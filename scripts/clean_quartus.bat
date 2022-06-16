@echo off
rem ------------------------------------------------------------------------------
rem  clean_quartus.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem   Use this file as a boilerplate for your custom clean script
rem   for Quartus projects


for /R %%f in (*.qpf) do (
  echo "Project name is %%~nf"

  rem Common junk files
  del /s /q .\%%~nf.qws
  del /s /q .\c5_pin_model_dump.txt
  del /s /q .\%%~nf.ipregen.rpt
  del /s /f /q .\.qsys_edit\*
  rmdir /s /q .\.qsys_edit\
  del /s /q .\%%~nf_assignment_defaults.qdf

  rem Compilation databases
  del /s /f /q .\db\*
  rmdir /s /q .\db\
  del /s /f /q .\incremental_db\*
  rmdir /s /q .\incremental_db\
  del /s /f /q .\greybox_tmp\*
  rmdir /s /q .\greybox_tmp\

  rem Output directory
  del /s /f /q .\out\*
  rmdir /s /q .\out\
  del /s /f /q .\output\*
  rmdir /s /q .\output\
  del /s /f /q .\OUTPUT\*
  rmdir /s /q .\OUTPUT\

  rem Design space explorer files
  del /s /f /q .\dse\*
  rmdir /s /q .\dse\
  del /s /q .\dse1_base.qpf
  del /s /q .\dse1_base.qsf
  del /s /q .\%%~nf.dse.rpt
  del /s /q .\%%~nf.archive.rpt

  rem Early power estimator files
  del /s /q .\%%~nf_early_pwr.csv

)

pause
goto :eof
