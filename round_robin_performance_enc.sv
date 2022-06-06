//------------------------------------------------------------------------------
// round_robin_performance_enc.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO -------------------------------------------------------------------------
// VErsion of round robin combinational encoder to select only one bit from
//    the input bus. Feature of this particular version is a performance boost
//    motivated by skipping inactive inputs while performing round_robin.
//
// In contrast to priority encoder, every input bit (on average) has equal
//   chance to get to the output when all inputs are equally probable
//
// See also round_robin_enc.sv
// See also priority_enc.sv
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

round_robin_performance_enc #(
  .WIDTH( 32 )
) RE1 (
  .clk( clk ),
  .nrst( nrst ),
  .id(  ),
  .od_valid(  ),
  .od_filt(  ),
  .od_bin(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module round_robin_performance_enc #( parameter
  WIDTH = 32,
  WIDTH_W = $clogb2(WIDTH)
)(
  input clk,                        // clock
  input nrst,                       // inversed reset, synchronous

  input  [WIDTH-1:0] id,            // input data bus
  output od_valid,                  // output valid (some bits are active)
  output logic [WIDTH-1:0] od_filt, // filtered data (only one priority bit active)
  output logic [WIDTH_W-1:0] od_bin // priority bit binary index
);


  // current bit selector
  logic [WIDTH_W-1:0] priority_bit = '0;

  // prepare double width buffer with LSB bits masked out
  logic [2*WIDTH-1:0] mask;
  logic [2*WIDTH-1:0] id_buf;
  always_comb begin
    integer i;
    for ( i=0; i<2*WIDTH; i++ ) begin
      if( i>priority_bit[WIDTH_W-1:0] ) begin
        mask[i] = 1'b1;
      end else begin
        mask[i] = 1'b0;
      end
    end
    id_buf[2*WIDTH-1:0] = {2{id[WIDTH-1:0]}} & mask[2*WIDTH-1:0];
  end

  logic [2*WIDTH-1:0] id_buf_filt;
  leave_one_hot #(
    .WIDTH( 2*WIDTH )
  ) one_hot_b (
    .in( id_buf[2*WIDTH-1:0] ),
    .out( id_buf_filt[2*WIDTH-1:0] )
  );

  logic [(WIDTH_W+1)-1:0] id_buf_bin;  // one more bit to decode double width input

  logic err_no_hot;
  assign od_valid = ~err_no_hot;

  pos2bin #(
    .BIN_WIDTH( (WIDTH_W+1) )
  ) pos2bin_b (
    .pos( id_buf_filt[2*WIDTH-1:0] ),
    .bin( id_buf_bin[(WIDTH_W+1)-1:0] ),

    .err_no_hot( err_no_hot ),
    .err_multi_hot(  )
  );

  always_comb begin
    if( od_valid ) begin
      od_bin[WIDTH_W-1:0] = id_buf_bin[(WIDTH_W+1)-1:0] % WIDTH;
      od_filt[WIDTH-1:0] = 1'b1 << od_bin[WIDTH_W-1:0];
    end else begin
      od_bin[WIDTH_W-1:0] = '0;
      od_filt[WIDTH-1:0] = '0;
    end
  end

  // latching current
  always_ff @(posedge clk) begin
    if( ~nrst ) begin
      priority_bit[WIDTH_W-1:0] <= '0;
    end else begin
      if( od_valid ) begin
        priority_bit[WIDTH_W-1:0] <= od_bin[WIDTH_W-1:0];
      end else begin
        // nop,
      end // if
    end // if nrst
  end

  `include "clogb2.svh"

endmodule

