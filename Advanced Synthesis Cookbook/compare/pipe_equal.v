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

// baeckler - 02-23-2006
// 64 bit equality compare with latency 3
//   Max 1 level of LUT logic between registers
//   Area - 21 6-LUT 5-5LUT 2-2LUT

module pipe_equal (a,b,clk,rst,eq);

input [63:0] a;
input [63:0] b;
input clk,rst;

output eq;
wire eq;

wire [21:0] level_0;
reg [21:0] level_0_r;
reg [4:0] level_1_r;
reg level_2_r;

// Compute equality in 3 bit segments.
genvar i;
generate
  for (i=0; i<21; i=i+1) 
  begin : l0
    wire [2:0] tmp_a;
    wire [2:0] tmp_b;
    assign tmp_a = a[3*i+2 : 3*i];
    assign tmp_b = b[3*i+2 : 3*i];
    assign level_0[i] = (tmp_a == tmp_b);
  end
endgenerate
assign level_0[21] = (a[63] == b[63]);

// First pipe register stage
always @(posedge clk or posedge rst) begin
  if (rst) level_0_r <= 22'b0;
  else level_0_r <= level_0;
end

// Start ANDing together the equality leaves
// we need 2 levels of LUT, so relaxed to 5 LUT
always @(posedge clk or posedge rst) begin
  if (rst) level_1_r <= 5'b0;
  else begin
    level_1_r[0] <= & level_0_r[4:0];
    level_1_r[1] <= & level_0_r[9:5];
    level_1_r[2] <= & level_0_r[14:10];
    level_1_r[3] <= & level_0_r[19:15];
    level_1_r[4] <= & level_0_r[21:20];
  end    
end

// final AND
always @(posedge clk or posedge rst) begin
  if (rst) level_2_r <= 1'b0;
  else begin
    level_2_r <= & level_1_r;
  end
end
assign eq = level_2_r;

endmodule
