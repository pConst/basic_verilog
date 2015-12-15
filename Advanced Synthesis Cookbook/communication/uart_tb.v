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

////////////////////////////////////////////////////////////////////

module uart_tb ();

reg clk, rst;
reg [7:0] tx_data;
reg tx_data_valid;
wire tx_data_ack;
wire txd,rxd;
wire [7:0] rx_data;
wire rx_data_fresh;

uart u (
	.clk(clk),
	.rst(rst),
	.tx_data(tx_data),
	.tx_data_valid(tx_data_valid),
	.tx_data_ack(tx_data_ack),
	.txd(txd),
	.rx_data(rx_data),
	.rx_data_fresh(rx_data_fresh),
	.rxd(rxd)
);

assign rxd = txd;

initial begin
	clk = 0;
	rst = 1;
	tx_data_valid = 1'b0;
	@(posedge clk);
	@(negedge clk);
	rst = 0;
end

always begin
	#50 clk = ~clk;
end

// tx data driver
always begin
	#1000 @(negedge clk) tx_data_valid = $random;
end

always @(posedge clk) begin
	if (rst) tx_data <= "a";
	else if (tx_data_ack) begin
		if (tx_data == "z") tx_data <= "a";
		else tx_data <= tx_data + 1'b1;
	end
end

// rx data checker
reg fail = 0;
reg [7:0] expected_rx;
always @(posedge clk) begin
	if (rst) expected_rx <= "a";
	else if (rx_data_fresh) begin
		if (rx_data !== expected_rx) begin
			$display ("Mismatch at time %d",$time);
			fail = 1;
			#1000
			$stop();
		end
		if (expected_rx == "z") expected_rx <= "a";
		else expected_rx <= expected_rx + 1'b1;
	end
end

initial begin
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

endmodule