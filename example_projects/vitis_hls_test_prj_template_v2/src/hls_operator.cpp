//------------------------------------------------------------------------------
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

#include "ap_int.h"
#include "hls_stream.h"

//#include "hls_operator.h"


//==================================================================================================
void stream_splitter(
  hls::stream<int> &is,
  hls::stream<int> &os1,
  hls::stream<int> &os2
){

//#pragma HLS INLINE

  int data;
  data = is.read();

  os1.write( data );
  os2.write( data );
}

//==================================================================================================
void func_1(
  hls::stream<int> &is,
  hls::stream<int> &os
){

//#pragma HLS INLINE

  const int st_k = 5;

  os.write( is.read() + st_k );
}


//==================================================================================================
void func_2(
  hls::stream<int> &is,
  hls::stream<int> &os
){

//#pragma HLS INLINE

  static int st_k;

  os.write( is.read() + st_k );

  if( st_k < 4 ){
    st_k++;
  } else {
    st_k = 0;
  }
}


//==================================================================================================
void func_3(
  hls::stream<int> &is,
  hls::stream<int> &os
){

//#pragma HLS INLINE

  //#pragma HLS DATAFLOW disable_start_propagation
  //#pragma HLS INTERFACE mode=ap_ctrl_none port=return

  os.write( is.read() / 13 );
}


//==================================================================================================
void hls_operator(
  hls::stream<int> &a,
  hls::stream<int> &b,
  hls::stream<int> &c,
  hls::stream<int> &d
){

  #pragma HLS DATAFLOW disable_start_propagation
  #pragma HLS INTERFACE mode=ap_ctrl_none port=return

  //#pragma HLS PIPELINE

  #pragma HLS INTERFACE port=a ap_fifo
  #pragma HLS INTERFACE port=b ap_fifo
  #pragma HLS INTERFACE port=c ap_fifo
  #pragma HLS INTERFACE port=d ap_fifo


  hls::stream<int> a1;
  hls::stream<int> a2;
  stream_splitter(a, a1, a2);


  // first branch (short)
  hls::stream<int> fa_os;
  func_1( a1, fa_os );


  // second branch (long)
  hls::stream<int> fb_os;
  func_2( a2, fb_os );

  hls::stream<int> fc_os;
  func_3( fb_os, fc_os );


  b.write( fa_os.read() + fc_os.read() );

}

