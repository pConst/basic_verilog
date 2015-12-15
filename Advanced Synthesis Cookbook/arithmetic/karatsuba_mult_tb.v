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

module karatsuba_mult_tb ();

parameter IN_WIDTH = 32; // smaller width for testing.  64x64 nominal

reg clk = 0;

reg [IN_WIDTH-1:0] a,b;
wire [2*IN_WIDTH-1:0] o;

////////////////////////////////
// DUT
////////////////////////////////

karatsuba_mult km (
	.clk(clk),
	.a(a),
	.b(b),
	.o(o)
);
defparam km .IN_WIDTH = IN_WIDTH;

////////////////////////////////
// functional model
////////////////////////////////
parameter LATENCY = 6;
reg [LATENCY * 2*IN_WIDTH-1:0] m;
wire [2*IN_WIDTH-1:0] o2 = m[LATENCY*2*IN_WIDTH-1:(LATENCY-1)*2*IN_WIDTH];

always @(posedge clk) begin
	m <= (m << 2*IN_WIDTH) | (a * b);
end

////////////////////////////////
// test stimulus + check
////////////////////////////////

always @(negedge clk) begin
	a = $random;
	b = $random;
end

reg fail = 0;

integer cyc = 0;
always @(posedge clk) begin
	cyc <= cyc + 1'b1;
	#2 if ((o2 !== o) && (cyc > LATENCY)) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

initial begin
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

always begin
	#100 clk = ~clk;
end

endmodule