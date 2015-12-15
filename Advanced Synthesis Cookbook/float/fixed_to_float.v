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

module fixed_to_float (
	fixed_sign,
	fixed_mag,
	float_out
);

parameter FIXED_WIDTH = 8; // must not be > 32
parameter FIXED_FRACTIONAL = 4;

input fixed_sign;
input [FIXED_WIDTH-1:0] fixed_mag;
output [31:0] float_out;

	wire [7:0] exponent;
	wire [31:0] unscaled_mantissa = fixed_mag << (32-FIXED_WIDTH);
	wire [31:0] scaled_mantissa;
	wire [4:0] scale_distance;

	scale_up sc (.in(unscaled_mantissa),
				.out(scaled_mantissa),
				.distance(scale_distance));
		defparam sc .WIDTH = 32;
		defparam sc .WIDTH_DIST = 5;

	assign exponent = 8'd127 + (FIXED_WIDTH-FIXED_FRACTIONAL) - 1
						- scale_distance;

	// Zero is special and gets an exponent of 0, not "something very small"
	assign float_out = &scale_distance ? {fixed_sign,31'h0} :
					{fixed_sign, exponent, scaled_mantissa[30:8]};
	
endmodule
