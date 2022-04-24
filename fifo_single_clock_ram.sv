//------------------------------------------------------------------------------
// fifo_single_clock_ram.sv
// published as part of https://github.com/pConst/basic_verilog
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
//  - simultaneous read and write operations supported BUT:
//        only read will happen if simultaneous rw from full fifo
//        only write will happen if simultaneous rw from empty fifo
//        Always honor empty and full flags!
//  - provides fifo contents initialization (!)
//  - CAUTION! block RAMs do NOT support fifo contents REinitialization after reset


/* --- INSTANTIATION TEMPLATE BEGIN ---

fifo_single_clock_ram #(
  .DEPTH( 8 ),
  .DATA_W( 32 ),

  // optional initialization
  .INIT_FILE( "fifo_single_clock_ram_init.mem" ),
  .INIT_CNT( 10 )
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

  FWFT_MODE = "TRUE",        // "TRUE"  - first word fall-trrough" mode
                             // "FALSE" - normal fifo mode
  DEPTH = 8,                 // max elements count == DEPTH, DEPTH MUST be power of 2
  DEPTH_W = clogb2(DEPTH)+1, // elements counter width, extra bit to store
                             // "fifo full" state, see cnt[] variable comments

  DATA_W = 32,               // data field width

  RAM_STYLE = "",            // "block","register","M10K","logic",...

  // optional initialization
  INIT_FILE = "",            // .HEX or .MEM file to initialize fifo contents
  INIT_CNT = '0              // sets desired initial cnt[]
)(

  input clk,
  input nrst,                // inverted reset

  // input port
  input w_req,
  input [DATA_W-1:0] w_data,

  // output port
  input r_req,
  output [DATA_W-1:0] r_data,

  // helper ports
  output logic [DEPTH_W-1:0] cnt = INIT_CNT[DEPTH_W-1:0],
  output logic empty,
  output logic full,

  output logic fail
);


  // read and write pointers
  logic [DEPTH_W-1:0] w_ptr = INIT_CNT[DEPTH_W-1:0];
  logic [DEPTH_W-1:0] r_ptr = '0;

  // filtered requests
  logic w_req_f;
  assign w_req_f = w_req && ~full;

  logic r_req_f;
  assign r_req_f = r_req && ~empty;


  true_dual_port_write_first_2_clock_ram #(
    .RAM_WIDTH( DATA_W ),
    .RAM_DEPTH( DEPTH ),
    .RAM_STYLE( RAM_STYLE ),  // "block","register","M10K","logic",...
    .INIT_FILE( INIT_FILE )
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


  always_ff @(posedge clk) begin
    if ( ~nrst ) begin
      w_ptr[DEPTH_W-1:0] <= '0;
      r_ptr[DEPTH_W-1:0] <= '0;

      cnt[DEPTH_W-1:0] <= '0;
    end else begin
      unique case ({w_req, r_req})
        2'b00: ; // nothing

        2'b01: begin  // reading out
          if( ~empty ) begin
            r_ptr[DEPTH_W-1:0] <= inc_ptr(r_ptr[DEPTH_W-1:0]);
            cnt[DEPTH_W-1:0] <= cnt[DEPTH_W-1:0] - 1'b1;
          end
        end

        2'b10: begin  // writing in
          if( ~full ) begin
            w_ptr[DEPTH_W-1:0] <= inc_ptr(w_ptr[DEPTH_W-1:0]);
            cnt[DEPTH_W-1:0] <= cnt[DEPTH_W-1:0] + 1'b1;
          end
        end

        2'b11: begin  // simultaneously reading and writing
          if( empty ) begin
            w_ptr[DEPTH_W-1:0] <= inc_ptr(w_ptr[DEPTH_W-1:0]);
            cnt[DEPTH_W-1:0] <= cnt[DEPTH_W-1:0] + 1'b1;
          end else if( full ) begin
            r_ptr[DEPTH_W-1:0] <= inc_ptr(r_ptr[DEPTH_W-1:0]);
            cnt[DEPTH_W-1:0] <= cnt[DEPTH_W-1:0] - 1'b1;
          end else begin
            w_ptr[DEPTH_W-1:0] <= inc_ptr(w_ptr[DEPTH_W-1:0]);
            r_ptr[DEPTH_W-1:0] <= inc_ptr(r_ptr[DEPTH_W-1:0]);
            //cnt[DEPTH_W-1:0] <=  // data counter does not change here
          end
        end
      endcase
    end
  end

  always_comb begin
    empty = ( cnt[DEPTH_W-1:0] == '0 );
    full =  ( cnt[DEPTH_W-1:0] == DEPTH );

    fail = ( empty && r_req ) ||
           ( full && w_req );
  end

  function [DEPTH_W-1:0] inc_ptr (
    input [DEPTH_W-1:0] ptr
  );
    if( ptr[DEPTH_W-1:0] == DEPTH-1 ) begin
      inc_ptr[DEPTH_W-1:0] = '0;
    end else begin
      inc_ptr[DEPTH_W-1:0] = ptr[DEPTH_W-1:0] + 1'b1;
    end
  endfunction

  `include "clogb2.svh"

endmodule
