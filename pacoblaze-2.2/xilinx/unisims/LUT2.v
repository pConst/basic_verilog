// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT2.v,v 1.6 2005/03/14 22:32:54 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 8.1i (I.13)
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-input Look-Up-Table with General Output
// /___/   /\     Filename : LUT2.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:53 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
// End Revision

`timescale  100 ps / 10 ps


module LUT2 (O, I0, I1);

    parameter INIT = 4'h0;

    input I0, I1;

    output O;

    reg  O;
    wire [1:0] s;

    assign s = {I1, I0};

    always @(s)
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           O = INIT[s];
         else if ((INIT[0] == INIT[1]) && (INIT[2] == INIT[3]) && (INIT[0] == INIT[2])) 
           O = INIT[0];
         else if ((s[1] == 0) && (INIT[0] == INIT[1]))
           O = INIT[0];
         else if ((s[1] == 1) && (INIT[2] == INIT[3])) 
           O = INIT[2];
         else if ((s[0] == 0) && (INIT[0] == INIT[2])) 
           O = INIT[0];
         else if ((s[0] == 1) && (INIT[1] == INIT[3]))
           O = INIT[1];
         else
           O = 1'bx;
endmodule
