`timescale 1 ps / 1 ps
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

// baeckler - 09-22-2008
// Test word and frame lock on a single lane TX->RX pair

module lane_tb ();

reg clk=0,arst=0;

reg [64:0] din = 0;
wire din_ack;
wire [19:0] tx_out;
wire [65:0] recovered;  // [65]=1 indicates sync [64]=1 indicates control words
wire recovered_valid;
wire word_locked;
wire sync_locked;
wire framing_error;		
wire crc32_error;
wire scrambler_mismatch;
wire missing_sync;

//////////////////////////////
// Simple TX->RX link
//////////////////////////////
reg [19:0] tx_error = 20'h12345;
wire [19:0] rx_in = tx_out | tx_error;
	
lane_tx dut_t (
	.clk,.arst,
	.din,
	.din_ack,
	.dout(tx_out)
);

// For debugging sanity - just send everything non-inverted
//defparam dut_t .DISABLE_DISPARITY = 1'b1;

lane_rx dut_r (
	.clk,.arst,
	.din(rx_in),
	.dout(recovered),  // [64]=1 indicates control words
	.dout_valid(recovered_valid),
	.word_locked,
	.sync_locked,
	.framing_error,
	.crc32_error,
	.scrambler_mismatch,
	.missing_sync
);

//////////////////////////////
// Line monitor
//////////////////////////////
reg [255:0] line_history;
always @(posedge clk) begin
	line_history <= (line_history << 8'd20) | tx_out;
end

//////////////////////////////
// Stimulus
//////////////////////////////

initial begin
	#1 arst = 1'b1;
	@(negedge clk) arst = 1'b0;
	#1000 tx_error = 20'h00000;	
end

always begin
	#5 clk = ~clk;
end

reg [15:0] error_cntr;
reg rst_error_cntr = 0;

always @(posedge clk) begin
	if (rst_error_cntr) error_cntr <= 0;
	else if (framing_error |crc32_error | scrambler_mismatch | missing_sync) begin
		error_cntr <= error_cntr + 1'b1;
	end
end

initial begin
	rst_error_cntr = 1'b1;
	#8400 if (!word_locked) begin
		$display ("Failed to acquire word lock as expected");
		$stop();
	end
	#2000 if (!sync_locked) begin
		$display ("Failed to acquire sync lock as expected");
		$stop();
	end
	rst_error_cntr = 1'b0;
	#100000
	if (error_cntr !== 0) begin
		$display ("Errors flagged during normal operation");
		$stop();
	end
	$display ("PASS");
	$stop();
end

always @(negedge clk) begin
	if (din_ack) din <= din + 1'b1;
end

endmodule