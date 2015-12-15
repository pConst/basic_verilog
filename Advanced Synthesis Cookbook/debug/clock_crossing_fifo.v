// Copyright 2009 Altera Corporation. All rights reserved.  
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

// baeckler - 03-23-2009
// simple clock crossing with ready / valid signals

module clock_crossing_fifo #(
	parameter DAT_WIDTH = 16,
	parameter WORDS = 32
)
(
	input wrclk,
	input wdata_valid,
	input [DAT_WIDTH-1:0] wdata,
	output wdata_ready,
	
	input rdclk,
	input rdata_ready,
	output [DAT_WIDTH-1:0] rdata,
	output reg rdata_valid	
);

`include "log2.inc"

wire wrreq, rdreq, rdempty, wrfull;

assign wdata_ready = !wrfull;
assign wrreq = wdata_valid & wdata_ready;
assign rdreq = !rdempty & (!rdata_valid | rdata_ready);

initial rdata_valid = 1'b0;
always @(posedge rdclk) begin
	if (rdata_ready) rdata_valid <= 1'b0;
	if (rdreq) rdata_valid <= 1'b1;
end

dcfifo    dcfifo_component (
            .wrclk (wrclk),
            .rdreq (rdreq),
            .rdclk (rdclk),
            .wrreq (wrreq),
            .data (wdata),
            .rdempty (rdempty),
            .wrfull (wrfull),
            .q (rdata),
            .aclr (1'b0),
            .rdfull (),
            .rdusedw (),
            .wrempty (),
            .wrusedw ()            
);
defparam
    dcfifo_component.intended_device_family = "Stratix II",
    dcfifo_component.lpm_numwords = WORDS,
    dcfifo_component.lpm_showahead = "OFF",
    dcfifo_component.lpm_type = "dcfifo",
    dcfifo_component.lpm_width = DAT_WIDTH,
    dcfifo_component.lpm_widthu = log2(WORDS-1),
    dcfifo_component.overflow_checking = "ON",
    dcfifo_component.rdsync_delaypipe = 4,
    dcfifo_component.underflow_checking = "ON",
    dcfifo_component.use_eab = "ON",
    dcfifo_component.wrsync_delaypipe = 4;

endmodule