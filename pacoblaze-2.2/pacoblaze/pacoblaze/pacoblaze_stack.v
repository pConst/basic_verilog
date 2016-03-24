/*
	Copyright (C) 2004-2007 Pablo Bleyer Kocik.

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
	PacoBlaze Call/return stack; single-port RAM.
*/

`ifndef PACOBLAZE_STACK_V_
`define PACOBLAZE_STACK_V_

`include "pacoblaze_inc.v"


module `PACOBLAZE_STACK(
	write_enable, update_enable, push_pop, data_in, data_out,
	reset, clk
);
input clk, reset, write_enable, update_enable, push_pop; // push:1, pop:0
input [`stack_width-1:0] data_in;
output [`stack_width-1:0] data_out;

reg [`stack_width-1:0] spr[0:`stack_size-1]; // single port ram memory
reg [`stack_depth-1:0] ptr; // stack pointer

wire [`stack_depth-1:0] ptr_1 =
	(push_pop) ? ptr + 1 : ptr - 1;

assign data_out = spr[ptr_1];

// eliminate undefined data on stack underflow
integer i;
initial for(i=0; i<`stack_size; i=i+1) spr[i] <= 0;

always @(posedge clk)
	if (reset) ptr <= 0;
	else begin
		if (write_enable) spr[ptr] <= data_in;
		if (update_enable) ptr <= ptr_1;
	end

endmodule

`endif // PACOBLAZE_STACK_V_
