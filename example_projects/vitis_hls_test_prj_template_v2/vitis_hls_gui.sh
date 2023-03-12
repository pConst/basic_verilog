#! /usr/bin/env bash

#------------------------------------------------------------------------------
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# Script to open Vitis HLS GUI
# see ../example_projects/vitis_hls_prj_template_v1/ for complete example

if [ ! -d "./prj" ]; then
  source vitis_hls_csynth.sh
fi

nohup vitis_hls -p prj &> /dev/null & disown

