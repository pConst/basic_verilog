#! /usr/bin/env bash

#  update_git_repos.sh
#  Konstantin Pavlov, pavlovconst@gmail.com
#
#  Simple script to update all git repos in the current directory
#
#  ===========================================================================
#  !!   CAUTION! All repos will be reset and all uncommitted changes lost   !!
#  ===========================================================================

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

eval $(ssh-agent)
ssh-add

find . -maxdepth 2 -type d -exec git -C {} reset --hard \;
find . -maxdepth 2 -type d -exec git -C {} submodule init \;
find . -maxdepth 2 -type d -exec git -C {} submodule update \;

find . -maxdepth 2 -type d -exec echo {} '  ' \; -exec git -C {} pull \;
