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

module rgb_to_hue_tb ();

reg clk,rst;
reg [7:0] r,g,b;
wire [7:0] h;

rgb_to_hue r2h
(
	.clk(clk),
	.rst(rst),
	.r(r),
	.g(g),
	.b(b),
	.hue(h)
);

integer n = 0;

real error;
reg [7:0] max3,min3;
real delta,rdist,gdist,bdist,hue;
real hue_d,hue_dd,hue_ddd,hue_dddd;

initial begin
	clk = 0;
	rst = 1'b1;
	r=0;
	g=0;
	b=0;

	@(posedge clk);
	@(negedge clk);
	rst = 1'b0;

	@(negedge clk);
	
	for (n=0;n<1000000;n=n+1)
	begin
		@(negedge clk);
		r = $random; g = $random; b = $random;
		@(negedge clk);
		@(posedge clk);
		#1
		error = h - hue_ddd;
		if (error > 2 || error < -2) begin
			if (delta < 16) begin
				$display ("Marginal - Low delta value %f with error %f at time %d",
					delta,error,$time);				
			end
			else begin
				$display ("Error - Outside of range at time %d",$time);
				#100
				$stop();
			end
		end
	end		
	$display ("PASS");
	$stop();
end


always @(posedge clk) begin
	max3 = (r > g) ? ((r > b) ? r : b) :
					((g > b) ? g : b);
	min3 = (r < g) ? ((r < b) ? r : b) :
					((g < b) ? g : b);
	
	delta = max3 - min3;
	
	if (delta == 0) hue = 0;
	else begin
		rdist = (max3 - r) / delta;
		gdist = (max3 - g) / delta;
		bdist = (max3 - b) / delta;
		if (r == max3) begin
			hue = 40 * ((g/delta) - (b/delta));
		end
		else if (g == max3) begin
			hue = 80 + 40 * ((b/delta) - (r/delta));
		end
		else begin
			hue = 160 + 40 * ((r/delta) - (g/delta));
		end
		if (hue < 0) hue = hue + 240;
		if (hue >= 240) hue = hue - 240;
	end

	hue_d <= hue;
	hue_dd <= hue_d;
	hue_ddd <= hue_dd;
	hue_dddd <= hue_ddd;
end

always begin
	#100 clk = ~clk;
end

endmodule