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
module stream_grabber #(
	parameter DAT_WIDTH = 72, // multiple of 8
	parameter ADDR_BITS = 8,  // depth of the sample memory
	
	// initial tag to shift out, length must be DAT_WIDTH
	// holding is the number of bytes actually used
	// shift initial content toward more significant end
	parameter INITIAL_SR_CONTENT = {"Stream 0",8'h0},
	parameter INITIAL_HOLDING = 8	
)
(
	input clk,arst,
	input [DAT_WIDTH-1:0] data_in,
	input data_in_valid,
	
	input start_harvest,
	output reg reporting,
	
	output [7:0] byte_out,
	output byte_out_valid,
	input byte_out_ready
);

`include "log2.inc"

localparam NUM_BYTES = DAT_WIDTH >> 3;
localparam LOG_NUM_BYTES = log2(NUM_BYTES);

///////////////////////////////////////////////
// sample RAM
///////////////////////////////////////////////

wire [DAT_WIDTH-1:0] ram_d, ram_q;
wire ram_we;
reg [ADDR_BITS+1-1:0] ram_a;

altsyncram	altsyncram_component (
			.wren_a (ram_we),
			.clock0 (clk),
			.address_a (ram_a[ADDR_BITS-1:0]),
			.data_a (ram_d),
			.q_a (ram_q),
			.aclr0 (1'b0),
			.aclr1 (1'b0),
			.address_b (1'b1),
			.addressstall_a (1'b0),
			.addressstall_b (1'b0),
			.byteena_a (1'b1),
			.byteena_b (1'b1),
			.clock1 (1'b1),
			.clocken0 (1'b1),
			.clocken1 (1'b1),
			.clocken2 (1'b1),
			.clocken3 (1'b1),
			.data_b (1'b1),
			.eccstatus (),
			.q_b (),
			.rden_a (1'b1),
			.rden_b (1'b1),
			.wren_b (1'b0));
defparam
	altsyncram_component.clock_enable_input_a = "BYPASS",
	altsyncram_component.clock_enable_output_a = "BYPASS",
	altsyncram_component.intended_device_family = "Stratix II",
	altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
	altsyncram_component.lpm_type = "altsyncram",
	altsyncram_component.numwords_a = (1<<ADDR_BITS),
	altsyncram_component.operation_mode = "SINGLE_PORT",
	altsyncram_component.outdata_aclr_a = "NONE",
	altsyncram_component.outdata_reg_a = "CLOCK0",
	altsyncram_component.power_up_uninitialized = "FALSE",
	altsyncram_component.ram_block_type = "AUTO",
	altsyncram_component.widthad_a = ADDR_BITS,
	altsyncram_component.width_a = DAT_WIDTH,
	altsyncram_component.width_byteena_a = 1;

///////////////////////////////////////////////
// Alternately fill and drain sample RAM
///////////////////////////////////////////////

// Input registers
reg [DAT_WIDTH-1:0] data_in_r;
reg data_in_valid_r;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		data_in_r <= 0;
		data_in_valid_r <= 0;
	end
	else begin
		data_in_r <= data_in;
		data_in_valid_r <= data_in_valid;
	end
end

wire [DAT_WIDTH-1:0] word;
wire word_ready;
reg word_valid,word_valid_p;

reg report,harvest,idle;
wire read_inc = word_ready & word_valid & report;
wire write_inc = data_in_valid_r & harvest;

// RAM address
always @(posedge clk or posedge arst) begin
	if (arst) begin
		ram_a <= 0;
	end
	else begin
		if (read_inc | write_inc) ram_a <= ram_a + 1'b1;
	end
end

assign ram_d = data_in_r;
assign ram_we = harvest & data_in_valid_r;
assign word = ram_q;

// little control state machine
// harvest -> report -> idle
always @(posedge clk or posedge arst) begin
	if (arst) begin
		harvest <= 0;
		report <= 0;
		idle <= 1'b1;
	end
	else begin
		if (idle & start_harvest) begin
			idle <= 1'b0;
			harvest <= 1'b1;
		end
		if (harvest & ram_a[ADDR_BITS]) begin
			harvest <= 1'b0;
			report <= 1'b1;
		end
		if (report & !ram_a[ADDR_BITS]) begin
			report <= 1'b0;
			idle <= 1'b1;
		end
	end
end	

always @(posedge clk or posedge arst) begin
	if (arst) begin
		word_valid <= 0;
		word_valid_p <= 0;
	end
	else begin
		if (word_valid & word_ready) begin
			word_valid <= 0;
			word_valid_p <= 0;
		end
		else begin
			word_valid_p <= report;
			word_valid <= word_valid_p & report;
		end
	end
end

///////////////////////////////////////////////
// Convert captured samples to byte stream
///////////////////////////////////////////////

reg [LOG_NUM_BYTES-1:0] holding;
reg [DAT_WIDTH-1:0] out_sr;
assign word_ready = (holding == 0) || ((holding == 1) & byte_out_ready);
assign byte_out_valid = |holding;
assign byte_out = out_sr[DAT_WIDTH-1:DAT_WIDTH-8];

always @(posedge clk or posedge arst) begin
	if (arst) begin
		holding <= 0;
		out_sr <= 0;
	end
	else begin
		// serialize words out as bytes
		if (word_valid & word_ready) begin
			holding <= NUM_BYTES;
			out_sr <= word;
		end
		else if (byte_out_valid & byte_out_ready) begin
			holding <= holding - 1'b1;
			out_sr <= {out_sr[DAT_WIDTH-9:0],8'h0};
		end		
		
		// initialize with a tag to identify this stream
		if (start_harvest) begin
			out_sr <= INITIAL_SR_CONTENT;
			holding <= INITIAL_HOLDING;
		end
	end
end

// stretch the reporting status until the data is
// really gone.

always @(posedge clk or posedge arst) begin
	if (arst) reporting <= 0;
	else begin
		if (report) reporting <= 1'b1;
		if (!report & !byte_out_valid) reporting <= 1'b0;
	end
end

endmodule