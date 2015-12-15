// Copyright 2008 Altera Corporation. All rights reserved.  
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

//baeckler - 12-05-2007

module clock_mux (clk,clk_select,clk_out);

parameter NUM_CLOCKS = 4;
parameter USE_FOLLOWERS = 1'b0;

input [NUM_CLOCKS-1:0] clk;
input [NUM_CLOCKS-1:0] clk_select; // one hot
output clk_out;

genvar i;

reg [NUM_CLOCKS-1:0] ena_r0;
reg [NUM_CLOCKS-1:0] ena_r1;
reg [NUM_CLOCKS-1:0] ena_r2;
wire [NUM_CLOCKS-1:0] qualified_sel;

// A LUT can glitch when multiple inputs slew 
// simultaneously (in theory indepently of the function).  
// Insert a hard LCELL to prevent the unrelated clocks
// from appearing on the same LUT.

wire [NUM_CLOCKS-1:0] gated_clks /* synthesis keep */;

initial begin
  ena_r0 = 0;
  ena_r1 = 0;
  ena_r2 = 0;
end

generate
for (i=0; i<NUM_CLOCKS; i=i+1) 
begin : lp0

  wire [NUM_CLOCKS-1:0] tmp_mask;
  assign tmp_mask = {NUM_CLOCKS{1'b1}} ^ (1 << i);

  assign qualified_sel[i] = clk_select[i] & 
			(~|(ena_r2 & tmp_mask));
  
  always @(posedge clk[i]) begin
    ena_r0[i] <= qualified_sel[i];    	
    ena_r1[i] <= ena_r0[i];    	
  end
  
  always @(negedge clk[i]) begin
    ena_r2[i] <= ena_r1[i];    	
  end

  if (USE_FOLLOWERS) begin
     wire cf_out;
     clock_follow cf (.clk_in(clk[i]),.clk_out(cf_out));
	 assign gated_clks[i] = cf_out & ena_r2[i];
  end
  else begin
     assign gated_clks[i] = clk[i] & ena_r2[i];
  end
end
endgenerate

// these will not exhibit simultaneous toggle by construction.
assign clk_out = |gated_clks;

endmodule