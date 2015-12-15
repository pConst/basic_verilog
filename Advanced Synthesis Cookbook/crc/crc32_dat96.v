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

//// CRC-32 of 96 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999
//        01234567890123456789012345678901 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
//
// C00  = .XXXX...XX.....X.XXXXX.X......XX X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XX
// C01  = XX...X..X.X....XXX....XXX.....X. XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..X.XXX.XXXX...X..X.X....XXX....XXX.....X.
// C02  = X..XX.X.X..X...XX..XXX..XX....X. XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X.
// C03  = .X..XX.X.X..X...XX..XXX..XX....X .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X
// C04  = .X.XXXX..XX..X.X...XX.X...XX..XX X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X......XXX...X.X.XXXX..XX..X.X...XX.X...XX..XX
// C05  = XX.X.XXXXXXX..XXXXXX.......XX.X. XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X.
// C06  = XXX.X.XXXXXXX..XXXXXX.......XX.X .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X
// C07  = ....XX.X..XXXX.XX......X.....X.X X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.XXX.X.......XX.X..XXXX.XX......X.....X.X
// C08  = .XXXXXX..X.XXXXXX.XXXX.XX......X XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......X
// C09  = X.XXXXXX..X.XXXXXX.XXXX.XX...... .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......
// C10  = ..X..XXX.X.X.XX.X..X..X..XX...XX X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..XX.XXX.XX..X..XXX.X.X.XX.X..X..X..XX...XX
// C11  = XXX.X.XX.XX.X.X...XX.X....XX..X. XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XXXXXX....XXX.X.XX.XX.X.X...XX.X....XX..X.
// C12  = ....XX.X.XXX.X...XX..XXX...XX.X. XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.
// C13  = X....XX.X.XXX.X...XX..XXX...XX.X .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X
// C14  = .X....XX.X.XXX.X...XX..XXX...XX. ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.
// C15  = X.X....XX.X.XXX.X...XX..XXX...XX ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX
// C16  = ..X.X......X.XX...XXX.XX.XXX..X. X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X.
// C17  = ...X.X......X.XX...XXX.XX.XXX..X .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X
// C18  = ....X.X......X.XX...XXX.XX.XXX.. ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..
// C19  = .....X.X......X.XX...XXX.XX.XXX. ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX.
// C20  = ......X.X......X.XX...XXX.XX.XXX ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX
// C21  = .......X.X......X.XX...XXX.XX.XX .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XX
// C22  = .XXXX....XX....X..X..X.XXXX.XXX. X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X.XX.XXX..XXXX....XX....X..X..X.XXXX.XXX.
// C23  = .X...X..XXXX...XXXX.XXXXXXXX.X.. XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..
// C24  = ..X...X..XXXX...XXXX.XXXXXXXX.X. .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X.
// C25  = X..X...X..XXXX...XXXX.XXXXXXXX.X ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X
// C26  = ..XX.....X.XXXXX.X......XXXXXX.X X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X
// C27  = ...XX.....X.XXXXX.X......XXXXXX. .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.
// C28  = X...XX.....X.XXXXX.X......XXXXXX ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX
// C29  = XX...XX.....X.XXXXX.X......XXXXX ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXX
// C30  = XXX...XX.....X.XXXXX.X......XXXX ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXX
// C31  = XXXX...XX.....X.XXXXX.X......XXX .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXX
//
module crc32_dat96 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [95:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat96_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat96_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat96_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [95:0] dat_in;
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
    d63,d64,d65,d66,d67,d68,d69,d70,d71,d72,d73,d74,d75,d76,d77,d78,
    d79,d80,d81,d82,d83,d84,d85,d86,d87,d88,d89,d90,d91,d92,d93,d94,
    d95;

assign { d95,d94,d93,d92,d91,d90,d89,d88,d87,d86,d85,d84,d83,d82,d81,
        d80,d79,d78,d77,d76,d75,d74,d73,d72,d71,d70,d69,d68,d67,d66,d65,
        d64,d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [95:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x31 = c14 ^ d29 ^ d5 ^ c0 ^ d86 ^ d28 ^ d27 ^ d66 ^ d33 ^ 
        d53 ^ d83 ^ d30 ^ d59 ^ c19 ^ d81 ^ d44 ^ c22 ^ d47 ^ d57 ^ 
        d71 ^ d60 ^ c16 ^ d64 ^ d78 ^ d31 ^ c18 ^ d52 ^ d49 ^ c7 ^ 
        c1 ^ d62 ^ d72 ^ c8 ^ c31 ^ d80 ^ c2 ^ d93 ^ d67 ^ d54 ^ 
        c3 ^ d65 ^ d25 ^ c30 ^ d46 ^ d82 ^ d9 ^ d43 ^ d8 ^ c29 ^ 
        d36 ^ d94 ^ c17 ^ d23 ^ d24 ^ d95 ^ d84 ^ c20 ^ d11 ^ d15;  // 59 ins 1 outs level 3

    assign x30 = d14 ^ c31 ^ d46 ^ d7 ^ c2 ^ d93 ^ d80 ^ d92 ^ c7 ^ 
        d58 ^ d82 ^ c18 ^ d29 ^ c16 ^ d43 ^ c30 ^ c6 ^ d63 ^ c0 ^ 
        c17 ^ d79 ^ d30 ^ c13 ^ d23 ^ c29 ^ d81 ^ d94 ^ d24 ^ c1 ^ 
        d32 ^ d8 ^ d71 ^ c21 ^ d26 ^ d42 ^ d95 ^ d77 ^ c19 ^ d70 ^ 
        d27 ^ d4 ^ d64 ^ d28 ^ d53 ^ d59 ^ d35 ^ d65 ^ d56 ^ d22 ^ 
        d85 ^ d66 ^ d45 ^ d52 ^ d10 ^ c15 ^ d83 ^ d61 ^ d48 ^ c28 ^ 
        d51;  // 60 ins 1 outs level 3

    assign x29 = d82 ^ d6 ^ d84 ^ d27 ^ d95 ^ c17 ^ d60 ^ d42 ^ d57 ^ 
        d50 ^ c29 ^ d80 ^ d69 ^ d29 ^ d34 ^ d78 ^ d63 ^ d70 ^ d45 ^ 
        c28 ^ d93 ^ d23 ^ d81 ^ c16 ^ d25 ^ d65 ^ d9 ^ d31 ^ c1 ^ 
        c31 ^ d76 ^ d44 ^ c12 ^ c6 ^ d3 ^ d21 ^ d55 ^ c20 ^ d22 ^ 
        d28 ^ c14 ^ d79 ^ d47 ^ c18 ^ d91 ^ c5 ^ d7 ^ d92 ^ d41 ^ 
        d94 ^ d51 ^ d13 ^ d62 ^ d26 ^ d52 ^ d58 ^ c30 ^ c0 ^ c15 ^ 
        d64 ^ c27;  // 61 ins 1 outs level 3

    assign x28 = d81 ^ c5 ^ d78 ^ d46 ^ d83 ^ d24 ^ d95 ^ d68 ^ d54 ^ 
        d21 ^ d41 ^ d80 ^ d79 ^ c29 ^ c31 ^ d33 ^ d57 ^ d56 ^ d77 ^ 
        c30 ^ d61 ^ c11 ^ c16 ^ d2 ^ d62 ^ d43 ^ c15 ^ d44 ^ d51 ^ 
        d30 ^ d69 ^ c19 ^ d90 ^ d28 ^ c27 ^ d6 ^ c28 ^ d91 ^ d26 ^ 
        d20 ^ d25 ^ d49 ^ d94 ^ d5 ^ d64 ^ d93 ^ d59 ^ c0 ^ c17 ^ 
        d75 ^ d50 ^ d27 ^ c14 ^ c26 ^ d40 ^ c4 ^ d22 ^ d12 ^ d63 ^ 
        d92 ^ c13 ^ d8;  // 62 ins 1 outs level 3

    assign x27 = d55 ^ d49 ^ d74 ^ d20 ^ d91 ^ d61 ^ c18 ^ d24 ^ c4 ^ 
        d32 ^ d80 ^ d60 ^ c26 ^ d42 ^ c29 ^ d94 ^ d63 ^ d21 ^ d23 ^ 
        d79 ^ c15 ^ d76 ^ c30 ^ d53 ^ c16 ^ c10 ^ d1 ^ d40 ^ d45 ^ 
        d50 ^ d90 ^ d78 ^ d62 ^ c3 ^ d5 ^ d82 ^ d68 ^ d93 ^ d43 ^ 
        d77 ^ d89 ^ d7 ^ d67 ^ d25 ^ d27 ^ c28 ^ d11 ^ c14 ^ c13 ^ 
        c27 ^ d39 ^ d92 ^ d48 ^ d56 ^ d19 ^ d58 ^ d29 ^ c25 ^ d26 ^ 
        d4 ^ c12;  // 61 ins 1 outs level 3

    assign x26 = d25 ^ d26 ^ d47 ^ d19 ^ d81 ^ c24 ^ d20 ^ d55 ^ d52 ^ 
        d61 ^ d6 ^ d48 ^ d38 ^ d54 ^ d31 ^ d42 ^ d39 ^ d92 ^ c17 ^ 
        d79 ^ d88 ^ d22 ^ d60 ^ d10 ^ d3 ^ c26 ^ d78 ^ c3 ^ d95 ^ 
        d0 ^ d93 ^ c28 ^ c2 ^ c14 ^ d18 ^ c31 ^ c27 ^ c29 ^ d44 ^ 
        d28 ^ c12 ^ d62 ^ d67 ^ d73 ^ c13 ^ c9 ^ d89 ^ d66 ^ d77 ^ 
        d41 ^ c15 ^ d49 ^ d24 ^ d75 ^ d90 ^ d76 ^ c11 ^ d59 ^ d57 ^ 
        d4 ^ d23 ^ c25 ^ d91;  // 63 ins 1 outs level 3

    assign x25 = d81 ^ d57 ^ d75 ^ c7 ^ c27 ^ d38 ^ d77 ^ d95 ^ d49 ^ 
        d22 ^ d41 ^ d48 ^ d44 ^ d40 ^ d31 ^ c29 ^ d36 ^ d83 ^ c31 ^ 
        d91 ^ d21 ^ c23 ^ c13 ^ d90 ^ d92 ^ c19 ^ d93 ^ d74 ^ d3 ^ 
        c20 ^ d56 ^ d62 ^ c28 ^ d82 ^ d51 ^ d86 ^ d33 ^ c3 ^ d37 ^ 
        c22 ^ d58 ^ c0 ^ d64 ^ c25 ^ d88 ^ d28 ^ c12 ^ d11 ^ d17 ^ 
        d8 ^ d89 ^ d76 ^ d61 ^ d84 ^ c10 ^ c18 ^ d71 ^ c26 ^ c17 ^ 
        d29 ^ c24 ^ d15 ^ d52 ^ d19 ^ d87 ^ d67 ^ c11 ^ d18 ^ d2;  // 69 ins 1 outs level 3

    assign x24 = d17 ^ d35 ^ c2 ^ d7 ^ c10 ^ d80 ^ d92 ^ d89 ^ d16 ^ 
        d87 ^ c11 ^ c30 ^ d50 ^ d66 ^ c19 ^ c12 ^ d14 ^ c27 ^ c16 ^ 
        c28 ^ d20 ^ d83 ^ c26 ^ c24 ^ c17 ^ d10 ^ c21 ^ d88 ^ d76 ^ 
        d73 ^ d18 ^ d21 ^ d2 ^ d56 ^ c6 ^ c9 ^ d47 ^ d30 ^ d91 ^ 
        d43 ^ c23 ^ d90 ^ d82 ^ d36 ^ d37 ^ d39 ^ d40 ^ d63 ^ d61 ^ 
        d1 ^ c22 ^ d85 ^ d75 ^ d57 ^ d81 ^ d51 ^ d48 ^ d60 ^ d86 ^ 
        d55 ^ d70 ^ c25 ^ d28 ^ d94 ^ d32 ^ d27 ^ d74 ^ c18;  // 68 ins 1 outs level 3

    assign x23 = d65 ^ d31 ^ d54 ^ d85 ^ d26 ^ c8 ^ d75 ^ d39 ^ d88 ^ 
        d89 ^ d50 ^ d42 ^ d36 ^ d16 ^ c15 ^ d79 ^ d1 ^ c16 ^ d34 ^ 
        d91 ^ c1 ^ c26 ^ d84 ^ d0 ^ d60 ^ d81 ^ d90 ^ d86 ^ c25 ^ 
        d19 ^ c27 ^ c22 ^ c11 ^ d93 ^ c9 ^ d82 ^ c23 ^ d38 ^ c21 ^ 
        d47 ^ d9 ^ c24 ^ d15 ^ d27 ^ d74 ^ d49 ^ d20 ^ d59 ^ d56 ^ 
        d46 ^ d72 ^ d62 ^ d55 ^ d6 ^ d69 ^ d73 ^ d80 ^ c10 ^ d35 ^ 
        d17 ^ c5 ^ d29 ^ c18 ^ c20 ^ d13 ^ d87 ^ c29 ^ c17;  // 68 ins 1 outs level 3

    assign x22 = d90 ^ d31 ^ d34 ^ d79 ^ d73 ^ d55 ^ d57 ^ c29 ^ c15 ^ 
        d11 ^ d19 ^ c1 ^ d9 ^ d0 ^ c25 ^ d87 ^ d35 ^ d47 ^ c24 ^ 
        d52 ^ d68 ^ d92 ^ d89 ^ d74 ^ c3 ^ d94 ^ d36 ^ c10 ^ d38 ^ 
        d85 ^ d44 ^ d93 ^ c28 ^ d27 ^ d18 ^ d88 ^ d45 ^ d26 ^ c30 ^ 
        c21 ^ c26 ^ d12 ^ d48 ^ d58 ^ d29 ^ d41 ^ c18 ^ d62 ^ d65 ^ 
        d60 ^ c4 ^ d43 ^ d14 ^ c23 ^ d61 ^ d67 ^ d66 ^ d82 ^ d23 ^ 
        d16 ^ c2 ^ c9 ^ d37 ^ d24;  // 64 ins 1 outs level 3

    assign x21 = d34 ^ d80 ^ d89 ^ d40 ^ d53 ^ d73 ^ d24 ^ c28 ^ d88 ^ 
        d18 ^ d37 ^ d5 ^ d29 ^ d13 ^ d42 ^ d94 ^ c19 ^ d61 ^ d35 ^ 
        c7 ^ d95 ^ d62 ^ c24 ^ d17 ^ c25 ^ d92 ^ d71 ^ d51 ^ d49 ^ 
        d31 ^ d9 ^ d87 ^ d27 ^ d91 ^ c30 ^ c27 ^ d52 ^ c16 ^ c9 ^ 
        d83 ^ d82 ^ d10 ^ c23 ^ d26 ^ d22 ^ c31 ^ c18 ^ d56;  // 48 ins 1 outs level 3

    assign x20 = d90 ^ d60 ^ d28 ^ d81 ^ d88 ^ c31 ^ d91 ^ d12 ^ d86 ^ 
        d50 ^ d26 ^ c22 ^ d87 ^ d16 ^ c27 ^ d33 ^ d52 ^ d61 ^ c29 ^ 
        d95 ^ c17 ^ d34 ^ d23 ^ c15 ^ c6 ^ d36 ^ d70 ^ c24 ^ d39 ^ 
        d72 ^ d48 ^ d93 ^ d41 ^ d51 ^ d30 ^ c23 ^ c8 ^ c18 ^ d4 ^ 
        d79 ^ d9 ^ d25 ^ c30 ^ d82 ^ c26 ^ d94 ^ d55 ^ d21 ^ d17 ^ 
        d8;  // 50 ins 1 outs level 3

    assign x19 = d85 ^ c23 ^ d81 ^ d7 ^ d51 ^ d15 ^ d49 ^ c21 ^ d92 ^ 
        d93 ^ d60 ^ d90 ^ d22 ^ d80 ^ c7 ^ d71 ^ d59 ^ d54 ^ d16 ^ 
        d27 ^ d86 ^ d35 ^ c25 ^ d40 ^ d32 ^ d3 ^ c28 ^ d47 ^ c26 ^ 
        d11 ^ d94 ^ d20 ^ d50 ^ d29 ^ c29 ^ c30 ^ d38 ^ d69 ^ c5 ^ 
        c16 ^ c22 ^ d33 ^ d25 ^ d87 ^ d89 ^ c17 ^ d24 ^ d78 ^ d8 ^ 
        c14;  // 50 ins 1 outs level 3

    assign x18 = d2 ^ d32 ^ d31 ^ c16 ^ c21 ^ d58 ^ d89 ^ d14 ^ d26 ^ 
        d85 ^ d79 ^ d19 ^ d49 ^ d50 ^ d77 ^ d59 ^ c29 ^ c15 ^ d70 ^ 
        c6 ^ d53 ^ c25 ^ d68 ^ d28 ^ d39 ^ d84 ^ c24 ^ d88 ^ d21 ^ 
        d86 ^ c22 ^ d93 ^ d23 ^ d24 ^ d48 ^ d34 ^ d91 ^ c4 ^ d7 ^ 
        c20 ^ d46 ^ d37 ^ d92 ^ c27 ^ d80 ^ d15 ^ d6 ^ c28 ^ d10 ^ 
        c13;  // 50 ins 1 outs level 3

    assign x17 = d57 ^ d47 ^ d6 ^ d90 ^ d30 ^ d78 ^ d88 ^ d69 ^ d9 ^ 
        d67 ^ d5 ^ d92 ^ d52 ^ d87 ^ d45 ^ c5 ^ d49 ^ c20 ^ d23 ^ 
        d18 ^ c19 ^ c31 ^ c21 ^ d25 ^ d31 ^ d84 ^ d1 ^ d33 ^ d83 ^ 
        d13 ^ d91 ^ c15 ^ d48 ^ d85 ^ c27 ^ c23 ^ d79 ^ c14 ^ d58 ^ 
        d27 ^ d14 ^ d95 ^ c3 ^ c26 ^ d20 ^ d38 ^ d36 ^ d76 ^ c24 ^ 
        d22 ^ c28 ^ c12;  // 52 ins 1 outs level 3

    assign x16 = c20 ^ d47 ^ d24 ^ c13 ^ d5 ^ d13 ^ d51 ^ d48 ^ d46 ^ 
        d87 ^ d22 ^ d30 ^ d66 ^ d32 ^ c2 ^ d94 ^ d26 ^ d82 ^ d4 ^ 
        c14 ^ d37 ^ c22 ^ d21 ^ d89 ^ c30 ^ c4 ^ d84 ^ d83 ^ c19 ^ 
        d68 ^ d8 ^ d12 ^ d75 ^ d78 ^ d29 ^ d0 ^ c25 ^ d17 ^ d90 ^ 
        d44 ^ c11 ^ c23 ^ d77 ^ d86 ^ d35 ^ d19 ^ d91 ^ c18 ^ c26 ^ 
        d57 ^ c27 ^ d56;  // 52 ins 1 outs level 3

    assign x15 = c20 ^ c30 ^ d94 ^ d66 ^ d45 ^ d33 ^ d52 ^ d85 ^ d56 ^ 
        c2 ^ c7 ^ d59 ^ d9 ^ d60 ^ d62 ^ d74 ^ c31 ^ d88 ^ d24 ^ 
        d21 ^ d71 ^ d20 ^ d84 ^ d5 ^ c10 ^ c16 ^ d3 ^ d76 ^ d7 ^ 
        c25 ^ d80 ^ c26 ^ c14 ^ d50 ^ d18 ^ c0 ^ c24 ^ c13 ^ d16 ^ 
        d72 ^ d78 ^ d89 ^ d64 ^ c12 ^ d8 ^ d90 ^ d77 ^ d49 ^ d27 ^ 
        c21 ^ d57 ^ d55 ^ d15 ^ c8 ^ d53 ^ d12 ^ d34 ^ d30 ^ d4 ^ 
        d54 ^ d95 ^ d44;  // 62 ins 1 outs level 3

    assign x14 = d63 ^ d3 ^ d2 ^ d11 ^ d4 ^ d17 ^ d14 ^ d77 ^ d76 ^ 
        d56 ^ d65 ^ d8 ^ d23 ^ c29 ^ d94 ^ d52 ^ c11 ^ d75 ^ d83 ^ 
        d32 ^ d43 ^ d71 ^ d20 ^ d89 ^ d48 ^ d59 ^ c30 ^ d51 ^ c7 ^ 
        d6 ^ c9 ^ c23 ^ c15 ^ c1 ^ d26 ^ d54 ^ d55 ^ d7 ^ d29 ^ 
        d79 ^ d58 ^ d33 ^ c19 ^ c20 ^ d49 ^ c24 ^ d70 ^ d44 ^ d15 ^ 
        d53 ^ c25 ^ c13 ^ c6 ^ d73 ^ d88 ^ c12 ^ d84 ^ d61 ^ d19 ^ 
        d87 ^ d93;  // 61 ins 1 outs level 3

    assign x13 = d47 ^ d48 ^ d86 ^ c18 ^ d53 ^ d92 ^ d28 ^ c5 ^ d69 ^ 
        d50 ^ d16 ^ c31 ^ d82 ^ d57 ^ c29 ^ d25 ^ d88 ^ d1 ^ d42 ^ 
        d95 ^ d43 ^ c0 ^ c24 ^ d19 ^ d3 ^ d87 ^ c14 ^ d58 ^ d6 ^ 
        d10 ^ d62 ^ d78 ^ d13 ^ c19 ^ d18 ^ d51 ^ c10 ^ c12 ^ d2 ^ 
        d74 ^ d52 ^ d60 ^ d31 ^ d83 ^ c11 ^ c6 ^ c23 ^ d75 ^ d22 ^ 
        d76 ^ d54 ^ c22 ^ d32 ^ d14 ^ d55 ^ d93 ^ d70 ^ d7 ^ d72 ^ 
        d64 ^ c8 ^ c28 ^ d5;  // 63 ins 1 outs level 3

    assign x12 = d63 ^ d77 ^ d85 ^ d94 ^ d30 ^ d59 ^ d82 ^ c22 ^ d81 ^ 
        d21 ^ c30 ^ c27 ^ c7 ^ d13 ^ c28 ^ d69 ^ d27 ^ d46 ^ c21 ^ 
        d15 ^ c13 ^ d57 ^ d52 ^ d5 ^ c9 ^ d1 ^ d53 ^ c11 ^ d9 ^ 
        d50 ^ c23 ^ d51 ^ d47 ^ d6 ^ d68 ^ d75 ^ c10 ^ d12 ^ d92 ^ 
        d4 ^ d42 ^ d71 ^ c4 ^ d73 ^ d0 ^ d74 ^ d61 ^ c18 ^ d86 ^ 
        d17 ^ d54 ^ d18 ^ d2 ^ d41 ^ d49 ^ d24 ^ d56 ^ d31 ^ c5 ^ 
        d87 ^ d91 ^ c17;  // 62 ins 1 outs level 3

    assign x11 = d74 ^ d47 ^ d9 ^ d15 ^ d51 ^ c26 ^ d64 ^ d55 ^ d44 ^ 
        d28 ^ d91 ^ d17 ^ d94 ^ d66 ^ d4 ^ c18 ^ d33 ^ d20 ^ d82 ^ 
        d1 ^ d59 ^ d68 ^ c14 ^ d43 ^ c7 ^ d14 ^ c27 ^ d36 ^ d83 ^ 
        d90 ^ d76 ^ c10 ^ d0 ^ d16 ^ d26 ^ d25 ^ d41 ^ d57 ^ d73 ^ 
        c1 ^ c2 ^ c9 ^ d85 ^ c30 ^ d56 ^ d70 ^ d78 ^ d24 ^ c21 ^ 
        c0 ^ c12 ^ d27 ^ d45 ^ d48 ^ d58 ^ d50 ^ c6 ^ d12 ^ d54 ^ 
        c4 ^ d31 ^ d65 ^ c19 ^ d40 ^ d3 ^ d71;  // 66 ins 1 outs level 3

    assign x10 = c25 ^ d14 ^ d33 ^ d86 ^ c7 ^ d58 ^ d29 ^ c14 ^ c13 ^ 
        d42 ^ d83 ^ d26 ^ d32 ^ d90 ^ d70 ^ c6 ^ d9 ^ d89 ^ d0 ^ 
        d55 ^ d40 ^ d2 ^ d19 ^ c19 ^ d35 ^ d66 ^ d73 ^ d80 ^ d16 ^ 
        d39 ^ d60 ^ c5 ^ c31 ^ d28 ^ d3 ^ d78 ^ d31 ^ d77 ^ d63 ^ 
        d71 ^ d59 ^ d94 ^ c2 ^ c26 ^ c9 ^ d13 ^ c30 ^ d36 ^ d50 ^ 
        c16 ^ d69 ^ c22 ^ d56 ^ d5 ^ d95 ^ d52 ^ c11 ^ d75 ^ d62;  // 59 ins 1 outs level 3

    assign x9 = d67 ^ d68 ^ d47 ^ d55 ^ d81 ^ d46 ^ c12 ^ d51 ^ c17 ^ 
        d77 ^ d41 ^ c2 ^ c16 ^ c21 ^ d85 ^ d24 ^ c7 ^ d18 ^ d76 ^ 
        c0 ^ c15 ^ d2 ^ d70 ^ c6 ^ d74 ^ d36 ^ c4 ^ d52 ^ d89 ^ 
        d60 ^ d53 ^ d78 ^ c25 ^ d44 ^ d83 ^ d58 ^ d43 ^ d9 ^ d64 ^ 
        d34 ^ c3 ^ d29 ^ d79 ^ d4 ^ d13 ^ c13 ^ d38 ^ d12 ^ d71 ^ 
        d84 ^ c22 ^ d33 ^ d86 ^ d39 ^ d11 ^ c24 ^ d88 ^ d23 ^ d1 ^ 
        d66 ^ d69 ^ c5 ^ d32 ^ d80 ^ d5 ^ c10 ^ d35 ^ c20 ^ c19 ^ 
        d61 ^ c14;  // 71 ins 1 outs level 3

    assign x8 = d37 ^ c9 ^ d82 ^ c18 ^ c20 ^ d3 ^ d40 ^ d57 ^ c3 ^ 
        d69 ^ d52 ^ d67 ^ d35 ^ d17 ^ d87 ^ d4 ^ d11 ^ d0 ^ d73 ^ 
        d22 ^ c16 ^ d77 ^ d80 ^ d83 ^ c1 ^ c5 ^ d38 ^ d85 ^ d28 ^ 
        d59 ^ d95 ^ c12 ^ d88 ^ d50 ^ c14 ^ c23 ^ d43 ^ d46 ^ d75 ^ 
        d34 ^ d33 ^ c21 ^ d84 ^ d68 ^ d1 ^ d51 ^ d12 ^ c24 ^ d70 ^ 
        d54 ^ d31 ^ d65 ^ c13 ^ c2 ^ d10 ^ d76 ^ d78 ^ d45 ^ d60 ^ 
        c4 ^ c11 ^ c19 ^ d42 ^ d79 ^ d8 ^ d32 ^ d23 ^ c31 ^ c6 ^ 
        d66 ^ d63 ^ c15;  // 72 ins 1 outs level 3

    assign x7 = d58 ^ d75 ^ c11 ^ d16 ^ d74 ^ d10 ^ c10 ^ d0 ^ d50 ^ 
        d29 ^ d15 ^ c7 ^ c5 ^ d24 ^ d2 ^ d68 ^ d87 ^ d54 ^ c15 ^ 
        d95 ^ d93 ^ d8 ^ c23 ^ d39 ^ d32 ^ d43 ^ d28 ^ d37 ^ d46 ^ 
        d45 ^ d80 ^ d34 ^ d3 ^ d22 ^ d21 ^ d25 ^ c13 ^ d5 ^ d57 ^ 
        d41 ^ d56 ^ d77 ^ d60 ^ d47 ^ c4 ^ c12 ^ d7 ^ c29 ^ d79 ^ 
        c31 ^ d69 ^ d42 ^ d23 ^ d51 ^ d71 ^ d76 ^ c16 ^ d52;  // 58 ins 1 outs level 3

    assign x6 = d68 ^ c2 ^ d7 ^ d66 ^ c0 ^ d45 ^ d51 ^ d70 ^ d55 ^ 
        d14 ^ c18 ^ d38 ^ d56 ^ d79 ^ d50 ^ d22 ^ c28 ^ d40 ^ c31 ^ 
        d92 ^ d83 ^ d82 ^ d74 ^ c4 ^ c20 ^ c9 ^ d71 ^ d64 ^ d30 ^ 
        c19 ^ d29 ^ d93 ^ d73 ^ d80 ^ d42 ^ d25 ^ d47 ^ c17 ^ d52 ^ 
        c11 ^ d4 ^ d1 ^ d5 ^ d75 ^ d81 ^ c29 ^ d21 ^ d54 ^ c8 ^ 
        d84 ^ d41 ^ c10 ^ d62 ^ d20 ^ d6 ^ c12 ^ d2 ^ c7 ^ d65 ^ 
        d72 ^ c15 ^ c16 ^ d76 ^ c1 ^ d43 ^ d11 ^ d8 ^ c6 ^ d60 ^ 
        d95;  // 70 ins 1 outs level 3

    assign x5 = d24 ^ d73 ^ d53 ^ d94 ^ d28 ^ c8 ^ c9 ^ d7 ^ c10 ^ 
        c16 ^ c27 ^ d29 ^ d6 ^ c18 ^ d55 ^ d21 ^ d74 ^ d4 ^ d1 ^ 
        d51 ^ d70 ^ d0 ^ c19 ^ c7 ^ c5 ^ d78 ^ d42 ^ d91 ^ d50 ^ 
        d41 ^ c6 ^ d79 ^ c17 ^ d81 ^ d83 ^ d65 ^ d46 ^ d19 ^ d44 ^ 
        d61 ^ d75 ^ d20 ^ c11 ^ d37 ^ d92 ^ d59 ^ d54 ^ d39 ^ c14 ^ 
        d49 ^ d5 ^ d64 ^ c1 ^ c0 ^ d40 ^ d10 ^ d67 ^ c30 ^ c28 ^ 
        d63 ^ d3 ^ d80 ^ d13 ^ c15 ^ d82 ^ d71 ^ d72 ^ c3 ^ d69;  // 69 ins 1 outs level 3

    assign x4 = d44 ^ c31 ^ d0 ^ d30 ^ d79 ^ c19 ^ d29 ^ d12 ^ c3 ^ 
        d39 ^ d63 ^ c10 ^ d31 ^ d11 ^ d20 ^ d91 ^ c9 ^ d69 ^ c30 ^ 
        d6 ^ d94 ^ d67 ^ d4 ^ d47 ^ d74 ^ d46 ^ d70 ^ d95 ^ d25 ^ 
        d90 ^ d8 ^ d59 ^ d73 ^ d86 ^ d15 ^ d40 ^ c15 ^ d41 ^ d3 ^ 
        d19 ^ d24 ^ d38 ^ d45 ^ d18 ^ d57 ^ c20 ^ c5 ^ c22 ^ d83 ^ 
        d77 ^ c1 ^ c4 ^ c26 ^ d48 ^ c13 ^ d33 ^ d65 ^ d58 ^ d50 ^ 
        d84 ^ c27 ^ d68 ^ d2 ^ c6;  // 64 ins 1 outs level 3

    assign x3 = d7 ^ d85 ^ d2 ^ d18 ^ d19 ^ c21 ^ d53 ^ d15 ^ d45 ^ 
        d36 ^ d54 ^ c17 ^ d84 ^ d38 ^ c26 ^ d71 ^ c31 ^ d52 ^ d3 ^ 
        d40 ^ d27 ^ d81 ^ d17 ^ c5 ^ d39 ^ c25 ^ d59 ^ d31 ^ d65 ^ 
        d14 ^ d89 ^ c1 ^ c16 ^ d76 ^ d10 ^ d8 ^ d90 ^ d56 ^ d9 ^ 
        d1 ^ c12 ^ d95 ^ d86 ^ c9 ^ d33 ^ c4 ^ d58 ^ d69 ^ d73 ^ 
        c7 ^ c22 ^ d60 ^ d25 ^ d32 ^ d80 ^ c20 ^ d68 ^ d37;  // 58 ins 1 outs level 3

    assign x2 = d17 ^ c4 ^ c15 ^ d88 ^ d94 ^ c25 ^ d70 ^ d64 ^ d14 ^ 
        d58 ^ d31 ^ c19 ^ d38 ^ d51 ^ d85 ^ d26 ^ d67 ^ d79 ^ d57 ^ 
        d89 ^ d80 ^ d75 ^ c11 ^ d52 ^ c8 ^ d37 ^ c20 ^ d7 ^ d24 ^ 
        d1 ^ d83 ^ d59 ^ d72 ^ d44 ^ d32 ^ d30 ^ d55 ^ d0 ^ c30 ^ 
        d84 ^ d53 ^ c21 ^ c16 ^ d13 ^ d68 ^ d36 ^ c24 ^ c3 ^ d35 ^ 
        d16 ^ d39 ^ c6 ^ d8 ^ c0 ^ d2 ^ d18 ^ d9 ^ d6;  // 58 ins 1 outs level 3

    assign x1 = d47 ^ d81 ^ d94 ^ d28 ^ c8 ^ c17 ^ d87 ^ d13 ^ c1 ^ 
        d63 ^ d12 ^ c16 ^ d65 ^ c15 ^ c30 ^ d60 ^ d79 ^ d58 ^ c5 ^ 
        d17 ^ d35 ^ d37 ^ d7 ^ c10 ^ d80 ^ d16 ^ c22 ^ d24 ^ d69 ^ 
        d0 ^ d44 ^ d72 ^ c0 ^ c23 ^ d51 ^ d62 ^ c24 ^ d34 ^ d1 ^ 
        d88 ^ d11 ^ d53 ^ d9 ^ d6 ^ d86 ^ d50 ^ d33 ^ d46 ^ d56 ^ 
        d59 ^ d38 ^ d64 ^ d49 ^ d74 ^ d27;  // 55 ins 1 outs level 3

    assign x0 = d24 ^ d73 ^ d6 ^ d9 ^ d53 ^ d37 ^ c9 ^ c2 ^ d16 ^ 
        c3 ^ d55 ^ d32 ^ d72 ^ d82 ^ c15 ^ d63 ^ d66 ^ d67 ^ d61 ^ 
        c23 ^ d44 ^ c31 ^ d0 ^ d30 ^ d79 ^ c19 ^ c4 ^ d60 ^ d45 ^ 
        d10 ^ d65 ^ d31 ^ d54 ^ c18 ^ d29 ^ d12 ^ d68 ^ d84 ^ d50 ^ 
        d58 ^ d48 ^ c21 ^ c30 ^ d85 ^ c1 ^ d83 ^ c20 ^ d25 ^ d26 ^ 
        d47 ^ d81 ^ d34 ^ d95 ^ d94 ^ d28 ^ c8 ^ c17 ^ d87;  // 58 ins 1 outs level 3

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat96_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [95:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x271, x270, x269, x268, x267, x266, x265, 
       x264, x263, x262, x261, x260, x259, x258, x257, 
       x256, x255, x254, x253, x252, x251, x250, x249, 
       x248, x247, x246, x244, x243, x242, x241, x240, 
       x239, x238, x237, x236, x235, x234, x233, x232, 
       x231, x230, x229, x228, x227, x226, x225, x224, 
       x223, x222, x221, x220, x219, x218, x217, x216, 
       x215, x214, x213, x212, x211, x210, x209, x208, 
       x207, x206, x205, x204, x203, x202, x201, x200, 
       x199, x198, x197, x196, x195, x194, x193, x192, 
       x191, x190, x189, x188, x187, x186, x185, x184, 
       x183, x182, x181, x180, x179, x178, x177, x176, 
       x175, x174, x173, x172, x171, x170, x169, x168, 
       x167, x166, x165, x164, x163, x162, x161, x160, 
       x159, x158, x157, x156, x155, x154, x153, x152, 
       x151, x150, x149, x148, x147, x146, x145, x144, 
       x143, x142, x141, x140, x139, x138, x137, x136, 
       x135, x134, x133, x132, x131, x130, x129, x128, 
       x127, x126, x125, x124, x123, x122, x121, x120, 
       x119, x118, x117, x116, x115, x114, x113, x112, 
       x111, x110, x109, x108, x107, x106, x105, x104, 
       x103, x102, x101, x100, x99, x98, x97, x96, 
       x94, x93, x92, x91, x90, x89, x88, x87, 
       x86, x85, x84, x83, x82, x81, x80, x79, 
       x78, x77, x76, x75, x74, x73, x72, x71, 
       x70, x69, x68, x67, x66, x65, x64, x63, 
       x62, x61, x60, x59, x58, x57, x56, x55, 
       x54, x53, x52, x51, x50, x49, x48, x47, 
       x46, x45, x44, x43, x42, x41, x40, x39, 
       x38, x37, x36, x35, x34, x33, x32, x31, 
       x30, x29, x28, x27, x26, x25, x24, x23, 
       x22, x21, x20, x19, x18, x17, x16, x15, 
       x14, x13, x12, x11, x10, x9, x8, x7, 
       x6, x5, x4, x3, x2, x1, x0;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44,d45,d46,
    d47,d48,d49,d50,d51,d52,d53,d54,d55,d56,d57,d58,d59,d60,d61,d62,
    d63,d64,d65,d66,d67,d68,d69,d70,d71,d72,d73,d74,d75,d76,d77,d78,
    d79,d80,d81,d82,d83,d84,d85,d86,d87,d88,d89,d90,d91,d92,d93,d94,
    d95;

assign { d95,d94,d93,d92,d91,d90,d89,d88,d87,d86,d85,d84,d83,d82,d81,
        d80,d79,d78,d77,d76,d75,d74,d73,d72,d71,d70,d69,d68,d67,d66,d65,
        d64,d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [95:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x271i (.out(x271),.a(d9),.b(x266),.c(x41),.d(x63),.e(x36),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x270i (.out(x270),.a(x267),.b(x42),.c(x39),.d(x269),.e(x268),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x269i (.out(x269),.a(d54),.b(c3),.c(c4),.d(d7),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x268i (.out(x268),.a(d67),.b(d47),.c(d10),.d(d72),.e(d53),.f(d87));  // 6 ins 1 outs level 1

    xor6 x267i (.out(x267),.a(d37),.b(d68),.c(d30),.d(d63),.e(d83),.f(d29));  // 6 ins 1 outs level 1

    xor6 x266i (.out(x266),.a(d27),.b(c23),.c(c31),.d(d61),.e(d50),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x265i (.out(x265),.a(x261),.b(x264),.c(x33),.d(x36),.e(x262),.f(x263));  // 6 ins 1 outs level 2

    xor6 x264i (.out(x264),.a(d65),.b(d53),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x263i (.out(x263),.a(d63),.b(d16),.c(d49),.d(d46),.e(c8),.f(d17));  // 6 ins 1 outs level 1

    xor6 x262i (.out(x262),.a(d61),.b(c23),.c(d47),.d(d87),.e(d19),.f(d27));  // 6 ins 1 outs level 1

    xor6 x261i (.out(x261),.a(d64),.b(d13),.c(d37),.d(d79),.e(d60),.f(d9));  // 6 ins 1 outs level 1

    xor6 x260i (.out(x260),.a(d0),.b(d35),.c(c24),.d(d88),.e(c15),.f(c1));  // 6 ins 1 outs level 1

    xor6 x259i (.out(x259),.a(x37),.b(x254),.c(x44),.d(x65),.e(x35),.f(x52));  // 6 ins 1 outs level 2

    xor6 x258i (.out(x258),.a(x255),.b(d16),.c(x46),.d(x36),.e(x256),.f(x257));  // 6 ins 1 outs level 2

    xor6 x257i (.out(x257),.a(d30),.b(d44),.c(c21),.d(d17),.e(d85),.f(d84));  // 6 ins 1 outs level 1

    xor6 x256i (.out(x256),.a(d2),.b(d10),.c(d78),.d(d50),.e(d14),.f(d51));  // 6 ins 1 outs level 1

    xor6 x255i (.out(x255),.a(d8),.b(c20),.c(d53),.d(c8),.e(d87),.f(c4));  // 6 ins 1 outs level 1

    xor6 x254i (.out(x254),.a(d1),.b(d64),.c(d15),.d(d62),.e(d68),.f(d36));  // 6 ins 1 outs level 1

    xor6 x253i (.out(x253),.a(x249),.b(x43),.c(x35),.d(x252),.e(x250),.f(x251));  // 6 ins 1 outs level 2

    xor6 x252i (.out(x252),.a(d68),.b(d43),.c(d32),.d(d9),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x251i (.out(x251),.a(d18),.b(c9),.c(d8),.d(d37),.e(d39),.f(d36));  // 6 ins 1 outs level 1

    xor6 x250i (.out(x250),.a(d56),.b(d19),.c(d50),.d(d53),.e(c26),.f(d51));  // 6 ins 1 outs level 1

    xor6 x249i (.out(x249),.a(d25),.b(d38),.c(c7),.d(d17),.e(d15),.f(d89));  // 6 ins 1 outs level 1

    xor6 x248i (.out(x248),.a(d81),.b(c17),.c(d90),.d(c31),.e(c25),.f(d58));  // 6 ins 1 outs level 1

    xor6 x247i (.out(x247),.a(x241),.b(x57),.c(x49),.d(x35),.e(x40),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x246i (.out(x246),.a(d57),.b(d50),.c(x242),.d(x47),.e(x243),.f(x244));  // 6 ins 1 outs level 2

    xor6 x244i (.out(x244),.a(d3),.b(d45),.c(d59),.d(d95),.e(d55),.f(d40));  // 6 ins 1 outs level 1

    xor6 x243i (.out(x243),.a(d73),.b(d29),.c(d63),.d(d4),.e(c31),.f(d79));  // 6 ins 1 outs level 1

    xor6 x242i (.out(x242),.a(d49),.b(d1),.c(d12),.d(d18),.e(d90),.f(c9));  // 6 ins 1 outs level 1

    xor6 x241i (.out(x241),.a(d0),.b(d47),.c(d30),.d(d25),.e(d39),.f(c15));  // 6 ins 1 outs level 1

    xor6 x240i (.out(x240),.a(x235),.b(x74),.c(x65),.d(x33),.e(x35),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x239i (.out(x239),.a(x236),.b(d63),.c(x34),.d(x46),.e(x237),.f(x238));  // 6 ins 1 outs level 2

    xor6 x238i (.out(x238),.a(c10),.b(d20),.c(d3),.d(d54),.e(d58),.f(d49));  // 6 ins 1 outs level 1

    xor6 x237i (.out(x237),.a(c5),.b(c28),.c(d65),.d(d42),.e(c14),.f(d69));  // 6 ins 1 outs level 1

    xor6 x236i (.out(x236),.a(c19),.b(d74),.c(c3),.d(d46),.e(c1),.f(d13));  // 6 ins 1 outs level 1

    xor6 x235i (.out(x235),.a(d64),.b(d92),.c(d40),.d(d1),.e(d67),.f(d62));  // 6 ins 1 outs level 1

    xor6 x234i (.out(x234),.a(x229),.b(x62),.c(x43),.d(x39),.e(x36),.f(x34));  // 6 ins 1 outs level 2

    xor6 x233i (.out(x233),.a(x230),.b(d42),.c(x49),.d(x38),.e(x231),.f(x232));  // 6 ins 1 outs level 2

    xor6 x232i (.out(x232),.a(d30),.b(d38),.c(d1),.d(d33),.e(d59),.f(d20));  // 6 ins 1 outs level 1

    xor6 x231i (.out(x231),.a(d54),.b(d51),.c(d41),.d(c12),.e(d83),.f(d81));  // 6 ins 1 outs level 1

    xor6 x230i (.out(x230),.a(c6),.b(d45),.c(d8),.d(d32),.e(d71),.f(d70));  // 6 ins 1 outs level 1

    xor6 x229i (.out(x229),.a(d76),.b(c4),.c(d56),.d(d68),.e(d5),.f(c17));  // 6 ins 1 outs level 1

    xor6 x228i (.out(x228),.a(x223),.b(x75),.c(x40),.d(x45),.e(x32),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x227i (.out(x227),.a(x224),.b(d22),.c(x65),.d(x42),.e(x225),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x226i (.out(x226),.a(d7),.b(d16),.c(d43),.d(d26),.e(d59),.f(d31));  // 6 ins 1 outs level 1

    xor6 x225i (.out(x225),.a(d23),.b(d42),.c(d58),.d(c23),.e(d41),.f(d15));  // 6 ins 1 outs level 1

    xor6 x224i (.out(x224),.a(d45),.b(c5),.c(d69),.d(d5),.e(d12),.f(d30));  // 6 ins 1 outs level 1

    xor6 x223i (.out(x223),.a(c7),.b(d95),.c(c10),.d(d74),.e(d46),.f(d71));  // 6 ins 1 outs level 1

    xor6 x222i (.out(x222),.a(x40),.b(x75),.c(x39),.d(x43),.e(x34),.f(x53));  // 6 ins 1 outs level 2

    xor6 x221i (.out(x221),.a(x217),.b(x220),.c(x44),.d(x45),.e(x218),.f(x219));  // 6 ins 1 outs level 2

    xor6 x220i (.out(x220),.a(d35),.b(d58),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x219i (.out(x219),.a(d28),.b(c9),.c(d22),.d(d11),.e(c24),.f(d88));  // 6 ins 1 outs level 1

    xor6 x218i (.out(x218),.a(d38),.b(d27),.c(d17),.d(d46),.e(c5),.f(c23));  // 6 ins 1 outs level 1

    xor6 x217i (.out(x217),.a(d37),.b(d69),.c(d1),.d(d40),.e(d0),.f(d2));  // 6 ins 1 outs level 1

    xor6 x216i (.out(x216),.a(x211),.b(x60),.c(x63),.d(x52),.e(x48),.f(x35));  // 6 ins 1 outs level 2

    xor6 x215i (.out(x215),.a(x212),.b(x214),.c(x33),.d(x37),.e(x40),.f(x213));  // 6 ins 1 outs level 2

    xor6 x214i (.out(x214),.a(c12),.b(d84),.c(c7),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x213i (.out(x213),.a(d36),.b(d64),.c(d47),.d(c0),.e(d31),.f(d80));  // 6 ins 1 outs level 1

    xor6 x212i (.out(x212),.a(d58),.b(c21),.c(d46),.d(d41),.e(d4),.f(c16));  // 6 ins 1 outs level 1

    xor6 x211i (.out(x211),.a(d15),.b(c20),.c(d85),.d(d79),.e(c15),.f(d39));  // 6 ins 1 outs level 1

    xor6 x210i (.out(x210),.a(x32),.b(x35),.c(x56),.d(x60),.e(x62),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x209i (.out(x209),.a(d36),.b(x206),.c(x52),.d(x58),.e(x207),.f(x208));  // 6 ins 1 outs level 2

    xor6 x208i (.out(x208),.a(c26),.b(d3),.c(d43),.d(d53),.e(d90),.f(d39));  // 6 ins 1 outs level 1

    xor6 x207i (.out(x207),.a(d62),.b(d77),.c(c25),.d(c13),.e(d25),.f(d75));  // 6 ins 1 outs level 1

    xor6 x206i (.out(x206),.a(c11),.b(c14),.c(d18),.d(d1),.e(c31),.f(d89));  // 6 ins 1 outs level 1

    xor6 x205i (.out(x205),.a(x199),.b(d20),.c(x56),.d(x50),.e(x35),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x204i (.out(x204),.a(x200),.b(x46),.c(x203),.d(x201),.e(x202),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x203i (.out(x203),.a(d50),.b(d68),.c(d65),.d(c23),.e(c19),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x202i (.out(x202),.a(c18),.b(c0),.c(d47),.d(d9),.e(c14),.f(d59));  // 6 ins 1 outs level 1

    xor6 x201i (.out(x201),.a(c10),.b(d82),.c(d1),.d(d57),.e(d56),.f(d73));  // 6 ins 1 outs level 1

    xor6 x200i (.out(x200),.a(d66),.b(c26),.c(c2),.d(d15),.e(d24),.f(d64));  // 6 ins 1 outs level 1

    xor6 x199i (.out(x199),.a(c9),.b(d12),.c(d2),.d(c1),.e(d74),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x198i (.out(x198),.a(x193),.b(x57),.c(x52),.d(x48),.e(x40),.f(x50));  // 6 ins 1 outs level 2

    xor6 x197i (.out(x197),.a(x194),.b(x60),.c(x196),.d(x41),.e(x58),.f(x195));  // 6 ins 1 outs level 2

    xor6 x196i (.out(x196),.a(c7),.b(d49),.c(d17),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x195i (.out(x195),.a(d50),.b(c23),.c(d12),.d(d59),.e(d54),.f(c10));  // 6 ins 1 outs level 1

    xor6 x194i (.out(x194),.a(d47),.b(d92),.c(c18),.d(d41),.e(c28),.f(d82));  // 6 ins 1 outs level 1

    xor6 x193i (.out(x193),.a(d74),.b(d0),.c(d29),.d(d6),.e(d8),.f(d45));  // 6 ins 1 outs level 1

    xor6 x192i (.out(x192),.a(x42),.b(x60),.c(x44),.d(x49),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x191i (.out(x191),.a(x187),.b(x190),.c(x38),.d(x48),.e(x188),.f(x189));  // 6 ins 1 outs level 2

    xor6 x190i (.out(x190),.a(d52),.b(d50),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x189i (.out(x189),.a(d88),.b(d28),.c(d32),.d(d16),.e(c14),.f(d18));  // 6 ins 1 outs level 1

    xor6 x188i (.out(x188),.a(c24),.b(c18),.c(c19),.d(d42),.e(d13),.f(c23));  // 6 ins 1 outs level 1

    xor6 x187i (.out(x187),.a(d11),.b(d40),.c(d82),.d(c4),.e(c8),.f(d48));  // 6 ins 1 outs level 1

    xor6 x186i (.out(x186),.a(x181),.b(x60),.c(x59),.d(x45),.e(x35),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x185i (.out(x185),.a(x182),.b(x44),.c(x37),.d(x183),.e(x184),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x184i (.out(x184),.a(d52),.b(d78),.c(d20),.d(d93),.e(d49),.f(c9));  // 6 ins 1 outs level 1

    xor6 x183i (.out(x183),.a(d17),.b(d11),.c(d61),.d(d23),.e(d2),.f(d14));  // 6 ins 1 outs level 1

    xor6 x182i (.out(x182),.a(d57),.b(d59),.c(d43),.d(d76),.e(d56),.f(d44));  // 6 ins 1 outs level 1

    xor6 x181i (.out(x181),.a(d19),.b(d5),.c(c23),.d(d55),.e(c19),.f(d63));  // 6 ins 1 outs level 1

    xor6 x180i (.out(x180),.a(x174),.b(x60),.c(x44),.d(x75),.e(x41),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x179i (.out(x179),.a(x175),.b(x178),.c(x32),.d(x37),.e(x176),.f(x177));  // 6 ins 1 outs level 2

    xor6 x178i (.out(x178),.a(c8),.b(d3),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x177i (.out(x177),.a(d28),.b(d33),.c(d54),.d(d44),.e(c12),.f(d29));  // 6 ins 1 outs level 1

    xor6 x176i (.out(x176),.a(c0),.b(d90),.c(d64),.d(c10),.e(c13),.f(c14));  // 6 ins 1 outs level 1

    xor6 x175i (.out(x175),.a(d9),.b(d18),.c(d66),.d(d57),.e(d74),.f(d84));  // 6 ins 1 outs level 1

    xor6 x174i (.out(x174),.a(c20),.b(c2),.c(d77),.d(d72),.e(d62),.f(d16));  // 6 ins 1 outs level 1

    xor6 x173i (.out(x173),.a(x40),.b(x170),.c(x57),.d(x61),.e(x171),.f(x172));  // 6 ins 1 outs level 2

    xor6 x172i (.out(x172),.a(d36),.b(c22),.c(c26),.d(d89),.e(c25),.f(d22));  // 6 ins 1 outs level 1

    xor6 x171i (.out(x171),.a(d26),.b(d13),.c(d44),.d(d4),.e(d56),.f(d47));  // 6 ins 1 outs level 1

    xor6 x170i (.out(x170),.a(d12),.b(d51),.c(d60),.d(d5),.e(d15),.f(d2));  // 6 ins 1 outs level 1

    xor6 x169i (.out(x169),.a(c14),.b(d29),.c(d0),.d(d78),.e(c20),.f(d84));  // 6 ins 1 outs level 1

    xor6 x168i (.out(x168),.a(x164),.b(x167),.c(x53),.d(x41),.e(x165),.f(x166));  // 6 ins 1 outs level 2

    xor6 x167i (.out(x167),.a(d88),.b(d73),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x166i (.out(x166),.a(d43),.b(c15),.c(c19),.d(d84),.e(d95),.f(d6));  // 6 ins 1 outs level 1

    xor6 x165i (.out(x165),.a(d30),.b(d47),.c(c5),.d(d69),.e(d87),.f(d57));  // 6 ins 1 outs level 1

    xor6 x164i (.out(x164),.a(d52),.b(d64),.c(d83),.d(d14),.e(d1),.f(c24));  // 6 ins 1 outs level 1

    xor6 x163i (.out(x163),.a(d58),.b(d79),.c(d17),.d(d25),.e(c20),.f(c12));  // 6 ins 1 outs level 1

    xor6 x162i (.out(x162),.a(x158),.b(x37),.c(x40),.d(x161),.e(x159),.f(x160));  // 6 ins 1 outs level 2

    xor6 x161i (.out(x161),.a(d34),.b(c22),.c(d14),.d(d23),.e(d19),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x160i (.out(x160),.a(d49),.b(d21),.c(d6),.d(d7),.e(d84),.f(d48));  // 6 ins 1 outs level 1

    xor6 x159i (.out(x159),.a(c28),.b(d91),.c(d86),.d(c20),.e(d58),.f(c21));  // 6 ins 1 outs level 1

    xor6 x158i (.out(x158),.a(d53),.b(c29),.c(d31),.d(c6),.e(d46),.f(c27));  // 6 ins 1 outs level 1

    xor6 x157i (.out(x157),.a(d92),.b(d70),.c(d93),.d(d52),.e(d0),.f(d85));  // 6 ins 1 outs level 1

    xor6 x156i (.out(x156),.a(x152),.b(x48),.c(x32),.d(x153),.e(x154),.f(x155));  // 6 ins 1 outs level 2

    xor6 x155i (.out(x155),.a(d90),.b(c23),.c(d71),.d(d22),.e(d54),.f(d27));  // 6 ins 1 outs level 1

    xor6 x154i (.out(x154),.a(d35),.b(d89),.c(d11),.d(c21),.e(d3),.f(d32));  // 6 ins 1 outs level 1

    xor6 x153i (.out(x153),.a(d7),.b(c14),.c(d87),.d(d38),.e(d85),.f(d16));  // 6 ins 1 outs level 1

    xor6 x152i (.out(x152),.a(d1),.b(c25),.c(d40),.d(d46),.e(c7),.f(d33));  // 6 ins 1 outs level 1

    xor6 x151i (.out(x151),.a(x148),.b(x36),.c(x34),.d(x50),.e(x150),.f(x149));  // 6 ins 1 outs level 2

    xor6 x150i (.out(x150),.a(d72),.b(d30),.c(d0),.d(c6),.e(d23),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x149i (.out(x149),.a(d88),.b(d21),.c(d9),.d(c22),.e(d7),.f(d70));  // 6 ins 1 outs level 1

    xor6 x148i (.out(x148),.a(d50),.b(d39),.c(d86),.d(d87),.e(c29),.f(d4));  // 6 ins 1 outs level 1

    xor6 x147i (.out(x147),.a(c26),.b(c24),.c(c8),.d(d44),.e(d93),.f(c9));  // 6 ins 1 outs level 1

    xor6 x146i (.out(x146),.a(x141),.b(x145),.c(x61),.d(x142),.e(x143),.f(x144));  // 6 ins 1 outs level 2

    xor6 x145i (.out(x145),.a(c7),.b(d49),.c(d10),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x144i (.out(x144),.a(d51),.b(d24),.c(d17),.d(c19),.e(c30),.f(d91));  // 6 ins 1 outs level 1

    xor6 x143i (.out(x143),.a(d73),.b(d94),.c(d52),.d(d26),.e(c9),.f(d80));  // 6 ins 1 outs level 1

    xor6 x142i (.out(x142),.a(d95),.b(d86),.c(c16),.d(d56),.e(d34),.f(d64));  // 6 ins 1 outs level 1

    xor6 x141i (.out(x141),.a(c23),.b(d27),.c(d40),.d(d42),.e(d61),.f(c27));  // 6 ins 1 outs level 1

    xor6 x140i (.out(x140),.a(x135),.b(x52),.c(x56),.d(x41),.e(x37),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x139i (.out(x139),.a(x53),.b(x136),.c(x138),.d(x34),.e(x50),.f(x137));  // 6 ins 1 outs level 2

    xor6 x138i (.out(x138),.a(d52),.b(d68),.c(c26),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x137i (.out(x137),.a(d66),.b(d14),.c(c30),.d(d94),.e(c2),.f(d87));  // 6 ins 1 outs level 1

    xor6 x136i (.out(x136),.a(d15),.b(d57),.c(c4),.d(d56),.e(c14),.f(d65));  // 6 ins 1 outs level 1

    xor6 x135i (.out(x135),.a(d13),.b(c1),.c(d62),.d(d37),.e(d41),.f(d17));  // 6 ins 1 outs level 1

    xor6 x134i (.out(x134),.a(x41),.b(x129),.c(x48),.d(x50),.e(x52),.f(x37));  // 6 ins 1 outs level 2

    xor6 x133i (.out(x133),.a(x130),.b(x132),.c(x49),.d(x44),.e(x43),.f(x131));  // 6 ins 1 outs level 2

    xor6 x132i (.out(x132),.a(c0),.b(c26),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x131i (.out(x131),.a(d20),.b(d18),.c(d48),.d(d57),.e(d49),.f(c27));  // 6 ins 1 outs level 1

    xor6 x130i (.out(x130),.a(d34),.b(d56),.c(d60),.d(d11),.e(d42),.f(d52));  // 6 ins 1 outs level 1

    xor6 x129i (.out(x129),.a(d39),.b(d46),.c(d45),.d(d54),.e(d91),.f(d38));  // 6 ins 1 outs level 1

    xor6 x128i (.out(x128),.a(x122),.b(x62),.c(x36),.d(x41),.e(x33),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x127i (.out(x127),.a(x123),.b(x126),.c(x37),.d(x39),.e(x124),.f(x125));  // 6 ins 1 outs level 2

    xor6 x126i (.out(x126),.a(c6),.b(d70),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x125i (.out(x125),.a(d52),.b(d18),.c(d1),.d(c10),.e(d16),.f(c9));  // 6 ins 1 outs level 1

    xor6 x124i (.out(x124),.a(d47),.b(c22),.c(d80),.d(c26),.e(d10),.f(d20));  // 6 ins 1 outs level 1

    xor6 x123i (.out(x123),.a(c28),.b(d24),.c(d45),.d(c16),.e(d92),.f(c12));  // 6 ins 1 outs level 1

    xor6 x122i (.out(x122),.a(d63),.b(d50),.c(d74),.d(d15),.e(d7),.f(d39));  // 6 ins 1 outs level 1

    xor6 x121i (.out(x121),.a(x116),.b(x76),.c(x61),.d(x49),.e(x37),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x120i (.out(x120),.a(x117),.b(x119),.c(x33),.d(x50),.e(x118),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x119i (.out(x119),.a(d29),.b(d84),.c(d28),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x118i (.out(x118),.a(c0),.b(c20),.c(d93),.d(d30),.e(d3),.f(d33));  // 6 ins 1 outs level 1

    xor6 x117i (.out(x117),.a(d31),.b(c22),.c(c26),.d(d62),.e(d71),.f(d49));  // 6 ins 1 outs level 1

    xor6 x116i (.out(x116),.a(c7),.b(d18),.c(c12),.d(d58),.e(d40),.f(d2));  // 6 ins 1 outs level 1

    xor6 x115i (.out(x115),.a(x38),.b(x44),.c(x53),.d(x59),.e(x47),.f(x46));  // 6 ins 1 outs level 2

    xor6 x114i (.out(x114),.a(x110),.b(x58),.c(x45),.d(x113),.e(x111),.f(x112));  // 6 ins 1 outs level 2

    xor6 x113i (.out(x113),.a(d32),.b(d55),.c(d6),.d(d43),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x112i (.out(x112),.a(d0),.b(d77),.c(d18),.d(d66),.e(c2),.f(d73));  // 6 ins 1 outs level 1

    xor6 x111i (.out(x111),.a(d48),.b(d64),.c(d19),.d(d63),.e(d38),.f(d29));  // 6 ins 1 outs level 1

    xor6 x110i (.out(x110),.a(d59),.b(c13),.c(d90),.d(d39),.e(d60),.f(d10));  // 6 ins 1 outs level 1

    xor6 x109i (.out(x109),.a(d62),.b(x104),.c(x58),.d(x47),.e(x53),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x108i (.out(x108),.a(x105),.b(x34),.c(x49),.d(x107),.e(x106),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x107i (.out(x107),.a(d45),.b(d48),.c(d55),.d(d27),.e(d89),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x106i (.out(x106),.a(d21),.b(c27),.c(d58),.d(d40),.e(d53),.f(c25));  // 6 ins 1 outs level 1

    xor6 x105i (.out(x105),.a(c12),.b(d28),.c(d32),.d(d26),.e(d50),.f(d2));  // 6 ins 1 outs level 1

    xor6 x104i (.out(x104),.a(d5),.b(d91),.c(d56),.d(d90),.e(d1),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x103i (.out(x103),.a(x40),.b(x57),.c(x59),.d(x33),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x102i (.out(x102),.a(x98),.b(x101),.c(x46),.d(x47),.e(x99),.f(x100));  // 6 ins 1 outs level 2

    xor6 x101i (.out(x101),.a(d32),.b(d87),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x100i (.out(x100),.a(d15),.b(d12),.c(c14),.d(d25),.e(d63),.f(c29));  // 6 ins 1 outs level 1

    xor6 x99i (.out(x99),.a(d72),.b(d54),.c(c19),.d(d93),.e(d43),.f(d40));  // 6 ins 1 outs level 1

    xor6 x98i (.out(x98),.a(d27),.b(d90),.c(c5),.d(d83),.e(d69),.f(d38));  // 6 ins 1 outs level 1

    xor6 x97i (.out(x97),.a(x92),.b(x58),.c(x46),.d(x43),.e(x35),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x96i (.out(x96),.a(c14),.b(d4),.c(x93),.d(x38),.e(x36),.f(x94));  // 6 ins 1 outs level 2

    xor6 x94i (.out(x94),.a(d9),.b(d23),.c(d34),.d(d60),.e(d21),.f(d13));  // 6 ins 1 outs level 1

    xor6 x93i (.out(x93),.a(c8),.b(d33),.c(d83),.d(c5),.e(d59),.f(d54));  // 6 ins 1 outs level 1

    xor6 x92i (.out(x92),.a(d26),.b(d45),.c(d69),.d(d27),.e(d57),.f(d72));  // 6 ins 1 outs level 1

    xor6 x91i (.out(x91),.a(x38),.b(x76),.c(x60),.d(x41),.e(x34),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x90i (.out(x90),.a(x86),.b(x39),.c(x89),.d(x87),.e(x88),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x89i (.out(x89),.a(d26),.b(d63),.c(d46),.d(d65),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x88i (.out(x88),.a(d78),.b(d93),.c(d43),.d(d23),.e(d30),.f(d52));  // 6 ins 1 outs level 1

    xor6 x87i (.out(x87),.a(d42),.b(d5),.c(c9),.d(c1),.e(d14),.f(d35));  // 6 ins 1 outs level 1

    xor6 x86i (.out(x86),.a(d95),.b(d50),.c(d48),.d(c0),.e(d56),.f(d24));  // 6 ins 1 outs level 1

    xor6 x85i (.out(x85),.a(x80),.b(d27),.c(x39),.d(x42),.e(x53),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x84i (.out(x84),.a(x81),.b(x61),.c(x57),.d(x82),.e(x83),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x83i (.out(x83),.a(d64),.b(d44),.c(c8),.d(d78),.e(d81),.f(d37));  // 6 ins 1 outs level 1

    xor6 x82i (.out(x82),.a(c22),.b(c17),.c(c7),.d(d24),.e(d9),.f(d54));  // 6 ins 1 outs level 1

    xor6 x81i (.out(x81),.a(d36),.b(d49),.c(c31),.d(d28),.e(d50),.f(d57));  // 6 ins 1 outs level 1

    xor6 x80i (.out(x80),.a(d32),.b(d11),.c(d29),.d(d48),.e(d30),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x79i (.out(x79),.a(d39),.b(c16),.c(x36),.d(d80),.e(d47),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x78i (.out(x78),.a(d95),.b(d10),.c(x35),.d(d60),.e(x32),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x77i (.out(x77),.a(d62),.b(d15),.c(d87),.d(x37),.e(1'b0),.f(1'b0));  // 4 ins 2 outs level 2

    xor6 x76i (.out(x76),.a(c29),.b(d77),.c(d55),.d(d8),.e(c13),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x75i (.out(x75),.a(d8),.b(d12),.c(d60),.d(d34),.e(c31),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x74i (.out(x74),.a(d19),.b(c8),.c(c11),.d(d75),.e(d21),.f(1'b0));  // 5 ins 2 outs level 1

    xor6 x73i (.out(x73),.a(d56),.b(d76),.c(d19),.d(x39),.e(1'b0),.f(1'b0));  // 4 ins 3 outs level 2

    xor6 x72i (.out(x72),.a(x49),.b(d56),.c(d33),.d(d38),.e(1'b0),.f(1'b0));  // 4 ins 3 outs level 2

    xor6 x71i (.out(x71),.a(d5),.b(x38),.c(d33),.d(d38),.e(d76),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x70i (.out(x70),.a(c17),.b(x34),.c(c8),.d(x42),.e(d81),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x69i (.out(x69),.a(x43),.b(d95),.c(d31),.d(d48),.e(d6),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x68i (.out(x68),.a(c28),.b(x42),.c(d92),.d(d60),.e(d61),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x67i (.out(x67),.a(x62),.b(c4),.c(d76),.d(d71),.e(x45),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x66i (.out(x66),.a(d67),.b(c3),.c(d38),.d(x46),.e(c19),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x65i (.out(x65),.a(d24),.b(d39),.c(d10),.d(d0),.e(d37),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x64i (.out(x64),.a(c27),.b(x50),.c(d35),.d(d24),.e(d91),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x63i (.out(x63),.a(d24),.b(d44),.c(d12),.d(d34),.e(d58),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x62i (.out(x62),.a(d43),.b(d7),.c(d14),.d(d2),.e(d40),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x61i (.out(x61),.a(d86),.b(d83),.c(d82),.d(c18),.e(d37),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x60i (.out(x60),.a(d5),.b(d71),.c(d29),.d(d53),.e(1'b0),.f(1'b0));  // 4 ins 10 outs level 1

    xor6 x59i (.out(x59),.a(d32),.b(d79),.c(d26),.d(d28),.e(c15),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x58i (.out(x58),.a(d4),.b(d42),.c(d63),.d(d76),.e(c9),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x57i (.out(x57),.a(d94),.b(c30),.c(d46),.d(d15),.e(d8),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x56i (.out(x56),.a(d0),.b(d16),.c(d26),.d(d25),.e(d33),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x55i (.out(x55),.a(d62),.b(x32),.c(d6),.d(d72),.e(c0),.f(1'b0));  // 5 ins 9 outs level 2

    xor6 x54i (.out(x54),.a(x44),.b(d76),.c(d21),.d(d56),.e(d30),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x53i (.out(x53),.a(d67),.b(c3),.c(d43),.d(d23),.e(c14),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x52i (.out(x52),.a(d13),.b(d35),.c(d18),.d(d9),.e(d31),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x51i (.out(x51),.a(d95),.b(d4),.c(x36),.d(d73),.e(c7),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x50i (.out(x50),.a(c23),.b(d90),.c(d36),.d(d48),.e(d17),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x49i (.out(x49),.a(d55),.b(d11),.c(d19),.d(d74),.e(c10),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x48i (.out(x48),.a(c22),.b(d86),.c(d1),.d(d69),.e(c5),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x47i (.out(x47),.a(d49),.b(d20),.c(d78),.d(d24),.e(c26),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x46i (.out(x46),.a(c27),.b(d95),.c(d41),.d(d44),.e(d91),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x45i (.out(x45),.a(c12),.b(d51),.c(d54),.d(d31),.e(d3),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x44i (.out(x44),.a(d87),.b(c11),.c(d57),.d(d75),.e(1'b0),.f(1'b0));  // 4 ins 8 outs level 1

    xor6 x43i (.out(x43),.a(c20),.b(c1),.c(d33),.d(d65),.e(d84),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x42i (.out(x42),.a(d29),.b(d93),.c(d25),.d(d47),.e(c29),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x41i (.out(x41),.a(d73),.b(d85),.c(c21),.d(d27),.e(d45),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x40i (.out(x40),.a(d77),.b(c4),.c(c13),.d(d68),.e(d2),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x39i (.out(x39),.a(c2),.b(d60),.c(c19),.d(d32),.e(d66),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x38i (.out(x38),.a(d22),.b(c28),.c(c31),.d(d92),.e(d64),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x37i (.out(x37),.a(c25),.b(d88),.c(d89),.d(c24),.e(d15),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x36i (.out(x36),.a(d55),.b(d28),.c(d94),.d(d7),.e(c30),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x35i (.out(x35),.a(d70),.b(c6),.c(d78),.d(d83),.e(d58),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x34i (.out(x34),.a(d79),.b(c15),.c(c9),.d(d82),.e(c18),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x33i (.out(x33),.a(d61),.b(d52),.c(d81),.d(d51),.e(c17),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x32i (.out(x32),.a(d52),.b(c16),.c(d80),.d(d59),.e(d50),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x31i (.out(x31),.a(x84),.b(x60),.c(x69),.d(x55),.e(x85),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x30i (.out(x30),.a(x90),.b(x33),.c(x78),.d(x51),.e(x91),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x29i (.out(x29),.a(x96),.b(x45),.c(x55),.d(x70),.e(x97),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x28i (.out(x28),.a(x102),.b(x71),.c(x55),.d(x54),.e(x103),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x27i (.out(x27),.a(x79),.b(x40),.c(x68),.d(x108),.e(x109),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x26i (.out(x26),.a(x114),.b(x33),.c(x42),.d(x77),.e(x115),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x25i (.out(x25),.a(x120),.b(x38),.c(x66),.d(x54),.e(x121),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x24i (.out(x24),.a(x127),.b(x61),.c(x64),.d(x54),.e(x128),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x23i (.out(x23),.a(x133),.b(x56),.c(x70),.d(x55),.e(x134),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x22i (.out(x22),.a(x139),.b(x72),.c(x63),.d(x68),.e(x140),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x21i (.out(x21),.a(x146),.b(x38),.c(x60),.d(x52),.e(x77),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x20i (.out(x20),.a(x147),.b(x46),.c(x33),.d(x56),.e(x75),.f(x151));  // 6 ins 1 outs level 3

    xor6 x19i (.out(x19),.a(x156),.b(x33),.c(x47),.d(x57),.e(x68),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x18i (.out(x18),.a(x157),.b(x32),.c(x65),.d(x59),.e(x162),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x17i (.out(x17),.a(x163),.b(x47),.c(x52),.d(x64),.e(x71),.f(x168));  // 6 ins 1 outs level 3

    xor6 x16i (.out(x16),.a(x169),.b(x73),.c(x54),.d(x64),.e(x173),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x15i (.out(x15),.a(x179),.b(x47),.c(x54),.d(x51),.e(x180),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x14i (.out(x14),.a(x185),.b(x76),.c(x69),.d(x51),.e(x186),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x13i (.out(x13),.a(x191),.b(x78),.c(x55),.d(x67),.e(x192),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x12i (.out(x12),.a(x197),.b(x33),.c(x64),.d(x54),.e(x198),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x11i (.out(x11),.a(x204),.b(x41),.c(x67),.d(x51),.e(x205),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x10i (.out(x10),.a(x209),.b(x48),.c(x73),.d(x51),.e(x210),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x9i (.out(x9),.a(x215),.b(x73),.c(x72),.d(x53),.e(x216),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x8i (.out(x8),.a(x221),.b(x41),.c(x58),.d(x78),.e(x222),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x7i (.out(x7),.a(x226),.b(x59),.c(x54),.d(x227),.e(x228),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x6i (.out(x6),.a(x233),.b(x42),.c(x51),.d(x74),.e(x55),.f(x234));  // 6 ins 1 outs level 3

    xor6 x5i (.out(x5),.a(x239),.b(x60),.c(x55),.d(x51),.e(x240),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x4i (.out(x4),.a(x246),.b(x48),.c(x69),.d(x66),.e(x247),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x3i (.out(x3),.a(x248),.b(x41),.c(x48),.d(x67),.e(x78),.f(x253));  // 6 ins 1 outs level 3

    xor6 x2i (.out(x2),.a(x258),.b(x66),.c(x59),.d(x55),.e(x259),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x1i (.out(x1),.a(x260),.b(x48),.c(x55),.d(x72),.e(x63),.f(x265));  // 6 ins 1 outs level 3

    xor6 x0i (.out(x0),.a(x270),.b(x70),.c(x56),.d(x69),.e(x271),.f(1'b0));  // 5 ins 1 outs level 3

endmodule

