//------------------------------------------------------------------------------
// main.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Gowin benchmark project
//
// This project uses dynamic_delay.sv module to model both high-register count and
// combinational-intensive design. See "Messages" tab for TOTAL time
// spent for compilation. This will give you some quantitive charachteristic
// of your environment processing power

`define WIDTH 16
`define LENGTH 1024
`define SEL_W $clog2(`LENGTH)


module main(

  input clk,
  input nrst,

  input [`WIDTH-1:0] id,
  input [`SEL_W-1:0] sel,
  output [`WIDTH-1:0] od
);

dynamic_delay #(
  .LENGTH( `LENGTH ),
  .WIDTH( 1 ),
  .SEL_W( `SEL_W )
) dd [`WIDTH-1:0] (
  .clk( {`WIDTH{clk}} ),
  .nrst( {`WIDTH{nrst}} ),
  .ena( {`WIDTH{1'b1}} ),
  .in( id[`WIDTH-1:0] ),
  .sel( {`WIDTH{sel[`SEL_W-1:0]}} ),
  .out( od[`WIDTH-1:0] )
);

endmodule
