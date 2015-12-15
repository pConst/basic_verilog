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

//// CRC-32 of 8 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 2
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDD
//        00000000001111111111222222222233 00000000
//        01234567890123456789012345678901 01234567
//
// C00  = ........................X.....X. X.....X.
// C01  = ........................XX....XX XX....XX
// C02  = ........................XXX...XX XXX...XX
// C03  = .........................XXX...X .XXX...X
// C04  = ........................X.XXX.X. X.XXX.X.
// C05  = ........................XX.XXXXX XX.XXXXX
// C06  = .........................XX.XXXX .XX.XXXX
// C07  = ........................X.XX.X.X X.XX.X.X
// C08  = X.......................XX.XX... XX.XX...
// C09  = .X.......................XX.XX.. .XX.XX..
// C10  = ..X.....................X.XX.X.. X.XX.X..
// C11  = ...X....................XX.XX... XX.XX...
// C12  = ....X...................XXX.XXX. XXX.XXX.
// C13  = .....X...................XXX.XXX .XXX.XXX
// C14  = ......X...................XXX.XX ..XXX.XX
// C15  = .......X...................XXX.X ...XXX.X
// C16  = ........X...............X...XX.. X...XX..
// C17  = .........X...............X...XX. .X...XX.
// C18  = ..........X...............X...XX ..X...XX
// C19  = ...........X...............X...X ...X...X
// C20  = ............X...............X... ....X...
// C21  = .............X...............X.. .....X..
// C22  = ..............X.........X....... X.......
// C23  = ...............X........XX....X. XX....X.
// C24  = ................X........XX....X .XX....X
// C25  = .................X........XX.... ..XX....
// C26  = ..................X.....X..XX.X. X..XX.X.
// C27  = ...................X.....X..XX.X .X..XX.X
// C28  = ....................X.....X..XX. ..X..XX.
// C29  = .....................X.....X..XX ...X..XX
// C30  = ......................X.....X..X ....X..X
// C31  = .......................X.....X.. .....X..
//
module crc32_dat8 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [7:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat8_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat8_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat8_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [7:0] dat_in;
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

wire d0,d1,d2,d3,d4,d5,d6,d7;

assign { d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [7:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x7 = d0 ^ c26 ^ d2 ^ c27 ^ d3 ^ c29 ^ d5 ^ c24 ^ c31 ^ 
        d7;  // 10 ins 1 outs

    assign x6 = c25 ^ d7 ^ c31 ^ d1 ^ c26 ^ d2 ^ c28 ^ d4 ^ c29 ^ 
        d5 ^ c30 ^ d6;  // 12 ins 1 outs

    assign x5 = c24 ^ d6 ^ c30 ^ d0 ^ c25 ^ d7 ^ c31 ^ d1 ^ c27 ^ 
        d3 ^ c28 ^ d4 ^ c29 ^ d5;  // 14 ins 1 outs

    assign x4 = c24 ^ d6 ^ c30 ^ d0 ^ c26 ^ d2 ^ c27 ^ d3 ^ c28 ^ 
        d4;  // 10 ins 1 outs

    assign x3 = c25 ^ d7 ^ c31 ^ d1 ^ c26 ^ d2 ^ c27 ^ d3;  // 8 ins 1 outs

    assign x2 = c24 ^ d6 ^ c30 ^ d0 ^ c25 ^ d7 ^ c31 ^ d1 ^ c26 ^ 
        d2;  // 10 ins 1 outs

    assign x1 = c24 ^ d6 ^ c30 ^ d0 ^ c25 ^ d7 ^ c31 ^ d1;  // 8 ins 1 outs

    xor6 x0i (.out(x0),.a(c24),.b(d6),.c(c30),.d(d0),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x31i (.out(x31),.a(c29),.b(d5),.c(c23),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x30i (.out(x30),.a(c28),.b(d4),.c(c31),.d(d7),.e(c22),.f(1'b0));  // 5 ins 1 outs

    assign x29 = c27 ^ d3 ^ c30 ^ d6 ^ c31 ^ d7 ^ c21;  // 7 ins 1 outs

    assign x28 = c26 ^ d2 ^ c29 ^ d5 ^ c30 ^ d6 ^ c20;  // 7 ins 1 outs

    assign x27 = c25 ^ d7 ^ c31 ^ d1 ^ c28 ^ d4 ^ c29 ^ d5 ^ c19;  // 9 ins 1 outs

    assign x26 = c24 ^ d6 ^ c30 ^ d0 ^ c27 ^ d3 ^ c28 ^ d4 ^ c18;  // 9 ins 1 outs

    xor6 x25i (.out(x25),.a(c26),.b(d2),.c(c27),.d(d3),.e(c17),.f(1'b0));  // 5 ins 1 outs

    assign x24 = c25 ^ d7 ^ c31 ^ d1 ^ c26 ^ d2 ^ c16;  // 7 ins 1 outs

    assign x23 = c24 ^ d6 ^ c30 ^ d1 ^ c25 ^ d0 ^ c15;  // 7 ins 1 outs

    xor6 x22i (.out(x22),.a(d0),.b(c24),.c(c14),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x21i (.out(x21),.a(c29),.b(d5),.c(c13),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x20i (.out(x20),.a(c28),.b(d4),.c(c12),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x19i (.out(x19),.a(c27),.b(d3),.c(c31),.d(d7),.e(c11),.f(1'b0));  // 5 ins 1 outs

    assign x18 = c26 ^ d2 ^ c30 ^ d6 ^ c31 ^ d7 ^ c10;  // 7 ins 1 outs

    assign x17 = d1 ^ c29 ^ d5 ^ c30 ^ d6 ^ c25 ^ c9;  // 7 ins 1 outs

    assign x16 = d0 ^ c28 ^ d4 ^ c29 ^ d5 ^ c24 ^ c8;  // 7 ins 1 outs

    assign x15 = c27 ^ d3 ^ c28 ^ d4 ^ c29 ^ d5 ^ c31 ^ d7 ^ c7;  // 9 ins 1 outs

    assign x14 = c26 ^ d2 ^ c27 ^ d3 ^ c28 ^ d4 ^ c30 ^ d6 ^ c31 ^ 
        d7 ^ c6;  // 11 ins 1 outs

    assign x13 = c25 ^ d7 ^ c31 ^ d1 ^ c26 ^ d2 ^ c27 ^ d3 ^ c29 ^ 
        d5 ^ c30 ^ d6 ^ c5;  // 13 ins 1 outs

    assign x12 = c24 ^ d6 ^ c30 ^ d1 ^ c26 ^ d2 ^ c28 ^ d4 ^ c29 ^ 
        d5 ^ c25 ^ d0 ^ c4;  // 13 ins 1 outs

    assign x11 = d1 ^ c27 ^ d3 ^ c28 ^ d4 ^ c24 ^ c25 ^ d0 ^ c3;  // 9 ins 1 outs

    assign x10 = d0 ^ c26 ^ d2 ^ c27 ^ d3 ^ c29 ^ d5 ^ c24 ^ c2;  // 9 ins 1 outs

    assign x9 = d1 ^ c26 ^ d2 ^ c28 ^ d4 ^ c29 ^ d5 ^ c25 ^ c1;  // 9 ins 1 outs

    assign x8 = d1 ^ c27 ^ d3 ^ c28 ^ d4 ^ c24 ^ c25 ^ d0 ^ c0;  // 9 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat8_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [7:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x44, x43, x42, x39, x38, x37, x36, 
       x35, x34, x33, x32, x7, x6, x5, x4, 
       x3, x2, x1, x0, x31, x30, x29, x28, 
       x27, x26, x25, x24, x23, x22, x21, x20, 
       x19, x18, x17, x16, x15, x14, x13, x12, 
       x11, x10, x9, x8;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7;

assign { d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [7:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x44i (.out(x44),.a(c28),.b(c25),.c(d4),.d(d1),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x43i (.out(x43),.a(c27),.b(c29),.c(d5),.d(d3),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x42i (.out(x42),.a(c17),.b(d2),.c(c27),.d(d3),.e(c26),.f(1'b0));  // 5 ins 2 outs

    xor6 x39i (.out(x39),.a(d5),.b(c29),.c(d2),.d(c26),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x38i (.out(x38),.a(d5),.b(d6),.c(d1),.d(c25),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x37i (.out(x37),.a(c24),.b(d0),.c(c25),.d(d1),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x36i (.out(x36),.a(d7),.b(c31),.c(c27),.d(d3),.e(1'b0),.f(1'b0));  // 4 ins 4 outs

    xor6 x35i (.out(x35),.a(d2),.b(c28),.c(d4),.d(c29),.e(d5),.f(1'b0));  // 5 ins 7 outs

    xor6 x34i (.out(x34),.a(c30),.b(d0),.c(c27),.d(d3),.e(c24),.f(1'b0));  // 5 ins 7 outs

    xor6 x33i (.out(x33),.a(d6),.b(c30),.c(c26),.d(d2),.e(1'b0),.f(1'b0));  // 4 ins 8 outs

    xor6 x32i (.out(x32),.a(c25),.b(d7),.c(c31),.d(d1),.e(1'b0),.f(1'b0));  // 4 ins 8 outs

    xor6 x7i (.out(x7),.a(c30),.b(x34),.c(x39),.d(d7),.e(c31),.f(1'b0));  // 5 ins 1 outs

    xor6 x6i (.out(x6),.a(x32),.b(x33),.c(x35),.d(d2),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x5i (.out(x5),.a(x32),.b(x35),.c(x34),.d(d2),.e(d6),.f(1'b0));  // 5 ins 1 outs

    xor6 x4i (.out(x4),.a(x33),.b(x34),.c(c30),.d(c28),.e(d4),.f(1'b0));  // 5 ins 1 outs

    xor6 x3i (.out(x3),.a(c17),.b(x32),.c(x42),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x2i (.out(x2),.a(x32),.b(c24),.c(d0),.d(x33),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x1i (.out(x1),.a(c30),.b(x32),.c(d6),.d(d0),.e(c24),.f(1'b0));  // 5 ins 1 outs

    xor6 x0i (.out(x0),.a(c24),.b(d6),.c(c30),.d(d0),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x31i (.out(x31),.a(c29),.b(d5),.c(c23),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x30i (.out(x30),.a(c22),.b(c28),.c(c31),.d(d7),.e(d4),.f(1'b0));  // 5 ins 1 outs

    xor6 x29i (.out(x29),.a(x36),.b(d6),.c(c30),.d(c21),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x28i (.out(x28),.a(x33),.b(c29),.c(d5),.d(c20),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x27i (.out(x27),.a(x35),.b(x32),.c(d2),.d(c19),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x26i (.out(x26),.a(d6),.b(x34),.c(c28),.d(d4),.e(c18),.f(1'b0));  // 5 ins 1 outs

    assign x25 = x42;  // 1 ins 1 outs

    xor6 x24i (.out(x24),.a(x32),.b(c26),.c(d2),.d(c16),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x23i (.out(x23),.a(x37),.b(d6),.c(c30),.d(c15),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x22i (.out(x22),.a(d0),.b(c24),.c(c14),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x21i (.out(x21),.a(c29),.b(d5),.c(c13),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x20i (.out(x20),.a(c28),.b(d4),.c(c12),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x19i (.out(x19),.a(x36),.b(c11),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x18i (.out(x18),.a(d7),.b(c31),.c(x33),.d(c10),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x17i (.out(x17),.a(c29),.b(x38),.c(c30),.d(c9),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x16i (.out(x16),.a(d0),.b(c24),.c(x35),.d(d2),.e(c8),.f(1'b0));  // 5 ins 1 outs

    xor6 x15i (.out(x15),.a(d2),.b(x35),.c(x36),.d(c7),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x14i (.out(x14),.a(c28),.b(d4),.c(x36),.d(x33),.e(c6),.f(1'b0));  // 5 ins 1 outs

    xor6 x13i (.out(x13),.a(x43),.b(x32),.c(x33),.d(c5),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x12i (.out(x12),.a(d2),.b(x35),.c(x33),.d(x37),.e(c4),.f(1'b0));  // 5 ins 1 outs

    xor6 x11i (.out(x11),.a(x34),.b(x44),.c(c30),.d(c3),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x10i (.out(x10),.a(c30),.b(x34),.c(x39),.d(c2),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x9i (.out(x9),.a(x35),.b(c26),.c(c1),.d(d1),.e(c25),.f(1'b0));  // 5 ins 1 outs

    xor6 x8i (.out(x8),.a(x34),.b(x44),.c(c30),.d(c0),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

endmodule

