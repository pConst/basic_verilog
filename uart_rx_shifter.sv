//------------------------------------------------------------------------------
// uart_rx_shifter.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// UART-like shifter for simple synchronous messaging inside the FPGA or between FPGAs
// See also `uart_tx_shifter.sv` for TX part
//
// TX and RX parts should share one clock source
// Capable of continious stream transfer when tx_start is held constant 1'b1
// Any reasonable start bit count,data bit count, stop bit count
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

uart_rx_shifter #(
  .START_BITS( 1 ),
  .DATA_BITS( 8 ),
  .STOP_BITS( 2 ),
  .SYNCHRONIZE_RXD( 0 )     // 0 - disabled; 1 - enabled
) rx1 (
  .clk( clk ),
  .nrst( 1'b1 ),
  .rx_data(  ),
  .rx_valid(  ),
  .rxd(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module uart_rx_shifter #(

  bit [7:0] START_BITS = 1,   // must be >=1
  bit [7:0] DATA_BITS = 4,    // must be >=1
  bit [7:0] STOP_BITS = 2,    // must be >=1

  bit SYNCHRONIZE_RXD = 0     // its better to synchronize when rxd input
                              //   is actually an FPGA pin
)(
  input clk,                  // transmitter and receiver should use
  input nrst,                 //   the same clock

  output logic [DATA_BITS-1:0] rx_data = '0,  // output data
  output logic rx_valid = '0,                 // read strobe

  input rxd
);

localparam TOTAL_BITS = START_BITS + DATA_BITS + STOP_BITS;

logic [TOTAL_BITS-1:0] rx_data_buf = '1;

logic rxd_sync;
delay #(
  .LENGTH( 2 ),
  .WIDTH( 1 )
) rxd_SYNC_ATTR (
  .clk( clk ),
  .nrst( 1'b1 ),
  .ena( 1'b1 ),

  .in( rxd ),
  .out( rxd_sync )
);

logic start_detected;
assign start_detected = ~|rx_data_buf[DATA_BITS+STOP_BITS+:START_BITS];
logic stop_detected;
assign stop_detected = &rx_data_buf[0+:STOP_BITS];
logic data_valid;
assign data_valid = start_detected && stop_detected;

always_ff @(posedge clk) begin
  if( ~nrst ) begin
    rx_data_buf[TOTAL_BITS-1:0] <= '1;

    rx_data[DATA_BITS-1:0] <= '0;
    rx_valid <= 1'b0;
  end else begin
    if( data_valid ) begin
      // clear rx_data_buf if valid message is already detected
      rx_data_buf[TOTAL_BITS-1:0] <= { {(TOTAL_BITS-1){1'b1}},
                                       (SYNCHRONIZE_RXD ? rxd_sync : rxd) };
    end else begin
      // simple shifter, MSB first
      rx_data_buf[TOTAL_BITS-1:0] <= { rx_data_buf[TOTAL_BITS-2:0],
                                       (SYNCHRONIZE_RXD ? rxd_sync : rxd) };
    end

    // buffering valid messages
    if( data_valid ) begin
      rx_data[DATA_BITS-1:0] <= rx_data_buf[STOP_BITS+:DATA_BITS];
      rx_valid <= 1'b1;
    end else begin
      rx_valid <= 1'b0;
    end
  end
end


endmodule

