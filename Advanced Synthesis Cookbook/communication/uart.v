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
////////////////////////////////////////////////////////////////////

module uart_tx (clk,rst,tx_data,tx_data_valid,tx_data_ack,txd);
  
output txd;
input clk, rst;
input [7:0] tx_data;
input tx_data_valid;
output tx_data_ack;

parameter BAUD_DIVISOR = 868;

reg [15:0] sample_cntr;
reg [10:0] tx_shift;
reg sample_now;
reg tx_data_ack;

assign txd = tx_shift[0];

always @(posedge clk) begin
	if (rst) begin
		sample_cntr <= 0;
		sample_now <= 1'b0;
	end
	else if (sample_cntr == (BAUD_DIVISOR-1)) begin
		sample_cntr <= 0;
		sample_now <= 1'b1;
   	end
	else begin
		sample_now <= 1'b0;
		sample_cntr <= sample_cntr + 1'b1;
	end
end

reg ready;
always @(posedge clk) begin
	if (rst) begin
		tx_shift <= {11'b00000000001};
		ready <= 1'b1;
	end
	else begin		
		if (!ready & sample_now) begin
			tx_shift <= {1'b0,tx_shift[10:1]};
			tx_data_ack <= 1'b0;
			ready <= ~|tx_shift[10:1];
		end		
		else if (ready & tx_data_valid) begin
			tx_shift[10:1] <= {1'b1,tx_data,1'b0};
			tx_data_ack <= 1'b1;
			ready <= 1'b0;		
		end
		else begin
			tx_data_ack <= 1'b0;
			ready <= ~|tx_shift[10:1];
		end
	end		
end

endmodule

////////////////////////////////////////////////////////////////////

module uart_rx (clk,rst,rx_data,rx_data_fresh,rxd);
  
input clk, rst, rxd;
output [7:0] rx_data;
output rx_data_fresh;

parameter BAUD_DIVISOR = 868;

reg [15:0] sample_cntr;
reg [7:0] rx_shift;
reg sample_now;
reg [7:0] rx_data;
reg rx_data_fresh;

reg last_rxd;
always @(posedge clk) begin
	last_rxd <= rxd;
end
wire slew = rxd ^ last_rxd;

always @(posedge clk) begin
	if (rst) begin
		sample_cntr <= 0;
		sample_now <= 1'b0;
	end
	else if (sample_cntr == (BAUD_DIVISOR-1) || slew) begin
		sample_cntr <= 0;
	end
	else if (sample_cntr == (BAUD_DIVISOR/2)) begin
		sample_now <= 1'b1;
		sample_cntr <= sample_cntr + 1'b1;
	end
	else begin
		sample_now <= 1'b0;
		sample_cntr <= sample_cntr + 1'b1;
	end
end

reg [1:0] state;
reg [3:0] held_bits;
parameter WAITING = 2'b00, READING = 2'b01, STOP = 2'b10, RECOVER = 2'b11;

always @(posedge clk) begin
	if (rst) begin
		state <= WAITING;
		held_bits <= 0;
		rx_shift <= 0;
		rx_data_fresh <= 1'b0;
		rx_data <= 0;
	end
	else begin
		rx_data_fresh <= 1'b0;
		case (state) 
			WAITING : begin
				// wait for a start bit (0)
				if (!slew & sample_now && !last_rxd) begin
					state <= READING;
					held_bits <= 0;
				end
			end
			READING : begin
				// gather data bits
				if (sample_now) begin
					rx_shift <= {last_rxd,rx_shift[7:1]};
					held_bits <= held_bits + 1'b1;
					if (held_bits == 4'h7) state <= STOP;
				end
			end
			STOP : begin
				// verify stop bit (1)
				if (sample_now) begin
					if (last_rxd) begin
						rx_data <= rx_shift;
						rx_data_fresh <= 1'b1;
						state <= WAITING;
					end
					else begin
						// there was a framing error -
						// discard the byte and work on resync
						state <= RECOVER;
					end
				end					
			end
			RECOVER : begin
				// wait for an idle (1) then resume
				if (sample_now) begin
					if (last_rxd) state <= WAITING;
				end				
			end
		endcase
	end
end

endmodule

////////////////////////////////////////////////////////////////////

module uart (clk,rst,
			tx_data,tx_data_valid,tx_data_ack,txd,
			rx_data,rx_data_fresh,rxd);

parameter CLK_HZ = 50_000_000;
parameter BAUD = 115200;
parameter BAUD_DIVISOR = CLK_HZ / BAUD;

initial begin
	if (BAUD_DIVISOR > 16'hffff) begin
		// This rate is too slow for the TX and RX sample 
		// counter resolution
		$display ("Error - Increase the size of the sample counters");
		$stop();
	end
end

output txd;
input clk, rst, rxd;
input [7:0] tx_data;
input tx_data_valid;
output tx_data_ack;
output [7:0] rx_data;
output rx_data_fresh;

uart_tx utx (
	.clk(clk),.rst(rst),
	.tx_data(tx_data),
	.tx_data_valid(tx_data_valid),
	.tx_data_ack(tx_data_ack),
	.txd(txd));

defparam utx .BAUD_DIVISOR = BAUD_DIVISOR;

uart_rx urx (
	.clk(clk),.rst(rst),
	.rx_data(rx_data),
	.rx_data_fresh(rx_data_fresh),
	.rxd(rxd));

defparam urx .BAUD_DIVISOR = BAUD_DIVISOR;

endmodule