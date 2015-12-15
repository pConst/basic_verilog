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

// baeckler - 03-07-2006

// the state 
//   (msb)  A B C D E F G H I J K L M N O P (lsb)
//
// shown as a grid :
//
//  AEIM
//  BFJN
//  CGKO
//  DHLP
//
//  Needs to be shifted to produce :
//
//  AEIM
//  FJNB
//  KOCG
//  PDHL
//

module shift_rows (in,out);
input [16*8-1 : 0] in;
output [16*8-1 : 0] out;
wire [16*8-1 : 0] out;

assign out = {
	in[127:120],in[87:80],in[47:40],in[7:0],
	in[95:88],in[55:48],in[15:8],in[103:96],
	in[63:56],in[23:16],in[111:104],in[71:64],
	in[31:24],in[119:112],in[79:72],in[39:32] };

endmodule

module inv_shift_rows (in,out);
input [16*8-1 : 0] in;
output [16*8-1 : 0] out;
wire [16*8-1 : 0] out;

assign out = {
	in[127:120],in[23:16],in[47:40],in[71:64],
	in[95:88],in[119:112],in[15:8],in[39:32],
	in[63:56],in[87:80],in[111:104],in[7:0],
	in[31:24],in[55:48],in[79:72],in[103:96] };

endmodule

