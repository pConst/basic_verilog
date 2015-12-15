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

// baeckler - 01-09-2009

module gearbox_66_32 (
	input clk,arst,
	input [65:0] din,
	input din_valid,
	output din_ready,
	output[31:0] dout,
	input dout_ready,
	output dout_valid
);

///////////////////////////////
// Cut in half to 33 bit words

wire [32:0] gb33_dout;
wire gb33_dout_ready, gb33_dout_valid;

two_to_one tto (
	.clk(clk),
	.arst(arst),
	.din(din),
	.din_valid(din_valid),
	.din_ready(din_ready),
	.dout(gb33_dout),
	.dout_ready(gb33_dout_ready),
	.dout_valid(gb33_dout_valid)	
);
defparam tto .WORD_LEN = 33;

///////////////////////////////
// Convert 33 to 32

gearbox_33_32 gb32 (
	.clk(clk),
	.arst(arst),
	.din(gb33_dout),
	.din_valid(gb33_dout_valid),
	.din_ready(gb33_dout_ready),
	.dout(dout),
	.dout_ready(dout_ready),
	.dout_valid(dout_valid)	
);

endmodule