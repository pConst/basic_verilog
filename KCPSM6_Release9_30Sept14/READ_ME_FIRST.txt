
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
KCPSM6 : PicoBlaze for Spartan-6, Virtex-6, 7-Series, Zynq and UltraScale Devices 
-------------------------------------------------------------------------------------------------

Release 9.

Ken Chapman - Xilinx Ltd - 30th September 2014  



Thank you for opening the 'READ_ME_FIRST' file. Don't worry, you really don't have to read all 
of this file before you get started but please do review just this section to understand what 
is being made available to you. I really hope you will have fun using PicoBlaze and I think you
will as long as you set off in the right direction from the outset.  



Welcome to  KCPSM6, the PicoBlaze optimised for Spartan-6, Virtex-6, 7-Series, Zynq and 
UltraScale devices. Whether this is your first experience of PicoBlaze or you have experience of 
the previous versions I hope you will find KCPSM6 useful, and most of all, fun! This package 
also contains optimised UART macros (and PicoTerm) which are ideal for use with PicoBlaze 
especially as so many boards provide a USB/UART interface. Several reference designs are 
included in which KCPSM6 implements simple applications involving UART, I2C, SPI and XADC.

Although KCPSM6 is not difficult to use, it is highly recommended that you take some time to 
look at the documentation. Before you do that, we must consider which Xilinx design tools you
will be using to target which device. As you can see from the table below, you don't always have
a choice, and certainly, only Vivado will support devices released in the future.


        Device                  ISE (14.7)        Vivado (2014.2)

        Spartan-6                  Yes               No 
       
        Virtex-6                   Yes               No
        
        7-Series
            Artix 35/50/75         No                Yes
            Artix 100/200          Yes               Yes
            Kintex                 Yes               Yes
            Virtex                 Yes               Yes
  
        Zynq                       Yes               Yes 
 
        UltraScale                 No                Yes
                  

The KCPSM6 macro is provided in the form of a VHDL or Verilog file. Although you will at some 
point assemble a PSM program for PicoBlaze to execute, the assembler also generates a single
VHDL or Verilog file defining a memory holding your program. As such if you can implement a 
standard HDL design using ISE or Vivado then there is really very little more for you to learn.
In fact, most competent hardware engineers report being able to implement their first design in
less than 2 hours and feeling quite proficient and productive by the end of one day. 

However, it is also recognised that a large number of people using PicoBlaze for the first 
time also have a tendency to be new to the world of FPGA and hardware design. Whilst it is not 
possible or intended for PicoBlaze and this package to be a replacement for all the official 
Xilinx documentation and customer education training materials, it is hoped that there is enough 
information presented in this package to at least get anyone started and able to implement their 
first small but working design that contains PicoBlaze. 


If you will be using the ISE design tools then...

    Open 'KCPSM6_User_Guide_30Sept14.pdf' and the first 30 pages will introduce you to 
    KCPSM6 and take you step by step through the creation of a working PicoBlaze design.
    Once you have done this you will know most of what there is to know about the PicoBlaze 
    design flow and the rest of the document provides you with a manual for you to refer to 
    as you interactively work with PicoBlaze when implementing your own real designs. 
 
    This document does assume that you have a fundamental grasp of HDL design and have used
    ISE before. If you have not, then it is strongly recommended that you first implement a 
    very simple design using ISE. For example, a design that simply connects some switches
    to some LEDs would be enough to prepare you to use PicoBlaze for the first time. Ideally,
    you will have a board that you can download your first design to and see that it works.
    Alternatively, you may choose to directly use one of the reference designs provided in 
    this package as your starting point (i.e. known good VHDL or Verilog code).  

    When this package was released, ISE was version 14.7 and ideally you will be using that 
    version or later. As you will learn when following the documentation, the assembler needs
    a 'ROM_form' template and your default starting template should be a copy of 'ROM_form.vhd' 
    provided in the root directory of the package or 'ROM_form.vhd' contained in the 'Verilog'
    directory. In both cases these are renamed copies of 'ROM_form_JTAGLoader_14March13.vhd' 
    and 'ROM_form_JTAGLoader_14March13.v' respectively. If for some reason you are using ISE
    version 12.x or older then please see 'Known_Issues_and_Workarounds.txt' as you will need 
    to use a different 'ROM_form' template to be compatible with the older version of the tools. 

