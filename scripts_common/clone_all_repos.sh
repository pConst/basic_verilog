#!/bin/bash

# ------------------------------------------------------------------------------
#  clone_all_repos.sh
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
# ------------------------------------------------------------------------------

#  Utility script to clone all repos from the list

REPOS_FILE="repos.txt"

while IFS= read -r url; do
    #echo $url
    git clone --recursive "$url"
done < "$REPOS_FILE"

echo "DONE"

