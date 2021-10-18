# Back-annotation script.  Version 1.3.  Janary 16th, 2012.  by Ryan Scoville
# To run, make sure Quartus II project is closed, and type at command prompt: 
# quartus_cdb -t ba.tcl

###### User Variables #######
# Variable project_name is the name of the .qpf without the extension.  Also can be "auto_find".
set project_name "auto_find" 

# Wildcard or list of wild cards that nodes must match in order to be back-annotated.  Case sensitive.
set name_wildcards {*}

# Wildcard or list of wilcards that node location must match in order to be back-annotated.  Examples:
# set location_wildcards {PIN_*} ;# Locks down all the top-level I/O ports
# set location_wildcards {M9K* M144K* M20K*} ;# Locks down all the hard memory blocks for Stratix IV/V.
# set location_wildcards {DSP*} ;# Locks down all the DSP blocks
# set location_wildcards {PLL*} ;# Locks down all the PLL Locations
# set location_wildcards {CLKCTRL_*} ;# Locks down all the clock trees
set location_wildcards {*}

# The following demotes specific location assignments like FF_X34_Y22_N4 to X34_Y22, i.e. to the LAB.  This should not hurt timing and gives
# flexibility to the router.  Currently only demotes location names matching FF_, LABCELL_ and MLABCELL_, which are used in 28nm families.  Older
# families may not work as they have different location naming conventions.
set demote_logic_location_to_LAB 1

# Assignment appended with this comment, making it easier to find/sort/delete these assignments in the .qsf and especially the Assignment Editor
set comment from_ba.tcl

# If debug set to 1, "puts" the assignments into a file called ba_assignments.tcl, but does not modify the project in any way.
# The assignments can then be copied into the .qsf, or the ba_assignments.tcl can be sourced from within Quartus.  This will append assignments if ba_assignments.tcl already exists.
set debug 1
##############################

##### Usage #######
# This script back-annotates nodes in a design based on name and location wildcards that the user chooses.  
# Note that Quartus II Assignments -> Back-Annotate from the menu already allows the user to lock down top-level ports in the design, or everything.  This
# script provides a little more control.  In general, it is not recommended to lock down a large number of nodes inside the FPGA.  Node names often change
# during synthesis, and locking down portions of the design can limit what the fitter can do.  The original intent of this script is to allow the user to
# lock down all the memories and DSP in a design.  Theoretically, after doing a seed sweep and locking down the memories and DSP of the best result,
# the user can "anchor" the fitter into getting similar results.  Of course this is design dependent.  (The design I ran it on had less variation and on average gave
# better results than the un-anchored compiles, but the very best result was from the unanchored seed sweep.)
# I have also used this script to quickly lock down PLLs and global clock trees.  I am sure user's will find their own applications.  Incremental Compilation
# is recommended for locking down hierarchies of the design.
###################

proc demote_logic_to_LAB {loc} {
	if {[regexp {^(FF_X)([0-9]+)(_Y)([0-9]+)} $loc a b x_loc d y_loc]} {
		set loc "X$x_loc\_Y$y_loc"
	} elseif {[regexp {^(LABCELL_X)([0-9]+)(_Y)([0-9]+)} $loc a b x_loc d y_loc]} {
		set loc "X$x_loc\_Y$y_loc"
	} elseif {[regexp {^(MLABCELL_X)([0-9]+)(_Y)([0-9]+)} $loc a b x_loc d y_loc]} {
		set loc "X$x_loc\_Y$y_loc"
	}
	return $loc
}

############################################
# Auto find the project name to open, if there is only one project in the directory(which is good practice...)
if {$project_name == "auto_find"} {
	set qpf [glob *.qpf]
	set num_quartus_projects [llength $qpf]
	if {$num_quartus_projects == 0} {
		puts "There is no .qpf in this directory.  No project to open."
	} elseif {$num_quartus_projects == 1} {
		set project_name [file rootname $qpf]
	} else {
		puts "There is more than one *.qpf in this project: $qpf"
		puts "Open remove_qip_from_project.tcl, uncomment line 1, and change project_name from auto_find to .qpf name.  For example, if project is called my_top.qpf, set line 1 to:"
		puts "set project_name my_top.qpf"
		exit
	}	
} elseif {![file exists "$project_name\.qpf"]} {
	puts "Variable project_name was set to $project_name, but $project_name\.qpf could not be found in directory."
	exit
}
project_open $project_name -current_revision ;# -force  ;# In one case I needed to use -force option even though opening with same version of Quartus.  


load_package chip_planner
read_netlist

set_batch_mode on

if {$debug == 1} {
	set outfile [open ba_assignments.tcl a]
}

set matched_nodes 0
set assign_name ""
set assign_loc ""

# User name match wildcards often have [] in their name, but that has special meaning when doing a "string match $wildcard name".  
# The following replaces [ with \[ and ] with \] so it works.
set newname_wildcards ""
foreach name $name_wildcards {
	regsub -all {]} $name {\]} name
	regsub -all {\[} $name {\[} name
	lappend newname_wildcards $name
}

set all_nodes [get_nodes -type all]
foreach_in_collection node $all_nodes {
	set node_name [get_node_info -node $node -info name]
	set node_loc [get_node_info -node $node -info "Location String"]
	set name_matches 0
	set loc_matches 0
#puts $outfile "$node_name $node_loc"
	foreach name $newname_wildcards {
		if {[string match $name $node_name]} {
			set name_matches 1
#puts $outfile "     name=$name"
#puts $outfile "node_name=$node_name"
			break
		}
	}
	foreach loc $location_wildcards {
		if {[string match $loc $node_loc]} {
			set loc_matches 1
			break
		}
	}	
	if {($name_matches == 1) && ($loc_matches)} {
#puts $outfile "MATCH!!!!"
		set assign_name $node_name
		set assign_loc $node_loc
		if {$demote_logic_location_to_LAB} {
			set assign_loc [demote_logic_to_LAB $assign_loc]
		}
		incr matched_nodes
		if {$debug == 1} {
			puts $outfile "set_location_assignment $assign_loc -to $assign_name -comment $comment"
		} elseif {$debug == 0} {
			set_location_assignment $assign_loc -to $assign_name -comment $comment
		} else {
			puts {Errors:  Variable debug was not "1" or "0"}
			break
		}
	}
}
puts "Found $matched_nodes nodes that match name $name_wildcards and location $location_wildcards."
if {$debug == 1} {
	puts $outfile "#Found $matched_nodes nodes that match name $name_wildcards and location $location_wildcards."
	close $outfile
}

set_batch_mode off
project_close

