/*
	Copyright (C) 2006 Pablo Bleyer Kocik.

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
	PacoBlaze Dual Register File; dual-port RAM.
*/

`ifndef PACOBLAZE_DREGISTER_V_
`define PACOBLAZE_DREGISTER_V_

`include "pacoblaze_inc.v"


module `PACOBLAZE_REGISTER(
	x_address, x_write_enable, x_data_in, x_data_out,
	y_address, y_data_out,
	wx_write_enable, w_data_in, u_data_out, v_data_out,
	reset, clk
);
input clk, reset; ///< Clock, reset
input x_write_enable, wx_write_enable; ///< Write single or contiguous (wide) registers
input [`register_depth-1:0] x_address, y_address; ///< Register x, y address
input [`register_width-1:0] x_data_in, w_data_in; ///< Register x, w data input
output [`register_width-1:0] x_data_out, y_data_out; ///< Register x, y data output
output [`register_width-1:0] u_data_out, v_data_out; ///< Register u, v data output

reg [`register_width-1:0]
	dpre[0:(`register_size>>1)-1], // even position dual-port ram
	dpro[0:(`register_size>>1)-1]; // odd position dual-port ram

wire [`register_depth-2:0]
	x_address_base = x_address[`register_depth-1:1], // base x-register address
	y_address_base = y_address[`register_depth-1:1]; // base y-register address

wire [`register_width-1:0]
	dpre_in = x_data_in, // x-register data in
	dpro_in = (wx_write_enable) ? w_data_in : x_data_in; // wx-register data in

wire
	dpre_we = (wx_write_enable || x_write_enable && !x_address[0]), // write even
	dpro_we = (wx_write_enable || x_write_enable && x_address[0]); // write odd

assign u_data_out = dpro[x_address_base]; // always odd (high) x
assign x_data_out =
	(x_address[0]) ? dpro[x_address_base] : dpre[x_address_base]; // x-register output
assign v_data_out = dpro[y_address_base]; // always odd (high) y
assign y_data_out =
	(y_address[0]) ? dpro[y_address_base] : dpre[y_address_base]; // y-register output

always @(posedge clk)
begin
	if (dpre_we) dpre[x_address_base] <= dpre_in; // even write
	if (dpro_we) dpro[x_address_base] <= dpro_in; // odd write
end

endmodule

`endif // PACOBLAZE_DREGISTER_V_
