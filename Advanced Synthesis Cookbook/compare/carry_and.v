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

// baeckler - 03-01-2006

module carry_and (dat,out);

parameter WIDTH = 32;
parameter METHOD = 4;

input [WIDTH-1:0] dat;
output out;

// figure out pairs and triples of inputs
localparam NEXT_EVEN_WIDTH = (WIDTH & 1) ? WIDTH + 1 : WIDTH;
localparam HALF_WIDTH = NEXT_EVEN_WIDTH >> 1;
localparam NEXT_DIV3_WIDTH = WIDTH + (((WIDTH % 3) & 1) << 1) + (((WIDTH % 3) & 2) >> 1);
localparam THIRD_WIDTH = NEXT_DIV3_WIDTH / 3;

wire [WIDTH + 2 : 0] ext_dat = {3'b111,dat};

genvar i;
generate
	if (METHOD == 0) begin
		///////////////////////
		// Generic style
		///////////////////////
		assign out = &dat;
	end
	else if (METHOD == 1) begin
		///////////////////////
		// 1 bit per cell carry chain
		///////////////////////
		wire [WIDTH:0] result;
		assign result = dat + 1'b1;
		assign out = result[WIDTH];
	end
	else if (METHOD == 2) begin
		////////////////////////////////
		// 2 bit per cell carry chain
		////////////////////////////////
		wire [HALF_WIDTH-1:0] pairs;
		wire [HALF_WIDTH:0] result;

		assign pairs = ext_dat[HALF_WIDTH-1:0] & 
					ext_dat[2*HALF_WIDTH-1:HALF_WIDTH];
		assign result = pairs + 1'b1;
		assign out = result[HALF_WIDTH];
	end
	else if (METHOD == 3) begin
		////////////////////////////////
		// 3 bit per cell carry chain
		//   may not absorb fully.
		//   it will also be very tempting
		//   for synthesit to unmap to 6 LUT.
		// Use Method = 4;
		////////////////////////////////
		wire [THIRD_WIDTH-1:0] triplets;
		wire [THIRD_WIDTH:0] result;

		assign triplets = ext_dat[THIRD_WIDTH-1:0] & 
						ext_dat[2*THIRD_WIDTH-1:THIRD_WIDTH] &
						ext_dat[3*THIRD_WIDTH-1:2*THIRD_WIDTH];
		assign result = triplets + 1'b1;
		assign out = result[THIRD_WIDTH];
	end
	else if (METHOD == 4) begin
		//////////////////////////////////////////
		// 3 bit per cell Wide AND carry chain
		//   WYSIWYG version
		//////////////////////////////////////////
		wire [THIRD_WIDTH:0] result;
		wire [THIRD_WIDTH+1:0] cin;
	
		assign cin[0] = 1'b0;

		for (i=0; i<THIRD_WIDTH; i=i+1)
		begin : third
			stratixii_lcell_comb w (
				.dataa(1'b0),
				.datab(ext_dat[i*3+0]),
				.datac(ext_dat[i*3+1]),
				.datad(ext_dat[i*3+2]),
								
				 // unused
				.datae(1'b0),
				.dataf(1'b0),
				.datag(1'b0),
				
				.cin(cin[i]),
				.sumout(result[i]),
				.cout(cin[i+1]),	
				
				.sharein(1'b0),
				.combout(),
				.shareout()
			);	
			
			defparam w .shared_arith = "off";
			defparam w .extended_lut = "off";
			
			// 1 + B&C&D  (quad 3 is inverted)
			defparam w .lut_mask =  
				i == 0 ? 64'h000000000000c000 :
						64'h0000ffff0000c000;
		end
		assign out = cin[THIRD_WIDTH];
	end
endgenerate
endmodule