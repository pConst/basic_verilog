//--------------------------------------------------------------------------------
// UartTx.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Straightforward yet simple UART transmitter implementation for FPGA written in Verilog
//  One stop bit setting is hardcoded


/* --- INSTANTIATION TEMPLATE BEGIN ---

UartTx UT1 (
    .clk(),
    .nrst(),

	.tx_data(),
	.tx_start(),
	.tx_busy(),
	.txd()
    );
defparam UT1.CLK_HZ = 200_000_000;
defparam UT1.BAUD = 9600;	// max. BAUD is CLK_HZ / 2

--- INSTANTIATION TEMPLATE END ---*/


module UartTx(clk, nrst, tx_data, tx_start, tx_busy, txd);

parameter CLK_HZ = 200_000_000;
parameter BAUD = 9600;
parameter BAUD_DIVISOR = CLK_HZ / BAUD;

input wire clk;
input wire nrst;

input wire [7:0] tx_data;
input wire tx_start;		// write strobe
output reg tx_busy = 0;
output reg txd = 1;


reg [15:0] tx_sample_cntr = (BAUD_DIVISOR-1);
reg [9:0] tx_shifter = 0;

always @ (posedge clk) begin
	if ((~nrst) || (tx_sample_cntr[15:0] == 0)) begin
		tx_sample_cntr[15:0] <= (BAUD_DIVISOR-1);
	end else begin
		tx_sample_cntr[15:0] <= tx_sample_cntr[15:0] - 1'b1;
	end
end

wire tx_do_sample = (tx_sample_cntr[15:0] == 0);

always @ (posedge clk) begin
	if (~nrst) begin
		tx_busy <= 0;
		tx_shifter[9:0] <= 0;
		txd <= 1;
	end else begin
		if (~tx_busy) begin
			if (tx_start) begin		// asynchronous data load and 'busy' set
				tx_shifter[9:0] <= {1'b1,tx_data[7:0],1'b0};
				tx_busy <= 1;
			end
		end else begin
		
			if (tx_do_sample) begin		// next bit
				{tx_shifter[9:0],txd} <= {tx_shifter[9:0],txd} >> 1;	// txd MUST change only on tx_do_sample although data may be loaded earlier
			end	// tx_do_sample
			
			if (~|tx_shifter[9:0]) begin		// asynchronous 'busy' reset
				tx_busy <= 0;					// txd still holds data, but shifter is ready
			end
			
		end	// ~tx_busy
	end // ~nrst
end

endmodule
