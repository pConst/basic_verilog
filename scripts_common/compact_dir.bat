@echo off
rem ------------------------------------------------------------------------------
rem  compact_dir.bat
rem  published as part of https://github.com/pConst/basic_verilog
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem Signaficantly decrease NTFS directory size on Windows 10 etc. 
rem Copy the script to target directory, for example, C:\Xilinx to C:\intelFPGA, and run

compact /c /s /a /i /exe:lzx

pause
goto :eof

