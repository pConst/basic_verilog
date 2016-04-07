//--------------------------------------------------------------------------------
// UartRxExtreme.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Extreme minimal UART receiver optimized for 20MHz/115200 data rate


/* --- INSTANTIATION TEMPLATE BEGIN ---

UartRxExtreme UR1 (
    .clk(),
	.rx_data(),
	.rx_busy(),
	.rx_done(),
	.rxd()
    );

--- INSTANTIATION TEMPLATE END ---*/


module UartRxExtreme(clk, rx_data, rx_busy, rx_done, rxd);


input wire clk;

output reg [7:0] rx_data = 0;
reg rx_data_9th_bit = 0;	// {rx_data[7:0],rx_data_9th_bit} is actually a shift register

output wire rx_busy;
output wire rx_done;
input wire rxd;


reg rxd_prev = 0;
always @ (posedge clk) begin
	rxd_prev <= rxd;
end
wire start_bit_strobe = ~rx_busy && (~rxd & rxd_prev);


reg [7:0] rx_sample_cntr = 0;
always @ (posedge clk) begin
	if (start_bit_strobe) begin
		rx_sample_cntr[7:0] <= (86 * 3 - 1) - 2;
	end else begin
		if (rx_sample_cntr[7:0] == 0) begin
			rx_sample_cntr[7:0] <= (86 * 2 - 1);
		end else begin
			rx_sample_cntr[7:0] <= rx_sample_cntr[7:0] - 1;
		end // rx_sample_cntr
	end // ~rx_busy && start_bit_strobe
end
wire rx_do_sample = (rx_sample_cntr[7:0] == 0);


always @ (posedge clk) begin
	if (start_bit_strobe) begin
		{rx_data[7:0],rx_data_9th_bit} <= 9'b100000000;
	end // start_bit_strobe

	if (rx_do_sample) begin
		if (~rx_done) begin
			{rx_data[7:0],rx_data_9th_bit} <= {rxd,rx_data[7:0]};
		end else begin
			rx_data[7:0] <= 0;
			rx_data_9th_bit <= 0;
		end	// ~rx_done
	end // rx_do_sample
end

assign
	rx_busy = |{rx_data[7:0],rx_data_9th_bit},
	rx_done = rx_data_9th_bit && rx_do_sample && rxd;
	

endmodule
