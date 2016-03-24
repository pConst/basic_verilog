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

Production template for a 0.25K program (256 instructions) for KCPSM6 in a Spartan-6, 
Virtex-6 or 7-Series device using 18 Slices.

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
-- Production definition of a 0.25K program (256 instructions) for KCPSM6 in a Spartan-6,  
-- Virtex-6 or 7-Series device device using 18 Slices. 
--
-- Note: The full 12-bit KCPSM6 address is connected but only the lower 8-bits will be 
--       employed. Likewise the 'bram_enable' should still be connected to 'enable'. 
--       This minimises the changes required to the hardware description of a design 
--       when moving between different memory types and selecting different sizes.
--
--            program_rom: your_program
--              port map(     address => address,      
--                        instruction => instruction,
--                             enable => bram_enable,
--                                clk => clk);
--
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
signal rom_value : std_logic_vector(17 downto 0);
--
begin
  --
  instruction_bit: for i in 0 to 17 generate
  begin
    --
    kcpsm6_rom_flop: FDRE
    port map (  D => rom_value(i),
                Q => instruction(i),
               CE => enable,
                R => address(8+(i/5)),
                C => clk);
    --
  end generate instruction_bit;
  --
  --
  kcpsm6_rom0: ROM256X1
  generic map( INIT => X"{INIT256_0}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(0));
  --
  kcpsm6_rom1: ROM256X1
  generic map( INIT => X"{INIT256_1}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(1));
  --
  kcpsm6_rom2: ROM256X1
  generic map( INIT => X"{INIT256_2}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(2));
  --
  kcpsm6_rom3: ROM256X1
  generic map( INIT => X"{INIT256_3}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(3));
  --
  kcpsm6_rom4: ROM256X1
  generic map( INIT => X"{INIT256_4}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(4));
  --
  kcpsm6_rom5: ROM256X1
  generic map( INIT => X"{INIT256_5}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(5));
  --
  kcpsm6_rom6: ROM256X1
  generic map( INIT => X"{INIT256_6}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(6));
  --
  kcpsm6_rom7: ROM256X1
  generic map( INIT => X"{INIT256_7}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(7));
  --
  kcpsm6_rom8: ROM256X1
  generic map( INIT => X"{INIT256_8}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(8));
  --
  kcpsm6_rom9: ROM256X1
  generic map( INIT => X"{INIT256_9}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(9));
  --
  kcpsm6_rom10: ROM256X1
  generic map( INIT => X"{INIT256_10}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(10));
  --
  kcpsm6_rom11: ROM256X1
  generic map( INIT => X"{INIT256_11}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(11));
  --
  kcpsm6_rom12: ROM256X1
  generic map( INIT => X"{INIT256_12}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(12));
  --
  kcpsm6_rom13: ROM256X1
  generic map( INIT => X"{INIT256_13}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(13));
  --
  kcpsm6_rom14: ROM256X1
  generic map( INIT => X"{INIT256_14}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(14));
  --
  kcpsm6_rom15: ROM256X1
  generic map( INIT => X"{INIT256_15}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(15));
  --
  kcpsm6_rom16: ROM256X1
  generic map( INIT => X"{INIT256_16}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(16));
  --
  kcpsm6_rom17: ROM256X1
  generic map( INIT => X"{INIT256_17}")
  port map( A0 => address(0),
            A1 => address(1),
            A2 => address(2),
            A3 => address(3),
            A4 => address(4),
            A5 => address(5),
            A6 => address(6),
            A7 => address(7),
             O => rom_value(17));
  --
  --
end low_level_definition;
--
------------------------------------------------------------------------------------
--
-- END OF FILE {name}.vhd
--
------------------------------------------------------------------------------------
