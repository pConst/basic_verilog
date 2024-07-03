// Quartus Prime SystemVerilog Template
//
// True Dual-Port RAM with single clock and different data width on the two ports and width new data on read during write on same port
//
// The first datawidth and the widths of the addresses are specified
// The second data width is equal to DATA_WIDTH1 * RATIO, where RATIO = (1 << (ADDRESS_WIDTH1 - ADDRESS_WIDTH2)
// RATIO must have value that is supported by the memory blocks in your target
// device.  Otherwise, no RAM will be inferred.  
//
// Read-during-write behavior returns old data for mixed ports and the new data on the same port
//
// This style of RAM can be used on certain devices, e.g. Stratix V, which do not support old data for read during write on same port

module mixed_width_true_dual_port_ram_new_rw
	#(parameter int
		DATA_WIDTH1 = 8,
		ADDRESS_WIDTH1 = 10,
		ADDRESS_WIDTH2 = 8)
(
		input [ADDRESS_WIDTH1-1:0] addr1,
		input [ADDRESS_WIDTH2-1:0] addr2,
		input [DATA_WIDTH1      -1:0] data_in1, 
		input [DATA_WIDTH1*(1<<(ADDRESS_WIDTH1 - ADDRESS_WIDTH2))-1:0] data_in2, 
		input we1, we2, clk,
		output reg [DATA_WIDTH1-1      :0] data_out1,
		output reg [DATA_WIDTH1*(1<<(ADDRESS_WIDTH1 - ADDRESS_WIDTH2))-1:0] data_out2);
    
	localparam RATIO = 1 << (ADDRESS_WIDTH1 - ADDRESS_WIDTH2); // valid values are 2,4,8... family dependent
	localparam DATA_WIDTH2 = DATA_WIDTH1 * RATIO;
	localparam RAM_DEPTH = 1 << ADDRESS_WIDTH2;

	// Use a multi-dimensional packed array to model the different read/ram width
	reg [RATIO-1:0] [DATA_WIDTH1-1:0] ram[0:RAM_DEPTH-1];
    
	reg [DATA_WIDTH1-1:0] data_reg1;
	reg [DATA_WIDTH2-1:0] data_reg2;

	// Port A
	always@(posedge clk)
	begin
		if(we1) 
		begin 
			ram[addr1 / RATIO][addr1 % RATIO] <= data_in1;
			data_reg1 <= data_in1;
		end
		else
		begin 
			data_reg1 <= ram[addr1 / RATIO][addr1 % RATIO];
		end
	end
	assign data_out1 = data_reg1;

	// port B
	always@(posedge clk)
	begin
		if(we2)
		begin
			ram[addr2] <= data_in2;
			data_reg2 <= data_in2;
		end
		else
		begin
			data_reg2 <= ram[addr2];
		end
	end
    
	assign data_out2 = data_reg2;
endmodule : mixed_width_true_dual_port_ram_new_rw
