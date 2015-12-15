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
// 58 bit CRC of 1 data bits (forward - LSB first)
// polynomial : 00000080 00000001 
//    x^39 + x^0
//
//        CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC D 
//        0000000000111111111122222222223333333333444444444455555555 0 
//        0123456789012345678901234567890123456789012345678901234567 0 
// C00  = .........................................................# # 
// C01  = #......................................................... . 
// C02  = .#........................................................ . 
// C03  = ..#....................................................... . 
// C04  = ...#...................................................... . 
// C05  = ....#..................................................... . 
// C06  = .....#.................................................... . 
// C07  = ......#................................................... . 
// C08  = .......#.................................................. . 
// C09  = ........#................................................. . 
// C10  = .........#................................................ . 
// C11  = ..........#............................................... . 
// C12  = ...........#.............................................. . 
// C13  = ............#............................................. . 
// C14  = .............#............................................ . 
// C15  = ..............#........................................... . 
// C16  = ...............#.......................................... . 
// C17  = ................#......................................... . 
// C18  = .................#........................................ . 
// C19  = ..................#....................................... . 
// C20  = ...................#...................................... . 
// C21  = ....................#..................................... . 
// C22  = .....................#.................................... . 
// C23  = ......................#................................... . 
// C24  = .......................#.................................. . 
// C25  = ........................#................................. . 
// C26  = .........................#................................ . 
// C27  = ..........................#............................... . 
// C28  = ...........................#.............................. . 
// C29  = ............................#............................. . 
// C30  = .............................#............................ . 
// C31  = ..............................#........................... . 
// C32  = ...............................#.......................... . 
// C33  = ................................#......................... . 
// C34  = .................................#........................ . 
// C35  = ..................................#....................... . 
// C36  = ...................................#...................... . 
// C37  = ....................................#..................... . 
// C38  = .....................................#.................... . 
// C39  = ......................................#..................# # 
// C40  = .......................................#.................. . 
// C41  = ........................................#................. . 
// C42  = .........................................#................ . 
// C43  = ..........................................#............... . 
// C44  = ...........................................#.............. . 
// C45  = ............................................#............. . 
// C46  = .............................................#............ . 
// C47  = ..............................................#........... . 
// C48  = ...............................................#.......... . 
// C49  = ................................................#......... . 
// C50  = .................................................#........ . 
// C51  = ..................................................#....... . 
// C52  = ...................................................#...... . 
// C53  = ....................................................#..... . 
// C54  = .....................................................#.... . 
// C55  = ......................................................#... . 
// C56  = .......................................................#.. . 
// C57  = ........................................................#. . 
//
// Number of XORs used is 58
// Maximum XOR input count is 3
//   Best possible depth in 4 LUTs = 1
//   Best possible depth in 5 LUTs = 1
//   Best possible depth in 6 LUTs = 1
// Total XOR inputs 61
//

module crc_flat (
    input [57:0] c,
    input [0:0] d,
    output [57:0] crc_out
);

assign crc_out[0] =
    c[57] ^ d[0];

assign crc_out[1] =
    c[0];

assign crc_out[2] =
    c[1];

assign crc_out[3] =
    c[2];

assign crc_out[4] =
    c[3];

assign crc_out[5] =
    c[4];

assign crc_out[6] =
    c[5];

assign crc_out[7] =
    c[6];

assign crc_out[8] =
    c[7];

assign crc_out[9] =
    c[8];

assign crc_out[10] =
    c[9];

assign crc_out[11] =
    c[10];

assign crc_out[12] =
    c[11];

assign crc_out[13] =
    c[12];

assign crc_out[14] =
    c[13];

assign crc_out[15] =
    c[14];

assign crc_out[16] =
    c[15];

assign crc_out[17] =
    c[16];

assign crc_out[18] =
    c[17];

assign crc_out[19] =
    c[18];

assign crc_out[20] =
    c[19];

assign crc_out[21] =
    c[20];

assign crc_out[22] =
    c[21];

assign crc_out[23] =
    c[22];

assign crc_out[24] =
    c[23];

assign crc_out[25] =
    c[24];

assign crc_out[26] =
    c[25];

assign crc_out[27] =
    c[26];

assign crc_out[28] =
    c[27];

assign crc_out[29] =
    c[28];

assign crc_out[30] =
    c[29];

assign crc_out[31] =
    c[30];

assign crc_out[32] =
    c[31];

assign crc_out[33] =
    c[32];

assign crc_out[34] =
    c[33];

assign crc_out[35] =
    c[34];

assign crc_out[36] =
    c[35];

assign crc_out[37] =
    c[36];

assign crc_out[38] =
    c[37];

assign crc_out[39] =
    c[38] ^ c[57] ^ d[0];

assign crc_out[40] =
    c[39];

assign crc_out[41] =
    c[40];

assign crc_out[42] =
    c[41];

assign crc_out[43] =
    c[42];

assign crc_out[44] =
    c[43];

assign crc_out[45] =
    c[44];

assign crc_out[46] =
    c[45];

assign crc_out[47] =
    c[46];

assign crc_out[48] =
    c[47];

assign crc_out[49] =
    c[48];

assign crc_out[50] =
    c[49];

assign crc_out[51] =
    c[50];

assign crc_out[52] =
    c[51];

assign crc_out[53] =
    c[52];

assign crc_out[54] =
    c[53];

assign crc_out[55] =
    c[54];

assign crc_out[56] =
    c[55];

assign crc_out[57] =
    c[56];

endmodule


