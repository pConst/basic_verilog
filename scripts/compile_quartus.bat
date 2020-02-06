@echo off
rem ------------------------------------------------------------------------------
rem  compile_quartus.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem Boilerplate script for commandline project compilation in Quartus IDE



cd /d D:\FPGA_PRJ

rem C:\intelFPGA\17.0\quartus\bin64\quartus_sh ^
quartus_sh -t "./DEBUG/pre_flow.tcl" compile FPGA_PRJ FPGA_PRJ
if %ERRORLEVEL% NEQ 0 GOTO fatal_end

quartus_map ^
 --read_settings_files=on ^
 --write_settings_files=off ^
 --64bit ^
 FPGA_PRJ -c FPGA_PRJ
rem dont use --effort=fast because it can dramatically increase fitting time
if %ERRORLEVEL% NEQ 0 GOTO fatal_end

quartus_cdb ^
 --read_settings_files=on ^
 --write_settings_files=off ^
 --64bit ^
 FPGA_PRJ -c FPGA_PRJ
if %ERRORLEVEL% NEQ 0 GOTO fatal_end

quartus_fit ^
 --read_settings_files=off ^
 --write_settings_files=off ^
 --inner_num=1 --one_fit_attempt=on --pack_register=off ^
 --effort=fast --64bit ^
 FPGA_PRJ -c FPGA_PRJ
rem use --io_smart_recompile for secondary fitter launches
if %ERRORLEVEL% NEQ 0 GOTO fatal_end

quartus_asm ^
 --read_settings_files=off ^
 --write_settings_files=off ^
 --64bit ^
 FPGA_PRJ -c FPGA_PRJ
if %ERRORLEVEL% NEQ 0 GOTO fatal_end

rem quartus_sta FPGA_PRJ -c FPGA_PRJ
rem if %ERRORLEVEL% NEQ 0 GOTO fatal_end

quartus_sh -t "./DEBUG/post_flow.tcl" compile FPGA_PRJ FPGA_PRJ
if %ERRORLEVEL% NEQ 0 GOTO fatal_end

:fatal_end
pause
exit
