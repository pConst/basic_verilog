#------------------------------------------------------------------------------
# post_flow_quartus.tcl
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
# Printing current SOF version
post_message "=== VERSION ======================================================"
set data 0
set ver 0
set ver_hi 0
set ver_lo 0

#file mkdir "./DEBUG"
set ver_filename "./DEBUG/version.bin"

# reading version
if { [file exists $ver_filename] } {
  set file [open $ver_filename "r"]
  fconfigure $file -translation binary
  set data [read $file 2]
  binary scan $data H4 ver
  set ver 0x${ver}
  close $file
}

set ver_hi [expr $ver / 256 ]
set ver_lo [expr $ver % 256 ]

post_message [ join [ list "Current project version: " [format %d $ver] ] "" ]
post_message [ join [ list "Version HIGH byte: 0x" [format %02x $ver_hi] ] "" ]
post_message [ join [ list "Version LOW byte: 0x" [format %02x $ver_lo] ] "" ]

#===============================================================================
# copying sof file to archieve
post_message "=== SOF ARCHIEVE ================================================="
set sof_dir "./OUTPUT/"
set sof_arch_dir "./SOF_ARCHIEVE/"
set sof_filename [join [list [lindex $argv 2] ".sof"] ""]
set new_sof_filename [join [list [lindex $argv 2] "_v" [format %02x $ver_hi] [format %02x $ver_lo] ".sof"] ""]

if { [file exists ${sof_dir}${sof_filename}] } {
  if { [file exists ${sof_arch_dir}] } {
    if { [file exists ${sof_arch_dir}${new_sof_filename}] } {
    post_message "Copying existing .sof file to archieve directory"
    file copy ${sof_dir}${sof_filename} ${sof_arch_dir}
    post_message "Adding version identifier to archieved .sof file"
    file rename ${sof_arch_dir}${sof_filename} ${sof_arch_dir}${new_sof_filename}
    } else {
      post_message "Destination .sof file already exists. Copying to archieve cancelled"
    }
  }
}

#===============================================================================
# copying OUTPUT dir to archieve
post_message "=== OUTPUT ARCHIEVE ================================================="
set out_dir "./OUTPUT/"
set out_arch_dir "./OUTPUT_ARCHIEVE/"
set new_out_dirname [join [list "OUTPUT_v" [format %02x $ver_hi] [format %02x $ver_lo] ] ""]

if { [file exists ${out_dir}] } {
  if { [file exists ${out_arch_dir}] } {
    if { [file exists ${out_arch_dir}${new_out_dirname}] } {
      post_message "Destination OUTPUT archeive already exists. Copying to archieve cancelled"
    } else {
      post_message "Copying existing OUTPUT directory to archieve"
      exec cp -r ${out_dir} ${out_arch_dir}${new_out_dirname}
    }
  }
}

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

set filename [join [list "./OUTPUT/" [lindex $argv 2] ".map.rpt"] ""]
if { [file exists $filename] } {
  set file [open $filename r]
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
}


set filename [join [list "./OUTPUT/" [lindex $argv 2] ".fit.rpt"] ""]
if { [file exists $filename] } {
  set file [open $filename r]
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
}

set filename [join [list "./OUTPUT/" [lindex $argv 2] ".asm.rpt"] ""]
if { [file exists $filename] } {
  set file [open $filename r]
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
}

# timequest execution time for newer versions of Quartus
set filename [join [list "./OUTPUT/" [lindex $argv 2] ".sta.rpt"] ""]
if { [file exists $filename] } {
  set file [open $filename r]
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
}

# classic timing analizer execution time for older versions of Quartus
set filename [join [list "./OUTPUT/" [lindex $argv 2] ".tan.rpt"] ""]
if { [file exists $filename] } {
  set file [open $filename r]
  while {[gets $file line] != -1} {
    set time [string range $line 24 31]
    if {[string first "Info: Elapsed time:" $line] != -1} {
      post_message [ join [ list "tan:   " $time ] "" ]
      scan $time "%d:%d:%d" hs ms ss
      set hs_t [expr {$hs_t + $hs} ]
      set ms_t [expr {$ms_t + $ms} ]
      set ss_t [expr {$ss_t + $ss} ]
    }
  }
  close $file
}

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

