#------------------------------------------------------------------------------
# timing.sdc
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

create_clock -period 10.000 -name clk [get_ports {clk}]

