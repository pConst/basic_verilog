// Copyright 2011 Altera Corporation. All rights reserved.  
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

// baeckler - 09-17-2008

// 58 bit loadable LFSR - x^58 + x^39 + 1
// with 64 bit output for use as a scrambler

module scrambler_lfsr (
	input clk, arst,
	input verify,		
	input load,
	input [57:0] load_d,
	input evolve,
	output [63:0] q,
	output verify_fail,
	output verify_pass		   
);

// the RESET_VAL must be non-zero and 
// for noise should be unique per TX lane
parameter RESET_VAL = 58'h1234567_89abcdef;

reg [57:0] lfsr;
wire [63:0] next;

assign q = {lfsr[57:0], next[63:58]};

// This is from the Interlaken scrambler sample
// Verilog, regrouped to words.
assign next = {lfsr,lfsr[57:52]} ^ 
			{lfsr[38:0],lfsr[38:14]} ^ 
			{39'b0,lfsr[57:39],6'b0};
  
always @(posedge clk or posedge arst) begin
	if(arst) begin
		lfsr <= RESET_VAL; 
	end else begin
		if (load) lfsr <= load_d;
		else if (evolve) lfsr <= next[57:0];
	end
end	

reg last_verify, match;
always @(posedge clk or posedge arst) begin
	if(arst) begin
		last_verify <= 1'b0;
		match <= 1'b0; 
	end
	else begin
		last_verify <= verify;
		match <= (lfsr == load_d);
	end
end

assign verify_fail = last_verify & !match;
assign verify_pass = last_verify & match;

endmodule

