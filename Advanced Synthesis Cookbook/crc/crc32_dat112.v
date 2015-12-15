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

//// CRC-32 of 112 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000000000000000000000000000 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111
//        00000000001111111111222222222233 0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011
//        01234567890123456789012345678901 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//
// C00  = .XXXXX.X......XXXXXX.X.XX.X...XX X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX
// C01  = XX....XXX.....X.....XXXX.XXX..X. XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..X.XXX.XXXX...X..X.X....XXX....XXX.....X.....XXXX.XXX..X.
// C02  = X..XXX..XX....X.XXXX..X....XX.X. XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X.XXXX..X....XX.X.
// C03  = XX..XXX..XX....X.XXXX..X....XX.X .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X.XXXX..X....XX.X
// C04  = ...XX.X...XX..XX.X..X..X..X..X.X X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X......XXX...X.X.XXXX..XX..X.X...XX.X...XX..XX.X..X..X..X..X.X
// C05  = XXXX.......XX.X..X.X...X..XX...X XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X..X.X...X..XX...X
// C06  = XXXXX.......XX.X..X.X...X..XX... .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X..X.X...X..XX...
// C07  = X......X.....X.X.XX....XXXX.XXXX X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.XXX.X.......XX.X..XXXX.XX......X.....X.X.XX....XXXX.XXXX
// C08  = X.XXXX.XX......X.X...X.X.X.X.X.. XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......X.X...X.X.X.X.X..
// C09  = XX.XXXX.XX......X.X...X.X.X.X.X. .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......X.X...X.X.X.X.X.
// C10  = X..X..X..XX...XXX.X..X..XXXX.XX. X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..XX.XXX.XX..X..XXX.X.X.XX.X..X..X..XX...XXX.X..X..XXXX.XX.
// C11  = ..XX.X....XX..X...X..XXXXX.XX... XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XXXXXX....XXX.X.XX.XX.X.X...XX.X....XX..X...X..XXXXX.XX...
// C12  = .XX..XXX...XX.X.XXX..XX..X..XXXX XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXXX
// C13  = ..XX..XXX...XX.X.XXX..XX..X..XXX .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXX
// C14  = ...XX..XXX...XX.X.XXX..XX..X..XX ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XX
// C15  = X...XX..XXX...XX.X.XXX..XX..X..X ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..X
// C16  = ..XXX.XX.XXX..X..X.XX.XXXX...XXX X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXX
// C17  = ...XXX.XX.XXX..X..X.XX.XXXX...XX .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XX
// C18  = X...XXX.XX.XXX..X..X.XX.XXXX...X ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...X
// C19  = XX...XXX.XX.XXX..X..X.XX.XXXX... ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...
// C20  = .XX...XXX.XX.XXX..X..X.XX.XXXX.. ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX..
// C21  = X.XX...XXX.XX.XXX..X..X.XX.XXXX. .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX.
// C22  = ..X..X.XXXX.XXX...XXXX..XX..XX.. X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X.XX.XXX..XXXX....XX....X..X..X.XXXX.XXX...XXXX..XX..XX..
// C23  = XXX.XXXXXXXX.X..XXX.X.XXXX...X.X XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XXXX...X.X
// C24  = XXXX.XXXXXXXX.X..XXX.X.XXXX...X. .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XXXX...X.
// C25  = .XXXX.XXXXXXXX.X..XXX.X.XXXX...X ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XXXX...X
// C26  = .X......XXXXXX.X.XX.X...XX.XX.XX X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XX
// C27  = X.X......XXXXXX.X.XX.X...XX.XX.X .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.X
// C28  = XX.X......XXXXXX.X.XX.X...XX.XX. ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.
// C29  = XXX.X......XXXXXX.X.XX.X...XX.XX ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX
// C30  = XXXX.X......XXXXXX.X.XX.X...XX.X ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.X
// C31  = XXXXX.X......XXXXXX.X.XX.X...XX. .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.
//
module crc32_dat112 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [111:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat112_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat112_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat112_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [111:0] dat_in;
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
    d79,d80,d81,d82,d83,d84,d85,d86,d87,d88,d89,d90,d91,d92,d93,d94,
    d95,d96,d97,d98,d99,d100,d101,d102,d103,d104,d105,d106,d107,d108,d109,d110,
    d111;

assign { d111,d110,d109,d108,d107,d106,d105,d104,d103,d102,d101,d100,d99,d98,d97,
        d96,d95,d94,d93,d92,d91,d90,d89,d88,d87,d86,d85,d84,d83,d82,d81,
        d80,d79,d78,d77,d76,d75,d74,d73,d72,d71,d70,d69,d68,d67,d66,d65,
        d64,d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [111:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x15 = d72 ^ c0 ^ d50 ^ c21 ^ c24 ^ d34 ^ d111 ^ c9 ^ d100 ^ 
        c28 ^ d95 ^ d20 ^ c19 ^ c31 ^ d66 ^ d18 ^ d8 ^ d57 ^ c17 ^ 
        d3 ^ d55 ^ d97 ^ d78 ^ d53 ^ d71 ^ d77 ^ d84 ^ d108 ^ d27 ^ 
        d62 ^ d90 ^ d24 ^ d45 ^ c15 ^ d4 ^ d64 ^ c5 ^ d7 ^ d104 ^ 
        c25 ^ c8 ^ d94 ^ d74 ^ d101 ^ d44 ^ c10 ^ c4 ^ d88 ^ d21 ^ 
        d9 ^ d54 ^ d33 ^ d15 ^ d80 ^ d105 ^ d5 ^ d89 ^ c20 ^ d12 ^ 
        d49 ^ d60 ^ d76 ^ d99 ^ d56 ^ d85 ^ d16 ^ d52 ^ d30 ^ c14 ^ 
        d59;  // 70 ins 1 outs level 3

    assign x14 = d49 ^ d20 ^ d51 ^ d88 ^ d79 ^ d14 ^ d87 ^ d73 ^ c20 ^ 
        d44 ^ c14 ^ c7 ^ d77 ^ d104 ^ d15 ^ c9 ^ d98 ^ c24 ^ d58 ^ 
        d70 ^ d63 ^ d83 ^ d56 ^ c16 ^ c19 ^ c23 ^ d94 ^ c31 ^ d100 ^ 
        d59 ^ d48 ^ d19 ^ d99 ^ d110 ^ c27 ^ d26 ^ c4 ^ d53 ^ d55 ^ 
        d11 ^ d61 ^ d6 ^ d23 ^ d54 ^ d2 ^ d84 ^ d52 ^ d43 ^ d75 ^ 
        d89 ^ c30 ^ d33 ^ d111 ^ d17 ^ d7 ^ d4 ^ d8 ^ c18 ^ d93 ^ 
        d65 ^ d3 ^ c8 ^ d107 ^ d29 ^ c13 ^ d71 ^ d76 ^ d103 ^ d32 ^ 
        c3 ^ d96;  // 71 ins 1 outs level 3

    assign x13 = d57 ^ d70 ^ c31 ^ d5 ^ c7 ^ d48 ^ d42 ^ d88 ^ d14 ^ 
        d106 ^ d102 ^ d3 ^ d110 ^ c19 ^ d103 ^ d109 ^ d82 ^ c3 ^ d25 ^ 
        d53 ^ d78 ^ d93 ^ d111 ^ c13 ^ d7 ^ d19 ^ d99 ^ c17 ^ d95 ^ 
        d98 ^ d72 ^ d69 ^ d32 ^ d43 ^ c30 ^ c6 ^ d87 ^ d55 ^ d62 ^ 
        d92 ^ d74 ^ c2 ^ d76 ^ c22 ^ d22 ^ c26 ^ d13 ^ d2 ^ d86 ^ 
        c15 ^ d6 ^ c8 ^ c29 ^ d50 ^ d58 ^ c18 ^ d47 ^ d10 ^ d75 ^ 
        d16 ^ c23 ^ d18 ^ d31 ^ c12 ^ d60 ^ d1 ^ d54 ^ d52 ^ d28 ^ 
        d51 ^ d97 ^ d64 ^ d83;  // 73 ins 1 outs level 3

    assign x12 = d68 ^ d24 ^ d18 ^ d91 ^ d4 ^ d1 ^ d57 ^ d101 ^ c28 ^ 
        d71 ^ d15 ^ d108 ^ d52 ^ c30 ^ c6 ^ d81 ^ d105 ^ d87 ^ d61 ^ 
        d86 ^ d2 ^ c21 ^ c14 ^ d53 ^ c16 ^ d92 ^ d102 ^ d54 ^ d46 ^ 
        d17 ^ d85 ^ d111 ^ d73 ^ d63 ^ d75 ^ d56 ^ c29 ^ d41 ^ d98 ^ 
        d0 ^ d74 ^ c22 ^ c7 ^ d109 ^ d6 ^ d27 ^ c18 ^ c31 ^ d42 ^ 
        c12 ^ d59 ^ d94 ^ d13 ^ c25 ^ d21 ^ d49 ^ d5 ^ d47 ^ c1 ^ 
        d96 ^ d77 ^ d12 ^ c2 ^ d30 ^ c17 ^ d69 ^ d110 ^ d51 ^ d50 ^ 
        d9 ^ c11 ^ d82 ^ d31 ^ c5 ^ d97;  // 75 ins 1 outs level 3

    assign x11 = c23 ^ d66 ^ d24 ^ d9 ^ d50 ^ d33 ^ d108 ^ d16 ^ d1 ^ 
        d43 ^ d36 ^ d102 ^ d107 ^ c10 ^ d14 ^ d58 ^ c5 ^ d85 ^ d74 ^ 
        d64 ^ c27 ^ d12 ^ d105 ^ d15 ^ d28 ^ d103 ^ d25 ^ d27 ^ d31 ^ 
        c25 ^ d0 ^ d47 ^ c21 ^ d94 ^ d76 ^ c22 ^ d56 ^ d51 ^ d70 ^ 
        d4 ^ d48 ^ d91 ^ c24 ^ d101 ^ d54 ^ c3 ^ d98 ^ d78 ^ d57 ^ 
        d82 ^ d40 ^ d68 ^ d41 ^ d104 ^ d45 ^ c11 ^ d73 ^ d90 ^ d26 ^ 
        d59 ^ d17 ^ c14 ^ d44 ^ d65 ^ d55 ^ d20 ^ c18 ^ c28 ^ c2 ^ 
        d3 ^ d71 ^ d83;  // 72 ins 1 outs level 3

    assign x10 = d19 ^ d13 ^ d90 ^ c29 ^ d58 ^ d42 ^ c10 ^ d104 ^ d28 ^ 
        c24 ^ d3 ^ d98 ^ d40 ^ d71 ^ d0 ^ d86 ^ d101 ^ c14 ^ d106 ^ 
        c6 ^ d29 ^ d14 ^ d32 ^ c15 ^ d5 ^ d69 ^ d36 ^ d63 ^ d59 ^ 
        c30 ^ d75 ^ d95 ^ d105 ^ c16 ^ d9 ^ d89 ^ d94 ^ d107 ^ d66 ^ 
        d16 ^ c26 ^ c3 ^ d73 ^ d55 ^ c18 ^ d77 ^ d62 ^ d70 ^ d39 ^ 
        d2 ^ d56 ^ d52 ^ c25 ^ d110 ^ c0 ^ d60 ^ d50 ^ c21 ^ c9 ^ 
        d80 ^ d33 ^ d78 ^ d26 ^ d31 ^ d83 ^ d109 ^ d96 ^ d35 ^ c27;  // 69 ins 1 outs level 3

    assign x9 = d74 ^ c5 ^ d66 ^ d1 ^ c8 ^ d88 ^ d35 ^ d29 ^ d41 ^ 
        d69 ^ d86 ^ c18 ^ d77 ^ c9 ^ d38 ^ d64 ^ d33 ^ d68 ^ d67 ^ 
        d12 ^ d104 ^ d36 ^ d5 ^ d71 ^ d110 ^ d96 ^ d78 ^ d108 ^ d23 ^ 
        c3 ^ c0 ^ c6 ^ d106 ^ d83 ^ d89 ^ d55 ^ d13 ^ d51 ^ d47 ^ 
        d24 ^ d85 ^ d43 ^ d18 ^ d11 ^ d81 ^ c22 ^ d32 ^ c28 ^ d70 ^ 
        d79 ^ d53 ^ d60 ^ d76 ^ c24 ^ c4 ^ d34 ^ c30 ^ d39 ^ c1 ^ 
        d61 ^ d44 ^ d4 ^ d58 ^ c16 ^ d80 ^ c26 ^ d9 ^ d2 ^ d52 ^ 
        d102 ^ d46 ^ d98 ^ d84;  // 73 ins 1 outs level 3

    assign x8 = d45 ^ d12 ^ d33 ^ d35 ^ d105 ^ d80 ^ d73 ^ d70 ^ d84 ^ 
        d107 ^ d46 ^ c23 ^ d67 ^ c5 ^ d23 ^ d59 ^ d63 ^ d82 ^ d31 ^ 
        d4 ^ d32 ^ d65 ^ d17 ^ d68 ^ d52 ^ d50 ^ d69 ^ d28 ^ c29 ^ 
        c2 ^ d22 ^ c17 ^ d95 ^ c15 ^ c0 ^ c27 ^ d101 ^ d79 ^ d76 ^ 
        d85 ^ d103 ^ d75 ^ d88 ^ d11 ^ d38 ^ d97 ^ d57 ^ d40 ^ d42 ^ 
        d10 ^ d66 ^ d43 ^ d0 ^ c7 ^ d8 ^ d83 ^ d37 ^ c25 ^ d51 ^ 
        d109 ^ c8 ^ d1 ^ d34 ^ d78 ^ d60 ^ c3 ^ c21 ^ d87 ^ c4 ^ 
        d77 ^ d3 ^ d54;  // 72 ins 1 outs level 3

    assign x7 = d103 ^ c15 ^ d106 ^ d104 ^ d60 ^ d97 ^ d29 ^ c28 ^ c0 ^ 
        d51 ^ d45 ^ c7 ^ d47 ^ d108 ^ d42 ^ d5 ^ d93 ^ c13 ^ c24 ^ 
        d74 ^ d58 ^ d75 ^ c23 ^ d10 ^ d2 ^ d68 ^ d34 ^ d69 ^ d87 ^ 
        d8 ^ d98 ^ d24 ^ d37 ^ d15 ^ c18 ^ d56 ^ d28 ^ c17 ^ d39 ^ 
        c31 ^ d43 ^ d57 ^ d7 ^ d76 ^ d32 ^ c30 ^ d46 ^ c29 ^ d105 ^ 
        d22 ^ c25 ^ d77 ^ d0 ^ c26 ^ d95 ^ d41 ^ d111 ^ d23 ^ d80 ^ 
        d109 ^ d110 ^ d50 ^ d21 ^ d16 ^ d54 ^ d52 ^ d25 ^ d3 ^ d71 ^ 
        d79;  // 70 ins 1 outs level 3

    assign x6 = c27 ^ c0 ^ d108 ^ d14 ^ d100 ^ c12 ^ d25 ^ d22 ^ d92 ^ 
        d56 ^ d82 ^ d41 ^ c15 ^ d7 ^ d38 ^ d65 ^ d64 ^ d21 ^ d104 ^ 
        c2 ^ d20 ^ d43 ^ d71 ^ d76 ^ d5 ^ c3 ^ d2 ^ d70 ^ d95 ^ 
        d79 ^ d81 ^ d4 ^ d40 ^ d54 ^ d29 ^ d74 ^ d72 ^ c28 ^ d93 ^ 
        c18 ^ d55 ^ d62 ^ d80 ^ d1 ^ d68 ^ d45 ^ d107 ^ d73 ^ c13 ^ 
        d47 ^ d75 ^ d42 ^ d8 ^ d51 ^ d50 ^ d30 ^ d6 ^ d98 ^ d60 ^ 
        d83 ^ c24 ^ d11 ^ c4 ^ c1 ^ d52 ^ d84 ^ d66 ^ c20;  // 68 ins 1 outs level 3

    assign x5 = d59 ^ d64 ^ d111 ^ d51 ^ d13 ^ d20 ^ c11 ^ d69 ^ d49 ^ 
        d103 ^ d72 ^ d19 ^ c31 ^ d4 ^ d97 ^ d106 ^ d40 ^ d82 ^ d55 ^ 
        d46 ^ d1 ^ d21 ^ d0 ^ c2 ^ d50 ^ d80 ^ d54 ^ d75 ^ d99 ^ 
        d78 ^ d81 ^ c19 ^ d24 ^ d41 ^ d28 ^ d5 ^ d79 ^ d91 ^ c23 ^ 
        c26 ^ d42 ^ d6 ^ c3 ^ d83 ^ d7 ^ d61 ^ c14 ^ d70 ^ c1 ^ 
        d10 ^ d44 ^ d53 ^ d63 ^ d73 ^ d39 ^ d94 ^ d65 ^ c17 ^ d92 ^ 
        d37 ^ d107 ^ d3 ^ d71 ^ c0 ^ d67 ^ d29 ^ d74 ^ c27 ^ c12;  // 69 ins 1 outs level 3

    assign x4 = d31 ^ d83 ^ d3 ^ d46 ^ c20 ^ d67 ^ d0 ^ c31 ^ d106 ^ 
        d91 ^ d4 ^ d90 ^ d30 ^ d59 ^ d68 ^ d12 ^ c15 ^ d103 ^ c26 ^ 
        d84 ^ d2 ^ d97 ^ d24 ^ c4 ^ d58 ^ d18 ^ c29 ^ c10 ^ d50 ^ 
        d19 ^ d33 ^ d48 ^ d100 ^ c3 ^ d69 ^ c23 ^ d45 ^ c14 ^ d79 ^ 
        c17 ^ d44 ^ d95 ^ d109 ^ d29 ^ d8 ^ d63 ^ d94 ^ d41 ^ d6 ^ 
        d65 ^ d15 ^ d86 ^ c6 ^ d74 ^ d70 ^ d11 ^ d47 ^ d39 ^ d111 ^ 
        d25 ^ d20 ^ c11 ^ d38 ^ d57 ^ d40 ^ d73 ^ d77;  // 67 ins 1 outs level 3

    assign x3 = d108 ^ d60 ^ d99 ^ d8 ^ d31 ^ c28 ^ d18 ^ d89 ^ c23 ^ 
        d7 ^ d103 ^ c1 ^ d65 ^ c4 ^ d76 ^ c9 ^ d86 ^ d81 ^ d2 ^ 
        d32 ^ d98 ^ d71 ^ d3 ^ c20 ^ d39 ^ d85 ^ d40 ^ d15 ^ d59 ^ 
        c10 ^ d80 ^ d52 ^ d25 ^ d68 ^ d1 ^ c5 ^ d17 ^ d36 ^ d9 ^ 
        d19 ^ c15 ^ c19 ^ d109 ^ d54 ^ d100 ^ d97 ^ d84 ^ c0 ^ c31 ^ 
        d45 ^ d111 ^ d33 ^ c6 ^ d27 ^ c29 ^ d56 ^ d73 ^ c17 ^ d95 ^ 
        d69 ^ c18 ^ d58 ^ d90 ^ d10 ^ d37 ^ d38 ^ d53 ^ d14;  // 68 ins 1 outs level 3

    assign x2 = d0 ^ d85 ^ c30 ^ d67 ^ d97 ^ c5 ^ d9 ^ d80 ^ d31 ^ 
        d98 ^ d102 ^ d58 ^ d32 ^ c3 ^ d52 ^ d26 ^ d55 ^ c18 ^ d110 ^ 
        d88 ^ c8 ^ c14 ^ c17 ^ c4 ^ d72 ^ d53 ^ d7 ^ d2 ^ d99 ^ 
        d1 ^ d51 ^ d83 ^ c0 ^ d38 ^ d94 ^ d16 ^ d37 ^ c9 ^ d68 ^ 
        d44 ^ c27 ^ d107 ^ d64 ^ c19 ^ d35 ^ d57 ^ d39 ^ d84 ^ d108 ^ 
        c22 ^ d70 ^ d36 ^ d59 ^ d24 ^ d96 ^ d17 ^ d8 ^ c28 ^ d18 ^ 
        d89 ^ d14 ^ d6 ^ d13 ^ d75 ^ d30 ^ d79 ^ c16;  // 67 ins 1 outs level 3

    assign x1 = d9 ^ d6 ^ d106 ^ d103 ^ d13 ^ d24 ^ d17 ^ d28 ^ c14 ^ 
        d59 ^ c22 ^ d110 ^ c30 ^ d44 ^ d16 ^ d81 ^ d7 ^ d12 ^ d33 ^ 
        d35 ^ d79 ^ d107 ^ d63 ^ d37 ^ d34 ^ c23 ^ d101 ^ d87 ^ d51 ^ 
        d50 ^ d38 ^ d53 ^ d69 ^ d0 ^ c26 ^ d49 ^ d56 ^ d100 ^ c25 ^ 
        d27 ^ c6 ^ d94 ^ c27 ^ c0 ^ c20 ^ d74 ^ d60 ^ c21 ^ d1 ^ 
        c8 ^ d88 ^ d65 ^ d11 ^ d72 ^ c7 ^ d46 ^ d64 ^ d47 ^ c1 ^ 
        d102 ^ d58 ^ d86 ^ d62 ^ d105 ^ d80;  // 65 ins 1 outs level 3

    assign x0 = d37 ^ d83 ^ d31 ^ d81 ^ d26 ^ d73 ^ d25 ^ d50 ^ d110 ^ 
        d111 ^ d95 ^ c17 ^ c2 ^ c18 ^ d55 ^ d58 ^ c1 ^ d47 ^ c7 ^ 
        d65 ^ d94 ^ d63 ^ d44 ^ c14 ^ d61 ^ d45 ^ c3 ^ c26 ^ d101 ^ 
        d28 ^ d24 ^ d84 ^ c19 ^ d99 ^ d54 ^ c4 ^ d103 ^ c15 ^ d106 ^ 
        d104 ^ d68 ^ d82 ^ c31 ^ d72 ^ d98 ^ d87 ^ d34 ^ c24 ^ d48 ^ 
        d12 ^ d96 ^ c21 ^ d60 ^ d0 ^ d85 ^ d16 ^ d66 ^ c30 ^ d32 ^ 
        d29 ^ d67 ^ d53 ^ d10 ^ d97 ^ c5 ^ d9 ^ d6 ^ c23 ^ c16 ^ 
        d79 ^ d30;  // 71 ins 1 outs level 3

    assign x31 = c20 ^ c23 ^ c6 ^ d27 ^ d84 ^ d105 ^ c17 ^ d36 ^ d86 ^ 
        d31 ^ d95 ^ d33 ^ c2 ^ c29 ^ d83 ^ d97 ^ d78 ^ d47 ^ c3 ^ 
        d11 ^ d100 ^ d15 ^ c14 ^ d49 ^ c18 ^ d66 ^ c4 ^ d80 ^ c0 ^ 
        d59 ^ d25 ^ c22 ^ d23 ^ d81 ^ d72 ^ d44 ^ d8 ^ d65 ^ d52 ^ 
        d5 ^ d103 ^ c13 ^ d98 ^ c1 ^ c15 ^ d24 ^ d62 ^ d46 ^ d94 ^ 
        d9 ^ d109 ^ d54 ^ d30 ^ d60 ^ c25 ^ d57 ^ d64 ^ d28 ^ d71 ^ 
        c16 ^ d110 ^ d96 ^ d67 ^ d43 ^ d93 ^ d82 ^ c30 ^ d53 ^ d102 ^ 
        d29;  // 70 ins 1 outs level 3

    assign x30 = d83 ^ d35 ^ d77 ^ d32 ^ c0 ^ d64 ^ c24 ^ d66 ^ d85 ^ 
        d48 ^ d27 ^ d10 ^ d81 ^ d99 ^ d43 ^ d71 ^ d63 ^ c21 ^ d52 ^ 
        d97 ^ d29 ^ d14 ^ d26 ^ c5 ^ d80 ^ d7 ^ c17 ^ c14 ^ d111 ^ 
        d23 ^ d109 ^ d58 ^ d46 ^ d59 ^ d65 ^ d22 ^ c29 ^ c1 ^ c19 ^ 
        d82 ^ d95 ^ d51 ^ d93 ^ c2 ^ c16 ^ d28 ^ d102 ^ c3 ^ d45 ^ 
        c22 ^ c13 ^ d8 ^ d30 ^ d61 ^ c15 ^ d101 ^ d42 ^ d4 ^ d70 ^ 
        c28 ^ d53 ^ d104 ^ d56 ^ d96 ^ d108 ^ d24 ^ d79 ^ c31 ^ d92 ^ 
        d94 ^ c12;  // 71 ins 1 outs level 3

    assign x29 = d50 ^ d82 ^ c21 ^ d31 ^ d34 ^ c11 ^ d101 ^ d79 ^ c30 ^ 
        d47 ^ d103 ^ d3 ^ d84 ^ d44 ^ d95 ^ d42 ^ d45 ^ d96 ^ d80 ^ 
        c20 ^ d63 ^ d28 ^ d108 ^ d81 ^ d58 ^ d41 ^ c12 ^ d51 ^ c15 ^ 
        d69 ^ d7 ^ c4 ^ c2 ^ c0 ^ d110 ^ c23 ^ d26 ^ c31 ^ d65 ^ 
        d92 ^ d70 ^ c18 ^ d76 ^ d78 ^ d107 ^ d100 ^ c1 ^ d64 ^ d55 ^ 
        d93 ^ d94 ^ d57 ^ d52 ^ d23 ^ d27 ^ d111 ^ c16 ^ d25 ^ d98 ^ 
        d29 ^ c27 ^ d62 ^ d22 ^ c28 ^ d9 ^ d91 ^ c14 ^ d13 ^ d60 ^ 
        d6 ^ c13 ^ d21;  // 72 ins 1 outs level 3

    assign x28 = d109 ^ d28 ^ d100 ^ d90 ^ d81 ^ d57 ^ d24 ^ d5 ^ d93 ^ 
        d80 ^ d46 ^ c0 ^ d63 ^ d107 ^ d94 ^ d75 ^ d8 ^ d26 ^ d97 ^ 
        c17 ^ d40 ^ d49 ^ c14 ^ c26 ^ d79 ^ d78 ^ c27 ^ d69 ^ c29 ^ 
        d68 ^ d92 ^ c3 ^ c19 ^ d83 ^ d25 ^ d50 ^ c1 ^ d44 ^ d21 ^ 
        d41 ^ d95 ^ d64 ^ d54 ^ d110 ^ d62 ^ d20 ^ d27 ^ d91 ^ d77 ^ 
        c20 ^ d99 ^ d102 ^ c15 ^ d12 ^ c12 ^ d2 ^ d33 ^ d106 ^ c22 ^ 
        d56 ^ d6 ^ c10 ^ d51 ^ d30 ^ c13 ^ c30 ^ d61 ^ c11 ^ d43 ^ 
        d59 ^ d22;  // 71 ins 1 outs level 3

    assign x27 = d62 ^ d61 ^ d25 ^ d89 ^ d76 ^ d55 ^ c18 ^ d20 ^ d78 ^ 
        c16 ^ d24 ^ d48 ^ d58 ^ d98 ^ d42 ^ d40 ^ d1 ^ d94 ^ d68 ^ 
        d82 ^ d45 ^ d26 ^ c12 ^ d79 ^ d11 ^ d50 ^ d96 ^ d77 ^ d93 ^ 
        d74 ^ d7 ^ c0 ^ d108 ^ d39 ^ c29 ^ d23 ^ d4 ^ d32 ^ d67 ^ 
        c28 ^ c26 ^ d91 ^ c9 ^ d5 ^ c2 ^ c19 ^ d63 ^ c31 ^ d111 ^ 
        c21 ^ d101 ^ d43 ^ d53 ^ d56 ^ d27 ^ d92 ^ c10 ^ c14 ^ c13 ^ 
        d106 ^ c25 ^ d49 ^ d99 ^ d60 ^ d80 ^ d21 ^ d105 ^ d29 ^ d90 ^ 
        c11 ^ d109 ^ d19;  // 72 ins 1 outs level 3

    assign x26 = d98 ^ d47 ^ d25 ^ d55 ^ c30 ^ d107 ^ d61 ^ d24 ^ c15 ^ 
        d4 ^ c9 ^ d39 ^ d77 ^ d6 ^ d44 ^ d54 ^ d104 ^ d62 ^ c27 ^ 
        d91 ^ c12 ^ d97 ^ d92 ^ d67 ^ d93 ^ d59 ^ d0 ^ c1 ^ d78 ^ 
        d22 ^ d60 ^ d18 ^ d76 ^ d66 ^ d88 ^ d90 ^ c13 ^ d48 ^ d41 ^ 
        d28 ^ d105 ^ c17 ^ c18 ^ d10 ^ d95 ^ d89 ^ c24 ^ c20 ^ c25 ^ 
        c10 ^ c31 ^ d75 ^ d100 ^ d38 ^ d111 ^ d57 ^ d42 ^ d23 ^ d3 ^ 
        c11 ^ d110 ^ d20 ^ d73 ^ d26 ^ d81 ^ d31 ^ d79 ^ d49 ^ d19 ^ 
        c28 ^ d52 ^ c8 ^ d108;  // 73 ins 1 outs level 3

    assign x25 = d56 ^ d28 ^ c7 ^ d31 ^ d67 ^ c18 ^ d33 ^ d76 ^ d89 ^ 
        d8 ^ d102 ^ d88 ^ d106 ^ d93 ^ d57 ^ d3 ^ d105 ^ d18 ^ d61 ^ 
        c25 ^ d107 ^ d19 ^ c20 ^ c12 ^ d37 ^ c24 ^ c8 ^ d86 ^ d41 ^ 
        c19 ^ d11 ^ c4 ^ d75 ^ d92 ^ d77 ^ d48 ^ d81 ^ d21 ^ d90 ^ 
        c3 ^ d38 ^ c11 ^ c1 ^ d44 ^ d29 ^ d83 ^ c31 ^ d49 ^ c27 ^ 
        d58 ^ c15 ^ d52 ^ c6 ^ d91 ^ c13 ^ d64 ^ c26 ^ d74 ^ d36 ^ 
        d100 ^ c9 ^ d82 ^ d84 ^ d98 ^ d99 ^ d51 ^ d104 ^ d17 ^ c2 ^ 
        d95 ^ d87 ^ d22 ^ c10 ^ c22 ^ d15 ^ d40 ^ d71 ^ d111 ^ d62 ^ 
        d2;  // 80 ins 1 outs level 3

    assign x24 = d17 ^ c24 ^ d51 ^ c25 ^ d27 ^ d74 ^ d105 ^ d88 ^ d30 ^ 
        d104 ^ c1 ^ d56 ^ d40 ^ d76 ^ d7 ^ d61 ^ d106 ^ c23 ^ d90 ^ 
        c10 ^ c11 ^ d48 ^ c0 ^ d16 ^ d39 ^ d83 ^ c26 ^ c30 ^ d55 ^ 
        d28 ^ d91 ^ c7 ^ d97 ^ d63 ^ d103 ^ d92 ^ c6 ^ d36 ^ d37 ^ 
        d70 ^ d82 ^ d101 ^ d98 ^ d20 ^ c17 ^ c12 ^ d85 ^ d87 ^ d47 ^ 
        d35 ^ d110 ^ d75 ^ c8 ^ d73 ^ c19 ^ c21 ^ d1 ^ d21 ^ d14 ^ 
        d89 ^ d18 ^ d99 ^ d60 ^ d57 ^ c3 ^ c18 ^ c9 ^ d43 ^ d50 ^ 
        d94 ^ c14 ^ d86 ^ d2 ^ d10 ^ d32 ^ c2 ^ d66 ^ c5 ^ d81 ^ 
        d80;  // 80 ins 1 outs level 3

    assign x23 = d54 ^ d82 ^ c31 ^ d72 ^ d98 ^ d97 ^ c5 ^ d9 ^ d6 ^ 
        d103 ^ d65 ^ d80 ^ d79 ^ d73 ^ d88 ^ c7 ^ d29 ^ c8 ^ c6 ^ 
        d16 ^ c24 ^ d109 ^ d47 ^ c1 ^ d91 ^ d93 ^ d90 ^ d105 ^ d55 ^ 
        d74 ^ c11 ^ d39 ^ c9 ^ d46 ^ d96 ^ c18 ^ c2 ^ d111 ^ c17 ^ 
        d85 ^ d15 ^ d69 ^ d35 ^ c22 ^ d0 ^ d36 ^ d19 ^ c13 ^ d75 ^ 
        c29 ^ d17 ^ d89 ^ d59 ^ d34 ^ d1 ^ d84 ^ c10 ^ d50 ^ d60 ^ 
        d13 ^ d87 ^ d26 ^ d81 ^ c20 ^ d31 ^ d62 ^ d42 ^ d20 ^ d86 ^ 
        c4 ^ c16 ^ c23 ^ d104 ^ d102 ^ c0 ^ d27 ^ c25 ^ d100 ^ d56 ^ 
        d49 ^ d38;  // 81 ins 1 outs level 3

    assign x22 = c2 ^ c18 ^ d45 ^ d66 ^ d11 ^ d18 ^ d108 ^ d27 ^ d36 ^ 
        d67 ^ d79 ^ d9 ^ c9 ^ d89 ^ d74 ^ c8 ^ d43 ^ d73 ^ d93 ^ 
        d29 ^ d82 ^ d57 ^ d62 ^ d19 ^ d24 ^ c13 ^ d31 ^ d26 ^ d35 ^ 
        d101 ^ d88 ^ d99 ^ c19 ^ d37 ^ c5 ^ d16 ^ d61 ^ d38 ^ d85 ^ 
        c20 ^ d0 ^ d60 ^ c28 ^ c21 ^ d52 ^ c12 ^ d12 ^ d48 ^ c24 ^ 
        d58 ^ d34 ^ c25 ^ d14 ^ d87 ^ d94 ^ c14 ^ d98 ^ d44 ^ d105 ^ 
        c29 ^ d92 ^ d41 ^ d23 ^ d90 ^ d68 ^ d104 ^ d109 ^ d65 ^ d100 ^ 
        c10 ^ c7 ^ d47 ^ d55;  // 73 ins 1 outs level 3

    assign x21 = d80 ^ d82 ^ c3 ^ d49 ^ d51 ^ d24 ^ c30 ^ d110 ^ d9 ^ 
        d18 ^ d61 ^ c16 ^ d42 ^ d96 ^ d71 ^ d35 ^ d88 ^ c7 ^ c14 ^ 
        d89 ^ c9 ^ d52 ^ d95 ^ c25 ^ c24 ^ d108 ^ d104 ^ d13 ^ c22 ^ 
        d99 ^ d73 ^ d91 ^ d87 ^ c19 ^ c0 ^ c27 ^ c15 ^ d40 ^ d31 ^ 
        d105 ^ c29 ^ d22 ^ d56 ^ d62 ^ d27 ^ d83 ^ c8 ^ d5 ^ d107 ^ 
        d10 ^ d34 ^ d94 ^ d109 ^ d53 ^ d17 ^ d37 ^ d26 ^ d92 ^ c2 ^ 
        c11 ^ d102 ^ c12 ^ c28 ^ d29;  // 64 ins 1 outs level 3

    assign x20 = d28 ^ d55 ^ c21 ^ c7 ^ d60 ^ d87 ^ d16 ^ c10 ^ d107 ^ 
        d41 ^ d25 ^ d94 ^ d4 ^ d90 ^ c18 ^ d79 ^ d21 ^ c23 ^ c14 ^ 
        d36 ^ d23 ^ c6 ^ d103 ^ d91 ^ c28 ^ d50 ^ d51 ^ c2 ^ c8 ^ 
        d106 ^ c11 ^ d95 ^ d72 ^ c27 ^ d8 ^ c1 ^ d48 ^ d82 ^ d9 ^ 
        c26 ^ d101 ^ d61 ^ d86 ^ d81 ^ d52 ^ d30 ^ d108 ^ d17 ^ d33 ^ 
        d26 ^ d104 ^ d70 ^ c29 ^ d34 ^ d88 ^ d98 ^ c24 ^ d12 ^ d39 ^ 
        d109 ^ c13 ^ c15 ^ d93;  // 63 ins 1 outs level 3

    assign x19 = d47 ^ d102 ^ d35 ^ d100 ^ d33 ^ c25 ^ d86 ^ d8 ^ c10 ^ 
        c13 ^ d11 ^ d50 ^ c9 ^ d93 ^ c12 ^ d27 ^ d107 ^ d97 ^ d80 ^ 
        d59 ^ c5 ^ d49 ^ c14 ^ c27 ^ d7 ^ c23 ^ d85 ^ c0 ^ d32 ^ 
        d38 ^ c1 ^ d25 ^ d103 ^ d92 ^ c22 ^ c6 ^ d106 ^ d108 ^ d29 ^ 
        d90 ^ d54 ^ c17 ^ d15 ^ c28 ^ d60 ^ d22 ^ d40 ^ d69 ^ c7 ^ 
        d16 ^ c26 ^ d3 ^ d105 ^ d20 ^ d81 ^ d87 ^ d51 ^ d71 ^ d24 ^ 
        c20 ^ d89 ^ d94 ^ d78;  // 63 ins 1 outs level 3

    assign x18 = d111 ^ d77 ^ c31 ^ d10 ^ d102 ^ c5 ^ d92 ^ c22 ^ d99 ^ 
        d34 ^ c26 ^ d106 ^ c27 ^ d24 ^ d39 ^ d49 ^ d48 ^ d104 ^ d53 ^ 
        d32 ^ c25 ^ d91 ^ c9 ^ d88 ^ d84 ^ d96 ^ d70 ^ d28 ^ d93 ^ 
        c21 ^ d105 ^ d101 ^ d68 ^ d21 ^ d50 ^ d107 ^ d58 ^ d14 ^ c16 ^ 
        d80 ^ d23 ^ c12 ^ d79 ^ d6 ^ d2 ^ d89 ^ d7 ^ d86 ^ d31 ^ 
        d46 ^ d85 ^ c19 ^ c6 ^ d26 ^ c4 ^ c24 ^ c0 ^ c8 ^ d59 ^ 
        c11 ^ d19 ^ d15 ^ d37 ^ c13;  // 64 ins 1 outs level 3

    assign x17 = c21 ^ c20 ^ c31 ^ d20 ^ d5 ^ d98 ^ d90 ^ d83 ^ c10 ^ 
        d14 ^ d48 ^ d13 ^ d91 ^ c15 ^ d92 ^ d85 ^ d25 ^ d106 ^ d38 ^ 
        d49 ^ d22 ^ c12 ^ d101 ^ c24 ^ d18 ^ d36 ^ d30 ^ d52 ^ c7 ^ 
        d57 ^ d79 ^ d111 ^ d105 ^ d104 ^ d58 ^ c30 ^ d84 ^ d23 ^ d88 ^ 
        d103 ^ d33 ^ c11 ^ d78 ^ d27 ^ d95 ^ d87 ^ d69 ^ d47 ^ d76 ^ 
        d67 ^ c8 ^ d1 ^ c25 ^ c26 ^ c23 ^ d9 ^ c5 ^ c3 ^ d100 ^ 
        c18 ^ d110 ^ c4 ^ d31 ^ d45 ^ d6;  // 65 ins 1 outs level 3

    assign x16 = d30 ^ d87 ^ d4 ^ c2 ^ c31 ^ d26 ^ c23 ^ d29 ^ d57 ^ 
        c17 ^ d46 ^ d78 ^ c9 ^ c25 ^ d111 ^ d12 ^ d0 ^ d97 ^ d103 ^ 
        c11 ^ d83 ^ d37 ^ d110 ^ d32 ^ d13 ^ d99 ^ d48 ^ d90 ^ d19 ^ 
        c4 ^ d94 ^ c7 ^ d86 ^ d105 ^ d22 ^ c30 ^ c10 ^ d91 ^ d51 ^ 
        c3 ^ d66 ^ d82 ^ c14 ^ c29 ^ d44 ^ d5 ^ d17 ^ d100 ^ c24 ^ 
        d47 ^ d56 ^ d68 ^ d104 ^ c20 ^ c6 ^ d21 ^ c19 ^ d8 ^ d84 ^ 
        d102 ^ d109 ^ d89 ^ d24 ^ d75 ^ d77 ^ d35 ^ c22;  // 67 ins 1 outs level 3

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat112_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [111:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x332, x331, x330, x329, x328, x327, x326, 
       x325, x324, x323, x322, x321, x320, x319, x318, 
       x317, x316, x315, x314, x312, x311, x310, x309, 
       x308, x307, x306, x305, x304, x303, x302, x301, 
       x300, x299, x298, x297, x296, x295, x294, x293, 
       x292, x291, x290, x289, x288, x287, x286, x285, 
       x284, x283, x282, x281, x280, x279, x278, x277, 
       x276, x275, x274, x273, x272, x271, x270, x269, 
       x268, x267, x266, x265, x264, x263, x262, x261, 
       x260, x259, x258, x257, x256, x255, x254, x253, 
       x252, x251, x250, x249, x248, x247, x246, x245, 
       x244, x243, x242, x241, x240, x239, x238, x237, 
       x236, x235, x234, x233, x232, x230, x229, x228, 
       x227, x226, x225, x224, x223, x221, x220, x219, 
       x218, x217, x216, x215, x214, x213, x212, x211, 
       x210, x209, x208, x207, x206, x205, x204, x203, 
       x202, x201, x200, x199, x198, x197, x196, x195, 
       x194, x193, x192, x191, x190, x189, x188, x187, 
       x186, x185, x184, x183, x182, x181, x180, x179, 
       x178, x177, x176, x175, x173, x172, x171, x170, 
       x169, x168, x167, x166, x165, x164, x163, x162, 
       x161, x160, x159, x158, x157, x156, x155, x154, 
       x153, x152, x151, x150, x149, x148, x147, x146, 
       x145, x144, x143, x142, x141, x140, x139, x138, 
       x137, x136, x135, x134, x133, x132, x131, x130, 
       x129, x128, x127, x126, x125, x124, x123, x122, 
       x121, x120, x119, x118, x117, x116, x115, x114, 
       x113, x112, x111, x110, x109, x108, x107, x106, 
       x105, x104, x103, x102, x101, x100, x99, x98, 
       x97, x96, x95, x94, x93, x92, x91, x90, 
       x89, x88, x87, x85, x84, x83, x82, x81, 
       x80, x79, x78, x77, x76, x75, x74, x73, 
       x72, x71, x70, x69, x68, x67, x66, x65, 
       x64, x63, x62, x61, x60, x59, x58, x57, 
       x56, x55, x54, x53, x52, x51, x50, x49, 
       x48, x47, x46, x45, x44, x43, x42, x41, 
       x40, x39, x38, x37, x36, x35, x34, x33, 
       x32, x15, x14, x13, x12, x11, x10, x9, 
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
    d79,d80,d81,d82,d83,d84,d85,d86,d87,d88,d89,d90,d91,d92,d93,d94,
    d95,d96,d97,d98,d99,d100,d101,d102,d103,d104,d105,d106,d107,d108,d109,d110,
    d111;

assign { d111,d110,d109,d108,d107,d106,d105,d104,d103,d102,d101,d100,d99,d98,d97,
        d96,d95,d94,d93,d92,d91,d90,d89,d88,d87,d86,d85,d84,d83,d82,d81,
        d80,d79,d78,d77,d76,d75,d74,d73,d72,d71,d70,d69,d68,d67,d66,d65,
        d64,d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [111:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x332i (.out(x332),.a(x324),.b(x57),.c(x40),.d(x50),.e(x38),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x331i (.out(x331),.a(x325),.b(x326),.c(x327),.d(x328),.e(x329),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x330i (.out(x330),.a(d75),.b(d102),.c(d83),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x329i (.out(x329),.a(d100),.b(c22),.c(d44),.d(d56),.e(d13),.f(c24));  // 6 ins 1 outs level 1

    xor6 x328i (.out(x328),.a(d94),.b(c30),.c(d17),.d(d84),.e(d21),.f(c7));  // 6 ins 1 outs level 1

    xor6 x327i (.out(x327),.a(d35),.b(d24),.c(d110),.d(c10),.e(d47),.f(c1));  // 6 ins 1 outs level 1

    xor6 x326i (.out(x326),.a(d97),.b(c3),.c(d12),.d(d7),.e(d37),.f(d86));  // 6 ins 1 outs level 1

    xor6 x325i (.out(x325),.a(c20),.b(d46),.c(d68),.d(d66),.e(c25),.f(c23));  // 6 ins 1 outs level 1

    xor6 x324i (.out(x324),.a(d26),.b(c4),.c(d48),.d(d19),.e(c6),.f(d30));  // 6 ins 1 outs level 1

    xor6 x323i (.out(x323),.a(x32),.b(x68),.c(x33),.d(x35),.e(x61),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x322i (.out(x322),.a(x317),.b(x318),.c(x319),.d(x320),.e(x321),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x321i (.out(x321),.a(d6),.b(d67),.c(d1),.d(d69),.e(d87),.f(d33));  // 6 ins 1 outs level 1

    xor6 x320i (.out(x320),.a(d85),.b(d5),.c(d9),.d(d84),.e(d101),.f(c5));  // 6 ins 1 outs level 1

    xor6 x319i (.out(x319),.a(d38),.b(d29),.c(d27),.d(c21),.e(d30),.f(c26));  // 6 ins 1 outs level 1

    xor6 x318i (.out(x318),.a(d98),.b(d78),.c(d22),.d(d76),.e(d95),.f(d25));  // 6 ins 1 outs level 1

    xor6 x317i (.out(x317),.a(c30),.b(d106),.c(d58),.d(d92),.e(d18),.f(d105));  // 6 ins 1 outs level 1

    xor6 x316i (.out(x316),.a(c1),.b(d48),.c(c23),.d(c4),.e(d45),.f(c14));  // 6 ins 1 outs level 1

    xor6 x315i (.out(x315),.a(x307),.b(x41),.c(x40),.d(x49),.e(x32),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x314i (.out(x314),.a(x308),.b(x309),.c(x310),.d(x311),.e(x312),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x312i (.out(x312),.a(d44),.b(d46),.c(d69),.d(d9),.e(c13),.f(d80));  // 6 ins 1 outs level 1

    xor6 x311i (.out(x311),.a(d85),.b(d107),.c(c25),.d(d93),.e(d91),.f(c21));  // 6 ins 1 outs level 1

    xor6 x310i (.out(x310),.a(d70),.b(d104),.c(c7),.d(c9),.e(c31),.f(d23));  // 6 ins 1 outs level 1

    xor6 x309i (.out(x309),.a(d50),.b(d89),.c(c0),.d(d26),.e(d77),.f(d49));  // 6 ins 1 outs level 1

    xor6 x308i (.out(x308),.a(d21),.b(c12),.c(d6),.d(d105),.e(d39),.f(d48));  // 6 ins 1 outs level 1

    xor6 x307i (.out(x307),.a(d65),.b(c19),.c(d14),.d(c11),.e(d19),.f(c17));  // 6 ins 1 outs level 1

    xor6 x306i (.out(x306),.a(x299),.b(x48),.c(x69),.d(x44),.e(x42),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x305i (.out(x305),.a(x300),.b(x304),.c(x301),.d(x302),.e(x303),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x304i (.out(x304),.a(d51),.b(d38),.c(d15),.d(c5),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x303i (.out(x303),.a(c1),.b(d90),.c(c7),.d(d11),.e(d16),.f(d32));  // 6 ins 1 outs level 1

    xor6 x302i (.out(x302),.a(d7),.b(d81),.c(d102),.d(c17),.e(d62),.f(c23));  // 6 ins 1 outs level 1

    xor6 x301i (.out(x301),.a(d35),.b(d22),.c(d107),.d(d59),.e(d79),.f(c10));  // 6 ins 1 outs level 1

    xor6 x300i (.out(x300),.a(d29),.b(d47),.c(d45),.d(d95),.e(d103),.f(d106));  // 6 ins 1 outs level 1

    xor6 x299i (.out(x299),.a(c25),.b(c27),.c(d3),.d(c19),.e(c22),.f(d105));  // 6 ins 1 outs level 1

    xor6 x298i (.out(x298),.a(x296),.b(x61),.c(x43),.d(x38),.e(x32),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x297i (.out(x297),.a(x291),.b(x33),.c(x292),.d(x293),.e(x294),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x296i (.out(x296),.a(d12),.b(d30),.c(d59),.d(d50),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x295i (.out(x295),.a(c26),.b(d86),.c(d105),.d(d72),.e(d87),.f(d8));  // 6 ins 1 outs level 1

    xor6 x294i (.out(x294),.a(d34),.b(d66),.c(d52),.d(c18),.e(d106),.f(c27));  // 6 ins 1 outs level 1

    xor6 x293i (.out(x293),.a(d109),.b(c28),.c(d108),.d(c23),.e(d75),.f(c15));  // 6 ins 1 outs level 1

    xor6 x292i (.out(x292),.a(d23),.b(c31),.c(d78),.d(d94),.e(d107),.f(d4));  // 6 ins 1 outs level 1

    xor6 x291i (.out(x291),.a(d70),.b(d14),.c(c6),.d(d17),.e(c29),.f(d39));  // 6 ins 1 outs level 1

    xor6 x290i (.out(x290),.a(x284),.b(d96),.c(x48),.d(x47),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x289i (.out(x289),.a(x285),.b(x288),.c(x32),.d(x60),.e(x286),.f(x287));  // 6 ins 1 outs level 2

    xor6 x288i (.out(x288),.a(d73),.b(d49),.c(d108),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x287i (.out(x287),.a(d107),.b(d99),.c(d26),.d(d91),.e(c11),.f(d95));  // 6 ins 1 outs level 1

    xor6 x286i (.out(x286),.a(d110),.b(d109),.c(d42),.d(d61),.e(d5),.f(c29));  // 6 ins 1 outs level 1

    xor6 x285i (.out(x285),.a(d13),.b(d71),.c(d17),.d(d8),.e(d31),.f(d35));  // 6 ins 1 outs level 1

    xor6 x284i (.out(x284),.a(c28),.b(d97),.c(d62),.d(c25),.e(d24),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x283i (.out(x283),.a(x61),.b(x41),.c(x42),.d(x50),.e(x48),.f(x33));  // 6 ins 1 outs level 2

    xor6 x282i (.out(x282),.a(x277),.b(x35),.c(x278),.d(x279),.e(x280),.f(x281));  // 6 ins 1 outs level 2

    xor6 x281i (.out(x281),.a(d47),.b(d12),.c(c25),.d(d99),.e(d58),.f(d73));  // 6 ins 1 outs level 1

    xor6 x280i (.out(x280),.a(d45),.b(c12),.c(d33),.d(d26),.e(d8),.f(d44));  // 6 ins 1 outs level 1

    xor6 x279i (.out(x279),.a(d90),.b(d61),.c(d48),.d(c13),.e(d93),.f(d34));  // 6 ins 1 outs level 1

    xor6 x278i (.out(x278),.a(d100),.b(d62),.c(c18),.d(d52),.e(c20),.f(d37));  // 6 ins 1 outs level 1

    xor6 x277i (.out(x277),.a(d19),.b(d51),.c(d35),.d(d92),.e(c29),.f(d67));  // 6 ins 1 outs level 1

    xor6 x276i (.out(x276),.a(d94),.b(d41),.c(d18),.d(d59),.e(d74),.f(d27));  // 6 ins 1 outs level 1

    xor6 x275i (.out(x275),.a(x273),.b(x54),.c(x47),.d(x41),.e(x40),.f(x32));  // 6 ins 1 outs level 2

    xor6 x274i (.out(x274),.a(x268),.b(x45),.c(x269),.d(x270),.e(x271),.f(x272));  // 6 ins 1 outs level 2

    xor6 x273i (.out(x273),.a(c6),.b(d60),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x272i (.out(x272),.a(d69),.b(d13),.c(d15),.d(c9),.e(d17),.f(d35));  // 6 ins 1 outs level 1

    xor6 x271i (.out(x271),.a(d73),.b(c13),.c(d46),.d(d87),.e(d105),.f(d93));  // 6 ins 1 outs level 1

    xor6 x270i (.out(x270),.a(d76),.b(d81),.c(d75),.d(d42),.e(c17),.f(c10));  // 6 ins 1 outs level 1

    xor6 x269i (.out(x269),.a(d84),.b(d38),.c(d86),.d(d36),.e(d96),.f(d26));  // 6 ins 1 outs level 1

    xor6 x268i (.out(x268),.a(d110),.b(c23),.c(d85),.d(c29),.e(d16),.f(d89));  // 6 ins 1 outs level 1

    xor6 x267i (.out(x267),.a(d68),.b(d34),.c(d6),.d(d72),.e(c4),.f(d51));  // 6 ins 1 outs level 1

    xor6 x266i (.out(x266),.a(x260),.b(x61),.c(x48),.d(x54),.e(x43),.f(x37));  // 6 ins 1 outs level 2

    xor6 x265i (.out(x265),.a(x261),.b(x40),.c(x32),.d(x264),.e(x262),.f(x263));  // 6 ins 1 outs level 2

    xor6 x264i (.out(x264),.a(d69),.b(d8),.c(c23),.d(d70),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x263i (.out(x263),.a(d41),.b(d20),.c(d17),.d(c30),.e(d85),.f(d61));  // 6 ins 1 outs level 1

    xor6 x262i (.out(x262),.a(d33),.b(d2),.c(d10),.d(d73),.e(d48),.f(c5));  // 6 ins 1 outs level 1

    xor6 x261i (.out(x261),.a(d16),.b(d106),.c(c31),.d(d18),.e(d30),.f(d83));  // 6 ins 1 outs level 1

    xor6 x260i (.out(x260),.a(d37),.b(d43),.c(c3),.d(d66),.e(d35),.f(d63));  // 6 ins 1 outs level 1

    xor6 x259i (.out(x259),.a(x257),.b(x49),.c(x48),.d(x43),.e(x45),.f(x39));  // 6 ins 1 outs level 2

    xor6 x258i (.out(x258),.a(x252),.b(x36),.c(x253),.d(x254),.e(x255),.f(x256));  // 6 ins 1 outs level 2

    xor6 x257i (.out(x257),.a(d15),.b(d64),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x256i (.out(x256),.a(d48),.b(d22),.c(c25),.d(d56),.e(d3),.f(d61));  // 6 ins 1 outs level 1

    xor6 x255i (.out(x255),.a(d36),.b(d18),.c(d99),.d(d43),.e(d76),.f(d95));  // 6 ins 1 outs level 1

    xor6 x254i (.out(x254),.a(d33),.b(c10),.c(c18),.d(d79),.e(d20),.f(d102));  // 6 ins 1 outs level 1

    xor6 x253i (.out(x253),.a(c12),.b(d106),.c(d19),.d(d107),.e(d31),.f(c13));  // 6 ins 1 outs level 1

    xor6 x252i (.out(x252),.a(d105),.b(d71),.c(c22),.d(d69),.e(d74),.f(d37));  // 6 ins 1 outs level 1

    xor6 x251i (.out(x251),.a(d17),.b(d67),.c(c27),.d(d77),.e(d93),.f(d40));  // 6 ins 1 outs level 1

    xor6 x250i (.out(x250),.a(x248),.b(x52),.c(x44),.d(x32),.e(x33),.f(x42));  // 6 ins 1 outs level 2

    xor6 x249i (.out(x249),.a(x243),.b(x45),.c(x244),.d(x245),.e(x246),.f(x247));  // 6 ins 1 outs level 2

    xor6 x248i (.out(x248),.a(d21),.b(d54),.c(c10),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x247i (.out(x247),.a(d26),.b(d104),.c(d98),.d(d0),.e(d61),.f(d2));  // 6 ins 1 outs level 1

    xor6 x246i (.out(x246),.a(d48),.b(c7),.c(d59),.d(d22),.e(d73),.f(c17));  // 6 ins 1 outs level 1

    xor6 x245i (.out(x245),.a(d60),.b(d107),.c(d67),.d(d105),.e(d39),.f(d44));  // 6 ins 1 outs level 1

    xor6 x244i (.out(x244),.a(d18),.b(d3),.c(d76),.d(d10),.e(d19),.f(d38));  // 6 ins 1 outs level 1

    xor6 x243i (.out(x243),.a(d4),.b(d55),.c(c9),.d(d77),.e(c15),.f(d85));  // 6 ins 1 outs level 1

    xor6 x242i (.out(x242),.a(c12),.b(d89),.c(d94),.d(d66),.e(d50),.f(d31));  // 6 ins 1 outs level 1

    xor6 x241i (.out(x241),.a(x234),.b(x44),.c(x57),.d(x54),.e(x40),.f(x38));  // 6 ins 1 outs level 2

    xor6 x240i (.out(x240),.a(x235),.b(x37),.c(x236),.d(x237),.e(x238),.f(x239));  // 6 ins 1 outs level 2

    xor6 x239i (.out(x239),.a(c1),.b(c25),.c(d109),.d(d89),.e(d58),.f(d29));  // 6 ins 1 outs level 1

    xor6 x238i (.out(x238),.a(c16),.b(d67),.c(d106),.d(d42),.e(d21),.f(c17));  // 6 ins 1 outs level 1

    xor6 x237i (.out(x237),.a(c10),.b(d98),.c(d19),.d(d96),.e(c18),.f(d78));  // 6 ins 1 outs level 1

    xor6 x236i (.out(x236),.a(d82),.b(d68),.c(d43),.d(d97),.e(d92),.f(c2));  // 6 ins 1 outs level 1

    xor6 x235i (.out(x235),.a(d53),.b(d26),.c(d85),.d(d48),.e(d20),.f(d45));  // 6 ins 1 outs level 1

    xor6 x234i (.out(x234),.a(d50),.b(d11),.c(c9),.d(d95),.e(d62),.f(d49));  // 6 ins 1 outs level 1

    xor6 x233i (.out(x233),.a(d99),.b(x225),.c(x77),.d(d42),.e(c17),.f(x44));  // 6 ins 1 outs level 2

    xor6 x232i (.out(x232),.a(x226),.b(x38),.c(x227),.d(x228),.e(x229),.f(x230));  // 6 ins 1 outs level 2

    xor6 x230i (.out(x230),.a(d64),.b(d54),.c(c19),.d(d44),.e(d23),.f(d6));  // 6 ins 1 outs level 1

    xor6 x229i (.out(x229),.a(c10),.b(d8),.c(c15),.d(d77),.e(d68),.f(d5));  // 6 ins 1 outs level 1

    xor6 x228i (.out(x228),.a(d57),.b(d24),.c(d51),.d(c29),.e(c30),.f(d43));  // 6 ins 1 outs level 1

    xor6 x227i (.out(x227),.a(d26),.b(d110),.c(d61),.d(d69),.e(c26),.f(d106));  // 6 ins 1 outs level 1

    xor6 x226i (.out(x226),.a(d102),.b(d63),.c(d83),.d(d46),.e(c3),.f(c22));  // 6 ins 1 outs level 1

    xor6 x225i (.out(x225),.a(d109),.b(d22),.c(c31),.d(d107),.e(d59),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x224i (.out(x224),.a(x37),.b(x217),.c(d64),.d(d69),.e(x46),.f(x68));  // 6 ins 1 outs level 2

    xor6 x223i (.out(x223),.a(x218),.b(x44),.c(x39),.d(x219),.e(x220),.f(x221));  // 6 ins 1 outs level 2

    xor6 x221i (.out(x221),.a(d76),.b(d55),.c(c25),.d(d75),.e(c16),.f(d7));  // 6 ins 1 outs level 1

    xor6 x220i (.out(x220),.a(c15),.b(d80),.c(d65),.d(d79),.e(d27),.f(c28));  // 6 ins 1 outs level 1

    xor6 x219i (.out(x219),.a(d100),.b(c0),.c(d63),.d(d26),.e(d96),.f(c20));  // 6 ins 1 outs level 1

    xor6 x218i (.out(x218),.a(d22),.b(d103),.c(d73),.d(d29),.e(d90),.f(d97));  // 6 ins 1 outs level 1

    xor6 x217i (.out(x217),.a(d34),.b(d23),.c(d105),.d(d108),.e(d45),.f(d9));  // 6 ins 1 outs level 1

    xor6 x216i (.out(x216),.a(x208),.b(x47),.c(x214),.d(x35),.e(x42),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x215i (.out(x215),.a(x209),.b(x67),.c(x210),.d(x211),.e(x212),.f(x213));  // 6 ins 1 outs level 2

    xor6 x214i (.out(x214),.a(d30),.b(d66),.c(d8),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x213i (.out(x213),.a(d40),.b(d35),.c(d42),.d(d28),.e(d48),.f(d4));  // 6 ins 1 outs level 1

    xor6 x212i (.out(x212),.a(d46),.b(d109),.c(d70),.d(d95),.e(c13),.f(d93));  // 6 ins 1 outs level 1

    xor6 x211i (.out(x211),.a(d77),.b(d105),.c(d59),.d(d58),.e(d10),.f(d101));  // 6 ins 1 outs level 1

    xor6 x210i (.out(x210),.a(c31),.b(d71),.c(d45),.d(d92),.e(d65),.f(d96));  // 6 ins 1 outs level 1

    xor6 x209i (.out(x209),.a(d14),.b(c1),.c(d26),.d(d81),.e(d43),.f(c24));  // 6 ins 1 outs level 1

    xor6 x208i (.out(x208),.a(d9),.b(d64),.c(c26),.d(c5),.e(c29),.f(c21));  // 6 ins 1 outs level 1

    xor6 x207i (.out(x207),.a(x200),.b(x69),.c(x34),.d(x60),.e(x35),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x206i (.out(x206),.a(x201),.b(x44),.c(x202),.d(x203),.e(x204),.f(x205));  // 6 ins 1 outs level 2

    xor6 x205i (.out(x205),.a(d67),.b(d64),.c(d30),.d(d46),.e(d94),.f(c2));  // 6 ins 1 outs level 1

    xor6 x204i (.out(x204),.a(d65),.b(d72),.c(d81),.d(d66),.e(d109),.f(c17));  // 6 ins 1 outs level 1

    xor6 x203i (.out(x203),.a(d44),.b(d84),.c(d11),.d(c1),.e(d15),.f(d8));  // 6 ins 1 outs level 1

    xor6 x202i (.out(x202),.a(d43),.b(d59),.c(d98),.d(d31),.e(d57),.f(c29));  // 6 ins 1 outs level 1

    xor6 x201i (.out(x201),.a(d5),.b(d82),.c(d105),.d(d103),.e(c6),.f(c30));  // 6 ins 1 outs level 1

    xor6 x200i (.out(x200),.a(d36),.b(c4),.c(d45),.d(d86),.e(c23),.f(d20));  // 6 ins 1 outs level 1

    xor6 x199i (.out(x199),.a(x196),.b(x33),.c(x39),.d(x40),.e(x41),.f(x197));  // 6 ins 1 outs level 2

    xor6 x198i (.out(x198),.a(x193),.b(x36),.c(x47),.d(x35),.e(x194),.f(x195));  // 6 ins 1 outs level 2

    xor6 x197i (.out(x197),.a(d30),.b(d67),.c(d12),.d(c7),.e(d72),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x196i (.out(x196),.a(d51),.b(d0),.c(d54),.d(c16),.e(d87),.f(d103));  // 6 ins 1 outs level 1

    xor6 x195i (.out(x195),.a(d73),.b(d81),.c(d26),.d(d105),.e(c19),.f(d61));  // 6 ins 1 outs level 1

    xor6 x194i (.out(x194),.a(d48),.b(c31),.c(d53),.d(c26),.e(d79),.f(d85));  // 6 ins 1 outs level 1

    xor6 x193i (.out(x193),.a(c24),.b(c1),.c(c27),.d(d45),.e(c25),.f(d25));  // 6 ins 1 outs level 1

    xor6 x192i (.out(x192),.a(d7),.b(d95),.c(c23),.d(d59),.e(d63),.f(d2));  // 6 ins 1 outs level 1

    xor6 x191i (.out(x191),.a(x52),.b(x185),.c(x32),.d(x49),.e(x47),.f(x45));  // 6 ins 1 outs level 2

    xor6 x190i (.out(x190),.a(x186),.b(d64),.c(x37),.d(x187),.e(x188),.f(x189));  // 6 ins 1 outs level 2

    xor6 x189i (.out(x189),.a(d46),.b(d72),.c(d20),.d(c18),.e(d38),.f(d1));  // 6 ins 1 outs level 1

    xor6 x188i (.out(x188),.a(d51),.b(d11),.c(d92),.d(d58),.e(d44),.f(c23));  // 6 ins 1 outs level 1

    xor6 x187i (.out(x187),.a(d103),.b(d10),.c(d107),.d(c24),.e(d12),.f(d7));  // 6 ins 1 outs level 1

    xor6 x186i (.out(x186),.a(d16),.b(d74),.c(c16),.d(d65),.e(c1),.f(d59));  // 6 ins 1 outs level 1

    xor6 x185i (.out(x185),.a(d81),.b(d63),.c(d0),.d(d33),.e(d52),.f(d87));  // 6 ins 1 outs level 1

    xor6 x184i (.out(x184),.a(x52),.b(x40),.c(x39),.d(x41),.e(x42),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x183i (.out(x183),.a(x178),.b(x179),.c(x180),.d(x181),.e(x182),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x182i (.out(x182),.a(d30),.b(d51),.c(d88),.d(d64),.e(d18),.f(d14));  // 6 ins 1 outs level 1

    xor6 x181i (.out(x181),.a(d23),.b(d79),.c(d36),.d(d0),.e(c18),.f(d38));  // 6 ins 1 outs level 1

    xor6 x180i (.out(x180),.a(d107),.b(d70),.c(d111),.d(d72),.e(d57),.f(c27));  // 6 ins 1 outs level 1

    xor6 x179i (.out(x179),.a(c14),.b(c8),.c(d37),.d(d110),.e(d1),.f(d26));  // 6 ins 1 outs level 1

    xor6 x178i (.out(x178),.a(c3),.b(d83),.c(d98),.d(d87),.e(d80),.f(d55));  // 6 ins 1 outs level 1

    xor6 x177i (.out(x177),.a(d65),.b(c0),.c(d67),.d(d39),.e(d75),.f(d16));  // 6 ins 1 outs level 1

    xor6 x176i (.out(x176),.a(d10),.b(c31),.c(x48),.d(x61),.e(x39),.f(c1));  // 6 ins 1 outs level 2

    xor6 x175i (.out(x175),.a(x169),.b(x41),.c(x170),.d(x171),.e(x172),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x173i (.out(x173),.a(c29),.b(c18),.c(d40),.d(d71),.e(d45),.f(d39));  // 6 ins 1 outs level 1

    xor6 x172i (.out(x172),.a(d76),.b(d9),.c(c15),.d(d17),.e(d15),.f(d37));  // 6 ins 1 outs level 1

    xor6 x171i (.out(x171),.a(d73),.b(d38),.c(d100),.d(c23),.e(d60),.f(d52));  // 6 ins 1 outs level 1

    xor6 x170i (.out(x170),.a(c20),.b(d18),.c(d95),.d(c6),.e(d86),.f(d1));  // 6 ins 1 outs level 1

    xor6 x169i (.out(x169),.a(d44),.b(d25),.c(d109),.d(d81),.e(d3),.f(d69));  // 6 ins 1 outs level 1

    xor6 x168i (.out(x168),.a(d98),.b(c28),.c(d108),.d(d87),.e(d90),.f(d85));  // 6 ins 1 outs level 1

    xor6 x167i (.out(x167),.a(x160),.b(x46),.c(x50),.d(x41),.e(x39),.f(x165));  // 6 ins 1 outs level 2

    xor6 x166i (.out(x166),.a(x161),.b(d15),.c(x38),.d(x162),.e(x163),.f(x164));  // 6 ins 1 outs level 2

    xor6 x165i (.out(x165),.a(d19),.b(d38),.c(d79),.d(d8),.e(d100),.f(d48));  // 6 ins 1 outs level 1

    xor6 x164i (.out(x164),.a(d50),.b(d45),.c(d4),.d(c14),.e(c20),.f(c5));  // 6 ins 1 outs level 1

    xor6 x163i (.out(x163),.a(d95),.b(d77),.c(c17),.d(d11),.e(c10),.f(d12));  // 6 ins 1 outs level 1

    xor6 x162i (.out(x162),.a(d25),.b(d41),.c(d30),.d(c1),.e(d40),.f(c29));  // 6 ins 1 outs level 1

    xor6 x161i (.out(x161),.a(d111),.b(d33),.c(d29),.d(d67),.e(d20),.f(d46));  // 6 ins 1 outs level 1

    xor6 x160i (.out(x160),.a(d107),.b(d63),.c(d24),.d(d47),.e(d74),.f(d39));  // 6 ins 1 outs level 1

    xor6 x159i (.out(x159),.a(x152),.b(x60),.c(x54),.d(x46),.e(x38),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x158i (.out(x158),.a(x153),.b(x43),.c(x154),.d(x155),.e(x156),.f(x157));  // 6 ins 1 outs level 2

    xor6 x157i (.out(x157),.a(d83),.b(d67),.c(c3),.d(d90),.e(d97),.f(d76));  // 6 ins 1 outs level 1

    xor6 x156i (.out(x156),.a(d6),.b(d29),.c(d80),.d(d59),.e(d42),.f(d69));  // 6 ins 1 outs level 1

    xor6 x155i (.out(x155),.a(d71),.b(d92),.c(c14),.d(d34),.e(d82),.f(d4));  // 6 ins 1 outs level 1

    xor6 x154i (.out(x154),.a(d5),.b(d46),.c(d51),.d(d24),.e(d103),.f(c0));  // 6 ins 1 outs level 1

    xor6 x153i (.out(x153),.a(d78),.b(d50),.c(d72),.d(d0),.e(d20),.f(d44));  // 6 ins 1 outs level 1

    xor6 x152i (.out(x152),.a(d49),.b(d13),.c(c2),.d(d32),.e(d64),.f(d65));  // 6 ins 1 outs level 1

    xor6 x151i (.out(x151),.a(x45),.b(x144),.c(x69),.d(x33),.e(x32),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x150i (.out(x150),.a(x145),.b(x44),.c(x149),.d(x146),.e(x147),.f(x148));  // 6 ins 1 outs level 2

    xor6 x149i (.out(x149),.a(d30),.b(d7),.c(d84),.d(d66),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x148i (.out(x148),.a(c1),.b(d107),.c(d108),.d(d72),.e(d6),.f(d79));  // 6 ins 1 outs level 1

    xor6 x147i (.out(x147),.a(d70),.b(c24),.c(d50),.d(d8),.e(c4),.f(d5));  // 6 ins 1 outs level 1

    xor6 x146i (.out(x146),.a(d39),.b(d78),.c(d73),.d(d47),.e(d64),.f(d68));  // 6 ins 1 outs level 1

    xor6 x145i (.out(x145),.a(d65),.b(c18),.c(c12),.d(c0),.e(d80),.f(d28));  // 6 ins 1 outs level 1

    xor6 x144i (.out(x144),.a(d4),.b(d40),.c(d49),.d(d14),.e(c28),.f(d22));  // 6 ins 1 outs level 1

    xor6 x143i (.out(x143),.a(x136),.b(x69),.c(x34),.d(x57),.e(x60),.f(x40));  // 6 ins 1 outs level 2

    xor6 x142i (.out(x142),.a(x137),.b(x44),.c(x141),.d(x138),.e(x139),.f(x140));  // 6 ins 1 outs level 2

    xor6 x141i (.out(x141),.a(d46),.b(d74),.c(d39),.d(d99),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x140i (.out(x140),.a(d76),.b(c7),.c(c31),.d(d15),.e(d51),.f(d87));  // 6 ins 1 outs level 1

    xor6 x139i (.out(x139),.a(d69),.b(d104),.c(d68),.d(d58),.e(d8),.f(d81));  // 6 ins 1 outs level 1

    xor6 x138i (.out(x138),.a(d43),.b(d16),.c(c23),.d(d3),.e(d4),.f(d85));  // 6 ins 1 outs level 1

    xor6 x137i (.out(x137),.a(d98),.b(c24),.c(d22),.d(d27),.e(c30),.f(d52));  // 6 ins 1 outs level 1

    xor6 x136i (.out(x136),.a(c15),.b(d56),.c(d105),.d(d92),.e(d79),.f(c26));  // 6 ins 1 outs level 1

    xor6 x135i (.out(x135),.a(x57),.b(x37),.c(x60),.d(x46),.e(x45),.f(x50));  // 6 ins 1 outs level 2

    xor6 x134i (.out(x134),.a(x128),.b(x133),.c(x129),.d(x130),.e(x131),.f(x132));  // 6 ins 1 outs level 2

    xor6 x133i (.out(x133),.a(d80),.b(c2),.c(d1),.d(c24),.e(d106),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x132i (.out(x132),.a(d42),.b(d66),.c(d76),.d(d97),.e(d32),.f(d82));  // 6 ins 1 outs level 1

    xor6 x131i (.out(x131),.a(d40),.b(d22),.c(c25),.d(d95),.e(d17),.f(d5));  // 6 ins 1 outs level 1

    xor6 x130i (.out(x130),.a(c17),.b(d45),.c(d35),.d(d51),.e(d54),.f(d75));  // 6 ins 1 outs level 1

    xor6 x129i (.out(x129),.a(d85),.b(d67),.c(d46),.d(d69),.e(d84),.f(d87));  // 6 ins 1 outs level 1

    xor6 x128i (.out(x128),.a(d8),.b(c0),.c(c4),.d(d63),.e(d28),.f(d12));  // 6 ins 1 outs level 1

    xor6 x127i (.out(x127),.a(x120),.b(x35),.c(x39),.d(x49),.e(x47),.f(x54));  // 6 ins 1 outs level 2

    xor6 x126i (.out(x126),.a(x121),.b(x57),.c(x125),.d(x122),.e(x123),.f(x124));  // 6 ins 1 outs level 2

    xor6 x125i (.out(x125),.a(d46),.b(d32),.c(c1),.d(d51),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x124i (.out(x124),.a(d61),.b(c9),.c(d110),.d(d36),.e(d66),.f(d80));  // 6 ins 1 outs level 1

    xor6 x123i (.out(x123),.a(c18),.b(d41),.c(d81),.d(d70),.e(d13),.f(d71));  // 6 ins 1 outs level 1

    xor6 x122i (.out(x122),.a(d60),.b(d35),.c(c0),.d(d12),.e(d67),.f(c5));  // 6 ins 1 outs level 1

    xor6 x121i (.out(x121),.a(d33),.b(d64),.c(d89),.d(d34),.e(d47),.f(d96));  // 6 ins 1 outs level 1

    xor6 x120i (.out(x120),.a(c15),.b(d104),.c(c7),.d(d98),.e(c29),.f(d68));  // 6 ins 1 outs level 1

    xor6 x119i (.out(x119),.a(x57),.b(x112),.c(x61),.d(x68),.e(x36),.f(x35));  // 6 ins 1 outs level 2

    xor6 x118i (.out(x118),.a(x113),.b(x43),.c(x117),.d(x114),.e(x115),.f(x116));  // 6 ins 1 outs level 2

    xor6 x117i (.out(x117),.a(d80),.b(c12),.c(d39),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x116i (.out(x116),.a(c9),.b(c16),.c(d89),.d(d95),.e(d63),.f(d94));  // 6 ins 1 outs level 1

    xor6 x115i (.out(x115),.a(d59),.b(d28),.c(d40),.d(d19),.e(d47),.f(d26));  // 6 ins 1 outs level 1

    xor6 x114i (.out(x114),.a(d35),.b(d98),.c(d90),.d(d0),.e(d109),.f(d71));  // 6 ins 1 outs level 1

    xor6 x113i (.out(x113),.a(c30),.b(d56),.c(c23),.d(c24),.e(d75),.f(c0));  // 6 ins 1 outs level 1

    xor6 x112i (.out(x112),.a(d106),.b(d32),.c(d4),.d(d58),.e(d96),.f(d103));  // 6 ins 1 outs level 1

    xor6 x111i (.out(x111),.a(x61),.b(x36),.c(x42),.d(x41),.e(x69),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x110i (.out(x110),.a(x105),.b(x33),.c(x109),.d(x106),.e(x107),.f(x108));  // 6 ins 1 outs level 2

    xor6 x109i (.out(x109),.a(d58),.b(d44),.c(c11),.d(d0),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x108i (.out(x108),.a(d23),.b(d83),.c(d91),.d(d94),.e(d110),.f(c3));  // 6 ins 1 outs level 1

    xor6 x107i (.out(x107),.a(d20),.b(d40),.c(d25),.d(d15),.e(d90),.f(d12));  // 6 ins 1 outs level 1

    xor6 x106i (.out(x106),.a(d64),.b(d26),.c(d48),.d(d17),.e(d102),.f(d28));  // 6 ins 1 outs level 1

    xor6 x105i (.out(x105),.a(d4),.b(d57),.c(d43),.d(c27),.e(d1),.f(d74));  // 6 ins 1 outs level 1

    xor6 x104i (.out(x104),.a(d41),.b(d76),.c(c22),.d(d27),.e(d78),.f(c24));  // 6 ins 1 outs level 1

    xor6 x103i (.out(x103),.a(x97),.b(x69),.c(x67),.d(x49),.e(x43),.f(x37));  // 6 ins 1 outs level 2

    xor6 x102i (.out(x102),.a(x98),.b(x57),.c(x101),.d(x42),.e(x99),.f(x100));  // 6 ins 1 outs level 2

    xor6 x101i (.out(x101),.a(d30),.b(d12),.c(d65),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x100i (.out(x100),.a(d27),.b(d104),.c(d28),.d(d73),.e(d46),.f(d0));  // 6 ins 1 outs level 1

    xor6 x99i (.out(x99),.a(d87),.b(c17),.c(d90),.d(d42),.e(d23),.f(c12));  // 6 ins 1 outs level 1

    xor6 x98i (.out(x98),.a(d78),.b(d49),.c(c19),.d(d1),.e(d15),.f(d109));  // 6 ins 1 outs level 1

    xor6 x97i (.out(x97),.a(d74),.b(d45),.c(d2),.d(d35),.e(d18),.f(c7));  // 6 ins 1 outs level 1

    xor6 x96i (.out(x96),.a(x54),.b(x36),.c(x50),.d(x49),.e(x34),.f(x44));  // 6 ins 1 outs level 2

    xor6 x95i (.out(x95),.a(x89),.b(x94),.c(x90),.d(x91),.e(x92),.f(x93));  // 6 ins 1 outs level 2

    xor6 x94i (.out(x94),.a(d64),.b(c25),.c(c31),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x93i (.out(x93),.a(c8),.b(c7),.c(d92),.d(d42),.e(d5),.f(d28));  // 6 ins 1 outs level 1

    xor6 x92i (.out(x92),.a(d39),.b(d97),.c(d6),.d(d72),.e(d43),.f(d75));  // 6 ins 1 outs level 1

    xor6 x91i (.out(x91),.a(c19),.b(d10),.c(d3),.d(d102),.e(d16),.f(d22));  // 6 ins 1 outs level 1

    xor6 x90i (.out(x90),.a(d60),.b(d87),.c(d48),.d(d70),.e(c22),.f(d2));  // 6 ins 1 outs level 1

    xor6 x89i (.out(x89),.a(d14),.b(d88),.c(c29),.d(d58),.e(c23),.f(d0));  // 6 ins 1 outs level 1

    xor6 x88i (.out(x88),.a(c13),.b(x45),.c(x39),.d(x48),.e(x34),.f(d62));  // 6 ins 1 outs level 2

    xor6 x87i (.out(x87),.a(x81),.b(x46),.c(x82),.d(x83),.e(x84),.f(x85));  // 6 ins 1 outs level 2

    xor6 x85i (.out(x85),.a(d93),.b(d63),.c(d104),.d(d96),.e(c30),.f(d38));  // 6 ins 1 outs level 1

    xor6 x84i (.out(x84),.a(d75),.b(d103),.c(d26),.d(d23),.e(d61),.f(d65));  // 6 ins 1 outs level 1

    xor6 x83i (.out(x83),.a(d55),.b(d76),.c(d6),.d(d94),.e(d17),.f(c27));  // 6 ins 1 outs level 1

    xor6 x82i (.out(x82),.a(d110),.b(d48),.c(c17),.d(c18),.e(c15),.f(d15));  // 6 ins 1 outs level 1

    xor6 x81i (.out(x81),.a(d4),.b(d77),.c(d59),.d(c31),.e(d56),.f(c16));  // 6 ins 1 outs level 1

    xor6 x80i (.out(x80),.a(d14),.b(d33),.c(d51),.d(c14),.e(d71),.f(d98));  // 6 ins 1 outs level 1

    xor6 x79i (.out(x79),.a(x71),.b(x57),.c(x48),.d(x42),.e(x45),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x78i (.out(x78),.a(x72),.b(x73),.c(x74),.d(x75),.e(x76),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x77i (.out(x77),.a(d30),.b(d12),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 2 outs level 1

    xor6 x76i (.out(x76),.a(d15),.b(c24),.c(c8),.d(d84),.e(d59),.f(d64));  // 6 ins 1 outs level 1

    xor6 x75i (.out(x75),.a(d18),.b(c29),.c(d71),.d(d34),.e(c31),.f(d50));  // 6 ins 1 outs level 1

    xor6 x74i (.out(x74),.a(c10),.b(d44),.c(d19),.d(d45),.e(d95),.f(d52));  // 6 ins 1 outs level 1

    xor6 x73i (.out(x73),.a(d57),.b(d74),.c(c5),.d(d94),.e(d104),.f(d76));  // 6 ins 1 outs level 1

    xor6 x72i (.out(x72),.a(c4),.b(d87),.c(d23),.d(d21),.e(d3),.f(d32));  // 6 ins 1 outs level 1

    xor6 x71i (.out(x71),.a(d33),.b(d88),.c(d90),.d(c25),.e(c15),.f(d72));  // 6 ins 1 outs level 1

    xor6 x70i (.out(x70),.a(d59),.b(d48),.c(x44),.d(d61),.e(d26),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x69i (.out(x69),.a(d60),.b(d54),.c(d56),.d(d45),.e(d71),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x68i (.out(x68),.a(c12),.b(d104),.c(d62),.d(d31),.e(d13),.f(1'b0));  // 5 ins 4 outs level 1

    xor6 x67i (.out(x67),.a(d63),.b(c26),.c(d61),.d(c19),.e(1'b0),.f(1'b0));  // 4 ins 4 outs level 1

    xor6 x66i (.out(x66),.a(d96),.b(x47),.c(d35),.d(d17),.e(d13),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x65i (.out(x65),.a(x60),.b(d96),.c(x47),.d(d28),.e(d24),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x64i (.out(x64),.a(c14),.b(d105),.c(d22),.d(x33),.e(d98),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x63i (.out(x63),.a(d18),.b(d92),.c(d106),.d(c30),.e(x35),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x62i (.out(x62),.a(d92),.b(d2),.c(x43),.d(d42),.e(c27),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x61i (.out(x61),.a(d33),.b(d36),.c(d103),.d(c10),.e(d14),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x60i (.out(x60),.a(d37),.b(d10),.c(d34),.d(d106),.e(c27),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x59i (.out(x59),.a(c14),.b(d23),.c(x45),.d(d33),.e(d50),.f(1'b0));  // 5 ins 5 outs level 2

    xor6 x58i (.out(x58),.a(d19),.b(x40),.c(x34),.d(d54),.e(d53),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x57i (.out(x57),.a(c29),.b(d78),.c(d5),.d(d77),.e(d4),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x56i (.out(x56),.a(d57),.b(x36),.c(x33),.d(x38),.e(d111),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x55i (.out(x55),.a(d11),.b(d38),.c(d43),.d(x35),.e(x32),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x54i (.out(x54),.a(d76),.b(d39),.c(d74),.d(d55),.e(d1),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x53i (.out(x53),.a(d9),.b(d66),.c(d16),.d(x37),.e(d55),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x52i (.out(x52),.a(c30),.b(d6),.c(d97),.d(d94),.e(d52),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x51i (.out(x51),.a(d40),.b(d94),.c(x34),.d(c12),.e(d79),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x50i (.out(x50),.a(d103),.b(d57),.c(d0),.d(d29),.e(d109),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x49i (.out(x49),.a(d69),.b(c6),.c(d92),.d(c26),.e(d86),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x48i (.out(x48),.a(c19),.b(d8),.c(d89),.d(d87),.e(c9),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x47i (.out(x47),.a(c22),.b(d53),.c(c16),.d(d9),.e(d102),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x46i (.out(x46),.a(d3),.b(d73),.c(d70),.d(d107),.e(c23),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x45i (.out(x45),.a(c20),.b(d62),.c(d20),.d(d100),.e(d49),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x44i (.out(x44),.a(d25),.b(d78),.c(d93),.d(c13),.e(d95),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x43i (.out(x43),.a(d21),.b(d75),.c(d81),.d(d41),.e(d28),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x42i (.out(x42),.a(d108),.b(d23),.c(d24),.d(d85),.e(c28),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x41i (.out(x41),.a(c5),.b(d59),.c(d31),.d(d65),.e(d68),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x40i (.out(x40),.a(d111),.b(d7),.c(d99),.d(c17),.e(d32),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x39i (.out(x39),.a(c4),.b(d44),.c(d58),.d(d2),.e(d84),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x38i (.out(x38),.a(d90),.b(c11),.c(c1),.d(c31),.e(d91),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x37i (.out(x37),.a(c21),.b(d101),.c(c14),.d(d60),.e(d105),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x36i (.out(x36),.a(c18),.b(c25),.c(d47),.d(d110),.e(d50),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x35i (.out(x35),.a(c3),.b(d29),.c(d83),.d(c15),.e(d52),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x34i (.out(x34),.a(c0),.b(d27),.c(d56),.d(d97),.e(d80),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x33i (.out(x33),.a(d82),.b(d98),.c(d51),.d(d104),.e(c2),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x32i (.out(x32),.a(d79),.b(d88),.c(c7),.d(c8),.e(c24),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x15i (.out(x15),.a(x78),.b(x58),.c(x77),.d(x53),.e(x79),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x14i (.out(x14),.a(x80),.b(x55),.c(x58),.d(x87),.e(x88),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x13i (.out(x13),.a(x95),.b(x68),.c(x33),.d(x63),.e(x58),.f(x96));  // 6 ins 1 outs level 3

    xor6 x12i (.out(x12),.a(x102),.b(x52),.c(x41),.d(x66),.e(x56),.f(x103));  // 6 ins 1 outs level 3

    xor6 x11i (.out(x11),.a(x104),.b(x46),.c(x53),.d(x111),.e(x110),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x10i (.out(x10),.a(x118),.b(x62),.c(x46),.d(x49),.e(x53),.f(x119));  // 6 ins 1 outs level 3

    xor6 x9i (.out(x9),.a(x126),.b(x42),.c(x63),.d(x55),.e(x127),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x8i (.out(x8),.a(x134),.b(x41),.c(x59),.d(x55),.e(x135),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x7i (.out(x7),.a(x142),.b(x36),.c(x42),.d(x50),.e(x62),.f(x143));  // 6 ins 1 outs level 3

    xor6 x6i (.out(x6),.a(x150),.b(x54),.c(x55),.d(x62),.e(x151),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x5i (.out(x5),.a(x158),.b(x67),.c(x58),.d(x51),.e(x159),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x4i (.out(x4),.a(x166),.b(x49),.c(x52),.d(x63),.e(x167),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x3i (.out(x3),.a(x168),.b(x58),.c(x175),.d(x173),.e(x176),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x2i (.out(x2),.a(x177),.b(x48),.c(x66),.d(x183),.e(x184),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x1i (.out(x1),.a(x190),.b(x34),.c(x36),.d(x66),.e(x65),.f(x191));  // 6 ins 1 outs level 3

    xor6 x0i (.out(x0),.a(x192),.b(x52),.c(x53),.d(x65),.e(x198),.f(x199));  // 6 ins 1 outs level 3

    xor6 x31i (.out(x31),.a(x206),.b(x36),.c(x65),.d(x59),.e(x207),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x30i (.out(x30),.a(x215),.b(x40),.c(x64),.d(x51),.e(x216),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x29i (.out(x29),.a(x223),.b(x52),.c(x62),.d(x56),.e(x224),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x28i (.out(x28),.a(x232),.b(x62),.c(x59),.d(x51),.e(x233),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x27i (.out(x27),.a(x240),.b(x67),.c(x42),.d(x51),.e(x241),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x26i (.out(x26),.a(x242),.b(x56),.c(x62),.d(x249),.e(x250),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x25i (.out(x25),.a(x251),.b(x55),.c(x56),.d(x258),.e(x259),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x24i (.out(x24),.a(x265),.b(x49),.c(x56),.d(x51),.e(x266),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x23i (.out(x23),.a(x267),.b(x50),.c(x56),.d(x58),.e(x274),.f(x275));  // 6 ins 1 outs level 3

    xor6 x22i (.out(x22),.a(x276),.b(x53),.c(x55),.d(x282),.e(x283),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x21i (.out(x21),.a(x289),.b(x64),.c(x63),.d(x51),.e(x290),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x20i (.out(x20),.a(x70),.b(x53),.c(x298),.d(x297),.e(x295),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x19i (.out(x19),.a(x305),.b(x49),.c(x59),.d(x51),.e(x306),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x18i (.out(x18),.a(x314),.b(d101),.c(d15),.d(x39),.e(x65),.f(x315));  // 6 ins 1 outs level 3

    xor6 x17i (.out(x17),.a(x316),.b(x59),.c(x56),.d(x322),.e(x323),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x16i (.out(x16),.a(x330),.b(x48),.c(x64),.d(x331),.e(x332),.f(1'b0));  // 5 ins 1 outs level 3

endmodule

