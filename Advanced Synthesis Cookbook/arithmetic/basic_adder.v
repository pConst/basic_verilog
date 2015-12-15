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

// baeckler - 10-24-2006
// example of bit slicing v.s. word adders on Stratix II

///////////////////////////////////////////////
//
// This is the basic "+" operator version.  It is
// easy to use and gives the synthesis tool an 
// unambiguous message of which bits belong together.
// The synthesis tool has permission to minimize and 
// restructure "+" operations freely.  For example to 
// change "1+a+1" to "a+2".  This is the method 
// recommended by Altera and 3rd party synthesis.
//
module word_adder_plain (a,b,s);
parameter WIDTH = 8;

input [WIDTH-1:0] a,b;
output [WIDTH-1:0] s;

assign s = a + b;

endmodule

///////////////////////////////////////////////
//
// This is a standard Full Adder cell expressed
// in a WYSIWYG gate.  This form is preferable
// to comb logic because it explicitly marks the
// carry in and carry out.  It is also a good
// way to express complex logic functions on the 
// input side of the adder, and shared chains 
// (ternary addition).   This view gives access
// to all architecture capabilities, but is somewhat
// cumbersome to use.  Unlike the "+" operator
// a WYSIWYG add will not be restructured or 
// mimnimized except in extreme cases.
//
module full_add (a,b,cin,s,cout);
input a,b,cin;
output s,cout;

stratixii_lcell_comb w (
    .dataa(1'b1),
    .datab(1'b1),
    .datac(1'b1),
    .datad(a),
    .datae(1'b1),
    .dataf(b),
    .datag(1'b1),

    .cin(cin),
    .sharein(1'b0),
    .sumout(s),
    .cout(cout),
    .combout(),
    .shareout()
);

defparam w .shared_arith = "off";
defparam w .extended_lut = "off";
defparam w .lut_mask = 64'h000000ff0000ff00 ;

//
// Note : LUT mask programming is generally done by
//   synthesis software, but they can be set by hand.  This
//   explanation is for the interested person, and by 
//   no means necessary to follow.
//
// The lut mask is a truth table expressed in 64 bit hex.  
// In basic adder mode these two blocks are active.
//         vvvv    vvvv 
// 64'h000000ff0000ff00 
// 
// Each 4 hex digit block represents a function of up to 4 inputs.
// The left hand block uses "ABCF" and the right hand "ABCD" with
// A being the least significant.  For each of the 16 possible input
// values the function output is stored in the corresponting bit.
//
//    e.g.  ffff  = vcc  (all ones)
//			ff00  = "D"  (most significant)
//			aaaa  = "A"  (1010..binary, the least significant)
//          6666  = "A xor B"
//
// These functions will be the two inputs to the adder chain.  
// In this case the inputs D and F pass through.  Detailed
// information on the programming of WYSIWYG cells is available
// through the Altera University Program (for CAD tools
// research).  
//

endmodule

///////////////////////////////////////////////
//
// This is a word adder constructed from the 
// slices declared above.
//
module word_adder_sliced (a,b,s);
parameter WIDTH = 8;

input [WIDTH-1:0] a,b;
output [WIDTH-1:0] s;
wire [WIDTH:0] cin;

assign cin[0] = 1'b0;

genvar i;
generate
	for (i=0; i<WIDTH; i=i+1) 
	begin : al
		full_add fa (.a(a[i]),.b(b[i]),.cin(cin[i]),.s(s[i]),.cout(cin[i+1]));
	end
endgenerate

endmodule

///////////////////////////////////////////////
//
// This verifies that the "+" and bit sliced
// chain have identical behavior
//
module adder_testbench ();

parameter WIDTH = 12;
reg [WIDTH-1:0] a,b;
wire [WIDTH-1:0] o1,o2;

// adders to compare
word_adder_plain ap (.a(a),.b(b),.s(o1));
	defparam ap .WIDTH = WIDTH;

word_adder_sliced as (.a(a),.b(b),.s(o2));
	defparam as .WIDTH = WIDTH;

reg fail;
initial begin
	a = 0; b = 0;
	fail = 0;
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

always begin 
	#100 a = $random; b = $random;
	#10 if (o1 !== o2) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

endmodule

