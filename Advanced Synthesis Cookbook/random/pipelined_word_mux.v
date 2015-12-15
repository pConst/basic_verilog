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

// baeckler - 05-07-2007

///////////////////////////////////////////
// word MUX with registered output

module reg_word_mux (clk,rst,ena,sel,din,dout);
parameter WORD_LEN = 32; 
parameter NUM_SEL = 2;
parameter NUM_WORDS_IN = 1 << NUM_SEL;

input clk,rst,ena;
input [NUM_SEL-1:0] sel;
input [WORD_LEN*NUM_WORDS_IN-1:0] din;
output [WORD_LEN-1:0] dout;

wire [WORD_LEN-1:0] dout_c;
reg [WORD_LEN-1:0] dout;

genvar i,j;
generate
	for (i=0; i<WORD_LEN; i=i+1) 
	begin : out_bits
		wire [NUM_WORDS_IN-1:0] tmp_dat;
		for (j = 0; j<NUM_WORDS_IN; j=j+1) 
		begin : dat_bits
			assign tmp_dat[j] = din[i+j*WORD_LEN];
		end
		assign dout_c[i] = tmp_dat[sel];
	end
endgenerate

always @(posedge clk) begin
	if (ena) begin
		if (rst) dout <= 0;
		else dout <= dout_c;
	end
end
endmodule

///////////////////////////////////////////
// Horizontal pipeline layer of N word MUXes

module reg_word_mux_layer (clk,rst,ena,sel,din,dout);

parameter WORD_LEN = 32;
parameter NUM_WORDS_IN = 32; // power of 2
parameter NUM_SEL = 2;
parameter N_TO_1 = 1 << NUM_SEL;
parameter NUM_WORDS_OUT = NUM_WORDS_IN >> NUM_SEL;

input clk,rst,ena;
input [NUM_SEL-1:0] sel;
input [WORD_LEN * NUM_WORDS_IN-1 : 0] din;
output [WORD_LEN*NUM_WORDS_OUT-1:0] dout;

genvar i;
generate
	for (i=0; i<NUM_WORDS_OUT; i=i+1) 
	begin : mx_r
		reg_word_mux r (
			.clk(clk),.rst(rst),.ena(ena),
			.sel(sel),
			.din(din[WORD_LEN*N_TO_1*(i+1)-1:WORD_LEN*N_TO_1*i]),
			.dout(dout[WORD_LEN*i+WORD_LEN-1:WORD_LEN*i])
		);			
		defparam r .NUM_SEL = NUM_SEL;
		defparam r .WORD_LEN = WORD_LEN;
	end
endgenerate
endmodule

///////////////////////////////////////////
// Pipelined word (bus) MUX
//    din = {word3, word2, word1, word0}, etc.
//    sel = 2'b01 = dout<=word1
// 
module pipelined_word_mux (clk,rst,ena,sel,din,dout);

`include "log2.inc"

parameter WORD_LEN = 32;
parameter NUM_WORDS_IN = 16;		// power of 2
parameter SEL_PER_LAYER = 2;		// output layer may be less
parameter BALANCE_SELECTS = 1'b1;	// adjust select latency to follow data?
parameter NUM_SEL = ((NUM_WORDS_IN <= 1) ? 1 : log2(NUM_WORDS_IN-1));

input clk,rst,ena;
input [NUM_SEL-1:0] sel;
input [WORD_LEN*NUM_WORDS_IN-1:0] din;
output [WORD_LEN-1:0] dout;

genvar i;
generate 
	if (NUM_SEL >= SEL_PER_LAYER) begin
		// knock out a full leaf layer		
		wire [(NUM_WORDS_IN >> SEL_PER_LAYER)*WORD_LEN-1:0] layer_dout;
		reg_word_mux_layer lyr (
				.clk(clk),.rst(rst),.ena(ena),
				.sel(sel[SEL_PER_LAYER-1:0]),
				.din(din),
				.dout(layer_dout));
			defparam lyr .WORD_LEN = WORD_LEN;
			defparam lyr .NUM_WORDS_IN = NUM_WORDS_IN;
			defparam lyr .NUM_SEL = SEL_PER_LAYER;
	
		// deal with the select latency if it needs
		// to be balanced with the data
		reg [((NUM_SEL > SEL_PER_LAYER) ? 
				(NUM_SEL-(1+SEL_PER_LAYER)) :
				0):0] next_sel;
		
		if (NUM_SEL > SEL_PER_LAYER) begin
			// some selects survive to next layer
			if (BALANCE_SELECTS) begin
				always @(posedge clk) begin
					if (ena) begin
						if (rst) next_sel <= 0;
						else next_sel <= sel [NUM_SEL-1:SEL_PER_LAYER];
					end
				end
			end
			else begin
				always @(*) next_sel = sel[NUM_SEL-1:SEL_PER_LAYER];
			end
		end
		else begin
			// all selects used - dummy
			always @(*) next_sel = 0;
		end			
		
		// recurse on smaller problem
		pipelined_word_mux pp (
				.clk(clk),.rst(rst),.ena(ena),
				.sel(next_sel),
				.din(layer_dout),
				.dout(dout));
			defparam pp .WORD_LEN = WORD_LEN;
			defparam pp .NUM_WORDS_IN = NUM_WORDS_IN >> SEL_PER_LAYER;
			defparam pp .SEL_PER_LAYER = SEL_PER_LAYER;
			defparam pp .BALANCE_SELECTS = BALANCE_SELECTS;
	end
	else if (NUM_WORDS_IN > 1) begin
		// Final mux isn't the full size
		reg_word_mux_layer lyr (
				.clk(clk),.rst(rst),.ena(ena),
				.sel(sel),
				.din(din),
				.dout(dout));
			defparam lyr .WORD_LEN = WORD_LEN;
			defparam lyr .NUM_WORDS_IN = NUM_WORDS_IN;
			defparam lyr .NUM_SEL = NUM_SEL;
	end
	else begin
		// last word
		assign dout = din;
	end
endgenerate

endmodule
