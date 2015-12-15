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

// baeckler - 12-04-2008
// Ethernet 10/40/100G style FEC insertion + PN2112 scramble

module fec_gen (
	input clk,arst,
	input [31:0] din,
	input parity_sel,	// the next tick's dout is to be the parity word
	output reg [31:0] dout
);

`include "reverse_32.inc"

///////////////////////////
// parity workhorse

reg [31:0] parity;
wire [31:0] next_parity;

fec_parity fs (.c(parity),.d(din),.co(next_parity));

///////////////////////////
// pseudo noise scrambler
wire [31:0] pn_val_w;
reg [31:0] pn_val;
reg [6:0] pn_cntr;

pn2112_table pn (
	.din(pn_cntr),
	.dout(pn_val_w)
);

always @(posedge clk) begin
	if (arst) begin
		pn_val <= 0;
		pn_cntr <= 0;
	end
	else begin
		pn_val <= pn_val_w;
		if (parity_sel) begin
			pn_cntr <= 1'b1;
			pn_val <= 32'hffffffff;
		end
		else begin
			if (pn_cntr == 7'd65) pn_cntr <= 0;
			else pn_cntr <= pn_cntr + 1'b1;
		end
	end
end

///////////////////////////
// output register

always @(posedge clk or posedge arst) begin
    if (arst) begin
		parity <= 0;
		dout <= 0;		
	end
    else begin
		parity <= parity_sel ? 32'b0 : next_parity;
		dout <= (parity_sel ? reverse_32(parity) : din) ^ pn_val;
	end
end

endmodule

