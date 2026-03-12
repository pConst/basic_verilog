#! /bin/bash

# ------------------------------------------------------------------------------
#  remove_dup_dirs.sh
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
# ------------------------------------------------------------------------------

#  Utility script to iterate through all subdirectories in the working directory
#  and try to find duplicate subdirectories in selected location.
#  Duplicate subdirs in selected location will be removed

shopt -s nullglob

for dir in */
do
  #echo "-- Inspecting $dir"

  if [ -d "$1$dir" ]; then
    #echo "= $1$dir"
    rm -rfv $1$dir
  else
    echo "unique"
  fi

done
