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

module pipelined_word_mux_tb ();

`include "log2.inc"

parameter WORD_LEN = 16;
parameter NUM_WORDS_IN = 32;		// power of 2
parameter SEL_PER_LAYER = 2;		// output layer may be less
parameter LATENCY = 3;

// Quick test cases -
//
// 16 words, 2 sel per layer, latency is 2
// 32 words, 2 sel per layer, latency is 3
// 64 words, 2 sel per layer, latency is 3
// 64 words, 3 sel per layer, latency is 2


parameter NUM_SEL = log2(NUM_WORDS_IN-1);
parameter BALANCE_SELECTS = 1'b1;	// adjust select latency to follow data?

reg clk,rst;
reg [NUM_SEL-1:0] sel;
reg [WORD_LEN*NUM_WORDS_IN-1:0] din;
wire [WORD_LEN-1:0] dout;

/////////////////////////////////////////////////
// DUT
/////////////////////////////////////////////////
pipelined_word_mux p (
	.clk(clk),
	.rst(rst),
	.sel(sel),
	.ena(1'b1),
	.din(din),
	.dout(dout));

defparam p .WORD_LEN = WORD_LEN;
defparam p .NUM_WORDS_IN = NUM_WORDS_IN;
defparam p .SEL_PER_LAYER = SEL_PER_LAYER;
defparam p .BALANCE_SELECTS = BALANCE_SELECTS;

/////////////////////////////////////////////////
// functional model
/////////////////////////////////////////////////
wire [WORD_LEN-1:0] dout_b, dout_b_lag;
assign dout_b = din >> (sel * WORD_LEN);
reg [WORD_LEN*LATENCY-1:0] history;

always @(posedge clk) begin
	history <= (history << WORD_LEN) | dout_b[WORD_LEN-1:0];
end
assign dout_b_lag = history[WORD_LEN*LATENCY-1:WORD_LEN*LATENCY-WORD_LEN];

/////////////////////////////////////////////////
// test
/////////////////////////////////////////////////

reg fail;

initial begin
	clk = 0;
	rst = 0;
	din = 0;
	sel = 0;
	fail = 0;
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

always begin
	#100 clk = ~clk;
end

always @(posedge clk) begin
	din <= (din << 64) | {$random,$random};
	sel <= $random;

	#5 if (dout_b_lag !== dout) begin
		$display ("Mismatch at time %d",$time);
		fail = 1'b1;
	end
end



endmodule
