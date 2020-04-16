//------------------------------------------------------------------------------
// reverse_bytes.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  "Physically" reverses bytes order within multi-byte array
//  Thus in[15] byte becomes out[7], in[0] becomes out[8] and vise-versa
//  Module could be used to convert big-endian data to little-endian
//  Module is no doubt synthesizable, but its instance does NOT occupy any FPGA resources!


/* --- INSTANTIATION TEMPLATE BEGIN ---

reverse_bytes #(
  .BYTES( 2 )
) RV1 (
  .in( smth[15:0] ),
  .out( htms[15:0] )   // reversed byte order
);

--- INSTANTIATION TEMPLATE END ---*/


module reverse_bytes #( parameter
  BYTES = 8
)(
  input [(BYTES*8-1):0] in,
  output logic [(BYTES*8-1):0] out
);


logic [BYTES-1:0][7:0] byte_data;
assign byte_data = in;

logic [BYTES-1:0][7:0] rev_byte_data;

genvar i;
generate
  for (i = 0; i < BYTES ; i++) begin : gen_reverse
    always_comb begin
      rev_byte_data[i] = byte_data[(BYTES-1)-i];
    end // always_comb
  end // for
endgenerate

assign out = rev_byte_data;

endmodule
