#! /usr/bin/env bash

#------------------------------------------------------------------------------
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# Script to perform HLS IP synthesis
# see ../example_projects/vitis_hls_prj_template_v1/ for complete example

if [ ! -d "./prj" ]; then
  source vitis_hls_csynth.sh
fi

if (vitis_hls -eval 'export_design -flow syn -rtl verilog -format ip_catalog' | grep --color -P "ERROR:|") ; then

    # open top Verilog
    subl ./prj/sol1/syn/verilog/hls_operator.v

    # open main report
    subl ./prj/sol1/impl/report/verilog/hls_operator_export.rpt
    subl ./prj/sol1/impl/report/verilog/export_syn.rpt
fi

