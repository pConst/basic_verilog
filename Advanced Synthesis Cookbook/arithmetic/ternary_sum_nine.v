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

// baeckler - 02-16-2006

// placing the ternary add in a sub module
// is not strictly necessary, but makes the 
// grouping clear and unambiguous if you
// want to remove the pipeline registers.

module tern_node (clk,a,b,c,o);
parameter WIDTH = 8;
input clk;
input [WIDTH-1:0] a;
input [WIDTH-1:0] b;
input [WIDTH-1:0] c;
output [WIDTH+2-1:0] o;
reg [WIDTH+2-1:0] o;

always @(posedge clk) begin
	o <= a+b+c;
end
endmodule

//
// pipelined sum of 9 binary words using 
// 4 ternary adder chains.
// This WIDTH 8 example should use 42 DFF and 42
// arithmetic logic cells.   This would require roughly
// 80 arithmetic cells on a binary adder device.
//

module ternary_sum_nine (clk,a,b,c,d,e,f,g,h,i,out);

parameter WIDTH = 8;

input clk;
input [WIDTH-1:0] a,b,c,d,e,f,g,h,i;
output [WIDTH+4-1:0] out;

wire [WIDTH+2-1:0] part0,part1,part2;

// entry layer, 9 => 3
tern_node x (.clk(clk),.a(a),.b(b),.c(c),.o(part0));
	defparam x .WIDTH = WIDTH;
tern_node y (.clk(clk),.a(d),.b(e),.c(f),.o(part1));
	defparam y .WIDTH = WIDTH;
tern_node z (.clk(clk),.a(g),.b(h),.c(i),.o(part2));
	defparam z .WIDTH = WIDTH;

// output layer 3=> 1
tern_node o (.clk(clk),.a(part0),.b(part1),.c(part2),.o(out));
	defparam o .WIDTH = WIDTH+2;

endmodule