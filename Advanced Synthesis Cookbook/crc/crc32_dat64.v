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

//// CRC-32 of 64 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 0000000000111111111122222222223333333333444444444455555555556666
//        01234567890123456789012345678901 0123456789012345678901234567890123456789012345678901234567890123
//
// C00  = X.X..X......XX.XX.X..XXX..X.XX.X X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X
// C01  = .XXX.XX.....X.XX.XXX.X..X.XXX.XX XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..X.XXX.XX
// C02  = X..XXXXX....X......XXX.X.XXX.... XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....
// C03  = XX..XXXXX....X......XXX.X.XXX... .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX...
// C04  = .X....XXXX..XXXXX.X......XXX...X X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X......XXX...X
// C05  = .....X.XXXX.X.X..XXX.XXX...X.X.X XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.X
// C06  = ......X.XXXX.X.X..XXX.XXX...X.X. .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.
// C07  = X.X..X.X.XXX.XXX..XXX.X.XXX.X... X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.XXX.X...
// C08  = XXXX.XX.X.XX.XX...XXX.X..X.XX..X XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X
// C09  = XXXXX.XX.X.XX.XX...XXX.X..X.XX.. .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..
// C10  = XX.XX..XX.X.......X.X..XX.XXX.XX X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..XX.XXX.XX
// C11  = .X..X...XX.XXX.XX.XX..XXXXXX.... XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XXXXXX....
// C12  = .........XX...XX.XXXXXX.XX.X.X.X XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X
// C13  = X.........XX...XX.XXXXXX.XX.X.X. .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.
// C14  = XX.........XX...XX.XXXXXX.XX.X.X ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X
// C15  = .XX.........XX...XX.XXXXXX.XX.X. ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.
// C16  = X..X.X......X.XXX..X....XX...... X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX......
// C17  = .X..X.X......X.XXX..X....XX..... .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX.....
// C18  = X.X..X.X......X.XXX..X....XX.... ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX....
// C19  = XX.X..X.X......X.XXX..X....XX... ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX...
// C20  = .XX.X..X.X......X.XXX..X....XX.. ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX..
// C21  = ..XX.X..X.X......X.XXX..X....XX. .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX.
// C22  = ..XXXXX..X.XXX.XX...X..X.XX.XXX. X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X.XX.XXX.
// C23  = ..XXX.XX..X...XX.XX...XXX..XX.X. XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X.
// C24  = X..XXX.XX..X...XX.XX...XXX..XX.X .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X
// C25  = .X..XXX.XX..X...XX.XX...XXX..XX. ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.
// C26  = ......XX.XX.X..XXX..X.XX.X.XXXX. X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX.
// C27  = X......XX.XX.X..XXX..X.XX.X.XXXX .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX
// C28  = .X......XX.XX.X..XXX..X.XX.X.XXX ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXX
// C29  = ..X......XX.XX.X..XXX..X.XX.X.XX ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XX
// C30  = X..X......XX.XX.X..XXX..X.XX.X.X ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.X
// C31  = .X..X......XX.XX.X..XXX..X.XX.X. .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.
//
module crc32_dat64 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [63:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat64_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat64_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat64_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [63:0] dat_in;
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
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63;

assign { d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [63:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x31 = c1 ^ d33 ^ d53 ^ d5 ^ c11 ^ d52 ^ d25 ^ c25 ^ d11 ^ 
        d57 ^ c17 ^ d46 ^ d62 ^ c27 ^ c12 ^ d15 ^ d28 ^ d44 ^ d47 ^ 
        d59 ^ c21 ^ d24 ^ d36 ^ d8 ^ d27 ^ c30 ^ c20 ^ c22 ^ d31 ^ 
        c4 ^ c14 ^ c15 ^ d30 ^ d9 ^ d49 ^ d23 ^ d60 ^ c28 ^ d29 ^ 
        d54 ^ d43;  // 41 ins 1 outs

    assign x30 = c24 ^ d23 ^ c21 ^ d61 ^ d51 ^ d59 ^ c26 ^ d27 ^ d24 ^ 
        c0 ^ d63 ^ d28 ^ d22 ^ d14 ^ c29 ^ d58 ^ d26 ^ d35 ^ d4 ^ 
        d52 ^ c31 ^ c20 ^ c19 ^ d7 ^ c10 ^ c13 ^ c11 ^ d46 ^ d53 ^ 
        c27 ^ d43 ^ c14 ^ d8 ^ c16 ^ d48 ^ d30 ^ d45 ^ d29 ^ d56 ^ 
        d32 ^ d10 ^ c3 ^ d42;  // 43 ins 1 outs

    assign x29 = d13 ^ d63 ^ d42 ^ c20 ^ d31 ^ d25 ^ c19 ^ d41 ^ d50 ^ 
        c23 ^ d60 ^ d9 ^ c26 ^ d6 ^ d26 ^ c18 ^ d27 ^ d28 ^ d34 ^ 
        d3 ^ d57 ^ c12 ^ c9 ^ c10 ^ d45 ^ d7 ^ d62 ^ d29 ^ d52 ^ 
        c28 ^ c13 ^ d51 ^ d23 ^ d21 ^ d47 ^ c15 ^ c25 ^ d55 ^ c31 ^ 
        c2 ^ d58 ^ d44 ^ c30 ^ d22;  // 44 ins 1 outs

    assign x28 = c24 ^ d12 ^ d21 ^ c29 ^ d59 ^ d62 ^ d49 ^ c22 ^ d44 ^ 
        d41 ^ c18 ^ c27 ^ d6 ^ c19 ^ c1 ^ d24 ^ d63 ^ c25 ^ d5 ^ 
        c30 ^ d8 ^ d2 ^ d46 ^ d50 ^ c12 ^ d40 ^ d27 ^ d56 ^ c31 ^ 
        d30 ^ c14 ^ d54 ^ d33 ^ d51 ^ d61 ^ d25 ^ c17 ^ c8 ^ c9 ^ 
        d28 ^ d26 ^ d22 ^ d20 ^ d57 ^ c11 ^ d43;  // 46 ins 1 outs

    assign x27 = c29 ^ d49 ^ c18 ^ d29 ^ c8 ^ c23 ^ c10 ^ d40 ^ d19 ^ 
        c21 ^ d32 ^ d63 ^ d45 ^ c13 ^ d24 ^ d43 ^ c30 ^ d53 ^ d58 ^ 
        d62 ^ d42 ^ d5 ^ d61 ^ c26 ^ d23 ^ c24 ^ c11 ^ d7 ^ c31 ^ 
        d60 ^ d11 ^ c0 ^ c28 ^ d20 ^ d26 ^ d55 ^ d1 ^ c16 ^ c17 ^ 
        d48 ^ d39 ^ d21 ^ d4 ^ d50 ^ d25 ^ d27 ^ d56 ^ c7;  // 48 ins 1 outs

    assign x26 = d47 ^ c28 ^ d0 ^ d28 ^ d31 ^ d62 ^ d57 ^ d19 ^ d42 ^ 
        c29 ^ d3 ^ c10 ^ d39 ^ d18 ^ d23 ^ d60 ^ d24 ^ d61 ^ c17 ^ 
        c7 ^ c22 ^ d26 ^ d48 ^ c12 ^ c23 ^ c25 ^ d25 ^ d22 ^ d41 ^ 
        d10 ^ d49 ^ c16 ^ c9 ^ c15 ^ d44 ^ d55 ^ d4 ^ d52 ^ c20 ^ 
        d38 ^ c27 ^ d20 ^ d54 ^ d59 ^ c6 ^ c30 ^ d6;  // 47 ins 1 outs

    assign x25 = d58 ^ d51 ^ c20 ^ d48 ^ d19 ^ d28 ^ d49 ^ d36 ^ d21 ^ 
        d15 ^ d3 ^ d44 ^ d57 ^ c19 ^ c4 ^ c25 ^ c8 ^ c30 ^ d22 ^ 
        d11 ^ c12 ^ d37 ^ d31 ^ d17 ^ c26 ^ c9 ^ d8 ^ d62 ^ d52 ^ 
        c6 ^ d41 ^ c29 ^ d38 ^ c24 ^ d40 ^ c16 ^ d56 ^ c1 ^ d29 ^ 
        d18 ^ d61 ^ d2 ^ d33 ^ c17 ^ c5;  // 45 ins 1 outs

    assign x24 = c19 ^ d10 ^ d30 ^ d60 ^ d57 ^ d7 ^ d17 ^ d28 ^ c5 ^ 
        c11 ^ d32 ^ d14 ^ d36 ^ c23 ^ c7 ^ d61 ^ c0 ^ d50 ^ c24 ^ 
        d63 ^ d18 ^ d55 ^ c15 ^ c18 ^ d40 ^ d37 ^ c4 ^ c3 ^ c31 ^ 
        d2 ^ d1 ^ c16 ^ c8 ^ d43 ^ c29 ^ c28 ^ d48 ^ d21 ^ d27 ^ 
        c25 ^ d16 ^ d56 ^ d20 ^ d39 ^ d35 ^ d51 ^ d47;  // 47 ins 1 outs

    assign x23 = d16 ^ d6 ^ d54 ^ d56 ^ d27 ^ d9 ^ d42 ^ d46 ^ c3 ^ 
        d0 ^ d39 ^ d38 ^ d20 ^ d35 ^ d50 ^ d31 ^ d15 ^ c18 ^ c22 ^ 
        d59 ^ c15 ^ d47 ^ d17 ^ c30 ^ c7 ^ d55 ^ c23 ^ c6 ^ d34 ^ 
        d36 ^ c4 ^ d19 ^ c17 ^ d62 ^ c2 ^ d26 ^ d29 ^ c24 ^ c14 ^ 
        d60 ^ d13 ^ c27 ^ c28 ^ c10 ^ d49 ^ d1;  // 46 ins 1 outs

    assign x22 = d55 ^ d44 ^ d47 ^ c4 ^ c15 ^ c28 ^ c3 ^ d41 ^ d9 ^ 
        d52 ^ c16 ^ c30 ^ c2 ^ d38 ^ c29 ^ d57 ^ d16 ^ d62 ^ c20 ^ 
        d37 ^ c11 ^ c6 ^ c25 ^ d58 ^ d43 ^ d60 ^ d14 ^ d23 ^ d11 ^ 
        d26 ^ d35 ^ c26 ^ d19 ^ d18 ^ d0 ^ c9 ^ d61 ^ d29 ^ c13 ^ 
        d36 ^ d34 ^ d27 ^ d48 ^ d45 ^ d24 ^ c12 ^ c23 ^ d12 ^ d31 ^ 
        c5;  // 50 ins 1 outs

    assign x21 = d29 ^ d27 ^ c21 ^ c20 ^ d17 ^ d61 ^ d31 ^ c10 ^ d9 ^ 
        d56 ^ d52 ^ d10 ^ d22 ^ d37 ^ d62 ^ d35 ^ c2 ^ c5 ^ d42 ^ 
        d5 ^ d53 ^ d51 ^ d26 ^ c3 ^ c19 ^ c24 ^ c17 ^ c8 ^ d34 ^ 
        d40 ^ d49 ^ d13 ^ c30 ^ c29 ^ d24 ^ d18;  // 36 ins 1 outs

    assign x20 = d28 ^ d48 ^ c29 ^ d33 ^ d21 ^ d34 ^ d16 ^ d36 ^ d23 ^ 
        d4 ^ d30 ^ c9 ^ d52 ^ c4 ^ d41 ^ c20 ^ d51 ^ c2 ^ c1 ^ 
        c19 ^ c16 ^ d17 ^ d60 ^ d8 ^ d12 ^ d26 ^ d50 ^ d61 ^ c28 ^ 
        c7 ^ d25 ^ d9 ^ d39 ^ d55 ^ c18 ^ c23;  // 36 ins 1 outs

    assign x19 = d27 ^ d59 ^ d20 ^ c0 ^ c6 ^ c28 ^ c22 ^ d60 ^ c18 ^ 
        d35 ^ d50 ^ c19 ^ d33 ^ d15 ^ d25 ^ d38 ^ d7 ^ c1 ^ d40 ^ 
        c8 ^ d49 ^ d54 ^ c3 ^ c15 ^ d32 ^ c27 ^ d3 ^ d11 ^ d24 ^ 
        d29 ^ d47 ^ d51 ^ c17 ^ d16 ^ d22 ^ d8;  // 36 ins 1 outs

    assign x18 = c7 ^ d39 ^ c2 ^ c21 ^ d59 ^ d19 ^ d31 ^ d50 ^ d23 ^ 
        d24 ^ c18 ^ d58 ^ d14 ^ c0 ^ c5 ^ d2 ^ c26 ^ d10 ^ d7 ^ 
        d48 ^ c14 ^ c27 ^ d49 ^ d15 ^ d53 ^ c17 ^ d32 ^ d46 ^ d34 ^ 
        d28 ^ d26 ^ d21 ^ d6 ^ d37 ^ c16;  // 35 ins 1 outs

    assign x17 = c17 ^ c1 ^ d36 ^ d45 ^ d38 ^ d14 ^ c25 ^ d13 ^ d52 ^ 
        c6 ^ c13 ^ d31 ^ d33 ^ c15 ^ d30 ^ d49 ^ c4 ^ d1 ^ d23 ^ 
        d47 ^ c16 ^ d48 ^ c26 ^ d25 ^ d5 ^ d27 ^ d58 ^ d22 ^ d6 ^ 
        d20 ^ d18 ^ d9 ^ d57 ^ c20;  // 34 ins 1 outs

    assign x16 = d48 ^ d24 ^ c16 ^ d0 ^ d8 ^ d32 ^ d30 ^ d26 ^ d29 ^ 
        c12 ^ d37 ^ d51 ^ d12 ^ c15 ^ c24 ^ c5 ^ d47 ^ d44 ^ c3 ^ 
        d57 ^ c19 ^ c0 ^ d56 ^ d13 ^ d5 ^ d35 ^ c25 ^ d4 ^ c14 ^ 
        d22 ^ d21 ^ d17 ^ d46 ^ d19;  // 34 ins 1 outs

    assign x15 = d12 ^ d9 ^ d62 ^ d34 ^ c21 ^ d59 ^ d45 ^ d24 ^ c22 ^ 
        d56 ^ c17 ^ c24 ^ c18 ^ c12 ^ d30 ^ d27 ^ d5 ^ d60 ^ d44 ^ 
        c1 ^ d33 ^ d3 ^ d55 ^ c23 ^ d54 ^ c28 ^ d8 ^ d53 ^ c27 ^ 
        d50 ^ d57 ^ d21 ^ d20 ^ d18 ^ c25 ^ d49 ^ d7 ^ d16 ^ c2 ^ 
        d15 ^ d4 ^ d52 ^ c13 ^ c20 ^ c30;  // 45 ins 1 outs

    assign x14 = c20 ^ d14 ^ d54 ^ d52 ^ d2 ^ c29 ^ d56 ^ d26 ^ d32 ^ 
        c26 ^ c27 ^ c19 ^ c24 ^ d17 ^ d7 ^ d20 ^ d15 ^ c11 ^ d49 ^ 
        c31 ^ d59 ^ c12 ^ d11 ^ c1 ^ c22 ^ d55 ^ d4 ^ d63 ^ d43 ^ 
        d8 ^ d33 ^ c17 ^ d3 ^ d53 ^ d6 ^ d61 ^ c16 ^ d19 ^ d48 ^ 
        c21 ^ d29 ^ d51 ^ d58 ^ c0 ^ c23 ^ d44 ^ d23;  // 47 ins 1 outs

    assign x13 = c19 ^ c23 ^ c22 ^ d60 ^ d57 ^ d52 ^ d28 ^ d1 ^ c15 ^ 
        d51 ^ d50 ^ d3 ^ c16 ^ d5 ^ c11 ^ c10 ^ d32 ^ d43 ^ d13 ^ 
        d14 ^ d31 ^ d54 ^ d58 ^ d7 ^ c25 ^ c26 ^ c20 ^ d48 ^ d53 ^ 
        d19 ^ c0 ^ c30 ^ d6 ^ d62 ^ d55 ^ d10 ^ c21 ^ d18 ^ d25 ^ 
        c18 ^ c28 ^ d2 ^ d42 ^ d47 ^ d22 ^ d16;  // 46 ins 1 outs

    assign x12 = d4 ^ d59 ^ d63 ^ d9 ^ c24 ^ c25 ^ c14 ^ c20 ^ d12 ^ 
        d51 ^ c21 ^ d50 ^ d47 ^ d41 ^ d57 ^ d5 ^ d31 ^ d24 ^ c31 ^ 
        d52 ^ c27 ^ d0 ^ d18 ^ c22 ^ d2 ^ c18 ^ c9 ^ c15 ^ c19 ^ 
        d17 ^ d42 ^ d46 ^ c17 ^ d13 ^ d49 ^ d1 ^ d61 ^ d27 ^ d15 ^ 
        d56 ^ d54 ^ d30 ^ d6 ^ d21 ^ c10 ^ d53 ^ c29;  // 47 ins 1 outs

    assign x11 = d15 ^ d28 ^ d58 ^ c25 ^ c18 ^ c19 ^ d14 ^ d36 ^ d40 ^ 
        d59 ^ d33 ^ c16 ^ d41 ^ d26 ^ c4 ^ c11 ^ d43 ^ d16 ^ d1 ^ 
        d47 ^ d27 ^ d50 ^ c27 ^ c9 ^ c13 ^ c24 ^ d56 ^ d54 ^ d48 ^ 
        d51 ^ c26 ^ d57 ^ c1 ^ c8 ^ d0 ^ d45 ^ d3 ^ d24 ^ c12 ^ 
        d17 ^ c23 ^ d25 ^ d9 ^ d12 ^ d31 ^ c22 ^ c15 ^ d44 ^ d4 ^ 
        d55 ^ d20;  // 51 ins 1 outs

    assign x10 = c1 ^ c24 ^ d3 ^ d52 ^ d35 ^ d36 ^ d55 ^ d31 ^ d16 ^ 
        c4 ^ d26 ^ d29 ^ d32 ^ d14 ^ c8 ^ c0 ^ c10 ^ d2 ^ d42 ^ 
        d63 ^ c23 ^ c30 ^ c7 ^ d60 ^ c26 ^ d0 ^ d28 ^ d50 ^ c31 ^ 
        d40 ^ d19 ^ d59 ^ c18 ^ c28 ^ c20 ^ d9 ^ c27 ^ d58 ^ d5 ^ 
        d62 ^ d33 ^ d13 ^ d56 ^ d39 ^ c3;  // 45 ins 1 outs

    assign x9 = d32 ^ d29 ^ c1 ^ d51 ^ c29 ^ d34 ^ d11 ^ c2 ^ d52 ^ 
        d33 ^ c23 ^ d58 ^ c28 ^ d41 ^ d60 ^ d61 ^ d23 ^ d13 ^ d24 ^ 
        d9 ^ c3 ^ c26 ^ c11 ^ d1 ^ d5 ^ d18 ^ d47 ^ d12 ^ c19 ^ 
        d2 ^ c9 ^ d43 ^ c20 ^ c12 ^ c0 ^ d44 ^ d36 ^ c15 ^ d46 ^ 
        d55 ^ c4 ^ c6 ^ c14 ^ d35 ^ c21 ^ c7 ^ d39 ^ d38 ^ d53 ^ 
        d4;  // 50 ins 1 outs

    assign x8 = d10 ^ d45 ^ c13 ^ c1 ^ d51 ^ d34 ^ c0 ^ d60 ^ d37 ^ 
        c2 ^ d33 ^ c8 ^ c5 ^ d8 ^ d57 ^ d12 ^ c31 ^ d0 ^ d54 ^ 
        d35 ^ d32 ^ d23 ^ d17 ^ d63 ^ d50 ^ d28 ^ c10 ^ c11 ^ c18 ^ 
        d42 ^ c19 ^ c27 ^ d59 ^ d11 ^ c25 ^ d31 ^ c6 ^ d40 ^ d1 ^ 
        c22 ^ d4 ^ d22 ^ d52 ^ d43 ^ c20 ^ c28 ^ d3 ^ d46 ^ d38 ^ 
        c3 ^ c14;  // 51 ins 1 outs

    assign x7 = d47 ^ c5 ^ d24 ^ d28 ^ d60 ^ c0 ^ d29 ^ c25 ^ c24 ^ 
        c20 ^ c19 ^ d22 ^ d7 ^ c13 ^ d2 ^ d54 ^ d3 ^ c11 ^ d41 ^ 
        d56 ^ d37 ^ d57 ^ d25 ^ c18 ^ c10 ^ d45 ^ d51 ^ c22 ^ d43 ^ 
        d46 ^ d23 ^ c7 ^ c2 ^ d16 ^ c9 ^ d10 ^ d15 ^ d39 ^ d42 ^ 
        d58 ^ d21 ^ d5 ^ c15 ^ c26 ^ d0 ^ d32 ^ d50 ^ d52 ^ d8 ^ 
        d34 ^ c28 ^ c14;  // 52 ins 1 outs

    assign x6 = d11 ^ d30 ^ c18 ^ c28 ^ c9 ^ d29 ^ d41 ^ c22 ^ d14 ^ 
        d54 ^ c6 ^ d8 ^ d7 ^ d55 ^ d21 ^ d51 ^ c13 ^ d6 ^ d50 ^ 
        c24 ^ d60 ^ d25 ^ d52 ^ d42 ^ d40 ^ d56 ^ c15 ^ d2 ^ d5 ^ 
        d45 ^ d1 ^ d47 ^ c23 ^ d4 ^ d20 ^ d43 ^ c11 ^ c20 ^ c19 ^ 
        d38 ^ c30 ^ c8 ^ d62 ^ c10 ^ d22;  // 45 ins 1 outs

    assign x5 = d53 ^ d10 ^ d24 ^ d50 ^ c14 ^ d59 ^ c29 ^ d51 ^ d20 ^ 
        c12 ^ c31 ^ c5 ^ d5 ^ c23 ^ d0 ^ d42 ^ d54 ^ d44 ^ c21 ^ 
        d29 ^ d41 ^ d37 ^ d4 ^ c27 ^ c17 ^ c7 ^ c19 ^ d46 ^ d13 ^ 
        c22 ^ d61 ^ d21 ^ d7 ^ d49 ^ d39 ^ d1 ^ c9 ^ d55 ^ c10 ^ 
        d19 ^ d3 ^ d6 ^ c18 ^ d63 ^ d40 ^ d28 ^ c8;  // 47 ins 1 outs

    assign x4 = c1 ^ d11 ^ d19 ^ d33 ^ d18 ^ d50 ^ d48 ^ c26 ^ c7 ^ 
        d29 ^ d58 ^ d39 ^ c31 ^ c8 ^ d6 ^ d46 ^ d0 ^ d4 ^ d40 ^ 
        c15 ^ d8 ^ d2 ^ c14 ^ d3 ^ d15 ^ c18 ^ d30 ^ c6 ^ d12 ^ 
        d25 ^ c13 ^ d31 ^ d45 ^ d59 ^ d57 ^ c9 ^ d24 ^ c25 ^ d47 ^ 
        d41 ^ c12 ^ c16 ^ d63 ^ d44 ^ d20 ^ c27 ^ d38;  // 47 ins 1 outs

    assign x3 = c22 ^ d39 ^ d38 ^ c20 ^ d14 ^ d58 ^ c1 ^ d32 ^ d3 ^ 
        d52 ^ d40 ^ d17 ^ c8 ^ d8 ^ c21 ^ d59 ^ d9 ^ c24 ^ c6 ^ 
        d45 ^ d25 ^ d27 ^ c26 ^ d31 ^ d54 ^ d19 ^ d1 ^ d36 ^ c5 ^ 
        d60 ^ d18 ^ d2 ^ d7 ^ c4 ^ d15 ^ d33 ^ c0 ^ c28 ^ d53 ^ 
        c13 ^ c27 ^ d56 ^ d37 ^ c7 ^ d10;  // 45 ins 1 outs

    assign x2 = d0 ^ d9 ^ d24 ^ d37 ^ c27 ^ c5 ^ d58 ^ d32 ^ c12 ^ 
        c25 ^ c23 ^ d57 ^ d17 ^ d31 ^ d35 ^ c21 ^ d13 ^ d59 ^ d1 ^ 
        d44 ^ d26 ^ d2 ^ d18 ^ c3 ^ d30 ^ d8 ^ d55 ^ c0 ^ d51 ^ 
        d16 ^ d52 ^ d6 ^ d39 ^ c7 ^ d7 ^ d53 ^ c6 ^ c4 ^ d36 ^ 
        c26 ^ d38 ^ c20 ^ d14 ^ c19;  // 44 ins 1 outs

    assign x1 = d44 ^ d47 ^ d12 ^ d58 ^ d0 ^ c26 ^ d16 ^ c2 ^ d53 ^ 
        d56 ^ d27 ^ d63 ^ d24 ^ d28 ^ d1 ^ d49 ^ c27 ^ d34 ^ c6 ^ 
        d59 ^ d35 ^ d33 ^ d7 ^ d6 ^ c15 ^ d13 ^ c17 ^ d17 ^ c21 ^ 
        c12 ^ d50 ^ d60 ^ c1 ^ d51 ^ c31 ^ c14 ^ c3 ^ d11 ^ c24 ^ 
        c18 ^ c28 ^ d62 ^ c30 ^ d38 ^ d46 ^ c19 ^ d9 ^ c5 ^ d37;  // 49 ins 1 outs

    assign x0 = c0 ^ d55 ^ d44 ^ d47 ^ c5 ^ c15 ^ c22 ^ d31 ^ d12 ^ 
        d58 ^ d37 ^ d9 ^ d28 ^ d63 ^ c16 ^ d10 ^ d25 ^ c23 ^ c12 ^ 
        d24 ^ d45 ^ d48 ^ c28 ^ c18 ^ c31 ^ d60 ^ c21 ^ d34 ^ c13 ^ 
        d29 ^ d26 ^ c29 ^ d30 ^ d50 ^ d32 ^ d61 ^ d0 ^ c26 ^ d16 ^ 
        c2 ^ d53 ^ d6 ^ d54;  // 43 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat64_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [63:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x767, x766, x765, x764, x763, x762, x761, 
       x760, x759, x758, x757, x756, x755, x754, x753, 
       x752, x751, x750, x749, x748, x747, x746, x745, 
       x744, x743, x742, x741, x740, x739, x738, x737, 
       x736, x735, x734, x733, x732, x731, x730, x729, 
       x728, x727, x726, x725, x724, x723, x722, x721, 
       x720, x719, x718, x717, x716, x715, x714, x713, 
       x712, x711, x710, x709, x708, x707, x706, x705, 
       x704, x703, x702, x701, x700, x699, x698, x697, 
       x696, x695, x694, x693, x692, x691, x690, x689, 
       x688, x687, x686, x685, x684, x683, x682, x681, 
       x680, x679, x678, x677, x676, x675, x674, x673, 
       x672, x671, x670, x669, x668, x667, x666, x665, 
       x664, x663, x662, x661, x660, x659, x658, x657, 
       x656, x655, x654, x653, x652, x651, x650, x649, 
       x648, x647, x646, x645, x644, x31, x30, x29, 
       x28, x27, x26, x25, x24, x23, x22, x21, 
       x20, x19, x18, x17, x16, x15, x14, x13, 
       x12, x11, x10, x9, x8, x7, x6, x5, 
       x4, x3, x2, x1, x0;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63;

assign { d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [63:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x767i (.out(x767),.a(x678),.b(d60),.c(d41),.d(c22),.e(d10),.f(1'b0));  // 5 ins 1 outs

    xor6 x766i (.out(x766),.a(x644),.b(x664),.c(d60),.d(d34),.e(d11),.f(1'b0));  // 5 ins 1 outs

    xor6 x765i (.out(x765),.a(d45),.b(d24),.c(d19),.d(d12),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x764i (.out(x764),.a(x648),.b(x660),.c(d18),.d(d40),.e(c21),.f(1'b0));  // 5 ins 1 outs

    xor6 x763i (.out(x763),.a(x659),.b(x653),.c(d5),.d(d52),.e(c14),.f(1'b0));  // 5 ins 1 outs

    xor6 x762i (.out(x762),.a(c16),.b(c28),.c(x738),.d(d26),.e(x658),.f(1'b0));  // 5 ins 1 outs

    xor6 x761i (.out(x761),.a(x746),.b(d13),.c(d56),.d(d42),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x760i (.out(x760),.a(c6),.b(d16),.c(d55),.d(d32),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x759i (.out(x759),.a(d17),.b(d2),.c(d13),.d(d11),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x758i (.out(x758),.a(c28),.b(x731),.c(d60),.d(d50),.e(c18),.f(1'b0));  // 5 ins 1 outs

    xor6 x757i (.out(x757),.a(x649),.b(d19),.c(d20),.d(d22),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x756i (.out(x756),.a(d45),.b(c15),.c(d48),.d(d27),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x755i (.out(x755),.a(x729),.b(d0),.c(x648),.d(x666),.e(x659),.f(1'b0));  // 5 ins 1 outs

    xor6 x754i (.out(x754),.a(d18),.b(d14),.c(d27),.d(d7),.e(d62),.f(1'b0));  // 5 ins 1 outs

    xor6 x753i (.out(x753),.a(x645),.b(d12),.c(d3),.d(d62),.e(d38),.f(1'b0));  // 5 ins 1 outs

    xor6 x752i (.out(x752),.a(d3),.b(d52),.c(d0),.d(x662),.e(x664),.f(d13));  // 6 ins 1 outs

    xor6 x751i (.out(x751),.a(x700),.b(c8),.c(x668),.d(d25),.e(d37),.f(c24));  // 6 ins 1 outs

    xor6 x750i (.out(x750),.a(d49),.b(c8),.c(c12),.d(d2),.e(d21),.f(1'b0));  // 5 ins 1 outs

    xor6 x749i (.out(x749),.a(c31),.b(d6),.c(d21),.d(x720),.e(x666),.f(1'b0));  // 5 ins 1 outs

    xor6 x748i (.out(x748),.a(d14),.b(x645),.c(d27),.d(x667),.e(d19),.f(1'b0));  // 5 ins 1 outs

    xor6 x747i (.out(x747),.a(d11),.b(x652),.c(x645),.d(d12),.e(x659),.f(1'b0));  // 5 ins 1 outs

    xor6 x746i (.out(x746),.a(c22),.b(c21),.c(d9),.d(d7),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x745i (.out(x745),.a(x651),.b(d44),.c(d8),.d(d47),.e(c12),.f(d22));  // 6 ins 1 outs

    xor6 x744i (.out(x744),.a(d55),.b(d39),.c(x662),.d(c10),.e(d47),.f(d29));  // 6 ins 1 outs

    xor6 x743i (.out(x743),.a(x658),.b(d5),.c(d14),.d(c6),.e(c9),.f(x656));  // 6 ins 1 outs

    xor6 x742i (.out(x742),.a(x652),.b(d10),.c(x670),.d(d34),.e(c2),.f(c14));  // 6 ins 1 outs

    xor6 x741i (.out(x741),.a(d38),.b(d0),.c(d44),.d(c12),.e(d26),.f(x649));  // 6 ins 1 outs

    xor6 x740i (.out(x740),.a(x667),.b(d8),.c(d21),.d(x647),.e(x658),.f(c30));  // 6 ins 1 outs

    xor6 x739i (.out(x739),.a(d3),.b(x650),.c(x672),.d(d15),.e(d46),.f(d28));  // 6 ins 1 outs

    xor6 x738i (.out(x738),.a(c4),.b(d9),.c(d24),.d(d14),.e(d36),.f(1'b0));  // 5 ins 1 outs

    xor6 x737i (.out(x737),.a(d50),.b(c18),.c(c17),.d(x669),.e(x691),.f(x664));  // 6 ins 1 outs

    xor6 x736i (.out(x736),.a(x647),.b(d32),.c(d25),.d(x660),.e(d5),.f(c6));  // 6 ins 1 outs

    xor6 x735i (.out(x735),.a(d13),.b(d42),.c(d10),.d(x710),.e(x666),.f(x668));  // 6 ins 1 outs

    xor6 x734i (.out(x734),.a(x667),.b(x659),.c(d30),.d(d27),.e(x654),.f(d19));  // 6 ins 1 outs

    xor6 x733i (.out(x733),.a(d33),.b(c1),.c(x664),.d(x672),.e(c9),.f(1'b0));  // 5 ins 1 outs

    xor6 x732i (.out(x732),.a(d33),.b(d6),.c(d52),.d(d15),.e(x646),.f(1'b0));  // 5 ins 1 outs

    xor6 x731i (.out(x731),.a(d34),.b(d52),.c(d20),.d(d62),.e(d12),.f(1'b0));  // 5 ins 1 outs

    xor6 x730i (.out(x730),.a(c24),.b(x694),.c(c13),.d(x660),.e(d23),.f(1'b0));  // 5 ins 1 outs

    xor6 x729i (.out(x729),.a(d38),.b(c27),.c(d59),.d(c6),.e(d49),.f(c4));  // 6 ins 1 outs

    xor6 x728i (.out(x728),.a(x665),.b(d36),.c(c5),.d(x678),.e(d10),.f(c16));  // 6 ins 1 outs

    xor6 x727i (.out(x727),.a(d30),.b(d7),.c(d3),.d(x651),.e(d53),.f(x650));  // 6 ins 2 outs

    xor6 x726i (.out(x726),.a(x655),.b(c24),.c(d63),.d(d2),.e(x662),.f(c20));  // 6 ins 1 outs

    xor6 x725i (.out(x725),.a(c16),.b(c4),.c(d53),.d(x665),.e(d2),.f(c31));  // 6 ins 1 outs

    xor6 x724i (.out(x724),.a(x665),.b(c8),.c(d16),.d(d14),.e(c30),.f(1'b0));  // 5 ins 1 outs

    xor6 x723i (.out(x723),.a(c23),.b(x669),.c(d25),.d(x644),.e(x680),.f(1'b0));  // 5 ins 1 outs

    xor6 x722i (.out(x722),.a(d24),.b(x669),.c(c4),.d(d25),.e(x672),.f(1'b0));  // 5 ins 1 outs

    xor6 x721i (.out(x721),.a(x672),.b(c21),.c(d4),.d(d53),.e(x700),.f(d20));  // 6 ins 1 outs

    xor6 x720i (.out(x720),.a(d63),.b(d31),.c(d27),.d(d3),.e(d13),.f(d10));  // 6 ins 1 outs

    xor6 x719i (.out(x719),.a(d6),.b(d21),.c(c2),.d(d8),.e(x644),.f(c28));  // 6 ins 1 outs

    xor6 x718i (.out(x718),.a(x656),.b(x668),.c(c30),.d(c17),.e(d28),.f(d48));  // 6 ins 1 outs

    xor6 x717i (.out(x717),.a(d60),.b(d52),.c(x665),.d(d53),.e(x650),.f(c6));  // 6 ins 1 outs

    xor6 x716i (.out(x716),.a(x649),.b(x648),.c(x665),.d(x655),.e(d13),.f(x675));  // 6 ins 1 outs

    xor6 x715i (.out(x715),.a(d59),.b(c27),.c(x667),.d(d27),.e(x662),.f(d18));  // 6 ins 1 outs

    xor6 x714i (.out(x714),.a(x659),.b(d17),.c(x680),.d(d5),.e(d7),.f(x653));  // 6 ins 1 outs

    xor6 x713i (.out(x713),.a(x691),.b(c23),.c(x658),.d(x653),.e(d27),.f(d42));  // 6 ins 1 outs

    xor6 x712i (.out(x712),.a(x648),.b(d1),.c(c22),.d(d22),.e(d2),.f(x688));  // 6 ins 1 outs

    xor6 x711i (.out(x711),.a(d32),.b(x681),.c(x692),.d(d46),.e(c9),.f(d8));  // 6 ins 1 outs

    xor6 x710i (.out(x710),.a(c3),.b(d35),.c(c29),.d(d61),.e(c24),.f(d38));  // 6 ins 1 outs

    xor6 x709i (.out(x709),.a(d24),.b(d8),.c(d25),.d(x654),.e(x652),.f(d60));  // 6 ins 2 outs

    xor6 x708i (.out(x708),.a(x678),.b(x694),.c(d50),.d(c18),.e(d6),.f(d29));  // 6 ins 1 outs

    xor6 x707i (.out(x707),.a(c10),.b(d23),.c(x660),.d(c4),.e(x694),.f(c25));  // 6 ins 1 outs

    xor6 x706i (.out(x706),.a(d49),.b(c2),.c(x681),.d(d24),.e(d46),.f(d34));  // 6 ins 1 outs

    xor6 x705i (.out(x705),.a(x668),.b(d15),.c(x645),.d(d33),.e(c0),.f(c1));  // 6 ins 1 outs

    xor6 x704i (.out(x704),.a(x653),.b(d39),.c(x658),.d(c13),.e(c7),.f(d41));  // 6 ins 1 outs

    xor6 x703i (.out(x703),.a(d15),.b(d56),.c(x650),.d(d57),.e(c25),.f(1'b0));  // 5 ins 1 outs

    xor6 x702i (.out(x702),.a(c17),.b(d20),.c(x644),.d(d36),.e(c24),.f(1'b0));  // 5 ins 1 outs

    xor6 x701i (.out(x701),.a(x654),.b(d37),.c(d48),.d(d17),.e(c28),.f(d28));  // 6 ins 2 outs

    xor6 x700i (.out(x700),.a(d6),.b(c8),.c(d30),.d(d26),.e(d22),.f(d40));  // 6 ins 2 outs

    xor6 x699i (.out(x699),.a(x652),.b(x662),.c(d16),.d(d62),.e(d54),.f(1'b0));  // 5 ins 2 outs

    xor6 x698i (.out(x698),.a(d5),.b(d62),.c(x659),.d(c31),.e(c6),.f(c2));  // 6 ins 2 outs

    xor6 x697i (.out(x697),.a(d26),.b(d3),.c(x650),.d(d29),.e(d31),.f(d28));  // 6 ins 2 outs

    xor6 x696i (.out(x696),.a(d6),.b(x647),.c(x667),.d(d52),.e(c24),.f(c14));  // 6 ins 2 outs

    xor6 x695i (.out(x695),.a(c26),.b(c4),.c(x650),.d(d8),.e(d58),.f(x655));  // 6 ins 2 outs

    xor6 x694i (.out(x694),.a(c28),.b(c24),.c(c10),.d(c11),.e(d43),.f(1'b0));  // 5 ins 3 outs

    xor6 x693i (.out(x693),.a(c10),.b(d12),.c(x670),.d(x656),.e(x666),.f(x646));  // 6 ins 2 outs

    xor6 x692i (.out(x692),.a(c22),.b(c0),.c(d3),.d(d58),.e(c26),.f(d5));  // 6 ins 2 outs

    xor6 x691i (.out(x691),.a(c5),.b(c14),.c(d37),.d(d28),.e(d21),.f(d13));  // 6 ins 2 outs

    xor6 x690i (.out(x690),.a(c8),.b(d31),.c(d18),.d(c21),.e(x655),.f(d9));  // 6 ins 2 outs

    xor6 x689i (.out(x689),.a(d20),.b(d23),.c(d49),.d(d4),.e(c17),.f(x645));  // 6 ins 2 outs

    xor6 x688i (.out(x688),.a(d55),.b(d30),.c(d16),.d(d21),.e(d7),.f(c23));  // 6 ins 2 outs

    xor6 x687i (.out(x687),.a(c16),.b(d34),.c(x650),.d(x653),.e(d23),.f(c4));  // 6 ins 3 outs

    xor6 x686i (.out(x686),.a(d1),.b(x646),.c(c9),.d(d57),.e(c25),.f(1'b0));  // 5 ins 2 outs

    xor6 x685i (.out(x685),.a(c20),.b(x648),.c(d29),.d(x651),.e(x678),.f(x669));  // 6 ins 2 outs

    xor6 x684i (.out(x684),.a(d35),.b(c3),.c(d20),.d(x644),.e(c8),.f(1'b0));  // 5 ins 2 outs

    xor6 x683i (.out(x683),.a(d0),.b(c1),.c(d33),.d(d12),.e(d28),.f(x645));  // 6 ins 3 outs

    xor6 x682i (.out(x682),.a(c7),.b(c10),.c(d56),.d(d24),.e(d39),.f(x646));  // 6 ins 2 outs

    xor6 x681i (.out(x681),.a(d23),.b(d15),.c(c7),.d(d39),.e(d7),.f(d10));  // 6 ins 3 outs

    xor6 x680i (.out(x680),.a(c30),.b(d43),.c(d6),.d(d2),.e(c11),.f(c21));  // 6 ins 2 outs

    xor6 x679i (.out(x679),.a(d3),.b(d15),.c(d29),.d(x649),.e(d44),.f(d11));  // 6 ins 2 outs

    xor6 x678i (.out(x678),.a(d63),.b(c31),.c(d61),.d(c29),.e(1'b0),.f(1'b0));  // 4 ins 4 outs

    xor6 x677i (.out(x677),.a(d35),.b(x649),.c(c3),.d(d14),.e(d16),.f(d36));  // 6 ins 2 outs

    xor6 x676i (.out(x676),.a(d54),.b(d15),.c(d17),.d(x648),.e(d27),.f(d31));  // 6 ins 3 outs

    xor6 x675i (.out(x675),.a(c13),.b(c2),.c(d45),.d(d36),.e(d4),.f(d18));  // 6 ins 2 outs

    xor6 x674i (.out(x674),.a(d42),.b(x654),.c(d19),.d(d6),.e(d56),.f(d1));  // 6 ins 3 outs

    xor6 x673i (.out(x673),.a(x656),.b(d48),.c(c30),.d(d6),.e(c20),.f(c10));  // 6 ins 5 outs

    xor6 x672i (.out(x672),.a(d25),.b(d47),.c(d30),.d(c14),.e(d38),.f(c15));  // 6 ins 4 outs

    xor6 x671i (.out(x671),.a(x656),.b(d19),.c(d4),.d(d12),.e(x653),.f(c15));  // 6 ins 5 outs

    xor6 x670i (.out(x670),.a(c20),.b(d0),.c(d37),.d(d24),.e(d29),.f(c5));  // 6 ins 3 outs

    xor6 x669i (.out(x669),.a(d53),.b(d14),.c(d13),.d(d19),.e(d48),.f(1'b0));  // 5 ins 4 outs

    xor6 x668i (.out(x668),.a(d62),.b(d22),.c(d52),.d(c19),.e(d51),.f(d40));  // 6 ins 4 outs

    xor6 x667i (.out(x667),.a(d23),.b(d25),.c(d58),.d(c26),.e(c13),.f(d45));  // 6 ins 5 outs

    xor6 x666i (.out(x666),.a(d26),.b(d34),.c(c2),.d(d9),.e(d29),.f(c30));  // 6 ins 4 outs

    xor6 x665i (.out(x665),.a(c4),.b(c28),.c(d32),.d(d1),.e(c0),.f(d40));  // 6 ins 5 outs

    xor6 x664i (.out(x664),.a(d2),.b(d58),.c(d6),.d(d59),.e(c27),.f(c26));  // 6 ins 5 outs

    xor6 x663i (.out(x663),.a(x645),.b(x647),.c(d44),.d(c12),.e(c30),.f(c21));  // 6 ins 5 outs

    xor6 x662i (.out(x662),.a(d1),.b(d7),.c(d51),.d(c20),.e(c10),.f(c19));  // 6 ins 5 outs

    xor6 x661i (.out(x661),.a(x648),.b(d21),.c(d30),.d(d2),.e(d57),.f(c25));  // 6 ins 5 outs

    xor6 x660i (.out(x660),.a(d62),.b(d29),.c(d38),.d(d52),.e(d60),.f(d11));  // 6 ins 5 outs

    xor6 x659i (.out(x659),.a(c10),.b(d46),.c(c14),.d(d13),.e(d35),.f(c3));  // 6 ins 6 outs

    xor6 x658i (.out(x658),.a(d4),.b(d8),.c(d20),.d(d40),.e(c8),.f(d48));  // 6 ins 5 outs

    xor6 x657i (.out(x657),.a(x644),.b(d25),.c(d45),.d(d54),.e(d41),.f(c13));  // 6 ins 5 outs

    xor6 x656i (.out(x656),.a(d19),.b(c9),.c(d41),.d(d47),.e(d61),.f(c29));  // 6 ins 5 outs

    xor6 x655i (.out(x655),.a(d9),.b(d38),.c(d56),.d(c5),.e(d37),.f(d17));  // 6 ins 4 outs

    xor6 x654i (.out(x654),.a(c23),.b(d62),.c(c7),.d(d39),.e(d60),.f(d55));  // 6 ins 4 outs

    xor6 x653i (.out(x653),.a(d0),.b(d46),.c(c31),.d(d50),.e(c18),.f(d63));  // 6 ins 6 outs

    xor6 x652i (.out(x652),.a(d22),.b(d60),.c(d42),.d(d52),.e(d28),.f(d10));  // 6 ins 4 outs

    xor6 x651i (.out(x651),.a(c16),.b(d26),.c(d32),.d(c21),.e(c0),.f(d7));  // 6 ins 5 outs

    xor6 x650i (.out(x650),.a(d9),.b(c24),.c(c1),.d(d33),.e(c20),.f(d36));  // 6 ins 8 outs

    xor6 x649i (.out(x649),.a(d31),.b(d57),.c(c25),.d(d18),.e(c6),.f(c16));  // 6 ins 6 outs

    xor6 x648i (.out(x648),.a(d51),.b(d56),.c(c11),.d(c24),.e(d43),.f(c19));  // 6 ins 7 outs

    xor6 x647i (.out(x647),.a(d27),.b(c17),.c(d49),.d(d5),.e(d24),.f(d53));  // 6 ins 5 outs

    xor6 x646i (.out(x646),.a(d44),.b(c23),.c(c26),.d(c12),.e(d55),.f(d58));  // 6 ins 4 outs

    xor6 x645i (.out(x645),.a(d59),.b(c27),.c(d54),.d(c22),.e(d8),.f(d3));  // 6 ins 7 outs

    xor6 x644i (.out(x644),.a(c28),.b(d50),.c(c18),.d(d16),.e(c15),.f(d47));  // 6 ins 6 outs

    xor6 x31i (.out(x31),.a(x707),.b(d31),.c(d57),.d(x739),.e(x663),.f(1'b0));  // 5 ins 1 outs

    xor6 x30i (.out(x30),.a(x734),.b(d4),.c(d59),.d(c27),.e(x709),.f(x685));  // 6 ins 1 outs

    xor6 x29i (.out(x29),.a(x749),.b(d23),.c(x699),.d(x686),.e(x657),.f(1'b0));  // 5 ins 1 outs

    xor6 x28i (.out(x28),.a(x663),.b(x721),.c(x671),.d(x683),.e(x753),.f(x661));  // 6 ins 1 outs

    xor6 x27i (.out(x27),.a(d11),.b(x708),.c(x674),.d(x651),.e(x740),.f(1'b0));  // 5 ins 1 outs

    xor6 x26i (.out(x26),.a(c15),.b(c28),.c(x741),.d(x689),.e(x709),.f(x673));  // 6 ins 1 outs

    xor6 x25i (.out(x25),.a(d47),.b(x718),.c(x679),.d(x750),.e(x695),.f(1'b0));  // 5 ins 1 outs

    xor6 x24i (.out(x24),.a(x728),.b(x684),.c(x754),.d(x661),.e(x701),.f(1'b0));  // 5 ins 1 outs

    xor6 x23i (.out(x23),.a(c22),.b(x702),.c(x755),.d(x676),.e(x674),.f(1'b0));  // 5 ins 1 outs

    xor6 x22i (.out(x22),.a(c4),.b(x730),.c(x756),.d(x677),.e(x693),.f(1'b0));  // 5 ins 1 outs

    xor6 x21i (.out(x21),.a(c10),.b(c20),.c(x735),.d(x647),.e(x690),.f(1'b0));  // 5 ins 1 outs

    xor6 x20i (.out(x20),.a(x719),.b(x701),.c(x687),.d(x751),.e(x671),.f(1'b0));  // 5 ins 1 outs

    xor6 x19i (.out(x19),.a(d53),.b(x705),.c(d7),.d(x684),.e(x736),.f(1'b0));  // 5 ins 1 outs

    xor6 x18i (.out(x18),.a(d7),.b(d31),.c(x651),.d(x706),.e(x737),.f(1'b0));  // 5 ins 1 outs

    xor6 x17i (.out(x17),.a(x722),.b(d1),.c(x757),.d(x650),.e(x696),.f(1'b0));  // 5 ins 1 outs

    xor6 x16i (.out(x16),.a(x714),.b(x671),.c(x670),.d(x673),.e(x745),.f(x661));  // 6 ins 1 outs

    xor6 x15i (.out(x15),.a(x703),.b(x663),.c(x758),.d(x675),.e(x688),.f(1'b0));  // 5 ins 1 outs

    xor6 x14i (.out(x14),.a(x732),.b(c1),.c(x759),.d(x685),.e(x689),.f(1'b0));  // 5 ins 1 outs

    xor6 x13i (.out(x13),.a(x723),.b(x649),.c(x760),.d(x699),.e(x692),.f(1'b0));  // 5 ins 1 outs

    xor6 x12i (.out(x12),.a(x715),.b(x761),.c(x696),.d(x676),.e(x661),.f(x671));  // 6 ins 1 outs

    xor6 x11i (.out(x11),.a(x762),.b(x676),.c(x686),.d(x683),.e(x657),.f(1'b0));  // 5 ins 1 outs

    xor6 x10i (.out(x10),.a(x724),.b(x664),.c(x763),.d(x674),.e(x697),.f(1'b0));  // 5 ins 1 outs

    xor6 x9i (.out(x9),.a(x687),.b(x725),.c(x698),.d(x671),.e(x764),.f(x682));  // 6 ins 1 outs

    xor6 x8i (.out(x8),.a(x716),.b(d46),.c(c8),.d(x747),.e(x687),.f(1'b0));  // 5 ins 1 outs

    xor6 x7i (.out(x7),.a(d30),.b(c10),.c(x711),.d(x661),.e(x657),.f(x742));  // 6 ins 1 outs

    xor6 x6i (.out(x6),.a(x712),.b(d42),.c(x660),.d(x673),.e(x743),.f(x657));  // 6 ins 1 outs

    xor6 x5i (.out(x5),.a(c7),.b(x713),.c(d10),.d(x673),.e(x663),.f(x744));  // 6 ins 1 outs

    xor6 x4i (.out(x4),.a(c12),.b(x704),.c(x765),.d(x733),.e(x679),.f(1'b0));  // 5 ins 1 outs

    xor6 x3i (.out(x3),.a(d2),.b(x717),.c(x681),.d(x748),.e(x690),.f(1'b0));  // 5 ins 1 outs

    xor6 x2i (.out(x2),.a(x752),.b(x727),.c(x677),.d(x682),.e(x695),.f(1'b0));  // 5 ins 1 outs

    xor6 x1i (.out(x1),.a(x726),.b(x663),.c(x683),.d(x766),.e(x698),.f(1'b0));  // 5 ins 1 outs

    xor6 x0i (.out(x0),.a(x767),.b(x657),.c(x697),.d(x727),.e(x673),.f(x693));  // 6 ins 1 outs

endmodule

