//------------------------------------------------------------------------------
// clogb2.svh
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Calculates counter/address width based on specified vector/RAM depth
//
//  Function should be instantiated inside a module
//  But you are free to call it from anywhere by its hierarchical name
//
//  To add clogb2 function to your module:
//  `include "clogb2.svh"
//

function integer clogb2;
  input integer depth;

  for( clogb2=0; depth>0; clogb2=clogb2+1 ) begin
    depth = depth >> 1;
  end
endfunction

