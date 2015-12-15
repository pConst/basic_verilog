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
// baeckler - 12-14-2009

module gearbox_20_22 (
	input clk,
	
	input odd,			// select a shift by 1 bit of the data 
	input drop2,		// slip to lose 2 bits of data
	
	input [19:0] din,	// lsbit used first
	
	output reg [21:0] dout,
	output reg dout_valid
);

reg [19:0] din_r = 20'h0;
reg extra_din_r = 1'b0;
always @(posedge clk) begin
	if (odd) begin
		{extra_din_r,din_r} <= {din,extra_din_r};
	end
	else begin
		din_r <= din;
	end
end

reg [3:0] gbstate = 4'b0 /* synthesis preserve */;
always @(posedge clk) begin
	if (gbstate == 4'ha) gbstate <= 4'h0;
	else gbstate <= gbstate + (drop2 ? 2'd2 : 2'd1);
end

reg [20 + 20 - 1:0] storage = 39'b0;
reg dout_valid_i = 1'b0;
always @(posedge clk) begin
	case (gbstate)
		4'h0: storage <= {20'b0,din_r};		
		4'h1: storage <= {din_r,storage[19:0]};		
		4'h2: storage <= {2'b0,din_r,storage[39:22]};
		4'h3: storage <= {4'b0,din_r,storage[37:22]};
		4'h4: storage <= {6'b0,din_r,storage[35:22]};
		4'h5: storage <= {8'b0,din_r,storage[33:22]};
		4'h6: storage <= {10'b0,din_r,storage[31:22]};
		4'h7: storage <= {12'b0,din_r,storage[29:22]};
		4'h8: storage <= {14'b0,din_r,storage[27:22]};
		4'h9: storage <= {16'b0,din_r,storage[25:22]};
		4'ha: storage <= {18'b0,din_r,storage[23:22]};
		default: storage <= {20'b0,din_r};				
	endcase
	dout_valid_i <= |gbstate;
end

initial dout = 22'b0;
initial dout_valid = 1'b0;
always @(posedge clk) begin
	dout_valid <= dout_valid_i;
	dout <= storage [21:0];
end

endmodule