//------------------------------------------------------------------------------
// leave_one_hot.v
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO -------------------------------------------------------------------------
// Completely combinational module that leaves only lowest hot bit
// compared to input vector
//
// For example 16'b1101_0000 becomes 8'b0001_0000
//             16'b1101_0010 becomes 8'b0000_0010


/* --- INSTANTIATION TEMPLATE BEGIN ---

leave_one_hot #(
  .WIDTH( 32 )
) OH1 (
  .in(  ),
  .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module leave_one_hot #( parameter
  WIDTH = 32
)(
  input [WIDTH-1:0] in,
  output logic [WIDTH-1:0] out
);


genvar i;
generate
  for( i=1; i<WIDTH; i++ ) begin : gen_for

    always_comb begin
        out[i] <= in[i] && ~( |in[(i-1):0] );
    end

  end  // for i
endgenerate

assign out[0] = in[0];

endmodule
