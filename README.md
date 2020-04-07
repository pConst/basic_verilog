# basic_verilog
### Some basic must-have verilog modules

(licensed under CC BY-SA 4_0)

Author: Konstantin Pavlov, pavlovconst@gmail.com

### CONTENTS:

* **/Advanced Synthesis Cookbook/**   - useful code from Altera's cookbook
* **/KCPSM6_Release9_30Sept14/**    - Xilinx's Picoblaze soft processor
* **/pacoblaze-2.2/**   - version of Picoblaze adapted for Altera devices


* **/scripts/**   - useful TCL scripts
* **/scripts/allow_undefined_ports.tcl**   - allows generation of test projects with undefined pins for Vivado IDE
* **/scripts/compile_quartus.tcl**   - boilerplate script for commandline project compilation in Quartus IDE
* **/scripts/convert_sof_to_jam.bat**   - Altera/Intel FPGA configuration file converter
* **/scripts/convert_sof_to_rbf.bat**   - another Altera/Intel FPGA configuration file converter
* **/scripts/iverilog_compile.tcl**   - complete script to compile Verilog sources with iverilog tool and run simulation in gtkwave tool
* **/scripts/modelsim_compile.tcl**   - Modelsim no-project-mode compilation script
* **/scripts/post_flow_quartus.tcl**   - custom reporting or report analisys for Intel Quartus IDE
* **/scripts/post_flow_vivado.tcl**   - custom reporting or report analisys for Xilinx Vivado IDE
* **/scripts/program_all.bat**   - command line programmer example for Altera/Intel FPGAs
* **/scripts/project_version_auto_increment.tcl**   - project version autoincrement script for Quartus IDE
* **/scripts/quartus_system_console_init.tcl**   - initialization script for reading/writing Avalon-MM through JTAG-to-Avalon-MM bridge IP
* **/scripts/set_project_directory.tcl**   - changes current directory to match project directory in Vivado IDE
* **/scripts/write_avalon_mm_from_file.tcl**   - writing bulk binary data from binary file to Avalon-MM through JTAG-to-Avalon-MM bridge IP


* **main_tb.sv**   - basic testbench template


* **ActionBurst**   - multichannel one-shot triggering module
* **ActionBurst2**    - multichannel one-shot triggering with variable steps
* **adder_tree**    - adding multiple values together in parallel
* **bin2gray**   - combinational Gray code to binary converter
* **bin2pos**   - converts binary coded value to positional (one-hot) code
* **clk_divider**    - wide reference clock divider
* **debounce**    - two-cycle debounce for input buttons
* **delay**    - VERY USEFUL MODULE to make static delays or to synchronize across clock domains
* **dynamic_delay**    - dynamic delay for arbitrary input signal
* **edge_detect**    - combinational edge detector, gives one-tick pulses on every signal edge
* **encoder**   - digital encoder input logic module
* **fifo**    - single-clock FIFO buffer (queue) implementation
* **gray2bin**    - combinational binary to Gray code converter
* **leave_one_hot**    - combinational module that leaves only lowest hot bit
* **lifo**   - single-clock LIFO buffer (stack) implementation
* **NDivide**   - primitive integer divider
* **pos2bin**   - converts positional (one-hot) value to binary representation
* **pos2bin**   - converts positional (one-hot) value to binary representation
* **prbs_gen_chk**   - PRBS pattern generator or checker
* **pulse_gen**    - generates pulses with given width and delay
* **pulse_stretch**    - configurable pulse stretcher/extender module
* **reset_set**    - SR trigger variant w/o metastable state, set dominates here
* **reverse_bytes**    - reverses bytes order within multi-byte array
* **reverse_vector**    - reverses signal order within multi-bit bus
* **set_reset**    - SR trigger variant w/o metastable state, reset dominates here
* **spi_master**    - universal spi master module
* **UartRx**    - straightforward yet simple UART receiver implementation for FPGA written in Verilog
* **UartTx**    - straightforward yet simple UART transmitter implementation for FPGA written in Verilog
* **UartRxExtreme**   - extreme minimal UART receiver implementation for FPGA written in Verilog
* **UartTxExtreme**   - extreme minimal UART transmitter implementation for FPGA written in Verilog


Also added testbenches for selected modules

