#------------------------------------------------------------------------------
# Quartus test project template
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# main reference clock, 500 MHz
create_clock -period 2.000 -waveform { 0.000 1.000 } [get_ports {FPGA_CLK1_50}]
create_clock -period 2.000 -waveform { 0.000 1.000 } [get_ports {FPGA_CLK2_50}]
create_clock -period 2.000 -waveform { 0.000 1.000 } [get_ports {FPGA_CLK3_50}]

derive_pll_clocks
derive_clock_uncertainty