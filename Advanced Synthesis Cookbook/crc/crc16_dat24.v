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

//// CRC-16 of 24 data bits.  MSB used first.
//   Polynomial 00001021 (MSB excluded)
//     x^12 + x^5 + x^0
//
// Optimal LUT depth 2
//
//        CCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDD
//        0000000000111111 000000000011111111112222
//        0123456789012345 012345678901234567890123
//
// C00  = X..XX......XX.X. X...X...X..XX......XX.X.
// C01  = .X..XX......XX.X .X...X...X..XX......XX.X
// C02  = ..X..XX......XX. ..X...X...X..XX......XX.
// C03  = ...X..XX......XX ...X...X...X..XX......XX
// C04  = X...X..XX......X ....X...X...X..XX......X
// C05  = XX.XXX..XX.XX.X. X...XX..XX.XXX..XX.XX.X.
// C06  = .XX.XXX..XX.XX.X .X...XX..XX.XXX..XX.XX.X
// C07  = ..XX.XXX..XX.XX. ..X...XX..XX.XXX..XX.XX.
// C08  = X..XX.XXX..XX.XX ...X...XX..XX.XXX..XX.XX
// C09  = XX..XX.XXX..XX.X ....X...XX..XX.XXX..XX.X
// C10  = .XX..XX.XXX..XX. .....X...XX..XX.XXX..XX.
// C11  = ..XX..XX.XXX..XX ......X...XX..XX.XXX..XX
// C12  = X......XX.X...XX X...X..XX......XX.X...XX
// C13  = XX......XX.X...X .X...X..XX......XX.X...X
// C14  = .XX......XX.X... ..X...X..XX......XX.X...
// C15  = ..XX......XX.X.. ...X...X..XX......XX.X..
//
module crc16_dat24 (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [23:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc16_dat24_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc16_dat24_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc16_dat24_flat (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [23:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

wire x7, x6, x5, x4, x3, x2, x1, 
       x0, x15, x14, x13, x12, x11, x10, x9, 
       x8;

assign crc_out = {x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23;

assign { d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [23:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15;

assign { c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [15:0];

    assign x7 = c6 ^ c14 ^ d22 ^ d2 ^ d13 ^ c2 ^ d21 ^ c13 ^ d14 ^ 
        c5 ^ d10 ^ d6 ^ d15 ^ c11 ^ d18 ^ d7 ^ c3 ^ c10 ^ d11 ^ 
        c7 ^ d19;  // 21 ins 1 outs

    assign x6 = c5 ^ c13 ^ d21 ^ d1 ^ d12 ^ c1 ^ d20 ^ c12 ^ d13 ^ 
        c15 ^ d23 ^ c4 ^ d9 ^ d5 ^ d14 ^ c10 ^ d17 ^ d6 ^ c2 ^ 
        c9 ^ d10 ^ c6 ^ d18;  // 23 ins 1 outs

    assign x5 = c12 ^ d20 ^ d11 ^ c0 ^ d19 ^ d0 ^ c4 ^ c11 ^ d12 ^ 
        c14 ^ d22 ^ c3 ^ d4 ^ d8 ^ d13 ^ c9 ^ d16 ^ d5 ^ c1 ^ 
        c8 ^ d9 ^ c5 ^ d17;  // 23 ins 1 outs

    assign x4 = d12 ^ c8 ^ d15 ^ c4 ^ d23 ^ c15 ^ c0 ^ c7 ^ d16 ^ 
        d8 ^ d4;  // 11 ins 1 outs

    assign x3 = c7 ^ c15 ^ d23 ^ d3 ^ d14 ^ c3 ^ d22 ^ c14 ^ d15 ^ 
        c6 ^ d11 ^ d7;  // 12 ins 1 outs

    assign x2 = c6 ^ c14 ^ d22 ^ d2 ^ d13 ^ c2 ^ d21 ^ c13 ^ d14 ^ 
        c5 ^ d10 ^ d6;  // 12 ins 1 outs

    assign x1 = c5 ^ c13 ^ d21 ^ d1 ^ d12 ^ c1 ^ d20 ^ c12 ^ d13 ^ 
        c15 ^ d23 ^ c4 ^ d9 ^ d5;  // 14 ins 1 outs

    assign x0 = c12 ^ d20 ^ d11 ^ c0 ^ d19 ^ d0 ^ c4 ^ c11 ^ d12 ^ 
        c14 ^ d22 ^ c3 ^ d4 ^ d8;  // 14 ins 1 outs

    assign x15 = d11 ^ d7 ^ c2 ^ d21 ^ c13 ^ d3 ^ c10 ^ c3 ^ d18 ^ 
        d10 ^ d19 ^ c11;  // 12 ins 1 outs

    assign x14 = d10 ^ d6 ^ c1 ^ d20 ^ c12 ^ d2 ^ c9 ^ c2 ^ d17 ^ 
        d9 ^ d18 ^ c10;  // 12 ins 1 outs

    assign x13 = c15 ^ d9 ^ d5 ^ c0 ^ d19 ^ d8 ^ d23 ^ c11 ^ d1 ^ 
        c8 ^ c1 ^ d16 ^ d17 ^ c9;  // 14 ins 1 outs

    assign x12 = c14 ^ d4 ^ d8 ^ d15 ^ d0 ^ d18 ^ d7 ^ d22 ^ c10 ^ 
        c7 ^ c0 ^ d23 ^ c15 ^ d16 ^ c8;  // 15 ins 1 outs

    assign x11 = d14 ^ c10 ^ d17 ^ d6 ^ c2 ^ c9 ^ d10 ^ c6 ^ d18 ^ 
        c3 ^ d22 ^ c14 ^ d15 ^ c11 ^ d23 ^ c15 ^ d19 ^ c7 ^ d11;  // 19 ins 1 outs

    assign x10 = d13 ^ c9 ^ d16 ^ d5 ^ c1 ^ c8 ^ d9 ^ c5 ^ d17 ^ 
        c2 ^ d21 ^ c13 ^ d14 ^ c10 ^ d22 ^ c14 ^ d18 ^ c6 ^ d10;  // 19 ins 1 outs

    assign x9 = d12 ^ c8 ^ d15 ^ c4 ^ d23 ^ c15 ^ c0 ^ c7 ^ d16 ^ 
        d8 ^ d4 ^ c1 ^ d20 ^ c12 ^ d13 ^ c9 ^ d21 ^ c13 ^ d17 ^ 
        c5 ^ d9;  // 21 ins 1 outs

    assign x8 = c7 ^ c15 ^ d23 ^ d3 ^ d14 ^ c3 ^ d22 ^ c14 ^ d15 ^ 
        c6 ^ d11 ^ d7 ^ c0 ^ d19 ^ d8 ^ c4 ^ c11 ^ d12 ^ c8 ^ 
        d20 ^ c12 ^ d16;  // 22 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc16_dat24_factor (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [23:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

wire x59, x58, x57, x56, x55, x54, x53, 
       x52, x51, x50, x49, x48, x47, x46, x45, 
       x44, x43, x42, x41, x40, x39, x38, x7, 
       x6, x5, x4, x3, x2, x1, x0, x15, 
       x14, x13, x12, x11, x10, x9, x8;

assign crc_out = {x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23;

assign { d23,d22,d21,d20,d19,d18,d17,d16,d15,d14,d13,d12,d11,d10,d9,
        d8,d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [23:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15;

assign { c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [15:0];

    xor6 x59i (.out(x59),.a(d19),.b(c15),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x58i (.out(x58),.a(d23),.b(d13),.c(c13),.d(d21),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x57i (.out(x57),.a(d23),.b(c11),.c(c15),.d(d19),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x56i (.out(x56),.a(c15),.b(d5),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x55i (.out(x55),.a(d9),.b(c1),.c(c13),.d(d13),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x54i (.out(x54),.a(c8),.b(c14),.c(d16),.d(d22),.e(d6),.f(1'b0));  // 5 ins 1 outs

    xor6 x53i (.out(x53),.a(d23),.b(d6),.c(c13),.d(c11),.e(d17),.f(1'b0));  // 5 ins 1 outs

    xor6 x52i (.out(x52),.a(d18),.b(c10),.c(d0),.d(d7),.e(c14),.f(1'b0));  // 5 ins 1 outs

    xor6 x51i (.out(x51),.a(d2),.b(c12),.c(d20),.d(c5),.e(d6),.f(1'b0));  // 5 ins 1 outs

    xor6 x50i (.out(x50),.a(d7),.b(d2),.c(c7),.d(d15),.e(c11),.f(1'b0));  // 5 ins 1 outs

    xor6 x49i (.out(x49),.a(c11),.b(d3),.c(d19),.d(d7),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x48i (.out(x48),.a(d22),.b(d2),.c(d10),.d(c5),.e(c13),.f(1'b0));  // 5 ins 1 outs

    xor6 x47i (.out(x47),.a(d0),.b(c11),.c(d23),.d(d4),.e(d13),.f(1'b0));  // 5 ins 2 outs

    xor6 x46i (.out(x46),.a(d5),.b(c15),.c(d1),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 3 outs

    xor6 x45i (.out(x45),.a(d23),.b(d15),.c(c7),.d(d4),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x44i (.out(x44),.a(d14),.b(d15),.c(c7),.d(c15),.e(c6),.f(1'b0));  // 5 ins 3 outs

    xor6 x43i (.out(x43),.a(c6),.b(d13),.c(d14),.d(d6),.e(d21),.f(1'b0));  // 5 ins 4 outs

    xor6 x42i (.out(x42),.a(c1),.b(d9),.c(c5),.d(d17),.e(c9),.f(1'b0));  // 5 ins 6 outs

    xor6 x41i (.out(x41),.a(d23),.b(c4),.c(d12),.d(d20),.e(c12),.f(1'b0));  // 5 ins 6 outs

    xor6 x40i (.out(x40),.a(c8),.b(c15),.c(c0),.d(d16),.e(d8),.f(1'b0));  // 5 ins 6 outs

    xor6 x39i (.out(x39),.a(c3),.b(d11),.c(d19),.d(c14),.e(d22),.f(1'b0));  // 5 ins 6 outs

    xor6 x38i (.out(x38),.a(c2),.b(c10),.c(c13),.d(d18),.e(d10),.f(1'b0));  // 5 ins 6 outs

    xor6 x7i (.out(x7),.a(x50),.b(c5),.c(x39),.d(x43),.e(x38),.f(1'b0));  // 5 ins 1 outs

    xor6 x6i (.out(x6),.a(x46),.b(x42),.c(x41),.d(x43),.e(x38),.f(1'b0));  // 5 ins 1 outs

    xor6 x5i (.out(x5),.a(x56),.b(x40),.c(x39),.d(x41),.e(x42),.f(x47));  // 6 ins 1 outs

    xor6 x4i (.out(x4),.a(c4),.b(d12),.c(x45),.d(x40),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x3i (.out(x3),.a(x39),.b(x49),.c(d23),.d(c11),.e(x44),.f(1'b0));  // 5 ins 1 outs

    xor6 x2i (.out(x2),.a(c14),.b(c2),.c(x48),.d(x43),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x1i (.out(x1),.a(d21),.b(x55),.c(c5),.d(x46),.e(x41),.f(1'b0));  // 5 ins 1 outs

    xor6 x0i (.out(x0),.a(x39),.b(c0),.c(d8),.d(x41),.e(d13),.f(x47));  // 6 ins 1 outs

    xor6 x15i (.out(x15),.a(c3),.b(d21),.c(x49),.d(d11),.e(x38),.f(1'b0));  // 5 ins 1 outs

    xor6 x14i (.out(x14),.a(c13),.b(x51),.c(x42),.d(x38),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x13i (.out(x13),.a(c5),.b(x57),.c(x46),.d(x42),.e(x40),.f(1'b0));  // 5 ins 1 outs

    xor6 x12i (.out(x12),.a(x52),.b(d22),.c(x45),.d(x40),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x11i (.out(x11),.a(x53),.b(c9),.c(x38),.d(x39),.e(x44),.f(1'b0));  // 5 ins 1 outs

    xor6 x10i (.out(x10),.a(x54),.b(d5),.c(x43),.d(x38),.e(x42),.f(1'b0));  // 5 ins 1 outs

    xor6 x9i (.out(x9),.a(x58),.b(x41),.c(x45),.d(x40),.e(x42),.f(1'b0));  // 5 ins 1 outs

    xor6 x8i (.out(x8),.a(x59),.b(x39),.c(x40),.d(x49),.e(x44),.f(x41));  // 6 ins 1 outs

endmodule

