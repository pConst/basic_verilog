// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT3.v,v 1.6 2005/03/14 22:32:54 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 8.1i (I.13)
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  3-input Look-Up-Table with General Output
// /___/   /\     Filename : LUT3.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
// End Revision

`timescale  100 ps / 10 ps


module LUT3 (O, I0, I1, I2);

    parameter INIT = 8'h00;

    input I0, I1, I2;

    output O;

    reg O;
    reg tmp;
  
    always @(  I2 or  I1 or  I0 )  begin
      tmp =  I0 ^ I1  ^ I2;
      if ( tmp == 0 || tmp == 1)
           O = INIT[{I2, I1, I0}];
      else
           O = lut3_mux4 ( {1'b0, 1'b0, lut3_mux4 (INIT[7:4], {I1, I0}),
                          lut3_mux4 (INIT[3:0], {I1, I0}) }, {1'b0, I2});
    end

  function lut3_mux4;
  input [3:0] d;
  input [1:0] s;

  begin
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           lut3_mux4 = d[s];
         else if ((d[0] === d[1]) && (d[2] === d[3]) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut3_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3]))
           lut3_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut3_mux4 = d[1];
         else
           lut3_mux4 = 1'bx;
   end
   endfunction

endmodule


