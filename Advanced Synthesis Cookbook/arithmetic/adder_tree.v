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

module adder_tree (clk,in_words,out,extra_bit_in,extra_bit_out);

parameter NUM_IN_WORDS = 5;
parameter NUM_IN_PAIRS = NUM_IN_WORDS / 2;
parameter NUM_IN_ODD = NUM_IN_WORDS - NUM_IN_PAIRS * 2;
parameter BITS_PER_IN_WORD = 13;
parameter OUT_BITS = 29;	
parameter SIGN_EXT = 1;		// bool - sign vs 0 extend
parameter REGISTER_MIDDLE = 0;	// bool - register within adders or not
parameter REGISTER_OUTPUT = 1;	// bool - register adder outputs or not
parameter SHIFT_DIST = 1;	// for multiplication - a shift between words
parameter EXTRA_BIT_USED = 0; // extra bit to pass along the pipeline

// properties of the 1st layer output
// Guess the number of output bits, if the guess is more than
// the final requirement cap it.
parameter LAYER_OUT_WORDS = NUM_IN_PAIRS + NUM_IN_ODD;
parameter LAYER_OUT_EST_BITS = BITS_PER_IN_WORD + 1 + SHIFT_DIST;
parameter LAYER_OUT_BITS = (OUT_BITS < LAYER_OUT_EST_BITS) ? OUT_BITS : LAYER_OUT_EST_BITS;

input clk;
input extra_bit_in;
output extra_bit_out;

input [NUM_IN_WORDS*BITS_PER_IN_WORD-1:0] in_words;
output [OUT_BITS-1:0] out;

generate 
	if (NUM_IN_WORDS == 1) begin
		if (OUT_BITS > BITS_PER_IN_WORD) begin
			// the output needs to be extended more
			initial begin
				$display ("Excess output width not currently supported");
				$stop();
			end
		end
		
		// no more pipe, just tie off the wires and terminate recursion
		assign out = in_words;
		assign extra_bit_out = extra_bit_in;
	end
	else begin
		// knock out one horizontal slice of pairs
		wire [LAYER_OUT_WORDS*LAYER_OUT_BITS-1:0] layer_out;
		wire next_extra_bit;

		adder_tree_layer al (
			.clk(clk),
			.in_words(in_words),
			.out_words(layer_out),
			.extra_bit_in(extra_bit_in),
			.extra_bit_out(next_extra_bit)
		);
		defparam al .NUM_IN_WORDS = NUM_IN_WORDS;
		defparam al .BITS_PER_IN_WORD = BITS_PER_IN_WORD;
		defparam al .BITS_PER_OUT_WORD = LAYER_OUT_BITS;
		defparam al .SIGN_EXT = SIGN_EXT;
		defparam al .REGISTER_OUTPUT = REGISTER_OUTPUT;
		defparam al .REGISTER_MIDDLE = REGISTER_MIDDLE;
		defparam al .SHIFT = SHIFT_DIST;
		defparam al .EXTRA_BIT_CONNECTED = EXTRA_BIT_USED;
	
		// recurse on the remaining words 
		adder_tree at (
			.clk(clk),
			.in_words(layer_out),
			.out(out),
			.extra_bit_in(next_extra_bit),
			.extra_bit_out(extra_bit_out)
		);
		defparam at .NUM_IN_WORDS = LAYER_OUT_WORDS;
		defparam at .BITS_PER_IN_WORD = LAYER_OUT_BITS;
		defparam at .OUT_BITS = OUT_BITS;
		defparam at .SIGN_EXT = SIGN_EXT;
		defparam at .REGISTER_OUTPUT = REGISTER_OUTPUT;
		defparam at .REGISTER_MIDDLE = REGISTER_MIDDLE;
		defparam at .SHIFT_DIST = SHIFT_DIST * 2;
		defparam at .EXTRA_BIT_USED = EXTRA_BIT_USED;
	end
endgenerate

endmodule
