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

//// CRC-32 of 120 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 3
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        00000000000000000000000000000000 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111
//        00000000001111111111222222222233 000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111
//        01234567890123456789012345678901 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//
// C00  = ......XXXXXX.X.XX.X...XX.XX.XXXX X.....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX
// C01  = X.....X.....XXXX.XXX..X.XX.XX... XX....XX.X.XXX..XX......X..XX....XXX.XX.....X.XX.XXX.X..X.XXX.XXXX...X..X.X....XXX....XXX.....X.....XXXX.XXX..X.XX.XX...
// C02  = XX....X.XXXX..X....XX.X.......XX XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X.XXXX..X....XX.X.......XX
// C03  = .XX....X.XXXX..X....XX.X.......X .XXX...XXXX...XX.XXX.....X.X...XXX..XXXXX....X......XXX.X.XXX....X..XX.X.X..X...XX..XXX..XX....X.XXXX..X....XX.X.......X
// C04  = ..XX..XX.X..X..X..X..X.XXXX.XXXX X.XXX.X.X..XX..X..XXX...XX...XXX.X....XXXX..XXXXX.X......XXX...X.X.XXXX..XX..X.X...XX.X...XX..XX.X..X..X..X..X.XXXX.XXXX
// C05  = ...XX.X..X.X...X..XX...XX..XX... XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X..X.X...X..XX...XX..XX...
// C06  = ....XX.X..X.X...X..XX...XX..XX.. .XX.XXXXX..X..X.....XXX..X...XX.......X.XXXX.X.X..XXX.XXX...X.X.XXX.X.XXXXXXX..XXXXXX.......XX.X..X.X...X..XX...XX..XX..
// C07  = .....X.X.XX....XXXX.XXXX....X..X X.XX.X.XX.X....XX....XXXXX..XX..X.X..X.X.XXX.XXX..XXX.X.XXX.X.......XX.X..XXXX.XX......X.....X.X.XX....XXXX.XXXX....X..X
// C08  = X......X.X...X.X.X.X.X..XXX.X.XX XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......X.X...X.X.X.X.X..XXX.X.XX
// C09  = XX......X.X...X.X.X.X.X..XXX.X.X .XX.XX...X.XXX....X....XX....X..XXXXX.XX.X.XX.XX...XXX.X..X.XX..X.XXXXXX..X.XXXXXX.XXXX.XX......X.X...X.X.X.X.X..XXX.X.X
// C10  = .XX...XXX.X..X..XXXX.XX..X.X.X.X X.XX.X...X...XX.X..X......X.XX.XXX.XX..XX.X.......X.X..XX.XXX.XX..X..XXX.X.X.XX.X..X..X..XX...XXX.X..X..XXXX.XX..X.X.X.X
// C11  = ..XX..X...X..XXXXX.XX....X...X.X XX.XX....X..X.XXXX..X...XXXXX..X.X..X...XX.XXX.XX.XX..XXXXXX....XXX.X.XX.XX.X.X...XX.X....XX..X...X..XXXXX.XX....X...X.X
// C12  = ...XX.X.XXX..XX..X..XXXX.X..XX.X XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXXX.X..XX.X
// C13  = X...XX.X.XXX..XX..X..XXXX.X..XX. .XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXXX.X..XX.
// C14  = XX...XX.X.XXX..XX..X..XXXX.X..XX ..XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXXX.X..XX
// C15  = XXX...XX.X.XXX..XX..X..XXXX.X..X ...XXX.XXX..X..XX.X.XX..X..X..X..XX.........XX...XX.XXXXXX.XX.X.X.X....XX.X.XXX.X...XX..XXX...XX.X.XXX..XX..X..XXXX.X..X
// C16  = .XXX..X..X.XX.XXXX...XXXX..XX.XX X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX.XX
// C17  = X.XXX..X..X.XX.XXXX...XXXX..XX.X .X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX.X
// C18  = XX.XXX..X..X.XX.XXXX...XXXX..XX. ..X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX.
// C19  = .XX.XXX..X..X.XX.XXXX...XXXX..XX ...X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..XX
// C20  = X.XX.XXX..X..X.XX.XXXX...XXXX..X ....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..X
// C21  = XX.XX.XXX..X..X.XX.XXXX...XXXX.. .....X...XX..X...XX...X.X.XX.X.X..XX.X..X.X......X.XXX..X....XX........X.X......X.XX...XXX.XX.XXX..X..X.XX.XXXX...XXXX..
// C22  = XXX.XXX...XXXX..XX..XX...XXX...X X........X.XX.X.X.XX...XX.XX.X.X..XXXXX..X.XXX.XX...X..X.XX.XXX..XXXX....XX....X..X..X.XXXX.XXX...XXXX..XX..XX...XXX...X
// C23  = XXXX.X..XXX.X.XXXX...X.X.X.X.XXX XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XXXX...X.X.X.X.XXX
// C24  = XXXXX.X..XXX.X.XXXX...X.X.X.X.XX .XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XXXX...X.X.X.X.XX
// C25  = XXXXXX.X..XXX.X.XXXX...X.X.X.X.X ..XX....X..X...X.XXX.XX.....XX.X.X..XXX.XX..X...XX.XX...XXX..XX.X..X...X..XXXX...XXXX.XXXXXXXX.X..XXX.X.XXXX...X.X.X.X.X
// C26  = XXXXXX.X.XX.X...XX.XX.XXXX...X.X X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X.X
// C27  = .XXXXXX.X.XX.X...XX.XX.XXXX...X. .X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X.
// C28  = ..XXXXXX.X.XX.X...XX.XX.XXXX...X ..X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...X
// C29  = ...XXXXXX.X.XX.X...XX.XX.XXXX... ...X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX...
// C30  = ....XXXXXX.X.XX.X...XX.XX.XXXX.. ....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX..
// C31  = .....XXXXXX.X.XX.X...XX.XX.XXXX. .....X..XX.X...X.......XXX.XXXXX.X..X......XX.XX.X..XXX..X.XX.X.XXXX...XX.....X.XXXXX.X......XXXXXX.X.XX.X...XX.XX.XXXX.
//
module crc32_dat120 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [119:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat120_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat120_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat120_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [119:0] dat_in;
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
    d79,d80,d81,d82,d83,d84,d85,d86,d87,d88,d89,d90,d91,d92,d93,d94,
    d95,d96,d97,d98,d99,d100,d101,d102,d103,d104,d105,d106,d107,d108,d109,d110,
    d111,d112,d113,d114,d115,d116,d117,d118,d119;

assign { d119,d118,d117,d116,d115,d114,d113,d112,d111,d110,d109,d108,d107,d106,d105,
        d104,d103,d102,d101,d100,d99,d98,d97,d96,d95,d94,d93,d92,d91,d90,d89,
        d88,d87,d86,d85,d84,d83,d82,d81,d80,d79,d78,d77,d76,d75,d74,d73,
        d72,d71,d70,d69,d68,d67,d66,d65,d64,d63,d62,d61,d60,d59,d58,d57,
        d56,d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [119:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x23 = d72 ^ c10 ^ d98 ^ d50 ^ d119 ^ d103 ^ d104 ^ c15 ^ d96 ^ 
        d113 ^ d82 ^ d79 ^ d85 ^ d65 ^ c30 ^ d1 ^ d80 ^ d16 ^ c21 ^ 
        d86 ^ d42 ^ d87 ^ d17 ^ c9 ^ c16 ^ c2 ^ d117 ^ c14 ^ d9 ^ 
        c29 ^ d69 ^ d35 ^ d36 ^ d55 ^ c17 ^ d34 ^ c27 ^ c3 ^ d31 ^ 
        d111 ^ d56 ^ c31 ^ d84 ^ d39 ^ d0 ^ c0 ^ d62 ^ d29 ^ d115 ^ 
        d54 ^ d27 ^ c5 ^ d15 ^ d6 ^ d75 ^ d49 ^ d74 ^ d59 ^ d109 ^ 
        d38 ^ d118 ^ c23 ^ d46 ^ c25 ^ d90 ^ d105 ^ d89 ^ d60 ^ d91 ^ 
        c8 ^ c12 ^ d81 ^ d20 ^ c1 ^ d88 ^ d73 ^ d100 ^ d93 ^ d47 ^ 
        d97 ^ d26 ^ d19 ^ d13 ^ d102;  // 84 ins 1 outs level 3

    assign x22 = d12 ^ d45 ^ d57 ^ d66 ^ c2 ^ d104 ^ d100 ^ c5 ^ d55 ^ 
        d67 ^ c20 ^ d52 ^ d9 ^ d34 ^ c0 ^ d48 ^ d23 ^ c13 ^ d29 ^ 
        d101 ^ d73 ^ c16 ^ c21 ^ d43 ^ d87 ^ d36 ^ d90 ^ d24 ^ d98 ^ 
        c12 ^ c25 ^ d108 ^ d68 ^ d35 ^ d27 ^ d105 ^ d26 ^ c27 ^ d88 ^ 
        c4 ^ d79 ^ d99 ^ d19 ^ d85 ^ d14 ^ d58 ^ d62 ^ d61 ^ d92 ^ 
        c17 ^ c1 ^ d65 ^ d16 ^ d31 ^ d41 ^ d119 ^ d82 ^ d0 ^ d113 ^ 
        d38 ^ d94 ^ c31 ^ d74 ^ d11 ^ d93 ^ d115 ^ d109 ^ d114 ^ c10 ^ 
        d18 ^ d89 ^ c11 ^ d60 ^ d47 ^ c6 ^ d37 ^ c26 ^ d44;  // 78 ins 1 outs level 3

    assign x21 = d31 ^ d115 ^ d73 ^ d13 ^ c7 ^ d56 ^ d53 ^ d96 ^ d22 ^ 
        d114 ^ d110 ^ d92 ^ d34 ^ c19 ^ d52 ^ d117 ^ c21 ^ c3 ^ d37 ^ 
        d61 ^ d108 ^ d102 ^ c16 ^ d29 ^ c4 ^ d27 ^ d107 ^ c17 ^ d104 ^ 
        c27 ^ d80 ^ c0 ^ d40 ^ d51 ^ d88 ^ c6 ^ d95 ^ d35 ^ c28 ^ 
        c1 ^ d82 ^ d17 ^ d99 ^ c22 ^ c14 ^ c26 ^ d10 ^ d94 ^ c8 ^ 
        c29 ^ d42 ^ c11 ^ d109 ^ d49 ^ c20 ^ d18 ^ d83 ^ d87 ^ d24 ^ 
        d26 ^ d71 ^ d5 ^ d9 ^ d62 ^ d116 ^ d89 ^ d105 ^ d91;  // 68 ins 1 outs level 3

    assign x20 = c3 ^ d101 ^ d26 ^ c20 ^ d12 ^ d9 ^ d88 ^ d109 ^ c28 ^ 
        d79 ^ d23 ^ d116 ^ d60 ^ d36 ^ d51 ^ c6 ^ c0 ^ d113 ^ d95 ^ 
        d30 ^ d94 ^ d41 ^ c21 ^ c26 ^ d61 ^ c16 ^ c19 ^ c15 ^ d70 ^ 
        d115 ^ d25 ^ d93 ^ d119 ^ d81 ^ d16 ^ d34 ^ c10 ^ d91 ^ d103 ^ 
        d106 ^ d8 ^ d82 ^ d4 ^ c7 ^ d108 ^ c13 ^ d107 ^ c18 ^ c31 ^ 
        d50 ^ d98 ^ d114 ^ d48 ^ d21 ^ c25 ^ d72 ^ d87 ^ d86 ^ d55 ^ 
        d52 ^ d104 ^ c2 ^ c27 ^ d33 ^ d28 ^ d17 ^ d90 ^ d39 ^ c5;  // 69 ins 1 outs level 3

    assign x19 = d97 ^ d33 ^ d54 ^ c6 ^ c4 ^ d69 ^ d27 ^ d3 ^ d40 ^ 
        d47 ^ d24 ^ d102 ^ d15 ^ d94 ^ d115 ^ c14 ^ d22 ^ d106 ^ c5 ^ 
        d93 ^ c26 ^ d32 ^ c27 ^ d20 ^ c17 ^ d107 ^ d118 ^ d114 ^ c9 ^ 
        d92 ^ d103 ^ d85 ^ d8 ^ c2 ^ d51 ^ d38 ^ c18 ^ d89 ^ d35 ^ 
        d59 ^ c20 ^ d78 ^ c19 ^ d50 ^ d71 ^ c24 ^ d100 ^ d29 ^ d108 ^ 
        c1 ^ d113 ^ c31 ^ c30 ^ d90 ^ c12 ^ d49 ^ d112 ^ d87 ^ d81 ^ 
        d119 ^ d7 ^ d25 ^ c25 ^ d16 ^ d60 ^ d86 ^ d80 ^ d105 ^ d11 ^ 
        c15;  // 70 ins 1 outs level 3

    assign x18 = d106 ^ c8 ^ d21 ^ c13 ^ d37 ^ c1 ^ d85 ^ d46 ^ d104 ^ 
        d101 ^ d6 ^ c11 ^ c19 ^ d48 ^ d79 ^ d86 ^ c16 ^ d114 ^ c24 ^ 
        d91 ^ c5 ^ c0 ^ d111 ^ d77 ^ c30 ^ d32 ^ d50 ^ d19 ^ c14 ^ 
        d113 ^ d112 ^ d2 ^ d14 ^ d70 ^ c4 ^ d24 ^ c26 ^ c25 ^ d31 ^ 
        d34 ^ d99 ^ d105 ^ d96 ^ d68 ^ d118 ^ d26 ^ d10 ^ d84 ^ d102 ^ 
        d28 ^ d89 ^ d117 ^ d93 ^ d58 ^ d88 ^ d49 ^ d107 ^ d23 ^ d7 ^ 
        d15 ^ d80 ^ c17 ^ c23 ^ d92 ^ c18 ^ c3 ^ c29 ^ d39 ^ d59 ^ 
        d53;  // 70 ins 1 outs level 3

    assign x17 = c4 ^ d33 ^ d36 ^ c28 ^ d9 ^ d49 ^ c17 ^ d69 ^ d91 ^ 
        d112 ^ c2 ^ d13 ^ d106 ^ d101 ^ d25 ^ c31 ^ d110 ^ d111 ^ d76 ^ 
        c3 ^ d20 ^ c16 ^ d116 ^ d104 ^ c22 ^ d6 ^ d105 ^ d31 ^ d67 ^ 
        d98 ^ d23 ^ d117 ^ d18 ^ d27 ^ d95 ^ d1 ^ d30 ^ d48 ^ d87 ^ 
        c10 ^ d88 ^ d38 ^ c0 ^ d5 ^ c23 ^ d57 ^ c15 ^ d14 ^ d119 ^ 
        c12 ^ d78 ^ d84 ^ c25 ^ d83 ^ d79 ^ c18 ^ d45 ^ c24 ^ d47 ^ 
        c13 ^ d58 ^ d90 ^ d92 ^ d100 ^ d113 ^ c7 ^ d52 ^ d103 ^ c29 ^ 
        d85 ^ d22;  // 71 ins 1 outs level 3

    assign x16 = c1 ^ c3 ^ c9 ^ d77 ^ c27 ^ c30 ^ c14 ^ c17 ^ c11 ^ 
        d115 ^ c12 ^ d24 ^ d32 ^ c23 ^ d110 ^ c15 ^ c2 ^ d29 ^ d17 ^ 
        d47 ^ d89 ^ d37 ^ d97 ^ d75 ^ d21 ^ d66 ^ d91 ^ d35 ^ d111 ^ 
        d51 ^ d87 ^ c24 ^ d94 ^ d82 ^ d100 ^ d22 ^ d90 ^ d102 ^ d4 ^ 
        d84 ^ c31 ^ d26 ^ d118 ^ d112 ^ d104 ^ d103 ^ d116 ^ d83 ^ d78 ^ 
        d48 ^ d56 ^ d119 ^ d99 ^ d19 ^ d46 ^ d0 ^ d57 ^ c6 ^ d5 ^ 
        d30 ^ d44 ^ d8 ^ c28 ^ d13 ^ c16 ^ d12 ^ d68 ^ c22 ^ c21 ^ 
        d109 ^ d105 ^ d86;  // 72 ins 1 outs level 3

    assign x15 = d72 ^ d80 ^ d76 ^ c13 ^ c16 ^ d104 ^ d33 ^ d54 ^ c20 ^ 
        d114 ^ d112 ^ d56 ^ d16 ^ d64 ^ d21 ^ d30 ^ d5 ^ d105 ^ c7 ^ 
        d71 ^ d4 ^ c17 ^ d60 ^ d100 ^ d88 ^ c24 ^ d15 ^ d20 ^ d9 ^ 
        c6 ^ d18 ^ d59 ^ d3 ^ c25 ^ c23 ^ d95 ^ c1 ^ d97 ^ d52 ^ 
        d45 ^ d84 ^ d74 ^ d66 ^ d108 ^ d85 ^ d44 ^ d12 ^ d78 ^ d57 ^ 
        c28 ^ d50 ^ c26 ^ d99 ^ d90 ^ d53 ^ d113 ^ d94 ^ d34 ^ d55 ^ 
        c11 ^ d8 ^ c12 ^ d101 ^ c0 ^ d27 ^ d77 ^ d116 ^ d111 ^ d89 ^ 
        c2 ^ c9 ^ d24 ^ d49 ^ d62 ^ d7 ^ c31 ^ d119;  // 77 ins 1 outs level 3

    assign x14 = d51 ^ d54 ^ c5 ^ c8 ^ d61 ^ d76 ^ d79 ^ d8 ^ d110 ^ 
        d55 ^ d11 ^ d93 ^ d96 ^ d77 ^ d87 ^ d94 ^ c11 ^ d73 ^ d56 ^ 
        d100 ^ d23 ^ d33 ^ d112 ^ d113 ^ d119 ^ d26 ^ d32 ^ d63 ^ d65 ^ 
        d111 ^ c24 ^ d107 ^ c19 ^ d14 ^ d2 ^ d103 ^ d84 ^ c25 ^ d53 ^ 
        d48 ^ d88 ^ d71 ^ c22 ^ d19 ^ d7 ^ d29 ^ d20 ^ c30 ^ c23 ^ 
        d58 ^ d15 ^ d115 ^ c15 ^ d89 ^ d4 ^ d98 ^ d59 ^ d17 ^ c16 ^ 
        d104 ^ d3 ^ d52 ^ c1 ^ c0 ^ d70 ^ c27 ^ d99 ^ c6 ^ c12 ^ 
        c10 ^ d75 ^ d49 ^ c31 ^ d6 ^ d43 ^ d83 ^ d118 ^ d44;  // 78 ins 1 outs level 3

    assign x13 = d72 ^ c23 ^ c10 ^ d78 ^ d54 ^ d112 ^ d2 ^ c21 ^ d76 ^ 
        d98 ^ c7 ^ d19 ^ d64 ^ d25 ^ d92 ^ d117 ^ d106 ^ d53 ^ d7 ^ 
        d22 ^ c11 ^ d87 ^ d58 ^ d50 ^ d69 ^ c24 ^ c15 ^ d48 ^ d10 ^ 
        d57 ^ d31 ^ d70 ^ d28 ^ c26 ^ d86 ^ d42 ^ d110 ^ d47 ^ d3 ^ 
        c14 ^ d88 ^ c0 ^ d14 ^ d109 ^ d83 ^ d111 ^ d99 ^ c22 ^ d43 ^ 
        d62 ^ c4 ^ d102 ^ d82 ^ d16 ^ d52 ^ d60 ^ d32 ^ d1 ^ d13 ^ 
        c29 ^ c18 ^ d51 ^ d5 ^ d55 ^ c9 ^ d74 ^ c5 ^ d6 ^ d97 ^ 
        d95 ^ d75 ^ d114 ^ c30 ^ d18 ^ d103 ^ d93 ^ d118;  // 77 ins 1 outs level 3

    assign x12 = d54 ^ d116 ^ d69 ^ d30 ^ c8 ^ c28 ^ d85 ^ c9 ^ d17 ^ 
        d24 ^ d18 ^ d41 ^ d63 ^ d86 ^ d108 ^ d92 ^ d57 ^ d94 ^ d61 ^ 
        c23 ^ d1 ^ d12 ^ d21 ^ d59 ^ d119 ^ d47 ^ d117 ^ d52 ^ c3 ^ 
        d4 ^ d81 ^ d53 ^ d46 ^ d9 ^ d6 ^ d77 ^ d73 ^ d101 ^ d110 ^ 
        d49 ^ c20 ^ d27 ^ c21 ^ c14 ^ d2 ^ c25 ^ d56 ^ d31 ^ d15 ^ 
        d50 ^ d111 ^ d97 ^ d82 ^ d113 ^ d51 ^ d68 ^ d96 ^ d74 ^ d105 ^ 
        d5 ^ d0 ^ c6 ^ c22 ^ d87 ^ c4 ^ d98 ^ c10 ^ c29 ^ c13 ^ 
        c31 ^ d13 ^ d71 ^ d102 ^ d109 ^ c17 ^ d42 ^ d91 ^ d75;  // 78 ins 1 outs level 3

    assign x11 = d83 ^ d31 ^ d98 ^ c15 ^ c31 ^ c13 ^ d0 ^ d57 ^ d82 ^ 
        d33 ^ d25 ^ c6 ^ d27 ^ d44 ^ d45 ^ d9 ^ d55 ^ c3 ^ c19 ^ 
        d20 ^ d58 ^ c2 ^ d43 ^ d73 ^ d41 ^ c10 ^ d70 ^ d56 ^ c17 ^ 
        d71 ^ d51 ^ d102 ^ d91 ^ d36 ^ d1 ^ d4 ^ d17 ^ d24 ^ c16 ^ 
        d76 ^ d68 ^ d12 ^ d101 ^ d64 ^ d28 ^ d47 ^ d26 ^ d40 ^ c14 ^ 
        d78 ^ d3 ^ d107 ^ d108 ^ c25 ^ d59 ^ c20 ^ d90 ^ d117 ^ d113 ^ 
        d104 ^ d103 ^ d48 ^ d65 ^ d85 ^ d74 ^ d66 ^ c29 ^ d105 ^ d14 ^ 
        d119 ^ d50 ^ d16 ^ d94 ^ d54 ^ d15;  // 75 ins 1 outs level 3

    assign x10 = c22 ^ c29 ^ d86 ^ c7 ^ c27 ^ d62 ^ d52 ^ d14 ^ c1 ^ 
        d33 ^ d63 ^ d110 ^ d115 ^ d104 ^ d13 ^ d119 ^ d42 ^ c2 ^ d3 ^ 
        d83 ^ d2 ^ c17 ^ c16 ^ d78 ^ d90 ^ d9 ^ d98 ^ d56 ^ d50 ^ 
        d36 ^ d60 ^ d40 ^ d80 ^ d70 ^ d31 ^ d32 ^ c31 ^ d29 ^ d101 ^ 
        d73 ^ c25 ^ c18 ^ d59 ^ d0 ^ d106 ^ c19 ^ d105 ^ c6 ^ d26 ^ 
        c8 ^ d28 ^ d69 ^ d89 ^ c10 ^ d71 ^ d39 ^ d19 ^ d113 ^ d35 ^ 
        d117 ^ d96 ^ d66 ^ c21 ^ d109 ^ d95 ^ d77 ^ d55 ^ d75 ^ c13 ^ 
        d58 ^ d16 ^ d94 ^ d5 ^ d107;  // 74 ins 1 outs level 3

    assign x9 = c26 ^ d66 ^ c27 ^ d67 ^ c31 ^ d55 ^ d13 ^ d114 ^ c25 ^ 
        d11 ^ d81 ^ d29 ^ d1 ^ c22 ^ d80 ^ d69 ^ d52 ^ d117 ^ d79 ^ 
        c14 ^ c10 ^ d110 ^ d35 ^ d106 ^ d119 ^ d24 ^ d98 ^ d71 ^ d12 ^ 
        d43 ^ d38 ^ d47 ^ c1 ^ c8 ^ d68 ^ d41 ^ d5 ^ d102 ^ d32 ^ 
        d104 ^ d86 ^ d88 ^ d44 ^ d34 ^ d36 ^ d60 ^ d113 ^ d23 ^ d89 ^ 
        d53 ^ d76 ^ d70 ^ d115 ^ d64 ^ c18 ^ d33 ^ d108 ^ d4 ^ d9 ^ 
        c16 ^ d18 ^ d61 ^ d83 ^ d77 ^ d85 ^ c29 ^ c0 ^ d39 ^ d84 ^ 
        d51 ^ d74 ^ d58 ^ d46 ^ c20 ^ d96 ^ d2 ^ d78;  // 77 ins 1 outs level 3

    assign x8 = d83 ^ d118 ^ d114 ^ d109 ^ d76 ^ d28 ^ d0 ^ d10 ^ d33 ^ 
        d85 ^ c24 ^ d35 ^ c9 ^ d73 ^ d37 ^ d67 ^ d11 ^ d52 ^ d97 ^ 
        d1 ^ d60 ^ d45 ^ d32 ^ d3 ^ c13 ^ d70 ^ c19 ^ d12 ^ d87 ^ 
        d51 ^ d68 ^ d22 ^ d101 ^ d77 ^ c31 ^ d40 ^ d23 ^ d80 ^ d78 ^ 
        c7 ^ c26 ^ d105 ^ c17 ^ c25 ^ d57 ^ d79 ^ d17 ^ c15 ^ d88 ^ 
        d4 ^ d65 ^ c30 ^ d107 ^ d69 ^ d63 ^ d42 ^ d54 ^ d75 ^ d103 ^ 
        c0 ^ d46 ^ d8 ^ d59 ^ d34 ^ c21 ^ d43 ^ d31 ^ c28 ^ d112 ^ 
        d82 ^ d66 ^ d38 ^ d113 ^ d116 ^ d95 ^ d84 ^ d119 ^ d50;  // 78 ins 1 outs level 3

    assign x7 = d32 ^ d51 ^ d57 ^ d105 ^ d95 ^ d29 ^ c15 ^ d22 ^ d3 ^ 
        c7 ^ d60 ^ d5 ^ d110 ^ d104 ^ d34 ^ d39 ^ d97 ^ c20 ^ d42 ^ 
        d58 ^ d2 ^ d25 ^ d68 ^ d52 ^ d119 ^ d75 ^ c17 ^ d71 ^ d106 ^ 
        c23 ^ d21 ^ d77 ^ d79 ^ c22 ^ d54 ^ d103 ^ c18 ^ c21 ^ d69 ^ 
        d116 ^ c9 ^ d50 ^ d80 ^ d7 ^ d16 ^ d24 ^ d15 ^ d10 ^ d87 ^ 
        d98 ^ c31 ^ d8 ^ d93 ^ d76 ^ d111 ^ c10 ^ d23 ^ d109 ^ d74 ^ 
        d108 ^ d47 ^ c5 ^ d43 ^ d56 ^ d46 ^ d41 ^ d0 ^ d45 ^ d37 ^ 
        c28 ^ c16 ^ d28;  // 72 ins 1 outs level 3

    assign x6 = d1 ^ d74 ^ d51 ^ c29 ^ d73 ^ d92 ^ d55 ^ d82 ^ d104 ^ 
        c19 ^ d5 ^ d66 ^ c20 ^ d11 ^ d80 ^ d54 ^ d72 ^ d107 ^ d112 ^ 
        d70 ^ d25 ^ d117 ^ d76 ^ d47 ^ d75 ^ c12 ^ c4 ^ d45 ^ d83 ^ 
        c24 ^ d62 ^ d4 ^ d81 ^ d95 ^ d20 ^ d100 ^ d84 ^ d30 ^ d56 ^ 
        d113 ^ c10 ^ c28 ^ d41 ^ d7 ^ d38 ^ d29 ^ d14 ^ d68 ^ d21 ^ 
        d98 ^ d2 ^ d52 ^ d60 ^ d71 ^ c5 ^ d108 ^ d22 ^ d42 ^ d116 ^ 
        d79 ^ d8 ^ c25 ^ d65 ^ d93 ^ d50 ^ d6 ^ d64 ^ d40 ^ c16 ^ 
        d43 ^ c7;  // 71 ins 1 outs level 3

    assign x5 = d50 ^ c19 ^ d115 ^ c28 ^ d55 ^ d111 ^ c23 ^ d7 ^ d21 ^ 
        d63 ^ d79 ^ d107 ^ d80 ^ d70 ^ d49 ^ d106 ^ d29 ^ c11 ^ d46 ^ 
        d59 ^ d99 ^ d40 ^ d72 ^ d112 ^ d13 ^ d6 ^ d0 ^ d20 ^ d82 ^ 
        d64 ^ d94 ^ c24 ^ d19 ^ d78 ^ c3 ^ d1 ^ d54 ^ d24 ^ d81 ^ 
        d41 ^ d65 ^ d71 ^ c4 ^ c27 ^ c15 ^ d5 ^ c18 ^ c9 ^ d10 ^ 
        d61 ^ d103 ^ d37 ^ d3 ^ d28 ^ d4 ^ d91 ^ d75 ^ c6 ^ d83 ^ 
        d92 ^ d69 ^ d44 ^ d53 ^ d116 ^ d51 ^ d74 ^ d67 ^ d42 ^ d39 ^ 
        d73 ^ d97;  // 71 ins 1 outs level 3

    assign x4 = c9 ^ d109 ^ d24 ^ c25 ^ d40 ^ d84 ^ d11 ^ d118 ^ d18 ^ 
        d30 ^ d8 ^ c31 ^ d67 ^ c24 ^ d69 ^ d47 ^ d38 ^ d59 ^ d4 ^ 
        d74 ^ d112 ^ d2 ^ c29 ^ c26 ^ d41 ^ d19 ^ d20 ^ d70 ^ c7 ^ 
        d33 ^ d46 ^ d113 ^ d31 ^ d12 ^ c15 ^ d117 ^ c12 ^ c30 ^ d63 ^ 
        d29 ^ d100 ^ d86 ^ d111 ^ d103 ^ d58 ^ d91 ^ d0 ^ c3 ^ d39 ^ 
        d90 ^ d77 ^ d57 ^ d25 ^ d3 ^ c2 ^ d6 ^ d79 ^ d73 ^ d116 ^ 
        d48 ^ d15 ^ d94 ^ d119 ^ d97 ^ d50 ^ d114 ^ c23 ^ d83 ^ c6 ^ 
        d44 ^ c21 ^ d95 ^ d45 ^ c28 ^ d106 ^ d68 ^ d65 ^ c18;  // 78 ins 1 outs level 3

    assign x3 = d2 ^ d60 ^ d95 ^ d69 ^ d100 ^ d37 ^ d27 ^ d98 ^ d85 ^ 
        c23 ^ d59 ^ d86 ^ d56 ^ c12 ^ d36 ^ d7 ^ d108 ^ d54 ^ d99 ^ 
        c7 ^ d33 ^ d84 ^ d109 ^ c21 ^ d65 ^ c11 ^ d71 ^ d32 ^ c2 ^ 
        c31 ^ d14 ^ d97 ^ d31 ^ d73 ^ d8 ^ d40 ^ d52 ^ d45 ^ d1 ^ 
        c10 ^ d111 ^ c9 ^ d15 ^ d80 ^ c1 ^ d25 ^ d3 ^ d17 ^ d58 ^ 
        d19 ^ d38 ^ d68 ^ d89 ^ d53 ^ d90 ^ d76 ^ d119 ^ d9 ^ d10 ^ 
        d81 ^ d18 ^ c15 ^ d39 ^ d103 ^ c20;  // 65 ins 1 outs level 3

    assign x2 = d51 ^ c9 ^ d31 ^ d55 ^ d64 ^ d85 ^ c19 ^ d72 ^ d118 ^ 
        d98 ^ d57 ^ c31 ^ d39 ^ d89 ^ d0 ^ d53 ^ d83 ^ d84 ^ d13 ^ 
        c8 ^ d80 ^ c10 ^ c22 ^ d32 ^ d67 ^ d108 ^ d7 ^ d9 ^ d38 ^ 
        d79 ^ d2 ^ c20 ^ c14 ^ d97 ^ d119 ^ d18 ^ d58 ^ d88 ^ d96 ^ 
        d36 ^ d26 ^ c0 ^ d16 ^ c6 ^ c11 ^ d1 ^ d35 ^ d102 ^ d24 ^ 
        d6 ^ c1 ^ d8 ^ c30 ^ d37 ^ d75 ^ d110 ^ d17 ^ d107 ^ d59 ^ 
        d99 ^ d70 ^ d30 ^ d68 ^ d52 ^ d14 ^ d44 ^ d94;  // 67 ins 1 outs level 3

    assign x1 = d116 ^ d79 ^ c25 ^ d101 ^ d87 ^ d50 ^ d60 ^ d65 ^ d38 ^ 
        d72 ^ c22 ^ d81 ^ d62 ^ d53 ^ d6 ^ d112 ^ d59 ^ d107 ^ d17 ^ 
        d80 ^ c13 ^ d0 ^ d33 ^ d113 ^ d63 ^ d102 ^ d34 ^ d35 ^ c6 ^ 
        d9 ^ c18 ^ c27 ^ d58 ^ d16 ^ d13 ^ d24 ^ d46 ^ c0 ^ d47 ^ 
        d94 ^ d7 ^ d56 ^ d37 ^ d100 ^ d88 ^ c14 ^ c19 ^ d49 ^ d86 ^ 
        c24 ^ c28 ^ c12 ^ d110 ^ d27 ^ d115 ^ d103 ^ d69 ^ c17 ^ d11 ^ 
        d44 ^ d12 ^ c15 ^ d1 ^ d106 ^ d105 ^ d74 ^ d51 ^ d28 ^ d64;  // 69 ins 1 outs level 3

    assign x0 = c31 ^ d87 ^ d32 ^ d61 ^ d10 ^ d94 ^ d16 ^ d58 ^ c13 ^ 
        c9 ^ c18 ^ c29 ^ c22 ^ d65 ^ d68 ^ d30 ^ d26 ^ d97 ^ d73 ^ 
        d29 ^ d9 ^ d67 ^ d53 ^ d81 ^ c8 ^ d83 ^ d118 ^ d54 ^ d55 ^ 
        d95 ^ d66 ^ d117 ^ d28 ^ d106 ^ d12 ^ c16 ^ c28 ^ d45 ^ d44 ^ 
        c6 ^ d0 ^ d111 ^ d31 ^ d34 ^ c7 ^ d99 ^ d110 ^ d63 ^ c30 ^ 
        c26 ^ d37 ^ d47 ^ d24 ^ d72 ^ d60 ^ c11 ^ c10 ^ d98 ^ c23 ^ 
        d114 ^ d50 ^ d119 ^ d84 ^ d85 ^ d48 ^ d116 ^ d103 ^ d104 ^ c15 ^ 
        d96 ^ d113 ^ d82 ^ d79 ^ c25 ^ d101 ^ d6 ^ d25;  // 77 ins 1 outs level 3

    assign x31 = d62 ^ c21 ^ d100 ^ d80 ^ c27 ^ d105 ^ c5 ^ c14 ^ d29 ^ 
        d11 ^ d78 ^ d71 ^ c30 ^ d81 ^ d96 ^ c7 ^ d30 ^ c8 ^ c6 ^ 
        d24 ^ c24 ^ d109 ^ d117 ^ d52 ^ d72 ^ d102 ^ d98 ^ d113 ^ d65 ^ 
        d82 ^ d103 ^ d47 ^ c9 ^ d54 ^ d36 ^ d84 ^ d118 ^ d33 ^ c17 ^ 
        d93 ^ d23 ^ d15 ^ d43 ^ c22 ^ d8 ^ d44 ^ d27 ^ d83 ^ c29 ^ 
        d25 ^ d97 ^ d67 ^ d53 ^ d9 ^ d116 ^ d66 ^ c10 ^ d49 ^ d95 ^ 
        d86 ^ c12 ^ d59 ^ d5 ^ c28 ^ c15 ^ d28 ^ d94 ^ d115 ^ d60 ^ 
        d31 ^ d112 ^ d110 ^ c25 ^ d64 ^ d57 ^ d46;  // 76 ins 1 outs level 3

    assign x30 = d104 ^ d80 ^ d7 ^ d64 ^ d58 ^ d52 ^ c4 ^ d53 ^ d71 ^ 
        d23 ^ d26 ^ d116 ^ d92 ^ d94 ^ c11 ^ c27 ^ d70 ^ c9 ^ d97 ^ 
        d82 ^ c8 ^ d61 ^ d81 ^ d10 ^ d117 ^ d108 ^ d28 ^ d115 ^ d27 ^ 
        c13 ^ d29 ^ d35 ^ d48 ^ d43 ^ d109 ^ d96 ^ d114 ^ d99 ^ d45 ^ 
        c5 ^ d24 ^ d51 ^ d46 ^ d93 ^ c23 ^ d8 ^ d65 ^ c28 ^ c21 ^ 
        d101 ^ d14 ^ c6 ^ d4 ^ d56 ^ c24 ^ d66 ^ d42 ^ d79 ^ d22 ^ 
        d95 ^ c16 ^ c14 ^ d59 ^ c26 ^ d77 ^ c29 ^ d85 ^ c20 ^ d32 ^ 
        d30 ^ d102 ^ d112 ^ d111 ^ d83 ^ c7 ^ d63;  // 76 ins 1 outs level 3

    assign x29 = d69 ^ d50 ^ d51 ^ d116 ^ d34 ^ d9 ^ d31 ^ c15 ^ d52 ^ 
        d80 ^ d103 ^ c20 ^ d91 ^ c23 ^ d58 ^ d28 ^ c19 ^ d76 ^ d101 ^ 
        c28 ^ d62 ^ d26 ^ d64 ^ d79 ^ c26 ^ d110 ^ d13 ^ d47 ^ d96 ^ 
        c7 ^ d93 ^ d84 ^ d100 ^ d111 ^ d41 ^ d65 ^ d6 ^ c12 ^ d3 ^ 
        d21 ^ d27 ^ c10 ^ d81 ^ c13 ^ c6 ^ d95 ^ c3 ^ d63 ^ c27 ^ 
        d78 ^ d92 ^ d82 ^ d98 ^ d114 ^ c25 ^ d57 ^ d107 ^ d29 ^ d44 ^ 
        d55 ^ c8 ^ d113 ^ d115 ^ d42 ^ c22 ^ d94 ^ d108 ^ d25 ^ d45 ^ 
        c5 ^ d23 ^ c4 ^ d60 ^ d7 ^ d22 ^ d70;  // 76 ins 1 outs level 3

    assign x28 = c11 ^ d50 ^ c2 ^ d78 ^ d8 ^ c18 ^ c4 ^ d2 ^ d110 ^ 
        d30 ^ d100 ^ c7 ^ d62 ^ d95 ^ d24 ^ c31 ^ d46 ^ d59 ^ c27 ^ 
        d5 ^ d61 ^ d56 ^ d49 ^ d68 ^ d106 ^ d57 ^ c14 ^ d44 ^ d12 ^ 
        c6 ^ d28 ^ d21 ^ d64 ^ d90 ^ d113 ^ c3 ^ d114 ^ d109 ^ d97 ^ 
        d80 ^ d33 ^ c19 ^ d63 ^ c22 ^ d115 ^ c26 ^ d27 ^ c9 ^ d94 ^ 
        d107 ^ d69 ^ d26 ^ c21 ^ d25 ^ d41 ^ c5 ^ d112 ^ d99 ^ c24 ^ 
        c12 ^ d6 ^ d91 ^ d20 ^ d43 ^ d75 ^ d40 ^ c25 ^ d81 ^ d54 ^ 
        d92 ^ d83 ^ d119 ^ d102 ^ d93 ^ d51 ^ d79 ^ d77 ^ d22;  // 78 ins 1 outs level 3

    assign x27 = c1 ^ d58 ^ d80 ^ d91 ^ d56 ^ d7 ^ d61 ^ c11 ^ d111 ^ 
        d29 ^ d1 ^ c18 ^ d96 ^ d92 ^ d20 ^ d43 ^ d99 ^ d74 ^ c25 ^ 
        d94 ^ d98 ^ d4 ^ d32 ^ d19 ^ d90 ^ d112 ^ d55 ^ d5 ^ d63 ^ 
        d49 ^ d27 ^ c10 ^ c5 ^ c26 ^ d21 ^ c20 ^ c4 ^ d77 ^ d93 ^ 
        d25 ^ d40 ^ d67 ^ d60 ^ d106 ^ d45 ^ d78 ^ d62 ^ c6 ^ d68 ^ 
        d82 ^ c21 ^ d48 ^ d89 ^ d105 ^ d23 ^ c13 ^ c23 ^ d76 ^ c2 ^ 
        d114 ^ d24 ^ c30 ^ d113 ^ d118 ^ d11 ^ c17 ^ d39 ^ d79 ^ d101 ^ 
        d108 ^ d26 ^ d42 ^ c24 ^ d109 ^ c3 ^ c8 ^ d50 ^ d53;  // 78 ins 1 outs level 3

    assign x26 = c7 ^ d48 ^ d113 ^ c25 ^ d119 ^ d10 ^ d19 ^ c31 ^ c12 ^ 
        c23 ^ d100 ^ d110 ^ d61 ^ c20 ^ d98 ^ d18 ^ d104 ^ c5 ^ c3 ^ 
        d57 ^ d20 ^ d42 ^ d28 ^ d107 ^ d77 ^ c2 ^ d117 ^ c22 ^ d25 ^ 
        c10 ^ d112 ^ d88 ^ d75 ^ d73 ^ d41 ^ c19 ^ d60 ^ d92 ^ d3 ^ 
        d78 ^ d108 ^ d31 ^ d24 ^ d6 ^ d79 ^ d91 ^ d49 ^ c1 ^ d76 ^ 
        d97 ^ d22 ^ d90 ^ d81 ^ c16 ^ d4 ^ d111 ^ d59 ^ d38 ^ c9 ^ 
        c0 ^ d39 ^ d93 ^ d67 ^ d44 ^ d105 ^ c4 ^ c24 ^ c17 ^ d26 ^ 
        c29 ^ d47 ^ d0 ^ d89 ^ d66 ^ d23 ^ d95 ^ d55 ^ d54 ^ d52 ^ 
        d62;  // 80 ins 1 outs level 3

    assign x25 = d57 ^ d81 ^ d83 ^ d18 ^ c18 ^ c17 ^ d113 ^ d36 ^ d71 ^ 
        d40 ^ c29 ^ d52 ^ d51 ^ d2 ^ d61 ^ c16 ^ c2 ^ d31 ^ d117 ^ 
        d91 ^ c14 ^ d22 ^ d48 ^ d21 ^ d62 ^ c27 ^ d56 ^ d93 ^ c25 ^ 
        d107 ^ d119 ^ d84 ^ d74 ^ d19 ^ d64 ^ c10 ^ d98 ^ d44 ^ d38 ^ 
        c7 ^ d11 ^ d58 ^ d88 ^ d37 ^ d99 ^ d102 ^ d115 ^ d92 ^ c12 ^ 
        d49 ^ d111 ^ d41 ^ d105 ^ d29 ^ c31 ^ d95 ^ d77 ^ d33 ^ d100 ^ 
        d76 ^ d106 ^ c19 ^ c23 ^ d17 ^ d75 ^ c5 ^ c3 ^ c11 ^ d90 ^ 
        d28 ^ c4 ^ d87 ^ d67 ^ d89 ^ d104 ^ d3 ^ d8 ^ c1 ^ d86 ^ 
        d82 ^ d15 ^ c0;  // 82 ins 1 outs level 3

    assign x24 = d17 ^ d82 ^ c31 ^ d118 ^ c30 ^ d1 ^ d73 ^ d105 ^ d116 ^ 
        d103 ^ d36 ^ d48 ^ d30 ^ d47 ^ c2 ^ c11 ^ d89 ^ c24 ^ d37 ^ 
        d50 ^ c18 ^ d35 ^ d119 ^ d14 ^ c9 ^ c17 ^ d20 ^ c1 ^ d85 ^ 
        d99 ^ d28 ^ d91 ^ d86 ^ d81 ^ d40 ^ d21 ^ d106 ^ d112 ^ d88 ^ 
        c13 ^ c28 ^ c4 ^ d61 ^ d51 ^ d94 ^ d18 ^ d104 ^ d27 ^ d39 ^ 
        d83 ^ c10 ^ c3 ^ d114 ^ d90 ^ d56 ^ d74 ^ d10 ^ d55 ^ d87 ^ 
        d2 ^ d80 ^ c16 ^ d76 ^ d70 ^ d57 ^ d63 ^ c6 ^ d7 ^ d98 ^ 
        c0 ^ d16 ^ d92 ^ d110 ^ c15 ^ d60 ^ d66 ^ d75 ^ d32 ^ d101 ^ 
        d43 ^ c26 ^ d97 ^ c22;  // 83 ins 1 outs level 3

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat120_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [119:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x343, x342, x341, x340, x339, x338, x337, 
       x336, x335, x334, x333, x332, x331, x330, x329, 
       x328, x327, x326, x325, x324, x323, x322, x321, 
       x320, x319, x318, x317, x316, x315, x314, x313, 
       x312, x311, x310, x309, x308, x307, x306, x305, 
       x304, x303, x302, x301, x300, x299, x298, x297, 
       x296, x295, x294, x293, x292, x291, x290, x289, 
       x288, x287, x286, x285, x284, x283, x282, x281, 
       x279, x278, x277, x276, x275, x274, x273, x272, 
       x271, x270, x269, x268, x267, x266, x265, x264, 
       x263, x262, x261, x260, x259, x258, x257, x256, 
       x255, x253, x252, x251, x250, x249, x248, x247, 
       x246, x245, x244, x243, x242, x241, x240, x239, 
       x238, x237, x236, x235, x234, x233, x232, x231, 
       x230, x229, x228, x227, x226, x225, x224, x223, 
       x222, x221, x220, x219, x218, x217, x216, x215, 
       x214, x213, x212, x211, x210, x209, x208, x207, 
       x206, x205, x204, x203, x202, x201, x200, x199, 
       x198, x197, x196, x195, x194, x193, x192, x191, 
       x190, x189, x188, x187, x186, x185, x184, x183, 
       x182, x181, x180, x179, x178, x177, x176, x175, 
       x174, x173, x172, x171, x170, x169, x168, x167, 
       x166, x165, x164, x163, x162, x161, x160, x159, 
       x158, x157, x156, x155, x154, x153, x152, x151, 
       x150, x149, x148, x147, x146, x145, x144, x143, 
       x142, x141, x140, x139, x138, x137, x136, x135, 
       x134, x133, x132, x131, x130, x129, x128, x127, 
       x126, x125, x124, x123, x122, x121, x120, x119, 
       x118, x117, x116, x115, x114, x113, x112, x111, 
       x110, x109, x108, x107, x106, x105, x104, x103, 
       x102, x101, x100, x99, x98, x97, x96, x95, 
       x94, x93, x92, x91, x90, x89, x88, x87, 
       x86, x85, x84, x83, x82, x81, x80, x79, 
       x78, x77, x76, x75, x74, x72, x71, x70, 
       x69, x68, x67, x66, x65, x64, x63, x62, 
       x61, x60, x59, x58, x57, x56, x55, x54, 
       x53, x52, x51, x50, x49, x48, x47, x46, 
       x45, x44, x43, x42, x41, x40, x39, x38, 
       x37, x36, x35, x34, x33, x32, x23, x22, 
       x21, x20, x19, x18, x17, x16, x15, x14, 
       x13, x12, x11, x10, x9, x8, x7, x6, 
       x5, x4, x3, x2, x1, x0, x31, x30, 
       x29, x28, x27, x26, x25, x24;

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
    d111,d112,d113,d114,d115,d116,d117,d118,d119;

assign { d119,d118,d117,d116,d115,d114,d113,d112,d111,d110,d109,d108,d107,d106,d105,
        d104,d103,d102,d101,d100,d99,d98,d97,d96,d95,d94,d93,d92,d91,d90,d89,
        d88,d87,d86,d85,d84,d83,d82,d81,d80,d79,d78,d77,d76,d75,d74,d73,
        d72,d71,d70,d69,d68,d67,d66,d65,d64,d63,d62,d61,d60,d59,d58,d57,
        d56,d55,d54,d53,d52,d51,d50,d49,d48,d47,d46,d45,d44,d43,d42,d41,
        d40,d39,d38,d37,d36,d35,d34,d33,d32,d31,d30,d29,d28,d27,d26,d25,
        d24,d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [119:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x343i (.out(x343),.a(x335),.b(x45),.c(x341),.d(x42),.e(x46),.f(x340));  // 6 ins 1 outs level 2

    xor6 x342i (.out(x342),.a(x336),.b(x52),.c(x37),.d(x337),.e(x338),.f(x339));  // 6 ins 1 outs level 2

    xor6 x341i (.out(x341),.a(d40),.b(d28),.c(d90),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x340i (.out(x340),.a(d18),.b(d45),.c(c3),.d(d106),.e(d80),.f(d50));  // 6 ins 1 outs level 1

    xor6 x339i (.out(x339),.a(c11),.b(d99),.c(d6),.d(d63),.e(d10),.f(c26));  // 6 ins 1 outs level 1

    xor6 x338i (.out(x338),.a(d14),.b(c0),.c(d17),.d(c4),.e(d92),.f(d36));  // 6 ins 1 outs level 1

    xor6 x337i (.out(x337),.a(d48),.b(d88),.c(c18),.d(d39),.e(d94),.f(d61));  // 6 ins 1 outs level 1

    xor6 x336i (.out(x336),.a(d20),.b(d21),.c(d35),.d(d30),.e(d7),.f(d113));  // 6 ins 1 outs level 1

    xor6 x335i (.out(x335),.a(d0),.b(d27),.c(d16),.d(d86),.e(d95),.f(d85));  // 6 ins 1 outs level 1

    xor6 x334i (.out(x334),.a(x326),.b(x45),.c(x50),.d(x65),.e(x42),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x333i (.out(x333),.a(x331),.b(x49),.c(x40),.d(x38),.e(x33),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x332i (.out(x332),.a(d87),.b(x327),.c(x56),.d(x328),.e(x329),.f(x330));  // 6 ins 1 outs level 2

    xor6 x331i (.out(x331),.a(d76),.b(d105),.c(d81),.d(c27),.e(c14),.f(d11));  // 6 ins 1 outs level 1

    xor6 x330i (.out(x330),.a(d38),.b(d99),.c(d61),.d(d19),.e(d18),.f(d37));  // 6 ins 1 outs level 1

    xor6 x329i (.out(x329),.a(c12),.b(d111),.c(d8),.d(d33),.e(d62),.f(d21));  // 6 ins 1 outs level 1

    xor6 x328i (.out(x328),.a(c0),.b(c11),.c(d84),.d(d88),.e(d115),.f(d49));  // 6 ins 1 outs level 1

    xor6 x327i (.out(x327),.a(d15),.b(d106),.c(d44),.d(d29),.e(d78),.f(d71));  // 6 ins 1 outs level 1

    xor6 x326i (.out(x326),.a(d57),.b(d95),.c(d75),.d(d86),.e(d82),.f(d67));  // 6 ins 1 outs level 1

    xor6 x325i (.out(x325),.a(x323),.b(x70),.c(x32),.d(x48),.e(x52),.f(x50));  // 6 ins 1 outs level 2

    xor6 x324i (.out(x324),.a(x318),.b(x33),.c(x319),.d(x320),.e(x321),.f(x322));  // 6 ins 1 outs level 2

    xor6 x323i (.out(x323),.a(d60),.b(d59),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x322i (.out(x322),.a(d49),.b(d54),.c(d24),.d(d9),.e(d50),.f(d55));  // 6 ins 1 outs level 1

    xor6 x321i (.out(x321),.a(d42),.b(d111),.c(d57),.d(d102),.e(d23),.f(c7));  // 6 ins 1 outs level 1

    xor6 x320i (.out(x320),.a(d44),.b(d97),.c(d58),.d(d76),.e(d79),.f(d87));  // 6 ins 1 outs level 1

    xor6 x319i (.out(x319),.a(d26),.b(d75),.c(c19),.d(d95),.e(c5),.f(d40));  // 6 ins 1 outs level 1

    xor6 x318i (.out(x318),.a(d38),.b(d19),.c(d88),.d(c9),.e(d61),.f(d48));  // 6 ins 1 outs level 1

    xor6 x317i (.out(x317),.a(x309),.b(x68),.c(x56),.d(x33),.e(x315),.f(x314));  // 6 ins 1 outs level 2

    xor6 x316i (.out(x316),.a(x310),.b(x39),.c(x53),.d(x311),.e(x312),.f(x313));  // 6 ins 1 outs level 2

    xor6 x315i (.out(x315),.a(d98),.b(d29),.c(d78),.d(d39),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x314i (.out(x314),.a(d34),.b(d68),.c(d1),.d(c20),.e(c4),.f(d100));  // 6 ins 1 outs level 1

    xor6 x313i (.out(x313),.a(d92),.b(d108),.c(d99),.d(d5),.e(d4),.f(d55));  // 6 ins 1 outs level 1

    xor6 x312i (.out(x312),.a(c21),.b(c10),.c(c6),.d(c12),.e(d40),.f(d19));  // 6 ins 1 outs level 1

    xor6 x311i (.out(x311),.a(d43),.b(c26),.c(d114),.d(d105),.e(d118),.f(d32));  // 6 ins 1 outs level 1

    xor6 x310i (.out(x310),.a(c30),.b(d93),.c(d63),.d(d11),.e(d76),.f(d61));  // 6 ins 1 outs level 1

    xor6 x309i (.out(x309),.a(d49),.b(d109),.c(d94),.d(d74),.e(d56),.f(d82));  // 6 ins 1 outs level 1

    xor6 x308i (.out(x308),.a(x40),.b(x50),.c(x56),.d(x55),.e(x44),.f(x47));  // 6 ins 1 outs level 2

    xor6 x307i (.out(x307),.a(x302),.b(x42),.c(x306),.d(x303),.e(x304),.f(x305));  // 6 ins 1 outs level 2

    xor6 x306i (.out(x306),.a(d97),.b(d67),.c(d57),.d(c9),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x305i (.out(x305),.a(d99),.b(d81),.c(d29),.d(c22),.e(c2),.f(d26));  // 6 ins 1 outs level 1

    xor6 x304i (.out(x304),.a(d83),.b(d6),.c(d43),.d(c31),.e(d110),.f(c26));  // 6 ins 1 outs level 1

    xor6 x303i (.out(x303),.a(d15),.b(d41),.c(d61),.d(c6),.e(d84),.f(c19));  // 6 ins 1 outs level 1

    xor6 x302i (.out(x302),.a(c14),.b(c23),.c(d69),.d(d21),.e(c11),.f(d48));  // 6 ins 1 outs level 1

    xor6 x301i (.out(x301),.a(d64),.b(d3),.c(c15),.d(d74),.e(d95),.f(d119));  // 6 ins 1 outs level 1

    xor6 x300i (.out(x300),.a(x39),.b(x40),.c(x46),.d(x52),.e(x34),.f(x50));  // 6 ins 1 outs level 2

    xor6 x299i (.out(x299),.a(x294),.b(x298),.c(x68),.d(x295),.e(x296),.f(x297));  // 6 ins 1 outs level 2

    xor6 x298i (.out(x298),.a(d98),.b(c10),.c(d51),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x297i (.out(x297),.a(d50),.b(d102),.c(d65),.d(c27),.e(d63),.f(c3));  // 6 ins 1 outs level 1

    xor6 x296i (.out(x296),.a(d76),.b(d62),.c(d100),.d(d57),.e(c23),.f(d79));  // 6 ins 1 outs level 1

    xor6 x295i (.out(x295),.a(d9),.b(d69),.c(d13),.d(c12),.e(d40),.f(d111));  // 6 ins 1 outs level 1

    xor6 x294i (.out(x294),.a(d73),.b(d108),.c(d103),.d(c26),.e(d52),.f(d83));  // 6 ins 1 outs level 1

    xor6 x293i (.out(x293),.a(c22),.b(c19),.c(d36),.d(d64),.e(d80),.f(d31));  // 6 ins 1 outs level 1

    xor6 x292i (.out(x292),.a(x290),.b(x53),.c(x34),.d(x40),.e(x47),.f(x38));  // 6 ins 1 outs level 2

    xor6 x291i (.out(x291),.a(x285),.b(x45),.c(x286),.d(x287),.e(x288),.f(x289));  // 6 ins 1 outs level 2

    xor6 x290i (.out(x290),.a(d104),.b(d97),.c(d112),.d(d65),.e(c20),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x289i (.out(x289),.a(d52),.b(d43),.c(d28),.d(d31),.e(c23),.f(c14));  // 6 ins 1 outs level 1

    xor6 x288i (.out(x288),.a(d77),.b(d85),.c(d108),.d(d81),.e(c5),.f(d48));  // 6 ins 1 outs level 1

    xor6 x287i (.out(x287),.a(d84),.b(c6),.c(d70),.d(d60),.e(d32),.f(d64));  // 6 ins 1 outs level 1

    xor6 x286i (.out(x286),.a(d44),.b(d4),.c(c27),.d(c9),.e(d66),.f(d10));  // 6 ins 1 outs level 1

    xor6 x285i (.out(x285),.a(d63),.b(d59),.c(d23),.d(c7),.e(d35),.f(d61));  // 6 ins 1 outs level 1

    xor6 x284i (.out(x284),.a(d71),.b(d51),.c(d30),.d(d56),.e(d106),.f(c24));  // 6 ins 1 outs level 1

    xor6 x283i (.out(x283),.a(x47),.b(x36),.c(x34),.d(x39),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 2

    xor6 x282i (.out(x282),.a(c17),.b(d93),.c(x274),.d(x61),.e(x44),.f(x38));  // 6 ins 1 outs level 2

    xor6 x281i (.out(x281),.a(x275),.b(x55),.c(x276),.d(x277),.e(x278),.f(x279));  // 6 ins 1 outs level 2

    xor6 x279i (.out(x279),.a(c22),.b(d36),.c(d23),.d(c7),.e(c14),.f(d78));  // 6 ins 1 outs level 1

    xor6 x278i (.out(x278),.a(d60),.b(d30),.c(d81),.d(d5),.e(d47),.f(d11));  // 6 ins 1 outs level 1

    xor6 x277i (.out(x277),.a(d98),.b(d65),.c(d53),.d(c10),.e(d72),.f(d100));  // 6 ins 1 outs level 1

    xor6 x276i (.out(x276),.a(d20),.b(d80),.c(c6),.d(d96),.e(d75),.f(c8));  // 6 ins 1 outs level 1

    xor6 x275i (.out(x275),.a(d64),.b(d105),.c(d71),.d(d43),.e(d102),.f(c5));  // 6 ins 1 outs level 1

    xor6 x274i (.out(x274),.a(d110),.b(d63),.c(d24),.d(d28),.e(d9),.f(d86));  // 6 ins 1 outs level 1

    xor6 x273i (.out(x273),.a(x266),.b(x56),.c(x37),.d(x36),.e(x32),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x272i (.out(x272),.a(x270),.b(x66),.c(x34),.d(x46),.e(x64),.f(x38));  // 6 ins 1 outs level 2

    xor6 x271i (.out(x271),.a(x267),.b(d72),.c(x52),.d(x41),.e(x268),.f(x269));  // 6 ins 1 outs level 2

    xor6 x270i (.out(x270),.a(d67),.b(c25),.c(d99),.d(d85),.e(d28),.f(d105));  // 6 ins 1 outs level 1

    xor6 x269i (.out(x269),.a(d9),.b(d80),.c(d66),.d(d61),.e(d70),.f(d118));  // 6 ins 1 outs level 1

    xor6 x268i (.out(x268),.a(d37),.b(d63),.c(d96),.d(d16),.e(c23),.f(d50));  // 6 ins 1 outs level 1

    xor6 x267i (.out(x267),.a(d26),.b(d65),.c(c8),.d(d34),.e(d10),.f(d115));  // 6 ins 1 outs level 1

    xor6 x266i (.out(x266),.a(d54),.b(c20),.c(d52),.d(c26),.e(d5),.f(d32));  // 6 ins 1 outs level 1

    xor6 x265i (.out(x265),.a(x63),.b(x39),.c(x58),.d(x42),.e(x35),.f(x45));  // 6 ins 1 outs level 2

    xor6 x264i (.out(x264),.a(x258),.b(x263),.c(x259),.d(x260),.e(x261),.f(x262));  // 6 ins 1 outs level 2

    xor6 x263i (.out(x263),.a(d27),.b(d1),.c(d102),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x262i (.out(x262),.a(d46),.b(d88),.c(d107),.d(d6),.e(d100),.f(d9));  // 6 ins 1 outs level 1

    xor6 x261i (.out(x261),.a(d59),.b(d116),.c(d34),.d(c31),.e(c17),.f(d103));  // 6 ins 1 outs level 1

    xor6 x260i (.out(x260),.a(c19),.b(d64),.c(d31),.d(d94),.e(d53),.f(d85));  // 6 ins 1 outs level 1

    xor6 x259i (.out(x259),.a(c18),.b(d115),.c(d58),.d(d28),.e(d49),.f(d20));  // 6 ins 1 outs level 1

    xor6 x258i (.out(x258),.a(d81),.b(d7),.c(d44),.d(d72),.e(d110),.f(d45));  // 6 ins 1 outs level 1

    xor6 x257i (.out(x257),.a(c28),.b(d37),.c(c6),.d(d2),.e(d35),.f(d62));  // 6 ins 1 outs level 1

    xor6 x256i (.out(x256),.a(d119),.b(x54),.c(x48),.d(x71),.e(d102),.f(x36));  // 6 ins 1 outs level 2

    xor6 x255i (.out(x255),.a(x248),.b(x249),.c(x250),.d(x251),.e(x252),.f(x253));  // 6 ins 1 outs level 2

    xor6 x253i (.out(x253),.a(d98),.b(d57),.c(d8),.d(d84),.e(d38),.f(c8));  // 6 ins 1 outs level 1

    xor6 x252i (.out(x252),.a(d31),.b(d59),.c(d26),.d(c10),.e(d13),.f(d6));  // 6 ins 1 outs level 1

    xor6 x251i (.out(x251),.a(d51),.b(d24),.c(d32),.d(d107),.e(d16),.f(d1));  // 6 ins 1 outs level 1

    xor6 x250i (.out(x250),.a(d85),.b(d39),.c(c15),.d(d96),.e(c14),.f(d94));  // 6 ins 1 outs level 1

    xor6 x249i (.out(x249),.a(d111),.b(d37),.c(d0),.d(d118),.e(d89),.f(d67));  // 6 ins 1 outs level 1

    xor6 x248i (.out(x248),.a(d72),.b(d30),.c(d68),.d(c27),.e(d44),.f(d80));  // 6 ins 1 outs level 1

    xor6 x247i (.out(x247),.a(x239),.b(x44),.c(x47),.d(x245),.e(x48),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x246i (.out(x246),.a(x240),.b(x37),.c(x241),.d(x242),.e(x243),.f(x244));  // 6 ins 1 outs level 2

    xor6 x245i (.out(x245),.a(d119),.b(d98),.c(c10),.d(d97),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x244i (.out(x244),.a(d19),.b(d38),.c(d89),.d(d73),.e(d81),.f(d56));  // 6 ins 1 outs level 1

    xor6 x243i (.out(x243),.a(d95),.b(d32),.c(d46),.d(d65),.e(d76),.f(d3));  // 6 ins 1 outs level 1

    xor6 x242i (.out(x242),.a(d37),.b(d86),.c(d68),.d(d1),.e(d71),.f(d45));  // 6 ins 1 outs level 1

    xor6 x241i (.out(x241),.a(d40),.b(d39),.c(c15),.d(c31),.e(c23),.f(d10));  // 6 ins 1 outs level 1

    xor6 x240i (.out(x240),.a(c9),.b(d25),.c(d60),.d(d100),.e(d31),.f(c2));  // 6 ins 1 outs level 1

    xor6 x239i (.out(x239),.a(d49),.b(c7),.c(d90),.d(c12),.e(d33),.f(d80));  // 6 ins 1 outs level 1

    xor6 x238i (.out(x238),.a(x231),.b(x70),.c(x34),.d(x58),.e(x55),.f(x52));  // 6 ins 1 outs level 2

    xor6 x237i (.out(x237),.a(d82),.b(x232),.c(x233),.d(x234),.e(x235),.f(x236));  // 6 ins 1 outs level 2

    xor6 x236i (.out(x236),.a(c6),.b(d80),.c(d74),.d(d48),.e(d111),.f(d115));  // 6 ins 1 outs level 1

    xor6 x235i (.out(x235),.a(d70),.b(c31),.c(c2),.d(d45),.e(d81),.f(c27));  // 6 ins 1 outs level 1

    xor6 x234i (.out(x234),.a(c18),.b(d117),.c(d19),.d(d119),.e(d118),.f(d57));  // 6 ins 1 outs level 1

    xor6 x233i (.out(x233),.a(c26),.b(d50),.c(c29),.d(d2),.e(d59),.f(d110));  // 6 ins 1 outs level 1

    xor6 x232i (.out(x232),.a(d75),.b(d86),.c(d0),.d(d68),.e(d40),.f(d69));  // 6 ins 1 outs level 1

    xor6 x231i (.out(x231),.a(d62),.b(d3),.c(c7),.d(d15),.e(d18),.f(d30));  // 6 ins 1 outs level 1

    xor6 x230i (.out(x230),.a(x223),.b(x70),.c(x52),.d(x46),.e(x41),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x229i (.out(x229),.a(x224),.b(x225),.c(x226),.d(x227),.e(x228),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x228i (.out(x228),.a(d0),.b(d64),.c(d71),.d(d67),.e(d114),.f(d65));  // 6 ins 1 outs level 1

    xor6 x227i (.out(x227),.a(c27),.b(d63),.c(d19),.d(c30),.e(d99),.f(c19));  // 6 ins 1 outs level 1

    xor6 x226i (.out(x226),.a(c23),.b(d42),.c(d13),.d(d47),.e(d20),.f(d72));  // 6 ins 1 outs level 1

    xor6 x225i (.out(x225),.a(d10),.b(c3),.c(c4),.d(d74),.e(d59),.f(d46));  // 6 ins 1 outs level 1

    xor6 x224i (.out(x224),.a(d49),.b(d1),.c(d54),.d(c18),.e(d61),.f(d51));  // 6 ins 1 outs level 1

    xor6 x223i (.out(x223),.a(d50),.b(d69),.c(d95),.d(d92),.e(d5),.f(d21));  // 6 ins 1 outs level 1

    xor6 x222i (.out(x222),.a(x216),.b(x66),.c(x64),.d(x42),.e(x35),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x221i (.out(x221),.a(x217),.b(x34),.c(x52),.d(x220),.e(x218),.f(x219));  // 6 ins 1 outs level 2

    xor6 x220i (.out(x220),.a(d71),.b(d91),.c(d119),.d(d107),.e(d100),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x219i (.out(x219),.a(d70),.b(d45),.c(d41),.d(d10),.e(d4),.f(d32));  // 6 ins 1 outs level 1

    xor6 x218i (.out(x218),.a(d29),.b(c19),.c(d21),.d(d40),.e(d72),.f(d55));  // 6 ins 1 outs level 1

    xor6 x217i (.out(x217),.a(d60),.b(d14),.c(d108),.d(d62),.e(c7),.f(d54));  // 6 ins 1 outs level 1

    xor6 x216i (.out(x216),.a(d64),.b(d8),.c(d102),.d(d42),.e(d79),.f(d80));  // 6 ins 1 outs level 1

    xor6 x215i (.out(x215),.a(x208),.b(x70),.c(x37),.d(x47),.e(x39),.f(x36));  // 6 ins 1 outs level 2

    xor6 x214i (.out(x214),.a(x209),.b(x68),.c(x213),.d(x210),.e(x211),.f(x212));  // 6 ins 1 outs level 2

    xor6 x213i (.out(x213),.a(d42),.b(d95),.c(d16),.d(d3),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x212i (.out(x212),.a(d77),.b(d45),.c(c17),.d(d116),.e(d22),.f(d68));  // 6 ins 1 outs level 1

    xor6 x211i (.out(x211),.a(d60),.b(d28),.c(d15),.d(d71),.e(c28),.f(d52));  // 6 ins 1 outs level 1

    xor6 x210i (.out(x210),.a(d54),.b(d29),.c(d37),.d(d47),.e(d111),.f(c23));  // 6 ins 1 outs level 1

    xor6 x209i (.out(x209),.a(d108),.b(c30),.c(d10),.d(d4),.e(c15),.f(c18));  // 6 ins 1 outs level 1

    xor6 x208i (.out(x208),.a(d57),.b(d69),.c(d93),.d(d5),.e(c16),.f(d1));  // 6 ins 1 outs level 1

    xor6 x207i (.out(x207),.a(x47),.b(x32),.c(x54),.d(x45),.e(x34),.f(x55));  // 6 ins 1 outs level 2

    xor6 x206i (.out(x206),.a(x201),.b(x58),.c(x202),.d(x203),.e(x204),.f(x205));  // 6 ins 1 outs level 2

    xor6 x205i (.out(x205),.a(c17),.b(d119),.c(d59),.d(d54),.e(c26),.f(d23));  // 6 ins 1 outs level 1

    xor6 x204i (.out(x204),.a(c7),.b(d51),.c(d34),.d(d50),.e(c24),.f(d80));  // 6 ins 1 outs level 1

    xor6 x203i (.out(x203),.a(d37),.b(d68),.c(d77),.d(d67),.e(d114),.f(d70));  // 6 ins 1 outs level 1

    xor6 x202i (.out(x202),.a(d118),.b(c25),.c(c19),.d(d42),.e(d66),.f(d52));  // 6 ins 1 outs level 1

    xor6 x201i (.out(x201),.a(d10),.b(d4),.c(d73),.d(d22),.e(d57),.f(d112));  // 6 ins 1 outs level 1

    xor6 x200i (.out(x200),.a(x193),.b(x54),.c(x58),.d(x48),.e(x38),.f(x198));  // 6 ins 1 outs level 2

    xor6 x199i (.out(x199),.a(x194),.b(x63),.c(x71),.d(x195),.e(x196),.f(x197));  // 6 ins 1 outs level 2

    xor6 x198i (.out(x198),.a(d85),.b(d78),.c(d77),.d(d74),.e(d94),.f(d51));  // 6 ins 1 outs level 1

    xor6 x197i (.out(x197),.a(d23),.b(d53),.c(d69),.d(d34),.e(d96),.f(c25));  // 6 ins 1 outs level 1

    xor6 x196i (.out(x196),.a(c8),.b(d71),.c(d68),.d(d5),.e(d83),.f(c18));  // 6 ins 1 outs level 1

    xor6 x195i (.out(x195),.a(d70),.b(d89),.c(c31),.d(d46),.e(d55),.f(d65));  // 6 ins 1 outs level 1

    xor6 x194i (.out(x194),.a(d60),.b(d64),.c(d81),.d(d102),.e(d16),.f(d66));  // 6 ins 1 outs level 1

    xor6 x193i (.out(x193),.a(d61),.b(d84),.c(d103),.d(d33),.e(d79),.f(d67));  // 6 ins 1 outs level 1

    xor6 x192i (.out(x192),.a(x184),.b(x32),.c(x190),.d(x33),.e(x38),.f(x53));  // 6 ins 1 outs level 2

    xor6 x191i (.out(x191),.a(x185),.b(x55),.c(x186),.d(x187),.e(x188),.f(x189));  // 6 ins 1 outs level 2

    xor6 x190i (.out(x190),.a(d19),.b(d71),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x189i (.out(x189),.a(d69),.b(c7),.c(d75),.d(d2),.e(d9),.f(d35));  // 6 ins 1 outs level 1

    xor6 x188i (.out(x188),.a(d41),.b(d56),.c(d39),.d(d59),.e(d73),.f(d45));  // 6 ins 1 outs level 1

    xor6 x187i (.out(x187),.a(d83),.b(d106),.c(d66),.d(d90),.e(d77),.f(d32));  // 6 ins 1 outs level 1

    xor6 x186i (.out(x186),.a(d62),.b(d14),.c(d80),.d(d113),.e(d5),.f(d27));  // 6 ins 1 outs level 1

    xor6 x185i (.out(x185),.a(c19),.b(d13),.c(d94),.d(c21),.e(d109),.f(d95));  // 6 ins 1 outs level 1

    xor6 x184i (.out(x184),.a(d115),.b(d86),.c(c18),.d(d16),.e(d29),.f(d87));  // 6 ins 1 outs level 1

    xor6 x183i (.out(x183),.a(x175),.b(x50),.c(x44),.d(x42),.e(x181),.f(x65));  // 6 ins 1 outs level 2

    xor6 x182i (.out(x182),.a(x176),.b(x46),.c(x177),.d(x178),.e(x179),.f(x180));  // 6 ins 1 outs level 2

    xor6 x181i (.out(x181),.a(d0),.b(d14),.c(d52),.d(d85),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x180i (.out(x180),.a(d66),.b(d33),.c(d102),.d(d32),.e(d60),.f(d65));  // 6 ins 1 outs level 1

    xor6 x179i (.out(x179),.a(d103),.b(d26),.c(d110),.d(d16),.e(d25),.f(d71));  // 6 ins 1 outs level 1

    xor6 x178i (.out(x178),.a(c17),.b(c14),.c(d57),.d(d73),.e(d48),.f(d24));  // 6 ins 1 outs level 1

    xor6 x177i (.out(x177),.a(d20),.b(d4),.c(d90),.d(d9),.e(c3),.f(d94));  // 6 ins 1 outs level 1

    xor6 x176i (.out(x176),.a(d49),.b(d2),.c(d47),.d(d91),.e(d12),.f(c20));  // 6 ins 1 outs level 1

    xor6 x175i (.out(x175),.a(d68),.b(d105),.c(d108),.d(c2),.e(d44),.f(d82));  // 6 ins 1 outs level 1

    xor6 x174i (.out(x174),.a(x167),.b(x66),.c(x44),.d(x52),.e(x32),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x173i (.out(x173),.a(x168),.b(x38),.c(x169),.d(x170),.e(x171),.f(x172));  // 6 ins 1 outs level 2

    xor6 x172i (.out(x172),.a(d71),.b(d116),.c(c17),.d(d102),.e(d82),.f(d97));  // 6 ins 1 outs level 1

    xor6 x171i (.out(x171),.a(c28),.b(d53),.c(d46),.d(c6),.e(d63),.f(c3));  // 6 ins 1 outs level 1

    xor6 x170i (.out(x170),.a(d111),.b(c8),.c(d92),.d(d42),.e(d104),.f(d101));  // 6 ins 1 outs level 1

    xor6 x169i (.out(x169),.a(c23),.b(d110),.c(d1),.d(d41),.e(d4),.f(c4));  // 6 ins 1 outs level 1

    xor6 x168i (.out(x168),.a(d77),.b(d13),.c(c14),.d(c25),.e(d24),.f(d86));  // 6 ins 1 outs level 1

    xor6 x167i (.out(x167),.a(c16),.b(c9),.c(d96),.d(d21),.e(d57),.f(c13));  // 6 ins 1 outs level 1

    xor6 x166i (.out(x166),.a(x63),.b(x61),.c(x56),.d(x36),.e(x32),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x165i (.out(x165),.a(x40),.b(x41),.c(x38),.d(x46),.e(x42),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x164i (.out(x164),.a(x158),.b(x163),.c(x159),.d(x160),.e(x161),.f(x162));  // 6 ins 1 outs level 2

    xor6 x163i (.out(x163),.a(d98),.b(c10),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x162i (.out(x162),.a(d87),.b(d109),.c(d99),.d(d42),.e(d112),.f(d3));  // 6 ins 1 outs level 1

    xor6 x161i (.out(x161),.a(c22),.b(d25),.c(d78),.d(c23),.e(d66),.f(d10));  // 6 ins 1 outs level 1

    xor6 x160i (.out(x160),.a(d69),.b(d88),.c(c0),.d(d5),.e(d18),.f(c26));  // 6 ins 1 outs level 1

    xor6 x159i (.out(x159),.a(c6),.b(d54),.c(d64),.d(d14),.e(d62),.f(d83));  // 6 ins 1 outs level 1

    xor6 x158i (.out(x158),.a(d19),.b(d91),.c(d95),.d(d6),.e(c21),.f(d56));  // 6 ins 1 outs level 1

    xor6 x157i (.out(x157),.a(c24),.b(d60),.c(d106),.d(d28),.e(d72),.f(d82));  // 6 ins 1 outs level 1

    xor6 x156i (.out(x156),.a(x148),.b(x154),.c(x44),.d(x53),.e(x65),.f(x153));  // 6 ins 1 outs level 2

    xor6 x155i (.out(x155),.a(x149),.b(x54),.c(x39),.d(x150),.e(x151),.f(x152));  // 6 ins 1 outs level 2

    xor6 x154i (.out(x154),.a(c5),.b(d84),.c(d100),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x153i (.out(x153),.a(d19),.b(d71),.c(d114),.d(d118),.e(d87),.f(d77));  // 6 ins 1 outs level 1

    xor6 x152i (.out(x152),.a(d65),.b(c16),.c(c23),.d(c30),.e(d56),.f(d11));  // 6 ins 1 outs level 1

    xor6 x151i (.out(x151),.a(d103),.b(c0),.c(d73),.d(d42),.e(c1),.f(d89));  // 6 ins 1 outs level 1

    xor6 x150i (.out(x150),.a(d23),.b(d64),.c(d6),.d(d61),.e(d107),.f(d51));  // 6 ins 1 outs level 1

    xor6 x149i (.out(x149),.a(c26),.b(d93),.c(d63),.d(d3),.e(d33),.f(d2));  // 6 ins 1 outs level 1

    xor6 x148i (.out(x148),.a(d75),.b(d8),.c(d1),.d(d4),.e(d35),.f(d48));  // 6 ins 1 outs level 1

    xor6 x147i (.out(x147),.a(x139),.b(x68),.c(x35),.d(x145),.e(x48),.f(x61));  // 6 ins 1 outs level 2

    xor6 x146i (.out(x146),.a(x140),.b(x49),.c(x141),.d(x142),.e(x143),.f(x144));  // 6 ins 1 outs level 2

    xor6 x145i (.out(x145),.a(d104),.b(d80),.c(d95),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x144i (.out(x144),.a(d16),.b(d56),.c(d5),.d(d4),.e(d97),.f(d116));  // 6 ins 1 outs level 1

    xor6 x143i (.out(x143),.a(d118),.b(d76),.c(d94),.d(d3),.e(d64),.f(d78));  // 6 ins 1 outs level 1

    xor6 x142i (.out(x142),.a(d14),.b(d8),.c(d105),.d(d33),.e(c3),.f(c6));  // 6 ins 1 outs level 1

    xor6 x141i (.out(x141),.a(c28),.b(d58),.c(d71),.d(d85),.e(d30),.f(d12));  // 6 ins 1 outs level 1

    xor6 x140i (.out(x140),.a(c31),.b(d84),.c(d74),.d(c9),.e(d44),.f(d62));  // 6 ins 1 outs level 1

    xor6 x139i (.out(x139),.a(d23),.b(d119),.c(d55),.d(d88),.e(d24),.f(d72));  // 6 ins 1 outs level 1

    xor6 x138i (.out(x138),.a(x132),.b(x63),.c(x66),.d(x47),.e(x37),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x137i (.out(x137),.a(x133),.b(x39),.c(x49),.d(x136),.e(x134),.f(x135));  // 6 ins 1 outs level 2

    xor6 x136i (.out(x136),.a(d19),.b(d104),.c(d119),.d(c12),.e(d99),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x135i (.out(x135),.a(d75),.b(d51),.c(d50),.d(d56),.e(d111),.f(d91));  // 6 ins 1 outs level 1

    xor6 x134i (.out(x134),.a(d35),.b(c15),.c(d110),.d(d26),.e(d22),.f(d24));  // 6 ins 1 outs level 1

    xor6 x133i (.out(x133),.a(c6),.b(d17),.c(d48),.d(d4),.e(d102),.f(c11));  // 6 ins 1 outs level 1

    xor6 x132i (.out(x132),.a(d95),.b(d16),.c(c27),.d(d32),.e(d78),.f(d21));  // 6 ins 1 outs level 1

    xor6 x131i (.out(x131),.a(x123),.b(x34),.c(x129),.d(x32),.e(x38),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x130i (.out(x130),.a(x124),.b(x45),.c(x125),.d(x126),.e(x127),.f(x128));  // 6 ins 1 outs level 2

    xor6 x129i (.out(x129),.a(d6),.b(d77),.c(d76),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs level 1

    xor6 x128i (.out(x128),.a(d57),.b(d14),.c(d18),.d(d30),.e(d60),.f(d49));  // 6 ins 1 outs level 1

    xor6 x127i (.out(x127),.a(d9),.b(d106),.c(d79),.d(d17),.e(d111),.f(d0));  // 6 ins 1 outs level 1

    xor6 x126i (.out(x126),.a(d27),.b(c4),.c(c2),.d(c5),.e(d22),.f(d38));  // 6 ins 1 outs level 1

    xor6 x125i (.out(x125),.a(d78),.b(d1),.c(d103),.d(d33),.e(d5),.f(d84));  // 6 ins 1 outs level 1

    xor6 x124i (.out(x124),.a(d58),.b(d88),.c(d47),.d(c17),.e(d36),.f(d13));  // 6 ins 1 outs level 1

    xor6 x123i (.out(x123),.a(d23),.b(d110),.c(d62),.d(d82),.e(c15),.f(d92));  // 6 ins 1 outs level 1

    xor6 x122i (.out(x122),.a(x68),.b(x39),.c(x40),.d(x33),.e(x56),.f(x38));  // 6 ins 1 outs level 2

    xor6 x121i (.out(x121),.a(x115),.b(x120),.c(x116),.d(x117),.e(x118),.f(x119));  // 6 ins 1 outs level 2

    xor6 x120i (.out(x120),.a(d32),.b(d107),.c(c3),.d(d88),.e(1'b0),.f(1'b0));  // 4 ins 1 outs level 1

    xor6 x119i (.out(x119),.a(d28),.b(d70),.c(d2),.d(d59),.e(d46),.f(d86));  // 6 ins 1 outs level 1

    xor6 x118i (.out(x118),.a(d22),.b(c25),.c(d84),.d(d19),.e(c24),.f(d6));  // 6 ins 1 outs level 1

    xor6 x117i (.out(x117),.a(c30),.b(d105),.c(c23),.d(c2),.e(d77),.f(c8));  // 6 ins 1 outs level 1

    xor6 x116i (.out(x116),.a(d114),.b(d10),.c(d118),.d(c14),.e(d49),.f(d85));  // 6 ins 1 outs level 1

    xor6 x115i (.out(x115),.a(d68),.b(d26),.c(d101),.d(d104),.e(c19),.f(c0));  // 6 ins 1 outs level 1

    xor6 x114i (.out(x114),.a(d37),.b(d112),.c(c13),.d(d39),.e(d96),.f(d15));  // 6 ins 1 outs level 1

    xor6 x113i (.out(x113),.a(x107),.b(x55),.c(x64),.d(x35),.e(x50),.f(x40));  // 6 ins 1 outs level 2

    xor6 x112i (.out(x112),.a(x108),.b(x36),.c(x44),.d(x109),.e(x110),.f(x111));  // 6 ins 1 outs level 2

    xor6 x111i (.out(x111),.a(d71),.b(d85),.c(d28),.d(d69),.e(d90),.f(d11));  // 6 ins 1 outs level 1

    xor6 x110i (.out(x110),.a(d87),.b(d100),.c(d105),.d(d44),.e(d84),.f(c26));  // 6 ins 1 outs level 1

    xor6 x109i (.out(x109),.a(d79),.b(d118),.c(d75),.d(c31),.e(d108),.f(d35));  // 6 ins 1 outs level 1

    xor6 x108i (.out(x108),.a(d119),.b(d8),.c(d51),.d(d13),.e(d81),.f(d32));  // 6 ins 1 outs level 1

    xor6 x107i (.out(x107),.a(c6),.b(d38),.c(c19),.d(c18),.e(d60),.f(d63));  // 6 ins 1 outs level 1

    xor6 x106i (.out(x106),.a(x99),.b(x65),.c(x70),.d(x34),.e(x104),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x105i (.out(x105),.a(x100),.b(x56),.c(x46),.d(x101),.e(x102),.f(x103));  // 6 ins 1 outs level 2

    xor6 x104i (.out(x104),.a(d72),.b(c27),.c(d93),.d(d64),.e(d81),.f(d52));  // 6 ins 1 outs level 1

    xor6 x103i (.out(x103),.a(d107),.b(d106),.c(d87),.d(d33),.e(d21),.f(d25));  // 6 ins 1 outs level 1

    xor6 x102i (.out(x102),.a(d26),.b(d51),.c(d50),.d(d16),.e(d23),.f(d115));  // 6 ins 1 outs level 1

    xor6 x101i (.out(x101),.a(d41),.b(d86),.c(c2),.d(d28),.e(d103),.f(d79));  // 6 ins 1 outs level 1

    xor6 x100i (.out(x100),.a(d114),.b(d45),.c(c16),.d(d34),.e(c26),.f(d30));  // 6 ins 1 outs level 1

    xor6 x99i (.out(x99),.a(d8),.b(d88),.c(d18),.d(d12),.e(d90),.f(c3));  // 6 ins 1 outs level 1

    xor6 x98i (.out(x98),.a(x95),.b(x54),.c(x39),.d(x34),.e(x96),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x97i (.out(x97),.a(d71),.b(x92),.c(x53),.d(x93),.e(x94),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x96i (.out(x96),.a(d104),.b(d87),.c(d37),.d(c19),.e(d17),.f(d13));  // 6 ins 1 outs level 1

    xor6 x95i (.out(x95),.a(d105),.b(d62),.c(d91),.d(d99),.e(d73),.f(d66));  // 6 ins 1 outs level 1

    xor6 x94i (.out(x94),.a(c17),.b(d89),.c(d107),.d(c1),.e(c6),.f(d49));  // 6 ins 1 outs level 1

    xor6 x93i (.out(x93),.a(d79),.b(c3),.c(c26),.d(d34),.e(d40),.f(d110));  // 6 ins 1 outs level 1

    xor6 x92i (.out(x92),.a(d80),.b(d56),.c(c7),.d(d93),.e(d94),.f(d44));  // 6 ins 1 outs level 1

    xor6 x91i (.out(x91),.a(d53),.b(c11),.c(d51),.d(c14),.e(d5),.f(d24));  // 6 ins 1 outs level 1

    xor6 x90i (.out(x90),.a(x83),.b(x54),.c(x41),.d(x37),.e(x39),.f(x32));  // 6 ins 1 outs level 2

    xor6 x89i (.out(x89),.a(x84),.b(x33),.c(x88),.d(x85),.e(x86),.f(x87));  // 6 ins 1 outs level 2

    xor6 x88i (.out(x88),.a(d50),.b(c4),.c(c11),.d(d19),.e(d34),.f(1'b0));  // 5 ins 1 outs level 1

    xor6 x87i (.out(x87),.a(d93),.b(c5),.c(d85),.d(d37),.e(d27),.f(c12));  // 6 ins 1 outs level 1

    xor6 x86i (.out(x86),.a(c16),.b(d82),.c(d26),.d(d57),.e(d16),.f(c21));  // 6 ins 1 outs level 1

    xor6 x85i (.out(x85),.a(d73),.b(d61),.c(d92),.d(d66),.e(d109),.f(d68));  // 6 ins 1 outs level 1

    xor6 x84i (.out(x84),.a(d43),.b(d23),.c(d24),.d(d100),.e(d47),.f(c6));  // 6 ins 1 outs level 1

    xor6 x83i (.out(x83),.a(d48),.b(d90),.c(d74),.d(d62),.e(d67),.f(d55));  // 6 ins 1 outs level 1

    xor6 x82i (.out(x82),.a(x53),.b(x52),.c(x47),.d(x63),.e(x49),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x81i (.out(x81),.a(x74),.b(x54),.c(x32),.d(x44),.e(x38),.f(1'b0));  // 5 ins 1 outs level 2

    xor6 x80i (.out(x80),.a(x75),.b(x79),.c(x33),.d(x76),.e(x77),.f(x78));  // 6 ins 1 outs level 2

    xor6 x79i (.out(x79),.a(d19),.b(d77),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs level 1

    xor6 x78i (.out(x78),.a(d8),.b(d60),.c(d80),.d(d74),.e(d1),.f(d56));  // 6 ins 1 outs level 1

    xor6 x77i (.out(x77),.a(d36),.b(d62),.c(d111),.d(d39),.e(d93),.f(d102));  // 6 ins 1 outs level 1

    xor6 x76i (.out(x76),.a(d115),.b(d29),.c(d118),.d(c25),.e(d27),.f(d47));  // 6 ins 1 outs level 1

    xor6 x75i (.out(x75),.a(d9),.b(c5),.c(d52),.d(d38),.e(c15),.f(d34));  // 6 ins 1 outs level 1

    xor6 x74i (.out(x74),.a(d55),.b(d65),.c(d20),.d(c12),.e(d82),.f(d72));  // 6 ins 1 outs level 1

    xor6 x72i (.out(x72),.a(x38),.b(d10),.c(d66),.d(x40),.e(1'b0),.f(1'b0));  // 4 ins 3 outs level 2

    xor6 x71i (.out(x71),.a(d36),.b(d2),.c(c26),.d(c1),.e(d103),.f(1'b0));  // 5 ins 3 outs level 1

    xor6 x70i (.out(x70),.a(d4),.b(d39),.c(d41),.d(d110),.e(d58),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x69i (.out(x69),.a(d109),.b(d61),.c(c21),.d(x48),.e(d94),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x68i (.out(x68),.a(d34),.b(d113),.c(c7),.d(d23),.e(d21),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x67i (.out(x67),.a(d112),.b(x34),.c(x36),.d(d37),.e(c24),.f(1'b0));  // 5 ins 3 outs level 2

    xor6 x66i (.out(x66),.a(d68),.b(d5),.c(d75),.d(d12),.e(d30),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x65i (.out(x65),.a(d64),.b(d17),.c(c19),.d(c31),.e(d83),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x64i (.out(x64),.a(d25),.b(d84),.c(c5),.d(c20),.e(d7),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x63i (.out(x63),.a(d86),.b(d47),.c(c14),.d(d16),.e(d13),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x62i (.out(x62),.a(d25),.b(d67),.c(x49),.d(d62),.e(x35),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x61i (.out(x61),.a(d57),.b(d66),.c(c16),.d(d118),.e(d114),.f(1'b0));  // 5 ins 5 outs level 1

    xor6 x60i (.out(x60),.a(d41),.b(c25),.c(x45),.d(d58),.e(d36),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x59i (.out(x59),.a(d52),.b(d14),.c(x41),.d(c26),.e(d99),.f(1'b0));  // 5 ins 7 outs level 2

    xor6 x58i (.out(x58),.a(d31),.b(d65),.c(d38),.d(d11),.e(d12),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x57i (.out(x57),.a(d69),.b(d85),.c(x37),.d(d17),.e(c0),.f(1'b0));  // 5 ins 6 outs level 2

    xor6 x56i (.out(x56),.a(c7),.b(d91),.c(c18),.d(d48),.e(c5),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x55i (.out(x55),.a(d33),.b(d113),.c(d63),.d(c27),.e(c15),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x54i (.out(x54),.a(d35),.b(c22),.c(c27),.d(d88),.e(d79),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x53i (.out(x53),.a(d26),.b(d42),.c(c8),.d(d27),.e(d96),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x52i (.out(x52),.a(d6),.b(d91),.c(d81),.d(d73),.e(d47),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x51i (.out(x51),.a(x32),.b(d76),.c(d32),.d(d43),.e(d1),.f(1'b0));  // 5 ins 8 outs level 2

    xor6 x50i (.out(x50),.a(d28),.b(d40),.c(d78),.d(d3),.e(d107),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x49i (.out(x49),.a(d77),.b(d100),.c(c23),.d(c3),.e(d90),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x48i (.out(x48),.a(d108),.b(d9),.c(d18),.d(c0),.e(c20),.f(1'b0));  // 5 ins 7 outs level 1

    xor6 x47i (.out(x47),.a(d46),.b(d8),.c(c21),.d(d84),.e(d109),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x46i (.out(x46),.a(d55),.b(d70),.c(c6),.d(d110),.e(c15),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x45i (.out(x45),.a(d60),.b(d45),.c(c13),.d(d101),.e(1'b0),.f(1'b0));  // 4 ins 10 outs level 1

    xor6 x44i (.out(x44),.a(d54),.b(d27),.c(d15),.d(d49),.e(d59),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x43i (.out(x43),.a(d80),.b(x39),.c(d79),.d(d106),.e(d24),.f(1'b0));  // 5 ins 11 outs level 2

    xor6 x42i (.out(x42),.a(d2),.b(d56),.c(d50),.d(d51),.e(d74),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x41i (.out(x41),.a(d53),.b(d58),.c(d7),.d(c11),.e(d111),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x40i (.out(x40),.a(d92),.b(d102),.c(d93),.d(d22),.e(c4),.f(1'b0));  // 5 ins 8 outs level 1

    xor6 x39i (.out(x39),.a(d114),.b(d29),.c(d44),.d(d115),.e(d94),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x38i (.out(x38),.a(c29),.b(d52),.c(c16),.d(d31),.e(d117),.f(1'b0));  // 5 ins 13 outs level 1

    xor6 x37i (.out(x37),.a(d105),.b(d0),.c(c22),.d(d87),.e(c31),.f(1'b0));  // 5 ins 9 outs level 1

    xor6 x36i (.out(x36),.a(c9),.b(d97),.c(d75),.d(c30),.e(d103),.f(1'b0));  // 5 ins 10 outs level 1

    xor6 x35i (.out(x35),.a(d112),.b(c24),.c(c12),.d(d20),.e(c25),.f(1'b0));  // 5 ins 6 outs level 1

    xor6 x34i (.out(x34),.a(c28),.b(d82),.c(d116),.d(d95),.e(d83),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x33i (.out(x33),.a(c2),.b(d89),.c(d50),.d(c17),.e(c1),.f(1'b0));  // 5 ins 11 outs level 1

    xor6 x32i (.out(x32),.a(c10),.b(d98),.c(d119),.d(d104),.e(d113),.f(1'b0));  // 5 ins 12 outs level 1

    xor6 x23i (.out(x23),.a(x80),.b(x36),.c(x57),.d(x81),.e(x82),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x22i (.out(x22),.a(x89),.b(x48),.c(x59),.d(x60),.e(x58),.f(x90));  // 6 ins 1 outs level 3

    xor6 x21i (.out(x21),.a(x91),.b(x72),.c(x69),.d(x97),.e(x98),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x20i (.out(x20),.a(x105),.b(x32),.c(x69),.d(x60),.e(x106),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x19i (.out(x19),.a(x112),.b(x33),.c(x63),.d(x43),.e(x113),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x18i (.out(x18),.a(x114),.b(x43),.c(x59),.d(x121),.e(x122),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x17i (.out(x17),.a(x130),.b(x62),.c(x56),.d(x57),.e(x131),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x16i (.out(x16),.a(x137),.b(x33),.c(x61),.d(x67),.e(x138),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x15i (.out(x15),.a(x146),.b(x33),.c(x45),.d(x44),.e(x59),.f(x147));  // 6 ins 1 outs level 3

    xor6 x14i (.out(x14),.a(x155),.b(x35),.c(x46),.d(x59),.e(x51),.f(x156));  // 6 ins 1 outs level 3

    xor6 x13i (.out(x13),.a(x157),.b(x51),.c(x165),.d(x166),.e(x164),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x12i (.out(x12),.a(x173),.b(x42),.c(x69),.d(x57),.e(x174),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x11i (.out(x11),.a(x182),.b(x38),.c(x60),.d(x51),.e(x183),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x10i (.out(x10),.a(x191),.b(x37),.c(x46),.d(x50),.e(x60),.f(x192));  // 6 ins 1 outs level 3

    xor6 x9i (.out(x9),.a(x199),.b(x70),.c(x51),.d(x43),.e(x200),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x8i (.out(x8),.a(x206),.b(x36),.c(x50),.d(x57),.e(x51),.f(x207));  // 6 ins 1 outs level 3

    xor6 x7i (.out(x7),.a(x214),.b(x42),.c(x64),.d(x43),.e(x51),.f(x215));  // 6 ins 1 outs level 3

    xor6 x6i (.out(x6),.a(x221),.b(x72),.c(x58),.d(x51),.e(x222),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x5i (.out(x5),.a(x229),.b(x50),.c(x67),.d(x43),.e(x230),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x4i (.out(x4),.a(x237),.b(x36),.c(x47),.d(x62),.e(x43),.f(x238));  // 6 ins 1 outs level 3

    xor6 x3i (.out(x3),.a(x246),.b(x57),.c(x71),.d(x59),.e(x247),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x2i (.out(x2),.a(x255),.b(x46),.c(x65),.d(x59),.e(x256),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x1i (.out(x1),.a(x257),.b(x43),.c(x55),.d(x57),.e(x264),.f(x265));  // 6 ins 1 outs level 3

    xor6 x0i (.out(x0),.a(x271),.b(x45),.c(x43),.d(x273),.e(x272),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x31i (.out(x31),.a(x281),.b(x62),.c(x49),.d(x283),.e(x282),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x30i (.out(x30),.a(x284),.b(x43),.c(x59),.d(x291),.e(x292),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x29i (.out(x29),.a(x60),.b(x293),.c(x53),.d(x64),.e(x299),.f(x300));  // 6 ins 1 outs level 3

    xor6 x28i (.out(x28),.a(x301),.b(x43),.c(x62),.d(x66),.e(x307),.f(x308));  // 6 ins 1 outs level 3

    xor6 x27i (.out(x27),.a(x316),.b(x43),.c(x45),.d(x41),.e(x62),.f(x317));  // 6 ins 1 outs level 3

    xor6 x26i (.out(x26),.a(x324),.b(x72),.c(x37),.d(x62),.e(x325),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x25i (.out(x25),.a(x332),.b(x32),.c(x60),.d(x333),.e(x334),.f(1'b0));  // 5 ins 1 outs level 3

    xor6 x24i (.out(x24),.a(x342),.b(x33),.c(x61),.d(x67),.e(x51),.f(x343));  // 6 ins 1 outs level 3

endmodule

