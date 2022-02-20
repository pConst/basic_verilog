#!/bin/bash

#  check_numeric_filenames.sh
#  Konstantin Pavlov, pavlovconst@gmail.com
#
#  simple utility script is useful whe thew directory holds enumerated files and
#  you want to check that there is no missing files in the sequence


# serching filenames with pattrn "001*", "002*", "003*" and so on up to "905*"
# you get a prompt if any file is missing
for i in $(seq -f "%03g" 1 905)
do
   echo -n "$i "
   if test -n "$(find . -maxdepth 1 -name "$i *" -print -quit)"
   then
      echo "" #"exists"
   else
      echo "ERR: $i file doesn't exist"
   fi
done