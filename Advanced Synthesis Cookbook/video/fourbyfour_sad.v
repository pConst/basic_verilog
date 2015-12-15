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

// Sum of absolute difference for a 4x4 array of 8 bit pixels
//    260 arithmetic mode cells.

module fourbyfour_sad (
	x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,xa,xb,xc,xd,xe,xf,
	y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,ya,yb,yc,yd,ye,yf,
	sad
);

input [7:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,xa,xb,xc,xd,xe,xf;
input [7:0] y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,ya,yb,yc,yd,ye,yf;
output [11:0] sad;

// Compute SAD for two pairs of pixels at a time
//  8 units each costing 27 arithmetic cells = 216 cells
wire [8:0] sd01,sd23,sd45,sd67,sd89,sdab,sdcd,sdef;
pair_sad p01 (.a0(x0),.a1(x1),.b0(y0),.b1(y1),.sad(sd01));
pair_sad p23 (.a0(x2),.a1(x3),.b0(y2),.b1(y3),.sad(sd23));
pair_sad p45 (.a0(x4),.a1(x5),.b0(y4),.b1(y5),.sad(sd45));
pair_sad p67 (.a0(x6),.a1(x7),.b0(y6),.b1(y7),.sad(sd67));
pair_sad p89 (.a0(x8),.a1(x9),.b0(y8),.b1(y9),.sad(sd89));
pair_sad pab (.a0(xa),.a1(xb),.b0(ya),.b1(yb),.sad(sdab));
pair_sad pcd (.a0(xc),.a1(xd),.b0(yc),.b1(yd),.sad(sdcd));
pair_sad pef (.a0(xe),.a1(xf),.b0(ye),.b1(yf),.sad(sdef));

// 1st level of summation - 32 arith cells
wire [10:0] partial0,partial1;
wire [9:0] partial2;
ternary_add t0 (.a(sd01),.b(sd23),.c(sd45),.o(partial0));
	defparam t0 .WIDTH = 9;
ternary_add t1 (.a(sd67),.b(sd89),.c(sdab),.o(partial1));
	defparam t1 .WIDTH = 9;
assign partial2 = sdcd + sdef;

// 2nd level of summation - 12 arith cells
wire [12:0] tmp_sum;
ternary_add t2 (.a(partial0),.b(partial1),.c({1'b0,partial2}),.o(tmp_sum));
	defparam t2	.WIDTH = 11;
assign sad = tmp_sum[11:0];

endmodule

	