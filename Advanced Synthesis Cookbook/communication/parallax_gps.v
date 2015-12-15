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

// baeckler - 04-30-2008

module parallax_gps (
	input clk,rst,
	input s_din,
	output s_dout,
	output s_oe,

	output reg [7:0] hw_version,
	output reg info_valid,
	output reg [3:0] sats,
	output reg [23:0] gmt_time,		// H, M, S
	output reg [23:0] gmt_date,		// M, D, Y
	output reg [39:0] lattitude,	// Deg, Min, Min/FFFF, 0=N,1=S
	output reg [39:0] longitude,	// Deg, Min, Min/FFFF, 0=E,1=W
	output reg [15:0] altitude,		// 1/10 M
	output reg [15:0] speed,		// 1/10 knots
	output reg [15:0] heading,		// 1/10 degrees

	// diagnostic information
	output [3:0] current_query,
	output [3:0] timeouts
);

/////////////////////////////
// SIO regs
/////////////////////////////
reg din_r /* synthesis altera_attribute = "FAST_INPUT_REGISTER=ON" */;
reg dout_r /* synthesis altera_attribute = "FAST_OUTPUT_REGISTER=ON" */;
reg oe_r /* synthesis altera_attribute = "FAST_OUTPUT_ENABLE_REGISTER=ON" */;

wire dout_w;
reg oe_w;
assign s_dout = dout_r;
assign s_oe = oe_r;

always @(posedge clk) begin
	din_r <= s_din;
	dout_r <= dout_w;
	oe_r <= oe_w;
end

/////////////////////////////
// 4800 N81 Uart
/////////////////////////////

reg [7:0] tx_data;
reg tx_data_valid;
wire tx_data_ack,txd;
wire [7:0] rx_data;
wire rx_data_fresh;
reg forced_idle;

assign dout_w = forced_idle | txd;

uart ur (
	.clk(clk),
	.rst(rst),
	.tx_data(tx_data),
	.tx_data_valid(tx_data_valid),
	.tx_data_ack(tx_data_ack),
	.txd(txd),
	.rx_data(rx_data),
	.rx_data_fresh(rx_data_fresh),
	.rxd(din_r)
); 
defparam ur .BAUD = 4800;
defparam ur .CLK_HZ = 50_000_000;

/////////////////////////////
// Insert some idle bits
//   to deal with RX and TX handoff
//   on the same line.
/////////////////////////////
reg [13:0] idle_timer;
reg idle_max;
always @(posedge clk) begin
	if (rst) begin
		idle_timer <= 0;
		idle_max <= 1'b0;
	end
	else begin
		if (forced_idle) idle_timer <= idle_timer + 1'b1;
		idle_max <= &idle_timer;
	end
end

/////////////////////////////
// capture read bytes
/////////////////////////////
reg [8*5-1:0] rx_history;

