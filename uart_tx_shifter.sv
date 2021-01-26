//------------------------------------------------------------------------------
// uart_tx_shifter.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// UART-like shifter for simple synchronous messaging inside the FPGA or between FPGAs
// See also `uart_rx_shifter.sv` for RX part
//
// TX and RX parts should share one clock source
// Capable of continious stream transfer when tx_start is held constant 1'b1
// Any reasonable start bit count,data bit count, stop bit count
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

uart_tx_shifter #(
  .START_BITS( 1 ),
  .DATA_BITS( 8 ),
  .STOP_BITS( 2 )
) tx1 (
  .clk( clk ),
  .nrst( 1'b1 ),
  .tx_data(  ),
  .tx_start(  ),
  .tx_busy(  ),
  .txd(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module uart_tx_shifter #(

  bit [7:0] START_BITS = 1,   // must be >=1
  bit [7:0] DATA_BITS = 4,    // must be >=1
  bit [7:0] STOP_BITS = 2     // must be >=1
)(
  input clk,                           // transmitter and receiver should use
  input nrst,                          //   the same clock

  input [DATA_BITS-1:0] tx_data,       // input data get captured on write strobe
  input tx_start,                      // write strobe itself
  output tx_busy,                      // tx_busy fall on the last stop bit

  output logic txd = 1'b1
);

logic [DATA_BITS-1:0] tx_data_buf = '0;
logic [7:0] state_cntr = '0;

enum int unsigned { STOP, START, DATA } tx_state = STOP;

always_ff @(posedge clk) begin
  if( ~nrst ) begin
    tx_state <= STOP;

    tx_data_buf[DATA_BITS-1:0] <= '0;
    state_cntr[7:0] <= '0;

    txd <= 1'b1;
  end else begin

    case( tx_state )
      STOP: begin

          txd <= 1'b1;
          if( state_cntr[7:0] != '0 ) begin
            // holding stop bits
            state_cntr[7:0]--;
          end else begin
            // idle state after stop bits

            // no need for edge detector here because tx_state changes instantly
            //  after the first active tx_start cycle
            if( tx_start ) begin
              // buffering input data
              tx_data_buf[DATA_BITS-1:0] <= tx_data[DATA_BITS-1:0];
              state_cntr[7:0] <= START_BITS - 1'b1;
              tx_state <= tx_state.next();
            end // tx_start
          end // state_cntr

      end
      START: begin

          txd <= 1'b0;
          if( state_cntr[7:0] != '0 ) begin
            // holding start bits
            state_cntr[7:0]--;
          end else begin
            // transition
            state_cntr[7:0] <= DATA_BITS - 1'b1;
            tx_state <= tx_state.next();
          end // state_cntr

      end
      DATA: begin

          // setting data, MSB first
          txd <= tx_data_buf[state_cntr[7:0]];

          if( state_cntr[7:0] != '0 ) begin
            state_cntr[7:0]--;
          end else begin
            // transition
            state_cntr[7:0] <= STOP_BITS - 1'b1;
            tx_state <= tx_state.next();
          end // state_cntr

      end
    endcase // tx_state

  end
end

assign tx_busy = ~( (tx_state == STOP) && (state_cntr[7:0] == '0) );


endmodule

