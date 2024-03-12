#------------------------------------------------------------------------------
# opt_design.tcl
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

  opt_design -directive ExploreWithRemap
  opt_design -aggressive_remap -resynth_remap -propconst -bufg_opt -mbufg_opt

