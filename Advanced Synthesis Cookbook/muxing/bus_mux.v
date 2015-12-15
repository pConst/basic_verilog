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

// baeckler - 10-28-2006

/////////////////////////////////////////////////////

module bus_mux (din,sel,dout);

parameter DAT_WIDTH = 16;
parameter SEL_WIDTH = 3;
parameter TOTAL_DAT = DAT_WIDTH << SEL_WIDTH;
parameter NUM_WORDS = (1 << SEL_WIDTH);

input [TOTAL_DAT-1 : 0] din;
input [SEL_WIDTH-1:0] sel;
output [DAT_WIDTH-1:0] dout;

genvar i,k;
generate
	for (k=0;k<DAT_WIDTH;k=k+1)
	begin : out
		wire [NUM_WORDS-1:0] tmp;
		for (i=0;i<NUM_WORDS;i=i+1)
		begin : mx
			assign tmp [i] = din[k+i*DAT_WIDTH];
		end
		assign dout[k] = tmp[sel];
	end
endgenerate
endmodule
