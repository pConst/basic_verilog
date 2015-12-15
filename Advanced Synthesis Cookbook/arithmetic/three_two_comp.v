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

// baeckler - 02-13-2006
//
//   Three input two output compressor (full adder)
//		area cost is two 3-LUTs.

module three_two_comp (data,sum);

input [2:0] data;
output [1:0] sum;

reg [1:0] sum;

always @(data) begin
	case (data)
	  0: sum=0;
	  1: sum=1;
	  2: sum=1;
	  3: sum=2;
	  4: sum=1;
	  5: sum=2;
	  6: sum=2;
	  7: sum=3;
	  default: sum=0;
	endcase
end
endmodule