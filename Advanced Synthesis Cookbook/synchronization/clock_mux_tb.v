// Copyright 2008 Altera Corporation. All rights reserved.  
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

//baeckler - 12-05-2007

module clock_mux_tb ();

reg [7:0] clk;
reg [7:0] clk_sel;
wire clk_out;

clock_mux dut (
	.clk(clk),
	.clk_select(clk_sel),
	.clk_out(clk_out)
);
defparam dut .NUM_CLOCKS = 8;


initial begin
	#200
	clk_sel = 8'b00000001;
	#200
	clk_sel = 8'b10000000;
	#200
	clk_sel = 8'b01000000;
	#400
	clk_sel = 8'b00000100;
end

initial clk = 0;
initial clk_sel = 0;

always #13 clk[0] = ~clk[0];
always #10 clk[1] = ~clk[1];
always #23 clk[2] = ~clk[2];
always #11 clk[3] = ~clk[3];
always #100 clk[4] = ~clk[4];
always #21 clk[5] = ~clk[5];
always #50 clk[6] = ~clk[6];
always #5 clk[7] = ~clk[7];


endmodule