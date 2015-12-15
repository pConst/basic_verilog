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

module mask_16 (in,mask);
input [3:0] in;
output [15:0] mask;
reg [15:0] mask;

parameter FROM_MSB = 1'b1;
parameter DIAG_ONES = 1'b1;

generate
  if (!FROM_MSB && !DIAG_ONES) begin
    always @(in) begin
    case (in)
      4'd0: mask=16'b0000000000000000;
      4'd1: mask=16'b0000000000000001;
      4'd2: mask=16'b0000000000000011;
      4'd3: mask=16'b0000000000000111;
      4'd4: mask=16'b0000000000001111;
      4'd5: mask=16'b0000000000011111;
      4'd6: mask=16'b0000000000111111;
      4'd7: mask=16'b0000000001111111;
      4'd8: mask=16'b0000000011111111;
      4'd9: mask=16'b0000000111111111;
      4'd10: mask=16'b0000001111111111;
      4'd11: mask=16'b0000011111111111;
      4'd12: mask=16'b0000111111111111;
      4'd13: mask=16'b0001111111111111;
      4'd14: mask=16'b0011111111111111;
      4'd15: mask=16'b0111111111111111;
      default: mask=0;
    endcase
    end
  end
  else if ( FROM_MSB && !DIAG_ONES) begin
    always @(in) begin
    case (in)
      4'd0: mask=16'b0000000000000000;
      4'd1: mask=16'b1000000000000000;
      4'd2: mask=16'b1100000000000000;
      4'd3: mask=16'b1110000000000000;
      4'd4: mask=16'b1111000000000000;
      4'd5: mask=16'b1111100000000000;
      4'd6: mask=16'b1111110000000000;
      4'd7: mask=16'b1111111000000000;
      4'd8: mask=16'b1111111100000000;
      4'd9: mask=16'b1111111110000000;
      4'd10: mask=16'b1111111111000000;
      4'd11: mask=16'b1111111111100000;
      4'd12: mask=16'b1111111111110000;
      4'd13: mask=16'b1111111111111000;
      4'd14: mask=16'b1111111111111100;
      4'd15: mask=16'b1111111111111110;
      default: mask=0;
    endcase
    end
  end
  else if (!FROM_MSB &&  DIAG_ONES) begin
    always @(in) begin
    case (in)
      4'd0: mask=16'b0000000000000001;
      4'd1: mask=16'b0000000000000011;
      4'd2: mask=16'b0000000000000111;
      4'd3: mask=16'b0000000000001111;
      4'd4: mask=16'b0000000000011111;
      4'd5: mask=16'b0000000000111111;
      4'd6: mask=16'b0000000001111111;
      4'd7: mask=16'b0000000011111111;
      4'd8: mask=16'b0000000111111111;
      4'd9: mask=16'b0000001111111111;
      4'd10: mask=16'b0000011111111111;
      4'd11: mask=16'b0000111111111111;
      4'd12: mask=16'b0001111111111111;
      4'd13: mask=16'b0011111111111111;
      4'd14: mask=16'b0111111111111111;
      4'd15: mask=16'b1111111111111111;
      default: mask=0;
    endcase
    end
  end
  else if ( FROM_MSB &&  DIAG_ONES) begin
    always @(in) begin
    case (in)
      4'd0: mask=16'b1000000000000000;
      4'd1: mask=16'b1100000000000000;
      4'd2: mask=16'b1110000000000000;
      4'd3: mask=16'b1111000000000000;
      4'd4: mask=16'b1111100000000000;
      4'd5: mask=16'b1111110000000000;
      4'd6: mask=16'b1111111000000000;
      4'd7: mask=16'b1111111100000000;
      4'd8: mask=16'b1111111110000000;
      4'd9: mask=16'b1111111111000000;
      4'd10: mask=16'b1111111111100000;
      4'd11: mask=16'b1111111111110000;
      4'd12: mask=16'b1111111111111000;
      4'd13: mask=16'b1111111111111100;
      4'd14: mask=16'b1111111111111110;
      4'd15: mask=16'b1111111111111111;
      default: mask=0;
    endcase
    end
  end
endgenerate
endmodule
