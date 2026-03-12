@echo off
rem ----------------------------------------------------------------------------
rem  git_pull_subdirs.bat
rem  published as part of https://github.com/pConst/basic_verilog
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ----------------------------------------------------------------------------

rem Use this script to walk through all subdirs and perform git pull there

rem  ===========================================================================
rem  !!   CAUTION! All repos will be reset and all uncommitted changes lost   !!
rem  ===========================================================================

echo INFO: =====================================================================
echo INFO: git_pull_subdirs.bat
echo INFO: The script may sometimes take a long time to complete

for /R /d %%D in (*) do (

  rem echo %%~fD
  cd %%~fD

  if exist .git (

    rem Skip pulling submodules
    if not exist ../.gitmodules (

      echo:
      echo %%~fD
      rem git reset --hard

      rem git submodule init
      rem git submodule update
      rem git fetch --all

      rem git pull --recurse-submodules --all
      git pull --all
    )
  )
)

pause
goto :eof

