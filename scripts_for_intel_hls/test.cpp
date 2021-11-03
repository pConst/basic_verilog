#include "HLS/hls.h"
#include <HLS/stdio.h>
#include <HLS/math.h>
#include <stdint.h>

using namespace ihc;

//component unsigned int test() {
//  static unsigned int cnt = 0;
//  return cnt++;
//}

component int dut(int a, int b) {
  return a*b;
}

int main (void) {
  //int x1, x2, x3;
  int x[3];

  for (int i = 0; i < 3; i++) x[i]=1;
  printf("1: x1 = %d, x2 = %d, x3 = %d\n", x[0], x[1], x[2]);

  x[0] = dut(7, 8);
  x[1] = dut(9, 10);
  x[2] = dut(11, 12);
  printf("2: x1 = %d, x2 = %d, x3 = %d\n", x[0], x[1], x[2]);


  for (int i = 0; i < 3; i++) x[i]=2;
  printf("3: x1 = %d, x2 = %d, x3 = %d\n", x[0], x[1], x[2]);

  ihc_hls_enqueue((int*)(x+0), &dut,  7,  8);
  ihc_hls_enqueue((int*)(x+1), &dut,  9, 10);
  ihc_hls_enqueue((int*)(x+2), &dut, 11, 12);
  ihc_hls_component_run_all(dut);
  printf("4: x1 = %d, x2 = %d, x3 = %d\n", x[0], x[1], x[2]);

  return 0;
}
