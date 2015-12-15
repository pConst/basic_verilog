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
//
// Combines (NUM_EXTERNAL_RESETS) external asynchronous active low resets.
//   Any active reset will reset the entire system immediately (even
//   if the clocks are not operating).
//
// Generate (NUM_DOMAINS) rstn signals, with guaranteed removal
//   timing with respect to the corresponding clock domains.
//
// The SEQUENTIAL_RELEASE parameter requires that rstn[0] is released
// before rstn[1] and so on.   For bringing up complex multi domain
// logic in the proper order.
//

module reset_control (
	external_rstn,
	clk,
	rstn	
);

parameter NUM_EXTERNAL_RESETS = 3;
parameter NUM_DOMAINS = 4;
parameter SEQUENTIAL_RELEASE = 1'b1;

input [NUM_EXTERNAL_RESETS-1:0] external_rstn;
input [NUM_DOMAINS-1:0] clk;
output [NUM_DOMAINS-1:0] rstn;

genvar i;

//////////////////////////////////
// filter the resets to ensure 
// min pulse width, and synch
// removal, with respect to clock 0
//////////////////////////////////
wire [NUM_EXTERNAL_RESETS-1:0] filtered_rstn;
generate
for (i=0; i<NUM_EXTERNAL_RESETS; i=i+1)
begin : lp0
  reset_filter rf_extern (
    .enable(1'b1),
	.rstn_raw(external_rstn[i]),
	.clk(clk[0]),
	.rstn_filtered(filtered_rstn[i]));
end
endgenerate

//////////////////////////////////////////////
// combine the various external reset sources
// to form a single system reset with respect 
// to clock 0
//////////////////////////////////////////////
wire sys_rstn = &filtered_rstn;

reset_filter rf_sys (
    .enable(1'b1),
	.rstn_raw(sys_rstn),
	.clk(clk[0]),
	.rstn_filtered(rstn[0]));

//////////////////////////////////////////////
// release remaining resets either as convenient
// or sequentially, according to parameter
//////////////////////////////////////////////
generate 
for (i=1;i<NUM_DOMAINS;i=i+1)
begin : lp1
    reset_filter rf_out (
	    .enable(SEQUENTIAL_RELEASE ? rstn[i-1] : 1'b1),
	    .rstn_raw(sys_rstn),
	    .clk(clk[i]),
	    .rstn_filtered(rstn[i])
	);
end
endgenerate

endmodule
