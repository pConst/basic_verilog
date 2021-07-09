//------------------------------------------------------------------------------
// soft_latch.sv
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
  .nrst( 1'b1 ),
  .latch(  ),
  .in(  ),
  .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module soft_latch #( parameter
  WIDTH = 1                         // data width
)(
  input clk,                        // clock
  input nrst,                       // inverted reset

  input latch,                      // latch strobe
  input [WIDTH-1:0] in,             // data in
  output logic [WIDTH-1:0] out      // data out
);

logic [WIDTH-1:0] in_buf = '0;

// buffering input data
always_ff @(posedge clk) begin
  if( ~nrst ) begin
    in_buf[WIDTH-1:0] <= '0;
  end else if( latch ) begin
    in_buf[WIDTH-1:0] <= in[WIDTH-1:0];
  end
end

// mixing combinational and buffered data to the output
always_comb begin
  if( ~nrst ) begin
    out[WIDTH-1:0] <= '0;
  end else if( latch ) begin
    out[WIDTH-1:0] <= in[WIDTH-1:0];
  end else begin
    out[WIDTH-1:0] <= in_buf[WIDTH-1:0];
  end


end

endmodule

