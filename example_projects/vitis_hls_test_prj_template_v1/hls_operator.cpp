//------------------------------------------------------------------------------
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

#include "hls_operator.h"

int hls_operator( int a, int b ) {

  #pragma HLS DATAFLOW

  static int delta = 1;

  int result = a + b + delta;
  delta++;

  return result;
}

