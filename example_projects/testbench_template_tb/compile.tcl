#------------------------------------------------------------------------------
# compile.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Modelsim/Questa compile script
# based on "ModelSimSE general compile script version 1.1" by Doulos

# launch the script by "vsim -do compile.tcl" command on linux
# or by "modelsim.exe -do compile.tcl" on windows


# Simply change the project settings in this section
# for each new project. There should be no need to
# modify the rest of the script.
set library_file_list {

  work {main_tb.sv
        sim_clk_gen.sv
        clk_divider.sv
        edge_detect.sv
        delay.sv}
}

set vsim_params "-L altera_mf_ver -L altera_mf -L lpm_ver -L lpm"

set top_level work.main_tb

set suppress_err_list 0

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
        vlog $file -suppress $suppress_err_list
      }
      set last_compile_time 0
    }
  }
}
set last_compile_time $time_now

# Load the simulation
eval vsim -voptargs=+acc $vsim_params $top_level

# Load saved wave patterns
do wave.do

# Run the simulation
run 100us

wave zoom range 0 1us

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

