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
// 16-22 ECC internal RAM
//
module soft_ecc_ram_16bit (
	rst,
	address_a,
	address_b,
	clock_a,
	clock_b,
	data_a,
	data_b,
	wren_a,
	wren_b,
	q_a,
	q_b,
	err_a,
	err_b
);

`include "log2.inc"

// Number of 16 bit data words (stored as 22 bit words internally)
parameter NUM_WORDS = 512;
localparam ADDR_WIDTH = log2(NUM_WORDS-1);

// For testing error detection / correction
// a 1 bit indicates inversion of the corresponding code bit
// on the encoded RAM output.
parameter PORT_A_ERROR_INJECT = 22'b0;
parameter PORT_B_ERROR_INJECT = 22'b0;

	input   rst;
	input	[ADDR_WIDTH-1:0]  address_a;
	input	[ADDR_WIDTH-1:0]  address_b;
	input   clock_a;
	input   clock_b;
	input	[15:0]  data_a;
	input	[15:0]  data_b;
	input   wren_a;
	input   wren_b;
	output	[15:0]  q_a;
	output	[15:0]  q_b;
	output  [2:0] err_a;
	output  [2:0] err_b;


///////////////////////
// port A encoder
///////////////////////
reg [15:0] data_a_reg;
always @(posedge clock_a or posedge rst) begin
	if (rst) data_a_reg <= 16'b0;
	else data_a_reg <= data_a;
end
wire [21:0] data_a_code;
ecc_encode_16bit enc_a (.d(data_a_reg),.c(data_a_code));

///////////////////////
// port B encoder
///////////////////////
reg [15:0] data_b_reg;
always @(posedge clock_b or posedge rst) begin
	if (rst) data_b_reg <= 16'b0;
	else data_b_reg <= data_b;
end
wire [21:0] data_b_code;
ecc_encode_16bit enc_b (.d(data_b_reg),.c(data_b_code));

///////////////////////
// RAM block (22 bit words)
///////////////////////
wire [21:0] q_a_code;
wire [21:0] q_b_code;
ram_block ram (
	.aclr_a(rst),
	.aclr_b(rst),
	.address_a(address_a),
	.address_b(address_b),
	.clock_a(clock_a),
	.clock_b(clock_b),
	.data_a(data_a_code),
	.data_b(data_b_code),
	.wren_a(wren_a),
	.wren_b(wren_b),
	.q_a(q_a_code),
	.q_b(q_b_code)
);
defparam ram .NUM_WORDS = NUM_WORDS;
defparam ram .DAT_WIDTH = 22;

///////////////////////
// port A decoder
///////////////////////
ecc_decode_16bit dec_a (
	.clk(clock_a),
	.rst(rst),
	.c(q_a_code ^ PORT_A_ERROR_INJECT),
	.d(q_a),
	.no_err(err_a[0]),
	.err_corrected(err_a[1]),
	.err_fatal(err_a[2]));

defparam dec_a .OUTPUT_REG = 1;
defparam dec_a .MIDDLE_REG = 1;

///////////////////////
// port B decoder
///////////////////////
ecc_decode_16bit dec_b (
	.clk(clock_b),
	.rst(rst),
	.c(q_b_code ^ PORT_B_ERROR_INJECT),
	.d(q_b),
	.no_err(err_b[0]),
	.err_corrected(err_b[1]),
	.err_fatal(err_b[2]));

defparam dec_b .OUTPUT_REG = 1;
defparam dec_b .MIDDLE_REG = 1;

endmodule
