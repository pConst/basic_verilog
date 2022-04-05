@echo off
rem ------------------------------------------------------------------------------
rem  program_de10.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

echo "Listing programmers"
C:\intelFPGA\18.0\quartus\bin64\quartus_pgm -l

echo "Programming FPGA"
C:\intelFPGA\18.0\quartus\bin64\quartus_pgm -c ^
 "DE-SoC [USB-1]" -m jtag -o ^
 "P;%~dp0out\test.sof@2"

pause
exit
