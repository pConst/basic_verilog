#------------------------------------------------------------------------------
# Vivado test project template
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------


## Clock signal
set_property -dict { PACKAGE_PIN H16 IOSTANDARD LVCMOS33 } [get_ports { clk }]

## Switches
set_property -dict { PACKAGE_PIN M20 IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]
set_property -dict { PACKAGE_PIN M19 IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]

## RGB LEDs
set_property -dict { PACKAGE_PIN L15 IOSTANDARD LVCMOS33 } [get_ports { led4_b }]
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { led4_g }]
set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 } [get_ports { led4_r }]
set_property -dict { PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports { led5_b }]
set_property -dict { PACKAGE_PIN L14 IOSTANDARD LVCMOS33 } [get_ports { led5_g }]
set_property -dict { PACKAGE_PIN M15 IOSTANDARD LVCMOS33 } [get_ports { led5_r }]

## LEDs
set_property -dict { PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports { led[0] }]
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports { led[1] }]
set_property -dict { PACKAGE_PIN N16 IOSTANDARD LVCMOS33 } [get_ports { led[2] }]
set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports { led[3] }]

## Buttons
set_property -dict { PACKAGE_PIN D19 IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]
set_property -dict { PACKAGE_PIN D20 IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]
set_property -dict { PACKAGE_PIN L20 IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]
set_property -dict { PACKAGE_PIN L19 IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]

## Pmod Header JA
set_property -dict { PACKAGE_PIN Y18 IOSTANDARD TMDS_33 } [get_ports { ja_p[1] }]
set_property -dict { PACKAGE_PIN Y19 IOSTANDARD TMDS_33 } [get_ports { ja_n[1] }]
set_property -dict { PACKAGE_PIN Y16 IOSTANDARD TMDS_33 } [get_ports { ja_p[2] }]
set_property -dict { PACKAGE_PIN Y17 IOSTANDARD TMDS_33 } [get_ports { ja_n[2] }]
set_property -dict { PACKAGE_PIN U18 IOSTANDARD TMDS_33 } [get_ports { ja_p[3] }]
set_property -dict { PACKAGE_PIN U19 IOSTANDARD TMDS_33 } [get_ports { ja_n[3] }]
set_property -dict { PACKAGE_PIN W18 IOSTANDARD TMDS_33 } [get_ports { ja_p[4] }]
set_property -dict { PACKAGE_PIN W19 IOSTANDARD TMDS_33 } [get_ports { ja_n[4] }]

## Pmod Header JB
set_property -dict { PACKAGE_PIN Y14 IOSTANDARD TMDS_33 } [get_ports { jb_n[1] }]
set_property -dict { PACKAGE_PIN W14 IOSTANDARD TMDS_33 } [get_ports { jb_p[1] }]
set_property -dict { PACKAGE_PIN T10 IOSTANDARD TMDS_33 } [get_ports { jb_n[2] }]
set_property -dict { PACKAGE_PIN T11 IOSTANDARD TMDS_33 } [get_ports { jb_p[2] }]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD TMDS_33 } [get_ports { jb_n[3] }]
set_property -dict { PACKAGE_PIN V16 IOSTANDARD TMDS_33 } [get_ports { jb_p[3] }]
set_property -dict { PACKAGE_PIN W13 IOSTANDARD TMDS_33 } [get_ports { jb_n[4] }]
set_property -dict { PACKAGE_PIN V12 IOSTANDARD TMDS_33 } [get_ports { jb_p[4] }]

## Audio Out
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports { aud_pwm }]
set_property -dict { PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports { aud_sd }]

## Crypto SDA
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { crypto_sda }]

##HDMI RX Signals
#set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_cec }]
#set_property -dict { PACKAGE_PIN N18 IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_clk_p }]
#set_property -dict { PACKAGE_PIN P19 IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_clk_n }]
#set_property -dict { PACKAGE_PIN V20 IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_p[0] }]
#set_property -dict { PACKAGE_PIN W20 IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_n[0] }]
#set_property -dict { PACKAGE_PIN T20 IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_p[1] }]
#set_property -dict { PACKAGE_PIN U20 IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_n[1] }]
#set_property -dict { PACKAGE_PIN N20 IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_p[2] }]
#set_property -dict { PACKAGE_PIN P20 IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_n[2] }]
#set_property -dict { PACKAGE_PIN T19 IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_hpd }]
#set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_scl }]
#set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_sda }]

##HDMI TX Signals
#set_property -dict { PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_cec }]
#set_property -dict { PACKAGE_PIN L16 IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_clk_p }]
#set_property -dict { PACKAGE_PIN L17 IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_clk_n }]
#set_property -dict { PACKAGE_PIN K17 IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_d_p[0] }]
#set_property -dict { PACKAGE_PIN K18 IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_d_n[0] }]
#set_property -dict { PACKAGE_PIN K19 IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_d_p[1] }]
#set_property -dict { PACKAGE_PIN J19 IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_d_n[1] }]
#set_property -dict { PACKAGE_PIN J18 IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_d_p[2] }]
#set_property -dict { PACKAGE_PIN H18 IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_d_n[2] }]
#set_property -dict { PACKAGE_PIN R19 IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_hpdn }]
#set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_scl }]
#set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_sda }]

