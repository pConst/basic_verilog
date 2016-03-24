
© Copyright 2010-2014, Xilinx, Inc. All rights reserved.
This file contains confidential and proprietary information of Xilinx, Inc. and is
protected under U.S. and international copyright and other intellectual property laws.

Disclaimer:
  This disclaimer is not a license and does not grant any rights to the materials
  distributed herewith. Except as otherwise provided in a valid license issued to you
  by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
  ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
  WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
  TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
  PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
  negligence, or under any other theory of liability) for any loss or damage of any
  kind or nature related to, arising under or in connection with these materials,
  including for any direct, or any indirect, special, incidental, or consequential
  loss or damage (including loss of data, profits, goodwill, or any type of loss or
  damage suffered as a result of any action brought by a third party) even if such
  damage or loss was reasonably foreseeable or Xilinx had been advised of the
  possibility of the same.

CRITICAL APPLICATIONS
  Xilinx products are not designed or intended to be fail-safe, or for use in any
  application requiring fail-safe performance, such as life-support or safety devices
  or systems, Class III medical devices, nuclear facilities, applications related to
  the deployment of airbags, or any other applications that could lead to death,
  personal injury, or severe property or environmental damage (individually and
  collectively, "Critical Applications"). Customer assumes the sole risk and
  liability of any use of Xilinx products in Critical Applications, subject only to
  applicable laws and regulations governing limitations on product liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES. 



-------------------------------------------------------------------------------------------------
UART Macros for Spartan-6, Virtex-6, 7-Series, Zynq and UltraScale Devices 
-------------------------------------------------------------------------------------------------

Release 5.

Ken Chapman - Xilinx Ltd - 30th September 2014  


Welcome to the fifth release of the UART macros optimised for Spartan-6, Virtex-6,7-Series, Zynq
and UltraScale devices and ideally suited for use with PicoBlaze (KCPSM6). 

There have been no changes to the actual UART macros since the first release. Minor corrections 
have been made to the documentation (thank you to those that reported issues). 

The most significant reason for this release has been the addition of a third reference design.
This new reference is presented on the KC705 board but the main feature is a scheme in which 
PicoBlaze (KCPSM6) adjusts the communication BAUD rate and software delays to reflect the clock
frequency. Please see 'UART6_User_Guide_and_Reference_Designs_30Sept14' for descriptions of 
all three reference designs provided. This design has been implemented using both ISE and Vivado 
and therefore both UCF and XDC constraints files have been provided.

   Hint - The KCPSM6 package includes more reference designs that use the UART 
          macros on a Kintex-7 KC705 board.

PicoTerm (v1.97) may now be invoked with a command line option that will open and write a log 
file. 'PicoTerm_README.txt' documents all the features of PicoTerm and the reference design 
presented on the ATLYS board demonstrates many of the possibilities.

Xilinx Technical Support is available to answer your questions. However it is recommended that
you take the time to consider exactly what your issue is before asking any questions. Just 
because your design contains the UART macros (and probably a PicoBlaze processor) it doesn't 
mean you actually have a problem with either! Page 13 of the 'UART6_User_Guide' recommends 
steps to debug a UART communication link and every item on this list should be checked before 
contacting Xilinx Technical Support.

http://www.xilinx.com/support/clearexpress/websupport.htm


-------------------------------------------------------------------------------------------------
Principle Features of 'uart_tx6' and 'uart_rx6' macros.
-------------------------------------------------------------------------------------------------

  - 8-bit data, 1 stop bit, no parity.
  - User definable baud rate.
  - Integrated 16-byte FIFO buffers.
  - Performance of >10mbps (baud rate) achievable depending on device family and clock rate. 
  - No handshake but signals provided facilitate implementation of soft or hardware schemes.
  - Each macro is only 5 Slices including the FIFO buffer.
  - Ideal peripherals for PicoBlaze (KCPSM6).


