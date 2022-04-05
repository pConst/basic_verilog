#!/bin/bash

#  mem_writer.sh
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#
#  generates a bunch of .mem files to test block memory initialization
#
#  see also for "./scripts/mem_writer_adv.py" for advanced
#    functional memory file generator


# linear file contents =========================================================
# looping file len
for l in 16 32 64 128 256 512 1024 2048 4096 65536
do
  # looping element width, in bits
  for w in 8 16 32
  do
    # calculating padded hex string width
    ws=$((w/8))
    # skipping erroneous widths
    if (( l <= 16 ** ${ws} )); then
      rm -rf ${l}x${w}bit_linear.mem
      # generating strings to the file
      for (( s=0; s <= ${l}-1; s++ ))
      do
        printf "%0${ws}X\n" ${s} >> ${l}x${w}bit_linear.mem
      done
    fi
  done
done


# ramdom file contents =========================================================
# looping file len
for l in 16 32 64 128 256 512 1024 2048 4096 65536
do
  # looping element width, in bits
  for w in 8 16 32
  do
    # calculating padded hex string width
    ws=$((w/8))
    # skipping erroneous widths
    if (( l <= 16 ** ${ws} )); then
      rm -rf ${l}x${w}bit_random.mem
      # generating strings to the file
      for (( s=0; s <= ${l}-1; s++ ))
      do
        printf "%0${ws}X\n" $(($RANDOM % (2 ** ${w}) )) >> ${l}x${w}bit_random.mem
      done
    fi
  done
done

printf "DONE\n"
