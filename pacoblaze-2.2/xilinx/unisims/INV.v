// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/INV.v,v 1.5 2005/03/14 22:32:53 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 8.1i (I.13)
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Inverter
// /___/   /\     Filename : INV.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:37 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
// End Revision

`timescale  100 ps / 10 ps


module INV (O, I);

    output O;

    input  I;

	not N1 (O, I);

endmodule

