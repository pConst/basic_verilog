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

//// CRC-32 of 128 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000000000000000000000000000 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111
//        00000000001111111111222222222233 00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222
//        01234567890123456789012345678901 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//
// C00  = XXXX.X.XX.X...XX.XX.XXXX...X.XXX X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X.XXX
// C01  = ....XXXX.XXX..X.XX.XX...X..XXX.. XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..X.XXX.XXXX...X..X.X....XXX....XXX.....X.....XXXX.XXX..X.XX.XX...X..XXX..
// C02  = XXXX..X....XX.X.......XX.X.XX..X XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X.XXXX..X....XX.X.......XX.X.XX..X
// C03  = .XXXX..X....XX.X.......XX.X.XX.. .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X.XXXX..X....XX.X.......XX.X.XX..
// C04  = .X..X..X..X..X.XXXX.XXXXXX.....X X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X......XXX...X.X.XXXX..XX..X.X...XX.X...XX..XX.X..X..X..X..X.XXXX.XXXXXX.....X
// C05  = .X.X...X..XX...XX..XX...XXXX.XXX XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X..X.X...X..XX...XX..XX...XXXX.XXX
// C06  = ..X.X...X..XX...XX..XX...XXXX.XX .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X..X.X...X..XX...XX..XX...XXXX.XX
// C07  = .XX....XXXX.XXXX....X..X..X.X.X. X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.XXX.X.......XX.X..XXXX.XX......X.....X.X.XX....XXXX.XXXX....X..X..X.X.X.
// C08  = .X...X.X.X.X.X..XXX.X.XXX.....X. XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......X.X...X.X.X.X.X..XXX.X.XXX.....X.
// C09  = X.X...X.X.X.X.X..XXX.X.XXX.....X .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......X.X...X.X.X.X.X..XXX.X.XXX.....X
// C10  = X.X..X..XXXX.XX..X.X.X.XXXXX.XXX X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..XX.XXX.XX..X..XXX.X.X.XX.X..X..X..XX...XXX.X..X..XXXX.XX..X.X.X.XXXXX.XXX
// C11  = ..X..XXXXX.XX....X...X.XXXX.XX.. XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XXXXXX....XXX.X.XX.XX.X.X...XX.X....XX..X...X..XXXXX.XX....X...X.XXXX.XX..
// C12  = XXX..XX..X..XXXX.X..XX.XXXX....X XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXXX.X..XX.XXXX....X
// C13  = .XXX..XX..X..XXXX.X..XX.XXXX.... .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXXX.X..XX.XXXX....
// C14  = X.XXX..XX..X..XXXX.X..XX.XXXX... ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXXX.X..XX.XXXX...
// C15  = .X.XXX..XX..X..XXXX.X..XX.XXXX.. ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXXX.X..XX.XXXX..
// C16  = .X.XX.XXXX...XXXX..XX.XXXX..X..X X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX.XXXX..X..X
// C17  = ..X.XX.XXXX...XXXX..XX.XXXX..X.. .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX.XXXX..X..
// C18  = X..X.XX.XXXX...XXXX..XX.XXXX..X. ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX.XXXX..X.
// C19  = .X..X.XX.XXXX...XXXX..XX.XXXX..X ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX.XXXX..X
// C20  = ..X..X.XX.XXXX...XXXX..XX.XXXX.. ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX.XXXX..
// C21  = X..X..X.XX.XXXX...XXXX..XX.XXXX. .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX.XXXX.
// C22  = ..XXXX..XX..XX...XXX...X.XXXX... X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X.XX.XXX..XXXX....XX....X..X..X.XXXX.XXX...XXXX..XX..XX...XXX...X.XXXX...
// C23  = XXX.X.XXXX...X.X.X.X.XXXX.X.X.XX XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XXXX...X.X.X.X.XXXX.X.X.XX
// C24  = .XXX.X.XXXX...X.X.X.X.XXXX.X.X.X .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XXXX...X.X.X.X.XXXX.X.X.X
// C25  = ..XXX.X.XXXX...X.X.X.X.XXXX.X.X. ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XXXX...X.X.X.X.XXXX.X.X.
// C26  = .XX.X...XX.XX.XXXX...X.XXXX...X. X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X.XXXX...X.
// C27  = X.XX.X...XX.XX.XXXX...X.XXXX...X .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X.XXXX...X
// C28  = .X.XX.X...XX.XX.XXXX...X.XXXX... ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X.XXXX...
// C29  = X.X.XX.X...XX.XX.XXXX...X.XXXX.. ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X.XXXX..
// C30  = XX.X.XX.X...XX.XX.XXXX...X.XXXX. ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X.XXXX.
// C31  = XXX.X.XX.X...XX.XX.XXXX...X.XXXX .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X.XXXX
//
module crc32_dat128 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [127:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat128_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat128_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat128_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [127:0] dat_in;
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
    d95,d96,d97,d98,d99,d100,d101,d102,d103,d104,d105,d106,d107,d108,d109,d110,
    d111,d112,d113,d114,d115,d116,d117,d118,d119,d120,d121,d122,d123,d124,d125,d126,
    d127;

assign { d127,d126,d125,d124,d123,d122,d121,d120,d119,d118,d117,d116,d115,d114,d113,
        d112,d111,d110,d109,d108,d107,d106,d105,d104,d103,d102,d101,d100,d99,d98,d97,
        d96,d95,d94,d93,d92,d91,d90,d89,d88,d87,d86,d85,d84,d83,d82,d81,
        d80,d79,d78,d77,d76,d75,d74,d73,d72,d71,d70,d69,d68,d67,d66,d65,
        d64,d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [127:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x31 = d80 ^ c13 ^ d122 ^ d59 ^ d127 ^ c20 ^ d112 ^ d60 ^ c7 ^ 
        d5 ^ d65 ^ c26 ^ d93 ^ d11 ^ c30 ^ d9 ^ d66 ^ d24 ^ c21 ^ 
        d94 ^ c22 ^ d95 ^ d25 ^ c9 ^ c16 ^ c2 ^ d125 ^ c14 ^ d36 ^ 
        c29 ^ d124 ^ d43 ^ d44 ^ d102 ^ c17 ^ c19 ^ d86 ^ d71 ^ d84 ^ 
        d49 ^ d64 ^ c31 ^ d29 ^ d47 ^ d8 ^ c0 ^ d72 ^ d52 ^ d116 ^ 
        d62 ^ c6 ^ d31 ^ d23 ^ d103 ^ d83 ^ d57 ^ d82 ^ d67 ^ d117 ^ 
        d109 ^ d46 ^ d126 ^ c28 ^ d54 ^ d115 ^ d98 ^ d113 ^ d97 ^ d15 ^ 
        d118 ^ d33 ^ d100 ^ d53 ^ d28 ^ c1 ^ d96 ^ d81 ^ c4 ^ d30 ^ 
        d78 ^ d105 ^ d27 ^ d110;  // 83 ins 1 outs level 3

    assign x30 = d29 ^ c15 ^ c28 ^ d64 ^ d94 ^ c19 ^ d101 ^ c6 ^ d53 ^ 
        c27 ^ d114 ^ c18 ^ d112 ^ d71 ^ d52 ^ d63 ^ d61 ^ c20 ^ d80 ^ 
        d124 ^ d42 ^ c0 ^ d56 ^ d23 ^ c13 ^ d10 ^ d109 ^ d81 ^ c16 ^ 
        d79 ^ d123 ^ d95 ^ d92 ^ d121 ^ c12 ^ d111 ^ d65 ^ c3 ^ d116 ^ 
        d117 ^ d43 ^ d59 ^ c30 ^ c21 ^ d85 ^ d96 ^ d108 ^ d30 ^ d14 ^ 
        d27 ^ d93 ^ d22 ^ d66 ^ d104 ^ d35 ^ d70 ^ c1 ^ d102 ^ d24 ^ 
        d99 ^ c5 ^ d8 ^ d126 ^ d46 ^ d32 ^ d115 ^ d77 ^ d82 ^ d28 ^ 
        c8 ^ c29 ^ d4 ^ d125 ^ d51 ^ d83 ^ d26 ^ d97 ^ d58 ^ d48 ^ 
        c25 ^ d7 ^ d45;  // 82 ins 1 outs level 3

    assign x29 = c4 ^ c20 ^ d29 ^ d3 ^ d82 ^ d107 ^ d57 ^ c7 ^ d27 ^ 
        d100 ^ d9 ^ d114 ^ d81 ^ d21 ^ d110 ^ d116 ^ d103 ^ c14 ^ d101 ^ 
        d70 ^ d98 ^ d120 ^ d42 ^ c19 ^ d80 ^ d7 ^ d108 ^ d58 ^ d45 ^ 
        d125 ^ d123 ^ d63 ^ c29 ^ c17 ^ d76 ^ d115 ^ d84 ^ d64 ^ d47 ^ 
        d113 ^ c0 ^ d31 ^ c28 ^ d96 ^ d34 ^ d94 ^ c2 ^ c15 ^ d69 ^ 
        d111 ^ d25 ^ d122 ^ d50 ^ c24 ^ d93 ^ c5 ^ c11 ^ d22 ^ d55 ^ 
        d13 ^ c27 ^ d62 ^ c12 ^ d44 ^ d6 ^ d26 ^ d95 ^ d92 ^ d124 ^ 
        d41 ^ c18 ^ d78 ^ c26 ^ d23 ^ d91 ^ d52 ^ d65 ^ d28 ^ d51 ^ 
        d60 ^ d79;  // 81 ins 1 outs level 3

    assign x28 = d100 ^ d68 ^ d63 ^ d2 ^ d92 ^ d75 ^ d8 ^ d21 ^ d69 ^ 
        c26 ^ d124 ^ d77 ^ d91 ^ c27 ^ d22 ^ d90 ^ d40 ^ d20 ^ d99 ^ 
        d83 ^ d56 ^ d64 ^ d78 ^ c11 ^ d113 ^ d121 ^ d44 ^ d54 ^ c17 ^ 
        c4 ^ d123 ^ c14 ^ d110 ^ d30 ^ d57 ^ d62 ^ d33 ^ d27 ^ d46 ^ 
        c16 ^ d5 ^ d12 ^ c3 ^ d115 ^ c23 ^ c10 ^ d24 ^ d106 ^ c13 ^ 
        d109 ^ c28 ^ d114 ^ d26 ^ d97 ^ d81 ^ c1 ^ d43 ^ d51 ^ d102 ^ 
        c18 ^ d112 ^ d59 ^ d122 ^ d107 ^ c6 ^ d28 ^ d80 ^ d95 ^ d94 ^ 
        d119 ^ c25 ^ d50 ^ d49 ^ d61 ^ d41 ^ d79 ^ d93 ^ d25 ^ d6 ^ 
        c19;  // 80 ins 1 outs level 3

    assign x27 = d111 ^ d67 ^ d123 ^ d1 ^ d48 ^ c5 ^ d26 ^ d21 ^ d61 ^ 
        d96 ^ d25 ^ d49 ^ c27 ^ d78 ^ c3 ^ c10 ^ d121 ^ c25 ^ c18 ^ 
        d32 ^ d101 ^ d23 ^ d53 ^ d42 ^ d5 ^ d20 ^ d98 ^ d45 ^ d105 ^ 
        d92 ^ d127 ^ d40 ^ d90 ^ d74 ^ c17 ^ d122 ^ d80 ^ c31 ^ d112 ^ 
        d106 ^ d89 ^ d93 ^ d11 ^ d56 ^ d114 ^ d55 ^ c16 ^ d118 ^ d43 ^ 
        c2 ^ c0 ^ d63 ^ d39 ^ d79 ^ c12 ^ c24 ^ d68 ^ d4 ^ d50 ^ 
        c22 ^ d120 ^ c26 ^ c13 ^ d76 ^ c15 ^ d60 ^ c9 ^ d62 ^ d7 ^ 
        d58 ^ d108 ^ d82 ^ d24 ^ d77 ^ d94 ^ d27 ^ d109 ^ d113 ^ d19 ^ 
        d99 ^ d91 ^ d29;  // 82 ins 1 outs level 3

    assign x26 = c2 ^ d55 ^ d110 ^ d48 ^ d119 ^ d26 ^ d6 ^ c4 ^ c21 ^ 
        d61 ^ c26 ^ c17 ^ d49 ^ d75 ^ d24 ^ c9 ^ d54 ^ d0 ^ d104 ^ 
        c23 ^ d79 ^ d28 ^ d88 ^ d93 ^ d111 ^ d112 ^ c1 ^ d107 ^ d4 ^ 
        d57 ^ d122 ^ d67 ^ d47 ^ c16 ^ d98 ^ d76 ^ d73 ^ c12 ^ d66 ^ 
        c15 ^ d95 ^ d10 ^ d60 ^ d121 ^ d31 ^ d120 ^ d38 ^ d108 ^ c14 ^ 
        d52 ^ d105 ^ d22 ^ d78 ^ d90 ^ d126 ^ d89 ^ d39 ^ d42 ^ d62 ^ 
        d19 ^ d100 ^ d20 ^ d25 ^ d18 ^ d92 ^ d59 ^ d3 ^ d97 ^ c11 ^ 
        d81 ^ c24 ^ d77 ^ c8 ^ d23 ^ d41 ^ c30 ^ d113 ^ d91 ^ d44 ^ 
        c25 ^ d117;  // 81 ins 1 outs level 3

    assign x25 = c17 ^ c24 ^ c4 ^ d89 ^ d86 ^ c25 ^ d121 ^ d61 ^ c21 ^ 
        d90 ^ c2 ^ d41 ^ d44 ^ c28 ^ d17 ^ c3 ^ d75 ^ d77 ^ d64 ^ 
        d62 ^ d122 ^ d21 ^ d87 ^ d48 ^ c23 ^ d106 ^ d37 ^ d99 ^ c8 ^ 
        d51 ^ d119 ^ d124 ^ d28 ^ d33 ^ d57 ^ c30 ^ d84 ^ d100 ^ d67 ^ 
        d126 ^ c10 ^ d36 ^ c26 ^ d104 ^ d38 ^ d74 ^ d95 ^ d29 ^ d83 ^ 
        c9 ^ d52 ^ d3 ^ d19 ^ d115 ^ c15 ^ d22 ^ d18 ^ d105 ^ d2 ^ 
        c6 ^ d92 ^ d102 ^ d91 ^ d8 ^ d107 ^ d76 ^ d117 ^ d31 ^ d120 ^ 
        d88 ^ d71 ^ d15 ^ d81 ^ d82 ^ c11 ^ d49 ^ d58 ^ d40 ^ c19 ^ 
        d56 ^ d11 ^ d111 ^ d93 ^ d98 ^ d113;  // 85 ins 1 outs level 3

    assign x24 = d27 ^ d56 ^ d30 ^ d114 ^ d28 ^ d125 ^ c27 ^ d48 ^ c14 ^ 
        c29 ^ d98 ^ d123 ^ d2 ^ d14 ^ d40 ^ c16 ^ c20 ^ d85 ^ c18 ^ 
        d37 ^ d83 ^ d73 ^ d103 ^ d55 ^ d89 ^ d81 ^ d51 ^ d63 ^ d57 ^ 
        d43 ^ d35 ^ d10 ^ d74 ^ d17 ^ d97 ^ d90 ^ d106 ^ d88 ^ d47 ^ 
        d110 ^ d101 ^ d92 ^ d105 ^ d60 ^ d80 ^ d119 ^ c5 ^ c8 ^ c3 ^ 
        d91 ^ d116 ^ d121 ^ d1 ^ d18 ^ c7 ^ d32 ^ d50 ^ d104 ^ c25 ^ 
        d70 ^ d36 ^ d66 ^ c24 ^ d127 ^ d112 ^ d16 ^ c31 ^ d21 ^ d75 ^ 
        d20 ^ d76 ^ c10 ^ c22 ^ d61 ^ d82 ^ c23 ^ c9 ^ d118 ^ c1 ^ 
        c2 ^ d94 ^ d39 ^ d87 ^ d120 ^ d7 ^ d99 ^ d86;  // 87 ins 1 outs level 3

    assign x23 = d50 ^ c2 ^ d113 ^ d74 ^ d60 ^ d16 ^ d124 ^ d85 ^ d29 ^ 
        d111 ^ d119 ^ c13 ^ d120 ^ d34 ^ d26 ^ d117 ^ d96 ^ d122 ^ c8 ^ 
        d1 ^ d118 ^ d104 ^ d38 ^ c6 ^ d54 ^ c21 ^ c9 ^ d72 ^ c17 ^ 
        d105 ^ d39 ^ d84 ^ d127 ^ d97 ^ d115 ^ c1 ^ d98 ^ d55 ^ d80 ^ 
        d36 ^ c31 ^ d59 ^ d126 ^ c23 ^ c30 ^ d75 ^ c0 ^ d47 ^ d65 ^ 
        d27 ^ c7 ^ d87 ^ d93 ^ d91 ^ d20 ^ d89 ^ d69 ^ d86 ^ d82 ^ 
        c26 ^ d100 ^ d102 ^ d0 ^ d56 ^ c15 ^ d42 ^ d103 ^ c4 ^ c22 ^ 
        d35 ^ d109 ^ d9 ^ d46 ^ d62 ^ d88 ^ d79 ^ d49 ^ d73 ^ d81 ^ 
        d13 ^ c28 ^ d90 ^ d31 ^ d19 ^ d15 ^ d17 ^ c24 ^ c19 ^ d6;  // 89 ins 1 outs level 3

    assign x22 = d101 ^ d62 ^ d26 ^ d89 ^ d18 ^ d65 ^ d0 ^ c28 ^ d31 ^ 
        d66 ^ d19 ^ d61 ^ d122 ^ d60 ^ c9 ^ d105 ^ d113 ^ d74 ^ d108 ^ 
        d124 ^ d88 ^ d41 ^ c3 ^ d121 ^ d12 ^ d100 ^ d38 ^ d34 ^ c23 ^ 
        d109 ^ c8 ^ d45 ^ d115 ^ c19 ^ d79 ^ d24 ^ d44 ^ d92 ^ c25 ^ 
        d90 ^ d55 ^ c5 ^ d58 ^ d27 ^ c4 ^ d43 ^ d123 ^ d9 ^ d67 ^ 
        c17 ^ d23 ^ d35 ^ d68 ^ c18 ^ c26 ^ d85 ^ d93 ^ c27 ^ d36 ^ 
        d99 ^ c13 ^ d11 ^ d94 ^ c2 ^ d37 ^ d104 ^ d48 ^ d29 ^ d114 ^ 
        d119 ^ c12 ^ d16 ^ d57 ^ d47 ^ d14 ^ d98 ^ d87 ^ d82 ^ d73 ^ 
        d52;  // 80 ins 1 outs level 3

    assign x21 = d80 ^ c19 ^ d89 ^ c25 ^ d62 ^ d120 ^ d10 ^ c21 ^ d109 ^ 
        d115 ^ d92 ^ d27 ^ d87 ^ d53 ^ d37 ^ d125 ^ d114 ^ d61 ^ c11 ^ 
        d95 ^ c28 ^ d124 ^ d42 ^ c24 ^ d88 ^ d56 ^ d18 ^ d52 ^ c20 ^ 
        d34 ^ d104 ^ d94 ^ d102 ^ d108 ^ d49 ^ d29 ^ c14 ^ d96 ^ c0 ^ 
        d22 ^ d117 ^ d91 ^ d73 ^ d107 ^ d116 ^ d51 ^ c12 ^ d110 ^ c8 ^ 
        d24 ^ d99 ^ d40 ^ d9 ^ d35 ^ c29 ^ c18 ^ d17 ^ c13 ^ d13 ^ 
        d121 ^ c9 ^ d82 ^ d31 ^ c6 ^ d105 ^ c3 ^ d83 ^ d123 ^ c30 ^ 
        d26 ^ d71 ^ c27 ^ d126 ^ d5;  // 74 ins 1 outs level 3

    assign x20 = c18 ^ d91 ^ d124 ^ d34 ^ d108 ^ c8 ^ c28 ^ d93 ^ d115 ^ 
        d25 ^ c27 ^ d26 ^ c5 ^ d123 ^ d94 ^ d116 ^ d101 ^ d52 ^ d33 ^ 
        d114 ^ c23 ^ d9 ^ d36 ^ d72 ^ d98 ^ d87 ^ d55 ^ d125 ^ d60 ^ 
        d122 ^ d12 ^ d30 ^ d61 ^ d88 ^ d17 ^ d28 ^ d81 ^ d109 ^ c7 ^ 
        d41 ^ c20 ^ d120 ^ d107 ^ c19 ^ d70 ^ c26 ^ d39 ^ d23 ^ c2 ^ 
        d119 ^ c24 ^ d90 ^ c12 ^ d51 ^ d104 ^ d82 ^ d113 ^ d48 ^ d8 ^ 
        d95 ^ d103 ^ d106 ^ c10 ^ c29 ^ c13 ^ c11 ^ d4 ^ d21 ^ d79 ^ 
        c17 ^ d50 ^ d86 ^ d16;  // 73 ins 1 outs level 3

    assign x19 = d7 ^ d80 ^ d105 ^ d3 ^ c9 ^ d123 ^ c31 ^ c23 ^ d8 ^ 
        d54 ^ d92 ^ d33 ^ d114 ^ d124 ^ d86 ^ d35 ^ d71 ^ c19 ^ d51 ^ 
        d15 ^ d122 ^ c22 ^ d81 ^ d49 ^ d103 ^ d78 ^ d69 ^ d32 ^ d121 ^ 
        d59 ^ c17 ^ c11 ^ d16 ^ c18 ^ d40 ^ d25 ^ c6 ^ c16 ^ d47 ^ 
        d97 ^ d90 ^ d20 ^ d50 ^ c1 ^ d113 ^ d94 ^ d87 ^ d100 ^ d89 ^ 
        d11 ^ d115 ^ d119 ^ c10 ^ c4 ^ c26 ^ d60 ^ c12 ^ d112 ^ c28 ^ 
        d118 ^ d93 ^ c25 ^ d107 ^ d102 ^ d29 ^ d22 ^ d127 ^ d24 ^ d106 ^ 
        d27 ^ d108 ^ d85 ^ c27 ^ c7 ^ d38;  // 75 ins 1 outs level 3

    assign x18 = c21 ^ c10 ^ d2 ^ d6 ^ d59 ^ d118 ^ d80 ^ c6 ^ d84 ^ 
        d106 ^ d121 ^ d70 ^ d46 ^ d88 ^ d21 ^ d26 ^ d99 ^ c22 ^ d86 ^ 
        c8 ^ d10 ^ d39 ^ c9 ^ c30 ^ d89 ^ d102 ^ c0 ^ d31 ^ d58 ^ 
        d92 ^ d28 ^ d48 ^ c26 ^ d112 ^ c16 ^ d91 ^ c5 ^ d19 ^ d49 ^ 
        d15 ^ c18 ^ d114 ^ d68 ^ c3 ^ d93 ^ c11 ^ d50 ^ c24 ^ d77 ^ 
        d105 ^ d7 ^ d101 ^ c25 ^ d85 ^ d120 ^ d96 ^ d111 ^ c15 ^ d32 ^ 
        d79 ^ d14 ^ d113 ^ d37 ^ c27 ^ d24 ^ c17 ^ d126 ^ d23 ^ d117 ^ 
        d123 ^ d34 ^ d104 ^ d122 ^ d107 ^ d53;  // 75 ins 1 outs level 3

    assign x17 = d116 ^ c25 ^ c5 ^ d30 ^ c29 ^ d57 ^ d113 ^ d90 ^ c15 ^ 
        d121 ^ d100 ^ d13 ^ d27 ^ d48 ^ d106 ^ d110 ^ d9 ^ d119 ^ c24 ^ 
        d58 ^ d69 ^ c21 ^ d78 ^ d1 ^ c14 ^ c20 ^ d38 ^ c23 ^ d67 ^ 
        d112 ^ d22 ^ c7 ^ d87 ^ d20 ^ d45 ^ d88 ^ d5 ^ d103 ^ d76 ^ 
        d105 ^ d111 ^ d14 ^ d6 ^ c8 ^ d104 ^ d49 ^ d117 ^ d85 ^ d84 ^ 
        c16 ^ c9 ^ d25 ^ c17 ^ d23 ^ d91 ^ c26 ^ d18 ^ c2 ^ d36 ^ 
        d31 ^ d125 ^ c4 ^ d98 ^ d83 ^ d101 ^ d120 ^ d52 ^ d95 ^ d92 ^ 
        c10 ^ d47 ^ d33 ^ d79 ^ d122;  // 74 ins 1 outs level 3

    assign x16 = c3 ^ d90 ^ d4 ^ d32 ^ d24 ^ d26 ^ d83 ^ d111 ^ c24 ^ 
        c23 ^ d109 ^ d5 ^ d8 ^ d97 ^ c19 ^ c1 ^ c16 ^ d56 ^ d104 ^ 
        d44 ^ d127 ^ d75 ^ d19 ^ c8 ^ d57 ^ d110 ^ d78 ^ d68 ^ d118 ^ 
        d47 ^ c6 ^ c13 ^ c28 ^ d87 ^ c14 ^ d12 ^ d119 ^ d121 ^ d22 ^ 
        c22 ^ d13 ^ c25 ^ c31 ^ d116 ^ c15 ^ d124 ^ c7 ^ c20 ^ d99 ^ 
        d66 ^ d94 ^ d37 ^ d84 ^ d82 ^ d0 ^ d48 ^ d29 ^ d112 ^ d30 ^ 
        d17 ^ d35 ^ d120 ^ d100 ^ d89 ^ d105 ^ c9 ^ d102 ^ d115 ^ d21 ^ 
        d103 ^ d77 ^ d51 ^ d91 ^ d46 ^ d86 ^ c4;  // 76 ins 1 outs level 3

    assign x15 = d100 ^ d104 ^ d15 ^ d16 ^ d76 ^ d59 ^ d12 ^ d27 ^ d116 ^ 
        d120 ^ d124 ^ c15 ^ d52 ^ d94 ^ c17 ^ d49 ^ d78 ^ c5 ^ d108 ^ 
        d60 ^ d5 ^ d20 ^ d112 ^ d123 ^ d34 ^ d114 ^ d3 ^ c26 ^ c20 ^ 
        d90 ^ d56 ^ d80 ^ d30 ^ d53 ^ d71 ^ d50 ^ d72 ^ c9 ^ c23 ^ 
        c1 ^ d57 ^ c24 ^ d44 ^ c3 ^ d54 ^ d77 ^ d111 ^ d74 ^ c8 ^ 
        d66 ^ d119 ^ d24 ^ c12 ^ d88 ^ d18 ^ d95 ^ c4 ^ c27 ^ c29 ^ 
        c28 ^ d97 ^ d105 ^ d85 ^ d101 ^ d125 ^ d33 ^ d113 ^ d84 ^ d89 ^ 
        d9 ^ c18 ^ d21 ^ d62 ^ d8 ^ d122 ^ d99 ^ d4 ^ d45 ^ d64 ^ 
        c16 ^ d55 ^ d7;  // 82 ins 1 outs level 3

    assign x14 = d32 ^ d75 ^ d98 ^ c8 ^ d115 ^ d104 ^ d26 ^ d59 ^ d103 ^ 
        d49 ^ d4 ^ d3 ^ d111 ^ d123 ^ d96 ^ c15 ^ d53 ^ c23 ^ c2 ^ 
        d15 ^ d44 ^ d7 ^ d77 ^ d2 ^ d70 ^ d100 ^ d6 ^ d122 ^ d118 ^ 
        d119 ^ c0 ^ d79 ^ d112 ^ d63 ^ d58 ^ d14 ^ c3 ^ d51 ^ d94 ^ 
        d65 ^ d19 ^ d52 ^ c22 ^ d83 ^ d55 ^ d107 ^ d89 ^ d110 ^ d71 ^ 
        d113 ^ d33 ^ c17 ^ c14 ^ d61 ^ c7 ^ d76 ^ d124 ^ d87 ^ d8 ^ 
        d56 ^ d23 ^ d48 ^ d43 ^ d93 ^ d20 ^ d121 ^ d17 ^ c19 ^ c25 ^ 
        d84 ^ d11 ^ d99 ^ d88 ^ d73 ^ c28 ^ c16 ^ c4 ^ c11 ^ d54 ^ 
        c26 ^ d29 ^ c27;  // 82 ins 1 outs level 3

    assign x13 = d52 ^ d47 ^ c15 ^ d111 ^ d18 ^ c22 ^ c25 ^ d121 ^ c21 ^ 
        d55 ^ d114 ^ d32 ^ c18 ^ d10 ^ c10 ^ d28 ^ d103 ^ d48 ^ d92 ^ 
        d16 ^ d82 ^ d88 ^ c3 ^ d78 ^ d31 ^ d57 ^ d123 ^ c6 ^ d53 ^ 
        d50 ^ d43 ^ d13 ^ d2 ^ d106 ^ d75 ^ d14 ^ d69 ^ d42 ^ d60 ^ 
        d25 ^ d70 ^ c24 ^ d76 ^ d95 ^ d54 ^ c16 ^ d72 ^ d117 ^ d62 ^ 
        c26 ^ c2 ^ d120 ^ d83 ^ c13 ^ d7 ^ d22 ^ d3 ^ d98 ^ d64 ^ 
        d99 ^ d122 ^ d87 ^ d86 ^ d102 ^ d74 ^ c27 ^ d19 ^ d97 ^ d51 ^ 
        d112 ^ c14 ^ d109 ^ d1 ^ d118 ^ c1 ^ d93 ^ d5 ^ d110 ^ d58 ^ 
        d6 ^ c7;  // 81 ins 1 outs level 3

    assign x12 = c15 ^ d98 ^ d2 ^ d108 ^ d57 ^ c31 ^ d127 ^ d91 ^ d46 ^ 
        d59 ^ d21 ^ d120 ^ d75 ^ d92 ^ d9 ^ d0 ^ c13 ^ c23 ^ c9 ^ 
        d94 ^ d81 ^ d117 ^ d113 ^ c0 ^ d49 ^ d27 ^ d111 ^ c1 ^ d56 ^ 
        d102 ^ d110 ^ d51 ^ d17 ^ c2 ^ c14 ^ d87 ^ d1 ^ d82 ^ d121 ^ 
        d42 ^ d30 ^ d47 ^ d71 ^ d122 ^ d5 ^ d119 ^ d77 ^ d24 ^ d96 ^ 
        d15 ^ d52 ^ c25 ^ d74 ^ d109 ^ d97 ^ d31 ^ d6 ^ d50 ^ d68 ^ 
        d85 ^ d12 ^ d116 ^ d41 ^ c5 ^ d105 ^ d13 ^ d86 ^ d18 ^ d54 ^ 
        c24 ^ c12 ^ d69 ^ c21 ^ c17 ^ c20 ^ d4 ^ d53 ^ d73 ^ d61 ^ 
        c6 ^ d101 ^ c26 ^ d63;  // 83 ins 1 outs level 3

    assign x11 = d28 ^ d64 ^ d90 ^ d70 ^ d24 ^ d41 ^ d31 ^ d33 ^ d65 ^ 
        d0 ^ c29 ^ d121 ^ d94 ^ d51 ^ d48 ^ d15 ^ d105 ^ d78 ^ d107 ^ 
        d54 ^ c6 ^ d4 ^ d9 ^ c24 ^ d68 ^ d113 ^ d12 ^ d82 ^ d108 ^ 
        d124 ^ c17 ^ c5 ^ d104 ^ d25 ^ c26 ^ d43 ^ d44 ^ d119 ^ d16 ^ 
        d59 ^ d103 ^ d117 ^ d20 ^ d40 ^ c28 ^ d76 ^ d55 ^ d36 ^ d17 ^ 
        d120 ^ d85 ^ d101 ^ c21 ^ c23 ^ d66 ^ d27 ^ d83 ^ d26 ^ d91 ^ 
        d47 ^ c11 ^ d56 ^ d102 ^ c9 ^ c7 ^ d1 ^ c12 ^ d14 ^ d122 ^ 
        c2 ^ c25 ^ d3 ^ d125 ^ d98 ^ d74 ^ d50 ^ d71 ^ d57 ^ c8 ^ 
        d73 ^ d45 ^ d58;  // 82 ins 1 outs level 3

    assign x10 = c14 ^ d109 ^ c11 ^ c24 ^ d117 ^ d31 ^ d59 ^ d32 ^ d50 ^ 
        c17 ^ c10 ^ d16 ^ d101 ^ d40 ^ d83 ^ d56 ^ d119 ^ c29 ^ d80 ^ 
        d19 ^ c8 ^ d5 ^ d2 ^ d36 ^ d106 ^ d62 ^ c0 ^ c19 ^ d70 ^ 
        d29 ^ d104 ^ d90 ^ d121 ^ c31 ^ d123 ^ d126 ^ d42 ^ c30 ^ c9 ^ 
        d78 ^ d60 ^ d69 ^ d86 ^ c13 ^ d94 ^ d0 ^ d96 ^ d113 ^ d115 ^ 
        d110 ^ d107 ^ d98 ^ d33 ^ d73 ^ d120 ^ d89 ^ d28 ^ d75 ^ d13 ^ 
        d3 ^ c25 ^ d58 ^ d39 ^ d71 ^ d9 ^ c5 ^ d122 ^ d35 ^ d14 ^ 
        d77 ^ d63 ^ c21 ^ c26 ^ d105 ^ d52 ^ c27 ^ d55 ^ c2 ^ d125 ^ 
        d127 ^ d26 ^ c23 ^ d66 ^ d95;  // 84 ins 1 outs level 3

    assign x9 = c14 ^ d39 ^ d67 ^ d58 ^ d4 ^ d98 ^ d78 ^ d80 ^ c10 ^ 
        d89 ^ d119 ^ d74 ^ d102 ^ d85 ^ d41 ^ d84 ^ d86 ^ d69 ^ d29 ^ 
        d81 ^ d18 ^ c21 ^ d114 ^ d106 ^ c19 ^ d83 ^ d60 ^ d13 ^ d11 ^ 
        d47 ^ d77 ^ c0 ^ d71 ^ d110 ^ d43 ^ d32 ^ d55 ^ c2 ^ d52 ^ 
        c17 ^ d79 ^ d24 ^ d70 ^ d120 ^ d38 ^ d35 ^ d113 ^ d64 ^ c18 ^ 
        d121 ^ d76 ^ d68 ^ d36 ^ c12 ^ d51 ^ d12 ^ d1 ^ d108 ^ d104 ^ 
        d44 ^ d34 ^ d33 ^ d115 ^ c25 ^ d127 ^ d46 ^ d88 ^ c8 ^ c6 ^ 
        d23 ^ d2 ^ d66 ^ d9 ^ d53 ^ d96 ^ c24 ^ d117 ^ c31 ^ d5 ^ 
        d61 ^ c23;  // 81 ins 1 outs level 3

    assign x8 = d87 ^ d82 ^ d67 ^ d12 ^ d114 ^ d78 ^ c24 ^ d97 ^ d22 ^ 
        d50 ^ d113 ^ d112 ^ d84 ^ d17 ^ d45 ^ d105 ^ d118 ^ d69 ^ d43 ^ 
        c18 ^ d34 ^ d52 ^ d80 ^ d126 ^ d11 ^ c30 ^ d116 ^ d37 ^ c17 ^ 
        c7 ^ d51 ^ c22 ^ c23 ^ d28 ^ d33 ^ d75 ^ d109 ^ c1 ^ d31 ^ 
        c20 ^ d3 ^ d119 ^ d59 ^ c5 ^ d32 ^ c9 ^ d77 ^ d73 ^ d40 ^ 
        d8 ^ c16 ^ d35 ^ d42 ^ d54 ^ d57 ^ d101 ^ d63 ^ d23 ^ d4 ^ 
        d107 ^ d120 ^ d65 ^ d46 ^ d66 ^ d95 ^ d10 ^ c11 ^ d60 ^ d38 ^ 
        d0 ^ d68 ^ d103 ^ d79 ^ d85 ^ d1 ^ d88 ^ d83 ^ d70 ^ d76 ^ 
        c13;  // 80 ins 1 outs level 3

    assign x7 = d0 ^ d110 ^ d28 ^ d32 ^ d97 ^ d39 ^ d111 ^ d21 ^ d37 ^ 
        d34 ^ d103 ^ d76 ^ c15 ^ d43 ^ d15 ^ c28 ^ d3 ^ d57 ^ d105 ^ 
        d29 ^ d116 ^ d54 ^ d46 ^ c23 ^ d47 ^ d104 ^ c7 ^ d79 ^ c26 ^ 
        d93 ^ c2 ^ d74 ^ d71 ^ d22 ^ c13 ^ c10 ^ d23 ^ d95 ^ d126 ^ 
        d16 ^ d41 ^ c9 ^ d10 ^ d50 ^ d25 ^ c12 ^ d56 ^ d45 ^ d51 ^ 
        d60 ^ d119 ^ d5 ^ d7 ^ d80 ^ c1 ^ d24 ^ d75 ^ d52 ^ d124 ^ 
        d98 ^ d87 ^ d77 ^ d108 ^ d58 ^ c20 ^ d2 ^ d42 ^ c14 ^ d109 ^ 
        d106 ^ d8 ^ d68 ^ d69 ^ c8 ^ d122 ^ c30;  // 76 ins 1 outs level 3

    assign x6 = d1 ^ d51 ^ d64 ^ c17 ^ d62 ^ d117 ^ d82 ^ d8 ^ d73 ^ 
        d92 ^ c8 ^ c11 ^ d50 ^ d6 ^ d75 ^ d121 ^ d40 ^ d81 ^ d93 ^ 
        d112 ^ c31 ^ d60 ^ c27 ^ d20 ^ d66 ^ d122 ^ d4 ^ d21 ^ d123 ^ 
        d126 ^ d80 ^ d45 ^ c30 ^ d22 ^ c12 ^ d84 ^ d70 ^ d54 ^ d25 ^ 
        d71 ^ c28 ^ d76 ^ d42 ^ d83 ^ d30 ^ c16 ^ d116 ^ c2 ^ d56 ^ 
        d107 ^ c25 ^ d124 ^ d43 ^ d55 ^ d127 ^ d7 ^ d5 ^ d29 ^ d108 ^ 
        c21 ^ d2 ^ d72 ^ d41 ^ d104 ^ c26 ^ c4 ^ d68 ^ d38 ^ c20 ^ 
        d65 ^ d98 ^ d14 ^ d95 ^ d79 ^ d74 ^ d100 ^ d11 ^ d47 ^ d52 ^ 
        d113;  // 80 ins 1 outs level 3

    assign x5 = d37 ^ d65 ^ d61 ^ d46 ^ d81 ^ d13 ^ c31 ^ d4 ^ c25 ^ 
        d78 ^ d24 ^ d10 ^ d70 ^ d69 ^ d122 ^ d3 ^ d0 ^ d116 ^ d126 ^ 
        d112 ^ d103 ^ c11 ^ d5 ^ d127 ^ d54 ^ d28 ^ d71 ^ d20 ^ d40 ^ 
        d72 ^ d79 ^ c19 ^ d80 ^ c7 ^ c27 ^ d91 ^ d82 ^ c26 ^ d64 ^ 
        d41 ^ d29 ^ d74 ^ d121 ^ c10 ^ d73 ^ d75 ^ c15 ^ d55 ^ c3 ^ 
        d59 ^ c1 ^ c16 ^ d83 ^ d92 ^ d51 ^ c20 ^ d19 ^ d6 ^ d21 ^ 
        d1 ^ d53 ^ d63 ^ d106 ^ c29 ^ d107 ^ d67 ^ d125 ^ d120 ^ d7 ^ 
        d115 ^ d49 ^ c24 ^ d97 ^ c30 ^ d111 ^ d39 ^ d44 ^ d42 ^ d50 ^ 
        d123 ^ d99 ^ d94;  // 82 ins 1 outs level 3

    assign x4 = d95 ^ d73 ^ c16 ^ c4 ^ d109 ^ d59 ^ d100 ^ d97 ^ d18 ^ 
        d91 ^ d63 ^ d84 ^ d46 ^ c23 ^ d94 ^ d113 ^ d24 ^ d40 ^ d15 ^ 
        d30 ^ d2 ^ c31 ^ d69 ^ d70 ^ d112 ^ d11 ^ d90 ^ d121 ^ d83 ^ 
        d77 ^ d50 ^ d3 ^ d47 ^ d120 ^ d74 ^ d48 ^ d33 ^ c24 ^ d86 ^ 
        d41 ^ d25 ^ c22 ^ c7 ^ d111 ^ c25 ^ d44 ^ d117 ^ c10 ^ c13 ^ 
        d45 ^ c21 ^ d20 ^ d58 ^ d65 ^ c1 ^ d8 ^ d19 ^ c18 ^ d29 ^ 
        d127 ^ d12 ^ d116 ^ c17 ^ d0 ^ d103 ^ d39 ^ c20 ^ d79 ^ d106 ^ 
        d114 ^ d38 ^ d57 ^ d67 ^ d119 ^ d118 ^ c15 ^ d31 ^ d68 ^ d6 ^ 
        d4;  // 80 ins 1 outs level 3

    assign x3 = c1 ^ d2 ^ c7 ^ d17 ^ d58 ^ d45 ^ d65 ^ c15 ^ c29 ^ 
        d36 ^ d68 ^ d39 ^ d109 ^ d80 ^ d52 ^ d8 ^ d19 ^ d59 ^ d27 ^ 
        d10 ^ d14 ^ d122 ^ d125 ^ d56 ^ d108 ^ c13 ^ d103 ^ d97 ^ d84 ^ 
        d18 ^ d38 ^ d90 ^ d76 ^ d100 ^ d54 ^ d89 ^ d53 ^ c23 ^ d60 ^ 
        d69 ^ c28 ^ d33 ^ d111 ^ d31 ^ d73 ^ d1 ^ c26 ^ d119 ^ d124 ^ 
        d32 ^ c2 ^ d71 ^ d3 ^ c24 ^ d120 ^ d81 ^ d85 ^ d25 ^ d40 ^ 
        c3 ^ c4 ^ c12 ^ d98 ^ d95 ^ d7 ^ d99 ^ d9 ^ d37 ^ d15 ^ 
        d86;  // 70 ins 1 outs level 3

    assign x2 = d107 ^ c14 ^ d59 ^ d119 ^ d9 ^ d127 ^ d26 ^ d70 ^ d84 ^ 
        d17 ^ d30 ^ d79 ^ d0 ^ c31 ^ c27 ^ d8 ^ d13 ^ c22 ^ d44 ^ 
        c1 ^ d110 ^ c0 ^ d55 ^ d52 ^ d75 ^ d72 ^ c3 ^ c2 ^ d96 ^ 
        d88 ^ d97 ^ d31 ^ d53 ^ d7 ^ d89 ^ d102 ^ d32 ^ d80 ^ d58 ^ 
        d123 ^ d57 ^ c23 ^ d24 ^ d14 ^ d16 ^ d39 ^ d99 ^ d38 ^ d94 ^ 
        c28 ^ d124 ^ c11 ^ d37 ^ d98 ^ d67 ^ d118 ^ d64 ^ d68 ^ d85 ^ 
        d83 ^ d6 ^ d51 ^ d35 ^ d36 ^ d1 ^ d2 ^ d108 ^ c12 ^ d18 ^ 
        c6 ^ c25 ^ d121;  // 72 ins 1 outs level 3

    assign x1 = d37 ^ d123 ^ d34 ^ d24 ^ c20 ^ d6 ^ d11 ^ d112 ^ d50 ^ 
        d74 ^ d60 ^ c4 ^ d102 ^ d87 ^ c11 ^ d16 ^ d124 ^ c29 ^ d9 ^ 
        d47 ^ c19 ^ c5 ^ d65 ^ d17 ^ d62 ^ c9 ^ d101 ^ d81 ^ d110 ^ 
        c24 ^ d72 ^ d49 ^ c7 ^ c28 ^ d13 ^ d100 ^ d125 ^ d107 ^ d58 ^ 
        c10 ^ c14 ^ c6 ^ d113 ^ d88 ^ d46 ^ d35 ^ d44 ^ d27 ^ d63 ^ 
        d12 ^ d115 ^ d1 ^ d51 ^ d64 ^ d38 ^ d0 ^ d103 ^ d56 ^ d79 ^ 
        d86 ^ d94 ^ d7 ^ d120 ^ d116 ^ c16 ^ d69 ^ d106 ^ d59 ^ d80 ^ 
        d105 ^ c27 ^ c17 ^ d28 ^ d33 ^ d53;  // 75 ins 1 outs level 3

    assign x0 = c22 ^ c29 ^ d6 ^ d83 ^ d85 ^ d68 ^ d31 ^ c15 ^ d118 ^ 
        d67 ^ d24 ^ c0 ^ d106 ^ d79 ^ d103 ^ d0 ^ d65 ^ d30 ^ d84 ^ 
        c14 ^ d60 ^ d10 ^ d95 ^ d66 ^ d63 ^ d73 ^ d82 ^ d87 ^ d98 ^ 
        d16 ^ c3 ^ c10 ^ c7 ^ d47 ^ c23 ^ d72 ^ d26 ^ d101 ^ d54 ^ 
        d32 ^ d61 ^ c21 ^ c5 ^ d96 ^ d119 ^ d114 ^ d29 ^ d48 ^ d37 ^ 
        d94 ^ d99 ^ d123 ^ d53 ^ c20 ^ c1 ^ d28 ^ c17 ^ d116 ^ d12 ^ 
        d127 ^ d104 ^ c18 ^ d58 ^ d45 ^ d50 ^ d97 ^ d125 ^ c2 ^ d55 ^ 
        d110 ^ d117 ^ d44 ^ d111 ^ c27 ^ d113 ^ d81 ^ d9 ^ c30 ^ d126 ^ 
        c31 ^ c8 ^ d25 ^ d34;  // 83 ins 1 outs level 3

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat128_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [127:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x378, x377, x376, x375, x374, x373, x372, 
       x371, x370, x369, x368, x367, x366, x365, x364, 
       x363, x362, x361, x360, x359, x358, x357, x356, 
       x355, x354, x353, x352, x351, x350, x349, x348, 
       x347, x346, x345, x344, x343, x342, x341, x340, 
       x339, x338, x337, x336, x335, x334, x333, x332, 
       x331, x330, x329, x328, x327, x326, x325, x324, 
       x323, x322, x321, x320, x319, x318, x317, x316, 
       x315, x314, x313, x312, x311, x310, x309, x308, 
       x307, x306, x305, x304, x303, x302, x301, x300, 
       x298, x297, x296, x295, x294, x293, x292, x291, 
       x290, x288, x287, x286, x285, x284, x283, x282, 
       x281, x280, x279, x278, x277, x276, x275, x274, 
       x273, x272, x271, x270, x269, x268, x267, x266, 
       x265, x264, x263, x262, x261, x260, x259, x258, 
       x257, x256, x255, x254, x253, x252, x251, x250, 
       x249, x248, x247, x246, x245, x244, x243, x242, 
       x241, x240, x239, x238, x237, x236, x235, x234, 
       x233, x232, x231, x230, x229, x228, x227, x226, 
       x225, x224, x223, x222, x221, x220, x219, x218, 
       x217, x216, x215, x214, x213, x212, x211, x210, 
       x209, x208, x207, x206, x205, x204, x203, x202, 
       x201, x200, x199, x198, x197, x196, x195, x194, 
       x193, x192, x191, x190, x189, x188, x187, x186, 
       x185, x184, x183, x182, x181, x180, x179, x178, 
       x177, x176, x175, x174, x173, x172, x171, x170, 
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
       x89, x88, x87, x86, x85, x84, x83, x82, 
       x81, x80, x79, x78, x77, x76, x75, x74, 
       x73, x72, x71, x70, x69, x68, x67, x66, 
       x65, x64, x63, x62, x61, x60, x59, x58, 
       x57, x56, x55, x54, x53, x52, x51, x50, 
       x49, x48, x47, x46, x45, x44, x43, x42, 
       x41, x40, x39, x38, x37, x36, x35, x34, 
       x33, x32, x31, x30, x29, x28, x27, x26, 
       x25, x24, x23, x22, x21, x20, x19, x18, 
       x17, x16, x15, x14, x13, x12, x11, x10, 
       x9, x8, x7, x6, x5, x4, x3, x2, 
       x1, x0;

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
    d111,d112,d113,d114,d115,d116,d117,d118,d119,d120,d121,d122,d123,d124,d125,d126,
    d127;

assign { d127,d126,d125,d124,d123,d122,d121,d120,d119,d118,d117,d116,d115,d114,d113,
        d112,d111,d110,d109,d108,d107,d106,d105,d104,d103,d102,d101,d100,d99,d98,d97,
        d96,d95,d94,d93,d92,d91,d90,d89,d88,d87,d86,d85,d84,d83,d82,d81,
        d80,d79,d78,d77,d76,d75,d74,d73,d72,d71,d70,d69,d68,d67,d66,d65,
        d64,d63,d62,d61,d60,d59,d58,d57,d56,d55,d54,d53,d52,d51,d50,d49,
        d48,d47,d46,d45,d44,d43,d42,d41,d40,d39,d38,d37,d36,d35,d34,d33,
        d32,d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [127:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x378i (.out(x378),.a(x371),.b(x60),.c(x65),.d(x55),.e(x47),.f(x376));  // 6 ins 1 outs level 2

    xor6 x377i (.out(x377),.a(d126),.b(x372),.c(x46),.d(x373),.e(x374),.f(x375));  // 6 ins 1 outs level 2

    xor6 x376i (.out(x376),.a(c1),.b(c17),.c(d101),.d(d96),.e(d85),.f(d48));  // 6 ins 1 outs level 1

    xor6 x375i (.out(x375),.a(c14),.b(d26),.c(d72),.d(d97),.e(c0),.f(d65));  // 6 ins 1 outs level 1

    xor6 x374i (.out(x374),.a(d81),.b(d45),.c(d116),.d(d21),.e(d47),.f(d95));  // 6 ins 1 outs level 1

    xor6 x373i (.out(x373),.a(d117),.b(d10),.c(d73),.d(d14),.e(d111),.f(c31));  // 6 ins 1 outs level 1

    xor6 x372i (.out(x372),.a(c30),.b(d31),.c(d6),.d(d67),.e(c7),.f(d58));  // 6 ins 1 outs level 1

    xor6 x371i (.out(x371),.a(d53),.b(d54),.c(c15),.d(d29),.e(d104),.f(c8));  // 6 ins 1 outs level 1

    xor6 x370i (.out(x370),.a(d107),.b(x361),.c(x70),.d(x36),.e(x45),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x369i (.out(x369),.a(x51),.b(x38),.c(x43),.d(x40),.e(x46),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x368i (.out(x368),.a(x362),.b(x367),.c(x363),.d(x364),.e(x365),.f(x366));  // 6 ins 1 outs level 2

    xor6 x367i (.out(x367),.a(c30),.b(c5),.c(d119),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x366i (.out(x366),.a(c6),.b(d37),.c(d9),.d(d35),.e(c14),.f(d102));  // 6 ins 1 outs level 1

    xor6 x365i (.out(x365),.a(d7),.b(d38),.c(d59),.d(d62),.e(d33),.f(d86));  // 6 ins 1 outs level 1

    xor6 x364i (.out(x364),.a(d85),.b(d72),.c(d113),.d(d124),.e(d49),.f(c17));  // 6 ins 1 outs level 1

    xor6 x363i (.out(x363),.a(d17),.b(c16),.c(d88),.d(d80),.e(c19),.f(d28));  // 6 ins 1 outs level 1

    xor6 x362i (.out(x362),.a(d69),.b(d94),.c(c10),.d(d11),.e(c24),.f(d74));  // 6 ins 1 outs level 1

    xor6 x361i (.out(x361),.a(d58),.b(d68),.c(c31),.d(d64),.e(d106),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x360i (.out(x360),.a(x66),.b(x43),.c(x60),.d(x34),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x359i (.out(x359),.a(x351),.b(x35),.c(x357),.d(x55),.e(x57),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x358i (.out(x358),.a(x352),.b(x51),.c(x353),.d(x354),.e(x355),.f(x356));  // 6 ins 1 outs level 2

    xor6 x357i (.out(x357),.a(d18),.b(d121),.c(d36),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x356i (.out(x356),.a(d6),.b(d32),.c(c14),.d(d16),.e(d39),.f(d14));  // 6 ins 1 outs level 1

    xor6 x355i (.out(x355),.a(d8),.b(d102),.c(d52),.d(d99),.e(c0),.f(d123));  // 6 ins 1 outs level 1

    xor6 x354i (.out(x354),.a(c3),.b(d1),.c(d94),.d(d96),.e(d37),.f(d72));  // 6 ins 1 outs level 1

    xor6 x353i (.out(x353),.a(d73),.b(d26),.c(c28),.d(d58),.e(d113),.f(c6));  // 6 ins 1 outs level 1

    xor6 x352i (.out(x352),.a(c11),.b(d119),.c(d17),.d(d85),.e(d12),.f(d51));  // 6 ins 1 outs level 1

    xor6 x351i (.out(x351),.a(d2),.b(c27),.c(c25),.d(d107),.e(d70),.f(d64));  // 6 ins 1 outs level 1

    xor6 x350i (.out(x350),.a(x342),.b(x69),.c(x34),.d(x347),.e(x348),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x349i (.out(x349),.a(x343),.b(d15),.c(x344),.d(x345),.e(x346),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x348i (.out(x348),.a(c7),.b(d101),.c(d19),.d(d81),.e(c24),.f(d32));  // 6 ins 1 outs level 1

    xor6 x347i (.out(x347),.a(d65),.b(d38),.c(d37),.d(d71),.e(d3),.f(d84));  // 6 ins 1 outs level 1

    xor6 x346i (.out(x346),.a(d122),.b(c13),.c(d14),.d(d8),.e(d52),.f(d31));  // 6 ins 1 outs level 1

    xor6 x345i (.out(x345),.a(d18),.b(d99),.c(d68),.d(d73),.e(d109),.f(c29));  // 6 ins 1 outs level 1

    xor6 x344i (.out(x344),.a(d60),.b(d17),.c(d10),.d(d86),.e(d125),.f(d111));  // 6 ins 1 outs level 1

    xor6 x343i (.out(x343),.a(d54),.b(d9),.c(d69),.d(d39),.e(d36),.f(d123));  // 6 ins 1 outs level 1

    xor6 x342i (.out(x342),.a(d115),.b(d2),.c(d89),.d(d45),.e(d103),.f(c2));  // 6 ins 1 outs level 1

    xor6 x341i (.out(x341),.a(x333),.b(x60),.c(x61),.d(x43),.e(x339),.f(x69));  // 6 ins 1 outs level 2

    xor6 x340i (.out(x340),.a(x334),.b(x55),.c(x335),.d(x336),.e(x337),.f(x338));  // 6 ins 1 outs level 2

    xor6 x339i (.out(x339),.a(d39),.b(c10),.c(c18),.d(c13),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x338i (.out(x338),.a(d109),.b(d116),.c(d86),.d(d15),.e(c7),.f(d94));  // 6 ins 1 outs level 1

    xor6 x337i (.out(x337),.a(d114),.b(d45),.c(d58),.d(d20),.e(d78),.f(d112));  // 6 ins 1 outs level 1

    xor6 x336i (.out(x336),.a(d46),.b(d65),.c(d4),.d(d47),.e(d106),.f(c31));  // 6 ins 1 outs level 1

    xor6 x335i (.out(x335),.a(d103),.b(d98),.c(c15),.d(d120),.e(d44),.f(c21));  // 6 ins 1 outs level 1

    xor6 x334i (.out(x334),.a(d49),.b(d18),.c(c20),.d(c4),.e(d113),.f(d100));  // 6 ins 1 outs level 1

    xor6 x333i (.out(x333),.a(d6),.b(d73),.c(d117),.d(d80),.e(d54),.f(c17));  // 6 ins 1 outs level 1

    xor6 x332i (.out(x332),.a(x50),.b(x59),.c(x36),.d(x66),.e(x40),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x331i (.out(x331),.a(x323),.b(x39),.c(x34),.d(x328),.e(x329),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x330i (.out(x330),.a(d39),.b(x324),.c(x67),.d(x325),.e(x326),.f(x327));  // 6 ins 1 outs level 2

    xor6 x329i (.out(x329),.a(d42),.b(d24),.c(d1),.d(c26),.e(d37),.f(d115));  // 6 ins 1 outs level 1

    xor6 x328i (.out(x328),.a(d106),.b(d122),.c(d55),.d(c3),.e(d119),.f(c15));  // 6 ins 1 outs level 1

    xor6 x327i (.out(x327),.a(d48),.b(d74),.c(d92),.d(c23),.e(d71),.f(d72));  // 6 ins 1 outs level 1

    xor6 x326i (.out(x326),.a(c19),.b(d28),.c(d54),.d(d5),.e(c10),.f(d20));  // 6 ins 1 outs level 1

    xor6 x325i (.out(x325),.a(d75),.b(d126),.c(c9),.d(d67),.e(d73),.f(d21));  // 6 ins 1 outs level 1

    xor6 x324i (.out(x324),.a(d7),.b(d127),.c(d10),.d(d64),.e(c16),.f(d0));  // 6 ins 1 outs level 1

    xor6 x323i (.out(x323),.a(d103),.b(d40),.c(d83),.d(d29),.e(d41),.f(d17));  // 6 ins 1 outs level 1

    xor6 x322i (.out(x322),.a(x313),.b(x38),.c(x32),.d(x320),.e(x55),.f(x71));  // 6 ins 1 outs level 2

    xor6 x321i (.out(x321),.a(x314),.b(x315),.c(x316),.d(x317),.e(x318),.f(x319));  // 6 ins 1 outs level 2

    xor6 x320i (.out(x320),.a(d82),.b(d76),.c(d72),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x319i (.out(x319),.a(c26),.b(d55),.c(d68),.d(c20),.e(d113),.f(d66));  // 6 ins 1 outs level 1

    xor6 x318i (.out(x318),.a(d54),.b(c21),.c(d108),.d(d115),.e(d7),.f(d14));  // 6 ins 1 outs level 1

    xor6 x317i (.out(x317),.a(c16),.b(d124),.c(c12),.d(d70),.e(d5),.f(c2));  // 6 ins 1 outs level 1

    xor6 x316i (.out(x316),.a(d126),.b(c27),.c(d65),.d(c25),.e(d4),.f(d123));  // 6 ins 1 outs level 1

    xor6 x315i (.out(x315),.a(c31),.b(d1),.c(d38),.d(d71),.e(d25),.f(d40));  // 6 ins 1 outs level 1

    xor6 x314i (.out(x314),.a(d50),.b(d60),.c(d79),.d(d73),.e(d8),.f(c9));  // 6 ins 1 outs level 1

    xor6 x313i (.out(x313),.a(d45),.b(d20),.c(d121),.d(d80),.e(d116),.f(d56));  // 6 ins 1 outs level 1

    xor6 x312i (.out(x312),.a(d59),.b(x303),.c(x59),.d(x46),.e(x40),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x311i (.out(x311),.a(x308),.b(x70),.c(x61),.d(x43),.e(x309),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x310i (.out(x310),.a(d37),.b(x304),.c(x32),.d(x305),.e(x306),.f(x307));  // 6 ins 1 outs level 2

    xor6 x309i (.out(x309),.a(d108),.b(d7),.c(c13),.d(d3),.e(d52),.f(d5));  // 6 ins 1 outs level 1

    xor6 x308i (.out(x308),.a(d124),.b(d95),.c(d10),.d(d42),.e(d126),.f(d23));  // 6 ins 1 outs level 1

    xor6 x307i (.out(x307),.a(d22),.b(d109),.c(c14),.d(d65),.e(c16),.f(d25));  // 6 ins 1 outs level 1

    xor6 x306i (.out(x306),.a(d21),.b(c2),.c(d11),.d(c9),.e(d15),.f(d111));  // 6 ins 1 outs level 1

    xor6 x305i (.out(x305),.a(d69),.b(d43),.c(d45),.d(c12),.e(d12),.f(c28));  // 6 ins 1 outs level 1

    xor6 x304i (.out(x304),.a(d71),.b(d106),.c(d75),.d(d56),.e(d39),.f(d28));  // 6 ins 1 outs level 1

    xor6 x303i (.out(x303),.a(c10),.b(c17),.c(d32),.d(c20),.e(d57),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x302i (.out(x302),.a(x59),.b(x67),.c(x46),.d(x60),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x301i (.out(x301),.a(d23),.b(x293),.c(d10),.d(x57),.e(x47),.f(x298));  // 6 ins 1 outs level 2

    xor6 x300i (.out(x300),.a(x294),.b(x68),.c(x40),.d(x295),.e(x296),.f(x297));  // 6 ins 1 outs level 2

    xor6 x298i (.out(x298),.a(d16),.b(c17),.c(d109),.d(d42),.e(d69),.f(d112));  // 6 ins 1 outs level 1

    xor6 x297i (.out(x297),.a(d101),.b(d82),.c(d70),.d(d105),.e(d103),.f(d22));  // 6 ins 1 outs level 1

    xor6 x296i (.out(x296),.a(d76),.b(d66),.c(d12),.d(d68),.e(d37),.f(d52));  // 6 ins 1 outs level 1

    xor6 x295i (.out(x295),.a(d126),.b(d40),.c(c13),.d(d1),.e(d45),.f(c5));  // 6 ins 1 outs level 1

    xor6 x294i (.out(x294),.a(d78),.b(d95),.c(d11),.d(c11),.e(c20),.f(c24));  // 6 ins 1 outs level 1

    xor6 x293i (.out(x293),.a(d88),.b(d113),.c(d3),.d(c10),.e(d85),.f(d93));  // 6 ins 1 outs level 1

    xor6 x292i (.out(x292),.a(d61),.b(x282),.c(x66),.d(x43),.e(x61),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x291i (.out(x291),.a(d23),.b(x48),.c(x55),.d(x35),.e(x47),.f(c17));  // 6 ins 1 outs level 2

    xor6 x290i (.out(x290),.a(x283),.b(x284),.c(x285),.d(x286),.e(x287),.f(x288));  // 6 ins 1 outs level 2

    xor6 x288i (.out(x288),.a(d117),.b(d36),.c(d52),.d(d120),.e(d51),.f(c23));  // 6 ins 1 outs level 1

    xor6 x287i (.out(x287),.a(d34),.b(d77),.c(d104),.d(d64),.e(d115),.f(d58));  // 6 ins 1 outs level 1

    xor6 x286i (.out(x286),.a(d33),.b(c8),.c(d76),.d(d35),.e(d88),.f(d63));  // 6 ins 1 outs level 1

    xor6 x285i (.out(x285),.a(c6),.b(d47),.c(d50),.d(d108),.e(d67),.f(d46));  // 6 ins 1 outs level 1

    xor6 x284i (.out(x284),.a(d38),.b(d18),.c(d60),.d(d96),.e(c12),.f(d30));  // 6 ins 1 outs level 1

    xor6 x283i (.out(x283),.a(d89),.b(d1),.c(d106),.d(d28),.e(d66),.f(d3));  // 6 ins 1 outs level 1

    xor6 x282i (.out(x282),.a(d4),.b(d80),.c(d85),.d(d39),.e(d109),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x281i (.out(x281),.a(x69),.b(x65),.c(x53),.d(x48),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x280i (.out(x280),.a(x277),.b(x57),.c(x36),.d(x32),.e(x278),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x279i (.out(x279),.a(x272),.b(x42),.c(x273),.d(x274),.e(x275),.f(x276));  // 6 ins 1 outs level 2

    xor6 x278i (.out(x278),.a(d39),.b(d25),.c(d16),.d(d117),.e(d52),.f(d19));  // 6 ins 1 outs level 1

    xor6 x277i (.out(x277),.a(d120),.b(c11),.c(d102),.d(d2),.e(d106),.f(d94));  // 6 ins 1 outs level 1

    xor6 x276i (.out(x276),.a(d42),.b(d88),.c(d126),.d(d77),.e(d107),.f(c26));  // 6 ins 1 outs level 1

    xor6 x275i (.out(x275),.a(d115),.b(d98),.c(d83),.d(d81),.e(d58),.f(d31));  // 6 ins 1 outs level 1

    xor6 x274i (.out(x274),.a(c30),.b(d36),.c(d101),.d(c20),.e(d80),.f(c31));  // 6 ins 1 outs level 1

    xor6 x273i (.out(x273),.a(d124),.b(d62),.c(d56),.d(d28),.e(d32),.f(d127));  // 6 ins 1 outs level 1

    xor6 x272i (.out(x272),.a(d13),.b(c10),.c(d59),.d(d63),.e(d60),.f(d105));  // 6 ins 1 outs level 1

    xor6 x271i (.out(x271),.a(x262),.b(x37),.c(x35),.d(x269),.e(x43),.f(x65));  // 6 ins 1 outs level 2

    xor6 x270i (.out(x270),.a(x263),.b(x264),.c(x265),.d(x266),.e(x267),.f(x268));  // 6 ins 1 outs level 2

    xor6 x269i (.out(x269),.a(d48),.b(d91),.c(d102),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x268i (.out(x268),.a(d117),.b(d36),.c(d94),.d(d82),.e(d31),.f(d7));  // 6 ins 1 outs level 1

    xor6 x267i (.out(x267),.a(c28),.b(d71),.c(d45),.d(d64),.e(c15),.f(d47));  // 6 ins 1 outs level 1

    xor6 x266i (.out(x266),.a(d103),.b(d41),.c(d26),.d(d65),.e(d110),.f(c21));  // 6 ins 1 outs level 1

    xor6 x265i (.out(x265),.a(c29),.b(d16),.c(d40),.d(d125),.e(d83),.f(d4));  // 6 ins 1 outs level 1

    xor6 x264i (.out(x264),.a(c11),.b(d79),.c(d90),.d(d17),.e(d107),.f(d73));  // 6 ins 1 outs level 1

    xor6 x263i (.out(x263),.a(d20),.b(d59),.c(d57),.d(d43),.e(d33),.f(d44));  // 6 ins 1 outs level 1

    xor6 x262i (.out(x262),.a(d74),.b(d54),.c(d69),.d(d25),.e(d51),.f(d28));  // 6 ins 1 outs level 1

    xor6 x261i (.out(x261),.a(x252),.b(x51),.c(x34),.d(x41),.e(x33),.f(x40));  // 6 ins 1 outs level 2

    xor6 x260i (.out(x260),.a(x258),.b(x63),.c(x66),.d(x53),.e(x43),.f(x48));  // 6 ins 1 outs level 2

    xor6 x259i (.out(x259),.a(x253),.b(x67),.c(x254),.d(x255),.e(x256),.f(x257));  // 6 ins 1 outs level 2

    xor6 x258i (.out(x258),.a(d18),.b(c5),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x257i (.out(x257),.a(d41),.b(c19),.c(d80),.d(d21),.e(d108),.f(d6));  // 6 ins 1 outs level 1

    xor6 x256i (.out(x256),.a(d54),.b(d127),.c(d75),.d(d95),.e(d0),.f(c26));  // 6 ins 1 outs level 1

    xor6 x255i (.out(x255),.a(d69),.b(d111),.c(d42),.d(d91),.e(d99),.f(c17));  // 6 ins 1 outs level 1

    xor6 x254i (.out(x254),.a(d55),.b(d96),.c(d57),.d(c20),.e(c13),.f(d73));  // 6 ins 1 outs level 1

    xor6 x253i (.out(x253),.a(d107),.b(c15),.c(d2),.d(d44),.e(d49),.f(d122));  // 6 ins 1 outs level 1

    xor6 x252i (.out(x252),.a(d30),.b(d31),.c(c12),.d(d74),.e(d46),.f(d77));  // 6 ins 1 outs level 1

    xor6 x251i (.out(x251),.a(x242),.b(x47),.c(x41),.d(x249),.e(x53),.f(x71));  // 6 ins 1 outs level 2

    xor6 x250i (.out(x250),.a(x243),.b(x244),.c(x245),.d(x246),.e(x247),.f(x248));  // 6 ins 1 outs level 2

    xor6 x249i (.out(x249),.a(c1),.b(d16),.c(d99),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x248i (.out(x248),.a(d60),.b(d72),.c(d112),.d(d6),.e(d82),.f(d55));  // 6 ins 1 outs level 1

    xor6 x247i (.out(x247),.a(c6),.b(d103),.c(d21),.d(d87),.e(d74),.f(d7));  // 6 ins 1 outs level 1

    xor6 x246i (.out(x246),.a(d25),.b(d88),.c(c7),.d(d13),.e(d42),.f(d83));  // 6 ins 1 outs level 1

    xor6 x245i (.out(x245),.a(d106),.b(d63),.c(d93),.d(d14),.e(d54),.f(d22));  // 6 ins 1 outs level 1

    xor6 x244i (.out(x244),.a(c21),.b(d48),.c(d111),.d(d10),.e(d19),.f(d31));  // 6 ins 1 outs level 1

    xor6 x243i (.out(x243),.a(d110),.b(c27),.c(d57),.d(c2),.e(d97),.f(d2));  // 6 ins 1 outs level 1

    xor6 x242i (.out(x242),.a(d18),.b(d1),.c(c16),.d(d122),.e(d98),.f(c13));  // 6 ins 1 outs level 1

    xor6 x241i (.out(x241),.a(x232),.b(x60),.c(x68),.d(x45),.e(x32),.f(x42));  // 6 ins 1 outs level 2

    xor6 x240i (.out(x240),.a(x238),.b(x40),.c(x38),.d(x34),.e(x37),.f(x35));  // 6 ins 1 outs level 2

    xor6 x239i (.out(x239),.a(x233),.b(x48),.c(x234),.d(x235),.e(x236),.f(x237));  // 6 ins 1 outs level 2

    xor6 x238i (.out(x238),.a(d23),.b(d73),.c(d7),.d(d121),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x237i (.out(x237),.a(c14),.b(c27),.c(d4),.d(d53),.e(d123),.f(d56));  // 6 ins 1 outs level 1

    xor6 x236i (.out(x236),.a(d15),.b(c13),.c(c23),.d(d116),.e(d75),.f(d32));  // 6 ins 1 outs level 1

    xor6 x235i (.out(x235),.a(d49),.b(d79),.c(d2),.d(c25),.e(d48),.f(d3));  // 6 ins 1 outs level 1

    xor6 x234i (.out(x234),.a(d11),.b(d44),.c(d9),.d(d14),.e(d20),.f(c3));  // 6 ins 1 outs level 1

    xor6 x233i (.out(x233),.a(d111),.b(d70),.c(d17),.d(d19),.e(c21),.f(d59));  // 6 ins 1 outs level 1

    xor6 x232i (.out(x232),.a(d107),.b(d119),.c(d82),.d(d52),.e(d65),.f(d103));  // 6 ins 1 outs level 1

    xor6 x231i (.out(x231),.a(x229),.b(x68),.c(x46),.d(x36),.e(x37),.f(x32));  // 6 ins 1 outs level 2

    xor6 x230i (.out(x230),.a(x223),.b(x224),.c(x225),.d(x226),.e(x227),.f(x228));  // 6 ins 1 outs level 2

    xor6 x229i (.out(x229),.a(d18),.b(d45),.c(d53),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x228i (.out(x228),.a(d21),.b(d4),.c(d74),.d(d15),.e(d52),.f(d62));  // 6 ins 1 outs level 1

    xor6 x227i (.out(x227),.a(d9),.b(d72),.c(c24),.d(d30),.e(d44),.f(d113));  // 6 ins 1 outs level 1

    xor6 x226i (.out(x226),.a(d64),.b(d105),.c(d116),.d(d94),.e(d20),.f(d78));  // 6 ins 1 outs level 1

    xor6 x225i (.out(x225),.a(d49),.b(c5),.c(d112),.d(d5),.e(d57),.f(d95));  // 6 ins 1 outs level 1

    xor6 x224i (.out(x224),.a(d66),.b(d3),.c(d111),.d(d71),.e(d99),.f(d83));  // 6 ins 1 outs level 1

    xor6 x223i (.out(x223),.a(c4),.b(d12),.c(d100),.d(d90),.e(d1),.f(d24));  // 6 ins 1 outs level 1

    xor6 x222i (.out(x222),.a(d55),.b(d58),.c(c18),.d(c3),.e(d114),.f(c28));  // 6 ins 1 outs level 1

    xor6 x221i (.out(x221),.a(x60),.b(x38),.c(x53),.d(x40),.e(x43),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x220i (.out(x220),.a(x50),.b(x42),.c(x214),.d(x67),.e(x55),.f(x33));  // 6 ins 1 outs level 2

    xor6 x219i (.out(x219),.a(x215),.b(d61),.c(x70),.d(x216),.e(x217),.f(x218));  // 6 ins 1 outs level 2

    xor6 x218i (.out(x218),.a(d104),.b(d53),.c(c23),.d(d35),.e(c15),.f(c6));  // 6 ins 1 outs level 1

    xor6 x217i (.out(x217),.a(d57),.b(d32),.c(d90),.d(d50),.e(d107),.f(c16));  // 6 ins 1 outs level 1

    xor6 x216i (.out(x216),.a(d46),.b(c20),.c(c8),.d(d56),.e(d22),.f(d8));  // 6 ins 1 outs level 1

    xor6 x215i (.out(x215),.a(d78),.b(d75),.c(d66),.d(d112),.e(c1),.f(d97));  // 6 ins 1 outs level 1

    xor6 x214i (.out(x214),.a(d49),.b(d96),.c(d77),.d(c19),.e(d89),.f(d106));  // 6 ins 1 outs level 1

    xor6 x213i (.out(x213),.a(x206),.b(x65),.c(x49),.d(x41),.e(x211),.f(x68));  // 6 ins 1 outs level 2

    xor6 x212i (.out(x212),.a(x207),.b(x51),.c(x50),.d(x208),.e(x209),.f(x210));  // 6 ins 1 outs level 2

    xor6 x211i (.out(x211),.a(d36),.b(d18),.c(d23),.d(d30),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x210i (.out(x210),.a(d50),.b(d112),.c(d89),.d(d98),.e(c7),.f(d106));  // 6 ins 1 outs level 1

    xor6 x209i (.out(x209),.a(c14),.b(d6),.c(d116),.d(d19),.e(d5),.f(d22));  // 6 ins 1 outs level 1

    xor6 x208i (.out(x208),.a(d69),.b(d80),.c(c4),.d(d55),.e(d13),.f(c29));  // 6 ins 1 outs level 1

    xor6 x207i (.out(x207),.a(d87),.b(d90),.c(d56),.d(d79),.e(d100),.f(c10));  // 6 ins 1 outs level 1

    xor6 x206i (.out(x206),.a(c16),.b(d105),.c(d125),.d(c20),.e(d66),.f(d44));  // 6 ins 1 outs level 1

    xor6 x205i (.out(x205),.a(x47),.b(x32),.c(x39),.d(x45),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x204i (.out(x204),.a(x195),.b(x33),.c(x202),.d(x37),.e(x201),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x203i (.out(x203),.a(x196),.b(x63),.c(x197),.d(x198),.e(x199),.f(x200));  // 6 ins 1 outs level 2

    xor6 x202i (.out(x202),.a(d23),.b(d126),.c(d24),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x201i (.out(x201),.a(d68),.b(d80),.c(c16),.d(d96),.e(d14),.f(d84));  // 6 ins 1 outs level 1

    xor6 x200i (.out(x200),.a(d77),.b(c5),.c(d123),.d(c27),.e(d102),.f(d107));  // 6 ins 1 outs level 1

    xor6 x199i (.out(x199),.a(d101),.b(d53),.c(d86),.d(d76),.e(c7),.f(d85));  // 6 ins 1 outs level 1

    xor6 x198i (.out(x198),.a(d92),.b(d117),.c(c0),.d(d89),.e(d79),.f(d34));  // 6 ins 1 outs level 1

    xor6 x197i (.out(x197),.a(d39),.b(d10),.c(d88),.d(d70),.e(d2),.f(d99));  // 6 ins 1 outs level 1

    xor6 x196i (.out(x196),.a(d26),.b(d46),.c(d118),.d(d59),.e(c30),.f(d7));  // 6 ins 1 outs level 1

    xor6 x195i (.out(x195),.a(d119),.b(c22),.c(d113),.d(d31),.e(c21),.f(d81));  // 6 ins 1 outs level 1

    xor6 x194i (.out(x194),.a(x185),.b(x47),.c(x69),.d(x38),.e(x45),.f(x192));  // 6 ins 1 outs level 2

    xor6 x193i (.out(x193),.a(x186),.b(x187),.c(x188),.d(x189),.e(x190),.f(x191));  // 6 ins 1 outs level 2

    xor6 x192i (.out(x192),.a(c22),.b(d102),.c(d35),.d(d108),.e(d86),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x191i (.out(x191),.a(d87),.b(d11),.c(d77),.d(d98),.e(d7),.f(d118));  // 6 ins 1 outs level 1

    xor6 x190i (.out(x190),.a(d94),.b(d92),.c(d16),.d(d20),.e(d22),.f(d27));  // 6 ins 1 outs level 1

    xor6 x189i (.out(x189),.a(d85),.b(d51),.c(d38),.d(d124),.e(d70),.f(d95));  // 6 ins 1 outs level 1

    xor6 x188i (.out(x188),.a(d49),.b(d60),.c(d29),.d(c24),.e(d89),.f(d107));  // 6 ins 1 outs level 1

    xor6 x187i (.out(x187),.a(d71),.b(c12),.c(c19),.d(d106),.e(d24),.f(c17));  // 6 ins 1 outs level 1

    xor6 x186i (.out(x186),.a(c9),.b(d28),.c(d47),.d(d6),.e(c27),.f(c31));  // 6 ins 1 outs level 1

    xor6 x185i (.out(x185),.a(c26),.b(d122),.c(d127),.d(d123),.e(d113),.f(d103));  // 6 ins 1 outs level 1

    xor6 x184i (.out(x184),.a(x176),.b(x69),.c(x36),.d(x182),.e(x40),.f(x46));  // 6 ins 1 outs level 2

    xor6 x183i (.out(x183),.a(x177),.b(x47),.c(x178),.d(x179),.e(x180),.f(x181));  // 6 ins 1 outs level 2

    xor6 x182i (.out(x182),.a(c24),.b(d23),.c(d39),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x181i (.out(x181),.a(d106),.b(d124),.c(d30),.d(c26),.e(d109),.f(d41));  // 6 ins 1 outs level 1

    xor6 x180i (.out(x180),.a(d70),.b(d86),.c(d101),.d(d103),.e(c11),.f(c12));  // 6 ins 1 outs level 1

    xor6 x179i (.out(x179),.a(d8),.b(d91),.c(d81),.d(d12),.e(d98),.f(d115));  // 6 ins 1 outs level 1

    xor6 x178i (.out(x178),.a(d72),.b(d36),.c(c5),.d(d32),.e(d26),.f(d108));  // 6 ins 1 outs level 1

    xor6 x177i (.out(x177),.a(c28),.b(c23),.c(d88),.d(d52),.e(d21),.f(d99));  // 6 ins 1 outs level 1

    xor6 x176i (.out(x176),.a(d93),.b(d110),.c(d40),.d(c13),.e(d48),.f(c19));  // 6 ins 1 outs level 1

    xor6 x175i (.out(x175),.a(x48),.b(x63),.c(x53),.d(x39),.e(x40),.f(x42));  // 6 ins 1 outs level 2

    xor6 x174i (.out(x174),.a(x168),.b(x173),.c(x169),.d(x170),.e(x171),.f(x172));  // 6 ins 1 outs level 2

    xor6 x173i (.out(x173),.a(d126),.b(d115),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x172i (.out(x172),.a(d9),.b(d75),.c(d62),.d(d83),.e(d17),.f(c3));  // 6 ins 1 outs level 1

    xor6 x171i (.out(x171),.a(d108),.b(c12),.c(d56),.d(d49),.e(d91),.f(c24));  // 6 ins 1 outs level 1

    xor6 x170i (.out(x170),.a(d114),.b(d18),.c(d27),.d(c25),.e(d86),.f(c11));  // 6 ins 1 outs level 1

    xor6 x169i (.out(x169),.a(d24),.b(d110),.c(d34),.d(d104),.e(c8),.f(c18));  // 6 ins 1 outs level 1

    xor6 x168i (.out(x168),.a(d15),.b(d53),.c(d37),.d(d40),.e(d31),.f(d10));  // 6 ins 1 outs level 1

    xor6 x167i (.out(x167),.a(c28),.b(d80),.c(d121),.d(d13),.e(d81),.f(d47));  // 6 ins 1 outs level 1

    xor6 x166i (.out(x166),.a(x38),.b(x65),.c(x70),.d(x42),.e(x46),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x165i (.out(x165),.a(x157),.b(x57),.c(x43),.d(x39),.e(x32),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x164i (.out(x164),.a(x158),.b(x163),.c(x159),.d(x160),.e(x161),.f(x162));  // 6 ins 1 outs level 2

    xor6 x163i (.out(x163),.a(d36),.b(d23),.c(d27),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x162i (.out(x162),.a(d108),.b(c19),.c(d101),.d(d58),.e(c26),.f(d103));  // 6 ins 1 outs level 1

    xor6 x161i (.out(x161),.a(d98),.b(d92),.c(d121),.d(c12),.e(d90),.f(c18));  // 6 ins 1 outs level 1

    xor6 x160i (.out(x160),.a(d11),.b(d52),.c(d43),.d(d44),.e(d74),.f(d65));  // 6 ins 1 outs level 1

    xor6 x159i (.out(x159),.a(d41),.b(c27),.c(c3),.d(c25),.e(d50),.f(d114));  // 6 ins 1 outs level 1

    xor6 x158i (.out(x158),.a(d75),.b(d85),.c(d62),.d(d48),.e(d37),.f(d19));  // 6 ins 1 outs level 1

    xor6 x157i (.out(x157),.a(d93),.b(d18),.c(d123),.d(d96),.e(d45),.f(d109));  // 6 ins 1 outs level 1

    xor6 x156i (.out(x156),.a(x148),.b(x63),.c(x51),.d(x59),.e(x38),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x155i (.out(x155),.a(x152),.b(x46),.c(x42),.d(x34),.e(x50),.f(x153));  // 6 ins 1 outs level 2

    xor6 x154i (.out(x154),.a(x149),.b(x48),.c(x35),.d(x32),.e(x150),.f(x151));  // 6 ins 1 outs level 2

    xor6 x153i (.out(x153),.a(d102),.b(d69),.c(d126),.d(d109),.e(d79),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x152i (.out(x152),.a(d36),.b(d86),.c(d117),.d(d120),.e(d82),.f(d90));  // 6 ins 1 outs level 1

    xor6 x151i (.out(x151),.a(d127),.b(d39),.c(d17),.d(c26),.e(d72),.f(d42));  // 6 ins 1 outs level 1

    xor6 x150i (.out(x150),.a(d74),.b(c31),.c(d20),.d(c22),.e(d118),.f(d38));  // 6 ins 1 outs level 1

    xor6 x149i (.out(x149),.a(d6),.b(d31),.c(c15),.d(d54),.e(d13),.f(d48));  // 6 ins 1 outs level 1

    xor6 x148i (.out(x148),.a(d101),.b(d84),.c(d71),.d(d62),.e(d105),.f(c24));  // 6 ins 1 outs level 1

    xor6 x147i (.out(x147),.a(x139),.b(x70),.c(x47),.d(x55),.e(x36),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x146i (.out(x146),.a(x33),.b(x40),.c(x60),.d(x34),.e(x51),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x145i (.out(x145),.a(d39),.b(x140),.c(x141),.d(x142),.e(x143),.f(x144));  // 6 ins 1 outs level 2

    xor6 x144i (.out(x144),.a(d36),.b(d104),.c(d18),.d(d55),.e(d16),.f(c2));  // 6 ins 1 outs level 1

    xor6 x143i (.out(x143),.a(d60),.b(c16),.c(d66),.d(d40),.e(d59),.f(d84));  // 6 ins 1 outs level 1

    xor6 x142i (.out(x142),.a(d14),.b(d10),.c(d17),.d(c5),.e(d98),.f(d112));  // 6 ins 1 outs level 1

    xor6 x141i (.out(x141),.a(d2),.b(d0),.c(d43),.d(d48),.e(d92),.f(d91));  // 6 ins 1 outs level 1

    xor6 x140i (.out(x140),.a(d90),.b(c31),.c(d74),.d(d70),.e(d76),.f(d20));  // 6 ins 1 outs level 1

    xor6 x139i (.out(x139),.a(c8),.b(d57),.c(d81),.d(d7),.e(c14),.f(d86));  // 6 ins 1 outs level 1

    xor6 x138i (.out(x138),.a(x48),.b(x50),.c(x71),.d(x49),.e(x38),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x137i (.out(x137),.a(x131),.b(x63),.c(x68),.d(x32),.e(x39),.f(x37));  // 6 ins 1 outs level 2

    xor6 x136i (.out(x136),.a(x132),.b(d18),.c(x33),.d(x133),.e(x134),.f(x135));  // 6 ins 1 outs level 2

    xor6 x135i (.out(x135),.a(d102),.b(c3),.c(d50),.d(d36),.e(d126),.f(c7));  // 6 ins 1 outs level 1

    xor6 x134i (.out(x134),.a(d124),.b(d42),.c(d28),.d(c11),.e(d77),.f(d47));  // 6 ins 1 outs level 1

    xor6 x133i (.out(x133),.a(d93),.b(d37),.c(d56),.d(d86),.e(d106),.f(d44));  // 6 ins 1 outs level 1

    xor6 x132i (.out(x132),.a(d8),.b(d17),.c(d113),.d(d40),.e(c0),.f(d94));  // 6 ins 1 outs level 1

    xor6 x131i (.out(x131),.a(c10),.b(c2),.c(d3),.d(d90),.e(c23),.f(d0));  // 6 ins 1 outs level 1

    xor6 x130i (.out(x130),.a(x123),.b(x37),.c(x50),.d(x57),.e(x45),.f(x33));  // 6 ins 1 outs level 2

    xor6 x129i (.out(x129),.a(x124),.b(x49),.c(x128),.d(x125),.e(x126),.f(x127));  // 6 ins 1 outs level 2

    xor6 x128i (.out(x128),.a(d23),.b(d18),.c(d39),.d(d126),.e(d10),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x127i (.out(x127),.a(d20),.b(d78),.c(d105),.d(d44),.e(d80),.f(d98));  // 6 ins 1 outs level 1

    xor6 x126i (.out(x126),.a(d25),.b(d26),.c(d90),.d(d61),.e(d4),.f(c4));  // 6 ins 1 outs level 1

    xor6 x125i (.out(x125),.a(d108),.b(c12),.c(d3),.d(d41),.e(c21),.f(d24));  // 6 ins 1 outs level 1

    xor6 x124i (.out(x124),.a(d62),.b(d50),.c(d8),.d(d35),.e(d100),.f(c14));  // 6 ins 1 outs level 1

    xor6 x123i (.out(x123),.a(d60),.b(d79),.c(d28),.d(d58),.e(d66),.f(d9));  // 6 ins 1 outs level 1

    xor6 x122i (.out(x122),.a(x112),.b(d87),.c(x60),.d(x47),.e(x42),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x121i (.out(x121),.a(x118),.b(x37),.c(x33),.d(x119),.e(x43),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x120i (.out(x120),.a(x113),.b(x50),.c(x114),.d(x115),.e(x116),.f(x117));  // 6 ins 1 outs level 2

    xor6 x119i (.out(x119),.a(c9),.b(c16),.c(d77),.d(d39),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x118i (.out(x118),.a(c17),.b(d55),.c(d89),.d(d60),.e(c27),.f(c5));  // 6 ins 1 outs level 1

    xor6 x117i (.out(x117),.a(d105),.b(d112),.c(d106),.d(d21),.e(d4),.f(d113));  // 6 ins 1 outs level 1

    xor6 x116i (.out(x116),.a(d122),.b(d11),.c(d40),.d(d90),.e(d127),.f(d92));  // 6 ins 1 outs level 1

    xor6 x115i (.out(x115),.a(d123),.b(d45),.c(d20),.d(d74),.e(d78),.f(c31));  // 6 ins 1 outs level 1

    xor6 x114i (.out(x114),.a(d23),.b(d5),.c(d67),.d(c0),.e(c2),.f(d80));  // 6 ins 1 outs level 1

    xor6 x113i (.out(x113),.a(d28),.b(c3),.c(d109),.d(d62),.e(d12),.f(d93));  // 6 ins 1 outs level 1

    xor6 x112i (.out(x112),.a(d53),.b(d85),.c(d42),.d(d119),.e(d25),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x111i (.out(x111),.a(x103),.b(x109),.c(x38),.d(x47),.e(x69),.f(x108));  // 6 ins 1 outs level 2

    xor6 x110i (.out(x110),.a(x104),.b(x71),.c(x45),.d(x105),.e(x106),.f(x107));  // 6 ins 1 outs level 2

    xor6 x109i (.out(x109),.a(d44),.b(d26),.c(d41),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x108i (.out(x108),.a(d92),.b(d63),.c(d106),.d(d2),.e(d86),.f(d113));  // 6 ins 1 outs level 1

    xor6 x107i (.out(x107),.a(d56),.b(c17),.c(d57),.d(d107),.e(d27),.f(d83));  // 6 ins 1 outs level 1

    xor6 x106i (.out(x106),.a(d91),.b(d30),.c(c26),.d(d99),.e(d122),.f(c19));  // 6 ins 1 outs level 1

    xor6 x105i (.out(x105),.a(c6),.b(c24),.c(c27),.d(d32),.e(d69),.f(d22));  // 6 ins 1 outs level 1

    xor6 x104i (.out(x104),.a(d124),.b(d94),.c(d20),.d(d78),.e(c3),.f(d49));  // 6 ins 1 outs level 1

    xor6 x103i (.out(x103),.a(c13),.b(d46),.c(d123),.d(d110),.e(d43),.f(d61));  // 6 ins 1 outs level 1

    xor6 x102i (.out(x102),.a(x100),.b(x71),.c(x42),.d(x38),.e(x37),.f(x36));  // 6 ins 1 outs level 2

    xor6 x101i (.out(x101),.a(x94),.b(x95),.c(x96),.d(x97),.e(x98),.f(x99));  // 6 ins 1 outs level 2

    xor6 x100i (.out(x100),.a(d23),.b(c24),.c(d79),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x99i (.out(x99),.a(d65),.b(c21),.c(d108),.d(d27),.e(d101),.f(d111));  // 6 ins 1 outs level 1

    xor6 x98i (.out(x98),.a(c19),.b(d91),.c(d57),.d(d28),.e(d34),.f(d75));  // 6 ins 1 outs level 1

    xor6 x97i (.out(x97),.a(d7),.b(d114),.c(d50),.d(c17),.e(d122),.f(d60));  // 6 ins 1 outs level 1

    xor6 x96i (.out(x96),.a(d41),.b(d84),.c(c12),.d(d78),.e(d63),.f(c0));  // 6 ins 1 outs level 1

    xor6 x95i (.out(x95),.a(d117),.b(d69),.c(d3),.d(d13),.e(d70),.f(c7));  // 6 ins 1 outs level 1

    xor6 x94i (.out(x94),.a(d80),.b(c30),.c(d112),.d(c18),.e(d94),.f(d31));  // 6 ins 1 outs level 1

    xor6 x93i (.out(x93),.a(c14),.b(d116),.c(d45),.d(c13),.e(c5),.f(d82));  // 6 ins 1 outs level 1

    xor6 x92i (.out(x92),.a(x83),.b(d1),.c(x51),.d(x39),.e(x36),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x91i (.out(x91),.a(x89),.b(x65),.c(x47),.d(x42),.e(x48),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x90i (.out(x90),.a(x84),.b(x59),.c(x85),.d(x86),.e(x87),.f(x88));  // 6 ins 1 outs level 2

    xor6 x89i (.out(x89),.a(d115),.b(d126),.c(d104),.d(c8),.e(d121),.f(d35));  // 6 ins 1 outs level 1

    xor6 x88i (.out(x88),.a(d63),.b(d30),.c(d108),.d(d109),.e(d64),.f(d47));  // 6 ins 1 outs level 1

    xor6 x87i (.out(x87),.a(d42),.b(d7),.c(c25),.d(d24),.e(d0),.f(d45));  // 6 ins 1 outs level 1

    xor6 x86i (.out(x86),.a(d112),.b(d83),.c(d70),.d(d10),.e(d54),.f(d23));  // 6 ins 1 outs level 1

    xor6 x85i (.out(x85),.a(d22),.b(c3),.c(d102),.d(d53),.e(c28),.f(d116));  // 6 ins 1 outs level 1

    xor6 x84i (.out(x84),.a(d43),.b(c12),.c(d48),.d(c10),.e(d58),.f(c6));  // 6 ins 1 outs level 1

    xor6 x83i (.out(x83),.a(d111),.b(d4),.c(d51),.d(c15),.e(d79),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x82i (.out(x82),.a(x48),.b(x42),.c(x63),.d(x55),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x81i (.out(x81),.a(x73),.b(x38),.c(x77),.d(x78),.e(x79),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x80i (.out(x80),.a(x74),.b(x59),.c(x35),.d(x53),.e(x75),.f(x76));  // 6 ins 1 outs level 2

    xor6 x79i (.out(x79),.a(d94),.b(d82),.c(d126),.d(d23),.e(d62),.f(d72));  // 6 ins 1 outs level 1

    xor6 x78i (.out(x78),.a(d25),.b(d60),.c(d77),.d(d103),.e(d78),.f(d27));  // 6 ins 1 outs level 1

    xor6 x77i (.out(x77),.a(d53),.b(d49),.c(d44),.d(d31),.e(c17),.f(d64));  // 6 ins 1 outs level 1

    xor6 x76i (.out(x76),.a(c22),.b(d24),.c(c26),.d(d36),.e(c20),.f(d55));  // 6 ins 1 outs level 1

    xor6 x75i (.out(x75),.a(d112),.b(d122),.c(c31),.d(d92),.e(d33),.f(c9));  // 6 ins 1 outs level 1

    xor6 x74i (.out(x74),.a(d67),.b(c23),.c(c29),.d(d11),.e(d118),.f(d87));  // 6 ins 1 outs level 1

    xor6 x73i (.out(x73),.a(d116),.b(d28),.c(d57),.d(d125),.e(d26),.f(d66));  // 6 ins 1 outs level 1

    xor6 x72i (.out(x72),.a(x37),.b(d80),.c(d78),.d(d20),.e(d45),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x71i (.out(x71),.a(d64),.b(d62),.c(d75),.d(d51),.e(d21),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x70i (.out(x70),.a(d110),.b(d103),.c(d105),.d(d0),.e(d47),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x69i (.out(x69),.a(d25),.b(d95),.c(d33),.d(d90),.e(d40),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x68i (.out(x68),.a(d89),.b(d84),.c(d33),.d(d83),.e(d88),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x67i (.out(x67),.a(d107),.b(d17),.c(d79),.d(d4),.e(1'b0),.f(1'b0));  // 4 ins 5 outs level 1

    xor6 x66i (.out(x66),.a(d53),.b(d63),.c(d44),.d(d13),.e(c31),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x65i (.out(x65),.a(c5),.b(d14),.c(d66),.d(d0),.e(c23),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x64i (.out(x64),.a(d119),.b(c3),.c(x37),.d(d53),.e(d123),.f(1'b0));  // 5 ins 2 outs level 2

    xor6 x63i (.out(x63),.a(c7),.b(d15),.c(d105),.d(c6),.e(1'b0),.f(1'b0));  // 4 ins 8 outs level 1

    xor6 x62i (.out(x62),.a(c21),.b(x35),.c(d25),.d(d44),.e(d103),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x61i (.out(x61),.a(d2),.b(d41),.c(d29),.d(d74),.e(d11),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x60i (.out(x60),.a(d118),.b(d63),.c(c22),.d(d43),.e(1'b0),.f(1'b0));  // 4 ins 9 outs level 1

    xor6 x59i (.out(x59),.a(c30),.b(d65),.c(d87),.d(d46),.e(d93),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x58i (.out(x58),.a(c3),.b(x39),.c(d21),.d(d106),.e(d37),.f(1'b0));  // 5 ins 4 outs level 2

    xor6 x57i (.out(x57),.a(d75),.b(d89),.c(d35),.d(d88),.e(d73),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x56i (.out(x56),.a(c12),.b(d124),.c(d7),.d(d108),.e(x51),.f(1'b0));  // 5 ins 5 outs level 2

    xor6 x55i (.out(x55),.a(d84),.b(d83),.c(d30),.d(d43),.e(d127),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x54i (.out(x54),.a(d78),.b(d70),.c(d69),.d(x33),.e(d3),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x53i (.out(x53),.a(d86),.b(d102),.c(c14),.d(d109),.e(d5),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x52i (.out(x52),.a(c30),.b(d22),.c(d42),.d(x41),.e(d107),.f(1'b0));  // 5 ins 5 outs level 2

    xor6 x51i (.out(x51),.a(d85),.b(d101),.c(d27),.d(d56),.e(d1),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x50i (.out(x50),.a(d19),.b(d91),.c(d111),.d(d48),.e(d49),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x49i (.out(x49),.a(d0),.b(d38),.c(d57),.d(d67),.e(d31),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x48i (.out(x48),.a(c21),.b(c19),.c(d81),.d(c0),.e(d71),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x47i (.out(x47),.a(d114),.b(d32),.c(c18),.d(c10),.e(d28),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x46i (.out(x46),.a(d60),.b(d16),.c(d50),.d(d34),.e(d119),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x45i (.out(x45),.a(c11),.b(d6),.c(d81),.d(d93),.e(d112),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x44i (.out(x44),.a(d77),.b(x34),.c(d8),.d(c16),.e(d54),.f(1'b0));  // 5 ins 10 outs level 2

    xor6 x43i (.out(x43),.a(d79),.b(d24),.c(d98),.d(d68),.e(d12),.f(1'b0));  // 5 ins 12 outs level 1

    xor6 x42i (.out(x42),.a(d124),.b(d29),.c(c13),.d(d26),.e(d96),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x41i (.out(x41),.a(d95),.b(d47),.c(d52),.d(d117),.e(d92),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x40i (.out(x40),.a(d120),.b(d116),.c(c9),.d(c7),.e(d51),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x39i (.out(x39),.a(d61),.b(d82),.c(d94),.d(d87),.e(d99),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x38i (.out(x38),.a(c28),.b(d115),.c(d98),.d(d100),.e(c4),.f(1'b0));  // 5 ins 12 outs level 1

    xor6 x37i (.out(x37),.a(d120),.b(c26),.c(d76),.d(c15),.e(d58),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x36i (.out(x36),.a(d125),.b(c27),.c(c29),.d(d123),.e(c20),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x35i (.out(x35),.a(c2),.b(d55),.c(d110),.d(d113),.e(d9),.f(1'b0));  // 5 ins 12 outs level 1

    xor6 x34i (.out(x34),.a(d97),.b(c1),.c(d80),.d(d59),.e(c23),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x33i (.out(x33),.a(d119),.b(d121),.c(d50),.d(c25),.e(c24),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x32i (.out(x32),.a(d122),.b(c8),.c(d104),.d(c9),.e(c17),.f(1'b0));  // 5 ins 13 outs level 1

    xor6 x31i (.out(x31),.a(x80),.b(x41),.c(x44),.d(x82),.e(x81),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x30i (.out(x30),.a(x90),.b(x41),.c(x44),.d(x91),.e(x92),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x29i (.out(x29),.a(x93),.b(x45),.c(x52),.d(x62),.e(x101),.f(x102));  // 6 ins 1 outs level 3

    xor6 x28i (.out(x28),.a(x110),.b(x33),.c(x43),.d(x44),.e(x53),.f(x111));  // 6 ins 1 outs level 3

    xor6 x27i (.out(x27),.a(x120),.b(x39),.c(x56),.d(x121),.e(x122),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x26i (.out(x26),.a(x129),.b(x35),.c(x32),.d(x52),.e(x44),.f(x130));  // 6 ins 1 outs level 3

    xor6 x25i (.out(x25),.a(x136),.b(x61),.c(x52),.d(x138),.e(x137),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x24i (.out(x24),.a(x145),.b(x57),.c(x58),.d(x146),.e(x147),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x23i (.out(x23),.a(x154),.b(x57),.c(x70),.d(x156),.e(x155),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x22i (.out(x22),.a(x164),.b(x35),.c(x49),.d(x165),.e(x166),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x21i (.out(x21),.a(x167),.b(x36),.c(x52),.d(x57),.e(x174),.f(x175));  // 6 ins 1 outs level 3

    xor6 x20i (.out(x20),.a(x183),.b(x32),.c(x35),.d(x39),.e(x67),.f(x184));  // 6 ins 1 outs level 3

    xor6 x19i (.out(x19),.a(x193),.b(x63),.c(x54),.d(x44),.e(x194),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x18i (.out(x18),.a(x203),.b(x50),.c(x58),.d(x205),.e(x204),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x17i (.out(x17),.a(x72),.b(x32),.c(x33),.d(x62),.e(x212),.f(x213));  // 6 ins 1 outs level 3

    xor6 x16i (.out(x16),.a(x219),.b(x66),.c(x58),.d(x221),.e(x220),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x15i (.out(x15),.a(x222),.b(x44),.c(x56),.d(x230),.e(x231),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x14i (.out(x14),.a(x239),.b(x39),.c(x44),.d(x240),.e(x241),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x13i (.out(x13),.a(x250),.b(x60),.c(x64),.d(x54),.e(x251),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x12i (.out(x12),.a(x259),.b(x35),.c(x39),.d(x260),.e(x261),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x11i (.out(x11),.a(x270),.b(x63),.c(x32),.d(x56),.e(x54),.f(x271));  // 6 ins 1 outs level 3

    xor6 x10i (.out(x10),.a(x279),.b(x35),.c(x54),.d(x281),.e(x280),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x9i (.out(x9),.a(x290),.b(x53),.c(x54),.d(x292),.e(x291),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x8i (.out(x8),.a(x300),.b(x49),.c(x44),.d(x302),.e(x301),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x7i (.out(x7),.a(x310),.b(x37),.c(x44),.d(x311),.e(x312),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x6i (.out(x6),.a(x321),.b(x45),.c(x61),.d(x52),.e(x322),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x5i (.out(x5),.a(x330),.b(x45),.c(x54),.d(x331),.e(x332),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x4i (.out(x4),.a(x340),.b(x49),.c(x50),.d(x54),.e(x44),.f(x341));  // 6 ins 1 outs level 3

    xor6 x3i (.out(x3),.a(x349),.b(x38),.c(x64),.d(x56),.e(x350),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x2i (.out(x2),.a(x358),.b(x56),.c(x49),.d(x360),.e(x359),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x1i (.out(x1),.a(x368),.b(x59),.c(x66),.d(x369),.e(x370),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x0i (.out(x0),.a(x377),.b(x36),.c(x43),.d(x62),.e(x58),.f(x378));  // 6 ins 1 outs level 3

endmodule

