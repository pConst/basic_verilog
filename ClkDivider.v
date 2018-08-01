//------------------------------------------------------------------------------
// ClkDivider.v
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Divides main clock to get derivative slower synchronous clocks
// See ClkDivider.sv file for SystemVerilog version of this module


/* --- INSTANTIATION TEMPLATE BEGIN ---

ClkDivider CD1 (
    .clk(),
    .nrst( 1'b1 ),
    .out()
    );
defparam CD1.WIDTH = 32;

--- INSTANTIATION TEMPLATE END ---*/


module ClkDivider(clk,nrst,out);

input wire clk;
input wire nrst;
output reg [(WIDTH-1):0] out = 0;

parameter WIDTH = 32;

always @ (posedge clk) begin
  if (~nrst) begin
    out[(WIDTH-1):0] <= 0;
  end
  else begin
    out[(WIDTH-1):0] <= out[(WIDTH-1):0] + 1'b1;
  end
end

endmodule
