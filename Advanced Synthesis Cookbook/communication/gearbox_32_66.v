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

module gearbox_32_66 (
	input clk,arst,
	input [31:0] din,  // bit 0 is sent first
	input din_valid,
	input slip_to_frame,
	output [65:0] dout, // bit 0 is sent first
	output dout_valid,
	
	// this is the number of bit slips used to find the lock
	// intended for debug / test
	output reg [6:0] slip_count
);

////////////////////////////////////
// workhorse 32 to 33 unit

reg gb33_slip;
wire [32:0] gb33_dout;
wire gb33_dout_valid;

gearbox_32_33 gb33 (
	.clk(clk),
	.arst(arst),
	.din(din),  // bit 0 is sent first
	.din_valid(din_valid),
	.din_slip(gb33_slip),	// drop bit 0 of the current din
	.dout(gb33_dout), // bit 0 is sent first
	.dout_valid(gb33_dout_valid)
);
wire correct_framing = ^gb33_dout[1:0];

////////////////////////////////////
// alternate 33 bit halves with slip control

reg first_half;
reg [32:0] prev_word;

always @(posedge clk or posedge arst) begin
	if (arst) begin 
		first_half <= 1'b1;
		gb33_slip <= 1'b0;
		prev_word <= 33'b0;
		slip_count <= 7'h0;
	end
	else begin
		if (din_valid) gb33_slip <= 1'b0;
	
		// alternate reading 33 bit halves
		if (gb33_dout_valid) begin
			first_half <= ~first_half;
			if (first_half) prev_word <= gb33_dout;
		end
		
		// when in search mode check the framing bits
		// they should be different if the alignment 
		// is correct.
		
		if (slip_to_frame) begin
			if (gb33_dout_valid & first_half & !correct_framing) begin
				// this isn't right, do a slip
				gb33_slip <= 1'b1;	
				slip_count <= slip_count + 1'b1;
			end
		end		
	end
end

assign dout = {gb33_dout,prev_word};
assign dout_valid = gb33_dout_valid & !first_half;

endmodule