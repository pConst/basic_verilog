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

//// CRC-32 of 32 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 2
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 00000000001111111111222222222233
//        01234567890123456789012345678901 01234567890123456789012345678901
//
// C00  = X.....X..XX.X...X.......XXX.XXXX X.....X..XX.X...X.......XXX.XXXX
// C01  = XX....XX.X.XXX..XX......X..XX... XX....XX.X.XXX..XX......X..XX...
// C02  = XXX...XXXX...XX.XXX.....X.X...XX XXX...XXXX...XX.XXX.....X.X...XX
// C03  = .XXX...XXXX...XX.XXX.....X.X...X .XXX...XXXX...XX.XXX.....X.X...X
// C04  = X.XXX.X.X..XX..X..XXX...XX...XXX X.XXX.X.X..XX..X..XXX...XX...XXX
// C05  = XX.XXXXX..X..X.....XXX..X...XX.. XX.XXXXX..X..X.....XXX..X...XX..
// C06  = .XX.XXXXX..X..X.....XXX..X...XX. .XX.XXXXX..X..X.....XXX..X...XX.
// C07  = X.XX.X.XX.X....XX....XXXXX..XX.. X.XX.X.XX.X....XX....XXXXX..XX..
// C08  = XX.XX...X.XXX....X....XX....X..X XX.XX...X.XXX....X....XX....X..X
// C09  = .XX.XX...X.XXX....X....XX....X.. .XX.XX...X.XXX....X....XX....X..
// C10  = X.XX.X...X...XX.X..X......X.XX.X X.XX.X...X...XX.X..X......X.XX.X
// C11  = XX.XX....X..X.XXXX..X...XXXXX..X XX.XX....X..X.XXXX..X...XXXXX..X
// C12  = XXX.XXX..X..XX.X.XX..X..X..X..XX XXX.XXX..X..XX.X.XX..X..X..X..XX
// C13  = .XXX.XXX..X..XX.X.XX..X..X..X..X .XXX.XXX..X..XX.X.XX..X..X..X..X
// C14  = ..XXX.XXX..X..XX.X.XX..X..X..X.. ..XXX.XXX..X..XX.X.XX..X..X..X..
// C15  = ...XXX.XXX..X..XX.X.XX..X..X..X. ...XXX.XXX..X..XX.X.XX..X..X..X.
// C16  = X...XX..X...XX...X.X.XX.X.X..XX. X...XX..X...XX...X.X.XX.X.X..XX.
// C17  = .X...XX..X...XX...X.X.XX.X.X..XX .X...XX..X...XX...X.X.XX.X.X..XX
// C18  = ..X...XX..X...XX...X.X.XX.X.X..X ..X...XX..X...XX...X.X.XX.X.X..X
// C19  = ...X...XX..X...XX...X.X.XX.X.X.. ...X...XX..X...XX...X.X.XX.X.X..
// C20  = ....X...XX..X...XX...X.X.XX.X.X. ....X...XX..X...XX...X.X.XX.X.X.
// C21  = .....X...XX..X...XX...X.X.XX.X.X .....X...XX..X...XX...X.X.XX.X.X
// C22  = X........X.XX.X.X.XX...XX.XX.X.X X........X.XX.X.X.XX...XX.XX.X.X
// C23  = XX....X..X...X.XXX.XX.....XX.X.X XX....X..X...X.XXX.XX.....XX.X.X
// C24  = .XX....X..X...X.XXX.XX.....XX.X. .XX....X..X...X.XXX.XX.....XX.X.
// C25  = ..XX....X..X...X.XXX.XX.....XX.X ..XX....X..X...X.XXX.XX.....XX.X
// C26  = X..XX.X...X.......XXX.XXXXX.X..X X..XX.X...X.......XXX.XXXXX.X..X
// C27  = .X..XX.X...X.......XXX.XXXXX.X.. .X..XX.X...X.......XXX.XXXXX.X..
// C28  = ..X..XX.X...X.......XXX.XXXXX.X. ..X..XX.X...X.......XXX.XXXXX.X.
// C29  = ...X..XX.X...X.......XXX.XXXXX.X ...X..XX.X...X.......XXX.XXXXX.X
// C30  = ....X..XX.X...X.......XXX.XXXXX. ....X..XX.X...X.......XXX.XXXXX.
// C31  = .....X..XX.X...X.......XXX.XXXXX .....X..XX.X...X.......XXX.XXXXX
//
module crc32_dat32 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [31:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat32_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat32_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat32_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [31:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x31, x30, x29, x28, x27, x26, x25, 
       x24, x23, x22, x21, x20, x19, x18, x17, 
       x16, x15, x14, x13, x12, x11, x10, x9, 
       x8, x7, x6, x5, x4, x3, x2, x1, 
       x0;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31;

assign { d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [31:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x31 = d31 ^ d29 ^ c29 ^ c30 ^ d30 ^ d11 ^ d8 ^ d15 ^ c27 ^ 
        d28 ^ c28 ^ d9 ^ d5 ^ c15 ^ d25 ^ c11 ^ c8 ^ c9 ^ d24 ^ 
        c31 ^ c23 ^ c25 ^ c24 ^ d23 ^ d27 ^ c5;  // 26 ins 1 outs

    assign x30 = c14 ^ d30 ^ d28 ^ c28 ^ d7 ^ c4 ^ c26 ^ d27 ^ c27 ^ 
        d8 ^ c10 ^ d14 ^ d24 ^ c29 ^ c7 ^ c22 ^ c24 ^ d10 ^ d29 ^ 
        c8 ^ d26 ^ c23 ^ d4 ^ d22 ^ c30 ^ d23;  // 26 ins 1 outs

    assign x29 = c3 ^ d28 ^ c28 ^ c29 ^ c9 ^ d27 ^ d13 ^ d31 ^ c25 ^ 
        d26 ^ c26 ^ c27 ^ d29 ^ c31 ^ d6 ^ d9 ^ c22 ^ c23 ^ d22 ^ 
        d25 ^ d21 ^ c13 ^ c21 ^ d23 ^ c6 ^ d7 ^ d3 ^ c7;  // 28 ins 1 outs

    assign x28 = c2 ^ d27 ^ c27 ^ c28 ^ c8 ^ d24 ^ c24 ^ d25 ^ d28 ^ 
        d21 ^ c25 ^ c26 ^ d8 ^ c30 ^ d12 ^ c21 ^ c22 ^ d22 ^ d6 ^ 
        d5 ^ c6 ^ d26 ^ c20 ^ d30 ^ c12 ^ d20 ^ c5 ^ d2;  // 28 ins 1 outs

    assign x27 = c1 ^ c27 ^ c7 ^ d1 ^ d26 ^ d23 ^ c24 ^ c21 ^ c11 ^ 
        d25 ^ d27 ^ d21 ^ d24 ^ d29 ^ d5 ^ c26 ^ d4 ^ d20 ^ c29 ^ 
        d7 ^ d11 ^ c20 ^ c5 ^ c19 ^ c25 ^ d19 ^ c4 ^ c23;  // 28 ins 1 outs

    assign x26 = c0 ^ d24 ^ d31 ^ d10 ^ d25 ^ d3 ^ c23 ^ d4 ^ c24 ^ 
        c25 ^ d20 ^ c26 ^ c3 ^ c20 ^ d28 ^ d23 ^ d19 ^ c6 ^ d0 ^ 
        c28 ^ d26 ^ c10 ^ d18 ^ c18 ^ c4 ^ d22 ^ c22 ^ c19 ^ d6 ^ 
        c31;  // 30 ins 1 outs

    assign x25 = d8 ^ d21 ^ d19 ^ c22 ^ c29 ^ d3 ^ d11 ^ c2 ^ c18 ^ 
        c8 ^ d31 ^ c28 ^ d18 ^ c3 ^ d22 ^ d15 ^ c19 ^ d17 ^ c15 ^ 
        d2 ^ c21 ^ d28 ^ d29 ^ c17 ^ c11 ^ c31;  // 26 ins 1 outs

    assign x24 = d7 ^ c7 ^ d27 ^ d20 ^ c20 ^ c18 ^ d18 ^ c28 ^ c27 ^ 
        d30 ^ d17 ^ c1 ^ c17 ^ c2 ^ c21 ^ d16 ^ c10 ^ d2 ^ d10 ^ 
        d1 ^ d21 ^ c14 ^ c16 ^ d14 ^ d28 ^ c30;  // 26 ins 1 outs

    assign x23 = d16 ^ c6 ^ d31 ^ c31 ^ d6 ^ d0 ^ d17 ^ c19 ^ c9 ^ 
        d19 ^ c17 ^ c16 ^ d29 ^ c29 ^ d26 ^ d20 ^ c27 ^ c15 ^ d13 ^ 
        c0 ^ c20 ^ d27 ^ d15 ^ d1 ^ c1 ^ c26 ^ c13 ^ d9;  // 28 ins 1 outs

    assign x22 = c0 ^ c26 ^ c24 ^ c31 ^ d16 ^ d27 ^ c27 ^ d23 ^ d24 ^ 
        d0 ^ d29 ^ c16 ^ d18 ^ c14 ^ c18 ^ c9 ^ d19 ^ d31 ^ d12 ^ 
        c19 ^ c11 ^ c29 ^ d26 ^ d14 ^ d9 ^ d11 ^ c12 ^ c23;  // 28 ins 1 outs

    assign x21 = d9 ^ d5 ^ c31 ^ c29 ^ c10 ^ d26 ^ d29 ^ d31 ^ c27 ^ 
        d27 ^ d17 ^ c13 ^ c18 ^ c17 ^ d18 ^ c9 ^ c26 ^ c5 ^ d24 ^ 
        c24 ^ d13 ^ d10 ^ d22 ^ c22;  // 24 ins 1 outs

    assign x20 = c16 ^ d8 ^ c4 ^ d4 ^ c25 ^ d17 ^ c17 ^ c9 ^ c30 ^ 
        c8 ^ c26 ^ c28 ^ c12 ^ d16 ^ d26 ^ d28 ^ d9 ^ d23 ^ c23 ^ 
        d30 ^ d12 ^ c21 ^ d21 ^ d25;  // 24 ins 1 outs

    assign x19 = d3 ^ c7 ^ c3 ^ c27 ^ c16 ^ d16 ^ c22 ^ d25 ^ c15 ^ 
        d15 ^ c11 ^ c25 ^ c8 ^ d27 ^ d8 ^ d29 ^ d11 ^ c29 ^ d22 ^ 
        d7 ^ c20 ^ d20 ^ d24 ^ c24;  // 24 ins 1 outs

    assign x18 = d28 ^ d14 ^ d2 ^ c6 ^ c15 ^ d6 ^ c26 ^ c7 ^ c14 ^ 
        c10 ^ d24 ^ c21 ^ d19 ^ c24 ^ d31 ^ d26 ^ c28 ^ c2 ^ c23 ^ 
        d10 ^ d7 ^ c19 ^ d21 ^ c31 ^ d15 ^ d23;  // 26 ins 1 outs

    assign x17 = c30 ^ d1 ^ c14 ^ c13 ^ c6 ^ c25 ^ d6 ^ c27 ^ c31 ^ 
        c23 ^ d31 ^ d14 ^ d9 ^ d25 ^ c20 ^ c9 ^ d5 ^ d30 ^ d20 ^ 
        d13 ^ d18 ^ c1 ^ d27 ^ d23 ^ c18 ^ c5 ^ c22 ^ d22;  // 28 ins 1 outs

    assign x16 = d29 ^ c30 ^ d30 ^ c5 ^ d4 ^ d12 ^ c21 ^ d8 ^ c22 ^ 
        c29 ^ d5 ^ d22 ^ c8 ^ c12 ^ d13 ^ c26 ^ c24 ^ d26 ^ d24 ^ 
        d17 ^ c19 ^ c17 ^ c0 ^ d19 ^ c4 ^ d21 ^ c13 ^ d0;  // 28 ins 1 outs

    assign x15 = d15 ^ c12 ^ d3 ^ c4 ^ d30 ^ c3 ^ c27 ^ d7 ^ d21 ^ 
        d27 ^ d24 ^ c21 ^ d5 ^ c15 ^ c24 ^ d12 ^ d4 ^ c18 ^ d8 ^ 
        d18 ^ c5 ^ c7 ^ c8 ^ c16 ^ d16 ^ d9 ^ c9 ^ d20 ^ c20 ^ 
        c30;  // 30 ins 1 outs

    assign x14 = d14 ^ c14 ^ c11 ^ d2 ^ c3 ^ d8 ^ c26 ^ d26 ^ d20 ^ 
        d6 ^ d23 ^ c20 ^ c6 ^ d19 ^ c17 ^ c8 ^ c23 ^ d4 ^ d11 ^ 
        c2 ^ d7 ^ d17 ^ c4 ^ c29 ^ d3 ^ d15 ^ c19 ^ d29 ^ c7 ^ 
        c15;  // 30 ins 1 outs

    assign x13 = c10 ^ d31 ^ c7 ^ d1 ^ c2 ^ d7 ^ c13 ^ d25 ^ d6 ^ 
        c31 ^ c19 ^ d5 ^ c5 ^ d19 ^ d3 ^ d10 ^ c18 ^ c16 ^ c22 ^ 
        c3 ^ d18 ^ c25 ^ d22 ^ c1 ^ c28 ^ d13 ^ d2 ^ c6 ^ c14 ^ 
        d14 ^ d28 ^ d16;  // 32 ins 1 outs

    assign x12 = c6 ^ d9 ^ d12 ^ d31 ^ c31 ^ d6 ^ d0 ^ c1 ^ c27 ^ 
        c12 ^ d30 ^ d5 ^ c17 ^ d4 ^ c4 ^ d2 ^ c9 ^ c30 ^ c24 ^ 
        c21 ^ d21 ^ c5 ^ c2 ^ c13 ^ d15 ^ d24 ^ c18 ^ c0 ^ d17 ^ 
        c15 ^ d18 ^ d1 ^ d13 ^ d27;  // 34 ins 1 outs

    assign x11 = c0 ^ d26 ^ c16 ^ d28 ^ d27 ^ d3 ^ c3 ^ d24 ^ c12 ^ 
        d25 ^ d17 ^ d16 ^ c15 ^ c27 ^ d14 ^ c24 ^ c1 ^ c4 ^ d15 ^ 
        d1 ^ c26 ^ d20 ^ c9 ^ c20 ^ d0 ^ c14 ^ c17 ^ c31 ^ d31 ^ 
        d12 ^ d9 ^ c25 ^ d4 ^ c28;  // 34 ins 1 outs

    assign x10 = c9 ^ d14 ^ d2 ^ c3 ^ d9 ^ d26 ^ c2 ^ c5 ^ d0 ^ 
        c31 ^ c19 ^ d3 ^ c0 ^ c13 ^ d16 ^ d31 ^ c28 ^ d13 ^ c26 ^ 
        c14 ^ d5 ^ d29 ^ c29 ^ d28 ^ d19 ^ c16;  // 26 ins 1 outs

    assign x9 = d1 ^ c2 ^ c13 ^ c11 ^ c1 ^ d11 ^ d29 ^ d13 ^ c5 ^ 
        c4 ^ d23 ^ d12 ^ c12 ^ c29 ^ c24 ^ c18 ^ d24 ^ d4 ^ c9 ^ 
        c23 ^ d9 ^ d5 ^ d2 ^ d18;  // 24 ins 1 outs

    assign x8 = d12 ^ d31 ^ d0 ^ c28 ^ d28 ^ c11 ^ c12 ^ d10 ^ c10 ^ 
        c0 ^ c31 ^ d11 ^ c23 ^ c1 ^ c4 ^ d23 ^ c22 ^ c8 ^ d22 ^ 
        d8 ^ d3 ^ c3 ^ d1 ^ c17 ^ d4 ^ d17;  // 26 ins 1 outs

    assign x7 = c8 ^ c10 ^ d16 ^ d3 ^ c5 ^ d28 ^ d10 ^ c15 ^ c24 ^ 
        c2 ^ c25 ^ c28 ^ d29 ^ c29 ^ d21 ^ d22 ^ c22 ^ c3 ^ c7 ^ 
        c16 ^ d8 ^ c21 ^ d7 ^ c23 ^ d0 ^ d25 ^ d5 ^ d24 ^ d23 ^ 
        c0 ^ d15 ^ d2;  // 32 ins 1 outs

    assign x6 = c7 ^ d1 ^ d14 ^ d2 ^ c4 ^ c29 ^ d30 ^ c1 ^ c30 ^ 
        d25 ^ c5 ^ d20 ^ d5 ^ d21 ^ d7 ^ c2 ^ c6 ^ c14 ^ d6 ^ 
        c11 ^ d29 ^ c25 ^ c20 ^ d22 ^ c22 ^ c21 ^ d8 ^ d4 ^ d11 ^ 
        c8;  // 30 ins 1 outs

    assign x5 = d6 ^ d7 ^ d13 ^ c6 ^ c7 ^ c24 ^ d28 ^ c10 ^ d10 ^ 
        d3 ^ d24 ^ d19 ^ c20 ^ c28 ^ d29 ^ c0 ^ c5 ^ d4 ^ c3 ^ 
        d20 ^ c29 ^ d5 ^ c21 ^ c1 ^ d0 ^ c19 ^ d21 ^ c13 ^ d1 ^ 
        c4;  // 30 ins 1 outs

    assign x4 = c12 ^ c29 ^ d12 ^ d31 ^ c31 ^ d6 ^ d29 ^ c11 ^ d2 ^ 
        c30 ^ c2 ^ c6 ^ c15 ^ c19 ^ d15 ^ c18 ^ d3 ^ c4 ^ d19 ^ 
        d30 ^ d0 ^ c3 ^ d18 ^ d8 ^ d4 ^ c24 ^ d24 ^ c0 ^ d11 ^ 
        c20 ^ d20 ^ c8 ^ c25 ^ d25;  // 34 ins 1 outs

    assign x3 = c10 ^ d31 ^ c7 ^ d1 ^ c8 ^ d27 ^ d14 ^ c14 ^ d10 ^ 
        d2 ^ c3 ^ d7 ^ d8 ^ d18 ^ c17 ^ d25 ^ c9 ^ c2 ^ d17 ^ 
        d19 ^ c31 ^ c25 ^ d9 ^ c15 ^ c27 ^ c1 ^ c19 ^ d15 ^ c18 ^ 
        d3;  // 30 ins 1 outs

    assign x2 = d16 ^ c6 ^ d31 ^ c31 ^ d6 ^ d0 ^ d17 ^ c9 ^ c7 ^ 
        d1 ^ c2 ^ c30 ^ d7 ^ c17 ^ c1 ^ c26 ^ c8 ^ d13 ^ c16 ^ 
        d18 ^ d9 ^ d8 ^ d30 ^ d24 ^ c18 ^ c24 ^ c13 ^ d26 ^ d14 ^ 
        c14 ^ c0 ^ d2;  // 32 ins 1 outs

    assign x1 = d16 ^ c6 ^ d6 ^ d0 ^ c1 ^ c27 ^ c28 ^ d28 ^ c12 ^ 
        c9 ^ c11 ^ d12 ^ d17 ^ c16 ^ c13 ^ c17 ^ d11 ^ d7 ^ c24 ^ 
        d24 ^ c0 ^ d27 ^ d13 ^ d9 ^ c7 ^ d1;  // 26 ins 1 outs

    assign x0 = c0 ^ d24 ^ c10 ^ d26 ^ c24 ^ d30 ^ c16 ^ d28 ^ c26 ^ 
        c30 ^ c9 ^ d25 ^ d10 ^ c12 ^ c29 ^ d29 ^ c28 ^ c25 ^ d16 ^ 
        c6 ^ d9 ^ d12 ^ d31 ^ c31 ^ d6 ^ d0;  // 26 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat32_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [31:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x631, x630, x629, x628, x627, x626, x625, 
       x624, x623, x622, x621, x620, x619, x618, x617, 
       x616, x615, x614, x613, x612, x611, x610, x609, 
       x608, x607, x606, x605, x604, x603, x602, x601, 
       x600, x599, x598, x597, x596, x595, x594, x593, 
       x592, x591, x590, x589, x588, x587, x586, x585, 
       x584, x583, x582, x581, x580, x579, x578, x577, 
       x576, x575, x574, x573, x572, x571, x570, x569, 
       x568, x567, x566, x565, x564, x563, x562, x561, 
       x560, x559, x558, x557, x556, x31, x30, x29, 
       x28, x27, x26, x25, x24, x23, x22, x21, 
       x20, x19, x18, x17, x16, x15, x14, x13, 
       x12, x11, x10, x9, x8, x7, x6, x5, 
       x4, x3, x2, x1, x0;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31;

assign { d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [31:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x631i (.out(x631),.a(c9),.b(c28),.c(d9),.d(c1),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x630i (.out(x630),.a(c26),.b(d30),.c(d26),.d(c31),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x629i (.out(x629),.a(c19),.b(d19),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x628i (.out(x628),.a(d15),.b(d6),.c(c31),.d(c15),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x627i (.out(x627),.a(d21),.b(d10),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x626i (.out(x626),.a(c11),.b(d29),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x625i (.out(x625),.a(c2),.b(d16),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x624i (.out(x624),.a(d15),.b(d17),.c(c17),.d(c15),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x623i (.out(x623),.a(c16),.b(d16),.c(d22),.d(c31),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x622i (.out(x622),.a(c24),.b(c15),.c(c19),.d(d19),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x621i (.out(x621),.a(c16),.b(c26),.c(d26),.d(d16),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x620i (.out(x620),.a(c22),.b(c18),.c(d22),.d(c21),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x619i (.out(x619),.a(c19),.b(c30),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x618i (.out(x618),.a(d21),.b(d6),.c(c21),.d(d22),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x617i (.out(x617),.a(c11),.b(c16),.c(d11),.d(d21),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x616i (.out(x616),.a(c28),.b(d29),.c(c29),.d(d10),.e(d25),.f(c10));  // 6 ins 1 outs

    xor6 x615i (.out(x615),.a(c14),.b(c0),.c(d14),.d(d2),.e(c2),.f(c22));  // 6 ins 1 outs

    xor6 x614i (.out(x614),.a(d26),.b(d4),.c(c4),.d(c14),.e(d14),.f(c26));  // 6 ins 1 outs

    xor6 x613i (.out(x613),.a(c3),.b(d3),.c(d26),.d(c26),.e(c20),.f(d20));  // 6 ins 1 outs

    xor6 x612i (.out(x612),.a(c15),.b(d15),.c(d12),.d(d27),.e(c12),.f(c27));  // 6 ins 1 outs

    xor6 x611i (.out(x611),.a(c19),.b(c22),.c(d19),.d(c17),.e(d17),.f(c21));  // 6 ins 1 outs

    xor6 x610i (.out(x610),.a(d22),.b(c30),.c(c29),.d(d30),.e(c5),.f(d5));  // 6 ins 1 outs

    xor6 x609i (.out(x609),.a(d3),.b(c3),.c(d16),.d(c24),.e(d24),.f(1'b0));  // 5 ins 1 outs

    xor6 x608i (.out(x608),.a(c22),.b(c17),.c(c29),.d(d17),.e(d22),.f(c21));  // 6 ins 1 outs

    xor6 x607i (.out(x607),.a(d6),.b(d0),.c(c6),.d(c0),.e(c19),.f(d19));  // 6 ins 1 outs

    xor6 x606i (.out(x606),.a(d27),.b(d20),.c(c21),.d(c27),.e(d1),.f(c20));  // 6 ins 1 outs

    xor6 x605i (.out(x605),.a(c1),.b(d1),.c(d4),.d(c4),.e(c6),.f(c28));  // 6 ins 1 outs

    xor6 x604i (.out(x604),.a(c8),.b(d8),.c(c30),.d(d30),.e(d28),.f(d22));  // 6 ins 1 outs

    xor6 x603i (.out(x603),.a(d28),.b(d29),.c(d24),.d(d14),.e(c14),.f(c24));  // 6 ins 1 outs

    xor6 x602i (.out(x602),.a(d3),.b(c3),.c(c25),.d(c1),.e(d1),.f(d25));  // 6 ins 1 outs

    xor6 x601i (.out(x601),.a(d29),.b(c19),.c(c10),.d(c7),.e(c31),.f(d7));  // 6 ins 1 outs

    xor6 x600i (.out(x600),.a(c21),.b(d6),.c(d11),.d(c6),.e(d1),.f(c1));  // 6 ins 1 outs

    xor6 x599i (.out(x599),.a(d0),.b(c7),.c(d21),.d(d7),.e(c0),.f(d2));  // 6 ins 1 outs

    xor6 x598i (.out(x598),.a(c13),.b(d29),.c(c9),.d(d2),.e(c23),.f(d23));  // 6 ins 1 outs

    xor6 x597i (.out(x597),.a(c12),.b(d9),.c(c9),.d(c26),.e(d12),.f(c1));  // 6 ins 1 outs

    xor6 x596i (.out(x596),.a(d30),.b(d28),.c(c25),.d(c30),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x595i (.out(x595),.a(d24),.b(c30),.c(c24),.d(d18),.e(d0),.f(c18));  // 6 ins 2 outs

    xor6 x594i (.out(x594),.a(d31),.b(c2),.c(d2),.d(c6),.e(d25),.f(c25));  // 6 ins 1 outs

    xor6 x593i (.out(x593),.a(d21),.b(c5),.c(c30),.d(d2),.e(d5),.f(d30));  // 6 ins 1 outs

    xor6 x592i (.out(x592),.a(d19),.b(c19),.c(c22),.d(c5),.e(d5),.f(d31));  // 6 ins 2 outs

    xor6 x591i (.out(x591),.a(d25),.b(d15),.c(c10),.d(d28),.e(d10),.f(d24));  // 6 ins 1 outs

    xor6 x590i (.out(x590),.a(c30),.b(d30),.c(d21),.d(c28),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x589i (.out(x589),.a(d18),.b(d2),.c(c2),.d(d31),.e(d0),.f(d21));  // 6 ins 1 outs

    xor6 x588i (.out(x588),.a(c22),.b(d7),.c(c7),.d(c6),.e(c23),.f(d23));  // 6 ins 2 outs

    xor6 x587i (.out(x587),.a(d21),.b(d7),.c(c29),.d(c7),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x586i (.out(x586),.a(d5),.b(c5),.c(d22),.d(d21),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x585i (.out(x585),.a(c6),.b(c4),.c(c23),.d(d23),.e(d4),.f(d6));  // 6 ins 1 outs

    xor6 x584i (.out(x584),.a(d23),.b(c14),.c(d14),.d(d18),.e(c18),.f(c23));  // 6 ins 2 outs

    xor6 x583i (.out(x583),.a(d7),.b(d11),.c(c11),.d(c7),.e(c27),.f(d27));  // 6 ins 2 outs

    xor6 x582i (.out(x582),.a(d1),.b(c15),.c(c20),.d(d15),.e(d28),.f(d20));  // 6 ins 2 outs

    xor6 x581i (.out(x581),.a(d12),.b(c12),.c(c2),.d(d6),.e(c6),.f(d2));  // 6 ins 1 outs

    xor6 x580i (.out(x580),.a(c20),.b(c4),.c(d20),.d(d4),.e(d19),.f(c0));  // 6 ins 2 outs

    xor6 x579i (.out(x579),.a(d1),.b(c1),.c(d12),.d(d11),.e(c11),.f(c12));  // 6 ins 2 outs

    xor6 x578i (.out(x578),.a(c23),.b(d25),.c(d21),.d(d23),.e(c28),.f(c21));  // 6 ins 3 outs

    xor6 x577i (.out(x577),.a(d18),.b(c10),.c(d10),.d(c18),.e(1'b0),.f(1'b0));  // 4 ins 4 outs

    xor6 x576i (.out(x576),.a(c8),.b(d8),.c(c17),.d(d17),.e(d31),.f(c0));  // 6 ins 2 outs

    xor6 x575i (.out(x575),.a(d29),.b(d15),.c(c16),.d(c8),.e(d8),.f(c15));  // 6 ins 3 outs

    xor6 x574i (.out(x574),.a(d21),.b(c27),.c(d27),.d(c28),.e(c26),.f(d26));  // 6 ins 3 outs

    xor6 x573i (.out(x573),.a(c16),.b(c9),.c(d9),.d(d16),.e(1'b0),.f(1'b0));  // 4 ins 4 outs

    xor6 x572i (.out(x572),.a(c21),.b(d18),.c(c4),.d(c18),.e(c2),.f(d4));  // 6 ins 2 outs

    xor6 x571i (.out(x571),.a(c28),.b(d28),.c(c31),.d(c3),.e(d3),.f(d0));  // 6 ins 4 outs

    xor6 x570i (.out(x570),.a(c3),.b(d3),.c(c18),.d(d18),.e(c20),.f(d20));  // 6 ins 2 outs

    xor6 x569i (.out(x569),.a(d26),.b(d31),.c(c26),.d(d6),.e(c6),.f(c31));  // 6 ins 3 outs

    xor6 x568i (.out(x568),.a(c17),.b(c1),.c(c16),.d(d16),.e(d17),.f(d28));  // 6 ins 5 outs

    xor6 x567i (.out(x567),.a(d15),.b(c8),.c(d8),.d(c15),.e(c17),.f(d17));  // 6 ins 3 outs

    xor6 x566i (.out(x566),.a(c29),.b(c22),.c(c25),.d(c20),.e(d20),.f(d25));  // 6 ins 5 outs

    xor6 x565i (.out(x565),.a(c13),.b(d13),.c(d6),.d(c6),.e(c1),.f(d1));  // 6 ins 6 outs

    xor6 x564i (.out(x564),.a(c22),.b(d22),.c(d10),.d(c10),.e(d23),.f(c23));  // 6 ins 4 outs

    xor6 x563i (.out(x563),.a(d29),.b(c26),.c(c13),.d(d13),.e(d26),.f(c29));  // 6 ins 5 outs

    xor6 x562i (.out(x562),.a(d19),.b(d29),.c(c29),.d(d11),.e(c11),.f(c19));  // 6 ins 5 outs

    xor6 x561i (.out(x561),.a(c21),.b(d5),.c(c29),.d(c5),.e(c24),.f(d24));  // 6 ins 8 outs

    xor6 x560i (.out(x560),.a(d4),.b(c4),.c(c8),.d(d8),.e(c30),.f(d30));  // 6 ins 6 outs

    xor6 x559i (.out(x559),.a(d28),.b(c28),.c(c25),.d(d25),.e(c3),.f(d3));  // 6 ins 5 outs

    xor6 x558i (.out(x558),.a(d2),.b(c14),.c(d14),.d(c2),.e(c7),.f(d7));  // 6 ins 7 outs

    xor6 x557i (.out(x557),.a(d0),.b(c24),.c(d24),.d(c0),.e(d12),.f(c12));  // 6 ins 7 outs

    xor6 x556i (.out(x556),.a(d9),.b(c31),.c(c27),.d(c9),.e(d27),.f(d31));  // 6 ins 9 outs

    xor6 x31i (.out(x31),.a(x617),.b(x575),.c(x596),.d(x578),.e(x561),.f(x556));  // 6 ins 1 outs

    xor6 x30i (.out(x30),.a(x603),.b(x587),.c(x564),.d(x560),.e(x574),.f(1'b0));  // 5 ins 1 outs

    xor6 x29i (.out(x29),.a(x618),.b(x563),.c(x588),.d(x559),.e(x556),.f(1'b0));  // 5 ins 1 outs

    xor6 x28i (.out(x28),.a(x581),.b(x561),.c(x574),.d(x604),.e(x566),.f(1'b0));  // 5 ins 1 outs

    xor6 x27i (.out(x27),.a(x605),.b(x561),.c(x574),.d(x588),.e(x562),.f(x566));  // 6 ins 1 outs

    xor6 x26i (.out(x26),.a(x619),.b(x595),.c(x559),.d(x580),.e(x569),.f(x564));  // 6 ins 1 outs

    xor6 x25i (.out(x25),.a(x571),.b(x589),.c(x620),.d(x562),.e(x567),.f(1'b0));  // 5 ins 1 outs

    xor6 x24i (.out(x24),.a(x590),.b(x577),.c(x606),.d(x568),.e(x558),.f(1'b0));  // 5 ins 1 outs

    xor6 x23i (.out(x23),.a(x607),.b(x563),.c(x582),.d(x568),.e(x556),.f(1'b0));  // 5 ins 1 outs

    xor6 x22i (.out(x22),.a(x621),.b(x562),.c(x584),.d(x557),.e(x556),.f(1'b0));  // 5 ins 1 outs

    xor6 x21i (.out(x21),.a(x608),.b(x563),.c(x561),.d(x577),.e(x556),.f(1'b0));  // 5 ins 1 outs

    xor6 x20i (.out(x20),.a(c25),.b(x597),.c(d26),.d(x568),.e(x578),.f(x560));  // 6 ins 1 outs

    xor6 x19i (.out(x19),.a(d22),.b(x609),.c(x566),.d(x583),.e(x575),.f(1'b0));  // 5 ins 1 outs

    xor6 x18i (.out(x18),.a(x591),.b(x578),.c(x622),.d(x558),.e(x569),.f(1'b0));  // 5 ins 1 outs

    xor6 x17i (.out(x17),.a(x610),.b(x566),.c(x584),.d(x565),.e(x556),.f(1'b0));  // 5 ins 1 outs

    xor6 x16i (.out(x16),.a(x611),.b(x586),.c(x563),.d(x560),.e(x557),.f(1'b0));  // 5 ins 1 outs

    xor6 x15i (.out(x15),.a(x612),.b(x573),.c(x587),.d(x570),.e(x561),.f(x560));  // 6 ins 1 outs

    xor6 x14i (.out(x14),.a(x585),.b(x562),.c(x613),.d(x567),.e(x558),.f(1'b0));  // 5 ins 1 outs

    xor6 x13i (.out(x13),.a(x623),.b(x577),.c(x565),.d(x592),.e(x559),.f(x558));  // 6 ins 1 outs

    xor6 x12i (.out(x12),.a(x593),.b(x624),.c(x557),.d(x556),.e(x565),.f(x572));  // 6 ins 1 outs

    xor6 x11i (.out(x11),.a(x614),.b(x559),.c(x582),.d(x568),.e(x557),.f(x556));  // 6 ins 1 outs

    xor6 x10i (.out(x10),.a(x615),.b(x592),.c(x573),.d(x563),.e(x571),.f(1'b0));  // 5 ins 1 outs

    xor6 x9i (.out(x9),.a(x598),.b(d9),.c(d13),.d(x579),.e(x572),.f(x561));  // 6 ins 1 outs

    xor6 x8i (.out(x8),.a(c4),.b(x579),.c(d4),.d(x576),.e(x564),.f(x571));  // 6 ins 1 outs

    xor6 x7i (.out(x7),.a(x599),.b(x625),.c(x559),.d(x561),.e(x564),.f(x575));  // 6 ins 1 outs

    xor6 x6i (.out(x6),.a(x600),.b(x626),.c(x558),.d(x586),.e(x560),.f(x566));  // 6 ins 1 outs

    xor6 x5i (.out(x5),.a(x601),.b(x627),.c(x571),.d(x561),.e(x565),.f(x580));  // 6 ins 1 outs

    xor6 x4i (.out(x4),.a(x594),.b(x628),.c(x560),.d(x557),.e(x562),.f(x570));  // 6 ins 1 outs

    xor6 x3i (.out(x3),.a(x602),.b(x577),.c(x629),.d(x556),.e(x558),.f(x567));  // 6 ins 1 outs

    xor6 x2i (.out(x2),.a(x630),.b(x573),.c(x558),.d(x576),.e(x595),.f(x565));  // 6 ins 1 outs

    xor6 x1i (.out(x1),.a(x631),.b(x568),.c(x565),.d(x557),.e(x583),.f(1'b0));  // 5 ins 1 outs

    xor6 x0i (.out(x0),.a(x616),.b(x573),.c(x596),.d(x569),.e(x557),.f(1'b0));  // 5 ins 1 outs

endmodule

