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

module ternary_add (a,b,c,o);

parameter WIDTH=8;
parameter SIGN_EXT = 1'b0;

input [WIDTH-1:0] a,b,c;
output [WIDTH+1:0] o;
wire [WIDTH+1:0] o;

generate 
if (!SIGN_EXT)
	assign o = a+b+c;
else
	assign o = {a[WIDTH-1],a[WIDTH-1],a} +
			   {b[WIDTH-1],b[WIDTH-1],b} +
			   {c[WIDTH-1],c[WIDTH-1],c};
endgenerate

endmodule

