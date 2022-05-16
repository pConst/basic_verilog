//------------------------------------------------------------------------------
// Gowin test project template
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------


// Vivado bugfix ===============================================================

  // This is a workaround for Vivado bug of not providing errors
  //   when using undeclared signals in your code
  //   See https://forums.xilinx.com/t5/Synthesis/Bug-in-handling-undeclared-signals-in-instance-statement-named/td-p/300127
    //`define VIVADO_MODULE_HEADER `default_nettype none
    //`define VIVADO_MODULE_FOOTER `default_nettype wire

  // Declare these stubs to safely reuse your Vivado modules in non-Xilinx FPGA projects
    `define VIVADO_MODULE_HEADER
    `define VIVADO_MODULE_FOOTER

// =============================================================================

 `define INC( AVAL ) \
    ``AVAL <= ``AVAL + 1'b1;

 `define DEC( AVAL ) \
    ``AVAL <= ``AVAL - 1'b1;

 `define SET( AVAL ) \
    ``AVAL <= 1'b1;

 `define RESET( AVAL ) \
    ``AVAL <= 1'b0;
