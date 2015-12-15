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

// baeckler - 08-25-2006 

//////////////////////////////////////////
// 64 bit to 72 bit ECC encoder
//////////////////////////////////////////

module ecc_encode_64bit (d,c);

input [63:0] d;
output [71:0] c;
wire [71:0] c;

  wire [5:0] help_c0;
  xor6 help_c0_0 (help_c0[0],d[0],d[1],d[3],d[4],d[6],d[8]);
  xor6 help_c0_1 (help_c0[1],d[10],d[11],d[13],d[15],d[17],d[19]);
  xor6 help_c0_2 (help_c0[2],d[21],d[23],d[25],d[26],d[28],d[30]);
  xor6 help_c0_3 (help_c0[3],d[32],d[34],d[36],d[38],d[40],d[42]);
  xor6 help_c0_4 (help_c0[4],d[44],d[46],d[48],d[50],d[52],d[54]);
  xor6 help_c0_5 (help_c0[5],d[56],d[57],d[59],d[61],d[63],1'b0);
  assign c[0] = ^help_c0;

  wire [5:0] help_c1;
  xor6 help_c1_0 (help_c1[0],d[0],d[2],d[3],d[5],d[6],d[9]);
  xor6 help_c1_1 (help_c1[1],d[10],d[12],d[13],d[16],d[17],d[20]);
  xor6 help_c1_2 (help_c1[2],d[21],d[24],d[25],d[27],d[28],d[31]);
  xor6 help_c1_3 (help_c1[3],d[32],d[35],d[36],d[39],d[40],d[43]);
  xor6 help_c1_4 (help_c1[4],d[44],d[47],d[48],d[51],d[52],d[55]);
  xor6 help_c1_5 (help_c1[5],d[56],d[58],d[59],d[62],d[63],1'b0);
  assign c[1] = ^help_c1;

  assign c[2] = d[0];
  wire [5:0] help_c3;
  xor6 help_c3_0 (help_c3[0],d[1],d[2],d[3],d[7],d[8],d[9]);
  xor6 help_c3_1 (help_c3[1],d[10],d[14],d[15],d[16],d[17],d[22]);
  xor6 help_c3_2 (help_c3[2],d[23],d[24],d[25],d[29],d[30],d[31]);
  xor6 help_c3_3 (help_c3[3],d[32],d[37],d[38],d[39],d[40],d[45]);
  xor6 help_c3_4 (help_c3[4],d[46],d[47],d[48],d[53],d[54],d[55]);
  xor6 help_c3_5 (help_c3[5],d[56],d[60],d[61],d[62],d[63],1'b0);
  assign c[3] = ^help_c3;

  assign c[4] = d[1];
  assign c[5] = d[2];
  assign c[6] = d[3];
  wire [5:0] help_c7;
  xor6 help_c7_0 (help_c7[0],d[4],d[5],d[6],d[7],d[8],d[9]);
  xor6 help_c7_1 (help_c7[1],d[10],d[18],d[19],d[20],d[21],d[22]);
  xor6 help_c7_2 (help_c7[2],d[23],d[24],d[25],d[33],d[34],d[35]);
  xor6 help_c7_3 (help_c7[3],d[36],d[37],d[38],d[39],d[40],d[49]);
  xor6 help_c7_4 (help_c7[4],d[50],d[51],d[52],d[53],d[54],d[55]);
  assign help_c7[5] = d[56];
  assign c[7] = ^help_c7;

  assign c[8] = d[4];
  assign c[9] = d[5];
  assign c[10] = d[6];
  assign c[11] = d[7];
  assign c[12] = d[8];
  assign c[13] = d[9];
  assign c[14] = d[10];
  wire [5:0] help_c15;
  xor6 help_c15_0 (help_c15[0],d[11],d[12],d[13],d[14],d[15],d[16]);
  xor6 help_c15_1 (help_c15[1],d[17],d[18],d[19],d[20],d[21],d[22]);
  xor6 help_c15_2 (help_c15[2],d[23],d[24],d[25],d[41],d[42],d[43]);
  xor6 help_c15_3 (help_c15[3],d[44],d[45],d[46],d[47],d[48],d[49]);
  xor6 help_c15_4 (help_c15[4],d[50],d[51],d[52],d[53],d[54],d[55]);
  assign help_c15[5] = d[56];
  assign c[15] = ^help_c15;

  assign c[16] = d[11];
  assign c[17] = d[12];
  assign c[18] = d[13];
  assign c[19] = d[14];
  assign c[20] = d[15];
  assign c[21] = d[16];
  assign c[22] = d[17];
  assign c[23] = d[18];
  assign c[24] = d[19];
  assign c[25] = d[20];
  assign c[26] = d[21];
  assign c[27] = d[22];
  assign c[28] = d[23];
  assign c[29] = d[24];
  assign c[30] = d[25];
  wire [5:0] help_c31;
  xor6 help_c31_0 (help_c31[0],d[26],d[27],d[28],d[29],d[30],d[31]);
  xor6 help_c31_1 (help_c31[1],d[32],d[33],d[34],d[35],d[36],d[37]);
  xor6 help_c31_2 (help_c31[2],d[38],d[39],d[40],d[41],d[42],d[43]);
  xor6 help_c31_3 (help_c31[3],d[44],d[45],d[46],d[47],d[48],d[49]);
  xor6 help_c31_4 (help_c31[4],d[50],d[51],d[52],d[53],d[54],d[55]);
  assign help_c31[5] = d[56];
  assign c[31] = ^help_c31;

  assign c[32] = d[26];
  assign c[33] = d[27];
  assign c[34] = d[28];
  assign c[35] = d[29];
  assign c[36] = d[30];
  assign c[37] = d[31];
  assign c[38] = d[32];
  assign c[39] = d[33];
  assign c[40] = d[34];
  assign c[41] = d[35];
  assign c[42] = d[36];
  assign c[43] = d[37];
  assign c[44] = d[38];
  assign c[45] = d[39];
  assign c[46] = d[40];
  assign c[47] = d[41];
  assign c[48] = d[42];
  assign c[49] = d[43];
  assign c[50] = d[44];
  assign c[51] = d[45];
  assign c[52] = d[46];
  assign c[53] = d[47];
  assign c[54] = d[48];
  assign c[55] = d[49];
  assign c[56] = d[50];
  assign c[57] = d[51];
  assign c[58] = d[52];
  assign c[59] = d[53];
  assign c[60] = d[54];
  assign c[61] = d[55];
  assign c[62] = d[56];
  wire [1:0] help_c63;
  xor6 help_c63_0 (help_c63[0],d[57],d[58],d[59],d[60],d[61],d[62]);
  assign help_c63[1] = d[63];
  assign c[63] = ^help_c63;

  assign c[64] = d[57];
  assign c[65] = d[58];
  assign c[66] = d[59];
  assign c[67] = d[60];
  assign c[68] = d[61];
  assign c[69] = d[62];
  assign c[70] = d[63];
  wire [5:0] help_c71;
  xor6 help_c71_0 (help_c71[0],d[0],d[1],d[2],d[4],d[5],d[7]);
  xor6 help_c71_1 (help_c71[1],d[10],d[11],d[12],d[14],d[17],d[18]);
  xor6 help_c71_2 (help_c71[2],d[21],d[23],d[24],d[26],d[27],d[29]);
  xor6 help_c71_3 (help_c71[3],d[32],d[33],d[36],d[38],d[39],d[41]);
  xor6 help_c71_4 (help_c71[4],d[44],d[46],d[47],d[50],d[51],d[53]);
  xor6 help_c71_5 (help_c71[5],d[56],d[57],d[58],d[60],d[63],1'b0);
  assign c[71] = ^help_c71;

endmodule

//////////////////////////////////////////
// compute a syndrome from the code word
//////////////////////////////////////////

module ecc_syndrome_64bit (clk,rst,c,s);

// optional register on the outputs
// of bits 0..6 and back one level in bit 7
parameter REGISTER = 0;

input clk,rst;
input [71:0] c;
output [7:0] s;
reg [7:0] s;

  // 36 terms
  wire [5:0] help_s0;
  xor6 help_s0_0 (help_s0[0],c[0],c[2],c[4],c[6],c[8],c[10]);
  xor6 help_s0_1 (help_s0[1],c[12],c[14],c[16],c[18],c[20],c[22]);
  xor6 help_s0_2 (help_s0[2],c[24],c[26],c[28],c[30],c[32],c[34]);
  xor6 help_s0_3 (help_s0[3],c[36],c[38],c[40],c[42],c[44],c[46]);
  xor6 help_s0_4 (help_s0[4],c[48],c[50],c[52],c[54],c[56],c[58]);
  xor6 help_s0_5 (help_s0[5],c[60],c[62],c[64],c[66],c[68],c[70]);
  generate
    if (REGISTER) begin
      always @(posedge clk or posedge rst) begin
        if (rst) s[0] <= 0;
        else s[0] <= ^help_s0;
      end
    end else begin
      always @(help_s0) begin
        s[0] = ^help_s0;
      end
    end
  endgenerate

  // 36 terms
  wire [5:0] help_s1;
  xor6 help_s1_0 (help_s1[0],c[1],c[2],c[5],c[6],c[9],c[10]);
  xor6 help_s1_1 (help_s1[1],c[13],c[14],c[17],c[18],c[21],c[22]);
  xor6 help_s1_2 (help_s1[2],c[25],c[26],c[29],c[30],c[33],c[34]);
  xor6 help_s1_3 (help_s1[3],c[37],c[38],c[41],c[42],c[45],c[46]);
  xor6 help_s1_4 (help_s1[4],c[49],c[50],c[53],c[54],c[57],c[58]);
  xor6 help_s1_5 (help_s1[5],c[61],c[62],c[65],c[66],c[69],c[70]);
  generate
    if (REGISTER) begin
      always @(posedge clk or posedge rst) begin
        if (rst) s[1] <= 0;
        else s[1] <= ^help_s1;
      end
    end else begin
      always @(help_s1) begin
        s[1] = ^help_s1;
      end
    end
  endgenerate

  // 36 terms
  wire [5:0] help_s2;
  xor6 help_s2_0 (help_s2[0],c[3],c[4],c[5],c[6],c[11],c[12]);
  xor6 help_s2_1 (help_s2[1],c[13],c[14],c[19],c[20],c[21],c[22]);
  xor6 help_s2_2 (help_s2[2],c[27],c[28],c[29],c[30],c[35],c[36]);
  xor6 help_s2_3 (help_s2[3],c[37],c[38],c[43],c[44],c[45],c[46]);
  xor6 help_s2_4 (help_s2[4],c[51],c[52],c[53],c[54],c[59],c[60]);
  xor6 help_s2_5 (help_s2[5],c[61],c[62],c[67],c[68],c[69],c[70]);
  generate
    if (REGISTER) begin
      always @(posedge clk or posedge rst) begin
        if (rst) s[2] <= 0;
        else s[2] <= ^help_s2;
      end
    end else begin
      always @(help_s2) begin
        s[2] = ^help_s2;
      end
    end
  endgenerate

  // 32 terms
  wire [5:0] help_s3;
  xor6 help_s3_0 (help_s3[0],c[7],c[8],c[9],c[10],c[11],c[12]);
  xor6 help_s3_1 (help_s3[1],c[13],c[14],c[23],c[24],c[25],c[26]);
  xor6 help_s3_2 (help_s3[2],c[27],c[28],c[29],c[30],c[39],c[40]);
  xor6 help_s3_3 (help_s3[3],c[41],c[42],c[43],c[44],c[45],c[46]);
  xor6 help_s3_4 (help_s3[4],c[55],c[56],c[57],c[58],c[59],c[60]);
  xor6 help_s3_5 (help_s3[5],c[61],c[62],1'b0,1'b0,1'b0,1'b0);
  generate
    if (REGISTER) begin
      always @(posedge clk or posedge rst) begin
        if (rst) s[3] <= 0;
        else s[3] <= ^help_s3;
      end
    end else begin
      always @(help_s3) begin
        s[3] = ^help_s3;
      end
    end
  endgenerate

  // 32 terms
  wire [5:0] help_s4;
  xor6 help_s4_0 (help_s4[0],c[15],c[16],c[17],c[18],c[19],c[20]);
  xor6 help_s4_1 (help_s4[1],c[21],c[22],c[23],c[24],c[25],c[26]);
  xor6 help_s4_2 (help_s4[2],c[27],c[28],c[29],c[30],c[47],c[48]);
  xor6 help_s4_3 (help_s4[3],c[49],c[50],c[51],c[52],c[53],c[54]);
  xor6 help_s4_4 (help_s4[4],c[55],c[56],c[57],c[58],c[59],c[60]);
  xor6 help_s4_5 (help_s4[5],c[61],c[62],1'b0,1'b0,1'b0,1'b0);
  generate
    if (REGISTER) begin
      always @(posedge clk or posedge rst) begin
        if (rst) s[4] <= 0;
        else s[4] <= ^help_s4;
      end
    end else begin
      always @(help_s4) begin
        s[4] = ^help_s4;
      end
    end
  endgenerate

  // 32 terms
  wire [5:0] help_s5;
  xor6 help_s5_0 (help_s5[0],c[31],c[32],c[33],c[34],c[35],c[36]);
  xor6 help_s5_1 (help_s5[1],c[37],c[38],c[39],c[40],c[41],c[42]);
  xor6 help_s5_2 (help_s5[2],c[43],c[44],c[45],c[46],c[47],c[48]);
  xor6 help_s5_3 (help_s5[3],c[49],c[50],c[51],c[52],c[53],c[54]);
  xor6 help_s5_4 (help_s5[4],c[55],c[56],c[57],c[58],c[59],c[60]);
  xor6 help_s5_5 (help_s5[5],c[61],c[62],1'b0,1'b0,1'b0,1'b0);
  generate
    if (REGISTER) begin
      always @(posedge clk or posedge rst) begin
        if (rst) s[5] <= 0;
        else s[5] <= ^help_s5;
      end
    end else begin
      always @(help_s5) begin
        s[5] = ^help_s5;
      end
    end
  endgenerate

  // 8 terms
  wire [1:0] help_s6;
  xor6 help_s6_0 (help_s6[0],c[63],c[64],c[65],c[66],c[67],c[68]);
  xor6 help_s6_1 (help_s6[1],c[69],c[70],1'b0,1'b0,1'b0,1'b0);
  generate
    if (REGISTER) begin
      always @(posedge clk or posedge rst) begin
        if (rst) s[6] <= 0;
        else s[6] <= ^help_s6;
      end
    end else begin
      always @(help_s6) begin
        s[6] = ^help_s6;
      end
    end
  endgenerate

  // 72 terms
  wire [11:0] help_s7;
  xor6 help_s7_0 (help_s7[0],c[0],c[1],c[2],c[3],c[4],c[5]);
  xor6 help_s7_1 (help_s7[1],c[6],c[7],c[8],c[9],c[10],c[11]);
  xor6 help_s7_2 (help_s7[2],c[12],c[13],c[14],c[15],c[16],c[17]);
  xor6 help_s7_3 (help_s7[3],c[18],c[19],c[20],c[21],c[22],c[23]);
  xor6 help_s7_4 (help_s7[4],c[24],c[25],c[26],c[27],c[28],c[29]);
  xor6 help_s7_5 (help_s7[5],c[30],c[31],c[32],c[33],c[34],c[35]);
  xor6 help_s7_6 (help_s7[6],c[36],c[37],c[38],c[39],c[40],c[41]);
  xor6 help_s7_7 (help_s7[7],c[42],c[43],c[44],c[45],c[46],c[47]);
  xor6 help_s7_8 (help_s7[8],c[48],c[49],c[50],c[51],c[52],c[53]);
  xor6 help_s7_9 (help_s7[9],c[54],c[55],c[56],c[57],c[58],c[59]);
  xor6 help_s7_10 (help_s7[10],c[60],c[61],c[62],c[63],c[64],c[65]);
  xor6 help_s7_11 (help_s7[11],c[66],c[67],c[68],c[69],c[70],c[71]);

  // the parity bit has too much fanin
  // register it a bit higher for balance
  reg [11:0] help_s7_r;
  generate
    if (REGISTER) begin
      always @(posedge clk or posedge rst) begin
        if (rst) help_s7_r <= 0;
        else help_s7_r <= help_s7;
      end
    end else begin
      always @(help_s7) begin
        help_s7_r = help_s7;
      end
    end
  endgenerate

  // group the parity helper XORs
  wire par_0, par_1;
  xor6 par_0x (par_0,help_s7_r[0],help_s7_r[1],help_s7_r[2],help_s7_r[3],help_s7_r[4],help_s7_r[5]);
  xor6 par_1x (par_1,help_s7_r[6],help_s7_r[7],help_s7_r[8],help_s7_r[9],help_s7_r[10],help_s7_r[11]);

  always @(par_0 or par_1) begin
    s[7] = par_0 ^ par_1;
  end

endmodule

//////////////////////////////////////////
// From the syndrome compute the correction
// needed to fix the data, or set fatal = 1
// and no correction if there are too many.
//////////////////////////////////////////
module ecc_correction_64bit (s,e,fatal);

input [7:0] s;
output [63:0] e;
output fatal;
wire [63:0] e;

  // decode the lower part of syndrome
  reg [63:0] d;
  wire [63:0] dw /* synthesis keep */;
  always @(s) begin
    d = 64'b0;
    d[s[5:0]] = 1'b1;
  end
  assign dw = d;

  // Identify uncorrectable errors
  // and unroll the s[6] ODC condition to help
  // synthesis get minimum depth
  wire or_syn50 = |(s[5:0]) /* synthesis keep */;
  wire fatal = (s[6] & !s[7]) | (or_syn50 & !s[7]);
  wire fatal_s6_cold = (or_syn50 & !s[7]);
  wire fatal_s6_hot = !s[7];
  assign e = {
    dw[7] & s[6] & !fatal_s6_hot,dw[6] & s[6] & !fatal_s6_hot,dw[5] & s[6] & !fatal_s6_hot,dw[4] & s[6] & !fatal_s6_hot,
    dw[3] & s[6] & !fatal_s6_hot,dw[2] & s[6] & !fatal_s6_hot,dw[1] & s[6] & !fatal_s6_hot,dw[63] & !s[6] & !fatal_s6_cold,
    dw[62] & !s[6] & !fatal_s6_cold,dw[61] & !s[6] & !fatal_s6_cold,dw[60] & !s[6] & !fatal_s6_cold,dw[59] & !s[6] & !fatal_s6_cold,
    dw[58] & !s[6] & !fatal_s6_cold,dw[57] & !s[6] & !fatal_s6_cold,dw[56] & !s[6] & !fatal_s6_cold,dw[55] & !s[6] & !fatal_s6_cold,
    dw[54] & !s[6] & !fatal_s6_cold,dw[53] & !s[6] & !fatal_s6_cold,dw[52] & !s[6] & !fatal_s6_cold,dw[51] & !s[6] & !fatal_s6_cold,
    dw[50] & !s[6] & !fatal_s6_cold,dw[49] & !s[6] & !fatal_s6_cold,dw[48] & !s[6] & !fatal_s6_cold,dw[47] & !s[6] & !fatal_s6_cold,
    dw[46] & !s[6] & !fatal_s6_cold,dw[45] & !s[6] & !fatal_s6_cold,dw[44] & !s[6] & !fatal_s6_cold,dw[43] & !s[6] & !fatal_s6_cold,
    dw[42] & !s[6] & !fatal_s6_cold,dw[41] & !s[6] & !fatal_s6_cold,dw[40] & !s[6] & !fatal_s6_cold,dw[39] & !s[6] & !fatal_s6_cold,
    dw[38] & !s[6] & !fatal_s6_cold,dw[37] & !s[6] & !fatal_s6_cold,dw[36] & !s[6] & !fatal_s6_cold,dw[35] & !s[6] & !fatal_s6_cold,
    dw[34] & !s[6] & !fatal_s6_cold,dw[33] & !s[6] & !fatal_s6_cold,dw[31] & !s[6] & !fatal_s6_cold,dw[30] & !s[6] & !fatal_s6_cold,
    dw[29] & !s[6] & !fatal_s6_cold,dw[28] & !s[6] & !fatal_s6_cold,dw[27] & !s[6] & !fatal_s6_cold,dw[26] & !s[6] & !fatal_s6_cold,
    dw[25] & !s[6] & !fatal_s6_cold,dw[24] & !s[6] & !fatal_s6_cold,dw[23] & !s[6] & !fatal_s6_cold,dw[22] & !s[6] & !fatal_s6_cold,
    dw[21] & !s[6] & !fatal_s6_cold,dw[20] & !s[6] & !fatal_s6_cold,dw[19] & !s[6] & !fatal_s6_cold,dw[18] & !s[6] & !fatal_s6_cold,
    dw[17] & !s[6] & !fatal_s6_cold,dw[15] & !s[6] & !fatal_s6_cold,dw[14] & !s[6] & !fatal_s6_cold,dw[13] & !s[6] & !fatal_s6_cold,
    dw[12] & !s[6] & !fatal_s6_cold,dw[11] & !s[6] & !fatal_s6_cold,dw[10] & !s[6] & !fatal_s6_cold,dw[9] & !s[6] & !fatal_s6_cold,
    dw[7] & !s[6] & !fatal_s6_cold,dw[6] & !s[6] & !fatal_s6_cold,dw[5] & !s[6] & !fatal_s6_cold,dw[3] & !s[6] & !fatal_s6_cold
    };


endmodule

//////////////////////////////////////////
// select the (uncorrected) data bits out
// of the code word.
//////////////////////////////////////////

module ecc_raw_data_64bit (clk,rst,c,d);
parameter REGISTER = 0;
input clk,rst;
input [71:0] c;
output [63:0] d;
reg [63:0] d;

wire [63:0] d_int;

  // pull out the pure data bits
  assign d_int = {
    c[70],c[69],c[68],c[67],c[66],c[65],c[64],c[62],
    c[61],c[60],c[59],c[58],c[57],c[56],c[55],c[54],
    c[53],c[52],c[51],c[50],c[49],c[48],c[47],c[46],
    c[45],c[44],c[43],c[42],c[41],c[40],c[39],c[38],
    c[37],c[36],c[35],c[34],c[33],c[32],c[30],c[29],
    c[28],c[27],c[26],c[25],c[24],c[23],c[22],c[21],
    c[20],c[19],c[18],c[17],c[16],c[14],c[13],c[12],
    c[11],c[10],c[9],c[8],c[6],c[5],c[4],c[2]
    };

  // conditional output register
  generate
  if (REGISTER) begin
    always @(posedge clk or posedge rst) begin
      if (rst) d <= 0;
      else d <= d_int;
    end
  end else begin
    always @(d_int) begin
      d <= d_int;
    end
  end
  endgenerate

endmodule

//////////////////////////////////////////
// 72 bit to 64 bit ECC decoder
//////////////////////////////////////////

module ecc_decode_64bit (clk,rst,c,d,no_err,err_corrected,err_fatal);

// optional pipeline registers at the halfway
// point and on the outputs
parameter MIDDLE_REG = 0;
parameter OUTPUT_REG = 0;

input clk,rst;
input [71:0] c;
output [63:0] d;
output no_err, err_corrected, err_fatal;

reg [63:0] d;
reg no_err, err_corrected, err_fatal;

  // Pull the raw (uncorrected) data from the codeword
  wire [63:0] raw_bits;
  ecc_raw_data_64bit raw (.clk(clk),.rst(rst),.c(c),.d(raw_bits));

    defparam raw .REGISTER = MIDDLE_REG;
  // Build syndrome, which will be 0 for correct
  // correct codewords, otherwise a pointer to the
  // error.
  wire [7:0] syndrome;
  ecc_syndrome_64bit syn (.clk(clk),.rst(rst),.c(c),.s(syndrome));
    defparam syn .REGISTER = MIDDLE_REG;

  // Use the the syndrome to find a correction, or 0 for no correction
  wire [63:0] err_flip;
  wire fatal;
  ecc_correction_64bit cor (.s(syndrome),.e(err_flip),.fatal(fatal));

  // Classify error types and correct data as appropriate
  // If there is a multibit error take care not to make 
  // the data worse.
  generate
    if (OUTPUT_REG) begin
      always @(posedge clk or posedge rst) begin
        if (rst) begin
          no_err <= 1'b0;
          err_corrected <= 1'b0;
          err_fatal <= 1'b0;
          d <= 1'b0;
        end else begin
          no_err <= ~| syndrome;
          err_corrected <= syndrome[7];
          err_fatal <= fatal;

          d <= err_flip ^ raw_bits;
        end
      end
    end else begin
      always @(*) begin
          no_err = ~| syndrome;
          err_corrected = syndrome[7];
          err_fatal = fatal;

          d = err_flip ^ raw_bits;
      end
    end
  endgenerate

endmodule

