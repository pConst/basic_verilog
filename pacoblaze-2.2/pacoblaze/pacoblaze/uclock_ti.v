/*
	Copyright (c) 2004, 2006 Pablo Bleyer Kocik.

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
	PacoBlaze uclock test implementation
*/

`include "timescale_inc.v"
`include "pacoblaze_inc.v"

module uclock_ti(
	MCKO,
	nRST,
	A, D,
	IOA
);

input MCKO, nRST;
input [23:0] A;
input [15:0] D;
inout [13:0] IOA;

wire clk, rst, ir; // clock, reset, interrupt req
wire [`code_depth-1:0] ad; // instruction address
wire [`operand_width-1:0] pa, po; // port id, port out
wire rd, wr, ia; // read strobe, write strobe, interrupt ack

wire [`code_width-1:0] di;
wire [`operand_width-1:0] pi;

assign clk = MCKO;
assign rst = !nRST;
assign pi = D[7:0];
assign IOA[7:0] = po;
assign IOA[8] = 'hz;
assign ir = IOA[8];


uclock rom(
	.clk(clk),
	.address(ad),
	.instruction(di)
);

pacoblaze dut(
	.clk(clk),
	.reset(rst),
	.address(ad),
	.instruction(di),
	.port_id(pa),
	.read_strobe(rd),
	.write_strobe(wr),
	.in_port(pi),
	.out_port(po),
	.interrupt(ir),
	.interrupt_ack(ia)
);

endmodule
