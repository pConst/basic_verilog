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

module expand (in,out);
input [31:0] in;
output [47:0] out;

wire [47:0] out;

assign out = {
    in[0],in[31],in[30],in[29],in[28],in[27],in[28],in[27],
    in[26],in[25],in[24],in[23],in[24],in[23],in[22],in[21],
    in[20],in[19],in[20],in[19],in[18],in[17],in[16],in[15],
    in[16],in[15],in[14],in[13],in[12],in[11],in[12],in[11],
    in[10],in[9],in[8],in[7],in[8],in[7],in[6],in[5],
    in[4],in[3],in[4],in[3],in[2],in[1],in[0],in[31]
};
endmodule

module permute (in,out);
input [31:0] in;
output [31:0] out;

wire [31:0] out;

assign out = {
    in[16],in[25],in[12],in[11],in[3],in[20],in[4],in[15],
    in[31],in[17],in[9],in[6],in[27],in[14],in[1],in[22],
    in[30],in[24],in[8],in[18],in[0],in[5],in[29],in[23],
    in[13],in[19],in[2],in[26],in[10],in[21],in[28],in[7]
};
endmodule

module initial_permute (in,out);
input [63:0] in;
output [63:0] out;

wire [63:0] out;

assign out = {
    in[6],in[14],in[22],in[30],in[38],in[46],in[54],in[62],
    in[4],in[12],in[20],in[28],in[36],in[44],in[52],in[60],
    in[2],in[10],in[18],in[26],in[34],in[42],in[50],in[58],
    in[0],in[8],in[16],in[24],in[32],in[40],in[48],in[56],
    in[7],in[15],in[23],in[31],in[39],in[47],in[55],in[63],
    in[5],in[13],in[21],in[29],in[37],in[45],in[53],in[61],
    in[3],in[11],in[19],in[27],in[35],in[43],in[51],in[59],
    in[1],in[9],in[17],in[25],in[33],in[41],in[49],in[57]
};
endmodule

module final_permute (in,out);
input [63:0] in;
output [63:0] out;

wire [63:0] out;

assign out = {
    in[24],in[56],in[16],in[48],in[8],in[40],in[0],in[32],
    in[25],in[57],in[17],in[49],in[9],in[41],in[1],in[33],
    in[26],in[58],in[18],in[50],in[10],in[42],in[2],in[34],
    in[27],in[59],in[19],in[51],in[11],in[43],in[3],in[35],
    in[28],in[60],in[20],in[52],in[12],in[44],in[4],in[36],
    in[29],in[61],in[21],in[53],in[13],in[45],in[5],in[37],
    in[30],in[62],in[22],in[54],in[14],in[46],in[6],in[38],
    in[31],in[63],in[23],in[55],in[15],in[47],in[7],in[39]
};
endmodule

// Strip out the parity and permute to make 56 bit
// starting key from 64 bit input
//  parity is at 0,8,16...
module key_init_perm (in,out);
input [63:0] in;
output [55:0] out;

wire [55:0] out;

assign out = {
    in[7],in[15],in[23],in[31],in[39],in[47],in[55],
    in[63],in[6],in[14],in[22],in[30],in[38],in[46],
    in[54],in[62],in[5],in[13],in[21],in[29],in[37],
    in[45],in[53],in[61],in[4],in[12],in[20],in[28],
    in[1],in[9],in[17],in[25],in[33],in[41],in[49],
    in[57],in[2],in[10],in[18],in[26],in[34],in[42],
    in[50],in[58],in[3],in[11],in[19],in[27],in[35],
    in[43],in[51],in[59],in[36],in[44],in[52],in[60]
};
endmodule

// Compress and permute to make 48 bit round key
// from the 56 bit shifted key
module round_key_select (in,out);
input [55:0] in;
output [47:0] out;

wire [47:0] out;

assign out = {
    in[42],in[39],in[45],in[32],in[55],in[51],in[53],in[28],
    in[41],in[50],in[35],in[46],in[33],in[37],in[44],in[52],
    in[30],in[48],in[40],in[49],in[29],in[36],in[43],in[54],
    in[15],in[4],in[25],in[19],in[9],in[1],in[26],in[16],
    in[5],in[11],in[23],in[8],in[12],in[7],in[17],in[0],
    in[22],in[3],in[10],in[14],in[6],in[20],in[27],in[24]
};
endmodule

//rotate the key halves
module key_shift (in,out);
input [55:0] in;
output [55:0] out;

wire [55:0] out;

