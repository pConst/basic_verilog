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

// compute the sum of absolute difference between 2 pairs of 
// 8 bit pixels.   Output range is 0..0x1fe
// Area cost is 27 arithmetic cells

module pair_sad (a0,a1,b0,b1,sad);
input [7:0] a0,a1,b0,b1;
output [8:0] sad;
wire [8:0] sad;

wire [8:0] diff0 = a0 - b0;		
wire [8:0] diff1 = a1 - b1;		
wire [10:0] tmp_sum;

double_addsub as (.a(diff0),.b(diff1),.negate_a(diff0[8]),.negate_b(diff1[8]),
		.sum(tmp_sum));
	defparam as .WIDTH = 9;
	defparam as .HW_CELLS = 1;

assign sad = tmp_sum[8:0];
endmodule

