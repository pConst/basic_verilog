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
// 32 bit to 39 bit ECC encoder
//////////////////////////////////////////

module ecc_encode_32bit (d,c);

input [31:0] d;
output [38:0] c;
wire [38:0] c;

  wire [2:0] help_c0;
  xor6 help_c0_0 (help_c0[0],d[0],d[1],d[3],d[4],d[6],d[8]);
  xor6 help_c0_1 (help_c0[1],d[10],d[11],d[13],d[15],d[17],d[19]);
  xor6 help_c0_2 (help_c0[2],d[21],d[23],d[25],d[26],d[28],d[30]);
  assign c[0] = ^help_c0;

  wire [2:0] help_c1;
  xor6 help_c1_0 (help_c1[0],d[0],d[2],d[3],d[5],d[6],d[9]);
  xor6 help_c1_1 (help_c1[1],d[10],d[12],d[13],d[16],d[17],d[20]);
  xor6 help_c1_2 (help_c1[2],d[21],d[24],d[25],d[27],d[28],d[31]);
  assign c[1] = ^help_c1;

  assign c[2] = d[0];
  wire [2:0] help_c3;
  xor6 help_c3_0 (help_c3[0],d[1],d[2],d[3],d[7],d[8],d[9]);
  xor6 help_c3_1 (help_c3[1],d[10],d[14],d[15],d[16],d[17],d[22]);
  xor6 help_c3_2 (help_c3[2],d[23],d[24],d[25],d[29],d[30],d[31]);
  assign c[3] = ^help_c3;

  assign c[4] = d[1];
  assign c[5] = d[2];
  assign c[6] = d[3];
  wire [2:0] help_c7;
  xor6 help_c7_0 (help_c7[0],d[4],d[5],d[6],d[7],d[8],d[9]);
  xor6 help_c7_1 (help_c7[1],d[10],d[18],d[19],d[20],d[21],d[22]);
  xor6 help_c7_2 (help_c7[2],d[23],d[24],d[25],1'b0,1'b0,1'b0);
  assign c[7] = ^help_c7;

  assign c[8] = d[4];
  assign c[9] = d[5];
  assign c[10] = d[6];
  assign c[11] = d[7];
  assign c[12] = d[8];
  assign c[13] = d[9];
  assign c[14] = d[10];
  wire [2:0] help_c15;
  xor6 help_c15_0 (help_c15[0],d[11],d[12],d[13],d[14],d[15],d[16]);
  xor6 help_c15_1 (help_c15[1],d[17],d[18],d[19],d[20],d[21],d[22]);
  xor6 help_c15_2 (help_c15[2],d[23],d[24],d[25],1'b0,1'b0,1'b0);
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
  wire [0:0] help_c31;
  xor6 help_c31_0 (help_c31[0],d[26],d[27],d[28],d[29],d[30],d[31]);
  assign c[31] = ^help_c31;

  assign c[32] = d[26];
  assign c[33] = d[27];
  assign c[34] = d[28];
  assign c[35] = d[29];
  assign c[36] = d[30];
  assign c[37] = d[31];
  wire [2:0] help_c38;
  xor6 help_c38_0 (help_c38[0],d[0],d[1],d[2],d[4],d[5],d[7]);
  xor6 help_c38_1 (help_c38[1],d[10],d[11],d[12],d[14],d[17],d[18]);
  xor6 help_c38_2 (help_c38[2],d[21],d[23],d[24],d[26],d[27],d[29]);
  assign c[38] = ^help_c38;

endmodule

//////////////////////////////////////////
// compute a syndrome from the code word
//////////////////////////////////////////

module ecc_syndrome_32bit (clk,rst,c,s);

// optional register on the outputs
// of bits 0..6 and back one level in bit 7
parameter REGISTER = 0;

input clk,rst;
input [38:0] c;
output [6:0] s;
reg [6:0] s;

  // 19 terms
  wire [3:0] help_s0;
  xor6 help_s0_0 (help_s0[0],c[0],c[2],c[4],c[6],c[8],c[10]);
  xor6 help_s0_1 (help_s0[1],c[12],c[14],c[16],c[18],c[20],c[22]);
  xor6 help_s0_2 (help_s0[2],c[24],c[26],c[28],c[30],c[32],c[34]);
  assign help_s0[3] = c[36];
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

  // 19 terms
  wire [3:0] help_s1;
  xor6 help_s1_0 (help_s1[0],c[1],c[2],c[5],c[6],c[9],c[10]);
  xor6 help_s1_1 (help_s1[1],c[13],c[14],c[17],c[18],c[21],c[22]);
  xor6 help_s1_2 (help_s1[2],c[25],c[26],c[29],c[30],c[33],c[34]);
  assign help_s1[3] = c[37];
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

  // 19 terms
  wire [3:0] help_s2;
  xor6 help_s2_0 (help_s2[0],c[3],c[4],c[5],c[6],c[11],c[12]);
  xor6 help_s2_1 (help_s2[1],c[13],c[14],c[19],c[20],c[21],c[22]);
  xor6 help_s2_2 (help_s2[2],c[27],c[28],c[29],c[30],c[35],c[36]);
  assign help_s2[3] = c[37];
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

  // 16 terms
  wire [2:0] help_s3;
  xor6 help_s3_0 (help_s3[0],c[7],c[8],c[9],c[10],c[11],c[12]);
  xor6 help_s3_1 (help_s3[1],c[13],c[14],c[23],c[24],c[25],c[26]);
  xor6 help_s3_2 (help_s3[2],c[27],c[28],c[29],c[30],1'b0,1'b0);
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

  // 16 terms
  wire [2:0] help_s4;
  xor6 help_s4_0 (help_s4[0],c[15],c[16],c[17],c[18],c[19],c[20]);
  xor6 help_s4_1 (help_s4[1],c[21],c[22],c[23],c[24],c[25],c[26]);
  xor6 help_s4_2 (help_s4[2],c[27],c[28],c[29],c[30],1'b0,1'b0);
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

  // 7 terms
  wire [1:0] help_s5;
  xor6 help_s5_0 (help_s5[0],c[31],c[32],c[33],c[34],c[35],c[36]);
  assign help_s5[1] = c[37];
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

  // 39 terms
  wire [6:0] help_s6;
  xor6 help_s6_0 (help_s6[0],c[0],c[1],c[2],c[3],c[4],c[5]);
  xor6 help_s6_1 (help_s6[1],c[6],c[7],c[8],c[9],c[10],c[11]);
  xor6 help_s6_2 (help_s6[2],c[12],c[13],c[14],c[15],c[16],c[17]);
  xor6 help_s6_3 (help_s6[3],c[18],c[19],c[20],c[21],c[22],c[23]);
  xor6 help_s6_4 (help_s6[4],c[24],c[25],c[26],c[27],c[28],c[29]);
  xor6 help_s6_5 (help_s6[5],c[30],c[31],c[32],c[33],c[34],c[35]);
  xor6 help_s6_6 (help_s6[6],c[36],c[37],c[38],1'b0,1'b0,1'b0);
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

endmodule

//////////////////////////////////////////
// From the syndrome compute the correction
// needed to fix the data, or set fatal = 1
// and no correction if there are too many.
//////////////////////////////////////////
module ecc_correction_32bit (s,e,fatal);

input [6:0] s;
output [31:0] e;
output fatal;
wire [31:0] e;

  // decode the syndrome
  reg [127:0] d;
  wire [127:0] dw /* synthesis keep */;
  always @(s) begin
    d = 128'b0;
    d[{!s[6],s[5:0]}] = 1'b1;
  end
  assign dw = d;

  // Identify uncorrectable errors
  wire fatal = (|s[5:0]) & !s[6] /* synthesis keep */;
  assign e = {
    dw[38],dw[37],dw[36],dw[35],
    dw[34],dw[33],dw[31],dw[30],
    dw[29],dw[28],dw[27],dw[26],
    dw[25],dw[24],dw[23],dw[22],
    dw[21],dw[20],dw[19],dw[18],
    dw[17],dw[15],dw[14],dw[13],
    dw[12],dw[11],dw[10],dw[9],
    dw[7],dw[6],dw[5],dw[3]
    };


endmodule

//////////////////////////////////////////
// select the (uncorrected) data bits out
// of the code word.
//////////////////////////////////////////

module ecc_raw_data_32bit (clk,rst,c,d);
parameter REGISTER = 0;
input clk,rst;
input [38:0] c;
output [31:0] d;
reg [31:0] d;

wire [31:0] d_int;

  // pull out the pure data bits
  assign d_int = {
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
// 39 bit to 32 bit ECC decoder
//////////////////////////////////////////

module ecc_decode_32bit (clk,rst,c,d,no_err,err_corrected,err_fatal);

// optional pipeline registers at the halfway
// point and on the outputs
parameter MIDDLE_REG = 0;
parameter OUTPUT_REG = 0;

input clk,rst;
input [38:0] c;
output [31:0] d;
output no_err, err_corrected, err_fatal;

reg [31:0] d;
reg no_err, err_corrected, err_fatal;

  // Pull the raw (uncorrected) data from the codeword
  wire [31:0] raw_bits;
  ecc_raw_data_32bit raw (.clk(clk),.rst(rst),.c(c),.d(raw_bits));

    defparam raw .REGISTER = MIDDLE_REG;
  // Build syndrome, which will be 0 for correct
  // correct codewords, otherwise a pointer to the
  // error.
  wire [6:0] syndrome;
  ecc_syndrome_32bit syn (.clk(clk),.rst(rst),.c(c),.s(syndrome));
    defparam syn .REGISTER = MIDDLE_REG;

  // Use the the syndrome to find a correction, or 0 for no correction
  wire [31:0] err_flip;
  wire fatal;
  ecc_correction_32bit cor (.s(syndrome),.e(err_flip),.fatal(fatal));

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
          err_corrected <= syndrome[6];
          err_fatal <= fatal;

          d <= err_flip ^ raw_bits;
        end
      end
    end else begin
      always @(*) begin
          no_err = ~| syndrome;
          err_corrected = syndrome[6];
          err_fatal = fatal;

          d = err_flip ^ raw_bits;
      end
    end
  endgenerate

endmodule

