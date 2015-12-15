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

// baeckler -01-02-2007
module lc_mult_signed (clk,a,b,o);

parameter WIDTH_A = 16;
parameter WIDTH_B = 13;
parameter WIDTH_O = WIDTH_A + WIDTH_B;
parameter REGISTER_LAYERS = 1;
parameter REGISTER_MIDPOINTS = 1;

/////////////////////////////////////
// these are just for sanity - to 
// display the actual latency in 
// simulation.
/////////////////////////////////////
function integer layer_latency;
	input integer words;
	begin
		layer_latency = 2;
		while (words > 1) begin
			words = (words/2) + (words - (2*(words/2)));
			layer_latency = layer_latency + 1;
		end
	end
endfunction

function integer midpoint_latency;
	input integer words;
	begin
		midpoint_latency = 0;
		while (words > 1) begin
			words = (words/2) + (words - (2*(words/2)));
			midpoint_latency = midpoint_latency + 1;
		end
	end
endfunction

input clk;
input [WIDTH_A-1:0] a;
input [WIDTH_B-1:0] b;
output [WIDTH_O-1:0] o;

wire b_negative = b[WIDTH_B-1];
wire [WIDTH_O-1:0] o_wire;
reg [WIDTH_O-1:0] o;

genvar i;
wire [WIDTH_B * WIDTH_A - 1:0] partials;

// report the latency in simulation
generate
	if (REGISTER_LAYERS) begin
		initial begin 
			$display ("lc_mult_signed layer latency for WIDTH_B=%d is %d",
				WIDTH_B,layer_latency(WIDTH_B));
		end
	end
	if (REGISTER_MIDPOINTS) begin
		initial begin 
			$display ("lc_mult_signed midpoint latency for WIDTH_B=%d is %d",
				WIDTH_B,midpoint_latency(WIDTH_B));
		end
	end
endgenerate

/////////////////////////////////////
// Construct the partial products
/////////////////////////////////////

// for all but the last word do simple AND gates
generate 
	for (i=0; i<(WIDTH_B-1); i=i+1) 
	begin : ps
		assign partials[i*WIDTH_A+WIDTH_A-1:i*WIDTH_A] = a & {WIDTH_A{b[i]}};
	end	
endgenerate

// for the last word and with !A
// this is analagous to B and (B xor A)
assign partials[WIDTH_B*WIDTH_A-1:WIDTH_B*WIDTH_A-WIDTH_A] = ~a & {WIDTH_A{b[WIDTH_B-1]}};

reg [WIDTH_B * WIDTH_A - 1:0] partials_r;
reg b_negative_r;
generate
	if (REGISTER_LAYERS) begin
		always @(posedge clk) begin
			partials_r <= partials;
			b_negative_r <= b_negative;
		end
	end
	else begin
		always @(*) begin
			partials_r = partials;
			b_negative_r <= b_negative;
		end
	end
endgenerate

/////////////////////////////////////
// Sum the partial products
/////////////////////////////////////
wire [WIDTH_O-1:0] sum;
wire b_negative_final;
adder_tree at (.clk(clk),
		.in_words(partials_r),
		.extra_bit_in(b_negative_r),
		.extra_bit_out(b_negative_final),
		.out(sum));
	defparam at .NUM_IN_WORDS = WIDTH_B;
	defparam at .BITS_PER_IN_WORD = WIDTH_A;
	defparam at .OUT_BITS = WIDTH_O;
	defparam at .SIGN_EXT = 1;
	defparam at .REGISTER_OUTPUT = REGISTER_LAYERS;
	defparam at .REGISTER_MIDDLE = REGISTER_MIDPOINTS;
	defparam at .SHIFT_DIST = 1;
	defparam at .EXTRA_BIT_USED = 1;

/////////////////////////////////////
// final signed correction
/////////////////////////////////////
assign o_wire = sum + (b_negative_final << (WIDTH_B-1));

/////////////////////////////////////
// optional output registers
/////////////////////////////////////
generate
	if (REGISTER_LAYERS) begin
		always @(posedge clk) begin
			o <= o_wire;
		end
	end
	else begin
		always @(*) begin
			o = o_wire;
		end
	end
endgenerate

endmodule

