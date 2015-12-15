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

// baeckler - 06-11-2007 

// Latency 3 pipelined DSP block based multiplier.
// input width up to 36x36 with input, output, and pipeline registers.
//
// This was derived from a pipelined LPM MULT VQM.
// The awkward flow is necessary to be super explicit about
// where the registers are intended to be.  The tools
// are too clever for their own good sometimes.
//

module 	mult_3tick (
	clk,
	a_in,
	b_in,
	o
);

parameter IN_WIDTH = 36;
parameter OUT_WIDTH = 2 * IN_WIDTH;

input 	clk;
input 	[IN_WIDTH-1:0] a_in, b_in;
output 	[OUT_WIDTH-1:0] o;

// ENHANCEMENT - shift these left
wire [35:0] a = 36'b0 | a_in;
wire [35:0] b = 36'b0 | b_in;
wire [71:0] o_int;
assign o = o_int[OUT_WIDTH-1:0];

wire gnd;
wire vcc;
assign gnd = 1'b0;
assign vcc = 1'b1;

wire [35:0] mult1_out;
stratixii_mac_mult mult1_i (
	.signa(gnd),
	.signb(gnd),
	.sourcea(gnd),
	.sourceb(gnd),
	.round(gnd),
	.saturate(gnd),
	.dataa({a[17:0]}),
	.datab({b[17:0]}),
	.clk({clk_unconnected_wire_0,clk_unconnected_wire_1,clk_unconnected_wire_2,clk}),
	.aclr({gnd,gnd,gnd,gnd}),
	.ena({vcc,vcc,vcc,vcc}),

	.scanina(18'b0),
	.scaninb(18'b0),
	.scanouta(),
	.scanoutb(),

	// synthesis translate off
	// simulation only ports
	.devpor(1'b1),
	.devclrn(1'b1),
	.zeroacc(1'b0),
	.mode(1'b0),
	// synthesis translate on

	.dataout(mult1_out[35:0])
//	.observabledataa_regout(),
//	.observabledatab_regout());
);

defparam mult1_i .dataa_width = 18;
defparam mult1_i .datab_width = 18;
defparam mult1_i .dataa_clock = "0";
defparam mult1_i .datab_clock = "0";
defparam mult1_i .signa_clock = "none";
defparam mult1_i .signb_clock = "none";
defparam mult1_i .dataa_clear = "0";
defparam mult1_i .datab_clear = "0";
defparam mult1_i .signa_clear = "none";
defparam mult1_i .signb_clear = "none";
defparam mult1_i .output_clock = "0";
defparam mult1_i .output_clear = "0";
defparam mult1_i .round_clock = "none";
defparam mult1_i .round_clear = "none";
defparam mult1_i .saturate_clock = "none";
defparam mult1_i .saturate_clear = "none";
defparam mult1_i .mode_clock = "none";
defparam mult1_i .zeroacc_clock = "none";
defparam mult1_i .mode_clear = "none";
defparam mult1_i .zeroacc_clear = "none";
defparam mult1_i .dynamic_mode = "no";
defparam mult1_i .bypass_multiplier = "no";
defparam mult1_i .signa_internally_grounded = "true";
defparam mult1_i .signb_internally_grounded = "true";

wire [35:0] mult2_out;
stratixii_mac_mult mult2_i (
	.signa(gnd),
	.signb(gnd),
	.sourcea(gnd),
	.sourceb(gnd),
	.round(gnd),
	.saturate(gnd),
	.dataa(a[35:18]),
	.datab(b[35:18]),
	.clk({clk_unconnected_wire_3,clk_unconnected_wire_4,clk_unconnected_wire_5,clk}),
	.aclr({gnd,gnd,gnd,gnd}),
	.ena({vcc,vcc,vcc,vcc}),

	.scanina(18'b0),
	.scaninb(18'b0),
	.scanouta(),
	.scanoutb(),

	// synthesis translate off
	// simulation only ports
	.devpor(1'b1),
	.devclrn(1'b1),
	.zeroacc(1'b0),
	.mode(1'b0),
	// synthesis translate on

	.dataout(mult2_out[35:0])
//	.observabledataa_regout(),
//	.observabledatab_regout());
);
defparam mult2_i .dataa_width = 18;
defparam mult2_i .datab_width = 18;
defparam mult2_i .dataa_clock = "0";
defparam mult2_i .datab_clock = "0";
defparam mult2_i .signa_clock = "none";
defparam mult2_i .signb_clock = "none";
defparam mult2_i .dataa_clear = "0";
defparam mult2_i .datab_clear = "0";
defparam mult2_i .signa_clear = "none";
defparam mult2_i .signb_clear = "none";
defparam mult2_i .output_clock = "0";
defparam mult2_i .output_clear = "0";
defparam mult2_i .round_clock = "none";
defparam mult2_i .round_clear = "none";
defparam mult2_i .saturate_clock = "none";
defparam mult2_i .saturate_clear = "none";
defparam mult2_i .mode_clock = "none";
defparam mult2_i .zeroacc_clock = "none";
defparam mult2_i .mode_clear = "none";
defparam mult2_i .zeroacc_clear = "none";
defparam mult2_i .dynamic_mode = "no";
defparam mult2_i .bypass_multiplier = "no";
defparam mult2_i .signa_internally_grounded = "false";
defparam mult2_i .signb_internally_grounded = "false";

wire [35:0] mult3_out;
stratixii_mac_mult mult3_i (
	.signa(gnd),
	.signb(gnd),
	.sourcea(gnd),
	.sourceb(gnd),
	.round(gnd),
	.saturate(gnd),
	.dataa(a[35:18]),
	.datab(b[17:0]),
	.clk({clk_unconnected_wire_6,clk_unconnected_wire_7,clk_unconnected_wire_8,clk}),
	.aclr({gnd,gnd,gnd,gnd}),
	.ena({vcc,vcc,vcc,vcc}),

	.scanina(18'b0),
	.scaninb(18'b0),
	.scanouta(),
	.scanoutb(),

	// synthesis translate off
	// simulation only ports
	.devpor(1'b1),
	.devclrn(1'b1),
	.zeroacc(1'b0),
	.mode(1'b0),
	// synthesis translate on

	.dataout(mult3_out[35:0])
//	.observabledataa_regout(),
//	.observabledatab_regout());
);
defparam mult3_i .dataa_width = 18;
defparam mult3_i .datab_width = 18;
defparam mult3_i .dataa_clock = "0";
defparam mult3_i .datab_clock = "0";
defparam mult3_i .signa_clock = "none";
defparam mult3_i .signb_clock = "none";
defparam mult3_i .dataa_clear = "0";
defparam mult3_i .datab_clear = "0";
defparam mult3_i .signa_clear = "none";
defparam mult3_i .signb_clear = "none";
defparam mult3_i .output_clock = "0";
defparam mult3_i .output_clear = "0";
defparam mult3_i .round_clock = "none";
defparam mult3_i .round_clear = "none";
defparam mult3_i .saturate_clock = "none";
defparam mult3_i .saturate_clear = "none";
defparam mult3_i .mode_clock = "none";
defparam mult3_i .zeroacc_clock = "none";
defparam mult3_i .mode_clear = "none";
defparam mult3_i .zeroacc_clear = "none";
defparam mult3_i .dynamic_mode = "no";
defparam mult3_i .bypass_multiplier = "no";
defparam mult3_i .signa_internally_grounded = "false";
defparam mult3_i .signb_internally_grounded = "true";

wire [35:0] mult4_out;
stratixii_mac_mult mult4_i (
	.signa(gnd),
	.signb(gnd),
	.sourcea(gnd),
	.sourceb(gnd),
	.round(gnd),
	.saturate(gnd),
	.dataa(a[17:0]),
	.datab(b[35:18]),
	.clk({clk_unconnected_wire_9,clk_unconnected_wire_10,clk_unconnected_wire_11,clk}),
	.aclr({gnd,gnd,gnd,gnd}),
	.ena({vcc,vcc,vcc,vcc}),

	.scanina(18'b0),
	.scaninb(18'b0),
	.scanouta(),
	.scanoutb(),

	// synthesis translate off
	// simulation only ports
	.devpor(1'b1),
	.devclrn(1'b1),
	.zeroacc(1'b0),
	.mode(1'b0),
	// synthesis translate on

	.dataout(mult4_out[35:0])
//	.observabledataa_regout(),
//	.observabledatab_regout());
);
defparam mult4_i .dataa_width = 18;
defparam mult4_i .datab_width = 18;
defparam mult4_i .dataa_clock = "0";
defparam mult4_i .datab_clock = "0";
defparam mult4_i .signa_clock = "none";
defparam mult4_i .signb_clock = "none";
defparam mult4_i .dataa_clear = "0";
defparam mult4_i .datab_clear = "0";
defparam mult4_i .signa_clear = "none";
defparam mult4_i .signb_clear = "none";
defparam mult4_i .output_clock = "0";
defparam mult4_i .output_clear = "0";
defparam mult4_i .round_clock = "none";
defparam mult4_i .round_clear = "none";
defparam mult4_i .saturate_clock = "none";
defparam mult4_i .saturate_clear = "none";
defparam mult4_i .mode_clock = "none";
defparam mult4_i .zeroacc_clock = "none";
defparam mult4_i .mode_clear = "none";
defparam mult4_i .zeroacc_clear = "none";
defparam mult4_i .dynamic_mode = "no";
defparam mult4_i .bypass_multiplier = "no";
defparam mult4_i .signa_internally_grounded = "true";
defparam mult4_i .signb_internally_grounded = "false";

stratixii_mac_out out5 (
	.multabsaturate(gnd),
	.multcdsaturate(gnd),
	.signa(gnd),
	.signb(gnd),
	.dataa(mult1_out),
	.datab(mult2_out),
	.datac(mult3_out),
	.datad(mult4_out),
	.clk({clk_unconnected_wire_9,clk_unconnected_wire_10,clk_unconnected_wire_11,clk}),
	.aclr({gnd,gnd,gnd,gnd}),
	.ena({vcc,vcc,vcc,vcc}),

	 // synthesis translate off
	 // simulation only ports
	 .saturate(1'b0),
	 .saturate1(1'b0),
	 .devpor(1'b1),
	 .devclrn(1'b1),
	 .zeroacc(1'b0),
	 .zeroacc1(1'b0),
	 .mode0(1'b0),
	 .mode1(1'b0),
	 .accoverflow(),
	 // synthesis translate on

	 .round0(1'b0),
	 .round1(1'b0),
	 .addnsub0(1'b0),
	 .addnsub1(1'b0),

	.dataout(o_int));
defparam out5 .operation_mode = "36_bit_multiply";
defparam out5 .dataa_width = 36;
defparam out5 .datab_width = 36;
defparam out5 .datac_width = 36;
defparam out5 .datad_width = 36;
defparam out5 .addnsub0_clock = "none";
defparam out5 .addnsub1_clock = "none";
defparam out5 .addnsub0_pipeline_clock = "none";
defparam out5 .addnsub1_pipeline_clock = "none";
defparam out5 .addnsub0_clear = "none";
defparam out5 .addnsub1_clear = "none";
defparam out5 .addnsub0_pipeline_clear = "none";
defparam out5 .addnsub1_pipeline_clear = "none";
defparam out5 .round0_clock = "none";
defparam out5 .round1_clock = "none";
defparam out5 .round0_pipeline_clock = "none";
defparam out5 .round1_pipeline_clock = "none";
defparam out5 .round0_clear = "none";
defparam out5 .round1_clear = "none";
defparam out5 .round0_pipeline_clear = "none";
defparam out5 .round1_pipeline_clear = "none";
defparam out5 .saturate_clock = "none";
defparam out5 .multabsaturate_clock = "none";
defparam out5 .multcdsaturate_clock = "none";
defparam out5 .saturate_pipeline_clock = "none";
defparam out5 .multabsaturate_pipeline_clock = "none";
defparam out5 .multcdsaturate_pipeline_clock = "none";
defparam out5 .saturate_clear = "none";
defparam out5 .multabsaturate_clear = "none";
defparam out5 .multcdsaturate_clear = "none";
defparam out5 .saturate_pipeline_clear = "none";
defparam out5 .multabsaturate_pipeline_clear = "none";
defparam out5 .multcdsaturate_pipeline_clear = "none";
defparam out5 .mode0_clock = "none";
defparam out5 .mode1_clock = "none";
defparam out5 .zeroacc1_clock = "none";
defparam out5 .saturate1_clock = "none";
defparam out5 .mode0_pipeline_clock = "none";
defparam out5 .mode1_pipeline_clock = "none";
defparam out5 .zeroacc1_pipeline_clock = "none";
defparam out5 .saturate1_pipeline_clock = "none";
defparam out5 .mode0_clear = "none";
defparam out5 .mode1_clear = "none";
defparam out5 .zeroacc1_clear = "none";
defparam out5 .saturate1_clear = "none";
defparam out5 .mode0_pipeline_clear = "none";
defparam out5 .mode1_pipeline_clear = "none";
defparam out5 .zeroacc1_pipeline_clear = "none";
defparam out5 .saturate1_pipeline_clear = "none";
defparam out5 .output1_clock = "none";
defparam out5 .output2_clock = "none";
defparam out5 .output3_clock = "none";
defparam out5 .output4_clock = "none";
defparam out5 .output5_clock = "none";
defparam out5 .output6_clock = "none";
defparam out5 .output7_clock = "none";
defparam out5 .output1_clear = "none";
defparam out5 .output2_clear = "none";
defparam out5 .output3_clear = "none";
defparam out5 .output4_clear = "none";
defparam out5 .output5_clear = "none";
defparam out5 .output6_clear = "none";
defparam out5 .output7_clear = "none";
defparam out5 .dataa_forced_to_zero = "no";
defparam out5 .datac_forced_to_zero = "no";
defparam out5 .output_clock = "0";
defparam out5 .zeroacc_clock = "none";
defparam out5 .signa_clock = "none";
defparam out5 .signb_clock = "none";
defparam out5 .zeroacc_pipeline_clock = "none";
defparam out5 .signa_pipeline_clock = "none";
defparam out5 .signb_pipeline_clock = "none";
defparam out5 .zeroacc_clear = "none";
defparam out5 .signa_clear = "none";
defparam out5 .signb_clear = "none";
defparam out5 .output_clear = "0";
defparam out5 .zeroacc_pipeline_clear = "none";
defparam out5 .signa_pipeline_clear = "none";
defparam out5 .signb_pipeline_clear = "none";

endmodule
