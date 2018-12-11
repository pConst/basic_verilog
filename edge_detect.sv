//------------------------------------------------------------------------------
// edge_detect.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Edge detector, ver.2
// Combinational implementation (zero ticks delay)
//
// In case when "in" port has toggle rate 100% (changes every clock period)
//    "rising" and "falling" outputs will completely replicate input
//    "both" output will be always active in this case


/* --- INSTANTIATION TEMPLATE BEGIN ---

edge_detect ED1[31:0] (
  .clk( {32{clk}} ),
  .nrst( {32{1'b1}} ),
  .in( in[31:0] ),
  .rising( out[31:0] ),
  .falling(  ),
  .both(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module edge_detect(
  input clk,
  input nrst,

  input in,
  output logic rising,
  output logic falling,
  output logic both
);

logic in_d = 0;
always_ff @(posedge clk) begin
  if ( ~nrst ) begin
    in_d <= 0;
  end else begin
    in_d <= in;
  end
end

always_comb begin
  rising = nrst && (in && ~in_d);
  falling = nrst && (~in && in_d);
  both = nrst && (rising || falling);
end

endmodule
