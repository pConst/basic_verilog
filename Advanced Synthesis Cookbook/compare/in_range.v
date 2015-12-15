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

// baeckler - 02-24-2006


module in_range (dat,inr);

`include "log2.inc"
`include "highest_10.inc"

parameter LOWER_BOUND = 85;
parameter UPPER_BOUND = 120;
parameter WIDTH = 7;
parameter METHOD = 2;

// identify the most significant bit where UPPER is 1 and
// LOWER is 0
localparam SPLIT_POINT = highest_10 (UPPER_BOUND,LOWER_BOUND);
		
input [WIDTH-1:0] dat;
output inr;
wire inr;

genvar i,j;
generate
	if (METHOD == 0) begin
		////////////////////////////////////////
		// generic implementation
		////////////////////////////////////////
		assign inr = (dat >= LOWER_BOUND && dat < UPPER_BOUND);
	end
	else if (METHOD == 1) begin
		///////////////////////////////////////////////////
		// use of subtractors to implement the comparison
		///////////////////////////////////////////////////
		wire [WIDTH+1:0] result;
		wire [WIDTH:0] comp_a;
		assign comp_a = dat-LOWER_BOUND;
		assign result = comp_a-(UPPER_BOUND-LOWER_BOUND);
		assign inr = result[WIDTH+1];
	end
	else if (METHOD == 2) begin
		///////////////////////////////////////////////////
		// Demonstration of over / under / equal technique
		//   illustrated by Paul Q3 2003 slides
		//   No hard structure / chains.
		///////////////////////////////////////////////////
		wire ou_out;
		wire eq_out;

		initial begin
			$display ("%x",UPPER_BOUND[SPLIT_POINT-1:0]);
			$display ("%x",LOWER_BOUND[SPLIT_POINT-1:0]);
			$display ("%x",UPPER_BOUND[WIDTH-1:SPLIT_POINT]);
		end

		over_under ou (
			.over(!dat[SPLIT_POINT]),
			.dat(dat[SPLIT_POINT-1:0]),
			.out(ou_out)
		);
		defparam ou .WIDTH = SPLIT_POINT;
		defparam ou .METHOD = 0;
		defparam ou .UPPER_BOUND = UPPER_BOUND [SPLIT_POINT-1 : 0];
		defparam ou .LOWER_BOUND = LOWER_BOUND [SPLIT_POINT-1 : 0];

		equal_const eq (
			.dat(dat[WIDTH-1:SPLIT_POINT+1]),
			.out(eq_out)
		);
		defparam eq .WIDTH = WIDTH-SPLIT_POINT-1;
		defparam eq .CONST_VAL = UPPER_BOUND [WIDTH-1:SPLIT_POINT+1];
		defparam eq .METHOD = 0;

		assign inr = ou_out & eq_out;
	end	
endgenerate

endmodule