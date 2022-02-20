//------------------------------------------------------------------------------
// pos2bin.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Converts positional (one-hot) value to binary representation
//  Thus 4'b0001 becomes 2'd0 and 256'b10100000 becomes 8'd5
//  Module is being synthesized into combinational logic only
//  See also bin2pos.sv module for inverse transformation


/* --- INSTANTIATION TEMPLATE BEGIN ---

pos2bin #(
  .BIN_WIDTH( 8 )
) PB1 (
  .pos(  ),
  .bin(  ),

  .err_no_hot(  ),
  .err_multi_hot(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module pos2bin #( parameter
  BIN_WIDTH = 8,
  POS_WIDTH = 2**BIN_WIDTH
)(
  input [(POS_WIDTH-1):0] pos,
  output logic [(BIN_WIDTH-1):0] bin,

// error flags
  output logic err_no_hot,    // no active bits in pos[] vector
  output logic err_multi_hot  // multiple active bits in pos[] vector
                              // only least-sensitive active bit affects the output
);


assign err_no_hot = (pos[(POS_WIDTH-1):0] == 0);

integer i;

logic found_hot;
always_comb begin
  err_multi_hot = 0;
  bin[(BIN_WIDTH-1):0] = 0;
  found_hot = 0;
  for (i=0; i<POS_WIDTH; i++) begin

    if ( ~found_hot && pos[i] ) begin
      bin[(BIN_WIDTH-1):0] = i[(BIN_WIDTH-1):0];
    end

    if ( found_hot && pos[i] ) begin
      err_multi_hot=1'b1;
    end

    if ( pos[i] ) begin
      found_hot = 1'b1;
    end

  end // for
end // always_comb

endmodule