If you will be using the Vivado design tools then...

    The first 30 pages of 'KCPSM6_User_Guide_30Sept14.pdf' introduce you to KCPSM6 and take
    you through the creation of a PicoBlaze design. Do take a look at these pages to gain an
    appreciation of the PicoBlaze design flow and how to insert and connect KCPSM6 to other
    logic but generally ignore anything specifically to do with the ISE tools because you are
    using Vivado! The rest of this document provides you with a manual for you to refer to 
    as you interactively work with PicoBlaze when implementing your own real designs. 

    Vivado is a relatively new tool and even engineers with years of ISE experience may be 
    faced with using it for the first time. 'PicoBlaze_Design_in_Vivado' is a supplementary
    document that takes one of the reference designs provided in this package and shows you,
    step by step, how to create a Vivado project and a way in which you can create and 
    implement a design containing PicoBlaze. The first page of this document will lead you
    to the relevant material depending on your current familiarity with Vivado and PicoBlaze. 

    When this package was released, Vivado was version 2014.x and ideally you will need to be 
    using a 2014.x version or later. As you will learn when following the documentation, the 
    assembler needs a 'ROM_form' template and your default starting template should be renamed
    copy of 'ROM_form_JTAGLoader_Vivado_2June14.vhd' or 'ROM_form_JTAGLoader_Vivado_2June14.v'.


Regardless of the design tools you are using, this package also includes the following documents.
Please don't feel that you need to read everything before you start (that wouldn't be fun!), but
do take a look at them when you feel like learning a bit more or feel that you may have an issue.

all_kcpsm6_syntax.psm
  Page 52 of 'KCPSM6_User_Guide_30Sept14.pdf' provides a summary of the KCPSM6 Assembler syntax
  and pages 53 to 101 show you all the instructions often with snippets of PSM code as examples.
  'all_kcpsm6_syntax.psm' is NOT a real program but it does contain valid examples of all PSM 
  syntax (i.e. it can be assembled). DO LOOK AT THIS file because it provides comprehensive 
  descriptions of the syntax rules and full details and examples of the assembler directives.
  An understanding of the most basic syntax is adequate for most users and applications. However, 
  there are some quite interesting possibilities that should appeal to anyone that wants to 
  achieve more with PicoBlaze just have more fun with it!

Known_Issues_and_Workarounds.txt 
  Ideally you won't encounter any issues, but if you do, please check this one out 
  and hopefully it will explain what to do.
 
UART6_User_Guide_and_Reference_Designs_30Sept14.pdf
  This document is provided in the 'UART_and_PicoTerm' directory and describes the optimised
  UART macros that can be useful in PicoBlaze designs and used in various reference designs.
  More designs together with their own documentation can be found in the 'Reference Designs' 
  directory.

PicoTerm_README.txt
  A terminal application called 'PicoTerm' with some rather special, and hopefully fun, features
  is also provided in the 'UART_and_PicoTerm' directory. 

kcpsm6_assembler_readme.txt
  The main documentation should have adequately described how to run the assembler to generate 
  VHDL, Verliog and HEX file from your PSM code. If you are someone that likes to write batch
  files to automate the design flow or you just like to know all the details then this document
  is for you.         

The remainder of this 'READ_ME_FIRST.txt' file contains the following sections.

  - Principle Features of KCPSM6
  - System Requirements
  - Package Contents
  - Changes and Additions in each release.
  - Other Useful Stuff?
  - Known Limitations

In most cases PicoBlaze design is easy so go and start having fun. Use the rest of this document 
for clues should you wonder what something is or need to check the details about package contents
of requirements.


-------------------------------------------------------------------------------------------------
Principle Features of KCPSM6
-------------------------------------------------------------------------------------------------

  - Only 26 Slices plus program memory (BRAM).
  - 100% embedded solution.
  - 8-bit data.
  - Performance 52 MIPS to 120 MIPs depending on device family and clock rate. 
  - Programs up to 4K instructions.
  - 32 General Purpose Registers arranged in 2 banks of 16 Registers.
  - 256 General Purpose Input Ports.
  - 256 General Purpose Output Ports.
  - 16 Constant-Optimised Output Ports.
  - 64-bytes of scratch pad memory expandable to 128 and 256-bytes (additional 2 and 6 Slices).
  - Fully automatic CALL/RETURN stack supporting nested subroutines to 30 levels. 
  - Interrupt with user definable interrupt vector and maximum response time of 4 clock cycles.  
  - Power saving features including 'sleep' mode.
  - Superset of KCPSM3 with high degree of code compatibility.

  - Supplied with optimum UART macros with integral FIFO buffers (only 5 Slices each).
  - Reference designs including UART, I2C and SPI communication, control and transactions. 


