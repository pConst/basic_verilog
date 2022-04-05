# (C) 2001-2020 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# +---------------------------------------------------
# | Cut the async clear paths
# +---------------------------------------------------
set aclr_counter 0
set clrn_counter 0
set aclr_collection [get_pins -compatibility_mode -nocase -nowarn *|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|aclr]
set clrn_collection [get_pins -compatibility_mode -nocase -nowarn *|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn]
set aclr_counter [get_collection_size $aclr_collection]
set clrn_counter [get_collection_size $clrn_collection]

if {$aclr_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|aclr]
}

if {$clrn_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn]
}
