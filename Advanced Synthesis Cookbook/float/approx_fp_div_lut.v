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

// Look up table for approximate floating point
// division - total area is seven 6-LUTs.

module approx_fp_div_lut (in, out);
input [5:0] in;
output [6:0] out;
reg [6:0] out;

always @(in) begin
   case (in)
        6'h0 : out <= 7'h7c;
        6'h1 : out <= 7'h78;
        6'h2 : out <= 7'h74;
        6'h3 : out <= 7'h70;
        6'h4 : out <= 7'h6d;
        6'h5 : out <= 7'h6a;
        6'h6 : out <= 7'h66;
        6'h7 : out <= 7'h63;
        6'h8 : out <= 7'h60;
        6'h9 : out <= 7'h5d;
        6'ha : out <= 7'h5a;
        6'hb : out <= 7'h57;
        6'hc : out <= 7'h54;
        6'hd : out <= 7'h52;
        6'he : out <= 7'h4f;
        6'hf : out <= 7'h4c;
        6'h10 : out <= 7'h4a;
        6'h11 : out <= 7'h47;
        6'h12 : out <= 7'h45;
        6'h13 : out <= 7'h43;
        6'h14 : out <= 7'h40;
        6'h15 : out <= 7'h3e;
        6'h16 : out <= 7'h3c;
        6'h17 : out <= 7'h3a;
        6'h18 : out <= 7'h38;
        6'h19 : out <= 7'h36;
        6'h1a : out <= 7'h34;
        6'h1b : out <= 7'h32;
        6'h1c : out <= 7'h30;
        6'h1d : out <= 7'h2e;
        6'h1e : out <= 7'h2c;
        6'h1f : out <= 7'h2a;
        6'h20 : out <= 7'h28;
        6'h21 : out <= 7'h27;
        6'h22 : out <= 7'h25;
        6'h23 : out <= 7'h23;
        6'h24 : out <= 7'h22;
        6'h25 : out <= 7'h20;
        6'h26 : out <= 7'h1f;
        6'h27 : out <= 7'h1d;
        6'h28 : out <= 7'h1c;
        6'h29 : out <= 7'h1a;
        6'h2a : out <= 7'h19;
        6'h2b : out <= 7'h17;
        6'h2c : out <= 7'h16;
        6'h2d : out <= 7'h14;
        6'h2e : out <= 7'h13;
        6'h2f : out <= 7'h12;
        6'h30 : out <= 7'h10;
        6'h31 : out <= 7'hf;
        6'h32 : out <= 7'he;
        6'h33 : out <= 7'hd;
        6'h34 : out <= 7'hc;
        6'h35 : out <= 7'ha;
        6'h36 : out <= 7'h9;
        6'h37 : out <= 7'h8;
        6'h38 : out <= 7'h7;
        6'h39 : out <= 7'h6;
        6'h3a : out <= 7'h5;
        6'h3b : out <= 7'h4;
        6'h3c : out <= 7'h3;
        6'h3d : out <= 7'h2;
        6'h3e : out <= 7'h1;
        6'h3f : out <= 7'h0;
    endcase
end
endmodule
