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

// baeckler - 02-16-2007
module uart_hw_test (clk,rst_n,txd,rxd);

input clk,rst_n;
input rxd;
output txd;

reg [7:0] tx_data;
reg tx_data_valid;
wire tx_data_ack;
wire txd,rxd;
wire [7:0] rx_data;
wire rx_data_fresh;

reg [7:0] rst_cntr;
reg rst;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rst_cntr <= 0;
		rst <= 1'b1;
	end
	else begin
		if (&rst_cntr) begin
			rst <= 1'b0;
		end
		else begin
			rst <= 1'b1;
			rst_cntr <= rst_cntr + 1'b1;
		end
	end
end

uart u (.clk(clk),
		.rst(rst),
		.tx_data(tx_data),
		.tx_data_valid(tx_data_valid),
		.tx_data_ack(tx_data_ack),
		.txd(txd),
		.rx_data(rx_data),
		.rx_data_fresh(rx_data_fresh),
		.rxd(rxd));

defparam u .CLK_HZ = 100_000_000;
defparam u .BAUD = 115200;

// add one to each RX byte and send it out again
always @(posedge clk) begin
	if (rst) begin
		tx_data <= 1'b0;
		tx_data_valid <= 1'b0;
	end
	else begin
		if (rx_data_fresh) begin
			tx_data <= rx_data + 1'b1;
			tx_data_valid <= 1'b1;
		end	
		else if (tx_data_ack) begin
			tx_data_valid <= 1'b0;
		end
	end
end

endmodule
