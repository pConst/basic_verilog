#! /usr/bin/env bash

#  update_from_ref.sh
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#
#  Updates all copies of files to the last reference version


cd ..
pp=$(pwd)


# $1 - reference file
update () {

  find . -type f -name $(basename -- "$1") -print0 | while IFS= read -r -d '' fp; do
    fpr=$(readlink -f $fp)

    if [ "$fpr" != "$1" ]; then

      echo -n $fpr

      if cmp -s $1 $fpr; then
        echo "  - OK"
      else
        echo "  - DIFFER"
      fi

    fi

  done
}


echo $pp
echo "========================================================================="
update $pp/scripts/clean_vivado.bat

echo "========================================================================="
update $pp/scripts/clean_quartus.bat

