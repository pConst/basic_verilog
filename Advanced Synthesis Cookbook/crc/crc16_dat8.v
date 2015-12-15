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

//// CRC-16 of 8 data bits.  MSB used first.
//   Polynomial 00001021 (MSB excluded)
//     x^12 + x^5 + x^0
//
// Optimal LUT depth 2
//
//        CCCCCCCCCCCCCCCC DDDDDDDD
//        0000000000111111 00000000
//        0123456789012345 01234567
//
// C00  = ........X...X... X...X...
// C01  = .........X...X.. .X...X..
// C02  = ..........X...X. ..X...X.
// C03  = ...........X...X ...X...X
// C04  = ............X... ....X...
// C05  = ........X...XX.. X...XX..
// C06  = .........X...XX. .X...XX.
// C07  = ..........X...XX ..X...XX
// C08  = X..........X...X ...X...X
// C09  = .X..........X... ....X...
// C10  = ..X..........X.. .....X..
// C11  = ...X..........X. ......X.
// C12  = ....X...X...X..X X...X..X
// C13  = .....X...X...X.. .X...X..
// C14  = ......X...X...X. ..X...X.
// C15  = .......X...X...X ...X...X
//
module crc16_dat8 (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [7:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

parameter METHOD = 1;

generate
  if (METHOD == 0)
    crc16_dat8_flat cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
  else
    crc16_dat8_factor cc (.crc_in(crc_in),.dat_in(dat_in),.crc_out(crc_out));
endgenerate

endmodule

////////////////////////////////////////////////////////////////
// Flat version
////////////////////////////////////////////////////////////////

module crc16_dat8_flat (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [7:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

wire x7, x6, x5, x4, x3, x2, x1, 
       x0, x15, x14, x13, x12, x11, x10, x9, 
       x8;

assign crc_out = {x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7;

assign { d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [7:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15;

assign { c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [15:0];

    xor6 x7i (.out(x7),.a(c10),.b(d6),.c(c14),.d(d2),.e(c15),.f(d7));  // 6 ins 1 outs

    xor6 x6i (.out(x6),.a(c9),.b(d5),.c(c13),.d(d1),.e(c14),.f(d6));  // 6 ins 1 outs

    xor6 x5i (.out(x5),.a(c8),.b(d4),.c(c12),.d(d0),.e(c13),.f(d5));  // 6 ins 1 outs

    xor6 x4i (.out(x4),.a(c12),.b(d4),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x3i (.out(x3),.a(c11),.b(d7),.c(c15),.d(d3),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x2i (.out(x2),.a(c10),.b(d6),.c(c14),.d(d2),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x1i (.out(x1),.a(c9),.b(d5),.c(c13),.d(d1),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x0i (.out(x0),.a(c8),.b(d4),.c(c12),.d(d0),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x15i (.out(x15),.a(c11),.b(d7),.c(c15),.d(d3),.e(c7),.f(1'b0));  // 5 ins 1 outs

    xor6 x14i (.out(x14),.a(c10),.b(d6),.c(c14),.d(d2),.e(c6),.f(1'b0));  // 5 ins 1 outs

    xor6 x13i (.out(x13),.a(c9),.b(d5),.c(c13),.d(d1),.e(c5),.f(1'b0));  // 5 ins 1 outs

    assign x12 = c8 ^ d4 ^ c12 ^ d0 ^ c15 ^ d7 ^ c4;  // 7 ins 1 outs

    xor6 x11i (.out(x11),.a(c14),.b(d6),.c(c3),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x10i (.out(x10),.a(c13),.b(d5),.c(c2),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x9i (.out(x9),.a(c12),.b(d4),.c(c1),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x8i (.out(x8),.a(c11),.b(d7),.c(c15),.d(d3),.e(c0),.f(1'b0));  // 5 ins 1 outs

endmodule

////////////////////////////////////////////////////////////////
// Depth optimal factored version
////////////////////////////////////////////////////////////////

module crc16_dat8_factor (crc_in,dat_in,crc_out);
input [15:0] crc_in;
input [7:0] dat_in;
output [15:0] crc_out;

wire [15:0] crc_out;

wire x19, x18, x17, x16, x7, x6, x5, 
       x4, x3, x2, x1, x0, x15, x14, x13, 
       x12, x11, x10, x9, x8;

assign crc_out = {x15,x14,x13,x12,x11,x10,x9,x8,x7,x6,x5,x4,x3,x2,x1,
        x0};

wire d0,d1,d2,d3,d4,d5,d6,d7;

assign { d7,d6,d5,d4,d3,d2,d1,d0} = dat_in [7:0];

wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,
    c15;

assign { c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,
        c0} = crc_in [15:0];

    xor6 x19i (.out(x19),.a(c7),.b(c11),.c(c15),.d(d7),.e(d3),.f(1'b0));  // 5 ins 2 outs

    xor6 x18i (.out(x18),.a(c5),.b(d1),.c(c9),.d(c13),.e(d5),.f(1'b0));  // 5 ins 2 outs

    xor6 x17i (.out(x17),.a(c6),.b(c10),.c(d6),.d(c14),.e(d2),.f(1'b0));  // 5 ins 2 outs

    xor6 x16i (.out(x16),.a(c8),.b(d4),.c(c12),.d(d0),.e(1'b0),.f(1'b0));  // 4 ins 2 outs

    xor6 x7i (.out(x7),.a(x17),.b(c6),.c(c15),.d(d7),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x6i (.out(x6),.a(d6),.b(c14),.c(x18),.d(c5),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x5i (.out(x5),.a(x16),.b(c13),.c(d5),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x4i (.out(x4),.a(c12),.b(d4),.c(1'b0),.d(1'b0),.e(1'b0),.f(1'b0));  // 2 ins 1 outs

    xor6 x3i (.out(x3),.a(c11),.b(d7),.c(c15),.d(d3),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x2i (.out(x2),.a(c10),.b(d6),.c(c14),.d(d2),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x1i (.out(x1),.a(c9),.b(d5),.c(c13),.d(d1),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x0i (.out(x0),.a(c8),.b(d4),.c(c12),.d(d0),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    assign x15 = x19;  // 1 ins 1 outs

    assign x14 = x17;  // 1 ins 1 outs

    assign x13 = x18;  // 1 ins 1 outs

    xor6 x12i (.out(x12),.a(x16),.b(c15),.c(d7),.d(c4),.e(1'b0),.f(1'b0));  // 4 ins 1 outs

    xor6 x11i (.out(x11),.a(c14),.b(d6),.c(c3),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x10i (.out(x10),.a(c13),.b(d5),.c(c2),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x9i (.out(x9),.a(c12),.b(d4),.c(c1),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

    xor6 x8i (.out(x8),.a(x19),.b(c7),.c(c0),.d(1'b0),.e(1'b0),.f(1'b0));  // 3 ins 1 outs

endmodule

