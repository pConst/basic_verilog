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

module system_timer_tb ();

reg clk = 0, rst = 0;
wire usecond_pulse;
wire msecond_pulse;
wire second_pulse;


wire [9:0] usecond_cntr;
wire [9:0] msecond_cntr;
wire [5:0] second_cntr;
wire [5:0] minute_cntr;
wire [4:0] hour_cntr;
wire [9:0] day_cntr;

system_timer dut (
	.clk,
	.rst,
	
	.usecond_cntr,
	.msecond_cntr,
	.second_cntr,
	.minute_cntr,
	.hour_cntr,
	.day_cntr,
		
	.usecond_pulse,
	.msecond_pulse,
	.second_pulse
);
	defparam dut .CLOCK_MHZ = 100;

always begin
	#5 clk = ~clk;
end

initial begin
	@(negedge clk);
	rst = 1;
	@(negedge clk);
	rst = 0;	
	#10000100

	// cursory activity check, better tested in hardware
	if (usecond_cntr == 10'h0 &&
		msecond_cntr == 10'ha) $display ("PASS");
	$stop();
end

endmodule