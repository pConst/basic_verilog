// Copyright 2011 Altera Corporation. All rights reserved.  
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
// baeckler - 09-19-2008

module word_align_control (
	input clk, arst,
	input din_framed,
	input din_valid,
	output reg slip_to_frame,
	output reg word_locked	
);

////////////////////////////////
// count mis-framed din words
//  stop counting at 16
/////////////////////////////////
reg rst_sync_err_cntr;
reg [4:0] sync_err_cntr;
always @(posedge clk or posedge arst) begin
	if (arst) sync_err_cntr <= 0;
	else begin
		if (rst_sync_err_cntr) sync_err_cntr <= 0;
		else if (din_valid & !din_framed & !sync_err_cntr[4]) 
			sync_err_cntr <= sync_err_cntr + 1'b1;
	end
end

/////////////////////////////////
// count words, modulus 64
/////////////////////////////////
reg rst_word_cntr;
reg [5:0] word_cntr;
reg word_cntr_max;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		word_cntr <= 0;
		word_cntr_max <= 1'b0;
	end
	else begin
		if (rst_word_cntr) begin
			word_cntr <= 0;
			word_cntr_max <= 1'b0;
		end
		else if (din_valid) begin
			word_cntr <= word_cntr + 1'b1;
			word_cntr_max <= (word_cntr == 6'b111110);
		end
	end	
end

/////////////////////////////////
// Little control machine
//   implementing figure 5-10 from Interlaken 1.1 spec
/////////////////////////////////
localparam ST_RESET = 2'h0,
		ST_SLIP = 2'h1,
		ST_VERIFY = 2'h2,
		ST_LOCKED = 2'h3;
		
reg [1:0] state, next_state;

always @(*) begin
	next_state = state;
	slip_to_frame = 1'b0;
	rst_word_cntr = 1'b0;
	rst_sync_err_cntr = 1'b0;
	word_locked = 1'b0;
	
	case (state)
		ST_RESET: begin
			next_state = ST_SLIP;
		end
		ST_SLIP: begin
			slip_to_frame = 1'b1;
			rst_word_cntr = 1'b1;
			if (din_valid & din_framed) next_state = ST_VERIFY;
		end
		ST_VERIFY: begin
			// On any error return to slipping
			// On 64 successful tests goto locked
			if (din_valid & !din_framed) next_state = ST_SLIP;
			else if (word_cntr_max) next_state = ST_LOCKED;			
		end
		ST_LOCKED: begin
			// Look for 16 or more bad syncs in a
			// 64 word window to indicate loss of lock
			word_locked = 1'b1;
			if (word_cntr_max) begin
				rst_sync_err_cntr = 1'b1;
				if (sync_err_cntr[4]) begin
					// lost it.
					next_state = ST_SLIP;
				end				
			end
		end
	endcase
end

always @(posedge clk or posedge arst) begin
	if (arst) state <= ST_RESET;
	else state <= next_state;
end

endmodule