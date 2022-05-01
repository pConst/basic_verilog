#------------------------------------------------------------------------------
# allow_undefined_ports.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Use this script for Xilinx Vivado environment to allow generation of test
# projects with undefines pins (that will eventually have DEFAULT positional
# and electrical standard constraints)
#
# Place this script as a pre-tcl-script for "Generate bitstream" step

set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
