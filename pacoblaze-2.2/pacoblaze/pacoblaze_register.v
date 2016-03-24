/*
	Copyright (C) 2004 Pablo Bleyer Kocik.

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
	PacoBlaze Register File; dual-port RAM.
*/

`ifndef PACOBLAZE_REGISTER_V_
`define PACOBLAZE_REGISTER_V_

`include "pacoblaze_inc.v"

module `PACOBLAZE_REGISTER(
	x_address, x_write_enable, x_data_in, x_data_out,
	y_address, y_data_out,
	reset, clk
);
input clk, reset, x_write_enable;
input [`register_depth-1:0] x_address, y_address;
input [`register_width-1:0] x_data_in;
output [`register_width-1:0] x_data_out, y_data_out;

reg [`register_width-1:0] dpr[0:`register_size-1];

assign x_data_out = dpr[x_address];
assign y_data_out = dpr[y_address];

always @(posedge clk)
	if (x_write_enable) dpr[x_address] <= x_data_in;

endmodule

`endif // PACOBLAZE_REGISTER_V_
