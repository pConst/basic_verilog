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

// baeckler - 1-19-2006

module sbox0 (in,out);
input [5:0] in;
output [3:0] out;

reg [3:0] out;

always @(in) begin
  case (in)
    0 : out = 14;
    1 : out = 0;
    2 : out = 4;
    3 : out = 15;
    4 : out = 13;
    5 : out = 7;
    6 : out = 1;
    7 : out = 4;
    8 : out = 2;
    9 : out = 14;
    10 : out = 15;
    11 : out = 2;
    12 : out = 11;
    13 : out = 13;
    14 : out = 8;
    15 : out = 1;
    16 : out = 3;
    17 : out = 10;
    18 : out = 10;
    19 : out = 6;
    20 : out = 6;
    21 : out = 12;
    22 : out = 12;
    23 : out = 11;
    24 : out = 5;
    25 : out = 9;
    26 : out = 9;
    27 : out = 5;
    28 : out = 0;
    29 : out = 3;
    30 : out = 7;
    31 : out = 8;
    32 : out = 4;
    33 : out = 15;
    34 : out = 1;
    35 : out = 12;
    36 : out = 14;
    37 : out = 8;
    38 : out = 8;
    39 : out = 2;
    40 : out = 13;
    41 : out = 4;
    42 : out = 6;
    43 : out = 9;
    44 : out = 2;
    45 : out = 1;
    46 : out = 11;
    47 : out = 7;
    48 : out = 15;
    49 : out = 5;
    50 : out = 12;
    51 : out = 11;
    52 : out = 9;
    53 : out = 3;
    54 : out = 7;
    55 : out = 14;
    56 : out = 3;
    57 : out = 10;
    58 : out = 10;
    59 : out = 0;
    60 : out = 5;
    61 : out = 6;
    62 : out = 0;
    63 : out = 13;
  endcase
end
endmodule

module sbox1 (in,out);
input [5:0] in;
output [3:0] out;

reg [3:0] out;

always @(in) begin
  case (in)
    0 : out = 15;
    1 : out = 3;
    2 : out = 1;
    3 : out = 13;
    4 : out = 8;
    5 : out = 4;
    6 : out = 14;
    7 : out = 7;
    8 : out = 6;
    9 : out = 15;
    10 : out = 11;
    11 : out = 2;
    12 : out = 3;
    13 : out = 8;
    14 : out = 4;
    15 : out = 14;
    16 : out = 9;
    17 : out = 12;
    18 : out = 7;
    19 : out = 0;
    20 : out = 2;
    21 : out = 1;
    22 : out = 13;
    23 : out = 10;
    24 : out = 12;
    25 : out = 6;
    26 : out = 0;
    27 : out = 9;
    28 : out = 5;
    29 : out = 11;
    30 : out = 10;
    31 : out = 5;
    32 : out = 0;
    33 : out = 13;
    34 : out = 14;
    35 : out = 8;
    36 : out = 7;
    37 : out = 10;
    38 : out = 11;
    39 : out = 1;
    40 : out = 10;
    41 : out = 3;
    42 : out = 4;
    43 : out = 15;
    44 : out = 13;
    45 : out = 4;
    46 : out = 1;
    47 : out = 2;
    48 : out = 5;
    49 : out = 11;
    50 : out = 8;
    51 : out = 6;
    52 : out = 12;
    53 : out = 7;
    54 : out = 6;
    55 : out = 12;
    56 : out = 9;
    57 : out = 0;
    58 : out = 3;
    59 : out = 5;
    60 : out = 2;
    61 : out = 14;
    62 : out = 15;
    63 : out = 9;
  endcase
end
endmodule

module sbox2 (in,out);
input [5:0] in;
output [3:0] out;

reg [3:0] out;

always @(in) begin
  case (in)
    0 : out = 10;
    1 : out = 13;
    2 : out = 0;
    3 : out = 7;
    4 : out = 9;
    5 : out = 0;
    6 : out = 14;
    7 : out = 9;
    8 : out = 6;
    9 : out = 3;
    10 : out = 3;
    11 : out = 4;
    12 : out = 15;
    13 : out = 6;
    14 : out = 5;
    15 : out = 10;
    16 : out = 1;
    17 : out = 2;
    18 : out = 13;
    19 : out = 8;
    20 : out = 12;
    21 : out = 5;
    22 : out = 7;
    23 : out = 14;
    24 : out = 11;
    25 : out = 12;
    26 : out = 4;
    27 : out = 11;
    28 : out = 2;
    29 : out = 15;
    30 : out = 8;
    31 : out = 1;
    32 : out = 13;
    33 : out = 1;
    34 : out = 6;
    35 : out = 10;
    36 : out = 4;
    37 : out = 13;
    38 : out = 9;
    39 : out = 0;
    40 : out = 8;
    41 : out = 6;
    42 : out = 15;
    43 : out = 9;
    44 : out = 3;
    45 : out = 8;
    46 : out = 0;
    47 : out = 7;
    48 : out = 11;
    49 : out = 4;
    50 : out = 1;
    51 : out = 15;
    52 : out = 2;
    53 : out = 14;
    54 : out = 12;
    55 : out = 3;
    56 : out = 5;
    57 : out = 11;
    58 : out = 10;
    59 : out = 5;
    60 : out = 14;
    61 : out = 2;
    62 : out = 7;
    63 : out = 12;
  endcase
