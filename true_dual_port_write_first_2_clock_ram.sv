//------------------------------------------------------------------------------
// true_dual_port_write_first_2_clock_ram.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  This is originally a Vivado template for block RAM with some minor edits
//  Also tested for Quartus IDE to automatically infer block memories
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

true_dual_port_write_first_2_clock_ram #(
  .RAM_WIDTH( DATA_W ),
  .RAM_DEPTH( DEPTH ),
  .INIT_FILE( "" )
) bram (
  .clka( w_clk ),
  .addra( w_ptr[DEPTH_W-1:0] ),
  .ena( w_req ),
  .wea( 1'b1 ),
  .dina( w_data[DATA_W-1:0] ),
  .douta(  ),

  .clkb( r_clk ),
  .addrb( r_ptr[DEPTH_W-1:0] ),
  .enb( r_req ),
  .web( 1'b0 ),
  .dinb( '0 ),
  .doutb( r_data[DATA_W-1:0] )
);

--- INSTANTIATION TEMPLATE END ---*/


module true_dual_port_write_first_2_clock_ram #( parameter
  RAM_WIDTH = 16,
  RAM_DEPTH = 8,
  INIT_FILE = ""
)(
  input clka,
  input [clogb2(RAM_DEPTH-1)-1:0] addra,
  input ena,
  input wea,
  input [RAM_WIDTH-1:0] dina,
  output [RAM_WIDTH-1:0] douta,

  input clkb,
  input [clogb2(RAM_DEPTH-1)-1:0] addrb,
  input enb,
  input web,
  input [RAM_WIDTH-1:0] dinb,
  output [RAM_WIDTH-1:0] doutb
);

  logic [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
  logic [RAM_WIDTH-1:0] ram_data_a = {RAM_WIDTH{1'b0}};
  logic [RAM_WIDTH-1:0] ram_data_b = {RAM_WIDTH{1'b0}};

  // either initializes the memory values to a specified file or to all zeros
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial begin
        for (ram_index=0; ram_index<RAM_DEPTH; ram_index=ram_index+1 ) begin
          BRAM[ram_index] = {RAM_WIDTH{1'b0}};
        end
      end
    end
  endgenerate

  always @(posedge clka) begin
    if (ena) begin
      if (wea) begin
        BRAM[addra] <= dina;
        ram_data_a <= dina;
      end else begin
        ram_data_a <= BRAM[addra];
      end
    end
  end

  always @(posedge clkb) begin
    if (enb) begin
      if (web) begin
        BRAM[addrb] <= dinb;
        ram_data_b <= dinb;
      end else begin
        ram_data_b <= BRAM[addrb];
      end
    end
  end

  // no output register
  assign douta = ram_data_a;
  assign doutb = ram_data_b;

  // calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction

endmodule

