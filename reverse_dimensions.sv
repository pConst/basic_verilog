//------------------------------------------------------------------------------
// reverse_dimensions.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  "Physically" reverses dimension order in systemv_erilog 2D vector
//  Thus in[7][1] signal becomes out[1][7], in[6][10] becomes out[10][6] and vise-versa
//  Module is no doubt synthesizable, but its instance does NOT occupy any FPGA resources!


/* --- INSTANTIATION TEMPLATE BEGIN ---

reverse_dimensions #(
  .D1_WIDTH( 8 ),
  .D2_WIDTH( 3 )
) RD1 (
  .in( smth[7:0][2:0] ),
  .out( htms[2:0][7:0] )   // reversed bit order
);

--- INSTANTIATION TEMPLATE END ---*/


module reverse_dimensions #( parameter
  D1_WIDTH = 8,        // first dimention width
  D2_WIDTH = 3         // second dimention width
)(
  input [D1_WIDTH-1:0][D2_WIDTH-1:0] in,
  output logic [D2_WIDTH-1:0][D1_WIDTH-1:0] out
);


genvar i;
genvar j;
generate
  for (i = 0; i < D1_WIDTH ; i++) begin : gen_i
  for (j = 0; j < D2_WIDTH ; j++) begin : gen_j

    always_comb begin
      out[j][i] = in[i][j];
    end // always_comb

  end // for
  end // for
endgenerate

endmodule
