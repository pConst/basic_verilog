#------------------------------------------------------------------------------
# project_version_auto_increment.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Auto-incrementing project version generator script for Quartus IDE
# Stores version in binary format in "version.bin" file
# Exports updated "version.vh" define file every time compilation begins
#
# Script generates "./SOURCE/version.vh" header that could bу included into the
# project. Definitions from that file, like version number, or random seed value
# are accessible from your application logic
#
# Script requires following QSF assignment
# set_global_assignment -name PRE_FLOW_SCRIPT_FILE "quartus_sh:project_version.tcl"
# set_global_assignment -name VERILOG_FILE version.vh


#===============================================================================
# Incrementing and printing current SOF version
post_message "=== VERSION ======================================================"
set data 0
set ver 0
set ver_hi 0
set ver_lo 0

set ver_filename "version.bin"

#if dev id file exists, version will be auto-incremented
#if not, project will be bit-to-bit identical to last compilation state
#this is also useful for automatic build configuration
set dev_filename "../_i_am_a_dev"

# reading version
if { [file exists $ver_filename] } {
  set file [open $ver_filename "r"]
  fconfigure $file -translation binary
  set data [read $file 2]
  binary scan $data H4 ver
  set ver 0x${ver}
  close $file
}

# incrementing version
if { [file exists $dev_filename] } {
  post_message "Sucess finding dev id file. Incrementing version"
set ver [expr $ver + 1 ]
} else {
  post_message "Failed finding dev id file. Project version preserved"
}
set ver_hi [expr $ver / 256 ]
set ver_lo [expr $ver % 256 ]

post_message [ join [ list "Current project version: " [format %d $ver ] ] "" ]
post_message [ join [ list "Version HIGH byte: 0x" [format %02x $ver_hi ] ] "" ]
post_message [ join [ list "Version LOW byte: 0x" [format %02x $ver_lo ] ] "" ]

if { [file exists $dev_filename] } {
# generating random value that changes every new compilation
set rand_hi [expr {int(rand()*4294967296)}]
set rand_lo [expr {int(rand()*4294967296)}]

post_message [ join [ list "Random seed: 0x" \
                         [format %04x $rand_hi ] \
                         [format %04x $rand_lo ] ] "" ]

# writing new version
set file [open $ver_filename "w"]
fconfigure $file -translation binary
set data [binary format S1 $ver]
puts -nonewline $file $data
close $file

# generating version.vh define file
set def_filename "version.vh"

post_message "Generating version.vh define file"
set file [open $def_filename "w"]
puts $file "// version.vh"
puts $file "// This file is auto-generated. Please dont edit manually"
  puts $file "// Project version and random seed value are auto-incremented"
  puts $file "// every time compilation begins"
  puts $file ""
  puts $file "// Update: Version auto-increment is turned off by default"
  puts $file "// to support for automatic compilation"
  puts $file ""
  puts $file "// To turn on version auto-increment on the developers machine - "
  puts $file "// create an empty file named '../_i_am_a_dev'"
  puts $file "// (the path is referred to the project folder) "
  puts $file ""
  puts $file "// Please don`t add dev id file to version control so that anyone"
  puts $file "// else get a bit-to-bit copy of your compilation result"
puts $file ""
puts $file [ join [ list "`define VERSION_HIGH 8'h" [format %02x $ver_hi ] ] "" ]
puts $file [ join [ list "`define VERSION_LOW 8'h" [format %02x $ver_lo ]] "" ]
puts $file ""
puts $file [ join [ list "`define RAND_SEED 64'h" \
                         [format %04x $rand_hi ] \
                         [format %04x $rand_lo ] ] "" ]
puts $file ""
close $file

