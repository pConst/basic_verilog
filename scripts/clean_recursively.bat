@echo off
rem ------------------------------------------------------------------------------
rem  clean_recursively.bat
rem  published as part of https://github.com/pConst/basic_verilog
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem   Use this script to walk through all subdirs and execute cleaning scripts
rem   there. Place cleaning script in every sybdir that requires cleaning.
rem   Cleaning script names supported
rem         - clean.bat            (generic one)
rem         - clean_quartus.bat    (special script for quartus project dirs)
rem         - clean_vivado.bat     (special script for vivado project dirs)
rem         - clean_gowin.bat      (special script for gowin project dirs)
rem         - clean_modelsim.bat   (special script for modelsim testbench dirs)


echo INFO: =====================================================================
echo INFO: clean_recursively.bat
echo INFO: The script may sometimes take a long time to complete

for /R /d %%D in (*) do (

  rem echo %%~fD
  cd %%~fD

  if exist clean.bat @echo | call clean.bat
  if exist clean_quartus.bat @echo | call clean_quartus.bat
  if exist clean_vivado.bat @echo | call clean_vivado.bat
  if exist clean_gowin.bat @echo | call clean_gowin.bat
  if exist clean_modelsim.bat @echo | call clean_madelsim.bat
)

pause
goto :eof

