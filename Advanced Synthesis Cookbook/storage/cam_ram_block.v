// Copyright 2007 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

// baeckler - 08-24-2007
// 
// Memory and tiny state machine to implement ternary CAM.  
// Intended for stitching to build larger CAMs
// 
// RAM is addressed by data bits, the stored content represents
// one hot coded address lines,  eg. data 0 = 110 means data 0
// matches addresses 1 and 2.
//
// The state machine handles don't cares, writing a new value 
// takes approximately 128 ticks (blocking), as the machine 
// iterates the data to see which slots match the don't care mask.
//
// Lookup is pipelined, at the RAM latency of 2
//

module cam_ram_block (
	clk,rst,
	waddr,wdata,wcare,start_write,ready,
	lookup_data,match_lines
);

// data 7 addr 5 produces 2^7 words of 2^5 bits
//   natural for a SII 4K RAM block
parameter DATA_WIDTH = 7;
parameter ADDR_WIDTH = 5;
parameter WORDS = (1<<ADDR_WIDTH);

input clk,rst,start_write;
input [ADDR_WIDTH-1:0] waddr;
input [DATA_WIDTH-1:0] wdata,wcare;

input [DATA_WIDTH-1:0] lookup_data;
output [WORDS-1:0] match_lines;
wire [WORDS-1:0] match_lines;
output ready;
reg ready;

reg [WORDS-1:0] waddr_dec;
always @(*) begin
	waddr_dec = 0;
	waddr_dec[waddr] = 1'b1;
end

//////////////////////////////////////
// RAM address pointer
//////////////////////////////////////
	reg rst_ptr;
	reg [DATA_WIDTH-1:0] addr_ptr,last_addr_ptr,last2_addr_ptr;
	reg ptr_max;

	always @(posedge clk) begin
		if (rst_ptr) begin
			ptr_max <= 1'b0;
			addr_ptr <= 0;
		end
		else begin
			if (addr_ptr == {{DATA_WIDTH-1{1'b1}},1'b0})
				ptr_max <= 1'b1;
			addr_ptr <= addr_ptr + 1'b1;
		end
	end

	always @(posedge clk) begin
		last_addr_ptr <= addr_ptr;
		last2_addr_ptr <= last_addr_ptr;
	end

//////////////////////////////////////
// storage table
//////////////////////////////////////
	wire [DATA_WIDTH-1:0] ram_raddr, ram_waddr;
	reg ram_we;
	wire [WORDS-1:0] ram_data, ram_match_lines;

	ram_block storage (
		.clk(clk),
		.data(ram_data),
		.rdaddress(ram_raddr),
		.wraddress(ram_waddr),
		.wren(ram_we),
		.q(ram_match_lines)
	);

	defparam storage .DAT_WIDTH = WORDS;
	defparam storage .ADDR_WIDTH = DATA_WIDTH;

	reg ram_addr_select, zero_ram_data;
	
	assign ram_raddr = ram_addr_select ? addr_ptr : lookup_data;
	assign ram_waddr = zero_ram_data ? addr_ptr : last2_addr_ptr;
	assign ram_data = (~{WORDS{zero_ram_data}}) &
			(waddr_dec | ram_match_lines);
	assign match_lines = ram_match_lines;

//////////////////////////////////////
// decide to write at this data 
//   location or not, with dont care
//////////////////////////////////////
reg write_here;
reg [DATA_WIDTH-1:0] bit_match;

	always @(posedge clk) begin
		bit_match <= ~wcare | ~(wdata ^ addr_ptr);
		write_here <= &bit_match;
	end

//////////////////////////////////////
// control
//////////////////////////////////////
parameter INIT = 0, WIPE = 1, READY = 2, WRITE_A = 3,
		WRITE_B = 4, WRITE_C = 5, WRITE_D = 6;

reg [3:0] state,next_state;

	always @(*) begin
		rst_ptr = 1'b0;
		ram_we = 1'b0;
		ram_addr_select = 1'b1;
		next_state = state;
		ready = 1'b0;
		zero_ram_data = 1'b0;

		case (state)
			INIT : begin
					rst_ptr = 1'b1;
					next_state = WIPE;
				end
			WIPE : begin
					ram_we = 1'b1;
					zero_ram_data = 1'b1;
					if (ptr_max) begin
						next_state = READY;
						rst_ptr = 1'b1;
					end
				end
			READY : begin
					ready = 1'b1;
					ram_addr_select = 1'b0;
					rst_ptr = 1'b1;
					if (start_write) begin
						next_state = WRITE_A;						
						rst_ptr = 1'b0;
					end
				end
			WRITE_A : begin
					next_state = WRITE_B;
				end
			WRITE_B : begin
					ram_we = write_here;
					if (ptr_max) begin
						next_state = WRITE_C;
					end
				end
			WRITE_C : begin
					ram_we = write_here;
					next_state = WRITE_D;
				end
			WRITE_D : begin
					ram_we = write_here;
					next_state = READY;					
					rst_ptr = 1'b1;
				end
		endcase
	end

	always @(posedge clk) begin
		if (rst) state <= INIT;
		else state <= next_state;		
	end

endmodule
