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

module register_bank_tb ();

parameter WIDTH = 10;

wire [WIDTH-1:0] qr,qs;
reg [WIDTH-1:0] d;
reg clk,sload,sclr,ena,aclr;
reg [WIDTH-1:0] sdata;
reg fail;

register_bank r (.d(d), .q(qr), .clk(clk), .sload(sload), .sdata(sdata),
	.sclr(sclr), .ena(ena), .aclr(aclr));
	defparam r .METHOD = 0;
	defparam r .WIDTH = WIDTH;

register_bank s (.d(d), .q(qs), .clk(clk), .sload(sload), .sdata(sdata),
	.sclr(sclr), .ena(ena), .aclr(aclr));
	defparam s .METHOD = 1;
	defparam s .WIDTH = WIDTH;

initial begin
	aclr = 1'b0;
	clk = 1'b0;
	sload = 1'b0;
	sclr = 1'b0;
	sdata = 0;
	d = 0;
	fail = 1'b0;

	#10 aclr = 1'b1;
	#10 aclr = 1'b0;

	#200000 if (!fail) $display ("PASS");
	$stop();
end

always begin
	#100 clk = ~clk;
end

always @(posedge clk) begin
	#10 if (qr !== qs) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

always @(negedge clk) begin
	sdata = $random;
	d = $random;
	sclr = $random;
	sload = $random;
	ena = $random;
end

endmodule