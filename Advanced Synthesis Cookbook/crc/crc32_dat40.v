// Copyright 2007 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

//// CRC-32 of 40 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 0000000000111111111122222222223333333333
//        01234567890123456789012345678901 0123456789012345678901234567890123456789
//
// C00  = .XX.X...X.......XXX.XXXXX.X..X.. X.....X..XX.X...X.......XXX.XXXXX.X..X..
// C01  = .X.XXX..XX......X..XX....XXX.XX. XX....XX.X.XXX..XX......X..XX....XXX.XX.
// C02  = XX...XX.XXX.....X.X...XXX..XXXXX XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX
// C03  = XXX...XX.XXX.....X.X...XXX..XXXX .XXX...XXXX...XX.XXX.....X.X...XXX..XXXX
// C04  = X..XX..X..XXX...XX...XXX.X....XX X.XXX.X.X..XX..X..XXX...XX...XXX.X....XX
// C05  = ..X..X.....XXX..X...XX.......X.X XX.XXXXX..X..X.....XXX..X...XX.......X.X
// C06  = X..X..X.....XXX..X...XX.......X. .XX.XXXXX..X..X.....XXX..X...XX.......X.
// C07  = X.X....XX....XXXXX..XX..X.X..X.X X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X
// C08  = X.XXX....X....XX....X..XXXXX.XX. XX.XX...X.XXX....X....XX....X..XXXXX.XX.
// C09  = .X.XXX....X....XX....X..XXXXX.XX .XX.XX...X.XXX....X....XX....X..XXXXX.XX
// C10  = .X...XX.X..X......X.XX.XXX.XX..X X.XX.X...X...XX.X..X......X.XX.XXX.XX..X
// C11  = .X..X.XXXX..X...XXXXX..X.X..X... XX.XX....X..X.XXXX..X...XXXXX..X.X..X...
// C12  = .X..XX.X.XX..X..X..X..XX........ XXX.XXX..X..XX.X.XX..X..X..X..XX........
// C13  = ..X..XX.X.XX..X..X..X..XX....... .XXX.XXX..X..XX.X.XX..X..X..X..XX.......
// C14  = X..X..XX.X.XX..X..X..X..XX...... ..XXX.XXX..X..XX.X.XX..X..X..X..XX......
// C15  = XX..X..XX.X.XX..X..X..X..XX..... ...XXX.XXX..X..XX.X.XX..X..X..X..XX.....
// C16  = X...XX...X.X.XX.X.X..XX.X..X.X.. X...XX..X...XX...X.X.XX.X.X..XX.X..X.X..
// C17  = .X...XX...X.X.XX.X.X..XX.X..X.X. .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X.
// C18  = ..X...XX...X.X.XX.X.X..XX.X..X.X ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X
// C19  = X..X...XX...X.X.XX.X.X..XX.X..X. ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.
// C20  = XX..X...XX...X.X.XX.X.X..XX.X..X ....X...XX..X...XX...X.X.XX.X.X..XX.X..X
// C21  = .XX..X...XX...X.X.XX.X.X..XX.X.. .....X...XX..X...XX...X.X.XX.X.X..XX.X..
// C22  = .X.XX.X.X.XX...XX.XX.X.X..XXXXX. X........X.XX.X.X.XX...XX.XX.X.X..XXXXX.
// C23  = .X...X.XXX.XX.....XX.X.X..XXX.XX XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX
// C24  = ..X...X.XXX.XX.....XX.X.X..XXX.X .XX....X..X...X.XXX.XX.....XX.X.X..XXX.X
// C25  = X..X...X.XXX.XX.....XX.X.X..XXX. ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.
// C26  = ..X.......XXX.XXXXX.X..X......XX X..XX.X...X.......XXX.XXXXX.X..X......XX
// C27  = ...X.......XXX.XXXXX.X..X......X .X..XX.X...X.......XXX.XXXXX.X..X......X
// C28  = X...X.......XXX.XXXXX.X..X...... ..X..XX.X...X.......XXX.XXXXX.X..X......
// C29  = .X...X.......XXX.XXXXX.X..X..... ...X..XX.X...X.......XXX.XXXXX.X..X.....
// C30  = X.X...X.......XXX.XXXXX.X..X.... ....X..XX.X...X.......XXX.XXXXX.X..X....
// C31  = XX.X...X.......XXX.XXXXX.X..X... .....X..XX.X...X.......XXX.XXXXX.X..X...
//
module crc32_dat40 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [39:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat40_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat40_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat40_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [39:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x7, x6, x5, x4, x3, x2, x1, 
       x0, x31, x30, x29, x28, x27, x26, x25, 
       x24, x23, x22, x21, x20, x19, x18, x17, 
       x16, x15, x14, x13, x12, x11, x10, x9, 
       x8;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39;

assign { d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [39:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x7 = c16 ^ d34 ^ d37 ^ d10 ^ c26 ^ d29 ^ c17 ^ d21 ^ d15 ^ 
        d32 ^ c14 ^ c8 ^ c31 ^ d16 ^ d5 ^ c7 ^ d0 ^ d3 ^ d39 ^ 
        d8 ^ c15 ^ d28 ^ d2 ^ c20 ^ c0 ^ d22 ^ d23 ^ c13 ^ c29 ^ 
        d25 ^ c2 ^ c21 ^ d24 ^ c24 ^ d7;  // 35 ins 1 outs

    assign x6 = d7 ^ c0 ^ d2 ^ c3 ^ d29 ^ c22 ^ d38 ^ d5 ^ d30 ^ 
        d20 ^ c30 ^ c6 ^ d1 ^ d25 ^ c21 ^ c17 ^ d14 ^ c13 ^ d4 ^ 
        d8 ^ d22 ^ d11 ^ c12 ^ d21 ^ c14 ^ d6;  // 26 ins 1 outs

    assign x5 = d28 ^ c29 ^ c2 ^ c16 ^ d13 ^ c21 ^ d24 ^ d4 ^ d29 ^ 
        d19 ^ d10 ^ d37 ^ c13 ^ c20 ^ d7 ^ d6 ^ d1 ^ c12 ^ c31 ^ 
        d20 ^ d0 ^ d39 ^ d21 ^ c5 ^ c11 ^ d3 ^ d5;  // 27 ins 1 outs

    assign x4 = d25 ^ c3 ^ c17 ^ c21 ^ d11 ^ d33 ^ d18 ^ d39 ^ d24 ^ 
        d29 ^ d6 ^ d3 ^ c16 ^ c31 ^ c23 ^ c12 ^ d38 ^ d8 ^ d12 ^ 
        c10 ^ d30 ^ d0 ^ c4 ^ c22 ^ c11 ^ d20 ^ c30 ^ d31 ^ d15 ^ 
        d19 ^ c25 ^ d2 ^ c7 ^ c0 ^ d4;  // 35 ins 1 outs

    assign x3 = d31 ^ c24 ^ c17 ^ c25 ^ d10 ^ d1 ^ d18 ^ c0 ^ d2 ^ 
        d33 ^ c19 ^ c6 ^ d36 ^ d14 ^ d27 ^ d8 ^ d19 ^ d15 ^ c29 ^ 
        c28 ^ c10 ^ d25 ^ d32 ^ d37 ^ d39 ^ c30 ^ d17 ^ c2 ^ c11 ^ 
        c23 ^ c9 ^ d38 ^ c31 ^ d9 ^ c7 ^ d7 ^ c1 ^ d3;  // 38 ins 1 outs

    assign x2 = d31 ^ d13 ^ d38 ^ c8 ^ c27 ^ d35 ^ c5 ^ d1 ^ c31 ^ 
        d14 ^ c1 ^ c30 ^ d7 ^ c22 ^ c9 ^ d37 ^ c10 ^ c16 ^ c28 ^ 
        d8 ^ c6 ^ d17 ^ d0 ^ d36 ^ c18 ^ d24 ^ d32 ^ d26 ^ c24 ^ 
        d16 ^ d30 ^ c29 ^ d6 ^ d9 ^ d18 ^ d39 ^ c23 ^ c0 ^ d2;  // 39 ins 1 outs

    assign x1 = c20 ^ d28 ^ c4 ^ d0 ^ d37 ^ d24 ^ c25 ^ d12 ^ d6 ^ 
        d9 ^ d7 ^ c29 ^ c1 ^ c19 ^ d33 ^ c3 ^ c26 ^ d13 ^ d38 ^ 
        c9 ^ c8 ^ d34 ^ d17 ^ d11 ^ c30 ^ d16 ^ d27 ^ c16 ^ c27 ^ 
        d35 ^ c5 ^ d1;  // 32 ins 1 outs

    assign x0 = d31 ^ d30 ^ d12 ^ c23 ^ c16 ^ d34 ^ c8 ^ d29 ^ d9 ^ 
        d6 ^ d37 ^ d10 ^ c24 ^ d24 ^ c21 ^ c2 ^ c17 ^ c1 ^ d25 ^ 
        c29 ^ d32 ^ c26 ^ d26 ^ c18 ^ c20 ^ d28 ^ d16 ^ c22 ^ c4 ^ 
        d0;  // 30 ins 1 outs

    assign x31 = d24 ^ d15 ^ c25 ^ c22 ^ c23 ^ d8 ^ d25 ^ c19 ^ d30 ^ 
        d27 ^ c17 ^ c16 ^ d33 ^ d29 ^ c21 ^ d28 ^ d31 ^ c15 ^ d11 ^ 
        c0 ^ c20 ^ c7 ^ d23 ^ d9 ^ c1 ^ d5 ^ c3 ^ d36 ^ c28;  // 29 ins 1 outs

    assign x30 = d29 ^ c15 ^ d32 ^ d7 ^ c0 ^ c21 ^ d10 ^ c22 ^ d24 ^ 
        d4 ^ d30 ^ c2 ^ d35 ^ d8 ^ d14 ^ c16 ^ d26 ^ c14 ^ c18 ^ 
        c27 ^ d27 ^ d28 ^ c6 ^ c19 ^ c24 ^ c20 ^ d22 ^ d23;  // 28 ins 1 outs

    assign x29 = d9 ^ d28 ^ d29 ^ c20 ^ d23 ^ c15 ^ d13 ^ d3 ^ c1 ^ 
        d22 ^ d34 ^ c23 ^ c5 ^ c26 ^ d6 ^ d25 ^ c13 ^ c18 ^ c17 ^ 
        d26 ^ d27 ^ d31 ^ c14 ^ d7 ^ c21 ^ c19 ^ d21;  // 27 ins 1 outs

    assign x28 = d33 ^ c25 ^ d12 ^ d2 ^ c16 ^ d26 ^ d21 ^ c13 ^ c18 ^ 
        d25 ^ c17 ^ d28 ^ d5 ^ c20 ^ d27 ^ c12 ^ d24 ^ d8 ^ d22 ^ 
        c4 ^ d30 ^ c22 ^ c19 ^ d6 ^ d20 ^ c14 ^ c0;  // 27 ins 1 outs

    assign x27 = d29 ^ d26 ^ d11 ^ d4 ^ c18 ^ c17 ^ c31 ^ c16 ^ d24 ^ 
        c24 ^ c3 ^ c15 ^ d23 ^ c11 ^ d5 ^ c12 ^ c19 ^ d21 ^ d20 ^ 
        d25 ^ d32 ^ d19 ^ d7 ^ d39 ^ c13 ^ d27 ^ c21 ^ d1;  // 28 ins 1 outs

    assign x26 = d31 ^ d6 ^ c11 ^ d24 ^ c17 ^ d28 ^ d0 ^ d22 ^ d3 ^ 
        c20 ^ c15 ^ d25 ^ c18 ^ c16 ^ c14 ^ c10 ^ c23 ^ d26 ^ c2 ^ 
        c30 ^ d39 ^ d38 ^ d10 ^ d4 ^ d18 ^ d19 ^ d20 ^ c31 ^ c12 ^ 
        d23;  // 30 ins 1 outs

    assign x25 = d31 ^ d36 ^ c20 ^ c23 ^ d11 ^ c0 ^ d19 ^ d15 ^ c25 ^ 
        d37 ^ c30 ^ c10 ^ c14 ^ c13 ^ d8 ^ c28 ^ c7 ^ d2 ^ d18 ^ 
        d22 ^ d17 ^ d29 ^ c9 ^ c3 ^ d38 ^ c29 ^ d21 ^ d28 ^ d3 ^ 
        d33 ^ c21 ^ c11;  // 32 ins 1 outs

    assign x24 = c22 ^ c9 ^ d30 ^ d36 ^ c20 ^ c24 ^ d37 ^ d17 ^ c19 ^ 
        d35 ^ d20 ^ d16 ^ d14 ^ c29 ^ d32 ^ c31 ^ c8 ^ c12 ^ d21 ^ 
        d7 ^ d28 ^ c10 ^ d39 ^ d10 ^ d1 ^ d18 ^ c6 ^ c27 ^ d27 ^ 
        d2 ^ c13 ^ c2 ^ c28;  // 33 ins 1 outs

    assign x23 = c1 ^ d13 ^ d38 ^ c21 ^ c30 ^ d6 ^ d36 ^ c12 ^ d17 ^ 
        d16 ^ d19 ^ d31 ^ c28 ^ d15 ^ d27 ^ d1 ^ d9 ^ c31 ^ d29 ^ 
        c19 ^ c11 ^ d0 ^ d20 ^ c9 ^ c8 ^ d34 ^ c5 ^ c7 ^ c18 ^ 
        c23 ^ d35 ^ c27 ^ d26 ^ c26 ^ d39;  // 35 ins 1 outs

    assign x22 = d12 ^ c29 ^ d38 ^ c11 ^ d37 ^ c3 ^ c10 ^ d35 ^ d31 ^ 
        c18 ^ d14 ^ d0 ^ d26 ^ c6 ^ d27 ^ c21 ^ c30 ^ c4 ^ d16 ^ 
        d19 ^ d24 ^ d9 ^ d36 ^ c27 ^ c1 ^ c26 ^ d29 ^ d11 ^ c28 ^ 
        d23 ^ c19 ^ d18 ^ c8 ^ d34 ^ c16 ^ c15 ^ c23;  // 37 ins 1 outs

    assign x21 = c10 ^ d34 ^ d9 ^ c2 ^ c21 ^ d29 ^ d17 ^ c23 ^ c19 ^ 
        d13 ^ c5 ^ d27 ^ d18 ^ c18 ^ c16 ^ d31 ^ c29 ^ d26 ^ c26 ^ 
        c1 ^ d5 ^ c9 ^ c27 ^ d10 ^ d35 ^ d37 ^ c14 ^ d22 ^ d24;  // 29 ins 1 outs

    assign x20 = d34 ^ d17 ^ c22 ^ d39 ^ c31 ^ c20 ^ d8 ^ c1 ^ c28 ^ 
        d28 ^ c17 ^ d12 ^ c4 ^ c9 ^ d30 ^ d33 ^ c25 ^ c8 ^ c13 ^ 
        d23 ^ d36 ^ c18 ^ c0 ^ d25 ^ d4 ^ c15 ^ d26 ^ d9 ^ c26 ^ 
        d21 ^ d16;  // 31 ins 1 outs

    assign x19 = d16 ^ c19 ^ d38 ^ c30 ^ d15 ^ d7 ^ c0 ^ c24 ^ c16 ^ 
        c25 ^ d27 ^ d11 ^ c3 ^ c12 ^ d33 ^ d25 ^ d24 ^ c8 ^ c21 ^ 
        d22 ^ d3 ^ c27 ^ c7 ^ d35 ^ d29 ^ d8 ^ c14 ^ c17 ^ d32 ^ 
        d20;  // 30 ins 1 outs

    assign x18 = d14 ^ d15 ^ d26 ^ c29 ^ c7 ^ d10 ^ c20 ^ c15 ^ c24 ^ 
        c2 ^ d6 ^ d34 ^ c31 ^ c23 ^ d32 ^ c13 ^ d24 ^ d2 ^ d28 ^ 
        d21 ^ d31 ^ c11 ^ d7 ^ c18 ^ d19 ^ d39 ^ c26 ^ c6 ^ c16 ^ 
        d23 ^ d37;  // 31 ins 1 outs

    assign x17 = d27 ^ c28 ^ d36 ^ d30 ^ d5 ^ c22 ^ d9 ^ d38 ^ c23 ^ 
        c30 ^ c1 ^ c10 ^ c6 ^ d14 ^ d6 ^ c25 ^ d13 ^ d22 ^ d33 ^ 
        d20 ^ c12 ^ d1 ^ c14 ^ c19 ^ c5 ^ d25 ^ d23 ^ c17 ^ d31 ^ 
        c15 ^ d18;  // 31 ins 1 outs

    assign x16 = c27 ^ c16 ^ d13 ^ d32 ^ d8 ^ d4 ^ c18 ^ c11 ^ d26 ^ 
        d17 ^ d22 ^ c0 ^ d29 ^ c5 ^ c14 ^ d37 ^ d21 ^ d19 ^ d0 ^ 
        c21 ^ d12 ^ d5 ^ c29 ^ c4 ^ c9 ^ c22 ^ d24 ^ c24 ^ d35 ^ 
        d30 ^ c13;  // 31 ins 1 outs

    assign x15 = d34 ^ d9 ^ c19 ^ d16 ^ d7 ^ d21 ^ c10 ^ d24 ^ d4 ^ 
        d5 ^ d18 ^ d33 ^ c25 ^ c26 ^ d12 ^ d15 ^ d20 ^ c12 ^ c13 ^ 
        d27 ^ c4 ^ c8 ^ c7 ^ c16 ^ d8 ^ c22 ^ d30 ^ c0 ^ d3 ^ 
        c1;  // 30 ins 1 outs

    assign x14 = d32 ^ c0 ^ d2 ^ d20 ^ d4 ^ d33 ^ d26 ^ d15 ^ d3 ^ 
        d14 ^ d23 ^ c18 ^ c7 ^ c3 ^ c9 ^ d6 ^ c15 ^ c6 ^ c24 ^ 
        d29 ^ c12 ^ d8 ^ c21 ^ c11 ^ d19 ^ d7 ^ d17 ^ d11 ^ c25;  // 29 ins 1 outs

    assign x13 = d13 ^ d19 ^ c10 ^ c2 ^ d25 ^ d18 ^ d32 ^ d7 ^ c8 ^ 
        c17 ^ d22 ^ d1 ^ d10 ^ d3 ^ d2 ^ c23 ^ c24 ^ d31 ^ d28 ^ 
        c6 ^ c20 ^ d6 ^ c11 ^ d14 ^ c14 ^ c5 ^ d16 ^ d5;  // 28 ins 1 outs

    assign x12 = d24 ^ d18 ^ c16 ^ c23 ^ d12 ^ d2 ^ d6 ^ d1 ^ c1 ^ 
        c10 ^ d13 ^ d21 ^ c19 ^ d17 ^ d0 ^ d27 ^ d15 ^ c7 ^ c5 ^ 
        d9 ^ d30 ^ d4 ^ d31 ^ c9 ^ d5 ^ c4 ^ c22 ^ c13;  // 28 ins 1 outs

    assign x11 = d0 ^ c8 ^ c25 ^ d4 ^ d14 ^ d9 ^ c16 ^ d1 ^ d25 ^ 
        c23 ^ c6 ^ d3 ^ c28 ^ d17 ^ d27 ^ d16 ^ d31 ^ d33 ^ d36 ^ 
        c19 ^ d12 ^ c1 ^ d15 ^ d24 ^ c17 ^ c9 ^ d20 ^ c4 ^ c12 ^ 
        c7 ^ d28 ^ c20 ^ c18 ^ d26;  // 34 ins 1 outs

    assign x10 = d36 ^ d5 ^ d35 ^ d39 ^ d9 ^ c24 ^ d19 ^ c6 ^ c11 ^ 
        d31 ^ c28 ^ c1 ^ c23 ^ c25 ^ d29 ^ c21 ^ d3 ^ d32 ^ c8 ^ 
        c27 ^ d16 ^ d13 ^ d28 ^ d14 ^ c5 ^ c31 ^ d0 ^ d33 ^ d2 ^ 
        c20 ^ c18 ^ d26;  // 32 ins 1 outs

    assign x9 = d29 ^ d39 ^ c26 ^ d36 ^ d5 ^ d23 ^ c30 ^ c31 ^ d38 ^ 
        d13 ^ d24 ^ c25 ^ c28 ^ d34 ^ c1 ^ c10 ^ c15 ^ c21 ^ d2 ^ 
        d18 ^ d12 ^ c3 ^ d32 ^ c16 ^ d33 ^ c24 ^ c4 ^ d4 ^ d11 ^ 
        d1 ^ c5 ^ d35 ^ c27 ^ d9;  // 34 ins 1 outs

    assign x8 = d28 ^ d35 ^ d34 ^ c24 ^ c26 ^ d32 ^ c25 ^ c2 ^ c23 ^ 
        c20 ^ d1 ^ d10 ^ c0 ^ c27 ^ d22 ^ d0 ^ d4 ^ d12 ^ d31 ^ 
        c30 ^ d11 ^ d17 ^ c4 ^ c9 ^ d38 ^ c29 ^ d23 ^ d3 ^ c15 ^ 
        d37 ^ c3 ^ d33 ^ c14 ^ d8;  // 34 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat40_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [39:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x123, x122, x121, x120, x119, x118, x117, 
       x116, x115, x114, x113, x112, x111, x110, x109, 
       x108, x107, x106, x105, x104, x103, x102, x101, 
       x100, x99, x98, x97, x96, x95, x94, x93, 
       x92, x91, x90, x89, x88, x87, x86, x85, 
       x84, x83, x82, x81, x80, x79, x78, x77, 
       x76, x75, x74, x73, x72, x71, x70, x69, 
       x68, x67, x66, x65, x64, x63, x62, x61, 
       x60, x59, x58, x57, x56, x55, x54, x53, 
       x52, x51, x50, x49, x48, x47, x46, x45, 
       x44, x43, x42, x41, x40, x39, x38, x37, 
       x36, x35, x34, x33, x32, x7, x6, x5, 
       x4, x3, x2, x1, x0, x31, x30, x29, 
       x28, x27, x26, x25, x24, x23, x22, x21, 
       x20, x19, x18, x17, x16, x15, x14, x13, 
       x12, x11, x10, x9, x8;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39;

assign { d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [39:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x123i (.out(x123),.a(d12),.b(d31),.c(c23),.d(c24),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x122i (.out(x122),.a(d9),.b(d2),.c(x96),.d(x33),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x121i (.out(x121),.a(x55),.b(c8),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x120i (.out(x120),.a(d16),.b(d1),.c(d7),.d(d6),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x119i (.out(x119),.a(d16),.b(d1),.c(x94),.d(d20),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x118i (.out(x118),.a(x34),.b(c8),.c(d23),.d(d19),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x117i (.out(x117),.a(x36),.b(d4),.c(c10),.d(d16),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x116i (.out(x116),.a(c3),.b(c14),.c(x93),.d(x48),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x115i (.out(x115),.a(d14),.b(c18),.c(x92),.d(d33),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x114i (.out(x114),.a(x48),.b(x63),.c(d5),.d(c24),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x113i (.out(x113),.a(x35),.b(d16),.c(d5),.d(c15),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x112i (.out(x112),.a(c27),.b(c19),.c(x87),.d(x51),.e(d18),.f(1'b0));  // 5 ins 1 outs

    xor6 x111i (.out(x111),.a(d14),.b(d6),.c(x41),.d(d20),.e(d39),.f(1'b0));  // 5 ins 1 outs

    xor6 x110i (.out(x110),.a(c2),.b(c18),.c(x32),.d(d26),.e(c26),.f(1'b0));  // 5 ins 1 outs

    xor6 x109i (.out(x109),.a(d15),.b(d14),.c(x55),.d(x48),.e(c30),.f(1'b0));  // 5 ins 1 outs

    xor6 x108i (.out(x108),.a(x84),.b(c17),.c(x45),.d(x33),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x107i (.out(x107),.a(d6),.b(x32),.c(c15),.d(x63),.e(c17),.f(1'b0));  // 5 ins 1 outs

    xor6 x106i (.out(x106),.a(x82),.b(x51),.c(x38),.d(c28),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x105i (.out(x105),.a(c6),.b(c30),.c(d38),.d(d32),.e(d6),.f(1'b0));  // 5 ins 1 outs

    xor6 x104i (.out(x104),.a(c12),.b(d4),.c(c4),.d(x51),.e(d20),.f(1'b0));  // 5 ins 1 outs

    xor6 x103i (.out(x103),.a(d35),.b(x41),.c(d4),.d(x37),.e(c6),.f(1'b0));  // 5 ins 1 outs

    xor6 x102i (.out(x102),.a(d10),.b(c2),.c(d35),.d(d25),.e(x38),.f(1'b0));  // 5 ins 1 outs

    xor6 x101i (.out(x101),.a(d11),.b(x50),.c(x33),.d(c3),.e(x72),.f(1'b0));  // 5 ins 1 outs

    xor6 x100i (.out(x100),.a(c6),.b(c17),.c(c19),.d(c25),.e(x34),.f(1'b0));  // 5 ins 1 outs

    xor6 x99i (.out(x99),.a(x46),.b(x42),.c(x55),.d(c17),.e(d2),.f(1'b0));  // 5 ins 1 outs

    xor6 x98i (.out(x98),.a(c20),.b(d23),.c(d28),.d(c1),.e(x35),.f(1'b0));  // 5 ins 1 outs

    xor6 x97i (.out(x97),.a(d1),.b(d3),.c(x44),.d(d19),.e(x47),.f(1'b0));  // 5 ins 1 outs

    xor6 x96i (.out(x96),.a(d4),.b(d36),.c(d23),.d(c1),.e(d32),.f(1'b0));  // 5 ins 1 outs

    xor6 x95i (.out(x95),.a(c18),.b(d26),.c(x50),.d(c19),.e(c11),.f(1'b0));  // 5 ins 1 outs

    xor6 x94i (.out(x94),.a(c30),.b(d38),.c(d25),.d(c12),.e(d27),.f(1'b0));  // 5 ins 1 outs

    xor6 x93i (.out(x93),.a(c13),.b(d11),.c(d36),.d(d21),.e(c17),.f(1'b0));  // 5 ins 1 outs

    xor6 x92i (.out(x92),.a(d26),.b(d27),.c(c14),.d(d22),.e(d2),.f(1'b0));  // 5 ins 1 outs

    xor6 x91i (.out(x91),.a(c5),.b(c19),.c(d6),.d(x32),.e(d27),.f(1'b0));  // 5 ins 1 outs

    xor6 x90i (.out(x90),.a(c0),.b(d32),.c(d8),.d(x41),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x89i (.out(x89),.a(c30),.b(d38),.c(d0),.d(x36),.e(x45),.f(1'b0));  // 5 ins 2 outs

    xor6 x88i (.out(x88),.a(x42),.b(d23),.c(c23),.d(d31),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x87i (.out(x87),.a(d14),.b(c17),.c(c10),.d(d7),.e(d6),.f(1'b0));  // 5 ins 1 outs

    xor6 x86i (.out(x86),.a(c6),.b(c24),.c(x38),.d(c11),.e(x37),.f(1'b0));  // 5 ins 1 outs

    xor6 x85i (.out(x85),.a(d18),.b(d36),.c(d39),.d(d28),.e(x37),.f(1'b0));  // 5 ins 1 outs

    xor6 x84i (.out(x84),.a(d25),.b(d32),.c(c19),.d(c31),.e(d19),.f(1'b0));  // 5 ins 1 outs

    xor6 x83i (.out(x83),.a(d23),.b(x33),.c(d25),.d(x45),.e(d28),.f(1'b0));  // 5 ins 1 outs

    xor6 x82i (.out(x82),.a(d5),.b(c4),.c(d1),.d(d30),.e(c22),.f(1'b0));  // 5 ins 1 outs

    xor6 x81i (.out(x81),.a(c31),.b(x63),.c(c6),.d(c12),.e(c28),.f(1'b0));  // 5 ins 1 outs

    xor6 x80i (.out(x80),.a(c4),.b(x51),.c(c7),.d(d39),.e(d15),.f(1'b0));  // 5 ins 2 outs

    xor6 x79i (.out(x79),.a(x36),.b(d10),.c(d27),.d(d34),.e(c24),.f(1'b0));  // 5 ins 1 outs

    xor6 x78i (.out(x78),.a(d38),.b(c7),.c(x47),.d(d12),.e(x40),.f(1'b0));  // 5 ins 1 outs

    xor6 x77i (.out(x77),.a(x42),.b(c11),.c(d7),.d(d39),.e(x36),.f(1'b0));  // 5 ins 1 outs

    xor6 x76i (.out(x76),.a(c8),.b(d32),.c(d35),.d(x45),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x75i (.out(x75),.a(d17),.b(x44),.c(c28),.d(x50),.e(c9),.f(1'b0));  // 5 ins 2 outs

    xor6 x74i (.out(x74),.a(x35),.b(d25),.c(d4),.d(d12),.e(1'b0),.f(1'b0));  // 4 ins 4 outs

    xor6 x73i (.out(x73),.a(d3),.b(c20),.c(x48),.d(d7),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x72i (.out(x72),.a(c24),.b(d20),.c(d6),.d(c11),.e(d30),.f(1'b0));  // 5 ins 2 outs

    xor6 x71i (.out(x71),.a(d23),.b(d2),.c(c21),.d(x45),.e(d29),.f(1'b0));  // 5 ins 2 outs

    xor6 x70i (.out(x70),.a(x36),.b(c20),.c(c31),.d(d22),.e(c28),.f(1'b0));  // 5 ins 1 outs

    xor6 x69i (.out(x69),.a(d0),.b(d39),.c(c8),.d(d2),.e(x46),.f(1'b0));  // 5 ins 2 outs

    xor6 x68i (.out(x68),.a(c1),.b(d27),.c(d16),.d(x40),.e(d9),.f(1'b0));  // 5 ins 2 outs

    xor6 x67i (.out(x67),.a(d30),.b(x46),.c(d27),.d(c22),.e(d23),.f(1'b0));  // 5 ins 2 outs

    xor6 x66i (.out(x66),.a(x47),.b(c0),.c(d8),.d(x36),.e(d19),.f(1'b0));  // 5 ins 2 outs

    xor6 x65i (.out(x65),.a(c25),.b(c28),.c(x47),.d(d33),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x64i (.out(x64),.a(d19),.b(x34),.c(c31),.d(d28),.e(d5),.f(1'b0));  // 5 ins 2 outs

    xor6 x63i (.out(x63),.a(d14),.b(d36),.c(c22),.d(c15),.e(d30),.f(1'b0));  // 5 ins 3 outs

    xor6 x62i (.out(x62),.a(x37),.b(d7),.c(x41),.d(c8),.e(d3),.f(1'b0));  // 5 ins 3 outs

    xor6 x61i (.out(x61),.a(d14),.b(c10),.c(d18),.d(d39),.e(x47),.f(1'b0));  // 5 ins 3 outs

    xor6 x60i (.out(x60),.a(c27),.b(d25),.c(c15),.d(x34),.e(c31),.f(1'b0));  // 5 ins 2 outs

    xor6 x59i (.out(x59),.a(c13),.b(d21),.c(d34),.d(x46),.e(c26),.f(1'b0));  // 5 ins 3 outs

    xor6 x58i (.out(x58),.a(d14),.b(c22),.c(d20),.d(d5),.e(x44),.f(1'b0));  // 5 ins 5 outs

    xor6 x57i (.out(x57),.a(c23),.b(d31),.c(d2),.d(d19),.e(x38),.f(1'b0));  // 5 ins 3 outs

    xor6 x56i (.out(x56),.a(x51),.b(d28),.c(c19),.d(d33),.e(c20),.f(1'b0));  // 5 ins 3 outs

    xor6 x55i (.out(x55),.a(d6),.b(c12),.c(d20),.d(c9),.e(d17),.f(1'b0));  // 5 ins 3 outs

    xor6 x54i (.out(x54),.a(c8),.b(x32),.c(x42),.d(x34),.e(c27),.f(1'b0));  // 5 ins 3 outs

    xor6 x53i (.out(x53),.a(c15),.b(d32),.c(d7),.d(x40),.e(c4),.f(1'b0));  // 5 ins 4 outs

    xor6 x52i (.out(x52),.a(c19),.b(x33),.c(c27),.d(d22),.e(c14),.f(1'b0));  // 5 ins 4 outs

    xor6 x51i (.out(x51),.a(c16),.b(d6),.c(d24),.d(c4),.e(1'b0),.f(1'b0));  // 4 ins 5 outs

    xor6 x50i (.out(x50),.a(d0),.b(c12),.c(d39),.d(c4),.e(c22),.f(1'b0));  // 5 ins 3 outs

    xor6 x49i (.out(x49),.a(d37),.b(x37),.c(x33),.d(c29),.e(c31),.f(1'b0));  // 5 ins 5 outs

    xor6 x48i (.out(x48),.a(c21),.b(d29),.c(c11),.d(d35),.e(d28),.f(1'b0));  // 5 ins 4 outs

    xor6 x47i (.out(x47),.a(c5),.b(d39),.c(d5),.d(d13),.e(1'b0),.f(1'b0));  // 4 ins 5 outs

    xor6 x46i (.out(x46),.a(c15),.b(c18),.c(d14),.d(c11),.e(d26),.f(1'b0));  // 5 ins 4 outs

    xor6 x45i (.out(x45),.a(c3),.b(d1),.c(d11),.d(d7),.e(1'b0),.f(1'b0));  // 4 ins 5 outs

    xor6 x44i (.out(x44),.a(d30),.b(c13),.c(d4),.d(c12),.e(d21),.f(1'b0));  // 5 ins 4 outs

    xor6 x43i (.out(x43),.a(c7),.b(d3),.c(x35),.d(d15),.e(1'b0),.f(1'b0));  // 4 ins 9 outs

    xor6 x42i (.out(x42),.a(d32),.b(c24),.c(d2),.d(d19),.e(c6),.f(1'b0));  // 5 ins 4 outs

    xor6 x41i (.out(x41),.a(d22),.b(d23),.c(d25),.d(c17),.e(c14),.f(1'b0));  // 5 ins 5 outs

    xor6 x40i (.out(x40),.a(d12),.b(c26),.c(c8),.d(d34),.e(c27),.f(1'b0));  // 5 ins 4 outs

    xor6 x39i (.out(x39),.a(c28),.b(d27),.c(d1),.d(c19),.e(x32),.f(1'b0));  // 5 ins 8 outs

    xor6 x38i (.out(x38),.a(c30),.b(c31),.c(d38),.d(c10),.e(d18),.f(1'b0));  // 5 ins 6 outs

    xor6 x37i (.out(x37),.a(d28),.b(c20),.c(c2),.d(d7),.e(d10),.f(1'b0));  // 5 ins 5 outs

    xor6 x36i (.out(x36),.a(c9),.b(d37),.c(d17),.d(d35),.e(c29),.f(1'b0));  // 5 ins 6 outs

    xor6 x35i (.out(x35),.a(c17),.b(c25),.c(c0),.d(d33),.e(d8),.f(1'b0));  // 5 ins 5 outs

    xor6 x34i (.out(x34),.a(d0),.b(d36),.c(c18),.d(d26),.e(d16),.f(1'b0));  // 5 ins 5 outs

    xor6 x33i (.out(x33),.a(c21),.b(d24),.c(c24),.d(c16),.e(d29),.f(1'b0));  // 5 ins 7 outs

    xor6 x32i (.out(x32),.a(d9),.b(c23),.c(d31),.d(d14),.e(c1),.f(1'b0));  // 5 ins 5 outs

    xor6 x7i (.out(x7),.a(x113),.b(x43),.c(x90),.d(x69),.e(x59),.f(x49));  // 6 ins 1 outs

    xor6 x6i (.out(x6),.a(x105),.b(x90),.c(x71),.d(x58),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x5i (.out(x5),.a(d0),.b(x97),.c(x49),.d(x72),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x4i (.out(x4),.a(x101),.b(x43),.c(x74),.d(x35),.e(x57),.f(1'b0));  // 5 ins 1 outs

    xor6 x3i (.out(x3),.a(d36),.b(x77),.c(x43),.d(x39),.e(x102),.f(1'b0));  // 5 ins 1 outs

    xor6 x2i (.out(x2),.a(d7),.b(x106),.c(x54),.d(x66),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x1i (.out(x1),.a(c5),.b(c25),.c(x89),.d(x68),.e(x56),.f(d13));  // 6 ins 1 outs

    xor6 x0i (.out(x0),.a(x107),.b(x53),.c(x60),.d(x49),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x31i (.out(x31),.a(x83),.b(x43),.c(x73),.d(x114),.e(x39),.f(1'b0));  // 5 ins 1 outs

    xor6 x30i (.out(x30),.a(c11),.b(x90),.c(x103),.d(x52),.e(x67),.f(1'b0));  // 5 ins 1 outs

    xor6 x29i (.out(x29),.a(d13),.b(x91),.c(d35),.d(x73),.e(x41),.f(x59));  // 6 ins 1 outs

    xor6 x28i (.out(x28),.a(x115),.b(x56),.c(x58),.d(x74),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x27i (.out(x27),.a(x108),.b(d39),.c(x67),.d(x58),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x26i (.out(x26),.a(x104),.b(d14),.c(x57),.d(x69),.e(x62),.f(1'b0));  // 5 ins 1 outs

    xor6 x25i (.out(x25),.a(x70),.b(x43),.c(x116),.d(x57),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x24i (.out(x24),.a(x85),.b(x64),.c(x117),.d(x39),.e(x54),.f(x58));  // 6 ins 1 outs

    xor6 x23i (.out(x23),.a(x78),.b(x39),.c(x64),.d(x109),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x22i (.out(x22),.a(x86),.b(x49),.c(x76),.d(x39),.e(x118),.f(x53));  // 6 ins 1 outs

    xor6 x21i (.out(x21),.a(x79),.b(x110),.c(x61),.d(x52),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x20i (.out(x20),.a(d9),.b(x98),.c(x40),.d(x75),.e(x60),.f(1'b0));  // 5 ins 1 outs

    xor6 x19i (.out(x19),.a(x119),.b(x43),.c(x76),.d(x52),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x18i (.out(x18),.a(x88),.b(x80),.c(x33),.d(x49),.e(x59),.f(1'b0));  // 5 ins 1 outs

    xor6 x17i (.out(x17),.a(x81),.b(x38),.c(x65),.d(x39),.e(x111),.f(1'b0));  // 5 ins 1 outs

    xor6 x16i (.out(x16),.a(x95),.b(d32),.c(d12),.d(x44),.e(x52),.f(x66));  // 6 ins 1 outs

    xor6 x15i (.out(x15),.a(x112),.b(x43),.c(x58),.d(x68),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x14i (.out(x14),.a(x99),.b(d1),.c(d4),.d(x43),.e(x71),.f(1'b0));  // 5 ins 1 outs

    xor6 x13i (.out(x13),.a(x120),.b(c11),.c(x62),.d(x88),.e(x61),.f(1'b0));  // 5 ins 1 outs

    xor6 x12i (.out(x12),.a(d2),.b(x80),.c(d12),.d(x75),.e(x39),.f(x61));  // 6 ins 1 outs

    xor6 x11i (.out(x11),.a(x100),.b(x39),.c(x56),.d(x121),.e(x43),.f(x74));  // 6 ins 1 outs

    xor6 x10i (.out(x10),.a(x65),.b(d7),.c(x54),.d(x73),.e(c31),.f(1'b0));  // 5 ins 1 outs

    xor6 x9i (.out(x9),.a(x122),.b(x38),.c(x65),.d(x76),.e(x53),.f(1'b0));  // 5 ins 1 outs

    xor6 x8i (.out(x8),.a(x123),.b(x74),.c(x89),.d(x62),.e(x53),.f(1'b0));  // 5 ins 1 outs

endmodule

