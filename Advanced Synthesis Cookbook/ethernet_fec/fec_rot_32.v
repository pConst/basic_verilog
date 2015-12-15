// Copyright 2009 Altera Corporation. All rights reserved.  
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
// 32 bit CRC of 32 data bits (forward - LSB first)
// polynomial : 00a00805 
//    x^23 + x^21 + x^11 + x^2 + x^0
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD 
//        00000000001111111111222222222233 00000000001111111111222222222233 
//        01234567890123456789012345678901 01234567890123456789012345678901 
// C00  = #........#.#......#..##....#.### ................................ 
// C01  = .#........#.#......#..##....#.## ................................ 
// C02  = #.#......#...#....#.#####..#..#. ................................ 
// C03  = .#.#......#...#....#.#####..#..# ................................ 
// C04  = ..#.#......#...#....#.#####..#.. ................................ 
// C05  = ...#.#......#...#....#.#####..#. ................................ 
// C06  = ....#.#......#...#....#.#####..# ................................ 
// C07  = .....#.#......#...#....#.#####.. ................................ 
// C08  = ......#.#......#...#....#.#####. ................................ 
// C09  = .......#.#......#...#....#.##### ................................ 
// C10  = ........#.#......#...#....#.#### ................................ 
// C11  = #....................#.......... ................................ 
// C12  = .#....................#......... ................................ 
// C13  = ..#....................#........ ................................ 
// C14  = ...#....................#....... ................................ 
// C15  = ....#....................#...... ................................ 
// C16  = .....#....................#..... ................................ 
// C17  = ......#....................#.... ................................ 
// C18  = .......#....................#... ................................ 
// C19  = ........#....................#.. ................................ 
// C20  = .........#....................#. ................................ 
// C21  = #........###......#..##....#.##. ................................ 
// C22  = .#........###......#..##....#.## ................................ 
// C23  = #.#......#..##....#.#####..#..#. ................................ 
// C24  = .#.#......#..##....#.#####..#..# ................................ 
// C25  = ..#.#......#..##....#.#####..#.. ................................ 
// C26  = ...#.#......#..##....#.#####..#. ................................ 
// C27  = ....#.#......#..##....#.#####..# ................................ 
// C28  = .....#.#......#..##....#.#####.. ................................ 
// C29  = ......#.#......#..##....#.#####. ................................ 
// C30  = .......#.#......#..##....#.##### ................................ 
// C31  = ........#.#......#..##....#.#### ................................ 
//
// Number of XORs used is 32
// Maximum XOR input count is 13
//   Best possible depth in 4 LUTs = 2
//   Best possible depth in 5 LUTs = 2
//   Best possible depth in 6 LUTs = 2
// Total XOR inputs 260
//

module fec_rot_32 (
    input [31:0] c,
    output [31:0] co
);

assign co[0] =
    c[0] ^ c[9] ^ c[11] ^ c[18] ^ c[21] ^ c[22] ^ 
    c[27] ^ c[29] ^ c[30] ^ c[31];

assign co[1] =
    c[1] ^ c[10] ^ c[12] ^ c[19] ^ c[22] ^ c[23] ^ 
    c[28] ^ c[30] ^ c[31];

assign co[2] =
    c[0] ^ c[2] ^ c[9] ^ c[13] ^ c[18] ^ c[20] ^ 
    c[21] ^ c[22] ^ c[23] ^ c[24] ^ c[27] ^ c[30];

assign co[3] =
    c[1] ^ c[3] ^ c[10] ^ c[14] ^ c[19] ^ c[21] ^ 
    c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[28] ^ c[31];

assign co[4] =
    c[2] ^ c[4] ^ c[11] ^ c[15] ^ c[20] ^ c[22] ^ 
    c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[29];

assign co[5] =
    c[3] ^ c[5] ^ c[12] ^ c[16] ^ c[21] ^ c[23] ^ 
    c[24] ^ c[25] ^ c[26] ^ c[27] ^ c[30];

assign co[6] =
    c[4] ^ c[6] ^ c[13] ^ c[17] ^ c[22] ^ c[24] ^ 
    c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[31];

assign co[7] =
    c[5] ^ c[7] ^ c[14] ^ c[18] ^ c[23] ^ c[25] ^ 
    c[26] ^ c[27] ^ c[28] ^ c[29];

assign co[8] =
    c[6] ^ c[8] ^ c[15] ^ c[19] ^ c[24] ^ c[26] ^ 
    c[27] ^ c[28] ^ c[29] ^ c[30];

assign co[9] =
    c[7] ^ c[9] ^ c[16] ^ c[20] ^ c[25] ^ c[27] ^ 
    c[28] ^ c[29] ^ c[30] ^ c[31];

assign co[10] =
    c[8] ^ c[10] ^ c[17] ^ c[21] ^ c[26] ^ c[28] ^ 
    c[29] ^ c[30] ^ c[31];

assign co[11] =
    c[0] ^ c[21];

assign co[12] =
    c[1] ^ c[22];

assign co[13] =
    c[2] ^ c[23];

assign co[14] =
    c[3] ^ c[24];

assign co[15] =
    c[4] ^ c[25];

assign co[16] =
    c[5] ^ c[26];

assign co[17] =
    c[6] ^ c[27];

assign co[18] =
    c[7] ^ c[28];

assign co[19] =
    c[8] ^ c[29];

assign co[20] =
    c[9] ^ c[30];

assign co[21] =
    c[0] ^ c[9] ^ c[10] ^ c[11] ^ c[18] ^ c[21] ^ 
    c[22] ^ c[27] ^ c[29] ^ c[30];

assign co[22] =
    c[1] ^ c[10] ^ c[11] ^ c[12] ^ c[19] ^ c[22] ^ 
    c[23] ^ c[28] ^ c[30] ^ c[31];

assign co[23] =
    c[0] ^ c[2] ^ c[9] ^ c[12] ^ c[13] ^ c[18] ^ 
    c[20] ^ c[21] ^ c[22] ^ c[23] ^ c[24] ^ c[27] ^ c[30];

assign co[24] =
    c[1] ^ c[3] ^ c[10] ^ c[13] ^ c[14] ^ c[19] ^ 
    c[21] ^ c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[28] ^ c[31];

assign co[25] =
    c[2] ^ c[4] ^ c[11] ^ c[14] ^ c[15] ^ c[20] ^ 
    c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[29];

assign co[26] =
    c[3] ^ c[5] ^ c[12] ^ c[15] ^ c[16] ^ c[21] ^ 
    c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[27] ^ c[30];

assign co[27] =
    c[4] ^ c[6] ^ c[13] ^ c[16] ^ c[17] ^ c[22] ^ 
    c[24] ^ c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[31];

assign co[28] =
    c[5] ^ c[7] ^ c[14] ^ c[17] ^ c[18] ^ c[23] ^ 
    c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[29];

assign co[29] =
    c[6] ^ c[8] ^ c[15] ^ c[18] ^ c[19] ^ c[24] ^ 
    c[26] ^ c[27] ^ c[28] ^ c[29] ^ c[30];

assign co[30] =
    c[7] ^ c[9] ^ c[16] ^ c[19] ^ c[20] ^ c[25] ^ 
    c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];

assign co[31] =
    c[8] ^ c[10] ^ c[17] ^ c[20] ^ c[21] ^ c[26] ^ 
    c[28] ^ c[29] ^ c[30] ^ c[31];

endmodule


