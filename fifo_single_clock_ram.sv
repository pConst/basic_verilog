//------------------------------------------------------------------------------
// fifo_single_clock_ram.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Single-clock FIFO buffer implementation, also known as "queue"
//
//  This fifo variant should synthesize into block RAM seamlessly, both for
//    Altera and for Xilinx chips. Simulation is also consistent.
//  Use this fifo when you need cross-vendor and sim/synth compatibility.
//
//  Features:
//  - single clock operation
//  - configurable depth and data width
//  - only "normal" mode is supported here, no FWFT mode
//  - protected against overflow and underflow
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

fifo_single_clock_ram #(
  .DEPTH( 8 ),
  .DATA_W( 32 )
) FF1 (
  .clk( clk ),
  .nrst( 1'b1 ),

  .w_req(  ),
  .w_data(  ),

  .r_req(  ),
  .r_data(  ),

  .cnt(  ),
  .empty(  ),
  .full(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module fifo_single_clock_ram #( parameter

  //FWFT_MODE = "TRUE",           // "TRUE"  - first word fall-trrough" mode
                                  // "FALSE" - normal fifo mode

  DEPTH = 8,                      // max elements count == DEPTH, DEPTH MUST be power of 2
  DEPTH_W = $clog2(DEPTH)+1,      // elements counter width, extra bit to store
                                  // "fifo full" state, see cnt[] variable comments

  DATA_W = 32                     // data field width
)(

  input clk,
  input nrst,                      // inverted reset

  // input port
  input w_req,
  input [DATA_W-1:0] w_data,

  // output port
  input r_req,
  output [DATA_W-1:0] r_data,

  // helper ports
  output logic [DEPTH_W-1:0] cnt = '0,
  output logic empty,
  output logic full,

  output logic fail
);


// read and write pointers
logic [DEPTH_W-1:0] w_ptr = '0;
logic [DEPTH_W-1:0] r_ptr = '0;

// filtered requests
logic w_req_f;
assign w_req_f = w_req && ~full;

logic r_req_f;
assign r_req_f = r_req && ~empty;


true_dual_port_write_first_2_clock_ram #(
  .RAM_WIDTH( DATA_W ),
  .RAM_DEPTH( DEPTH ),
  .INIT_FILE( "" )
) data_ram (
  .clka( clk ),
  .addra( w_ptr[DEPTH_W-1:0] ),
  .ena( w_req_f ),
  .wea( 1'b1 ),
  .dina( w_data[DATA_W-1:0] ),
  .douta(  ),

  .clkb( clk ),
  .addrb( r_ptr[DEPTH_W-1:0] ),
  .enb( r_req_f ),
  .web( 1'b0 ),
  .dinb( '0 ),
  .doutb( r_data[DATA_W-1:0] )
);


function [DEPTH_W-1:0] inc_ptr (
  input [DEPTH_W-1:0] ptr
);

  if( ptr[DEPTH_W-1:0] == DEPTH-1 ) begin
    inc_ptr[DEPTH_W-1:0] = '0;
  end else begin
    inc_ptr[DEPTH_W-1:0] = ptr[DEPTH_W-1:0] + 1'b1;
  end
endfunction


always_ff @(posedge clk) begin
  if ( ~nrst ) begin
    w_ptr[DEPTH_W-1:0] <= '0;
    r_ptr[DEPTH_W-1:0] <= '0;

    cnt[DEPTH_W-1:0] <= '0;
  end else begin

    if( w_req_f ) begin
      w_ptr[DEPTH_W-1:0] <= inc_ptr(w_ptr[DEPTH_W-1:0]);
    end

    if( r_req_f ) begin
      r_ptr[DEPTH_W-1:0] <= inc_ptr(r_ptr[DEPTH_W-1:0]);
    end

    if( w_req_f && ~r_req_f ) begin
      cnt[DEPTH_W-1:0] <= cnt[DEPTH_W-1:0] + 1'b1;
    end else if( ~w_req_f && r_req_f ) begin
      cnt[DEPTH_W-1:0] <= cnt[DEPTH_W-1:0] - 1'b1;
    end

  end
end

always_comb begin
  empty = ( cnt[DEPTH_W-1:0] == '0 );
  full =  ( cnt[DEPTH_W-1:0] == DEPTH );

  fail = ( empty && r_req ) ||
         ( full && w_req );
end

endmodule



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

  reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] ram_data_a = {RAM_WIDTH{1'b0}};
  reg [RAM_WIDTH-1:0] ram_data_b = {RAM_WIDTH{1'b0}};

  // either initializes the memory values to a specified file or to all zeros
  //   to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          BRAM[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge clka)
    if (ena)
      if (wea) begin
        BRAM[addra] <= dina;
        ram_data_a <= dina;
      end else
        ram_data_a <= BRAM[addra];

  always @(posedge clkb)
    if (enb)
      if (web) begin
        BRAM[addrb] <= dinb;
        ram_data_b <= dinb;
      end else
        ram_data_b <= BRAM[addrb];

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

