@echo off
rem ------------------------------------------------------------------------------
rem  iverilog_compile.bat
rem  Konstantin Pavlov, pavlovconst@gmail.com
rem ------------------------------------------------------------------------------

rem creating VVP file
  C:\iverilog\bin\iverilog.exe -Wall -g2012 -o iverilog_sim.vvp -s main_tb ^
        main_tb.sv ^
        ..\main.sv ^
        clk_divider.sv ^
        c_rand.v ^
        delay.sv ^
        edge_detect.sv

rem creating VCD file
  C:\iverilog\bin\vvp.exe -v iverilog_sim.vvp

rem creating settings file for gtkwave on-the-fly
  echo fontname_waves Verdana 9 > .\gtkwaverc
  echo fontname_signals Verdana 9 >> .\gtkwaverc
  echo fontname_logfile Verdana 9 >> .\gtkwaverc
  echo splash_disable 1 >> .\gtkwaverc
  echo use_roundcaps 1 >> .\gtkwaverc
  echo force_toolbars 1 >> .\gtkwaverc
  echo left_justify_sigs 1 >> .\gtkwaverc

rem launching gtkwave
rem press CTRL+S to save vawe config. gtkwave will open it automatically next time
  start C:\iverilog\gtkwave\bin\gtkwave.exe ^
        -r .\gtkwaverc ^
        iverilog_sim.vcd ^
        wave.gtkw

rem   // place this code into your testbench and add signals you want to dump
rem   //   and navigate during simulation
rem   initial begin
rem     $dumpfile("iverilog_sim.vcd");
rem     $dumpvars( 0, M );
rem     #10000 $finish;
rem   end

pause
exit