-------------------------------------------------------------------------------------------------
System Requirements
-------------------------------------------------------------------------------------------------


Hardware
--------

KCPSM6 is optimised for Spartan-6, Virtex-6 and 7-Series devices. It also maps well to 
UltraScale devices but it can NOT be used with previous generations of device including 
Spartan-3 Generation and Virtex-5. 


JTAG Loader requires a Platform Cable USB or Digilent equivalent JTAG programming solution.
Note that equivalent circuits are often included on development boards and evaluation kits 
rather than as a separate 'pod'. 


Xilinx Design Tools
-------------------

ISE - v13.x or later (ideally v14.7).
      Please see the 'Known_Issues_and_Workarounds.txt' file if using ISE 12.x.

  or
  --

Vivado 2014.x or later 
      Note that JTAG Loader also requires ISE to be installed. 


KCPSM6 Assembler
----------------

Windows operating system for KCPSM6 Assembler and JTAG Loader utility.
   Users have reported that the KCPSM6 Assembler has worked well with both 32-Bit and 64-bit 
   versions of both Windows-XP and Win-7 environments. It has also been successfully used with 
   Wine within a 64-bit Linux environment.   


JTAG Loader Utility
-------------------

JTAG Loader makes use of various drivers associated with ChipScope and forming part of an 
installation of the ISE tools. Therefore you must have ISE installed (even if using Vivado) and
the 'PATH' and 'XILINX' environment variables must be set appropriately so that JTAG Loader can 
locate and use the files that it requires. Below are typical examples of the environment 
variables required when using ISE v14.7. It is possible that they have already been set at the 
system level but check that they accurately reflect your installation. 

PATH = C:\Xilinx\14.7\ISE_DS\ISE\lib\nt;     (for 32-bit operating systems)
PATH = C:\Xilinx\14.7\ISE_DS\ISE\lib\nt64;   (for 64-bit operating systems)
XILINX = C:\Xilinx\14.7\ISE_DS\ISE

As shown on page 25 of 'KCPSM6_User_Guide_30Sept14.pdf' the 'ISE Design Suite Command Prompt'
can be used or you can manually invoke the 'settings32.bat' or 'settings64.bat' provided in 
C:\Xilinx\14.7\ISE_DS (or equivalent depending on version of ISE) once a command window has been
opened. 

It is often easier and more convenient to permanently define your PATH and XILINX environment 
variables at the system level or to write batch files that temporarily set them before running 
JTAG Loader to load a specified program into the memory.

To permanently set 'System Properties'.... 

 Windows XP...
  Right click on 'My Computer' and select 'Properties'. 
  Go to the 'Advanced' tab and choose 'Environment Variables'. 
  Use 'New' or 'Edit' as necessary.   

 Windows 7...
  Start -> Control Panel -> User Accounts
  Change my environment variables
  Use 'New' or 'Edit' under 'User variables for <username>' as necessary.   

An example batch file (.bat)...

  REM Setting environment variables to define location of ISE v14.7
  PATH=%PATH%;C:\Xilinx\14.7\ISE_DS\ISE\lib\nt64
  set XILINX=C:\Xilinx\14.7\ISE_DS\ISE

  REM Upload program HEX using JTAG Loader 
  JTAG_Loader_Win7_64.exe -l my_program.hex

JTAG Loader must also be able to access some system level DLL files. In the case of a Windows-XP
environment then it is normal for the PATH to contain 'C:\WINDOWS\system32;' or similar. So if 
you receive a system error indicating that 'PCMSVCR100.dll' is missing or could not be found then
add the appropriate definition to your PATH. When using a Windows-7 environment it is more likely 
that 'MSVCR100.dll' will become the subject of a system error message. 'MSVCR100.dll' is not part
of a default Windows-7 installation but is a often present as a result of a Microsoft Visual C++
application. If you do encounter this issue then the quickest solution is to place a copy of 
'msvcr100.dll' provided in the 'JTAG_Loader' directory of this package in to the same directory
as the JTAG Loader executable you are invoking.



-------------------------------------------------------------------------------------------------
Package Contents
-------------------------------------------------------------------------------------------------


               READ_ME_FIRST.txt - This file!

  KCPSM6_User_Guide_30Sept14.pdf - The main KCPSM6 User Guide document.

    Reference_Design_License.pdf - Copy of the Reference Design License Agreement under 
                                   which KCPSM6 and the UART macros are released.

  PicoBlaze_Design_in_Vivado.pdf - Supplementary guide for Vivado users including the step by 
                                   step implementation of one of the reference designs.

