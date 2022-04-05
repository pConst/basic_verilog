#!/usr/bin/env python
# coding: utf-8

# author: Konstantin Pavlov
# published as part of https://github.com/pConst/basic_verilog
# email:  pavlovconst@gmail.com

# boilerplate script to generate ASCII hex files to initialize RAMs in Verilog

import math
import os

# settings =====================================================================
N = 1024
tablename = "1024sin"
filename = tablename + ".mem"

# main =========================================================================
if os.path.exists(filename):
  os.remove(filename)
  print("Old file version removed")

f = open(filename, "x")
#f.write("// ascii hex file for " + tablename + " function\n\n")

for i in range(0, N):
    # computing and scaling
    rad = math.pi/4/N*i
    val = round(math.sin(rad) * 65535)
    # formatting to HEX string of specified length
    val_str = format(val, "#06x")
    # additional prefix
    prefix_str = format(i, "#06x")
    # cutting '0x' prefix away
    f.write(prefix_str[2:] + "_" + val_str[2:] + "\n")

f.close()

