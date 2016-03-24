#
#------------------------------------------------------------------------------------------
# Copyright 2012-2014, Xilinx, Inc.
# This file contains confidential and proprietary information of Xilinx, Inc. and is
# protected under U.S. and international copyright and other intellectual property laws.
#------------------------------------------------------------------------------------------
#
# Disclaimer:
# This disclaimer is not a license and does not grant any rights to the materials
# distributed herewith. Except as otherwise provided in a valid license issued to
# you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
# MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
# DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
# INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
# OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
# (whether in contract or tort, including negligence, or under any other theory
# of liability) for any loss or damage of any kind or nature related to, arising
# under or in connection with these materials, including for any direct, or any
# indirect, special, incidental, or consequential loss or damage (including loss
# of data, profits, goodwill, or any type of loss or damage suffered as a result
# of any action brought by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-safe, or for use in any
# application requiring fail-safe performance, such as life-support or safety
# devices or systems, Class III medical devices, nuclear facilities, applications
# related to the deployment of airbags, or any other applications that could lead
# to death, personal injury, or severe property or environmental damage
# (individually and collectively, "Critical Applications"). Customer assumes the
# sole risk and liability of any use of Xilinx products in Critical Applications,
# subject only to applicable laws and regulations governing limitations on product
# liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
#
#------------------------------------------------------------------------------------------
#
# Constraints for 'uart6_kc705.vhd'.
#
# KC705 Board (www.xilinx.com) Rev 1.1
#
# XC7K325T-1FFG900 Device 
#
# Ken Chapman - Xilinx Ltd
# 
# 3rd June 2014
#
#
# DEVICE
# ------
#
# On the KC705 board, bank 0 and the CFGBVS pin are connected to a 2.5v supply. 
# 
# Configuration voltage supplied to bank 0
# Specified as an actual voltage value
set_property CONFIG_VOLTAGE 2.5 [current_design]
#
# Configuration Bank Voltage Selection (CFGBVS)
# Specified as VCCO (as in this case) or GND
set_property CFGBVS VCCO [current_design]
#
#
# Essential Bits File Generation
# ------------------------------
set_property bitstream.seu.essentialbits yes [current_design]
#
#
# TIMING
# ------
#
# 200MHz clock from oscillator on KC705 board
#
create_clock -period 5 -name clk200 -waveform {0 2.5} -add [get_ports clk200_p]
#
# 200MHz internal clock
#
# create_clock -period 5 -name clk -waveform {0 2.5} -add [get_nets clk]
#
# Signals that appear to be clocks and need to be given a definition to prevent Vivado warnings
#
create_clock -period 100 -name JTAG_Loader_DRCK -waveform {0 10} -add [get_pins program_rom/instantiate_loader.jtag_loader_6_inst/jtag_loader_gen.BSCAN_7SERIES_gen.BSCAN_BLOCK_inst/DRCK]
create_clock -period 1000 -name JTAG_Loader_UPDATE -waveform {0 80} -add [get_pins program_rom/instantiate_loader.jtag_loader_6_inst/jtag_loader_gen.BSCAN_7SERIES_gen.BSCAN_BLOCK_inst/UPDATE]
#
# Tell Vivado to treat all clocks as asynchronous to again prevent unnecessary constraints and warnings.
#
set_clock_groups -name my_async_clocks -asynchronous -group [get_clocks clk200] -group [get_clocks JTAG_Loader_DRCK] -group [get_clocks JTAG_Loader_UPDATE]
#
#
#
# I/O timing is not critical but constraints prevent unnecessary constraints and Vivado warnings.
# Unfortunately Vivado is still reporting 'partial input delay' and 'partial output delay' warnings.
#
#
set_max_delay 50 -from [get_ports uart_rx] -to [get_clocks clk200] -quiet -datapath_only
set_min_delay  0 -from [get_ports uart_rx] -to [get_clocks clk200] -quiet 
#set_max_delay 50 -from [get_ports cpu_rst] -to [get_clocks clk200] -quiet -datapath_only
#set_min_delay  0 -from [get_ports cpu_rst] -to [get_clocks clk200] -quiet 
#
set_max_delay 50 -from [get_clocks clk200] -to [get_ports uart_tx] -quiet -datapath_only
set_min_delay  0 -from [get_clocks clk200] -to [get_ports uart_tx] -quiet 
#
#
#
# DEFINE I/O PINS
# ---------------
#
#
# 200MHz Differential Clock
# -------------------------
# 
set_property PACKAGE_PIN AD12 [get_ports clk200_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk200_p]
#
set_property PACKAGE_PIN AD11 [get_ports clk200_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk200_n]
#
#
# USB-UART
# --------
#
set_property PACKAGE_PIN M19 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS25 [get_ports uart_rx]
#
set_property PACKAGE_PIN K24 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS25 [get_ports uart_tx]
set_property SLEW SLOW [get_ports uart_tx]
set_property DRIVE 4 [get_ports uart_tx]
#
#
# CPU_RST press switch (SW7)
# --------------------------
#
# This input is not used by this design but the constraints have been provided for 
# additional reference.
#
#    Active High
#
# set_property PACKAGE_PIN AB7 [get_ports cpu_rst]
# set_property IOSTANDARD LVCMOS15 [get_ports cpu_rst]
#
#
#------------------------------------------------------------------------------------------
# End of File
#------------------------------------------------------------------------------------------
#
