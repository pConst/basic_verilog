//------------------------------------------------------------------------------
// clk_divider.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Divides main clock to get derivative slower synchronous clocks


/* --- INSTANTIATION TEMPLATE BEGIN ---

clk_divider #(
  .WIDTH( 32 )
) CD1 (
  .clk( clk ),
  .nrst( 1'b1 ),
  .ena( 1'b1 ),
  .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module clk_divider #( parameter
  WIDTH = 32
)(
  input clk,
  input nrst,
  input ena,
  output logic [(WIDTH-1):0] out = 0
);


always_ff @(posedge clk) begin
  if ( ~nrst ) begin
    out[(WIDTH-1):0] <= 0;
  end else if (ena) begin
    out[(WIDTH-1):0] <= out[(WIDTH-1):0] + 1'b1;
  end
end

endmodule
