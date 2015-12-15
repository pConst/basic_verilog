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

// baeckler - 04-24-2007

module simple_quad (
	clk,
	wraddr_a,wraddr_b,
	wrdat_a, wrdat_b,
	we_a, we_b, 
	rdaddr_a,rdaddr_b,
	rddat_a,rddat_b
);

parameter ADDR_WIDTH = 5;
parameter NUM_WORDS = 1 << ADDR_WIDTH;
parameter DATA_WIDTH = 32;

input clk;
input [ADDR_WIDTH-1:0] wraddr_a,wraddr_b,rdaddr_a,rdaddr_b;
input [DATA_WIDTH-1:0] wrdat_a,wrdat_b;
input we_a,we_b;
output [DATA_WIDTH-1:0] rddat_a,rddat_b;

flag_array fa (
	.clk(clk),
	.waddr_a(wraddr_a),
	.waddr_b(wraddr_b), 
	.we_a(we_a),
	.we_b(we_b), 
	.raddr_a(rdaddr_a),
	.raddr_b(rdaddr_b),
	.sel_a(sel_a),
	.sel_b(sel_b)
);
defparam fa .ADDR_WIDTH = ADDR_WIDTH;

//
// Bank Q - Write A read A 
wire [DATA_WIDTH-1:0] rddata_q;
altsyncram  bank_q (
            .wren_a (we_a),
            .clock0 (clk),
            .address_a (wraddr_a),
            .address_b (rdaddr_a),
            .data_a (wrdat_a),
            .q_b (rddata_q),
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
            .data_b ({DATA_WIDTH{1'b1}}),
            .eccstatus (),
            .q_a (),
            .rden_a (1'b1),
            .rden_b (1'b1),
            .wren_b (1'b0));
defparam
    bank_q.address_reg_b = "CLOCK0",
    bank_q.clock_enable_input_a = "BYPASS",
    bank_q.clock_enable_input_b = "BYPASS",
    bank_q.clock_enable_output_a = "BYPASS",
    bank_q.clock_enable_output_b = "BYPASS",
    bank_q.intended_device_family = "Stratix II",
    bank_q.lpm_type = "altsyncram",
    bank_q.numwords_a = NUM_WORDS,
    bank_q.numwords_b = NUM_WORDS,
    bank_q.operation_mode = "DUAL_PORT",
    bank_q.outdata_aclr_b = "NONE",
    bank_q.outdata_reg_b = "CLOCK0",
    bank_q.power_up_uninitialized = "FALSE",
    bank_q.read_during_write_mode_mixed_ports = "DONT_CARE",
    bank_q.widthad_a = ADDR_WIDTH,
    bank_q.widthad_b = ADDR_WIDTH,
    bank_q.width_a = DATA_WIDTH,
    bank_q.width_b = DATA_WIDTH,
    bank_q.width_byteena_a = 1;

//
// Bank R - Write A read B 
wire [DATA_WIDTH-1:0] rddata_r;
altsyncram  bank_r (
            .wren_a (we_a),
            .clock0 (clk),
            .address_a (wraddr_a),
            .address_b (rdaddr_b),
            .data_a (wrdat_a),
            .q_b (rddata_r),
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
            .data_b ({DATA_WIDTH{1'b1}}),
            .eccstatus (),
            .q_a (),
            .rden_a (1'b1),
            .rden_b (1'b1),
            .wren_b (1'b0));
defparam
    bank_r.address_reg_b = "CLOCK0",
    bank_r.clock_enable_input_a = "BYPASS",
    bank_r.clock_enable_input_b = "BYPASS",
    bank_r.clock_enable_output_a = "BYPASS",
    bank_r.clock_enable_output_b = "BYPASS",
    bank_r.intended_device_family = "Stratix II",
    bank_r.lpm_type = "altsyncram",
    bank_r.numwords_a = NUM_WORDS,
    bank_r.numwords_b = NUM_WORDS,
    bank_r.operation_mode = "DUAL_PORT",
    bank_r.outdata_aclr_b = "NONE",
    bank_r.outdata_reg_b = "CLOCK0",
    bank_r.power_up_uninitialized = "FALSE",
    bank_r.read_during_write_mode_mixed_ports = "DONT_CARE",
    bank_r.widthad_a = ADDR_WIDTH,
    bank_r.widthad_b = ADDR_WIDTH,
    bank_r.width_a = DATA_WIDTH,
    bank_r.width_b = DATA_WIDTH,
    bank_r.width_byteena_a = 1;

//
// Bank S - Write B read A 
wire [DATA_WIDTH-1:0] rddata_s;
altsyncram  bank_s (
            .wren_a (we_b),
            .clock0 (clk),
            .address_a (wraddr_b),
            .address_b (rdaddr_a),
            .data_a (wrdat_b),
            .q_b (rddata_s),
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
            .data_b ({DATA_WIDTH{1'b1}}),
            .eccstatus (),
            .q_a (),
            .rden_a (1'b1),
            .rden_b (1'b1),
            .wren_b (1'b0));
defparam
    bank_s.address_reg_b = "CLOCK0",
    bank_s.clock_enable_input_a = "BYPASS",
    bank_s.clock_enable_input_b = "BYPASS",
    bank_s.clock_enable_output_a = "BYPASS",
    bank_s.clock_enable_output_b = "BYPASS",
    bank_s.intended_device_family = "Stratix II",
    bank_s.lpm_type = "altsyncram",
    bank_s.numwords_a = NUM_WORDS,
    bank_s.numwords_b = NUM_WORDS,
    bank_s.operation_mode = "DUAL_PORT",
    bank_s.outdata_aclr_b = "NONE",
    bank_s.outdata_reg_b = "CLOCK0",
    bank_s.power_up_uninitialized = "FALSE",
    bank_s.read_during_write_mode_mixed_ports = "DONT_CARE",
    bank_s.widthad_a = ADDR_WIDTH,
    bank_s.widthad_b = ADDR_WIDTH,
    bank_s.width_a = DATA_WIDTH,
    bank_s.width_b = DATA_WIDTH,
    bank_s.width_byteena_a = 1;

//
// Bank T - Write B read B 
wire [DATA_WIDTH-1:0] rddata_t;
altsyncram  bank_t (
            .wren_a (we_b),
            .clock0 (clk),
            .address_a (wraddr_b),
            .address_b (rdaddr_b),
            .data_a (wrdat_b),
            .q_b (rddata_t),
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
            .data_b ({DATA_WIDTH{1'b1}}),
            .eccstatus (),
            .q_a (),
            .rden_a (1'b1),
            .rden_b (1'b1),
            .wren_b (1'b0));
defparam
    bank_t.address_reg_b = "CLOCK0",
    bank_t.clock_enable_input_a = "BYPASS",
    bank_t.clock_enable_input_b = "BYPASS",
    bank_t.clock_enable_output_a = "BYPASS",
    bank_t.clock_enable_output_b = "BYPASS",
    bank_t.intended_device_family = "Stratix II",
    bank_t.lpm_type = "altsyncram",
    bank_t.numwords_a = NUM_WORDS,
    bank_t.numwords_b = NUM_WORDS,
    bank_t.operation_mode = "DUAL_PORT",
    bank_t.outdata_aclr_b = "NONE",
    bank_t.outdata_reg_b = "CLOCK0",
    bank_t.power_up_uninitialized = "FALSE",
    bank_t.read_during_write_mode_mixed_ports = "DONT_CARE",
    bank_t.widthad_a = ADDR_WIDTH,
    bank_t.widthad_b = ADDR_WIDTH,
    bank_t.width_a = DATA_WIDTH,
    bank_t.width_b = DATA_WIDTH,
    bank_t.width_byteena_a = 1;


assign rddat_a = sel_a ? rddata_s : rddata_q;
assign rddat_b = sel_b ? rddata_t : rddata_r; 

endmodule