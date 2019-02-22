//------------------------------------------------------------------------------
// bin2pos.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Converts binary coded value to positional code (one-hot in specified position)
//  Thus 2'd0 becomes 4'b0001 and 8'd5 becomes 256'b100000
//  Module is being synthesized into combinational logic only
//  See also pos2bin.sv module for inverse transformation


/* --- INSTANTIATION TEMPLATE BEGIN ---

bin2pos #(
  .BIN_WIDTH( 8 )
) BP1 (
  .bin(  ),
  .pos(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module bin2pos #( parameter
  BIN_WIDTH = 8,
  POS_WIDTH = 2**BIN_WIDTH
)(
  input [(BIN_WIDTH-1):0] bin,
  output logic [(POS_WIDTH-1):0] pos
);


always_comb begin
  pos = 0;
  pos[bin] = 1'b1;
end

endmodule
