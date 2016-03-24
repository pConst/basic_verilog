#!sh
for i in ../test/*rmh;
do
echo $i
rm compare3_tb.vcd; make compare3_tb.vcd TEST_FILE=$i TEST_CYCLES=5000 TEST_IRQ=1000;
done
