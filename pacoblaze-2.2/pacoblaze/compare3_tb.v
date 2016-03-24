/*
	Compare KCPSM3 and PacoBlaze3
*/

`define PACOBLAZE3

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

module compare3_tb;

parameter tck = 10, program_cycles = `TEST_CYCLES, irq_cycles = `TEST_IRQ;

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
	.enb(1'b1),
	.wen(1'b0),
	.addr(addr_0),
	.din(0),
	.dout(din_0)
);

/* PacoBlaze dut */
pacoblaze3 dut_0(
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
	.enb(1'b1),
	.wen(1'b0),
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

integer i;
always @(negedge clk)
	if (!dut_0.timing_control) begin
		$display("pb3=%h:%h kp3=%h:%h", addr_0, din_0, addr_1, din_1);
		if (addr_0 != addr_1) $display("***address mismatch***");
		if (dut_0.zero != dut_1.zero_flag) $display("***zero mismatch***");
		if (dut_0.carry != dut_1.carry_flag) $display("***carry mismatch***");
		if (dut_0.register.dpr['h0] != dut_1.s0_contents) $display("***s0 mismatch***");
		if (dut_0.register.dpr['h1] != dut_1.s1_contents) $display("***s1 mismatch***");
		if (dut_0.register.dpr['h2] != dut_1.s2_contents) $display("***s2 mismatch***");
		if (dut_0.register.dpr['h3] != dut_1.s3_contents) $display("***s3 mismatch***");
		if (dut_0.register.dpr['h4] != dut_1.s4_contents) $display("***s4 mismatch***");
		if (dut_0.register.dpr['h5] != dut_1.s5_contents) $display("***s5 mismatch***");
		if (dut_0.register.dpr['h6] != dut_1.s6_contents) $display("***s6 mismatch***");
		if (dut_0.register.dpr['h7] != dut_1.s7_contents) $display("***s7 mismatch***");
		if (dut_0.register.dpr['h8] != dut_1.s8_contents) $display("***s8 mismatch***");
		if (dut_0.register.dpr['h9] != dut_1.s9_contents) $display("***s9 mismatch***");
		if (dut_0.register.dpr['ha] != dut_1.sa_contents) $display("***sa mismatch***");
		if (dut_0.register.dpr['hb] != dut_1.sb_contents) $display("***sb mismatch***");
		if (dut_0.register.dpr['hc] != dut_1.sc_contents) $display("***sc mismatch***");
		if (dut_0.register.dpr['hd] != dut_1.sd_contents) $display("***sd mismatch***");
		if (dut_0.register.dpr['he] != dut_1.se_contents) $display("***se mismatch***");
		if (dut_0.register.dpr['hf] != dut_1.sf_contents) $display("***sf mismatch***");
		if (dut_0.scratch.spr['h00] != dut_1.spm00_contents) $display("***spm00 mismatch***");
		if (dut_0.scratch.spr['h01] != dut_1.spm01_contents) $display("***spm01 mismatch***");
		if (dut_0.scratch.spr['h02] != dut_1.spm02_contents) $display("***spm02 mismatch***");
		if (dut_0.scratch.spr['h03] != dut_1.spm03_contents) $display("***spm03 mismatch***");
		if (dut_0.scratch.spr['h04] != dut_1.spm04_contents) $display("***spm04 mismatch***");
		if (dut_0.scratch.spr['h05] != dut_1.spm05_contents) $display("***spm05 mismatch***");
		if (dut_0.scratch.spr['h06] != dut_1.spm06_contents) $display("***spm06 mismatch***");
		if (dut_0.scratch.spr['h07] != dut_1.spm07_contents) $display("***spm07 mismatch***");
		if (dut_0.scratch.spr['h08] != dut_1.spm08_contents) $display("***spm08 mismatch***");
		if (dut_0.scratch.spr['h09] != dut_1.spm09_contents) $display("***spm09 mismatch***");
		if (dut_0.scratch.spr['h0a] != dut_1.spm0a_contents) $display("***spm0a mismatch***");
		if (dut_0.scratch.spr['h0b] != dut_1.spm0b_contents) $display("***spm0b mismatch***");
		if (dut_0.scratch.spr['h0c] != dut_1.spm0c_contents) $display("***spm0c mismatch***");
		if (dut_0.scratch.spr['h0d] != dut_1.spm0d_contents) $display("***spm0d mismatch***");
		if (dut_0.scratch.spr['h0e] != dut_1.spm0e_contents) $display("***spm0e mismatch***");
		if (dut_0.scratch.spr['h0f] != dut_1.spm0f_contents) $display("***spm0f mismatch***");
		if (dut_0.scratch.spr['h10] != dut_1.spm10_contents) $display("***spm10 mismatch***");
		if (dut_0.scratch.spr['h11] != dut_1.spm11_contents) $display("***spm11 mismatch***");
		if (dut_0.scratch.spr['h12] != dut_1.spm12_contents) $display("***spm12 mismatch***");
		if (dut_0.scratch.spr['h13] != dut_1.spm13_contents) $display("***spm13 mismatch***");
		if (dut_0.scratch.spr['h14] != dut_1.spm14_contents) $display("***spm14 mismatch***");
		if (dut_0.scratch.spr['h15] != dut_1.spm15_contents) $display("***spm15 mismatch***");
		if (dut_0.scratch.spr['h16] != dut_1.spm16_contents) $display("***spm16 mismatch***");
		if (dut_0.scratch.spr['h17] != dut_1.spm17_contents) $display("***spm17 mismatch***");
		if (dut_0.scratch.spr['h18] != dut_1.spm18_contents) $display("***spm18 mismatch***");
		if (dut_0.scratch.spr['h19] != dut_1.spm19_contents) $display("***spm19 mismatch***");
		if (dut_0.scratch.spr['h1a] != dut_1.spm1a_contents) $display("***spm1a mismatch***");
		if (dut_0.scratch.spr['h1b] != dut_1.spm1b_contents) $display("***spm1b mismatch***");
		if (dut_0.scratch.spr['h1c] != dut_1.spm1c_contents) $display("***spm1c mismatch***");
		if (dut_0.scratch.spr['h1d] != dut_1.spm1d_contents) $display("***spm1d mismatch***");
		if (dut_0.scratch.spr['h1e] != dut_1.spm1e_contents) $display("***spm1e mismatch***");
		if (dut_0.scratch.spr['h1f] != dut_1.spm1f_contents) $display("***spm1f mismatch***");
		if (dut_0.scratch.spr['h20] != dut_1.spm20_contents) $display("***spm20 mismatch***");
		if (dut_0.scratch.spr['h21] != dut_1.spm21_contents) $display("***spm21 mismatch***");
		if (dut_0.scratch.spr['h22] != dut_1.spm22_contents) $display("***spm22 mismatch***");
		if (dut_0.scratch.spr['h23] != dut_1.spm23_contents) $display("***spm23 mismatch***");
		if (dut_0.scratch.spr['h24] != dut_1.spm24_contents) $display("***spm24 mismatch***");
		if (dut_0.scratch.spr['h25] != dut_1.spm25_contents) $display("***spm25 mismatch***");
		if (dut_0.scratch.spr['h26] != dut_1.spm26_contents) $display("***spm26 mismatch***");
		if (dut_0.scratch.spr['h27] != dut_1.spm27_contents) $display("***spm27 mismatch***");
		if (dut_0.scratch.spr['h28] != dut_1.spm28_contents) $display("***spm28 mismatch***");
		if (dut_0.scratch.spr['h29] != dut_1.spm29_contents) $display("***spm29 mismatch***");
		if (dut_0.scratch.spr['h2a] != dut_1.spm2a_contents) $display("***spm2a mismatch***");
		if (dut_0.scratch.spr['h2b] != dut_1.spm2b_contents) $display("***spm2b mismatch***");
		if (dut_0.scratch.spr['h2c] != dut_1.spm2c_contents) $display("***spm2c mismatch***");
		if (dut_0.scratch.spr['h2d] != dut_1.spm2d_contents) $display("***spm2d mismatch***");
		if (dut_0.scratch.spr['h2e] != dut_1.spm2e_contents) $display("***spm2e mismatch***");
		if (dut_0.scratch.spr['h2f] != dut_1.spm2f_contents) $display("***spm2f mismatch***");
		if (dut_0.scratch.spr['h30] != dut_1.spm30_contents) $display("***spm30 mismatch***");
		if (dut_0.scratch.spr['h31] != dut_1.spm31_contents) $display("***spm31 mismatch***");
		if (dut_0.scratch.spr['h32] != dut_1.spm32_contents) $display("***spm32 mismatch***");
		if (dut_0.scratch.spr['h33] != dut_1.spm33_contents) $display("***spm33 mismatch***");
		if (dut_0.scratch.spr['h34] != dut_1.spm34_contents) $display("***spm34 mismatch***");
		if (dut_0.scratch.spr['h35] != dut_1.spm35_contents) $display("***spm35 mismatch***");
		if (dut_0.scratch.spr['h36] != dut_1.spm36_contents) $display("***spm36 mismatch***");
		if (dut_0.scratch.spr['h37] != dut_1.spm37_contents) $display("***spm37 mismatch***");
		if (dut_0.scratch.spr['h38] != dut_1.spm38_contents) $display("***spm38 mismatch***");
		if (dut_0.scratch.spr['h39] != dut_1.spm39_contents) $display("***spm39 mismatch***");
		if (dut_0.scratch.spr['h3a] != dut_1.spm3a_contents) $display("***spm3a mismatch***");
		if (dut_0.scratch.spr['h3b] != dut_1.spm3b_contents) $display("***spm3b mismatch***");
		if (dut_0.scratch.spr['h3c] != dut_1.spm3c_contents) $display("***spm3c mismatch***");
		if (dut_0.scratch.spr['h3d] != dut_1.spm3d_contents) $display("***spm3d mismatch***");
		if (dut_0.scratch.spr['h3e] != dut_1.spm3e_contents) $display("***spm3e mismatch***");
		if (dut_0.scratch.spr['h3f] != dut_1.spm3f_contents) $display("***spm3f mismatch***");

`ifdef HAS_DEBUG
		// $display("%h %h", dut.idu.instruction_0, dut.alu.operation);
		$display("%s %s", dut_0.idu_debug, (dut_0.is_alu) ? {"[", dut_0.alu_debug, "]"} : "");
`endif

	end

/* Simulation setup */
initial begin
	$dumpvars(-1, compare3_tb);
	$dumpfile("compare3_tb.vcd");
	$readmemh(`TEST_FILE, rom_0.ram);
	$readmemh(`TEST_FILE, rom_1.ram);
end

/* Simulation */
initial begin
	/* Initialize port memory */
	for (i=0; i<`port_size; i=i+1) begin
		port_0[i] = i;
		port_1[i] = i;
	end

	clk = 0; rst = 1; irq = 0;
	#(tck*3);
	@(negedge clk) rst = 0; // free processor

	#(tck*irq_cycles);
	@(negedge clk) irq = 1; // flag interrupt
	$display("*IRQ*");
	@(negedge clk) ;
	@(negedge clk) irq = 0;

	#(tck*program_cycles) $finish;
end

endmodule
