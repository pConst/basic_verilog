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
// baeckler - 09-23-2008

module frame_sync_control (
	input clk, arst,
	input [64:0] din,
	input din_valid,
	input word_locked,
	output reg sync_locked,
	output good_sync,
	output missing_sync,
		
	output scrambler_load,
	output scrambler_evolve,
	input scrambler_match,
	input scrambler_mismatch,
	
	output check_crc32
);

`include "log2.inc"

parameter META_FRAME_LEN = 10; // words per metaframe
localparam META_CNTR_BITS = log2(META_FRAME_LEN-1);

/////////////////////////////////////////
// 
reg sync_detected;
always @(posedge clk or posedge arst) begin
	if (arst) sync_detected <= 0;
	else if (din_valid) sync_detected <= (din == {1'b1,64'h78f678f678f678f6});
end

/////////////////////////////////////////
// Where are we within the metaframe?

reg [META_CNTR_BITS-1:0] meta_cntr;
reg meta_cntr_max;
reg expect_sync_word,expect_scram_state,expect_skip,expect_payload,expect_diag;
wire advance_meta = din_valid;
reg hold_meta; 

always @(posedge clk or posedge arst) begin
	if (arst) begin
		meta_cntr <= 0;
		meta_cntr_max <= 0;		
		expect_sync_word <= 0;
		expect_scram_state <= 0;
		expect_skip <= 0;
		expect_diag <= 0;
	end
	else begin
		if (hold_meta) begin
			// freeze waiting for the sync word
			meta_cntr <= 1;
			meta_cntr_max <= 0;		
			expect_sync_word <= 1'b1;
			expect_scram_state <= 0;
			expect_skip <= 0;
			expect_diag <= 0;
		end
		else if (advance_meta) begin
			meta_cntr_max <= (meta_cntr == META_FRAME_LEN-2);
			if (meta_cntr_max) meta_cntr <= 0;
			else meta_cntr <= meta_cntr + 1'b1;
			
			expect_sync_word <= ~|meta_cntr;
			expect_scram_state <= expect_sync_word;
			expect_skip <= expect_scram_state;
			expect_payload <= expect_payload | expect_skip;
			expect_diag <= 1'b0;
			if (meta_cntr == (META_FRAME_LEN-1)) begin
				expect_payload <= 1'b0;
				expect_diag <= 1'b1;
			end									
		end
	end
end

/////////////////////////////////
// tally up expected or missing 
// sync words
/////////////////////////////////
reg last_din_valid;
always @(posedge clk or posedge arst) begin
	if (arst) last_din_valid <= 1'b0;
	else last_din_valid <= din_valid;
end
assign good_sync = last_din_valid & expect_sync_word & sync_detected;
assign missing_sync = last_din_valid & expect_sync_word & !sync_detected;

reg [2:0] sync_tally;
reg rst_sync_tally, inc_sync_tally;
always @(posedge clk or posedge arst) begin
	if (arst) sync_tally <= 0;
	else begin
		if (rst_sync_tally) sync_tally <= 0;
		else if (inc_sync_tally) sync_tally <= sync_tally + 1'b1;
	end
end

/////////////////////////////////
// Watch the scrambler synch
//   3 consecutive problems = lost lock
/////////////////////////////////
reg [1:0] scramble_miss_cntr;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		scramble_miss_cntr <= 0;
	end
	else begin
		if (scrambler_match | !sync_locked) 
			scramble_miss_cntr <= 0;
		else if (scrambler_mismatch & (scramble_miss_cntr != 2'b11)) 
			scramble_miss_cntr <= scramble_miss_cntr + 1'b1;		
	end
end

/////////////////////////////////
// tell the scrambler and CRC what to do
/////////////////////////////////
assign scrambler_load = last_din_valid & expect_scram_state;
assign scrambler_evolve = last_din_valid & 
		(!expect_sync_word & !expect_scram_state);
assign check_crc32 = last_din_valid & expect_diag;

/////////////////////////////////
// Little control machine
//   implementing figure 5-10 from Interlaken 1.1 spec
/////////////////////////////////
localparam ST_RESET = 2'h0,
		ST_SEARCH = 2'h1,
		ST_VERIFY = 2'h2,
		ST_LOCKED = 2'h3;

reg [1:0] state,next_state;

always @(*) begin
	next_state = state;
	sync_locked = 1'b0;
	inc_sync_tally = 1'b0;
	rst_sync_tally = 1'b0;
	hold_meta = 1'b0;
	
	case (state)
		ST_RESET : begin
				next_state = ST_SEARCH;
			end
		ST_SEARCH : begin
				hold_meta = 1'b1;
				rst_sync_tally = 1'b1;
				if (good_sync) next_state = ST_VERIFY;
			end
		ST_VERIFY : begin
				// I want to see 3 more consecutive good sync words to lock
				if (good_sync) inc_sync_tally = 1'b1;
				if (missing_sync) next_state = ST_SEARCH;
				else if (sync_tally == 3'b011) begin
					next_state = ST_LOCKED;
					rst_sync_tally = 1'b1;
				end
			end
		ST_LOCKED : begin
				// Drop lock if there are 
				//   4 consecutive bad sync words 
				//   3 consecutive scrambler state problems 
				sync_locked = 1'b1;
				if (missing_sync) inc_sync_tally = 1'b1;
				if (good_sync) rst_sync_tally = 1'b1;
				else if (sync_tally == 3'b100 || scramble_miss_cntr == 2'b11)
					next_state = ST_SEARCH;				
			end		
	endcase
end

always @(posedge clk or posedge arst) begin
	if (arst) state <= ST_RESET;
	else state <= (!word_locked ? ST_RESET : next_state);
end

endmodule