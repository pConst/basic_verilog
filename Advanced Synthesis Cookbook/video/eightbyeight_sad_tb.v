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

module eightbyeight_sad_tb ();

reg clk,aclr;
reg [8*8*8-1:0] xpixels;
reg [8*8*8-1:0] ypixels;
wire [13:0] sad;

////////////////////////////////
// Test unit

eightbyeight_sad dut 
(
	.clk(clk),
	.aclr(aclr),
	.xpixels(xpixels),
	.ypixels(ypixels),
	.sad(sad)
);

////////////////////////////////
// Equivalent summation
integer n = 0;
integer diff = 0, x = 0, y = 0, cume = 0;

always @(*) begin
	cume = 0;
	for (n=0; n<64; n=n+1) 
	begin : check
		x = (xpixels >> (8*n)) & 8'hff;
		y = (ypixels >> (8*n)) & 8'hff;
		diff = (x > y) ? (x-y) : (y-x);
		cume = cume + diff;					
	end
end

reg [6*14-1:0] pipe;
always @(posedge clk or posedge aclr) begin
	if (aclr) pipe <= 0;
	else pipe <= (pipe << 14) | cume;	
end

////////////////////////////////
// verify
reg fail = 1'b0;

always @(posedge clk) begin
	#1
	if (pipe[6*14-1:5*14] !== sad) begin
		$display ("Mismatch at time %d : %d vs %d",
			$time,pipe[6*14-1:5*14],sad);
		fail = 1'b1;
	end
end

initial begin
	#100000 if (!fail) $display ("PASS");
	$stop();
end

////////////////////////////////
// control

initial begin
	clk = 0;
	aclr = 0;
	#1 aclr = 1'b1;
	@(negedge clk) aclr = 1'b0;
	xpixels = 0;
	ypixels = 0;
end

integer k = 0;
always @(negedge clk) begin
	xpixels = (xpixels << 32) | $random;
	ypixels = (ypixels << 32) | $random;	
end

always begin
	#5 clk = ~clk;
end

endmodule