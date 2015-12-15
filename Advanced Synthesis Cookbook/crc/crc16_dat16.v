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

//// CRC-16 of 16 data bits.  MSB used first.
//   Polynomial 00001021 (MSB excluded)
//     x^12 + x^5 + x^0
//
// Optimal LUT depth 2
//
//        CCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDD
//        0000000000111111 0000000000111111
//        0123456789012345 0123456789012345
//
// C00  = X...X...X..XX... X...X...X..XX...
// C01  = .X...X...X..XX.. .X...X...X..XX..
// C02  = ..X...X...X..XX. ..X...X...X..XX.
// C03  = ...X...X...X..XX ...X...X...X..XX
// C04  = ....X...X...X..X ....X...X...X..X
// C05  = X...XX..XX.XXX.. X...XX..XX.XXX..
// C06  = .X...XX..XX.XXX. .X...XX..XX.XXX.
// C07  = ..X...XX..XX.XXX ..X...XX..XX.XXX
// C08  = ...X...XX..XX.XX ...X...XX..XX.XX
// C09  = ....X...XX..XX.X ....X...XX..XX.X
// C10  = .....X...XX..XX. .....X...XX..XX.
// C11  = ......X...XX..XX ......X...XX..XX
// C12  = X...X..XX......X X...X..XX......X
// C13  = .X...X..XX...... .X...X..XX......
// C14  = ..X...X..XX..... ..X...X..XX.....
// C15  = ...X...X..XX.... ...X...X..XX....
//
module crc16_dat16 (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [15:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc16_dat16_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc16_dat16_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc16_dat16_flat (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [15:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

wire x15, x14, x13, x12, x11, x10, x9, 
       x8, x7, x6, x5, x4, x3, x2, x1, 
       x0;

assign crc_out = {x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15;

assign { d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [15:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15;

assign { c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [15:0];

    assign x15 = d11 ^ c7 ^ d3 ^ c10 ^ c3 ^ d10 ^ c11 ^ d7;  // 8 ins 1 outs

    assign x14 = d10 ^ c6 ^ d2 ^ c9 ^ c2 ^ d9 ^ c10 ^ d6;  // 8 ins 1 outs

    assign x13 = d9 ^ c5 ^ d1 ^ c8 ^ c1 ^ d8 ^ c9 ^ d5;  // 8 ins 1 outs

    assign x12 = d0 ^ d8 ^ c7 ^ c0 ^ c15 ^ d15 ^ c4 ^ d7 ^ c8 ^ 
        d4;  // 10 ins 1 outs

    assign x11 = c6 ^ d10 ^ c14 ^ d14 ^ c10 ^ d6 ^ c11 ^ d15 ^ c15 ^ 
        d11;  // 10 ins 1 outs

    assign x10 = c5 ^ d9 ^ c13 ^ d13 ^ c9 ^ d5 ^ c10 ^ d14 ^ c14 ^ 
        d10;  // 10 ins 1 outs

    assign x9 = c4 ^ d15 ^ c15 ^ d8 ^ c12 ^ d12 ^ c8 ^ d4 ^ c9 ^ 
        d13 ^ c13 ^ d9;  // 12 ins 1 outs

    assign x8 = c3 ^ d14 ^ c14 ^ d7 ^ c11 ^ d15 ^ c15 ^ d11 ^ c7 ^ 
        d3 ^ c8 ^ d12 ^ c12 ^ d8;  // 14 ins 1 outs

    assign x7 = c2 ^ d13 ^ c13 ^ d6 ^ c10 ^ d14 ^ c14 ^ d10 ^ c6 ^ 
        d2 ^ c7 ^ d11 ^ c15 ^ d15 ^ c11 ^ d7;  // 16 ins 1 outs

    assign x6 = c1 ^ d12 ^ c12 ^ d5 ^ c9 ^ d13 ^ c13 ^ d9 ^ c5 ^ 
        d1 ^ c6 ^ d10 ^ c14 ^ d14 ^ c10 ^ d6;  // 16 ins 1 outs

    assign x5 = c0 ^ d11 ^ d0 ^ c4 ^ c11 ^ d4 ^ c8 ^ d12 ^ c12 ^ 
        d8 ^ c5 ^ d9 ^ c13 ^ d13 ^ c9 ^ d5;  // 16 ins 1 outs

    assign x4 = c4 ^ d15 ^ c15 ^ d8 ^ c12 ^ d12 ^ c8 ^ d4;  // 8 ins 1 outs

    assign x3 = c3 ^ d14 ^ c14 ^ d7 ^ c11 ^ d15 ^ c15 ^ d11 ^ c7 ^ 
        d3;  // 10 ins 1 outs

    assign x2 = c2 ^ d13 ^ c13 ^ d6 ^ c10 ^ d14 ^ c14 ^ d10 ^ c6 ^ 
        d2;  // 10 ins 1 outs

    assign x1 = c1 ^ d12 ^ c12 ^ d5 ^ c9 ^ d13 ^ c13 ^ d9 ^ c5 ^ 
        d1;  // 10 ins 1 outs

    assign x0 = c0 ^ d11 ^ d0 ^ c4 ^ c11 ^ d4 ^ c8 ^ d12 ^ c12 ^ 
        d8;  // 10 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc16_dat16_factor (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [15:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

wire x28, x27, x26, x24, x23, x22, x21, 
       x20, x19, x18, x17, x16, x15, x14, x13, 
       x12, x11, x10, x9, x8, x7, x6, x5, 
       x4, x3, x2, x1, x0;

assign crc_out = {x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15;

assign { d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [15:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15;

assign { c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [15:0];

    xor6 x28i (.out(x28),.a(c6),.b(c12),.c(d12),.d(d5),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x27i (.out(x27),.a(c9),.b(d11),.c(d13),.d(c13),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x26i (.out(x26),.a(d11),.b(d14),.c(c3),.d(c14),.e(d3),.f(1'b0));  // 5 ins 2 outs

    xor6 x24i (.out(x24),.a(d11),.b(d4),.c(c15),.d(d15),.e(c4),.f(1'b0));  // 5 ins 2 outs

    xor6 x23i (.out(x23),.a(d4),.b(c11),.c(d0),.d(c0),.e(c4),.f(1'b0));  // 5 ins 3 outs

    xor6 x22i (.out(x22),.a(c5),.b(d1),.c(c1),.d(d5),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x21i (.out(x21),.a(c9),.b(c6),.c(d2),.d(c2),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x20i (.out(x20),.a(d11),.b(d3),.c(c3),.d(c10),.e(d10),.f(1'b0));  // 5 ins 1 outs

    xor6 x19i (.out(x19),.a(c11),.b(d7),.c(c7),.d(c15),.e(d15),.f(1'b0));  // 5 ins 4 outs

    xor6 x18i (.out(x18),.a(d11),.b(c8),.c(d12),.d(c12),.e(d8),.f(1'b0));  // 5 ins 5 outs

    xor6 x17i (.out(x17),.a(d9),.b(c13),.c(d13),.d(c9),.e(d5),.f(1'b0));  // 5 ins 5 outs

    xor6 x16i (.out(x16),.a(d6),.b(c10),.c(d14),.d(c14),.e(d10),.f(1'b0));  // 5 ins 5 outs

    xor6 x15i (.out(x15),.a(c11),.b(x20),.c(d7),.d(c7),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x14i (.out(x14),.a(c10),.b(d10),.c(x21),.d(d6),.e(d9),.f(1'b0));  // 5 ins 1 outs

    xor6 x13i (.out(x13),.a(d9),.b(x22),.c(c8),.d(d8),.e(c9),.f(1'b0));  // 5 ins 1 outs

    xor6 x12i (.out(x12),.a(c8),.b(d8),.c(x19),.d(x23),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x11i (.out(x11),.a(d15),.b(x16),.c(c6),.d(c11),.e(c15),.f(d11));  // 6 ins 1 outs

    xor6 x10i (.out(x10),.a(d6),.b(x16),.c(c5),.d(x17),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x9i (.out(x9),.a(x17),.b(d5),.c(x18),.d(x24),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x8i (.out(x8),.a(x18),.b(x19),.c(x26),.d(d11),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x7i (.out(x7),.a(x27),.b(x21),.c(x16),.d(x19),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x6i (.out(x6),.a(x28),.b(x17),.c(x22),.d(x16),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x5i (.out(x5),.a(x17),.b(x18),.c(c5),.d(x23),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x4i (.out(x4),.a(x18),.b(x24),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x3i (.out(x3),.a(x19),.b(x26),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x2i (.out(x2),.a(x21),.b(x16),.c(c9),.d(c13),.e(d13),.f(1'b0));  // 5 ins 1 outs

    xor6 x1i (.out(x1),.a(x17),.b(d12),.c(c12),.d(x22),.e(d5),.f(1'b0));  // 5 ins 1 outs

    xor6 x0i (.out(x0),.a(x18),.b(x23),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

endmodule

