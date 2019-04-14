#------------------------------------------------------------------------------
# post_flow.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Use this script as a boilerplate for custom reporting or report analisys
# for Intel Quartus IDE. Your custom messages will be reported in messages window
# after all normal compilation messages
#
# Script requires following QSF assignment
# set_global_assignment -name PROJECT_OUTPUT_DIRECTORY OUTPUT
# set_global_assignment -name POST_FLOW_SCRIPT_FILE "quartus_sh:post_flow.tcl"


#===============================================================================
# Set warning on implicit nets declaration
post_message "=== ERRORS ======================================================="
set file [open [join [list "./OUTPUT/" [lindex $argv 2] ".map.rpt"] ""] r]
while {[gets $file line] != -1} {
  if {[string first "implicit" $line] != -1} {
    post_message $line
  }
}
close $file

#===============================================================================
# compuiting elapsed time
post_message "=== COMPILE TIME ================================================="

set hs 0
set ms 0
set ss 0
set hs_t 0
set ms_t 0
set ss_t 0

set file [open [join [list "./OUTPUT/" [lindex $argv 2] ".map.rpt"] ""] r]
while {[gets $file line] != -1} {
  set time [string range $line 24 31]
  if {[string first "Info: Elapsed time:" $line] != -1} {
    post_message [ join [ list "map:   " $time ] "" ]
    scan $time "%d:%d:%d" hs ms ss
    set hs_t [expr {$hs_t + $hs} ]
    set ms_t [expr {$ms_t + $ms} ]
    set ss_t [expr {$ss_t + $ss} ]
  }
}
close $file


set file [open [join [list "./OUTPUT/" [lindex $argv 2] ".fit.rpt"] ""] r]
while {[gets $file line] != -1} {
  set time [string range $line 24 31]
  if {[string first "Info: Elapsed time:" $line] != -1} {
    post_message [ join [ list "fit:   " $time ] "" ]
    scan $time "%d:%d:%d" hs ms ss
    set hs_t [expr {$hs_t + $hs} ]
    set ms_t [expr {$ms_t + $ms} ]
    set ss_t [expr {$ss_t + $ss} ]
  }
}
close $file


set file [open [join [list "./OUTPUT/" [lindex $argv 2] ".asm.rpt"] ""] r]
while {[gets $file line] != -1} {
  set time [string range $line 24 31]
  if {[string first "Info: Elapsed time:" $line] != -1} {
    post_message [ join [ list "asm:   " $time ] "" ]
    scan $time "%d:%d:%d" hs ms ss
    set hs_t [expr {$hs_t + $hs} ]
    set ms_t [expr {$ms_t + $ms} ]
    set ss_t [expr {$ss_t + $ss} ]
  }
}
close $file


set file [open [join [list "./OUTPUT/" [lindex $argv 2] ".sta.rpt"] ""] r]
while {[gets $file line] != -1} {
  set time [string range $line 24 31]
  if {[string first "Info: Elapsed time:" $line] != -1} {
    post_message [ join [ list "sta:   " $time ] "" ]
    scan $time "%d:%d:%d" hs ms ss
    set hs_t [expr {$hs_t + $hs} ]
    set ms_t [expr {$ms_t + $ms} ]
    set ss_t [expr {$ss_t + $ss} ]
  }
}
close $file


while { $ss_t >= 60 } {
  set ss_t [expr $ss_t - 60]
  set ms_t [expr $ms_t + 1]
}
while { $ms_t >= 60 } {
  set ms_t [expr $ms_t - 60]
  set hs_t [expr $hs_t + 1]
}
post_message "----------------------------------"
post_message [ join [ list "TOTAL: " [format "%02d:%02d:%02d" $hs_t $ms_t $ss_t]] "" ]




