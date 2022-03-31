//------------------------------------------------------------------------------
// edge_detect.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Edge detector, ver.4
//
// (new!) Added WIDTH parameter to simplify instantiating arrays of edge detectors
// (new!) Made reset to be asynchronous
//
// Added parameter to select combinational implementation (zero clocks delay)
//                        or registered implementation (one clocks delay)
//
// In case when "in" port has toggle rate 100% (changes every clock period)
//    "rising" and "falling" outputs will completely replicate input
//    "both" output will be always active in this case
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

edge_detect #(
  .WIDTH( 32 ),
  .REGISTER_OUTPUTS( 1'b1 )
) in_ed (
  .clk( clk ),
  .anrst( 1'b1 ),
  .in( in[31:0] ),
  .rising( in_rise[31:0] ),
  .falling(  ),
  .both(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module edge_detect #( parameter
  bit [7:0] WIDTH = 1,                 // signal width
  bit [0:0] REGISTER_OUTPUTS = 1'b0    // 0 - comb. implementation (default)
                                       // 1 - registered implementation
)(
  input clk,
  input anrst,

  input [WIDTH-1:0] in,
  output logic [WIDTH-1:0] rising,
  output logic [WIDTH-1:0] falling,
  output logic [WIDTH-1:0] both
);

// data delay line
logic [WIDTH-1:0] in_d = '0;
always_ff @(posedge clk or negedge anrst) begin
  if ( ~anrst ) begin
    in_d[WIDTH-1:0] <= '0;
  end else begin
    in_d[WIDTH-1:0] <= in[WIDTH-1:0];
  end
end

logic [WIDTH-1:0] rising_comb;
logic [WIDTH-1:0] falling_comb;
logic [WIDTH-1:0] both_comb;
always_comb begin
  rising_comb[WIDTH-1:0] = {WIDTH{anrst}} & (in[WIDTH-1:0] & ~in_d[WIDTH-1:0]);
  falling_comb[WIDTH-1:0] = {WIDTH{anrst}} & (~in[WIDTH-1:0] & in_d[WIDTH-1:0]);
  both_comb[WIDTH-1:0] = {WIDTH{anrst}} & (rising_comb[WIDTH-1:0] | falling_comb[WIDTH-1:0]);
end

generate
  if( REGISTER_OUTPUTS==1'b0 ) begin

    // combinational outputs, no delay
    always_comb begin
      rising[WIDTH-1:0] = rising_comb[WIDTH-1:0];
      falling[WIDTH-1:0] = falling_comb[WIDTH-1:0];
      both[WIDTH-1:0] = both_comb[WIDTH-1:0];
    end // always

  end else begin

    // registered outputs, 1 cycle delay
    always_ff @(posedge clk or negedge anrst) begin
      if( ~anrst ) begin
        rising[WIDTH-1:0] <= '0;
        falling[WIDTH-1:0] <= '0;
        both[WIDTH-1:0] <= '0;
      end else begin
        rising[WIDTH-1:0] <= rising_comb[WIDTH-1:0];
        falling[WIDTH-1:0] <= falling_comb[WIDTH-1:0];
        both[WIDTH-1:0] <= both_comb[WIDTH-1:0];
      end // always
    end // if

  end // end else
endgenerate

endmodule
