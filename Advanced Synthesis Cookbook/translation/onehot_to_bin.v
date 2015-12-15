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

// baeckler - 11-14-2006

module onehot_to_bin (onehot,bin);

`include "log2.inc"

parameter ONEHOT_WIDTH = 16;
parameter BIN_WIDTH = log2(ONEHOT_WIDTH-1);

input [ONEHOT_WIDTH-1:0] onehot;
output [BIN_WIDTH-1:0] bin;

genvar i,j;
generate
	for (j=0; j<BIN_WIDTH; j=j+1)
	begin : jl
		wire [ONEHOT_WIDTH-1:0] tmp_mask;
		for (i=0; i<ONEHOT_WIDTH; i=i+1)
		begin : il
			assign tmp_mask[i] = i[j];
		end	
		assign bin[j] = |(tmp_mask & onehot);
	end
endgenerate

endmodule