Known_Issues_and_Workarounds.txt - List of issues that you may encounter when using KCPSM6. 
                                   Please check this file before asking for technical support.

     kcpsm6_assembler_readme.txt - Supplementary information related specifically to the KCPSM6 
                                   assembler. Describes in detail the options and features when 
                                   invoking the assembler from batch files or using the 'drag 
                                   and drop' technique.   

           all_kcpsm6_syntax.psm - Examples and detailed descriptions of all PSM syntax 
                                   supported by the KCPSM6 assembler. 

                      kcpsm6.vhd - The KCPSM6 Processor v1.3.
 
                      kcpsm6.exe - The KCPSM6 Assembler for Windows v2.70.

                    ROM_form.vhd - Default program memory template for use during development
                                   when using the ISE tools. Please see 'ROM_form_templates' 
                                   below especially when using Vivado (e.g. for UltraScale).
 
      kcpsm6_design_template.vhd - Collection of VHDL reference code for KCPSM6 designs.


              -----------------------------------------------------------------------------------

                     JTAG_Loader - A sub-directory containing JTAG Loader executable files. 
                                   Select the executable file corresponding with your operating 
                                   system. Please note that for simplicity, the documentation 
                                   (e.g. pages 25-29 of 'KCPSM6_User_Guide_29March12.pdf') assume
                                   that the selected executable has been renamed 'jtagloader', 
                                   but you can retain the original file name if you prefer.  

                       JTAG_Loader_WinXP_32.exe - Windows-XP 32-Bit.
                       JTAG_Loader_WinXP_64.exe - Windows-XP 64-Bit.
                        JTAG_Loader_Win7_32.exe - Windows-7 32-Bit.
                        JTAG_Loader_Win7_64.exe - Windows-7 64-Bit.
                              JTAG_Loader_RH_32 - Linux 32-Bit.
                              JTAG_Loader_RH_64 - Linux 64-Bit.
                                   msvcr100.dll - This DLL is required by JTAG Loader when using 
                                                  Windows-7 (see 'Requirements' section below).

              -----------------------------------------------------------------------------------

              ROM_form_templates - A sub-directory containing a copy of the default templates and 
                                   optional 'production' templates. Their use is described in 
                                   the user guide (see pages 47 and 123) and in assembler 
                                   supplement 'kcpsm6_assembler_readme.txt'. Each template file
                                   also includes a description. Note that the Verilog equivalent 
                                   of most files is provided in the 'verilog' directory. 
      
                 ROM_form_JTAGLoader_14March13.vhd - Development template for ISE users only.
                                                     Note that the default 'ROM_form.vhd' 
                                                     template is a renamed copy of this file.

                 ROM_form_JTAGLoader_3Mar11.vhd - Development template for ISE 12.x users only.

                 ROM_form_JTAGLoader_Vivado_2June14.vhd - Development template for Vivado users
                                                          (UltraScale devices are supported).

                 ROM_form_S6_1K_5Aug11.vhd - Spartan-6 1K (1 BRAM)
                 ROM_form_S6_2K_5Aug11.vhd - Spartan-6 2K (2 BRAM)
                 ROM_form_S6_4K_23Nov12.vhd - Spartan-6 4K (4 BRAM)
                 ROM_form_V6_1K_14March13.vhd - Virtex-6 1K (0.5 BRAM)
                 ROM_form_V6_2K_14March13.vhd - Virtex-6 2K (1 BRAM)
                 ROM_form_V6_4K_14March13.vhd - Virtex-6 4K (2 BRAM)
                 ROM_form_7S_1K_14March13.vhd - 7-Series 1K (0.5 BRAM)
                 ROM_form_7S_2K_14March13.vhd - 7-Series 2K (1 BRAM)
                 ROM_form_7S_4K_14March13.vhd - 7-Series 4K (2 BRAM)

                 ROM_form_256_5Aug11.vhd - Spartan-6, Virtex-6 and 7-Series 
                                           256 instructions (18 Slices)

                 ROM_form_128_14March13.vhd - Spartan-6, Virtex-6 and 7-Series 
                                              128 instructions (9 Slices)

                 ROM_form_7S_2K_with_error_detection_14March13.vhd - 7-Series 2K (1 BRAM) with 
                                           error detection circuit (see User Guide page 118) 

                 ROM_form_7S_1K5_with_ecc_5Dec13.vhd - 7-Series 1.5K (1 BRAM) with error 
                                           detection and ECC correction (see User Guide page 119) 

              -----------------------------------------------------------------------------------

                         verilog - A sub-directory containing the Verilog equivalent of the 
                                   VHDL files to be used in exactly the same way in a design.

                                    kcpsm6.v
                                    ROM_form.v
                                    kcpsm6_design_template.v
                                    ROM_form_JTAGLoader_14March13.v
                                    ROM_form_JTAGLoader_3Mar11.v
                                    ROM_form_JTAGLoader_Vivado_2June14.v
                                    ROM_form_S6_1K_5Aug11.v
                                    ROM_form_S6_2K_5Aug11.v
                                    ROM_form_S6_4K_26Nov12.v
                                    ROM_form_V6_1K_14March13.v
                                    ROM_form_V6_2K_14March13.v
                                    ROM_form_V6_4K_14March13.v
                                    ROM_form_7S_1K_14March13.v
                                    ROM_form_7S_2K_14March13.v
                                    ROM_form_7S_4K_14March13.v
                                    ROM_form_256_5Aug11.v
                                    ROM_form_128_14March13.v

              -----------------------------------------------------------------------------------
                        
              UART_and_PicoTerm - A sub-directory containing the Ultra-Compact UART macros
                                  together with documentation (readme and PDF), reference designs
                                  and a terminal application (PicoTerm) that is ideally suited 
                                  for use with PicoBlaze based designs.

                                    UART6_README.txt
                                    UART6_User_Guide_and_Reference_Designs_29March13.pdf
                                    BAUD_rate_counter_calculator.xlsx

                                    uart_rx6.vhd
                                    uart_tx6.vhd
                                    uart_rx6.v
                                    uart_tx6.v

                                    PicoTerm_README.txt
                                    PicoTerm.exe         - PicoTerm v1.97
 
                                    ML605_design - Reference design presented on ML605 board.
                                                   Simple interaction with any terminal.  

                                                     uart6_ml605.vhd
                                                     uart6_ml605.v
                                                     uart6_ml605.ucf
                                                     uart_control.psm
                                                     uart_interface_routines.psm

                                    KC705_design - Reference design presented on KC705 board.
                                                   KCPSM6 calculates values to set BAUD rate and 
                                                   software delays to correspond with clock frequency.

                                                     uart6_kc705.vhd
                                                     uart6_kc705.v
                                                     uart6_kc705.ucf
                                                     uart6_kc705.xdc
                                                     auto_baud_rate_control.psm
                                                     uart_interface_routines.psm
                                                     testbench_uart6_kc705.vhd

                                    ATLYS_design - Reference design presented on ATLYS board.
                                                   This design also illustrates PicoTerm features.

                                                     uart6_atlys.vhd
                                                     uart6_atlys.v
                                                     uart6_atlys.ucf        
                                                     atlys_real_time_clock.psm
                                                     PicoTerm_routines.psm
                                                     soft_delays_100mhz.psm

              -----------------------------------------------------------------------------------

              Reference_Designs - A sub-directory containing more reference designs that build
                                  on the UART designs listed above and illustrate some typical 
                                  KCPSM6 applications. Each design is provided with its own
                                  documentation and source code containing detailed comments.  


                                  I2C
                                       Presented on the KC705 Kintex-7 Board this design shows
                                       how KCPSM6 can implement I2C communication. In this example,
                                       KCPSM6 is used to control an I2C Bus Switch (PCA9548) in order 
                                       to access the M24C08 EEPROM on the KC705 board. The design can 
                                       be used to read and modify any location in the EEPROM.

                                          KC705_KCPSM6_I2C_EEPROM_reference_design.pdf
                                          kc705_kcpsm6_i2c_eeprom.vhd
                                          kc705_kcpsm6_i2c_eeprom.ucf
                                          m24c08_i2c_uart_bridge.psm
                                          i2c_routines.psm
                                          kc705_i2c_devices.psm
                                          soft_delays_100mhz.psm
                                          PicoTerm_routines.psm


                                  SPI
                                       Presented on the KC705 Kintex-7 Board this design shows
                                       how KCPSM6 can implement SPI communication. In this example,
                                       KCPSM6 is used to access the N25Q128 Flash memory whose primary 
                                       purpose is holding a configuration image for the Kintex device. 
                                       Hence this design can be used to observe a configuration image 
                                       as well as erase sectors and write any location.

                                          KC705_KCPSM6_SPI_Flash_reference_design.pdf
                                          kc705_kcpsm6_spi_flash.vhd
                                          kc705_kcpsm6_spi_flash.ucf
                                          n25q128_spi_uart_bridge.psm
                                          N25Q128_SPI_routines.psm
                                          soft_delays_100mhz.psm
                                          PicoTerm_routines.psm


                                  XADC
                                       Presented on the KC705 Kintex-7 Board this design shows
                                       KCPSM6 interfaced to XADC, reading and displaying various
                                       analogue values including a simple plot of die temperature 
                                       over time on the PicoTerm Graphic Display  

                                          KC705_KCPSM6_XADC_reference_design.pdf
                                          kc705_kcpsm6_xadc.vhd
                                          kc705_kcpsm6_xadc.ucf
                                          xadc_monitor.psm
                                          xadc_routines.psm
                                          soft_delays_200mhz.psm
                                          PicoTerm_routines.psm


                                  ICAP
                                       Presented on the KC705 Kintex-7 Board this design shows
                                       KCPSM6 interfaced to ICAPE2, FRAME_ECCE2 and a BRAM memory.
                                       This design will have particular appeal to anyone interested
                                       in SEU, error detection and correction and the SEM IP core.
                                       ICAPE2 can be used for other applications such as MultiBoot
                                       control so the fundamental communication presented will be 
                                       useful for anyone needing to use ICAPE2. The connection of
                                       a BRAM for additional data storage as well as a simple line
                                       editor may have wider appeal to all PicoBlaze users.

                                          KC705_KCPSM6_ICAP_reference_design.pdf
                                          kc705_kcpsm6_icap.vhd
                                          ram_4096x8.vhd
                                          kc705_kcpsm6_icap.xdc
                                          icap_control.psm
                                          ICAPE2_routines.psm
                                          line_input_and_editing.psm
                                          RAM_4096x8_routines.psm
                                          PicoTerm_routines.psm


                                  VC707_KCPSM6_VID_PMBus_and_more.pdf   
                                       Additional documentation for the XAPP555 reference design.
                                       This design includes the following KCPSM6 items of interest.
                                          Presented on the VC707 Evaluation Kit
                                          Reading DEVICE_DNA (in this case to extract 'VID')
                                          PMBus control and monitoring of TI Power Controllers
                                          Control of Si570 Programmable Oscillator (I2C and algorithms)
                                          UART macros and communication with user terminal
                                          Internal chain of 1,000 PicoBlaze for control and monitoring!
                                          Measure the power consumption of a PicoBlaze
                                          
              -----------------------------------------------------------------------------------

                  Miscellaneous - A sub-directory for miscellaneous files 
                                  described in 'Known Issues' where appropriate.






