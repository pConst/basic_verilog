// Copyright 2011 Altera Corporation. All rights reserved.  
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

`timescale 1 ps / 1 ps

// baeckler -09-15-2008
// This is intended to use exactly ten LUTs in two levels.

module twelve_four_comp (data,sum);

input [11:0] data;
output [3:0] sum;

wire [3:0] sum /* synthesis keep */;
wire [2:0] sum_a,sum_b;

six_three_comp ca (.data(data[5:0]),.sum(sum_a));
six_three_comp cb (.data(data[11:6]),.sum(sum_b));
sum_of_3bit_pair st (.a(sum_a),.b(sum_b),.sum(sum));

endmodule
