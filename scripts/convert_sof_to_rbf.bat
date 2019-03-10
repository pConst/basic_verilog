@echo off
rem ------------------------------------------------------------------------------
rem  convert_sof_to_fbf.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

echo "Converting .SOF to .RBF"
quartus_cpf -c PIN400_CC_dummy.sof PIN400_CC_dummy.rbf
pause
exit