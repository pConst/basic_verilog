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

module synchronizer #(
	parameter WIDTH = 16,
	parameter STAGES = 3 // should not be less than 2
)
(
	input clk_in,arst_in,
	input clk_out,arst_out,
	
	input [WIDTH-1:0] dat_in,
	output [WIDTH-1:0] dat_out	
);

// launch register
reg [WIDTH-1:0] d /* synthesis preserve */;
always @(posedge clk_in or posedge arst_in) begin
	if (arst_in) d <= 0;
	else d <= dat_in;
end

// capture registers
reg [STAGES*WIDTH-1:0] c /* synthesis preserve */;
always @(posedge clk_out or posedge arst_out) begin
	if (arst_out) c <= 0;
	else c <= {c[(STAGES-1)*WIDTH-1:0],d};
end

assign dat_out = c[STAGES*WIDTH-1:(STAGES-1)*WIDTH];

endmodule