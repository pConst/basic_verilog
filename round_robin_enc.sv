//------------------------------------------------------------------------------
// round_robin_enc.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO -------------------------------------------------------------------------
// Round robin combinational encoder to select only one bit from the input bus.
// In contrast to priority encoder, it features cyclically changing priority
//   pointer inside, so every input bit (on aaverage) has equal chance
//   to get to the output
//
// This module is meant to be as simple as possible. It is possible to make
//   more efficient, but complicated circuit
//
// See also priority_enc.sv
// See also round_robin_performance_enc.sv
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

round_robin_enc #(
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


module round_robin_enc #( parameter
  WIDTH = 32,
  WIDTH_W = $clogb2(WIDTH)
)(
  input clk,                        // clock
  input nrst,                       // inversed reset, synchronous

  input  [WIDTH-1:0] id,            // input data bus
  output logic od_valid,            // output valid (some bits are active)
  output logic [WIDTH-1:0] od_filt, // filtered data (only one priority bit active)
  output logic [WIDTH_W-1:0] od_bin // priority bit binary index
);


  // current bit selector
  logic [WIDTH_W-1:0] priority_bit = '0;
  always_ff @(posedge clk) begin
    if( ~nrst ) begin
      priority_bit[WIDTH_W-1:0] <= '0;
    end else begin
      if( priority_bit[WIDTH_W-1:0] == WIDTH-1 ) begin
        priority_bit[WIDTH_W-1:0] <= '0;
      end else begin
        priority_bit[WIDTH_W-1:0] <= priority_bit[WIDTH_W-1:0] + 1'b1;
      end // if
    end // if nrst
  end

  always_comb begin
    if( id[priority_bit[WIDTH_W-1:0]] ) begin
      od_valid = id[priority_bit[WIDTH_W-1:0]];
      od_filt[WIDTH-1:0] = 1'b1 << priority_bit[WIDTH_W-1:0];
      od_bin[WIDTH_W-1:0] = priority_bit[WIDTH_W-1:0];
    end else begin
      od_valid = 1'b0;
      od_filt[WIDTH-1:0] = '0;
      od_bin[WIDTH_W-1:0] = '0;
    end
  end

  `include "clogb2.svh"

endmodule