parameter SINGLE = 1'b0;
parameter REVERSE = 1'b0;
wire [27:0] h0;
wire [27:0] h1;
  generate
  if (REVERSE) begin
    if (SINGLE) begin
       assign h1 = {in[28],in[55:29]};
       assign h0 = {in[0],in[27:1]};
    end else begin
       assign h1 = {in[29:28],in[55:30]};
       assign h0 = {in[1:0],in[27:2]};
    end
  end else begin
    if (SINGLE) begin
       assign h1 = {in[54:28],in[55]};
       assign h0 = {in[26:0],in[27]};
    end else begin
       assign h1 = {in[53:28],in[55:54]};
       assign h0 = {in[25:0],in[27:26]};
    end
  end
  endgenerate

assign out = {h1,h0};
endmodule

// one of the 16 rounds, data and key evolution
module round (clk,rst,in,out,key_in,key_out,salt);
parameter INIT = 1'b0; // optional initial perm
parameter FINAL = 1'b0; // optional final perm
parameter SINGLE = 1'b0; // single shift the key (vs dbl)
parameter REVERSE = 1'b0; // shift backwards for decrypt
parameter PIPEA = 1'b0; // reg normal outs
parameter PIPEB = 1'b0; // reg retimed back
parameter USE_SALT = 1'b0; // Unix password style
input clk,rst;
input [63:0] in;
input [55:0] key_in;
input [11:0] salt;
output [63:0] out;
output [55:0] key_out;
reg [63:0] out;
reg [55:0] key_out;

wire [31:0] lhs_in;
wire [31:0] rhs_in;
wire [47:0] exp;
wire [47:0] keyd;
wire [31:0] box;
wire [31:0] pout;
wire [47:0] round_key;

  // Optional initial perm
  generate
  if (INIT)
    initial_permute i (.in(in),.out({lhs_in,rhs_in}));
  else
    assign {lhs_in,rhs_in} = in;
  endgenerate

  // Key evolution
  wire [55:0] key_o;
  key_shift kf (.in(key_in),.out(key_o));
  defparam kf .REVERSE = REVERSE;
  defparam kf .SINGLE = SINGLE;
  round_key_select rk (.in(key_o),.out(round_key));

  generate
  if (PIPEA | PIPEB) begin
    always @(posedge clk or posedge rst) begin
      if (rst) key_out <= 56'b0;
      else key_out <= key_o;
    end
  end else begin
    always @(key_o) begin
      key_out = key_o;
    end
  end
  endgenerate

  // Data expand with optional salt perm
  generate
  if (USE_SALT) begin
    wire [47:0] presalt_exp;
    wire [23:0] salt_x;
    wire [23:0] rev_salt = {salt[0],salt[1],salt[2],salt[3],
            salt[4],salt[5],salt[6],salt[7],salt[8],salt[9],
            salt[10],salt[11],12'b0};
    expand e (.in(rhs_in),.out(presalt_exp));
    assign salt_x = (presalt_exp[47:24] ^ presalt_exp[23:0]) & rev_salt;
    assign exp = presalt_exp ^ {salt_x,salt_x};
  end else begin
    expand e (.in(rhs_in),.out(exp));
  end
  endgenerate

  // data Key, box, and round permute
  assign keyd = exp ^ round_key;
  sboxes s (.in(keyd),.out(box));
  permute p (.in(box),.out(pout));

  // Deal with pipe and optional final perm
  wire [63:0] comb_out;
  generate
  if (!PIPEB) begin
    if (FINAL)
      final_permute f (.in({lhs_in ^ pout,rhs_in}),.out(comb_out));
    else
      assign comb_out = {rhs_in,lhs_in ^ pout};
    if (PIPEA) begin
       always @(posedge clk or posedge rst) begin
          if (rst) out <= 64'b0;
          else out <= comb_out;
       end
    end else begin
       always @(comb_out) begin
          out = comb_out;
       end
    end
  end
  else begin // PIPEB
    reg [31:0] reg_rhs, reg_lhs, reg_pout;
    always @(posedge clk or posedge rst) begin
      if (rst) begin
        reg_rhs <= 32'b0;
        reg_lhs <= 32'b0;
        reg_pout <= 32'b0;
      end else begin
        reg_rhs <= rhs_in;
        reg_lhs <= lhs_in;
        reg_pout <= pout;
      end
    end

    if (FINAL)
      final_permute f (.in({reg_lhs ^ reg_pout,reg_rhs}),.out(comb_out));
    else
      assign comb_out = {reg_rhs,reg_lhs ^ reg_pout};

    always @(comb_out) begin
      out = comb_out;
    end
  end
  endgenerate

endmodule

