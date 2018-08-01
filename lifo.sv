//------------------------------------------------------------------------------
// lifo.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Simple single-clock LIFO buffer implementation, also known as "stack"
//  Features one write- and one read- port in FWFT mode
//  See also "fifo.sv" module for similar FIFO buffer implementation


/* --- INSTANTIATION TEMPLATE BEGIN ---

lifo #(
  .DEPTH( 8 ),
  .DATA_W( 32 )
) FF1 (
  .clk( clk ),
  .rst( 1'b0 ),

  .w_req(  ),
  .w_data(  ),

  .r_req(  ),
  .r_data(  ),

  .cnt(  ),
  .empty(  ),
  .full(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module lifo #( parameter

  DEPTH = 4,                      // max elements count == DEPTH, DEPTH MUST be power of 2
  DEPTH_W = $clog2(DEPTH)+1,      // elements counter width, extra bit to store
                                  // "fifo full" state, see cnt[] variable comments

  DATA_W = 32                     // data field width
)(

  input clk,
  input rst,                      // non-inverted reset

  // input port
  input w_req,
  input [DATA_W-1:0] w_data,

  // output port
  input r_req,
  output logic [DATA_W-1:0] r_data,

  // helper ports
  output logic [DATA_W-1:0] cnt = 0,
  output logic empty,
  output logic full,

  output logic fail
);

// lifo data
logic [DEPTH-1:0][DATA_W-1:0] data = 0;

// cnt[] vector always holds lifo elements count
// data[cnt[]] points to the first empty lifo slot
// when lifo is full data[cnt[]] points "outside" of data[]

// please take attention to the case when cnt[]==0 && r_req==1'b1 && w_req==1'b1
// this case makes no read/write to the lifo and should be handled externally

always_ff @(posedge clk) begin
  if ( rst ) begin
    data <= 0;
    cnt <= 0;
  end else begin
    case ({w_req, r_req})
      2'b01  : begin  // reading out
        if ( cnt[DATA_W-1:0] > 1'b0 ) begin
          cnt[DATA_W-1:0] <= cnt[DATA_W-1:0] - 1'b1;
        end
      end
      2'b10  : begin  // writing in
        if ( ~full ) begin
          data[cnt[DATA_W-1:0]] <= w_data;
          cnt[DATA_W-1:0] <= cnt[DATA_W-1:0] + 1'b1;
        end
      end
      2'b11  : begin  // simultaneously reading and writing
        if ( cnt[DATA_W-1:0] > 1'b0 ) begin
          data[cnt[DATA_W-1:0]-1] <= w_data;
        end
        // cnt[DATA_W-1:0] <= cnt[DATA_W-1:0]; // data counter does not change
      end
      default: ;
    endcase
  end
end

always_comb begin
  empty = ( cnt[DATA_W-1:0] == 0 );
  full = ( cnt[DATA_W-1:0] == DEPTH );

  if (~empty) begin
    r_data[DATA_W-1:0] = data[cnt[DATA_W-1:0]]; // first-word fall-through mode
  end else begin
    r_data[DATA_W-1:0] = 0;
  end

  fail = ( empty && r_req ) ||
         ( full && w_req );
end

endmodule
