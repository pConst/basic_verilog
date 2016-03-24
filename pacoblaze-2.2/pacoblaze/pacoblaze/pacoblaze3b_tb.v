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
	PacoBlaze test
*/

`define PACOBLAZE3
`define TEST_FILE "../test/pb3_int.rmh"

`include "timescale_inc.v"
`include "pacoblaze_inc.v"

module pacoblaze3_tb;

parameter tck = 10, program_size = 1024;

reg clk, rst, ir; // clock, reset, interrupt request
wire [`code_depth-1:0] ad; // instruction address
wire [`operand_width-1:0] pa, po; // port id, port output
wire rd, wr; // read strobe, write strobe
`ifdef HAS_INTERRUPT_ACK
wire ia; // interrupt acknowledge
`endif

reg [`operand_width-1:0] prt[0:`port_size-1]; // port memory

wire [`code_width-1:0] di; // program data input
wire [`operand_width-1:0] pi = prt[pa]; // port input

blockram #(.width(`code_width), .depth(`code_depth))
	rom(
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.we(1'b0),
	.ad(ad),
	.di(`code_width 'b0),
	.do(di)
);

pacoblaze3 dut(
	.clk(clk),
	.reset(rst),
	.address(ad),
	.instruction(di),
	.port_id(pa),
	.read_strobe(rd),
	.write_strobe(wr),
	.in_port(pi),
	.out_port(po),
	.interrupt(ir)
`ifdef HAS_INTERRUPT_ACK
	,	.interrupt_ack(ia)
`endif
);

// clocking device
always #(tck/2) clk = ~clk;

// write to port memory
always @(posedge clk)	if (wr) prt[pa] <= po;

// initial setup
initial begin
	$dumpvars(1, dut);
	$dumpfile("pacoblaze3b_tb.vcd");
	$readmemh(`TEST_FILE, rom.ram);
end

// simulation
integer i;
initial begin
	for (i=0; i<`port_size; i=i+1) prt[i] = i; // initialize ports
	clk = 0; rst = 1; ir = 1;
	#(tck*2);
	@(negedge clk) rst = 0; // free processor

	#(program_size*tck+100) $finish;
end

endmodule
