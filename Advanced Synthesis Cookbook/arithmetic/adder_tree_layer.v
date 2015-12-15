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
// a horizontal slice of an adder tree

module adder_tree_layer (clk,in_words,out_words,extra_bit_in,extra_bit_out);

parameter NUM_IN_WORDS = 5;
parameter NUM_IN_PAIRS = NUM_IN_WORDS / 2;
parameter NUM_IN_ODD = NUM_IN_WORDS - NUM_IN_PAIRS * 2;
parameter NUM_OUT_WORDS = NUM_IN_PAIRS + NUM_IN_ODD;

parameter BITS_PER_IN_WORD = 16;
parameter BITS_PER_OUT_WORD = 17;
parameter SIGN_EXT = 1;
parameter REGISTER_MIDDLE = 0;
parameter REGISTER_OUTPUT = 1;
parameter SHIFT = 1;	// apply to odd numbered words

parameter EXTRA_BIT_CONNECTED = 0; // pass extra bit along pipeline

input clk;
input [NUM_IN_WORDS * BITS_PER_IN_WORD - 1 : 0] in_words;
output [NUM_OUT_WORDS * BITS_PER_OUT_WORD -1 :0] out_words;
input extra_bit_in;
output extra_bit_out;
reg extra_bit_m,extra_bit_out;

genvar i;
generate
	if (EXTRA_BIT_CONNECTED) begin
		if (REGISTER_MIDDLE) begin
			always @(posedge clk) extra_bit_m <= extra_bit_in;
		end
		else begin
			always @(*) extra_bit_m = extra_bit_in;
		end
		if (REGISTER_OUTPUT) begin
			always @(posedge clk) extra_bit_out <= extra_bit_m;
		end
		else begin
			always @(*) extra_bit_out = extra_bit_m;
		end
	end
	else begin
		always @(*) extra_bit_out = 1'b0;
	end
		
	// process the pairs as binary adder nodes with optional pipeline
	for (i=0; i<NUM_IN_PAIRS; i=i+1)
	begin : ad
		wire [2*BITS_PER_IN_WORD-1:0] node_ins;
		assign node_ins = in_words[2*(i+1)*BITS_PER_IN_WORD-1:
									2*i*BITS_PER_IN_WORD];
		adder_tree_node an (
			.clk(clk),
			.a(node_ins[BITS_PER_IN_WORD-1:0]),
			.b(node_ins[2*BITS_PER_IN_WORD-1:BITS_PER_IN_WORD]),
			.out(out_words[(i+1)*BITS_PER_OUT_WORD-1:
						i*BITS_PER_OUT_WORD]));
			defparam an .IN_BITS = BITS_PER_IN_WORD;
			defparam an .OUT_BITS = BITS_PER_OUT_WORD;
			defparam an .SIGN_EXT = SIGN_EXT;
			defparam an .REGISTER_OUTPUT = REGISTER_OUTPUT;
			defparam an .REGISTER_MIDDLE = REGISTER_MIDDLE;
			defparam an .B_SHIFT = SHIFT;
	end
	
	// process any odd fall-through words
	if (NUM_IN_ODD) begin	
		// treat this like a +0 to maintain the sign extension
		// and pipeline behavior with minimum fuss
		adder_tree_node an (
			.clk(clk),
			.a(in_words[BITS_PER_IN_WORD*NUM_IN_WORDS-1:
					BITS_PER_IN_WORD*(NUM_IN_WORDS-1)]),
			.b({BITS_PER_IN_WORD{1'b0}}),
			.out(out_words[(NUM_IN_PAIRS+1)*BITS_PER_OUT_WORD-1:
						NUM_IN_PAIRS*BITS_PER_OUT_WORD]));
			defparam an .IN_BITS = BITS_PER_IN_WORD;
			defparam an .OUT_BITS = BITS_PER_OUT_WORD;
			defparam an .SIGN_EXT = SIGN_EXT;
			defparam an .REGISTER_OUTPUT = REGISTER_OUTPUT;
			defparam an .REGISTER_MIDDLE = REGISTER_MIDDLE;
			defparam an .B_SHIFT = SHIFT;
		
	end
endgenerate

endmodule