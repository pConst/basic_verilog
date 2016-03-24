
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


------------------------------------------------------------------------------------------------
Supplementary Usage Notes for KCPSM6 Assembler v2.70 (Release 9)
------------------------------------------------------------------------------------------------

Ken Chapman - Xilinx Ltd - 30th September 2014 (Release 9)


Please see 'KCPSM6_User_Guide_30Sept14.pdf' before referring to this document.



------------------------------------------------------------------------------------------------
Assembler changes since version v2.63 distributed with Release 8 (31st March 2014)
------------------------------------------------------------------------------------------------


Support for 'STAR sX, kk' Instruction
------------------------------------

During the original design and implementation of KCPSM6 is was thought that pressure on the 
limited number of instruction op-codes would mean that it would only be possible to provide
the 'STAR sX, sY' instruction. So when KCPSM6 was released back in 2010 only the 'STAR sX, sY'
instruction was documented and supported by the assembler. Rather amusingly, four years later 
it was realised that the 'STAR sX, kk' instruction was also implemented by the original 
hardware definition! The documentation and the assembler have been enhanced so that we can all 
benefit from using this previously hidden instruction. 


Vivado 'ROM_form' Templates including UltraScale
------------------------------------------------

As the transition from the ISE to Vivado design tools gradually takes place we are faced
with situations like the UltraScale devices only being supported by Vivado and Spartan-6 
devices only being supported by ISE. This in turn means that the component libraries are 
different for each tool. For this reason, 'ROM_form_JTAGLoader_Vivado_2June14.vhd' and 
'ROM_form_JTAGLoader_Vivado_2June14.v' have been now been provided. Vivado users should
make a copy of the desired template and rename it 'ROM_form.vhd' or 'ROM_form.v' as 
appropriate.


------------------------------------------------------------------------------------------------
General Usage of KCPSM6
------------------------------------------------------------------------------------------------


The assembler is provided for the Windows operating system.


Running the Assembler
---------------------

The name of the file to be assembled must have the '.psm' extension. The name can be 
any length but the name must not contain any spaces.

     e.g.   This_is_an_acceptable_name_for_a_PSM_file.psm


The KCPSM6 assembler can be used interactively simply by running it and then entering 
the name of the PSM file to be assembled when prompted to do so (in this case the '.psm' 
extension is optional). The interactive mode is recommended when you are in the main code 
development phase of your work and repeatedly running the assembler.

Alternatively, the assembler can be invoked from the command line or from a batch file 
together with the name of the PSM file (the '.psm' extension is again optional but it is 
good practice to include it!). You may optionally provide an alternative name to be given
to the output files. When used, this name must not contain spaces and must not specify a 
file extension of any kind as the name will actually be applied to several different files.

     e.g.   kcpsm6 <name>[.psm] [<alternative_name_for_output_files>]

In this case the assembler will start and immediately attempt to assemble your specified 
PSM file. If the assembly is successful the assembler will close automatically. This
is useful when running batch files which are then free to continue with other tasks that 
probably use the successful results of the assembly. This also means that you will only 
have a brief opportunity to observe the messages displayed in the window before it closes. 
If however, there are errors in your PSM file the window will remain open for you to 
review the message, make a correction and perform another iteration of the assembler 
without needing to abandon your batch file execution sequence which will be waiting 
until the assembler is successful.

Finally, a rather elegant way to invoke the assembler is to locate your PSM file in Windows
Explorer and then select, drag and drop the PSM file over 'kcpsm6.exe'. This is equivalent  
to entering 'kcpsm6 <name>.psm' at the command line but without typing anything. This scheme 
is particularly quick and easy to use if you first create a shortcut of 'kcpsm6.exe' and 
place it on your desk top. You can then drag and drop any PSM file over it and all the files 
generated by the assembler will be written to the same directory as your PSM file.  


See 'Advanced Techniques and Operation' below for more detail and further options.


Default Output Files
--------------------

When the assembly is successful the following files will be generated. 

