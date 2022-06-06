//------------------------------------------------------------------------------
// priority_enc.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO -------------------------------------------------------------------------
// Completely combinational priority_encoder
//
// See also round_robin_enc.sv
// See also round_robin_performance_enc.sv
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

priority_enc #(
  .WIDTH( 32 )   // WIDTH must be >=2
) PE1 (
  .id(  ),
  .od_valid(  ),
  .od_filt(  ),
  .od_bin(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module priority_enc #( parameter
  WIDTH = 32,
  WIDTH_W = $clogb2(WIDTH)
)(
  input  [WIDTH-1:0] id,      // input data bus

  output od_valid,            // output valid (some bits are active)
  output [WIDTH-1:0] od_filt, // filtered data (only one priority bit active)
  output [WIDTH_W-1:0] od_bin // priority bit binary index
);


  // reversed id[] data
  // conventional operation of priority encoder is when MSB bits have a priority
  logic [WIDTH-1:0] id_r;
  reverse_vector #(
    .WIDTH( WIDTH )  // WIDTH must be >=2
  ) reverse_b (
    .in( id[WIDTH-1:0] ),
    .out( id_r[WIDTH-1:0] )
  );

  leave_one_hot #(
    .WIDTH( WIDTH )
  ) one_hot_b (
    .in( id_r[WIDTH-1:0] ),
    .out( od_filt[WIDTH-1:0] )
  );

  logic err_no_hot;
  assign od_valid = ~err_no_hot;

  pos2bin #(
    .BIN_WIDTH( WIDTH_W )
  ) pos2bin_b (
    .pos( od_filt[WIDTH-1:0] ),
    .bin( od_bin[WIDTH_W-1:0] ),

    .err_no_hot( err_no_hot ),
    .err_multi_hot(  )
  );

  `include "clogb2.svh"

endmodule

