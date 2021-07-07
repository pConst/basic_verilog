Must-have verilog systemverilog modules
---------------------------------------

Hello! This is a collection of verilog systemverilog synthesizable modules.<br>
All the code is highly reusable across typical FPGA projects and mainstream FPGA vendors.<br>
Please feel free to contact me in case you found any code issues.<br>
Also, give me a pleasure, tell me if the code has got succesfully implemented in your hobby, scientific or industrial projects!<br>

Konstantin Pavlov, pavlovconst@gmail.com

The code is licensed under CC BY-SA 4_0.<br>
You can remix, transform, and build upon the material for any purpose, even commercially<br>
You must provide the name of the creator and distribute your contributions under the same license as the original<br>

Directories description:
-----------------------

| DIRECTORY | DESCRIPTION |
|-----------|-------------|
| Advanced Synthesis Cookbook/ | useful code from Altera's cookbook |
| KCPSM6_Release9_30Sept14/ | Xilinx's Picoblaze soft processo |
| pacoblaze-2.2/ | version of Picoblaze adapted for Altera devices |
| example_projects/ | FPGA project examples |
| benchmark_projects/ | compilation time benchmarks for a dosen of FPGA types |
| scripts/ | useful TCL scripts |

Scripts description:
--------------------

| SCRIPT | DESCRIPTION |
|--------|-------------|
| scripts/allow_undefined_ports.tcl | allows generation of test projects with undefined pins for Vivado IDE |
| scripts/compile_quartus.tcl | boilerplate script for commandline project compilation in Quartus IDE |
| scripts/convert_sof_to_jam.bat | Altera/Intel FPGA configuration file converter |
| scripts/convert_sof_to_rbf.bat | another Altera/Intel FPGA configuration file converter |
| scripts/iverilog_compile.tcl | complete script to compile Verilog sources with iverilog tool and run simulation in gtkwave tool |
| scripts/modelsim_compile.tcl | Modelsim no-project-mode compilation script |
| scripts/post_flow_quartus.tcl | custom reporting or report analisys for Intel Quartus IDE |
| scripts/post_flow_vivado.tcl | custom reporting or report analisys for Xilinx Vivado IDE |
| scripts/program_all.bat | command line programmer example for Altera/Intel FPGAs |
| scripts/project_version_auto_increment.tcl | project version autoincrement script for Quartus IDE |
| scripts/quartus_system_console_init.tcl | initialization script for reading/writing Avalon-MM through JTAG-to-Avalon-MM bridge IP |
| scripts/set_project_directory.tcl | changes current directory to match project directory in Vivado IDE |
| scripts/write_avalon_mm_from_file.tcl | writing bulk binary data from binary file to Avalon-MM through JTAG-to-Avalon-MM bridge IP |

Modules description:
--------------------
 
| MODULE | DESCRIPTION |
|--------|-------------|
| ActionBurst.v | multichannel one-shot triggering module |
| ActionBurst2.v | multichannel one-shot triggering with variable steps |
| adder_tree.sv | adding multiple values together in parallel |
| bin2gray.sv | combinational Gray code to binary converter |
| bin2pos.sv | converts binary coded value to positional (one-hot) code |
| clk_divider.sv | wide reference clock divider |
| debounce.v | two-cycle debounce for input buttons |
| delay.sv | useful module to make static delays or to synchronize across clock domains |
| dynamic_delay.sv | dynamic delay for arbitrary input signal |
| edge_detect.sv | combinational edge detector, gives one-tick pulses on every signal edge |
| encoder.v | digital encoder input logic module |
| fifo_single_clock_reg_*.sv | single-clock FIFO buffer (queue) implementation |
| gray2bin.sv | combinational binary to Gray code converter |
| leave_one_hot.sv | combinational module that leaves only lowest hot bit |
| lifo.sv | single-clock LIFO buffer (stack) implementation |
| main_tb.sv | basic testbench template |
| NDivide.v | primitive integer divider |
| pos2bin.sv | converts positional (one-hot) value to binary representation |
| pos2bin.sv | converts positional (one-hot) value to binary representation |
| prbs_gen_chk.sv | PRBS pattern generator or checker |
| pulse_gen.sv | generates pulses with given width and delay |
| pulse_stretch.sv | configurable pulse stretcher/extender module |
| reset_set.sv | SR trigger variant w/o metastable state, set dominates here |
| reverse_bytes.sv | reverses bytes order within multi-byte array |
| reverse_vector.sv | reverses signal order within multi-bit bus |
| set_reset.sv | SR trigger variant w/o metastable state, reset dominates here |
| spi_master.sv | universal spi master module |
| UartRx.v | straightforward yet simple UART receiver |
| UartTx.v | straightforward yet simple UART transmitter  |
| uart_rx_shifter.sv | UART-like receiver shifter for simple synchronous messaging inside the FPGA or between FPGAs |
| uart_rx_shifter.sv | UART-like receiver shifter for simple synchronous messaging inside the FPGA or between FPGAs |
| UartRxExtreme.v | extreme minimal UART receiver implementation |
| UartTxExtreme.v | extreme minimal UART transmitter implementation |

Also added testbenches for selected modules
