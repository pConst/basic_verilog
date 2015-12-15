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

module evolve_key_256_tb ();

reg [255:0] key_in = {
	128'h603deb1015ca71be2b73aef0857d7781,
	128'h1f352c073b6108d72d9810a30914dff4
};

wire [255:0] e0_out,e1_out,e2_out,e3_out,e4_out;

evolve_key_256 e0 (
	.key_in(key_in),
	.rconst(8'h01),
	.key_out(e0_out)
);
defparam e0 .KEY_EVOLVE_TYPE = 0;

evolve_key_256 e1 (
	.key_in(e0_out),
	.rconst(8'h01),
	.key_out(e1_out)
);
defparam e1 .KEY_EVOLVE_TYPE = 1;

evolve_key_256 e2 (
	.key_in(e1_out),
	.rconst(8'h02),
	.key_out(e2_out)
);
defparam e2 .KEY_EVOLVE_TYPE = 0;

evolve_key_256 e3 (
	.key_in(e2_out),
	.rconst(8'h02),
	.key_out(e3_out)
);
defparam e3 .KEY_EVOLVE_TYPE = 1;

evolve_key_256 e4 (
	.key_in(e3_out),
	.rconst(8'h04),
	.key_out(e4_out)
);
defparam e4 .KEY_EVOLVE_TYPE = 0;


initial begin
	#100
	$display ("%x / 603deb10",key_in[255:128]);
	$display ("%x / 1f352c07",e0_out[255:128]);
	$display ("%x / 9ba35411",e1_out[255:128]);
	$display ("%x / a8b09c1a",e2_out[255:128]);
	$display ("%x / d59aecb8",e3_out[255:128]);
	$display ("%x / b5a9328a",e4_out[255:128]);
	$stop();
end

endmodule