<name>.fmt - A file with the same name and essentially the same contents as your original
             PSM file but this time perfectly formatted. The '.fmt' file is written to the 
             same directory as the original PSM file. If INCLUDE directives are used, then
             a corresponding '.fmt' file will be generated and written into the same 
             directory as each PSM file.

             Hint - Use the '.fmt' file to replace your original file and make it look 
                    like you spent all day making things look so neat and tidy :-)

<name>.log - The report on the assembly process in full detail. The log file is written 
             to the same directory as that containing the top level PSM file and with 
             the same name. This is the default but an alternative name and path can be 
             specified if required by invoking the assembler from the command line.

<name>.hex - The assembled op-codes as a list of hexadecimal values used by utility programs
             such as JTAG_Loader. The HEX file always contains 4096 op-codes (a 4K program) 
             but typical programs will use much less (e.g. up to 1K or 2K) and all unused 
             locations will be set to zero. The HEX file is written to the same directory as 
             that containing the top level PSM file and with the same name. This is the
             default but an alternative name and path can be specified if required by 
             invoking the assembler from the command line.
 
Whenever the KCPSM6 assembler is used the following file will be generated.

KCPSM6_session_log.txt - This file contains everything that was displayed in the assembler 
                         window during the session. This file is automatically written into 
                         the directory in which the 'kcpsm6.exe' file is located. 
 
                         Hint - This can be particularly useful for those invoking the 
                                assembler from a batch file because the window closes 
                                automatically when successful.

                         Please note that this file really does contain everything that was 
                         output to the screen so depending on what application you use to 
                         view it you may see some strange characters corresponding with the 
                         changing of text colour originally. 



Generation of VHDL and Verilog Files
------------------------------------

To generate a VHDL and/or Verilog file then place the corresponding 'ROM_form.vhd' and/or 
'ROM_form.v' program memory template file in the same directory as your to level PSM file 
and the KCPSM6 assembler will automatically generate a VHDL and/or Verilog file for 
each 'ROM_form' template that is found. The generated VHDL and/or Verilog file 
will be assigned the same name as the original PSM file and written to the same directory 
unless an alternative name and directory was specified on the command line.

With appropriate 'ROM_form' templates the assembler supports the following program 
memory implementations...

   128 instruction program using 9-Slices (ROM only) in all devices.
   256 instruction program using 18-Slices (ROM only) in all devices.
   1K program using a RAMB18 (or similar) in all devices.
   2K program using a RAMB36 (or similar) for Virtex-6, 7-Series and UltraScale devices only.
   2K program using 2 x RAMB18 (or similar) for Spartan-6 devices only.
   4K program using 2 x RAMB36 (or similar) for Virtex-6, 7-Series and UltraScale devices only.
   4K program using 5 x RAMB18 (or similar) for Spartan-6 devices only**.
   4K program using 4 x RAMB18 (or similar) and 9 x LUT6 for Spartan-6 devices only**.
       ** 4K is not a natural fit in the Spartan-6 devices so there must be a trade off 
          between the use of a 5th BRAM or the delay, and hence reduced performance, 
          associated with a small amount of logic. 
   2K program using a RAMB36 for 7-Series devices with CRC error detection circuit.
   1.5K program using a RAMB36 for 7-Series devices with ECC protection.

   Please note that whilst the assembler is capable of supporting a 512 instruction 
   program using a RAMB8BWRE in a Spartan-6 there is an errata titled "9K Block RAM 
   Initialization" in EN148 that would make its use potential unreliable. Hence there 
   are no plans to provide a template for this memory size in Spartan-6 using 9K BRAM.
    

The following templates have been provided at this time. Remember to place a copy of the 
required template in the same directory as your PSM file and to rename it 'ROM_form.vhd'.
The verilog equivalent of each file (except if marked with '*') is also provided and 
these are used in exactly the same way but obviously with a copy of the desired file 
being renamed to 'ROM_form.v' for the assembler to read.

