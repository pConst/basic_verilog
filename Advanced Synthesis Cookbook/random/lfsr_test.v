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

module lfsr_test ();

parameter WIDTH = 20;

reg clk, rst, fail;
integer cycles;

wire [WIDTH-1:0] out;

lfsr l (.clk(clk),.rst(rst),.out(out));
	defparam l .WIDTH = WIDTH;

initial begin 
	rst = 0;
	clk = 0;
	fail = 0;
	#10 rst = 1;
	#10 rst = 0;
	cycles = 0;
end

always @(posedge clk) begin
  cycles = cycles + 1;
  if (cycles == (1 << WIDTH)) begin
	if (out != 0) begin
		$display ("Failed to return to zero");
	end
	else begin
		if (!fail) $display ("PASS");
	end
	$stop();
  end
end

always @(negedge clk) begin
  if ((cycles != (1 << WIDTH)-1) && out == 0) begin
	$display ("Early return to zero");
	fail = 1;
  end
end 

always begin
	#1000 clk = ~clk;	
end

endmodule
