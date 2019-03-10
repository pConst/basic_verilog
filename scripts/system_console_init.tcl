#------------------------------------------------------------------------------
# system_console_init.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Initialization script for reading/writing Avalon-MM through
#   JTAG-to-Avalon-MM bridge IP when using Quartus System Console
# To select the script press Ctrl+E in Quartus System Console

# setting path to first service master
set master_path [lindex [get_service_paths master] 0]
# example output
#/devices/10CL025(Y|Z)|EP3C25|EP4CE22@1#3-3.1/(link)/JTAG/alt_sld_fab_sldfabric.node_0/phy_0/master_0.master

# claiming master resources
set claim_path [claim_service master $master_path mylib]
# example output
#/channels/local/mylib/master_1

# reading/Writing service master
puts "INIT DONE"
puts "Example syntax for following commands:"
puts "master_write_32 \$claim_path 0x10 0x810000FF"
puts "master_read_8 \$claim_path 0x10 1"

# closing the service
#close_service master $claim_path

