// Copyright 2009 Altera Corporation. All rights reserved.  
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

// baeckler - 12-15-2008

module pn2112_table (
	input [6:0] din,
	output reg [31:0] dout
);

always @(*) begin
	case (din)
		7'd  0 : dout = 32'hffffffff;
		7'd  1 : dout = 32'h02aaaaff;
		7'd  2 : dout = 32'haaaa8000;
		7'd  3 : dout = 32'h554aaaaa;
		7'd  4 : dout = 32'h0fffff55;
		7'd  5 : dout = 32'haaaa8000;
		7'd  6 : dout = 32'h557ffffa;
		7'd  7 : dout = 32'h55555755;
		7'd  8 : dout = 32'hfffe5555;
		7'd  9 : dout = 32'haa7ffff7;
		7'd 10 : dout = 32'he00002aa;
		7'd 11 : dout = 32'haaa8aaaa;
		7'd 12 : dout = 32'hffd5557a;
		7'd 13 : dout = 32'h00001fff;
		7'd 14 : dout = 32'hfff0aaaa;
		7'd 15 : dout = 32'h5055557f;
		7'd 16 : dout = 32'hd5557d55;
		7'd 17 : dout = 32'hfffffffd;
		7'd 18 : dout = 32'h08aaab1f;
		7'd 19 : dout = 32'h2aaa7000;
		7'd 20 : dout = 32'h551aaaa8;
		7'd 21 : dout = 32'h2dfffdd5;
		7'd 22 : dout = 32'haaaa8000;
		7'd 23 : dout = 32'h55f7ffe1;
		7'd 24 : dout = 32'h7d555ad5;
		7'd 25 : dout = 32'hfffab555;
		7'd 26 : dout = 32'ha8afffd5;
		7'd 27 : dout = 32'h0000002a;
		7'd 28 : dout = 32'haaa2aaab;
		7'd 29 : dout = 32'hfd555580;
		7'd 30 : dout = 32'ha8004aff;
		7'd 31 : dout = 32'hffd02aa8;
		7'd 32 : dout = 32'h4ab5557f;
		7'd 33 : dout = 32'ha555ff55;
		7'd 34 : dout = 32'hffd57ff0;
		7'd 35 : dout = 32'h282aafaf;
		7'd 36 : dout = 32'haaa88200;
		7'd 37 : dout = 32'h54e1aaaa;
		7'd 38 : dout = 32'hda7ff75d;
		7'd 39 : dout = 32'h4aa82800;
		7'd 40 : dout = 32'h577dffb0;
		7'd 41 : dout = 32'h7fd57885;
		7'd 42 : dout = 32'hffe1b555;
		7'd 43 : dout = 32'ha525ff5d;
		7'd 44 : dout = 32'he500282a;
		7'd 45 : dout = 32'h2a8082af;
		7'd 46 : dout = 32'hffd55752;
		7'd 47 : dout = 32'ha201ab1f;
		7'd 48 : dout = 32'h7f2adaa2;
		7'd 49 : dout = 32'h1fe557fd;
		7'd 50 : dout = 32'h075755d5;
		7'd 51 : dout = 32'hffd57fd0;
		7'd 52 : dout = 32'haaa2b554;
		7'd 53 : dout = 32'h02a5ff80;
		7'd 54 : dout = 32'h50554a80;
		7'd 55 : dout = 32'h2aafd7ff;
		7'd 56 : dout = 32'haaaaaa82;
		7'd 57 : dout = 32'h5dfffe4a;
		7'd 58 : dout = 32'hd5558fff;
		7'd 59 : dout = 32'h57b00057;
		7'd 60 : dout = 32'h87557dd5;
		7'd 61 : dout = 32'hffe02aaa;
		7'd 62 : dout = 32'h5a0800b4;
		7'd 63 : dout = 32'hd7ffdad5;
		7'd 64 : dout = 32'haa854aaf;
		7'd 65 : dout = 32'hfdfaa880;
		default : dout = 32'h0;
	endcase
end

endmodule
