--
-------------------------------------------------------------------------------------------
-- Copyright © 2010-2012, Xilinx, Inc.
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

Production template for a 4K KCPSM6 program in a Spartan-6 device using 
4 x RAMB18WER. It should be noted that a 4K program is not such a natural fit in
a Spartan-6 device and the implementation also requires a small amount of logic 
(9 x LUT6_2 and an FD) resulting in slightly lower performance compared with 
memories for 1K and 2K programs.

Ken Chapman (Xilinx Ltd)

23rd November 2012


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
-- Copyright © 2010-2012, Xilinx, Inc.
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
-- Production definition of a 4K program for KCPSM6 in a Spartan-6 device using 
-- 4 x RAMB18WER. It should be noted that a 4K program is not such a natural fit in
-- a Spartan-6 device and the implementation also requires a small amount of logic 
-- (9 x LUT6_2 and an FD) resulting in slightly lower performance compared with 
-- memories for 1K and 2K programs.
--
--
-- Program defined by '{psmname}.psm'.
--
-- Generated by KCPSM6 Assembler: {timestamp}. 
--
-- Assembler used ROM_form template: 23rd November 2012
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
signal     address_a : std_logic_vector(13 downto 0);
signal      pipe_a11 : std_logic;
signal     data_in_a : std_logic_vector(35 downto 0);
signal data_out_a_ll : std_logic_vector(35 downto 0);
signal data_out_a_lh : std_logic_vector(35 downto 0);
signal data_out_a_hl : std_logic_vector(35 downto 0);
signal data_out_a_hh : std_logic_vector(35 downto 0);
signal     address_b : std_logic_vector(13 downto 0);
signal  data_in_b_ll : std_logic_vector(35 downto 0);
signal data_out_b_ll : std_logic_vector(35 downto 0);
signal  data_in_b_lh : std_logic_vector(35 downto 0);
signal data_out_b_lh : std_logic_vector(35 downto 0);
signal  data_in_b_hl : std_logic_vector(35 downto 0);
signal data_out_b_hl : std_logic_vector(35 downto 0);
signal  data_in_b_hh : std_logic_vector(35 downto 0);
signal data_out_b_hh : std_logic_vector(35 downto 0);
signal      enable_b : std_logic;
signal         clk_b : std_logic;
signal          we_b : std_logic_vector(3 downto 0);
--
begin
--
  address_a <= address(10 downto 0) & "000";
  data_in_a <= "000000000000000000000000000000000000";
  --
  s6_a11_flop: FD
  port map (  D => address(11),
              Q => pipe_a11,
              C => clk);
  --
  s6_4k_mux0_lut: LUT6_2
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data_out_a_ll(0),
            I1 => data_out_a_hl(0),
            I2 => data_out_a_ll(1),
            I3 => data_out_a_hl(1),
            I4 => pipe_a11,
            I5 => '1',
            O5 => instruction(0),
            O6 => instruction(1));
  --
  s6_4k_mux2_lut: LUT6_2
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data_out_a_ll(2),
            I1 => data_out_a_hl(2),
            I2 => data_out_a_ll(3),
            I3 => data_out_a_hl(3),
            I4 => pipe_a11,
            I5 => '1',
            O5 => instruction(2),
            O6 => instruction(3));
  --
  s6_4k_mux4_lut: LUT6_2
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data_out_a_ll(4),
            I1 => data_out_a_hl(4),
            I2 => data_out_a_ll(5),
            I3 => data_out_a_hl(5),
            I4 => pipe_a11,
            I5 => '1',
            O5 => instruction(4),
            O6 => instruction(5));
  --
  s6_4k_mux6_lut: LUT6_2
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data_out_a_ll(6),
            I1 => data_out_a_hl(6),
            I2 => data_out_a_ll(7),
            I3 => data_out_a_hl(7),
            I4 => pipe_a11,
            I5 => '1',
            O5 => instruction(6),
            O6 => instruction(7));
  --
  s6_4k_mux8_lut: LUT6_2
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data_out_a_ll(32),
            I1 => data_out_a_hl(32),
            I2 => data_out_a_lh(0),
            I3 => data_out_a_hh(0),
            I4 => pipe_a11,
            I5 => '1',
            O5 => instruction(8),
            O6 => instruction(9));
  --
  s6_4k_mux10_lut: LUT6_2
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data_out_a_lh(1),
            I1 => data_out_a_hh(1),
            I2 => data_out_a_lh(2),
            I3 => data_out_a_hh(2),
            I4 => pipe_a11,
            I5 => '1',
            O5 => instruction(10),
            O6 => instruction(11));
  --
  s6_4k_mux12_lut: LUT6_2
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data_out_a_lh(3),
            I1 => data_out_a_hh(3),
            I2 => data_out_a_lh(4),
            I3 => data_out_a_hh(4),
            I4 => pipe_a11,
            I5 => '1',
            O5 => instruction(12),
            O6 => instruction(13));
  --
  s6_4k_mux14_lut: LUT6_2
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data_out_a_lh(5),
            I1 => data_out_a_hh(5),
            I2 => data_out_a_lh(6),
            I3 => data_out_a_hh(6),
            I4 => pipe_a11,
            I5 => '1',
            O5 => instruction(14),
            O6 => instruction(15));
  --
  s6_4k_mux16_lut: LUT6_2
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data_out_a_lh(7),
            I1 => data_out_a_hh(7),
            I2 => data_out_a_lh(32),
            I3 => data_out_a_hh(32),
            I4 => pipe_a11,
            I5 => '1',
            O5 => instruction(16),
            O6 => instruction(17));
  --
  address_b <= "00000000000000";
  data_in_b_ll <= "000" & data_out_b_ll(32) & "000000000000000000000000" & data_out_b_ll(7 downto 0);
  data_in_b_lh <= "000" & data_out_b_lh(32) & "000000000000000000000000" & data_out_b_lh(7 downto 0);
  data_in_b_hl <= "000" & data_out_b_hl(32) & "000000000000000000000000" & data_out_b_hl(7 downto 0);
  data_in_b_hh <= "000" & data_out_b_hh(32) & "000000000000000000000000" & data_out_b_hh(7 downto 0);
  enable_b <= '0';
  we_b <= "0000";
  clk_b <= '0';
  --
  --
  -- 
  kcpsm6_rom_ll: RAMB16BWER
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
               DOA => data_out_a_ll(31 downto 0),
              DOPA => data_out_a_ll(35 downto 32), 
               DIA => data_in_a(31 downto 0),
              DIPA => data_in_a(35 downto 32), 
               WEA => "0000",
            REGCEA => '0',
              RSTA => '0',
             ADDRB => address_b,
               ENB => enable_b,
              CLKB => clk_b,
               DOB => data_out_b_ll(31 downto 0),
              DOPB => data_out_b_ll(35 downto 32), 
               DIB => data_in_b_ll(31 downto 0),
              DIPB => data_in_b_ll(35 downto 32), 
               WEB => we_b,
            REGCEB => '0',
              RSTB => '0');
  --
  --
  -- 
  kcpsm6_rom_lh: RAMB16BWER
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
               DOA => data_out_a_lh(31 downto 0),
              DOPA => data_out_a_lh(35 downto 32), 
               DIA => data_in_a(31 downto 0),
              DIPA => data_in_a(35 downto 32), 
               WEA => "0000",
            REGCEA => '0',
              RSTA => '0',
             ADDRB => address_b,
               ENB => enable_b,
              CLKB => clk_b,
               DOB => data_out_b_lh(31 downto 0),
              DOPB => data_out_b_lh(35 downto 32), 
               DIB => data_in_b_lh(31 downto 0),
              DIPB => data_in_b_lh(35 downto 32), 
               WEB => we_b,
            REGCEB => '0',
              RSTB => '0');
  -- 
  kcpsm6_rom_hl: RAMB16BWER
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
                INIT_00 => X"{[8:0]_INIT_40}",
                INIT_01 => X"{[8:0]_INIT_41}",
                INIT_02 => X"{[8:0]_INIT_42}",
                INIT_03 => X"{[8:0]_INIT_43}",
                INIT_04 => X"{[8:0]_INIT_44}",
                INIT_05 => X"{[8:0]_INIT_45}",
                INIT_06 => X"{[8:0]_INIT_46}",
                INIT_07 => X"{[8:0]_INIT_47}",
                INIT_08 => X"{[8:0]_INIT_48}",
                INIT_09 => X"{[8:0]_INIT_49}",
                INIT_0A => X"{[8:0]_INIT_4A}",
                INIT_0B => X"{[8:0]_INIT_4B}",
                INIT_0C => X"{[8:0]_INIT_4C}",
                INIT_0D => X"{[8:0]_INIT_4D}",
                INIT_0E => X"{[8:0]_INIT_4E}",
                INIT_0F => X"{[8:0]_INIT_4F}",
                INIT_10 => X"{[8:0]_INIT_50}",
                INIT_11 => X"{[8:0]_INIT_51}",
                INIT_12 => X"{[8:0]_INIT_52}",
                INIT_13 => X"{[8:0]_INIT_53}",
                INIT_14 => X"{[8:0]_INIT_54}",
                INIT_15 => X"{[8:0]_INIT_55}",
                INIT_16 => X"{[8:0]_INIT_56}",
                INIT_17 => X"{[8:0]_INIT_57}",
                INIT_18 => X"{[8:0]_INIT_58}",
                INIT_19 => X"{[8:0]_INIT_59}",
                INIT_1A => X"{[8:0]_INIT_5A}",
                INIT_1B => X"{[8:0]_INIT_5B}",
                INIT_1C => X"{[8:0]_INIT_5C}",
                INIT_1D => X"{[8:0]_INIT_5D}",
                INIT_1E => X"{[8:0]_INIT_5E}",
                INIT_1F => X"{[8:0]_INIT_5F}",
                INIT_20 => X"{[8:0]_INIT_60}",
                INIT_21 => X"{[8:0]_INIT_61}",
                INIT_22 => X"{[8:0]_INIT_62}",
                INIT_23 => X"{[8:0]_INIT_63}",
                INIT_24 => X"{[8:0]_INIT_64}",
                INIT_25 => X"{[8:0]_INIT_65}",
                INIT_26 => X"{[8:0]_INIT_66}",
                INIT_27 => X"{[8:0]_INIT_67}",
                INIT_28 => X"{[8:0]_INIT_68}",
                INIT_29 => X"{[8:0]_INIT_69}",
                INIT_2A => X"{[8:0]_INIT_6A}",
                INIT_2B => X"{[8:0]_INIT_6B}",
                INIT_2C => X"{[8:0]_INIT_6C}",
                INIT_2D => X"{[8:0]_INIT_6D}",
                INIT_2E => X"{[8:0]_INIT_6E}",
                INIT_2F => X"{[8:0]_INIT_6F}",
                INIT_30 => X"{[8:0]_INIT_70}",
                INIT_31 => X"{[8:0]_INIT_71}",
                INIT_32 => X"{[8:0]_INIT_72}",
                INIT_33 => X"{[8:0]_INIT_73}",
                INIT_34 => X"{[8:0]_INIT_74}",
                INIT_35 => X"{[8:0]_INIT_75}",
                INIT_36 => X"{[8:0]_INIT_76}",
                INIT_37 => X"{[8:0]_INIT_77}",
                INIT_38 => X"{[8:0]_INIT_78}",
                INIT_39 => X"{[8:0]_INIT_79}",
                INIT_3A => X"{[8:0]_INIT_7A}",
                INIT_3B => X"{[8:0]_INIT_7B}",
                INIT_3C => X"{[8:0]_INIT_7C}",
                INIT_3D => X"{[8:0]_INIT_7D}",
                INIT_3E => X"{[8:0]_INIT_7E}",
                INIT_3F => X"{[8:0]_INIT_7F}",
               INITP_00 => X"{[8:0]_INITP_08}",
               INITP_01 => X"{[8:0]_INITP_09}",
               INITP_02 => X"{[8:0]_INITP_0A}",
               INITP_03 => X"{[8:0]_INITP_0B}",
               INITP_04 => X"{[8:0]_INITP_0C}",
               INITP_05 => X"{[8:0]_INITP_0D}",
               INITP_06 => X"{[8:0]_INITP_0E}",
               INITP_07 => X"{[8:0]_INITP_0F}")
  port map(  ADDRA => address_a,
               ENA => enable,
              CLKA => clk,
               DOA => data_out_a_hl(31 downto 0),
              DOPA => data_out_a_hl(35 downto 32), 
               DIA => data_in_a(31 downto 0),
              DIPA => data_in_a(35 downto 32), 
               WEA => "0000",
            REGCEA => '0',
              RSTA => '0',
             ADDRB => address_b,
               ENB => enable_b,
              CLKB => clk_b,
               DOB => data_out_b_hl(31 downto 0),
              DOPB => data_out_b_hl(35 downto 32), 
               DIB => data_in_b_hl(31 downto 0),
              DIPB => data_in_b_hl(35 downto 32), 
               WEB => we_b,
            REGCEB => '0',
              RSTB => '0');
  --
  kcpsm6_rom_hh: RAMB16BWER
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
                INIT_00 => X"{[17:9]_INIT_40}",
                INIT_01 => X"{[17:9]_INIT_41}",
                INIT_02 => X"{[17:9]_INIT_42}",
                INIT_03 => X"{[17:9]_INIT_43}",
                INIT_04 => X"{[17:9]_INIT_44}",
                INIT_05 => X"{[17:9]_INIT_45}",
                INIT_06 => X"{[17:9]_INIT_46}",
                INIT_07 => X"{[17:9]_INIT_47}",
                INIT_08 => X"{[17:9]_INIT_48}",
                INIT_09 => X"{[17:9]_INIT_49}",
                INIT_0A => X"{[17:9]_INIT_4A}",
                INIT_0B => X"{[17:9]_INIT_4B}",
                INIT_0C => X"{[17:9]_INIT_4C}",
                INIT_0D => X"{[17:9]_INIT_4D}",
                INIT_0E => X"{[17:9]_INIT_4E}",
                INIT_0F => X"{[17:9]_INIT_4F}",
                INIT_10 => X"{[17:9]_INIT_50}",
                INIT_11 => X"{[17:9]_INIT_51}",
                INIT_12 => X"{[17:9]_INIT_52}",
                INIT_13 => X"{[17:9]_INIT_53}",
                INIT_14 => X"{[17:9]_INIT_54}",
                INIT_15 => X"{[17:9]_INIT_55}",
                INIT_16 => X"{[17:9]_INIT_56}",
                INIT_17 => X"{[17:9]_INIT_57}",
                INIT_18 => X"{[17:9]_INIT_58}",
                INIT_19 => X"{[17:9]_INIT_59}",
                INIT_1A => X"{[17:9]_INIT_5A}",
                INIT_1B => X"{[17:9]_INIT_5B}",
                INIT_1C => X"{[17:9]_INIT_5C}",
                INIT_1D => X"{[17:9]_INIT_5D}",
                INIT_1E => X"{[17:9]_INIT_5E}",
                INIT_1F => X"{[17:9]_INIT_5F}",
                INIT_20 => X"{[17:9]_INIT_60}",
                INIT_21 => X"{[17:9]_INIT_61}",
                INIT_22 => X"{[17:9]_INIT_62}",
                INIT_23 => X"{[17:9]_INIT_63}",
                INIT_24 => X"{[17:9]_INIT_64}",
                INIT_25 => X"{[17:9]_INIT_65}",
                INIT_26 => X"{[17:9]_INIT_66}",
                INIT_27 => X"{[17:9]_INIT_67}",
                INIT_28 => X"{[17:9]_INIT_68}",
                INIT_29 => X"{[17:9]_INIT_69}",
                INIT_2A => X"{[17:9]_INIT_6A}",
                INIT_2B => X"{[17:9]_INIT_6B}",
                INIT_2C => X"{[17:9]_INIT_6C}",
                INIT_2D => X"{[17:9]_INIT_6D}",
                INIT_2E => X"{[17:9]_INIT_6E}",
                INIT_2F => X"{[17:9]_INIT_6F}",
                INIT_30 => X"{[17:9]_INIT_70}",
                INIT_31 => X"{[17:9]_INIT_71}",
                INIT_32 => X"{[17:9]_INIT_72}",
                INIT_33 => X"{[17:9]_INIT_73}",
                INIT_34 => X"{[17:9]_INIT_74}",
                INIT_35 => X"{[17:9]_INIT_75}",
                INIT_36 => X"{[17:9]_INIT_76}",
                INIT_37 => X"{[17:9]_INIT_77}",
                INIT_38 => X"{[17:9]_INIT_78}",
                INIT_39 => X"{[17:9]_INIT_79}",
                INIT_3A => X"{[17:9]_INIT_7A}",
                INIT_3B => X"{[17:9]_INIT_7B}",
                INIT_3C => X"{[17:9]_INIT_7C}",
                INIT_3D => X"{[17:9]_INIT_7D}",
                INIT_3E => X"{[17:9]_INIT_7E}",
                INIT_3F => X"{[17:9]_INIT_7F}",
               INITP_00 => X"{[17:9]_INITP_08}",
               INITP_01 => X"{[17:9]_INITP_09}",
               INITP_02 => X"{[17:9]_INITP_0A}",
               INITP_03 => X"{[17:9]_INITP_0B}",
               INITP_04 => X"{[17:9]_INITP_0C}",
               INITP_05 => X"{[17:9]_INITP_0D}",
               INITP_06 => X"{[17:9]_INITP_0E}",
               INITP_07 => X"{[17:9]_INITP_0F}")
  port map(  ADDRA => address_a,
               ENA => enable,
              CLKA => clk,
               DOA => data_out_a_hh(31 downto 0),
              DOPA => data_out_a_hh(35 downto 32), 
               DIA => data_in_a(31 downto 0),
              DIPA => data_in_a(35 downto 32), 
               WEA => "0000",
            REGCEA => '0',
              RSTA => '0',
             ADDRB => address_b,
               ENB => enable_b,
              CLKB => clk_b,
               DOB => data_out_b_hh(31 downto 0),
              DOPB => data_out_b_hh(35 downto 32), 
               DIB => data_in_b_hh(31 downto 0),
              DIPB => data_in_b_hh(35 downto 32), 
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
