#------------------------------------------------------------------------------
# show_runs_progress.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Get current progress for every Vivado run that is currently running

set my_runs [get_runs]
puts "Progress:"

foreach run_i $my_runs {

  set status [get_property STATUS [get_runs $run_i]]

  if {[string match "Running*" $status]} {

    puts -nonewline "$run_i:  "
    puts -nonewline "$status, "
    puts -nonewline [file rootname [get_property PROGRESS [get_runs $run_i]]]
    puts "%"
  }
}

