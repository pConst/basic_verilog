// Copyright 2011 Altera Corporation. All rights reserved.  
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

`timescale 1 ps / 1 ps

module xor6 (out,a,b,c,d,e,f);
input a,b,c,d,e,f;
output out;
wire out;

// Equivalent function : out = a ^ b ^ c ^ d ^ e ^ f;
//assign out = a ^ b ^ c ^ d ^ e ^ f;


stratixiv_lcell_comb s2lc (
  .dataa (a),.datab (b),.datac (c),.datad (d),.datae (e),.dataf (f),.datag(1'b1),
  .cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
  .combout(out));

defparam s2lc .lut_mask = 64'h6996966996696996;
defparam s2lc .shared_arith = "off";
defparam s2lc .extended_lut = "off";

endmodule
