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

module lane_tx (
	input clk,arst,
	input [64:0] din,	// bit [64] = 1 indicates control word
	output din_ack,
	output [19:0] dout	
);

`include "log2.inc"

// call all data non-inverted, for debug
parameter DISABLE_DISPARITY = 1'b0;

// the RESET_VAL must be non-zero and 
// for noise should be unique per TX lane
parameter SCRAMBLER_RESET = 58'h1234567_89abcdef;

parameter META_FRAME_LEN = 10; // words per metaframe
localparam META_CNTR_BITS = log2(META_FRAME_LEN-1);

parameter PN_REVERSE = 1'b0;

////////////////////////////////////////////////////////////
// this is the schedule for sending 20 words to the gearbox
// every 67 cycles in order to maintain continuous output.
reg [66:0] schedule /* synthesis preserve */;
always @(posedge clk or posedge arst) begin
	if (arst) schedule <= 67'b1001001000100100100010010010001001001000100100100010010010001001000;
	else schedule <= {schedule[65:0],schedule[66]};
end	

/////////////////////////////////////////
// Where are we within the metaframe?

reg [META_CNTR_BITS-1:0] meta_cntr;
reg meta_cntr_max;
reg send_sync_word,send_scram_state,send_skip,send_payload,send_diag;

wire advance_meta = schedule[61];
always @(posedge clk or posedge arst) begin
	if (arst) begin
		meta_cntr <= 0;
		meta_cntr_max <= 0;		
		send_sync_word <= 0;
		send_scram_state <= 0;
		send_skip <= 0;
		send_payload <= 0;
		send_diag <= 0;
	end
	else begin
		if (advance_meta) begin
			meta_cntr_max <= (meta_cntr == META_FRAME_LEN-2);
			if (meta_cntr_max) meta_cntr <= 0;
			else meta_cntr <= meta_cntr + 1'b1;
			
			send_sync_word <= ~|meta_cntr;
			send_scram_state <= send_sync_word;
			send_skip <= send_scram_state;
			send_payload <= send_payload | send_skip;
			send_diag <= 1'b0;
			if (meta_cntr == (META_FRAME_LEN-1)) begin
				send_payload <= 1'b0;
				send_diag <= 1'b1;
			end									
		end
	end
end

assign din_ack = schedule[61] & send_payload;

/////////////////////////
// 32 bit meta frame CRC
wire [1:0] status_bits = 2'b11;
wire [31:0] crc;
lane_tx_crc ltc (
	.clk(clk),
	.arst(arst),
	.din(din[63:0]),
	.previous_din_ack(din_ack),
	.final_din_of_burst(send_diag),
	.status_bits(status_bits), // to be embedded in the diagnostic word
	.crc(crc)
);

/////////////////////////
// Scrambler 
wire [63:0] scrambler_q;
wire scrambler_evolve = advance_meta & !send_sync_word & !send_scram_state;

scrambler_lfsr scr (
	.clk(clk),
	.arst(arst),
	.verify(1'b0),
	.load(1'b0),
	.load_d(58'h0),
	.evolve(scrambler_evolve),
	.q(scrambler_q),
	.verify_pass(),
	.verify_fail()	   
);
defparam scr .RESET_VAL = SCRAMBLER_RESET;

/////////////////////////
// transmit data select
reg [64:0] tx_din;
reg stick_in_crc;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		tx_din <= 0;
		stick_in_crc <= 0;
	end
	else begin
		stick_in_crc <= 1'b0;
		if (send_sync_word) 
			tx_din <= {1'b1,64'h78f678f678f678f6};
		else if (send_skip)
			tx_din <= {1'b1,({6'b000111,58'h21e1e1e1e1e1e1e} ^ scrambler_q)};
		else if (send_scram_state) 
			tx_din <= {1'b1,6'b001010,scrambler_q[63:6]};
		else if (send_diag) begin
			tx_din <= {1'b1,({6'b011001,24'h000000,status_bits,32'h00000000} ^ scrambler_q)};	
			stick_in_crc <= 1'b1;
		end
		else 
			tx_din <= {din[64],(din[63:0] ^ scrambler_q)};
			
	end
end

/////////////////////////
// 64-67 disparity encoder
wire [66:0] gb_data;
enc_64_67 enc (
	.clk(clk),
	.arst(arst),
	.din((stick_in_crc ? (crc ^ 32'hffffffff) : 32'h0) ^ tx_din), // bit 64=1 indicates control word
	.din_fresh(schedule[62]),
	.pn_reverse(PN_REVERSE),
	.dout(gb_data)
);
defparam enc .DISABLE_DISPARITY = DISABLE_DISPARITY;

/////////////////////////
// 67 to 20 bit gearbox
gearbox_67_20 gb (
	.clk(clk),
	.arst(arst),
	.din(gb_data),
	.din_valid(schedule[66]),
	.dout(dout)
);

endmodule