-------------------------------------------------------------------------------------------------
Changes and Additions in each release
-------------------------------------------------------------------------------------------------


Release 1 (30 September 2010)
-----------------------------

Initial public release.


Release 2 (31 March 2011)
-------------------------

kcpsm6.vhd
  Correction to logic used to calculate parity (CARRY flag) during a TEST instruction.
  The specific conditions under which v1.0 would generate an incorrect result were:-
    TEST instruction (not TESTCY).
    The least significant 2 bits of the logical AND register had to be "01".
    The carry flag had to be set before the TEST instruction was executed. 
  The most likely coding style in which the defect in v1.0 would be observed would be...
       TEST s4, 01
       JUMP C, bit0_was_set 
  Even the above code works in v1.0 if the CARRY flag was clear before the TEST instruction.
  Fortunately the most common coding style uses the ZERO flag which works correctly so 
  the alternative code shown below would work perfectly in v1.0 as well...
       TEST s4, 01
       JUMP NZ, bit0_was_set 
   
Additions to ROM_form templates.
  Mainly additions including support of 7-Series devices but some minor corrections too.

Assembler
  Please see 'kcpsm6_assembler_readme.txt' for additions.  

User Guide
  General additions and corrections.  

Verilog equivalent of all VHDL files is now provided.

64-bit version of JTAG_Loader provided in addition to standard version. Physical size of 
executable files now much smaller (19KB compared with 468KB).


