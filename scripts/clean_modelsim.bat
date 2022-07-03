@echo off
rem ------------------------------------------------------------------------------
rem  clean_quartus.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem   Use this file as a boilerplate for your custom clean script
rem   for Modelsim projects

del /s /q .\transcript
del /s /q .\wave.do
del /s /q .\modelsim.ini
del /s /q .\start_time.txt
del /s /q .\vsim.wlf
del /s /q .\vish_stacktrace.vstf

del /s /f /q .\work\*
rmdir /s /q .\work\

pause
goto :eof
