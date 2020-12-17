//------------------------------------------------------------------------------
// main.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// ISE benchmark project
//
// This project uses dynamic_delay.v module to model both high-register count and
// combinational-intensive design
//
//
//  WARNING!
//  This is an adapted verilog version of the Dynamic delay module
//  Please use original "dynamic_delay.sv" where it is posibble

`define WIDTH 16
`define LENGTH 1024
//`define SEL_W $clog2(`LENGTH)
`define SEL_W 10


module main(

  input clk,
  input nrst,

  input [`WIDTH-1:0] id,
  input [`SEL_W-1:0] sel,
  output [`WIDTH-1:0] od
);

genvar i;
generate
  for( i=0; i<`WIDTH; i=i+1 ) begin : dd_bits

    dynamic_delay #(
      .LENGTH( `LENGTH ),
      .WIDTH( 1 ),
      .SEL_W( `SEL_W )
    ) dd (
      .clk( clk ),
      .nrst( nrst ),
      .ena( 1'b1 ),
      .in( id[i] ),
      .sel( sel[`SEL_W-1:0] ),
      .out( od[i] )
    );
  end
endgenerate

endmodule
