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

//// CRC-32 of 80 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 00000000001111111111222222222233333333334444444444555555555566666666667777777777
//        01234567890123456789012345678901 01234567890123456789012345678901234567890123456789012345678901234567890123456789
//
// C00  = X.X..XXX..X.XX.X.XXXX...XX.....X X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X
// C01  = .XXX.X..X.XXX.XXXX...X..X.X....X XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..X.XXX.XXXX...X..X.X....X
// C02  = ...XXX.X.XXX....X..XX.X.X..X...X XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...X
// C03  = ....XXX.X.XXX....X..XX.X.X..X... .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...
// C04  = X.X......XXX...X.X.XXXX..XX..X.X X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X......XXX...X.X.XXXX..XX..X.X
// C05  = .XXX.XXX...X.X.XXX.X.XXXXXXX..XX XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XX
// C06  = ..XXX.XXX...X.X.XXX.X.XXXXXXX..X .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..X
// C07  = ..XXX.X.XXX.X.......XX.X..XXXX.X X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.XXX.X.......XX.X..XXXX.X
// C08  = ..XXX.X..X.XX..X.XXXXXX..X.XXXXX XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXX
// C09  = ...XXX.X..X.XX..X.XXXXXX..X.XXXX .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXX
// C10  = ..X.X..XX.XXX.XX..X..XXX.X.X.XX. X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..XX.XXX.XX..X..XXX.X.X.XX.
// C11  = X.XX..XXXXXX....XXX.X.XX.XX.X.X. XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XXXXXX....XXX.X.XX.XX.X.X.
// C12  = .XXXXXX.XX.X.X.X....XX.X.XXX.X.. XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X..
// C13  = X.XXXXXX.XX.X.X.X....XX.X.XXX.X. .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X.
// C14  = XX.XXXXXX.XX.X.X.X....XX.X.XXX.X ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X
// C15  = .XX.XXXXXX.XX.X.X.X....XX.X.XXX. ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.
// C16  = X..X....XX........X.X......X.XX. X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX.
// C17  = XX..X....XX........X.X......X.XX .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX
// C18  = XXX..X....XX........X.X......X.X ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.X
// C19  = .XXX..X....XX........X.X......X. ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.
// C20  = X.XXX..X....XX........X.X......X ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X
// C21  = .X.XXX..X....XX........X.X...... .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......
// C22  = X...X..X.XX.XXX..XXXX....XX....X X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X.XX.XXX..XXXX....XX....X
// C23  = .XX...XXX..XX.X..X...X..XXXX...X XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...X
// C24  = X.XX...XXX..XX.X..X...X..XXXX... .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...
// C25  = XX.XX...XXX..XX.X..X...X..XXXX.. ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX..
// C26  = XX..X.XX.X.XXXX...XX.....X.XXXXX X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX
// C27  = XXX..X.XX.X.XXXX...XX.....X.XXXX .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXX
// C28  = .XXX..X.XX.X.XXXX...XX.....X.XXX ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXX
// C29  = ..XXX..X.XX.X.XXXX...XX.....X.XX ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XX
// C30  = X..XXX..X.XX.X.XXXX...XX.....X.X ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.X
// C31  = .X..XXX..X.XX.X.XXXX...XX.....X. .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.
//
module crc32_dat80 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [79:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat80_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat80_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat80_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [79:0] dat_in;
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
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63,d64,d65,d66,d67,d68,d69,d70,d71,d72,d73,d74,d75,d76,d77,d78,
    d79;

assign { d79,d78,d77,d76,d75,d74,d73,d72,d71,d70,d69,d68,d67,d66,d65,
        d64,d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [79:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x15 = c16 ^ c9 ^ d12 ^ c14 ^ d34 ^ d3 ^ d62 ^ c11 ^ c23 ^ 
        d57 ^ c12 ^ d8 ^ d72 ^ d71 ^ d59 ^ d27 ^ d53 ^ c5 ^ c24 ^ 
        c29 ^ d76 ^ d54 ^ c4 ^ c28 ^ d4 ^ d55 ^ d9 ^ d30 ^ d56 ^ 
        c7 ^ d60 ^ c2 ^ d24 ^ d5 ^ d44 ^ d78 ^ d33 ^ d15 ^ d18 ^ 
        d74 ^ d21 ^ d77 ^ d49 ^ d16 ^ c18 ^ d50 ^ c6 ^ c8 ^ d45 ^ 
        d66 ^ d64 ^ d7 ^ c26 ^ d52 ^ c30 ^ c1 ^ d20;  // 57 ins 1 outs level 3

    assign x14 = d56 ^ d32 ^ d52 ^ d61 ^ c10 ^ c28 ^ d63 ^ d73 ^ d58 ^ 
        c5 ^ d43 ^ d79 ^ c15 ^ d55 ^ d65 ^ d77 ^ d3 ^ c11 ^ d14 ^ 
        d49 ^ d8 ^ d15 ^ d54 ^ d75 ^ c6 ^ c29 ^ c25 ^ c27 ^ c0 ^ 
        d2 ^ c8 ^ c17 ^ d7 ^ d76 ^ c7 ^ d23 ^ d4 ^ d26 ^ d17 ^ 
        c4 ^ d20 ^ d11 ^ d29 ^ d70 ^ d33 ^ d59 ^ c1 ^ d48 ^ d6 ^ 
        c13 ^ d53 ^ d51 ^ c23 ^ c3 ^ c22 ^ d71 ^ d19 ^ d44 ^ c31;  // 59 ins 1 outs level 3

    assign x13 = c14 ^ d78 ^ d47 ^ d62 ^ d54 ^ d64 ^ d43 ^ d72 ^ c3 ^ 
        d25 ^ d3 ^ c0 ^ c5 ^ d53 ^ d1 ^ c6 ^ d50 ^ c16 ^ d60 ^ 
        d31 ^ c21 ^ c2 ^ d48 ^ d52 ^ d7 ^ d51 ^ d58 ^ c27 ^ d57 ^ 
        d28 ^ d19 ^ c26 ^ d2 ^ d42 ^ d5 ^ c7 ^ c12 ^ d76 ^ c28 ^ 
        c24 ^ d14 ^ d22 ^ d75 ^ c10 ^ d69 ^ d74 ^ c4 ^ d13 ^ d16 ^ 
        d70 ^ d32 ^ c22 ^ d10 ^ d6 ^ d18 ^ c9 ^ c30 ^ d55;  // 58 ins 1 outs level 3

    assign x12 = d77 ^ d47 ^ c2 ^ c6 ^ d50 ^ c27 ^ c20 ^ d52 ^ c3 ^ 
        d41 ^ d51 ^ c13 ^ d21 ^ c25 ^ d42 ^ d31 ^ d53 ^ c29 ^ c26 ^ 
        c5 ^ d75 ^ c15 ^ d68 ^ c4 ^ d30 ^ d12 ^ c1 ^ d18 ^ d6 ^ 
        d73 ^ d24 ^ d0 ^ d2 ^ d69 ^ d5 ^ c9 ^ c11 ^ d59 ^ d4 ^ 
        d9 ^ c8 ^ d57 ^ c21 ^ d1 ^ d49 ^ c23 ^ d56 ^ d17 ^ d46 ^ 
        d54 ^ d71 ^ d74 ^ d13 ^ d61 ^ d27 ^ d15 ^ d63;  // 57 ins 1 outs level 3

    assign x11 = d33 ^ d51 ^ c23 ^ c22 ^ d14 ^ d78 ^ d56 ^ d4 ^ c17 ^ 
        c6 ^ d28 ^ d44 ^ c7 ^ c26 ^ d70 ^ c3 ^ d15 ^ d12 ^ d66 ^ 
        d57 ^ d17 ^ d24 ^ c9 ^ c16 ^ d74 ^ c0 ^ c30 ^ d68 ^ d71 ^ 
        d59 ^ d40 ^ d36 ^ c2 ^ d48 ^ d27 ^ d31 ^ d73 ^ d25 ^ d1 ^ 
        d76 ^ d65 ^ c11 ^ d20 ^ d54 ^ d64 ^ d41 ^ c8 ^ c25 ^ c28 ^ 
        d45 ^ c18 ^ d50 ^ d3 ^ d0 ^ d58 ^ d47 ^ d9 ^ d43 ^ d16 ^ 
        c10 ^ d26 ^ d55 ^ c20;  // 63 ins 1 outs level 3

    assign x10 = c14 ^ c18 ^ c2 ^ c29 ^ c27 ^ c15 ^ d52 ^ d59 ^ d19 ^ 
        d71 ^ d28 ^ c25 ^ d5 ^ c21 ^ d73 ^ d77 ^ d3 ^ d9 ^ c7 ^ 
        d39 ^ d60 ^ d32 ^ d69 ^ c22 ^ d58 ^ c12 ^ c11 ^ d2 ^ d63 ^ 
        d13 ^ d56 ^ d70 ^ c4 ^ d66 ^ d29 ^ d50 ^ d31 ^ d35 ^ d33 ^ 
        d16 ^ d0 ^ c10 ^ d78 ^ d40 ^ d36 ^ d26 ^ d55 ^ d14 ^ c30 ^ 
        d62 ^ c23 ^ d75 ^ c8 ^ d42;  // 54 ins 1 outs level 3

    assign x9 = d35 ^ d38 ^ c29 ^ d29 ^ c16 ^ d76 ^ d55 ^ c21 ^ c28 ^ 
        d61 ^ d46 ^ d79 ^ d41 ^ c10 ^ d23 ^ d58 ^ d60 ^ d9 ^ d64 ^ 
        d47 ^ c30 ^ d34 ^ d18 ^ d68 ^ c7 ^ d2 ^ d24 ^ c23 ^ d51 ^ 
        c18 ^ d69 ^ c13 ^ d53 ^ c12 ^ c26 ^ d5 ^ d74 ^ c19 ^ c4 ^ 
        d44 ^ d32 ^ d13 ^ d70 ^ d1 ^ c31 ^ c20 ^ d12 ^ d33 ^ d71 ^ 
        d66 ^ c22 ^ d36 ^ d78 ^ d11 ^ c3 ^ d52 ^ d43 ^ d67 ^ d4 ^ 
        d77 ^ d39 ^ c5;  // 62 ins 1 outs level 3

    assign x8 = d0 ^ d31 ^ c20 ^ d57 ^ d10 ^ d54 ^ c21 ^ d79 ^ d45 ^ 
        d28 ^ d63 ^ d38 ^ c2 ^ d59 ^ c19 ^ c22 ^ c18 ^ d37 ^ d66 ^ 
        d40 ^ d34 ^ d78 ^ c27 ^ d17 ^ d60 ^ d46 ^ d52 ^ c17 ^ c15 ^ 
        d65 ^ d76 ^ c29 ^ c6 ^ d12 ^ c30 ^ c9 ^ c12 ^ d1 ^ d3 ^ 
        d70 ^ d22 ^ d11 ^ d35 ^ d43 ^ d67 ^ c3 ^ d51 ^ d42 ^ d32 ^ 
        c25 ^ d75 ^ c11 ^ d50 ^ d8 ^ d33 ^ c31 ^ d69 ^ d23 ^ c4 ^ 
        c28 ^ d68 ^ d4 ^ d77 ^ d73;  // 64 ins 1 outs level 3

    assign x7 = c10 ^ c6 ^ c9 ^ c4 ^ c12 ^ d50 ^ d47 ^ d52 ^ d16 ^ 
        d56 ^ c8 ^ d3 ^ d21 ^ d58 ^ d77 ^ d7 ^ d0 ^ d74 ^ d75 ^ 
        c26 ^ c20 ^ d28 ^ c31 ^ d32 ^ d39 ^ d42 ^ c29 ^ d23 ^ d43 ^ 
        d57 ^ d24 ^ d29 ^ d68 ^ c21 ^ c2 ^ d25 ^ d54 ^ c27 ^ d76 ^ 
        d10 ^ c3 ^ d71 ^ d41 ^ d22 ^ d69 ^ d45 ^ d79 ^ c28 ^ d2 ^ 
        d5 ^ d15 ^ d8 ^ d34 ^ d37 ^ d46 ^ d51 ^ d60 ^ c23;  // 58 ins 1 outs level 3

    assign x6 = c16 ^ d56 ^ c6 ^ d38 ^ c8 ^ c26 ^ d30 ^ c14 ^ d55 ^ 
        d21 ^ d47 ^ d74 ^ c18 ^ d4 ^ d50 ^ d54 ^ c31 ^ d71 ^ d73 ^ 
        d43 ^ c7 ^ d72 ^ d8 ^ d76 ^ d14 ^ d1 ^ d65 ^ d6 ^ d20 ^ 
        c28 ^ c25 ^ d60 ^ d62 ^ d66 ^ d70 ^ d41 ^ c12 ^ c20 ^ c2 ^ 
        c27 ^ c24 ^ d75 ^ c23 ^ d79 ^ d52 ^ d40 ^ d5 ^ d64 ^ c17 ^ 
        d2 ^ d22 ^ d25 ^ d68 ^ d42 ^ c4 ^ d51 ^ c22 ^ d11 ^ d29 ^ 
        c3 ^ d45 ^ d7;  // 62 ins 1 outs level 3

    assign x5 = d24 ^ d44 ^ d61 ^ c13 ^ c31 ^ d67 ^ c2 ^ d72 ^ d41 ^ 
        d55 ^ d37 ^ d69 ^ c16 ^ d5 ^ d10 ^ d53 ^ d74 ^ d3 ^ d64 ^ 
        c21 ^ d73 ^ d50 ^ d54 ^ d46 ^ d1 ^ c5 ^ d28 ^ d7 ^ c23 ^ 
        d70 ^ c1 ^ d71 ^ d42 ^ d40 ^ d75 ^ c3 ^ c19 ^ c27 ^ d79 ^ 
        c26 ^ d51 ^ c17 ^ d20 ^ d63 ^ d29 ^ d13 ^ c24 ^ c6 ^ d21 ^ 
        d19 ^ d78 ^ c15 ^ d39 ^ d49 ^ d4 ^ c7 ^ d65 ^ d59 ^ c30 ^ 
        c25 ^ d6 ^ c22 ^ d0 ^ c11;  // 64 ins 1 outs level 3

    assign x4 = d19 ^ d50 ^ d12 ^ d30 ^ d2 ^ d40 ^ d68 ^ d8 ^ d74 ^ 
        d44 ^ d38 ^ d73 ^ d79 ^ c20 ^ d58 ^ c17 ^ d18 ^ c29 ^ c19 ^ 
        d65 ^ c26 ^ d59 ^ d57 ^ d33 ^ d3 ^ d39 ^ c11 ^ d29 ^ d11 ^ 
        d69 ^ c21 ^ d15 ^ d77 ^ d46 ^ c0 ^ d31 ^ c9 ^ c15 ^ c2 ^ 
        d41 ^ d20 ^ c22 ^ c10 ^ d24 ^ d4 ^ d70 ^ d63 ^ d45 ^ d67 ^ 
        c31 ^ d47 ^ d48 ^ d25 ^ c25 ^ d6 ^ d0;  // 56 ins 1 outs level 3

    assign x3 = d45 ^ c4 ^ d39 ^ d69 ^ d27 ^ d52 ^ d54 ^ d68 ^ d25 ^ 
        c10 ^ c28 ^ d76 ^ c8 ^ d2 ^ d19 ^ c12 ^ d1 ^ d18 ^ d58 ^ 
        d31 ^ c17 ^ d71 ^ d32 ^ d38 ^ d8 ^ c21 ^ d73 ^ d59 ^ c6 ^ 
        d53 ^ d3 ^ d37 ^ c11 ^ d36 ^ c25 ^ d10 ^ d65 ^ d60 ^ c23 ^ 
        d17 ^ c20 ^ d33 ^ d9 ^ d56 ^ c5 ^ d7 ^ d40 ^ d15 ^ d14;  // 49 ins 1 outs level 3

    assign x2 = d44 ^ d58 ^ d31 ^ d7 ^ d6 ^ c9 ^ d9 ^ d17 ^ d72 ^ 
        d2 ^ c27 ^ c24 ^ d53 ^ d57 ^ d32 ^ d0 ^ d59 ^ d51 ^ d35 ^ 
        d38 ^ d18 ^ d16 ^ c10 ^ c22 ^ d79 ^ d70 ^ c3 ^ c4 ^ d68 ^ 
        c19 ^ c7 ^ d75 ^ d14 ^ d24 ^ d26 ^ d55 ^ d13 ^ d39 ^ c20 ^ 
        d67 ^ d1 ^ d52 ^ c31 ^ d36 ^ d37 ^ c5 ^ d8 ^ d64 ^ d30 ^ 
        c16 ^ c11;  // 51 ins 1 outs level 3

    assign x1 = d12 ^ c2 ^ c24 ^ d63 ^ d47 ^ d27 ^ c31 ^ d13 ^ d34 ^ 
        d9 ^ d74 ^ d69 ^ d65 ^ d44 ^ d58 ^ d72 ^ c21 ^ c16 ^ d56 ^ 
        d28 ^ d37 ^ d16 ^ d38 ^ c8 ^ d60 ^ c3 ^ d11 ^ d64 ^ d62 ^ 
        c11 ^ c10 ^ d33 ^ c5 ^ d1 ^ d24 ^ d53 ^ d46 ^ d17 ^ d49 ^ 
        d79 ^ d59 ^ c17 ^ c26 ^ c15 ^ d6 ^ c12 ^ d51 ^ d50 ^ d35 ^ 
        c1 ^ c14 ^ d0 ^ d7;  // 53 ins 1 outs level 3

    assign x0 = d0 ^ d50 ^ c12 ^ d6 ^ c25 ^ d65 ^ c7 ^ c15 ^ c17 ^ 
        d30 ^ c5 ^ d37 ^ c20 ^ d55 ^ d26 ^ c10 ^ d16 ^ d31 ^ c6 ^ 
        d29 ^ d66 ^ d79 ^ d10 ^ d9 ^ d47 ^ c0 ^ c19 ^ d58 ^ d73 ^ 
        d68 ^ d32 ^ d12 ^ d53 ^ d60 ^ d28 ^ d72 ^ d34 ^ c18 ^ d45 ^ 
        d54 ^ d25 ^ d48 ^ d24 ^ d44 ^ d61 ^ c13 ^ c31 ^ d67 ^ c2 ^ 
        c24 ^ d63;  // 51 ins 1 outs level 3

    assign x31 = d72 ^ d28 ^ d43 ^ d44 ^ d71 ^ d60 ^ d47 ^ c12 ^ d59 ^ 
        d24 ^ d5 ^ c19 ^ d31 ^ c1 ^ c24 ^ d62 ^ d8 ^ d9 ^ d49 ^ 
        c6 ^ d27 ^ d78 ^ c17 ^ c11 ^ d67 ^ d52 ^ d64 ^ d29 ^ c14 ^ 
        d11 ^ d46 ^ c18 ^ d30 ^ d25 ^ d15 ^ d36 ^ c23 ^ c30 ^ c9 ^ 
        c4 ^ d33 ^ d23 ^ d53 ^ d57 ^ c5 ^ d66 ^ d54 ^ d65 ^ c16;  // 49 ins 1 outs level 3

    assign x30 = d64 ^ d10 ^ d58 ^ c5 ^ d43 ^ d35 ^ d8 ^ d26 ^ c13 ^ 
        c10 ^ c31 ^ d70 ^ d46 ^ d77 ^ d29 ^ d32 ^ c8 ^ d79 ^ c16 ^ 
        d52 ^ d42 ^ d28 ^ d66 ^ d27 ^ c0 ^ d61 ^ c15 ^ d30 ^ d51 ^ 
        c17 ^ c18 ^ d71 ^ c4 ^ d4 ^ d56 ^ d22 ^ d53 ^ d48 ^ c11 ^ 
        d14 ^ d45 ^ d7 ^ d23 ^ c23 ^ d59 ^ d65 ^ c29 ^ d63 ^ c22 ^ 
        d24 ^ c3;  // 51 ins 1 outs level 3

    assign x29 = d69 ^ d25 ^ d58 ^ d42 ^ d27 ^ d63 ^ d3 ^ c30 ^ d50 ^ 
        d47 ^ c22 ^ d23 ^ d22 ^ d21 ^ d29 ^ d76 ^ d52 ^ c16 ^ d6 ^ 
        d45 ^ d9 ^ d57 ^ c31 ^ c14 ^ d79 ^ d7 ^ d44 ^ c21 ^ d70 ^ 
        d78 ^ c17 ^ d51 ^ c12 ^ c28 ^ d62 ^ d31 ^ d26 ^ c9 ^ c3 ^ 
        d28 ^ d55 ^ d60 ^ c15 ^ d64 ^ c10 ^ d41 ^ d34 ^ c2 ^ c7 ^ 
        d13 ^ c4 ^ d65;  // 52 ins 1 outs level 3

    assign x28 = d78 ^ d69 ^ c1 ^ d28 ^ c20 ^ d20 ^ c3 ^ c9 ^ d25 ^ 
        c15 ^ d24 ^ c8 ^ d59 ^ d57 ^ d41 ^ c11 ^ d30 ^ d5 ^ d64 ^ 
        c16 ^ d40 ^ d44 ^ d75 ^ c21 ^ d22 ^ d77 ^ d26 ^ d51 ^ d6 ^ 
        c14 ^ d63 ^ d33 ^ d54 ^ d50 ^ d56 ^ d12 ^ d79 ^ c2 ^ d68 ^ 
        d21 ^ c27 ^ d2 ^ c6 ^ d62 ^ d46 ^ d8 ^ d27 ^ d49 ^ c13 ^ 
        d61 ^ d43 ^ c29 ^ c31 ^ c30;  // 54 ins 1 outs level 3

    assign x27 = d67 ^ d68 ^ c29 ^ d24 ^ d21 ^ d29 ^ d50 ^ d26 ^ d53 ^ 
        d7 ^ d56 ^ d48 ^ d60 ^ d78 ^ d55 ^ d63 ^ d45 ^ c13 ^ d4 ^ 
        d61 ^ d62 ^ d1 ^ d79 ^ d23 ^ d43 ^ c31 ^ c14 ^ d40 ^ d42 ^ 
        d5 ^ c26 ^ c30 ^ d76 ^ d49 ^ c1 ^ d74 ^ c7 ^ c10 ^ d20 ^ 
        d19 ^ d39 ^ d58 ^ d11 ^ c8 ^ c2 ^ c5 ^ c19 ^ d32 ^ c20 ^ 
        d25 ^ d77 ^ d27 ^ c0 ^ c12 ^ c15 ^ c28;  // 56 ins 1 outs level 3

    assign x26 = d31 ^ d66 ^ c7 ^ d42 ^ d52 ^ d73 ^ c4 ^ c27 ^ c1 ^ 
        c30 ^ c19 ^ d22 ^ c0 ^ d67 ^ d49 ^ c25 ^ c9 ^ d19 ^ d10 ^ 
        d18 ^ d26 ^ d75 ^ d4 ^ d20 ^ d41 ^ d6 ^ c31 ^ d28 ^ d0 ^ 
        c12 ^ d38 ^ d3 ^ d60 ^ d77 ^ d47 ^ c6 ^ d57 ^ c18 ^ d79 ^ 
        c11 ^ d23 ^ d39 ^ d62 ^ d78 ^ c13 ^ d76 ^ c28 ^ d55 ^ d61 ^ 
        d44 ^ d59 ^ c14 ^ d24 ^ c29 ^ d48 ^ d25 ^ d54;  // 57 ins 1 outs level 3

    assign x25 = c4 ^ d77 ^ c0 ^ d49 ^ d40 ^ d31 ^ c19 ^ d58 ^ d33 ^ 
        d11 ^ d41 ^ c13 ^ d29 ^ d37 ^ d28 ^ c26 ^ d18 ^ d3 ^ d21 ^ 
        d57 ^ d22 ^ d75 ^ d51 ^ d38 ^ c3 ^ d17 ^ c1 ^ d15 ^ c27 ^ 
        c23 ^ c8 ^ c29 ^ d48 ^ c16 ^ d62 ^ d74 ^ d64 ^ d44 ^ d2 ^ 
        d71 ^ d67 ^ c14 ^ d19 ^ c9 ^ d56 ^ d76 ^ c28 ^ c10 ^ d61 ^ 
        d52 ^ d8 ^ d36;  // 52 ins 1 outs level 3

    assign x24 = d1 ^ c13 ^ d47 ^ d66 ^ c26 ^ d35 ^ d60 ^ c3 ^ d21 ^ 
        d43 ^ d14 ^ d27 ^ c8 ^ c0 ^ d56 ^ d20 ^ d36 ^ d48 ^ d73 ^ 
        d70 ^ d57 ^ d16 ^ d61 ^ c7 ^ c28 ^ c2 ^ c12 ^ d39 ^ d74 ^ 
        d37 ^ d10 ^ d28 ^ d76 ^ c15 ^ d40 ^ d75 ^ d51 ^ c22 ^ d32 ^ 
        d18 ^ d50 ^ d30 ^ d63 ^ c27 ^ d2 ^ c18 ^ d17 ^ c9 ^ c25 ^ 
        d7 ^ d55;  // 51 ins 1 outs level 3

    assign x23 = d73 ^ d56 ^ d39 ^ d47 ^ c17 ^ c7 ^ d60 ^ d15 ^ d42 ^ 
        c26 ^ c14 ^ d20 ^ d26 ^ c27 ^ c1 ^ c21 ^ d35 ^ d34 ^ d9 ^ 
        d65 ^ d29 ^ d79 ^ d54 ^ d59 ^ c6 ^ d31 ^ d49 ^ d69 ^ d17 ^ 
        c24 ^ c25 ^ d46 ^ d36 ^ c8 ^ d72 ^ d16 ^ d55 ^ d19 ^ d6 ^ 
        c12 ^ d1 ^ d50 ^ d38 ^ d75 ^ d74 ^ c11 ^ d62 ^ d0 ^ d13 ^ 
        c31 ^ d27 ^ c2;  // 52 ins 1 outs level 3

    assign x22 = d67 ^ d31 ^ d43 ^ d38 ^ d11 ^ d52 ^ c26 ^ d45 ^ c18 ^ 
        d12 ^ d79 ^ d68 ^ d74 ^ d36 ^ c31 ^ c12 ^ c17 ^ d0 ^ d19 ^ 
        c7 ^ d18 ^ d35 ^ d60 ^ c13 ^ d61 ^ d57 ^ d44 ^ d24 ^ d48 ^ 
        d23 ^ d34 ^ d73 ^ d41 ^ d62 ^ c14 ^ d14 ^ c9 ^ d58 ^ c19 ^ 
        d65 ^ c0 ^ d47 ^ d9 ^ d66 ^ d29 ^ d16 ^ c4 ^ c10 ^ d26 ^ 
        d55 ^ c20 ^ d37 ^ c25 ^ d27;  // 54 ins 1 outs level 3

    assign x21 = d22 ^ d52 ^ d53 ^ c14 ^ d62 ^ d61 ^ c1 ^ d27 ^ c4 ^ 
        c3 ^ d5 ^ d42 ^ d24 ^ d10 ^ d13 ^ d35 ^ c8 ^ d31 ^ c5 ^ 
        c25 ^ c23 ^ d71 ^ d49 ^ c13 ^ d40 ^ d29 ^ d17 ^ d73 ^ d37 ^ 
        d34 ^ d56 ^ d18 ^ d9 ^ d26 ^ d51;  // 35 ins 1 outs level 3

    assign x20 = d8 ^ d41 ^ d61 ^ d28 ^ d52 ^ d16 ^ d17 ^ c31 ^ d39 ^ 
        d79 ^ d48 ^ c24 ^ c4 ^ d60 ^ d34 ^ d4 ^ d33 ^ d55 ^ c12 ^ 
        d12 ^ d72 ^ c0 ^ d36 ^ d30 ^ c2 ^ d51 ^ d50 ^ d70 ^ c13 ^ 
        c22 ^ c3 ^ d26 ^ d23 ^ c7 ^ d25 ^ d21 ^ d9;  // 37 ins 1 outs level 3

    assign x19 = d27 ^ d69 ^ d3 ^ d38 ^ d71 ^ d15 ^ c3 ^ c2 ^ c1 ^ 
        d35 ^ d25 ^ d47 ^ c21 ^ d32 ^ d33 ^ d29 ^ d60 ^ d11 ^ d16 ^ 
        d24 ^ d50 ^ c12 ^ c11 ^ d59 ^ d51 ^ d49 ^ d7 ^ d22 ^ c23 ^ 
        d54 ^ c6 ^ d8 ^ d40 ^ c30 ^ d78 ^ d20;  // 36 ins 1 outs level 3

    assign x18 = d77 ^ c2 ^ d28 ^ d48 ^ d2 ^ c29 ^ d39 ^ d46 ^ d49 ^ 
        d7 ^ c31 ^ c5 ^ d24 ^ d14 ^ d79 ^ d34 ^ d32 ^ c11 ^ d6 ^ 
        d15 ^ d26 ^ d70 ^ d37 ^ c1 ^ c0 ^ c22 ^ d31 ^ d21 ^ d19 ^ 
        c20 ^ d50 ^ d53 ^ d68 ^ c10 ^ d10 ^ d59 ^ d58 ^ d23;  // 38 ins 1 outs level 3

    assign x17 = d58 ^ d49 ^ d33 ^ c1 ^ c31 ^ c10 ^ d69 ^ d45 ^ d38 ^ 
        d1 ^ d79 ^ d5 ^ d14 ^ d30 ^ c21 ^ d48 ^ c19 ^ d52 ^ d25 ^ 
        d6 ^ d31 ^ d13 ^ d67 ^ d27 ^ d36 ^ c9 ^ c0 ^ c4 ^ c30 ^ 
        d22 ^ d47 ^ d57 ^ d78 ^ d76 ^ d23 ^ d18 ^ d20 ^ c28 ^ d9;  // 39 ins 1 outs level 3

    assign x16 = d26 ^ d5 ^ d44 ^ d12 ^ d0 ^ c18 ^ d24 ^ c29 ^ c9 ^ 
        c3 ^ c20 ^ c0 ^ c27 ^ d48 ^ d51 ^ d66 ^ d32 ^ d37 ^ d68 ^ 
        d35 ^ d13 ^ d4 ^ d47 ^ d22 ^ d57 ^ d29 ^ d30 ^ c30 ^ d46 ^ 
        d56 ^ d19 ^ d17 ^ c8 ^ d77 ^ d75 ^ d78 ^ d21 ^ d8;  // 38 ins 1 outs level 3

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat80_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [79:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x862, x861, x860, x859, x858, x857, x855, 
       x854, x853, x852, x851, x850, x849, x848, x847, 
       x846, x845, x844, x843, x842, x841, x840, x839, 
       x838, x837, x836, x835, x834, x833, x832, x831, 
       x830, x829, x828, x827, x826, x825, x824, x823, 
       x822, x821, x820, x819, x817, x816, x815, x814, 
       x813, x812, x811, x810, x809, x808, x807, x806, 
       x805, x804, x803, x802, x801, x800, x799, x798, 
       x797, x796, x795, x794, x793, x792, x791, x790, 
       x789, x788, x787, x786, x785, x784, x783, x782, 
       x781, x780, x779, x778, x777, x776, x775, x774, 
       x773, x772, x771, x770, x769, x768, x767, x766, 
       x765, x764, x763, x762, x761, x760, x759, x758, 
       x757, x756, x755, x754, x753, x752, x751, x750, 
       x749, x748, x747, x746, x745, x744, x743, x742, 
       x741, x740, x739, x738, x737, x736, x735, x734, 
       x733, x732, x731, x730, x729, x728, x727, x726, 
       x725, x724, x723, x722, x721, x720, x719, x718, 
       x717, x716, x715, x714, x713, x712, x711, x710, 
       x709, x708, x707, x706, x705, x704, x703, x702, 
       x701, x700, x15, x14, x13, x12, x11, x10, 
       x9, x8, x7, x6, x5, x4, x3, x2, 
       x1, x0, x31, x30, x29, x28, x27, x26, 
       x25, x24, x23, x22, x21, x20, x19, x18, 
       x17, x16;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63,d64,d65,d66,d67,d68,d69,d70,d71,d72,d73,d74,d75,d76,d77,d78,
    d79;

assign { d79,d78,d77,d76,d75,d74,d73,d72,d71,d70,d69,d68,d67,d66,d65,
        d64,d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [79:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x862i (.out(x862),.a(x860),.b(x755),.c(x710),.d(x759),.e(x861),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x861i (.out(x861),.a(c16),.b(c29),.c(d29),.d(c31),.e(d5),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x860i (.out(x860),.a(d8),.b(d46),.c(d21),.d(d34),.e(d15),.f(d22));  // 6 ins 1 outs level 1

    xor6 x859i (.out(x859),.a(d45),.b(x858),.c(x740),.d(x731),.e(x767),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x858i (.out(x858),.a(d50),.b(d36),.c(d27),.d(c31),.e(d5),.f(d9));  // 6 ins 1 outs level 1

    xor6 x857i (.out(x857),.a(d10),.b(x746),.c(x708),.d(x703),.e(x752),.f(d15));  // 6 ins 1 outs level 2

    xor6 x855i (.out(x855),.a(d31),.b(d7),.c(d21),.d(c11),.e(d14),.f(d26));  // 6 ins 1 outs level 1

    xor6 x854i (.out(x854),.a(x852),.b(d33),.c(x721),.d(x853),.e(x767),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x853i (.out(x853),.a(c2),.b(c12),.c(d32),.d(d16),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x852i (.out(x852),.a(c23),.b(d71),.c(d29),.d(d8),.e(d47),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x851i (.out(x851),.a(x850),.b(x711),.c(x769),.d(x714),.e(x710),.f(x703));  // 6 ins 1 outs level 2

    xor6 x850i (.out(x850),.a(d52),.b(d0),.c(c4),.d(c15),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x849i (.out(x849),.a(d31),.b(d5),.c(d73),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x848i (.out(x848),.a(d9),.b(d26),.c(c5),.d(d27),.e(c25),.f(d22));  // 6 ins 1 outs level 1

    xor6 x847i (.out(x847),.a(x845),.b(x738),.c(x717),.d(x708),.e(x846),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x846i (.out(x846),.a(d41),.b(d52),.c(c4),.d(d44),.e(d57),.f(d45));  // 6 ins 1 outs level 1

    xor6 x845i (.out(x845),.a(d77),.b(d66),.c(d14),.d(c15),.e(c18),.f(d27));  // 6 ins 1 outs level 1

    xor6 x844i (.out(x844),.a(x842),.b(d28),.c(x703),.d(x758),.e(x843),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x843i (.out(x843),.a(d39),.b(d69),.c(d13),.d(c9),.e(d29),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x842i (.out(x842),.a(d4),.b(d42),.c(d46),.d(d38),.e(c27),.f(d75));  // 6 ins 1 outs level 1

    xor6 x841i (.out(x841),.a(x839),.b(x757),.c(x749),.d(x840),.e(x709),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x840i (.out(x840),.a(d40),.b(d36),.c(d60),.d(d73),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x839i (.out(x839),.a(d14),.b(d26),.c(c25),.d(d66),.e(d16),.f(c18));  // 6 ins 1 outs level 1

    xor6 x838i (.out(x838),.a(d60),.b(x836),.c(x704),.d(x742),.e(x837),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x837i (.out(x837),.a(d23),.b(d27),.c(d29),.d(d58),.e(d15),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x836i (.out(x836),.a(c10),.b(d64),.c(c15),.d(d8),.e(d19),.f(d44));  // 6 ins 1 outs level 1

    xor6 x835i (.out(x835),.a(x833),.b(x761),.c(x717),.d(x755),.e(x722),.f(x834));  // 6 ins 1 outs level 2

    xor6 x834i (.out(x834),.a(d79),.b(d60),.c(c15),.d(d39),.e(d11),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x833i (.out(x833),.a(c7),.b(d55),.c(d41),.d(d42),.e(c11),.f(d26));  // 6 ins 1 outs level 1

    xor6 x832i (.out(x832),.a(x830),.b(x734),.c(x720),.d(x831),.e(x757),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x831i (.out(x831),.a(d47),.b(c30),.c(d78),.d(d43),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x830i (.out(x830),.a(d79),.b(d20),.c(c5),.d(d7),.e(d2),.f(d45));  // 6 ins 1 outs level 1

    xor6 x829i (.out(x829),.a(x827),.b(x759),.c(x710),.d(x703),.e(x828),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x828i (.out(x828),.a(d33),.b(d12),.c(d22),.d(d57),.e(c14),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x827i (.out(x827),.a(d19),.b(d13),.c(d27),.d(d25),.e(d64),.f(d62));  // 6 ins 1 outs level 1

    xor6 x826i (.out(x826),.a(x719),.b(x824),.c(x708),.d(x722),.e(x825),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x825i (.out(x825),.a(d19),.b(d26),.c(d9),.d(d23),.e(d33),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x824i (.out(x824),.a(d4),.b(d21),.c(d40),.d(d54),.e(d34),.f(c9));  // 6 ins 1 outs level 1

    xor6 x823i (.out(x823),.a(x822),.b(x763),.c(x721),.d(x732),.e(x709),.f(x726));  // 6 ins 1 outs level 2

    xor6 x822i (.out(x822),.a(d45),.b(d26),.c(c11),.d(d63),.e(d32),.f(c5));  // 6 ins 1 outs level 1

    xor6 x821i (.out(x821),.a(x820),.b(x762),.c(x733),.d(x717),.e(x718),.f(x701));  // 6 ins 1 outs level 2

    xor6 x820i (.out(x820),.a(d5),.b(d30),.c(d36),.d(d25),.e(d1),.f(d28));  // 6 ins 1 outs level 1

    xor6 x819i (.out(x819),.a(d35),.b(x816),.c(c9),.d(x749),.e(x709),.f(x817));  // 6 ins 1 outs level 2

    xor6 x817i (.out(x817),.a(d47),.b(d36),.c(c18),.d(d54),.e(d66),.f(d77));  // 6 ins 1 outs level 1

    xor6 x816i (.out(x816),.a(d30),.b(d44),.c(d16),.d(d64),.e(d63),.f(d45));  // 6 ins 1 outs level 1

    xor6 x815i (.out(x815),.a(x813),.b(x703),.c(x814),.d(x704),.e(x719),.f(x721));  // 6 ins 1 outs level 2

    xor6 x814i (.out(x814),.a(d16),.b(d46),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x813i (.out(x813),.a(d44),.b(c31),.c(d11),.d(d7),.e(d17),.f(d0));  // 6 ins 1 outs level 1

    xor6 x812i (.out(x812),.a(x703),.b(x810),.c(x762),.d(x811),.e(x711),.f(x726));  // 6 ins 1 outs level 2

    xor6 x811i (.out(x811),.a(d1),.b(d8),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x810i (.out(x810),.a(d57),.b(d44),.c(d6),.d(d10),.e(d77),.f(d13));  // 6 ins 1 outs level 1

    xor6 x809i (.out(x809),.a(x807),.b(x733),.c(x701),.d(x720),.e(x808),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x808i (.out(x808),.a(d56),.b(c5),.c(d57),.d(d25),.e(d8),.f(d9));  // 6 ins 1 outs level 1

    xor6 x807i (.out(x807),.a(c9),.b(d69),.c(d45),.d(d1),.e(c8),.f(d64));  // 6 ins 1 outs level 1

    xor6 x806i (.out(x806),.a(x804),.b(x703),.c(x805),.d(x746),.e(x717),.f(x739));  // 6 ins 1 outs level 2

    xor6 x805i (.out(x805),.a(d41),.b(c11),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x804i (.out(x804),.a(d45),.b(d53),.c(d25),.d(c26),.e(d12),.f(d74));  // 6 ins 1 outs level 1

    xor6 x803i (.out(x803),.a(d15),.b(x801),.c(x710),.d(x706),.e(x707),.f(x802));  // 6 ins 1 outs level 2

    xor6 x802i (.out(x802),.a(c23),.b(d46),.c(c26),.d(d24),.e(c31),.f(d2));  // 6 ins 1 outs level 1

    xor6 x801i (.out(x801),.a(d1),.b(d19),.c(d71),.d(d74),.e(d3),.f(d42));  // 6 ins 1 outs level 1

    xor6 x800i (.out(x800),.a(x799),.b(d8),.c(x739),.d(x702),.e(x706),.f(x713));  // 6 ins 1 outs level 2

    xor6 x799i (.out(x799),.a(d11),.b(d19),.c(c24),.d(c16),.e(d72),.f(c6));  // 6 ins 1 outs level 1

    xor6 x798i (.out(x798),.a(x704),.b(x796),.c(x702),.d(x797),.e(x769),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x797i (.out(x797),.a(d71),.b(c23),.c(d6),.d(d47),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x796i (.out(x796),.a(d3),.b(d34),.c(d37),.d(d69),.e(d27),.f(d57));  // 6 ins 1 outs level 1

    xor6 x795i (.out(x795),.a(x793),.b(x755),.c(x719),.d(x707),.e(x718),.f(x794));  // 6 ins 1 outs level 2

    xor6 x794i (.out(x794),.a(c22),.b(d70),.c(c30),.d(c21),.e(d24),.f(d78));  // 6 ins 1 outs level 1

    xor6 x793i (.out(x793),.a(d57),.b(d10),.c(d54),.d(c12),.e(d18),.f(d13));  // 6 ins 1 outs level 1

    xor6 x792i (.out(x792),.a(x790),.b(d64),.c(x738),.d(x709),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x791i (.out(x791),.a(x705),.b(x713),.c(x714),.d(x765),.e(x702),.f(d35));  // 6 ins 1 outs level 2

    xor6 x790i (.out(x790),.a(d46),.b(d19),.c(d12),.d(c5),.e(d69),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x789i (.out(x789),.a(x788),.b(d14),.c(x750),.d(x761),.e(x711),.f(x719));  // 6 ins 1 outs level 2

    xor6 x788i (.out(x788),.a(d59),.b(d33),.c(d28),.d(d35),.e(c2),.f(c29));  // 6 ins 1 outs level 1

    xor6 x787i (.out(x787),.a(x785),.b(x702),.c(x711),.d(x701),.e(x786),.f(x760));  // 6 ins 1 outs level 2

    xor6 x786i (.out(x786),.a(d28),.b(d43),.c(d24),.d(d17),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x785i (.out(x785),.a(c28),.b(d76),.c(d25),.d(d40),.e(d45),.f(d20));  // 6 ins 1 outs level 1

    xor6 x784i (.out(x784),.a(x782),.b(x705),.c(x762),.d(x701),.e(x783),.f(x723));  // 6 ins 1 outs level 2

    xor6 x783i (.out(x783),.a(d9),.b(d40),.c(d30),.d(d6),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x782i (.out(x782),.a(d4),.b(d42),.c(c25),.d(d73),.e(d12),.f(c31));  // 6 ins 1 outs level 1

    xor6 x781i (.out(x781),.a(x779),.b(x700),.c(x780),.d(x722),.e(x731),.f(x738));  // 6 ins 1 outs level 2

    xor6 x780i (.out(x780),.a(d45),.b(c30),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x779i (.out(x779),.a(d9),.b(d69),.c(d5),.d(d78),.e(c16),.f(d14));  // 6 ins 1 outs level 1

    xor6 x778i (.out(x778),.a(x726),.b(x759),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 2

    xor6 x777i (.out(x777),.a(x776),.b(c5),.c(x719),.d(x718),.e(x723),.f(x700));  // 6 ins 1 outs level 2

    xor6 x776i (.out(x776),.a(d77),.b(d46),.c(d3),.d(d23),.e(d11),.f(d63));  // 6 ins 1 outs level 1

    xor6 x775i (.out(x775),.a(x773),.b(x704),.c(x774),.d(x713),.e(x750),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x774i (.out(x774),.a(d50),.b(d45),.c(c7),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x773i (.out(x773),.a(d55),.b(d34),.c(d9),.d(c2),.e(d16),.f(d18));  // 6 ins 1 outs level 1

    xor6 x772i (.out(x772),.a(d42),.b(d4),.c(x705),.d(d38),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x771i (.out(x771),.a(c17),.b(d60),.c(x720),.d(d65),.e(1'b0),.f(1'b0));  // 4 ins 2 outs level 2

    xor6 x770i (.out(x770),.a(c31),.b(d4),.c(x722),.d(d1),.e(x704),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x769i (.out(x769),.a(d25),.b(d4),.c(d39),.d(d23),.e(d7),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x768i (.out(x768),.a(d30),.b(x714),.c(d21),.d(d12),.e(d8),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x767i (.out(x767),.a(d22),.b(d69),.c(c21),.d(d11),.e(d25),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x766i (.out(x766),.a(x702),.b(x719),.c(d44),.d(d32),.e(x707),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x765i (.out(x765),.a(d13),.b(d36),.c(c13),.d(d34),.e(d61),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x764i (.out(x764),.a(d37),.b(d10),.c(d36),.d(x720),.e(x723),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x763i (.out(x763),.a(d65),.b(c17),.c(c31),.d(d64),.e(d27),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x762i (.out(x762),.a(d57),.b(c4),.c(d52),.d(d31),.e(1'b0),.f(1'b0));  // 4 ins 3 outs level 1

    xor6 x761i (.out(x761),.a(d75),.b(c11),.c(c25),.d(c27),.e(d73),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x760i (.out(x760),.a(c10),.b(d48),.c(c0),.d(d58),.e(d12),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x759i (.out(x759),.a(d26),.b(c8),.c(d56),.d(d19),.e(d30),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x758i (.out(x758),.a(d72),.b(d34),.c(c24),.d(c12),.e(d17),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x757i (.out(x757),.a(d63),.b(d76),.c(d26),.d(d21),.e(c28),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x756i (.out(x756),.a(x749),.b(x703),.c(x714),.d(c19),.e(d67),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x755i (.out(x755),.a(d0),.b(d15),.c(d66),.d(d18),.e(c18),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x754i (.out(x754),.a(c11),.b(x705),.c(c16),.d(d38),.e(d59),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x753i (.out(x753),.a(d32),.b(x708),.c(d16),.d(d10),.e(c6),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x752i (.out(x752),.a(d46),.b(c1),.c(c5),.d(c29),.e(d49),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x751i (.out(x751),.a(x717),.b(d6),.c(d1),.d(c9),.e(x701),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x750i (.out(x750),.a(d77),.b(d62),.c(d5),.d(d31),.e(c14),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x749i (.out(x749),.a(d10),.b(d39),.c(d29),.d(d37),.e(1'b0),.f(1'b0));  // 4 ins 3 outs level 1

    xor6 x748i (.out(x748),.a(d64),.b(d68),.c(x707),.d(d14),.e(c20),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x747i (.out(x747),.a(d18),.b(d2),.c(x706),.d(d29),.e(1'b0),.f(1'b0));  // 4 ins 4 outs level 2

    xor6 x746i (.out(x746),.a(d70),.b(c22),.c(d23),.d(d53),.e(d59),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x745i (.out(x745),.a(x734),.b(d35),.c(x707),.d(x711),.e(d31),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x744i (.out(x744),.a(d5),.b(c29),.c(x717),.d(d53),.e(x709),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x743i (.out(x743),.a(x718),.b(d15),.c(x705),.d(d0),.e(1'b0),.f(1'b0));  // 4 ins 3 outs level 2

    xor6 x742i (.out(x742),.a(d10),.b(d28),.c(d22),.d(c16),.e(d77),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x741i (.out(x741),.a(d47),.b(d33),.c(d9),.d(x714),.e(d1),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x740i (.out(x740),.a(d50),.b(d78),.c(d60),.d(c30),.e(d3),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x739i (.out(x739),.a(d43),.b(d30),.c(d20),.d(c12),.e(d28),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x738i (.out(x738),.a(d79),.b(d18),.c(d74),.d(c26),.e(d43),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x737i (.out(x737),.a(c21),.b(d61),.c(d0),.d(x719),.e(c13),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x736i (.out(x736),.a(c31),.b(d33),.c(d60),.d(x709),.e(d6),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x735i (.out(x735),.a(d17),.b(d32),.c(d35),.d(d57),.e(x700),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x734i (.out(x734),.a(d25),.b(c21),.c(d55),.d(c7),.e(d60),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x733i (.out(x733),.a(d29),.b(d40),.c(d27),.d(d38),.e(d7),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x732i (.out(x732),.a(d56),.b(c4),.c(c8),.d(d52),.e(d42),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x731i (.out(x731),.a(d48),.b(d13),.c(c0),.d(d47),.e(d18),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x730i (.out(x730),.a(d41),.b(c3),.c(d51),.d(x706),.e(x710),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x729i (.out(x729),.a(x705),.b(d34),.c(d37),.d(d12),.e(1'b0),.f(1'b0));  // 4 ins 6 outs level 2

    xor6 x728i (.out(x728),.a(x710),.b(c12),.c(c29),.d(d24),.e(c9),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x727i (.out(x727),.a(d1),.b(c2),.c(d47),.d(x704),.e(d50),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x726i (.out(x726),.a(c10),.b(d30),.c(d58),.d(d79),.e(d14),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x725i (.out(x725),.a(d45),.b(d42),.c(d22),.d(d54),.e(x703),.f(1'b0));  // 5 ins 5 outs level 2

    xor6 x724i (.out(x724),.a(d39),.b(d2),.c(x708),.d(d19),.e(d32),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x723i (.out(x723),.a(d71),.b(d17),.c(d53),.d(c23),.e(d18),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x722i (.out(x722),.a(d25),.b(d47),.c(d62),.d(d19),.e(c14),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x721i (.out(x721),.a(c3),.b(d24),.c(d29),.d(d35),.e(d51),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x720i (.out(x720),.a(d62),.b(d49),.c(d40),.d(c14),.e(c1),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x719i (.out(x719),.a(d13),.b(d63),.c(d69),.d(c15),.e(d40),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x718i (.out(x718),.a(d8),.b(d4),.c(d43),.d(d46),.e(c29),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x717i (.out(x717),.a(d23),.b(d11),.c(c19),.d(d38),.e(d67),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x716i (.out(x716),.a(d5),.b(d21),.c(x700),.d(d2),.e(d41),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x715i (.out(x715),.a(x701),.b(d49),.c(c1),.d(d20),.e(1'b0),.f(1'b0));  // 4 ins 8 outs level 2

    xor6 x714i (.out(x714),.a(d64),.b(d72),.c(c24),.d(c5),.e(d53),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x713i (.out(x713),.a(c23),.b(d7),.c(d71),.d(d66),.e(c18),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x712i (.out(x712),.a(d57),.b(d33),.c(d31),.d(x702),.e(d3),.f(1'b0));  // 5 ins 10 outs level 2

    xor6 x711i (.out(x711),.a(d26),.b(d16),.c(d0),.d(d9),.e(d36),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x710i (.out(x710),.a(d44),.b(d4),.c(c16),.d(d78),.e(c30),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x709i (.out(x709),.a(d48),.b(c15),.c(d61),.d(c13),.e(c0),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x708i (.out(x708),.a(c21),.b(c10),.c(d29),.d(d58),.e(c12),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x707i (.out(x707),.a(c25),.b(d65),.c(c9),.d(d73),.e(c17),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x706i (.out(x706),.a(d7),.b(d55),.c(c7),.d(d70),.e(c22),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x705i (.out(x705),.a(d24),.b(d77),.c(c31),.d(d68),.e(c20),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x704i (.out(x704),.a(c8),.b(d74),.c(c26),.d(d56),.e(d27),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x703i (.out(x703),.a(d50),.b(d79),.c(d28),.d(c2),.e(d6),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x702i (.out(x702),.a(c28),.b(d52),.c(d76),.d(d60),.e(c4),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x701i (.out(x701),.a(d54),.b(c6),.c(d59),.d(c11),.e(d15),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x700i (.out(x700),.a(c9),.b(c27),.c(c3),.d(d51),.e(d75),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x15i (.out(x15),.a(x775),.b(x715),.c(x712),.d(x768),.e(x728),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x14i (.out(x14),.a(x777),.b(x715),.c(x766),.d(x778),.e(x747),.f(x736));  // 6 ins 1 outs level 3

    xor6 x13i (.out(x13),.a(x781),.b(x747),.c(x753),.d(x741),.e(x725),.f(x712));  // 6 ins 1 outs level 3

    xor6 x12i (.out(x12),.a(x784),.b(x716),.c(x752),.d(x737),.e(x727),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x11i (.out(x11),.a(x787),.b(x712),.c(x713),.d(x748),.e(x730),.f(x727));  // 6 ins 1 outs level 3

    xor6 x10i (.out(x10),.a(x789),.b(x706),.c(x713),.d(x732),.e(x740),.f(x724));  // 6 ins 1 outs level 3

    xor6 x9i (.out(x9),.a(x791),.b(x741),.c(x730),.d(x724),.e(x744),.f(x792));  // 6 ins 1 outs level 3

    xor6 x8i (.out(x8),.a(x795),.b(x729),.c(x735),.d(x751),.e(x725),.f(x712));  // 6 ins 1 outs level 3

    xor6 x7i (.out(x7),.a(x798),.b(x743),.c(x753),.d(x716),.e(x725),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x6i (.out(x6),.a(x800),.b(x716),.c(x733),.d(x748),.e(x770),.f(x725));  // 6 ins 1 outs level 3

    xor6 x5i (.out(x5),.a(x803),.b(x715),.c(x716),.d(x737),.e(x756),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x4i (.out(x4),.a(x806),.b(x731),.c(x743),.d(x766),.e(x724),.f(x712));  // 6 ins 1 outs level 3

    xor6 x3i (.out(x3),.a(x809),.b(x764),.c(x724),.d(x748),.e(x712),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x2i (.out(x2),.a(x812),.b(x756),.c(x747),.d(x754),.e(x735),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x1i (.out(x1),.a(x815),.b(x708),.c(x729),.d(x771),.e(x754),.f(x741));  // 6 ins 1 outs level 3

    xor6 x0i (.out(x0),.a(x819),.b(x745),.c(x756),.d(x729),.e(x753),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x31i (.out(x31),.a(x821),.b(x713),.c(x771),.d(x741),.e(x728),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x30i (.out(x30),.a(x823),.b(x718),.c(x713),.d(x742),.e(x746),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x29i (.out(x29),.a(x826),.b(x725),.c(x712),.d(x763),.e(x730),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x28i (.out(x28),.a(x829),.b(x715),.c(x743),.d(x716),.e(x737),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x27i (.out(x27),.a(x772),.b(x724),.c(x744),.d(x832),.e(x727),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x26i (.out(x26),.a(x835),.b(x715),.c(x728),.d(x742),.e(x736),.f(x712));  // 6 ins 1 outs level 3

    xor6 x25i (.out(x25),.a(x838),.b(x716),.c(x744),.d(x764),.e(x712),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x24i (.out(x24),.a(x841),.b(x747),.c(x739),.d(x735),.e(x727),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x23i (.out(x23),.a(x844),.b(x715),.c(x745),.d(x770),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x22i (.out(x22),.a(x847),.b(x709),.c(x729),.d(x722),.e(x745),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x21i (.out(x21),.a(x848),.b(x721),.c(x732),.d(x849),.e(x764),.f(x765));  // 6 ins 1 outs level 3

    xor6 x20i (.out(x20),.a(x730),.b(x851),.c(x768),.d(x758),.e(x736),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x19i (.out(x19),.a(x854),.b(x715),.c(x733),.d(x740),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x18i (.out(x18),.a(x855),.b(x729),.c(x724),.d(x760),.e(x857),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x17i (.out(x17),.a(x859),.b(x715),.c(x726),.d(x751),.e(x712),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x16i (.out(x16),.a(x862),.b(x729),.c(x731),.d(x735),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

endmodule

