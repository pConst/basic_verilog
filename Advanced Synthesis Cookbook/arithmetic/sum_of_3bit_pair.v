// Copyright 2008 Altera Corporation. All rights reserved.  
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

// baeckler - 09-15-2008
//
// Sum of two 3-bit numbers, targeting exactly four LUTs 
// {6,6,4,2} inputs
//

module sum_of_3bit_pair
(
	input [2:0] a,b,
	output reg [3:0] sum
);

always @(*) begin
    case ({a,b})
      6'd0: sum=4'd0;
      6'd1: sum=4'd1;
      6'd2: sum=4'd2;
      6'd3: sum=4'd3;
      6'd4: sum=4'd4;
      6'd5: sum=4'd5;
      6'd6: sum=4'd6;
      6'd7: sum=4'd7;
      6'd8: sum=4'd1;
      6'd9: sum=4'd2;
      6'd10: sum=4'd3;
      6'd11: sum=4'd4;
      6'd12: sum=4'd5;
      6'd13: sum=4'd6;
      6'd14: sum=4'd7;
      6'd15: sum=4'd8;
      6'd16: sum=4'd2;
      6'd17: sum=4'd3;
      6'd18: sum=4'd4;
      6'd19: sum=4'd5;
      6'd20: sum=4'd6;
      6'd21: sum=4'd7;
      6'd22: sum=4'd8;
      6'd23: sum=4'd9;
      6'd24: sum=4'd3;
      6'd25: sum=4'd4;
      6'd26: sum=4'd5;
      6'd27: sum=4'd6;
      6'd28: sum=4'd7;
      6'd29: sum=4'd8;
      6'd30: sum=4'd9;
      6'd31: sum=4'd10;
      6'd32: sum=4'd4;
      6'd33: sum=4'd5;
      6'd34: sum=4'd6;
      6'd35: sum=4'd7;
      6'd36: sum=4'd8;
      6'd37: sum=4'd9;
      6'd38: sum=4'd10;
      6'd39: sum=4'd11;
      6'd40: sum=4'd5;
      6'd41: sum=4'd6;
      6'd42: sum=4'd7;
      6'd43: sum=4'd8;
      6'd44: sum=4'd9;
      6'd45: sum=4'd10;
      6'd46: sum=4'd11;
      6'd47: sum=4'd12;
      6'd48: sum=4'd6;
      6'd49: sum=4'd7;
      6'd50: sum=4'd8;
      6'd51: sum=4'd9;
      6'd52: sum=4'd10;
      6'd53: sum=4'd11;
      6'd54: sum=4'd12;
      6'd55: sum=4'd13;
      6'd56: sum=4'd7;
      6'd57: sum=4'd8;
      6'd58: sum=4'd9;
      6'd59: sum=4'd10;
      6'd60: sum=4'd11;
      6'd61: sum=4'd12;
      6'd62: sum=4'd13;
      6'd63: sum=4'd14;
      default: sum=0;
    endcase
end

endmodule

