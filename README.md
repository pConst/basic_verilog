# basic_verilog
### Some basic must-have verilog modules

(licensed under CC BY-SA 4_0)

Author: Konstantin Pavlov, pavlovconst@gmail.com


### CONTENTS:

* **/Advanced Synthesis Cookbook/**   - useful code from Altera's cookbook
* **/KCPSM6_Release9_30Sept14/**    - Xilinx's Picoblaze soft processor
* **/pacoblaze-2.2/**   - version of Picoblaze adapted for Altera devices

* **/scripts/**   - useful TCL scripts
* **/scripts/compile.tcl**   - Modelsim no-project-mode compile script
* **/scripts/quartus_custom_report.tcl**   - custom reporting or report analisys for Intel Quartus IDE
* **/scripts/quartus_system_console_init.tcl**   - initialization script for reading/writing Avalon-MM through JTAG-to-Avalon-MM bridge IP
* **/scripts/write_avalon_mm_from_file.tcl**   - writing bulk binary data from binary file to Avalon-MM through JTAG-to-Avalon-MM bridge IP

* **main_tb.sv**   - basic testbench template

* **ActionBurst**   - multichannel one-shot triggering module
* **ActionBurst2**    - multichannel one-shot triggering with variable steps module
* **bin2pos**   - converts binary coded value to positional (one-hot) code
* **clk_divider**    - wide reference clock divider
* **debounce**    - two-cycle debounce for input buttons
* **dynamic_delay**    - dynamic delay for arbitrary input signal made on general-purpose trigger elements
* **edge_detect**    - edge detector, gives one-tick pulses on every signal edge
* **encoder**   - digital encoder input logic module
* **fifo**    - single-clock FIFO buffer (queue) implementation
* **NDivide**   - primitive integer divider
* **lifo**   - single-clock LIFO buffer (stack) implementation
* **leave_one_hot**   - leaves only lowest hot bit in vector
* **PulseGen**    - generates pulses with given width and delay
* **pos2bin**   - converts positional (one-hot) value to binary representation
* **reset_set**    - SR trigger variant w/o metastable state, set dominates here
* **reverse_vector**    - reverses signal order within multi-bit bus
* **set_reset**    - SR trigger variant w/o metastable state, reset dominates here
* **spi_master**    - universal spi master module
* **delay**    - static delay for arbitrary input signal made on Xilinx`s SRL16E primitives. Also serves as input synchronizer, a standard way to get rid of metastability issues
* **UartRx**    - straightforward yet simple UART receiver implementation for FPGA written in Verilog
* **UartTx**    - straightforward yet simple UART transmitter implementation for FPGA written in Verilog
* **UartRxExtreme**   - extreme minimal UART receiver implementation for FPGA written in Verilog
* **UartTxExtreme**   - extreme minimal UART transmitter implementation for FPGA written in Verilog


Also added testbenches for selected modules

