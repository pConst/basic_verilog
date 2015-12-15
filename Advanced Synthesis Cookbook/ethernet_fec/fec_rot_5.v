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
// 32 bit CRC of 5 data bits (forward - LSB first)
// polynomial : 00a00805 
//    x^23 + x^21 + x^11 + x^2 + x^0
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC DDDDD 
//        00000000001111111111222222222233 00000 
//        01234567890123456789012345678901 01234 
// C00  = ...........................#.... ..... 
// C01  = ............................#... ..... 
// C02  = ...........................#.#.. ..... 
// C03  = ............................#.#. ..... 
// C04  = .............................#.# ..... 
// C05  = #.............................#. ..... 
// C06  = .#.............................# ..... 
// C07  = ..#............................. ..... 
// C08  = ...#............................ ..... 
// C09  = ....#........................... ..... 
// C10  = .....#.......................... ..... 
// C11  = ......#....................#.... ..... 
// C12  = .......#....................#... ..... 
// C13  = ........#....................#.. ..... 
// C14  = .........#....................#. ..... 
// C15  = ..........#....................# ..... 
// C16  = ...........#.................... ..... 
// C17  = ............#................... ..... 
// C18  = .............#.................. ..... 
// C19  = ..............#................. ..... 
// C20  = ...............#................ ..... 
// C21  = ................#..........#.... ..... 
// C22  = .................#..........#... ..... 
// C23  = ..................#........#.#.. ..... 
// C24  = ...................#........#.#. ..... 
// C25  = ....................#........#.# ..... 
// C26  = .....................#........#. ..... 
// C27  = ......................#........# ..... 
// C28  = .......................#........ ..... 
// C29  = ........................#....... ..... 
// C30  = .........................#...... ..... 
// C31  = ..........................#..... ..... 
//
// Number of XORs used is 32
// Maximum XOR input count is 3
//   Best possible depth in 4 LUTs = 1
//   Best possible depth in 5 LUTs = 1
//   Best possible depth in 6 LUTs = 1
// Total XOR inputs 52
//

module fec_rot_5 (
    input [31:0] c,
    output [31:0] co
);

assign co[0] =
    c[27];

assign co[1] =
    c[28];

assign co[2] =
    c[27] ^ c[29];

assign co[3] =
    c[28] ^ c[30];

assign co[4] =
    c[29] ^ c[31];

assign co[5] =
    c[0] ^ c[30];

assign co[6] =
    c[1] ^ c[31];

assign co[7] =
    c[2];

assign co[8] =
    c[3];

assign co[9] =
    c[4];

assign co[10] =
    c[5];

assign co[11] =
    c[6] ^ c[27];

assign co[12] =
    c[7] ^ c[28];

assign co[13] =
    c[8] ^ c[29];

assign co[14] =
    c[9] ^ c[30];

assign co[15] =
    c[10] ^ c[31];

assign co[16] =
    c[11];

assign co[17] =
    c[12];

assign co[18] =
    c[13];

assign co[19] =
    c[14];

assign co[20] =
    c[15];

assign co[21] =
    c[16] ^ c[27];

assign co[22] =
    c[17] ^ c[28];

assign co[23] =
    c[18] ^ c[27] ^ c[29];

assign co[24] =
    c[19] ^ c[28] ^ c[30];

assign co[25] =
    c[20] ^ c[29] ^ c[31];

assign co[26] =
    c[21] ^ c[30];

assign co[27] =
    c[22] ^ c[31];

assign co[28] =
    c[23];

assign co[29] =
    c[24];

assign co[30] =
    c[25];

assign co[31] =
    c[26];

endmodule


