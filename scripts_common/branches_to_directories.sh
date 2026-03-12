#! /usr/bin/env bash

# ------------------------------------------------------------------------------
#  branches_to_directories.sh
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
# ------------------------------------------------------------------------------
#
# Script for flattening git branches
# Every branch becomes local directory
#
# Run the script from git repo root
#

# pre clean
rm -rf ../branches
mkdir -p ../branches/remotes/origin/

for branch in `git branch -a | grep remotes `; do
  #git branch --track ${branch#remotes/origin/} $branch

  git checkout -f $branch
  echo $branch
  #read -p "Checkout done"

  mkdir ../branches/$branch/
  cp -r * ../branches/$branch/
  #read -p "Copy done"

done

