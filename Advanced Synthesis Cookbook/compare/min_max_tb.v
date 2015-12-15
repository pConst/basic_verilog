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

// baeckler - 05-05-2006
// testbench for min_max

////////////////////////////////////////////

module min_max_tb ();

parameter WIDTH = 8;

reg clk,rst,sign;
reg [WIDTH-1:0] a,b;
wire [WIDTH-1:0] min_ab,max_ab;
wire [WIDTH-1:0] min_abu,max_abu;
wire [WIDTH-1:0] min_ab8,max_ab8;

min_max_signed mm (.clk(clk),.rst(rst),.a(a),.b(b),
	.min_ab(min_ab),.max_ab(max_ab));
	defparam mm .WIDTH = WIDTH;

min_max_unsigned mmu (.clk(clk),.rst(rst),.a(a),.b(b),
	.min_ab(min_abu),.max_ab(max_abu));
	defparam mmu .WIDTH = WIDTH;

min_max_8bit m8 (.clk(clk),.rst(rst),.a_in(a),.b_in(b),
	.is_signed(sign),
	.min_ab(min_ab8),.max_ab(max_ab8));

reg fail = 0;
initial begin
	clk = 0;
	rst = 0;
	sign = 0;
	#10 rst = 1;
	#10 rst = 0;
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

always begin
	#100 clk = ~clk;
end

always @(negedge clk) begin
	a = $random;
	b = $random;
	sign = $random;
end

always @(posedge clk) begin
	#10 if (sign & (min_ab8 != min_ab || min_ab8 != min_ab) |
			!sign & (min_ab8 != min_abu || min_ab8 != min_abu))
		begin
			$display ("Mismatch at time %d",$time);
			fail = 1;
		end
end


endmodule
