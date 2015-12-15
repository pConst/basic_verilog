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

// baeckler - 06-12-2007

module seconds_counter (clk100,reset,count_val,tick);

parameter WIDTH = 10;

input clk100,reset;
output [WIDTH-1:0] count_val;
output tick;

// divide by 1000
reg [9:0] div_one;
reg div_one_max;

always @(posedge clk100) begin
	div_one_max <= (div_one == 10'd998);
	if (div_one_max | reset) div_one <= 10'd0;
	else div_one <= div_one + 1'b1;
end

// divide by 1000
reg [9:0] div_two;
reg div_two_max;

always @(posedge clk100) begin
	div_two_max <= (div_two == 10'd999);
	if ((div_one_max & div_two_max) | reset) div_two <= 10'd0;
	else if (div_one_max) div_two <= div_two + 1'b1;	
end

// divide by 100
reg [6:0] div_three;
reg div_three_max;

always @(posedge clk100) begin
	div_three_max <= (div_three == 7'd99);
	if ((div_one_max & div_two_max & div_three_max) | reset) div_three <= 10'd0;
	else if (div_one_max & div_two_max) div_three <= div_three + 1'b1;		
end

// tally seconds
reg tick, reset_pending;
reg [WIDTH-1:0] count_val;
always @(posedge clk100) begin
	reset_pending <= reset;
	tick <= div_one_max & div_two_max & div_three_max & !reset_pending & !reset;
	
	if (reset | reset_pending) begin
		count_val <= 0;
	end
	else if (tick) begin
		count_val <= count_val + 1'b1;
	end
end

endmodule