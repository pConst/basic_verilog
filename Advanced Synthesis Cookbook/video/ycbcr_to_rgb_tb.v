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

module ycbcr_to_rgb_tb ();

reg rst,clk;
reg [7:0] y,cb,cr;
wire [7:0] red,green,blue;

///////////////////////////////////////////
// test device

ycbcr_to_rgb dut (
	.y(y),.cb(cb),.cr(cr),
	.red(red),.green(green),.blue(blue),
	.clk(clk)
);

///////////////////////////////////////////
// reference formulas

real r,rp,rpp,g,gp,gpp,b,bp,bpp; 
real ry,rcr,rcb;
real c16 = 16;	// A Verilog type cast?
real c128 = 128; 

always @(posedge clk) begin
	ry <= y-c16;
	rcr <= cr-c128;
	rcb <= cb-c128;
	rpp <= 1.164 * ry + 1.596 * rcr;
	gpp <= 1.164 * ry - 0.813 * rcr - 0.392*rcb;
	bpp <= 1.164 * ry + 2.017 * rcb;
	rp <= rpp;
	gp <= gpp;
	bp <= bpp;
	r <= (rp < 0) ? 0 : (rp > 255) ? 255 : rp;
	g <= (gp < 0) ? 0 : (gp > 255) ? 255 : gp;
	b <= (bp < 0) ? 0 : (bp > 255) ? 255 : bp;	
end

real error_bar = 2;
real rdelta,gdelta,bdelta;

integer n = 0;
initial begin
	clk = 0;
	rst = 0;
	@(negedge clk) y = 255; cb = 255; cr = 255;
	@(negedge clk); @(negedge clk);

	@(negedge clk) y = 255; cb = 0; cr = 0;
	@(negedge clk); @(negedge clk);

	for (n=0; n<1000000; n=n+1) 
	begin
		@(negedge clk) y = $random; cb = $random; cr = $random;
		@(negedge clk); 
		@(negedge clk); 
		
		rdelta = r-red;
		gdelta = g-green;
		bdelta = b-blue;
		if ((rdelta > error_bar) | 
			(rdelta < -error_bar) |
			(gdelta > error_bar) | 
			(gdelta < -error_bar) |
			(bdelta > error_bar) | 
			(bdelta < -error_bar))
		begin
			$display ("Error margin too high at time %d", $time);
			#100
			$stop();
		end

	end

	$display ("PASS");
	$stop();
end

always begin
	#50 clk = ~clk;
end

endmodule
