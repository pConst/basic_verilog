@echo off
rem ------------------------------------------------------------------------------
rem  cp_recursively.bat
rem  published as part of https://github.com/pConst/basic_verilog
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem Use this script to walk through all subdirs and update files with
rem specific names to the latest version


echo INFO: =====================================================================
echo INFO: cp_recursively.bat
echo INFO: The script may sometimes take a long time to complete

for /R /d %%D in (*) do (

  rem echo %%~fD
  cd %%~fD

  if exist clean_recursively.bat cp -dv j:\basic_verilog\scripts\clean_recursively.bat .\clean_recursively.bat

  if exist clean_quartus.bat cp -dv j:\basic_verilog\scripts\clean_quartus.bat .\clean_quartus.bat
  if exist clean_vivado.bat cp -dv j:\basic_verilog\scripts\clean_vivado.bat .\clean_vivado.bat
  if exist clean_gowin.bat cp -dv j:\basic_verilog\scripts\clean_gowin.bat .\clean_gowin.bat
  if exist clean_modelsim.bat cp -dv j:\basic_verilog\scripts\clean_modelsim.bat .\clean_modelsim.bat

  if exist delay.sv cp -dv j:\basic_verilog\scripts\delay.sv .\delay.sv
  if exist edge_detect.sv cp -dv j:\basic_verilog\scripts\edge_detect.sv .\edge_detect.sv
)

pause
goto :eof

