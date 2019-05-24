/*
  Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
  use of Altera Corporation's design tools, logic functions and other
  software and tools, and its AMPP partner logic functions, and any
  output files any of the foregoing (including device programming or
  simulation files), and any associated documentation or information are
  expressly subject to the terms and conditions of the Altera Program
  License Subscription Agreement or other applicable license agreement,
  including, without limitation, that your use is for the sole purpose
  of programming logic devices manufactured by Altera and sold by Altera
  or its authorized distributors.  Please refer to the applicable
  agreement for further details.
*/

/*

	Author:  JCJB
	Date:  11/04/2007
	
	This bursting write master is passed a word aligned address, length in bytes,
	and a 'go' bit.  The master will continue to post full length bursts until
	the length register reaches a value less than a full burst.  A single final
	burst is then posted when enough data has been buffered and then the done bit
	will be asserted. 

	To use this master you must simply drive the control signals into this block,
	and also write the data to the exposed write FIFO.  To read from the exposed FIFO
	use the 'user_write_buffer' signal to push data into the FIFO 'user_buffer_data'.
	The signal 'user_buffer_full' is asserted whenever the exposed buffer is full.
	You should not attempt to write data to the exposed FIFO if it is full.
	
*/

// altera message_off 10230


module burst_write_master (
	clk,
	reset,
	
	// control inputs and outputs
	control_fixed_location,
	control_write_base,
	control_write_length,
	control_go,
	control_done,
	
	// user logic inputs and outputs
	user_write_buffer,
	user_buffer_data,
	user_buffer_full,
	
	// master inputs and outputs
	master_address,
	master_write,
	master_byteenable,
	master_writedata,
	master_burstcount,
	master_waitrequest
);


	parameter DATAWIDTH = 32;
	parameter MAXBURSTCOUNT = 4;
	parameter BURSTCOUNTWIDTH = 3;
	parameter BYTEENABLEWIDTH = 4;
	parameter ADDRESSWIDTH = 32;
	parameter FIFODEPTH = 32;  // must be at least twice MAXBURSTCOUNT in order to be efficient
	parameter FIFODEPTH_LOG2 = 5;
	parameter FIFOUSEMEMORY = 1;  // set to 0 to use LEs instead
	
	
	
	input clk;
	input reset;
	
	// control inputs and outputs
	input control_fixed_location;  // this only makes sense to enable when MAXBURSTCOUNT = 1
	input [ADDRESSWIDTH-1:0] control_write_base;
	input [ADDRESSWIDTH-1:0] control_write_length;
	input control_go;
	output wire control_done;
	
	// user logic inputs and outputs
	input user_write_buffer;
	input [DATAWIDTH-1:0] user_buffer_data;
	output wire user_buffer_full;
	
	// master inputs and outputs
	input master_waitrequest;
	output reg [ADDRESSWIDTH-1:0] master_address;
	output wire master_write;
	output wire [BYTEENABLEWIDTH-1:0] master_byteenable;
	output wire [DATAWIDTH-1:0] master_writedata;
	output reg [BURSTCOUNTWIDTH-1:0] master_burstcount;
	
	// internal control signals
	reg control_fixed_location_d1;
	reg [ADDRESSWIDTH-1:0] length;
	wire final_short_burst_enable;  // when the length is less than MAXBURSTCOUNT * # of bytes per word (BYTEENABLEWIDTH) (i.e. end of the transfer)
	wire final_short_burst_ready;  // when there is enough data in the FIFO for the final burst
	wire [BURSTCOUNTWIDTH-1:0] burst_boundary_word_address;  // represents the word offset within the burst boundary
	wire [BURSTCOUNTWIDTH-1:0] first_short_burst_count;
	wire [BURSTCOUNTWIDTH-1:0] final_short_burst_count;
	wire first_short_burst_enable;  // when the transfer doesn't start on a burst boundary
	wire first_short_burst_ready;  // when there is enough data in the FIFO to get the master back into burst alignment
	wire full_burst_ready;  // when there is enough data in the FIFO for a full burst
	wire increment_address;  // this increments the 'address' register when write is asserted and waitrequest is de-asserted
	wire burst_begin;  // used to register the registers 'burst_address' and 'burst_count_d1' as well as drive the master_address and burst_count muxes
	wire read_fifo;
	wire [FIFODEPTH_LOG2-1:0] fifo_used;  // going to combined used with the full bit
	wire [BURSTCOUNTWIDTH-1:0] burst_count;  // watermark of the FIFO, it has a latency of 2 cycles
	reg [BURSTCOUNTWIDTH-1:0] burst_counter;
	reg first_transfer;  // need to keep track of the first burst so that we don't incorrectly increment the address



	// registering the control_fixed_location bit
	always @ (posedge clk or posedge reset)
	begin
		if (reset == 1)
		begin
			control_fixed_location_d1 <= 0;
		end
		else
		begin
			if (control_go == 1)
			begin
				control_fixed_location_d1 <= control_fixed_location;
			end
		end
	end


	// set when control_go fires, and reset once the first burst starts
	always @ (posedge clk or posedge reset)
	begin
		if (reset == 1)
		begin
			first_transfer <= 0;
		end
		else
		begin
			if (control_go == 1)
			begin
				first_transfer <= 1;
			end
			else if (burst_begin == 1)
			begin
				first_transfer <= 0;
			end
		end
	end


	// master address (held constant during burst)
	always @ (posedge clk or posedge reset)
	begin
		if (reset == 1)
		begin
			master_address <= 0;
		end
		else
		begin
			if (control_go == 1)
			begin
				master_address <= control_write_base;
			end
			else if ((first_transfer == 0) & (burst_begin == 1) & (control_fixed_location_d1 == 0))
			begin
				master_address <= master_address + (master_burstcount * BYTEENABLEWIDTH);  // we don't want address + BYTEENABLEWIDTH for the first access
			end
		end
	end	


	// master length logic
	always @ (posedge clk or posedge reset)
	begin
		if (reset == 1)
		begin
			length <= 0;
		end
		else
		begin
			if (control_go == 1)
			begin
				length <= control_write_length;
			end
			else if (increment_address == 1)
			begin
				length <= length - BYTEENABLEWIDTH;  // always performing word size accesses
			end
		end
	end


	
	// register the master burstcount (held constant during burst)
	always @ (posedge clk or posedge reset)
	begin
		if (reset == 1)
		begin
			master_burstcount <= 0;
		end
		else
		begin
			if (burst_begin == 1)
			begin
				master_burstcount <= burst_count;
			end
		end
	end



	// burst counter.  This is set to the burst count being posted then counts down when each word
	// of data goes out.  If it reaches 0 (i.e. not reloaded after 1) then the master stalls due to
	// a lack of data to post a new burst.
	always @ (posedge clk or posedge reset)
	begin
		if (reset == 1)
		begin
			burst_counter <= 0;
		end
		else
		begin
			if (control_go == 1)
			begin
				burst_counter <= 0;
			end
			else if (burst_begin == 1)
			begin
				burst_counter <= burst_count;
			end
			else if (increment_address == 1)  // decrements each write, burst_counter will only hit 0 if burst begin doesn't fire on the next cycle
			begin
				burst_counter <= burst_counter - 1;
			end
		end
	end




	// burst boundaries are on the master "width * maximum burst count".  The burst boundary word address will be used to determine how far off the boundary the transfer starts from.
	assign burst_boundary_word_address = ((master_address / BYTEENABLEWIDTH) & (MAXBURSTCOUNT - 1));	
	
	// first short burst enable will only be active on the first transfer (if applicable).  It will either post the amount of words remaining to reach the end of the burst
	// boundary or post the remainder of the transfer whichever is shorter.  If the transfer is very short and not aligned on a burst boundary then the same logic as the final short transfer is used
	assign first_short_burst_enable = (burst_boundary_word_address != 0) & (first_transfer == 1);
	assign first_short_burst_count = ((burst_boundary_word_address & 1'b1) == 1'b1)? 1 :  // if the burst boundary isn't a multiple of 2 then must post a burst of 1 to get to a multiple of 2 for the next burst
									(((MAXBURSTCOUNT - burst_boundary_word_address) < (length / BYTEENABLEWIDTH))?
									(MAXBURSTCOUNT - burst_boundary_word_address) : final_short_burst_count);
	assign first_short_burst_ready = (fifo_used > first_short_burst_count) | ((fifo_used == first_short_burst_count) & (burst_counter == 0));
	
	// when there isn't enough data for a full burst at the end of the transfer a short burst is sent out instead									
	assign final_short_burst_enable = (length < (MAXBURSTCOUNT * BYTEENABLEWIDTH));
	assign final_short_burst_count = (length/BYTEENABLEWIDTH);
	assign final_short_burst_ready = (fifo_used > final_short_burst_count) | ((fifo_used == final_short_burst_count) & (burst_counter == 0));  // this will add a one cycle stall between bursts, since fifo_used has a cycle of latency, this only affects the last burst

	// since the fifo has a latency of 1 we need to make sure we don't under flow
	assign full_burst_ready = (fifo_used > MAXBURSTCOUNT) |	((fifo_used == MAXBURSTCOUNT) & (burst_counter == 0));  // when fifo used watermark equals the burst count the statemachine must stall for one cycle, this will make sure that when a burst begins there really is enough data present in the FIFO


	assign master_byteenable = -1;  // all ones, always performing word size accesses
	assign control_done = (length == 0);
	assign master_write = (control_done == 0) & (burst_counter != 0);  // burst_counter = 0 means the transfer is done, or not enough data in the fifo for a new burst

	// fifo controls and the burst_begin responsible for timing most of the circuit, burst_begin starts the writing statemachine
	assign burst_begin = (((first_short_burst_enable == 1) & (first_short_burst_ready == 1))
						| ((final_short_burst_enable == 1) & (final_short_burst_ready == 1))
						| (full_burst_ready == 1))
						& (control_done == 0)  // since the FIFO can have data before the master starts we need to disable this bit from firing when length = 0
						& ((burst_counter == 0) | ((burst_counter == 1) & (master_waitrequest == 0) & (length > (MAXBURSTCOUNT * BYTEENABLEWIDTH))));  // need to make a short final burst doesn't start right after a full burst completes.

	assign burst_count = (first_short_burst_enable == 1)? first_short_burst_count :  // alignment correction gets priority, if the transfer is short and unaligned this will cover both
						(final_short_burst_enable == 1)? final_short_burst_count : MAXBURSTCOUNT; 

	assign increment_address = (master_write == 1) & (master_waitrequest == 0);  // writing is occuring without wait states
	assign read_fifo = increment_address;



	// write data feed by user logic
	scfifo the_user_to_master_fifo (
		.aclr (reset),
		.usedw (fifo_used),
		.clock (clk),
		.data (user_buffer_data),
		.almost_full (user_buffer_full),
		.q (master_writedata),
		.rdreq (read_fifo),
		.wrreq (user_write_buffer)
	);
	defparam the_user_to_master_fifo.lpm_width = DATAWIDTH;
	defparam the_user_to_master_fifo.lpm_numwords = FIFODEPTH;
	defparam the_user_to_master_fifo.lpm_showahead = "ON";
	defparam the_user_to_master_fifo.almost_full_value = (FIFODEPTH - 2);
	defparam the_user_to_master_fifo.use_eab = (FIFOUSEMEMORY == 1)? "ON" : "OFF";
	defparam the_user_to_master_fifo.add_ram_output_register = "OFF";  // makes timing the burst begin single simplier
	defparam the_user_to_master_fifo.underflow_checking = "OFF";
	defparam the_user_to_master_fifo.overflow_checking = "OFF";

endmodule
