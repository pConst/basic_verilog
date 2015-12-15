// Copyright 2008 Altera Corporation. All rights reserved.  
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

//
// 24 bit CRC of 64 data bits (reversed - MSB first)
// polynomial : 00328b63 
//    x^21 + x^20 + x^17 + x^15 + x^11 + x^9 + x^8 + x^6 + x^5 + x^1 + x^0
//
//        CCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD 
//        000000000011111111112222 0000000000111111111122222222223333333333444444444455555555556666 
//        012345678901234567890123 0123456789012345678901234567890123456789012345678901234567890123 
// C00  = .......#.#....##.#.#..## ................................................................ 
// C01  = .......####...#.#####.#. ................................................................ 
// C02  = #.......####...#.#####.# ................................................................ 
// C03  = .#.......####...#.#####. ................................................................ 
// C04  = ..#.......####...#.##### ................................................................ 
// C05  = ...#...#.#.###.#.#####.. ................................................................ 
// C06  = #...#..####.##.####.##.# ................................................................ 
// C07  = .#...#..####.##.####.##. ................................................................ 
// C08  = ..#...##..###.....#.#... ................................................................ 
// C09  = #..#....##.#####.#...### ................................................................ 
// C10  = .#..#....##.#####.#...## ................................................................ 
// C11  = #.#..#.#.###.#..#.....#. ................................................................ 
// C12  = ##.#..#.#.###.#..#.....# ................................................................ 
// C13  = ###.#..#.#.###.#..#..... ................................................................ 
// C14  = ####.#..#.#.###.#..#.... ................................................................ 
// C15  = #####.##...#.#.....##.## ................................................................ 
// C16  = .#####.##...#.#.....##.# ................................................................ 
// C17  = #.#######....##..#.#.#.# ................................................................ 
// C18  = .#.#######....##..#.#.#. ................................................................ 
// C19  = ..#.#######....##..#.#.# ................................................................ 
// C20  = ...#.##.#.##..###..##..# ................................................................ 
// C21  = ....#.#....##.#.#..##### ................................................................ 
// C22  = .....#.#....##.#.#..#### ................................................................ 
// C23  = ......#.#....##.#.#..### ................................................................ 
//
// Number of XORs used is 24
// Maximum XOR input count is 15
//   Best possible depth in 4 LUTs = 2
//   Best possible depth in 5 LUTs = 2
//   Best possible depth in 6 LUTs = 2
// Total XOR inputs 278
//
// Special signal relations -
//    none
//

module crc24_zer64x3_flat (c,crc_out);
input[23:0] c;
output[23:0] crc_out;
wire[23:0] crc_out;

assign crc_out[0] =
    c[7] ^ c[9] ^ c[14] ^ c[15] ^ c[17] ^ c[19] ^ 
    c[22] ^ c[23];

assign crc_out[1] =
    c[7] ^ c[8] ^ c[9] ^ c[10] ^ c[14] ^ c[16] ^ 
    c[17] ^ c[18] ^ c[19] ^ c[20] ^ c[22];

assign crc_out[2] =
    c[0] ^ c[8] ^ c[9] ^ c[10] ^ c[11] ^ c[15] ^ 
    c[17] ^ c[18] ^ c[19] ^ c[20] ^ c[21] ^ c[23];

assign crc_out[3] =
    c[1] ^ c[9] ^ c[10] ^ c[11] ^ c[12] ^ c[16] ^ 
    c[18] ^ c[19] ^ c[20] ^ c[21] ^ c[22];

assign crc_out[4] =
    c[2] ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[17] ^ 
    c[19] ^ c[20] ^ c[21] ^ c[22] ^ c[23];

assign crc_out[5] =
    c[3] ^ c[7] ^ c[9] ^ c[11] ^ c[12] ^ c[13] ^ 
    c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[20] ^ c[21];

assign crc_out[6] =
    c[0] ^ c[4] ^ c[7] ^ c[8] ^ c[9] ^ c[10] ^ 
    c[12] ^ c[13] ^ c[15] ^ c[16] ^ c[17] ^ c[18] ^ c[20] ^ 
    c[21] ^ c[23];

