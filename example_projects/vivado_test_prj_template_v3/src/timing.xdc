#------------------------------------------------------------------------------
# Vivado test project template
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------


# clocks =======================================================================
create_clock -name clk -period 8.000 -waveform {0.000 4.000} [get_ports { clk }]


# ==============================================================================
#set_property BITSTREAM.CONFIG.UNUSEDPIN PULLDOWN [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]
#set_property CONFIG_VOLTAGE 3.3 [current_design]
#set_property CFGBVS VCCO [current_design]
#set_property CONFIG_MODE SPIx4 [current_design]
#set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#set_property BITSTREAM.CONFIG.M1PIN PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.M2PIN PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.M0PIN PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]


# cross clock false paths ======================================================

#set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clk_out2_clk_wiz_0]
#set_false_path -from [get_clocks clk_out2_clk_wiz_0] -to [get_clocks clk_out1_clk_wiz_0]


# false paths ==================================================================

# all delay.sv instances with "_SYNC_ATTR" suffix name will be considered not
#   a delay, but as a synchronizers
#   see https://www.xilinx.com/support/answers/62136.html for syntax explanation
set_false_path -to [get_cells -hier -filter {NAME =~ *_SYNC_ATTR/data_reg[1]*}]
set_false_path -to [get_cells -hier -filter {NAME =~ *_SYNC_ATTR[*]/data_reg[1]*}]


# ==============================================================================
# Other automatically adde dby Vivado ==========================================
# ==============================================================================

