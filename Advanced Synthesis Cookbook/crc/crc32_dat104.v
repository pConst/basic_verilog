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

//// CRC-32 of 104 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000000000000000000000000000 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111
//        00000000001111111111222222222233 00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000
//        01234567890123456789012345678901 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
//
// C00  = XX.....X.XXXXX.X......XXXXXX.X.X X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.X
// C01  = X.X....XXX....XXX.....X.....XXXX XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..X.XXX.XXXX...X..X.X....XXX....XXX.....X.....XXXX
// C02  = X..X...XX..XXX..XX....X.XXXX..X. XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X.XXXX..X.
// C03  = .X..X...XX..XXX..XX....X.XXXX..X .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X.XXXX..X
// C04  = .XX..X.X...XX.X...XX..XX.X..X..X X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X......XXX...X.X.XXXX..XX..X.X...XX.X...XX..XX.X..X..X
// C05  = XXXX..XXXXXX.......XX.X..X.X...X XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X..X.X...X
// C06  = XXXXX..XXXXXX.......XX.X..X.X... .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X..X.X...
// C07  = ..XXXX.XX......X.....X.X.XX....X X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.XXX.X.......XX.X..XXXX.XX......X.....X.X.XX....X
// C08  = .X.XXXXXX.XXXX.XX......X.X...X.X XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......X.X...X.X
// C09  = ..X.XXXXXX.XXXX.XX......X.X...X. .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......X.X...X.
// C10  = .X.X.XX.X..X..X..XX...XXX.X..X.. X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..XX.XXX.XX..X..XXX.X.X.XX.X..X..X..XX...XXX.X..X..
// C11  = .XX.X.X...XX.X....XX..X...X..XXX XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XXXXXX....XXX.X.XX.XX.X.X...XX.X....XX..X...X..XXX
// C12  = .XXX.X...XX..XXX...XX.X.XXX..XX. XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX.
// C13  = X.XXX.X...XX..XXX...XX.X.XXX..XX .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX
// C14  = .X.XXX.X...XX..XXX...XX.X.XXX..X ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..X
// C15  = X.X.XXX.X...XX..XXX...XX.X.XXX.. ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..
// C16  = ...X.XX...XXX.XX.XXX..X..X.XX.XX X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XX
// C17  = ....X.XX...XXX.XX.XXX..X..X.XX.X .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.X
// C18  = .....X.XX...XXX.XX.XXX..X..X.XX. ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.
// C19  = ......X.XX...XXX.XX.XXX..X..X.XX ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX
// C20  = X......X.XX...XXX.XX.XXX..X..X.X ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.X
// C21  = .X......X.XX...XXX.XX.XXX..X..X. .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.
// C22  = .XX....X..X..X.XXXX.XXX...XXXX.. X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X.XX.XXX..XXXX....XX....X..X..X.XXXX.XXX...XXXX..
// C23  = XXXX...XXXX.XXXXXXXX.X..XXX.X.XX XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XX
// C24  = .XXXX...XXXX.XXXXXXXX.X..XXX.X.X .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.X
// C25  = ..XXXX...XXXX.XXXXXXXX.X..XXX.X. ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.
// C26  = .X.XXXXX.X......XXXXXX.X.XX.X... X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...
// C27  = ..X.XXXXX.X......XXXXXX.X.XX.X.. .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X..
// C28  = ...X.XXXXX.X......XXXXXX.X.XX.X. ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X.
// C29  = ....X.XXXXX.X......XXXXXX.X.XX.X ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X
// C30  = .....X.XXXXX.X......XXXXXX.X.XX. ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.
// C31  = X.....X.XXXXX.X......XXXXXX.X.XX .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX
//
module crc32_dat104 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [103:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat104_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat104_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat104_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [103:0] dat_in;
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
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63,d64,d65,d66,d67,d68,d69,d70,d71,d72,d73,d74,d75,d76,d77,d78,
    d79,d80,d81,d82,d83,d84,d85,d86,d87,d88,d89,d90,d91,d92,d93,d94,
    d95,d96,d97,d98,d99,d100,d101,d102,d103;

assign { d103,d102,d101,d100,d99,d98,d97,d96,d95,d94,d93,d92,d91,d90,d89,
        d88,d87,d86,d85,d84,d83,d82,d81,d80,d79,d78,d77,d76,d75,d74,d73,
        d72,d71,d70,d69,d68,d67,d66,d65,d64,d63,d62,d61,d60,d59,d58,d57,
        d56,d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [103:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x7 = d95 ^ d25 ^ d32 ^ c31 ^ c23 ^ d75 ^ c3 ^ d87 ^ d29 ^ 
        d22 ^ d23 ^ d10 ^ d0 ^ c2 ^ d74 ^ d8 ^ c21 ^ d2 ^ d69 ^ 
        d45 ^ d98 ^ d51 ^ c7 ^ d47 ^ d57 ^ d7 ^ d50 ^ d16 ^ d37 ^ 
        c15 ^ d76 ^ d39 ^ c25 ^ d71 ^ d56 ^ d28 ^ c8 ^ d80 ^ d58 ^ 
        d43 ^ c4 ^ d46 ^ c26 ^ d93 ^ d54 ^ d5 ^ d52 ^ d97 ^ d79 ^ 
        d34 ^ c5 ^ d60 ^ d68 ^ d24 ^ d103 ^ d21 ^ d15 ^ d41 ^ d77 ^ 
        d42 ^ d3;  // 61 ins 1 outs level 3

    assign x6 = c28 ^ c2 ^ d64 ^ d11 ^ c1 ^ c12 ^ d71 ^ d20 ^ d62 ^ 
        d92 ^ d21 ^ d84 ^ d1 ^ d4 ^ d8 ^ d55 ^ c3 ^ d51 ^ d73 ^ 
        d80 ^ d93 ^ d25 ^ d50 ^ d43 ^ c0 ^ d45 ^ d95 ^ d76 ^ d38 ^ 
        d30 ^ c10 ^ d65 ^ d54 ^ c8 ^ d66 ^ d47 ^ c21 ^ d79 ^ d74 ^ 
        d40 ^ d7 ^ d29 ^ d2 ^ d70 ^ d75 ^ d52 ^ d60 ^ c26 ^ d14 ^ 
        d42 ^ d81 ^ d98 ^ c9 ^ c11 ^ c23 ^ c20 ^ d41 ^ d72 ^ c7 ^ 
        d56 ^ d5 ^ d100 ^ d68 ^ d83 ^ d82 ^ d6 ^ c4 ^ d22;  // 68 ins 1 outs level 3

    assign x5 = d28 ^ c27 ^ c0 ^ d24 ^ d49 ^ c31 ^ d64 ^ c1 ^ d6 ^ 
        d81 ^ d46 ^ d40 ^ d29 ^ d83 ^ c2 ^ d10 ^ d21 ^ c19 ^ c7 ^ 
        d41 ^ d67 ^ d75 ^ d7 ^ d99 ^ d44 ^ d103 ^ c11 ^ d53 ^ c9 ^ 
        d20 ^ c20 ^ d71 ^ d37 ^ d59 ^ c6 ^ d1 ^ d54 ^ d73 ^ d4 ^ 
        d80 ^ d39 ^ d74 ^ c22 ^ d79 ^ c10 ^ d91 ^ d0 ^ d69 ^ d55 ^ 
        d70 ^ d78 ^ d65 ^ d5 ^ d50 ^ d42 ^ d94 ^ d13 ^ d63 ^ d72 ^ 
        c3 ^ d3 ^ c25 ^ d51 ^ d19 ^ d61 ^ d82 ^ d92 ^ d97 ^ c8;  // 69 ins 1 outs level 3

    assign x4 = d2 ^ c23 ^ d57 ^ d67 ^ c1 ^ d83 ^ c22 ^ d100 ^ d46 ^ 
        d44 ^ d20 ^ d18 ^ d40 ^ d12 ^ d0 ^ d84 ^ d19 ^ d8 ^ d45 ^ 
        d29 ^ d58 ^ d25 ^ d74 ^ c25 ^ d90 ^ d73 ^ d3 ^ c18 ^ c7 ^ 
        d11 ^ d97 ^ d39 ^ d24 ^ d70 ^ d15 ^ c19 ^ d77 ^ d38 ^ d59 ^ 
        d30 ^ d31 ^ d95 ^ d47 ^ c11 ^ c12 ^ d4 ^ d79 ^ d48 ^ d33 ^ 
        d65 ^ c31 ^ d41 ^ d50 ^ d68 ^ d103 ^ d69 ^ d94 ^ d63 ^ d86 ^ 
        d6 ^ c28 ^ c2 ^ d91 ^ c14 ^ c5;  // 65 ins 1 outs level 3

    assign x3 = c26 ^ d7 ^ d69 ^ d39 ^ d81 ^ c14 ^ d68 ^ c1 ^ d37 ^ 
        c25 ^ d89 ^ c28 ^ d85 ^ c17 ^ c12 ^ d52 ^ c9 ^ d10 ^ d19 ^ 
        d17 ^ d73 ^ d3 ^ d27 ^ d25 ^ d15 ^ d56 ^ d2 ^ d95 ^ c31 ^ 
        d76 ^ d90 ^ d103 ^ c27 ^ d8 ^ d58 ^ d53 ^ c8 ^ d9 ^ d54 ^ 
        d31 ^ d45 ^ d32 ^ d97 ^ d65 ^ d38 ^ d1 ^ c23 ^ d71 ^ d99 ^ 
        d36 ^ d18 ^ d80 ^ d59 ^ c13 ^ d40 ^ c4 ^ d98 ^ c18 ^ d14 ^ 
        d100 ^ d60 ^ d33 ^ d86 ^ d84;  // 64 ins 1 outs level 3

    assign x2 = d67 ^ d30 ^ c7 ^ d38 ^ c12 ^ d68 ^ d37 ^ d31 ^ d9 ^ 
        d44 ^ d2 ^ d7 ^ d57 ^ d96 ^ c16 ^ d1 ^ c30 ^ d13 ^ d55 ^ 
        d64 ^ d26 ^ d75 ^ d70 ^ d51 ^ d36 ^ d52 ^ d99 ^ d80 ^ d6 ^ 
        d97 ^ d16 ^ d17 ^ d59 ^ d24 ^ d8 ^ d94 ^ c3 ^ d35 ^ c11 ^ 
        d85 ^ d18 ^ c8 ^ d102 ^ c0 ^ d0 ^ c17 ^ d58 ^ c22 ^ d72 ^ 
        d39 ^ d79 ^ d88 ^ d98 ^ d14 ^ d53 ^ d83 ^ c25 ^ c26 ^ c27 ^ 
        d89 ^ c24 ^ c13 ^ d84 ^ d32;  // 64 ins 1 outs level 3

    assign x1 = d28 ^ d0 ^ d6 ^ d12 ^ c9 ^ c29 ^ c0 ^ d58 ^ d27 ^ 
        d51 ^ c15 ^ d13 ^ d34 ^ d7 ^ d9 ^ d37 ^ d69 ^ d81 ^ d24 ^ 
        d44 ^ d101 ^ c31 ^ d47 ^ c30 ^ d74 ^ d53 ^ d33 ^ d16 ^ c7 ^ 
        d35 ^ d59 ^ d17 ^ c28 ^ c2 ^ d64 ^ d11 ^ d62 ^ d86 ^ d100 ^ 
        c22 ^ d79 ^ d60 ^ d65 ^ d50 ^ d88 ^ d38 ^ d103 ^ d102 ^ c8 ^ 
        d94 ^ c16 ^ d56 ^ d49 ^ d63 ^ d80 ^ d1 ^ d46 ^ d87 ^ d72 ^ 
        c14;  // 60 ins 1 outs level 3

    assign x0 = d82 ^ d67 ^ d85 ^ d61 ^ c25 ^ d72 ^ d63 ^ d94 ^ d103 ^ 
        d68 ^ d50 ^ d65 ^ d83 ^ d60 ^ d79 ^ c22 ^ d9 ^ d54 ^ d16 ^ 
        d48 ^ d47 ^ d45 ^ d44 ^ c1 ^ d98 ^ c23 ^ d32 ^ d99 ^ c29 ^ 
        d55 ^ c9 ^ d31 ^ d30 ^ d10 ^ d29 ^ d26 ^ d81 ^ d84 ^ d96 ^ 
        d34 ^ c15 ^ c13 ^ c24 ^ c26 ^ d28 ^ d0 ^ d87 ^ c27 ^ d6 ^ 
        c31 ^ c12 ^ d12 ^ d53 ^ d58 ^ c0 ^ c11 ^ d95 ^ d24 ^ d97 ^ 
        d37 ^ d66 ^ c10 ^ c7 ^ d101 ^ d73 ^ d25;  // 66 ins 1 outs level 3

    assign x31 = c31 ^ d84 ^ d62 ^ d93 ^ d60 ^ c8 ^ d83 ^ d47 ^ d96 ^ 
        d97 ^ d86 ^ d65 ^ d44 ^ d24 ^ d72 ^ d15 ^ d9 ^ d33 ^ d5 ^ 
        d100 ^ d52 ^ c26 ^ d103 ^ d8 ^ d71 ^ c12 ^ d98 ^ d94 ^ c25 ^ 
        d27 ^ c22 ^ c11 ^ d31 ^ c9 ^ d78 ^ c23 ^ d46 ^ c21 ^ d49 ^ 
        c6 ^ c24 ^ d23 ^ d53 ^ d82 ^ d57 ^ d28 ^ d67 ^ d64 ^ d54 ^ 
        d80 ^ d66 ^ d30 ^ c28 ^ d11 ^ d81 ^ d29 ^ c10 ^ d43 ^ d25 ^ 
        d102 ^ d36 ^ c14 ^ d59 ^ c30 ^ c0 ^ d95;  // 66 ins 1 outs level 3

    assign x30 = c29 ^ c27 ^ d102 ^ d42 ^ d65 ^ d81 ^ d63 ^ d79 ^ d83 ^ 
        d52 ^ d23 ^ d27 ^ d80 ^ d8 ^ c25 ^ d95 ^ d43 ^ d10 ^ c24 ^ 
        c7 ^ d29 ^ c13 ^ d97 ^ d82 ^ d101 ^ d64 ^ d92 ^ c10 ^ d46 ^ 
        d93 ^ c22 ^ d85 ^ d99 ^ c30 ^ d26 ^ d96 ^ d53 ^ d28 ^ d32 ^ 
        c21 ^ d48 ^ d71 ^ d56 ^ d66 ^ d58 ^ d4 ^ c8 ^ c11 ^ d7 ^ 
        d35 ^ d30 ^ c20 ^ d22 ^ c23 ^ d70 ^ c5 ^ d61 ^ d51 ^ d59 ^ 
        d24 ^ d77 ^ c9 ^ d45 ^ d14 ^ d94;  // 65 ins 1 outs level 3

    assign x29 = c12 ^ c28 ^ d78 ^ d29 ^ c6 ^ d42 ^ c26 ^ d3 ^ d58 ^ 
        d47 ^ d81 ^ d92 ^ d63 ^ d96 ^ d26 ^ d45 ^ d84 ^ d94 ^ d21 ^ 
        d103 ^ d31 ^ d100 ^ c10 ^ c4 ^ d98 ^ d41 ^ d64 ^ d93 ^ d50 ^ 
        c20 ^ d80 ^ c24 ^ d25 ^ d60 ^ d34 ^ c7 ^ c29 ^ d57 ^ c8 ^ 
        d9 ^ d95 ^ d52 ^ d69 ^ d27 ^ d70 ^ c9 ^ c22 ^ d79 ^ d55 ^ 
        d91 ^ c23 ^ d65 ^ d13 ^ d62 ^ d76 ^ d82 ^ d28 ^ d7 ^ c21 ^ 
        d44 ^ c19 ^ d23 ^ d101 ^ d22 ^ c31 ^ d6 ^ d51;  // 67 ins 1 outs level 3

    assign x28 = d69 ^ d27 ^ d75 ^ c18 ^ d28 ^ d30 ^ c11 ^ d12 ^ d61 ^ 
        d2 ^ d68 ^ d6 ^ c5 ^ d20 ^ d94 ^ d81 ^ d77 ^ c22 ^ d95 ^ 
        d24 ^ d33 ^ d41 ^ c3 ^ c28 ^ c27 ^ d49 ^ c9 ^ d8 ^ d40 ^ 
        d91 ^ d78 ^ d44 ^ d22 ^ d26 ^ d63 ^ d100 ^ d80 ^ d90 ^ d5 ^ 
        d102 ^ d56 ^ d79 ^ c23 ^ c8 ^ c25 ^ d46 ^ c21 ^ d54 ^ d59 ^ 
        d97 ^ d21 ^ c7 ^ c30 ^ d50 ^ d51 ^ d57 ^ d99 ^ c19 ^ d83 ^ 
        d43 ^ d64 ^ d93 ^ d62 ^ d92 ^ c20 ^ c6 ^ d25;  // 67 ins 1 outs level 3

    assign x27 = c8 ^ d98 ^ c19 ^ d93 ^ d62 ^ d45 ^ d99 ^ d21 ^ d23 ^ 
        d29 ^ d90 ^ c21 ^ d27 ^ d82 ^ d50 ^ d61 ^ d74 ^ d42 ^ c7 ^ 
        d79 ^ c24 ^ c17 ^ c29 ^ d24 ^ d76 ^ d94 ^ d43 ^ d96 ^ c4 ^ 
        d40 ^ c2 ^ d67 ^ c18 ^ d92 ^ d49 ^ d19 ^ d101 ^ c27 ^ d5 ^ 
        d11 ^ d1 ^ d78 ^ d53 ^ d58 ^ d80 ^ d39 ^ d56 ^ d25 ^ d60 ^ 
        c10 ^ c22 ^ d7 ^ d32 ^ c26 ^ d26 ^ c6 ^ d63 ^ c20 ^ d4 ^ 
        d55 ^ d20 ^ d89 ^ c5 ^ d68 ^ d91 ^ d48 ^ d77;  // 67 ins 1 outs level 3

    assign x26 = d95 ^ d24 ^ c3 ^ d88 ^ d39 ^ d67 ^ c21 ^ d97 ^ d75 ^ 
        d22 ^ c23 ^ d93 ^ d6 ^ d81 ^ d10 ^ c28 ^ c16 ^ d0 ^ d41 ^ 
        d52 ^ d78 ^ c6 ^ d66 ^ d28 ^ d62 ^ d3 ^ d100 ^ d92 ^ d26 ^ 
        d31 ^ d49 ^ c25 ^ d79 ^ d89 ^ c17 ^ c5 ^ c26 ^ d61 ^ c9 ^ 
        d42 ^ d90 ^ d55 ^ d19 ^ c20 ^ d91 ^ d47 ^ d76 ^ d54 ^ d25 ^ 
        c18 ^ d4 ^ d98 ^ d59 ^ d23 ^ d38 ^ d77 ^ c19 ^ c1 ^ c7 ^ 
        d18 ^ d44 ^ d20 ^ d48 ^ d57 ^ d60 ^ c4 ^ d73;  // 67 ins 1 outs level 3

    assign x25 = d67 ^ c11 ^ d84 ^ d98 ^ d31 ^ d89 ^ d56 ^ d75 ^ d38 ^ 
        d90 ^ d18 ^ d77 ^ d17 ^ d3 ^ d76 ^ d64 ^ d62 ^ d95 ^ d58 ^ 
        c5 ^ d82 ^ c20 ^ c30 ^ c27 ^ c19 ^ d52 ^ c21 ^ d19 ^ d100 ^ 
        d92 ^ d48 ^ d41 ^ d91 ^ d21 ^ c17 ^ d87 ^ d61 ^ c18 ^ d2 ^ 
        d28 ^ d93 ^ d11 ^ c23 ^ c4 ^ c16 ^ d40 ^ c9 ^ d37 ^ d99 ^ 
        d22 ^ d8 ^ c28 ^ d88 ^ c26 ^ d86 ^ d36 ^ c3 ^ d44 ^ c10 ^ 
        c2 ^ c14 ^ d102 ^ d71 ^ d29 ^ d51 ^ c12 ^ d49 ^ d74 ^ d15 ^ 
        d33 ^ d81 ^ c15 ^ d57 ^ d83;  // 74 ins 1 outs level 3

    assign x24 = c8 ^ d48 ^ c16 ^ d30 ^ d80 ^ d1 ^ c20 ^ d89 ^ d2 ^ 
        c9 ^ d51 ^ d21 ^ d35 ^ d85 ^ d66 ^ d27 ^ d7 ^ c11 ^ d83 ^ 
        d28 ^ d88 ^ d56 ^ d40 ^ d10 ^ d99 ^ d63 ^ d90 ^ c13 ^ c31 ^ 
        d74 ^ d60 ^ c22 ^ d98 ^ c15 ^ c25 ^ c4 ^ d92 ^ d91 ^ c19 ^ 
        d76 ^ d16 ^ d20 ^ c10 ^ c26 ^ c3 ^ d37 ^ d101 ^ c14 ^ d14 ^ 
        d32 ^ d97 ^ d36 ^ d55 ^ d86 ^ d82 ^ d57 ^ d94 ^ d43 ^ d39 ^ 
        c1 ^ d50 ^ d47 ^ c18 ^ c2 ^ c17 ^ d87 ^ d103 ^ c27 ^ c29 ^ 
        d17 ^ d18 ^ d61 ^ d73 ^ d70 ^ d75 ^ d81;  // 76 ins 1 outs level 3

    assign x23 = d50 ^ d55 ^ d29 ^ d19 ^ d13 ^ d97 ^ c17 ^ d91 ^ c12 ^ 
        c19 ^ d87 ^ d93 ^ c2 ^ c7 ^ d75 ^ d89 ^ d27 ^ d39 ^ c3 ^ 
        c28 ^ d47 ^ d82 ^ c14 ^ d98 ^ c18 ^ c26 ^ d103 ^ d72 ^ c0 ^ 
        c31 ^ d17 ^ d69 ^ d15 ^ d73 ^ d6 ^ d31 ^ d36 ^ d0 ^ c10 ^ 
        d79 ^ c24 ^ d100 ^ c13 ^ d90 ^ c1 ^ c15 ^ d16 ^ d54 ^ d38 ^ 
        d86 ^ d1 ^ d65 ^ d46 ^ c21 ^ d80 ^ c25 ^ c9 ^ d49 ^ d56 ^ 
        d20 ^ d42 ^ c16 ^ d34 ^ d9 ^ c8 ^ d102 ^ d88 ^ d60 ^ d62 ^ 
        d59 ^ d35 ^ d85 ^ d74 ^ c30 ^ d96 ^ d84 ^ d81 ^ d26;  // 78 ins 1 outs level 3

    assign x22 = d58 ^ d11 ^ d31 ^ d19 ^ d61 ^ d73 ^ c27 ^ d35 ^ d26 ^ 
        d55 ^ d93 ^ c21 ^ d89 ^ d98 ^ d68 ^ d18 ^ d12 ^ d65 ^ c28 ^ 
        d94 ^ c17 ^ d36 ^ c26 ^ d24 ^ d101 ^ d43 ^ d38 ^ c7 ^ d90 ^ 
        d14 ^ c29 ^ c1 ^ c10 ^ d74 ^ d87 ^ d62 ^ d85 ^ c2 ^ c16 ^ 
        d66 ^ c18 ^ d41 ^ d37 ^ c20 ^ d57 ^ c13 ^ d0 ^ d52 ^ d23 ^ 
        c15 ^ d67 ^ d34 ^ d29 ^ d99 ^ d44 ^ d45 ^ d92 ^ d47 ^ d48 ^ 
        d9 ^ d88 ^ d27 ^ d16 ^ d100 ^ c22 ^ d79 ^ d60 ^ d82;  // 68 ins 1 outs level 3

    assign x21 = d99 ^ d56 ^ d94 ^ d49 ^ d61 ^ d102 ^ d87 ^ d34 ^ d37 ^ 
        d88 ^ d24 ^ d52 ^ d92 ^ d42 ^ d5 ^ d73 ^ d96 ^ d9 ^ d71 ^ 
        c17 ^ d51 ^ c15 ^ c24 ^ d27 ^ d29 ^ d95 ^ c30 ^ c27 ^ d35 ^ 
        d18 ^ d53 ^ c19 ^ d26 ^ c10 ^ c20 ^ d31 ^ d10 ^ d82 ^ d89 ^ 
        c1 ^ d91 ^ c11 ^ c23 ^ d83 ^ d62 ^ c22 ^ d40 ^ d22 ^ c16 ^ 
        d17 ^ d80 ^ c8 ^ d13;  // 53 ins 1 outs level 3

    assign x20 = d16 ^ d4 ^ d93 ^ d72 ^ c19 ^ c0 ^ d90 ^ c22 ^ d86 ^ 
        d88 ^ c16 ^ d34 ^ c7 ^ d21 ^ d28 ^ d98 ^ c14 ^ d91 ^ c21 ^ 
        d23 ^ d70 ^ d60 ^ d101 ^ c9 ^ d9 ^ d61 ^ d51 ^ d17 ^ c26 ^ 
        c23 ^ d36 ^ d55 ^ d33 ^ d87 ^ d48 ^ c10 ^ d12 ^ d50 ^ d79 ^ 
        d30 ^ d81 ^ d8 ^ d82 ^ c15 ^ c18 ^ d94 ^ d25 ^ c29 ^ d26 ^ 
        d52 ^ c31 ^ d103 ^ d41 ^ d39 ^ d95;  // 55 ins 1 outs level 3

    assign x19 = d69 ^ d50 ^ d16 ^ c18 ^ d59 ^ d102 ^ d60 ^ d32 ^ c22 ^ 
        d86 ^ d40 ^ d25 ^ c17 ^ d38 ^ d71 ^ d89 ^ d29 ^ d87 ^ d90 ^ 
        d51 ^ d85 ^ c25 ^ c15 ^ d97 ^ d22 ^ d47 ^ d103 ^ d80 ^ d15 ^ 
        c30 ^ d33 ^ d8 ^ d24 ^ d54 ^ d49 ^ c8 ^ d81 ^ c31 ^ d3 ^ 
        c9 ^ d93 ^ d7 ^ d27 ^ d78 ^ d35 ^ d92 ^ c21 ^ d94 ^ c28 ^ 
        c14 ^ c13 ^ d100 ^ c6 ^ d20 ^ c20 ^ d11;  // 56 ins 1 outs level 3

    assign x18 = d99 ^ c27 ^ d31 ^ d79 ^ d37 ^ d96 ^ d102 ^ c21 ^ d101 ^ 
        c19 ^ c12 ^ d68 ^ d84 ^ d93 ^ d85 ^ c30 ^ d49 ^ c14 ^ d70 ^ 
        d14 ^ d48 ^ d10 ^ d89 ^ c24 ^ d53 ^ c13 ^ d88 ^ d24 ^ c17 ^ 
        d46 ^ c5 ^ d32 ^ c16 ^ d86 ^ d2 ^ d80 ^ d26 ^ c8 ^ d39 ^ 
        d91 ^ c29 ^ d21 ^ d50 ^ d34 ^ d15 ^ d7 ^ d58 ^ d59 ^ d77 ^ 
        d28 ^ d92 ^ c20 ^ d19 ^ d23 ^ d6 ^ c7;  // 56 ins 1 outs level 3

    assign x17 = c23 ^ c28 ^ d76 ^ d58 ^ c20 ^ d85 ^ c26 ^ c6 ^ d90 ^ 
        c19 ^ d1 ^ d31 ^ d45 ^ d5 ^ d67 ^ c12 ^ d23 ^ d79 ^ d52 ^ 
        d33 ^ d91 ^ d25 ^ d78 ^ d84 ^ d69 ^ c4 ^ d57 ^ d13 ^ d27 ^ 
        d95 ^ d30 ^ c11 ^ d38 ^ d36 ^ c29 ^ c31 ^ d6 ^ d101 ^ c15 ^ 
        d18 ^ c16 ^ d83 ^ c13 ^ d49 ^ d20 ^ d48 ^ d22 ^ d88 ^ d47 ^ 
        d9 ^ d98 ^ d87 ^ d100 ^ d14 ^ c7 ^ d92 ^ d103 ^ c18;  // 58 ins 1 outs level 3

    assign x16 = d47 ^ d99 ^ d5 ^ d77 ^ d100 ^ d32 ^ c15 ^ d68 ^ c3 ^ 
        c22 ^ d4 ^ d75 ^ d82 ^ c10 ^ c11 ^ c28 ^ d19 ^ d8 ^ d26 ^ 
        d56 ^ d89 ^ c30 ^ d30 ^ d44 ^ d83 ^ c19 ^ d46 ^ d90 ^ d84 ^ 
        d103 ^ c6 ^ d29 ^ d78 ^ d51 ^ d22 ^ d48 ^ d12 ^ d21 ^ c12 ^ 
        d94 ^ c25 ^ d57 ^ d102 ^ d66 ^ d37 ^ c27 ^ d17 ^ d13 ^ d97 ^ 
        c18 ^ c31 ^ c17 ^ d24 ^ d35 ^ c5 ^ d86 ^ c14 ^ d91 ^ d87 ^ 
        d0;  // 60 ins 1 outs level 3

    assign x15 = d71 ^ d84 ^ c0 ^ d99 ^ d90 ^ d76 ^ d24 ^ c18 ^ d18 ^ 
        d9 ^ d8 ^ c16 ^ d89 ^ d101 ^ c4 ^ d16 ^ d62 ^ d85 ^ d53 ^ 
        d95 ^ d97 ^ c5 ^ d72 ^ d33 ^ d44 ^ c23 ^ d100 ^ d55 ^ d88 ^ 
        d21 ^ d50 ^ d45 ^ d7 ^ c17 ^ d94 ^ c2 ^ d5 ^ d57 ^ c28 ^ 
        c13 ^ d15 ^ c29 ^ d74 ^ d54 ^ d60 ^ d4 ^ d3 ^ c27 ^ c6 ^ 
        d52 ^ d30 ^ d56 ^ d49 ^ d59 ^ d64 ^ d27 ^ d77 ^ d66 ^ c25 ^ 
        d34 ^ d12 ^ c12 ^ d20 ^ c22 ^ d80 ^ c8 ^ d78;  // 67 ins 1 outs level 3

    assign x14 = c3 ^ d61 ^ d3 ^ d43 ^ d100 ^ d19 ^ d26 ^ d89 ^ d94 ^ 
        d14 ^ c5 ^ d65 ^ d32 ^ d4 ^ d71 ^ c17 ^ d93 ^ d77 ^ c31 ^ 
        d49 ^ d54 ^ d11 ^ d76 ^ c7 ^ d73 ^ d17 ^ d63 ^ d20 ^ d23 ^ 
        c15 ^ c4 ^ d87 ^ d59 ^ c22 ^ c26 ^ d99 ^ d2 ^ d96 ^ c16 ^ 
        d7 ^ c28 ^ d48 ^ d44 ^ c12 ^ d103 ^ d53 ^ d83 ^ d56 ^ c1 ^ 
        d88 ^ d8 ^ d6 ^ d51 ^ d55 ^ d52 ^ d58 ^ d98 ^ d29 ^ d84 ^ 
        d33 ^ d15 ^ c24 ^ c27 ^ d70 ^ d75 ^ c11 ^ d79 ^ c21;  // 68 ins 1 outs level 3

    assign x13 = d72 ^ d6 ^ d74 ^ d22 ^ c3 ^ d98 ^ d43 ^ d16 ^ c30 ^ 
        d102 ^ d1 ^ d10 ^ d53 ^ c16 ^ d60 ^ d88 ^ d92 ^ d52 ^ c20 ^ 
        d25 ^ c14 ^ d58 ^ d69 ^ d76 ^ d87 ^ c25 ^ d93 ^ d103 ^ d3 ^ 
        d5 ^ d70 ^ d55 ^ c23 ^ d83 ^ d51 ^ d95 ^ c21 ^ c0 ^ c27 ^ 
        c15 ^ c31 ^ d32 ^ d28 ^ d97 ^ c10 ^ d14 ^ d48 ^ d54 ^ d19 ^ 
        d75 ^ d50 ^ d31 ^ d99 ^ d2 ^ d47 ^ d86 ^ d62 ^ d42 ^ d7 ^ 
        d82 ^ d64 ^ d78 ^ d18 ^ c26 ^ c4 ^ d13 ^ c2 ^ d57 ^ c11 ^ 
        c6;  // 70 ins 1 outs level 3

    assign x12 = d6 ^ d47 ^ c25 ^ d97 ^ d52 ^ d102 ^ d49 ^ c10 ^ d50 ^ 
        d24 ^ d17 ^ d86 ^ d51 ^ d82 ^ d75 ^ d71 ^ d13 ^ d56 ^ c14 ^ 
        d27 ^ d15 ^ d92 ^ d68 ^ d54 ^ d81 ^ d42 ^ d57 ^ c2 ^ d5 ^ 
        d98 ^ d30 ^ d87 ^ d59 ^ d41 ^ d0 ^ c1 ^ d2 ^ d74 ^ d1 ^ 
        c26 ^ c30 ^ d53 ^ d94 ^ d73 ^ c5 ^ d77 ^ d63 ^ d9 ^ c20 ^ 
        d18 ^ d96 ^ d21 ^ c29 ^ d69 ^ d12 ^ c3 ^ c24 ^ d46 ^ d4 ^ 
        d91 ^ d61 ^ c22 ^ d31 ^ c9 ^ d101 ^ c13 ^ c15 ^ d85 ^ c19;  // 69 ins 1 outs level 3

    assign x11 = d64 ^ d76 ^ d90 ^ c2 ^ d56 ^ d98 ^ d33 ^ d0 ^ d1 ^ 
        c13 ^ d3 ^ d74 ^ d31 ^ d85 ^ d71 ^ d83 ^ c19 ^ d55 ^ d24 ^ 
        d51 ^ d4 ^ d41 ^ d36 ^ d82 ^ d27 ^ c11 ^ d20 ^ d102 ^ c29 ^ 
        d57 ^ c1 ^ d17 ^ d59 ^ c18 ^ d26 ^ c30 ^ d44 ^ d91 ^ d45 ^ 
        d78 ^ c6 ^ c4 ^ d28 ^ d15 ^ d14 ^ d40 ^ d25 ^ d65 ^ c31 ^ 
        d58 ^ d47 ^ d12 ^ d73 ^ c10 ^ c26 ^ d48 ^ d101 ^ d16 ^ d54 ^ 
        d66 ^ d9 ^ c22 ^ d50 ^ d68 ^ d103 ^ d94 ^ d70 ^ d43;  // 68 ins 1 outs level 3

    assign x10 = d52 ^ d69 ^ d2 ^ d14 ^ c17 ^ d66 ^ d3 ^ d42 ^ c18 ^ 
        d95 ^ d16 ^ d9 ^ d0 ^ d73 ^ d40 ^ d26 ^ d31 ^ d33 ^ d96 ^ 
        d86 ^ d89 ^ c6 ^ c3 ^ d56 ^ d62 ^ c22 ^ d77 ^ d35 ^ c11 ^ 
        d13 ^ c14 ^ d29 ^ d50 ^ d28 ^ d94 ^ c8 ^ d60 ^ c26 ^ c24 ^ 
        d83 ^ d90 ^ d39 ^ d80 ^ d55 ^ d5 ^ c5 ^ d19 ^ c29 ^ d78 ^ 
        d71 ^ d63 ^ d36 ^ d32 ^ d70 ^ d75 ^ c23 ^ d98 ^ d59 ^ d58 ^ 
        c1 ^ d101;  // 61 ins 1 outs level 3

    assign x9 = d51 ^ d12 ^ d4 ^ d38 ^ d76 ^ d35 ^ c26 ^ c16 ^ c8 ^ 
        d79 ^ c5 ^ d102 ^ d96 ^ d29 ^ c11 ^ d2 ^ d46 ^ d78 ^ d71 ^ 
        d5 ^ d33 ^ d52 ^ d13 ^ d85 ^ d11 ^ c9 ^ d32 ^ d43 ^ d66 ^ 
        d36 ^ c24 ^ d24 ^ d60 ^ d70 ^ d53 ^ d81 ^ d58 ^ d84 ^ c14 ^ 
        c13 ^ d34 ^ d55 ^ d39 ^ d68 ^ d9 ^ d18 ^ d23 ^ d77 ^ d61 ^ 
        d83 ^ d1 ^ d74 ^ d80 ^ d88 ^ c7 ^ d98 ^ d47 ^ d86 ^ d89 ^ 
        d64 ^ c2 ^ c30 ^ d44 ^ c17 ^ c6 ^ d67 ^ d41 ^ c12 ^ d69 ^ 
        c4;  // 70 ins 1 outs level 3

    assign x8 = d10 ^ d32 ^ c8 ^ d84 ^ d31 ^ d17 ^ c16 ^ d12 ^ c12 ^ 
        d3 ^ d38 ^ d69 ^ d33 ^ d63 ^ d87 ^ d88 ^ c29 ^ c23 ^ c4 ^ 
        d4 ^ d43 ^ d73 ^ c1 ^ d54 ^ d95 ^ d75 ^ d57 ^ c13 ^ d76 ^ 
        d11 ^ c15 ^ d77 ^ d101 ^ d51 ^ c7 ^ d45 ^ d79 ^ c5 ^ d8 ^ 
        c10 ^ d59 ^ d66 ^ d40 ^ c6 ^ d35 ^ d37 ^ d60 ^ d83 ^ c25 ^ 
        d1 ^ d97 ^ d46 ^ d65 ^ d23 ^ d85 ^ c31 ^ d70 ^ d50 ^ d22 ^ 
        c11 ^ d0 ^ c3 ^ d28 ^ d34 ^ d78 ^ d68 ^ d103 ^ d42 ^ d67 ^ 
        d52 ^ d80 ^ d82;  // 72 ins 1 outs level 3

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat104_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [103:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x306, x305, x304, x303, x302, x301, x300, 
       x299, x298, x297, x296, x295, x294, x293, x292, 
       x291, x290, x289, x288, x287, x286, x285, x284, 
       x283, x282, x281, x280, x279, x278, x277, x276, 
       x275, x274, x273, x272, x271, x270, x269, x268, 
       x267, x266, x265, x264, x263, x262, x261, x260, 
       x259, x258, x257, x256, x255, x254, x253, x252, 
       x251, x250, x249, x248, x247, x246, x245, x244, 
       x243, x242, x241, x240, x239, x238, x237, x236, 
       x235, x234, x233, x232, x231, x230, x229, x228, 
       x227, x226, x225, x224, x223, x222, x221, x220, 
       x219, x218, x217, x216, x215, x214, x213, x212, 
       x211, x210, x209, x208, x207, x206, x205, x204, 
       x203, x202, x201, x200, x199, x198, x197, x196, 
       x195, x194, x193, x192, x191, x190, x189, x188, 
       x187, x186, x185, x184, x183, x182, x181, x180, 
       x179, x178, x177, x176, x175, x174, x173, x172, 
       x171, x170, x169, x168, x167, x166, x165, x164, 
       x163, x162, x161, x160, x159, x158, x157, x156, 
       x155, x154, x153, x152, x151, x150, x149, x148, 
       x147, x146, x145, x144, x143, x142, x141, x140, 
       x139, x138, x137, x135, x134, x133, x132, x131, 
       x130, x129, x128, x127, x126, x125, x124, x123, 
       x122, x121, x120, x119, x118, x117, x116, x115, 
       x113, x112, x111, x110, x109, x108, x107, x106, 
       x105, x104, x103, x102, x101, x100, x99, x98, 
       x97, x96, x95, x94, x93, x92, x91, x90, 
       x89, x88, x87, x86, x85, x84, x83, x82, 
       x81, x80, x79, x78, x77, x76, x74, x73, 
       x72, x71, x70, x69, x68, x67, x66, x65, 
       x64, x63, x62, x61, x60, x59, x58, x57, 
       x56, x55, x54, x53, x52, x51, x50, x49, 
       x48, x47, x46, x45, x44, x43, x42, x41, 
       x40, x39, x38, x37, x36, x35, x34, x33, 
       x32, x7, x6, x5, x4, x3, x2, x1, 
       x0, x31, x30, x29, x28, x27, x26, x25, 
       x24, x23, x22, x21, x20, x19, x18, x17, 
       x16, x15, x14, x13, x12, x11, x10, x9, 
       x8;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63,d64,d65,d66,d67,d68,d69,d70,d71,d72,d73,d74,d75,d76,d77,d78,
    d79,d80,d81,d82,d83,d84,d85,d86,d87,d88,d89,d90,d91,d92,d93,d94,
    d95,d96,d97,d98,d99,d100,d101,d102,d103;

assign { d103,d102,d101,d100,d99,d98,d97,d96,d95,d94,d93,d92,d91,d90,d89,
        d88,d87,d86,d85,d84,d83,d82,d81,d80,d79,d78,d77,d76,d75,d74,d73,
        d72,d71,d70,d69,d68,d67,d66,d65,d64,d63,d62,d61,d60,d59,d58,d57,
        d56,d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [103:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x306i (.out(x306),.a(x299),.b(x33),.c(x39),.d(x36),.e(x55),.f(x304));  // 6 ins 1 outs level 2

    xor6 x305i (.out(x305),.a(x300),.b(x62),.c(x60),.d(x301),.e(x302),.f(x303));  // 6 ins 1 outs level 2

    xor6 x304i (.out(x304),.a(d46),.b(d22),.c(d68),.d(d24),.e(d70),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x303i (.out(x303),.a(d97),.b(c3),.c(d28),.d(d32),.e(d50),.f(d66));  // 6 ins 1 outs level 1

    xor6 x302i (.out(x302),.a(d88),.b(d42),.c(d33),.d(d51),.e(d19),.f(d11));  // 6 ins 1 outs level 1

    xor6 x301i (.out(x301),.a(c29),.b(d101),.c(d85),.d(c6),.e(c16),.f(d40));  // 6 ins 1 outs level 1

    xor6 x300i (.out(x300),.a(d38),.b(d6),.c(c13),.d(d8),.e(c27),.f(d17));  // 6 ins 1 outs level 1

    xor6 x299i (.out(x299),.a(d87),.b(d78),.c(d62),.d(d1),.e(d82),.f(c10));  // 6 ins 1 outs level 1

    xor6 x298i (.out(x298),.a(x53),.b(x291),.c(x62),.d(x38),.e(x40),.f(x34));  // 6 ins 1 outs level 2

    xor6 x297i (.out(x297),.a(x292),.b(x296),.c(x41),.d(x293),.e(x294),.f(x295));  // 6 ins 1 outs level 2

    xor6 x296i (.out(x296),.a(d12),.b(d66),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x295i (.out(x295),.a(c20),.b(c16),.c(d60),.d(d61),.e(c8),.f(c24));  // 6 ins 1 outs level 1

    xor6 x294i (.out(x294),.a(d34),.b(c7),.c(d41),.d(d82),.e(d33),.f(d13));  // 6 ins 1 outs level 1

    xor6 x293i (.out(x293),.a(d52),.b(d5),.c(d86),.d(d25),.e(d46),.f(d76));  // 6 ins 1 outs level 1

    xor6 x292i (.out(x292),.a(c4),.b(d53),.c(d68),.d(d79),.e(c14),.f(d50));  // 6 ins 1 outs level 1

    xor6 x291i (.out(x291),.a(d80),.b(d59),.c(d11),.d(d14),.e(d71),.f(d69));  // 6 ins 1 outs level 1

    xor6 x290i (.out(x290),.a(x284),.b(x65),.c(x37),.d(x56),.e(x36),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x289i (.out(x289),.a(x285),.b(c6),.c(x286),.d(x287),.e(x288),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x288i (.out(x288),.a(c24),.b(d86),.c(d28),.d(d33),.e(d26),.f(d13));  // 6 ins 1 outs level 1

    xor6 x287i (.out(x287),.a(c22),.b(d55),.c(d78),.d(c14),.e(d14),.f(d50));  // 6 ins 1 outs level 1

    xor6 x286i (.out(x286),.a(d63),.b(d9),.c(d77),.d(c23),.e(d59),.f(d75));  // 6 ins 1 outs level 1

    xor6 x285i (.out(x285),.a(d96),.b(d16),.c(c5),.d(d61),.e(d97),.f(d76));  // 6 ins 1 outs level 1

    xor6 x284i (.out(x284),.a(d30),.b(c26),.c(d36),.d(d98),.e(d40),.f(d69));  // 6 ins 1 outs level 1

    xor6 x283i (.out(x283),.a(x281),.b(x65),.c(x46),.d(x36),.e(x35),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x282i (.out(x282),.a(x276),.b(x53),.c(x277),.d(x278),.e(x279),.f(x280));  // 6 ins 1 outs level 2

    xor6 x281i (.out(x281),.a(d16),.b(d65),.c(d24),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x280i (.out(x280),.a(d59),.b(d58),.c(c31),.d(d54),.e(d12),.f(c4));  // 6 ins 1 outs level 1

    xor6 x279i (.out(x279),.a(d48),.b(d28),.c(d45),.d(d4),.e(d61),.f(d33));  // 6 ins 1 outs level 1

    xor6 x278i (.out(x278),.a(d92),.b(d41),.c(d68),.d(d70),.e(d44),.f(d26));  // 6 ins 1 outs level 1

    xor6 x277i (.out(x277),.a(d103),.b(d96),.c(d15),.d(d40),.e(d76),.f(d38));  // 6 ins 1 outs level 1

    xor6 x276i (.out(x276),.a(d57),.b(d17),.c(d20),.d(d30),.e(d51),.f(d3));  // 6 ins 1 outs level 1

    xor6 x275i (.out(x275),.a(x46),.b(x32),.c(x35),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 2

    xor6 x274i (.out(x274),.a(x50),.b(x270),.c(x273),.d(x36),.e(x271),.f(x272));  // 6 ins 1 outs level 2

    xor6 x273i (.out(x273),.a(d46),.b(c24),.c(d49),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x272i (.out(x272),.a(d50),.b(d2),.c(c15),.d(c18),.e(d27),.f(c13));  // 6 ins 1 outs level 1

    xor6 x271i (.out(x271),.a(d15),.b(d13),.c(d75),.d(d21),.e(d6),.f(d74));  // 6 ins 1 outs level 1

    xor6 x270i (.out(x270),.a(d54),.b(d53),.c(d52),.d(c16),.e(d69),.f(d18));  // 6 ins 1 outs level 1

    xor6 x269i (.out(x269),.a(x264),.b(x39),.c(x65),.d(x47),.e(x49),.f(x52));  // 6 ins 1 outs level 2

    xor6 x268i (.out(x268),.a(d13),.b(x265),.c(x56),.d(x50),.e(x266),.f(x267));  // 6 ins 1 outs level 2

    xor6 x267i (.out(x267),.a(d31),.b(d39),.c(d88),.d(d92),.e(d72),.f(d1));  // 6 ins 1 outs level 1

    xor6 x266i (.out(x266),.a(d26),.b(d62),.c(d10),.d(d18),.e(c20),.f(c10));  // 6 ins 1 outs level 1

    xor6 x265i (.out(x265),.a(c7),.b(d51),.c(d57),.d(c0),.e(d60),.f(c15));  // 6 ins 1 outs level 1

    xor6 x264i (.out(x264),.a(d14),.b(d16),.c(d17),.d(c18),.e(d27),.f(d79));  // 6 ins 1 outs level 1

    xor6 x263i (.out(x263),.a(x56),.b(x64),.c(x41),.d(x48),.e(x43),.f(x47));  // 6 ins 1 outs level 2

    xor6 x262i (.out(x262),.a(x256),.b(x261),.c(x257),.d(x258),.e(x259),.f(x260));  // 6 ins 1 outs level 2

    xor6 x261i (.out(x261),.a(c24),.b(c26),.c(d18),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x260i (.out(x260),.a(c22),.b(d51),.c(d59),.d(d39),.e(d43),.f(d23));  // 6 ins 1 outs level 1

    xor6 x259i (.out(x259),.a(d98),.b(d73),.c(c23),.d(c15),.e(c16),.f(c1));  // 6 ins 1 outs level 1

    xor6 x258i (.out(x258),.a(d57),.b(d96),.c(d17),.d(d69),.e(d11),.f(d15));  // 6 ins 1 outs level 1

    xor6 x257i (.out(x257),.a(d55),.b(d56),.c(c27),.d(d20),.e(d61),.f(d63));  // 6 ins 1 outs level 1

    xor6 x256i (.out(x256),.a(d28),.b(c3),.c(d14),.d(d95),.e(d29),.f(d87));  // 6 ins 1 outs level 1

    xor6 x255i (.out(x255),.a(d74),.b(x249),.c(x41),.d(x40),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x254i (.out(x254),.a(x250),.b(x33),.c(x48),.d(x253),.e(x251),.f(x252));  // 6 ins 1 outs level 2

    xor6 x253i (.out(x253),.a(c22),.b(d84),.c(d27),.d(d58),.e(c6),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x252i (.out(x252),.a(d20),.b(c13),.c(d64),.d(d78),.e(c7),.f(d55));  // 6 ins 1 outs level 1

    xor6 x251i (.out(x251),.a(d45),.b(d12),.c(d57),.d(d15),.e(d16),.f(d9));  // 6 ins 1 outs level 1

    xor6 x250i (.out(x250),.a(d50),.b(c16),.c(d5),.d(d97),.e(d90),.f(d61));  // 6 ins 1 outs level 1

    xor6 x249i (.out(x249),.a(d21),.b(d75),.c(d34),.d(c12),.e(d85),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x248i (.out(x248),.a(x246),.b(d13),.c(x61),.d(x35),.e(x34),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x247i (.out(x247),.a(x241),.b(x50),.c(x242),.d(x243),.e(x244),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x246i (.out(x246),.a(d32),.b(d82),.c(c31),.d(c6),.e(d59),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x245i (.out(x245),.a(d35),.b(d26),.c(d37),.d(d19),.e(d89),.f(d47));  // 6 ins 1 outs level 1

    xor6 x244i (.out(x244),.a(d46),.b(d51),.c(d78),.d(d44),.e(d103),.f(d99));  // 6 ins 1 outs level 1

    xor6 x243i (.out(x243),.a(c17),.b(d30),.c(d48),.d(d66),.e(d8),.f(d100));  // 6 ins 1 outs level 1

    xor6 x242i (.out(x242),.a(d21),.b(d0),.c(d75),.d(d94),.e(d92),.f(c16));  // 6 ins 1 outs level 1

    xor6 x241i (.out(x241),.a(d63),.b(c15),.c(d56),.d(d29),.e(d42),.f(c28));  // 6 ins 1 outs level 1

    xor6 x240i (.out(x240),.a(x237),.b(x37),.c(x53),.d(x34),.e(x238),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x239i (.out(x239),.a(d25),.b(x233),.c(x39),.d(x234),.e(x235),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x238i (.out(x238),.a(d90),.b(c16),.c(d67),.d(c29),.e(c18),.f(d22));  // 6 ins 1 outs level 1

    xor6 x237i (.out(x237),.a(d9),.b(d85),.c(d88),.d(d8),.e(d13),.f(d3));  // 6 ins 1 outs level 1

    xor6 x236i (.out(x236),.a(c19),.b(c6),.c(d30),.d(c26),.e(d91),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x235i (.out(x235),.a(d5),.b(c23),.c(d98),.d(d48),.e(d27),.f(d92));  // 6 ins 1 outs level 1

    xor6 x234i (.out(x234),.a(d20),.b(d87),.c(c7),.d(d78),.e(c15),.f(d31));  // 6 ins 1 outs level 1

    xor6 x233i (.out(x233),.a(d23),.b(d47),.c(d45),.d(d18),.e(c20),.f(d101));  // 6 ins 1 outs level 1

    xor6 x232i (.out(x232),.a(x225),.b(x41),.c(x230),.d(x47),.e(x46),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x231i (.out(x231),.a(x226),.b(x55),.c(x227),.d(x228),.e(x229),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x230i (.out(x230),.a(d4),.b(d79),.c(c20),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x229i (.out(x229),.a(c19),.b(d91),.c(d92),.d(c17),.e(d46),.f(d50));  // 6 ins 1 outs level 1

    xor6 x228i (.out(x228),.a(d88),.b(d58),.c(c8),.d(c24),.e(d89),.f(c15));  // 6 ins 1 outs level 1

    xor6 x227i (.out(x227),.a(d9),.b(d14),.c(d68),.d(c13),.e(d86),.f(d23));  // 6 ins 1 outs level 1

    xor6 x226i (.out(x226),.a(c16),.b(c12),.c(d84),.d(d31),.e(c29),.f(d101));  // 6 ins 1 outs level 1

    xor6 x225i (.out(x225),.a(c14),.b(d15),.c(d6),.d(d80),.e(d21),.f(d49));  // 6 ins 1 outs level 1

    xor6 x224i (.out(x224),.a(x48),.b(x61),.c(x64),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 2

    xor6 x223i (.out(x223),.a(x218),.b(x222),.c(x38),.d(x219),.e(x220),.f(x221));  // 6 ins 1 outs level 2

    xor6 x222i (.out(x222),.a(d25),.b(c6),.c(d54),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x221i (.out(x221),.a(d69),.b(c31),.c(d92),.d(d87),.e(d57),.f(c21));  // 6 ins 1 outs level 1

    xor6 x220i (.out(x220),.a(d86),.b(c14),.c(d32),.d(c22),.e(c27),.f(d3));  // 6 ins 1 outs level 1

    xor6 x219i (.out(x219),.a(c15),.b(d93),.c(d65),.d(d47),.e(c13),.f(d90));  // 6 ins 1 outs level 1

    xor6 x218i (.out(x218),.a(d78),.b(d29),.c(d62),.d(d7),.e(d50),.f(d16));  // 6 ins 1 outs level 1

    xor6 x217i (.out(x217),.a(x212),.b(x216),.c(x45),.d(x213),.e(x214),.f(x215));  // 6 ins 1 outs level 2

    xor6 x216i (.out(x216),.a(d88),.b(d79),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x215i (.out(x215),.a(c31),.b(d55),.c(d60),.d(d51),.e(c10),.f(d103));  // 6 ins 1 outs level 1

    xor6 x214i (.out(x214),.a(c15),.b(c26),.c(d34),.d(d8),.e(d98),.f(d9));  // 6 ins 1 outs level 1

    xor6 x213i (.out(x213),.a(d52),.b(d36),.c(d82),.d(d30),.e(d40),.f(d33));  // 6 ins 1 outs level 1

    xor6 x212i (.out(x212),.a(d39),.b(d12),.c(d4),.d(d90),.e(d92),.f(d95));  // 6 ins 1 outs level 1

    xor6 x211i (.out(x211),.a(d23),.b(d25),.c(c7),.d(c23),.e(d50),.f(d16));  // 6 ins 1 outs level 1

    xor6 x210i (.out(x210),.a(x204),.b(x209),.c(x205),.d(x206),.e(x207),.f(x208));  // 6 ins 1 outs level 2

    xor6 x209i (.out(x209),.a(d13),.b(d62),.c(d31),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x208i (.out(x208),.a(c8),.b(d51),.c(d80),.d(d42),.e(d82),.f(c23));  // 6 ins 1 outs level 1

    xor6 x207i (.out(x207),.a(d52),.b(d26),.c(c24),.d(c20),.e(d94),.f(d40));  // 6 ins 1 outs level 1

    xor6 x206i (.out(x206),.a(d49),.b(d53),.c(c1),.d(c16),.e(d17),.f(d73));  // 6 ins 1 outs level 1

    xor6 x205i (.out(x205),.a(d95),.b(d35),.c(d44),.d(d56),.e(d71),.f(d87));  // 6 ins 1 outs level 1

    xor6 x204i (.out(x204),.a(d22),.b(d24),.c(d5),.d(d61),.e(d85),.f(d99));  // 6 ins 1 outs level 1

    xor6 x203i (.out(x203),.a(x197),.b(x62),.c(x40),.d(x53),.e(x43),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x202i (.out(x202),.a(x198),.b(x201),.c(x45),.d(x55),.e(x199),.f(x200));  // 6 ins 1 outs level 2

    xor6 x201i (.out(x201),.a(d16),.b(d92),.c(d85),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x200i (.out(x200),.a(c22),.b(d79),.c(c16),.d(d10),.e(c20),.f(d87));  // 6 ins 1 outs level 1

    xor6 x199i (.out(x199),.a(c28),.b(d99),.c(d62),.d(d50),.e(d1),.f(d100));  // 6 ins 1 outs level 1

    xor6 x198i (.out(x198),.a(d27),.b(d12),.c(d60),.d(c10),.e(d11),.f(d28));  // 6 ins 1 outs level 1

    xor6 x197i (.out(x197),.a(d24),.b(d57),.c(d9),.d(d52),.e(d41),.f(d66));  // 6 ins 1 outs level 1

    xor6 x196i (.out(x196),.a(x189),.b(x59),.c(x39),.d(x46),.e(x36),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x195i (.out(x195),.a(x190),.b(x194),.c(x53),.d(x191),.e(x192),.f(x193));  // 6 ins 1 outs level 2

    xor6 x194i (.out(x194),.a(d46),.b(d16),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x193i (.out(x193),.a(d39),.b(c24),.c(c3),.d(d49),.e(c15),.f(d59));  // 6 ins 1 outs level 1

    xor6 x192i (.out(x192),.a(d34),.b(d65),.c(c18),.d(c7),.e(d14),.f(c12));  // 6 ins 1 outs level 1

    xor6 x191i (.out(x191),.a(d100),.b(d15),.c(d20),.d(d19),.e(c28),.f(d97));  // 6 ins 1 outs level 1

    xor6 x190i (.out(x190),.a(d75),.b(c19),.c(d84),.d(d91),.e(d88),.f(d42));  // 6 ins 1 outs level 1

    xor6 x189i (.out(x189),.a(d13),.b(d56),.c(d26),.d(d54),.e(c21),.f(d93));  // 6 ins 1 outs level 1

    xor6 x188i (.out(x188),.a(x33),.b(x182),.c(x65),.d(x35),.e(x38),.f(x55));  // 6 ins 1 outs level 2

    xor6 x187i (.out(x187),.a(x183),.b(x56),.c(x40),.d(x186),.e(x184),.f(x185));  // 6 ins 1 outs level 2

    xor6 x186i (.out(x186),.a(d16),.b(d76),.c(c1),.d(d63),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x185i (.out(x185),.a(d75),.b(c31),.c(d73),.d(d40),.e(d99),.f(d34));  // 6 ins 1 outs level 1

    xor6 x184i (.out(x184),.a(d20),.b(d97),.c(c4),.d(d48),.e(d38),.f(d21));  // 6 ins 1 outs level 1

    xor6 x183i (.out(x183),.a(c3),.b(d35),.c(d85),.d(d7),.e(d19),.f(d71));  // 6 ins 1 outs level 1

    xor6 x182i (.out(x182),.a(d44),.b(d43),.c(d103),.d(d90),.e(d28),.f(d62));  // 6 ins 1 outs level 1

    xor6 x181i (.out(x181),.a(x175),.b(x50),.c(x48),.d(x43),.e(x40),.f(x32));  // 6 ins 1 outs level 2

    xor6 x180i (.out(x180),.a(x176),.b(x34),.c(x38),.d(x179),.e(x177),.f(x178));  // 6 ins 1 outs level 2

    xor6 x179i (.out(x179),.a(d47),.b(d56),.c(d37),.d(d11),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x178i (.out(x178),.a(c3),.b(d2),.c(d71),.d(d67),.e(d61),.f(c15));  // 6 ins 1 outs level 1

    xor6 x177i (.out(x177),.a(d99),.b(d26),.c(d29),.d(d57),.e(d38),.f(d90));  // 6 ins 1 outs level 1

    xor6 x176i (.out(x176),.a(d74),.b(d77),.c(d54),.d(d36),.e(d19),.f(d15));  // 6 ins 1 outs level 1

    xor6 x175i (.out(x175),.a(c5),.b(d64),.c(d31),.d(c22),.e(d70),.f(d62));  // 6 ins 1 outs level 1

    xor6 x174i (.out(x174),.a(x168),.b(d78),.c(x43),.d(x40),.e(x36),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x173i (.out(x173),.a(x169),.b(x41),.c(x170),.d(x171),.e(x172),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x172i (.out(x172),.a(c19),.b(d91),.c(d62),.d(c26),.e(d98),.f(d92));  // 6 ins 1 outs level 1

    xor6 x171i (.out(x171),.a(d47),.b(d60),.c(c18),.d(d5),.e(d79),.f(d25));  // 6 ins 1 outs level 1

    xor6 x170i (.out(x170),.a(d49),.b(d22),.c(c6),.d(d10),.e(c28),.f(d20));  // 6 ins 1 outs level 1

    xor6 x169i (.out(x169),.a(d100),.b(d39),.c(d51),.d(d6),.e(c7),.f(d61));  // 6 ins 1 outs level 1

    xor6 x168i (.out(x168),.a(d1),.b(d38),.c(c16),.d(d55),.e(d35),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x167i (.out(x167),.a(x45),.b(x62),.c(x35),.d(x47),.e(x33),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x166i (.out(x166),.a(x162),.b(x52),.c(x43),.d(x165),.e(x163),.f(x164));  // 6 ins 1 outs level 2

    xor6 x165i (.out(x165),.a(d32),.b(d40),.c(d20),.d(d35),.e(d89),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x164i (.out(x164),.a(d47),.b(d64),.c(c20),.d(d42),.e(d27),.f(c24));  // 6 ins 1 outs level 1

    xor6 x163i (.out(x163),.a(d79),.b(d5),.c(c25),.d(d39),.e(d96),.f(d56));  // 6 ins 1 outs level 1

    xor6 x162i (.out(x162),.a(d11),.b(c4),.c(d1),.d(c17),.e(d59),.f(d49));  // 6 ins 1 outs level 1

    xor6 x161i (.out(x161),.a(c27),.b(d76),.c(d28),.d(d12),.e(d45),.f(d21));  // 6 ins 1 outs level 1

    xor6 x160i (.out(x160),.a(x154),.b(x43),.c(x65),.d(x61),.e(x33),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x159i (.out(x159),.a(x155),.b(x158),.c(x38),.d(x52),.e(x156),.f(x157));  // 6 ins 1 outs level 2

    xor6 x158i (.out(x158),.a(d99),.b(d46),.c(d4),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x157i (.out(x157),.a(d95),.b(d60),.c(d75),.d(d20),.e(d97),.f(d44));  // 6 ins 1 outs level 1

    xor6 x156i (.out(x156),.a(c3),.b(c10),.c(d5),.d(d54),.e(c7),.f(d79));  // 6 ins 1 outs level 1

    xor6 x155i (.out(x155),.a(d50),.b(d6),.c(d30),.d(d2),.e(d94),.f(d70));  // 6 ins 1 outs level 1

    xor6 x154i (.out(x154),.a(d56),.b(d48),.c(d61),.d(c23),.e(d29),.f(d69));  // 6 ins 1 outs level 1

    xor6 x153i (.out(x153),.a(x147),.b(x33),.c(x37),.d(x39),.e(x52),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x152i (.out(x152),.a(x43),.b(x148),.c(x60),.d(x151),.e(x149),.f(x150));  // 6 ins 1 outs level 2

    xor6 x151i (.out(x151),.a(d13),.b(d7),.c(d68),.d(d42),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x150i (.out(x150),.a(c24),.b(d27),.c(d40),.d(c4),.e(d34),.f(c23));  // 6 ins 1 outs level 1

    xor6 x149i (.out(x149),.a(d96),.b(d74),.c(c28),.d(d101),.e(d94),.f(c29));  // 6 ins 1 outs level 1

    xor6 x148i (.out(x148),.a(c12),.b(d23),.c(d48),.d(d9),.e(d31),.f(d44));  // 6 ins 1 outs level 1

    xor6 x147i (.out(x147),.a(d63),.b(c25),.c(c2),.d(d22),.e(d100),.f(d84));  // 6 ins 1 outs level 1

    xor6 x146i (.out(x146),.a(x139),.b(x38),.c(x47),.d(x65),.e(x41),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x145i (.out(x145),.a(x140),.b(x46),.c(x141),.d(x142),.e(x143),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x144i (.out(x144),.a(c8),.b(c18),.c(d22),.d(d9),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x143i (.out(x143),.a(d65),.b(d97),.c(d14),.d(d52),.e(c23),.f(d46));  // 6 ins 1 outs level 1

    xor6 x142i (.out(x142),.a(d92),.b(d45),.c(d64),.d(d70),.e(d80),.f(c10));  // 6 ins 1 outs level 1

    xor6 x141i (.out(x141),.a(c13),.b(c24),.c(d43),.d(d23),.e(d8),.f(d42));  // 6 ins 1 outs level 1

    xor6 x140i (.out(x140),.a(d82),.b(d35),.c(d58),.d(d95),.e(c22),.f(d79));  // 6 ins 1 outs level 1

    xor6 x139i (.out(x139),.a(d63),.b(d57),.c(c27),.d(c25),.e(d32),.f(d10));  // 6 ins 1 outs level 1

    xor6 x138i (.out(x138),.a(x46),.b(x64),.c(x32),.d(x52),.e(x59),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x137i (.out(x137),.a(x132),.b(x34),.c(x133),.d(x134),.e(x135),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x135i (.out(x135),.a(d86),.b(d46),.c(c2),.d(d54),.e(c21),.f(c23));  // 6 ins 1 outs level 1

    xor6 x134i (.out(x134),.a(c31),.b(d93),.c(d11),.d(d52),.e(d36),.f(c14));  // 6 ins 1 outs level 1

    xor6 x133i (.out(x133),.a(d66),.b(d27),.c(d67),.d(d29),.e(d23),.f(d5));  // 6 ins 1 outs level 1

    xor6 x132i (.out(x132),.a(d53),.b(d95),.c(d31),.d(d28),.e(c22),.f(d44));  // 6 ins 1 outs level 1

    xor6 x131i (.out(x131),.a(x124),.b(x41),.c(x45),.d(x59),.e(x36),.f(x34));  // 6 ins 1 outs level 2

    xor6 x130i (.out(x130),.a(x125),.b(x47),.c(x129),.d(x126),.e(x127),.f(x128));  // 6 ins 1 outs level 2

    xor6 x129i (.out(x129),.a(d74),.b(d57),.c(c24),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x128i (.out(x128),.a(d97),.b(d85),.c(d87),.d(d7),.e(d32),.f(d30));  // 6 ins 1 outs level 1

    xor6 x127i (.out(x127),.a(c13),.b(c23),.c(c2),.d(d54),.e(d95),.f(d65));  // 6 ins 1 outs level 1

    xor6 x126i (.out(x126),.a(d58),.b(d48),.c(d16),.d(d66),.e(d44),.f(c22));  // 6 ins 1 outs level 1

    xor6 x125i (.out(x125),.a(c18),.b(d28),.c(d25),.d(d69),.e(d67),.f(d45));  // 6 ins 1 outs level 1

    xor6 x124i (.out(x124),.a(d60),.b(d9),.c(d96),.d(d24),.e(c25),.f(d26));  // 6 ins 1 outs level 1

    xor6 x123i (.out(x123),.a(x64),.b(x48),.c(x50),.d(x39),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x122i (.out(x122),.a(x118),.b(x55),.c(x119),.d(x120),.e(x121),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x121i (.out(x121),.a(d46),.b(d0),.c(d47),.d(d63),.e(d12),.f(d28));  // 6 ins 1 outs level 1

    xor6 x120i (.out(x120),.a(c22),.b(c25),.c(d16),.d(d50),.e(d10),.f(c30));  // 6 ins 1 outs level 1

    xor6 x119i (.out(x119),.a(c29),.b(d27),.c(d74),.d(d44),.e(d71),.f(d102));  // 6 ins 1 outs level 1

    xor6 x118i (.out(x118),.a(d99),.b(d35),.c(d13),.d(d56),.e(d51),.f(d81));  // 6 ins 1 outs level 1

    xor6 x117i (.out(x117),.a(d9),.b(c9),.c(d64),.d(d88),.e(d58),.f(d101));  // 6 ins 1 outs level 1

    xor6 x116i (.out(x116),.a(x46),.b(x62),.c(x53),.d(x56),.e(x34),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x115i (.out(x115),.a(c24),.b(x110),.c(c8),.d(x111),.e(x112),.f(x113));  // 6 ins 1 outs level 2

    xor6 x113i (.out(x113),.a(d79),.b(d55),.c(d16),.d(d6),.e(d0),.f(c16));  // 6 ins 1 outs level 1

    xor6 x112i (.out(x112),.a(d52),.b(d23),.c(d51),.d(d24),.e(d75),.f(d26));  // 6 ins 1 outs level 1

    xor6 x111i (.out(x111),.a(d13),.b(d68),.c(d17),.d(c25),.e(d31),.f(c3));  // 6 ins 1 outs level 1

    xor6 x110i (.out(x110),.a(d97),.b(d8),.c(c2),.d(d94),.e(d37),.f(d64));  // 6 ins 1 outs level 1

    xor6 x109i (.out(x109),.a(c22),.b(d30),.c(d59),.d(d80),.e(c26),.f(d98));  // 6 ins 1 outs level 1

    xor6 x108i (.out(x108),.a(x102),.b(x60),.c(x36),.d(x56),.e(x53),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x107i (.out(x107),.a(x103),.b(d86),.c(x48),.d(x104),.e(x105),.f(x106));  // 6 ins 1 outs level 2

    xor6 x106i (.out(x106),.a(c14),.b(d9),.c(c12),.d(d70),.e(d69),.f(c31));  // 6 ins 1 outs level 1

    xor6 x105i (.out(x105),.a(d56),.b(d89),.c(d71),.d(d0),.e(c27),.f(c17));  // 6 ins 1 outs level 1

    xor6 x104i (.out(x104),.a(d37),.b(d43),.c(d84),.d(d40),.e(c18),.f(d49));  // 6 ins 1 outs level 1

    xor6 x103i (.out(x103),.a(d27),.b(d62),.c(d10),.d(d75),.e(d25),.f(d17));  // 6 ins 1 outs level 1

    xor6 x102i (.out(x102),.a(c9),.b(d59),.c(d18),.d(d81),.e(c26),.f(d98));  // 6 ins 1 outs level 1

    xor6 x101i (.out(x101),.a(x94),.b(x56),.c(x39),.d(x34),.e(x33),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x100i (.out(x100),.a(x95),.b(x99),.c(x36),.d(x96),.e(x97),.f(x98));  // 6 ins 1 outs level 2

    xor6 x99i (.out(x99),.a(d47),.b(d86),.c(d90),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x98i (.out(x98),.a(d49),.b(d58),.c(c23),.d(c18),.e(c7),.f(d48));  // 6 ins 1 outs level 1

    xor6 x97i (.out(x97),.a(d97),.b(c14),.c(d94),.d(d29),.e(d18),.f(d67));  // 6 ins 1 outs level 1

    xor6 x96i (.out(x96),.a(d50),.b(c2),.c(d74),.d(d45),.e(d15),.f(d32));  // 6 ins 1 outs level 1

    xor6 x95i (.out(x95),.a(c19),.b(d95),.c(d44),.d(d25),.e(d46),.f(c25));  // 6 ins 1 outs level 1

    xor6 x94i (.out(x94),.a(d91),.b(d3),.c(d41),.d(c22),.e(d65),.f(d30));  // 6 ins 1 outs level 1

    xor6 x93i (.out(x93),.a(x86),.b(x64),.c(x49),.d(x39),.e(x38),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x92i (.out(x92),.a(x87),.b(x35),.c(x91),.d(x88),.e(x89),.f(x90));  // 6 ins 1 outs level 2

    xor6 x91i (.out(x91),.a(c8),.b(d13),.c(d19),.d(d3),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x90i (.out(x90),.a(d67),.b(c1),.c(d61),.d(d1),.e(d64),.f(c11));  // 6 ins 1 outs level 1

    xor6 x89i (.out(x89),.a(d83),.b(c6),.c(d63),.d(d75),.e(d49),.f(d0));  // 6 ins 1 outs level 1

    xor6 x88i (.out(x88),.a(d21),.b(d70),.c(d82),.d(d28),.e(d40),.f(d46));  // 6 ins 1 outs level 1

    xor6 x87i (.out(x87),.a(d57),.b(d4),.c(d73),.d(d78),.e(d44),.f(d41));  // 6 ins 1 outs level 1

    xor6 x86i (.out(x86),.a(d39),.b(d37),.c(d54),.d(d10),.e(d80),.f(d20));  // 6 ins 1 outs level 1

    xor6 x85i (.out(x85),.a(x33),.b(x49),.c(x38),.d(x60),.e(x37),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x84i (.out(x84),.a(x79),.b(x34),.c(x80),.d(x81),.e(x82),.f(x83));  // 6 ins 1 outs level 2

    xor6 x83i (.out(x83),.a(d30),.b(d2),.c(d40),.d(d7),.e(d100),.f(d4));  // 6 ins 1 outs level 1

    xor6 x82i (.out(x82),.a(d66),.b(d71),.c(d41),.d(d95),.e(d56),.f(d72));  // 6 ins 1 outs level 1

    xor6 x81i (.out(x81),.a(d76),.b(d52),.c(d21),.d(d64),.e(d70),.f(c21));  // 6 ins 1 outs level 1

    xor6 x80i (.out(x80),.a(d22),.b(c1),.c(d79),.d(d97),.e(d93),.f(c28));  // 6 ins 1 outs level 1

    xor6 x79i (.out(x79),.a(d14),.b(d92),.c(d20),.d(c0),.e(d11),.f(d38));  // 6 ins 1 outs level 1

    xor6 x78i (.out(x78),.a(d6),.b(d73),.c(d8),.d(d25),.e(c10),.f(d1));  // 6 ins 1 outs level 1

    xor6 x77i (.out(x77),.a(x70),.b(d46),.c(d22),.d(x49),.e(x39),.f(x60));  // 6 ins 1 outs level 2

    xor6 x76i (.out(x76),.a(x71),.b(x55),.c(x72),.d(x73),.e(x74),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x74i (.out(x74),.a(d77),.b(d15),.c(d71),.d(d56),.e(d65),.f(d32));  // 6 ins 1 outs level 1

    xor6 x73i (.out(x73),.a(d16),.b(c21),.c(d25),.d(d0),.e(d62),.f(d7));  // 6 ins 1 outs level 1

    xor6 x72i (.out(x72),.a(d51),.b(d24),.c(c5),.d(d39),.e(d87),.f(d28));  // 6 ins 1 outs level 1

    xor6 x71i (.out(x71),.a(d82),.b(d8),.c(d21),.d(d23),.e(d93),.f(d55));  // 6 ins 1 outs level 1

    xor6 x70i (.out(x70),.a(d41),.b(c25),.c(c27),.d(d6),.e(d2),.f(d57));  // 6 ins 1 outs level 1

    xor6 x69i (.out(x69),.a(d1),.b(d8),.c(d38),.d(d11),.e(x33),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x68i (.out(x68),.a(d41),.b(x38),.c(d66),.d(x49),.e(d1),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x67i (.out(x67),.a(d38),.b(d11),.c(x33),.d(d20),.e(d40),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x66i (.out(x66),.a(c17),.b(x33),.c(d27),.d(d89),.e(d35),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x65i (.out(x65),.a(d27),.b(d83),.c(c11),.d(d29),.e(1'b0),.f(1'b0));  // 4 ins 7 outs level 1

    xor6 x64i (.out(x64),.a(d59),.b(d24),.c(d65),.d(d71),.e(d94),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x63i (.out(x63),.a(d40),.b(x35),.c(d70),.d(d21),.e(d41),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x62i (.out(x62),.a(d19),.b(d23),.c(d67),.d(d58),.e(d35),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x61i (.out(x61),.a(c27),.b(d22),.c(c18),.d(d102),.e(c30),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x60i (.out(x60),.a(d68),.b(d43),.c(d45),.d(d65),.e(c7),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x59i (.out(x59),.a(c10),.b(d81),.c(c0),.d(d72),.e(c9),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x58i (.out(x58),.a(d103),.b(d85),.c(d97),.d(x33),.e(d15),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x57i (.out(x57),.a(x45),.b(d71),.c(d56),.d(d66),.e(d30),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x56i (.out(x56),.a(d39),.b(d19),.c(d32),.d(d70),.e(d2),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x55i (.out(x55),.a(d10),.b(d34),.c(c15),.d(c27),.e(d37),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x54i (.out(x54),.a(x47),.b(d72),.c(c2),.d(c27),.e(c0),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x53i (.out(x53),.a(d38),.b(d1),.c(d36),.d(c13),.e(d14),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x52i (.out(x52),.a(d78),.b(c6),.c(d25),.d(d43),.e(d64),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x51i (.out(x51),.a(d68),.b(d90),.c(d12),.d(d63),.e(x41),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x50i (.out(x50),.a(c14),.b(d86),.c(d87),.d(d17),.e(c16),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x49i (.out(x49),.a(d5),.b(d42),.c(c3),.d(c25),.e(d97),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x48i (.out(x48),.a(d33),.b(c28),.c(d49),.d(d8),.e(d100),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x47i (.out(x47),.a(c7),.b(d7),.c(d99),.d(d53),.e(1'b0),.f(1'b0));  // 4 ins 8 outs level 1

    xor6 x46i (.out(x46),.a(d9),.b(d102),.c(d85),.d(c30),.e(d96),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x45i (.out(x45),.a(d101),.b(d94),.c(c18),.d(c29),.e(d61),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x44i (.out(x44),.a(c23),.b(c4),.c(x37),.d(d54),.e(d75),.f(1'b0));  // 5 ins 9 outs level 2

    xor6 x43i (.out(x43),.a(d93),.b(d26),.c(d28),.d(c21),.e(d48),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x42i (.out(x42),.a(d74),.b(x32),.c(d50),.d(d55),.e(d29),.f(1'b0));  // 5 ins 12 outs level 2

    xor6 x41i (.out(x41),.a(d4),.b(c5),.c(d59),.d(d24),.e(d77),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x40i (.out(x40),.a(d18),.b(d88),.c(d89),.d(d44),.e(c17),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x39i (.out(x39),.a(d103),.b(c31),.c(d69),.d(d6),.e(d79),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x38i (.out(x38),.a(d81),.b(d57),.c(c20),.d(c9),.e(d51),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x37i (.out(x37),.a(d3),.b(d76),.c(d95),.d(d58),.e(d52),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x36i (.out(x36),.a(d73),.b(d31),.c(d0),.d(d90),.e(c1),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x35i (.out(x35),.a(c22),.b(d92),.c(d91),.d(c19),.e(c10),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x34i (.out(x34),.a(c12),.b(d57),.c(d83),.d(c11),.e(d84),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x33i (.out(x33),.a(d80),.b(c25),.c(c8),.d(d60),.e(d62),.f(1'b0));  // 5 ins 13 outs level 1

    xor6 x32i (.out(x32),.a(c2),.b(d47),.c(d82),.d(d98),.e(c26),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x7i (.out(x7),.a(x76),.b(x33),.c(x44),.d(x42),.e(x77),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x6i (.out(x6),.a(x78),.b(x42),.c(x44),.d(x85),.e(x84),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x5i (.out(x5),.a(x92),.b(x42),.c(x32),.d(x54),.e(x93),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x4i (.out(x4),.a(x100),.b(x67),.c(x51),.d(x48),.e(x101),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x3i (.out(x3),.a(x107),.b(x47),.c(x58),.d(x44),.e(x108),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x2i (.out(x2),.a(x109),.b(x40),.c(x54),.d(x116),.e(x115),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x1i (.out(x1),.a(x69),.b(x123),.c(x54),.d(x122),.e(x117),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x0i (.out(x0),.a(x130),.b(x39),.c(x51),.d(x55),.e(x42),.f(x131));  // 6 ins 1 outs level 3

    xor6 x31i (.out(x31),.a(d30),.b(x137),.c(c24),.d(x48),.e(x58),.f(x138));  // 6 ins 1 outs level 3

    xor6 x30i (.out(x30),.a(x144),.b(x43),.c(x57),.d(x145),.e(x146),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x29i (.out(x29),.a(x152),.b(x38),.c(x63),.d(x42),.e(x153),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x28i (.out(x28),.a(x159),.b(x48),.c(x63),.d(x51),.e(x160),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x27i (.out(x27),.a(x161),.b(x51),.c(x42),.d(x167),.e(x166),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x26i (.out(x26),.a(x173),.b(x62),.c(x68),.d(x44),.e(x174),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x25i (.out(x25),.a(x180),.b(x61),.c(x63),.d(x44),.e(x181),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x24i (.out(x24),.a(x187),.b(x50),.c(x53),.d(x42),.e(x57),.f(x188));  // 6 ins 1 outs level 3

    xor6 x23i (.out(x23),.a(x195),.b(x50),.c(x66),.d(x42),.e(x196),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x22i (.out(x22),.a(x202),.b(x36),.c(x60),.d(x42),.e(x203),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x21i (.out(x21),.a(x210),.b(x35),.c(x40),.d(x46),.e(x65),.f(x55));  // 6 ins 1 outs level 3

    xor6 x20i (.out(x20),.a(x211),.b(x43),.c(x50),.d(x59),.e(x63),.f(x217));  // 6 ins 1 outs level 3

    xor6 x19i (.out(x19),.a(x223),.b(x67),.c(x66),.d(x58),.e(x224),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x18i (.out(x18),.a(x231),.b(x43),.c(x56),.d(x232),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x17i (.out(x17),.a(c4),.b(x236),.c(x48),.d(x239),.e(x240),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x16i (.out(x16),.a(x245),.b(x49),.c(x51),.d(x247),.e(x248),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x15i (.out(x15),.a(x254),.b(x57),.c(x54),.d(x44),.e(x255),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x14i (.out(x14),.a(x262),.b(x34),.c(x39),.d(x40),.e(x44),.f(x263));  // 6 ins 1 outs level 3

    xor6 x13i (.out(x13),.a(x268),.b(x43),.c(x61),.d(x44),.e(x42),.f(x269));  // 6 ins 1 outs level 3

    xor6 x12i (.out(x12),.a(x274),.b(x68),.c(x57),.d(x51),.e(x275),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x11i (.out(x11),.a(x282),.b(x52),.c(x57),.d(x42),.e(x283),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x10i (.out(x10),.a(x289),.b(x49),.c(x66),.d(x57),.e(x290),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x9i (.out(x9),.a(x297),.b(x46),.c(x52),.d(x56),.e(x42),.f(x298));  // 6 ins 1 outs level 3

    xor6 x8i (.out(x8),.a(x305),.b(x34),.c(x51),.d(x44),.e(x306),.f(1'b0));  // 5 ins 1 outs level 3

endmodule

