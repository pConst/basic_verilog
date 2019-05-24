#------------------------------------------------------------------------------
# compile.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Modelsim compile script
# based on "ModelSimSE general compile script version 1.1" by Doulos

# launch the script by "vsim -do compile.tcl" command on linux
# or by "modelsim.exe -do compile.tcl" on windows


# Simply change the project settings in this section
# for each new project. There should be no need to
# modify the rest of the script.
set library_file_list {

  work {fifo_tb.sv
        fifo.sv
        test.vo
        c_rand.v
        edge_detect.sv
        clk_divider.sv}
}

        ../../c_rand.v
        ../../edge_detect.sv
        ../../delay.sv
        ../../clk_divider.sv}
}

set vsim_params "-L altera_mf_ver -L altera_mf -L lpm_ver -L lpm"
# add these parameters when simulating Quartus netlists
# "+transport_int_delays +transport_path_delays -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver"

set top_level work.fifo_tb

# Console commands:
# r = Recompile changed and dependent files
# rr = Recompile everything
# q = Quit without confirmation

# After sourcing the script from ModelSim for the
# first time use these commands to recompile.
proc r  {} {uplevel #0 source compile.tcl}
proc rr {} {global last_compile_time
            set last_compile_time 0
            r                            }
proc q  {} {quit -force                  }

#Does this installation support Tk?
set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

# Prefer a fixed point font for the transcript
set PrefMain(font) {Courier 10 roman normal}

# Compile out of date files
set time_now [clock seconds]
if [catch {set last_compile_time}] {
  set last_compile_time 0
}
foreach {library file_list} $library_file_list {
  vlib $library
  vmap work $library
  foreach file $file_list {
    if { $last_compile_time < [file mtime $file] } {
      if [regexp {.vhdl?$} $file] {
        vcom -93 $file
      } else {
        vlog $file
      }
      set last_compile_time 0
    }
  }
}
set last_compile_time $time_now

# Load the simulation
eval vsim $top_level $vsim_params

# Load saved wave patterns
do wave.do

# Run the simulation
run 100us

wave zoom range 0 100us

# How long since project began?
if {[file isfile start_time.txt] == 0} {
  set f [open start_time.txt w]
  puts $f "Start time was [clock seconds]"
  close $f
} else {
  set f [open start_time.txt r]
  set line [gets $f]
  close $f
  regexp {\d+} $line start_time
  set total_time [expr ([clock seconds]-$start_time)/60]
  puts "Project time is $total_time minutes"
}

