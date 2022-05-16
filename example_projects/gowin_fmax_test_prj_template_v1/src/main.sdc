#------------------------------------------------------------------------------
# Gowin test project template
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# main reference clock, 27 MHz
create_clock -period 37.037-waveform { 0.000 18.518 } [get_ports {clk27}]

