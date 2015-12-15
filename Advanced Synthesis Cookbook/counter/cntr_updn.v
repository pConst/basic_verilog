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

// baeckler - 06-16-2006
//
// UP/DN binary counter with all of the register secondary
// hardware. (1 cell per bit)

module cntr_updn (clk,ena,rst,sload,sdata,sclear,inc_not_dec,q);

parameter WIDTH = 16;

input clk,ena,rst,sload,sclear,inc_not_dec;
input [WIDTH-1:0] sdata;

output [WIDTH-1:0] q;
reg [WIDTH-1:0] q;

always @(posedge clk or posedge rst) begin
	if (rst) q <= 0;
	else begin
		if (ena) begin
			if (sclear) q <= 0;
			else if (sload) q <= sdata;
			else q <= q + (inc_not_dec ? 1'b1 : {WIDTH{1'b1}});
		end
	end
end

endmodule