assign crc_out[7] =
    c[1] ^ c[5] ^ c[8] ^ c[9] ^ c[10] ^ c[11] ^ 
    c[13] ^ c[14] ^ c[16] ^ c[17] ^ c[18] ^ c[19] ^ c[21] ^ 
    c[22];

assign crc_out[8] =
    c[2] ^ c[6] ^ c[7] ^ c[10] ^ c[11] ^ c[12] ^ 
    c[18] ^ c[20];

assign crc_out[9] =
    c[0] ^ c[3] ^ c[8] ^ c[9] ^ c[11] ^ c[12] ^ 
    c[13] ^ c[14] ^ c[15] ^ c[17] ^ c[21] ^ c[22] ^ c[23];

assign crc_out[10] =
    c[1] ^ c[4] ^ c[9] ^ c[10] ^ c[12] ^ c[13] ^ 
    c[14] ^ c[15] ^ c[16] ^ c[18] ^ c[22] ^ c[23];

assign crc_out[11] =
    c[0] ^ c[2] ^ c[5] ^ c[7] ^ c[9] ^ c[10] ^ 
    c[11] ^ c[13] ^ c[16] ^ c[22];

assign crc_out[12] =
    c[0] ^ c[1] ^ c[3] ^ c[6] ^ c[8] ^ c[10] ^ 
    c[11] ^ c[12] ^ c[14] ^ c[17] ^ c[23];

assign crc_out[13] =
    c[0] ^ c[1] ^ c[2] ^ c[4] ^ c[7] ^ c[9] ^ 
    c[11] ^ c[12] ^ c[13] ^ c[15] ^ c[18];

assign crc_out[14] =
    c[0] ^ c[1] ^ c[2] ^ c[3] ^ c[5] ^ c[8] ^ 
    c[10] ^ c[12] ^ c[13] ^ c[14] ^ c[16] ^ c[19];

assign crc_out[15] =
    c[0] ^ c[1] ^ c[2] ^ c[3] ^ c[4] ^ c[6] ^ 
    c[7] ^ c[11] ^ c[13] ^ c[19] ^ c[20] ^ c[22] ^ c[23];

assign crc_out[16] =
    c[1] ^ c[2] ^ c[3] ^ c[4] ^ c[5] ^ c[7] ^ 
    c[8] ^ c[12] ^ c[14] ^ c[20] ^ c[21] ^ c[23];

assign crc_out[17] =
    c[0] ^ c[2] ^ c[3] ^ c[4] ^ c[5] ^ c[6] ^ 
    c[7] ^ c[8] ^ c[13] ^ c[14] ^ c[17] ^ c[19] ^ c[21] ^ 
    c[23];

assign crc_out[18] =
    c[1] ^ c[3] ^ c[4] ^ c[5] ^ c[6] ^ c[7] ^ 
    c[8] ^ c[9] ^ c[14] ^ c[15] ^ c[18] ^ c[20] ^ c[22];

assign crc_out[19] =
    c[2] ^ c[4] ^ c[5] ^ c[6] ^ c[7] ^ c[8] ^ 
    c[9] ^ c[10] ^ c[15] ^ c[16] ^ c[19] ^ c[21] ^ c[23];

assign crc_out[20] =
    c[3] ^ c[5] ^ c[6] ^ c[8] ^ c[10] ^ c[11] ^ 
    c[14] ^ c[15] ^ c[16] ^ c[19] ^ c[20] ^ c[23];

assign crc_out[21] =
    c[4] ^ c[6] ^ c[11] ^ c[12] ^ c[14] ^ c[16] ^ 
    c[19] ^ c[20] ^ c[21] ^ c[22] ^ c[23];

assign crc_out[22] =
    c[5] ^ c[7] ^ c[12] ^ c[13] ^ c[15] ^ c[17] ^ 
    c[20] ^ c[21] ^ c[22] ^ c[23];

assign crc_out[23] =
    c[6] ^ c[8] ^ c[13] ^ c[14] ^ c[16] ^ c[18] ^ 
    c[21] ^ c[22] ^ c[23];

endmodule


