
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
KCPSM6 : Known Issues and Workarounds
-------------------------------------------------------------------------------------------------

This file was included with KCPSM6 Release 9 - 30th September 2014.

Ken Chapman - Xilinx Ltd - 30th September 2014  


This document contains known issues and workarounds with PicoBlaze or when using PicoBlaze in an
ISE or Vivado design environment. For more general discussion and to share ideas and experiences
please visit the PicoBlaze forum. It is likely that commonly asked questions will be discussed
here and threads provide a resource for everyone to be able to read.  

http://forums.xilinx.com/t5/PicoBlaze/bd-p/PicoBlaze

Xilinx Technical support is also available to answer your questions. However it is recommended
that you take the time to consider exactly what your issue is before asking any questions. Just 
because your design contains a PicoBlaze processor doesn't mean you actually have a problem 
with PicoBlaze! If you are a Xilinx novice and encounter difficulties then make sure you can 
get a simple HDL design through ISE or Verilog before including PicoBlaze.   

http://www.xilinx.com/support/clearexpress/websupport.htm



-------------------------------------------------------------------------------------------------
Contents
-------------------------------------------------------------------------------------------------

Potential issues when using ISE 12.x 

JTAG Loader requires ISE/ChipScope when using Vivado

'The XILINX environment variable is not set or is empty'
'The program can't start because libCsdFpga.dll is missing...'

'PCMSVCR100.dll' or 'MSVCR100.dll' is missing or could not be found

KCPSM6 program memory can be corrupted when configuring device with Vivado 'Hardware Manager'.

KCPSM6 size may vary when using Vivado 

WARNING:Xst:647 - Input <instruction<0:11>> is never used

INFO:Xst:2261 or WARNING:Xst:1710 messages relating to Unit <jtag_loader_6> 

JTAG Loader not working

JTAG Loader may take ~25 seconds to load a new program when using an ATLYS board

Designs containing multiple KCPSM6 processors

'global_opt' may result in incorrect implementation

'Pack:2811' errors in MAP when using ChipScope

'Pack:2811' errors in MAP when using 'Keep Hierarchy' and design contains multiple KCPSM6.

'Pack:2811' errors in MAP when using a low 'Max Fanout' value in XST.

'PhysDesignRules:1422' errors reported by BITGEN

JTAG Loader and BSCAN Users 

KCPSM6 program memory can be corrupted when using ChipScope Analyser

KCPSM6 program memory can be corrupted when using Vivado Hardware Manager

Poor Display of Strings in ISE Simulator 

KCPSM6 Assembler window takes a long time to appear on screen

-------------------------------------------------------------------------------------------------
Descriptions
-------------------------------------------------------------------------------------------------


Potential issues when using ISE 12.x 
------------------------------------

Using ISE v12.x may result in XST generating errors similar to the following...

    HDLCompiler:1314 - "<program_ROM_filename>.vhd" Line 390: 
      Formal port/generic <rdaddr_collision_hwconfig> is not declared in <ramb18e1>

The logic primitives including BRAM are defined in libraries that XST reads as it elaborates
your design. Not surprisingly these libraries change with each release of the ISE tools. In 
particular the ISE v13.x tools introduced support for the 7-Series devices a obviously this 
required quite significant additions and alterations to the underlying libraries. 

The ROM_form templates have been prepared to match with the libraries provided with ISE v13.x
and therefore the potential exists for a something to be absent from an older library 
resulting in a error similar to that shown above. 

It is recommended that you use ISE v13.2 or later with KCPSM6 but if this is not convenient 
then simply replace the default 'ROM_form.vhd' or 'ROM_form.v' template with a copy of an 
older template that was supplied with 'Release 2' of KCPSM6 and included in this package 
for your convenience.

  Provided for use with ISE v13.x or later

               ROM_form_JTAGLoader_14March13.vhd    
               ROM_form_JTAGLoader_14March13.v  

  Provided for use with ISE v12.x only

               ROM_form_JTAGLoader_3Mar11.vhd    
               ROM_form_JTAGLoader_3Mar11.v  


JTAG Loader requires ISE/ChipScope when using Vivado
----------------------------------------------------

In order to use JTAG loader the drivers associated with ChipScope must be present. These 
drivers provide access the Platform Cable USB or the equivalent Digilent circuit. It is 
therefore necessary to also have an installation of ChipScope which is part of the ISE 
tools. Please see page 25 of 'PicoBlaze_Design_in_Vivado.pdf' which presents a simple 
batch file that will set environment variables that specify the location of ISE on you  
PC so that JTAG Loader will be able to work. 
 

