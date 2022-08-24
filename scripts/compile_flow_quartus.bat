@echo off
rem ----------------------------------------------------------------------------
rem  compile_flow_quartus.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ----------------------------------------------------------------------------

rem The simplest way to compile Quartus project from commandline


for /R %%f in (*.qpf) do (
  echo "Project name is %%~nf"

  quartus_sh --flow compile %%~nf
)
echo "DONE!"

pause
exit
