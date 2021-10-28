@echo off
rem ------------------------------------------------------------------------------
rem  find_large_files.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

forfiles /s /c "cmd /c if @fsize GTR 1000000000 echo @path"
 
pause
exit
