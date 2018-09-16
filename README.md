# basic_verilog
### Some basic must-have verilog modules
(licensed under CC BY-SA 4_0)


### CONTENTS:

* **/Advanced Synthesis Cookbook/**   - useful code from Altera's cookbook
* **/KCPSM6_Release9_30Sept14/**    - Xilinx's Picoblaze soft processor
* **/pacoblaze-2.2/**   - version of Picoblaze adapted for Altera devices

* **Main_tb.v**   - basic testbench template

* **ActionBurst**   - multichannel one-shot triggering module
* **ActionBurst2**    - multichannel one-shot triggering with variable steps module
* **bin2pos**   - converts binary coded value to positional (one-hot) code
* **ClkDivider**    - wide reference clock divider
* **DeBounce**    - two-cycle debounce for input buttons
* **DynDelay**    - dynamic delay for arbitrary input signal made on general-purpose trigger elements
* **EdgeDetect**    - edge detector, gives one-tick pulses on every signal edge
* **Encoder**   - digital encoder input logic module
* **fifo**    - single-clock FIFO buffer (queue) implementation
* **NDivide**   - primitive integer divider
* **lifo**   - single-clock LIFO buffer (stack) implementation
* **PulseGen**    - generates pulses with given width and delay
* **bin2pos**   - converts positional (one-hot) value to binary representation
* **ResetSet**    - SR trigger variant w/o metastable state, set dominates here
* **ReverseVector**    - reverses signal order within multi-bit bus
* **SetReset**    - SR trigger variant w/o metastable state, reset dominates here
* **StaticDelay**   - static delay for arbitrary input signal made on Xilinx`s SRL16E primitives. Also serves as input synchronizer, a standard way to get rid of metastability issues
* **UartRx**    - straightforward yet simple UART receiver implementation for FPGA written in Verilog
* **UartTx**    - straightforward yet simple UART transmitter implementation for FPGA written in Verilog
* **UartRxExtreme**   - extreme minimal UART receiver implementation for FPGA written in Verilog
* **UartTxExtreme**   - extreme minimal UART transmitter implementation for FPGA written in Verilog

Also added some simple testbenches for selected modules


Author: Konstantin Pavlov, pavlovconst@gmail.com