-------------------------------------------------------------------------------------------------
'UART' Directory Contents
-------------------------------------------------------------------------------------------------


               UART6_README.txt - This file!

  UART6_User_Guide_and_Reference_Designs_29March13.pdf - The main UART6 User Guide document.

                   uart_tx6.vhd - UART transmitter with integrated 16-byte FIFO buffer.

                   uart_rx6.vhd - UART receiver with integrated 16-byte FIFO buffer.

                     uart_tx6.v - Verilog equivalent of 'uart_tx6.vhd'.
 
                     uart_rx6.v - Verilog equivalent of 'uart_rx6.vhd'.

                   PicoTerm.exe - A very simple PC based terminal but with some special features!

            PicoTerm_README.txt - Description of PicoTerm basic usage and special features. 


       'ML605_design' Directory
       ------------------------ 

                uart6_ml605.vhd - KCPSM6 reference design using 'uart_tx6' and 'uart_rx6'.
                                  Can be used as provided with the ML605 evaluation board.

                  uart6_ml605.v - Verilog equivalent of 'uart6_ml605.vhd'.

               uart_control.psm - Top level KCPSM6 program for 'uart6_ml605' design.
                                  INCLUDE directive used to include 'uart_interface_routines.psm'.
 
    uart_interface_routines.psm - UART interface definition and UART routines.

                uart6_ml605.ucf - ISE constraints file when using an ML605 board.
 

       'ATLYS_design' Directory 
       ------------------------ 


                uart6_atlys.vhd - KCPSM6 reference design using 'uart_tx6' and 'uart_rx6'.
                                  Design is described in the PDF document.
                                  Can be used as provided with the ATLYS Design Platform.

                  uart6_atlys.v - Verilog equivalent of 'uart6_atlys.vhd'.

      atlys_real_time_clock.psm - Top level KCPSM6 program for 'uart6_atlys.vhd' design.
                                  INCLUDE directives used to include 'PicoTerm_routines.psm' 
                                  and 'soft_delays_100mhz.psm'.
 
          PicoTerm_routines.psm - UART interface definition and UART routines including routines
                                  written specifically to use PicoTerm's special features. 

         soft_delays_100mhz.psm - Routines implementing delays based on a 100MHz clock.

                uart6_atlys.ucf - ISE constraints file when using an ATLYS Design Platform.
 

       'KC705_design' Directory
       ------------------------ 

                uart6_kc705.vhd - KCPSM6 reference design using 'uart_tx6' and 'uart_rx6'.
                                  Can be used as provided with the KC705 evaluation board.

                  uart6_kc705.v - Verilog equivalent of 'uart6_kc705.vhd'.

     auto_baud_rate_control.psm - Top level KCPSM6 program for 'uart6_kc705' design.
                                  INCLUDE directive used to include 'uart_interface_routines.psm'.
 
    uart_interface_routines.psm - UART interface definition and UART routines.

                uart6_kc705.ucf - ISE constraints file when using a KC705 board.

                uart6_kc705.xdc - Vivado constraints file when using a KC705 board.

      testbench_uart6_kc705.vhd - Simple test bench. The waveforms shown on page 22 of 
                                  'UART6_User_Guide_and_Reference_Designs_30Sept14.pdf'
                                  were captured from the Vivado simulator using this test bench.


-------------------------------------------------------------------------------------------------
Requirements
-------------------------------------------------------------------------------------------------

ISE v12.x or later (v14.7 current at time of this release) 

 or 
 
Vivado 2013.x or later (2014.2 current at time of this release)

These UART macros are optimised for Spartan-6, Virtex-6 and 7-Series devices. They also map well
to UltraScale devices but they can NOT be used with previous generations of device including 
Spartan-3 Generation and Virtex-5. 

The KCPSM6 Assembler v2.70 was current at the time this package. Older versions of the KCPSM6
Assembler may not recognise all the syntax present in the PSM files provided with the reference 
designs in this release.


-------------------------------------------------------------------------------------------------
Changes and Additions
-------------------------------------------------------------------------------------------------



Release 1
---------

Initial release


Release 2
---------

Enhancements to documentation.
PicoTerm v1.03 - Basic terminal features only.


Release 3
---------

ATLYS reference design and documentation.
PicoTerm v1.30 - With Device Control String (DCS) features.


Release 4
---------

Enhancements to the ATLYS reference design.
PicoTerm v1.72 - With more Device Control String (DCS) features.


Release 5
---------

KC705 reference design and documentation.
PicoTerm v1.97 - Additional command line option to open a log file.


-------------------------------------------------------------------------------------------------
Known Issues
-------------------------------------------------------------------------------------------------


Terminal only displays everything on one line
---------------------------------------------

As shown in the reference programs (PSM files) provided, it is common practice for each line of 
text to end with a carriage return character (0D hex) only. Your terminal should be configured to 
append a line feed automatically to a carriage return. In HyperTerminal this is the 'Append line 
feeds to incoming line ends' option in the ASCII Setup menu. 

PicoTerm is permanently set to meet this end of line requirement. It is also permanently set to 
match the 8-bit, 1 stop bit and no parity configuration required to work with the UART6 macros 
as well as having a default baud rate of 115200. All of this should make PicoTerm easy to use 
and a good alternative if you are experiencing issue with another terminal. At least give it a 
try!  



Incorrect removal of logic during implementation
------------------------------------------------

Setting 'global_opt' option in MAP to 'speed', 'area' or 'power' may result in the incorrect 
removal of the serial input to the receiver which leads on to the removal of the whole macro!
A good implementation is realised when 'global_opt' is set to 'off' (the default setting).

This issue was observed when using ISE v12.4 and may also apply to some other versions of ISE. 
This issue was fixed in ISE v13.4 so you must use ISE v13.4 when 'global_opt' needs to be used 
for other parts of your design.

Note that 'global_opt' is only applicable to Spartan-6 and Virtex-6 designs so this should 
never be an issue for 7-Series designs.



