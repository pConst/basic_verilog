#------------------------------------------------------------------------------
# set_project_directory.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Sets the working directory to the project so that if you generate files they
# are writen to the directory
#
# Place this script as a pre-tcl-script for "Synthesis" step

set work_directory [get_property DIRECTORY [current_project]]
cd $work_directory
puts -nonewline "Changing Directory to " ; pwd
