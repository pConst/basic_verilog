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

// baeckler - 03-02-2006
//
// compute - 
//    over ? (dat >= LOWER_BOUND) : (dat < UPPER_BOUND);  
//
// where upper and lower are constants
//
// Building block used for an efficient in-range comparator.
//  
module over_under (over,dat,out);

`include "compare_masks.inc"

parameter WIDTH = 32;
parameter UPPER_BOUND = 32'hae141234;
parameter LOWER_BOUND = 32'hae100010;
parameter METHOD = 3;

localparam [WIDTH:0] NEG_UPPER = ~UPPER_BOUND + 1;
localparam NEXT_EVEN_WIDTH = (WIDTH & 1) ? WIDTH + 1 : WIDTH;
localparam HALF_WIDTH = NEXT_EVEN_WIDTH >> 1;

input [WIDTH-1:0] dat;
input over;
output out;

// zero pad out the data and constant for convenience
wire [WIDTH+5:0] ext_dat = {6'b0,dat};
localparam EXT_LOWER = {6'b0,LOWER_BOUND};
localparam EXT_UPPER = {6'b0,UPPER_BOUND};
localparam EXT_NEG_UPPER = {6'b0,NEG_UPPER};

genvar i;
	
generate

	if (METHOD == 0) begin
		///////////////////////
		// Generic style
		///////////////////////
		assign out = over ? (dat >= LOWER_BOUND) : (dat < UPPER_BOUND);
	end
	else if (METHOD == 1) begin
		////////////////////////////////////////
		// Rephrased in terms of add / subtract
		////////////////////////////////////////
		wire [WIDTH:0] chain;
		
	 	//assign chain = (over ? (LOWER_BOUND + ~dat) : (dat-UPPER_BOUND));
		//assign chain = (over ? (LOWER_BOUND + ~dat) : (dat + ~UPPER_BOUND + 1));
		//assign chain = (over ? ~dat : dat) + (over ? LOWER_BOUND : ~UPPER_BOUND + 1);
		assign chain = (over ? ~dat : dat) + (over ? LOWER_BOUND : NEG_UPPER);
		assign out = chain[WIDTH];
	end
	else if (METHOD == 2) begin
		////////////////////////////////////////
		// Compress to 2 bits per cell
		//   this uses quite a bit of logic in 
		//   front of the carry chain.  Use
		//   WYS version to guarantee packing.
		////////////////////////////////////////
		wire [HALF_WIDTH:0] chain;
		wire [HALF_WIDTH-1 :0] g;
		wire [HALF_WIDTH-1 :0] p;

		// rephrase in terms of generate and propagate
		// carry - looking at two bits of the compare at
		// a time.
		for (i=0; i<HALF_WIDTH; i=i+1)
		begin : half
			wire [1:0] dat_bits = {over ^ ext_dat[i*2+1], over ^ ext_dat[i*2]};
			wire [1:0] const_bits = over ? EXT_LOWER [i*2+1:i*2] :
						EXT_NEG_UPPER [i*2+1:i*2];

			assign p [i] = (dat_bits[0] ^ const_bits[0]) & 
							(dat_bits[1] ^ const_bits[1]);
			assign g [i] = (dat_bits[1] & const_bits[1]) | 
							((dat_bits[0] & const_bits[0]) &
							(dat_bits[1] | const_bits[1]));						 
		end
		assign chain = (g | p) + g;
		assign out = !chain[HALF_WIDTH];
	end
	else if (METHOD == 3) begin
		////////////////////////////////////////
		// WYSIWYG share chain using 2 bits per cell
		////////////////////////////////////////
		wire [HALF_WIDTH:0] chain;
		wire [HALF_WIDTH+1 : 0] cin;
		wire [HALF_WIDTH+1 : 0] sin;

		assign cin[0] = 1'b0;
		assign sin[0] = 1'b0;

		for (i=0; i<=HALF_WIDTH; i=i+1)
		begin : half
			
			stratixii_lcell_comb w (
				.dataa(over),
				.datab(1'b1),
				.datac(ext_dat[i*2+0]),
				.datad(ext_dat[i*2+1]),
								
				 // unused
				.datae(1'b0),
				.dataf(1'b0),
				.datag(1'b0),
				
				.cin(cin[i]),
				.sharein(sin[i]),
				.sumout(chain[i]),
				.cout(cin[i+1]),	
				.combout(),
				.shareout(sin[i+1])
			);	
				
			defparam w .shared_arith = "on";
			defparam w .extended_lut = "off";
			
			defparam w .lut_mask =  
				// the 1st cell needs to do >= for over = 1, < for over = 0
				i == 0 ? {
					16'h0000,
					(16'haaaa & dc_ge_const_mask(EXT_LOWER[i*2+1:i*2])) |
					(16'h5555 & dc_less_const_mask(EXT_UPPER[i*2+1:i*2])),
					16'h0000,
					(16'haaaa & dc_eq_const_mask(EXT_LOWER[i*2+1:i*2])) |
					(16'h5555 & dc_eq_const_mask(EXT_UPPER[i*2+1:i*2]))
				}
				// following cells needs to do > for over = 1, < for over = 0
				:	{
					16'h0000,
					(16'haaaa & dc_greater_const_mask(EXT_LOWER[i*2+1:i*2])) |
					(16'h5555 & dc_less_const_mask(EXT_UPPER[i*2+1:i*2])),
					16'h0000,
					(16'haaaa & dc_eq_const_mask(EXT_LOWER[i*2+1:i*2])) |
					(16'h5555 & dc_eq_const_mask(EXT_UPPER[i*2+1:i*2]))
				};
						
		end
		
		// this carry out routing track cannot directly
		// fanout to other cells, it needs another cell
		// to leave the chain.
		
		// equiv to assign out = cin[HALF_WIDTH+1];

		stratixii_lcell_comb tail (
				.dataa(1'b1),
				.datab(1'b1),
				.datac(1'b1),
				.datad(1'b1),
								
				 // unused
				.datae(1'b0),
				.dataf(1'b0),
				.datag(1'b0),
				
				.cin(cin[HALF_WIDTH+1]),
				.sharein(sin[HALF_WIDTH+1]),
				.sumout(out),
				.cout(),	
				.combout(),
				.shareout()
		);

		defparam tail .shared_arith = "on";
		defparam tail .extended_lut = "off";
		defparam tail .lut_mask =  {
					16'h0000,
					16'hffff,
					16'h0000,
					16'h0000
				};					
		
	end

endgenerate

endmodule
