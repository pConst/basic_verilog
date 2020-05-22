@echo off
rem ------------------------------------------------------------------------------
rem  clean_quartus.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem   Use this file as a boilerplate for your custom clean script
rem   for Quartus projects

SET PROJ=MY_PROJECT_NAME

rem Common junk files
del /s /q .\%PROJ%.qws
del /s /q .\c5_pin_model_dump.txt

rem Compilation databases
del /s /f /q .\db\*
rmdir /s /q .\db\
del /s /f /q .\incremental_db\*
rmdir /s /q .\incremental_db\

rem Output directory
del /s /f /q .\OUTPUT\*
rmdir /s /q .\OUTPUT\

rem Design space explorer files
del /s /f /q .\dse\*
rmdir /s /q .\dse\
del /s /q .\dse1_base.qpf
del /s /q .\dse1_base.qsf
del /s /q .\%PROJ%.dse.rpt
del /s /q .\%PROJ%.archive.rpt

rem Early power estimator files
del /s /q .\%PROJ%_early_pwr.csv

pause
exit
