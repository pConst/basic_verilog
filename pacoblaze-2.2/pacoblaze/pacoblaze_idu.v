/*
	Copyright (C) 2004, 2006 Pablo Bleyer Kocik.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

	1. Redistributions of source code must retain the above copyright notice, this
	list of conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above copyright notice,
	this list of conditions and the following disclaimer in the documentation
	and/or other materials provided with the distribution.

	3. The name of the author may not be used to endorse or promote products
	derived from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
	WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
	EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
	BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
	IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/

/** @file
	PacoBlaze Instruction Decode Unit.
*/

`ifndef PACOBLAZE_IDU_V_
`define PACOBLAZE_IDU_V_

`include "pacoblaze_inc.v"

`ifdef USE_ONEHOT_ENCODING
`define operation_set(x) operation = (1<<x)
// `define operation_set(x) operation[x] = 1'b1
`define operation(x) operation[(x)]
`else
`define operation_set(x) operation = (x)
`define operation(x) (x)
`endif

module `PACOBLAZE_IDU(
	instruction,
	operation,
	shift_operation, shift_direction, shift_constant,
	operand_selection,
	x_address, y_address,
	implied_value, port_address,
`ifdef HAS_SCRATCH_MEMORY
	scratch_address,
`endif
	code_address,
	conditional, condition_flags,
	interrupt_enable
`ifdef HAS_DEBUG
	, debug
`endif
);
input [`code_width-1:0] instruction; ///< Instruction
output reg [`operation_width-1:0] operation; ///< Main operation
output [2:0] shift_operation; ///< Rotate/shift operation
output shift_direction; ///< Rotate/shift left(0)/right(1)
output shift_constant; ///< Shift constant value
output operand_selection; ///< Operand selection (k/p/s:0, y:1)
output [`register_depth-1:0] x_address, y_address; ///< Operation x source/target, y source
output [`operand_width-1:0] implied_value; ///< Operand constant source
output [`port_depth-1:0] port_address; ///< Port address
`ifdef HAS_SCRATCH_MEMORY
output [`scratch_depth-1:0] scratch_address; ///< Scratchpad address
`endif
output [`code_depth-1:0] code_address; ///< Program address
output conditional; ///< Conditional operation (unconditional(0)/conditional(1))
output [1:0] condition_flags; ///< Condition flags on zero and carry
output interrupt_enable; ///< Interrupt disable(0)/enable(1)

`ifdef HAS_DEBUG
output reg [8*`idu_debug_width:1] debug; ///< Operation debug string
reg [2*8:1] debug_conditional; ///< Conditional debug string
reg [5*8:1] debug_operand; ///< Operand debug string
reg [7*8:1] debug_interrupt; ///< Interrupt debug string
`endif

`ifdef PACOBLAZE1
wire [3:0] instruction_0 =
	(instruction[15:12] == `opcode_reg) ? instruction[3:0] : instruction[15:12];
wire [3:0] instruction_1 = instruction[9:6];

assign x_address = instruction[11:8];
assign y_address = instruction[7:4];
assign operand_selection =
	(instruction[15] && instruction[13]) ? instruction[12] :
	instruction[15];
assign code_address = instruction[7:0];
assign interrupt_enable = instruction[5];
`endif

`ifdef PACOBLAZE2
wire [3:0] instruction_0 = {instruction[17], instruction[15:13]};
wire instruction_1 = instruction[16];

assign x_address = instruction[12:8];
assign y_address = instruction[7:3];
assign operand_selection = instruction[16];
assign code_address = instruction[9:0];
assign interrupt_enable = instruction[0];
`endif

`ifdef PACOBLAZE3
wire [4:0] instruction_0 = instruction[17:13];

assign x_address = instruction[11:8];
assign y_address = instruction[7:4];
assign operand_selection = instruction[12];
assign code_address = instruction[9:0];
assign interrupt_enable = instruction[0];
assign scratch_address = instruction[5:0];
`endif

`ifdef PACOBLAZE3M
wire [4:0] instruction_0 = instruction[17:13];

assign x_address = instruction[11:8];
assign y_address = instruction[7:4];
assign operand_selection = instruction[12];
assign code_address = instruction[9:0];
assign interrupt_enable = instruction[0];
assign scratch_address = instruction[5:0];
`endif

assign shift_direction = instruction[3];
assign shift_operation = instruction[2:1];
assign shift_constant = instruction[0];

assign conditional = instruction[12];
assign condition_flags = instruction[11:10];

assign implied_value = instruction[7:0];
assign port_address = instruction[7:0];


`ifdef PACOBLAZE1
always @(instruction_0, instruction_1)
`endif
`ifdef PACOBLAZE2
always @(instruction_0, instruction_1)
`endif
`ifdef PACOBLAZE3
always @(instruction_0)
`endif
`ifdef PACOBLAZE3M
always @(instruction_0)
`endif
begin
	`ifdef HAS_DEBUG
	operation = 'hx; // default
	`else
	operation = 'h0; // default
	`endif

	// synthesis parallel_case full_case
`ifdef PACOBLAZE1
	casex (instruction_0)
`else
	case (instruction_0)
`endif

		`opcode_load: `operation_set(`op_load);
		`opcode_add: `operation_set(`op_add);
		`opcode_addcy: `operation_set(`op_addcy);
		`opcode_and: `operation_set(`op_and);
		`opcode_or: `operation_set(`op_or);
		`opcode_rs: `operation_set(`op_rs);
		`opcode_sub: `operation_set(`op_sub);
		`opcode_subcy: `operation_set(`op_subcy);
		`opcode_xor: `operation_set(`op_xor);

`ifdef PACOBLAZE1
		{`opcode_ctl, 1'b?}:
			casex (instruction_1)
				{`opcode_jump, 2'b??}: `operation_set(`op_jump);
				{`opcode_call, 2'b??}: `operation_set(`op_call);
				`opcode_return: `operation_set(`op_return);
				`opcode_returni: `operation_set(`op_returni);
				`opcode_interrupt: `operation_set(`op_interrupt);
			endcase
		{`opcode_input, 1'b?}: `operation_set(`op_input);
		{`opcode_output, 1'b?}: `operation_set(`op_output);
`endif // PACOBLAZE1

`ifdef PACOBLAZE2
		`opcode_jump: // == `opcode_return
			if (instruction_1) `operation_set(`op_jump);
			else `operation_set(`op_return);
		`opcode_call: if (instruction_1) `operation_set(`op_call);
		`opcode_interrupt: // == `opcode_returni
			if (instruction_1) `operation_set(`op_interrupt);
			else `operation_set(`op_returni);
		`opcode_input: `operation_set(`op_input);
		`opcode_output: `operation_set(`op_output);
`endif // PACOBLAZE2

`ifdef PACOBLAZE3
		`opcode_jump: `operation_set(`op_jump);
		`opcode_call: `operation_set(`op_call);
		`opcode_return: `operation_set(`op_return);
		`opcode_returni: `operation_set(`op_returni);
		`opcode_interrupt: `operation_set(`op_interrupt);
		`opcode_input: `operation_set(`op_input);
		`opcode_output: `operation_set(`op_output);
`endif // PACOBLAZE3

`ifdef PACOBLAZE3M
		`opcode_jump: `operation_set(`op_jump);
		`opcode_call: `operation_set(`op_call);
		`opcode_return: `operation_set(`op_return);
		`opcode_returni: `operation_set(`op_returni);
		`opcode_interrupt: `operation_set(`op_interrupt);
		`opcode_input: `operation_set(`op_input);
		`opcode_output: `operation_set(`op_output);
`endif // PACOBLAZE3M

		// PB3
`ifdef HAS_COMPARE_OPERATION
		`opcode_compare: `operation_set(`op_compare);
`endif
`ifdef HAS_TEST_OPERATION
		`opcode_test: `operation_set(`op_test);
`endif
`ifdef HAS_SCRATCH_MEMORY
		`opcode_fetch: `operation_set(`op_fetch);
		`opcode_store: `operation_set(`op_store);
`endif

		// PB3M
`ifdef HAS_MUL_OPERATION
		`opcode_mul: `operation_set(`op_mul);
`endif

`ifdef HAS_WIDE_ALU
		`opcode_addw: `operation_set(`op_addw);
		`opcode_addwcy: `operation_set(`op_addwcy);
		`opcode_subw: `operation_set(`op_subw);
		`opcode_subwcy: `operation_set(`op_subwcy);
`endif

		// default: `operation_set(0);
	endcase

end


`ifdef HAS_DEBUG

`include "pacoblaze_util.v"

always @(operand_selection, x_address, y_address, implied_value)
	if (operand_selection) debug_operand = {"s", numtohex(x_address), ",", "s", numtohex(y_address)};
	else debug_operand = {"s", numtohex(x_address), ",", numtohex(implied_value[7:4]), numtohex(implied_value[3:0])};

always @(conditional, condition_flags) begin
	case ({conditional, condition_flags})
		// 3b'0??: debug_conditional = "  ";
		{1'b1, `flag_z}: debug_conditional = `os_z;
		{1'b1, `flag_nz}: debug_conditional = `os_nz;
		{1'b1, `flag_c}: debug_conditional = `os_c;
		{1'b1, `flag_nc}: debug_conditional = `os_nc;
		default: debug_conditional = "  ";
	endcase
end

always @(interrupt_enable)
	if (interrupt_enable) debug_interrupt = `os_enable;
	else debug_interrupt = `os_disable;

always @(operation, shift_direction, shift_operation, shift_constant,
	debug_operand, debug_conditional, debug_interrupt,
	code_address
)
`ifdef USE_ONEHOT_ENCODING
	case (1'b1)
`else
	case (operation)
`endif
		`operation(`op_load): debug = {`os_load, " ", debug_operand};
		`operation(`op_add): debug = {`os_add, " ", debug_operand};
		`operation(`op_addcy): debug = {`os_addcy, " ", debug_operand};
		`operation(`op_and): debug = {`os_and, " ", debug_operand};
		`operation(`op_or): debug = {`os_or, " ", debug_operand};
		`operation(`op_rs):  // debug = `os_rs;
			case ({shift_direction, shift_operation, shift_constant})
				4'b1_11_0: debug = {`os_sr0, " s", numtohex(x_address)};
				4'b1_11_1: debug = {`os_sr1, " s", numtohex(x_address)};
				4'b1_01_0: debug = {`os_srx, " s", numtohex(x_address)};
				4'b1_00_0: debug = {`os_sra, " s", numtohex(x_address)};
				4'b1_10_0: debug = {`os_rr, " s", numtohex(x_address)};
				4'b0_11_0: debug = {`os_sl0, " s", numtohex(x_address)};
				4'b0_11_1: debug = {`os_sl1, " s", numtohex(x_address)};
				4'b0_10_0: debug = {`os_slx, " s", numtohex(x_address)};
				4'b0_00_0: debug = {`os_sla, " s", numtohex(x_address)};
				4'b0_01_0: debug = {`os_rl, " s", numtohex(x_address)};
				default: debug = `os_invalid;
			endcase
		`operation(`op_sub): debug = {`os_sub, " ", debug_operand};
		`operation(`op_subcy): debug = {`os_subcy, " ", debug_operand};
		`operation(`op_xor): debug = {`os_xor, " ", debug_operand};

`ifdef HAS_MUL_OPERATION
		`operation(`op_mul): debug = {`os_mul, " ", debug_operand};
`endif

		`operation(`op_jump): debug = {`os_jump, " ", debug_conditional, " ", adrtohex(code_address)};
		`operation(`op_call): debug = {`os_call, " ", debug_conditional, " ", adrtohex(code_address)};
		`operation(`op_return): debug = {`os_return, " ", debug_conditional};
		`operation(`op_returni): debug = {`os_returni, " ", debug_interrupt};
		`operation(`op_interrupt): debug = {`os_interrupt, " ", debug_interrupt};

		`operation(`op_input): debug = {`os_input, " ", debug_operand};
		`operation(`op_output): debug = {`os_output, " ", debug_operand};
`ifdef HAS_COMPARE_OPERATION
		`operation(`op_compare): debug = {`os_compare, " ", debug_operand};
`endif
`ifdef HAS_TEST_OPERATION
		`operation(`op_test): debug = {`os_test, " ", debug_operand};
`endif
`ifdef HAS_SCRATCH_MEMORY
		`operation(`op_fetch): debug = {`os_fetch, " ", debug_operand};
		`operation(`op_store): debug = {`os_store, " ", debug_operand};
`endif

		default: debug = `os_invalid;
	endcase

`endif // HAS_DEBUG


endmodule

`endif // PACOBLAZE_IDU_V_
