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

module float_to_fixed (
	float_in,
	fixed_sign,
	fixed_mag
);

parameter FIXED_WIDTH = 8; // must not be > 32
parameter FIXED_FRACTIONAL = 4;

input [31:0] float_in;
output fixed_sign;
output [FIXED_WIDTH-1:0] fixed_mag;
	
	wire [7:0] float_exp;
	wire [22:0] float_mantissa;
	assign {fixed_sign, float_exp, float_mantissa} = float_in;

	wire [31:0] working_out = {1'b1,float_mantissa,8'h0};
	
	wire [7:0] shift_dist = 8'd127 + (FIXED_WIDTH-FIXED_FRACTIONAL) - 1
					- float_exp;
	wire [4:0] trunc_shift_dist = (|shift_dist[7:5]) ? 5'b11111 : shift_dist[4:0];

	wire [31:0] shifted_out = working_out >> trunc_shift_dist;
	
	assign fixed_mag = 	shifted_out[31:32-FIXED_WIDTH];
	
endmodule
