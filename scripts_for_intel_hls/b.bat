@echo off
rem ----------------------------------------------------------------------------
rem  b.bat
rem  build script for Intel High Level Synthesis projects for Windows
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ----------------------------------------------------------------------------

setlocal enabledelayedexpansion


set "COMPONENT=test"

set "FPGA_SERIES=CycloneV"
set "FPGA_CLOCK=100MHz"

set "SOURCE_FILES=test.cpp"
set "HLS_CXX_FLAGS=-v --debug-log"


for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set Z_DATE=%%c-%%a-%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set Z_TIME=%%a-%%b)
echo DBG: start timestamp is %Z_DATE%_%Z_TIME%
set "Z_PATH="C:\Program Files\7-Zip\7z.exe""
echo DBG: 7z.exe path is %Z_PATH%

:: Accept the user's target, else default to e[mulation]
if not "%1"=="" (
  set "TARGET=%1"
) else (
  set "TARGET=e"
  echo No target specified, defaulting to !TARGET!
  echo Available targets: e[mulation], s[imulation], m[svc], c[lean], r[eport], v[sim], q[uartus]
)
echo DBG: target is !TARGET!

:: Any tools installed with HLS can be found relative to the location of i++
for %%I in (i++.exe) do (
  set "HLS_INSTALL_DIR=%%~dp$PATH:I"
)
set "HLS_INSTALL_DIR=%HLS_INSTALL_DIR%.."
echo DBG: HLS_INSTALL_DIR is %HLS_INSTALL_DIR%

set "TARGET_INIT=!TARGET!"

:: Set up the compile variables
if "!TARGET!" == "e" (
  :: Dont gesitate that FPGA_FAMILY is shown as Arria 10 here.
  :: This is just an emulation anyway
  call :clean_e_subroutine

  set "CXX=i++"
  set "CXXFLAGS=%HLS_CXX_FLAGS% -march=x86-64"
  set "LFLAGS=-o !TARGET!.exe"
)

if "!TARGET!" == "s" (
  call :clean_s_subroutine

  set "CXX=i++"
  set "CXXFLAGS=%HLS_CXX_FLAGS% --clock %FPGA_CLOCK% -ghdl -march=%FPGA_SERIES%
  set "LFLAGS=-o !TARGET!.exe"
)

if "!TARGET!" == "q" (
  ::Dont make special project folder for Quartus
  set "INIT_TARGET=q"
  set "TARGET=s"
  echo DBG: target is !TARGET!

  call :clean_s_subroutine

  set "CXX=i++"
  set "CXXFLAGS=%HLS_CXX_FLAGS% --clock %FPGA_CLOCK%  --quartus-compile -ghdl -march=%FPGA_SERIES%
  set "LFLAGS=-o !TARGET!.exe"
)

if "!TARGET!" == "m" (
  ::Dont make special project folder for VC
  set "TARGET=s"
  echo DBG: target is !TARGET!

  call :clean_s_subroutine

  set "CXX=cl"
  set "CXXFLAGS=/I ""%HLS_INSTALL_DIR%\include"" /nologo /EHsc /wd4068 /DWIN32 /MD"
  set "LFLAGS=/link ""/libpath:%HLS_INSTALL_DIR%\host\windows64\lib"" hls_emul.lib /out:!TARGET!.exe"
)

if "!TARGET!" == "c" (
  call :clean_all_subroutine
  goto:eof
)

if "!TARGET!" == "r" (
  call :open_report_subroutine
  goto:eof
)

if "!TARGET!" == "v" (
  if exist ".\s.prj\verification\vsim.wlf" (
  echo:
    echo DBG: vsim.wlf file - open in Mdelsim
    modelsim.exe -view ".\s.prj\verification\vsim.wlf" -do "add wave -position insertpoint vsim:/tb/%COMPONENT%_inst/*"
    rem @pause
  ) else (
    echo:
    echo ERR: =================================
    echo ERR:  vsim.wlf file - doesn`t exist !
    echo ERR: =================================
  )
  goto:eof
)

::set "OBJ=%SOURCE_FILES:cpp=o%"

:: Replace "" with " in the flags
set "CXXFLAGS=%CXXFLAGS:""="%"
set "LFLAGS=%LFLAGS:""="%"

:: Kick off the compile
echo DBG: executing %CXX% %CXXFLAGS% %SOURCE_FILES% %LFLAGS%
%CXX% %CXXFLAGS% %SOURCE_FILES% %LFLAGS%
if not ERRORLEVEL 0 (
  echo:
  echo ERR: ======================
  echo ERR:  COMPILATION FAILED !
  echo ERR: ======================
  exit /b 1
)

::echo %CXX% %CXXFLAGS% --x86-only  %SOURCE_FILES% %LFLAGS%
::%CXX% %CXXFLAGS% --x86-only -c %SOURCE_FILES% %LFLAGS%

::echo %CXX% %CXXFLAGS% --fpga-only -c %SOURCE_FILES% %LFLAGS%
::%CXX% %CXXFLAGS% --fpga-only -c %SOURCE_FILES% %LFLAGS%

:: Execute the test
echo:
echo DBG: Executing the test
call !TARGET!.exe
if not ERRORLEVEL 0 (
  echo:
  echo ERR: ==============
  echo ERR:  RUN FAILED !
  echo ERR: ==============
  exit /b 1
)

if "%TARGET_INIT%" == "q" (
  echo:
  echo DBG: Quartus timing
  findstr /r /c:"Analysis & Synthesis ; 0" %~dp0s.prj\quartus\quartus_compile.flow.rpt
  findstr /r /c:"Partition Merge      ; 0" %~dp0s.prj\quartus\quartus_compile.flow.rpt
  findstr /r /c:"Fitter               ; 0" %~dp0s.prj\quartus\quartus_compile.flow.rpt
  findstr /r /c:"Fitter               ; 0" %~dp0s.prj\quartus\quartus_compile.flow.rpt
  findstr /r /c:"Timing Analyzer      ; 0" %~dp0s.prj\quartus\quartus_compile.flow.rpt
  findstr /r /c:"Total                ; 0" %~dp0s.prj\quartus\quartus_compile.flow.rpt

  echo:
  call :open_report_subroutine
)

:: Make a backup
echo:
echo DBG: Making a backup
:: enabledelayedexpansion turned on. With this mode, ! symbols have special
:: meaning, and to make matters more interesting, there are two parse passes
:: on each line, meaning you'll need to double escape them to have the symbol
:: pass through to the target application
%Z_PATH% a -t7z .\backup\%Z_DATE%_%Z_TIME%.7z *.* -x^^!backup | findstr /I "Add"
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set Z_DATE=%%c-%%a-%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set Z_TIME=%%a-%%b)
echo DBG: end timestamp is %Z_DATE%_%Z_TIME%
echo DBG: Recipe done
goto:eof


:clean_all_subroutine
  call :clean_e_subroutine
  call :clean_s_subroutine
exit /b

:clean_e_subroutine
  del /S /F /Q e.exe > NUL
  echo DBG: Cleaning emulation done
exit /b

:clean_s_subroutine
  del /S /F /Q m.exe s.exe s.prj > NUL
  rmdir /S /Q s.prj > NUL
  echo DBG: Cleaning simulation done
exit /b

:open_report_subroutine
  echo DBG: Opening the report
  start "" .\s.prj\reports\report.html
exit /b

