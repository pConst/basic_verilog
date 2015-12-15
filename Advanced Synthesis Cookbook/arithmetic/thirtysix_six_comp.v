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

// baeckler - 2-13-2006
// compute sum of 36 bit lines
//
// uses nine 6:3 compressors = 27 six-luts
// plus a 5 bit carry propagate output adder (one bit falls through)

module thirtysix_six_comp (data,sum);

input [35:0] data;
output [5:0] sum;
wire [5:0] sum;

wire [5:0] word_l;
wire [5:0] word_m;
wire [5:0] word_h;

wire [2:0] sa,sb,sc,sd,se,sf;
wire [2:0] slo,sme,shi;

six_three_comp a (.data(data[5:0]),.sum(sa));
six_three_comp b (.data(data[11:6]),.sum(sb));
six_three_comp c (.data(data[17:12]),.sum(sc));
six_three_comp d (.data(data[23:18]),.sum(sd));
six_three_comp e (.data(data[29:24]),.sum(se));
six_three_comp f (.data(data[35:30]),.sum(sf));

six_three_comp lo (.data({sa[0],sb[0],sc[0],sd[0],se[0],sf[0]}),.sum(slo));
six_three_comp me (.data({sa[1],sb[1],sc[1],sd[1],se[1],sf[1]}),.sum(sme));
six_three_comp hi (.data({sa[2],sb[2],sc[2],sd[2],se[2],sf[2]}),.sum(shi));

wire [7:0] tmp_sum;
ternary_add t (.a({3'b0,slo}),
			.b({2'b0,sme,1'b0}),
			.c({1'b0,shi,2'b0}),
			.o(tmp_sum));
	defparam t .WIDTH = 6;
assign sum = tmp_sum[5:0];

endmodule
