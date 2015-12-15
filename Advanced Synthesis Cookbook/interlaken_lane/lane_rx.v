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

// baeckler - 09-22-2008
// single lane 20 bit RX including alignment, descramble, CRC

module lane_rx (
	input clk,arst,
	input [19:0] din,
	output reg [65:0] dout,  // [65]=1 indicates sync [64]=1 indicates control words
	output reg dout_valid,
	output word_locked,
	output sync_locked,
	output framing_error,
	output crc32_error,
	output scrambler_mismatch,
	output missing_sync		
);

parameter META_FRAME_LEN = 10;
parameter PN_REVERSE = 1'b0;
parameter SKIP_RX_CRC32 = 1'b0;

wire [66:0] gearbox_dout;
wire gearbox_dout_valid;
wire slip_to_frame;

/////////////////////////
// 20 to 67 bit gearbox
gearbox_20_67 gb (
	.clk(clk),.arst(arst),
	.din(din),
	.slip_to_frame(slip_to_frame),	// 1=slip until you hit a properly framed word
	.dout(gearbox_dout),
	.dout_valid(gearbox_dout_valid)	
);

/////////////////////////
// Lock on framing bits
wire din_framed = gearbox_dout[65] ^ gearbox_dout[64];
word_align_control wac (
	.clk(clk), .arst(arst),
	.din_framed(din_framed),
	.din_valid(gearbox_dout_valid),
	.slip_to_frame(slip_to_frame),
	.word_locked(word_locked)	
);

/////////////////////////
// Undo disparity inverts
wire [64:0] dec_dout;
dec_67_64 dec (
	.clk(clk), .arst(arst),
	.din(gearbox_dout), 
	.pn_reverse(PN_REVERSE),
	.dout(dec_dout), // bit 64=1 indicates control word
	.framing_error(framing_error)
);

/////////////////////////
// Grab the decoded word
reg [64:0] last_valid_word;
reg last_gearbox_dout_valid;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		last_valid_word <= 0;
		last_gearbox_dout_valid <= 0;
	end
	else begin
		if (gearbox_dout_valid) last_valid_word <= dec_dout;
		last_gearbox_dout_valid <= gearbox_dout_valid;
	end
end

/////////////////////////
// Scrambler 
wire [63:0] scrambler_q;
wire scrambler_evolve;
wire scrambler_load;
wire [57:0] scrambler_load_val = last_valid_word[57:0];
wire scrambler_match;

scrambler_lfsr scr (
	.clk(clk),
	.arst(arst),
	.verify(scrambler_load & sync_locked),
	.load(scrambler_load & !sync_locked),
	.load_d(scrambler_load_val),
	.evolve(scrambler_evolve),
	.q(scrambler_q),
	.verify_fail(scrambler_mismatch),	   
	.verify_pass(scrambler_match)	   
);

/////////////////////////
// Lock on synchronization words
//  and keep the scrambler and CRC on task
wire good_sync, check_crc32;
frame_sync_control fsc (
	.clk(clk), .arst(arst),
	.din(dec_dout),
	.din_valid(gearbox_dout_valid),
	.word_locked(word_locked),
	.sync_locked(sync_locked),
	.good_sync(good_sync),
	.missing_sync(missing_sync),
	.scrambler_load(scrambler_load),
	.scrambler_evolve(scrambler_evolve),
	.scrambler_match(scrambler_match),
	.scrambler_mismatch(scrambler_mismatch),
	.check_crc32(check_crc32)
);
defparam fsc .META_FRAME_LEN = META_FRAME_LEN;

/////////////////////////
// Undo the scrambling
always @(posedge clk or posedge arst) begin
	if (arst) begin
		dout <= 0;
		dout_valid <= 0;
	end
	else begin
		if (good_sync | missing_sync) begin
			dout <= {1'b1,last_valid_word};
			dout_valid <= 1'b1;
		end
		else if (scrambler_evolve) begin
			dout <= {1'b0,(last_valid_word ^ scrambler_q)};
			dout_valid <= 1'b1;
		end
		else if (scrambler_load) begin
			dout <= {1'b0,last_valid_word & {1'b1,6'b111111,58'h0}}; 
				// blank out the scrambler state in RX data 
			dout_valid <= 1'b1;
		end
		else dout_valid <= 1'b0;
	end
end

generate
	if (SKIP_RX_CRC32) begin
		// your data is hereby declared OK.  CRC24 will (most likely) see if it isn't.
		assign crc32_error = 1'b0;
	end
	else begin
		/////////////////////////
		// CRC32 (Castagnoli) check the out stream
		lane_rx_crc lrc (
			.clk(clk),
			.arst(arst),
			.din(dout[63:0]),  // does this really omit thc control bit?  Yes it does.
			.din_fresh(dout_valid),
			.diag_word(check_crc32),
			.crc_error(crc32_error)
		);
	end
endgenerate

endmodule
