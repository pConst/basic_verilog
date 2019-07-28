#------------------------------------------------------------------------------
# quartus_system_console_init.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Initialization script for reading/writing Avalon-MM through
#   JTAG-to-Avalon-MM bridge IP when using Quartus System Console
# To select the script press Ctrl+E in Quartus System Console

# list masters
proc lm { } {
  get_service_paths master
}

# select masters
proc sm { index } {
  upvar 1 claim_path claim_path

  set master_path [lindex [get_service_paths master] $index]
# example output
#/devices/10CL025(Y|Z)|EP3C25|EP4CE22@1#3-3.1/(link)/JTAG/alt_sld_fab_sldfabric.node_0/phy_0/master_0.master
  set claim_path [claim_service master $master_path mylib]
# example output
#/channels/local/mylib/master_1
}

# basic write
proc wr { a i d } {
  upvar 1 claim_path claim_path
  master_write_32 $claim_path 0x10 0x$a$i$d
}

# basic read
proc rd { a i } {
  upvar 1 claim_path claim_path
  set ir 8[string range $i 1 3]
  master_write_32 $claim_path 0x10 0x${a}${ir}00
  master_read_32 $claim_path 0x00 1
}

# pause next operations for N milliseconds
proc sleep { N } {
   after [expr {int($N)}]
}

proc random_int {} {
    return [expr {int(rand()*4294967296)}]
}

puts "INIT DONE"

# closing the service
#close_service master $claim_path

