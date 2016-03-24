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

Production template for a 2K program for KCPSM6 in a 7-Series device using a 
RAMB36E1 primitive with a content verifying CRC-16 circuit.

PLEASE READ THE DESCRIPTIONS AND ADVICE  LATER IN THIS TEMPLATE OR CONTAINED IN THE 
ASSEMBLED FILE. 


Ken Chapman (Xilinx Ltd)

 9th August 2012 - Initial Release
8th October 2012 - Optimised implementation.
 14th March 2013 - Unused address inputs on BRAMs connected High to reflect 
                   descriptions UG473.




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
--
-- Production definition of a 2K program for KCPSM6 in a 7-Series device using a 
-- RAMB36E1 primitive with a content verifying CRC-16 error detection circuit.
--
--    NOTE - Compared with any of the normal program memory definitions for KCPSM6 this 
--           module has additional inputs and outputs associated with the error detection
--           feature. Only use this module if there is a clear requirement to perform 
--           error detection and do consider all the factors described below when 
--           incorporating it in a design.
--
--
-- Program defined by '{psmname}.psm'.
--
-- Generated by KCPSM6 Assembler: {timestamp}. 
--
-- Assembler used ROM_form template: ROM_form_7S_2K_with_error_detection_14March13.vhd
--
--
-- Error Detection Feature
-- -----------------------
--
-- In this application the BRAM is being used as a ROM and therefore the contents should 
-- not change during normal operation. If for any reason the contents of the memory should
-- change then there is the potential for KCPSM6 to execute an instruction that is either 
-- different to that expected or even an invalid op-code neither of which would be
-- desirable. Obviously this should not happen and in majority of cases it will be more 
-- than acceptable to assume that it never will. However, designs in which extreme levels
-- of reliability or design security are required may consider that the special error 
-- detection feature provided in this memory definition is useful.
--
-- This memory definition provides KCPSM6 with access to the program in the conventional 
-- way using the first port of the BRAM. Then the second port of the BRAM is used to 
-- continuously scan the whole memory and compute the CRC-16 of the entire contents. At 
-- the end of each scan the result of each CRC calculation is compared with the expected 
-- value (which was computed by the KCPSM6 assembler). If the value does not match then 
-- the 'scan_error' output is forced High to inform the system of a potential corruption
-- somewhere within the memory.
--
--
-- SEU Mitigation
-- --------------
--
-- One concern for the very highest reliability systems are Single Event Upsets (SEU) 
-- caused by radiation. FIT rates for BRAM are published and updated quarterly in UG116
-- and these should be used to evaluate the potential failure rates prior to using this 
-- memory with its error detection circuit. It is vital to remember that everything in a 
-- system contributes to the overall reliability. As such, the thoughtless addition of 
-- features such as BRAM content error detection could in fact lower the overall 
-- reliability of the system which obviously wouldn't be the intention! Two of the factors
-- to consider are as follows:-
--
--    a) Configuration memory is also susceptible to SEU and may impact the operation of 
--       a design. Again the FIT rates are published in UG116 and the failure rates need 
--       to be estimated. PicoBlaze itself, the error detection circuit defined in this
--       file and whatever you monitor and control the error detection circuit with are 
--       all associated with configuration memory and therefore the potential exists for 
--       a 'false alarm'. For example, and SEU could flip a configuration memory cell that
--       altered the logic of the error detection circuit resulting in a 'scan_error' even 
--       though the BRAM contents are good. 
--       
--    b) If one bit within the BRAM is flipped by an SEU (the typical effect), it could 
--       take up to ~73,740 'scan_clk' cycles for the error to be detected and reported.
--       This worst case detection time is equivalent two complete scans of the memory
--       and would only occur if the SEU flips a bit very close to the start of the 
--       memory (address zero) just after the scan has just passed that location. Hence,
--       the average detection time will be one complete scan (36,873 'scan_clk' cycles).
--       During the time taken to detect and report the error, and any time leading up to 
--       your decision to take some suitable action, KCPSM6 may execute the instruction 
--       that has been corrupted. The impact of executing that corrupted instruction is 
--       anyone's guess! However, in terms of estimating the failure rate it is important
--       to recognise that KCPSM6 must actually read and execute the corrupted instruction
--       for anything unexpected to occur. So whilst the error detection circuit will 
--       report when an error is present in the memory it definitely does not mean that
--       KCPSM6 has or will definitely go wrong. KCPSM6 programs rarely occupy all the 
--       memory locations so the failure rate estimate should be scaled accordingly. 
--       Likewise, most programs consist of some code that is used frequently and other 
--       code which is only used occasionally (e.g. some code is only used during 
--       initialisation). So once again the failure rate can often be scaled appropriately
--       to reflect the actual code. Due to these scaling factors there is quite a high 
--       probability that a real upset will be detected and reported but for there to be 
--       no effect on the program execution. Whilst this is not a 'false alarm' is may 
--       appear to be. Detection of any error is valuable in a fail-safe system but it can 
--       adversely impact the overall availability of systems if every alarm results in 
--       an interruption to service. Therefore, deciding what action to take when an error
--       is detected is critical before opting to us this memory module with KCPSM6.
--
--
-- Design Security
-- ---------------
--
-- Devices of the 7-Series which this memory definition is intended to service provide 
-- Bitstream Security in the form of AES encryption so obviously this should be of 
-- high relevance for anyone concerned with design security. However, there may be 
-- reasons not to use that feature or a desire to further enhance security in other ways. 
-- Whilst it would be a significant challenge to reverse engineer a bitstream (assuming it
-- wasn't encrypted or was somehow decrypted), it is feasible to alter or tamper with the
-- bits in what is often referred to as 'side attacks'. 
--
-- On a scale of difficulty it should be recognised that BRAM contents are one of the 
-- easier targets for such attacks. Note that the DATA2MEM tool (see UG658) intended to 
-- help accelerate design development would also be a useful tool for an attacker! 
-- Obviously the ability to tamper with BRAM contents means that the program for a KCPSM6
-- processor could be altered or replaced. Depending on the purpose of that code it could
-- definitely compromise security.
--
-- Since the error detection circuit will report any changes to the memory contents this 
-- scheme can also be used to detect attacks and somehow disable the design to prevent the 
-- attacker making progress. For example, the 'scan_error' signal could be used to 
-- permanently reset KCPSM6 or be used to disable something else in the design such as 
-- putting critical output pins of the device into a high impedance state.
--
--
-- Using the Error Detection Feature in a Design
-- ---------------------------------------------
--
-- Whether this feature is used for SEU mitigation or design security it is highly 
-- recommended that signals and logic associated with the error detection feature remain 
-- isolated from the KCPSM6 processor; i.e. it certainly wouldn't be a good idea to  
-- monitor the error signal with the same KCPSM6 given that any change to the 
-- program may prevent KCPSM6 from reacting as intended in the first place. However, 
-- it would be a valid arrangement for two or more KCPSM6 processors to monitor the 
-- health of each other's memory providing they too had a reasonable degree of 
-- independence(e.g. avoiding a common point such as using the same clock).
--
-- As with most digital circuits the clock is critical for reliable operation. In terms 
-- failure rates then SEU are so rare that things like an irregular clock cycle or glitch
-- possibly caused by power surge could be as likely to impact the integrity of the 
-- CRC-16 calculation and result in a false alarm. So always give consideration to the 
-- source of your clock including any use of clock division or multiplication schemes 
-- implemented within the FPGA before it is applied to the 'scan_clk' input of this module.
--
-- In most applications the 'scan_reset' control can be driven or tied Low. The report of
-- any error would be a rare event but would generally be considered a permanent error 
-- until the device is reconfigured. However, there is the small possibility that an SEU
-- or clock glitch could impact the logical operation of the error detection circuit
-- resulting in a 'false alarm'. In these situations, the device level SEU mitigation
-- measures would detect and subsequently correct the configuration memory error or the 
-- clock source would recover. Applying a synchronous pulse to 'scan_reset' would then 
-- clear the false alarm and allow the memory checking to continue. Ultimately, design 
-- for reliability must consider the interaction between all elements of the system and 
-- can not simply focus on one issue like the BRAM contents.
--
-- In situations where the clock may take time to settle following device configuration 
-- the error detection circuit should be held in reset until the integrity of the clock 
-- can be assured.
--
-- Note that the 'scan_error' signal has be deliberately designed to 'latch' any error 
-- that is detected (i.e. false alarms are not cleared automatically by a subsequent good  
-- scan of the memory). This scheme ensures that no error reports can be missed by a
-- monitor which only checks occasionally. It is always the responsibility of the system 
-- to decide what action to take when an error is reported. Some systems may initially 
-- reset the error detection circuit in order to confirm the error is permanent before 
-- taking more significant actions.
--
-- The 'scan_complete' signal is a single clock cycle pulse generated at the end of each 
-- CRC-16 calculation. This signal could be ignored but for both reliability and security 
-- purposes it is extremely useful to know that the error detection circuit is actually 
-- working and these pulses will confirm that it is (one pulse every 36,873 'scan_clk' 
-- cycles). For example, these pulses confirm that the clock is being supplied and has not
-- been disabled by an SEU, oscillator failure, board defect or a malicious attacker.
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
    Port (       address : in std_logic_vector(11 downto 0);
             instruction : out std_logic_vector(17 downto 0);
                  enable : in std_logic;
                     clk : in std_logic;
              scan_error : out std_logic;
           scan_complete : out std_logic;
              scan_reset : in std_logic;
                scan_clk : in std_logic);
    end {name};
--
architecture low_level_definition of {name} is
--
signal             address_a : std_logic_vector(15 downto 0);
signal             data_in_a : std_logic_vector(35 downto 0);
signal            data_out_a : std_logic_vector(35 downto 0);
signal             address_b : std_logic_vector(15 downto 0);
signal             data_in_b : std_logic_vector(35 downto 0);
signal            data_out_b : std_logic_vector(35 downto 0);
--
signal previous_scan_address : std_logic_vector(11 downto 0);
signal       sa_carry_primer : std_logic_vector(11 downto 0);
signal    scan_address_carry : std_logic_vector(11 downto 0);
signal    scan_address_value : std_logic_vector(11 downto 0);
signal          scan_address : std_logic_vector(11 downto 0);
signal scan_address_ce_value : std_logic;
signal       scan_address_ce : std_logic;
signal             scan_data : std_logic_vector(8 downto 0);
signal        scan_bit_value : std_logic_vector(3 downto 0);
signal              scan_bit : std_logic_vector(3 downto 0);
signal              scan_mid : std_logic;
signal             scan_high : std_logic;
signal             scan_byte : std_logic;
signal       crc_reset_value : std_logic;
signal             crc_reset : std_logic;
signal                   crc : std_logic_vector(16 downto 1);
signal            crc1_value : std_logic;
signal            crc2_value : std_logic;
signal            crc3_value : std_logic;
signal           crc16_value : std_logic;
signal     serial_data_value : std_logic;
signal           serial_data : std_logic;
signal    last_address_value : std_logic;
signal          last_address : std_logic;
signal              last_bit : std_logic;
signal           end_of_scan : std_logic;
signal              crc_test : std_logic;
signal       crc_check_value : std_logic;
signal             crc_check : std_logic;
--
attribute hblknm : string;
attribute hblknm of           crc16_flop : label is "kcpsm6_program_crc1"; 
attribute hblknm of            crc1_flop : label is "kcpsm6_program_crc1";
attribute hblknm of            crc2_flop : label is "kcpsm6_program_crc1";
attribute hblknm of            crc3_flop : label is "kcpsm6_program_crc1";
attribute hblknm of            crc4_flop : label is "kcpsm6_program_crc1";
attribute hblknm of            crc5_flop : label is "kcpsm6_program_crc1";
attribute hblknm of            crc6_flop : label is "kcpsm6_program_crc1";
attribute hblknm of            crc7_flop : label is "kcpsm6_program_crc1";
attribute hblknm of             crc1_lut : label is "kcpsm6_program_crc1";
attribute hblknm of             crc3_lut : label is "kcpsm6_program_crc1";
--
attribute hblknm of            crc8_flop : label is "kcpsm6_program_crc2";
attribute hblknm of            crc9_flop : label is "kcpsm6_program_crc2";
attribute hblknm of           crc10_flop : label is "kcpsm6_program_crc2";
attribute hblknm of           crc11_flop : label is "kcpsm6_program_crc2";
attribute hblknm of           crc12_flop : label is "kcpsm6_program_crc2";
attribute hblknm of           crc13_flop : label is "kcpsm6_program_crc2";
attribute hblknm of           crc14_flop : label is "kcpsm6_program_crc2";
attribute hblknm of           crc15_flop : label is "kcpsm6_program_crc2";
--
attribute hblknm of       scan_bit0_flop : label is "kcpsm6_program_crc3";
attribute hblknm of       scan_bit1_flop : label is "kcpsm6_program_crc3";
attribute hblknm of       scan_bit2_flop : label is "kcpsm6_program_crc3";
attribute hblknm of       scan_bit3_flop : label is "kcpsm6_program_crc3";
attribute hblknm of       crc_reset_flop : label is "kcpsm6_program_crc3";
attribute hblknm of scan_address_ce_flop : label is "kcpsm6_program_crc3";
attribute hblknm of       crc_check_flop : label is "kcpsm6_program_crc3";
attribute hblknm of    last_address_flop : label is "kcpsm6_program_crc3";
attribute hblknm of       scan_bit01_lut : label is "kcpsm6_program_crc3";
attribute hblknm of       scan_bit23_lut : label is "kcpsm6_program_crc3";
attribute hblknm of        crc_reset_lut : label is "kcpsm6_program_crc3";
attribute hblknm of        crc_check_lut : label is "kcpsm6_program_crc3";
--
attribute hblknm of     serial_data_flop : label is "kcpsm6_program_crc4";
attribute hblknm of        last_bit_flop : label is "kcpsm6_program_crc4";
attribute hblknm of     end_of_scan_flop : label is "kcpsm6_program_crc4";
attribute hblknm of   scan_complete_flop : label is "kcpsm6_program_crc4";
attribute hblknm of      serial_data_lut : label is "kcpsm6_program_crc4";
attribute hblknm of         scan_mid_lut : label is "kcpsm6_program_crc4";
attribute hblknm of        scan_high_lut : label is "kcpsm6_program_crc4";
attribute hblknm of      scan_byte_muxf7 : label is "kcpsm6_program_crc4";
--
attribute hblknm of   scan_address0_flop : label is "kcpsm6_program_crc5";
attribute hblknm of    scan_address0_lut : label is "kcpsm6_program_crc5";
attribute hblknm of  scan_address0_xorcy : label is "kcpsm6_program_crc5";
attribute hblknm of  scan_address0_muxcy : label is "kcpsm6_program_crc5";
attribute hblknm of   scan_address1_flop : label is "kcpsm6_program_crc5";
attribute hblknm of    scan_address1_lut : label is "kcpsm6_program_crc5";
attribute hblknm of  scan_address1_xorcy : label is "kcpsm6_program_crc5";
attribute hblknm of  scan_address1_muxcy : label is "kcpsm6_program_crc5";
attribute hblknm of   scan_address2_flop : label is "kcpsm6_program_crc5";
attribute hblknm of    scan_address2_lut : label is "kcpsm6_program_crc5";
attribute hblknm of  scan_address2_xorcy : label is "kcpsm6_program_crc5";
attribute hblknm of  scan_address2_muxcy : label is "kcpsm6_program_crc5";
attribute hblknm of   scan_address3_flop : label is "kcpsm6_program_crc5";
attribute hblknm of    scan_address3_lut : label is "kcpsm6_program_crc5";
attribute hblknm of  scan_address3_xorcy : label is "kcpsm6_program_crc5";
attribute hblknm of  scan_address3_muxcy : label is "kcpsm6_program_crc5";
--
attribute hblknm of   scan_address4_flop : label is "kcpsm6_program_crc6";
attribute hblknm of    scan_address4_lut : label is "kcpsm6_program_crc6";
attribute hblknm of  scan_address4_xorcy : label is "kcpsm6_program_crc6";
attribute hblknm of  scan_address4_muxcy : label is "kcpsm6_program_crc6";
attribute hblknm of   scan_address5_flop : label is "kcpsm6_program_crc6";
attribute hblknm of    scan_address5_lut : label is "kcpsm6_program_crc6";
attribute hblknm of  scan_address5_xorcy : label is "kcpsm6_program_crc6";
attribute hblknm of  scan_address5_muxcy : label is "kcpsm6_program_crc6";
attribute hblknm of   scan_address6_flop : label is "kcpsm6_program_crc6";
attribute hblknm of    scan_address6_lut : label is "kcpsm6_program_crc6";
attribute hblknm of  scan_address6_xorcy : label is "kcpsm6_program_crc6";
attribute hblknm of  scan_address6_muxcy : label is "kcpsm6_program_crc6";
attribute hblknm of   scan_address7_flop : label is "kcpsm6_program_crc6";
attribute hblknm of    scan_address7_lut : label is "kcpsm6_program_crc6";
attribute hblknm of  scan_address7_xorcy : label is "kcpsm6_program_crc6";
attribute hblknm of  scan_address7_muxcy : label is "kcpsm6_program_crc6";
--
attribute hblknm of   scan_address8_flop : label is "kcpsm6_program_crc7";
attribute hblknm of    scan_address8_lut : label is "kcpsm6_program_crc7";
attribute hblknm of  scan_address8_xorcy : label is "kcpsm6_program_crc7";
attribute hblknm of  scan_address8_muxcy : label is "kcpsm6_program_crc7";
attribute hblknm of   scan_address9_flop : label is "kcpsm6_program_crc7";
attribute hblknm of    scan_address9_lut : label is "kcpsm6_program_crc7";
attribute hblknm of  scan_address9_xorcy : label is "kcpsm6_program_crc7";
attribute hblknm of  scan_address9_muxcy : label is "kcpsm6_program_crc7";
attribute hblknm of  scan_address10_flop : label is "kcpsm6_program_crc7";
attribute hblknm of   scan_address10_lut : label is "kcpsm6_program_crc7";
attribute hblknm of scan_address10_xorcy : label is "kcpsm6_program_crc7";
attribute hblknm of scan_address10_muxcy : label is "kcpsm6_program_crc7";
attribute hblknm of  scan_address11_flop : label is "kcpsm6_program_crc7";
attribute hblknm of   scan_address11_lut : label is "kcpsm6_program_crc7";
attribute hblknm of scan_address11_xorcy : label is "kcpsm6_program_crc7";
attribute hblknm of scan_address11_muxcy : label is "kcpsm6_program_crc7";
--
begin
--
  address_a <= '1' & address(10 downto 0) & "1111";
  instruction <= data_out_a(33 downto 32) & data_out_a(15 downto 0);
  data_in_a <= "00000000000000000000000000000000000" & address(11);
  --
  address_b <= '1' & scan_address(11 downto 0) & "111";
  data_in_b <= "000000000000000000000000000000000000";
  scan_data <= data_out_b(32) & data_out_b(7 downto 0);
  --
  kcpsm6_rom: RAMB36E1
  generic map ( READ_WIDTH_A => 18,
                WRITE_WIDTH_A => 18,
                DOA_REG => 0,
                INIT_A => X"000000000",
                RSTREG_PRIORITY_A => "REGCE",
                SRVAL_A => X"000000000",
                WRITE_MODE_A => "WRITE_FIRST",
                READ_WIDTH_B => 9,
                WRITE_WIDTH_B => 9,
                DOB_REG => 0,
                INIT_B => X"000000000",
                RSTREG_PRIORITY_B => "REGCE",
                SRVAL_B => X"000000000",
                WRITE_MODE_B => "WRITE_FIRST",
                INIT_FILE => "NONE",
                SIM_COLLISION_CHECK => "ALL",
                RAM_MODE => "TDP",
                RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                EN_ECC_READ => FALSE,
                EN_ECC_WRITE => FALSE,
                RAM_EXTENSION_A => "NONE",
                RAM_EXTENSION_B => "NONE",
                SIM_DEVICE => "7SERIES",
                INIT_00 => X"{INIT_00}",
                INIT_01 => X"{INIT_01}",
                INIT_02 => X"{INIT_02}",
                INIT_03 => X"{INIT_03}",
                INIT_04 => X"{INIT_04}",
                INIT_05 => X"{INIT_05}",
                INIT_06 => X"{INIT_06}",
                INIT_07 => X"{INIT_07}",
                INIT_08 => X"{INIT_08}",
                INIT_09 => X"{INIT_09}",
                INIT_0A => X"{INIT_0A}",
                INIT_0B => X"{INIT_0B}",
                INIT_0C => X"{INIT_0C}",
                INIT_0D => X"{INIT_0D}",
                INIT_0E => X"{INIT_0E}",
                INIT_0F => X"{INIT_0F}",
                INIT_10 => X"{INIT_10}",
                INIT_11 => X"{INIT_11}",
                INIT_12 => X"{INIT_12}",
                INIT_13 => X"{INIT_13}",
                INIT_14 => X"{INIT_14}",
                INIT_15 => X"{INIT_15}",
                INIT_16 => X"{INIT_16}",
                INIT_17 => X"{INIT_17}",
                INIT_18 => X"{INIT_18}",
                INIT_19 => X"{INIT_19}",
                INIT_1A => X"{INIT_1A}",
                INIT_1B => X"{INIT_1B}",
                INIT_1C => X"{INIT_1C}",
                INIT_1D => X"{INIT_1D}",
                INIT_1E => X"{INIT_1E}",
                INIT_1F => X"{INIT_1F}",
                INIT_20 => X"{INIT_20}",
                INIT_21 => X"{INIT_21}",
                INIT_22 => X"{INIT_22}",
                INIT_23 => X"{INIT_23}",
                INIT_24 => X"{INIT_24}",
                INIT_25 => X"{INIT_25}",
                INIT_26 => X"{INIT_26}",
                INIT_27 => X"{INIT_27}",
                INIT_28 => X"{INIT_28}",
                INIT_29 => X"{INIT_29}",
                INIT_2A => X"{INIT_2A}",
                INIT_2B => X"{INIT_2B}",
                INIT_2C => X"{INIT_2C}",
                INIT_2D => X"{INIT_2D}",
                INIT_2E => X"{INIT_2E}",
                INIT_2F => X"{INIT_2F}",
                INIT_30 => X"{INIT_30}",
                INIT_31 => X"{INIT_31}",
                INIT_32 => X"{INIT_32}",
                INIT_33 => X"{INIT_33}",
                INIT_34 => X"{INIT_34}",
                INIT_35 => X"{INIT_35}",
                INIT_36 => X"{INIT_36}",
                INIT_37 => X"{INIT_37}",
                INIT_38 => X"{INIT_38}",
                INIT_39 => X"{INIT_39}",
                INIT_3A => X"{INIT_3A}",
                INIT_3B => X"{INIT_3B}",
                INIT_3C => X"{INIT_3C}",
                INIT_3D => X"{INIT_3D}",
                INIT_3E => X"{INIT_3E}",
                INIT_3F => X"{INIT_3F}",
                INIT_40 => X"{INIT_40}",
                INIT_41 => X"{INIT_41}",
                INIT_42 => X"{INIT_42}",
                INIT_43 => X"{INIT_43}",
                INIT_44 => X"{INIT_44}",
                INIT_45 => X"{INIT_45}",
                INIT_46 => X"{INIT_46}",
                INIT_47 => X"{INIT_47}",
                INIT_48 => X"{INIT_48}",
                INIT_49 => X"{INIT_49}",
                INIT_4A => X"{INIT_4A}",
                INIT_4B => X"{INIT_4B}",
                INIT_4C => X"{INIT_4C}",
                INIT_4D => X"{INIT_4D}",
                INIT_4E => X"{INIT_4E}",
                INIT_4F => X"{INIT_4F}",
                INIT_50 => X"{INIT_50}",
                INIT_51 => X"{INIT_51}",
                INIT_52 => X"{INIT_52}",
                INIT_53 => X"{INIT_53}",
                INIT_54 => X"{INIT_54}",
                INIT_55 => X"{INIT_55}",
                INIT_56 => X"{INIT_56}",
                INIT_57 => X"{INIT_57}",
                INIT_58 => X"{INIT_58}",
                INIT_59 => X"{INIT_59}",
                INIT_5A => X"{INIT_5A}",
                INIT_5B => X"{INIT_5B}",
                INIT_5C => X"{INIT_5C}",
                INIT_5D => X"{INIT_5D}",
                INIT_5E => X"{INIT_5E}",
                INIT_5F => X"{INIT_5F}",
                INIT_60 => X"{INIT_60}",
                INIT_61 => X"{INIT_61}",
                INIT_62 => X"{INIT_62}",
                INIT_63 => X"{INIT_63}",
                INIT_64 => X"{INIT_64}",
                INIT_65 => X"{INIT_65}",
                INIT_66 => X"{INIT_66}",
                INIT_67 => X"{INIT_67}",
                INIT_68 => X"{INIT_68}",
                INIT_69 => X"{INIT_69}",
                INIT_6A => X"{INIT_6A}",
                INIT_6B => X"{INIT_6B}",
                INIT_6C => X"{INIT_6C}",
                INIT_6D => X"{INIT_6D}",
                INIT_6E => X"{INIT_6E}",
                INIT_6F => X"{INIT_6F}",
                INIT_70 => X"{INIT_70}",
                INIT_71 => X"{INIT_71}",
                INIT_72 => X"{INIT_72}",
                INIT_73 => X"{INIT_73}",
                INIT_74 => X"{INIT_74}",
                INIT_75 => X"{INIT_75}",
                INIT_76 => X"{INIT_76}",
                INIT_77 => X"{INIT_77}",
                INIT_78 => X"{INIT_78}",
                INIT_79 => X"{INIT_79}",
                INIT_7A => X"{INIT_7A}",
                INIT_7B => X"{INIT_7B}",
                INIT_7C => X"{INIT_7C}",
                INIT_7D => X"{INIT_7D}",
                INIT_7E => X"{INIT_7E}",
                INIT_7F => X"{INIT_7F}",
               INITP_00 => X"{INITP_00}",
               INITP_01 => X"{INITP_01}",
               INITP_02 => X"{INITP_02}",
               INITP_03 => X"{INITP_03}",
               INITP_04 => X"{INITP_04}",
               INITP_05 => X"{INITP_05}",
               INITP_06 => X"{INITP_06}",
               INITP_07 => X"{INITP_07}",
               INITP_08 => X"{INITP_08}",
               INITP_09 => X"{INITP_09}",
               INITP_0A => X"{INITP_0A}",
               INITP_0B => X"{INITP_0B}",
               INITP_0C => X"{INITP_0C}",
               INITP_0D => X"{INITP_0D}",
               INITP_0E => X"{INITP_0E}",
               INITP_0F => X"{INITP_0F}")
  port map(   ADDRARDADDR => address_a,
                  ENARDEN => enable,
                CLKARDCLK => clk,
                    DOADO => data_out_a(31 downto 0),
                  DOPADOP => data_out_a(35 downto 32), 
                    DIADI => data_in_a(31 downto 0),
                  DIPADIP => data_in_a(35 downto 32), 
                      WEA => "0000",
              REGCEAREGCE => '0',
            RSTRAMARSTRAM => '0',
            RSTREGARSTREG => '0',
              ADDRBWRADDR => address_b,
                  ENBWREN => '1',
                CLKBWRCLK => scan_clk,
                    DOBDO => data_out_b(31 downto 0),
                  DOPBDOP => data_out_b(35 downto 32), 
                    DIBDI => data_in_b(31 downto 0),
                  DIPBDIP => data_in_b(35 downto 32), 
                    WEBWE => "00000000",
                   REGCEB => '0',
                  RSTRAMB => '0',
                  RSTREGB => '0',
               CASCADEINA => '0',
               CASCADEINB => '0',
            INJECTDBITERR => '0',
            INJECTSBITERR => '0');
  --
  -- Error Detection Circuit
  --
  scan_mid_lut: LUT6
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => scan_data(1),
            I1 => scan_data(2),
            I2 => scan_data(3),
            I3 => scan_data(4),
            I4 => scan_bit(0),
            I5 => scan_bit(1),
             O => scan_mid);                     
  --
  scan_high_lut: LUT6
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => scan_data(5),
            I1 => scan_data(6),
            I2 => scan_data(7),
            I3 => scan_data(8),
            I4 => scan_bit(0),
            I5 => scan_bit(1),
             O => scan_high);                     
  --
  scan_byte_muxf7: MUXF7
  port map( I0 => scan_mid,
            I1 => scan_high,
             S => scan_bit(2),
             O => scan_byte);
  --
  crc1_lut: LUT6_2
  generic map (INIT => X"F0F0F0F066666666")
  port map( I0 => serial_data,
            I1 => crc(16),
            I2 => crc(1),
            I3 => '1',
            I4 => '1',
            I5 => '1',
            O5 => crc1_value,
            O6 => crc2_value);  
  --
  crc3_lut: LUT6_2
  generic map (INIT => X"C33C0000A55A0000")
  port map( I0 => crc(2),
            I1 => crc(15),
            I2 => crc(16),
            I3 => serial_data,
            I4 => '1',
            I5 => '1',
            O5 => crc3_value,
            O6 => crc16_value); 
  --
  crc1_flop: FDR
  port map (  D => crc1_value,
              Q => crc(1),
              R => crc_reset,
              C => scan_clk);
  --
  crc2_flop: FDR
  port map (  D => crc2_value,
              Q => crc(2),
              R => crc_reset,
              C => scan_clk);
   --
  crc3_flop: FDR
  port map (  D => crc3_value,
              Q => crc(3),
              R => crc_reset,
              C => scan_clk);
  --
  crc4_flop: FDR
  port map (  D => crc(3),
              Q => crc(4),
              R => crc_reset,
              C => scan_clk);
  --
  crc5_flop: FDR
  port map (  D => crc(4),
              Q => crc(5),
              R => crc_reset,
              C => scan_clk);
  --
  crc6_flop: FDR
  port map (  D => crc(5),
              Q => crc(6),
              R => crc_reset,
              C => scan_clk);
  --
  crc7_flop: FDR
  port map (  D => crc(6),
              Q => crc(7),
              R => crc_reset,
              C => scan_clk);
  --
  crc8_flop: FDR
  port map (  D => crc(7),
              Q => crc(8),
              R => crc_reset,
              C => scan_clk);
  --
  crc9_flop: FDR
  port map (  D => crc(8),
              Q => crc(9),
              R => crc_reset,
              C => scan_clk);
  --
  crc10_flop: FDR
  port map (  D => crc(9),
              Q => crc(10),
              R => crc_reset,
              C => scan_clk);
  --
  crc11_flop: FDR
  port map (  D => crc(10),
              Q => crc(11),
              R => crc_reset,
              C => scan_clk);
  --
  crc12_flop: FDR
  port map (  D => crc(11),
              Q => crc(12),
              R => crc_reset,
              C => scan_clk);
  --
  crc13_flop: FDR
  port map (  D => crc(12),
              Q => crc(13),
              R => crc_reset,
              C => scan_clk);
  --
  crc14_flop: FDR
  port map (  D => crc(13),
              Q => crc(14),
              R => crc_reset,
              C => scan_clk);
  --
  crc15_flop: FDR
  port map (  D => crc(14),
              Q => crc(15),
              R => crc_reset,
              C => scan_clk);
  --
  crc16_flop: FDR
  port map (  D => crc16_value,
              Q => crc(16),
              R => crc_reset,
              C => scan_clk);
  --
  scan_bit01_lut: LUT6_2
  generic map (INIT => X"0000E6660000D555")
  port map( I0 => scan_bit(0),
            I1 => scan_bit(1),
            I2 => scan_bit(2),
            I3 => scan_bit(3),
            I4 => end_of_scan,
            I5 => '1',
            O5 => scan_bit_value(0),
            O6 => scan_bit_value(1));
  --
  scan_bit23_lut: LUT6_2
  generic map (INIT => X"00007F800000F878")
  port map( I0 => scan_bit(0),
            I1 => scan_bit(1),
            I2 => scan_bit(2),
            I3 => scan_bit(3),
            I4 => end_of_scan,
            I5 => '1',
            O5 => scan_bit_value(2),
            O6 => scan_bit_value(3));
  --
  scan_bit0_flop: FDR
  port map (  D => scan_bit_value(0),
              Q => scan_bit(0),
              R => scan_reset,
              C => scan_clk);
  --
  scan_bit1_flop: FDR
  port map (  D => scan_bit_value(1),
              Q => scan_bit(1),
              R => scan_reset,
              C => scan_clk);
  --
  scan_bit2_flop: FDR
  port map (  D => scan_bit_value(2),
              Q => scan_bit(2),
              R => scan_reset,
              C => scan_clk);
  --
  scan_bit3_flop: FDR
  port map (  D => scan_bit_value(3),
              Q => scan_bit(3),
              R => scan_reset,
              C => scan_clk);
  --
  crc_reset_lut: LUT6_2
  generic map (INIT => X"007F000020000000")
  port map( I0 => scan_bit(0),
            I1 => scan_bit(1),
            I2 => scan_bit(2),
            I3 => scan_bit(3),
            I4 => '1',
            I5 => '1',
            O5 => scan_address_ce_value,
            O6 => crc_reset_value);
  --
  scan_address_ce_flop: FDR
  port map (  D => scan_address_ce_value,
              Q => scan_address_ce,
              R => scan_reset,
              C => scan_clk);
  --
  crc_reset_flop: FDR
  port map (  D => crc_reset_value,
              Q => crc_reset,
              R => scan_reset,
              C => scan_clk);
  --
  crc_check_lut: LUT6_2
  generic map (INIT => X"FF00F0F088888888")
  port map( I0 => scan_address_carry(11),
            I1 => scan_address_ce,
            I2 => crc_check,
            I3 => crc_test,
            I4 => end_of_scan,
            I5 => '1',
            O5 => last_address_value,
            O6 => crc_check_value);
  --
  crc_check_flop: FDR
  port map (  D => crc_check_value,
              Q => crc_check,
              R => scan_reset,
              C => scan_clk);
  --
  last_address_flop: FDR
  port map (  D => last_address_value,
              Q => last_address,
              R => scan_reset,
              C => scan_clk);
  --
  scan_address0_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(0),
            I5 => '1',
            O5 => sa_carry_primer(0),
            O6 => previous_scan_address(0));
  --                 
  scan_address0_xorcy: XORCY
  port map( LI => previous_scan_address(0),
            CI => '1',
             O => scan_address_value(0));
  --
  scan_address0_muxcy: MUXCY
  port map( DI => sa_carry_primer(0),
            CI => '1',                     
             S => previous_scan_address(0),
             O => scan_address_carry(0));
  --
  scan_address0_flop: FDRE
  port map (  D => scan_address_value(0),
              Q => scan_address(0),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address1_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(1),
            I5 => '1',
            O5 => sa_carry_primer(1),
            O6 => previous_scan_address(1));
  --                 
  scan_address1_xorcy: XORCY
  port map( LI => previous_scan_address(1),
            CI => scan_address_carry(0),
             O => scan_address_value(1));
  --
  scan_address1_muxcy: MUXCY
  port map( DI => sa_carry_primer(1),
            CI => scan_address_carry(0),                     
             S => previous_scan_address(1),
             O => scan_address_carry(1));
  --
  scan_address1_flop: FDRE
  port map (  D => scan_address_value(1),
              Q => scan_address(1),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address2_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(2),
            I5 => '1',
            O5 => sa_carry_primer(2),
            O6 => previous_scan_address(2));
  --                 
  scan_address2_xorcy: XORCY
  port map( LI => previous_scan_address(2),
            CI => scan_address_carry(1),
             O => scan_address_value(2));
  --
  scan_address2_muxcy: MUXCY
  port map( DI => sa_carry_primer(2),
            CI => scan_address_carry(1),                     
             S => previous_scan_address(2),
             O => scan_address_carry(2));
  --
  scan_address2_flop: FDRE
  port map (  D => scan_address_value(2),
              Q => scan_address(2),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address3_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(3),
            I5 => '1',
            O5 => sa_carry_primer(3),
            O6 => previous_scan_address(3));
  --                 
  scan_address3_xorcy: XORCY
  port map( LI => previous_scan_address(3),
            CI => scan_address_carry(2),
             O => scan_address_value(3));
  --
  scan_address3_muxcy: MUXCY
  port map( DI => sa_carry_primer(3),
            CI => scan_address_carry(2),                     
             S => previous_scan_address(3),
             O => scan_address_carry(3));
  --
  scan_address3_flop: FDRE
  port map (  D => scan_address_value(3),
              Q => scan_address(3),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address4_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(4),
            I5 => '1',
            O5 => sa_carry_primer(4),
            O6 => previous_scan_address(4));
  --                 
  scan_address4_xorcy: XORCY
  port map( LI => previous_scan_address(4),
            CI => scan_address_carry(3),
             O => scan_address_value(4));
  --
  scan_address4_muxcy: MUXCY
  port map( DI => sa_carry_primer(4),
            CI => scan_address_carry(3),                     
             S => previous_scan_address(4),
             O => scan_address_carry(4));
  --
  scan_address4_flop: FDRE
  port map (  D => scan_address_value(4),
              Q => scan_address(4),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address5_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(5),
            I5 => '1',
            O5 => sa_carry_primer(5),
            O6 => previous_scan_address(5));
  --                 
  scan_address5_xorcy: XORCY
  port map( LI => previous_scan_address(5),
            CI => scan_address_carry(4),
             O => scan_address_value(5));
  --
  scan_address5_muxcy: MUXCY
  port map( DI => sa_carry_primer(5),
            CI => scan_address_carry(4),                     
             S => previous_scan_address(5),
             O => scan_address_carry(5));
  --
  scan_address5_flop: FDRE
  port map (  D => scan_address_value(5),
              Q => scan_address(5),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address6_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(6),
            I5 => '1',
            O5 => sa_carry_primer(6),
            O6 => previous_scan_address(6));
  --                 
  scan_address6_xorcy: XORCY
  port map( LI => previous_scan_address(6),
            CI => scan_address_carry(5),
             O => scan_address_value(6));
  --
  scan_address6_muxcy: MUXCY
  port map( DI => sa_carry_primer(6),
            CI => scan_address_carry(5),                     
             S => previous_scan_address(6),
             O => scan_address_carry(6));
  --
  scan_address6_flop: FDRE
  port map (  D => scan_address_value(6),
              Q => scan_address(6),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address7_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(7),
            I5 => '1',
            O5 => sa_carry_primer(7),
            O6 => previous_scan_address(7));
  --                 
  scan_address7_xorcy: XORCY
  port map( LI => previous_scan_address(7),
            CI => scan_address_carry(6),
             O => scan_address_value(7));
  --
  scan_address7_muxcy: MUXCY
  port map( DI => sa_carry_primer(7),
            CI => scan_address_carry(6),                     
             S => previous_scan_address(7),
             O => scan_address_carry(7));
  --
  scan_address7_flop: FDRE
  port map (  D => scan_address_value(7),
              Q => scan_address(7),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address8_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(8),
            I5 => '1',
            O5 => sa_carry_primer(8),
            O6 => previous_scan_address(8));
  --                 
  scan_address8_xorcy: XORCY
  port map( LI => previous_scan_address(8),
            CI => scan_address_carry(7),
             O => scan_address_value(8));
  --
  scan_address8_muxcy: MUXCY
  port map( DI => sa_carry_primer(8),
            CI => scan_address_carry(7),                     
             S => previous_scan_address(8),
             O => scan_address_carry(8));
  --
  scan_address8_flop: FDRE
  port map (  D => scan_address_value(8),
              Q => scan_address(8),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address9_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(9),
            I5 => '1',
            O5 => sa_carry_primer(9),
            O6 => previous_scan_address(9));
  --                 
  scan_address9_xorcy: XORCY
  port map( LI => previous_scan_address(9),
            CI => scan_address_carry(8),
             O => scan_address_value(9));
  --
  scan_address9_muxcy: MUXCY
  port map( DI => sa_carry_primer(9),
            CI => scan_address_carry(8),                     
             S => previous_scan_address(9),
             O => scan_address_carry(9));
  --
  scan_address9_flop: FDRE
  port map (  D => scan_address_value(9),
              Q => scan_address(9),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address10_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(10),
            I5 => '1',
            O5 => sa_carry_primer(10),
            O6 => previous_scan_address(10));
  --                 
  scan_address10_xorcy: XORCY
  port map( LI => previous_scan_address(10),
            CI => scan_address_carry(9),
             O => scan_address_value(10));
  --
  scan_address10_muxcy: MUXCY
  port map( DI => sa_carry_primer(10),
            CI => scan_address_carry(9),                     
             S => previous_scan_address(10),
             O => scan_address_carry(10));
  --
  scan_address10_flop: FDRE
  port map (  D => scan_address_value(10),
              Q => scan_address(10),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  scan_address11_lut: LUT6_2
  generic map (INIT => X"FFFF000000000000")
  port map( I0 => '1',
            I1 => '1',
            I2 => '1',
            I3 => '1',
            I4 => scan_address(11),
            I5 => '1',
            O5 => sa_carry_primer(11),
            O6 => previous_scan_address(11));
  --                 
  scan_address11_xorcy: XORCY
  port map( LI => previous_scan_address(11),
            CI => scan_address_carry(10),
             O => scan_address_value(11));
  --
  scan_address11_muxcy: MUXCY
  port map( DI => sa_carry_primer(11),
            CI => scan_address_carry(10),                     
             S => previous_scan_address(11),
             O => scan_address_carry(11));
  --
  scan_address11_flop: FDRE
  port map (  D => scan_address_value(11),
              Q => scan_address(11),
             CE => scan_address_ce,
              R => crc_reset,
              C => scan_clk);
  --
  serial_data_lut: LUT6
  generic map (INIT => X"CACACACACACACACA")
  port map( I0 => scan_data(0),
            I1 => scan_byte,
            I2 => scan_bit(3),
            I3 => '1',
            I4 => '1',
            I5 => '1',
             O => serial_data_value);  
  --
  serial_data_flop: FD
  port map (  D => serial_data_value,
              Q => serial_data,
              C => scan_clk);
  --
  last_bit_flop: FD
  port map (  D => last_address,
              Q => last_bit,
              C => scan_clk);
  --
  end_of_scan_flop: FD
  port map (  D => last_bit,
              Q => end_of_scan,
              C => scan_clk);
  --
  scan_complete_flop: FD
  port map (  D => end_of_scan,
              Q => scan_complete,
              C => scan_clk);
  --
  crc_test <= '0' when (crc = "{CRC_2K}") else '1';
  --
  scan_error <= crc_check;
--
end low_level_definition;
--
------------------------------------------------------------------------------------
--
-- END OF FILE {name}.vhd
--
------------------------------------------------------------------------------------
