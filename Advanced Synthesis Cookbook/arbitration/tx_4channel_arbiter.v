// Copyright 2008 Altera Corporation. All rights reserved.  
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

// baeckler - 10-03-2008

module tx_4channel_arbiter # (
	parameter NUM_DAT_WORDS = 8,
	parameter LOG_DAT_WORDS = 4, // enough bits to represent 0..#dat inclusive
	parameter CHANID0 = 8'h0,
	parameter CHANID1 = 8'h1,
	parameter CHANID2 = 8'h2,
	parameter CHANID3 = 8'h3	
)
(
	input clk, arst,
	
	// four input ports
	input [LOG_DAT_WORDS-1:0] num_chan0words_valid,
	input [64*NUM_DAT_WORDS-1:0] chan0words,
	input chan0sop,
	input [3:0] chan0eopbits,
	output chan0ready,
	input chan0valid,
	
	input [LOG_DAT_WORDS-1:0] num_chan1words_valid,
	input [64*NUM_DAT_WORDS-1:0] chan1words,
	input chan1sop,
	input [3:0] chan1eopbits,
	output chan1ready,
	input chan1valid,
	
	input [LOG_DAT_WORDS-1:0] num_chan2words_valid,
	input [64*NUM_DAT_WORDS-1:0] chan2words,
	input chan2sop,
	input [3:0] chan2eopbits,
	output chan2ready,
	input chan2valid,
	
	input [LOG_DAT_WORDS-1:0] num_chan3words_valid,
	input [64*NUM_DAT_WORDS-1:0] chan3words,
	input chan3sop,
	input [3:0] chan3eopbits,
	output chan3ready,
	input chan3valid,
	
	// output port	
	output reg [LOG_DAT_WORDS-1:0] num_datwords_valid,
	output reg [64*NUM_DAT_WORDS-1:0] datwords,
	output reg [7:0] chan,
	output reg sop,
	output reg [3:0] eopbits,
	input ready,
	output valid		
);

localparam ARB_CHANS = 4;

reg [ARB_CHANS-1:0] qualified_req;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		qualified_req <= 0;
	end
	else begin
		qualified_req[0] <= chan0valid & (|num_chan0words_valid);
		qualified_req[1] <= chan1valid & (|num_chan1words_valid);
		qualified_req[2] <= chan2valid & (|num_chan2words_valid);
		qualified_req[3] <= chan3valid & (|num_chan3words_valid);	
	end
end

/////////////////////////////////////
// arbiter with rotating fairness

reg [ARB_CHANS-1:0] base,grant;
wire [ARB_CHANS-1:0] grant_w;
reg [1:0] enc_grant;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		base <= 1;
		grant <= 0;
		enc_grant <= 0;
	end
	else begin
		if (ready) begin
			base <= {base[ARB_CHANS-2:0],base[ARB_CHANS-1]};
			grant <= grant_w;
			enc_grant <= {grant_w[3] | grant_w[2], grant_w[3] | grant_w[1]}; 
		end
	end
end

arbiter arb (
	.req(qualified_req),
	.grant(grant_w),
	.base(base)
);
defparam arb .WIDTH = ARB_CHANS;

/////////////////////////////////////
// ready the winner if any

always @(posedge clk or posedge arst) begin
	if (arst) begin
		num_datwords_valid <= 0;
		datwords <= 0;
		chan <= 0;
		sop <= 0;
		eopbits <= 0;
	end
	else begin
		if (ready) begin
			if (enc_grant == 2'b00) begin
				num_datwords_valid <= num_chan0words_valid;
				datwords <= chan0words;
				sop <= chan0sop;
				eopbits <= chan0eopbits;							
				chan <= CHANID0;
			end
			else if (enc_grant == 2'b01) begin
				num_datwords_valid <= num_chan1words_valid;
				datwords <= chan1words;
				sop <= chan1sop;
				eopbits <= chan1eopbits;							
				chan <= CHANID1;
			end
			else if (enc_grant == 2'b10) begin
				num_datwords_valid <= num_chan2words_valid;
				datwords <= chan2words;
				sop <= chan2sop;
				eopbits <= chan2eopbits;							
				chan <= CHANID2;
			end
			else begin
				num_datwords_valid <= num_chan3words_valid;
				datwords <= chan3words;
				sop <= chan3sop;
				eopbits <= chan3eopbits;							
				chan <= CHANID3;
			end		
			
			if (~|grant) num_datwords_valid <= 0;	
		end
	end
end

assign chan0ready = grant[0] & ready;
assign chan1ready = grant[1] & ready;
assign chan2ready = grant[2] & ready;
assign chan3ready = grant[3] & ready;
assign valid = |num_datwords_valid;

endmodule