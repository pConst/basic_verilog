# Run Modelsim on all appropriate verilog files in the 
# directory

rm test.log
for des in `ls *_tb.v`  
do
  print Testing $des...	
  short_des=`print $des | sed 's/\.v//g'`
  print $short_des
 
  print onerror quit > test.do
  print onbreak resume > test.do
  print vlib work >> test.do
  print vlog d:/quartus/eda/sim_lib/altera_mf.v >> test.do
  print vlog d:/quartus/eda/sim_lib/stratixii_atoms.v >> test.do
  print vlog *.v >> test.do
  print vsim $short_des >> test.do
  print run -all >> test.do
  print quit >> test.do

  d:/modeltech_6.1d/win32/vsim -c -do test.do >> test.log 

done

grep -e "Error" -e "Mismatch" -e "PASS" test.log