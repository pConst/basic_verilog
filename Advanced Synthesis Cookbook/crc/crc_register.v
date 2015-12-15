// Copyright 2007 Altera Corporation. All rights reserved.  
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

// baeckler - 04-03-2006
//
// typical CRC register bank
//   the init constant is defaulted to all 1's for CRC-32
// aclr beats ena beats sclr beats init in terms of signal priority.
//

module crc_register (d, q, clk, init, sclr, ena, aclr);

parameter WIDTH = 32;
parameter METHOD = 1;
parameter INIT_CONST = 32'hffffffff;

input [WIDTH-1:0] d;
input clk,init,sclr,ena,aclr;
output [WIDTH-1:0] q;
reg [WIDTH-1:0] q;

genvar i;
generate
	if (METHOD == 0) begin
		/////////////////////////////////////
		// Generic style.
		//    Depending on the WIDTH setting and surrounding logic the 
		//	synthesis tool may not use the dedicated hardware.  For 
		//  example at WIDTH=1 the LUT implementation is clearly
		//  better.  To force secondary signals use the WYS version below.	
		/////////////////////////////////////
		always @(posedge clk or posedge aclr) begin
			if (aclr) q <= 0;
			else begin
				if (ena) begin
					if (sclr) q <= 0;
					else if (init) q <= INIT_CONST;
					else q <= d;
				end
			end
		end
	end
	else begin
		///////////////////////
		// WYSIWYG style
		///////////////////////
		wire [WIDTH-1:0] q_internal;

		for (i=0; i<WIDTH; i=i+1)
		begin : regs
			stratixii_lcell_ff r (
				.clk(clk),
				.ena(ena),
				.datain (d[i]),
				.sload (init),
				.adatasdata (INIT_CONST[i]),
				.sclr (sclr),
				.aload(1'b0),
				.aclr(aclr),
		
			// These are simulation-only chipwide
			// reset signals.  Both active low.
						
			// synthesis translate_off
				.devpor(1'b1),
				.devclrn(1'b1),
			// synthesis translate on

				.regout (q_internal[i])	
			);
		end

		always @(q_internal) begin
			q = q_internal;
		end
	end
endgenerate

endmodule