always @(posedge clk) begin
	if (rst) rx_history <= 0;
	else if (rx_data_fresh) begin
		rx_history <= (rx_history << 4'h8) | rx_data;
	end
end

/////////////////////////////
// commands
/////////////////////////////
reg [3:0] cmd_reg;
reg inc_cmd;
always @(posedge clk) begin
	if (rst) cmd_reg <= 0;
	else begin
		if (inc_cmd) begin
			if (cmd_reg == 4'h9) cmd_reg <= 0;
			else cmd_reg <= cmd_reg + 1'b1;
		end
	end
end

/////////////////////////////
// reply timer 
//    wait until either 
//		the transmitter finishes 512 dummy chars
//		the receiver gets the appropriate number of bytes		
/////////////////////////////
reg [9:0] reply_cntr;
reg clr_reply_cntr, reply_cntr_max, prompt_complete;
reg [2:0] expected_bytes;
reg [3:0] timeout_counter;

always @(posedge clk) begin
	if (rst) timeout_counter <= 0;
	if (rst | clr_reply_cntr) begin
		reply_cntr <= 0;
		reply_cntr_max <= 0;
		if ((cmd_reg == 0) || 
			(cmd_reg == 1) || 
			(cmd_reg == 2)) expected_bytes <= 3'd1;
		else if ((cmd_reg == 3) ||
				(cmd_reg == 4)) expected_bytes <= 3'd3;
		else if ((cmd_reg == 5) ||
				(cmd_reg == 6)) expected_bytes <= 3'd5;
		else expected_bytes <= 3'd2;
		prompt_complete <= 1'b0;
	end
	else begin
		// make sure you're past the !GPSn prompt string
		// before counting bytes
		if (rx_history[23:8] == "PS") prompt_complete <= 1'b1;

		if (tx_data_ack) reply_cntr <= reply_cntr + 1'b1;
		if (rx_data_fresh & prompt_complete) expected_bytes <= expected_bytes - 1'b1;
		
		reply_cntr_max <= 1'b0;
		if (&reply_cntr) begin
			reply_cntr_max <= 1'b1;
			if (!reply_cntr_max) timeout_counter <= timeout_counter + 1'b1;
		end
		if (~|expected_bytes) begin
			reply_cntr_max <= 1'b1;
		end
	end
end

/////////////////////////////
// Data regs
/////////////////////////////
reg grab_data;

always @(posedge clk) begin
	if (rst) begin
		hw_version <= 0;
		info_valid <= 0;
		sats <= 0;
		gmt_time <= 0;
		gmt_date <= 0;
		lattitude <= 0;
		longitude <= 0;
		altitude <= 0;
		speed <= 0;
		heading <= 0;
	end
	else if (grab_data) begin
		if (cmd_reg == 4'h0) hw_version <= rx_history [7:0];
		if (cmd_reg == 4'h1) info_valid <= rx_history [0];
		if (cmd_reg == 4'h2) sats <= rx_history [3:0];
		if (cmd_reg == 4'h3) gmt_time <= rx_history [23:0];
		if (cmd_reg == 4'h4) gmt_date <= rx_history [23:0];
		if (cmd_reg == 4'h5) lattitude <= rx_history [39:0];
		if (cmd_reg == 4'h6) longitude <= rx_history [39:0];
		if (cmd_reg == 4'h7) altitude <= rx_history [15:0];
		if (cmd_reg == 4'h8) speed <= rx_history [15:0];
		if (cmd_reg == 4'h9) heading <= rx_history [15:0];
	end
end

/////////////////////////////
// Cycle through data requests
/////////////////////////////
reg [3:0] state /* synthesis preserve */;
reg [3:0] next_state;

parameter 
	ST_INIT = 0,
	ST_PRESEND = 1,
	ST_PRESEND1 = 2,
	ST_PRESEND2 = 3,
	ST_PRESEND3 = 4,
	ST_SEND = 5,
	ST_SEND1 = 6,
	ST_SEND2 = 7,
	ST_SEND3 = 8,
	ST_SEND4 = 9,
	ST_TX_PENDING = 10,
	ST_PRELISTEN = 11,
	ST_LISTEN = 12,
	ST_REPORT = 13,
	ST_NEXT_CMD = 14;
	
always @(*) begin
	next_state = state;
	tx_data = 0;
	tx_data_valid = 0;
	oe_w = 1'b0;
	clr_reply_cntr = 1'b0;
	inc_cmd = 1'b0;
	grab_data = 1'b0;
	forced_idle = 1'b0;

	case (state) 
		ST_INIT : begin
				next_state = ST_PRESEND;
			end
		ST_PRESEND : begin
				// force the line to idle for 1 char
				oe_w = 1'b1;
				forced_idle = 1'b1;
				tx_data = 0;
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_PRESEND1;
			end
		ST_PRESEND1 : begin
				// force the line to idle for 1 char
				oe_w = 1'b1;
				forced_idle = 1'b1;
				tx_data = 0;
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_PRESEND2;
			end
		ST_PRESEND2 : begin
				// force the line to idle for 1 char
				oe_w = 1'b1;
				forced_idle = 1'b1;
				tx_data = 0;
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_PRESEND3;
			end
		ST_PRESEND3 : begin
				// force the line to idle for 1 char
				oe_w = 1'b1;
				forced_idle = 1'b1;
				tx_data = 0;
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_SEND;
			end
		ST_SEND : begin
				oe_w = 1'b1;
				tx_data = "!";
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_SEND1;
			end
		ST_SEND1 : begin
				oe_w = 1'b1;
				tx_data = "G";
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_SEND2;
			end
		ST_SEND2 : begin
				oe_w = 1'b1;
				tx_data = "P";
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_SEND3;
			end
		ST_SEND3 : begin
				oe_w = 1'b1;
				tx_data = "S";
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_SEND4;
			end
		ST_SEND4 : begin
				oe_w = 1'b1;
				tx_data = {4'h0,cmd_reg};
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_TX_PENDING;
			end
		ST_TX_PENDING : begin
				// wait until the last command 
				// byte is done sending 
				oe_w = 1'b1;
				tx_data = 0;
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_PRELISTEN;
			end
		ST_PRELISTEN : begin
				// force the line to idle for 1 char
				clr_reply_cntr = 1'b1;
				oe_w = 1'b1;
				forced_idle = 1'b1;
				tx_data = 0;
				tx_data_valid = 1'b1;
				if (tx_data_ack) next_state = ST_LISTEN;			
			end
		ST_LISTEN : begin
				// wait until reply complete or timeout
				forced_idle = 1'b1;
				tx_data = 0;
				tx_data_valid = 1'b1;
				if (reply_cntr_max) next_state = ST_REPORT;
			end
		ST_REPORT : begin
				grab_data = 1'b1;
				next_state = ST_NEXT_CMD;				
			end
		ST_NEXT_CMD : begin
				inc_cmd = 1'b1;
				next_state = ST_PRESEND;
			end
	endcase
end

always @(posedge clk) begin
	if (rst) state <= ST_INIT;
	else state <= next_state;
end

// diagnostic info
assign current_query = cmd_reg;
assign timeouts = timeout_counter;

endmodule