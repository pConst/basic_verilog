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
// Storage register with don't care comparator 
// for use in register based ternary CAM

module reg_cam_cell (
	clk,rst,
	wdata,wcare,wused,wena,
	lookup_data,match
);

parameter DATA_WIDTH = 32;

input clk,rst;
input [DATA_WIDTH-1:0] wdata, wcare;
input wused,wena;

input [DATA_WIDTH-1:0] lookup_data;
output match;
reg match;

reg cell_used;

// Storage cells
reg [DATA_WIDTH - 1 : 0] data;
reg [DATA_WIDTH - 1 : 0] care;
always @(posedge clk) begin
  if (rst) begin
	cell_used <= 1'b0;
	data <= {DATA_WIDTH{1'b0}};
	care <= {DATA_WIDTH{1'b0}};
  end else begin
	if (wena) begin
	   cell_used <= wused;
	   data <= wdata;
       care <= wcare;
	end
  end
end

// Ternary match
wire [DATA_WIDTH-1:0] bit_match;
genvar i;
generate 
  for (i=0; i<DATA_WIDTH; i=i+1)
  begin : bmt
    assign bit_match[i] = !care[i] | !(data[i] ^ lookup_data[i]);
  end
endgenerate

always @(posedge clk) begin
  if (rst) match <= 1'b0;
  else match <= (& bit_match) & cell_used;
end

endmodule
