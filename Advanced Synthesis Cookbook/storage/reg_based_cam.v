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


//////////////////////////////////////////
// baeckler - 08-24-2007
//
// Parameterized ternary CAM made from registers (no RAM)
// 
// 1 tick read and write, 1hot match output
//
module reg_based_cam (
	clk,rst,
	waddr,wdata,wcare,wena,
	lookup_data,match_lines
);

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 4;
parameter WORDS = (1<<ADDR_WIDTH);

input clk,rst;
input [ADDR_WIDTH-1:0] waddr;
input [DATA_WIDTH-1:0] wdata,wcare;
input wena;

input [DATA_WIDTH-1:0] lookup_data;
output [WORDS-1:0] match_lines;
wire [WORDS-1:0] match_lines;

// write decoder
wire [WORDS-1:0] word_wena;
reg [WORDS-1:0] waddr_dec;
always @(*) begin
    waddr_dec = 0;
    waddr_dec[waddr] = 1'b1;
end
assign word_wena = waddr_dec & {WORDS{wena}};

// writing "all don't care" disables the word.
wire wused = |wcare /*synthesis keep*/;

// storage and match cells
genvar i;
generate 
  for (i=0; i<WORDS; i=i+1)
  begin : cw
    reg_cam_cell c (
		.clk(clk),
		.rst(rst),
		.wdata(wdata),
		.wcare(wcare),
		.wused(wused),
		.wena(word_wena[i]),
		.lookup_data(lookup_data),
		.match(match_lines[i])
    );
    defparam c .DATA_WIDTH = DATA_WIDTH; 
  end
endgenerate

// match encoder

endmodule

//////////////////////////////////////////
