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
  WIDTH = 8
)(
  input [(WIDTH-1):0] in,
  output logic [(WIDTH-1):0] out
);

  integer i;
  always_comb begin
    for (i = 0; i < WIDTH ; i++) begin : gen_reverse
      out[i] = in[(WIDTH-1)-i];
    end // for
  end // always_comb

endmodule

