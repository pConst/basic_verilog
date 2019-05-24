@echo off
rem ------------------------------------------------------------------------------
rem  init_system_console.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem
rem  This is a support script for launching Quartus system-console
rem    in console mode with user-defined initialization script
rem ------------------------------------------------------------------------------

@echo on
C:\intelFPGA_lite\17.0\quartus\sopc_builder\bin\system-console.exe --rc_script="J:\dev\system_console_init.tcl" --cli
