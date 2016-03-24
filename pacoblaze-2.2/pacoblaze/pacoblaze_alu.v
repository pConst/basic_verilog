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
	PacoBlaze Arithmetic-Logic Unit.
*/

`ifndef PACOBLAZE_ALU_V_
`define PACOBLAZE_ALU_V_

`include "pacoblaze_inc.v"

`ifdef USE_ONEHOT_ENCODING
`define operation(x) operation[(x)]
`define operation_is(x) operation[(x)]
`else
`define operation(x) (x)
`define operation_is(x) (operation == (x))
`endif

module `PACOBLAZE_ALU(
	operation,
	shift_operation, shift_direction, shift_constant,
	result, operand_a, operand_b,
`ifdef HAS_WIDE_ALU
	resultw, operand_u, operand_v,
`endif
	carry_in, zero_out, carry_out
`ifdef HAS_DEBUG
	, debug
`endif
);
input [`operation_width-1:0] operation; ///< Main operation
input [2:0] shift_operation; ///< Rotate/shift operation
input shift_direction; ///< Rotate/shift left(0)/right(1)
input shift_constant; ///< Shift constant (0 or 1)
output reg [`operand_width-1:0] result; ///< ALU result
input [`operand_width-1:0] operand_a, operand_b; ///< ALU operands
`ifdef HAS_WIDE_ALU
output reg [`operand_width-1:0] resultw; ///< wide ALU high result
input [`operand_width-1:0] operand_u, operand_v; ///< wide ALU high operands
`endif
input carry_in; ///< Carry in
output zero_out; ///< Zero out
output reg carry_out; ///< Carry out

`ifdef HAS_DEBUG
output reg [8*`alu_debug_width:1] debug; ///< ALU debug string
reg [18*8:1] debug_rabc; ///< ALU debug operands and result
reg [7*8:1] debug_cz; ///< ALU debug flags
`endif

/** Adder/substracter second operand. */
wire [`operand_width-1:0] addsub_b =
	(`operation_is(`op_sub)
	|| `operation_is(`op_subcy)
`ifdef HAS_COMPARE_OPERATION
	|| `operation_is(`op_compare)
`endif
	) ? ~operand_b :
	operand_b;

`ifdef HAS_WIDE_ALU
wire [2*`operand_width-1:0] addsubw_b =
	(`operation_is(`op_subw) || `operation_is(`op_subwcy)) ? ~{operand_v, operand_b} :
	{operand_v, operand_b};
`endif

/** Adder/substracter carry. */
wire addsub_carry =
	(`operation_is(`op_addcy)
`ifdef HAS_WIDE_ALU
	|| `operation_is(`op_addwcy)
`endif
	) ? carry_in :
	(`operation_is(`op_sub)
`ifdef HAS_COMPARE_OPERATION
	|| `operation_is(`op_compare)
`endif
`ifdef HAS_WIDE_ALU
	|| `operation_is(`op_subw)
`endif
	) ? 1 : // ~b => b'
	(`operation_is(`op_subcy)
`ifdef HAS_WIDE_ALU
	|| `operation_is(`op_subwcy)
`endif
	) ? ~carry_in : // ~b - c => b' - c
	0;

/** Adder/substracter with carry. */
wire [1+`operand_width-1:0] addsub_result = operand_a + addsub_b + addsub_carry;
`ifdef HAS_WIDE_ALU
wire [1+2*`operand_width-1:0] addsubw_result =
	{operand_u, operand_a} + addsubw_b + addsub_carry;
`endif

/** Shift bit value. */
// synthesis parallel_case full_case
wire shift_bit =
	(shift_operation == `opcode_rr) ? operand_a[0] : // == `opcode_slx
	(shift_operation == `opcode_rl) ? operand_a[7] : // == `opcode_srx
	(shift_operation == `opcode_rsa) ? carry_in :
	shift_constant; // == `opcode_rsc

`ifdef HAS_WIDE_ALU
wire [2*`operand_width-1:0] resultx = {resultw, result};
`endif

assign zero_out =
`ifdef HAS_MUL_OPERATION
	(`operation_is(`op_mul)) ? ~|resultx :
