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

`define PACOBLAZE1

`ifndef TEST_FILE
`define TEST_FILE "../test/adc_ctrl.rmh"
`endif

`ifndef TEST_CYCLES
`define TEST_CYCLES 1000
`endif

`ifndef TEST_IRQ
`define TEST_IRQ 100
`endif

`include "timescale_inc.v"
`include "pacoblaze_inc.v"

module pacoblaze1_tb;

parameter tck = 10, program_cycles = `TEST_CYCLES;

reg clk, rst, irq; // clock, reset, interrupt request
wire [`code_depth-1:0] addr; // instruction address
wire [`operand_width-1:0] pid, pout; // port id, port output
wire ren, wen; // read strobe, write strobe
`ifdef HAS_INTERRUPT_ACK
wire iak; // interrupt acknowledge
`endif

reg [`operand_width-1:0] port[0:`port_size-1]; // port memory

wire [`code_width-1:0] din; // program data input
wire [`operand_width-1:0] pin = port[pid]; // port input

/* PacoBlaze program memory */
blockram #(.width(`code_width), .depth(`code_depth))
	rom(
	.clk(clk),
	.rst(rst),
	.enb(1'b1),
	.wen(1'b0),
	.addr(addr),
	.din(`code_width 'b0),
	.dout(din)
);

/* PacoBlaze dut */
pacoblaze1 dut(
	.clk(clk),
	.reset(rst),
	.address(addr),
	.instruction(din),
	.port_id(pid),
	.read_strobe(ren),
	.write_strobe(wen),
	.in_port(pin),
	.out_port(pout),
	.interrupt(irq)
`ifdef HAS_INTERRUPT_ACK
	,	.interrupt_ack(iak)
`endif
);

/* Clocking device */
always #(tck/2) clk = ~clk;

/* Watch port memory */
always @(posedge clk)	if (wen) port[pid] <= pout;

/* Display code */
always @(negedge clk)
	if (dut.timing_control)
`ifdef HAS_DEBUG
		$display("%h:%h %s", addr, din, dut.idu_debug);
`else
		$display("%h:%h", rom.addr, rom.din);
`endif

/* Simulation setup */
initial begin
	$dumpvars(-1, dut);
	$dumpfile("pacoblaze1_tb.vcd");
	$readmemh(`TEST_FILE, rom.ram);
end

/* Simulation */
integer i;
initial begin
	for (i=0; i<`port_size; i=i+1) port[i] = i; // initialize ports
	clk = 0; rst = 1; irq = 0;
	#(tck*2);
	@(negedge clk) rst = 0; // free processor

	#(tck*`TEST_IRQ);
	@(negedge clk) irq = 1; // interrupt request
	// @(negedge clk) ;
	@(negedge clk) irq = 0;

	#(program_cycles*tck+100) $finish;
end

endmodule
