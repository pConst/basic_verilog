#------------------------------------------------------------------------------
# export_autoplaced_pins.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Use this script for Xilinx Vivado environment to export automaticaly
# placed pins after succesful implementation
#
# Source this script from the TCL Console, after opening implemented design

set f [open export.xdc a]

set my_ports [get_ports]
foreach port_i $my_ports {
puts $f "set_property PACKAGE_PIN [get_property PACKAGE_PIN $port_i] \[get_ports $port_i \] "
}

foreach port_i $my_ports {
puts $f "set_property IOSTANDARD [get_property IOSTANDARD $port_i] \[get_ports $port_i \] "
}

close $f