end
endmodule

module sbox3 (in,out);
input [5:0] in;
output [3:0] out;

reg [3:0] out;

always @(in) begin
  case (in)
    0 : out = 7;
    1 : out = 13;
    2 : out = 13;
    3 : out = 8;
    4 : out = 14;
    5 : out = 11;
    6 : out = 3;
    7 : out = 5;
    8 : out = 0;
    9 : out = 6;
    10 : out = 6;
    11 : out = 15;
    12 : out = 9;
    13 : out = 0;
    14 : out = 10;
    15 : out = 3;
    16 : out = 1;
    17 : out = 4;
    18 : out = 2;
    19 : out = 7;
    20 : out = 8;
    21 : out = 2;
    22 : out = 5;
    23 : out = 12;
    24 : out = 11;
    25 : out = 1;
    26 : out = 12;
    27 : out = 10;
    28 : out = 4;
    29 : out = 14;
    30 : out = 15;
    31 : out = 9;
    32 : out = 10;
    33 : out = 3;
    34 : out = 6;
    35 : out = 15;
    36 : out = 9;
    37 : out = 0;
    38 : out = 0;
    39 : out = 6;
    40 : out = 12;
    41 : out = 10;
    42 : out = 11;
    43 : out = 1;
    44 : out = 7;
    45 : out = 13;
    46 : out = 13;
    47 : out = 8;
    48 : out = 15;
    49 : out = 9;
    50 : out = 1;
    51 : out = 4;
    52 : out = 3;
    53 : out = 5;
    54 : out = 14;
    55 : out = 11;
    56 : out = 5;
    57 : out = 12;
    58 : out = 2;
    59 : out = 7;
    60 : out = 8;
    61 : out = 2;
    62 : out = 4;
    63 : out = 14;
  endcase
end
endmodule

module sbox4 (in,out);
input [5:0] in;
output [3:0] out;

reg [3:0] out;

always @(in) begin
  case (in)
    0 : out = 2;
    1 : out = 14;
    2 : out = 12;
    3 : out = 11;
    4 : out = 4;
    5 : out = 2;
    6 : out = 1;
    7 : out = 12;
    8 : out = 7;
    9 : out = 4;
    10 : out = 10;
    11 : out = 7;
    12 : out = 11;
    13 : out = 13;
    14 : out = 6;
    15 : out = 1;
    16 : out = 8;
    17 : out = 5;
    18 : out = 5;
    19 : out = 0;
    20 : out = 3;
    21 : out = 15;
    22 : out = 15;
    23 : out = 10;
    24 : out = 13;
    25 : out = 3;
    26 : out = 0;
    27 : out = 9;
    28 : out = 14;
    29 : out = 8;
    30 : out = 9;
    31 : out = 6;
    32 : out = 4;
    33 : out = 11;
    34 : out = 2;
    35 : out = 8;
    36 : out = 1;
    37 : out = 12;
    38 : out = 11;
    39 : out = 7;
    40 : out = 10;
    41 : out = 1;
    42 : out = 13;
    43 : out = 14;
    44 : out = 7;
    45 : out = 2;
    46 : out = 8;
    47 : out = 13;
    48 : out = 15;
    49 : out = 6;
    50 : out = 9;
    51 : out = 15;
    52 : out = 12;
    53 : out = 0;
    54 : out = 5;
    55 : out = 9;
    56 : out = 6;
    57 : out = 10;
    58 : out = 3;
    59 : out = 4;
    60 : out = 0;
    61 : out = 5;
    62 : out = 14;
    63 : out = 3;
  endcase
end
endmodule

module sbox5 (in,out);
input [5:0] in;
output [3:0] out;

reg [3:0] out;

always @(in) begin
  case (in)
    0 : out = 12;
    1 : out = 10;
    2 : out = 1;
    3 : out = 15;
    4 : out = 10;
    5 : out = 4;
    6 : out = 15;
    7 : out = 2;
    8 : out = 9;
    9 : out = 7;
    10 : out = 2;
    11 : out = 12;
    12 : out = 6;
    13 : out = 9;
    14 : out = 8;
    15 : out = 5;
    16 : out = 0;
    17 : out = 6;
    18 : out = 13;
    19 : out = 1;
    20 : out = 3;
    21 : out = 13;
    22 : out = 4;
    23 : out = 14;
    24 : out = 14;
    25 : out = 0;
    26 : out = 7;
    27 : out = 11;
    28 : out = 5;
    29 : out = 3;
    30 : out = 11;
    31 : out = 8;
    32 : out = 9;
    33 : out = 4;
    34 : out = 14;
    35 : out = 3;
    36 : out = 15;
    37 : out = 2;
    38 : out = 5;
    39 : out = 12;
    40 : out = 2;
    41 : out = 9;
    42 : out = 8;
    43 : out = 5;
    44 : out = 12;
    45 : out = 15;
    46 : out = 3;
    47 : out = 10;
    48 : out = 7;
    49 : out = 11;
    50 : out = 0;
    51 : out = 14;
    52 : out = 4;
    53 : out = 1;
    54 : out = 10;
    55 : out = 7;
    56 : out = 1;
    57 : out = 6;
    58 : out = 13;
    59 : out = 0;
    60 : out = 11;
    61 : out = 8;
    62 : out = 6;
    63 : out = 13;
  endcase