## ChipKit Single Ended Analog Inputs
## NOTE: The ck_an_p pins can be used as single ended analog inputs with voltages from 0-3.3V (Chipkit Analog pins A0-A5).
##      These signals should only be connected to the XADC core. When using these pins as digital I/O, use pins CK_A[0-5].
set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[0] }]
set_property -dict { PACKAGE_PIN E17 IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[0] }]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[1] }]
set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[1] }]
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[2] }]
set_property -dict { PACKAGE_PIN K14 IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[2] }]
set_property -dict { PACKAGE_PIN J16 IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[3] }]
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[3] }]
set_property -dict { PACKAGE_PIN H20 IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[4] }]
set_property -dict { PACKAGE_PIN J20 IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[4] }]
set_property -dict { PACKAGE_PIN G20 IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[5] }]
set_property -dict { PACKAGE_PIN G19 IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[5] }]

## ChipKit Digital I/O On Outer Analog Header
## NOTE: These pins should be used when using the analog header signals A0-A5 as digital I/O (Chipkit digital pins 0-5)
set_property -dict { PACKAGE_PIN Y11 IOSTANDARD LVCMOS33 } [get_ports { ck_a[0] }]
set_property -dict { PACKAGE_PIN Y12 IOSTANDARD LVCMOS33 } [get_ports { ck_a[1] }]
set_property -dict { PACKAGE_PIN W11 IOSTANDARD LVCMOS33 } [get_ports { ck_a[2] }]
set_property -dict { PACKAGE_PIN V11 IOSTANDARD LVCMOS33 } [get_ports { ck_a[3] }]
set_property -dict { PACKAGE_PIN T5 IOSTANDARD LVCMOS33 } [get_ports { ck_a[4] }]
set_property -dict { PACKAGE_PIN U10 IOSTANDARD LVCMOS33 } [get_ports { ck_a[5] }]

## ChipKit Digital I/O On Inner Analog Header
## NOTE: These pins will need to be connected to the XADC core when used as differential analog inputs (Chipkit analog pins A6-A11)
#set_property -dict { PACKAGE_PIN B20 IOSTANDARD LVCMOS33 } [get_ports { ad_n[0] }]
#set_property -dict { PACKAGE_PIN C20 IOSTANDARD LVCMOS33 } [get_ports { ad_p[0] }]
#set_property -dict { PACKAGE_PIN F20 IOSTANDARD LVCMOS33 } [get_ports { ad_n[12] }]
#set_property -dict { PACKAGE_PIN F19 IOSTANDARD LVCMOS33 } [get_ports { ad_p[12] }]
#set_property -dict { PACKAGE_PIN A20 IOSTANDARD LVCMOS33 } [get_ports { ad_n[8] }]
#set_property -dict { PACKAGE_PIN B19 IOSTANDARD LVCMOS33 } [get_ports { ad_p[8] }]

## ChipKit Digital I/O Low
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[0] }]
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[1] }]
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[2] }]
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[3] }]
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[4] }]
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[5] }]
set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[6] }]
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[7] }]
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[8] }]
set_property -dict { PACKAGE_PIN V18 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[9] }]
set_property -dict { PACKAGE_PIN T16 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[10] }]
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[11] }]
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[12] }]
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { ck_io_low[13] }]

## ChipKit Digital I/O High
set_property -dict { PACKAGE_PIN U5 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[26] }]
set_property -dict { PACKAGE_PIN V5 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[27] }]
set_property -dict { PACKAGE_PIN V6 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[28] }]
set_property -dict { PACKAGE_PIN U7 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[29] }]
set_property -dict { PACKAGE_PIN V7 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[30] }]
set_property -dict { PACKAGE_PIN U8 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[31] }]
set_property -dict { PACKAGE_PIN V8 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[32] }]
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[33] }]
set_property -dict { PACKAGE_PIN W10 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[34] }]
set_property -dict { PACKAGE_PIN W6 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[35] }]
set_property -dict { PACKAGE_PIN Y6 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[36] }]
set_property -dict { PACKAGE_PIN Y7 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[37] }]
set_property -dict { PACKAGE_PIN W8 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[38] }]
set_property -dict { PACKAGE_PIN Y8 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[39] }]
set_property -dict { PACKAGE_PIN W9 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[40] }]
set_property -dict { PACKAGE_PIN Y9 IOSTANDARD LVCMOS33 } [get_ports { ck_io_high[41] }]

## ChipKit SPI
set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports { ck_miso }]
set_property -dict { PACKAGE_PIN T12 IOSTANDARD LVCMOS33 } [get_ports { ck_mosi }]
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { ck_sck }]
set_property -dict { PACKAGE_PIN F16 IOSTANDARD LVCMOS33 } [get_ports { ck_ss }]

## ChipKit I2C
set_property -dict { PACKAGE_PIN P16 IOSTANDARD LVCMOS33 } [get_ports { ck_scl }]
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { ck_sda }]

## Misc. ChipKit signals
set_property -dict { PACKAGE_PIN Y13 IOSTANDARD LVCMOS33 } [get_ports { ck_ioa }]

## Not Connected Pins
#set_property PACKAGE_PIN F17 [get_ports {netic20_f17}]
#set_property PACKAGE_PIN G18 [get_ports {netic20_g18}]
#set_property PACKAGE_PIN T9 [get_ports {netic20_t9}]
#set_property PACKAGE_PIN U9 [get_ports {netic20_u9}]


set_property IOB TRUE [get_ports {*}]
