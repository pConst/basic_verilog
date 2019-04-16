#------------------------------------------------------------------------------
# project_version.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Auto-incrementing project version generator script for Quartus IDE
# Stores version in binary format in "version.bin" file
# Exports updated "version.vh" define file every time compilation begins
#
# Script requires following QSF assignment
# set_global_assignment -name PRE_FLOW_SCRIPT_FILE "quartus_sh:project_version.tcl"
# set_global_assignment -name VERILOG_FILE version.vh

post_message "=== PROJECT VERSION =============================================="

set data 0
set ver 0
set ver_hi 0
set ver_lo 0

#file mkdir "./DEBUG"
set ver_filename "version.bin"

# reading version
if { [file exists $ver_filename] } {
  set file [open $ver_filename "r"]
  fconfigure $file -translation binary
  set data [read $file 2]
  binary scan $data H4 ver
  set ver 0x${ver}
  close $file
}

# converting signed to unsigned
# set ver [expr $ver & 0xFFFF];

# incrementing version
set ver [expr $ver + 1 ]
set ver_hi [expr $ver / 256 ]
set ver_lo [expr $ver % 256 ]

post_message [ join [ list "Current project version: " [format %d $ver ] ] "" ]
post_message [ join [ list "Version HIGH byte: 0x" [format %02x $ver_hi ] ] "" ]
post_message [ join [ list "Version LOW byte: 0x" [format %02x $ver_lo ] ] "" ]

# writing new version
set file [open $ver_filename "w"]
fconfigure $file -translation binary
set data [binary format S1 $ver]
puts -nonewline $file $data
close $file

# generating version.vh define file
#file mkdir "./SOURCES"
set def_filename "version.vh"

post_message "Generating version.vh define file"
set file [open $def_filename "w"]
puts $file "// version.vh"
puts $file "// This file is auto-generated. Please dont edit manually"
puts $file "// Project version is auto-incremented every time compilation begins"
puts $file ""
puts $file [ join [ list "`define VERSION_HIGH 8'h" [format %02x $ver_hi ] ] "" ]
puts $file [ join [ list "`define VERSION_LOW 8'h" [format %02x $ver_lo ]] "" ]
close $file