ROM_form_JTAGLoader_14March13.vhd         - Use with ISE v13.x or later 
ROM_form_JTAGLoader_3Mar11.vhd            - Use with ISE 12.x
ROM_form_JTAGLoader_Vivado_2June14.vhd'   - Use with Vivado 2014.x or later

  These are the default design and code development templates generally used at the start of
  all designs. Generics enable you to specify device family, program size and insert the JTAG 
  Loader for rapid code iterations. Each file contains more detailed descriptions of these
  generics and its use is described in the KCPSM6 User Guide.

ROM_form_S6_1K_5Aug11.vhd
ROM_form_S6_2K_5Aug11.vhd
ROM_form_S6_4K_23Nov12.vhd
ROM_form_V6_1K_14March13.vhd
ROM_form_V6_2K_14March13.vhd
ROM_form_V6_4K_14March13.vhd
ROM_form_7S_1K_14March13.vhd
ROM_form_7S_2K_14March13.vhd
ROM_form_7S_4K_14March13.vhd
ROM_form_128_14March13.vhd
ROM_form_256_5Aug11.vhd
ROM_form_7S_2K_with_error_detection_14March13.vhd *
ROM_form_7S_1K5_with_ecc_5Dec13.vhd *

  These are the templates recommended for production designs. Not only are these simplified
  memory definitions but they also ensure that JTAG Loader cannot accidently be included in
  your production design. Whilst JTAG Loader is an extremely useful development tool its 
  ability to access and modify your KCPSM6 program could present a threat to design security.
  Of course you may decide that you want to retain JTAG Loader as a feature in your deployed 
  products or to control your design using the generics on the development template. Simply 
  use the template and best fits your application.

  The name of each production template describes:-
    The device family it is for...
         'S6' for Spartan-6.
         'V6' for Virtex-6.
         '7S' for 7-Series (Artix-7, Kintex-7, Virtex-7 or Zynq).
         'US' for UltraScale.
    The size of the program memory implemented: 128, 256, 1K, 1.5K, 2K or 4K instructions.

  'ROM_form_128' and 'ROM_form_256' are implemented using 9 and 18 Slices and are suitable for
  relatively small programs releasing BRAM for other purposes. This can make KCPSM6's footprint
  very light indeed.
  
     
------------------------------------------------------------------------------------------------
Advanced Techniques and Operation
------------------------------------------------------------------------------------------------

The following notes will generally apply when batch files invoke the KCPSM6 assembler and 
specify the file names in the command line. 

Although the assembler will attempt to provide useful feedback when invoked from a command line 
or batch file, it is generally expected that paths are specified correctly and that PSM files 
and directories exist and are accessible to the assembler. Some incorrect command lines could 
be particularly confusing and result in multiple warning or error messages (i.e. one mistake  
can lead to other elements of the command line being interpreted incorrectly). 

If you specify an alternative name for the output files that is invalid a warning message 
will be generated but the assembly will continue, and if successful, result in the generation 
of output files with default names and locations based on the PSM file being assembled.

If the specified PSM file is not found by the assembler an error message will be generated 
and you will invited to provide the name of a PSM file that does exist. However, this will 
also mean that the files generated by the assembler will be given default names based on the 
name of the PSM file specified. 

Path Specifications
-------------------

Any specification of a file name can include a specification of a path to its location. The 
path can be absolute or relative. This can be very useful but there are specific rules which 
should be understood. 

If there are spaces contained in the names of any directories used in the paths to PSM files
or the output files then the path\filename must be enclosed within quotation marks. If in 
doubt always use quotation marks.