'The XILINX environment variable is not set or is empty'
'The program can't start because libCsdFpga.dll is missing...'
--------------------------------------------------------------

The 'PATH' and 'XILINX' environment variables must be correctly set to the location of 
an ISE installation. Please see one or more of the following for further details...

   'READ_ME_FIRST.txt'              - 'System Requirements' section.
   'KCPSM6_User_Guide_30Sept14.pdf' - Page 25.
   'PicoBlaze_Design_in_Vivado.pdf' - Page 25.


'PCMSVCR100.dll' or 'MSVCR100.dll' is missing or could not be found
-------------------------------------------------------------------

The following description is also to be found in the 'System Requirements' section of the 
'READ_ME_FIRST.txt' file.

JTAG Loader must also be able to access some system level DLL files. In the case of a Windows-XP
environment then it is normal for the PATH to contain 'C:\WINDOWS\system32;' or similar. So if 
you receive a system error indicating that 'PCMSVCR100.dll' is missing or could not be found then
add the appropriate definition to your PATH. When using a Windows-7 environment it is more likely 
that 'MSVCR100.dll' will become the subject of a system error message. 'MSVCR100.dll' is not part
of a default Windows-7 installation but is a often present as a result of a Microsoft Visual C++
application. If you do encounter this issue then the quickest solution is to place a copy of 
'msvcr100.dll' provided in the 'JTAG_Loader' directory of this package in to the same directory
as the JTAG Loader executable you are invoking.



KCPSM6 program memory can be corrupted when configuring device with Vivado 'Hardware Manager'.
----------------------------------------------------------------------------------------------

Vivado 'Hardware Manager' results in the same memory corruption issue as described in 
'KCPSM6 program memory can be corrupted when using ChipScope Analyser'. In this case the only
workarounds are either to use iMPACT to configure your device or to write your program in a way 
that avoids address 003. For example, placing the following at the start of a program will ensure
that the corrupted location is not executed at all.

            JUMP cold_start   ;Avoid address 003 on start up
            JUMP cold_start
            JUMP cold_start
            JUMP cold_start   ;Address 003 
            ;
cold_start: <normal program code starts here>


KCPSM6 size may vary when using Vivado 
--------------------------------------

When using Vivado to implement a design, KCPSM6 will probably occupy more than the 26-32 
Slices predictably achieved when using the ISE tools and quoted in the documentation. The 
maximum performance may also be lower. Vivado (at least up to 2014.2), ignores the Slice 
packing directives (i.e. HBLKNM attributes) contained in the source VHDL and Verilog files
and this tends to result in KCPSM6 being distributed across a larger number of Slices. Vivado
packs designs more tightly the more a design fills a given device so this is not a significant
issue. However, the size reports can be misleadingly large when implementing a simple test case.  

The architecture of UltraScale devices is somewhat different in that every Slice has 8 LUTs 
rather than the 4 LUTs in the Slices of Spartan-6, Virtex-6 and 7-Series devices. It is 
therefore expected that KCPSM6 would appear to occupy less Slices in an UltraScale device 
but that is really just a difference in architecture.


Unrecognised 'RAMB18E2' Primitives in Program Memory when using ISE
-------------------------------------------------------------------

This will happen if you assembled your program whilst using the 'ROM_form' template intended
for use with Vivado (e.g. 'ROM_form_JTAGLoader_Vivado_2June14.vhd'). When using ISE you should 
assemble your programs using a copy of 'ROM_form_JTAGLoader_14March13.vhd' which is the original
template compatible with ISE. Alternatively, assemble your program using one of the 'production
templates' consistent with the target device and memory size required.


WARNING:Xst:647 - Input <instruction<0:11>> is never used
---------------------------------------------------------

XST in ISE v12.x and ISE v13.x incorrectly reports the following warning message....

   WARNING:Xst:647 - Input <instruction<0:11>> is never used. 

This warning can safely be ignored. However, it should be recognised that if a similar warning 
message reports that all 18-bits of instruction (instruction<0:17>) are never used then it 
probably means that you really didn't connect the program memory to KCPSM6 correctly. 

This issue was fixed in ISE version 14.1. 


INFO:Xst:2261 or WARNING:Xst:1710 messages relating to Unit <jtag_loader_6> 
---------------------------------------------------------------------------

