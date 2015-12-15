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

// baeckler - 01-08-2009

module gearbox_32_33 (
	input clk,arst,
	input [31:0] din,  // bit 0 is sent first
	input din_valid,
	input din_slip,		// drop bit 0 of the current din
	output [32:0] dout, // bit 0 is sent first
	output reg dout_valid
);

reg [63:0] storage;
reg [5:0] holding;

// make it explicit that holding will never be greater than 32
// to help synthesis with the shifter
wire [63:0] aligned_din = holding[5] ? 
				{din,32'b0} :
				(din << holding[4:0]);

always @(posedge clk or posedge arst) begin
	if (arst) begin
		holding <= 0;
		storage <= 0;
		dout_valid <= 1'b0;
	end
	else begin
		dout_valid <= 1'b0;
		if (din_valid) begin
			
			if (din_slip) begin
				// with 31 in and 33 out, holding decreases by 2, mod 33
				if (holding == 0) holding <= 6'd31;
				else if (holding == 1) holding <= 6'd32;
				else holding <= holding - 6'd2;
			end
			else begin
				// with 32 in and 33 out, holding decreases by 1, mod 33
				if (holding == 0) holding <= 6'd32;
				else holding <= holding - 6'd1;
			end
			
			// when you are holding 32 bits there is no output,
			// don't shift the storage, otherwise remove the low
			// order 33 bits.
			storage <= (holding[5] ? storage : (storage >> 6'd33)) |
						 (din_slip ? (aligned_din >> 1'b1) : aligned_din);		
						 
			// the output will be valid unless we are not holding any
			// bits at all.
			dout_valid <= (holding == 0) ? 1'b0 :
						 (din_slip && holding == 6'd1) ? 1'b0 :
						 1'b1;
		end
	end
end

assign dout = storage [32:0];

endmodule