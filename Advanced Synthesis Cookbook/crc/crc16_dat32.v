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

//// CRC-16 of 32 data bits.  MSB used first.
//   Polynomial 00001021 (MSB excluded)
//     x^12 + x^5 + x^0
//
// Optimal LUT depth 2
//
//        CCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
//        0000000000111111 00000000001111111111222222222233
//        0123456789012345 01234567890123456789012345678901
//
// C00  = ...XX.X...XXX... X...X...X..XX......XX.X...XXX...
// C01  = ....XX.X...XXX.. .X...X...X..XX......XX.X...XXX..
// C02  = .....XX.X...XXX. ..X...X...X..XX......XX.X...XXX.
// C03  = ......XX.X...XXX ...X...X...X..XX......XX.X...XXX
// C04  = X......XX.X...XX ....X...X...X..XX......XX.X...XX
// C05  = XX.XX.X.XXX.X..X X...XX..XX.XXX..XX.XX.X.XXX.X..X
// C06  = .XX.XX.X.XXX.X.. .X...XX..XX.XXX..XX.XX.X.XXX.X..
// C07  = ..XX.XX.X.XXX.X. ..X...XX..XX.XXX..XX.XX.X.XXX.X.
// C08  = X..XX.XX.X.XXX.X ...X...XX..XX.XXX..XX.XX.X.XXX.X
// C09  = XX..XX.XX.X.XXX. ....X...XX..XX.XXX..XX.XX.X.XXX.
// C10  = XXX..XX.XX.X.XXX .....X...XX..XX.XXX..XX.XX.X.XXX
// C11  = .XXX..XX.XX.X.XX ......X...XX..XX.XXX..XX.XX.X.XX
// C12  = X.X...XXX...XX.X X...X..XX......XX.X...XXX...XX.X
// C13  = XX.X...XXX...XX. .X...X..XX......XX.X...XXX...XX.
// C14  = .XX.X...XXX...XX ..X...X..XX......XX.X...XXX...XX
// C15  = ..XX.X...XXX...X ...X...X..XX......XX.X...XXX...X
//
module crc16_dat32 (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [31:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc16_dat32_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc16_dat32_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc16_dat32_flat (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [31:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

wire x15, x14, x13, x12, x11, x10, x9, 
       x8, x7, x6, x5, x4, x3, x2, x1, 
       x0;

assign crc_out = {x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31;

assign { d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [31:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15;

assign { c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [15:0];

    assign x15 = d11 ^ d31 ^ c15 ^ d10 ^ d21 ^ c2 ^ c9 ^ d7 ^ d25 ^ 
        c5 ^ d18 ^ d3 ^ c11 ^ d26 ^ c3 ^ c10 ^ d19 ^ d27;  // 18 ins 1 outs

    assign x14 = d10 ^ d30 ^ c14 ^ d9 ^ d20 ^ c1 ^ c8 ^ d6 ^ d24 ^ 
        c15 ^ d31 ^ c4 ^ d17 ^ d2 ^ c10 ^ d25 ^ c2 ^ c9 ^ d18 ^ 
        d26;  // 20 ins 1 outs

    assign x13 = d23 ^ d29 ^ c13 ^ d19 ^ c0 ^ c7 ^ d8 ^ d1 ^ d9 ^ 
        d5 ^ c14 ^ d30 ^ c3 ^ d16 ^ c9 ^ d24 ^ c1 ^ c8 ^ d17 ^ 
        d25;  // 20 ins 1 outs

    assign x12 = d0 ^ d28 ^ c12 ^ d18 ^ d7 ^ d8 ^ c6 ^ d22 ^ c13 ^ 
        d29 ^ c2 ^ d15 ^ d4 ^ c8 ^ d23 ^ d31 ^ c15 ^ c0 ^ c7 ^ 
        d24 ^ d16;  // 21 ins 1 outs

    assign x11 = c10 ^ d26 ^ d17 ^ d25 ^ d6 ^ c2 ^ c9 ^ d10 ^ c12 ^ 
        d28 ^ c1 ^ d14 ^ d18 ^ c7 ^ c15 ^ d31 ^ d11 ^ d22 ^ c3 ^ 
        d30 ^ c14 ^ d23 ^ c6 ^ d19 ^ d15;  // 25 ins 1 outs

    assign x10 = c9 ^ d25 ^ d24 ^ d5 ^ c1 ^ c8 ^ d9 ^ c11 ^ d31 ^ 
        d16 ^ d27 ^ c0 ^ d13 ^ d17 ^ c15 ^ c6 ^ c14 ^ d30 ^ d10 ^ 
        d21 ^ c2 ^ d29 ^ c13 ^ d22 ^ c5 ^ d18 ^ d14;  // 27 ins 1 outs

    assign x9 = c0 ^ c7 ^ d4 ^ c10 ^ d30 ^ d15 ^ d26 ^ d8 ^ d23 ^ 
        d16 ^ d12 ^ c14 ^ c5 ^ c13 ^ d29 ^ d9 ^ d20 ^ c1 ^ d28 ^ 
        c12 ^ d21 ^ d24 ^ c8 ^ c4 ^ d17 ^ d13;  // 26 ins 1 outs

    assign x8 = d15 ^ c7 ^ c15 ^ c6 ^ d3 ^ c9 ^ d29 ^ d14 ^ d25 ^ 
        d7 ^ d22 ^ c13 ^ d11 ^ c12 ^ d28 ^ d19 ^ c0 ^ d27 ^ d8 ^ 
        c4 ^ c11 ^ d20 ^ d23 ^ d31 ^ c3 ^ d12 ^ d16;  // 27 ins 1 outs

    assign x7 = d14 ^ c6 ^ c14 ^ c5 ^ d2 ^ c8 ^ d28 ^ d13 ^ d24 ^ 
        d6 ^ d21 ^ c12 ^ d10 ^ c11 ^ d27 ^ d18 ^ d26 ^ d7 ^ c3 ^ 
        c10 ^ d11 ^ d22 ^ d30 ^ c2 ^ d15 ^ d19;  // 26 ins 1 outs

    assign x6 = c5 ^ c13 ^ d12 ^ d9 ^ d1 ^ c7 ^ d27 ^ d13 ^ c11 ^ 
        c4 ^ d23 ^ d5 ^ d20 ^ c10 ^ d26 ^ d17 ^ d25 ^ d6 ^ c2 ^ 
        c9 ^ d10 ^ d21 ^ d29 ^ c1 ^ d14 ^ d18;  // 26 ins 1 outs

    assign x5 = c12 ^ d28 ^ c4 ^ d4 ^ d19 ^ c6 ^ d8 ^ d12 ^ c10 ^ 
        c3 ^ d22 ^ d11 ^ d0 ^ c9 ^ d25 ^ d24 ^ d5 ^ c1 ^ c8 ^ 
        d9 ^ d20 ^ d31 ^ d16 ^ d26 ^ c0 ^ d13 ^ d17 ^ c15;  // 28 ins 1 outs

    assign x4 = c8 ^ d24 ^ c15 ^ d31 ^ c0 ^ c7 ^ d4 ^ c10 ^ d30 ^ 
        d15 ^ d26 ^ d8 ^ d23 ^ d16 ^ d12 ^ c14;  // 16 ins 1 outs

    assign x3 = d15 ^ c7 ^ c15 ^ d31 ^ d23 ^ c14 ^ d30 ^ c6 ^ d3 ^ 
        c9 ^ d29 ^ d14 ^ d25 ^ d7 ^ d22 ^ c13 ^ d11;  // 17 ins 1 outs

    assign x2 = d14 ^ c6 ^ c14 ^ d30 ^ d22 ^ c13 ^ d29 ^ c5 ^ d2 ^ 
        c8 ^ d28 ^ d13 ^ d24 ^ d6 ^ d21 ^ c12 ^ d10;  // 17 ins 1 outs

    assign x1 = c5 ^ c13 ^ d29 ^ d21 ^ c12 ^ d28 ^ d12 ^ d9 ^ d1 ^ 
        c7 ^ d27 ^ d13 ^ c11 ^ c4 ^ d23 ^ d5 ^ d20;  // 17 ins 1 outs

    assign x0 = c12 ^ d28 ^ d20 ^ c11 ^ c4 ^ d26 ^ d27 ^ d4 ^ d19 ^ 
        c6 ^ d8 ^ d12 ^ c10 ^ c3 ^ d22 ^ d11 ^ d0;  // 17 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc16_dat32_factor (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [31:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

wire x281, x280, x279, x278, x277, x276, x275, 
       x274, x273, x272, x271, x270, x269, x268, x267, 
       x266, x265, x264, x263, x262, x261, x260, x259, 
       x258, x257, x256, x255, x254, x253, x252, x251, 
       x250, x249, x15, x14, x13, x12, x11, x10, 
       x9, x8, x7, x6, x5, x4, x3, x2, 
       x1, x0;

assign crc_out = {x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,
    d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,
    d31;

assign { d31,d30,d29,d28,d27,d26,d25,d24,d23,d22,d21,d20,d19,d18,d17,
        d16,d15,d14,d13,d12,d11,d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,
        d0} = dat_in [31:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15;

assign { c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [15:0];

    xor6 x281i (.out(x281),.a(d13),.b(d0),.c(d11),.d(c3),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x280i (.out(x280),.a(d1),.b(d23),.c(c7),.d(d12),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x279i (.out(x279),.a(d26),.b(d5),.c(c10),.d(d19),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x278i (.out(x278),.a(d1),.b(d21),.c(d6),.d(d15),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x277i (.out(x277),.a(d7),.b(d2),.c(d5),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x276i (.out(x276),.a(c11),.b(d14),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x275i (.out(x275),.a(c1),.b(d28),.c(c12),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x274i (.out(x274),.a(c6),.b(d22),.c(d8),.d(d18),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x273i (.out(x273),.a(d13),.b(d9),.c(d23),.d(c7),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x272i (.out(x272),.a(c15),.b(c5),.c(d21),.d(d31),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x271i (.out(x271),.a(d14),.b(c12),.c(d9),.d(d8),.e(d28),.f(1'b0));  // 5 ins 1 outs

    xor6 x270i (.out(x270),.a(c2),.b(d7),.c(d18),.d(c3),.e(d11),.f(1'b0));  // 5 ins 1 outs

    xor6 x269i (.out(x269),.a(d16),.b(c3),.c(d19),.d(d5),.e(c0),.f(1'b0));  // 5 ins 1 outs

    xor6 x268i (.out(x268),.a(d2),.b(c5),.c(d14),.d(c2),.e(c3),.f(1'b0));  // 5 ins 1 outs

    xor6 x267i (.out(x267),.a(c4),.b(d20),.c(d27),.d(d19),.e(d12),.f(1'b0));  // 5 ins 1 outs

    xor6 x266i (.out(x266),.a(d31),.b(c15),.c(d6),.d(d21),.e(d2),.f(1'b0));  // 5 ins 1 outs

    xor6 x265i (.out(x265),.a(d13),.b(d15),.c(d6),.d(d11),.e(d19),.f(1'b0));  // 5 ins 2 outs

    xor6 x264i (.out(x264),.a(c5),.b(d9),.c(c0),.d(d16),.e(d17),.f(1'b0));  // 5 ins 1 outs

    xor6 x263i (.out(x263),.a(d19),.b(d27),.c(c3),.d(c11),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x262i (.out(x262),.a(d24),.b(d4),.c(d11),.d(d0),.e(c8),.f(1'b0));  // 5 ins 2 outs

    xor6 x261i (.out(x261),.a(d10),.b(d29),.c(c2),.d(d13),.e(c13),.f(1'b0));  // 5 ins 2 outs

    xor6 x260i (.out(x260),.a(d21),.b(d15),.c(d1),.d(d8),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x259i (.out(x259),.a(d4),.b(c10),.c(d26),.d(d8),.e(1'b0),.f(1'b0));  // 4 ins 3 outs

    xor6 x258i (.out(x258),.a(c14),.b(d30),.c(c15),.d(d14),.e(d31),.f(1'b0));  // 5 ins 2 outs

    xor6 x257i (.out(x257),.a(d7),.b(d3),.c(c9),.d(d11),.e(d25),.f(1'b0));  // 5 ins 3 outs

    xor6 x256i (.out(x256),.a(c11),.b(d5),.c(c5),.d(d27),.e(d14),.f(1'b0));  // 5 ins 4 outs

    xor6 x255i (.out(x255),.a(d12),.b(d13),.c(c4),.d(d20),.e(1'b0),.f(1'b0));  // 4 ins 5 outs

    xor6 x254i (.out(x254),.a(c15),.b(d8),.c(d16),.d(c0),.e(d31),.f(1'b0));  // 5 ins 5 outs

    xor6 x253i (.out(x253),.a(c10),.b(d10),.c(d26),.d(d18),.e(c2),.f(1'b0));  // 5 ins 5 outs

    xor6 x252i (.out(x252),.a(d29),.b(c13),.c(c7),.d(d23),.e(d15),.f(1'b0));  // 5 ins 7 outs

    xor6 x251i (.out(x251),.a(d17),.b(c1),.c(d9),.d(d25),.e(c9),.f(1'b0));  // 5 ins 6 outs

    xor6 x250i (.out(x250),.a(d24),.b(c8),.c(c14),.d(d30),.e(d21),.f(1'b0));  // 5 ins 7 outs

    xor6 x249i (.out(x249),.a(c12),.b(d28),.c(c6),.d(c3),.e(d22),.f(1'b0));  // 5 ins 7 outs

    xor6 x15i (.out(x15),.a(x272),.b(x263),.c(x257),.d(x253),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x14i (.out(x14),.a(c4),.b(x250),.c(d20),.d(x266),.e(x253),.f(x251));  // 6 ins 1 outs

    xor6 x13i (.out(x13),.a(x269),.b(x250),.c(x260),.d(x252),.e(x251),.f(1'b0));  // 5 ins 1 outs

    xor6 x12i (.out(x12),.a(x270),.b(x249),.c(x262),.d(x252),.e(x254),.f(1'b0));  // 5 ins 1 outs

    xor6 x11i (.out(x11),.a(x273),.b(x251),.c(x265),.d(x253),.e(x258),.f(x249));  // 6 ins 1 outs

    xor6 x10i (.out(x10),.a(x274),.b(x254),.c(x251),.d(x256),.e(x261),.f(x250));  // 6 ins 1 outs

    xor6 x9i (.out(x9),.a(x264),.b(x255),.c(x250),.d(x275),.e(x259),.f(x252));  // 6 ins 1 outs

    xor6 x8i (.out(x8),.a(x267),.b(x276),.c(x249),.d(x252),.e(x254),.f(x257));  // 6 ins 1 outs

    xor6 x7i (.out(x7),.a(x277),.b(x256),.c(x253),.d(x265),.e(x250),.f(x249));  // 6 ins 1 outs

    xor6 x6i (.out(x6),.a(x278),.b(x252),.c(x255),.d(x256),.e(x253),.f(x251));  // 6 ins 1 outs

    xor6 x5i (.out(x5),.a(x279),.b(x251),.c(x255),.d(x254),.e(x262),.f(x249));  // 6 ins 1 outs

    xor6 x4i (.out(x4),.a(x280),.b(x260),.c(x259),.d(x254),.e(x250),.f(1'b0));  // 5 ins 1 outs

    xor6 x3i (.out(x3),.a(x258),.b(c6),.c(d22),.d(x257),.e(x252),.f(1'b0));  // 5 ins 1 outs

    xor6 x2i (.out(x2),.a(x268),.b(d6),.c(x249),.d(x261),.e(x250),.f(1'b0));  // 5 ins 1 outs

    xor6 x1i (.out(x1),.a(x271),.b(x256),.c(x260),.d(x255),.e(x252),.f(1'b0));  // 5 ins 1 outs

    xor6 x0i (.out(x0),.a(x281),.b(x255),.c(x263),.d(x249),.e(x259),.f(1'b0));  // 5 ins 1 outs

endmodule

