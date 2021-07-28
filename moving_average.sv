//------------------------------------------------------------------------------
// moving_average.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Simple moving average implementation in SystemVerilog
//
//  Features:
//  - configurable depth and data width
//  - DEPTH doesnt have to be a power of two, but 2^N implementations are
//       the most efficient
//  - can be configured to implement in cells or block RAM
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

moving_average #(
  .DEPTH( 12 ),
  .DATA_W( 32 )
) MA (
  .clk( clk ),
  .nrst( 1'b1 ),
  .ena( 1'b1 ),

  .id(  ),
  .od(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module moving_average #( parameter
  DEPTH = 12,                         // DEPTH doesnt have to be a power of two
  DEPTH_W = $clog2(DEPTH),

  DATA_W = 32                         // data field width
)(

  input clk,                          // clock
  input nrst,                         // inverted reset
  input ena,                          // data enable

  input [DATA_W-1:0] id,              // data input
  output logic [DATA_W-1:0] od        // averaged data output
);


  logic [DATA_W-1:0] id_delayed;
  delay #(
      .LENGTH( DEPTH ),
      .WIDTH( DATA_W ),
      .TYPE( "CELLS" )                // "ALTERA_BLOCK_RAM" infers block ram
  ) delay_data_buf (                  //   "ALTERA_TAPS" infers altshift_taps
      .clk( clk ),                    //   all other values infer registers
      .nrst( nrst ),
      .ena( ena ),

      .in( id[DATA_W-1:0] ),
      .out( id_delayed[DATA_W-1:0] )
  );

  logic [DATA_W-1+DEPTH_W:0] moving_summ = '0;  // considering width expansion
  always_ff @(posedge clk) begin
    if( ~nrst ) begin
      moving_summ[DATA_W-1+DEPTH_W:0] <= '0;
    end else if( ena ) begin
      moving_summ[DATA_W-1+DEPTH_W:0] <=
            ( moving_summ[DATA_W-1+DEPTH_W:0] +
              id[DATA_W-1:0] -                  // adding new item
              id_delayed[DATA_W-1:0]);          // subtracting the last one
    end
  end

  always_comb begin
    // when DEPTH is a power of two, division turns out like a simple bit-shift
    od[DATA_W-1:0] <= moving_summ[DATA_W-1+DEPTH_W:0] / DEPTH;
  end

endmodule

