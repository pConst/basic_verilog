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

module double_addsub_tb ();

parameter WIDTH = 10;

reg [WIDTH-1:0] a,b;
wire [WIDTH+1:0] sum_x,sum_y,sum_z;
reg negate_a,negate_b,fail;

double_addsub x (.a(a),.b(b),.negate_a(negate_a),.negate_b(negate_b),.sum(sum_x));
defparam x .WIDTH = WIDTH;
defparam x .HW_CELLS = 1'b0;

double_addsub y (.a(a),.b(b),.negate_a(negate_a),.negate_b(negate_b),.sum(sum_y));
defparam y .WIDTH = WIDTH;
defparam y .HW_CELLS = 1'b1;

assign sum_z = (negate_a ? -a : a) + (negate_b ? -b : b);

initial begin
	a = ~0;
	b = ~0;
	negate_a = 0;
	negate_b = 0;
	fail = 0;
	$random(123);
end

always begin 
	#1000
	a = $random;
	b = $random;
	negate_a = $random;
	negate_b = $random;

	#1000
	if (sum_x != sum_z || sum_y != sum_z) begin
		$display ("Mismatch at time %d",$time);
		fail = 1'b1;
	end
end

initial begin
	#1000000
	if (!fail) $display ("PASS");
	$stop();
end

endmodule