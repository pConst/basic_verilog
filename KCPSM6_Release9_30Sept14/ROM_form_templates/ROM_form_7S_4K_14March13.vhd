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

Production template for a 4K program for KCPSM6 in a 7-Series device using  
2 x RAMB36E1 primitives.

Ken Chapman (Xilinx Ltd)

5th August 2011 - First Release
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
-- Production definition of a 4K program for KCPSM6 in a 7-Series device using  
-- 2 x RAMB36E1 primitives.
--
--
-- Program defined by '{psmname}.psm'.
--
-- Generated by KCPSM6 Assembler: {timestamp}. 
--
-- Assembler used ROM_form template: ROM_form_7S_4K_14March13.vhd
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
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    clk : in std_logic);
    end {name};
--
architecture low_level_definition of {name} is
--
signal  address_a : std_logic_vector(15 downto 0);
signal  data_in_a : std_logic_vector(35 downto 0);
signal data_out_a_l : std_logic_vector(35 downto 0);
signal data_out_a_h : std_logic_vector(35 downto 0);
signal  address_b : std_logic_vector(15 downto 0);
signal  data_in_b_l : std_logic_vector(35 downto 0);
signal data_out_b_l : std_logic_vector(35 downto 0);
signal  data_in_b_h : std_logic_vector(35 downto 0);
signal data_out_b_h : std_logic_vector(35 downto 0);
signal   enable_b : std_logic;
signal      clk_b : std_logic;
signal       we_b : std_logic_vector(7 downto 0);
--
begin
--
  address_a <= '1' & address(11 downto 0) & "111";
  instruction <= data_out_a_h(32) & data_out_a_h(7 downto 0) & data_out_a_l(32) & data_out_a_l(7 downto 0);
  data_in_a <= "000000000000000000000000000000000000";
  --
  address_b <= "1111111111111111";
  data_in_b_l <= "000" & data_out_b_l(32) & "000000000000000000000000" & data_out_b_l(7 downto 0);
  data_in_b_h <= "000" & data_out_b_h(32) & "000000000000000000000000" & data_out_b_h(7 downto 0);
  enable_b <= '0';
  we_b <= "00000000";
  clk_b <= '0';
  --
  kcpsm6_rom_l: RAMB36E1
  generic map ( READ_WIDTH_A => 9,
                WRITE_WIDTH_A => 9,
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
                INIT_00 => X"{[8:0]_INIT_00}",
                INIT_01 => X"{[8:0]_INIT_01}",
                INIT_02 => X"{[8:0]_INIT_02}",
                INIT_03 => X"{[8:0]_INIT_03}",
                INIT_04 => X"{[8:0]_INIT_04}",
                INIT_05 => X"{[8:0]_INIT_05}",
                INIT_06 => X"{[8:0]_INIT_06}",
                INIT_07 => X"{[8:0]_INIT_07}",
                INIT_08 => X"{[8:0]_INIT_08}",
                INIT_09 => X"{[8:0]_INIT_09}",
                INIT_0A => X"{[8:0]_INIT_0A}",
                INIT_0B => X"{[8:0]_INIT_0B}",
                INIT_0C => X"{[8:0]_INIT_0C}",
                INIT_0D => X"{[8:0]_INIT_0D}",
                INIT_0E => X"{[8:0]_INIT_0E}",
                INIT_0F => X"{[8:0]_INIT_0F}",
                INIT_10 => X"{[8:0]_INIT_10}",
                INIT_11 => X"{[8:0]_INIT_11}",
                INIT_12 => X"{[8:0]_INIT_12}",
                INIT_13 => X"{[8:0]_INIT_13}",
                INIT_14 => X"{[8:0]_INIT_14}",
                INIT_15 => X"{[8:0]_INIT_15}",
                INIT_16 => X"{[8:0]_INIT_16}",
                INIT_17 => X"{[8:0]_INIT_17}",
                INIT_18 => X"{[8:0]_INIT_18}",
                INIT_19 => X"{[8:0]_INIT_19}",
                INIT_1A => X"{[8:0]_INIT_1A}",
                INIT_1B => X"{[8:0]_INIT_1B}",
                INIT_1C => X"{[8:0]_INIT_1C}",
                INIT_1D => X"{[8:0]_INIT_1D}",
                INIT_1E => X"{[8:0]_INIT_1E}",
                INIT_1F => X"{[8:0]_INIT_1F}",
                INIT_20 => X"{[8:0]_INIT_20}",
                INIT_21 => X"{[8:0]_INIT_21}",
                INIT_22 => X"{[8:0]_INIT_22}",
                INIT_23 => X"{[8:0]_INIT_23}",
                INIT_24 => X"{[8:0]_INIT_24}",
                INIT_25 => X"{[8:0]_INIT_25}",
                INIT_26 => X"{[8:0]_INIT_26}",
                INIT_27 => X"{[8:0]_INIT_27}",
                INIT_28 => X"{[8:0]_INIT_28}",
                INIT_29 => X"{[8:0]_INIT_29}",
                INIT_2A => X"{[8:0]_INIT_2A}",
                INIT_2B => X"{[8:0]_INIT_2B}",
                INIT_2C => X"{[8:0]_INIT_2C}",
                INIT_2D => X"{[8:0]_INIT_2D}",
                INIT_2E => X"{[8:0]_INIT_2E}",
                INIT_2F => X"{[8:0]_INIT_2F}",
                INIT_30 => X"{[8:0]_INIT_30}",
                INIT_31 => X"{[8:0]_INIT_31}",
                INIT_32 => X"{[8:0]_INIT_32}",
                INIT_33 => X"{[8:0]_INIT_33}",
                INIT_34 => X"{[8:0]_INIT_34}",
                INIT_35 => X"{[8:0]_INIT_35}",
                INIT_36 => X"{[8:0]_INIT_36}",
                INIT_37 => X"{[8:0]_INIT_37}",
                INIT_38 => X"{[8:0]_INIT_38}",
                INIT_39 => X"{[8:0]_INIT_39}",
                INIT_3A => X"{[8:0]_INIT_3A}",
                INIT_3B => X"{[8:0]_INIT_3B}",
                INIT_3C => X"{[8:0]_INIT_3C}",
                INIT_3D => X"{[8:0]_INIT_3D}",
                INIT_3E => X"{[8:0]_INIT_3E}",
                INIT_3F => X"{[8:0]_INIT_3F}",
                INIT_40 => X"{[8:0]_INIT_40}",
                INIT_41 => X"{[8:0]_INIT_41}",
                INIT_42 => X"{[8:0]_INIT_42}",
                INIT_43 => X"{[8:0]_INIT_43}",
                INIT_44 => X"{[8:0]_INIT_44}",
                INIT_45 => X"{[8:0]_INIT_45}",
                INIT_46 => X"{[8:0]_INIT_46}",
                INIT_47 => X"{[8:0]_INIT_47}",
                INIT_48 => X"{[8:0]_INIT_48}",
                INIT_49 => X"{[8:0]_INIT_49}",
                INIT_4A => X"{[8:0]_INIT_4A}",
                INIT_4B => X"{[8:0]_INIT_4B}",
                INIT_4C => X"{[8:0]_INIT_4C}",
                INIT_4D => X"{[8:0]_INIT_4D}",
                INIT_4E => X"{[8:0]_INIT_4E}",
                INIT_4F => X"{[8:0]_INIT_4F}",
                INIT_50 => X"{[8:0]_INIT_50}",
                INIT_51 => X"{[8:0]_INIT_51}",
                INIT_52 => X"{[8:0]_INIT_52}",
                INIT_53 => X"{[8:0]_INIT_53}",
                INIT_54 => X"{[8:0]_INIT_54}",
                INIT_55 => X"{[8:0]_INIT_55}",
                INIT_56 => X"{[8:0]_INIT_56}",
                INIT_57 => X"{[8:0]_INIT_57}",
                INIT_58 => X"{[8:0]_INIT_58}",
                INIT_59 => X"{[8:0]_INIT_59}",
                INIT_5A => X"{[8:0]_INIT_5A}",
                INIT_5B => X"{[8:0]_INIT_5B}",
                INIT_5C => X"{[8:0]_INIT_5C}",
                INIT_5D => X"{[8:0]_INIT_5D}",
                INIT_5E => X"{[8:0]_INIT_5E}",
                INIT_5F => X"{[8:0]_INIT_5F}",
                INIT_60 => X"{[8:0]_INIT_60}",
                INIT_61 => X"{[8:0]_INIT_61}",
                INIT_62 => X"{[8:0]_INIT_62}",
                INIT_63 => X"{[8:0]_INIT_63}",
                INIT_64 => X"{[8:0]_INIT_64}",
                INIT_65 => X"{[8:0]_INIT_65}",
                INIT_66 => X"{[8:0]_INIT_66}",
                INIT_67 => X"{[8:0]_INIT_67}",
                INIT_68 => X"{[8:0]_INIT_68}",
                INIT_69 => X"{[8:0]_INIT_69}",
                INIT_6A => X"{[8:0]_INIT_6A}",
                INIT_6B => X"{[8:0]_INIT_6B}",
                INIT_6C => X"{[8:0]_INIT_6C}",
                INIT_6D => X"{[8:0]_INIT_6D}",
                INIT_6E => X"{[8:0]_INIT_6E}",
                INIT_6F => X"{[8:0]_INIT_6F}",
                INIT_70 => X"{[8:0]_INIT_70}",
                INIT_71 => X"{[8:0]_INIT_71}",
                INIT_72 => X"{[8:0]_INIT_72}",
                INIT_73 => X"{[8:0]_INIT_73}",
                INIT_74 => X"{[8:0]_INIT_74}",
                INIT_75 => X"{[8:0]_INIT_75}",
                INIT_76 => X"{[8:0]_INIT_76}",
                INIT_77 => X"{[8:0]_INIT_77}",
                INIT_78 => X"{[8:0]_INIT_78}",
                INIT_79 => X"{[8:0]_INIT_79}",
                INIT_7A => X"{[8:0]_INIT_7A}",
                INIT_7B => X"{[8:0]_INIT_7B}",
                INIT_7C => X"{[8:0]_INIT_7C}",
                INIT_7D => X"{[8:0]_INIT_7D}",
                INIT_7E => X"{[8:0]_INIT_7E}",
                INIT_7F => X"{[8:0]_INIT_7F}",
               INITP_00 => X"{[8:0]_INITP_00}",
               INITP_01 => X"{[8:0]_INITP_01}",
               INITP_02 => X"{[8:0]_INITP_02}",
               INITP_03 => X"{[8:0]_INITP_03}",
               INITP_04 => X"{[8:0]_INITP_04}",
               INITP_05 => X"{[8:0]_INITP_05}",
               INITP_06 => X"{[8:0]_INITP_06}",
               INITP_07 => X"{[8:0]_INITP_07}",
               INITP_08 => X"{[8:0]_INITP_08}",
               INITP_09 => X"{[8:0]_INITP_09}",
               INITP_0A => X"{[8:0]_INITP_0A}",
               INITP_0B => X"{[8:0]_INITP_0B}",
               INITP_0C => X"{[8:0]_INITP_0C}",
               INITP_0D => X"{[8:0]_INITP_0D}",
               INITP_0E => X"{[8:0]_INITP_0E}",
               INITP_0F => X"{[8:0]_INITP_0F}")
  port map(   ADDRARDADDR => address_a,
                  ENARDEN => enable,
                CLKARDCLK => clk,
                    DOADO => data_out_a_l(31 downto 0),
                  DOPADOP => data_out_a_l(35 downto 32), 
                    DIADI => data_in_a(31 downto 0),
                  DIPADIP => data_in_a(35 downto 32), 
                      WEA => "0000",
              REGCEAREGCE => '0',
            RSTRAMARSTRAM => '0',
            RSTREGARSTREG => '0',
              ADDRBWRADDR => address_b,
                  ENBWREN => enable_b,
                CLKBWRCLK => clk_b,
                    DOBDO => data_out_b_l(31 downto 0),
                  DOPBDOP => data_out_b_l(35 downto 32), 
                    DIBDI => data_in_b_l(31 downto 0),
                  DIPBDIP => data_in_b_l(35 downto 32), 
                    WEBWE => we_b,
                   REGCEB => '0',
                  RSTRAMB => '0',
                  RSTREGB => '0',
               CASCADEINA => '0',
               CASCADEINB => '0',
            INJECTDBITERR => '0',
            INJECTSBITERR => '0');
  --
  kcpsm6_rom_h: RAMB36E1
  generic map ( READ_WIDTH_A => 9,
                WRITE_WIDTH_A => 9,
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
                INIT_00 => X"{[17:9]_INIT_00}",
                INIT_01 => X"{[17:9]_INIT_01}",
                INIT_02 => X"{[17:9]_INIT_02}",
                INIT_03 => X"{[17:9]_INIT_03}",
                INIT_04 => X"{[17:9]_INIT_04}",
                INIT_05 => X"{[17:9]_INIT_05}",
                INIT_06 => X"{[17:9]_INIT_06}",
                INIT_07 => X"{[17:9]_INIT_07}",
                INIT_08 => X"{[17:9]_INIT_08}",
                INIT_09 => X"{[17:9]_INIT_09}",
                INIT_0A => X"{[17:9]_INIT_0A}",
                INIT_0B => X"{[17:9]_INIT_0B}",
                INIT_0C => X"{[17:9]_INIT_0C}",
                INIT_0D => X"{[17:9]_INIT_0D}",
                INIT_0E => X"{[17:9]_INIT_0E}",
                INIT_0F => X"{[17:9]_INIT_0F}",
                INIT_10 => X"{[17:9]_INIT_10}",
                INIT_11 => X"{[17:9]_INIT_11}",
                INIT_12 => X"{[17:9]_INIT_12}",
                INIT_13 => X"{[17:9]_INIT_13}",
                INIT_14 => X"{[17:9]_INIT_14}",
                INIT_15 => X"{[17:9]_INIT_15}",
                INIT_16 => X"{[17:9]_INIT_16}",
                INIT_17 => X"{[17:9]_INIT_17}",
                INIT_18 => X"{[17:9]_INIT_18}",
                INIT_19 => X"{[17:9]_INIT_19}",
                INIT_1A => X"{[17:9]_INIT_1A}",
                INIT_1B => X"{[17:9]_INIT_1B}",
                INIT_1C => X"{[17:9]_INIT_1C}",
                INIT_1D => X"{[17:9]_INIT_1D}",
                INIT_1E => X"{[17:9]_INIT_1E}",
                INIT_1F => X"{[17:9]_INIT_1F}",
                INIT_20 => X"{[17:9]_INIT_20}",
                INIT_21 => X"{[17:9]_INIT_21}",
                INIT_22 => X"{[17:9]_INIT_22}",
                INIT_23 => X"{[17:9]_INIT_23}",
                INIT_24 => X"{[17:9]_INIT_24}",
                INIT_25 => X"{[17:9]_INIT_25}",
                INIT_26 => X"{[17:9]_INIT_26}",
                INIT_27 => X"{[17:9]_INIT_27}",
                INIT_28 => X"{[17:9]_INIT_28}",
                INIT_29 => X"{[17:9]_INIT_29}",
                INIT_2A => X"{[17:9]_INIT_2A}",
                INIT_2B => X"{[17:9]_INIT_2B}",
                INIT_2C => X"{[17:9]_INIT_2C}",
                INIT_2D => X"{[17:9]_INIT_2D}",
                INIT_2E => X"{[17:9]_INIT_2E}",
                INIT_2F => X"{[17:9]_INIT_2F}",
                INIT_30 => X"{[17:9]_INIT_30}",
                INIT_31 => X"{[17:9]_INIT_31}",
                INIT_32 => X"{[17:9]_INIT_32}",
                INIT_33 => X"{[17:9]_INIT_33}",
                INIT_34 => X"{[17:9]_INIT_34}",
                INIT_35 => X"{[17:9]_INIT_35}",
                INIT_36 => X"{[17:9]_INIT_36}",
                INIT_37 => X"{[17:9]_INIT_37}",
                INIT_38 => X"{[17:9]_INIT_38}",
                INIT_39 => X"{[17:9]_INIT_39}",
                INIT_3A => X"{[17:9]_INIT_3A}",
                INIT_3B => X"{[17:9]_INIT_3B}",
                INIT_3C => X"{[17:9]_INIT_3C}",
                INIT_3D => X"{[17:9]_INIT_3D}",
                INIT_3E => X"{[17:9]_INIT_3E}",
                INIT_3F => X"{[17:9]_INIT_3F}",
                INIT_40 => X"{[17:9]_INIT_40}",
                INIT_41 => X"{[17:9]_INIT_41}",
                INIT_42 => X"{[17:9]_INIT_42}",
                INIT_43 => X"{[17:9]_INIT_43}",
                INIT_44 => X"{[17:9]_INIT_44}",
                INIT_45 => X"{[17:9]_INIT_45}",
                INIT_46 => X"{[17:9]_INIT_46}",
                INIT_47 => X"{[17:9]_INIT_47}",
                INIT_48 => X"{[17:9]_INIT_48}",
                INIT_49 => X"{[17:9]_INIT_49}",
                INIT_4A => X"{[17:9]_INIT_4A}",
                INIT_4B => X"{[17:9]_INIT_4B}",
                INIT_4C => X"{[17:9]_INIT_4C}",
                INIT_4D => X"{[17:9]_INIT_4D}",
                INIT_4E => X"{[17:9]_INIT_4E}",
                INIT_4F => X"{[17:9]_INIT_4F}",
                INIT_50 => X"{[17:9]_INIT_50}",
                INIT_51 => X"{[17:9]_INIT_51}",
                INIT_52 => X"{[17:9]_INIT_52}",
                INIT_53 => X"{[17:9]_INIT_53}",
                INIT_54 => X"{[17:9]_INIT_54}",
                INIT_55 => X"{[17:9]_INIT_55}",
                INIT_56 => X"{[17:9]_INIT_56}",
                INIT_57 => X"{[17:9]_INIT_57}",
                INIT_58 => X"{[17:9]_INIT_58}",
                INIT_59 => X"{[17:9]_INIT_59}",
                INIT_5A => X"{[17:9]_INIT_5A}",
                INIT_5B => X"{[17:9]_INIT_5B}",
                INIT_5C => X"{[17:9]_INIT_5C}",
                INIT_5D => X"{[17:9]_INIT_5D}",
                INIT_5E => X"{[17:9]_INIT_5E}",
                INIT_5F => X"{[17:9]_INIT_5F}",
                INIT_60 => X"{[17:9]_INIT_60}",
                INIT_61 => X"{[17:9]_INIT_61}",
                INIT_62 => X"{[17:9]_INIT_62}",
                INIT_63 => X"{[17:9]_INIT_63}",
                INIT_64 => X"{[17:9]_INIT_64}",
                INIT_65 => X"{[17:9]_INIT_65}",
                INIT_66 => X"{[17:9]_INIT_66}",
                INIT_67 => X"{[17:9]_INIT_67}",
                INIT_68 => X"{[17:9]_INIT_68}",
                INIT_69 => X"{[17:9]_INIT_69}",
                INIT_6A => X"{[17:9]_INIT_6A}",
                INIT_6B => X"{[17:9]_INIT_6B}",
                INIT_6C => X"{[17:9]_INIT_6C}",
                INIT_6D => X"{[17:9]_INIT_6D}",
                INIT_6E => X"{[17:9]_INIT_6E}",
                INIT_6F => X"{[17:9]_INIT_6F}",
                INIT_70 => X"{[17:9]_INIT_70}",
                INIT_71 => X"{[17:9]_INIT_71}",
                INIT_72 => X"{[17:9]_INIT_72}",
                INIT_73 => X"{[17:9]_INIT_73}",
                INIT_74 => X"{[17:9]_INIT_74}",
                INIT_75 => X"{[17:9]_INIT_75}",
                INIT_76 => X"{[17:9]_INIT_76}",
                INIT_77 => X"{[17:9]_INIT_77}",
                INIT_78 => X"{[17:9]_INIT_78}",
                INIT_79 => X"{[17:9]_INIT_79}",
                INIT_7A => X"{[17:9]_INIT_7A}",
                INIT_7B => X"{[17:9]_INIT_7B}",
                INIT_7C => X"{[17:9]_INIT_7C}",
                INIT_7D => X"{[17:9]_INIT_7D}",
                INIT_7E => X"{[17:9]_INIT_7E}",
                INIT_7F => X"{[17:9]_INIT_7F}",
               INITP_00 => X"{[17:9]_INITP_00}",
               INITP_01 => X"{[17:9]_INITP_01}",
               INITP_02 => X"{[17:9]_INITP_02}",
               INITP_03 => X"{[17:9]_INITP_03}",
               INITP_04 => X"{[17:9]_INITP_04}",
               INITP_05 => X"{[17:9]_INITP_05}",
               INITP_06 => X"{[17:9]_INITP_06}",
               INITP_07 => X"{[17:9]_INITP_07}",
               INITP_08 => X"{[17:9]_INITP_08}",
               INITP_09 => X"{[17:9]_INITP_09}",
               INITP_0A => X"{[17:9]_INITP_0A}",
               INITP_0B => X"{[17:9]_INITP_0B}",
               INITP_0C => X"{[17:9]_INITP_0C}",
               INITP_0D => X"{[17:9]_INITP_0D}",
               INITP_0E => X"{[17:9]_INITP_0E}",
               INITP_0F => X"{[17:9]_INITP_0F}")
  port map(   ADDRARDADDR => address_a,
                  ENARDEN => enable,
                CLKARDCLK => clk,
                    DOADO => data_out_a_h(31 downto 0),
                  DOPADOP => data_out_a_h(35 downto 32), 
                    DIADI => data_in_a(31 downto 0),
                  DIPADIP => data_in_a(35 downto 32), 
                      WEA => "0000",
              REGCEAREGCE => '0',
            RSTRAMARSTRAM => '0',
            RSTREGARSTREG => '0',
              ADDRBWRADDR => address_b,
                  ENBWREN => enable_b,
                CLKBWRCLK => clk_b,
                    DOBDO => data_out_b_h(31 downto 0),
                  DOPBDOP => data_out_b_h(35 downto 32), 
                    DIBDI => data_in_b_h(31 downto 0),
                  DIPBDIP => data_in_b_h(35 downto 32), 
                    WEBWE => we_b,
                   REGCEB => '0',
                  RSTRAMB => '0',
                  RSTREGB => '0',
               CASCADEINA => '0',
               CASCADEINB => '0',
            INJECTDBITERR => '0',
            INJECTSBITERR => '0');
--
end low_level_definition;
--
------------------------------------------------------------------------------------
--
-- END OF FILE {name}.vhd
--
------------------------------------------------------------------------------------
