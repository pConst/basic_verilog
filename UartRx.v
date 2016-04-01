//--------------------------------------------------------------------------------
// UartRx.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Straightforward yet simple UART receiver implementation for FPGA written in Verilog
//  Expects at least one stop bit


/* --- INSTANTIATION TEMPLATE BEGIN ---

UartRx UR1 (
    .clk(),
    .nrst(),
	
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
output reg rx_busy = 0;
output reg rx_done = 0;		// read strobe
output reg rx_err = 0;		// read strobe
input wire rxd;


reg rxd_prev = 0;
always @ (posedge clk) begin
	if (~nrst) begin
		rxd_prev <= 0;
	end else begin
		rxd_prev <= rxd;
	end
end

wire start_bit_strobe = ~rxd & rxd_prev;

reg [15:0] rx_sample_cntr = (BAUD_DIVISOR_2 - 1);
wire rx_do_sample = (rx_sample_cntr[15:0] == 0);
reg [3:0] rx_data_cntr = 4'b1000;

always @ (posedge clk) begin
	if (~nrst) begin
		rx_data[7:0] <= 0;
		rx_busy <= 0;
		rx_done <= 0;
		rx_err <= 0;
		rx_sample_cntr[15:0] <= (BAUD_DIVISOR_2 - 1);
		rx_data_cntr[3:0] <= 4'b1000; 
	end else begin
		if (~rx_busy) begin
			if (start_bit_strobe) begin
				rx_sample_cntr[15:0] <= (BAUD_DIVISOR_2 * 3 - 1);		// wait for 1,5-bit period till next sample
				rx_data[7:0] <= 0;
				rx_busy <= 1;
				rx_done <= 0;
				rx_err <= 0;
				rx_data_cntr[3:0] <= 4'b1000;
			end // start_bit_strobe
		end else begin

			if (rx_sample_cntr[15:0] == 0) begin
				rx_sample_cntr[15:0] <= (BAUD_DIVISOR_2 * 2 - 1);		// wait for 1-bit-period till next sample
			end else begin
				rx_sample_cntr[15:0] <= rx_sample_cntr[15:0] - 1;	// counting and sampling only when 'busy'
			end
			
			if (rx_do_sample) begin
				if (rx_data_cntr[3:0] == 0)	begin	// do stop bit check
					if (rxd) begin
						rx_done <= 1;
					end	else begin
						rx_err <= 1;
					end // rxd
				end else begin						// do sample and shift data
					rx_data[7:0] <= {rxd, rx_data[7:1]};
					rx_data_cntr[3:0] <= rx_data_cntr[3:0] - 1;
				end	// rx_data_cntr[3:0]
			end // rx_do_sample
			
			if (rx_done || rx_err) begin
				rx_busy <= 0;
				rx_done <= 0;
				rx_err <= 0;
			end	// rx_done
			
		end	// ~rx_busy
	end // ~nrst
end

endmodule
