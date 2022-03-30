// Konstantin Pavlov, pavlovconst@gmail.com
// Arty board base project template

`timescale 1ns / 1ps

`include "define.svh"


`define WIDTH 32

module main(

  input clk,         // 125 MHz
  input [1:0] sw,

  // RGB LEDs
  output led4_r,led4_g,led4_b,
  output led5_r,led5_g,led5_b,

  output [3:0] led,
  input [4:0] btn,

  // PMOD Headers
  output [4:1] ja_p, [4:1] ja_n,
  output [4:1] jb_p, [4:1] jb_n,

  // Audio Out
  output aud_pwm, aud_sd,

  // crypto SDA
  output crypto_sda,

  // HDMI RX Signals
  //output hdmi_rx_cec,
  //output hdmi_rx_clk_p,
  //output hdmi_rx_clk_n,
  //output [2:0] hdmi_rx_d_p,
  //output [2:0] hdmi_rx_d_n,
  //output hdmi_rx_hpd,
  //output hdmi_rx_scl,
  //output hdmi_rx_sda,

  // HDMI TX Signals
  // output hdmi_tx_cec,
  // output hdmi_tx_clk_p,
  // output hdmi_tx_clk_n,
  // input [2:0] hdmi_tx_d_p,
  // input [2:0] hdmi_tx_d_n,
  // output hdmi_tx_hpdn,        // hpdn!
  // output hdmi_tx_scl,
  // output hdmi_tx_sda,

  // Single Ended Analog Inputs
  input [5:0] ck_an_p,
  input [5:0] ck_an_n,

  // Digital I/O On Outer Analog Header
  output [5:0] ck_a,
  // Digital I/O On Inner Analog Header
  //

  // Digital I/O Low
  output [13:0] ck_io_low,

  // Digital I/O High
  output [41:26] ck_io_high,

  // SPI
  output ck_miso, ck_mosi, ck_sck, ck_ss,
  // I2C
  output ck_scl, ck_sda,
  // Misc
  output ck_ioa
);

`VIVADO_MODULE_HEADER


// clocks ======================================================================

logic sys_pll_locked;  // asyn
logic clk125;
logic clk500;

logic nrst;

clk_wiz_0 sys_pll (
  .clk_in1( clk ),
  .resetn(1'b1),
  .clk_out1( clk125 ),
  .clk_out2( clk500 ),
  .locked( sys_pll_locked )
);

logic [31:0] div_clk125;
clk_divider #(
  .WIDTH( 32 )
) cd1 (
  .clk( clk125 ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .out( div_clk125[31:0] )
);

assign led4_g = div_clk125[25];

// nrst ========================================================================
logic [1:0] sw_s;
logic [4:0] btn_s;

always_ff @(posedge clk125) begin
  nrst <= ~btn_s[0];  // external reset
end

assign led4_b = ~nrst;

// buttons =====================================================================

delay #(
    .LENGTH( 2 ),
    .WIDTH( 6 )
) sw_SYNC_ATTR [5:0] (
    .clk( {6{clk125}} ),
    .nrst( {6{1'b1}} ),
    .ena( {6{1'b1}} ),
    .in( {btn[3:0], sw[1:0]} ),
    .out( {btn_s[3:0], sw_s[1:0]} )
);

logic [1:0] sw_s_rise;
logic [4:0] btn_s_rise;

logic gpio_sws_front;
edge_detect sw_s_ed [5:0] (
  .clk( {6{clk125}} ),
  .nrst( {6{nrst}} ),
  .in( {btn_s[3:0], sw_s[1:0]} ),
  .rising( {btn_s_rise[3:0], sw_s_rise[1:0]} ),
  .falling(  ),
  .both(  )
);

// =============================================================================

logic [`WIDTH-1:0] in_data;

// input registers
logic [`WIDTH-1:0] in_data_reg = 0;
always_ff @(posedge clk125) begin
  if( ~nrst ) begin
    in_data_reg[`WIDTH-1:0] <= '0;
  end else begin
    in_data_reg[`WIDTH-1:0] <= in_data[`WIDTH-1:0];
  end
end

// place your test logic here ==================================================

logic [`WIDTH-1:0] out_data_comb = 0;
always_comb begin
  out_data_comb[`WIDTH-1:0] <= in_data_reg[`WIDTH-1:0] ^ div_clk125[31:0];
end

// output registers
logic [`WIDTH-1:0] out_data = '0;
always_ff @(posedge clk125) begin
  if( ~nrst ) begin
    out_data[`WIDTH-1:0] <= '0;
  end else begin
    out_data[`WIDTH-1:0] <= out_data_comb[`WIDTH-1:0];
  end
end


vio_0 debug_vio (
  .clk( clk125 ),
  .probe_out0( in_data[`WIDTH-1:0] ),
  .probe_in0( div_clk125[31:0] ),
  .probe_in1( out_data[`WIDTH-1:0] )
);

// =============================================================================

OBUFDS #(
  .IOSTANDARD("DEFAULT"),
  .SLEW("FAST")
) ja_b [4:1] (
  .I( div_clk125[24:21] ),
  .O( ja_p[4:1] ),
  .OB( ja_n[4:1] )
);

OBUFDS #(
  .IOSTANDARD("DEFAULT"),
  .SLEW("FAST")
) jb_b [4:1] (
  .I( div_clk125[24:21] ),
  .O( jb_p[4:1] ),
  .OB( jb_n[4:1] )
);



`VIVADO_MODULE_FOOTER

endmodule

