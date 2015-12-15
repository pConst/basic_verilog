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

// baeckler - 11-16-2005

module unstable_counters (clk,rst,dat);

input clk,rst;
output [7:0] dat;
wire [7:0] dat;

function [7:0] rev_byte;
	input [7:0] b;
	begin
		rev_byte = {b[0],b[1],b[2],b[3],b[4],b[5],b[6],b[7]};
	end
endfunction

function [7:0] mash_word;
	input [15:0] w;
	begin
		mash_word = w[7:0] ^ rev_byte(w[15:8]);
	end
endfunction

wire [15:0] nd0_out;
wire [15:0] nd1_out;
wire [15:0] nd2_out;
wire [15:0] nd3_out;

// unstable counters with delay loops in the 75-100 cell neighborhood
ring_counter nd0 (.clk(clk),.rst(rst),.out(nd0_out));
defparam nd0 .DELAY = 79;
ring_counter nd1 (.clk(clk),.rst(rst),.out(nd1_out));
defparam nd1 .DELAY = 83;
ring_counter nd2 (.clk(clk),.rst(rst),.out(nd2_out));
defparam nd2 .DELAY = 89;
ring_counter nd3 (.clk(clk),.rst(rst),.out(nd3_out));
defparam nd3 .DELAY = 97;

assign dat = (mash_word(nd0_out) ^ mash_word(nd3_out) ^ 
		rev_byte(mash_word(nd1_out)) ^ rev_byte(mash_word(nd2_out)));

endmodule