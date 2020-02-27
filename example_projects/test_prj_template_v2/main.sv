//------------------------------------------------------------------------------
// main.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Test project template, v2
//
// - use this as a boilerplate project for fast prototyping
// - inputs and outputs are registered to allow valid timequest output
//   even if your custom logic/IPs have combinational outputs
// - SDC constraint file assigns clk to 500MHz to force fitter to synthesize
//   the fastest possible circuit
//

`define WIDTH

module main(

  input clk,
  input nrst,

  input [`WIDTH-1:0] in_data,
  output logic [`WIDTH-1:0] out_data
);

// input registers
logic [`WIDTH-1:0] in_data_reg = 0;
always_ff @(posedge clk) begin
  if( ~nrst ) begin
    in_data_reg <= '0;
  end else begin
    in_data_reg <= in_data;
  end
end

// place your test logic here ==================================================

// logic [31:0] divided_clk;
// clk_divider #(
//   .WIDTH( 32 )
// ) cd1 (
//   .clk( clk ),
//   .nrst( nrst ),
//   .ena( 1'b1 ),
//   .out( divided_clk[31:0] )
// );

// logic [`WIDTH-1:0] out_data_comb = 0;
// always_comb begin
//   out_data_comb <= out_data_comb[`WIDTH-1:0] ^ divided_clk[31:0];
// end


// =============================================================================

// output registers
always_ff @(posedge clk) begin
  if( ~nrst ) begin
    out_data[`WIDTH-1:0] <= '0;
  end else begin
    out_data[`WIDTH-1:0] <= out_data_comb[`WIDTH-1:0];
  end
end

endmodule