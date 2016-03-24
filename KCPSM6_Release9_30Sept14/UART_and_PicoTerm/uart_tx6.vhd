--
-------------------------------------------------------------------------------------------
-- Copyright © 2011, Xilinx, Inc.
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
-- UART Transmitter with integral 16 byte FIFO buffer
--
-- 8 bit, no parity, 1 stop bit
--
-- This module was made for use with Spartan-6 Generation Devices and is also ideally 
-- suited for use with Virtex-6 and 7-Series devices.
--
-- Version 1 - 31st March 2011.
--
-- Ken Chapman
-- Xilinx Ltd
-- Benchmark House
-- 203 Brooklands Road
-- Weybridge
-- Surrey KT13 ORH
-- United Kingdom
--
-- chapman@xilinx.com
--
-------------------------------------------------------------------------------------------
--
-- Format of this file.
--
-- The module defines the implementation of the logic using Xilinx primitives.
-- These ensure predictable synthesis results and maximise the density of the 
-- implementation. The Unisim Library is used to define Xilinx primitives. It is also 
-- used during simulation. 
-- The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
-- 
-------------------------------------------------------------------------------------------
--
-- Library declarations
--
-- Standard IEEE libraries
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
use unisim.vcomponents.all;
--
-------------------------------------------------------------------------------------------
--
-- Main Entity for 
--
entity uart_tx6 is
  Port (             data_in : in std_logic_vector(7 downto 0);
                en_16_x_baud : in std_logic;
                  serial_out : out std_logic;
                buffer_write : in std_logic;
         buffer_data_present : out std_logic;
            buffer_half_full : out std_logic;
                 buffer_full : out std_logic;
                buffer_reset : in std_logic;
                         clk : in std_logic);
  end uart_tx6;
