@echo off
rem ------------------------------------------------------------------------------
rem  setup_jtag_server_quartus.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem this a quick setup script to enable remote jtag connections in Quartus IDE
rem script must be executed with administrator privileges


cd C:\IntelFPGA\17.0\quartus\bin64

echo current jtag server status
jtagserver --status

echo enabling remote clients with password "aaa"
jtagconfig --enableremote aaa

echo enabling automatic start for jtag server
jtagserver --start

echo please restart your server computer now
echo then connect to the server from a client

pause
exit
