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

//// CRC-32 of 24 data bits.  MSB used first.
//   Polynomial 04c11db7 (MSB excluded)
//     x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + x^0
//
// Optimal LUT depth 2
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDD
//        00000000001111111111222222222233 000000000011111111112222
//        01234567890123456789012345678901 012345678901234567890123
//
// C00  = ........X.....X..XX.X...X....... X.....X..XX.X...X.......
// C01  = ........XX....XX.X.XXX..XX...... XX....XX.X.XXX..XX......
// C02  = ........XXX...XXXX...XX.XXX..... XXX...XXXX...XX.XXX.....
// C03  = .........XXX...XXXX...XX.XXX.... .XXX...XXXX...XX.XXX....
// C04  = ........X.XXX.X.X..XX..X..XXX... X.XXX.X.X..XX..X..XXX...
// C05  = ........XX.XXXXX..X..X.....XXX.. XX.XXXXX..X..X.....XXX..
// C06  = .........XX.XXXXX..X..X.....XXX. .XX.XXXXX..X..X.....XXX.
// C07  = ........X.XX.X.XX.X....XX....XXX X.XX.X.XX.X....XX....XXX
// C08  = ........XX.XX...X.XXX....X....XX XX.XX...X.XXX....X....XX
// C09  = .........XX.XX...X.XXX....X....X .XX.XX...X.XXX....X....X
// C10  = ........X.XX.X...X...XX.X..X.... X.XX.X...X...XX.X..X....
// C11  = ........XX.XX....X..X.XXXX..X... XX.XX....X..X.XXXX..X...
// C12  = ........XXX.XXX..X..XX.X.XX..X.. XXX.XXX..X..XX.X.XX..X..
// C13  = .........XXX.XXX..X..XX.X.XX..X. .XXX.XXX..X..XX.X.XX..X.
// C14  = ..........XXX.XXX..X..XX.X.XX..X ..XXX.XXX..X..XX.X.XX..X
// C15  = ...........XXX.XXX..X..XX.X.XX.. ...XXX.XXX..X..XX.X.XX..
// C16  = ........X...XX..X...XX...X.X.XX. X...XX..X...XX...X.X.XX.
// C17  = .........X...XX..X...XX...X.X.XX .X...XX..X...XX...X.X.XX
// C18  = ..........X...XX..X...XX...X.X.X ..X...XX..X...XX...X.X.X
// C19  = ...........X...XX..X...XX...X.X. ...X...XX..X...XX...X.X.
// C20  = ............X...XX..X...XX...X.X ....X...XX..X...XX...X.X
// C21  = .............X...XX..X...XX...X. .....X...XX..X...XX...X.
// C22  = ........X........X.XX.X.X.XX...X X........X.XX.X.X.XX...X
// C23  = ........XX....X..X...X.XXX.XX... XX....X..X...X.XXX.XX...
// C24  = X........XX....X..X...X.XXX.XX.. .XX....X..X...X.XXX.XX..
// C25  = .X........XX....X..X...X.XXX.XX. ..XX....X..X...X.XXX.XX.
// C26  = ..X.....X..XX.X...X.......XXX.XX X..XX.X...X.......XXX.XX
// C27  = ...X.....X..XX.X...X.......XXX.X .X..XX.X...X.......XXX.X
// C28  = ....X.....X..XX.X...X.......XXX. ..X..XX.X...X.......XXX.
// C29  = .....X.....X..XX.X...X.......XXX ...X..XX.X...X.......XXX
// C30  = ......X.....X..XX.X...X.......XX ....X..XX.X...X.......XX
// C31  = .......X.....X..XX.X...X.......X .....X..XX.X...X.......X
//
module crc32_dat24 (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [23:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc32_dat24_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc32_dat24_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc32_dat24_flat (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [23:0] dat_in;
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
    d15,d16,d17,d18,d19,d20,d21,d22,d23;

assign { d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [23:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    assign x23 = d0 ^ c14 ^ c27 ^ d20 ^ c28 ^ d1 ^ c21 ^ d13 ^ d17 ^ 
        d9 ^ c8 ^ c9 ^ d16 ^ c17 ^ c23 ^ c25 ^ c24 ^ d15 ^ d19 ^ 
        d6;  // 20 ins 1 outs

    assign x22 = c26 ^ d19 ^ c27 ^ d0 ^ c20 ^ d12 ^ d16 ^ c17 ^ d23 ^ 
        c22 ^ c24 ^ d9 ^ c19 ^ c8 ^ d18 ^ d11 ^ d14 ^ c31;  // 18 ins 1 outs

    assign x21 = c25 ^ d18 ^ c26 ^ c13 ^ d22 ^ c18 ^ d9 ^ c17 ^ d17 ^ 
        d13 ^ d10 ^ c21 ^ c30 ^ d5;  // 14 ins 1 outs

    assign x20 = d16 ^ c24 ^ d17 ^ d8 ^ c12 ^ c25 ^ d21 ^ c17 ^ c16 ^ 
        c31 ^ d23 ^ d9 ^ c20 ^ d12 ^ c29 ^ d4;  // 16 ins 1 outs

    assign x19 = d15 ^ c24 ^ c11 ^ d16 ^ c16 ^ d7 ^ c15 ^ c30 ^ d22 ^ 
        d20 ^ d3 ^ d8 ^ c19 ^ d11 ^ c28 ^ c23;  // 16 ins 1 outs

    assign x18 = c23 ^ c10 ^ d6 ^ d23 ^ d19 ^ d15 ^ c29 ^ d21 ^ c15 ^ 
        c14 ^ d10 ^ c18 ^ d2 ^ d14 ^ c22 ^ d7 ^ c27 ^ c31;  // 18 ins 1 outs

    assign x17 = d13 ^ d1 ^ c22 ^ c9 ^ d5 ^ d22 ^ c30 ^ c26 ^ d18 ^ 
        c28 ^ d20 ^ d14 ^ d9 ^ c31 ^ c13 ^ d23 ^ c21 ^ c14 ^ c17 ^ 
        d6;  // 20 ins 1 outs

    assign x16 = d12 ^ c20 ^ c12 ^ d0 ^ c8 ^ d21 ^ c29 ^ d17 ^ c25 ^ 
        c27 ^ d19 ^ c21 ^ d8 ^ c30 ^ c13 ^ d22 ^ d13 ^ d4 ^ c16 ^ 
        d5;  // 20 ins 1 outs

    assign x15 = c11 ^ d15 ^ c23 ^ d20 ^ c28 ^ c26 ^ c29 ^ d12 ^ d8 ^ 
        c15 ^ d18 ^ c16 ^ c20 ^ d5 ^ d7 ^ c17 ^ d21 ^ c12 ^ d3 ^ 
        d9 ^ c13 ^ d4 ^ c24 ^ d16;  // 24 ins 1 outs

    assign x14 = d8 ^ c22 ^ d14 ^ c16 ^ d19 ^ c27 ^ d15 ^ c10 ^ c15 ^ 
        c28 ^ d20 ^ c31 ^ c14 ^ d23 ^ d17 ^ d11 ^ c12 ^ c19 ^ c11 ^ 
        c25 ^ d2 ^ d6 ^ d4 ^ d3 ^ d7 ^ c23;  // 26 ins 1 outs

    assign x13 = d1 ^ c15 ^ d13 ^ c21 ^ c10 ^ d18 ^ d7 ^ c14 ^ c27 ^ 
        d19 ^ c30 ^ c13 ^ c18 ^ d3 ^ d10 ^ c9 ^ c26 ^ d22 ^ c11 ^ 
        d16 ^ c24 ^ d5 ^ d2 ^ d14 ^ d6 ^ c22;  // 26 ins 1 outs

    assign x12 = d0 ^ c14 ^ d12 ^ c25 ^ d9 ^ c17 ^ c9 ^ c13 ^ c8 ^ 
        c26 ^ c29 ^ c12 ^ d2 ^ d18 ^ d21 ^ d1 ^ d15 ^ c23 ^ c10 ^ 
        d5 ^ d4 ^ d6 ^ c21 ^ c20 ^ d13 ^ d17;  // 26 ins 1 outs

    assign x11 = c22 ^ d17 ^ d9 ^ c12 ^ c11 ^ c28 ^ c25 ^ c8 ^ d1 ^ 
        d20 ^ d0 ^ d3 ^ c9 ^ d4 ^ d14 ^ c23 ^ c20 ^ d12 ^ d15 ^ 
        d16 ^ c17 ^ c24;  // 22 ins 1 outs

    assign x10 = c11 ^ c10 ^ d16 ^ c21 ^ c17 ^ c24 ^ d14 ^ d9 ^ d0 ^ 
        c27 ^ d19 ^ d5 ^ d2 ^ c8 ^ c13 ^ d13 ^ d3 ^ c22;  // 18 ins 1 outs

    assign x9 = c26 ^ c19 ^ d5 ^ d23 ^ c31 ^ d1 ^ d11 ^ c20 ^ c9 ^ 
        c13 ^ d12 ^ d18 ^ c17 ^ c12 ^ d2 ^ c10 ^ d4 ^ c21 ^ d13 ^ 
        d9;  // 20 ins 1 outs

    assign x8 = c18 ^ d0 ^ d4 ^ d22 ^ c30 ^ d10 ^ c8 ^ d23 ^ c31 ^ 
        d1 ^ d17 ^ c25 ^ c12 ^ c19 ^ c16 ^ c11 ^ d11 ^ d8 ^ d3 ^ 
        c9 ^ c20 ^ d12;  // 22 ins 1 outs

    assign x7 = d15 ^ c23 ^ d3 ^ d8 ^ d21 ^ d16 ^ d5 ^ d22 ^ c30 ^ 
        c24 ^ c11 ^ c10 ^ c18 ^ d0 ^ d10 ^ c15 ^ c13 ^ c8 ^ c29 ^ 
        d23 ^ c31 ^ d2 ^ c16 ^ d7;  // 24 ins 1 outs

    assign x6 = c22 ^ d14 ^ c16 ^ d2 ^ c12 ^ d7 ^ c19 ^ d4 ^ d8 ^ 
        d21 ^ c29 ^ c15 ^ d1 ^ c10 ^ d11 ^ d5 ^ c14 ^ c9 ^ c28 ^ 
        d20 ^ d22 ^ c30 ^ c13 ^ d6;  // 24 ins 1 outs

    assign x5 = d13 ^ c21 ^ c11 ^ c14 ^ d6 ^ d3 ^ c12 ^ c18 ^ d7 ^ 
        d20 ^ c28 ^ d0 ^ d10 ^ d4 ^ c13 ^ c8 ^ c27 ^ d19 ^ c15 ^ 
        d21 ^ c29 ^ d1 ^ c9 ^ d5;  // 24 ins 1 outs

    assign x4 = d12 ^ c20 ^ c10 ^ d18 ^ c16 ^ d2 ^ c11 ^ c14 ^ d6 ^ 
        d19 ^ c27 ^ d15 ^ c23 ^ d3 ^ c12 ^ c8 ^ c19 ^ d8 ^ d11 ^ 
        c26 ^ d0 ^ d20 ^ c28 ^ d4;  // 24 ins 1 outs

    assign x3 = d1 ^ c15 ^ d7 ^ c25 ^ c10 ^ d18 ^ c26 ^ d8 ^ c22 ^ 
        d14 ^ c16 ^ d2 ^ c11 ^ d10 ^ d17 ^ d9 ^ c9 ^ c18 ^ c17 ^ 
        d19 ^ c27 ^ d15 ^ c23 ^ d3;  // 24 ins 1 outs

    assign x2 = d0 ^ c14 ^ d6 ^ c24 ^ d1 ^ c15 ^ d7 ^ c25 ^ d9 ^ 
        d17 ^ d13 ^ c21 ^ c10 ^ d18 ^ c26 ^ c9 ^ d16 ^ d8 ^ c8 ^ 
        c17 ^ c22 ^ d14 ^ c16 ^ d2;  // 24 ins 1 outs

    assign x1 = d0 ^ c14 ^ d6 ^ c24 ^ c17 ^ d16 ^ d12 ^ c20 ^ c9 ^ 
        d11 ^ d1 ^ c15 ^ c8 ^ c19 ^ d7 ^ c25 ^ d9 ^ d17 ^ d13 ^ 
        c21;  // 20 ins 1 outs

    assign x0 = c8 ^ d10 ^ d0 ^ c14 ^ d9 ^ c18 ^ d6 ^ c24 ^ c17 ^ 
        d16 ^ d12 ^ c20;  // 12 ins 1 outs

    assign x31 = c19 ^ d8 ^ c16 ^ d15 ^ d5 ^ c17 ^ c13 ^ d11 ^ c23 ^ 
        d9 ^ c31 ^ d23 ^ c7;  // 13 ins 1 outs

    assign x30 = d4 ^ d23 ^ c31 ^ d10 ^ c18 ^ c16 ^ d7 ^ c22 ^ d14 ^ 
        d8 ^ c12 ^ c30 ^ d22 ^ c15 ^ c6;  // 15 ins 1 outs

    assign x29 = d3 ^ d22 ^ c30 ^ d9 ^ c17 ^ c14 ^ d13 ^ d7 ^ c15 ^ 
        c11 ^ c21 ^ c31 ^ c29 ^ d21 ^ d23 ^ d6 ^ c5;  // 17 ins 1 outs

    assign x28 = c16 ^ d2 ^ d8 ^ d21 ^ d12 ^ c20 ^ c13 ^ c10 ^ d6 ^ 
        c29 ^ c30 ^ c28 ^ d20 ^ d22 ^ c14 ^ d5 ^ c4;  // 17 ins 1 outs

    assign x27 = c12 ^ d7 ^ c19 ^ d21 ^ c31 ^ c15 ^ d1 ^ c13 ^ d5 ^ 
        d11 ^ c27 ^ d19 ^ c9 ^ c29 ^ c28 ^ d4 ^ d23 ^ d20 ^ c3;  // 19 ins 1 outs

    assign x26 = c11 ^ c14 ^ d6 ^ d20 ^ c30 ^ c12 ^ c18 ^ d23 ^ c31 ^ 
        d0 ^ d4 ^ d10 ^ c26 ^ d18 ^ c8 ^ c28 ^ c27 ^ d3 ^ d22 ^ 
        d19 ^ c2;  // 21 ins 1 outs

    assign x25 = c10 ^ d18 ^ c16 ^ d19 ^ c29 ^ d22 ^ c30 ^ d11 ^ d3 ^ 
        c19 ^ d8 ^ d17 ^ c23 ^ d15 ^ c11 ^ d2 ^ d21 ^ c26 ^ c25 ^ 
        c27 ^ c1;  // 21 ins 1 outs

    assign x24 = d1 ^ c15 ^ d7 ^ c25 ^ c28 ^ d21 ^ c29 ^ d14 ^ d2 ^ 
        d17 ^ c9 ^ c22 ^ c26 ^ d20 ^ c18 ^ d10 ^ c24 ^ d18 ^ c10 ^ 
        d16 ^ c0;  // 21 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc32_dat24_factor (crc_in,dat_in,crc_out);
input [31:0] crc_in;
input [23:0] dat_in;
output [31:0] crc_out;

wire [31:0] crc_out;

wire x142, x141, x140, x139, x138, x137, x136, 
       x135, x134, x133, x132, x131, x130, x129, x128, 
       x127, x126, x125, x124, x123, x122, x121, x120, 
       x119, x118, x117, x116, x115, x114, x113, x112, 
       x111, x110, x109, x108, x107, x106, x105, x104, 
       x103, x102, x101, x100, x99, x98, x97, x96, 
       x95, x94, x93, x92, x91, x90, x89, x23, 
       x22, x21, x20, x19, x18, x17, x16, x15, 
       x14, x13, x12, x11, x10, x9, x8, x7, 
       x6, x5, x4, x3, x2, x1, x0, x31, 
       x30, x29, x28, x27, x26, x25, x24;

assign crc_out = {x31,x30,x29,x28,x27,x26,x25,x24,x23,x22,x21,x20,x19,x18,x17,
        x16,x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23;

assign { d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [23:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,
    c31;

assign { c31,c30,c29,c28,c27,c26,c25,c24,c23,c22,c21,c20,c19,c18,c17,
        c16,c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [31:0];

    xor6 x142i (.out(x142),.a(c0),.b(d18),.c(d21),.d(c29),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x141i (.out(x141),.a(c1),.b(c10),.c(d21),.d(c29),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x140i (.out(x140),.a(c15),.b(d2),.c(d7),.d(d11),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x139i (.out(x139),.a(d0),.b(c14),.c(d2),.d(d11),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x138i (.out(x138),.a(c15),.b(d19),.c(c27),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x137i (.out(x137),.a(c9),.b(d6),.c(d11),.d(c19),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x136i (.out(x136),.a(c9),.b(c10),.c(d0),.d(c8),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x135i (.out(x135),.a(d13),.b(d1),.c(d2),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x134i (.out(x134),.a(d2),.b(c30),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x133i (.out(x133),.a(d2),.b(d18),.c(c26),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x132i (.out(x132),.a(c14),.b(c13),.c(d1),.d(d0),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x131i (.out(x131),.a(c9),.b(d1),.c(d14),.d(c22),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x130i (.out(x130),.a(c19),.b(c22),.c(d14),.d(c11),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x129i (.out(x129),.a(d20),.b(d0),.c(c28),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x128i (.out(x128),.a(d0),.b(d3),.c(c2),.d(d1),.e(c8),.f(1'b0));  // 5 ins 1 outs

    xor6 x127i (.out(x127),.a(c3),.b(d2),.c(c27),.d(d19),.e(c11),.f(1'b0));  // 5 ins 1 outs

    xor6 x126i (.out(x126),.a(d0),.b(d18),.c(d8),.d(c16),.e(c26),.f(1'b0));  // 5 ins 1 outs

    xor6 x125i (.out(x125),.a(d10),.b(c18),.c(c9),.d(c17),.e(d9),.f(1'b0));  // 5 ins 1 outs

    xor6 x124i (.out(x124),.a(d10),.b(c14),.c(c22),.d(c18),.e(c9),.f(1'b0));  // 5 ins 1 outs

    xor6 x123i (.out(x123),.a(c8),.b(d15),.c(c26),.d(d14),.e(c23),.f(1'b0));  // 5 ins 1 outs

    xor6 x122i (.out(x122),.a(d19),.b(d6),.c(c11),.d(c14),.e(c27),.f(1'b0));  // 5 ins 1 outs

    xor6 x121i (.out(x121),.a(d3),.b(c17),.c(d9),.d(c5),.e(d21),.f(1'b0));  // 5 ins 1 outs

    xor6 x120i (.out(x120),.a(c23),.b(c10),.c(d9),.d(d18),.e(d0),.f(1'b0));  // 5 ins 1 outs

    xor6 x119i (.out(x119),.a(d3),.b(d1),.c(c13),.d(d22),.e(d5),.f(1'b0));  // 5 ins 1 outs

    xor6 x118i (.out(x118),.a(c28),.b(c9),.c(c26),.d(d20),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x117i (.out(x117),.a(d4),.b(c10),.c(c16),.d(c6),.e(d10),.f(1'b0));  // 5 ins 1 outs

    xor6 x116i (.out(x116),.a(c19),.b(d0),.c(d12),.d(c20),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x115i (.out(x115),.a(c8),.b(c18),.c(d10),.d(c22),.e(d7),.f(1'b0));  // 5 ins 1 outs

    xor6 x114i (.out(x114),.a(c9),.b(c21),.c(c10),.d(c8),.e(c26),.f(1'b0));  // 5 ins 1 outs

    xor6 x113i (.out(x113),.a(d13),.b(c27),.c(c13),.d(d19),.e(c21),.f(1'b0));  // 5 ins 2 outs

    xor6 x112i (.out(x112),.a(c25),.b(d23),.c(c29),.d(c31),.e(d21),.f(1'b0));  // 5 ins 2 outs

    xor6 x111i (.out(x111),.a(c19),.b(d22),.c(d1),.d(d11),.e(c30),.f(1'b0));  // 5 ins 2 outs

    xor6 x110i (.out(x110),.a(d20),.b(c28),.c(d6),.d(c10),.e(c19),.f(1'b0));  // 5 ins 2 outs

    xor6 x109i (.out(x109),.a(d2),.b(c23),.c(d15),.d(c27),.e(d19),.f(1'b0));  // 5 ins 2 outs

    xor6 x108i (.out(x108),.a(c18),.b(c21),.c(c25),.d(c30),.e(d17),.f(1'b0));  // 5 ins 1 outs

    xor6 x107i (.out(x107),.a(d7),.b(c9),.c(c11),.d(c15),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x106i (.out(x106),.a(d17),.b(c25),.c(c26),.d(c17),.e(d1),.f(1'b0));  // 5 ins 1 outs

    xor6 x105i (.out(x105),.a(c15),.b(d7),.c(d20),.d(c11),.e(c28),.f(1'b0));  // 5 ins 2 outs

    xor6 x104i (.out(x104),.a(c18),.b(d16),.c(c24),.d(d10),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x103i (.out(x103),.a(c14),.b(d8),.c(c30),.d(d22),.e(c16),.f(1'b0));  // 5 ins 4 outs

    xor6 x102i (.out(x102),.a(d2),.b(c22),.c(d0),.d(d3),.e(c11),.f(1'b0));  // 5 ins 4 outs

    xor6 x101i (.out(x101),.a(d10),.b(c18),.c(d6),.d(c14),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x100i (.out(x100),.a(d18),.b(c13),.c(c17),.d(d9),.e(d5),.f(1'b0));  // 5 ins 4 outs

    xor6 x99i (.out(x99),.a(c30),.b(d22),.c(d23),.d(c31),.e(1'b0),.f(1'b0));  // 4 ins 5 outs

    xor6 x98i (.out(x98),.a(d2),.b(d1),.c(c25),.d(d17),.e(1'b0),.f(1'b0));  // 4 ins 10 outs

    xor6 x97i (.out(x97),.a(d20),.b(d4),.c(d1),.d(c28),.e(c12),.f(1'b0));  // 5 ins 5 outs

    xor6 x96i (.out(x96),.a(d11),.b(d23),.c(c19),.d(c31),.e(1'b0),.f(1'b0));  // 4 ins 6 outs

    xor6 x95i (.out(x95),.a(c13),.b(d2),.c(c29),.d(d21),.e(d5),.f(1'b0));  // 5 ins 8 outs

    xor6 x94i (.out(x94),.a(d18),.b(c11),.c(d19),.d(c27),.e(c26),.f(1'b0));  // 5 ins 6 outs

    xor6 x93i (.out(x93),.a(c20),.b(d12),.c(c8),.d(d4),.e(c12),.f(1'b0));  // 5 ins 8 outs

    xor6 x92i (.out(x92),.a(d16),.b(c17),.c(c24),.d(d9),.e(c8),.f(1'b0));  // 5 ins 9 outs

    xor6 x91i (.out(x91),.a(d7),.b(d14),.c(c22),.d(c15),.e(c10),.f(1'b0));  // 5 ins 8 outs

    xor6 x90i (.out(x90),.a(c9),.b(d6),.c(c21),.d(d13),.e(c14),.f(1'b0));  // 5 ins 8 outs

    xor6 x89i (.out(x89),.a(d3),.b(c23),.c(d8),.d(c16),.e(d15),.f(1'b0));  // 5 ins 8 outs

    xor6 x23i (.out(x23),.a(x129),.b(x98),.c(x92),.d(x109),.e(x90),.f(1'b0));  // 5 ins 1 outs

    xor6 x22i (.out(x22),.a(x130),.b(x96),.c(x116),.d(x94),.e(x92),.f(1'b0));  // 5 ins 1 outs

    xor6 x21i (.out(x21),.a(x108),.b(d10),.c(c26),.d(d22),.e(d13),.f(x100));  // 6 ins 1 outs

    xor6 x20i (.out(x20),.a(d8),.b(x92),.c(c16),.d(x93),.e(d17),.f(x112));  // 6 ins 1 outs

    xor6 x19i (.out(x19),.a(d1),.b(x111),.c(x105),.d(d16),.e(c24),.f(x89));  // 6 ins 1 outs

    xor6 x18i (.out(x18),.a(x112),.b(c25),.c(x101),.d(x109),.e(x91),.f(1'b0));  // 5 ins 1 outs

    xor6 x17i (.out(x17),.a(x131),.b(x118),.c(x90),.d(x99),.e(x100),.f(1'b0));  // 5 ins 1 outs

    xor6 x16i (.out(x16),.a(x132),.b(x98),.c(x95),.d(x103),.e(x113),.f(x93));  // 6 ins 1 outs

    xor6 x15i (.out(x15),.a(x133),.b(x95),.c(x92),.d(x93),.e(x105),.f(x89));  // 6 ins 1 outs

    xor6 x14i (.out(x14),.a(x122),.b(x96),.c(x98),.d(x97),.e(x91),.f(x89));  // 6 ins 1 outs

    xor6 x13i (.out(x13),.a(x119),.b(x134),.c(x90),.d(x91),.e(x104),.f(x94));  // 6 ins 1 outs

    xor6 x12i (.out(x12),.a(d15),.b(x106),.c(x93),.d(x95),.e(x120),.f(x90));  // 6 ins 1 outs

    xor6 x11i (.out(x11),.a(x92),.b(x93),.c(x123),.d(x118),.e(x98),.f(x102));  // 6 ins 1 outs

    xor6 x10i (.out(x10),.a(d5),.b(d14),.c(c10),.d(x113),.e(x102),.f(x92));  // 6 ins 1 outs

    xor6 x9i (.out(x9),.a(x114),.b(x93),.c(x96),.d(x135),.e(x100),.f(1'b0));  // 5 ins 1 outs

    xor6 x8i (.out(x8),.a(x124),.b(x102),.c(x96),.d(x103),.e(x98),.f(x93));  // 6 ins 1 outs

    xor6 x7i (.out(x7),.a(x136),.b(x107),.c(x104),.d(x99),.e(x95),.f(x89));  // 6 ins 1 outs

    xor6 x6i (.out(x6),.a(x137),.b(x95),.c(x97),.d(x103),.e(x91),.f(1'b0));  // 5 ins 1 outs

    xor6 x5i (.out(x5),.a(x115),.b(x102),.c(x138),.d(x90),.e(x95),.f(x97));  // 6 ins 1 outs

    xor6 x4i (.out(x4),.a(x139),.b(x94),.c(x110),.d(x93),.e(x89),.f(1'b0));  // 5 ins 1 outs

    xor6 x3i (.out(x3),.a(x125),.b(x91),.c(x98),.d(x94),.e(x89),.f(1'b0));  // 5 ins 1 outs

    xor6 x2i (.out(x2),.a(x126),.b(x90),.c(x91),.d(x98),.e(x92),.f(1'b0));  // 5 ins 1 outs

    xor6 x1i (.out(x1),.a(x140),.b(x98),.c(x116),.d(x92),.e(x90),.f(1'b0));  // 5 ins 1 outs

    xor6 x0i (.out(x0),.a(c20),.b(x101),.c(d12),.d(d0),.e(x92),.f(1'b0));  // 5 ins 1 outs

    xor6 x31i (.out(x31),.a(x100),.b(c7),.c(d3),.d(d18),.e(x96),.f(x89));  // 6 ins 1 outs

    xor6 x30i (.out(x30),.a(c12),.b(x91),.c(d8),.d(x117),.e(c18),.f(x99));  // 6 ins 1 outs

    xor6 x29i (.out(x29),.a(x121),.b(c29),.c(x107),.d(x99),.e(x90),.f(1'b0));  // 5 ins 1 outs

    xor6 x28i (.out(x28),.a(c4),.b(x116),.c(x95),.d(d0),.e(x110),.f(x103));  // 6 ins 1 outs

    xor6 x27i (.out(x27),.a(x127),.b(x95),.c(x107),.d(x96),.e(x97),.f(1'b0));  // 5 ins 1 outs

    xor6 x26i (.out(x26),.a(x128),.b(x97),.c(x99),.d(x101),.e(x94),.f(1'b0));  // 5 ins 1 outs

    xor6 x25i (.out(x25),.a(x141),.b(x89),.c(x98),.d(x94),.e(x111),.f(1'b0));  // 5 ins 1 outs

    xor6 x24i (.out(x24),.a(x142),.b(x104),.c(x98),.d(x118),.e(x91),.f(1'b0));  // 5 ins 1 outs

endmodule

