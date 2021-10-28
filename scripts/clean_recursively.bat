@echo off
rem ------------------------------------------------------------------------------
rem  clean_recursively.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem   Use this script to walk through all subdirs and execute cleaning scripts
rem   there. Place cleaning script in every sybdir that requires cleaning.
rem   Cleaning script names supported
rem         - clean.bat            (custom one)
rem         - clean_quartus.bat    (special script for quartus project dirs)
rem         - clean_vivado.bat     (special script for vivado project dirs)
rem         - clean_modelsim.bat   (special script for modelsim testbench dirs)


echo INFO: =====================================================================
echo INFO: clean_recursively.bat
echo INFO: The script may sometimes take a long time to complete
for /R %%f in (*) do (
  echo %%f | findstr /C:".git" >nul & if ERRORLEVEL 1 (

    echo %%f | findstr /C:"clean\.bat" >nul & if ERRORLEVEL 1 (
      rem
    ) else (
      pushd %%~df%%~pf
      echo %%~df%%~pf
      @echo | call %%f
      popd
    )

    echo %%f | findstr /C:"clean\_quartus\.bat" >nul & if ERRORLEVEL 1 (
      rem
    ) else (
      pushd %%~df%%~pf
      echo %%~df%%~pf
      @echo | call %%f
      popd
    )

    echo %%f | findstr /C:"clean\_vivado\.bat" >nul & if ERRORLEVEL 1 (
      rem
    ) else (
      pushd %%~df%%~pf
      echo %%~df%%~pf
      @echo | call %%f
      popd
    )

    echo %%f | findstr /C:"clean\_modelsim\.bat" >nul & if ERRORLEVEL 1 (
      rem
    ) else (
      pushd %%~df%%~pf
      echo %%~df%%~pf
      @echo | call %%f
      popd
    )
  )
)

pause
goto :eof

