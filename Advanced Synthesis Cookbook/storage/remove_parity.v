// Copyright 2010 Altera Corporation. All rights reserved.  
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
module remove_parity #(
	parameter WORDS = 5,
	parameter BITS_PER_WORD = 9
	
)(
	input [(1+BITS_PER_WORD)*WORDS-1:0] din,
	output [BITS_PER_WORD*WORDS-1:0] dout	
);

genvar i;
generate
	for (i=0; i<WORDS; i=i+1) begin : p
		wire [BITS_PER_WORD-1:0] tmp_in = din [(i+1)*(BITS_PER_WORD+1)-2:
			i*(BITS_PER_WORD+1)];
		assign dout[(i+1)*BITS_PER_WORD-1:i*BITS_PER_WORD] = tmp_in;
	end
endgenerate

endmodule