//------------------------------------------------------------------------------
// true_single_port_write_first_ram.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  This is single port RAM/ROM module
//  Also tested for Quartus IDE to automatically infer block memories
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

true_single_port_write_first_ram #(
  .RAM_WIDTH( DATA_W ),
  .RAM_DEPTH( DEPTH ),
  .RAM_STYLE( "block" ),  // "block","register","M10K","logic",...
  .INIT_FILE( "init.mem" )
) SR1 (
  .clka( w_clk ),
  .addra( w_ptr[DEPTH_W-1:0] ),
  .ena( w_req ),
  .wea( 1'b1 ),
  .dina( w_data[DATA_W-1:0] ),
  .douta(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module true_single_port_write_first_ram #( parameter
  RAM_WIDTH = 16,
  RAM_DEPTH = 8,

  // optional initialization parameters
  RAM_STYLE = "block",
  INIT_FILE = ""
)(
  input clka,
  input [clogb2(RAM_DEPTH-1)-1:0] addra,
  input ena,
  input wea,
  input [RAM_WIDTH-1:0] dina,
  output [RAM_WIDTH-1:0] douta
);

  // Xilinx:
  // ram_style = "{ auto | block | distributed | register | ultra }"
  // "ram_style" is equivalent to "ramstyle" in Vivado

  // Altera:
  // ramstyle = "{ logic | M9K | MLAB }" and other variants

  // ONLY FOR QUARTUS IDE
  // You can provide initialization in convinient .mif format
  //(* ram_init_file = INIT_FILE *) logic [RAM_WIDTH-1:0] data_mem [RAM_DEPTH-1:0];

  (* ramstyle = RAM_STYLE *) logic [RAM_WIDTH-1:0] data_mem [RAM_DEPTH-1:0];


  logic [RAM_WIDTH-1:0] ram_data_a = {RAM_WIDTH{1'b0}};

  // either initializes the memory values to a specified file or to all zeros
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, data_mem, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer i;
      initial begin
        for (i=0; i<RAM_DEPTH; i=i+1 ) begin
          data_mem[i] = {RAM_WIDTH{1'b0}};
        end
      end
    end
  endgenerate

  always @(posedge clka) begin
    if (ena) begin
      if (wea) begin
        data_mem[addra] <= dina;
        ram_data_a <= dina;
      end else begin
        ram_data_a <= data_mem[addra];
      end
    end
  end

  // no output register
  assign douta = ram_data_a;

  `include "clogb2.svh"

endmodule

