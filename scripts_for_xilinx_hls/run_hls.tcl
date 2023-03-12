#------------------------------------------------------------------------------
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

# Create a project
open_project prj -reset
add_files src/hls_operator.cpp
add_files -tb src/hls_operator_tb.cpp
set_top hls_operator

# Create a solution
open_solution -reset sol1 -flow_target vitis
set_part {xcvu9p-flga2104-2-i}
create_clock -period 5 -name default

#csim_design
csynth_design
#cosim_design
#export_design -rtl verilog -format ip_catalog -output /home/kp/tmp

#export_design -flow syn -rtl verilog -format ip_catalog
#export_design -flow impl -rtl verilog -format ip_catalog

exit

