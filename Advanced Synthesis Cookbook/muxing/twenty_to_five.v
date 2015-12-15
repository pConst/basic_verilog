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

// baeckler - 01-22-2009
// accept 20 words, output in chunks of 5
// send the less significant end through first

module twenty_to_five #(
	parameter WORD_LEN = 66
)
(
	input clk,arst,
	
	input [20*WORD_LEN-1:0] din,
	input din_valid,
	output din_ready,
	
	output [5*WORD_LEN-1:0] dout,
	input dout_ready,
	output dout_valid
);

reg [2:0] holding;  // holding 0..4 blocks of 5 words
reg [20*WORD_LEN-1:0] storage;

assign din_ready = 
	(holding == 3'b0) || 
	((holding == 3'b1) && dout_ready);
assign dout_valid = 
	(|holding);
assign dout = storage[5*WORD_LEN-1:0];

always @(posedge clk or posedge arst) begin
	if (arst) begin
		storage <= 0;
		holding <= 0;
	end
	else begin
		if (din_ready & din_valid) begin
			// if we are reloading it goes to 4 blocks available
			storage <= din;
			holding <= 3'b100;
		end
		else begin
			// not reloading
			// if the output side is ready lose one block
			if (dout_valid & dout_ready) begin
				holding <= holding - 1'b1;
				storage <= {{(5*WORD_LEN){1'b0}},
						storage[20*WORD_LEN-1:5*WORD_LEN]}; 
			end
		end
	end
end

endmodule
