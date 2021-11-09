@echo off
rem ------------------------------------------------------------------------------
rem  build_recursively.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem   Use this script to walk through all subdirs and execute build scripts
rem   there. Place build script in every subdir that requires build


echo INFO: =====================================================================
echo INFO: build_recursively.bat
echo INFO: The script may sometimes take a long time to complete
for /R %%f in (*) do (
  echo %%f | findstr /C:".git" >nul & if ERRORLEVEL 1 (

    echo %%f | findstr /C:"b\.bat" >nul & if ERRORLEVEL 1 (
      rem
    ) else (
      pushd %%~df%%~pf
      echo %%~df%%~pf
      @echo | call %%f f
      popd
    )

  )
)

pause
goto :eof

