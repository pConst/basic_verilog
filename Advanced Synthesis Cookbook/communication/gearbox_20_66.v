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

`timescale 1 ps / 1 ps
// BLOCK 4,3
// baeckler - 12-14-2009

module gearbox_20_66 (
	input clk,
	input slip_to_frame, // look for ethernet framing, [1:0] opposite
	input [19:0] din, // lsbit used first
	output reg [65:0] dout,
	output reg dout_valid
);

wire [21:0] dout_22;
wire dout_22_valid;

// framing control
wire framed = ^dout[1:0];
reg odd = 1'b0;
reg drop2 = 1'b0;

// helper gearbox
gearbox_20_22 gba (
	.clk(clk),
	
	.odd(odd),
	.drop2(drop2),
	
	.din(din),	// lsbit used first
	.dout(dout_22),
	.dout_valid(dout_22_valid)
);

// combine 3 words of 22 to one 66
reg [1:0] gbstate = 0 /* synthesis preserve */;

wire [21:0] dout_mid,dout_low;
assign {dout_mid,dout_low} = dout[43:0];

always @(posedge clk) begin
	dout_valid <= 1'b0;
	drop2 <= 1'b0;
	
	case (gbstate)
		2'h0 : begin
			if (dout_22_valid) begin
				dout <= {22'h0,22'h0,dout_22};
				gbstate <= 2'h1;	
			end
		end
		2'h1 : begin
			if (slip_to_frame & !framed) begin
				if (!odd) odd <= 1'b1;
				else begin
					drop2 <= 1'b1;
					odd <= 1'b0;
				end
			end
			
			if (dout_22_valid) begin
				dout <= {22'h0,dout_22,dout_low};
				gbstate <= 2'h2;	
			end
		end
		2'h2 : begin
			if (dout_22_valid) begin
				dout <= {dout_22,dout_mid,dout_low};
				gbstate <= 2'h0;	
				dout_valid <= 1'b1;
			end
		end
		
		2'h3 : begin
			// this is an illegal state.   Recover
			gbstate <= 2'h0;
		end
	endcase
end

endmodule