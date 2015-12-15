# Run Quartus on all appropriate verilog files in the 
# directory

rm test.log
for des in `ls *.v | grep -v "test" | grep -v "_tb"`
do
  print Quartus Testing $des	
  short_des=`print $des | sed 's/\.v//g'`
  print $short_des
  quartus_map --family=stratixii $short_des >> test.log
done

grep "Error" test.log