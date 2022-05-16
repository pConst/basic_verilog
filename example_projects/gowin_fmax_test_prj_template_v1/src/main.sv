//------------------------------------------------------------------------------
// Gowin test project template
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Gowin IDE test project template, v1
// Compatible with Tang Nano 9K board
//
// - use this as a boilerplate project for fast prototyping
// - inputs and outputs are registered to allow valid timequest output
//   even if your custom logic/IPs have combinational outputs
// - SDC constraint file assigns clk to 500MHz to force fitter to synthesize
//   the fastest possible circuit
//

`timescale 1ns / 1ps

`include "define.svh"


`define WIDTH 16

module main(
  input clk27,

  input [1:0] key,
  output [5:0] led,

  input [`WIDTH-1:0] in_data,
  output logic [`WIDTH-1:0] out_data
);


// clocks ======================================================================

logic sys_pll_locked;  // asyn
logic clk250;

logic nrst;

sys_pll sys_pll_b (
  .clkin( clk27 ),
  .clkout( clk250 ),
  .lock( sys_pll_locked )
);

assign led[0] = sys_pll_locked;

logic [31:0] div_clk250;
clk_divider #(
  .WIDTH( 32 )
) cd_500 (
  .clk( clk250 ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .out( div_clk250[31:0] )
);

assign led[1] = div_clk250[27];

// nrst ========================================================================
logic [1:0] key_s;

always_ff @(posedge clk250) begin
  nrst <= ~key_s[0];      // external reset
end

assign led[2] = ~key_s[0];
assign led[3] = ~key_s[1];

// buttons =====================================================================

delay #(
    .LENGTH( 2 ),
    .WIDTH( 2 )
) sw_SYNC_ATTR (
    .clk( clk250 ),
    .nrst( 1'b1 ),   // dont use nrst here!
    .ena( 1'b1 ),
    .in( ~key[1:0] ),
    .out( key_s[1:0] )
);

logic [1:0] key_s_rise;
logic [1:0] key_s_fall;

edge_detect #(
  .WIDTH( 2 )
) sw_s_ed (
  .clk( clk250 ),
  .anrst( 1'b1 ),
  .in( key_s[1:0] ),
  .rising( key_s_rise[1:0] ),
  .falling( key_s_fall[1:0] ),
  .both(  )
);

// =============================================================================

// input registers
logic [`WIDTH-1:0] in_data_reg = 0;
always_ff @(posedge clk250) begin
  if( ~nrst ) begin
    in_data_reg[`WIDTH-1:0] <= '0;
  end else begin
    in_data_reg[`WIDTH-1:0] <= in_data[`WIDTH-1:0];
  end
end

// place your test logic here ==================================================

logic [`WIDTH-1:0] out_data_comb = 0;
always_comb begin
  out_data_comb[`WIDTH-1:0] <= in_data_reg[`WIDTH-1:0] ^ div_clk250[31:0];
end

// output registers
always_ff @(posedge clk250) begin
  if( ~nrst ) begin
    out_data[`WIDTH-1:0] <= 0;
  end else begin
    out_data[`WIDTH-1:0] <= out_data_comb[`WIDTH-1:0];
  end
end

`include "clogb2.svh"

endmodule