The first few characters are corrupted but then everything works as expected
----------------------------------------------------------------------------

This can occur when the UART macros are used to transmit characters to a PC almost immediately 
after the device is configured. The simple solution is to implement a delay (e.g. ~1 second) 
before the first transmission is attempted. This is very easy to arrange when using PicoBlaze
(see reference code provided). 

Should this issue occur it is almost certainly the case that the UART communications involve a
USB/UART converter device with a corresponding Virtual COM Port driver on the PC. Whilst the UART
transmitter macro transmits characters correctly, it is not entirely fair to blame the USB/UART 
arrangement because the serial communication is ultimately recovering from what is known as a 
'break condition'. In other words, until the FPGA was configured, there was nothing to define 
the state of the serial line. In theory, a serial line should be parked High when not active 
but in this case it has probably been Low which would be consistent with a broken or disconnected
link. Depending on the vendor of the device and driver, it appears that some take more time to 
recover from the break condition. Again to be fair, the serial line really needs to be High 
long enough for the first start bit Low to be recognised correctly and typical baud rates are 
slow relative to the typical clock speeds used in FPGA designs.   




-------------------------------------------------------------------------------------------------
Hints and Tips
-------------------------------------------------------------------------------------------------


Simulation
----------

As covered in the main documentation, a UART can appear very slow relative to the clock so if
you want to see an output from UART_TX6 or simulate an input to UART_RX6 then just remember that 
your simulation may be rather long or you really need to zoom out to see the waveforms.

When performing a functional simulation it is your responsibility to ensure that all your 
stimuli have defined values at time zero to represent what would happen in the real silicon. 
In particular the circuit you use to generate the 'en_16_x_baud' pulses should be such that this
signal also has a defined value before the first rising edge is applied to the clock input of 
UART_TX6. The easiest way to do this is to make sure that initial values are defined. E.g....

signal en_16_x_baud : std_logic := '0';
 


-------------------------------------------------------------------------------------------------
UART pin assignments for commonly used boards
-------------------------------------------------------------------------------------------------


Drigmorn3 (www.enterpoint.co.uk) 
--------------------------------

NET "uart_rx" LOC = "G11" | IOSTANDARD = LVTTL;
NET "uart_tx" LOC = "A11" | IOSTANDARD = LVTTL | SLEW = SLOW | DRIVE = 4;


LX9 Microboard: AES-S6MB-LX9-G (www.em.avnet.com/drc)
-----------------------------------------------------

NET "rs232_rx"  LOC = "R7" | IOSTANDARD = LVCMOS33;
NET "rs232_tx"  LOC = "T7" | IOSTANDARD = LVCMOS33 | SLEW = SLOW | DRIVE = 4;


LX16 Evaluation board: AES-S6EV-LX16-G (www.em.avnet.com/drc)
-------------------------------------------------------------

NET "rs232_rx"  LOC = "H13" | IOSTANDARD = LVCMOS33;
NET "rs232_tx"  LOC = "H14" | IOSTANDARD = LVCMOS33 | SLEW = SLOW | DRIVE = 4;


ATLYS  (www.digilentinc.com)
----------------------------

NET "rs232_rx"  LOC = "A16" | IOSTANDARD = LVCMOS33;
NET "rs232_tx"  LOC = "B16" | IOSTANDARD = LVCMOS33 | SLEW = SLOW | DRIVE = 4;


SP601 
-----

NET "uart_rx" LOC = "K14" | IOSTANDARD = LVCMOS25;
NET "uart_tx" LOC = "L12" | IOSTANDARD = LVCMOS25 | SLEW = SLOW | DRIVE = 4;


SP605  (www.xilinx.com)
-----------------------

NET "uart_rx" LOC = "H17" | IOSTANDARD = LVCMOS25;
NET "uart_tx" LOC = "B21" | IOSTANDARD = LVCMOS25 | SLEW = SLOW | DRIVE = 4;


ML605 (www.xilinx.com)
----------------------

NET "uart_rx" LOC = "J24" | IOSTANDARD = LVCMOS25;
NET "uart_tx" LOC = "J25" | IOSTANDARD = LVCMOS25 | SLEW = SLOW | DRIVE = 4;


KC705 (www.xilinx.com)
----------------------

(Correct for Rev.D board but check pin assignments if using an earlier revision) 

NET "uart_rx" LOC = "M19" | IOSTANDARD = LVCMOS25;
NET "uart_tx" LOC = "K24" | IOSTANDARD = LVCMOS25 | SLEW = SLOW | DRIVE = 4;


VC707 (www.xilinx.com)
----------------------

NET "uart_rx" LOC = "AU33" | IOSTANDARD = LVCMOS18;
NET "uart_tx" LOC = "AU36" | IOSTANDARD = LVCMOS18 | SLEW = SLOW | DRIVE = 4;


-------------------------------------------------------------------------------------------------
End of file 'UART6_README.txt'
-------------------------------------------------------------------------------------------------
