//--------------------------------------------------------------------------------
// UartTxExtreme.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
// Extreme minimal UART transmitter


/* --- INSTANTIATION TEMPLATE BEGIN ---

UartTxExtreme UT1 (
    .clk(),
	//.tx_do_sample(),
	.tx_data(),
	.tx_start(),
	.tx_busy(),
	.txd()
    );

--- INSTANTIATION TEMPLATE END ---*/


module UartTxExtreme(clk, tx_do_sample, tx_data, tx_start, tx_busy, txd);


input wire clk;
input wire tx_do_sample;

input wire [7:0] tx_data;
input wire tx_start;
output wire tx_busy;
output reg txd = 1;


reg [9:0] tx_shifter = 0;

always @ (posedge clk) begin
	if (tx_start) begin
		tx_shifter[9:0] <= {1'b1,tx_data[7:0],1'b0};
	end	// tx_start
	
	if (tx_do_sample) begin
		{tx_shifter[9:0],txd} <= {tx_shifter[9:0],txd} >> 1;
	end	// tx_do_sample
end

assign
	tx_busy = |tx_shifter[9:1];

endmodule
