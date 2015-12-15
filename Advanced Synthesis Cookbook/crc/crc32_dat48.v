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

//// CRC-32 of 48 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 000000000011111111112222222222333333333344444444
//        01234567890123456789012345678901 012345678901234567890123456789012345678901234567
//
// C00  = X.......XXX.XXXXX.X..X......XX.X X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.X
// C01  = XX......X..XX....XXX.XX.....X.XX XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX
// C02  = XXX.....X.X...XXX..XXXXX....X... XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X...
// C03  = .XXX.....X.X...XXX..XXXXX....X.. .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X..
// C04  = ..XXX...XX...XXX.X....XXXX..XXXX X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXX
// C05  = ...XXX..X...XX.......X.XXXX.X.X. XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X.
// C06  = ....XXX..X...XX.......X.XXXX.X.X .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X
// C07  = X....XXXXX..XX..X.X..X.X.XXX.XXX X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX
// C08  = .X....XX....X..XXXXX.XX.X.XX.XX. XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX.
// C09  = ..X....XX....X..XXXXX.XX.X.XX.XX .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX
// C10  = X..X......X.XX.XXX.XX..XX.X..... X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.....
// C11  = XX..X...XXXXX..X.X..X...XX.XXX.X XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.X
// C12  = .XX..X..X..X..XX.........XX...XX XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX
// C13  = X.XX..X..X..X..XX.........XX...X .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...X
// C14  = .X.XX..X..X..X..XX.........XX... ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...
// C15  = X.X.XX..X..X..X..XX.........XX.. ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX..
// C16  = .X.X.XX.X.X..XX.X..X.X......X.XX X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XX
// C17  = ..X.X.XX.X.X..XX.X..X.X......X.X .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.X
// C18  = ...X.X.XX.X.X..XX.X..X.X......X. ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.
// C19  = X...X.X.XX.X.X..XX.X..X.X......X ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X
// C20  = XX...X.X.XX.X.X..XX.X..X.X...... ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......
// C21  = .XX...X.X.XX.X.X..XX.X..X.X..... .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X.....
// C22  = X.XX...XX.XX.X.X..XXXXX..X.XXX.X X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.X
// C23  = XX.XX.....XX.X.X..XXX.XX..X...XX XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX
// C24  = XXX.XX.....XX.X.X..XXX.XX..X...X .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...X
// C25  = .XXX.XX.....XX.X.X..XXX.XX..X... ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...
// C26  = ..XXX.XXXXX.X..X......XX.XX.X..X X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..X
// C27  = ...XXX.XXXXX.X..X......XX.XX.X.. .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..
// C28  = ....XXX.XXXXX.X..X......XX.XX.X. ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X.
// C29  = .....XXX.XXXXX.X..X......XX.XX.X ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X
// C30  = ......XXX.XXXXX.X..X......XX.XX. ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.
// C31  = .......XXX.XXXXX.X..X......XX.XX .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX
//
module crc32_dat48 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [47:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat48_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat48_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat48_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [47:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x15, x14, x13, x12, x11, x10, x9, 
       x8, x7, x6, x5, x4, x3, x2, x1, 
       x0, x31, x30, x29, x28, x27, x26, x25, 
       x24, x23, x22, x21, x20, x19, x18, x17, 
       x16;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47;

assign { d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [47:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x15 = c17 ^ c18 ^ d21 ^ d20 ^ c5 ^ d45 ^ d18 ^ d33 ^ d9 ^ 
        d12 ^ d5 ^ c11 ^ d27 ^ d4 ^ c8 ^ d15 ^ d24 ^ d8 ^ c14 ^ 
        d7 ^ d16 ^ d44 ^ c28 ^ d30 ^ d34 ^ c4 ^ c29 ^ c0 ^ c2 ^ 
        d3;  // 30 ins 1 outs

    assign x14 = c13 ^ d2 ^ d11 ^ d43 ^ d29 ^ d26 ^ d6 ^ c3 ^ d44 ^ 
        d33 ^ c10 ^ c28 ^ d4 ^ d3 ^ d23 ^ d20 ^ d14 ^ d32 ^ d8 ^ 
        c16 ^ c17 ^ c7 ^ c4 ^ d15 ^ d19 ^ d17 ^ c1 ^ d7 ^ c27;  // 29 ins 1 outs

    assign x13 = d31 ^ d1 ^ c12 ^ c15 ^ d32 ^ d7 ^ c2 ^ d25 ^ c6 ^ 
        c16 ^ d43 ^ d14 ^ d10 ^ d13 ^ c9 ^ d16 ^ d42 ^ d22 ^ c0 ^ 
        d6 ^ c27 ^ d47 ^ d5 ^ d3 ^ d2 ^ c3 ^ d18 ^ d19 ^ c26 ^ 
        d28 ^ c31;  // 31 ins 1 outs

    assign x12 = d31 ^ d6 ^ d30 ^ d21 ^ c15 ^ d42 ^ d24 ^ d2 ^ c31 ^ 
        c8 ^ d1 ^ c5 ^ c26 ^ d12 ^ c11 ^ d18 ^ c2 ^ d17 ^ d0 ^ 
        d47 ^ c14 ^ c1 ^ c30 ^ d27 ^ d9 ^ d13 ^ d15 ^ d46 ^ d5 ^ 
        d4 ^ d41 ^ c25;  // 32 ins 1 outs

    assign x11 = d47 ^ d3 ^ d40 ^ d9 ^ d26 ^ d44 ^ d45 ^ d15 ^ d43 ^ 
        c4 ^ d1 ^ d25 ^ c9 ^ c24 ^ c29 ^ c28 ^ d14 ^ c27 ^ d4 ^ 
        d41 ^ c31 ^ d33 ^ d12 ^ c25 ^ c17 ^ d20 ^ d17 ^ c15 ^ c1 ^ 
        c11 ^ d16 ^ d27 ^ d31 ^ d28 ^ c0 ^ d24 ^ c8 ^ c20 ^ c12 ^ 
        d36 ^ d0 ^ c10;  // 42 ins 1 outs

    assign x10 = c12 ^ d26 ^ c20 ^ d42 ^ d35 ^ c26 ^ d2 ^ d29 ^ d0 ^ 
        d5 ^ d40 ^ d39 ^ d9 ^ c10 ^ c17 ^ c13 ^ d31 ^ c24 ^ d16 ^ 
        c16 ^ c23 ^ d3 ^ c3 ^ c15 ^ d28 ^ c0 ^ d19 ^ d32 ^ d33 ^ 
        d36 ^ d13 ^ d14 ^ c19;  // 33 ins 1 outs

    assign x9 = c13 ^ c25 ^ d33 ^ c22 ^ c28 ^ c20 ^ c19 ^ c18 ^ c7 ^ 
        d39 ^ d13 ^ d23 ^ c30 ^ c31 ^ d36 ^ c17 ^ d1 ^ d35 ^ d38 ^ 
        d29 ^ c23 ^ d34 ^ c2 ^ d47 ^ d44 ^ d2 ^ d18 ^ d12 ^ d46 ^ 
        c8 ^ c16 ^ d11 ^ d32 ^ d24 ^ d5 ^ d4 ^ c27 ^ d43 ^ d41 ^ 
        d9;  // 40 ins 1 outs

    assign x8 = c21 ^ d46 ^ d37 ^ d31 ^ c12 ^ d40 ^ d11 ^ c22 ^ c6 ^ 
        d3 ^ c18 ^ d35 ^ c24 ^ d10 ^ d1 ^ d33 ^ d22 ^ d17 ^ d42 ^ 
        d12 ^ c1 ^ d45 ^ d34 ^ c30 ^ c19 ^ d23 ^ d43 ^ c7 ^ c16 ^ 
        c15 ^ d0 ^ d32 ^ c26 ^ c17 ^ c27 ^ d4 ^ c29 ^ d28 ^ d38 ^ 
        d8;  // 40 ins 1 outs

    assign x7 = d29 ^ c12 ^ c8 ^ c31 ^ d8 ^ c18 ^ c16 ^ d45 ^ d28 ^ 
        d21 ^ d47 ^ d32 ^ c23 ^ c27 ^ d10 ^ d25 ^ c9 ^ c30 ^ d7 ^ 
        d42 ^ d46 ^ d2 ^ c7 ^ c0 ^ d0 ^ c13 ^ d16 ^ d39 ^ c6 ^ 
        d37 ^ d15 ^ d41 ^ d24 ^ d5 ^ d34 ^ c29 ^ c5 ^ c21 ^ d22 ^ 
        c26 ^ d43 ^ c25 ^ d23 ^ d3;  // 44 ins 1 outs

    assign x6 = c9 ^ d7 ^ c22 ^ d30 ^ d25 ^ d20 ^ d11 ^ d8 ^ c31 ^ 
        c26 ^ d45 ^ d21 ^ d42 ^ d6 ^ d1 ^ c24 ^ c29 ^ c6 ^ c14 ^ 
        d14 ^ c27 ^ c13 ^ d5 ^ d4 ^ d38 ^ d22 ^ d29 ^ d43 ^ d47 ^ 
        c4 ^ d41 ^ c25 ^ d40 ^ d2 ^ c5;  // 35 ins 1 outs

    assign x5 = c21 ^ d46 ^ d28 ^ d1 ^ d24 ^ d10 ^ d37 ^ c8 ^ c12 ^ 
        d44 ^ c24 ^ d29 ^ d20 ^ c25 ^ d41 ^ d4 ^ d5 ^ c30 ^ c13 ^ 
        c28 ^ d0 ^ d39 ^ c3 ^ d6 ^ c4 ^ d7 ^ c26 ^ c5 ^ c23 ^ 
        d42 ^ d3 ^ d21 ^ d40 ^ d19 ^ d13;  // 35 ins 1 outs

    assign x4 = c14 ^ d0 ^ d12 ^ d31 ^ d25 ^ d45 ^ d18 ^ d2 ^ c30 ^ 
        c2 ^ c29 ^ c23 ^ c9 ^ d44 ^ c13 ^ d19 ^ d6 ^ d24 ^ d47 ^ 
        d40 ^ c17 ^ c31 ^ c22 ^ d38 ^ c4 ^ d11 ^ d30 ^ c24 ^ d15 ^ 
        c8 ^ d33 ^ d46 ^ d8 ^ d29 ^ c28 ^ c3 ^ d39 ^ d3 ^ c15 ^ 
        d20 ^ c25 ^ d41 ^ d4;  // 43 ins 1 outs

    assign x3 = c22 ^ d27 ^ c1 ^ d18 ^ d2 ^ c20 ^ c11 ^ d14 ^ d39 ^ 
        d9 ^ c21 ^ d10 ^ d38 ^ c29 ^ d15 ^ c15 ^ d40 ^ d32 ^ d1 ^ 
        c16 ^ d45 ^ d31 ^ c17 ^ d36 ^ d33 ^ d7 ^ c3 ^ c24 ^ d8 ^ 
        c23 ^ d17 ^ d25 ^ c2 ^ c9 ^ d19 ^ d3 ^ d37;  // 37 ins 1 outs

    assign x2 = d24 ^ c15 ^ d30 ^ d6 ^ d0 ^ c28 ^ d31 ^ c19 ^ d17 ^ 
        c10 ^ c8 ^ c0 ^ c22 ^ c16 ^ c14 ^ d18 ^ d2 ^ c21 ^ d9 ^ 
        c2 ^ d26 ^ c23 ^ d38 ^ d7 ^ d32 ^ c1 ^ d1 ^ c20 ^ d16 ^ 
        d13 ^ d8 ^ d36 ^ d37 ^ d35 ^ d44 ^ d14 ^ d39;  // 37 ins 1 outs

    assign x1 = c18 ^ d0 ^ c12 ^ d6 ^ d44 ^ c11 ^ d11 ^ d28 ^ d12 ^ 
        c21 ^ d46 ^ d16 ^ c17 ^ d13 ^ c0 ^ d24 ^ c28 ^ d35 ^ d7 ^ 
        d37 ^ d38 ^ d9 ^ d47 ^ c30 ^ d34 ^ c19 ^ c22 ^ d27 ^ c1 ^ 
        d17 ^ d33 ^ c31 ^ d1 ^ c8;  // 34 ins 1 outs

    assign x0 = c28 ^ c13 ^ d10 ^ d26 ^ c18 ^ d9 ^ c14 ^ d47 ^ c10 ^ 
        d0 ^ d12 ^ d29 ^ c12 ^ c8 ^ c31 ^ c21 ^ c29 ^ d34 ^ d24 ^ 
        c0 ^ d28 ^ c15 ^ c16 ^ d31 ^ d25 ^ d45 ^ d30 ^ d6 ^ d44 ^ 
        d37 ^ d16 ^ c9 ^ d32;  // 33 ins 1 outs

    assign x31 = d30 ^ d11 ^ d46 ^ d29 ^ c30 ^ d33 ^ d44 ^ c12 ^ d25 ^ 
        d24 ^ d27 ^ c14 ^ c28 ^ d23 ^ d15 ^ d9 ^ d36 ^ c31 ^ c20 ^ 
        d5 ^ c11 ^ d8 ^ d28 ^ d31 ^ c9 ^ c8 ^ c13 ^ c17 ^ c7 ^ 
        c15 ^ d43 ^ c27 ^ d47;  // 33 ins 1 outs

    assign x30 = d35 ^ c19 ^ d10 ^ c16 ^ c29 ^ d46 ^ c11 ^ d45 ^ d4 ^ 
        c10 ^ d43 ^ c12 ^ d22 ^ d8 ^ d29 ^ c6 ^ d32 ^ d30 ^ c30 ^ 
        d14 ^ d24 ^ d27 ^ d23 ^ d7 ^ c13 ^ c27 ^ d28 ^ c26 ^ c14 ^ 
        c7 ^ d26 ^ c8 ^ d42;  // 33 ins 1 outs

    assign x29 = d47 ^ d34 ^ c28 ^ c10 ^ d42 ^ d23 ^ d7 ^ d22 ^ c25 ^ 
        c6 ^ d27 ^ d25 ^ c15 ^ d9 ^ d21 ^ c5 ^ c31 ^ d31 ^ d26 ^ 
        d29 ^ d41 ^ c18 ^ c29 ^ c11 ^ c26 ^ c13 ^ d13 ^ d44 ^ c9 ^ 
        d6 ^ c12 ^ d3 ^ d45 ^ d28 ^ c7;  // 35 ins 1 outs

    assign x28 = d33 ^ d21 ^ c14 ^ c30 ^ d25 ^ c17 ^ d46 ^ c12 ^ d6 ^ 
        d22 ^ c5 ^ c28 ^ c6 ^ c10 ^ d40 ^ d2 ^ d20 ^ c4 ^ d5 ^ 
        c9 ^ d12 ^ d41 ^ c11 ^ c25 ^ d26 ^ c8 ^ d27 ^ d8 ^ d44 ^ 
        c27 ^ d43 ^ d30 ^ d28 ^ d24 ^ c24;  // 35 ins 1 outs

    assign x27 = d24 ^ d27 ^ c29 ^ c10 ^ d23 ^ d5 ^ d1 ^ c24 ^ c9 ^ 
        d20 ^ d39 ^ d19 ^ c3 ^ d45 ^ d25 ^ d26 ^ d29 ^ c4 ^ c8 ^ 
        d4 ^ d42 ^ c13 ^ c27 ^ c16 ^ c7 ^ d43 ^ d32 ^ d7 ^ d11 ^ 
        d21 ^ c11 ^ d40 ^ c23 ^ c5 ^ c26;  // 35 ins 1 outs

    assign x26 = d26 ^ d0 ^ d19 ^ d3 ^ c31 ^ d44 ^ d24 ^ d10 ^ c10 ^ 
        d22 ^ d23 ^ c28 ^ c8 ^ c7 ^ d18 ^ c12 ^ c3 ^ c2 ^ c9 ^ 
        d42 ^ c15 ^ d4 ^ c23 ^ d6 ^ d25 ^ d31 ^ d28 ^ d47 ^ d41 ^ 
        d39 ^ c4 ^ c26 ^ c6 ^ d38 ^ c25 ^ d20 ^ c22;  // 37 ins 1 outs

    assign x25 = d33 ^ c3 ^ c24 ^ c21 ^ c28 ^ d44 ^ d38 ^ d29 ^ c22 ^ 
        d17 ^ d2 ^ c2 ^ d18 ^ c1 ^ d28 ^ c6 ^ d22 ^ c17 ^ c25 ^ 
        d21 ^ d11 ^ d41 ^ d40 ^ c12 ^ d36 ^ d31 ^ d15 ^ c5 ^ d8 ^ 
        c20 ^ c13 ^ d37 ^ d3 ^ d19 ^ c15;  // 35 ins 1 outs

    assign x24 = d27 ^ d17 ^ c12 ^ c31 ^ d18 ^ c27 ^ c14 ^ d39 ^ d21 ^ 
        d40 ^ d16 ^ d30 ^ c23 ^ c16 ^ c2 ^ c11 ^ c0 ^ d37 ^ c5 ^ 
        d32 ^ d7 ^ d28 ^ c20 ^ c21 ^ d20 ^ c4 ^ c19 ^ d36 ^ c24 ^ 
        d43 ^ d35 ^ d14 ^ d1 ^ c1 ^ d47 ^ d10 ^ d2;  // 37 ins 1 outs

    assign x23 = c31 ^ d46 ^ d13 ^ d31 ^ d42 ^ d35 ^ d16 ^ d34 ^ d15 ^ 
        c15 ^ d9 ^ c23 ^ d0 ^ c3 ^ d17 ^ c0 ^ d6 ^ d29 ^ c26 ^ 
        d20 ^ d36 ^ c10 ^ d47 ^ d38 ^ d39 ^ c4 ^ c18 ^ c1 ^ d1 ^ 
        d19 ^ c20 ^ d26 ^ d27 ^ c22 ^ c19 ^ c13 ^ c30 ^ c11;  // 38 ins 1 outs

    assign x22 = c28 ^ d26 ^ c18 ^ d47 ^ c10 ^ d0 ^ d18 ^ c22 ^ c13 ^ 
        c0 ^ d38 ^ d41 ^ d9 ^ d23 ^ d11 ^ c15 ^ d16 ^ c27 ^ c7 ^ 
        c3 ^ d37 ^ d14 ^ d44 ^ c2 ^ c19 ^ c20 ^ d43 ^ d29 ^ d35 ^ 
        d36 ^ d45 ^ d31 ^ c11 ^ d27 ^ d24 ^ d34 ^ c29 ^ c21 ^ c31 ^ 
        d19 ^ c25 ^ c8 ^ d12;  // 43 ins 1 outs

    assign x21 = c1 ^ d27 ^ c10 ^ c2 ^ c13 ^ d26 ^ d40 ^ c21 ^ c8 ^ 
        d34 ^ d42 ^ d9 ^ d18 ^ c26 ^ d10 ^ c18 ^ c24 ^ c19 ^ d17 ^ 
        d37 ^ d31 ^ c6 ^ c15 ^ d35 ^ d29 ^ d5 ^ c11 ^ d22 ^ d24 ^ 
        d13;  // 30 ins 1 outs

    assign x20 = d16 ^ d26 ^ d34 ^ c23 ^ c18 ^ d33 ^ d28 ^ d9 ^ c1 ^ 
        c10 ^ d21 ^ c17 ^ c14 ^ d25 ^ d8 ^ c12 ^ d23 ^ c7 ^ c5 ^ 
        d17 ^ c0 ^ d12 ^ d39 ^ d4 ^ d41 ^ c9 ^ c25 ^ d36 ^ c20 ^ 
        d30;  // 30 ins 1 outs

    assign x19 = d8 ^ c8 ^ c22 ^ c17 ^ d22 ^ d7 ^ d3 ^ d38 ^ d16 ^ 
        c6 ^ d11 ^ c31 ^ d25 ^ d24 ^ c11 ^ c16 ^ d32 ^ c0 ^ d20 ^ 
        c19 ^ d29 ^ d33 ^ c24 ^ c9 ^ d40 ^ d27 ^ c4 ^ d15 ^ d47 ^ 
        c13 ^ d35;  // 31 ins 1 outs

    assign x18 = c10 ^ c15 ^ c18 ^ d37 ^ c3 ^ c16 ^ d46 ^ d7 ^ d6 ^ 
        d28 ^ c23 ^ d32 ^ d15 ^ c21 ^ d26 ^ d39 ^ c12 ^ d19 ^ c30 ^ 
        d34 ^ d14 ^ c8 ^ d2 ^ d24 ^ d21 ^ d31 ^ d23 ^ c7 ^ c5 ^ 
        d10;  // 30 ins 1 outs

    assign x17 = d30 ^ c6 ^ d6 ^ d47 ^ d14 ^ c20 ^ d23 ^ c11 ^ d25 ^ 
        c14 ^ c31 ^ c29 ^ d27 ^ d13 ^ d38 ^ d45 ^ d5 ^ c17 ^ d18 ^ 
        c15 ^ c9 ^ d20 ^ c2 ^ d22 ^ d1 ^ c7 ^ d31 ^ c4 ^ d33 ^ 
        c22 ^ d9 ^ d36;  // 32 ins 1 outs

    assign x16 = d26 ^ c19 ^ c6 ^ d22 ^ c5 ^ d30 ^ d24 ^ d13 ^ c13 ^ 
        c21 ^ d35 ^ d17 ^ c28 ^ c31 ^ d5 ^ d32 ^ d29 ^ d8 ^ d37 ^ 
        d44 ^ d4 ^ c30 ^ d19 ^ c16 ^ c8 ^ d12 ^ d46 ^ d0 ^ c10 ^ 
        c1 ^ d47 ^ c14 ^ c3 ^ d21;  // 34 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat48_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [47:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x251, x250, x249, x248, x247, x246, x245, 
       x244, x243, x242, x241, x240, x239, x238, x237, 
       x236, x235, x234, x233, x232, x231, x230, x229, 
       x228, x227, x226, x225, x224, x223, x222, x221, 
       x220, x219, x218, x217, x216, x215, x214, x213, 
       x212, x211, x210, x209, x208, x207, x206, x205, 
       x204, x203, x202, x201, x200, x199, x198, x197, 
       x196, x195, x194, x193, x192, x191, x190, x189, 
       x188, x187, x186, x185, x184, x183, x182, x181, 
       x180, x179, x178, x177, x176, x175, x174, x173, 
       x172, x171, x170, x169, x168, x167, x166, x165, 
       x164, x163, x162, x161, x160, x159, x158, x157, 
       x156, x155, x154, x153, x152, x151, x150, x149, 
       x148, x147, x146, x145, x144, x143, x142, x141, 
       x15, x14, x13, x12, x11, x10, x9, x8, 
       x7, x6, x5, x4, x3, x2, x1, x0, 
       x31, x30, x29, x28, x27, x26, x25, x24, 
       x23, x22, x21, x20, x19, x18, x17, x16;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47;

assign { d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [47:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x251i (.out(x251),.a(c20),.b(d22),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x250i (.out(x250),.a(x158),.b(d41),.c(c27),.d(d43),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x249i (.out(x249),.a(d22),.b(x219),.c(x199),.d(x195),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x248i (.out(x248),.a(x149),.b(d39),.c(c5),.d(d21),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x247i (.out(x247),.a(x150),.b(d22),.c(c6),.d(c5),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x246i (.out(x246),.a(c31),.b(d9),.c(c11),.d(d47),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x245i (.out(x245),.a(x151),.b(d11),.c(d45),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x244i (.out(x244),.a(x186),.b(x141),.c(d5),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x243i (.out(x243),.a(x156),.b(d6),.c(d29),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x242i (.out(x242),.a(x157),.b(c13),.c(c14),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x241i (.out(x241),.a(c3),.b(c20),.c(d19),.d(d36),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x240i (.out(x240),.a(x148),.b(x213),.c(x174),.d(x155),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x239i (.out(x239),.a(x151),.b(x167),.c(c22),.d(d2),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x238i (.out(x238),.a(x149),.b(x175),.c(d11),.d(c18),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x237i (.out(x237),.a(x144),.b(d4),.c(d14),.d(d44),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x236i (.out(x236),.a(x150),.b(c2),.c(d45),.d(c29),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x235i (.out(x235),.a(x141),.b(d10),.c(x157),.d(d32),.e(d8),.f(1'b0));  // 5 ins 1 outs

    xor6 x234i (.out(x234),.a(d9),.b(d10),.c(c3),.d(d7),.e(x166),.f(1'b0));  // 5 ins 1 outs

    xor6 x233i (.out(x233),.a(c29),.b(d45),.c(x206),.d(x158),.e(x151),.f(1'b0));  // 5 ins 1 outs

    xor6 x232i (.out(x232),.a(d13),.b(d12),.c(d6),.d(x163),.e(x175),.f(1'b0));  // 5 ins 1 outs

    xor6 x231i (.out(x231),.a(c5),.b(d14),.c(d15),.d(x163),.e(x148),.f(1'b0));  // 5 ins 1 outs

    xor6 x230i (.out(x230),.a(d9),.b(x156),.c(d12),.d(c14),.e(d23),.f(1'b0));  // 5 ins 1 outs

    xor6 x229i (.out(x229),.a(x193),.b(d40),.c(c24),.d(d24),.e(c21),.f(1'b0));  // 5 ins 1 outs

    xor6 x228i (.out(x228),.a(d33),.b(d47),.c(c30),.d(c31),.e(d0),.f(1'b0));  // 5 ins 1 outs

    xor6 x227i (.out(x227),.a(x201),.b(d29),.c(x154),.d(x150),.e(x147),.f(1'b0));  // 5 ins 1 outs

    xor6 x226i (.out(x226),.a(c20),.b(x151),.c(x152),.d(d5),.e(d8),.f(1'b0));  // 5 ins 1 outs

    xor6 x225i (.out(x225),.a(x158),.b(d6),.c(x167),.d(x147),.e(x149),.f(1'b0));  // 5 ins 1 outs

    xor6 x224i (.out(x224),.a(x199),.b(c19),.c(d7),.d(c6),.e(d35),.f(1'b0));  // 5 ins 1 outs

    xor6 x223i (.out(x223),.a(d31),.b(d3),.c(d10),.d(c17),.e(x174),.f(1'b0));  // 5 ins 1 outs

    xor6 x222i (.out(x222),.a(x150),.b(x199),.c(x193),.d(d4),.e(d8),.f(1'b0));  // 5 ins 1 outs

    xor6 x221i (.out(x221),.a(d16),.b(d6),.c(c7),.d(d30),.e(c9),.f(1'b0));  // 5 ins 1 outs

    xor6 x220i (.out(x220),.a(d16),.b(c1),.c(c21),.d(x154),.e(c0),.f(1'b0));  // 5 ins 1 outs

    xor6 x219i (.out(x219),.a(d36),.b(d14),.c(d25),.d(d1),.e(c6),.f(1'b0));  // 5 ins 1 outs

    xor6 x218i (.out(x218),.a(c30),.b(d46),.c(x159),.d(d40),.e(c14),.f(1'b0));  // 5 ins 1 outs

    xor6 x217i (.out(x217),.a(c14),.b(d3),.c(d30),.d(x144),.e(x166),.f(1'b0));  // 5 ins 1 outs

    xor6 x216i (.out(x216),.a(c16),.b(d32),.c(x159),.d(x163),.e(d8),.f(1'b0));  // 5 ins 1 outs

    xor6 x215i (.out(x215),.a(x159),.b(d17),.c(d35),.d(x182),.e(d1),.f(1'b0));  // 5 ins 1 outs

    xor6 x214i (.out(x214),.a(x142),.b(c28),.c(d44),.d(d40),.e(d7),.f(1'b0));  // 5 ins 1 outs

    xor6 x213i (.out(x213),.a(d13),.b(c3),.c(d19),.d(d0),.e(c13),.f(1'b0));  // 5 ins 1 outs

    xor6 x212i (.out(x212),.a(x163),.b(d45),.c(c0),.d(c25),.e(x148),.f(1'b0));  // 5 ins 1 outs

    xor6 x211i (.out(x211),.a(c23),.b(d10),.c(x148),.d(d13),.e(x155),.f(1'b0));  // 5 ins 1 outs

    xor6 x210i (.out(x210),.a(x154),.b(d33),.c(d44),.d(c28),.e(x186),.f(1'b0));  // 5 ins 1 outs

    xor6 x209i (.out(x209),.a(d7),.b(x193),.c(d27),.d(x163),.e(x147),.f(1'b0));  // 5 ins 1 outs

    xor6 x208i (.out(x208),.a(x142),.b(x155),.c(x153),.d(d30),.e(x175),.f(1'b0));  // 5 ins 1 outs

    xor6 x207i (.out(x207),.a(c25),.b(d41),.c(c7),.d(x154),.e(d8),.f(1'b0));  // 5 ins 1 outs

    xor6 x206i (.out(x206),.a(c18),.b(d35),.c(d34),.d(d15),.e(d12),.f(1'b0));  // 5 ins 1 outs

    xor6 x205i (.out(x205),.a(x153),.b(c17),.c(d7),.d(d0),.e(d33),.f(1'b0));  // 5 ins 1 outs

    xor6 x204i (.out(x204),.a(d2),.b(c28),.c(d11),.d(x155),.e(c13),.f(1'b0));  // 5 ins 1 outs

    xor6 x203i (.out(x203),.a(x144),.b(d18),.c(x163),.d(x152),.e(d6),.f(1'b0));  // 5 ins 1 outs

    xor6 x202i (.out(x202),.a(c6),.b(c7),.c(c16),.d(d22),.e(x152),.f(1'b0));  // 5 ins 1 outs

    xor6 x201i (.out(x201),.a(c26),.b(c7),.c(c14),.d(d11),.e(d42),.f(1'b0));  // 5 ins 1 outs

    xor6 x200i (.out(x200),.a(x147),.b(d19),.c(c16),.d(x153),.e(d32),.f(1'b0));  // 5 ins 1 outs

    xor6 x199i (.out(x199),.a(d36),.b(c20),.c(c13),.d(d29),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x198i (.out(x198),.a(d37),.b(c18),.c(x151),.d(d10),.e(c8),.f(1'b0));  // 5 ins 1 outs

    xor6 x197i (.out(x197),.a(d6),.b(x143),.c(x147),.d(d3),.e(d15),.f(1'b0));  // 5 ins 1 outs

    xor6 x196i (.out(x196),.a(x148),.b(x157),.c(d36),.d(d33),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x195i (.out(x195),.a(d19),.b(d3),.c(c3),.d(d25),.e(d2),.f(1'b0));  // 5 ins 2 outs

    xor6 x194i (.out(x194),.a(c0),.b(c6),.c(x182),.d(d9),.e(d22),.f(1'b0));  // 5 ins 1 outs

    xor6 x193i (.out(x193),.a(d16),.b(d29),.c(c10),.d(d26),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x192i (.out(x192),.a(d42),.b(d15),.c(d2),.d(x163),.e(c26),.f(1'b0));  // 5 ins 2 outs

    xor6 x191i (.out(x191),.a(x150),.b(d36),.c(d17),.d(d35),.e(d40),.f(1'b0));  // 5 ins 1 outs

    xor6 x190i (.out(x190),.a(d36),.b(x141),.c(d25),.d(c9),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x189i (.out(x189),.a(x148),.b(d17),.c(c1),.d(c7),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x188i (.out(x188),.a(d6),.b(x166),.c(c19),.d(c29),.e(d35),.f(1'b0));  // 5 ins 2 outs

    xor6 x187i (.out(x187),.a(d39),.b(d1),.c(x148),.d(c23),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x186i (.out(x186),.a(d46),.b(c30),.c(d12),.d(d43),.e(c27),.f(1'b0));  // 5 ins 2 outs

    xor6 x185i (.out(x185),.a(c15),.b(x149),.c(d31),.d(c14),.e(x147),.f(1'b0));  // 5 ins 2 outs

    xor6 x184i (.out(x184),.a(c8),.b(d24),.c(x152),.d(d7),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x183i (.out(x183),.a(d38),.b(x155),.c(d7),.d(d5),.e(d40),.f(1'b0));  // 5 ins 1 outs

    xor6 x182i (.out(x182),.a(d14),.b(d13),.c(c13),.d(d33),.e(c17),.f(1'b0));  // 5 ins 2 outs

    xor6 x181i (.out(x181),.a(x153),.b(d21),.c(c0),.d(x163),.e(d4),.f(1'b0));  // 5 ins 2 outs

    xor6 x180i (.out(x180),.a(d18),.b(c2),.c(d27),.d(x142),.e(c11),.f(1'b0));  // 5 ins 2 outs

    xor6 x179i (.out(x179),.a(d31),.b(d23),.c(x151),.d(c15),.e(d13),.f(1'b0));  // 5 ins 3 outs

    xor6 x178i (.out(x178),.a(c19),.b(c22),.c(d7),.d(d38),.e(x152),.f(1'b0));  // 5 ins 2 outs

    xor6 x177i (.out(x177),.a(d37),.b(c21),.c(d14),.d(x149),.e(1'b0),.f(1'b0));  // 4 ins 5 outs

    xor6 x176i (.out(x176),.a(c22),.b(x150),.c(x142),.d(d38),.e(x153),.f(1'b0));  // 5 ins 2 outs

    xor6 x175i (.out(x175),.a(d9),.b(d46),.c(c30),.d(d41),.e(c25),.f(1'b0));  // 5 ins 3 outs

    xor6 x174i (.out(x174),.a(c24),.b(d40),.c(d5),.d(c26),.e(d42),.f(1'b0));  // 5 ins 2 outs

    xor6 x173i (.out(x173),.a(x158),.b(d29),.c(d28),.d(c12),.e(d0),.f(1'b0));  // 5 ins 3 outs

    xor6 x172i (.out(x172),.a(d43),.b(c27),.c(x147),.d(d11),.e(d14),.f(1'b0));  // 5 ins 2 outs

    xor6 x171i (.out(x171),.a(x146),.b(d18),.c(x167),.d(x159),.e(c2),.f(1'b0));  // 5 ins 2 outs

    xor6 x170i (.out(x170),.a(c17),.b(d2),.c(d25),.d(c9),.e(x143),.f(1'b0));  // 5 ins 2 outs

    xor6 x169i (.out(x169),.a(d16),.b(d32),.c(c16),.d(d0),.e(x153),.f(1'b0));  // 5 ins 4 outs

    xor6 x168i (.out(x168),.a(d1),.b(x157),.c(d34),.d(d5),.e(c7),.f(1'b0));  // 5 ins 2 outs

    xor6 x167i (.out(x167),.a(d30),.b(d1),.c(d47),.d(c31),.e(d5),.f(1'b0));  // 5 ins 3 outs

    xor6 x166i (.out(x166),.a(d27),.b(d11),.c(c13),.d(c11),.e(1'b0),.f(1'b0));  // 4 ins 4 outs

    xor6 x165i (.out(x165),.a(d29),.b(x146),.c(d4),.d(d23),.e(1'b0),.f(1'b0));  // 4 ins 6 outs

    xor6 x164i (.out(x164),.a(x154),.b(d30),.c(d4),.d(x141),.e(c24),.f(1'b0));  // 5 ins 3 outs

    xor6 x163i (.out(x163),.a(d6),.b(c18),.c(d34),.d(d16),.e(1'b0),.f(1'b0));  // 4 ins 9 outs

    xor6 x162i (.out(x162),.a(x156),.b(c8),.c(d24),.d(d40),.e(c0),.f(1'b0));  // 5 ins 4 outs

    xor6 x161i (.out(x161),.a(d3),.b(d44),.c(d21),.d(c28),.e(x143),.f(1'b0));  // 5 ins 4 outs

    xor6 x160i (.out(x160),.a(d11),.b(d40),.c(x142),.d(x144),.e(c24),.f(1'b0));  // 5 ins 6 outs

    xor6 x159i (.out(x159),.a(d28),.b(d14),.c(d10),.d(c0),.e(c12),.f(1'b0));  // 5 ins 5 outs

    xor6 x158i (.out(x158),.a(c7),.b(c20),.c(d31),.d(c15),.e(d23),.f(1'b0));  // 5 ins 4 outs

    xor6 x157i (.out(x157),.a(c19),.b(c13),.c(d13),.d(d9),.e(d35),.f(1'b0));  // 5 ins 5 outs

    xor6 x156i (.out(x156),.a(d8),.b(d6),.c(c10),.d(d30),.e(d26),.f(1'b0));  // 5 ins 4 outs

    xor6 x155i (.out(x155),.a(d29),.b(d6),.c(d20),.d(c4),.e(d4),.f(1'b0));  // 5 ins 5 outs

    xor6 x154i (.out(x154),.a(c24),.b(c5),.c(d21),.d(d5),.e(c14),.f(1'b0));  // 5 ins 5 outs

    xor6 x153i (.out(x153),.a(c20),.b(d2),.c(d39),.d(c23),.e(1'b0),.f(1'b0));  // 4 ins 7 outs

    xor6 x152i (.out(x152),.a(d37),.b(d10),.c(d46),.d(c21),.e(c30),.f(1'b0));  // 5 ins 5 outs

    xor6 x151i (.out(x151),.a(d22),.b(c26),.c(c7),.d(d42),.e(c6),.f(1'b0));  // 5 ins 6 outs

    xor6 x150i (.out(x150),.a(d27),.b(c0),.c(c11),.d(d20),.e(c4),.f(1'b0));  // 5 ins 7 outs

    xor6 x149i (.out(x149),.a(c22),.b(d38),.c(d36),.d(c2),.e(d18),.f(1'b0));  // 5 ins 5 outs

    xor6 x148i (.out(x148),.a(d26),.b(d19),.c(c10),.d(d29),.e(c3),.f(1'b0));  // 5 ins 7 outs

    xor6 x147i (.out(x147),.a(c9),.b(d25),.c(c29),.d(d45),.e(c13),.f(1'b0));  // 5 ins 7 outs

    xor6 x146i (.out(x146),.a(d7),.b(d43),.c(c27),.d(d32),.e(c16),.f(1'b0));  // 5 ins 2 outs

    xor6 x145i (.out(x145),.a(d9),.b(d44),.c(x141),.d(d12),.e(c28),.f(1'b0));  // 5 ins 9 outs

    xor6 x144i (.out(x144),.a(d8),.b(d33),.c(d15),.d(c17),.e(d3),.f(1'b0));  // 5 ins 4 outs

    xor6 x143i (.out(x143),.a(c12),.b(c5),.c(d41),.d(d28),.e(c25),.f(1'b0));  // 5 ins 4 outs

    xor6 x142i (.out(x142),.a(d17),.b(c1),.c(d1),.d(d31),.e(c15),.f(1'b0));  // 5 ins 5 outs

    xor6 x141i (.out(x141),.a(d47),.b(c31),.c(c8),.d(d24),.e(d0),.f(1'b0));  // 5 ins 6 outs

    xor6 x15i (.out(x15),.a(x203),.b(x184),.c(x145),.d(x236),.e(x164),.f(1'b0));  // 5 ins 1 outs

    xor6 x14i (.out(x14),.a(x204),.b(x165),.c(x189),.d(x237),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x13i (.out(x13),.a(d23),.b(x221),.c(x179),.d(x195),.e(x171),.f(1'b0));  // 5 ins 1 outs

    xor6 x12i (.out(x12),.a(x232),.b(x164),.c(x192),.d(x180),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x11i (.out(x11),.a(c5),.b(x222),.c(x143),.d(x145),.e(x172),.f(x160));  // 6 ins 1 outs

    xor6 x10i (.out(x10),.a(c15),.b(x223),.c(x159),.d(x196),.e(x169),.f(1'b0));  // 5 ins 1 outs

    xor6 x9i (.out(x9),.a(x205),.b(x165),.c(x238),.d(x145),.e(x168),.f(1'b0));  // 5 ins 1 outs

    xor6 x8i (.out(x8),.a(x233),.b(x165),.c(x173),.d(x178),.e(x160),.f(1'b0));  // 5 ins 1 outs

    xor6 x7i (.out(x7),.a(x197),.b(x141),.c(x165),.d(x226),.e(x181),.f(1'b0));  // 5 ins 1 outs

    xor6 x6i (.out(x6),.a(x183),.b(x239),.c(x172),.d(x207),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x5i (.out(x5),.a(x240),.b(x187),.c(x184),.d(x161),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x4i (.out(x4),.a(x208),.b(x160),.c(x145),.d(x241),.e(x185),.f(1'b0));  // 5 ins 1 outs

    xor6 x3i (.out(x3),.a(x200),.b(x177),.c(x234),.d(x160),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x2i (.out(x2),.a(x214),.b(x162),.c(x242),.d(x177),.e(x169),.f(1'b0));  // 5 ins 1 outs

    xor6 x1i (.out(x1),.a(x215),.b(c1),.c(x163),.d(x166),.e(x178),.f(x145));  // 6 ins 1 outs

    xor6 x0i (.out(x0),.a(x216),.b(x177),.c(x243),.d(x145),.e(x185),.f(1'b0));  // 5 ins 1 outs

    xor6 x31i (.out(x31),.a(x217),.b(x145),.c(x244),.d(x190),.e(x173),.f(1'b0));  // 5 ins 1 outs

    xor6 x30i (.out(x30),.a(x218),.b(x162),.c(x245),.d(x165),.e(x188),.f(1'b0));  // 5 ins 1 outs

    xor6 x29i (.out(x29),.a(x209),.b(x246),.c(x161),.d(x179),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x28i (.out(x28),.a(x210),.b(x170),.c(x247),.d(x162),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x27i (.out(x27),.a(x227),.b(x165),.c(x162),.d(x187),.e(x156),.f(1'b0));  // 5 ins 1 outs

    xor6 x26i (.out(x26),.a(x211),.b(x179),.c(x190),.d(x248),.e(x161),.f(1'b0));  // 5 ins 1 outs

    xor6 x25i (.out(x25),.a(x249),.b(x177),.c(x161),.d(x160),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x24i (.out(x24),.a(x191),.b(c19),.c(d37),.d(x153),.e(x171),.f(x220));  // 6 ins 1 outs

    xor6 x23i (.out(x23),.a(d46),.b(x196),.c(x228),.d(x176),.e(x192),.f(1'b0));  // 5 ins 1 outs

    xor6 x22i (.out(x22),.a(x212),.b(x177),.c(x250),.d(x145),.e(x188),.f(1'b0));  // 5 ins 1 outs

    xor6 x21i (.out(x21),.a(x198),.b(d16),.c(x180),.d(x229),.e(x168),.f(1'b0));  // 5 ins 1 outs

    xor6 x20i (.out(x20),.a(x230),.b(x157),.c(x196),.d(x170),.e(x189),.f(x181));  // 6 ins 1 outs

    xor6 x19i (.out(x19),.a(x224),.b(x251),.c(x160),.d(x169),.e(x190),.f(x176));  // 6 ins 1 outs

    xor6 x18i (.out(x18),.a(x231),.b(d21),.c(x169),.d(x184),.e(x173),.f(1'b0));  // 5 ins 1 outs

    xor6 x17i (.out(x17),.a(x194),.b(c14),.c(x150),.d(x225),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x16i (.out(x16),.a(x189),.b(x202),.c(x145),.d(x164),.e(x235),.f(1'b0));  // 5 ins 1 outs

endmodule

