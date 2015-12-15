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

module tx_4channel_arbiter_tb ();

parameter NUM_DAT_WORDS = 2;
parameter LOG_DAT_WORDS = 2;

reg clk, arst;

// four input ports
reg [LOG_DAT_WORDS-1:0] num_chan0words_valid;
reg [64*NUM_DAT_WORDS-1:0] chan0words;
reg chan0sop;
reg [3:0] chan0eopbits;
wire chan0ready;
reg chan0valid;

reg [LOG_DAT_WORDS-1:0] num_chan1words_valid;
reg [64*NUM_DAT_WORDS-1:0] chan1words;
reg chan1sop;
reg [3:0] chan1eopbits;
wire chan1ready;
reg chan1valid;

reg [LOG_DAT_WORDS-1:0] num_chan2words_valid;
reg [64*NUM_DAT_WORDS-1:0] chan2words;
reg chan2sop;
reg [3:0] chan2eopbits;
wire chan2ready;
reg chan2valid;

reg [LOG_DAT_WORDS-1:0] num_chan3words_valid;
reg [64*NUM_DAT_WORDS-1:0] chan3words;
reg chan3sop;
reg [3:0] chan3eopbits;
wire chan3ready;
reg chan3valid;

// outport	
wire [LOG_DAT_WORDS-1:0] num_datwords_valid;
wire [64*NUM_DAT_WORDS-1:0] datwords;
wire [7:0] chan;
wire sop;
wire [3:0] eopbits;
reg ready;
wire valid;		

tx_4channel_arbiter #
(
	.NUM_DAT_WORDS(NUM_DAT_WORDS),
	.LOG_DAT_WORDS(LOG_DAT_WORDS)
)
dut
(.*);

////////////////////////////////////////
// Chan 0 driver
////////////////////////////////////////
reg chan0state;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		num_chan0words_valid <= 2'd2;
		chan0words <= 0;
		chan0sop <= 0;
		chan0eopbits <= 0;
		chan0valid <= 1'b1;
		chan0state <= 0;
	end
	else begin
		if (chan0ready) begin
			if (chan0state) begin
				num_chan0words_valid <= 2'd2;
				chan0words <= {"chan0abc","chan0def"};
				chan0sop <= 1'b1;
				chan0eopbits <= 0;				
			end
			else begin
				num_chan0words_valid <= 2'd2;
				chan0words <= {"chan0ghi","chan0jki"};;
				chan0sop <= 0;
				chan0eopbits <= 4'b1000;			
			end
			chan0state <= chan0state + 1'b1;
		end				
	end
end

////////////////////////////////////////
// Chan 1 driver
////////////////////////////////////////
reg chan1state;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		num_chan1words_valid <= 2'd2;
		chan1words <= 0;
		chan1sop <= 0;
		chan1eopbits <= 0;
		chan1valid <= 1'b1;
		chan1state <= 0;
	end
	else begin
		if (chan1ready) begin
			if (chan1state) begin
				num_chan1words_valid <= 2'd2;
				chan1words <= {"chan1abc","chan1def"};
				chan1sop <= 1'b1;
				chan1eopbits <= 0;				
			end
			else begin
				num_chan1words_valid <= 2'd2;
				chan1words <= {"chan1ghi","chan1jki"};;
				chan1sop <= 0;
				chan1eopbits <= 4'b1000;			
			end
			chan1state <= chan1state + 1'b1;
		end				
	end
end

////////////////////////////////////////
// Chan 2 driver
////////////////////////////////////////
reg chan2state;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		num_chan2words_valid <= 2'd2;
		chan2words <= 0;
		chan2sop <= 0;
		chan2eopbits <= 0;
		chan2valid <= 1'b1;
		chan2state <= 0;
	end
	else begin
		if (chan2ready) begin
			if (chan2state) begin
				num_chan2words_valid <= 2'd2;
				chan2words <= {"chan2abc","chan2def"};
				chan2sop <= 1'b1;
				chan2eopbits <= 0;				
			end
			else begin
				num_chan2words_valid <= 2'd2;
				chan2words <= {"chan2ghi","chan2jki"};;
				chan2sop <= 0;
				chan2eopbits <= 4'b1000;			
			end
			chan2state <= chan2state + 1'b1;
		end				
	end
