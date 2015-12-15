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

// baeckler - 03-30-2009
module four_lane_jtag_probe (
	
	// system clock
	input clk_sys,arst_sys,
		
	// lane probes - pre alignment data streams
	input [3:0] lane_clk,
	input [3:0] lane_arst,
	input [4*66-1:0] unaligned_dat,
	input [3:0] unaligned_dat_valid		
);

// how deep should the sample memory be?
parameter ADDR_BITS = 10;

// simulation option, ignore the JTAG probe
parameter SIMULATION_REMOVE_JTAG = 1'b0;

reg start_harvest;
wire [7:0] dout;
wire dout_ready,dout_valid,reporting;

//////////////////////////////////////////////
// capture 4 asynchronous streams 
//   simultaneously
//////////////////////////////////////////////

wire [72*4-1:0] padded_unaligned_dat;
genvar i;
generate
	for (i=0; i<4; i=i+1) begin : pd
		assign padded_unaligned_dat[72*(i+1)-1:72*i] = 
			{6'b0,unaligned_dat[66*(i+1)-1:66*i]};
	end
endgenerate

quad_stream_grabber qsg
(
	// streams to observe - independently clocked
	.clk_str(lane_clk),
	.arst_str(lane_arst),
	.data_in(padded_unaligned_dat),
	.data_in_valid(unaligned_dat_valid),
	
	// system clk / ctrl
	.clk_sys(clk_sys),
	.arst_sys(arst_sys),
	.start_harvest(start_harvest),
	
	// combined output
	.dout(dout),
	.dout_ready(dout_ready),
	.dout_valid(dout_valid),
	.reporting(reporting)	
);
defparam qsg .ADDR_BITS = ADDR_BITS;

//////////////////////////////////////////////
// Convert to ASCII HEX for a little integrity
//   checking.
//////////////////////////////////////////////

wire [15:0] jtag_data;
wire jtag_data_ready, jtag_data_valid;

bin_to_asc_hex bah (
	.in(dout),
	.out(jtag_data)
);
defparam bah .WIDTH = 8;

assign jtag_data_valid = dout_valid;
assign dout_ready = jtag_data_ready;

//////////////////////////////////////////////
// Push the data out the JTAG port
//////////////////////////////////////////////

generate
	if (SIMULATION_REMOVE_JTAG) begin
		assign jtag_data_ready = 1'b1;
	end
	else begin
		jtag_to_c_probe jc
		(
			// !!
			// drop the JTAG signals - will be auto connected by Quartus
			// !!
			
			// internal sigs
			// data to and from host PC
			.core_clock(clk_sys),
			
			// PC to FPGA path is unused here
			.dat_from_host(),
			.dat_from_host_ready(1'b0),
			.dat_from_host_valid(),
			
			// send stream back to host.
			.dat_to_host(jtag_data),
			.dat_to_host_valid(jtag_data_valid),
			.dat_to_host_ready(jtag_data_ready)	
		);
	end
endgenerate

//////////////////////////////////////////////
// Harvest continuously
//////////////////////////////////////////////

reg cntr_rst,cntr_max;
reg [4:0] cntr;
always @(posedge clk_sys) begin
	if (cntr_rst) cntr <= 0;
	else cntr <= cntr + 1'b1;
	cntr_max <= & cntr;
end

localparam ST_PAUSE = 0, ST_START = 1, ST_LISTEN = 2;
reg [1:0] state /* synthesis preserve */;

always @(posedge clk_sys or posedge arst_sys) begin
	if (arst_sys) begin
		state <= ST_PAUSE;
		start_harvest <= 0;
		cntr_rst <= 1'b1;
	end
	else begin
		case (state)
			ST_PAUSE : begin
				if (cntr_max) state <= ST_START;
				cntr_rst <= 1'b0;
			end
			ST_START : begin
				start_harvest <= 1'b1;
				if (reporting) state <= ST_LISTEN;
			end
			ST_LISTEN : begin
				cntr_rst <= 1'b1;
				start_harvest <= 1'b0;
				if (!reporting) state <= ST_PAUSE;
			end
		endcase
	end
end	

endmodule