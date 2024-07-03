// Quartus Prime SystemVerilog Template
//
// Simple Dual-Port RAM with different read/write addresses and single read/write clock
// and with a control for writing single bytes into the memory word; byte enable

module byte_enabled_simple_dual_port_ram
	#(parameter int
		ADDR_WIDTH = 6,
		BYTE_WIDTH = 8,
		BYTES = 4,
			WIDTH = BYTES * BYTE_WIDTH
)
( 
	input [ADDR_WIDTH-1:0] waddr,
	input [ADDR_WIDTH-1:0] raddr,
	input [BYTES-1:0] be,
	input [BYTE_WIDTH-1:0] wdata, 
	input we, clk,
	output reg [WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a multi-dimensional packed array to model individual bytes within the word
	logic [BYTES-1:0][BYTE_WIDTH-1:0] ram[0:WORDS-1];

	always_ff@(posedge clk)
	begin
		if(we) begin
		// edit this code if using other than four bytes per word
			if(be[0]) ram[waddr][0] <= wdata;
			if(be[1]) ram[waddr][1] <= wdata;
			if(be[2]) ram[waddr][2] <= wdata;
			if(be[3]) ram[waddr][3] <= wdata;
	end
		q <= ram[raddr];
	end
endmodule : byte_enabled_simple_dual_port_ram
