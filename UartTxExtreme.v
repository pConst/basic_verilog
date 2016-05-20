//--------------------------------------------------------------------------------
// UartTxExtreme.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
// Extreme minimal UART transmitter
//  
// CAUTION:
// optimized for 20MHz/115200
// tx_busy has been made asynchronous to tx_do_sample
// tx_start has no internal protection and should be rised only when tx_busy is low


/* --- INSTANTIATION TEMPLATE BEGIN ---

reg [7:0] tx_sample_cntr = 0;
always @ (posedge clk20) begin
	if (tx_sample_cntr[7:0] == 0) begin
		tx_sample_cntr[7:0] <= (173-1);
	end else begin
		tx_sample_cntr[7:0] <= tx_sample_cntr[7:0] - 1;
	end
end
wire tx_do_sample = (tx_sample_cntr[7:0] == 0);

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
	if (tx_start && ~tx_busy) begin
		tx_shifter[9:0] <= {1'b1,tx_data[7:0],1'b0};
	end	// tx_start
	
	if (tx_do_sample && tx_busy) begin
		{tx_shifter[9:0],txd} <= {tx_shifter[9:0],txd} >> 1;
	end	// tx_do_sample
end

assign
	tx_busy = (tx_shifter[9:0] != 0);

endmodule
