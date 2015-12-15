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

module fifo_hw_test_tb ();

reg clk_x,clk_y,aclr;
reg [1:0] mode;

wire mismatch,any_mismatch,rd_empty,wr_full;
wire [15:0] cntr;

fifo_hw_test fht (
	clk_x,clk_y,aclr,
	mode,	
	mismatch,any_mismatch,rd_empty,wr_full,
	cntr
);
defparam fht .SIMULATION = 1'b0;

initial begin
	clk_x = 1'b0;
	clk_y = 1'b0;
	mode = 2'b11;
	aclr = 1'b1;
	#1000
	aclr = 1'b0;

	#10000006
	aclr = 1'b1;
	#1000
	aclr = 1'b0;

	#10000006
	mode = 2'b01;
	#10000007
	mode = 2'b11;
	#10000003
	mode = 2'b01;
	#10000003
	mode = 2'b11;
	#10000006
	mode = 2'b01;
	#10000002
	mode = 2'b11;
	#10000001
	mode = 2'b01;
	#10000009
	mode = 2'b11;
	#10000003
	mode = 2'b01;
	#10000007
	mode = 2'b11;
	#10000003
	mode = 2'b01;
	#10000003
	mode = 2'b11;
	#10000006
	mode = 2'b01;
	#10000002
	mode = 2'b11;
	#10000001
	mode = 2'b01;
	#10000009
	mode = 2'b11;
	
	mode = 2'b00;
	aclr = 1'b1;
	#1000
	aclr = 1'b0;
	#1000
	mode = 2'b11;
	
	#10000006
	if (!any_mismatch) $display ("PASS");
	$stop();
		
end

always begin 
	#35 clk_x = ~clk_x;
end

always begin 
	#43 clk_y = ~clk_y;
end

endmodule