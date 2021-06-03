#------------------------------------------------------------------------------
# allow_wors.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Simple script to add wor type support in Vivado
# Add this script as a tcl.pre for the Synthesis step

set_param synth.elaboration.rodinMoreOptions "rt::set_parameter compatibilityMode true"