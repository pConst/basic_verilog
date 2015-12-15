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

// baeckler - 04-13-2006
// RC4 stream 
//   algorithm taken from "Applied Cryptography" by Bruce Schneier

////////////////////////////////////////////////////
// dual port RAM helper, 256 words x 8 bits
////////////////////////////////////////////////////
module sbox_ram (
	address_a,
	address_b,
	clock,
	ena,
	data_a,
	data_b,
	wren_a,
	wren_b,
	q_a,
	q_b
);

	input	[7:0]  address_a;
	input	[7:0]  address_b;
	input	  clock,ena;
	input	[7:0]  data_a;
	input	[7:0]  data_b;
	input	  wren_a;
	input	  wren_b;
	output	[7:0]  q_a;
	output	[7:0]  q_b;

	wire [7:0] sub_wire0;
	wire [7:0] sub_wire1;
	wire [7:0] q_a;
	wire [7:0] q_b;

	altsyncram	altsyncram_component (
				.wren_a (wren_a),
				.clock0 (clock),
				.wren_b (wren_b),
				.address_a (address_a),
				.address_b (address_b),
				.data_a (data_a),
				.data_b (data_b),
				.q_a (q_a),
				.q_b (q_b),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken0 (ena),
				.clocken1 (1'b1),
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
		altsyncram_component.numwords_a = 256,
		altsyncram_component.numwords_b = 256,
		altsyncram_component.operation_mode = "BIDIR_DUAL_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_aclr_b = "NONE",
		altsyncram_component.outdata_reg_a = "CLOCK0",
		altsyncram_component.outdata_reg_b = "CLOCK0",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
		altsyncram_component.widthad_a = 8,
		altsyncram_component.widthad_b = 8,
		altsyncram_component.width_a = 8,
		altsyncram_component.width_b = 8,
		altsyncram_component.width_byteena_a = 1,
		altsyncram_component.width_byteena_b = 1,
		altsyncram_component.wrcontrol_wraddress_reg_b = "CLOCK0";

endmodule

////////////////////////////////////////////////////
// stream generator - 1 byte per 4 cycles
////////////////////////////////////////////////////
module rc4 (clk,ena,rst,load_key,key,dat_valid,dat);

parameter KEY_BYTES = 5;

input clk,ena,rst,load_key;
input [KEY_BYTES*8-1:0] key;

output [7:0] dat;
output dat_valid;

reg [7:0] dat;
reg dat_valid;

reg [7:0] i,j;

// state
parameter INIT_SCLR=1, INIT_SPIN=2, 
		STEP_READY=3,STEP_ONE=4,STEP_TWO=5,STEP_THREE=6,STEP_FOUR=7;
reg [2:0] state;
reg [2:0] next_state;

//////////////////////////

reg [7:0] address_a, address_b;
reg [7:0] data_a, data_b;
reg wren_a,wren_b;
wire [7:0] q_a, q_b;

sbox_ram bx (.address_a(address_a),.address_b(address_b),
	.clock(clk),.ena(ena),.data_a(data_a),.data_b(data_b),
	.wren_a(wren_a),.wren_b(wren_b),.q_a(q_a),.q_b(q_b)
);

//////////////////////////

reg inc_i, sclr_i;
always @(posedge clk or posedge rst) begin
	if (rst) i <= 8'b0;
	else begin
		if (ena) i <= ~{8{sclr_i}} & (i+inc_i);
	end
end

//////////////////////////

reg [7:0] add_j;
reg sclr_j;
always @(posedge clk or posedge rst) begin
	if (rst) j <= 8'b0;
	else begin
		if (ena) j <= ~{8{sclr_j}} & (j+add_j);
	end
end

//////////////////////////

reg key_load,key_shft;
reg [KEY_BYTES*8-1:0] key_reg;
always @(posedge clk or posedge rst) begin
	if (rst)
		key_reg <= 0;
	else begin
		if (ena) begin
			if (key_load) key_reg <= key;
	
			// rotate left one byte
			else if (key_shft) key_reg <= 
				{key_reg[(KEY_BYTES-1)*8-1:0],key_reg[KEY_BYTES*8-1:(KEY_BYTES-1)*8]};
		end
	end
end

//////////////////////////

reg out_idx_load, out_idx_accum;
reg [7:0] out_idx;
always @(posedge clk or posedge rst) begin
	if (rst)
		out_idx <= 0;
	else begin
		if (ena) begin
			if (out_idx_load) out_idx <= q_a; 
			else if (out_idx_accum) out_idx <= out_idx + q_b;
		end
	end
end

//////////////////////////

reg keying;
reg start_keying,done_keying;
always @(posedge clk or posedge rst) begin
	if (rst) keying <= 1'b0;
	else begin
		if (ena) keying <= (keying & !done_keying) | start_keying;	
	end		
end

//////////////////////////

reg first_load;
reg load_dout;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		first_load <= 1'b0;
	end
	else begin
		// after keying swallow the 1st output
		// byte generated, it's an artifact.
		if (ena) begin
			if (keying) first_load <= 1'b1;
			else if (load_dout) first_load <= 1'b0;
		end
	end
end

//////////////////////////

always @(posedge clk or posedge rst) begin
	if (rst) begin
		dat_valid <= 1'b0;
		dat <= 0;
	end
	else begin
		// manage the output byte and valid registers
		if (ena) begin
			if (load_dout && !first_load) begin
				dat <= q_b;
				dat_valid <= 1'b1;
			end
			else dat_valid <= 1'b0;
		end
	end
end


//////////////////////////

// state registers
always @(posedge clk or posedge rst) begin
	if (rst) state <= INIT_SCLR;
	else if (ena) state <= next_state;
end


// next state and output decisions
always @(*) begin

	// control signal defaults
	sclr_i = 0;
	inc_i = 0;
	sclr_j = 0;
	add_j = 0;

	out_idx_load = 0;
	out_idx_accum = 0;
	load_dout = 0;

	start_keying = 0;
	done_keying = 0;
	key_load = 0;
	key_shft = 0;

	wren_a = 0;
	wren_b = 0;

	// these are really don't care when not specified.
	address_a = 8'bx;
	address_b = 8'bx;
	data_a = 8'bx;
	data_b = q_b;
	
	// from any state offer sync reset to the init state
	if (load_key)  begin
		$display ("Reinit requested");
		next_state = INIT_SCLR;
	end
	// otherwise do the state machine...
	else begin
		case (state)

			// The INIT states cover RAM init to 0..255
			// the B port is idle. Could double up here.
			INIT_SCLR : begin 
					next_state = INIT_SPIN;
					start_keying = 1'b1; 
					sclr_i = 1'b1;
					sclr_j = 1'b1;
				end
			INIT_SPIN : begin
					// write 0..255 to memory 0..255
					// on port A					
					if (i == 255) next_state = STEP_READY;
					else next_state = INIT_SPIN;
					wren_a = 1'b1;
					address_a = i;
					data_a = i;
					inc_i = 1'b1;
				end

			// The STEP states cover keying and generation
			STEP_READY : begin
					$display ("Ready state.  keying = %b",keying);
					next_state = STEP_ONE;
					key_load = keying;
					sclr_j = 1'b1;
					
					// i is going to be 0 on entry.
					// during generation we want 1, not 0.
					inc_i = !keying;

					// ask for S[i] on A, correct it if it should be 1
					address_a = i | !keying;
				end
			STEP_ONE : begin
					// ask for S[i] on A
					// ask for the output byte (s[S[i]+S[j]]) on B
					next_state = STEP_TWO;
					address_a = i;
					address_b = out_idx;
					add_j <= keying ? key_reg[KEY_BYTES*8-1:(KEY_BYTES-1)*8] : 0;
					key_shft = keying;
				end
			STEP_TWO : begin
					// S[i] ready on A
					// ask for j + S[i] aka S[j] on B
					next_state = STEP_THREE;
					address_b = j + q_a;
					add_j = q_a;
				end
			STEP_THREE : begin
					// S[i] still ready on A
					// output byte ready on B
					// write S[i] to loc j on B
					next_state = STEP_FOUR;
					wren_a = 1'b1;
					address_a = j;
					data_a = q_a;
					
					out_idx_load = 1'b1;
					load_dout = !keying;
				end
			STEP_FOUR : begin
					// S[j] ready on B
					// write S[j] to loc i on B
					wren_b = 1'b1;
					data_b = q_b;
					address_b = i;

					if (keying && i == 255) begin
						next_state = STEP_READY; 
						done_keying = 1'b1;
					end
					else next_state = STEP_ONE;
					
					// ask for the next S[i] on A
					address_a = i + 1;
					inc_i = 1'b1;
					out_idx_accum = 1'b1;
				end
		endcase
	end
end
endmodule

