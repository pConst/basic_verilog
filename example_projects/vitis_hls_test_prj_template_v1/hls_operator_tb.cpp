//------------------------------------------------------------------------------
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

#include "ap_int.h"

#include "hls_operator.h"

using namespace std;

int main() {

  const int Ni = 3;
  const int Nj = 5;

  for (int i = 0; i < Ni; ++i) {
    for (int j = 1; j < Nj; j=j*2) {

      int result;
      result = hls_operator( i, j );
      cout << i << " @ " << j << " = " << result << endl;
    }
  }

  return 0;
}

