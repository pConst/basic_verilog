//------------------------------------------------------------------------------
// Quartus test project template
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Quartus test project template, v4
// Compatible with DE10-Nano board
//
// - use this as a boilerplate project for fast prototyping
// - inputs and outputs are registered to allow valid timequest output
//   even if your custom logic/IPs have combinational outputs
// - SDC constraint file assigns clk to 500MHz to force fitter to synthesize
//   the fastest possible circuit
//

`timescale 1ns / 1ps

`include "define.svh"


`define WIDTH 32

module main(

  input FPGA_CLK1_50,
  input FPGA_CLK2_50,
  input FPGA_CLK3_50,

  // ADC
  input ADC_CONVST,
  input ADC_SCK,
  input ADC_SDI,
  input ADC_SDO,

  // ARDUINO
  input ARDUINO_RESET_N,
  input [15:0] ARDUINO_IO,

  // HDMI
  input [23:0] HDMI_TX_D,
  input HDMI_I2C_SCL,
  input HDMI_I2C_SDA,
  input HDMI_I2S,
  input HDMI_LRCLK,
  input HDMI_MCLK,
  input HDMI_SCLK,
  input HDMI_TX_CLK,
  input HDMI_TX_DE,
  input HDMI_TX_HS,
  input HDMI_TX_INT,
  input HDMI_TX_VS,

  // GPIO
  input [35:0] GPIO_0,
  output [35:0] GPIO_1,
  input [1:0] KEY,
  input [3:0] SW,
  output [7:0] LED,

  // virtual pins
  input [`WIDTH-1:0] in_data,
  input [`WIDTH-1:0] in_datb,
  output logic [`WIDTH-1:0] out_data = '0
);


// clocks ======================================================================

logic sys_pll_locked;  // asyn
logic clk125;
logic clk500;

logic nrst;

sys_pll sys_pll_b (
  .refclk( FPGA_CLK1_50 ),
  .rst( 1'b0 ),
  .outclk_0( clk125 ),
  .outclk_1( clk500 ),
  .locked( sys_pll_locked )
);

logic [31:0] div_clk125;
clk_divider #(
  .WIDTH( 32 )
) cd_125 (
  .clk( clk125 ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .out( div_clk125[31:0] )
);

logic [31:0] div_clk500;
clk_divider #(
  .WIDTH( 32 )
) cd_500 (
  .clk( clk500 ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .out( div_clk500[31:0] )
);

assign LED[7] = div_clk125[25];

// nrst ========================================================================
logic [3:0] sw_s;
logic [1:0] key_s;

always_ff @(posedge clk125) begin
  nrst <= ~key_s[0];  // external reset
end

assign LED[6] = ~nrst;

// buttons =====================================================================

delay #(
    .LENGTH( 2 ),
    .WIDTH( 6 )
) sw_SYNC_ATTR (
    .clk( clk125 ),
    .nrst( 1'b1 ),
    .ena( 1'b1 ),
    .in( {SW[3:0], KEY[1:0]} ),
    .out( {sw_s[3:0], key_s[1:0]} )
);

logic [3:0] sw_s_rise;
logic [1:0] key_s_rise;

edge_detect #(
  .WIDTH( 6 )
) sw_s_ed (
  .clk( clk125 ),
  .anrst( nrst ),
  .in( {sw_s[3:0], key_s[1:0]} ),
  .rising( {sw_s_rise[3:0], key_s_rise[1:0]} ),
  .falling(  ),
  .both(  )
);

// =============================================================================

// input registers
logic [`WIDTH-1:0] in_data_reg = 0;
always_ff @(posedge clk500) begin
  if( ~nrst ) begin
    in_data_reg[`WIDTH-1:0] <= '0;
  end else begin
    in_data_reg[`WIDTH-1:0] <= in_data[`WIDTH-1:0];
  end
end

// place your test logic here ==================================================

logic [`WIDTH-1:0] out_data_comb = 0;
always_comb begin
  out_data_comb[`WIDTH-1:0] <= in_data_reg[`WIDTH-1:0] ^ div_clk500[31:0];
end

// output registers
always_ff @(posedge clk500) begin
  if( ~nrst ) begin
    out_data[`WIDTH-1:0] <= '0;
  end else begin
    out_data[`WIDTH-1:0] <= out_data_comb[`WIDTH-1:0];
  end
end

// =============================================================================

/*logic [`WIDTH-1:0] in_datc;
logic [`WIDTH-1:0] in_datd;
logic [`WIDTH-1:0] out_datc;
assign out_datc[`WIDTH-1:0] = in_datc[`WIDTH-1:0] | in_datd[`WIDTH-1:0];

jtag_io jtag_io_b (
  .clk_clk( clk125 ),
  .reset_reset_n( nrst ),
  .out0_export( in_datc[`WIDTH-1:0] ),
  .out1_export( in_datd[`WIDTH-1:0] ),
  .in0_export( div_clk125[31:0] ),
  .in1_export( out_datc[`WIDTH-1:0] )
);
*/

`include "clogb2.svh"

endmodule

