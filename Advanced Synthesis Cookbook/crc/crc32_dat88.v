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

//// CRC-32 of 88 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888
//        01234567890123456789012345678901 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//
// C00  = ..X.XX.X.XXXX...XX.....X.XXXXX.X X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X
// C01  = X.XXX.XXXX...X..X.X....XXX....XX XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..X.XXX.XXXX...X..X.X....XXX....XX
// C02  = .XXX....X..XX.X.X..X...XX..XXX.. XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..
// C03  = X.XXX....X..XX.X.X..X...XX..XXX. .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX.
// C04  = .XXX...X.X.XXXX..XX..X.X...XX.X. X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X......XXX...X.X.XXXX..XX..X.X...XX.X.
// C05  = ...X.X.XXX.X.XXXXXXX..XXXXXX.... XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX....
// C06  = X...X.X.XXX.X.XXXXXXX..XXXXXX... .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX...
// C07  = XXX.X.......XX.X..XXXX.XX......X X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.XXX.X.......XX.X..XXXX.XX......X
// C08  = .X.XX..X.XXXXXX..X.XXXXXX.XXXX.X XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.X
// C09  = ..X.XX..X.XXXXXX..X.XXXXXX.XXXX. .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.
// C10  = X.XXX.XX..X..XXX.X.X.XX.X..X..X. X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..XX.XXX.XX..X..XXX.X.X.XX.X..X..X.
// C11  = XXXX....XXX.X.XX.XX.X.X...XX.X.. XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XXXXXX....XXX.X.XX.XX.X.X...XX.X..
// C12  = XX.X.X.X....XX.X.XXX.X...XX..XXX XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX
// C13  = .XX.X.X.X....XX.X.XXX.X...XX..XX .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XX
// C14  = X.XX.X.X.X....XX.X.XXX.X...XX..X ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..X
// C15  = XX.XX.X.X.X....XX.X.XXX.X...XX.. ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..
// C16  = XX........X.X......X.XX...XXX.XX X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX
// C17  = .XX........X.X......X.XX...XXX.X .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.X
// C18  = ..XX........X.X......X.XX...XXX. ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.
// C19  = ...XX........X.X......X.XX...XXX ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX
// C20  = ....XX........X.X......X.XX...XX ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XX
// C21  = X....XX........X.X......X.XX...X .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...X
// C22  = .XX.XXX..XXXX....XX....X..X..X.X X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X.XX.XXX..XXXX....XX....X..X..X.X
// C23  = X..XX.X..X...X..XXXX...XXXX.XXXX XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXX
// C24  = XX..XX.X..X...X..XXXX...XXXX.XXX .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXX
// C25  = XXX..XX.X..X...X..XXXX...XXXX.XX ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XX
// C26  = .X.XXXX...XX.....X.XXXXX.X...... X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......
// C27  = X.X.XXXX...XX.....X.XXXXX.X..... .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X.....
// C28  = XX.X.XXXX...XX.....X.XXXXX.X.... ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X....
// C29  = .XX.X.XXXX...XX.....X.XXXXX.X... ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X...
// C30  = X.XX.X.XXXX...XX.....X.XXXXX.X.. ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X..
// C31  = .X.XX.X.XXXX...XX.....X.XXXXX.X. .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X.
//
module crc32_dat88 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [87:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat88_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat88_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat88_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [87:0] dat_in;
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
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63,d64,d65,d66,d67,d68,d69,d70,d71,d72,d73,d74,d75,d76,d77,d78,
    d79,d80,d81,d82,d83,d84,d85,d86,d87;

assign { d87,d86,d85,d84,d83,d82,d81,d80,d79,d78,d77,d76,d75,d74,d73,
        d72,d71,d70,d69,d68,d67,d66,d65,d64,d63,d62,d61,d60,d59,d58,d57,
        d56,d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [87:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x23 = c0 ^ c6 ^ d20 ^ d19 ^ d42 ^ d84 ^ d81 ^ d75 ^ d55 ^ 
        c23 ^ c19 ^ d73 ^ d36 ^ d62 ^ d39 ^ d49 ^ c24 ^ d31 ^ c16 ^ 
        d56 ^ d80 ^ c13 ^ c18 ^ d69 ^ c28 ^ d27 ^ d54 ^ d47 ^ d82 ^ 
        c31 ^ d72 ^ d65 ^ d85 ^ d59 ^ d46 ^ c3 ^ d6 ^ d17 ^ c30 ^ 
        d38 ^ c9 ^ d74 ^ d1 ^ d35 ^ d0 ^ d26 ^ d60 ^ c25 ^ c29 ^ 
        d86 ^ d13 ^ d79 ^ d50 ^ d9 ^ c17 ^ d15 ^ c26 ^ d16 ^ d29 ^ 
        d34 ^ d87 ^ c4;  // 62 ins 1 outs level 3

    assign x22 = d44 ^ c31 ^ d9 ^ d38 ^ d65 ^ c2 ^ d85 ^ d24 ^ d43 ^ 
        c9 ^ d36 ^ d74 ^ c18 ^ c10 ^ d35 ^ d11 ^ d79 ^ d55 ^ d57 ^ 
        c17 ^ d23 ^ d62 ^ c23 ^ c6 ^ c26 ^ c29 ^ d73 ^ d66 ^ d16 ^ 
        d60 ^ d68 ^ d0 ^ d29 ^ d31 ^ c12 ^ d18 ^ d34 ^ d87 ^ c4 ^ 
        c11 ^ d12 ^ d19 ^ d47 ^ d82 ^ d41 ^ d45 ^ c5 ^ c1 ^ d61 ^ 
        d48 ^ d14 ^ d26 ^ d58 ^ d67 ^ d37 ^ d27 ^ d52;  // 57 ins 1 outs level 3

    assign x21 = d87 ^ c17 ^ d31 ^ d34 ^ d62 ^ d49 ^ d51 ^ d80 ^ c15 ^ 
        d35 ^ d29 ^ c0 ^ c5 ^ d61 ^ d9 ^ c6 ^ d37 ^ d53 ^ d42 ^ 
        d5 ^ d73 ^ d56 ^ d17 ^ d52 ^ d71 ^ c27 ^ c31 ^ d27 ^ c26 ^ 
        d10 ^ d13 ^ c24 ^ d22 ^ d83 ^ d82 ^ d24 ^ d40 ^ d18 ^ d26;  // 39 ins 1 outs level 3

    assign x20 = d34 ^ d55 ^ d70 ^ d16 ^ d87 ^ d4 ^ d28 ^ d60 ^ d33 ^ 
        d72 ^ c14 ^ d51 ^ c31 ^ c25 ^ d50 ^ d39 ^ d61 ^ c30 ^ c26 ^ 
        c5 ^ d30 ^ c16 ^ c4 ^ d48 ^ d36 ^ d26 ^ d41 ^ d81 ^ d52 ^ 
        d8 ^ d12 ^ d17 ^ d86 ^ d9 ^ c23 ^ d25 ^ d79 ^ d82 ^ d21 ^ 
        d23;  // 40 ins 1 outs level 3

    assign x19 = d16 ^ d80 ^ d51 ^ d59 ^ c4 ^ c22 ^ d22 ^ c29 ^ d86 ^ 
        d69 ^ d60 ^ d15 ^ d71 ^ c15 ^ d27 ^ c30 ^ d78 ^ c3 ^ c13 ^ 
        d20 ^ d32 ^ d40 ^ d25 ^ d47 ^ d29 ^ d87 ^ d33 ^ d3 ^ c31 ^ 
        d50 ^ d85 ^ d35 ^ c24 ^ d81 ^ d54 ^ d49 ^ c25 ^ d38 ^ d11 ^ 
        d8 ^ d7 ^ d24;  // 42 ins 1 outs level 3

    assign x18 = d19 ^ d59 ^ c2 ^ c3 ^ c30 ^ d2 ^ d26 ^ d39 ^ d34 ^ 
        d31 ^ d84 ^ d28 ^ d49 ^ c21 ^ d14 ^ d37 ^ d68 ^ c12 ^ d50 ^ 
        d70 ^ d46 ^ d86 ^ d77 ^ d85 ^ c28 ^ c24 ^ c14 ^ d10 ^ d32 ^ 
        d21 ^ c29 ^ d6 ^ c23 ^ d58 ^ d7 ^ d24 ^ d79 ^ d48 ^ d53 ^ 
        d80 ^ d23 ^ d15;  // 42 ins 1 outs level 3

    assign x17 = d25 ^ c27 ^ d30 ^ d69 ^ d87 ^ d67 ^ d14 ^ d33 ^ d78 ^ 
        d36 ^ c2 ^ d45 ^ c29 ^ d5 ^ d49 ^ c31 ^ d83 ^ d13 ^ d57 ^ 
        c13 ^ d1 ^ d84 ^ d31 ^ d85 ^ d38 ^ d76 ^ d48 ^ d27 ^ c1 ^ 
        c28 ^ d79 ^ d23 ^ c11 ^ d52 ^ d18 ^ d6 ^ d9 ^ d58 ^ c20 ^ 
        d20 ^ c22 ^ d22 ^ d47 ^ c23;  // 44 ins 1 outs level 3

    assign x16 = d84 ^ d24 ^ d8 ^ d44 ^ c30 ^ c10 ^ d37 ^ d78 ^ c12 ^ 
        c21 ^ c27 ^ d46 ^ c28 ^ d12 ^ c19 ^ c26 ^ d87 ^ d48 ^ c0 ^ 
        d26 ^ d21 ^ d68 ^ d47 ^ d13 ^ d51 ^ d0 ^ d66 ^ c22 ^ d30 ^ 
        d83 ^ d35 ^ d57 ^ d82 ^ c31 ^ d4 ^ d29 ^ d32 ^ d19 ^ d75 ^ 
        d17 ^ d56 ^ d22 ^ d5 ^ d86 ^ d77 ^ c1;  // 46 ins 1 outs level 3

    assign x15 = d84 ^ c8 ^ d76 ^ c10 ^ d62 ^ d34 ^ d15 ^ d49 ^ d55 ^ 
        c20 ^ d21 ^ d24 ^ d20 ^ d72 ^ c22 ^ d64 ^ d50 ^ d59 ^ d78 ^ 
        d8 ^ d27 ^ c21 ^ d57 ^ d66 ^ c15 ^ c1 ^ d33 ^ d85 ^ d60 ^ 
        c0 ^ d80 ^ d56 ^ c3 ^ d3 ^ c24 ^ d74 ^ d7 ^ c16 ^ d71 ^ 
        d53 ^ d12 ^ d5 ^ d44 ^ d9 ^ c6 ^ c28 ^ d18 ^ d52 ^ c4 ^ 
        d77 ^ d30 ^ d54 ^ d16 ^ d4 ^ d45 ^ c18 ^ c29;  // 57 ins 1 outs level 3

    assign x14 = c27 ^ d79 ^ d87 ^ c19 ^ d29 ^ c0 ^ d49 ^ c21 ^ d55 ^ 
        d3 ^ d11 ^ d75 ^ c9 ^ d23 ^ d59 ^ d71 ^ d65 ^ d73 ^ d26 ^ 
        d44 ^ c23 ^ d84 ^ d83 ^ d58 ^ d77 ^ d14 ^ d48 ^ d70 ^ c7 ^ 
        d17 ^ c31 ^ d8 ^ c28 ^ d19 ^ c3 ^ d2 ^ d63 ^ c20 ^ d4 ^ 
        d52 ^ d76 ^ c14 ^ d32 ^ d56 ^ d33 ^ d51 ^ d54 ^ d7 ^ d20 ^ 
        c2 ^ d6 ^ c5 ^ c15 ^ d61 ^ d15 ^ d53 ^ c17 ^ d43;  // 58 ins 1 outs level 3

    assign x13 = d52 ^ d72 ^ d50 ^ d32 ^ d25 ^ d64 ^ d16 ^ d82 ^ d78 ^ 
        d10 ^ d42 ^ d3 ^ d76 ^ d5 ^ d69 ^ d86 ^ d13 ^ d51 ^ c19 ^ 
        d6 ^ d60 ^ d53 ^ d87 ^ d54 ^ c4 ^ c22 ^ d31 ^ c20 ^ d47 ^ 
        d43 ^ c1 ^ d58 ^ d1 ^ c2 ^ d19 ^ d83 ^ c30 ^ c27 ^ d28 ^ 
        c16 ^ c6 ^ d75 ^ d74 ^ d57 ^ d2 ^ d18 ^ c8 ^ c13 ^ d7 ^ 
        d70 ^ d14 ^ c31 ^ d55 ^ d62 ^ d22 ^ c18 ^ d48 ^ c14 ^ c26;  // 59 ins 1 outs level 3

    assign x12 = d82 ^ d52 ^ d56 ^ d73 ^ d81 ^ c31 ^ d27 ^ d4 ^ c25 ^ 
        d42 ^ d18 ^ d6 ^ d2 ^ d54 ^ d49 ^ d24 ^ c1 ^ d53 ^ c29 ^ 
        d87 ^ c17 ^ d30 ^ d15 ^ c15 ^ c19 ^ c21 ^ d12 ^ c0 ^ c7 ^ 
        d31 ^ d63 ^ c5 ^ d85 ^ d68 ^ d61 ^ d59 ^ c13 ^ c18 ^ d71 ^ 
        d41 ^ d51 ^ d75 ^ d46 ^ c12 ^ d21 ^ d5 ^ c3 ^ d1 ^ d77 ^ 
        d17 ^ c30 ^ d74 ^ c26 ^ d69 ^ d86 ^ d57 ^ d47 ^ d13 ^ d50 ^ 
        d9 ^ d0;  // 61 ins 1 outs level 3

    assign x11 = c27 ^ c2 ^ d73 ^ c1 ^ d74 ^ c22 ^ d41 ^ d33 ^ d27 ^ 
        d15 ^ d85 ^ d28 ^ d54 ^ d14 ^ d44 ^ d64 ^ c18 ^ d26 ^ d51 ^ 
        d31 ^ d36 ^ d40 ^ c20 ^ c9 ^ d25 ^ d76 ^ d56 ^ c0 ^ d57 ^ 
        d65 ^ d48 ^ d83 ^ d3 ^ d24 ^ d12 ^ d43 ^ c12 ^ d50 ^ d47 ^ 
        c29 ^ c3 ^ d9 ^ d4 ^ d82 ^ d66 ^ c10 ^ d58 ^ d59 ^ d17 ^ 
        d71 ^ d55 ^ d45 ^ d20 ^ c15 ^ c8 ^ d1 ^ c17 ^ c26 ^ d16 ^ 
        d68 ^ d78 ^ d70 ^ d0 ^ c14;  // 64 ins 1 outs level 3

    assign x10 = d29 ^ c17 ^ d55 ^ c10 ^ d9 ^ d50 ^ d62 ^ d33 ^ d31 ^ 
        d42 ^ d14 ^ d66 ^ d39 ^ c15 ^ d69 ^ d78 ^ d26 ^ c22 ^ c6 ^ 
        d0 ^ d63 ^ c27 ^ c21 ^ d83 ^ d32 ^ c7 ^ c3 ^ d13 ^ d60 ^ 
        d80 ^ d73 ^ c30 ^ c24 ^ d71 ^ d16 ^ d40 ^ d58 ^ c4 ^ d59 ^ 
        d28 ^ c19 ^ c2 ^ d77 ^ d35 ^ d3 ^ c0 ^ d5 ^ d36 ^ d19 ^ 
        d75 ^ d2 ^ d70 ^ d86 ^ c13 ^ d52 ^ c14 ^ d56;  // 57 ins 1 outs level 3

    assign x9 = d39 ^ d83 ^ d36 ^ d52 ^ d55 ^ d76 ^ d2 ^ d1 ^ c15 ^ 
        d64 ^ d84 ^ c30 ^ c13 ^ c24 ^ d77 ^ d58 ^ d85 ^ d60 ^ d66 ^ 
        d61 ^ c18 ^ c11 ^ d71 ^ d5 ^ c28 ^ d51 ^ d38 ^ d81 ^ c25 ^ 
        d79 ^ d47 ^ d11 ^ d78 ^ c22 ^ c2 ^ d18 ^ d29 ^ d24 ^ d70 ^ 
        c14 ^ d46 ^ c20 ^ c5 ^ c27 ^ d4 ^ d74 ^ c8 ^ c29 ^ c4 ^ 
        d9 ^ d12 ^ c21 ^ d35 ^ d68 ^ d34 ^ d33 ^ d23 ^ d44 ^ c10 ^ 
        d41 ^ d53 ^ c23 ^ d80 ^ d69 ^ d43 ^ c12 ^ d67 ^ d32 ^ d86 ^ 
        d13;  // 70 ins 1 outs level 3

    assign x8 = d17 ^ c9 ^ c3 ^ d50 ^ d3 ^ c20 ^ d40 ^ c12 ^ d84 ^ 
        d82 ^ d38 ^ c1 ^ c10 ^ d1 ^ d80 ^ d69 ^ d70 ^ d83 ^ d75 ^ 
        c17 ^ d35 ^ d8 ^ c24 ^ c14 ^ d79 ^ c29 ^ d60 ^ c26 ^ d66 ^ 
        d22 ^ d23 ^ c19 ^ d51 ^ d68 ^ d0 ^ d78 ^ d67 ^ d12 ^ d34 ^ 
        d87 ^ d33 ^ d43 ^ c4 ^ d28 ^ d4 ^ c31 ^ c11 ^ c13 ^ d37 ^ 
        d54 ^ d65 ^ c7 ^ d11 ^ c28 ^ d45 ^ d31 ^ c23 ^ d42 ^ d32 ^ 
        d85 ^ c27 ^ c22 ^ d59 ^ d10 ^ d77 ^ d52 ^ d46 ^ c21 ^ d73 ^ 
        d63 ^ d57 ^ d76;  // 72 ins 1 outs level 3

    assign x7 = c4 ^ d37 ^ d52 ^ d69 ^ d60 ^ d57 ^ d75 ^ c0 ^ d28 ^ 
        d45 ^ c13 ^ d8 ^ c31 ^ c21 ^ d16 ^ c23 ^ d39 ^ d46 ^ d58 ^ 
        d3 ^ d50 ^ d68 ^ d43 ^ d71 ^ d24 ^ c18 ^ d41 ^ d32 ^ d10 ^ 
        d25 ^ d51 ^ d54 ^ d23 ^ d42 ^ c2 ^ c15 ^ c20 ^ d0 ^ d74 ^ 
        d15 ^ d76 ^ d22 ^ d29 ^ d34 ^ d2 ^ c12 ^ d21 ^ d5 ^ d7 ^ 
        c24 ^ d47 ^ d79 ^ d87 ^ d77 ^ d56 ^ c1 ^ c19 ^ d80;  // 58 ins 1 outs level 3

    assign x6 = d80 ^ c10 ^ c28 ^ d84 ^ d64 ^ d68 ^ d38 ^ d83 ^ d29 ^ 
        c26 ^ d51 ^ d66 ^ d56 ^ d25 ^ d5 ^ d21 ^ d50 ^ c15 ^ c27 ^ 
        c12 ^ c17 ^ c19 ^ c0 ^ d8 ^ d74 ^ d72 ^ c23 ^ d52 ^ c18 ^ 
        c8 ^ d22 ^ c16 ^ d62 ^ d54 ^ d71 ^ d20 ^ d14 ^ c20 ^ d79 ^ 
        d2 ^ d65 ^ c24 ^ d75 ^ d60 ^ c25 ^ d81 ^ c4 ^ c6 ^ d47 ^ 
        d6 ^ d41 ^ d1 ^ d7 ^ d40 ^ d70 ^ d76 ^ d82 ^ c9 ^ d73 ^ 
        d42 ^ d11 ^ d55 ^ d4 ^ d43 ^ d30 ^ d45 ^ c14;  // 67 ins 1 outs level 3

    assign x5 = d24 ^ d65 ^ d54 ^ d81 ^ d6 ^ d51 ^ c5 ^ c18 ^ d61 ^ 
        d7 ^ d67 ^ d28 ^ d37 ^ d70 ^ d64 ^ d44 ^ d5 ^ d21 ^ d83 ^ 
        c27 ^ d42 ^ d50 ^ d82 ^ d10 ^ d53 ^ d13 ^ d71 ^ d72 ^ c23 ^ 
        c16 ^ d41 ^ d39 ^ d49 ^ d73 ^ c15 ^ d55 ^ c17 ^ d0 ^ d78 ^ 
        d80 ^ d59 ^ d1 ^ d74 ^ c7 ^ d75 ^ d69 ^ c8 ^ c26 ^ d20 ^ 
        c9 ^ c25 ^ d19 ^ c13 ^ d63 ^ d29 ^ c14 ^ c22 ^ d79 ^ d46 ^ 
        c11 ^ c3 ^ d4 ^ c19 ^ d40 ^ c24 ^ d3;  // 66 ins 1 outs level 3

    assign x4 = c23 ^ d47 ^ c12 ^ c2 ^ c30 ^ d30 ^ d57 ^ d69 ^ d63 ^ 
        c27 ^ d68 ^ c17 ^ d44 ^ d4 ^ d45 ^ d0 ^ d65 ^ d70 ^ c18 ^ 
        d73 ^ c1 ^ d84 ^ d15 ^ d31 ^ d24 ^ d20 ^ d33 ^ d58 ^ d50 ^ 
        d41 ^ d79 ^ d29 ^ d67 ^ d59 ^ c14 ^ d3 ^ d18 ^ c21 ^ d8 ^ 
        d25 ^ d6 ^ c9 ^ d48 ^ d86 ^ d38 ^ c13 ^ d46 ^ c11 ^ d12 ^ 
        d83 ^ c7 ^ d11 ^ c28 ^ c3 ^ d19 ^ d39 ^ d2 ^ d40 ^ d77 ^ 
        d74;  // 60 ins 1 outs level 3

    assign x3 = d45 ^ d65 ^ c29 ^ c4 ^ d56 ^ d39 ^ d52 ^ c15 ^ c3 ^ 
        d3 ^ c25 ^ d38 ^ d33 ^ d27 ^ c20 ^ d40 ^ d59 ^ d25 ^ c2 ^ 
        d1 ^ d19 ^ d54 ^ d32 ^ d18 ^ c13 ^ d80 ^ d60 ^ d68 ^ c9 ^ 
        d17 ^ d31 ^ c30 ^ d10 ^ c17 ^ d81 ^ c24 ^ d85 ^ d36 ^ d73 ^ 
        c0 ^ d2 ^ d9 ^ d7 ^ d84 ^ d14 ^ c28 ^ d53 ^ d71 ^ d69 ^ 
        c12 ^ d86 ^ d15 ^ d8 ^ d58 ^ d37 ^ d76;  // 56 ins 1 outs level 3

    assign x2 = d17 ^ d24 ^ d84 ^ d6 ^ d64 ^ d1 ^ d35 ^ d13 ^ c14 ^ 
        d16 ^ d52 ^ d9 ^ d55 ^ d80 ^ d31 ^ d68 ^ d70 ^ d72 ^ d83 ^ 
        d0 ^ d2 ^ d30 ^ d51 ^ c28 ^ c24 ^ d53 ^ d7 ^ c29 ^ d79 ^ 
        c3 ^ d44 ^ d8 ^ d36 ^ d85 ^ d14 ^ c11 ^ c2 ^ c12 ^ d59 ^ 
        c23 ^ d32 ^ d18 ^ c16 ^ d57 ^ d75 ^ d26 ^ c19 ^ c8 ^ c1 ^ 
        d58 ^ d67 ^ d37 ^ c27 ^ d38 ^ d39;  // 55 ins 1 outs level 3

    assign x1 = c7 ^ d12 ^ d24 ^ d44 ^ c4 ^ d9 ^ d50 ^ d81 ^ d16 ^ 
        d13 ^ d86 ^ c16 ^ d37 ^ d47 ^ d69 ^ d80 ^ d0 ^ c2 ^ c23 ^ 
        d64 ^ d6 ^ d27 ^ d62 ^ d33 ^ d34 ^ c9 ^ d53 ^ d38 ^ d72 ^ 
        d35 ^ d1 ^ d56 ^ d63 ^ c8 ^ d74 ^ d60 ^ c30 ^ d17 ^ c25 ^ 
        c3 ^ d46 ^ d59 ^ c31 ^ d28 ^ d58 ^ d79 ^ d11 ^ d87 ^ d51 ^ 
        c18 ^ c13 ^ d49 ^ d65 ^ d7 ^ c24 ^ c6 ^ c0;  // 57 ins 1 outs level 3

    assign x0 = d63 ^ c29 ^ c25 ^ d60 ^ c9 ^ d6 ^ d25 ^ d73 ^ d10 ^ 
        c27 ^ d37 ^ d67 ^ d58 ^ d26 ^ d85 ^ c31 ^ c16 ^ d32 ^ c23 ^ 
        d83 ^ d48 ^ d31 ^ d84 ^ d61 ^ c5 ^ d45 ^ d66 ^ d72 ^ d82 ^ 
        d47 ^ c12 ^ c2 ^ c28 ^ c7 ^ d12 ^ d24 ^ d65 ^ d54 ^ d81 ^ 
        c11 ^ d44 ^ d28 ^ d30 ^ c4 ^ d87 ^ d79 ^ d53 ^ d34 ^ d29 ^ 
        d0 ^ d68 ^ d16 ^ c26 ^ c17 ^ d55 ^ c10 ^ d9 ^ d50;  // 58 ins 1 outs level 3

    assign x31 = d49 ^ c10 ^ c16 ^ d60 ^ d81 ^ d64 ^ d47 ^ c22 ^ d59 ^ 
        d5 ^ c15 ^ d23 ^ d71 ^ c26 ^ d15 ^ d28 ^ c9 ^ c27 ^ c1 ^ 
        d78 ^ d43 ^ c4 ^ d65 ^ d84 ^ d52 ^ d62 ^ d67 ^ c6 ^ c3 ^ 
        d57 ^ d33 ^ d25 ^ c24 ^ c25 ^ d54 ^ d44 ^ c8 ^ d80 ^ d24 ^ 
        d72 ^ d27 ^ d53 ^ c28 ^ d9 ^ d31 ^ d46 ^ d83 ^ d82 ^ c11 ^ 
        d36 ^ d8 ^ d66 ^ d86 ^ d11 ^ c30 ^ d30 ^ d29;  // 57 ins 1 outs level 3

    assign x30 = d10 ^ d48 ^ d28 ^ d79 ^ d46 ^ d35 ^ d52 ^ c26 ^ d53 ^ 
        c15 ^ c2 ^ d29 ^ c27 ^ d82 ^ c23 ^ d65 ^ d83 ^ d8 ^ d27 ^ 
        c7 ^ d26 ^ d43 ^ c21 ^ d51 ^ c29 ^ c5 ^ c24 ^ d7 ^ d56 ^ 
        d61 ^ d42 ^ d81 ^ d30 ^ d4 ^ d23 ^ d22 ^ d58 ^ d66 ^ d85 ^ 
        c0 ^ d70 ^ d77 ^ d64 ^ d24 ^ c3 ^ c10 ^ d59 ^ d63 ^ c9 ^ 
        d45 ^ c25 ^ d80 ^ d32 ^ c8 ^ d14 ^ c14 ^ d71;  // 57 ins 1 outs level 3

    assign x29 = d47 ^ d27 ^ c7 ^ d82 ^ c1 ^ d64 ^ c8 ^ d65 ^ c2 ^ 
        d28 ^ c28 ^ c24 ^ d63 ^ d41 ^ d76 ^ c20 ^ d3 ^ d7 ^ d21 ^ 
        c14 ^ d31 ^ c6 ^ c25 ^ d84 ^ c13 ^ d79 ^ d78 ^ d50 ^ d25 ^ 
        d81 ^ d45 ^ d42 ^ d69 ^ d80 ^ c4 ^ d58 ^ d52 ^ d55 ^ d26 ^ 
        d29 ^ d22 ^ d34 ^ d70 ^ d9 ^ d23 ^ d44 ^ c9 ^ c23 ^ d62 ^ 
        d51 ^ d6 ^ d60 ^ d13 ^ c22 ^ c26 ^ d57;  // 56 ins 1 outs level 3

    assign x28 = d49 ^ d21 ^ d5 ^ c27 ^ c7 ^ d68 ^ d24 ^ d25 ^ d54 ^ 
        c13 ^ d8 ^ d50 ^ d63 ^ c24 ^ d64 ^ d81 ^ c1 ^ d69 ^ d41 ^ 
        c19 ^ d56 ^ d20 ^ d80 ^ d59 ^ d44 ^ d2 ^ d30 ^ d79 ^ d26 ^ 
        c6 ^ d33 ^ c0 ^ d62 ^ d77 ^ d75 ^ c5 ^ d51 ^ d40 ^ d43 ^ 
        c23 ^ c8 ^ d6 ^ c22 ^ d61 ^ d22 ^ d57 ^ c25 ^ c12 ^ c21 ^ 
        d78 ^ d27 ^ d83 ^ d12 ^ c3 ^ d46 ^ d28;  // 56 ins 1 outs level 3

    assign x27 = c5 ^ d29 ^ d58 ^ d61 ^ c22 ^ d25 ^ d79 ^ d23 ^ c20 ^ 
        c7 ^ d74 ^ d43 ^ d50 ^ c0 ^ d56 ^ d78 ^ d40 ^ d80 ^ c12 ^ 
        d60 ^ d1 ^ d20 ^ d82 ^ d19 ^ d24 ^ d68 ^ d53 ^ d67 ^ c11 ^ 
        c21 ^ d49 ^ d4 ^ d55 ^ d62 ^ c6 ^ d27 ^ c2 ^ c23 ^ d76 ^ 
        d32 ^ d39 ^ c18 ^ d63 ^ c26 ^ d42 ^ d21 ^ d5 ^ d48 ^ c4 ^ 
        d77 ^ c24 ^ d7 ^ d45 ^ d26 ^ d11;  // 55 ins 1 outs level 3

    assign x26 = d79 ^ d59 ^ d10 ^ d19 ^ d0 ^ c6 ^ d31 ^ d47 ^ c4 ^ 
        d4 ^ d77 ^ d28 ^ d75 ^ c19 ^ c20 ^ d22 ^ c10 ^ d42 ^ d26 ^ 
        d38 ^ d55 ^ d23 ^ d66 ^ d78 ^ c5 ^ c3 ^ d60 ^ d3 ^ d61 ^ 
        c22 ^ d39 ^ d48 ^ c17 ^ d44 ^ c11 ^ d67 ^ d24 ^ d81 ^ d49 ^ 
        d57 ^ c23 ^ d73 ^ c1 ^ d54 ^ d18 ^ d52 ^ d25 ^ c21 ^ d6 ^ 
        d41 ^ d62 ^ c25 ^ d20 ^ d76;  // 54 ins 1 outs level 3

    assign x25 = d19 ^ d82 ^ d41 ^ d81 ^ d56 ^ d18 ^ d77 ^ d84 ^ d11 ^ 
        d51 ^ d48 ^ c26 ^ d22 ^ d38 ^ c21 ^ c6 ^ d40 ^ c27 ^ c18 ^ 
        c31 ^ d74 ^ d21 ^ d76 ^ d3 ^ d44 ^ d83 ^ d87 ^ d33 ^ d62 ^ 
        c1 ^ d29 ^ d37 ^ d86 ^ c0 ^ d58 ^ d2 ^ d28 ^ d61 ^ d15 ^ 
        d64 ^ c11 ^ d52 ^ c8 ^ c30 ^ d49 ^ d71 ^ d36 ^ c2 ^ d67 ^ 
        c28 ^ c5 ^ c20 ^ c19 ^ c15 ^ d75 ^ d57 ^ c25 ^ d8 ^ d31 ^ 
        d17;  // 60 ins 1 outs level 3

    assign x24 = d28 ^ c17 ^ d32 ^ d20 ^ d86 ^ d87 ^ d27 ^ d73 ^ d39 ^ 
        d18 ^ d17 ^ c20 ^ d75 ^ c1 ^ d85 ^ c30 ^ c7 ^ d40 ^ d50 ^ 
        d51 ^ d76 ^ d60 ^ d43 ^ d21 ^ c18 ^ d48 ^ d81 ^ d57 ^ d2 ^ 
        d37 ^ d10 ^ c4 ^ c19 ^ c25 ^ c5 ^ d14 ^ c31 ^ d36 ^ c27 ^ 
        c26 ^ c10 ^ d30 ^ d55 ^ d74 ^ c0 ^ c29 ^ d47 ^ d70 ^ d83 ^ 
        d80 ^ d63 ^ c14 ^ c24 ^ d7 ^ d56 ^ d66 ^ d61 ^ d1 ^ d35 ^ 
        d82 ^ d16;  // 61 ins 1 outs level 3

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat88_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [87:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x262, x261, x260, x259, x258, x257, x256, 
       x255, x254, x252, x251, x250, x249, x248, x247, 
       x246, x245, x244, x243, x241, x240, x239, x238, 
       x237, x236, x235, x234, x233, x232, x231, x230, 
       x229, x228, x227, x226, x225, x224, x223, x222, 
       x221, x220, x219, x218, x217, x216, x215, x214, 
       x213, x212, x211, x210, x209, x208, x207, x206, 
       x205, x204, x203, x202, x201, x200, x199, x198, 
       x197, x196, x195, x194, x193, x192, x191, x190, 
       x189, x188, x187, x186, x185, x183, x182, x181, 
       x180, x179, x178, x177, x176, x175, x174, x173, 
       x172, x171, x170, x169, x168, x167, x166, x165, 
       x164, x163, x162, x161, x160, x159, x158, x157, 
       x156, x155, x154, x153, x152, x151, x150, x149, 
       x148, x147, x146, x145, x144, x143, x142, x141, 
       x140, x139, x138, x137, x136, x135, x134, x133, 
       x132, x131, x130, x129, x128, x127, x126, x125, 
       x124, x122, x121, x120, x119, x118, x117, x116, 
       x115, x114, x113, x112, x111, x110, x109, x108, 
       x107, x106, x105, x104, x103, x102, x100, x99, 
       x98, x97, x96, x95, x94, x93, x92, x90, 
       x88, x87, x86, x85, x84, x83, x82, x81, 
       x80, x79, x77, x76, x75, x74, x73, x72, 
       x71, x70, x69, x68, x67, x66, x65, x64, 
       x63, x62, x61, x60, x59, x58, x57, x56, 
       x55, x54, x53, x52, x51, x50, x49, x48, 
       x47, x46, x45, x44, x43, x42, x41, x40, 
       x39, x38, x37, x36, x35, x34, x33, x32, 
       x23, x22, x21, x20, x19, x18, x17, x16, 
       x15, x14, x13, x12, x11, x10, x9, x8, 
       x7, x6, x5, x4, x3, x2, x1, x0, 
       x31, x30, x29, x28, x27, x26, x25, x24;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63,d64,d65,d66,d67,d68,d69,d70,d71,d72,d73,d74,d75,d76,d77,d78,
    d79,d80,d81,d82,d83,d84,d85,d86,d87;

assign { d87,d86,d85,d84,d83,d82,d81,d80,d79,d78,d77,d76,d75,d74,d73,
        d72,d71,d70,d69,d68,d67,d66,d65,d64,d63,d62,d61,d60,d59,d58,d57,
        d56,d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [87:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x262i (.out(x262),.a(x256),.b(x43),.c(x39),.d(x33),.e(x35),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x261i (.out(x261),.a(x257),.b(x37),.c(x53),.d(x260),.e(x258),.f(x259));  // 6 ins 1 outs level 2

    xor6 x260i (.out(x260),.a(c29),.b(c7),.c(d50),.d(c25),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x259i (.out(x259),.a(c14),.b(c1),.c(c31),.d(d43),.e(c4),.f(c10));  // 6 ins 1 outs level 1

    xor6 x258i (.out(x258),.a(d63),.b(d21),.c(d79),.d(d30),.e(d66),.f(d35));  // 6 ins 1 outs level 1

    xor6 x257i (.out(x257),.a(d10),.b(d81),.c(d85),.d(d18),.e(d0),.f(d56));  // 6 ins 1 outs level 1

    xor6 x256i (.out(x256),.a(c20),.b(d19),.c(d47),.d(d32),.e(d87),.f(d37));  // 6 ins 1 outs level 1

    xor6 x255i (.out(x255),.a(x250),.b(x47),.c(x48),.d(x50),.e(x39),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x254i (.out(x254),.a(x251),.b(c31),.c(c25),.d(x41),.e(x33),.f(x252));  // 6 ins 1 outs level 2

    xor6 x252i (.out(x252),.a(c30),.b(d38),.c(d37),.d(c26),.e(d8),.f(c20));  // 6 ins 1 outs level 1

    xor6 x251i (.out(x251),.a(d0),.b(d5),.c(d49),.d(d36),.e(d81),.f(d2));  // 6 ins 1 outs level 1

    xor6 x250i (.out(x250),.a(d44),.b(d67),.c(d29),.d(d17),.e(d57),.f(d54));  // 6 ins 1 outs level 1

    xor6 x249i (.out(x249),.a(x245),.b(x48),.c(x49),.d(x248),.e(x246),.f(x247));  // 6 ins 1 outs level 2

    xor6 x248i (.out(x248),.a(d31),.b(c17),.c(d79),.d(d82),.e(d38),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x247i (.out(x247),.a(d75),.b(d55),.c(d41),.d(d20),.e(d25),.f(d39));  // 6 ins 1 outs level 1

    xor6 x246i (.out(x246),.a(c19),.b(c1),.c(d43),.d(d44),.e(d52),.f(c8));  // 6 ins 1 outs level 1

    xor6 x245i (.out(x245),.a(d73),.b(d59),.c(d29),.d(d53),.e(c3),.f(d66));  // 6 ins 1 outs level 1

    xor6 x244i (.out(x244),.a(x238),.b(d7),.c(x49),.d(x69),.e(x36),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x243i (.out(x243),.a(d79),.b(x239),.c(d11),.d(x38),.e(x240),.f(x241));  // 6 ins 1 outs level 2

    xor6 x241i (.out(x241),.a(c21),.b(d20),.c(d24),.d(d77),.e(d21),.f(d53));  // 6 ins 1 outs level 1

    xor6 x240i (.out(x240),.a(d49),.b(c4),.c(d45),.d(c26),.e(d70),.f(c11));  // 6 ins 1 outs level 1

    xor6 x239i (.out(x239),.a(d42),.b(d27),.c(d5),.d(d25),.e(d40),.f(d86));  // 6 ins 1 outs level 1

    xor6 x238i (.out(x238),.a(d50),.b(c10),.c(d36),.d(d19),.e(d44),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x237i (.out(x237),.a(x71),.b(x64),.c(x33),.d(x47),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x236i (.out(x236),.a(x232),.b(c22),.c(x233),.d(x234),.e(x235),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x235i (.out(x235),.a(c27),.b(d59),.c(d43),.d(c0),.e(d54),.f(c21));  // 6 ins 1 outs level 1

    xor6 x234i (.out(x234),.a(d24),.b(d8),.c(c25),.d(d32),.e(d25),.f(d33));  // 6 ins 1 outs level 1

    xor6 x233i (.out(x233),.a(d79),.b(d30),.c(d57),.d(c3),.e(d61),.f(d6));  // 6 ins 1 outs level 1

    xor6 x232i (.out(x232),.a(d81),.b(c5),.c(d78),.d(d20),.e(d56),.f(d50));  // 6 ins 1 outs level 1

    xor6 x231i (.out(x231),.a(x47),.b(x36),.c(x32),.d(x42),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x230i (.out(x230),.a(x226),.b(d25),.c(x59),.d(x227),.e(x228),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x229i (.out(x229),.a(d76),.b(c26),.c(c28),.d(c23),.e(c14),.f(d6));  // 6 ins 1 outs level 1

    xor6 x228i (.out(x228),.a(d13),.b(d55),.c(d26),.d(d23),.e(d9),.f(d24));  // 6 ins 1 outs level 1

    xor6 x227i (.out(x227),.a(d64),.b(d50),.c(d28),.d(d41),.e(d34),.f(d45));  // 6 ins 1 outs level 1

    xor6 x226i (.out(x226),.a(d27),.b(d3),.c(d21),.d(d33),.e(d59),.f(d82));  // 6 ins 1 outs level 1

    xor6 x225i (.out(x225),.a(x220),.b(x54),.c(x48),.d(x59),.e(x49),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x224i (.out(x224),.a(x221),.b(x32),.c(x62),.d(x222),.e(x223),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x223i (.out(x223),.a(c3),.b(d14),.c(c23),.d(d59),.e(d64),.f(d56));  // 6 ins 1 outs level 1

    xor6 x222i (.out(x222),.a(d32),.b(d83),.c(d3),.d(d67),.e(d22),.f(d79));  // 6 ins 1 outs level 1

    xor6 x221i (.out(x221),.a(d71),.b(d38),.c(d30),.d(c8),.e(d8),.f(c26));  // 6 ins 1 outs level 1

    xor6 x220i (.out(x220),.a(c29),.b(d27),.c(d13),.d(d66),.e(d47),.f(c27));  // 6 ins 1 outs level 1

    xor6 x219i (.out(x219),.a(x45),.b(x47),.c(x49),.d(x71),.e(x60),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x218i (.out(x218),.a(d83),.b(x215),.c(x54),.d(x216),.e(x217),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x217i (.out(x217),.a(d46),.b(d36),.c(d56),.d(d10),.e(d22),.f(c22));  // 6 ins 1 outs level 1

    xor6 x216i (.out(x216),.a(d9),.b(d6),.c(d78),.d(c30),.e(d5),.f(c3));  // 6 ins 1 outs level 1

    xor6 x215i (.out(x215),.a(d66),.b(d4),.c(c26),.d(d58),.e(d64),.f(d30));  // 6 ins 1 outs level 1

    xor6 x214i (.out(x214),.a(c29),.b(x211),.c(x60),.d(x212),.e(x213),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x213i (.out(x213),.a(d82),.b(d57),.c(d31),.d(d16),.e(d55),.f(d67));  // 6 ins 1 outs level 1

    xor6 x212i (.out(x212),.a(c28),.b(d25),.c(c10),.d(d38),.e(d84),.f(d30));  // 6 ins 1 outs level 1

    xor6 x211i (.out(x211),.a(c2),.b(c4),.c(d9),.d(d42),.e(d83),.f(d87));  // 6 ins 1 outs level 1

    xor6 x210i (.out(x210),.a(x42),.b(x39),.c(x69),.d(x52),.e(x34),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x209i (.out(x209),.a(x205),.b(x32),.c(x38),.d(x206),.e(x207),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x208i (.out(x208),.a(d20),.b(d13),.c(c8),.d(d1),.e(c16),.f(d7));  // 6 ins 1 outs level 1

    xor6 x207i (.out(x207),.a(d44),.b(d51),.c(d35),.d(c2),.e(d53),.f(c9));  // 6 ins 1 outs level 1

    xor6 x206i (.out(x206),.a(d72),.b(c30),.c(d70),.d(d38),.e(d11),.f(d58));  // 6 ins 1 outs level 1

    xor6 x205i (.out(x205),.a(d33),.b(d0),.c(c29),.d(d65),.e(d64),.f(d28));  // 6 ins 1 outs level 1

    xor6 x204i (.out(x204),.a(d35),.b(x199),.c(x38),.d(x33),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x203i (.out(x203),.a(x200),.b(x60),.c(x39),.d(x37),.e(x201),.f(x202));  // 6 ins 1 outs level 2

    xor6 x202i (.out(x202),.a(d64),.b(c2),.c(c8),.d(d14),.e(d53),.f(d82));  // 6 ins 1 outs level 1

    xor6 x201i (.out(x201),.a(d52),.b(d67),.c(d2),.d(d13),.e(d11),.f(d60));  // 6 ins 1 outs level 1

    xor6 x200i (.out(x200),.a(d38),.b(d8),.c(d37),.d(d57),.e(d26),.f(d0));  // 6 ins 1 outs level 1

    xor6 x199i (.out(x199),.a(d17),.b(d24),.c(d33),.d(d7),.e(d16),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x198i (.out(x198),.a(x194),.b(x45),.c(x46),.d(x197),.e(x195),.f(x196));  // 6 ins 1 outs level 2

    xor6 x197i (.out(x197),.a(c25),.b(d81),.c(d73),.d(c0),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x196i (.out(x196),.a(c1),.b(d37),.c(d40),.d(c28),.e(d36),.f(d76));  // 6 ins 1 outs level 1

    xor6 x195i (.out(x195),.a(d28),.b(c17),.c(d17),.d(d39),.e(c13),.f(d18));  // 6 ins 1 outs level 1

    xor6 x194i (.out(x194),.a(d69),.b(d80),.c(c24),.d(c2),.e(d3),.f(d27));  // 6 ins 1 outs level 1

    xor6 x193i (.out(x193),.a(x58),.b(x38),.c(x45),.d(x42),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x192i (.out(x192),.a(x187),.b(x191),.c(x188),.d(x189),.e(x190),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x191i (.out(x191),.a(d12),.b(c30),.c(d83),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x190i (.out(x190),.a(d20),.b(d19),.c(d32),.d(d15),.e(d85),.f(d74));  // 6 ins 1 outs level 1

    xor6 x189i (.out(x189),.a(c14),.b(d79),.c(c3),.d(d70),.e(d40),.f(d67));  // 6 ins 1 outs level 1

    xor6 x188i (.out(x188),.a(c27),.b(c26),.c(d30),.d(d6),.e(d39),.f(d48));  // 6 ins 1 outs level 1

    xor6 x187i (.out(x187),.a(d59),.b(d2),.c(d29),.d(c18),.e(c4),.f(d18));  // 6 ins 1 outs level 1

    xor6 x186i (.out(x186),.a(d67),.b(x33),.c(x35),.d(x60),.e(x50),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x185i (.out(x185),.a(x180),.b(x42),.c(x181),.d(x182),.e(x183),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x183i (.out(x183),.a(d3),.b(d61),.c(c22),.d(c8),.e(c5),.f(d47));  // 6 ins 1 outs level 1

    xor6 x182i (.out(x182),.a(d19),.b(c15),.c(d4),.d(d13),.e(c3),.f(d78));  // 6 ins 1 outs level 1

    xor6 x181i (.out(x181),.a(d40),.b(c23),.c(c18),.d(d20),.e(d37),.f(d49));  // 6 ins 1 outs level 1

    xor6 x180i (.out(x180),.a(d44),.b(d36),.c(c9),.d(d59),.e(d7),.f(d65));  // 6 ins 1 outs level 1

    xor6 x179i (.out(x179),.a(x175),.b(x67),.c(x60),.d(x32),.e(x47),.f(x39));  // 6 ins 1 outs level 2

    xor6 x178i (.out(x178),.a(x176),.b(d2),.c(x50),.d(x34),.e(x33),.f(x177));  // 6 ins 1 outs level 2

    xor6 x177i (.out(x177),.a(d14),.b(d43),.c(d55),.d(d0),.e(d7),.f(d40));  // 6 ins 1 outs level 1

    xor6 x176i (.out(x176),.a(d50),.b(d85),.c(c23),.d(d15),.e(d86),.f(d71));  // 6 ins 1 outs level 1

    xor6 x175i (.out(x175),.a(d24),.b(d42),.c(c20),.d(d20),.e(d11),.f(d4));  // 6 ins 1 outs level 1

    xor6 x174i (.out(x174),.a(x169),.b(x59),.c(x41),.d(x39),.e(x32),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x173i (.out(x173),.a(d39),.b(x170),.c(x45),.d(x171),.e(x172),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x172i (.out(x172),.a(d10),.b(d29),.c(d28),.d(d16),.e(d64),.f(d44));  // 6 ins 1 outs level 1

    xor6 x171i (.out(x171),.a(d87),.b(d70),.c(d24),.d(d58),.e(c20),.f(d0));  // 6 ins 1 outs level 1

    xor6 x170i (.out(x170),.a(d43),.b(d77),.c(d45),.d(c13),.e(d57),.f(d47));  // 6 ins 1 outs level 1

    xor6 x169i (.out(x169),.a(c19),.b(d22),.c(d75),.d(d52),.e(d69),.f(d23));  // 6 ins 1 outs level 1

    xor6 x168i (.out(x168),.a(x48),.b(x42),.c(x37),.d(x36),.e(x35),.f(x33));  // 6 ins 1 outs level 2

    xor6 x167i (.out(x167),.a(x163),.b(x166),.c(x32),.d(x49),.e(x164),.f(x165));  // 6 ins 1 outs level 2

    xor6 x166i (.out(x166),.a(d82),.b(d54),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x165i (.out(x165),.a(d1),.b(d42),.c(c27),.d(d66),.e(d87),.f(d76));  // 6 ins 1 outs level 1

    xor6 x164i (.out(x164),.a(d35),.b(d8),.c(d17),.d(d52),.e(d22),.f(d58));  // 6 ins 1 outs level 1

    xor6 x163i (.out(x163),.a(d10),.b(d57),.c(d28),.d(d9),.e(d40),.f(d44));  // 6 ins 1 outs level 1

    xor6 x162i (.out(x162),.a(x36),.b(x38),.c(x39),.d(x62),.e(x34),.f(x49));  // 6 ins 1 outs level 2

    xor6 x161i (.out(x161),.a(x156),.b(x160),.c(x50),.d(x157),.e(x158),.f(x159));  // 6 ins 1 outs level 2

    xor6 x160i (.out(x160),.a(d61),.b(c5),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x159i (.out(x159),.a(c13),.b(d9),.c(c29),.d(d51),.e(d46),.f(d12));  // 6 ins 1 outs level 1

    xor6 x158i (.out(x158),.a(c30),.b(d77),.c(d84),.d(d58),.e(d2),.f(d83));  // 6 ins 1 outs level 1

    xor6 x157i (.out(x157),.a(d52),.b(d34),.c(d33),.d(d21),.e(d69),.f(d53));  // 6 ins 1 outs level 1

    xor6 x156i (.out(x156),.a(d85),.b(c21),.c(d66),.d(c8),.e(d18),.f(d38));  // 6 ins 1 outs level 1

    xor6 x155i (.out(x155),.a(x151),.b(x64),.c(x62),.d(x53),.e(x42),.f(x36));  // 6 ins 1 outs level 2

    xor6 x154i (.out(x154),.a(x152),.b(x48),.c(x46),.d(x37),.e(x153),.f(x69));  // 6 ins 1 outs level 2

    xor6 x153i (.out(x153),.a(d16),.b(c4),.c(d1),.d(c2),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x152i (.out(x152),.a(d71),.b(c20),.c(d58),.d(d86),.e(c10),.f(d79));  // 6 ins 1 outs level 1

    xor6 x151i (.out(x151),.a(d33),.b(d31),.c(c29),.d(d32),.e(d5),.f(c26));  // 6 ins 1 outs level 1

    xor6 x150i (.out(x150),.a(x145),.b(x40),.c(x39),.d(x58),.e(x64),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x149i (.out(x149),.a(x146),.b(x148),.c(x35),.d(x36),.e(x147),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x148i (.out(x148),.a(d70),.b(d43),.c(d52),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x147i (.out(x147),.a(d38),.b(d51),.c(d3),.d(d55),.e(c8),.f(d36));  // 6 ins 1 outs level 1

    xor6 x146i (.out(x146),.a(d82),.b(d83),.c(d48),.d(d12),.e(c10),.f(d44));  // 6 ins 1 outs level 1

    xor6 x145i (.out(x145),.a(d64),.b(c4),.c(d25),.d(d86),.e(d14),.f(d84));  // 6 ins 1 outs level 1

    xor6 x144i (.out(x144),.a(x52),.b(x35),.c(x37),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 2

    xor6 x143i (.out(x143),.a(x139),.b(x34),.c(x42),.d(x142),.e(x140),.f(x141));  // 6 ins 1 outs level 2

    xor6 x142i (.out(x142),.a(c23),.b(c19),.c(d64),.d(c21),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x141i (.out(x141),.a(d57),.b(d75),.c(d61),.d(c5),.e(d71),.f(c31));  // 6 ins 1 outs level 1

    xor6 x140i (.out(x140),.a(d82),.b(d31),.c(d53),.d(c30),.e(d42),.f(d51));  // 6 ins 1 outs level 1

    xor6 x139i (.out(x139),.a(d27),.b(d4),.c(c27),.d(d17),.e(d13),.f(d29));  // 6 ins 1 outs level 1

    xor6 x138i (.out(x138),.a(x39),.b(x132),.c(x54),.d(x60),.e(x33),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x137i (.out(x137),.a(x133),.b(x136),.c(x53),.d(x134),.e(x135),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x136i (.out(x136),.a(d5),.b(d3),.c(d25),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x135i (.out(x135),.a(d55),.b(d64),.c(c13),.d(d31),.e(d69),.f(d18));  // 6 ins 1 outs level 1

    xor6 x134i (.out(x134),.a(c1),.b(c27),.c(d70),.d(c26),.e(d42),.f(d47));  // 6 ins 1 outs level 1

    xor6 x133i (.out(x133),.a(d54),.b(d87),.c(d43),.d(d52),.e(c31),.f(d48));  // 6 ins 1 outs level 1

    xor6 x132i (.out(x132),.a(c0),.b(d16),.c(d13),.d(d32),.e(d58),.f(d1));  // 6 ins 1 outs level 1

    xor6 x131i (.out(x131),.a(x126),.b(x34),.c(x48),.d(x41),.e(x52),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x130i (.out(x130),.a(d20),.b(x127),.c(x33),.d(x128),.e(x129),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x129i (.out(x129),.a(d70),.b(d4),.c(c27),.d(d84),.e(c0),.f(c31));  // 6 ins 1 outs level 1

    xor6 x128i (.out(x128),.a(c28),.b(d33),.c(c20),.d(d55),.e(d23),.f(d71));  // 6 ins 1 outs level 1

    xor6 x127i (.out(x127),.a(d17),.b(c3),.c(d73),.d(d11),.e(d43),.f(d8));  // 6 ins 1 outs level 1

    xor6 x126i (.out(x126),.a(d82),.b(d53),.c(c30),.d(d29),.e(d32),.f(c17));  // 6 ins 1 outs level 1

    xor6 x125i (.out(x125),.a(x36),.b(x58),.c(x47),.d(x67),.e(x50),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x124i (.out(x124),.a(d34),.b(d12),.c(x121),.d(x48),.e(x41),.f(x122));  // 6 ins 1 outs level 2

    xor6 x122i (.out(x122),.a(d17),.b(c24),.c(d53),.d(d45),.e(d49),.f(d47));  // 6 ins 1 outs level 1

    xor6 x121i (.out(x121),.a(d30),.b(d60),.c(c16),.d(d7),.e(d72),.f(d44));  // 6 ins 1 outs level 1

    xor6 x120i (.out(x120),.a(d80),.b(d55),.c(c1),.d(d8),.e(d22),.f(d33));  // 6 ins 1 outs level 1

    xor6 x119i (.out(x119),.a(x115),.b(x118),.c(x67),.d(x33),.e(x116),.f(x117));  // 6 ins 1 outs level 2

    xor6 x118i (.out(x118),.a(c30),.b(d34),.c(c23),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 2 outs level 1

    xor6 x117i (.out(x117),.a(d21),.b(c21),.c(d22),.d(c22),.e(d57),.f(d0));  // 6 ins 1 outs level 1

    xor6 x116i (.out(x116),.a(d19),.b(d46),.c(d17),.d(d48),.e(d87),.f(d26));  // 6 ins 1 outs level 1

    xor6 x115i (.out(x115),.a(c26),.b(c1),.c(d77),.d(d82),.e(d78),.f(c15));  // 6 ins 1 outs level 1

    xor6 x114i (.out(x114),.a(c27),.b(d56),.c(d5),.d(d8),.e(d41),.f(d29));  // 6 ins 1 outs level 1

    xor6 x113i (.out(x113),.a(x109),.b(x36),.c(x112),.d(x39),.e(x110),.f(x111));  // 6 ins 1 outs level 2

    xor6 x112i (.out(x112),.a(d83),.b(d13),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x111i (.out(x111),.a(d27),.b(d5),.c(d47),.d(d67),.e(d38),.f(c13));  // 6 ins 1 outs level 1

    xor6 x110i (.out(x110),.a(d69),.b(d25),.c(d36),.d(d22),.e(d52),.f(d11));  // 6 ins 1 outs level 1

    xor6 x109i (.out(x109),.a(d20),.b(d9),.c(d57),.d(c29),.e(c4),.f(d79));  // 6 ins 1 outs level 1

    xor6 x108i (.out(x108),.a(c31),.b(d23),.c(d14),.d(d48),.e(d1),.f(d45));  // 6 ins 1 outs level 1

    xor6 x107i (.out(x107),.a(x104),.b(x38),.c(x54),.d(x37),.e(x106),.f(x105));  // 6 ins 1 outs level 2

    xor6 x106i (.out(x106),.a(d39),.b(d21),.c(d23),.d(d15),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x105i (.out(x105),.a(c14),.b(d31),.c(d49),.d(d6),.e(d46),.f(d3));  // 6 ins 1 outs level 1

    xor6 x104i (.out(x104),.a(d85),.b(d24),.c(d44),.d(d26),.e(d86),.f(c28));  // 6 ins 1 outs level 1

    xor6 x103i (.out(x103),.a(d48),.b(d37),.c(d9),.d(d58),.e(d34),.f(d84));  // 6 ins 1 outs level 1

    xor6 x102i (.out(x102),.a(d7),.b(x97),.c(d54),.d(x98),.e(x99),.f(x100));  // 6 ins 1 outs level 2

    xor6 x100i (.out(x100),.a(d27),.b(d51),.c(d17),.d(d11),.e(c13),.f(c31));  // 6 ins 1 outs level 1

    xor6 x99i (.out(x99),.a(d69),.b(c22),.c(d3),.d(d15),.e(d60),.f(d38));  // 6 ins 1 outs level 1

    xor6 x98i (.out(x98),.a(c30),.b(c15),.c(d87),.d(d32),.e(d33),.f(d9));  // 6 ins 1 outs level 1

    xor6 x97i (.out(x97),.a(d22),.b(d35),.c(d78),.d(d50),.e(d85),.f(d40));  // 6 ins 1 outs level 1

    xor6 x96i (.out(x96),.a(x92),.b(x45),.c(x93),.d(x94),.e(x95),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x95i (.out(x95),.a(d33),.b(c25),.c(c14),.d(d4),.e(d28),.f(d16));  // 6 ins 1 outs level 1

    xor6 x94i (.out(x94),.a(d23),.b(d81),.c(d17),.d(d51),.e(d60),.f(c16));  // 6 ins 1 outs level 1

    xor6 x93i (.out(x93),.a(d55),.b(d41),.c(d30),.d(d36),.e(d39),.f(d9));  // 6 ins 1 outs level 1

    xor6 x92i (.out(x92),.a(c26),.b(d12),.c(d52),.d(d79),.e(d72),.f(d70));  // 6 ins 1 outs level 1

    xor6 x90i (.out(x90),.a(c4),.b(c31),.c(x86),.d(x71),.e(x87),.f(x88));  // 6 ins 1 outs level 2

    xor6 x88i (.out(x88),.a(d53),.b(d42),.c(d34),.d(d5),.e(d17),.f(d9));  // 6 ins 1 outs level 1

    xor6 x87i (.out(x87),.a(d52),.b(d10),.c(d24),.d(d22),.e(d31),.f(d48));  // 6 ins 1 outs level 1

    xor6 x86i (.out(x86),.a(d40),.b(d83),.c(d19),.d(d37),.e(d51),.f(c14));  // 6 ins 1 outs level 1

    xor6 x85i (.out(x85),.a(x81),.b(x69),.c(x58),.d(x82),.e(x83),.f(x84));  // 6 ins 1 outs level 2

    xor6 x84i (.out(x84),.a(d55),.b(d60),.c(d74),.d(d14),.e(d35),.f(c29));  // 6 ins 1 outs level 1

    xor6 x83i (.out(x83),.a(d9),.b(d0),.c(c18),.d(d58),.e(c1),.f(d36));  // 6 ins 1 outs level 1

    xor6 x82i (.out(x82),.a(c27),.b(d16),.c(d66),.d(d31),.e(d32),.f(d79));  // 6 ins 1 outs level 1

    xor6 x81i (.out(x81),.a(d52),.b(c2),.c(d27),.d(d56),.e(d11),.f(c11));  // 6 ins 1 outs level 1

    xor6 x80i (.out(x80),.a(x69),.b(x74),.c(x46),.d(x39),.e(x35),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x79i (.out(x79),.a(d31),.b(x75),.c(d13),.d(x52),.e(x76),.f(x77));  // 6 ins 1 outs level 2

    xor6 x77i (.out(x77),.a(d19),.b(c16),.c(d72),.d(d24),.e(d54),.f(c13));  // 6 ins 1 outs level 1

    xor6 x76i (.out(x76),.a(c30),.b(c27),.c(d69),.d(c31),.e(d82),.f(d70));  // 6 ins 1 outs level 1

    xor6 x75i (.out(x75),.a(d15),.b(d35),.c(d75),.d(d26),.e(d45),.f(d42));  // 6 ins 1 outs level 1

    xor6 x74i (.out(x74),.a(c19),.b(d84),.c(d46),.d(d34),.e(d29),.f(c28));  // 6 ins 1 outs level 1

    xor6 x73i (.out(x73),.a(d32),.b(x37),.c(x53),.d(c20),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x72i (.out(x72),.a(d18),.b(d85),.c(x39),.d(d30),.e(1'b0),.f(1'b0));  // 4 ins 4 outs level 2

    xor6 x71i (.out(x71),.a(d27),.b(d49),.c(c24),.d(d71),.e(d80),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x70i (.out(x70),.a(d65),.b(x34),.c(d59),.d(c9),.e(d44),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x69i (.out(x69),.a(c4),.b(c6),.c(d56),.d(d62),.e(d29),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x68i (.out(x68),.a(d68),.b(d71),.c(d1),.d(c12),.e(x41),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x67i (.out(x67),.a(d30),.b(d84),.c(c10),.d(c28),.e(d86),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x66i (.out(x66),.a(x34),.b(d54),.c(x54),.d(d42),.e(c11),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x65i (.out(x65),.a(d57),.b(x35),.c(d66),.d(x46),.e(1'b0),.f(1'b0));  // 4 ins 5 outs level 2

    xor6 x64i (.out(x64),.a(d28),.b(c14),.c(d57),.d(d26),.e(d40),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x63i (.out(x63),.a(d87),.b(d19),.c(d0),.d(d18),.e(x43),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x62i (.out(x62),.a(d35),.b(d13),.c(c14),.d(c15),.e(c0),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x61i (.out(x61),.a(d79),.b(d63),.c(x43),.d(c7),.e(d58),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x60i (.out(x60),.a(d82),.b(d6),.c(d72),.d(c16),.e(d50),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x59i (.out(x59),.a(d46),.b(d51),.c(d7),.d(d52),.e(d42),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x58i (.out(x58),.a(d4),.b(d47),.c(d41),.d(d24),.e(d66),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x57i (.out(x57),.a(d2),.b(d77),.c(c1),.d(x50),.e(d12),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x56i (.out(x56),.a(x40),.b(c28),.c(c11),.d(d11),.e(c27),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x55i (.out(x55),.a(d34),.b(d12),.c(d37),.d(c31),.e(x38),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x54i (.out(x54),.a(d10),.b(d28),.c(d60),.d(d53),.e(1'b0),.f(1'b0));  // 4 ins 6 outs level 1

    xor6 x53i (.out(x53),.a(d19),.b(c30),.c(d2),.d(d7),.e(d14),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x52i (.out(x52),.a(c23),.b(d6),.c(d87),.d(d76),.e(d49),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x51i (.out(x51),.a(d17),.b(d20),.c(d16),.d(x37),.e(d27),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x50i (.out(x50),.a(d64),.b(d5),.c(d21),.d(d71),.e(d41),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x49i (.out(x49),.a(d4),.b(d23),.c(c10),.d(d43),.e(d67),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x48i (.out(x48),.a(c21),.b(d3),.c(c2),.d(d77),.e(1'b0),.f(1'b0));  // 4 ins 10 outs level 1

    xor6 x47i (.out(x47),.a(c6),.b(d57),.c(c8),.d(d62),.e(d22),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x46i (.out(x46),.a(d45),.b(d38),.c(d65),.d(d85),.e(c9),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x45i (.out(x45),.a(d25),.b(c4),.c(d50),.d(d8),.e(d86),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x44i (.out(x44),.a(x32),.b(d39),.c(d36),.d(d55),.e(d1),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x43i (.out(x43),.a(d82),.b(c5),.c(d61),.d(d48),.e(d26),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x42i (.out(x42),.a(c7),.b(d69),.c(c13),.d(d63),.e(d46),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x41i (.out(x41),.a(d52),.b(d56),.c(d54),.d(c15),.e(d15),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x40i (.out(x40),.a(c1),.b(d84),.c(d31),.d(d33),.e(d58),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x39i (.out(x39),.a(c18),.b(d74),.c(d76),.d(d86),.e(c0),.f(1'b0));  // 5 ins 13 outs level 1

    xor6 x38i (.out(x38),.a(d68),.b(d44),.c(c23),.d(c12),.e(d32),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x37i (.out(x37),.a(d50),.b(c29),.c(c3),.d(d9),.e(d59),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x36i (.out(x36),.a(d78),.b(c22),.c(c2),.d(c20),.e(c4),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x35i (.out(x35),.a(c17),.b(c26),.c(d0),.d(c27),.e(d73),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x34i (.out(x34),.a(d81),.b(c25),.c(d47),.d(d29),.e(d24),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x33i (.out(x33),.a(d83),.b(d75),.c(c14),.d(c19),.e(d51),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x32i (.out(x32),.a(d80),.b(d70),.c(c24),.d(d79),.e(d60),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x23i (.out(x23),.a(x79),.b(x34),.c(x51),.d(x44),.e(x80),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x22i (.out(x22),.a(x85),.b(x65),.c(x49),.d(x63),.e(x55),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x21i (.out(x21),.a(x90),.b(x69),.c(x35),.d(x62),.e(x63),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x20i (.out(x20),.a(x96),.b(d21),.c(d87),.d(c31),.e(x43),.f(x118));  // 6 ins 1 outs level 3

    xor6 x19i (.out(x19),.a(x102),.b(x34),.c(x45),.d(x71),.e(x51),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x18i (.out(x18),.a(x103),.b(x48),.c(x32),.d(x53),.e(x107),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x17i (.out(x17),.a(x108),.b(x72),.c(x52),.d(x56),.e(x113),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x16i (.out(x16),.a(x114),.b(x58),.c(x55),.d(x62),.e(x119),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x15i (.out(x15),.a(x120),.b(x72),.c(x51),.d(x125),.e(x124),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x14i (.out(x14),.a(x130),.b(x53),.c(x70),.d(x61),.e(x131),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x13i (.out(x13),.a(x137),.b(x36),.c(x47),.d(x138),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x12i (.out(x12),.a(x143),.b(x72),.c(x68),.d(x57),.e(x144),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x11i (.out(x11),.a(x149),.b(x46),.c(x68),.d(x51),.e(x150),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x10i (.out(x10),.a(x65),.b(x154),.c(x33),.d(x59),.e(x44),.f(x155));  // 6 ins 1 outs level 3

    xor6 x9i (.out(x9),.a(x161),.b(x56),.c(x40),.d(x44),.e(x162),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x8i (.out(x8),.a(x167),.b(x46),.c(x56),.d(x55),.e(x168),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x7i (.out(x7),.a(x173),.b(x48),.c(x57),.d(x55),.e(x174),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x6i (.out(x6),.a(x178),.b(x45),.c(x65),.d(x68),.e(x179),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x5i (.out(x5),.a(d74),.b(x185),.c(x66),.d(x44),.e(x186),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x4i (.out(x4),.a(x192),.b(x48),.c(x65),.d(x56),.e(x193),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x3i (.out(x3),.a(x73),.b(x40),.c(x54),.d(x68),.e(x198),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x2i (.out(x2),.a(x203),.b(x72),.c(x56),.d(x44),.e(x204),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x1i (.out(x1),.a(x208),.b(x51),.c(x55),.d(x209),.e(x210),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x0i (.out(x0),.a(x214),.b(x55),.c(x65),.d(x66),.e(x61),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x31i (.out(x31),.a(x218),.b(x41),.c(x70),.d(x56),.e(x219),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x30i (.out(x30),.a(x224),.b(x34),.c(x46),.d(x61),.e(x225),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x29i (.out(x29),.a(x229),.b(x40),.c(x70),.d(x231),.e(x230),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x28i (.out(x28),.a(x236),.b(x38),.c(x42),.d(x57),.e(x237),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x27i (.out(x27),.a(x243),.b(x61),.c(x39),.d(x44),.e(x244),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x26i (.out(x26),.a(x249),.b(x36),.c(x47),.d(x52),.e(x66),.f(x63));  // 6 ins 1 outs level 3

    xor6 x25i (.out(x25),.a(x254),.b(x63),.c(x56),.d(x64),.e(x255),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x24i (.out(x24),.a(x261),.b(x51),.c(x64),.d(x44),.e(x262),.f(1'b0));  // 5 ins 1 outs level 3

endmodule

