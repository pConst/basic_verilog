//------------------------------------------------------------------------------
// fifo_single_clock_reg_v2.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Single-clock FIFO buffer implementation, also known as "queue"
//
//  Features:
//  - single clock operation
//  - configurable depth and data width
//  - one write- and one read- port in "FWFT" or "normal" mode
//  - protected against overflow and underflow
//  - simultaneous read and write operations supported if not full and not empty
//  - only read operation is performed when (full && r_req && w_req)
//  - only write operation is performed when (empty && r_req && w_req)
//
//  See also "lifo.sv" module for similar LIFO buffer implementation


/* --- INSTANTIATION TEMPLATE BEGIN ---

fifo_single_clock_reg_v2 #(
  .FWFT_MODE( "TRUE" ),
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

module fifo_single_clock_reg_v2 #( parameter

  FWFT_MODE = "TRUE",             // "TRUE"  - first word fall-trrough" mode
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
  output logic [DATA_W-1:0] r_data,

  // helper ports
  output logic [DEPTH_W-1:0] cnt = '0,
  output logic empty,
  output logic full,

  output logic fail
);

// fifo data, extra element to keep pointer positions always valid,
//  even when fifo is empty or full
logic [DEPTH-1:0][DATA_W-1:0] data = '0;

// read and write pointers
logic [DEPTH_W-1:0] w_ptr = '0;
logic [DEPTH_W-1:0] r_ptr = '0;

// data output buffer for normal fifo mode
logic [DATA_W-1:0] data_buf = '0;


// filtered requests
logic w_req_f;
assign w_req_f = w_req && ~full;

logic r_req_f;
assign r_req_f = r_req && ~empty;


function [DEPTH_W-1:0] inc_ptr (
  input [DEPTH_W-1:0] ptr
);

  if( ptr[DEPTH_W-1:0] == DEPTH-1 ) begin
    inc_ptr[DEPTH_W-1:0] = '0;
  end else begin
    inc_ptr[DEPTH_W-1:0] = ptr[DEPTH_W-1:0] + 1'b1;
  end
endfunction


integer i;
always_ff @(posedge clk) begin
  if ( ~nrst ) begin
    data <= '0;
    cnt[DEPTH_W-1:0] <= '0;

    w_ptr[DEPTH_W-1:0] <= '0;
    r_ptr[DEPTH_W-1:0] <= '0;

    data_buf[DATA_W-1:0] <= '0;
  end else begin
    unique case ({w_req_f, r_req_f})
      2'b00: ; // nothing

      2'b01: begin  // reading out
        if( ~empty ) begin
          r_ptr[DEPTH_W-1:0] <= inc_ptr(r_ptr[DEPTH_W-1:0]);
        end
        cnt[DEPTH_W-1:0] <= cnt[DEPTH_W-1:0] - 1'b1;
      end

      2'b10: begin  // writing in
        if( ~full ) begin
          w_ptr[DEPTH_W-1:0] <= inc_ptr(w_ptr[DEPTH_W-1:0]);
        end
        data[w_ptr[DEPTH_W-1:0]] <= w_data[DATA_W-1:0];
        cnt[DEPTH_W-1:0] <= cnt[DEPTH_W-1:0] + 1'b1;
      end

      2'b11: begin  // simultaneously reading and writing
        if( ~empty ) begin
          r_ptr[DEPTH_W-1:0] <= inc_ptr(r_ptr[DEPTH_W-1:0]);
        end
        if( ~full ) begin
          w_ptr[DEPTH_W-1:0] <= inc_ptr(w_ptr[DEPTH_W-1:0]);
        end
        data[w_ptr[DEPTH_W-1:0]] <= w_data[DATA_W-1:0];
        // data counter does not change here
      end
    endcase

    // data buffer works only for normal fifo mode
    if( r_req_f ) begin
      data_buf[DATA_W-1:0] <= data[r_ptr[DEPTH_W-1:0]];
    end

  end
end


always_comb begin
  empty = ( cnt[DEPTH_W-1:0] == '0 );
  full =  ( cnt[DEPTH_W-1:0] == DEPTH );

  if( FWFT_MODE == "TRUE" ) begin
    if (~empty) begin
      r_data[DATA_W-1:0] = data[r_ptr[DEPTH_W-1:0]];   // first-word fall-through mode
    end else begin
      r_data[DATA_W-1:0] = '0;
    end
  end else begin
    r_data[DATA_W-1:0] = data_buf[DATA_W-1:0];   // normal mode
  end

  fail = ( empty && r_req ) ||
         ( full && w_req );
end

endmodule
