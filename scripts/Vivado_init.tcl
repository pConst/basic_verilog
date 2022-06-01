#------------------------------------------------------------------------------
# Vivado_init.tcl
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Initialization script for Vivado that adds some useful tweaks and should
#   improve project compile time, especially for Windows OSes
#
# Place this script to the directory
# Windows : %APPDATA%/Xilinx/Vivado/<VivadoVersion>/scripts/Vivado_init.tcl
# Linux   : $HOME/.Xilinx/Vivado/<VivadoVersion>/scripts/Vivado_init.tcl
#
# and double-check that Vivado imports exactly the file from the path

# setting maximum allowed thread limit (1 to 8)
set_param synth.maxThreads 8


# setting maximum allowed thread limit (1 to 32)
set_param general.maxThreads 16


# allow_undefined_ports
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]


# allow_wors
set_param synth.elaboration.rodinMoreOptions "rt::set_parameter compatibilityMode true"


# jtag_to_axi_master

# value should be 8 HEX digits == 32bit
proc jwr {address value} {
    #set address [string range $address 2 [expr {[string length $address]-1}]]
    create_hw_axi_txn -force wr_tx [get_hw_axis hw_axi_1] \
                            -address $address -data $value -len 1 -type write
    run_hw_axi -quiet wr_tx
}

proc jrd {address} {
    #set address [string range $address 2 [expr {[string length $address]-1}]]
    create_hw_axi_txn -force rd_tx [get_hw_axis hw_axi_1] \
                                          -address $address -len 1 -type read
    run_hw_axi -quiet rd_tx
    return 0x[get_property DATA [get_hw_axi_txn rd_tx]]
}


# compuiting time spent for the project compilation
proc el_time {} {
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
    puts ""
}

# compuiting fmax, in MHz, given target clock in MHz
proc fmax {target_clock} {
    open_run impl_1
    puts [ join [ list \
        [expr round(1e3/((1e3/$target_clock)-[get_property SLACK [get_timing_paths]]))] \
        " MHz" ] "" ]
    puts ""
}

# export hardware for Vitis IDE
proc eh {} {
    write_hw_platform -fixed -force -include_bit -file ./main.xsa
    puts ""
}

