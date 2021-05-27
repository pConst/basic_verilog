@echo off
rem ------------------------------------------------------------------------------
rem  hard_clean_modelsim.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

del /s /f /q .\work\*
rmdir /s /q .\work\

del /s /f /q .\modelsim.ini
del /s /f /q .\start_time.txt
del /s /f /q .\transcript
del /s /f /q .\vsim.wlf

pause
exit
