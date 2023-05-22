//------------------------------------------------------------------------------
// clogb2.svh
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Calculates counter width based on specified vector/RAM depth
//  see also: http://www.sunburst-design.com/papers/CummingsHDLCON2001_Verilog2001.pdf
//
//  WARNING:
//  ========
//  - clogb2() usage is a quite obsolete technique, left from Verilog-2001 era
//    when system function $clog2() was not supported or was implemented falcely
//
//  - don`t use clogb2() for new designs! Instead:
//
//  - use $clog2(DEPTH) when declaring wr_addr[] pointer, which can refer any
//    RAM element from 0 to DEPTH-1
//
//  - use $clog2(DEPTH+1) to declare counters, which should hold any walue from
//    0 up to the DEPTH (inclusive)
//
//
//  Compared with system function $clog2():
//  =======================================
//  $clog2(0) = 0;   clogb2(0) = 0;
//  $clog2(1) = 0;   clogb2(1) = 1;
//  $clog2(2) = 1;   clogb2(2) = 2;
//  $clog2(3) = 2;   clogb2(3) = 2;
//  $clog2(4) = 2;   clogb2(4) = 3;
//  $clog2(5) = 3;   clogb2(5) = 3;
//  $clog2(6) = 3;   clogb2(6) = 3;
//  $clog2(7) = 3;   clogb2(7) = 3;
//  $clog2(8) = 3;   clogb2(8) = 4;
//  $clog2(9) = 4;   clogb2(9) = 4;
//  $clog2(10)= 4;   clogb2(10)= 4;
//  $clog2(11)= 4;   clogb2(11)= 4;
//  $clog2(12)= 4;   clogb2(12)= 4;
//  $clog2(13)= 4;   clogb2(13)= 4;
//  $clog2(14)= 4;   clogb2(14)= 4;
//  $clog2(15)= 4;   clogb2(15)= 4;
//  $clog2(16)= 4;   clogb2(16)= 5;
//
//  Function should be instantiated inside a module
//  But you are free to call it from anywhere by its hierarchical name
//
//  To add clogb2 function to your module:
//  `include "clogb2.svh"
//

function integer clogb2;
  input [31:0] depth;

  for( clogb2=0; depth>0; clogb2=clogb2+1 ) begin
    depth = depth >> 1;
  end

endfunction

