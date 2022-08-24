@echo off
rem ----------------------------------------------------------------------------
rem  convert_sof_to_jic.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ----------------------------------------------------------------------------


echo "onverting .SOF to .JIC"
del /s /q .\out\SYNC_MM_PG_prj_128.jic
quartus_cpf -c -d EPCQ128 -s 5CGXFC4C7 .\out\PRJ_NAME.sof .\out\PRJ_NAME_128.jic