Release 3 (30 September 2011)
-----------------------------

Adjustments to ROM_form templates to be compatible with with ISE 13.x. 
ROM_form templates to support 7-Series devices.

Assembler
  Please see 'kcpsm6_assembler_readme.txt' for additions.   

User Guide
  General additions and corrections.  

Optimised UART6 macros provided with reference design and documentation.


Release 4 (30 April 2012)
-------------------------

JTAG Loader
  Support for Linux operating system.
  Support for Digilent JTAG Programming solution.
  Support for spaces in the names of directories in PATH specifications.

Assembler
  Addition of an 'INCLUDE' directive.
  Support for spaces in the names of directories in PATH specifications.
  Enhancements to LOG file contents.
  Generation of a 'session log' file. 
  Please see user guide, 'kcpsm6_assembler_readme.txt' and 'all_kcpsm6_syntax.psm' for details.

UART
  Verilog version of the reference design to complement the existing VHDL version.
  PSM reference code provides an example of the new INCLUDE directive and is more portable .
  PicoTerm v1.03 is provided as a simple terminal ideal for use with PicoBlaze designs.

General additions, enhancements and corrections to all documentation.


Release 5 (30 September 2012)
-----------------------------

Assembler
  Enhancements to LOG file contents including instruction and memory usage statistics.
  Ability to specify an environment variable in a CONSTANT, STRING or TABLE directive
    which in turn provides the value, string or data list. Please see description in 
    'all_kcpsm6_syntax.psm' for details.
  Support for 'ROM_form_7S_2K_with_error_detection_9Aug12.vhd' (see 'Documentation' below).
  Examples of 'HWBUILD' instruction added to 'all_kcpsm6_syntax.psm'.

