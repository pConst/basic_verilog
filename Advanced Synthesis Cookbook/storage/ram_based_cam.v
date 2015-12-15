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

// Ternary CAM made from stitched RAM based blocks

module ram_based_cam (clk,rst,start_write,waddr,wdata,wcare,
	lookup_data,match_lines,ready);

parameter DATA_BLOCKS = 5;  // number of blocks of 7 bits
parameter ADDR_WIDTH = 5; 

localparam DATA_PER_BLOCK = 7;   // Note : affects write latency
localparam DATA_WIDTH = DATA_BLOCKS * DATA_PER_BLOCK;
localparam WORDS = (1 << ADDR_WIDTH);

input clk,rst,start_write;
input [ADDR_WIDTH-1:0] waddr;
input [DATA_WIDTH-1:0] wdata,wcare;
input [DATA_WIDTH-1:0] lookup_data;
output [WORDS-1:0] match_lines;
wire [WORDS-1:0] match_lines;
output ready;

// Workhorse blocks, stitch to create wider data

wire [DATA_BLOCKS * WORDS-1:0] block_match_lines;
wire [DATA_BLOCKS-1:0] block_ready;

genvar i,j;
generate
	for (i=0;i<DATA_BLOCKS;i=i+1)
	begin : db			
		cam_ram_block cr (
			.clk(clk),
			.rst(rst),
			.waddr(waddr),
			.wdata(wdata[DATA_PER_BLOCK*(i+1)-1:DATA_PER_BLOCK*i]),
			.wcare(wcare[DATA_PER_BLOCK*(i+1)-1:DATA_PER_BLOCK*i]),
			.start_write(start_write),
			.ready(block_ready[i]),
			.lookup_data(lookup_data[DATA_PER_BLOCK*(i+1)-1:DATA_PER_BLOCK*i]),
			.match_lines(block_match_lines[WORDS*(i+1)-1:WORDS*i])
		);
		defparam cr .DATA_WIDTH = DATA_PER_BLOCK;
		defparam cr .ADDR_WIDTH = ADDR_WIDTH;
	end
endgenerate

// In the current design all of the block readies will
// move together.  If they were allowed to cut corners
// on the don't care for example they should be AND ed
// together
assign ready = block_ready[0];

// Combine match lines.  Address match must be true for
// all data blocks to be true for the full data word.

generate
	for (j=0;j<WORDS;j=j+1) 
	begin : mta
		wire [DATA_BLOCKS-1:0] tmp_match;
		for (i=0;i<DATA_BLOCKS;i=i+1)
		begin : mtb
			assign tmp_match[i] = block_match_lines[WORDS*i+j];
		end
		assign match_lines[j] = &tmp_match;
	end
endgenerate

endmodule