XST typically issues two or three messages concerning 'FF/Latch <control_dout_int_2>' or 
similar when the design has JTAG Loader enabled. These messages can be safely ignored because 
they reflect the way in which certain signals have been assigned the same constant values
which the JTAG Loader utility will later use to understand your PicoBlaze design (e.g. a value
defining the size of your program memory). 

Once JTAG Loader is disabled or a production 'ROM_form' template is used there should be no 
messages of this kind. 

Note that XST issues 'INFO' messages when the program memory file is VHDL and 'WARNING' messages
when the program memory file is Verilog. Hence, if you use a VHDL file to define your program
memory the messages will become 'INFO' even if the remainder of your project is Verilog.


JTAG Loader not working
-----------------------

If you experience any issues related to not being able to find a DLL then please check the 
'Requirements' section above to ensure that your environment variables are set appropriately. 

Vivado users must install ChipScope provided with ISE (see 'Requirements') 

JTAG Loader may not work correctly if you have more that Platform Cable USB connected to your 
PC at the same time so the obvious workaround is only to connect the cable associated with 
the chain in which your target device is located. Please note that many development boards and 
evaluation kits such as ATLYS or ML605 boards have Platform Cable USB circuit or Digilent 
equivalent included on them so the most common reason for appearing to have multiple cables 
connected is when one or more of these boards are connected (or one of these boards and a real
Platform Cable USB).


JTAG Loader may take ~25 seconds to load a new program when using an ATLYS board
--------------------------------------------------------------------------------

Loading a KCPSM6 program normally takes about 5 seconds so this issue is under investigation.
However, it is only a case of being slower than expected; operation is correct and reliable.


Designs containing multiple KCPSM6 processors
---------------------------------------------

It is common practice for designs to contain multiple instances of PicoBlaze with each typically 
acting as an independent 'state machine'. There are also some designs in which hundreds, or even 
thousands, are used to implement amazing structures and algorithms. Regardless of how many 
KCPSM6 processors are included, the use model and design method is really the same for each 
instance so there is really very little to consider just because there is more than one. That
said, the following points may be helpful in making your multi-KCPSM6 enjoyable.

When using the default 'ROM_form' template your assembled program file provides you with the 
option to enable the JTAG Loader circuit. However, you do need to remember that only one program 
memory can have this feature enabled at any time. Hence, only one instance can have 
'C_JTAG_LOADER_ENABLE' assigned the value '1' and all other instances must be assigned '0'.

Although compliance with the fundamental limitation described above should result in a design 
that will successfully pass through the ISE tools you will find that WARNING messages are 
generated for each instance or program memory assembled using the default 'ROM_form' template.
This is because the default 'ROM_form' template includes the definition of the JTAG Loader 
circuit and this means that synthesis observes a repeated definition of the JTAG Loader circuit
(and a function) in each instance irrespective of the loader being enabled or not. These warnings
can be safely ignored but if you are looking for more elegance (and why shouldn’t you?), then 
here are two techniques for you to consider.

a) Replace the default 'ROM_form' template with the appropriate 'Production Memory' template. 
   These are described on page 47 of the KCPSM6 user guide and in 'kcpsm6_assembler_readme.txt'.
   Once a program is assembled using a production template then the memory definition file 
   only contains the specific BRAM(s) necessary for your application. JTAG Loader is no longer 
   included and hence replicated definition is avoided. Use of 'Production Memory' does require
   small changes to your design (i.e. the instantiation no longer includes generics or the 'rdl'
   port) but this is a recommended step before release of a product anyway and suitable once 
   any program has become stable.

b) If you still want to maintain the ability to enable the JTAG Loader on a program instance 
   in the design (obviously you can only enable one at a time) then you have to keep the 
   JTAG Loader option available within each instance. To avoid those warning messages you 
   need to ensure that the JTAG Loader is only defined once in overall design. This ultimately 
   means separating the definition of JTAG Loader from the definition of the program memory.

   Start by making a copy of the default template ('ROM_form_JTAGLoader_16Aug11.vhd') and remove 
   all items defining JTAG Loader. Locate and delete the code near the top that defines a function
   called 'addr_width_calc' and all the code towards the end following the 'JTAG Loader' comment
   banner that defines the actual JTAG Loader circuit. In the 'Miscellaneous' directory you can 
   find 'ROM_form_for_multiple_instances.vhd' which has already had these items removed from the 
   default template and ready for you to use.

   You must (only) assemble one program using the default template which will include the definition 
   of JTAG Loader. All other programs must be assembled using the modified template which only 
   define the program memory (hint - assemble programs in different directories containing the 
   'ROM_form' template required).


