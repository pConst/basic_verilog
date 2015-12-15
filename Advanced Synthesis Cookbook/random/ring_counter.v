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

// baeckler - 11-14-2005
// counter with unstable count enable signal based
// on ring oscillator.

module ring_counter (clk,rst,out);

parameter DELAY = 100;

input clk,rst;
output [15:0] out;

wire [DELAY-1:0] delay_line /* synthesis keep */;

reg [15:0] cntr;
reg sync0;
reg wobble;

// unstable ring oscillator
genvar i;
generate
for (i=1; i<DELAY; i=i+1)
  begin : del
    assign delay_line [i] = delay_line[i-1];
  end
endgenerate
assign delay_line [0] = !delay_line [DELAY-1];

// sync it over to the input clock
always @(posedge clk) begin
  sync0 <= delay_line[0];
  wobble <= sync0;
end

// count when the wobbly oscillator is high
always @(posedge clk or posedge rst) begin
  if (rst) cntr <= 0;
  else if (wobble) cntr <= cntr + 1;
end

assign out = cntr;

endmodule
