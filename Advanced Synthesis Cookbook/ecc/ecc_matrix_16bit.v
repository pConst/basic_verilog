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
// 16 bit to 22 bit ECC encoder
//////////////////////////////////////////

module ecc_encode_16bit (d,c);

input [15:0] d;
output [21:0] c;
wire [21:0] c;

  wire [1:0] help_c0;
  xor6 help_c0_0 (help_c0[0],d[0],d[1],d[3],d[4],d[6],d[8]);
  xor6 help_c0_1 (help_c0[1],d[10],d[11],d[13],d[15],1'b0,1'b0);
  assign c[0] = ^help_c0;

  wire [1:0] help_c1;
  xor6 help_c1_0 (help_c1[0],d[0],d[2],d[3],d[5],d[6],d[9]);
  xor6 help_c1_1 (help_c1[1],d[10],d[12],d[13],1'b0,1'b0,1'b0);
  assign c[1] = ^help_c1;

  assign c[2] = d[0];
  wire [1:0] help_c3;
  xor6 help_c3_0 (help_c3[0],d[1],d[2],d[3],d[7],d[8],d[9]);
  xor6 help_c3_1 (help_c3[1],d[10],d[14],d[15],1'b0,1'b0,1'b0);
  assign c[3] = ^help_c3;

  assign c[4] = d[1];
  assign c[5] = d[2];
  assign c[6] = d[3];
  wire [1:0] help_c7;
  xor6 help_c7_0 (help_c7[0],d[4],d[5],d[6],d[7],d[8],d[9]);
  assign help_c7[1] = d[10];
  assign c[7] = ^help_c7;

  assign c[8] = d[4];
  assign c[9] = d[5];
  assign c[10] = d[6];
  assign c[11] = d[7];
  assign c[12] = d[8];
  assign c[13] = d[9];
  assign c[14] = d[10];
  assign c[15] = d[11] ^ d[12] ^ d[13] ^ d[14] ^ d[15];
  assign c[16] = d[11];
  assign c[17] = d[12];
  assign c[18] = d[13];
  assign c[19] = d[14];
  assign c[20] = d[15];
  wire [1:0] help_c21;
  xor6 help_c21_0 (help_c21[0],d[0],d[1],d[2],d[4],d[5],d[7]);
  xor6 help_c21_1 (help_c21[1],d[10],d[11],d[12],d[14],1'b0,1'b0);
  assign c[21] = ^help_c21;

endmodule

//////////////////////////////////////////
// compute a syndrome from the code word
//////////////////////////////////////////

module ecc_syndrome_16bit (clk,rst,c,s);

// optional register on the outputs
// of bits 0..6 and back one level in bit 7
parameter REGISTER = 0;

input clk,rst;
input [21:0] c;
output [5:0] s;
reg [5:0] s;

  // 11 terms
  wire [1:0] help_s0;
  xor6 help_s0_0 (help_s0[0],c[0],c[2],c[4],c[6],c[8],c[10]);
  xor6 help_s0_1 (help_s0[1],c[12],c[14],c[16],c[18],c[20],1'b0);
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

  // 10 terms
  wire [1:0] help_s1;
  xor6 help_s1_0 (help_s1[0],c[1],c[2],c[5],c[6],c[9],c[10]);
  xor6 help_s1_1 (help_s1[1],c[13],c[14],c[17],c[18],1'b0,1'b0);
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

  // 10 terms
  wire [1:0] help_s2;
  xor6 help_s2_0 (help_s2[0],c[3],c[4],c[5],c[6],c[11],c[12]);
  xor6 help_s2_1 (help_s2[1],c[13],c[14],c[19],c[20],1'b0,1'b0);
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

  // 8 terms
  wire [1:0] help_s3;
  xor6 help_s3_0 (help_s3[0],c[7],c[8],c[9],c[10],c[11],c[12]);
  xor6 help_s3_1 (help_s3[1],c[13],c[14],1'b0,1'b0,1'b0,1'b0);
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

  // 6 terms
  wire [0:0] help_s4;
  xor6 help_s4_0 (help_s4[0],c[15],c[16],c[17],c[18],c[19],c[20]);
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

  // 22 terms
  wire [3:0] help_s5;
  xor6 help_s5_0 (help_s5[0],c[0],c[1],c[2],c[3],c[4],c[5]);
  xor6 help_s5_1 (help_s5[1],c[6],c[7],c[8],c[9],c[10],c[11]);
  xor6 help_s5_2 (help_s5[2],c[12],c[13],c[14],c[15],c[16],c[17]);
  xor6 help_s5_3 (help_s5[3],c[18],c[19],c[20],c[21],1'b0,1'b0);
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

endmodule

//////////////////////////////////////////
// From the syndrome compute the correction
// needed to fix the data, or set fatal = 1
// and no correction if there are too many.
//////////////////////////////////////////
module ecc_correction_16bit (s,e,fatal);

input [5:0] s;
output [15:0] e;
output fatal;
wire [15:0] e;

  // decode the syndrome
  reg [63:0] d;
  wire [63:0] dw /* synthesis keep */;
  always @(s) begin
    d = 64'b0;
    d[{!s[5],s[4:0]}] = 1'b1;
  end
  assign dw = d;

  // Identify uncorrectable errors
  wire fatal = (|s[4:0]) & !s[5] /* synthesis keep */;
  assign e = {
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

module ecc_raw_data_16bit (clk,rst,c,d);
parameter REGISTER = 0;
input clk,rst;
input [21:0] c;
output [15:0] d;
reg [15:0] d;

wire [15:0] d_int;

  // pull out the pure data bits
  assign d_int = {
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
// 22 bit to 16 bit ECC decoder
//////////////////////////////////////////

module ecc_decode_16bit (clk,rst,c,d,no_err,err_corrected,err_fatal);

// optional pipeline registers at the halfway
// point and on the outputs
parameter MIDDLE_REG = 0;
parameter OUTPUT_REG = 0;

input clk,rst;
input [21:0] c;
output [15:0] d;
output no_err, err_corrected, err_fatal;

reg [15:0] d;
reg no_err, err_corrected, err_fatal;

  // Pull the raw (uncorrected) data from the codeword
  wire [15:0] raw_bits;
  ecc_raw_data_16bit raw (.clk(clk),.rst(rst),.c(c),.d(raw_bits));

    defparam raw .REGISTER = MIDDLE_REG;
  // Build syndrome, which will be 0 for correct
  // correct codewords, otherwise a pointer to the
  // error.
  wire [5:0] syndrome;
  ecc_syndrome_16bit syn (.clk(clk),.rst(rst),.c(c),.s(syndrome));
    defparam syn .REGISTER = MIDDLE_REG;

  // Use the the syndrome to find a correction, or 0 for no correction
  wire [15:0] err_flip;
  wire fatal;
  ecc_correction_16bit cor (.s(syndrome),.e(err_flip),.fatal(fatal));

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
          err_corrected <= syndrome[5];
          err_fatal <= fatal;

          d <= err_flip ^ raw_bits;
        end
      end
    end else begin
      always @(*) begin
          no_err = ~| syndrome;
          err_corrected = syndrome[5];
          err_fatal = fatal;

          d = err_flip ^ raw_bits;
      end
    end
  endgenerate

endmodule

