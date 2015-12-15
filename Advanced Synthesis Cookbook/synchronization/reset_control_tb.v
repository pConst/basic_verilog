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

module reset_control_tb ();

reg pll_lock, rstn_pin, fatal_error;
reg [7:0] clk;
reg [7:0] clk_ena;
wire [7:0] rstn;

reset_control dut (
	.external_rstn({pll_lock,rstn_pin,!fatal_error}),
	.clk(clk & clk_ena),
	.rstn(rstn)	
);
defparam dut .NUM_EXTERNAL_RESETS = 3;
defparam dut .NUM_DOMAINS = 8;

/////////////////////////////////////
reg fail = 0;
initial begin
	pll_lock = 1'b1;
    rstn_pin = 1'b1;
	fatal_error = 1'b0;
	clk_ena = 0;
	#500
	if (rstn !== 8'b0) begin
		$display ("Expected powerup to reset state");
		fail = 1'b1;
		$stop();
	end
	clk_ena = 8'hff;
	#2000
	if (rstn !== 8'hff) begin
		$display ("Failed to leave reset state");
		fail = 1'b1;
		$stop();
	end

	// lose PLL lock - should trigger immediate reset
	pll_lock = 1'b0;
	#1
	if (rstn !== 8'b0) begin
		$display ("Did not enter reset immediately on loss of PLL lock");
		fail = 1'b1;
		$stop();
	end
	pll_lock = 1'b1;
	
	#2000
	if (rstn !== 8'hff) begin
		$display ("Failed to leave reset state");
		fail = 1'b1;
		$stop();
	end


	if (!fail)
	begin
		$display ("PASS");
	end
	$stop();
end


/////////////////////////////////////
// create a bunch of random clocks
initial clk = 0;

always #13 clk[0] = ~clk[0];
always #10 clk[1] = ~clk[1];
always #23 clk[2] = ~clk[2];
always #11 clk[3] = ~clk[3];
always #100 clk[4] = ~clk[4];
always #21 clk[5] = ~clk[5];
always #50 clk[6] = ~clk[6];
always #5 clk[7] = ~clk[7];

endmodule