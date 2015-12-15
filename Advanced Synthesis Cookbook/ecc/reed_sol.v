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

// baeckler - 08-08-2006

// Reed Solomon
// N = 255 (symbols per code word)
// K = 239 (data symbols)
// t = 8 (# of errors corrected)
// 2t = 16 (# of check symbols)
// m = 8 (bits per symbol)


// alpha ^ 0 = 01
// alpha ^ 1 = 02
// alpha ^ 2 = 04
// alpha ^ 3 = 08
// alpha ^ 4 = 10
// alpha ^ 5 = 20
// alpha ^ 6 = 40
// alpha ^ 7 = 80
// alpha ^ 8 = 1d
// alpha ^ 9 = 3a
// alpha ^ 10 = 74
// alpha ^ 11 = e8
// alpha ^ 12 = cd
// alpha ^ 13 = 87
// alpha ^ 14 = 13
// alpha ^ 15 = 26
// alpha ^ 16 = 4c
// alpha ^ 17 = 98
// alpha ^ 18 = 2d
// alpha ^ 19 = 5a
// alpha ^ 20 = b4
// alpha ^ 21 = 75
// alpha ^ 22 = ea
// alpha ^ 23 = c9
// alpha ^ 24 = 8f
// alpha ^ 25 = 03
// alpha ^ 26 = 06
// alpha ^ 27 = 0c
// alpha ^ 28 = 18
// alpha ^ 29 = 30
// alpha ^ 30 = 60
// alpha ^ 31 = c0
// alpha ^ 32 = 9d
// alpha ^ 33 = 27
// alpha ^ 34 = 4e
// alpha ^ 35 = 9c
// alpha ^ 36 = 25
// alpha ^ 37 = 4a
// alpha ^ 38 = 94
// alpha ^ 39 = 35
// alpha ^ 40 = 6a
// alpha ^ 41 = d4
// alpha ^ 42 = b5
// alpha ^ 43 = 77
// alpha ^ 44 = ee
// alpha ^ 45 = c1
// alpha ^ 46 = 9f
// alpha ^ 47 = 23
// alpha ^ 48 = 46
// alpha ^ 49 = 8c
// alpha ^ 50 = 05
// alpha ^ 51 = 0a
// alpha ^ 52 = 14
// alpha ^ 53 = 28
// alpha ^ 54 = 50
// alpha ^ 55 = a0
// alpha ^ 56 = 5d
// alpha ^ 57 = ba
// alpha ^ 58 = 69
// alpha ^ 59 = d2
// alpha ^ 60 = b9
// alpha ^ 61 = 6f
// alpha ^ 62 = de
// alpha ^ 63 = a1
// alpha ^ 64 = 5f
// alpha ^ 65 = be
// alpha ^ 66 = 61
// alpha ^ 67 = c2
// alpha ^ 68 = 99
// alpha ^ 69 = 2f
// alpha ^ 70 = 5e
// alpha ^ 71 = bc
// alpha ^ 72 = 65
// alpha ^ 73 = ca
// alpha ^ 74 = 89
// alpha ^ 75 = 0f
// alpha ^ 76 = 1e
// alpha ^ 77 = 3c
// alpha ^ 78 = 78
// alpha ^ 79 = f0
// alpha ^ 80 = fd
// alpha ^ 81 = e7
// alpha ^ 82 = d3
// alpha ^ 83 = bb
// alpha ^ 84 = 6b
// alpha ^ 85 = d6
// alpha ^ 86 = b1
// alpha ^ 87 = 7f
// alpha ^ 88 = fe
// alpha ^ 89 = e1
// alpha ^ 90 = df
// alpha ^ 91 = a3
// alpha ^ 92 = 5b
// alpha ^ 93 = b6
// alpha ^ 94 = 71
// alpha ^ 95 = e2
// alpha ^ 96 = d9
// alpha ^ 97 = af
// alpha ^ 98 = 43
// alpha ^ 99 = 86
// alpha ^ 100 = 11
// alpha ^ 101 = 22
// alpha ^ 102 = 44
// alpha ^ 103 = 88
// alpha ^ 104 = 0d
// alpha ^ 105 = 1a
// alpha ^ 106 = 34
// alpha ^ 107 = 68
// alpha ^ 108 = d0
// alpha ^ 109 = bd
// alpha ^ 110 = 67
// alpha ^ 111 = ce
// alpha ^ 112 = 81
// alpha ^ 113 = 1f
// alpha ^ 114 = 3e
// alpha ^ 115 = 7c
// alpha ^ 116 = f8
// alpha ^ 117 = ed
// alpha ^ 118 = c7
// alpha ^ 119 = 93
// alpha ^ 120 = 3b
// alpha ^ 121 = 76
// alpha ^ 122 = ec
// alpha ^ 123 = c5
// alpha ^ 124 = 97
// alpha ^ 125 = 33
// alpha ^ 126 = 66
// alpha ^ 127 = cc
// alpha ^ 128 = 85
// alpha ^ 129 = 17
// alpha ^ 130 = 2e
// alpha ^ 131 = 5c
// alpha ^ 132 = b8
// alpha ^ 133 = 6d
// alpha ^ 134 = da
// alpha ^ 135 = a9
// alpha ^ 136 = 4f
// alpha ^ 137 = 9e
// alpha ^ 138 = 21
// alpha ^ 139 = 42
// alpha ^ 140 = 84
// alpha ^ 141 = 15
// alpha ^ 142 = 2a
// alpha ^ 143 = 54
// alpha ^ 144 = a8
// alpha ^ 145 = 4d
// alpha ^ 146 = 9a
// alpha ^ 147 = 29
// alpha ^ 148 = 52
// alpha ^ 149 = a4
// alpha ^ 150 = 55
// alpha ^ 151 = aa
// alpha ^ 152 = 49
// alpha ^ 153 = 92
// alpha ^ 154 = 39
// alpha ^ 155 = 72
// alpha ^ 156 = e4
// alpha ^ 157 = d5
// alpha ^ 158 = b7
// alpha ^ 159 = 73
// alpha ^ 160 = e6
// alpha ^ 161 = d1
// alpha ^ 162 = bf
// alpha ^ 163 = 63
// alpha ^ 164 = c6
// alpha ^ 165 = 91
// alpha ^ 166 = 3f
// alpha ^ 167 = 7e
// alpha ^ 168 = fc
// alpha ^ 169 = e5
// alpha ^ 170 = d7
// alpha ^ 171 = b3
// alpha ^ 172 = 7b
// alpha ^ 173 = f6
// alpha ^ 174 = f1
// alpha ^ 175 = ff
// alpha ^ 176 = e3
// alpha ^ 177 = db
// alpha ^ 178 = ab
// alpha ^ 179 = 4b
// alpha ^ 180 = 96
// alpha ^ 181 = 31
// alpha ^ 182 = 62
// alpha ^ 183 = c4
// alpha ^ 184 = 95
// alpha ^ 185 = 37
// alpha ^ 186 = 6e
// alpha ^ 187 = dc
// alpha ^ 188 = a5
// alpha ^ 189 = 57
// alpha ^ 190 = ae
// alpha ^ 191 = 41
// alpha ^ 192 = 82
// alpha ^ 193 = 19
// alpha ^ 194 = 32
// alpha ^ 195 = 64
// alpha ^ 196 = c8
// alpha ^ 197 = 8d
// alpha ^ 198 = 07
// alpha ^ 199 = 0e
// alpha ^ 200 = 1c
// alpha ^ 201 = 38
// alpha ^ 202 = 70
// alpha ^ 203 = e0
// alpha ^ 204 = dd
// alpha ^ 205 = a7
// alpha ^ 206 = 53
// alpha ^ 207 = a6
// alpha ^ 208 = 51
// alpha ^ 209 = a2
// alpha ^ 210 = 59
// alpha ^ 211 = b2
// alpha ^ 212 = 79
// alpha ^ 213 = f2
// alpha ^ 214 = f9
// alpha ^ 215 = ef
// alpha ^ 216 = c3
// alpha ^ 217 = 9b
// alpha ^ 218 = 2b
// alpha ^ 219 = 56
// alpha ^ 220 = ac
// alpha ^ 221 = 45
// alpha ^ 222 = 8a
// alpha ^ 223 = 09
// alpha ^ 224 = 12
// alpha ^ 225 = 24
// alpha ^ 226 = 48
// alpha ^ 227 = 90
// alpha ^ 228 = 3d
// alpha ^ 229 = 7a
// alpha ^ 230 = f4
// alpha ^ 231 = f5
// alpha ^ 232 = f7
// alpha ^ 233 = f3
// alpha ^ 234 = fb
// alpha ^ 235 = eb
// alpha ^ 236 = cb
// alpha ^ 237 = 8b
// alpha ^ 238 = 0b
// alpha ^ 239 = 16
// alpha ^ 240 = 2c
// alpha ^ 241 = 58
// alpha ^ 242 = b0
// alpha ^ 243 = 7d
// alpha ^ 244 = fa
// alpha ^ 245 = e9
// alpha ^ 246 = cf
// alpha ^ 247 = 83
// alpha ^ 248 = 1b
// alpha ^ 249 = 36
// alpha ^ 250 = 6c
// alpha ^ 251 = d8
// alpha ^ 252 = ad
// alpha ^ 253 = 47
// alpha ^ 254 = 8e
// alpha ^ 255 = 01

// gen_poly [0] = 3b
// gen_poly [1] = 24
// gen_poly [2] = 32
// gen_poly [3] = 62
// gen_poly [4] = e5
// gen_poly [5] = 29
// gen_poly [6] = 41
// gen_poly [7] = a3
// gen_poly [8] = 08
// gen_poly [9] = 1e
// gen_poly [10] = d1
// gen_poly [11] = 44
// gen_poly [12] = bd
// gen_poly [13] = 68
// gen_poly [14] = 0d
// gen_poly [15] = 3b
// gen_poly [16] = 01

module gf_mult_by_01 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0];
  assign o[1] = i[1];
  assign o[2] = i[2];
  assign o[3] = i[3];
  assign o[4] = i[4];
  assign o[5] = i[5];
  assign o[6] = i[6];
  assign o[7] = i[7];
endmodule

module gf_mult_by_02 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[7];
  assign o[1] = i[0];
  assign o[2] = i[1]^i[7];
  assign o[3] = i[2]^i[7];
  assign o[4] = i[3]^i[7];
  assign o[5] = i[4];
  assign o[6] = i[5];
  assign o[7] = i[6];
endmodule

module gf_mult_by_03 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[7];
  assign o[1] = i[0]^i[1];
  assign o[2] = i[1]^i[2]^i[7];
  assign o[3] = i[2]^i[3]^i[7];
  assign o[4] = i[3]^i[4]^i[7];
  assign o[5] = i[4]^i[5];
  assign o[6] = i[5]^i[6];
  assign o[7] = i[6]^i[7];
endmodule

module gf_mult_by_04 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[6];
  assign o[1] = i[7];
  assign o[2] = i[0]^i[6];
  assign o[3] = i[1]^i[6]^i[7];
  assign o[4] = i[2]^i[6]^i[7];
  assign o[5] = i[3]^i[7];
  assign o[6] = i[4];
  assign o[7] = i[5];
endmodule

module gf_mult_by_05 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[6];
  assign o[1] = i[1]^i[7];
  assign o[2] = i[0]^i[2]^i[6];
  assign o[3] = i[1]^i[3]^i[6]^i[7];
  assign o[4] = i[2]^i[4]^i[6]^i[7];
  assign o[5] = i[3]^i[5]^i[7];
  assign o[6] = i[4]^i[6];
  assign o[7] = i[5]^i[7];
endmodule

module gf_mult_by_06 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[6]^i[7];
  assign o[1] = i[0]^i[7];
  assign o[2] = i[0]^i[1]^i[6]^i[7];
  assign o[3] = i[1]^i[2]^i[6];
  assign o[4] = i[2]^i[3]^i[6];
  assign o[5] = i[3]^i[4]^i[7];
  assign o[6] = i[4]^i[5];
  assign o[7] = i[5]^i[6];
endmodule

module gf_mult_by_07 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[6]^i[7];
  assign o[3] = i[1]^i[2]^i[3]^i[6];
  assign o[4] = i[2]^i[3]^i[4]^i[6];
  assign o[5] = i[3]^i[4]^i[5]^i[7];
  assign o[6] = i[4]^i[5]^i[6];
  assign o[7] = i[5]^i[6]^i[7];
endmodule

module gf_mult_by_08 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[5];
  assign o[1] = i[6];
  assign o[2] = i[5]^i[7];
  assign o[3] = i[0]^i[5]^i[6];
  assign o[4] = i[1]^i[5]^i[6]^i[7];
  assign o[5] = i[2]^i[6]^i[7];
  assign o[6] = i[3]^i[7];
  assign o[7] = i[4];
endmodule

module gf_mult_by_09 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[5];
  assign o[1] = i[1]^i[6];
  assign o[2] = i[2]^i[5]^i[7];
  assign o[3] = i[0]^i[3]^i[5]^i[6];
  assign o[4] = i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[2]^i[5]^i[6]^i[7];
  assign o[6] = i[3]^i[6]^i[7];
  assign o[7] = i[4]^i[7];
endmodule

module gf_mult_by_0a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[5]^i[7];
  assign o[1] = i[0]^i[6];
  assign o[2] = i[1]^i[5];
  assign o[3] = i[0]^i[2]^i[5]^i[6]^i[7];
  assign o[4] = i[1]^i[3]^i[5]^i[6];
  assign o[5] = i[2]^i[4]^i[6]^i[7];
  assign o[6] = i[3]^i[5]^i[7];
  assign o[7] = i[4]^i[6];
endmodule

module gf_mult_by_0b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[5]^i[7];
  assign o[1] = i[0]^i[1]^i[6];
  assign o[2] = i[1]^i[2]^i[5];
  assign o[3] = i[0]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[4] = i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[5] = i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[3]^i[5]^i[6]^i[7];
  assign o[7] = i[4]^i[6]^i[7];
endmodule

module gf_mult_by_0c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[5]^i[6];
  assign o[1] = i[6]^i[7];
  assign o[2] = i[0]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[5]^i[7];
  assign o[4] = i[1]^i[2]^i[5];
  assign o[5] = i[2]^i[3]^i[6];
  assign o[6] = i[3]^i[4]^i[7];
  assign o[7] = i[4]^i[5];
endmodule

module gf_mult_by_0d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[5]^i[6];
  assign o[1] = i[1]^i[6]^i[7];
  assign o[2] = i[0]^i[2]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[3]^i[5]^i[7];
  assign o[4] = i[1]^i[2]^i[4]^i[5];
  assign o[5] = i[2]^i[3]^i[5]^i[6];
  assign o[6] = i[3]^i[4]^i[6]^i[7];
  assign o[7] = i[4]^i[5]^i[7];
endmodule

module gf_mult_by_0e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[5]^i[6];
  assign o[3] = i[0]^i[1]^i[2]^i[5];
  assign o[4] = i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[5] = i[2]^i[3]^i[4]^i[6];
  assign o[6] = i[3]^i[4]^i[5]^i[7];
  assign o[7] = i[4]^i[5]^i[6];
endmodule

module gf_mult_by_0f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[5]^i[6];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[5];
  assign o[4] = i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[5] = i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[6] = i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_10 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[4];
  assign o[1] = i[5];
  assign o[2] = i[4]^i[6];
  assign o[3] = i[4]^i[5]^i[7];
  assign o[4] = i[0]^i[4]^i[5]^i[6];
  assign o[5] = i[1]^i[5]^i[6]^i[7];
  assign o[6] = i[2]^i[6]^i[7];
  assign o[7] = i[3]^i[7];
endmodule

module gf_mult_by_11 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[4];
  assign o[1] = i[1]^i[5];
  assign o[2] = i[2]^i[4]^i[6];
  assign o[3] = i[3]^i[4]^i[5]^i[7];
  assign o[4] = i[0]^i[5]^i[6];
  assign o[5] = i[1]^i[6]^i[7];
  assign o[6] = i[2]^i[7];
  assign o[7] = i[3];
endmodule

module gf_mult_by_12 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[4]^i[7];
  assign o[1] = i[0]^i[5];
  assign o[2] = i[1]^i[4]^i[6]^i[7];
  assign o[3] = i[2]^i[4]^i[5];
  assign o[4] = i[0]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[2]^i[5]^i[6]^i[7];
  assign o[7] = i[3]^i[6]^i[7];
endmodule

module gf_mult_by_13 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[4]^i[7];
  assign o[1] = i[0]^i[1]^i[5];
  assign o[2] = i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[3] = i[2]^i[3]^i[4]^i[5];
  assign o[4] = i[0]^i[3]^i[5]^i[6]^i[7];
  assign o[5] = i[1]^i[4]^i[6]^i[7];
  assign o[6] = i[2]^i[5]^i[7];
  assign o[7] = i[3]^i[6];
endmodule

module gf_mult_by_14 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[4]^i[6];
  assign o[1] = i[5]^i[7];
  assign o[2] = i[0]^i[4];
  assign o[3] = i[1]^i[4]^i[5]^i[6];
  assign o[4] = i[0]^i[2]^i[4]^i[5]^i[7];
  assign o[5] = i[1]^i[3]^i[5]^i[6];
  assign o[6] = i[2]^i[4]^i[6]^i[7];
  assign o[7] = i[3]^i[5]^i[7];
endmodule

module gf_mult_by_15 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[4]^i[6];
  assign o[1] = i[1]^i[5]^i[7];
  assign o[2] = i[0]^i[2]^i[4];
  assign o[3] = i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[4] = i[0]^i[2]^i[5]^i[7];
  assign o[5] = i[1]^i[3]^i[6];
  assign o[6] = i[2]^i[4]^i[7];
  assign o[7] = i[3]^i[5];
endmodule

module gf_mult_by_16 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[4]^i[6]^i[7];
  assign o[1] = i[0]^i[5]^i[7];
  assign o[2] = i[0]^i[1]^i[4]^i[7];
  assign o[3] = i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[4]^i[5];
  assign o[5] = i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[6] = i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[3]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_17 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[4]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[5]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[4]^i[7];
  assign o[3] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[5];
  assign o[5] = i[1]^i[3]^i[4]^i[6];
  assign o[6] = i[2]^i[4]^i[5]^i[7];
  assign o[7] = i[3]^i[5]^i[6];
endmodule

module gf_mult_by_18 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[4]^i[5];
  assign o[1] = i[5]^i[6];
  assign o[2] = i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[4]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[4]^i[7];
  assign o[5] = i[1]^i[2]^i[5];
  assign o[6] = i[2]^i[3]^i[6];
  assign o[7] = i[3]^i[4]^i[7];
endmodule

module gf_mult_by_19 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[4]^i[5];
  assign o[1] = i[1]^i[5]^i[6];
  assign o[2] = i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[3]^i[4]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[7];
  assign o[5] = i[1]^i[2];
  assign o[6] = i[2]^i[3];
  assign o[7] = i[3]^i[4];
endmodule

module gf_mult_by_1a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[4]^i[5]^i[7];
  assign o[1] = i[0]^i[5]^i[6];
  assign o[2] = i[1]^i[4]^i[5]^i[6];
  assign o[3] = i[0]^i[2]^i[4]^i[6];
  assign o[4] = i[0]^i[1]^i[3]^i[4];
  assign o[5] = i[1]^i[2]^i[4]^i[5];
  assign o[6] = i[2]^i[3]^i[5]^i[6];
  assign o[7] = i[3]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_1b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[4]^i[5]^i[7];
  assign o[1] = i[0]^i[1]^i[5]^i[6];
  assign o[2] = i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[3] = i[0]^i[2]^i[3]^i[4]^i[6];
  assign o[4] = i[0]^i[1]^i[3];
  assign o[5] = i[1]^i[2]^i[4];
  assign o[6] = i[2]^i[3]^i[5];
  assign o[7] = i[3]^i[4]^i[6];
endmodule

module gf_mult_by_1c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[4]^i[5]^i[6];
  assign o[1] = i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[4]^i[5]^i[7];
  assign o[3] = i[0]^i[1]^i[4];
  assign o[4] = i[0]^i[1]^i[2]^i[4]^i[6];
  assign o[5] = i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[6] = i[2]^i[3]^i[4]^i[6];
  assign o[7] = i[3]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_1d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[4]^i[5]^i[6];
  assign o[1] = i[1]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[2]^i[4]^i[5]^i[7];
  assign o[3] = i[0]^i[1]^i[3]^i[4];
  assign o[4] = i[0]^i[1]^i[2]^i[6];
  assign o[5] = i[1]^i[2]^i[3]^i[7];
  assign o[6] = i[2]^i[3]^i[4];
  assign o[7] = i[3]^i[4]^i[5];
endmodule

module gf_mult_by_1e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[4]^i[5];
  assign o[3] = i[0]^i[1]^i[2]^i[4]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[5] = i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[6] = i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[7] = i[3]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_1f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[4]^i[5];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[5] = i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[6] = i[2]^i[3]^i[4]^i[5];
  assign o[7] = i[3]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_20 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[7];
  assign o[1] = i[4];
  assign o[2] = i[3]^i[5]^i[7];
  assign o[3] = i[3]^i[4]^i[6]^i[7];
  assign o[4] = i[3]^i[4]^i[5];
  assign o[5] = i[0]^i[4]^i[5]^i[6];
  assign o[6] = i[1]^i[5]^i[6]^i[7];
  assign o[7] = i[2]^i[6]^i[7];
endmodule

module gf_mult_by_21 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[7];
  assign o[1] = i[1]^i[4];
  assign o[2] = i[2]^i[3]^i[5]^i[7];
  assign o[3] = i[4]^i[6]^i[7];
  assign o[4] = i[3]^i[5];
  assign o[5] = i[0]^i[4]^i[6];
  assign o[6] = i[1]^i[5]^i[7];
  assign o[7] = i[2]^i[6];
endmodule

module gf_mult_by_22 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3];
  assign o[1] = i[0]^i[4];
  assign o[2] = i[1]^i[3]^i[5];
  assign o[3] = i[2]^i[3]^i[4]^i[6];
  assign o[4] = i[4]^i[5]^i[7];
  assign o[5] = i[0]^i[5]^i[6];
  assign o[6] = i[1]^i[6]^i[7];
  assign o[7] = i[2]^i[7];
endmodule

module gf_mult_by_23 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3];
  assign o[1] = i[0]^i[1]^i[4];
  assign o[2] = i[1]^i[2]^i[3]^i[5];
  assign o[3] = i[2]^i[4]^i[6];
  assign o[4] = i[5]^i[7];
  assign o[5] = i[0]^i[6];
  assign o[6] = i[1]^i[7];
  assign o[7] = i[2];
endmodule

module gf_mult_by_24 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[6]^i[7];
  assign o[1] = i[4]^i[7];
  assign o[2] = i[0]^i[3]^i[5]^i[6]^i[7];
  assign o[3] = i[1]^i[3]^i[4];
  assign o[4] = i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[2]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_25 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[6]^i[7];
  assign o[1] = i[1]^i[4]^i[7];
  assign o[2] = i[0]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[3] = i[1]^i[4];
  assign o[4] = i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[3]^i[4]^i[6]^i[7];
  assign o[6] = i[1]^i[4]^i[5]^i[7];
  assign o[7] = i[2]^i[5]^i[6];
endmodule

module gf_mult_by_26 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[6];
  assign o[1] = i[0]^i[4]^i[7];
  assign o[2] = i[0]^i[1]^i[3]^i[5]^i[6];
  assign o[3] = i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[4] = i[2]^i[4]^i[5]^i[6];
  assign o[5] = i[0]^i[3]^i[5]^i[6]^i[7];
  assign o[6] = i[1]^i[4]^i[6]^i[7];
  assign o[7] = i[2]^i[5]^i[7];
endmodule

module gf_mult_by_27 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[6];
  assign o[1] = i[0]^i[1]^i[4]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[3] = i[1]^i[2]^i[4]^i[7];
  assign o[4] = i[2]^i[5]^i[6];
  assign o[5] = i[0]^i[3]^i[6]^i[7];
  assign o[6] = i[1]^i[4]^i[7];
  assign o[7] = i[2]^i[5];
endmodule

module gf_mult_by_28 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[5]^i[7];
  assign o[1] = i[4]^i[6];
  assign o[2] = i[3];
  assign o[3] = i[0]^i[3]^i[4]^i[5]^i[7];
  assign o[4] = i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[5] = i[0]^i[2]^i[4]^i[5]^i[7];
  assign o[6] = i[1]^i[3]^i[5]^i[6];
  assign o[7] = i[2]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_29 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[5]^i[7];
  assign o[1] = i[1]^i[4]^i[6];
  assign o[2] = i[2]^i[3];
  assign o[3] = i[0]^i[4]^i[5]^i[7];
  assign o[4] = i[1]^i[3]^i[6]^i[7];
  assign o[5] = i[0]^i[2]^i[4]^i[7];
  assign o[6] = i[1]^i[3]^i[5];
  assign o[7] = i[2]^i[4]^i[6];
endmodule

module gf_mult_by_2a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[5];
  assign o[1] = i[0]^i[4]^i[6];
  assign o[2] = i[1]^i[3]^i[7];
  assign o[3] = i[0]^i[2]^i[3]^i[4]^i[5];
  assign o[4] = i[1]^i[4]^i[6];
  assign o[5] = i[0]^i[2]^i[5]^i[7];
  assign o[6] = i[1]^i[3]^i[6];
  assign o[7] = i[2]^i[4]^i[7];
endmodule

module gf_mult_by_2b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[5];
  assign o[1] = i[0]^i[1]^i[4]^i[6];
  assign o[2] = i[1]^i[2]^i[3]^i[7];
  assign o[3] = i[0]^i[2]^i[4]^i[5];
  assign o[4] = i[1]^i[6];
  assign o[5] = i[0]^i[2]^i[7];
  assign o[6] = i[1]^i[3];
  assign o[7] = i[2]^i[4];
endmodule

module gf_mult_by_2c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[5]^i[6]^i[7];
  assign o[1] = i[4]^i[6]^i[7];
  assign o[2] = i[0]^i[3]^i[6];
  assign o[3] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[4] = i[1]^i[2]^i[3]^i[4];
  assign o[5] = i[0]^i[2]^i[3]^i[4]^i[5];
  assign o[6] = i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[7] = i[2]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_2d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[5]^i[6]^i[7];
  assign o[1] = i[1]^i[4]^i[6]^i[7];
  assign o[2] = i[0]^i[2]^i[3]^i[6];
  assign o[3] = i[0]^i[1]^i[4]^i[5]^i[6];
  assign o[4] = i[1]^i[2]^i[3];
  assign o[5] = i[0]^i[2]^i[3]^i[4];
  assign o[6] = i[1]^i[3]^i[4]^i[5];
  assign o[7] = i[2]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_2e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[5]^i[6];
  assign o[1] = i[0]^i[4]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[3]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[1]^i[2]^i[4]^i[7];
  assign o[5] = i[0]^i[2]^i[3]^i[5];
  assign o[6] = i[1]^i[3]^i[4]^i[6];
  assign o[7] = i[2]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_2f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[5]^i[6];
  assign o[1] = i[0]^i[1]^i[4]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[1]^i[2]^i[7];
  assign o[5] = i[0]^i[2]^i[3];
  assign o[6] = i[1]^i[3]^i[4];
  assign o[7] = i[2]^i[4]^i[5];
endmodule

module gf_mult_by_30 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[4]^i[7];
  assign o[1] = i[4]^i[5];
  assign o[2] = i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[3]^i[5]^i[6];
  assign o[4] = i[0]^i[3]^i[6];
  assign o[5] = i[0]^i[1]^i[4]^i[7];
  assign o[6] = i[1]^i[2]^i[5];
  assign o[7] = i[2]^i[3]^i[6];
endmodule

module gf_mult_by_31 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[4]^i[7];
  assign o[1] = i[1]^i[4]^i[5];
  assign o[2] = i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[5]^i[6];
  assign o[4] = i[0]^i[3]^i[4]^i[6];
  assign o[5] = i[0]^i[1]^i[4]^i[5]^i[7];
  assign o[6] = i[1]^i[2]^i[5]^i[6];
  assign o[7] = i[2]^i[3]^i[6]^i[7];
endmodule

module gf_mult_by_32 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[4];
  assign o[1] = i[0]^i[4]^i[5];
  assign o[2] = i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[3] = i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[7];
  assign o[6] = i[1]^i[2];
  assign o[7] = i[2]^i[3];
endmodule

module gf_mult_by_33 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[4];
  assign o[1] = i[0]^i[1]^i[4]^i[5];
  assign o[2] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[3] = i[2]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[4]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[5]^i[7];
  assign o[6] = i[1]^i[2]^i[6];
  assign o[7] = i[2]^i[3]^i[7];
endmodule

module gf_mult_by_34 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[4]^i[6]^i[7];
  assign o[1] = i[4]^i[5]^i[7];
  assign o[2] = i[0]^i[3]^i[4]^i[5]^i[7];
  assign o[3] = i[1]^i[3]^i[5]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[7];
  assign o[5] = i[0]^i[1]^i[3]^i[4];
  assign o[6] = i[1]^i[2]^i[4]^i[5];
  assign o[7] = i[2]^i[3]^i[5]^i[6];
endmodule

module gf_mult_by_35 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[4]^i[6]^i[7];
  assign o[1] = i[1]^i[4]^i[5]^i[7];
  assign o[2] = i[0]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[3] = i[1]^i[5]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[4]^i[7];
  assign o[5] = i[0]^i[1]^i[3]^i[4]^i[5];
  assign o[6] = i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[7] = i[2]^i[3]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_36 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[4]^i[6];
  assign o[1] = i[0]^i[4]^i[5]^i[7];
  assign o[2] = i[0]^i[1]^i[3]^i[4]^i[5];
  assign o[3] = i[1]^i[2]^i[3]^i[5];
  assign o[4] = i[0]^i[2];
  assign o[5] = i[0]^i[1]^i[3];
  assign o[6] = i[1]^i[2]^i[4];
  assign o[7] = i[2]^i[3]^i[5];
endmodule

module gf_mult_by_37 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[4]^i[6];
  assign o[1] = i[0]^i[1]^i[4]^i[5]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[3] = i[1]^i[2]^i[5];
  assign o[4] = i[0]^i[2]^i[4];
  assign o[5] = i[0]^i[1]^i[3]^i[5];
  assign o[6] = i[1]^i[2]^i[4]^i[6];
  assign o[7] = i[2]^i[3]^i[5]^i[7];
endmodule

module gf_mult_by_38 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[4]^i[5]^i[7];
  assign o[1] = i[4]^i[5]^i[6];
  assign o[2] = i[3]^i[4]^i[6];
  assign o[3] = i[0]^i[3];
  assign o[4] = i[0]^i[1]^i[3]^i[5]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[4]^i[6];
  assign o[6] = i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[7] = i[2]^i[3]^i[4]^i[6];
endmodule

module gf_mult_by_39 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[4]^i[5]^i[7];
  assign o[1] = i[1]^i[4]^i[5]^i[6];
  assign o[2] = i[2]^i[3]^i[4]^i[6];
  assign o[3] = i[0];
  assign o[4] = i[0]^i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[6] = i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[7] = i[2]^i[3]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_3a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[4]^i[5];
  assign o[1] = i[0]^i[4]^i[5]^i[6];
  assign o[2] = i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[3] = i[0]^i[2]^i[3]^i[7];
  assign o[4] = i[0]^i[1]^i[5];
  assign o[5] = i[0]^i[1]^i[2]^i[6];
  assign o[6] = i[1]^i[2]^i[3]^i[7];
  assign o[7] = i[2]^i[3]^i[4];
endmodule

module gf_mult_by_3b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[4]^i[5];
  assign o[1] = i[0]^i[1]^i[4]^i[5]^i[6];
  assign o[2] = i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[3] = i[0]^i[2]^i[7];
  assign o[4] = i[0]^i[1]^i[4]^i[5];
  assign o[5] = i[0]^i[1]^i[2]^i[5]^i[6];
  assign o[6] = i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[7] = i[2]^i[3]^i[4]^i[7];
endmodule

module gf_mult_by_3c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[3]^i[4];
  assign o[3] = i[0]^i[1]^i[3]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[6] = i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[7] = i[2]^i[3]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_3d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[2]^i[3]^i[4];
  assign o[3] = i[0]^i[1]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_3e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[3]^i[4]^i[5]^i[6];
  assign o[1] = i[0]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[3]^i[4]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[6];
  assign o[4] = i[0]^i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[6] = i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[7] = i[2]^i[3]^i[4]^i[5];
endmodule

module gf_mult_by_3f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[3]^i[4]^i[5]^i[6];
  assign o[1] = i[0]^i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[6];
  assign o[4] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[6] = i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[7] = i[2]^i[3]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_40 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[6]^i[7];
  assign o[1] = i[3]^i[7];
  assign o[2] = i[2]^i[4]^i[6]^i[7];
  assign o[3] = i[2]^i[3]^i[5]^i[6];
  assign o[4] = i[2]^i[3]^i[4];
  assign o[5] = i[3]^i[4]^i[5];
  assign o[6] = i[0]^i[4]^i[5]^i[6];
  assign o[7] = i[1]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_41 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[6]^i[7];
  assign o[1] = i[1]^i[3]^i[7];
  assign o[2] = i[4]^i[6]^i[7];
  assign o[3] = i[2]^i[5]^i[6];
  assign o[4] = i[2]^i[3];
  assign o[5] = i[3]^i[4];
  assign o[6] = i[0]^i[4]^i[5];
  assign o[7] = i[1]^i[5]^i[6];
endmodule

module gf_mult_by_42 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[6];
  assign o[1] = i[0]^i[3]^i[7];
  assign o[2] = i[1]^i[2]^i[4]^i[6];
  assign o[3] = i[3]^i[5]^i[6]^i[7];
  assign o[4] = i[2]^i[4]^i[7];
  assign o[5] = i[3]^i[5];
  assign o[6] = i[0]^i[4]^i[6];
  assign o[7] = i[1]^i[5]^i[7];
endmodule

module gf_mult_by_43 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[6];
  assign o[1] = i[0]^i[1]^i[3]^i[7];
  assign o[2] = i[1]^i[4]^i[6];
  assign o[3] = i[5]^i[6]^i[7];
  assign o[4] = i[2]^i[7];
  assign o[5] = i[3];
  assign o[6] = i[0]^i[4];
  assign o[7] = i[1]^i[5];
endmodule

module gf_mult_by_44 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[7];
  assign o[1] = i[3];
  assign o[2] = i[0]^i[2]^i[4]^i[7];
  assign o[3] = i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[4] = i[3]^i[4]^i[6]^i[7];
  assign o[5] = i[4]^i[5]^i[7];
  assign o[6] = i[0]^i[5]^i[6];
  assign o[7] = i[1]^i[6]^i[7];
endmodule

module gf_mult_by_45 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[7];
  assign o[1] = i[1]^i[3];
  assign o[2] = i[0]^i[4]^i[7];
  assign o[3] = i[1]^i[2]^i[5]^i[7];
  assign o[4] = i[3]^i[6]^i[7];
  assign o[5] = i[4]^i[7];
  assign o[6] = i[0]^i[5];
  assign o[7] = i[1]^i[6];
endmodule

module gf_mult_by_46 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2];
  assign o[1] = i[0]^i[3];
  assign o[2] = i[0]^i[1]^i[2]^i[4];
  assign o[3] = i[1]^i[3]^i[5];
  assign o[4] = i[4]^i[6];
  assign o[5] = i[5]^i[7];
  assign o[6] = i[0]^i[6];
  assign o[7] = i[1]^i[7];
endmodule

module gf_mult_by_47 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2];
  assign o[1] = i[0]^i[1]^i[3];
  assign o[2] = i[0]^i[1]^i[4];
  assign o[3] = i[1]^i[5];
  assign o[4] = i[6];
  assign o[5] = i[7];
  assign o[6] = i[0];
  assign o[7] = i[1];
endmodule

module gf_mult_by_48 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[5]^i[6]^i[7];
  assign o[1] = i[3]^i[6]^i[7];
  assign o[2] = i[2]^i[4]^i[5]^i[6];
  assign o[3] = i[0]^i[2]^i[3];
  assign o[4] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[1]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_49 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[5]^i[6]^i[7];
  assign o[1] = i[1]^i[3]^i[6]^i[7];
  assign o[2] = i[4]^i[5]^i[6];
  assign o[3] = i[0]^i[2];
  assign o[4] = i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[5] = i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[6] = i[0]^i[3]^i[4]^i[5]^i[7];
  assign o[7] = i[1]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_4a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[5]^i[6];
  assign o[1] = i[0]^i[3]^i[6]^i[7];
  assign o[2] = i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[3]^i[7];
  assign o[4] = i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[5] = i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[3]^i[4]^i[6]^i[7];
  assign o[7] = i[1]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_4b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[5]^i[6];
  assign o[1] = i[0]^i[1]^i[3]^i[6]^i[7];
  assign o[2] = i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[7];
  assign o[4] = i[1]^i[2]^i[5]^i[6];
  assign o[5] = i[2]^i[3]^i[6]^i[7];
  assign o[6] = i[0]^i[3]^i[4]^i[7];
  assign o[7] = i[1]^i[4]^i[5];
endmodule

module gf_mult_by_4c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[5]^i[7];
  assign o[1] = i[3]^i[6];
  assign o[2] = i[0]^i[2]^i[4]^i[5];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[4] = i[1]^i[3]^i[4]^i[5];
  assign o[5] = i[2]^i[4]^i[5]^i[6];
  assign o[6] = i[0]^i[3]^i[5]^i[6]^i[7];
  assign o[7] = i[1]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_4d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[5]^i[7];
  assign o[1] = i[1]^i[3]^i[6];
  assign o[2] = i[0]^i[4]^i[5];
  assign o[3] = i[0]^i[1]^i[2]^i[6]^i[7];
  assign o[4] = i[1]^i[3]^i[5];
  assign o[5] = i[2]^i[4]^i[6];
  assign o[6] = i[0]^i[3]^i[5]^i[7];
  assign o[7] = i[1]^i[4]^i[6];
endmodule

module gf_mult_by_4e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[5];
  assign o[1] = i[0]^i[3]^i[6];
  assign o[2] = i[0]^i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[3] = i[0]^i[1]^i[3]^i[6];
  assign o[4] = i[1]^i[4]^i[5]^i[7];
  assign o[5] = i[2]^i[5]^i[6];
  assign o[6] = i[0]^i[3]^i[6]^i[7];
  assign o[7] = i[1]^i[4]^i[7];
endmodule

module gf_mult_by_4f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[5];
  assign o[1] = i[0]^i[1]^i[3]^i[6];
  assign o[2] = i[0]^i[1]^i[4]^i[5]^i[7];
  assign o[3] = i[0]^i[1]^i[6];
  assign o[4] = i[1]^i[5]^i[7];
  assign o[5] = i[2]^i[6];
  assign o[6] = i[0]^i[3]^i[7];
  assign o[7] = i[1]^i[4];
endmodule

module gf_mult_by_50 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[4]^i[6]^i[7];
  assign o[1] = i[3]^i[5]^i[7];
  assign o[2] = i[2]^i[7];
  assign o[3] = i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[5]^i[6];
  assign o[5] = i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[6] = i[0]^i[2]^i[4]^i[5]^i[7];
  assign o[7] = i[1]^i[3]^i[5]^i[6];
endmodule

module gf_mult_by_51 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[4]^i[6]^i[7];
  assign o[1] = i[1]^i[3]^i[5]^i[7];
  assign o[2] = i[7];
  assign o[3] = i[2]^i[4]^i[6]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[5] = i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[1]^i[3]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_52 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[4]^i[6];
  assign o[1] = i[0]^i[3]^i[5]^i[7];
  assign o[2] = i[1]^i[2];
  assign o[3] = i[3]^i[4]^i[6];
  assign o[4] = i[0]^i[2]^i[5]^i[6]^i[7];
  assign o[5] = i[1]^i[3]^i[6]^i[7];
  assign o[6] = i[0]^i[2]^i[4]^i[7];
  assign o[7] = i[1]^i[3]^i[5];
endmodule

module gf_mult_by_53 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[4]^i[6];
  assign o[1] = i[0]^i[1]^i[3]^i[5]^i[7];
  assign o[2] = i[1];
  assign o[3] = i[4]^i[6];
  assign o[4] = i[0]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[2]^i[4]^i[6]^i[7];
  assign o[7] = i[1]^i[3]^i[5]^i[7];
endmodule

module gf_mult_by_54 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[4]^i[7];
  assign o[1] = i[3]^i[5];
  assign o[2] = i[0]^i[2]^i[6]^i[7];
  assign o[3] = i[1]^i[2]^i[3]^i[4];
  assign o[4] = i[0]^i[3]^i[5]^i[7];
  assign o[5] = i[1]^i[4]^i[6];
  assign o[6] = i[0]^i[2]^i[5]^i[7];
  assign o[7] = i[1]^i[3]^i[6];
endmodule

module gf_mult_by_55 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[4]^i[7];
  assign o[1] = i[1]^i[3]^i[5];
  assign o[2] = i[0]^i[6]^i[7];
  assign o[3] = i[1]^i[2]^i[4];
  assign o[4] = i[0]^i[3]^i[4]^i[5]^i[7];
  assign o[5] = i[1]^i[4]^i[5]^i[6];
  assign o[6] = i[0]^i[2]^i[5]^i[6]^i[7];
  assign o[7] = i[1]^i[3]^i[6]^i[7];
endmodule

module gf_mult_by_56 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[4];
  assign o[1] = i[0]^i[3]^i[5];
  assign o[2] = i[0]^i[1]^i[2]^i[6];
  assign o[3] = i[1]^i[3]^i[4]^i[7];
  assign o[4] = i[0]^i[5];
  assign o[5] = i[1]^i[6];
  assign o[6] = i[0]^i[2]^i[7];
  assign o[7] = i[1]^i[3];
endmodule

module gf_mult_by_57 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[4];
  assign o[1] = i[0]^i[1]^i[3]^i[5];
  assign o[2] = i[0]^i[1]^i[6];
  assign o[3] = i[1]^i[4]^i[7];
  assign o[4] = i[0]^i[4]^i[5];
  assign o[5] = i[1]^i[5]^i[6];
  assign o[6] = i[0]^i[2]^i[6]^i[7];
  assign o[7] = i[1]^i[3]^i[7];
endmodule

module gf_mult_by_58 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[3]^i[5]^i[6]^i[7];
  assign o[2] = i[2]^i[5];
  assign o[3] = i[0]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[7];
  assign o[5] = i[1]^i[2]^i[3]^i[4];
  assign o[6] = i[0]^i[2]^i[3]^i[4]^i[5];
  assign o[7] = i[1]^i[3]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_59 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[2] = i[5];
  assign o[3] = i[0]^i[2]^i[4]^i[5]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[5] = i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[6] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[7] = i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_5a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[4]^i[5]^i[6];
  assign o[1] = i[0]^i[3]^i[5]^i[6]^i[7];
  assign o[2] = i[1]^i[2]^i[5]^i[7];
  assign o[3] = i[0]^i[3]^i[4]^i[5];
  assign o[4] = i[0]^i[1]^i[2];
  assign o[5] = i[1]^i[2]^i[3];
  assign o[6] = i[0]^i[2]^i[3]^i[4];
  assign o[7] = i[1]^i[3]^i[4]^i[5];
endmodule

module gf_mult_by_5b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[4]^i[5]^i[6];
  assign o[1] = i[0]^i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[2] = i[1]^i[5]^i[7];
  assign o[3] = i[0]^i[4]^i[5];
  assign o[4] = i[0]^i[1]^i[2]^i[4];
  assign o[5] = i[1]^i[2]^i[3]^i[5];
  assign o[6] = i[0]^i[2]^i[3]^i[4]^i[6];
  assign o[7] = i[1]^i[3]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_5c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[4]^i[5]^i[7];
  assign o[1] = i[3]^i[5]^i[6];
  assign o[2] = i[0]^i[2]^i[5]^i[6];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[4] = i[0]^i[1]^i[3]^i[6];
  assign o[5] = i[1]^i[2]^i[4]^i[7];
  assign o[6] = i[0]^i[2]^i[3]^i[5];
  assign o[7] = i[1]^i[3]^i[4]^i[6];
endmodule

module gf_mult_by_5d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[4]^i[5]^i[7];
  assign o[1] = i[1]^i[3]^i[5]^i[6];
  assign o[2] = i[0]^i[5]^i[6];
  assign o[3] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[4] = i[0]^i[1]^i[3]^i[4]^i[6];
  assign o[5] = i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[6] = i[0]^i[2]^i[3]^i[5]^i[6];
  assign o[7] = i[1]^i[3]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_5e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[4]^i[5];
  assign o[1] = i[0]^i[3]^i[5]^i[6];
  assign o[2] = i[0]^i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[6]^i[7];
  assign o[5] = i[1]^i[2]^i[7];
  assign o[6] = i[0]^i[2]^i[3];
  assign o[7] = i[1]^i[3]^i[4];
endmodule

module gf_mult_by_5f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[4]^i[5];
  assign o[1] = i[0]^i[1]^i[3]^i[5]^i[6];
  assign o[2] = i[0]^i[1]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[4]^i[6]^i[7];
  assign o[5] = i[1]^i[2]^i[5]^i[7];
  assign o[6] = i[0]^i[2]^i[3]^i[6];
  assign o[7] = i[1]^i[3]^i[4]^i[7];
endmodule

module gf_mult_by_60 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[6];
  assign o[1] = i[3]^i[4]^i[7];
  assign o[2] = i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[3] = i[2]^i[4]^i[5]^i[7];
  assign o[4] = i[2]^i[5];
  assign o[5] = i[0]^i[3]^i[6];
  assign o[6] = i[0]^i[1]^i[4]^i[7];
  assign o[7] = i[1]^i[2]^i[5];
endmodule

module gf_mult_by_61 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[6];
  assign o[1] = i[1]^i[3]^i[4]^i[7];
  assign o[2] = i[3]^i[4]^i[5]^i[6];
  assign o[3] = i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[4] = i[2]^i[4]^i[5];
  assign o[5] = i[0]^i[3]^i[5]^i[6];
  assign o[6] = i[0]^i[1]^i[4]^i[6]^i[7];
  assign o[7] = i[1]^i[2]^i[5]^i[7];
endmodule

module gf_mult_by_62 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[6]^i[7];
  assign o[1] = i[0]^i[3]^i[4]^i[7];
  assign o[2] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[4]^i[5];
  assign o[4] = i[2]^i[3]^i[5]^i[7];
  assign o[5] = i[0]^i[3]^i[4]^i[6];
  assign o[6] = i[0]^i[1]^i[4]^i[5]^i[7];
  assign o[7] = i[1]^i[2]^i[5]^i[6];
endmodule

module gf_mult_by_63 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[3]^i[4]^i[7];
  assign o[2] = i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[3]^i[4]^i[5];
  assign o[4] = i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[5] = i[0]^i[3]^i[4]^i[5]^i[6];
  assign o[6] = i[0]^i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[1]^i[2]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_64 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3];
  assign o[1] = i[3]^i[4];
  assign o[2] = i[0]^i[2]^i[3]^i[4]^i[5];
  assign o[3] = i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[4] = i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[7];
  assign o[7] = i[1]^i[2];
endmodule

module gf_mult_by_65 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3];
  assign o[1] = i[1]^i[3]^i[4];
  assign o[2] = i[0]^i[3]^i[4]^i[5];
  assign o[3] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[4] = i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[6]^i[7];
  assign o[7] = i[1]^i[2]^i[7];
endmodule

module gf_mult_by_66 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[7];
  assign o[1] = i[0]^i[3]^i[4];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[3] = i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[3]^i[5]^i[6];
  assign o[5] = i[0]^i[4]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[5]^i[7];
  assign o[7] = i[1]^i[2]^i[6];
endmodule

module gf_mult_by_67 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[7];
  assign o[1] = i[0]^i[1]^i[3]^i[4];
  assign o[2] = i[0]^i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[3] = i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[3]^i[4]^i[5]^i[6];
  assign o[5] = i[0]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[5]^i[6]^i[7];
  assign o[7] = i[1]^i[2]^i[6]^i[7];
endmodule

module gf_mult_by_68 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[5]^i[6];
  assign o[1] = i[3]^i[4]^i[6]^i[7];
  assign o[2] = i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[3] = i[0]^i[2]^i[4]^i[6]^i[7];
  assign o[4] = i[1]^i[2]^i[6]^i[7];
  assign o[5] = i[0]^i[2]^i[3]^i[7];
  assign o[6] = i[0]^i[1]^i[3]^i[4];
  assign o[7] = i[1]^i[2]^i[4]^i[5];
endmodule

module gf_mult_by_69 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[5]^i[6];
  assign o[1] = i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[2] = i[3]^i[4]^i[6]^i[7];
  assign o[3] = i[0]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[4] = i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[5] = i[0]^i[2]^i[3]^i[5]^i[7];
  assign o[6] = i[0]^i[1]^i[3]^i[4]^i[6];
  assign o[7] = i[1]^i[2]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_6a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[3]^i[4]^i[6]^i[7];
  assign o[2] = i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[3] = i[0]^i[4]^i[6];
  assign o[4] = i[1]^i[2]^i[3]^i[6];
  assign o[5] = i[0]^i[2]^i[3]^i[4]^i[7];
  assign o[6] = i[0]^i[1]^i[3]^i[4]^i[5];
  assign o[7] = i[1]^i[2]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_6b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[2] = i[1]^i[3]^i[4]^i[6];
  assign o[3] = i[0]^i[3]^i[4]^i[6];
  assign o[4] = i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[5] = i[0]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[6] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[7] = i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_6c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[5];
  assign o[1] = i[3]^i[4]^i[6];
  assign o[2] = i[0]^i[2]^i[3]^i[4]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[4];
  assign o[4] = i[1];
  assign o[5] = i[0]^i[2];
  assign o[6] = i[0]^i[1]^i[3];
  assign o[7] = i[1]^i[2]^i[4];
endmodule

module gf_mult_by_6d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[5];
  assign o[1] = i[1]^i[3]^i[4]^i[6];
  assign o[2] = i[0]^i[3]^i[4]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[4];
  assign o[4] = i[1]^i[4];
  assign o[5] = i[0]^i[2]^i[5];
  assign o[6] = i[0]^i[1]^i[3]^i[6];
  assign o[7] = i[1]^i[2]^i[4]^i[7];
endmodule

module gf_mult_by_6e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[5]^i[7];
  assign o[1] = i[0]^i[3]^i[4]^i[6];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[4];
  assign o[3] = i[0]^i[1]^i[4]^i[7];
  assign o[4] = i[1]^i[3]^i[7];
  assign o[5] = i[0]^i[2]^i[4];
  assign o[6] = i[0]^i[1]^i[3]^i[5];
  assign o[7] = i[1]^i[2]^i[4]^i[6];
endmodule

module gf_mult_by_6f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[5]^i[7];
  assign o[1] = i[0]^i[1]^i[3]^i[4]^i[6];
  assign o[2] = i[0]^i[1]^i[3]^i[4];
  assign o[3] = i[0]^i[1]^i[3]^i[4]^i[7];
  assign o[4] = i[1]^i[3]^i[4]^i[7];
  assign o[5] = i[0]^i[2]^i[4]^i[5];
  assign o[6] = i[0]^i[1]^i[3]^i[5]^i[6];
  assign o[7] = i[1]^i[2]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_70 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[4]^i[6];
  assign o[1] = i[3]^i[4]^i[5]^i[7];
  assign o[2] = i[2]^i[3]^i[5];
  assign o[3] = i[2];
  assign o[4] = i[0]^i[2]^i[4]^i[6];
  assign o[5] = i[0]^i[1]^i[3]^i[5]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[4]^i[6];
  assign o[7] = i[1]^i[2]^i[3]^i[5]^i[7];
endmodule

module gf_mult_by_71 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[4]^i[6];
  assign o[1] = i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[2] = i[3]^i[5];
  assign o[3] = i[2]^i[3];
  assign o[4] = i[0]^i[2]^i[6];
  assign o[5] = i[0]^i[1]^i[3]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[4];
  assign o[7] = i[1]^i[2]^i[3]^i[5];
endmodule

module gf_mult_by_72 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[1] = i[0]^i[3]^i[4]^i[5]^i[7];
  assign o[2] = i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[3] = i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[7] = i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_73 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[2] = i[1]^i[3]^i[5]^i[7];
  assign o[3] = i[3]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[3]^i[4]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[4]^i[5];
  assign o[7] = i[1]^i[2]^i[3]^i[5]^i[6];
endmodule

module gf_mult_by_74 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[4];
  assign o[1] = i[3]^i[4]^i[5];
  assign o[2] = i[0]^i[2]^i[3]^i[5]^i[6];
  assign o[3] = i[1]^i[2]^i[6]^i[7];
  assign o[4] = i[0]^i[4]^i[7];
  assign o[5] = i[0]^i[1]^i[5];
  assign o[6] = i[0]^i[1]^i[2]^i[6];
  assign o[7] = i[1]^i[2]^i[3]^i[7];
endmodule

module gf_mult_by_75 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[4];
  assign o[1] = i[1]^i[3]^i[4]^i[5];
  assign o[2] = i[0]^i[3]^i[5]^i[6];
  assign o[3] = i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[4] = i[0]^i[7];
  assign o[5] = i[0]^i[1];
  assign o[6] = i[0]^i[1]^i[2];
  assign o[7] = i[1]^i[2]^i[3];
endmodule

module gf_mult_by_76 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[4]^i[7];
  assign o[1] = i[0]^i[3]^i[4]^i[5];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[3] = i[1]^i[6];
  assign o[4] = i[0]^i[3]^i[4];
  assign o[5] = i[0]^i[1]^i[4]^i[5];
  assign o[6] = i[0]^i[1]^i[2]^i[5]^i[6];
  assign o[7] = i[1]^i[2]^i[3]^i[6]^i[7];
endmodule

module gf_mult_by_77 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[4]^i[7];
  assign o[1] = i[0]^i[1]^i[3]^i[4]^i[5];
  assign o[2] = i[0]^i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[3] = i[1]^i[3]^i[6];
  assign o[4] = i[0]^i[3];
  assign o[5] = i[0]^i[1]^i[4];
  assign o[6] = i[0]^i[1]^i[2]^i[5];
  assign o[7] = i[1]^i[2]^i[3]^i[6];
endmodule

module gf_mult_by_78 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[1] = i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[2]^i[3]^i[7];
  assign o[3] = i[0]^i[2]^i[5]^i[6];
  assign o[4] = i[0]^i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[7] = i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_79 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[1] = i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[3]^i[7];
  assign o[3] = i[0]^i[2]^i[3]^i[5]^i[6];
  assign o[4] = i[0]^i[1]^i[2]^i[5]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[6];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[7] = i[1]^i[2]^i[3]^i[4]^i[5];
endmodule

module gf_mult_by_7a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[1]^i[2]^i[3];
  assign o[3] = i[0]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_7b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[1]^i[3];
  assign o[3] = i[0]^i[3]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[5];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[7] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_7c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[4]^i[5];
  assign o[1] = i[3]^i[4]^i[5]^i[6];
  assign o[2] = i[0]^i[2]^i[3]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[5]^i[7];
  assign o[4] = i[0]^i[1]^i[4]^i[5]^i[6];
  assign o[5] = i[0]^i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[7] = i[1]^i[2]^i[3]^i[4]^i[7];
endmodule

module gf_mult_by_7d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[4]^i[5];
  assign o[1] = i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[2] = i[0]^i[3]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[4] = i[0]^i[1]^i[5]^i[6];
  assign o[5] = i[0]^i[1]^i[2]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[7];
  assign o[7] = i[1]^i[2]^i[3]^i[4];
endmodule

module gf_mult_by_7e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[1] = i[0]^i[3]^i[4]^i[5]^i[6];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[6];
  assign o[3] = i[0]^i[1]^i[5];
  assign o[4] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[7] = i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_7f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[1] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[2] = i[0]^i[1]^i[3]^i[6];
  assign o[3] = i[0]^i[1]^i[3]^i[5];
  assign o[4] = i[0]^i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[7] = i[1]^i[2]^i[3]^i[4]^i[6];
endmodule

module gf_mult_by_80 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[5]^i[6]^i[7];
  assign o[1] = i[2]^i[6]^i[7];
  assign o[2] = i[1]^i[3]^i[5]^i[6];
  assign o[3] = i[1]^i[2]^i[4]^i[5];
  assign o[4] = i[1]^i[2]^i[3]^i[7];
  assign o[5] = i[2]^i[3]^i[4];
  assign o[6] = i[3]^i[4]^i[5];
  assign o[7] = i[0]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_81 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[5]^i[6]^i[7];
  assign o[1] = i[1]^i[2]^i[6]^i[7];
  assign o[2] = i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[3] = i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[4] = i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[5] = i[2]^i[3]^i[4]^i[5];
  assign o[6] = i[3]^i[4]^i[5]^i[6];
  assign o[7] = i[0]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_82 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[5]^i[6];
  assign o[1] = i[0]^i[2]^i[6]^i[7];
  assign o[2] = i[3]^i[5]^i[6]^i[7];
  assign o[3] = i[1]^i[4]^i[5]^i[7];
  assign o[4] = i[1]^i[2];
  assign o[5] = i[2]^i[3];
  assign o[6] = i[3]^i[4];
  assign o[7] = i[0]^i[4]^i[5];
endmodule

module gf_mult_by_83 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[5]^i[6];
  assign o[1] = i[0]^i[1]^i[2]^i[6]^i[7];
  assign o[2] = i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[3] = i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[4] = i[1]^i[2]^i[4];
  assign o[5] = i[2]^i[3]^i[5];
  assign o[6] = i[3]^i[4]^i[6];
  assign o[7] = i[0]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_84 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[5]^i[7];
  assign o[1] = i[2]^i[6];
  assign o[2] = i[0]^i[1]^i[3]^i[5];
  assign o[3] = i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[1]^i[3]^i[6];
  assign o[5] = i[2]^i[4]^i[7];
  assign o[6] = i[3]^i[5];
  assign o[7] = i[0]^i[4]^i[6];
endmodule

module gf_mult_by_85 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[5]^i[7];
  assign o[1] = i[1]^i[2]^i[6];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[5];
  assign o[3] = i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[1]^i[3]^i[4]^i[6];
  assign o[5] = i[2]^i[4]^i[5]^i[7];
  assign o[6] = i[3]^i[5]^i[6];
  assign o[7] = i[0]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_86 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[5];
  assign o[1] = i[0]^i[2]^i[6];
  assign o[2] = i[0]^i[3]^i[5]^i[7];
  assign o[3] = i[4]^i[5]^i[6];
  assign o[4] = i[1]^i[6]^i[7];
  assign o[5] = i[2]^i[7];
  assign o[6] = i[3];
  assign o[7] = i[0]^i[4];
endmodule

module gf_mult_by_87 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[5];
  assign o[1] = i[0]^i[1]^i[2]^i[6];
  assign o[2] = i[0]^i[2]^i[3]^i[5]^i[7];
  assign o[3] = i[3]^i[4]^i[5]^i[6];
  assign o[4] = i[1]^i[4]^i[6]^i[7];
  assign o[5] = i[2]^i[5]^i[7];
  assign o[6] = i[3]^i[6];
  assign o[7] = i[0]^i[4]^i[7];
endmodule

module gf_mult_by_88 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[6]^i[7];
  assign o[1] = i[2]^i[7];
  assign o[2] = i[1]^i[3]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[4]^i[6];
  assign o[4] = i[2]^i[3]^i[5]^i[6];
  assign o[5] = i[3]^i[4]^i[6]^i[7];
  assign o[6] = i[4]^i[5]^i[7];
  assign o[7] = i[0]^i[5]^i[6];
endmodule

module gf_mult_by_89 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[6]^i[7];
  assign o[1] = i[1]^i[2]^i[7];
  assign o[2] = i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[4] = i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[5] = i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_8a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[6];
  assign o[1] = i[0]^i[2]^i[7];
  assign o[2] = i[3]^i[6];
  assign o[3] = i[0]^i[1]^i[4]^i[6]^i[7];
  assign o[4] = i[2]^i[5]^i[6]^i[7];
  assign o[5] = i[3]^i[6]^i[7];
  assign o[6] = i[4]^i[7];
  assign o[7] = i[0]^i[5];
endmodule

module gf_mult_by_8b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[6];
  assign o[1] = i[0]^i[1]^i[2]^i[7];
  assign o[2] = i[2]^i[3]^i[6];
  assign o[3] = i[0]^i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[4] = i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[3]^i[5]^i[6]^i[7];
  assign o[6] = i[4]^i[6]^i[7];
  assign o[7] = i[0]^i[5]^i[7];
endmodule

module gf_mult_by_8c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[7];
  assign o[1] = i[2];
  assign o[2] = i[0]^i[1]^i[3]^i[7];
  assign o[3] = i[0]^i[2]^i[4]^i[7];
  assign o[4] = i[3]^i[5]^i[7];
  assign o[5] = i[4]^i[6];
  assign o[6] = i[5]^i[7];
  assign o[7] = i[0]^i[6];
endmodule

module gf_mult_by_8d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[7];
  assign o[1] = i[1]^i[2];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[7];
  assign o[3] = i[0]^i[2]^i[3]^i[4]^i[7];
  assign o[4] = i[3]^i[4]^i[5]^i[7];
  assign o[5] = i[4]^i[5]^i[6];
  assign o[6] = i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[6]^i[7];
endmodule

module gf_mult_by_8e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1];
  assign o[1] = i[0]^i[2];
  assign o[2] = i[0]^i[3];
  assign o[3] = i[0]^i[4];
  assign o[4] = i[5];
  assign o[5] = i[6];
  assign o[6] = i[7];
  assign o[7] = i[0];
endmodule

module gf_mult_by_8f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1];
  assign o[1] = i[0]^i[1]^i[2];
  assign o[2] = i[0]^i[2]^i[3];
  assign o[3] = i[0]^i[3]^i[4];
  assign o[4] = i[4]^i[5];
  assign o[5] = i[5]^i[6];
  assign o[6] = i[6]^i[7];
  assign o[7] = i[0]^i[7];
endmodule

module gf_mult_by_90 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[2]^i[5]^i[6]^i[7];
  assign o[2] = i[1]^i[3]^i[4]^i[5];
  assign o[3] = i[1]^i[2]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[3]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_91 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[2] = i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[3] = i[1]^i[2]^i[3]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[5] = i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[6] = i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[7] = i[0]^i[3]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_92 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[4]^i[5]^i[6];
  assign o[1] = i[0]^i[2]^i[5]^i[6]^i[7];
  assign o[2] = i[3]^i[4]^i[5]^i[7];
  assign o[3] = i[1];
  assign o[4] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[5] = i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[6] = i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[7] = i[0]^i[3]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_93 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[4]^i[5]^i[6];
  assign o[1] = i[0]^i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[2] = i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[3] = i[1]^i[3];
  assign o[4] = i[0]^i[1]^i[2]^i[5]^i[6];
  assign o[5] = i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[6] = i[2]^i[3]^i[4]^i[7];
  assign o[7] = i[0]^i[3]^i[4]^i[5];
endmodule

module gf_mult_by_94 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[4]^i[5]^i[7];
  assign o[1] = i[2]^i[5]^i[6];
  assign o[2] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[3] = i[2]^i[6];
  assign o[4] = i[0]^i[1]^i[3]^i[4]^i[5];
  assign o[5] = i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[6] = i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[3]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_95 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[4]^i[5]^i[7];
  assign o[1] = i[1]^i[2]^i[5]^i[6];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[3] = i[2]^i[3]^i[6];
  assign o[4] = i[0]^i[1]^i[3]^i[5];
  assign o[5] = i[1]^i[2]^i[4]^i[6];
  assign o[6] = i[2]^i[3]^i[5]^i[7];
  assign o[7] = i[0]^i[3]^i[4]^i[6];
endmodule

module gf_mult_by_96 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[4]^i[5];
  assign o[1] = i[0]^i[2]^i[5]^i[6];
  assign o[2] = i[0]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[4]^i[5]^i[7];
  assign o[5] = i[1]^i[2]^i[5]^i[6];
  assign o[6] = i[2]^i[3]^i[6]^i[7];
  assign o[7] = i[0]^i[3]^i[4]^i[7];
endmodule

module gf_mult_by_97 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[4]^i[5];
  assign o[1] = i[0]^i[1]^i[2]^i[5]^i[6];
  assign o[2] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[3]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[5]^i[7];
  assign o[5] = i[1]^i[2]^i[6];
  assign o[6] = i[2]^i[3]^i[7];
  assign o[7] = i[0]^i[3]^i[4];
endmodule

module gf_mult_by_98 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[4]^i[6]^i[7];
  assign o[1] = i[2]^i[5]^i[7];
  assign o[2] = i[1]^i[3]^i[4]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[4];
  assign o[5] = i[1]^i[3]^i[4]^i[5];
  assign o[6] = i[2]^i[4]^i[5]^i[6];
  assign o[7] = i[0]^i[3]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_99 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[4]^i[6]^i[7];
  assign o[1] = i[1]^i[2]^i[5]^i[7];
  assign o[2] = i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[2]^i[3];
  assign o[5] = i[1]^i[3]^i[4];
  assign o[6] = i[2]^i[4]^i[5];
  assign o[7] = i[0]^i[3]^i[5]^i[6];
endmodule

module gf_mult_by_9a (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[4]^i[6];
  assign o[1] = i[0]^i[2]^i[5]^i[7];
  assign o[2] = i[3]^i[4];
  assign o[3] = i[0]^i[1]^i[5]^i[6];
  assign o[4] = i[0]^i[2]^i[4]^i[7];
  assign o[5] = i[1]^i[3]^i[5];
  assign o[6] = i[2]^i[4]^i[6];
  assign o[7] = i[0]^i[3]^i[5]^i[7];
endmodule

module gf_mult_by_9b (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[4]^i[6];
  assign o[1] = i[0]^i[1]^i[2]^i[5]^i[7];
  assign o[2] = i[2]^i[3]^i[4];
  assign o[3] = i[0]^i[1]^i[3]^i[5]^i[6];
  assign o[4] = i[0]^i[2]^i[7];
  assign o[5] = i[1]^i[3];
  assign o[6] = i[2]^i[4];
  assign o[7] = i[0]^i[3]^i[5];
endmodule

module gf_mult_by_9c (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[4]^i[7];
  assign o[1] = i[2]^i[5];
  assign o[2] = i[0]^i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[3] = i[0]^i[2]^i[5];
  assign o[4] = i[0]^i[3]^i[4]^i[6]^i[7];
  assign o[5] = i[1]^i[4]^i[5]^i[7];
  assign o[6] = i[2]^i[5]^i[6];
  assign o[7] = i[0]^i[3]^i[6]^i[7];
endmodule

module gf_mult_by_9d (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[4]^i[7];
  assign o[1] = i[1]^i[2]^i[5];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[3] = i[0]^i[2]^i[3]^i[5];
  assign o[4] = i[0]^i[3]^i[6]^i[7];
  assign o[5] = i[1]^i[4]^i[7];
  assign o[6] = i[2]^i[5];
  assign o[7] = i[0]^i[3]^i[6];
endmodule

module gf_mult_by_9e (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[4];
  assign o[1] = i[0]^i[2]^i[5];
  assign o[2] = i[0]^i[3]^i[4]^i[6];
  assign o[3] = i[0]^i[5]^i[7];
  assign o[4] = i[0]^i[4]^i[6];
  assign o[5] = i[1]^i[5]^i[7];
  assign o[6] = i[2]^i[6];
  assign o[7] = i[0]^i[3]^i[7];
endmodule

module gf_mult_by_9f (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[4];
  assign o[1] = i[0]^i[1]^i[2]^i[5];
  assign o[2] = i[0]^i[2]^i[3]^i[4]^i[6];
  assign o[3] = i[0]^i[3]^i[5]^i[7];
  assign o[4] = i[0]^i[6];
  assign o[5] = i[1]^i[7];
  assign o[6] = i[2];
  assign o[7] = i[0]^i[3];
endmodule

module gf_mult_by_a0 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[5]^i[6];
  assign o[1] = i[2]^i[4]^i[6]^i[7];
  assign o[2] = i[1]^i[6]^i[7];
  assign o[3] = i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[4] = i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[5] = i[0]^i[2]^i[3]^i[5]^i[6];
  assign o[6] = i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[7] = i[0]^i[2]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_a1 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[5]^i[6];
  assign o[1] = i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[2] = i[1]^i[2]^i[6]^i[7];
  assign o[3] = i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[4] = i[1]^i[2]^i[5]^i[7];
  assign o[5] = i[0]^i[2]^i[3]^i[6];
  assign o[6] = i[1]^i[3]^i[4]^i[7];
  assign o[7] = i[0]^i[2]^i[4]^i[5];
endmodule

module gf_mult_by_a2 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[2]^i[4]^i[6]^i[7];
  assign o[2] = i[6];
  assign o[3] = i[1]^i[3]^i[5]^i[6];
  assign o[4] = i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[5] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[6] = i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[2]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_a3 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[2] = i[2]^i[6];
  assign o[3] = i[1]^i[5]^i[6];
  assign o[4] = i[1]^i[2]^i[3]^i[5];
  assign o[5] = i[0]^i[2]^i[3]^i[4]^i[6];
  assign o[6] = i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[7] = i[0]^i[2]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_a4 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[5];
  assign o[1] = i[2]^i[4]^i[6];
  assign o[2] = i[0]^i[1]^i[7];
  assign o[3] = i[2]^i[3]^i[5];
  assign o[4] = i[1]^i[4]^i[5]^i[6];
  assign o[5] = i[0]^i[2]^i[5]^i[6]^i[7];
  assign o[6] = i[1]^i[3]^i[6]^i[7];
  assign o[7] = i[0]^i[2]^i[4]^i[7];
endmodule

module gf_mult_by_a5 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[5];
  assign o[1] = i[1]^i[2]^i[4]^i[6];
  assign o[2] = i[0]^i[1]^i[2]^i[7];
  assign o[3] = i[2]^i[5];
  assign o[4] = i[1]^i[5]^i[6];
  assign o[5] = i[0]^i[2]^i[6]^i[7];
  assign o[6] = i[1]^i[3]^i[7];
  assign o[7] = i[0]^i[2]^i[4];
endmodule

module gf_mult_by_a6 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[5]^i[7];
  assign o[1] = i[0]^i[2]^i[4]^i[6];
  assign o[2] = i[0];
  assign o[3] = i[3]^i[5]^i[7];
  assign o[4] = i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[2]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_a7 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[5]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[4]^i[6];
  assign o[2] = i[0]^i[2];
  assign o[3] = i[5]^i[7];
  assign o[4] = i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[2]^i[4]^i[6]^i[7];
  assign o[6] = i[1]^i[3]^i[5]^i[7];
  assign o[7] = i[0]^i[2]^i[4]^i[6];
endmodule

module gf_mult_by_a8 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[6];
  assign o[1] = i[2]^i[4]^i[7];
  assign o[2] = i[1]^i[5]^i[6];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[7];
  assign o[4] = i[2]^i[4]^i[6];
  assign o[5] = i[0]^i[3]^i[5]^i[7];
  assign o[6] = i[1]^i[4]^i[6];
  assign o[7] = i[0]^i[2]^i[5]^i[7];
endmodule

module gf_mult_by_a9 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[6];
  assign o[1] = i[1]^i[2]^i[4]^i[7];
  assign o[2] = i[1]^i[2]^i[5]^i[6];
  assign o[3] = i[0]^i[1]^i[2]^i[7];
  assign o[4] = i[2]^i[6];
  assign o[5] = i[0]^i[3]^i[7];
  assign o[6] = i[1]^i[4];
  assign o[7] = i[0]^i[2]^i[5];
endmodule

module gf_mult_by_aa (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[6]^i[7];
  assign o[1] = i[0]^i[2]^i[4]^i[7];
  assign o[2] = i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[3];
  assign o[4] = i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[5] = i[0]^i[3]^i[4]^i[5]^i[7];
  assign o[6] = i[1]^i[4]^i[5]^i[6];
  assign o[7] = i[0]^i[2]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_ab (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[4]^i[7];
  assign o[2] = i[2]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[1];
  assign o[4] = i[2]^i[3]^i[6]^i[7];
  assign o[5] = i[0]^i[3]^i[4]^i[7];
  assign o[6] = i[1]^i[4]^i[5];
  assign o[7] = i[0]^i[2]^i[5]^i[6];
endmodule

module gf_mult_by_ac (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3];
  assign o[1] = i[2]^i[4];
  assign o[2] = i[0]^i[1]^i[5];
  assign o[3] = i[0]^i[2]^i[3]^i[6];
  assign o[4] = i[4]^i[7];
  assign o[5] = i[0]^i[5];
  assign o[6] = i[1]^i[6];
  assign o[7] = i[0]^i[2]^i[7];
endmodule

module gf_mult_by_ad (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3];
  assign o[1] = i[1]^i[2]^i[4];
  assign o[2] = i[0]^i[1]^i[2]^i[5];
  assign o[3] = i[0]^i[2]^i[6];
  assign o[4] = i[7];
  assign o[5] = i[0];
  assign o[6] = i[1];
  assign o[7] = i[0]^i[2];
endmodule

module gf_mult_by_ae (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[7];
  assign o[1] = i[0]^i[2]^i[4];
  assign o[2] = i[0]^i[5]^i[7];
  assign o[3] = i[0]^i[3]^i[6]^i[7];
  assign o[4] = i[3]^i[4];
  assign o[5] = i[0]^i[4]^i[5];
  assign o[6] = i[1]^i[5]^i[6];
  assign o[7] = i[0]^i[2]^i[6]^i[7];
endmodule

module gf_mult_by_af (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[4];
  assign o[2] = i[0]^i[2]^i[5]^i[7];
  assign o[3] = i[0]^i[6]^i[7];
  assign o[4] = i[3];
  assign o[5] = i[0]^i[4];
  assign o[6] = i[1]^i[5];
  assign o[7] = i[0]^i[2]^i[6];
endmodule

module gf_mult_by_b0 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[1] = i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[1]^i[4]^i[7];
  assign o[3] = i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[4] = i[0]^i[1]^i[2]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[7];
  assign o[6] = i[1]^i[2]^i[3]^i[4];
  assign o[7] = i[0]^i[2]^i[3]^i[4]^i[5];
endmodule

module gf_mult_by_b1 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[1] = i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[1]^i[2]^i[4]^i[7];
  assign o[3] = i[1]^i[2]^i[4]^i[6];
  assign o[4] = i[0]^i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[6] = i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[7] = i[0]^i[2]^i[3]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_b2 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[4];
  assign o[3] = i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[6];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[6] = i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[7] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_b3 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[2]^i[4];
  assign o[3] = i[1]^i[4]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[6] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[7] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_b4 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[4]^i[5];
  assign o[1] = i[2]^i[4]^i[5]^i[6];
  assign o[2] = i[0]^i[1]^i[4]^i[6]^i[7];
  assign o[3] = i[2]^i[3]^i[4]^i[7];
  assign o[4] = i[0]^i[1];
  assign o[5] = i[0]^i[1]^i[2];
  assign o[6] = i[1]^i[2]^i[3];
  assign o[7] = i[0]^i[2]^i[3]^i[4];
endmodule

module gf_mult_by_b5 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[4]^i[5];
  assign o[1] = i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[2] = i[0]^i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[3] = i[2]^i[4]^i[7];
  assign o[4] = i[0]^i[1]^i[4];
  assign o[5] = i[0]^i[1]^i[2]^i[5];
  assign o[6] = i[1]^i[2]^i[3]^i[6];
  assign o[7] = i[0]^i[2]^i[3]^i[4]^i[7];
endmodule

module gf_mult_by_b6 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[1] = i[0]^i[2]^i[4]^i[5]^i[6];
  assign o[2] = i[0]^i[4]^i[6];
  assign o[3] = i[3]^i[4];
  assign o[4] = i[0]^i[1]^i[3]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[4];
  assign o[6] = i[1]^i[2]^i[3]^i[5];
  assign o[7] = i[0]^i[2]^i[3]^i[4]^i[6];
endmodule

module gf_mult_by_b7 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[2] = i[0]^i[2]^i[4]^i[6];
  assign o[3] = i[4];
  assign o[4] = i[0]^i[1]^i[3]^i[4]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[4]^i[5];
  assign o[6] = i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[7] = i[0]^i[2]^i[3]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_b8 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[4]^i[6];
  assign o[1] = i[2]^i[4]^i[5]^i[7];
  assign o[2] = i[1]^i[4]^i[5];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[4] = i[0]^i[2]^i[5];
  assign o[5] = i[0]^i[1]^i[3]^i[6];
  assign o[6] = i[1]^i[2]^i[4]^i[7];
  assign o[7] = i[0]^i[2]^i[3]^i[5];
endmodule

module gf_mult_by_b9 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[4]^i[6];
  assign o[1] = i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[2] = i[1]^i[2]^i[4]^i[5];
  assign o[3] = i[0]^i[1]^i[2]^i[4]^i[5];
  assign o[4] = i[0]^i[2]^i[4]^i[5];
  assign o[5] = i[0]^i[1]^i[3]^i[5]^i[6];
  assign o[6] = i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[7] = i[0]^i[2]^i[3]^i[5]^i[7];
endmodule

module gf_mult_by_ba (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[1] = i[0]^i[2]^i[4]^i[5]^i[7];
  assign o[2] = i[4]^i[5]^i[7];
  assign o[3] = i[0]^i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[5]^i[7];
  assign o[5] = i[0]^i[1]^i[3]^i[4]^i[6];
  assign o[6] = i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[7] = i[0]^i[2]^i[3]^i[5]^i[6];
endmodule

module gf_mult_by_bb (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[2] = i[2]^i[4]^i[5]^i[7];
  assign o[3] = i[0]^i[1]^i[4]^i[5]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[5] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[6] = i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[2]^i[3]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_bc (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[4];
  assign o[1] = i[2]^i[4]^i[5];
  assign o[2] = i[0]^i[1]^i[4]^i[5]^i[6];
  assign o[3] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[6]^i[7];
  assign o[6] = i[1]^i[2]^i[7];
  assign o[7] = i[0]^i[2]^i[3];
endmodule

module gf_mult_by_bd (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[4];
  assign o[1] = i[1]^i[2]^i[4]^i[5];
  assign o[2] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[3] = i[0]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[5]^i[6]^i[7];
  assign o[6] = i[1]^i[2]^i[6]^i[7];
  assign o[7] = i[0]^i[2]^i[3]^i[7];
endmodule

module gf_mult_by_be (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[3]^i[4]^i[7];
  assign o[1] = i[0]^i[2]^i[4]^i[5];
  assign o[2] = i[0]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[3]^i[4]^i[5]^i[6];
  assign o[4] = i[0]^i[3]^i[5]^i[6];
  assign o[5] = i[0]^i[1]^i[4]^i[6]^i[7];
  assign o[6] = i[1]^i[2]^i[5]^i[7];
  assign o[7] = i[0]^i[2]^i[3]^i[6];
endmodule

module gf_mult_by_bf (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[3]^i[4]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[4]^i[5];
  assign o[2] = i[0]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[4]^i[5]^i[6];
  assign o[4] = i[0]^i[3]^i[4]^i[5]^i[6];
  assign o[5] = i[0]^i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[2]^i[3]^i[6]^i[7];
endmodule

module gf_mult_by_c0 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[5];
  assign o[1] = i[2]^i[3]^i[6];
  assign o[2] = i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[3] = i[1]^i[3]^i[4]^i[6];
  assign o[4] = i[1]^i[4]^i[7];
  assign o[5] = i[2]^i[5];
  assign o[6] = i[0]^i[3]^i[6];
  assign o[7] = i[0]^i[1]^i[4]^i[7];
endmodule

module gf_mult_by_c1 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[5];
  assign o[1] = i[1]^i[2]^i[3]^i[6];
  assign o[2] = i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[3] = i[1]^i[4]^i[6];
  assign o[4] = i[1]^i[7];
  assign o[5] = i[2];
  assign o[6] = i[0]^i[3];
  assign o[7] = i[0]^i[1]^i[4];
endmodule

module gf_mult_by_c2 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[5]^i[7];
  assign o[1] = i[0]^i[2]^i[3]^i[6];
  assign o[2] = i[2]^i[3]^i[4]^i[5];
  assign o[3] = i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[4] = i[1]^i[3]^i[4];
  assign o[5] = i[2]^i[4]^i[5];
  assign o[6] = i[0]^i[3]^i[5]^i[6];
  assign o[7] = i[0]^i[1]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_c3 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[5]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[6];
  assign o[2] = i[3]^i[4]^i[5];
  assign o[3] = i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[4] = i[1]^i[3];
  assign o[5] = i[2]^i[4];
  assign o[6] = i[0]^i[3]^i[5];
  assign o[7] = i[0]^i[1]^i[4]^i[6];
endmodule

module gf_mult_by_c4 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[5]^i[6];
  assign o[1] = i[2]^i[3]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[3]^i[4]^i[7];
  assign o[4] = i[1]^i[2]^i[4]^i[6];
  assign o[5] = i[2]^i[3]^i[5]^i[7];
  assign o[6] = i[0]^i[3]^i[4]^i[6];
  assign o[7] = i[0]^i[1]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_c5 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[5]^i[6];
  assign o[1] = i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[4]^i[7];
  assign o[4] = i[1]^i[2]^i[6];
  assign o[5] = i[2]^i[3]^i[7];
  assign o[6] = i[0]^i[3]^i[4];
  assign o[7] = i[0]^i[1]^i[4]^i[5];
endmodule

module gf_mult_by_c6 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[2]^i[3]^i[6]^i[7];
  assign o[2] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[3] = i[2]^i[3]^i[4];
  assign o[4] = i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[5] = i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[6] = i[0]^i[3]^i[4]^i[5]^i[6];
  assign o[7] = i[0]^i[1]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_c7 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[2] = i[0]^i[3]^i[4]^i[5]^i[6];
  assign o[3] = i[2]^i[4];
  assign o[4] = i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[5] = i[2]^i[3]^i[4]^i[7];
  assign o[6] = i[0]^i[3]^i[4]^i[5];
  assign o[7] = i[0]^i[1]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_c8 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2];
  assign o[1] = i[2]^i[3];
  assign o[2] = i[1]^i[2]^i[3]^i[4];
  assign o[3] = i[0]^i[1]^i[3]^i[4]^i[5];
  assign o[4] = i[4]^i[5]^i[6];
  assign o[5] = i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[7];
endmodule

module gf_mult_by_c9 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2];
  assign o[1] = i[1]^i[2]^i[3];
  assign o[2] = i[1]^i[3]^i[4];
  assign o[3] = i[0]^i[1]^i[4]^i[5];
  assign o[4] = i[5]^i[6];
  assign o[5] = i[6]^i[7];
  assign o[6] = i[0]^i[7];
  assign o[7] = i[0]^i[1];
endmodule

module gf_mult_by_ca (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[7];
  assign o[1] = i[0]^i[2]^i[3];
  assign o[2] = i[2]^i[3]^i[4]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[4] = i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[6]^i[7];
endmodule

module gf_mult_by_cb (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[3];
  assign o[2] = i[3]^i[4]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[4] = i[3]^i[5]^i[6]^i[7];
  assign o[5] = i[4]^i[6]^i[7];
  assign o[6] = i[0]^i[5]^i[7];
  assign o[7] = i[0]^i[1]^i[6];
endmodule

module gf_mult_by_cc (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[6];
  assign o[1] = i[2]^i[3]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[3] = i[0]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[2]^i[4]^i[5]^i[7];
  assign o[5] = i[3]^i[5]^i[6];
  assign o[6] = i[0]^i[4]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[5]^i[7];
endmodule

module gf_mult_by_cd (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[6];
  assign o[1] = i[1]^i[2]^i[3]^i[7];
  assign o[2] = i[0]^i[1]^i[3]^i[4]^i[6];
  assign o[3] = i[0]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[2]^i[5]^i[7];
  assign o[5] = i[3]^i[6];
  assign o[6] = i[0]^i[4]^i[7];
  assign o[7] = i[0]^i[1]^i[5];
endmodule

module gf_mult_by_ce (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[6]^i[7];
  assign o[1] = i[0]^i[2]^i[3]^i[7];
  assign o[2] = i[0]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[3] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[4] = i[2]^i[3]^i[4]^i[5];
  assign o[5] = i[3]^i[4]^i[5]^i[6];
  assign o[6] = i[0]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_cf (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[7];
  assign o[2] = i[0]^i[3]^i[4]^i[6]^i[7];
  assign o[3] = i[0]^i[2]^i[4]^i[5]^i[6];
  assign o[4] = i[2]^i[3]^i[5];
  assign o[5] = i[3]^i[4]^i[6];
  assign o[6] = i[0]^i[4]^i[5]^i[7];
  assign o[7] = i[0]^i[1]^i[5]^i[6];
endmodule

module gf_mult_by_d0 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[4]^i[5];
  assign o[1] = i[2]^i[3]^i[5]^i[6];
  assign o[2] = i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[3] = i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[5]^i[6]^i[7];
  assign o[5] = i[1]^i[2]^i[6]^i[7];
  assign o[6] = i[0]^i[2]^i[3]^i[7];
  assign o[7] = i[0]^i[1]^i[3]^i[4];
endmodule

module gf_mult_by_d1 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[4]^i[5];
  assign o[1] = i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[2] = i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[3] = i[1]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[2]^i[3]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[3]^i[4]^i[7];
endmodule

module gf_mult_by_d2 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[1] = i[0]^i[2]^i[3]^i[5]^i[6];
  assign o[2] = i[2]^i[3]^i[5]^i[6];
  assign o[3] = i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[4] = i[0]^i[1]^i[3]^i[5]^i[6];
  assign o[5] = i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[6] = i[0]^i[2]^i[3]^i[5]^i[7];
  assign o[7] = i[0]^i[1]^i[3]^i[4]^i[6];
endmodule

module gf_mult_by_d3 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[2] = i[3]^i[5]^i[6];
  assign o[3] = i[1]^i[2]^i[5]^i[6];
  assign o[4] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6];
  assign o[5] = i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[3]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_d4 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[1] = i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[3] = i[3]^i[5];
  assign o[4] = i[0]^i[1]^i[2]^i[5];
  assign o[5] = i[1]^i[2]^i[3]^i[6];
  assign o[6] = i[0]^i[2]^i[3]^i[4]^i[7];
  assign o[7] = i[0]^i[1]^i[3]^i[4]^i[5];
endmodule

module gf_mult_by_d5 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6];
  assign o[1] = i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[3]^i[5]^i[7];
  assign o[3] = i[5];
  assign o[4] = i[0]^i[1]^i[2]^i[4]^i[5];
  assign o[5] = i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[6] = i[0]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[3]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_d6 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[2]^i[3]^i[5];
  assign o[3] = i[2]^i[3]^i[5]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[5] = i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[6] = i[0]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[7] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_d7 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[3]^i[5];
  assign o[3] = i[2]^i[5]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[5] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[6] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_d8 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[4];
  assign o[1] = i[2]^i[3]^i[5];
  assign o[2] = i[1]^i[2]^i[3]^i[6];
  assign o[3] = i[0]^i[1]^i[3]^i[7];
  assign o[4] = i[0];
  assign o[5] = i[1];
  assign o[6] = i[0]^i[2];
  assign o[7] = i[0]^i[1]^i[3];
endmodule

module gf_mult_by_d9 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[4];
  assign o[1] = i[1]^i[2]^i[3]^i[5];
  assign o[2] = i[1]^i[3]^i[6];
  assign o[3] = i[0]^i[1]^i[7];
  assign o[4] = i[0]^i[4];
  assign o[5] = i[1]^i[5];
  assign o[6] = i[0]^i[2]^i[6];
  assign o[7] = i[0]^i[1]^i[3]^i[7];
endmodule

module gf_mult_by_da (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[4]^i[7];
  assign o[1] = i[0]^i[2]^i[3]^i[5];
  assign o[2] = i[2]^i[3]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[2]^i[3];
  assign o[4] = i[0]^i[3]^i[7];
  assign o[5] = i[1]^i[4];
  assign o[6] = i[0]^i[2]^i[5];
  assign o[7] = i[0]^i[1]^i[3]^i[6];
endmodule

module gf_mult_by_db (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[4]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[5];
  assign o[2] = i[3]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[2];
  assign o[4] = i[0]^i[3]^i[4]^i[7];
  assign o[5] = i[1]^i[4]^i[5];
  assign o[6] = i[0]^i[2]^i[5]^i[6];
  assign o[7] = i[0]^i[1]^i[3]^i[6]^i[7];
endmodule

module gf_mult_by_dc (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[4]^i[6];
  assign o[1] = i[2]^i[3]^i[5]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[3];
  assign o[3] = i[0]^i[3]^i[6];
  assign o[4] = i[0]^i[2]^i[6]^i[7];
  assign o[5] = i[1]^i[3]^i[7];
  assign o[6] = i[0]^i[2]^i[4];
  assign o[7] = i[0]^i[1]^i[3]^i[5];
endmodule

module gf_mult_by_dd (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[4]^i[6];
  assign o[1] = i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[2] = i[0]^i[1]^i[3];
  assign o[3] = i[0]^i[6];
  assign o[4] = i[0]^i[2]^i[4]^i[6]^i[7];
  assign o[5] = i[1]^i[3]^i[5]^i[7];
  assign o[6] = i[0]^i[2]^i[4]^i[6];
  assign o[7] = i[0]^i[1]^i[3]^i[5]^i[7];
endmodule

module gf_mult_by_de (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[1] = i[0]^i[2]^i[3]^i[5]^i[7];
  assign o[2] = i[0]^i[2]^i[3]^i[7];
  assign o[3] = i[0]^i[2]^i[3]^i[6]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[6];
  assign o[5] = i[1]^i[3]^i[4]^i[7];
  assign o[6] = i[0]^i[2]^i[4]^i[5];
  assign o[7] = i[0]^i[1]^i[3]^i[5]^i[6];
endmodule

module gf_mult_by_df (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[2] = i[0]^i[3]^i[7];
  assign o[3] = i[0]^i[2]^i[6]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[4]^i[6];
  assign o[5] = i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[6] = i[0]^i[2]^i[4]^i[5]^i[6];
  assign o[7] = i[0]^i[1]^i[3]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_e0 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[1] = i[2]^i[3]^i[4]^i[6];
  assign o[2] = i[1]^i[2]^i[4];
  assign o[3] = i[1]^i[7];
  assign o[4] = i[1]^i[3]^i[5]^i[7];
  assign o[5] = i[0]^i[2]^i[4]^i[6];
  assign o[6] = i[0]^i[1]^i[3]^i[5]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[4]^i[6];
endmodule

module gf_mult_by_e1 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[5]^i[7];
  assign o[1] = i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[2] = i[1]^i[4];
  assign o[3] = i[1]^i[3]^i[7];
  assign o[4] = i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[5] = i[0]^i[2]^i[4]^i[5]^i[6];
  assign o[6] = i[0]^i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_e2 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[5];
  assign o[1] = i[0]^i[2]^i[3]^i[4]^i[6];
  assign o[2] = i[2]^i[4]^i[7];
  assign o[3] = i[1]^i[2];
  assign o[4] = i[1]^i[5];
  assign o[5] = i[0]^i[2]^i[6];
  assign o[6] = i[0]^i[1]^i[3]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[4];
endmodule

module gf_mult_by_e3 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[5];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[2] = i[4]^i[7];
  assign o[3] = i[1]^i[2]^i[3];
  assign o[4] = i[1]^i[4]^i[5];
  assign o[5] = i[0]^i[2]^i[5]^i[6];
  assign o[6] = i[0]^i[1]^i[3]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[4]^i[7];
endmodule

module gf_mult_by_e4 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[1] = i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[4]^i[6];
  assign o[3] = i[6];
  assign o[4] = i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[5] = i[0]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[3]^i[4]^i[5]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_e5 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[1] = i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[4]^i[6];
  assign o[3] = i[3]^i[6];
  assign o[4] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[5] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_e6 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[1] = i[0]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[2] = i[0]^i[2]^i[4]^i[6]^i[7];
  assign o[3] = i[2]^i[6]^i[7];
  assign o[4] = i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[2]^i[3]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[3]^i[4]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[4]^i[5];
endmodule

module gf_mult_by_e7 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[2] = i[0]^i[4]^i[6]^i[7];
  assign o[3] = i[2]^i[3]^i[6]^i[7];
  assign o[4] = i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_e8 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[7];
  assign o[1] = i[2]^i[3]^i[4];
  assign o[2] = i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[3] = i[0]^i[1]^i[5]^i[6]^i[7];
  assign o[4] = i[3]^i[6];
  assign o[5] = i[0]^i[4]^i[7];
  assign o[6] = i[0]^i[1]^i[5];
  assign o[7] = i[0]^i[1]^i[2]^i[6];
endmodule

module gf_mult_by_e9 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[7];
  assign o[1] = i[1]^i[2]^i[3]^i[4];
  assign o[2] = i[1]^i[4]^i[5]^i[7];
  assign o[3] = i[0]^i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[4] = i[3]^i[4]^i[6];
  assign o[5] = i[0]^i[4]^i[5]^i[7];
  assign o[6] = i[0]^i[1]^i[5]^i[6];
  assign o[7] = i[0]^i[1]^i[2]^i[6]^i[7];
endmodule

module gf_mult_by_ea (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3];
  assign o[1] = i[0]^i[2]^i[3]^i[4];
  assign o[2] = i[2]^i[4]^i[5];
  assign o[3] = i[0]^i[1]^i[2]^i[5]^i[6];
  assign o[4] = i[6]^i[7];
  assign o[5] = i[0]^i[7];
  assign o[6] = i[0]^i[1];
  assign o[7] = i[0]^i[1]^i[2];
endmodule

module gf_mult_by_eb (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[4];
  assign o[2] = i[4]^i[5];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[4] = i[4]^i[6]^i[7];
  assign o[5] = i[0]^i[5]^i[7];
  assign o[6] = i[0]^i[1]^i[6];
  assign o[7] = i[0]^i[1]^i[2]^i[7];
endmodule

module gf_mult_by_ec (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[1] = i[2]^i[3]^i[4]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[5];
  assign o[4] = i[2]^i[3]^i[7];
  assign o[5] = i[0]^i[3]^i[4];
  assign o[6] = i[0]^i[1]^i[4]^i[5];
  assign o[7] = i[0]^i[1]^i[2]^i[5]^i[6];
endmodule

module gf_mult_by_ed (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[6]^i[7];
  assign o[1] = i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[2] = i[0]^i[1]^i[4]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[3]^i[5];
  assign o[4] = i[2]^i[3]^i[4]^i[7];
  assign o[5] = i[0]^i[3]^i[4]^i[5];
  assign o[6] = i[0]^i[1]^i[4]^i[5]^i[6];
  assign o[7] = i[0]^i[1]^i[2]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_ee (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[6];
  assign o[1] = i[0]^i[2]^i[3]^i[4]^i[7];
  assign o[2] = i[0]^i[2]^i[4]^i[5]^i[6];
  assign o[3] = i[0]^i[2]^i[5]^i[7];
  assign o[4] = i[2];
  assign o[5] = i[0]^i[3];
  assign o[6] = i[0]^i[1]^i[4];
  assign o[7] = i[0]^i[1]^i[2]^i[5];
endmodule

module gf_mult_by_ef (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[6];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[2] = i[0]^i[4]^i[5]^i[6];
  assign o[3] = i[0]^i[2]^i[3]^i[5]^i[7];
  assign o[4] = i[2]^i[4];
  assign o[5] = i[0]^i[3]^i[5];
  assign o[6] = i[0]^i[1]^i[4]^i[6];
  assign o[7] = i[0]^i[1]^i[2]^i[5]^i[7];
endmodule

module gf_mult_by_f0 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[1] = i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[2] = i[1]^i[2]^i[6];
  assign o[3] = i[1]^i[4]^i[5];
  assign o[4] = i[0]^i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
endmodule

module gf_mult_by_f1 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[1] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[2] = i[1]^i[6];
  assign o[3] = i[1]^i[3]^i[4]^i[5];
  assign o[4] = i[0]^i[1]^i[3]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[4]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[5];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6];
endmodule

module gf_mult_by_f2 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[1] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[2] = i[2]^i[6]^i[7];
  assign o[3] = i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[4] = i[0]^i[1]^i[4]^i[6];
  assign o[5] = i[0]^i[1]^i[2]^i[5]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[6];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[4]^i[7];
endmodule

module gf_mult_by_f3 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[2] = i[6]^i[7];
  assign o[3] = i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[4] = i[0]^i[1]^i[6];
  assign o[5] = i[0]^i[1]^i[2]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[3];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[4];
endmodule

module gf_mult_by_f4 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[1]^i[2];
  assign o[3] = i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3]^i[4];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_f5 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[1] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[1];
  assign o[3] = i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[4] = i[0]^i[1]^i[2]^i[3];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[4];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
endmodule

module gf_mult_by_f6 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[1] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[2]^i[7];
  assign o[3] = i[2]^i[4]^i[5]^i[6];
  assign o[4] = i[0]^i[1]^i[2]^i[4]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[3]^i[5];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
endmodule

module gf_mult_by_f7 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[2] = i[0]^i[7];
  assign o[3] = i[2]^i[3]^i[4]^i[5]^i[6];
  assign o[4] = i[0]^i[1]^i[2]^i[7];
  assign o[5] = i[0]^i[1]^i[2]^i[3];
  assign o[6] = i[0]^i[1]^i[2]^i[3]^i[4];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5];
endmodule

module gf_mult_by_f8 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[1] = i[2]^i[3]^i[4]^i[5];
  assign o[2] = i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[4]^i[6];
  assign o[4] = i[0]^i[3]^i[4]^i[5];
  assign o[5] = i[0]^i[1]^i[4]^i[5]^i[6];
  assign o[6] = i[0]^i[1]^i[2]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[6]^i[7];
endmodule

module gf_mult_by_f9 (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[4]^i[7];
  assign o[1] = i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[2] = i[1]^i[5]^i[6]^i[7];
  assign o[3] = i[0]^i[1]^i[3]^i[4]^i[6];
  assign o[4] = i[0]^i[3]^i[5];
  assign o[5] = i[0]^i[1]^i[4]^i[6];
  assign o[6] = i[0]^i[1]^i[2]^i[5]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[6];
endmodule

module gf_mult_by_fa (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[4];
  assign o[1] = i[0]^i[2]^i[3]^i[4]^i[5];
  assign o[2] = i[2]^i[5]^i[6];
  assign o[3] = i[0]^i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[4] = i[0]^i[4]^i[5]^i[7];
  assign o[5] = i[0]^i[1]^i[5]^i[6];
  assign o[6] = i[0]^i[1]^i[2]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[7];
endmodule

module gf_mult_by_fb (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[4];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5];
  assign o[2] = i[5]^i[6];
  assign o[3] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[4] = i[0]^i[5]^i[7];
  assign o[5] = i[0]^i[1]^i[6];
  assign o[6] = i[0]^i[1]^i[2]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[3];
endmodule

module gf_mult_by_fc (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[1] = i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[2] = i[0]^i[1]^i[2]^i[5]^i[7];
  assign o[3] = i[0]^i[4]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[3]^i[4]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[4]^i[5]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6]^i[7];
endmodule

module gf_mult_by_fd (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6]^i[7];
  assign o[1] = i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[2] = i[0]^i[1]^i[5]^i[7];
  assign o[3] = i[0]^i[3]^i[4]^i[7];
  assign o[4] = i[0]^i[2]^i[3]^i[5]^i[6]^i[7];
  assign o[5] = i[0]^i[1]^i[3]^i[4]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[4]^i[5]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[5]^i[6];
endmodule

module gf_mult_by_fe (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[1] = i[0]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[2] = i[0]^i[2]^i[5];
  assign o[3] = i[0]^i[2]^i[4];
  assign o[4] = i[0]^i[2]^i[4]^i[5]^i[6];
  assign o[5] = i[0]^i[1]^i[3]^i[5]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[4]^i[6]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[5]^i[7];
endmodule

module gf_mult_by_ff (i,o);
input [7:0] i;
output [7:0] o;
wire [7:0] o;
  assign o[0] = i[0]^i[1]^i[2]^i[3]^i[4]^i[6];
  assign o[1] = i[0]^i[1]^i[2]^i[3]^i[4]^i[5]^i[7];
  assign o[2] = i[0]^i[5];
  assign o[3] = i[0]^i[2]^i[3]^i[4];
  assign o[4] = i[0]^i[2]^i[5]^i[6];
  assign o[5] = i[0]^i[1]^i[3]^i[6]^i[7];
  assign o[6] = i[0]^i[1]^i[2]^i[4]^i[7];
  assign o[7] = i[0]^i[1]^i[2]^i[3]^i[5];
endmodule


///////////////////////////////////////////

// first din zeros the accumulator on the first data symbol
// shift is for reading out the parity register, overrides
//   the first_din signal
module encoder (clk,rst,shift,ena,first_din,din,parity);
input clk,rst,shift,ena,first_din;
input [7:0] din;
output [127:0] parity;
reg [127:0] parity;

  wire [7:0] feedback;
  assign feedback = din ^ (first_din ? 8'b0 : parity[127:120]);

  wire [127:0] gen_fn;
  gf_mult_by_3b m0 (.i(feedback),.o(gen_fn[7:0]));
  gf_mult_by_24 m1 (.i(feedback),.o(gen_fn[15:8]));
  gf_mult_by_32 m2 (.i(feedback),.o(gen_fn[23:16]));
  gf_mult_by_62 m3 (.i(feedback),.o(gen_fn[31:24]));
  gf_mult_by_e5 m4 (.i(feedback),.o(gen_fn[39:32]));
  gf_mult_by_29 m5 (.i(feedback),.o(gen_fn[47:40]));
  gf_mult_by_41 m6 (.i(feedback),.o(gen_fn[55:48]));
  gf_mult_by_a3 m7 (.i(feedback),.o(gen_fn[63:56]));
  gf_mult_by_08 m8 (.i(feedback),.o(gen_fn[71:64]));
  gf_mult_by_1e m9 (.i(feedback),.o(gen_fn[79:72]));
  gf_mult_by_d1 m10 (.i(feedback),.o(gen_fn[87:80]));
  gf_mult_by_44 m11 (.i(feedback),.o(gen_fn[95:88]));
  gf_mult_by_bd m12 (.i(feedback),.o(gen_fn[103:96]));
  gf_mult_by_68 m13 (.i(feedback),.o(gen_fn[111:104]));
  gf_mult_by_0d m14 (.i(feedback),.o(gen_fn[119:112]));
  gf_mult_by_3b m15 (.i(feedback),.o(gen_fn[127:120]));

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      parity <= 0;
    end
    else if (ena) begin
      parity <= ((!shift & first_din) ? 128'b0 : (parity << 8)) ^
             (shift ? 128'b0 : gen_fn);
    end
  end
endmodule


///////////////////////////////////////////

// No latency syndrome computation
module syndrome_flat (rx_data,syndrome);
input [2039:0] rx_data;
output [127:0] syndrome;
wire [127:0] syndrome;


// syndrome 0
  wire [2039:0] syn_0_tmp;
  gf_mult_by_01 m0 (.i(rx_data[7:0]),.o(syn_0_tmp[7:0]));
  gf_mult_by_01 m1 (.i(rx_data[15:8]),.o(syn_0_tmp[15:8]));
  gf_mult_by_01 m2 (.i(rx_data[23:16]),.o(syn_0_tmp[23:16]));
  gf_mult_by_01 m3 (.i(rx_data[31:24]),.o(syn_0_tmp[31:24]));
  gf_mult_by_01 m4 (.i(rx_data[39:32]),.o(syn_0_tmp[39:32]));
  gf_mult_by_01 m5 (.i(rx_data[47:40]),.o(syn_0_tmp[47:40]));
  gf_mult_by_01 m6 (.i(rx_data[55:48]),.o(syn_0_tmp[55:48]));
  gf_mult_by_01 m7 (.i(rx_data[63:56]),.o(syn_0_tmp[63:56]));
  gf_mult_by_01 m8 (.i(rx_data[71:64]),.o(syn_0_tmp[71:64]));
  gf_mult_by_01 m9 (.i(rx_data[79:72]),.o(syn_0_tmp[79:72]));
  gf_mult_by_01 m10 (.i(rx_data[87:80]),.o(syn_0_tmp[87:80]));
  gf_mult_by_01 m11 (.i(rx_data[95:88]),.o(syn_0_tmp[95:88]));
  gf_mult_by_01 m12 (.i(rx_data[103:96]),.o(syn_0_tmp[103:96]));
  gf_mult_by_01 m13 (.i(rx_data[111:104]),.o(syn_0_tmp[111:104]));
  gf_mult_by_01 m14 (.i(rx_data[119:112]),.o(syn_0_tmp[119:112]));
  gf_mult_by_01 m15 (.i(rx_data[127:120]),.o(syn_0_tmp[127:120]));
  gf_mult_by_01 m16 (.i(rx_data[135:128]),.o(syn_0_tmp[135:128]));
  gf_mult_by_01 m17 (.i(rx_data[143:136]),.o(syn_0_tmp[143:136]));
  gf_mult_by_01 m18 (.i(rx_data[151:144]),.o(syn_0_tmp[151:144]));
  gf_mult_by_01 m19 (.i(rx_data[159:152]),.o(syn_0_tmp[159:152]));
  gf_mult_by_01 m20 (.i(rx_data[167:160]),.o(syn_0_tmp[167:160]));
  gf_mult_by_01 m21 (.i(rx_data[175:168]),.o(syn_0_tmp[175:168]));
  gf_mult_by_01 m22 (.i(rx_data[183:176]),.o(syn_0_tmp[183:176]));
  gf_mult_by_01 m23 (.i(rx_data[191:184]),.o(syn_0_tmp[191:184]));
  gf_mult_by_01 m24 (.i(rx_data[199:192]),.o(syn_0_tmp[199:192]));
  gf_mult_by_01 m25 (.i(rx_data[207:200]),.o(syn_0_tmp[207:200]));
  gf_mult_by_01 m26 (.i(rx_data[215:208]),.o(syn_0_tmp[215:208]));
  gf_mult_by_01 m27 (.i(rx_data[223:216]),.o(syn_0_tmp[223:216]));
  gf_mult_by_01 m28 (.i(rx_data[231:224]),.o(syn_0_tmp[231:224]));
  gf_mult_by_01 m29 (.i(rx_data[239:232]),.o(syn_0_tmp[239:232]));
  gf_mult_by_01 m30 (.i(rx_data[247:240]),.o(syn_0_tmp[247:240]));
  gf_mult_by_01 m31 (.i(rx_data[255:248]),.o(syn_0_tmp[255:248]));
  gf_mult_by_01 m32 (.i(rx_data[263:256]),.o(syn_0_tmp[263:256]));
  gf_mult_by_01 m33 (.i(rx_data[271:264]),.o(syn_0_tmp[271:264]));
  gf_mult_by_01 m34 (.i(rx_data[279:272]),.o(syn_0_tmp[279:272]));
  gf_mult_by_01 m35 (.i(rx_data[287:280]),.o(syn_0_tmp[287:280]));
  gf_mult_by_01 m36 (.i(rx_data[295:288]),.o(syn_0_tmp[295:288]));
  gf_mult_by_01 m37 (.i(rx_data[303:296]),.o(syn_0_tmp[303:296]));
  gf_mult_by_01 m38 (.i(rx_data[311:304]),.o(syn_0_tmp[311:304]));
  gf_mult_by_01 m39 (.i(rx_data[319:312]),.o(syn_0_tmp[319:312]));
  gf_mult_by_01 m40 (.i(rx_data[327:320]),.o(syn_0_tmp[327:320]));
  gf_mult_by_01 m41 (.i(rx_data[335:328]),.o(syn_0_tmp[335:328]));
  gf_mult_by_01 m42 (.i(rx_data[343:336]),.o(syn_0_tmp[343:336]));
  gf_mult_by_01 m43 (.i(rx_data[351:344]),.o(syn_0_tmp[351:344]));
  gf_mult_by_01 m44 (.i(rx_data[359:352]),.o(syn_0_tmp[359:352]));
  gf_mult_by_01 m45 (.i(rx_data[367:360]),.o(syn_0_tmp[367:360]));
  gf_mult_by_01 m46 (.i(rx_data[375:368]),.o(syn_0_tmp[375:368]));
  gf_mult_by_01 m47 (.i(rx_data[383:376]),.o(syn_0_tmp[383:376]));
  gf_mult_by_01 m48 (.i(rx_data[391:384]),.o(syn_0_tmp[391:384]));
  gf_mult_by_01 m49 (.i(rx_data[399:392]),.o(syn_0_tmp[399:392]));
  gf_mult_by_01 m50 (.i(rx_data[407:400]),.o(syn_0_tmp[407:400]));
  gf_mult_by_01 m51 (.i(rx_data[415:408]),.o(syn_0_tmp[415:408]));
  gf_mult_by_01 m52 (.i(rx_data[423:416]),.o(syn_0_tmp[423:416]));
  gf_mult_by_01 m53 (.i(rx_data[431:424]),.o(syn_0_tmp[431:424]));
  gf_mult_by_01 m54 (.i(rx_data[439:432]),.o(syn_0_tmp[439:432]));
  gf_mult_by_01 m55 (.i(rx_data[447:440]),.o(syn_0_tmp[447:440]));
  gf_mult_by_01 m56 (.i(rx_data[455:448]),.o(syn_0_tmp[455:448]));
  gf_mult_by_01 m57 (.i(rx_data[463:456]),.o(syn_0_tmp[463:456]));
  gf_mult_by_01 m58 (.i(rx_data[471:464]),.o(syn_0_tmp[471:464]));
  gf_mult_by_01 m59 (.i(rx_data[479:472]),.o(syn_0_tmp[479:472]));
  gf_mult_by_01 m60 (.i(rx_data[487:480]),.o(syn_0_tmp[487:480]));
  gf_mult_by_01 m61 (.i(rx_data[495:488]),.o(syn_0_tmp[495:488]));
  gf_mult_by_01 m62 (.i(rx_data[503:496]),.o(syn_0_tmp[503:496]));
  gf_mult_by_01 m63 (.i(rx_data[511:504]),.o(syn_0_tmp[511:504]));
  gf_mult_by_01 m64 (.i(rx_data[519:512]),.o(syn_0_tmp[519:512]));
  gf_mult_by_01 m65 (.i(rx_data[527:520]),.o(syn_0_tmp[527:520]));
  gf_mult_by_01 m66 (.i(rx_data[535:528]),.o(syn_0_tmp[535:528]));
  gf_mult_by_01 m67 (.i(rx_data[543:536]),.o(syn_0_tmp[543:536]));
  gf_mult_by_01 m68 (.i(rx_data[551:544]),.o(syn_0_tmp[551:544]));
  gf_mult_by_01 m69 (.i(rx_data[559:552]),.o(syn_0_tmp[559:552]));
  gf_mult_by_01 m70 (.i(rx_data[567:560]),.o(syn_0_tmp[567:560]));
  gf_mult_by_01 m71 (.i(rx_data[575:568]),.o(syn_0_tmp[575:568]));
  gf_mult_by_01 m72 (.i(rx_data[583:576]),.o(syn_0_tmp[583:576]));
  gf_mult_by_01 m73 (.i(rx_data[591:584]),.o(syn_0_tmp[591:584]));
  gf_mult_by_01 m74 (.i(rx_data[599:592]),.o(syn_0_tmp[599:592]));
  gf_mult_by_01 m75 (.i(rx_data[607:600]),.o(syn_0_tmp[607:600]));
  gf_mult_by_01 m76 (.i(rx_data[615:608]),.o(syn_0_tmp[615:608]));
  gf_mult_by_01 m77 (.i(rx_data[623:616]),.o(syn_0_tmp[623:616]));
  gf_mult_by_01 m78 (.i(rx_data[631:624]),.o(syn_0_tmp[631:624]));
  gf_mult_by_01 m79 (.i(rx_data[639:632]),.o(syn_0_tmp[639:632]));
  gf_mult_by_01 m80 (.i(rx_data[647:640]),.o(syn_0_tmp[647:640]));
  gf_mult_by_01 m81 (.i(rx_data[655:648]),.o(syn_0_tmp[655:648]));
  gf_mult_by_01 m82 (.i(rx_data[663:656]),.o(syn_0_tmp[663:656]));
  gf_mult_by_01 m83 (.i(rx_data[671:664]),.o(syn_0_tmp[671:664]));
  gf_mult_by_01 m84 (.i(rx_data[679:672]),.o(syn_0_tmp[679:672]));
  gf_mult_by_01 m85 (.i(rx_data[687:680]),.o(syn_0_tmp[687:680]));
  gf_mult_by_01 m86 (.i(rx_data[695:688]),.o(syn_0_tmp[695:688]));
  gf_mult_by_01 m87 (.i(rx_data[703:696]),.o(syn_0_tmp[703:696]));
  gf_mult_by_01 m88 (.i(rx_data[711:704]),.o(syn_0_tmp[711:704]));
  gf_mult_by_01 m89 (.i(rx_data[719:712]),.o(syn_0_tmp[719:712]));
  gf_mult_by_01 m90 (.i(rx_data[727:720]),.o(syn_0_tmp[727:720]));
  gf_mult_by_01 m91 (.i(rx_data[735:728]),.o(syn_0_tmp[735:728]));
  gf_mult_by_01 m92 (.i(rx_data[743:736]),.o(syn_0_tmp[743:736]));
  gf_mult_by_01 m93 (.i(rx_data[751:744]),.o(syn_0_tmp[751:744]));
  gf_mult_by_01 m94 (.i(rx_data[759:752]),.o(syn_0_tmp[759:752]));
  gf_mult_by_01 m95 (.i(rx_data[767:760]),.o(syn_0_tmp[767:760]));
  gf_mult_by_01 m96 (.i(rx_data[775:768]),.o(syn_0_tmp[775:768]));
  gf_mult_by_01 m97 (.i(rx_data[783:776]),.o(syn_0_tmp[783:776]));
  gf_mult_by_01 m98 (.i(rx_data[791:784]),.o(syn_0_tmp[791:784]));
  gf_mult_by_01 m99 (.i(rx_data[799:792]),.o(syn_0_tmp[799:792]));
  gf_mult_by_01 m100 (.i(rx_data[807:800]),.o(syn_0_tmp[807:800]));
  gf_mult_by_01 m101 (.i(rx_data[815:808]),.o(syn_0_tmp[815:808]));
  gf_mult_by_01 m102 (.i(rx_data[823:816]),.o(syn_0_tmp[823:816]));
  gf_mult_by_01 m103 (.i(rx_data[831:824]),.o(syn_0_tmp[831:824]));
  gf_mult_by_01 m104 (.i(rx_data[839:832]),.o(syn_0_tmp[839:832]));
  gf_mult_by_01 m105 (.i(rx_data[847:840]),.o(syn_0_tmp[847:840]));
  gf_mult_by_01 m106 (.i(rx_data[855:848]),.o(syn_0_tmp[855:848]));
  gf_mult_by_01 m107 (.i(rx_data[863:856]),.o(syn_0_tmp[863:856]));
  gf_mult_by_01 m108 (.i(rx_data[871:864]),.o(syn_0_tmp[871:864]));
  gf_mult_by_01 m109 (.i(rx_data[879:872]),.o(syn_0_tmp[879:872]));
  gf_mult_by_01 m110 (.i(rx_data[887:880]),.o(syn_0_tmp[887:880]));
  gf_mult_by_01 m111 (.i(rx_data[895:888]),.o(syn_0_tmp[895:888]));
  gf_mult_by_01 m112 (.i(rx_data[903:896]),.o(syn_0_tmp[903:896]));
  gf_mult_by_01 m113 (.i(rx_data[911:904]),.o(syn_0_tmp[911:904]));
  gf_mult_by_01 m114 (.i(rx_data[919:912]),.o(syn_0_tmp[919:912]));
  gf_mult_by_01 m115 (.i(rx_data[927:920]),.o(syn_0_tmp[927:920]));
  gf_mult_by_01 m116 (.i(rx_data[935:928]),.o(syn_0_tmp[935:928]));
  gf_mult_by_01 m117 (.i(rx_data[943:936]),.o(syn_0_tmp[943:936]));
  gf_mult_by_01 m118 (.i(rx_data[951:944]),.o(syn_0_tmp[951:944]));
  gf_mult_by_01 m119 (.i(rx_data[959:952]),.o(syn_0_tmp[959:952]));
  gf_mult_by_01 m120 (.i(rx_data[967:960]),.o(syn_0_tmp[967:960]));
  gf_mult_by_01 m121 (.i(rx_data[975:968]),.o(syn_0_tmp[975:968]));
  gf_mult_by_01 m122 (.i(rx_data[983:976]),.o(syn_0_tmp[983:976]));
  gf_mult_by_01 m123 (.i(rx_data[991:984]),.o(syn_0_tmp[991:984]));
  gf_mult_by_01 m124 (.i(rx_data[999:992]),.o(syn_0_tmp[999:992]));
  gf_mult_by_01 m125 (.i(rx_data[1007:1000]),.o(syn_0_tmp[1007:1000]));
  gf_mult_by_01 m126 (.i(rx_data[1015:1008]),.o(syn_0_tmp[1015:1008]));
  gf_mult_by_01 m127 (.i(rx_data[1023:1016]),.o(syn_0_tmp[1023:1016]));
  gf_mult_by_01 m128 (.i(rx_data[1031:1024]),.o(syn_0_tmp[1031:1024]));
  gf_mult_by_01 m129 (.i(rx_data[1039:1032]),.o(syn_0_tmp[1039:1032]));
  gf_mult_by_01 m130 (.i(rx_data[1047:1040]),.o(syn_0_tmp[1047:1040]));
  gf_mult_by_01 m131 (.i(rx_data[1055:1048]),.o(syn_0_tmp[1055:1048]));
  gf_mult_by_01 m132 (.i(rx_data[1063:1056]),.o(syn_0_tmp[1063:1056]));
  gf_mult_by_01 m133 (.i(rx_data[1071:1064]),.o(syn_0_tmp[1071:1064]));
  gf_mult_by_01 m134 (.i(rx_data[1079:1072]),.o(syn_0_tmp[1079:1072]));
  gf_mult_by_01 m135 (.i(rx_data[1087:1080]),.o(syn_0_tmp[1087:1080]));
  gf_mult_by_01 m136 (.i(rx_data[1095:1088]),.o(syn_0_tmp[1095:1088]));
  gf_mult_by_01 m137 (.i(rx_data[1103:1096]),.o(syn_0_tmp[1103:1096]));
  gf_mult_by_01 m138 (.i(rx_data[1111:1104]),.o(syn_0_tmp[1111:1104]));
  gf_mult_by_01 m139 (.i(rx_data[1119:1112]),.o(syn_0_tmp[1119:1112]));
  gf_mult_by_01 m140 (.i(rx_data[1127:1120]),.o(syn_0_tmp[1127:1120]));
  gf_mult_by_01 m141 (.i(rx_data[1135:1128]),.o(syn_0_tmp[1135:1128]));
  gf_mult_by_01 m142 (.i(rx_data[1143:1136]),.o(syn_0_tmp[1143:1136]));
  gf_mult_by_01 m143 (.i(rx_data[1151:1144]),.o(syn_0_tmp[1151:1144]));
  gf_mult_by_01 m144 (.i(rx_data[1159:1152]),.o(syn_0_tmp[1159:1152]));
  gf_mult_by_01 m145 (.i(rx_data[1167:1160]),.o(syn_0_tmp[1167:1160]));
  gf_mult_by_01 m146 (.i(rx_data[1175:1168]),.o(syn_0_tmp[1175:1168]));
  gf_mult_by_01 m147 (.i(rx_data[1183:1176]),.o(syn_0_tmp[1183:1176]));
  gf_mult_by_01 m148 (.i(rx_data[1191:1184]),.o(syn_0_tmp[1191:1184]));
  gf_mult_by_01 m149 (.i(rx_data[1199:1192]),.o(syn_0_tmp[1199:1192]));
  gf_mult_by_01 m150 (.i(rx_data[1207:1200]),.o(syn_0_tmp[1207:1200]));
  gf_mult_by_01 m151 (.i(rx_data[1215:1208]),.o(syn_0_tmp[1215:1208]));
  gf_mult_by_01 m152 (.i(rx_data[1223:1216]),.o(syn_0_tmp[1223:1216]));
  gf_mult_by_01 m153 (.i(rx_data[1231:1224]),.o(syn_0_tmp[1231:1224]));
  gf_mult_by_01 m154 (.i(rx_data[1239:1232]),.o(syn_0_tmp[1239:1232]));
  gf_mult_by_01 m155 (.i(rx_data[1247:1240]),.o(syn_0_tmp[1247:1240]));
  gf_mult_by_01 m156 (.i(rx_data[1255:1248]),.o(syn_0_tmp[1255:1248]));
  gf_mult_by_01 m157 (.i(rx_data[1263:1256]),.o(syn_0_tmp[1263:1256]));
  gf_mult_by_01 m158 (.i(rx_data[1271:1264]),.o(syn_0_tmp[1271:1264]));
  gf_mult_by_01 m159 (.i(rx_data[1279:1272]),.o(syn_0_tmp[1279:1272]));
  gf_mult_by_01 m160 (.i(rx_data[1287:1280]),.o(syn_0_tmp[1287:1280]));
  gf_mult_by_01 m161 (.i(rx_data[1295:1288]),.o(syn_0_tmp[1295:1288]));
  gf_mult_by_01 m162 (.i(rx_data[1303:1296]),.o(syn_0_tmp[1303:1296]));
  gf_mult_by_01 m163 (.i(rx_data[1311:1304]),.o(syn_0_tmp[1311:1304]));
  gf_mult_by_01 m164 (.i(rx_data[1319:1312]),.o(syn_0_tmp[1319:1312]));
  gf_mult_by_01 m165 (.i(rx_data[1327:1320]),.o(syn_0_tmp[1327:1320]));
  gf_mult_by_01 m166 (.i(rx_data[1335:1328]),.o(syn_0_tmp[1335:1328]));
  gf_mult_by_01 m167 (.i(rx_data[1343:1336]),.o(syn_0_tmp[1343:1336]));
  gf_mult_by_01 m168 (.i(rx_data[1351:1344]),.o(syn_0_tmp[1351:1344]));
  gf_mult_by_01 m169 (.i(rx_data[1359:1352]),.o(syn_0_tmp[1359:1352]));
  gf_mult_by_01 m170 (.i(rx_data[1367:1360]),.o(syn_0_tmp[1367:1360]));
  gf_mult_by_01 m171 (.i(rx_data[1375:1368]),.o(syn_0_tmp[1375:1368]));
  gf_mult_by_01 m172 (.i(rx_data[1383:1376]),.o(syn_0_tmp[1383:1376]));
  gf_mult_by_01 m173 (.i(rx_data[1391:1384]),.o(syn_0_tmp[1391:1384]));
  gf_mult_by_01 m174 (.i(rx_data[1399:1392]),.o(syn_0_tmp[1399:1392]));
  gf_mult_by_01 m175 (.i(rx_data[1407:1400]),.o(syn_0_tmp[1407:1400]));
  gf_mult_by_01 m176 (.i(rx_data[1415:1408]),.o(syn_0_tmp[1415:1408]));
  gf_mult_by_01 m177 (.i(rx_data[1423:1416]),.o(syn_0_tmp[1423:1416]));
  gf_mult_by_01 m178 (.i(rx_data[1431:1424]),.o(syn_0_tmp[1431:1424]));
  gf_mult_by_01 m179 (.i(rx_data[1439:1432]),.o(syn_0_tmp[1439:1432]));
  gf_mult_by_01 m180 (.i(rx_data[1447:1440]),.o(syn_0_tmp[1447:1440]));
  gf_mult_by_01 m181 (.i(rx_data[1455:1448]),.o(syn_0_tmp[1455:1448]));
  gf_mult_by_01 m182 (.i(rx_data[1463:1456]),.o(syn_0_tmp[1463:1456]));
  gf_mult_by_01 m183 (.i(rx_data[1471:1464]),.o(syn_0_tmp[1471:1464]));
  gf_mult_by_01 m184 (.i(rx_data[1479:1472]),.o(syn_0_tmp[1479:1472]));
  gf_mult_by_01 m185 (.i(rx_data[1487:1480]),.o(syn_0_tmp[1487:1480]));
  gf_mult_by_01 m186 (.i(rx_data[1495:1488]),.o(syn_0_tmp[1495:1488]));
  gf_mult_by_01 m187 (.i(rx_data[1503:1496]),.o(syn_0_tmp[1503:1496]));
  gf_mult_by_01 m188 (.i(rx_data[1511:1504]),.o(syn_0_tmp[1511:1504]));
  gf_mult_by_01 m189 (.i(rx_data[1519:1512]),.o(syn_0_tmp[1519:1512]));
  gf_mult_by_01 m190 (.i(rx_data[1527:1520]),.o(syn_0_tmp[1527:1520]));
  gf_mult_by_01 m191 (.i(rx_data[1535:1528]),.o(syn_0_tmp[1535:1528]));
  gf_mult_by_01 m192 (.i(rx_data[1543:1536]),.o(syn_0_tmp[1543:1536]));
  gf_mult_by_01 m193 (.i(rx_data[1551:1544]),.o(syn_0_tmp[1551:1544]));
  gf_mult_by_01 m194 (.i(rx_data[1559:1552]),.o(syn_0_tmp[1559:1552]));
  gf_mult_by_01 m195 (.i(rx_data[1567:1560]),.o(syn_0_tmp[1567:1560]));
  gf_mult_by_01 m196 (.i(rx_data[1575:1568]),.o(syn_0_tmp[1575:1568]));
  gf_mult_by_01 m197 (.i(rx_data[1583:1576]),.o(syn_0_tmp[1583:1576]));
  gf_mult_by_01 m198 (.i(rx_data[1591:1584]),.o(syn_0_tmp[1591:1584]));
  gf_mult_by_01 m199 (.i(rx_data[1599:1592]),.o(syn_0_tmp[1599:1592]));
  gf_mult_by_01 m200 (.i(rx_data[1607:1600]),.o(syn_0_tmp[1607:1600]));
  gf_mult_by_01 m201 (.i(rx_data[1615:1608]),.o(syn_0_tmp[1615:1608]));
  gf_mult_by_01 m202 (.i(rx_data[1623:1616]),.o(syn_0_tmp[1623:1616]));
  gf_mult_by_01 m203 (.i(rx_data[1631:1624]),.o(syn_0_tmp[1631:1624]));
  gf_mult_by_01 m204 (.i(rx_data[1639:1632]),.o(syn_0_tmp[1639:1632]));
  gf_mult_by_01 m205 (.i(rx_data[1647:1640]),.o(syn_0_tmp[1647:1640]));
  gf_mult_by_01 m206 (.i(rx_data[1655:1648]),.o(syn_0_tmp[1655:1648]));
  gf_mult_by_01 m207 (.i(rx_data[1663:1656]),.o(syn_0_tmp[1663:1656]));
  gf_mult_by_01 m208 (.i(rx_data[1671:1664]),.o(syn_0_tmp[1671:1664]));
  gf_mult_by_01 m209 (.i(rx_data[1679:1672]),.o(syn_0_tmp[1679:1672]));
  gf_mult_by_01 m210 (.i(rx_data[1687:1680]),.o(syn_0_tmp[1687:1680]));
  gf_mult_by_01 m211 (.i(rx_data[1695:1688]),.o(syn_0_tmp[1695:1688]));
  gf_mult_by_01 m212 (.i(rx_data[1703:1696]),.o(syn_0_tmp[1703:1696]));
  gf_mult_by_01 m213 (.i(rx_data[1711:1704]),.o(syn_0_tmp[1711:1704]));
  gf_mult_by_01 m214 (.i(rx_data[1719:1712]),.o(syn_0_tmp[1719:1712]));
  gf_mult_by_01 m215 (.i(rx_data[1727:1720]),.o(syn_0_tmp[1727:1720]));
  gf_mult_by_01 m216 (.i(rx_data[1735:1728]),.o(syn_0_tmp[1735:1728]));
  gf_mult_by_01 m217 (.i(rx_data[1743:1736]),.o(syn_0_tmp[1743:1736]));
  gf_mult_by_01 m218 (.i(rx_data[1751:1744]),.o(syn_0_tmp[1751:1744]));
  gf_mult_by_01 m219 (.i(rx_data[1759:1752]),.o(syn_0_tmp[1759:1752]));
  gf_mult_by_01 m220 (.i(rx_data[1767:1760]),.o(syn_0_tmp[1767:1760]));
  gf_mult_by_01 m221 (.i(rx_data[1775:1768]),.o(syn_0_tmp[1775:1768]));
  gf_mult_by_01 m222 (.i(rx_data[1783:1776]),.o(syn_0_tmp[1783:1776]));
  gf_mult_by_01 m223 (.i(rx_data[1791:1784]),.o(syn_0_tmp[1791:1784]));
  gf_mult_by_01 m224 (.i(rx_data[1799:1792]),.o(syn_0_tmp[1799:1792]));
  gf_mult_by_01 m225 (.i(rx_data[1807:1800]),.o(syn_0_tmp[1807:1800]));
  gf_mult_by_01 m226 (.i(rx_data[1815:1808]),.o(syn_0_tmp[1815:1808]));
  gf_mult_by_01 m227 (.i(rx_data[1823:1816]),.o(syn_0_tmp[1823:1816]));
  gf_mult_by_01 m228 (.i(rx_data[1831:1824]),.o(syn_0_tmp[1831:1824]));
  gf_mult_by_01 m229 (.i(rx_data[1839:1832]),.o(syn_0_tmp[1839:1832]));
  gf_mult_by_01 m230 (.i(rx_data[1847:1840]),.o(syn_0_tmp[1847:1840]));
  gf_mult_by_01 m231 (.i(rx_data[1855:1848]),.o(syn_0_tmp[1855:1848]));
  gf_mult_by_01 m232 (.i(rx_data[1863:1856]),.o(syn_0_tmp[1863:1856]));
  gf_mult_by_01 m233 (.i(rx_data[1871:1864]),.o(syn_0_tmp[1871:1864]));
  gf_mult_by_01 m234 (.i(rx_data[1879:1872]),.o(syn_0_tmp[1879:1872]));
  gf_mult_by_01 m235 (.i(rx_data[1887:1880]),.o(syn_0_tmp[1887:1880]));
  gf_mult_by_01 m236 (.i(rx_data[1895:1888]),.o(syn_0_tmp[1895:1888]));
  gf_mult_by_01 m237 (.i(rx_data[1903:1896]),.o(syn_0_tmp[1903:1896]));
  gf_mult_by_01 m238 (.i(rx_data[1911:1904]),.o(syn_0_tmp[1911:1904]));
  gf_mult_by_01 m239 (.i(rx_data[1919:1912]),.o(syn_0_tmp[1919:1912]));
  gf_mult_by_01 m240 (.i(rx_data[1927:1920]),.o(syn_0_tmp[1927:1920]));
  gf_mult_by_01 m241 (.i(rx_data[1935:1928]),.o(syn_0_tmp[1935:1928]));
  gf_mult_by_01 m242 (.i(rx_data[1943:1936]),.o(syn_0_tmp[1943:1936]));
  gf_mult_by_01 m243 (.i(rx_data[1951:1944]),.o(syn_0_tmp[1951:1944]));
  gf_mult_by_01 m244 (.i(rx_data[1959:1952]),.o(syn_0_tmp[1959:1952]));
  gf_mult_by_01 m245 (.i(rx_data[1967:1960]),.o(syn_0_tmp[1967:1960]));
  gf_mult_by_01 m246 (.i(rx_data[1975:1968]),.o(syn_0_tmp[1975:1968]));
  gf_mult_by_01 m247 (.i(rx_data[1983:1976]),.o(syn_0_tmp[1983:1976]));
  gf_mult_by_01 m248 (.i(rx_data[1991:1984]),.o(syn_0_tmp[1991:1984]));
  gf_mult_by_01 m249 (.i(rx_data[1999:1992]),.o(syn_0_tmp[1999:1992]));
  gf_mult_by_01 m250 (.i(rx_data[2007:2000]),.o(syn_0_tmp[2007:2000]));
  gf_mult_by_01 m251 (.i(rx_data[2015:2008]),.o(syn_0_tmp[2015:2008]));
  gf_mult_by_01 m252 (.i(rx_data[2023:2016]),.o(syn_0_tmp[2023:2016]));
  gf_mult_by_01 m253 (.i(rx_data[2031:2024]),.o(syn_0_tmp[2031:2024]));
  gf_mult_by_01 m254 (.i(rx_data[2039:2032]),.o(syn_0_tmp[2039:2032]));
  assign syndrome[7:0] =
      syn_0_tmp[7:0] ^ syn_0_tmp[15:8] ^ syn_0_tmp[23:16] ^ 
      syn_0_tmp[31:24] ^ syn_0_tmp[39:32] ^ syn_0_tmp[47:40] ^ 
      syn_0_tmp[55:48] ^ syn_0_tmp[63:56] ^ syn_0_tmp[71:64] ^ 
      syn_0_tmp[79:72] ^ syn_0_tmp[87:80] ^ syn_0_tmp[95:88] ^ 
      syn_0_tmp[103:96] ^ syn_0_tmp[111:104] ^ syn_0_tmp[119:112] ^ 
      syn_0_tmp[127:120] ^ syn_0_tmp[135:128] ^ syn_0_tmp[143:136] ^ 
      syn_0_tmp[151:144] ^ syn_0_tmp[159:152] ^ syn_0_tmp[167:160] ^ 
      syn_0_tmp[175:168] ^ syn_0_tmp[183:176] ^ syn_0_tmp[191:184] ^ 
      syn_0_tmp[199:192] ^ syn_0_tmp[207:200] ^ syn_0_tmp[215:208] ^ 
      syn_0_tmp[223:216] ^ syn_0_tmp[231:224] ^ syn_0_tmp[239:232] ^ 
      syn_0_tmp[247:240] ^ syn_0_tmp[255:248] ^ syn_0_tmp[263:256] ^ 
      syn_0_tmp[271:264] ^ syn_0_tmp[279:272] ^ syn_0_tmp[287:280] ^ 
      syn_0_tmp[295:288] ^ syn_0_tmp[303:296] ^ syn_0_tmp[311:304] ^ 
      syn_0_tmp[319:312] ^ syn_0_tmp[327:320] ^ syn_0_tmp[335:328] ^ 
      syn_0_tmp[343:336] ^ syn_0_tmp[351:344] ^ syn_0_tmp[359:352] ^ 
      syn_0_tmp[367:360] ^ syn_0_tmp[375:368] ^ syn_0_tmp[383:376] ^ 
      syn_0_tmp[391:384] ^ syn_0_tmp[399:392] ^ syn_0_tmp[407:400] ^ 
      syn_0_tmp[415:408] ^ syn_0_tmp[423:416] ^ syn_0_tmp[431:424] ^ 
      syn_0_tmp[439:432] ^ syn_0_tmp[447:440] ^ syn_0_tmp[455:448] ^ 
      syn_0_tmp[463:456] ^ syn_0_tmp[471:464] ^ syn_0_tmp[479:472] ^ 
      syn_0_tmp[487:480] ^ syn_0_tmp[495:488] ^ syn_0_tmp[503:496] ^ 
      syn_0_tmp[511:504] ^ syn_0_tmp[519:512] ^ syn_0_tmp[527:520] ^ 
      syn_0_tmp[535:528] ^ syn_0_tmp[543:536] ^ syn_0_tmp[551:544] ^ 
      syn_0_tmp[559:552] ^ syn_0_tmp[567:560] ^ syn_0_tmp[575:568] ^ 
      syn_0_tmp[583:576] ^ syn_0_tmp[591:584] ^ syn_0_tmp[599:592] ^ 
      syn_0_tmp[607:600] ^ syn_0_tmp[615:608] ^ syn_0_tmp[623:616] ^ 
      syn_0_tmp[631:624] ^ syn_0_tmp[639:632] ^ syn_0_tmp[647:640] ^ 
      syn_0_tmp[655:648] ^ syn_0_tmp[663:656] ^ syn_0_tmp[671:664] ^ 
      syn_0_tmp[679:672] ^ syn_0_tmp[687:680] ^ syn_0_tmp[695:688] ^ 
      syn_0_tmp[703:696] ^ syn_0_tmp[711:704] ^ syn_0_tmp[719:712] ^ 
      syn_0_tmp[727:720] ^ syn_0_tmp[735:728] ^ syn_0_tmp[743:736] ^ 
      syn_0_tmp[751:744] ^ syn_0_tmp[759:752] ^ syn_0_tmp[767:760] ^ 
      syn_0_tmp[775:768] ^ syn_0_tmp[783:776] ^ syn_0_tmp[791:784] ^ 
      syn_0_tmp[799:792] ^ syn_0_tmp[807:800] ^ syn_0_tmp[815:808] ^ 
      syn_0_tmp[823:816] ^ syn_0_tmp[831:824] ^ syn_0_tmp[839:832] ^ 
      syn_0_tmp[847:840] ^ syn_0_tmp[855:848] ^ syn_0_tmp[863:856] ^ 
      syn_0_tmp[871:864] ^ syn_0_tmp[879:872] ^ syn_0_tmp[887:880] ^ 
      syn_0_tmp[895:888] ^ syn_0_tmp[903:896] ^ syn_0_tmp[911:904] ^ 
      syn_0_tmp[919:912] ^ syn_0_tmp[927:920] ^ syn_0_tmp[935:928] ^ 
      syn_0_tmp[943:936] ^ syn_0_tmp[951:944] ^ syn_0_tmp[959:952] ^ 
      syn_0_tmp[967:960] ^ syn_0_tmp[975:968] ^ syn_0_tmp[983:976] ^ 
      syn_0_tmp[991:984] ^ syn_0_tmp[999:992] ^ syn_0_tmp[1007:1000] ^ 
      syn_0_tmp[1015:1008] ^ syn_0_tmp[1023:1016] ^ syn_0_tmp[1031:1024] ^ 
      syn_0_tmp[1039:1032] ^ syn_0_tmp[1047:1040] ^ syn_0_tmp[1055:1048] ^ 
      syn_0_tmp[1063:1056] ^ syn_0_tmp[1071:1064] ^ syn_0_tmp[1079:1072] ^ 
      syn_0_tmp[1087:1080] ^ syn_0_tmp[1095:1088] ^ syn_0_tmp[1103:1096] ^ 
      syn_0_tmp[1111:1104] ^ syn_0_tmp[1119:1112] ^ syn_0_tmp[1127:1120] ^ 
      syn_0_tmp[1135:1128] ^ syn_0_tmp[1143:1136] ^ syn_0_tmp[1151:1144] ^ 
      syn_0_tmp[1159:1152] ^ syn_0_tmp[1167:1160] ^ syn_0_tmp[1175:1168] ^ 
      syn_0_tmp[1183:1176] ^ syn_0_tmp[1191:1184] ^ syn_0_tmp[1199:1192] ^ 
      syn_0_tmp[1207:1200] ^ syn_0_tmp[1215:1208] ^ syn_0_tmp[1223:1216] ^ 
      syn_0_tmp[1231:1224] ^ syn_0_tmp[1239:1232] ^ syn_0_tmp[1247:1240] ^ 
      syn_0_tmp[1255:1248] ^ syn_0_tmp[1263:1256] ^ syn_0_tmp[1271:1264] ^ 
      syn_0_tmp[1279:1272] ^ syn_0_tmp[1287:1280] ^ syn_0_tmp[1295:1288] ^ 
      syn_0_tmp[1303:1296] ^ syn_0_tmp[1311:1304] ^ syn_0_tmp[1319:1312] ^ 
      syn_0_tmp[1327:1320] ^ syn_0_tmp[1335:1328] ^ syn_0_tmp[1343:1336] ^ 
      syn_0_tmp[1351:1344] ^ syn_0_tmp[1359:1352] ^ syn_0_tmp[1367:1360] ^ 
      syn_0_tmp[1375:1368] ^ syn_0_tmp[1383:1376] ^ syn_0_tmp[1391:1384] ^ 
      syn_0_tmp[1399:1392] ^ syn_0_tmp[1407:1400] ^ syn_0_tmp[1415:1408] ^ 
      syn_0_tmp[1423:1416] ^ syn_0_tmp[1431:1424] ^ syn_0_tmp[1439:1432] ^ 
      syn_0_tmp[1447:1440] ^ syn_0_tmp[1455:1448] ^ syn_0_tmp[1463:1456] ^ 
      syn_0_tmp[1471:1464] ^ syn_0_tmp[1479:1472] ^ syn_0_tmp[1487:1480] ^ 
      syn_0_tmp[1495:1488] ^ syn_0_tmp[1503:1496] ^ syn_0_tmp[1511:1504] ^ 
      syn_0_tmp[1519:1512] ^ syn_0_tmp[1527:1520] ^ syn_0_tmp[1535:1528] ^ 
      syn_0_tmp[1543:1536] ^ syn_0_tmp[1551:1544] ^ syn_0_tmp[1559:1552] ^ 
      syn_0_tmp[1567:1560] ^ syn_0_tmp[1575:1568] ^ syn_0_tmp[1583:1576] ^ 
      syn_0_tmp[1591:1584] ^ syn_0_tmp[1599:1592] ^ syn_0_tmp[1607:1600] ^ 
      syn_0_tmp[1615:1608] ^ syn_0_tmp[1623:1616] ^ syn_0_tmp[1631:1624] ^ 
      syn_0_tmp[1639:1632] ^ syn_0_tmp[1647:1640] ^ syn_0_tmp[1655:1648] ^ 
      syn_0_tmp[1663:1656] ^ syn_0_tmp[1671:1664] ^ syn_0_tmp[1679:1672] ^ 
      syn_0_tmp[1687:1680] ^ syn_0_tmp[1695:1688] ^ syn_0_tmp[1703:1696] ^ 
      syn_0_tmp[1711:1704] ^ syn_0_tmp[1719:1712] ^ syn_0_tmp[1727:1720] ^ 
      syn_0_tmp[1735:1728] ^ syn_0_tmp[1743:1736] ^ syn_0_tmp[1751:1744] ^ 
      syn_0_tmp[1759:1752] ^ syn_0_tmp[1767:1760] ^ syn_0_tmp[1775:1768] ^ 
      syn_0_tmp[1783:1776] ^ syn_0_tmp[1791:1784] ^ syn_0_tmp[1799:1792] ^ 
      syn_0_tmp[1807:1800] ^ syn_0_tmp[1815:1808] ^ syn_0_tmp[1823:1816] ^ 
      syn_0_tmp[1831:1824] ^ syn_0_tmp[1839:1832] ^ syn_0_tmp[1847:1840] ^ 
      syn_0_tmp[1855:1848] ^ syn_0_tmp[1863:1856] ^ syn_0_tmp[1871:1864] ^ 
      syn_0_tmp[1879:1872] ^ syn_0_tmp[1887:1880] ^ syn_0_tmp[1895:1888] ^ 
      syn_0_tmp[1903:1896] ^ syn_0_tmp[1911:1904] ^ syn_0_tmp[1919:1912] ^ 
      syn_0_tmp[1927:1920] ^ syn_0_tmp[1935:1928] ^ syn_0_tmp[1943:1936] ^ 
      syn_0_tmp[1951:1944] ^ syn_0_tmp[1959:1952] ^ syn_0_tmp[1967:1960] ^ 
      syn_0_tmp[1975:1968] ^ syn_0_tmp[1983:1976] ^ syn_0_tmp[1991:1984] ^ 
      syn_0_tmp[1999:1992] ^ syn_0_tmp[2007:2000] ^ syn_0_tmp[2015:2008] ^ 
      syn_0_tmp[2023:2016] ^ syn_0_tmp[2031:2024] ^ syn_0_tmp[2039:2032];

// syndrome 1
  wire [2039:0] syn_1_tmp;
  gf_mult_by_01 m255 (.i(rx_data[7:0]),.o(syn_1_tmp[7:0]));
  gf_mult_by_02 m256 (.i(rx_data[15:8]),.o(syn_1_tmp[15:8]));
  gf_mult_by_04 m257 (.i(rx_data[23:16]),.o(syn_1_tmp[23:16]));
  gf_mult_by_08 m258 (.i(rx_data[31:24]),.o(syn_1_tmp[31:24]));
  gf_mult_by_10 m259 (.i(rx_data[39:32]),.o(syn_1_tmp[39:32]));
  gf_mult_by_20 m260 (.i(rx_data[47:40]),.o(syn_1_tmp[47:40]));
  gf_mult_by_40 m261 (.i(rx_data[55:48]),.o(syn_1_tmp[55:48]));
  gf_mult_by_80 m262 (.i(rx_data[63:56]),.o(syn_1_tmp[63:56]));
  gf_mult_by_1d m263 (.i(rx_data[71:64]),.o(syn_1_tmp[71:64]));
  gf_mult_by_3a m264 (.i(rx_data[79:72]),.o(syn_1_tmp[79:72]));
  gf_mult_by_74 m265 (.i(rx_data[87:80]),.o(syn_1_tmp[87:80]));
  gf_mult_by_e8 m266 (.i(rx_data[95:88]),.o(syn_1_tmp[95:88]));
  gf_mult_by_cd m267 (.i(rx_data[103:96]),.o(syn_1_tmp[103:96]));
  gf_mult_by_87 m268 (.i(rx_data[111:104]),.o(syn_1_tmp[111:104]));
  gf_mult_by_13 m269 (.i(rx_data[119:112]),.o(syn_1_tmp[119:112]));
  gf_mult_by_26 m270 (.i(rx_data[127:120]),.o(syn_1_tmp[127:120]));
  gf_mult_by_4c m271 (.i(rx_data[135:128]),.o(syn_1_tmp[135:128]));
  gf_mult_by_98 m272 (.i(rx_data[143:136]),.o(syn_1_tmp[143:136]));
  gf_mult_by_2d m273 (.i(rx_data[151:144]),.o(syn_1_tmp[151:144]));
  gf_mult_by_5a m274 (.i(rx_data[159:152]),.o(syn_1_tmp[159:152]));
  gf_mult_by_b4 m275 (.i(rx_data[167:160]),.o(syn_1_tmp[167:160]));
  gf_mult_by_75 m276 (.i(rx_data[175:168]),.o(syn_1_tmp[175:168]));
  gf_mult_by_ea m277 (.i(rx_data[183:176]),.o(syn_1_tmp[183:176]));
  gf_mult_by_c9 m278 (.i(rx_data[191:184]),.o(syn_1_tmp[191:184]));
  gf_mult_by_8f m279 (.i(rx_data[199:192]),.o(syn_1_tmp[199:192]));
  gf_mult_by_03 m280 (.i(rx_data[207:200]),.o(syn_1_tmp[207:200]));
  gf_mult_by_06 m281 (.i(rx_data[215:208]),.o(syn_1_tmp[215:208]));
  gf_mult_by_0c m282 (.i(rx_data[223:216]),.o(syn_1_tmp[223:216]));
  gf_mult_by_18 m283 (.i(rx_data[231:224]),.o(syn_1_tmp[231:224]));
  gf_mult_by_30 m284 (.i(rx_data[239:232]),.o(syn_1_tmp[239:232]));
  gf_mult_by_60 m285 (.i(rx_data[247:240]),.o(syn_1_tmp[247:240]));
  gf_mult_by_c0 m286 (.i(rx_data[255:248]),.o(syn_1_tmp[255:248]));
  gf_mult_by_9d m287 (.i(rx_data[263:256]),.o(syn_1_tmp[263:256]));
  gf_mult_by_27 m288 (.i(rx_data[271:264]),.o(syn_1_tmp[271:264]));
  gf_mult_by_4e m289 (.i(rx_data[279:272]),.o(syn_1_tmp[279:272]));
  gf_mult_by_9c m290 (.i(rx_data[287:280]),.o(syn_1_tmp[287:280]));
  gf_mult_by_25 m291 (.i(rx_data[295:288]),.o(syn_1_tmp[295:288]));
  gf_mult_by_4a m292 (.i(rx_data[303:296]),.o(syn_1_tmp[303:296]));
  gf_mult_by_94 m293 (.i(rx_data[311:304]),.o(syn_1_tmp[311:304]));
  gf_mult_by_35 m294 (.i(rx_data[319:312]),.o(syn_1_tmp[319:312]));
  gf_mult_by_6a m295 (.i(rx_data[327:320]),.o(syn_1_tmp[327:320]));
  gf_mult_by_d4 m296 (.i(rx_data[335:328]),.o(syn_1_tmp[335:328]));
  gf_mult_by_b5 m297 (.i(rx_data[343:336]),.o(syn_1_tmp[343:336]));
  gf_mult_by_77 m298 (.i(rx_data[351:344]),.o(syn_1_tmp[351:344]));
  gf_mult_by_ee m299 (.i(rx_data[359:352]),.o(syn_1_tmp[359:352]));
  gf_mult_by_c1 m300 (.i(rx_data[367:360]),.o(syn_1_tmp[367:360]));
  gf_mult_by_9f m301 (.i(rx_data[375:368]),.o(syn_1_tmp[375:368]));
  gf_mult_by_23 m302 (.i(rx_data[383:376]),.o(syn_1_tmp[383:376]));
  gf_mult_by_46 m303 (.i(rx_data[391:384]),.o(syn_1_tmp[391:384]));
  gf_mult_by_8c m304 (.i(rx_data[399:392]),.o(syn_1_tmp[399:392]));
  gf_mult_by_05 m305 (.i(rx_data[407:400]),.o(syn_1_tmp[407:400]));
  gf_mult_by_0a m306 (.i(rx_data[415:408]),.o(syn_1_tmp[415:408]));
  gf_mult_by_14 m307 (.i(rx_data[423:416]),.o(syn_1_tmp[423:416]));
  gf_mult_by_28 m308 (.i(rx_data[431:424]),.o(syn_1_tmp[431:424]));
  gf_mult_by_50 m309 (.i(rx_data[439:432]),.o(syn_1_tmp[439:432]));
  gf_mult_by_a0 m310 (.i(rx_data[447:440]),.o(syn_1_tmp[447:440]));
  gf_mult_by_5d m311 (.i(rx_data[455:448]),.o(syn_1_tmp[455:448]));
  gf_mult_by_ba m312 (.i(rx_data[463:456]),.o(syn_1_tmp[463:456]));
  gf_mult_by_69 m313 (.i(rx_data[471:464]),.o(syn_1_tmp[471:464]));
  gf_mult_by_d2 m314 (.i(rx_data[479:472]),.o(syn_1_tmp[479:472]));
  gf_mult_by_b9 m315 (.i(rx_data[487:480]),.o(syn_1_tmp[487:480]));
  gf_mult_by_6f m316 (.i(rx_data[495:488]),.o(syn_1_tmp[495:488]));
  gf_mult_by_de m317 (.i(rx_data[503:496]),.o(syn_1_tmp[503:496]));
  gf_mult_by_a1 m318 (.i(rx_data[511:504]),.o(syn_1_tmp[511:504]));
  gf_mult_by_5f m319 (.i(rx_data[519:512]),.o(syn_1_tmp[519:512]));
  gf_mult_by_be m320 (.i(rx_data[527:520]),.o(syn_1_tmp[527:520]));
  gf_mult_by_61 m321 (.i(rx_data[535:528]),.o(syn_1_tmp[535:528]));
  gf_mult_by_c2 m322 (.i(rx_data[543:536]),.o(syn_1_tmp[543:536]));
  gf_mult_by_99 m323 (.i(rx_data[551:544]),.o(syn_1_tmp[551:544]));
  gf_mult_by_2f m324 (.i(rx_data[559:552]),.o(syn_1_tmp[559:552]));
  gf_mult_by_5e m325 (.i(rx_data[567:560]),.o(syn_1_tmp[567:560]));
  gf_mult_by_bc m326 (.i(rx_data[575:568]),.o(syn_1_tmp[575:568]));
  gf_mult_by_65 m327 (.i(rx_data[583:576]),.o(syn_1_tmp[583:576]));
  gf_mult_by_ca m328 (.i(rx_data[591:584]),.o(syn_1_tmp[591:584]));
  gf_mult_by_89 m329 (.i(rx_data[599:592]),.o(syn_1_tmp[599:592]));
  gf_mult_by_0f m330 (.i(rx_data[607:600]),.o(syn_1_tmp[607:600]));
  gf_mult_by_1e m331 (.i(rx_data[615:608]),.o(syn_1_tmp[615:608]));
  gf_mult_by_3c m332 (.i(rx_data[623:616]),.o(syn_1_tmp[623:616]));
  gf_mult_by_78 m333 (.i(rx_data[631:624]),.o(syn_1_tmp[631:624]));
  gf_mult_by_f0 m334 (.i(rx_data[639:632]),.o(syn_1_tmp[639:632]));
  gf_mult_by_fd m335 (.i(rx_data[647:640]),.o(syn_1_tmp[647:640]));
  gf_mult_by_e7 m336 (.i(rx_data[655:648]),.o(syn_1_tmp[655:648]));
  gf_mult_by_d3 m337 (.i(rx_data[663:656]),.o(syn_1_tmp[663:656]));
  gf_mult_by_bb m338 (.i(rx_data[671:664]),.o(syn_1_tmp[671:664]));
  gf_mult_by_6b m339 (.i(rx_data[679:672]),.o(syn_1_tmp[679:672]));
  gf_mult_by_d6 m340 (.i(rx_data[687:680]),.o(syn_1_tmp[687:680]));
  gf_mult_by_b1 m341 (.i(rx_data[695:688]),.o(syn_1_tmp[695:688]));
  gf_mult_by_7f m342 (.i(rx_data[703:696]),.o(syn_1_tmp[703:696]));
  gf_mult_by_fe m343 (.i(rx_data[711:704]),.o(syn_1_tmp[711:704]));
  gf_mult_by_e1 m344 (.i(rx_data[719:712]),.o(syn_1_tmp[719:712]));
  gf_mult_by_df m345 (.i(rx_data[727:720]),.o(syn_1_tmp[727:720]));
  gf_mult_by_a3 m346 (.i(rx_data[735:728]),.o(syn_1_tmp[735:728]));
  gf_mult_by_5b m347 (.i(rx_data[743:736]),.o(syn_1_tmp[743:736]));
  gf_mult_by_b6 m348 (.i(rx_data[751:744]),.o(syn_1_tmp[751:744]));
  gf_mult_by_71 m349 (.i(rx_data[759:752]),.o(syn_1_tmp[759:752]));
  gf_mult_by_e2 m350 (.i(rx_data[767:760]),.o(syn_1_tmp[767:760]));
  gf_mult_by_d9 m351 (.i(rx_data[775:768]),.o(syn_1_tmp[775:768]));
  gf_mult_by_af m352 (.i(rx_data[783:776]),.o(syn_1_tmp[783:776]));
  gf_mult_by_43 m353 (.i(rx_data[791:784]),.o(syn_1_tmp[791:784]));
  gf_mult_by_86 m354 (.i(rx_data[799:792]),.o(syn_1_tmp[799:792]));
  gf_mult_by_11 m355 (.i(rx_data[807:800]),.o(syn_1_tmp[807:800]));
  gf_mult_by_22 m356 (.i(rx_data[815:808]),.o(syn_1_tmp[815:808]));
  gf_mult_by_44 m357 (.i(rx_data[823:816]),.o(syn_1_tmp[823:816]));
  gf_mult_by_88 m358 (.i(rx_data[831:824]),.o(syn_1_tmp[831:824]));
  gf_mult_by_0d m359 (.i(rx_data[839:832]),.o(syn_1_tmp[839:832]));
  gf_mult_by_1a m360 (.i(rx_data[847:840]),.o(syn_1_tmp[847:840]));
  gf_mult_by_34 m361 (.i(rx_data[855:848]),.o(syn_1_tmp[855:848]));
  gf_mult_by_68 m362 (.i(rx_data[863:856]),.o(syn_1_tmp[863:856]));
  gf_mult_by_d0 m363 (.i(rx_data[871:864]),.o(syn_1_tmp[871:864]));
  gf_mult_by_bd m364 (.i(rx_data[879:872]),.o(syn_1_tmp[879:872]));
  gf_mult_by_67 m365 (.i(rx_data[887:880]),.o(syn_1_tmp[887:880]));
  gf_mult_by_ce m366 (.i(rx_data[895:888]),.o(syn_1_tmp[895:888]));
  gf_mult_by_81 m367 (.i(rx_data[903:896]),.o(syn_1_tmp[903:896]));
  gf_mult_by_1f m368 (.i(rx_data[911:904]),.o(syn_1_tmp[911:904]));
  gf_mult_by_3e m369 (.i(rx_data[919:912]),.o(syn_1_tmp[919:912]));
  gf_mult_by_7c m370 (.i(rx_data[927:920]),.o(syn_1_tmp[927:920]));
  gf_mult_by_f8 m371 (.i(rx_data[935:928]),.o(syn_1_tmp[935:928]));
  gf_mult_by_ed m372 (.i(rx_data[943:936]),.o(syn_1_tmp[943:936]));
  gf_mult_by_c7 m373 (.i(rx_data[951:944]),.o(syn_1_tmp[951:944]));
  gf_mult_by_93 m374 (.i(rx_data[959:952]),.o(syn_1_tmp[959:952]));
  gf_mult_by_3b m375 (.i(rx_data[967:960]),.o(syn_1_tmp[967:960]));
  gf_mult_by_76 m376 (.i(rx_data[975:968]),.o(syn_1_tmp[975:968]));
  gf_mult_by_ec m377 (.i(rx_data[983:976]),.o(syn_1_tmp[983:976]));
  gf_mult_by_c5 m378 (.i(rx_data[991:984]),.o(syn_1_tmp[991:984]));
  gf_mult_by_97 m379 (.i(rx_data[999:992]),.o(syn_1_tmp[999:992]));
  gf_mult_by_33 m380 (.i(rx_data[1007:1000]),.o(syn_1_tmp[1007:1000]));
  gf_mult_by_66 m381 (.i(rx_data[1015:1008]),.o(syn_1_tmp[1015:1008]));
  gf_mult_by_cc m382 (.i(rx_data[1023:1016]),.o(syn_1_tmp[1023:1016]));
  gf_mult_by_85 m383 (.i(rx_data[1031:1024]),.o(syn_1_tmp[1031:1024]));
  gf_mult_by_17 m384 (.i(rx_data[1039:1032]),.o(syn_1_tmp[1039:1032]));
  gf_mult_by_2e m385 (.i(rx_data[1047:1040]),.o(syn_1_tmp[1047:1040]));
  gf_mult_by_5c m386 (.i(rx_data[1055:1048]),.o(syn_1_tmp[1055:1048]));
  gf_mult_by_b8 m387 (.i(rx_data[1063:1056]),.o(syn_1_tmp[1063:1056]));
  gf_mult_by_6d m388 (.i(rx_data[1071:1064]),.o(syn_1_tmp[1071:1064]));
  gf_mult_by_da m389 (.i(rx_data[1079:1072]),.o(syn_1_tmp[1079:1072]));
  gf_mult_by_a9 m390 (.i(rx_data[1087:1080]),.o(syn_1_tmp[1087:1080]));
  gf_mult_by_4f m391 (.i(rx_data[1095:1088]),.o(syn_1_tmp[1095:1088]));
  gf_mult_by_9e m392 (.i(rx_data[1103:1096]),.o(syn_1_tmp[1103:1096]));
  gf_mult_by_21 m393 (.i(rx_data[1111:1104]),.o(syn_1_tmp[1111:1104]));
  gf_mult_by_42 m394 (.i(rx_data[1119:1112]),.o(syn_1_tmp[1119:1112]));
  gf_mult_by_84 m395 (.i(rx_data[1127:1120]),.o(syn_1_tmp[1127:1120]));
  gf_mult_by_15 m396 (.i(rx_data[1135:1128]),.o(syn_1_tmp[1135:1128]));
  gf_mult_by_2a m397 (.i(rx_data[1143:1136]),.o(syn_1_tmp[1143:1136]));
  gf_mult_by_54 m398 (.i(rx_data[1151:1144]),.o(syn_1_tmp[1151:1144]));
  gf_mult_by_a8 m399 (.i(rx_data[1159:1152]),.o(syn_1_tmp[1159:1152]));
  gf_mult_by_4d m400 (.i(rx_data[1167:1160]),.o(syn_1_tmp[1167:1160]));
  gf_mult_by_9a m401 (.i(rx_data[1175:1168]),.o(syn_1_tmp[1175:1168]));
  gf_mult_by_29 m402 (.i(rx_data[1183:1176]),.o(syn_1_tmp[1183:1176]));
  gf_mult_by_52 m403 (.i(rx_data[1191:1184]),.o(syn_1_tmp[1191:1184]));
  gf_mult_by_a4 m404 (.i(rx_data[1199:1192]),.o(syn_1_tmp[1199:1192]));
  gf_mult_by_55 m405 (.i(rx_data[1207:1200]),.o(syn_1_tmp[1207:1200]));
  gf_mult_by_aa m406 (.i(rx_data[1215:1208]),.o(syn_1_tmp[1215:1208]));
  gf_mult_by_49 m407 (.i(rx_data[1223:1216]),.o(syn_1_tmp[1223:1216]));
  gf_mult_by_92 m408 (.i(rx_data[1231:1224]),.o(syn_1_tmp[1231:1224]));
  gf_mult_by_39 m409 (.i(rx_data[1239:1232]),.o(syn_1_tmp[1239:1232]));
  gf_mult_by_72 m410 (.i(rx_data[1247:1240]),.o(syn_1_tmp[1247:1240]));
  gf_mult_by_e4 m411 (.i(rx_data[1255:1248]),.o(syn_1_tmp[1255:1248]));
  gf_mult_by_d5 m412 (.i(rx_data[1263:1256]),.o(syn_1_tmp[1263:1256]));
  gf_mult_by_b7 m413 (.i(rx_data[1271:1264]),.o(syn_1_tmp[1271:1264]));
  gf_mult_by_73 m414 (.i(rx_data[1279:1272]),.o(syn_1_tmp[1279:1272]));
  gf_mult_by_e6 m415 (.i(rx_data[1287:1280]),.o(syn_1_tmp[1287:1280]));
  gf_mult_by_d1 m416 (.i(rx_data[1295:1288]),.o(syn_1_tmp[1295:1288]));
  gf_mult_by_bf m417 (.i(rx_data[1303:1296]),.o(syn_1_tmp[1303:1296]));
  gf_mult_by_63 m418 (.i(rx_data[1311:1304]),.o(syn_1_tmp[1311:1304]));
  gf_mult_by_c6 m419 (.i(rx_data[1319:1312]),.o(syn_1_tmp[1319:1312]));
  gf_mult_by_91 m420 (.i(rx_data[1327:1320]),.o(syn_1_tmp[1327:1320]));
  gf_mult_by_3f m421 (.i(rx_data[1335:1328]),.o(syn_1_tmp[1335:1328]));
  gf_mult_by_7e m422 (.i(rx_data[1343:1336]),.o(syn_1_tmp[1343:1336]));
  gf_mult_by_fc m423 (.i(rx_data[1351:1344]),.o(syn_1_tmp[1351:1344]));
  gf_mult_by_e5 m424 (.i(rx_data[1359:1352]),.o(syn_1_tmp[1359:1352]));
  gf_mult_by_d7 m425 (.i(rx_data[1367:1360]),.o(syn_1_tmp[1367:1360]));
  gf_mult_by_b3 m426 (.i(rx_data[1375:1368]),.o(syn_1_tmp[1375:1368]));
  gf_mult_by_7b m427 (.i(rx_data[1383:1376]),.o(syn_1_tmp[1383:1376]));
  gf_mult_by_f6 m428 (.i(rx_data[1391:1384]),.o(syn_1_tmp[1391:1384]));
  gf_mult_by_f1 m429 (.i(rx_data[1399:1392]),.o(syn_1_tmp[1399:1392]));
  gf_mult_by_ff m430 (.i(rx_data[1407:1400]),.o(syn_1_tmp[1407:1400]));
  gf_mult_by_e3 m431 (.i(rx_data[1415:1408]),.o(syn_1_tmp[1415:1408]));
  gf_mult_by_db m432 (.i(rx_data[1423:1416]),.o(syn_1_tmp[1423:1416]));
  gf_mult_by_ab m433 (.i(rx_data[1431:1424]),.o(syn_1_tmp[1431:1424]));
  gf_mult_by_4b m434 (.i(rx_data[1439:1432]),.o(syn_1_tmp[1439:1432]));
  gf_mult_by_96 m435 (.i(rx_data[1447:1440]),.o(syn_1_tmp[1447:1440]));
  gf_mult_by_31 m436 (.i(rx_data[1455:1448]),.o(syn_1_tmp[1455:1448]));
  gf_mult_by_62 m437 (.i(rx_data[1463:1456]),.o(syn_1_tmp[1463:1456]));
  gf_mult_by_c4 m438 (.i(rx_data[1471:1464]),.o(syn_1_tmp[1471:1464]));
  gf_mult_by_95 m439 (.i(rx_data[1479:1472]),.o(syn_1_tmp[1479:1472]));
  gf_mult_by_37 m440 (.i(rx_data[1487:1480]),.o(syn_1_tmp[1487:1480]));
  gf_mult_by_6e m441 (.i(rx_data[1495:1488]),.o(syn_1_tmp[1495:1488]));
  gf_mult_by_dc m442 (.i(rx_data[1503:1496]),.o(syn_1_tmp[1503:1496]));
  gf_mult_by_a5 m443 (.i(rx_data[1511:1504]),.o(syn_1_tmp[1511:1504]));
  gf_mult_by_57 m444 (.i(rx_data[1519:1512]),.o(syn_1_tmp[1519:1512]));
  gf_mult_by_ae m445 (.i(rx_data[1527:1520]),.o(syn_1_tmp[1527:1520]));
  gf_mult_by_41 m446 (.i(rx_data[1535:1528]),.o(syn_1_tmp[1535:1528]));
  gf_mult_by_82 m447 (.i(rx_data[1543:1536]),.o(syn_1_tmp[1543:1536]));
  gf_mult_by_19 m448 (.i(rx_data[1551:1544]),.o(syn_1_tmp[1551:1544]));
  gf_mult_by_32 m449 (.i(rx_data[1559:1552]),.o(syn_1_tmp[1559:1552]));
  gf_mult_by_64 m450 (.i(rx_data[1567:1560]),.o(syn_1_tmp[1567:1560]));
  gf_mult_by_c8 m451 (.i(rx_data[1575:1568]),.o(syn_1_tmp[1575:1568]));
  gf_mult_by_8d m452 (.i(rx_data[1583:1576]),.o(syn_1_tmp[1583:1576]));
  gf_mult_by_07 m453 (.i(rx_data[1591:1584]),.o(syn_1_tmp[1591:1584]));
  gf_mult_by_0e m454 (.i(rx_data[1599:1592]),.o(syn_1_tmp[1599:1592]));
  gf_mult_by_1c m455 (.i(rx_data[1607:1600]),.o(syn_1_tmp[1607:1600]));
  gf_mult_by_38 m456 (.i(rx_data[1615:1608]),.o(syn_1_tmp[1615:1608]));
  gf_mult_by_70 m457 (.i(rx_data[1623:1616]),.o(syn_1_tmp[1623:1616]));
  gf_mult_by_e0 m458 (.i(rx_data[1631:1624]),.o(syn_1_tmp[1631:1624]));
  gf_mult_by_dd m459 (.i(rx_data[1639:1632]),.o(syn_1_tmp[1639:1632]));
  gf_mult_by_a7 m460 (.i(rx_data[1647:1640]),.o(syn_1_tmp[1647:1640]));
  gf_mult_by_53 m461 (.i(rx_data[1655:1648]),.o(syn_1_tmp[1655:1648]));
  gf_mult_by_a6 m462 (.i(rx_data[1663:1656]),.o(syn_1_tmp[1663:1656]));
  gf_mult_by_51 m463 (.i(rx_data[1671:1664]),.o(syn_1_tmp[1671:1664]));
  gf_mult_by_a2 m464 (.i(rx_data[1679:1672]),.o(syn_1_tmp[1679:1672]));
  gf_mult_by_59 m465 (.i(rx_data[1687:1680]),.o(syn_1_tmp[1687:1680]));
  gf_mult_by_b2 m466 (.i(rx_data[1695:1688]),.o(syn_1_tmp[1695:1688]));
  gf_mult_by_79 m467 (.i(rx_data[1703:1696]),.o(syn_1_tmp[1703:1696]));
  gf_mult_by_f2 m468 (.i(rx_data[1711:1704]),.o(syn_1_tmp[1711:1704]));
  gf_mult_by_f9 m469 (.i(rx_data[1719:1712]),.o(syn_1_tmp[1719:1712]));
  gf_mult_by_ef m470 (.i(rx_data[1727:1720]),.o(syn_1_tmp[1727:1720]));
  gf_mult_by_c3 m471 (.i(rx_data[1735:1728]),.o(syn_1_tmp[1735:1728]));
  gf_mult_by_9b m472 (.i(rx_data[1743:1736]),.o(syn_1_tmp[1743:1736]));
  gf_mult_by_2b m473 (.i(rx_data[1751:1744]),.o(syn_1_tmp[1751:1744]));
  gf_mult_by_56 m474 (.i(rx_data[1759:1752]),.o(syn_1_tmp[1759:1752]));
  gf_mult_by_ac m475 (.i(rx_data[1767:1760]),.o(syn_1_tmp[1767:1760]));
  gf_mult_by_45 m476 (.i(rx_data[1775:1768]),.o(syn_1_tmp[1775:1768]));
  gf_mult_by_8a m477 (.i(rx_data[1783:1776]),.o(syn_1_tmp[1783:1776]));
  gf_mult_by_09 m478 (.i(rx_data[1791:1784]),.o(syn_1_tmp[1791:1784]));
  gf_mult_by_12 m479 (.i(rx_data[1799:1792]),.o(syn_1_tmp[1799:1792]));
  gf_mult_by_24 m480 (.i(rx_data[1807:1800]),.o(syn_1_tmp[1807:1800]));
  gf_mult_by_48 m481 (.i(rx_data[1815:1808]),.o(syn_1_tmp[1815:1808]));
  gf_mult_by_90 m482 (.i(rx_data[1823:1816]),.o(syn_1_tmp[1823:1816]));
  gf_mult_by_3d m483 (.i(rx_data[1831:1824]),.o(syn_1_tmp[1831:1824]));
  gf_mult_by_7a m484 (.i(rx_data[1839:1832]),.o(syn_1_tmp[1839:1832]));
  gf_mult_by_f4 m485 (.i(rx_data[1847:1840]),.o(syn_1_tmp[1847:1840]));
  gf_mult_by_f5 m486 (.i(rx_data[1855:1848]),.o(syn_1_tmp[1855:1848]));
  gf_mult_by_f7 m487 (.i(rx_data[1863:1856]),.o(syn_1_tmp[1863:1856]));
  gf_mult_by_f3 m488 (.i(rx_data[1871:1864]),.o(syn_1_tmp[1871:1864]));
  gf_mult_by_fb m489 (.i(rx_data[1879:1872]),.o(syn_1_tmp[1879:1872]));
  gf_mult_by_eb m490 (.i(rx_data[1887:1880]),.o(syn_1_tmp[1887:1880]));
  gf_mult_by_cb m491 (.i(rx_data[1895:1888]),.o(syn_1_tmp[1895:1888]));
  gf_mult_by_8b m492 (.i(rx_data[1903:1896]),.o(syn_1_tmp[1903:1896]));
  gf_mult_by_0b m493 (.i(rx_data[1911:1904]),.o(syn_1_tmp[1911:1904]));
  gf_mult_by_16 m494 (.i(rx_data[1919:1912]),.o(syn_1_tmp[1919:1912]));
  gf_mult_by_2c m495 (.i(rx_data[1927:1920]),.o(syn_1_tmp[1927:1920]));
  gf_mult_by_58 m496 (.i(rx_data[1935:1928]),.o(syn_1_tmp[1935:1928]));
  gf_mult_by_b0 m497 (.i(rx_data[1943:1936]),.o(syn_1_tmp[1943:1936]));
  gf_mult_by_7d m498 (.i(rx_data[1951:1944]),.o(syn_1_tmp[1951:1944]));
  gf_mult_by_fa m499 (.i(rx_data[1959:1952]),.o(syn_1_tmp[1959:1952]));
  gf_mult_by_e9 m500 (.i(rx_data[1967:1960]),.o(syn_1_tmp[1967:1960]));
  gf_mult_by_cf m501 (.i(rx_data[1975:1968]),.o(syn_1_tmp[1975:1968]));
  gf_mult_by_83 m502 (.i(rx_data[1983:1976]),.o(syn_1_tmp[1983:1976]));
  gf_mult_by_1b m503 (.i(rx_data[1991:1984]),.o(syn_1_tmp[1991:1984]));
  gf_mult_by_36 m504 (.i(rx_data[1999:1992]),.o(syn_1_tmp[1999:1992]));
  gf_mult_by_6c m505 (.i(rx_data[2007:2000]),.o(syn_1_tmp[2007:2000]));
  gf_mult_by_d8 m506 (.i(rx_data[2015:2008]),.o(syn_1_tmp[2015:2008]));
  gf_mult_by_ad m507 (.i(rx_data[2023:2016]),.o(syn_1_tmp[2023:2016]));
  gf_mult_by_47 m508 (.i(rx_data[2031:2024]),.o(syn_1_tmp[2031:2024]));
  gf_mult_by_8e m509 (.i(rx_data[2039:2032]),.o(syn_1_tmp[2039:2032]));
  assign syndrome[15:8] =
      syn_1_tmp[7:0] ^ syn_1_tmp[15:8] ^ syn_1_tmp[23:16] ^ 
      syn_1_tmp[31:24] ^ syn_1_tmp[39:32] ^ syn_1_tmp[47:40] ^ 
      syn_1_tmp[55:48] ^ syn_1_tmp[63:56] ^ syn_1_tmp[71:64] ^ 
      syn_1_tmp[79:72] ^ syn_1_tmp[87:80] ^ syn_1_tmp[95:88] ^ 
      syn_1_tmp[103:96] ^ syn_1_tmp[111:104] ^ syn_1_tmp[119:112] ^ 
      syn_1_tmp[127:120] ^ syn_1_tmp[135:128] ^ syn_1_tmp[143:136] ^ 
      syn_1_tmp[151:144] ^ syn_1_tmp[159:152] ^ syn_1_tmp[167:160] ^ 
      syn_1_tmp[175:168] ^ syn_1_tmp[183:176] ^ syn_1_tmp[191:184] ^ 
      syn_1_tmp[199:192] ^ syn_1_tmp[207:200] ^ syn_1_tmp[215:208] ^ 
      syn_1_tmp[223:216] ^ syn_1_tmp[231:224] ^ syn_1_tmp[239:232] ^ 
      syn_1_tmp[247:240] ^ syn_1_tmp[255:248] ^ syn_1_tmp[263:256] ^ 
      syn_1_tmp[271:264] ^ syn_1_tmp[279:272] ^ syn_1_tmp[287:280] ^ 
      syn_1_tmp[295:288] ^ syn_1_tmp[303:296] ^ syn_1_tmp[311:304] ^ 
      syn_1_tmp[319:312] ^ syn_1_tmp[327:320] ^ syn_1_tmp[335:328] ^ 
      syn_1_tmp[343:336] ^ syn_1_tmp[351:344] ^ syn_1_tmp[359:352] ^ 
      syn_1_tmp[367:360] ^ syn_1_tmp[375:368] ^ syn_1_tmp[383:376] ^ 
      syn_1_tmp[391:384] ^ syn_1_tmp[399:392] ^ syn_1_tmp[407:400] ^ 
      syn_1_tmp[415:408] ^ syn_1_tmp[423:416] ^ syn_1_tmp[431:424] ^ 
      syn_1_tmp[439:432] ^ syn_1_tmp[447:440] ^ syn_1_tmp[455:448] ^ 
      syn_1_tmp[463:456] ^ syn_1_tmp[471:464] ^ syn_1_tmp[479:472] ^ 
      syn_1_tmp[487:480] ^ syn_1_tmp[495:488] ^ syn_1_tmp[503:496] ^ 
      syn_1_tmp[511:504] ^ syn_1_tmp[519:512] ^ syn_1_tmp[527:520] ^ 
      syn_1_tmp[535:528] ^ syn_1_tmp[543:536] ^ syn_1_tmp[551:544] ^ 
      syn_1_tmp[559:552] ^ syn_1_tmp[567:560] ^ syn_1_tmp[575:568] ^ 
      syn_1_tmp[583:576] ^ syn_1_tmp[591:584] ^ syn_1_tmp[599:592] ^ 
      syn_1_tmp[607:600] ^ syn_1_tmp[615:608] ^ syn_1_tmp[623:616] ^ 
      syn_1_tmp[631:624] ^ syn_1_tmp[639:632] ^ syn_1_tmp[647:640] ^ 
      syn_1_tmp[655:648] ^ syn_1_tmp[663:656] ^ syn_1_tmp[671:664] ^ 
      syn_1_tmp[679:672] ^ syn_1_tmp[687:680] ^ syn_1_tmp[695:688] ^ 
      syn_1_tmp[703:696] ^ syn_1_tmp[711:704] ^ syn_1_tmp[719:712] ^ 
      syn_1_tmp[727:720] ^ syn_1_tmp[735:728] ^ syn_1_tmp[743:736] ^ 
      syn_1_tmp[751:744] ^ syn_1_tmp[759:752] ^ syn_1_tmp[767:760] ^ 
      syn_1_tmp[775:768] ^ syn_1_tmp[783:776] ^ syn_1_tmp[791:784] ^ 
      syn_1_tmp[799:792] ^ syn_1_tmp[807:800] ^ syn_1_tmp[815:808] ^ 
      syn_1_tmp[823:816] ^ syn_1_tmp[831:824] ^ syn_1_tmp[839:832] ^ 
      syn_1_tmp[847:840] ^ syn_1_tmp[855:848] ^ syn_1_tmp[863:856] ^ 
      syn_1_tmp[871:864] ^ syn_1_tmp[879:872] ^ syn_1_tmp[887:880] ^ 
      syn_1_tmp[895:888] ^ syn_1_tmp[903:896] ^ syn_1_tmp[911:904] ^ 
      syn_1_tmp[919:912] ^ syn_1_tmp[927:920] ^ syn_1_tmp[935:928] ^ 
      syn_1_tmp[943:936] ^ syn_1_tmp[951:944] ^ syn_1_tmp[959:952] ^ 
      syn_1_tmp[967:960] ^ syn_1_tmp[975:968] ^ syn_1_tmp[983:976] ^ 
      syn_1_tmp[991:984] ^ syn_1_tmp[999:992] ^ syn_1_tmp[1007:1000] ^ 
      syn_1_tmp[1015:1008] ^ syn_1_tmp[1023:1016] ^ syn_1_tmp[1031:1024] ^ 
      syn_1_tmp[1039:1032] ^ syn_1_tmp[1047:1040] ^ syn_1_tmp[1055:1048] ^ 
      syn_1_tmp[1063:1056] ^ syn_1_tmp[1071:1064] ^ syn_1_tmp[1079:1072] ^ 
      syn_1_tmp[1087:1080] ^ syn_1_tmp[1095:1088] ^ syn_1_tmp[1103:1096] ^ 
      syn_1_tmp[1111:1104] ^ syn_1_tmp[1119:1112] ^ syn_1_tmp[1127:1120] ^ 
      syn_1_tmp[1135:1128] ^ syn_1_tmp[1143:1136] ^ syn_1_tmp[1151:1144] ^ 
      syn_1_tmp[1159:1152] ^ syn_1_tmp[1167:1160] ^ syn_1_tmp[1175:1168] ^ 
      syn_1_tmp[1183:1176] ^ syn_1_tmp[1191:1184] ^ syn_1_tmp[1199:1192] ^ 
      syn_1_tmp[1207:1200] ^ syn_1_tmp[1215:1208] ^ syn_1_tmp[1223:1216] ^ 
      syn_1_tmp[1231:1224] ^ syn_1_tmp[1239:1232] ^ syn_1_tmp[1247:1240] ^ 
      syn_1_tmp[1255:1248] ^ syn_1_tmp[1263:1256] ^ syn_1_tmp[1271:1264] ^ 
      syn_1_tmp[1279:1272] ^ syn_1_tmp[1287:1280] ^ syn_1_tmp[1295:1288] ^ 
      syn_1_tmp[1303:1296] ^ syn_1_tmp[1311:1304] ^ syn_1_tmp[1319:1312] ^ 
      syn_1_tmp[1327:1320] ^ syn_1_tmp[1335:1328] ^ syn_1_tmp[1343:1336] ^ 
      syn_1_tmp[1351:1344] ^ syn_1_tmp[1359:1352] ^ syn_1_tmp[1367:1360] ^ 
      syn_1_tmp[1375:1368] ^ syn_1_tmp[1383:1376] ^ syn_1_tmp[1391:1384] ^ 
      syn_1_tmp[1399:1392] ^ syn_1_tmp[1407:1400] ^ syn_1_tmp[1415:1408] ^ 
      syn_1_tmp[1423:1416] ^ syn_1_tmp[1431:1424] ^ syn_1_tmp[1439:1432] ^ 
      syn_1_tmp[1447:1440] ^ syn_1_tmp[1455:1448] ^ syn_1_tmp[1463:1456] ^ 
      syn_1_tmp[1471:1464] ^ syn_1_tmp[1479:1472] ^ syn_1_tmp[1487:1480] ^ 
      syn_1_tmp[1495:1488] ^ syn_1_tmp[1503:1496] ^ syn_1_tmp[1511:1504] ^ 
      syn_1_tmp[1519:1512] ^ syn_1_tmp[1527:1520] ^ syn_1_tmp[1535:1528] ^ 
      syn_1_tmp[1543:1536] ^ syn_1_tmp[1551:1544] ^ syn_1_tmp[1559:1552] ^ 
      syn_1_tmp[1567:1560] ^ syn_1_tmp[1575:1568] ^ syn_1_tmp[1583:1576] ^ 
      syn_1_tmp[1591:1584] ^ syn_1_tmp[1599:1592] ^ syn_1_tmp[1607:1600] ^ 
      syn_1_tmp[1615:1608] ^ syn_1_tmp[1623:1616] ^ syn_1_tmp[1631:1624] ^ 
      syn_1_tmp[1639:1632] ^ syn_1_tmp[1647:1640] ^ syn_1_tmp[1655:1648] ^ 
      syn_1_tmp[1663:1656] ^ syn_1_tmp[1671:1664] ^ syn_1_tmp[1679:1672] ^ 
      syn_1_tmp[1687:1680] ^ syn_1_tmp[1695:1688] ^ syn_1_tmp[1703:1696] ^ 
      syn_1_tmp[1711:1704] ^ syn_1_tmp[1719:1712] ^ syn_1_tmp[1727:1720] ^ 
      syn_1_tmp[1735:1728] ^ syn_1_tmp[1743:1736] ^ syn_1_tmp[1751:1744] ^ 
      syn_1_tmp[1759:1752] ^ syn_1_tmp[1767:1760] ^ syn_1_tmp[1775:1768] ^ 
      syn_1_tmp[1783:1776] ^ syn_1_tmp[1791:1784] ^ syn_1_tmp[1799:1792] ^ 
      syn_1_tmp[1807:1800] ^ syn_1_tmp[1815:1808] ^ syn_1_tmp[1823:1816] ^ 
      syn_1_tmp[1831:1824] ^ syn_1_tmp[1839:1832] ^ syn_1_tmp[1847:1840] ^ 
      syn_1_tmp[1855:1848] ^ syn_1_tmp[1863:1856] ^ syn_1_tmp[1871:1864] ^ 
      syn_1_tmp[1879:1872] ^ syn_1_tmp[1887:1880] ^ syn_1_tmp[1895:1888] ^ 
      syn_1_tmp[1903:1896] ^ syn_1_tmp[1911:1904] ^ syn_1_tmp[1919:1912] ^ 
      syn_1_tmp[1927:1920] ^ syn_1_tmp[1935:1928] ^ syn_1_tmp[1943:1936] ^ 
      syn_1_tmp[1951:1944] ^ syn_1_tmp[1959:1952] ^ syn_1_tmp[1967:1960] ^ 
      syn_1_tmp[1975:1968] ^ syn_1_tmp[1983:1976] ^ syn_1_tmp[1991:1984] ^ 
      syn_1_tmp[1999:1992] ^ syn_1_tmp[2007:2000] ^ syn_1_tmp[2015:2008] ^ 
      syn_1_tmp[2023:2016] ^ syn_1_tmp[2031:2024] ^ syn_1_tmp[2039:2032];

// syndrome 2
  wire [2039:0] syn_2_tmp;
  gf_mult_by_01 m510 (.i(rx_data[7:0]),.o(syn_2_tmp[7:0]));
  gf_mult_by_04 m511 (.i(rx_data[15:8]),.o(syn_2_tmp[15:8]));
  gf_mult_by_10 m512 (.i(rx_data[23:16]),.o(syn_2_tmp[23:16]));
  gf_mult_by_40 m513 (.i(rx_data[31:24]),.o(syn_2_tmp[31:24]));
  gf_mult_by_1d m514 (.i(rx_data[39:32]),.o(syn_2_tmp[39:32]));
  gf_mult_by_74 m515 (.i(rx_data[47:40]),.o(syn_2_tmp[47:40]));
  gf_mult_by_cd m516 (.i(rx_data[55:48]),.o(syn_2_tmp[55:48]));
  gf_mult_by_13 m517 (.i(rx_data[63:56]),.o(syn_2_tmp[63:56]));
  gf_mult_by_4c m518 (.i(rx_data[71:64]),.o(syn_2_tmp[71:64]));
  gf_mult_by_2d m519 (.i(rx_data[79:72]),.o(syn_2_tmp[79:72]));
  gf_mult_by_b4 m520 (.i(rx_data[87:80]),.o(syn_2_tmp[87:80]));
  gf_mult_by_ea m521 (.i(rx_data[95:88]),.o(syn_2_tmp[95:88]));
  gf_mult_by_8f m522 (.i(rx_data[103:96]),.o(syn_2_tmp[103:96]));
  gf_mult_by_06 m523 (.i(rx_data[111:104]),.o(syn_2_tmp[111:104]));
  gf_mult_by_18 m524 (.i(rx_data[119:112]),.o(syn_2_tmp[119:112]));
  gf_mult_by_60 m525 (.i(rx_data[127:120]),.o(syn_2_tmp[127:120]));
  gf_mult_by_9d m526 (.i(rx_data[135:128]),.o(syn_2_tmp[135:128]));
  gf_mult_by_4e m527 (.i(rx_data[143:136]),.o(syn_2_tmp[143:136]));
  gf_mult_by_25 m528 (.i(rx_data[151:144]),.o(syn_2_tmp[151:144]));
  gf_mult_by_94 m529 (.i(rx_data[159:152]),.o(syn_2_tmp[159:152]));
  gf_mult_by_6a m530 (.i(rx_data[167:160]),.o(syn_2_tmp[167:160]));
  gf_mult_by_b5 m531 (.i(rx_data[175:168]),.o(syn_2_tmp[175:168]));
  gf_mult_by_ee m532 (.i(rx_data[183:176]),.o(syn_2_tmp[183:176]));
  gf_mult_by_9f m533 (.i(rx_data[191:184]),.o(syn_2_tmp[191:184]));
  gf_mult_by_46 m534 (.i(rx_data[199:192]),.o(syn_2_tmp[199:192]));
  gf_mult_by_05 m535 (.i(rx_data[207:200]),.o(syn_2_tmp[207:200]));
  gf_mult_by_14 m536 (.i(rx_data[215:208]),.o(syn_2_tmp[215:208]));
  gf_mult_by_50 m537 (.i(rx_data[223:216]),.o(syn_2_tmp[223:216]));
  gf_mult_by_5d m538 (.i(rx_data[231:224]),.o(syn_2_tmp[231:224]));
  gf_mult_by_69 m539 (.i(rx_data[239:232]),.o(syn_2_tmp[239:232]));
  gf_mult_by_b9 m540 (.i(rx_data[247:240]),.o(syn_2_tmp[247:240]));
  gf_mult_by_de m541 (.i(rx_data[255:248]),.o(syn_2_tmp[255:248]));
  gf_mult_by_5f m542 (.i(rx_data[263:256]),.o(syn_2_tmp[263:256]));
  gf_mult_by_61 m543 (.i(rx_data[271:264]),.o(syn_2_tmp[271:264]));
  gf_mult_by_99 m544 (.i(rx_data[279:272]),.o(syn_2_tmp[279:272]));
  gf_mult_by_5e m545 (.i(rx_data[287:280]),.o(syn_2_tmp[287:280]));
  gf_mult_by_65 m546 (.i(rx_data[295:288]),.o(syn_2_tmp[295:288]));
  gf_mult_by_89 m547 (.i(rx_data[303:296]),.o(syn_2_tmp[303:296]));
  gf_mult_by_1e m548 (.i(rx_data[311:304]),.o(syn_2_tmp[311:304]));
  gf_mult_by_78 m549 (.i(rx_data[319:312]),.o(syn_2_tmp[319:312]));
  gf_mult_by_fd m550 (.i(rx_data[327:320]),.o(syn_2_tmp[327:320]));
  gf_mult_by_d3 m551 (.i(rx_data[335:328]),.o(syn_2_tmp[335:328]));
  gf_mult_by_6b m552 (.i(rx_data[343:336]),.o(syn_2_tmp[343:336]));
  gf_mult_by_b1 m553 (.i(rx_data[351:344]),.o(syn_2_tmp[351:344]));
  gf_mult_by_fe m554 (.i(rx_data[359:352]),.o(syn_2_tmp[359:352]));
  gf_mult_by_df m555 (.i(rx_data[367:360]),.o(syn_2_tmp[367:360]));
  gf_mult_by_5b m556 (.i(rx_data[375:368]),.o(syn_2_tmp[375:368]));
  gf_mult_by_71 m557 (.i(rx_data[383:376]),.o(syn_2_tmp[383:376]));
  gf_mult_by_d9 m558 (.i(rx_data[391:384]),.o(syn_2_tmp[391:384]));
  gf_mult_by_43 m559 (.i(rx_data[399:392]),.o(syn_2_tmp[399:392]));
  gf_mult_by_11 m560 (.i(rx_data[407:400]),.o(syn_2_tmp[407:400]));
  gf_mult_by_44 m561 (.i(rx_data[415:408]),.o(syn_2_tmp[415:408]));
  gf_mult_by_0d m562 (.i(rx_data[423:416]),.o(syn_2_tmp[423:416]));
  gf_mult_by_34 m563 (.i(rx_data[431:424]),.o(syn_2_tmp[431:424]));
  gf_mult_by_d0 m564 (.i(rx_data[439:432]),.o(syn_2_tmp[439:432]));
  gf_mult_by_67 m565 (.i(rx_data[447:440]),.o(syn_2_tmp[447:440]));
  gf_mult_by_81 m566 (.i(rx_data[455:448]),.o(syn_2_tmp[455:448]));
  gf_mult_by_3e m567 (.i(rx_data[463:456]),.o(syn_2_tmp[463:456]));
  gf_mult_by_f8 m568 (.i(rx_data[471:464]),.o(syn_2_tmp[471:464]));
  gf_mult_by_c7 m569 (.i(rx_data[479:472]),.o(syn_2_tmp[479:472]));
  gf_mult_by_3b m570 (.i(rx_data[487:480]),.o(syn_2_tmp[487:480]));
  gf_mult_by_ec m571 (.i(rx_data[495:488]),.o(syn_2_tmp[495:488]));
  gf_mult_by_97 m572 (.i(rx_data[503:496]),.o(syn_2_tmp[503:496]));
  gf_mult_by_66 m573 (.i(rx_data[511:504]),.o(syn_2_tmp[511:504]));
  gf_mult_by_85 m574 (.i(rx_data[519:512]),.o(syn_2_tmp[519:512]));
  gf_mult_by_2e m575 (.i(rx_data[527:520]),.o(syn_2_tmp[527:520]));
  gf_mult_by_b8 m576 (.i(rx_data[535:528]),.o(syn_2_tmp[535:528]));
  gf_mult_by_da m577 (.i(rx_data[543:536]),.o(syn_2_tmp[543:536]));
  gf_mult_by_4f m578 (.i(rx_data[551:544]),.o(syn_2_tmp[551:544]));
  gf_mult_by_21 m579 (.i(rx_data[559:552]),.o(syn_2_tmp[559:552]));
  gf_mult_by_84 m580 (.i(rx_data[567:560]),.o(syn_2_tmp[567:560]));
  gf_mult_by_2a m581 (.i(rx_data[575:568]),.o(syn_2_tmp[575:568]));
  gf_mult_by_a8 m582 (.i(rx_data[583:576]),.o(syn_2_tmp[583:576]));
  gf_mult_by_9a m583 (.i(rx_data[591:584]),.o(syn_2_tmp[591:584]));
  gf_mult_by_52 m584 (.i(rx_data[599:592]),.o(syn_2_tmp[599:592]));
  gf_mult_by_55 m585 (.i(rx_data[607:600]),.o(syn_2_tmp[607:600]));
  gf_mult_by_49 m586 (.i(rx_data[615:608]),.o(syn_2_tmp[615:608]));
  gf_mult_by_39 m587 (.i(rx_data[623:616]),.o(syn_2_tmp[623:616]));
  gf_mult_by_e4 m588 (.i(rx_data[631:624]),.o(syn_2_tmp[631:624]));
  gf_mult_by_b7 m589 (.i(rx_data[639:632]),.o(syn_2_tmp[639:632]));
  gf_mult_by_e6 m590 (.i(rx_data[647:640]),.o(syn_2_tmp[647:640]));
  gf_mult_by_bf m591 (.i(rx_data[655:648]),.o(syn_2_tmp[655:648]));
  gf_mult_by_c6 m592 (.i(rx_data[663:656]),.o(syn_2_tmp[663:656]));
  gf_mult_by_3f m593 (.i(rx_data[671:664]),.o(syn_2_tmp[671:664]));
  gf_mult_by_fc m594 (.i(rx_data[679:672]),.o(syn_2_tmp[679:672]));
  gf_mult_by_d7 m595 (.i(rx_data[687:680]),.o(syn_2_tmp[687:680]));
  gf_mult_by_7b m596 (.i(rx_data[695:688]),.o(syn_2_tmp[695:688]));
  gf_mult_by_f1 m597 (.i(rx_data[703:696]),.o(syn_2_tmp[703:696]));
  gf_mult_by_e3 m598 (.i(rx_data[711:704]),.o(syn_2_tmp[711:704]));
  gf_mult_by_ab m599 (.i(rx_data[719:712]),.o(syn_2_tmp[719:712]));
  gf_mult_by_96 m600 (.i(rx_data[727:720]),.o(syn_2_tmp[727:720]));
  gf_mult_by_62 m601 (.i(rx_data[735:728]),.o(syn_2_tmp[735:728]));
  gf_mult_by_95 m602 (.i(rx_data[743:736]),.o(syn_2_tmp[743:736]));
  gf_mult_by_6e m603 (.i(rx_data[751:744]),.o(syn_2_tmp[751:744]));
  gf_mult_by_a5 m604 (.i(rx_data[759:752]),.o(syn_2_tmp[759:752]));
  gf_mult_by_ae m605 (.i(rx_data[767:760]),.o(syn_2_tmp[767:760]));
  gf_mult_by_82 m606 (.i(rx_data[775:768]),.o(syn_2_tmp[775:768]));
  gf_mult_by_32 m607 (.i(rx_data[783:776]),.o(syn_2_tmp[783:776]));
  gf_mult_by_c8 m608 (.i(rx_data[791:784]),.o(syn_2_tmp[791:784]));
  gf_mult_by_07 m609 (.i(rx_data[799:792]),.o(syn_2_tmp[799:792]));
  gf_mult_by_1c m610 (.i(rx_data[807:800]),.o(syn_2_tmp[807:800]));
  gf_mult_by_70 m611 (.i(rx_data[815:808]),.o(syn_2_tmp[815:808]));
  gf_mult_by_dd m612 (.i(rx_data[823:816]),.o(syn_2_tmp[823:816]));
  gf_mult_by_53 m613 (.i(rx_data[831:824]),.o(syn_2_tmp[831:824]));
  gf_mult_by_51 m614 (.i(rx_data[839:832]),.o(syn_2_tmp[839:832]));
  gf_mult_by_59 m615 (.i(rx_data[847:840]),.o(syn_2_tmp[847:840]));
  gf_mult_by_79 m616 (.i(rx_data[855:848]),.o(syn_2_tmp[855:848]));
  gf_mult_by_f9 m617 (.i(rx_data[863:856]),.o(syn_2_tmp[863:856]));
  gf_mult_by_c3 m618 (.i(rx_data[871:864]),.o(syn_2_tmp[871:864]));
  gf_mult_by_2b m619 (.i(rx_data[879:872]),.o(syn_2_tmp[879:872]));
  gf_mult_by_ac m620 (.i(rx_data[887:880]),.o(syn_2_tmp[887:880]));
  gf_mult_by_8a m621 (.i(rx_data[895:888]),.o(syn_2_tmp[895:888]));
  gf_mult_by_12 m622 (.i(rx_data[903:896]),.o(syn_2_tmp[903:896]));
  gf_mult_by_48 m623 (.i(rx_data[911:904]),.o(syn_2_tmp[911:904]));
  gf_mult_by_3d m624 (.i(rx_data[919:912]),.o(syn_2_tmp[919:912]));
  gf_mult_by_f4 m625 (.i(rx_data[927:920]),.o(syn_2_tmp[927:920]));
  gf_mult_by_f7 m626 (.i(rx_data[935:928]),.o(syn_2_tmp[935:928]));
  gf_mult_by_fb m627 (.i(rx_data[943:936]),.o(syn_2_tmp[943:936]));
  gf_mult_by_cb m628 (.i(rx_data[951:944]),.o(syn_2_tmp[951:944]));
  gf_mult_by_0b m629 (.i(rx_data[959:952]),.o(syn_2_tmp[959:952]));
  gf_mult_by_2c m630 (.i(rx_data[967:960]),.o(syn_2_tmp[967:960]));
  gf_mult_by_b0 m631 (.i(rx_data[975:968]),.o(syn_2_tmp[975:968]));
  gf_mult_by_fa m632 (.i(rx_data[983:976]),.o(syn_2_tmp[983:976]));
  gf_mult_by_cf m633 (.i(rx_data[991:984]),.o(syn_2_tmp[991:984]));
  gf_mult_by_1b m634 (.i(rx_data[999:992]),.o(syn_2_tmp[999:992]));
  gf_mult_by_6c m635 (.i(rx_data[1007:1000]),.o(syn_2_tmp[1007:1000]));
  gf_mult_by_ad m636 (.i(rx_data[1015:1008]),.o(syn_2_tmp[1015:1008]));
  gf_mult_by_8e m637 (.i(rx_data[1023:1016]),.o(syn_2_tmp[1023:1016]));
  gf_mult_by_02 m638 (.i(rx_data[1031:1024]),.o(syn_2_tmp[1031:1024]));
  gf_mult_by_08 m639 (.i(rx_data[1039:1032]),.o(syn_2_tmp[1039:1032]));
  gf_mult_by_20 m640 (.i(rx_data[1047:1040]),.o(syn_2_tmp[1047:1040]));
  gf_mult_by_80 m641 (.i(rx_data[1055:1048]),.o(syn_2_tmp[1055:1048]));
  gf_mult_by_3a m642 (.i(rx_data[1063:1056]),.o(syn_2_tmp[1063:1056]));
  gf_mult_by_e8 m643 (.i(rx_data[1071:1064]),.o(syn_2_tmp[1071:1064]));
  gf_mult_by_87 m644 (.i(rx_data[1079:1072]),.o(syn_2_tmp[1079:1072]));
  gf_mult_by_26 m645 (.i(rx_data[1087:1080]),.o(syn_2_tmp[1087:1080]));
  gf_mult_by_98 m646 (.i(rx_data[1095:1088]),.o(syn_2_tmp[1095:1088]));
  gf_mult_by_5a m647 (.i(rx_data[1103:1096]),.o(syn_2_tmp[1103:1096]));
  gf_mult_by_75 m648 (.i(rx_data[1111:1104]),.o(syn_2_tmp[1111:1104]));
  gf_mult_by_c9 m649 (.i(rx_data[1119:1112]),.o(syn_2_tmp[1119:1112]));
  gf_mult_by_03 m650 (.i(rx_data[1127:1120]),.o(syn_2_tmp[1127:1120]));
  gf_mult_by_0c m651 (.i(rx_data[1135:1128]),.o(syn_2_tmp[1135:1128]));
  gf_mult_by_30 m652 (.i(rx_data[1143:1136]),.o(syn_2_tmp[1143:1136]));
  gf_mult_by_c0 m653 (.i(rx_data[1151:1144]),.o(syn_2_tmp[1151:1144]));
  gf_mult_by_27 m654 (.i(rx_data[1159:1152]),.o(syn_2_tmp[1159:1152]));
  gf_mult_by_9c m655 (.i(rx_data[1167:1160]),.o(syn_2_tmp[1167:1160]));
  gf_mult_by_4a m656 (.i(rx_data[1175:1168]),.o(syn_2_tmp[1175:1168]));
  gf_mult_by_35 m657 (.i(rx_data[1183:1176]),.o(syn_2_tmp[1183:1176]));
  gf_mult_by_d4 m658 (.i(rx_data[1191:1184]),.o(syn_2_tmp[1191:1184]));
  gf_mult_by_77 m659 (.i(rx_data[1199:1192]),.o(syn_2_tmp[1199:1192]));
  gf_mult_by_c1 m660 (.i(rx_data[1207:1200]),.o(syn_2_tmp[1207:1200]));
  gf_mult_by_23 m661 (.i(rx_data[1215:1208]),.o(syn_2_tmp[1215:1208]));
  gf_mult_by_8c m662 (.i(rx_data[1223:1216]),.o(syn_2_tmp[1223:1216]));
  gf_mult_by_0a m663 (.i(rx_data[1231:1224]),.o(syn_2_tmp[1231:1224]));
  gf_mult_by_28 m664 (.i(rx_data[1239:1232]),.o(syn_2_tmp[1239:1232]));
  gf_mult_by_a0 m665 (.i(rx_data[1247:1240]),.o(syn_2_tmp[1247:1240]));
  gf_mult_by_ba m666 (.i(rx_data[1255:1248]),.o(syn_2_tmp[1255:1248]));
  gf_mult_by_d2 m667 (.i(rx_data[1263:1256]),.o(syn_2_tmp[1263:1256]));
  gf_mult_by_6f m668 (.i(rx_data[1271:1264]),.o(syn_2_tmp[1271:1264]));
  gf_mult_by_a1 m669 (.i(rx_data[1279:1272]),.o(syn_2_tmp[1279:1272]));
  gf_mult_by_be m670 (.i(rx_data[1287:1280]),.o(syn_2_tmp[1287:1280]));
  gf_mult_by_c2 m671 (.i(rx_data[1295:1288]),.o(syn_2_tmp[1295:1288]));
  gf_mult_by_2f m672 (.i(rx_data[1303:1296]),.o(syn_2_tmp[1303:1296]));
  gf_mult_by_bc m673 (.i(rx_data[1311:1304]),.o(syn_2_tmp[1311:1304]));
  gf_mult_by_ca m674 (.i(rx_data[1319:1312]),.o(syn_2_tmp[1319:1312]));
  gf_mult_by_0f m675 (.i(rx_data[1327:1320]),.o(syn_2_tmp[1327:1320]));
  gf_mult_by_3c m676 (.i(rx_data[1335:1328]),.o(syn_2_tmp[1335:1328]));
  gf_mult_by_f0 m677 (.i(rx_data[1343:1336]),.o(syn_2_tmp[1343:1336]));
  gf_mult_by_e7 m678 (.i(rx_data[1351:1344]),.o(syn_2_tmp[1351:1344]));
  gf_mult_by_bb m679 (.i(rx_data[1359:1352]),.o(syn_2_tmp[1359:1352]));
  gf_mult_by_d6 m680 (.i(rx_data[1367:1360]),.o(syn_2_tmp[1367:1360]));
  gf_mult_by_7f m681 (.i(rx_data[1375:1368]),.o(syn_2_tmp[1375:1368]));
  gf_mult_by_e1 m682 (.i(rx_data[1383:1376]),.o(syn_2_tmp[1383:1376]));
  gf_mult_by_a3 m683 (.i(rx_data[1391:1384]),.o(syn_2_tmp[1391:1384]));
  gf_mult_by_b6 m684 (.i(rx_data[1399:1392]),.o(syn_2_tmp[1399:1392]));
  gf_mult_by_e2 m685 (.i(rx_data[1407:1400]),.o(syn_2_tmp[1407:1400]));
  gf_mult_by_af m686 (.i(rx_data[1415:1408]),.o(syn_2_tmp[1415:1408]));
  gf_mult_by_86 m687 (.i(rx_data[1423:1416]),.o(syn_2_tmp[1423:1416]));
  gf_mult_by_22 m688 (.i(rx_data[1431:1424]),.o(syn_2_tmp[1431:1424]));
  gf_mult_by_88 m689 (.i(rx_data[1439:1432]),.o(syn_2_tmp[1439:1432]));
  gf_mult_by_1a m690 (.i(rx_data[1447:1440]),.o(syn_2_tmp[1447:1440]));
  gf_mult_by_68 m691 (.i(rx_data[1455:1448]),.o(syn_2_tmp[1455:1448]));
  gf_mult_by_bd m692 (.i(rx_data[1463:1456]),.o(syn_2_tmp[1463:1456]));
  gf_mult_by_ce m693 (.i(rx_data[1471:1464]),.o(syn_2_tmp[1471:1464]));
  gf_mult_by_1f m694 (.i(rx_data[1479:1472]),.o(syn_2_tmp[1479:1472]));
  gf_mult_by_7c m695 (.i(rx_data[1487:1480]),.o(syn_2_tmp[1487:1480]));
  gf_mult_by_ed m696 (.i(rx_data[1495:1488]),.o(syn_2_tmp[1495:1488]));
  gf_mult_by_93 m697 (.i(rx_data[1503:1496]),.o(syn_2_tmp[1503:1496]));
  gf_mult_by_76 m698 (.i(rx_data[1511:1504]),.o(syn_2_tmp[1511:1504]));
  gf_mult_by_c5 m699 (.i(rx_data[1519:1512]),.o(syn_2_tmp[1519:1512]));
  gf_mult_by_33 m700 (.i(rx_data[1527:1520]),.o(syn_2_tmp[1527:1520]));
  gf_mult_by_cc m701 (.i(rx_data[1535:1528]),.o(syn_2_tmp[1535:1528]));
  gf_mult_by_17 m702 (.i(rx_data[1543:1536]),.o(syn_2_tmp[1543:1536]));
  gf_mult_by_5c m703 (.i(rx_data[1551:1544]),.o(syn_2_tmp[1551:1544]));
  gf_mult_by_6d m704 (.i(rx_data[1559:1552]),.o(syn_2_tmp[1559:1552]));
  gf_mult_by_a9 m705 (.i(rx_data[1567:1560]),.o(syn_2_tmp[1567:1560]));
  gf_mult_by_9e m706 (.i(rx_data[1575:1568]),.o(syn_2_tmp[1575:1568]));
  gf_mult_by_42 m707 (.i(rx_data[1583:1576]),.o(syn_2_tmp[1583:1576]));
  gf_mult_by_15 m708 (.i(rx_data[1591:1584]),.o(syn_2_tmp[1591:1584]));
  gf_mult_by_54 m709 (.i(rx_data[1599:1592]),.o(syn_2_tmp[1599:1592]));
  gf_mult_by_4d m710 (.i(rx_data[1607:1600]),.o(syn_2_tmp[1607:1600]));
  gf_mult_by_29 m711 (.i(rx_data[1615:1608]),.o(syn_2_tmp[1615:1608]));
  gf_mult_by_a4 m712 (.i(rx_data[1623:1616]),.o(syn_2_tmp[1623:1616]));
  gf_mult_by_aa m713 (.i(rx_data[1631:1624]),.o(syn_2_tmp[1631:1624]));
  gf_mult_by_92 m714 (.i(rx_data[1639:1632]),.o(syn_2_tmp[1639:1632]));
  gf_mult_by_72 m715 (.i(rx_data[1647:1640]),.o(syn_2_tmp[1647:1640]));
  gf_mult_by_d5 m716 (.i(rx_data[1655:1648]),.o(syn_2_tmp[1655:1648]));
  gf_mult_by_73 m717 (.i(rx_data[1663:1656]),.o(syn_2_tmp[1663:1656]));
  gf_mult_by_d1 m718 (.i(rx_data[1671:1664]),.o(syn_2_tmp[1671:1664]));
  gf_mult_by_63 m719 (.i(rx_data[1679:1672]),.o(syn_2_tmp[1679:1672]));
  gf_mult_by_91 m720 (.i(rx_data[1687:1680]),.o(syn_2_tmp[1687:1680]));
  gf_mult_by_7e m721 (.i(rx_data[1695:1688]),.o(syn_2_tmp[1695:1688]));
  gf_mult_by_e5 m722 (.i(rx_data[1703:1696]),.o(syn_2_tmp[1703:1696]));
  gf_mult_by_b3 m723 (.i(rx_data[1711:1704]),.o(syn_2_tmp[1711:1704]));
  gf_mult_by_f6 m724 (.i(rx_data[1719:1712]),.o(syn_2_tmp[1719:1712]));
  gf_mult_by_ff m725 (.i(rx_data[1727:1720]),.o(syn_2_tmp[1727:1720]));
  gf_mult_by_db m726 (.i(rx_data[1735:1728]),.o(syn_2_tmp[1735:1728]));
  gf_mult_by_4b m727 (.i(rx_data[1743:1736]),.o(syn_2_tmp[1743:1736]));
  gf_mult_by_31 m728 (.i(rx_data[1751:1744]),.o(syn_2_tmp[1751:1744]));
  gf_mult_by_c4 m729 (.i(rx_data[1759:1752]),.o(syn_2_tmp[1759:1752]));
  gf_mult_by_37 m730 (.i(rx_data[1767:1760]),.o(syn_2_tmp[1767:1760]));
  gf_mult_by_dc m731 (.i(rx_data[1775:1768]),.o(syn_2_tmp[1775:1768]));
  gf_mult_by_57 m732 (.i(rx_data[1783:1776]),.o(syn_2_tmp[1783:1776]));
  gf_mult_by_41 m733 (.i(rx_data[1791:1784]),.o(syn_2_tmp[1791:1784]));
  gf_mult_by_19 m734 (.i(rx_data[1799:1792]),.o(syn_2_tmp[1799:1792]));
  gf_mult_by_64 m735 (.i(rx_data[1807:1800]),.o(syn_2_tmp[1807:1800]));
  gf_mult_by_8d m736 (.i(rx_data[1815:1808]),.o(syn_2_tmp[1815:1808]));
  gf_mult_by_0e m737 (.i(rx_data[1823:1816]),.o(syn_2_tmp[1823:1816]));
  gf_mult_by_38 m738 (.i(rx_data[1831:1824]),.o(syn_2_tmp[1831:1824]));
  gf_mult_by_e0 m739 (.i(rx_data[1839:1832]),.o(syn_2_tmp[1839:1832]));
  gf_mult_by_a7 m740 (.i(rx_data[1847:1840]),.o(syn_2_tmp[1847:1840]));
  gf_mult_by_a6 m741 (.i(rx_data[1855:1848]),.o(syn_2_tmp[1855:1848]));
  gf_mult_by_a2 m742 (.i(rx_data[1863:1856]),.o(syn_2_tmp[1863:1856]));
  gf_mult_by_b2 m743 (.i(rx_data[1871:1864]),.o(syn_2_tmp[1871:1864]));
  gf_mult_by_f2 m744 (.i(rx_data[1879:1872]),.o(syn_2_tmp[1879:1872]));
  gf_mult_by_ef m745 (.i(rx_data[1887:1880]),.o(syn_2_tmp[1887:1880]));
  gf_mult_by_9b m746 (.i(rx_data[1895:1888]),.o(syn_2_tmp[1895:1888]));
  gf_mult_by_56 m747 (.i(rx_data[1903:1896]),.o(syn_2_tmp[1903:1896]));
  gf_mult_by_45 m748 (.i(rx_data[1911:1904]),.o(syn_2_tmp[1911:1904]));
  gf_mult_by_09 m749 (.i(rx_data[1919:1912]),.o(syn_2_tmp[1919:1912]));
  gf_mult_by_24 m750 (.i(rx_data[1927:1920]),.o(syn_2_tmp[1927:1920]));
  gf_mult_by_90 m751 (.i(rx_data[1935:1928]),.o(syn_2_tmp[1935:1928]));
  gf_mult_by_7a m752 (.i(rx_data[1943:1936]),.o(syn_2_tmp[1943:1936]));
  gf_mult_by_f5 m753 (.i(rx_data[1951:1944]),.o(syn_2_tmp[1951:1944]));
  gf_mult_by_f3 m754 (.i(rx_data[1959:1952]),.o(syn_2_tmp[1959:1952]));
  gf_mult_by_eb m755 (.i(rx_data[1967:1960]),.o(syn_2_tmp[1967:1960]));
  gf_mult_by_8b m756 (.i(rx_data[1975:1968]),.o(syn_2_tmp[1975:1968]));
  gf_mult_by_16 m757 (.i(rx_data[1983:1976]),.o(syn_2_tmp[1983:1976]));
  gf_mult_by_58 m758 (.i(rx_data[1991:1984]),.o(syn_2_tmp[1991:1984]));
  gf_mult_by_7d m759 (.i(rx_data[1999:1992]),.o(syn_2_tmp[1999:1992]));
  gf_mult_by_e9 m760 (.i(rx_data[2007:2000]),.o(syn_2_tmp[2007:2000]));
  gf_mult_by_83 m761 (.i(rx_data[2015:2008]),.o(syn_2_tmp[2015:2008]));
  gf_mult_by_36 m762 (.i(rx_data[2023:2016]),.o(syn_2_tmp[2023:2016]));
  gf_mult_by_d8 m763 (.i(rx_data[2031:2024]),.o(syn_2_tmp[2031:2024]));
  gf_mult_by_47 m764 (.i(rx_data[2039:2032]),.o(syn_2_tmp[2039:2032]));
  assign syndrome[23:16] =
      syn_2_tmp[7:0] ^ syn_2_tmp[15:8] ^ syn_2_tmp[23:16] ^ 
      syn_2_tmp[31:24] ^ syn_2_tmp[39:32] ^ syn_2_tmp[47:40] ^ 
      syn_2_tmp[55:48] ^ syn_2_tmp[63:56] ^ syn_2_tmp[71:64] ^ 
      syn_2_tmp[79:72] ^ syn_2_tmp[87:80] ^ syn_2_tmp[95:88] ^ 
      syn_2_tmp[103:96] ^ syn_2_tmp[111:104] ^ syn_2_tmp[119:112] ^ 
      syn_2_tmp[127:120] ^ syn_2_tmp[135:128] ^ syn_2_tmp[143:136] ^ 
      syn_2_tmp[151:144] ^ syn_2_tmp[159:152] ^ syn_2_tmp[167:160] ^ 
      syn_2_tmp[175:168] ^ syn_2_tmp[183:176] ^ syn_2_tmp[191:184] ^ 
      syn_2_tmp[199:192] ^ syn_2_tmp[207:200] ^ syn_2_tmp[215:208] ^ 
      syn_2_tmp[223:216] ^ syn_2_tmp[231:224] ^ syn_2_tmp[239:232] ^ 
      syn_2_tmp[247:240] ^ syn_2_tmp[255:248] ^ syn_2_tmp[263:256] ^ 
      syn_2_tmp[271:264] ^ syn_2_tmp[279:272] ^ syn_2_tmp[287:280] ^ 
      syn_2_tmp[295:288] ^ syn_2_tmp[303:296] ^ syn_2_tmp[311:304] ^ 
      syn_2_tmp[319:312] ^ syn_2_tmp[327:320] ^ syn_2_tmp[335:328] ^ 
      syn_2_tmp[343:336] ^ syn_2_tmp[351:344] ^ syn_2_tmp[359:352] ^ 
      syn_2_tmp[367:360] ^ syn_2_tmp[375:368] ^ syn_2_tmp[383:376] ^ 
      syn_2_tmp[391:384] ^ syn_2_tmp[399:392] ^ syn_2_tmp[407:400] ^ 
      syn_2_tmp[415:408] ^ syn_2_tmp[423:416] ^ syn_2_tmp[431:424] ^ 
      syn_2_tmp[439:432] ^ syn_2_tmp[447:440] ^ syn_2_tmp[455:448] ^ 
      syn_2_tmp[463:456] ^ syn_2_tmp[471:464] ^ syn_2_tmp[479:472] ^ 
      syn_2_tmp[487:480] ^ syn_2_tmp[495:488] ^ syn_2_tmp[503:496] ^ 
      syn_2_tmp[511:504] ^ syn_2_tmp[519:512] ^ syn_2_tmp[527:520] ^ 
      syn_2_tmp[535:528] ^ syn_2_tmp[543:536] ^ syn_2_tmp[551:544] ^ 
      syn_2_tmp[559:552] ^ syn_2_tmp[567:560] ^ syn_2_tmp[575:568] ^ 
      syn_2_tmp[583:576] ^ syn_2_tmp[591:584] ^ syn_2_tmp[599:592] ^ 
      syn_2_tmp[607:600] ^ syn_2_tmp[615:608] ^ syn_2_tmp[623:616] ^ 
      syn_2_tmp[631:624] ^ syn_2_tmp[639:632] ^ syn_2_tmp[647:640] ^ 
      syn_2_tmp[655:648] ^ syn_2_tmp[663:656] ^ syn_2_tmp[671:664] ^ 
      syn_2_tmp[679:672] ^ syn_2_tmp[687:680] ^ syn_2_tmp[695:688] ^ 
      syn_2_tmp[703:696] ^ syn_2_tmp[711:704] ^ syn_2_tmp[719:712] ^ 
      syn_2_tmp[727:720] ^ syn_2_tmp[735:728] ^ syn_2_tmp[743:736] ^ 
      syn_2_tmp[751:744] ^ syn_2_tmp[759:752] ^ syn_2_tmp[767:760] ^ 
      syn_2_tmp[775:768] ^ syn_2_tmp[783:776] ^ syn_2_tmp[791:784] ^ 
      syn_2_tmp[799:792] ^ syn_2_tmp[807:800] ^ syn_2_tmp[815:808] ^ 
      syn_2_tmp[823:816] ^ syn_2_tmp[831:824] ^ syn_2_tmp[839:832] ^ 
      syn_2_tmp[847:840] ^ syn_2_tmp[855:848] ^ syn_2_tmp[863:856] ^ 
      syn_2_tmp[871:864] ^ syn_2_tmp[879:872] ^ syn_2_tmp[887:880] ^ 
      syn_2_tmp[895:888] ^ syn_2_tmp[903:896] ^ syn_2_tmp[911:904] ^ 
      syn_2_tmp[919:912] ^ syn_2_tmp[927:920] ^ syn_2_tmp[935:928] ^ 
      syn_2_tmp[943:936] ^ syn_2_tmp[951:944] ^ syn_2_tmp[959:952] ^ 
      syn_2_tmp[967:960] ^ syn_2_tmp[975:968] ^ syn_2_tmp[983:976] ^ 
      syn_2_tmp[991:984] ^ syn_2_tmp[999:992] ^ syn_2_tmp[1007:1000] ^ 
      syn_2_tmp[1015:1008] ^ syn_2_tmp[1023:1016] ^ syn_2_tmp[1031:1024] ^ 
      syn_2_tmp[1039:1032] ^ syn_2_tmp[1047:1040] ^ syn_2_tmp[1055:1048] ^ 
      syn_2_tmp[1063:1056] ^ syn_2_tmp[1071:1064] ^ syn_2_tmp[1079:1072] ^ 
      syn_2_tmp[1087:1080] ^ syn_2_tmp[1095:1088] ^ syn_2_tmp[1103:1096] ^ 
      syn_2_tmp[1111:1104] ^ syn_2_tmp[1119:1112] ^ syn_2_tmp[1127:1120] ^ 
      syn_2_tmp[1135:1128] ^ syn_2_tmp[1143:1136] ^ syn_2_tmp[1151:1144] ^ 
      syn_2_tmp[1159:1152] ^ syn_2_tmp[1167:1160] ^ syn_2_tmp[1175:1168] ^ 
      syn_2_tmp[1183:1176] ^ syn_2_tmp[1191:1184] ^ syn_2_tmp[1199:1192] ^ 
      syn_2_tmp[1207:1200] ^ syn_2_tmp[1215:1208] ^ syn_2_tmp[1223:1216] ^ 
      syn_2_tmp[1231:1224] ^ syn_2_tmp[1239:1232] ^ syn_2_tmp[1247:1240] ^ 
      syn_2_tmp[1255:1248] ^ syn_2_tmp[1263:1256] ^ syn_2_tmp[1271:1264] ^ 
      syn_2_tmp[1279:1272] ^ syn_2_tmp[1287:1280] ^ syn_2_tmp[1295:1288] ^ 
      syn_2_tmp[1303:1296] ^ syn_2_tmp[1311:1304] ^ syn_2_tmp[1319:1312] ^ 
      syn_2_tmp[1327:1320] ^ syn_2_tmp[1335:1328] ^ syn_2_tmp[1343:1336] ^ 
      syn_2_tmp[1351:1344] ^ syn_2_tmp[1359:1352] ^ syn_2_tmp[1367:1360] ^ 
      syn_2_tmp[1375:1368] ^ syn_2_tmp[1383:1376] ^ syn_2_tmp[1391:1384] ^ 
      syn_2_tmp[1399:1392] ^ syn_2_tmp[1407:1400] ^ syn_2_tmp[1415:1408] ^ 
      syn_2_tmp[1423:1416] ^ syn_2_tmp[1431:1424] ^ syn_2_tmp[1439:1432] ^ 
      syn_2_tmp[1447:1440] ^ syn_2_tmp[1455:1448] ^ syn_2_tmp[1463:1456] ^ 
      syn_2_tmp[1471:1464] ^ syn_2_tmp[1479:1472] ^ syn_2_tmp[1487:1480] ^ 
      syn_2_tmp[1495:1488] ^ syn_2_tmp[1503:1496] ^ syn_2_tmp[1511:1504] ^ 
      syn_2_tmp[1519:1512] ^ syn_2_tmp[1527:1520] ^ syn_2_tmp[1535:1528] ^ 
      syn_2_tmp[1543:1536] ^ syn_2_tmp[1551:1544] ^ syn_2_tmp[1559:1552] ^ 
      syn_2_tmp[1567:1560] ^ syn_2_tmp[1575:1568] ^ syn_2_tmp[1583:1576] ^ 
      syn_2_tmp[1591:1584] ^ syn_2_tmp[1599:1592] ^ syn_2_tmp[1607:1600] ^ 
      syn_2_tmp[1615:1608] ^ syn_2_tmp[1623:1616] ^ syn_2_tmp[1631:1624] ^ 
      syn_2_tmp[1639:1632] ^ syn_2_tmp[1647:1640] ^ syn_2_tmp[1655:1648] ^ 
      syn_2_tmp[1663:1656] ^ syn_2_tmp[1671:1664] ^ syn_2_tmp[1679:1672] ^ 
      syn_2_tmp[1687:1680] ^ syn_2_tmp[1695:1688] ^ syn_2_tmp[1703:1696] ^ 
      syn_2_tmp[1711:1704] ^ syn_2_tmp[1719:1712] ^ syn_2_tmp[1727:1720] ^ 
      syn_2_tmp[1735:1728] ^ syn_2_tmp[1743:1736] ^ syn_2_tmp[1751:1744] ^ 
      syn_2_tmp[1759:1752] ^ syn_2_tmp[1767:1760] ^ syn_2_tmp[1775:1768] ^ 
      syn_2_tmp[1783:1776] ^ syn_2_tmp[1791:1784] ^ syn_2_tmp[1799:1792] ^ 
      syn_2_tmp[1807:1800] ^ syn_2_tmp[1815:1808] ^ syn_2_tmp[1823:1816] ^ 
      syn_2_tmp[1831:1824] ^ syn_2_tmp[1839:1832] ^ syn_2_tmp[1847:1840] ^ 
      syn_2_tmp[1855:1848] ^ syn_2_tmp[1863:1856] ^ syn_2_tmp[1871:1864] ^ 
      syn_2_tmp[1879:1872] ^ syn_2_tmp[1887:1880] ^ syn_2_tmp[1895:1888] ^ 
      syn_2_tmp[1903:1896] ^ syn_2_tmp[1911:1904] ^ syn_2_tmp[1919:1912] ^ 
      syn_2_tmp[1927:1920] ^ syn_2_tmp[1935:1928] ^ syn_2_tmp[1943:1936] ^ 
      syn_2_tmp[1951:1944] ^ syn_2_tmp[1959:1952] ^ syn_2_tmp[1967:1960] ^ 
      syn_2_tmp[1975:1968] ^ syn_2_tmp[1983:1976] ^ syn_2_tmp[1991:1984] ^ 
      syn_2_tmp[1999:1992] ^ syn_2_tmp[2007:2000] ^ syn_2_tmp[2015:2008] ^ 
      syn_2_tmp[2023:2016] ^ syn_2_tmp[2031:2024] ^ syn_2_tmp[2039:2032];

// syndrome 3
  wire [2039:0] syn_3_tmp;
  gf_mult_by_01 m765 (.i(rx_data[7:0]),.o(syn_3_tmp[7:0]));
  gf_mult_by_08 m766 (.i(rx_data[15:8]),.o(syn_3_tmp[15:8]));
  gf_mult_by_40 m767 (.i(rx_data[23:16]),.o(syn_3_tmp[23:16]));
  gf_mult_by_3a m768 (.i(rx_data[31:24]),.o(syn_3_tmp[31:24]));
  gf_mult_by_cd m769 (.i(rx_data[39:32]),.o(syn_3_tmp[39:32]));
  gf_mult_by_26 m770 (.i(rx_data[47:40]),.o(syn_3_tmp[47:40]));
  gf_mult_by_2d m771 (.i(rx_data[55:48]),.o(syn_3_tmp[55:48]));
  gf_mult_by_75 m772 (.i(rx_data[63:56]),.o(syn_3_tmp[63:56]));
  gf_mult_by_8f m773 (.i(rx_data[71:64]),.o(syn_3_tmp[71:64]));
  gf_mult_by_0c m774 (.i(rx_data[79:72]),.o(syn_3_tmp[79:72]));
  gf_mult_by_60 m775 (.i(rx_data[87:80]),.o(syn_3_tmp[87:80]));
  gf_mult_by_27 m776 (.i(rx_data[95:88]),.o(syn_3_tmp[95:88]));
  gf_mult_by_25 m777 (.i(rx_data[103:96]),.o(syn_3_tmp[103:96]));
  gf_mult_by_35 m778 (.i(rx_data[111:104]),.o(syn_3_tmp[111:104]));
  gf_mult_by_b5 m779 (.i(rx_data[119:112]),.o(syn_3_tmp[119:112]));
  gf_mult_by_c1 m780 (.i(rx_data[127:120]),.o(syn_3_tmp[127:120]));
  gf_mult_by_46 m781 (.i(rx_data[135:128]),.o(syn_3_tmp[135:128]));
  gf_mult_by_0a m782 (.i(rx_data[143:136]),.o(syn_3_tmp[143:136]));
  gf_mult_by_50 m783 (.i(rx_data[151:144]),.o(syn_3_tmp[151:144]));
  gf_mult_by_ba m784 (.i(rx_data[159:152]),.o(syn_3_tmp[159:152]));
  gf_mult_by_b9 m785 (.i(rx_data[167:160]),.o(syn_3_tmp[167:160]));
  gf_mult_by_a1 m786 (.i(rx_data[175:168]),.o(syn_3_tmp[175:168]));
  gf_mult_by_61 m787 (.i(rx_data[183:176]),.o(syn_3_tmp[183:176]));
  gf_mult_by_2f m788 (.i(rx_data[191:184]),.o(syn_3_tmp[191:184]));
  gf_mult_by_65 m789 (.i(rx_data[199:192]),.o(syn_3_tmp[199:192]));
  gf_mult_by_0f m790 (.i(rx_data[207:200]),.o(syn_3_tmp[207:200]));
  gf_mult_by_78 m791 (.i(rx_data[215:208]),.o(syn_3_tmp[215:208]));
  gf_mult_by_e7 m792 (.i(rx_data[223:216]),.o(syn_3_tmp[223:216]));
  gf_mult_by_6b m793 (.i(rx_data[231:224]),.o(syn_3_tmp[231:224]));
  gf_mult_by_7f m794 (.i(rx_data[239:232]),.o(syn_3_tmp[239:232]));
  gf_mult_by_df m795 (.i(rx_data[247:240]),.o(syn_3_tmp[247:240]));
  gf_mult_by_b6 m796 (.i(rx_data[255:248]),.o(syn_3_tmp[255:248]));
  gf_mult_by_d9 m797 (.i(rx_data[263:256]),.o(syn_3_tmp[263:256]));
  gf_mult_by_86 m798 (.i(rx_data[271:264]),.o(syn_3_tmp[271:264]));
  gf_mult_by_44 m799 (.i(rx_data[279:272]),.o(syn_3_tmp[279:272]));
  gf_mult_by_1a m800 (.i(rx_data[287:280]),.o(syn_3_tmp[287:280]));
  gf_mult_by_d0 m801 (.i(rx_data[295:288]),.o(syn_3_tmp[295:288]));
  gf_mult_by_ce m802 (.i(rx_data[303:296]),.o(syn_3_tmp[303:296]));
  gf_mult_by_3e m803 (.i(rx_data[311:304]),.o(syn_3_tmp[311:304]));
  gf_mult_by_ed m804 (.i(rx_data[319:312]),.o(syn_3_tmp[319:312]));
  gf_mult_by_3b m805 (.i(rx_data[327:320]),.o(syn_3_tmp[327:320]));
  gf_mult_by_c5 m806 (.i(rx_data[335:328]),.o(syn_3_tmp[335:328]));
  gf_mult_by_66 m807 (.i(rx_data[343:336]),.o(syn_3_tmp[343:336]));
  gf_mult_by_17 m808 (.i(rx_data[351:344]),.o(syn_3_tmp[351:344]));
  gf_mult_by_b8 m809 (.i(rx_data[359:352]),.o(syn_3_tmp[359:352]));
  gf_mult_by_a9 m810 (.i(rx_data[367:360]),.o(syn_3_tmp[367:360]));
  gf_mult_by_21 m811 (.i(rx_data[375:368]),.o(syn_3_tmp[375:368]));
  gf_mult_by_15 m812 (.i(rx_data[383:376]),.o(syn_3_tmp[383:376]));
  gf_mult_by_a8 m813 (.i(rx_data[391:384]),.o(syn_3_tmp[391:384]));
  gf_mult_by_29 m814 (.i(rx_data[399:392]),.o(syn_3_tmp[399:392]));
  gf_mult_by_55 m815 (.i(rx_data[407:400]),.o(syn_3_tmp[407:400]));
  gf_mult_by_92 m816 (.i(rx_data[415:408]),.o(syn_3_tmp[415:408]));
  gf_mult_by_e4 m817 (.i(rx_data[423:416]),.o(syn_3_tmp[423:416]));
  gf_mult_by_73 m818 (.i(rx_data[431:424]),.o(syn_3_tmp[431:424]));
  gf_mult_by_bf m819 (.i(rx_data[439:432]),.o(syn_3_tmp[439:432]));
  gf_mult_by_91 m820 (.i(rx_data[447:440]),.o(syn_3_tmp[447:440]));
  gf_mult_by_fc m821 (.i(rx_data[455:448]),.o(syn_3_tmp[455:448]));
  gf_mult_by_b3 m822 (.i(rx_data[463:456]),.o(syn_3_tmp[463:456]));
  gf_mult_by_f1 m823 (.i(rx_data[471:464]),.o(syn_3_tmp[471:464]));
  gf_mult_by_db m824 (.i(rx_data[479:472]),.o(syn_3_tmp[479:472]));
  gf_mult_by_96 m825 (.i(rx_data[487:480]),.o(syn_3_tmp[487:480]));
  gf_mult_by_c4 m826 (.i(rx_data[495:488]),.o(syn_3_tmp[495:488]));
  gf_mult_by_6e m827 (.i(rx_data[503:496]),.o(syn_3_tmp[503:496]));
  gf_mult_by_57 m828 (.i(rx_data[511:504]),.o(syn_3_tmp[511:504]));
  gf_mult_by_82 m829 (.i(rx_data[519:512]),.o(syn_3_tmp[519:512]));
  gf_mult_by_64 m830 (.i(rx_data[527:520]),.o(syn_3_tmp[527:520]));
  gf_mult_by_07 m831 (.i(rx_data[535:528]),.o(syn_3_tmp[535:528]));
  gf_mult_by_38 m832 (.i(rx_data[543:536]),.o(syn_3_tmp[543:536]));
  gf_mult_by_dd m833 (.i(rx_data[551:544]),.o(syn_3_tmp[551:544]));
  gf_mult_by_a6 m834 (.i(rx_data[559:552]),.o(syn_3_tmp[559:552]));
  gf_mult_by_59 m835 (.i(rx_data[567:560]),.o(syn_3_tmp[567:560]));
  gf_mult_by_f2 m836 (.i(rx_data[575:568]),.o(syn_3_tmp[575:568]));
  gf_mult_by_c3 m837 (.i(rx_data[583:576]),.o(syn_3_tmp[583:576]));
  gf_mult_by_56 m838 (.i(rx_data[591:584]),.o(syn_3_tmp[591:584]));
  gf_mult_by_8a m839 (.i(rx_data[599:592]),.o(syn_3_tmp[599:592]));
  gf_mult_by_24 m840 (.i(rx_data[607:600]),.o(syn_3_tmp[607:600]));
  gf_mult_by_3d m841 (.i(rx_data[615:608]),.o(syn_3_tmp[615:608]));
  gf_mult_by_f5 m842 (.i(rx_data[623:616]),.o(syn_3_tmp[623:616]));
  gf_mult_by_fb m843 (.i(rx_data[631:624]),.o(syn_3_tmp[631:624]));
  gf_mult_by_8b m844 (.i(rx_data[639:632]),.o(syn_3_tmp[639:632]));
  gf_mult_by_2c m845 (.i(rx_data[647:640]),.o(syn_3_tmp[647:640]));
  gf_mult_by_7d m846 (.i(rx_data[655:648]),.o(syn_3_tmp[655:648]));
  gf_mult_by_cf m847 (.i(rx_data[663:656]),.o(syn_3_tmp[663:656]));
  gf_mult_by_36 m848 (.i(rx_data[671:664]),.o(syn_3_tmp[671:664]));
  gf_mult_by_ad m849 (.i(rx_data[679:672]),.o(syn_3_tmp[679:672]));
  gf_mult_by_01 m850 (.i(rx_data[687:680]),.o(syn_3_tmp[687:680]));
  gf_mult_by_08 m851 (.i(rx_data[695:688]),.o(syn_3_tmp[695:688]));
  gf_mult_by_40 m852 (.i(rx_data[703:696]),.o(syn_3_tmp[703:696]));
  gf_mult_by_3a m853 (.i(rx_data[711:704]),.o(syn_3_tmp[711:704]));
  gf_mult_by_cd m854 (.i(rx_data[719:712]),.o(syn_3_tmp[719:712]));
  gf_mult_by_26 m855 (.i(rx_data[727:720]),.o(syn_3_tmp[727:720]));
  gf_mult_by_2d m856 (.i(rx_data[735:728]),.o(syn_3_tmp[735:728]));
  gf_mult_by_75 m857 (.i(rx_data[743:736]),.o(syn_3_tmp[743:736]));
  gf_mult_by_8f m858 (.i(rx_data[751:744]),.o(syn_3_tmp[751:744]));
  gf_mult_by_0c m859 (.i(rx_data[759:752]),.o(syn_3_tmp[759:752]));
  gf_mult_by_60 m860 (.i(rx_data[767:760]),.o(syn_3_tmp[767:760]));
  gf_mult_by_27 m861 (.i(rx_data[775:768]),.o(syn_3_tmp[775:768]));
  gf_mult_by_25 m862 (.i(rx_data[783:776]),.o(syn_3_tmp[783:776]));
  gf_mult_by_35 m863 (.i(rx_data[791:784]),.o(syn_3_tmp[791:784]));
  gf_mult_by_b5 m864 (.i(rx_data[799:792]),.o(syn_3_tmp[799:792]));
  gf_mult_by_c1 m865 (.i(rx_data[807:800]),.o(syn_3_tmp[807:800]));
  gf_mult_by_46 m866 (.i(rx_data[815:808]),.o(syn_3_tmp[815:808]));
  gf_mult_by_0a m867 (.i(rx_data[823:816]),.o(syn_3_tmp[823:816]));
  gf_mult_by_50 m868 (.i(rx_data[831:824]),.o(syn_3_tmp[831:824]));
  gf_mult_by_ba m869 (.i(rx_data[839:832]),.o(syn_3_tmp[839:832]));
  gf_mult_by_b9 m870 (.i(rx_data[847:840]),.o(syn_3_tmp[847:840]));
  gf_mult_by_a1 m871 (.i(rx_data[855:848]),.o(syn_3_tmp[855:848]));
  gf_mult_by_61 m872 (.i(rx_data[863:856]),.o(syn_3_tmp[863:856]));
  gf_mult_by_2f m873 (.i(rx_data[871:864]),.o(syn_3_tmp[871:864]));
  gf_mult_by_65 m874 (.i(rx_data[879:872]),.o(syn_3_tmp[879:872]));
  gf_mult_by_0f m875 (.i(rx_data[887:880]),.o(syn_3_tmp[887:880]));
  gf_mult_by_78 m876 (.i(rx_data[895:888]),.o(syn_3_tmp[895:888]));
  gf_mult_by_e7 m877 (.i(rx_data[903:896]),.o(syn_3_tmp[903:896]));
  gf_mult_by_6b m878 (.i(rx_data[911:904]),.o(syn_3_tmp[911:904]));
  gf_mult_by_7f m879 (.i(rx_data[919:912]),.o(syn_3_tmp[919:912]));
  gf_mult_by_df m880 (.i(rx_data[927:920]),.o(syn_3_tmp[927:920]));
  gf_mult_by_b6 m881 (.i(rx_data[935:928]),.o(syn_3_tmp[935:928]));
  gf_mult_by_d9 m882 (.i(rx_data[943:936]),.o(syn_3_tmp[943:936]));
  gf_mult_by_86 m883 (.i(rx_data[951:944]),.o(syn_3_tmp[951:944]));
  gf_mult_by_44 m884 (.i(rx_data[959:952]),.o(syn_3_tmp[959:952]));
  gf_mult_by_1a m885 (.i(rx_data[967:960]),.o(syn_3_tmp[967:960]));
  gf_mult_by_d0 m886 (.i(rx_data[975:968]),.o(syn_3_tmp[975:968]));
  gf_mult_by_ce m887 (.i(rx_data[983:976]),.o(syn_3_tmp[983:976]));
  gf_mult_by_3e m888 (.i(rx_data[991:984]),.o(syn_3_tmp[991:984]));
  gf_mult_by_ed m889 (.i(rx_data[999:992]),.o(syn_3_tmp[999:992]));
  gf_mult_by_3b m890 (.i(rx_data[1007:1000]),.o(syn_3_tmp[1007:1000]));
  gf_mult_by_c5 m891 (.i(rx_data[1015:1008]),.o(syn_3_tmp[1015:1008]));
  gf_mult_by_66 m892 (.i(rx_data[1023:1016]),.o(syn_3_tmp[1023:1016]));
  gf_mult_by_17 m893 (.i(rx_data[1031:1024]),.o(syn_3_tmp[1031:1024]));
  gf_mult_by_b8 m894 (.i(rx_data[1039:1032]),.o(syn_3_tmp[1039:1032]));
  gf_mult_by_a9 m895 (.i(rx_data[1047:1040]),.o(syn_3_tmp[1047:1040]));
  gf_mult_by_21 m896 (.i(rx_data[1055:1048]),.o(syn_3_tmp[1055:1048]));
  gf_mult_by_15 m897 (.i(rx_data[1063:1056]),.o(syn_3_tmp[1063:1056]));
  gf_mult_by_a8 m898 (.i(rx_data[1071:1064]),.o(syn_3_tmp[1071:1064]));
  gf_mult_by_29 m899 (.i(rx_data[1079:1072]),.o(syn_3_tmp[1079:1072]));
  gf_mult_by_55 m900 (.i(rx_data[1087:1080]),.o(syn_3_tmp[1087:1080]));
  gf_mult_by_92 m901 (.i(rx_data[1095:1088]),.o(syn_3_tmp[1095:1088]));
  gf_mult_by_e4 m902 (.i(rx_data[1103:1096]),.o(syn_3_tmp[1103:1096]));
  gf_mult_by_73 m903 (.i(rx_data[1111:1104]),.o(syn_3_tmp[1111:1104]));
  gf_mult_by_bf m904 (.i(rx_data[1119:1112]),.o(syn_3_tmp[1119:1112]));
  gf_mult_by_91 m905 (.i(rx_data[1127:1120]),.o(syn_3_tmp[1127:1120]));
  gf_mult_by_fc m906 (.i(rx_data[1135:1128]),.o(syn_3_tmp[1135:1128]));
  gf_mult_by_b3 m907 (.i(rx_data[1143:1136]),.o(syn_3_tmp[1143:1136]));
  gf_mult_by_f1 m908 (.i(rx_data[1151:1144]),.o(syn_3_tmp[1151:1144]));
  gf_mult_by_db m909 (.i(rx_data[1159:1152]),.o(syn_3_tmp[1159:1152]));
  gf_mult_by_96 m910 (.i(rx_data[1167:1160]),.o(syn_3_tmp[1167:1160]));
  gf_mult_by_c4 m911 (.i(rx_data[1175:1168]),.o(syn_3_tmp[1175:1168]));
  gf_mult_by_6e m912 (.i(rx_data[1183:1176]),.o(syn_3_tmp[1183:1176]));
  gf_mult_by_57 m913 (.i(rx_data[1191:1184]),.o(syn_3_tmp[1191:1184]));
  gf_mult_by_82 m914 (.i(rx_data[1199:1192]),.o(syn_3_tmp[1199:1192]));
  gf_mult_by_64 m915 (.i(rx_data[1207:1200]),.o(syn_3_tmp[1207:1200]));
  gf_mult_by_07 m916 (.i(rx_data[1215:1208]),.o(syn_3_tmp[1215:1208]));
  gf_mult_by_38 m917 (.i(rx_data[1223:1216]),.o(syn_3_tmp[1223:1216]));
  gf_mult_by_dd m918 (.i(rx_data[1231:1224]),.o(syn_3_tmp[1231:1224]));
  gf_mult_by_a6 m919 (.i(rx_data[1239:1232]),.o(syn_3_tmp[1239:1232]));
  gf_mult_by_59 m920 (.i(rx_data[1247:1240]),.o(syn_3_tmp[1247:1240]));
  gf_mult_by_f2 m921 (.i(rx_data[1255:1248]),.o(syn_3_tmp[1255:1248]));
  gf_mult_by_c3 m922 (.i(rx_data[1263:1256]),.o(syn_3_tmp[1263:1256]));
  gf_mult_by_56 m923 (.i(rx_data[1271:1264]),.o(syn_3_tmp[1271:1264]));
  gf_mult_by_8a m924 (.i(rx_data[1279:1272]),.o(syn_3_tmp[1279:1272]));
  gf_mult_by_24 m925 (.i(rx_data[1287:1280]),.o(syn_3_tmp[1287:1280]));
  gf_mult_by_3d m926 (.i(rx_data[1295:1288]),.o(syn_3_tmp[1295:1288]));
  gf_mult_by_f5 m927 (.i(rx_data[1303:1296]),.o(syn_3_tmp[1303:1296]));
  gf_mult_by_fb m928 (.i(rx_data[1311:1304]),.o(syn_3_tmp[1311:1304]));
  gf_mult_by_8b m929 (.i(rx_data[1319:1312]),.o(syn_3_tmp[1319:1312]));
  gf_mult_by_2c m930 (.i(rx_data[1327:1320]),.o(syn_3_tmp[1327:1320]));
  gf_mult_by_7d m931 (.i(rx_data[1335:1328]),.o(syn_3_tmp[1335:1328]));
  gf_mult_by_cf m932 (.i(rx_data[1343:1336]),.o(syn_3_tmp[1343:1336]));
  gf_mult_by_36 m933 (.i(rx_data[1351:1344]),.o(syn_3_tmp[1351:1344]));
  gf_mult_by_ad m934 (.i(rx_data[1359:1352]),.o(syn_3_tmp[1359:1352]));
  gf_mult_by_01 m935 (.i(rx_data[1367:1360]),.o(syn_3_tmp[1367:1360]));
  gf_mult_by_08 m936 (.i(rx_data[1375:1368]),.o(syn_3_tmp[1375:1368]));
  gf_mult_by_40 m937 (.i(rx_data[1383:1376]),.o(syn_3_tmp[1383:1376]));
  gf_mult_by_3a m938 (.i(rx_data[1391:1384]),.o(syn_3_tmp[1391:1384]));
  gf_mult_by_cd m939 (.i(rx_data[1399:1392]),.o(syn_3_tmp[1399:1392]));
  gf_mult_by_26 m940 (.i(rx_data[1407:1400]),.o(syn_3_tmp[1407:1400]));
  gf_mult_by_2d m941 (.i(rx_data[1415:1408]),.o(syn_3_tmp[1415:1408]));
  gf_mult_by_75 m942 (.i(rx_data[1423:1416]),.o(syn_3_tmp[1423:1416]));
  gf_mult_by_8f m943 (.i(rx_data[1431:1424]),.o(syn_3_tmp[1431:1424]));
  gf_mult_by_0c m944 (.i(rx_data[1439:1432]),.o(syn_3_tmp[1439:1432]));
  gf_mult_by_60 m945 (.i(rx_data[1447:1440]),.o(syn_3_tmp[1447:1440]));
  gf_mult_by_27 m946 (.i(rx_data[1455:1448]),.o(syn_3_tmp[1455:1448]));
  gf_mult_by_25 m947 (.i(rx_data[1463:1456]),.o(syn_3_tmp[1463:1456]));
  gf_mult_by_35 m948 (.i(rx_data[1471:1464]),.o(syn_3_tmp[1471:1464]));
  gf_mult_by_b5 m949 (.i(rx_data[1479:1472]),.o(syn_3_tmp[1479:1472]));
  gf_mult_by_c1 m950 (.i(rx_data[1487:1480]),.o(syn_3_tmp[1487:1480]));
  gf_mult_by_46 m951 (.i(rx_data[1495:1488]),.o(syn_3_tmp[1495:1488]));
  gf_mult_by_0a m952 (.i(rx_data[1503:1496]),.o(syn_3_tmp[1503:1496]));
  gf_mult_by_50 m953 (.i(rx_data[1511:1504]),.o(syn_3_tmp[1511:1504]));
  gf_mult_by_ba m954 (.i(rx_data[1519:1512]),.o(syn_3_tmp[1519:1512]));
  gf_mult_by_b9 m955 (.i(rx_data[1527:1520]),.o(syn_3_tmp[1527:1520]));
  gf_mult_by_a1 m956 (.i(rx_data[1535:1528]),.o(syn_3_tmp[1535:1528]));
  gf_mult_by_61 m957 (.i(rx_data[1543:1536]),.o(syn_3_tmp[1543:1536]));
  gf_mult_by_2f m958 (.i(rx_data[1551:1544]),.o(syn_3_tmp[1551:1544]));
  gf_mult_by_65 m959 (.i(rx_data[1559:1552]),.o(syn_3_tmp[1559:1552]));
  gf_mult_by_0f m960 (.i(rx_data[1567:1560]),.o(syn_3_tmp[1567:1560]));
  gf_mult_by_78 m961 (.i(rx_data[1575:1568]),.o(syn_3_tmp[1575:1568]));
  gf_mult_by_e7 m962 (.i(rx_data[1583:1576]),.o(syn_3_tmp[1583:1576]));
  gf_mult_by_6b m963 (.i(rx_data[1591:1584]),.o(syn_3_tmp[1591:1584]));
  gf_mult_by_7f m964 (.i(rx_data[1599:1592]),.o(syn_3_tmp[1599:1592]));
  gf_mult_by_df m965 (.i(rx_data[1607:1600]),.o(syn_3_tmp[1607:1600]));
  gf_mult_by_b6 m966 (.i(rx_data[1615:1608]),.o(syn_3_tmp[1615:1608]));
  gf_mult_by_d9 m967 (.i(rx_data[1623:1616]),.o(syn_3_tmp[1623:1616]));
  gf_mult_by_86 m968 (.i(rx_data[1631:1624]),.o(syn_3_tmp[1631:1624]));
  gf_mult_by_44 m969 (.i(rx_data[1639:1632]),.o(syn_3_tmp[1639:1632]));
  gf_mult_by_1a m970 (.i(rx_data[1647:1640]),.o(syn_3_tmp[1647:1640]));
  gf_mult_by_d0 m971 (.i(rx_data[1655:1648]),.o(syn_3_tmp[1655:1648]));
  gf_mult_by_ce m972 (.i(rx_data[1663:1656]),.o(syn_3_tmp[1663:1656]));
  gf_mult_by_3e m973 (.i(rx_data[1671:1664]),.o(syn_3_tmp[1671:1664]));
  gf_mult_by_ed m974 (.i(rx_data[1679:1672]),.o(syn_3_tmp[1679:1672]));
  gf_mult_by_3b m975 (.i(rx_data[1687:1680]),.o(syn_3_tmp[1687:1680]));
  gf_mult_by_c5 m976 (.i(rx_data[1695:1688]),.o(syn_3_tmp[1695:1688]));
  gf_mult_by_66 m977 (.i(rx_data[1703:1696]),.o(syn_3_tmp[1703:1696]));
  gf_mult_by_17 m978 (.i(rx_data[1711:1704]),.o(syn_3_tmp[1711:1704]));
  gf_mult_by_b8 m979 (.i(rx_data[1719:1712]),.o(syn_3_tmp[1719:1712]));
  gf_mult_by_a9 m980 (.i(rx_data[1727:1720]),.o(syn_3_tmp[1727:1720]));
  gf_mult_by_21 m981 (.i(rx_data[1735:1728]),.o(syn_3_tmp[1735:1728]));
  gf_mult_by_15 m982 (.i(rx_data[1743:1736]),.o(syn_3_tmp[1743:1736]));
  gf_mult_by_a8 m983 (.i(rx_data[1751:1744]),.o(syn_3_tmp[1751:1744]));
  gf_mult_by_29 m984 (.i(rx_data[1759:1752]),.o(syn_3_tmp[1759:1752]));
  gf_mult_by_55 m985 (.i(rx_data[1767:1760]),.o(syn_3_tmp[1767:1760]));
  gf_mult_by_92 m986 (.i(rx_data[1775:1768]),.o(syn_3_tmp[1775:1768]));
  gf_mult_by_e4 m987 (.i(rx_data[1783:1776]),.o(syn_3_tmp[1783:1776]));
  gf_mult_by_73 m988 (.i(rx_data[1791:1784]),.o(syn_3_tmp[1791:1784]));
  gf_mult_by_bf m989 (.i(rx_data[1799:1792]),.o(syn_3_tmp[1799:1792]));
  gf_mult_by_91 m990 (.i(rx_data[1807:1800]),.o(syn_3_tmp[1807:1800]));
  gf_mult_by_fc m991 (.i(rx_data[1815:1808]),.o(syn_3_tmp[1815:1808]));
  gf_mult_by_b3 m992 (.i(rx_data[1823:1816]),.o(syn_3_tmp[1823:1816]));
  gf_mult_by_f1 m993 (.i(rx_data[1831:1824]),.o(syn_3_tmp[1831:1824]));
  gf_mult_by_db m994 (.i(rx_data[1839:1832]),.o(syn_3_tmp[1839:1832]));
  gf_mult_by_96 m995 (.i(rx_data[1847:1840]),.o(syn_3_tmp[1847:1840]));
  gf_mult_by_c4 m996 (.i(rx_data[1855:1848]),.o(syn_3_tmp[1855:1848]));
  gf_mult_by_6e m997 (.i(rx_data[1863:1856]),.o(syn_3_tmp[1863:1856]));
  gf_mult_by_57 m998 (.i(rx_data[1871:1864]),.o(syn_3_tmp[1871:1864]));
  gf_mult_by_82 m999 (.i(rx_data[1879:1872]),.o(syn_3_tmp[1879:1872]));
  gf_mult_by_64 m1000 (.i(rx_data[1887:1880]),.o(syn_3_tmp[1887:1880]));
  gf_mult_by_07 m1001 (.i(rx_data[1895:1888]),.o(syn_3_tmp[1895:1888]));
  gf_mult_by_38 m1002 (.i(rx_data[1903:1896]),.o(syn_3_tmp[1903:1896]));
  gf_mult_by_dd m1003 (.i(rx_data[1911:1904]),.o(syn_3_tmp[1911:1904]));
  gf_mult_by_a6 m1004 (.i(rx_data[1919:1912]),.o(syn_3_tmp[1919:1912]));
  gf_mult_by_59 m1005 (.i(rx_data[1927:1920]),.o(syn_3_tmp[1927:1920]));
  gf_mult_by_f2 m1006 (.i(rx_data[1935:1928]),.o(syn_3_tmp[1935:1928]));
  gf_mult_by_c3 m1007 (.i(rx_data[1943:1936]),.o(syn_3_tmp[1943:1936]));
  gf_mult_by_56 m1008 (.i(rx_data[1951:1944]),.o(syn_3_tmp[1951:1944]));
  gf_mult_by_8a m1009 (.i(rx_data[1959:1952]),.o(syn_3_tmp[1959:1952]));
  gf_mult_by_24 m1010 (.i(rx_data[1967:1960]),.o(syn_3_tmp[1967:1960]));
  gf_mult_by_3d m1011 (.i(rx_data[1975:1968]),.o(syn_3_tmp[1975:1968]));
  gf_mult_by_f5 m1012 (.i(rx_data[1983:1976]),.o(syn_3_tmp[1983:1976]));
  gf_mult_by_fb m1013 (.i(rx_data[1991:1984]),.o(syn_3_tmp[1991:1984]));
  gf_mult_by_8b m1014 (.i(rx_data[1999:1992]),.o(syn_3_tmp[1999:1992]));
  gf_mult_by_2c m1015 (.i(rx_data[2007:2000]),.o(syn_3_tmp[2007:2000]));
  gf_mult_by_7d m1016 (.i(rx_data[2015:2008]),.o(syn_3_tmp[2015:2008]));
  gf_mult_by_cf m1017 (.i(rx_data[2023:2016]),.o(syn_3_tmp[2023:2016]));
  gf_mult_by_36 m1018 (.i(rx_data[2031:2024]),.o(syn_3_tmp[2031:2024]));
  gf_mult_by_ad m1019 (.i(rx_data[2039:2032]),.o(syn_3_tmp[2039:2032]));
  assign syndrome[31:24] =
      syn_3_tmp[7:0] ^ syn_3_tmp[15:8] ^ syn_3_tmp[23:16] ^ 
      syn_3_tmp[31:24] ^ syn_3_tmp[39:32] ^ syn_3_tmp[47:40] ^ 
      syn_3_tmp[55:48] ^ syn_3_tmp[63:56] ^ syn_3_tmp[71:64] ^ 
      syn_3_tmp[79:72] ^ syn_3_tmp[87:80] ^ syn_3_tmp[95:88] ^ 
      syn_3_tmp[103:96] ^ syn_3_tmp[111:104] ^ syn_3_tmp[119:112] ^ 
      syn_3_tmp[127:120] ^ syn_3_tmp[135:128] ^ syn_3_tmp[143:136] ^ 
      syn_3_tmp[151:144] ^ syn_3_tmp[159:152] ^ syn_3_tmp[167:160] ^ 
      syn_3_tmp[175:168] ^ syn_3_tmp[183:176] ^ syn_3_tmp[191:184] ^ 
      syn_3_tmp[199:192] ^ syn_3_tmp[207:200] ^ syn_3_tmp[215:208] ^ 
      syn_3_tmp[223:216] ^ syn_3_tmp[231:224] ^ syn_3_tmp[239:232] ^ 
      syn_3_tmp[247:240] ^ syn_3_tmp[255:248] ^ syn_3_tmp[263:256] ^ 
      syn_3_tmp[271:264] ^ syn_3_tmp[279:272] ^ syn_3_tmp[287:280] ^ 
      syn_3_tmp[295:288] ^ syn_3_tmp[303:296] ^ syn_3_tmp[311:304] ^ 
      syn_3_tmp[319:312] ^ syn_3_tmp[327:320] ^ syn_3_tmp[335:328] ^ 
      syn_3_tmp[343:336] ^ syn_3_tmp[351:344] ^ syn_3_tmp[359:352] ^ 
      syn_3_tmp[367:360] ^ syn_3_tmp[375:368] ^ syn_3_tmp[383:376] ^ 
      syn_3_tmp[391:384] ^ syn_3_tmp[399:392] ^ syn_3_tmp[407:400] ^ 
      syn_3_tmp[415:408] ^ syn_3_tmp[423:416] ^ syn_3_tmp[431:424] ^ 
      syn_3_tmp[439:432] ^ syn_3_tmp[447:440] ^ syn_3_tmp[455:448] ^ 
      syn_3_tmp[463:456] ^ syn_3_tmp[471:464] ^ syn_3_tmp[479:472] ^ 
      syn_3_tmp[487:480] ^ syn_3_tmp[495:488] ^ syn_3_tmp[503:496] ^ 
      syn_3_tmp[511:504] ^ syn_3_tmp[519:512] ^ syn_3_tmp[527:520] ^ 
      syn_3_tmp[535:528] ^ syn_3_tmp[543:536] ^ syn_3_tmp[551:544] ^ 
      syn_3_tmp[559:552] ^ syn_3_tmp[567:560] ^ syn_3_tmp[575:568] ^ 
      syn_3_tmp[583:576] ^ syn_3_tmp[591:584] ^ syn_3_tmp[599:592] ^ 
      syn_3_tmp[607:600] ^ syn_3_tmp[615:608] ^ syn_3_tmp[623:616] ^ 
      syn_3_tmp[631:624] ^ syn_3_tmp[639:632] ^ syn_3_tmp[647:640] ^ 
      syn_3_tmp[655:648] ^ syn_3_tmp[663:656] ^ syn_3_tmp[671:664] ^ 
      syn_3_tmp[679:672] ^ syn_3_tmp[687:680] ^ syn_3_tmp[695:688] ^ 
      syn_3_tmp[703:696] ^ syn_3_tmp[711:704] ^ syn_3_tmp[719:712] ^ 
      syn_3_tmp[727:720] ^ syn_3_tmp[735:728] ^ syn_3_tmp[743:736] ^ 
      syn_3_tmp[751:744] ^ syn_3_tmp[759:752] ^ syn_3_tmp[767:760] ^ 
      syn_3_tmp[775:768] ^ syn_3_tmp[783:776] ^ syn_3_tmp[791:784] ^ 
      syn_3_tmp[799:792] ^ syn_3_tmp[807:800] ^ syn_3_tmp[815:808] ^ 
      syn_3_tmp[823:816] ^ syn_3_tmp[831:824] ^ syn_3_tmp[839:832] ^ 
      syn_3_tmp[847:840] ^ syn_3_tmp[855:848] ^ syn_3_tmp[863:856] ^ 
      syn_3_tmp[871:864] ^ syn_3_tmp[879:872] ^ syn_3_tmp[887:880] ^ 
      syn_3_tmp[895:888] ^ syn_3_tmp[903:896] ^ syn_3_tmp[911:904] ^ 
      syn_3_tmp[919:912] ^ syn_3_tmp[927:920] ^ syn_3_tmp[935:928] ^ 
      syn_3_tmp[943:936] ^ syn_3_tmp[951:944] ^ syn_3_tmp[959:952] ^ 
      syn_3_tmp[967:960] ^ syn_3_tmp[975:968] ^ syn_3_tmp[983:976] ^ 
      syn_3_tmp[991:984] ^ syn_3_tmp[999:992] ^ syn_3_tmp[1007:1000] ^ 
      syn_3_tmp[1015:1008] ^ syn_3_tmp[1023:1016] ^ syn_3_tmp[1031:1024] ^ 
      syn_3_tmp[1039:1032] ^ syn_3_tmp[1047:1040] ^ syn_3_tmp[1055:1048] ^ 
      syn_3_tmp[1063:1056] ^ syn_3_tmp[1071:1064] ^ syn_3_tmp[1079:1072] ^ 
      syn_3_tmp[1087:1080] ^ syn_3_tmp[1095:1088] ^ syn_3_tmp[1103:1096] ^ 
      syn_3_tmp[1111:1104] ^ syn_3_tmp[1119:1112] ^ syn_3_tmp[1127:1120] ^ 
      syn_3_tmp[1135:1128] ^ syn_3_tmp[1143:1136] ^ syn_3_tmp[1151:1144] ^ 
      syn_3_tmp[1159:1152] ^ syn_3_tmp[1167:1160] ^ syn_3_tmp[1175:1168] ^ 
      syn_3_tmp[1183:1176] ^ syn_3_tmp[1191:1184] ^ syn_3_tmp[1199:1192] ^ 
      syn_3_tmp[1207:1200] ^ syn_3_tmp[1215:1208] ^ syn_3_tmp[1223:1216] ^ 
      syn_3_tmp[1231:1224] ^ syn_3_tmp[1239:1232] ^ syn_3_tmp[1247:1240] ^ 
      syn_3_tmp[1255:1248] ^ syn_3_tmp[1263:1256] ^ syn_3_tmp[1271:1264] ^ 
      syn_3_tmp[1279:1272] ^ syn_3_tmp[1287:1280] ^ syn_3_tmp[1295:1288] ^ 
      syn_3_tmp[1303:1296] ^ syn_3_tmp[1311:1304] ^ syn_3_tmp[1319:1312] ^ 
      syn_3_tmp[1327:1320] ^ syn_3_tmp[1335:1328] ^ syn_3_tmp[1343:1336] ^ 
      syn_3_tmp[1351:1344] ^ syn_3_tmp[1359:1352] ^ syn_3_tmp[1367:1360] ^ 
      syn_3_tmp[1375:1368] ^ syn_3_tmp[1383:1376] ^ syn_3_tmp[1391:1384] ^ 
      syn_3_tmp[1399:1392] ^ syn_3_tmp[1407:1400] ^ syn_3_tmp[1415:1408] ^ 
      syn_3_tmp[1423:1416] ^ syn_3_tmp[1431:1424] ^ syn_3_tmp[1439:1432] ^ 
      syn_3_tmp[1447:1440] ^ syn_3_tmp[1455:1448] ^ syn_3_tmp[1463:1456] ^ 
      syn_3_tmp[1471:1464] ^ syn_3_tmp[1479:1472] ^ syn_3_tmp[1487:1480] ^ 
      syn_3_tmp[1495:1488] ^ syn_3_tmp[1503:1496] ^ syn_3_tmp[1511:1504] ^ 
      syn_3_tmp[1519:1512] ^ syn_3_tmp[1527:1520] ^ syn_3_tmp[1535:1528] ^ 
      syn_3_tmp[1543:1536] ^ syn_3_tmp[1551:1544] ^ syn_3_tmp[1559:1552] ^ 
      syn_3_tmp[1567:1560] ^ syn_3_tmp[1575:1568] ^ syn_3_tmp[1583:1576] ^ 
      syn_3_tmp[1591:1584] ^ syn_3_tmp[1599:1592] ^ syn_3_tmp[1607:1600] ^ 
      syn_3_tmp[1615:1608] ^ syn_3_tmp[1623:1616] ^ syn_3_tmp[1631:1624] ^ 
      syn_3_tmp[1639:1632] ^ syn_3_tmp[1647:1640] ^ syn_3_tmp[1655:1648] ^ 
      syn_3_tmp[1663:1656] ^ syn_3_tmp[1671:1664] ^ syn_3_tmp[1679:1672] ^ 
      syn_3_tmp[1687:1680] ^ syn_3_tmp[1695:1688] ^ syn_3_tmp[1703:1696] ^ 
      syn_3_tmp[1711:1704] ^ syn_3_tmp[1719:1712] ^ syn_3_tmp[1727:1720] ^ 
      syn_3_tmp[1735:1728] ^ syn_3_tmp[1743:1736] ^ syn_3_tmp[1751:1744] ^ 
      syn_3_tmp[1759:1752] ^ syn_3_tmp[1767:1760] ^ syn_3_tmp[1775:1768] ^ 
      syn_3_tmp[1783:1776] ^ syn_3_tmp[1791:1784] ^ syn_3_tmp[1799:1792] ^ 
      syn_3_tmp[1807:1800] ^ syn_3_tmp[1815:1808] ^ syn_3_tmp[1823:1816] ^ 
      syn_3_tmp[1831:1824] ^ syn_3_tmp[1839:1832] ^ syn_3_tmp[1847:1840] ^ 
      syn_3_tmp[1855:1848] ^ syn_3_tmp[1863:1856] ^ syn_3_tmp[1871:1864] ^ 
      syn_3_tmp[1879:1872] ^ syn_3_tmp[1887:1880] ^ syn_3_tmp[1895:1888] ^ 
      syn_3_tmp[1903:1896] ^ syn_3_tmp[1911:1904] ^ syn_3_tmp[1919:1912] ^ 
      syn_3_tmp[1927:1920] ^ syn_3_tmp[1935:1928] ^ syn_3_tmp[1943:1936] ^ 
      syn_3_tmp[1951:1944] ^ syn_3_tmp[1959:1952] ^ syn_3_tmp[1967:1960] ^ 
      syn_3_tmp[1975:1968] ^ syn_3_tmp[1983:1976] ^ syn_3_tmp[1991:1984] ^ 
      syn_3_tmp[1999:1992] ^ syn_3_tmp[2007:2000] ^ syn_3_tmp[2015:2008] ^ 
      syn_3_tmp[2023:2016] ^ syn_3_tmp[2031:2024] ^ syn_3_tmp[2039:2032];

// syndrome 4
  wire [2039:0] syn_4_tmp;
  gf_mult_by_01 m1020 (.i(rx_data[7:0]),.o(syn_4_tmp[7:0]));
  gf_mult_by_10 m1021 (.i(rx_data[15:8]),.o(syn_4_tmp[15:8]));
  gf_mult_by_1d m1022 (.i(rx_data[23:16]),.o(syn_4_tmp[23:16]));
  gf_mult_by_cd m1023 (.i(rx_data[31:24]),.o(syn_4_tmp[31:24]));
  gf_mult_by_4c m1024 (.i(rx_data[39:32]),.o(syn_4_tmp[39:32]));
  gf_mult_by_b4 m1025 (.i(rx_data[47:40]),.o(syn_4_tmp[47:40]));
  gf_mult_by_8f m1026 (.i(rx_data[55:48]),.o(syn_4_tmp[55:48]));
  gf_mult_by_18 m1027 (.i(rx_data[63:56]),.o(syn_4_tmp[63:56]));
  gf_mult_by_9d m1028 (.i(rx_data[71:64]),.o(syn_4_tmp[71:64]));
  gf_mult_by_25 m1029 (.i(rx_data[79:72]),.o(syn_4_tmp[79:72]));
  gf_mult_by_6a m1030 (.i(rx_data[87:80]),.o(syn_4_tmp[87:80]));
  gf_mult_by_ee m1031 (.i(rx_data[95:88]),.o(syn_4_tmp[95:88]));
  gf_mult_by_46 m1032 (.i(rx_data[103:96]),.o(syn_4_tmp[103:96]));
  gf_mult_by_14 m1033 (.i(rx_data[111:104]),.o(syn_4_tmp[111:104]));
  gf_mult_by_5d m1034 (.i(rx_data[119:112]),.o(syn_4_tmp[119:112]));
  gf_mult_by_b9 m1035 (.i(rx_data[127:120]),.o(syn_4_tmp[127:120]));
  gf_mult_by_5f m1036 (.i(rx_data[135:128]),.o(syn_4_tmp[135:128]));
  gf_mult_by_99 m1037 (.i(rx_data[143:136]),.o(syn_4_tmp[143:136]));
  gf_mult_by_65 m1038 (.i(rx_data[151:144]),.o(syn_4_tmp[151:144]));
  gf_mult_by_1e m1039 (.i(rx_data[159:152]),.o(syn_4_tmp[159:152]));
  gf_mult_by_fd m1040 (.i(rx_data[167:160]),.o(syn_4_tmp[167:160]));
  gf_mult_by_6b m1041 (.i(rx_data[175:168]),.o(syn_4_tmp[175:168]));
  gf_mult_by_fe m1042 (.i(rx_data[183:176]),.o(syn_4_tmp[183:176]));
  gf_mult_by_5b m1043 (.i(rx_data[191:184]),.o(syn_4_tmp[191:184]));
  gf_mult_by_d9 m1044 (.i(rx_data[199:192]),.o(syn_4_tmp[199:192]));
  gf_mult_by_11 m1045 (.i(rx_data[207:200]),.o(syn_4_tmp[207:200]));
  gf_mult_by_0d m1046 (.i(rx_data[215:208]),.o(syn_4_tmp[215:208]));
  gf_mult_by_d0 m1047 (.i(rx_data[223:216]),.o(syn_4_tmp[223:216]));
  gf_mult_by_81 m1048 (.i(rx_data[231:224]),.o(syn_4_tmp[231:224]));
  gf_mult_by_f8 m1049 (.i(rx_data[239:232]),.o(syn_4_tmp[239:232]));
  gf_mult_by_3b m1050 (.i(rx_data[247:240]),.o(syn_4_tmp[247:240]));
  gf_mult_by_97 m1051 (.i(rx_data[255:248]),.o(syn_4_tmp[255:248]));
  gf_mult_by_85 m1052 (.i(rx_data[263:256]),.o(syn_4_tmp[263:256]));
  gf_mult_by_b8 m1053 (.i(rx_data[271:264]),.o(syn_4_tmp[271:264]));
  gf_mult_by_4f m1054 (.i(rx_data[279:272]),.o(syn_4_tmp[279:272]));
  gf_mult_by_84 m1055 (.i(rx_data[287:280]),.o(syn_4_tmp[287:280]));
  gf_mult_by_a8 m1056 (.i(rx_data[295:288]),.o(syn_4_tmp[295:288]));
  gf_mult_by_52 m1057 (.i(rx_data[303:296]),.o(syn_4_tmp[303:296]));
  gf_mult_by_49 m1058 (.i(rx_data[311:304]),.o(syn_4_tmp[311:304]));
  gf_mult_by_e4 m1059 (.i(rx_data[319:312]),.o(syn_4_tmp[319:312]));
  gf_mult_by_e6 m1060 (.i(rx_data[327:320]),.o(syn_4_tmp[327:320]));
  gf_mult_by_c6 m1061 (.i(rx_data[335:328]),.o(syn_4_tmp[335:328]));
  gf_mult_by_fc m1062 (.i(rx_data[343:336]),.o(syn_4_tmp[343:336]));
  gf_mult_by_7b m1063 (.i(rx_data[351:344]),.o(syn_4_tmp[351:344]));
  gf_mult_by_e3 m1064 (.i(rx_data[359:352]),.o(syn_4_tmp[359:352]));
  gf_mult_by_96 m1065 (.i(rx_data[367:360]),.o(syn_4_tmp[367:360]));
  gf_mult_by_95 m1066 (.i(rx_data[375:368]),.o(syn_4_tmp[375:368]));
  gf_mult_by_a5 m1067 (.i(rx_data[383:376]),.o(syn_4_tmp[383:376]));
  gf_mult_by_82 m1068 (.i(rx_data[391:384]),.o(syn_4_tmp[391:384]));
  gf_mult_by_c8 m1069 (.i(rx_data[399:392]),.o(syn_4_tmp[399:392]));
  gf_mult_by_1c m1070 (.i(rx_data[407:400]),.o(syn_4_tmp[407:400]));
  gf_mult_by_dd m1071 (.i(rx_data[415:408]),.o(syn_4_tmp[415:408]));
  gf_mult_by_51 m1072 (.i(rx_data[423:416]),.o(syn_4_tmp[423:416]));
  gf_mult_by_79 m1073 (.i(rx_data[431:424]),.o(syn_4_tmp[431:424]));
  gf_mult_by_c3 m1074 (.i(rx_data[439:432]),.o(syn_4_tmp[439:432]));
  gf_mult_by_ac m1075 (.i(rx_data[447:440]),.o(syn_4_tmp[447:440]));
  gf_mult_by_12 m1076 (.i(rx_data[455:448]),.o(syn_4_tmp[455:448]));
  gf_mult_by_3d m1077 (.i(rx_data[463:456]),.o(syn_4_tmp[463:456]));
  gf_mult_by_f7 m1078 (.i(rx_data[471:464]),.o(syn_4_tmp[471:464]));
  gf_mult_by_cb m1079 (.i(rx_data[479:472]),.o(syn_4_tmp[479:472]));
  gf_mult_by_2c m1080 (.i(rx_data[487:480]),.o(syn_4_tmp[487:480]));
  gf_mult_by_fa m1081 (.i(rx_data[495:488]),.o(syn_4_tmp[495:488]));
  gf_mult_by_1b m1082 (.i(rx_data[503:496]),.o(syn_4_tmp[503:496]));
  gf_mult_by_ad m1083 (.i(rx_data[511:504]),.o(syn_4_tmp[511:504]));
  gf_mult_by_02 m1084 (.i(rx_data[519:512]),.o(syn_4_tmp[519:512]));
  gf_mult_by_20 m1085 (.i(rx_data[527:520]),.o(syn_4_tmp[527:520]));
  gf_mult_by_3a m1086 (.i(rx_data[535:528]),.o(syn_4_tmp[535:528]));
  gf_mult_by_87 m1087 (.i(rx_data[543:536]),.o(syn_4_tmp[543:536]));
  gf_mult_by_98 m1088 (.i(rx_data[551:544]),.o(syn_4_tmp[551:544]));
  gf_mult_by_75 m1089 (.i(rx_data[559:552]),.o(syn_4_tmp[559:552]));
  gf_mult_by_03 m1090 (.i(rx_data[567:560]),.o(syn_4_tmp[567:560]));
  gf_mult_by_30 m1091 (.i(rx_data[575:568]),.o(syn_4_tmp[575:568]));
  gf_mult_by_27 m1092 (.i(rx_data[583:576]),.o(syn_4_tmp[583:576]));
  gf_mult_by_4a m1093 (.i(rx_data[591:584]),.o(syn_4_tmp[591:584]));
  gf_mult_by_d4 m1094 (.i(rx_data[599:592]),.o(syn_4_tmp[599:592]));
  gf_mult_by_c1 m1095 (.i(rx_data[607:600]),.o(syn_4_tmp[607:600]));
  gf_mult_by_8c m1096 (.i(rx_data[615:608]),.o(syn_4_tmp[615:608]));
  gf_mult_by_28 m1097 (.i(rx_data[623:616]),.o(syn_4_tmp[623:616]));
  gf_mult_by_ba m1098 (.i(rx_data[631:624]),.o(syn_4_tmp[631:624]));
  gf_mult_by_6f m1099 (.i(rx_data[639:632]),.o(syn_4_tmp[639:632]));
  gf_mult_by_be m1100 (.i(rx_data[647:640]),.o(syn_4_tmp[647:640]));
  gf_mult_by_2f m1101 (.i(rx_data[655:648]),.o(syn_4_tmp[655:648]));
  gf_mult_by_ca m1102 (.i(rx_data[663:656]),.o(syn_4_tmp[663:656]));
  gf_mult_by_3c m1103 (.i(rx_data[671:664]),.o(syn_4_tmp[671:664]));
  gf_mult_by_e7 m1104 (.i(rx_data[679:672]),.o(syn_4_tmp[679:672]));
  gf_mult_by_d6 m1105 (.i(rx_data[687:680]),.o(syn_4_tmp[687:680]));
  gf_mult_by_e1 m1106 (.i(rx_data[695:688]),.o(syn_4_tmp[695:688]));
  gf_mult_by_b6 m1107 (.i(rx_data[703:696]),.o(syn_4_tmp[703:696]));
  gf_mult_by_af m1108 (.i(rx_data[711:704]),.o(syn_4_tmp[711:704]));
  gf_mult_by_22 m1109 (.i(rx_data[719:712]),.o(syn_4_tmp[719:712]));
  gf_mult_by_1a m1110 (.i(rx_data[727:720]),.o(syn_4_tmp[727:720]));
  gf_mult_by_bd m1111 (.i(rx_data[735:728]),.o(syn_4_tmp[735:728]));
  gf_mult_by_1f m1112 (.i(rx_data[743:736]),.o(syn_4_tmp[743:736]));
  gf_mult_by_ed m1113 (.i(rx_data[751:744]),.o(syn_4_tmp[751:744]));
  gf_mult_by_76 m1114 (.i(rx_data[759:752]),.o(syn_4_tmp[759:752]));
  gf_mult_by_33 m1115 (.i(rx_data[767:760]),.o(syn_4_tmp[767:760]));
  gf_mult_by_17 m1116 (.i(rx_data[775:768]),.o(syn_4_tmp[775:768]));
  gf_mult_by_6d m1117 (.i(rx_data[783:776]),.o(syn_4_tmp[783:776]));
  gf_mult_by_9e m1118 (.i(rx_data[791:784]),.o(syn_4_tmp[791:784]));
  gf_mult_by_15 m1119 (.i(rx_data[799:792]),.o(syn_4_tmp[799:792]));
  gf_mult_by_4d m1120 (.i(rx_data[807:800]),.o(syn_4_tmp[807:800]));
  gf_mult_by_a4 m1121 (.i(rx_data[815:808]),.o(syn_4_tmp[815:808]));
  gf_mult_by_92 m1122 (.i(rx_data[823:816]),.o(syn_4_tmp[823:816]));
  gf_mult_by_d5 m1123 (.i(rx_data[831:824]),.o(syn_4_tmp[831:824]));
  gf_mult_by_d1 m1124 (.i(rx_data[839:832]),.o(syn_4_tmp[839:832]));
  gf_mult_by_91 m1125 (.i(rx_data[847:840]),.o(syn_4_tmp[847:840]));
  gf_mult_by_e5 m1126 (.i(rx_data[855:848]),.o(syn_4_tmp[855:848]));
  gf_mult_by_f6 m1127 (.i(rx_data[863:856]),.o(syn_4_tmp[863:856]));
  gf_mult_by_db m1128 (.i(rx_data[871:864]),.o(syn_4_tmp[871:864]));
  gf_mult_by_31 m1129 (.i(rx_data[879:872]),.o(syn_4_tmp[879:872]));
  gf_mult_by_37 m1130 (.i(rx_data[887:880]),.o(syn_4_tmp[887:880]));
  gf_mult_by_57 m1131 (.i(rx_data[895:888]),.o(syn_4_tmp[895:888]));
  gf_mult_by_19 m1132 (.i(rx_data[903:896]),.o(syn_4_tmp[903:896]));
  gf_mult_by_8d m1133 (.i(rx_data[911:904]),.o(syn_4_tmp[911:904]));
  gf_mult_by_38 m1134 (.i(rx_data[919:912]),.o(syn_4_tmp[919:912]));
  gf_mult_by_a7 m1135 (.i(rx_data[927:920]),.o(syn_4_tmp[927:920]));
  gf_mult_by_a2 m1136 (.i(rx_data[935:928]),.o(syn_4_tmp[935:928]));
  gf_mult_by_f2 m1137 (.i(rx_data[943:936]),.o(syn_4_tmp[943:936]));
  gf_mult_by_9b m1138 (.i(rx_data[951:944]),.o(syn_4_tmp[951:944]));
  gf_mult_by_45 m1139 (.i(rx_data[959:952]),.o(syn_4_tmp[959:952]));
  gf_mult_by_24 m1140 (.i(rx_data[967:960]),.o(syn_4_tmp[967:960]));
  gf_mult_by_7a m1141 (.i(rx_data[975:968]),.o(syn_4_tmp[975:968]));
  gf_mult_by_f3 m1142 (.i(rx_data[983:976]),.o(syn_4_tmp[983:976]));
  gf_mult_by_8b m1143 (.i(rx_data[991:984]),.o(syn_4_tmp[991:984]));
  gf_mult_by_58 m1144 (.i(rx_data[999:992]),.o(syn_4_tmp[999:992]));
  gf_mult_by_e9 m1145 (.i(rx_data[1007:1000]),.o(syn_4_tmp[1007:1000]));
  gf_mult_by_36 m1146 (.i(rx_data[1015:1008]),.o(syn_4_tmp[1015:1008]));
  gf_mult_by_47 m1147 (.i(rx_data[1023:1016]),.o(syn_4_tmp[1023:1016]));
  gf_mult_by_04 m1148 (.i(rx_data[1031:1024]),.o(syn_4_tmp[1031:1024]));
  gf_mult_by_40 m1149 (.i(rx_data[1039:1032]),.o(syn_4_tmp[1039:1032]));
  gf_mult_by_74 m1150 (.i(rx_data[1047:1040]),.o(syn_4_tmp[1047:1040]));
  gf_mult_by_13 m1151 (.i(rx_data[1055:1048]),.o(syn_4_tmp[1055:1048]));
  gf_mult_by_2d m1152 (.i(rx_data[1063:1056]),.o(syn_4_tmp[1063:1056]));
  gf_mult_by_ea m1153 (.i(rx_data[1071:1064]),.o(syn_4_tmp[1071:1064]));
  gf_mult_by_06 m1154 (.i(rx_data[1079:1072]),.o(syn_4_tmp[1079:1072]));
  gf_mult_by_60 m1155 (.i(rx_data[1087:1080]),.o(syn_4_tmp[1087:1080]));
  gf_mult_by_4e m1156 (.i(rx_data[1095:1088]),.o(syn_4_tmp[1095:1088]));
  gf_mult_by_94 m1157 (.i(rx_data[1103:1096]),.o(syn_4_tmp[1103:1096]));
  gf_mult_by_b5 m1158 (.i(rx_data[1111:1104]),.o(syn_4_tmp[1111:1104]));
  gf_mult_by_9f m1159 (.i(rx_data[1119:1112]),.o(syn_4_tmp[1119:1112]));
  gf_mult_by_05 m1160 (.i(rx_data[1127:1120]),.o(syn_4_tmp[1127:1120]));
  gf_mult_by_50 m1161 (.i(rx_data[1135:1128]),.o(syn_4_tmp[1135:1128]));
  gf_mult_by_69 m1162 (.i(rx_data[1143:1136]),.o(syn_4_tmp[1143:1136]));
  gf_mult_by_de m1163 (.i(rx_data[1151:1144]),.o(syn_4_tmp[1151:1144]));
  gf_mult_by_61 m1164 (.i(rx_data[1159:1152]),.o(syn_4_tmp[1159:1152]));
  gf_mult_by_5e m1165 (.i(rx_data[1167:1160]),.o(syn_4_tmp[1167:1160]));
  gf_mult_by_89 m1166 (.i(rx_data[1175:1168]),.o(syn_4_tmp[1175:1168]));
  gf_mult_by_78 m1167 (.i(rx_data[1183:1176]),.o(syn_4_tmp[1183:1176]));
  gf_mult_by_d3 m1168 (.i(rx_data[1191:1184]),.o(syn_4_tmp[1191:1184]));
  gf_mult_by_b1 m1169 (.i(rx_data[1199:1192]),.o(syn_4_tmp[1199:1192]));
  gf_mult_by_df m1170 (.i(rx_data[1207:1200]),.o(syn_4_tmp[1207:1200]));
  gf_mult_by_71 m1171 (.i(rx_data[1215:1208]),.o(syn_4_tmp[1215:1208]));
  gf_mult_by_43 m1172 (.i(rx_data[1223:1216]),.o(syn_4_tmp[1223:1216]));
  gf_mult_by_44 m1173 (.i(rx_data[1231:1224]),.o(syn_4_tmp[1231:1224]));
  gf_mult_by_34 m1174 (.i(rx_data[1239:1232]),.o(syn_4_tmp[1239:1232]));
  gf_mult_by_67 m1175 (.i(rx_data[1247:1240]),.o(syn_4_tmp[1247:1240]));
  gf_mult_by_3e m1176 (.i(rx_data[1255:1248]),.o(syn_4_tmp[1255:1248]));
  gf_mult_by_c7 m1177 (.i(rx_data[1263:1256]),.o(syn_4_tmp[1263:1256]));
  gf_mult_by_ec m1178 (.i(rx_data[1271:1264]),.o(syn_4_tmp[1271:1264]));
  gf_mult_by_66 m1179 (.i(rx_data[1279:1272]),.o(syn_4_tmp[1279:1272]));
  gf_mult_by_2e m1180 (.i(rx_data[1287:1280]),.o(syn_4_tmp[1287:1280]));
  gf_mult_by_da m1181 (.i(rx_data[1295:1288]),.o(syn_4_tmp[1295:1288]));
  gf_mult_by_21 m1182 (.i(rx_data[1303:1296]),.o(syn_4_tmp[1303:1296]));
  gf_mult_by_2a m1183 (.i(rx_data[1311:1304]),.o(syn_4_tmp[1311:1304]));
  gf_mult_by_9a m1184 (.i(rx_data[1319:1312]),.o(syn_4_tmp[1319:1312]));
  gf_mult_by_55 m1185 (.i(rx_data[1327:1320]),.o(syn_4_tmp[1327:1320]));
  gf_mult_by_39 m1186 (.i(rx_data[1335:1328]),.o(syn_4_tmp[1335:1328]));
  gf_mult_by_b7 m1187 (.i(rx_data[1343:1336]),.o(syn_4_tmp[1343:1336]));
  gf_mult_by_bf m1188 (.i(rx_data[1351:1344]),.o(syn_4_tmp[1351:1344]));
  gf_mult_by_3f m1189 (.i(rx_data[1359:1352]),.o(syn_4_tmp[1359:1352]));
  gf_mult_by_d7 m1190 (.i(rx_data[1367:1360]),.o(syn_4_tmp[1367:1360]));
  gf_mult_by_f1 m1191 (.i(rx_data[1375:1368]),.o(syn_4_tmp[1375:1368]));
  gf_mult_by_ab m1192 (.i(rx_data[1383:1376]),.o(syn_4_tmp[1383:1376]));
  gf_mult_by_62 m1193 (.i(rx_data[1391:1384]),.o(syn_4_tmp[1391:1384]));
  gf_mult_by_6e m1194 (.i(rx_data[1399:1392]),.o(syn_4_tmp[1399:1392]));
  gf_mult_by_ae m1195 (.i(rx_data[1407:1400]),.o(syn_4_tmp[1407:1400]));
  gf_mult_by_32 m1196 (.i(rx_data[1415:1408]),.o(syn_4_tmp[1415:1408]));
  gf_mult_by_07 m1197 (.i(rx_data[1423:1416]),.o(syn_4_tmp[1423:1416]));
  gf_mult_by_70 m1198 (.i(rx_data[1431:1424]),.o(syn_4_tmp[1431:1424]));
  gf_mult_by_53 m1199 (.i(rx_data[1439:1432]),.o(syn_4_tmp[1439:1432]));
  gf_mult_by_59 m1200 (.i(rx_data[1447:1440]),.o(syn_4_tmp[1447:1440]));
  gf_mult_by_f9 m1201 (.i(rx_data[1455:1448]),.o(syn_4_tmp[1455:1448]));
  gf_mult_by_2b m1202 (.i(rx_data[1463:1456]),.o(syn_4_tmp[1463:1456]));
  gf_mult_by_8a m1203 (.i(rx_data[1471:1464]),.o(syn_4_tmp[1471:1464]));
  gf_mult_by_48 m1204 (.i(rx_data[1479:1472]),.o(syn_4_tmp[1479:1472]));
  gf_mult_by_f4 m1205 (.i(rx_data[1487:1480]),.o(syn_4_tmp[1487:1480]));
  gf_mult_by_fb m1206 (.i(rx_data[1495:1488]),.o(syn_4_tmp[1495:1488]));
  gf_mult_by_0b m1207 (.i(rx_data[1503:1496]),.o(syn_4_tmp[1503:1496]));
  gf_mult_by_b0 m1208 (.i(rx_data[1511:1504]),.o(syn_4_tmp[1511:1504]));
  gf_mult_by_cf m1209 (.i(rx_data[1519:1512]),.o(syn_4_tmp[1519:1512]));
  gf_mult_by_6c m1210 (.i(rx_data[1527:1520]),.o(syn_4_tmp[1527:1520]));
  gf_mult_by_8e m1211 (.i(rx_data[1535:1528]),.o(syn_4_tmp[1535:1528]));
  gf_mult_by_08 m1212 (.i(rx_data[1543:1536]),.o(syn_4_tmp[1543:1536]));
  gf_mult_by_80 m1213 (.i(rx_data[1551:1544]),.o(syn_4_tmp[1551:1544]));
  gf_mult_by_e8 m1214 (.i(rx_data[1559:1552]),.o(syn_4_tmp[1559:1552]));
  gf_mult_by_26 m1215 (.i(rx_data[1567:1560]),.o(syn_4_tmp[1567:1560]));
  gf_mult_by_5a m1216 (.i(rx_data[1575:1568]),.o(syn_4_tmp[1575:1568]));
  gf_mult_by_c9 m1217 (.i(rx_data[1583:1576]),.o(syn_4_tmp[1583:1576]));
  gf_mult_by_0c m1218 (.i(rx_data[1591:1584]),.o(syn_4_tmp[1591:1584]));
  gf_mult_by_c0 m1219 (.i(rx_data[1599:1592]),.o(syn_4_tmp[1599:1592]));
  gf_mult_by_9c m1220 (.i(rx_data[1607:1600]),.o(syn_4_tmp[1607:1600]));
  gf_mult_by_35 m1221 (.i(rx_data[1615:1608]),.o(syn_4_tmp[1615:1608]));
  gf_mult_by_77 m1222 (.i(rx_data[1623:1616]),.o(syn_4_tmp[1623:1616]));
  gf_mult_by_23 m1223 (.i(rx_data[1631:1624]),.o(syn_4_tmp[1631:1624]));
  gf_mult_by_0a m1224 (.i(rx_data[1639:1632]),.o(syn_4_tmp[1639:1632]));
  gf_mult_by_a0 m1225 (.i(rx_data[1647:1640]),.o(syn_4_tmp[1647:1640]));
  gf_mult_by_d2 m1226 (.i(rx_data[1655:1648]),.o(syn_4_tmp[1655:1648]));
  gf_mult_by_a1 m1227 (.i(rx_data[1663:1656]),.o(syn_4_tmp[1663:1656]));
  gf_mult_by_c2 m1228 (.i(rx_data[1671:1664]),.o(syn_4_tmp[1671:1664]));
  gf_mult_by_bc m1229 (.i(rx_data[1679:1672]),.o(syn_4_tmp[1679:1672]));
  gf_mult_by_0f m1230 (.i(rx_data[1687:1680]),.o(syn_4_tmp[1687:1680]));
  gf_mult_by_f0 m1231 (.i(rx_data[1695:1688]),.o(syn_4_tmp[1695:1688]));
  gf_mult_by_bb m1232 (.i(rx_data[1703:1696]),.o(syn_4_tmp[1703:1696]));
  gf_mult_by_7f m1233 (.i(rx_data[1711:1704]),.o(syn_4_tmp[1711:1704]));
  gf_mult_by_a3 m1234 (.i(rx_data[1719:1712]),.o(syn_4_tmp[1719:1712]));
  gf_mult_by_e2 m1235 (.i(rx_data[1727:1720]),.o(syn_4_tmp[1727:1720]));
  gf_mult_by_86 m1236 (.i(rx_data[1735:1728]),.o(syn_4_tmp[1735:1728]));
  gf_mult_by_88 m1237 (.i(rx_data[1743:1736]),.o(syn_4_tmp[1743:1736]));
  gf_mult_by_68 m1238 (.i(rx_data[1751:1744]),.o(syn_4_tmp[1751:1744]));
  gf_mult_by_ce m1239 (.i(rx_data[1759:1752]),.o(syn_4_tmp[1759:1752]));
  gf_mult_by_7c m1240 (.i(rx_data[1767:1760]),.o(syn_4_tmp[1767:1760]));
  gf_mult_by_93 m1241 (.i(rx_data[1775:1768]),.o(syn_4_tmp[1775:1768]));
  gf_mult_by_c5 m1242 (.i(rx_data[1783:1776]),.o(syn_4_tmp[1783:1776]));
  gf_mult_by_cc m1243 (.i(rx_data[1791:1784]),.o(syn_4_tmp[1791:1784]));
  gf_mult_by_5c m1244 (.i(rx_data[1799:1792]),.o(syn_4_tmp[1799:1792]));
  gf_mult_by_a9 m1245 (.i(rx_data[1807:1800]),.o(syn_4_tmp[1807:1800]));
  gf_mult_by_42 m1246 (.i(rx_data[1815:1808]),.o(syn_4_tmp[1815:1808]));
  gf_mult_by_54 m1247 (.i(rx_data[1823:1816]),.o(syn_4_tmp[1823:1816]));
  gf_mult_by_29 m1248 (.i(rx_data[1831:1824]),.o(syn_4_tmp[1831:1824]));
  gf_mult_by_aa m1249 (.i(rx_data[1839:1832]),.o(syn_4_tmp[1839:1832]));
  gf_mult_by_72 m1250 (.i(rx_data[1847:1840]),.o(syn_4_tmp[1847:1840]));
  gf_mult_by_73 m1251 (.i(rx_data[1855:1848]),.o(syn_4_tmp[1855:1848]));
  gf_mult_by_63 m1252 (.i(rx_data[1863:1856]),.o(syn_4_tmp[1863:1856]));
  gf_mult_by_7e m1253 (.i(rx_data[1871:1864]),.o(syn_4_tmp[1871:1864]));
  gf_mult_by_b3 m1254 (.i(rx_data[1879:1872]),.o(syn_4_tmp[1879:1872]));
  gf_mult_by_ff m1255 (.i(rx_data[1887:1880]),.o(syn_4_tmp[1887:1880]));
  gf_mult_by_4b m1256 (.i(rx_data[1895:1888]),.o(syn_4_tmp[1895:1888]));
  gf_mult_by_c4 m1257 (.i(rx_data[1903:1896]),.o(syn_4_tmp[1903:1896]));
  gf_mult_by_dc m1258 (.i(rx_data[1911:1904]),.o(syn_4_tmp[1911:1904]));
  gf_mult_by_41 m1259 (.i(rx_data[1919:1912]),.o(syn_4_tmp[1919:1912]));
  gf_mult_by_64 m1260 (.i(rx_data[1927:1920]),.o(syn_4_tmp[1927:1920]));
  gf_mult_by_0e m1261 (.i(rx_data[1935:1928]),.o(syn_4_tmp[1935:1928]));
  gf_mult_by_e0 m1262 (.i(rx_data[1943:1936]),.o(syn_4_tmp[1943:1936]));
  gf_mult_by_a6 m1263 (.i(rx_data[1951:1944]),.o(syn_4_tmp[1951:1944]));
  gf_mult_by_b2 m1264 (.i(rx_data[1959:1952]),.o(syn_4_tmp[1959:1952]));
  gf_mult_by_ef m1265 (.i(rx_data[1967:1960]),.o(syn_4_tmp[1967:1960]));
  gf_mult_by_56 m1266 (.i(rx_data[1975:1968]),.o(syn_4_tmp[1975:1968]));
  gf_mult_by_09 m1267 (.i(rx_data[1983:1976]),.o(syn_4_tmp[1983:1976]));
  gf_mult_by_90 m1268 (.i(rx_data[1991:1984]),.o(syn_4_tmp[1991:1984]));
  gf_mult_by_f5 m1269 (.i(rx_data[1999:1992]),.o(syn_4_tmp[1999:1992]));
  gf_mult_by_eb m1270 (.i(rx_data[2007:2000]),.o(syn_4_tmp[2007:2000]));
  gf_mult_by_16 m1271 (.i(rx_data[2015:2008]),.o(syn_4_tmp[2015:2008]));
  gf_mult_by_7d m1272 (.i(rx_data[2023:2016]),.o(syn_4_tmp[2023:2016]));
  gf_mult_by_83 m1273 (.i(rx_data[2031:2024]),.o(syn_4_tmp[2031:2024]));
  gf_mult_by_d8 m1274 (.i(rx_data[2039:2032]),.o(syn_4_tmp[2039:2032]));
  assign syndrome[39:32] =
      syn_4_tmp[7:0] ^ syn_4_tmp[15:8] ^ syn_4_tmp[23:16] ^ 
      syn_4_tmp[31:24] ^ syn_4_tmp[39:32] ^ syn_4_tmp[47:40] ^ 
      syn_4_tmp[55:48] ^ syn_4_tmp[63:56] ^ syn_4_tmp[71:64] ^ 
      syn_4_tmp[79:72] ^ syn_4_tmp[87:80] ^ syn_4_tmp[95:88] ^ 
      syn_4_tmp[103:96] ^ syn_4_tmp[111:104] ^ syn_4_tmp[119:112] ^ 
      syn_4_tmp[127:120] ^ syn_4_tmp[135:128] ^ syn_4_tmp[143:136] ^ 
      syn_4_tmp[151:144] ^ syn_4_tmp[159:152] ^ syn_4_tmp[167:160] ^ 
      syn_4_tmp[175:168] ^ syn_4_tmp[183:176] ^ syn_4_tmp[191:184] ^ 
      syn_4_tmp[199:192] ^ syn_4_tmp[207:200] ^ syn_4_tmp[215:208] ^ 
      syn_4_tmp[223:216] ^ syn_4_tmp[231:224] ^ syn_4_tmp[239:232] ^ 
      syn_4_tmp[247:240] ^ syn_4_tmp[255:248] ^ syn_4_tmp[263:256] ^ 
      syn_4_tmp[271:264] ^ syn_4_tmp[279:272] ^ syn_4_tmp[287:280] ^ 
      syn_4_tmp[295:288] ^ syn_4_tmp[303:296] ^ syn_4_tmp[311:304] ^ 
      syn_4_tmp[319:312] ^ syn_4_tmp[327:320] ^ syn_4_tmp[335:328] ^ 
      syn_4_tmp[343:336] ^ syn_4_tmp[351:344] ^ syn_4_tmp[359:352] ^ 
      syn_4_tmp[367:360] ^ syn_4_tmp[375:368] ^ syn_4_tmp[383:376] ^ 
      syn_4_tmp[391:384] ^ syn_4_tmp[399:392] ^ syn_4_tmp[407:400] ^ 
      syn_4_tmp[415:408] ^ syn_4_tmp[423:416] ^ syn_4_tmp[431:424] ^ 
      syn_4_tmp[439:432] ^ syn_4_tmp[447:440] ^ syn_4_tmp[455:448] ^ 
      syn_4_tmp[463:456] ^ syn_4_tmp[471:464] ^ syn_4_tmp[479:472] ^ 
      syn_4_tmp[487:480] ^ syn_4_tmp[495:488] ^ syn_4_tmp[503:496] ^ 
      syn_4_tmp[511:504] ^ syn_4_tmp[519:512] ^ syn_4_tmp[527:520] ^ 
      syn_4_tmp[535:528] ^ syn_4_tmp[543:536] ^ syn_4_tmp[551:544] ^ 
      syn_4_tmp[559:552] ^ syn_4_tmp[567:560] ^ syn_4_tmp[575:568] ^ 
      syn_4_tmp[583:576] ^ syn_4_tmp[591:584] ^ syn_4_tmp[599:592] ^ 
      syn_4_tmp[607:600] ^ syn_4_tmp[615:608] ^ syn_4_tmp[623:616] ^ 
      syn_4_tmp[631:624] ^ syn_4_tmp[639:632] ^ syn_4_tmp[647:640] ^ 
      syn_4_tmp[655:648] ^ syn_4_tmp[663:656] ^ syn_4_tmp[671:664] ^ 
      syn_4_tmp[679:672] ^ syn_4_tmp[687:680] ^ syn_4_tmp[695:688] ^ 
      syn_4_tmp[703:696] ^ syn_4_tmp[711:704] ^ syn_4_tmp[719:712] ^ 
      syn_4_tmp[727:720] ^ syn_4_tmp[735:728] ^ syn_4_tmp[743:736] ^ 
      syn_4_tmp[751:744] ^ syn_4_tmp[759:752] ^ syn_4_tmp[767:760] ^ 
      syn_4_tmp[775:768] ^ syn_4_tmp[783:776] ^ syn_4_tmp[791:784] ^ 
      syn_4_tmp[799:792] ^ syn_4_tmp[807:800] ^ syn_4_tmp[815:808] ^ 
      syn_4_tmp[823:816] ^ syn_4_tmp[831:824] ^ syn_4_tmp[839:832] ^ 
      syn_4_tmp[847:840] ^ syn_4_tmp[855:848] ^ syn_4_tmp[863:856] ^ 
      syn_4_tmp[871:864] ^ syn_4_tmp[879:872] ^ syn_4_tmp[887:880] ^ 
      syn_4_tmp[895:888] ^ syn_4_tmp[903:896] ^ syn_4_tmp[911:904] ^ 
      syn_4_tmp[919:912] ^ syn_4_tmp[927:920] ^ syn_4_tmp[935:928] ^ 
      syn_4_tmp[943:936] ^ syn_4_tmp[951:944] ^ syn_4_tmp[959:952] ^ 
      syn_4_tmp[967:960] ^ syn_4_tmp[975:968] ^ syn_4_tmp[983:976] ^ 
      syn_4_tmp[991:984] ^ syn_4_tmp[999:992] ^ syn_4_tmp[1007:1000] ^ 
      syn_4_tmp[1015:1008] ^ syn_4_tmp[1023:1016] ^ syn_4_tmp[1031:1024] ^ 
      syn_4_tmp[1039:1032] ^ syn_4_tmp[1047:1040] ^ syn_4_tmp[1055:1048] ^ 
      syn_4_tmp[1063:1056] ^ syn_4_tmp[1071:1064] ^ syn_4_tmp[1079:1072] ^ 
      syn_4_tmp[1087:1080] ^ syn_4_tmp[1095:1088] ^ syn_4_tmp[1103:1096] ^ 
      syn_4_tmp[1111:1104] ^ syn_4_tmp[1119:1112] ^ syn_4_tmp[1127:1120] ^ 
      syn_4_tmp[1135:1128] ^ syn_4_tmp[1143:1136] ^ syn_4_tmp[1151:1144] ^ 
      syn_4_tmp[1159:1152] ^ syn_4_tmp[1167:1160] ^ syn_4_tmp[1175:1168] ^ 
      syn_4_tmp[1183:1176] ^ syn_4_tmp[1191:1184] ^ syn_4_tmp[1199:1192] ^ 
      syn_4_tmp[1207:1200] ^ syn_4_tmp[1215:1208] ^ syn_4_tmp[1223:1216] ^ 
      syn_4_tmp[1231:1224] ^ syn_4_tmp[1239:1232] ^ syn_4_tmp[1247:1240] ^ 
      syn_4_tmp[1255:1248] ^ syn_4_tmp[1263:1256] ^ syn_4_tmp[1271:1264] ^ 
      syn_4_tmp[1279:1272] ^ syn_4_tmp[1287:1280] ^ syn_4_tmp[1295:1288] ^ 
      syn_4_tmp[1303:1296] ^ syn_4_tmp[1311:1304] ^ syn_4_tmp[1319:1312] ^ 
      syn_4_tmp[1327:1320] ^ syn_4_tmp[1335:1328] ^ syn_4_tmp[1343:1336] ^ 
      syn_4_tmp[1351:1344] ^ syn_4_tmp[1359:1352] ^ syn_4_tmp[1367:1360] ^ 
      syn_4_tmp[1375:1368] ^ syn_4_tmp[1383:1376] ^ syn_4_tmp[1391:1384] ^ 
      syn_4_tmp[1399:1392] ^ syn_4_tmp[1407:1400] ^ syn_4_tmp[1415:1408] ^ 
      syn_4_tmp[1423:1416] ^ syn_4_tmp[1431:1424] ^ syn_4_tmp[1439:1432] ^ 
      syn_4_tmp[1447:1440] ^ syn_4_tmp[1455:1448] ^ syn_4_tmp[1463:1456] ^ 
      syn_4_tmp[1471:1464] ^ syn_4_tmp[1479:1472] ^ syn_4_tmp[1487:1480] ^ 
      syn_4_tmp[1495:1488] ^ syn_4_tmp[1503:1496] ^ syn_4_tmp[1511:1504] ^ 
      syn_4_tmp[1519:1512] ^ syn_4_tmp[1527:1520] ^ syn_4_tmp[1535:1528] ^ 
      syn_4_tmp[1543:1536] ^ syn_4_tmp[1551:1544] ^ syn_4_tmp[1559:1552] ^ 
      syn_4_tmp[1567:1560] ^ syn_4_tmp[1575:1568] ^ syn_4_tmp[1583:1576] ^ 
      syn_4_tmp[1591:1584] ^ syn_4_tmp[1599:1592] ^ syn_4_tmp[1607:1600] ^ 
      syn_4_tmp[1615:1608] ^ syn_4_tmp[1623:1616] ^ syn_4_tmp[1631:1624] ^ 
      syn_4_tmp[1639:1632] ^ syn_4_tmp[1647:1640] ^ syn_4_tmp[1655:1648] ^ 
      syn_4_tmp[1663:1656] ^ syn_4_tmp[1671:1664] ^ syn_4_tmp[1679:1672] ^ 
      syn_4_tmp[1687:1680] ^ syn_4_tmp[1695:1688] ^ syn_4_tmp[1703:1696] ^ 
      syn_4_tmp[1711:1704] ^ syn_4_tmp[1719:1712] ^ syn_4_tmp[1727:1720] ^ 
      syn_4_tmp[1735:1728] ^ syn_4_tmp[1743:1736] ^ syn_4_tmp[1751:1744] ^ 
      syn_4_tmp[1759:1752] ^ syn_4_tmp[1767:1760] ^ syn_4_tmp[1775:1768] ^ 
      syn_4_tmp[1783:1776] ^ syn_4_tmp[1791:1784] ^ syn_4_tmp[1799:1792] ^ 
      syn_4_tmp[1807:1800] ^ syn_4_tmp[1815:1808] ^ syn_4_tmp[1823:1816] ^ 
      syn_4_tmp[1831:1824] ^ syn_4_tmp[1839:1832] ^ syn_4_tmp[1847:1840] ^ 
      syn_4_tmp[1855:1848] ^ syn_4_tmp[1863:1856] ^ syn_4_tmp[1871:1864] ^ 
      syn_4_tmp[1879:1872] ^ syn_4_tmp[1887:1880] ^ syn_4_tmp[1895:1888] ^ 
      syn_4_tmp[1903:1896] ^ syn_4_tmp[1911:1904] ^ syn_4_tmp[1919:1912] ^ 
      syn_4_tmp[1927:1920] ^ syn_4_tmp[1935:1928] ^ syn_4_tmp[1943:1936] ^ 
      syn_4_tmp[1951:1944] ^ syn_4_tmp[1959:1952] ^ syn_4_tmp[1967:1960] ^ 
      syn_4_tmp[1975:1968] ^ syn_4_tmp[1983:1976] ^ syn_4_tmp[1991:1984] ^ 
      syn_4_tmp[1999:1992] ^ syn_4_tmp[2007:2000] ^ syn_4_tmp[2015:2008] ^ 
      syn_4_tmp[2023:2016] ^ syn_4_tmp[2031:2024] ^ syn_4_tmp[2039:2032];

// syndrome 5
  wire [2039:0] syn_5_tmp;
  gf_mult_by_01 m1275 (.i(rx_data[7:0]),.o(syn_5_tmp[7:0]));
  gf_mult_by_20 m1276 (.i(rx_data[15:8]),.o(syn_5_tmp[15:8]));
  gf_mult_by_74 m1277 (.i(rx_data[23:16]),.o(syn_5_tmp[23:16]));
  gf_mult_by_26 m1278 (.i(rx_data[31:24]),.o(syn_5_tmp[31:24]));
  gf_mult_by_b4 m1279 (.i(rx_data[39:32]),.o(syn_5_tmp[39:32]));
  gf_mult_by_03 m1280 (.i(rx_data[47:40]),.o(syn_5_tmp[47:40]));
  gf_mult_by_60 m1281 (.i(rx_data[55:48]),.o(syn_5_tmp[55:48]));
  gf_mult_by_9c m1282 (.i(rx_data[63:56]),.o(syn_5_tmp[63:56]));
  gf_mult_by_6a m1283 (.i(rx_data[71:64]),.o(syn_5_tmp[71:64]));
  gf_mult_by_c1 m1284 (.i(rx_data[79:72]),.o(syn_5_tmp[79:72]));
  gf_mult_by_05 m1285 (.i(rx_data[87:80]),.o(syn_5_tmp[87:80]));
  gf_mult_by_a0 m1286 (.i(rx_data[95:88]),.o(syn_5_tmp[95:88]));
  gf_mult_by_b9 m1287 (.i(rx_data[103:96]),.o(syn_5_tmp[103:96]));
  gf_mult_by_be m1288 (.i(rx_data[111:104]),.o(syn_5_tmp[111:104]));
  gf_mult_by_5e m1289 (.i(rx_data[119:112]),.o(syn_5_tmp[119:112]));
  gf_mult_by_0f m1290 (.i(rx_data[127:120]),.o(syn_5_tmp[127:120]));
  gf_mult_by_fd m1291 (.i(rx_data[135:128]),.o(syn_5_tmp[135:128]));
  gf_mult_by_d6 m1292 (.i(rx_data[143:136]),.o(syn_5_tmp[143:136]));
  gf_mult_by_df m1293 (.i(rx_data[151:144]),.o(syn_5_tmp[151:144]));
  gf_mult_by_e2 m1294 (.i(rx_data[159:152]),.o(syn_5_tmp[159:152]));
  gf_mult_by_11 m1295 (.i(rx_data[167:160]),.o(syn_5_tmp[167:160]));
  gf_mult_by_1a m1296 (.i(rx_data[175:168]),.o(syn_5_tmp[175:168]));
  gf_mult_by_67 m1297 (.i(rx_data[183:176]),.o(syn_5_tmp[183:176]));
  gf_mult_by_7c m1298 (.i(rx_data[191:184]),.o(syn_5_tmp[191:184]));
  gf_mult_by_3b m1299 (.i(rx_data[199:192]),.o(syn_5_tmp[199:192]));
  gf_mult_by_33 m1300 (.i(rx_data[207:200]),.o(syn_5_tmp[207:200]));
  gf_mult_by_2e m1301 (.i(rx_data[215:208]),.o(syn_5_tmp[215:208]));
  gf_mult_by_a9 m1302 (.i(rx_data[223:216]),.o(syn_5_tmp[223:216]));
  gf_mult_by_84 m1303 (.i(rx_data[231:224]),.o(syn_5_tmp[231:224]));
  gf_mult_by_4d m1304 (.i(rx_data[239:232]),.o(syn_5_tmp[239:232]));
  gf_mult_by_55 m1305 (.i(rx_data[247:240]),.o(syn_5_tmp[247:240]));
  gf_mult_by_72 m1306 (.i(rx_data[255:248]),.o(syn_5_tmp[255:248]));
  gf_mult_by_e6 m1307 (.i(rx_data[263:256]),.o(syn_5_tmp[263:256]));
  gf_mult_by_91 m1308 (.i(rx_data[271:264]),.o(syn_5_tmp[271:264]));
  gf_mult_by_d7 m1309 (.i(rx_data[279:272]),.o(syn_5_tmp[279:272]));
  gf_mult_by_ff m1310 (.i(rx_data[287:280]),.o(syn_5_tmp[287:280]));
  gf_mult_by_96 m1311 (.i(rx_data[295:288]),.o(syn_5_tmp[295:288]));
  gf_mult_by_37 m1312 (.i(rx_data[303:296]),.o(syn_5_tmp[303:296]));
  gf_mult_by_ae m1313 (.i(rx_data[311:304]),.o(syn_5_tmp[311:304]));
  gf_mult_by_64 m1314 (.i(rx_data[319:312]),.o(syn_5_tmp[319:312]));
  gf_mult_by_1c m1315 (.i(rx_data[327:320]),.o(syn_5_tmp[327:320]));
  gf_mult_by_a7 m1316 (.i(rx_data[335:328]),.o(syn_5_tmp[335:328]));
  gf_mult_by_59 m1317 (.i(rx_data[343:336]),.o(syn_5_tmp[343:336]));
  gf_mult_by_ef m1318 (.i(rx_data[351:344]),.o(syn_5_tmp[351:344]));
  gf_mult_by_ac m1319 (.i(rx_data[359:352]),.o(syn_5_tmp[359:352]));
  gf_mult_by_24 m1320 (.i(rx_data[367:360]),.o(syn_5_tmp[367:360]));
  gf_mult_by_f4 m1321 (.i(rx_data[375:368]),.o(syn_5_tmp[375:368]));
  gf_mult_by_eb m1322 (.i(rx_data[383:376]),.o(syn_5_tmp[383:376]));
  gf_mult_by_2c m1323 (.i(rx_data[391:384]),.o(syn_5_tmp[391:384]));
  gf_mult_by_e9 m1324 (.i(rx_data[399:392]),.o(syn_5_tmp[399:392]));
  gf_mult_by_6c m1325 (.i(rx_data[407:400]),.o(syn_5_tmp[407:400]));
  gf_mult_by_01 m1326 (.i(rx_data[415:408]),.o(syn_5_tmp[415:408]));
  gf_mult_by_20 m1327 (.i(rx_data[423:416]),.o(syn_5_tmp[423:416]));
  gf_mult_by_74 m1328 (.i(rx_data[431:424]),.o(syn_5_tmp[431:424]));
  gf_mult_by_26 m1329 (.i(rx_data[439:432]),.o(syn_5_tmp[439:432]));
  gf_mult_by_b4 m1330 (.i(rx_data[447:440]),.o(syn_5_tmp[447:440]));
  gf_mult_by_03 m1331 (.i(rx_data[455:448]),.o(syn_5_tmp[455:448]));
  gf_mult_by_60 m1332 (.i(rx_data[463:456]),.o(syn_5_tmp[463:456]));
  gf_mult_by_9c m1333 (.i(rx_data[471:464]),.o(syn_5_tmp[471:464]));
  gf_mult_by_6a m1334 (.i(rx_data[479:472]),.o(syn_5_tmp[479:472]));
  gf_mult_by_c1 m1335 (.i(rx_data[487:480]),.o(syn_5_tmp[487:480]));
  gf_mult_by_05 m1336 (.i(rx_data[495:488]),.o(syn_5_tmp[495:488]));
  gf_mult_by_a0 m1337 (.i(rx_data[503:496]),.o(syn_5_tmp[503:496]));
  gf_mult_by_b9 m1338 (.i(rx_data[511:504]),.o(syn_5_tmp[511:504]));
  gf_mult_by_be m1339 (.i(rx_data[519:512]),.o(syn_5_tmp[519:512]));
  gf_mult_by_5e m1340 (.i(rx_data[527:520]),.o(syn_5_tmp[527:520]));
  gf_mult_by_0f m1341 (.i(rx_data[535:528]),.o(syn_5_tmp[535:528]));
  gf_mult_by_fd m1342 (.i(rx_data[543:536]),.o(syn_5_tmp[543:536]));
  gf_mult_by_d6 m1343 (.i(rx_data[551:544]),.o(syn_5_tmp[551:544]));
  gf_mult_by_df m1344 (.i(rx_data[559:552]),.o(syn_5_tmp[559:552]));
  gf_mult_by_e2 m1345 (.i(rx_data[567:560]),.o(syn_5_tmp[567:560]));
  gf_mult_by_11 m1346 (.i(rx_data[575:568]),.o(syn_5_tmp[575:568]));
  gf_mult_by_1a m1347 (.i(rx_data[583:576]),.o(syn_5_tmp[583:576]));
  gf_mult_by_67 m1348 (.i(rx_data[591:584]),.o(syn_5_tmp[591:584]));
  gf_mult_by_7c m1349 (.i(rx_data[599:592]),.o(syn_5_tmp[599:592]));
  gf_mult_by_3b m1350 (.i(rx_data[607:600]),.o(syn_5_tmp[607:600]));
  gf_mult_by_33 m1351 (.i(rx_data[615:608]),.o(syn_5_tmp[615:608]));
  gf_mult_by_2e m1352 (.i(rx_data[623:616]),.o(syn_5_tmp[623:616]));
  gf_mult_by_a9 m1353 (.i(rx_data[631:624]),.o(syn_5_tmp[631:624]));
  gf_mult_by_84 m1354 (.i(rx_data[639:632]),.o(syn_5_tmp[639:632]));
  gf_mult_by_4d m1355 (.i(rx_data[647:640]),.o(syn_5_tmp[647:640]));
  gf_mult_by_55 m1356 (.i(rx_data[655:648]),.o(syn_5_tmp[655:648]));
  gf_mult_by_72 m1357 (.i(rx_data[663:656]),.o(syn_5_tmp[663:656]));
  gf_mult_by_e6 m1358 (.i(rx_data[671:664]),.o(syn_5_tmp[671:664]));
  gf_mult_by_91 m1359 (.i(rx_data[679:672]),.o(syn_5_tmp[679:672]));
  gf_mult_by_d7 m1360 (.i(rx_data[687:680]),.o(syn_5_tmp[687:680]));
  gf_mult_by_ff m1361 (.i(rx_data[695:688]),.o(syn_5_tmp[695:688]));
  gf_mult_by_96 m1362 (.i(rx_data[703:696]),.o(syn_5_tmp[703:696]));
  gf_mult_by_37 m1363 (.i(rx_data[711:704]),.o(syn_5_tmp[711:704]));
  gf_mult_by_ae m1364 (.i(rx_data[719:712]),.o(syn_5_tmp[719:712]));
  gf_mult_by_64 m1365 (.i(rx_data[727:720]),.o(syn_5_tmp[727:720]));
  gf_mult_by_1c m1366 (.i(rx_data[735:728]),.o(syn_5_tmp[735:728]));
  gf_mult_by_a7 m1367 (.i(rx_data[743:736]),.o(syn_5_tmp[743:736]));
  gf_mult_by_59 m1368 (.i(rx_data[751:744]),.o(syn_5_tmp[751:744]));
  gf_mult_by_ef m1369 (.i(rx_data[759:752]),.o(syn_5_tmp[759:752]));
  gf_mult_by_ac m1370 (.i(rx_data[767:760]),.o(syn_5_tmp[767:760]));
  gf_mult_by_24 m1371 (.i(rx_data[775:768]),.o(syn_5_tmp[775:768]));
  gf_mult_by_f4 m1372 (.i(rx_data[783:776]),.o(syn_5_tmp[783:776]));
  gf_mult_by_eb m1373 (.i(rx_data[791:784]),.o(syn_5_tmp[791:784]));
  gf_mult_by_2c m1374 (.i(rx_data[799:792]),.o(syn_5_tmp[799:792]));
  gf_mult_by_e9 m1375 (.i(rx_data[807:800]),.o(syn_5_tmp[807:800]));
  gf_mult_by_6c m1376 (.i(rx_data[815:808]),.o(syn_5_tmp[815:808]));
  gf_mult_by_01 m1377 (.i(rx_data[823:816]),.o(syn_5_tmp[823:816]));
  gf_mult_by_20 m1378 (.i(rx_data[831:824]),.o(syn_5_tmp[831:824]));
  gf_mult_by_74 m1379 (.i(rx_data[839:832]),.o(syn_5_tmp[839:832]));
  gf_mult_by_26 m1380 (.i(rx_data[847:840]),.o(syn_5_tmp[847:840]));
  gf_mult_by_b4 m1381 (.i(rx_data[855:848]),.o(syn_5_tmp[855:848]));
  gf_mult_by_03 m1382 (.i(rx_data[863:856]),.o(syn_5_tmp[863:856]));
  gf_mult_by_60 m1383 (.i(rx_data[871:864]),.o(syn_5_tmp[871:864]));
  gf_mult_by_9c m1384 (.i(rx_data[879:872]),.o(syn_5_tmp[879:872]));
  gf_mult_by_6a m1385 (.i(rx_data[887:880]),.o(syn_5_tmp[887:880]));
  gf_mult_by_c1 m1386 (.i(rx_data[895:888]),.o(syn_5_tmp[895:888]));
  gf_mult_by_05 m1387 (.i(rx_data[903:896]),.o(syn_5_tmp[903:896]));
  gf_mult_by_a0 m1388 (.i(rx_data[911:904]),.o(syn_5_tmp[911:904]));
  gf_mult_by_b9 m1389 (.i(rx_data[919:912]),.o(syn_5_tmp[919:912]));
  gf_mult_by_be m1390 (.i(rx_data[927:920]),.o(syn_5_tmp[927:920]));
  gf_mult_by_5e m1391 (.i(rx_data[935:928]),.o(syn_5_tmp[935:928]));
  gf_mult_by_0f m1392 (.i(rx_data[943:936]),.o(syn_5_tmp[943:936]));
  gf_mult_by_fd m1393 (.i(rx_data[951:944]),.o(syn_5_tmp[951:944]));
  gf_mult_by_d6 m1394 (.i(rx_data[959:952]),.o(syn_5_tmp[959:952]));
  gf_mult_by_df m1395 (.i(rx_data[967:960]),.o(syn_5_tmp[967:960]));
  gf_mult_by_e2 m1396 (.i(rx_data[975:968]),.o(syn_5_tmp[975:968]));
  gf_mult_by_11 m1397 (.i(rx_data[983:976]),.o(syn_5_tmp[983:976]));
  gf_mult_by_1a m1398 (.i(rx_data[991:984]),.o(syn_5_tmp[991:984]));
  gf_mult_by_67 m1399 (.i(rx_data[999:992]),.o(syn_5_tmp[999:992]));
  gf_mult_by_7c m1400 (.i(rx_data[1007:1000]),.o(syn_5_tmp[1007:1000]));
  gf_mult_by_3b m1401 (.i(rx_data[1015:1008]),.o(syn_5_tmp[1015:1008]));
  gf_mult_by_33 m1402 (.i(rx_data[1023:1016]),.o(syn_5_tmp[1023:1016]));
  gf_mult_by_2e m1403 (.i(rx_data[1031:1024]),.o(syn_5_tmp[1031:1024]));
  gf_mult_by_a9 m1404 (.i(rx_data[1039:1032]),.o(syn_5_tmp[1039:1032]));
  gf_mult_by_84 m1405 (.i(rx_data[1047:1040]),.o(syn_5_tmp[1047:1040]));
  gf_mult_by_4d m1406 (.i(rx_data[1055:1048]),.o(syn_5_tmp[1055:1048]));
  gf_mult_by_55 m1407 (.i(rx_data[1063:1056]),.o(syn_5_tmp[1063:1056]));
  gf_mult_by_72 m1408 (.i(rx_data[1071:1064]),.o(syn_5_tmp[1071:1064]));
  gf_mult_by_e6 m1409 (.i(rx_data[1079:1072]),.o(syn_5_tmp[1079:1072]));
  gf_mult_by_91 m1410 (.i(rx_data[1087:1080]),.o(syn_5_tmp[1087:1080]));
  gf_mult_by_d7 m1411 (.i(rx_data[1095:1088]),.o(syn_5_tmp[1095:1088]));
  gf_mult_by_ff m1412 (.i(rx_data[1103:1096]),.o(syn_5_tmp[1103:1096]));
  gf_mult_by_96 m1413 (.i(rx_data[1111:1104]),.o(syn_5_tmp[1111:1104]));
  gf_mult_by_37 m1414 (.i(rx_data[1119:1112]),.o(syn_5_tmp[1119:1112]));
  gf_mult_by_ae m1415 (.i(rx_data[1127:1120]),.o(syn_5_tmp[1127:1120]));
  gf_mult_by_64 m1416 (.i(rx_data[1135:1128]),.o(syn_5_tmp[1135:1128]));
  gf_mult_by_1c m1417 (.i(rx_data[1143:1136]),.o(syn_5_tmp[1143:1136]));
  gf_mult_by_a7 m1418 (.i(rx_data[1151:1144]),.o(syn_5_tmp[1151:1144]));
  gf_mult_by_59 m1419 (.i(rx_data[1159:1152]),.o(syn_5_tmp[1159:1152]));
  gf_mult_by_ef m1420 (.i(rx_data[1167:1160]),.o(syn_5_tmp[1167:1160]));
  gf_mult_by_ac m1421 (.i(rx_data[1175:1168]),.o(syn_5_tmp[1175:1168]));
  gf_mult_by_24 m1422 (.i(rx_data[1183:1176]),.o(syn_5_tmp[1183:1176]));
  gf_mult_by_f4 m1423 (.i(rx_data[1191:1184]),.o(syn_5_tmp[1191:1184]));
  gf_mult_by_eb m1424 (.i(rx_data[1199:1192]),.o(syn_5_tmp[1199:1192]));
  gf_mult_by_2c m1425 (.i(rx_data[1207:1200]),.o(syn_5_tmp[1207:1200]));
  gf_mult_by_e9 m1426 (.i(rx_data[1215:1208]),.o(syn_5_tmp[1215:1208]));
  gf_mult_by_6c m1427 (.i(rx_data[1223:1216]),.o(syn_5_tmp[1223:1216]));
  gf_mult_by_01 m1428 (.i(rx_data[1231:1224]),.o(syn_5_tmp[1231:1224]));
  gf_mult_by_20 m1429 (.i(rx_data[1239:1232]),.o(syn_5_tmp[1239:1232]));
  gf_mult_by_74 m1430 (.i(rx_data[1247:1240]),.o(syn_5_tmp[1247:1240]));
  gf_mult_by_26 m1431 (.i(rx_data[1255:1248]),.o(syn_5_tmp[1255:1248]));
  gf_mult_by_b4 m1432 (.i(rx_data[1263:1256]),.o(syn_5_tmp[1263:1256]));
  gf_mult_by_03 m1433 (.i(rx_data[1271:1264]),.o(syn_5_tmp[1271:1264]));
  gf_mult_by_60 m1434 (.i(rx_data[1279:1272]),.o(syn_5_tmp[1279:1272]));
  gf_mult_by_9c m1435 (.i(rx_data[1287:1280]),.o(syn_5_tmp[1287:1280]));
  gf_mult_by_6a m1436 (.i(rx_data[1295:1288]),.o(syn_5_tmp[1295:1288]));
  gf_mult_by_c1 m1437 (.i(rx_data[1303:1296]),.o(syn_5_tmp[1303:1296]));
  gf_mult_by_05 m1438 (.i(rx_data[1311:1304]),.o(syn_5_tmp[1311:1304]));
  gf_mult_by_a0 m1439 (.i(rx_data[1319:1312]),.o(syn_5_tmp[1319:1312]));
  gf_mult_by_b9 m1440 (.i(rx_data[1327:1320]),.o(syn_5_tmp[1327:1320]));
  gf_mult_by_be m1441 (.i(rx_data[1335:1328]),.o(syn_5_tmp[1335:1328]));
  gf_mult_by_5e m1442 (.i(rx_data[1343:1336]),.o(syn_5_tmp[1343:1336]));
  gf_mult_by_0f m1443 (.i(rx_data[1351:1344]),.o(syn_5_tmp[1351:1344]));
  gf_mult_by_fd m1444 (.i(rx_data[1359:1352]),.o(syn_5_tmp[1359:1352]));
  gf_mult_by_d6 m1445 (.i(rx_data[1367:1360]),.o(syn_5_tmp[1367:1360]));
  gf_mult_by_df m1446 (.i(rx_data[1375:1368]),.o(syn_5_tmp[1375:1368]));
  gf_mult_by_e2 m1447 (.i(rx_data[1383:1376]),.o(syn_5_tmp[1383:1376]));
  gf_mult_by_11 m1448 (.i(rx_data[1391:1384]),.o(syn_5_tmp[1391:1384]));
  gf_mult_by_1a m1449 (.i(rx_data[1399:1392]),.o(syn_5_tmp[1399:1392]));
  gf_mult_by_67 m1450 (.i(rx_data[1407:1400]),.o(syn_5_tmp[1407:1400]));
  gf_mult_by_7c m1451 (.i(rx_data[1415:1408]),.o(syn_5_tmp[1415:1408]));
  gf_mult_by_3b m1452 (.i(rx_data[1423:1416]),.o(syn_5_tmp[1423:1416]));
  gf_mult_by_33 m1453 (.i(rx_data[1431:1424]),.o(syn_5_tmp[1431:1424]));
  gf_mult_by_2e m1454 (.i(rx_data[1439:1432]),.o(syn_5_tmp[1439:1432]));
  gf_mult_by_a9 m1455 (.i(rx_data[1447:1440]),.o(syn_5_tmp[1447:1440]));
  gf_mult_by_84 m1456 (.i(rx_data[1455:1448]),.o(syn_5_tmp[1455:1448]));
  gf_mult_by_4d m1457 (.i(rx_data[1463:1456]),.o(syn_5_tmp[1463:1456]));
  gf_mult_by_55 m1458 (.i(rx_data[1471:1464]),.o(syn_5_tmp[1471:1464]));
  gf_mult_by_72 m1459 (.i(rx_data[1479:1472]),.o(syn_5_tmp[1479:1472]));
  gf_mult_by_e6 m1460 (.i(rx_data[1487:1480]),.o(syn_5_tmp[1487:1480]));
  gf_mult_by_91 m1461 (.i(rx_data[1495:1488]),.o(syn_5_tmp[1495:1488]));
  gf_mult_by_d7 m1462 (.i(rx_data[1503:1496]),.o(syn_5_tmp[1503:1496]));
  gf_mult_by_ff m1463 (.i(rx_data[1511:1504]),.o(syn_5_tmp[1511:1504]));
  gf_mult_by_96 m1464 (.i(rx_data[1519:1512]),.o(syn_5_tmp[1519:1512]));
  gf_mult_by_37 m1465 (.i(rx_data[1527:1520]),.o(syn_5_tmp[1527:1520]));
  gf_mult_by_ae m1466 (.i(rx_data[1535:1528]),.o(syn_5_tmp[1535:1528]));
  gf_mult_by_64 m1467 (.i(rx_data[1543:1536]),.o(syn_5_tmp[1543:1536]));
  gf_mult_by_1c m1468 (.i(rx_data[1551:1544]),.o(syn_5_tmp[1551:1544]));
  gf_mult_by_a7 m1469 (.i(rx_data[1559:1552]),.o(syn_5_tmp[1559:1552]));
  gf_mult_by_59 m1470 (.i(rx_data[1567:1560]),.o(syn_5_tmp[1567:1560]));
  gf_mult_by_ef m1471 (.i(rx_data[1575:1568]),.o(syn_5_tmp[1575:1568]));
  gf_mult_by_ac m1472 (.i(rx_data[1583:1576]),.o(syn_5_tmp[1583:1576]));
  gf_mult_by_24 m1473 (.i(rx_data[1591:1584]),.o(syn_5_tmp[1591:1584]));
  gf_mult_by_f4 m1474 (.i(rx_data[1599:1592]),.o(syn_5_tmp[1599:1592]));
  gf_mult_by_eb m1475 (.i(rx_data[1607:1600]),.o(syn_5_tmp[1607:1600]));
  gf_mult_by_2c m1476 (.i(rx_data[1615:1608]),.o(syn_5_tmp[1615:1608]));
  gf_mult_by_e9 m1477 (.i(rx_data[1623:1616]),.o(syn_5_tmp[1623:1616]));
  gf_mult_by_6c m1478 (.i(rx_data[1631:1624]),.o(syn_5_tmp[1631:1624]));
  gf_mult_by_01 m1479 (.i(rx_data[1639:1632]),.o(syn_5_tmp[1639:1632]));
  gf_mult_by_20 m1480 (.i(rx_data[1647:1640]),.o(syn_5_tmp[1647:1640]));
  gf_mult_by_74 m1481 (.i(rx_data[1655:1648]),.o(syn_5_tmp[1655:1648]));
  gf_mult_by_26 m1482 (.i(rx_data[1663:1656]),.o(syn_5_tmp[1663:1656]));
  gf_mult_by_b4 m1483 (.i(rx_data[1671:1664]),.o(syn_5_tmp[1671:1664]));
  gf_mult_by_03 m1484 (.i(rx_data[1679:1672]),.o(syn_5_tmp[1679:1672]));
  gf_mult_by_60 m1485 (.i(rx_data[1687:1680]),.o(syn_5_tmp[1687:1680]));
  gf_mult_by_9c m1486 (.i(rx_data[1695:1688]),.o(syn_5_tmp[1695:1688]));
  gf_mult_by_6a m1487 (.i(rx_data[1703:1696]),.o(syn_5_tmp[1703:1696]));
  gf_mult_by_c1 m1488 (.i(rx_data[1711:1704]),.o(syn_5_tmp[1711:1704]));
  gf_mult_by_05 m1489 (.i(rx_data[1719:1712]),.o(syn_5_tmp[1719:1712]));
  gf_mult_by_a0 m1490 (.i(rx_data[1727:1720]),.o(syn_5_tmp[1727:1720]));
  gf_mult_by_b9 m1491 (.i(rx_data[1735:1728]),.o(syn_5_tmp[1735:1728]));
  gf_mult_by_be m1492 (.i(rx_data[1743:1736]),.o(syn_5_tmp[1743:1736]));
  gf_mult_by_5e m1493 (.i(rx_data[1751:1744]),.o(syn_5_tmp[1751:1744]));
  gf_mult_by_0f m1494 (.i(rx_data[1759:1752]),.o(syn_5_tmp[1759:1752]));
  gf_mult_by_fd m1495 (.i(rx_data[1767:1760]),.o(syn_5_tmp[1767:1760]));
  gf_mult_by_d6 m1496 (.i(rx_data[1775:1768]),.o(syn_5_tmp[1775:1768]));
  gf_mult_by_df m1497 (.i(rx_data[1783:1776]),.o(syn_5_tmp[1783:1776]));
  gf_mult_by_e2 m1498 (.i(rx_data[1791:1784]),.o(syn_5_tmp[1791:1784]));
  gf_mult_by_11 m1499 (.i(rx_data[1799:1792]),.o(syn_5_tmp[1799:1792]));
  gf_mult_by_1a m1500 (.i(rx_data[1807:1800]),.o(syn_5_tmp[1807:1800]));
  gf_mult_by_67 m1501 (.i(rx_data[1815:1808]),.o(syn_5_tmp[1815:1808]));
  gf_mult_by_7c m1502 (.i(rx_data[1823:1816]),.o(syn_5_tmp[1823:1816]));
  gf_mult_by_3b m1503 (.i(rx_data[1831:1824]),.o(syn_5_tmp[1831:1824]));
  gf_mult_by_33 m1504 (.i(rx_data[1839:1832]),.o(syn_5_tmp[1839:1832]));
  gf_mult_by_2e m1505 (.i(rx_data[1847:1840]),.o(syn_5_tmp[1847:1840]));
  gf_mult_by_a9 m1506 (.i(rx_data[1855:1848]),.o(syn_5_tmp[1855:1848]));
  gf_mult_by_84 m1507 (.i(rx_data[1863:1856]),.o(syn_5_tmp[1863:1856]));
  gf_mult_by_4d m1508 (.i(rx_data[1871:1864]),.o(syn_5_tmp[1871:1864]));
  gf_mult_by_55 m1509 (.i(rx_data[1879:1872]),.o(syn_5_tmp[1879:1872]));
  gf_mult_by_72 m1510 (.i(rx_data[1887:1880]),.o(syn_5_tmp[1887:1880]));
  gf_mult_by_e6 m1511 (.i(rx_data[1895:1888]),.o(syn_5_tmp[1895:1888]));
  gf_mult_by_91 m1512 (.i(rx_data[1903:1896]),.o(syn_5_tmp[1903:1896]));
  gf_mult_by_d7 m1513 (.i(rx_data[1911:1904]),.o(syn_5_tmp[1911:1904]));
  gf_mult_by_ff m1514 (.i(rx_data[1919:1912]),.o(syn_5_tmp[1919:1912]));
  gf_mult_by_96 m1515 (.i(rx_data[1927:1920]),.o(syn_5_tmp[1927:1920]));
  gf_mult_by_37 m1516 (.i(rx_data[1935:1928]),.o(syn_5_tmp[1935:1928]));
  gf_mult_by_ae m1517 (.i(rx_data[1943:1936]),.o(syn_5_tmp[1943:1936]));
  gf_mult_by_64 m1518 (.i(rx_data[1951:1944]),.o(syn_5_tmp[1951:1944]));
  gf_mult_by_1c m1519 (.i(rx_data[1959:1952]),.o(syn_5_tmp[1959:1952]));
  gf_mult_by_a7 m1520 (.i(rx_data[1967:1960]),.o(syn_5_tmp[1967:1960]));
  gf_mult_by_59 m1521 (.i(rx_data[1975:1968]),.o(syn_5_tmp[1975:1968]));
  gf_mult_by_ef m1522 (.i(rx_data[1983:1976]),.o(syn_5_tmp[1983:1976]));
  gf_mult_by_ac m1523 (.i(rx_data[1991:1984]),.o(syn_5_tmp[1991:1984]));
  gf_mult_by_24 m1524 (.i(rx_data[1999:1992]),.o(syn_5_tmp[1999:1992]));
  gf_mult_by_f4 m1525 (.i(rx_data[2007:2000]),.o(syn_5_tmp[2007:2000]));
  gf_mult_by_eb m1526 (.i(rx_data[2015:2008]),.o(syn_5_tmp[2015:2008]));
  gf_mult_by_2c m1527 (.i(rx_data[2023:2016]),.o(syn_5_tmp[2023:2016]));
  gf_mult_by_e9 m1528 (.i(rx_data[2031:2024]),.o(syn_5_tmp[2031:2024]));
  gf_mult_by_6c m1529 (.i(rx_data[2039:2032]),.o(syn_5_tmp[2039:2032]));
  assign syndrome[47:40] =
      syn_5_tmp[7:0] ^ syn_5_tmp[15:8] ^ syn_5_tmp[23:16] ^ 
      syn_5_tmp[31:24] ^ syn_5_tmp[39:32] ^ syn_5_tmp[47:40] ^ 
      syn_5_tmp[55:48] ^ syn_5_tmp[63:56] ^ syn_5_tmp[71:64] ^ 
      syn_5_tmp[79:72] ^ syn_5_tmp[87:80] ^ syn_5_tmp[95:88] ^ 
      syn_5_tmp[103:96] ^ syn_5_tmp[111:104] ^ syn_5_tmp[119:112] ^ 
      syn_5_tmp[127:120] ^ syn_5_tmp[135:128] ^ syn_5_tmp[143:136] ^ 
      syn_5_tmp[151:144] ^ syn_5_tmp[159:152] ^ syn_5_tmp[167:160] ^ 
      syn_5_tmp[175:168] ^ syn_5_tmp[183:176] ^ syn_5_tmp[191:184] ^ 
      syn_5_tmp[199:192] ^ syn_5_tmp[207:200] ^ syn_5_tmp[215:208] ^ 
      syn_5_tmp[223:216] ^ syn_5_tmp[231:224] ^ syn_5_tmp[239:232] ^ 
      syn_5_tmp[247:240] ^ syn_5_tmp[255:248] ^ syn_5_tmp[263:256] ^ 
      syn_5_tmp[271:264] ^ syn_5_tmp[279:272] ^ syn_5_tmp[287:280] ^ 
      syn_5_tmp[295:288] ^ syn_5_tmp[303:296] ^ syn_5_tmp[311:304] ^ 
      syn_5_tmp[319:312] ^ syn_5_tmp[327:320] ^ syn_5_tmp[335:328] ^ 
      syn_5_tmp[343:336] ^ syn_5_tmp[351:344] ^ syn_5_tmp[359:352] ^ 
      syn_5_tmp[367:360] ^ syn_5_tmp[375:368] ^ syn_5_tmp[383:376] ^ 
      syn_5_tmp[391:384] ^ syn_5_tmp[399:392] ^ syn_5_tmp[407:400] ^ 
      syn_5_tmp[415:408] ^ syn_5_tmp[423:416] ^ syn_5_tmp[431:424] ^ 
      syn_5_tmp[439:432] ^ syn_5_tmp[447:440] ^ syn_5_tmp[455:448] ^ 
      syn_5_tmp[463:456] ^ syn_5_tmp[471:464] ^ syn_5_tmp[479:472] ^ 
      syn_5_tmp[487:480] ^ syn_5_tmp[495:488] ^ syn_5_tmp[503:496] ^ 
      syn_5_tmp[511:504] ^ syn_5_tmp[519:512] ^ syn_5_tmp[527:520] ^ 
      syn_5_tmp[535:528] ^ syn_5_tmp[543:536] ^ syn_5_tmp[551:544] ^ 
      syn_5_tmp[559:552] ^ syn_5_tmp[567:560] ^ syn_5_tmp[575:568] ^ 
      syn_5_tmp[583:576] ^ syn_5_tmp[591:584] ^ syn_5_tmp[599:592] ^ 
      syn_5_tmp[607:600] ^ syn_5_tmp[615:608] ^ syn_5_tmp[623:616] ^ 
      syn_5_tmp[631:624] ^ syn_5_tmp[639:632] ^ syn_5_tmp[647:640] ^ 
      syn_5_tmp[655:648] ^ syn_5_tmp[663:656] ^ syn_5_tmp[671:664] ^ 
      syn_5_tmp[679:672] ^ syn_5_tmp[687:680] ^ syn_5_tmp[695:688] ^ 
      syn_5_tmp[703:696] ^ syn_5_tmp[711:704] ^ syn_5_tmp[719:712] ^ 
      syn_5_tmp[727:720] ^ syn_5_tmp[735:728] ^ syn_5_tmp[743:736] ^ 
      syn_5_tmp[751:744] ^ syn_5_tmp[759:752] ^ syn_5_tmp[767:760] ^ 
      syn_5_tmp[775:768] ^ syn_5_tmp[783:776] ^ syn_5_tmp[791:784] ^ 
      syn_5_tmp[799:792] ^ syn_5_tmp[807:800] ^ syn_5_tmp[815:808] ^ 
      syn_5_tmp[823:816] ^ syn_5_tmp[831:824] ^ syn_5_tmp[839:832] ^ 
      syn_5_tmp[847:840] ^ syn_5_tmp[855:848] ^ syn_5_tmp[863:856] ^ 
      syn_5_tmp[871:864] ^ syn_5_tmp[879:872] ^ syn_5_tmp[887:880] ^ 
      syn_5_tmp[895:888] ^ syn_5_tmp[903:896] ^ syn_5_tmp[911:904] ^ 
      syn_5_tmp[919:912] ^ syn_5_tmp[927:920] ^ syn_5_tmp[935:928] ^ 
      syn_5_tmp[943:936] ^ syn_5_tmp[951:944] ^ syn_5_tmp[959:952] ^ 
      syn_5_tmp[967:960] ^ syn_5_tmp[975:968] ^ syn_5_tmp[983:976] ^ 
      syn_5_tmp[991:984] ^ syn_5_tmp[999:992] ^ syn_5_tmp[1007:1000] ^ 
      syn_5_tmp[1015:1008] ^ syn_5_tmp[1023:1016] ^ syn_5_tmp[1031:1024] ^ 
      syn_5_tmp[1039:1032] ^ syn_5_tmp[1047:1040] ^ syn_5_tmp[1055:1048] ^ 
      syn_5_tmp[1063:1056] ^ syn_5_tmp[1071:1064] ^ syn_5_tmp[1079:1072] ^ 
      syn_5_tmp[1087:1080] ^ syn_5_tmp[1095:1088] ^ syn_5_tmp[1103:1096] ^ 
      syn_5_tmp[1111:1104] ^ syn_5_tmp[1119:1112] ^ syn_5_tmp[1127:1120] ^ 
      syn_5_tmp[1135:1128] ^ syn_5_tmp[1143:1136] ^ syn_5_tmp[1151:1144] ^ 
      syn_5_tmp[1159:1152] ^ syn_5_tmp[1167:1160] ^ syn_5_tmp[1175:1168] ^ 
      syn_5_tmp[1183:1176] ^ syn_5_tmp[1191:1184] ^ syn_5_tmp[1199:1192] ^ 
      syn_5_tmp[1207:1200] ^ syn_5_tmp[1215:1208] ^ syn_5_tmp[1223:1216] ^ 
      syn_5_tmp[1231:1224] ^ syn_5_tmp[1239:1232] ^ syn_5_tmp[1247:1240] ^ 
      syn_5_tmp[1255:1248] ^ syn_5_tmp[1263:1256] ^ syn_5_tmp[1271:1264] ^ 
      syn_5_tmp[1279:1272] ^ syn_5_tmp[1287:1280] ^ syn_5_tmp[1295:1288] ^ 
      syn_5_tmp[1303:1296] ^ syn_5_tmp[1311:1304] ^ syn_5_tmp[1319:1312] ^ 
      syn_5_tmp[1327:1320] ^ syn_5_tmp[1335:1328] ^ syn_5_tmp[1343:1336] ^ 
      syn_5_tmp[1351:1344] ^ syn_5_tmp[1359:1352] ^ syn_5_tmp[1367:1360] ^ 
      syn_5_tmp[1375:1368] ^ syn_5_tmp[1383:1376] ^ syn_5_tmp[1391:1384] ^ 
      syn_5_tmp[1399:1392] ^ syn_5_tmp[1407:1400] ^ syn_5_tmp[1415:1408] ^ 
      syn_5_tmp[1423:1416] ^ syn_5_tmp[1431:1424] ^ syn_5_tmp[1439:1432] ^ 
      syn_5_tmp[1447:1440] ^ syn_5_tmp[1455:1448] ^ syn_5_tmp[1463:1456] ^ 
      syn_5_tmp[1471:1464] ^ syn_5_tmp[1479:1472] ^ syn_5_tmp[1487:1480] ^ 
      syn_5_tmp[1495:1488] ^ syn_5_tmp[1503:1496] ^ syn_5_tmp[1511:1504] ^ 
      syn_5_tmp[1519:1512] ^ syn_5_tmp[1527:1520] ^ syn_5_tmp[1535:1528] ^ 
      syn_5_tmp[1543:1536] ^ syn_5_tmp[1551:1544] ^ syn_5_tmp[1559:1552] ^ 
      syn_5_tmp[1567:1560] ^ syn_5_tmp[1575:1568] ^ syn_5_tmp[1583:1576] ^ 
      syn_5_tmp[1591:1584] ^ syn_5_tmp[1599:1592] ^ syn_5_tmp[1607:1600] ^ 
      syn_5_tmp[1615:1608] ^ syn_5_tmp[1623:1616] ^ syn_5_tmp[1631:1624] ^ 
      syn_5_tmp[1639:1632] ^ syn_5_tmp[1647:1640] ^ syn_5_tmp[1655:1648] ^ 
      syn_5_tmp[1663:1656] ^ syn_5_tmp[1671:1664] ^ syn_5_tmp[1679:1672] ^ 
      syn_5_tmp[1687:1680] ^ syn_5_tmp[1695:1688] ^ syn_5_tmp[1703:1696] ^ 
      syn_5_tmp[1711:1704] ^ syn_5_tmp[1719:1712] ^ syn_5_tmp[1727:1720] ^ 
      syn_5_tmp[1735:1728] ^ syn_5_tmp[1743:1736] ^ syn_5_tmp[1751:1744] ^ 
      syn_5_tmp[1759:1752] ^ syn_5_tmp[1767:1760] ^ syn_5_tmp[1775:1768] ^ 
      syn_5_tmp[1783:1776] ^ syn_5_tmp[1791:1784] ^ syn_5_tmp[1799:1792] ^ 
      syn_5_tmp[1807:1800] ^ syn_5_tmp[1815:1808] ^ syn_5_tmp[1823:1816] ^ 
      syn_5_tmp[1831:1824] ^ syn_5_tmp[1839:1832] ^ syn_5_tmp[1847:1840] ^ 
      syn_5_tmp[1855:1848] ^ syn_5_tmp[1863:1856] ^ syn_5_tmp[1871:1864] ^ 
      syn_5_tmp[1879:1872] ^ syn_5_tmp[1887:1880] ^ syn_5_tmp[1895:1888] ^ 
      syn_5_tmp[1903:1896] ^ syn_5_tmp[1911:1904] ^ syn_5_tmp[1919:1912] ^ 
      syn_5_tmp[1927:1920] ^ syn_5_tmp[1935:1928] ^ syn_5_tmp[1943:1936] ^ 
      syn_5_tmp[1951:1944] ^ syn_5_tmp[1959:1952] ^ syn_5_tmp[1967:1960] ^ 
      syn_5_tmp[1975:1968] ^ syn_5_tmp[1983:1976] ^ syn_5_tmp[1991:1984] ^ 
      syn_5_tmp[1999:1992] ^ syn_5_tmp[2007:2000] ^ syn_5_tmp[2015:2008] ^ 
      syn_5_tmp[2023:2016] ^ syn_5_tmp[2031:2024] ^ syn_5_tmp[2039:2032];

// syndrome 6
  wire [2039:0] syn_6_tmp;
  gf_mult_by_01 m1530 (.i(rx_data[7:0]),.o(syn_6_tmp[7:0]));
  gf_mult_by_40 m1531 (.i(rx_data[15:8]),.o(syn_6_tmp[15:8]));
  gf_mult_by_cd m1532 (.i(rx_data[23:16]),.o(syn_6_tmp[23:16]));
  gf_mult_by_2d m1533 (.i(rx_data[31:24]),.o(syn_6_tmp[31:24]));
  gf_mult_by_8f m1534 (.i(rx_data[39:32]),.o(syn_6_tmp[39:32]));
  gf_mult_by_60 m1535 (.i(rx_data[47:40]),.o(syn_6_tmp[47:40]));
  gf_mult_by_25 m1536 (.i(rx_data[55:48]),.o(syn_6_tmp[55:48]));
  gf_mult_by_b5 m1537 (.i(rx_data[63:56]),.o(syn_6_tmp[63:56]));
  gf_mult_by_46 m1538 (.i(rx_data[71:64]),.o(syn_6_tmp[71:64]));
  gf_mult_by_50 m1539 (.i(rx_data[79:72]),.o(syn_6_tmp[79:72]));
  gf_mult_by_b9 m1540 (.i(rx_data[87:80]),.o(syn_6_tmp[87:80]));
  gf_mult_by_61 m1541 (.i(rx_data[95:88]),.o(syn_6_tmp[95:88]));
  gf_mult_by_65 m1542 (.i(rx_data[103:96]),.o(syn_6_tmp[103:96]));
  gf_mult_by_78 m1543 (.i(rx_data[111:104]),.o(syn_6_tmp[111:104]));
  gf_mult_by_6b m1544 (.i(rx_data[119:112]),.o(syn_6_tmp[119:112]));
  gf_mult_by_df m1545 (.i(rx_data[127:120]),.o(syn_6_tmp[127:120]));
  gf_mult_by_d9 m1546 (.i(rx_data[135:128]),.o(syn_6_tmp[135:128]));
  gf_mult_by_44 m1547 (.i(rx_data[143:136]),.o(syn_6_tmp[143:136]));
  gf_mult_by_d0 m1548 (.i(rx_data[151:144]),.o(syn_6_tmp[151:144]));
  gf_mult_by_3e m1549 (.i(rx_data[159:152]),.o(syn_6_tmp[159:152]));
  gf_mult_by_3b m1550 (.i(rx_data[167:160]),.o(syn_6_tmp[167:160]));
  gf_mult_by_66 m1551 (.i(rx_data[175:168]),.o(syn_6_tmp[175:168]));
  gf_mult_by_b8 m1552 (.i(rx_data[183:176]),.o(syn_6_tmp[183:176]));
  gf_mult_by_21 m1553 (.i(rx_data[191:184]),.o(syn_6_tmp[191:184]));
  gf_mult_by_a8 m1554 (.i(rx_data[199:192]),.o(syn_6_tmp[199:192]));
  gf_mult_by_55 m1555 (.i(rx_data[207:200]),.o(syn_6_tmp[207:200]));
  gf_mult_by_e4 m1556 (.i(rx_data[215:208]),.o(syn_6_tmp[215:208]));
  gf_mult_by_bf m1557 (.i(rx_data[223:216]),.o(syn_6_tmp[223:216]));
  gf_mult_by_fc m1558 (.i(rx_data[231:224]),.o(syn_6_tmp[231:224]));
  gf_mult_by_f1 m1559 (.i(rx_data[239:232]),.o(syn_6_tmp[239:232]));
  gf_mult_by_96 m1560 (.i(rx_data[247:240]),.o(syn_6_tmp[247:240]));
  gf_mult_by_6e m1561 (.i(rx_data[255:248]),.o(syn_6_tmp[255:248]));
  gf_mult_by_82 m1562 (.i(rx_data[263:256]),.o(syn_6_tmp[263:256]));
  gf_mult_by_07 m1563 (.i(rx_data[271:264]),.o(syn_6_tmp[271:264]));
  gf_mult_by_dd m1564 (.i(rx_data[279:272]),.o(syn_6_tmp[279:272]));
  gf_mult_by_59 m1565 (.i(rx_data[287:280]),.o(syn_6_tmp[287:280]));
  gf_mult_by_c3 m1566 (.i(rx_data[295:288]),.o(syn_6_tmp[295:288]));
  gf_mult_by_8a m1567 (.i(rx_data[303:296]),.o(syn_6_tmp[303:296]));
  gf_mult_by_3d m1568 (.i(rx_data[311:304]),.o(syn_6_tmp[311:304]));
  gf_mult_by_fb m1569 (.i(rx_data[319:312]),.o(syn_6_tmp[319:312]));
  gf_mult_by_2c m1570 (.i(rx_data[327:320]),.o(syn_6_tmp[327:320]));
  gf_mult_by_cf m1571 (.i(rx_data[335:328]),.o(syn_6_tmp[335:328]));
  gf_mult_by_ad m1572 (.i(rx_data[343:336]),.o(syn_6_tmp[343:336]));
  gf_mult_by_08 m1573 (.i(rx_data[351:344]),.o(syn_6_tmp[351:344]));
  gf_mult_by_3a m1574 (.i(rx_data[359:352]),.o(syn_6_tmp[359:352]));
  gf_mult_by_26 m1575 (.i(rx_data[367:360]),.o(syn_6_tmp[367:360]));
  gf_mult_by_75 m1576 (.i(rx_data[375:368]),.o(syn_6_tmp[375:368]));
  gf_mult_by_0c m1577 (.i(rx_data[383:376]),.o(syn_6_tmp[383:376]));
  gf_mult_by_27 m1578 (.i(rx_data[391:384]),.o(syn_6_tmp[391:384]));
  gf_mult_by_35 m1579 (.i(rx_data[399:392]),.o(syn_6_tmp[399:392]));
  gf_mult_by_c1 m1580 (.i(rx_data[407:400]),.o(syn_6_tmp[407:400]));
  gf_mult_by_0a m1581 (.i(rx_data[415:408]),.o(syn_6_tmp[415:408]));
  gf_mult_by_ba m1582 (.i(rx_data[423:416]),.o(syn_6_tmp[423:416]));
  gf_mult_by_a1 m1583 (.i(rx_data[431:424]),.o(syn_6_tmp[431:424]));
  gf_mult_by_2f m1584 (.i(rx_data[439:432]),.o(syn_6_tmp[439:432]));
  gf_mult_by_0f m1585 (.i(rx_data[447:440]),.o(syn_6_tmp[447:440]));
  gf_mult_by_e7 m1586 (.i(rx_data[455:448]),.o(syn_6_tmp[455:448]));
  gf_mult_by_7f m1587 (.i(rx_data[463:456]),.o(syn_6_tmp[463:456]));
  gf_mult_by_b6 m1588 (.i(rx_data[471:464]),.o(syn_6_tmp[471:464]));
  gf_mult_by_86 m1589 (.i(rx_data[479:472]),.o(syn_6_tmp[479:472]));
  gf_mult_by_1a m1590 (.i(rx_data[487:480]),.o(syn_6_tmp[487:480]));
  gf_mult_by_ce m1591 (.i(rx_data[495:488]),.o(syn_6_tmp[495:488]));
  gf_mult_by_ed m1592 (.i(rx_data[503:496]),.o(syn_6_tmp[503:496]));
  gf_mult_by_c5 m1593 (.i(rx_data[511:504]),.o(syn_6_tmp[511:504]));
  gf_mult_by_17 m1594 (.i(rx_data[519:512]),.o(syn_6_tmp[519:512]));
  gf_mult_by_a9 m1595 (.i(rx_data[527:520]),.o(syn_6_tmp[527:520]));
  gf_mult_by_15 m1596 (.i(rx_data[535:528]),.o(syn_6_tmp[535:528]));
  gf_mult_by_29 m1597 (.i(rx_data[543:536]),.o(syn_6_tmp[543:536]));
  gf_mult_by_92 m1598 (.i(rx_data[551:544]),.o(syn_6_tmp[551:544]));
  gf_mult_by_73 m1599 (.i(rx_data[559:552]),.o(syn_6_tmp[559:552]));
  gf_mult_by_91 m1600 (.i(rx_data[567:560]),.o(syn_6_tmp[567:560]));
  gf_mult_by_b3 m1601 (.i(rx_data[575:568]),.o(syn_6_tmp[575:568]));
  gf_mult_by_db m1602 (.i(rx_data[583:576]),.o(syn_6_tmp[583:576]));
  gf_mult_by_c4 m1603 (.i(rx_data[591:584]),.o(syn_6_tmp[591:584]));
  gf_mult_by_57 m1604 (.i(rx_data[599:592]),.o(syn_6_tmp[599:592]));
  gf_mult_by_64 m1605 (.i(rx_data[607:600]),.o(syn_6_tmp[607:600]));
  gf_mult_by_38 m1606 (.i(rx_data[615:608]),.o(syn_6_tmp[615:608]));
  gf_mult_by_a6 m1607 (.i(rx_data[623:616]),.o(syn_6_tmp[623:616]));
  gf_mult_by_f2 m1608 (.i(rx_data[631:624]),.o(syn_6_tmp[631:624]));
  gf_mult_by_56 m1609 (.i(rx_data[639:632]),.o(syn_6_tmp[639:632]));
  gf_mult_by_24 m1610 (.i(rx_data[647:640]),.o(syn_6_tmp[647:640]));
  gf_mult_by_f5 m1611 (.i(rx_data[655:648]),.o(syn_6_tmp[655:648]));
  gf_mult_by_8b m1612 (.i(rx_data[663:656]),.o(syn_6_tmp[663:656]));
  gf_mult_by_7d m1613 (.i(rx_data[671:664]),.o(syn_6_tmp[671:664]));
  gf_mult_by_36 m1614 (.i(rx_data[679:672]),.o(syn_6_tmp[679:672]));
  gf_mult_by_01 m1615 (.i(rx_data[687:680]),.o(syn_6_tmp[687:680]));
  gf_mult_by_40 m1616 (.i(rx_data[695:688]),.o(syn_6_tmp[695:688]));
  gf_mult_by_cd m1617 (.i(rx_data[703:696]),.o(syn_6_tmp[703:696]));
  gf_mult_by_2d m1618 (.i(rx_data[711:704]),.o(syn_6_tmp[711:704]));
  gf_mult_by_8f m1619 (.i(rx_data[719:712]),.o(syn_6_tmp[719:712]));
  gf_mult_by_60 m1620 (.i(rx_data[727:720]),.o(syn_6_tmp[727:720]));
  gf_mult_by_25 m1621 (.i(rx_data[735:728]),.o(syn_6_tmp[735:728]));
  gf_mult_by_b5 m1622 (.i(rx_data[743:736]),.o(syn_6_tmp[743:736]));
  gf_mult_by_46 m1623 (.i(rx_data[751:744]),.o(syn_6_tmp[751:744]));
  gf_mult_by_50 m1624 (.i(rx_data[759:752]),.o(syn_6_tmp[759:752]));
  gf_mult_by_b9 m1625 (.i(rx_data[767:760]),.o(syn_6_tmp[767:760]));
  gf_mult_by_61 m1626 (.i(rx_data[775:768]),.o(syn_6_tmp[775:768]));
  gf_mult_by_65 m1627 (.i(rx_data[783:776]),.o(syn_6_tmp[783:776]));
  gf_mult_by_78 m1628 (.i(rx_data[791:784]),.o(syn_6_tmp[791:784]));
  gf_mult_by_6b m1629 (.i(rx_data[799:792]),.o(syn_6_tmp[799:792]));
  gf_mult_by_df m1630 (.i(rx_data[807:800]),.o(syn_6_tmp[807:800]));
  gf_mult_by_d9 m1631 (.i(rx_data[815:808]),.o(syn_6_tmp[815:808]));
  gf_mult_by_44 m1632 (.i(rx_data[823:816]),.o(syn_6_tmp[823:816]));
  gf_mult_by_d0 m1633 (.i(rx_data[831:824]),.o(syn_6_tmp[831:824]));
  gf_mult_by_3e m1634 (.i(rx_data[839:832]),.o(syn_6_tmp[839:832]));
  gf_mult_by_3b m1635 (.i(rx_data[847:840]),.o(syn_6_tmp[847:840]));
  gf_mult_by_66 m1636 (.i(rx_data[855:848]),.o(syn_6_tmp[855:848]));
  gf_mult_by_b8 m1637 (.i(rx_data[863:856]),.o(syn_6_tmp[863:856]));
  gf_mult_by_21 m1638 (.i(rx_data[871:864]),.o(syn_6_tmp[871:864]));
  gf_mult_by_a8 m1639 (.i(rx_data[879:872]),.o(syn_6_tmp[879:872]));
  gf_mult_by_55 m1640 (.i(rx_data[887:880]),.o(syn_6_tmp[887:880]));
  gf_mult_by_e4 m1641 (.i(rx_data[895:888]),.o(syn_6_tmp[895:888]));
  gf_mult_by_bf m1642 (.i(rx_data[903:896]),.o(syn_6_tmp[903:896]));
  gf_mult_by_fc m1643 (.i(rx_data[911:904]),.o(syn_6_tmp[911:904]));
  gf_mult_by_f1 m1644 (.i(rx_data[919:912]),.o(syn_6_tmp[919:912]));
  gf_mult_by_96 m1645 (.i(rx_data[927:920]),.o(syn_6_tmp[927:920]));
  gf_mult_by_6e m1646 (.i(rx_data[935:928]),.o(syn_6_tmp[935:928]));
  gf_mult_by_82 m1647 (.i(rx_data[943:936]),.o(syn_6_tmp[943:936]));
  gf_mult_by_07 m1648 (.i(rx_data[951:944]),.o(syn_6_tmp[951:944]));
  gf_mult_by_dd m1649 (.i(rx_data[959:952]),.o(syn_6_tmp[959:952]));
  gf_mult_by_59 m1650 (.i(rx_data[967:960]),.o(syn_6_tmp[967:960]));
  gf_mult_by_c3 m1651 (.i(rx_data[975:968]),.o(syn_6_tmp[975:968]));
  gf_mult_by_8a m1652 (.i(rx_data[983:976]),.o(syn_6_tmp[983:976]));
  gf_mult_by_3d m1653 (.i(rx_data[991:984]),.o(syn_6_tmp[991:984]));
  gf_mult_by_fb m1654 (.i(rx_data[999:992]),.o(syn_6_tmp[999:992]));
  gf_mult_by_2c m1655 (.i(rx_data[1007:1000]),.o(syn_6_tmp[1007:1000]));
  gf_mult_by_cf m1656 (.i(rx_data[1015:1008]),.o(syn_6_tmp[1015:1008]));
  gf_mult_by_ad m1657 (.i(rx_data[1023:1016]),.o(syn_6_tmp[1023:1016]));
  gf_mult_by_08 m1658 (.i(rx_data[1031:1024]),.o(syn_6_tmp[1031:1024]));
  gf_mult_by_3a m1659 (.i(rx_data[1039:1032]),.o(syn_6_tmp[1039:1032]));
  gf_mult_by_26 m1660 (.i(rx_data[1047:1040]),.o(syn_6_tmp[1047:1040]));
  gf_mult_by_75 m1661 (.i(rx_data[1055:1048]),.o(syn_6_tmp[1055:1048]));
  gf_mult_by_0c m1662 (.i(rx_data[1063:1056]),.o(syn_6_tmp[1063:1056]));
  gf_mult_by_27 m1663 (.i(rx_data[1071:1064]),.o(syn_6_tmp[1071:1064]));
  gf_mult_by_35 m1664 (.i(rx_data[1079:1072]),.o(syn_6_tmp[1079:1072]));
  gf_mult_by_c1 m1665 (.i(rx_data[1087:1080]),.o(syn_6_tmp[1087:1080]));
  gf_mult_by_0a m1666 (.i(rx_data[1095:1088]),.o(syn_6_tmp[1095:1088]));
  gf_mult_by_ba m1667 (.i(rx_data[1103:1096]),.o(syn_6_tmp[1103:1096]));
  gf_mult_by_a1 m1668 (.i(rx_data[1111:1104]),.o(syn_6_tmp[1111:1104]));
  gf_mult_by_2f m1669 (.i(rx_data[1119:1112]),.o(syn_6_tmp[1119:1112]));
  gf_mult_by_0f m1670 (.i(rx_data[1127:1120]),.o(syn_6_tmp[1127:1120]));
  gf_mult_by_e7 m1671 (.i(rx_data[1135:1128]),.o(syn_6_tmp[1135:1128]));
  gf_mult_by_7f m1672 (.i(rx_data[1143:1136]),.o(syn_6_tmp[1143:1136]));
  gf_mult_by_b6 m1673 (.i(rx_data[1151:1144]),.o(syn_6_tmp[1151:1144]));
  gf_mult_by_86 m1674 (.i(rx_data[1159:1152]),.o(syn_6_tmp[1159:1152]));
  gf_mult_by_1a m1675 (.i(rx_data[1167:1160]),.o(syn_6_tmp[1167:1160]));
  gf_mult_by_ce m1676 (.i(rx_data[1175:1168]),.o(syn_6_tmp[1175:1168]));
  gf_mult_by_ed m1677 (.i(rx_data[1183:1176]),.o(syn_6_tmp[1183:1176]));
  gf_mult_by_c5 m1678 (.i(rx_data[1191:1184]),.o(syn_6_tmp[1191:1184]));
  gf_mult_by_17 m1679 (.i(rx_data[1199:1192]),.o(syn_6_tmp[1199:1192]));
  gf_mult_by_a9 m1680 (.i(rx_data[1207:1200]),.o(syn_6_tmp[1207:1200]));
  gf_mult_by_15 m1681 (.i(rx_data[1215:1208]),.o(syn_6_tmp[1215:1208]));
  gf_mult_by_29 m1682 (.i(rx_data[1223:1216]),.o(syn_6_tmp[1223:1216]));
  gf_mult_by_92 m1683 (.i(rx_data[1231:1224]),.o(syn_6_tmp[1231:1224]));
  gf_mult_by_73 m1684 (.i(rx_data[1239:1232]),.o(syn_6_tmp[1239:1232]));
  gf_mult_by_91 m1685 (.i(rx_data[1247:1240]),.o(syn_6_tmp[1247:1240]));
  gf_mult_by_b3 m1686 (.i(rx_data[1255:1248]),.o(syn_6_tmp[1255:1248]));
  gf_mult_by_db m1687 (.i(rx_data[1263:1256]),.o(syn_6_tmp[1263:1256]));
  gf_mult_by_c4 m1688 (.i(rx_data[1271:1264]),.o(syn_6_tmp[1271:1264]));
  gf_mult_by_57 m1689 (.i(rx_data[1279:1272]),.o(syn_6_tmp[1279:1272]));
  gf_mult_by_64 m1690 (.i(rx_data[1287:1280]),.o(syn_6_tmp[1287:1280]));
  gf_mult_by_38 m1691 (.i(rx_data[1295:1288]),.o(syn_6_tmp[1295:1288]));
  gf_mult_by_a6 m1692 (.i(rx_data[1303:1296]),.o(syn_6_tmp[1303:1296]));
  gf_mult_by_f2 m1693 (.i(rx_data[1311:1304]),.o(syn_6_tmp[1311:1304]));
  gf_mult_by_56 m1694 (.i(rx_data[1319:1312]),.o(syn_6_tmp[1319:1312]));
  gf_mult_by_24 m1695 (.i(rx_data[1327:1320]),.o(syn_6_tmp[1327:1320]));
  gf_mult_by_f5 m1696 (.i(rx_data[1335:1328]),.o(syn_6_tmp[1335:1328]));
  gf_mult_by_8b m1697 (.i(rx_data[1343:1336]),.o(syn_6_tmp[1343:1336]));
  gf_mult_by_7d m1698 (.i(rx_data[1351:1344]),.o(syn_6_tmp[1351:1344]));
  gf_mult_by_36 m1699 (.i(rx_data[1359:1352]),.o(syn_6_tmp[1359:1352]));
  gf_mult_by_01 m1700 (.i(rx_data[1367:1360]),.o(syn_6_tmp[1367:1360]));
  gf_mult_by_40 m1701 (.i(rx_data[1375:1368]),.o(syn_6_tmp[1375:1368]));
  gf_mult_by_cd m1702 (.i(rx_data[1383:1376]),.o(syn_6_tmp[1383:1376]));
  gf_mult_by_2d m1703 (.i(rx_data[1391:1384]),.o(syn_6_tmp[1391:1384]));
  gf_mult_by_8f m1704 (.i(rx_data[1399:1392]),.o(syn_6_tmp[1399:1392]));
  gf_mult_by_60 m1705 (.i(rx_data[1407:1400]),.o(syn_6_tmp[1407:1400]));
  gf_mult_by_25 m1706 (.i(rx_data[1415:1408]),.o(syn_6_tmp[1415:1408]));
  gf_mult_by_b5 m1707 (.i(rx_data[1423:1416]),.o(syn_6_tmp[1423:1416]));
  gf_mult_by_46 m1708 (.i(rx_data[1431:1424]),.o(syn_6_tmp[1431:1424]));
  gf_mult_by_50 m1709 (.i(rx_data[1439:1432]),.o(syn_6_tmp[1439:1432]));
  gf_mult_by_b9 m1710 (.i(rx_data[1447:1440]),.o(syn_6_tmp[1447:1440]));
  gf_mult_by_61 m1711 (.i(rx_data[1455:1448]),.o(syn_6_tmp[1455:1448]));
  gf_mult_by_65 m1712 (.i(rx_data[1463:1456]),.o(syn_6_tmp[1463:1456]));
  gf_mult_by_78 m1713 (.i(rx_data[1471:1464]),.o(syn_6_tmp[1471:1464]));
  gf_mult_by_6b m1714 (.i(rx_data[1479:1472]),.o(syn_6_tmp[1479:1472]));
  gf_mult_by_df m1715 (.i(rx_data[1487:1480]),.o(syn_6_tmp[1487:1480]));
  gf_mult_by_d9 m1716 (.i(rx_data[1495:1488]),.o(syn_6_tmp[1495:1488]));
  gf_mult_by_44 m1717 (.i(rx_data[1503:1496]),.o(syn_6_tmp[1503:1496]));
  gf_mult_by_d0 m1718 (.i(rx_data[1511:1504]),.o(syn_6_tmp[1511:1504]));
  gf_mult_by_3e m1719 (.i(rx_data[1519:1512]),.o(syn_6_tmp[1519:1512]));
  gf_mult_by_3b m1720 (.i(rx_data[1527:1520]),.o(syn_6_tmp[1527:1520]));
  gf_mult_by_66 m1721 (.i(rx_data[1535:1528]),.o(syn_6_tmp[1535:1528]));
  gf_mult_by_b8 m1722 (.i(rx_data[1543:1536]),.o(syn_6_tmp[1543:1536]));
  gf_mult_by_21 m1723 (.i(rx_data[1551:1544]),.o(syn_6_tmp[1551:1544]));
  gf_mult_by_a8 m1724 (.i(rx_data[1559:1552]),.o(syn_6_tmp[1559:1552]));
  gf_mult_by_55 m1725 (.i(rx_data[1567:1560]),.o(syn_6_tmp[1567:1560]));
  gf_mult_by_e4 m1726 (.i(rx_data[1575:1568]),.o(syn_6_tmp[1575:1568]));
  gf_mult_by_bf m1727 (.i(rx_data[1583:1576]),.o(syn_6_tmp[1583:1576]));
  gf_mult_by_fc m1728 (.i(rx_data[1591:1584]),.o(syn_6_tmp[1591:1584]));
  gf_mult_by_f1 m1729 (.i(rx_data[1599:1592]),.o(syn_6_tmp[1599:1592]));
  gf_mult_by_96 m1730 (.i(rx_data[1607:1600]),.o(syn_6_tmp[1607:1600]));
  gf_mult_by_6e m1731 (.i(rx_data[1615:1608]),.o(syn_6_tmp[1615:1608]));
  gf_mult_by_82 m1732 (.i(rx_data[1623:1616]),.o(syn_6_tmp[1623:1616]));
  gf_mult_by_07 m1733 (.i(rx_data[1631:1624]),.o(syn_6_tmp[1631:1624]));
  gf_mult_by_dd m1734 (.i(rx_data[1639:1632]),.o(syn_6_tmp[1639:1632]));
  gf_mult_by_59 m1735 (.i(rx_data[1647:1640]),.o(syn_6_tmp[1647:1640]));
  gf_mult_by_c3 m1736 (.i(rx_data[1655:1648]),.o(syn_6_tmp[1655:1648]));
  gf_mult_by_8a m1737 (.i(rx_data[1663:1656]),.o(syn_6_tmp[1663:1656]));
  gf_mult_by_3d m1738 (.i(rx_data[1671:1664]),.o(syn_6_tmp[1671:1664]));
  gf_mult_by_fb m1739 (.i(rx_data[1679:1672]),.o(syn_6_tmp[1679:1672]));
  gf_mult_by_2c m1740 (.i(rx_data[1687:1680]),.o(syn_6_tmp[1687:1680]));
  gf_mult_by_cf m1741 (.i(rx_data[1695:1688]),.o(syn_6_tmp[1695:1688]));
  gf_mult_by_ad m1742 (.i(rx_data[1703:1696]),.o(syn_6_tmp[1703:1696]));
  gf_mult_by_08 m1743 (.i(rx_data[1711:1704]),.o(syn_6_tmp[1711:1704]));
  gf_mult_by_3a m1744 (.i(rx_data[1719:1712]),.o(syn_6_tmp[1719:1712]));
  gf_mult_by_26 m1745 (.i(rx_data[1727:1720]),.o(syn_6_tmp[1727:1720]));
  gf_mult_by_75 m1746 (.i(rx_data[1735:1728]),.o(syn_6_tmp[1735:1728]));
  gf_mult_by_0c m1747 (.i(rx_data[1743:1736]),.o(syn_6_tmp[1743:1736]));
  gf_mult_by_27 m1748 (.i(rx_data[1751:1744]),.o(syn_6_tmp[1751:1744]));
  gf_mult_by_35 m1749 (.i(rx_data[1759:1752]),.o(syn_6_tmp[1759:1752]));
  gf_mult_by_c1 m1750 (.i(rx_data[1767:1760]),.o(syn_6_tmp[1767:1760]));
  gf_mult_by_0a m1751 (.i(rx_data[1775:1768]),.o(syn_6_tmp[1775:1768]));
  gf_mult_by_ba m1752 (.i(rx_data[1783:1776]),.o(syn_6_tmp[1783:1776]));
  gf_mult_by_a1 m1753 (.i(rx_data[1791:1784]),.o(syn_6_tmp[1791:1784]));
  gf_mult_by_2f m1754 (.i(rx_data[1799:1792]),.o(syn_6_tmp[1799:1792]));
  gf_mult_by_0f m1755 (.i(rx_data[1807:1800]),.o(syn_6_tmp[1807:1800]));
  gf_mult_by_e7 m1756 (.i(rx_data[1815:1808]),.o(syn_6_tmp[1815:1808]));
  gf_mult_by_7f m1757 (.i(rx_data[1823:1816]),.o(syn_6_tmp[1823:1816]));
  gf_mult_by_b6 m1758 (.i(rx_data[1831:1824]),.o(syn_6_tmp[1831:1824]));
  gf_mult_by_86 m1759 (.i(rx_data[1839:1832]),.o(syn_6_tmp[1839:1832]));
  gf_mult_by_1a m1760 (.i(rx_data[1847:1840]),.o(syn_6_tmp[1847:1840]));
  gf_mult_by_ce m1761 (.i(rx_data[1855:1848]),.o(syn_6_tmp[1855:1848]));
  gf_mult_by_ed m1762 (.i(rx_data[1863:1856]),.o(syn_6_tmp[1863:1856]));
  gf_mult_by_c5 m1763 (.i(rx_data[1871:1864]),.o(syn_6_tmp[1871:1864]));
  gf_mult_by_17 m1764 (.i(rx_data[1879:1872]),.o(syn_6_tmp[1879:1872]));
  gf_mult_by_a9 m1765 (.i(rx_data[1887:1880]),.o(syn_6_tmp[1887:1880]));
  gf_mult_by_15 m1766 (.i(rx_data[1895:1888]),.o(syn_6_tmp[1895:1888]));
  gf_mult_by_29 m1767 (.i(rx_data[1903:1896]),.o(syn_6_tmp[1903:1896]));
  gf_mult_by_92 m1768 (.i(rx_data[1911:1904]),.o(syn_6_tmp[1911:1904]));
  gf_mult_by_73 m1769 (.i(rx_data[1919:1912]),.o(syn_6_tmp[1919:1912]));
  gf_mult_by_91 m1770 (.i(rx_data[1927:1920]),.o(syn_6_tmp[1927:1920]));
  gf_mult_by_b3 m1771 (.i(rx_data[1935:1928]),.o(syn_6_tmp[1935:1928]));
  gf_mult_by_db m1772 (.i(rx_data[1943:1936]),.o(syn_6_tmp[1943:1936]));
  gf_mult_by_c4 m1773 (.i(rx_data[1951:1944]),.o(syn_6_tmp[1951:1944]));
  gf_mult_by_57 m1774 (.i(rx_data[1959:1952]),.o(syn_6_tmp[1959:1952]));
  gf_mult_by_64 m1775 (.i(rx_data[1967:1960]),.o(syn_6_tmp[1967:1960]));
  gf_mult_by_38 m1776 (.i(rx_data[1975:1968]),.o(syn_6_tmp[1975:1968]));
  gf_mult_by_a6 m1777 (.i(rx_data[1983:1976]),.o(syn_6_tmp[1983:1976]));
  gf_mult_by_f2 m1778 (.i(rx_data[1991:1984]),.o(syn_6_tmp[1991:1984]));
  gf_mult_by_56 m1779 (.i(rx_data[1999:1992]),.o(syn_6_tmp[1999:1992]));
  gf_mult_by_24 m1780 (.i(rx_data[2007:2000]),.o(syn_6_tmp[2007:2000]));
  gf_mult_by_f5 m1781 (.i(rx_data[2015:2008]),.o(syn_6_tmp[2015:2008]));
  gf_mult_by_8b m1782 (.i(rx_data[2023:2016]),.o(syn_6_tmp[2023:2016]));
  gf_mult_by_7d m1783 (.i(rx_data[2031:2024]),.o(syn_6_tmp[2031:2024]));
  gf_mult_by_36 m1784 (.i(rx_data[2039:2032]),.o(syn_6_tmp[2039:2032]));
  assign syndrome[55:48] =
      syn_6_tmp[7:0] ^ syn_6_tmp[15:8] ^ syn_6_tmp[23:16] ^ 
      syn_6_tmp[31:24] ^ syn_6_tmp[39:32] ^ syn_6_tmp[47:40] ^ 
      syn_6_tmp[55:48] ^ syn_6_tmp[63:56] ^ syn_6_tmp[71:64] ^ 
      syn_6_tmp[79:72] ^ syn_6_tmp[87:80] ^ syn_6_tmp[95:88] ^ 
      syn_6_tmp[103:96] ^ syn_6_tmp[111:104] ^ syn_6_tmp[119:112] ^ 
      syn_6_tmp[127:120] ^ syn_6_tmp[135:128] ^ syn_6_tmp[143:136] ^ 
      syn_6_tmp[151:144] ^ syn_6_tmp[159:152] ^ syn_6_tmp[167:160] ^ 
      syn_6_tmp[175:168] ^ syn_6_tmp[183:176] ^ syn_6_tmp[191:184] ^ 
      syn_6_tmp[199:192] ^ syn_6_tmp[207:200] ^ syn_6_tmp[215:208] ^ 
      syn_6_tmp[223:216] ^ syn_6_tmp[231:224] ^ syn_6_tmp[239:232] ^ 
      syn_6_tmp[247:240] ^ syn_6_tmp[255:248] ^ syn_6_tmp[263:256] ^ 
      syn_6_tmp[271:264] ^ syn_6_tmp[279:272] ^ syn_6_tmp[287:280] ^ 
      syn_6_tmp[295:288] ^ syn_6_tmp[303:296] ^ syn_6_tmp[311:304] ^ 
      syn_6_tmp[319:312] ^ syn_6_tmp[327:320] ^ syn_6_tmp[335:328] ^ 
      syn_6_tmp[343:336] ^ syn_6_tmp[351:344] ^ syn_6_tmp[359:352] ^ 
      syn_6_tmp[367:360] ^ syn_6_tmp[375:368] ^ syn_6_tmp[383:376] ^ 
      syn_6_tmp[391:384] ^ syn_6_tmp[399:392] ^ syn_6_tmp[407:400] ^ 
      syn_6_tmp[415:408] ^ syn_6_tmp[423:416] ^ syn_6_tmp[431:424] ^ 
      syn_6_tmp[439:432] ^ syn_6_tmp[447:440] ^ syn_6_tmp[455:448] ^ 
      syn_6_tmp[463:456] ^ syn_6_tmp[471:464] ^ syn_6_tmp[479:472] ^ 
      syn_6_tmp[487:480] ^ syn_6_tmp[495:488] ^ syn_6_tmp[503:496] ^ 
      syn_6_tmp[511:504] ^ syn_6_tmp[519:512] ^ syn_6_tmp[527:520] ^ 
      syn_6_tmp[535:528] ^ syn_6_tmp[543:536] ^ syn_6_tmp[551:544] ^ 
      syn_6_tmp[559:552] ^ syn_6_tmp[567:560] ^ syn_6_tmp[575:568] ^ 
      syn_6_tmp[583:576] ^ syn_6_tmp[591:584] ^ syn_6_tmp[599:592] ^ 
      syn_6_tmp[607:600] ^ syn_6_tmp[615:608] ^ syn_6_tmp[623:616] ^ 
      syn_6_tmp[631:624] ^ syn_6_tmp[639:632] ^ syn_6_tmp[647:640] ^ 
      syn_6_tmp[655:648] ^ syn_6_tmp[663:656] ^ syn_6_tmp[671:664] ^ 
      syn_6_tmp[679:672] ^ syn_6_tmp[687:680] ^ syn_6_tmp[695:688] ^ 
      syn_6_tmp[703:696] ^ syn_6_tmp[711:704] ^ syn_6_tmp[719:712] ^ 
      syn_6_tmp[727:720] ^ syn_6_tmp[735:728] ^ syn_6_tmp[743:736] ^ 
      syn_6_tmp[751:744] ^ syn_6_tmp[759:752] ^ syn_6_tmp[767:760] ^ 
      syn_6_tmp[775:768] ^ syn_6_tmp[783:776] ^ syn_6_tmp[791:784] ^ 
      syn_6_tmp[799:792] ^ syn_6_tmp[807:800] ^ syn_6_tmp[815:808] ^ 
      syn_6_tmp[823:816] ^ syn_6_tmp[831:824] ^ syn_6_tmp[839:832] ^ 
      syn_6_tmp[847:840] ^ syn_6_tmp[855:848] ^ syn_6_tmp[863:856] ^ 
      syn_6_tmp[871:864] ^ syn_6_tmp[879:872] ^ syn_6_tmp[887:880] ^ 
      syn_6_tmp[895:888] ^ syn_6_tmp[903:896] ^ syn_6_tmp[911:904] ^ 
      syn_6_tmp[919:912] ^ syn_6_tmp[927:920] ^ syn_6_tmp[935:928] ^ 
      syn_6_tmp[943:936] ^ syn_6_tmp[951:944] ^ syn_6_tmp[959:952] ^ 
      syn_6_tmp[967:960] ^ syn_6_tmp[975:968] ^ syn_6_tmp[983:976] ^ 
      syn_6_tmp[991:984] ^ syn_6_tmp[999:992] ^ syn_6_tmp[1007:1000] ^ 
      syn_6_tmp[1015:1008] ^ syn_6_tmp[1023:1016] ^ syn_6_tmp[1031:1024] ^ 
      syn_6_tmp[1039:1032] ^ syn_6_tmp[1047:1040] ^ syn_6_tmp[1055:1048] ^ 
      syn_6_tmp[1063:1056] ^ syn_6_tmp[1071:1064] ^ syn_6_tmp[1079:1072] ^ 
      syn_6_tmp[1087:1080] ^ syn_6_tmp[1095:1088] ^ syn_6_tmp[1103:1096] ^ 
      syn_6_tmp[1111:1104] ^ syn_6_tmp[1119:1112] ^ syn_6_tmp[1127:1120] ^ 
      syn_6_tmp[1135:1128] ^ syn_6_tmp[1143:1136] ^ syn_6_tmp[1151:1144] ^ 
      syn_6_tmp[1159:1152] ^ syn_6_tmp[1167:1160] ^ syn_6_tmp[1175:1168] ^ 
      syn_6_tmp[1183:1176] ^ syn_6_tmp[1191:1184] ^ syn_6_tmp[1199:1192] ^ 
      syn_6_tmp[1207:1200] ^ syn_6_tmp[1215:1208] ^ syn_6_tmp[1223:1216] ^ 
      syn_6_tmp[1231:1224] ^ syn_6_tmp[1239:1232] ^ syn_6_tmp[1247:1240] ^ 
      syn_6_tmp[1255:1248] ^ syn_6_tmp[1263:1256] ^ syn_6_tmp[1271:1264] ^ 
      syn_6_tmp[1279:1272] ^ syn_6_tmp[1287:1280] ^ syn_6_tmp[1295:1288] ^ 
      syn_6_tmp[1303:1296] ^ syn_6_tmp[1311:1304] ^ syn_6_tmp[1319:1312] ^ 
      syn_6_tmp[1327:1320] ^ syn_6_tmp[1335:1328] ^ syn_6_tmp[1343:1336] ^ 
      syn_6_tmp[1351:1344] ^ syn_6_tmp[1359:1352] ^ syn_6_tmp[1367:1360] ^ 
      syn_6_tmp[1375:1368] ^ syn_6_tmp[1383:1376] ^ syn_6_tmp[1391:1384] ^ 
      syn_6_tmp[1399:1392] ^ syn_6_tmp[1407:1400] ^ syn_6_tmp[1415:1408] ^ 
      syn_6_tmp[1423:1416] ^ syn_6_tmp[1431:1424] ^ syn_6_tmp[1439:1432] ^ 
      syn_6_tmp[1447:1440] ^ syn_6_tmp[1455:1448] ^ syn_6_tmp[1463:1456] ^ 
      syn_6_tmp[1471:1464] ^ syn_6_tmp[1479:1472] ^ syn_6_tmp[1487:1480] ^ 
      syn_6_tmp[1495:1488] ^ syn_6_tmp[1503:1496] ^ syn_6_tmp[1511:1504] ^ 
      syn_6_tmp[1519:1512] ^ syn_6_tmp[1527:1520] ^ syn_6_tmp[1535:1528] ^ 
      syn_6_tmp[1543:1536] ^ syn_6_tmp[1551:1544] ^ syn_6_tmp[1559:1552] ^ 
      syn_6_tmp[1567:1560] ^ syn_6_tmp[1575:1568] ^ syn_6_tmp[1583:1576] ^ 
      syn_6_tmp[1591:1584] ^ syn_6_tmp[1599:1592] ^ syn_6_tmp[1607:1600] ^ 
      syn_6_tmp[1615:1608] ^ syn_6_tmp[1623:1616] ^ syn_6_tmp[1631:1624] ^ 
      syn_6_tmp[1639:1632] ^ syn_6_tmp[1647:1640] ^ syn_6_tmp[1655:1648] ^ 
      syn_6_tmp[1663:1656] ^ syn_6_tmp[1671:1664] ^ syn_6_tmp[1679:1672] ^ 
      syn_6_tmp[1687:1680] ^ syn_6_tmp[1695:1688] ^ syn_6_tmp[1703:1696] ^ 
      syn_6_tmp[1711:1704] ^ syn_6_tmp[1719:1712] ^ syn_6_tmp[1727:1720] ^ 
      syn_6_tmp[1735:1728] ^ syn_6_tmp[1743:1736] ^ syn_6_tmp[1751:1744] ^ 
      syn_6_tmp[1759:1752] ^ syn_6_tmp[1767:1760] ^ syn_6_tmp[1775:1768] ^ 
      syn_6_tmp[1783:1776] ^ syn_6_tmp[1791:1784] ^ syn_6_tmp[1799:1792] ^ 
      syn_6_tmp[1807:1800] ^ syn_6_tmp[1815:1808] ^ syn_6_tmp[1823:1816] ^ 
      syn_6_tmp[1831:1824] ^ syn_6_tmp[1839:1832] ^ syn_6_tmp[1847:1840] ^ 
      syn_6_tmp[1855:1848] ^ syn_6_tmp[1863:1856] ^ syn_6_tmp[1871:1864] ^ 
      syn_6_tmp[1879:1872] ^ syn_6_tmp[1887:1880] ^ syn_6_tmp[1895:1888] ^ 
      syn_6_tmp[1903:1896] ^ syn_6_tmp[1911:1904] ^ syn_6_tmp[1919:1912] ^ 
      syn_6_tmp[1927:1920] ^ syn_6_tmp[1935:1928] ^ syn_6_tmp[1943:1936] ^ 
      syn_6_tmp[1951:1944] ^ syn_6_tmp[1959:1952] ^ syn_6_tmp[1967:1960] ^ 
      syn_6_tmp[1975:1968] ^ syn_6_tmp[1983:1976] ^ syn_6_tmp[1991:1984] ^ 
      syn_6_tmp[1999:1992] ^ syn_6_tmp[2007:2000] ^ syn_6_tmp[2015:2008] ^ 
      syn_6_tmp[2023:2016] ^ syn_6_tmp[2031:2024] ^ syn_6_tmp[2039:2032];

// syndrome 7
  wire [2039:0] syn_7_tmp;
  gf_mult_by_01 m1785 (.i(rx_data[7:0]),.o(syn_7_tmp[7:0]));
  gf_mult_by_80 m1786 (.i(rx_data[15:8]),.o(syn_7_tmp[15:8]));
  gf_mult_by_13 m1787 (.i(rx_data[23:16]),.o(syn_7_tmp[23:16]));
  gf_mult_by_75 m1788 (.i(rx_data[31:24]),.o(syn_7_tmp[31:24]));
  gf_mult_by_18 m1789 (.i(rx_data[39:32]),.o(syn_7_tmp[39:32]));
  gf_mult_by_9c m1790 (.i(rx_data[47:40]),.o(syn_7_tmp[47:40]));
  gf_mult_by_b5 m1791 (.i(rx_data[55:48]),.o(syn_7_tmp[55:48]));
  gf_mult_by_8c m1792 (.i(rx_data[63:56]),.o(syn_7_tmp[63:56]));
  gf_mult_by_5d m1793 (.i(rx_data[71:64]),.o(syn_7_tmp[71:64]));
  gf_mult_by_a1 m1794 (.i(rx_data[79:72]),.o(syn_7_tmp[79:72]));
  gf_mult_by_5e m1795 (.i(rx_data[87:80]),.o(syn_7_tmp[87:80]));
  gf_mult_by_3c m1796 (.i(rx_data[95:88]),.o(syn_7_tmp[95:88]));
  gf_mult_by_6b m1797 (.i(rx_data[103:96]),.o(syn_7_tmp[103:96]));
  gf_mult_by_a3 m1798 (.i(rx_data[111:104]),.o(syn_7_tmp[111:104]));
  gf_mult_by_43 m1799 (.i(rx_data[119:112]),.o(syn_7_tmp[119:112]));
  gf_mult_by_1a m1800 (.i(rx_data[127:120]),.o(syn_7_tmp[127:120]));
  gf_mult_by_81 m1801 (.i(rx_data[135:128]),.o(syn_7_tmp[135:128]));
  gf_mult_by_93 m1802 (.i(rx_data[143:136]),.o(syn_7_tmp[143:136]));
  gf_mult_by_66 m1803 (.i(rx_data[151:144]),.o(syn_7_tmp[151:144]));
  gf_mult_by_6d m1804 (.i(rx_data[159:152]),.o(syn_7_tmp[159:152]));
  gf_mult_by_84 m1805 (.i(rx_data[167:160]),.o(syn_7_tmp[167:160]));
  gf_mult_by_29 m1806 (.i(rx_data[175:168]),.o(syn_7_tmp[175:168]));
  gf_mult_by_39 m1807 (.i(rx_data[183:176]),.o(syn_7_tmp[183:176]));
  gf_mult_by_d1 m1808 (.i(rx_data[191:184]),.o(syn_7_tmp[191:184]));
  gf_mult_by_fc m1809 (.i(rx_data[199:192]),.o(syn_7_tmp[199:192]));
  gf_mult_by_ff m1810 (.i(rx_data[207:200]),.o(syn_7_tmp[207:200]));
  gf_mult_by_62 m1811 (.i(rx_data[215:208]),.o(syn_7_tmp[215:208]));
  gf_mult_by_57 m1812 (.i(rx_data[223:216]),.o(syn_7_tmp[223:216]));
  gf_mult_by_c8 m1813 (.i(rx_data[231:224]),.o(syn_7_tmp[231:224]));
  gf_mult_by_e0 m1814 (.i(rx_data[239:232]),.o(syn_7_tmp[239:232]));
  gf_mult_by_59 m1815 (.i(rx_data[247:240]),.o(syn_7_tmp[247:240]));
  gf_mult_by_9b m1816 (.i(rx_data[255:248]),.o(syn_7_tmp[255:248]));
  gf_mult_by_12 m1817 (.i(rx_data[263:256]),.o(syn_7_tmp[263:256]));
  gf_mult_by_f5 m1818 (.i(rx_data[271:264]),.o(syn_7_tmp[271:264]));
  gf_mult_by_0b m1819 (.i(rx_data[279:272]),.o(syn_7_tmp[279:272]));
  gf_mult_by_e9 m1820 (.i(rx_data[287:280]),.o(syn_7_tmp[287:280]));
  gf_mult_by_ad m1821 (.i(rx_data[295:288]),.o(syn_7_tmp[295:288]));
  gf_mult_by_10 m1822 (.i(rx_data[303:296]),.o(syn_7_tmp[303:296]));
  gf_mult_by_e8 m1823 (.i(rx_data[311:304]),.o(syn_7_tmp[311:304]));
  gf_mult_by_2d m1824 (.i(rx_data[319:312]),.o(syn_7_tmp[319:312]));
  gf_mult_by_03 m1825 (.i(rx_data[327:320]),.o(syn_7_tmp[327:320]));
  gf_mult_by_9d m1826 (.i(rx_data[335:328]),.o(syn_7_tmp[335:328]));
  gf_mult_by_35 m1827 (.i(rx_data[343:336]),.o(syn_7_tmp[343:336]));
  gf_mult_by_9f m1828 (.i(rx_data[351:344]),.o(syn_7_tmp[351:344]));
  gf_mult_by_28 m1829 (.i(rx_data[359:352]),.o(syn_7_tmp[359:352]));
  gf_mult_by_b9 m1830 (.i(rx_data[367:360]),.o(syn_7_tmp[367:360]));
  gf_mult_by_c2 m1831 (.i(rx_data[375:368]),.o(syn_7_tmp[375:368]));
  gf_mult_by_89 m1832 (.i(rx_data[383:376]),.o(syn_7_tmp[383:376]));
  gf_mult_by_e7 m1833 (.i(rx_data[391:384]),.o(syn_7_tmp[391:384]));
  gf_mult_by_fe m1834 (.i(rx_data[399:392]),.o(syn_7_tmp[399:392]));
  gf_mult_by_e2 m1835 (.i(rx_data[407:400]),.o(syn_7_tmp[407:400]));
  gf_mult_by_44 m1836 (.i(rx_data[415:408]),.o(syn_7_tmp[415:408]));
  gf_mult_by_bd m1837 (.i(rx_data[423:416]),.o(syn_7_tmp[423:416]));
  gf_mult_by_f8 m1838 (.i(rx_data[431:424]),.o(syn_7_tmp[431:424]));
  gf_mult_by_c5 m1839 (.i(rx_data[439:432]),.o(syn_7_tmp[439:432]));
  gf_mult_by_2e m1840 (.i(rx_data[447:440]),.o(syn_7_tmp[447:440]));
  gf_mult_by_9e m1841 (.i(rx_data[455:448]),.o(syn_7_tmp[455:448]));
  gf_mult_by_a8 m1842 (.i(rx_data[463:456]),.o(syn_7_tmp[463:456]));
  gf_mult_by_aa m1843 (.i(rx_data[471:464]),.o(syn_7_tmp[471:464]));
  gf_mult_by_b7 m1844 (.i(rx_data[479:472]),.o(syn_7_tmp[479:472]));
  gf_mult_by_91 m1845 (.i(rx_data[487:480]),.o(syn_7_tmp[487:480]));
  gf_mult_by_7b m1846 (.i(rx_data[495:488]),.o(syn_7_tmp[495:488]));
  gf_mult_by_4b m1847 (.i(rx_data[503:496]),.o(syn_7_tmp[503:496]));
  gf_mult_by_6e m1848 (.i(rx_data[511:504]),.o(syn_7_tmp[511:504]));
  gf_mult_by_19 m1849 (.i(rx_data[519:512]),.o(syn_7_tmp[519:512]));
  gf_mult_by_1c m1850 (.i(rx_data[527:520]),.o(syn_7_tmp[527:520]));
  gf_mult_by_a6 m1851 (.i(rx_data[535:528]),.o(syn_7_tmp[535:528]));
  gf_mult_by_f9 m1852 (.i(rx_data[543:536]),.o(syn_7_tmp[543:536]));
  gf_mult_by_45 m1853 (.i(rx_data[551:544]),.o(syn_7_tmp[551:544]));
  gf_mult_by_3d m1854 (.i(rx_data[559:552]),.o(syn_7_tmp[559:552]));
  gf_mult_by_eb m1855 (.i(rx_data[567:560]),.o(syn_7_tmp[567:560]));
  gf_mult_by_b0 m1856 (.i(rx_data[575:568]),.o(syn_7_tmp[575:568]));
  gf_mult_by_36 m1857 (.i(rx_data[583:576]),.o(syn_7_tmp[583:576]));
  gf_mult_by_02 m1858 (.i(rx_data[591:584]),.o(syn_7_tmp[591:584]));
  gf_mult_by_1d m1859 (.i(rx_data[599:592]),.o(syn_7_tmp[599:592]));
  gf_mult_by_26 m1860 (.i(rx_data[607:600]),.o(syn_7_tmp[607:600]));
  gf_mult_by_ea m1861 (.i(rx_data[615:608]),.o(syn_7_tmp[615:608]));
  gf_mult_by_30 m1862 (.i(rx_data[623:616]),.o(syn_7_tmp[623:616]));
  gf_mult_by_25 m1863 (.i(rx_data[631:624]),.o(syn_7_tmp[631:624]));
  gf_mult_by_77 m1864 (.i(rx_data[639:632]),.o(syn_7_tmp[639:632]));
  gf_mult_by_05 m1865 (.i(rx_data[647:640]),.o(syn_7_tmp[647:640]));
  gf_mult_by_ba m1866 (.i(rx_data[655:648]),.o(syn_7_tmp[655:648]));
  gf_mult_by_5f m1867 (.i(rx_data[663:656]),.o(syn_7_tmp[663:656]));
  gf_mult_by_bc m1868 (.i(rx_data[671:664]),.o(syn_7_tmp[671:664]));
  gf_mult_by_78 m1869 (.i(rx_data[679:672]),.o(syn_7_tmp[679:672]));
  gf_mult_by_d6 m1870 (.i(rx_data[687:680]),.o(syn_7_tmp[687:680]));
  gf_mult_by_5b m1871 (.i(rx_data[695:688]),.o(syn_7_tmp[695:688]));
  gf_mult_by_86 m1872 (.i(rx_data[703:696]),.o(syn_7_tmp[703:696]));
  gf_mult_by_34 m1873 (.i(rx_data[711:704]),.o(syn_7_tmp[711:704]));
  gf_mult_by_1f m1874 (.i(rx_data[719:712]),.o(syn_7_tmp[719:712]));
  gf_mult_by_3b m1875 (.i(rx_data[727:720]),.o(syn_7_tmp[727:720]));
  gf_mult_by_cc m1876 (.i(rx_data[735:728]),.o(syn_7_tmp[735:728]));
  gf_mult_by_da m1877 (.i(rx_data[743:736]),.o(syn_7_tmp[743:736]));
  gf_mult_by_15 m1878 (.i(rx_data[751:744]),.o(syn_7_tmp[751:744]));
  gf_mult_by_52 m1879 (.i(rx_data[759:752]),.o(syn_7_tmp[759:752]));
  gf_mult_by_72 m1880 (.i(rx_data[767:760]),.o(syn_7_tmp[767:760]));
  gf_mult_by_bf m1881 (.i(rx_data[775:768]),.o(syn_7_tmp[775:768]));
  gf_mult_by_e5 m1882 (.i(rx_data[783:776]),.o(syn_7_tmp[783:776]));
  gf_mult_by_e3 m1883 (.i(rx_data[791:784]),.o(syn_7_tmp[791:784]));
  gf_mult_by_c4 m1884 (.i(rx_data[799:792]),.o(syn_7_tmp[799:792]));
  gf_mult_by_ae m1885 (.i(rx_data[807:800]),.o(syn_7_tmp[807:800]));
  gf_mult_by_8d m1886 (.i(rx_data[815:808]),.o(syn_7_tmp[815:808]));
  gf_mult_by_dd m1887 (.i(rx_data[823:816]),.o(syn_7_tmp[823:816]));
  gf_mult_by_b2 m1888 (.i(rx_data[831:824]),.o(syn_7_tmp[831:824]));
  gf_mult_by_2b m1889 (.i(rx_data[839:832]),.o(syn_7_tmp[839:832]));
  gf_mult_by_24 m1890 (.i(rx_data[847:840]),.o(syn_7_tmp[847:840]));
  gf_mult_by_f7 m1891 (.i(rx_data[855:848]),.o(syn_7_tmp[855:848]));
  gf_mult_by_16 m1892 (.i(rx_data[863:856]),.o(syn_7_tmp[863:856]));
  gf_mult_by_cf m1893 (.i(rx_data[871:864]),.o(syn_7_tmp[871:864]));
  gf_mult_by_47 m1894 (.i(rx_data[879:872]),.o(syn_7_tmp[879:872]));
  gf_mult_by_20 m1895 (.i(rx_data[887:880]),.o(syn_7_tmp[887:880]));
  gf_mult_by_cd m1896 (.i(rx_data[895:888]),.o(syn_7_tmp[895:888]));
  gf_mult_by_5a m1897 (.i(rx_data[903:896]),.o(syn_7_tmp[903:896]));
  gf_mult_by_06 m1898 (.i(rx_data[911:904]),.o(syn_7_tmp[911:904]));
  gf_mult_by_27 m1899 (.i(rx_data[919:912]),.o(syn_7_tmp[919:912]));
  gf_mult_by_6a m1900 (.i(rx_data[927:920]),.o(syn_7_tmp[927:920]));
  gf_mult_by_23 m1901 (.i(rx_data[935:928]),.o(syn_7_tmp[935:928]));
  gf_mult_by_50 m1902 (.i(rx_data[943:936]),.o(syn_7_tmp[943:936]));
  gf_mult_by_6f m1903 (.i(rx_data[951:944]),.o(syn_7_tmp[951:944]));
  gf_mult_by_99 m1904 (.i(rx_data[959:952]),.o(syn_7_tmp[959:952]));
  gf_mult_by_0f m1905 (.i(rx_data[967:960]),.o(syn_7_tmp[967:960]));
  gf_mult_by_d3 m1906 (.i(rx_data[975:968]),.o(syn_7_tmp[975:968]));
  gf_mult_by_e1 m1907 (.i(rx_data[983:976]),.o(syn_7_tmp[983:976]));
  gf_mult_by_d9 m1908 (.i(rx_data[991:984]),.o(syn_7_tmp[991:984]));
  gf_mult_by_88 m1909 (.i(rx_data[999:992]),.o(syn_7_tmp[999:992]));
  gf_mult_by_67 m1910 (.i(rx_data[1007:1000]),.o(syn_7_tmp[1007:1000]));
  gf_mult_by_ed m1911 (.i(rx_data[1015:1008]),.o(syn_7_tmp[1015:1008]));
  gf_mult_by_97 m1912 (.i(rx_data[1023:1016]),.o(syn_7_tmp[1023:1016]));
  gf_mult_by_5c m1913 (.i(rx_data[1031:1024]),.o(syn_7_tmp[1031:1024]));
  gf_mult_by_21 m1914 (.i(rx_data[1039:1032]),.o(syn_7_tmp[1039:1032]));
  gf_mult_by_4d m1915 (.i(rx_data[1047:1040]),.o(syn_7_tmp[1047:1040]));
  gf_mult_by_49 m1916 (.i(rx_data[1055:1048]),.o(syn_7_tmp[1055:1048]));
  gf_mult_by_73 m1917 (.i(rx_data[1063:1056]),.o(syn_7_tmp[1063:1056]));
  gf_mult_by_3f m1918 (.i(rx_data[1071:1064]),.o(syn_7_tmp[1071:1064]));
  gf_mult_by_f6 m1919 (.i(rx_data[1079:1072]),.o(syn_7_tmp[1079:1072]));
  gf_mult_by_96 m1920 (.i(rx_data[1087:1080]),.o(syn_7_tmp[1087:1080]));
  gf_mult_by_dc m1921 (.i(rx_data[1095:1088]),.o(syn_7_tmp[1095:1088]));
  gf_mult_by_32 m1922 (.i(rx_data[1103:1096]),.o(syn_7_tmp[1103:1096]));
  gf_mult_by_38 m1923 (.i(rx_data[1111:1104]),.o(syn_7_tmp[1111:1104]));
  gf_mult_by_51 m1924 (.i(rx_data[1119:1112]),.o(syn_7_tmp[1119:1112]));
  gf_mult_by_ef m1925 (.i(rx_data[1127:1120]),.o(syn_7_tmp[1127:1120]));
  gf_mult_by_8a m1926 (.i(rx_data[1135:1128]),.o(syn_7_tmp[1135:1128]));
  gf_mult_by_7a m1927 (.i(rx_data[1143:1136]),.o(syn_7_tmp[1143:1136]));
  gf_mult_by_cb m1928 (.i(rx_data[1151:1144]),.o(syn_7_tmp[1151:1144]));
  gf_mult_by_7d m1929 (.i(rx_data[1159:1152]),.o(syn_7_tmp[1159:1152]));
  gf_mult_by_6c m1930 (.i(rx_data[1167:1160]),.o(syn_7_tmp[1167:1160]));
  gf_mult_by_04 m1931 (.i(rx_data[1175:1168]),.o(syn_7_tmp[1175:1168]));
  gf_mult_by_3a m1932 (.i(rx_data[1183:1176]),.o(syn_7_tmp[1183:1176]));
  gf_mult_by_4c m1933 (.i(rx_data[1191:1184]),.o(syn_7_tmp[1191:1184]));
  gf_mult_by_c9 m1934 (.i(rx_data[1199:1192]),.o(syn_7_tmp[1199:1192]));
  gf_mult_by_60 m1935 (.i(rx_data[1207:1200]),.o(syn_7_tmp[1207:1200]));
  gf_mult_by_4a m1936 (.i(rx_data[1215:1208]),.o(syn_7_tmp[1215:1208]));
  gf_mult_by_ee m1937 (.i(rx_data[1223:1216]),.o(syn_7_tmp[1223:1216]));
  gf_mult_by_0a m1938 (.i(rx_data[1231:1224]),.o(syn_7_tmp[1231:1224]));
  gf_mult_by_69 m1939 (.i(rx_data[1239:1232]),.o(syn_7_tmp[1239:1232]));
  gf_mult_by_be m1940 (.i(rx_data[1247:1240]),.o(syn_7_tmp[1247:1240]));
  gf_mult_by_65 m1941 (.i(rx_data[1255:1248]),.o(syn_7_tmp[1255:1248]));
  gf_mult_by_f0 m1942 (.i(rx_data[1263:1256]),.o(syn_7_tmp[1263:1256]));
  gf_mult_by_b1 m1943 (.i(rx_data[1271:1264]),.o(syn_7_tmp[1271:1264]));
  gf_mult_by_b6 m1944 (.i(rx_data[1279:1272]),.o(syn_7_tmp[1279:1272]));
  gf_mult_by_11 m1945 (.i(rx_data[1287:1280]),.o(syn_7_tmp[1287:1280]));
  gf_mult_by_68 m1946 (.i(rx_data[1295:1288]),.o(syn_7_tmp[1295:1288]));
  gf_mult_by_3e m1947 (.i(rx_data[1303:1296]),.o(syn_7_tmp[1303:1296]));
  gf_mult_by_76 m1948 (.i(rx_data[1311:1304]),.o(syn_7_tmp[1311:1304]));
  gf_mult_by_85 m1949 (.i(rx_data[1319:1312]),.o(syn_7_tmp[1319:1312]));
  gf_mult_by_a9 m1950 (.i(rx_data[1327:1320]),.o(syn_7_tmp[1327:1320]));
  gf_mult_by_2a m1951 (.i(rx_data[1335:1328]),.o(syn_7_tmp[1335:1328]));
  gf_mult_by_a4 m1952 (.i(rx_data[1343:1336]),.o(syn_7_tmp[1343:1336]));
  gf_mult_by_e4 m1953 (.i(rx_data[1351:1344]),.o(syn_7_tmp[1351:1344]));
  gf_mult_by_63 m1954 (.i(rx_data[1359:1352]),.o(syn_7_tmp[1359:1352]));
  gf_mult_by_d7 m1955 (.i(rx_data[1367:1360]),.o(syn_7_tmp[1367:1360]));
  gf_mult_by_db m1956 (.i(rx_data[1375:1368]),.o(syn_7_tmp[1375:1368]));
  gf_mult_by_95 m1957 (.i(rx_data[1383:1376]),.o(syn_7_tmp[1383:1376]));
  gf_mult_by_41 m1958 (.i(rx_data[1391:1384]),.o(syn_7_tmp[1391:1384]));
  gf_mult_by_07 m1959 (.i(rx_data[1399:1392]),.o(syn_7_tmp[1399:1392]));
  gf_mult_by_a7 m1960 (.i(rx_data[1407:1400]),.o(syn_7_tmp[1407:1400]));
  gf_mult_by_79 m1961 (.i(rx_data[1415:1408]),.o(syn_7_tmp[1415:1408]));
  gf_mult_by_56 m1962 (.i(rx_data[1423:1416]),.o(syn_7_tmp[1423:1416]));
  gf_mult_by_48 m1963 (.i(rx_data[1431:1424]),.o(syn_7_tmp[1431:1424]));
  gf_mult_by_f3 m1964 (.i(rx_data[1439:1432]),.o(syn_7_tmp[1439:1432]));
  gf_mult_by_2c m1965 (.i(rx_data[1447:1440]),.o(syn_7_tmp[1447:1440]));
  gf_mult_by_83 m1966 (.i(rx_data[1455:1448]),.o(syn_7_tmp[1455:1448]));
  gf_mult_by_8e m1967 (.i(rx_data[1463:1456]),.o(syn_7_tmp[1463:1456]));
  gf_mult_by_40 m1968 (.i(rx_data[1471:1464]),.o(syn_7_tmp[1471:1464]));
  gf_mult_by_87 m1969 (.i(rx_data[1479:1472]),.o(syn_7_tmp[1479:1472]));
  gf_mult_by_b4 m1970 (.i(rx_data[1487:1480]),.o(syn_7_tmp[1487:1480]));
  gf_mult_by_0c m1971 (.i(rx_data[1495:1488]),.o(syn_7_tmp[1495:1488]));
  gf_mult_by_4e m1972 (.i(rx_data[1503:1496]),.o(syn_7_tmp[1503:1496]));
  gf_mult_by_d4 m1973 (.i(rx_data[1511:1504]),.o(syn_7_tmp[1511:1504]));
  gf_mult_by_46 m1974 (.i(rx_data[1519:1512]),.o(syn_7_tmp[1519:1512]));
  gf_mult_by_a0 m1975 (.i(rx_data[1527:1520]),.o(syn_7_tmp[1527:1520]));
  gf_mult_by_de m1976 (.i(rx_data[1535:1528]),.o(syn_7_tmp[1535:1528]));
  gf_mult_by_2f m1977 (.i(rx_data[1543:1536]),.o(syn_7_tmp[1543:1536]));
  gf_mult_by_1e m1978 (.i(rx_data[1551:1544]),.o(syn_7_tmp[1551:1544]));
  gf_mult_by_bb m1979 (.i(rx_data[1559:1552]),.o(syn_7_tmp[1559:1552]));
  gf_mult_by_df m1980 (.i(rx_data[1567:1560]),.o(syn_7_tmp[1567:1560]));
  gf_mult_by_af m1981 (.i(rx_data[1575:1568]),.o(syn_7_tmp[1575:1568]));
  gf_mult_by_0d m1982 (.i(rx_data[1583:1576]),.o(syn_7_tmp[1583:1576]));
  gf_mult_by_ce m1983 (.i(rx_data[1591:1584]),.o(syn_7_tmp[1591:1584]));
  gf_mult_by_c7 m1984 (.i(rx_data[1599:1592]),.o(syn_7_tmp[1599:1592]));
  gf_mult_by_33 m1985 (.i(rx_data[1607:1600]),.o(syn_7_tmp[1607:1600]));
  gf_mult_by_b8 m1986 (.i(rx_data[1615:1608]),.o(syn_7_tmp[1615:1608]));
  gf_mult_by_42 m1987 (.i(rx_data[1623:1616]),.o(syn_7_tmp[1623:1616]));
  gf_mult_by_9a m1988 (.i(rx_data[1631:1624]),.o(syn_7_tmp[1631:1624]));
  gf_mult_by_92 m1989 (.i(rx_data[1639:1632]),.o(syn_7_tmp[1639:1632]));
  gf_mult_by_e6 m1990 (.i(rx_data[1647:1640]),.o(syn_7_tmp[1647:1640]));
  gf_mult_by_7e m1991 (.i(rx_data[1655:1648]),.o(syn_7_tmp[1655:1648]));
  gf_mult_by_f1 m1992 (.i(rx_data[1663:1656]),.o(syn_7_tmp[1663:1656]));
  gf_mult_by_31 m1993 (.i(rx_data[1671:1664]),.o(syn_7_tmp[1671:1664]));
  gf_mult_by_a5 m1994 (.i(rx_data[1679:1672]),.o(syn_7_tmp[1679:1672]));
  gf_mult_by_64 m1995 (.i(rx_data[1687:1680]),.o(syn_7_tmp[1687:1680]));
  gf_mult_by_70 m1996 (.i(rx_data[1695:1688]),.o(syn_7_tmp[1695:1688]));
  gf_mult_by_a2 m1997 (.i(rx_data[1703:1696]),.o(syn_7_tmp[1703:1696]));
  gf_mult_by_c3 m1998 (.i(rx_data[1711:1704]),.o(syn_7_tmp[1711:1704]));
  gf_mult_by_09 m1999 (.i(rx_data[1719:1712]),.o(syn_7_tmp[1719:1712]));
  gf_mult_by_f4 m2000 (.i(rx_data[1727:1720]),.o(syn_7_tmp[1727:1720]));
  gf_mult_by_8b m2001 (.i(rx_data[1735:1728]),.o(syn_7_tmp[1735:1728]));
  gf_mult_by_fa m2002 (.i(rx_data[1743:1736]),.o(syn_7_tmp[1743:1736]));
  gf_mult_by_d8 m2003 (.i(rx_data[1751:1744]),.o(syn_7_tmp[1751:1744]));
  gf_mult_by_08 m2004 (.i(rx_data[1759:1752]),.o(syn_7_tmp[1759:1752]));
  gf_mult_by_74 m2005 (.i(rx_data[1767:1760]),.o(syn_7_tmp[1767:1760]));
  gf_mult_by_98 m2006 (.i(rx_data[1775:1768]),.o(syn_7_tmp[1775:1768]));
  gf_mult_by_8f m2007 (.i(rx_data[1783:1776]),.o(syn_7_tmp[1783:1776]));
  gf_mult_by_c0 m2008 (.i(rx_data[1791:1784]),.o(syn_7_tmp[1791:1784]));
  gf_mult_by_94 m2009 (.i(rx_data[1799:1792]),.o(syn_7_tmp[1799:1792]));
  gf_mult_by_c1 m2010 (.i(rx_data[1807:1800]),.o(syn_7_tmp[1807:1800]));
  gf_mult_by_14 m2011 (.i(rx_data[1815:1808]),.o(syn_7_tmp[1815:1808]));
  gf_mult_by_d2 m2012 (.i(rx_data[1823:1816]),.o(syn_7_tmp[1823:1816]));
  gf_mult_by_61 m2013 (.i(rx_data[1831:1824]),.o(syn_7_tmp[1831:1824]));
  gf_mult_by_ca m2014 (.i(rx_data[1839:1832]),.o(syn_7_tmp[1839:1832]));
  gf_mult_by_fd m2015 (.i(rx_data[1847:1840]),.o(syn_7_tmp[1847:1840]));
  gf_mult_by_7f m2016 (.i(rx_data[1855:1848]),.o(syn_7_tmp[1855:1848]));
  gf_mult_by_71 m2017 (.i(rx_data[1863:1856]),.o(syn_7_tmp[1863:1856]));
  gf_mult_by_22 m2018 (.i(rx_data[1871:1864]),.o(syn_7_tmp[1871:1864]));
  gf_mult_by_d0 m2019 (.i(rx_data[1879:1872]),.o(syn_7_tmp[1879:1872]));
  gf_mult_by_7c m2020 (.i(rx_data[1887:1880]),.o(syn_7_tmp[1887:1880]));
  gf_mult_by_ec m2021 (.i(rx_data[1895:1888]),.o(syn_7_tmp[1895:1888]));
  gf_mult_by_17 m2022 (.i(rx_data[1903:1896]),.o(syn_7_tmp[1903:1896]));
  gf_mult_by_4f m2023 (.i(rx_data[1911:1904]),.o(syn_7_tmp[1911:1904]));
  gf_mult_by_54 m2024 (.i(rx_data[1919:1912]),.o(syn_7_tmp[1919:1912]));
  gf_mult_by_55 m2025 (.i(rx_data[1927:1920]),.o(syn_7_tmp[1927:1920]));
  gf_mult_by_d5 m2026 (.i(rx_data[1935:1928]),.o(syn_7_tmp[1935:1928]));
  gf_mult_by_c6 m2027 (.i(rx_data[1943:1936]),.o(syn_7_tmp[1943:1936]));
  gf_mult_by_b3 m2028 (.i(rx_data[1951:1944]),.o(syn_7_tmp[1951:1944]));
  gf_mult_by_ab m2029 (.i(rx_data[1959:1952]),.o(syn_7_tmp[1959:1952]));
  gf_mult_by_37 m2030 (.i(rx_data[1967:1960]),.o(syn_7_tmp[1967:1960]));
  gf_mult_by_82 m2031 (.i(rx_data[1975:1968]),.o(syn_7_tmp[1975:1968]));
  gf_mult_by_0e m2032 (.i(rx_data[1983:1976]),.o(syn_7_tmp[1983:1976]));
  gf_mult_by_53 m2033 (.i(rx_data[1991:1984]),.o(syn_7_tmp[1991:1984]));
  gf_mult_by_f2 m2034 (.i(rx_data[1999:1992]),.o(syn_7_tmp[1999:1992]));
  gf_mult_by_ac m2035 (.i(rx_data[2007:2000]),.o(syn_7_tmp[2007:2000]));
  gf_mult_by_90 m2036 (.i(rx_data[2015:2008]),.o(syn_7_tmp[2015:2008]));
  gf_mult_by_fb m2037 (.i(rx_data[2023:2016]),.o(syn_7_tmp[2023:2016]));
  gf_mult_by_58 m2038 (.i(rx_data[2031:2024]),.o(syn_7_tmp[2031:2024]));
  gf_mult_by_1b m2039 (.i(rx_data[2039:2032]),.o(syn_7_tmp[2039:2032]));
  assign syndrome[63:56] =
      syn_7_tmp[7:0] ^ syn_7_tmp[15:8] ^ syn_7_tmp[23:16] ^ 
      syn_7_tmp[31:24] ^ syn_7_tmp[39:32] ^ syn_7_tmp[47:40] ^ 
      syn_7_tmp[55:48] ^ syn_7_tmp[63:56] ^ syn_7_tmp[71:64] ^ 
      syn_7_tmp[79:72] ^ syn_7_tmp[87:80] ^ syn_7_tmp[95:88] ^ 
      syn_7_tmp[103:96] ^ syn_7_tmp[111:104] ^ syn_7_tmp[119:112] ^ 
      syn_7_tmp[127:120] ^ syn_7_tmp[135:128] ^ syn_7_tmp[143:136] ^ 
      syn_7_tmp[151:144] ^ syn_7_tmp[159:152] ^ syn_7_tmp[167:160] ^ 
      syn_7_tmp[175:168] ^ syn_7_tmp[183:176] ^ syn_7_tmp[191:184] ^ 
      syn_7_tmp[199:192] ^ syn_7_tmp[207:200] ^ syn_7_tmp[215:208] ^ 
      syn_7_tmp[223:216] ^ syn_7_tmp[231:224] ^ syn_7_tmp[239:232] ^ 
      syn_7_tmp[247:240] ^ syn_7_tmp[255:248] ^ syn_7_tmp[263:256] ^ 
      syn_7_tmp[271:264] ^ syn_7_tmp[279:272] ^ syn_7_tmp[287:280] ^ 
      syn_7_tmp[295:288] ^ syn_7_tmp[303:296] ^ syn_7_tmp[311:304] ^ 
      syn_7_tmp[319:312] ^ syn_7_tmp[327:320] ^ syn_7_tmp[335:328] ^ 
      syn_7_tmp[343:336] ^ syn_7_tmp[351:344] ^ syn_7_tmp[359:352] ^ 
      syn_7_tmp[367:360] ^ syn_7_tmp[375:368] ^ syn_7_tmp[383:376] ^ 
      syn_7_tmp[391:384] ^ syn_7_tmp[399:392] ^ syn_7_tmp[407:400] ^ 
      syn_7_tmp[415:408] ^ syn_7_tmp[423:416] ^ syn_7_tmp[431:424] ^ 
      syn_7_tmp[439:432] ^ syn_7_tmp[447:440] ^ syn_7_tmp[455:448] ^ 
      syn_7_tmp[463:456] ^ syn_7_tmp[471:464] ^ syn_7_tmp[479:472] ^ 
      syn_7_tmp[487:480] ^ syn_7_tmp[495:488] ^ syn_7_tmp[503:496] ^ 
      syn_7_tmp[511:504] ^ syn_7_tmp[519:512] ^ syn_7_tmp[527:520] ^ 
      syn_7_tmp[535:528] ^ syn_7_tmp[543:536] ^ syn_7_tmp[551:544] ^ 
      syn_7_tmp[559:552] ^ syn_7_tmp[567:560] ^ syn_7_tmp[575:568] ^ 
      syn_7_tmp[583:576] ^ syn_7_tmp[591:584] ^ syn_7_tmp[599:592] ^ 
      syn_7_tmp[607:600] ^ syn_7_tmp[615:608] ^ syn_7_tmp[623:616] ^ 
      syn_7_tmp[631:624] ^ syn_7_tmp[639:632] ^ syn_7_tmp[647:640] ^ 
      syn_7_tmp[655:648] ^ syn_7_tmp[663:656] ^ syn_7_tmp[671:664] ^ 
      syn_7_tmp[679:672] ^ syn_7_tmp[687:680] ^ syn_7_tmp[695:688] ^ 
      syn_7_tmp[703:696] ^ syn_7_tmp[711:704] ^ syn_7_tmp[719:712] ^ 
      syn_7_tmp[727:720] ^ syn_7_tmp[735:728] ^ syn_7_tmp[743:736] ^ 
      syn_7_tmp[751:744] ^ syn_7_tmp[759:752] ^ syn_7_tmp[767:760] ^ 
      syn_7_tmp[775:768] ^ syn_7_tmp[783:776] ^ syn_7_tmp[791:784] ^ 
      syn_7_tmp[799:792] ^ syn_7_tmp[807:800] ^ syn_7_tmp[815:808] ^ 
      syn_7_tmp[823:816] ^ syn_7_tmp[831:824] ^ syn_7_tmp[839:832] ^ 
      syn_7_tmp[847:840] ^ syn_7_tmp[855:848] ^ syn_7_tmp[863:856] ^ 
      syn_7_tmp[871:864] ^ syn_7_tmp[879:872] ^ syn_7_tmp[887:880] ^ 
      syn_7_tmp[895:888] ^ syn_7_tmp[903:896] ^ syn_7_tmp[911:904] ^ 
      syn_7_tmp[919:912] ^ syn_7_tmp[927:920] ^ syn_7_tmp[935:928] ^ 
      syn_7_tmp[943:936] ^ syn_7_tmp[951:944] ^ syn_7_tmp[959:952] ^ 
      syn_7_tmp[967:960] ^ syn_7_tmp[975:968] ^ syn_7_tmp[983:976] ^ 
      syn_7_tmp[991:984] ^ syn_7_tmp[999:992] ^ syn_7_tmp[1007:1000] ^ 
      syn_7_tmp[1015:1008] ^ syn_7_tmp[1023:1016] ^ syn_7_tmp[1031:1024] ^ 
      syn_7_tmp[1039:1032] ^ syn_7_tmp[1047:1040] ^ syn_7_tmp[1055:1048] ^ 
      syn_7_tmp[1063:1056] ^ syn_7_tmp[1071:1064] ^ syn_7_tmp[1079:1072] ^ 
      syn_7_tmp[1087:1080] ^ syn_7_tmp[1095:1088] ^ syn_7_tmp[1103:1096] ^ 
      syn_7_tmp[1111:1104] ^ syn_7_tmp[1119:1112] ^ syn_7_tmp[1127:1120] ^ 
      syn_7_tmp[1135:1128] ^ syn_7_tmp[1143:1136] ^ syn_7_tmp[1151:1144] ^ 
      syn_7_tmp[1159:1152] ^ syn_7_tmp[1167:1160] ^ syn_7_tmp[1175:1168] ^ 
      syn_7_tmp[1183:1176] ^ syn_7_tmp[1191:1184] ^ syn_7_tmp[1199:1192] ^ 
      syn_7_tmp[1207:1200] ^ syn_7_tmp[1215:1208] ^ syn_7_tmp[1223:1216] ^ 
      syn_7_tmp[1231:1224] ^ syn_7_tmp[1239:1232] ^ syn_7_tmp[1247:1240] ^ 
      syn_7_tmp[1255:1248] ^ syn_7_tmp[1263:1256] ^ syn_7_tmp[1271:1264] ^ 
      syn_7_tmp[1279:1272] ^ syn_7_tmp[1287:1280] ^ syn_7_tmp[1295:1288] ^ 
      syn_7_tmp[1303:1296] ^ syn_7_tmp[1311:1304] ^ syn_7_tmp[1319:1312] ^ 
      syn_7_tmp[1327:1320] ^ syn_7_tmp[1335:1328] ^ syn_7_tmp[1343:1336] ^ 
      syn_7_tmp[1351:1344] ^ syn_7_tmp[1359:1352] ^ syn_7_tmp[1367:1360] ^ 
      syn_7_tmp[1375:1368] ^ syn_7_tmp[1383:1376] ^ syn_7_tmp[1391:1384] ^ 
      syn_7_tmp[1399:1392] ^ syn_7_tmp[1407:1400] ^ syn_7_tmp[1415:1408] ^ 
      syn_7_tmp[1423:1416] ^ syn_7_tmp[1431:1424] ^ syn_7_tmp[1439:1432] ^ 
      syn_7_tmp[1447:1440] ^ syn_7_tmp[1455:1448] ^ syn_7_tmp[1463:1456] ^ 
      syn_7_tmp[1471:1464] ^ syn_7_tmp[1479:1472] ^ syn_7_tmp[1487:1480] ^ 
      syn_7_tmp[1495:1488] ^ syn_7_tmp[1503:1496] ^ syn_7_tmp[1511:1504] ^ 
      syn_7_tmp[1519:1512] ^ syn_7_tmp[1527:1520] ^ syn_7_tmp[1535:1528] ^ 
      syn_7_tmp[1543:1536] ^ syn_7_tmp[1551:1544] ^ syn_7_tmp[1559:1552] ^ 
      syn_7_tmp[1567:1560] ^ syn_7_tmp[1575:1568] ^ syn_7_tmp[1583:1576] ^ 
      syn_7_tmp[1591:1584] ^ syn_7_tmp[1599:1592] ^ syn_7_tmp[1607:1600] ^ 
      syn_7_tmp[1615:1608] ^ syn_7_tmp[1623:1616] ^ syn_7_tmp[1631:1624] ^ 
      syn_7_tmp[1639:1632] ^ syn_7_tmp[1647:1640] ^ syn_7_tmp[1655:1648] ^ 
      syn_7_tmp[1663:1656] ^ syn_7_tmp[1671:1664] ^ syn_7_tmp[1679:1672] ^ 
      syn_7_tmp[1687:1680] ^ syn_7_tmp[1695:1688] ^ syn_7_tmp[1703:1696] ^ 
      syn_7_tmp[1711:1704] ^ syn_7_tmp[1719:1712] ^ syn_7_tmp[1727:1720] ^ 
      syn_7_tmp[1735:1728] ^ syn_7_tmp[1743:1736] ^ syn_7_tmp[1751:1744] ^ 
      syn_7_tmp[1759:1752] ^ syn_7_tmp[1767:1760] ^ syn_7_tmp[1775:1768] ^ 
      syn_7_tmp[1783:1776] ^ syn_7_tmp[1791:1784] ^ syn_7_tmp[1799:1792] ^ 
      syn_7_tmp[1807:1800] ^ syn_7_tmp[1815:1808] ^ syn_7_tmp[1823:1816] ^ 
      syn_7_tmp[1831:1824] ^ syn_7_tmp[1839:1832] ^ syn_7_tmp[1847:1840] ^ 
      syn_7_tmp[1855:1848] ^ syn_7_tmp[1863:1856] ^ syn_7_tmp[1871:1864] ^ 
      syn_7_tmp[1879:1872] ^ syn_7_tmp[1887:1880] ^ syn_7_tmp[1895:1888] ^ 
      syn_7_tmp[1903:1896] ^ syn_7_tmp[1911:1904] ^ syn_7_tmp[1919:1912] ^ 
      syn_7_tmp[1927:1920] ^ syn_7_tmp[1935:1928] ^ syn_7_tmp[1943:1936] ^ 
      syn_7_tmp[1951:1944] ^ syn_7_tmp[1959:1952] ^ syn_7_tmp[1967:1960] ^ 
      syn_7_tmp[1975:1968] ^ syn_7_tmp[1983:1976] ^ syn_7_tmp[1991:1984] ^ 
      syn_7_tmp[1999:1992] ^ syn_7_tmp[2007:2000] ^ syn_7_tmp[2015:2008] ^ 
      syn_7_tmp[2023:2016] ^ syn_7_tmp[2031:2024] ^ syn_7_tmp[2039:2032];

// syndrome 8
  wire [2039:0] syn_8_tmp;
  gf_mult_by_01 m2040 (.i(rx_data[7:0]),.o(syn_8_tmp[7:0]));
  gf_mult_by_1d m2041 (.i(rx_data[15:8]),.o(syn_8_tmp[15:8]));
  gf_mult_by_4c m2042 (.i(rx_data[23:16]),.o(syn_8_tmp[23:16]));
  gf_mult_by_8f m2043 (.i(rx_data[31:24]),.o(syn_8_tmp[31:24]));
  gf_mult_by_9d m2044 (.i(rx_data[39:32]),.o(syn_8_tmp[39:32]));
  gf_mult_by_6a m2045 (.i(rx_data[47:40]),.o(syn_8_tmp[47:40]));
  gf_mult_by_46 m2046 (.i(rx_data[55:48]),.o(syn_8_tmp[55:48]));
  gf_mult_by_5d m2047 (.i(rx_data[63:56]),.o(syn_8_tmp[63:56]));
  gf_mult_by_5f m2048 (.i(rx_data[71:64]),.o(syn_8_tmp[71:64]));
  gf_mult_by_65 m2049 (.i(rx_data[79:72]),.o(syn_8_tmp[79:72]));
  gf_mult_by_fd m2050 (.i(rx_data[87:80]),.o(syn_8_tmp[87:80]));
  gf_mult_by_fe m2051 (.i(rx_data[95:88]),.o(syn_8_tmp[95:88]));
  gf_mult_by_d9 m2052 (.i(rx_data[103:96]),.o(syn_8_tmp[103:96]));
  gf_mult_by_0d m2053 (.i(rx_data[111:104]),.o(syn_8_tmp[111:104]));
  gf_mult_by_81 m2054 (.i(rx_data[119:112]),.o(syn_8_tmp[119:112]));
  gf_mult_by_3b m2055 (.i(rx_data[127:120]),.o(syn_8_tmp[127:120]));
  gf_mult_by_85 m2056 (.i(rx_data[135:128]),.o(syn_8_tmp[135:128]));
  gf_mult_by_4f m2057 (.i(rx_data[143:136]),.o(syn_8_tmp[143:136]));
  gf_mult_by_a8 m2058 (.i(rx_data[151:144]),.o(syn_8_tmp[151:144]));
  gf_mult_by_49 m2059 (.i(rx_data[159:152]),.o(syn_8_tmp[159:152]));
  gf_mult_by_e6 m2060 (.i(rx_data[167:160]),.o(syn_8_tmp[167:160]));
  gf_mult_by_fc m2061 (.i(rx_data[175:168]),.o(syn_8_tmp[175:168]));
  gf_mult_by_e3 m2062 (.i(rx_data[183:176]),.o(syn_8_tmp[183:176]));
  gf_mult_by_95 m2063 (.i(rx_data[191:184]),.o(syn_8_tmp[191:184]));
  gf_mult_by_82 m2064 (.i(rx_data[199:192]),.o(syn_8_tmp[199:192]));
  gf_mult_by_1c m2065 (.i(rx_data[207:200]),.o(syn_8_tmp[207:200]));
  gf_mult_by_51 m2066 (.i(rx_data[215:208]),.o(syn_8_tmp[215:208]));
  gf_mult_by_c3 m2067 (.i(rx_data[223:216]),.o(syn_8_tmp[223:216]));
  gf_mult_by_12 m2068 (.i(rx_data[231:224]),.o(syn_8_tmp[231:224]));
  gf_mult_by_f7 m2069 (.i(rx_data[239:232]),.o(syn_8_tmp[239:232]));
  gf_mult_by_2c m2070 (.i(rx_data[247:240]),.o(syn_8_tmp[247:240]));
  gf_mult_by_1b m2071 (.i(rx_data[255:248]),.o(syn_8_tmp[255:248]));
  gf_mult_by_02 m2072 (.i(rx_data[263:256]),.o(syn_8_tmp[263:256]));
  gf_mult_by_3a m2073 (.i(rx_data[271:264]),.o(syn_8_tmp[271:264]));
  gf_mult_by_98 m2074 (.i(rx_data[279:272]),.o(syn_8_tmp[279:272]));
  gf_mult_by_03 m2075 (.i(rx_data[287:280]),.o(syn_8_tmp[287:280]));
  gf_mult_by_27 m2076 (.i(rx_data[295:288]),.o(syn_8_tmp[295:288]));
  gf_mult_by_d4 m2077 (.i(rx_data[303:296]),.o(syn_8_tmp[303:296]));
  gf_mult_by_8c m2078 (.i(rx_data[311:304]),.o(syn_8_tmp[311:304]));
  gf_mult_by_ba m2079 (.i(rx_data[319:312]),.o(syn_8_tmp[319:312]));
  gf_mult_by_be m2080 (.i(rx_data[327:320]),.o(syn_8_tmp[327:320]));
  gf_mult_by_ca m2081 (.i(rx_data[335:328]),.o(syn_8_tmp[335:328]));
  gf_mult_by_e7 m2082 (.i(rx_data[343:336]),.o(syn_8_tmp[343:336]));
  gf_mult_by_e1 m2083 (.i(rx_data[351:344]),.o(syn_8_tmp[351:344]));
  gf_mult_by_af m2084 (.i(rx_data[359:352]),.o(syn_8_tmp[359:352]));
  gf_mult_by_1a m2085 (.i(rx_data[367:360]),.o(syn_8_tmp[367:360]));
  gf_mult_by_1f m2086 (.i(rx_data[375:368]),.o(syn_8_tmp[375:368]));
  gf_mult_by_76 m2087 (.i(rx_data[383:376]),.o(syn_8_tmp[383:376]));
  gf_mult_by_17 m2088 (.i(rx_data[391:384]),.o(syn_8_tmp[391:384]));
  gf_mult_by_9e m2089 (.i(rx_data[399:392]),.o(syn_8_tmp[399:392]));
  gf_mult_by_4d m2090 (.i(rx_data[407:400]),.o(syn_8_tmp[407:400]));
  gf_mult_by_92 m2091 (.i(rx_data[415:408]),.o(syn_8_tmp[415:408]));
  gf_mult_by_d1 m2092 (.i(rx_data[423:416]),.o(syn_8_tmp[423:416]));
  gf_mult_by_e5 m2093 (.i(rx_data[431:424]),.o(syn_8_tmp[431:424]));
  gf_mult_by_db m2094 (.i(rx_data[439:432]),.o(syn_8_tmp[439:432]));
  gf_mult_by_37 m2095 (.i(rx_data[447:440]),.o(syn_8_tmp[447:440]));
  gf_mult_by_19 m2096 (.i(rx_data[455:448]),.o(syn_8_tmp[455:448]));
  gf_mult_by_38 m2097 (.i(rx_data[463:456]),.o(syn_8_tmp[463:456]));
  gf_mult_by_a2 m2098 (.i(rx_data[471:464]),.o(syn_8_tmp[471:464]));
  gf_mult_by_9b m2099 (.i(rx_data[479:472]),.o(syn_8_tmp[479:472]));
  gf_mult_by_24 m2100 (.i(rx_data[487:480]),.o(syn_8_tmp[487:480]));
  gf_mult_by_f3 m2101 (.i(rx_data[495:488]),.o(syn_8_tmp[495:488]));
  gf_mult_by_58 m2102 (.i(rx_data[503:496]),.o(syn_8_tmp[503:496]));
  gf_mult_by_36 m2103 (.i(rx_data[511:504]),.o(syn_8_tmp[511:504]));
  gf_mult_by_04 m2104 (.i(rx_data[519:512]),.o(syn_8_tmp[519:512]));
  gf_mult_by_74 m2105 (.i(rx_data[527:520]),.o(syn_8_tmp[527:520]));
  gf_mult_by_2d m2106 (.i(rx_data[535:528]),.o(syn_8_tmp[535:528]));
  gf_mult_by_06 m2107 (.i(rx_data[543:536]),.o(syn_8_tmp[543:536]));
  gf_mult_by_4e m2108 (.i(rx_data[551:544]),.o(syn_8_tmp[551:544]));
  gf_mult_by_b5 m2109 (.i(rx_data[559:552]),.o(syn_8_tmp[559:552]));
  gf_mult_by_05 m2110 (.i(rx_data[567:560]),.o(syn_8_tmp[567:560]));
  gf_mult_by_69 m2111 (.i(rx_data[575:568]),.o(syn_8_tmp[575:568]));
  gf_mult_by_61 m2112 (.i(rx_data[583:576]),.o(syn_8_tmp[583:576]));
  gf_mult_by_89 m2113 (.i(rx_data[591:584]),.o(syn_8_tmp[591:584]));
  gf_mult_by_d3 m2114 (.i(rx_data[599:592]),.o(syn_8_tmp[599:592]));
  gf_mult_by_df m2115 (.i(rx_data[607:600]),.o(syn_8_tmp[607:600]));
  gf_mult_by_43 m2116 (.i(rx_data[615:608]),.o(syn_8_tmp[615:608]));
  gf_mult_by_34 m2117 (.i(rx_data[623:616]),.o(syn_8_tmp[623:616]));
  gf_mult_by_3e m2118 (.i(rx_data[631:624]),.o(syn_8_tmp[631:624]));
  gf_mult_by_ec m2119 (.i(rx_data[639:632]),.o(syn_8_tmp[639:632]));
  gf_mult_by_2e m2120 (.i(rx_data[647:640]),.o(syn_8_tmp[647:640]));
  gf_mult_by_21 m2121 (.i(rx_data[655:648]),.o(syn_8_tmp[655:648]));
  gf_mult_by_9a m2122 (.i(rx_data[663:656]),.o(syn_8_tmp[663:656]));
  gf_mult_by_39 m2123 (.i(rx_data[671:664]),.o(syn_8_tmp[671:664]));
  gf_mult_by_bf m2124 (.i(rx_data[679:672]),.o(syn_8_tmp[679:672]));
  gf_mult_by_d7 m2125 (.i(rx_data[687:680]),.o(syn_8_tmp[687:680]));
  gf_mult_by_ab m2126 (.i(rx_data[695:688]),.o(syn_8_tmp[695:688]));
  gf_mult_by_6e m2127 (.i(rx_data[703:696]),.o(syn_8_tmp[703:696]));
  gf_mult_by_32 m2128 (.i(rx_data[711:704]),.o(syn_8_tmp[711:704]));
  gf_mult_by_70 m2129 (.i(rx_data[719:712]),.o(syn_8_tmp[719:712]));
  gf_mult_by_59 m2130 (.i(rx_data[727:720]),.o(syn_8_tmp[727:720]));
  gf_mult_by_2b m2131 (.i(rx_data[735:728]),.o(syn_8_tmp[735:728]));
  gf_mult_by_48 m2132 (.i(rx_data[743:736]),.o(syn_8_tmp[743:736]));
  gf_mult_by_fb m2133 (.i(rx_data[751:744]),.o(syn_8_tmp[751:744]));
  gf_mult_by_b0 m2134 (.i(rx_data[759:752]),.o(syn_8_tmp[759:752]));
  gf_mult_by_6c m2135 (.i(rx_data[767:760]),.o(syn_8_tmp[767:760]));
  gf_mult_by_08 m2136 (.i(rx_data[775:768]),.o(syn_8_tmp[775:768]));
  gf_mult_by_e8 m2137 (.i(rx_data[783:776]),.o(syn_8_tmp[783:776]));
  gf_mult_by_5a m2138 (.i(rx_data[791:784]),.o(syn_8_tmp[791:784]));
  gf_mult_by_0c m2139 (.i(rx_data[799:792]),.o(syn_8_tmp[799:792]));
  gf_mult_by_9c m2140 (.i(rx_data[807:800]),.o(syn_8_tmp[807:800]));
  gf_mult_by_77 m2141 (.i(rx_data[815:808]),.o(syn_8_tmp[815:808]));
  gf_mult_by_0a m2142 (.i(rx_data[823:816]),.o(syn_8_tmp[823:816]));
  gf_mult_by_d2 m2143 (.i(rx_data[831:824]),.o(syn_8_tmp[831:824]));
  gf_mult_by_c2 m2144 (.i(rx_data[839:832]),.o(syn_8_tmp[839:832]));
  gf_mult_by_0f m2145 (.i(rx_data[847:840]),.o(syn_8_tmp[847:840]));
  gf_mult_by_bb m2146 (.i(rx_data[855:848]),.o(syn_8_tmp[855:848]));
  gf_mult_by_a3 m2147 (.i(rx_data[863:856]),.o(syn_8_tmp[863:856]));
  gf_mult_by_86 m2148 (.i(rx_data[871:864]),.o(syn_8_tmp[871:864]));
  gf_mult_by_68 m2149 (.i(rx_data[879:872]),.o(syn_8_tmp[879:872]));
  gf_mult_by_7c m2150 (.i(rx_data[887:880]),.o(syn_8_tmp[887:880]));
  gf_mult_by_c5 m2151 (.i(rx_data[895:888]),.o(syn_8_tmp[895:888]));
  gf_mult_by_5c m2152 (.i(rx_data[903:896]),.o(syn_8_tmp[903:896]));
  gf_mult_by_42 m2153 (.i(rx_data[911:904]),.o(syn_8_tmp[911:904]));
  gf_mult_by_29 m2154 (.i(rx_data[919:912]),.o(syn_8_tmp[919:912]));
  gf_mult_by_72 m2155 (.i(rx_data[927:920]),.o(syn_8_tmp[927:920]));
  gf_mult_by_63 m2156 (.i(rx_data[935:928]),.o(syn_8_tmp[935:928]));
  gf_mult_by_b3 m2157 (.i(rx_data[943:936]),.o(syn_8_tmp[943:936]));
  gf_mult_by_4b m2158 (.i(rx_data[951:944]),.o(syn_8_tmp[951:944]));
  gf_mult_by_dc m2159 (.i(rx_data[959:952]),.o(syn_8_tmp[959:952]));
  gf_mult_by_64 m2160 (.i(rx_data[967:960]),.o(syn_8_tmp[967:960]));
  gf_mult_by_e0 m2161 (.i(rx_data[975:968]),.o(syn_8_tmp[975:968]));
  gf_mult_by_b2 m2162 (.i(rx_data[983:976]),.o(syn_8_tmp[983:976]));
  gf_mult_by_56 m2163 (.i(rx_data[991:984]),.o(syn_8_tmp[991:984]));
  gf_mult_by_90 m2164 (.i(rx_data[999:992]),.o(syn_8_tmp[999:992]));
  gf_mult_by_eb m2165 (.i(rx_data[1007:1000]),.o(syn_8_tmp[1007:1000]));
  gf_mult_by_7d m2166 (.i(rx_data[1015:1008]),.o(syn_8_tmp[1015:1008]));
  gf_mult_by_d8 m2167 (.i(rx_data[1023:1016]),.o(syn_8_tmp[1023:1016]));
  gf_mult_by_10 m2168 (.i(rx_data[1031:1024]),.o(syn_8_tmp[1031:1024]));
  gf_mult_by_cd m2169 (.i(rx_data[1039:1032]),.o(syn_8_tmp[1039:1032]));
  gf_mult_by_b4 m2170 (.i(rx_data[1047:1040]),.o(syn_8_tmp[1047:1040]));
  gf_mult_by_18 m2171 (.i(rx_data[1055:1048]),.o(syn_8_tmp[1055:1048]));
  gf_mult_by_25 m2172 (.i(rx_data[1063:1056]),.o(syn_8_tmp[1063:1056]));
  gf_mult_by_ee m2173 (.i(rx_data[1071:1064]),.o(syn_8_tmp[1071:1064]));
  gf_mult_by_14 m2174 (.i(rx_data[1079:1072]),.o(syn_8_tmp[1079:1072]));
  gf_mult_by_b9 m2175 (.i(rx_data[1087:1080]),.o(syn_8_tmp[1087:1080]));
  gf_mult_by_99 m2176 (.i(rx_data[1095:1088]),.o(syn_8_tmp[1095:1088]));
  gf_mult_by_1e m2177 (.i(rx_data[1103:1096]),.o(syn_8_tmp[1103:1096]));
  gf_mult_by_6b m2178 (.i(rx_data[1111:1104]),.o(syn_8_tmp[1111:1104]));
  gf_mult_by_5b m2179 (.i(rx_data[1119:1112]),.o(syn_8_tmp[1119:1112]));
  gf_mult_by_11 m2180 (.i(rx_data[1127:1120]),.o(syn_8_tmp[1127:1120]));
  gf_mult_by_d0 m2181 (.i(rx_data[1135:1128]),.o(syn_8_tmp[1135:1128]));
  gf_mult_by_f8 m2182 (.i(rx_data[1143:1136]),.o(syn_8_tmp[1143:1136]));
  gf_mult_by_97 m2183 (.i(rx_data[1151:1144]),.o(syn_8_tmp[1151:1144]));
  gf_mult_by_b8 m2184 (.i(rx_data[1159:1152]),.o(syn_8_tmp[1159:1152]));
  gf_mult_by_84 m2185 (.i(rx_data[1167:1160]),.o(syn_8_tmp[1167:1160]));
  gf_mult_by_52 m2186 (.i(rx_data[1175:1168]),.o(syn_8_tmp[1175:1168]));
  gf_mult_by_e4 m2187 (.i(rx_data[1183:1176]),.o(syn_8_tmp[1183:1176]));
  gf_mult_by_c6 m2188 (.i(rx_data[1191:1184]),.o(syn_8_tmp[1191:1184]));
  gf_mult_by_7b m2189 (.i(rx_data[1199:1192]),.o(syn_8_tmp[1199:1192]));
  gf_mult_by_96 m2190 (.i(rx_data[1207:1200]),.o(syn_8_tmp[1207:1200]));
  gf_mult_by_a5 m2191 (.i(rx_data[1215:1208]),.o(syn_8_tmp[1215:1208]));
  gf_mult_by_c8 m2192 (.i(rx_data[1223:1216]),.o(syn_8_tmp[1223:1216]));
  gf_mult_by_dd m2193 (.i(rx_data[1231:1224]),.o(syn_8_tmp[1231:1224]));
  gf_mult_by_79 m2194 (.i(rx_data[1239:1232]),.o(syn_8_tmp[1239:1232]));
  gf_mult_by_ac m2195 (.i(rx_data[1247:1240]),.o(syn_8_tmp[1247:1240]));
  gf_mult_by_3d m2196 (.i(rx_data[1255:1248]),.o(syn_8_tmp[1255:1248]));
  gf_mult_by_cb m2197 (.i(rx_data[1263:1256]),.o(syn_8_tmp[1263:1256]));
  gf_mult_by_fa m2198 (.i(rx_data[1271:1264]),.o(syn_8_tmp[1271:1264]));
  gf_mult_by_ad m2199 (.i(rx_data[1279:1272]),.o(syn_8_tmp[1279:1272]));
  gf_mult_by_20 m2200 (.i(rx_data[1287:1280]),.o(syn_8_tmp[1287:1280]));
  gf_mult_by_87 m2201 (.i(rx_data[1295:1288]),.o(syn_8_tmp[1295:1288]));
  gf_mult_by_75 m2202 (.i(rx_data[1303:1296]),.o(syn_8_tmp[1303:1296]));
  gf_mult_by_30 m2203 (.i(rx_data[1311:1304]),.o(syn_8_tmp[1311:1304]));
  gf_mult_by_4a m2204 (.i(rx_data[1319:1312]),.o(syn_8_tmp[1319:1312]));
  gf_mult_by_c1 m2205 (.i(rx_data[1327:1320]),.o(syn_8_tmp[1327:1320]));
  gf_mult_by_28 m2206 (.i(rx_data[1335:1328]),.o(syn_8_tmp[1335:1328]));
  gf_mult_by_6f m2207 (.i(rx_data[1343:1336]),.o(syn_8_tmp[1343:1336]));
  gf_mult_by_2f m2208 (.i(rx_data[1351:1344]),.o(syn_8_tmp[1351:1344]));
  gf_mult_by_3c m2209 (.i(rx_data[1359:1352]),.o(syn_8_tmp[1359:1352]));
  gf_mult_by_d6 m2210 (.i(rx_data[1367:1360]),.o(syn_8_tmp[1367:1360]));
  gf_mult_by_b6 m2211 (.i(rx_data[1375:1368]),.o(syn_8_tmp[1375:1368]));
  gf_mult_by_22 m2212 (.i(rx_data[1383:1376]),.o(syn_8_tmp[1383:1376]));
  gf_mult_by_bd m2213 (.i(rx_data[1391:1384]),.o(syn_8_tmp[1391:1384]));
  gf_mult_by_ed m2214 (.i(rx_data[1399:1392]),.o(syn_8_tmp[1399:1392]));
  gf_mult_by_33 m2215 (.i(rx_data[1407:1400]),.o(syn_8_tmp[1407:1400]));
  gf_mult_by_6d m2216 (.i(rx_data[1415:1408]),.o(syn_8_tmp[1415:1408]));
  gf_mult_by_15 m2217 (.i(rx_data[1423:1416]),.o(syn_8_tmp[1423:1416]));
  gf_mult_by_a4 m2218 (.i(rx_data[1431:1424]),.o(syn_8_tmp[1431:1424]));
  gf_mult_by_d5 m2219 (.i(rx_data[1439:1432]),.o(syn_8_tmp[1439:1432]));
  gf_mult_by_91 m2220 (.i(rx_data[1447:1440]),.o(syn_8_tmp[1447:1440]));
  gf_mult_by_f6 m2221 (.i(rx_data[1455:1448]),.o(syn_8_tmp[1455:1448]));
  gf_mult_by_31 m2222 (.i(rx_data[1463:1456]),.o(syn_8_tmp[1463:1456]));
  gf_mult_by_57 m2223 (.i(rx_data[1471:1464]),.o(syn_8_tmp[1471:1464]));
  gf_mult_by_8d m2224 (.i(rx_data[1479:1472]),.o(syn_8_tmp[1479:1472]));
  gf_mult_by_a7 m2225 (.i(rx_data[1487:1480]),.o(syn_8_tmp[1487:1480]));
  gf_mult_by_f2 m2226 (.i(rx_data[1495:1488]),.o(syn_8_tmp[1495:1488]));
  gf_mult_by_45 m2227 (.i(rx_data[1503:1496]),.o(syn_8_tmp[1503:1496]));
  gf_mult_by_7a m2228 (.i(rx_data[1511:1504]),.o(syn_8_tmp[1511:1504]));
  gf_mult_by_8b m2229 (.i(rx_data[1519:1512]),.o(syn_8_tmp[1519:1512]));
  gf_mult_by_e9 m2230 (.i(rx_data[1527:1520]),.o(syn_8_tmp[1527:1520]));
  gf_mult_by_47 m2231 (.i(rx_data[1535:1528]),.o(syn_8_tmp[1535:1528]));
  gf_mult_by_40 m2232 (.i(rx_data[1543:1536]),.o(syn_8_tmp[1543:1536]));
  gf_mult_by_13 m2233 (.i(rx_data[1551:1544]),.o(syn_8_tmp[1551:1544]));
  gf_mult_by_ea m2234 (.i(rx_data[1559:1552]),.o(syn_8_tmp[1559:1552]));
  gf_mult_by_60 m2235 (.i(rx_data[1567:1560]),.o(syn_8_tmp[1567:1560]));
  gf_mult_by_94 m2236 (.i(rx_data[1575:1568]),.o(syn_8_tmp[1575:1568]));
  gf_mult_by_9f m2237 (.i(rx_data[1583:1576]),.o(syn_8_tmp[1583:1576]));
  gf_mult_by_50 m2238 (.i(rx_data[1591:1584]),.o(syn_8_tmp[1591:1584]));
  gf_mult_by_de m2239 (.i(rx_data[1599:1592]),.o(syn_8_tmp[1599:1592]));
  gf_mult_by_5e m2240 (.i(rx_data[1607:1600]),.o(syn_8_tmp[1607:1600]));
  gf_mult_by_78 m2241 (.i(rx_data[1615:1608]),.o(syn_8_tmp[1615:1608]));
  gf_mult_by_b1 m2242 (.i(rx_data[1623:1616]),.o(syn_8_tmp[1623:1616]));
  gf_mult_by_71 m2243 (.i(rx_data[1631:1624]),.o(syn_8_tmp[1631:1624]));
  gf_mult_by_44 m2244 (.i(rx_data[1639:1632]),.o(syn_8_tmp[1639:1632]));
  gf_mult_by_67 m2245 (.i(rx_data[1647:1640]),.o(syn_8_tmp[1647:1640]));
  gf_mult_by_c7 m2246 (.i(rx_data[1655:1648]),.o(syn_8_tmp[1655:1648]));
  gf_mult_by_66 m2247 (.i(rx_data[1663:1656]),.o(syn_8_tmp[1663:1656]));
  gf_mult_by_da m2248 (.i(rx_data[1671:1664]),.o(syn_8_tmp[1671:1664]));
  gf_mult_by_2a m2249 (.i(rx_data[1679:1672]),.o(syn_8_tmp[1679:1672]));
  gf_mult_by_55 m2250 (.i(rx_data[1687:1680]),.o(syn_8_tmp[1687:1680]));
  gf_mult_by_b7 m2251 (.i(rx_data[1695:1688]),.o(syn_8_tmp[1695:1688]));
  gf_mult_by_3f m2252 (.i(rx_data[1703:1696]),.o(syn_8_tmp[1703:1696]));
  gf_mult_by_f1 m2253 (.i(rx_data[1711:1704]),.o(syn_8_tmp[1711:1704]));
  gf_mult_by_62 m2254 (.i(rx_data[1719:1712]),.o(syn_8_tmp[1719:1712]));
  gf_mult_by_ae m2255 (.i(rx_data[1727:1720]),.o(syn_8_tmp[1727:1720]));
  gf_mult_by_07 m2256 (.i(rx_data[1735:1728]),.o(syn_8_tmp[1735:1728]));
  gf_mult_by_53 m2257 (.i(rx_data[1743:1736]),.o(syn_8_tmp[1743:1736]));
  gf_mult_by_f9 m2258 (.i(rx_data[1751:1744]),.o(syn_8_tmp[1751:1744]));
  gf_mult_by_8a m2259 (.i(rx_data[1759:1752]),.o(syn_8_tmp[1759:1752]));
  gf_mult_by_f4 m2260 (.i(rx_data[1767:1760]),.o(syn_8_tmp[1767:1760]));
  gf_mult_by_0b m2261 (.i(rx_data[1775:1768]),.o(syn_8_tmp[1775:1768]));
  gf_mult_by_cf m2262 (.i(rx_data[1783:1776]),.o(syn_8_tmp[1783:1776]));
  gf_mult_by_8e m2263 (.i(rx_data[1791:1784]),.o(syn_8_tmp[1791:1784]));
  gf_mult_by_80 m2264 (.i(rx_data[1799:1792]),.o(syn_8_tmp[1799:1792]));
  gf_mult_by_26 m2265 (.i(rx_data[1807:1800]),.o(syn_8_tmp[1807:1800]));
  gf_mult_by_c9 m2266 (.i(rx_data[1815:1808]),.o(syn_8_tmp[1815:1808]));
  gf_mult_by_c0 m2267 (.i(rx_data[1823:1816]),.o(syn_8_tmp[1823:1816]));
  gf_mult_by_35 m2268 (.i(rx_data[1831:1824]),.o(syn_8_tmp[1831:1824]));
  gf_mult_by_23 m2269 (.i(rx_data[1839:1832]),.o(syn_8_tmp[1839:1832]));
  gf_mult_by_a0 m2270 (.i(rx_data[1847:1840]),.o(syn_8_tmp[1847:1840]));
  gf_mult_by_a1 m2271 (.i(rx_data[1855:1848]),.o(syn_8_tmp[1855:1848]));
  gf_mult_by_bc m2272 (.i(rx_data[1863:1856]),.o(syn_8_tmp[1863:1856]));
  gf_mult_by_f0 m2273 (.i(rx_data[1871:1864]),.o(syn_8_tmp[1871:1864]));
  gf_mult_by_7f m2274 (.i(rx_data[1879:1872]),.o(syn_8_tmp[1879:1872]));
  gf_mult_by_e2 m2275 (.i(rx_data[1887:1880]),.o(syn_8_tmp[1887:1880]));
  gf_mult_by_88 m2276 (.i(rx_data[1895:1888]),.o(syn_8_tmp[1895:1888]));
  gf_mult_by_ce m2277 (.i(rx_data[1903:1896]),.o(syn_8_tmp[1903:1896]));
  gf_mult_by_93 m2278 (.i(rx_data[1911:1904]),.o(syn_8_tmp[1911:1904]));
  gf_mult_by_cc m2279 (.i(rx_data[1919:1912]),.o(syn_8_tmp[1919:1912]));
  gf_mult_by_a9 m2280 (.i(rx_data[1927:1920]),.o(syn_8_tmp[1927:1920]));
  gf_mult_by_54 m2281 (.i(rx_data[1935:1928]),.o(syn_8_tmp[1935:1928]));
  gf_mult_by_aa m2282 (.i(rx_data[1943:1936]),.o(syn_8_tmp[1943:1936]));
  gf_mult_by_73 m2283 (.i(rx_data[1951:1944]),.o(syn_8_tmp[1951:1944]));
  gf_mult_by_7e m2284 (.i(rx_data[1959:1952]),.o(syn_8_tmp[1959:1952]));
  gf_mult_by_ff m2285 (.i(rx_data[1967:1960]),.o(syn_8_tmp[1967:1960]));
  gf_mult_by_c4 m2286 (.i(rx_data[1975:1968]),.o(syn_8_tmp[1975:1968]));
  gf_mult_by_41 m2287 (.i(rx_data[1983:1976]),.o(syn_8_tmp[1983:1976]));
  gf_mult_by_0e m2288 (.i(rx_data[1991:1984]),.o(syn_8_tmp[1991:1984]));
  gf_mult_by_a6 m2289 (.i(rx_data[1999:1992]),.o(syn_8_tmp[1999:1992]));
  gf_mult_by_ef m2290 (.i(rx_data[2007:2000]),.o(syn_8_tmp[2007:2000]));
  gf_mult_by_09 m2291 (.i(rx_data[2015:2008]),.o(syn_8_tmp[2015:2008]));
  gf_mult_by_f5 m2292 (.i(rx_data[2023:2016]),.o(syn_8_tmp[2023:2016]));
  gf_mult_by_16 m2293 (.i(rx_data[2031:2024]),.o(syn_8_tmp[2031:2024]));
  gf_mult_by_83 m2294 (.i(rx_data[2039:2032]),.o(syn_8_tmp[2039:2032]));
  assign syndrome[71:64] =
      syn_8_tmp[7:0] ^ syn_8_tmp[15:8] ^ syn_8_tmp[23:16] ^ 
      syn_8_tmp[31:24] ^ syn_8_tmp[39:32] ^ syn_8_tmp[47:40] ^ 
      syn_8_tmp[55:48] ^ syn_8_tmp[63:56] ^ syn_8_tmp[71:64] ^ 
      syn_8_tmp[79:72] ^ syn_8_tmp[87:80] ^ syn_8_tmp[95:88] ^ 
      syn_8_tmp[103:96] ^ syn_8_tmp[111:104] ^ syn_8_tmp[119:112] ^ 
      syn_8_tmp[127:120] ^ syn_8_tmp[135:128] ^ syn_8_tmp[143:136] ^ 
      syn_8_tmp[151:144] ^ syn_8_tmp[159:152] ^ syn_8_tmp[167:160] ^ 
      syn_8_tmp[175:168] ^ syn_8_tmp[183:176] ^ syn_8_tmp[191:184] ^ 
      syn_8_tmp[199:192] ^ syn_8_tmp[207:200] ^ syn_8_tmp[215:208] ^ 
      syn_8_tmp[223:216] ^ syn_8_tmp[231:224] ^ syn_8_tmp[239:232] ^ 
      syn_8_tmp[247:240] ^ syn_8_tmp[255:248] ^ syn_8_tmp[263:256] ^ 
      syn_8_tmp[271:264] ^ syn_8_tmp[279:272] ^ syn_8_tmp[287:280] ^ 
      syn_8_tmp[295:288] ^ syn_8_tmp[303:296] ^ syn_8_tmp[311:304] ^ 
      syn_8_tmp[319:312] ^ syn_8_tmp[327:320] ^ syn_8_tmp[335:328] ^ 
      syn_8_tmp[343:336] ^ syn_8_tmp[351:344] ^ syn_8_tmp[359:352] ^ 
      syn_8_tmp[367:360] ^ syn_8_tmp[375:368] ^ syn_8_tmp[383:376] ^ 
      syn_8_tmp[391:384] ^ syn_8_tmp[399:392] ^ syn_8_tmp[407:400] ^ 
      syn_8_tmp[415:408] ^ syn_8_tmp[423:416] ^ syn_8_tmp[431:424] ^ 
      syn_8_tmp[439:432] ^ syn_8_tmp[447:440] ^ syn_8_tmp[455:448] ^ 
      syn_8_tmp[463:456] ^ syn_8_tmp[471:464] ^ syn_8_tmp[479:472] ^ 
      syn_8_tmp[487:480] ^ syn_8_tmp[495:488] ^ syn_8_tmp[503:496] ^ 
      syn_8_tmp[511:504] ^ syn_8_tmp[519:512] ^ syn_8_tmp[527:520] ^ 
      syn_8_tmp[535:528] ^ syn_8_tmp[543:536] ^ syn_8_tmp[551:544] ^ 
      syn_8_tmp[559:552] ^ syn_8_tmp[567:560] ^ syn_8_tmp[575:568] ^ 
      syn_8_tmp[583:576] ^ syn_8_tmp[591:584] ^ syn_8_tmp[599:592] ^ 
      syn_8_tmp[607:600] ^ syn_8_tmp[615:608] ^ syn_8_tmp[623:616] ^ 
      syn_8_tmp[631:624] ^ syn_8_tmp[639:632] ^ syn_8_tmp[647:640] ^ 
      syn_8_tmp[655:648] ^ syn_8_tmp[663:656] ^ syn_8_tmp[671:664] ^ 
      syn_8_tmp[679:672] ^ syn_8_tmp[687:680] ^ syn_8_tmp[695:688] ^ 
      syn_8_tmp[703:696] ^ syn_8_tmp[711:704] ^ syn_8_tmp[719:712] ^ 
      syn_8_tmp[727:720] ^ syn_8_tmp[735:728] ^ syn_8_tmp[743:736] ^ 
      syn_8_tmp[751:744] ^ syn_8_tmp[759:752] ^ syn_8_tmp[767:760] ^ 
      syn_8_tmp[775:768] ^ syn_8_tmp[783:776] ^ syn_8_tmp[791:784] ^ 
      syn_8_tmp[799:792] ^ syn_8_tmp[807:800] ^ syn_8_tmp[815:808] ^ 
      syn_8_tmp[823:816] ^ syn_8_tmp[831:824] ^ syn_8_tmp[839:832] ^ 
      syn_8_tmp[847:840] ^ syn_8_tmp[855:848] ^ syn_8_tmp[863:856] ^ 
      syn_8_tmp[871:864] ^ syn_8_tmp[879:872] ^ syn_8_tmp[887:880] ^ 
      syn_8_tmp[895:888] ^ syn_8_tmp[903:896] ^ syn_8_tmp[911:904] ^ 
      syn_8_tmp[919:912] ^ syn_8_tmp[927:920] ^ syn_8_tmp[935:928] ^ 
      syn_8_tmp[943:936] ^ syn_8_tmp[951:944] ^ syn_8_tmp[959:952] ^ 
      syn_8_tmp[967:960] ^ syn_8_tmp[975:968] ^ syn_8_tmp[983:976] ^ 
      syn_8_tmp[991:984] ^ syn_8_tmp[999:992] ^ syn_8_tmp[1007:1000] ^ 
      syn_8_tmp[1015:1008] ^ syn_8_tmp[1023:1016] ^ syn_8_tmp[1031:1024] ^ 
      syn_8_tmp[1039:1032] ^ syn_8_tmp[1047:1040] ^ syn_8_tmp[1055:1048] ^ 
      syn_8_tmp[1063:1056] ^ syn_8_tmp[1071:1064] ^ syn_8_tmp[1079:1072] ^ 
      syn_8_tmp[1087:1080] ^ syn_8_tmp[1095:1088] ^ syn_8_tmp[1103:1096] ^ 
      syn_8_tmp[1111:1104] ^ syn_8_tmp[1119:1112] ^ syn_8_tmp[1127:1120] ^ 
      syn_8_tmp[1135:1128] ^ syn_8_tmp[1143:1136] ^ syn_8_tmp[1151:1144] ^ 
      syn_8_tmp[1159:1152] ^ syn_8_tmp[1167:1160] ^ syn_8_tmp[1175:1168] ^ 
      syn_8_tmp[1183:1176] ^ syn_8_tmp[1191:1184] ^ syn_8_tmp[1199:1192] ^ 
      syn_8_tmp[1207:1200] ^ syn_8_tmp[1215:1208] ^ syn_8_tmp[1223:1216] ^ 
      syn_8_tmp[1231:1224] ^ syn_8_tmp[1239:1232] ^ syn_8_tmp[1247:1240] ^ 
      syn_8_tmp[1255:1248] ^ syn_8_tmp[1263:1256] ^ syn_8_tmp[1271:1264] ^ 
      syn_8_tmp[1279:1272] ^ syn_8_tmp[1287:1280] ^ syn_8_tmp[1295:1288] ^ 
      syn_8_tmp[1303:1296] ^ syn_8_tmp[1311:1304] ^ syn_8_tmp[1319:1312] ^ 
      syn_8_tmp[1327:1320] ^ syn_8_tmp[1335:1328] ^ syn_8_tmp[1343:1336] ^ 
      syn_8_tmp[1351:1344] ^ syn_8_tmp[1359:1352] ^ syn_8_tmp[1367:1360] ^ 
      syn_8_tmp[1375:1368] ^ syn_8_tmp[1383:1376] ^ syn_8_tmp[1391:1384] ^ 
      syn_8_tmp[1399:1392] ^ syn_8_tmp[1407:1400] ^ syn_8_tmp[1415:1408] ^ 
      syn_8_tmp[1423:1416] ^ syn_8_tmp[1431:1424] ^ syn_8_tmp[1439:1432] ^ 
      syn_8_tmp[1447:1440] ^ syn_8_tmp[1455:1448] ^ syn_8_tmp[1463:1456] ^ 
      syn_8_tmp[1471:1464] ^ syn_8_tmp[1479:1472] ^ syn_8_tmp[1487:1480] ^ 
      syn_8_tmp[1495:1488] ^ syn_8_tmp[1503:1496] ^ syn_8_tmp[1511:1504] ^ 
      syn_8_tmp[1519:1512] ^ syn_8_tmp[1527:1520] ^ syn_8_tmp[1535:1528] ^ 
      syn_8_tmp[1543:1536] ^ syn_8_tmp[1551:1544] ^ syn_8_tmp[1559:1552] ^ 
      syn_8_tmp[1567:1560] ^ syn_8_tmp[1575:1568] ^ syn_8_tmp[1583:1576] ^ 
      syn_8_tmp[1591:1584] ^ syn_8_tmp[1599:1592] ^ syn_8_tmp[1607:1600] ^ 
      syn_8_tmp[1615:1608] ^ syn_8_tmp[1623:1616] ^ syn_8_tmp[1631:1624] ^ 
      syn_8_tmp[1639:1632] ^ syn_8_tmp[1647:1640] ^ syn_8_tmp[1655:1648] ^ 
      syn_8_tmp[1663:1656] ^ syn_8_tmp[1671:1664] ^ syn_8_tmp[1679:1672] ^ 
      syn_8_tmp[1687:1680] ^ syn_8_tmp[1695:1688] ^ syn_8_tmp[1703:1696] ^ 
      syn_8_tmp[1711:1704] ^ syn_8_tmp[1719:1712] ^ syn_8_tmp[1727:1720] ^ 
      syn_8_tmp[1735:1728] ^ syn_8_tmp[1743:1736] ^ syn_8_tmp[1751:1744] ^ 
      syn_8_tmp[1759:1752] ^ syn_8_tmp[1767:1760] ^ syn_8_tmp[1775:1768] ^ 
      syn_8_tmp[1783:1776] ^ syn_8_tmp[1791:1784] ^ syn_8_tmp[1799:1792] ^ 
      syn_8_tmp[1807:1800] ^ syn_8_tmp[1815:1808] ^ syn_8_tmp[1823:1816] ^ 
      syn_8_tmp[1831:1824] ^ syn_8_tmp[1839:1832] ^ syn_8_tmp[1847:1840] ^ 
      syn_8_tmp[1855:1848] ^ syn_8_tmp[1863:1856] ^ syn_8_tmp[1871:1864] ^ 
      syn_8_tmp[1879:1872] ^ syn_8_tmp[1887:1880] ^ syn_8_tmp[1895:1888] ^ 
      syn_8_tmp[1903:1896] ^ syn_8_tmp[1911:1904] ^ syn_8_tmp[1919:1912] ^ 
      syn_8_tmp[1927:1920] ^ syn_8_tmp[1935:1928] ^ syn_8_tmp[1943:1936] ^ 
      syn_8_tmp[1951:1944] ^ syn_8_tmp[1959:1952] ^ syn_8_tmp[1967:1960] ^ 
      syn_8_tmp[1975:1968] ^ syn_8_tmp[1983:1976] ^ syn_8_tmp[1991:1984] ^ 
      syn_8_tmp[1999:1992] ^ syn_8_tmp[2007:2000] ^ syn_8_tmp[2015:2008] ^ 
      syn_8_tmp[2023:2016] ^ syn_8_tmp[2031:2024] ^ syn_8_tmp[2039:2032];

// syndrome 9
  wire [2039:0] syn_9_tmp;
  gf_mult_by_01 m2295 (.i(rx_data[7:0]),.o(syn_9_tmp[7:0]));
  gf_mult_by_3a m2296 (.i(rx_data[15:8]),.o(syn_9_tmp[15:8]));
  gf_mult_by_2d m2297 (.i(rx_data[23:16]),.o(syn_9_tmp[23:16]));
  gf_mult_by_0c m2298 (.i(rx_data[31:24]),.o(syn_9_tmp[31:24]));
  gf_mult_by_25 m2299 (.i(rx_data[39:32]),.o(syn_9_tmp[39:32]));
  gf_mult_by_c1 m2300 (.i(rx_data[47:40]),.o(syn_9_tmp[47:40]));
  gf_mult_by_50 m2301 (.i(rx_data[55:48]),.o(syn_9_tmp[55:48]));
  gf_mult_by_a1 m2302 (.i(rx_data[63:56]),.o(syn_9_tmp[63:56]));
  gf_mult_by_65 m2303 (.i(rx_data[71:64]),.o(syn_9_tmp[71:64]));
  gf_mult_by_e7 m2304 (.i(rx_data[79:72]),.o(syn_9_tmp[79:72]));
  gf_mult_by_df m2305 (.i(rx_data[87:80]),.o(syn_9_tmp[87:80]));
  gf_mult_by_86 m2306 (.i(rx_data[95:88]),.o(syn_9_tmp[95:88]));
  gf_mult_by_d0 m2307 (.i(rx_data[103:96]),.o(syn_9_tmp[103:96]));
  gf_mult_by_ed m2308 (.i(rx_data[111:104]),.o(syn_9_tmp[111:104]));
  gf_mult_by_66 m2309 (.i(rx_data[119:112]),.o(syn_9_tmp[119:112]));
  gf_mult_by_a9 m2310 (.i(rx_data[127:120]),.o(syn_9_tmp[127:120]));
  gf_mult_by_a8 m2311 (.i(rx_data[135:128]),.o(syn_9_tmp[135:128]));
  gf_mult_by_92 m2312 (.i(rx_data[143:136]),.o(syn_9_tmp[143:136]));
  gf_mult_by_bf m2313 (.i(rx_data[151:144]),.o(syn_9_tmp[151:144]));
  gf_mult_by_b3 m2314 (.i(rx_data[159:152]),.o(syn_9_tmp[159:152]));
  gf_mult_by_96 m2315 (.i(rx_data[167:160]),.o(syn_9_tmp[167:160]));
  gf_mult_by_57 m2316 (.i(rx_data[175:168]),.o(syn_9_tmp[175:168]));
  gf_mult_by_07 m2317 (.i(rx_data[183:176]),.o(syn_9_tmp[183:176]));
  gf_mult_by_a6 m2318 (.i(rx_data[191:184]),.o(syn_9_tmp[191:184]));
  gf_mult_by_c3 m2319 (.i(rx_data[199:192]),.o(syn_9_tmp[199:192]));
  gf_mult_by_24 m2320 (.i(rx_data[207:200]),.o(syn_9_tmp[207:200]));
  gf_mult_by_fb m2321 (.i(rx_data[215:208]),.o(syn_9_tmp[215:208]));
  gf_mult_by_7d m2322 (.i(rx_data[223:216]),.o(syn_9_tmp[223:216]));
  gf_mult_by_ad m2323 (.i(rx_data[231:224]),.o(syn_9_tmp[231:224]));
  gf_mult_by_40 m2324 (.i(rx_data[239:232]),.o(syn_9_tmp[239:232]));
  gf_mult_by_26 m2325 (.i(rx_data[247:240]),.o(syn_9_tmp[247:240]));
  gf_mult_by_8f m2326 (.i(rx_data[255:248]),.o(syn_9_tmp[255:248]));
  gf_mult_by_27 m2327 (.i(rx_data[263:256]),.o(syn_9_tmp[263:256]));
  gf_mult_by_b5 m2328 (.i(rx_data[271:264]),.o(syn_9_tmp[271:264]));
  gf_mult_by_0a m2329 (.i(rx_data[279:272]),.o(syn_9_tmp[279:272]));
  gf_mult_by_b9 m2330 (.i(rx_data[287:280]),.o(syn_9_tmp[287:280]));
  gf_mult_by_2f m2331 (.i(rx_data[295:288]),.o(syn_9_tmp[295:288]));
  gf_mult_by_78 m2332 (.i(rx_data[303:296]),.o(syn_9_tmp[303:296]));
  gf_mult_by_7f m2333 (.i(rx_data[311:304]),.o(syn_9_tmp[311:304]));
  gf_mult_by_d9 m2334 (.i(rx_data[319:312]),.o(syn_9_tmp[319:312]));
  gf_mult_by_1a m2335 (.i(rx_data[327:320]),.o(syn_9_tmp[327:320]));
  gf_mult_by_3e m2336 (.i(rx_data[335:328]),.o(syn_9_tmp[335:328]));
  gf_mult_by_c5 m2337 (.i(rx_data[343:336]),.o(syn_9_tmp[343:336]));
  gf_mult_by_b8 m2338 (.i(rx_data[351:344]),.o(syn_9_tmp[351:344]));
  gf_mult_by_15 m2339 (.i(rx_data[359:352]),.o(syn_9_tmp[359:352]));
  gf_mult_by_55 m2340 (.i(rx_data[367:360]),.o(syn_9_tmp[367:360]));
  gf_mult_by_73 m2341 (.i(rx_data[375:368]),.o(syn_9_tmp[375:368]));
  gf_mult_by_fc m2342 (.i(rx_data[383:376]),.o(syn_9_tmp[383:376]));
  gf_mult_by_db m2343 (.i(rx_data[391:384]),.o(syn_9_tmp[391:384]));
  gf_mult_by_6e m2344 (.i(rx_data[399:392]),.o(syn_9_tmp[399:392]));
  gf_mult_by_64 m2345 (.i(rx_data[407:400]),.o(syn_9_tmp[407:400]));
  gf_mult_by_dd m2346 (.i(rx_data[415:408]),.o(syn_9_tmp[415:408]));
  gf_mult_by_f2 m2347 (.i(rx_data[423:416]),.o(syn_9_tmp[423:416]));
  gf_mult_by_8a m2348 (.i(rx_data[431:424]),.o(syn_9_tmp[431:424]));
  gf_mult_by_f5 m2349 (.i(rx_data[439:432]),.o(syn_9_tmp[439:432]));
  gf_mult_by_2c m2350 (.i(rx_data[447:440]),.o(syn_9_tmp[447:440]));
  gf_mult_by_36 m2351 (.i(rx_data[455:448]),.o(syn_9_tmp[455:448]));
  gf_mult_by_08 m2352 (.i(rx_data[463:456]),.o(syn_9_tmp[463:456]));
  gf_mult_by_cd m2353 (.i(rx_data[471:464]),.o(syn_9_tmp[471:464]));
  gf_mult_by_75 m2354 (.i(rx_data[479:472]),.o(syn_9_tmp[479:472]));
  gf_mult_by_60 m2355 (.i(rx_data[487:480]),.o(syn_9_tmp[487:480]));
  gf_mult_by_35 m2356 (.i(rx_data[495:488]),.o(syn_9_tmp[495:488]));
  gf_mult_by_46 m2357 (.i(rx_data[503:496]),.o(syn_9_tmp[503:496]));
  gf_mult_by_ba m2358 (.i(rx_data[511:504]),.o(syn_9_tmp[511:504]));
  gf_mult_by_61 m2359 (.i(rx_data[519:512]),.o(syn_9_tmp[519:512]));
  gf_mult_by_0f m2360 (.i(rx_data[527:520]),.o(syn_9_tmp[527:520]));
  gf_mult_by_6b m2361 (.i(rx_data[535:528]),.o(syn_9_tmp[535:528]));
  gf_mult_by_b6 m2362 (.i(rx_data[543:536]),.o(syn_9_tmp[543:536]));
  gf_mult_by_44 m2363 (.i(rx_data[551:544]),.o(syn_9_tmp[551:544]));
  gf_mult_by_ce m2364 (.i(rx_data[559:552]),.o(syn_9_tmp[559:552]));
  gf_mult_by_3b m2365 (.i(rx_data[567:560]),.o(syn_9_tmp[567:560]));
  gf_mult_by_17 m2366 (.i(rx_data[575:568]),.o(syn_9_tmp[575:568]));
  gf_mult_by_21 m2367 (.i(rx_data[583:576]),.o(syn_9_tmp[583:576]));
  gf_mult_by_29 m2368 (.i(rx_data[591:584]),.o(syn_9_tmp[591:584]));
  gf_mult_by_e4 m2369 (.i(rx_data[599:592]),.o(syn_9_tmp[599:592]));
  gf_mult_by_91 m2370 (.i(rx_data[607:600]),.o(syn_9_tmp[607:600]));
  gf_mult_by_f1 m2371 (.i(rx_data[615:608]),.o(syn_9_tmp[615:608]));
  gf_mult_by_c4 m2372 (.i(rx_data[623:616]),.o(syn_9_tmp[623:616]));
  gf_mult_by_82 m2373 (.i(rx_data[631:624]),.o(syn_9_tmp[631:624]));
  gf_mult_by_38 m2374 (.i(rx_data[639:632]),.o(syn_9_tmp[639:632]));
  gf_mult_by_59 m2375 (.i(rx_data[647:640]),.o(syn_9_tmp[647:640]));
  gf_mult_by_56 m2376 (.i(rx_data[655:648]),.o(syn_9_tmp[655:648]));
  gf_mult_by_3d m2377 (.i(rx_data[663:656]),.o(syn_9_tmp[663:656]));
  gf_mult_by_8b m2378 (.i(rx_data[671:664]),.o(syn_9_tmp[671:664]));
  gf_mult_by_cf m2379 (.i(rx_data[679:672]),.o(syn_9_tmp[679:672]));
  gf_mult_by_01 m2380 (.i(rx_data[687:680]),.o(syn_9_tmp[687:680]));
  gf_mult_by_3a m2381 (.i(rx_data[695:688]),.o(syn_9_tmp[695:688]));
  gf_mult_by_2d m2382 (.i(rx_data[703:696]),.o(syn_9_tmp[703:696]));
  gf_mult_by_0c m2383 (.i(rx_data[711:704]),.o(syn_9_tmp[711:704]));
  gf_mult_by_25 m2384 (.i(rx_data[719:712]),.o(syn_9_tmp[719:712]));
  gf_mult_by_c1 m2385 (.i(rx_data[727:720]),.o(syn_9_tmp[727:720]));
  gf_mult_by_50 m2386 (.i(rx_data[735:728]),.o(syn_9_tmp[735:728]));
  gf_mult_by_a1 m2387 (.i(rx_data[743:736]),.o(syn_9_tmp[743:736]));
  gf_mult_by_65 m2388 (.i(rx_data[751:744]),.o(syn_9_tmp[751:744]));
  gf_mult_by_e7 m2389 (.i(rx_data[759:752]),.o(syn_9_tmp[759:752]));
  gf_mult_by_df m2390 (.i(rx_data[767:760]),.o(syn_9_tmp[767:760]));
  gf_mult_by_86 m2391 (.i(rx_data[775:768]),.o(syn_9_tmp[775:768]));
  gf_mult_by_d0 m2392 (.i(rx_data[783:776]),.o(syn_9_tmp[783:776]));
  gf_mult_by_ed m2393 (.i(rx_data[791:784]),.o(syn_9_tmp[791:784]));
  gf_mult_by_66 m2394 (.i(rx_data[799:792]),.o(syn_9_tmp[799:792]));
  gf_mult_by_a9 m2395 (.i(rx_data[807:800]),.o(syn_9_tmp[807:800]));
  gf_mult_by_a8 m2396 (.i(rx_data[815:808]),.o(syn_9_tmp[815:808]));
  gf_mult_by_92 m2397 (.i(rx_data[823:816]),.o(syn_9_tmp[823:816]));
  gf_mult_by_bf m2398 (.i(rx_data[831:824]),.o(syn_9_tmp[831:824]));
  gf_mult_by_b3 m2399 (.i(rx_data[839:832]),.o(syn_9_tmp[839:832]));
  gf_mult_by_96 m2400 (.i(rx_data[847:840]),.o(syn_9_tmp[847:840]));
  gf_mult_by_57 m2401 (.i(rx_data[855:848]),.o(syn_9_tmp[855:848]));
  gf_mult_by_07 m2402 (.i(rx_data[863:856]),.o(syn_9_tmp[863:856]));
  gf_mult_by_a6 m2403 (.i(rx_data[871:864]),.o(syn_9_tmp[871:864]));
  gf_mult_by_c3 m2404 (.i(rx_data[879:872]),.o(syn_9_tmp[879:872]));
  gf_mult_by_24 m2405 (.i(rx_data[887:880]),.o(syn_9_tmp[887:880]));
  gf_mult_by_fb m2406 (.i(rx_data[895:888]),.o(syn_9_tmp[895:888]));
  gf_mult_by_7d m2407 (.i(rx_data[903:896]),.o(syn_9_tmp[903:896]));
  gf_mult_by_ad m2408 (.i(rx_data[911:904]),.o(syn_9_tmp[911:904]));
  gf_mult_by_40 m2409 (.i(rx_data[919:912]),.o(syn_9_tmp[919:912]));
  gf_mult_by_26 m2410 (.i(rx_data[927:920]),.o(syn_9_tmp[927:920]));
  gf_mult_by_8f m2411 (.i(rx_data[935:928]),.o(syn_9_tmp[935:928]));
  gf_mult_by_27 m2412 (.i(rx_data[943:936]),.o(syn_9_tmp[943:936]));
  gf_mult_by_b5 m2413 (.i(rx_data[951:944]),.o(syn_9_tmp[951:944]));
  gf_mult_by_0a m2414 (.i(rx_data[959:952]),.o(syn_9_tmp[959:952]));
  gf_mult_by_b9 m2415 (.i(rx_data[967:960]),.o(syn_9_tmp[967:960]));
  gf_mult_by_2f m2416 (.i(rx_data[975:968]),.o(syn_9_tmp[975:968]));
  gf_mult_by_78 m2417 (.i(rx_data[983:976]),.o(syn_9_tmp[983:976]));
  gf_mult_by_7f m2418 (.i(rx_data[991:984]),.o(syn_9_tmp[991:984]));
  gf_mult_by_d9 m2419 (.i(rx_data[999:992]),.o(syn_9_tmp[999:992]));
  gf_mult_by_1a m2420 (.i(rx_data[1007:1000]),.o(syn_9_tmp[1007:1000]));
  gf_mult_by_3e m2421 (.i(rx_data[1015:1008]),.o(syn_9_tmp[1015:1008]));
  gf_mult_by_c5 m2422 (.i(rx_data[1023:1016]),.o(syn_9_tmp[1023:1016]));
  gf_mult_by_b8 m2423 (.i(rx_data[1031:1024]),.o(syn_9_tmp[1031:1024]));
  gf_mult_by_15 m2424 (.i(rx_data[1039:1032]),.o(syn_9_tmp[1039:1032]));
  gf_mult_by_55 m2425 (.i(rx_data[1047:1040]),.o(syn_9_tmp[1047:1040]));
  gf_mult_by_73 m2426 (.i(rx_data[1055:1048]),.o(syn_9_tmp[1055:1048]));
  gf_mult_by_fc m2427 (.i(rx_data[1063:1056]),.o(syn_9_tmp[1063:1056]));
  gf_mult_by_db m2428 (.i(rx_data[1071:1064]),.o(syn_9_tmp[1071:1064]));
  gf_mult_by_6e m2429 (.i(rx_data[1079:1072]),.o(syn_9_tmp[1079:1072]));
  gf_mult_by_64 m2430 (.i(rx_data[1087:1080]),.o(syn_9_tmp[1087:1080]));
  gf_mult_by_dd m2431 (.i(rx_data[1095:1088]),.o(syn_9_tmp[1095:1088]));
  gf_mult_by_f2 m2432 (.i(rx_data[1103:1096]),.o(syn_9_tmp[1103:1096]));
  gf_mult_by_8a m2433 (.i(rx_data[1111:1104]),.o(syn_9_tmp[1111:1104]));
  gf_mult_by_f5 m2434 (.i(rx_data[1119:1112]),.o(syn_9_tmp[1119:1112]));
  gf_mult_by_2c m2435 (.i(rx_data[1127:1120]),.o(syn_9_tmp[1127:1120]));
  gf_mult_by_36 m2436 (.i(rx_data[1135:1128]),.o(syn_9_tmp[1135:1128]));
  gf_mult_by_08 m2437 (.i(rx_data[1143:1136]),.o(syn_9_tmp[1143:1136]));
  gf_mult_by_cd m2438 (.i(rx_data[1151:1144]),.o(syn_9_tmp[1151:1144]));
  gf_mult_by_75 m2439 (.i(rx_data[1159:1152]),.o(syn_9_tmp[1159:1152]));
  gf_mult_by_60 m2440 (.i(rx_data[1167:1160]),.o(syn_9_tmp[1167:1160]));
  gf_mult_by_35 m2441 (.i(rx_data[1175:1168]),.o(syn_9_tmp[1175:1168]));
  gf_mult_by_46 m2442 (.i(rx_data[1183:1176]),.o(syn_9_tmp[1183:1176]));
  gf_mult_by_ba m2443 (.i(rx_data[1191:1184]),.o(syn_9_tmp[1191:1184]));
  gf_mult_by_61 m2444 (.i(rx_data[1199:1192]),.o(syn_9_tmp[1199:1192]));
  gf_mult_by_0f m2445 (.i(rx_data[1207:1200]),.o(syn_9_tmp[1207:1200]));
  gf_mult_by_6b m2446 (.i(rx_data[1215:1208]),.o(syn_9_tmp[1215:1208]));
  gf_mult_by_b6 m2447 (.i(rx_data[1223:1216]),.o(syn_9_tmp[1223:1216]));
  gf_mult_by_44 m2448 (.i(rx_data[1231:1224]),.o(syn_9_tmp[1231:1224]));
  gf_mult_by_ce m2449 (.i(rx_data[1239:1232]),.o(syn_9_tmp[1239:1232]));
  gf_mult_by_3b m2450 (.i(rx_data[1247:1240]),.o(syn_9_tmp[1247:1240]));
  gf_mult_by_17 m2451 (.i(rx_data[1255:1248]),.o(syn_9_tmp[1255:1248]));
  gf_mult_by_21 m2452 (.i(rx_data[1263:1256]),.o(syn_9_tmp[1263:1256]));
  gf_mult_by_29 m2453 (.i(rx_data[1271:1264]),.o(syn_9_tmp[1271:1264]));
  gf_mult_by_e4 m2454 (.i(rx_data[1279:1272]),.o(syn_9_tmp[1279:1272]));
  gf_mult_by_91 m2455 (.i(rx_data[1287:1280]),.o(syn_9_tmp[1287:1280]));
  gf_mult_by_f1 m2456 (.i(rx_data[1295:1288]),.o(syn_9_tmp[1295:1288]));
  gf_mult_by_c4 m2457 (.i(rx_data[1303:1296]),.o(syn_9_tmp[1303:1296]));
  gf_mult_by_82 m2458 (.i(rx_data[1311:1304]),.o(syn_9_tmp[1311:1304]));
  gf_mult_by_38 m2459 (.i(rx_data[1319:1312]),.o(syn_9_tmp[1319:1312]));
  gf_mult_by_59 m2460 (.i(rx_data[1327:1320]),.o(syn_9_tmp[1327:1320]));
  gf_mult_by_56 m2461 (.i(rx_data[1335:1328]),.o(syn_9_tmp[1335:1328]));
  gf_mult_by_3d m2462 (.i(rx_data[1343:1336]),.o(syn_9_tmp[1343:1336]));
  gf_mult_by_8b m2463 (.i(rx_data[1351:1344]),.o(syn_9_tmp[1351:1344]));
  gf_mult_by_cf m2464 (.i(rx_data[1359:1352]),.o(syn_9_tmp[1359:1352]));
  gf_mult_by_01 m2465 (.i(rx_data[1367:1360]),.o(syn_9_tmp[1367:1360]));
  gf_mult_by_3a m2466 (.i(rx_data[1375:1368]),.o(syn_9_tmp[1375:1368]));
  gf_mult_by_2d m2467 (.i(rx_data[1383:1376]),.o(syn_9_tmp[1383:1376]));
  gf_mult_by_0c m2468 (.i(rx_data[1391:1384]),.o(syn_9_tmp[1391:1384]));
  gf_mult_by_25 m2469 (.i(rx_data[1399:1392]),.o(syn_9_tmp[1399:1392]));
  gf_mult_by_c1 m2470 (.i(rx_data[1407:1400]),.o(syn_9_tmp[1407:1400]));
  gf_mult_by_50 m2471 (.i(rx_data[1415:1408]),.o(syn_9_tmp[1415:1408]));
  gf_mult_by_a1 m2472 (.i(rx_data[1423:1416]),.o(syn_9_tmp[1423:1416]));
  gf_mult_by_65 m2473 (.i(rx_data[1431:1424]),.o(syn_9_tmp[1431:1424]));
  gf_mult_by_e7 m2474 (.i(rx_data[1439:1432]),.o(syn_9_tmp[1439:1432]));
  gf_mult_by_df m2475 (.i(rx_data[1447:1440]),.o(syn_9_tmp[1447:1440]));
  gf_mult_by_86 m2476 (.i(rx_data[1455:1448]),.o(syn_9_tmp[1455:1448]));
  gf_mult_by_d0 m2477 (.i(rx_data[1463:1456]),.o(syn_9_tmp[1463:1456]));
  gf_mult_by_ed m2478 (.i(rx_data[1471:1464]),.o(syn_9_tmp[1471:1464]));
  gf_mult_by_66 m2479 (.i(rx_data[1479:1472]),.o(syn_9_tmp[1479:1472]));
  gf_mult_by_a9 m2480 (.i(rx_data[1487:1480]),.o(syn_9_tmp[1487:1480]));
  gf_mult_by_a8 m2481 (.i(rx_data[1495:1488]),.o(syn_9_tmp[1495:1488]));
  gf_mult_by_92 m2482 (.i(rx_data[1503:1496]),.o(syn_9_tmp[1503:1496]));
  gf_mult_by_bf m2483 (.i(rx_data[1511:1504]),.o(syn_9_tmp[1511:1504]));
  gf_mult_by_b3 m2484 (.i(rx_data[1519:1512]),.o(syn_9_tmp[1519:1512]));
  gf_mult_by_96 m2485 (.i(rx_data[1527:1520]),.o(syn_9_tmp[1527:1520]));
  gf_mult_by_57 m2486 (.i(rx_data[1535:1528]),.o(syn_9_tmp[1535:1528]));
  gf_mult_by_07 m2487 (.i(rx_data[1543:1536]),.o(syn_9_tmp[1543:1536]));
  gf_mult_by_a6 m2488 (.i(rx_data[1551:1544]),.o(syn_9_tmp[1551:1544]));
  gf_mult_by_c3 m2489 (.i(rx_data[1559:1552]),.o(syn_9_tmp[1559:1552]));
  gf_mult_by_24 m2490 (.i(rx_data[1567:1560]),.o(syn_9_tmp[1567:1560]));
  gf_mult_by_fb m2491 (.i(rx_data[1575:1568]),.o(syn_9_tmp[1575:1568]));
  gf_mult_by_7d m2492 (.i(rx_data[1583:1576]),.o(syn_9_tmp[1583:1576]));
  gf_mult_by_ad m2493 (.i(rx_data[1591:1584]),.o(syn_9_tmp[1591:1584]));
  gf_mult_by_40 m2494 (.i(rx_data[1599:1592]),.o(syn_9_tmp[1599:1592]));
  gf_mult_by_26 m2495 (.i(rx_data[1607:1600]),.o(syn_9_tmp[1607:1600]));
  gf_mult_by_8f m2496 (.i(rx_data[1615:1608]),.o(syn_9_tmp[1615:1608]));
  gf_mult_by_27 m2497 (.i(rx_data[1623:1616]),.o(syn_9_tmp[1623:1616]));
  gf_mult_by_b5 m2498 (.i(rx_data[1631:1624]),.o(syn_9_tmp[1631:1624]));
  gf_mult_by_0a m2499 (.i(rx_data[1639:1632]),.o(syn_9_tmp[1639:1632]));
  gf_mult_by_b9 m2500 (.i(rx_data[1647:1640]),.o(syn_9_tmp[1647:1640]));
  gf_mult_by_2f m2501 (.i(rx_data[1655:1648]),.o(syn_9_tmp[1655:1648]));
  gf_mult_by_78 m2502 (.i(rx_data[1663:1656]),.o(syn_9_tmp[1663:1656]));
  gf_mult_by_7f m2503 (.i(rx_data[1671:1664]),.o(syn_9_tmp[1671:1664]));
  gf_mult_by_d9 m2504 (.i(rx_data[1679:1672]),.o(syn_9_tmp[1679:1672]));
  gf_mult_by_1a m2505 (.i(rx_data[1687:1680]),.o(syn_9_tmp[1687:1680]));
  gf_mult_by_3e m2506 (.i(rx_data[1695:1688]),.o(syn_9_tmp[1695:1688]));
  gf_mult_by_c5 m2507 (.i(rx_data[1703:1696]),.o(syn_9_tmp[1703:1696]));
  gf_mult_by_b8 m2508 (.i(rx_data[1711:1704]),.o(syn_9_tmp[1711:1704]));
  gf_mult_by_15 m2509 (.i(rx_data[1719:1712]),.o(syn_9_tmp[1719:1712]));
  gf_mult_by_55 m2510 (.i(rx_data[1727:1720]),.o(syn_9_tmp[1727:1720]));
  gf_mult_by_73 m2511 (.i(rx_data[1735:1728]),.o(syn_9_tmp[1735:1728]));
  gf_mult_by_fc m2512 (.i(rx_data[1743:1736]),.o(syn_9_tmp[1743:1736]));
  gf_mult_by_db m2513 (.i(rx_data[1751:1744]),.o(syn_9_tmp[1751:1744]));
  gf_mult_by_6e m2514 (.i(rx_data[1759:1752]),.o(syn_9_tmp[1759:1752]));
  gf_mult_by_64 m2515 (.i(rx_data[1767:1760]),.o(syn_9_tmp[1767:1760]));
  gf_mult_by_dd m2516 (.i(rx_data[1775:1768]),.o(syn_9_tmp[1775:1768]));
  gf_mult_by_f2 m2517 (.i(rx_data[1783:1776]),.o(syn_9_tmp[1783:1776]));
  gf_mult_by_8a m2518 (.i(rx_data[1791:1784]),.o(syn_9_tmp[1791:1784]));
  gf_mult_by_f5 m2519 (.i(rx_data[1799:1792]),.o(syn_9_tmp[1799:1792]));
  gf_mult_by_2c m2520 (.i(rx_data[1807:1800]),.o(syn_9_tmp[1807:1800]));
  gf_mult_by_36 m2521 (.i(rx_data[1815:1808]),.o(syn_9_tmp[1815:1808]));
  gf_mult_by_08 m2522 (.i(rx_data[1823:1816]),.o(syn_9_tmp[1823:1816]));
  gf_mult_by_cd m2523 (.i(rx_data[1831:1824]),.o(syn_9_tmp[1831:1824]));
  gf_mult_by_75 m2524 (.i(rx_data[1839:1832]),.o(syn_9_tmp[1839:1832]));
  gf_mult_by_60 m2525 (.i(rx_data[1847:1840]),.o(syn_9_tmp[1847:1840]));
  gf_mult_by_35 m2526 (.i(rx_data[1855:1848]),.o(syn_9_tmp[1855:1848]));
  gf_mult_by_46 m2527 (.i(rx_data[1863:1856]),.o(syn_9_tmp[1863:1856]));
  gf_mult_by_ba m2528 (.i(rx_data[1871:1864]),.o(syn_9_tmp[1871:1864]));
  gf_mult_by_61 m2529 (.i(rx_data[1879:1872]),.o(syn_9_tmp[1879:1872]));
  gf_mult_by_0f m2530 (.i(rx_data[1887:1880]),.o(syn_9_tmp[1887:1880]));
  gf_mult_by_6b m2531 (.i(rx_data[1895:1888]),.o(syn_9_tmp[1895:1888]));
  gf_mult_by_b6 m2532 (.i(rx_data[1903:1896]),.o(syn_9_tmp[1903:1896]));
  gf_mult_by_44 m2533 (.i(rx_data[1911:1904]),.o(syn_9_tmp[1911:1904]));
  gf_mult_by_ce m2534 (.i(rx_data[1919:1912]),.o(syn_9_tmp[1919:1912]));
  gf_mult_by_3b m2535 (.i(rx_data[1927:1920]),.o(syn_9_tmp[1927:1920]));
  gf_mult_by_17 m2536 (.i(rx_data[1935:1928]),.o(syn_9_tmp[1935:1928]));
  gf_mult_by_21 m2537 (.i(rx_data[1943:1936]),.o(syn_9_tmp[1943:1936]));
  gf_mult_by_29 m2538 (.i(rx_data[1951:1944]),.o(syn_9_tmp[1951:1944]));
  gf_mult_by_e4 m2539 (.i(rx_data[1959:1952]),.o(syn_9_tmp[1959:1952]));
  gf_mult_by_91 m2540 (.i(rx_data[1967:1960]),.o(syn_9_tmp[1967:1960]));
  gf_mult_by_f1 m2541 (.i(rx_data[1975:1968]),.o(syn_9_tmp[1975:1968]));
  gf_mult_by_c4 m2542 (.i(rx_data[1983:1976]),.o(syn_9_tmp[1983:1976]));
  gf_mult_by_82 m2543 (.i(rx_data[1991:1984]),.o(syn_9_tmp[1991:1984]));
  gf_mult_by_38 m2544 (.i(rx_data[1999:1992]),.o(syn_9_tmp[1999:1992]));
  gf_mult_by_59 m2545 (.i(rx_data[2007:2000]),.o(syn_9_tmp[2007:2000]));
  gf_mult_by_56 m2546 (.i(rx_data[2015:2008]),.o(syn_9_tmp[2015:2008]));
  gf_mult_by_3d m2547 (.i(rx_data[2023:2016]),.o(syn_9_tmp[2023:2016]));
  gf_mult_by_8b m2548 (.i(rx_data[2031:2024]),.o(syn_9_tmp[2031:2024]));
  gf_mult_by_cf m2549 (.i(rx_data[2039:2032]),.o(syn_9_tmp[2039:2032]));
  assign syndrome[79:72] =
      syn_9_tmp[7:0] ^ syn_9_tmp[15:8] ^ syn_9_tmp[23:16] ^ 
      syn_9_tmp[31:24] ^ syn_9_tmp[39:32] ^ syn_9_tmp[47:40] ^ 
      syn_9_tmp[55:48] ^ syn_9_tmp[63:56] ^ syn_9_tmp[71:64] ^ 
      syn_9_tmp[79:72] ^ syn_9_tmp[87:80] ^ syn_9_tmp[95:88] ^ 
      syn_9_tmp[103:96] ^ syn_9_tmp[111:104] ^ syn_9_tmp[119:112] ^ 
      syn_9_tmp[127:120] ^ syn_9_tmp[135:128] ^ syn_9_tmp[143:136] ^ 
      syn_9_tmp[151:144] ^ syn_9_tmp[159:152] ^ syn_9_tmp[167:160] ^ 
      syn_9_tmp[175:168] ^ syn_9_tmp[183:176] ^ syn_9_tmp[191:184] ^ 
      syn_9_tmp[199:192] ^ syn_9_tmp[207:200] ^ syn_9_tmp[215:208] ^ 
      syn_9_tmp[223:216] ^ syn_9_tmp[231:224] ^ syn_9_tmp[239:232] ^ 
      syn_9_tmp[247:240] ^ syn_9_tmp[255:248] ^ syn_9_tmp[263:256] ^ 
      syn_9_tmp[271:264] ^ syn_9_tmp[279:272] ^ syn_9_tmp[287:280] ^ 
      syn_9_tmp[295:288] ^ syn_9_tmp[303:296] ^ syn_9_tmp[311:304] ^ 
      syn_9_tmp[319:312] ^ syn_9_tmp[327:320] ^ syn_9_tmp[335:328] ^ 
      syn_9_tmp[343:336] ^ syn_9_tmp[351:344] ^ syn_9_tmp[359:352] ^ 
      syn_9_tmp[367:360] ^ syn_9_tmp[375:368] ^ syn_9_tmp[383:376] ^ 
      syn_9_tmp[391:384] ^ syn_9_tmp[399:392] ^ syn_9_tmp[407:400] ^ 
      syn_9_tmp[415:408] ^ syn_9_tmp[423:416] ^ syn_9_tmp[431:424] ^ 
      syn_9_tmp[439:432] ^ syn_9_tmp[447:440] ^ syn_9_tmp[455:448] ^ 
      syn_9_tmp[463:456] ^ syn_9_tmp[471:464] ^ syn_9_tmp[479:472] ^ 
      syn_9_tmp[487:480] ^ syn_9_tmp[495:488] ^ syn_9_tmp[503:496] ^ 
      syn_9_tmp[511:504] ^ syn_9_tmp[519:512] ^ syn_9_tmp[527:520] ^ 
      syn_9_tmp[535:528] ^ syn_9_tmp[543:536] ^ syn_9_tmp[551:544] ^ 
      syn_9_tmp[559:552] ^ syn_9_tmp[567:560] ^ syn_9_tmp[575:568] ^ 
      syn_9_tmp[583:576] ^ syn_9_tmp[591:584] ^ syn_9_tmp[599:592] ^ 
      syn_9_tmp[607:600] ^ syn_9_tmp[615:608] ^ syn_9_tmp[623:616] ^ 
      syn_9_tmp[631:624] ^ syn_9_tmp[639:632] ^ syn_9_tmp[647:640] ^ 
      syn_9_tmp[655:648] ^ syn_9_tmp[663:656] ^ syn_9_tmp[671:664] ^ 
      syn_9_tmp[679:672] ^ syn_9_tmp[687:680] ^ syn_9_tmp[695:688] ^ 
      syn_9_tmp[703:696] ^ syn_9_tmp[711:704] ^ syn_9_tmp[719:712] ^ 
      syn_9_tmp[727:720] ^ syn_9_tmp[735:728] ^ syn_9_tmp[743:736] ^ 
      syn_9_tmp[751:744] ^ syn_9_tmp[759:752] ^ syn_9_tmp[767:760] ^ 
      syn_9_tmp[775:768] ^ syn_9_tmp[783:776] ^ syn_9_tmp[791:784] ^ 
      syn_9_tmp[799:792] ^ syn_9_tmp[807:800] ^ syn_9_tmp[815:808] ^ 
      syn_9_tmp[823:816] ^ syn_9_tmp[831:824] ^ syn_9_tmp[839:832] ^ 
      syn_9_tmp[847:840] ^ syn_9_tmp[855:848] ^ syn_9_tmp[863:856] ^ 
      syn_9_tmp[871:864] ^ syn_9_tmp[879:872] ^ syn_9_tmp[887:880] ^ 
      syn_9_tmp[895:888] ^ syn_9_tmp[903:896] ^ syn_9_tmp[911:904] ^ 
      syn_9_tmp[919:912] ^ syn_9_tmp[927:920] ^ syn_9_tmp[935:928] ^ 
      syn_9_tmp[943:936] ^ syn_9_tmp[951:944] ^ syn_9_tmp[959:952] ^ 
      syn_9_tmp[967:960] ^ syn_9_tmp[975:968] ^ syn_9_tmp[983:976] ^ 
      syn_9_tmp[991:984] ^ syn_9_tmp[999:992] ^ syn_9_tmp[1007:1000] ^ 
      syn_9_tmp[1015:1008] ^ syn_9_tmp[1023:1016] ^ syn_9_tmp[1031:1024] ^ 
      syn_9_tmp[1039:1032] ^ syn_9_tmp[1047:1040] ^ syn_9_tmp[1055:1048] ^ 
      syn_9_tmp[1063:1056] ^ syn_9_tmp[1071:1064] ^ syn_9_tmp[1079:1072] ^ 
      syn_9_tmp[1087:1080] ^ syn_9_tmp[1095:1088] ^ syn_9_tmp[1103:1096] ^ 
      syn_9_tmp[1111:1104] ^ syn_9_tmp[1119:1112] ^ syn_9_tmp[1127:1120] ^ 
      syn_9_tmp[1135:1128] ^ syn_9_tmp[1143:1136] ^ syn_9_tmp[1151:1144] ^ 
      syn_9_tmp[1159:1152] ^ syn_9_tmp[1167:1160] ^ syn_9_tmp[1175:1168] ^ 
      syn_9_tmp[1183:1176] ^ syn_9_tmp[1191:1184] ^ syn_9_tmp[1199:1192] ^ 
      syn_9_tmp[1207:1200] ^ syn_9_tmp[1215:1208] ^ syn_9_tmp[1223:1216] ^ 
      syn_9_tmp[1231:1224] ^ syn_9_tmp[1239:1232] ^ syn_9_tmp[1247:1240] ^ 
      syn_9_tmp[1255:1248] ^ syn_9_tmp[1263:1256] ^ syn_9_tmp[1271:1264] ^ 
      syn_9_tmp[1279:1272] ^ syn_9_tmp[1287:1280] ^ syn_9_tmp[1295:1288] ^ 
      syn_9_tmp[1303:1296] ^ syn_9_tmp[1311:1304] ^ syn_9_tmp[1319:1312] ^ 
      syn_9_tmp[1327:1320] ^ syn_9_tmp[1335:1328] ^ syn_9_tmp[1343:1336] ^ 
      syn_9_tmp[1351:1344] ^ syn_9_tmp[1359:1352] ^ syn_9_tmp[1367:1360] ^ 
      syn_9_tmp[1375:1368] ^ syn_9_tmp[1383:1376] ^ syn_9_tmp[1391:1384] ^ 
      syn_9_tmp[1399:1392] ^ syn_9_tmp[1407:1400] ^ syn_9_tmp[1415:1408] ^ 
      syn_9_tmp[1423:1416] ^ syn_9_tmp[1431:1424] ^ syn_9_tmp[1439:1432] ^ 
      syn_9_tmp[1447:1440] ^ syn_9_tmp[1455:1448] ^ syn_9_tmp[1463:1456] ^ 
      syn_9_tmp[1471:1464] ^ syn_9_tmp[1479:1472] ^ syn_9_tmp[1487:1480] ^ 
      syn_9_tmp[1495:1488] ^ syn_9_tmp[1503:1496] ^ syn_9_tmp[1511:1504] ^ 
      syn_9_tmp[1519:1512] ^ syn_9_tmp[1527:1520] ^ syn_9_tmp[1535:1528] ^ 
      syn_9_tmp[1543:1536] ^ syn_9_tmp[1551:1544] ^ syn_9_tmp[1559:1552] ^ 
      syn_9_tmp[1567:1560] ^ syn_9_tmp[1575:1568] ^ syn_9_tmp[1583:1576] ^ 
      syn_9_tmp[1591:1584] ^ syn_9_tmp[1599:1592] ^ syn_9_tmp[1607:1600] ^ 
      syn_9_tmp[1615:1608] ^ syn_9_tmp[1623:1616] ^ syn_9_tmp[1631:1624] ^ 
      syn_9_tmp[1639:1632] ^ syn_9_tmp[1647:1640] ^ syn_9_tmp[1655:1648] ^ 
      syn_9_tmp[1663:1656] ^ syn_9_tmp[1671:1664] ^ syn_9_tmp[1679:1672] ^ 
      syn_9_tmp[1687:1680] ^ syn_9_tmp[1695:1688] ^ syn_9_tmp[1703:1696] ^ 
      syn_9_tmp[1711:1704] ^ syn_9_tmp[1719:1712] ^ syn_9_tmp[1727:1720] ^ 
      syn_9_tmp[1735:1728] ^ syn_9_tmp[1743:1736] ^ syn_9_tmp[1751:1744] ^ 
      syn_9_tmp[1759:1752] ^ syn_9_tmp[1767:1760] ^ syn_9_tmp[1775:1768] ^ 
      syn_9_tmp[1783:1776] ^ syn_9_tmp[1791:1784] ^ syn_9_tmp[1799:1792] ^ 
      syn_9_tmp[1807:1800] ^ syn_9_tmp[1815:1808] ^ syn_9_tmp[1823:1816] ^ 
      syn_9_tmp[1831:1824] ^ syn_9_tmp[1839:1832] ^ syn_9_tmp[1847:1840] ^ 
      syn_9_tmp[1855:1848] ^ syn_9_tmp[1863:1856] ^ syn_9_tmp[1871:1864] ^ 
      syn_9_tmp[1879:1872] ^ syn_9_tmp[1887:1880] ^ syn_9_tmp[1895:1888] ^ 
      syn_9_tmp[1903:1896] ^ syn_9_tmp[1911:1904] ^ syn_9_tmp[1919:1912] ^ 
      syn_9_tmp[1927:1920] ^ syn_9_tmp[1935:1928] ^ syn_9_tmp[1943:1936] ^ 
      syn_9_tmp[1951:1944] ^ syn_9_tmp[1959:1952] ^ syn_9_tmp[1967:1960] ^ 
      syn_9_tmp[1975:1968] ^ syn_9_tmp[1983:1976] ^ syn_9_tmp[1991:1984] ^ 
      syn_9_tmp[1999:1992] ^ syn_9_tmp[2007:2000] ^ syn_9_tmp[2015:2008] ^ 
      syn_9_tmp[2023:2016] ^ syn_9_tmp[2031:2024] ^ syn_9_tmp[2039:2032];

// syndrome 10
  wire [2039:0] syn_10_tmp;
  gf_mult_by_01 m2550 (.i(rx_data[7:0]),.o(syn_10_tmp[7:0]));
  gf_mult_by_74 m2551 (.i(rx_data[15:8]),.o(syn_10_tmp[15:8]));
  gf_mult_by_b4 m2552 (.i(rx_data[23:16]),.o(syn_10_tmp[23:16]));
  gf_mult_by_60 m2553 (.i(rx_data[31:24]),.o(syn_10_tmp[31:24]));
  gf_mult_by_6a m2554 (.i(rx_data[39:32]),.o(syn_10_tmp[39:32]));
  gf_mult_by_05 m2555 (.i(rx_data[47:40]),.o(syn_10_tmp[47:40]));
  gf_mult_by_b9 m2556 (.i(rx_data[55:48]),.o(syn_10_tmp[55:48]));
  gf_mult_by_5e m2557 (.i(rx_data[63:56]),.o(syn_10_tmp[63:56]));
  gf_mult_by_fd m2558 (.i(rx_data[71:64]),.o(syn_10_tmp[71:64]));
  gf_mult_by_df m2559 (.i(rx_data[79:72]),.o(syn_10_tmp[79:72]));
  gf_mult_by_11 m2560 (.i(rx_data[87:80]),.o(syn_10_tmp[87:80]));
  gf_mult_by_67 m2561 (.i(rx_data[95:88]),.o(syn_10_tmp[95:88]));
  gf_mult_by_3b m2562 (.i(rx_data[103:96]),.o(syn_10_tmp[103:96]));
  gf_mult_by_2e m2563 (.i(rx_data[111:104]),.o(syn_10_tmp[111:104]));
  gf_mult_by_84 m2564 (.i(rx_data[119:112]),.o(syn_10_tmp[119:112]));
  gf_mult_by_55 m2565 (.i(rx_data[127:120]),.o(syn_10_tmp[127:120]));
  gf_mult_by_e6 m2566 (.i(rx_data[135:128]),.o(syn_10_tmp[135:128]));
  gf_mult_by_d7 m2567 (.i(rx_data[143:136]),.o(syn_10_tmp[143:136]));
  gf_mult_by_96 m2568 (.i(rx_data[151:144]),.o(syn_10_tmp[151:144]));
  gf_mult_by_ae m2569 (.i(rx_data[159:152]),.o(syn_10_tmp[159:152]));
  gf_mult_by_1c m2570 (.i(rx_data[167:160]),.o(syn_10_tmp[167:160]));
  gf_mult_by_59 m2571 (.i(rx_data[175:168]),.o(syn_10_tmp[175:168]));
  gf_mult_by_ac m2572 (.i(rx_data[183:176]),.o(syn_10_tmp[183:176]));
  gf_mult_by_f4 m2573 (.i(rx_data[191:184]),.o(syn_10_tmp[191:184]));
  gf_mult_by_2c m2574 (.i(rx_data[199:192]),.o(syn_10_tmp[199:192]));
  gf_mult_by_6c m2575 (.i(rx_data[207:200]),.o(syn_10_tmp[207:200]));
  gf_mult_by_20 m2576 (.i(rx_data[215:208]),.o(syn_10_tmp[215:208]));
  gf_mult_by_26 m2577 (.i(rx_data[223:216]),.o(syn_10_tmp[223:216]));
  gf_mult_by_03 m2578 (.i(rx_data[231:224]),.o(syn_10_tmp[231:224]));
  gf_mult_by_9c m2579 (.i(rx_data[239:232]),.o(syn_10_tmp[239:232]));
  gf_mult_by_c1 m2580 (.i(rx_data[247:240]),.o(syn_10_tmp[247:240]));
  gf_mult_by_a0 m2581 (.i(rx_data[255:248]),.o(syn_10_tmp[255:248]));
  gf_mult_by_be m2582 (.i(rx_data[263:256]),.o(syn_10_tmp[263:256]));
  gf_mult_by_0f m2583 (.i(rx_data[271:264]),.o(syn_10_tmp[271:264]));
  gf_mult_by_d6 m2584 (.i(rx_data[279:272]),.o(syn_10_tmp[279:272]));
  gf_mult_by_e2 m2585 (.i(rx_data[287:280]),.o(syn_10_tmp[287:280]));
  gf_mult_by_1a m2586 (.i(rx_data[295:288]),.o(syn_10_tmp[295:288]));
  gf_mult_by_7c m2587 (.i(rx_data[303:296]),.o(syn_10_tmp[303:296]));
  gf_mult_by_33 m2588 (.i(rx_data[311:304]),.o(syn_10_tmp[311:304]));
  gf_mult_by_a9 m2589 (.i(rx_data[319:312]),.o(syn_10_tmp[319:312]));
  gf_mult_by_4d m2590 (.i(rx_data[327:320]),.o(syn_10_tmp[327:320]));
  gf_mult_by_72 m2591 (.i(rx_data[335:328]),.o(syn_10_tmp[335:328]));
  gf_mult_by_91 m2592 (.i(rx_data[343:336]),.o(syn_10_tmp[343:336]));
  gf_mult_by_ff m2593 (.i(rx_data[351:344]),.o(syn_10_tmp[351:344]));
  gf_mult_by_37 m2594 (.i(rx_data[359:352]),.o(syn_10_tmp[359:352]));
  gf_mult_by_64 m2595 (.i(rx_data[367:360]),.o(syn_10_tmp[367:360]));
  gf_mult_by_a7 m2596 (.i(rx_data[375:368]),.o(syn_10_tmp[375:368]));
  gf_mult_by_ef m2597 (.i(rx_data[383:376]),.o(syn_10_tmp[383:376]));
  gf_mult_by_24 m2598 (.i(rx_data[391:384]),.o(syn_10_tmp[391:384]));
  gf_mult_by_eb m2599 (.i(rx_data[399:392]),.o(syn_10_tmp[399:392]));
  gf_mult_by_e9 m2600 (.i(rx_data[407:400]),.o(syn_10_tmp[407:400]));
  gf_mult_by_01 m2601 (.i(rx_data[415:408]),.o(syn_10_tmp[415:408]));
  gf_mult_by_74 m2602 (.i(rx_data[423:416]),.o(syn_10_tmp[423:416]));
  gf_mult_by_b4 m2603 (.i(rx_data[431:424]),.o(syn_10_tmp[431:424]));
  gf_mult_by_60 m2604 (.i(rx_data[439:432]),.o(syn_10_tmp[439:432]));
  gf_mult_by_6a m2605 (.i(rx_data[447:440]),.o(syn_10_tmp[447:440]));
  gf_mult_by_05 m2606 (.i(rx_data[455:448]),.o(syn_10_tmp[455:448]));
  gf_mult_by_b9 m2607 (.i(rx_data[463:456]),.o(syn_10_tmp[463:456]));
  gf_mult_by_5e m2608 (.i(rx_data[471:464]),.o(syn_10_tmp[471:464]));
  gf_mult_by_fd m2609 (.i(rx_data[479:472]),.o(syn_10_tmp[479:472]));
  gf_mult_by_df m2610 (.i(rx_data[487:480]),.o(syn_10_tmp[487:480]));
  gf_mult_by_11 m2611 (.i(rx_data[495:488]),.o(syn_10_tmp[495:488]));
  gf_mult_by_67 m2612 (.i(rx_data[503:496]),.o(syn_10_tmp[503:496]));
  gf_mult_by_3b m2613 (.i(rx_data[511:504]),.o(syn_10_tmp[511:504]));
  gf_mult_by_2e m2614 (.i(rx_data[519:512]),.o(syn_10_tmp[519:512]));
  gf_mult_by_84 m2615 (.i(rx_data[527:520]),.o(syn_10_tmp[527:520]));
  gf_mult_by_55 m2616 (.i(rx_data[535:528]),.o(syn_10_tmp[535:528]));
  gf_mult_by_e6 m2617 (.i(rx_data[543:536]),.o(syn_10_tmp[543:536]));
  gf_mult_by_d7 m2618 (.i(rx_data[551:544]),.o(syn_10_tmp[551:544]));
  gf_mult_by_96 m2619 (.i(rx_data[559:552]),.o(syn_10_tmp[559:552]));
  gf_mult_by_ae m2620 (.i(rx_data[567:560]),.o(syn_10_tmp[567:560]));
  gf_mult_by_1c m2621 (.i(rx_data[575:568]),.o(syn_10_tmp[575:568]));
  gf_mult_by_59 m2622 (.i(rx_data[583:576]),.o(syn_10_tmp[583:576]));
  gf_mult_by_ac m2623 (.i(rx_data[591:584]),.o(syn_10_tmp[591:584]));
  gf_mult_by_f4 m2624 (.i(rx_data[599:592]),.o(syn_10_tmp[599:592]));
  gf_mult_by_2c m2625 (.i(rx_data[607:600]),.o(syn_10_tmp[607:600]));
  gf_mult_by_6c m2626 (.i(rx_data[615:608]),.o(syn_10_tmp[615:608]));
  gf_mult_by_20 m2627 (.i(rx_data[623:616]),.o(syn_10_tmp[623:616]));
  gf_mult_by_26 m2628 (.i(rx_data[631:624]),.o(syn_10_tmp[631:624]));
  gf_mult_by_03 m2629 (.i(rx_data[639:632]),.o(syn_10_tmp[639:632]));
  gf_mult_by_9c m2630 (.i(rx_data[647:640]),.o(syn_10_tmp[647:640]));
  gf_mult_by_c1 m2631 (.i(rx_data[655:648]),.o(syn_10_tmp[655:648]));
  gf_mult_by_a0 m2632 (.i(rx_data[663:656]),.o(syn_10_tmp[663:656]));
  gf_mult_by_be m2633 (.i(rx_data[671:664]),.o(syn_10_tmp[671:664]));
  gf_mult_by_0f m2634 (.i(rx_data[679:672]),.o(syn_10_tmp[679:672]));
  gf_mult_by_d6 m2635 (.i(rx_data[687:680]),.o(syn_10_tmp[687:680]));
  gf_mult_by_e2 m2636 (.i(rx_data[695:688]),.o(syn_10_tmp[695:688]));
  gf_mult_by_1a m2637 (.i(rx_data[703:696]),.o(syn_10_tmp[703:696]));
  gf_mult_by_7c m2638 (.i(rx_data[711:704]),.o(syn_10_tmp[711:704]));
  gf_mult_by_33 m2639 (.i(rx_data[719:712]),.o(syn_10_tmp[719:712]));
  gf_mult_by_a9 m2640 (.i(rx_data[727:720]),.o(syn_10_tmp[727:720]));
  gf_mult_by_4d m2641 (.i(rx_data[735:728]),.o(syn_10_tmp[735:728]));
  gf_mult_by_72 m2642 (.i(rx_data[743:736]),.o(syn_10_tmp[743:736]));
  gf_mult_by_91 m2643 (.i(rx_data[751:744]),.o(syn_10_tmp[751:744]));
  gf_mult_by_ff m2644 (.i(rx_data[759:752]),.o(syn_10_tmp[759:752]));
  gf_mult_by_37 m2645 (.i(rx_data[767:760]),.o(syn_10_tmp[767:760]));
  gf_mult_by_64 m2646 (.i(rx_data[775:768]),.o(syn_10_tmp[775:768]));
  gf_mult_by_a7 m2647 (.i(rx_data[783:776]),.o(syn_10_tmp[783:776]));
  gf_mult_by_ef m2648 (.i(rx_data[791:784]),.o(syn_10_tmp[791:784]));
  gf_mult_by_24 m2649 (.i(rx_data[799:792]),.o(syn_10_tmp[799:792]));
  gf_mult_by_eb m2650 (.i(rx_data[807:800]),.o(syn_10_tmp[807:800]));
  gf_mult_by_e9 m2651 (.i(rx_data[815:808]),.o(syn_10_tmp[815:808]));
  gf_mult_by_01 m2652 (.i(rx_data[823:816]),.o(syn_10_tmp[823:816]));
  gf_mult_by_74 m2653 (.i(rx_data[831:824]),.o(syn_10_tmp[831:824]));
  gf_mult_by_b4 m2654 (.i(rx_data[839:832]),.o(syn_10_tmp[839:832]));
  gf_mult_by_60 m2655 (.i(rx_data[847:840]),.o(syn_10_tmp[847:840]));
  gf_mult_by_6a m2656 (.i(rx_data[855:848]),.o(syn_10_tmp[855:848]));
  gf_mult_by_05 m2657 (.i(rx_data[863:856]),.o(syn_10_tmp[863:856]));
  gf_mult_by_b9 m2658 (.i(rx_data[871:864]),.o(syn_10_tmp[871:864]));
  gf_mult_by_5e m2659 (.i(rx_data[879:872]),.o(syn_10_tmp[879:872]));
  gf_mult_by_fd m2660 (.i(rx_data[887:880]),.o(syn_10_tmp[887:880]));
  gf_mult_by_df m2661 (.i(rx_data[895:888]),.o(syn_10_tmp[895:888]));
  gf_mult_by_11 m2662 (.i(rx_data[903:896]),.o(syn_10_tmp[903:896]));
  gf_mult_by_67 m2663 (.i(rx_data[911:904]),.o(syn_10_tmp[911:904]));
  gf_mult_by_3b m2664 (.i(rx_data[919:912]),.o(syn_10_tmp[919:912]));
  gf_mult_by_2e m2665 (.i(rx_data[927:920]),.o(syn_10_tmp[927:920]));
  gf_mult_by_84 m2666 (.i(rx_data[935:928]),.o(syn_10_tmp[935:928]));
  gf_mult_by_55 m2667 (.i(rx_data[943:936]),.o(syn_10_tmp[943:936]));
  gf_mult_by_e6 m2668 (.i(rx_data[951:944]),.o(syn_10_tmp[951:944]));
  gf_mult_by_d7 m2669 (.i(rx_data[959:952]),.o(syn_10_tmp[959:952]));
  gf_mult_by_96 m2670 (.i(rx_data[967:960]),.o(syn_10_tmp[967:960]));
  gf_mult_by_ae m2671 (.i(rx_data[975:968]),.o(syn_10_tmp[975:968]));
  gf_mult_by_1c m2672 (.i(rx_data[983:976]),.o(syn_10_tmp[983:976]));
  gf_mult_by_59 m2673 (.i(rx_data[991:984]),.o(syn_10_tmp[991:984]));
  gf_mult_by_ac m2674 (.i(rx_data[999:992]),.o(syn_10_tmp[999:992]));
  gf_mult_by_f4 m2675 (.i(rx_data[1007:1000]),.o(syn_10_tmp[1007:1000]));
  gf_mult_by_2c m2676 (.i(rx_data[1015:1008]),.o(syn_10_tmp[1015:1008]));
  gf_mult_by_6c m2677 (.i(rx_data[1023:1016]),.o(syn_10_tmp[1023:1016]));
  gf_mult_by_20 m2678 (.i(rx_data[1031:1024]),.o(syn_10_tmp[1031:1024]));
  gf_mult_by_26 m2679 (.i(rx_data[1039:1032]),.o(syn_10_tmp[1039:1032]));
  gf_mult_by_03 m2680 (.i(rx_data[1047:1040]),.o(syn_10_tmp[1047:1040]));
  gf_mult_by_9c m2681 (.i(rx_data[1055:1048]),.o(syn_10_tmp[1055:1048]));
  gf_mult_by_c1 m2682 (.i(rx_data[1063:1056]),.o(syn_10_tmp[1063:1056]));
  gf_mult_by_a0 m2683 (.i(rx_data[1071:1064]),.o(syn_10_tmp[1071:1064]));
  gf_mult_by_be m2684 (.i(rx_data[1079:1072]),.o(syn_10_tmp[1079:1072]));
  gf_mult_by_0f m2685 (.i(rx_data[1087:1080]),.o(syn_10_tmp[1087:1080]));
  gf_mult_by_d6 m2686 (.i(rx_data[1095:1088]),.o(syn_10_tmp[1095:1088]));
  gf_mult_by_e2 m2687 (.i(rx_data[1103:1096]),.o(syn_10_tmp[1103:1096]));
  gf_mult_by_1a m2688 (.i(rx_data[1111:1104]),.o(syn_10_tmp[1111:1104]));
  gf_mult_by_7c m2689 (.i(rx_data[1119:1112]),.o(syn_10_tmp[1119:1112]));
  gf_mult_by_33 m2690 (.i(rx_data[1127:1120]),.o(syn_10_tmp[1127:1120]));
  gf_mult_by_a9 m2691 (.i(rx_data[1135:1128]),.o(syn_10_tmp[1135:1128]));
  gf_mult_by_4d m2692 (.i(rx_data[1143:1136]),.o(syn_10_tmp[1143:1136]));
  gf_mult_by_72 m2693 (.i(rx_data[1151:1144]),.o(syn_10_tmp[1151:1144]));
  gf_mult_by_91 m2694 (.i(rx_data[1159:1152]),.o(syn_10_tmp[1159:1152]));
  gf_mult_by_ff m2695 (.i(rx_data[1167:1160]),.o(syn_10_tmp[1167:1160]));
  gf_mult_by_37 m2696 (.i(rx_data[1175:1168]),.o(syn_10_tmp[1175:1168]));
  gf_mult_by_64 m2697 (.i(rx_data[1183:1176]),.o(syn_10_tmp[1183:1176]));
  gf_mult_by_a7 m2698 (.i(rx_data[1191:1184]),.o(syn_10_tmp[1191:1184]));
  gf_mult_by_ef m2699 (.i(rx_data[1199:1192]),.o(syn_10_tmp[1199:1192]));
  gf_mult_by_24 m2700 (.i(rx_data[1207:1200]),.o(syn_10_tmp[1207:1200]));
  gf_mult_by_eb m2701 (.i(rx_data[1215:1208]),.o(syn_10_tmp[1215:1208]));
  gf_mult_by_e9 m2702 (.i(rx_data[1223:1216]),.o(syn_10_tmp[1223:1216]));
  gf_mult_by_01 m2703 (.i(rx_data[1231:1224]),.o(syn_10_tmp[1231:1224]));
  gf_mult_by_74 m2704 (.i(rx_data[1239:1232]),.o(syn_10_tmp[1239:1232]));
  gf_mult_by_b4 m2705 (.i(rx_data[1247:1240]),.o(syn_10_tmp[1247:1240]));
  gf_mult_by_60 m2706 (.i(rx_data[1255:1248]),.o(syn_10_tmp[1255:1248]));
  gf_mult_by_6a m2707 (.i(rx_data[1263:1256]),.o(syn_10_tmp[1263:1256]));
  gf_mult_by_05 m2708 (.i(rx_data[1271:1264]),.o(syn_10_tmp[1271:1264]));
  gf_mult_by_b9 m2709 (.i(rx_data[1279:1272]),.o(syn_10_tmp[1279:1272]));
  gf_mult_by_5e m2710 (.i(rx_data[1287:1280]),.o(syn_10_tmp[1287:1280]));
  gf_mult_by_fd m2711 (.i(rx_data[1295:1288]),.o(syn_10_tmp[1295:1288]));
  gf_mult_by_df m2712 (.i(rx_data[1303:1296]),.o(syn_10_tmp[1303:1296]));
  gf_mult_by_11 m2713 (.i(rx_data[1311:1304]),.o(syn_10_tmp[1311:1304]));
  gf_mult_by_67 m2714 (.i(rx_data[1319:1312]),.o(syn_10_tmp[1319:1312]));
  gf_mult_by_3b m2715 (.i(rx_data[1327:1320]),.o(syn_10_tmp[1327:1320]));
  gf_mult_by_2e m2716 (.i(rx_data[1335:1328]),.o(syn_10_tmp[1335:1328]));
  gf_mult_by_84 m2717 (.i(rx_data[1343:1336]),.o(syn_10_tmp[1343:1336]));
  gf_mult_by_55 m2718 (.i(rx_data[1351:1344]),.o(syn_10_tmp[1351:1344]));
  gf_mult_by_e6 m2719 (.i(rx_data[1359:1352]),.o(syn_10_tmp[1359:1352]));
  gf_mult_by_d7 m2720 (.i(rx_data[1367:1360]),.o(syn_10_tmp[1367:1360]));
  gf_mult_by_96 m2721 (.i(rx_data[1375:1368]),.o(syn_10_tmp[1375:1368]));
  gf_mult_by_ae m2722 (.i(rx_data[1383:1376]),.o(syn_10_tmp[1383:1376]));
  gf_mult_by_1c m2723 (.i(rx_data[1391:1384]),.o(syn_10_tmp[1391:1384]));
  gf_mult_by_59 m2724 (.i(rx_data[1399:1392]),.o(syn_10_tmp[1399:1392]));
  gf_mult_by_ac m2725 (.i(rx_data[1407:1400]),.o(syn_10_tmp[1407:1400]));
  gf_mult_by_f4 m2726 (.i(rx_data[1415:1408]),.o(syn_10_tmp[1415:1408]));
  gf_mult_by_2c m2727 (.i(rx_data[1423:1416]),.o(syn_10_tmp[1423:1416]));
  gf_mult_by_6c m2728 (.i(rx_data[1431:1424]),.o(syn_10_tmp[1431:1424]));
  gf_mult_by_20 m2729 (.i(rx_data[1439:1432]),.o(syn_10_tmp[1439:1432]));
  gf_mult_by_26 m2730 (.i(rx_data[1447:1440]),.o(syn_10_tmp[1447:1440]));
  gf_mult_by_03 m2731 (.i(rx_data[1455:1448]),.o(syn_10_tmp[1455:1448]));
  gf_mult_by_9c m2732 (.i(rx_data[1463:1456]),.o(syn_10_tmp[1463:1456]));
  gf_mult_by_c1 m2733 (.i(rx_data[1471:1464]),.o(syn_10_tmp[1471:1464]));
  gf_mult_by_a0 m2734 (.i(rx_data[1479:1472]),.o(syn_10_tmp[1479:1472]));
  gf_mult_by_be m2735 (.i(rx_data[1487:1480]),.o(syn_10_tmp[1487:1480]));
  gf_mult_by_0f m2736 (.i(rx_data[1495:1488]),.o(syn_10_tmp[1495:1488]));
  gf_mult_by_d6 m2737 (.i(rx_data[1503:1496]),.o(syn_10_tmp[1503:1496]));
  gf_mult_by_e2 m2738 (.i(rx_data[1511:1504]),.o(syn_10_tmp[1511:1504]));
  gf_mult_by_1a m2739 (.i(rx_data[1519:1512]),.o(syn_10_tmp[1519:1512]));
  gf_mult_by_7c m2740 (.i(rx_data[1527:1520]),.o(syn_10_tmp[1527:1520]));
  gf_mult_by_33 m2741 (.i(rx_data[1535:1528]),.o(syn_10_tmp[1535:1528]));
  gf_mult_by_a9 m2742 (.i(rx_data[1543:1536]),.o(syn_10_tmp[1543:1536]));
  gf_mult_by_4d m2743 (.i(rx_data[1551:1544]),.o(syn_10_tmp[1551:1544]));
  gf_mult_by_72 m2744 (.i(rx_data[1559:1552]),.o(syn_10_tmp[1559:1552]));
  gf_mult_by_91 m2745 (.i(rx_data[1567:1560]),.o(syn_10_tmp[1567:1560]));
  gf_mult_by_ff m2746 (.i(rx_data[1575:1568]),.o(syn_10_tmp[1575:1568]));
  gf_mult_by_37 m2747 (.i(rx_data[1583:1576]),.o(syn_10_tmp[1583:1576]));
  gf_mult_by_64 m2748 (.i(rx_data[1591:1584]),.o(syn_10_tmp[1591:1584]));
  gf_mult_by_a7 m2749 (.i(rx_data[1599:1592]),.o(syn_10_tmp[1599:1592]));
  gf_mult_by_ef m2750 (.i(rx_data[1607:1600]),.o(syn_10_tmp[1607:1600]));
  gf_mult_by_24 m2751 (.i(rx_data[1615:1608]),.o(syn_10_tmp[1615:1608]));
  gf_mult_by_eb m2752 (.i(rx_data[1623:1616]),.o(syn_10_tmp[1623:1616]));
  gf_mult_by_e9 m2753 (.i(rx_data[1631:1624]),.o(syn_10_tmp[1631:1624]));
  gf_mult_by_01 m2754 (.i(rx_data[1639:1632]),.o(syn_10_tmp[1639:1632]));
  gf_mult_by_74 m2755 (.i(rx_data[1647:1640]),.o(syn_10_tmp[1647:1640]));
  gf_mult_by_b4 m2756 (.i(rx_data[1655:1648]),.o(syn_10_tmp[1655:1648]));
  gf_mult_by_60 m2757 (.i(rx_data[1663:1656]),.o(syn_10_tmp[1663:1656]));
  gf_mult_by_6a m2758 (.i(rx_data[1671:1664]),.o(syn_10_tmp[1671:1664]));
  gf_mult_by_05 m2759 (.i(rx_data[1679:1672]),.o(syn_10_tmp[1679:1672]));
  gf_mult_by_b9 m2760 (.i(rx_data[1687:1680]),.o(syn_10_tmp[1687:1680]));
  gf_mult_by_5e m2761 (.i(rx_data[1695:1688]),.o(syn_10_tmp[1695:1688]));
  gf_mult_by_fd m2762 (.i(rx_data[1703:1696]),.o(syn_10_tmp[1703:1696]));
  gf_mult_by_df m2763 (.i(rx_data[1711:1704]),.o(syn_10_tmp[1711:1704]));
  gf_mult_by_11 m2764 (.i(rx_data[1719:1712]),.o(syn_10_tmp[1719:1712]));
  gf_mult_by_67 m2765 (.i(rx_data[1727:1720]),.o(syn_10_tmp[1727:1720]));
  gf_mult_by_3b m2766 (.i(rx_data[1735:1728]),.o(syn_10_tmp[1735:1728]));
  gf_mult_by_2e m2767 (.i(rx_data[1743:1736]),.o(syn_10_tmp[1743:1736]));
  gf_mult_by_84 m2768 (.i(rx_data[1751:1744]),.o(syn_10_tmp[1751:1744]));
  gf_mult_by_55 m2769 (.i(rx_data[1759:1752]),.o(syn_10_tmp[1759:1752]));
  gf_mult_by_e6 m2770 (.i(rx_data[1767:1760]),.o(syn_10_tmp[1767:1760]));
  gf_mult_by_d7 m2771 (.i(rx_data[1775:1768]),.o(syn_10_tmp[1775:1768]));
  gf_mult_by_96 m2772 (.i(rx_data[1783:1776]),.o(syn_10_tmp[1783:1776]));
  gf_mult_by_ae m2773 (.i(rx_data[1791:1784]),.o(syn_10_tmp[1791:1784]));
  gf_mult_by_1c m2774 (.i(rx_data[1799:1792]),.o(syn_10_tmp[1799:1792]));
  gf_mult_by_59 m2775 (.i(rx_data[1807:1800]),.o(syn_10_tmp[1807:1800]));
  gf_mult_by_ac m2776 (.i(rx_data[1815:1808]),.o(syn_10_tmp[1815:1808]));
  gf_mult_by_f4 m2777 (.i(rx_data[1823:1816]),.o(syn_10_tmp[1823:1816]));
  gf_mult_by_2c m2778 (.i(rx_data[1831:1824]),.o(syn_10_tmp[1831:1824]));
  gf_mult_by_6c m2779 (.i(rx_data[1839:1832]),.o(syn_10_tmp[1839:1832]));
  gf_mult_by_20 m2780 (.i(rx_data[1847:1840]),.o(syn_10_tmp[1847:1840]));
  gf_mult_by_26 m2781 (.i(rx_data[1855:1848]),.o(syn_10_tmp[1855:1848]));
  gf_mult_by_03 m2782 (.i(rx_data[1863:1856]),.o(syn_10_tmp[1863:1856]));
  gf_mult_by_9c m2783 (.i(rx_data[1871:1864]),.o(syn_10_tmp[1871:1864]));
  gf_mult_by_c1 m2784 (.i(rx_data[1879:1872]),.o(syn_10_tmp[1879:1872]));
  gf_mult_by_a0 m2785 (.i(rx_data[1887:1880]),.o(syn_10_tmp[1887:1880]));
  gf_mult_by_be m2786 (.i(rx_data[1895:1888]),.o(syn_10_tmp[1895:1888]));
  gf_mult_by_0f m2787 (.i(rx_data[1903:1896]),.o(syn_10_tmp[1903:1896]));
  gf_mult_by_d6 m2788 (.i(rx_data[1911:1904]),.o(syn_10_tmp[1911:1904]));
  gf_mult_by_e2 m2789 (.i(rx_data[1919:1912]),.o(syn_10_tmp[1919:1912]));
  gf_mult_by_1a m2790 (.i(rx_data[1927:1920]),.o(syn_10_tmp[1927:1920]));
  gf_mult_by_7c m2791 (.i(rx_data[1935:1928]),.o(syn_10_tmp[1935:1928]));
  gf_mult_by_33 m2792 (.i(rx_data[1943:1936]),.o(syn_10_tmp[1943:1936]));
  gf_mult_by_a9 m2793 (.i(rx_data[1951:1944]),.o(syn_10_tmp[1951:1944]));
  gf_mult_by_4d m2794 (.i(rx_data[1959:1952]),.o(syn_10_tmp[1959:1952]));
  gf_mult_by_72 m2795 (.i(rx_data[1967:1960]),.o(syn_10_tmp[1967:1960]));
  gf_mult_by_91 m2796 (.i(rx_data[1975:1968]),.o(syn_10_tmp[1975:1968]));
  gf_mult_by_ff m2797 (.i(rx_data[1983:1976]),.o(syn_10_tmp[1983:1976]));
  gf_mult_by_37 m2798 (.i(rx_data[1991:1984]),.o(syn_10_tmp[1991:1984]));
  gf_mult_by_64 m2799 (.i(rx_data[1999:1992]),.o(syn_10_tmp[1999:1992]));
  gf_mult_by_a7 m2800 (.i(rx_data[2007:2000]),.o(syn_10_tmp[2007:2000]));
  gf_mult_by_ef m2801 (.i(rx_data[2015:2008]),.o(syn_10_tmp[2015:2008]));
  gf_mult_by_24 m2802 (.i(rx_data[2023:2016]),.o(syn_10_tmp[2023:2016]));
  gf_mult_by_eb m2803 (.i(rx_data[2031:2024]),.o(syn_10_tmp[2031:2024]));
  gf_mult_by_e9 m2804 (.i(rx_data[2039:2032]),.o(syn_10_tmp[2039:2032]));
  assign syndrome[87:80] =
      syn_10_tmp[7:0] ^ syn_10_tmp[15:8] ^ syn_10_tmp[23:16] ^ 
      syn_10_tmp[31:24] ^ syn_10_tmp[39:32] ^ syn_10_tmp[47:40] ^ 
      syn_10_tmp[55:48] ^ syn_10_tmp[63:56] ^ syn_10_tmp[71:64] ^ 
      syn_10_tmp[79:72] ^ syn_10_tmp[87:80] ^ syn_10_tmp[95:88] ^ 
      syn_10_tmp[103:96] ^ syn_10_tmp[111:104] ^ syn_10_tmp[119:112] ^ 
      syn_10_tmp[127:120] ^ syn_10_tmp[135:128] ^ syn_10_tmp[143:136] ^ 
      syn_10_tmp[151:144] ^ syn_10_tmp[159:152] ^ syn_10_tmp[167:160] ^ 
      syn_10_tmp[175:168] ^ syn_10_tmp[183:176] ^ syn_10_tmp[191:184] ^ 
      syn_10_tmp[199:192] ^ syn_10_tmp[207:200] ^ syn_10_tmp[215:208] ^ 
      syn_10_tmp[223:216] ^ syn_10_tmp[231:224] ^ syn_10_tmp[239:232] ^ 
      syn_10_tmp[247:240] ^ syn_10_tmp[255:248] ^ syn_10_tmp[263:256] ^ 
      syn_10_tmp[271:264] ^ syn_10_tmp[279:272] ^ syn_10_tmp[287:280] ^ 
      syn_10_tmp[295:288] ^ syn_10_tmp[303:296] ^ syn_10_tmp[311:304] ^ 
      syn_10_tmp[319:312] ^ syn_10_tmp[327:320] ^ syn_10_tmp[335:328] ^ 
      syn_10_tmp[343:336] ^ syn_10_tmp[351:344] ^ syn_10_tmp[359:352] ^ 
      syn_10_tmp[367:360] ^ syn_10_tmp[375:368] ^ syn_10_tmp[383:376] ^ 
      syn_10_tmp[391:384] ^ syn_10_tmp[399:392] ^ syn_10_tmp[407:400] ^ 
      syn_10_tmp[415:408] ^ syn_10_tmp[423:416] ^ syn_10_tmp[431:424] ^ 
      syn_10_tmp[439:432] ^ syn_10_tmp[447:440] ^ syn_10_tmp[455:448] ^ 
      syn_10_tmp[463:456] ^ syn_10_tmp[471:464] ^ syn_10_tmp[479:472] ^ 
      syn_10_tmp[487:480] ^ syn_10_tmp[495:488] ^ syn_10_tmp[503:496] ^ 
      syn_10_tmp[511:504] ^ syn_10_tmp[519:512] ^ syn_10_tmp[527:520] ^ 
      syn_10_tmp[535:528] ^ syn_10_tmp[543:536] ^ syn_10_tmp[551:544] ^ 
      syn_10_tmp[559:552] ^ syn_10_tmp[567:560] ^ syn_10_tmp[575:568] ^ 
      syn_10_tmp[583:576] ^ syn_10_tmp[591:584] ^ syn_10_tmp[599:592] ^ 
      syn_10_tmp[607:600] ^ syn_10_tmp[615:608] ^ syn_10_tmp[623:616] ^ 
      syn_10_tmp[631:624] ^ syn_10_tmp[639:632] ^ syn_10_tmp[647:640] ^ 
      syn_10_tmp[655:648] ^ syn_10_tmp[663:656] ^ syn_10_tmp[671:664] ^ 
      syn_10_tmp[679:672] ^ syn_10_tmp[687:680] ^ syn_10_tmp[695:688] ^ 
      syn_10_tmp[703:696] ^ syn_10_tmp[711:704] ^ syn_10_tmp[719:712] ^ 
      syn_10_tmp[727:720] ^ syn_10_tmp[735:728] ^ syn_10_tmp[743:736] ^ 
      syn_10_tmp[751:744] ^ syn_10_tmp[759:752] ^ syn_10_tmp[767:760] ^ 
      syn_10_tmp[775:768] ^ syn_10_tmp[783:776] ^ syn_10_tmp[791:784] ^ 
      syn_10_tmp[799:792] ^ syn_10_tmp[807:800] ^ syn_10_tmp[815:808] ^ 
      syn_10_tmp[823:816] ^ syn_10_tmp[831:824] ^ syn_10_tmp[839:832] ^ 
      syn_10_tmp[847:840] ^ syn_10_tmp[855:848] ^ syn_10_tmp[863:856] ^ 
      syn_10_tmp[871:864] ^ syn_10_tmp[879:872] ^ syn_10_tmp[887:880] ^ 
      syn_10_tmp[895:888] ^ syn_10_tmp[903:896] ^ syn_10_tmp[911:904] ^ 
      syn_10_tmp[919:912] ^ syn_10_tmp[927:920] ^ syn_10_tmp[935:928] ^ 
      syn_10_tmp[943:936] ^ syn_10_tmp[951:944] ^ syn_10_tmp[959:952] ^ 
      syn_10_tmp[967:960] ^ syn_10_tmp[975:968] ^ syn_10_tmp[983:976] ^ 
      syn_10_tmp[991:984] ^ syn_10_tmp[999:992] ^ syn_10_tmp[1007:1000] ^ 
      syn_10_tmp[1015:1008] ^ syn_10_tmp[1023:1016] ^ syn_10_tmp[1031:1024] ^ 
      syn_10_tmp[1039:1032] ^ syn_10_tmp[1047:1040] ^ syn_10_tmp[1055:1048] ^ 
      syn_10_tmp[1063:1056] ^ syn_10_tmp[1071:1064] ^ syn_10_tmp[1079:1072] ^ 
      syn_10_tmp[1087:1080] ^ syn_10_tmp[1095:1088] ^ syn_10_tmp[1103:1096] ^ 
      syn_10_tmp[1111:1104] ^ syn_10_tmp[1119:1112] ^ syn_10_tmp[1127:1120] ^ 
      syn_10_tmp[1135:1128] ^ syn_10_tmp[1143:1136] ^ syn_10_tmp[1151:1144] ^ 
      syn_10_tmp[1159:1152] ^ syn_10_tmp[1167:1160] ^ syn_10_tmp[1175:1168] ^ 
      syn_10_tmp[1183:1176] ^ syn_10_tmp[1191:1184] ^ syn_10_tmp[1199:1192] ^ 
      syn_10_tmp[1207:1200] ^ syn_10_tmp[1215:1208] ^ syn_10_tmp[1223:1216] ^ 
      syn_10_tmp[1231:1224] ^ syn_10_tmp[1239:1232] ^ syn_10_tmp[1247:1240] ^ 
      syn_10_tmp[1255:1248] ^ syn_10_tmp[1263:1256] ^ syn_10_tmp[1271:1264] ^ 
      syn_10_tmp[1279:1272] ^ syn_10_tmp[1287:1280] ^ syn_10_tmp[1295:1288] ^ 
      syn_10_tmp[1303:1296] ^ syn_10_tmp[1311:1304] ^ syn_10_tmp[1319:1312] ^ 
      syn_10_tmp[1327:1320] ^ syn_10_tmp[1335:1328] ^ syn_10_tmp[1343:1336] ^ 
      syn_10_tmp[1351:1344] ^ syn_10_tmp[1359:1352] ^ syn_10_tmp[1367:1360] ^ 
      syn_10_tmp[1375:1368] ^ syn_10_tmp[1383:1376] ^ syn_10_tmp[1391:1384] ^ 
      syn_10_tmp[1399:1392] ^ syn_10_tmp[1407:1400] ^ syn_10_tmp[1415:1408] ^ 
      syn_10_tmp[1423:1416] ^ syn_10_tmp[1431:1424] ^ syn_10_tmp[1439:1432] ^ 
      syn_10_tmp[1447:1440] ^ syn_10_tmp[1455:1448] ^ syn_10_tmp[1463:1456] ^ 
      syn_10_tmp[1471:1464] ^ syn_10_tmp[1479:1472] ^ syn_10_tmp[1487:1480] ^ 
      syn_10_tmp[1495:1488] ^ syn_10_tmp[1503:1496] ^ syn_10_tmp[1511:1504] ^ 
      syn_10_tmp[1519:1512] ^ syn_10_tmp[1527:1520] ^ syn_10_tmp[1535:1528] ^ 
      syn_10_tmp[1543:1536] ^ syn_10_tmp[1551:1544] ^ syn_10_tmp[1559:1552] ^ 
      syn_10_tmp[1567:1560] ^ syn_10_tmp[1575:1568] ^ syn_10_tmp[1583:1576] ^ 
      syn_10_tmp[1591:1584] ^ syn_10_tmp[1599:1592] ^ syn_10_tmp[1607:1600] ^ 
      syn_10_tmp[1615:1608] ^ syn_10_tmp[1623:1616] ^ syn_10_tmp[1631:1624] ^ 
      syn_10_tmp[1639:1632] ^ syn_10_tmp[1647:1640] ^ syn_10_tmp[1655:1648] ^ 
      syn_10_tmp[1663:1656] ^ syn_10_tmp[1671:1664] ^ syn_10_tmp[1679:1672] ^ 
      syn_10_tmp[1687:1680] ^ syn_10_tmp[1695:1688] ^ syn_10_tmp[1703:1696] ^ 
      syn_10_tmp[1711:1704] ^ syn_10_tmp[1719:1712] ^ syn_10_tmp[1727:1720] ^ 
      syn_10_tmp[1735:1728] ^ syn_10_tmp[1743:1736] ^ syn_10_tmp[1751:1744] ^ 
      syn_10_tmp[1759:1752] ^ syn_10_tmp[1767:1760] ^ syn_10_tmp[1775:1768] ^ 
      syn_10_tmp[1783:1776] ^ syn_10_tmp[1791:1784] ^ syn_10_tmp[1799:1792] ^ 
      syn_10_tmp[1807:1800] ^ syn_10_tmp[1815:1808] ^ syn_10_tmp[1823:1816] ^ 
      syn_10_tmp[1831:1824] ^ syn_10_tmp[1839:1832] ^ syn_10_tmp[1847:1840] ^ 
      syn_10_tmp[1855:1848] ^ syn_10_tmp[1863:1856] ^ syn_10_tmp[1871:1864] ^ 
      syn_10_tmp[1879:1872] ^ syn_10_tmp[1887:1880] ^ syn_10_tmp[1895:1888] ^ 
      syn_10_tmp[1903:1896] ^ syn_10_tmp[1911:1904] ^ syn_10_tmp[1919:1912] ^ 
      syn_10_tmp[1927:1920] ^ syn_10_tmp[1935:1928] ^ syn_10_tmp[1943:1936] ^ 
      syn_10_tmp[1951:1944] ^ syn_10_tmp[1959:1952] ^ syn_10_tmp[1967:1960] ^ 
      syn_10_tmp[1975:1968] ^ syn_10_tmp[1983:1976] ^ syn_10_tmp[1991:1984] ^ 
      syn_10_tmp[1999:1992] ^ syn_10_tmp[2007:2000] ^ syn_10_tmp[2015:2008] ^ 
      syn_10_tmp[2023:2016] ^ syn_10_tmp[2031:2024] ^ syn_10_tmp[2039:2032];

// syndrome 11
  wire [2039:0] syn_11_tmp;
  gf_mult_by_01 m2805 (.i(rx_data[7:0]),.o(syn_11_tmp[7:0]));
  gf_mult_by_e8 m2806 (.i(rx_data[15:8]),.o(syn_11_tmp[15:8]));
  gf_mult_by_ea m2807 (.i(rx_data[23:16]),.o(syn_11_tmp[23:16]));
  gf_mult_by_27 m2808 (.i(rx_data[31:24]),.o(syn_11_tmp[31:24]));
  gf_mult_by_ee m2809 (.i(rx_data[39:32]),.o(syn_11_tmp[39:32]));
  gf_mult_by_a0 m2810 (.i(rx_data[47:40]),.o(syn_11_tmp[47:40]));
  gf_mult_by_61 m2811 (.i(rx_data[55:48]),.o(syn_11_tmp[55:48]));
  gf_mult_by_3c m2812 (.i(rx_data[63:56]),.o(syn_11_tmp[63:56]));
  gf_mult_by_fe m2813 (.i(rx_data[71:64]),.o(syn_11_tmp[71:64]));
  gf_mult_by_86 m2814 (.i(rx_data[79:72]),.o(syn_11_tmp[79:72]));
  gf_mult_by_67 m2815 (.i(rx_data[87:80]),.o(syn_11_tmp[87:80]));
  gf_mult_by_76 m2816 (.i(rx_data[95:88]),.o(syn_11_tmp[95:88]));
  gf_mult_by_b8 m2817 (.i(rx_data[103:96]),.o(syn_11_tmp[103:96]));
  gf_mult_by_54 m2818 (.i(rx_data[111:104]),.o(syn_11_tmp[111:104]));
  gf_mult_by_39 m2819 (.i(rx_data[119:112]),.o(syn_11_tmp[119:112]));
  gf_mult_by_91 m2820 (.i(rx_data[127:120]),.o(syn_11_tmp[127:120]));
  gf_mult_by_e3 m2821 (.i(rx_data[135:128]),.o(syn_11_tmp[135:128]));
  gf_mult_by_dc m2822 (.i(rx_data[143:136]),.o(syn_11_tmp[143:136]));
  gf_mult_by_07 m2823 (.i(rx_data[151:144]),.o(syn_11_tmp[151:144]));
  gf_mult_by_a2 m2824 (.i(rx_data[159:152]),.o(syn_11_tmp[159:152]));
  gf_mult_by_ac m2825 (.i(rx_data[167:160]),.o(syn_11_tmp[167:160]));
  gf_mult_by_f5 m2826 (.i(rx_data[175:168]),.o(syn_11_tmp[175:168]));
  gf_mult_by_b0 m2827 (.i(rx_data[183:176]),.o(syn_11_tmp[183:176]));
  gf_mult_by_47 m2828 (.i(rx_data[191:184]),.o(syn_11_tmp[191:184]));
  gf_mult_by_3a m2829 (.i(rx_data[199:192]),.o(syn_11_tmp[199:192]));
  gf_mult_by_b4 m2830 (.i(rx_data[207:200]),.o(syn_11_tmp[207:200]));
  gf_mult_by_c0 m2831 (.i(rx_data[215:208]),.o(syn_11_tmp[215:208]));
  gf_mult_by_b5 m2832 (.i(rx_data[223:216]),.o(syn_11_tmp[223:216]));
  gf_mult_by_28 m2833 (.i(rx_data[231:224]),.o(syn_11_tmp[231:224]));
  gf_mult_by_5f m2834 (.i(rx_data[239:232]),.o(syn_11_tmp[239:232]));
  gf_mult_by_0f m2835 (.i(rx_data[247:240]),.o(syn_11_tmp[247:240]));
  gf_mult_by_b1 m2836 (.i(rx_data[255:248]),.o(syn_11_tmp[255:248]));
  gf_mult_by_af m2837 (.i(rx_data[263:256]),.o(syn_11_tmp[263:256]));
  gf_mult_by_d0 m2838 (.i(rx_data[271:264]),.o(syn_11_tmp[271:264]));
  gf_mult_by_93 m2839 (.i(rx_data[279:272]),.o(syn_11_tmp[279:272]));
  gf_mult_by_2e m2840 (.i(rx_data[287:280]),.o(syn_11_tmp[287:280]));
  gf_mult_by_15 m2841 (.i(rx_data[295:288]),.o(syn_11_tmp[295:288]));
  gf_mult_by_49 m2842 (.i(rx_data[303:296]),.o(syn_11_tmp[303:296]));
  gf_mult_by_63 m2843 (.i(rx_data[311:304]),.o(syn_11_tmp[311:304]));
  gf_mult_by_f1 m2844 (.i(rx_data[319:312]),.o(syn_11_tmp[319:312]));
  gf_mult_by_37 m2845 (.i(rx_data[327:320]),.o(syn_11_tmp[327:320]));
  gf_mult_by_c8 m2846 (.i(rx_data[335:328]),.o(syn_11_tmp[335:328]));
  gf_mult_by_a6 m2847 (.i(rx_data[343:336]),.o(syn_11_tmp[343:336]));
  gf_mult_by_2b m2848 (.i(rx_data[351:344]),.o(syn_11_tmp[351:344]));
  gf_mult_by_7a m2849 (.i(rx_data[359:352]),.o(syn_11_tmp[359:352]));
  gf_mult_by_2c m2850 (.i(rx_data[367:360]),.o(syn_11_tmp[367:360]));
  gf_mult_by_d8 m2851 (.i(rx_data[375:368]),.o(syn_11_tmp[375:368]));
  gf_mult_by_80 m2852 (.i(rx_data[383:376]),.o(syn_11_tmp[383:376]));
  gf_mult_by_2d m2853 (.i(rx_data[391:384]),.o(syn_11_tmp[391:384]));
  gf_mult_by_30 m2854 (.i(rx_data[399:392]),.o(syn_11_tmp[399:392]));
  gf_mult_by_6a m2855 (.i(rx_data[407:400]),.o(syn_11_tmp[407:400]));
  gf_mult_by_0a m2856 (.i(rx_data[415:408]),.o(syn_11_tmp[415:408]));
  gf_mult_by_de m2857 (.i(rx_data[423:416]),.o(syn_11_tmp[423:416]));
  gf_mult_by_ca m2858 (.i(rx_data[431:424]),.o(syn_11_tmp[431:424]));
  gf_mult_by_6b m2859 (.i(rx_data[439:432]),.o(syn_11_tmp[439:432]));
  gf_mult_by_e2 m2860 (.i(rx_data[447:440]),.o(syn_11_tmp[447:440]));
  gf_mult_by_34 m2861 (.i(rx_data[455:448]),.o(syn_11_tmp[455:448]));
  gf_mult_by_ed m2862 (.i(rx_data[463:456]),.o(syn_11_tmp[463:456]));
  gf_mult_by_85 m2863 (.i(rx_data[471:464]),.o(syn_11_tmp[471:464]));
  gf_mult_by_42 m2864 (.i(rx_data[479:472]),.o(syn_11_tmp[479:472]));
  gf_mult_by_55 m2865 (.i(rx_data[487:480]),.o(syn_11_tmp[487:480]));
  gf_mult_by_d1 m2866 (.i(rx_data[495:488]),.o(syn_11_tmp[495:488]));
  gf_mult_by_7b m2867 (.i(rx_data[503:496]),.o(syn_11_tmp[503:496]));
  gf_mult_by_c4 m2868 (.i(rx_data[511:504]),.o(syn_11_tmp[511:504]));
  gf_mult_by_32 m2869 (.i(rx_data[519:512]),.o(syn_11_tmp[519:512]));
  gf_mult_by_a7 m2870 (.i(rx_data[527:520]),.o(syn_11_tmp[527:520]));
  gf_mult_by_c3 m2871 (.i(rx_data[535:528]),.o(syn_11_tmp[535:528]));
  gf_mult_by_90 m2872 (.i(rx_data[543:536]),.o(syn_11_tmp[543:536]));
  gf_mult_by_0b m2873 (.i(rx_data[551:544]),.o(syn_11_tmp[551:544]));
  gf_mult_by_36 m2874 (.i(rx_data[559:552]),.o(syn_11_tmp[559:552]));
  gf_mult_by_20 m2875 (.i(rx_data[567:560]),.o(syn_11_tmp[567:560]));
  gf_mult_by_4c m2876 (.i(rx_data[575:568]),.o(syn_11_tmp[575:568]));
  gf_mult_by_0c m2877 (.i(rx_data[583:576]),.o(syn_11_tmp[583:576]));
  gf_mult_by_94 m2878 (.i(rx_data[591:584]),.o(syn_11_tmp[591:584]));
  gf_mult_by_8c m2879 (.i(rx_data[599:592]),.o(syn_11_tmp[599:592]));
  gf_mult_by_b9 m2880 (.i(rx_data[607:600]),.o(syn_11_tmp[607:600]));
  gf_mult_by_bc m2881 (.i(rx_data[615:608]),.o(syn_11_tmp[615:608]));
  gf_mult_by_d3 m2882 (.i(rx_data[623:616]),.o(syn_11_tmp[623:616]));
  gf_mult_by_b6 m2883 (.i(rx_data[631:624]),.o(syn_11_tmp[631:624]));
  gf_mult_by_0d m2884 (.i(rx_data[639:632]),.o(syn_11_tmp[639:632]));
  gf_mult_by_7c m2885 (.i(rx_data[647:640]),.o(syn_11_tmp[647:640]));
  gf_mult_by_66 m2886 (.i(rx_data[655:648]),.o(syn_11_tmp[655:648]));
  gf_mult_by_9e m2887 (.i(rx_data[663:656]),.o(syn_11_tmp[663:656]));
  gf_mult_by_52 m2888 (.i(rx_data[671:664]),.o(syn_11_tmp[671:664]));
  gf_mult_by_73 m2889 (.i(rx_data[679:672]),.o(syn_11_tmp[679:672]));
  gf_mult_by_d7 m2890 (.i(rx_data[687:680]),.o(syn_11_tmp[687:680]));
  gf_mult_by_31 m2891 (.i(rx_data[695:688]),.o(syn_11_tmp[695:688]));
  gf_mult_by_82 m2892 (.i(rx_data[703:696]),.o(syn_11_tmp[703:696]));
  gf_mult_by_e0 m2893 (.i(rx_data[711:704]),.o(syn_11_tmp[711:704]));
  gf_mult_by_f9 m2894 (.i(rx_data[719:712]),.o(syn_11_tmp[719:712]));
  gf_mult_by_24 m2895 (.i(rx_data[727:720]),.o(syn_11_tmp[727:720]));
  gf_mult_by_cb m2896 (.i(rx_data[735:728]),.o(syn_11_tmp[735:728]));
  gf_mult_by_83 m2897 (.i(rx_data[743:736]),.o(syn_11_tmp[743:736]));
  gf_mult_by_08 m2898 (.i(rx_data[751:744]),.o(syn_11_tmp[751:744]));
  gf_mult_by_13 m2899 (.i(rx_data[759:752]),.o(syn_11_tmp[759:752]));
  gf_mult_by_03 m2900 (.i(rx_data[767:760]),.o(syn_11_tmp[767:760]));
  gf_mult_by_25 m2901 (.i(rx_data[775:768]),.o(syn_11_tmp[775:768]));
  gf_mult_by_23 m2902 (.i(rx_data[783:776]),.o(syn_11_tmp[783:776]));
  gf_mult_by_69 m2903 (.i(rx_data[791:784]),.o(syn_11_tmp[791:784]));
  gf_mult_by_2f m2904 (.i(rx_data[799:792]),.o(syn_11_tmp[799:792]));
  gf_mult_by_fd m2905 (.i(rx_data[807:800]),.o(syn_11_tmp[807:800]));
  gf_mult_by_a3 m2906 (.i(rx_data[815:808]),.o(syn_11_tmp[815:808]));
  gf_mult_by_44 m2907 (.i(rx_data[823:816]),.o(syn_11_tmp[823:816]));
  gf_mult_by_1f m2908 (.i(rx_data[831:824]),.o(syn_11_tmp[831:824]));
  gf_mult_by_97 m2909 (.i(rx_data[839:832]),.o(syn_11_tmp[839:832]));
  gf_mult_by_a9 m2910 (.i(rx_data[847:840]),.o(syn_11_tmp[847:840]));
  gf_mult_by_9a m2911 (.i(rx_data[855:848]),.o(syn_11_tmp[855:848]));
  gf_mult_by_d5 m2912 (.i(rx_data[863:856]),.o(syn_11_tmp[863:856]));
  gf_mult_by_fc m2913 (.i(rx_data[871:864]),.o(syn_11_tmp[871:864]));
  gf_mult_by_4b m2914 (.i(rx_data[879:872]),.o(syn_11_tmp[879:872]));
  gf_mult_by_ae m2915 (.i(rx_data[887:880]),.o(syn_11_tmp[887:880]));
  gf_mult_by_38 m2916 (.i(rx_data[895:888]),.o(syn_11_tmp[895:888]));
  gf_mult_by_79 m2917 (.i(rx_data[903:896]),.o(syn_11_tmp[903:896]));
  gf_mult_by_09 m2918 (.i(rx_data[911:904]),.o(syn_11_tmp[911:904]));
  gf_mult_by_fb m2919 (.i(rx_data[919:912]),.o(syn_11_tmp[919:912]));
  gf_mult_by_e9 m2920 (.i(rx_data[927:920]),.o(syn_11_tmp[927:920]));
  gf_mult_by_02 m2921 (.i(rx_data[935:928]),.o(syn_11_tmp[935:928]));
  gf_mult_by_cd m2922 (.i(rx_data[943:936]),.o(syn_11_tmp[943:936]));
  gf_mult_by_c9 m2923 (.i(rx_data[951:944]),.o(syn_11_tmp[951:944]));
  gf_mult_by_4e m2924 (.i(rx_data[959:952]),.o(syn_11_tmp[959:952]));
  gf_mult_by_c1 m2925 (.i(rx_data[967:960]),.o(syn_11_tmp[967:960]));
  gf_mult_by_5d m2926 (.i(rx_data[975:968]),.o(syn_11_tmp[975:968]));
  gf_mult_by_c2 m2927 (.i(rx_data[983:976]),.o(syn_11_tmp[983:976]));
  gf_mult_by_78 m2928 (.i(rx_data[991:984]),.o(syn_11_tmp[991:984]));
  gf_mult_by_e1 m2929 (.i(rx_data[999:992]),.o(syn_11_tmp[999:992]));
  gf_mult_by_11 m2930 (.i(rx_data[1007:1000]),.o(syn_11_tmp[1007:1000]));
  gf_mult_by_ce m2931 (.i(rx_data[1015:1008]),.o(syn_11_tmp[1015:1008]));
  gf_mult_by_ec m2932 (.i(rx_data[1023:1016]),.o(syn_11_tmp[1023:1016]));
  gf_mult_by_6d m2933 (.i(rx_data[1031:1024]),.o(syn_11_tmp[1031:1024]));
  gf_mult_by_a8 m2934 (.i(rx_data[1039:1032]),.o(syn_11_tmp[1039:1032]));
  gf_mult_by_72 m2935 (.i(rx_data[1047:1040]),.o(syn_11_tmp[1047:1040]));
  gf_mult_by_3f m2936 (.i(rx_data[1055:1048]),.o(syn_11_tmp[1055:1048]));
  gf_mult_by_db m2937 (.i(rx_data[1063:1056]),.o(syn_11_tmp[1063:1056]));
  gf_mult_by_a5 m2938 (.i(rx_data[1071:1064]),.o(syn_11_tmp[1071:1064]));
  gf_mult_by_0e m2939 (.i(rx_data[1079:1072]),.o(syn_11_tmp[1079:1072]));
  gf_mult_by_59 m2940 (.i(rx_data[1087:1080]),.o(syn_11_tmp[1087:1080]));
  gf_mult_by_45 m2941 (.i(rx_data[1095:1088]),.o(syn_11_tmp[1095:1088]));
  gf_mult_by_f7 m2942 (.i(rx_data[1103:1096]),.o(syn_11_tmp[1103:1096]));
  gf_mult_by_7d m2943 (.i(rx_data[1111:1104]),.o(syn_11_tmp[1111:1104]));
  gf_mult_by_8e m2944 (.i(rx_data[1119:1112]),.o(syn_11_tmp[1119:1112]));
  gf_mult_by_74 m2945 (.i(rx_data[1127:1120]),.o(syn_11_tmp[1127:1120]));
  gf_mult_by_75 m2946 (.i(rx_data[1135:1128]),.o(syn_11_tmp[1135:1128]));
  gf_mult_by_9d m2947 (.i(rx_data[1143:1136]),.o(syn_11_tmp[1143:1136]));
  gf_mult_by_77 m2948 (.i(rx_data[1151:1144]),.o(syn_11_tmp[1151:1144]));
  gf_mult_by_50 m2949 (.i(rx_data[1159:1152]),.o(syn_11_tmp[1159:1152]));
  gf_mult_by_be m2950 (.i(rx_data[1167:1160]),.o(syn_11_tmp[1167:1160]));
  gf_mult_by_1e m2951 (.i(rx_data[1175:1168]),.o(syn_11_tmp[1175:1168]));
  gf_mult_by_7f m2952 (.i(rx_data[1183:1176]),.o(syn_11_tmp[1183:1176]));
  gf_mult_by_43 m2953 (.i(rx_data[1191:1184]),.o(syn_11_tmp[1191:1184]));
  gf_mult_by_bd m2954 (.i(rx_data[1199:1192]),.o(syn_11_tmp[1199:1192]));
  gf_mult_by_3b m2955 (.i(rx_data[1207:1200]),.o(syn_11_tmp[1207:1200]));
  gf_mult_by_5c m2956 (.i(rx_data[1215:1208]),.o(syn_11_tmp[1215:1208]));
  gf_mult_by_2a m2957 (.i(rx_data[1223:1216]),.o(syn_11_tmp[1223:1216]));
  gf_mult_by_92 m2958 (.i(rx_data[1231:1224]),.o(syn_11_tmp[1231:1224]));
  gf_mult_by_c6 m2959 (.i(rx_data[1239:1232]),.o(syn_11_tmp[1239:1232]));
  gf_mult_by_ff m2960 (.i(rx_data[1247:1240]),.o(syn_11_tmp[1247:1240]));
  gf_mult_by_6e m2961 (.i(rx_data[1255:1248]),.o(syn_11_tmp[1255:1248]));
  gf_mult_by_8d m2962 (.i(rx_data[1263:1256]),.o(syn_11_tmp[1263:1256]));
  gf_mult_by_51 m2963 (.i(rx_data[1271:1264]),.o(syn_11_tmp[1271:1264]));
  gf_mult_by_56 m2964 (.i(rx_data[1279:1272]),.o(syn_11_tmp[1279:1272]));
  gf_mult_by_f4 m2965 (.i(rx_data[1287:1280]),.o(syn_11_tmp[1287:1280]));
  gf_mult_by_58 m2966 (.i(rx_data[1295:1288]),.o(syn_11_tmp[1295:1288]));
  gf_mult_by_ad m2967 (.i(rx_data[1303:1296]),.o(syn_11_tmp[1303:1296]));
  gf_mult_by_1d m2968 (.i(rx_data[1311:1304]),.o(syn_11_tmp[1311:1304]));
  gf_mult_by_5a m2969 (.i(rx_data[1319:1312]),.o(syn_11_tmp[1319:1312]));
  gf_mult_by_60 m2970 (.i(rx_data[1327:1320]),.o(syn_11_tmp[1327:1320]));
  gf_mult_by_d4 m2971 (.i(rx_data[1335:1328]),.o(syn_11_tmp[1335:1328]));
  gf_mult_by_14 m2972 (.i(rx_data[1343:1336]),.o(syn_11_tmp[1343:1336]));
  gf_mult_by_a1 m2973 (.i(rx_data[1351:1344]),.o(syn_11_tmp[1351:1344]));
  gf_mult_by_89 m2974 (.i(rx_data[1359:1352]),.o(syn_11_tmp[1359:1352]));
  gf_mult_by_d6 m2975 (.i(rx_data[1367:1360]),.o(syn_11_tmp[1367:1360]));
  gf_mult_by_d9 m2976 (.i(rx_data[1375:1368]),.o(syn_11_tmp[1375:1368]));
  gf_mult_by_68 m2977 (.i(rx_data[1383:1376]),.o(syn_11_tmp[1383:1376]));
  gf_mult_by_c7 m2978 (.i(rx_data[1391:1384]),.o(syn_11_tmp[1391:1384]));
  gf_mult_by_17 m2979 (.i(rx_data[1399:1392]),.o(syn_11_tmp[1399:1392]));
  gf_mult_by_84 m2980 (.i(rx_data[1407:1400]),.o(syn_11_tmp[1407:1400]));
  gf_mult_by_aa m2981 (.i(rx_data[1415:1408]),.o(syn_11_tmp[1415:1408]));
  gf_mult_by_bf m2982 (.i(rx_data[1423:1416]),.o(syn_11_tmp[1423:1416]));
  gf_mult_by_f6 m2983 (.i(rx_data[1431:1424]),.o(syn_11_tmp[1431:1424]));
  gf_mult_by_95 m2984 (.i(rx_data[1439:1432]),.o(syn_11_tmp[1439:1432]));
  gf_mult_by_64 m2985 (.i(rx_data[1447:1440]),.o(syn_11_tmp[1447:1440]));
  gf_mult_by_53 m2986 (.i(rx_data[1455:1448]),.o(syn_11_tmp[1455:1448]));
  gf_mult_by_9b m2987 (.i(rx_data[1463:1456]),.o(syn_11_tmp[1463:1456]));
  gf_mult_by_3d m2988 (.i(rx_data[1471:1464]),.o(syn_11_tmp[1471:1464]));
  gf_mult_by_16 m2989 (.i(rx_data[1479:1472]),.o(syn_11_tmp[1479:1472]));
  gf_mult_by_6c m2990 (.i(rx_data[1487:1480]),.o(syn_11_tmp[1487:1480]));
  gf_mult_by_40 m2991 (.i(rx_data[1495:1488]),.o(syn_11_tmp[1495:1488]));
  gf_mult_by_98 m2992 (.i(rx_data[1503:1496]),.o(syn_11_tmp[1503:1496]));
  gf_mult_by_18 m2993 (.i(rx_data[1511:1504]),.o(syn_11_tmp[1511:1504]));
  gf_mult_by_35 m2994 (.i(rx_data[1519:1512]),.o(syn_11_tmp[1519:1512]));
  gf_mult_by_05 m2995 (.i(rx_data[1527:1520]),.o(syn_11_tmp[1527:1520]));
  gf_mult_by_6f m2996 (.i(rx_data[1535:1528]),.o(syn_11_tmp[1535:1528]));
  gf_mult_by_65 m2997 (.i(rx_data[1543:1536]),.o(syn_11_tmp[1543:1536]));
  gf_mult_by_bb m2998 (.i(rx_data[1551:1544]),.o(syn_11_tmp[1551:1544]));
  gf_mult_by_71 m2999 (.i(rx_data[1559:1552]),.o(syn_11_tmp[1559:1552]));
  gf_mult_by_1a m3000 (.i(rx_data[1567:1560]),.o(syn_11_tmp[1567:1560]));
  gf_mult_by_f8 m3001 (.i(rx_data[1575:1568]),.o(syn_11_tmp[1575:1568]));
  gf_mult_by_cc m3002 (.i(rx_data[1583:1576]),.o(syn_11_tmp[1583:1576]));
  gf_mult_by_21 m3003 (.i(rx_data[1591:1584]),.o(syn_11_tmp[1591:1584]));
  gf_mult_by_a4 m3004 (.i(rx_data[1599:1592]),.o(syn_11_tmp[1599:1592]));
  gf_mult_by_e6 m3005 (.i(rx_data[1607:1600]),.o(syn_11_tmp[1607:1600]));
  gf_mult_by_b3 m3006 (.i(rx_data[1615:1608]),.o(syn_11_tmp[1615:1608]));
  gf_mult_by_62 m3007 (.i(rx_data[1623:1616]),.o(syn_11_tmp[1623:1616]));
  gf_mult_by_19 m3008 (.i(rx_data[1631:1624]),.o(syn_11_tmp[1631:1624]));
  gf_mult_by_dd m3009 (.i(rx_data[1639:1632]),.o(syn_11_tmp[1639:1632]));
  gf_mult_by_ef m3010 (.i(rx_data[1647:1640]),.o(syn_11_tmp[1647:1640]));
  gf_mult_by_48 m3011 (.i(rx_data[1655:1648]),.o(syn_11_tmp[1655:1648]));
  gf_mult_by_8b m3012 (.i(rx_data[1663:1656]),.o(syn_11_tmp[1663:1656]));
  gf_mult_by_1b m3013 (.i(rx_data[1671:1664]),.o(syn_11_tmp[1671:1664]));
  gf_mult_by_10 m3014 (.i(rx_data[1679:1672]),.o(syn_11_tmp[1679:1672]));
  gf_mult_by_26 m3015 (.i(rx_data[1687:1680]),.o(syn_11_tmp[1687:1680]));
  gf_mult_by_06 m3016 (.i(rx_data[1695:1688]),.o(syn_11_tmp[1695:1688]));
  gf_mult_by_4a m3017 (.i(rx_data[1703:1696]),.o(syn_11_tmp[1703:1696]));
  gf_mult_by_46 m3018 (.i(rx_data[1711:1704]),.o(syn_11_tmp[1711:1704]));
  gf_mult_by_d2 m3019 (.i(rx_data[1719:1712]),.o(syn_11_tmp[1719:1712]));
  gf_mult_by_5e m3020 (.i(rx_data[1727:1720]),.o(syn_11_tmp[1727:1720]));
  gf_mult_by_e7 m3021 (.i(rx_data[1735:1728]),.o(syn_11_tmp[1735:1728]));
  gf_mult_by_5b m3022 (.i(rx_data[1743:1736]),.o(syn_11_tmp[1743:1736]));
  gf_mult_by_88 m3023 (.i(rx_data[1751:1744]),.o(syn_11_tmp[1751:1744]));
  gf_mult_by_3e m3024 (.i(rx_data[1759:1752]),.o(syn_11_tmp[1759:1752]));
  gf_mult_by_33 m3025 (.i(rx_data[1767:1760]),.o(syn_11_tmp[1767:1760]));
  gf_mult_by_4f m3026 (.i(rx_data[1775:1768]),.o(syn_11_tmp[1775:1768]));
  gf_mult_by_29 m3027 (.i(rx_data[1783:1776]),.o(syn_11_tmp[1783:1776]));
  gf_mult_by_b7 m3028 (.i(rx_data[1791:1784]),.o(syn_11_tmp[1791:1784]));
  gf_mult_by_e5 m3029 (.i(rx_data[1799:1792]),.o(syn_11_tmp[1799:1792]));
  gf_mult_by_96 m3030 (.i(rx_data[1807:1800]),.o(syn_11_tmp[1807:1800]));
  gf_mult_by_41 m3031 (.i(rx_data[1815:1808]),.o(syn_11_tmp[1815:1808]));
  gf_mult_by_70 m3032 (.i(rx_data[1823:1816]),.o(syn_11_tmp[1823:1816]));
  gf_mult_by_f2 m3033 (.i(rx_data[1831:1824]),.o(syn_11_tmp[1831:1824]));
  gf_mult_by_12 m3034 (.i(rx_data[1839:1832]),.o(syn_11_tmp[1839:1832]));
  gf_mult_by_eb m3035 (.i(rx_data[1847:1840]),.o(syn_11_tmp[1847:1840]));
  gf_mult_by_cf m3036 (.i(rx_data[1855:1848]),.o(syn_11_tmp[1855:1848]));
  gf_mult_by_04 m3037 (.i(rx_data[1863:1856]),.o(syn_11_tmp[1863:1856]));
  gf_mult_by_87 m3038 (.i(rx_data[1871:1864]),.o(syn_11_tmp[1871:1864]));
  gf_mult_by_8f m3039 (.i(rx_data[1879:1872]),.o(syn_11_tmp[1879:1872]));
  gf_mult_by_9c m3040 (.i(rx_data[1887:1880]),.o(syn_11_tmp[1887:1880]));
  gf_mult_by_9f m3041 (.i(rx_data[1895:1888]),.o(syn_11_tmp[1895:1888]));
  gf_mult_by_ba m3042 (.i(rx_data[1903:1896]),.o(syn_11_tmp[1903:1896]));
  gf_mult_by_99 m3043 (.i(rx_data[1911:1904]),.o(syn_11_tmp[1911:1904]));
  gf_mult_by_f0 m3044 (.i(rx_data[1919:1912]),.o(syn_11_tmp[1919:1912]));
  gf_mult_by_df m3045 (.i(rx_data[1927:1920]),.o(syn_11_tmp[1927:1920]));
  gf_mult_by_22 m3046 (.i(rx_data[1935:1928]),.o(syn_11_tmp[1935:1928]));
  gf_mult_by_81 m3047 (.i(rx_data[1943:1936]),.o(syn_11_tmp[1943:1936]));
  gf_mult_by_c5 m3048 (.i(rx_data[1951:1944]),.o(syn_11_tmp[1951:1944]));
  gf_mult_by_da m3049 (.i(rx_data[1959:1952]),.o(syn_11_tmp[1959:1952]));
  gf_mult_by_4d m3050 (.i(rx_data[1967:1960]),.o(syn_11_tmp[1967:1960]));
  gf_mult_by_e4 m3051 (.i(rx_data[1975:1968]),.o(syn_11_tmp[1975:1968]));
  gf_mult_by_7e m3052 (.i(rx_data[1983:1976]),.o(syn_11_tmp[1983:1976]));
  gf_mult_by_ab m3053 (.i(rx_data[1991:1984]),.o(syn_11_tmp[1991:1984]));
  gf_mult_by_57 m3054 (.i(rx_data[1999:1992]),.o(syn_11_tmp[1999:1992]));
  gf_mult_by_1c m3055 (.i(rx_data[2007:2000]),.o(syn_11_tmp[2007:2000]));
  gf_mult_by_b2 m3056 (.i(rx_data[2015:2008]),.o(syn_11_tmp[2015:2008]));
  gf_mult_by_8a m3057 (.i(rx_data[2023:2016]),.o(syn_11_tmp[2023:2016]));
  gf_mult_by_f3 m3058 (.i(rx_data[2031:2024]),.o(syn_11_tmp[2031:2024]));
  gf_mult_by_fa m3059 (.i(rx_data[2039:2032]),.o(syn_11_tmp[2039:2032]));
  assign syndrome[95:88] =
      syn_11_tmp[7:0] ^ syn_11_tmp[15:8] ^ syn_11_tmp[23:16] ^ 
      syn_11_tmp[31:24] ^ syn_11_tmp[39:32] ^ syn_11_tmp[47:40] ^ 
      syn_11_tmp[55:48] ^ syn_11_tmp[63:56] ^ syn_11_tmp[71:64] ^ 
      syn_11_tmp[79:72] ^ syn_11_tmp[87:80] ^ syn_11_tmp[95:88] ^ 
      syn_11_tmp[103:96] ^ syn_11_tmp[111:104] ^ syn_11_tmp[119:112] ^ 
      syn_11_tmp[127:120] ^ syn_11_tmp[135:128] ^ syn_11_tmp[143:136] ^ 
      syn_11_tmp[151:144] ^ syn_11_tmp[159:152] ^ syn_11_tmp[167:160] ^ 
      syn_11_tmp[175:168] ^ syn_11_tmp[183:176] ^ syn_11_tmp[191:184] ^ 
      syn_11_tmp[199:192] ^ syn_11_tmp[207:200] ^ syn_11_tmp[215:208] ^ 
      syn_11_tmp[223:216] ^ syn_11_tmp[231:224] ^ syn_11_tmp[239:232] ^ 
      syn_11_tmp[247:240] ^ syn_11_tmp[255:248] ^ syn_11_tmp[263:256] ^ 
      syn_11_tmp[271:264] ^ syn_11_tmp[279:272] ^ syn_11_tmp[287:280] ^ 
      syn_11_tmp[295:288] ^ syn_11_tmp[303:296] ^ syn_11_tmp[311:304] ^ 
      syn_11_tmp[319:312] ^ syn_11_tmp[327:320] ^ syn_11_tmp[335:328] ^ 
      syn_11_tmp[343:336] ^ syn_11_tmp[351:344] ^ syn_11_tmp[359:352] ^ 
      syn_11_tmp[367:360] ^ syn_11_tmp[375:368] ^ syn_11_tmp[383:376] ^ 
      syn_11_tmp[391:384] ^ syn_11_tmp[399:392] ^ syn_11_tmp[407:400] ^ 
      syn_11_tmp[415:408] ^ syn_11_tmp[423:416] ^ syn_11_tmp[431:424] ^ 
      syn_11_tmp[439:432] ^ syn_11_tmp[447:440] ^ syn_11_tmp[455:448] ^ 
      syn_11_tmp[463:456] ^ syn_11_tmp[471:464] ^ syn_11_tmp[479:472] ^ 
      syn_11_tmp[487:480] ^ syn_11_tmp[495:488] ^ syn_11_tmp[503:496] ^ 
      syn_11_tmp[511:504] ^ syn_11_tmp[519:512] ^ syn_11_tmp[527:520] ^ 
      syn_11_tmp[535:528] ^ syn_11_tmp[543:536] ^ syn_11_tmp[551:544] ^ 
      syn_11_tmp[559:552] ^ syn_11_tmp[567:560] ^ syn_11_tmp[575:568] ^ 
      syn_11_tmp[583:576] ^ syn_11_tmp[591:584] ^ syn_11_tmp[599:592] ^ 
      syn_11_tmp[607:600] ^ syn_11_tmp[615:608] ^ syn_11_tmp[623:616] ^ 
      syn_11_tmp[631:624] ^ syn_11_tmp[639:632] ^ syn_11_tmp[647:640] ^ 
      syn_11_tmp[655:648] ^ syn_11_tmp[663:656] ^ syn_11_tmp[671:664] ^ 
      syn_11_tmp[679:672] ^ syn_11_tmp[687:680] ^ syn_11_tmp[695:688] ^ 
      syn_11_tmp[703:696] ^ syn_11_tmp[711:704] ^ syn_11_tmp[719:712] ^ 
      syn_11_tmp[727:720] ^ syn_11_tmp[735:728] ^ syn_11_tmp[743:736] ^ 
      syn_11_tmp[751:744] ^ syn_11_tmp[759:752] ^ syn_11_tmp[767:760] ^ 
      syn_11_tmp[775:768] ^ syn_11_tmp[783:776] ^ syn_11_tmp[791:784] ^ 
      syn_11_tmp[799:792] ^ syn_11_tmp[807:800] ^ syn_11_tmp[815:808] ^ 
      syn_11_tmp[823:816] ^ syn_11_tmp[831:824] ^ syn_11_tmp[839:832] ^ 
      syn_11_tmp[847:840] ^ syn_11_tmp[855:848] ^ syn_11_tmp[863:856] ^ 
      syn_11_tmp[871:864] ^ syn_11_tmp[879:872] ^ syn_11_tmp[887:880] ^ 
      syn_11_tmp[895:888] ^ syn_11_tmp[903:896] ^ syn_11_tmp[911:904] ^ 
      syn_11_tmp[919:912] ^ syn_11_tmp[927:920] ^ syn_11_tmp[935:928] ^ 
      syn_11_tmp[943:936] ^ syn_11_tmp[951:944] ^ syn_11_tmp[959:952] ^ 
      syn_11_tmp[967:960] ^ syn_11_tmp[975:968] ^ syn_11_tmp[983:976] ^ 
      syn_11_tmp[991:984] ^ syn_11_tmp[999:992] ^ syn_11_tmp[1007:1000] ^ 
      syn_11_tmp[1015:1008] ^ syn_11_tmp[1023:1016] ^ syn_11_tmp[1031:1024] ^ 
      syn_11_tmp[1039:1032] ^ syn_11_tmp[1047:1040] ^ syn_11_tmp[1055:1048] ^ 
      syn_11_tmp[1063:1056] ^ syn_11_tmp[1071:1064] ^ syn_11_tmp[1079:1072] ^ 
      syn_11_tmp[1087:1080] ^ syn_11_tmp[1095:1088] ^ syn_11_tmp[1103:1096] ^ 
      syn_11_tmp[1111:1104] ^ syn_11_tmp[1119:1112] ^ syn_11_tmp[1127:1120] ^ 
      syn_11_tmp[1135:1128] ^ syn_11_tmp[1143:1136] ^ syn_11_tmp[1151:1144] ^ 
      syn_11_tmp[1159:1152] ^ syn_11_tmp[1167:1160] ^ syn_11_tmp[1175:1168] ^ 
      syn_11_tmp[1183:1176] ^ syn_11_tmp[1191:1184] ^ syn_11_tmp[1199:1192] ^ 
      syn_11_tmp[1207:1200] ^ syn_11_tmp[1215:1208] ^ syn_11_tmp[1223:1216] ^ 
      syn_11_tmp[1231:1224] ^ syn_11_tmp[1239:1232] ^ syn_11_tmp[1247:1240] ^ 
      syn_11_tmp[1255:1248] ^ syn_11_tmp[1263:1256] ^ syn_11_tmp[1271:1264] ^ 
      syn_11_tmp[1279:1272] ^ syn_11_tmp[1287:1280] ^ syn_11_tmp[1295:1288] ^ 
      syn_11_tmp[1303:1296] ^ syn_11_tmp[1311:1304] ^ syn_11_tmp[1319:1312] ^ 
      syn_11_tmp[1327:1320] ^ syn_11_tmp[1335:1328] ^ syn_11_tmp[1343:1336] ^ 
      syn_11_tmp[1351:1344] ^ syn_11_tmp[1359:1352] ^ syn_11_tmp[1367:1360] ^ 
      syn_11_tmp[1375:1368] ^ syn_11_tmp[1383:1376] ^ syn_11_tmp[1391:1384] ^ 
      syn_11_tmp[1399:1392] ^ syn_11_tmp[1407:1400] ^ syn_11_tmp[1415:1408] ^ 
      syn_11_tmp[1423:1416] ^ syn_11_tmp[1431:1424] ^ syn_11_tmp[1439:1432] ^ 
      syn_11_tmp[1447:1440] ^ syn_11_tmp[1455:1448] ^ syn_11_tmp[1463:1456] ^ 
      syn_11_tmp[1471:1464] ^ syn_11_tmp[1479:1472] ^ syn_11_tmp[1487:1480] ^ 
      syn_11_tmp[1495:1488] ^ syn_11_tmp[1503:1496] ^ syn_11_tmp[1511:1504] ^ 
      syn_11_tmp[1519:1512] ^ syn_11_tmp[1527:1520] ^ syn_11_tmp[1535:1528] ^ 
      syn_11_tmp[1543:1536] ^ syn_11_tmp[1551:1544] ^ syn_11_tmp[1559:1552] ^ 
      syn_11_tmp[1567:1560] ^ syn_11_tmp[1575:1568] ^ syn_11_tmp[1583:1576] ^ 
      syn_11_tmp[1591:1584] ^ syn_11_tmp[1599:1592] ^ syn_11_tmp[1607:1600] ^ 
      syn_11_tmp[1615:1608] ^ syn_11_tmp[1623:1616] ^ syn_11_tmp[1631:1624] ^ 
      syn_11_tmp[1639:1632] ^ syn_11_tmp[1647:1640] ^ syn_11_tmp[1655:1648] ^ 
      syn_11_tmp[1663:1656] ^ syn_11_tmp[1671:1664] ^ syn_11_tmp[1679:1672] ^ 
      syn_11_tmp[1687:1680] ^ syn_11_tmp[1695:1688] ^ syn_11_tmp[1703:1696] ^ 
      syn_11_tmp[1711:1704] ^ syn_11_tmp[1719:1712] ^ syn_11_tmp[1727:1720] ^ 
      syn_11_tmp[1735:1728] ^ syn_11_tmp[1743:1736] ^ syn_11_tmp[1751:1744] ^ 
      syn_11_tmp[1759:1752] ^ syn_11_tmp[1767:1760] ^ syn_11_tmp[1775:1768] ^ 
      syn_11_tmp[1783:1776] ^ syn_11_tmp[1791:1784] ^ syn_11_tmp[1799:1792] ^ 
      syn_11_tmp[1807:1800] ^ syn_11_tmp[1815:1808] ^ syn_11_tmp[1823:1816] ^ 
      syn_11_tmp[1831:1824] ^ syn_11_tmp[1839:1832] ^ syn_11_tmp[1847:1840] ^ 
      syn_11_tmp[1855:1848] ^ syn_11_tmp[1863:1856] ^ syn_11_tmp[1871:1864] ^ 
      syn_11_tmp[1879:1872] ^ syn_11_tmp[1887:1880] ^ syn_11_tmp[1895:1888] ^ 
      syn_11_tmp[1903:1896] ^ syn_11_tmp[1911:1904] ^ syn_11_tmp[1919:1912] ^ 
      syn_11_tmp[1927:1920] ^ syn_11_tmp[1935:1928] ^ syn_11_tmp[1943:1936] ^ 
      syn_11_tmp[1951:1944] ^ syn_11_tmp[1959:1952] ^ syn_11_tmp[1967:1960] ^ 
      syn_11_tmp[1975:1968] ^ syn_11_tmp[1983:1976] ^ syn_11_tmp[1991:1984] ^ 
      syn_11_tmp[1999:1992] ^ syn_11_tmp[2007:2000] ^ syn_11_tmp[2015:2008] ^ 
      syn_11_tmp[2023:2016] ^ syn_11_tmp[2031:2024] ^ syn_11_tmp[2039:2032];

// syndrome 12
  wire [2039:0] syn_12_tmp;
  gf_mult_by_01 m3060 (.i(rx_data[7:0]),.o(syn_12_tmp[7:0]));
  gf_mult_by_cd m3061 (.i(rx_data[15:8]),.o(syn_12_tmp[15:8]));
  gf_mult_by_8f m3062 (.i(rx_data[23:16]),.o(syn_12_tmp[23:16]));
  gf_mult_by_25 m3063 (.i(rx_data[31:24]),.o(syn_12_tmp[31:24]));
  gf_mult_by_46 m3064 (.i(rx_data[39:32]),.o(syn_12_tmp[39:32]));
  gf_mult_by_b9 m3065 (.i(rx_data[47:40]),.o(syn_12_tmp[47:40]));
  gf_mult_by_65 m3066 (.i(rx_data[55:48]),.o(syn_12_tmp[55:48]));
  gf_mult_by_6b m3067 (.i(rx_data[63:56]),.o(syn_12_tmp[63:56]));
  gf_mult_by_d9 m3068 (.i(rx_data[71:64]),.o(syn_12_tmp[71:64]));
  gf_mult_by_d0 m3069 (.i(rx_data[79:72]),.o(syn_12_tmp[79:72]));
  gf_mult_by_3b m3070 (.i(rx_data[87:80]),.o(syn_12_tmp[87:80]));
  gf_mult_by_b8 m3071 (.i(rx_data[95:88]),.o(syn_12_tmp[95:88]));
  gf_mult_by_a8 m3072 (.i(rx_data[103:96]),.o(syn_12_tmp[103:96]));
  gf_mult_by_e4 m3073 (.i(rx_data[111:104]),.o(syn_12_tmp[111:104]));
  gf_mult_by_fc m3074 (.i(rx_data[119:112]),.o(syn_12_tmp[119:112]));
  gf_mult_by_96 m3075 (.i(rx_data[127:120]),.o(syn_12_tmp[127:120]));
  gf_mult_by_82 m3076 (.i(rx_data[135:128]),.o(syn_12_tmp[135:128]));
  gf_mult_by_dd m3077 (.i(rx_data[143:136]),.o(syn_12_tmp[143:136]));
  gf_mult_by_c3 m3078 (.i(rx_data[151:144]),.o(syn_12_tmp[151:144]));
  gf_mult_by_3d m3079 (.i(rx_data[159:152]),.o(syn_12_tmp[159:152]));
  gf_mult_by_2c m3080 (.i(rx_data[167:160]),.o(syn_12_tmp[167:160]));
  gf_mult_by_ad m3081 (.i(rx_data[175:168]),.o(syn_12_tmp[175:168]));
  gf_mult_by_3a m3082 (.i(rx_data[183:176]),.o(syn_12_tmp[183:176]));
  gf_mult_by_75 m3083 (.i(rx_data[191:184]),.o(syn_12_tmp[191:184]));
  gf_mult_by_27 m3084 (.i(rx_data[199:192]),.o(syn_12_tmp[199:192]));
  gf_mult_by_c1 m3085 (.i(rx_data[207:200]),.o(syn_12_tmp[207:200]));
  gf_mult_by_ba m3086 (.i(rx_data[215:208]),.o(syn_12_tmp[215:208]));
  gf_mult_by_2f m3087 (.i(rx_data[223:216]),.o(syn_12_tmp[223:216]));
  gf_mult_by_e7 m3088 (.i(rx_data[231:224]),.o(syn_12_tmp[231:224]));
  gf_mult_by_b6 m3089 (.i(rx_data[239:232]),.o(syn_12_tmp[239:232]));
  gf_mult_by_1a m3090 (.i(rx_data[247:240]),.o(syn_12_tmp[247:240]));
  gf_mult_by_ed m3091 (.i(rx_data[255:248]),.o(syn_12_tmp[255:248]));
  gf_mult_by_17 m3092 (.i(rx_data[263:256]),.o(syn_12_tmp[263:256]));
  gf_mult_by_15 m3093 (.i(rx_data[271:264]),.o(syn_12_tmp[271:264]));
  gf_mult_by_92 m3094 (.i(rx_data[279:272]),.o(syn_12_tmp[279:272]));
  gf_mult_by_91 m3095 (.i(rx_data[287:280]),.o(syn_12_tmp[287:280]));
  gf_mult_by_db m3096 (.i(rx_data[295:288]),.o(syn_12_tmp[295:288]));
  gf_mult_by_57 m3097 (.i(rx_data[303:296]),.o(syn_12_tmp[303:296]));
  gf_mult_by_38 m3098 (.i(rx_data[311:304]),.o(syn_12_tmp[311:304]));
  gf_mult_by_f2 m3099 (.i(rx_data[319:312]),.o(syn_12_tmp[319:312]));
  gf_mult_by_24 m3100 (.i(rx_data[327:320]),.o(syn_12_tmp[327:320]));
  gf_mult_by_8b m3101 (.i(rx_data[335:328]),.o(syn_12_tmp[335:328]));
  gf_mult_by_36 m3102 (.i(rx_data[343:336]),.o(syn_12_tmp[343:336]));
  gf_mult_by_40 m3103 (.i(rx_data[351:344]),.o(syn_12_tmp[351:344]));
  gf_mult_by_2d m3104 (.i(rx_data[359:352]),.o(syn_12_tmp[359:352]));
  gf_mult_by_60 m3105 (.i(rx_data[367:360]),.o(syn_12_tmp[367:360]));
  gf_mult_by_b5 m3106 (.i(rx_data[375:368]),.o(syn_12_tmp[375:368]));
  gf_mult_by_50 m3107 (.i(rx_data[383:376]),.o(syn_12_tmp[383:376]));
  gf_mult_by_61 m3108 (.i(rx_data[391:384]),.o(syn_12_tmp[391:384]));
  gf_mult_by_78 m3109 (.i(rx_data[399:392]),.o(syn_12_tmp[399:392]));
  gf_mult_by_df m3110 (.i(rx_data[407:400]),.o(syn_12_tmp[407:400]));
  gf_mult_by_44 m3111 (.i(rx_data[415:408]),.o(syn_12_tmp[415:408]));
  gf_mult_by_3e m3112 (.i(rx_data[423:416]),.o(syn_12_tmp[423:416]));
  gf_mult_by_66 m3113 (.i(rx_data[431:424]),.o(syn_12_tmp[431:424]));
  gf_mult_by_21 m3114 (.i(rx_data[439:432]),.o(syn_12_tmp[439:432]));
  gf_mult_by_55 m3115 (.i(rx_data[447:440]),.o(syn_12_tmp[447:440]));
  gf_mult_by_bf m3116 (.i(rx_data[455:448]),.o(syn_12_tmp[455:448]));
  gf_mult_by_f1 m3117 (.i(rx_data[463:456]),.o(syn_12_tmp[463:456]));
  gf_mult_by_6e m3118 (.i(rx_data[471:464]),.o(syn_12_tmp[471:464]));
  gf_mult_by_07 m3119 (.i(rx_data[479:472]),.o(syn_12_tmp[479:472]));
  gf_mult_by_59 m3120 (.i(rx_data[487:480]),.o(syn_12_tmp[487:480]));
  gf_mult_by_8a m3121 (.i(rx_data[495:488]),.o(syn_12_tmp[495:488]));
  gf_mult_by_fb m3122 (.i(rx_data[503:496]),.o(syn_12_tmp[503:496]));
  gf_mult_by_cf m3123 (.i(rx_data[511:504]),.o(syn_12_tmp[511:504]));
  gf_mult_by_08 m3124 (.i(rx_data[519:512]),.o(syn_12_tmp[519:512]));
  gf_mult_by_26 m3125 (.i(rx_data[527:520]),.o(syn_12_tmp[527:520]));
  gf_mult_by_0c m3126 (.i(rx_data[535:528]),.o(syn_12_tmp[535:528]));
  gf_mult_by_35 m3127 (.i(rx_data[543:536]),.o(syn_12_tmp[543:536]));
  gf_mult_by_0a m3128 (.i(rx_data[551:544]),.o(syn_12_tmp[551:544]));
  gf_mult_by_a1 m3129 (.i(rx_data[559:552]),.o(syn_12_tmp[559:552]));
  gf_mult_by_0f m3130 (.i(rx_data[567:560]),.o(syn_12_tmp[567:560]));
  gf_mult_by_7f m3131 (.i(rx_data[575:568]),.o(syn_12_tmp[575:568]));
  gf_mult_by_86 m3132 (.i(rx_data[583:576]),.o(syn_12_tmp[583:576]));
  gf_mult_by_ce m3133 (.i(rx_data[591:584]),.o(syn_12_tmp[591:584]));
  gf_mult_by_c5 m3134 (.i(rx_data[599:592]),.o(syn_12_tmp[599:592]));
  gf_mult_by_a9 m3135 (.i(rx_data[607:600]),.o(syn_12_tmp[607:600]));
  gf_mult_by_29 m3136 (.i(rx_data[615:608]),.o(syn_12_tmp[615:608]));
  gf_mult_by_73 m3137 (.i(rx_data[623:616]),.o(syn_12_tmp[623:616]));
  gf_mult_by_b3 m3138 (.i(rx_data[631:624]),.o(syn_12_tmp[631:624]));
  gf_mult_by_c4 m3139 (.i(rx_data[639:632]),.o(syn_12_tmp[639:632]));
  gf_mult_by_64 m3140 (.i(rx_data[647:640]),.o(syn_12_tmp[647:640]));
  gf_mult_by_a6 m3141 (.i(rx_data[655:648]),.o(syn_12_tmp[655:648]));
  gf_mult_by_56 m3142 (.i(rx_data[663:656]),.o(syn_12_tmp[663:656]));
  gf_mult_by_f5 m3143 (.i(rx_data[671:664]),.o(syn_12_tmp[671:664]));
  gf_mult_by_7d m3144 (.i(rx_data[679:672]),.o(syn_12_tmp[679:672]));
  gf_mult_by_01 m3145 (.i(rx_data[687:680]),.o(syn_12_tmp[687:680]));
  gf_mult_by_cd m3146 (.i(rx_data[695:688]),.o(syn_12_tmp[695:688]));
  gf_mult_by_8f m3147 (.i(rx_data[703:696]),.o(syn_12_tmp[703:696]));
  gf_mult_by_25 m3148 (.i(rx_data[711:704]),.o(syn_12_tmp[711:704]));
  gf_mult_by_46 m3149 (.i(rx_data[719:712]),.o(syn_12_tmp[719:712]));
  gf_mult_by_b9 m3150 (.i(rx_data[727:720]),.o(syn_12_tmp[727:720]));
  gf_mult_by_65 m3151 (.i(rx_data[735:728]),.o(syn_12_tmp[735:728]));
  gf_mult_by_6b m3152 (.i(rx_data[743:736]),.o(syn_12_tmp[743:736]));
  gf_mult_by_d9 m3153 (.i(rx_data[751:744]),.o(syn_12_tmp[751:744]));
  gf_mult_by_d0 m3154 (.i(rx_data[759:752]),.o(syn_12_tmp[759:752]));
  gf_mult_by_3b m3155 (.i(rx_data[767:760]),.o(syn_12_tmp[767:760]));
  gf_mult_by_b8 m3156 (.i(rx_data[775:768]),.o(syn_12_tmp[775:768]));
  gf_mult_by_a8 m3157 (.i(rx_data[783:776]),.o(syn_12_tmp[783:776]));
  gf_mult_by_e4 m3158 (.i(rx_data[791:784]),.o(syn_12_tmp[791:784]));
  gf_mult_by_fc m3159 (.i(rx_data[799:792]),.o(syn_12_tmp[799:792]));
  gf_mult_by_96 m3160 (.i(rx_data[807:800]),.o(syn_12_tmp[807:800]));
  gf_mult_by_82 m3161 (.i(rx_data[815:808]),.o(syn_12_tmp[815:808]));
  gf_mult_by_dd m3162 (.i(rx_data[823:816]),.o(syn_12_tmp[823:816]));
  gf_mult_by_c3 m3163 (.i(rx_data[831:824]),.o(syn_12_tmp[831:824]));
  gf_mult_by_3d m3164 (.i(rx_data[839:832]),.o(syn_12_tmp[839:832]));
  gf_mult_by_2c m3165 (.i(rx_data[847:840]),.o(syn_12_tmp[847:840]));
  gf_mult_by_ad m3166 (.i(rx_data[855:848]),.o(syn_12_tmp[855:848]));
  gf_mult_by_3a m3167 (.i(rx_data[863:856]),.o(syn_12_tmp[863:856]));
  gf_mult_by_75 m3168 (.i(rx_data[871:864]),.o(syn_12_tmp[871:864]));
  gf_mult_by_27 m3169 (.i(rx_data[879:872]),.o(syn_12_tmp[879:872]));
  gf_mult_by_c1 m3170 (.i(rx_data[887:880]),.o(syn_12_tmp[887:880]));
  gf_mult_by_ba m3171 (.i(rx_data[895:888]),.o(syn_12_tmp[895:888]));
  gf_mult_by_2f m3172 (.i(rx_data[903:896]),.o(syn_12_tmp[903:896]));
  gf_mult_by_e7 m3173 (.i(rx_data[911:904]),.o(syn_12_tmp[911:904]));
  gf_mult_by_b6 m3174 (.i(rx_data[919:912]),.o(syn_12_tmp[919:912]));
  gf_mult_by_1a m3175 (.i(rx_data[927:920]),.o(syn_12_tmp[927:920]));
  gf_mult_by_ed m3176 (.i(rx_data[935:928]),.o(syn_12_tmp[935:928]));
  gf_mult_by_17 m3177 (.i(rx_data[943:936]),.o(syn_12_tmp[943:936]));
  gf_mult_by_15 m3178 (.i(rx_data[951:944]),.o(syn_12_tmp[951:944]));
  gf_mult_by_92 m3179 (.i(rx_data[959:952]),.o(syn_12_tmp[959:952]));
  gf_mult_by_91 m3180 (.i(rx_data[967:960]),.o(syn_12_tmp[967:960]));
  gf_mult_by_db m3181 (.i(rx_data[975:968]),.o(syn_12_tmp[975:968]));
  gf_mult_by_57 m3182 (.i(rx_data[983:976]),.o(syn_12_tmp[983:976]));
  gf_mult_by_38 m3183 (.i(rx_data[991:984]),.o(syn_12_tmp[991:984]));
  gf_mult_by_f2 m3184 (.i(rx_data[999:992]),.o(syn_12_tmp[999:992]));
  gf_mult_by_24 m3185 (.i(rx_data[1007:1000]),.o(syn_12_tmp[1007:1000]));
  gf_mult_by_8b m3186 (.i(rx_data[1015:1008]),.o(syn_12_tmp[1015:1008]));
  gf_mult_by_36 m3187 (.i(rx_data[1023:1016]),.o(syn_12_tmp[1023:1016]));
  gf_mult_by_40 m3188 (.i(rx_data[1031:1024]),.o(syn_12_tmp[1031:1024]));
  gf_mult_by_2d m3189 (.i(rx_data[1039:1032]),.o(syn_12_tmp[1039:1032]));
  gf_mult_by_60 m3190 (.i(rx_data[1047:1040]),.o(syn_12_tmp[1047:1040]));
  gf_mult_by_b5 m3191 (.i(rx_data[1055:1048]),.o(syn_12_tmp[1055:1048]));
  gf_mult_by_50 m3192 (.i(rx_data[1063:1056]),.o(syn_12_tmp[1063:1056]));
  gf_mult_by_61 m3193 (.i(rx_data[1071:1064]),.o(syn_12_tmp[1071:1064]));
  gf_mult_by_78 m3194 (.i(rx_data[1079:1072]),.o(syn_12_tmp[1079:1072]));
  gf_mult_by_df m3195 (.i(rx_data[1087:1080]),.o(syn_12_tmp[1087:1080]));
  gf_mult_by_44 m3196 (.i(rx_data[1095:1088]),.o(syn_12_tmp[1095:1088]));
  gf_mult_by_3e m3197 (.i(rx_data[1103:1096]),.o(syn_12_tmp[1103:1096]));
  gf_mult_by_66 m3198 (.i(rx_data[1111:1104]),.o(syn_12_tmp[1111:1104]));
  gf_mult_by_21 m3199 (.i(rx_data[1119:1112]),.o(syn_12_tmp[1119:1112]));
  gf_mult_by_55 m3200 (.i(rx_data[1127:1120]),.o(syn_12_tmp[1127:1120]));
  gf_mult_by_bf m3201 (.i(rx_data[1135:1128]),.o(syn_12_tmp[1135:1128]));
  gf_mult_by_f1 m3202 (.i(rx_data[1143:1136]),.o(syn_12_tmp[1143:1136]));
  gf_mult_by_6e m3203 (.i(rx_data[1151:1144]),.o(syn_12_tmp[1151:1144]));
  gf_mult_by_07 m3204 (.i(rx_data[1159:1152]),.o(syn_12_tmp[1159:1152]));
  gf_mult_by_59 m3205 (.i(rx_data[1167:1160]),.o(syn_12_tmp[1167:1160]));
  gf_mult_by_8a m3206 (.i(rx_data[1175:1168]),.o(syn_12_tmp[1175:1168]));
  gf_mult_by_fb m3207 (.i(rx_data[1183:1176]),.o(syn_12_tmp[1183:1176]));
  gf_mult_by_cf m3208 (.i(rx_data[1191:1184]),.o(syn_12_tmp[1191:1184]));
  gf_mult_by_08 m3209 (.i(rx_data[1199:1192]),.o(syn_12_tmp[1199:1192]));
  gf_mult_by_26 m3210 (.i(rx_data[1207:1200]),.o(syn_12_tmp[1207:1200]));
  gf_mult_by_0c m3211 (.i(rx_data[1215:1208]),.o(syn_12_tmp[1215:1208]));
  gf_mult_by_35 m3212 (.i(rx_data[1223:1216]),.o(syn_12_tmp[1223:1216]));
  gf_mult_by_0a m3213 (.i(rx_data[1231:1224]),.o(syn_12_tmp[1231:1224]));
  gf_mult_by_a1 m3214 (.i(rx_data[1239:1232]),.o(syn_12_tmp[1239:1232]));
  gf_mult_by_0f m3215 (.i(rx_data[1247:1240]),.o(syn_12_tmp[1247:1240]));
  gf_mult_by_7f m3216 (.i(rx_data[1255:1248]),.o(syn_12_tmp[1255:1248]));
  gf_mult_by_86 m3217 (.i(rx_data[1263:1256]),.o(syn_12_tmp[1263:1256]));
  gf_mult_by_ce m3218 (.i(rx_data[1271:1264]),.o(syn_12_tmp[1271:1264]));
  gf_mult_by_c5 m3219 (.i(rx_data[1279:1272]),.o(syn_12_tmp[1279:1272]));
  gf_mult_by_a9 m3220 (.i(rx_data[1287:1280]),.o(syn_12_tmp[1287:1280]));
  gf_mult_by_29 m3221 (.i(rx_data[1295:1288]),.o(syn_12_tmp[1295:1288]));
  gf_mult_by_73 m3222 (.i(rx_data[1303:1296]),.o(syn_12_tmp[1303:1296]));
  gf_mult_by_b3 m3223 (.i(rx_data[1311:1304]),.o(syn_12_tmp[1311:1304]));
  gf_mult_by_c4 m3224 (.i(rx_data[1319:1312]),.o(syn_12_tmp[1319:1312]));
  gf_mult_by_64 m3225 (.i(rx_data[1327:1320]),.o(syn_12_tmp[1327:1320]));
  gf_mult_by_a6 m3226 (.i(rx_data[1335:1328]),.o(syn_12_tmp[1335:1328]));
  gf_mult_by_56 m3227 (.i(rx_data[1343:1336]),.o(syn_12_tmp[1343:1336]));
  gf_mult_by_f5 m3228 (.i(rx_data[1351:1344]),.o(syn_12_tmp[1351:1344]));
  gf_mult_by_7d m3229 (.i(rx_data[1359:1352]),.o(syn_12_tmp[1359:1352]));
  gf_mult_by_01 m3230 (.i(rx_data[1367:1360]),.o(syn_12_tmp[1367:1360]));
  gf_mult_by_cd m3231 (.i(rx_data[1375:1368]),.o(syn_12_tmp[1375:1368]));
  gf_mult_by_8f m3232 (.i(rx_data[1383:1376]),.o(syn_12_tmp[1383:1376]));
  gf_mult_by_25 m3233 (.i(rx_data[1391:1384]),.o(syn_12_tmp[1391:1384]));
  gf_mult_by_46 m3234 (.i(rx_data[1399:1392]),.o(syn_12_tmp[1399:1392]));
  gf_mult_by_b9 m3235 (.i(rx_data[1407:1400]),.o(syn_12_tmp[1407:1400]));
  gf_mult_by_65 m3236 (.i(rx_data[1415:1408]),.o(syn_12_tmp[1415:1408]));
  gf_mult_by_6b m3237 (.i(rx_data[1423:1416]),.o(syn_12_tmp[1423:1416]));
  gf_mult_by_d9 m3238 (.i(rx_data[1431:1424]),.o(syn_12_tmp[1431:1424]));
  gf_mult_by_d0 m3239 (.i(rx_data[1439:1432]),.o(syn_12_tmp[1439:1432]));
  gf_mult_by_3b m3240 (.i(rx_data[1447:1440]),.o(syn_12_tmp[1447:1440]));
  gf_mult_by_b8 m3241 (.i(rx_data[1455:1448]),.o(syn_12_tmp[1455:1448]));
  gf_mult_by_a8 m3242 (.i(rx_data[1463:1456]),.o(syn_12_tmp[1463:1456]));
  gf_mult_by_e4 m3243 (.i(rx_data[1471:1464]),.o(syn_12_tmp[1471:1464]));
  gf_mult_by_fc m3244 (.i(rx_data[1479:1472]),.o(syn_12_tmp[1479:1472]));
  gf_mult_by_96 m3245 (.i(rx_data[1487:1480]),.o(syn_12_tmp[1487:1480]));
  gf_mult_by_82 m3246 (.i(rx_data[1495:1488]),.o(syn_12_tmp[1495:1488]));
  gf_mult_by_dd m3247 (.i(rx_data[1503:1496]),.o(syn_12_tmp[1503:1496]));
  gf_mult_by_c3 m3248 (.i(rx_data[1511:1504]),.o(syn_12_tmp[1511:1504]));
  gf_mult_by_3d m3249 (.i(rx_data[1519:1512]),.o(syn_12_tmp[1519:1512]));
  gf_mult_by_2c m3250 (.i(rx_data[1527:1520]),.o(syn_12_tmp[1527:1520]));
  gf_mult_by_ad m3251 (.i(rx_data[1535:1528]),.o(syn_12_tmp[1535:1528]));
  gf_mult_by_3a m3252 (.i(rx_data[1543:1536]),.o(syn_12_tmp[1543:1536]));
  gf_mult_by_75 m3253 (.i(rx_data[1551:1544]),.o(syn_12_tmp[1551:1544]));
  gf_mult_by_27 m3254 (.i(rx_data[1559:1552]),.o(syn_12_tmp[1559:1552]));
  gf_mult_by_c1 m3255 (.i(rx_data[1567:1560]),.o(syn_12_tmp[1567:1560]));
  gf_mult_by_ba m3256 (.i(rx_data[1575:1568]),.o(syn_12_tmp[1575:1568]));
  gf_mult_by_2f m3257 (.i(rx_data[1583:1576]),.o(syn_12_tmp[1583:1576]));
  gf_mult_by_e7 m3258 (.i(rx_data[1591:1584]),.o(syn_12_tmp[1591:1584]));
  gf_mult_by_b6 m3259 (.i(rx_data[1599:1592]),.o(syn_12_tmp[1599:1592]));
  gf_mult_by_1a m3260 (.i(rx_data[1607:1600]),.o(syn_12_tmp[1607:1600]));
  gf_mult_by_ed m3261 (.i(rx_data[1615:1608]),.o(syn_12_tmp[1615:1608]));
  gf_mult_by_17 m3262 (.i(rx_data[1623:1616]),.o(syn_12_tmp[1623:1616]));
  gf_mult_by_15 m3263 (.i(rx_data[1631:1624]),.o(syn_12_tmp[1631:1624]));
  gf_mult_by_92 m3264 (.i(rx_data[1639:1632]),.o(syn_12_tmp[1639:1632]));
  gf_mult_by_91 m3265 (.i(rx_data[1647:1640]),.o(syn_12_tmp[1647:1640]));
  gf_mult_by_db m3266 (.i(rx_data[1655:1648]),.o(syn_12_tmp[1655:1648]));
  gf_mult_by_57 m3267 (.i(rx_data[1663:1656]),.o(syn_12_tmp[1663:1656]));
  gf_mult_by_38 m3268 (.i(rx_data[1671:1664]),.o(syn_12_tmp[1671:1664]));
  gf_mult_by_f2 m3269 (.i(rx_data[1679:1672]),.o(syn_12_tmp[1679:1672]));
  gf_mult_by_24 m3270 (.i(rx_data[1687:1680]),.o(syn_12_tmp[1687:1680]));
  gf_mult_by_8b m3271 (.i(rx_data[1695:1688]),.o(syn_12_tmp[1695:1688]));
  gf_mult_by_36 m3272 (.i(rx_data[1703:1696]),.o(syn_12_tmp[1703:1696]));
  gf_mult_by_40 m3273 (.i(rx_data[1711:1704]),.o(syn_12_tmp[1711:1704]));
  gf_mult_by_2d m3274 (.i(rx_data[1719:1712]),.o(syn_12_tmp[1719:1712]));
  gf_mult_by_60 m3275 (.i(rx_data[1727:1720]),.o(syn_12_tmp[1727:1720]));
  gf_mult_by_b5 m3276 (.i(rx_data[1735:1728]),.o(syn_12_tmp[1735:1728]));
  gf_mult_by_50 m3277 (.i(rx_data[1743:1736]),.o(syn_12_tmp[1743:1736]));
  gf_mult_by_61 m3278 (.i(rx_data[1751:1744]),.o(syn_12_tmp[1751:1744]));
  gf_mult_by_78 m3279 (.i(rx_data[1759:1752]),.o(syn_12_tmp[1759:1752]));
  gf_mult_by_df m3280 (.i(rx_data[1767:1760]),.o(syn_12_tmp[1767:1760]));
  gf_mult_by_44 m3281 (.i(rx_data[1775:1768]),.o(syn_12_tmp[1775:1768]));
  gf_mult_by_3e m3282 (.i(rx_data[1783:1776]),.o(syn_12_tmp[1783:1776]));
  gf_mult_by_66 m3283 (.i(rx_data[1791:1784]),.o(syn_12_tmp[1791:1784]));
  gf_mult_by_21 m3284 (.i(rx_data[1799:1792]),.o(syn_12_tmp[1799:1792]));
  gf_mult_by_55 m3285 (.i(rx_data[1807:1800]),.o(syn_12_tmp[1807:1800]));
  gf_mult_by_bf m3286 (.i(rx_data[1815:1808]),.o(syn_12_tmp[1815:1808]));
  gf_mult_by_f1 m3287 (.i(rx_data[1823:1816]),.o(syn_12_tmp[1823:1816]));
  gf_mult_by_6e m3288 (.i(rx_data[1831:1824]),.o(syn_12_tmp[1831:1824]));
  gf_mult_by_07 m3289 (.i(rx_data[1839:1832]),.o(syn_12_tmp[1839:1832]));
  gf_mult_by_59 m3290 (.i(rx_data[1847:1840]),.o(syn_12_tmp[1847:1840]));
  gf_mult_by_8a m3291 (.i(rx_data[1855:1848]),.o(syn_12_tmp[1855:1848]));
  gf_mult_by_fb m3292 (.i(rx_data[1863:1856]),.o(syn_12_tmp[1863:1856]));
  gf_mult_by_cf m3293 (.i(rx_data[1871:1864]),.o(syn_12_tmp[1871:1864]));
  gf_mult_by_08 m3294 (.i(rx_data[1879:1872]),.o(syn_12_tmp[1879:1872]));
  gf_mult_by_26 m3295 (.i(rx_data[1887:1880]),.o(syn_12_tmp[1887:1880]));
  gf_mult_by_0c m3296 (.i(rx_data[1895:1888]),.o(syn_12_tmp[1895:1888]));
  gf_mult_by_35 m3297 (.i(rx_data[1903:1896]),.o(syn_12_tmp[1903:1896]));
  gf_mult_by_0a m3298 (.i(rx_data[1911:1904]),.o(syn_12_tmp[1911:1904]));
  gf_mult_by_a1 m3299 (.i(rx_data[1919:1912]),.o(syn_12_tmp[1919:1912]));
  gf_mult_by_0f m3300 (.i(rx_data[1927:1920]),.o(syn_12_tmp[1927:1920]));
  gf_mult_by_7f m3301 (.i(rx_data[1935:1928]),.o(syn_12_tmp[1935:1928]));
  gf_mult_by_86 m3302 (.i(rx_data[1943:1936]),.o(syn_12_tmp[1943:1936]));
  gf_mult_by_ce m3303 (.i(rx_data[1951:1944]),.o(syn_12_tmp[1951:1944]));
  gf_mult_by_c5 m3304 (.i(rx_data[1959:1952]),.o(syn_12_tmp[1959:1952]));
  gf_mult_by_a9 m3305 (.i(rx_data[1967:1960]),.o(syn_12_tmp[1967:1960]));
  gf_mult_by_29 m3306 (.i(rx_data[1975:1968]),.o(syn_12_tmp[1975:1968]));
  gf_mult_by_73 m3307 (.i(rx_data[1983:1976]),.o(syn_12_tmp[1983:1976]));
  gf_mult_by_b3 m3308 (.i(rx_data[1991:1984]),.o(syn_12_tmp[1991:1984]));
  gf_mult_by_c4 m3309 (.i(rx_data[1999:1992]),.o(syn_12_tmp[1999:1992]));
  gf_mult_by_64 m3310 (.i(rx_data[2007:2000]),.o(syn_12_tmp[2007:2000]));
  gf_mult_by_a6 m3311 (.i(rx_data[2015:2008]),.o(syn_12_tmp[2015:2008]));
  gf_mult_by_56 m3312 (.i(rx_data[2023:2016]),.o(syn_12_tmp[2023:2016]));
  gf_mult_by_f5 m3313 (.i(rx_data[2031:2024]),.o(syn_12_tmp[2031:2024]));
  gf_mult_by_7d m3314 (.i(rx_data[2039:2032]),.o(syn_12_tmp[2039:2032]));
  assign syndrome[103:96] =
      syn_12_tmp[7:0] ^ syn_12_tmp[15:8] ^ syn_12_tmp[23:16] ^ 
      syn_12_tmp[31:24] ^ syn_12_tmp[39:32] ^ syn_12_tmp[47:40] ^ 
      syn_12_tmp[55:48] ^ syn_12_tmp[63:56] ^ syn_12_tmp[71:64] ^ 
      syn_12_tmp[79:72] ^ syn_12_tmp[87:80] ^ syn_12_tmp[95:88] ^ 
      syn_12_tmp[103:96] ^ syn_12_tmp[111:104] ^ syn_12_tmp[119:112] ^ 
      syn_12_tmp[127:120] ^ syn_12_tmp[135:128] ^ syn_12_tmp[143:136] ^ 
      syn_12_tmp[151:144] ^ syn_12_tmp[159:152] ^ syn_12_tmp[167:160] ^ 
      syn_12_tmp[175:168] ^ syn_12_tmp[183:176] ^ syn_12_tmp[191:184] ^ 
      syn_12_tmp[199:192] ^ syn_12_tmp[207:200] ^ syn_12_tmp[215:208] ^ 
      syn_12_tmp[223:216] ^ syn_12_tmp[231:224] ^ syn_12_tmp[239:232] ^ 
      syn_12_tmp[247:240] ^ syn_12_tmp[255:248] ^ syn_12_tmp[263:256] ^ 
      syn_12_tmp[271:264] ^ syn_12_tmp[279:272] ^ syn_12_tmp[287:280] ^ 
      syn_12_tmp[295:288] ^ syn_12_tmp[303:296] ^ syn_12_tmp[311:304] ^ 
      syn_12_tmp[319:312] ^ syn_12_tmp[327:320] ^ syn_12_tmp[335:328] ^ 
      syn_12_tmp[343:336] ^ syn_12_tmp[351:344] ^ syn_12_tmp[359:352] ^ 
      syn_12_tmp[367:360] ^ syn_12_tmp[375:368] ^ syn_12_tmp[383:376] ^ 
      syn_12_tmp[391:384] ^ syn_12_tmp[399:392] ^ syn_12_tmp[407:400] ^ 
      syn_12_tmp[415:408] ^ syn_12_tmp[423:416] ^ syn_12_tmp[431:424] ^ 
      syn_12_tmp[439:432] ^ syn_12_tmp[447:440] ^ syn_12_tmp[455:448] ^ 
      syn_12_tmp[463:456] ^ syn_12_tmp[471:464] ^ syn_12_tmp[479:472] ^ 
      syn_12_tmp[487:480] ^ syn_12_tmp[495:488] ^ syn_12_tmp[503:496] ^ 
      syn_12_tmp[511:504] ^ syn_12_tmp[519:512] ^ syn_12_tmp[527:520] ^ 
      syn_12_tmp[535:528] ^ syn_12_tmp[543:536] ^ syn_12_tmp[551:544] ^ 
      syn_12_tmp[559:552] ^ syn_12_tmp[567:560] ^ syn_12_tmp[575:568] ^ 
      syn_12_tmp[583:576] ^ syn_12_tmp[591:584] ^ syn_12_tmp[599:592] ^ 
      syn_12_tmp[607:600] ^ syn_12_tmp[615:608] ^ syn_12_tmp[623:616] ^ 
      syn_12_tmp[631:624] ^ syn_12_tmp[639:632] ^ syn_12_tmp[647:640] ^ 
      syn_12_tmp[655:648] ^ syn_12_tmp[663:656] ^ syn_12_tmp[671:664] ^ 
      syn_12_tmp[679:672] ^ syn_12_tmp[687:680] ^ syn_12_tmp[695:688] ^ 
      syn_12_tmp[703:696] ^ syn_12_tmp[711:704] ^ syn_12_tmp[719:712] ^ 
      syn_12_tmp[727:720] ^ syn_12_tmp[735:728] ^ syn_12_tmp[743:736] ^ 
      syn_12_tmp[751:744] ^ syn_12_tmp[759:752] ^ syn_12_tmp[767:760] ^ 
      syn_12_tmp[775:768] ^ syn_12_tmp[783:776] ^ syn_12_tmp[791:784] ^ 
      syn_12_tmp[799:792] ^ syn_12_tmp[807:800] ^ syn_12_tmp[815:808] ^ 
      syn_12_tmp[823:816] ^ syn_12_tmp[831:824] ^ syn_12_tmp[839:832] ^ 
      syn_12_tmp[847:840] ^ syn_12_tmp[855:848] ^ syn_12_tmp[863:856] ^ 
      syn_12_tmp[871:864] ^ syn_12_tmp[879:872] ^ syn_12_tmp[887:880] ^ 
      syn_12_tmp[895:888] ^ syn_12_tmp[903:896] ^ syn_12_tmp[911:904] ^ 
      syn_12_tmp[919:912] ^ syn_12_tmp[927:920] ^ syn_12_tmp[935:928] ^ 
      syn_12_tmp[943:936] ^ syn_12_tmp[951:944] ^ syn_12_tmp[959:952] ^ 
      syn_12_tmp[967:960] ^ syn_12_tmp[975:968] ^ syn_12_tmp[983:976] ^ 
      syn_12_tmp[991:984] ^ syn_12_tmp[999:992] ^ syn_12_tmp[1007:1000] ^ 
      syn_12_tmp[1015:1008] ^ syn_12_tmp[1023:1016] ^ syn_12_tmp[1031:1024] ^ 
      syn_12_tmp[1039:1032] ^ syn_12_tmp[1047:1040] ^ syn_12_tmp[1055:1048] ^ 
      syn_12_tmp[1063:1056] ^ syn_12_tmp[1071:1064] ^ syn_12_tmp[1079:1072] ^ 
      syn_12_tmp[1087:1080] ^ syn_12_tmp[1095:1088] ^ syn_12_tmp[1103:1096] ^ 
      syn_12_tmp[1111:1104] ^ syn_12_tmp[1119:1112] ^ syn_12_tmp[1127:1120] ^ 
      syn_12_tmp[1135:1128] ^ syn_12_tmp[1143:1136] ^ syn_12_tmp[1151:1144] ^ 
      syn_12_tmp[1159:1152] ^ syn_12_tmp[1167:1160] ^ syn_12_tmp[1175:1168] ^ 
      syn_12_tmp[1183:1176] ^ syn_12_tmp[1191:1184] ^ syn_12_tmp[1199:1192] ^ 
      syn_12_tmp[1207:1200] ^ syn_12_tmp[1215:1208] ^ syn_12_tmp[1223:1216] ^ 
      syn_12_tmp[1231:1224] ^ syn_12_tmp[1239:1232] ^ syn_12_tmp[1247:1240] ^ 
      syn_12_tmp[1255:1248] ^ syn_12_tmp[1263:1256] ^ syn_12_tmp[1271:1264] ^ 
      syn_12_tmp[1279:1272] ^ syn_12_tmp[1287:1280] ^ syn_12_tmp[1295:1288] ^ 
      syn_12_tmp[1303:1296] ^ syn_12_tmp[1311:1304] ^ syn_12_tmp[1319:1312] ^ 
      syn_12_tmp[1327:1320] ^ syn_12_tmp[1335:1328] ^ syn_12_tmp[1343:1336] ^ 
      syn_12_tmp[1351:1344] ^ syn_12_tmp[1359:1352] ^ syn_12_tmp[1367:1360] ^ 
      syn_12_tmp[1375:1368] ^ syn_12_tmp[1383:1376] ^ syn_12_tmp[1391:1384] ^ 
      syn_12_tmp[1399:1392] ^ syn_12_tmp[1407:1400] ^ syn_12_tmp[1415:1408] ^ 
      syn_12_tmp[1423:1416] ^ syn_12_tmp[1431:1424] ^ syn_12_tmp[1439:1432] ^ 
      syn_12_tmp[1447:1440] ^ syn_12_tmp[1455:1448] ^ syn_12_tmp[1463:1456] ^ 
      syn_12_tmp[1471:1464] ^ syn_12_tmp[1479:1472] ^ syn_12_tmp[1487:1480] ^ 
      syn_12_tmp[1495:1488] ^ syn_12_tmp[1503:1496] ^ syn_12_tmp[1511:1504] ^ 
      syn_12_tmp[1519:1512] ^ syn_12_tmp[1527:1520] ^ syn_12_tmp[1535:1528] ^ 
      syn_12_tmp[1543:1536] ^ syn_12_tmp[1551:1544] ^ syn_12_tmp[1559:1552] ^ 
      syn_12_tmp[1567:1560] ^ syn_12_tmp[1575:1568] ^ syn_12_tmp[1583:1576] ^ 
      syn_12_tmp[1591:1584] ^ syn_12_tmp[1599:1592] ^ syn_12_tmp[1607:1600] ^ 
      syn_12_tmp[1615:1608] ^ syn_12_tmp[1623:1616] ^ syn_12_tmp[1631:1624] ^ 
      syn_12_tmp[1639:1632] ^ syn_12_tmp[1647:1640] ^ syn_12_tmp[1655:1648] ^ 
      syn_12_tmp[1663:1656] ^ syn_12_tmp[1671:1664] ^ syn_12_tmp[1679:1672] ^ 
      syn_12_tmp[1687:1680] ^ syn_12_tmp[1695:1688] ^ syn_12_tmp[1703:1696] ^ 
      syn_12_tmp[1711:1704] ^ syn_12_tmp[1719:1712] ^ syn_12_tmp[1727:1720] ^ 
      syn_12_tmp[1735:1728] ^ syn_12_tmp[1743:1736] ^ syn_12_tmp[1751:1744] ^ 
      syn_12_tmp[1759:1752] ^ syn_12_tmp[1767:1760] ^ syn_12_tmp[1775:1768] ^ 
      syn_12_tmp[1783:1776] ^ syn_12_tmp[1791:1784] ^ syn_12_tmp[1799:1792] ^ 
      syn_12_tmp[1807:1800] ^ syn_12_tmp[1815:1808] ^ syn_12_tmp[1823:1816] ^ 
      syn_12_tmp[1831:1824] ^ syn_12_tmp[1839:1832] ^ syn_12_tmp[1847:1840] ^ 
      syn_12_tmp[1855:1848] ^ syn_12_tmp[1863:1856] ^ syn_12_tmp[1871:1864] ^ 
      syn_12_tmp[1879:1872] ^ syn_12_tmp[1887:1880] ^ syn_12_tmp[1895:1888] ^ 
      syn_12_tmp[1903:1896] ^ syn_12_tmp[1911:1904] ^ syn_12_tmp[1919:1912] ^ 
      syn_12_tmp[1927:1920] ^ syn_12_tmp[1935:1928] ^ syn_12_tmp[1943:1936] ^ 
      syn_12_tmp[1951:1944] ^ syn_12_tmp[1959:1952] ^ syn_12_tmp[1967:1960] ^ 
      syn_12_tmp[1975:1968] ^ syn_12_tmp[1983:1976] ^ syn_12_tmp[1991:1984] ^ 
      syn_12_tmp[1999:1992] ^ syn_12_tmp[2007:2000] ^ syn_12_tmp[2015:2008] ^ 
      syn_12_tmp[2023:2016] ^ syn_12_tmp[2031:2024] ^ syn_12_tmp[2039:2032];

// syndrome 13
  wire [2039:0] syn_13_tmp;
  gf_mult_by_01 m3315 (.i(rx_data[7:0]),.o(syn_13_tmp[7:0]));
  gf_mult_by_87 m3316 (.i(rx_data[15:8]),.o(syn_13_tmp[15:8]));
  gf_mult_by_06 m3317 (.i(rx_data[23:16]),.o(syn_13_tmp[23:16]));
  gf_mult_by_35 m3318 (.i(rx_data[31:24]),.o(syn_13_tmp[31:24]));
  gf_mult_by_14 m3319 (.i(rx_data[39:32]),.o(syn_13_tmp[39:32]));
  gf_mult_by_be m3320 (.i(rx_data[47:40]),.o(syn_13_tmp[47:40]));
  gf_mult_by_78 m3321 (.i(rx_data[55:48]),.o(syn_13_tmp[55:48]));
  gf_mult_by_a3 m3322 (.i(rx_data[63:56]),.o(syn_13_tmp[63:56]));
  gf_mult_by_0d m3323 (.i(rx_data[71:64]),.o(syn_13_tmp[71:64]));
  gf_mult_by_ed m3324 (.i(rx_data[79:72]),.o(syn_13_tmp[79:72]));
  gf_mult_by_2e m3325 (.i(rx_data[87:80]),.o(syn_13_tmp[87:80]));
  gf_mult_by_54 m3326 (.i(rx_data[95:88]),.o(syn_13_tmp[95:88]));
  gf_mult_by_e4 m3327 (.i(rx_data[103:96]),.o(syn_13_tmp[103:96]));
  gf_mult_by_e5 m3328 (.i(rx_data[111:104]),.o(syn_13_tmp[111:104]));
  gf_mult_by_62 m3329 (.i(rx_data[119:112]),.o(syn_13_tmp[119:112]));
  gf_mult_by_64 m3330 (.i(rx_data[127:120]),.o(syn_13_tmp[127:120]));
  gf_mult_by_51 m3331 (.i(rx_data[135:128]),.o(syn_13_tmp[135:128]));
  gf_mult_by_45 m3332 (.i(rx_data[143:136]),.o(syn_13_tmp[143:136]));
  gf_mult_by_fb m3333 (.i(rx_data[151:144]),.o(syn_13_tmp[151:144]));
  gf_mult_by_83 m3334 (.i(rx_data[159:152]),.o(syn_13_tmp[159:152]));
  gf_mult_by_20 m3335 (.i(rx_data[167:160]),.o(syn_13_tmp[167:160]));
  gf_mult_by_2d m3336 (.i(rx_data[175:168]),.o(syn_13_tmp[175:168]));
  gf_mult_by_c0 m3337 (.i(rx_data[183:176]),.o(syn_13_tmp[183:176]));
  gf_mult_by_ee m3338 (.i(rx_data[191:184]),.o(syn_13_tmp[191:184]));
  gf_mult_by_ba m3339 (.i(rx_data[199:192]),.o(syn_13_tmp[199:192]));
  gf_mult_by_5e m3340 (.i(rx_data[207:200]),.o(syn_13_tmp[207:200]));
  gf_mult_by_bb m3341 (.i(rx_data[215:208]),.o(syn_13_tmp[215:208]));
  gf_mult_by_d9 m3342 (.i(rx_data[223:216]),.o(syn_13_tmp[223:216]));
  gf_mult_by_bd m3343 (.i(rx_data[231:224]),.o(syn_13_tmp[231:224]));
  gf_mult_by_ec m3344 (.i(rx_data[239:232]),.o(syn_13_tmp[239:232]));
  gf_mult_by_a9 m3345 (.i(rx_data[247:240]),.o(syn_13_tmp[247:240]));
  gf_mult_by_52 m3346 (.i(rx_data[255:248]),.o(syn_13_tmp[255:248]));
  gf_mult_by_d1 m3347 (.i(rx_data[263:256]),.o(syn_13_tmp[263:256]));
  gf_mult_by_f1 m3348 (.i(rx_data[271:264]),.o(syn_13_tmp[271:264]));
  gf_mult_by_dc m3349 (.i(rx_data[279:272]),.o(syn_13_tmp[279:272]));
  gf_mult_by_1c m3350 (.i(rx_data[287:280]),.o(syn_13_tmp[287:280]));
  gf_mult_by_f2 m3351 (.i(rx_data[295:288]),.o(syn_13_tmp[295:288]));
  gf_mult_by_48 m3352 (.i(rx_data[303:296]),.o(syn_13_tmp[303:296]));
  gf_mult_by_16 m3353 (.i(rx_data[311:304]),.o(syn_13_tmp[311:304]));
  gf_mult_by_ad m3354 (.i(rx_data[319:312]),.o(syn_13_tmp[319:312]));
  gf_mult_by_74 m3355 (.i(rx_data[327:320]),.o(syn_13_tmp[327:320]));
  gf_mult_by_c9 m3356 (.i(rx_data[335:328]),.o(syn_13_tmp[335:328]));
  gf_mult_by_25 m3357 (.i(rx_data[343:336]),.o(syn_13_tmp[343:336]));
  gf_mult_by_8c m3358 (.i(rx_data[351:344]),.o(syn_13_tmp[351:344]));
  gf_mult_by_de m3359 (.i(rx_data[359:352]),.o(syn_13_tmp[359:352]));
  gf_mult_by_0f m3360 (.i(rx_data[367:360]),.o(syn_13_tmp[367:360]));
  gf_mult_by_fe m3361 (.i(rx_data[375:368]),.o(syn_13_tmp[375:368]));
  gf_mult_by_22 m3362 (.i(rx_data[383:376]),.o(syn_13_tmp[383:376]));
  gf_mult_by_3e m3363 (.i(rx_data[391:384]),.o(syn_13_tmp[391:384]));
  gf_mult_by_cc m3364 (.i(rx_data[399:392]),.o(syn_13_tmp[399:392]));
  gf_mult_by_84 m3365 (.i(rx_data[407:400]),.o(syn_13_tmp[407:400]));
  gf_mult_by_92 m3366 (.i(rx_data[415:408]),.o(syn_13_tmp[415:408]));
  gf_mult_by_3f m3367 (.i(rx_data[423:416]),.o(syn_13_tmp[423:416]));
  gf_mult_by_4b m3368 (.i(rx_data[431:424]),.o(syn_13_tmp[431:424]));
  gf_mult_by_82 m3369 (.i(rx_data[439:432]),.o(syn_13_tmp[439:432]));
  gf_mult_by_a7 m3370 (.i(rx_data[447:440]),.o(syn_13_tmp[447:440]));
  gf_mult_by_2b m3371 (.i(rx_data[455:448]),.o(syn_13_tmp[455:448]));
  gf_mult_by_f5 m3372 (.i(rx_data[463:456]),.o(syn_13_tmp[463:456]));
  gf_mult_by_fa m3373 (.i(rx_data[471:464]),.o(syn_13_tmp[471:464]));
  gf_mult_by_04 m3374 (.i(rx_data[479:472]),.o(syn_13_tmp[479:472]));
  gf_mult_by_26 m3375 (.i(rx_data[487:480]),.o(syn_13_tmp[487:480]));
  gf_mult_by_18 m3376 (.i(rx_data[495:488]),.o(syn_13_tmp[495:488]));
  gf_mult_by_d4 m3377 (.i(rx_data[503:496]),.o(syn_13_tmp[503:496]));
  gf_mult_by_50 m3378 (.i(rx_data[511:504]),.o(syn_13_tmp[511:504]));
  gf_mult_by_c2 m3379 (.i(rx_data[519:512]),.o(syn_13_tmp[519:512]));
  gf_mult_by_fd m3380 (.i(rx_data[527:520]),.o(syn_13_tmp[527:520]));
  gf_mult_by_b6 m3381 (.i(rx_data[535:528]),.o(syn_13_tmp[535:528]));
  gf_mult_by_34 m3382 (.i(rx_data[543:536]),.o(syn_13_tmp[543:536]));
  gf_mult_by_93 m3383 (.i(rx_data[551:544]),.o(syn_13_tmp[551:544]));
  gf_mult_by_b8 m3384 (.i(rx_data[559:552]),.o(syn_13_tmp[559:552]));
  gf_mult_by_4d m3385 (.i(rx_data[567:560]),.o(syn_13_tmp[567:560]));
  gf_mult_by_b7 m3386 (.i(rx_data[575:568]),.o(syn_13_tmp[575:568]));
  gf_mult_by_b3 m3387 (.i(rx_data[583:576]),.o(syn_13_tmp[583:576]));
  gf_mult_by_95 m3388 (.i(rx_data[591:584]),.o(syn_13_tmp[591:584]));
  gf_mult_by_8d m3389 (.i(rx_data[599:592]),.o(syn_13_tmp[599:592]));
  gf_mult_by_59 m3390 (.i(rx_data[607:600]),.o(syn_13_tmp[607:600]));
  gf_mult_by_09 m3391 (.i(rx_data[615:608]),.o(syn_13_tmp[615:608]));
  gf_mult_by_cb m3392 (.i(rx_data[623:616]),.o(syn_13_tmp[623:616]));
  gf_mult_by_36 m3393 (.i(rx_data[631:624]),.o(syn_13_tmp[631:624]));
  gf_mult_by_80 m3394 (.i(rx_data[639:632]),.o(syn_13_tmp[639:632]));
  gf_mult_by_b4 m3395 (.i(rx_data[647:640]),.o(syn_13_tmp[647:640]));
  gf_mult_by_27 m3396 (.i(rx_data[655:648]),.o(syn_13_tmp[655:648]));
  gf_mult_by_9f m3397 (.i(rx_data[663:656]),.o(syn_13_tmp[663:656]));
  gf_mult_by_d2 m3398 (.i(rx_data[671:664]),.o(syn_13_tmp[671:664]));
  gf_mult_by_65 m3399 (.i(rx_data[679:672]),.o(syn_13_tmp[679:672]));
  gf_mult_by_d6 m3400 (.i(rx_data[687:680]),.o(syn_13_tmp[687:680]));
  gf_mult_by_43 m3401 (.i(rx_data[695:688]),.o(syn_13_tmp[695:688]));
  gf_mult_by_ce m3402 (.i(rx_data[703:696]),.o(syn_13_tmp[703:696]));
  gf_mult_by_97 m3403 (.i(rx_data[711:704]),.o(syn_13_tmp[711:704]));
  gf_mult_by_9e m3404 (.i(rx_data[719:712]),.o(syn_13_tmp[719:712]));
  gf_mult_by_55 m3405 (.i(rx_data[727:720]),.o(syn_13_tmp[727:720]));
  gf_mult_by_63 m3406 (.i(rx_data[735:728]),.o(syn_13_tmp[735:728]));
  gf_mult_by_e3 m3407 (.i(rx_data[743:736]),.o(syn_13_tmp[743:736]));
  gf_mult_by_57 m3408 (.i(rx_data[751:744]),.o(syn_13_tmp[751:744]));
  gf_mult_by_70 m3409 (.i(rx_data[759:752]),.o(syn_13_tmp[759:752]));
  gf_mult_by_ef m3410 (.i(rx_data[767:760]),.o(syn_13_tmp[767:760]));
  gf_mult_by_3d m3411 (.i(rx_data[775:768]),.o(syn_13_tmp[775:768]));
  gf_mult_by_58 m3412 (.i(rx_data[783:776]),.o(syn_13_tmp[783:776]));
  gf_mult_by_8e m3413 (.i(rx_data[791:784]),.o(syn_13_tmp[791:784]));
  gf_mult_by_cd m3414 (.i(rx_data[799:792]),.o(syn_13_tmp[799:792]));
  gf_mult_by_03 m3415 (.i(rx_data[807:800]),.o(syn_13_tmp[807:800]));
  gf_mult_by_94 m3416 (.i(rx_data[815:808]),.o(syn_13_tmp[815:808]));
  gf_mult_by_0a m3417 (.i(rx_data[823:816]),.o(syn_13_tmp[823:816]));
  gf_mult_by_5f m3418 (.i(rx_data[831:824]),.o(syn_13_tmp[831:824]));
  gf_mult_by_3c m3419 (.i(rx_data[839:832]),.o(syn_13_tmp[839:832]));
  gf_mult_by_df m3420 (.i(rx_data[847:840]),.o(syn_13_tmp[847:840]));
  gf_mult_by_88 m3421 (.i(rx_data[855:848]),.o(syn_13_tmp[855:848]));
  gf_mult_by_f8 m3422 (.i(rx_data[863:856]),.o(syn_13_tmp[863:856]));
  gf_mult_by_17 m3423 (.i(rx_data[871:864]),.o(syn_13_tmp[871:864]));
  gf_mult_by_2a m3424 (.i(rx_data[879:872]),.o(syn_13_tmp[879:872]));
  gf_mult_by_72 m3425 (.i(rx_data[887:880]),.o(syn_13_tmp[887:880]));
  gf_mult_by_fc m3426 (.i(rx_data[895:888]),.o(syn_13_tmp[895:888]));
  gf_mult_by_31 m3427 (.i(rx_data[903:896]),.o(syn_13_tmp[903:896]));
  gf_mult_by_32 m3428 (.i(rx_data[911:904]),.o(syn_13_tmp[911:904]));
  gf_mult_by_a6 m3429 (.i(rx_data[919:912]),.o(syn_13_tmp[919:912]));
  gf_mult_by_ac m3430 (.i(rx_data[927:920]),.o(syn_13_tmp[927:920]));
  gf_mult_by_f3 m3431 (.i(rx_data[935:928]),.o(syn_13_tmp[935:928]));
  gf_mult_by_cf m3432 (.i(rx_data[943:936]),.o(syn_13_tmp[943:936]));
  gf_mult_by_10 m3433 (.i(rx_data[951:944]),.o(syn_13_tmp[951:944]));
  gf_mult_by_98 m3434 (.i(rx_data[959:952]),.o(syn_13_tmp[959:952]));
  gf_mult_by_60 m3435 (.i(rx_data[967:960]),.o(syn_13_tmp[967:960]));
  gf_mult_by_77 m3436 (.i(rx_data[975:968]),.o(syn_13_tmp[975:968]));
  gf_mult_by_5d m3437 (.i(rx_data[983:976]),.o(syn_13_tmp[983:976]));
  gf_mult_by_2f m3438 (.i(rx_data[991:984]),.o(syn_13_tmp[991:984]));
  gf_mult_by_d3 m3439 (.i(rx_data[999:992]),.o(syn_13_tmp[999:992]));
  gf_mult_by_e2 m3440 (.i(rx_data[1007:1000]),.o(syn_13_tmp[1007:1000]));
  gf_mult_by_d0 m3441 (.i(rx_data[1015:1008]),.o(syn_13_tmp[1015:1008]));
  gf_mult_by_76 m3442 (.i(rx_data[1023:1016]),.o(syn_13_tmp[1023:1016]));
  gf_mult_by_da m3443 (.i(rx_data[1031:1024]),.o(syn_13_tmp[1031:1024]));
  gf_mult_by_29 m3444 (.i(rx_data[1039:1032]),.o(syn_13_tmp[1039:1032]));
  gf_mult_by_e6 m3445 (.i(rx_data[1047:1040]),.o(syn_13_tmp[1047:1040]));
  gf_mult_by_f6 m3446 (.i(rx_data[1055:1048]),.o(syn_13_tmp[1055:1048]));
  gf_mult_by_6e m3447 (.i(rx_data[1063:1056]),.o(syn_13_tmp[1063:1056]));
  gf_mult_by_0e m3448 (.i(rx_data[1071:1064]),.o(syn_13_tmp[1071:1064]));
  gf_mult_by_79 m3449 (.i(rx_data[1079:1072]),.o(syn_13_tmp[1079:1072]));
  gf_mult_by_24 m3450 (.i(rx_data[1087:1080]),.o(syn_13_tmp[1087:1080]));
  gf_mult_by_0b m3451 (.i(rx_data[1095:1088]),.o(syn_13_tmp[1095:1088]));
  gf_mult_by_d8 m3452 (.i(rx_data[1103:1096]),.o(syn_13_tmp[1103:1096]));
  gf_mult_by_3a m3453 (.i(rx_data[1111:1104]),.o(syn_13_tmp[1111:1104]));
  gf_mult_by_ea m3454 (.i(rx_data[1119:1112]),.o(syn_13_tmp[1119:1112]));
  gf_mult_by_9c m3455 (.i(rx_data[1127:1120]),.o(syn_13_tmp[1127:1120]));
  gf_mult_by_46 m3456 (.i(rx_data[1135:1128]),.o(syn_13_tmp[1135:1128]));
  gf_mult_by_6f m3457 (.i(rx_data[1143:1136]),.o(syn_13_tmp[1143:1136]));
  gf_mult_by_89 m3458 (.i(rx_data[1151:1144]),.o(syn_13_tmp[1151:1144]));
  gf_mult_by_7f m3459 (.i(rx_data[1159:1152]),.o(syn_13_tmp[1159:1152]));
  gf_mult_by_11 m3460 (.i(rx_data[1167:1160]),.o(syn_13_tmp[1167:1160]));
  gf_mult_by_1f m3461 (.i(rx_data[1175:1168]),.o(syn_13_tmp[1175:1168]));
  gf_mult_by_66 m3462 (.i(rx_data[1183:1176]),.o(syn_13_tmp[1183:1176]));
  gf_mult_by_42 m3463 (.i(rx_data[1191:1184]),.o(syn_13_tmp[1191:1184]));
  gf_mult_by_49 m3464 (.i(rx_data[1199:1192]),.o(syn_13_tmp[1199:1192]));
  gf_mult_by_91 m3465 (.i(rx_data[1207:1200]),.o(syn_13_tmp[1207:1200]));
  gf_mult_by_ab m3466 (.i(rx_data[1215:1208]),.o(syn_13_tmp[1215:1208]));
  gf_mult_by_41 m3467 (.i(rx_data[1223:1216]),.o(syn_13_tmp[1223:1216]));
  gf_mult_by_dd m3468 (.i(rx_data[1231:1224]),.o(syn_13_tmp[1231:1224]));
  gf_mult_by_9b m3469 (.i(rx_data[1239:1232]),.o(syn_13_tmp[1239:1232]));
  gf_mult_by_f4 m3470 (.i(rx_data[1247:1240]),.o(syn_13_tmp[1247:1240]));
  gf_mult_by_7d m3471 (.i(rx_data[1255:1248]),.o(syn_13_tmp[1255:1248]));
  gf_mult_by_02 m3472 (.i(rx_data[1263:1256]),.o(syn_13_tmp[1263:1256]));
  gf_mult_by_13 m3473 (.i(rx_data[1271:1264]),.o(syn_13_tmp[1271:1264]));
  gf_mult_by_0c m3474 (.i(rx_data[1279:1272]),.o(syn_13_tmp[1279:1272]));
  gf_mult_by_6a m3475 (.i(rx_data[1287:1280]),.o(syn_13_tmp[1287:1280]));
  gf_mult_by_28 m3476 (.i(rx_data[1295:1288]),.o(syn_13_tmp[1295:1288]));
  gf_mult_by_61 m3477 (.i(rx_data[1303:1296]),.o(syn_13_tmp[1303:1296]));
  gf_mult_by_f0 m3478 (.i(rx_data[1311:1304]),.o(syn_13_tmp[1311:1304]));
  gf_mult_by_5b m3479 (.i(rx_data[1319:1312]),.o(syn_13_tmp[1319:1312]));
  gf_mult_by_1a m3480 (.i(rx_data[1327:1320]),.o(syn_13_tmp[1327:1320]));
  gf_mult_by_c7 m3481 (.i(rx_data[1335:1328]),.o(syn_13_tmp[1335:1328]));
  gf_mult_by_5c m3482 (.i(rx_data[1343:1336]),.o(syn_13_tmp[1343:1336]));
  gf_mult_by_a8 m3483 (.i(rx_data[1351:1344]),.o(syn_13_tmp[1351:1344]));
  gf_mult_by_d5 m3484 (.i(rx_data[1359:1352]),.o(syn_13_tmp[1359:1352]));
  gf_mult_by_d7 m3485 (.i(rx_data[1367:1360]),.o(syn_13_tmp[1367:1360]));
  gf_mult_by_c4 m3486 (.i(rx_data[1375:1368]),.o(syn_13_tmp[1375:1368]));
  gf_mult_by_c8 m3487 (.i(rx_data[1383:1376]),.o(syn_13_tmp[1383:1376]));
  gf_mult_by_a2 m3488 (.i(rx_data[1391:1384]),.o(syn_13_tmp[1391:1384]));
  gf_mult_by_8a m3489 (.i(rx_data[1399:1392]),.o(syn_13_tmp[1399:1392]));
  gf_mult_by_eb m3490 (.i(rx_data[1407:1400]),.o(syn_13_tmp[1407:1400]));
  gf_mult_by_1b m3491 (.i(rx_data[1415:1408]),.o(syn_13_tmp[1415:1408]));
  gf_mult_by_40 m3492 (.i(rx_data[1423:1416]),.o(syn_13_tmp[1423:1416]));
  gf_mult_by_5a m3493 (.i(rx_data[1431:1424]),.o(syn_13_tmp[1431:1424]));
  gf_mult_by_9d m3494 (.i(rx_data[1439:1432]),.o(syn_13_tmp[1439:1432]));
  gf_mult_by_c1 m3495 (.i(rx_data[1447:1440]),.o(syn_13_tmp[1447:1440]));
  gf_mult_by_69 m3496 (.i(rx_data[1455:1448]),.o(syn_13_tmp[1455:1448]));
  gf_mult_by_bc m3497 (.i(rx_data[1463:1456]),.o(syn_13_tmp[1463:1456]));
  gf_mult_by_6b m3498 (.i(rx_data[1471:1464]),.o(syn_13_tmp[1471:1464]));
  gf_mult_by_af m3499 (.i(rx_data[1479:1472]),.o(syn_13_tmp[1479:1472]));
  gf_mult_by_67 m3500 (.i(rx_data[1487:1480]),.o(syn_13_tmp[1487:1480]));
  gf_mult_by_c5 m3501 (.i(rx_data[1495:1488]),.o(syn_13_tmp[1495:1488]));
  gf_mult_by_4f m3502 (.i(rx_data[1503:1496]),.o(syn_13_tmp[1503:1496]));
  gf_mult_by_a4 m3503 (.i(rx_data[1511:1504]),.o(syn_13_tmp[1511:1504]));
  gf_mult_by_bf m3504 (.i(rx_data[1519:1512]),.o(syn_13_tmp[1519:1512]));
  gf_mult_by_ff m3505 (.i(rx_data[1527:1520]),.o(syn_13_tmp[1527:1520]));
  gf_mult_by_a5 m3506 (.i(rx_data[1535:1528]),.o(syn_13_tmp[1535:1528]));
  gf_mult_by_38 m3507 (.i(rx_data[1543:1536]),.o(syn_13_tmp[1543:1536]));
  gf_mult_by_f9 m3508 (.i(rx_data[1551:1544]),.o(syn_13_tmp[1551:1544]));
  gf_mult_by_90 m3509 (.i(rx_data[1559:1552]),.o(syn_13_tmp[1559:1552]));
  gf_mult_by_2c m3510 (.i(rx_data[1567:1560]),.o(syn_13_tmp[1567:1560]));
  gf_mult_by_47 m3511 (.i(rx_data[1575:1568]),.o(syn_13_tmp[1575:1568]));
  gf_mult_by_e8 m3512 (.i(rx_data[1583:1576]),.o(syn_13_tmp[1583:1576]));
  gf_mult_by_8f m3513 (.i(rx_data[1591:1584]),.o(syn_13_tmp[1591:1584]));
  gf_mult_by_4a m3514 (.i(rx_data[1599:1592]),.o(syn_13_tmp[1599:1592]));
  gf_mult_by_05 m3515 (.i(rx_data[1607:1600]),.o(syn_13_tmp[1607:1600]));
  gf_mult_by_a1 m3516 (.i(rx_data[1615:1608]),.o(syn_13_tmp[1615:1608]));
  gf_mult_by_1e m3517 (.i(rx_data[1623:1616]),.o(syn_13_tmp[1623:1616]));
  gf_mult_by_e1 m3518 (.i(rx_data[1631:1624]),.o(syn_13_tmp[1631:1624]));
  gf_mult_by_44 m3519 (.i(rx_data[1639:1632]),.o(syn_13_tmp[1639:1632]));
  gf_mult_by_7c m3520 (.i(rx_data[1647:1640]),.o(syn_13_tmp[1647:1640]));
  gf_mult_by_85 m3521 (.i(rx_data[1655:1648]),.o(syn_13_tmp[1655:1648]));
  gf_mult_by_15 m3522 (.i(rx_data[1663:1656]),.o(syn_13_tmp[1663:1656]));
  gf_mult_by_39 m3523 (.i(rx_data[1671:1664]),.o(syn_13_tmp[1671:1664]));
  gf_mult_by_7e m3524 (.i(rx_data[1679:1672]),.o(syn_13_tmp[1679:1672]));
  gf_mult_by_96 m3525 (.i(rx_data[1687:1680]),.o(syn_13_tmp[1687:1680]));
  gf_mult_by_19 m3526 (.i(rx_data[1695:1688]),.o(syn_13_tmp[1695:1688]));
  gf_mult_by_53 m3527 (.i(rx_data[1703:1696]),.o(syn_13_tmp[1703:1696]));
  gf_mult_by_56 m3528 (.i(rx_data[1711:1704]),.o(syn_13_tmp[1711:1704]));
  gf_mult_by_f7 m3529 (.i(rx_data[1719:1712]),.o(syn_13_tmp[1719:1712]));
  gf_mult_by_e9 m3530 (.i(rx_data[1727:1720]),.o(syn_13_tmp[1727:1720]));
  gf_mult_by_08 m3531 (.i(rx_data[1735:1728]),.o(syn_13_tmp[1735:1728]));
  gf_mult_by_4c m3532 (.i(rx_data[1743:1736]),.o(syn_13_tmp[1743:1736]));
  gf_mult_by_30 m3533 (.i(rx_data[1751:1744]),.o(syn_13_tmp[1751:1744]));
  gf_mult_by_b5 m3534 (.i(rx_data[1759:1752]),.o(syn_13_tmp[1759:1752]));
  gf_mult_by_a0 m3535 (.i(rx_data[1767:1760]),.o(syn_13_tmp[1767:1760]));
  gf_mult_by_99 m3536 (.i(rx_data[1775:1768]),.o(syn_13_tmp[1775:1768]));
  gf_mult_by_e7 m3537 (.i(rx_data[1783:1776]),.o(syn_13_tmp[1783:1776]));
  gf_mult_by_71 m3538 (.i(rx_data[1791:1784]),.o(syn_13_tmp[1791:1784]));
  gf_mult_by_68 m3539 (.i(rx_data[1799:1792]),.o(syn_13_tmp[1799:1792]));
  gf_mult_by_3b m3540 (.i(rx_data[1807:1800]),.o(syn_13_tmp[1807:1800]));
  gf_mult_by_6d m3541 (.i(rx_data[1815:1808]),.o(syn_13_tmp[1815:1808]));
  gf_mult_by_9a m3542 (.i(rx_data[1823:1816]),.o(syn_13_tmp[1823:1816]));
  gf_mult_by_73 m3543 (.i(rx_data[1831:1824]),.o(syn_13_tmp[1831:1824]));
  gf_mult_by_7b m3544 (.i(rx_data[1839:1832]),.o(syn_13_tmp[1839:1832]));
  gf_mult_by_37 m3545 (.i(rx_data[1847:1840]),.o(syn_13_tmp[1847:1840]));
  gf_mult_by_07 m3546 (.i(rx_data[1855:1848]),.o(syn_13_tmp[1855:1848]));
  gf_mult_by_b2 m3547 (.i(rx_data[1863:1856]),.o(syn_13_tmp[1863:1856]));
  gf_mult_by_12 m3548 (.i(rx_data[1871:1864]),.o(syn_13_tmp[1871:1864]));
  gf_mult_by_8b m3549 (.i(rx_data[1879:1872]),.o(syn_13_tmp[1879:1872]));
  gf_mult_by_6c m3550 (.i(rx_data[1887:1880]),.o(syn_13_tmp[1887:1880]));
  gf_mult_by_1d m3551 (.i(rx_data[1895:1888]),.o(syn_13_tmp[1895:1888]));
  gf_mult_by_75 m3552 (.i(rx_data[1903:1896]),.o(syn_13_tmp[1903:1896]));
  gf_mult_by_4e m3553 (.i(rx_data[1911:1904]),.o(syn_13_tmp[1911:1904]));
  gf_mult_by_23 m3554 (.i(rx_data[1919:1912]),.o(syn_13_tmp[1919:1912]));
  gf_mult_by_b9 m3555 (.i(rx_data[1927:1920]),.o(syn_13_tmp[1927:1920]));
  gf_mult_by_ca m3556 (.i(rx_data[1935:1928]),.o(syn_13_tmp[1935:1928]));
  gf_mult_by_b1 m3557 (.i(rx_data[1943:1936]),.o(syn_13_tmp[1943:1936]));
  gf_mult_by_86 m3558 (.i(rx_data[1951:1944]),.o(syn_13_tmp[1951:1944]));
  gf_mult_by_81 m3559 (.i(rx_data[1959:1952]),.o(syn_13_tmp[1959:1952]));
  gf_mult_by_33 m3560 (.i(rx_data[1967:1960]),.o(syn_13_tmp[1967:1960]));
  gf_mult_by_21 m3561 (.i(rx_data[1975:1968]),.o(syn_13_tmp[1975:1968]));
  gf_mult_by_aa m3562 (.i(rx_data[1983:1976]),.o(syn_13_tmp[1983:1976]));
  gf_mult_by_c6 m3563 (.i(rx_data[1991:1984]),.o(syn_13_tmp[1991:1984]));
  gf_mult_by_db m3564 (.i(rx_data[1999:1992]),.o(syn_13_tmp[1999:1992]));
  gf_mult_by_ae m3565 (.i(rx_data[2007:2000]),.o(syn_13_tmp[2007:2000]));
  gf_mult_by_e0 m3566 (.i(rx_data[2015:2008]),.o(syn_13_tmp[2015:2008]));
  gf_mult_by_c3 m3567 (.i(rx_data[2023:2016]),.o(syn_13_tmp[2023:2016]));
  gf_mult_by_7a m3568 (.i(rx_data[2031:2024]),.o(syn_13_tmp[2031:2024]));
  gf_mult_by_b0 m3569 (.i(rx_data[2039:2032]),.o(syn_13_tmp[2039:2032]));
  assign syndrome[111:104] =
      syn_13_tmp[7:0] ^ syn_13_tmp[15:8] ^ syn_13_tmp[23:16] ^ 
      syn_13_tmp[31:24] ^ syn_13_tmp[39:32] ^ syn_13_tmp[47:40] ^ 
      syn_13_tmp[55:48] ^ syn_13_tmp[63:56] ^ syn_13_tmp[71:64] ^ 
      syn_13_tmp[79:72] ^ syn_13_tmp[87:80] ^ syn_13_tmp[95:88] ^ 
      syn_13_tmp[103:96] ^ syn_13_tmp[111:104] ^ syn_13_tmp[119:112] ^ 
      syn_13_tmp[127:120] ^ syn_13_tmp[135:128] ^ syn_13_tmp[143:136] ^ 
      syn_13_tmp[151:144] ^ syn_13_tmp[159:152] ^ syn_13_tmp[167:160] ^ 
      syn_13_tmp[175:168] ^ syn_13_tmp[183:176] ^ syn_13_tmp[191:184] ^ 
      syn_13_tmp[199:192] ^ syn_13_tmp[207:200] ^ syn_13_tmp[215:208] ^ 
      syn_13_tmp[223:216] ^ syn_13_tmp[231:224] ^ syn_13_tmp[239:232] ^ 
      syn_13_tmp[247:240] ^ syn_13_tmp[255:248] ^ syn_13_tmp[263:256] ^ 
      syn_13_tmp[271:264] ^ syn_13_tmp[279:272] ^ syn_13_tmp[287:280] ^ 
      syn_13_tmp[295:288] ^ syn_13_tmp[303:296] ^ syn_13_tmp[311:304] ^ 
      syn_13_tmp[319:312] ^ syn_13_tmp[327:320] ^ syn_13_tmp[335:328] ^ 
      syn_13_tmp[343:336] ^ syn_13_tmp[351:344] ^ syn_13_tmp[359:352] ^ 
      syn_13_tmp[367:360] ^ syn_13_tmp[375:368] ^ syn_13_tmp[383:376] ^ 
      syn_13_tmp[391:384] ^ syn_13_tmp[399:392] ^ syn_13_tmp[407:400] ^ 
      syn_13_tmp[415:408] ^ syn_13_tmp[423:416] ^ syn_13_tmp[431:424] ^ 
      syn_13_tmp[439:432] ^ syn_13_tmp[447:440] ^ syn_13_tmp[455:448] ^ 
      syn_13_tmp[463:456] ^ syn_13_tmp[471:464] ^ syn_13_tmp[479:472] ^ 
      syn_13_tmp[487:480] ^ syn_13_tmp[495:488] ^ syn_13_tmp[503:496] ^ 
      syn_13_tmp[511:504] ^ syn_13_tmp[519:512] ^ syn_13_tmp[527:520] ^ 
      syn_13_tmp[535:528] ^ syn_13_tmp[543:536] ^ syn_13_tmp[551:544] ^ 
      syn_13_tmp[559:552] ^ syn_13_tmp[567:560] ^ syn_13_tmp[575:568] ^ 
      syn_13_tmp[583:576] ^ syn_13_tmp[591:584] ^ syn_13_tmp[599:592] ^ 
      syn_13_tmp[607:600] ^ syn_13_tmp[615:608] ^ syn_13_tmp[623:616] ^ 
      syn_13_tmp[631:624] ^ syn_13_tmp[639:632] ^ syn_13_tmp[647:640] ^ 
      syn_13_tmp[655:648] ^ syn_13_tmp[663:656] ^ syn_13_tmp[671:664] ^ 
      syn_13_tmp[679:672] ^ syn_13_tmp[687:680] ^ syn_13_tmp[695:688] ^ 
      syn_13_tmp[703:696] ^ syn_13_tmp[711:704] ^ syn_13_tmp[719:712] ^ 
      syn_13_tmp[727:720] ^ syn_13_tmp[735:728] ^ syn_13_tmp[743:736] ^ 
      syn_13_tmp[751:744] ^ syn_13_tmp[759:752] ^ syn_13_tmp[767:760] ^ 
      syn_13_tmp[775:768] ^ syn_13_tmp[783:776] ^ syn_13_tmp[791:784] ^ 
      syn_13_tmp[799:792] ^ syn_13_tmp[807:800] ^ syn_13_tmp[815:808] ^ 
      syn_13_tmp[823:816] ^ syn_13_tmp[831:824] ^ syn_13_tmp[839:832] ^ 
      syn_13_tmp[847:840] ^ syn_13_tmp[855:848] ^ syn_13_tmp[863:856] ^ 
      syn_13_tmp[871:864] ^ syn_13_tmp[879:872] ^ syn_13_tmp[887:880] ^ 
      syn_13_tmp[895:888] ^ syn_13_tmp[903:896] ^ syn_13_tmp[911:904] ^ 
      syn_13_tmp[919:912] ^ syn_13_tmp[927:920] ^ syn_13_tmp[935:928] ^ 
      syn_13_tmp[943:936] ^ syn_13_tmp[951:944] ^ syn_13_tmp[959:952] ^ 
      syn_13_tmp[967:960] ^ syn_13_tmp[975:968] ^ syn_13_tmp[983:976] ^ 
      syn_13_tmp[991:984] ^ syn_13_tmp[999:992] ^ syn_13_tmp[1007:1000] ^ 
      syn_13_tmp[1015:1008] ^ syn_13_tmp[1023:1016] ^ syn_13_tmp[1031:1024] ^ 
      syn_13_tmp[1039:1032] ^ syn_13_tmp[1047:1040] ^ syn_13_tmp[1055:1048] ^ 
      syn_13_tmp[1063:1056] ^ syn_13_tmp[1071:1064] ^ syn_13_tmp[1079:1072] ^ 
      syn_13_tmp[1087:1080] ^ syn_13_tmp[1095:1088] ^ syn_13_tmp[1103:1096] ^ 
      syn_13_tmp[1111:1104] ^ syn_13_tmp[1119:1112] ^ syn_13_tmp[1127:1120] ^ 
      syn_13_tmp[1135:1128] ^ syn_13_tmp[1143:1136] ^ syn_13_tmp[1151:1144] ^ 
      syn_13_tmp[1159:1152] ^ syn_13_tmp[1167:1160] ^ syn_13_tmp[1175:1168] ^ 
      syn_13_tmp[1183:1176] ^ syn_13_tmp[1191:1184] ^ syn_13_tmp[1199:1192] ^ 
      syn_13_tmp[1207:1200] ^ syn_13_tmp[1215:1208] ^ syn_13_tmp[1223:1216] ^ 
      syn_13_tmp[1231:1224] ^ syn_13_tmp[1239:1232] ^ syn_13_tmp[1247:1240] ^ 
      syn_13_tmp[1255:1248] ^ syn_13_tmp[1263:1256] ^ syn_13_tmp[1271:1264] ^ 
      syn_13_tmp[1279:1272] ^ syn_13_tmp[1287:1280] ^ syn_13_tmp[1295:1288] ^ 
      syn_13_tmp[1303:1296] ^ syn_13_tmp[1311:1304] ^ syn_13_tmp[1319:1312] ^ 
      syn_13_tmp[1327:1320] ^ syn_13_tmp[1335:1328] ^ syn_13_tmp[1343:1336] ^ 
      syn_13_tmp[1351:1344] ^ syn_13_tmp[1359:1352] ^ syn_13_tmp[1367:1360] ^ 
      syn_13_tmp[1375:1368] ^ syn_13_tmp[1383:1376] ^ syn_13_tmp[1391:1384] ^ 
      syn_13_tmp[1399:1392] ^ syn_13_tmp[1407:1400] ^ syn_13_tmp[1415:1408] ^ 
      syn_13_tmp[1423:1416] ^ syn_13_tmp[1431:1424] ^ syn_13_tmp[1439:1432] ^ 
      syn_13_tmp[1447:1440] ^ syn_13_tmp[1455:1448] ^ syn_13_tmp[1463:1456] ^ 
      syn_13_tmp[1471:1464] ^ syn_13_tmp[1479:1472] ^ syn_13_tmp[1487:1480] ^ 
      syn_13_tmp[1495:1488] ^ syn_13_tmp[1503:1496] ^ syn_13_tmp[1511:1504] ^ 
      syn_13_tmp[1519:1512] ^ syn_13_tmp[1527:1520] ^ syn_13_tmp[1535:1528] ^ 
      syn_13_tmp[1543:1536] ^ syn_13_tmp[1551:1544] ^ syn_13_tmp[1559:1552] ^ 
      syn_13_tmp[1567:1560] ^ syn_13_tmp[1575:1568] ^ syn_13_tmp[1583:1576] ^ 
      syn_13_tmp[1591:1584] ^ syn_13_tmp[1599:1592] ^ syn_13_tmp[1607:1600] ^ 
      syn_13_tmp[1615:1608] ^ syn_13_tmp[1623:1616] ^ syn_13_tmp[1631:1624] ^ 
      syn_13_tmp[1639:1632] ^ syn_13_tmp[1647:1640] ^ syn_13_tmp[1655:1648] ^ 
      syn_13_tmp[1663:1656] ^ syn_13_tmp[1671:1664] ^ syn_13_tmp[1679:1672] ^ 
      syn_13_tmp[1687:1680] ^ syn_13_tmp[1695:1688] ^ syn_13_tmp[1703:1696] ^ 
      syn_13_tmp[1711:1704] ^ syn_13_tmp[1719:1712] ^ syn_13_tmp[1727:1720] ^ 
      syn_13_tmp[1735:1728] ^ syn_13_tmp[1743:1736] ^ syn_13_tmp[1751:1744] ^ 
      syn_13_tmp[1759:1752] ^ syn_13_tmp[1767:1760] ^ syn_13_tmp[1775:1768] ^ 
      syn_13_tmp[1783:1776] ^ syn_13_tmp[1791:1784] ^ syn_13_tmp[1799:1792] ^ 
      syn_13_tmp[1807:1800] ^ syn_13_tmp[1815:1808] ^ syn_13_tmp[1823:1816] ^ 
      syn_13_tmp[1831:1824] ^ syn_13_tmp[1839:1832] ^ syn_13_tmp[1847:1840] ^ 
      syn_13_tmp[1855:1848] ^ syn_13_tmp[1863:1856] ^ syn_13_tmp[1871:1864] ^ 
      syn_13_tmp[1879:1872] ^ syn_13_tmp[1887:1880] ^ syn_13_tmp[1895:1888] ^ 
      syn_13_tmp[1903:1896] ^ syn_13_tmp[1911:1904] ^ syn_13_tmp[1919:1912] ^ 
      syn_13_tmp[1927:1920] ^ syn_13_tmp[1935:1928] ^ syn_13_tmp[1943:1936] ^ 
      syn_13_tmp[1951:1944] ^ syn_13_tmp[1959:1952] ^ syn_13_tmp[1967:1960] ^ 
      syn_13_tmp[1975:1968] ^ syn_13_tmp[1983:1976] ^ syn_13_tmp[1991:1984] ^ 
      syn_13_tmp[1999:1992] ^ syn_13_tmp[2007:2000] ^ syn_13_tmp[2015:2008] ^ 
      syn_13_tmp[2023:2016] ^ syn_13_tmp[2031:2024] ^ syn_13_tmp[2039:2032];

// syndrome 14
  wire [2039:0] syn_14_tmp;
  gf_mult_by_01 m3570 (.i(rx_data[7:0]),.o(syn_14_tmp[7:0]));
  gf_mult_by_13 m3571 (.i(rx_data[15:8]),.o(syn_14_tmp[15:8]));
  gf_mult_by_18 m3572 (.i(rx_data[23:16]),.o(syn_14_tmp[23:16]));
  gf_mult_by_b5 m3573 (.i(rx_data[31:24]),.o(syn_14_tmp[31:24]));
  gf_mult_by_5d m3574 (.i(rx_data[39:32]),.o(syn_14_tmp[39:32]));
  gf_mult_by_5e m3575 (.i(rx_data[47:40]),.o(syn_14_tmp[47:40]));
  gf_mult_by_6b m3576 (.i(rx_data[55:48]),.o(syn_14_tmp[55:48]));
  gf_mult_by_43 m3577 (.i(rx_data[63:56]),.o(syn_14_tmp[63:56]));
  gf_mult_by_81 m3578 (.i(rx_data[71:64]),.o(syn_14_tmp[71:64]));
  gf_mult_by_66 m3579 (.i(rx_data[79:72]),.o(syn_14_tmp[79:72]));
  gf_mult_by_84 m3580 (.i(rx_data[87:80]),.o(syn_14_tmp[87:80]));
  gf_mult_by_39 m3581 (.i(rx_data[95:88]),.o(syn_14_tmp[95:88]));
  gf_mult_by_fc m3582 (.i(rx_data[103:96]),.o(syn_14_tmp[103:96]));
  gf_mult_by_62 m3583 (.i(rx_data[111:104]),.o(syn_14_tmp[111:104]));
  gf_mult_by_c8 m3584 (.i(rx_data[119:112]),.o(syn_14_tmp[119:112]));
  gf_mult_by_59 m3585 (.i(rx_data[127:120]),.o(syn_14_tmp[127:120]));
  gf_mult_by_12 m3586 (.i(rx_data[135:128]),.o(syn_14_tmp[135:128]));
  gf_mult_by_0b m3587 (.i(rx_data[143:136]),.o(syn_14_tmp[143:136]));
  gf_mult_by_ad m3588 (.i(rx_data[151:144]),.o(syn_14_tmp[151:144]));
  gf_mult_by_e8 m3589 (.i(rx_data[159:152]),.o(syn_14_tmp[159:152]));
  gf_mult_by_03 m3590 (.i(rx_data[167:160]),.o(syn_14_tmp[167:160]));
  gf_mult_by_35 m3591 (.i(rx_data[175:168]),.o(syn_14_tmp[175:168]));
  gf_mult_by_28 m3592 (.i(rx_data[183:176]),.o(syn_14_tmp[183:176]));
  gf_mult_by_c2 m3593 (.i(rx_data[191:184]),.o(syn_14_tmp[191:184]));
  gf_mult_by_e7 m3594 (.i(rx_data[199:192]),.o(syn_14_tmp[199:192]));
  gf_mult_by_e2 m3595 (.i(rx_data[207:200]),.o(syn_14_tmp[207:200]));
  gf_mult_by_bd m3596 (.i(rx_data[215:208]),.o(syn_14_tmp[215:208]));
  gf_mult_by_c5 m3597 (.i(rx_data[223:216]),.o(syn_14_tmp[223:216]));
  gf_mult_by_9e m3598 (.i(rx_data[231:224]),.o(syn_14_tmp[231:224]));
  gf_mult_by_aa m3599 (.i(rx_data[239:232]),.o(syn_14_tmp[239:232]));
  gf_mult_by_91 m3600 (.i(rx_data[247:240]),.o(syn_14_tmp[247:240]));
  gf_mult_by_4b m3601 (.i(rx_data[255:248]),.o(syn_14_tmp[255:248]));
  gf_mult_by_19 m3602 (.i(rx_data[263:256]),.o(syn_14_tmp[263:256]));
  gf_mult_by_a6 m3603 (.i(rx_data[271:264]),.o(syn_14_tmp[271:264]));
  gf_mult_by_45 m3604 (.i(rx_data[279:272]),.o(syn_14_tmp[279:272]));
  gf_mult_by_eb m3605 (.i(rx_data[287:280]),.o(syn_14_tmp[287:280]));
  gf_mult_by_36 m3606 (.i(rx_data[295:288]),.o(syn_14_tmp[295:288]));
  gf_mult_by_1d m3607 (.i(rx_data[303:296]),.o(syn_14_tmp[303:296]));
  gf_mult_by_ea m3608 (.i(rx_data[311:304]),.o(syn_14_tmp[311:304]));
  gf_mult_by_25 m3609 (.i(rx_data[319:312]),.o(syn_14_tmp[319:312]));
  gf_mult_by_05 m3610 (.i(rx_data[327:320]),.o(syn_14_tmp[327:320]));
  gf_mult_by_5f m3611 (.i(rx_data[335:328]),.o(syn_14_tmp[335:328]));
  gf_mult_by_78 m3612 (.i(rx_data[343:336]),.o(syn_14_tmp[343:336]));
  gf_mult_by_5b m3613 (.i(rx_data[351:344]),.o(syn_14_tmp[351:344]));
  gf_mult_by_34 m3614 (.i(rx_data[359:352]),.o(syn_14_tmp[359:352]));
  gf_mult_by_3b m3615 (.i(rx_data[367:360]),.o(syn_14_tmp[367:360]));
  gf_mult_by_da m3616 (.i(rx_data[375:368]),.o(syn_14_tmp[375:368]));
  gf_mult_by_52 m3617 (.i(rx_data[383:376]),.o(syn_14_tmp[383:376]));
  gf_mult_by_bf m3618 (.i(rx_data[391:384]),.o(syn_14_tmp[391:384]));
  gf_mult_by_e3 m3619 (.i(rx_data[399:392]),.o(syn_14_tmp[399:392]));
  gf_mult_by_ae m3620 (.i(rx_data[407:400]),.o(syn_14_tmp[407:400]));
  gf_mult_by_dd m3621 (.i(rx_data[415:408]),.o(syn_14_tmp[415:408]));
  gf_mult_by_2b m3622 (.i(rx_data[423:416]),.o(syn_14_tmp[423:416]));
  gf_mult_by_f7 m3623 (.i(rx_data[431:424]),.o(syn_14_tmp[431:424]));
  gf_mult_by_cf m3624 (.i(rx_data[439:432]),.o(syn_14_tmp[439:432]));
  gf_mult_by_20 m3625 (.i(rx_data[447:440]),.o(syn_14_tmp[447:440]));
  gf_mult_by_5a m3626 (.i(rx_data[455:448]),.o(syn_14_tmp[455:448]));
  gf_mult_by_27 m3627 (.i(rx_data[463:456]),.o(syn_14_tmp[463:456]));
  gf_mult_by_23 m3628 (.i(rx_data[471:464]),.o(syn_14_tmp[471:464]));
  gf_mult_by_6f m3629 (.i(rx_data[479:472]),.o(syn_14_tmp[479:472]));
  gf_mult_by_0f m3630 (.i(rx_data[487:480]),.o(syn_14_tmp[487:480]));
  gf_mult_by_e1 m3631 (.i(rx_data[495:488]),.o(syn_14_tmp[495:488]));
  gf_mult_by_88 m3632 (.i(rx_data[503:496]),.o(syn_14_tmp[503:496]));
  gf_mult_by_ed m3633 (.i(rx_data[511:504]),.o(syn_14_tmp[511:504]));
  gf_mult_by_5c m3634 (.i(rx_data[519:512]),.o(syn_14_tmp[519:512]));
  gf_mult_by_4d m3635 (.i(rx_data[527:520]),.o(syn_14_tmp[527:520]));
  gf_mult_by_73 m3636 (.i(rx_data[535:528]),.o(syn_14_tmp[535:528]));
  gf_mult_by_f6 m3637 (.i(rx_data[543:536]),.o(syn_14_tmp[543:536]));
  gf_mult_by_dc m3638 (.i(rx_data[551:544]),.o(syn_14_tmp[551:544]));
  gf_mult_by_38 m3639 (.i(rx_data[559:552]),.o(syn_14_tmp[559:552]));
  gf_mult_by_ef m3640 (.i(rx_data[567:560]),.o(syn_14_tmp[567:560]));
  gf_mult_by_7a m3641 (.i(rx_data[575:568]),.o(syn_14_tmp[575:568]));
  gf_mult_by_7d m3642 (.i(rx_data[583:576]),.o(syn_14_tmp[583:576]));
  gf_mult_by_04 m3643 (.i(rx_data[591:584]),.o(syn_14_tmp[591:584]));
  gf_mult_by_4c m3644 (.i(rx_data[599:592]),.o(syn_14_tmp[599:592]));
  gf_mult_by_60 m3645 (.i(rx_data[607:600]),.o(syn_14_tmp[607:600]));
  gf_mult_by_ee m3646 (.i(rx_data[615:608]),.o(syn_14_tmp[615:608]));
  gf_mult_by_69 m3647 (.i(rx_data[623:616]),.o(syn_14_tmp[623:616]));
  gf_mult_by_65 m3648 (.i(rx_data[631:624]),.o(syn_14_tmp[631:624]));
  gf_mult_by_b1 m3649 (.i(rx_data[639:632]),.o(syn_14_tmp[639:632]));
  gf_mult_by_11 m3650 (.i(rx_data[647:640]),.o(syn_14_tmp[647:640]));
  gf_mult_by_3e m3651 (.i(rx_data[655:648]),.o(syn_14_tmp[655:648]));
  gf_mult_by_85 m3652 (.i(rx_data[663:656]),.o(syn_14_tmp[663:656]));
  gf_mult_by_2a m3653 (.i(rx_data[671:664]),.o(syn_14_tmp[671:664]));
  gf_mult_by_e4 m3654 (.i(rx_data[679:672]),.o(syn_14_tmp[679:672]));
  gf_mult_by_d7 m3655 (.i(rx_data[687:680]),.o(syn_14_tmp[687:680]));
  gf_mult_by_95 m3656 (.i(rx_data[695:688]),.o(syn_14_tmp[695:688]));
  gf_mult_by_07 m3657 (.i(rx_data[703:696]),.o(syn_14_tmp[703:696]));
  gf_mult_by_79 m3658 (.i(rx_data[711:704]),.o(syn_14_tmp[711:704]));
  gf_mult_by_48 m3659 (.i(rx_data[719:712]),.o(syn_14_tmp[719:712]));
  gf_mult_by_2c m3660 (.i(rx_data[727:720]),.o(syn_14_tmp[727:720]));
  gf_mult_by_8e m3661 (.i(rx_data[735:728]),.o(syn_14_tmp[735:728]));
  gf_mult_by_87 m3662 (.i(rx_data[743:736]),.o(syn_14_tmp[743:736]));
  gf_mult_by_0c m3663 (.i(rx_data[751:744]),.o(syn_14_tmp[751:744]));
  gf_mult_by_d4 m3664 (.i(rx_data[759:752]),.o(syn_14_tmp[759:752]));
  gf_mult_by_a0 m3665 (.i(rx_data[767:760]),.o(syn_14_tmp[767:760]));
  gf_mult_by_2f m3666 (.i(rx_data[775:768]),.o(syn_14_tmp[775:768]));
  gf_mult_by_bb m3667 (.i(rx_data[783:776]),.o(syn_14_tmp[783:776]));
  gf_mult_by_af m3668 (.i(rx_data[791:784]),.o(syn_14_tmp[791:784]));
  gf_mult_by_ce m3669 (.i(rx_data[799:792]),.o(syn_14_tmp[799:792]));
  gf_mult_by_33 m3670 (.i(rx_data[807:800]),.o(syn_14_tmp[807:800]));
  gf_mult_by_42 m3671 (.i(rx_data[815:808]),.o(syn_14_tmp[815:808]));
  gf_mult_by_92 m3672 (.i(rx_data[823:816]),.o(syn_14_tmp[823:816]));
  gf_mult_by_7e m3673 (.i(rx_data[831:824]),.o(syn_14_tmp[831:824]));
  gf_mult_by_31 m3674 (.i(rx_data[839:832]),.o(syn_14_tmp[839:832]));
  gf_mult_by_64 m3675 (.i(rx_data[847:840]),.o(syn_14_tmp[847:840]));
  gf_mult_by_a2 m3676 (.i(rx_data[855:848]),.o(syn_14_tmp[855:848]));
  gf_mult_by_09 m3677 (.i(rx_data[863:856]),.o(syn_14_tmp[863:856]));
  gf_mult_by_8b m3678 (.i(rx_data[871:864]),.o(syn_14_tmp[871:864]));
  gf_mult_by_d8 m3679 (.i(rx_data[879:872]),.o(syn_14_tmp[879:872]));
  gf_mult_by_74 m3680 (.i(rx_data[887:880]),.o(syn_14_tmp[887:880]));
  gf_mult_by_8f m3681 (.i(rx_data[895:888]),.o(syn_14_tmp[895:888]));
  gf_mult_by_94 m3682 (.i(rx_data[903:896]),.o(syn_14_tmp[903:896]));
  gf_mult_by_14 m3683 (.i(rx_data[911:904]),.o(syn_14_tmp[911:904]));
  gf_mult_by_61 m3684 (.i(rx_data[919:912]),.o(syn_14_tmp[919:912]));
  gf_mult_by_fd m3685 (.i(rx_data[927:920]),.o(syn_14_tmp[927:920]));
  gf_mult_by_71 m3686 (.i(rx_data[935:928]),.o(syn_14_tmp[935:928]));
  gf_mult_by_d0 m3687 (.i(rx_data[943:936]),.o(syn_14_tmp[943:936]));
  gf_mult_by_ec m3688 (.i(rx_data[951:944]),.o(syn_14_tmp[951:944]));
  gf_mult_by_4f m3689 (.i(rx_data[959:952]),.o(syn_14_tmp[959:952]));
  gf_mult_by_55 m3690 (.i(rx_data[967:960]),.o(syn_14_tmp[967:960]));
  gf_mult_by_c6 m3691 (.i(rx_data[975:968]),.o(syn_14_tmp[975:968]));
  gf_mult_by_ab m3692 (.i(rx_data[983:976]),.o(syn_14_tmp[983:976]));
  gf_mult_by_82 m3693 (.i(rx_data[991:984]),.o(syn_14_tmp[991:984]));
  gf_mult_by_53 m3694 (.i(rx_data[999:992]),.o(syn_14_tmp[999:992]));
  gf_mult_by_ac m3695 (.i(rx_data[1007:1000]),.o(syn_14_tmp[1007:1000]));
  gf_mult_by_fb m3696 (.i(rx_data[1015:1008]),.o(syn_14_tmp[1015:1008]));
  gf_mult_by_1b m3697 (.i(rx_data[1023:1016]),.o(syn_14_tmp[1023:1016]));
  gf_mult_by_80 m3698 (.i(rx_data[1031:1024]),.o(syn_14_tmp[1031:1024]));
  gf_mult_by_75 m3699 (.i(rx_data[1039:1032]),.o(syn_14_tmp[1039:1032]));
  gf_mult_by_9c m3700 (.i(rx_data[1047:1040]),.o(syn_14_tmp[1047:1040]));
  gf_mult_by_8c m3701 (.i(rx_data[1055:1048]),.o(syn_14_tmp[1055:1048]));
  gf_mult_by_a1 m3702 (.i(rx_data[1063:1056]),.o(syn_14_tmp[1063:1056]));
  gf_mult_by_3c m3703 (.i(rx_data[1071:1064]),.o(syn_14_tmp[1071:1064]));
  gf_mult_by_a3 m3704 (.i(rx_data[1079:1072]),.o(syn_14_tmp[1079:1072]));
  gf_mult_by_1a m3705 (.i(rx_data[1087:1080]),.o(syn_14_tmp[1087:1080]));
  gf_mult_by_93 m3706 (.i(rx_data[1095:1088]),.o(syn_14_tmp[1095:1088]));
  gf_mult_by_6d m3707 (.i(rx_data[1103:1096]),.o(syn_14_tmp[1103:1096]));
  gf_mult_by_29 m3708 (.i(rx_data[1111:1104]),.o(syn_14_tmp[1111:1104]));
  gf_mult_by_d1 m3709 (.i(rx_data[1119:1112]),.o(syn_14_tmp[1119:1112]));
  gf_mult_by_ff m3710 (.i(rx_data[1127:1120]),.o(syn_14_tmp[1127:1120]));
  gf_mult_by_57 m3711 (.i(rx_data[1135:1128]),.o(syn_14_tmp[1135:1128]));
  gf_mult_by_e0 m3712 (.i(rx_data[1143:1136]),.o(syn_14_tmp[1143:1136]));
  gf_mult_by_9b m3713 (.i(rx_data[1151:1144]),.o(syn_14_tmp[1151:1144]));
  gf_mult_by_f5 m3714 (.i(rx_data[1159:1152]),.o(syn_14_tmp[1159:1152]));
  gf_mult_by_e9 m3715 (.i(rx_data[1167:1160]),.o(syn_14_tmp[1167:1160]));
  gf_mult_by_10 m3716 (.i(rx_data[1175:1168]),.o(syn_14_tmp[1175:1168]));
  gf_mult_by_2d m3717 (.i(rx_data[1183:1176]),.o(syn_14_tmp[1183:1176]));
  gf_mult_by_9d m3718 (.i(rx_data[1191:1184]),.o(syn_14_tmp[1191:1184]));
  gf_mult_by_9f m3719 (.i(rx_data[1199:1192]),.o(syn_14_tmp[1199:1192]));
  gf_mult_by_b9 m3720 (.i(rx_data[1207:1200]),.o(syn_14_tmp[1207:1200]));
  gf_mult_by_89 m3721 (.i(rx_data[1215:1208]),.o(syn_14_tmp[1215:1208]));
  gf_mult_by_fe m3722 (.i(rx_data[1223:1216]),.o(syn_14_tmp[1223:1216]));
  gf_mult_by_44 m3723 (.i(rx_data[1231:1224]),.o(syn_14_tmp[1231:1224]));
  gf_mult_by_f8 m3724 (.i(rx_data[1239:1232]),.o(syn_14_tmp[1239:1232]));
  gf_mult_by_2e m3725 (.i(rx_data[1247:1240]),.o(syn_14_tmp[1247:1240]));
  gf_mult_by_a8 m3726 (.i(rx_data[1255:1248]),.o(syn_14_tmp[1255:1248]));
  gf_mult_by_b7 m3727 (.i(rx_data[1263:1256]),.o(syn_14_tmp[1263:1256]));
  gf_mult_by_7b m3728 (.i(rx_data[1271:1264]),.o(syn_14_tmp[1271:1264]));
  gf_mult_by_6e m3729 (.i(rx_data[1279:1272]),.o(syn_14_tmp[1279:1272]));
  gf_mult_by_1c m3730 (.i(rx_data[1287:1280]),.o(syn_14_tmp[1287:1280]));
  gf_mult_by_f9 m3731 (.i(rx_data[1295:1288]),.o(syn_14_tmp[1295:1288]));
  gf_mult_by_3d m3732 (.i(rx_data[1303:1296]),.o(syn_14_tmp[1303:1296]));
  gf_mult_by_b0 m3733 (.i(rx_data[1311:1304]),.o(syn_14_tmp[1311:1304]));
  gf_mult_by_02 m3734 (.i(rx_data[1319:1312]),.o(syn_14_tmp[1319:1312]));
  gf_mult_by_26 m3735 (.i(rx_data[1327:1320]),.o(syn_14_tmp[1327:1320]));
  gf_mult_by_30 m3736 (.i(rx_data[1335:1328]),.o(syn_14_tmp[1335:1328]));
  gf_mult_by_77 m3737 (.i(rx_data[1343:1336]),.o(syn_14_tmp[1343:1336]));
  gf_mult_by_ba m3738 (.i(rx_data[1351:1344]),.o(syn_14_tmp[1351:1344]));
  gf_mult_by_bc m3739 (.i(rx_data[1359:1352]),.o(syn_14_tmp[1359:1352]));
  gf_mult_by_d6 m3740 (.i(rx_data[1367:1360]),.o(syn_14_tmp[1367:1360]));
  gf_mult_by_86 m3741 (.i(rx_data[1375:1368]),.o(syn_14_tmp[1375:1368]));
  gf_mult_by_1f m3742 (.i(rx_data[1383:1376]),.o(syn_14_tmp[1383:1376]));
  gf_mult_by_cc m3743 (.i(rx_data[1391:1384]),.o(syn_14_tmp[1391:1384]));
  gf_mult_by_15 m3744 (.i(rx_data[1399:1392]),.o(syn_14_tmp[1399:1392]));
  gf_mult_by_72 m3745 (.i(rx_data[1407:1400]),.o(syn_14_tmp[1407:1400]));
  gf_mult_by_e5 m3746 (.i(rx_data[1415:1408]),.o(syn_14_tmp[1415:1408]));
  gf_mult_by_c4 m3747 (.i(rx_data[1423:1416]),.o(syn_14_tmp[1423:1416]));
  gf_mult_by_8d m3748 (.i(rx_data[1431:1424]),.o(syn_14_tmp[1431:1424]));
  gf_mult_by_b2 m3749 (.i(rx_data[1439:1432]),.o(syn_14_tmp[1439:1432]));
  gf_mult_by_24 m3750 (.i(rx_data[1447:1440]),.o(syn_14_tmp[1447:1440]));
  gf_mult_by_16 m3751 (.i(rx_data[1455:1448]),.o(syn_14_tmp[1455:1448]));
  gf_mult_by_47 m3752 (.i(rx_data[1463:1456]),.o(syn_14_tmp[1463:1456]));
  gf_mult_by_cd m3753 (.i(rx_data[1471:1464]),.o(syn_14_tmp[1471:1464]));
  gf_mult_by_06 m3754 (.i(rx_data[1479:1472]),.o(syn_14_tmp[1479:1472]));
  gf_mult_by_6a m3755 (.i(rx_data[1487:1480]),.o(syn_14_tmp[1487:1480]));
  gf_mult_by_50 m3756 (.i(rx_data[1495:1488]),.o(syn_14_tmp[1495:1488]));
  gf_mult_by_99 m3757 (.i(rx_data[1503:1496]),.o(syn_14_tmp[1503:1496]));
  gf_mult_by_d3 m3758 (.i(rx_data[1511:1504]),.o(syn_14_tmp[1511:1504]));
  gf_mult_by_d9 m3759 (.i(rx_data[1519:1512]),.o(syn_14_tmp[1519:1512]));
  gf_mult_by_67 m3760 (.i(rx_data[1527:1520]),.o(syn_14_tmp[1527:1520]));
  gf_mult_by_97 m3761 (.i(rx_data[1535:1528]),.o(syn_14_tmp[1535:1528]));
  gf_mult_by_21 m3762 (.i(rx_data[1543:1536]),.o(syn_14_tmp[1543:1536]));
  gf_mult_by_49 m3763 (.i(rx_data[1551:1544]),.o(syn_14_tmp[1551:1544]));
  gf_mult_by_3f m3764 (.i(rx_data[1559:1552]),.o(syn_14_tmp[1559:1552]));
  gf_mult_by_96 m3765 (.i(rx_data[1567:1560]),.o(syn_14_tmp[1567:1560]));
  gf_mult_by_32 m3766 (.i(rx_data[1575:1568]),.o(syn_14_tmp[1575:1568]));
  gf_mult_by_51 m3767 (.i(rx_data[1583:1576]),.o(syn_14_tmp[1583:1576]));
  gf_mult_by_8a m3768 (.i(rx_data[1591:1584]),.o(syn_14_tmp[1591:1584]));
  gf_mult_by_cb m3769 (.i(rx_data[1599:1592]),.o(syn_14_tmp[1599:1592]));
  gf_mult_by_6c m3770 (.i(rx_data[1607:1600]),.o(syn_14_tmp[1607:1600]));
  gf_mult_by_3a m3771 (.i(rx_data[1615:1608]),.o(syn_14_tmp[1615:1608]));
  gf_mult_by_c9 m3772 (.i(rx_data[1623:1616]),.o(syn_14_tmp[1623:1616]));
  gf_mult_by_4a m3773 (.i(rx_data[1631:1624]),.o(syn_14_tmp[1631:1624]));
  gf_mult_by_0a m3774 (.i(rx_data[1639:1632]),.o(syn_14_tmp[1639:1632]));
  gf_mult_by_be m3775 (.i(rx_data[1647:1640]),.o(syn_14_tmp[1647:1640]));
  gf_mult_by_f0 m3776 (.i(rx_data[1655:1648]),.o(syn_14_tmp[1655:1648]));
  gf_mult_by_b6 m3777 (.i(rx_data[1663:1656]),.o(syn_14_tmp[1663:1656]));
  gf_mult_by_68 m3778 (.i(rx_data[1671:1664]),.o(syn_14_tmp[1671:1664]));
  gf_mult_by_76 m3779 (.i(rx_data[1679:1672]),.o(syn_14_tmp[1679:1672]));
  gf_mult_by_a9 m3780 (.i(rx_data[1687:1680]),.o(syn_14_tmp[1687:1680]));
  gf_mult_by_a4 m3781 (.i(rx_data[1695:1688]),.o(syn_14_tmp[1695:1688]));
  gf_mult_by_63 m3782 (.i(rx_data[1703:1696]),.o(syn_14_tmp[1703:1696]));
  gf_mult_by_db m3783 (.i(rx_data[1711:1704]),.o(syn_14_tmp[1711:1704]));
  gf_mult_by_41 m3784 (.i(rx_data[1719:1712]),.o(syn_14_tmp[1719:1712]));
  gf_mult_by_a7 m3785 (.i(rx_data[1727:1720]),.o(syn_14_tmp[1727:1720]));
  gf_mult_by_56 m3786 (.i(rx_data[1735:1728]),.o(syn_14_tmp[1735:1728]));
  gf_mult_by_f3 m3787 (.i(rx_data[1743:1736]),.o(syn_14_tmp[1743:1736]));
  gf_mult_by_83 m3788 (.i(rx_data[1751:1744]),.o(syn_14_tmp[1751:1744]));
  gf_mult_by_40 m3789 (.i(rx_data[1759:1752]),.o(syn_14_tmp[1759:1752]));
  gf_mult_by_b4 m3790 (.i(rx_data[1767:1760]),.o(syn_14_tmp[1767:1760]));
  gf_mult_by_4e m3791 (.i(rx_data[1775:1768]),.o(syn_14_tmp[1775:1768]));
  gf_mult_by_46 m3792 (.i(rx_data[1783:1776]),.o(syn_14_tmp[1783:1776]));
  gf_mult_by_de m3793 (.i(rx_data[1791:1784]),.o(syn_14_tmp[1791:1784]));
  gf_mult_by_1e m3794 (.i(rx_data[1799:1792]),.o(syn_14_tmp[1799:1792]));
  gf_mult_by_df m3795 (.i(rx_data[1807:1800]),.o(syn_14_tmp[1807:1800]));
  gf_mult_by_0d m3796 (.i(rx_data[1815:1808]),.o(syn_14_tmp[1815:1808]));
  gf_mult_by_c7 m3797 (.i(rx_data[1823:1816]),.o(syn_14_tmp[1823:1816]));
  gf_mult_by_b8 m3798 (.i(rx_data[1831:1824]),.o(syn_14_tmp[1831:1824]));
  gf_mult_by_9a m3799 (.i(rx_data[1839:1832]),.o(syn_14_tmp[1839:1832]));
  gf_mult_by_e6 m3800 (.i(rx_data[1847:1840]),.o(syn_14_tmp[1847:1840]));
  gf_mult_by_f1 m3801 (.i(rx_data[1855:1848]),.o(syn_14_tmp[1855:1848]));
  gf_mult_by_a5 m3802 (.i(rx_data[1863:1856]),.o(syn_14_tmp[1863:1856]));
  gf_mult_by_70 m3803 (.i(rx_data[1871:1864]),.o(syn_14_tmp[1871:1864]));
  gf_mult_by_c3 m3804 (.i(rx_data[1879:1872]),.o(syn_14_tmp[1879:1872]));
  gf_mult_by_f4 m3805 (.i(rx_data[1887:1880]),.o(syn_14_tmp[1887:1880]));
  gf_mult_by_fa m3806 (.i(rx_data[1895:1888]),.o(syn_14_tmp[1895:1888]));
  gf_mult_by_08 m3807 (.i(rx_data[1903:1896]),.o(syn_14_tmp[1903:1896]));
  gf_mult_by_98 m3808 (.i(rx_data[1911:1904]),.o(syn_14_tmp[1911:1904]));
  gf_mult_by_c0 m3809 (.i(rx_data[1919:1912]),.o(syn_14_tmp[1919:1912]));
  gf_mult_by_c1 m3810 (.i(rx_data[1927:1920]),.o(syn_14_tmp[1927:1920]));
  gf_mult_by_d2 m3811 (.i(rx_data[1935:1928]),.o(syn_14_tmp[1935:1928]));
  gf_mult_by_ca m3812 (.i(rx_data[1943:1936]),.o(syn_14_tmp[1943:1936]));
  gf_mult_by_7f m3813 (.i(rx_data[1951:1944]),.o(syn_14_tmp[1951:1944]));
  gf_mult_by_22 m3814 (.i(rx_data[1959:1952]),.o(syn_14_tmp[1959:1952]));
  gf_mult_by_7c m3815 (.i(rx_data[1967:1960]),.o(syn_14_tmp[1967:1960]));
  gf_mult_by_17 m3816 (.i(rx_data[1975:1968]),.o(syn_14_tmp[1975:1968]));
  gf_mult_by_54 m3817 (.i(rx_data[1983:1976]),.o(syn_14_tmp[1983:1976]));
  gf_mult_by_d5 m3818 (.i(rx_data[1991:1984]),.o(syn_14_tmp[1991:1984]));
  gf_mult_by_b3 m3819 (.i(rx_data[1999:1992]),.o(syn_14_tmp[1999:1992]));
  gf_mult_by_37 m3820 (.i(rx_data[2007:2000]),.o(syn_14_tmp[2007:2000]));
  gf_mult_by_0e m3821 (.i(rx_data[2015:2008]),.o(syn_14_tmp[2015:2008]));
  gf_mult_by_f2 m3822 (.i(rx_data[2023:2016]),.o(syn_14_tmp[2023:2016]));
  gf_mult_by_90 m3823 (.i(rx_data[2031:2024]),.o(syn_14_tmp[2031:2024]));
  gf_mult_by_58 m3824 (.i(rx_data[2039:2032]),.o(syn_14_tmp[2039:2032]));
  assign syndrome[119:112] =
      syn_14_tmp[7:0] ^ syn_14_tmp[15:8] ^ syn_14_tmp[23:16] ^ 
      syn_14_tmp[31:24] ^ syn_14_tmp[39:32] ^ syn_14_tmp[47:40] ^ 
      syn_14_tmp[55:48] ^ syn_14_tmp[63:56] ^ syn_14_tmp[71:64] ^ 
      syn_14_tmp[79:72] ^ syn_14_tmp[87:80] ^ syn_14_tmp[95:88] ^ 
      syn_14_tmp[103:96] ^ syn_14_tmp[111:104] ^ syn_14_tmp[119:112] ^ 
      syn_14_tmp[127:120] ^ syn_14_tmp[135:128] ^ syn_14_tmp[143:136] ^ 
      syn_14_tmp[151:144] ^ syn_14_tmp[159:152] ^ syn_14_tmp[167:160] ^ 
      syn_14_tmp[175:168] ^ syn_14_tmp[183:176] ^ syn_14_tmp[191:184] ^ 
      syn_14_tmp[199:192] ^ syn_14_tmp[207:200] ^ syn_14_tmp[215:208] ^ 
      syn_14_tmp[223:216] ^ syn_14_tmp[231:224] ^ syn_14_tmp[239:232] ^ 
      syn_14_tmp[247:240] ^ syn_14_tmp[255:248] ^ syn_14_tmp[263:256] ^ 
      syn_14_tmp[271:264] ^ syn_14_tmp[279:272] ^ syn_14_tmp[287:280] ^ 
      syn_14_tmp[295:288] ^ syn_14_tmp[303:296] ^ syn_14_tmp[311:304] ^ 
      syn_14_tmp[319:312] ^ syn_14_tmp[327:320] ^ syn_14_tmp[335:328] ^ 
      syn_14_tmp[343:336] ^ syn_14_tmp[351:344] ^ syn_14_tmp[359:352] ^ 
      syn_14_tmp[367:360] ^ syn_14_tmp[375:368] ^ syn_14_tmp[383:376] ^ 
      syn_14_tmp[391:384] ^ syn_14_tmp[399:392] ^ syn_14_tmp[407:400] ^ 
      syn_14_tmp[415:408] ^ syn_14_tmp[423:416] ^ syn_14_tmp[431:424] ^ 
      syn_14_tmp[439:432] ^ syn_14_tmp[447:440] ^ syn_14_tmp[455:448] ^ 
      syn_14_tmp[463:456] ^ syn_14_tmp[471:464] ^ syn_14_tmp[479:472] ^ 
      syn_14_tmp[487:480] ^ syn_14_tmp[495:488] ^ syn_14_tmp[503:496] ^ 
      syn_14_tmp[511:504] ^ syn_14_tmp[519:512] ^ syn_14_tmp[527:520] ^ 
      syn_14_tmp[535:528] ^ syn_14_tmp[543:536] ^ syn_14_tmp[551:544] ^ 
      syn_14_tmp[559:552] ^ syn_14_tmp[567:560] ^ syn_14_tmp[575:568] ^ 
      syn_14_tmp[583:576] ^ syn_14_tmp[591:584] ^ syn_14_tmp[599:592] ^ 
      syn_14_tmp[607:600] ^ syn_14_tmp[615:608] ^ syn_14_tmp[623:616] ^ 
      syn_14_tmp[631:624] ^ syn_14_tmp[639:632] ^ syn_14_tmp[647:640] ^ 
      syn_14_tmp[655:648] ^ syn_14_tmp[663:656] ^ syn_14_tmp[671:664] ^ 
      syn_14_tmp[679:672] ^ syn_14_tmp[687:680] ^ syn_14_tmp[695:688] ^ 
      syn_14_tmp[703:696] ^ syn_14_tmp[711:704] ^ syn_14_tmp[719:712] ^ 
      syn_14_tmp[727:720] ^ syn_14_tmp[735:728] ^ syn_14_tmp[743:736] ^ 
      syn_14_tmp[751:744] ^ syn_14_tmp[759:752] ^ syn_14_tmp[767:760] ^ 
      syn_14_tmp[775:768] ^ syn_14_tmp[783:776] ^ syn_14_tmp[791:784] ^ 
      syn_14_tmp[799:792] ^ syn_14_tmp[807:800] ^ syn_14_tmp[815:808] ^ 
      syn_14_tmp[823:816] ^ syn_14_tmp[831:824] ^ syn_14_tmp[839:832] ^ 
      syn_14_tmp[847:840] ^ syn_14_tmp[855:848] ^ syn_14_tmp[863:856] ^ 
      syn_14_tmp[871:864] ^ syn_14_tmp[879:872] ^ syn_14_tmp[887:880] ^ 
      syn_14_tmp[895:888] ^ syn_14_tmp[903:896] ^ syn_14_tmp[911:904] ^ 
      syn_14_tmp[919:912] ^ syn_14_tmp[927:920] ^ syn_14_tmp[935:928] ^ 
      syn_14_tmp[943:936] ^ syn_14_tmp[951:944] ^ syn_14_tmp[959:952] ^ 
      syn_14_tmp[967:960] ^ syn_14_tmp[975:968] ^ syn_14_tmp[983:976] ^ 
      syn_14_tmp[991:984] ^ syn_14_tmp[999:992] ^ syn_14_tmp[1007:1000] ^ 
      syn_14_tmp[1015:1008] ^ syn_14_tmp[1023:1016] ^ syn_14_tmp[1031:1024] ^ 
      syn_14_tmp[1039:1032] ^ syn_14_tmp[1047:1040] ^ syn_14_tmp[1055:1048] ^ 
      syn_14_tmp[1063:1056] ^ syn_14_tmp[1071:1064] ^ syn_14_tmp[1079:1072] ^ 
      syn_14_tmp[1087:1080] ^ syn_14_tmp[1095:1088] ^ syn_14_tmp[1103:1096] ^ 
      syn_14_tmp[1111:1104] ^ syn_14_tmp[1119:1112] ^ syn_14_tmp[1127:1120] ^ 
      syn_14_tmp[1135:1128] ^ syn_14_tmp[1143:1136] ^ syn_14_tmp[1151:1144] ^ 
      syn_14_tmp[1159:1152] ^ syn_14_tmp[1167:1160] ^ syn_14_tmp[1175:1168] ^ 
      syn_14_tmp[1183:1176] ^ syn_14_tmp[1191:1184] ^ syn_14_tmp[1199:1192] ^ 
      syn_14_tmp[1207:1200] ^ syn_14_tmp[1215:1208] ^ syn_14_tmp[1223:1216] ^ 
      syn_14_tmp[1231:1224] ^ syn_14_tmp[1239:1232] ^ syn_14_tmp[1247:1240] ^ 
      syn_14_tmp[1255:1248] ^ syn_14_tmp[1263:1256] ^ syn_14_tmp[1271:1264] ^ 
      syn_14_tmp[1279:1272] ^ syn_14_tmp[1287:1280] ^ syn_14_tmp[1295:1288] ^ 
      syn_14_tmp[1303:1296] ^ syn_14_tmp[1311:1304] ^ syn_14_tmp[1319:1312] ^ 
      syn_14_tmp[1327:1320] ^ syn_14_tmp[1335:1328] ^ syn_14_tmp[1343:1336] ^ 
      syn_14_tmp[1351:1344] ^ syn_14_tmp[1359:1352] ^ syn_14_tmp[1367:1360] ^ 
      syn_14_tmp[1375:1368] ^ syn_14_tmp[1383:1376] ^ syn_14_tmp[1391:1384] ^ 
      syn_14_tmp[1399:1392] ^ syn_14_tmp[1407:1400] ^ syn_14_tmp[1415:1408] ^ 
      syn_14_tmp[1423:1416] ^ syn_14_tmp[1431:1424] ^ syn_14_tmp[1439:1432] ^ 
      syn_14_tmp[1447:1440] ^ syn_14_tmp[1455:1448] ^ syn_14_tmp[1463:1456] ^ 
      syn_14_tmp[1471:1464] ^ syn_14_tmp[1479:1472] ^ syn_14_tmp[1487:1480] ^ 
      syn_14_tmp[1495:1488] ^ syn_14_tmp[1503:1496] ^ syn_14_tmp[1511:1504] ^ 
      syn_14_tmp[1519:1512] ^ syn_14_tmp[1527:1520] ^ syn_14_tmp[1535:1528] ^ 
      syn_14_tmp[1543:1536] ^ syn_14_tmp[1551:1544] ^ syn_14_tmp[1559:1552] ^ 
      syn_14_tmp[1567:1560] ^ syn_14_tmp[1575:1568] ^ syn_14_tmp[1583:1576] ^ 
      syn_14_tmp[1591:1584] ^ syn_14_tmp[1599:1592] ^ syn_14_tmp[1607:1600] ^ 
      syn_14_tmp[1615:1608] ^ syn_14_tmp[1623:1616] ^ syn_14_tmp[1631:1624] ^ 
      syn_14_tmp[1639:1632] ^ syn_14_tmp[1647:1640] ^ syn_14_tmp[1655:1648] ^ 
      syn_14_tmp[1663:1656] ^ syn_14_tmp[1671:1664] ^ syn_14_tmp[1679:1672] ^ 
      syn_14_tmp[1687:1680] ^ syn_14_tmp[1695:1688] ^ syn_14_tmp[1703:1696] ^ 
      syn_14_tmp[1711:1704] ^ syn_14_tmp[1719:1712] ^ syn_14_tmp[1727:1720] ^ 
      syn_14_tmp[1735:1728] ^ syn_14_tmp[1743:1736] ^ syn_14_tmp[1751:1744] ^ 
      syn_14_tmp[1759:1752] ^ syn_14_tmp[1767:1760] ^ syn_14_tmp[1775:1768] ^ 
      syn_14_tmp[1783:1776] ^ syn_14_tmp[1791:1784] ^ syn_14_tmp[1799:1792] ^ 
      syn_14_tmp[1807:1800] ^ syn_14_tmp[1815:1808] ^ syn_14_tmp[1823:1816] ^ 
      syn_14_tmp[1831:1824] ^ syn_14_tmp[1839:1832] ^ syn_14_tmp[1847:1840] ^ 
      syn_14_tmp[1855:1848] ^ syn_14_tmp[1863:1856] ^ syn_14_tmp[1871:1864] ^ 
      syn_14_tmp[1879:1872] ^ syn_14_tmp[1887:1880] ^ syn_14_tmp[1895:1888] ^ 
      syn_14_tmp[1903:1896] ^ syn_14_tmp[1911:1904] ^ syn_14_tmp[1919:1912] ^ 
      syn_14_tmp[1927:1920] ^ syn_14_tmp[1935:1928] ^ syn_14_tmp[1943:1936] ^ 
      syn_14_tmp[1951:1944] ^ syn_14_tmp[1959:1952] ^ syn_14_tmp[1967:1960] ^ 
      syn_14_tmp[1975:1968] ^ syn_14_tmp[1983:1976] ^ syn_14_tmp[1991:1984] ^ 
      syn_14_tmp[1999:1992] ^ syn_14_tmp[2007:2000] ^ syn_14_tmp[2015:2008] ^ 
      syn_14_tmp[2023:2016] ^ syn_14_tmp[2031:2024] ^ syn_14_tmp[2039:2032];

// syndrome 15
  wire [2039:0] syn_15_tmp;
  gf_mult_by_01 m3825 (.i(rx_data[7:0]),.o(syn_15_tmp[7:0]));
  gf_mult_by_26 m3826 (.i(rx_data[15:8]),.o(syn_15_tmp[15:8]));
  gf_mult_by_60 m3827 (.i(rx_data[23:16]),.o(syn_15_tmp[23:16]));
  gf_mult_by_c1 m3828 (.i(rx_data[31:24]),.o(syn_15_tmp[31:24]));
  gf_mult_by_b9 m3829 (.i(rx_data[39:32]),.o(syn_15_tmp[39:32]));
  gf_mult_by_0f m3830 (.i(rx_data[47:40]),.o(syn_15_tmp[47:40]));
  gf_mult_by_df m3831 (.i(rx_data[55:48]),.o(syn_15_tmp[55:48]));
  gf_mult_by_1a m3832 (.i(rx_data[63:56]),.o(syn_15_tmp[63:56]));
  gf_mult_by_3b m3833 (.i(rx_data[71:64]),.o(syn_15_tmp[71:64]));
  gf_mult_by_a9 m3834 (.i(rx_data[79:72]),.o(syn_15_tmp[79:72]));
  gf_mult_by_55 m3835 (.i(rx_data[87:80]),.o(syn_15_tmp[87:80]));
  gf_mult_by_91 m3836 (.i(rx_data[95:88]),.o(syn_15_tmp[95:88]));
  gf_mult_by_96 m3837 (.i(rx_data[103:96]),.o(syn_15_tmp[103:96]));
  gf_mult_by_64 m3838 (.i(rx_data[111:104]),.o(syn_15_tmp[111:104]));
  gf_mult_by_59 m3839 (.i(rx_data[119:112]),.o(syn_15_tmp[119:112]));
  gf_mult_by_24 m3840 (.i(rx_data[127:120]),.o(syn_15_tmp[127:120]));
  gf_mult_by_2c m3841 (.i(rx_data[135:128]),.o(syn_15_tmp[135:128]));
  gf_mult_by_01 m3842 (.i(rx_data[143:136]),.o(syn_15_tmp[143:136]));
  gf_mult_by_26 m3843 (.i(rx_data[151:144]),.o(syn_15_tmp[151:144]));
  gf_mult_by_60 m3844 (.i(rx_data[159:152]),.o(syn_15_tmp[159:152]));
  gf_mult_by_c1 m3845 (.i(rx_data[167:160]),.o(syn_15_tmp[167:160]));
  gf_mult_by_b9 m3846 (.i(rx_data[175:168]),.o(syn_15_tmp[175:168]));
  gf_mult_by_0f m3847 (.i(rx_data[183:176]),.o(syn_15_tmp[183:176]));
  gf_mult_by_df m3848 (.i(rx_data[191:184]),.o(syn_15_tmp[191:184]));
  gf_mult_by_1a m3849 (.i(rx_data[199:192]),.o(syn_15_tmp[199:192]));
  gf_mult_by_3b m3850 (.i(rx_data[207:200]),.o(syn_15_tmp[207:200]));
  gf_mult_by_a9 m3851 (.i(rx_data[215:208]),.o(syn_15_tmp[215:208]));
  gf_mult_by_55 m3852 (.i(rx_data[223:216]),.o(syn_15_tmp[223:216]));
  gf_mult_by_91 m3853 (.i(rx_data[231:224]),.o(syn_15_tmp[231:224]));
  gf_mult_by_96 m3854 (.i(rx_data[239:232]),.o(syn_15_tmp[239:232]));
  gf_mult_by_64 m3855 (.i(rx_data[247:240]),.o(syn_15_tmp[247:240]));
  gf_mult_by_59 m3856 (.i(rx_data[255:248]),.o(syn_15_tmp[255:248]));
  gf_mult_by_24 m3857 (.i(rx_data[263:256]),.o(syn_15_tmp[263:256]));
  gf_mult_by_2c m3858 (.i(rx_data[271:264]),.o(syn_15_tmp[271:264]));
  gf_mult_by_01 m3859 (.i(rx_data[279:272]),.o(syn_15_tmp[279:272]));
  gf_mult_by_26 m3860 (.i(rx_data[287:280]),.o(syn_15_tmp[287:280]));
  gf_mult_by_60 m3861 (.i(rx_data[295:288]),.o(syn_15_tmp[295:288]));
  gf_mult_by_c1 m3862 (.i(rx_data[303:296]),.o(syn_15_tmp[303:296]));
  gf_mult_by_b9 m3863 (.i(rx_data[311:304]),.o(syn_15_tmp[311:304]));
  gf_mult_by_0f m3864 (.i(rx_data[319:312]),.o(syn_15_tmp[319:312]));
  gf_mult_by_df m3865 (.i(rx_data[327:320]),.o(syn_15_tmp[327:320]));
  gf_mult_by_1a m3866 (.i(rx_data[335:328]),.o(syn_15_tmp[335:328]));
  gf_mult_by_3b m3867 (.i(rx_data[343:336]),.o(syn_15_tmp[343:336]));
  gf_mult_by_a9 m3868 (.i(rx_data[351:344]),.o(syn_15_tmp[351:344]));
  gf_mult_by_55 m3869 (.i(rx_data[359:352]),.o(syn_15_tmp[359:352]));
  gf_mult_by_91 m3870 (.i(rx_data[367:360]),.o(syn_15_tmp[367:360]));
  gf_mult_by_96 m3871 (.i(rx_data[375:368]),.o(syn_15_tmp[375:368]));
  gf_mult_by_64 m3872 (.i(rx_data[383:376]),.o(syn_15_tmp[383:376]));
  gf_mult_by_59 m3873 (.i(rx_data[391:384]),.o(syn_15_tmp[391:384]));
  gf_mult_by_24 m3874 (.i(rx_data[399:392]),.o(syn_15_tmp[399:392]));
  gf_mult_by_2c m3875 (.i(rx_data[407:400]),.o(syn_15_tmp[407:400]));
  gf_mult_by_01 m3876 (.i(rx_data[415:408]),.o(syn_15_tmp[415:408]));
  gf_mult_by_26 m3877 (.i(rx_data[423:416]),.o(syn_15_tmp[423:416]));
  gf_mult_by_60 m3878 (.i(rx_data[431:424]),.o(syn_15_tmp[431:424]));
  gf_mult_by_c1 m3879 (.i(rx_data[439:432]),.o(syn_15_tmp[439:432]));
  gf_mult_by_b9 m3880 (.i(rx_data[447:440]),.o(syn_15_tmp[447:440]));
  gf_mult_by_0f m3881 (.i(rx_data[455:448]),.o(syn_15_tmp[455:448]));
  gf_mult_by_df m3882 (.i(rx_data[463:456]),.o(syn_15_tmp[463:456]));
  gf_mult_by_1a m3883 (.i(rx_data[471:464]),.o(syn_15_tmp[471:464]));
  gf_mult_by_3b m3884 (.i(rx_data[479:472]),.o(syn_15_tmp[479:472]));
  gf_mult_by_a9 m3885 (.i(rx_data[487:480]),.o(syn_15_tmp[487:480]));
  gf_mult_by_55 m3886 (.i(rx_data[495:488]),.o(syn_15_tmp[495:488]));
  gf_mult_by_91 m3887 (.i(rx_data[503:496]),.o(syn_15_tmp[503:496]));
  gf_mult_by_96 m3888 (.i(rx_data[511:504]),.o(syn_15_tmp[511:504]));
  gf_mult_by_64 m3889 (.i(rx_data[519:512]),.o(syn_15_tmp[519:512]));
  gf_mult_by_59 m3890 (.i(rx_data[527:520]),.o(syn_15_tmp[527:520]));
  gf_mult_by_24 m3891 (.i(rx_data[535:528]),.o(syn_15_tmp[535:528]));
  gf_mult_by_2c m3892 (.i(rx_data[543:536]),.o(syn_15_tmp[543:536]));
  gf_mult_by_01 m3893 (.i(rx_data[551:544]),.o(syn_15_tmp[551:544]));
  gf_mult_by_26 m3894 (.i(rx_data[559:552]),.o(syn_15_tmp[559:552]));
  gf_mult_by_60 m3895 (.i(rx_data[567:560]),.o(syn_15_tmp[567:560]));
  gf_mult_by_c1 m3896 (.i(rx_data[575:568]),.o(syn_15_tmp[575:568]));
  gf_mult_by_b9 m3897 (.i(rx_data[583:576]),.o(syn_15_tmp[583:576]));
  gf_mult_by_0f m3898 (.i(rx_data[591:584]),.o(syn_15_tmp[591:584]));
  gf_mult_by_df m3899 (.i(rx_data[599:592]),.o(syn_15_tmp[599:592]));
  gf_mult_by_1a m3900 (.i(rx_data[607:600]),.o(syn_15_tmp[607:600]));
  gf_mult_by_3b m3901 (.i(rx_data[615:608]),.o(syn_15_tmp[615:608]));
  gf_mult_by_a9 m3902 (.i(rx_data[623:616]),.o(syn_15_tmp[623:616]));
  gf_mult_by_55 m3903 (.i(rx_data[631:624]),.o(syn_15_tmp[631:624]));
  gf_mult_by_91 m3904 (.i(rx_data[639:632]),.o(syn_15_tmp[639:632]));
  gf_mult_by_96 m3905 (.i(rx_data[647:640]),.o(syn_15_tmp[647:640]));
  gf_mult_by_64 m3906 (.i(rx_data[655:648]),.o(syn_15_tmp[655:648]));
  gf_mult_by_59 m3907 (.i(rx_data[663:656]),.o(syn_15_tmp[663:656]));
  gf_mult_by_24 m3908 (.i(rx_data[671:664]),.o(syn_15_tmp[671:664]));
  gf_mult_by_2c m3909 (.i(rx_data[679:672]),.o(syn_15_tmp[679:672]));
  gf_mult_by_01 m3910 (.i(rx_data[687:680]),.o(syn_15_tmp[687:680]));
  gf_mult_by_26 m3911 (.i(rx_data[695:688]),.o(syn_15_tmp[695:688]));
  gf_mult_by_60 m3912 (.i(rx_data[703:696]),.o(syn_15_tmp[703:696]));
  gf_mult_by_c1 m3913 (.i(rx_data[711:704]),.o(syn_15_tmp[711:704]));
  gf_mult_by_b9 m3914 (.i(rx_data[719:712]),.o(syn_15_tmp[719:712]));
  gf_mult_by_0f m3915 (.i(rx_data[727:720]),.o(syn_15_tmp[727:720]));
  gf_mult_by_df m3916 (.i(rx_data[735:728]),.o(syn_15_tmp[735:728]));
  gf_mult_by_1a m3917 (.i(rx_data[743:736]),.o(syn_15_tmp[743:736]));
  gf_mult_by_3b m3918 (.i(rx_data[751:744]),.o(syn_15_tmp[751:744]));
  gf_mult_by_a9 m3919 (.i(rx_data[759:752]),.o(syn_15_tmp[759:752]));
  gf_mult_by_55 m3920 (.i(rx_data[767:760]),.o(syn_15_tmp[767:760]));
  gf_mult_by_91 m3921 (.i(rx_data[775:768]),.o(syn_15_tmp[775:768]));
  gf_mult_by_96 m3922 (.i(rx_data[783:776]),.o(syn_15_tmp[783:776]));
  gf_mult_by_64 m3923 (.i(rx_data[791:784]),.o(syn_15_tmp[791:784]));
  gf_mult_by_59 m3924 (.i(rx_data[799:792]),.o(syn_15_tmp[799:792]));
  gf_mult_by_24 m3925 (.i(rx_data[807:800]),.o(syn_15_tmp[807:800]));
  gf_mult_by_2c m3926 (.i(rx_data[815:808]),.o(syn_15_tmp[815:808]));
  gf_mult_by_01 m3927 (.i(rx_data[823:816]),.o(syn_15_tmp[823:816]));
  gf_mult_by_26 m3928 (.i(rx_data[831:824]),.o(syn_15_tmp[831:824]));
  gf_mult_by_60 m3929 (.i(rx_data[839:832]),.o(syn_15_tmp[839:832]));
  gf_mult_by_c1 m3930 (.i(rx_data[847:840]),.o(syn_15_tmp[847:840]));
  gf_mult_by_b9 m3931 (.i(rx_data[855:848]),.o(syn_15_tmp[855:848]));
  gf_mult_by_0f m3932 (.i(rx_data[863:856]),.o(syn_15_tmp[863:856]));
  gf_mult_by_df m3933 (.i(rx_data[871:864]),.o(syn_15_tmp[871:864]));
  gf_mult_by_1a m3934 (.i(rx_data[879:872]),.o(syn_15_tmp[879:872]));
  gf_mult_by_3b m3935 (.i(rx_data[887:880]),.o(syn_15_tmp[887:880]));
  gf_mult_by_a9 m3936 (.i(rx_data[895:888]),.o(syn_15_tmp[895:888]));
  gf_mult_by_55 m3937 (.i(rx_data[903:896]),.o(syn_15_tmp[903:896]));
  gf_mult_by_91 m3938 (.i(rx_data[911:904]),.o(syn_15_tmp[911:904]));
  gf_mult_by_96 m3939 (.i(rx_data[919:912]),.o(syn_15_tmp[919:912]));
  gf_mult_by_64 m3940 (.i(rx_data[927:920]),.o(syn_15_tmp[927:920]));
  gf_mult_by_59 m3941 (.i(rx_data[935:928]),.o(syn_15_tmp[935:928]));
  gf_mult_by_24 m3942 (.i(rx_data[943:936]),.o(syn_15_tmp[943:936]));
  gf_mult_by_2c m3943 (.i(rx_data[951:944]),.o(syn_15_tmp[951:944]));
  gf_mult_by_01 m3944 (.i(rx_data[959:952]),.o(syn_15_tmp[959:952]));
  gf_mult_by_26 m3945 (.i(rx_data[967:960]),.o(syn_15_tmp[967:960]));
  gf_mult_by_60 m3946 (.i(rx_data[975:968]),.o(syn_15_tmp[975:968]));
  gf_mult_by_c1 m3947 (.i(rx_data[983:976]),.o(syn_15_tmp[983:976]));
  gf_mult_by_b9 m3948 (.i(rx_data[991:984]),.o(syn_15_tmp[991:984]));
  gf_mult_by_0f m3949 (.i(rx_data[999:992]),.o(syn_15_tmp[999:992]));
  gf_mult_by_df m3950 (.i(rx_data[1007:1000]),.o(syn_15_tmp[1007:1000]));
  gf_mult_by_1a m3951 (.i(rx_data[1015:1008]),.o(syn_15_tmp[1015:1008]));
  gf_mult_by_3b m3952 (.i(rx_data[1023:1016]),.o(syn_15_tmp[1023:1016]));
  gf_mult_by_a9 m3953 (.i(rx_data[1031:1024]),.o(syn_15_tmp[1031:1024]));
  gf_mult_by_55 m3954 (.i(rx_data[1039:1032]),.o(syn_15_tmp[1039:1032]));
  gf_mult_by_91 m3955 (.i(rx_data[1047:1040]),.o(syn_15_tmp[1047:1040]));
  gf_mult_by_96 m3956 (.i(rx_data[1055:1048]),.o(syn_15_tmp[1055:1048]));
  gf_mult_by_64 m3957 (.i(rx_data[1063:1056]),.o(syn_15_tmp[1063:1056]));
  gf_mult_by_59 m3958 (.i(rx_data[1071:1064]),.o(syn_15_tmp[1071:1064]));
  gf_mult_by_24 m3959 (.i(rx_data[1079:1072]),.o(syn_15_tmp[1079:1072]));
  gf_mult_by_2c m3960 (.i(rx_data[1087:1080]),.o(syn_15_tmp[1087:1080]));
  gf_mult_by_01 m3961 (.i(rx_data[1095:1088]),.o(syn_15_tmp[1095:1088]));
  gf_mult_by_26 m3962 (.i(rx_data[1103:1096]),.o(syn_15_tmp[1103:1096]));
  gf_mult_by_60 m3963 (.i(rx_data[1111:1104]),.o(syn_15_tmp[1111:1104]));
  gf_mult_by_c1 m3964 (.i(rx_data[1119:1112]),.o(syn_15_tmp[1119:1112]));
  gf_mult_by_b9 m3965 (.i(rx_data[1127:1120]),.o(syn_15_tmp[1127:1120]));
  gf_mult_by_0f m3966 (.i(rx_data[1135:1128]),.o(syn_15_tmp[1135:1128]));
  gf_mult_by_df m3967 (.i(rx_data[1143:1136]),.o(syn_15_tmp[1143:1136]));
  gf_mult_by_1a m3968 (.i(rx_data[1151:1144]),.o(syn_15_tmp[1151:1144]));
  gf_mult_by_3b m3969 (.i(rx_data[1159:1152]),.o(syn_15_tmp[1159:1152]));
  gf_mult_by_a9 m3970 (.i(rx_data[1167:1160]),.o(syn_15_tmp[1167:1160]));
  gf_mult_by_55 m3971 (.i(rx_data[1175:1168]),.o(syn_15_tmp[1175:1168]));
  gf_mult_by_91 m3972 (.i(rx_data[1183:1176]),.o(syn_15_tmp[1183:1176]));
  gf_mult_by_96 m3973 (.i(rx_data[1191:1184]),.o(syn_15_tmp[1191:1184]));
  gf_mult_by_64 m3974 (.i(rx_data[1199:1192]),.o(syn_15_tmp[1199:1192]));
  gf_mult_by_59 m3975 (.i(rx_data[1207:1200]),.o(syn_15_tmp[1207:1200]));
  gf_mult_by_24 m3976 (.i(rx_data[1215:1208]),.o(syn_15_tmp[1215:1208]));
  gf_mult_by_2c m3977 (.i(rx_data[1223:1216]),.o(syn_15_tmp[1223:1216]));
  gf_mult_by_01 m3978 (.i(rx_data[1231:1224]),.o(syn_15_tmp[1231:1224]));
  gf_mult_by_26 m3979 (.i(rx_data[1239:1232]),.o(syn_15_tmp[1239:1232]));
  gf_mult_by_60 m3980 (.i(rx_data[1247:1240]),.o(syn_15_tmp[1247:1240]));
  gf_mult_by_c1 m3981 (.i(rx_data[1255:1248]),.o(syn_15_tmp[1255:1248]));
  gf_mult_by_b9 m3982 (.i(rx_data[1263:1256]),.o(syn_15_tmp[1263:1256]));
  gf_mult_by_0f m3983 (.i(rx_data[1271:1264]),.o(syn_15_tmp[1271:1264]));
  gf_mult_by_df m3984 (.i(rx_data[1279:1272]),.o(syn_15_tmp[1279:1272]));
  gf_mult_by_1a m3985 (.i(rx_data[1287:1280]),.o(syn_15_tmp[1287:1280]));
  gf_mult_by_3b m3986 (.i(rx_data[1295:1288]),.o(syn_15_tmp[1295:1288]));
  gf_mult_by_a9 m3987 (.i(rx_data[1303:1296]),.o(syn_15_tmp[1303:1296]));
  gf_mult_by_55 m3988 (.i(rx_data[1311:1304]),.o(syn_15_tmp[1311:1304]));
  gf_mult_by_91 m3989 (.i(rx_data[1319:1312]),.o(syn_15_tmp[1319:1312]));
  gf_mult_by_96 m3990 (.i(rx_data[1327:1320]),.o(syn_15_tmp[1327:1320]));
  gf_mult_by_64 m3991 (.i(rx_data[1335:1328]),.o(syn_15_tmp[1335:1328]));
  gf_mult_by_59 m3992 (.i(rx_data[1343:1336]),.o(syn_15_tmp[1343:1336]));
  gf_mult_by_24 m3993 (.i(rx_data[1351:1344]),.o(syn_15_tmp[1351:1344]));
  gf_mult_by_2c m3994 (.i(rx_data[1359:1352]),.o(syn_15_tmp[1359:1352]));
  gf_mult_by_01 m3995 (.i(rx_data[1367:1360]),.o(syn_15_tmp[1367:1360]));
  gf_mult_by_26 m3996 (.i(rx_data[1375:1368]),.o(syn_15_tmp[1375:1368]));
  gf_mult_by_60 m3997 (.i(rx_data[1383:1376]),.o(syn_15_tmp[1383:1376]));
  gf_mult_by_c1 m3998 (.i(rx_data[1391:1384]),.o(syn_15_tmp[1391:1384]));
  gf_mult_by_b9 m3999 (.i(rx_data[1399:1392]),.o(syn_15_tmp[1399:1392]));
  gf_mult_by_0f m4000 (.i(rx_data[1407:1400]),.o(syn_15_tmp[1407:1400]));
  gf_mult_by_df m4001 (.i(rx_data[1415:1408]),.o(syn_15_tmp[1415:1408]));
  gf_mult_by_1a m4002 (.i(rx_data[1423:1416]),.o(syn_15_tmp[1423:1416]));
  gf_mult_by_3b m4003 (.i(rx_data[1431:1424]),.o(syn_15_tmp[1431:1424]));
  gf_mult_by_a9 m4004 (.i(rx_data[1439:1432]),.o(syn_15_tmp[1439:1432]));
  gf_mult_by_55 m4005 (.i(rx_data[1447:1440]),.o(syn_15_tmp[1447:1440]));
  gf_mult_by_91 m4006 (.i(rx_data[1455:1448]),.o(syn_15_tmp[1455:1448]));
  gf_mult_by_96 m4007 (.i(rx_data[1463:1456]),.o(syn_15_tmp[1463:1456]));
  gf_mult_by_64 m4008 (.i(rx_data[1471:1464]),.o(syn_15_tmp[1471:1464]));
  gf_mult_by_59 m4009 (.i(rx_data[1479:1472]),.o(syn_15_tmp[1479:1472]));
  gf_mult_by_24 m4010 (.i(rx_data[1487:1480]),.o(syn_15_tmp[1487:1480]));
  gf_mult_by_2c m4011 (.i(rx_data[1495:1488]),.o(syn_15_tmp[1495:1488]));
  gf_mult_by_01 m4012 (.i(rx_data[1503:1496]),.o(syn_15_tmp[1503:1496]));
  gf_mult_by_26 m4013 (.i(rx_data[1511:1504]),.o(syn_15_tmp[1511:1504]));
  gf_mult_by_60 m4014 (.i(rx_data[1519:1512]),.o(syn_15_tmp[1519:1512]));
  gf_mult_by_c1 m4015 (.i(rx_data[1527:1520]),.o(syn_15_tmp[1527:1520]));
  gf_mult_by_b9 m4016 (.i(rx_data[1535:1528]),.o(syn_15_tmp[1535:1528]));
  gf_mult_by_0f m4017 (.i(rx_data[1543:1536]),.o(syn_15_tmp[1543:1536]));
  gf_mult_by_df m4018 (.i(rx_data[1551:1544]),.o(syn_15_tmp[1551:1544]));
  gf_mult_by_1a m4019 (.i(rx_data[1559:1552]),.o(syn_15_tmp[1559:1552]));
  gf_mult_by_3b m4020 (.i(rx_data[1567:1560]),.o(syn_15_tmp[1567:1560]));
  gf_mult_by_a9 m4021 (.i(rx_data[1575:1568]),.o(syn_15_tmp[1575:1568]));
  gf_mult_by_55 m4022 (.i(rx_data[1583:1576]),.o(syn_15_tmp[1583:1576]));
  gf_mult_by_91 m4023 (.i(rx_data[1591:1584]),.o(syn_15_tmp[1591:1584]));
  gf_mult_by_96 m4024 (.i(rx_data[1599:1592]),.o(syn_15_tmp[1599:1592]));
  gf_mult_by_64 m4025 (.i(rx_data[1607:1600]),.o(syn_15_tmp[1607:1600]));
  gf_mult_by_59 m4026 (.i(rx_data[1615:1608]),.o(syn_15_tmp[1615:1608]));
  gf_mult_by_24 m4027 (.i(rx_data[1623:1616]),.o(syn_15_tmp[1623:1616]));
  gf_mult_by_2c m4028 (.i(rx_data[1631:1624]),.o(syn_15_tmp[1631:1624]));
  gf_mult_by_01 m4029 (.i(rx_data[1639:1632]),.o(syn_15_tmp[1639:1632]));
  gf_mult_by_26 m4030 (.i(rx_data[1647:1640]),.o(syn_15_tmp[1647:1640]));
  gf_mult_by_60 m4031 (.i(rx_data[1655:1648]),.o(syn_15_tmp[1655:1648]));
  gf_mult_by_c1 m4032 (.i(rx_data[1663:1656]),.o(syn_15_tmp[1663:1656]));
  gf_mult_by_b9 m4033 (.i(rx_data[1671:1664]),.o(syn_15_tmp[1671:1664]));
  gf_mult_by_0f m4034 (.i(rx_data[1679:1672]),.o(syn_15_tmp[1679:1672]));
  gf_mult_by_df m4035 (.i(rx_data[1687:1680]),.o(syn_15_tmp[1687:1680]));
  gf_mult_by_1a m4036 (.i(rx_data[1695:1688]),.o(syn_15_tmp[1695:1688]));
  gf_mult_by_3b m4037 (.i(rx_data[1703:1696]),.o(syn_15_tmp[1703:1696]));
  gf_mult_by_a9 m4038 (.i(rx_data[1711:1704]),.o(syn_15_tmp[1711:1704]));
  gf_mult_by_55 m4039 (.i(rx_data[1719:1712]),.o(syn_15_tmp[1719:1712]));
  gf_mult_by_91 m4040 (.i(rx_data[1727:1720]),.o(syn_15_tmp[1727:1720]));
  gf_mult_by_96 m4041 (.i(rx_data[1735:1728]),.o(syn_15_tmp[1735:1728]));
  gf_mult_by_64 m4042 (.i(rx_data[1743:1736]),.o(syn_15_tmp[1743:1736]));
  gf_mult_by_59 m4043 (.i(rx_data[1751:1744]),.o(syn_15_tmp[1751:1744]));
  gf_mult_by_24 m4044 (.i(rx_data[1759:1752]),.o(syn_15_tmp[1759:1752]));
  gf_mult_by_2c m4045 (.i(rx_data[1767:1760]),.o(syn_15_tmp[1767:1760]));
  gf_mult_by_01 m4046 (.i(rx_data[1775:1768]),.o(syn_15_tmp[1775:1768]));
  gf_mult_by_26 m4047 (.i(rx_data[1783:1776]),.o(syn_15_tmp[1783:1776]));
  gf_mult_by_60 m4048 (.i(rx_data[1791:1784]),.o(syn_15_tmp[1791:1784]));
  gf_mult_by_c1 m4049 (.i(rx_data[1799:1792]),.o(syn_15_tmp[1799:1792]));
  gf_mult_by_b9 m4050 (.i(rx_data[1807:1800]),.o(syn_15_tmp[1807:1800]));
  gf_mult_by_0f m4051 (.i(rx_data[1815:1808]),.o(syn_15_tmp[1815:1808]));
  gf_mult_by_df m4052 (.i(rx_data[1823:1816]),.o(syn_15_tmp[1823:1816]));
  gf_mult_by_1a m4053 (.i(rx_data[1831:1824]),.o(syn_15_tmp[1831:1824]));
  gf_mult_by_3b m4054 (.i(rx_data[1839:1832]),.o(syn_15_tmp[1839:1832]));
  gf_mult_by_a9 m4055 (.i(rx_data[1847:1840]),.o(syn_15_tmp[1847:1840]));
  gf_mult_by_55 m4056 (.i(rx_data[1855:1848]),.o(syn_15_tmp[1855:1848]));
  gf_mult_by_91 m4057 (.i(rx_data[1863:1856]),.o(syn_15_tmp[1863:1856]));
  gf_mult_by_96 m4058 (.i(rx_data[1871:1864]),.o(syn_15_tmp[1871:1864]));
  gf_mult_by_64 m4059 (.i(rx_data[1879:1872]),.o(syn_15_tmp[1879:1872]));
  gf_mult_by_59 m4060 (.i(rx_data[1887:1880]),.o(syn_15_tmp[1887:1880]));
  gf_mult_by_24 m4061 (.i(rx_data[1895:1888]),.o(syn_15_tmp[1895:1888]));
  gf_mult_by_2c m4062 (.i(rx_data[1903:1896]),.o(syn_15_tmp[1903:1896]));
  gf_mult_by_01 m4063 (.i(rx_data[1911:1904]),.o(syn_15_tmp[1911:1904]));
  gf_mult_by_26 m4064 (.i(rx_data[1919:1912]),.o(syn_15_tmp[1919:1912]));
  gf_mult_by_60 m4065 (.i(rx_data[1927:1920]),.o(syn_15_tmp[1927:1920]));
  gf_mult_by_c1 m4066 (.i(rx_data[1935:1928]),.o(syn_15_tmp[1935:1928]));
  gf_mult_by_b9 m4067 (.i(rx_data[1943:1936]),.o(syn_15_tmp[1943:1936]));
  gf_mult_by_0f m4068 (.i(rx_data[1951:1944]),.o(syn_15_tmp[1951:1944]));
  gf_mult_by_df m4069 (.i(rx_data[1959:1952]),.o(syn_15_tmp[1959:1952]));
  gf_mult_by_1a m4070 (.i(rx_data[1967:1960]),.o(syn_15_tmp[1967:1960]));
  gf_mult_by_3b m4071 (.i(rx_data[1975:1968]),.o(syn_15_tmp[1975:1968]));
  gf_mult_by_a9 m4072 (.i(rx_data[1983:1976]),.o(syn_15_tmp[1983:1976]));
  gf_mult_by_55 m4073 (.i(rx_data[1991:1984]),.o(syn_15_tmp[1991:1984]));
  gf_mult_by_91 m4074 (.i(rx_data[1999:1992]),.o(syn_15_tmp[1999:1992]));
  gf_mult_by_96 m4075 (.i(rx_data[2007:2000]),.o(syn_15_tmp[2007:2000]));
  gf_mult_by_64 m4076 (.i(rx_data[2015:2008]),.o(syn_15_tmp[2015:2008]));
  gf_mult_by_59 m4077 (.i(rx_data[2023:2016]),.o(syn_15_tmp[2023:2016]));
  gf_mult_by_24 m4078 (.i(rx_data[2031:2024]),.o(syn_15_tmp[2031:2024]));
  gf_mult_by_2c m4079 (.i(rx_data[2039:2032]),.o(syn_15_tmp[2039:2032]));
  assign syndrome[127:120] =
      syn_15_tmp[7:0] ^ syn_15_tmp[15:8] ^ syn_15_tmp[23:16] ^ 
      syn_15_tmp[31:24] ^ syn_15_tmp[39:32] ^ syn_15_tmp[47:40] ^ 
      syn_15_tmp[55:48] ^ syn_15_tmp[63:56] ^ syn_15_tmp[71:64] ^ 
      syn_15_tmp[79:72] ^ syn_15_tmp[87:80] ^ syn_15_tmp[95:88] ^ 
      syn_15_tmp[103:96] ^ syn_15_tmp[111:104] ^ syn_15_tmp[119:112] ^ 
      syn_15_tmp[127:120] ^ syn_15_tmp[135:128] ^ syn_15_tmp[143:136] ^ 
      syn_15_tmp[151:144] ^ syn_15_tmp[159:152] ^ syn_15_tmp[167:160] ^ 
      syn_15_tmp[175:168] ^ syn_15_tmp[183:176] ^ syn_15_tmp[191:184] ^ 
      syn_15_tmp[199:192] ^ syn_15_tmp[207:200] ^ syn_15_tmp[215:208] ^ 
      syn_15_tmp[223:216] ^ syn_15_tmp[231:224] ^ syn_15_tmp[239:232] ^ 
      syn_15_tmp[247:240] ^ syn_15_tmp[255:248] ^ syn_15_tmp[263:256] ^ 
      syn_15_tmp[271:264] ^ syn_15_tmp[279:272] ^ syn_15_tmp[287:280] ^ 
      syn_15_tmp[295:288] ^ syn_15_tmp[303:296] ^ syn_15_tmp[311:304] ^ 
      syn_15_tmp[319:312] ^ syn_15_tmp[327:320] ^ syn_15_tmp[335:328] ^ 
      syn_15_tmp[343:336] ^ syn_15_tmp[351:344] ^ syn_15_tmp[359:352] ^ 
      syn_15_tmp[367:360] ^ syn_15_tmp[375:368] ^ syn_15_tmp[383:376] ^ 
      syn_15_tmp[391:384] ^ syn_15_tmp[399:392] ^ syn_15_tmp[407:400] ^ 
      syn_15_tmp[415:408] ^ syn_15_tmp[423:416] ^ syn_15_tmp[431:424] ^ 
      syn_15_tmp[439:432] ^ syn_15_tmp[447:440] ^ syn_15_tmp[455:448] ^ 
      syn_15_tmp[463:456] ^ syn_15_tmp[471:464] ^ syn_15_tmp[479:472] ^ 
      syn_15_tmp[487:480] ^ syn_15_tmp[495:488] ^ syn_15_tmp[503:496] ^ 
      syn_15_tmp[511:504] ^ syn_15_tmp[519:512] ^ syn_15_tmp[527:520] ^ 
      syn_15_tmp[535:528] ^ syn_15_tmp[543:536] ^ syn_15_tmp[551:544] ^ 
      syn_15_tmp[559:552] ^ syn_15_tmp[567:560] ^ syn_15_tmp[575:568] ^ 
      syn_15_tmp[583:576] ^ syn_15_tmp[591:584] ^ syn_15_tmp[599:592] ^ 
      syn_15_tmp[607:600] ^ syn_15_tmp[615:608] ^ syn_15_tmp[623:616] ^ 
      syn_15_tmp[631:624] ^ syn_15_tmp[639:632] ^ syn_15_tmp[647:640] ^ 
      syn_15_tmp[655:648] ^ syn_15_tmp[663:656] ^ syn_15_tmp[671:664] ^ 
      syn_15_tmp[679:672] ^ syn_15_tmp[687:680] ^ syn_15_tmp[695:688] ^ 
      syn_15_tmp[703:696] ^ syn_15_tmp[711:704] ^ syn_15_tmp[719:712] ^ 
      syn_15_tmp[727:720] ^ syn_15_tmp[735:728] ^ syn_15_tmp[743:736] ^ 
      syn_15_tmp[751:744] ^ syn_15_tmp[759:752] ^ syn_15_tmp[767:760] ^ 
      syn_15_tmp[775:768] ^ syn_15_tmp[783:776] ^ syn_15_tmp[791:784] ^ 
      syn_15_tmp[799:792] ^ syn_15_tmp[807:800] ^ syn_15_tmp[815:808] ^ 
      syn_15_tmp[823:816] ^ syn_15_tmp[831:824] ^ syn_15_tmp[839:832] ^ 
      syn_15_tmp[847:840] ^ syn_15_tmp[855:848] ^ syn_15_tmp[863:856] ^ 
      syn_15_tmp[871:864] ^ syn_15_tmp[879:872] ^ syn_15_tmp[887:880] ^ 
      syn_15_tmp[895:888] ^ syn_15_tmp[903:896] ^ syn_15_tmp[911:904] ^ 
      syn_15_tmp[919:912] ^ syn_15_tmp[927:920] ^ syn_15_tmp[935:928] ^ 
      syn_15_tmp[943:936] ^ syn_15_tmp[951:944] ^ syn_15_tmp[959:952] ^ 
      syn_15_tmp[967:960] ^ syn_15_tmp[975:968] ^ syn_15_tmp[983:976] ^ 
      syn_15_tmp[991:984] ^ syn_15_tmp[999:992] ^ syn_15_tmp[1007:1000] ^ 
      syn_15_tmp[1015:1008] ^ syn_15_tmp[1023:1016] ^ syn_15_tmp[1031:1024] ^ 
      syn_15_tmp[1039:1032] ^ syn_15_tmp[1047:1040] ^ syn_15_tmp[1055:1048] ^ 
      syn_15_tmp[1063:1056] ^ syn_15_tmp[1071:1064] ^ syn_15_tmp[1079:1072] ^ 
      syn_15_tmp[1087:1080] ^ syn_15_tmp[1095:1088] ^ syn_15_tmp[1103:1096] ^ 
      syn_15_tmp[1111:1104] ^ syn_15_tmp[1119:1112] ^ syn_15_tmp[1127:1120] ^ 
      syn_15_tmp[1135:1128] ^ syn_15_tmp[1143:1136] ^ syn_15_tmp[1151:1144] ^ 
      syn_15_tmp[1159:1152] ^ syn_15_tmp[1167:1160] ^ syn_15_tmp[1175:1168] ^ 
      syn_15_tmp[1183:1176] ^ syn_15_tmp[1191:1184] ^ syn_15_tmp[1199:1192] ^ 
      syn_15_tmp[1207:1200] ^ syn_15_tmp[1215:1208] ^ syn_15_tmp[1223:1216] ^ 
      syn_15_tmp[1231:1224] ^ syn_15_tmp[1239:1232] ^ syn_15_tmp[1247:1240] ^ 
      syn_15_tmp[1255:1248] ^ syn_15_tmp[1263:1256] ^ syn_15_tmp[1271:1264] ^ 
      syn_15_tmp[1279:1272] ^ syn_15_tmp[1287:1280] ^ syn_15_tmp[1295:1288] ^ 
      syn_15_tmp[1303:1296] ^ syn_15_tmp[1311:1304] ^ syn_15_tmp[1319:1312] ^ 
      syn_15_tmp[1327:1320] ^ syn_15_tmp[1335:1328] ^ syn_15_tmp[1343:1336] ^ 
      syn_15_tmp[1351:1344] ^ syn_15_tmp[1359:1352] ^ syn_15_tmp[1367:1360] ^ 
      syn_15_tmp[1375:1368] ^ syn_15_tmp[1383:1376] ^ syn_15_tmp[1391:1384] ^ 
      syn_15_tmp[1399:1392] ^ syn_15_tmp[1407:1400] ^ syn_15_tmp[1415:1408] ^ 
      syn_15_tmp[1423:1416] ^ syn_15_tmp[1431:1424] ^ syn_15_tmp[1439:1432] ^ 
      syn_15_tmp[1447:1440] ^ syn_15_tmp[1455:1448] ^ syn_15_tmp[1463:1456] ^ 
      syn_15_tmp[1471:1464] ^ syn_15_tmp[1479:1472] ^ syn_15_tmp[1487:1480] ^ 
      syn_15_tmp[1495:1488] ^ syn_15_tmp[1503:1496] ^ syn_15_tmp[1511:1504] ^ 
      syn_15_tmp[1519:1512] ^ syn_15_tmp[1527:1520] ^ syn_15_tmp[1535:1528] ^ 
      syn_15_tmp[1543:1536] ^ syn_15_tmp[1551:1544] ^ syn_15_tmp[1559:1552] ^ 
      syn_15_tmp[1567:1560] ^ syn_15_tmp[1575:1568] ^ syn_15_tmp[1583:1576] ^ 
      syn_15_tmp[1591:1584] ^ syn_15_tmp[1599:1592] ^ syn_15_tmp[1607:1600] ^ 
      syn_15_tmp[1615:1608] ^ syn_15_tmp[1623:1616] ^ syn_15_tmp[1631:1624] ^ 
      syn_15_tmp[1639:1632] ^ syn_15_tmp[1647:1640] ^ syn_15_tmp[1655:1648] ^ 
      syn_15_tmp[1663:1656] ^ syn_15_tmp[1671:1664] ^ syn_15_tmp[1679:1672] ^ 
      syn_15_tmp[1687:1680] ^ syn_15_tmp[1695:1688] ^ syn_15_tmp[1703:1696] ^ 
      syn_15_tmp[1711:1704] ^ syn_15_tmp[1719:1712] ^ syn_15_tmp[1727:1720] ^ 
      syn_15_tmp[1735:1728] ^ syn_15_tmp[1743:1736] ^ syn_15_tmp[1751:1744] ^ 
      syn_15_tmp[1759:1752] ^ syn_15_tmp[1767:1760] ^ syn_15_tmp[1775:1768] ^ 
      syn_15_tmp[1783:1776] ^ syn_15_tmp[1791:1784] ^ syn_15_tmp[1799:1792] ^ 
      syn_15_tmp[1807:1800] ^ syn_15_tmp[1815:1808] ^ syn_15_tmp[1823:1816] ^ 
      syn_15_tmp[1831:1824] ^ syn_15_tmp[1839:1832] ^ syn_15_tmp[1847:1840] ^ 
      syn_15_tmp[1855:1848] ^ syn_15_tmp[1863:1856] ^ syn_15_tmp[1871:1864] ^ 
      syn_15_tmp[1879:1872] ^ syn_15_tmp[1887:1880] ^ syn_15_tmp[1895:1888] ^ 
      syn_15_tmp[1903:1896] ^ syn_15_tmp[1911:1904] ^ syn_15_tmp[1919:1912] ^ 
      syn_15_tmp[1927:1920] ^ syn_15_tmp[1935:1928] ^ syn_15_tmp[1943:1936] ^ 
      syn_15_tmp[1951:1944] ^ syn_15_tmp[1959:1952] ^ syn_15_tmp[1967:1960] ^ 
      syn_15_tmp[1975:1968] ^ syn_15_tmp[1983:1976] ^ syn_15_tmp[1991:1984] ^ 
      syn_15_tmp[1999:1992] ^ syn_15_tmp[2007:2000] ^ syn_15_tmp[2015:2008] ^ 
      syn_15_tmp[2023:2016] ^ syn_15_tmp[2031:2024] ^ syn_15_tmp[2039:2032];

endmodule


///////////////////////////////////////////

// 1 cycle per data symbol syndrome computation
// on the last cycle skip the mult, just XOR
module syndrome_round (rx_data,syndrome_in,syndrome_out,skip_mult);
input [7:0] rx_data;
input [127:0] syndrome_in;
input skip_mult;
output [127:0] syndrome_out;

// syndrome 0
  wire [7:0] syn_0_in;
  wire [7:0] syn_0_mult;
  assign syn_0_in = rx_data ^ syndrome_in[7:0];
  gf_mult_by_01 sm0 (.i(syn_0_in),.o(syn_0_mult));
  assign syndrome_out [7:0] = (skip_mult ? 
         syn_0_in : syn_0_mult);


// syndrome 1
  wire [7:0] syn_1_in;
  wire [7:0] syn_1_mult;
  assign syn_1_in = rx_data ^ syndrome_in[15:8];
  gf_mult_by_02 sm1 (.i(syn_1_in),.o(syn_1_mult));
  assign syndrome_out [15:8] = (skip_mult ? 
         syn_1_in : syn_1_mult);


// syndrome 2
  wire [7:0] syn_2_in;
  wire [7:0] syn_2_mult;
  assign syn_2_in = rx_data ^ syndrome_in[23:16];
  gf_mult_by_04 sm2 (.i(syn_2_in),.o(syn_2_mult));
  assign syndrome_out [23:16] = (skip_mult ? 
         syn_2_in : syn_2_mult);


// syndrome 3
  wire [7:0] syn_3_in;
  wire [7:0] syn_3_mult;
  assign syn_3_in = rx_data ^ syndrome_in[31:24];
  gf_mult_by_08 sm3 (.i(syn_3_in),.o(syn_3_mult));
  assign syndrome_out [31:24] = (skip_mult ? 
         syn_3_in : syn_3_mult);


// syndrome 4
  wire [7:0] syn_4_in;
  wire [7:0] syn_4_mult;
  assign syn_4_in = rx_data ^ syndrome_in[39:32];
  gf_mult_by_10 sm4 (.i(syn_4_in),.o(syn_4_mult));
  assign syndrome_out [39:32] = (skip_mult ? 
         syn_4_in : syn_4_mult);


// syndrome 5
  wire [7:0] syn_5_in;
  wire [7:0] syn_5_mult;
  assign syn_5_in = rx_data ^ syndrome_in[47:40];
  gf_mult_by_20 sm5 (.i(syn_5_in),.o(syn_5_mult));
  assign syndrome_out [47:40] = (skip_mult ? 
         syn_5_in : syn_5_mult);


// syndrome 6
  wire [7:0] syn_6_in;
  wire [7:0] syn_6_mult;
  assign syn_6_in = rx_data ^ syndrome_in[55:48];
  gf_mult_by_40 sm6 (.i(syn_6_in),.o(syn_6_mult));
  assign syndrome_out [55:48] = (skip_mult ? 
         syn_6_in : syn_6_mult);


// syndrome 7
  wire [7:0] syn_7_in;
  wire [7:0] syn_7_mult;
  assign syn_7_in = rx_data ^ syndrome_in[63:56];
  gf_mult_by_80 sm7 (.i(syn_7_in),.o(syn_7_mult));
  assign syndrome_out [63:56] = (skip_mult ? 
         syn_7_in : syn_7_mult);


// syndrome 8
  wire [7:0] syn_8_in;
  wire [7:0] syn_8_mult;
  assign syn_8_in = rx_data ^ syndrome_in[71:64];
  gf_mult_by_1d sm8 (.i(syn_8_in),.o(syn_8_mult));
  assign syndrome_out [71:64] = (skip_mult ? 
         syn_8_in : syn_8_mult);


// syndrome 9
  wire [7:0] syn_9_in;
  wire [7:0] syn_9_mult;
  assign syn_9_in = rx_data ^ syndrome_in[79:72];
  gf_mult_by_3a sm9 (.i(syn_9_in),.o(syn_9_mult));
  assign syndrome_out [79:72] = (skip_mult ? 
         syn_9_in : syn_9_mult);


// syndrome 10
  wire [7:0] syn_10_in;
  wire [7:0] syn_10_mult;
  assign syn_10_in = rx_data ^ syndrome_in[87:80];
  gf_mult_by_74 sm10 (.i(syn_10_in),.o(syn_10_mult));
  assign syndrome_out [87:80] = (skip_mult ? 
         syn_10_in : syn_10_mult);


// syndrome 11
  wire [7:0] syn_11_in;
  wire [7:0] syn_11_mult;
  assign syn_11_in = rx_data ^ syndrome_in[95:88];
  gf_mult_by_e8 sm11 (.i(syn_11_in),.o(syn_11_mult));
  assign syndrome_out [95:88] = (skip_mult ? 
         syn_11_in : syn_11_mult);


// syndrome 12
  wire [7:0] syn_12_in;
  wire [7:0] syn_12_mult;
  assign syn_12_in = rx_data ^ syndrome_in[103:96];
  gf_mult_by_cd sm12 (.i(syn_12_in),.o(syn_12_mult));
  assign syndrome_out [103:96] = (skip_mult ? 
         syn_12_in : syn_12_mult);


// syndrome 13
  wire [7:0] syn_13_in;
  wire [7:0] syn_13_mult;
  assign syn_13_in = rx_data ^ syndrome_in[111:104];
  gf_mult_by_87 sm13 (.i(syn_13_in),.o(syn_13_mult));
  assign syndrome_out [111:104] = (skip_mult ? 
         syn_13_in : syn_13_mult);


// syndrome 14
  wire [7:0] syn_14_in;
  wire [7:0] syn_14_mult;
  assign syn_14_in = rx_data ^ syndrome_in[119:112];
  gf_mult_by_13 sm14 (.i(syn_14_in),.o(syn_14_mult));
  assign syndrome_out [119:112] = (skip_mult ? 
         syn_14_in : syn_14_mult);


// syndrome 15
  wire [7:0] syn_15_in;
  wire [7:0] syn_15_mult;
  assign syn_15_in = rx_data ^ syndrome_in[127:120];
  gf_mult_by_26 sm15 (.i(syn_15_in),.o(syn_15_mult));
  assign syndrome_out [127:120] = (skip_mult ? 
         syn_15_in : syn_15_mult);


endmodule


///////////////////////////////////////////

// PROBLEM - the iterative unit isn't exercised well
module syndrome_tb ();
reg [7:0] din;
reg clk,clk_ena,tx_ena,rst,first_din;
wire [127:0] parity;
reg [1911:0] tx_buffer;
wire [2039:0] tx_data = {tx_buffer,parity};
reg [2039:0] err;
wire [2039:0] rx_data = tx_data ^ err;
wire [127:0] syndrome;
reg [127:0] syndrome_reg;
wire [127:0] next_syndrome_reg;

// iterative encoder
encoder enc (.clk(clk & tx_ena),.ena(1'b1),.shift(1'b0),.rst(rst),.first_din(first_din),.din(din),.parity(parity));

// flat and iterative syndrome generators
reg [7:0] par;
reg sending_data;
syndrome_flat syn_f (.rx_data(rx_data),.syndrome(syndrome));
syndrome_round syn_r (.rx_data(sending_data ? din : par),.syndrome_in(syndrome_reg),	.syndrome_out(next_syndrome_reg),.skip_mult(1'b0));

initial begin
  clk = 0;
  rst = 0;
  tx_ena = 1'b1;
  clk_ena = 1'b1;
  sending_data = 1'b1;
  first_din = 1'b1;
  #10 rst = 1;
  #10 rst = 0;
  @(posedge clk) syndrome_reg <= 0; // cheating
end

always begin
  #100 if (clk_ena) clk = ~clk;
end

always @(negedge clk) begin
  din <= $random;
end

always @(posedge clk) begin
  if (tx_ena) tx_buffer <= (tx_buffer << 8) | din;
end

always @(posedge clk or posedge rst) begin
  if (rst) syndrome_reg <= 0;
  else syndrome_reg <= next_syndrome_reg;
end

integer i;
initial begin

  // start the TX of a new word
  #100
  @(negedge clk);
  err = 0;
  first_din = 1'b1;
  @(posedge clk);
  @(negedge clk);
  first_din = 1'b0;
  for (i=0; i<238; i=i+1) begin
    @(posedge clk);
    @(negedge clk);
  end

  // stop the TX, RX gets more cycle of data..
  tx_ena = 1'b0;
  sending_data = 1'b0;
  // give the RX the rest of the parity symbols..
  par = parity [127:120];
  @(posedge clk);
  @(negedge clk);
  par = parity [119:112];
  @(posedge clk);
  @(negedge clk);
  par = parity [111:104];
  @(posedge clk);
  @(negedge clk);
  par = parity [103:96];
  @(posedge clk);
  @(negedge clk);
  par = parity [95:88];
  @(posedge clk);
  @(negedge clk);
  par = parity [87:80];
  @(posedge clk);
  @(negedge clk);
  par = parity [79:72];
  @(posedge clk);
  @(negedge clk);
  par = parity [71:64];
  @(posedge clk);
  @(negedge clk);
  par = parity [63:56];
  @(posedge clk);
  @(negedge clk);
  par = parity [55:48];
  @(posedge clk);
  @(negedge clk);
  par = parity [47:40];
  @(posedge clk);
  @(negedge clk);
  par = parity [39:32];
  @(posedge clk);
  @(negedge clk);
  par = parity [31:24];
  @(posedge clk);
  @(negedge clk);
  par = parity [23:16];
  @(posedge clk);
  @(negedge clk);
  par = parity [15:8];
  @(posedge clk);
  @(negedge clk);
  par = parity [7:0];
  @(posedge clk);
  @(negedge clk);
  clk_ena = 1'b0;

  // Check the syndromes of the uncorrupted data
  $display ("tx data %x",tx_data);
  $display ("  pure rx data %x",rx_data);
  $display ("  flat syndrome %x",syndrome);
  if (syndrome !== 0) begin
    $display ("Error : correct code has a non-zero syndrome");
    $stop();
  end
  $display ("  round syndrome %x",syndrome_reg);
  if (syndrome_reg !== 0) begin
    $display ("Error : correct code has a non-zero syndrome");
    $stop();
  end

  // Corrupt, and make sure it gets detected
  #10 err = 1'b1;
  for (i=0; i<2040; i=i+1) begin
    #10
    $display ("  corrupted rx data %x",rx_data);
    $display ("  syndrome %x",syndrome);
    if (syndrome == 0) begin
      $display ("Error : incorrect code has zero syndrome");
      $stop();
    end
    err = err << 1;
  end
  $display ("PASS");
  $stop();
end

endmodule

///////////////////////////////////////////

// Galois field multiplier, 8 by 8 modulus 0x11d
module gf_mult (a,b,o);
input [7:0] a;
input [7:0] b;
output [7:0] o;
wire [7:0] o /* synthesis keep */;
parameter METHOD = 2;

generate
    if (METHOD == 0) begin
        // Build A,2A,4A,.. with modulus
        wire [7:0] a_0;
        assign a_0 = {^(a & 8'h80),^(a & 8'h40),^(a & 8'h20),^(a & 8'h10),^(a & 8'h8),^(a & 8'h4),^(a & 8'h2),^(a & 8'h1)};

        wire [7:0] a_1;
        assign a_1 = {^(a & 8'h40),^(a & 8'h20),^(a & 8'h10),^(a & 8'h88),^(a & 8'h84),^(a & 8'h82),^(a & 8'h1),^(a & 8'h80)};

        wire [7:0] a_2;
        assign a_2 = {^(a & 8'h20),^(a & 8'h10),^(a & 8'h88),^(a & 8'hc4),^(a & 8'hc2),^(a & 8'h41),^(a & 8'h80),^(a & 8'h40)};

        wire [7:0] a_3;
        assign a_3 = {^(a & 8'h10),^(a & 8'h88),^(a & 8'hc4),^(a & 8'he2),^(a & 8'h61),^(a & 8'ha0),^(a & 8'h40),^(a & 8'h20)};

        wire [7:0] a_4;
        assign a_4 = {^(a & 8'h88),^(a & 8'hc4),^(a & 8'he2),^(a & 8'h71),^(a & 8'hb0),^(a & 8'h50),^(a & 8'h20),^(a & 8'h10)};

        wire [7:0] a_5;
        assign a_5 = {^(a & 8'hc4),^(a & 8'he2),^(a & 8'h71),^(a & 8'h38),^(a & 8'hd8),^(a & 8'ha8),^(a & 8'h10),^(a & 8'h88)};

        wire [7:0] a_6;
        assign a_6 = {^(a & 8'he2),^(a & 8'h71),^(a & 8'h38),^(a & 8'h1c),^(a & 8'h6c),^(a & 8'hd4),^(a & 8'h88),^(a & 8'hc4)};

        wire [7:0] a_7;
        assign a_7 = {^(a & 8'h71),^(a & 8'h38),^(a & 8'h1c),^(a & 8'h8e),^(a & 8'h36),^(a & 8'h6a),^(a & 8'hc4),^(a & 8'he2)};

        // Conditional sum based on the B bits
        assign o = 
        ({8{b[0]}} & a_0) ^
        ({8{b[1]}} & a_1) ^
        ({8{b[2]}} & a_2) ^
        ({8{b[3]}} & a_3) ^
        ({8{b[4]}} & a_4) ^
        ({8{b[5]}} & a_5) ^
        ({8{b[6]}} & a_6) ^
        ({8{b[7]}} & a_7);

    end
    else if (METHOD == 1) begin
        // Build shifted sum of A&B0, A&B1... no modulus
        wire [14:0] full_sum;
        assign full_sum = 
            ({8{b[0]}} & a) ^
            {({8{b[1]}} & a),1'b0} ^
            {({8{b[2]}} & a),2'b0} ^
            {({8{b[3]}} & a),3'b0} ^
            {({8{b[4]}} & a),4'b0} ^
            {({8{b[5]}} & a),5'b0} ^
            {({8{b[6]}} & a),6'b0} ^
            {({8{b[7]}} & a),7'b0};

        // Modulus out the terms with out-of-range order
        assign o = 
           full_sum[7:0] ^
           ({8{full_sum[8]}} & 8'h1d) ^
           ({8{full_sum[9]}} & 8'h3a) ^
           ({8{full_sum[10]}} & 8'h74) ^
           ({8{full_sum[11]}} & 8'he8) ^
           ({8{full_sum[12]}} & 8'hcd) ^
           ({8{full_sum[13]}} & 8'h87) ^
           ({8{full_sum[14]}} & 8'h13);
    end
    else if (METHOD == 2) begin
        // Build explicit array of AND gates
        wire [63:0] and_terms;
        assign and_terms = {
            ({8{b[7]}} & a),
            ({8{b[6]}} & a),
            ({8{b[5]}} & a),
            ({8{b[4]}} & a),
            ({8{b[3]}} & a),
            ({8{b[2]}} & a),
            ({8{b[1]}} & a),
            ({8{b[0]}} & a)};

       wire o0_helper0 = 
           and_terms[15] /* B[1] A[7] */ ^
           and_terms[47] /* B[5] A[7] */ ^
           and_terms[55] /* B[6] A[7] */ ^
           and_terms[57] /* B[7] A[1] */ ^
           and_terms[63] /* B[7] A[7] */ /* synthesis keep */;

       wire o0_helper1 = 
           and_terms[22] /* B[2] A[6] */ ^
           and_terms[29] /* B[3] A[5] */ ^
           and_terms[54] /* B[6] A[6] */ ^
           and_terms[61] /* B[7] A[5] */ ^
           and_terms[62] /* B[7] A[6] */ /* synthesis keep */;

       wire o0_helper2 = 
           and_terms[0] /* B[0] A[0] */ ^
           and_terms[43] /* B[5] A[3] */ ^
           and_terms[50] /* B[6] A[2] */ /* synthesis keep */;

       wire o0_helper3 = 
           and_terms[36] /* B[4] A[4] */ /* synthesis keep */;

       assign o[0] = 
         o0_helper0 ^
         o0_helper1 ^
         o0_helper2 ^
         o0_helper3;

       wire o1_helper0 = 
           and_terms[23] /* B[2] A[7] */ ^
           and_terms[30] /* B[3] A[6] */ ^
           and_terms[55] /* B[6] A[7] */ ^
           and_terms[62] /* B[7] A[6] */ ^
           and_terms[63] /* B[7] A[7] */ /* synthesis keep */;

       wire o1_helper1 = 
           and_terms[1] /* B[0] A[1] */ ^
           and_terms[8] /* B[1] A[0] */ ^
           and_terms[58] /* B[7] A[2] */ /* synthesis keep */;

       wire o1_helper2 = 
           and_terms[37] /* B[4] A[5] */ ^
           and_terms[44] /* B[5] A[4] */ ^
           and_terms[51] /* B[6] A[3] */ /* synthesis keep */;

       assign o[1] = 
         o1_helper0 ^
         o1_helper1 ^
         o1_helper2;

       wire o2_helper0 = 
           and_terms[22] /* B[2] A[6] */ ^
           and_terms[36] /* B[4] A[4] */ ^
           and_terms[38] /* B[4] A[6] */ ^
           and_terms[52] /* B[6] A[4] */ ^
           and_terms[54] /* B[6] A[6] */ ^
           and_terms[62] /* B[7] A[6] */ /* synthesis keep */;

       wire o2_helper1 = 
           and_terms[15] /* B[1] A[7] */ ^
           and_terms[31] /* B[3] A[7] */ ^
           and_terms[47] /* B[5] A[7] */ ^
           and_terms[55] /* B[6] A[7] */ /* synthesis keep */;

       wire o2_helper2 = 
           and_terms[9] /* B[1] A[1] */ ^
           and_terms[29] /* B[3] A[5] */ ^
           and_terms[45] /* B[5] A[5] */ ^
           and_terms[57] /* B[7] A[1] */ ^
           and_terms[61] /* B[7] A[5] */ /* synthesis keep */;

       wire o2_helper3 = 
           and_terms[2] /* B[0] A[2] */ ^
           and_terms[43] /* B[5] A[3] */ ^
           and_terms[50] /* B[6] A[2] */ ^
           and_terms[59] /* B[7] A[3] */ /* synthesis keep */;

       wire o2_helper4 = 
           and_terms[16] /* B[2] A[0] */ /* synthesis keep */;

       assign o[2] = 
         o2_helper0 ^
         o2_helper1 ^
         o2_helper2 ^
         o2_helper3 ^
         o2_helper4;

       wire o3_helper0 = 
           and_terms[24] /* B[3] A[0] */ ^
           and_terms[29] /* B[3] A[5] */ ^
           and_terms[37] /* B[4] A[5] */ ^
           and_terms[53] /* B[6] A[5] */ ^
           and_terms[61] /* B[7] A[5] */ /* synthesis keep */;

       wire o3_helper1 = 
           and_terms[22] /* B[2] A[6] */ ^
           and_terms[30] /* B[3] A[6] */ ^
           and_terms[46] /* B[5] A[6] */ ^
           and_terms[54] /* B[6] A[6] */ /* synthesis keep */;

       wire o3_helper2 = 
           and_terms[15] /* B[1] A[7] */ ^
           and_terms[23] /* B[2] A[7] */ ^
           and_terms[39] /* B[4] A[7] */ ^
           and_terms[47] /* B[5] A[7] */ /* synthesis keep */;

       wire o3_helper3 = 
           and_terms[10] /* B[1] A[2] */ ^
           and_terms[17] /* B[2] A[1] */ ^
           and_terms[50] /* B[6] A[2] */ ^
           and_terms[57] /* B[7] A[1] */ ^
           and_terms[58] /* B[7] A[2] */ /* synthesis keep */;

       wire o3_helper4 = 
           and_terms[3] /* B[0] A[3] */ ^
           and_terms[43] /* B[5] A[3] */ ^
           and_terms[51] /* B[6] A[3] */ /* synthesis keep */;

       wire o3_helper5 = 
           and_terms[36] /* B[4] A[4] */ ^
           and_terms[44] /* B[5] A[4] */ ^
           and_terms[60] /* B[7] A[4] */ /* synthesis keep */;

       assign o[3] = 
         o3_helper0 ^
         o3_helper1 ^
         o3_helper2 ^
         o3_helper3 ^
         o3_helper4 ^
         o3_helper5;

       wire o4_helper0 = 
           and_terms[11] /* B[1] A[3] */ ^
           and_terms[43] /* B[5] A[3] */ ^
           and_terms[51] /* B[6] A[3] */ ^
           and_terms[59] /* B[7] A[3] */ /* synthesis keep */;

       wire o4_helper1 = 
           and_terms[4] /* B[0] A[4] */ ^
           and_terms[32] /* B[4] A[0] */ ^
           and_terms[36] /* B[4] A[4] */ ^
           and_terms[44] /* B[5] A[4] */ ^
           and_terms[52] /* B[6] A[4] */ /* synthesis keep */;

       wire o4_helper2 = 
           and_terms[15] /* B[1] A[7] */ ^
           and_terms[23] /* B[2] A[7] */ ^
           and_terms[25] /* B[3] A[1] */ ^
           and_terms[31] /* B[3] A[7] */ ^
           and_terms[57] /* B[7] A[1] */ ^
           and_terms[63] /* B[7] A[7] */ /* synthesis keep */;

       wire o4_helper3 = 
           and_terms[18] /* B[2] A[2] */ ^
           and_terms[50] /* B[6] A[2] */ ^
           and_terms[58] /* B[7] A[2] */ /* synthesis keep */;

       wire o4_helper4 = 
           and_terms[22] /* B[2] A[6] */ ^
           and_terms[29] /* B[3] A[5] */ ^
           and_terms[30] /* B[3] A[6] */ ^
           and_terms[37] /* B[4] A[5] */ ^
           and_terms[38] /* B[4] A[6] */ ^
           and_terms[45] /* B[5] A[5] */ /* synthesis keep */;

       assign o[4] = 
         o4_helper0 ^
         o4_helper1 ^
         o4_helper2 ^
         o4_helper3 ^
         o4_helper4;

       wire o5_helper0 = 
           and_terms[12] /* B[1] A[4] */ ^
           and_terms[40] /* B[5] A[0] */ ^
           and_terms[44] /* B[5] A[4] */ ^
           and_terms[52] /* B[6] A[4] */ ^
           and_terms[60] /* B[7] A[4] */ /* synthesis keep */;

       wire o5_helper1 = 
           and_terms[5] /* B[0] A[5] */ ^
           and_terms[33] /* B[4] A[1] */ ^
           and_terms[37] /* B[4] A[5] */ ^
           and_terms[45] /* B[5] A[5] */ ^
           and_terms[53] /* B[6] A[5] */ /* synthesis keep */;

       wire o5_helper2 = 
           and_terms[19] /* B[2] A[3] */ ^
           and_terms[26] /* B[3] A[2] */ ^
           and_terms[51] /* B[6] A[3] */ ^
           and_terms[58] /* B[7] A[2] */ ^
           and_terms[59] /* B[7] A[3] */ /* synthesis keep */;

       wire o5_helper3 = 
           and_terms[23] /* B[2] A[7] */ ^
           and_terms[30] /* B[3] A[6] */ ^
           and_terms[31] /* B[3] A[7] */ ^
           and_terms[38] /* B[4] A[6] */ ^
           and_terms[39] /* B[4] A[7] */ ^
           and_terms[46] /* B[5] A[6] */ /* synthesis keep */;

       assign o[5] = 
         o5_helper0 ^
         o5_helper1 ^
         o5_helper2 ^
         o5_helper3;

       wire o6_helper0 = 
           and_terms[13] /* B[1] A[5] */ ^
           and_terms[45] /* B[5] A[5] */ ^
           and_terms[48] /* B[6] A[0] */ ^
           and_terms[53] /* B[6] A[5] */ ^
           and_terms[61] /* B[7] A[5] */ /* synthesis keep */;

       wire o6_helper1 = 
           and_terms[6] /* B[0] A[6] */ ^
           and_terms[38] /* B[4] A[6] */ ^
           and_terms[41] /* B[5] A[1] */ ^
           and_terms[46] /* B[5] A[6] */ ^
           and_terms[54] /* B[6] A[6] */ /* synthesis keep */;

       wire o6_helper2 = 
           and_terms[20] /* B[2] A[4] */ ^
           and_terms[27] /* B[3] A[3] */ ^
           and_terms[52] /* B[6] A[4] */ ^
           and_terms[59] /* B[7] A[3] */ ^
           and_terms[60] /* B[7] A[4] */ /* synthesis keep */;

       wire o6_helper3 = 
           and_terms[31] /* B[3] A[7] */ ^
           and_terms[34] /* B[4] A[2] */ ^
           and_terms[39] /* B[4] A[7] */ ^
           and_terms[47] /* B[5] A[7] */ /* synthesis keep */;

       assign o[6] = 
         o6_helper0 ^
         o6_helper1 ^
         o6_helper2 ^
         o6_helper3;

       wire o7_helper0 = 
           and_terms[14] /* B[1] A[6] */ ^
           and_terms[46] /* B[5] A[6] */ ^
           and_terms[54] /* B[6] A[6] */ ^
           and_terms[56] /* B[7] A[0] */ ^
           and_terms[62] /* B[7] A[6] */ /* synthesis keep */;

       wire o7_helper1 = 
           and_terms[7] /* B[0] A[7] */ ^
           and_terms[39] /* B[4] A[7] */ ^
           and_terms[47] /* B[5] A[7] */ ^
           and_terms[49] /* B[6] A[1] */ ^
           and_terms[55] /* B[6] A[7] */ /* synthesis keep */;

       wire o7_helper2 = 
           and_terms[21] /* B[2] A[5] */ ^
           and_terms[28] /* B[3] A[4] */ ^
           and_terms[53] /* B[6] A[5] */ ^
           and_terms[60] /* B[7] A[4] */ ^
           and_terms[61] /* B[7] A[5] */ /* synthesis keep */;

       wire o7_helper3 = 
           and_terms[35] /* B[4] A[3] */ ^
           and_terms[42] /* B[5] A[2] */ /* synthesis keep */;

       assign o[7] = 
         o7_helper0 ^
         o7_helper1 ^
         o7_helper2 ^
         o7_helper3;

    end
endgenerate
endmodule


///////////////////////////////////////////

module gf_inverse (i,o);
input [7:0] i;
output [7:0] o;
reg [7:0] o /* synthesis keep */;
  always @(i) begin
     case (i)
       8'h0: o=8'h0;
       8'h1: o=8'h1;
       8'h2: o=8'h8e;
       8'h4: o=8'h47;
       8'h8: o=8'had;
       8'h10: o=8'hd8;
       8'h20: o=8'h6c;
       8'h40: o=8'h36;
       8'h80: o=8'h1b;
       8'h1d: o=8'h83;
       8'h3a: o=8'hcf;
       8'h74: o=8'he9;
       8'he8: o=8'hfa;
       8'hcd: o=8'h7d;
       8'h87: o=8'hb0;
       8'h13: o=8'h58;
       8'h26: o=8'h2c;
       8'h4c: o=8'h16;
       8'h98: o=8'hb;
       8'h2d: o=8'h8b;
       8'h5a: o=8'hcb;
       8'hb4: o=8'heb;
       8'h75: o=8'hfb;
       8'hea: o=8'hf3;
       8'hc9: o=8'hf7;
       8'h8f: o=8'hf5;
       8'h3: o=8'hf4;
       8'h6: o=8'h7a;
       8'hc: o=8'h3d;
       8'h18: o=8'h90;
       8'h30: o=8'h48;
       8'h60: o=8'h24;
       8'hc0: o=8'h12;
       8'h9d: o=8'h9;
       8'h27: o=8'h8a;
       8'h4e: o=8'h45;
       8'h9c: o=8'hac;
       8'h25: o=8'h56;
       8'h4a: o=8'h2b;
       8'h94: o=8'h9b;
       8'h35: o=8'hc3;
       8'h6a: o=8'hef;
       8'hd4: o=8'hf9;
       8'hb5: o=8'hf2;
       8'h77: o=8'h79;
       8'hee: o=8'hb2;
       8'hc1: o=8'h59;
       8'h9f: o=8'ha2;
       8'h23: o=8'h51;
       8'h46: o=8'ha6;
       8'h8c: o=8'h53;
       8'h5: o=8'ha7;
       8'ha: o=8'hdd;
       8'h14: o=8'he0;
       8'h28: o=8'h70;
       8'h50: o=8'h38;
       8'ha0: o=8'h1c;
       8'h5d: o=8'he;
       8'hba: o=8'h7;
       8'h69: o=8'h8d;
       8'hd2: o=8'hc8;
       8'hb9: o=8'h64;
       8'h6f: o=8'h32;
       8'hde: o=8'h19;
       8'ha1: o=8'h82;
       8'h5f: o=8'h41;
       8'hbe: o=8'hae;
       8'h61: o=8'h57;
       8'hc2: o=8'ha5;
       8'h99: o=8'hdc;
       8'h2f: o=8'h6e;
       8'h5e: o=8'h37;
       8'hbc: o=8'h95;
       8'h65: o=8'hc4;
       8'hca: o=8'h62;
       8'h89: o=8'h31;
       8'hf: o=8'h96;
       8'h1e: o=8'h4b;
       8'h3c: o=8'hab;
       8'h78: o=8'hdb;
       8'hf0: o=8'he3;
       8'hfd: o=8'hff;
       8'he7: o=8'hf1;
       8'hd3: o=8'hf6;
       8'hbb: o=8'h7b;
       8'h6b: o=8'hb3;
       8'hd6: o=8'hd7;
       8'hb1: o=8'he5;
       8'h7f: o=8'hfc;
       8'hfe: o=8'h7e;
       8'he1: o=8'h3f;
       8'hdf: o=8'h91;
       8'ha3: o=8'hc6;
       8'h5b: o=8'h63;
       8'hb6: o=8'hbf;
       8'h71: o=8'hd1;
       8'he2: o=8'he6;
       8'hd9: o=8'h73;
       8'haf: o=8'hb7;
       8'h43: o=8'hd5;
       8'h86: o=8'he4;
       8'h11: o=8'h72;
       8'h22: o=8'h39;
       8'h44: o=8'h92;
       8'h88: o=8'h49;
       8'hd: o=8'haa;
       8'h1a: o=8'h55;
       8'h34: o=8'ha4;
       8'h68: o=8'h52;
       8'hd0: o=8'h29;
       8'hbd: o=8'h9a;
       8'h67: o=8'h4d;
       8'hce: o=8'ha8;
       8'h81: o=8'h54;
       8'h1f: o=8'h2a;
       8'h3e: o=8'h15;
       8'h7c: o=8'h84;
       8'hf8: o=8'h42;
       8'hed: o=8'h21;
       8'hc7: o=8'h9e;
       8'h93: o=8'h4f;
       8'h3b: o=8'ha9;
       8'h76: o=8'hda;
       8'hec: o=8'h6d;
       8'hc5: o=8'hb8;
       8'h97: o=8'h5c;
       8'h33: o=8'h2e;
       8'h66: o=8'h17;
       8'hcc: o=8'h85;
       8'h85: o=8'hcc;
       8'h17: o=8'h66;
       8'h2e: o=8'h33;
       8'h5c: o=8'h97;
       8'hb8: o=8'hc5;
       8'h6d: o=8'hec;
       8'hda: o=8'h76;
       8'ha9: o=8'h3b;
       8'h4f: o=8'h93;
       8'h9e: o=8'hc7;
       8'h21: o=8'hed;
       8'h42: o=8'hf8;
       8'h84: o=8'h7c;
       8'h15: o=8'h3e;
       8'h2a: o=8'h1f;
       8'h54: o=8'h81;
       8'ha8: o=8'hce;
       8'h4d: o=8'h67;
       8'h9a: o=8'hbd;
       8'h29: o=8'hd0;
       8'h52: o=8'h68;
       8'ha4: o=8'h34;
       8'h55: o=8'h1a;
       8'haa: o=8'hd;
       8'h49: o=8'h88;
       8'h92: o=8'h44;
       8'h39: o=8'h22;
       8'h72: o=8'h11;
       8'he4: o=8'h86;
       8'hd5: o=8'h43;
       8'hb7: o=8'haf;
       8'h73: o=8'hd9;
       8'he6: o=8'he2;
       8'hd1: o=8'h71;
       8'hbf: o=8'hb6;
       8'h63: o=8'h5b;
       8'hc6: o=8'ha3;
       8'h91: o=8'hdf;
       8'h3f: o=8'he1;
       8'h7e: o=8'hfe;
       8'hfc: o=8'h7f;
       8'he5: o=8'hb1;
       8'hd7: o=8'hd6;
       8'hb3: o=8'h6b;
       8'h7b: o=8'hbb;
       8'hf6: o=8'hd3;
       8'hf1: o=8'he7;
       8'hff: o=8'hfd;
       8'he3: o=8'hf0;
       8'hdb: o=8'h78;
       8'hab: o=8'h3c;
       8'h4b: o=8'h1e;
       8'h96: o=8'hf;
       8'h31: o=8'h89;
       8'h62: o=8'hca;
       8'hc4: o=8'h65;
       8'h95: o=8'hbc;
       8'h37: o=8'h5e;
       8'h6e: o=8'h2f;
       8'hdc: o=8'h99;
       8'ha5: o=8'hc2;
       8'h57: o=8'h61;
       8'hae: o=8'hbe;
       8'h41: o=8'h5f;
       8'h82: o=8'ha1;
       8'h19: o=8'hde;
       8'h32: o=8'h6f;
       8'h64: o=8'hb9;
       8'hc8: o=8'hd2;
       8'h8d: o=8'h69;
       8'h7: o=8'hba;
       8'he: o=8'h5d;
       8'h1c: o=8'ha0;
       8'h38: o=8'h50;
       8'h70: o=8'h28;
       8'he0: o=8'h14;
       8'hdd: o=8'ha;
       8'ha7: o=8'h5;
       8'h53: o=8'h8c;
       8'ha6: o=8'h46;
       8'h51: o=8'h23;
       8'ha2: o=8'h9f;
       8'h59: o=8'hc1;
       8'hb2: o=8'hee;
       8'h79: o=8'h77;
       8'hf2: o=8'hb5;
       8'hf9: o=8'hd4;
       8'hef: o=8'h6a;
       8'hc3: o=8'h35;
       8'h9b: o=8'h94;
       8'h2b: o=8'h4a;
       8'h56: o=8'h25;
       8'hac: o=8'h9c;
       8'h45: o=8'h4e;
       8'h8a: o=8'h27;
       8'h9: o=8'h9d;
       8'h12: o=8'hc0;
       8'h24: o=8'h60;
       8'h48: o=8'h30;
       8'h90: o=8'h18;
       8'h3d: o=8'hc;
       8'h7a: o=8'h6;
       8'hf4: o=8'h3;
       8'hf5: o=8'h8f;
       8'hf7: o=8'hc9;
       8'hf3: o=8'hea;
       8'hfb: o=8'h75;
       8'heb: o=8'hb4;
       8'hcb: o=8'h5a;
       8'h8b: o=8'h2d;
       8'hb: o=8'h98;
       8'h16: o=8'h4c;
       8'h2c: o=8'h26;
       8'h58: o=8'h13;
       8'hb0: o=8'h87;
       8'h7d: o=8'hcd;
       8'hfa: o=8'he8;
       8'he9: o=8'h74;
       8'hcf: o=8'h3a;
       8'h83: o=8'h1d;
       8'h1b: o=8'h80;
       8'h36: o=8'h40;
       8'h6c: o=8'h20;
       8'hd8: o=8'h10;
       8'had: o=8'h8;
       8'h47: o=8'h4;
       8'h8e: o=8'h2;
     endcase
   end
endmodule


///////////////////////////////////////////

module gf_divide (n,d,o);
input [7:0] n;
input [7:0] d;
output [7:0] o;
wire [7:0] o;

wire [7:0] d_inv;
gf_inverse divi (.i(d),.o(d_inv));
gf_mult divm (.a(n),.b(d_inv),.o(o));

endmodule


///////////////////////////////////////////
// Error Location poly computation
//   1 tick per round version
///////////////////////////////////////////

// initial ELP_in is 1 at word 0 (meaning 1)
// initial correction is 1 at word 1 (meaning x)
// step = 1..2t
// This is using the Berlekamp method
module error_loc_poly_round (step,order_in,order_out,elp_in,elp_out,step_syndrome,
          correction_in,correction_out);
input [4:0] step;
input [3:0] order_in;
output [3:0] order_out;
input [127:0] elp_in;
output [127:0] elp_out;
input [127:0] step_syndrome;
input [127:0] correction_in;
output [127:0] correction_out;

reg [3:0] order_out;
reg [127:0] correction_out;

wire [7:0] discrepancy;

wire [127:0] disc_mult;
gf_mult m0 (.a(elp_in[7:0]),.b(step_syndrome[7:0]),.o(disc_mult[7:0]));
gf_mult m1 (.a(elp_in[15:8]),.b(step_syndrome[15:8]),.o(disc_mult[15:8]));
gf_mult m2 (.a(elp_in[23:16]),.b(step_syndrome[23:16]),.o(disc_mult[23:16]));
gf_mult m3 (.a(elp_in[31:24]),.b(step_syndrome[31:24]),.o(disc_mult[31:24]));
gf_mult m4 (.a(elp_in[39:32]),.b(step_syndrome[39:32]),.o(disc_mult[39:32]));
gf_mult m5 (.a(elp_in[47:40]),.b(step_syndrome[47:40]),.o(disc_mult[47:40]));
gf_mult m6 (.a(elp_in[55:48]),.b(step_syndrome[55:48]),.o(disc_mult[55:48]));
gf_mult m7 (.a(elp_in[63:56]),.b(step_syndrome[63:56]),.o(disc_mult[63:56]));
gf_mult m8 (.a(elp_in[71:64]),.b(step_syndrome[71:64]),.o(disc_mult[71:64]));
gf_mult m9 (.a(elp_in[79:72]),.b(step_syndrome[79:72]),.o(disc_mult[79:72]));
gf_mult m10 (.a(elp_in[87:80]),.b(step_syndrome[87:80]),.o(disc_mult[87:80]));
gf_mult m11 (.a(elp_in[95:88]),.b(step_syndrome[95:88]),.o(disc_mult[95:88]));
gf_mult m12 (.a(elp_in[103:96]),.b(step_syndrome[103:96]),.o(disc_mult[103:96]));
gf_mult m13 (.a(elp_in[111:104]),.b(step_syndrome[111:104]),.o(disc_mult[111:104]));
gf_mult m14 (.a(elp_in[119:112]),.b(step_syndrome[119:112]),.o(disc_mult[119:112]));
gf_mult m15 (.a(elp_in[127:120]),.b(step_syndrome[127:120]),.o(disc_mult[127:120]));

assign discrepancy = 
    disc_mult [7:0] ^
    disc_mult [15:8] ^
    disc_mult [23:16] ^
    disc_mult [31:24] ^
    disc_mult [39:32] ^
    disc_mult [47:40] ^
    disc_mult [55:48] ^
    disc_mult [63:56] ^
    disc_mult [71:64] ^
    disc_mult [79:72] ^
    disc_mult [87:80] ^
    disc_mult [95:88] ^
    disc_mult [103:96] ^
    disc_mult [111:104] ^
    disc_mult [119:112] ^
    disc_mult [127:120]
;

wire [127:0] disc_mult_correction;
gf_mult m16 (.a(discrepancy),.b(correction_in[7:0]),.o(disc_mult_correction[7:0]));
gf_mult m17 (.a(discrepancy),.b(correction_in[15:8]),.o(disc_mult_correction[15:8]));
gf_mult m18 (.a(discrepancy),.b(correction_in[23:16]),.o(disc_mult_correction[23:16]));
gf_mult m19 (.a(discrepancy),.b(correction_in[31:24]),.o(disc_mult_correction[31:24]));
gf_mult m20 (.a(discrepancy),.b(correction_in[39:32]),.o(disc_mult_correction[39:32]));
gf_mult m21 (.a(discrepancy),.b(correction_in[47:40]),.o(disc_mult_correction[47:40]));
gf_mult m22 (.a(discrepancy),.b(correction_in[55:48]),.o(disc_mult_correction[55:48]));
gf_mult m23 (.a(discrepancy),.b(correction_in[63:56]),.o(disc_mult_correction[63:56]));
gf_mult m24 (.a(discrepancy),.b(correction_in[71:64]),.o(disc_mult_correction[71:64]));
gf_mult m25 (.a(discrepancy),.b(correction_in[79:72]),.o(disc_mult_correction[79:72]));
gf_mult m26 (.a(discrepancy),.b(correction_in[87:80]),.o(disc_mult_correction[87:80]));
gf_mult m27 (.a(discrepancy),.b(correction_in[95:88]),.o(disc_mult_correction[95:88]));
gf_mult m28 (.a(discrepancy),.b(correction_in[103:96]),.o(disc_mult_correction[103:96]));
gf_mult m29 (.a(discrepancy),.b(correction_in[111:104]),.o(disc_mult_correction[111:104]));
gf_mult m30 (.a(discrepancy),.b(correction_in[119:112]),.o(disc_mult_correction[119:112]));
gf_mult m31 (.a(discrepancy),.b(correction_in[127:120]),.o(disc_mult_correction[127:120]));

assign elp_out = elp_in ^ disc_mult_correction;

// build the elp divided by the discrepancy
//  by inverse then multiply...
wire [7:0] inv_discrepancy;
gf_inverse id (.i(discrepancy),.o(inv_discrepancy));

wire [127:0] elp_div_disc;
gf_mult d32 (.a(elp_in[7:0]),.b(inv_discrepancy),.o(elp_div_disc[7:0]));
gf_mult d33 (.a(elp_in[15:8]),.b(inv_discrepancy),.o(elp_div_disc[15:8]));
gf_mult d34 (.a(elp_in[23:16]),.b(inv_discrepancy),.o(elp_div_disc[23:16]));
gf_mult d35 (.a(elp_in[31:24]),.b(inv_discrepancy),.o(elp_div_disc[31:24]));
gf_mult d36 (.a(elp_in[39:32]),.b(inv_discrepancy),.o(elp_div_disc[39:32]));
gf_mult d37 (.a(elp_in[47:40]),.b(inv_discrepancy),.o(elp_div_disc[47:40]));
gf_mult d38 (.a(elp_in[55:48]),.b(inv_discrepancy),.o(elp_div_disc[55:48]));
gf_mult d39 (.a(elp_in[63:56]),.b(inv_discrepancy),.o(elp_div_disc[63:56]));
gf_mult d40 (.a(elp_in[71:64]),.b(inv_discrepancy),.o(elp_div_disc[71:64]));
gf_mult d41 (.a(elp_in[79:72]),.b(inv_discrepancy),.o(elp_div_disc[79:72]));
gf_mult d42 (.a(elp_in[87:80]),.b(inv_discrepancy),.o(elp_div_disc[87:80]));
gf_mult d43 (.a(elp_in[95:88]),.b(inv_discrepancy),.o(elp_div_disc[95:88]));
gf_mult d44 (.a(elp_in[103:96]),.b(inv_discrepancy),.o(elp_div_disc[103:96]));
gf_mult d45 (.a(elp_in[111:104]),.b(inv_discrepancy),.o(elp_div_disc[111:104]));
gf_mult d46 (.a(elp_in[119:112]),.b(inv_discrepancy),.o(elp_div_disc[119:112]));
gf_mult d47 (.a(elp_in[127:120]),.b(inv_discrepancy),.o(elp_div_disc[127:120]));

// update the order and correction poly
always @(*) begin
  if ((|discrepancy) && ((order_in << 1) < step)) begin
    order_out = step - order_in;
    correction_out = {elp_div_disc[119:0],8'b0};
  end
  else begin
    order_out = order_in;
    correction_out = {correction_in[119:0],8'b0} ;
  end
end

endmodule

/////////////////////////////////////////////////
// Error Location poly computation
//   Multiple ticks per round version
///////////////////////////////////////////////////

// initial ELP_in is 1 at word 0 (meaning 1)
// initial correction is 1 at word 1 (meaning x)
// step = 1..2t
// This is using the Berlekamp method
module error_loc_poly_round_multi_step (step,order_in,order_out,elp_in,elp_out,step_syndrome,
          correction_in,correction_out,clk,rst,sync,elpr_wait);
input [4:0] step;
input [3:0] order_in;
output [3:0] order_out;
input [127:0] elp_in;
output [127:0] elp_out;
input [127:0] step_syndrome;
input [127:0] correction_in;
output [127:0] correction_out;

input clk,rst,sync;
output elpr_wait;

reg [3:0] order_out;
reg [127:0] correction_out;

wire [7:0] discrepancy;

// state 0 : (upper) discrepancy_reg <= ^ (elp_in * step_syn)
// state 1 : (lower) discrepancy_reg <= ^ (elp_in * step_syn)
// state 2 : (upper) disc_cor_reg <= (dicrepancy_reg * correction)
// state 3 : (lower) disc_cor_reg <= (dicrepancy_reg * correction)
// state 4 : (upper) elp_div_disc_reg <= elp_in * inverse discrepancy
// state 5 : (lower) elp_div_disc_reg <= elp_in * inverse discrepancy
// state 6 : settling time
reg [6:0] wait_state;

always @(posedge clk or posedge rst) begin
  if (rst) wait_state <= 7'b1;
  else begin
    if (sync) wait_state <= 7'b000001;
    else wait_state <= {wait_state[5:0],wait_state[6]};
  end
end

assign elpr_wait = !wait_state[6];

wire [63:0] mult_in_a, mult_in_b, mult_o, disc_inv_repeat;
wire [7:0] disc_inv_mux;
assign disc_inv_repeat = {8{disc_inv_mux}};

// multi purpose Galois mult (half size)
wire [63:0] elp_in_hi, elp_in_lo, correction_in_hi, correction_in_lo;
wire [63:0] step_syndrome_hi, step_syndrome_lo;
assign {step_syndrome_hi,step_syndrome_lo} = step_syndrome;
assign {elp_in_hi,elp_in_lo} = elp_in;
assign {correction_in_hi,correction_in_lo} = correction_in;

assign mult_in_a = (wait_state[0] | wait_state[4]) ? elp_in_hi :
                   (wait_state[1] | wait_state[5]) ? elp_in_lo :
                   (wait_state[2]) ? correction_in_hi :
                   correction_in_lo;
assign mult_in_b = (wait_state[0]) ? step_syndrome_hi :
                   (wait_state[1]) ? step_syndrome_lo :
                   disc_inv_repeat;

gf_mult m0 (.a(mult_in_a[7:0]),.b(mult_in_b[7:0]),.o(mult_o[7:0]));
gf_mult m1 (.a(mult_in_a[15:8]),.b(mult_in_b[15:8]),.o(mult_o[15:8]));
gf_mult m2 (.a(mult_in_a[23:16]),.b(mult_in_b[23:16]),.o(mult_o[23:16]));
gf_mult m3 (.a(mult_in_a[31:24]),.b(mult_in_b[31:24]),.o(mult_o[31:24]));
gf_mult m4 (.a(mult_in_a[39:32]),.b(mult_in_b[39:32]),.o(mult_o[39:32]));
gf_mult m5 (.a(mult_in_a[47:40]),.b(mult_in_b[47:40]),.o(mult_o[47:40]));
gf_mult m6 (.a(mult_in_a[55:48]),.b(mult_in_b[55:48]),.o(mult_o[55:48]));
gf_mult m7 (.a(mult_in_a[63:56]),.b(mult_in_b[63:56]),.o(mult_o[63:56]));

// XOR the mult output words together for the discrepancy
assign discrepancy = 
    mult_o [7:0] ^
    mult_o [15:8] ^
    mult_o [23:16] ^
    mult_o [31:24] ^
    mult_o [39:32] ^
    mult_o [47:40] ^
    mult_o [55:48] ^
    mult_o [63:56]
;

reg [7:0] discrepancy_reg;
always @(posedge clk or posedge rst) begin
  if (rst) discrepancy_reg <= 0;
  else begin
    if (wait_state[0]) discrepancy_reg <= discrepancy;
    else if (wait_state[1]) discrepancy_reg <= discrepancy ^ discrepancy_reg;
  end
end


// XOR the mult output words with ELP in for ELP out
reg [127:0] disc_cor_reg;
always @(posedge clk or posedge rst) begin
  if (rst) disc_cor_reg <= 0;
  else begin
     if (wait_state[2]) disc_cor_reg[127:64] <= mult_o;
     else if (wait_state[3]) disc_cor_reg[64:0] <= mult_o;
  end
end

assign elp_out = elp_in ^ disc_cor_reg;

// Capture the mult out directly for ELP divided by discrepancy
reg [127:0] elp_div_disc_reg;
always @(posedge clk or posedge rst) begin
  if (rst) elp_div_disc_reg <= 0;
  else begin
     if (wait_state[4]) elp_div_disc_reg[127:64] <= mult_o;
     else if (wait_state[5]) elp_div_disc_reg[64:0] <= mult_o;
  end
end

// build the mult inverse of the discrepancy
wire [7:0] inv_discrepancy_wire;
reg [7:0] inv_discrepancy;
gf_inverse id (.i(discrepancy_reg),.o(inv_discrepancy_wire));

always @(posedge clk or posedge rst) begin
  if (rst) inv_discrepancy <= 8'b0;
  else inv_discrepancy <= inv_discrepancy_wire;
end

// offer the discrepancy or inverse to the multiplier
assign disc_inv_mux = ((wait_state[4] || wait_state[5]) ? inv_discrepancy : discrepancy_reg);
// update the order and correction poly
always @(*) begin
  if ((|discrepancy_reg) && ((order_in << 1) < step)) begin
    order_out = step - order_in;
    correction_out = {elp_div_disc_reg[119:0],8'b0};
  end
  else begin
    order_out = order_in;
    correction_out = {correction_in[119:0],8'b0} ;
  end
end

endmodule

///////////////////////////////////////////
// Error location poly root finder
///////////////////////////////////////////

// Fixable problems will have the degree of the ELP
// less than or equal to t (8)
// This is using the Chien search method
module error_loc_poly_roots (elp_in,elp_out,match);
input [71:0] elp_in;
output [71:0] elp_out;
output match;

wire [7:0] q;
  gf_mult_by_01 rp0 (.i(elp_in[7:0]),.o(elp_out[7:0]));
  gf_mult_by_02 rp1 (.i(elp_in[15:8]),.o(elp_out[15:8]));
  gf_mult_by_04 rp2 (.i(elp_in[23:16]),.o(elp_out[23:16]));
  gf_mult_by_08 rp3 (.i(elp_in[31:24]),.o(elp_out[31:24]));
  gf_mult_by_10 rp4 (.i(elp_in[39:32]),.o(elp_out[39:32]));
  gf_mult_by_20 rp5 (.i(elp_in[47:40]),.o(elp_out[47:40]));
  gf_mult_by_40 rp6 (.i(elp_in[55:48]),.o(elp_out[55:48]));
  gf_mult_by_80 rp7 (.i(elp_in[63:56]),.o(elp_out[63:56]));
  gf_mult_by_1d rp8 (.i(elp_in[71:64]),.o(elp_out[71:64]));

  assign q = 
   elp_out [7:0] ^
   elp_out [15:8] ^
   elp_out [23:16] ^
   elp_out [31:24] ^
   elp_out [39:32] ^
   elp_out [47:40] ^
   elp_out [55:48] ^
   elp_out [63:56] ^
   elp_out [71:64]
;

assign match = ~|q;

endmodule

///////////////////////////////////////////
// Error magnitude poly computation
///////////////////////////////////////////

module error_mag_poly_round (step_elp,syndrome,emp_term);
input [71:0] step_elp;
input [71:0] syndrome;
output [7:0] emp_term;
wire [71:0] mag_mult;
gf_mult m0 (.a(step_elp[7:0]),.b(syndrome[7:0]),.o(mag_mult[7:0]));
gf_mult m1 (.a(step_elp[15:8]),.b(syndrome[15:8]),.o(mag_mult[15:8]));
gf_mult m2 (.a(step_elp[23:16]),.b(syndrome[23:16]),.o(mag_mult[23:16]));
gf_mult m3 (.a(step_elp[31:24]),.b(syndrome[31:24]),.o(mag_mult[31:24]));
gf_mult m4 (.a(step_elp[39:32]),.b(syndrome[39:32]),.o(mag_mult[39:32]));
gf_mult m5 (.a(step_elp[47:40]),.b(syndrome[47:40]),.o(mag_mult[47:40]));
gf_mult m6 (.a(step_elp[55:48]),.b(syndrome[55:48]),.o(mag_mult[55:48]));
gf_mult m7 (.a(step_elp[63:56]),.b(syndrome[63:56]),.o(mag_mult[63:56]));
gf_mult m8 (.a(step_elp[71:64]),.b(syndrome[71:64]),.o(mag_mult[71:64]));

assign emp_term = 
    mag_mult [7:0] ^
    mag_mult [15:8] ^
    mag_mult [23:16] ^
    mag_mult [31:24] ^
    mag_mult [39:32] ^
    mag_mult [47:40] ^
    mag_mult [55:48] ^
    mag_mult [63:56] ^
    mag_mult [71:64]
;

endmodule


///////////////////////////////////////////
// Error Value computation
///////////////////////////////////////////

// deriv_term is ELP'(alpha^-j) / alpha^j
// error position indicates symbols with actual errors
// error_value will have the invert pattern to correct bad symbols
module error_value_round (emp_in,emp_out,deriv_term,error_pos,error_val);
input [71:0] emp_in;
output [71:0] emp_out;
input [7:0] deriv_term;
input error_pos;
output [7:0] error_val;

wire [7:0] q,r;
  gf_mult_by_01 rp0 (.i(emp_in[7:0]),.o(emp_out[7:0]));
  gf_mult_by_02 rp1 (.i(emp_in[15:8]),.o(emp_out[15:8]));
  gf_mult_by_04 rp2 (.i(emp_in[23:16]),.o(emp_out[23:16]));
  gf_mult_by_08 rp3 (.i(emp_in[31:24]),.o(emp_out[31:24]));
  gf_mult_by_10 rp4 (.i(emp_in[39:32]),.o(emp_out[39:32]));
  gf_mult_by_20 rp5 (.i(emp_in[47:40]),.o(emp_out[47:40]));
  gf_mult_by_40 rp6 (.i(emp_in[55:48]),.o(emp_out[55:48]));
  gf_mult_by_80 rp7 (.i(emp_in[63:56]),.o(emp_out[63:56]));
  gf_mult_by_1d rp8 (.i(emp_in[71:64]),.o(emp_out[71:64]));

  assign q = 
   emp_out [7:0] ^
   emp_out [15:8] ^
   emp_out [23:16] ^
   emp_out [31:24] ^
   emp_out [39:32] ^
   emp_out [47:40] ^
   emp_out [55:48] ^
   emp_out [63:56] ^
   emp_out [71:64]
;

// r will be the correction if the symbol is actually
// wrong, and garbage if it's correct.  Apply as appro
gf_divide evd (.n(q),.d(deriv_term),.o(r));

assign error_val = {8{error_pos}} & r;

endmodule

//////////////////////////////////////////////
// Complete decoder - no latency version

//////////////////////////////////////////////
module flat_decoder(rx_data,rx_data_corrected);

input [2039:0] rx_data;
output [2039:0] rx_data_corrected;

wire [127:0] syndrome;
syndrome_flat syn (.rx_data(rx_data),.syndrome(syndrome));

//////////////////////////////
// build error location poly
//////////////////////////////
wire [3:0] order_0;
wire [127:0] elp_0;
wire [127:0] step_syn_0;
wire [127:0] correction_0;
wire [3:0] order_1;
wire [127:0] elp_1;
wire [127:0] step_syn_1;
wire [127:0] correction_1;
wire [3:0] order_2;
wire [127:0] elp_2;
wire [127:0] step_syn_2;
wire [127:0] correction_2;
wire [3:0] order_3;
wire [127:0] elp_3;
wire [127:0] step_syn_3;
wire [127:0] correction_3;
wire [3:0] order_4;
wire [127:0] elp_4;
wire [127:0] step_syn_4;
wire [127:0] correction_4;
wire [3:0] order_5;
wire [127:0] elp_5;
wire [127:0] step_syn_5;
wire [127:0] correction_5;
wire [3:0] order_6;
wire [127:0] elp_6;
wire [127:0] step_syn_6;
wire [127:0] correction_6;
wire [3:0] order_7;
wire [127:0] elp_7;
wire [127:0] step_syn_7;
wire [127:0] correction_7;
wire [3:0] order_8;
wire [127:0] elp_8;
wire [127:0] step_syn_8;
wire [127:0] correction_8;
wire [3:0] order_9;
wire [127:0] elp_9;
wire [127:0] step_syn_9;
wire [127:0] correction_9;
wire [3:0] order_10;
wire [127:0] elp_10;
wire [127:0] step_syn_10;
wire [127:0] correction_10;
wire [3:0] order_11;
wire [127:0] elp_11;
wire [127:0] step_syn_11;
wire [127:0] correction_11;
wire [3:0] order_12;
wire [127:0] elp_12;
wire [127:0] step_syn_12;
wire [127:0] correction_12;
wire [3:0] order_13;
wire [127:0] elp_13;
wire [127:0] step_syn_13;
wire [127:0] correction_13;
wire [3:0] order_14;
wire [127:0] elp_14;
wire [127:0] step_syn_14;
wire [127:0] correction_14;
wire [3:0] order_15;
wire [127:0] elp_15;
wire [127:0] step_syn_15;
wire [127:0] correction_15;
wire [3:0] order_16;
wire [127:0] elp_16;
wire [127:0] step_syn_16;
wire [127:0] correction_16;

assign order_0 = 0;
assign correction_0 = 1 << 8;
assign step_syn_0 = syndrome[7:0];
assign elp_0 = 1;

error_loc_poly_round r0 (.step(1),.order_in(order_0),
   .order_out(order_1),.elp_in(elp_0),.elp_out(elp_1),
   .step_syndrome(step_syn_0),
   .correction_in(correction_0),.correction_out(correction_1));

assign step_syn_1 = {step_syn_0,syndrome[15:8]};
error_loc_poly_round r1 (.step(2),.order_in(order_1),
   .order_out(order_2),.elp_in(elp_1),.elp_out(elp_2),
   .step_syndrome(step_syn_1),
   .correction_in(correction_1),.correction_out(correction_2));

assign step_syn_2 = {step_syn_1,syndrome[23:16]};
error_loc_poly_round r2 (.step(3),.order_in(order_2),
   .order_out(order_3),.elp_in(elp_2),.elp_out(elp_3),
   .step_syndrome(step_syn_2),
   .correction_in(correction_2),.correction_out(correction_3));

assign step_syn_3 = {step_syn_2,syndrome[31:24]};
error_loc_poly_round r3 (.step(4),.order_in(order_3),
   .order_out(order_4),.elp_in(elp_3),.elp_out(elp_4),
   .step_syndrome(step_syn_3),
   .correction_in(correction_3),.correction_out(correction_4));

assign step_syn_4 = {step_syn_3,syndrome[39:32]};
error_loc_poly_round r4 (.step(5),.order_in(order_4),
   .order_out(order_5),.elp_in(elp_4),.elp_out(elp_5),
   .step_syndrome(step_syn_4),
   .correction_in(correction_4),.correction_out(correction_5));

assign step_syn_5 = {step_syn_4,syndrome[47:40]};
error_loc_poly_round r5 (.step(6),.order_in(order_5),
   .order_out(order_6),.elp_in(elp_5),.elp_out(elp_6),
   .step_syndrome(step_syn_5),
   .correction_in(correction_5),.correction_out(correction_6));

assign step_syn_6 = {step_syn_5,syndrome[55:48]};
error_loc_poly_round r6 (.step(7),.order_in(order_6),
   .order_out(order_7),.elp_in(elp_6),.elp_out(elp_7),
   .step_syndrome(step_syn_6),
   .correction_in(correction_6),.correction_out(correction_7));

assign step_syn_7 = {step_syn_6,syndrome[63:56]};
error_loc_poly_round r7 (.step(8),.order_in(order_7),
   .order_out(order_8),.elp_in(elp_7),.elp_out(elp_8),
   .step_syndrome(step_syn_7),
   .correction_in(correction_7),.correction_out(correction_8));

assign step_syn_8 = {step_syn_7,syndrome[71:64]};
error_loc_poly_round r8 (.step(9),.order_in(order_8),
   .order_out(order_9),.elp_in(elp_8),.elp_out(elp_9),
   .step_syndrome(step_syn_8),
   .correction_in(correction_8),.correction_out(correction_9));

assign step_syn_9 = {step_syn_8,syndrome[79:72]};
error_loc_poly_round r9 (.step(10),.order_in(order_9),
   .order_out(order_10),.elp_in(elp_9),.elp_out(elp_10),
   .step_syndrome(step_syn_9),
   .correction_in(correction_9),.correction_out(correction_10));

assign step_syn_10 = {step_syn_9,syndrome[87:80]};
error_loc_poly_round r10 (.step(11),.order_in(order_10),
   .order_out(order_11),.elp_in(elp_10),.elp_out(elp_11),
   .step_syndrome(step_syn_10),
   .correction_in(correction_10),.correction_out(correction_11));

assign step_syn_11 = {step_syn_10,syndrome[95:88]};
error_loc_poly_round r11 (.step(12),.order_in(order_11),
   .order_out(order_12),.elp_in(elp_11),.elp_out(elp_12),
   .step_syndrome(step_syn_11),
   .correction_in(correction_11),.correction_out(correction_12));

assign step_syn_12 = {step_syn_11,syndrome[103:96]};
error_loc_poly_round r12 (.step(13),.order_in(order_12),
   .order_out(order_13),.elp_in(elp_12),.elp_out(elp_13),
   .step_syndrome(step_syn_12),
   .correction_in(correction_12),.correction_out(correction_13));

assign step_syn_13 = {step_syn_12,syndrome[111:104]};
error_loc_poly_round r13 (.step(14),.order_in(order_13),
   .order_out(order_14),.elp_in(elp_13),.elp_out(elp_14),
   .step_syndrome(step_syn_13),
   .correction_in(correction_13),.correction_out(correction_14));

assign step_syn_14 = {step_syn_13,syndrome[119:112]};
error_loc_poly_round r14 (.step(15),.order_in(order_14),
   .order_out(order_15),.elp_in(elp_14),.elp_out(elp_15),
   .step_syndrome(step_syn_14),
   .correction_in(correction_14),.correction_out(correction_15));

assign step_syn_15 = {step_syn_14,syndrome[127:120]};
error_loc_poly_round r15 (.step(16),.order_in(order_15),
   .order_out(order_16),.elp_in(elp_15),.elp_out(elp_16),
   .step_syndrome(step_syn_15),
   .correction_in(correction_15),.correction_out(correction_16));

wire [127:0] elp;
assign elp = elp_16;

wire [71:0] step_elp_0;
wire [71:0] step_elp_1;
wire [71:0] step_elp_2;
wire [71:0] step_elp_3;
wire [71:0] step_elp_4;
wire [71:0] step_elp_5;
wire [71:0] step_elp_6;
wire [71:0] step_elp_7;
wire [71:0] step_elp_8;
wire [71:0] step_elp_9;
//////////////////////////////
// build error mag poly
//////////////////////////////
wire [71:0] emp;

assign step_elp_0 = elp[7:0];
error_mag_poly_round m0 (.step_elp(step_elp_0),
    .syndrome(syndrome),.emp_term(emp[7:0]));

assign step_elp_1 = {step_elp_0,elp[15:8]};
error_mag_poly_round m1 (.step_elp(step_elp_1),
    .syndrome(syndrome),.emp_term(emp[15:8]));

assign step_elp_2 = {step_elp_1,elp[23:16]};
error_mag_poly_round m2 (.step_elp(step_elp_2),
    .syndrome(syndrome),.emp_term(emp[23:16]));

assign step_elp_3 = {step_elp_2,elp[31:24]};
error_mag_poly_round m3 (.step_elp(step_elp_3),
    .syndrome(syndrome),.emp_term(emp[31:24]));

assign step_elp_4 = {step_elp_3,elp[39:32]};
error_mag_poly_round m4 (.step_elp(step_elp_4),
    .syndrome(syndrome),.emp_term(emp[39:32]));

assign step_elp_5 = {step_elp_4,elp[47:40]};
error_mag_poly_round m5 (.step_elp(step_elp_5),
    .syndrome(syndrome),.emp_term(emp[47:40]));

assign step_elp_6 = {step_elp_5,elp[55:48]};
error_mag_poly_round m6 (.step_elp(step_elp_6),
    .syndrome(syndrome),.emp_term(emp[55:48]));

assign step_elp_7 = {step_elp_6,elp[63:56]};
error_mag_poly_round m7 (.step_elp(step_elp_7),
    .syndrome(syndrome),.emp_term(emp[63:56]));

assign step_elp_8 = {step_elp_7,elp[71:64]};
error_mag_poly_round m8 (.step_elp(step_elp_8),
    .syndrome(syndrome),.emp_term(emp[71:64]));

//////////////////////////////
// Find roots of ELP
//////////////////////////////

wire [254:0] root_match;
wire [71:0] elprt_0 = elp[71:0];
wire [71:0] elprt_1;
error_loc_poly_roots elpr0 (.elp_in(elprt_0),
     .elp_out(elprt_1),.match(root_match[0]));

wire [71:0] elprt_2;
error_loc_poly_roots elpr1 (.elp_in(elprt_1),
     .elp_out(elprt_2),.match(root_match[1]));

wire [71:0] elprt_3;
error_loc_poly_roots elpr2 (.elp_in(elprt_2),
     .elp_out(elprt_3),.match(root_match[2]));

wire [71:0] elprt_4;
error_loc_poly_roots elpr3 (.elp_in(elprt_3),
     .elp_out(elprt_4),.match(root_match[3]));

wire [71:0] elprt_5;
error_loc_poly_roots elpr4 (.elp_in(elprt_4),
     .elp_out(elprt_5),.match(root_match[4]));

wire [71:0] elprt_6;
error_loc_poly_roots elpr5 (.elp_in(elprt_5),
     .elp_out(elprt_6),.match(root_match[5]));

wire [71:0] elprt_7;
error_loc_poly_roots elpr6 (.elp_in(elprt_6),
     .elp_out(elprt_7),.match(root_match[6]));

wire [71:0] elprt_8;
error_loc_poly_roots elpr7 (.elp_in(elprt_7),
     .elp_out(elprt_8),.match(root_match[7]));

wire [71:0] elprt_9;
error_loc_poly_roots elpr8 (.elp_in(elprt_8),
     .elp_out(elprt_9),.match(root_match[8]));

wire [71:0] elprt_10;
error_loc_poly_roots elpr9 (.elp_in(elprt_9),
     .elp_out(elprt_10),.match(root_match[9]));

wire [71:0] elprt_11;
error_loc_poly_roots elpr10 (.elp_in(elprt_10),
     .elp_out(elprt_11),.match(root_match[10]));

wire [71:0] elprt_12;
error_loc_poly_roots elpr11 (.elp_in(elprt_11),
     .elp_out(elprt_12),.match(root_match[11]));

wire [71:0] elprt_13;
error_loc_poly_roots elpr12 (.elp_in(elprt_12),
     .elp_out(elprt_13),.match(root_match[12]));

wire [71:0] elprt_14;
error_loc_poly_roots elpr13 (.elp_in(elprt_13),
     .elp_out(elprt_14),.match(root_match[13]));

wire [71:0] elprt_15;
error_loc_poly_roots elpr14 (.elp_in(elprt_14),
     .elp_out(elprt_15),.match(root_match[14]));

wire [71:0] elprt_16;
error_loc_poly_roots elpr15 (.elp_in(elprt_15),
     .elp_out(elprt_16),.match(root_match[15]));

wire [71:0] elprt_17;
error_loc_poly_roots elpr16 (.elp_in(elprt_16),
     .elp_out(elprt_17),.match(root_match[16]));

wire [71:0] elprt_18;
error_loc_poly_roots elpr17 (.elp_in(elprt_17),
     .elp_out(elprt_18),.match(root_match[17]));

wire [71:0] elprt_19;
error_loc_poly_roots elpr18 (.elp_in(elprt_18),
     .elp_out(elprt_19),.match(root_match[18]));

wire [71:0] elprt_20;
error_loc_poly_roots elpr19 (.elp_in(elprt_19),
     .elp_out(elprt_20),.match(root_match[19]));

wire [71:0] elprt_21;
error_loc_poly_roots elpr20 (.elp_in(elprt_20),
     .elp_out(elprt_21),.match(root_match[20]));

wire [71:0] elprt_22;
error_loc_poly_roots elpr21 (.elp_in(elprt_21),
     .elp_out(elprt_22),.match(root_match[21]));

wire [71:0] elprt_23;
error_loc_poly_roots elpr22 (.elp_in(elprt_22),
     .elp_out(elprt_23),.match(root_match[22]));

wire [71:0] elprt_24;
error_loc_poly_roots elpr23 (.elp_in(elprt_23),
     .elp_out(elprt_24),.match(root_match[23]));

wire [71:0] elprt_25;
error_loc_poly_roots elpr24 (.elp_in(elprt_24),
     .elp_out(elprt_25),.match(root_match[24]));

wire [71:0] elprt_26;
error_loc_poly_roots elpr25 (.elp_in(elprt_25),
     .elp_out(elprt_26),.match(root_match[25]));

wire [71:0] elprt_27;
error_loc_poly_roots elpr26 (.elp_in(elprt_26),
     .elp_out(elprt_27),.match(root_match[26]));

wire [71:0] elprt_28;
error_loc_poly_roots elpr27 (.elp_in(elprt_27),
     .elp_out(elprt_28),.match(root_match[27]));

wire [71:0] elprt_29;
error_loc_poly_roots elpr28 (.elp_in(elprt_28),
     .elp_out(elprt_29),.match(root_match[28]));

wire [71:0] elprt_30;
error_loc_poly_roots elpr29 (.elp_in(elprt_29),
     .elp_out(elprt_30),.match(root_match[29]));

wire [71:0] elprt_31;
error_loc_poly_roots elpr30 (.elp_in(elprt_30),
     .elp_out(elprt_31),.match(root_match[30]));

wire [71:0] elprt_32;
error_loc_poly_roots elpr31 (.elp_in(elprt_31),
     .elp_out(elprt_32),.match(root_match[31]));

wire [71:0] elprt_33;
error_loc_poly_roots elpr32 (.elp_in(elprt_32),
     .elp_out(elprt_33),.match(root_match[32]));

wire [71:0] elprt_34;
error_loc_poly_roots elpr33 (.elp_in(elprt_33),
     .elp_out(elprt_34),.match(root_match[33]));

wire [71:0] elprt_35;
error_loc_poly_roots elpr34 (.elp_in(elprt_34),
     .elp_out(elprt_35),.match(root_match[34]));

wire [71:0] elprt_36;
error_loc_poly_roots elpr35 (.elp_in(elprt_35),
     .elp_out(elprt_36),.match(root_match[35]));

wire [71:0] elprt_37;
error_loc_poly_roots elpr36 (.elp_in(elprt_36),
     .elp_out(elprt_37),.match(root_match[36]));

wire [71:0] elprt_38;
error_loc_poly_roots elpr37 (.elp_in(elprt_37),
     .elp_out(elprt_38),.match(root_match[37]));

wire [71:0] elprt_39;
error_loc_poly_roots elpr38 (.elp_in(elprt_38),
     .elp_out(elprt_39),.match(root_match[38]));

wire [71:0] elprt_40;
error_loc_poly_roots elpr39 (.elp_in(elprt_39),
     .elp_out(elprt_40),.match(root_match[39]));

wire [71:0] elprt_41;
error_loc_poly_roots elpr40 (.elp_in(elprt_40),
     .elp_out(elprt_41),.match(root_match[40]));

wire [71:0] elprt_42;
error_loc_poly_roots elpr41 (.elp_in(elprt_41),
     .elp_out(elprt_42),.match(root_match[41]));

wire [71:0] elprt_43;
error_loc_poly_roots elpr42 (.elp_in(elprt_42),
     .elp_out(elprt_43),.match(root_match[42]));

wire [71:0] elprt_44;
error_loc_poly_roots elpr43 (.elp_in(elprt_43),
     .elp_out(elprt_44),.match(root_match[43]));

wire [71:0] elprt_45;
error_loc_poly_roots elpr44 (.elp_in(elprt_44),
     .elp_out(elprt_45),.match(root_match[44]));

wire [71:0] elprt_46;
error_loc_poly_roots elpr45 (.elp_in(elprt_45),
     .elp_out(elprt_46),.match(root_match[45]));

wire [71:0] elprt_47;
error_loc_poly_roots elpr46 (.elp_in(elprt_46),
     .elp_out(elprt_47),.match(root_match[46]));

wire [71:0] elprt_48;
error_loc_poly_roots elpr47 (.elp_in(elprt_47),
     .elp_out(elprt_48),.match(root_match[47]));

wire [71:0] elprt_49;
error_loc_poly_roots elpr48 (.elp_in(elprt_48),
     .elp_out(elprt_49),.match(root_match[48]));

wire [71:0] elprt_50;
error_loc_poly_roots elpr49 (.elp_in(elprt_49),
     .elp_out(elprt_50),.match(root_match[49]));

wire [71:0] elprt_51;
error_loc_poly_roots elpr50 (.elp_in(elprt_50),
     .elp_out(elprt_51),.match(root_match[50]));

wire [71:0] elprt_52;
error_loc_poly_roots elpr51 (.elp_in(elprt_51),
     .elp_out(elprt_52),.match(root_match[51]));

wire [71:0] elprt_53;
error_loc_poly_roots elpr52 (.elp_in(elprt_52),
     .elp_out(elprt_53),.match(root_match[52]));

wire [71:0] elprt_54;
error_loc_poly_roots elpr53 (.elp_in(elprt_53),
     .elp_out(elprt_54),.match(root_match[53]));

wire [71:0] elprt_55;
error_loc_poly_roots elpr54 (.elp_in(elprt_54),
     .elp_out(elprt_55),.match(root_match[54]));

wire [71:0] elprt_56;
error_loc_poly_roots elpr55 (.elp_in(elprt_55),
     .elp_out(elprt_56),.match(root_match[55]));

wire [71:0] elprt_57;
error_loc_poly_roots elpr56 (.elp_in(elprt_56),
     .elp_out(elprt_57),.match(root_match[56]));

wire [71:0] elprt_58;
error_loc_poly_roots elpr57 (.elp_in(elprt_57),
     .elp_out(elprt_58),.match(root_match[57]));

wire [71:0] elprt_59;
error_loc_poly_roots elpr58 (.elp_in(elprt_58),
     .elp_out(elprt_59),.match(root_match[58]));

wire [71:0] elprt_60;
error_loc_poly_roots elpr59 (.elp_in(elprt_59),
     .elp_out(elprt_60),.match(root_match[59]));

wire [71:0] elprt_61;
error_loc_poly_roots elpr60 (.elp_in(elprt_60),
     .elp_out(elprt_61),.match(root_match[60]));

wire [71:0] elprt_62;
error_loc_poly_roots elpr61 (.elp_in(elprt_61),
     .elp_out(elprt_62),.match(root_match[61]));

wire [71:0] elprt_63;
error_loc_poly_roots elpr62 (.elp_in(elprt_62),
     .elp_out(elprt_63),.match(root_match[62]));

wire [71:0] elprt_64;
error_loc_poly_roots elpr63 (.elp_in(elprt_63),
     .elp_out(elprt_64),.match(root_match[63]));

wire [71:0] elprt_65;
error_loc_poly_roots elpr64 (.elp_in(elprt_64),
     .elp_out(elprt_65),.match(root_match[64]));

wire [71:0] elprt_66;
error_loc_poly_roots elpr65 (.elp_in(elprt_65),
     .elp_out(elprt_66),.match(root_match[65]));

wire [71:0] elprt_67;
error_loc_poly_roots elpr66 (.elp_in(elprt_66),
     .elp_out(elprt_67),.match(root_match[66]));

wire [71:0] elprt_68;
error_loc_poly_roots elpr67 (.elp_in(elprt_67),
     .elp_out(elprt_68),.match(root_match[67]));

wire [71:0] elprt_69;
error_loc_poly_roots elpr68 (.elp_in(elprt_68),
     .elp_out(elprt_69),.match(root_match[68]));

wire [71:0] elprt_70;
error_loc_poly_roots elpr69 (.elp_in(elprt_69),
     .elp_out(elprt_70),.match(root_match[69]));

wire [71:0] elprt_71;
error_loc_poly_roots elpr70 (.elp_in(elprt_70),
     .elp_out(elprt_71),.match(root_match[70]));

wire [71:0] elprt_72;
error_loc_poly_roots elpr71 (.elp_in(elprt_71),
     .elp_out(elprt_72),.match(root_match[71]));

wire [71:0] elprt_73;
error_loc_poly_roots elpr72 (.elp_in(elprt_72),
     .elp_out(elprt_73),.match(root_match[72]));

wire [71:0] elprt_74;
error_loc_poly_roots elpr73 (.elp_in(elprt_73),
     .elp_out(elprt_74),.match(root_match[73]));

wire [71:0] elprt_75;
error_loc_poly_roots elpr74 (.elp_in(elprt_74),
     .elp_out(elprt_75),.match(root_match[74]));

wire [71:0] elprt_76;
error_loc_poly_roots elpr75 (.elp_in(elprt_75),
     .elp_out(elprt_76),.match(root_match[75]));

wire [71:0] elprt_77;
error_loc_poly_roots elpr76 (.elp_in(elprt_76),
     .elp_out(elprt_77),.match(root_match[76]));

wire [71:0] elprt_78;
error_loc_poly_roots elpr77 (.elp_in(elprt_77),
     .elp_out(elprt_78),.match(root_match[77]));

wire [71:0] elprt_79;
error_loc_poly_roots elpr78 (.elp_in(elprt_78),
     .elp_out(elprt_79),.match(root_match[78]));

wire [71:0] elprt_80;
error_loc_poly_roots elpr79 (.elp_in(elprt_79),
     .elp_out(elprt_80),.match(root_match[79]));

wire [71:0] elprt_81;
error_loc_poly_roots elpr80 (.elp_in(elprt_80),
     .elp_out(elprt_81),.match(root_match[80]));

wire [71:0] elprt_82;
error_loc_poly_roots elpr81 (.elp_in(elprt_81),
     .elp_out(elprt_82),.match(root_match[81]));

wire [71:0] elprt_83;
error_loc_poly_roots elpr82 (.elp_in(elprt_82),
     .elp_out(elprt_83),.match(root_match[82]));

wire [71:0] elprt_84;
error_loc_poly_roots elpr83 (.elp_in(elprt_83),
     .elp_out(elprt_84),.match(root_match[83]));

wire [71:0] elprt_85;
error_loc_poly_roots elpr84 (.elp_in(elprt_84),
     .elp_out(elprt_85),.match(root_match[84]));

wire [71:0] elprt_86;
error_loc_poly_roots elpr85 (.elp_in(elprt_85),
     .elp_out(elprt_86),.match(root_match[85]));

wire [71:0] elprt_87;
error_loc_poly_roots elpr86 (.elp_in(elprt_86),
     .elp_out(elprt_87),.match(root_match[86]));

wire [71:0] elprt_88;
error_loc_poly_roots elpr87 (.elp_in(elprt_87),
     .elp_out(elprt_88),.match(root_match[87]));

wire [71:0] elprt_89;
error_loc_poly_roots elpr88 (.elp_in(elprt_88),
     .elp_out(elprt_89),.match(root_match[88]));

wire [71:0] elprt_90;
error_loc_poly_roots elpr89 (.elp_in(elprt_89),
     .elp_out(elprt_90),.match(root_match[89]));

wire [71:0] elprt_91;
error_loc_poly_roots elpr90 (.elp_in(elprt_90),
     .elp_out(elprt_91),.match(root_match[90]));

wire [71:0] elprt_92;
error_loc_poly_roots elpr91 (.elp_in(elprt_91),
     .elp_out(elprt_92),.match(root_match[91]));

wire [71:0] elprt_93;
error_loc_poly_roots elpr92 (.elp_in(elprt_92),
     .elp_out(elprt_93),.match(root_match[92]));

wire [71:0] elprt_94;
error_loc_poly_roots elpr93 (.elp_in(elprt_93),
     .elp_out(elprt_94),.match(root_match[93]));

wire [71:0] elprt_95;
error_loc_poly_roots elpr94 (.elp_in(elprt_94),
     .elp_out(elprt_95),.match(root_match[94]));

wire [71:0] elprt_96;
error_loc_poly_roots elpr95 (.elp_in(elprt_95),
     .elp_out(elprt_96),.match(root_match[95]));

wire [71:0] elprt_97;
error_loc_poly_roots elpr96 (.elp_in(elprt_96),
     .elp_out(elprt_97),.match(root_match[96]));

wire [71:0] elprt_98;
error_loc_poly_roots elpr97 (.elp_in(elprt_97),
     .elp_out(elprt_98),.match(root_match[97]));

wire [71:0] elprt_99;
error_loc_poly_roots elpr98 (.elp_in(elprt_98),
     .elp_out(elprt_99),.match(root_match[98]));

wire [71:0] elprt_100;
error_loc_poly_roots elpr99 (.elp_in(elprt_99),
     .elp_out(elprt_100),.match(root_match[99]));

wire [71:0] elprt_101;
error_loc_poly_roots elpr100 (.elp_in(elprt_100),
     .elp_out(elprt_101),.match(root_match[100]));

wire [71:0] elprt_102;
error_loc_poly_roots elpr101 (.elp_in(elprt_101),
     .elp_out(elprt_102),.match(root_match[101]));

wire [71:0] elprt_103;
error_loc_poly_roots elpr102 (.elp_in(elprt_102),
     .elp_out(elprt_103),.match(root_match[102]));

wire [71:0] elprt_104;
error_loc_poly_roots elpr103 (.elp_in(elprt_103),
     .elp_out(elprt_104),.match(root_match[103]));

wire [71:0] elprt_105;
error_loc_poly_roots elpr104 (.elp_in(elprt_104),
     .elp_out(elprt_105),.match(root_match[104]));

wire [71:0] elprt_106;
error_loc_poly_roots elpr105 (.elp_in(elprt_105),
     .elp_out(elprt_106),.match(root_match[105]));

wire [71:0] elprt_107;
error_loc_poly_roots elpr106 (.elp_in(elprt_106),
     .elp_out(elprt_107),.match(root_match[106]));

wire [71:0] elprt_108;
error_loc_poly_roots elpr107 (.elp_in(elprt_107),
     .elp_out(elprt_108),.match(root_match[107]));

wire [71:0] elprt_109;
error_loc_poly_roots elpr108 (.elp_in(elprt_108),
     .elp_out(elprt_109),.match(root_match[108]));

wire [71:0] elprt_110;
error_loc_poly_roots elpr109 (.elp_in(elprt_109),
     .elp_out(elprt_110),.match(root_match[109]));

wire [71:0] elprt_111;
error_loc_poly_roots elpr110 (.elp_in(elprt_110),
     .elp_out(elprt_111),.match(root_match[110]));

wire [71:0] elprt_112;
error_loc_poly_roots elpr111 (.elp_in(elprt_111),
     .elp_out(elprt_112),.match(root_match[111]));

wire [71:0] elprt_113;
error_loc_poly_roots elpr112 (.elp_in(elprt_112),
     .elp_out(elprt_113),.match(root_match[112]));

wire [71:0] elprt_114;
error_loc_poly_roots elpr113 (.elp_in(elprt_113),
     .elp_out(elprt_114),.match(root_match[113]));

wire [71:0] elprt_115;
error_loc_poly_roots elpr114 (.elp_in(elprt_114),
     .elp_out(elprt_115),.match(root_match[114]));

wire [71:0] elprt_116;
error_loc_poly_roots elpr115 (.elp_in(elprt_115),
     .elp_out(elprt_116),.match(root_match[115]));

wire [71:0] elprt_117;
error_loc_poly_roots elpr116 (.elp_in(elprt_116),
     .elp_out(elprt_117),.match(root_match[116]));

wire [71:0] elprt_118;
error_loc_poly_roots elpr117 (.elp_in(elprt_117),
     .elp_out(elprt_118),.match(root_match[117]));

wire [71:0] elprt_119;
error_loc_poly_roots elpr118 (.elp_in(elprt_118),
     .elp_out(elprt_119),.match(root_match[118]));

wire [71:0] elprt_120;
error_loc_poly_roots elpr119 (.elp_in(elprt_119),
     .elp_out(elprt_120),.match(root_match[119]));

wire [71:0] elprt_121;
error_loc_poly_roots elpr120 (.elp_in(elprt_120),
     .elp_out(elprt_121),.match(root_match[120]));

wire [71:0] elprt_122;
error_loc_poly_roots elpr121 (.elp_in(elprt_121),
     .elp_out(elprt_122),.match(root_match[121]));

wire [71:0] elprt_123;
error_loc_poly_roots elpr122 (.elp_in(elprt_122),
     .elp_out(elprt_123),.match(root_match[122]));

wire [71:0] elprt_124;
error_loc_poly_roots elpr123 (.elp_in(elprt_123),
     .elp_out(elprt_124),.match(root_match[123]));

wire [71:0] elprt_125;
error_loc_poly_roots elpr124 (.elp_in(elprt_124),
     .elp_out(elprt_125),.match(root_match[124]));

wire [71:0] elprt_126;
error_loc_poly_roots elpr125 (.elp_in(elprt_125),
     .elp_out(elprt_126),.match(root_match[125]));

wire [71:0] elprt_127;
error_loc_poly_roots elpr126 (.elp_in(elprt_126),
     .elp_out(elprt_127),.match(root_match[126]));

wire [71:0] elprt_128;
error_loc_poly_roots elpr127 (.elp_in(elprt_127),
     .elp_out(elprt_128),.match(root_match[127]));

wire [71:0] elprt_129;
error_loc_poly_roots elpr128 (.elp_in(elprt_128),
     .elp_out(elprt_129),.match(root_match[128]));

wire [71:0] elprt_130;
error_loc_poly_roots elpr129 (.elp_in(elprt_129),
     .elp_out(elprt_130),.match(root_match[129]));

wire [71:0] elprt_131;
error_loc_poly_roots elpr130 (.elp_in(elprt_130),
     .elp_out(elprt_131),.match(root_match[130]));

wire [71:0] elprt_132;
error_loc_poly_roots elpr131 (.elp_in(elprt_131),
     .elp_out(elprt_132),.match(root_match[131]));

wire [71:0] elprt_133;
error_loc_poly_roots elpr132 (.elp_in(elprt_132),
     .elp_out(elprt_133),.match(root_match[132]));

wire [71:0] elprt_134;
error_loc_poly_roots elpr133 (.elp_in(elprt_133),
     .elp_out(elprt_134),.match(root_match[133]));

wire [71:0] elprt_135;
error_loc_poly_roots elpr134 (.elp_in(elprt_134),
     .elp_out(elprt_135),.match(root_match[134]));

wire [71:0] elprt_136;
error_loc_poly_roots elpr135 (.elp_in(elprt_135),
     .elp_out(elprt_136),.match(root_match[135]));

wire [71:0] elprt_137;
error_loc_poly_roots elpr136 (.elp_in(elprt_136),
     .elp_out(elprt_137),.match(root_match[136]));

wire [71:0] elprt_138;
error_loc_poly_roots elpr137 (.elp_in(elprt_137),
     .elp_out(elprt_138),.match(root_match[137]));

wire [71:0] elprt_139;
error_loc_poly_roots elpr138 (.elp_in(elprt_138),
     .elp_out(elprt_139),.match(root_match[138]));

wire [71:0] elprt_140;
error_loc_poly_roots elpr139 (.elp_in(elprt_139),
     .elp_out(elprt_140),.match(root_match[139]));

wire [71:0] elprt_141;
error_loc_poly_roots elpr140 (.elp_in(elprt_140),
     .elp_out(elprt_141),.match(root_match[140]));

wire [71:0] elprt_142;
error_loc_poly_roots elpr141 (.elp_in(elprt_141),
     .elp_out(elprt_142),.match(root_match[141]));

wire [71:0] elprt_143;
error_loc_poly_roots elpr142 (.elp_in(elprt_142),
     .elp_out(elprt_143),.match(root_match[142]));

wire [71:0] elprt_144;
error_loc_poly_roots elpr143 (.elp_in(elprt_143),
     .elp_out(elprt_144),.match(root_match[143]));

wire [71:0] elprt_145;
error_loc_poly_roots elpr144 (.elp_in(elprt_144),
     .elp_out(elprt_145),.match(root_match[144]));

wire [71:0] elprt_146;
error_loc_poly_roots elpr145 (.elp_in(elprt_145),
     .elp_out(elprt_146),.match(root_match[145]));

wire [71:0] elprt_147;
error_loc_poly_roots elpr146 (.elp_in(elprt_146),
     .elp_out(elprt_147),.match(root_match[146]));

wire [71:0] elprt_148;
error_loc_poly_roots elpr147 (.elp_in(elprt_147),
     .elp_out(elprt_148),.match(root_match[147]));

wire [71:0] elprt_149;
error_loc_poly_roots elpr148 (.elp_in(elprt_148),
     .elp_out(elprt_149),.match(root_match[148]));

wire [71:0] elprt_150;
error_loc_poly_roots elpr149 (.elp_in(elprt_149),
     .elp_out(elprt_150),.match(root_match[149]));

wire [71:0] elprt_151;
error_loc_poly_roots elpr150 (.elp_in(elprt_150),
     .elp_out(elprt_151),.match(root_match[150]));

wire [71:0] elprt_152;
error_loc_poly_roots elpr151 (.elp_in(elprt_151),
     .elp_out(elprt_152),.match(root_match[151]));

wire [71:0] elprt_153;
error_loc_poly_roots elpr152 (.elp_in(elprt_152),
     .elp_out(elprt_153),.match(root_match[152]));

wire [71:0] elprt_154;
error_loc_poly_roots elpr153 (.elp_in(elprt_153),
     .elp_out(elprt_154),.match(root_match[153]));

wire [71:0] elprt_155;
error_loc_poly_roots elpr154 (.elp_in(elprt_154),
     .elp_out(elprt_155),.match(root_match[154]));

wire [71:0] elprt_156;
error_loc_poly_roots elpr155 (.elp_in(elprt_155),
     .elp_out(elprt_156),.match(root_match[155]));

wire [71:0] elprt_157;
error_loc_poly_roots elpr156 (.elp_in(elprt_156),
     .elp_out(elprt_157),.match(root_match[156]));

wire [71:0] elprt_158;
error_loc_poly_roots elpr157 (.elp_in(elprt_157),
     .elp_out(elprt_158),.match(root_match[157]));

wire [71:0] elprt_159;
error_loc_poly_roots elpr158 (.elp_in(elprt_158),
     .elp_out(elprt_159),.match(root_match[158]));

wire [71:0] elprt_160;
error_loc_poly_roots elpr159 (.elp_in(elprt_159),
     .elp_out(elprt_160),.match(root_match[159]));

wire [71:0] elprt_161;
error_loc_poly_roots elpr160 (.elp_in(elprt_160),
     .elp_out(elprt_161),.match(root_match[160]));

wire [71:0] elprt_162;
error_loc_poly_roots elpr161 (.elp_in(elprt_161),
     .elp_out(elprt_162),.match(root_match[161]));

wire [71:0] elprt_163;
error_loc_poly_roots elpr162 (.elp_in(elprt_162),
     .elp_out(elprt_163),.match(root_match[162]));

wire [71:0] elprt_164;
error_loc_poly_roots elpr163 (.elp_in(elprt_163),
     .elp_out(elprt_164),.match(root_match[163]));

wire [71:0] elprt_165;
error_loc_poly_roots elpr164 (.elp_in(elprt_164),
     .elp_out(elprt_165),.match(root_match[164]));

wire [71:0] elprt_166;
error_loc_poly_roots elpr165 (.elp_in(elprt_165),
     .elp_out(elprt_166),.match(root_match[165]));

wire [71:0] elprt_167;
error_loc_poly_roots elpr166 (.elp_in(elprt_166),
     .elp_out(elprt_167),.match(root_match[166]));

wire [71:0] elprt_168;
error_loc_poly_roots elpr167 (.elp_in(elprt_167),
     .elp_out(elprt_168),.match(root_match[167]));

wire [71:0] elprt_169;
error_loc_poly_roots elpr168 (.elp_in(elprt_168),
     .elp_out(elprt_169),.match(root_match[168]));

wire [71:0] elprt_170;
error_loc_poly_roots elpr169 (.elp_in(elprt_169),
     .elp_out(elprt_170),.match(root_match[169]));

wire [71:0] elprt_171;
error_loc_poly_roots elpr170 (.elp_in(elprt_170),
     .elp_out(elprt_171),.match(root_match[170]));

wire [71:0] elprt_172;
error_loc_poly_roots elpr171 (.elp_in(elprt_171),
     .elp_out(elprt_172),.match(root_match[171]));

wire [71:0] elprt_173;
error_loc_poly_roots elpr172 (.elp_in(elprt_172),
     .elp_out(elprt_173),.match(root_match[172]));

wire [71:0] elprt_174;
error_loc_poly_roots elpr173 (.elp_in(elprt_173),
     .elp_out(elprt_174),.match(root_match[173]));

wire [71:0] elprt_175;
error_loc_poly_roots elpr174 (.elp_in(elprt_174),
     .elp_out(elprt_175),.match(root_match[174]));

wire [71:0] elprt_176;
error_loc_poly_roots elpr175 (.elp_in(elprt_175),
     .elp_out(elprt_176),.match(root_match[175]));

wire [71:0] elprt_177;
error_loc_poly_roots elpr176 (.elp_in(elprt_176),
     .elp_out(elprt_177),.match(root_match[176]));

wire [71:0] elprt_178;
error_loc_poly_roots elpr177 (.elp_in(elprt_177),
     .elp_out(elprt_178),.match(root_match[177]));

wire [71:0] elprt_179;
error_loc_poly_roots elpr178 (.elp_in(elprt_178),
     .elp_out(elprt_179),.match(root_match[178]));

wire [71:0] elprt_180;
error_loc_poly_roots elpr179 (.elp_in(elprt_179),
     .elp_out(elprt_180),.match(root_match[179]));

wire [71:0] elprt_181;
error_loc_poly_roots elpr180 (.elp_in(elprt_180),
     .elp_out(elprt_181),.match(root_match[180]));

wire [71:0] elprt_182;
error_loc_poly_roots elpr181 (.elp_in(elprt_181),
     .elp_out(elprt_182),.match(root_match[181]));

wire [71:0] elprt_183;
error_loc_poly_roots elpr182 (.elp_in(elprt_182),
     .elp_out(elprt_183),.match(root_match[182]));

wire [71:0] elprt_184;
error_loc_poly_roots elpr183 (.elp_in(elprt_183),
     .elp_out(elprt_184),.match(root_match[183]));

wire [71:0] elprt_185;
error_loc_poly_roots elpr184 (.elp_in(elprt_184),
     .elp_out(elprt_185),.match(root_match[184]));

wire [71:0] elprt_186;
error_loc_poly_roots elpr185 (.elp_in(elprt_185),
     .elp_out(elprt_186),.match(root_match[185]));

wire [71:0] elprt_187;
error_loc_poly_roots elpr186 (.elp_in(elprt_186),
     .elp_out(elprt_187),.match(root_match[186]));

wire [71:0] elprt_188;
error_loc_poly_roots elpr187 (.elp_in(elprt_187),
     .elp_out(elprt_188),.match(root_match[187]));

wire [71:0] elprt_189;
error_loc_poly_roots elpr188 (.elp_in(elprt_188),
     .elp_out(elprt_189),.match(root_match[188]));

wire [71:0] elprt_190;
error_loc_poly_roots elpr189 (.elp_in(elprt_189),
     .elp_out(elprt_190),.match(root_match[189]));

wire [71:0] elprt_191;
error_loc_poly_roots elpr190 (.elp_in(elprt_190),
     .elp_out(elprt_191),.match(root_match[190]));

wire [71:0] elprt_192;
error_loc_poly_roots elpr191 (.elp_in(elprt_191),
     .elp_out(elprt_192),.match(root_match[191]));

wire [71:0] elprt_193;
error_loc_poly_roots elpr192 (.elp_in(elprt_192),
     .elp_out(elprt_193),.match(root_match[192]));

wire [71:0] elprt_194;
error_loc_poly_roots elpr193 (.elp_in(elprt_193),
     .elp_out(elprt_194),.match(root_match[193]));

wire [71:0] elprt_195;
error_loc_poly_roots elpr194 (.elp_in(elprt_194),
     .elp_out(elprt_195),.match(root_match[194]));

wire [71:0] elprt_196;
error_loc_poly_roots elpr195 (.elp_in(elprt_195),
     .elp_out(elprt_196),.match(root_match[195]));

wire [71:0] elprt_197;
error_loc_poly_roots elpr196 (.elp_in(elprt_196),
     .elp_out(elprt_197),.match(root_match[196]));

wire [71:0] elprt_198;
error_loc_poly_roots elpr197 (.elp_in(elprt_197),
     .elp_out(elprt_198),.match(root_match[197]));

wire [71:0] elprt_199;
error_loc_poly_roots elpr198 (.elp_in(elprt_198),
     .elp_out(elprt_199),.match(root_match[198]));

wire [71:0] elprt_200;
error_loc_poly_roots elpr199 (.elp_in(elprt_199),
     .elp_out(elprt_200),.match(root_match[199]));

wire [71:0] elprt_201;
error_loc_poly_roots elpr200 (.elp_in(elprt_200),
     .elp_out(elprt_201),.match(root_match[200]));

wire [71:0] elprt_202;
error_loc_poly_roots elpr201 (.elp_in(elprt_201),
     .elp_out(elprt_202),.match(root_match[201]));

wire [71:0] elprt_203;
error_loc_poly_roots elpr202 (.elp_in(elprt_202),
     .elp_out(elprt_203),.match(root_match[202]));

wire [71:0] elprt_204;
error_loc_poly_roots elpr203 (.elp_in(elprt_203),
     .elp_out(elprt_204),.match(root_match[203]));

wire [71:0] elprt_205;
error_loc_poly_roots elpr204 (.elp_in(elprt_204),
     .elp_out(elprt_205),.match(root_match[204]));

wire [71:0] elprt_206;
error_loc_poly_roots elpr205 (.elp_in(elprt_205),
     .elp_out(elprt_206),.match(root_match[205]));

wire [71:0] elprt_207;
error_loc_poly_roots elpr206 (.elp_in(elprt_206),
     .elp_out(elprt_207),.match(root_match[206]));

wire [71:0] elprt_208;
error_loc_poly_roots elpr207 (.elp_in(elprt_207),
     .elp_out(elprt_208),.match(root_match[207]));

wire [71:0] elprt_209;
error_loc_poly_roots elpr208 (.elp_in(elprt_208),
     .elp_out(elprt_209),.match(root_match[208]));

wire [71:0] elprt_210;
error_loc_poly_roots elpr209 (.elp_in(elprt_209),
     .elp_out(elprt_210),.match(root_match[209]));

wire [71:0] elprt_211;
error_loc_poly_roots elpr210 (.elp_in(elprt_210),
     .elp_out(elprt_211),.match(root_match[210]));

wire [71:0] elprt_212;
error_loc_poly_roots elpr211 (.elp_in(elprt_211),
     .elp_out(elprt_212),.match(root_match[211]));

wire [71:0] elprt_213;
error_loc_poly_roots elpr212 (.elp_in(elprt_212),
     .elp_out(elprt_213),.match(root_match[212]));

wire [71:0] elprt_214;
error_loc_poly_roots elpr213 (.elp_in(elprt_213),
     .elp_out(elprt_214),.match(root_match[213]));

wire [71:0] elprt_215;
error_loc_poly_roots elpr214 (.elp_in(elprt_214),
     .elp_out(elprt_215),.match(root_match[214]));

wire [71:0] elprt_216;
error_loc_poly_roots elpr215 (.elp_in(elprt_215),
     .elp_out(elprt_216),.match(root_match[215]));

wire [71:0] elprt_217;
error_loc_poly_roots elpr216 (.elp_in(elprt_216),
     .elp_out(elprt_217),.match(root_match[216]));

wire [71:0] elprt_218;
error_loc_poly_roots elpr217 (.elp_in(elprt_217),
     .elp_out(elprt_218),.match(root_match[217]));

wire [71:0] elprt_219;
error_loc_poly_roots elpr218 (.elp_in(elprt_218),
     .elp_out(elprt_219),.match(root_match[218]));

wire [71:0] elprt_220;
error_loc_poly_roots elpr219 (.elp_in(elprt_219),
     .elp_out(elprt_220),.match(root_match[219]));

wire [71:0] elprt_221;
error_loc_poly_roots elpr220 (.elp_in(elprt_220),
     .elp_out(elprt_221),.match(root_match[220]));

wire [71:0] elprt_222;
error_loc_poly_roots elpr221 (.elp_in(elprt_221),
     .elp_out(elprt_222),.match(root_match[221]));

wire [71:0] elprt_223;
error_loc_poly_roots elpr222 (.elp_in(elprt_222),
     .elp_out(elprt_223),.match(root_match[222]));

wire [71:0] elprt_224;
error_loc_poly_roots elpr223 (.elp_in(elprt_223),
     .elp_out(elprt_224),.match(root_match[223]));

wire [71:0] elprt_225;
error_loc_poly_roots elpr224 (.elp_in(elprt_224),
     .elp_out(elprt_225),.match(root_match[224]));

wire [71:0] elprt_226;
error_loc_poly_roots elpr225 (.elp_in(elprt_225),
     .elp_out(elprt_226),.match(root_match[225]));

wire [71:0] elprt_227;
error_loc_poly_roots elpr226 (.elp_in(elprt_226),
     .elp_out(elprt_227),.match(root_match[226]));

wire [71:0] elprt_228;
error_loc_poly_roots elpr227 (.elp_in(elprt_227),
     .elp_out(elprt_228),.match(root_match[227]));

wire [71:0] elprt_229;
error_loc_poly_roots elpr228 (.elp_in(elprt_228),
     .elp_out(elprt_229),.match(root_match[228]));

wire [71:0] elprt_230;
error_loc_poly_roots elpr229 (.elp_in(elprt_229),
     .elp_out(elprt_230),.match(root_match[229]));

wire [71:0] elprt_231;
error_loc_poly_roots elpr230 (.elp_in(elprt_230),
     .elp_out(elprt_231),.match(root_match[230]));

wire [71:0] elprt_232;
error_loc_poly_roots elpr231 (.elp_in(elprt_231),
     .elp_out(elprt_232),.match(root_match[231]));

wire [71:0] elprt_233;
error_loc_poly_roots elpr232 (.elp_in(elprt_232),
     .elp_out(elprt_233),.match(root_match[232]));

wire [71:0] elprt_234;
error_loc_poly_roots elpr233 (.elp_in(elprt_233),
     .elp_out(elprt_234),.match(root_match[233]));

wire [71:0] elprt_235;
error_loc_poly_roots elpr234 (.elp_in(elprt_234),
     .elp_out(elprt_235),.match(root_match[234]));

wire [71:0] elprt_236;
error_loc_poly_roots elpr235 (.elp_in(elprt_235),
     .elp_out(elprt_236),.match(root_match[235]));

wire [71:0] elprt_237;
error_loc_poly_roots elpr236 (.elp_in(elprt_236),
     .elp_out(elprt_237),.match(root_match[236]));

wire [71:0] elprt_238;
error_loc_poly_roots elpr237 (.elp_in(elprt_237),
     .elp_out(elprt_238),.match(root_match[237]));

wire [71:0] elprt_239;
error_loc_poly_roots elpr238 (.elp_in(elprt_238),
     .elp_out(elprt_239),.match(root_match[238]));

wire [71:0] elprt_240;
error_loc_poly_roots elpr239 (.elp_in(elprt_239),
     .elp_out(elprt_240),.match(root_match[239]));

wire [71:0] elprt_241;
error_loc_poly_roots elpr240 (.elp_in(elprt_240),
     .elp_out(elprt_241),.match(root_match[240]));

wire [71:0] elprt_242;
error_loc_poly_roots elpr241 (.elp_in(elprt_241),
     .elp_out(elprt_242),.match(root_match[241]));

wire [71:0] elprt_243;
error_loc_poly_roots elpr242 (.elp_in(elprt_242),
     .elp_out(elprt_243),.match(root_match[242]));

wire [71:0] elprt_244;
error_loc_poly_roots elpr243 (.elp_in(elprt_243),
     .elp_out(elprt_244),.match(root_match[243]));

wire [71:0] elprt_245;
error_loc_poly_roots elpr244 (.elp_in(elprt_244),
     .elp_out(elprt_245),.match(root_match[244]));

wire [71:0] elprt_246;
error_loc_poly_roots elpr245 (.elp_in(elprt_245),
     .elp_out(elprt_246),.match(root_match[245]));

wire [71:0] elprt_247;
error_loc_poly_roots elpr246 (.elp_in(elprt_246),
     .elp_out(elprt_247),.match(root_match[246]));

wire [71:0] elprt_248;
error_loc_poly_roots elpr247 (.elp_in(elprt_247),
     .elp_out(elprt_248),.match(root_match[247]));

wire [71:0] elprt_249;
error_loc_poly_roots elpr248 (.elp_in(elprt_248),
     .elp_out(elprt_249),.match(root_match[248]));

wire [71:0] elprt_250;
error_loc_poly_roots elpr249 (.elp_in(elprt_249),
     .elp_out(elprt_250),.match(root_match[249]));

wire [71:0] elprt_251;
error_loc_poly_roots elpr250 (.elp_in(elprt_250),
     .elp_out(elprt_251),.match(root_match[250]));

wire [71:0] elprt_252;
error_loc_poly_roots elpr251 (.elp_in(elprt_251),
     .elp_out(elprt_252),.match(root_match[251]));

wire [71:0] elprt_253;
error_loc_poly_roots elpr252 (.elp_in(elprt_252),
     .elp_out(elprt_253),.match(root_match[252]));

wire [71:0] elprt_254;
error_loc_poly_roots elpr253 (.elp_in(elprt_253),
     .elp_out(elprt_254),.match(root_match[253]));

wire [71:0] elprt_255;
error_loc_poly_roots elpr254 (.elp_in(elprt_254),
     .elp_out(elprt_255),.match(root_match[254]));

//////////////////////////////
// Find the correction values
//////////////////////////////

wire [71:0] val_emp_0 = emp[71:0];
wire [2039:0] error_val;

wire [71:0] val_emp_1;
wire [7:0] sum_of_odds_1 =
     elprt_1[15:8] ^
     elprt_1[31:24] ^
     elprt_1[47:40] ^
     elprt_1[63:56];

error_value_round evr0 (.emp_in(val_emp_0),
     .emp_out(val_emp_1),
     .deriv_term(sum_of_odds_1),
     .error_pos(root_match[0]),
     .error_val(error_val[7:0]));

wire [71:0] val_emp_2;
wire [7:0] sum_of_odds_2 =
     elprt_2[15:8] ^
     elprt_2[31:24] ^
     elprt_2[47:40] ^
     elprt_2[63:56];

error_value_round evr1 (.emp_in(val_emp_1),
     .emp_out(val_emp_2),
     .deriv_term(sum_of_odds_2),
     .error_pos(root_match[1]),
     .error_val(error_val[15:8]));

wire [71:0] val_emp_3;
wire [7:0] sum_of_odds_3 =
     elprt_3[15:8] ^
     elprt_3[31:24] ^
     elprt_3[47:40] ^
     elprt_3[63:56];

error_value_round evr2 (.emp_in(val_emp_2),
     .emp_out(val_emp_3),
     .deriv_term(sum_of_odds_3),
     .error_pos(root_match[2]),
     .error_val(error_val[23:16]));

wire [71:0] val_emp_4;
wire [7:0] sum_of_odds_4 =
     elprt_4[15:8] ^
     elprt_4[31:24] ^
     elprt_4[47:40] ^
     elprt_4[63:56];

error_value_round evr3 (.emp_in(val_emp_3),
     .emp_out(val_emp_4),
     .deriv_term(sum_of_odds_4),
     .error_pos(root_match[3]),
     .error_val(error_val[31:24]));

wire [71:0] val_emp_5;
wire [7:0] sum_of_odds_5 =
     elprt_5[15:8] ^
     elprt_5[31:24] ^
     elprt_5[47:40] ^
     elprt_5[63:56];

error_value_round evr4 (.emp_in(val_emp_4),
     .emp_out(val_emp_5),
     .deriv_term(sum_of_odds_5),
     .error_pos(root_match[4]),
     .error_val(error_val[39:32]));

wire [71:0] val_emp_6;
wire [7:0] sum_of_odds_6 =
     elprt_6[15:8] ^
     elprt_6[31:24] ^
     elprt_6[47:40] ^
     elprt_6[63:56];

error_value_round evr5 (.emp_in(val_emp_5),
     .emp_out(val_emp_6),
     .deriv_term(sum_of_odds_6),
     .error_pos(root_match[5]),
     .error_val(error_val[47:40]));

wire [71:0] val_emp_7;
wire [7:0] sum_of_odds_7 =
     elprt_7[15:8] ^
     elprt_7[31:24] ^
     elprt_7[47:40] ^
     elprt_7[63:56];

error_value_round evr6 (.emp_in(val_emp_6),
     .emp_out(val_emp_7),
     .deriv_term(sum_of_odds_7),
     .error_pos(root_match[6]),
     .error_val(error_val[55:48]));

wire [71:0] val_emp_8;
wire [7:0] sum_of_odds_8 =
     elprt_8[15:8] ^
     elprt_8[31:24] ^
     elprt_8[47:40] ^
     elprt_8[63:56];

error_value_round evr7 (.emp_in(val_emp_7),
     .emp_out(val_emp_8),
     .deriv_term(sum_of_odds_8),
     .error_pos(root_match[7]),
     .error_val(error_val[63:56]));

wire [71:0] val_emp_9;
wire [7:0] sum_of_odds_9 =
     elprt_9[15:8] ^
     elprt_9[31:24] ^
     elprt_9[47:40] ^
     elprt_9[63:56];

error_value_round evr8 (.emp_in(val_emp_8),
     .emp_out(val_emp_9),
     .deriv_term(sum_of_odds_9),
     .error_pos(root_match[8]),
     .error_val(error_val[71:64]));

wire [71:0] val_emp_10;
wire [7:0] sum_of_odds_10 =
     elprt_10[15:8] ^
     elprt_10[31:24] ^
     elprt_10[47:40] ^
     elprt_10[63:56];

error_value_round evr9 (.emp_in(val_emp_9),
     .emp_out(val_emp_10),
     .deriv_term(sum_of_odds_10),
     .error_pos(root_match[9]),
     .error_val(error_val[79:72]));

wire [71:0] val_emp_11;
wire [7:0] sum_of_odds_11 =
     elprt_11[15:8] ^
     elprt_11[31:24] ^
     elprt_11[47:40] ^
     elprt_11[63:56];

error_value_round evr10 (.emp_in(val_emp_10),
     .emp_out(val_emp_11),
     .deriv_term(sum_of_odds_11),
     .error_pos(root_match[10]),
     .error_val(error_val[87:80]));

wire [71:0] val_emp_12;
wire [7:0] sum_of_odds_12 =
     elprt_12[15:8] ^
     elprt_12[31:24] ^
     elprt_12[47:40] ^
     elprt_12[63:56];

error_value_round evr11 (.emp_in(val_emp_11),
     .emp_out(val_emp_12),
     .deriv_term(sum_of_odds_12),
     .error_pos(root_match[11]),
     .error_val(error_val[95:88]));

wire [71:0] val_emp_13;
wire [7:0] sum_of_odds_13 =
     elprt_13[15:8] ^
     elprt_13[31:24] ^
     elprt_13[47:40] ^
     elprt_13[63:56];

error_value_round evr12 (.emp_in(val_emp_12),
     .emp_out(val_emp_13),
     .deriv_term(sum_of_odds_13),
     .error_pos(root_match[12]),
     .error_val(error_val[103:96]));

wire [71:0] val_emp_14;
wire [7:0] sum_of_odds_14 =
     elprt_14[15:8] ^
     elprt_14[31:24] ^
     elprt_14[47:40] ^
     elprt_14[63:56];

error_value_round evr13 (.emp_in(val_emp_13),
     .emp_out(val_emp_14),
     .deriv_term(sum_of_odds_14),
     .error_pos(root_match[13]),
     .error_val(error_val[111:104]));

wire [71:0] val_emp_15;
wire [7:0] sum_of_odds_15 =
     elprt_15[15:8] ^
     elprt_15[31:24] ^
     elprt_15[47:40] ^
     elprt_15[63:56];

error_value_round evr14 (.emp_in(val_emp_14),
     .emp_out(val_emp_15),
     .deriv_term(sum_of_odds_15),
     .error_pos(root_match[14]),
     .error_val(error_val[119:112]));

wire [71:0] val_emp_16;
wire [7:0] sum_of_odds_16 =
     elprt_16[15:8] ^
     elprt_16[31:24] ^
     elprt_16[47:40] ^
     elprt_16[63:56];

error_value_round evr15 (.emp_in(val_emp_15),
     .emp_out(val_emp_16),
     .deriv_term(sum_of_odds_16),
     .error_pos(root_match[15]),
     .error_val(error_val[127:120]));

wire [71:0] val_emp_17;
wire [7:0] sum_of_odds_17 =
     elprt_17[15:8] ^
     elprt_17[31:24] ^
     elprt_17[47:40] ^
     elprt_17[63:56];

error_value_round evr16 (.emp_in(val_emp_16),
     .emp_out(val_emp_17),
     .deriv_term(sum_of_odds_17),
     .error_pos(root_match[16]),
     .error_val(error_val[135:128]));

wire [71:0] val_emp_18;
wire [7:0] sum_of_odds_18 =
     elprt_18[15:8] ^
     elprt_18[31:24] ^
     elprt_18[47:40] ^
     elprt_18[63:56];

error_value_round evr17 (.emp_in(val_emp_17),
     .emp_out(val_emp_18),
     .deriv_term(sum_of_odds_18),
     .error_pos(root_match[17]),
     .error_val(error_val[143:136]));

wire [71:0] val_emp_19;
wire [7:0] sum_of_odds_19 =
     elprt_19[15:8] ^
     elprt_19[31:24] ^
     elprt_19[47:40] ^
     elprt_19[63:56];

error_value_round evr18 (.emp_in(val_emp_18),
     .emp_out(val_emp_19),
     .deriv_term(sum_of_odds_19),
     .error_pos(root_match[18]),
     .error_val(error_val[151:144]));

wire [71:0] val_emp_20;
wire [7:0] sum_of_odds_20 =
     elprt_20[15:8] ^
     elprt_20[31:24] ^
     elprt_20[47:40] ^
     elprt_20[63:56];

error_value_round evr19 (.emp_in(val_emp_19),
     .emp_out(val_emp_20),
     .deriv_term(sum_of_odds_20),
     .error_pos(root_match[19]),
     .error_val(error_val[159:152]));

wire [71:0] val_emp_21;
wire [7:0] sum_of_odds_21 =
     elprt_21[15:8] ^
     elprt_21[31:24] ^
     elprt_21[47:40] ^
     elprt_21[63:56];

error_value_round evr20 (.emp_in(val_emp_20),
     .emp_out(val_emp_21),
     .deriv_term(sum_of_odds_21),
     .error_pos(root_match[20]),
     .error_val(error_val[167:160]));

wire [71:0] val_emp_22;
wire [7:0] sum_of_odds_22 =
     elprt_22[15:8] ^
     elprt_22[31:24] ^
     elprt_22[47:40] ^
     elprt_22[63:56];

error_value_round evr21 (.emp_in(val_emp_21),
     .emp_out(val_emp_22),
     .deriv_term(sum_of_odds_22),
     .error_pos(root_match[21]),
     .error_val(error_val[175:168]));

wire [71:0] val_emp_23;
wire [7:0] sum_of_odds_23 =
     elprt_23[15:8] ^
     elprt_23[31:24] ^
     elprt_23[47:40] ^
     elprt_23[63:56];

error_value_round evr22 (.emp_in(val_emp_22),
     .emp_out(val_emp_23),
     .deriv_term(sum_of_odds_23),
     .error_pos(root_match[22]),
     .error_val(error_val[183:176]));

wire [71:0] val_emp_24;
wire [7:0] sum_of_odds_24 =
     elprt_24[15:8] ^
     elprt_24[31:24] ^
     elprt_24[47:40] ^
     elprt_24[63:56];

error_value_round evr23 (.emp_in(val_emp_23),
     .emp_out(val_emp_24),
     .deriv_term(sum_of_odds_24),
     .error_pos(root_match[23]),
     .error_val(error_val[191:184]));

wire [71:0] val_emp_25;
wire [7:0] sum_of_odds_25 =
     elprt_25[15:8] ^
     elprt_25[31:24] ^
     elprt_25[47:40] ^
     elprt_25[63:56];

error_value_round evr24 (.emp_in(val_emp_24),
     .emp_out(val_emp_25),
     .deriv_term(sum_of_odds_25),
     .error_pos(root_match[24]),
     .error_val(error_val[199:192]));

wire [71:0] val_emp_26;
wire [7:0] sum_of_odds_26 =
     elprt_26[15:8] ^
     elprt_26[31:24] ^
     elprt_26[47:40] ^
     elprt_26[63:56];

error_value_round evr25 (.emp_in(val_emp_25),
     .emp_out(val_emp_26),
     .deriv_term(sum_of_odds_26),
     .error_pos(root_match[25]),
     .error_val(error_val[207:200]));

wire [71:0] val_emp_27;
wire [7:0] sum_of_odds_27 =
     elprt_27[15:8] ^
     elprt_27[31:24] ^
     elprt_27[47:40] ^
     elprt_27[63:56];

error_value_round evr26 (.emp_in(val_emp_26),
     .emp_out(val_emp_27),
     .deriv_term(sum_of_odds_27),
     .error_pos(root_match[26]),
     .error_val(error_val[215:208]));

wire [71:0] val_emp_28;
wire [7:0] sum_of_odds_28 =
     elprt_28[15:8] ^
     elprt_28[31:24] ^
     elprt_28[47:40] ^
     elprt_28[63:56];

error_value_round evr27 (.emp_in(val_emp_27),
     .emp_out(val_emp_28),
     .deriv_term(sum_of_odds_28),
     .error_pos(root_match[27]),
     .error_val(error_val[223:216]));

wire [71:0] val_emp_29;
wire [7:0] sum_of_odds_29 =
     elprt_29[15:8] ^
     elprt_29[31:24] ^
     elprt_29[47:40] ^
     elprt_29[63:56];

error_value_round evr28 (.emp_in(val_emp_28),
     .emp_out(val_emp_29),
     .deriv_term(sum_of_odds_29),
     .error_pos(root_match[28]),
     .error_val(error_val[231:224]));

wire [71:0] val_emp_30;
wire [7:0] sum_of_odds_30 =
     elprt_30[15:8] ^
     elprt_30[31:24] ^
     elprt_30[47:40] ^
     elprt_30[63:56];

error_value_round evr29 (.emp_in(val_emp_29),
     .emp_out(val_emp_30),
     .deriv_term(sum_of_odds_30),
     .error_pos(root_match[29]),
     .error_val(error_val[239:232]));

wire [71:0] val_emp_31;
wire [7:0] sum_of_odds_31 =
     elprt_31[15:8] ^
     elprt_31[31:24] ^
     elprt_31[47:40] ^
     elprt_31[63:56];

error_value_round evr30 (.emp_in(val_emp_30),
     .emp_out(val_emp_31),
     .deriv_term(sum_of_odds_31),
     .error_pos(root_match[30]),
     .error_val(error_val[247:240]));

wire [71:0] val_emp_32;
wire [7:0] sum_of_odds_32 =
     elprt_32[15:8] ^
     elprt_32[31:24] ^
     elprt_32[47:40] ^
     elprt_32[63:56];

error_value_round evr31 (.emp_in(val_emp_31),
     .emp_out(val_emp_32),
     .deriv_term(sum_of_odds_32),
     .error_pos(root_match[31]),
     .error_val(error_val[255:248]));

wire [71:0] val_emp_33;
wire [7:0] sum_of_odds_33 =
     elprt_33[15:8] ^
     elprt_33[31:24] ^
     elprt_33[47:40] ^
     elprt_33[63:56];

error_value_round evr32 (.emp_in(val_emp_32),
     .emp_out(val_emp_33),
     .deriv_term(sum_of_odds_33),
     .error_pos(root_match[32]),
     .error_val(error_val[263:256]));

wire [71:0] val_emp_34;
wire [7:0] sum_of_odds_34 =
     elprt_34[15:8] ^
     elprt_34[31:24] ^
     elprt_34[47:40] ^
     elprt_34[63:56];

error_value_round evr33 (.emp_in(val_emp_33),
     .emp_out(val_emp_34),
     .deriv_term(sum_of_odds_34),
     .error_pos(root_match[33]),
     .error_val(error_val[271:264]));

wire [71:0] val_emp_35;
wire [7:0] sum_of_odds_35 =
     elprt_35[15:8] ^
     elprt_35[31:24] ^
     elprt_35[47:40] ^
     elprt_35[63:56];

error_value_round evr34 (.emp_in(val_emp_34),
     .emp_out(val_emp_35),
     .deriv_term(sum_of_odds_35),
     .error_pos(root_match[34]),
     .error_val(error_val[279:272]));

wire [71:0] val_emp_36;
wire [7:0] sum_of_odds_36 =
     elprt_36[15:8] ^
     elprt_36[31:24] ^
     elprt_36[47:40] ^
     elprt_36[63:56];

error_value_round evr35 (.emp_in(val_emp_35),
     .emp_out(val_emp_36),
     .deriv_term(sum_of_odds_36),
     .error_pos(root_match[35]),
     .error_val(error_val[287:280]));

wire [71:0] val_emp_37;
wire [7:0] sum_of_odds_37 =
     elprt_37[15:8] ^
     elprt_37[31:24] ^
     elprt_37[47:40] ^
     elprt_37[63:56];

error_value_round evr36 (.emp_in(val_emp_36),
     .emp_out(val_emp_37),
     .deriv_term(sum_of_odds_37),
     .error_pos(root_match[36]),
     .error_val(error_val[295:288]));

wire [71:0] val_emp_38;
wire [7:0] sum_of_odds_38 =
     elprt_38[15:8] ^
     elprt_38[31:24] ^
     elprt_38[47:40] ^
     elprt_38[63:56];

error_value_round evr37 (.emp_in(val_emp_37),
     .emp_out(val_emp_38),
     .deriv_term(sum_of_odds_38),
     .error_pos(root_match[37]),
     .error_val(error_val[303:296]));

wire [71:0] val_emp_39;
wire [7:0] sum_of_odds_39 =
     elprt_39[15:8] ^
     elprt_39[31:24] ^
     elprt_39[47:40] ^
     elprt_39[63:56];

error_value_round evr38 (.emp_in(val_emp_38),
     .emp_out(val_emp_39),
     .deriv_term(sum_of_odds_39),
     .error_pos(root_match[38]),
     .error_val(error_val[311:304]));

wire [71:0] val_emp_40;
wire [7:0] sum_of_odds_40 =
     elprt_40[15:8] ^
     elprt_40[31:24] ^
     elprt_40[47:40] ^
     elprt_40[63:56];

error_value_round evr39 (.emp_in(val_emp_39),
     .emp_out(val_emp_40),
     .deriv_term(sum_of_odds_40),
     .error_pos(root_match[39]),
     .error_val(error_val[319:312]));

wire [71:0] val_emp_41;
wire [7:0] sum_of_odds_41 =
     elprt_41[15:8] ^
     elprt_41[31:24] ^
     elprt_41[47:40] ^
     elprt_41[63:56];

error_value_round evr40 (.emp_in(val_emp_40),
     .emp_out(val_emp_41),
     .deriv_term(sum_of_odds_41),
     .error_pos(root_match[40]),
     .error_val(error_val[327:320]));

wire [71:0] val_emp_42;
wire [7:0] sum_of_odds_42 =
     elprt_42[15:8] ^
     elprt_42[31:24] ^
     elprt_42[47:40] ^
     elprt_42[63:56];

error_value_round evr41 (.emp_in(val_emp_41),
     .emp_out(val_emp_42),
     .deriv_term(sum_of_odds_42),
     .error_pos(root_match[41]),
     .error_val(error_val[335:328]));

wire [71:0] val_emp_43;
wire [7:0] sum_of_odds_43 =
     elprt_43[15:8] ^
     elprt_43[31:24] ^
     elprt_43[47:40] ^
     elprt_43[63:56];

error_value_round evr42 (.emp_in(val_emp_42),
     .emp_out(val_emp_43),
     .deriv_term(sum_of_odds_43),
     .error_pos(root_match[42]),
     .error_val(error_val[343:336]));

wire [71:0] val_emp_44;
wire [7:0] sum_of_odds_44 =
     elprt_44[15:8] ^
     elprt_44[31:24] ^
     elprt_44[47:40] ^
     elprt_44[63:56];

error_value_round evr43 (.emp_in(val_emp_43),
     .emp_out(val_emp_44),
     .deriv_term(sum_of_odds_44),
     .error_pos(root_match[43]),
     .error_val(error_val[351:344]));

wire [71:0] val_emp_45;
wire [7:0] sum_of_odds_45 =
     elprt_45[15:8] ^
     elprt_45[31:24] ^
     elprt_45[47:40] ^
     elprt_45[63:56];

error_value_round evr44 (.emp_in(val_emp_44),
     .emp_out(val_emp_45),
     .deriv_term(sum_of_odds_45),
     .error_pos(root_match[44]),
     .error_val(error_val[359:352]));

wire [71:0] val_emp_46;
wire [7:0] sum_of_odds_46 =
     elprt_46[15:8] ^
     elprt_46[31:24] ^
     elprt_46[47:40] ^
     elprt_46[63:56];

error_value_round evr45 (.emp_in(val_emp_45),
     .emp_out(val_emp_46),
     .deriv_term(sum_of_odds_46),
     .error_pos(root_match[45]),
     .error_val(error_val[367:360]));

wire [71:0] val_emp_47;
wire [7:0] sum_of_odds_47 =
     elprt_47[15:8] ^
     elprt_47[31:24] ^
     elprt_47[47:40] ^
     elprt_47[63:56];

error_value_round evr46 (.emp_in(val_emp_46),
     .emp_out(val_emp_47),
     .deriv_term(sum_of_odds_47),
     .error_pos(root_match[46]),
     .error_val(error_val[375:368]));

wire [71:0] val_emp_48;
wire [7:0] sum_of_odds_48 =
     elprt_48[15:8] ^
     elprt_48[31:24] ^
     elprt_48[47:40] ^
     elprt_48[63:56];

error_value_round evr47 (.emp_in(val_emp_47),
     .emp_out(val_emp_48),
     .deriv_term(sum_of_odds_48),
     .error_pos(root_match[47]),
     .error_val(error_val[383:376]));

wire [71:0] val_emp_49;
wire [7:0] sum_of_odds_49 =
     elprt_49[15:8] ^
     elprt_49[31:24] ^
     elprt_49[47:40] ^
     elprt_49[63:56];

error_value_round evr48 (.emp_in(val_emp_48),
     .emp_out(val_emp_49),
     .deriv_term(sum_of_odds_49),
     .error_pos(root_match[48]),
     .error_val(error_val[391:384]));

wire [71:0] val_emp_50;
wire [7:0] sum_of_odds_50 =
     elprt_50[15:8] ^
     elprt_50[31:24] ^
     elprt_50[47:40] ^
     elprt_50[63:56];

error_value_round evr49 (.emp_in(val_emp_49),
     .emp_out(val_emp_50),
     .deriv_term(sum_of_odds_50),
     .error_pos(root_match[49]),
     .error_val(error_val[399:392]));

wire [71:0] val_emp_51;
wire [7:0] sum_of_odds_51 =
     elprt_51[15:8] ^
     elprt_51[31:24] ^
     elprt_51[47:40] ^
     elprt_51[63:56];

error_value_round evr50 (.emp_in(val_emp_50),
     .emp_out(val_emp_51),
     .deriv_term(sum_of_odds_51),
     .error_pos(root_match[50]),
     .error_val(error_val[407:400]));

wire [71:0] val_emp_52;
wire [7:0] sum_of_odds_52 =
     elprt_52[15:8] ^
     elprt_52[31:24] ^
     elprt_52[47:40] ^
     elprt_52[63:56];

error_value_round evr51 (.emp_in(val_emp_51),
     .emp_out(val_emp_52),
     .deriv_term(sum_of_odds_52),
     .error_pos(root_match[51]),
     .error_val(error_val[415:408]));

wire [71:0] val_emp_53;
wire [7:0] sum_of_odds_53 =
     elprt_53[15:8] ^
     elprt_53[31:24] ^
     elprt_53[47:40] ^
     elprt_53[63:56];

error_value_round evr52 (.emp_in(val_emp_52),
     .emp_out(val_emp_53),
     .deriv_term(sum_of_odds_53),
     .error_pos(root_match[52]),
     .error_val(error_val[423:416]));

wire [71:0] val_emp_54;
wire [7:0] sum_of_odds_54 =
     elprt_54[15:8] ^
     elprt_54[31:24] ^
     elprt_54[47:40] ^
     elprt_54[63:56];

error_value_round evr53 (.emp_in(val_emp_53),
     .emp_out(val_emp_54),
     .deriv_term(sum_of_odds_54),
     .error_pos(root_match[53]),
     .error_val(error_val[431:424]));

wire [71:0] val_emp_55;
wire [7:0] sum_of_odds_55 =
     elprt_55[15:8] ^
     elprt_55[31:24] ^
     elprt_55[47:40] ^
     elprt_55[63:56];

error_value_round evr54 (.emp_in(val_emp_54),
     .emp_out(val_emp_55),
     .deriv_term(sum_of_odds_55),
     .error_pos(root_match[54]),
     .error_val(error_val[439:432]));

wire [71:0] val_emp_56;
wire [7:0] sum_of_odds_56 =
     elprt_56[15:8] ^
     elprt_56[31:24] ^
     elprt_56[47:40] ^
     elprt_56[63:56];

error_value_round evr55 (.emp_in(val_emp_55),
     .emp_out(val_emp_56),
     .deriv_term(sum_of_odds_56),
     .error_pos(root_match[55]),
     .error_val(error_val[447:440]));

wire [71:0] val_emp_57;
wire [7:0] sum_of_odds_57 =
     elprt_57[15:8] ^
     elprt_57[31:24] ^
     elprt_57[47:40] ^
     elprt_57[63:56];

error_value_round evr56 (.emp_in(val_emp_56),
     .emp_out(val_emp_57),
     .deriv_term(sum_of_odds_57),
     .error_pos(root_match[56]),
     .error_val(error_val[455:448]));

wire [71:0] val_emp_58;
wire [7:0] sum_of_odds_58 =
     elprt_58[15:8] ^
     elprt_58[31:24] ^
     elprt_58[47:40] ^
     elprt_58[63:56];

error_value_round evr57 (.emp_in(val_emp_57),
     .emp_out(val_emp_58),
     .deriv_term(sum_of_odds_58),
     .error_pos(root_match[57]),
     .error_val(error_val[463:456]));

wire [71:0] val_emp_59;
wire [7:0] sum_of_odds_59 =
     elprt_59[15:8] ^
     elprt_59[31:24] ^
     elprt_59[47:40] ^
     elprt_59[63:56];

error_value_round evr58 (.emp_in(val_emp_58),
     .emp_out(val_emp_59),
     .deriv_term(sum_of_odds_59),
     .error_pos(root_match[58]),
     .error_val(error_val[471:464]));

wire [71:0] val_emp_60;
wire [7:0] sum_of_odds_60 =
     elprt_60[15:8] ^
     elprt_60[31:24] ^
     elprt_60[47:40] ^
     elprt_60[63:56];

error_value_round evr59 (.emp_in(val_emp_59),
     .emp_out(val_emp_60),
     .deriv_term(sum_of_odds_60),
     .error_pos(root_match[59]),
     .error_val(error_val[479:472]));

wire [71:0] val_emp_61;
wire [7:0] sum_of_odds_61 =
     elprt_61[15:8] ^
     elprt_61[31:24] ^
     elprt_61[47:40] ^
     elprt_61[63:56];

error_value_round evr60 (.emp_in(val_emp_60),
     .emp_out(val_emp_61),
     .deriv_term(sum_of_odds_61),
     .error_pos(root_match[60]),
     .error_val(error_val[487:480]));

wire [71:0] val_emp_62;
wire [7:0] sum_of_odds_62 =
     elprt_62[15:8] ^
     elprt_62[31:24] ^
     elprt_62[47:40] ^
     elprt_62[63:56];

error_value_round evr61 (.emp_in(val_emp_61),
     .emp_out(val_emp_62),
     .deriv_term(sum_of_odds_62),
     .error_pos(root_match[61]),
     .error_val(error_val[495:488]));

wire [71:0] val_emp_63;
wire [7:0] sum_of_odds_63 =
     elprt_63[15:8] ^
     elprt_63[31:24] ^
     elprt_63[47:40] ^
     elprt_63[63:56];

error_value_round evr62 (.emp_in(val_emp_62),
     .emp_out(val_emp_63),
     .deriv_term(sum_of_odds_63),
     .error_pos(root_match[62]),
     .error_val(error_val[503:496]));

wire [71:0] val_emp_64;
wire [7:0] sum_of_odds_64 =
     elprt_64[15:8] ^
     elprt_64[31:24] ^
     elprt_64[47:40] ^
     elprt_64[63:56];

error_value_round evr63 (.emp_in(val_emp_63),
     .emp_out(val_emp_64),
     .deriv_term(sum_of_odds_64),
     .error_pos(root_match[63]),
     .error_val(error_val[511:504]));

wire [71:0] val_emp_65;
wire [7:0] sum_of_odds_65 =
     elprt_65[15:8] ^
     elprt_65[31:24] ^
     elprt_65[47:40] ^
     elprt_65[63:56];

error_value_round evr64 (.emp_in(val_emp_64),
     .emp_out(val_emp_65),
     .deriv_term(sum_of_odds_65),
     .error_pos(root_match[64]),
     .error_val(error_val[519:512]));

wire [71:0] val_emp_66;
wire [7:0] sum_of_odds_66 =
     elprt_66[15:8] ^
     elprt_66[31:24] ^
     elprt_66[47:40] ^
     elprt_66[63:56];

error_value_round evr65 (.emp_in(val_emp_65),
     .emp_out(val_emp_66),
     .deriv_term(sum_of_odds_66),
     .error_pos(root_match[65]),
     .error_val(error_val[527:520]));

wire [71:0] val_emp_67;
wire [7:0] sum_of_odds_67 =
     elprt_67[15:8] ^
     elprt_67[31:24] ^
     elprt_67[47:40] ^
     elprt_67[63:56];

error_value_round evr66 (.emp_in(val_emp_66),
     .emp_out(val_emp_67),
     .deriv_term(sum_of_odds_67),
     .error_pos(root_match[66]),
     .error_val(error_val[535:528]));

wire [71:0] val_emp_68;
wire [7:0] sum_of_odds_68 =
     elprt_68[15:8] ^
     elprt_68[31:24] ^
     elprt_68[47:40] ^
     elprt_68[63:56];

error_value_round evr67 (.emp_in(val_emp_67),
     .emp_out(val_emp_68),
     .deriv_term(sum_of_odds_68),
     .error_pos(root_match[67]),
     .error_val(error_val[543:536]));

wire [71:0] val_emp_69;
wire [7:0] sum_of_odds_69 =
     elprt_69[15:8] ^
     elprt_69[31:24] ^
     elprt_69[47:40] ^
     elprt_69[63:56];

error_value_round evr68 (.emp_in(val_emp_68),
     .emp_out(val_emp_69),
     .deriv_term(sum_of_odds_69),
     .error_pos(root_match[68]),
     .error_val(error_val[551:544]));

wire [71:0] val_emp_70;
wire [7:0] sum_of_odds_70 =
     elprt_70[15:8] ^
     elprt_70[31:24] ^
     elprt_70[47:40] ^
     elprt_70[63:56];

error_value_round evr69 (.emp_in(val_emp_69),
     .emp_out(val_emp_70),
     .deriv_term(sum_of_odds_70),
     .error_pos(root_match[69]),
     .error_val(error_val[559:552]));

wire [71:0] val_emp_71;
wire [7:0] sum_of_odds_71 =
     elprt_71[15:8] ^
     elprt_71[31:24] ^
     elprt_71[47:40] ^
     elprt_71[63:56];

error_value_round evr70 (.emp_in(val_emp_70),
     .emp_out(val_emp_71),
     .deriv_term(sum_of_odds_71),
     .error_pos(root_match[70]),
     .error_val(error_val[567:560]));

wire [71:0] val_emp_72;
wire [7:0] sum_of_odds_72 =
     elprt_72[15:8] ^
     elprt_72[31:24] ^
     elprt_72[47:40] ^
     elprt_72[63:56];

error_value_round evr71 (.emp_in(val_emp_71),
     .emp_out(val_emp_72),
     .deriv_term(sum_of_odds_72),
     .error_pos(root_match[71]),
     .error_val(error_val[575:568]));

wire [71:0] val_emp_73;
wire [7:0] sum_of_odds_73 =
     elprt_73[15:8] ^
     elprt_73[31:24] ^
     elprt_73[47:40] ^
     elprt_73[63:56];

error_value_round evr72 (.emp_in(val_emp_72),
     .emp_out(val_emp_73),
     .deriv_term(sum_of_odds_73),
     .error_pos(root_match[72]),
     .error_val(error_val[583:576]));

wire [71:0] val_emp_74;
wire [7:0] sum_of_odds_74 =
     elprt_74[15:8] ^
     elprt_74[31:24] ^
     elprt_74[47:40] ^
     elprt_74[63:56];

error_value_round evr73 (.emp_in(val_emp_73),
     .emp_out(val_emp_74),
     .deriv_term(sum_of_odds_74),
     .error_pos(root_match[73]),
     .error_val(error_val[591:584]));

wire [71:0] val_emp_75;
wire [7:0] sum_of_odds_75 =
     elprt_75[15:8] ^
     elprt_75[31:24] ^
     elprt_75[47:40] ^
     elprt_75[63:56];

error_value_round evr74 (.emp_in(val_emp_74),
     .emp_out(val_emp_75),
     .deriv_term(sum_of_odds_75),
     .error_pos(root_match[74]),
     .error_val(error_val[599:592]));

wire [71:0] val_emp_76;
wire [7:0] sum_of_odds_76 =
     elprt_76[15:8] ^
     elprt_76[31:24] ^
     elprt_76[47:40] ^
     elprt_76[63:56];

error_value_round evr75 (.emp_in(val_emp_75),
     .emp_out(val_emp_76),
     .deriv_term(sum_of_odds_76),
     .error_pos(root_match[75]),
     .error_val(error_val[607:600]));

wire [71:0] val_emp_77;
wire [7:0] sum_of_odds_77 =
     elprt_77[15:8] ^
     elprt_77[31:24] ^
     elprt_77[47:40] ^
     elprt_77[63:56];

error_value_round evr76 (.emp_in(val_emp_76),
     .emp_out(val_emp_77),
     .deriv_term(sum_of_odds_77),
     .error_pos(root_match[76]),
     .error_val(error_val[615:608]));

wire [71:0] val_emp_78;
wire [7:0] sum_of_odds_78 =
     elprt_78[15:8] ^
     elprt_78[31:24] ^
     elprt_78[47:40] ^
     elprt_78[63:56];

error_value_round evr77 (.emp_in(val_emp_77),
     .emp_out(val_emp_78),
     .deriv_term(sum_of_odds_78),
     .error_pos(root_match[77]),
     .error_val(error_val[623:616]));

wire [71:0] val_emp_79;
wire [7:0] sum_of_odds_79 =
     elprt_79[15:8] ^
     elprt_79[31:24] ^
     elprt_79[47:40] ^
     elprt_79[63:56];

error_value_round evr78 (.emp_in(val_emp_78),
     .emp_out(val_emp_79),
     .deriv_term(sum_of_odds_79),
     .error_pos(root_match[78]),
     .error_val(error_val[631:624]));

wire [71:0] val_emp_80;
wire [7:0] sum_of_odds_80 =
     elprt_80[15:8] ^
     elprt_80[31:24] ^
     elprt_80[47:40] ^
     elprt_80[63:56];

error_value_round evr79 (.emp_in(val_emp_79),
     .emp_out(val_emp_80),
     .deriv_term(sum_of_odds_80),
     .error_pos(root_match[79]),
     .error_val(error_val[639:632]));

wire [71:0] val_emp_81;
wire [7:0] sum_of_odds_81 =
     elprt_81[15:8] ^
     elprt_81[31:24] ^
     elprt_81[47:40] ^
     elprt_81[63:56];

error_value_round evr80 (.emp_in(val_emp_80),
     .emp_out(val_emp_81),
     .deriv_term(sum_of_odds_81),
     .error_pos(root_match[80]),
     .error_val(error_val[647:640]));

wire [71:0] val_emp_82;
wire [7:0] sum_of_odds_82 =
     elprt_82[15:8] ^
     elprt_82[31:24] ^
     elprt_82[47:40] ^
     elprt_82[63:56];

error_value_round evr81 (.emp_in(val_emp_81),
     .emp_out(val_emp_82),
     .deriv_term(sum_of_odds_82),
     .error_pos(root_match[81]),
     .error_val(error_val[655:648]));

wire [71:0] val_emp_83;
wire [7:0] sum_of_odds_83 =
     elprt_83[15:8] ^
     elprt_83[31:24] ^
     elprt_83[47:40] ^
     elprt_83[63:56];

error_value_round evr82 (.emp_in(val_emp_82),
     .emp_out(val_emp_83),
     .deriv_term(sum_of_odds_83),
     .error_pos(root_match[82]),
     .error_val(error_val[663:656]));

wire [71:0] val_emp_84;
wire [7:0] sum_of_odds_84 =
     elprt_84[15:8] ^
     elprt_84[31:24] ^
     elprt_84[47:40] ^
     elprt_84[63:56];

error_value_round evr83 (.emp_in(val_emp_83),
     .emp_out(val_emp_84),
     .deriv_term(sum_of_odds_84),
     .error_pos(root_match[83]),
     .error_val(error_val[671:664]));

wire [71:0] val_emp_85;
wire [7:0] sum_of_odds_85 =
     elprt_85[15:8] ^
     elprt_85[31:24] ^
     elprt_85[47:40] ^
     elprt_85[63:56];

error_value_round evr84 (.emp_in(val_emp_84),
     .emp_out(val_emp_85),
     .deriv_term(sum_of_odds_85),
     .error_pos(root_match[84]),
     .error_val(error_val[679:672]));

wire [71:0] val_emp_86;
wire [7:0] sum_of_odds_86 =
     elprt_86[15:8] ^
     elprt_86[31:24] ^
     elprt_86[47:40] ^
     elprt_86[63:56];

error_value_round evr85 (.emp_in(val_emp_85),
     .emp_out(val_emp_86),
     .deriv_term(sum_of_odds_86),
     .error_pos(root_match[85]),
     .error_val(error_val[687:680]));

wire [71:0] val_emp_87;
wire [7:0] sum_of_odds_87 =
     elprt_87[15:8] ^
     elprt_87[31:24] ^
     elprt_87[47:40] ^
     elprt_87[63:56];

error_value_round evr86 (.emp_in(val_emp_86),
     .emp_out(val_emp_87),
     .deriv_term(sum_of_odds_87),
     .error_pos(root_match[86]),
     .error_val(error_val[695:688]));

wire [71:0] val_emp_88;
wire [7:0] sum_of_odds_88 =
     elprt_88[15:8] ^
     elprt_88[31:24] ^
     elprt_88[47:40] ^
     elprt_88[63:56];

error_value_round evr87 (.emp_in(val_emp_87),
     .emp_out(val_emp_88),
     .deriv_term(sum_of_odds_88),
     .error_pos(root_match[87]),
     .error_val(error_val[703:696]));

wire [71:0] val_emp_89;
wire [7:0] sum_of_odds_89 =
     elprt_89[15:8] ^
     elprt_89[31:24] ^
     elprt_89[47:40] ^
     elprt_89[63:56];

error_value_round evr88 (.emp_in(val_emp_88),
     .emp_out(val_emp_89),
     .deriv_term(sum_of_odds_89),
     .error_pos(root_match[88]),
     .error_val(error_val[711:704]));

wire [71:0] val_emp_90;
wire [7:0] sum_of_odds_90 =
     elprt_90[15:8] ^
     elprt_90[31:24] ^
     elprt_90[47:40] ^
     elprt_90[63:56];

error_value_round evr89 (.emp_in(val_emp_89),
     .emp_out(val_emp_90),
     .deriv_term(sum_of_odds_90),
     .error_pos(root_match[89]),
     .error_val(error_val[719:712]));

wire [71:0] val_emp_91;
wire [7:0] sum_of_odds_91 =
     elprt_91[15:8] ^
     elprt_91[31:24] ^
     elprt_91[47:40] ^
     elprt_91[63:56];

error_value_round evr90 (.emp_in(val_emp_90),
     .emp_out(val_emp_91),
     .deriv_term(sum_of_odds_91),
     .error_pos(root_match[90]),
     .error_val(error_val[727:720]));

wire [71:0] val_emp_92;
wire [7:0] sum_of_odds_92 =
     elprt_92[15:8] ^
     elprt_92[31:24] ^
     elprt_92[47:40] ^
     elprt_92[63:56];

error_value_round evr91 (.emp_in(val_emp_91),
     .emp_out(val_emp_92),
     .deriv_term(sum_of_odds_92),
     .error_pos(root_match[91]),
     .error_val(error_val[735:728]));

wire [71:0] val_emp_93;
wire [7:0] sum_of_odds_93 =
     elprt_93[15:8] ^
     elprt_93[31:24] ^
     elprt_93[47:40] ^
     elprt_93[63:56];

error_value_round evr92 (.emp_in(val_emp_92),
     .emp_out(val_emp_93),
     .deriv_term(sum_of_odds_93),
     .error_pos(root_match[92]),
     .error_val(error_val[743:736]));

wire [71:0] val_emp_94;
wire [7:0] sum_of_odds_94 =
     elprt_94[15:8] ^
     elprt_94[31:24] ^
     elprt_94[47:40] ^
     elprt_94[63:56];

error_value_round evr93 (.emp_in(val_emp_93),
     .emp_out(val_emp_94),
     .deriv_term(sum_of_odds_94),
     .error_pos(root_match[93]),
     .error_val(error_val[751:744]));

wire [71:0] val_emp_95;
wire [7:0] sum_of_odds_95 =
     elprt_95[15:8] ^
     elprt_95[31:24] ^
     elprt_95[47:40] ^
     elprt_95[63:56];

error_value_round evr94 (.emp_in(val_emp_94),
     .emp_out(val_emp_95),
     .deriv_term(sum_of_odds_95),
     .error_pos(root_match[94]),
     .error_val(error_val[759:752]));

wire [71:0] val_emp_96;
wire [7:0] sum_of_odds_96 =
     elprt_96[15:8] ^
     elprt_96[31:24] ^
     elprt_96[47:40] ^
     elprt_96[63:56];

error_value_round evr95 (.emp_in(val_emp_95),
     .emp_out(val_emp_96),
     .deriv_term(sum_of_odds_96),
     .error_pos(root_match[95]),
     .error_val(error_val[767:760]));

wire [71:0] val_emp_97;
wire [7:0] sum_of_odds_97 =
     elprt_97[15:8] ^
     elprt_97[31:24] ^
     elprt_97[47:40] ^
     elprt_97[63:56];

error_value_round evr96 (.emp_in(val_emp_96),
     .emp_out(val_emp_97),
     .deriv_term(sum_of_odds_97),
     .error_pos(root_match[96]),
     .error_val(error_val[775:768]));

wire [71:0] val_emp_98;
wire [7:0] sum_of_odds_98 =
     elprt_98[15:8] ^
     elprt_98[31:24] ^
     elprt_98[47:40] ^
     elprt_98[63:56];

error_value_round evr97 (.emp_in(val_emp_97),
     .emp_out(val_emp_98),
     .deriv_term(sum_of_odds_98),
     .error_pos(root_match[97]),
     .error_val(error_val[783:776]));

wire [71:0] val_emp_99;
wire [7:0] sum_of_odds_99 =
     elprt_99[15:8] ^
     elprt_99[31:24] ^
     elprt_99[47:40] ^
     elprt_99[63:56];

error_value_round evr98 (.emp_in(val_emp_98),
     .emp_out(val_emp_99),
     .deriv_term(sum_of_odds_99),
     .error_pos(root_match[98]),
     .error_val(error_val[791:784]));

wire [71:0] val_emp_100;
wire [7:0] sum_of_odds_100 =
     elprt_100[15:8] ^
     elprt_100[31:24] ^
     elprt_100[47:40] ^
     elprt_100[63:56];

error_value_round evr99 (.emp_in(val_emp_99),
     .emp_out(val_emp_100),
     .deriv_term(sum_of_odds_100),
     .error_pos(root_match[99]),
     .error_val(error_val[799:792]));

wire [71:0] val_emp_101;
wire [7:0] sum_of_odds_101 =
     elprt_101[15:8] ^
     elprt_101[31:24] ^
     elprt_101[47:40] ^
     elprt_101[63:56];

error_value_round evr100 (.emp_in(val_emp_100),
     .emp_out(val_emp_101),
     .deriv_term(sum_of_odds_101),
     .error_pos(root_match[100]),
     .error_val(error_val[807:800]));

wire [71:0] val_emp_102;
wire [7:0] sum_of_odds_102 =
     elprt_102[15:8] ^
     elprt_102[31:24] ^
     elprt_102[47:40] ^
     elprt_102[63:56];

error_value_round evr101 (.emp_in(val_emp_101),
     .emp_out(val_emp_102),
     .deriv_term(sum_of_odds_102),
     .error_pos(root_match[101]),
     .error_val(error_val[815:808]));

wire [71:0] val_emp_103;
wire [7:0] sum_of_odds_103 =
     elprt_103[15:8] ^
     elprt_103[31:24] ^
     elprt_103[47:40] ^
     elprt_103[63:56];

error_value_round evr102 (.emp_in(val_emp_102),
     .emp_out(val_emp_103),
     .deriv_term(sum_of_odds_103),
     .error_pos(root_match[102]),
     .error_val(error_val[823:816]));

wire [71:0] val_emp_104;
wire [7:0] sum_of_odds_104 =
     elprt_104[15:8] ^
     elprt_104[31:24] ^
     elprt_104[47:40] ^
     elprt_104[63:56];

error_value_round evr103 (.emp_in(val_emp_103),
     .emp_out(val_emp_104),
     .deriv_term(sum_of_odds_104),
     .error_pos(root_match[103]),
     .error_val(error_val[831:824]));

wire [71:0] val_emp_105;
wire [7:0] sum_of_odds_105 =
     elprt_105[15:8] ^
     elprt_105[31:24] ^
     elprt_105[47:40] ^
     elprt_105[63:56];

error_value_round evr104 (.emp_in(val_emp_104),
     .emp_out(val_emp_105),
     .deriv_term(sum_of_odds_105),
     .error_pos(root_match[104]),
     .error_val(error_val[839:832]));

wire [71:0] val_emp_106;
wire [7:0] sum_of_odds_106 =
     elprt_106[15:8] ^
     elprt_106[31:24] ^
     elprt_106[47:40] ^
     elprt_106[63:56];

error_value_round evr105 (.emp_in(val_emp_105),
     .emp_out(val_emp_106),
     .deriv_term(sum_of_odds_106),
     .error_pos(root_match[105]),
     .error_val(error_val[847:840]));

wire [71:0] val_emp_107;
wire [7:0] sum_of_odds_107 =
     elprt_107[15:8] ^
     elprt_107[31:24] ^
     elprt_107[47:40] ^
     elprt_107[63:56];

error_value_round evr106 (.emp_in(val_emp_106),
     .emp_out(val_emp_107),
     .deriv_term(sum_of_odds_107),
     .error_pos(root_match[106]),
     .error_val(error_val[855:848]));

wire [71:0] val_emp_108;
wire [7:0] sum_of_odds_108 =
     elprt_108[15:8] ^
     elprt_108[31:24] ^
     elprt_108[47:40] ^
     elprt_108[63:56];

error_value_round evr107 (.emp_in(val_emp_107),
     .emp_out(val_emp_108),
     .deriv_term(sum_of_odds_108),
     .error_pos(root_match[107]),
     .error_val(error_val[863:856]));

wire [71:0] val_emp_109;
wire [7:0] sum_of_odds_109 =
     elprt_109[15:8] ^
     elprt_109[31:24] ^
     elprt_109[47:40] ^
     elprt_109[63:56];

error_value_round evr108 (.emp_in(val_emp_108),
     .emp_out(val_emp_109),
     .deriv_term(sum_of_odds_109),
     .error_pos(root_match[108]),
     .error_val(error_val[871:864]));

wire [71:0] val_emp_110;
wire [7:0] sum_of_odds_110 =
     elprt_110[15:8] ^
     elprt_110[31:24] ^
     elprt_110[47:40] ^
     elprt_110[63:56];

error_value_round evr109 (.emp_in(val_emp_109),
     .emp_out(val_emp_110),
     .deriv_term(sum_of_odds_110),
     .error_pos(root_match[109]),
     .error_val(error_val[879:872]));

wire [71:0] val_emp_111;
wire [7:0] sum_of_odds_111 =
     elprt_111[15:8] ^
     elprt_111[31:24] ^
     elprt_111[47:40] ^
     elprt_111[63:56];

error_value_round evr110 (.emp_in(val_emp_110),
     .emp_out(val_emp_111),
     .deriv_term(sum_of_odds_111),
     .error_pos(root_match[110]),
     .error_val(error_val[887:880]));

wire [71:0] val_emp_112;
wire [7:0] sum_of_odds_112 =
     elprt_112[15:8] ^
     elprt_112[31:24] ^
     elprt_112[47:40] ^
     elprt_112[63:56];

error_value_round evr111 (.emp_in(val_emp_111),
     .emp_out(val_emp_112),
     .deriv_term(sum_of_odds_112),
     .error_pos(root_match[111]),
     .error_val(error_val[895:888]));

wire [71:0] val_emp_113;
wire [7:0] sum_of_odds_113 =
     elprt_113[15:8] ^
     elprt_113[31:24] ^
     elprt_113[47:40] ^
     elprt_113[63:56];

error_value_round evr112 (.emp_in(val_emp_112),
     .emp_out(val_emp_113),
     .deriv_term(sum_of_odds_113),
     .error_pos(root_match[112]),
     .error_val(error_val[903:896]));

wire [71:0] val_emp_114;
wire [7:0] sum_of_odds_114 =
     elprt_114[15:8] ^
     elprt_114[31:24] ^
     elprt_114[47:40] ^
     elprt_114[63:56];

error_value_round evr113 (.emp_in(val_emp_113),
     .emp_out(val_emp_114),
     .deriv_term(sum_of_odds_114),
     .error_pos(root_match[113]),
     .error_val(error_val[911:904]));

wire [71:0] val_emp_115;
wire [7:0] sum_of_odds_115 =
     elprt_115[15:8] ^
     elprt_115[31:24] ^
     elprt_115[47:40] ^
     elprt_115[63:56];

error_value_round evr114 (.emp_in(val_emp_114),
     .emp_out(val_emp_115),
     .deriv_term(sum_of_odds_115),
     .error_pos(root_match[114]),
     .error_val(error_val[919:912]));

wire [71:0] val_emp_116;
wire [7:0] sum_of_odds_116 =
     elprt_116[15:8] ^
     elprt_116[31:24] ^
     elprt_116[47:40] ^
     elprt_116[63:56];

error_value_round evr115 (.emp_in(val_emp_115),
     .emp_out(val_emp_116),
     .deriv_term(sum_of_odds_116),
     .error_pos(root_match[115]),
     .error_val(error_val[927:920]));

wire [71:0] val_emp_117;
wire [7:0] sum_of_odds_117 =
     elprt_117[15:8] ^
     elprt_117[31:24] ^
     elprt_117[47:40] ^
     elprt_117[63:56];

error_value_round evr116 (.emp_in(val_emp_116),
     .emp_out(val_emp_117),
     .deriv_term(sum_of_odds_117),
     .error_pos(root_match[116]),
     .error_val(error_val[935:928]));

wire [71:0] val_emp_118;
wire [7:0] sum_of_odds_118 =
     elprt_118[15:8] ^
     elprt_118[31:24] ^
     elprt_118[47:40] ^
     elprt_118[63:56];

error_value_round evr117 (.emp_in(val_emp_117),
     .emp_out(val_emp_118),
     .deriv_term(sum_of_odds_118),
     .error_pos(root_match[117]),
     .error_val(error_val[943:936]));

wire [71:0] val_emp_119;
wire [7:0] sum_of_odds_119 =
     elprt_119[15:8] ^
     elprt_119[31:24] ^
     elprt_119[47:40] ^
     elprt_119[63:56];

error_value_round evr118 (.emp_in(val_emp_118),
     .emp_out(val_emp_119),
     .deriv_term(sum_of_odds_119),
     .error_pos(root_match[118]),
     .error_val(error_val[951:944]));

wire [71:0] val_emp_120;
wire [7:0] sum_of_odds_120 =
     elprt_120[15:8] ^
     elprt_120[31:24] ^
     elprt_120[47:40] ^
     elprt_120[63:56];

error_value_round evr119 (.emp_in(val_emp_119),
     .emp_out(val_emp_120),
     .deriv_term(sum_of_odds_120),
     .error_pos(root_match[119]),
     .error_val(error_val[959:952]));

wire [71:0] val_emp_121;
wire [7:0] sum_of_odds_121 =
     elprt_121[15:8] ^
     elprt_121[31:24] ^
     elprt_121[47:40] ^
     elprt_121[63:56];

error_value_round evr120 (.emp_in(val_emp_120),
     .emp_out(val_emp_121),
     .deriv_term(sum_of_odds_121),
     .error_pos(root_match[120]),
     .error_val(error_val[967:960]));

wire [71:0] val_emp_122;
wire [7:0] sum_of_odds_122 =
     elprt_122[15:8] ^
     elprt_122[31:24] ^
     elprt_122[47:40] ^
     elprt_122[63:56];

error_value_round evr121 (.emp_in(val_emp_121),
     .emp_out(val_emp_122),
     .deriv_term(sum_of_odds_122),
     .error_pos(root_match[121]),
     .error_val(error_val[975:968]));

wire [71:0] val_emp_123;
wire [7:0] sum_of_odds_123 =
     elprt_123[15:8] ^
     elprt_123[31:24] ^
     elprt_123[47:40] ^
     elprt_123[63:56];

error_value_round evr122 (.emp_in(val_emp_122),
     .emp_out(val_emp_123),
     .deriv_term(sum_of_odds_123),
     .error_pos(root_match[122]),
     .error_val(error_val[983:976]));

wire [71:0] val_emp_124;
wire [7:0] sum_of_odds_124 =
     elprt_124[15:8] ^
     elprt_124[31:24] ^
     elprt_124[47:40] ^
     elprt_124[63:56];

error_value_round evr123 (.emp_in(val_emp_123),
     .emp_out(val_emp_124),
     .deriv_term(sum_of_odds_124),
     .error_pos(root_match[123]),
     .error_val(error_val[991:984]));

wire [71:0] val_emp_125;
wire [7:0] sum_of_odds_125 =
     elprt_125[15:8] ^
     elprt_125[31:24] ^
     elprt_125[47:40] ^
     elprt_125[63:56];

error_value_round evr124 (.emp_in(val_emp_124),
     .emp_out(val_emp_125),
     .deriv_term(sum_of_odds_125),
     .error_pos(root_match[124]),
     .error_val(error_val[999:992]));

wire [71:0] val_emp_126;
wire [7:0] sum_of_odds_126 =
     elprt_126[15:8] ^
     elprt_126[31:24] ^
     elprt_126[47:40] ^
     elprt_126[63:56];

error_value_round evr125 (.emp_in(val_emp_125),
     .emp_out(val_emp_126),
     .deriv_term(sum_of_odds_126),
     .error_pos(root_match[125]),
     .error_val(error_val[1007:1000]));

wire [71:0] val_emp_127;
wire [7:0] sum_of_odds_127 =
     elprt_127[15:8] ^
     elprt_127[31:24] ^
     elprt_127[47:40] ^
     elprt_127[63:56];

error_value_round evr126 (.emp_in(val_emp_126),
     .emp_out(val_emp_127),
     .deriv_term(sum_of_odds_127),
     .error_pos(root_match[126]),
     .error_val(error_val[1015:1008]));

wire [71:0] val_emp_128;
wire [7:0] sum_of_odds_128 =
     elprt_128[15:8] ^
     elprt_128[31:24] ^
     elprt_128[47:40] ^
     elprt_128[63:56];

error_value_round evr127 (.emp_in(val_emp_127),
     .emp_out(val_emp_128),
     .deriv_term(sum_of_odds_128),
     .error_pos(root_match[127]),
     .error_val(error_val[1023:1016]));

wire [71:0] val_emp_129;
wire [7:0] sum_of_odds_129 =
     elprt_129[15:8] ^
     elprt_129[31:24] ^
     elprt_129[47:40] ^
     elprt_129[63:56];

error_value_round evr128 (.emp_in(val_emp_128),
     .emp_out(val_emp_129),
     .deriv_term(sum_of_odds_129),
     .error_pos(root_match[128]),
     .error_val(error_val[1031:1024]));

wire [71:0] val_emp_130;
wire [7:0] sum_of_odds_130 =
     elprt_130[15:8] ^
     elprt_130[31:24] ^
     elprt_130[47:40] ^
     elprt_130[63:56];

error_value_round evr129 (.emp_in(val_emp_129),
     .emp_out(val_emp_130),
     .deriv_term(sum_of_odds_130),
     .error_pos(root_match[129]),
     .error_val(error_val[1039:1032]));

wire [71:0] val_emp_131;
wire [7:0] sum_of_odds_131 =
     elprt_131[15:8] ^
     elprt_131[31:24] ^
     elprt_131[47:40] ^
     elprt_131[63:56];

error_value_round evr130 (.emp_in(val_emp_130),
     .emp_out(val_emp_131),
     .deriv_term(sum_of_odds_131),
     .error_pos(root_match[130]),
     .error_val(error_val[1047:1040]));

wire [71:0] val_emp_132;
wire [7:0] sum_of_odds_132 =
     elprt_132[15:8] ^
     elprt_132[31:24] ^
     elprt_132[47:40] ^
     elprt_132[63:56];

error_value_round evr131 (.emp_in(val_emp_131),
     .emp_out(val_emp_132),
     .deriv_term(sum_of_odds_132),
     .error_pos(root_match[131]),
     .error_val(error_val[1055:1048]));

wire [71:0] val_emp_133;
wire [7:0] sum_of_odds_133 =
     elprt_133[15:8] ^
     elprt_133[31:24] ^
     elprt_133[47:40] ^
     elprt_133[63:56];

error_value_round evr132 (.emp_in(val_emp_132),
     .emp_out(val_emp_133),
     .deriv_term(sum_of_odds_133),
     .error_pos(root_match[132]),
     .error_val(error_val[1063:1056]));

wire [71:0] val_emp_134;
wire [7:0] sum_of_odds_134 =
     elprt_134[15:8] ^
     elprt_134[31:24] ^
     elprt_134[47:40] ^
     elprt_134[63:56];

error_value_round evr133 (.emp_in(val_emp_133),
     .emp_out(val_emp_134),
     .deriv_term(sum_of_odds_134),
     .error_pos(root_match[133]),
     .error_val(error_val[1071:1064]));

wire [71:0] val_emp_135;
wire [7:0] sum_of_odds_135 =
     elprt_135[15:8] ^
     elprt_135[31:24] ^
     elprt_135[47:40] ^
     elprt_135[63:56];

error_value_round evr134 (.emp_in(val_emp_134),
     .emp_out(val_emp_135),
     .deriv_term(sum_of_odds_135),
     .error_pos(root_match[134]),
     .error_val(error_val[1079:1072]));

wire [71:0] val_emp_136;
wire [7:0] sum_of_odds_136 =
     elprt_136[15:8] ^
     elprt_136[31:24] ^
     elprt_136[47:40] ^
     elprt_136[63:56];

error_value_round evr135 (.emp_in(val_emp_135),
     .emp_out(val_emp_136),
     .deriv_term(sum_of_odds_136),
     .error_pos(root_match[135]),
     .error_val(error_val[1087:1080]));

wire [71:0] val_emp_137;
wire [7:0] sum_of_odds_137 =
     elprt_137[15:8] ^
     elprt_137[31:24] ^
     elprt_137[47:40] ^
     elprt_137[63:56];

error_value_round evr136 (.emp_in(val_emp_136),
     .emp_out(val_emp_137),
     .deriv_term(sum_of_odds_137),
     .error_pos(root_match[136]),
     .error_val(error_val[1095:1088]));

wire [71:0] val_emp_138;
wire [7:0] sum_of_odds_138 =
     elprt_138[15:8] ^
     elprt_138[31:24] ^
     elprt_138[47:40] ^
     elprt_138[63:56];

error_value_round evr137 (.emp_in(val_emp_137),
     .emp_out(val_emp_138),
     .deriv_term(sum_of_odds_138),
     .error_pos(root_match[137]),
     .error_val(error_val[1103:1096]));

wire [71:0] val_emp_139;
wire [7:0] sum_of_odds_139 =
     elprt_139[15:8] ^
     elprt_139[31:24] ^
     elprt_139[47:40] ^
     elprt_139[63:56];

error_value_round evr138 (.emp_in(val_emp_138),
     .emp_out(val_emp_139),
     .deriv_term(sum_of_odds_139),
     .error_pos(root_match[138]),
     .error_val(error_val[1111:1104]));

wire [71:0] val_emp_140;
wire [7:0] sum_of_odds_140 =
     elprt_140[15:8] ^
     elprt_140[31:24] ^
     elprt_140[47:40] ^
     elprt_140[63:56];

error_value_round evr139 (.emp_in(val_emp_139),
     .emp_out(val_emp_140),
     .deriv_term(sum_of_odds_140),
     .error_pos(root_match[139]),
     .error_val(error_val[1119:1112]));

wire [71:0] val_emp_141;
wire [7:0] sum_of_odds_141 =
     elprt_141[15:8] ^
     elprt_141[31:24] ^
     elprt_141[47:40] ^
     elprt_141[63:56];

error_value_round evr140 (.emp_in(val_emp_140),
     .emp_out(val_emp_141),
     .deriv_term(sum_of_odds_141),
     .error_pos(root_match[140]),
     .error_val(error_val[1127:1120]));

wire [71:0] val_emp_142;
wire [7:0] sum_of_odds_142 =
     elprt_142[15:8] ^
     elprt_142[31:24] ^
     elprt_142[47:40] ^
     elprt_142[63:56];

error_value_round evr141 (.emp_in(val_emp_141),
     .emp_out(val_emp_142),
     .deriv_term(sum_of_odds_142),
     .error_pos(root_match[141]),
     .error_val(error_val[1135:1128]));

wire [71:0] val_emp_143;
wire [7:0] sum_of_odds_143 =
     elprt_143[15:8] ^
     elprt_143[31:24] ^
     elprt_143[47:40] ^
     elprt_143[63:56];

error_value_round evr142 (.emp_in(val_emp_142),
     .emp_out(val_emp_143),
     .deriv_term(sum_of_odds_143),
     .error_pos(root_match[142]),
     .error_val(error_val[1143:1136]));

wire [71:0] val_emp_144;
wire [7:0] sum_of_odds_144 =
     elprt_144[15:8] ^
     elprt_144[31:24] ^
     elprt_144[47:40] ^
     elprt_144[63:56];

error_value_round evr143 (.emp_in(val_emp_143),
     .emp_out(val_emp_144),
     .deriv_term(sum_of_odds_144),
     .error_pos(root_match[143]),
     .error_val(error_val[1151:1144]));

wire [71:0] val_emp_145;
wire [7:0] sum_of_odds_145 =
     elprt_145[15:8] ^
     elprt_145[31:24] ^
     elprt_145[47:40] ^
     elprt_145[63:56];

error_value_round evr144 (.emp_in(val_emp_144),
     .emp_out(val_emp_145),
     .deriv_term(sum_of_odds_145),
     .error_pos(root_match[144]),
     .error_val(error_val[1159:1152]));

wire [71:0] val_emp_146;
wire [7:0] sum_of_odds_146 =
     elprt_146[15:8] ^
     elprt_146[31:24] ^
     elprt_146[47:40] ^
     elprt_146[63:56];

error_value_round evr145 (.emp_in(val_emp_145),
     .emp_out(val_emp_146),
     .deriv_term(sum_of_odds_146),
     .error_pos(root_match[145]),
     .error_val(error_val[1167:1160]));

wire [71:0] val_emp_147;
wire [7:0] sum_of_odds_147 =
     elprt_147[15:8] ^
     elprt_147[31:24] ^
     elprt_147[47:40] ^
     elprt_147[63:56];

error_value_round evr146 (.emp_in(val_emp_146),
     .emp_out(val_emp_147),
     .deriv_term(sum_of_odds_147),
     .error_pos(root_match[146]),
     .error_val(error_val[1175:1168]));

wire [71:0] val_emp_148;
wire [7:0] sum_of_odds_148 =
     elprt_148[15:8] ^
     elprt_148[31:24] ^
     elprt_148[47:40] ^
     elprt_148[63:56];

error_value_round evr147 (.emp_in(val_emp_147),
     .emp_out(val_emp_148),
     .deriv_term(sum_of_odds_148),
     .error_pos(root_match[147]),
     .error_val(error_val[1183:1176]));

wire [71:0] val_emp_149;
wire [7:0] sum_of_odds_149 =
     elprt_149[15:8] ^
     elprt_149[31:24] ^
     elprt_149[47:40] ^
     elprt_149[63:56];

error_value_round evr148 (.emp_in(val_emp_148),
     .emp_out(val_emp_149),
     .deriv_term(sum_of_odds_149),
     .error_pos(root_match[148]),
     .error_val(error_val[1191:1184]));

wire [71:0] val_emp_150;
wire [7:0] sum_of_odds_150 =
     elprt_150[15:8] ^
     elprt_150[31:24] ^
     elprt_150[47:40] ^
     elprt_150[63:56];

error_value_round evr149 (.emp_in(val_emp_149),
     .emp_out(val_emp_150),
     .deriv_term(sum_of_odds_150),
     .error_pos(root_match[149]),
     .error_val(error_val[1199:1192]));

wire [71:0] val_emp_151;
wire [7:0] sum_of_odds_151 =
     elprt_151[15:8] ^
     elprt_151[31:24] ^
     elprt_151[47:40] ^
     elprt_151[63:56];

error_value_round evr150 (.emp_in(val_emp_150),
     .emp_out(val_emp_151),
     .deriv_term(sum_of_odds_151),
     .error_pos(root_match[150]),
     .error_val(error_val[1207:1200]));

wire [71:0] val_emp_152;
wire [7:0] sum_of_odds_152 =
     elprt_152[15:8] ^
     elprt_152[31:24] ^
     elprt_152[47:40] ^
     elprt_152[63:56];

error_value_round evr151 (.emp_in(val_emp_151),
     .emp_out(val_emp_152),
     .deriv_term(sum_of_odds_152),
     .error_pos(root_match[151]),
     .error_val(error_val[1215:1208]));

wire [71:0] val_emp_153;
wire [7:0] sum_of_odds_153 =
     elprt_153[15:8] ^
     elprt_153[31:24] ^
     elprt_153[47:40] ^
     elprt_153[63:56];

error_value_round evr152 (.emp_in(val_emp_152),
     .emp_out(val_emp_153),
     .deriv_term(sum_of_odds_153),
     .error_pos(root_match[152]),
     .error_val(error_val[1223:1216]));

wire [71:0] val_emp_154;
wire [7:0] sum_of_odds_154 =
     elprt_154[15:8] ^
     elprt_154[31:24] ^
     elprt_154[47:40] ^
     elprt_154[63:56];

error_value_round evr153 (.emp_in(val_emp_153),
     .emp_out(val_emp_154),
     .deriv_term(sum_of_odds_154),
     .error_pos(root_match[153]),
     .error_val(error_val[1231:1224]));

wire [71:0] val_emp_155;
wire [7:0] sum_of_odds_155 =
     elprt_155[15:8] ^
     elprt_155[31:24] ^
     elprt_155[47:40] ^
     elprt_155[63:56];

error_value_round evr154 (.emp_in(val_emp_154),
     .emp_out(val_emp_155),
     .deriv_term(sum_of_odds_155),
     .error_pos(root_match[154]),
     .error_val(error_val[1239:1232]));

wire [71:0] val_emp_156;
wire [7:0] sum_of_odds_156 =
     elprt_156[15:8] ^
     elprt_156[31:24] ^
     elprt_156[47:40] ^
     elprt_156[63:56];

error_value_round evr155 (.emp_in(val_emp_155),
     .emp_out(val_emp_156),
     .deriv_term(sum_of_odds_156),
     .error_pos(root_match[155]),
     .error_val(error_val[1247:1240]));

wire [71:0] val_emp_157;
wire [7:0] sum_of_odds_157 =
     elprt_157[15:8] ^
     elprt_157[31:24] ^
     elprt_157[47:40] ^
     elprt_157[63:56];

error_value_round evr156 (.emp_in(val_emp_156),
     .emp_out(val_emp_157),
     .deriv_term(sum_of_odds_157),
     .error_pos(root_match[156]),
     .error_val(error_val[1255:1248]));

wire [71:0] val_emp_158;
wire [7:0] sum_of_odds_158 =
     elprt_158[15:8] ^
     elprt_158[31:24] ^
     elprt_158[47:40] ^
     elprt_158[63:56];

error_value_round evr157 (.emp_in(val_emp_157),
     .emp_out(val_emp_158),
     .deriv_term(sum_of_odds_158),
     .error_pos(root_match[157]),
     .error_val(error_val[1263:1256]));

wire [71:0] val_emp_159;
wire [7:0] sum_of_odds_159 =
     elprt_159[15:8] ^
     elprt_159[31:24] ^
     elprt_159[47:40] ^
     elprt_159[63:56];

error_value_round evr158 (.emp_in(val_emp_158),
     .emp_out(val_emp_159),
     .deriv_term(sum_of_odds_159),
     .error_pos(root_match[158]),
     .error_val(error_val[1271:1264]));

wire [71:0] val_emp_160;
wire [7:0] sum_of_odds_160 =
     elprt_160[15:8] ^
     elprt_160[31:24] ^
     elprt_160[47:40] ^
     elprt_160[63:56];

error_value_round evr159 (.emp_in(val_emp_159),
     .emp_out(val_emp_160),
     .deriv_term(sum_of_odds_160),
     .error_pos(root_match[159]),
     .error_val(error_val[1279:1272]));

wire [71:0] val_emp_161;
wire [7:0] sum_of_odds_161 =
     elprt_161[15:8] ^
     elprt_161[31:24] ^
     elprt_161[47:40] ^
     elprt_161[63:56];

error_value_round evr160 (.emp_in(val_emp_160),
     .emp_out(val_emp_161),
     .deriv_term(sum_of_odds_161),
     .error_pos(root_match[160]),
     .error_val(error_val[1287:1280]));

wire [71:0] val_emp_162;
wire [7:0] sum_of_odds_162 =
     elprt_162[15:8] ^
     elprt_162[31:24] ^
     elprt_162[47:40] ^
     elprt_162[63:56];

error_value_round evr161 (.emp_in(val_emp_161),
     .emp_out(val_emp_162),
     .deriv_term(sum_of_odds_162),
     .error_pos(root_match[161]),
     .error_val(error_val[1295:1288]));

wire [71:0] val_emp_163;
wire [7:0] sum_of_odds_163 =
     elprt_163[15:8] ^
     elprt_163[31:24] ^
     elprt_163[47:40] ^
     elprt_163[63:56];

error_value_round evr162 (.emp_in(val_emp_162),
     .emp_out(val_emp_163),
     .deriv_term(sum_of_odds_163),
     .error_pos(root_match[162]),
     .error_val(error_val[1303:1296]));

wire [71:0] val_emp_164;
wire [7:0] sum_of_odds_164 =
     elprt_164[15:8] ^
     elprt_164[31:24] ^
     elprt_164[47:40] ^
     elprt_164[63:56];

error_value_round evr163 (.emp_in(val_emp_163),
     .emp_out(val_emp_164),
     .deriv_term(sum_of_odds_164),
     .error_pos(root_match[163]),
     .error_val(error_val[1311:1304]));

wire [71:0] val_emp_165;
wire [7:0] sum_of_odds_165 =
     elprt_165[15:8] ^
     elprt_165[31:24] ^
     elprt_165[47:40] ^
     elprt_165[63:56];

error_value_round evr164 (.emp_in(val_emp_164),
     .emp_out(val_emp_165),
     .deriv_term(sum_of_odds_165),
     .error_pos(root_match[164]),
     .error_val(error_val[1319:1312]));

wire [71:0] val_emp_166;
wire [7:0] sum_of_odds_166 =
     elprt_166[15:8] ^
     elprt_166[31:24] ^
     elprt_166[47:40] ^
     elprt_166[63:56];

error_value_round evr165 (.emp_in(val_emp_165),
     .emp_out(val_emp_166),
     .deriv_term(sum_of_odds_166),
     .error_pos(root_match[165]),
     .error_val(error_val[1327:1320]));

wire [71:0] val_emp_167;
wire [7:0] sum_of_odds_167 =
     elprt_167[15:8] ^
     elprt_167[31:24] ^
     elprt_167[47:40] ^
     elprt_167[63:56];

error_value_round evr166 (.emp_in(val_emp_166),
     .emp_out(val_emp_167),
     .deriv_term(sum_of_odds_167),
     .error_pos(root_match[166]),
     .error_val(error_val[1335:1328]));

wire [71:0] val_emp_168;
wire [7:0] sum_of_odds_168 =
     elprt_168[15:8] ^
     elprt_168[31:24] ^
     elprt_168[47:40] ^
     elprt_168[63:56];

error_value_round evr167 (.emp_in(val_emp_167),
     .emp_out(val_emp_168),
     .deriv_term(sum_of_odds_168),
     .error_pos(root_match[167]),
     .error_val(error_val[1343:1336]));

wire [71:0] val_emp_169;
wire [7:0] sum_of_odds_169 =
     elprt_169[15:8] ^
     elprt_169[31:24] ^
     elprt_169[47:40] ^
     elprt_169[63:56];

error_value_round evr168 (.emp_in(val_emp_168),
     .emp_out(val_emp_169),
     .deriv_term(sum_of_odds_169),
     .error_pos(root_match[168]),
     .error_val(error_val[1351:1344]));

wire [71:0] val_emp_170;
wire [7:0] sum_of_odds_170 =
     elprt_170[15:8] ^
     elprt_170[31:24] ^
     elprt_170[47:40] ^
     elprt_170[63:56];

error_value_round evr169 (.emp_in(val_emp_169),
     .emp_out(val_emp_170),
     .deriv_term(sum_of_odds_170),
     .error_pos(root_match[169]),
     .error_val(error_val[1359:1352]));

wire [71:0] val_emp_171;
wire [7:0] sum_of_odds_171 =
     elprt_171[15:8] ^
     elprt_171[31:24] ^
     elprt_171[47:40] ^
     elprt_171[63:56];

error_value_round evr170 (.emp_in(val_emp_170),
     .emp_out(val_emp_171),
     .deriv_term(sum_of_odds_171),
     .error_pos(root_match[170]),
     .error_val(error_val[1367:1360]));

wire [71:0] val_emp_172;
wire [7:0] sum_of_odds_172 =
     elprt_172[15:8] ^
     elprt_172[31:24] ^
     elprt_172[47:40] ^
     elprt_172[63:56];

error_value_round evr171 (.emp_in(val_emp_171),
     .emp_out(val_emp_172),
     .deriv_term(sum_of_odds_172),
     .error_pos(root_match[171]),
     .error_val(error_val[1375:1368]));

wire [71:0] val_emp_173;
wire [7:0] sum_of_odds_173 =
     elprt_173[15:8] ^
     elprt_173[31:24] ^
     elprt_173[47:40] ^
     elprt_173[63:56];

error_value_round evr172 (.emp_in(val_emp_172),
     .emp_out(val_emp_173),
     .deriv_term(sum_of_odds_173),
     .error_pos(root_match[172]),
     .error_val(error_val[1383:1376]));

wire [71:0] val_emp_174;
wire [7:0] sum_of_odds_174 =
     elprt_174[15:8] ^
     elprt_174[31:24] ^
     elprt_174[47:40] ^
     elprt_174[63:56];

error_value_round evr173 (.emp_in(val_emp_173),
     .emp_out(val_emp_174),
     .deriv_term(sum_of_odds_174),
     .error_pos(root_match[173]),
     .error_val(error_val[1391:1384]));

wire [71:0] val_emp_175;
wire [7:0] sum_of_odds_175 =
     elprt_175[15:8] ^
     elprt_175[31:24] ^
     elprt_175[47:40] ^
     elprt_175[63:56];

error_value_round evr174 (.emp_in(val_emp_174),
     .emp_out(val_emp_175),
     .deriv_term(sum_of_odds_175),
     .error_pos(root_match[174]),
     .error_val(error_val[1399:1392]));

wire [71:0] val_emp_176;
wire [7:0] sum_of_odds_176 =
     elprt_176[15:8] ^
     elprt_176[31:24] ^
     elprt_176[47:40] ^
     elprt_176[63:56];

error_value_round evr175 (.emp_in(val_emp_175),
     .emp_out(val_emp_176),
     .deriv_term(sum_of_odds_176),
     .error_pos(root_match[175]),
     .error_val(error_val[1407:1400]));

wire [71:0] val_emp_177;
wire [7:0] sum_of_odds_177 =
     elprt_177[15:8] ^
     elprt_177[31:24] ^
     elprt_177[47:40] ^
     elprt_177[63:56];

error_value_round evr176 (.emp_in(val_emp_176),
     .emp_out(val_emp_177),
     .deriv_term(sum_of_odds_177),
     .error_pos(root_match[176]),
     .error_val(error_val[1415:1408]));

wire [71:0] val_emp_178;
wire [7:0] sum_of_odds_178 =
     elprt_178[15:8] ^
     elprt_178[31:24] ^
     elprt_178[47:40] ^
     elprt_178[63:56];

error_value_round evr177 (.emp_in(val_emp_177),
     .emp_out(val_emp_178),
     .deriv_term(sum_of_odds_178),
     .error_pos(root_match[177]),
     .error_val(error_val[1423:1416]));

wire [71:0] val_emp_179;
wire [7:0] sum_of_odds_179 =
     elprt_179[15:8] ^
     elprt_179[31:24] ^
     elprt_179[47:40] ^
     elprt_179[63:56];

error_value_round evr178 (.emp_in(val_emp_178),
     .emp_out(val_emp_179),
     .deriv_term(sum_of_odds_179),
     .error_pos(root_match[178]),
     .error_val(error_val[1431:1424]));

wire [71:0] val_emp_180;
wire [7:0] sum_of_odds_180 =
     elprt_180[15:8] ^
     elprt_180[31:24] ^
     elprt_180[47:40] ^
     elprt_180[63:56];

error_value_round evr179 (.emp_in(val_emp_179),
     .emp_out(val_emp_180),
     .deriv_term(sum_of_odds_180),
     .error_pos(root_match[179]),
     .error_val(error_val[1439:1432]));

wire [71:0] val_emp_181;
wire [7:0] sum_of_odds_181 =
     elprt_181[15:8] ^
     elprt_181[31:24] ^
     elprt_181[47:40] ^
     elprt_181[63:56];

error_value_round evr180 (.emp_in(val_emp_180),
     .emp_out(val_emp_181),
     .deriv_term(sum_of_odds_181),
     .error_pos(root_match[180]),
     .error_val(error_val[1447:1440]));

wire [71:0] val_emp_182;
wire [7:0] sum_of_odds_182 =
     elprt_182[15:8] ^
     elprt_182[31:24] ^
     elprt_182[47:40] ^
     elprt_182[63:56];

error_value_round evr181 (.emp_in(val_emp_181),
     .emp_out(val_emp_182),
     .deriv_term(sum_of_odds_182),
     .error_pos(root_match[181]),
     .error_val(error_val[1455:1448]));

wire [71:0] val_emp_183;
wire [7:0] sum_of_odds_183 =
     elprt_183[15:8] ^
     elprt_183[31:24] ^
     elprt_183[47:40] ^
     elprt_183[63:56];

error_value_round evr182 (.emp_in(val_emp_182),
     .emp_out(val_emp_183),
     .deriv_term(sum_of_odds_183),
     .error_pos(root_match[182]),
     .error_val(error_val[1463:1456]));

wire [71:0] val_emp_184;
wire [7:0] sum_of_odds_184 =
     elprt_184[15:8] ^
     elprt_184[31:24] ^
     elprt_184[47:40] ^
     elprt_184[63:56];

error_value_round evr183 (.emp_in(val_emp_183),
     .emp_out(val_emp_184),
     .deriv_term(sum_of_odds_184),
     .error_pos(root_match[183]),
     .error_val(error_val[1471:1464]));

wire [71:0] val_emp_185;
wire [7:0] sum_of_odds_185 =
     elprt_185[15:8] ^
     elprt_185[31:24] ^
     elprt_185[47:40] ^
     elprt_185[63:56];

error_value_round evr184 (.emp_in(val_emp_184),
     .emp_out(val_emp_185),
     .deriv_term(sum_of_odds_185),
     .error_pos(root_match[184]),
     .error_val(error_val[1479:1472]));

wire [71:0] val_emp_186;
wire [7:0] sum_of_odds_186 =
     elprt_186[15:8] ^
     elprt_186[31:24] ^
     elprt_186[47:40] ^
     elprt_186[63:56];

error_value_round evr185 (.emp_in(val_emp_185),
     .emp_out(val_emp_186),
     .deriv_term(sum_of_odds_186),
     .error_pos(root_match[185]),
     .error_val(error_val[1487:1480]));

wire [71:0] val_emp_187;
wire [7:0] sum_of_odds_187 =
     elprt_187[15:8] ^
     elprt_187[31:24] ^
     elprt_187[47:40] ^
     elprt_187[63:56];

error_value_round evr186 (.emp_in(val_emp_186),
     .emp_out(val_emp_187),
     .deriv_term(sum_of_odds_187),
     .error_pos(root_match[186]),
     .error_val(error_val[1495:1488]));

wire [71:0] val_emp_188;
wire [7:0] sum_of_odds_188 =
     elprt_188[15:8] ^
     elprt_188[31:24] ^
     elprt_188[47:40] ^
     elprt_188[63:56];

error_value_round evr187 (.emp_in(val_emp_187),
     .emp_out(val_emp_188),
     .deriv_term(sum_of_odds_188),
     .error_pos(root_match[187]),
     .error_val(error_val[1503:1496]));

wire [71:0] val_emp_189;
wire [7:0] sum_of_odds_189 =
     elprt_189[15:8] ^
     elprt_189[31:24] ^
     elprt_189[47:40] ^
     elprt_189[63:56];

error_value_round evr188 (.emp_in(val_emp_188),
     .emp_out(val_emp_189),
     .deriv_term(sum_of_odds_189),
     .error_pos(root_match[188]),
     .error_val(error_val[1511:1504]));

wire [71:0] val_emp_190;
wire [7:0] sum_of_odds_190 =
     elprt_190[15:8] ^
     elprt_190[31:24] ^
     elprt_190[47:40] ^
     elprt_190[63:56];

error_value_round evr189 (.emp_in(val_emp_189),
     .emp_out(val_emp_190),
     .deriv_term(sum_of_odds_190),
     .error_pos(root_match[189]),
     .error_val(error_val[1519:1512]));

wire [71:0] val_emp_191;
wire [7:0] sum_of_odds_191 =
     elprt_191[15:8] ^
     elprt_191[31:24] ^
     elprt_191[47:40] ^
     elprt_191[63:56];

error_value_round evr190 (.emp_in(val_emp_190),
     .emp_out(val_emp_191),
     .deriv_term(sum_of_odds_191),
     .error_pos(root_match[190]),
     .error_val(error_val[1527:1520]));

wire [71:0] val_emp_192;
wire [7:0] sum_of_odds_192 =
     elprt_192[15:8] ^
     elprt_192[31:24] ^
     elprt_192[47:40] ^
     elprt_192[63:56];

error_value_round evr191 (.emp_in(val_emp_191),
     .emp_out(val_emp_192),
     .deriv_term(sum_of_odds_192),
     .error_pos(root_match[191]),
     .error_val(error_val[1535:1528]));

wire [71:0] val_emp_193;
wire [7:0] sum_of_odds_193 =
     elprt_193[15:8] ^
     elprt_193[31:24] ^
     elprt_193[47:40] ^
     elprt_193[63:56];

error_value_round evr192 (.emp_in(val_emp_192),
     .emp_out(val_emp_193),
     .deriv_term(sum_of_odds_193),
     .error_pos(root_match[192]),
     .error_val(error_val[1543:1536]));

wire [71:0] val_emp_194;
wire [7:0] sum_of_odds_194 =
     elprt_194[15:8] ^
     elprt_194[31:24] ^
     elprt_194[47:40] ^
     elprt_194[63:56];

error_value_round evr193 (.emp_in(val_emp_193),
     .emp_out(val_emp_194),
     .deriv_term(sum_of_odds_194),
     .error_pos(root_match[193]),
     .error_val(error_val[1551:1544]));

wire [71:0] val_emp_195;
wire [7:0] sum_of_odds_195 =
     elprt_195[15:8] ^
     elprt_195[31:24] ^
     elprt_195[47:40] ^
     elprt_195[63:56];

error_value_round evr194 (.emp_in(val_emp_194),
     .emp_out(val_emp_195),
     .deriv_term(sum_of_odds_195),
     .error_pos(root_match[194]),
     .error_val(error_val[1559:1552]));

wire [71:0] val_emp_196;
wire [7:0] sum_of_odds_196 =
     elprt_196[15:8] ^
     elprt_196[31:24] ^
     elprt_196[47:40] ^
     elprt_196[63:56];

error_value_round evr195 (.emp_in(val_emp_195),
     .emp_out(val_emp_196),
     .deriv_term(sum_of_odds_196),
     .error_pos(root_match[195]),
     .error_val(error_val[1567:1560]));

wire [71:0] val_emp_197;
wire [7:0] sum_of_odds_197 =
     elprt_197[15:8] ^
     elprt_197[31:24] ^
     elprt_197[47:40] ^
     elprt_197[63:56];

error_value_round evr196 (.emp_in(val_emp_196),
     .emp_out(val_emp_197),
     .deriv_term(sum_of_odds_197),
     .error_pos(root_match[196]),
     .error_val(error_val[1575:1568]));

wire [71:0] val_emp_198;
wire [7:0] sum_of_odds_198 =
     elprt_198[15:8] ^
     elprt_198[31:24] ^
     elprt_198[47:40] ^
     elprt_198[63:56];

error_value_round evr197 (.emp_in(val_emp_197),
     .emp_out(val_emp_198),
     .deriv_term(sum_of_odds_198),
     .error_pos(root_match[197]),
     .error_val(error_val[1583:1576]));

wire [71:0] val_emp_199;
wire [7:0] sum_of_odds_199 =
     elprt_199[15:8] ^
     elprt_199[31:24] ^
     elprt_199[47:40] ^
     elprt_199[63:56];

error_value_round evr198 (.emp_in(val_emp_198),
     .emp_out(val_emp_199),
     .deriv_term(sum_of_odds_199),
     .error_pos(root_match[198]),
     .error_val(error_val[1591:1584]));

wire [71:0] val_emp_200;
wire [7:0] sum_of_odds_200 =
     elprt_200[15:8] ^
     elprt_200[31:24] ^
     elprt_200[47:40] ^
     elprt_200[63:56];

error_value_round evr199 (.emp_in(val_emp_199),
     .emp_out(val_emp_200),
     .deriv_term(sum_of_odds_200),
     .error_pos(root_match[199]),
     .error_val(error_val[1599:1592]));

wire [71:0] val_emp_201;
wire [7:0] sum_of_odds_201 =
     elprt_201[15:8] ^
     elprt_201[31:24] ^
     elprt_201[47:40] ^
     elprt_201[63:56];

error_value_round evr200 (.emp_in(val_emp_200),
     .emp_out(val_emp_201),
     .deriv_term(sum_of_odds_201),
     .error_pos(root_match[200]),
     .error_val(error_val[1607:1600]));

wire [71:0] val_emp_202;
wire [7:0] sum_of_odds_202 =
     elprt_202[15:8] ^
     elprt_202[31:24] ^
     elprt_202[47:40] ^
     elprt_202[63:56];

error_value_round evr201 (.emp_in(val_emp_201),
     .emp_out(val_emp_202),
     .deriv_term(sum_of_odds_202),
     .error_pos(root_match[201]),
     .error_val(error_val[1615:1608]));

wire [71:0] val_emp_203;
wire [7:0] sum_of_odds_203 =
     elprt_203[15:8] ^
     elprt_203[31:24] ^
     elprt_203[47:40] ^
     elprt_203[63:56];

error_value_round evr202 (.emp_in(val_emp_202),
     .emp_out(val_emp_203),
     .deriv_term(sum_of_odds_203),
     .error_pos(root_match[202]),
     .error_val(error_val[1623:1616]));

wire [71:0] val_emp_204;
wire [7:0] sum_of_odds_204 =
     elprt_204[15:8] ^
     elprt_204[31:24] ^
     elprt_204[47:40] ^
     elprt_204[63:56];

error_value_round evr203 (.emp_in(val_emp_203),
     .emp_out(val_emp_204),
     .deriv_term(sum_of_odds_204),
     .error_pos(root_match[203]),
     .error_val(error_val[1631:1624]));

wire [71:0] val_emp_205;
wire [7:0] sum_of_odds_205 =
     elprt_205[15:8] ^
     elprt_205[31:24] ^
     elprt_205[47:40] ^
     elprt_205[63:56];

error_value_round evr204 (.emp_in(val_emp_204),
     .emp_out(val_emp_205),
     .deriv_term(sum_of_odds_205),
     .error_pos(root_match[204]),
     .error_val(error_val[1639:1632]));

wire [71:0] val_emp_206;
wire [7:0] sum_of_odds_206 =
     elprt_206[15:8] ^
     elprt_206[31:24] ^
     elprt_206[47:40] ^
     elprt_206[63:56];

error_value_round evr205 (.emp_in(val_emp_205),
     .emp_out(val_emp_206),
     .deriv_term(sum_of_odds_206),
     .error_pos(root_match[205]),
     .error_val(error_val[1647:1640]));

wire [71:0] val_emp_207;
wire [7:0] sum_of_odds_207 =
     elprt_207[15:8] ^
     elprt_207[31:24] ^
     elprt_207[47:40] ^
     elprt_207[63:56];

error_value_round evr206 (.emp_in(val_emp_206),
     .emp_out(val_emp_207),
     .deriv_term(sum_of_odds_207),
     .error_pos(root_match[206]),
     .error_val(error_val[1655:1648]));

wire [71:0] val_emp_208;
wire [7:0] sum_of_odds_208 =
     elprt_208[15:8] ^
     elprt_208[31:24] ^
     elprt_208[47:40] ^
     elprt_208[63:56];

error_value_round evr207 (.emp_in(val_emp_207),
     .emp_out(val_emp_208),
     .deriv_term(sum_of_odds_208),
     .error_pos(root_match[207]),
     .error_val(error_val[1663:1656]));

wire [71:0] val_emp_209;
wire [7:0] sum_of_odds_209 =
     elprt_209[15:8] ^
     elprt_209[31:24] ^
     elprt_209[47:40] ^
     elprt_209[63:56];

error_value_round evr208 (.emp_in(val_emp_208),
     .emp_out(val_emp_209),
     .deriv_term(sum_of_odds_209),
     .error_pos(root_match[208]),
     .error_val(error_val[1671:1664]));

wire [71:0] val_emp_210;
wire [7:0] sum_of_odds_210 =
     elprt_210[15:8] ^
     elprt_210[31:24] ^
     elprt_210[47:40] ^
     elprt_210[63:56];

error_value_round evr209 (.emp_in(val_emp_209),
     .emp_out(val_emp_210),
     .deriv_term(sum_of_odds_210),
     .error_pos(root_match[209]),
     .error_val(error_val[1679:1672]));

wire [71:0] val_emp_211;
wire [7:0] sum_of_odds_211 =
     elprt_211[15:8] ^
     elprt_211[31:24] ^
     elprt_211[47:40] ^
     elprt_211[63:56];

error_value_round evr210 (.emp_in(val_emp_210),
     .emp_out(val_emp_211),
     .deriv_term(sum_of_odds_211),
     .error_pos(root_match[210]),
     .error_val(error_val[1687:1680]));

wire [71:0] val_emp_212;
wire [7:0] sum_of_odds_212 =
     elprt_212[15:8] ^
     elprt_212[31:24] ^
     elprt_212[47:40] ^
     elprt_212[63:56];

error_value_round evr211 (.emp_in(val_emp_211),
     .emp_out(val_emp_212),
     .deriv_term(sum_of_odds_212),
     .error_pos(root_match[211]),
     .error_val(error_val[1695:1688]));

wire [71:0] val_emp_213;
wire [7:0] sum_of_odds_213 =
     elprt_213[15:8] ^
     elprt_213[31:24] ^
     elprt_213[47:40] ^
     elprt_213[63:56];

error_value_round evr212 (.emp_in(val_emp_212),
     .emp_out(val_emp_213),
     .deriv_term(sum_of_odds_213),
     .error_pos(root_match[212]),
     .error_val(error_val[1703:1696]));

wire [71:0] val_emp_214;
wire [7:0] sum_of_odds_214 =
     elprt_214[15:8] ^
     elprt_214[31:24] ^
     elprt_214[47:40] ^
     elprt_214[63:56];

error_value_round evr213 (.emp_in(val_emp_213),
     .emp_out(val_emp_214),
     .deriv_term(sum_of_odds_214),
     .error_pos(root_match[213]),
     .error_val(error_val[1711:1704]));

wire [71:0] val_emp_215;
wire [7:0] sum_of_odds_215 =
     elprt_215[15:8] ^
     elprt_215[31:24] ^
     elprt_215[47:40] ^
     elprt_215[63:56];

error_value_round evr214 (.emp_in(val_emp_214),
     .emp_out(val_emp_215),
     .deriv_term(sum_of_odds_215),
     .error_pos(root_match[214]),
     .error_val(error_val[1719:1712]));

wire [71:0] val_emp_216;
wire [7:0] sum_of_odds_216 =
     elprt_216[15:8] ^
     elprt_216[31:24] ^
     elprt_216[47:40] ^
     elprt_216[63:56];

error_value_round evr215 (.emp_in(val_emp_215),
     .emp_out(val_emp_216),
     .deriv_term(sum_of_odds_216),
     .error_pos(root_match[215]),
     .error_val(error_val[1727:1720]));

wire [71:0] val_emp_217;
wire [7:0] sum_of_odds_217 =
     elprt_217[15:8] ^
     elprt_217[31:24] ^
     elprt_217[47:40] ^
     elprt_217[63:56];

error_value_round evr216 (.emp_in(val_emp_216),
     .emp_out(val_emp_217),
     .deriv_term(sum_of_odds_217),
     .error_pos(root_match[216]),
     .error_val(error_val[1735:1728]));

wire [71:0] val_emp_218;
wire [7:0] sum_of_odds_218 =
     elprt_218[15:8] ^
     elprt_218[31:24] ^
     elprt_218[47:40] ^
     elprt_218[63:56];

error_value_round evr217 (.emp_in(val_emp_217),
     .emp_out(val_emp_218),
     .deriv_term(sum_of_odds_218),
     .error_pos(root_match[217]),
     .error_val(error_val[1743:1736]));

wire [71:0] val_emp_219;
wire [7:0] sum_of_odds_219 =
     elprt_219[15:8] ^
     elprt_219[31:24] ^
     elprt_219[47:40] ^
     elprt_219[63:56];

error_value_round evr218 (.emp_in(val_emp_218),
     .emp_out(val_emp_219),
     .deriv_term(sum_of_odds_219),
     .error_pos(root_match[218]),
     .error_val(error_val[1751:1744]));

wire [71:0] val_emp_220;
wire [7:0] sum_of_odds_220 =
     elprt_220[15:8] ^
     elprt_220[31:24] ^
     elprt_220[47:40] ^
     elprt_220[63:56];

error_value_round evr219 (.emp_in(val_emp_219),
     .emp_out(val_emp_220),
     .deriv_term(sum_of_odds_220),
     .error_pos(root_match[219]),
     .error_val(error_val[1759:1752]));

wire [71:0] val_emp_221;
wire [7:0] sum_of_odds_221 =
     elprt_221[15:8] ^
     elprt_221[31:24] ^
     elprt_221[47:40] ^
     elprt_221[63:56];

error_value_round evr220 (.emp_in(val_emp_220),
     .emp_out(val_emp_221),
     .deriv_term(sum_of_odds_221),
     .error_pos(root_match[220]),
     .error_val(error_val[1767:1760]));

wire [71:0] val_emp_222;
wire [7:0] sum_of_odds_222 =
     elprt_222[15:8] ^
     elprt_222[31:24] ^
     elprt_222[47:40] ^
     elprt_222[63:56];

error_value_round evr221 (.emp_in(val_emp_221),
     .emp_out(val_emp_222),
     .deriv_term(sum_of_odds_222),
     .error_pos(root_match[221]),
     .error_val(error_val[1775:1768]));

wire [71:0] val_emp_223;
wire [7:0] sum_of_odds_223 =
     elprt_223[15:8] ^
     elprt_223[31:24] ^
     elprt_223[47:40] ^
     elprt_223[63:56];

error_value_round evr222 (.emp_in(val_emp_222),
     .emp_out(val_emp_223),
     .deriv_term(sum_of_odds_223),
     .error_pos(root_match[222]),
     .error_val(error_val[1783:1776]));

wire [71:0] val_emp_224;
wire [7:0] sum_of_odds_224 =
     elprt_224[15:8] ^
     elprt_224[31:24] ^
     elprt_224[47:40] ^
     elprt_224[63:56];

error_value_round evr223 (.emp_in(val_emp_223),
     .emp_out(val_emp_224),
     .deriv_term(sum_of_odds_224),
     .error_pos(root_match[223]),
     .error_val(error_val[1791:1784]));

wire [71:0] val_emp_225;
wire [7:0] sum_of_odds_225 =
     elprt_225[15:8] ^
     elprt_225[31:24] ^
     elprt_225[47:40] ^
     elprt_225[63:56];

error_value_round evr224 (.emp_in(val_emp_224),
     .emp_out(val_emp_225),
     .deriv_term(sum_of_odds_225),
     .error_pos(root_match[224]),
     .error_val(error_val[1799:1792]));

wire [71:0] val_emp_226;
wire [7:0] sum_of_odds_226 =
     elprt_226[15:8] ^
     elprt_226[31:24] ^
     elprt_226[47:40] ^
     elprt_226[63:56];

error_value_round evr225 (.emp_in(val_emp_225),
     .emp_out(val_emp_226),
     .deriv_term(sum_of_odds_226),
     .error_pos(root_match[225]),
     .error_val(error_val[1807:1800]));

wire [71:0] val_emp_227;
wire [7:0] sum_of_odds_227 =
     elprt_227[15:8] ^
     elprt_227[31:24] ^
     elprt_227[47:40] ^
     elprt_227[63:56];

error_value_round evr226 (.emp_in(val_emp_226),
     .emp_out(val_emp_227),
     .deriv_term(sum_of_odds_227),
     .error_pos(root_match[226]),
     .error_val(error_val[1815:1808]));

wire [71:0] val_emp_228;
wire [7:0] sum_of_odds_228 =
     elprt_228[15:8] ^
     elprt_228[31:24] ^
     elprt_228[47:40] ^
     elprt_228[63:56];

error_value_round evr227 (.emp_in(val_emp_227),
     .emp_out(val_emp_228),
     .deriv_term(sum_of_odds_228),
     .error_pos(root_match[227]),
     .error_val(error_val[1823:1816]));

wire [71:0] val_emp_229;
wire [7:0] sum_of_odds_229 =
     elprt_229[15:8] ^
     elprt_229[31:24] ^
     elprt_229[47:40] ^
     elprt_229[63:56];

error_value_round evr228 (.emp_in(val_emp_228),
     .emp_out(val_emp_229),
     .deriv_term(sum_of_odds_229),
     .error_pos(root_match[228]),
     .error_val(error_val[1831:1824]));

wire [71:0] val_emp_230;
wire [7:0] sum_of_odds_230 =
     elprt_230[15:8] ^
     elprt_230[31:24] ^
     elprt_230[47:40] ^
     elprt_230[63:56];

error_value_round evr229 (.emp_in(val_emp_229),
     .emp_out(val_emp_230),
     .deriv_term(sum_of_odds_230),
     .error_pos(root_match[229]),
     .error_val(error_val[1839:1832]));

wire [71:0] val_emp_231;
wire [7:0] sum_of_odds_231 =
     elprt_231[15:8] ^
     elprt_231[31:24] ^
     elprt_231[47:40] ^
     elprt_231[63:56];

error_value_round evr230 (.emp_in(val_emp_230),
     .emp_out(val_emp_231),
     .deriv_term(sum_of_odds_231),
     .error_pos(root_match[230]),
     .error_val(error_val[1847:1840]));

wire [71:0] val_emp_232;
wire [7:0] sum_of_odds_232 =
     elprt_232[15:8] ^
     elprt_232[31:24] ^
     elprt_232[47:40] ^
     elprt_232[63:56];

error_value_round evr231 (.emp_in(val_emp_231),
     .emp_out(val_emp_232),
     .deriv_term(sum_of_odds_232),
     .error_pos(root_match[231]),
     .error_val(error_val[1855:1848]));

wire [71:0] val_emp_233;
wire [7:0] sum_of_odds_233 =
     elprt_233[15:8] ^
     elprt_233[31:24] ^
     elprt_233[47:40] ^
     elprt_233[63:56];

error_value_round evr232 (.emp_in(val_emp_232),
     .emp_out(val_emp_233),
     .deriv_term(sum_of_odds_233),
     .error_pos(root_match[232]),
     .error_val(error_val[1863:1856]));

wire [71:0] val_emp_234;
wire [7:0] sum_of_odds_234 =
     elprt_234[15:8] ^
     elprt_234[31:24] ^
     elprt_234[47:40] ^
     elprt_234[63:56];

error_value_round evr233 (.emp_in(val_emp_233),
     .emp_out(val_emp_234),
     .deriv_term(sum_of_odds_234),
     .error_pos(root_match[233]),
     .error_val(error_val[1871:1864]));

wire [71:0] val_emp_235;
wire [7:0] sum_of_odds_235 =
     elprt_235[15:8] ^
     elprt_235[31:24] ^
     elprt_235[47:40] ^
     elprt_235[63:56];

error_value_round evr234 (.emp_in(val_emp_234),
     .emp_out(val_emp_235),
     .deriv_term(sum_of_odds_235),
     .error_pos(root_match[234]),
     .error_val(error_val[1879:1872]));

wire [71:0] val_emp_236;
wire [7:0] sum_of_odds_236 =
     elprt_236[15:8] ^
     elprt_236[31:24] ^
     elprt_236[47:40] ^
     elprt_236[63:56];

error_value_round evr235 (.emp_in(val_emp_235),
     .emp_out(val_emp_236),
     .deriv_term(sum_of_odds_236),
     .error_pos(root_match[235]),
     .error_val(error_val[1887:1880]));

wire [71:0] val_emp_237;
wire [7:0] sum_of_odds_237 =
     elprt_237[15:8] ^
     elprt_237[31:24] ^
     elprt_237[47:40] ^
     elprt_237[63:56];

error_value_round evr236 (.emp_in(val_emp_236),
     .emp_out(val_emp_237),
     .deriv_term(sum_of_odds_237),
     .error_pos(root_match[236]),
     .error_val(error_val[1895:1888]));

wire [71:0] val_emp_238;
wire [7:0] sum_of_odds_238 =
     elprt_238[15:8] ^
     elprt_238[31:24] ^
     elprt_238[47:40] ^
     elprt_238[63:56];

error_value_round evr237 (.emp_in(val_emp_237),
     .emp_out(val_emp_238),
     .deriv_term(sum_of_odds_238),
     .error_pos(root_match[237]),
     .error_val(error_val[1903:1896]));

wire [71:0] val_emp_239;
wire [7:0] sum_of_odds_239 =
     elprt_239[15:8] ^
     elprt_239[31:24] ^
     elprt_239[47:40] ^
     elprt_239[63:56];

error_value_round evr238 (.emp_in(val_emp_238),
     .emp_out(val_emp_239),
     .deriv_term(sum_of_odds_239),
     .error_pos(root_match[238]),
     .error_val(error_val[1911:1904]));

wire [71:0] val_emp_240;
wire [7:0] sum_of_odds_240 =
     elprt_240[15:8] ^
     elprt_240[31:24] ^
     elprt_240[47:40] ^
     elprt_240[63:56];

error_value_round evr239 (.emp_in(val_emp_239),
     .emp_out(val_emp_240),
     .deriv_term(sum_of_odds_240),
     .error_pos(root_match[239]),
     .error_val(error_val[1919:1912]));

wire [71:0] val_emp_241;
wire [7:0] sum_of_odds_241 =
     elprt_241[15:8] ^
     elprt_241[31:24] ^
     elprt_241[47:40] ^
     elprt_241[63:56];

error_value_round evr240 (.emp_in(val_emp_240),
     .emp_out(val_emp_241),
     .deriv_term(sum_of_odds_241),
     .error_pos(root_match[240]),
     .error_val(error_val[1927:1920]));

wire [71:0] val_emp_242;
wire [7:0] sum_of_odds_242 =
     elprt_242[15:8] ^
     elprt_242[31:24] ^
     elprt_242[47:40] ^
     elprt_242[63:56];

error_value_round evr241 (.emp_in(val_emp_241),
     .emp_out(val_emp_242),
     .deriv_term(sum_of_odds_242),
     .error_pos(root_match[241]),
     .error_val(error_val[1935:1928]));

wire [71:0] val_emp_243;
wire [7:0] sum_of_odds_243 =
     elprt_243[15:8] ^
     elprt_243[31:24] ^
     elprt_243[47:40] ^
     elprt_243[63:56];

error_value_round evr242 (.emp_in(val_emp_242),
     .emp_out(val_emp_243),
     .deriv_term(sum_of_odds_243),
     .error_pos(root_match[242]),
     .error_val(error_val[1943:1936]));

wire [71:0] val_emp_244;
wire [7:0] sum_of_odds_244 =
     elprt_244[15:8] ^
     elprt_244[31:24] ^
     elprt_244[47:40] ^
     elprt_244[63:56];

error_value_round evr243 (.emp_in(val_emp_243),
     .emp_out(val_emp_244),
     .deriv_term(sum_of_odds_244),
     .error_pos(root_match[243]),
     .error_val(error_val[1951:1944]));

wire [71:0] val_emp_245;
wire [7:0] sum_of_odds_245 =
     elprt_245[15:8] ^
     elprt_245[31:24] ^
     elprt_245[47:40] ^
     elprt_245[63:56];

error_value_round evr244 (.emp_in(val_emp_244),
     .emp_out(val_emp_245),
     .deriv_term(sum_of_odds_245),
     .error_pos(root_match[244]),
     .error_val(error_val[1959:1952]));

wire [71:0] val_emp_246;
wire [7:0] sum_of_odds_246 =
     elprt_246[15:8] ^
     elprt_246[31:24] ^
     elprt_246[47:40] ^
     elprt_246[63:56];

error_value_round evr245 (.emp_in(val_emp_245),
     .emp_out(val_emp_246),
     .deriv_term(sum_of_odds_246),
     .error_pos(root_match[245]),
     .error_val(error_val[1967:1960]));

wire [71:0] val_emp_247;
wire [7:0] sum_of_odds_247 =
     elprt_247[15:8] ^
     elprt_247[31:24] ^
     elprt_247[47:40] ^
     elprt_247[63:56];

error_value_round evr246 (.emp_in(val_emp_246),
     .emp_out(val_emp_247),
     .deriv_term(sum_of_odds_247),
     .error_pos(root_match[246]),
     .error_val(error_val[1975:1968]));

wire [71:0] val_emp_248;
wire [7:0] sum_of_odds_248 =
     elprt_248[15:8] ^
     elprt_248[31:24] ^
     elprt_248[47:40] ^
     elprt_248[63:56];

error_value_round evr247 (.emp_in(val_emp_247),
     .emp_out(val_emp_248),
     .deriv_term(sum_of_odds_248),
     .error_pos(root_match[247]),
     .error_val(error_val[1983:1976]));

wire [71:0] val_emp_249;
wire [7:0] sum_of_odds_249 =
     elprt_249[15:8] ^
     elprt_249[31:24] ^
     elprt_249[47:40] ^
     elprt_249[63:56];

error_value_round evr248 (.emp_in(val_emp_248),
     .emp_out(val_emp_249),
     .deriv_term(sum_of_odds_249),
     .error_pos(root_match[248]),
     .error_val(error_val[1991:1984]));

wire [71:0] val_emp_250;
wire [7:0] sum_of_odds_250 =
     elprt_250[15:8] ^
     elprt_250[31:24] ^
     elprt_250[47:40] ^
     elprt_250[63:56];

error_value_round evr249 (.emp_in(val_emp_249),
     .emp_out(val_emp_250),
     .deriv_term(sum_of_odds_250),
     .error_pos(root_match[249]),
     .error_val(error_val[1999:1992]));

wire [71:0] val_emp_251;
wire [7:0] sum_of_odds_251 =
     elprt_251[15:8] ^
     elprt_251[31:24] ^
     elprt_251[47:40] ^
     elprt_251[63:56];

error_value_round evr250 (.emp_in(val_emp_250),
     .emp_out(val_emp_251),
     .deriv_term(sum_of_odds_251),
     .error_pos(root_match[250]),
     .error_val(error_val[2007:2000]));

wire [71:0] val_emp_252;
wire [7:0] sum_of_odds_252 =
     elprt_252[15:8] ^
     elprt_252[31:24] ^
     elprt_252[47:40] ^
     elprt_252[63:56];

error_value_round evr251 (.emp_in(val_emp_251),
     .emp_out(val_emp_252),
     .deriv_term(sum_of_odds_252),
     .error_pos(root_match[251]),
     .error_val(error_val[2015:2008]));

wire [71:0] val_emp_253;
wire [7:0] sum_of_odds_253 =
     elprt_253[15:8] ^
     elprt_253[31:24] ^
     elprt_253[47:40] ^
     elprt_253[63:56];

error_value_round evr252 (.emp_in(val_emp_252),
     .emp_out(val_emp_253),
     .deriv_term(sum_of_odds_253),
     .error_pos(root_match[252]),
     .error_val(error_val[2023:2016]));

wire [71:0] val_emp_254;
wire [7:0] sum_of_odds_254 =
     elprt_254[15:8] ^
     elprt_254[31:24] ^
     elprt_254[47:40] ^
     elprt_254[63:56];

error_value_round evr253 (.emp_in(val_emp_253),
     .emp_out(val_emp_254),
     .deriv_term(sum_of_odds_254),
     .error_pos(root_match[253]),
     .error_val(error_val[2031:2024]));

wire [71:0] val_emp_255;
wire [7:0] sum_of_odds_255 =
     elprt_255[15:8] ^
     elprt_255[31:24] ^
     elprt_255[47:40] ^
     elprt_255[63:56];

error_value_round evr254 (.emp_in(val_emp_254),
     .emp_out(val_emp_255),
     .deriv_term(sum_of_odds_255),
     .error_pos(root_match[254]),
     .error_val(error_val[2039:2032]));

//////////////////////////////
// Apply correction values
//////////////////////////////

assign rx_data_corrected[7:0] = rx_data[7:0] ^ error_val[2039:2032];
assign rx_data_corrected[15:8] = rx_data[15:8] ^ error_val[2031:2024];
assign rx_data_corrected[23:16] = rx_data[23:16] ^ error_val[2023:2016];
assign rx_data_corrected[31:24] = rx_data[31:24] ^ error_val[2015:2008];
assign rx_data_corrected[39:32] = rx_data[39:32] ^ error_val[2007:2000];
assign rx_data_corrected[47:40] = rx_data[47:40] ^ error_val[1999:1992];
assign rx_data_corrected[55:48] = rx_data[55:48] ^ error_val[1991:1984];
assign rx_data_corrected[63:56] = rx_data[63:56] ^ error_val[1983:1976];
assign rx_data_corrected[71:64] = rx_data[71:64] ^ error_val[1975:1968];
assign rx_data_corrected[79:72] = rx_data[79:72] ^ error_val[1967:1960];
assign rx_data_corrected[87:80] = rx_data[87:80] ^ error_val[1959:1952];
assign rx_data_corrected[95:88] = rx_data[95:88] ^ error_val[1951:1944];
assign rx_data_corrected[103:96] = rx_data[103:96] ^ error_val[1943:1936];
assign rx_data_corrected[111:104] = rx_data[111:104] ^ error_val[1935:1928];
assign rx_data_corrected[119:112] = rx_data[119:112] ^ error_val[1927:1920];
assign rx_data_corrected[127:120] = rx_data[127:120] ^ error_val[1919:1912];
assign rx_data_corrected[135:128] = rx_data[135:128] ^ error_val[1911:1904];
assign rx_data_corrected[143:136] = rx_data[143:136] ^ error_val[1903:1896];
assign rx_data_corrected[151:144] = rx_data[151:144] ^ error_val[1895:1888];
assign rx_data_corrected[159:152] = rx_data[159:152] ^ error_val[1887:1880];
assign rx_data_corrected[167:160] = rx_data[167:160] ^ error_val[1879:1872];
assign rx_data_corrected[175:168] = rx_data[175:168] ^ error_val[1871:1864];
assign rx_data_corrected[183:176] = rx_data[183:176] ^ error_val[1863:1856];
assign rx_data_corrected[191:184] = rx_data[191:184] ^ error_val[1855:1848];
assign rx_data_corrected[199:192] = rx_data[199:192] ^ error_val[1847:1840];
assign rx_data_corrected[207:200] = rx_data[207:200] ^ error_val[1839:1832];
assign rx_data_corrected[215:208] = rx_data[215:208] ^ error_val[1831:1824];
assign rx_data_corrected[223:216] = rx_data[223:216] ^ error_val[1823:1816];
assign rx_data_corrected[231:224] = rx_data[231:224] ^ error_val[1815:1808];
assign rx_data_corrected[239:232] = rx_data[239:232] ^ error_val[1807:1800];
assign rx_data_corrected[247:240] = rx_data[247:240] ^ error_val[1799:1792];
assign rx_data_corrected[255:248] = rx_data[255:248] ^ error_val[1791:1784];
assign rx_data_corrected[263:256] = rx_data[263:256] ^ error_val[1783:1776];
assign rx_data_corrected[271:264] = rx_data[271:264] ^ error_val[1775:1768];
assign rx_data_corrected[279:272] = rx_data[279:272] ^ error_val[1767:1760];
assign rx_data_corrected[287:280] = rx_data[287:280] ^ error_val[1759:1752];
assign rx_data_corrected[295:288] = rx_data[295:288] ^ error_val[1751:1744];
assign rx_data_corrected[303:296] = rx_data[303:296] ^ error_val[1743:1736];
assign rx_data_corrected[311:304] = rx_data[311:304] ^ error_val[1735:1728];
assign rx_data_corrected[319:312] = rx_data[319:312] ^ error_val[1727:1720];
assign rx_data_corrected[327:320] = rx_data[327:320] ^ error_val[1719:1712];
assign rx_data_corrected[335:328] = rx_data[335:328] ^ error_val[1711:1704];
assign rx_data_corrected[343:336] = rx_data[343:336] ^ error_val[1703:1696];
assign rx_data_corrected[351:344] = rx_data[351:344] ^ error_val[1695:1688];
assign rx_data_corrected[359:352] = rx_data[359:352] ^ error_val[1687:1680];
assign rx_data_corrected[367:360] = rx_data[367:360] ^ error_val[1679:1672];
assign rx_data_corrected[375:368] = rx_data[375:368] ^ error_val[1671:1664];
assign rx_data_corrected[383:376] = rx_data[383:376] ^ error_val[1663:1656];
assign rx_data_corrected[391:384] = rx_data[391:384] ^ error_val[1655:1648];
assign rx_data_corrected[399:392] = rx_data[399:392] ^ error_val[1647:1640];
assign rx_data_corrected[407:400] = rx_data[407:400] ^ error_val[1639:1632];
assign rx_data_corrected[415:408] = rx_data[415:408] ^ error_val[1631:1624];
assign rx_data_corrected[423:416] = rx_data[423:416] ^ error_val[1623:1616];
assign rx_data_corrected[431:424] = rx_data[431:424] ^ error_val[1615:1608];
assign rx_data_corrected[439:432] = rx_data[439:432] ^ error_val[1607:1600];
assign rx_data_corrected[447:440] = rx_data[447:440] ^ error_val[1599:1592];
assign rx_data_corrected[455:448] = rx_data[455:448] ^ error_val[1591:1584];
assign rx_data_corrected[463:456] = rx_data[463:456] ^ error_val[1583:1576];
assign rx_data_corrected[471:464] = rx_data[471:464] ^ error_val[1575:1568];
assign rx_data_corrected[479:472] = rx_data[479:472] ^ error_val[1567:1560];
assign rx_data_corrected[487:480] = rx_data[487:480] ^ error_val[1559:1552];
assign rx_data_corrected[495:488] = rx_data[495:488] ^ error_val[1551:1544];
assign rx_data_corrected[503:496] = rx_data[503:496] ^ error_val[1543:1536];
assign rx_data_corrected[511:504] = rx_data[511:504] ^ error_val[1535:1528];
assign rx_data_corrected[519:512] = rx_data[519:512] ^ error_val[1527:1520];
assign rx_data_corrected[527:520] = rx_data[527:520] ^ error_val[1519:1512];
assign rx_data_corrected[535:528] = rx_data[535:528] ^ error_val[1511:1504];
assign rx_data_corrected[543:536] = rx_data[543:536] ^ error_val[1503:1496];
assign rx_data_corrected[551:544] = rx_data[551:544] ^ error_val[1495:1488];
assign rx_data_corrected[559:552] = rx_data[559:552] ^ error_val[1487:1480];
assign rx_data_corrected[567:560] = rx_data[567:560] ^ error_val[1479:1472];
assign rx_data_corrected[575:568] = rx_data[575:568] ^ error_val[1471:1464];
assign rx_data_corrected[583:576] = rx_data[583:576] ^ error_val[1463:1456];
assign rx_data_corrected[591:584] = rx_data[591:584] ^ error_val[1455:1448];
assign rx_data_corrected[599:592] = rx_data[599:592] ^ error_val[1447:1440];
assign rx_data_corrected[607:600] = rx_data[607:600] ^ error_val[1439:1432];
assign rx_data_corrected[615:608] = rx_data[615:608] ^ error_val[1431:1424];
assign rx_data_corrected[623:616] = rx_data[623:616] ^ error_val[1423:1416];
assign rx_data_corrected[631:624] = rx_data[631:624] ^ error_val[1415:1408];
assign rx_data_corrected[639:632] = rx_data[639:632] ^ error_val[1407:1400];
assign rx_data_corrected[647:640] = rx_data[647:640] ^ error_val[1399:1392];
assign rx_data_corrected[655:648] = rx_data[655:648] ^ error_val[1391:1384];
assign rx_data_corrected[663:656] = rx_data[663:656] ^ error_val[1383:1376];
assign rx_data_corrected[671:664] = rx_data[671:664] ^ error_val[1375:1368];
assign rx_data_corrected[679:672] = rx_data[679:672] ^ error_val[1367:1360];
assign rx_data_corrected[687:680] = rx_data[687:680] ^ error_val[1359:1352];
assign rx_data_corrected[695:688] = rx_data[695:688] ^ error_val[1351:1344];
assign rx_data_corrected[703:696] = rx_data[703:696] ^ error_val[1343:1336];
assign rx_data_corrected[711:704] = rx_data[711:704] ^ error_val[1335:1328];
assign rx_data_corrected[719:712] = rx_data[719:712] ^ error_val[1327:1320];
assign rx_data_corrected[727:720] = rx_data[727:720] ^ error_val[1319:1312];
assign rx_data_corrected[735:728] = rx_data[735:728] ^ error_val[1311:1304];
assign rx_data_corrected[743:736] = rx_data[743:736] ^ error_val[1303:1296];
assign rx_data_corrected[751:744] = rx_data[751:744] ^ error_val[1295:1288];
assign rx_data_corrected[759:752] = rx_data[759:752] ^ error_val[1287:1280];
assign rx_data_corrected[767:760] = rx_data[767:760] ^ error_val[1279:1272];
assign rx_data_corrected[775:768] = rx_data[775:768] ^ error_val[1271:1264];
assign rx_data_corrected[783:776] = rx_data[783:776] ^ error_val[1263:1256];
assign rx_data_corrected[791:784] = rx_data[791:784] ^ error_val[1255:1248];
assign rx_data_corrected[799:792] = rx_data[799:792] ^ error_val[1247:1240];
assign rx_data_corrected[807:800] = rx_data[807:800] ^ error_val[1239:1232];
assign rx_data_corrected[815:808] = rx_data[815:808] ^ error_val[1231:1224];
assign rx_data_corrected[823:816] = rx_data[823:816] ^ error_val[1223:1216];
assign rx_data_corrected[831:824] = rx_data[831:824] ^ error_val[1215:1208];
assign rx_data_corrected[839:832] = rx_data[839:832] ^ error_val[1207:1200];
assign rx_data_corrected[847:840] = rx_data[847:840] ^ error_val[1199:1192];
assign rx_data_corrected[855:848] = rx_data[855:848] ^ error_val[1191:1184];
assign rx_data_corrected[863:856] = rx_data[863:856] ^ error_val[1183:1176];
assign rx_data_corrected[871:864] = rx_data[871:864] ^ error_val[1175:1168];
assign rx_data_corrected[879:872] = rx_data[879:872] ^ error_val[1167:1160];
assign rx_data_corrected[887:880] = rx_data[887:880] ^ error_val[1159:1152];
assign rx_data_corrected[895:888] = rx_data[895:888] ^ error_val[1151:1144];
assign rx_data_corrected[903:896] = rx_data[903:896] ^ error_val[1143:1136];
assign rx_data_corrected[911:904] = rx_data[911:904] ^ error_val[1135:1128];
assign rx_data_corrected[919:912] = rx_data[919:912] ^ error_val[1127:1120];
assign rx_data_corrected[927:920] = rx_data[927:920] ^ error_val[1119:1112];
assign rx_data_corrected[935:928] = rx_data[935:928] ^ error_val[1111:1104];
assign rx_data_corrected[943:936] = rx_data[943:936] ^ error_val[1103:1096];
assign rx_data_corrected[951:944] = rx_data[951:944] ^ error_val[1095:1088];
assign rx_data_corrected[959:952] = rx_data[959:952] ^ error_val[1087:1080];
assign rx_data_corrected[967:960] = rx_data[967:960] ^ error_val[1079:1072];
assign rx_data_corrected[975:968] = rx_data[975:968] ^ error_val[1071:1064];
assign rx_data_corrected[983:976] = rx_data[983:976] ^ error_val[1063:1056];
assign rx_data_corrected[991:984] = rx_data[991:984] ^ error_val[1055:1048];
assign rx_data_corrected[999:992] = rx_data[999:992] ^ error_val[1047:1040];
assign rx_data_corrected[1007:1000] = rx_data[1007:1000] ^ error_val[1039:1032];
assign rx_data_corrected[1015:1008] = rx_data[1015:1008] ^ error_val[1031:1024];
assign rx_data_corrected[1023:1016] = rx_data[1023:1016] ^ error_val[1023:1016];
assign rx_data_corrected[1031:1024] = rx_data[1031:1024] ^ error_val[1015:1008];
assign rx_data_corrected[1039:1032] = rx_data[1039:1032] ^ error_val[1007:1000];
assign rx_data_corrected[1047:1040] = rx_data[1047:1040] ^ error_val[999:992];
assign rx_data_corrected[1055:1048] = rx_data[1055:1048] ^ error_val[991:984];
assign rx_data_corrected[1063:1056] = rx_data[1063:1056] ^ error_val[983:976];
assign rx_data_corrected[1071:1064] = rx_data[1071:1064] ^ error_val[975:968];
assign rx_data_corrected[1079:1072] = rx_data[1079:1072] ^ error_val[967:960];
assign rx_data_corrected[1087:1080] = rx_data[1087:1080] ^ error_val[959:952];
assign rx_data_corrected[1095:1088] = rx_data[1095:1088] ^ error_val[951:944];
assign rx_data_corrected[1103:1096] = rx_data[1103:1096] ^ error_val[943:936];
assign rx_data_corrected[1111:1104] = rx_data[1111:1104] ^ error_val[935:928];
assign rx_data_corrected[1119:1112] = rx_data[1119:1112] ^ error_val[927:920];
assign rx_data_corrected[1127:1120] = rx_data[1127:1120] ^ error_val[919:912];
assign rx_data_corrected[1135:1128] = rx_data[1135:1128] ^ error_val[911:904];
assign rx_data_corrected[1143:1136] = rx_data[1143:1136] ^ error_val[903:896];
assign rx_data_corrected[1151:1144] = rx_data[1151:1144] ^ error_val[895:888];
assign rx_data_corrected[1159:1152] = rx_data[1159:1152] ^ error_val[887:880];
assign rx_data_corrected[1167:1160] = rx_data[1167:1160] ^ error_val[879:872];
assign rx_data_corrected[1175:1168] = rx_data[1175:1168] ^ error_val[871:864];
assign rx_data_corrected[1183:1176] = rx_data[1183:1176] ^ error_val[863:856];
assign rx_data_corrected[1191:1184] = rx_data[1191:1184] ^ error_val[855:848];
assign rx_data_corrected[1199:1192] = rx_data[1199:1192] ^ error_val[847:840];
assign rx_data_corrected[1207:1200] = rx_data[1207:1200] ^ error_val[839:832];
assign rx_data_corrected[1215:1208] = rx_data[1215:1208] ^ error_val[831:824];
assign rx_data_corrected[1223:1216] = rx_data[1223:1216] ^ error_val[823:816];
assign rx_data_corrected[1231:1224] = rx_data[1231:1224] ^ error_val[815:808];
assign rx_data_corrected[1239:1232] = rx_data[1239:1232] ^ error_val[807:800];
assign rx_data_corrected[1247:1240] = rx_data[1247:1240] ^ error_val[799:792];
assign rx_data_corrected[1255:1248] = rx_data[1255:1248] ^ error_val[791:784];
assign rx_data_corrected[1263:1256] = rx_data[1263:1256] ^ error_val[783:776];
assign rx_data_corrected[1271:1264] = rx_data[1271:1264] ^ error_val[775:768];
assign rx_data_corrected[1279:1272] = rx_data[1279:1272] ^ error_val[767:760];
assign rx_data_corrected[1287:1280] = rx_data[1287:1280] ^ error_val[759:752];
assign rx_data_corrected[1295:1288] = rx_data[1295:1288] ^ error_val[751:744];
assign rx_data_corrected[1303:1296] = rx_data[1303:1296] ^ error_val[743:736];
assign rx_data_corrected[1311:1304] = rx_data[1311:1304] ^ error_val[735:728];
assign rx_data_corrected[1319:1312] = rx_data[1319:1312] ^ error_val[727:720];
assign rx_data_corrected[1327:1320] = rx_data[1327:1320] ^ error_val[719:712];
assign rx_data_corrected[1335:1328] = rx_data[1335:1328] ^ error_val[711:704];
assign rx_data_corrected[1343:1336] = rx_data[1343:1336] ^ error_val[703:696];
assign rx_data_corrected[1351:1344] = rx_data[1351:1344] ^ error_val[695:688];
assign rx_data_corrected[1359:1352] = rx_data[1359:1352] ^ error_val[687:680];
assign rx_data_corrected[1367:1360] = rx_data[1367:1360] ^ error_val[679:672];
assign rx_data_corrected[1375:1368] = rx_data[1375:1368] ^ error_val[671:664];
assign rx_data_corrected[1383:1376] = rx_data[1383:1376] ^ error_val[663:656];
assign rx_data_corrected[1391:1384] = rx_data[1391:1384] ^ error_val[655:648];
assign rx_data_corrected[1399:1392] = rx_data[1399:1392] ^ error_val[647:640];
assign rx_data_corrected[1407:1400] = rx_data[1407:1400] ^ error_val[639:632];
assign rx_data_corrected[1415:1408] = rx_data[1415:1408] ^ error_val[631:624];
assign rx_data_corrected[1423:1416] = rx_data[1423:1416] ^ error_val[623:616];
assign rx_data_corrected[1431:1424] = rx_data[1431:1424] ^ error_val[615:608];
assign rx_data_corrected[1439:1432] = rx_data[1439:1432] ^ error_val[607:600];
assign rx_data_corrected[1447:1440] = rx_data[1447:1440] ^ error_val[599:592];
assign rx_data_corrected[1455:1448] = rx_data[1455:1448] ^ error_val[591:584];
assign rx_data_corrected[1463:1456] = rx_data[1463:1456] ^ error_val[583:576];
assign rx_data_corrected[1471:1464] = rx_data[1471:1464] ^ error_val[575:568];
assign rx_data_corrected[1479:1472] = rx_data[1479:1472] ^ error_val[567:560];
assign rx_data_corrected[1487:1480] = rx_data[1487:1480] ^ error_val[559:552];
assign rx_data_corrected[1495:1488] = rx_data[1495:1488] ^ error_val[551:544];
assign rx_data_corrected[1503:1496] = rx_data[1503:1496] ^ error_val[543:536];
assign rx_data_corrected[1511:1504] = rx_data[1511:1504] ^ error_val[535:528];
assign rx_data_corrected[1519:1512] = rx_data[1519:1512] ^ error_val[527:520];
assign rx_data_corrected[1527:1520] = rx_data[1527:1520] ^ error_val[519:512];
assign rx_data_corrected[1535:1528] = rx_data[1535:1528] ^ error_val[511:504];
assign rx_data_corrected[1543:1536] = rx_data[1543:1536] ^ error_val[503:496];
assign rx_data_corrected[1551:1544] = rx_data[1551:1544] ^ error_val[495:488];
assign rx_data_corrected[1559:1552] = rx_data[1559:1552] ^ error_val[487:480];
assign rx_data_corrected[1567:1560] = rx_data[1567:1560] ^ error_val[479:472];
assign rx_data_corrected[1575:1568] = rx_data[1575:1568] ^ error_val[471:464];
assign rx_data_corrected[1583:1576] = rx_data[1583:1576] ^ error_val[463:456];
assign rx_data_corrected[1591:1584] = rx_data[1591:1584] ^ error_val[455:448];
assign rx_data_corrected[1599:1592] = rx_data[1599:1592] ^ error_val[447:440];
assign rx_data_corrected[1607:1600] = rx_data[1607:1600] ^ error_val[439:432];
assign rx_data_corrected[1615:1608] = rx_data[1615:1608] ^ error_val[431:424];
assign rx_data_corrected[1623:1616] = rx_data[1623:1616] ^ error_val[423:416];
assign rx_data_corrected[1631:1624] = rx_data[1631:1624] ^ error_val[415:408];
assign rx_data_corrected[1639:1632] = rx_data[1639:1632] ^ error_val[407:400];
assign rx_data_corrected[1647:1640] = rx_data[1647:1640] ^ error_val[399:392];
assign rx_data_corrected[1655:1648] = rx_data[1655:1648] ^ error_val[391:384];
assign rx_data_corrected[1663:1656] = rx_data[1663:1656] ^ error_val[383:376];
assign rx_data_corrected[1671:1664] = rx_data[1671:1664] ^ error_val[375:368];
assign rx_data_corrected[1679:1672] = rx_data[1679:1672] ^ error_val[367:360];
assign rx_data_corrected[1687:1680] = rx_data[1687:1680] ^ error_val[359:352];
assign rx_data_corrected[1695:1688] = rx_data[1695:1688] ^ error_val[351:344];
assign rx_data_corrected[1703:1696] = rx_data[1703:1696] ^ error_val[343:336];
assign rx_data_corrected[1711:1704] = rx_data[1711:1704] ^ error_val[335:328];
assign rx_data_corrected[1719:1712] = rx_data[1719:1712] ^ error_val[327:320];
assign rx_data_corrected[1727:1720] = rx_data[1727:1720] ^ error_val[319:312];
assign rx_data_corrected[1735:1728] = rx_data[1735:1728] ^ error_val[311:304];
assign rx_data_corrected[1743:1736] = rx_data[1743:1736] ^ error_val[303:296];
assign rx_data_corrected[1751:1744] = rx_data[1751:1744] ^ error_val[295:288];
assign rx_data_corrected[1759:1752] = rx_data[1759:1752] ^ error_val[287:280];
assign rx_data_corrected[1767:1760] = rx_data[1767:1760] ^ error_val[279:272];
assign rx_data_corrected[1775:1768] = rx_data[1775:1768] ^ error_val[271:264];
assign rx_data_corrected[1783:1776] = rx_data[1783:1776] ^ error_val[263:256];
assign rx_data_corrected[1791:1784] = rx_data[1791:1784] ^ error_val[255:248];
assign rx_data_corrected[1799:1792] = rx_data[1799:1792] ^ error_val[247:240];
assign rx_data_corrected[1807:1800] = rx_data[1807:1800] ^ error_val[239:232];
assign rx_data_corrected[1815:1808] = rx_data[1815:1808] ^ error_val[231:224];
assign rx_data_corrected[1823:1816] = rx_data[1823:1816] ^ error_val[223:216];
assign rx_data_corrected[1831:1824] = rx_data[1831:1824] ^ error_val[215:208];
assign rx_data_corrected[1839:1832] = rx_data[1839:1832] ^ error_val[207:200];
assign rx_data_corrected[1847:1840] = rx_data[1847:1840] ^ error_val[199:192];
assign rx_data_corrected[1855:1848] = rx_data[1855:1848] ^ error_val[191:184];
assign rx_data_corrected[1863:1856] = rx_data[1863:1856] ^ error_val[183:176];
assign rx_data_corrected[1871:1864] = rx_data[1871:1864] ^ error_val[175:168];
assign rx_data_corrected[1879:1872] = rx_data[1879:1872] ^ error_val[167:160];
assign rx_data_corrected[1887:1880] = rx_data[1887:1880] ^ error_val[159:152];
assign rx_data_corrected[1895:1888] = rx_data[1895:1888] ^ error_val[151:144];
assign rx_data_corrected[1903:1896] = rx_data[1903:1896] ^ error_val[143:136];
assign rx_data_corrected[1911:1904] = rx_data[1911:1904] ^ error_val[135:128];
assign rx_data_corrected[1919:1912] = rx_data[1919:1912] ^ error_val[127:120];
assign rx_data_corrected[1927:1920] = rx_data[1927:1920] ^ error_val[119:112];
assign rx_data_corrected[1935:1928] = rx_data[1935:1928] ^ error_val[111:104];
assign rx_data_corrected[1943:1936] = rx_data[1943:1936] ^ error_val[103:96];
assign rx_data_corrected[1951:1944] = rx_data[1951:1944] ^ error_val[95:88];
assign rx_data_corrected[1959:1952] = rx_data[1959:1952] ^ error_val[87:80];
assign rx_data_corrected[1967:1960] = rx_data[1967:1960] ^ error_val[79:72];
assign rx_data_corrected[1975:1968] = rx_data[1975:1968] ^ error_val[71:64];
assign rx_data_corrected[1983:1976] = rx_data[1983:1976] ^ error_val[63:56];
assign rx_data_corrected[1991:1984] = rx_data[1991:1984] ^ error_val[55:48];
assign rx_data_corrected[1999:1992] = rx_data[1999:1992] ^ error_val[47:40];
assign rx_data_corrected[2007:2000] = rx_data[2007:2000] ^ error_val[39:32];
assign rx_data_corrected[2015:2008] = rx_data[2015:2008] ^ error_val[31:24];
assign rx_data_corrected[2023:2016] = rx_data[2023:2016] ^ error_val[23:16];
assign rx_data_corrected[2031:2024] = rx_data[2031:2024] ^ error_val[15:8];
assign rx_data_corrected[2039:2032] = rx_data[2039:2032] ^ error_val[7:0];
endmodule

///////////////////////////////////////////

module flat_decoder_tb ();
reg [7:0] din;
reg clk,rst,first_din;
wire [127:0] parity;
reg [1911:0] tx_buffer;
wire [2039:0] tx_data = {tx_buffer,parity};
reg [2039:0] err;
wire [2039:0] rx_data = tx_data ^ err;
wire [2039:0] rx_data_corrected;

encoder enc (.clk(clk),.ena(1'b1),.rst(rst),.shift(1'b0),.first_din(first_din),.din(din),.parity(parity));

flat_decoder fd (.rx_data(rx_data),.rx_data_corrected(rx_data_corrected));

initial begin
  clk = 0;
  rst = 0;
  first_din = 1'b1;
  #10 rst = 1;
  #10 rst = 0;
end

always begin
  #1000 clk = ~clk;
end

always @(negedge clk) begin
  din = $random;
end

always @(posedge clk) begin
  tx_buffer = (tx_buffer << 8) | din;
end

integer i;
initial begin
  #100
  @(negedge clk);
  err = 0;
  first_din = 1'b1;
  @(posedge clk);
  @(negedge clk);
  first_din = 1'b0;
  for (i=0; i<238; i=i+1) begin
    @(posedge clk);
    @(negedge clk);
  end
  $display ("tx data %x",tx_data);
  $display ("  correct rx data %x",rx_data);
  $display ("    rx_data_corrected %x",rx_data_corrected);
  if (rx_data_corrected !== tx_data) begin
    $display ("Error : correct data was fixed incorrectly?");
    $stop();
  end
  #1 err = 1'b1;
  for (i=0; i<2040; i=i+1) begin
    #1
    $display ("  rx data with error%x",rx_data);
    $display ("    rx_data_corrected %x",rx_data_corrected);
    if (rx_data_corrected !== tx_data) begin
      $display ("Error : data was not corrected");
      $stop();
    end
    err = err << 1;
  end
  $display ("PASS");
  $stop();
end

endmodule

///////////////////////////////////////////
// Iterative TX unit
///////////////////////////////////////////

module reed_sol_tx (
   clk,rst,
   first_din,din,din_valid,ready_for_din,
   dout,dout_valid
);

input clk,rst;
input first_din;  // 1 for the first symbol of each word
input [7:0] din; // most significant symbol first
input din_valid;		// din data is valid
output ready_for_din;  // din will be accepted
output [7:0] dout;        // TX data out
output dout_valid;         // TX data is valid

reg [7:0] dout;
reg dout_valid,ready_for_din;

reg [7:0] symbol_cntr;

wire enc_ena;
wire [127:0] parity;

assign enc_ena = !ready_for_din | din_valid;
encoder enc (.clk(clk),.rst(rst),.ena(enc_ena),.shift(!ready_for_din),
   .first_din(first_din),.din(din),.parity(parity));

always @(posedge clk or posedge rst) begin
  if (rst) begin
      symbol_cntr <= 0;
      ready_for_din <= 1'b1;
      dout_valid <= 1'b0;
  end
  else begin
      if (ready_for_din) begin
          if (din_valid) begin
              // Pass the data symbols along
              dout <= din;
              dout_valid <= 1'b1;
              symbol_cntr <= symbol_cntr + 1'b1;
              if (symbol_cntr == 238) begin
                 // data is complete, start sending parity next
                 ready_for_din <= 1'b0;
              end
          end
          else begin
              // I want more data, it's not available yet
              dout_valid <= 1'b0;
          end
      end
      else begin
          // Send the parity symbols
          symbol_cntr <= symbol_cntr + 1'b1;
          dout <= parity[127:120];
          dout_valid <= 1'b1;
          if (symbol_cntr == 254) begin
              // parity almost complete, request more data
              ready_for_din <= 1'b1;
              symbol_cntr <= 0;
          end
      end
  end
end
endmodule

///////////////////////////////////////////
// Iterative RX unit
///////////////////////////////////////////

module reed_sol_rx (
   clk,rst,
   first_din,din,din_valid,ready_for_din,
   dout,dout_valid,corrected_bits,failure
);

input clk,rst;
input first_din;  // 1 for the first symbol of each word
input [7:0] din; // most significant symbol first
input din_valid;		  // din data is valid
output ready_for_din;    // din will be accepted
output [7:0] dout;        // Corrected data out
output dout_valid;         // data out available
output [7:0] corrected_bits;   // bits changed to fix dout
output failure;            // too many errors to correct this symbol

reg [7:0] dout;
reg [7:0] corrected_bits;
reg dout_valid,ready_for_din,failure;

reg [7:0] symbol_cntr;

/////////////////////////////////
// syndrome computation
/////////////////////////////////
reg [127:0] syndrome;
wire [127:0] next_syndrome;
reg syndrome_ready,leading_syndrome_ready;

wire syndrome_ena = ready_for_din & din_valid;
syndrome_round sr (.rx_data (din),
       .syndrome_in(first_din ? 128'b0 : syndrome),
       .syndrome_out(next_syndrome),
       .skip_mult(leading_syndrome_ready)
);

always @(posedge clk or posedge rst) begin
  if (rst) begin
    syndrome <= 128'b0;
    syndrome_ready <= 1'b0;
    leading_syndrome_ready <= 1'b0;
    symbol_cntr <= 0;
    ready_for_din <= 1'b1;
  end
  else begin
    if (syndrome_ena) begin
        syndrome <= next_syndrome;
        if (symbol_cntr == 254) begin
            // syndrome is complete
            // accept more immediately, and signal syn ready
            ready_for_din <= 1'b1;
            syndrome_ready <= 1'b1;
            leading_syndrome_ready <= 1'b0;
            symbol_cntr <= 0;
        end
        else begin
            if (symbol_cntr == 253) begin
               leading_syndrome_ready <= 1'b1;
            end
            symbol_cntr <= symbol_cntr + 1'b1;
            syndrome_ready <= 1'b0;
        end
    end
  end
end

////////////////////////////////////////
// Error location poly computation
////////////////////////////////////////

reg [4:0] step;
reg [3:0] order;
wire [3:0] next_order;
reg [127:0] elp;
wire [127:0] next_elp;
reg [127:0] step_syndrome;
reg [127:0] saved_syndrome;
reg [127:0] correction;
wire [127:0] next_correction;

wire elp_ena = 1'b1;
reg last_syndrome_ready;
reg elp_ready;
reg first_elp;
wire final_elp = (step == 16) ? 1'b1 : 1'b0;
wire elpr_wait;

always @(posedge clk or posedge rst) begin
  if (rst) first_elp <= 1'b0;
  else begin
    if (leading_syndrome_ready) first_elp <= 1'b1;
    else if (!elpr_wait) first_elp <= 1'b0;
  end
end

error_loc_poly_round_multi_step elpr (
    .step(step),
    .order_in(order),
    .order_out(next_order),
    .elp_in(elp),
    .elp_out(next_elp),
    .step_syndrome(step_syndrome),
    .correction_in(correction),
    .clk(clk),.rst(rst),.sync(leading_syndrome_ready),
    .elpr_wait(elpr_wait),
    .correction_out(next_correction));
always @(posedge clk or posedge rst) begin
  if (rst) begin
      step <= 0;
      order <= 0;
      correction <= 0;
      step_syndrome <= 0;
      elp_ready <= 1'b0;
  end
  else if (elp_ena) begin
      if (leading_syndrome_ready) begin
         step <= 1;
         order <= 0;
         correction <= {120'b1,8'b0};
         elp <= 128'b1;
         step_syndrome <= {120'b0,next_syndrome[7:0]};
         elp_ready <= 1'b0;
      end
      else if (!elpr_wait & first_elp) begin
         saved_syndrome <= syndrome;
         step_syndrome <= {112'b0,syndrome[7:0],syndrome[15:8]};
         step <= 2;
         correction <= next_correction;
         order <= next_order;
         elp <= next_elp;
      end
      else if (!elpr_wait & !elp_ready) begin
         step <= step + 1'b1;
         step_syndrome <= {step_syndrome[119:0],saved_syndrome[23:16]};
         saved_syndrome <= {saved_syndrome [7:0],saved_syndrome[127:8]};
         correction <= next_correction;
         order <= next_order;
         elp <= next_elp;
         if (final_elp) elp_ready <= 1'b1;
      end
  end
end

/////////////////////////////////////////////
// Error magnitude poly computation
//   error mag poly has terms 0..v-1 for v errors
//   derived from the syndrome (S0..Sv-1) and 
//   the ELP (0..v-1)
/////////////////////////////////////////////

reg [71:0] step_elp;
reg [127:0] elp_mirror;
wire [7:0] emp_term;
reg [63:0] emp;
reg emp_ready;
wire emp_ena = 1'b1;
reg [3:0] emp_cntr;

wire final_emp = (emp_cntr == 7) ? 1'b1 : 1'b0;
error_mag_poly_round empr (
    .step_elp(step_elp),
    .syndrome(saved_syndrome[79:8]),
    .emp_term(emp_term));

always @(posedge clk or posedge rst) begin
  if (rst) begin
      emp <= 0;
      emp_ready <= 0;
      step_elp <= 0;
  end
  else if (emp_ena) begin
      if (final_elp) begin
         // mirror the low ELP register during the last ELP computation
         elp_mirror <= next_elp[71:0];
         step_elp <= {64'b0,next_elp[7:0]};
         emp_ready <= 1'b0;
         emp_cntr <= 0;
      end
      else if (!emp_ready) begin
         emp_cntr <= emp_cntr + 1'b1;
         step_elp <= {step_elp[63:0],elp_mirror[15:8]};
         elp_mirror <= elp_mirror >> 8;
         if (final_emp) emp_ready <= 1'b1;
         emp <= {emp_term,emp[63:8]};
      end
  end
end

///////////////////////////////////////////////
// ELP Roots (bad symbols in the word)
// and Error values (bad bits in the symbol)
///////////////////////////////////////////////

reg [71:0] root_step_elp;
wire [71:0] next_root_step_elp;
wire root_match;
reg last_root_match;
reg last_emp_ready;
reg [7:0] root_cntr;
reg roots_pending;
wire root_ena = 1'b1;

// generate a pulse when the new EMP is available
always @(posedge clk or posedge rst) begin
  if (rst) last_emp_ready <= 1'b0;
  else last_emp_ready <= emp_ready;
end

// find the roots of the error location poly.
// The ELP will be stable before the EMP is ready
error_loc_poly_roots root (
    .elp_in(root_step_elp),
	 .elp_out(next_root_step_elp),
    .match(root_match));

always @(posedge clk or posedge rst) begin
  if (rst) begin
      last_root_match <= 0;
      root_step_elp <= 0;
      root_cntr <= 0;
      roots_pending <= 0;
  end
  else if (root_ena) begin
      if (final_emp) begin
         // while waiting for the the last EMP, load the ELP
         root_step_elp <= elp[71:0];
         root_cntr <= 0;
         roots_pending <= 1'b1;
      end
      else begin
         if (roots_pending) begin
             // Advancing through the roots...
             root_step_elp <= next_root_step_elp;
             if (root_cntr == 255) begin
                root_cntr <= 0;
                roots_pending <= 1'b0;
             end
             else begin
                root_cntr <= root_cntr + 1'b1;
             end
         end
      end
      last_root_match <= root_match;
  end
end

reg [71:0] step_emp;
wire [71:0] next_step_emp;

// the derivitive term is equal to the sum of the 
// odd terms of the working ELP from the root search
wire [7:0] deriv_term =
     root_step_elp[15:8] ^
     root_step_elp[31:24] ^
     root_step_elp[47:40] ^
     root_step_elp[63:56];

wire [7:0] error_val;

// this is running 1 tick behind the root finder
// to use the root_match and derivitive output signals
error_value_round eval (
    .emp_in(step_emp),
    .emp_out(next_step_emp),
    .deriv_term(deriv_term),
    .error_pos(last_root_match),
    .error_val(error_val));

always @(posedge clk or posedge rst) begin
  if (rst) begin
      step_emp <= 0;
  end
  else if (root_ena) begin
      if (emp_ready & !last_emp_ready) begin
         step_emp <= emp;
      end
      else begin
         step_emp <= next_step_emp;
      end
  end
end

///////////////////////////////////////////////
// Delay the data in and mix with the correction
// to form output
///////////////////////////////////////////////

reg [3055:0] data_delay;
always @(posedge clk) begin
  if (syndrome_ena) data_delay <= {din,data_delay[3055:8]};
end

// don't aclear the delay buffer, so it can go in RAM
// but do fix it for simulation
initial begin
  data_delay <= 0;
end
always @(posedge clk or posedge rst) begin
  if (rst) begin
      dout <= 1'b0;
      dout_valid <= 1'b0;
  end
  else begin
      if (| root_cntr) begin
        dout <= data_delay[7:0] ^ error_val;
        corrected_bits <= error_val;
        dout_valid <= 1'b1;
      end
  end
end

endmodule

///////////////////////////////////////////
// Iterative TX / RX testbench
///////////////////////////////////////////

module reed_sol_tb ();

reg clk,rst,tx_first_din;
reg [7:0] tx_din;
wire [7:0] tx_dout;
wire tx_dout_valid,tx_ready_for_din;
reg tx_din_valid;
reg [2039:0] line_noise;
integer bytes_sent,bytes_rxd;

   reed_sol_tx tx (
       .clk(clk),.rst(rst),
       .first_din(tx_first_din),.din(tx_din),.din_valid(tx_din_valid),
       .ready_for_din(tx_ready_for_din),
       .dout(tx_dout),.dout_valid(tx_dout_valid));

initial begin
  clk = 0;
  rst = 0;
  tx_din = 0;
  tx_din_valid = 1'b1;
  tx_first_din = 1'b1;
  bytes_sent = 0;
  bytes_rxd = 0;
  line_noise = {1992'b0,48'h00d0_0000_0200};
  #10 rst = 1;
  #10 rst = 0;
end

always begin
  #100 clk = ~clk;
end

reg [1911:0] original_msg;
always @(posedge clk or posedge rst) begin
   if (rst) begin
       original_msg <= 0;
       bytes_sent <= 0;
   end else begin
     if (tx_ready_for_din) begin
       original_msg <= (original_msg << 8) | tx_din;
       bytes_sent <= (bytes_sent + 1'b1) % 239;
     end
   end
end

always @(negedge clk) begin
  //tx_din = (tx_din+1'b1) % 255;
  tx_din = $random;
  tx_first_din = ((bytes_sent == 0) ? 1'b1 : 1'b0);
end

reg rx_first_din;
wire [7:0] rx_din;
wire [7:0] rx_dout;
wire [7:0] corrected_bits;
wire failure;
wire rx_dout_valid,rx_ready_for_din;
wire rx_din_valid;

// update the noise pattern
always @(posedge clk) begin
  if (rx_din_valid) line_noise <= {line_noise[2032:0],line_noise[2039:2032]};
end

// XOR in line noise for the RX end
assign rx_din = tx_dout ^ line_noise[2039:2032];
assign rx_din_valid = tx_dout_valid;
   reed_sol_rx rx (
       .clk(clk),.rst(rst),
       .first_din(rx_first_din),
       .din(rx_din),
       .din_valid(rx_din_valid),
       .ready_for_din(rx_ready_for_din),
       .dout(rx_dout),
       .dout_valid(rx_dout_valid),
       .corrected_bits(corrected_bits),
       .failure(failure)
);

always @(posedge clk or posedge rst) begin
   if (rst) begin
       bytes_rxd <= 0;
   end else begin
     if (rx_ready_for_din && rx_din_valid) begin
       bytes_rxd <= (bytes_rxd + 1'b1) % 255;
     end
   end
end

reg [2039:0] recovered_msg;
integer bytes_recovered = 0;
always @(posedge clk) begin
  if (rx_dout_valid) begin
     recovered_msg <= (recovered_msg << 8) | rx_dout;
     bytes_recovered <= (bytes_recovered + 1'b1) % 255;
  end
end

always @(negedge clk) begin
  rx_first_din = ((bytes_rxd == 0) ? 1'b1 : 1'b0);
end

reg [1911:0] original_msg0;
reg [1911:0] original_msg1;
reg [1911:0] original_msg2;
always @(posedge clk) begin
  if ((bytes_sent == 0) && tx_ready_for_din) begin
     $display ("Sent %x",original_msg);
     original_msg0 <= original_msg;
     original_msg1 <= original_msg0;
     original_msg2 <= original_msg1;
  end
  if (bytes_recovered == 0) begin
     $display ("Recovered %x ",recovered_msg);
     $display ("  should be %x",original_msg1);
     if (recovered_msg[2039:128] !== original_msg1) begin
        $display ("MISMATCH");
        $display ("  pattern %x",original_msg1 ^ recovered_msg[2039:128]);
     end else begin
        $display ("OK");
     end
  end
end

endmodule

//////////////////////////////////////////
// GF mult / div correctness testbench 
//////////////////////////////////////////

module gf_math_tb();
reg fail = 1'b0;
reg [7:0] a,b;
wire [7:0] om0,om1,om2,om3,om4,om5,om6,oi0,oi1;

// multipliers - (all equivalent)
gf_mult m0 (.a(a),.b(b),.o(om0));
gf_mult m1 (.a(a),.b(b),.o(om1));
gf_mult m2 (.a(b),.b(a),.o(om2));
gf_mult m3 (.a(b),.b(a),.o(om3));
gf_mult m6 (.a(a),.b(b),.o(om6));
defparam m0 .METHOD = 0;
defparam m1 .METHOD = 1;
defparam m2 .METHOD = 0;
defparam m3 .METHOD = 1;
defparam m6 .METHOD = 2;

// mult. inverse
gf_inverse i0 (.i(a),.o(oi0));
gf_inverse i1 (.i(b),.o(oi1));

// pseudo divide
gf_mult m4 (.a(om0),.b(oi0),.o(om4));
defparam m4 .METHOD = 0;
gf_mult m5 (.a(om0),.b(oi1),.o(om5));
defparam m5 .METHOD = 0;

// verify
always begin
  #10
  a = $random;
  b = $random;
  #10
  if (om0 !== om1) fail = 1;
  if (om0 !== om2) fail = 1;
  if (om0 !== om3) fail = 1;
  if (om0 !== om6) fail = 1;
  if (om4 !== b && a !== 0) fail = 1;
  if (om5 !== a && b !== 0) fail = 1;
end

initial begin
  #1000000 if (!fail) begin
    $display ("PASS");
    $stop();
  end
  else begin
    $display ("FAIL");
    $stop();
  end
end

endmodule

