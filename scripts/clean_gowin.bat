@echo off
rem ------------------------------------------------------------------------------
rem  clean_gowin.bat
rem  published as part of https://github.com/pConst/basic_verilog
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem   Use this file as a boilerplate for your custom clean script
rem   for Gowin IDE projects


rem preserving .\impl\gwsynthesis\test.prj file
del /s /f /q .\impl\gwsynthesis\*.html
del /s /f /q .\impl\gwsynthesis\*.xml
del /s /f /q .\impl\gwsynthesis\*.log
del /s /f /q .\impl\gwsynthesis\*.vg

del /s /f /q .\impl\pnr\*
rmdir /s /q  .\impl\pnr\

del /s /f /q .\impl\temp\*
rmdir /s /q  .\impl\temp\

del /s /f /q .*.gprj.user

pause
goto :eof

