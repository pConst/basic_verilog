//------------------------------------------------------------------------------
// bin2gray.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Gray code to binary converter
//  Combinational design


/* --- INSTANTIATION TEMPLATE BEGIN ---

bin2gray #(
  .WIDTH( 32 )
) BG1 (
  .bin_in(  ),
  .gray_out(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module bin2gray #( parameter
  WIDTH = 32
)(
  input [WIDTH-1:0] bin_in,
  output logic[WIDTH-1:0] gray_out
);

  always_comb begin
    gray_out[WIDTH-1:0] = bin_in[WIDTH-1:0] ^ ( bin_in[WIDTH-1:0] >> 1 );
  end

endmodule

