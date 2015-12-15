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

// output bits are an XOR function of more significant bits, the
// area required may increase somewhat irregularly with WIDTH
// as the synthesis tool selects different area / depth tradeoffs

module gray_to_bin (gray,bin);

parameter WIDTH = 8;

input [WIDTH-1:0] gray;
output [WIDTH-1:0] bin;
wire [WIDTH-1:0] bin;

assign bin[WIDTH-1] = gray[WIDTH-1];
genvar i;
generate
for (i=WIDTH-2; i>=0; i=i-1)
  begin: gry_to_bin
    assign bin[i] = bin[i+1] ^ gray[i];
  end
endgenerate

endmodule