end

////////////////////////////////////////
// Chan 3 driver
////////////////////////////////////////
reg chan3state;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		num_chan3words_valid <= 2'd2;
		chan3words <= 0;
		chan3sop <= 0;
		chan3eopbits <= 0;
		chan3valid <= 1'b1;
		chan3state <= 0;
	end
	else begin
		if (chan3ready) begin
			if (chan3state) begin
				num_chan3words_valid <= 2'd2;
				chan3words <= {"chan3abc","chan3def"};
				chan3sop <= 1'b1;
				chan3eopbits <= 0;				
			end
			else begin
				num_chan3words_valid <= 2'd2;
				chan3words <= {"chan3ghi","chan3jki"};;
				chan3sop <= 0;
				chan3eopbits <= 4'b1000;			
			end
			chan3state <= chan3state + 1'b1;
		end				
	end
end

////////////////////////////////////////
// simulate sink readiness and XON/XOFF
////////////////////////////////////////
reg all_off;
always @(negedge clk) begin
	ready <= $random | $random;	
	all_off <= $random & $random;
	if (all_off) begin
		chan0valid <= 1'b0;	
		chan1valid <= 1'b0;	
		chan2valid <= 1'b0;	
		chan3valid <= 1'b0;		
	end
	else begin
		chan0valid <= $random | $random;	
		chan1valid <= $random | $random;	
		chan2valid <= $random | $random;	
		chan3valid <= $random | $random;		
	end
end

////////////////////////////////////////
// Inspect the recovered data
////////////////////////////////////////
reg fail = 1'b0;
reg [64*NUM_DAT_WORDS-1:0] last_chan0,last_chan1,last_chan2,last_chan3;
always @(posedge clk) begin
	#1
	if (ready && chan == 8'h0 && |num_datwords_valid) begin
		last_chan0 <= datwords;
		if (datwords == last_chan0) begin
			$display ("Repeated data on channel 0 at time %d",$time);
			fail = 1;	
		end
		if (datwords[64*NUM_DAT_WORDS-1:64*NUM_DAT_WORDS-5*8] != "chan0") begin
			$display ("Channel 0 data tag mismatch");
			fail = 1;	
		end			
	end
	if (ready && chan == 8'h1 && |num_datwords_valid) begin
		last_chan1 <= datwords;
		if (datwords == last_chan1) begin
			$display ("Repeated data on channel 1 at time %d",$time);
			fail = 1;	
		end
		if (datwords[64*NUM_DAT_WORDS-1:64*NUM_DAT_WORDS-5*8] != "chan1") begin
			$display ("Channel 1 data tag mismatch");
			fail = 1;	
		end			
	end
	if (ready && chan == 8'h2 && |num_datwords_valid) begin
		last_chan2 <= datwords;
		if (datwords == last_chan2) begin
			$display ("Repeated data on channel 2 at time %d",$time);
			fail = 1;	
		end
		if (datwords[64*NUM_DAT_WORDS-1:64*NUM_DAT_WORDS-5*8] != "chan2") begin
			$display ("Channel 2 data tag mismatch");
			fail = 1;	
		end			
	end
	if (ready && chan == 8'h3 && |num_datwords_valid) begin
		last_chan3 <= datwords;
		if (datwords == last_chan3) begin
			$display ("Repeated data on channel 3 at time %d",$time);
			fail = 1;	
		end
		if (datwords[64*NUM_DAT_WORDS-1:64*NUM_DAT_WORDS-5*8] != "chan3") begin
			$display ("Channel 3 data tag mismatch");
			fail = 1;	
		end			
	end	
end

////////////////////////////////////////
// clock driver
////////////////////////////////////////
initial begin
	clk = 0;
	arst = 0;
	#1 arst = 1'b1;
	@(negedge clk) arst = 1'b0;
end

always begin
	#5 clk = ~clk;
end


endmodule