UART
  An additional reference design presented on the ATLYS Spartan-6 Design Platform
    and exploiting new special features provided in PicoTerm (Hint: Reusable code).   
  PicoTerm v1.30 includes a Virtual 7-Segment Display, Virtual LEDs and other features 
    as well as provided the simple terminal ideal for use with PicoBlaze designs.

JTAG Loader
  New command line option (-i) can be used to modify the BSCAN 'USER' number.
    Please see 'JTAG Loader and BSCAN Users' in the 'Known Issues' section below.

Documentation 
  A detailed study and discussion concerning KCPSM6 reliability (see pages 106-118 of 
    'KCPSM6_User_Guide_29March12.pdf'). In addition to the documentation an error detection
    scheme has been provided for a 2K program memory in 7-Series devices for those seeking 
    the very highest levels of design reliability.
  General additions, enhancements and corrections to all documentation.


Release 6 (29 March 2013)
-------------------------

Assembler
  Enhancements to LOG file and messages relating to PSM syntax.
  Pre-defined constants for ASCII control characters 
        (NUL, BEL, BS, HT, LF, VT, CR, ESC, DEL, DCS, ST).
  4K program memory supported in Spartan-6.
  128 instruction program memory in 9 Slices for Spartan-6, Virtex-6 and 7-Series.
  Improved implementation of 'ROM_form_7S_2K_with_error_detection'.
  Unused address inputs on Virtex-6 and 7-Series BRAMs within the 'ROM_form' templates have 
     been connected High to reflect descriptions in UG363 and UG473 (no functional change).

UART and PicoTerm
  PicoTerm v1.72 includes Virtual Switches and a simple Graphic Display.
  ATLYS Spartan-6 reference design modified to include PicoTerm Virtual Switches.

Reference Designs
  Three new reference designs are presented on the Kintex-7 KC705 board. All build upon the 
  UART reference designs to show how KCPSM6 can implement...   
    a) I2C signalling and transactions (I2C Multiplexer control and EEPROM access).
    b) SPI signalling and transactions (access Flash memory shared with configuration).
    c) an XADC interface and analogue sample value conversions (includes a simple plot of die 
       temperature over time in the PicoTerm Graphic window).
  The source code provided with all designs contains comprehensive descriptions and there is 
  a supporting PDF document providing an overview, images and schematics.  

Documentation 
  General additions, enhancements and corrections to all documentation.


Release 7 (30 September 2013)
-----------------------------

Assembler
  Addition of a 'DEFAULT_JUMP' directive for very high reliability applications.
  Correction to handling of TABLEs containing only one item.

UART and PicoTerm
  PicoTerm v1.94
    Addition of several new DCS commands (see 'PicoTerm_README.txt' for full details)...
       'L' and 'l' to open and close a log file.
       'R' and 'r' to read files.
       'N' to generate and return random numbers.
       'p' to return the version of PicoTerm.
    Support display of British Pound symbol (£ = A3 hex).
    Improved response to mouse clicks when using the Virtual Switches.
     
