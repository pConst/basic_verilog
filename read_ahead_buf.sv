//------------------------------------------------------------------------------
// fwft_read_ahead_buf.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Read ahead buffer
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

read_ahead_buf #(
  .DATA_W( 32 )
)(
  .clk(  ),
  .anrst(  ),

  // input fifo interface
  .fifo_r_req(  ),
  .fifo_r_data(  ),
  .fifo_empty(  ),

  // output fifo interface
  .r_req(  ),
  .r_data(  ),
  .empty(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module read_ahead_buf #( parameter
  DATA_W = 32
)(
  input clk,               // clock
  input anrst,             // inverse reset

  // input fifo interface
  output fifo_r_req,
  input [DATA_W-1:0] fifo_r_data,
  input fifo_empty,

  // output fifo interface
  input r_req,
  output logic [DATA_W-1:0] r_data,
  output logic empty
);

  // buffer initialization flags
  logic buf_empty = 1'b1;

  // buffer fill request
  logic buf_fill_req;
  assign buf_fill_req = ~fifo_empty &&
                        buf_empty &&
                        ~buf_fill_req_d1;

  // buffer fill and re-fill cycle
  logic buf_fill_req_d1 = 1'b0;
  always_ff @(posedge clk or negedge anrst) begin
    if( ~anrst ) begin
      buf_fill_req_d1 <= 1'b0;
    end else begin
      buf_fill_req_d1 <= buf_fill_req;
    end
  end

  // filtering read requests
  logic r_req_filt;
  assign r_req_filt = anrst &&
                      ~fifo_empty &&
                      ~buf_empty &&
                      ~buf_fill_req && r_req;

  logic r_req_rise;
  logic r_req_fall;
  edge_detect r_req_ed (
    .clk( clk ),
    .nrst( anrst ),
    .in( r_req_filt ),
    .rising( r_req_rise ),
    .falling( r_req_fall ),
    .both(  )
  );

  assign fifo_r_req = r_req_filt;
  assign empty = anrst && fifo_empty && buf_empty;

  // buffer itself
  logic [DATA_W-1:0] r_data_buf = '0;
  always_ff @(posedge clk or negedge anrst) begin
    if( ~anrst ) begin
      buf_empty = 1'b1;
    end else begin

      if( buf_fill_req_d1 ) begin
        r_data_buf[DATA_W-1:0] <= fifo_r_data[DATA_W-1:0];
        buf_empty = 1'b0;
      end else if( ~r_req_filt && r_req_fall )  begin
        r_data_buf[DATA_W-1:0] <= fifo_r_data[DATA_W-1:0];
      end

    end
  end

  soft_latch #(
    .WIDTH( DATA_W )
  ) r_data_latch (
    .clk( clk ),
    .anrst( anrst ),
    .latch( r_req_filt ),
    .in( (r_req_rise)?(r_data_buf[DATA_W-1:0]):(fifo_r_data[DATA_W-1:0]) ),
    .out( r_data[DATA_W-1:0] )
  );

endmodule
