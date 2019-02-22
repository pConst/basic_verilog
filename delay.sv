//------------------------------------------------------------------------------
// delay.v
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO -------------------------------------------------------------------------
// Static Delay for arbitrary signal
// Another equivalent names for this module:
//          conveyor.sv
//          synchronizer.sv
//
// Tip for Xilinx-based implementations: Leave nrst=1'b1 and ena=1'b1 on
// purpose of inferring Xilinx`s SRL16E/SRL32E primitives


/* --- INSTANTIATION TEMPLATE BEGIN ---

delay #(
    .LENGTH( 2 )
) S1 (
    .clk( clk ),
    .nrst( 1'b1 ),
    .ena( 1'b1 ),
    .in(  ),
    .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module delay #( parameter
  LENGTH = 2              // delay/synchronizer chain length
                          // default length for synchronizer chain is 2
)(
  input clk,
  input nrst,
  input ena,
  input in,
  output out
);


(* ASYNC_REG = "TRUE" *) logic [LENGTH:0] data = 0;
always_ff @(posedge clk) begin
  if (~nrst) begin
    data[LENGTH:0] <= 0;
  end else if (ena) begin
    data[LENGTH:0] <= {data[LENGTH-1:0],in};
  end
end

assign
    out = data[LENGTH];

endmodule
