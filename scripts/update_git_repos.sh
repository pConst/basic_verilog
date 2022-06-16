#! /usr/bin/env bash

#  update_git_repos.sh
#  Konstantin Pavlov, pavlovconst@gmail.com
#
#  Simple script to update all git repos in the current directory
#
#  ===========================================================================
#  !!   CAUTION! All repos will be reset and all uncommitted changes lost   !!
#  ===========================================================================
#
#  see git_pull_subdirs.bat for mode convinient and clever script variant
#

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

eval $(ssh-agent)
ssh-add

find . -type d -exec echo {} '  ' \; -exec git -C {} reset --hard \;
find . -type d -exec echo {} '  ' \; -exec git -C {} pull --recurse-submodules --all \;
