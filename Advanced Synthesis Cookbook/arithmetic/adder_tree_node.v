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

// baeckler - 01-02-2007
// a relatively fancy adder tree node

module adder_tree_node (clk,a,b,out);

parameter IN_BITS = 16;
parameter OUT_BITS = 17;
parameter SIGN_EXT = 1;
parameter REGISTER_MIDDLE = 0;  // register within adder chains
parameter REGISTER_OUTPUT = 1;	// register adder outputs
parameter B_SHIFT = 1;

// for the placement of the midway pipeline registers
localparam LS_WIDTH = OUT_BITS / 2;
localparam MS_WIDTH = OUT_BITS - LS_WIDTH;

input clk;
input [IN_BITS-1:0] a,b;
output [OUT_BITS-1:0] out;

// sign extension
wire [OUT_BITS-1:0] a_ext,b_ext;
generate
	if (SIGN_EXT) begin
		assign a_ext = {{(OUT_BITS-IN_BITS){a[IN_BITS-1]}},a};
		assign b_ext = {{(OUT_BITS-IN_BITS){b[IN_BITS-1]}},b};
	end
	else begin
		assign a_ext = {{(OUT_BITS-IN_BITS){1'b0}},a};
		assign b_ext = {{(OUT_BITS-IN_BITS){1'b0}},b};
	end
endgenerate

// offset B
wire [OUT_BITS-1:0] b_ext_shft;
assign b_ext_shft = b_ext << B_SHIFT;

// addition
wire [OUT_BITS-1:0] sum;
generate
	if (REGISTER_MIDDLE) begin

		// pipeline in the middle of the adder chain
		reg [LS_WIDTH-1+1:0] ls_adder;
		wire cross_carry = ls_adder[LS_WIDTH];
		always @(posedge clk) begin
			ls_adder <= {1'b0,a_ext[LS_WIDTH-1:0]} + {1'b0,b_ext_shft[LS_WIDTH-1:0]};
		end

		reg [MS_WIDTH-1:0] ms_data_a,ms_data_b;
		always @(posedge clk) begin
			ms_data_a <= a_ext[OUT_BITS-1:OUT_BITS-MS_WIDTH];
			ms_data_b <= b_ext_shft[OUT_BITS-1:OUT_BITS-MS_WIDTH];
		end

		wire [MS_WIDTH-1+1:0] ms_adder;
		assign ms_adder = {ms_data_a,cross_carry} + 
				{ms_data_b,cross_carry};

		assign sum = {ms_adder[MS_WIDTH:1],ls_adder[LS_WIDTH-1:0]};
	end
	else begin
		// simple addition
		assign sum = a_ext + b_ext_shft;
	end
endgenerate

// optional output register
reg [OUT_BITS-1:0] out;
generate 
	if (REGISTER_OUTPUT) begin
		always @(posedge clk) begin
			out <= sum;	
		end
	end
	else begin
		always @(*) begin
			out = sum;	
		end	
	end
endgenerate

endmodule