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

// C runtime library random number generator
//
// uses 32 logic cells for DFF/ADD and 8 DSP blocks for the
// 32x18=>32 multiply

module c_rand (clk,rst,reseed,seed_val,out);
input clk,rst,reseed;
input [31:0] seed_val;
output [15:0] out;
wire [15:0] out;

reg [31:0] state;

always @(posedge clk or posedge rst) begin
	if (rst) state <= 0;
	else begin
		if (reseed) state <= seed_val;
		else begin
			state <= state * 32'h343fd + 32'h269EC3;
		end
	end
end

assign out = (state >> 16) & 16'h7fff;

endmodule