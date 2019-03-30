@echo off
rem ------------------------------------------------------------------------------
rem  convert_sof_to_fbf.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

echo "Converting .SOF to .RBF"
quartus_cpf -c PRJ_NAME.sof PRJ_NAME.rbf
pause
exit
