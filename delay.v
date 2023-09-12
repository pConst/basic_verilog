//------------------------------------------------------------------------------
// delay.v
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO -------------------------------------------------------------------------
// Static Delay for arbitrary signal
// (simplified Verilog version, see ./delay.sv for advanced features)
//
// Another equivalent names for this module:
//          conveyor.sv
//          synchronizer.sv
//
// Tip for Xilinx-based implementations: Leave nrst=1'b1 and ena=1'b1 on
// purpose of inferring Xilinx`s SRL16E/SRL32E primitives
//
// CAUTION: delay module is widely used for synchronizing signals across clock
//   domains. When synchronizing, please exclude input data paths from timing
//   analysis manually by writing appropriate set_false_path SDC constraint
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

delay #(
  .LENGTH( 2 ),
  .WIDTH( 1 )
) S1 (
  .clk( clk ),
  .nrst( 1'b1 ),
  .ena( 1'b1 ),

  .in(  ),
  .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module delay #( parameter
  LENGTH = 2,                  // delay/synchronizer chain length
  WIDTH = 1                    // signal width
)(
  input clk,
  input nrst,
  input ena,

  input [WIDTH-1:0] in,
  output [WIDTH-1:0] out
);

  reg [LENGTH:1][WIDTH-1:0] data = 0;

  always @(posedge clk) begin
    integer i;
    if( ~nrst ) begin
      data <= 0;
    end else if( ena ) begin
      for( i=LENGTH-1; i>0; i=i-1 ) begin
        data[i+1][WIDTH-1:0] <= data[i][WIDTH-1:0];
      end
      data[1][WIDTH-1:0] <= in[WIDTH-1:0];
    end
  end

  assign out[WIDTH-1:0] = data[LENGTH][WIDTH-1:0];

endmodule

