@echo off
rem ------------------------------------------------------------------------------
rem  clean_vivado.bat
rem  published as part of https://github.com/pConst/basic_verilog
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem Use this file as a boilerplate for your custom clean script
rem for Vivado/Vitis projects


for /R %%f in (*.xpr) do (
  echo "Project name is %%~nf"

  del /s /f /q .\.Xil\*
  rmdir /s /q  .\.Xil\

  del /s /f /q .\%%~nf.cache\*
  rmdir /s /q  .\%%~nf.cache\

  del /s /f /q .\%%~nf.gen\*
  rmdir /s /q  .\%%~nf.gen\

  del /s /f /q .\%%~nf.hw\*
  rmdir /s /q  .\%%~nf.hw\

  del /s /f /q .\%%~nf.ip_user_files\*
  rmdir /s /q  .\%%~nf.ip_user_files\

  del /s /f /q .\%%~nf.runs\*
  rmdir /s /q  .\%%~nf.runs\

  del /s /f /q .\%%~nf.sim\*
  rmdir /s /q  .\%%~nf.sim\


  del /s /f /q .\*.jou
  del /s /f /q .\*.log
  del /s /f /q .\*.str
  del /s /f /q .\*.tmp
  del /s /f /q .\usage_statistics_webtalk.*

  del /s /f /q *.xsa

)

pause
goto :eof

