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

// baeckler 01-27-2010
// #delay the bus randomly by 0..7 increments of the delay parameter

`timescale 1 ps / 1 ps
module random_delay #(
	parameter D_INCREMENT = 100,
	parameter WIDTH = 8
)(
	input [WIDTH-1:0] din,
	output reg [WIDTH-1:0] dout
);
	
reg [2:0] delay_sel;
initial delay_sel = $random;

always @(*) begin
	case (delay_sel) 
		3'h0 : dout = din;
		3'h1 : dout = #D_INCREMENT din;
		3'h2 : dout = #(D_INCREMENT*2) din;
		3'h3 : dout = #(D_INCREMENT*3) din;
		3'h4 : dout = #(D_INCREMENT*4) din;
		3'h5 : dout = #(D_INCREMENT*5) din;
		3'h6 : dout = #(D_INCREMENT*6) din;
		3'h7 : dout = #(D_INCREMENT*7) din;		
	endcase
end
endmodule

