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

// baeckler - 01-09-2008

module gearbox_33_32 (
	input clk,arst,
	
	input [32:0] din,
	input din_valid,
	output din_ready,
	
	output [31:0] dout,
	output reg dout_valid,
	input dout_ready	
);

reg [4:0] holding;
reg holding_32;
reg [63:0] storage;

assign din_ready = dout_ready & !holding_32;

// holding will never be >= 32
wire [63:0] aligned_din = (din << holding);
				
always @(posedge clk or posedge arst) begin
	if (arst) begin
		storage <= 0;
		holding <= 0;
		holding_32 <= 0;
		dout_valid <= 1'b0;
	end
	else begin
		if (dout_ready) dout_valid <= 1'b0;
		
		if (holding_32) begin
			holding <= 0;							
			holding_32 <= 0;
			storage <= (storage >> 32);			
			dout_valid <= 1'b1;
		end
		else begin
			if (din_ready & din_valid) begin
				storage <= (storage >> 32) | aligned_din;		
				
				// when holding 31, 33 in, there are enough
				// bits for TWO words out.
				if (&holding) begin
					holding <= 0;
					holding_32 <= 1'b1;
				end
				else begin			
					holding <= holding + 1'b1;
				end
				dout_valid <= 1'b1;		
			end					
		end
	end
end

assign dout = storage [31:0];

endmodule