'global_opt' may result in incorrect implementation
---------------------------------------------------

Setting 'global_opt' to anything other than 'off' (the default) in MAP when using ISE v13.1 or
ISE 13.2 may result in incorrect implementation of the KCPSM6 logic and therefore a failure to 
execute code in the way expected (e.g. shift and rotate operations may not work properly). The 
'area' setting may even prevent your design from passing through MAP at all. This issue had
not been observed when using ISE v12.4 and there are no issues as long as 'global_opt' is set 
to 'off'. Note that when using ISE v13.2 to target a 7-Series device the 'global_opt' option 
is not available and therefore this issue can only occur when targeting Spartan-6 or Virtex-6.
 
The cause of this issue was located and then fixed in ISE v13.4 so you should use ISE v13.4 
or later when 'global_opt' needs to be set to anything other than 'off' in order to process 
other parts of your design. However, a user of ISE v13.4 did still appear to have a similar
issue when ChipScope was also being used to probe inside KCPSM6.


'Pack:2811' errors in MAP when using ChipScope
----------------------------------------------

Connection of ChipScope can generate 'Pack:2811' errors in MAP. This mainly appears to happen 
when connecting 'out_port' or 'port_id' directly to ChipScope. It has also been known to 
happen when connecting ChipScope directly to the 'address' or 'instruction' ports.
  
There are four potential workarounds for this issue.
  a) To insert a pipeline register between KCPSM6 and ChipScope.
  b) Set the 'Keep Hierarchy' option in XST to 'Yes' (default is 'No').
     However this may not work if there are more than one KCPSM6 (see below).  
  c) Set the following system environment variable: XIL_MAP_OLD_SAVE=1.
     Close ISE.
     Right click on 'My Computer' and select 'Properties'.
     Go to the 'Advanced' tab and choose 'Environment Variables'. 
     Use 'New' or 'Edit' as necessary.
     Open and run ISE again.  
  d) Remove or comment out all the Slice packing directives (HBLKNM attributes) in the KCPSM6 
     source file. The 'kcpsm6_without_slice_packing_attributes.vhd' located on the 'Miscellaneous' 
     directory already has these attributes commented out. Using this workaround will result in 
     KCPSM6 occupying more Slices and having a lower peak performance and therefore it is 
     better to only resort to using it if the other methods cannot be used or are unsuccessful. 


'Pack:2811' errors in MAP when using 'Keep Hierarchy' and design contains multiple KCPSM6.
------------------------------------------------------------------------------------------

This error has been observed when a design contains multiple instances of KCPSM6 and 
the 'Keep Hierarchy' option in XST has been set to 'Yes'. Therefore the obvious solution is
to revert to the default setting of 'No'. Alternatively the 'Allow Logic Optimization Across
Hierarchy' option in MAP can be enabled (tick box in Project navigator or apply the 
-ignore_keep_hierarchy switch on the command line).

If it is undesirable to adjust your implementation settings then please see 'c' and 'd' 
workarounds in the issue above. 


'Pack:2811' errors in MAP when using a low 'Max Fanout' value in XST.
---------------------------------------------------------------------

The 'Max Fanout' parameter is a 'Xilinx Specific Option' for XST and has the default value 
of 100000 for the devices used with KCPSM6. It has been known for very low values (e.g. <20)
to result in a subsequent error in MAP. Should this occur, please increase the value. If 
you have a particular reason to use such a low value then synthesize KCPSM6 separately and 
include it in your design as a 'black box'.


'PhysDesignRules:1422' errors reported by BITGEN
------------------------------------------------

Should this error report occur then it will probably look something like this....

ERROR:PhysDesignRules:1385 - Issue with pin connections and/or configuration on
block:<instance_name>/stack_ram_high_RAMD_D1>:<LUT_OR_MEM6>. For RAMMODE programming
set with DPRAM32 or SPRAM32 or SRL16 the DI2 input pin must be connected.

This error has only occurred in designs where the user has not connected all 12-bits of the 
address bus to a program memory. Hence the simple and obvious solution is to ensure that 
all address bits are connected to something.

