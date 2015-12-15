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

//// CRC-32 of 16 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 2
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 0000000000111111
//        01234567890123456789012345678901 0123456789012345
//
// C00  = ................X.....X..XX.X... X.....X..XX.X...
// C01  = ................XX....XX.X.XXX.. XX....XX.X.XXX..
// C02  = ................XXX...XXXX...XX. XXX...XXXX...XX.
// C03  = .................XXX...XXXX...XX .XXX...XXXX...XX
// C04  = ................X.XXX.X.X..XX..X X.XXX.X.X..XX..X
// C05  = ................XX.XXXXX..X..X.. XX.XXXXX..X..X..
// C06  = .................XX.XXXXX..X..X. .XX.XXXXX..X..X.
// C07  = ................X.XX.X.XX.X....X X.XX.X.XX.X....X
// C08  = ................XX.XX...X.XXX... XX.XX...X.XXX...
// C09  = .................XX.XX...X.XXX.. .XX.XX...X.XXX..
// C10  = ................X.XX.X...X...XX. X.XX.X...X...XX.
// C11  = ................XX.XX....X..X.XX XX.XX....X..X.XX
// C12  = ................XXX.XXX..X..XX.X XXX.XXX..X..XX.X
// C13  = .................XXX.XXX..X..XX. .XXX.XXX..X..XX.
// C14  = ..................XXX.XXX..X..XX ..XXX.XXX..X..XX
// C15  = ...................XXX.XXX..X..X ...XXX.XXX..X..X
// C16  = X...............X...XX..X...XX.. X...XX..X...XX..
// C17  = .X...............X...XX..X...XX. .X...XX..X...XX.
// C18  = ..X...............X...XX..X...XX ..X...XX..X...XX
// C19  = ...X...............X...XX..X...X ...X...XX..X...X
// C20  = ....X...............X...XX..X... ....X...XX..X...
// C21  = .....X...............X...XX..X.. .....X...XX..X..
// C22  = ......X.........X........X.XX.X. X........X.XX.X.
// C23  = .......X........XX....X..X...X.X XX....X..X...X.X
// C24  = ........X........XX....X..X...X. .XX....X..X...X.
// C25  = .........X........XX....X..X...X ..XX....X..X...X
// C26  = ..........X.....X..XX.X...X..... X..XX.X...X.....
// C27  = ...........X.....X..XX.X...X.... .X..XX.X...X....
// C28  = ............X.....X..XX.X...X... ..X..XX.X...X...
// C29  = .............X.....X..XX.X...X.. ...X..XX.X...X..
// C30  = ..............X.....X..XX.X...X. ....X..XX.X...X.
// C31  = ...............X.....X..XX.X...X .....X..XX.X...X
//
module crc32_dat16 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [15:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat16_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat16_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat16_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [15:0] dat_in;
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
    d15;

assign { d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [15:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x15 = d12 ^ c28 ^ d9 ^ c31 ^ d15 ^ c25 ^ d8 ^ c19 ^ c20 ^ 
        d3 ^ c23 ^ d5 ^ c24 ^ d7 ^ c21 ^ d4;  // 16 ins 1 outs

    assign x14 = d11 ^ c27 ^ d8 ^ c30 ^ d14 ^ c24 ^ d7 ^ d15 ^ c22 ^ 
        d4 ^ c18 ^ c19 ^ d2 ^ c20 ^ d3 ^ c23 ^ d6 ^ c31;  // 18 ins 1 outs

    assign x13 = d10 ^ c26 ^ d7 ^ c29 ^ d6 ^ d14 ^ c18 ^ d1 ^ c17 ^ 
        c19 ^ c22 ^ d5 ^ d2 ^ c21 ^ d3 ^ c30 ^ c23 ^ d13;  // 18 ins 1 outs

    assign x12 = d9 ^ d0 ^ c22 ^ c25 ^ d6 ^ c28 ^ d5 ^ d13 ^ c17 ^ 
        d12 ^ c16 ^ c18 ^ c31 ^ d15 ^ d1 ^ c20 ^ d2 ^ c21 ^ d4 ^ 
        c29;  // 20 ins 1 outs

    assign x11 = d1 ^ c31 ^ c16 ^ c25 ^ c17 ^ c30 ^ d14 ^ d12 ^ d15 ^ 
        d0 ^ d4 ^ c19 ^ c20 ^ d3 ^ c28 ^ d9;  // 16 ins 1 outs

    assign x10 = d3 ^ c21 ^ c25 ^ d0 ^ c29 ^ d13 ^ d9 ^ d14 ^ c19 ^ 
        d2 ^ c18 ^ c30 ^ c16 ^ d5;  // 14 ins 1 outs

    assign x9 = d2 ^ c20 ^ c28 ^ d12 ^ d5 ^ d13 ^ c18 ^ d1 ^ c27 ^ 
        c29 ^ c21 ^ d4 ^ d11 ^ c25 ^ c17 ^ d9;  // 16 ins 1 outs

    assign x8 = c27 ^ d11 ^ d4 ^ d0 ^ c26 ^ c17 ^ d12 ^ c19 ^ d10 ^ 
        c28 ^ c20 ^ d3 ^ c16 ^ c24 ^ d1 ^ d8;  // 16 ins 1 outs

    assign x7 = c26 ^ c31 ^ d15 ^ d0 ^ d8 ^ d10 ^ c16 ^ c18 ^ d5 ^ 
        c21 ^ d3 ^ c19 ^ d2 ^ c23 ^ c24 ^ d7;  // 16 ins 1 outs

    assign x6 = d8 ^ c30 ^ d14 ^ c24 ^ d7 ^ c27 ^ d11 ^ c17 ^ c20 ^ 
        d2 ^ c18 ^ d1 ^ d5 ^ c22 ^ c21 ^ d4 ^ c23 ^ d6;  // 18 ins 1 outs

    assign x5 = d7 ^ c29 ^ d13 ^ c23 ^ d6 ^ c22 ^ c19 ^ d1 ^ c17 ^ 
        d0 ^ d4 ^ c21 ^ c26 ^ d10 ^ c20 ^ d3 ^ c16 ^ d5;  // 18 ins 1 outs

    assign x4 = d0 ^ d6 ^ c28 ^ d11 ^ c24 ^ c18 ^ d12 ^ c16 ^ c31 ^ 
        d15 ^ c22 ^ d3 ^ c20 ^ d8 ^ c27 ^ c19 ^ d2 ^ d4;  // 18 ins 1 outs

    assign x3 = d10 ^ c23 ^ c17 ^ d8 ^ c30 ^ d14 ^ c24 ^ d2 ^ c19 ^ 
        d7 ^ c26 ^ c18 ^ d1 ^ d9 ^ c31 ^ d15 ^ c25 ^ d3;  // 18 ins 1 outs

    assign x2 = d9 ^ d0 ^ c16 ^ d7 ^ c29 ^ d13 ^ c23 ^ d1 ^ c18 ^ 
        d6 ^ c25 ^ c17 ^ c22 ^ d8 ^ c30 ^ d14 ^ c24 ^ d2;  // 18 ins 1 outs

    assign x1 = d9 ^ d0 ^ c22 ^ c25 ^ d6 ^ c28 ^ d12 ^ c17 ^ d11 ^ 
        c27 ^ c16 ^ d7 ^ c29 ^ d13 ^ c23 ^ d1;  // 16 ins 1 outs

    assign x0 = c16 ^ d10 ^ c26 ^ d9 ^ d0 ^ c22 ^ c25 ^ d6 ^ c28 ^ 
        d12;  // 10 ins 1 outs

    assign x31 = c21 ^ d11 ^ c27 ^ d5 ^ c24 ^ c31 ^ d15 ^ d9 ^ c25 ^ 
        d8 ^ c15;  // 11 ins 1 outs

    assign x30 = c20 ^ d10 ^ c26 ^ d4 ^ c23 ^ c30 ^ d14 ^ d8 ^ c24 ^ 
        d7 ^ c14;  // 11 ins 1 outs

    assign x29 = c25 ^ d3 ^ c22 ^ d9 ^ c29 ^ d13 ^ c19 ^ d7 ^ c23 ^ 
        d6 ^ c13;  // 11 ins 1 outs

    assign x28 = c24 ^ d8 ^ c28 ^ d12 ^ c18 ^ d5 ^ c22 ^ d6 ^ c21 ^ 
        d2 ^ c12;  // 11 ins 1 outs

    assign x27 = c23 ^ d7 ^ c27 ^ d11 ^ c17 ^ d5 ^ c20 ^ d1 ^ c21 ^ 
        d4 ^ c11;  // 11 ins 1 outs

    assign x26 = c16 ^ d6 ^ c22 ^ d4 ^ c19 ^ d0 ^ c20 ^ d3 ^ c26 ^ 
        d10 ^ c10;  // 11 ins 1 outs

    assign x25 = d11 ^ c24 ^ c18 ^ c31 ^ c19 ^ d2 ^ d8 ^ c27 ^ d15 ^ 
        d3 ^ c9;  // 11 ins 1 outs

    assign x24 = d10 ^ c23 ^ c17 ^ c30 ^ c18 ^ d1 ^ d7 ^ c26 ^ d14 ^ 
        d2 ^ c8;  // 11 ins 1 outs

    assign x23 = d9 ^ d0 ^ c16 ^ c29 ^ c17 ^ d6 ^ c25 ^ c22 ^ d13 ^ 
        d1 ^ c31 ^ d15 ^ c7;  // 13 ins 1 outs

    assign x22 = c25 ^ c16 ^ c27 ^ d11 ^ d0 ^ d12 ^ c30 ^ d14 ^ c28 ^ 
        d9 ^ c6;  // 11 ins 1 outs

    assign x21 = d5 ^ c25 ^ c21 ^ d9 ^ c26 ^ d10 ^ c29 ^ d13 ^ c5;  // 9 ins 1 outs

    assign x20 = d4 ^ c24 ^ c20 ^ d9 ^ c28 ^ d12 ^ c25 ^ d8 ^ c4;  // 9 ins 1 outs

    assign x19 = c31 ^ d3 ^ c23 ^ c19 ^ c27 ^ d11 ^ c24 ^ d7 ^ d15 ^ 
        d8 ^ c3;  // 11 ins 1 outs

    assign x18 = c30 ^ d2 ^ c22 ^ d15 ^ c31 ^ c18 ^ c26 ^ d10 ^ c23 ^ 
        d6 ^ d14 ^ d7 ^ c2;  // 13 ins 1 outs

    assign x17 = c29 ^ d14 ^ c30 ^ c17 ^ d5 ^ c22 ^ d9 ^ c21 ^ d1 ^ 
        d13 ^ d6 ^ c25 ^ c1;  // 13 ins 1 outs

    assign x16 = c28 ^ d13 ^ c29 ^ c16 ^ d5 ^ d0 ^ c20 ^ d12 ^ c21 ^ 
        d4 ^ c24 ^ d8 ^ c0;  // 13 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat16_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [15:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x64, x63, x62, x61, x60, x59, x58, 
       x57, x55, x54, x53, x52, x51, x50, x49, 
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
    d15;

assign { d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [15:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x64i (.out(x64),.a(d6),.b(c22),.c(d11),.d(c27),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x63i (.out(x63),.a(d7),.b(c23),.c(c18),.d(d2),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x62i (.out(x62),.a(c26),.b(c17),.c(c27),.d(d11),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x61i (.out(x61),.a(c17),.b(c18),.c(d2),.d(d1),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x60i (.out(x60),.a(c16),.b(d5),.c(d0),.d(c21),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x59i (.out(x59),.a(d9),.b(c25),.c(c21),.d(d5),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x58i (.out(x58),.a(c22),.b(d6),.c(c17),.d(d1),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x57i (.out(x57),.a(c2),.b(c31),.c(d7),.d(c23),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x55i (.out(x55),.a(c22),.b(c7),.c(c16),.d(d6),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x54i (.out(x54),.a(d6),.b(d9),.c(d10),.d(c22),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x53i (.out(x53),.a(c16),.b(c24),.c(d0),.d(d8),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x52i (.out(x52),.a(c30),.b(c27),.c(d11),.d(d14),.e(d4),.f(1'b0));  // 5 ins 1 outs

    xor6 x51i (.out(x51),.a(c25),.b(d14),.c(c30),.d(d9),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x50i (.out(x50),.a(c18),.b(d2),.c(d3),.d(c19),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x49i (.out(x49),.a(d4),.b(c20),.c(c22),.d(d6),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x48i (.out(x48),.a(d5),.b(c12),.c(d8),.d(c24),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x47i (.out(x47),.a(d4),.b(d8),.c(c20),.d(c24),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x46i (.out(x46),.a(d1),.b(d8),.c(d10),.d(c24),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x45i (.out(x45),.a(d3),.b(c29),.c(d5),.d(c21),.e(d13),.f(1'b0));  // 5 ins 2 outs

    xor6 x44i (.out(x44),.a(c30),.b(d14),.c(d5),.d(c21),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x43i (.out(x43),.a(d1),.b(c17),.c(d15),.d(c31),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x42i (.out(x42),.a(c29),.b(d10),.c(d5),.d(c21),.e(c26),.f(1'b0));  // 5 ins 3 outs

    xor6 x41i (.out(x41),.a(c27),.b(d11),.c(d5),.d(c21),.e(1'b0),.f(1'b0));  // 4 ins 4 outs

    xor6 x40i (.out(x40),.a(c19),.b(c23),.c(d7),.d(d3),.e(1'b0),.f(1'b0));  // 4 ins 4 outs

    xor6 x39i (.out(x39),.a(d12),.b(c28),.c(d0),.d(c16),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x38i (.out(x38),.a(d10),.b(c26),.c(c30),.d(d14),.e(1'b0),.f(1'b0));  // 4 ins 5 outs

    xor6 x37i (.out(x37),.a(c19),.b(d0),.c(d3),.d(c16),.e(1'b0),.f(1'b0));  // 4 ins 7 outs

    xor6 x36i (.out(x36),.a(c24),.b(c31),.c(d15),.d(d8),.e(1'b0),.f(1'b0));  // 4 ins 8 outs

    xor6 x35i (.out(x35),.a(c20),.b(d4),.c(d12),.d(c28),.e(1'b0),.f(1'b0));  // 4 ins 8 outs

    xor6 x34i (.out(x34),.a(d7),.b(c23),.c(d1),.d(c17),.e(1'b0),.f(1'b0));  // 4 ins 8 outs

    xor6 x33i (.out(x33),.a(c22),.b(c18),.c(d2),.d(d6),.e(1'b0),.f(1'b0));  // 4 ins 8 outs

    xor6 x32i (.out(x32),.a(c29),.b(d9),.c(c25),.d(d13),.e(1'b0),.f(1'b0));  // 4 ins 9 outs

    xor6 x15i (.out(x15),.a(x59),.b(x35),.c(x36),.d(x40),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x14i (.out(x14),.a(x52),.b(c20),.c(x33),.d(x36),.e(x40),.f(1'b0));  // 5 ins 1 outs

    xor6 x13i (.out(x13),.a(c19),.b(x33),.c(x34),.d(x45),.e(x38),.f(1'b0));  // 5 ins 1 outs

    xor6 x12i (.out(x12),.a(x60),.b(x33),.c(x35),.d(x43),.e(x32),.f(1'b0));  // 5 ins 1 outs

    xor6 x11i (.out(x11),.a(x51),.b(x35),.c(x37),.d(x43),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x10i (.out(x10),.a(c18),.b(x44),.c(d2),.d(x37),.e(x32),.f(1'b0));  // 5 ins 1 outs

    xor6 x9i (.out(x9),.a(x61),.b(x41),.c(x35),.d(x32),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x8i (.out(x8),.a(x46),.b(x35),.c(x37),.d(x62),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x7i (.out(x7),.a(c29),.b(x63),.c(x37),.d(x42),.e(x36),.f(1'b0));  // 5 ins 1 outs

    xor6 x6i (.out(x6),.a(x33),.b(x34),.c(c30),.d(d14),.e(x47),.f(x41));  // 6 ins 1 outs

    xor6 x5i (.out(x5),.a(x49),.b(d13),.c(x37),.d(x34),.e(x42),.f(1'b0));  // 5 ins 1 outs

    xor6 x4i (.out(x4),.a(x33),.b(x35),.c(x36),.d(d11),.e(x37),.f(c27));  // 6 ins 1 outs

    xor6 x3i (.out(x3),.a(d9),.b(x36),.c(c25),.d(x50),.e(x38),.f(x34));  // 6 ins 1 outs

    xor6 x2i (.out(x2),.a(x33),.b(x32),.c(x34),.d(x53),.e(c30),.f(d14));  // 6 ins 1 outs

    xor6 x1i (.out(x1),.a(x64),.b(x34),.c(x39),.d(x32),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x0i (.out(x0),.a(x54),.b(c25),.c(c26),.d(x39),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x31i (.out(x31),.a(x36),.b(x41),.c(d9),.d(c25),.e(c15),.f(1'b0));  // 5 ins 1 outs

    xor6 x30i (.out(x30),.a(d7),.b(c23),.c(x47),.d(x38),.e(c14),.f(1'b0));  // 5 ins 1 outs

    xor6 x29i (.out(x29),.a(d6),.b(x32),.c(x40),.d(c22),.e(c13),.f(1'b0));  // 5 ins 1 outs

    xor6 x28i (.out(x28),.a(c21),.b(d12),.c(c28),.d(x48),.e(x33),.f(1'b0));  // 5 ins 1 outs

    xor6 x27i (.out(x27),.a(x34),.b(d4),.c(x41),.d(c20),.e(c11),.f(1'b0));  // 5 ins 1 outs

    xor6 x26i (.out(x26),.a(d10),.b(c26),.c(x49),.d(x37),.e(c10),.f(1'b0));  // 5 ins 1 outs

    xor6 x25i (.out(x25),.a(d11),.b(c27),.c(x36),.d(x50),.e(c9),.f(1'b0));  // 5 ins 1 outs

    xor6 x24i (.out(x24),.a(c18),.b(d2),.c(x34),.d(x38),.e(c8),.f(1'b0));  // 5 ins 1 outs

    xor6 x23i (.out(x23),.a(d0),.b(x55),.c(x32),.d(x43),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x22i (.out(x22),.a(d11),.b(c27),.c(x51),.d(x39),.e(c6),.f(1'b0));  // 5 ins 1 outs

    xor6 x21i (.out(x21),.a(c29),.b(x32),.c(x42),.d(c5),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x20i (.out(x20),.a(c24),.b(c25),.c(d9),.d(d8),.e(x35),.f(c4));  // 6 ins 1 outs

    xor6 x19i (.out(x19),.a(d11),.b(c27),.c(x40),.d(x36),.e(c3),.f(1'b0));  // 5 ins 1 outs

    xor6 x18i (.out(x18),.a(x57),.b(d15),.c(x33),.d(x38),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x17i (.out(x17),.a(x58),.b(x32),.c(x44),.d(c1),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x16i (.out(x16),.a(x35),.b(d3),.c(x53),.d(x45),.e(c0),.f(1'b0));  // 5 ins 1 outs

endmodule