Examples...


    kcpsm6 C:\my_projects\display\pico_code\motor_control.psm ..\control_program

    In this case there are no spaces present in any directory names and the assembler will 
    assemble 'motor_control.psm' located in the 'C:\my_projects\display\pico_code' directory
    and write output files named 'control_program' to the 'C:\my_projects\display' directory.

    
    kcpsm6 "C:\Xilinx projects\space robot\psm\motor_control.psm" ..\pb_program

    In this case there are spaces in the directory names but the quotation marks define the
    beginnind and end of the input path and PSM file specification so the assembler will 
    assemble 'motor_control.psm' located in the 'C:\Xilinx projects\space robot\psm' directory
    and write output files named 'pb_program' to the 'C:\Xilinx projects\space robot' directory.

In most cases a batch file is located in the same directory as the program to be assembled allowing 
a simplified command line to be used in the first place and therefore naturally avoiding the 
specification of the path regardless of if it contains any spaces or not. 

There is also no issue with spaces when specifying paths in INCLUDE directives as these are 
always enclosed within quotation marks (e.g. INCLUDE "C:\Xilinx projects\space robot\psm\pwm.psm").  


Where the 'ROM_form' templates are found
----------------------------------------

The KCPSM6 assembler will attempt to read the 'ROM_form' templates from the same directory as the 
PSM file being assembled. Note that any other directories in which any files specified by INCLUDE 
directives are otherwise ignored (i.e. only the location of the top level file is searched).

Where files are written
-----------------------
 
Regardless of the directory in which a PSM file is located, a corresponding FMT file will be written 
into the same directory following successful assembly. When INCLUDE directives are used to include 
additional files, a FMT file will be written into their corresponding directories too.

Unless an alternative output path and file name is specified on the command line, the LOG file, 
HEX file and any V and VHD files will be written to the same directory as the top level PSM file that 
is being assembled and all these files will adopt the same name as the PSM file. When an alternative
path and name for output files is specified on the command line then the LOG, HEX, V and VHD files
will be written to that directory with the name defined. Note that the output directory must already 
exist as KCPSM6 will not create the directory if it does not.


Examples....

kcpsm6 c:\Ken\my_prog.psm

   Assuming that 'my_prog.psm' contained the following directive
     INCLUDE "have_fun.psm"

   KCPSM6 will attempt to read the following files from c:\Ken
     my_prog.psm
     have_fun.psm
     ROM_form.v
     ROM_form.vhd
   KCPSM6 will write the following files to c:\Ken
     my_prog.fmt
     have_fun.fmt 
     my_prog.log
     my_prog.hex
     my_prog.v       <- Only if 'ROM_form.v' was present 
     my_prog.vhd     <- Only if 'ROM_form.vhd' was present 

   In the directory where kcpsm6.exe is located 
     KCPSM6_session_log.txt 


kcpsm6 c:\Ken\my_prog c:\Nick\kcpsm6_rom

   Assuming that 'my_prog.psm' contained the following directive
     INCLUDE "..\Marc\have_fun.psm"


   KCPSM6 will attempt to read the following files from c:\Ken
     my_prog.psm
     ROM_form.v
     ROM_form.vhd
   KCPSM6 will attempt to read the following files from c:\Marc
     have_fun.psm
   KCPSM6 will write the following file to c:\Ken
     my_prog.fmt
   KCPSM6 will write the following file to c:\Marc
     have_fun.fmt
   KCPSM6 will write the following files to c:\Nick
     kcpsm6_rom.log
     kcpsm6_rom.hex
     kcpsm6_rom.v        <- Only if 'ROM_form.v' was present 
     kcpsm6_rom.vhd      <- Only if 'ROM_form.vhd' was present 

   In the directory where kcpsm6.exe is located 
     KCPSM6_session_log.txt 



Error Codes
-----------

When KCPSM6 completes it will set the ERRORLEVEL system variable based on the success of failure 
of the assembly process. 

ERRORLEVEL=0 when assembly completes successfully.
ERRORLEVEL=1 when there was an error present at the point at which the assembler was quit.

A batch file can test for the error condition to take an appropriate action. In this example a 
successful assembly is followed by running JTAG Loader to update the program in the device...

kcpsm6 my_program.psm
IF ERRORLEVEL 1 GOTO failed
REM Assembly was successful so run JTAG Loader 
JtagLoader -l my_program.hex
GOTO end
:failed
REM Oh dear, that didn't work did it?
:end