end
endmodule

module sbox6 (in,out);
input [5:0] in;
output [3:0] out;

reg [3:0] out;

always @(in) begin
  case (in)
    0 : out = 4;
    1 : out = 13;
    2 : out = 11;
    3 : out = 0;
    4 : out = 2;
    5 : out = 11;
    6 : out = 14;
    7 : out = 7;
    8 : out = 15;
    9 : out = 4;
    10 : out = 0;
    11 : out = 9;
    12 : out = 8;
    13 : out = 1;
    14 : out = 13;
    15 : out = 10;
    16 : out = 3;
    17 : out = 14;
    18 : out = 12;
    19 : out = 3;
    20 : out = 9;
    21 : out = 5;
    22 : out = 7;
    23 : out = 12;
    24 : out = 5;
    25 : out = 2;
    26 : out = 10;
    27 : out = 15;
    28 : out = 6;
    29 : out = 8;
    30 : out = 1;
    31 : out = 6;
    32 : out = 1;
    33 : out = 6;
    34 : out = 4;
    35 : out = 11;
    36 : out = 11;
    37 : out = 13;
    38 : out = 13;
    39 : out = 8;
    40 : out = 12;
    41 : out = 1;
    42 : out = 3;
    43 : out = 4;
    44 : out = 7;
    45 : out = 10;
    46 : out = 14;
    47 : out = 7;
    48 : out = 10;
    49 : out = 9;
    50 : out = 15;
    51 : out = 5;
    52 : out = 6;
    53 : out = 0;
    54 : out = 8;
    55 : out = 15;
    56 : out = 0;
    57 : out = 14;
    58 : out = 5;
    59 : out = 2;
    60 : out = 9;
    61 : out = 3;
    62 : out = 2;
    63 : out = 12;
  endcase
end
endmodule

module sbox7 (in,out);
input [5:0] in;
output [3:0] out;

reg [3:0] out;

always @(in) begin
  case (in)
    0 : out = 13;
    1 : out = 1;
    2 : out = 2;
    3 : out = 15;
    4 : out = 8;
    5 : out = 13;
    6 : out = 4;
    7 : out = 8;
    8 : out = 6;
    9 : out = 10;
    10 : out = 15;
    11 : out = 3;
    12 : out = 11;
    13 : out = 7;
    14 : out = 1;
    15 : out = 4;
    16 : out = 10;
    17 : out = 12;
    18 : out = 9;
    19 : out = 5;
    20 : out = 3;
    21 : out = 6;
    22 : out = 14;
    23 : out = 11;
    24 : out = 5;
    25 : out = 0;
    26 : out = 0;
    27 : out = 14;
    28 : out = 12;
    29 : out = 9;
    30 : out = 7;
    31 : out = 2;
    32 : out = 7;
    33 : out = 2;
    34 : out = 11;
    35 : out = 1;
    36 : out = 4;
    37 : out = 14;
    38 : out = 1;
    39 : out = 7;
    40 : out = 9;
    41 : out = 4;
    42 : out = 12;
    43 : out = 10;
    44 : out = 14;
    45 : out = 8;
    46 : out = 2;
    47 : out = 13;
    48 : out = 0;
    49 : out = 15;
    50 : out = 6;
    51 : out = 12;
    52 : out = 10;
    53 : out = 9;
    54 : out = 13;
    55 : out = 0;
    56 : out = 15;
    57 : out = 3;
    58 : out = 3;
    59 : out = 5;
    60 : out = 5;
    61 : out = 6;
    62 : out = 8;
    63 : out = 11;
  endcase
end
endmodule

module sboxes (in,out);
input [47:0] in;
output [31:0] out;

wire [31:0] out;

sbox7 s0 (.in(in[5:0]),.out(out[3:0]));
sbox6 s1 (.in(in[11:6]),.out(out[7:4]));
sbox5 s2 (.in(in[17:12]),.out(out[11:8]));
sbox4 s3 (.in(in[23:18]),.out(out[15:12]));
sbox3 s4 (.in(in[29:24]),.out(out[19:16]));
sbox2 s5 (.in(in[35:30]),.out(out[23:20]));
sbox1 s6 (.in(in[41:36]),.out(out[27:24]));
sbox0 s7 (.in(in[47:42]),.out(out[31:28]));
endmodule

