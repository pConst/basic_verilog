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

// baeckler - 07-05-2006

////////////////////////////////////////////
// Quick test bench
////////////////////////////////////////////
module gray_cntr_tb ();

parameter WIDTH = 20;

reg clk, rst, ena, sclr;
wire [WIDTH-1:0] q,b,c;
reg fail;

gray_cntr cntrc (
	.clk(clk),
	.rst(rst),
	.ena(ena),
	.sclr(sclr),
	.q(q)
);
defparam cntrc .WIDTH = WIDTH;

gray_cntr_la cntrla (
	.clk(clk),
	.rst(rst),
	.ena(ena),
	.sclr(sclr),
	.q(b)
);
defparam cntrla .WIDTH = WIDTH;
defparam cntrla .METHOD = 0;

gray_cntr_la cntrlac (
	.clk(clk),
	.rst(rst),
	.ena(ena),
	.sclr(sclr),
	.q(c)
);
defparam cntrlac .WIDTH = WIDTH;
defparam cntrlac .METHOD = 1;

// Reference unit
reg [WIDTH-1:0] backup_q;
always @(posedge clk or posedge rst) begin
	if (rst) backup_q <= 0;
	else if (ena) begin
		if (sclr) backup_q <= 0;
		else backup_q <= backup_q + 1'b1;
	end
end

reg allow_sclr;

initial begin
	clk = 0;
	rst = 0;
	ena = 1;
	sclr = 0;
	fail = 0;
	allow_sclr = 0;

	#10 rst = 1;
	#10 rst = 0;
	@(&backup_q) #10000 if (!fail) $display ("Count to max pass");

	@(negedge clk) allow_sclr = 1;
	#1000000
	@(negedge clk);
	if (!fail) $display ("Random SCLR pass");
	allow_sclr = 0;
	
	if (!fail) $display ("PASS");
	$stop();
end

always begin
	#100 clk = ~clk;
end


always @(negedge clk) begin
	if ((backup_q ^ (backup_q >> 1)) !== q) begin
		$display ("Q Mismatch time at %d",$time);
		fail = 1;
	end

	if ((backup_q ^ (backup_q >> 1)) !== b) begin
		$display ("B Mismatch time at %d",$time);
		fail = 1;
	end

	if ((backup_q ^ (backup_q >> 1)) !== c) begin
		$display ("C Mismatch time at %d",$time);
		fail = 1;
	end

	ena = $random | $random;
	sclr = allow_sclr & (($random % 100) == 0) ;

	#10 if (fail) #1000 $stop();	
end

endmodule
