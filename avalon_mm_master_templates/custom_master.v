/*
This file is a simple top level that will generate one of four types of
Avalon-MM master.  As a result all the ports must be declared and it will be
up to the component .tcl file to stub unused signals.
*/

// altera message_off 10034

module custom_master (
	clk,
	reset,

	// control inputs and outputs
	control_fixed_location,
	control_read_base,
	control_read_length,
	control_write_base,
	control_write_length,
	control_go,
	control_done,
	control_early_done,
	
	// user logic inputs and outputs
	user_read_buffer,
	user_write_buffer,
	user_buffer_input_data,
	user_buffer_output_data,
	user_data_available,
	user_buffer_full,
	
	// master inputs and outputs
	master_address,
	master_read,
	master_write,
	master_byteenable,
	master_readdata,
	master_readdatavalid,
	master_writedata,
	master_burstcount,
	master_waitrequest
);

	parameter MASTER_DIRECTION = 0;							// 0 for read master, 1 for write master
	parameter DATA_WIDTH = 32;
	parameter MEMORY_BASED_FIFO = 1;						// 0 for LE/ALUT FIFOs, 1 for memory FIFOs (highly recommend 1)
	parameter FIFO_DEPTH = 32;
	parameter FIFO_DEPTH_LOG2 = 5;
	parameter ADDRESS_WIDTH = 32;
	parameter BURST_CAPABLE = 0;							// 1 to enable burst, 0 to disable it
	parameter MAXIMUM_BURST_COUNT = 2;
	parameter BURST_COUNT_WIDTH = 2;


	input clk;
	input reset;

	// control inputs and outputs
	input control_fixed_location;
	input [ADDRESS_WIDTH-1:0] control_read_base;			// for read master
	input [ADDRESS_WIDTH-1:0] control_read_length;			// for read master
	input [ADDRESS_WIDTH-1:0] control_write_base;			// for write master
	input [ADDRESS_WIDTH-1:0] control_write_length;			// for write master
	input control_go;
	output wire control_done;
	output wire control_early_done;							// for read master
	
	// user logic inputs and outputs
	input user_read_buffer;									// for read master
	input user_write_buffer;								// for write master
	input [DATA_WIDTH-1:0] user_buffer_input_data;			// for write master
	output wire [DATA_WIDTH-1:0] user_buffer_output_data;	// for read master
	output wire user_data_available;						// for read master
	output wire user_buffer_full;							// for write master
	
	// master inputs and outputs
	output wire [ADDRESS_WIDTH-1:0] master_address;
	output wire master_read;								// for read master
	output wire master_write;								// for write master
	output wire [(DATA_WIDTH/8)-1:0] master_byteenable;
	input [DATA_WIDTH-1:0] master_readdata;					// for read master
	input master_readdatavalid;								// for read master
	output wire [DATA_WIDTH-1:0] master_writedata;			// for write master
	output wire [BURST_COUNT_WIDTH-1:0] master_burstcount;	// for bursting read and write masters
	input master_waitrequest;


