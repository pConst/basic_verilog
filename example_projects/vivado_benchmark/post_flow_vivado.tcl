#------------------------------------------------------------------------------
# post_flow_vivado.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Use this script as a boilerplate for custom reporting or report analisys
# for Vivado IDE. Your custom messages will be reported in messages window
# after all normal compilation messages
#
# Set this script as a post.tcl for "Generate bitstream" step

#===============================================================================
# compuiting elapsed time
puts "=== COMPILE TIME ================================================="

set hs 0
set ms 0
set ss 0
set hs_t 0
set ms_t 0
set ss_t 0

scan [get_property STATS.ELAPSED [get_runs synth_1]] "%d:%d:%d" hs ms ss
puts [ join [ list "synth:   " [puts [format "%02d:%02d:%02d" $hs $ms $ss]] ] "" ]
set hs_t [expr {$hs_t + $hs} ]
set ms_t [expr {$ms_t + $ms} ]
set ss_t [expr {$ss_t + $ss} ]

scan [get_property STATS.ELAPSED [get_runs impl_1]] "%d:%d:%d" hs ms ss
puts [ join [ list "impl:    " [puts [format "%02d:%02d:%02d" $hs $ms $ss]] ] "" ]
set hs_t [expr {$hs_t + $hs} ]
set ms_t [expr {$ms_t + $ms} ]
set ss_t [expr {$ss_t + $ss} ]

while { $ss_t >= 60 } {
  set ss_t [expr $ss_t - 60]
  set ms_t [expr $ms_t + 1]
}
while { $ms_t >= 60 } {
  set ms_t [expr $ms_t - 60]
  set hs_t [expr $hs_t + 1]
}
puts "----------------------------------"
puts [ join [ list "TOTAL: " [format "%02d:%02d:%02d" $hs_t $ms_t $ss_t]] "" ]




