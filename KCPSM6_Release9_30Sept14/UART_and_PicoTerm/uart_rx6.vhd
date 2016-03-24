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
-- UART Receiver with integral 16 byte FIFO buffer
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
entity uart_rx6 is
  Port (           serial_in : in std_logic;
                en_16_x_baud : in std_logic;
                    data_out : out std_logic_vector(7 downto 0);
                 buffer_read : in std_logic;
         buffer_data_present : out std_logic;
            buffer_half_full : out std_logic;
                 buffer_full : out std_logic;
                buffer_reset : in std_logic;
                         clk : in std_logic);
  end uart_rx6;
--
-------------------------------------------------------------------------------------------
--
-- Start of Main Architecture for uart_rx6
--	 
architecture low_level_definition of uart_rx6 is
--
-------------------------------------------------------------------------------------------
--
-- Signals used in uart_rx6
--
-------------------------------------------------------------------------------------------
--
signal      pointer_value : std_logic_vector(3 downto 0);
signal            pointer : std_logic_vector(3 downto 0);
signal         en_pointer : std_logic;
signal               zero : std_logic;
signal           full_int : std_logic;
signal data_present_value : std_logic;
signal   data_present_int : std_logic;
signal       sample_value : std_logic;
signal             sample : std_logic;
signal   sample_dly_value : std_logic;
signal         sample_dly : std_logic;
signal     stop_bit_value : std_logic;
signal           stop_bit : std_logic;
signal         data_value : std_logic_vector(7 downto 0);
signal               data : std_logic_vector(7 downto 0);
signal          run_value : std_logic;
signal                run : std_logic;
signal    start_bit_value : std_logic;
signal          start_bit : std_logic;
signal          div_value : std_logic_vector(3 downto 0);
signal                div : std_logic_vector(3 downto 0);
signal          div_carry : std_logic;
signal sample_input_value : std_logic;
signal       sample_input : std_logic;
signal buffer_write_value : std_logic;
signal       buffer_write : std_logic;
--
-------------------------------------------------------------------------------------------
--
-- Attributes to guide mapping of logic into Slices.
-------------------------------------------------------------------------------------------
--
--
attribute hblknm : string; 
attribute hblknm of      pointer3_lut : label is "uart_rx6_1";
attribute hblknm of     pointer3_flop : label is "uart_rx6_1";
attribute hblknm of      pointer2_lut : label is "uart_rx6_1";
attribute hblknm of     pointer2_flop : label is "uart_rx6_1";
attribute hblknm of     pointer01_lut : label is "uart_rx6_1";
attribute hblknm of     pointer1_flop : label is "uart_rx6_1";
attribute hblknm of     pointer0_flop : label is "uart_rx6_1";
attribute hblknm of  data_present_lut : label is "uart_rx6_1";
attribute hblknm of data_present_flop : label is "uart_rx6_1";
--
attribute hblknm of        data01_lut : label is "uart_rx6_2";
attribute hblknm of        data0_flop : label is "uart_rx6_2";
attribute hblknm of        data1_flop : label is "uart_rx6_2";
attribute hblknm of        data23_lut : label is "uart_rx6_2";
attribute hblknm of        data2_flop : label is "uart_rx6_2";
attribute hblknm of        data3_flop : label is "uart_rx6_2";
attribute hblknm of        data45_lut : label is "uart_rx6_2";
attribute hblknm of        data4_flop : label is "uart_rx6_2";
attribute hblknm of        data5_flop : label is "uart_rx6_2";
attribute hblknm of        data67_lut : label is "uart_rx6_2";
attribute hblknm of        data6_flop : label is "uart_rx6_2";
attribute hblknm of        data7_flop : label is "uart_rx6_2";
--
attribute hblknm of         div01_lut : label is "uart_rx6_3";
attribute hblknm of         div23_lut : label is "uart_rx6_3";
attribute hblknm of         div0_flop : label is "uart_rx6_3";
attribute hblknm of         div1_flop : label is "uart_rx6_3";
attribute hblknm of         div2_flop : label is "uart_rx6_3";
attribute hblknm of         div3_flop : label is "uart_rx6_3";
attribute hblknm of  sample_input_lut : label is "uart_rx6_3";
attribute hblknm of sample_input_flop : label is "uart_rx6_3";
attribute hblknm of          full_lut : label is "uart_rx6_3";
--
attribute hblknm of        sample_lut : label is "uart_rx6_4";
attribute hblknm of       sample_flop : label is "uart_rx6_4";
attribute hblknm of   sample_dly_flop : label is "uart_rx6_4";
attribute hblknm of      stop_bit_lut : label is "uart_rx6_4";
attribute hblknm of     stop_bit_flop : label is "uart_rx6_4";
attribute hblknm of buffer_write_flop : label is "uart_rx6_4";
attribute hblknm of     start_bit_lut : label is "uart_rx6_4";
attribute hblknm of    start_bit_flop : label is "uart_rx6_4";
attribute hblknm of           run_lut : label is "uart_rx6_4";
attribute hblknm of          run_flop : label is "uart_rx6_4";
--
--
-------------------------------------------------------------------------------------------
--
-- Start of uart_rx6 circuit description
--
-------------------------------------------------------------------------------------------
--	
begin

  -- SRL16E data storage

  data_width_loop: for i in 0 to 7 generate
    attribute hblknm : string; 
    attribute hblknm of  storage_srl : label is "uart_rx6_5";

  begin

    storage_srl: SRL16E
    generic map (INIT => X"0000")
    port map(   D => data(i),
               CE => buffer_write,
              CLK => clk,
               A0 => pointer(0),
               A1 => pointer(1),
               A2 => pointer(2),
               A3 => pointer(3),
                Q => data_out(i) );

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

  sample_lut: LUT6_2
  generic map (INIT => X"CCF00000AACC0000")
  port map( I0 => serial_in,
            I1 => sample,
            I2 => sample_dly,
            I3 => en_16_x_baud,
            I4 => '1',
            I5 => '1',
            O5 => sample_value,
            O6 => sample_dly_value);

  sample_flop: FD
  port map (  D => sample_value,
              Q => sample,
              C => clk);

  sample_dly_flop: FD
  port map (  D => sample_dly_value,
              Q => sample_dly,
              C => clk);

  stop_bit_lut: LUT6_2
  generic map (INIT => X"CAFFCAFF0000C0C0")
  port map( I0 => stop_bit,
            I1 => sample,
            I2 => sample_input,
            I3 => run,
            I4 => data(0),
            I5 => '1',
            O5 => buffer_write_value,
            O6 => stop_bit_value);

  buffer_write_flop: FD
  port map (  D => buffer_write_value,
              Q => buffer_write,
              C => clk);

  stop_bit_flop: FD
  port map (  D => stop_bit_value,
              Q => stop_bit,
              C => clk);

  data01_lut: LUT6_2
  generic map (INIT => X"F0CCFFFFCCAAFFFF")
  port map( I0 => data(0),
            I1 => data(1),
            I2 => data(2),
            I3 => sample_input,
            I4 => run,
            I5 => '1',
            O5 => data_value(0),
            O6 => data_value(1));

  data0_flop: FD
  port map (  D => data_value(0),
              Q => data(0),
              C => clk);

  data1_flop: FD
  port map (  D => data_value(1),
              Q => data(1),
              C => clk);


  data23_lut: LUT6_2
  generic map (INIT => X"F0CCFFFFCCAAFFFF")
  port map( I0 => data(2),
            I1 => data(3),
            I2 => data(4),
            I3 => sample_input,
            I4 => run,
            I5 => '1',
            O5 => data_value(2),
            O6 => data_value(3));

  data2_flop: FD
  port map (  D => data_value(2),
              Q => data(2),
              C => clk);

  data3_flop: FD
  port map (  D => data_value(3),
              Q => data(3),
              C => clk);

  data45_lut: LUT6_2
  generic map (INIT => X"F0CCFFFFCCAAFFFF")
  port map( I0 => data(4),
            I1 => data(5),
            I2 => data(6),
            I3 => sample_input,
            I4 => run,
            I5 => '1',
            O5 => data_value(4),
            O6 => data_value(5));

  data4_flop: FD
  port map (  D => data_value(4),
              Q => data(4),
              C => clk);

  data5_flop: FD
  port map (  D => data_value(5),
              Q => data(5),
              C => clk);

  data67_lut: LUT6_2
  generic map (INIT => X"F0CCFFFFCCAAFFFF")
  port map( I0 => data(6),
            I1 => data(7),
            I2 => stop_bit,
            I3 => sample_input,
            I4 => run,
            I5 => '1',
            O5 => data_value(6),
            O6 => data_value(7));

  data6_flop: FD
  port map (  D => data_value(6),
              Q => data(6),
              C => clk);

  data7_flop: FD
  port map (  D => data_value(7),
              Q => data(7),
              C => clk);

  run_lut: LUT6
  generic map (INIT => X"2F2FAFAF0000FF00")
  port map( I0 => data(0),
            I1 => start_bit,
            I2 => sample_input,
            I3 => sample_dly,
            I4 => sample,
            I5 => run,
             O => run_value);                     

  run_flop: FD
  port map (  D => run_value,
              Q => run,
              C => clk);

  start_bit_lut: LUT6
  generic map (INIT => X"222200F000000000")
  port map( I0 => start_bit,
            I1 => sample_input,
            I2 => sample_dly,
            I3 => sample,
            I4 => run,
            I5 => '1',
             O => start_bit_value);                     

  start_bit_flop: FD
  port map (  D => start_bit_value,
              Q => start_bit,
              C => clk);

  div01_lut: LUT6_2
  generic map (INIT => X"6C0000005A000000")
  port map( I0 => div(0),
            I1 => div(1),
            I2 => en_16_x_baud,
            I3 => run,
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
  generic map (INIT => X"6CCC00005AAA0000")
  port map( I0 => div(2),
            I1 => div(3),
            I2 => div_carry,
            I3 => en_16_x_baud,
            I4 => run,
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

  sample_input_lut: LUT6_2
  generic map (INIT => X"0080000088888888")
  port map( I0 => div(0),
            I1 => div(1),
            I2 => div(2),
            I3 => div(3),
            I4 => en_16_x_baud,
            I5 => '1',
            O5 => div_carry,
            O6 => sample_input_value);

  sample_input_flop: FD
  port map (  D => sample_input_value,
              Q => sample_input,
              C => clk);


  -- assign internal signals to outputs

  buffer_full <= full_int;  
  buffer_half_full <= pointer(3);  
  buffer_data_present <= data_present_int;

end low_level_definition;

-------------------------------------------------------------------------------------------
--
-- END OF FILE uart_rx6.vhd
--
-------------------------------------------------------------------------------------------


