#! /usr/bin/env bash
#------------------------------------------------------------------------------
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# Script to initialize HLS project solution and make CSYNTH compilation step
# see ../example_projects/vitis_hls_prj_template_v1/ for complete example



rm -rf ./prj/sol1/syn
rm -rf ./prj/sol1/impl

vitis_hls -f run_hls.tcl

# open top Verilog
subl ./prj/sol1/syn/verilog/hls_operator.v

# open main report
subl ./prj/sol1/syn/report/csynth.rpt

