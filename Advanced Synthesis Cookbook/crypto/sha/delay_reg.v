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

// baeckler - 12-13-2006
module delay_reg (
	clock,
	enable,
	data_in,
	data_out
);

parameter DEPTH = 7;					// Minimum legal DEPTH is 2 
parameter WIDTH = 64;

// RAM info
parameter ADDR_WIDTH = 4;				// 2^ADDR_WIDTH must be > DEPTH
parameter NUM_WORDS = 1 << ADDR_WIDTH;

input	  clock,enable;
input	[WIDTH-1:0]  data_in;
output	[WIDTH-1:0]  data_out;

reg [ADDR_WIDTH-1:0] pointer;
wire [ADDR_WIDTH-1:0] adv_pointer = pointer + (DEPTH - 2); // 2 is for RAM IO regs

// this value does not matter, but must not be X
initial begin
	pointer = 0;
end

always @(posedge clock) begin
	if (enable)	pointer <= pointer + 1'b1;
end
	
altsyncram	altsyncram_component (
				.wren_a (1'b1),
				.clock0 (clock),
				.wren_b (1'b0),
				.address_a (adv_pointer),
				.address_b (pointer),
				.data_a (data_in),
				.data_b ({WIDTH{1'b0}}),
				.q_a (),
				.q_b (data_out),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken0 (enable),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.eccstatus (),
				.rden_a (1'b1),
				.rden_b (1'b1));
	defparam
		altsyncram_component.address_reg_b = "CLOCK0",
		altsyncram_component.clock_enable_input_a = "NORMAL",
		altsyncram_component.clock_enable_input_b = "NORMAL",
		altsyncram_component.clock_enable_output_a = "NORMAL",
		altsyncram_component.clock_enable_output_b = "NORMAL",
		altsyncram_component.indata_reg_b = "CLOCK0",
		altsyncram_component.intended_device_family = "Stratix II",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = NUM_WORDS,
		altsyncram_component.numwords_b = NUM_WORDS,
		altsyncram_component.operation_mode = "BIDIR_DUAL_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_aclr_b = "NONE",
		altsyncram_component.outdata_reg_a = "CLOCK0",
		altsyncram_component.outdata_reg_b = "CLOCK0",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
		altsyncram_component.widthad_a = ADDR_WIDTH,
		altsyncram_component.widthad_b = ADDR_WIDTH,
		altsyncram_component.width_a = WIDTH,
		altsyncram_component.width_b = WIDTH,
		altsyncram_component.width_byteena_a = 1,
		altsyncram_component.width_byteena_b = 1,
		altsyncram_component.wrcontrol_wraddress_reg_b = "CLOCK0";

endmodule
