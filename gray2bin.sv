//------------------------------------------------------------------------------
// gray2bin.sv
// published as part of https://github.com/pConst/basic_verilog
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
   output logic [WIDTH-1:0] bin_out
);

   always_comb begin
      bin_out[WIDTH-1:0] = '0;

      for( integer i=0; i<WIDTH; i++ ) begin
         bin_out[WIDTH-1:0] ^= gray_in[WIDTH-1:0] >> i;
      end
   end

endmodule

