//------------------------------------------------------------------------------
// edge_detect.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Edge detector, ver.3
// Added parameter to select combinational implementation (zero clocks delay)
//                        or registered implementation (one clocks delay)
//
// In case when "in" port has toggle rate 100% (changes every clock period)
//    "rising" and "falling" outputs will completely replicate input
//    "both" output will be always active in this case
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

edge_detect #(
  .REGISTER_OUTPUTS( 1'b1 )
) ED1[31:0] (
  .clk( {32{clk}} ),
  .nrst( {32{1'b1}} ),
  .in( in[31:0] ),
  .rising( out[31:0] ),
  .falling(  ),
  .both(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module edge_detect #( parameter
  bit [0:0] REGISTER_OUTPUTS = 1'b0    // 0 - comb. implementation (default)
                                       // 1 - registered implementation
)(
  input clk,
  input nrst,

  input in,
  output logic rising,
  output logic falling,
  output logic both
);

// data delay line
logic in_d = 0;
always_ff @(posedge clk) begin
  if ( ~nrst ) begin
    in_d <= 0;
  end else begin
    in_d <= in;
  end
end

logic rising_comb;
logic falling_comb;
logic both_comb;
always_comb begin
  rising_comb = nrst && (in && ~in_d);
  falling_comb = nrst && (~in && in_d);
  both_comb = nrst && (rising_comb || falling_comb);
end

generate
  if( REGISTER_OUTPUTS=='0 ) begin

    // combinational outputs, no delay
    always_comb begin
      rising = rising_comb;
      falling = falling_comb;
      both = both_comb;
    end // always

  end else begin

    // registered outputs, 1 cycle delay
    always_ff @(posedge clk) begin
      if( ~nrst ) begin
        rising <= 0;
        falling <= 0;
        both <= 0;
      end else begin
        rising <= rising_comb;
        falling <= falling_comb;
        both <= both_comb;
      end // always
    end // if

  end // end else
endgenerate

endmodule
