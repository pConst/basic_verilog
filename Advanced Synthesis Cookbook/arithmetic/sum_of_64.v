// Copyright 2008 Altera Corporation. All rights reserved.  
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

// baeckler - 09-16-2008
//   this is essentially a 64 to 7 compressor.   The first two
//   layers are LUT based.
//
module sum_of_64 (
	input [63:0] data,
	output [6:0] sum	
);

// first and second layers - LUT based
wire [3:0] sum_a,sum_b,sum_c,sum_d,sum_e;
wire [2:0] sum_f;
twelve_four_comp ca (.data(data[11:0]),.sum(sum_a));
twelve_four_comp cb (.data(data[23:12]),.sum(sum_b));
twelve_four_comp cc (.data(data[35:24]),.sum(sum_c));
twelve_four_comp cd (.data(data[47:36]),.sum(sum_d));
twelve_four_comp ce (.data(data[59:48]),.sum(sum_e));
six_three_comp cf (.data({2'b0,data[63:60]}),.sum(sum_f));

// third layer binary adders
wire[4:0] sum_g = sum_a + sum_b;
wire[4:0] sum_h = sum_c + sum_d;
wire[4:0] sum_i = sum_e + sum_f;

// fourth layer ternary add
ternary_add ta (.a(sum_g),.b(sum_h),.c(sum_i),.o(sum));
	defparam ta .WIDTH=5;

endmodule