#! /usr/bin/env bash

# ------------------------------------------------------------------------------
#  clean_vivado.sh
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
# ------------------------------------------------------------------------------
#
# Use this file as a boilerplate for your custom clean script
# for Xilinx Vivado projects


rm -rf .Xil
rm -rf *.cache
rm -rf *.hw
rm -rf *.gen
rm -rf *.ip_user_files
rm -rf *.runs
rm -rf *.sim

find /*.srcs/sources*/bd/ -type f -not -name '*.xci' -delete
find /*.srcs/sources*/ip/ -type f -not -name '*.xci' -delete

rm -f .ioplanning
rm -f *.jou
rm -f *.log
rm -f *.str
rm -f *.tmp
rm -f usage_statistics_webtalk.*

rm -f *.xsa

