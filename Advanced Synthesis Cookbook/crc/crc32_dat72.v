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

//// CRC-32 of 72 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 000000000011111111112222222222333333333344444444445555555555666666666677
//        01234567890123456789012345678901 012345678901234567890123456789012345678901234567890123456789012345678901
//
// C00  = ....XX.XX.X..XXX..X.XX.X.XXXX... X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...
// C01  = ....X.XX.XXX.X..X.XXX.XXXX...X.. XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..X.XXX.XXXX...X..
// C02  = ....X......XXX.X.XXX....X..XX.X. XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.
// C03  = X....X......XXX.X.XXX....X..XX.X .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X
// C04  = XX..XXXXX.X......XXX...X.X.XXXX. X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X......XXX...X.X.XXXX.
// C05  = XXX.X.X..XXX.XXX...X.X.XXX.X.XXX XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXX
// C06  = XXXX.X.X..XXX.XXX...X.X.XXX.X.XX .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XX
// C07  = .XXX.XXX..XXX.X.XXX.X.......XX.X X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.XXX.X.......XX.X
// C08  = X.XX.XX...XXX.X..X.XX..X.XXXXXX. XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX.
// C09  = .X.XX.XX...XXX.X..X.XX..X.XXXXXX .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX
// C10  = X.X.......X.X..XX.XXX.XX..X..XXX X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..XX.XXX.XX..X..XXX
// C11  = XX.XXX.XX.XX..XXXXXX....XXX.X.XX XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XXXXXX....XXX.X.XX
// C12  = .XX...XX.XXXXXX.XX.X.X.X....XX.X XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X
// C13  = ..XX...XX.XXXXXX.XX.X.X.X....XX. .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.
// C14  = ...XX...XX.XXXXXX.XX.X.X.X....XX ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX
// C15  = ....XX...XX.XXXXXX.XX.X.X.X....X ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....X
// C16  = ....X.XXX..X....XX........X.X... X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X...
// C17  = .....X.XXX..X....XX........X.X.. .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X..
// C18  = ......X.XXX..X....XX........X.X. ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X.
// C19  = X......X.XXX..X....XX........X.X ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X
// C20  = .X......X.XXX..X....XX........X. ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.
// C21  = X.X......X.XXX..X....XX........X .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X
// C22  = .X.XXX.XX...X..X.XX.XXX..XXXX... X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X.XX.XXX..XXXX...
// C23  = ..X...XX.XX...XXX..XX.X..X...X.. XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..
// C24  = X..X...XX.XX...XXX..XX.X..X...X. .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X.
// C25  = XX..X...XX.XX...XXX..XX.X..X...X ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X
// C26  = .XX.X..XXX..X.XX.X.XXXX...XX.... X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX....
// C27  = X.XX.X..XXX..X.XX.X.XXXX...XX... .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX...
// C28  = XX.XX.X..XXX..X.XX.X.XXXX...XX.. ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX..
// C29  = .XX.XX.X..XXX..X.XX.X.XXXX...XX. ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.
// C30  = ..XX.XX.X..XXX..X.XX.X.XXXX...XX ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX
// C31  = ...XX.XX.X..XXX..X.XX.X.XXXX...X .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...X
//
module crc32_dat72 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [71:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat72_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat72_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat72_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [71:0] dat_in;
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
    d63,d64,d65,d66,d67,d68,d69,d70,d71;

assign { d71,d70,d69,d68,d67,d66,d65,d64,d63,d62,d61,d60,d59,d58,d57,
        d56,d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [71:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x7 = d47 ^ d0 ^ d56 ^ d69 ^ c18 ^ d21 ^ c11 ^ c14 ^ d46 ^ 
        c5 ^ d43 ^ d45 ^ d5 ^ c20 ^ d22 ^ d15 ^ c17 ^ d7 ^ d34 ^ 
        d3 ^ c12 ^ c10 ^ d16 ^ c29 ^ d60 ^ c2 ^ d8 ^ d10 ^ d57 ^ 
        c7 ^ d39 ^ d2 ^ c28 ^ d58 ^ d71 ^ d25 ^ d68 ^ d54 ^ d24 ^ 
        d23 ^ d37 ^ d51 ^ d50 ^ c16 ^ d52 ^ c6 ^ d29 ^ d32 ^ d28 ^ 
        c3 ^ c31 ^ d42 ^ d41 ^ c1;  // 54 ins 1 outs level 3

    assign x6 = c28 ^ c26 ^ d56 ^ d66 ^ d14 ^ d7 ^ c11 ^ d2 ^ c16 ^ 
        d4 ^ d25 ^ d38 ^ c25 ^ d21 ^ d70 ^ c3 ^ d68 ^ d40 ^ c31 ^ 
        d8 ^ d6 ^ d52 ^ d11 ^ c12 ^ d60 ^ d29 ^ d41 ^ d65 ^ c14 ^ 
        d62 ^ c22 ^ d55 ^ c24 ^ d50 ^ c20 ^ c1 ^ c7 ^ c2 ^ c5 ^ 
        d64 ^ d43 ^ d71 ^ d5 ^ c15 ^ d22 ^ d20 ^ d42 ^ d51 ^ c0 ^ 
        d30 ^ c10 ^ d1 ^ c30 ^ d47 ^ d54 ^ d45;  // 56 ins 1 outs level 3

    assign x5 = c13 ^ d53 ^ d50 ^ c10 ^ d1 ^ d51 ^ d54 ^ c11 ^ d63 ^ 
        d41 ^ c19 ^ c14 ^ d20 ^ c31 ^ c15 ^ d0 ^ d5 ^ d70 ^ c2 ^ 
        c4 ^ d6 ^ d19 ^ c25 ^ d44 ^ d10 ^ c0 ^ d64 ^ c30 ^ c21 ^ 
        d37 ^ c9 ^ d40 ^ d61 ^ d29 ^ d71 ^ d65 ^ d24 ^ d28 ^ d55 ^ 
        d42 ^ d4 ^ d3 ^ c1 ^ c6 ^ d49 ^ d67 ^ c29 ^ c23 ^ d59 ^ 
        d46 ^ d13 ^ c24 ^ c27 ^ d39 ^ d69 ^ d7 ^ d21;  // 57 ins 1 outs level 3

    assign x4 = c4 ^ d45 ^ d48 ^ d12 ^ d31 ^ d67 ^ d70 ^ d63 ^ c18 ^ 
        d8 ^ d25 ^ d40 ^ d4 ^ c27 ^ d15 ^ c29 ^ c28 ^ d18 ^ d6 ^ 
        d39 ^ c8 ^ d33 ^ d57 ^ d3 ^ d59 ^ d41 ^ c6 ^ d29 ^ d38 ^ 
        c25 ^ d58 ^ d11 ^ d46 ^ d2 ^ d0 ^ d24 ^ d44 ^ d69 ^ d47 ^ 
        d68 ^ c17 ^ c1 ^ c19 ^ c10 ^ c30 ^ d50 ^ d65 ^ d30 ^ c5 ^ 
        d19 ^ c23 ^ c7 ^ d20 ^ c0;  // 54 ins 1 outs level 3

    assign x3 = d2 ^ d39 ^ d36 ^ d31 ^ d56 ^ d3 ^ d69 ^ d54 ^ d32 ^ 
        d58 ^ d60 ^ c19 ^ d10 ^ c12 ^ c25 ^ d68 ^ d9 ^ c20 ^ c29 ^ 
        d7 ^ d8 ^ c0 ^ d19 ^ d18 ^ c31 ^ d15 ^ c5 ^ c16 ^ d38 ^ 
        c28 ^ d52 ^ d1 ^ c14 ^ d65 ^ d59 ^ d14 ^ c13 ^ d53 ^ d71 ^ 
        d40 ^ d45 ^ d17 ^ d25 ^ d33 ^ d37 ^ c18 ^ d27;  // 47 ins 1 outs level 3

    assign x2 = d55 ^ d59 ^ d44 ^ d14 ^ c30 ^ c24 ^ c27 ^ d9 ^ d16 ^ 
        c28 ^ c4 ^ d6 ^ d37 ^ d26 ^ c15 ^ d52 ^ d38 ^ d64 ^ d57 ^ 
        d18 ^ d13 ^ d32 ^ d7 ^ d24 ^ d67 ^ c12 ^ d35 ^ d58 ^ d31 ^ 
        c17 ^ c11 ^ d17 ^ d0 ^ c18 ^ d51 ^ d53 ^ c19 ^ d1 ^ d68 ^ 
        c13 ^ d70 ^ d2 ^ d39 ^ d36 ^ d8 ^ d30;  // 46 ins 1 outs level 3

    assign x1 = d47 ^ d6 ^ c13 ^ d53 ^ d50 ^ c10 ^ d1 ^ d51 ^ d0 ^ 
        c11 ^ d7 ^ d13 ^ d9 ^ d69 ^ d63 ^ d62 ^ d16 ^ d64 ^ c16 ^ 
        c4 ^ c24 ^ d46 ^ c29 ^ d49 ^ c6 ^ d33 ^ d37 ^ d65 ^ c9 ^ 
        d44 ^ d17 ^ c20 ^ d38 ^ c25 ^ c23 ^ c18 ^ d60 ^ d24 ^ c19 ^ 
        c7 ^ d11 ^ d34 ^ d28 ^ d35 ^ d12 ^ d27 ^ d56 ^ c22 ^ d59 ^ 
        d58;  // 50 ins 1 outs level 3

    assign x0 = d16 ^ c27 ^ d55 ^ c21 ^ c26 ^ d61 ^ d47 ^ d28 ^ d24 ^ 
        c25 ^ d32 ^ d29 ^ d37 ^ c28 ^ d60 ^ c14 ^ c8 ^ d6 ^ d9 ^ 
        d10 ^ c20 ^ c4 ^ d45 ^ d48 ^ c18 ^ c15 ^ d63 ^ d26 ^ d12 ^ 
        d31 ^ d58 ^ d34 ^ d67 ^ c7 ^ c23 ^ d44 ^ d66 ^ d0 ^ d54 ^ 
        c5 ^ d30 ^ d25 ^ c13 ^ d65 ^ d68 ^ d53 ^ d50 ^ c10;  // 48 ins 1 outs level 3

    assign x31 = d24 ^ d36 ^ d62 ^ d64 ^ d11 ^ c26 ^ c20 ^ d54 ^ c3 ^ 
        d8 ^ d47 ^ d71 ^ d46 ^ d28 ^ d43 ^ d65 ^ d33 ^ d23 ^ c12 ^ 
        c22 ^ d67 ^ c25 ^ c31 ^ d25 ^ d30 ^ c7 ^ d66 ^ c19 ^ c9 ^ 
        d49 ^ c6 ^ d53 ^ d15 ^ d44 ^ c4 ^ d27 ^ c17 ^ d60 ^ c13 ^ 
        d5 ^ d59 ^ d31 ^ c24 ^ c14 ^ d29 ^ d52 ^ c27 ^ d57 ^ d9;  // 49 ins 1 outs level 3

    assign x30 = c30 ^ d61 ^ d59 ^ d63 ^ d70 ^ c21 ^ c8 ^ d30 ^ d28 ^ 
        c3 ^ c18 ^ d52 ^ d65 ^ c16 ^ d14 ^ c2 ^ d46 ^ c19 ^ c11 ^ 
        d32 ^ d24 ^ d71 ^ d7 ^ d45 ^ d58 ^ c6 ^ d23 ^ d66 ^ c24 ^ 
        d29 ^ d22 ^ c25 ^ d51 ^ d4 ^ d43 ^ c26 ^ d27 ^ d26 ^ d8 ^ 
        d10 ^ c13 ^ c12 ^ d42 ^ d48 ^ d56 ^ d53 ^ d35 ^ d64 ^ c23 ^ 
        c31 ^ c5;  // 51 ins 1 outs level 3

    assign x29 = c20 ^ d51 ^ c17 ^ d7 ^ d28 ^ c30 ^ d62 ^ c22 ^ d44 ^ 
        c4 ^ d25 ^ d31 ^ d47 ^ d70 ^ d50 ^ d13 ^ d64 ^ c29 ^ d22 ^ 
        d45 ^ d6 ^ c1 ^ d58 ^ c2 ^ c5 ^ d57 ^ d69 ^ c25 ^ d3 ^ 
        d60 ^ c18 ^ d34 ^ c24 ^ c23 ^ c10 ^ d42 ^ d27 ^ d63 ^ d41 ^ 
        d21 ^ d9 ^ d65 ^ c12 ^ c15 ^ d23 ^ c11 ^ d29 ^ c7 ^ d52 ^ 
        d55 ^ d26;  // 51 ins 1 outs level 3

    assign x28 = c28 ^ d27 ^ d5 ^ d41 ^ d8 ^ c10 ^ d24 ^ d44 ^ c21 ^ 
        d63 ^ d6 ^ d46 ^ d59 ^ c4 ^ d68 ^ c6 ^ c1 ^ d12 ^ d33 ^ 
        c24 ^ d25 ^ d56 ^ d2 ^ d64 ^ d50 ^ d69 ^ d20 ^ c0 ^ d28 ^ 
        d22 ^ d43 ^ c11 ^ d54 ^ d61 ^ d62 ^ c23 ^ d51 ^ c14 ^ d40 ^ 
        d57 ^ c29 ^ c22 ^ c3 ^ c19 ^ d26 ^ d21 ^ c17 ^ d30 ^ d49 ^ 
        c16 ^ c9;  // 51 ins 1 outs level 3

    assign x27 = d20 ^ d7 ^ c18 ^ d32 ^ c27 ^ c5 ^ c0 ^ d21 ^ d49 ^ 
        c13 ^ d1 ^ d25 ^ d42 ^ d43 ^ c23 ^ c8 ^ c22 ^ d23 ^ c9 ^ 
        d48 ^ d58 ^ d29 ^ d61 ^ d45 ^ c3 ^ c15 ^ d40 ^ c16 ^ d4 ^ 
        d19 ^ d56 ^ d60 ^ d63 ^ d67 ^ d27 ^ d50 ^ c20 ^ d55 ^ d39 ^ 
        d11 ^ c21 ^ d24 ^ d68 ^ c28 ^ c10 ^ d53 ^ d62 ^ d26 ^ c2 ^ 
        d5;  // 50 ins 1 outs level 3

    assign x26 = d25 ^ d24 ^ d48 ^ d4 ^ d54 ^ d0 ^ d19 ^ d66 ^ d28 ^ 
        c2 ^ d44 ^ d47 ^ c7 ^ d39 ^ c12 ^ d31 ^ d61 ^ c19 ^ d20 ^ 
        c15 ^ d22 ^ d6 ^ d67 ^ c17 ^ d26 ^ d18 ^ c4 ^ d3 ^ d62 ^ 
        c1 ^ c22 ^ d23 ^ c20 ^ d10 ^ c8 ^ c14 ^ d42 ^ d60 ^ c26 ^ 
        d57 ^ d52 ^ d49 ^ c21 ^ d55 ^ c27 ^ d38 ^ d41 ^ d59 ^ c9;  // 49 ins 1 outs level 3

    assign x25 = c22 ^ c27 ^ d8 ^ d31 ^ c1 ^ d44 ^ c17 ^ d28 ^ d22 ^ 
        d33 ^ d21 ^ d62 ^ d51 ^ d2 ^ d41 ^ d52 ^ d38 ^ c18 ^ c4 ^ 
        d29 ^ c24 ^ d36 ^ d67 ^ d58 ^ c11 ^ d64 ^ d56 ^ d3 ^ d11 ^ 
        d37 ^ c8 ^ c12 ^ d49 ^ d18 ^ d57 ^ d48 ^ c16 ^ c21 ^ d40 ^ 
        d71 ^ c9 ^ d61 ^ d17 ^ d15 ^ c31 ^ d19 ^ c0;  // 47 ins 1 outs level 3

    assign x24 = d55 ^ d66 ^ d14 ^ c30 ^ c23 ^ d10 ^ d48 ^ d36 ^ d16 ^ 
        d40 ^ d17 ^ c16 ^ d37 ^ d61 ^ c26 ^ d56 ^ d20 ^ d63 ^ d7 ^ 
        d51 ^ c11 ^ d60 ^ c3 ^ d50 ^ c8 ^ c0 ^ d39 ^ d1 ^ d2 ^ 
        d70 ^ d21 ^ c21 ^ d43 ^ c10 ^ d18 ^ d47 ^ c20 ^ d35 ^ c17 ^ 
        c15 ^ c7 ^ d57 ^ d30 ^ d27 ^ d32 ^ d28;  // 46 ins 1 outs level 3

    assign x23 = d50 ^ d20 ^ d35 ^ d36 ^ d42 ^ c7 ^ d39 ^ d65 ^ c20 ^ 
        d16 ^ d55 ^ c19 ^ d9 ^ d6 ^ d34 ^ d29 ^ d54 ^ d0 ^ d1 ^ 
        c10 ^ c6 ^ d19 ^ d31 ^ c15 ^ d59 ^ c22 ^ d26 ^ d56 ^ d27 ^ 
        c14 ^ c25 ^ d38 ^ d60 ^ d47 ^ d17 ^ d69 ^ c9 ^ d15 ^ d49 ^ 
        c2 ^ c29 ^ d46 ^ c16 ^ d62 ^ d13;  // 45 ins 1 outs level 3

    assign x22 = d68 ^ d43 ^ d62 ^ c5 ^ d35 ^ d9 ^ d0 ^ d18 ^ d60 ^ 
        c3 ^ c25 ^ d36 ^ d38 ^ d65 ^ d66 ^ d44 ^ c8 ^ d47 ^ d23 ^ 
        c7 ^ d57 ^ d67 ^ d34 ^ c12 ^ d58 ^ d19 ^ c1 ^ c22 ^ c15 ^ 
        d31 ^ d12 ^ d26 ^ c18 ^ d41 ^ c17 ^ d11 ^ d48 ^ d14 ^ d45 ^ 
        c4 ^ c20 ^ c28 ^ d37 ^ d29 ^ d24 ^ d27 ^ d61 ^ c26 ^ c21 ^ 
        d55 ^ c27 ^ d16 ^ d52;  // 53 ins 1 outs level 3

    assign x21 = d49 ^ d17 ^ c22 ^ d34 ^ c12 ^ c13 ^ d42 ^ d9 ^ c31 ^ 
        d31 ^ d35 ^ c9 ^ c16 ^ d13 ^ d71 ^ c11 ^ d53 ^ d40 ^ d51 ^ 
        d37 ^ d22 ^ d29 ^ d62 ^ d5 ^ c2 ^ d52 ^ d56 ^ d61 ^ d27 ^ 
        c0 ^ d18 ^ c21 ^ d26 ^ d10 ^ d24;  // 35 ins 1 outs level 3

    assign x20 = d12 ^ d70 ^ c30 ^ d17 ^ d52 ^ d16 ^ d41 ^ c20 ^ c1 ^ 
        d33 ^ c21 ^ c12 ^ d55 ^ d48 ^ c8 ^ c11 ^ d36 ^ d39 ^ d34 ^ 
        d30 ^ d28 ^ d60 ^ d51 ^ d8 ^ d26 ^ d4 ^ c15 ^ d25 ^ d50 ^ 
        d21 ^ d9 ^ d23 ^ c10 ^ d61;  // 34 ins 1 outs level 3

    assign x19 = d40 ^ d16 ^ d50 ^ c0 ^ c10 ^ c19 ^ d22 ^ d69 ^ d27 ^ 
        c20 ^ c11 ^ d47 ^ d49 ^ d29 ^ c14 ^ d60 ^ c29 ^ d24 ^ d33 ^ 
        d38 ^ d71 ^ d15 ^ d35 ^ c31 ^ c9 ^ d32 ^ d3 ^ c7 ^ d7 ^ 
        d59 ^ d54 ^ d51 ^ d8 ^ d11 ^ d25 ^ d20;  // 36 ins 1 outs level 3

    assign x18 = d28 ^ d34 ^ c10 ^ d49 ^ d46 ^ c9 ^ c6 ^ c30 ^ d24 ^ 
        d14 ^ d26 ^ c8 ^ d39 ^ c13 ^ d10 ^ c28 ^ d7 ^ d2 ^ d58 ^ 
        c19 ^ d48 ^ d53 ^ d50 ^ d59 ^ c18 ^ d6 ^ d37 ^ d19 ^ d15 ^ 
        d31 ^ d70 ^ d23 ^ d68 ^ d32 ^ d21;  // 35 ins 1 outs level 3

    assign x17 = d18 ^ d69 ^ c27 ^ d38 ^ c18 ^ c8 ^ c12 ^ d27 ^ d5 ^ 
        c17 ^ d33 ^ d49 ^ c5 ^ d58 ^ d48 ^ d25 ^ d67 ^ c9 ^ d13 ^ 
        d57 ^ d14 ^ d31 ^ d1 ^ d30 ^ d23 ^ d9 ^ d22 ^ d52 ^ d20 ^ 
        d45 ^ c29 ^ d36 ^ d6 ^ c7 ^ d47;  // 35 ins 1 outs level 3

    assign x16 = d47 ^ d21 ^ c8 ^ c26 ^ d24 ^ d13 ^ d35 ^ d22 ^ d17 ^ 
        c4 ^ d5 ^ c17 ^ d12 ^ d0 ^ c16 ^ d30 ^ d26 ^ d57 ^ d8 ^ 
        c11 ^ d56 ^ c28 ^ d66 ^ d48 ^ c7 ^ d37 ^ d29 ^ d51 ^ d44 ^ 
        d68 ^ d4 ^ d32 ^ d19 ^ c6 ^ d46;  // 35 ins 1 outs level 3

    assign x15 = d4 ^ d66 ^ d59 ^ d50 ^ c5 ^ d44 ^ d20 ^ d7 ^ d34 ^ 
        d21 ^ d9 ^ d12 ^ c10 ^ d27 ^ d57 ^ d71 ^ c24 ^ d54 ^ c26 ^ 
        d15 ^ c31 ^ c9 ^ c16 ^ c14 ^ d45 ^ d60 ^ c19 ^ d30 ^ c17 ^ 
        d55 ^ c15 ^ c4 ^ c20 ^ d56 ^ d16 ^ d5 ^ d24 ^ d33 ^ d18 ^ 
        d53 ^ d64 ^ d3 ^ c22 ^ d62 ^ d52 ^ d49 ^ d8 ^ c13 ^ c12;  // 49 ins 1 outs level 3

    assign x14 = d65 ^ d58 ^ d56 ^ c30 ^ d3 ^ d44 ^ d4 ^ d17 ^ d14 ^ 
        d7 ^ d2 ^ d32 ^ c19 ^ d70 ^ d8 ^ c12 ^ d11 ^ c23 ^ d26 ^ 
        c11 ^ c16 ^ d51 ^ c25 ^ d49 ^ d43 ^ d61 ^ c18 ^ d15 ^ d55 ^ 
        d71 ^ d33 ^ d54 ^ c14 ^ d6 ^ c9 ^ c15 ^ d59 ^ c8 ^ d48 ^ 
        d29 ^ c4 ^ d52 ^ c21 ^ d53 ^ d23 ^ d63 ^ c13 ^ c31 ^ c3 ^ 
        d20 ^ d19;  // 51 ins 1 outs level 3

    assign x13 = d14 ^ c30 ^ c29 ^ c14 ^ d54 ^ d53 ^ d6 ^ d19 ^ d62 ^ 
        c3 ^ d55 ^ d60 ^ d16 ^ d2 ^ d5 ^ d42 ^ c8 ^ c15 ^ d70 ^ 
        d51 ^ c17 ^ d25 ^ d31 ^ c13 ^ d32 ^ c22 ^ c24 ^ d3 ^ d50 ^ 
        c20 ^ d48 ^ d58 ^ d64 ^ c10 ^ d47 ^ d69 ^ d10 ^ d13 ^ c12 ^ 
        d22 ^ d7 ^ c7 ^ c18 ^ c11 ^ d1 ^ d18 ^ d52 ^ d57 ^ c2 ^ 
        d43 ^ d28;  // 51 ins 1 outs level 3

    assign x12 = d0 ^ d68 ^ d53 ^ d50 ^ c10 ^ d9 ^ c31 ^ d31 ^ d71 ^ 
        c17 ^ c23 ^ c1 ^ d63 ^ d52 ^ c19 ^ d59 ^ d24 ^ d47 ^ c12 ^ 
        d4 ^ d56 ^ d41 ^ d5 ^ c6 ^ c2 ^ d2 ^ d49 ^ d42 ^ d61 ^ 
        c13 ^ c28 ^ d12 ^ d6 ^ d69 ^ c14 ^ d18 ^ c29 ^ d15 ^ c21 ^ 
        d57 ^ d27 ^ c7 ^ d17 ^ d30 ^ c9 ^ d46 ^ c16 ^ c11 ^ d13 ^ 
        d54 ^ d21 ^ d51 ^ d1;  // 53 ins 1 outs level 3

    assign x11 = c15 ^ d33 ^ c24 ^ c25 ^ c16 ^ d9 ^ d25 ^ d68 ^ c1 ^ 
        c8 ^ d17 ^ c28 ^ d58 ^ d64 ^ d56 ^ c19 ^ d55 ^ c26 ^ c5 ^ 
        d24 ^ d31 ^ d3 ^ c3 ^ d16 ^ d59 ^ d28 ^ c11 ^ d51 ^ d1 ^ 
        d41 ^ c14 ^ d14 ^ d40 ^ c10 ^ d50 ^ c0 ^ d27 ^ d36 ^ d15 ^ 
        d65 ^ d71 ^ c17 ^ d54 ^ d0 ^ c31 ^ d66 ^ c30 ^ d44 ^ c7 ^ 
        d4 ^ d70 ^ d43 ^ d12 ^ d26 ^ d57 ^ c18 ^ d20 ^ d48 ^ d45 ^ 
        c4 ^ d47;  // 61 ins 1 outs level 3

    assign x10 = d69 ^ d0 ^ d66 ^ d71 ^ d40 ^ d55 ^ c29 ^ c20 ^ c26 ^ 
        d28 ^ d52 ^ d29 ^ d36 ^ c23 ^ d16 ^ d9 ^ d58 ^ d35 ^ c16 ^ 
        d26 ^ c2 ^ d19 ^ c31 ^ d31 ^ d3 ^ d63 ^ c0 ^ c19 ^ d42 ^ 
        c22 ^ d13 ^ d62 ^ d60 ^ c15 ^ c18 ^ c30 ^ d39 ^ d5 ^ d56 ^ 
        d14 ^ d59 ^ c10 ^ d2 ^ d70 ^ d32 ^ c12 ^ d33 ^ d50;  // 48 ins 1 outs level 3

    assign x9 = c20 ^ c15 ^ c7 ^ d32 ^ d55 ^ c29 ^ d44 ^ d13 ^ d47 ^ 
        d5 ^ d36 ^ d69 ^ d24 ^ c18 ^ c27 ^ c31 ^ c30 ^ c11 ^ d66 ^ 
        d18 ^ d9 ^ d35 ^ d23 ^ d29 ^ d67 ^ c4 ^ d43 ^ d4 ^ d39 ^ 
        d34 ^ d64 ^ d38 ^ d41 ^ c26 ^ c13 ^ d68 ^ d11 ^ d51 ^ c21 ^ 
        d2 ^ d12 ^ d70 ^ d58 ^ d61 ^ c3 ^ c28 ^ d33 ^ c12 ^ d53 ^ 
        d52 ^ c6 ^ d46 ^ c1 ^ d60 ^ d71 ^ d1 ^ c24;  // 57 ins 1 outs level 3

    assign x8 = c25 ^ d12 ^ d34 ^ d66 ^ d65 ^ c5 ^ d68 ^ c14 ^ c27 ^ 
        d59 ^ d35 ^ d33 ^ c0 ^ c6 ^ d60 ^ c29 ^ c28 ^ c26 ^ c11 ^ 
        c23 ^ d51 ^ d52 ^ c20 ^ d40 ^ d31 ^ d43 ^ d17 ^ d54 ^ c17 ^ 
        d32 ^ c3 ^ d1 ^ c19 ^ d38 ^ d23 ^ d22 ^ d57 ^ d11 ^ c10 ^ 
        d45 ^ c30 ^ d46 ^ c12 ^ d42 ^ d70 ^ d63 ^ d3 ^ d69 ^ d67 ^ 
        d10 ^ d4 ^ d8 ^ d37 ^ d28 ^ c2 ^ d50 ^ d0;  // 57 ins 1 outs level 3

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat72_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [71:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x640, x639, x638, x637, x636, x635, x634, 
       x633, x632, x631, x630, x629, x628, x627, x626, 
       x625, x624, x623, x622, x621, x620, x618, x617, 
       x616, x615, x614, x613, x612, x611, x610, x609, 
       x608, x607, x606, x605, x603, x602, x601, x600, 
       x599, x598, x597, x596, x595, x594, x593, x592, 
       x591, x590, x589, x588, x587, x586, x585, x584, 
       x583, x582, x581, x580, x579, x578, x577, x576, 
       x575, x574, x573, x572, x571, x570, x569, x568, 
       x567, x566, x565, x564, x563, x562, x561, x560, 
       x559, x558, x557, x556, x555, x554, x553, x552, 
       x551, x550, x549, x548, x547, x546, x545, x544, 
       x543, x542, x541, x540, x539, x538, x537, x536, 
       x535, x534, x533, x532, x531, x530, x529, x528, 
       x527, x526, x525, x524, x523, x522, x521, x520, 
       x519, x518, x517, x516, x515, x514, x513, x512, 
       x511, x510, x509, x508, x507, x506, x505, x504, 
       x503, x502, x501, x500, x499, x498, x497, x496, 
       x495, x494, x493, x492, x491, x7, x6, x5, 
       x4, x3, x2, x1, x0, x31, x30, x29, 
       x28, x27, x26, x25, x24, x23, x22, x21, 
       x20, x19, x18, x17, x16, x15, x14, x13, 
       x12, x11, x10, x9, x8;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63,d64,d65,d66,d67,d68,d69,d70,d71;

assign { d71,d70,d69,d68,d67,d66,d65,d64,d63,d62,d61,d60,d59,d58,d57,
        d56,d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [71:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x640i (.out(x640),.a(x516),.b(x522),.c(x503),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 2

    xor6 x639i (.out(x639),.a(x638),.b(d32),.c(x506),.d(x551),.e(x500),.f(x491));  // 6 ins 1 outs level 2

    xor6 x638i (.out(x638),.a(d8),.b(d27),.c(c6),.d(d38),.e(c17),.f(c23));  // 6 ins 1 outs level 1

    xor6 x637i (.out(x637),.a(x635),.b(x511),.c(x495),.d(x516),.e(x636),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x636i (.out(x636),.a(d61),.b(d36),.c(d41),.d(d4),.e(d68),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x635i (.out(x635),.a(c31),.b(c1),.c(d1),.d(d57),.e(d69),.f(d71));  // 6 ins 1 outs level 1

    xor6 x634i (.out(x634),.a(x552),.b(x503),.c(x515),.d(x512),.e(x499),.f(d61));  // 6 ins 1 outs level 2

    xor6 x633i (.out(x633),.a(d31),.b(d69),.c(d13),.d(c31),.e(d22),.f(c9));  // 6 ins 1 outs level 1

    xor6 x632i (.out(x632),.a(x495),.b(x631),.c(x513),.d(x492),.e(x494),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x631i (.out(x631),.a(d64),.b(c16),.c(d28),.d(c24),.e(d56),.f(d29));  // 6 ins 1 outs level 1

    xor6 x630i (.out(x630),.a(x629),.b(x519),.c(x511),.d(x518),.e(x491),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x629i (.out(x629),.a(d15),.b(d18),.c(c13),.d(c31),.e(d41),.f(d53));  // 6 ins 1 outs level 1

    xor6 x628i (.out(x628),.a(x626),.b(x492),.c(x627),.d(x558),.e(x505),.f(x549));  // 6 ins 1 outs level 2

    xor6 x627i (.out(x627),.a(c30),.b(d19),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x626i (.out(x626),.a(d62),.b(c22),.c(d14),.d(c7),.e(d24),.f(d13));  // 6 ins 1 outs level 1

    xor6 x625i (.out(x625),.a(x624),.b(x562),.c(x530),.d(x529),.e(x513),.f(x497));  // 6 ins 1 outs level 2

    xor6 x624i (.out(x624),.a(d6),.b(d17),.c(d51),.d(d70),.e(d25),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x623i (.out(x623),.a(x621),.b(x548),.c(x493),.d(x622),.e(x513),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x622i (.out(x622),.a(d44),.b(c4),.c(d16),.d(d12),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x621i (.out(x621),.a(d70),.b(d9),.c(d24),.d(d34),.e(d40),.f(d4));  // 6 ins 1 outs level 1

    xor6 x620i (.out(x620),.a(d35),.b(x618),.c(x541),.d(x495),.e(x494),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x618i (.out(x618),.a(d32),.b(d5),.c(d13),.d(d46),.e(d19),.f(d22));  // 6 ins 1 outs level 1

    xor6 x617i (.out(x617),.a(d52),.b(x616),.c(x548),.d(x495),.e(x511),.f(x534));  // 6 ins 1 outs level 2

    xor6 x616i (.out(x616),.a(d14),.b(c5),.c(c12),.d(d23),.e(d47),.f(d33));  // 6 ins 1 outs level 1

    xor6 x615i (.out(x615),.a(x613),.b(x508),.c(x614),.d(x529),.e(x558),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x614i (.out(x614),.a(d26),.b(c28),.c(d10),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x613i (.out(x613),.a(c19),.b(d59),.c(d37),.d(d21),.e(d69),.f(d49));  // 6 ins 1 outs level 1

    xor6 x612i (.out(x612),.a(x610),.b(x495),.c(x513),.d(x611),.e(x525),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x611i (.out(x611),.a(c10),.b(d50),.c(d47),.d(d24),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x610i (.out(x610),.a(c11),.b(d11),.c(d69),.d(d35),.e(d32),.f(d25));  // 6 ins 1 outs level 1

    xor6 x609i (.out(x609),.a(x608),.b(x494),.c(d48),.d(x496),.e(x512),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x608i (.out(x608),.a(d47),.b(c8),.c(d61),.d(c1),.e(d17),.f(d40));  // 6 ins 1 outs level 1

    xor6 x607i (.out(x607),.a(d26),.b(d61),.c(d24),.d(c11),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x606i (.out(x606),.a(d27),.b(d35),.c(d18),.d(c31),.e(d13),.f(d49));  // 6 ins 1 outs level 1

    xor6 x605i (.out(x605),.a(x603),.b(d35),.c(d27),.d(x492),.e(x516),.f(x496));  // 6 ins 1 outs level 2

    xor6 x603i (.out(x603),.a(d6),.b(d62),.c(c22),.d(d37),.e(c15),.f(d55));  // 6 ins 1 outs level 1

    xor6 x602i (.out(x602),.a(d26),.b(x601),.c(x525),.d(x511),.e(x506),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x601i (.out(x601),.a(d36),.b(d20),.c(d31),.d(d35),.e(d15),.f(d46));  // 6 ins 1 outs level 1

    xor6 x600i (.out(x600),.a(d16),.b(x599),.c(x529),.d(x506),.e(x505),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x599i (.out(x599),.a(d36),.b(d4),.c(d30),.d(c11),.e(c7),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x598i (.out(x598),.a(x597),.b(x520),.c(x491),.d(x499),.e(x497),.f(x524));  // 6 ins 1 outs level 2

    xor6 x597i (.out(x597),.a(c31),.b(d24),.c(d71),.d(d11),.e(d0),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x596i (.out(x596),.a(x594),.b(x493),.c(x491),.d(x595),.e(x503),.f(x520));  // 6 ins 1 outs level 2

    xor6 x595i (.out(x595),.a(d44),.b(c4),.c(d10),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x594i (.out(x594),.a(c26),.b(c21),.c(d39),.d(d69),.e(c8),.f(d66));  // 6 ins 1 outs level 1

    xor6 x593i (.out(x593),.a(x591),.b(x508),.c(x592),.d(x530),.e(x519),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x592i (.out(x592),.a(c27),.b(d27),.c(d28),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x591i (.out(x591),.a(d29),.b(d45),.c(d67),.d(d11),.e(d23),.f(d68));  // 6 ins 1 outs level 1

    xor6 x590i (.out(x590),.a(d5),.b(x589),.c(x499),.d(x524),.e(x501),.f(x550));  // 6 ins 1 outs level 2

    xor6 x589i (.out(x589),.a(d20),.b(d6),.c(d7),.d(c9),.e(d71),.f(c28));  // 6 ins 1 outs level 1

    xor6 x588i (.out(x588),.a(x587),.b(d34),.c(x495),.d(x524),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x587i (.out(x587),.a(d48),.b(c11),.c(d27),.d(d2),.e(d7),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x586i (.out(x586),.a(x503),.b(x585),.c(x542),.d(x498),.e(x496),.f(x492));  // 6 ins 1 outs level 2

    xor6 x585i (.out(x585),.a(d32),.b(d11),.c(d23),.d(c31),.e(d27),.f(d3));  // 6 ins 1 outs level 1

    xor6 x584i (.out(x584),.a(x582),.b(x498),.c(x583),.d(x562),.e(x551),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x583i (.out(x583),.a(c31),.b(d36),.c(d63),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x582i (.out(x582),.a(d62),.b(d9),.c(d1),.d(d30),.e(d46),.f(c22));  // 6 ins 1 outs level 1

    xor6 x581i (.out(x581),.a(d0),.b(x580),.c(x549),.d(x525),.e(x518),.f(x501));  // 6 ins 1 outs level 2

    xor6 x580i (.out(x580),.a(d16),.b(d9),.c(d36),.d(d37),.e(d25),.f(c11));  // 6 ins 1 outs level 1

    xor6 x579i (.out(x579),.a(x502),.b(x525),.c(x562),.d(x499),.e(x495),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x578i (.out(x578),.a(c21),.b(d49),.c(d28),.d(d11),.e(d37),.f(d68));  // 6 ins 1 outs level 1

    xor6 x577i (.out(x577),.a(x576),.b(x493),.c(x515),.d(x512),.e(x561),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x576i (.out(x576),.a(c30),.b(d31),.c(c15),.d(d52),.e(c12),.f(d30));  // 6 ins 1 outs level 1

    xor6 x575i (.out(x575),.a(x574),.b(x517),.c(x546),.d(x513),.e(x506),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x574i (.out(x574),.a(d38),.b(c9),.c(d21),.d(d5),.e(d14),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x573i (.out(x573),.a(x571),.b(x552),.c(x492),.d(x572),.e(x542),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x572i (.out(x572),.a(c19),.b(d59),.c(d47),.d(d3),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x571i (.out(x571),.a(d32),.b(d12),.c(d40),.d(d19),.e(d20),.f(d0));  // 6 ins 1 outs level 1

    xor6 x570i (.out(x570),.a(x569),.b(x561),.c(c1),.d(d51),.e(x501),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x569i (.out(x569),.a(d41),.b(d21),.c(d69),.d(d4),.e(d55),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x568i (.out(x568),.a(x567),.b(d34),.c(x542),.d(x498),.e(x493),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x567i (.out(x567),.a(d54),.b(c1),.c(d6),.d(c14),.e(d68),.f(d41));  // 6 ins 1 outs level 1

    xor6 x566i (.out(x566),.a(x564),.b(x530),.c(x493),.d(x565),.e(x517),.f(x549));  // 6 ins 1 outs level 2

    xor6 x565i (.out(x565),.a(d45),.b(c31),.c(d24),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x564i (.out(x564),.a(d18),.b(c28),.c(c5),.d(d8),.e(c0),.f(d29));  // 6 ins 1 outs level 1

    xor6 x563i (.out(x563),.a(x491),.b(d12),.c(d15),.d(d7),.e(x506),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x562i (.out(x562),.a(d65),.b(d11),.c(d70),.d(c25),.e(1'b0),.f(1'b0));  // 4 ins 3 outs level 1

    xor6 x561i (.out(x561),.a(d13),.b(d37),.c(d0),.d(c29),.e(d55),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x560i (.out(x560),.a(d19),.b(d68),.c(d36),.d(d40),.e(x496),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x559i (.out(x559),.a(d6),.b(x492),.c(d22),.d(d36),.e(1'b0),.f(1'b0));  // 4 ins 2 outs level 2

    xor6 x558i (.out(x558),.a(d6),.b(d34),.c(d23),.d(d24),.e(d39),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x557i (.out(x557),.a(d21),.b(d39),.c(x516),.d(d41),.e(c11),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x556i (.out(x556),.a(c9),.b(d38),.c(d1),.d(x513),.e(x494),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x555i (.out(x555),.a(c8),.b(x517),.c(d4),.d(d48),.e(c17),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x554i (.out(x554),.a(x501),.b(d20),.c(x494),.d(c20),.e(d60),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x553i (.out(x553),.a(d51),.b(x516),.c(x500),.d(x506),.e(1'b0),.f(1'b0));  // 4 ins 2 outs level 2

    xor6 x552i (.out(x552),.a(d63),.b(d33),.c(d14),.d(c23),.e(1'b0),.f(1'b0));  // 4 ins 2 outs level 1

    xor6 x551i (.out(x551),.a(d31),.b(d67),.c(c27),.d(d63),.e(d25),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x550i (.out(x550),.a(d40),.b(d22),.c(d51),.d(d29),.e(c29),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x549i (.out(x549),.a(d34),.b(d16),.c(c14),.d(d10),.e(d54),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x548i (.out(x548),.a(d18),.b(d45),.c(d27),.d(d30),.e(1'b0),.f(1'b0));  // 4 ins 2 outs level 1

    xor6 x547i (.out(x547),.a(d48),.b(x508),.c(x497),.d(c22),.e(d62),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x546i (.out(x546),.a(d53),.b(d31),.c(d9),.d(c13),.e(d10),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x545i (.out(x545),.a(x512),.b(d33),.c(x497),.d(d68),.e(x498),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x544i (.out(x544),.a(d2),.b(x508),.c(d28),.d(c9),.e(x497),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x543i (.out(x543),.a(d52),.b(d3),.c(c12),.d(d17),.e(x522),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x542i (.out(x542),.a(d8),.b(d11),.c(d30),.d(c11),.e(d14),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x541i (.out(x541),.a(d51),.b(d68),.c(c28),.d(d8),.e(d17),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x540i (.out(x540),.a(d65),.b(c25),.c(d19),.d(x519),.e(x491),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x539i (.out(x539),.a(x494),.b(x503),.c(d71),.d(d40),.e(d69),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x538i (.out(x538),.a(d1),.b(c0),.c(x499),.d(d21),.e(c5),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x537i (.out(x537),.a(c9),.b(c6),.c(c7),.d(d27),.e(x495),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x536i (.out(x536),.a(d58),.b(d63),.c(c23),.d(x511),.e(c18),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x535i (.out(x535),.a(x498),.b(d10),.c(d57),.d(d35),.e(c29),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x534i (.out(x534),.a(d20),.b(d69),.c(d25),.d(d49),.e(c9),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x533i (.out(x533),.a(c0),.b(x497),.c(x500),.d(c6),.e(d15),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x532i (.out(x532),.a(d47),.b(x494),.c(d66),.d(c26),.e(1'b0),.f(1'b0));  // 4 ins 4 outs level 2

    xor6 x531i (.out(x531),.a(x503),.b(x499),.c(d29),.d(d34),.e(d5),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x530i (.out(x530),.a(d25),.b(d7),.c(c3),.d(d43),.e(1'b0),.f(1'b0));  // 4 ins 5 outs level 1

    xor6 x529i (.out(x529),.a(c0),.b(d70),.c(d7),.d(c30),.e(d14),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x528i (.out(x528),.a(d55),.b(x495),.c(c15),.d(c28),.e(d23),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x527i (.out(x527),.a(d46),.b(x502),.c(d10),.d(c6),.e(c30),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x526i (.out(x526),.a(d56),.b(c16),.c(d52),.d(x501),.e(c12),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x525i (.out(x525),.a(d16),.b(c6),.c(d60),.d(d38),.e(c20),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x524i (.out(x524),.a(c24),.b(d64),.c(d2),.d(c7),.e(d21),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x523i (.out(x523),.a(c18),.b(d58),.c(d5),.d(x505),.e(x493),.f(1'b0));  // 5 ins 5 outs level 2

    xor6 x522i (.out(x522),.a(d37),.b(d51),.c(c21),.d(d40),.e(c0),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x521i (.out(x521),.a(c17),.b(d5),.c(d1),.d(d57),.e(x502),.f(1'b0));  // 5 ins 5 outs level 2

    xor6 x520i (.out(x520),.a(d28),.b(d18),.c(d19),.d(d0),.e(d61),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x519i (.out(x519),.a(d39),.b(d42),.c(c2),.d(d49),.e(d5),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x518i (.out(x518),.a(c6),.b(c7),.c(d26),.d(d12),.e(d30),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x517i (.out(x517),.a(d37),.b(d56),.c(c16),.d(d21),.e(d0),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x516i (.out(x516),.a(d34),.b(d12),.c(d11),.d(c21),.e(d33),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x515i (.out(x515),.a(d35),.b(d29),.c(d59),.d(c19),.e(d7),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x514i (.out(x514),.a(d53),.b(d32),.c(d19),.d(c13),.e(x492),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x513i (.out(x513),.a(d7),.b(d3),.c(d20),.d(c31),.e(c0),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x512i (.out(x512),.a(d16),.b(d26),.c(d14),.d(d9),.e(d36),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x511i (.out(x511),.a(d13),.b(d6),.c(c7),.d(d9),.e(c29),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x510i (.out(x510),.a(d4),.b(x496),.c(c30),.d(d70),.e(d25),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x509i (.out(x509),.a(x493),.b(d51),.c(c11),.d(d23),.e(d28),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x508i (.out(x508),.a(d26),.b(d31),.c(c28),.d(d24),.e(d4),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x507i (.out(x507),.a(d6),.b(x495),.c(d67),.d(c27),.e(d38),.f(1'b0));  // 5 ins 9 outs level 2

    xor6 x506i (.out(x506),.a(d47),.b(d0),.c(d27),.d(d17),.e(d1),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x505i (.out(x505),.a(d2),.b(d18),.c(d32),.d(c29),.e(d39),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x504i (.out(x504),.a(x491),.b(d33),.c(d8),.d(d15),.e(d49),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x503i (.out(x503),.a(d42),.b(c2),.c(d22),.d(d71),.e(d3),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x502i (.out(x502),.a(c24),.b(d64),.c(d70),.d(d53),.e(c13),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x501i (.out(x501),.a(d63),.b(c23),.c(d28),.d(c21),.e(d61),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x500i (.out(x500),.a(d46),.b(d50),.c(c10),.d(d69),.e(d68),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x499i (.out(x499),.a(d56),.b(c9),.c(d62),.d(c16),.e(c22),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x498i (.out(x498),.a(d66),.b(d51),.c(c26),.d(c3),.e(d43),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x497i (.out(x497),.a(c1),.b(c17),.c(c7),.d(d41),.e(d57),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x496i (.out(x496),.a(c5),.b(d45),.c(d65),.d(c25),.e(c28),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x495i (.out(x495),.a(d24),.b(c11),.c(c4),.d(d44),.e(d29),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x494i (.out(x494),.a(d55),.b(c15),.c(d50),.d(c10),.e(d40),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x493i (.out(x493),.a(c12),.b(d52),.c(d60),.d(c20),.e(d47),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x492i (.out(x492),.a(c8),.b(d48),.c(c18),.d(d58),.e(d31),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x491i (.out(x491),.a(c14),.b(c19),.c(d54),.d(d71),.e(d59),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x7i (.out(x7),.a(x566),.b(x523),.c(x509),.d(x503),.e(x533),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x6i (.out(x6),.a(x568),.b(x531),.c(x524),.d(x556),.e(x510),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x5i (.out(x5),.a(x570),.b(x540),.c(x556),.d(x527),.e(x507),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x4i (.out(x4),.a(x573),.b(x505),.c(x507),.d(x533),.e(x510),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x3i (.out(x3),.a(x575),.b(x534),.c(x523),.d(x560),.e(x504),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x2i (.out(x2),.a(x577),.b(x523),.c(x521),.d(x541),.e(x507),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x1i (.out(x1),.a(x578),.b(x553),.c(x515),.d(x536),.e(x579),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x0i (.out(x0),.a(x581),.b(x532),.c(x560),.d(x507),.e(x514),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x31i (.out(x31),.a(x584),.b(x504),.c(x509),.d(x537),.e(x521),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x30i (.out(x30),.a(x586),.b(x508),.c(x515),.d(x526),.e(x527),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x29i (.out(x29),.a(x588),.b(x510),.c(x539),.d(x547),.e(x536),.f(x509));  // 6 ins 1 outs level 3

    xor6 x28i (.out(x28),.a(x590),.b(x518),.c(x504),.d(x530),.e(x537),.f(x533));  // 6 ins 1 outs level 3

    xor6 x27i (.out(x27),.a(x593),.b(x554),.c(x538),.d(x514),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x26i (.out(x26),.a(x596),.b(x534),.c(x547),.d(x528),.e(x507),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x25i (.out(x25),.a(x598),.b(x504),.c(x507),.d(x559),.e(x543),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x24i (.out(x24),.a(x600),.b(x555),.c(x554),.d(x535),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x23i (.out(x23),.a(x602),.b(x531),.c(x539),.d(x540),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x22i (.out(x22),.a(x605),.b(x507),.c(x509),.d(x520),.e(x545),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x21i (.out(x21),.a(x606),.b(x543),.c(x531),.d(x607),.e(x546),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x20i (.out(x20),.a(x609),.b(x510),.c(x542),.d(x557),.e(x509),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x19i (.out(x19),.a(x612),.b(x537),.c(x550),.d(x504),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x18i (.out(x18),.a(x615),.b(x544),.c(x533),.d(x514),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x17i (.out(x17),.a(x617),.b(x521),.c(x507),.d(x502),.e(x559),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x16i (.out(x16),.a(d57),.b(x620),.c(x532),.d(x518),.e(x555),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x15i (.out(x15),.a(x623),.b(x532),.c(x504),.d(x538),.e(x521),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x14i (.out(x14),.a(x625),.b(x544),.c(x528),.d(x526),.e(x514),.f(x504));  // 6 ins 1 outs level 3

    xor6 x13i (.out(x13),.a(x628),.b(x530),.c(x539),.d(x521),.e(x509),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x12i (.out(x12),.a(x630),.b(x553),.c(x544),.d(x557),.e(x526),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x11i (.out(x11),.a(x563),.b(x545),.c(x510),.d(x632),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 3

    xor6 x10i (.out(x10),.a(x633),.b(x520),.c(x532),.d(x529),.e(x523),.f(x634));  // 6 ins 1 outs level 3

    xor6 x9i (.out(x9),.a(x637),.b(x507),.c(x528),.d(x527),.e(x535),.f(x523));  // 6 ins 1 outs level 3

    xor6 x8i (.out(x8),.a(x639),.b(x510),.c(x509),.d(x535),.e(x640),.f(1'b0));  // 5 ins 1 outs level 3

endmodule

