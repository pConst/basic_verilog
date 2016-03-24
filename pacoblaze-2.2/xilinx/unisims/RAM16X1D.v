// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/RAM16X1D.v,v 1.8 2005/03/14 22:32:58 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 8.1i (I.13)
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Static Dual Port Synchronous RAM 16-Deep by 1-Wide
// /___/   /\     Filename : RAM16X1D.v
// \   \  /  \    Timestamp : Thu Mar 25 16:43:33 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Remove for-loop in initial block;
// End Revision

`timescale  1 ps / 1 ps


module RAM16X1D (DPO, SPO, A0, A1, A2, A3, D, DPRA0, DPRA1, DPRA2, DPRA3, WCLK, WE);

    parameter INIT = 16'h0000;

    output DPO, SPO;

    input  A0, A1, A2, A3, D, DPRA0, DPRA1, DPRA2, DPRA3, WCLK, WE;

    reg  [15:0] mem;
    wire [3:0] adr;

    assign adr = {A3, A2, A1, A0};
    assign SPO = mem[adr];
    assign DPO = mem[{DPRA3, DPRA2, DPRA1, DPRA0}];

    initial 
        mem = INIT;

    always @(posedge WCLK) 
        if (WE == 1'b1)
            mem[adr] <= #100 D;

endmodule

