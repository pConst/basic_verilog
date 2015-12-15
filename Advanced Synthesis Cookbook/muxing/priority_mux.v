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

// baeckler - 3-20-2006
// higher numbered select bits take priority over lower

module priority_mux (sel,dat,out);

parameter WIDTH = 24;  // currently must be a multiple of 6

localparam WIDTH_DIV_3 = WIDTH/3;
localparam WIDTH_DIV_6 = WIDTH/6;

input [WIDTH-1:0] sel;
input [WIDTH-1:0] dat;
output out;

parameter METHOD = 1;


genvar i;
generate 
	if (METHOD == 0) begin
		////////////////////////////////////////////
		// Generic
		////////////////////////////////////////////
		wire [WIDTH:0] partials;
		assign partials[0] = 1'b0;

		for (i=0; i<WIDTH; i=i+1) 
		begin : m
		 assign partials[i+1] = (!sel[i] & partials[i]) | (sel[i] & dat[i]);
		end   
		assign out = partials[WIDTH];
	end
	else if (METHOD == 1) begin
		////////////////////////////////////////////
		// With some hard grouping for speed
		////////////////////////////////////////////
		// priority mux within a block of 6 
		wire [WIDTH_DIV_3-1:0] triples /* synthesis keep */;
		for (i=0; i<WIDTH_DIV_3; i=i+1) 
		begin : m3
		   assign triples[i] = sel[3*i+2] ? dat[3*i+2] : 
							sel[3*i+1] ? dat[3*i+1] :
							sel[3*i] ? dat[3*i] : 1'b0;							
		end   
		
		// aggregate the select signals to chunks of 6
		wire [WIDTH_DIV_6-1:0] grouped_select /* synthesis keep */;
		for (i=0; i<WIDTH_DIV_6; i=i+1) 
		begin : sg
			assign grouped_select[i] = |sel[6*i+5:6*i];
		end   

		// see if a block of 6 higher than mine is active
		wire [WIDTH_DIV_6-1:0] higher_select;
		for (i=0; i<WIDTH_DIV_6-1; i=i+1) 
		begin : hs
			assign higher_select[i] = |grouped_select[WIDTH_DIV_6-1:i];
		end   
		assign higher_select[WIDTH_DIV_6-1] = 1'b0;
						
		// priority mux within a block of 6
		// refer to the higher signal for between block
		// priority 
		wire [WIDTH_DIV_6-1:0] sixes;
		for (i=0; i<WIDTH_DIV_6; i=i+1) 
		begin : m6
			assign sixes[i] = !higher_select[i] & (
				triples[2*i+1] | 
				(!sel[6*i+3] & !sel[6*i+4] & !sel[6*i+5] & triples[2*i]));
		end   
		assign out = |sixes;
	end
endgenerate    
endmodule
