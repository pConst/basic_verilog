/*
	Copyright (c) 2006 Pablo Bleyer Kocik.

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

/*
	PacoBlaze IDU test
*/

`define PACOBLAZE3
`define PACOBLAZE_IDU pacoblaze3_idu

`define HAS_DEBUG

`include "timescale_inc.v"
`include "pacoblaze_inc.v"

module pacoblaze_idu_tb;

parameter tck = 10;


reg [`code_width-1:0] instruction; ///< Instruction

wire [`operation_width-1:0] operation; ///< Main operation
wire [2:0] shift_operation; ///< Rotate/shift operation
wire shift_direction; ///< Rotate/shift left(0)/right(1)
wire shift_constant; ///< Shift constant value
wire operand_selection; ///< Operand selection (k/p/s:0, y:1)
wire [`register_depth-1:0] x_address, y_address; ///< Operation x source/target, y source
wire [`operand_width-1:0] implied_value; ///< Operand constant source
wire [`port_depth-1:0] port_address; ///< Port address
`ifdef HAS_SCRATCH_MEMORY
wire [`scratch_depth-1:0] scratch_address; ///< Scratchpad address
`endif
wire [`code_depth-1:0] code_address; ///< Program address
wire conditional; ///< Conditional operation (unconditional(0)/conditional(1))
wire [1:0] condition_flags; ///< Condition flags on zero and carry
wire interrupt_enable; ///< Interrupt disable(0)/enable(1)

`ifdef HAS_DEBUG
wire [8*`idu_debug_width:1] debug;
`endif

/* PacoBlaze dut */
`PACOBLAZE_IDU dut(
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

/* Initial setup */
initial begin
	$dumpvars(1, dut);
	$dumpfile("pacoblaze_idu_tb.vcd");
	// $monitor("%h: %s", instruction, debug);
end

/* Simulation */
integer i;
initial begin
	for (i=0; i<(1<<`code_width); i=i+1) begin
	// for (i=0; i<16; i=i+1) begin
		instruction = i;
		#tck $display("%h: %s", instruction, debug);
	end
	$finish;
end

endmodule
