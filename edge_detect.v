//------------------------------------------------------------------------------
// edge_detect.v
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Edge detector, ver.4
// (simplified Verilog version, see ./edge_detect.sv for advanced features)
//
// In case when "in" port has toggle rate 100% (changes every clock period)
//    "rising" and "falling" outputs will completely replicate input
//    "both" output will be always active in this case
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

edge_detect #(
  .WIDTH( 32 )
) ED1 (
  .clk( clk ),
  .anrst( 1'b1 ),
  .in( in[31:0] ),
  .rising( in_rise[31:0] ),
  .falling(  ),
  .both(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module edge_detect #( parameter
  bit [7:0] WIDTH = 1
)(
  input clk,
  input anrst,

  input  [WIDTH-1:0] in,

  output [WIDTH-1:0] rising,
  output [WIDTH-1:0] falling,
  output [WIDTH-1:0] both
);

  // data delay line
  reg [WIDTH-1:0] in_d = '0;
  always_ff @(posedge clk or negedge anrst) begin
    if ( ~anrst ) begin
      in_d[WIDTH-1:0] <= '0;
    end else begin
      in_d[WIDTH-1:0] <= in[WIDTH-1:0];
    end
  end

  always @(*) begin
    rising[WIDTH-1:0] = {WIDTH{anrst}} & (in[WIDTH-1:0] & ~in_d[WIDTH-1:0]);
    falling[WIDTH-1:0] = {WIDTH{anrst}} & (~in[WIDTH-1:0] & in_d[WIDTH-1:0]);

    both[WIDTH-1:0] = rising[WIDTH-1:0] | falling[WIDTH-1:0];
  end

endmodule
