// readme for "scripts_for_intel_hls" directory   
// published as part of https://github.com/pConst/basic_verilog   
// Konstantin Pavlov, pavlovconst@gmail.com   


The directory contains automation scripts to work with Intel HLS technology on Windows machines.

My setup includes:
  * Intel Quartus Prime 18.0 Standard Edition
  * Mentor Modelsim Intel edition that comes with Quartus 
  * Microsoft Visual Studio 10 x64  

Don't hesitate meaningless (at the first glance) sctipt names. It is done on purpose to speedup commandline typing.


b.bat is an universal b[uild] script template for HLS components. Place the script at your HLS project directory. You may specify your FPGA target, desired HLS component clock and other options. Run it by typing "b q[Enter]" in terminal window after HLS initialization (see i.bat description below).

There are several options to select build type
* e[mulation] - perform HLS component  emulation with standard i++ compiler
* s[imulation] - perform HLS component simulation in Modelsim
* m[svc] - perform HLS component emulation with Visual Studio compiler instead of standard i++
* c[lean] - clean generated files, for example, before committing
* r[eport] - show HLS component report in your browser
* v[sim] - open "vsim.wlf" file in Modelsim
* q[uartus] - perform HLS component compilation in Quartus


build_recursively.bat is a recursive compilation entry-point script in case you have multiple components in your project and you want to compile them all


i.bat - helper script to perform HLS initialization. See instruction comments inside


README.md - this file


test.cpp - common HLS component template to start with