Reference Designs & Documentation 
  General additions, enhancements and corrections.


Release 8 - 31 March 2014
-------------------------

Assembler
  ECC Protected BRAM (1.5K instructions in a 7-Series BRAM).
  Enhanced documentation relating to the use of KCPSM6 in high reliability application’s.  
  LOG file reports contents of unused locations (zero or 'DEFAULT_JUMP' address).

Reference Designs & Documentation 
  Additions and enhancements to reliability sections (ECC protected program ROM etc).
  Supplemental documentation for the XAPP555 reference design.


New in this release (Release 9 - 30 September 2014)
---------------------------------------------------

Documentation
  Known issues placed into a separate file called 'Known_Issues_and_Workarounds.txt'.
  New document 'PicoBlaze_Design_in_Vivado.pdf' for users of Vivado.
  Modified description of 'STAR' instruction.
  General additions and corrections.

Hardware
  Simulation model added for 'STAR sX, kk' instuction (no logical changes to implementation).

Assembler
  Support for the 'STAR sX, kk' instuction.
  'ROM_form' templates for use with Vivado (including UltraScale device support).
 
UART and PicoTerm
  'uart6_kc705' reference design provided for the KC705 board and demonstrating a scheme in 
     which KCPSM6 defines the BAUD rate and software delay loops to reflect the clock frequency. 
  PicoTerm v1.97
    Addition of '-w' command line option to open and write to a log file when opened.
    DCS Transaction Window reports opening an closing of log files when DCS commands are used. 
  'BAUD_rate_counter_calculator.xlsx' spread sheet provided to aid the setting of BAUD rate.

Reference Designs
  ICAPE2 design and documentation including Readback CRC monitor and RAM buffer.

-------------------------------------------------------------------------------------------------
Other Useful Stuff?
-------------------------------------------------------------------------------------------------

These links are provided as they may be of interest to KCPSM6 users. Thank you to the people that
have created these tools and have made them available to the PicoBlaze user community. 

Please note that these links in no way represent a recommendation of any particular tool or
imply their availability (now or in the future). Should you choose to investigate or work further
with any of these tools then you must evaluate the quality of the offering and you must then 
interact with the third party developer of that tool (Xilinx cannot provide support for third 
party tools). 


Mediatronix Tools
-----------------

http://www.mediatronix.org/pages/Tools
http://code.google.com/p/pblazasm/

pBlazASM is an assembler for PicoBlaze.
pBlazMRG merges code into a VHDL or Verilog template file.
pBlazSIM simulates a KCPSM6.
pBlazDIS can disassemble MEM files and clips from XDL and NDF files.
pBlazBIT can patch Spartan-6 bitstream files directly with MEM and SCR file contents. 


FIDEx
-----

http://www.fautronix.com/en/fidex

FIDEx is an integrated assembler development environment (IDE) for soft-core processors and 
works on Linux and Windows platforms.


opbasm
------

http://code.google.com/p/opbasm/

Opbasm is a free cross-platform assembler for KCPSM3 and KCPSM6. It will run readily on any 
platform with a functional Python intepreter. Opbasm provides a solution to assembling PicoBlaze
code without resorting to DOS or Windows emulation to run the native KCPSM assemblers. 


PicoBlaze C Compiler Toolchain 2.1
----------------------------------

http://sp.utia.cz/smecy/pblaze-cc-v2/Users_Guide/index.html#id609572

Optimizing C Compiler and an ELF-Based Toolchain for the PicoBlaze Processor


-------------------------------------------------------------------------------------------------
Known Limitations
-------------------------------------------------------------------------------------------------


DATA2MEM
--------

There are some issues associated with the use of DATA2MEM contained in ISE 12.x and later that 
prevent its use in modifying a KCPSM6 program contained in block memory within Spartan-6 and 
Virtex-6 devices. It is unlikely that this issue will be fixed but a workaround may yet be 
possible to implement. Whenever possible, use JTAG Loader which has the advantage of being much
faster anyway. If you have a requirement to modify more than one KCPSM6 program in the same 
design then please contact us to discuss how this may be achieved using JTAG Loader.

DATA2MEM in ISE 14.5 has been used to successfully to modify the contents of a 2K program in a 
Kintex-7 device. At this time the procedure is manual and needs to be better documented. Please
contact the author of PicoBlaze if you require early access to this information.

-------------------------------------------------------------------------------------------------
End of file 'READ_ME_FIRST.txt'
-------------------------------------------------------------------------------------------------
