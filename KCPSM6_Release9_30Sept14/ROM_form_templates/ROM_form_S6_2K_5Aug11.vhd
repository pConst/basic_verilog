--
-------------------------------------------------------------------------------------------
-- Copyright © 2010-2011, Xilinx, Inc.
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

Production template for a 2K program for KCPSM6 in a Spartan-6 device using 
2 x RAMB18WER primitives.

Ken Chapman (Xilinx Ltd)

5th August 2011


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
-- Copyright © 2010-2011, Xilinx, Inc.
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
-- Production definition of a 2K program for KCPSM6 in a Spartan-6 device using 
-- 2 x RAMB18WER primitives.
--
-- Note: The complete 12-bit address bus is connected to KCPSM6 to facilitate future code 
--       expansion with minimum changes being required to the hardware description. 
--       Only the lower 11-bits of the address are actually used for the 2K address range
--       000 to 7FF hex.  
--
-- Program defined by '{psmname}.psm'.
--
-- Generated by KCPSM6 Assembler: {timestamp}. 
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
signal    address_a : std_logic_vector(13 downto 0);
signal    data_in_a : std_logic_vector(35 downto 0);
signal data_out_a_l : std_logic_vector(35 downto 0);
signal data_out_a_h : std_logic_vector(35 downto 0);
signal    address_b : std_logic_vector(13 downto 0);
signal  data_in_b_l : std_logic_vector(35 downto 0);
signal data_out_b_l : std_logic_vector(35 downto 0);
signal  data_in_b_h : std_logic_vector(35 downto 0);
signal data_out_b_h : std_logic_vector(35 downto 0);
signal     enable_b : std_logic;
signal        clk_b : std_logic;
signal         we_b : std_logic_vector(3 downto 0);
--
begin
--
  address_a <= address(10 downto 0) & "000";
  instruction <= data_out_a_h(32) & data_out_a_h(7 downto 0) & data_out_a_l(32) & data_out_a_l(7 downto 0);
  data_in_a <= "00000000000000000000000000000000000" & address(11);
  --
  address_b <= "00000000000000";
  data_in_b_l <= "000" & data_out_b_l(32) & "000000000000000000000000" & data_out_b_l(7 downto 0);
  data_in_b_h <= "000" & data_out_b_h(32) & "000000000000000000000000" & data_out_b_h(7 downto 0);
   enable_b <= '0';
       we_b <= "0000";
      clk_b <= '0';
  --
  --
  -- 
  kcpsm6_rom_l: RAMB16BWER
  generic map ( DATA_WIDTH_A => 9,
                DOA_REG => 0,
                EN_RSTRAM_A => FALSE,
                INIT_A => X"000000000",
                RST_PRIORITY_A => "CE",
                SRVAL_A => X"000000000",
                WRITE_MODE_A => "WRITE_FIRST",
                DATA_WIDTH_B => 9,
                DOB_REG => 0,
                EN_RSTRAM_B => FALSE,
                INIT_B => X"000000000",
                RST_PRIORITY_B => "CE",
                SRVAL_B => X"000000000",
                WRITE_MODE_B => "WRITE_FIRST",
                RSTTYPE => "SYNC",
                INIT_FILE => "NONE",
                SIM_COLLISION_CHECK => "ALL",
                SIM_DEVICE => "SPARTAN6",
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
               INITP_00 => X"{[8:0]_INITP_00}",
               INITP_01 => X"{[8:0]_INITP_01}",
               INITP_02 => X"{[8:0]_INITP_02}",
               INITP_03 => X"{[8:0]_INITP_03}",
               INITP_04 => X"{[8:0]_INITP_04}",
               INITP_05 => X"{[8:0]_INITP_05}",
               INITP_06 => X"{[8:0]_INITP_06}",
               INITP_07 => X"{[8:0]_INITP_07}")
  port map(  ADDRA => address_a,
               ENA => enable,
              CLKA => clk,
               DOA => data_out_a_l(31 downto 0),
              DOPA => data_out_a_l(35 downto 32), 
               DIA => data_in_a(31 downto 0),
              DIPA => data_in_a(35 downto 32), 
               WEA => "0000",
            REGCEA => '0',
              RSTA => '0',
             ADDRB => address_b,
               ENB => enable_b,
              CLKB => clk_b,
               DOB => data_out_b_l(31 downto 0),
              DOPB => data_out_b_l(35 downto 32), 
               DIB => data_in_b_l(31 downto 0),
              DIPB => data_in_b_l(35 downto 32), 
               WEB => we_b,
            REGCEB => '0',
              RSTB => '0');
  --
  --
  -- 
  kcpsm6_rom_h: RAMB16BWER
  generic map ( DATA_WIDTH_A => 9,
                DOA_REG => 0,
                EN_RSTRAM_A => FALSE,
                INIT_A => X"000000000",
                RST_PRIORITY_A => "CE",
                SRVAL_A => X"000000000",
                WRITE_MODE_A => "WRITE_FIRST",
                DATA_WIDTH_B => 9,
                DOB_REG => 0,
                EN_RSTRAM_B => FALSE,
                INIT_B => X"000000000",
                RST_PRIORITY_B => "CE",
                SRVAL_B => X"000000000",
                WRITE_MODE_B => "WRITE_FIRST",
                RSTTYPE => "SYNC",
                INIT_FILE => "NONE",
                SIM_COLLISION_CHECK => "ALL",
                SIM_DEVICE => "SPARTAN6",
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
               INITP_00 => X"{[17:9]_INITP_00}",
               INITP_01 => X"{[17:9]_INITP_01}",
               INITP_02 => X"{[17:9]_INITP_02}",
               INITP_03 => X"{[17:9]_INITP_03}",
               INITP_04 => X"{[17:9]_INITP_04}",
               INITP_05 => X"{[17:9]_INITP_05}",
               INITP_06 => X"{[17:9]_INITP_06}",
               INITP_07 => X"{[17:9]_INITP_07}")
  port map(  ADDRA => address_a,
               ENA => enable,
              CLKA => clk,
               DOA => data_out_a_h(31 downto 0),
              DOPA => data_out_a_h(35 downto 32), 
               DIA => data_in_a(31 downto 0),
              DIPA => data_in_a(35 downto 32), 
               WEA => "0000",
            REGCEA => '0',
              RSTA => '0',
             ADDRB => address_b,
               ENB => enable_b,
              CLKB => clk_b,
               DOB => data_out_b_h(31 downto 0),
              DOPB => data_out_b_h(35 downto 32), 
               DIB => data_in_b_h(31 downto 0),
              DIPB => data_in_b_h(35 downto 32), 
               WEB => we_b,
            REGCEB => '0',
              RSTB => '0');
--
--
end low_level_definition;
--
------------------------------------------------------------------------------------
--
-- END OF FILE {name}.vhd
--
------------------------------------------------------------------------------------
