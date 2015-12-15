// Copyright 2011 Altera Corporation. All rights reserved.  
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

`timescale 1 ps / 1 ps

// baeckler - 12-17-2008
// Unrolled descrambler LFSR

module descrambler # (
	parameter WIDTH = 512
)(
	input clk,arst,ena,
	input [WIDTH-1:0] din,		// bit 0 is used first
	output reg [WIDTH-1:0] dout
);

reg [57:0] scram_state;
wire [WIDTH+58-1:0] history;
wire [WIDTH-1:0] dout_w;
assign history = {din,scram_state};

genvar i;
generate
	for (i=0; i<WIDTH; i=i+1) begin : lp
		assign dout_w[i] = history[58+i-58] ^ history[58+i-39] ^ history[58+i];		
	end
endgenerate
	
always @(posedge clk or posedge arst) begin
	if (arst) begin
		dout <= 0;
		scram_state <= 58'h3ff_ffff_ffff_ffff;
	end
	else if (ena) begin
		dout <= dout_w;
		scram_state <= history[WIDTH+58-1:WIDTH];
	end
end

endmodule
	