User defined maximum program size option
----------------------------------------

The KCPSM6 assembler always checks that the program does not exceed the maximum program size
of 4096 instructions and will generate an error should this occur. In addition each successful
assembly includes a report (on screen and in the log file) of the last occupied address and 
the nominal program size as shown in this example below.

Last occupied address: FFE hex
Nominal program memory size: 4K    address(11:0)

This information should be used to ensure that the physical memory you have provided to 
KCPSM6 in your design is also of an adequate size.

However, it has been found that the use of a batch file to automate the process of assembly and
then to invoke the JTAG Loader is so fast and convenient that is all too easy to miss this 
report and exceed the limit of a smaller physical memory. For example a program may initially 
fit easily within a 1K memory so you specify 'C_RAM_SIZE_KWORDS => 2' in your design. Then as 
you develop your code it gradually grows until it eventually exceeds the 1024 locations that 
you have provided. The assembler reports that you need a nominal program memory of 2K but you 
don't notice it!

This command line option allows you to specify a 'check' value for the maximum program size.
In this way the assembler will generate an error before reaching the absolute maximum of 4K 
and therefore ensure that you do not miss the growth of your program.

Usage....

   kcpsm6 -c1024 my_program

The -c option must be the first item following the kcpsm6 command (before input file name).
-c must be immediately followed (no spaces) by the maximum program size in the range 1 to 4096.

If no filenames are specified on the command line then the assembler will open in interactive 
mode but with the user defined maximum program size.




------------------------------------------------------------------------------------------------
Known Limitations
------------------------------------------------------------------------------------------------


Quotation marks in comments associated with STRING directives and ASCII constants
---------------------------------------------------------------------------------

When using a STRING directive or defining constants using ASCII characters, all characters 
between the first and last quotation marks on the line will be interpreted to be the definition
of the text string. This enables your string to contain all the basic visible characters 
including quotation marks, colons and semi-colons. So the assembler will correctly interpret the 
following examples...

 STRING info$, "Program version: 3.0"  ;The colon is part of the text string not for a label
 STRING quote$, "He said "go away" in a loud voice" ;Quotes are supported in a text string
 COMPARE s4, ":"  ;Compare register with ASCII value of a colon 
 COMPARE s4, ";"  ;The semi-colon within quotation marks does not start this comment 
 COMPARE s4, """  ;Compare register with ASCII value of a quotation mark
 LOAD s4, s8 ;A comment can contain quotation marks "like this" one! 
 LOAD s4, s8 ;A comment can contain all sorts of characters like :;" 

The limitation is that you cannot include quotation marks in the comment field when using  
a STRING directive or defining constants using ASCII characters. The issue is that the text 
string is interpreted as everything between the first and last quotation marks on the line.
For this reason the following examples would be misinterpreted by the assembler...
 
 STRING quote$, "He said "go away" in a loud voice" ;Display "go away" message

   - In this case the assembler would think the text string being defined was 
              "He said "go away" in a loud voice" ;Display "go away" 
     and then there would be a syntax error because 'message' would appear to be a 
     third operand and not part of a comment.

 COMPARE s4, """  ;Look for a " character

   - In this case the assembler would think that the second operand was the text string 
                        """  ;Look for a " 
     and this would then be a syntax error because the second operand needs to be a single 
     ASCII character for this instruction and 'character' would appear to be a third operand 
     and not part of a comment.

This limitation is a consequence of allowing all visible ASCII characters to be used within 
STRING directive or when defining constants using ASCII characters. It was felt that this provided 
a greater benefit when writing PSM code than to say that colons, semi-colons and quotation marks 
where reserved characters only to be used to identify line labels, comments, strings and ASCII 
constants.  

------------------------------------------------------------------------------------------------
End of file 'kcpsm6_assembler_readme.txt'
------------------------------------------------------------------------------------------------

