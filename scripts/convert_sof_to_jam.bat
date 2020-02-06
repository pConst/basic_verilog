@echo off
rem ------------------------------------------------------------------------------
rem  convert_sof_to_jam.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

echo "Converting .SOF to .JAM"
quartus_cpf -c PRJ_NAME.sof PRJ_NAME.jam
pause
exit
