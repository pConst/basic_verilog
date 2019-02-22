//------------------------------------------------------------------------------
// reverse_vector.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  "Physically" reverses signal order within multi-bit bus
//  Thus in[7] signal becomes out[0], in[6] becomes out[1] and vise-versa
//  Module is no doubt synthesizable, but its instance does NOT occupy any FPGA resources!


/* --- INSTANTIATION TEMPLATE BEGIN ---

reverse_vector #(
  .WIDTH( 8 )         // WIDTH must be >=2
) RV1 (
  .in( smth[7:0] ),
  .out( htms[7:0] )   // reversed bit order
);

--- INSTANTIATION TEMPLATE END ---*/


module reverse_vector #( parameter
  WIDTH = 8         // WIDTH must be >=2
)(
  input [(WIDTH-1):0] in,
  output logic [(WIDTH-1):0] out
);


genvar i;

generate
  for (i = 0; i < (WIDTH/2) ; i++) begin : gen1
    always_comb begin
      out[i] = in[WIDTH-1-i];
      out[WIDTH-1-i] = in[i];
    end // always_comb
  end // for
endgenerate

// additional assign needed when WIDTH is odd
generate
  if ( WIDTH%2 ) begin : gen2
    always_comb begin
      out[WIDTH/2] = in[WIDTH/2];
    end // always_comb
  end // for
endgenerate


endmodule
