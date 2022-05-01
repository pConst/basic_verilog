#------------------------------------------------------------------------------
# get_fmax_vivado.tcl
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------


fmax 1000

# compuiting fmax, in MHz, given target clock in MHz
proc fmax {target_clock} {
    open_run impl_1
    puts [ join [ list \
        [expr round(1e3/((1e3/$target_clock)-[get_property SLACK [get_timing_paths]]))] \
        " MHz" ] "" ]
    puts ""
}

