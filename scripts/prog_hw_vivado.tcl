#------------------------------------------------------------------------------
# prog_hw_vivado.tcl
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# program script for Vivado
#
# call with
# vivado -nolog -mode batch -source prog_hw_vivado.tcl

connect_hw_server
open_hw_target [lindex [get_hw_targets] 0]
set_property PROGRAM.FILE main.bit [lindex [get_hw_devices] 1]
program_hw_devices [lindex [get_hw_devices] 1]

