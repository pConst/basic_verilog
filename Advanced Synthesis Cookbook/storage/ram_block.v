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

// Basic RAM wrapper, 1 read 1 write port on common clock.

module ram_block (
	clk,
	data,
	rdaddress,
	wraddress,
	wren,
	q
);

parameter DAT_WIDTH = 36;
parameter ADDR_WIDTH = 7;

input	clk;
input	[DAT_WIDTH-1:0]  data;
input	[ADDR_WIDTH-1:0]  rdaddress;
input	[ADDR_WIDTH-1:0]  wraddress;
input	wren;
output	[DAT_WIDTH-1:0]  q;

altsyncram	altsyncram_component (
			.wren_a (wren),
			.clock0 (clk),
			.address_a (wraddress),
			.address_b (rdaddress),
			.data_a (data),
			.q_b (q),
			.aclr0 (1'b0),
			.aclr1 (1'b0),
			.addressstall_a (1'b0),
			.addressstall_b (1'b0),
			.byteena_a (1'b1),
			.byteena_b (1'b1),
			.clock1 (1'b1),
			.clocken0 (1'b1),
			.clocken1 (1'b1),
			.clocken2 (1'b1),
			.clocken3 (1'b1),
			.data_b ({DAT_WIDTH{1'b1}}),
			.eccstatus (),
			.q_a (),
			.rden_a (1'b1),
			.rden_b (1'b1),
			.wren_b (1'b0));
defparam
	altsyncram_component.address_reg_b = "CLOCK0",
	altsyncram_component.clock_enable_input_a = "BYPASS",
	altsyncram_component.clock_enable_input_b = "BYPASS",
	altsyncram_component.clock_enable_output_a = "BYPASS",
	altsyncram_component.clock_enable_output_b = "BYPASS",
	altsyncram_component.intended_device_family = "Stratix II",
	altsyncram_component.lpm_type = "altsyncram",
	altsyncram_component.numwords_a = (1<<ADDR_WIDTH),
	altsyncram_component.numwords_b = (1<<ADDR_WIDTH),
	altsyncram_component.operation_mode = "DUAL_PORT",
	altsyncram_component.outdata_aclr_b = "NONE",
	altsyncram_component.outdata_reg_b = "CLOCK0",
	altsyncram_component.power_up_uninitialized = "FALSE",
	altsyncram_component.ram_block_type = "AUTO",
	altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
	altsyncram_component.widthad_a = ADDR_WIDTH,
	altsyncram_component.widthad_b = ADDR_WIDTH,
	altsyncram_component.width_a = DAT_WIDTH,
	altsyncram_component.width_b = DAT_WIDTH,
	altsyncram_component.width_byteena_a = 1;

endmodule
