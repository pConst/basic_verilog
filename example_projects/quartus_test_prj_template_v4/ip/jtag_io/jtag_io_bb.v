
module jtag_io (
	reset_reset_n,
	clk_clk,
	out0_export,
	out1_export,
	in0_export,
	in1_export);	

	input		reset_reset_n;
	input		clk_clk;
	output	[31:0]	out0_export;
	output	[31:0]	out1_export;
	input	[31:0]	in0_export;
	input	[31:0]	in1_export;
endmodule
