#------------------------------------------------------------------------------
# quartus_custom_eport.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Use this script as a boilerplate for custom reporting or report analisys
# for Intel Quartus IDE. Your custom messages will be reported in messages window
# after all normal compilation messages
#
# Script requires following QSF assignment
# set_global_assignment -name POST_FLOW_SCRIPT_FILE "quartus_sh:quartus_custom_report.tcl"
#
# This particular example finds for "Implicit Net warning" lines in mapping report


set file [open [lindex $argv 2]".map.rpt" r]

while {[gets $file line] != -1} {
  if {[string first "implicit" $line] != -1} {
    post_message $line
  }
}

close $file

