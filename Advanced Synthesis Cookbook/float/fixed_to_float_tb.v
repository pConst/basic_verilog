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

module fixed_to_float_tb ();

parameter FIXED_WIDTH = 12; // must not be > 32
parameter FIXED_FRACTIONAL = 4;

wire [31:0] float_out;
reg [FIXED_WIDTH-1:0] mag;
wire  [FIXED_WIDTH-1:0] recovered_mag;
reg sign_in;
wire sign_out;

//////////////////////////////////////
// test units - requested width
//////////////////////////////////////
fixed_to_float tof
(
	.fixed_sign (sign_in),
	.fixed_mag (mag),
	.float_out (float_out)
);

defparam tof .FIXED_WIDTH = FIXED_WIDTH;
defparam tof .FIXED_FRACTIONAL = FIXED_FRACTIONAL;

float_to_fixed fromf 
(
	.float_in(float_out),
	.fixed_mag(recovered_mag),
	.fixed_sign(sign_out)
);

defparam fromf .FIXED_WIDTH = FIXED_WIDTH;
defparam fromf .FIXED_FRACTIONAL = FIXED_FRACTIONAL;

//////////////////////////////////////
// test units - 
//   additional unused fraction bits
//////////////////////////////////////
wire [31:0] float_out_b;
wire [FIXED_WIDTH+4-1:0] recovered_mag_b;

fixed_to_float tof_b
(
	.fixed_sign (sign_in),
	.fixed_mag ({mag,4'h0}),
	.float_out (float_out_b)
);

defparam tof_b .FIXED_WIDTH = FIXED_WIDTH + 4;
defparam tof_b .FIXED_FRACTIONAL = FIXED_FRACTIONAL + 4;

float_to_fixed fromf_b 
(
	.float_in(float_out_b),
	.fixed_mag(recovered_mag_b),
	.fixed_sign()
);

defparam fromf_b .FIXED_WIDTH = FIXED_WIDTH + 4;
defparam fromf_b .FIXED_FRACTIONAL = FIXED_FRACTIONAL + 4;

//////////////////////////////////////
// test units - 
//   additional unused ones bits
//////////////////////////////////////
wire [31:0] float_out_c;
wire [FIXED_WIDTH+4-1:0] recovered_mag_c;

fixed_to_float tof_c
(
	.fixed_sign (sign_in),
	.fixed_mag ({4'h0,mag}),
	.float_out (float_out_c)
);

defparam tof_c .FIXED_WIDTH = FIXED_WIDTH + 4;
defparam tof_c .FIXED_FRACTIONAL = FIXED_FRACTIONAL;

float_to_fixed fromf_c 
(
	.float_in(float_out_c),
	.fixed_mag(recovered_mag_c),
	.fixed_sign()
);

defparam fromf_c .FIXED_WIDTH = FIXED_WIDTH + 4;
defparam fromf_c .FIXED_FRACTIONAL = FIXED_FRACTIONAL;


//////////////////////////////////////
// stim and check
//////////////////////////////////////
reg fail;
initial begin
	fail = 1'b0;
	mag = 0;
	sign_in = 1'b0;

	#10000000 if (!fail) $display ("PASS");
	$stop();
end

always begin
	#5 

	// 
	// Verify to_fixed(to_float(x)) == x
	//
	if ((sign_out !== sign_in) ||
		(recovered_mag !== mag))
	begin
		$display ("Mismatch at time %d - transitivity",$time);
		fail = 1'b1;
		#200
		$stop();
	end
	
	//
	// Verify some different fixed pt versions 
	// of the same number have the same floating pt
	//
	if ((float_out !== float_out_b) ||
		(float_out !== float_out_c))
	begin
		$display ("Mismatch at time %d - B and C comparison",$time);
		fail = 1'b1;
		#200
		$stop();
	end		

	#100
	mag = $random; 
	sign_in = $random;
	
end

endmodule