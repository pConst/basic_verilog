//------------------------------------------------------------------------------
// gray2bin.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Binary to gray code converter
//  Combinational design


/* --- INSTANTIATION TEMPLATE BEGIN ---

gray2bin #(
  .WIDTH( 32 )
) GB1 (
  .gray_in(  ),
  .bin_out(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module gray2bin #( parameter
   WIDTH = 32
)(
   input [WIDTH-1:0] gray_in,
   output [WIDTH-1:0] bin_out
);

genvar i;
generate
   for( i=0; i<WIDTH; i++ ) begin
      assign bin_out[i] = ^gray_in[WIDTH-1:i];
   end
endgenerate

endmodule

