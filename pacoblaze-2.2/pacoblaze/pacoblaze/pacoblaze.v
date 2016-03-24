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
	Behavioral KCPSMX implementation.
*/

`ifndef PACOBLAZE_V_
`define PACOBLAZE_V_

`include "pacoblaze_inc.v"

`include "pacoblaze_idu.v"
`include "pacoblaze_alu.v"
`include "pacoblaze_stack.v"
`ifdef HAS_WIDE_ALU // HAS_MUL_OPERATION implied
`include "pacoblaze_dregister.v"
`else
`include "pacoblaze_register.v"
`endif
`ifdef HAS_SCRATCH_MEMORY
`include "pacoblaze_scratch.v"
`endif

`ifdef USE_ONEHOT_ENCODING
`define operation(x) operation[(x)]
`define operation_is(x) idu_operation[(x)]
`else
`define operation(x) (x)
`define operation_is(x) (idu_operation == (x))
`endif


/** Top PacoBlaze module */
module `PACOBLAZE(
	address, instruction,
	port_id,
	write_strobe, out_port,
	read_strobe, in_port,
	interrupt,
`ifdef HAS_INTERRUPT_ACK
	interrupt_ack,
`endif
	reset, clk
);
output [`code_depth-1:0] address; ///< Address output
input [`code_width-1:0] instruction; ///< Instruction input
output [`port_depth-1:0] port_id; ///< Port address
output write_strobe; ///< Port output strobe
output [`port_width-1:0] out_port; ///< Port output
output read_strobe; ///< Port input strobe
input [`port_width-1:0] in_port; ///< Port input
input interrupt; ///< Interrupt request
`ifdef HAS_INTERRUPT_ACK
output interrupt_ack; ///< Interrupt acknowledge (output)
`endif
input reset; ///< Reset input
input clk; ///< Clock input

/* Output registers */
reg write_strobe, read_strobe;

/* Processor registers and signals */
reg [`code_depth-1:0] program_counter; ///< Program counter
reg timing_control; ///< Timing control register

reg zero; ///< Zero flag
reg carry; ///< Carry flag
reg interrupt_enable; ///< Interrupt enable
reg interrupt_latch; ///< Interrupt latch hold
reg interrupt_ack; ///< Interrupt acknowledge
reg zero_saved; ///< Interrupt-saved zero flag
reg carry_saved; ///< Interrupt-saved carry flag
`ifdef HAS_RESET_LATCH
reg [1:0] reset_latch; ///< Reset latch
`endif
reg zero_carry_write_enable; ///< Zero/Carry update

