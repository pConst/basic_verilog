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

// baeckler - 01-02-2007

module adder_tree_tb ();

reg [7:0] a,b,c;
reg clk;
wire [3*8-1:0] in_words;

assign in_words = {c,b,a};

initial begin
	a = 0;
	b = 0;
	c = 0;	
	clk = 0;
	#10000000
	$display ("PASS");
	$stop();
end

wire [9:0] out_at0, simple_sum;
assign simple_sum = a + b + c;

adder_tree at0 (.clk(clk),.in_words(in_words),.out(out_at0),
	.extra_bit_in(1'b0),.extra_bit_out());
	defparam at0 .NUM_IN_WORDS = 3;
	defparam at0 .BITS_PER_IN_WORD = 8;
	defparam at0 .OUT_BITS = 10;
	defparam at0 .SIGN_EXT = 0;
	defparam at0 .REGISTER_OUTPUT = 0;
	defparam at0 .REGISTER_MIDDLE = 0;
	defparam at0 .SHIFT_DIST = 0;
	defparam at0 .EXTRA_BIT_USED = 0;

wire [11:0] out_at1, shifted_sum;
assign shifted_sum = a + (b << 1) + (c << 2);

adder_tree at1 (.clk(clk),.in_words(in_words),.out(out_at1),
	.extra_bit_in(1'b0),.extra_bit_out());
	defparam at1 .NUM_IN_WORDS = 3;
	defparam at1 .BITS_PER_IN_WORD = 8;
	defparam at1 .OUT_BITS = 12;
	defparam at1 .SIGN_EXT = 0;
	defparam at1 .REGISTER_OUTPUT = 0;
	defparam at1 .REGISTER_MIDDLE = 0;
	defparam at1 .SHIFT_DIST = 1;
	defparam at1 .EXTRA_BIT_USED = 0;

always @(negedge clk) begin
	a = $random();
	b = $random();
	c = $random();
end

always begin
	#100 clk = ~clk;
end

always @(posedge clk) begin
	#10
	if (out_at0 !== simple_sum) begin
		$display ("Mismatch on no-shift addition at time %d",$time);
		$stop();
	end
	if (out_at1 !== shifted_sum) begin
		$display ("Mismatch on shift addition at time %d",$time);
		$stop();
	end
end


endmodule
