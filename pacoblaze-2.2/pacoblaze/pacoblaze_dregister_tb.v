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
	PacoBlaze Dual Register test
*/

`define PACOBLAZE3
`define PACOBLAZE_REGISTER pacoblaze3_register

`include "timescale_inc.v"
`include "pacoblaze_inc.v"

module pacoblaze_dregister_tb;

parameter tck = 10;

reg clk, reset, x_write_enable, wx_write_enable;
reg [`register_depth-1:0] x_address, y_address;
reg [`register_width-1:0] x_data_in, w_data_in;
wire [`register_width-1:0] x_data_out, y_data_out;

`PACOBLAZE_DREGISTER dut(
	x_address, x_write_enable, x_data_in, x_data_out,
	y_address, y_data_out,
	wx_write_enable, w_data_in,
	reset, clk
);

//task single_write;
//endtask
//
//task dual_write;
//endtask


// initial setup
initial begin
	$dumpvars(1, dut);
	$dumpfile("pacoblaze_dregister_tb.vcd");
	// $monitor("%h: %s", instruction, debug);
end

// clocking device
always #(tck/2) clk = ~clk;

// simulation
integer i;
initial begin
	clk = 0; reset = 0; x_write_enable = 0; wx_write_enable = 0;
	x_address = 0; y_address = 0;
	x_data_in = 0; w_data_in = 0;

	@(negedge clk);
	x_address = 5; x_data_in = 'hca; x_write_enable = 1;
	@(negedge clk);
	x_write_enable = 0;

	y_address = 5;

	@(negedge clk);
	x_address = 8; w_data_in = 'hba; x_data_in = 'hbe; wx_write_enable = 1;
	@(negedge clk);
	wx_write_enable = 0;

	x_address = 9; y_address = 8; // inverted

	#(tck*2) $finish;

end

endmodule
