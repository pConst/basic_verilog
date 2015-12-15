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

// baeckler - 04-20-2007

// shift "in" left until the most significant bit is a "1"
// pass the shifted value, and number of shifts required
// to the output.

module scale_up (in,out,distance);

parameter WIDTH = 16;
parameter WIDTH_DIST = 4;

input [WIDTH-1:0] in;
output [WIDTH-1:0] out;
output [WIDTH_DIST-1:0] distance;

wire [(WIDTH_DIST+1) * WIDTH-1:0] shift_layers;
assign shift_layers [WIDTH-1:0] = in;

genvar i;
generate
	for (i=0;i<WIDTH_DIST;i=i+1)
	begin : shft
		wire [WIDTH-1:0] layer_in;
		wire [WIDTH-1:0] shifted_out;
		wire [WIDTH-1:0] layer_out;
		
		assign layer_in = shift_layers[(i+1)*WIDTH-1:i*WIDTH];

		// are there ones in the upper part?
		wire shift_desired = ~|(layer_in[WIDTH-1:WIDTH-(1 << (WIDTH_DIST-1-i))]);
		assign distance[(WIDTH_DIST-1-i)] = shift_desired;

		// barrel shifter
		assign shifted_out = layer_in << (1 << (WIDTH_DIST-1-i));
		assign layer_out = shift_desired ? shifted_out : layer_in;
		
		assign shift_layers[(i+2)*WIDTH-1:(i+1)*WIDTH] = layer_out;
								
	end
endgenerate

assign out = shift_layers[(WIDTH_DIST+1)*WIDTH-1 : WIDTH_DIST*WIDTH];

endmodule