wire internal_reset; ///< Internal reset signal
wire [`code_depth-1:0] program_counter_source, program_counter_next; ///< Next program counter logic
wire conditional_match; ///< True when unconditional or flags match
wire interrupt_assert; ///< True when interrupt condition is met


/* IDU - Instruction Decode Unit */
wire [`operation_width-1:0] idu_operation;
wire [2:0] idu_shift_operation;
wire idu_shift_direction, idu_shift_constant;
wire idu_operand_selection;
wire [`register_depth-1:0] idu_x_address, idu_y_address;
wire [`operand_width-1:0] idu_implied_value;
wire [`port_depth-1:0] idu_port_address;
`ifdef HAS_SCRATCH_MEMORY
wire [`scratch_depth-1:0] idu_scratch_address;
`endif
wire [`code_depth-1:0] idu_code_address;
wire idu_conditional;
wire [1:0] idu_condition_flags;
wire idu_interrupt_enable;
`ifdef HAS_DEBUG
wire [8*`idu_debug_width:1] idu_debug;
wire [8*`alu_debug_width:1] alu_debug;
`endif


`PACOBLAZE_IDU idu(
	instruction,
	idu_operation,
	idu_shift_operation, idu_shift_direction, idu_shift_constant,
	idu_operand_selection,
	idu_x_address, idu_y_address,
	idu_implied_value, idu_port_address,
`ifdef HAS_SCRATCH_MEMORY
	idu_scratch_address,
`endif
	idu_code_address,
	idu_conditional, idu_condition_flags,
	idu_interrupt_enable
`ifdef HAS_DEBUG
	, idu_debug
`endif
);


/* ALU - Arithmetic-Logic Unit */
wire [`operand_width-1:0] alu_result, alu_operand_a, alu_operand_b;
wire alu_zero_out, alu_carry_out;
`ifdef HAS_WIDE_ALU
wire [`operand_width-1:0] alu_resultw, alu_operand_u, alu_operand_v;
`endif

`PACOBLAZE_ALU alu(
	idu_operation,
	idu_shift_operation, idu_shift_direction, idu_shift_constant,
	alu_result, alu_operand_a, alu_operand_b,
`ifdef HAS_WIDE_ALU
	alu_resultw, alu_operand_u, alu_operand_v,
`endif
	carry, alu_zero_out, alu_carry_out
`ifdef HAS_DEBUG
	, alu_debug
`endif
);

wire is_alu =
	// `operation_is(`op_load)
	`operation_is(`op_and)
	|| `operation_is(`op_or)
	|| `operation_is(`op_xor)
	|| `operation_is(`op_add)
	|| `operation_is(`op_addcy)
	|| `operation_is(`op_sub)
	|| `operation_is(`op_subcy)
	|| `operation_is(`op_rs)
`ifdef HAS_COMPARE_OPERATION
	|| `operation_is(`op_compare)
`endif
`ifdef HAS_TEST_OPERATION
	|| `operation_is(`op_test)
`endif
`ifdef HAS_MUL_OPERATION
	|| `operation_is(`op_mul)
`endif
`ifdef HAS_WIDE_ALU
	||`operation_is(`op_addw)
	||`operation_is(`op_addwcy)
	||`operation_is(`op_subw)
	||`operation_is(`op_subwcy)
`endif
	;

/* Register file */
reg register_x_write_enable;
wire [`register_width-1:0] register_x_data_in, register_x_data_out, register_y_data_out;
`ifdef HAS_WIDE_ALU
reg register_wx_write_enable;
wire [`register_width-1:0] register_w_data_in, register_u_data_out, register_v_data_out;
`endif

`PACOBLAZE_REGISTER register(
	idu_x_address, register_x_write_enable, register_x_data_in, register_x_data_out,
	idu_y_address, register_y_data_out,
`ifdef HAS_WIDE_ALU
	register_wx_write_enable, register_w_data_in, register_u_data_out, register_v_data_out,
`endif
	reset, clk
);

/* Call/return stack */
wire stack_write_enable, stack_update_enable, stack_push_pop;
wire [`stack_width-1:0] stack_data_in = program_counter;
wire [`stack_width-1:0] stack_data_out;

`PACOBLAZE_STACK stack(
	stack_write_enable, stack_update_enable, stack_push_pop, stack_data_in, stack_data_out,
	reset, clk
);

/* Scratchpad RAM */
`ifdef HAS_SCRATCH_MEMORY
reg scratch_write_enable;
wire [`scratch_depth-1:0] scratch_address =
	(idu_operand_selection == 0) ? idu_scratch_address :
	register_y_data_out[`scratch_depth-1:0];
wire [`scratch_width-1:0] scratch_data_out;

`PACOBLAZE_SCRATCH scratch(
	scratch_address, scratch_write_enable, register_x_data_out, scratch_data_out,
	reset, clk
);
`endif

/* Miscellaneous */
assign address = program_counter;

assign out_port = register_x_data_out;
assign port_id =
	(idu_operand_selection == 0) ? idu_port_address : register_y_data_out;

`ifdef HAS_RESET_LATCH
assign internal_reset = reset_latch[1];
`else
assign internal_reset = reset;
`endif

assign conditional_match =
	(!idu_conditional
	|| idu_condition_flags == `flag_c && carry
	|| idu_condition_flags == `flag_nc && ~carry
	|| idu_condition_flags == `flag_z && zero
	|| idu_condition_flags == `flag_nz && ~zero
	) ? 1 : 0;

wire is_jump = `operation_is(`op_jump);
wire is_call = `operation_is(`op_call);
wire is_return = `operation_is(`op_return);
wire is_returni = `operation_is(`op_returni);
wire is_input = `operation_is(`op_input);
`ifdef HAS_SCRATCH_MEMORY
wire is_fetch = `operation_is(`op_fetch);
`endif

assign program_counter_source =
	(interrupt_latch) ? `interrupt_vector :
	(conditional_match && (is_jump || is_call)) ? idu_code_address : // PC from opcode
	(conditional_match && is_return || is_returni) ? stack_data_out : // PC from stack
	program_counter; // current PC

assign program_counter_next =
	(interrupt_latch ||
	conditional_match && (is_jump || is_call)
	|| is_returni) ? program_counter_source : // PC not incremented
	program_counter_source + 1; // PC must be incremented

assign interrupt_assert = interrupt && interrupt_enable;

assign stack_write_enable =
	internal_reset || timing_control; // update stack at reset and T==1
assign stack_update_enable = ~timing_control &&
	(conditional_match && (is_call || is_return)
	|| is_returni
	|| interrupt_latch);
assign stack_push_pop = interrupt_latch ||
	((conditional_match && is_return || is_returni) ? 0 : 1);

assign alu_operand_a = register_x_data_out;
assign alu_operand_b =
	(idu_operand_selection == 0) ? idu_implied_value : register_y_data_out;
assign register_x_data_in =
`ifdef HAS_SCRATCH_MEMORY
	(is_fetch) ? scratch_data_out :
`endif
	(is_input) ? in_port : alu_result;

`ifdef HAS_WIDE_ALU
assign alu_operand_u = register_u_data_out;
assign alu_operand_v = register_v_data_out;
assign register_w_data_in = alu_resultw;
`endif


/*
task decode;
input [`operation_width-1:0] operation;
begin
end
endtask
*/

task execute;
input [`operation_width-1:0] operation;
begin
	// synthesis parallel_case full_case
`ifdef USE_ONEHOT_ENCODING
	case (1'b1)
`else
	case (operation)
`endif
		`operation(`op_load): register_x_write_enable <= 1; // load register with value

		`operation(`op_and),
		`operation(`op_or),
		`operation(`op_xor),
		`operation(`op_add),
		`operation(`op_addcy),
		`operation(`op_sub),
		`operation(`op_subcy),
		`operation(`op_rs): begin
				register_x_write_enable <= 1; // writeback register
				zero_carry_write_enable <= 1; // writeback zero, carry
			end

		`operation(`op_returni): begin
				zero <= zero_saved; carry <= carry_saved; // restore flags
				interrupt_enable <= idu_interrupt_enable; // return with interrupt enabled/disabled
			end

		`operation(`op_interrupt): interrupt_enable <= idu_interrupt_enable; // enable/disable interrupt

		`operation(`op_input): begin
				read_strobe <= 1; // flag read
				register_x_write_enable <= 1; // write into register
			end

		`operation(`op_output): write_strobe <= 1; // flag write


