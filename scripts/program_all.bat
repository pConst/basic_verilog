@echo off
rem ------------------------------------------------------------------------------
rem  program_all.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

echo "Listing programmers"
C:\intelFPGA_lite\17.0\quartus\bin64\quartus_pgm -l

echo "Programming first FPGA in the chain"
C:\intelFPGA_lite\17.0\quartus\bin64\quartus_pgm -c ^
 "USB-Blaster on 192.168.0.182 [USB-1]" -m jtag -o ^
 "P;%~dp0out\main.sof@1"

echo "Programming second FPGA in the chain"
C:\intelFPGA_lite\17.0\quartus\bin64\quartus_pgm -c ^
 "USB-Blaster on 192.168.0.182 [USB-1]" -m jtag -o ^
 "P;%~dp0out\main.sof@2"

pause
exit
