# basic_verilog
### Some basic must-have verilog modules
####(licensed under CC BY-SA 4_0)


**/Advanced Synthesis Cookbook/**		useful code from Altera`s cookbook  

**Main_tb.v**		- basic testbench template  

**ClkDivider.v**		- wide reference clock divider  
**DeBounce.v**		- two-cycle debounce for input buttons  
**DynDelay.v**		- dynamic delay made on general-purpose trigger elements  
**EdgeDetect.v**		- edge detector, gives one-tick pulses on every signal edge  
**Encoder.v**		encoder input module  
**PulseGen.v**		- generates pulses with given width and delay  
**ResetSet.v**		- SR trigger variant w/o metastable state, set dominates here  
**SetReset.v**		- SR trigger variant w/o metastable state, reset dominates here  
**SimplePulseGen.v**		- generates one-cycle pulse with given delay  
**StaticDelay.v**		static delay made on Xilinx`s SRL16E primitives  
**Synch.v**		- input syncnronizer (and also "static delay module"), standard way to get rid of metastability issues  

Also added some simple testbenches for selected modules


Author: Konstantin Pavlov, pavlovconst@gmail.com