`ifdef HAS_COMPARE_OPERATION
		`operation(`op_compare): zero_carry_write_enable <= 1; // writeback zero, carry
`endif

`ifdef HAS_TEST_OPERATION
		`operation(`op_test): zero_carry_write_enable <= 1; // writeback zero, carry
`endif

`ifdef HAS_SCRATCH_MEMORY
		`operation(`op_fetch): register_x_write_enable <= 1; // transfer scratchpad to register
		`operation(`op_store): scratch_write_enable <= 1; // transfer register to scratchpad
`endif

`ifdef HAS_MUL_OPERATION
		`operation(`op_mul): begin
				register_wx_write_enable <= 1; // writeback wide register
				zero_carry_write_enable <= 1;
			end
`endif

`ifdef HAS_WIDE_ALU
		`operation(`op_addw),
		`operation(`op_addwcy),
		`operation(`op_subw),
		`operation(`op_subwcy): begin
				register_wx_write_enable <= 1; // writeback wide register
				zero_carry_write_enable <= 1; // writeback zero, carry
			end
`endif

		default: ;
	endcase
end
endtask

/* Combinatorial main block */
/*
always @(program_counter) begin: com
end
*/

/* Sequential internal reset control */
`ifdef HAS_RESET_LATCH
always @(posedge clk) begin: on_reset
	if (reset) reset_latch <= 'b11; // initialize latch
	else begin
		reset_latch[1] <= reset_latch[0]; // shift latch
		reset_latch[0] <= 0;
	end
end
`endif

/* Sequential main block */
always @(posedge clk) begin: seq
	/* Idle values and default actions */
	read_strobe <= 0; write_strobe <= 0;
	register_x_write_enable <= 0;
`ifdef HAS_WIDE_ALU
	register_wx_write_enable <= 0;
`endif
`ifdef HAS_SCRATCH_MEMORY
	scratch_write_enable <= 0;
`endif
	interrupt_ack <= 0;
	zero_carry_write_enable <= 0;

	if (internal_reset) begin: on_internal_reset
		/* Reset values */
		timing_control <= 0;
		program_counter <= `reset_vector; // load reset vector
		zero <= 0; carry <= 0; // flags begin cleared
		interrupt_enable <= 0; interrupt_latch <= 0; // interrupts disabled at reset
	end
	else begin: on_run
		timing_control <= ~timing_control; // step timing control

		interrupt_latch <= interrupt_assert | interrupt_latch; // recognize interrupt

		/* First stage, T == 0 */
		if (timing_control == 0) begin
			program_counter <= program_counter_next; // default next program counter

			if (interrupt_latch) begin // process interrupt
				interrupt_enable <= 0; interrupt_latch <= 0; // clear interrupt
				interrupt_ack <= 1; // acknowledge interrupt
				zero_saved <= zero; carry_saved <= carry; // save flags
			end
			else // execute instruction
				execute(idu_operation);
		end
		/* Second stage, T == 1 */
		else begin
			if (zero_carry_write_enable) begin
				zero <= alu_zero_out; carry <= alu_carry_out; // update alu flags
			end
		end

	end // on_run

end
endmodule

`endif // PACOBLAZE_V_
