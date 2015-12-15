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

// baeckler - 03-29-2006
// speed test bench for carry select adder

module select_add_speed_test (clk,a,b,o);

parameter BLOCK_SIZE = 14;
parameter NUM_BLOCKS = 4;
parameter DAT_WIDTH = BLOCK_SIZE * NUM_BLOCKS;

parameter METHOD = 0;

input clk;
input [DAT_WIDTH-1:0] a,b;
output [DAT_WIDTH:0] o;

reg [DAT_WIDTH-1:0] ra,rb;
reg [DAT_WIDTH:0] ro;

always @(posedge clk) begin
    ra <= a;
    rb <= b;
end

generate

if (METHOD == 0) begin

  car_select_add la (.clk(clk),.a(ra),.b(rb),.o(o));
     defparam la .BLOCK_SIZE = BLOCK_SIZE;
     defparam la .NUM_BLOCKS = NUM_BLOCKS;
end
else begin
  always @(posedge clk) begin
	ro <= ra + rb;
  end	
  assign o = ro;
end
endgenerate

endmodule 