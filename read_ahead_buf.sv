//------------------------------------------------------------------------------
// fwft_read_ahead_buf.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Read ahead buffer for FWFT fifo
//
// The buffer substitutes fifo read port and performs fifo data update at the
//   same clock cycle as r_req, combinationally, for a one cycle earlier than
//   it is expected from standard FWFT fifo
//
// Featires:
//   - effectively increases fifo depth by one word
//   - adds one cycle lateny for empty flag deassertion
//   - does not touch fifo write port and full flag operation logic
//   - hides all combinatorial tinkering inside
//   - allows controlling and analizing fifo read signals from
//                             a single always_ff block, like this:
//
//             always_ff @(posedge clk) begin
//
//                 // read control logic
//                 if( ~empty ) begin        // masking rd_req in always_ff
//                   r_req <= 1'b1;
//                 end else begin
//                   r_req <= 1'b0;
//                 end
//
//                 // getting input data
//                 if( r_req ) begin
//                   new_data[] <= r_data[]; // getting data in always_ff
//                 end
//
//               end
//             end
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

read_ahead_buf #(
  .DATA_W( 32 )
) RB1 (
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

// synopsys translate_off
`define SIMULATION yes
// synopsys translate_on

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


  logic fifo_empty_fall;
  edge_detect fifo_empty_ed (
    .clk( clk ),
    .anrst( anrst ),
    .in( fifo_empty ),
    .rising(  ),
    .falling( fifo_empty_fall ),
    .both(  )
  );

  logic fantom_read;
  logic normal_read;

  logic buf_empty = 1'b1;
  always_ff @(posedge clk or negedge anrst) begin
    if( ~anrst ) begin
      buf_empty = 1'b1;
    end else begin
      if( fantom_read ) begin
        buf_empty <= 1'b0;
      end else if( fifo_empty && r_req ) begin
        buf_empty = 1'b1;
      end
    end
  end

  assign fantom_read = fifo_empty_fall && buf_empty;

  assign normal_read = r_req && ~fifo_empty;

  assign empty = buf_empty ||            // empty falls only after fantom read
                 (r_req && fifo_empty);  // early empty assertion

  assign fifo_r_req = anrst &&
                      (fantom_read || normal_read);

  // prepare combinational signal for soft_latch
  logic latch_req;
  logic [DATA_W-1:0] r_data_latch;
  always_comb begin
    latch_req = ( fantom_read || normal_read ) ||
                ( fifo_empty && r_req );        // buffer depletion

    if( latch_req ) begin
      r_data_latch[DATA_W-1:0] = fifo_r_data[DATA_W-1:0];
    end else begin
      r_data_latch[DATA_W-1:0] = '0;
    end
  end

  soft_latch #(
    .WIDTH( DATA_W )
  ) r_data_latch_b (
    .clk( clk ),
    .anrst( anrst ),
    .latch( latch_req ),
    .in( r_data_latch[DATA_W-1:0] ),
    .out( r_data[DATA_W-1:0] )
  );

endmodule
