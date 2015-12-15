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

module bin_to_7seg	(bin,seg);
input	[3:0]	bin;
output	[6:0]	seg;
reg		[6:0]	seg;

always @(bin) begin
	
	case(bin)
		4'h0: seg = 7'b1000000;		//  output = 0 indicates a lit segment
		4'h1: seg = 7'b1111001;		// ---0---
		4'h2: seg = 7'b0100100; 	// |	 |
		4'h3: seg = 7'b0110000; 	// 5	 1
		4'h4: seg = 7'b0011001; 	// |	 |
		4'h5: seg = 7'b0010010; 	// ---6---
		4'h6: seg = 7'b0000010; 	// |	 |
		4'h7: seg = 7'b1111000; 	// 4	 2
		4'h8: seg = 7'b0000000; 	// |	 |
		4'h9: seg = 7'b0011000; 	// ---3---
		4'ha: seg = 7'b0001000;
		4'hb: seg = 7'b0000011;
		4'hc: seg = 7'b1000110;
		4'hd: seg = 7'b0100001;
		4'he: seg = 7'b0000110;
		4'hf: seg = 7'b0001110;
		default : seg = 7'b1111111;
	endcase
end

endmodule
