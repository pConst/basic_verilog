/*
	Compare KCPSM3 and PacoBlaze3m
*/

`define PACOBLAZE3M
`define PACOBLAZE pacoblaze3m

`ifndef TEST_FILE
`define TEST_FILE "../test/uclock.rmh"
`endif

`ifndef TEST_CYCLES
`define TEST_CYCLES 100
`endif

`ifndef TEST_IRQ
`define TEST_IRQ 50
`endif

`include "timescale_inc.v"
`include "pacoblaze_inc.v"

module compare3m_tb;

parameter tck = 10, program_cycles = `TEST_CYCLES;

defparam glbl.ROC_WIDTH = 0;

reg clk, rst, irq; // clock, reset, interrupt req
wire [`code_depth-1:0] addr_0, addr_1; // instruction address
reg [`operand_width-1:0] port_0[0:`port_size-1], port_1[0:`port_size-1];
wire [`operand_width-1:0] pid_0, pid_1, pout_0, pout_1; // port id, port out
wire ren_0, ren_1, wen_0, wen_1, iak_0, iak_1; // read strobe, write strobe, interrupt ack

wire [`code_width-1:0] din_0, din_1;
wire [`operand_width-1:0] pin_0 = port_0[pid_0], pin_1 = port_1[pid_1]; // port in

/* PacoBlaze program memory */
blockram #(.width(`code_width),.depth(`code_depth)) rom_0(
	.clk(clk),
	.rst(rst),
	.enb(1),
	.wen(0),
	.addr(addr_0),
	.din(0),
	.dout(din_0)
);

/* PacoBlaze dut */
`PACOBLAZE dut_0(
	.clk(clk),
	.reset(rst),
	.address(addr_0),
	.instruction(din_0),
	.port_id(pid_0),
	.read_strobe(ren_0),
	.write_strobe(wen_0),
	.in_port(pin_0),
	.out_port(pout_0),
	.interrupt(irq),
	.interrupt_ack(iak_0)
);

/* KCPSM3 program memory */
blockram #(.width(`code_width),.depth(`code_depth)) rom_1(
	.clk(clk),
	.rst(rst),
	.enb(1),
	.wen(0),
	.addr(addr_1),
	.din(0),
	.dout(din_1)
);

/* KCPSM3 dut */
kcpsm3 dut_1(
	.clk(clk),
	.reset(rst),
	.address(addr_1),
	.instruction(din_1),
	.port_id(pid_1),
	.read_strobe(ren_1),
	.write_strobe(wen_1),
	.in_port(pin_1),
	.out_port(pout_1),
	.interrupt(irq),
	.interrupt_ack(iak_1)
);

/* Clocking device */
always #(tck/2) clk = ~clk;

/* Watch external ports */
always @(posedge clk)	begin
	if (wen_0) port_0[pid_0] <= pout_0;
	if (wen_1) port_1[pid_1] <= pout_1;
end

always @(negedge clk) begin
	$display("%h:%h %h:%h", addr_0, din_0, addr_1, din_1);
	if (addr_0 != addr_1) $display("***address mismatch***");
end

/* Simulation setup */
initial begin
	$dumpvars(-1, compare3m_tb);
	$dumpfile("compare3m_tb.vcd");
	$readmemh(`TEST_FILE, rom_0.ram);
	$readmemh(`TEST_FILE, rom_1.ram);
end

/* Simulation */
integer i;
initial begin
	/* Initialize port memory */
	for (i=0; i<`port_size; i=i+1) begin
		port_0[i] = i;
		port_1[i] = i;
	end

	clk = 0; rst = 1; irq = 0;
	#(tck*3);
	@(negedge clk) rst = 0; // free processor

	#(tck*`TEST_IRQ);
	@(negedge clk) irq = 1; // flag interrupt
	@(negedge clk) ;
	@(negedge clk) irq = 0;

	#(program_cycles*tck+100) $finish;
end

endmodule
