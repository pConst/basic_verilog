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

// baeckler - 04-25-2007

module fifo_hw_test (
	clk_x,clk_y,aclr,
	mode,	
	mismatch,any_mismatch,rd_empty,wr_full,
	cntr
);

parameter DAT_WIDTH = 16;
parameter ADDR_WIDTH = 5; // small enough to hit the extremes easily
parameter USE_LPM_DCFIFO = 1'b0; // use LPM DCFIFO, not fifo.v
parameter SIMULATION = 1'b0; // use model for ram in fifo.v

input clk_x,clk_y,aclr;
input [1:0] mode;
output mismatch,any_mismatch,rd_empty,wr_full;
output [15:0] cntr;

reg [15:0] cntr;

wire rd_clk,wr_clk;
assign rd_clk = clk_x;
assign wr_clk = clk_y;

////////////////////////////////////
// Test pattern generate and check
////////////////////////////////////
wire go_read,go_write;
wire [DAT_WIDTH-1:0] wr_dat,compare_dat,rd_dat;
reg [DAT_WIDTH-1:0]last_compare_dat;

test_pattern gen_pat (.clk(wr_clk),
					.aclr(aclr),
					.ena(go_write),
					.val(wr_dat));

	defparam gen_pat .WIDTH = DAT_WIDTH;

test_pattern check_pat (.clk(rd_clk),
					.aclr(aclr),
					.ena(go_read),
					.val(compare_dat));
	defparam check_pat .WIDTH = DAT_WIDTH;

always @(posedge rd_clk or posedge aclr) begin
	if (aclr) last_compare_dat <= 0;
	else if (go_read) last_compare_dat <= compare_dat;
end

// compare to expected results
//   the output before any read req is not
//	defined.
reg mismatch,any_mismatch;
reg data_ready,last_data_ready;
always @(posedge rd_clk or posedge aclr) begin
	if (aclr) begin
		mismatch <= 1'b0;
		any_mismatch <= 1'b0;
		data_ready <= 1'b0;
		last_data_ready <= 1'b0;
	end
	else begin
		if (go_read) begin
			data_ready <= 1'b1;
			last_data_ready <= data_ready;
			mismatch <= |(last_compare_dat ^ rd_dat);
			if (!last_data_ready) any_mismatch <= 1'b0;
			else any_mismatch <= any_mismatch | mismatch;
		end
	end
end

////////////////////////////////////
// FIFO under test
////////////////////////////////////

generate 
if (!USE_LPM_DCFIFO) begin
	fifo f (
		.aclr(aclr),

		.rd_dat(rd_dat),
		.rd_clk(rd_clk),
		.rd_req(go_read),
		.rd_empty(rd_empty),
		.rd_used(),

		.wr_dat(wr_dat),
		.wr_clk(wr_clk),
		.wr_req(go_write),
		.wr_full(wr_full),
		.wr_used()
	);

	defparam f .DAT_WIDTH = DAT_WIDTH;
	defparam f .ADDR_WIDTH = ADDR_WIDTH;
	defparam f .SIMULATION = SIMULATION;
end
else begin
	dcfifo dcfifo_component (
            .wrclk (wr_clk),
            .rdreq (go_read),
            .rdclk (rd_clk),
            .wrreq (go_write),
            .data (wr_dat),
            .rdempty (rd_empty),
            .wrusedw (),
            .wrfull (wr_full),
            .q (rd_dat),
            .rdusedw (),
            .aclr (aclr),
            .rdfull (),
            .wrempty ()
         );
defparam
    dcfifo_component.intended_device_family = "Stratix II",
    dcfifo_component.lpm_hint = "MAXIMIZE_SPEED=5,",
    dcfifo_component.lpm_numwords = 1 << ADDR_WIDTH,
    dcfifo_component.lpm_showahead = "OFF",
    dcfifo_component.lpm_type = "dcfifo",
    dcfifo_component.lpm_width = DAT_WIDTH,
    dcfifo_component.lpm_widthu = ADDR_WIDTH,
    dcfifo_component.overflow_checking = "ON",
    dcfifo_component.rdsync_delaypipe = 4,
    dcfifo_component.underflow_checking = "ON",
    dcfifo_component.use_eab = "ON",
    dcfifo_component.wrsync_delaypipe = 4;
end
endgenerate

////////////////////////////////////
// read / write pacing
////////////////////////////////////
reg mode_r, mode_rr, mode_w, mode_ww;

always @(posedge rd_clk or posedge aclr) begin
	if (aclr) mode_r <= 1'b0;
	else begin
		mode_r <= mode[0];
		mode_rr <= mode_r;
	end
end

always @(posedge wr_clk or posedge aclr) begin
	if (aclr) mode_w <= 1'b0;
	else begin
		mode_w <= mode[1];
		mode_ww <= mode_w;
	end
end

assign go_write = mode_ww ? !wr_full : 1'b0;
assign go_read = mode_rr ? !rd_empty : 1'b0;

always @(posedge rd_clk or posedge aclr) begin
	if (aclr) cntr <= 0;
	else if (go_read) cntr <= cntr + 1'b1;
end

endmodule