Regardless of the memory size, all the supplied 'ROM_form' templates connect all address bits
to something so that these signals and associated logic are preserved. This makes it easier to
increase or decrease the memory size and avoids warning messages (as well as this error). As 
such, if you have encountered this error you are probably using your own 'ROM_form' template 
in which one or more of the (most significant) address bits are not required and have not been
connected to something in order to preserve them.

Whilst it is generally a good idea for unused logic to be trimmed, KCPSM6 is so optimised 
to the architecture and so tightly packed into the logic Slices that any logic trimming is
insignificant. Furthermore, any trimming only leads to the formation of unusable 'holes' in 
otherwise used Slices so there is nothing to be gained. This is particularly true of what 
happens to the memory used to implement the program counter stack when any of the address 
bits are unused and leads to the error being generated. Obviously it would be better if the 
tool chain could handle this better but it just happens to be one of those cases that is 
more challenging than it first appears to be!  


JTAG Loader and BSCAN Users 
---------------------------

The JTAG Loader utility employs a BSCAN primitive within the device to form a bridge to the 
KCPSM6 program memory. Other applications may also exploit a BSCAN primitive such as ChipScope
which implements a bridge between ChipScope Analyser and an associated ICON core. The good news
is that there are four BSCAN primitives in each device so it is unlikely that you will not have
enough of them. Clearly, if you do exceed the number available then your only recourse is to  
reduce the number required; possibly disabling JTAG Loader so that the rest of your design can 
fit will be the easiest solution.

However, since there are normally enough BSCAN primitives available, the more common issue 
relates to the allocation of the 'USER' address to each BSCAN primitive. As provided, the JTAG 
Loader is assigned to 'USER2'. When generating an ICON core for ChipScope there is an option to 
set the 'boundary scan' value to USER1, USER2, USER3 or USER4 but this is normally set to 'USER1' 
so in most cases ChipScope and JTAG Loader happily co-exist.

If you find it necessary to assign JTAG Loader to a different 'USER' then you will need to 
make a small adjustment to hardware and use JTAG Loader with the '-i' option as shown below.

To modify the hardare, open the default 'ROM_form' template and locate the line shown below and 
adjust the number '2' to '1', '3' or '4' as desired...

    'ROM_form.vhd' (approximately line 256 and part of 'component jtag_loader_6') 
  
             C_JTAG_CHAIN : integer := 2;
      
    'ROM_form.v' (approximately line 295 and part of 'module jtag_loader_6')
 
             parameter integer C_JTAG_CHAIN = 2;

You will then need to assemble your PSM file such that the new assignment is transferred into
your actual design file. Obviously, since this is a change to the hardware definition you must 
also process the whole design, generate a BIT file and configure the device with it too.

When you run the JTAG Loader utility it assumes the default USER number is '2' so you will now 
need to use the '-i' option to specify the same USER number that you defined in your template.
For example, if the line in the VHDL template was changed to 'C_JTAG_CHAIN : integer := 4;' 
then to update the KCPSM6 program using JTAG Loader the command will be...

     jtagloader -i4 -l your_program.hex

   (where 'jtagloader' is the required executable for your operating system). 


KCPSM6 program memory can be corrupted when using ChipScope Analyser.
---------------------------------------------------------------------

If your PicoBlaze design has JTAG Loader enabled and the device is configured with the BIT 
file using ChipScope Analyser (rather than iMPACT) then this can result in corruption to one 
location of the program memory. Other uses of ChipScope may also result in the same corruption
which will almost certainly be to the 4th instruction in the program memory (address 003) and 
result in that location being cleared to 00000 Hex. This value is equivalent to a 'LOAD s0, s0' 
instruction which will do nothing but obviously that still means that your intended instruction
is missing and effect the execution of your program.

Note that there does not need to be a ChipScope Core in the design, it is purely the act of 
using ChipScope Analyser that has this effect even if it is only used to configure the device. 
The issue is related to the way ChipScope Analyser searches for a ChipScope core in your design 
and that process interfering with JTAG Loader which makes use of a BSCAN primitive in a very 
similar way to that of a ChipScope core. 

If you suspect that this is happening then JTAG Loader can be used to confirm it using its 
read back facility. First read back the contents of the memory into a temporary hex file...

   jtagloader -r temp.hex

Then compare the contents of this hex file with the hex file generated by the KCPSM6 assembler
for your program. It should be easy to see the '00000' value near the top of the file if 
corruption has taken place.

