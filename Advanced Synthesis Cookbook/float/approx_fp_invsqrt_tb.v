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

// baeckler - 05-02-2007

module approx_fp_invsqrt_tb ();

// number of stimuli in table
parameter NUM_STIM = 50000;

// 1st order approximation only v.s. additional Newton refinement round
parameter CORRECTION_ROUND = 1'b1;

// the correction round increases the pipeline latency
parameter LAG = CORRECTION_ROUND ? 6 : 1;

reg [32*NUM_STIM*7-1:0] test_stim  =
{

`include "inv_sqrt.tbl"

};

reg clk = 0;

//////////////////////////
// handle the stimulus and
//   expected result latency
//////////////////////////

wire [31:0] in, invsqrt_in, min_err2, max_err2,
	min_err5, max_err5,min_err10, max_err10;
wire [6*32-1:0] err_bars;

assign {in,err_bars} = test_stim [7*32-1:0];

reg [32*6*LAG-1:0] history;

always @(posedge clk) begin
	history <= (history << 6*32) | err_bars;
end

assign {min_err2,max_err2,min_err5,max_err5,min_err10,max_err10} =
		history [LAG*6*32-1:(LAG-1)*6*32];

//////////////////////////
// DUT
//////////////////////////
approx_fp_invsqrt ais (.clk(clk),.in(in),.out(invsqrt_in));
	defparam ais .CORRECTION_ROUND = CORRECTION_ROUND;

integer n;
integer fail10 = 0, fail5 = 0, fail2 = 0;

initial begin
	for (n=0; n<LAG; n=n+1) 
	begin : flush
		@(posedge clk);
	end

	for (n=0; n<NUM_STIM-1; n=n+1) 
	begin : tst
		@(posedge clk);
		#5 if (invsqrt_in < min_err10 ||
				invsqrt_in > max_err10) 
		begin
			$display ("10pct error bar failed");
			fail10 = fail10 + 1'b1;
		end
		else if (invsqrt_in < min_err5 ||
				invsqrt_in > max_err5) 
		begin
			$display ("5pct error bar failed");
			fail5 = fail5 + 1'b1;
		end
		else if (invsqrt_in < min_err2 ||
				invsqrt_in > max_err2) 
		begin
			$display ("2pct error bar failed");
			fail2 = fail2 + 1'b1;
		end		
	end

	$display ("Total trials %d",NUM_STIM);
	$display ("  2 to 5 pct err %d",fail2);
	$display ("  5 to 10 pct err %d",fail5);
	$display ("  over 10 pct err %d",fail10);

	if (fail10 == 0) $display ("PASS");
	$stop();
end

always @(posedge clk) begin
	test_stim <= test_stim >> (7*32);
end

always begin
	#100 clk = ~clk;
end

endmodule