`endif
`ifdef HAS_WIDE_ALU
	(`operation_is(`op_addw) || `operation_is(`op_addwcy)
	|| `operation_is(`op_subw) || `operation_is(`op_subwcy)
	) ? ~|resultx :
`endif
	~|result;


/*
always @(operation,
	shift_operation, shift_direction, shift_constant, shift_bit,
	result, operand_a, operand_b, carry_in, carry_out,
	addsub_result, addsub_b, addsub_carry
`ifdef HAS_WIDE_ALU
	, resultw, operand_v, addsubw_result
`endif
	) begin
	$display("op:%b %h (%h)=(%h),(%h)", operation, operation, result, operand_a, operand_b);
	$display("as:%h=%h+%h+%b", addsub_result, operand_a, addsub_b, addsub_carry);
end
*/

// always @*
always @(operation,
	shift_operation, shift_direction, shift_constant, shift_bit,
	result, operand_a, operand_b, carry_in, carry_out,
	addsub_result, addsub_carry
`ifdef HAS_WIDE_ALU
	, resultw, operand_v, addsubw_result
`endif
	) begin: on_alu
	/* Defaults */
	carry_out = 0;
`ifdef HAS_WIDE_ALU
	resultw = operand_v;
`endif

	// synthesis parallel_case full_case
`ifdef USE_ONEHOT_ENCODING
	case (1'b1)
`else
	case (operation)
`endif

		`operation(`op_add),
		`operation(`op_addcy):
			{carry_out, result} = addsub_result;

`ifdef HAS_COMPARE_OPERATION
		`operation(`op_compare),
`endif
		`operation(`op_sub),
		`operation(`op_subcy): begin
			{carry_out, result} = {~addsub_result[8], addsub_result[7:0]};
		end

		`operation(`op_and):
			result = operand_a & operand_b;

		`operation(`op_or):
			result = operand_a | operand_b;

`ifdef HAS_TEST_OPERATION
		`operation(`op_test):
			begin result = operand_a & operand_b; carry_out = ^result; end
`endif

		`operation(`op_xor):
			result = operand_a ^ operand_b;

		`operation(`op_rs):
			if (shift_direction) // shift right
				{result, carry_out} = {shift_bit, operand_a};
			else // shift left
				{carry_out, result} = {operand_a, shift_bit};

`ifdef HAS_MUL_OPERATION
		`operation(`op_mul):
			{resultw, result} = operand_a * operand_b;
`endif

`ifdef HAS_WIDE_ALU
		`operation(`op_addw),
		`operation(`op_addwcy):
			{carry_out, resultw, result} = addsubw_result;

		`operation(`op_subw),
		`operation(`op_subwcy):
			{carry_out, resultw, result} = {~addsubw_result[16], addsubw_result[15:0]};
`endif

		default:
			result = operand_b;

	endcase

end


`ifdef HAS_DEBUG

`include "pacoblaze_util.v"

always @(operand_a, operand_b, result)
	debug_rabc = {"r=", numtohex(result[7:4]), numtohex(operand_a[3:0]), " a=", numtohex(operand_a[7:4]), numtohex(operand_a[3:0]), " b=", numtohex(operand_b[7:4]), numtohex(operand_b[3:0]), " c=", numtohex(carry_in)};

always @(carry_in, carry_out, zero_out)
	debug_cz = {"C=", numtohex(carry_out), " Z=", numtohex(zero_out)};

always @(debug_rabc, debug_cz)
	debug = {debug_rabc, ", ", debug_cz};

`endif // HAS_DEBUG


endmodule

`endif // PACOBLAZE_ALU_V_
