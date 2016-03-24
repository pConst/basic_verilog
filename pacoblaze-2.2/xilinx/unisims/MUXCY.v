// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/MUXCY.v,v 1.8 2005/03/14 22:32:55 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 8.1i (I.13)
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-to-1 Multiplexer for Carry Logic with General Output
// /___/   /\     Filename : MUXCY.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:55 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Remove unnessasary begin/end;
// End Revision

`timescale  100 ps / 10 ps


module MUXCY (O, CI, DI, S);

    output O;
    reg    O;

    input  CI, DI, S;

	always @(CI or DI or S) begin
	    if (S)
		O <= CI;
	    else
		O <= DI;
	end


endmodule

