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

// baeckler - 07-10-2006
// Vanilla dual port RAM 
// use the quartus/eda/sim_lib/altera_mf.v library to simulate
//
module ram_block (
	aclr_a,
	aclr_b,
	address_a,
	address_b,
	clock_a,
	clock_b,
	data_a,
	data_b,
	wren_a,
	wren_b,
	q_a,
	q_b
);

`include "log2.inc"

parameter NUM_WORDS = 512;
parameter DAT_WIDTH = 72;
localparam ADDR_WIDTH = log2(NUM_WORDS-1);

	input   aclr_a;
	input   aclr_b;
	input	[ADDR_WIDTH-1:0]  address_a;
	input	[ADDR_WIDTH-1:0]  address_b;
	input   clock_a;
	input   clock_b;
	input	[DAT_WIDTH-1:0]  data_a;
	input	[DAT_WIDTH-1:0]  data_b;
	input   wren_a;
	input   wren_b;
	output	[DAT_WIDTH-1:0]  q_a;
	output	[DAT_WIDTH-1:0]  q_b;

	altsyncram	altsyncram_component (
				.wren_a (wren_a),
				.aclr0 (aclr_a),
				.clock0 (clock_a),
				.wren_b (wren_b),
				.aclr1 (aclr_b),
				.clock1 (clock_b),
				.address_a (address_a),
				.address_b (address_b),
				.data_a (data_a),
				.data_b (data_b),
				.q_a (q_a),
				.q_b (q_b),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.eccstatus (),
				.rden_a (1'b1),
				.rden_b (1'b1)
	);

	defparam
		altsyncram_component.address_reg_b = "CLOCK1",
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_input_b = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.clock_enable_output_b = "BYPASS",
		altsyncram_component.indata_reg_b = "CLOCK1",
		altsyncram_component.intended_device_family = "Stratix II",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = NUM_WORDS,
		altsyncram_component.numwords_b = NUM_WORDS,
		altsyncram_component.operation_mode = "BIDIR_DUAL_PORT",
		altsyncram_component.outdata_aclr_a = "CLEAR0",
		altsyncram_component.outdata_aclr_b = "CLEAR1",
		altsyncram_component.outdata_reg_a = "CLOCK0",
		altsyncram_component.outdata_reg_b = "CLOCK1",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.ram_block_type = "AUTO",
		altsyncram_component.widthad_a = ADDR_WIDTH,
		altsyncram_component.widthad_b = ADDR_WIDTH,
		altsyncram_component.width_a = DAT_WIDTH,
		altsyncram_component.width_b = DAT_WIDTH,
		altsyncram_component.width_byteena_a = 1,
		altsyncram_component.width_byteena_b = 1,
		altsyncram_component.wrcontrol_wraddress_reg_b = "CLOCK1";

endmodule
