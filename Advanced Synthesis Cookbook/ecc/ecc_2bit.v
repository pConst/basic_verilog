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

//////////////////////////////////////////////
// 2 to 6 bit ECC encoder
//////////////////////////////////////////////
module ecc_encode_2bit (d,c);
input [1:0] d;
output [5:0] c;
wire [5:0] c;

  assign c = {d[1],d[1],d[0],d[0],^d,^d};
endmodule

//////////////////////////////////////////////
// the error flag indicates
//   [2] 2 or more bit error
//   [1] 1 bit error (corrected)
//   [0] no error
//////////////////////////////////////////////
module ecc_decode_2bit (c,d,err_flag);
input [5:0] c;
output [1:0] d;
output [2:0] err_flag;
reg [1:0] d;
reg [2:0] err_flag;
  always @(c) begin
    case (c)
                      // bit distance to codes 0 .. 3
      6'h00 : {d,err_flag} = {2'b00, 3'b001}; // 0 4 4 4
      6'h01 : {d,err_flag} = {2'b00, 3'b010}; // 1 3 3 5
      6'h02 : {d,err_flag} = {2'b00, 3'b010}; // 1 3 3 5
      6'h03 : {d,err_flag} = {2'b00, 3'b100}; // 2 2 2 6
      6'h04 : {d,err_flag} = {2'b00, 3'b010}; // 1 3 5 3
      6'h05 : {d,err_flag} = {2'b00, 3'b100}; // 2 2 4 4
      6'h06 : {d,err_flag} = {2'b00, 3'b100}; // 2 2 4 4
      6'h07 : {d,err_flag} = {2'b01, 3'b010}; // 3 1 3 5
      6'h08 : {d,err_flag} = {2'b00, 3'b010}; // 1 3 5 3
      6'h09 : {d,err_flag} = {2'b00, 3'b100}; // 2 2 4 4
      6'h0a : {d,err_flag} = {2'b00, 3'b100}; // 2 2 4 4
      6'h0b : {d,err_flag} = {2'b01, 3'b010}; // 3 1 3 5
      6'h0c : {d,err_flag} = {2'b00, 3'b100}; // 2 2 6 2
      6'h0d : {d,err_flag} = {2'b01, 3'b010}; // 3 1 5 3
      6'h0e : {d,err_flag} = {2'b01, 3'b010}; // 3 1 5 3
      6'h0f : {d,err_flag} = {2'b01, 3'b001}; // 4 0 4 4
      6'h10 : {d,err_flag} = {2'b00, 3'b010}; // 1 5 3 3
      6'h11 : {d,err_flag} = {2'b00, 3'b100}; // 2 4 2 4
      6'h12 : {d,err_flag} = {2'b00, 3'b100}; // 2 4 2 4
      6'h13 : {d,err_flag} = {2'b10, 3'b010}; // 3 3 1 5
      6'h14 : {d,err_flag} = {2'b00, 3'b100}; // 2 4 4 2
      6'h15 : {d,err_flag} = {2'b00, 3'b100}; // 3 3 3 3
      6'h16 : {d,err_flag} = {2'b00, 3'b100}; // 3 3 3 3
      6'h17 : {d,err_flag} = {2'b01, 3'b100}; // 4 2 2 4
      6'h18 : {d,err_flag} = {2'b00, 3'b100}; // 2 4 4 2
      6'h19 : {d,err_flag} = {2'b00, 3'b100}; // 3 3 3 3
      6'h1a : {d,err_flag} = {2'b00, 3'b100}; // 3 3 3 3
      6'h1b : {d,err_flag} = {2'b01, 3'b100}; // 4 2 2 4
      6'h1c : {d,err_flag} = {2'b11, 3'b010}; // 3 3 5 1
      6'h1d : {d,err_flag} = {2'b01, 3'b100}; // 4 2 4 2
      6'h1e : {d,err_flag} = {2'b01, 3'b100}; // 4 2 4 2
      6'h1f : {d,err_flag} = {2'b01, 3'b010}; // 5 1 3 3
      6'h20 : {d,err_flag} = {2'b00, 3'b010}; // 1 5 3 3
      6'h21 : {d,err_flag} = {2'b00, 3'b100}; // 2 4 2 4
      6'h22 : {d,err_flag} = {2'b00, 3'b100}; // 2 4 2 4
      6'h23 : {d,err_flag} = {2'b10, 3'b010}; // 3 3 1 5
      6'h24 : {d,err_flag} = {2'b00, 3'b100}; // 2 4 4 2
      6'h25 : {d,err_flag} = {2'b00, 3'b100}; // 3 3 3 3
      6'h26 : {d,err_flag} = {2'b00, 3'b100}; // 3 3 3 3
      6'h27 : {d,err_flag} = {2'b01, 3'b100}; // 4 2 2 4
      6'h28 : {d,err_flag} = {2'b00, 3'b100}; // 2 4 4 2
      6'h29 : {d,err_flag} = {2'b00, 3'b100}; // 3 3 3 3
      6'h2a : {d,err_flag} = {2'b00, 3'b100}; // 3 3 3 3
      6'h2b : {d,err_flag} = {2'b01, 3'b100}; // 4 2 2 4
      6'h2c : {d,err_flag} = {2'b11, 3'b010}; // 3 3 5 1
      6'h2d : {d,err_flag} = {2'b01, 3'b100}; // 4 2 4 2
      6'h2e : {d,err_flag} = {2'b01, 3'b100}; // 4 2 4 2
      6'h2f : {d,err_flag} = {2'b01, 3'b010}; // 5 1 3 3
      6'h30 : {d,err_flag} = {2'b00, 3'b100}; // 2 6 2 2
      6'h31 : {d,err_flag} = {2'b10, 3'b010}; // 3 5 1 3
      6'h32 : {d,err_flag} = {2'b10, 3'b010}; // 3 5 1 3
      6'h33 : {d,err_flag} = {2'b10, 3'b001}; // 4 4 0 4
      6'h34 : {d,err_flag} = {2'b11, 3'b010}; // 3 5 3 1
      6'h35 : {d,err_flag} = {2'b10, 3'b100}; // 4 4 2 2
      6'h36 : {d,err_flag} = {2'b10, 3'b100}; // 4 4 2 2
      6'h37 : {d,err_flag} = {2'b10, 3'b010}; // 5 3 1 3
      6'h38 : {d,err_flag} = {2'b11, 3'b010}; // 3 5 3 1
      6'h39 : {d,err_flag} = {2'b10, 3'b100}; // 4 4 2 2
      6'h3a : {d,err_flag} = {2'b10, 3'b100}; // 4 4 2 2
      6'h3b : {d,err_flag} = {2'b10, 3'b010}; // 5 3 1 3
      6'h3c : {d,err_flag} = {2'b11, 3'b001}; // 4 4 4 0
      6'h3d : {d,err_flag} = {2'b11, 3'b010}; // 5 3 3 1
      6'h3e : {d,err_flag} = {2'b11, 3'b010}; // 5 3 3 1
      6'h3f : {d,err_flag} = {2'b01, 3'b100}; // 6 2 2 2
    endcase
  end
endmodule
