// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/RAM64X1S.v,v 1.8 2005/03/14 22:32:58 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 8.1i (I.13)
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Static Synchronous RAM 64-Deep by 1-Wide
// /___/   /\     Filename : RAM64X1S.v
// \   \  /  \    Timestamp : Thu Mar 25 16:43:34 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Remove for-loop in initial block;
// End Revision

`timescale  1 ps / 1 ps


module RAM64X1S (O, A0, A1, A2, A3, A4, A5, D, WCLK, WE);

    parameter INIT = 64'h0000000000000000;

    output O;

    input  A0, A1, A2, A3, A4, A5, D, WCLK, WE;

    reg   [63:0] mem;
    wire [5:0] adr;

    assign adr = {A5, A4, A3, A2, A1, A0};
    assign O = mem[adr];

    initial 
        mem = INIT;

    always @(posedge WCLK) 
        if (WE == 1'b1)
            mem[adr] <= #100 D;

endmodule

