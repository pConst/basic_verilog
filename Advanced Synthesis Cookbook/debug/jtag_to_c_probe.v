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


// note the JTAG hub signals and parameters will be magically
// updated during compile.

module jtag_to_c_probe #
(
	parameter   INSTANCE_ID = 8'h0,
    parameter   SLD_NODE_INFO = {5'h01,8'h30,11'h06E,8'h00} | (INSTANCE_ID & 8'hff),
                         // node_ver[31:27], node_id[26:19], mfg_id[18:8], inst_id[7:0]
    parameter   SLD_AUTO_INSTANCE_INDEX = "YES",
    parameter   NODE_IR_WIDTH = 1,
    parameter   DAT_WIDTH = 16
)
(
	// Hub sigs
	input       raw_tck,                // raw node clock;
	input       tdi,                    // node data in;
	input       usr1,                   // Indicates that current instruction in the JSM is the USER1 instruction;
	input       clrn,                   // Asynchronous clear;
	input       ena,                    // Indicates that the current instruction in the Hub is for Node
	input       [NODE_IR_WIDTH-1:0] ir_in,  // Node IR;
	output      tdo,                    // Node data out
	output      [NODE_IR_WIDTH-1:0] ir_out, // Node IR capture port
	input       jtag_state_cdr,         // Indicates that the JSM is in the Capture_DR(CDR) state;
	input       jtag_state_sdr,         // Indicates that the JSM is in the Shift_DR(SDR) state;
	input       jtag_state_udr,         // Indicates that the JSM is in the Update_DR(UDR) state;

	// internal sigs
	// data to and from host PC
	input core_clock,
	
	output [DAT_WIDTH-1:0] dat_from_host,
	input dat_from_host_ready,
	output dat_from_host_valid,
	
	input [DAT_WIDTH-1:0] dat_to_host,
	input dat_to_host_valid,
	output dat_to_host_ready	
);

assign ir_out = ir_in;

reg [DAT_WIDTH-1:0] sr;
wire dr_select = ena & ~usr1;

reg	[DAT_WIDTH-1:0] dat_from_host_i;
reg	dat_from_host_valid_i;
wire [DAT_WIDTH-1:0] dat_to_host_i;
reg  dat_to_host_ack_i;	

/////////////////////////////////////////
// shift out data from FPGA to JTAG host
/////////////////////////////////////////

always @(posedge raw_tck or negedge clrn) begin
	if (!clrn) begin
		sr <= 0;
		dat_to_host_ack_i <= 1'b0;
	end
	else begin
		dat_to_host_ack_i <= 1'b0;
		if (dr_select) begin
			if (jtag_state_cdr) begin
				sr <= dat_to_host_i;
				dat_to_host_ack_i <= 1'b1;
			end

			if (jtag_state_sdr) begin
				sr <= {tdi,sr[DAT_WIDTH-1:1]};
			end			
		end
		else begin
			sr[0] <= tdi;
		end		
	end
end
assign tdo = sr[0];

////////////////////////////////////
// grab data from JTAG host to FPGA
////////////////////////////////////

always @(posedge raw_tck or negedge clrn) begin
	if (!clrn) begin
		dat_from_host_valid_i <= 1'b0;
		dat_from_host_i <= 0;
	end
	else begin
		dat_from_host_valid_i <= 1'b0;
		if (dr_select & jtag_state_udr) begin
			dat_from_host_i <= sr;
			dat_from_host_valid_i <= 1'b1;
		end		
	end
end

////////////////////////////////////
// cross clocks between FPGA to JTAG
////////////////////////////////////

clock_crossing_fifo cc0
(
	.wrclk(raw_tck),
	.wdata_valid(dat_from_host_valid_i),
	.wdata(dat_from_host_i),
	.wdata_ready(),
	
	.rdclk(core_clock),
	.rdata_ready (dat_from_host_ready),
	.rdata(dat_from_host),
	.rdata_valid(dat_from_host_valid)	
);
defparam cc0 .DAT_WIDTH = DAT_WIDTH;

wire dat_to_host_ready_i, dat_to_host_valid_i;
wire [DAT_WIDTH-1:0] dat_to_host_fifo_i;

assign dat_to_host_i = dat_to_host_valid_i ? dat_to_host_fifo_i : 16'h1234;
assign dat_to_host_ready_i = dat_to_host_ack_i;

clock_crossing_fifo cc1
(
	.wrclk(core_clock),
	.wdata_valid(dat_to_host_valid),
	.wdata(dat_to_host),
	.wdata_ready(dat_to_host_ready),
	
	.rdclk(raw_tck),
	.rdata_ready (dat_to_host_ready_i),
	.rdata(dat_to_host_fifo_i),
	.rdata_valid(dat_to_host_valid_i)	
);
defparam cc1 .DAT_WIDTH = DAT_WIDTH;

endmodule

