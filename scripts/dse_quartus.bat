@echo off
rem ------------------------------------------------------------------------------
rem  dse_quartus.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem   This script runs DSE (Quartus Design Space Explorer)
rem   compilation from commandline
rem   Prior to run the script - open DSE and setup your discovery

SET PROJ=MY_PROJECT_NAME

quartus_dse ^
 --terminate off ^
 --num-parallel-processors 8 ^
 --auto-discover-files on ^
 --revision %PROJ% ^
 %PROJ%.qpf ^
 --use-dse-file %PROJ%.dse
 
pause
exit
