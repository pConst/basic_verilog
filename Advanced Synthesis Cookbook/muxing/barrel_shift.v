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

module barrel_shift (din,dout,distance);

`include "log2.inc"

parameter RIGHT = 1;
parameter WIDTH = 16;
parameter DIST_WIDTH = log2(WIDTH-1);
parameter GENERIC = 0;

localparam MAX_D = 1 << DIST_WIDTH; // The shifting range described by
									// the distance. 

input [WIDTH-1:0] din;
output [WIDTH-1:0] dout;
input [DIST_WIDTH-1:0] distance;

wire [WIDTH-1:0] din_int, dout_int;

// input reversal for ROL
genvar i;
generate
	if (RIGHT) assign din_int = din;
	else begin
		for (i=0; i<WIDTH; i=i+1) 
		begin : revi
			assign din_int[i] = din[WIDTH-1-i];
		end
	end
endgenerate

// rotate right sorting network
rotate_internal r (.din(din_int),.dout(dout_int),.distance(distance));
	defparam r .WIDTH = WIDTH;
	defparam r .DIST_WIDTH = DIST_WIDTH;
	defparam r .GENERIC = GENERIC;

// output reversal for ROL
generate
	if (RIGHT) assign dout = dout_int;
	else begin
		for (i=0; i<WIDTH; i=i+1) 
		begin : revo
			assign dout[i] = dout_int[WIDTH-1-i];
		end
	end
endgenerate

endmodule
