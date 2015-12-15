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

// baeckler - 12-17-2008

// Order:
// given 76543210, fedcba98, nmlkjihg
// output jihg fedcba98 76543210 as the first word

module eight_to_twenty #(
	parameter WORD_LEN = 66
)
(
	input clk,arst,
	
	input [8*WORD_LEN-1:0] din, 
	input din_valid,
	output din_ready,
	
	output reg [20*WORD_LEN-1:0] dout,
	input dout_ready,
	output reg dout_valid		
);

// Possible states :
//	 0 : 20 out, no residue 
//   1 : holding 8 words
//   2 : holding 16 words
//   3 : 20 out, holding residue of 4
//   4 : holding 12 words
reg [4:0] state;

wire input_wait = din_ready & !din_valid;
wire output_wait = dout_valid & !dout_ready;
assign din_ready = !output_wait;

always @(posedge clk or posedge arst) begin
	if (arst) state <= 5'b1;
	else if (!input_wait & !output_wait)
		state <= {state [3:0],state[4]};
end

reg [4*WORD_LEN-1:0] surplus;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		dout <= 0;
		dout_valid <= 0;
	end
	else begin
		if (!input_wait & !output_wait) begin
			if (state[0]) begin
				dout[8*WORD_LEN-1:0] <= din;
			end
			if (state[1]) begin
				dout[16*WORD_LEN-1:8*WORD_LEN] <= din;
			end
			if (state[2]) begin
				dout[20*WORD_LEN-1:16*WORD_LEN] <= din[4*WORD_LEN-1:0];
				surplus <= din[8*WORD_LEN-1:4*WORD_LEN];
				dout_valid <= 1'b1;
			end
			if (state[3]) begin
				dout[4*WORD_LEN-1:0] <= surplus;
				dout[12*WORD_LEN-1:4*WORD_LEN] <= din;
			end
			if (state[4]) begin
				dout[20*WORD_LEN-1:12*WORD_LEN] <= din;			
				dout_valid <= 1'b1;
			end
		end	
		
		if (dout_valid & dout_ready) dout_valid <= 1'b0;				
	end	
end
endmodule
