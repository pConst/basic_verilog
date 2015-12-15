// Copyright 2010 Altera Corporation. All rights reserved.  
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
module mlab_delay_tb ();
	
parameter BITS_PER_WORD = 9;
parameter WORDS = 46;

reg clk = 0;
reg [WORDS * BITS_PER_WORD - 1 : 0] din = 0;
wire [WORDS * BITS_PER_WORD - 1 : 0]  dout;
reg ena = 1'b1;
wire parity_error;

mlab_delay dut (.*);
defparam dut .WORDS = WORDS;
defparam dut .BITS_PER_WORD = BITS_PER_WORD;
defparam dut .LATENCY = 10;

always @(posedge clk) begin
	if (ena) din <= din + 1'b1;
end

always @(negedge clk) ena = $random();

reg [WORDS * BITS_PER_WORD - 1 : 0] delta;
always @(posedge clk) delta <= din - dout;

always begin
	#5 clk = ~clk;
end

reg fail = 0;
always @(posedge clk) begin
	if (!parity_error && delta != 10) fail = 1'b1;
end

initial begin
	#10
	@(negedge parity_error);
	#100000
	if (!fail) $display ("PASS");
	$stop();
end

endmodule