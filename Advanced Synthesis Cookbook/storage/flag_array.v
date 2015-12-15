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

// baeckler - 04-24-2007
//
// In the event of a contest the flag will be set for B (1)
//
module flag_array (
	clk,
	waddr_a, waddr_b, 
	we_a, we_b, 
	raddr_a, raddr_b,
	sel_a, sel_b
);

parameter ADDR_WIDTH = 4;
parameter NUM_SLOTS = 1 << ADDR_WIDTH;

input clk;
input [ADDR_WIDTH-1:0] waddr_a,waddr_b,raddr_a,raddr_b;
input we_a,we_b;
output sel_a,sel_b;

reg [NUM_SLOTS-1:0] slots;

reg [ADDR_WIDTH-1:0] waddr_a_r,waddr_b_r,raddr_a_r,raddr_b_r;
reg we_a_r, we_b_r;

always @(posedge clk) begin
	waddr_a_r <= waddr_a;
	waddr_b_r <= waddr_b;
	raddr_a_r <= raddr_a;
	raddr_b_r <= raddr_b;
	we_a_r <= we_a;
	we_b_r <= we_b;
end

reg sel_a,sel_b;
always @(posedge clk) begin
	if (we_a_r) slots[waddr_a_r] <= 1'b0;
	if (we_b_r) slots[waddr_b_r] <= 1'b1;
	sel_a <= slots[raddr_a_r];
	sel_b <= slots[raddr_b_r];
end

endmodule

