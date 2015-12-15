for sb in `ls` crypto/des crypto/aes crypto/rc4 crypto/sha \
	interlaken/interlaken_lane \
	interlaken/interlaken_common \
	interlaken/interlaken_if2 \
	interlaken/interlaken_if4 \
	interlaken/interlaken_if8 \
	interlaken/interlaken_4 \
	interlaken/interlaken_5 \
	interlaken/interlaken_8 \
	interlaken/interlaken_12 \
	interlaken/interlaken_19 \
	interlaken/interlaken_20 \
	ethernet/ethernet_fec \
	ethernet/ethernet_pcs 

do
  if [ -d $sb ] 
  then
    rm $sb/*.abo
    rm $sb/*.qsf 
    rm $sb/*.eqn
    rm $sb/*.sof 
    rm $sb/*.pof
    rm $sb/*.done 
    rm -rf $sb/work
    rm -rf $sb/db
    rm -rf $sb/incremental_db
    rm $sb/serv_req_info.txt
    rm $sb/*.rpt
    rm $sb/*.fabo
    rm $sb/*.summary
    rm $sb/*.qpf
    rm $sb/transcript
    rm $sb/vsim.wlf
    rm $sb/*.vstf
    rm $sb/*.rout
    rm $sb/ftm*.vec
    rm $sb/*.fad
    rm $sb/*.pin
    rm $sb/*.log
    rm $sb/*.qws
    rm $sb/*.bak 
    rm $sb/*.smsg
    rm $sb/*.ilk
    rm $sb/*.pdb
    rm $sb/*_debussy_*
    rm $sb/*.obj    
    rm $sb/*.exe
    rm $sb/*.exp
    rm $sb/*.lib
    rm $sb/*.dll
    rm $sb/*.mabo
    rm $sb/*.post_fit_netlist
    rm $sb/test.do
  fi
done

rm design_files.txt
rm tmp
