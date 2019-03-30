#------------------------------------------------------------------------------
# write_avalon_mm_from_file.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Use this script for writing bulk binary data from binary file to Avalon-MM through
#   JTAG-to-Avalon-MM bridge IP when using Quartus System Console
# To select the script press Ctrl+E in Quartus System Console

# Observed speed was around 8kbps

# The script expects you already have valid path to Avalon-MM jtag master
# stored in $claim_path variable. See "system_console_init.tcl" script


proc write_avalon_mm_from_file { filename } {
  upvar 1 claim_path claim_path

  set file [open $filename r]
  fconfigure $file -translation binary
  set rbf_len 4244820
  set data [read $file $rbf_len]
  close $file

  set db3 0
  set db2 0
  set db1 0
  set db0 0
  set i 0
  set b_str " kbytes done"
  while {$i < $rbf_len} {

    binary scan $data x${i}H2H2H2H2 db0 db1 db2 db3

    # puts 0x$db0$db1$db2$db3
    master_write_32 $claim_path 0x20 0x$db0$db1$db2$db3

    if { 0 == [ expr $i % 1024 ] } {
      puts $i$b_str
    }

    set i [expr $i+4]
  }
  puts "DONE!"

}
