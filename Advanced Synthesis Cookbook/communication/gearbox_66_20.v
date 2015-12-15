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
// BLOCK 5,4
// baeckler - 12-14-2009

module gearbox_66_20 (
	input clk,
	input sclr,			// fixes the state, although not the data registers for reduced fanout
	input [65:0] din,	// lsbit sent first
	output reg din_ack,
	output reg [19:0] dout
);

reg [65:0] din_r  = 0 /* synthesis preserve */;
always @(posedge clk) begin
	if (din_ack) din_r <= din;
end

reg [5:0] gbstate  = 0 /* synthesis preserve */;
always @(posedge clk) begin
	if (gbstate[5] | sclr) gbstate <= 6'b0;
	else gbstate <= gbstate + 1'b1;	
end

reg [3:0] muxop = 0 /* synthesis preserve */;
always @(posedge clk) begin
	case (gbstate)
		6'h0 : muxop <= 4'h1; // (66 in to position shl 0) 20 out, residue 46
		6'h1 : muxop <= 4'h0; // 20 out, residue 26
		6'h2 : muxop <= 4'h0; // 20 out, residue 6
		6'h3 : muxop <= 4'h4; // (66 in to position shl 6) 20 out, residue 52
		6'h4 : muxop <= 4'h0; // 20 out, residue 32
		6'h5 : muxop <= 4'h0; // 20 out, residue 12
		6'h6 : muxop <= 4'h7; // (66 in to position shl 12) 20 out, residue 58
		6'h7 : muxop <= 4'h0; // 20 out, residue 38
		6'h8 : muxop <= 4'h0; // 20 out, residue 18
		6'h9 : muxop <= 4'ha; // (66 in to position shl 18) 20 out, residue 64
		6'ha : muxop <= 4'h0; // 20 out, residue 44
		6'hb : muxop <= 4'h0; // 20 out, residue 24
		6'hc : muxop <= 4'h0; // 20 out, residue 4
		6'hd : muxop <= 4'h3; // (66 in to position shl 4) 20 out, residue 50
		6'he : muxop <= 4'h0; // 20 out, residue 30
		6'hf : muxop <= 4'h0; // 20 out, residue 10
		6'h10 : muxop <= 4'h6; // (66 in to position shl 10) 20 out, residue 56
		6'h11 : muxop <= 4'h0; // 20 out, residue 36
		6'h12 : muxop <= 4'h0; // 20 out, residue 16
		6'h13 : muxop <= 4'h9; // (66 in to position shl 16) 20 out, residue 62
		6'h14 : muxop <= 4'h0; // 20 out, residue 42
		6'h15 : muxop <= 4'h0; // 20 out, residue 22
		6'h16 : muxop <= 4'h0; // 20 out, residue 2
		6'h17 : muxop <= 4'h2; // (66 in to position shl 2) 20 out, residue 48
		6'h18 : muxop <= 4'h0; // 20 out, residue 28
		6'h19 : muxop <= 4'h0; // 20 out, residue 8
		6'h1a : muxop <= 4'h5; // (66 in to position shl 8) 20 out, residue 54
		6'h1b : muxop <= 4'h0; // 20 out, residue 34
		6'h1c : muxop <= 4'h0; // 20 out, residue 14
		6'h1d : muxop <= 4'h8; // (66 in to position shl 14) 20 out, residue 60
		6'h1e : muxop <= 4'h0; // 20 out, residue 40
		6'h1f : muxop <= 4'h0; // 20 out, residue 20
		6'h20 : muxop <= 4'h0; // 20 out, residue 0
		default : muxop <= 4'h0;
	endcase
end

reg [18+66-1:0] storage = 0;
always @(posedge clk) begin
	if (sclr) din_ack <= 1'b0;
	else din_ack <= |muxop;
	case (muxop)
		4'h0 : storage <= {18'h0,storage[83:20]};
		4'h1 : storage <= {18'h0,din_r};
		4'h2 : storage <= {16'b0,din_r,storage[21:20]}; // din shl 2
		4'h3 : storage <= {14'b0,din_r,storage[23:20]}; // din shl 4
		4'h4 : storage <= {12'b0,din_r,storage[25:20]}; // din shl 6
		4'h5 : storage <= {10'b0,din_r,storage[27:20]}; // din shl 8
		4'h6 : storage <= {8'b0,din_r,storage[29:20]}; // din shl 10
		4'h7 : storage <= {6'b0,din_r,storage[31:20]}; // din shl 12
		4'h8 : storage <= {4'b0,din_r,storage[33:20]}; // din shl 14
		4'h9 : storage <= {2'b0,din_r,storage[35:20]}; // din shl 16
		4'ha : storage <= {din_r,storage[37:20]}; // din shl 18
		default : storage <= {18'h0,storage[83:20]};
	endcase
end

initial dout = 20'b0;
always @(posedge clk) begin
	dout <= storage [19:0];
end

endmodule