//------------------------------------------------------------------------------
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

#include "ap_int.h"
#include "hls_stream.h"

void hls_operator(
  hls::stream<int> &a,
  hls::stream<int> &b,
  hls::stream<int> &c,
  hls::stream<int> &d
){

  #pragma HLS DATAFLOW disable_start_propagation
  #pragma HLS INTERFACE mode=ap_ctrl_none port=return

  #pragma HLS INTERFACE port=a ap_fifo
  #pragma HLS INTERFACE port=b axis
  #pragma HLS INTERFACE port=c ap_fifo
  #pragma HLS INTERFACE port=d axis

  c.write( a.read() + b.read() );
  d.write( a.read() - b.read() );
}

