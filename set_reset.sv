//--------------------------------------------------------------------------------
// set_reset.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Synchronous SR trigger variant
//  No metastable state. RESET signal dominates here


/* --- INSTANTIATION TEMPLATE BEGIN ---

set_reset SR1 (
  .clk( clk ),
  .nrst( 1'b1 ),
  .s(  ),
  .r(  ),
  .q(  ),
  .nq(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module set_reset(
  input clk,
  input nrst,
  input s,
  input r,
  output logic q = 0,   // aka "present state"
  output nq
);

always_ff @(posedge clk) begin
  if( ~nrst ) begin
    q = 0;
  end else begin
    if( s ) q = 1'b1;
    if( r ) q = 1'b0;
  end
end

assign nq = ~q;

endmodule