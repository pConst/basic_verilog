#------------------------------------------------------------------------------
# jtag_to_axi_master.tcl
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# INFO ------------------------------------------------------------------------
# Use this script to read/write AXI bus through "JTAG to AXI Master" IP-core

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

