#! /usr/bin/env bash

#------------------------------------------------------------------------------
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# Script to export HLS component to Vivado IP catalog
# see ../example_projects/vitis_hls_prj_template_v1/ for complete example

if [ ! -d "./prj" ]; then
  source vitis_hls_csynth.sh
fi

vitis_hls -eval 'export_design -rtl verilog -format ip_catalog'

