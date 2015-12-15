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

// 
// Asynchronous reset filter
// Important properties :
//
//	1) The reset_n propagates immediately to output,
//    even if the clock is not operating.
//
//  2) The reset pulse will last for at least (PULSE_HOLD - 1)
//    clock ticks. 
//
//  3) The removal (de-assertion) of the reset will occur 
//    synchronously
//
//  4) circuit powers up in the reset asserted state
//
//  5) circuit can only leave the reset state if clock is 
//    operating, and enable = 1

module reset_filter (
	enable,
	rstn_raw,
	clk,
	rstn_filtered
);

//
// "2" is the most common number for this parameter
// (enforces at least 1 cycle of reset)
//
// I personally am willing to spend 1 more register
// to see a nice robust length 2+ pulse.   The LABwide
// clr is already selected, might as well USE it.
//
parameter PULSE_HOLD = 3;  

input enable;
input rstn_raw;
input clk;
output rstn_filtered;

reg [PULSE_HOLD-1:0] rstn_reg /* synthesis preserve */;
initial rstn_reg = {PULSE_HOLD{1'b0}};

always @(posedge clk or negedge rstn_raw) begin
  if (!rstn_raw) begin
    rstn_reg <= {PULSE_HOLD{1'b0}};
  end
  else begin
	rstn_reg <= {enable,rstn_reg[PULSE_HOLD-1:1]};
  end
end

assign rstn_filtered = rstn_reg[0];

endmodule
