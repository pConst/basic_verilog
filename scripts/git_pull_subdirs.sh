#! /usr/bin/env bash

#  git_pull_subdirs.sh
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#
#  Simple script to update all git repos in the current directory
#
#  ===========================================================================
#  !!   CAUTION! All repos will be reset and all uncommitted changes lost   !!
#  ===========================================================================


eval $(ssh-agent)
ssh-add

pp=$(pwd)

#find . -maxdepth 1 -type d -print0 | while IFS= read -r -d '' fp; do
find . -type d -print0 | while IFS= read -r -d '' fp; do
  cd "$fp"
  if [ -d "./.git" ]; then

    echo
    echo "==================================================================="
    echo "Working in $fp"
    echo "==================================================================="

    git config --replace-all core.filemode false

    #git reset --hard

    git pull --recurse-submodules --all
    #git submodule init
    git submodule update --recursive
  fi
  cd "$pp"
done

