//--------------------------------------------------------------------------------
// UartRx.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Straightforward yet simple UART receiver implementation for FPGA written in Verilog
//  Expects at least one stop bit
//  Features continuous data aquisition at BAUD levels up to CLK_HZ / 2
//  Features early asynchronous 'busy' reset


/* --- INSTANTIATION TEMPLATE BEGIN ---

UartRx UR1 (
    .clk(),
    .nrst( 1'b1 ),
	.rx_data(),
	.rx_busy(),
	.rx_done(),
	.rx_err(),
	.rxd()
    );
defparam UR1.CLK_HZ = 200_000_000;
defparam UR1.BAUD = 9600;	// max. BAUD is CLK_HZ / 2

--- INSTANTIATION TEMPLATE END ---*/


module UartRx(clk, nrst, rx_data, rx_busy, rx_done, rx_err, rxd);

parameter CLK_HZ = 200_000_000;
parameter BAUD = 9600;
parameter BAUD_DIVISOR_2 = CLK_HZ / BAUD / 2;

input wire clk;
input wire nrst;

output reg [7:0] rx_data = 0;
reg rx_data_9th_bit = 0;	// {rx_data[7:0],rx_data_9th_bit} is actually a shift register

output reg rx_busy = 0;
output wire rx_done;		// read strobe
output wire rx_err;
input wire rxd;


StaticDelay SD (
    .clk(clk),
    .nrst(nrst),
    .in(rxd),
    .out(s_rxd)		// Synchronized rxd
    );
defparam SD.LENGTH = 2;
defparam SD.WIDTH = 1;


reg rxd_prev = 0;
always @ (posedge clk) begin
	if (~nrst) begin
		rxd_prev <= 0;
	end else begin
		rxd_prev <= s_rxd;
	end
end
wire start_bit_strobe = ~s_rxd & rxd_prev;


reg [15:0] rx_sample_cntr = (BAUD_DIVISOR_2 - 1);
wire rx_do_sample = (rx_sample_cntr[15:0] == 0);
always @ (posedge clk) begin
	if (~nrst) begin
		rx_busy <= 0;
	end else begin
		if (~rx_busy) begin
			if (start_bit_strobe) begin
				rx_sample_cntr[15:0] <= (BAUD_DIVISOR_2 * 3 - 1);		// wait for 1,5-bit period till next sample
				{rx_data[7:0],rx_data_9th_bit} <= 9'b100000000;
				rx_busy <= 1;
			end // start_bit_strobe
		end else begin

			if (rx_sample_cntr[15:0] == 0) begin
				rx_sample_cntr[15:0] <= (BAUD_DIVISOR_2 * 2 - 1);	// wait for 1-bit-period till next sample
			end else begin
				rx_sample_cntr[15:0] <= rx_sample_cntr[15:0] - 1;	// counting and sampling only when 'busy'
			end
			
			if (rx_do_sample) begin
				if (rx_data_9th_bit == 1) begin
					rx_busy <= 0;		// early asynchronous 'busy' reset
				end else begin
					{rx_data[7:0],rx_data_9th_bit} <= {s_rxd, rx_data[7:0]};
				end	//
			end // rx_do_sample
			
		end	// ~rx_busy
	end // ~nrst
end

assign
	rx_done = rx_data_9th_bit && rx_do_sample && s_rxd,		// rx_done and rx_busy fall simultaneously
	rx_err = rx_data_9th_bit && rx_do_sample && ~s_rxd;

endmodule
