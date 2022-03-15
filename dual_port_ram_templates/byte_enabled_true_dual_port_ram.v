// Quartus Prime SystemVerilog Template
//
// True Dual-Port RAM with different read/write addresses and single read/write clock
// and with a control for writing single bytes into the memory word; byte enable

// Read during write produces old data on ports A and B and old data on mixed ports
// For device families that do not support this mode (e.g. Stratix V) the ram is not inferred

module byte_enabled_true_dual_port_ram
  #(
    parameter int
    BYTE_WIDTH = 8,
    ADDRESS_WIDTH = 6,
    BYTES = 4,
    DATA_WIDTH_R = BYTE_WIDTH * BYTES
)
(
  input [ADDRESS_WIDTH-1:0] addr1,
  input [ADDRESS_WIDTH-1:0] addr2,
  input [BYTES-1:0] be1,
  input [BYTES-1:0] be2,
  input [BYTE_WIDTH-1:0] data_in1, 
  input [BYTE_WIDTH-1:0] data_in2, 
  input we1, we2, clk,
  output [DATA_WIDTH_R-1:0] data_out1,
  output [DATA_WIDTH_R-1:0] data_out2);
  localparam RAM_DEPTH = 1 << ADDRESS_WIDTH;

  // model the RAM with two dimensional packed array
  logic [BYTES-1:0][BYTE_WIDTH-1:0] ram[0:RAM_DEPTH-1];

  reg [DATA_WIDTH_R-1:0] data_reg1;
  reg [DATA_WIDTH_R-1:0] data_reg2;

  // port A
  always@(posedge clk)
  begin
    if(we1) begin
    // edit this code if using other than four bytes per word
      if(be1[0]) ram[addr1][0] <= data_in1;
      if(be1[1]) ram[addr1][1] <= data_in1;
      if(be1[2]) ram[addr1][2] <= data_in1;
      if(be1[3]) ram[addr1][3] <= data_in1;
    end
  data_reg1 <= ram[addr1];
  end

  assign data_out1 = data_reg1;
   
  // port B
  always@(posedge clk)
  begin
    if(we2) begin
    // edit this code if using other than four bytes per word
      if(be2[0]) ram[addr2][0] <= data_in2;
      if(be2[1]) ram[addr2][1] <= data_in2;
      if(be2[2]) ram[addr2][2] <= data_in2;
      if(be2[3]) ram[addr2][3] <= data_in2;
    end
  data_reg2 <= ram[addr2];
  end

  assign data_out2 = data_reg2;

endmodule : byte_enabled_true_dual_port_ram
