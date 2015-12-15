// Copyright 2010 Altera Corporation. All rights reserved.  
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

`timescale 1 ps / 1 ps
// baeckler - 12-05-2009
// one MLAB memory with support registers

module mlab_fifo_cells (
	input din_clk,
	input [19:0] din,
	input we,
	input [4:0] wraddr,
	
	input dout_clk,
	input [4:0] rdaddr,
	output [19:0] dout,
	input parity_err_in,
	output parity_err_out	
);

localparam BIT_WIDTH=20;
localparam ADDR_WIDTH = 5;
localparam DEPTH = 1 << ADDR_WIDTH;


///////////////////////////
// input registers
///////////////////////////

reg [BIT_WIDTH-1:0] din_reg = 0 /* synthesis preserve */;
reg [BIT_WIDTH-1:0] din2_reg = 0 /* synthesis preserve */;
reg [ADDR_WIDTH-1:0] wraddr_reg = 0 /* synthesis preserve */;
reg [ADDR_WIDTH-1:0] wraddr2_reg = 0 /* synthesis preserve */;
reg we_reg = 0 /* synthesis preserve */;

always @(posedge din_clk) begin
	din_reg <= din;		
	din2_reg <= din_reg;		
	wraddr_reg <= wraddr;
	wraddr2_reg <= wraddr_reg;
	we_reg <= we;
end

///////////////////////////
// storage array - doesn't seem to work with direct 20 wide, need "for"
///////////////////////////

wire [BIT_WIDTH-1:0] dout_wire;
genvar i;
generate
	for (i=0; i<BIT_WIDTH; i=i+1)  begin : ml
		stratixiv_mlab_cell lrm (
			.clk0(din_clk),
			.ena0(we_reg),
			.portabyteenamasks(1'b1),
			.portadatain(din2_reg[i]),
			.portaaddr(wraddr2_reg),
			.portbaddr(rdaddr),
			.portbdataout(dout_wire[i])
		);
		
		//defparam lrm .mixed_port_feed_through_mode = "new";
		defparam lrm .mixed_port_feed_through_mode = "dont_care";
		
		defparam lrm .logical_ram_name = "lrmi";
		defparam lrm .logical_ram_depth = DEPTH;
		defparam lrm .logical_ram_width = BIT_WIDTH;
		defparam lrm .first_address = 0;
		defparam lrm .last_address = DEPTH-1;
		defparam lrm .first_bit_number = i;
		defparam lrm .data_width = 1;
		defparam lrm .address_width = ADDR_WIDTH;
	end
endgenerate



///////////////////////////
// parity check
///////////////////////////

reg [BIT_WIDTH-1:0] dout_reg = 0 /* synthesis preserve */;


wire [3:0] pxor /* synthesis keep */;
assign pxor[0] = ^dout_reg [5:0];
assign pxor[1] = (^dout_reg [9:6] ^ pxor[0]) & !parity_err_in;
assign pxor[2] = ^dout_reg [15:10];
assign pxor[3] = (^dout_reg [19:16] ^ pxor[2]) & pxor[1];

///////////////////////////
// output registers
///////////////////////////

reg parity_err_reg = 0 /* synthesis preserve */;

always @(posedge dout_clk) begin
	dout_reg <= dout_wire;			
	parity_err_reg <= !pxor[3];
end
assign dout = dout_reg;
assign parity_err_out = parity_err_reg;

///////////////////////////
// debug
///////////////////////////

localparam DEBUG_MSGS = 0;
generate
	if (DEBUG_MSGS) begin
			
		// synthesis translate off
		reg go_write = 1'b0;
		always @(posedge din_clk) begin
			go_write <= we_reg;	
		end

		always @(negedge din_clk) begin
			if (go_write) begin
				$display ("Write %x to addr %x",din2_reg,wraddr2_reg);
			end
		end
		// synthesis translate on
	end
endgenerate

endmodule