generate  // big generate if statement to select the approprate master depending on the direction and burst parameters
if(MASTER_DIRECTION == 0)
begin
	if(BURST_CAPABLE == 1)
	begin
		burst_read_master a_burst_read_master(
			.clk (clk),
			.reset (reset),
			.control_fixed_location (control_fixed_location),
			.control_read_base (control_read_base),
			.control_read_length (control_read_length),
			.control_go (control_go),
			.control_done (control_done),
			.control_early_done (control_early_done),
			.user_read_buffer (user_read_buffer),
			.user_buffer_data (user_buffer_output_data),
			.user_data_available (user_data_available),
			.master_address (master_address),
			.master_read (master_read),
			.master_byteenable (master_byteenable),
			.master_readdata (master_readdata),
			.master_readdatavalid (master_readdatavalid),
			.master_burstcount (master_burstcount),
			.master_waitrequest (master_waitrequest)
		);
		defparam a_burst_read_master.DATAWIDTH = DATA_WIDTH;
		defparam a_burst_read_master.MAXBURSTCOUNT = MAXIMUM_BURST_COUNT;
		defparam a_burst_read_master.BURSTCOUNTWIDTH = BURST_COUNT_WIDTH;
		defparam a_burst_read_master.BYTEENABLEWIDTH = DATA_WIDTH/8;
		defparam a_burst_read_master.ADDRESSWIDTH = ADDRESS_WIDTH;
		defparam a_burst_read_master.FIFODEPTH = FIFO_DEPTH;
		defparam a_burst_read_master.FIFODEPTH_LOG2 = FIFO_DEPTH_LOG2;
		defparam a_burst_read_master.FIFOUSEMEMORY = MEMORY_BASED_FIFO;
	end
	else
	begin
		latency_aware_read_master a_latency_aware_read_master(
			.clk (clk),
			.reset (reset),
			.control_fixed_location (control_fixed_location),
			.control_read_base (control_read_base),
			.control_read_length (control_read_length),
			.control_go (control_go),
			.control_done (control_done),
			.control_early_done (control_early_done),
			.user_read_buffer (user_read_buffer),
			.user_buffer_data (user_buffer_output_data),
			.user_data_available (user_data_available),
			.master_address (master_address),
			.master_read (master_read),
			.master_byteenable (master_byteenable),
			.master_readdata (master_readdata),
			.master_readdatavalid (master_readdatavalid),
			.master_waitrequest (master_waitrequest)
		);
		defparam a_latency_aware_read_master.DATAWIDTH = DATA_WIDTH;
		defparam a_latency_aware_read_master.BYTEENABLEWIDTH = DATA_WIDTH/8;
		defparam a_latency_aware_read_master.ADDRESSWIDTH = ADDRESS_WIDTH;
		defparam a_latency_aware_read_master.FIFODEPTH = FIFO_DEPTH;
		defparam a_latency_aware_read_master.FIFODEPTH_LOG2 = FIFO_DEPTH_LOG2;
		defparam a_latency_aware_read_master.FIFOUSEMEMORY = MEMORY_BASED_FIFO;
	end
end
else
begin
	if(BURST_CAPABLE == 1)
	begin
		burst_write_master a_burst_write_master(
			.clk (clk),
			.reset (reset),
			.control_fixed_location (control_fixed_location),
			.control_write_base (control_write_base),
			.control_write_length (control_write_length),
			.control_go (control_go),
			.control_done (control_done),
			.user_write_buffer (user_write_buffer),
			.user_buffer_data (user_buffer_input_data),
			.user_buffer_full (user_buffer_full),
			.master_address (master_address),
			.master_write (master_write),
			.master_byteenable (master_byteenable),
			.master_writedata (master_writedata),
			.master_burstcount (master_burstcount),
			.master_waitrequest (master_waitrequest)
		);
		defparam a_burst_write_master.DATAWIDTH = DATA_WIDTH;
		defparam a_burst_write_master.MAXBURSTCOUNT = MAXIMUM_BURST_COUNT;
		defparam a_burst_write_master.BURSTCOUNTWIDTH = BURST_COUNT_WIDTH;
		defparam a_burst_write_master.BYTEENABLEWIDTH = DATA_WIDTH/8;
		defparam a_burst_write_master.ADDRESSWIDTH = ADDRESS_WIDTH;
		defparam a_burst_write_master.FIFODEPTH = FIFO_DEPTH;
		defparam a_burst_write_master.FIFODEPTH_LOG2 = FIFO_DEPTH_LOG2;
		defparam a_burst_write_master.FIFOUSEMEMORY = MEMORY_BASED_FIFO;
	end
	else
	begin
		write_master a_write_master(
			.clk (clk),
			.reset (reset),
			.control_fixed_location (control_fixed_location),
			.control_write_base (control_write_base),
			.control_write_length (control_write_length),
			.control_go (control_go),
			.control_done (control_done),
			.user_write_buffer (user_write_buffer),
			.user_buffer_data (user_buffer_input_data),
			.user_buffer_full (user_buffer_full),
			.master_address (master_address),
			.master_write (master_write),
			.master_byteenable (master_byteenable),
			.master_writedata (master_writedata),
			.master_waitrequest (master_waitrequest)
		);
		defparam a_write_master.DATAWIDTH = DATA_WIDTH;
		defparam a_write_master.BYTEENABLEWIDTH = DATA_WIDTH/8;
		defparam a_write_master.ADDRESSWIDTH = ADDRESS_WIDTH;
		defparam a_write_master.FIFODEPTH = FIFO_DEPTH;
		defparam a_write_master.FIFODEPTH_LOG2 = FIFO_DEPTH_LOG2;
		defparam a_write_master.FIFOUSEMEMORY = MEMORY_BASED_FIFO;
	end
end
endgenerate


endmodule
