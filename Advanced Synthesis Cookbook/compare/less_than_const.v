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
// Check if data is less than constant value

module less_than_const (dat,out);

`include "compare_masks.inc"

parameter CONST_VAL = 64'h123456781234567a;
parameter METHOD = 4;
parameter WIDTH = 64;

// derive some more constants for local use
localparam NEXT_EVEN_WIDTH = (WIDTH & 1) ? WIDTH + 1 : WIDTH;
localparam NEXT_DIV3_WIDTH = WIDTH + (((WIDTH % 3) & 1) << 1) + (((WIDTH % 3) & 2) >> 1);

localparam HALF_WIDTH = NEXT_EVEN_WIDTH >> 1;
localparam THIRD_WIDTH = NEXT_DIV3_WIDTH / 3;

input [WIDTH-1:0] dat;
output out;
wire out;

	// Equivalent :
	// dat < CONST
	// dat - CONST < 0
	// dat - CONST sign bit is 1

genvar i,n;

// zero pad out the data and constant for convenience
wire [WIDTH+5:0] ext_dat = {6'b0,dat};
localparam EXT_CONST_VAL = {6'b0,CONST_VAL};

generate
	if (METHOD == 0) begin
		///////////////////////
		// Generic style
		///////////////////////
		assign out = dat < CONST_VAL;
	end
	else if (METHOD == 1) begin
		//////////////////////////////////
		// Carry chain - one cell per bit + 1
		//////////////////////////////////
		wire [WIDTH:0] chain;
		assign chain = dat - CONST_VAL;
		assign out = chain[WIDTH];
	end	
	else if (METHOD == 2) begin
		//////////////////////////////////
		// Carry chain - one cell per 2 bits + 1
		//////////////////////////////////
		wire [HALF_WIDTH:0] chain;
		wire [HALF_WIDTH-1 :0] g;
		wire [HALF_WIDTH-1 :0] p;

		// rephrase in terms of generate and propagate
		// carry - looking at two bits of the compare at
		// a time.
		for (i=0; i<HALF_WIDTH; i=i+1)
		begin : half
			wire [1:0] dat_bits = ext_dat[i*2+1 : i*2];
			wire [1:0] const_bits = EXT_CONST_VAL[i*2+1 : i*2];
			assign p [i] = (dat_bits == const_bits);
			assign g [i] = (dat_bits < const_bits);			 
		end
		assign chain = (g | p) + g;
		assign out = chain[HALF_WIDTH];
	end	
	else if (METHOD == 3) begin
		//////////////////////////////////////
		// Carry chain - one cell per 3 bits
		//		this doesn't actually fit, 
		//		but can be rephrased in share
		//		chain.
		//////////////////////////////////////
		wire [THIRD_WIDTH:0] chain;
		wire [THIRD_WIDTH-1 :0] g;
		wire [THIRD_WIDTH-1 :0] p;

		
		// rephrase in terms of generate and propagate
		// carry - looking at three bits of the compare at
		// a time.
		for (i=0; i<THIRD_WIDTH; i=i+1)
		begin : third
			wire [2:0] dat_bits = ext_dat[i*3+2 : i*3];
			wire [2:0] const_bits = EXT_CONST_VAL[i*3+2 : i*3];
			assign p [i] = (dat_bits == const_bits);
			assign g [i] = (dat_bits < const_bits);			 
		end
		assign chain = (g | p) + g;
		assign out = chain[THIRD_WIDTH];
	end	
	else if (METHOD == 4) begin
		//////////////////////////////////////////
		// WYS share chain - one cell per 3 bits
		//////////////////////////////////////////
		wire [THIRD_WIDTH:0] chain;
		wire [THIRD_WIDTH+1 : 0] cin;
		wire [THIRD_WIDTH+1 : 0] sin;

		assign cin[0] = 1'b0;
		assign sin[0] = 1'b0;

		for (i=0; i<=THIRD_WIDTH; i=i+1)
		begin : third
			stratixii_lcell_comb w (
				.dataa(1'b1),
				.datab(ext_dat[i*3+0]),
				.datac(ext_dat[i*3+1]),
				.datad(ext_dat[i*3+2]),
								
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
			
			// zero the share-out on the last cell
			defparam w .lut_mask =  {
				16'h0000,
				(i == THIRD_WIDTH ? 16'h0000 : 
					dcb_less_const_mask(EXT_CONST_VAL[i*3+2:i*3])),
				16'h0000,
				dcb_eq_const_mask(EXT_CONST_VAL[i*3+2:i*3])
			};			
		end

		// this carry out routing track cannot directly
		// fanout to other cells, it needs another cell
		// to leave the chain.
		
		stratixii_lcell_comb tail (
				.dataa(1'b1),
				.datab(1'b1),
				.datac(1'b1),
				.datad(1'b1),
								
				 // unused
				.datae(1'b0),
				.dataf(1'b0),
				.datag(1'b0),
				
				.cin(cin[THIRD_WIDTH+1]),
				.sharein(sin[THIRD_WIDTH+1]),
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