// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT1.v,v 1.6 2005/03/14 22:32:54 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 8.1i (I.13)
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  1-input Look-Up-Table with General Output
// /___/   /\     Filename : LUT1.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:53 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
// End Revision

`timescale  100 ps / 10 ps


module LUT1 (O, I0);

    parameter INIT = 2'h0;

    input I0;

    output O;
    
    wire O;

    assign O = (INIT[0] == INIT[1]) ? INIT[0] : INIT[I0];

endmodule
