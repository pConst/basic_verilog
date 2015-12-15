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

// baeckler - 3-15-2006

module sha_padding (
	clk,
	reset,
	word_in,
	word_in_bits,
	word_out,
	msg_complete,
	next_word
);

`include "log2.inc"

parameter WORD_SIZE = 64;
parameter LOG_WORD = log2(WORD_SIZE-1);
parameter WPM = 1024 / WORD_SIZE;  // words per message block
parameter LOG_WPM = log2(WPM-1);

input clk,reset;
input [WORD_SIZE-1:0] word_in;
input [LOG_WORD:0] word_in_bits;  // one bit too many, for full blocks
wire word_in_full = word_in_bits[LOG_WORD];

output [WORD_SIZE-1:0] word_out;
input next_word;
output msg_complete;

reg [2*WORD_SIZE-1:0] user_bits;
reg [LOG_WPM-1:0] words;

// status flags for the postamble
reg msg_size_h, msg_size_l, finishing;

always @(posedge clk) begin
	if (reset) begin
		user_bits <= 0;
		words <= 0;
		msg_size_h <= 1'b0;
		msg_size_l <= 1'b0;
		finishing <= 1'b0;
	end
	else if (next_word) begin
		user_bits <= user_bits + word_in_bits;
		words <= words + 1'b1;
		if (!word_in_full) begin
			finishing <= 1'b1;
			if (words == (WPM-3)) msg_size_h <= 1'b1;
		end
		msg_size_l <= msg_size_h;
	end
end

reg [WORD_SIZE:0] one_pos;
always @(*) begin
	one_pos = 0;
	one_pos[WORD_SIZE-1-word_in_bits] = 1'b1;
end

// generate the word with 1000 ... at the end if appro
wire [WORD_SIZE-1:0] used /* synthesis keep */;
wire [WORD_SIZE-1:0] masked_word;
genvar i;
generate
	for (i=0; i<WORD_SIZE; i=i+1) 
	begin : mask
		assign used[i] = ((WORD_SIZE-1-word_in_bits) < i);
		assign masked_word[i] = ((word_in_full | used[i]) ? word_in[i] : 1'b0);
	end
endgenerate		

// generate zero words, and the final message size words
wire [WORD_SIZE-1:0] tail_word;
assign tail_word = msg_size_l ? user_bits [WORD_SIZE-1:0] :
					msg_size_h ? user_bits [2*WORD_SIZE-1:WORD_SIZE] :
					{WORD_SIZE{1'b0}};

assign word_out = finishing ? tail_word : (masked_word | one_pos);
assign msg_complete = msg_size_l;

endmodule