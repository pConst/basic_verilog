//--------------------------------------------------------------------------------
// set_reset_comb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Synchronous SR trigger, but has a combinational output that changes
//     "with no delay" after inputs
//  No metastable state. RESET signal dominates here


//           |   |   +---+   |   |   |   |   |   |  SET
//           |   |   |   |   |   |   |   |   |   |
//      +------------+   +--------------------------------+
//           |   |   |   |   |   |   |   |   |   |
//           |   |   |   |   |   |   +---+   |   |  RESET
//           |   |   |   |   |   |   |   |   |   |
//      +----------------------------+   +----------------+
//           |   |   |   |   |   |   |   |   |   |
//           |   |   |   +---------------+   |   |  Q output, original
//           |   |   |   |   |   |   |   |   |   |  set_reset.sv
//      +----------------+   |   |   |   +----------------+
//           |   |   |   |   |   |   |   |   |   |
//           |   |   +---------------+   |   |   |  Q output, this module
//           |   |   |   |   |   |   |   |   |   |  set_reset_comb.sv
//      +------------+   |   |   |   +--------------------+
//           |   |   |   |   |   |   |   |   |   |
//           |   |   |   |   |   |   |   |   |   |


/* --- INSTANTIATION TEMPLATE BEGIN ---

set_reset_comb SR1 (
  .clk( clk ),
  .nrst( 1'b1 ),
  .s(  ),
  .r(  ),
  .q(  ),
  .nq(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module set_reset_comb(
  input clk,
  input nrst,
  input s,
  input r,
  output q,
  output nq
);

logic q_reg = 0;
always_ff @(posedge clk) begin
  if( ~nrst ) begin
    q_reg = 0;
  end else begin
    if( s ) q_reg = 1'b1;
    if( r ) q_reg = 1'b0;
  end
end

assign q = (s || q_reg) && ~r;
assign nq = ~q;

endmodule