Fortunately there are several workarounds:-

  a) Use iMPACT rather than ChipScope to configure the device with your BIT file.
  b) Following configuration by ChipScope Analyser, use JTAG Loader to refresh the program 
     memory with a valid image (you will do this naturally if using JTAG Loader during 
     program development).
  c) Disable JTAG Loader if you don't need to use it.
  d) Start your PSM program with directive 'ADDRESS 004' such that your code begins at 
     address 004. In this way the first four locations of memory will default to 00000 hex
     ('LOAD s0, s0' has no effect) and the clearing effect of the corruption will become 
     irrelevant. Note that the DEFAULT_JUMP directive would override this default though.
  e) Place the following instructions at the start of your program so that address 003 
     is avoided.
                     JUMP cold_start   ;Avoid address 003 on start up
                     JUMP cold_start
                     JUMP cold_start
                     JUMP cold_start   ;Address 003 
                     ;
         cold_start: <normal program code starts here>
 
  f) Modify the ChipScope Analyser project file '.cpj' as described below.
     
     Note that this method requires ISE v13.3 or later to work correctly. 

       i) Insert the line 'avoidUserRegDevice0=2' in your '.cpj' file. 
          For example...

              #ChipScope Pro Analyzer Project File, Version 3.0
              #Tue Aug 20 16:17:05 BST 2013
              avoidUserRegDevice0=2
              device.0.configFileDir= ....

          This tells ChipScope Analyser to avoid 'USER2' which is assigned to JTAG Loader
          from being scanned in the first device (device '0') in the JTAG chain. Adjust 
          'avoidUserRegDevice0' as appropriate for the device position in your JTAG chain.
      ii) Start ChipScope Anaylser and open the project (.cpj file). You must do this first.
     iii) Then you can 'Open Cable/Search JTAG Chain' and you should see a messages similar
          to "INFO: Skipping xsdb core scan on device 0, user register 2" displayed in 
          the console confirming that 'USER2' has been avoided.
      iv) Configure your device (probably worth using 'jtagloader -r' to confirm that 
          everything worked correctly the first time you try it but should be Ok after that).

     Answer Record 19337 (http://www.xilinx.com/support/answers/19337.htm) may also be 
     useful reference when using ChipScope Analyser.


KCPSM6 program memory can be corrupted when using Vivado Hardware Manager
-------------------------------------------------------------------------

This is very similar to the known issue described immediately above but there are fewer options
when it comes to implementing a workaround. Please see page 24 of 'PicoBlaze_Design_in_Vivado.pdf'
for more details of this known issue.


Poor Display of Strings in ISE Simulator 
----------------------------------------

The way in which iSim (in ISE) displays text strings is not ideal for the observation of 
'kcpsm6_opcode' and 'kcpsm6_status' during simulation. It seems unlikely that this will be 
rectified in ISE. These text strings are displayed correctly when using the Vivado Simulator.


KCPSM6 Assembler window takes a long time to appear on screen
-------------------------------------------------------------

In most cases the assembler window should open almost immediately so if it takes more than a few
seconds, especially if your PC is not busy processing other applications, then this is worthy of
some investigation and an experiment. Have a look to see what your default printer is set to... 

    Start -> Printers and Faxes 

The default printer will have a small tick next to it. Ideally you should assign a local printer
and make sure that the selected printer is available to Windows applications (a printer 
doesn't actually need to be turned on but should be capable of printing from applications
e.g., a USB connected printer will normally automatically turn on when sent a document).

    Right click on the desired printer and select 'Set as Default Printer'.
    The small tick mark will move.

Run the KCPSM6 assembler again and see if that has made it open faster. If it is not convenient
to change the default printer then the quickest and easiest way to use KCPSM6 in interactive 
mode. Run KCPSM6 and wait for it to open. Then enter the name of your PSM file and let it 
assemble your PSM code. Then just leave the KCPM6 assembler open and then use the 'R' and 'N' 
options to control assembly. In this way you avoid having to wait for the assembler to open 
each time. 

Although rare, this issue typically occurs when a network printer has been assigned as the 
default but the Windows applications cannot find it. This can also be associated with the print 
driver being incorrect or requiring an update. If the network and/or printer driver can not 
be resolved then consider assigning a local printer as the default. If you don't have a physical 
local printer then a useful technique is to install a PDF writer and make that your default 
printer.

-------------------------------------------------------------------------------------------------
End of file 'READ_ME_FIRST.txt'
-------------------------------------------------------------------------------------------------
