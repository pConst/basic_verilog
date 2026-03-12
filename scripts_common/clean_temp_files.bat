 @echo off
rem ------------------------------------------------------------------------------
rem  clean_temp_files.bat
rem  published as part of https://github.com/pConst/basic_verilog
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem Utility script to clean temporary files directories

 echo Cleaning temporary files...
 
 del /q /f /s %temp%\*.*
 del /q /f /s %localappdata%\Temp\*.*
 del /q /f /s %windir%\temp\*.*
 echo DONE
 
 pause
 
 