--
-------------------------------------------------------------------------------------------
--
-- Start of Main Architecture for uart_tx6
--	 
architecture low_level_definition of uart_tx6 is
--
-------------------------------------------------------------------------------------------
--
-- Signals used in uart_tx6
--
-------------------------------------------------------------------------------------------
--
signal         store_data : std_logic_vector(7 downto 0);
signal               data : std_logic_vector(7 downto 0);
signal      pointer_value : std_logic_vector(3 downto 0);
signal            pointer : std_logic_vector(3 downto 0);
signal         en_pointer : std_logic;
signal               zero : std_logic;
signal           full_int : std_logic;
signal data_present_value : std_logic;
signal   data_present_int : std_logic;
signal           sm_value : std_logic_vector(3 downto 0);
signal                 sm : std_logic_vector(3 downto 0);
signal          div_value : std_logic_vector(3 downto 0);
signal                div : std_logic_vector(3 downto 0);
signal           lsb_data : std_logic;
signal           msb_data : std_logic;
signal           last_bit : std_logic;
signal        serial_data : std_logic;
signal         next_value : std_logic;
signal           next_bit : std_logic;
signal  buffer_read_value : std_logic;
signal        buffer_read : std_logic;
--
-------------------------------------------------------------------------------------------
--
-- Attributes to guide mapping of logic into Slices.
-------------------------------------------------------------------------------------------
--
--
attribute hblknm : string; 
attribute hblknm of      pointer3_lut : label is "uart_tx6_1";
attribute hblknm of     pointer3_flop : label is "uart_tx6_1";
attribute hblknm of      pointer2_lut : label is "uart_tx6_1";
attribute hblknm of     pointer2_flop : label is "uart_tx6_1";
attribute hblknm of     pointer01_lut : label is "uart_tx6_1";
attribute hblknm of     pointer1_flop : label is "uart_tx6_1";
attribute hblknm of     pointer0_flop : label is "uart_tx6_1";
attribute hblknm of  data_present_lut : label is "uart_tx6_1";
attribute hblknm of data_present_flop : label is "uart_tx6_1";
--
attribute hblknm of           sm0_lut : label is "uart_tx6_2";
attribute hblknm of          sm0_flop : label is "uart_tx6_2";
attribute hblknm of           sm1_lut : label is "uart_tx6_2";
attribute hblknm of          sm1_flop : label is "uart_tx6_2";
attribute hblknm of           sm2_lut : label is "uart_tx6_2";
attribute hblknm of          sm2_flop : label is "uart_tx6_2";
attribute hblknm of           sm3_lut : label is "uart_tx6_2";
attribute hblknm of          sm3_flop : label is "uart_tx6_2";
--
attribute hblknm of         div01_lut : label is "uart_tx6_3";
attribute hblknm of         div23_lut : label is "uart_tx6_3";
attribute hblknm of         div0_flop : label is "uart_tx6_3";
attribute hblknm of         div1_flop : label is "uart_tx6_3";
attribute hblknm of         div2_flop : label is "uart_tx6_3";
attribute hblknm of         div3_flop : label is "uart_tx6_3";
attribute hblknm of          next_lut : label is "uart_tx6_3";
attribute hblknm of         next_flop : label is "uart_tx6_3";
attribute hblknm of         read_flop : label is "uart_tx6_3";
--
attribute hblknm of      lsb_data_lut : label is "uart_tx6_4";
attribute hblknm of      msb_data_lut : label is "uart_tx6_4";
attribute hblknm of        serial_lut : label is "uart_tx6_4";
attribute hblknm of       serial_flop : label is "uart_tx6_4";
attribute hblknm of          full_lut : label is "uart_tx6_4";
--
--
-------------------------------------------------------------------------------------------
--
-- Start of uart_tx6 circuit description
--
-------------------------------------------------------------------------------------------
--	
begin

  -- SRL16E data storage

  data_width_loop: for i in 0 to 7 generate
    attribute hblknm : string; 
    attribute hblknm of  storage_srl : label is "uart_tx6_5";
    attribute hblknm of storage_flop : label is "uart_tx6_5";

  begin

    storage_srl: SRL16E
    generic map (INIT => X"0000")
    port map(   D => data_in(i),
               CE => buffer_write,
              CLK => clk,
               A0 => pointer(0),
               A1 => pointer(1),
               A2 => pointer(2),
               A3 => pointer(3),
                Q => store_data(i) );

    storage_flop: FD
    port map (  D => store_data(i),
                Q => data(i),
                C => clk);

  end generate data_width_loop;
 

  pointer3_lut: LUT6
  generic map (INIT => X"FF00FE00FF80FF00")
  port map( I0 => pointer(0),
            I1 => pointer(1),
            I2 => pointer(2),
            I3 => pointer(3),
            I4 => buffer_write,
            I5 => buffer_read,
             O => pointer_value(3));                     

  pointer3_flop: FDR
  port map (  D => pointer_value(3),
              Q => pointer(3),
              R => buffer_reset,
              C => clk);

  pointer2_lut: LUT6
  generic map (INIT => X"F0F0E1E0F878F0F0")
  port map( I0 => pointer(0),
            I1 => pointer(1),
            I2 => pointer(2),
            I3 => pointer(3),
            I4 => buffer_write,
            I5 => buffer_read,
             O => pointer_value(2));                     

  pointer2_flop: FDR
  port map (  D => pointer_value(2),
              Q => pointer(2),
              R => buffer_reset,
              C => clk);


  pointer01_lut: LUT6_2
  generic map (INIT => X"CC9060CCAA5050AA")
  port map( I0 => pointer(0),
            I1 => pointer(1),
            I2 => en_pointer,
            I3 => buffer_write,
            I4 => buffer_read,
            I5 => '1',
            O5 => pointer_value(0),
            O6 => pointer_value(1));

  pointer1_flop: FDR
  port map (  D => pointer_value(1),
              Q => pointer(1),
              R => buffer_reset,
              C => clk);

  pointer0_flop: FDR
  port map (  D => pointer_value(0),
              Q => pointer(0),
              R => buffer_reset,
              C => clk);

  data_present_lut: LUT6_2
  generic map (INIT => X"F4FCF4FC040004C0")
  port map( I0 => zero,
            I1 => data_present_int,
            I2 => buffer_write,
            I3 => buffer_read,
            I4 => full_int,
            I5 => '1',
            O5 => en_pointer,
            O6 => data_present_value);                     

  data_present_flop: FDR
  port map (  D => data_present_value,
              Q => data_present_int,
              R => buffer_reset,
              C => clk);

  full_lut: LUT6_2
  generic map (INIT => X"0001000080000000")
  port map( I0 => pointer(0),
            I1 => pointer(1),
            I2 => pointer(2),
            I3 => pointer(3),
            I4 => '1',
            I5 => '1',
            O5 => full_int,
            O6 => zero);

  lsb_data_lut: LUT6
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data(0),
            I1 => data(1),
            I2 => data(2),
            I3 => data(3),
            I4 => sm(0),
            I5 => sm(1),
             O => lsb_data);                     


  msb_data_lut: LUT6
  generic map (INIT => X"FF00F0F0CCCCAAAA")
  port map( I0 => data(4),
            I1 => data(5),
            I2 => data(6),
            I3 => data(7),
            I4 => sm(0),
            I5 => sm(1),
             O => msb_data);                     

  serial_lut: LUT6_2
  generic map (INIT => X"CFAACC0F0FFFFFFF")
  port map( I0 => lsb_data,
            I1 => msb_data,
            I2 => sm(1),
            I3 => sm(2),
            I4 => sm(3),
            I5 => '1',
            O5 => last_bit,
            O6 => serial_data);

  serial_flop: FD
  port map (  D => serial_data,
              Q => serial_out,
              C => clk);

  sm0_lut: LUT6
  generic map (INIT => X"85500000AAAAAAAA")
  port map( I0 => sm(0),
            I1 => sm(1),
            I2 => sm(2),
            I3 => sm(3),
            I4 => data_present_int,
            I5 => next_bit,
             O => sm_value(0));                     

  sm0_flop: FD
  port map (  D => sm_value(0),
              Q => sm(0),
              C => clk);

  sm1_lut: LUT6
  generic map (INIT => X"26610000CCCCCCCC")
  port map( I0 => sm(0),
            I1 => sm(1),
            I2 => sm(2),
            I3 => sm(3),
            I4 => data_present_int,
            I5 => next_bit,
             O => sm_value(1));                     

  sm1_flop: FD
  port map (  D => sm_value(1),
              Q => sm(1),
              C => clk);

  sm2_lut: LUT6
  generic map (INIT => X"88700000F0F0F0F0")
  port map( I0 => sm(0),
            I1 => sm(1),
            I2 => sm(2),
            I3 => sm(3),
            I4 => data_present_int,
            I5 => next_bit,
             O => sm_value(2));                     

  sm2_flop: FD
  port map (  D => sm_value(2),
              Q => sm(2),
              C => clk);

  sm3_lut: LUT6
  generic map (INIT => X"87440000FF00FF00")
  port map( I0 => sm(0),
            I1 => sm(1),
            I2 => sm(2),
            I3 => sm(3),
            I4 => data_present_int,
            I5 => next_bit,
             O => sm_value(3));                     

  sm3_flop: FD
  port map (  D => sm_value(3),
              Q => sm(3),
              C => clk);


  div01_lut: LUT6_2
  generic map (INIT => X"6C0000005A000000")
  port map( I0 => div(0),
            I1 => div(1),
            I2 => en_16_x_baud,
            I3 => '1',
            I4 => '1',
            I5 => '1',
            O5 => div_value(0),
            O6 => div_value(1));

  div0_flop: FD
  port map (  D => div_value(0),
              Q => div(0),
              C => clk);

  div1_flop: FD
  port map (  D => div_value(1),
              Q => div(1),
              C => clk);

  div23_lut: LUT6_2
  generic map (INIT => X"7F80FF007878F0F0")
  port map( I0 => div(0),
            I1 => div(1),
            I2 => div(2),
            I3 => div(3),
            I4 => en_16_x_baud,
            I5 => '1',
            O5 => div_value(2),
            O6 => div_value(3));

  div2_flop: FD
  port map (  D => div_value(2),
              Q => div(2),
              C => clk);

  div3_flop: FD
  port map (  D => div_value(3),
              Q => div(3),
              C => clk);

  next_lut: LUT6_2
  generic map (INIT => X"0000000080000000")
  port map( I0 => div(0),
            I1 => div(1),
            I2 => div(2),
            I3 => div(3),
            I4 => en_16_x_baud,
            I5 => last_bit,
            O5 => next_value,
            O6 => buffer_read_value);

  next_flop: FD
  port map (  D => next_value,
              Q => next_bit,
              C => clk);

  read_flop: FD
  port map (  D => buffer_read_value,
              Q => buffer_read,
              C => clk);


  -- assign internal signals to outputs

  buffer_full <= full_int;  
  buffer_half_full <= pointer(3);  
  buffer_data_present <= data_present_int;

end low_level_definition;

-------------------------------------------------------------------------------------------
--
-- END OF FILE uart_tx6.vhd
--
-------------------------------------------------------------------------------------------


