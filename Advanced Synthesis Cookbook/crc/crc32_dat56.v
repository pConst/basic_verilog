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

//// CRC-32 of 56 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 00000000001111111111222222222233333333334444444444555555
//        01234567890123456789012345678901 01234567890123456789012345678901234567890123456789012345
//
// C00  = XXX.XXXXX.X..X......XX.XX.X..XXX X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX
// C01  = X..XX....XXX.XX.....X.XX.XXX.X.. XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..
// C02  = X.X...XXX..XXXXX....X......XXX.X XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X
// C03  = .X.X...XXX..XXXXX....X......XXX. .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.
// C04  = XX...XXX.X....XXXX..XXXXX.X..... X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X.....
// C05  = X...XX.......X.XXXX.X.X..XXX.XXX XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX
// C06  = .X...XX.......X.XXXX.X.X..XXX.XX .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XX
// C07  = XX..XX..X.X..X.X.XXX.XXX..XXX.X. X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.
// C08  = ....X..XXXXX.XX.X.XX.XX...XXX.X. XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X.
// C09  = X....X..XXXXX.XX.X.XX.XX...XXX.X .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X
// C10  = ..X.XX.XXX.XX..XX.X.......X.X..X X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..X
// C11  = XXXXX..X.X..X...XX.XXX.XX.XX..XX XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XX
// C12  = X..X..XX.........XX...XX.XXXXXX. XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.
// C13  = .X..X..XX.........XX...XX.XXXXXX .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX
// C14  = ..X..X..XX.........XX...XX.XXXXX ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXX
// C15  = X..X..X..XX.........XX...XX.XXXX ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXX
// C16  = X.X..XX.X..X.X......X.XXX..X.... X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....
// C17  = .X.X..XX.X..X.X......X.XXX..X... .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X...
// C18  = X.X.X..XX.X..X.X......X.XXX..X.. ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X..
// C19  = XX.X.X..XX.X..X.X......X.XXX..X. ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X.
// C20  = .XX.X.X..XX.X..X.X......X.XXX..X ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X
// C21  = X.XX.X.X..XX.X..X.X......X.XXX.. .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..
// C22  = X.XX.X.X..XXXXX..X.XXX.XX...X..X X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X
// C23  = ..XX.X.X..XXX.XX..X...XX.XX...XX XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XX
// C24  = ...XX.X.X..XXX.XX..X...XX.XX...X .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...X
// C25  = ....XX.X.X..XXX.XX..X...XX.XX... ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...
// C26  = XXX.X..X......XX.XX.X..XXX..X.XX X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX
// C27  = XXXX.X..X......XX.XX.X..XXX..X.X .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.X
// C28  = XXXXX.X..X......XX.XX.X..XXX..X. ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.
// C29  = .XXXXX.X..X......XX.XX.X..XXX..X ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X
// C30  = X.XXXXX.X..X......XX.XX.X..XXX.. ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..
// C31  = XX.XXXXX.X..X......XX.XX.X..XXX. .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX.
//
module crc32_dat56 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [55:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat56_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat56_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat56_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [55:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x23, x22, x21, x20, x19, x18, x17, 
       x16, x15, x14, x13, x12, x11, x10, x9, 
       x8, x7, x6, x5, x4, x3, x2, x1, 
       x0, x31, x30, x29, x28, x27, x26, x25, 
       x24;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55;

assign { d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [55:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x23 = d29 ^ d47 ^ c7 ^ c26 ^ c11 ^ d13 ^ d17 ^ c25 ^ c18 ^ 
        d49 ^ c10 ^ d38 ^ d54 ^ d55 ^ c12 ^ d50 ^ d20 ^ d36 ^ d39 ^ 
        d34 ^ d6 ^ d16 ^ d9 ^ d0 ^ d19 ^ c30 ^ c22 ^ c3 ^ c14 ^ 
        c15 ^ c5 ^ d1 ^ d31 ^ d15 ^ c23 ^ d46 ^ d42 ^ c2 ^ c31 ^ 
        d26 ^ d35 ^ d27;  // 42 ins 1 outs

    assign x22 = c24 ^ d44 ^ c21 ^ c20 ^ d36 ^ d43 ^ d19 ^ d16 ^ d9 ^ 
        d55 ^ c19 ^ d14 ^ c3 ^ d52 ^ d41 ^ d18 ^ c2 ^ c12 ^ c28 ^ 
        c31 ^ d11 ^ c0 ^ c7 ^ c10 ^ c13 ^ c11 ^ d38 ^ d45 ^ c23 ^ 
        d35 ^ c14 ^ d0 ^ c17 ^ d31 ^ d26 ^ d37 ^ d23 ^ d27 ^ d47 ^ 
        d29 ^ d48 ^ d24 ^ c5 ^ d12 ^ d34;  // 45 ins 1 outs

    assign x21 = d34 ^ d9 ^ d5 ^ d17 ^ d40 ^ c25 ^ c2 ^ d29 ^ d35 ^ 
        c16 ^ d51 ^ d22 ^ d18 ^ d52 ^ d53 ^ d24 ^ d31 ^ d42 ^ c28 ^ 
        c5 ^ c0 ^ c10 ^ d37 ^ c7 ^ d49 ^ c18 ^ c29 ^ c11 ^ c13 ^ 
        c27 ^ d13 ^ d10 ^ c3 ^ d26 ^ d27;  // 35 ins 1 outs

    assign x20 = d39 ^ d30 ^ d36 ^ d33 ^ c15 ^ d50 ^ c24 ^ d28 ^ c31 ^ 
        d16 ^ d9 ^ c28 ^ c26 ^ d34 ^ d41 ^ d52 ^ d26 ^ c17 ^ c12 ^ 
        c2 ^ c6 ^ d25 ^ d8 ^ d55 ^ c10 ^ d48 ^ c1 ^ c4 ^ c27 ^ 
        d17 ^ d21 ^ d23 ^ c9 ^ d51 ^ d4 ^ d12;  // 36 ins 1 outs

    assign x19 = c30 ^ c8 ^ d54 ^ d29 ^ d32 ^ d11 ^ c23 ^ c9 ^ d50 ^ 
        c14 ^ d33 ^ d16 ^ d35 ^ c27 ^ d47 ^ d27 ^ c16 ^ c3 ^ d51 ^ 
        d40 ^ d22 ^ d15 ^ d38 ^ c11 ^ d49 ^ d7 ^ d3 ^ d20 ^ c25 ^ 
        c5 ^ c26 ^ d25 ^ c1 ^ d24 ^ c0 ^ d8;  // 36 ins 1 outs

    assign x18 = d46 ^ d39 ^ d34 ^ d53 ^ d32 ^ c10 ^ d31 ^ d10 ^ d15 ^ 
        c8 ^ d37 ^ d48 ^ c4 ^ c7 ^ d6 ^ d26 ^ d7 ^ d50 ^ c24 ^ 
        d24 ^ c29 ^ d14 ^ d2 ^ c13 ^ c2 ^ c15 ^ d49 ^ c0 ^ d19 ^ 
        c26 ^ c25 ^ d28 ^ c22 ^ d21 ^ d23;  // 35 ins 1 outs

    assign x17 = d1 ^ c14 ^ d38 ^ d13 ^ d25 ^ d23 ^ d36 ^ d18 ^ d27 ^ 
        d49 ^ d47 ^ c1 ^ d52 ^ d14 ^ d45 ^ c12 ^ d5 ^ d9 ^ d48 ^ 
        c9 ^ c23 ^ c28 ^ c6 ^ d33 ^ c3 ^ d30 ^ c7 ^ d20 ^ c24 ^ 
        d6 ^ c21 ^ d22 ^ c25 ^ d31;  // 34 ins 1 outs

    assign x16 = d37 ^ d47 ^ c5 ^ c11 ^ c2 ^ d19 ^ c22 ^ d4 ^ c0 ^ 
        d21 ^ d0 ^ d30 ^ d44 ^ d22 ^ d26 ^ c23 ^ d32 ^ d29 ^ c20 ^ 
        c24 ^ c6 ^ c27 ^ c8 ^ d35 ^ d48 ^ d51 ^ d13 ^ d17 ^ d24 ^ 
        d8 ^ c13 ^ d12 ^ d5 ^ d46;  // 34 ins 1 outs

    assign x15 = d34 ^ d33 ^ d3 ^ c26 ^ d54 ^ d30 ^ c20 ^ d12 ^ d15 ^ 
        d4 ^ d7 ^ c31 ^ d55 ^ d18 ^ c29 ^ c30 ^ d50 ^ d20 ^ d21 ^ 
        d9 ^ d27 ^ c28 ^ c0 ^ d8 ^ d5 ^ d24 ^ c3 ^ d45 ^ c6 ^ 
        d44 ^ c9 ^ d49 ^ c25 ^ c21 ^ c10 ^ d16 ^ d52 ^ d53;  // 38 ins 1 outs

    assign x14 = d32 ^ d26 ^ d14 ^ d7 ^ d33 ^ d55 ^ d44 ^ d17 ^ c30 ^ 
        c27 ^ c24 ^ d49 ^ d8 ^ d54 ^ c20 ^ d2 ^ d4 ^ c28 ^ c25 ^ 
        d20 ^ c29 ^ d6 ^ d15 ^ d3 ^ c8 ^ d43 ^ c2 ^ d11 ^ c9 ^ 
        d53 ^ c19 ^ d51 ^ d19 ^ d29 ^ d48 ^ d23 ^ c5 ^ c31 ^ d52;  // 39 ins 1 outs

    assign x13 = c28 ^ d19 ^ d31 ^ c27 ^ d13 ^ d53 ^ d55 ^ c1 ^ d1 ^ 
        d48 ^ c23 ^ d2 ^ d14 ^ d7 ^ d54 ^ d52 ^ c18 ^ d3 ^ d22 ^ 
        d51 ^ d47 ^ d43 ^ d18 ^ c7 ^ c19 ^ c24 ^ c31 ^ c8 ^ d50 ^ 
        d32 ^ c4 ^ c26 ^ d5 ^ d42 ^ c30 ^ d6 ^ c29 ^ d16 ^ d28 ^ 
        d25 ^ d10;  // 41 ins 1 outs

    assign x12 = c0 ^ d54 ^ c29 ^ c6 ^ d13 ^ d21 ^ d50 ^ c25 ^ d15 ^ 
        d27 ^ c27 ^ d41 ^ c17 ^ d51 ^ d2 ^ d6 ^ d5 ^ d24 ^ d49 ^ 
        c3 ^ d12 ^ c22 ^ d9 ^ d52 ^ c30 ^ d0 ^ c26 ^ d4 ^ d46 ^ 
        d18 ^ d30 ^ d42 ^ d53 ^ c28 ^ c7 ^ d17 ^ d1 ^ d31 ^ d47 ^ 
        c18 ^ c23;  // 41 ins 1 outs

    assign x11 = d51 ^ d12 ^ c4 ^ d50 ^ c19 ^ d43 ^ d33 ^ d54 ^ c3 ^ 
        c16 ^ c20 ^ d48 ^ d27 ^ d17 ^ c9 ^ d9 ^ c21 ^ d20 ^ d40 ^ 
        d41 ^ d44 ^ d28 ^ c31 ^ d15 ^ c27 ^ d1 ^ d3 ^ d16 ^ d31 ^ 
        d25 ^ d26 ^ c26 ^ c7 ^ d47 ^ c17 ^ d24 ^ d36 ^ c30 ^ c23 ^ 
        c2 ^ c12 ^ c0 ^ d45 ^ d14 ^ c24 ^ c1 ^ d55 ^ d0 ^ d4;  // 49 ins 1 outs

    assign x10 = d36 ^ c2 ^ d3 ^ c12 ^ d42 ^ d31 ^ c4 ^ c8 ^ c31 ^ 
        d5 ^ d16 ^ c15 ^ c11 ^ d50 ^ c5 ^ d52 ^ d26 ^ c28 ^ c26 ^ 
        d2 ^ c7 ^ d40 ^ d19 ^ d32 ^ d29 ^ d35 ^ d28 ^ c9 ^ d9 ^ 
        d55 ^ d0 ^ d13 ^ d14 ^ d33 ^ c18 ^ d39 ^ c16;  // 37 ins 1 outs

    assign x9 = d47 ^ c23 ^ d35 ^ c17 ^ d4 ^ d53 ^ d29 ^ c31 ^ d52 ^ 
        c8 ^ d18 ^ c9 ^ c15 ^ d33 ^ d32 ^ c29 ^ c27 ^ c5 ^ d39 ^ 
        c22 ^ d34 ^ c10 ^ d38 ^ d46 ^ c14 ^ d13 ^ d24 ^ d41 ^ c28 ^ 
        c0 ^ d23 ^ d44 ^ d51 ^ d43 ^ c12 ^ c11 ^ d11 ^ c20 ^ d12 ^ 
        d55 ^ d5 ^ d2 ^ c19 ^ d1 ^ d36 ^ d9;  // 46 ins 1 outs

    assign x8 = d31 ^ d54 ^ d0 ^ d51 ^ d40 ^ c16 ^ d52 ^ d37 ^ d17 ^ 
        c30 ^ d3 ^ d45 ^ d32 ^ c13 ^ d12 ^ d33 ^ c8 ^ d46 ^ d35 ^ 
        c4 ^ d34 ^ c18 ^ d50 ^ d23 ^ d43 ^ c22 ^ d8 ^ c26 ^ d22 ^ 
        c7 ^ c21 ^ d28 ^ d10 ^ c28 ^ d42 ^ c27 ^ c10 ^ c14 ^ c9 ^ 
        d4 ^ d38 ^ c11 ^ d11 ^ c19 ^ d1;  // 45 ins 1 outs

    assign x7 = d37 ^ d16 ^ c10 ^ d47 ^ d8 ^ d39 ^ d54 ^ c0 ^ c1 ^ 
        d3 ^ d51 ^ c26 ^ c19 ^ d43 ^ d42 ^ c27 ^ c4 ^ d24 ^ d7 ^ 
        c8 ^ c17 ^ c22 ^ d45 ^ d0 ^ d46 ^ d25 ^ c18 ^ d29 ^ d50 ^ 
        c21 ^ d21 ^ d10 ^ d2 ^ d23 ^ d5 ^ c30 ^ d15 ^ c23 ^ c28 ^ 
        c15 ^ c5 ^ d32 ^ d41 ^ d22 ^ c13 ^ d34 ^ d52 ^ d28;  // 48 ins 1 outs

    assign x6 = c21 ^ d50 ^ c6 ^ c1 ^ c30 ^ d52 ^ c31 ^ d25 ^ d42 ^ 
        d47 ^ d8 ^ c5 ^ d11 ^ d41 ^ c17 ^ d21 ^ d2 ^ c26 ^ d4 ^ 
        d30 ^ c23 ^ d38 ^ d29 ^ d22 ^ c28 ^ c27 ^ d40 ^ d7 ^ c18 ^ 
        d54 ^ c14 ^ d5 ^ d6 ^ d51 ^ d45 ^ d14 ^ d55 ^ d20 ^ d1 ^ 
        c16 ^ c19 ^ d43;  // 42 ins 1 outs

    assign x5 = c25 ^ d29 ^ c31 ^ d55 ^ c26 ^ d24 ^ d46 ^ c20 ^ d49 ^ 
        c22 ^ d41 ^ d40 ^ d4 ^ d50 ^ c27 ^ d5 ^ c29 ^ d53 ^ d20 ^ 
        c16 ^ d21 ^ d19 ^ d28 ^ d6 ^ c4 ^ c18 ^ d37 ^ c30 ^ d1 ^ 
        d39 ^ d0 ^ d54 ^ d13 ^ d7 ^ c15 ^ c17 ^ d51 ^ d3 ^ c5 ^ 
        d10 ^ c0 ^ c13 ^ d44 ^ d42;  // 44 ins 1 outs

    assign x4 = d24 ^ d48 ^ d29 ^ d47 ^ d6 ^ d18 ^ c26 ^ d8 ^ d19 ^ 
        d15 ^ c7 ^ d44 ^ c0 ^ d4 ^ d0 ^ d38 ^ d40 ^ c16 ^ d12 ^ 
        c24 ^ d50 ^ d33 ^ c6 ^ c1 ^ d3 ^ d46 ^ d20 ^ d11 ^ c15 ^ 
        d45 ^ d39 ^ c5 ^ c22 ^ d2 ^ d31 ^ c9 ^ d25 ^ d30 ^ c20 ^ 
        c17 ^ c21 ^ c23 ^ c14 ^ d41;  // 44 ins 1 outs

    assign x3 = d10 ^ d32 ^ d31 ^ c3 ^ d33 ^ c8 ^ d2 ^ d52 ^ d17 ^ 
        c7 ^ d38 ^ d14 ^ d7 ^ d3 ^ d27 ^ d54 ^ d19 ^ d15 ^ d40 ^ 
        d45 ^ c1 ^ c16 ^ d1 ^ c13 ^ c15 ^ d39 ^ c12 ^ c30 ^ d37 ^ 
        d8 ^ d36 ^ d53 ^ c9 ^ c14 ^ d25 ^ c21 ^ d9 ^ c28 ^ c29 ^ 
        d18;  // 40 ins 1 outs

    assign x2 = d26 ^ c31 ^ c11 ^ d32 ^ d51 ^ d30 ^ d6 ^ d24 ^ c29 ^ 
        c0 ^ c7 ^ d16 ^ c2 ^ d53 ^ d1 ^ d36 ^ d39 ^ c6 ^ d14 ^ 
        c13 ^ c20 ^ c15 ^ d9 ^ d35 ^ d55 ^ d37 ^ d2 ^ c12 ^ d17 ^ 
        d44 ^ d38 ^ c28 ^ d7 ^ c8 ^ d18 ^ c14 ^ d52 ^ d13 ^ c27 ^ 
        d31 ^ d8 ^ d0;  // 42 ins 1 outs

    assign x1 = d44 ^ d37 ^ d16 ^ d1 ^ d0 ^ c27 ^ d27 ^ d11 ^ c11 ^ 
        c13 ^ d51 ^ d13 ^ c14 ^ d7 ^ d38 ^ d12 ^ d17 ^ d50 ^ c26 ^ 
        d35 ^ d24 ^ d49 ^ c0 ^ c23 ^ c25 ^ d47 ^ c29 ^ d9 ^ c9 ^ 
        d53 ^ d34 ^ c20 ^ c22 ^ d28 ^ d46 ^ c10 ^ d6 ^ c4 ^ c3 ^ 
        d33;  // 40 ins 1 outs

    assign x0 = d10 ^ d0 ^ d55 ^ c1 ^ d9 ^ d50 ^ c8 ^ c6 ^ c24 ^ 
        d44 ^ d37 ^ d16 ^ c4 ^ d6 ^ c10 ^ d28 ^ c21 ^ c20 ^ d34 ^ 
        d12 ^ c13 ^ d32 ^ c5 ^ d45 ^ c0 ^ d54 ^ d53 ^ c2 ^ c29 ^ 
        c23 ^ c30 ^ d24 ^ d48 ^ d29 ^ d47 ^ c7 ^ c26 ^ d26 ^ c31 ^ 
        d30 ^ d25 ^ d31;  // 42 ins 1 outs

    assign x31 = d49 ^ d54 ^ d52 ^ c29 ^ d31 ^ d43 ^ d24 ^ c28 ^ d23 ^ 
        d29 ^ c5 ^ c23 ^ d8 ^ c3 ^ d25 ^ c0 ^ c12 ^ c9 ^ d5 ^ 
        d28 ^ d44 ^ d15 ^ d30 ^ d46 ^ d47 ^ c4 ^ d11 ^ c1 ^ d9 ^ 
        d27 ^ c20 ^ d53 ^ c25 ^ d33 ^ c22 ^ c19 ^ d36 ^ c30 ^ c6 ^ 
        c7;  // 40 ins 1 outs

    assign x30 = d14 ^ d29 ^ d4 ^ d23 ^ c8 ^ c18 ^ d30 ^ d48 ^ d8 ^ 
        d26 ^ c22 ^ c5 ^ c0 ^ d46 ^ c11 ^ d35 ^ d52 ^ c28 ^ c6 ^ 
        d24 ^ d10 ^ d7 ^ c3 ^ d45 ^ d22 ^ d28 ^ c2 ^ c19 ^ d32 ^ 
        c4 ^ c27 ^ d43 ^ d51 ^ d53 ^ c24 ^ d42 ^ c29 ^ c21 ^ d27;  // 39 ins 1 outs

    assign x29 = d50 ^ d55 ^ c27 ^ d7 ^ c20 ^ c31 ^ d23 ^ d29 ^ c1 ^ 
        c10 ^ d6 ^ c2 ^ c17 ^ d31 ^ c23 ^ c21 ^ d13 ^ d42 ^ d9 ^ 
        d44 ^ d26 ^ d28 ^ c7 ^ c18 ^ d47 ^ d27 ^ d25 ^ d45 ^ c3 ^ 
        d3 ^ c4 ^ c5 ^ d22 ^ d34 ^ d51 ^ c26 ^ d41 ^ d52 ^ c28 ^ 
        d21;  // 40 ins 1 outs

    assign x28 = d30 ^ c27 ^ d21 ^ d12 ^ d26 ^ d22 ^ d24 ^ d2 ^ c3 ^ 
        d33 ^ c2 ^ d41 ^ d49 ^ c9 ^ c1 ^ d51 ^ c4 ^ c17 ^ d50 ^ 
        d8 ^ c26 ^ d5 ^ c6 ^ d46 ^ c25 ^ d25 ^ c0 ^ d20 ^ d28 ^ 
        d6 ^ c22 ^ d27 ^ d44 ^ c20 ^ c30 ^ d43 ^ c19 ^ c16 ^ d54 ^ 
        d40;  // 40 ins 1 outs

    assign x27 = c3 ^ c25 ^ d4 ^ d5 ^ d29 ^ d55 ^ c29 ^ c18 ^ d45 ^ 
        c31 ^ d25 ^ d49 ^ d7 ^ c15 ^ d53 ^ d42 ^ c2 ^ d24 ^ c5 ^ 
        d19 ^ d39 ^ d11 ^ d48 ^ c24 ^ c26 ^ c16 ^ d40 ^ c0 ^ d27 ^ 
        c19 ^ d1 ^ d26 ^ c21 ^ c1 ^ c8 ^ d20 ^ d32 ^ d23 ^ d21 ^ 
        d43 ^ d50;  // 41 ins 1 outs

    assign x26 = c0 ^ c23 ^ d6 ^ c20 ^ d38 ^ d19 ^ d28 ^ c15 ^ c18 ^ 
        c4 ^ d54 ^ d48 ^ c31 ^ d3 ^ c28 ^ d4 ^ c7 ^ d31 ^ d23 ^ 
        d44 ^ c2 ^ c24 ^ c1 ^ d55 ^ d0 ^ d42 ^ d22 ^ d10 ^ c14 ^ 
        d39 ^ d41 ^ d25 ^ c17 ^ d26 ^ d47 ^ d20 ^ d18 ^ d49 ^ d24 ^ 
        c25 ^ d52 ^ c30;  // 42 ins 1 outs

    assign x25 = d2 ^ c25 ^ c5 ^ d33 ^ d38 ^ d28 ^ d36 ^ d49 ^ d22 ^ 
        c20 ^ c24 ^ d3 ^ d8 ^ c14 ^ d52 ^ d31 ^ c4 ^ d21 ^ d37 ^ 
        d18 ^ d11 ^ c17 ^ c12 ^ c9 ^ c7 ^ c28 ^ d51 ^ c13 ^ c27 ^ 
        d41 ^ c16 ^ d40 ^ d17 ^ d15 ^ d19 ^ d44 ^ d29 ^ d48;  // 38 ins 1 outs

    assign x24 = c24 ^ d10 ^ d28 ^ d48 ^ c26 ^ d27 ^ c19 ^ c6 ^ d32 ^ 
        d7 ^ d51 ^ d18 ^ d21 ^ c13 ^ d30 ^ d43 ^ d35 ^ c31 ^ c8 ^ 
        c11 ^ d40 ^ d37 ^ d16 ^ c27 ^ c12 ^ c23 ^ d17 ^ d2 ^ c16 ^ 
        d55 ^ d20 ^ d1 ^ d50 ^ c15 ^ d14 ^ c3 ^ d39 ^ d36 ^ d47 ^ 
        c4;  // 40 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat56_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [55:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x696, x695, x694, x693, x692, x691, x690, 
       x689, x688, x687, x686, x685, x684, x683, x682, 
       x681, x680, x679, x678, x677, x676, x675, x674, 
       x673, x672, x671, x670, x669, x668, x667, x666, 
       x665, x664, x663, x662, x661, x660, x659, x658, 
       x657, x656, x655, x654, x653, x652, x651, x650, 
       x649, x648, x647, x646, x645, x644, x643, x642, 
       x641, x640, x639, x638, x637, x636, x635, x634, 
       x633, x632, x631, x630, x629, x628, x627, x626, 
       x625, x624, x623, x622, x621, x620, x619, x618, 
       x617, x616, x615, x614, x613, x612, x611, x610, 
       x609, x608, x607, x606, x605, x604, x603, x602, 
       x601, x600, x599, x598, x597, x596, x595, x594, 
       x593, x592, x591, x590, x589, x588, x587, x586, 
       x585, x23, x22, x21, x20, x19, x18, x17, 
       x16, x15, x14, x13, x12, x11, x10, x9, 
       x8, x7, x6, x5, x4, x3, x2, x1, 
       x0, x31, x30, x29, x28, x27, x26, x25, 
       x24;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55;

assign { d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [55:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x696i (.out(x696),.a(d37),.b(x660),.c(c20),.d(d3),.e(c13),.f(1'b0));  // 5 ins 1 outs

    xor6 x695i (.out(x695),.a(x603),.b(x587),.c(c26),.d(d49),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x694i (.out(x694),.a(x590),.b(d28),.c(c29),.d(d31),.e(d47),.f(1'b0));  // 5 ins 1 outs

    xor6 x693i (.out(x693),.a(x585),.b(c11),.c(d35),.d(d5),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x692i (.out(x692),.a(x590),.b(c23),.c(d47),.d(d13),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x691i (.out(x691),.a(c23),.b(d27),.c(d9),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x690i (.out(x690),.a(x598),.b(c6),.c(c23),.d(c17),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x689i (.out(x689),.a(x617),.b(d43),.c(d13),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x688i (.out(x688),.a(c27),.b(d51),.c(d12),.d(d4),.e(x634),.f(1'b0));  // 5 ins 1 outs

    xor6 x687i (.out(x687),.a(d55),.b(c31),.c(d24),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x686i (.out(x686),.a(d7),.b(d3),.c(d24),.d(x667),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x685i (.out(x685),.a(x587),.b(c26),.c(c18),.d(d20),.e(d50),.f(1'b0));  // 5 ins 1 outs

    xor6 x684i (.out(x684),.a(d19),.b(c5),.c(c23),.d(d46),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x683i (.out(x683),.a(x636),.b(d14),.c(d5),.d(d9),.e(d25),.f(1'b0));  // 5 ins 1 outs

    xor6 x682i (.out(x682),.a(x589),.b(x631),.c(d0),.d(d7),.e(c24),.f(1'b0));  // 5 ins 1 outs

    xor6 x681i (.out(x681),.a(x585),.b(d28),.c(d17),.d(d11),.e(d44),.f(1'b0));  // 5 ins 1 outs

    xor6 x680i (.out(x680),.a(d2),.b(x594),.c(c15),.d(c2),.e(d46),.f(1'b0));  // 5 ins 1 outs

    xor6 x679i (.out(x679),.a(d14),.b(d26),.c(d12),.d(x592),.e(d28),.f(x603));  // 6 ins 1 outs

    xor6 x678i (.out(x678),.a(d46),.b(d33),.c(c18),.d(d42),.e(d10),.f(x600));  // 6 ins 1 outs

    xor6 x677i (.out(x677),.a(x593),.b(c29),.c(d53),.d(c15),.e(d11),.f(d6));  // 6 ins 1 outs

    xor6 x676i (.out(x676),.a(x614),.b(x594),.c(d21),.d(c31),.e(d11),.f(c15));  // 6 ins 1 outs

    xor6 x675i (.out(x675),.a(d21),.b(d23),.c(d12),.d(x586),.e(x585),.f(1'b0));  // 5 ins 1 outs

    xor6 x674i (.out(x674),.a(d34),.b(x603),.c(d7),.d(d20),.e(c10),.f(x598));  // 6 ins 1 outs

    xor6 x673i (.out(x673),.a(d22),.b(d7),.c(c19),.d(x598),.e(d14),.f(d5));  // 6 ins 1 outs

    xor6 x672i (.out(x672),.a(x595),.b(x601),.c(c10),.d(x588),.e(d23),.f(c22));  // 6 ins 1 outs

    xor6 x671i (.out(x671),.a(x597),.b(c31),.c(d15),.d(c4),.e(x613),.f(c22));  // 6 ins 1 outs

    xor6 x670i (.out(x670),.a(d39),.b(d35),.c(c11),.d(c25),.e(c20),.f(x613));  // 6 ins 1 outs

    xor6 x669i (.out(x669),.a(d22),.b(x598),.c(c2),.d(d20),.e(d43),.f(d41));  // 6 ins 1 outs

    xor6 x668i (.out(x668),.a(d42),.b(d10),.c(x614),.d(d32),.e(c8),.f(x587));  // 6 ins 1 outs

    xor6 x667i (.out(x667),.a(c17),.b(d17),.c(d22),.d(d19),.e(d43),.f(1'b0));  // 5 ins 1 outs

    xor6 x666i (.out(x666),.a(d20),.b(d47),.c(x640),.d(d40),.e(x617),.f(x597));  // 6 ins 1 outs

    xor6 x665i (.out(x665),.a(x594),.b(d17),.c(x591),.d(x601),.e(d3),.f(c3));  // 6 ins 1 outs

    xor6 x664i (.out(x664),.a(c5),.b(x595),.c(d29),.d(c20),.e(d2),.f(d41));  // 6 ins 1 outs

    xor6 x663i (.out(x663),.a(x588),.b(c9),.c(x631),.d(x595),.e(d26),.f(d5));  // 6 ins 1 outs

    xor6 x662i (.out(x662),.a(c24),.b(c9),.c(d7),.d(d5),.e(x588),.f(x585));  // 6 ins 1 outs

    xor6 x661i (.out(x661),.a(d38),.b(x616),.c(d3),.d(x607),.e(d24),.f(d22));  // 6 ins 1 outs

    xor6 x660i (.out(x660),.a(d26),.b(c7),.c(d31),.d(c4),.e(d17),.f(c15));  // 6 ins 1 outs

    xor6 x659i (.out(x659),.a(d4),.b(c25),.c(c0),.d(d0),.e(d50),.f(x622));  // 6 ins 1 outs

    xor6 x658i (.out(x658),.a(c9),.b(d21),.c(d9),.d(d10),.e(x612),.f(1'b0));  // 5 ins 1 outs

    xor6 x657i (.out(x657),.a(x592),.b(d30),.c(c9),.d(c24),.e(d24),.f(1'b0));  // 5 ins 1 outs

    xor6 x656i (.out(x656),.a(d46),.b(d11),.c(d13),.d(x604),.e(d41),.f(1'b0));  // 5 ins 1 outs

    xor6 x655i (.out(x655),.a(x604),.b(c20),.c(d8),.d(d29),.e(d24),.f(1'b0));  // 5 ins 1 outs

    xor6 x654i (.out(x654),.a(c1),.b(c7),.c(x622),.d(c3),.e(d25),.f(1'b0));  // 5 ins 1 outs

    xor6 x653i (.out(x653),.a(d21),.b(x597),.c(x614),.d(d18),.e(c10),.f(1'b0));  // 5 ins 1 outs

    xor6 x652i (.out(x652),.a(x597),.b(c25),.c(c1),.d(d0),.e(d3),.f(1'b0));  // 5 ins 1 outs

    xor6 x651i (.out(x651),.a(d10),.b(x604),.c(d53),.d(x616),.e(x603),.f(1'b0));  // 5 ins 1 outs

    xor6 x650i (.out(x650),.a(x597),.b(x592),.c(x612),.d(c21),.e(d45),.f(1'b0));  // 5 ins 1 outs

    xor6 x649i (.out(x649),.a(x586),.b(d47),.c(x607),.d(x592),.e(x585),.f(1'b0));  // 5 ins 1 outs

    xor6 x648i (.out(x648),.a(c12),.b(d24),.c(x588),.d(d36),.e(x587),.f(c19));  // 6 ins 1 outs

    xor6 x647i (.out(x647),.a(d9),.b(c17),.c(x585),.d(d2),.e(c0),.f(1'b0));  // 5 ins 2 outs

    xor6 x646i (.out(x646),.a(d9),.b(c17),.c(x622),.d(d18),.e(x586),.f(d48));  // 6 ins 1 outs

    xor6 x645i (.out(x645),.a(x589),.b(x587),.c(d39),.d(d19),.e(d45),.f(c21));  // 6 ins 1 outs

    xor6 x644i (.out(x644),.a(d42),.b(x590),.c(d4),.d(d48),.e(d39),.f(d55));  // 6 ins 1 outs

    xor6 x643i (.out(x643),.a(c0),.b(d8),.c(d22),.d(x588),.e(d16),.f(d7));  // 6 ins 2 outs

    xor6 x642i (.out(x642),.a(c4),.b(d38),.c(x592),.d(d55),.e(c14),.f(d47));  // 6 ins 1 outs

    xor6 x641i (.out(x641),.a(d44),.b(c31),.c(d49),.d(x612),.e(d20),.f(d17));  // 6 ins 1 outs

    xor6 x640i (.out(x640),.a(c12),.b(d36),.c(c16),.d(c19),.e(d43),.f(d28));  // 6 ins 1 outs

    xor6 x639i (.out(x639),.a(x586),.b(d18),.c(d41),.d(x593),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x638i (.out(x638),.a(d53),.b(d28),.c(x603),.d(d15),.e(c0),.f(x590));  // 6 ins 2 outs

    xor6 x637i (.out(x637),.a(x597),.b(c4),.c(d37),.d(c13),.e(c17),.f(c22));  // 6 ins 1 outs

    xor6 x636i (.out(x636),.a(d20),.b(d4),.c(c15),.d(d18),.e(d3),.f(1'b0));  // 5 ins 2 outs

    xor6 x635i (.out(x635),.a(c22),.b(d28),.c(x590),.d(x607),.e(d10),.f(d1));  // 6 ins 2 outs

    xor6 x634i (.out(x634),.a(c9),.b(d35),.c(c11),.d(d21),.e(d33),.f(1'b0));  // 5 ins 1 outs

    xor6 x633i (.out(x633),.a(x622),.b(d33),.c(x601),.d(c8),.e(c2),.f(d32));  // 6 ins 2 outs

    xor6 x632i (.out(x632),.a(d16),.b(c1),.c(d19),.d(d25),.e(d53),.f(x594));  // 6 ins 2 outs

    xor6 x631i (.out(x631),.a(d2),.b(d35),.c(c11),.d(c15),.e(d23),.f(d14));  // 6 ins 2 outs

    xor6 x630i (.out(x630),.a(d41),.b(c24),.c(d18),.d(d13),.e(x588),.f(d48));  // 6 ins 2 outs

    xor6 x629i (.out(x629),.a(d1),.b(x603),.c(d40),.d(c16),.e(c3),.f(d27));  // 6 ins 3 outs

    xor6 x628i (.out(x628),.a(c21),.b(d32),.c(c8),.d(x607),.e(d10),.f(d45));  // 6 ins 2 outs

    xor6 x627i (.out(x627),.a(d11),.b(d44),.c(x586),.d(c17),.e(d30),.f(c6));  // 6 ins 2 outs

    xor6 x626i (.out(x626),.a(d1),.b(d22),.c(c21),.d(x588),.e(d33),.f(d45));  // 6 ins 2 outs

    xor6 x625i (.out(x625),.a(d28),.b(d19),.c(d54),.d(x598),.e(c23),.f(c30));  // 6 ins 3 outs

    xor6 x624i (.out(x624),.a(d0),.b(d17),.c(x600),.d(d47),.e(c0),.f(d44));  // 6 ins 2 outs

    xor6 x623i (.out(x623),.a(d12),.b(d39),.c(c22),.d(d46),.e(x612),.f(d15));  // 6 ins 3 outs

    xor6 x622i (.out(x622),.a(d23),.b(d9),.c(c4),.d(c12),.e(d36),.f(1'b0));  // 5 ins 4 outs

    xor6 x621i (.out(x621),.a(d17),.b(d21),.c(x589),.d(d10),.e(d4),.f(x585));  // 6 ins 2 outs

    xor6 x620i (.out(x620),.a(d53),.b(d14),.c(d24),.d(x587),.e(x586),.f(x594));  // 6 ins 4 outs

    xor6 x619i (.out(x619),.a(d16),.b(d3),.c(c0),.d(d17),.e(c24),.f(x591));  // 6 ins 2 outs

    xor6 x618i (.out(x618),.a(x587),.b(d12),.c(d30),.d(c6),.e(d53),.f(d24));  // 6 ins 2 outs

    xor6 x617i (.out(x617),.a(c31),.b(d55),.c(d16),.d(c15),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x616i (.out(x616),.a(d47),.b(c5),.c(c29),.d(d29),.e(c4),.f(d26));  // 6 ins 2 outs

    xor6 x615i (.out(x615),.a(c30),.b(d24),.c(d54),.d(d10),.e(d22),.f(x595));  // 6 ins 3 outs

    xor6 x614i (.out(x614),.a(c2),.b(d7),.c(c18),.d(c21),.e(d45),.f(d46));  // 6 ins 3 outs

    xor6 x613i (.out(x613),.a(c30),.b(c31),.c(d54),.d(d42),.e(c18),.f(d1));  // 6 ins 3 outs

    xor6 x612i (.out(x612),.a(c14),.b(d38),.c(d33),.d(c20),.e(d21),.f(d11));  // 6 ins 4 outs

    xor6 x611i (.out(x611),.a(x593),.b(c9),.c(d23),.d(d52),.e(d13),.f(c28));  // 6 ins 3 outs

    xor6 x610i (.out(x610),.a(d11),.b(c24),.c(c25),.d(x591),.e(x589),.f(d49));  // 6 ins 3 outs

    xor6 x609i (.out(x609),.a(d48),.b(d39),.c(d16),.d(x587),.e(d26),.f(x600));  // 6 ins 4 outs

    xor6 x608i (.out(x608),.a(d43),.b(x591),.c(c22),.d(c23),.e(c20),.f(c19));  // 6 ins 3 outs

    xor6 x607i (.out(x607),.a(d16),.b(d37),.c(c13),.d(c29),.e(d7),.f(1'b0));  // 5 ins 4 outs

    xor6 x606i (.out(x606),.a(d12),.b(d52),.c(x590),.d(c29),.e(c28),.f(d17));  // 6 ins 4 outs

    xor6 x605i (.out(x605),.a(x585),.b(d43),.c(d6),.d(d4),.e(d20),.f(c17));  // 6 ins 5 outs

    xor6 x604i (.out(x604),.a(c22),.b(d34),.c(d21),.d(c10),.e(c2),.f(d5));  // 6 ins 4 outs

    xor6 x603i (.out(x603),.a(c24),.b(c0),.c(d26),.d(c1),.e(d25),.f(d20));  // 6 ins 6 outs

    xor6 x602i (.out(x602),.a(x589),.b(d48),.c(c27),.d(d26),.e(d22),.f(d51));  // 6 ins 6 outs

    xor6 x601i (.out(x601),.a(d40),.b(c28),.c(c16),.d(d31),.e(c7),.f(d52));  // 6 ins 3 outs

    xor6 x600i (.out(x600),.a(c10),.b(d13),.c(d34),.d(c3),.e(d27),.f(d12));  // 6 ins 3 outs

    xor6 x599i (.out(x599),.a(d18),.b(d39),.c(d1),.d(x593),.e(d2),.f(d14));  // 6 ins 5 outs

    xor6 x598i (.out(x598),.a(d44),.b(d40),.c(d2),.d(c16),.e(c0),.f(d21));  // 6 ins 5 outs

    xor6 x597i (.out(x597),.a(d27),.b(d30),.c(d4),.d(c6),.e(c24),.f(c3));  // 6 ins 8 outs

    xor6 x596i (.out(x596),.a(d19),.b(c26),.c(x588),.d(c5),.e(d50),.f(d29));  // 6 ins 7 outs

    xor6 x595i (.out(x595),.a(d42),.b(d3),.c(d0),.d(d39),.e(d28),.f(c18));  // 6 ins 5 outs

    xor6 x594i (.out(x594),.a(c8),.b(d43),.c(c19),.d(d32),.e(c29),.f(d23));  // 6 ins 5 outs

    xor6 x593i (.out(x593),.a(c23),.b(c14),.c(d38),.d(c12),.e(d36),.f(c15));  // 6 ins 6 outs

    xor6 x592i (.out(x592),.a(d8),.b(d41),.c(c21),.d(c1),.e(d45),.f(d25));  // 6 ins 6 outs

    xor6 x591i (.out(x591),.a(c30),.b(d54),.c(d33),.d(d15),.e(c9),.f(d8));  // 6 ins 4 outs

    xor6 x590i (.out(x590),.a(d46),.b(d53),.c(d49),.d(d5),.e(c25),.f(d24));  // 6 ins 6 outs

    xor6 x589i (.out(x589),.a(d37),.b(c13),.c(d35),.d(c11),.e(c8),.f(d32));  // 6 ins 5 outs

    xor6 x588i (.out(x588),.a(d31),.b(d48),.c(d0),.d(c7),.e(d47),.f(d6));  // 6 ins 9 outs

    xor6 x587i (.out(x587),.a(d55),.b(c31),.c(d9),.d(c20),.e(d44),.f(c2));  // 6 ins 8 outs

    xor6 x586i (.out(x586),.a(c28),.b(d52),.c(c5),.d(c17),.e(d29),.f(c0));  // 6 ins 6 outs

    xor6 x585i (.out(x585),.a(c27),.b(c23),.c(c26),.d(d51),.e(d50),.f(c4));  // 6 ins 9 outs

    xor6 x23i (.out(x23),.a(x641),.b(x593),.c(x623),.d(x609),.e(x670),.f(x596));  // 6 ins 1 outs

    xor6 x22i (.out(x22),.a(x645),.b(x609),.c(x620),.d(x630),.e(x677),.f(1'b0));  // 5 ins 1 outs

    xor6 x21i (.out(x21),.a(x646),.b(x633),.c(x602),.d(x606),.e(x678),.f(1'b0));  // 5 ins 1 outs

    xor6 x20i (.out(x20),.a(x650),.b(c17),.c(x681),.d(x611),.e(x609),.f(1'b0));  // 5 ins 1 outs

    xor6 x19i (.out(x19),.a(x661),.b(d1),.c(c14),.d(x629),.e(x585),.f(x610));  // 6 ins 1 outs

    xor6 x18i (.out(x18),.a(d39),.b(x651),.c(x638),.d(x682),.e(x596),.f(1'b0));  // 5 ins 1 outs

    xor6 x17i (.out(x17),.a(d49),.b(x652),.c(x683),.d(x626),.e(x611),.f(1'b0));  // 5 ins 1 outs

    xor6 x16i (.out(x16),.a(x655),.b(x684),.c(x597),.d(x602),.e(x624),.f(1'b0));  // 5 ins 1 outs

    xor6 x15i (.out(x15),.a(x653),.b(d34),.c(x685),.d(x606),.e(x619),.f(1'b0));  // 5 ins 1 outs

    xor6 x14i (.out(x14),.a(x686),.b(x620),.c(x647),.d(x610),.e(x605),.f(x602));  // 6 ins 1 outs

    xor6 x13i (.out(x13),.a(x662),.b(x611),.c(x687),.d(x599),.e(x615),.f(x632));  // 6 ins 1 outs

    xor6 x12i (.out(x12),.a(d21),.b(x671),.c(x647),.d(x630),.e(x606),.f(1'b0));  // 5 ins 1 outs

    xor6 x11i (.out(x11),.a(x648),.b(x629),.c(x679),.d(x619),.e(x605),.f(1'b0));  // 5 ins 1 outs

    xor6 x10i (.out(x10),.a(x663),.b(c15),.c(x617),.d(d13),.e(x596),.f(x633));  // 6 ins 1 outs

    xor6 x9i (.out(x9),.a(x656),.b(d47),.c(x688),.d(x599),.e(x620),.f(1'b0));  // 5 ins 1 outs

    xor6 x8i (.out(x8),.a(d34),.b(x672),.c(x608),.d(x623),.e(x626),.f(x621));  // 6 ins 1 outs

    xor6 x7i (.out(x7),.a(d15),.b(x649),.c(x680),.d(x604),.e(x615),.f(1'b0));  // 5 ins 1 outs

    xor6 x6i (.out(x6),.a(x642),.b(x613),.c(x627),.d(x673),.e(x605),.f(1'b0));  // 5 ins 1 outs

    xor6 x5i (.out(x5),.a(x664),.b(x689),.c(x605),.d(x625),.e(x635),.f(1'b0));  // 5 ins 1 outs

    xor6 x4i (.out(x4),.a(x657),.b(x690),.c(x636),.d(x596),.e(x623),.f(1'b0));  // 5 ins 1 outs

    xor6 x3i (.out(x3),.a(x632),.b(x665),.c(x691),.d(x599),.e(x628),.f(1'b0));  // 5 ins 1 outs

    xor6 x2i (.out(x2),.a(x692),.b(x606),.c(x643),.d(x618),.e(x602),.f(x599));  // 6 ins 1 outs

    xor6 x1i (.out(x1),.a(d6),.b(x658),.c(x693),.d(x635),.e(x624),.f(1'b0));  // 5 ins 1 outs

    xor6 x0i (.out(x0),.a(c4),.b(x674),.c(x625),.d(x596),.e(x618),.f(x628));  // 6 ins 1 outs

    xor6 x31i (.out(x31),.a(x654),.b(d27),.c(x694),.d(x627),.e(x608),.f(1'b0));  // 5 ins 1 outs

    xor6 x30i (.out(x30),.a(d28),.b(d8),.c(x637),.d(x602),.e(x620),.f(x668));  // 6 ins 1 outs

    xor6 x29i (.out(x29),.a(x675),.b(x592),.c(x595),.d(x609),.e(x643),.f(1'b0));  // 5 ins 1 outs

    xor6 x28i (.out(x28),.a(d12),.b(x669),.c(x605),.d(x608),.e(x597),.f(x638));  // 6 ins 1 outs

    xor6 x27i (.out(x27),.a(x644),.b(x588),.c(x596),.d(x629),.e(x676),.f(1'b0));  // 5 ins 1 outs

    xor6 x26i (.out(x26),.a(x659),.b(x596),.c(x639),.d(x695),.e(x615),.f(1'b0));  // 5 ins 1 outs

    xor6 x25i (.out(x25),.a(x696),.b(x639),.c(x610),.d(x625),.e(x602),.f(1'b0));  // 5 ins 1 outs

    xor6 x24i (.out(x24),.a(d48),.b(d7),.c(x666),.d(x599),.e(x593),.f(x621));  // 6 ins 1 outs

endmodule

