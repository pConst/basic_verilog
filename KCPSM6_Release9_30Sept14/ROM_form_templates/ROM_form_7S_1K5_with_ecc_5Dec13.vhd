--
-------------------------------------------------------------------------------------------
-- Copyright © 2010-2013, Xilinx, Inc.
-- This file contains confidential and proprietary information of Xilinx, Inc. and is
-- protected under U.S. and international copyright and other intellectual property laws.
-------------------------------------------------------------------------------------------
--
-- Disclaimer:
-- This disclaimer is not a license and does not grant any rights to the materials
-- distributed herewith. Except as otherwise provided in a valid license issued to
-- you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
-- MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
-- DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
-- INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
-- OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
-- (whether in contract or tort, including negligence, or under any other theory
-- of liability) for any loss or damage of any kind or nature related to, arising
-- under or in connection with these materials, including for any direct, or any
-- indirect, special, incidental, or consequential loss or damage (including loss
-- of data, profits, goodwill, or any type of loss or damage suffered as a result
-- of any action brought by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-safe, or for use in any
-- application requiring fail-safe performance, such as life-support or safety
-- devices or systems, Class III medical devices, nuclear facilities, applications
-- related to the deployment of airbags, or any other applications that could lead
-- to death, personal injury, or severe property or environmental damage
-- (individually and collectively, "Critical Applications"). Customer assumes the
-- sole risk and liability of any use of Xilinx products in Critical Applications,
-- subject only to applicable laws and regulations governing limitations on product
-- liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------------------
--

ROM_form.vhd

Production template for a 1.5K program (address range 000 to 5FF) for KCPSM6 in a 7-Series
device using a RAMB36E1 primitive with built-in Error Correcting Code (ECC) and 4.5 Slices.

PLEASE READ THE DESCRIPTIONS AND ADVICE  LATER IN THIS TEMPLATE OR CONTAINED IN THE 
ASSEMBLED FILE. 


Ken Chapman (Xilinx Ltd)

5th December 2013 - Initial Release



This is a VHDL template file for the KCPSM6 assembler.

This VHDL file is not valid as input directly into a synthesis or a simulation tool.
The assembler will read this template and insert the information required to complete
the definition of program ROM and write it out to a new '.vhd' file that is ready for 
synthesis and simulation.

This template can be modified to define alternative memory definitions. However, you are 
responsible for ensuring the template is correct as the assembler does not perform any 
checking of the VHDL.

The assembler identifies all text enclosed by {} characters, and replaces these
character strings. All templates should include these {} character strings for 
the assembler to work correctly. 


The next line is used to determine where the template actually starts.
{begin template}
--
-------------------------------------------------------------------------------------------
-- Copyright © 2010-2013, Xilinx, Inc.
-- This file contains confidential and proprietary information of Xilinx, Inc. and is
-- protected under U.S. and international copyright and other intellectual property laws.
-------------------------------------------------------------------------------------------
--
-- Disclaimer:
-- This disclaimer is not a license and does not grant any rights to the materials
-- distributed herewith. Except as otherwise provided in a valid license issued to
-- you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
-- MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
-- DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
-- INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
-- OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
-- (whether in contract or tort, including negligence, or under any other theory
-- of liability) for any loss or damage of any kind or nature related to, arising
-- under or in connection with these materials, including for any direct, or any
-- indirect, special, incidental, or consequential loss or damage (including loss
-- of data, profits, goodwill, or any type of loss or damage suffered as a result
-- of any action brought by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-safe, or for use in any
-- application requiring fail-safe performance, such as life-support or safety
-- devices or systems, Class III medical devices, nuclear facilities, applications
-- related to the deployment of airbags, or any other applications that could lead
-- to death, personal injury, or severe property or environmental damage
-- (individually and collectively, "Critical Applications"). Customer assumes the
-- sole risk and liability of any use of Xilinx products in Critical Applications,
-- subject only to applicable laws and regulations governing limitations on product
-- liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------------------
--
-- Program defined by '{psmname}.psm'.
--
-- Generated by KCPSM6 Assembler: {timestamp}. 
--
-- Assembler used ROM_form template: ROM_form_7S_1K5_with_ecc_5Dec13.vhd
--
--
-- Production definition of a 1.5K program (address range 000 to 5FF) for KCPSM6 in a 
-- 7-Series device using a RAMB36E1 primitive with built-in Error Correcting Code (ECC)
-- and 4.5 Slices.
--
--    NOTE - Compared with any of the normal program memory definitions for KCPSM6 this 
--           module has additional outputs associated with the error detection and
--           correction feature. Only use this module if there is a clear requirement to 
--           perform error detection and correction and do consider all the factors 
--           described below before incorporating it in a design. 
-- 
--           The built-in ECC feature can only be used when the RAMB36E1 primitive is 
--           configured to be 64 data bits wide plus 8 'parity' (ECC) bits. At this aspect 
--           ratio the memory has 512 locations. In this KCPSM6 program memory, three 
--           18-bit instructions are packed into each 64-bit word resulting in the somewhat
--           unusual program size of 1.5K instructions. So please be very aware that the 
--           address range is (000 to 5FF) as that is not a power of two!
-- 
--           When the built-in ECC feature is used, the clock to output time of the 
--           RAMB36E1 is also increased. Furthermore, a multiplexer is then required to 
--           select the required instruction from the three presented in each 64-bit word
--           which also increases the time taken for the instruction to reach KCPSM6. Hence
--           the maximum clock frequency that can be achieved when using this ECC protected
--           memory will be less than when using any of the standard memories. If highest 
--           performance is critical to your application then...
--              i) Reconsider if error correction is really required.
--             ii) Consider using the program memory with CRC error detection only.
--            iii) The 'sleep' mode could be used to run KCPSM6 at a lower rate whilst 
--                 remaining synchronous the higher clock rate (see 'Slow down waveforms' on 
--                 page 39 of the 'KCPSM6_User_Guide'). One or more additional clock cycles
--                 would then be available to read the ECC protected memory. Hint: You will 
--                 need to permanently enable the memory (i.e. tie 'enable' High) and 
--                 define a multi-cycle timing constraint to cover the path from the 
--                 program memory to KCPSM6. Adding a pipeline stage in the instruction 
--                 path would also be possible when using the slow down technique.
--
-- Error Detection and Correction Features
-- ---------------------------------------
--
-- In this application the BRAM is being used as a ROM and therefore the contents should 
-- not change during normal operation. If for any reason the contents of the memory should
-- change then there is the potential for KCPSM6 to execute an instruction that is either 
-- different to that expected or even an invalid op-code neither of which would be
-- desirable. Obviously this should not happen and in majority of cases it will be more 
-- than acceptable to assume that it never will. However, designs in which extreme levels
-- of reliability are required may consider that the special error detection and correction
-- features provided in this memory definition are useful.
--
-- This memory uses the built-in Error Correcting Code (ECC) feature of the RAMB36E1 
-- primitive. This requires that the memory is configured to be 512 locations each 
-- containing a 64-bit data word and an 8-bit ECC. 'address[8:0]' from KCPM6 is supplied 
-- directly to the RAMB36E1 primitive and reads a 64-bit word containing three 18-bit 
-- instructions (i.e. 54-bits are actually used). A single bit error anywhere in the 
-- 64-bit word or the 8-bit ECC value will be detected and corrected by the built-in 
-- logic. 'address[10:9]' from KCPM6 is then used (via a pipeline compensation register) 
-- to select the required instruction from the three presented.
--
-- The arrangement means that the three instructions packed into each memory location 
-- are from different 'blocks' of the program address range.  
--         
--      BRAM Data Bits        Instruction from       address         address [8:0]   
--                          KCPSM6 Address Range      [11:9]
--         
--         [57:40]              400 to 5FF             010       000000000 - 111111111 
--         [37:20]              200 to 3FF             001       000000000 - 111111111
--          [17:0]              000 to 1FF             000       000000000 - 111111111
--
-- The ECC scheme can correct any single bit errors which, although rare, are the most 
-- likely to occur. In the unlikely event that a double bit error should occur (in the 
-- same 64+8 bits) then the ECC scheme will report its detection even though it can not 
-- correct. The 'SBITERR' and 'DBITERR' status signals from the built-in ECC decoder and 
-- correction logic are presented as outputs of this memory. In most cases 'SBITERR' can
-- be ignored but it is always interesting to log events (e.g. how often did KCPSM6 
-- benefit from using this feature?). 'DBITERR' could mean that KCPSM6 has be presented 
-- with a corrupted instruction so it would probably be time to perform some further 
-- checks and/or mitigation at the system level.
--
-- Note - If a double bit error is detected and reported then there is a 75% probability 
--        that is did not corrupt the instruction that KCPSM6 actually used (i.e. the 
--        instruction used is only 18-bits out of the 72-bits read from the memory). At 
--        the time that this particular KCPSM6 program memory was developed there were 
--        ideas to implement an enhanced scheme capable of refining the error reporting 
--        to only the instruction being selected. Please check to see if this scheme is 
--        now available for your consideration.
--
--
-- SEU Mitigation
-- --------------
--
-- One concern for the very highest reliability systems are Single Event Upsets (SEU) 
-- caused by radiation. FIT rates for BRAM are published and updated quarterly in UG116
-- and these should be used to evaluate the potential failure rates prior to using this 
-- memory with its error detection and correction features.
--
-- UG116 (v9.6) published 19th November 2013 shows that the real time soft error rate for 
-- Block RAM memory in a 7-Series device is 78 FIT/Mb. Based on this figure (you should 
-- always use the latest version of UG116 in your own calculations), the nominal upset 
-- rate for contents of this one RAMB36E1 (36kbits) is 1.44 FIT. That's equivalent to one
-- upset inside this memory every 79,274 years when operating at sea-level New York. Even
-- when flying at an altitude of 40,000ft anywhere around the world the upset rate would 
-- be 158 years (and aircraft don't fly for that long!). 
--
-- The analysis shows that it is most unlikely that multiple events would lead to the 
-- accumulation of bit errors within the same KCPSM6 program memory. Even if two events 
-- did lead to two upsets it is statistically unlikely (1 in 512) that they would both
-- occur in the same 64+8 bit location and hence the ECC scheme would be able to detect 
-- and correct the single bit errors contained in any of the instructions as they were 
-- being read.
--
-- Note - When an error is detected, it is only the word read from the memory is corrected.
--        The contents of the memory remain the same so any error will be detected and 
--        corrected every time the same location is accessed. Hence the 'SBITERR' would be 
--        seen to pulse High every time KCPSM6 accessed the memory location containing the 
--        error. Hence, multiple 'SBITERR' pulses do NOT mean there are multiple errors. 
--        It would be possible to implement a memory write-back or 'scrubbing' mechanism 
--        but with such a low probability of multiple events leading to the accumulation 
--        of errors such a scheme was considered to be unnecessary.
--
--
-- Mitigation of incorrect program execution using 'DEFAULT_JUMP' Directive 
-- ------------------------------------------------------------------------
--
-- Even with an ECC protected program memory there is the possibility of an SEU impacting 
-- the operation of KCPSM6 (i.e. an SEU flips a configuration cell that impacts either the 
-- logic or interconnect associated with KCPSM6). There is also the potential for a PSM
-- program to be incorrect in some way (i.e. we all make mistakes!). As such, it is 
-- possible that KCPSM6 could at some time attempt to fetch an instruction from an address 
-- outside of the available memory range 000 to 5FF hex. 
--
-- This memory will detect any address in the range 600 to FFF hex and force the 18-bit 
-- instruction to be a predictable fixed value. The KCPSM6 Assembler supports a directive 
-- called 'DEFAULT_JUMP' which is described in 'all_kcpsm6_syntax.psm'. This directive 
-- is normally used to fill all otherwise unused locations in a memory with a 'JUMP' 
-- instruction to a address defined by the user. The user would typically define a special
-- routine at this location to handle the otherwise unexpected case. When 'DEFAULT_JUMP'
-- is used with this memory it will fill all otherwise unused locations in the usual way 
-- but it will also define the output instruction in the address range 600 to FFF hex.
--
-- Hint - In the interest of achieving maximum reliability it is recommended that the 
--        'DEFAULT_JUMP' directive be used. If it is not used then this memory will still 
--        detect any address in the range 600 to FFF hex and force the output instruction 
--        to '00000' equivalent to 'LOAD s0, s0' which is a 'no-operation' (which is also 
--        the default for any unused locations in any program memory).
--
--
-- TESTING METHODS
-- ---------------
--
-- The error correction capability can be tested by deliberately corrupting any bit stored
-- in the memory by manually adjusting one of the INIT values before processing the design.
-- Then observe the SBITERR and DBITERR outputs when KCPSM6 fetches the corrupted word from
-- the memory.  
--
--    Hints - Each hexadecimal digit in an INIT string represents 4 adjacent bits in the
--            same 64-bit word (or 8-bit ECC) read from the memory so only adjust a digit 
--            in a way that would create a single bit error or an adjacent double bit error
--            (e.g. 'E' hex = 1110 binary so 'A' hex would be the single bit error 1010 but 
--            '0' hex would be a 3-bit error 0000 and an unrealistic test case). 
--
--            SBITERR or DBITERR will pulse when KCPSM6 reads a word from memory containing  
--            an error. Each word is associated with three addresses in different 'blocks' 
--            (see above). So consider where you locate the error and how your PSM program
--            will execute because each error relates to three addresses.
--         
--            Single bit errors are corrected so KCPSM6 execution should always continue 
--            to be correct when SBITERR pulses are observed. If a double bit error is 
--            created and DBITERR pulse is observed then the instruction fetched could be 
--            corrupted depending on where you created the error.  
--
--            Each 64-bit word contains three 18-bit instructions and ten otherwise unused
--            bits (bits 18, 19, 38, 39, 58, 59, 60, 61, 62, 62 and 63). Errors created in 
--            these unused bits will still result in SBITERR or DBITERR pulses but we 
--            would know that all three instructions remain valid. Hence these are good 
--            places to create double bit errors for test purposes.
--
--            With due care and attention paid to the fact that each 64-bit word contains 
--            three instructions from different blocks, your PSM code could contain a test 
--            routine located at a particular address range corresponding with the location
--            of the deliberate errors created in the INIT strings. In this way SBITERR and
--            DBITERR could be made to pulse when required for test purposes but normal 
--            operation would never execute any of the instructions contained in the 
--            corrupted word(s).
--
-- 
-------------------------------------------------------------------------------------------
--
--
-- Standard IEEE libraries
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--  
library unisim;
use unisim.vcomponents.all;
--
--
entity {name} is
    Port (     address : in std_logic_vector(11 downto 0);
           instruction : out std_logic_vector(17 downto 0);
                enable : in std_logic;
               SBITERR : out std_logic;
               DBITERR : out std_logic;
                   clk : in std_logic);
    end {name};
--
architecture low_level_definition of {name} is
--
signal    address_a : std_logic_vector(15 downto 0);
signal    address_b : std_logic_vector(15 downto 0);
signal      data_in : std_logic_vector(63 downto 0);
signal     data_out : std_logic_vector(63 downto 0);
signal    data_in_p : std_logic_vector(7 downto 0);
--
signal pipe_address : std_logic_vector(11 downto 9);
--
--
constant default_jump  : std_logic_vector(17 downto 0) := "{default_jump}";
--
--
begin
--
  address_a <= '1' & address(8 downto 0) & "111111";
  address_b <= "1111111111111111";
  data_in <= data_out(63 downto 58) & "000000000000000000" & data_out(39 downto 38) & "000000000000000000" & data_out(19 downto 18)& "000000000000000000";
  data_in_p <= "00000000";
  --          
  kcpsm6_rom: RAMB36E1
  generic map ( READ_WIDTH_A => 72,
                WRITE_WIDTH_A => 0,
                DOA_REG => 0,
                INIT_A => X"000000000",
                RSTREG_PRIORITY_A => "REGCE",
                SRVAL_A => X"000000000",
                WRITE_MODE_A => "WRITE_FIRST",
                READ_WIDTH_B => 0,
                WRITE_WIDTH_B => 72,
                DOB_REG => 0,
                INIT_B => X"000000000",
                RSTREG_PRIORITY_B => "REGCE",
                SRVAL_B => X"000000000",
                WRITE_MODE_B => "WRITE_FIRST",
                INIT_FILE => "NONE",
                SIM_COLLISION_CHECK => "ALL",
                RAM_MODE => "SDP",
                RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                EN_ECC_READ => TRUE,
                EN_ECC_WRITE => FALSE,
                RAM_EXTENSION_A => "NONE",
                RAM_EXTENSION_B => "NONE",
                SIM_DEVICE => "7SERIES",
                INIT_00 => X"{ECC_7S_1K5_INIT_00}",
                INIT_01 => X"{ECC_7S_1K5_INIT_01}",
                INIT_02 => X"{ECC_7S_1K5_INIT_02}",
                INIT_03 => X"{ECC_7S_1K5_INIT_03}",
                INIT_04 => X"{ECC_7S_1K5_INIT_04}",
                INIT_05 => X"{ECC_7S_1K5_INIT_05}",
                INIT_06 => X"{ECC_7S_1K5_INIT_06}",
                INIT_07 => X"{ECC_7S_1K5_INIT_07}",
                INIT_08 => X"{ECC_7S_1K5_INIT_08}",
                INIT_09 => X"{ECC_7S_1K5_INIT_09}",
                INIT_0A => X"{ECC_7S_1K5_INIT_0A}",
                INIT_0B => X"{ECC_7S_1K5_INIT_0B}",
                INIT_0C => X"{ECC_7S_1K5_INIT_0C}",
                INIT_0D => X"{ECC_7S_1K5_INIT_0D}",
                INIT_0E => X"{ECC_7S_1K5_INIT_0E}",
                INIT_0F => X"{ECC_7S_1K5_INIT_0F}",
                INIT_10 => X"{ECC_7S_1K5_INIT_10}",
                INIT_11 => X"{ECC_7S_1K5_INIT_11}",
                INIT_12 => X"{ECC_7S_1K5_INIT_12}",
                INIT_13 => X"{ECC_7S_1K5_INIT_13}",
                INIT_14 => X"{ECC_7S_1K5_INIT_14}",
                INIT_15 => X"{ECC_7S_1K5_INIT_15}",
                INIT_16 => X"{ECC_7S_1K5_INIT_16}",
                INIT_17 => X"{ECC_7S_1K5_INIT_17}",
                INIT_18 => X"{ECC_7S_1K5_INIT_18}",
                INIT_19 => X"{ECC_7S_1K5_INIT_19}",
                INIT_1A => X"{ECC_7S_1K5_INIT_1A}",
                INIT_1B => X"{ECC_7S_1K5_INIT_1B}",
                INIT_1C => X"{ECC_7S_1K5_INIT_1C}",
                INIT_1D => X"{ECC_7S_1K5_INIT_1D}",
                INIT_1E => X"{ECC_7S_1K5_INIT_1E}",
                INIT_1F => X"{ECC_7S_1K5_INIT_1F}",
                INIT_20 => X"{ECC_7S_1K5_INIT_20}",
                INIT_21 => X"{ECC_7S_1K5_INIT_21}",
                INIT_22 => X"{ECC_7S_1K5_INIT_22}",
                INIT_23 => X"{ECC_7S_1K5_INIT_23}",
                INIT_24 => X"{ECC_7S_1K5_INIT_24}",
                INIT_25 => X"{ECC_7S_1K5_INIT_25}",
                INIT_26 => X"{ECC_7S_1K5_INIT_26}",
                INIT_27 => X"{ECC_7S_1K5_INIT_27}",
                INIT_28 => X"{ECC_7S_1K5_INIT_28}",
                INIT_29 => X"{ECC_7S_1K5_INIT_29}",
                INIT_2A => X"{ECC_7S_1K5_INIT_2A}",
                INIT_2B => X"{ECC_7S_1K5_INIT_2B}",
                INIT_2C => X"{ECC_7S_1K5_INIT_2C}",
                INIT_2D => X"{ECC_7S_1K5_INIT_2D}",
                INIT_2E => X"{ECC_7S_1K5_INIT_2E}",
                INIT_2F => X"{ECC_7S_1K5_INIT_2F}",
                INIT_30 => X"{ECC_7S_1K5_INIT_30}",
                INIT_31 => X"{ECC_7S_1K5_INIT_31}",
                INIT_32 => X"{ECC_7S_1K5_INIT_32}",
                INIT_33 => X"{ECC_7S_1K5_INIT_33}",
                INIT_34 => X"{ECC_7S_1K5_INIT_34}",
                INIT_35 => X"{ECC_7S_1K5_INIT_35}",
                INIT_36 => X"{ECC_7S_1K5_INIT_36}",
                INIT_37 => X"{ECC_7S_1K5_INIT_37}",
                INIT_38 => X"{ECC_7S_1K5_INIT_38}",
                INIT_39 => X"{ECC_7S_1K5_INIT_39}",
                INIT_3A => X"{ECC_7S_1K5_INIT_3A}",
                INIT_3B => X"{ECC_7S_1K5_INIT_3B}",
                INIT_3C => X"{ECC_7S_1K5_INIT_3C}",
                INIT_3D => X"{ECC_7S_1K5_INIT_3D}",
                INIT_3E => X"{ECC_7S_1K5_INIT_3E}",
                INIT_3F => X"{ECC_7S_1K5_INIT_3F}",
                INIT_40 => X"{ECC_7S_1K5_INIT_40}",
                INIT_41 => X"{ECC_7S_1K5_INIT_41}",
                INIT_42 => X"{ECC_7S_1K5_INIT_42}",
                INIT_43 => X"{ECC_7S_1K5_INIT_43}",
                INIT_44 => X"{ECC_7S_1K5_INIT_44}",
                INIT_45 => X"{ECC_7S_1K5_INIT_45}",
                INIT_46 => X"{ECC_7S_1K5_INIT_46}",
                INIT_47 => X"{ECC_7S_1K5_INIT_47}",
                INIT_48 => X"{ECC_7S_1K5_INIT_48}",
                INIT_49 => X"{ECC_7S_1K5_INIT_49}",
                INIT_4A => X"{ECC_7S_1K5_INIT_4A}",
                INIT_4B => X"{ECC_7S_1K5_INIT_4B}",
                INIT_4C => X"{ECC_7S_1K5_INIT_4C}",
                INIT_4D => X"{ECC_7S_1K5_INIT_4D}",
                INIT_4E => X"{ECC_7S_1K5_INIT_4E}",
                INIT_4F => X"{ECC_7S_1K5_INIT_4F}",
                INIT_50 => X"{ECC_7S_1K5_INIT_50}",
                INIT_51 => X"{ECC_7S_1K5_INIT_51}",
                INIT_52 => X"{ECC_7S_1K5_INIT_52}",
                INIT_53 => X"{ECC_7S_1K5_INIT_53}",
                INIT_54 => X"{ECC_7S_1K5_INIT_54}",
                INIT_55 => X"{ECC_7S_1K5_INIT_55}",
                INIT_56 => X"{ECC_7S_1K5_INIT_56}",
                INIT_57 => X"{ECC_7S_1K5_INIT_57}",
                INIT_58 => X"{ECC_7S_1K5_INIT_58}",
                INIT_59 => X"{ECC_7S_1K5_INIT_59}",
                INIT_5A => X"{ECC_7S_1K5_INIT_5A}",
                INIT_5B => X"{ECC_7S_1K5_INIT_5B}",
                INIT_5C => X"{ECC_7S_1K5_INIT_5C}",
                INIT_5D => X"{ECC_7S_1K5_INIT_5D}",
                INIT_5E => X"{ECC_7S_1K5_INIT_5E}",
                INIT_5F => X"{ECC_7S_1K5_INIT_5F}",
                INIT_60 => X"{ECC_7S_1K5_INIT_60}",
                INIT_61 => X"{ECC_7S_1K5_INIT_61}",
                INIT_62 => X"{ECC_7S_1K5_INIT_62}",
                INIT_63 => X"{ECC_7S_1K5_INIT_63}",
                INIT_64 => X"{ECC_7S_1K5_INIT_64}",
                INIT_65 => X"{ECC_7S_1K5_INIT_65}",
                INIT_66 => X"{ECC_7S_1K5_INIT_66}",
                INIT_67 => X"{ECC_7S_1K5_INIT_67}",
                INIT_68 => X"{ECC_7S_1K5_INIT_68}",
                INIT_69 => X"{ECC_7S_1K5_INIT_69}",
                INIT_6A => X"{ECC_7S_1K5_INIT_6A}",
                INIT_6B => X"{ECC_7S_1K5_INIT_6B}",
                INIT_6C => X"{ECC_7S_1K5_INIT_6C}",
                INIT_6D => X"{ECC_7S_1K5_INIT_6D}",
                INIT_6E => X"{ECC_7S_1K5_INIT_6E}",
                INIT_6F => X"{ECC_7S_1K5_INIT_6F}",
                INIT_70 => X"{ECC_7S_1K5_INIT_70}",
                INIT_71 => X"{ECC_7S_1K5_INIT_71}",
                INIT_72 => X"{ECC_7S_1K5_INIT_72}",
                INIT_73 => X"{ECC_7S_1K5_INIT_73}",
                INIT_74 => X"{ECC_7S_1K5_INIT_74}",
                INIT_75 => X"{ECC_7S_1K5_INIT_75}",
                INIT_76 => X"{ECC_7S_1K5_INIT_76}",
                INIT_77 => X"{ECC_7S_1K5_INIT_77}",
                INIT_78 => X"{ECC_7S_1K5_INIT_78}",
                INIT_79 => X"{ECC_7S_1K5_INIT_79}",
                INIT_7A => X"{ECC_7S_1K5_INIT_7A}",
                INIT_7B => X"{ECC_7S_1K5_INIT_7B}",
                INIT_7C => X"{ECC_7S_1K5_INIT_7C}",
                INIT_7D => X"{ECC_7S_1K5_INIT_7D}",
                INIT_7E => X"{ECC_7S_1K5_INIT_7E}",
                INIT_7F => X"{ECC_7S_1K5_INIT_7F}",
               INITP_00 => X"{ECC_7S_1K5_INITP_00}",
               INITP_01 => X"{ECC_7S_1K5_INITP_01}",
               INITP_02 => X"{ECC_7S_1K5_INITP_02}",
               INITP_03 => X"{ECC_7S_1K5_INITP_03}",
               INITP_04 => X"{ECC_7S_1K5_INITP_04}",
               INITP_05 => X"{ECC_7S_1K5_INITP_05}",
               INITP_06 => X"{ECC_7S_1K5_INITP_06}",
               INITP_07 => X"{ECC_7S_1K5_INITP_07}",
               INITP_08 => X"{ECC_7S_1K5_INITP_08}",
               INITP_09 => X"{ECC_7S_1K5_INITP_09}",
               INITP_0A => X"{ECC_7S_1K5_INITP_0A}",
               INITP_0B => X"{ECC_7S_1K5_INITP_0B}",
               INITP_0C => X"{ECC_7S_1K5_INITP_0C}",
               INITP_0D => X"{ECC_7S_1K5_INITP_0D}",
               INITP_0E => X"{ECC_7S_1K5_INITP_0E}",
               INITP_0F => X"{ECC_7S_1K5_INITP_0F}")
  port map(   ADDRARDADDR => address_a,
                  ENARDEN => enable,
                CLKARDCLK => clk,
                    DOADO => data_out(31 downto 0),
                    DIADI => data_in(31 downto 0),
                  DIPADIP => data_in_p(3 downto 0), 
                      WEA => "0000",
              REGCEAREGCE => '0',
            RSTRAMARSTRAM => '0',
            RSTREGARSTREG => '0',
              ADDRBWRADDR => address_b,
                  ENBWREN => '0',
                CLKBWRCLK => '0',
                    DOBDO => data_out(63 downto 32),
                    DIBDI => data_in(63 downto 32),
                  DIPBDIP => data_in_p(7 downto 4), 
                    WEBWE => "00000000",
                   REGCEB => '0',
                  RSTRAMB => '0',
                  RSTREGB => '0',
               CASCADEINA => '0',
               CASCADEINB => '0',
                  SBITERR => SBITERR,
                  DBITERR => DBITERR,
            INJECTDBITERR => '0',
            INJECTSBITERR => '0');
  --
  pipe_address_loop: for i in 9 to 11 generate
  begin
    --
    kcpsm6_rom_flop: FDE
    port map (   D => address(i),
                 Q => pipe_address(i),
                CE => enable,
                 C => clk);
    --
  end generate pipe_address_loop;
  --
  instruction_width_loop: for i in 0 to 17 generate
  begin
    --
    force_low: if default_jump(i)='0' generate
    begin
      --
      kcpsm6_rom_lut: LUT6
      generic map (INIT => X"0000000000F0CCAA")
      port map( I0 => data_out(i),
                I1 => data_out(i+20),
                I2 => data_out(i+40),
                I3 => pipe_address(9),
                I4 => pipe_address(10),
                I5 => pipe_address(11),
                 O => instruction(i));
      --
    end generate force_low;
    --
    force_high: if default_jump(i)='1' generate
    begin
      --
      kcpsm6_rom_lut: LUT6
      generic map (INIT => X"FFFFFFFFFFF0CCAA")
      port map( I0 => data_out(i),
                I1 => data_out(i+20),
                I2 => data_out(i+40),
                I3 => pipe_address(9),
                I4 => pipe_address(10),
                I5 => pipe_address(11),
                 O => instruction(i));
      --
    end generate force_high;
    --
  end generate instruction_width_loop;
--
end low_level_definition;
--
------------------------------------------------------------------------------------
--
-- END OF FILE {name}.vhd
--
------------------------------------------------------------------------------------
