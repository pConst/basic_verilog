//------------------------------------------------------------------------------
// soft_latch.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  "Software" latch, aka combinational data hold circuit
//
//  Features combinational data latching and combinational resetting
//  Zero latency for setting and resetting data
//  No hardware latches inferred by means of this circuit
//

//        |   |   +---+   |   |   |   |   |   |      latch, this module input
//        |   |   |   |   |   |   |   |   |   |
//   +------------+   +--------------------------------+
//        |   |   |   |   |   |   |   |   |   |
//   +----------------------------+   +----------------+
//        |   |   |   |   |   |   |   |   |   |
//        |   |   |   |   |   |   +---+   |   |      nrst, this module input
//        |   |   |   |   |   |   |   |   |   |
//   +-------------------------------------------------+
//        }{A }{B }{C }{D }{E }{F }{G }{H }{J }{     in, this module data input
//   +-------------------------------------------------+
//        |   |   |   |   |   |   |   |   |   |
//        |   |   |   +---------------+   |   |   standard unblocking assignment
//        |   |   |   { C | C | C | C }   |   |
//   +----------------+   |   |   |   +----------------+
//        |   |   |   |   |   |   |   |   |   |
//        |   |   +---------------+   |   |   |      out, this module data output
//        |   |   { C | C | C | C }   |   |   |
//   +------------+   |   |   |   +--------------------+
//        |   |   |   |   |   |   |   |   |   |
//        |   |   |   |   |   |   |   |   |   |


/* --- INSTANTIATION TEMPLATE BEGIN ---

soft_latch #(
  .WIDTH( 16 )
) SL1 (
  .clk( clk ),
  .anrst( 1'b1 ),
  .latch(  ),
  .in(  ),
  .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module soft_latch #( parameter
  bit [7:0] WIDTH = 1               // data width
)(
  input clk,                        // clock
  input anrst,                      // inverted reset

  input latch,                      // latch strobe
  input [WIDTH-1:0] in,             // data in
  output logic [WIDTH-1:0] out      // data out
);

logic [WIDTH-1:0] in_buf = '0;

// buffering input data
always_ff @(posedge clk or negedge anrst) begin
  if( ~anrst ) begin
    in_buf[WIDTH-1:0] <= '0;
  end else if( latch ) begin
    in_buf[WIDTH-1:0] <= in[WIDTH-1:0];
  end
end

// mixing combinational and buffered data to the output
always_comb begin
  if( ~anrst ) begin
    out[WIDTH-1:0] <= '0;
  end else if( latch ) begin
    out[WIDTH-1:0] <= in[WIDTH-1:0];
  end else begin
    out[WIDTH-1:0] <= in_buf[WIDTH-1:0];
  end
end

endmodule

