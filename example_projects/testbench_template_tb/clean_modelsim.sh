#! /usr/bin/env bash

# ------------------------------------------------------------------------------
#  clean_modelsim.sh
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
# ------------------------------------------------------------------------------
#
# Use this file as a boilerplate for your custom clean script
# for Modelsim projects


rm -rf work

rm transcript
rm wave.do
rm modelsim.ini
rm start_time.txt
rm vsim.wlf
rm vish_stacktrace.vstf

