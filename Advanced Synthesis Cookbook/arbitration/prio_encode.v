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

//baeckler - 11-14-2006
// priority encoder
//   no requests - output = 0
//   request bit 0 (highest priority) - output = 1
//   request bit 5 (lowest priority) - output = 6
module prio_encode (reqs,out);
input [5:0] reqs;
output [2:0] out;
reg [2:0] out;

    always @(*) begin
      case(reqs)
        // 0 is special, no reqs
        6'd0: out = 0;

        6'd1: out = 1;
        6'd2: out = 2;
        6'd3: out = 1;
        6'd4: out = 3;
        6'd5: out = 1;
        6'd6: out = 2;
        6'd7: out = 1;
        6'd8: out = 4;
        6'd9: out = 1;
        6'd10: out = 2;
        6'd11: out = 1;
        6'd12: out = 3;
        6'd13: out = 1;
        6'd14: out = 2;
        6'd15: out = 1;
        6'd16: out = 5;
        6'd17: out = 1;
        6'd18: out = 2;
        6'd19: out = 1;
        6'd20: out = 3;
        6'd21: out = 1;
        6'd22: out = 2;
        6'd23: out = 1;
        6'd24: out = 4;
        6'd25: out = 1;
        6'd26: out = 2;
        6'd27: out = 1;
        6'd28: out = 3;
        6'd29: out = 1;
        6'd30: out = 2;
        6'd31: out = 1;
        6'd32: out = 6;
        6'd33: out = 1;
        6'd34: out = 2;
        6'd35: out = 1;
        6'd36: out = 3;
        6'd37: out = 1;
        6'd38: out = 2;
        6'd39: out = 1;
        6'd40: out = 4;
        6'd41: out = 1;
        6'd42: out = 2;
        6'd43: out = 1;
        6'd44: out = 3;
        6'd45: out = 1;
        6'd46: out = 2;
        6'd47: out = 1;
        6'd48: out = 5;
        6'd49: out = 1;
        6'd50: out = 2;
        6'd51: out = 1;
        6'd52: out = 3;
        6'd53: out = 1;
        6'd54: out = 2;
        6'd55: out = 1;
        6'd56: out = 4;
        6'd57: out = 1;
        6'd58: out = 2;
        6'd59: out = 1;
        6'd60: out = 3;
        6'd61: out = 1;
        6'd62: out = 2;
        6'd63: out = 1;
      endcase
    end
endmodule
