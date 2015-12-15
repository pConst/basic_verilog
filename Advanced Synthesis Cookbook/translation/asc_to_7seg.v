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

module asc_to_7seg	(bin,seg);
input	[7:0]	bin;
output	[6:0]	seg;
reg		[6:0]	seg;

always @(bin) begin
	
	case(bin)
		8'h0,"0" : seg = 7'b1000000;	//  output = 0 indicates a lit segment
		8'h1,"1" : seg = 7'b1111001;	// ---0---
		8'h2,"2" : seg = 7'b0100100; 	// |	 |
		8'h3,"3" : seg = 7'b0110000; 	// 5	 1
		8'h4,"4" : seg = 7'b0011001; 	// |	 |
		8'h5,"5" : seg = 7'b0010010; 	// ---6---
		8'h6,"6" : seg = 7'b0000010; 	// |	 |
		8'h7,"7" : seg = 7'b1111000; 	// 4	 2
		8'h8,"8" : seg = 7'b0000000; 	// |	 |
		8'h9,"9" : seg = 7'b0011000; 	// ---3---
		8'ha: seg = 7'b0001000;
		8'hb: seg = 7'b0000011;
		8'hc: seg = 7'b1000110;
		8'hd: seg = 7'b0100001;
		8'he: seg = 7'b0000110;
		8'hf: seg = 7'b0001110;

		"a","A" : seg = 7'b0001000;
		"b","B" : seg = 7'b0000011;
		"c","C" : seg = 7'b1000110;
		"d","D" : seg = 7'b0100001;
		"e","E" : seg = 7'b0000110;
		"f","F" : seg = 7'b0001110;
		"g","G" : seg = 7'b0010000;
		"h","H" : seg = 7'b0001011;
		"i","I" : seg = 7'b1111011;
		"j","J" : seg = 7'b1100001;
		"k","K" : seg = 7'b0000111;
		"l","L" : seg = 7'b1000111;
		"m","M" : seg = 7'b0101011;
		"n","N" : seg = 7'b0101011;
		"o","O" : seg = 7'b0100011;
		"p","P" : seg = 7'b0001100;
		"q","Q" : seg = 7'b0011000;
		"r","R" : seg = 7'b0101111;
		"s","S" : seg = 7'b0010010;
		"t","T" : seg = 7'b1001110;
		"u","U" : seg = 7'b1000001;
		"v","V" : seg = 7'b1000000;
		"w","W" : seg = 7'b1000000;		// a couple of letters
		"x","X" : seg = 7'b0001001;		// don't map well.  Show
		"y","Y" : seg = 7'b0011001;		// something anyway.
		"z","Z" : seg = 7'b0100100;

		" " : seg = 7'b1111111;
		"-" : seg = 7'b0111111;
	
		default : seg = 7'b1111111;
	endcase
end

endmodule
