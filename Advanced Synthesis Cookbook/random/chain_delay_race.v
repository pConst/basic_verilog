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

// baeckler - 03-28-2008

module chain_delay_race
(
	clk,rst,
	calibrate_a,
	calibrate_b,
	a_wins,
	b_wins,
	valid		
);

parameter CHAIN_LEN = 32;
parameter CALIBRATE_BITS = 4;
localparam CALIBRATE_DEC = (1<<CALIBRATE_BITS);

input clk,rst;
input [CALIBRATE_BITS-1:0] calibrate_a;
input [CALIBRATE_BITS-1:0] calibrate_b;
output a_wins,b_wins,valid;

reg flush, valid;

///////////////////////
// input regs
///////////////////////
reg [CALIBRATE_BITS-1:0] calibrate_a_r /* synthesis preserve */;
reg [CALIBRATE_BITS-1:0] calibrate_b_r /* synthesis preserve */;

always @(posedge clk) begin
	if (rst) begin
		calibrate_a_r <= 0;
		calibrate_b_r <= 0;
	end
	else begin
		calibrate_a_r <= calibrate_a;
		calibrate_b_r <= calibrate_b;
	end
end

///////////////////////
// path A
///////////////////////
reg [CALIBRATE_DEC-1:0] calibrate_a_dec;
always @(posedge clk) begin
	calibrate_a_dec <= 0;
	calibrate_a_dec[calibrate_a_r] <= !flush;
end

wire [CHAIN_LEN:0] chain_a = {CHAIN_LEN{1'b1}} + calibrate_a_dec;
wire a_out = chain_a[CHAIN_LEN];

///////////////////////
// path B
///////////////////////
reg [CALIBRATE_DEC-1:0] calibrate_b_dec;
always @(posedge clk) begin
	calibrate_b_dec <= 0;
	calibrate_b_dec[calibrate_b_r] <= !flush;
end

wire [CHAIN_LEN:0] chain_b = {CHAIN_LEN{1'b1}} + calibrate_b_dec;
wire b_out = chain_b[CHAIN_LEN];

///////////////////////
// finish line latches
///////////////////////
wire a_wins_latch, b_wins_latch /* synthesis keep */;
wire trial_complete = a_out & b_out;
assign a_wins_latch = !flush & (a_wins_latch | (a_out & !b_out));
assign b_wins_latch = !flush & (b_wins_latch | (b_out & !a_out));

///////////////////////
// resynchronize
///////////////////////
reg a_wins, b_wins, stable /* synthesis preserve */;
always @(posedge clk) begin
	a_wins <= a_wins_latch;
	b_wins <= b_wins_latch;
	stable <= trial_complete;	
end

////////////////////////////////////
// control - continuous retrigger
////////////////////////////////////
reg [1:0] state /* synthesis preserve */;

always @(posedge clk) begin
	if (rst) begin
		flush <= 1'b1;
		state <= 2'b00;
		valid <= 1'b0;
	end
	else begin
		case (state)
			2'b00 : begin
				flush <= 1'b1;
				valid <= 1'b0;
				if (!a_wins & !b_wins & !stable) state <= 2'b01;
			end
			2'b01 : begin
				flush <= 1'b0;
				if (stable) state <= 2'b10;
			end
			2'b10 : begin
				valid <= 1'b1;
				state <= 2'b00;
			end
			2'b11 : begin
				// unreachable
				state <= 2'b00;
			end
		endcase
	end
end

endmodule