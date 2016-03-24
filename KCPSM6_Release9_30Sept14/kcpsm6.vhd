--
-------------------------------------------------------------------------------------------
-- Copyright © 2010-2014, Xilinx, Inc.
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
-- KCPSM6 - PicoBlaze for Spartan-6 and Virtex-6 devices.
--
-- Start of design entry - 14th May 2010.
--         Alpha Version - 20th July 2010.
--           Version 1.0 - 30th September 2010. 
--           Version 1.1 - 9th February 2011. 
--                         Correction to parity computation logic.
--           Version 1.2 - 4th October 2012. 
--                         Addition of WebTalk information.
--           Version 1.3 - 21st May 2014. 
--                         Disassembly of 'STAR sX, kk' instruction added to the simulation
--                         code. No changes to functionality or the physical implementation.
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
-- These ensure predictable synthesis results and maximise the density of the implementation. 
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
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
-- Main Entity for kcpsm6
--
entity kcpsm6 is
  generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                  interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
           scratch_pad_memory_size : integer := 64);
  port (                   address : out std_logic_vector(11 downto 0);
                       instruction : in std_logic_vector(17 downto 0);
                       bram_enable : out std_logic;
                           in_port : in std_logic_vector(7 downto 0);
                          out_port : out std_logic_vector(7 downto 0);
                           port_id : out std_logic_vector(7 downto 0);
                      write_strobe : out std_logic;
                    k_write_strobe : out std_logic;
                       read_strobe : out std_logic;
                         interrupt : in std_logic;
                     interrupt_ack : out std_logic;
                             sleep : in std_logic;
                             reset : in std_logic;
                               clk : in std_logic);
  end kcpsm6;
--
-------------------------------------------------------------------------------------------
--
-- Start of Main Architecture for kcpsm6
--	 
architecture low_level_definition of kcpsm6 is
--
-------------------------------------------------------------------------------------------
--
-- Signals used in kcpsm6
--
-------------------------------------------------------------------------------------------
--
-- State Machine and Interrupt
--	 
signal          t_state_value : std_logic_vector(2 downto 1);
signal                t_state : std_logic_vector(2 downto 1);
signal              run_value : std_logic;
signal                    run : std_logic;
signal   internal_reset_value : std_logic;
signal         internal_reset : std_logic;
signal             sync_sleep : std_logic;
signal        int_enable_type : std_logic;
signal interrupt_enable_value : std_logic;
signal       interrupt_enable : std_logic;
signal         sync_interrupt : std_logic;
signal active_interrupt_value : std_logic;
signal       active_interrupt : std_logic;

--
-- Arithmetic and Logical Functions
--	 
signal      arith_logical_sel : std_logic_vector(2 downto 0);
signal         arith_carry_in : std_logic;
signal      arith_carry_value : std_logic;
signal            arith_carry : std_logic;
signal     half_arith_logical : std_logic_vector(7 downto 0);
signal     logical_carry_mask : std_logic_vector(7 downto 0);
signal    carry_arith_logical : std_logic_vector(7 downto 0);
signal    arith_logical_value : std_logic_vector(7 downto 0);
signal   arith_logical_result : std_logic_vector(7 downto 0);
--
-- Shift and Rotate Functions
--	 
signal     shift_rotate_value : std_logic_vector(7 downto 0);
signal    shift_rotate_result : std_logic_vector(7 downto 0);
signal           shift_in_bit : std_logic;
--
-- ALU structure
--	 
signal             alu_result : std_logic_vector(7 downto 0);
signal      alu_mux_sel_value : std_logic_vector(1 downto 0);
signal            alu_mux_sel : std_logic_vector(1 downto 0);
--
-- Strobes
--	
signal            strobe_type : std_logic;
signal     write_strobe_value : std_logic;
signal   k_write_strobe_value : std_logic;
signal      read_strobe_value : std_logic;
--
-- Flags
--	
signal       flag_enable_type : std_logic;
signal      flag_enable_value : std_logic;
signal            flag_enable : std_logic; 
signal           lower_parity : std_logic;
signal       lower_parity_sel : std_logic;
signal     carry_lower_parity : std_logic;
signal           upper_parity : std_logic;
signal                 parity : std_logic;
signal      shift_carry_value : std_logic;
signal            shift_carry : std_logic;
signal       carry_flag_value : std_logic;
signal             carry_flag : std_logic;

signal    use_zero_flag_value : std_logic;
signal          use_zero_flag : std_logic;
signal    drive_carry_in_zero : std_logic;
signal          carry_in_zero : std_logic;
signal             lower_zero : std_logic;
signal         lower_zero_sel : std_logic;
signal       carry_lower_zero : std_logic;
signal            middle_zero : std_logic;
signal        middle_zero_sel : std_logic;
signal      carry_middle_zero : std_logic;
signal         upper_zero_sel : std_logic;
signal        zero_flag_value : std_logic;
signal              zero_flag : std_logic;
--
-- Scratch Pad Memory
--	 
signal       spm_enable_value : std_logic;
signal             spm_enable : std_logic;
signal           spm_ram_data : std_logic_vector(7 downto 0);
signal               spm_data : std_logic_vector(7 downto 0);
--
-- Registers
--	 
signal           regbank_type : std_logic;
signal             bank_value : std_logic;
signal                   bank : std_logic;
signal          loadstar_type : std_logic;
signal         sx_addr4_value : std_logic;
signal   register_enable_type : std_logic;
signal  register_enable_value : std_logic;
signal        register_enable : std_logic;
signal                sx_addr : std_logic_vector(4 downto 0);
signal                sy_addr : std_logic_vector(4 downto 0);
signal                     sx : std_logic_vector(7 downto 0);
signal                     sy : std_logic_vector(7 downto 0);
--
-- Second Operand 
--	 
signal               sy_or_kk : std_logic_vector(7 downto 0);
--
-- Program Counter 
--	 
signal       pc_move_is_valid : std_logic;
signal              move_type : std_logic;
signal           returni_type : std_logic;
signal                pc_mode : std_logic_vector(2 downto 0);
signal        register_vector : std_logic_vector(11 downto 0);
signal                half_pc : std_logic_vector(11 downto 0);
signal               carry_pc : std_logic_vector(10 downto 0);
signal               pc_value : std_logic_vector(11 downto 0);
signal                     pc : std_logic_vector(11 downto 0);
signal              pc_vector : std_logic_vector(11 downto 0);
--
-- Program Counter Stack 
--	 
signal             push_stack : std_logic;
signal              pop_stack : std_logic;
signal           stack_memory : std_logic_vector(11 downto 0);
signal          return_vector : std_logic_vector(11 downto 0);
signal       stack_carry_flag : std_logic;
signal      shadow_carry_flag : std_logic;
signal        stack_zero_flag : std_logic;
signal      shadow_zero_value : std_logic;
signal       shadow_zero_flag : std_logic;
signal             stack_bank : std_logic;
signal            shadow_bank : std_logic;
signal              stack_bit : std_logic;
signal            special_bit : std_logic;
signal     half_pointer_value : std_logic_vector(4 downto 0);
signal     feed_pointer_value : std_logic_vector(4 downto 0);
signal    stack_pointer_carry : std_logic_vector(4 downto 0);
signal    stack_pointer_value : std_logic_vector(4 downto 0);
signal          stack_pointer : std_logic_vector(4 downto 0);
--
--
--
--**********************************************************************************
--
-- Signals between these *** lines are only made visible during simulation 
--
--synthesis translate off
--
signal kcpsm6_opcode : string(1 to 19):= "LOAD s0, s0        ";
signal kcpsm6_status : string(1 to 16):= "A,NZ,NC,ID,Reset";
signal        sim_s0 : std_logic_vector(7 downto 0);
signal        sim_s1 : std_logic_vector(7 downto 0);
signal        sim_s2 : std_logic_vector(7 downto 0);
signal        sim_s3 : std_logic_vector(7 downto 0);
signal        sim_s4 : std_logic_vector(7 downto 0);
signal        sim_s5 : std_logic_vector(7 downto 0);
signal        sim_s6 : std_logic_vector(7 downto 0);
signal        sim_s7 : std_logic_vector(7 downto 0);
signal        sim_s8 : std_logic_vector(7 downto 0);
signal        sim_s9 : std_logic_vector(7 downto 0);
signal        sim_sA : std_logic_vector(7 downto 0);
signal        sim_sB : std_logic_vector(7 downto 0);
signal        sim_sC : std_logic_vector(7 downto 0);
signal        sim_sD : std_logic_vector(7 downto 0);
signal        sim_sE : std_logic_vector(7 downto 0);
signal        sim_sF : std_logic_vector(7 downto 0);
signal     sim_spm00 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm01 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm02 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm03 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm04 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm05 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm06 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm07 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm08 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm09 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm0A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm0B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm0C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm0D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm0E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm0F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm10 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm11 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm12 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm13 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm14 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm15 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm16 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm17 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm18 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm19 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm1A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm1B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm1C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm1D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm1E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm1F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm20 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm21 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm22 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm23 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm24 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm25 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm26 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm27 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm28 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm29 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm2A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm2B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm2C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm2D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm2E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm2F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm30 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm31 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm32 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm33 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm34 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm35 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm36 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm37 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm38 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm39 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm3A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm3B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm3C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm3D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm3E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm3F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm40 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm41 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm42 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm43 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm44 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm45 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm46 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm47 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm48 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm49 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm4A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm4B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm4C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm4D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm4E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm4F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm50 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm51 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm52 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm53 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm54 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm55 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm56 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm57 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm58 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm59 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm5A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm5B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm5C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm5D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm5E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm5F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm60 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm61 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm62 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm63 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm64 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm65 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm66 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm67 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm68 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm69 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm6A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm6B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm6C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm6D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm6E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm6F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm70 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm71 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm72 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm73 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm74 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm75 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm76 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm77 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm78 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm79 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm7A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm7B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm7C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm7D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm7E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm7F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm80 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm81 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm82 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm83 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm84 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm85 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm86 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm87 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm88 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm89 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm8A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm8B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm8C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm8D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm8E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm8F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm90 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm91 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm92 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm93 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm94 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm95 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm96 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm97 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm98 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm99 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm9A : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm9B : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm9C : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm9D : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm9E : std_logic_vector(7 downto 0) := X"00";
signal     sim_spm9F : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA0 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA1 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA2 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA3 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA4 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA5 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA6 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA7 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA8 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmA9 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmAA : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmAB : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmAC : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmAD : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmAE : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmAF : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB0 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB1 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB2 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB3 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB4 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB5 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB6 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB7 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB8 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmB9 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmBA : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmBB : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmBC : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmBD : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmBE : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmBF : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC0 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC1 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC2 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC3 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC4 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC5 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC6 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC7 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC8 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmC9 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmCA : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmCB : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmCC : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmCD : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmCE : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmCF : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD0 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD1 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD2 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD3 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD4 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD5 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD6 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD7 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD8 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmD9 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmDA : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmDB : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmDC : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmDD : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmDE : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmDF : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE0 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE1 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE2 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE3 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE4 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE5 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE6 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE7 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE8 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmE9 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmEA : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmEB : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmEC : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmED : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmEE : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmEF : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF0 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF1 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF2 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF3 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF4 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF5 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF6 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF7 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF8 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmF9 : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmFA : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmFB : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmFC : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmFD : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmFE : std_logic_vector(7 downto 0) := X"00";
signal     sim_spmFF : std_logic_vector(7 downto 0) := X"00";
--
--synthesis translate on
--
--**********************************************************************************
--
--
-------------------------------------------------------------------------------------------
--
-- WebTalk Attributes
--

attribute CORE_GENERATION_INFO : string;
attribute CORE_GENERATION_INFO of low_level_definition : ARCHITECTURE IS 
    "kcpsm6,kcpsm6_v1_3,{component_name=kcpsm6}";

--
-- Attributes to guide mapping of logic into Slices.
--

attribute hblknm : string; 
attribute hblknm of                reset_lut : label is "kcpsm6_control";
attribute hblknm of                 run_flop : label is "kcpsm6_control";
attribute hblknm of      internal_reset_flop : label is "kcpsm6_control";
attribute hblknm of              t_state_lut : label is "kcpsm6_control";
attribute hblknm of            t_state1_flop : label is "kcpsm6_control";
attribute hblknm of            t_state2_flop : label is "kcpsm6_control";
attribute hblknm of     active_interrupt_lut : label is "kcpsm6_control";
attribute hblknm of    active_interrupt_flop : label is "kcpsm6_control";
attribute hblknm of            sx_addr4_flop : label is "kcpsm6_control";
attribute hblknm of        arith_carry_xorcy : label is "kcpsm6_control";
attribute hblknm of         arith_carry_flop : label is "kcpsm6_control";

attribute hblknm of           zero_flag_flop : label is "kcpsm6_flags";
attribute hblknm of          carry_flag_flop : label is "kcpsm6_flags";
attribute hblknm of           carry_flag_lut : label is "kcpsm6_flags";
attribute hblknm of           lower_zero_lut : label is "kcpsm6_flags";
attribute hblknm of          middle_zero_lut : label is "kcpsm6_flags";
attribute hblknm of           upper_zero_lut : label is "kcpsm6_flags";
attribute hblknm of          init_zero_muxcy : label is "kcpsm6_flags";
attribute hblknm of         lower_zero_muxcy : label is "kcpsm6_flags";
attribute hblknm of        middle_zero_muxcy : label is "kcpsm6_flags";
attribute hblknm of         upper_zero_muxcy : label is "kcpsm6_flags";

attribute hblknm of      int_enable_type_lut : label is "kcpsm6_decode0";
attribute hblknm of            move_type_lut : label is "kcpsm6_decode0";
attribute hblknm of     pc_move_is_valid_lut : label is "kcpsm6_decode0";
attribute hblknm of     interrupt_enable_lut : label is "kcpsm6_decode0";
attribute hblknm of    interrupt_enable_flop : label is "kcpsm6_decode0";

attribute hblknm of          alu_decode1_lut : label is "kcpsm6_decode1";
attribute hblknm of        alu_mux_sel1_flop : label is "kcpsm6_decode1";
attribute hblknm of          shift_carry_lut : label is "kcpsm6_decode1";
attribute hblknm of         shift_carry_flop : label is "kcpsm6_decode1";
attribute hblknm of        use_zero_flag_lut : label is "kcpsm6_decode1";
attribute hblknm of       use_zero_flag_flop : label is "kcpsm6_decode1";
attribute hblknm of       interrupt_ack_flop : label is "kcpsm6_decode1";
attribute hblknm of    shadow_zero_flag_flop : label is "kcpsm6_decode1";

attribute hblknm of          alu_decode0_lut : label is "kcpsm6_decode2";
attribute hblknm of        alu_mux_sel0_flop : label is "kcpsm6_decode2";
attribute hblknm of          alu_decode2_lut : label is "kcpsm6_decode2";
attribute hblknm of         lower_parity_lut : label is "kcpsm6_decode2";
attribute hblknm of             parity_muxcy : label is "kcpsm6_decode2";
attribute hblknm of         upper_parity_lut : label is "kcpsm6_decode2";
attribute hblknm of             parity_xorcy : label is "kcpsm6_decode2";
attribute hblknm of          sync_sleep_flop : label is "kcpsm6_decode2";
attribute hblknm of      sync_interrupt_flop : label is "kcpsm6_decode2";

attribute hblknm of             push_pop_lut : label is "kcpsm6_stack1";	
attribute hblknm of         regbank_type_lut : label is "kcpsm6_stack1";	
attribute hblknm of                 bank_lut : label is "kcpsm6_stack1";	
attribute hblknm of                bank_flop : label is "kcpsm6_stack1";	

attribute hblknm of register_enable_type_lut : label is "kcpsm6_strobes";	
attribute hblknm of      register_enable_lut : label is "kcpsm6_strobes";	
attribute hblknm of         flag_enable_flop : label is "kcpsm6_strobes";	
attribute hblknm of     register_enable_flop : label is "kcpsm6_strobes";	
attribute hblknm of           spm_enable_lut : label is "kcpsm6_strobes";	
attribute hblknm of      k_write_strobe_flop : label is "kcpsm6_strobes";	
attribute hblknm of          spm_enable_flop : label is "kcpsm6_strobes";	
attribute hblknm of          read_strobe_lut : label is "kcpsm6_strobes";	
attribute hblknm of        write_strobe_flop : label is "kcpsm6_strobes";	
attribute hblknm of         read_strobe_flop : label is "kcpsm6_strobes";	

attribute hblknm of            stack_ram_low : label is "kcpsm6_stack_ram0";	
attribute hblknm of   shadow_carry_flag_flop : label is "kcpsm6_stack_ram0";	
attribute hblknm of          stack_zero_flop : label is "kcpsm6_stack_ram0";	
attribute hblknm of         shadow_bank_flop : label is "kcpsm6_stack_ram0";	
attribute hblknm of           stack_bit_flop : label is "kcpsm6_stack_ram0";	
attribute hblknm of           stack_ram_high : label is "kcpsm6_stack_ram1";	

attribute hblknm of          lower_reg_banks : label is "kcpsm6_reg0";	
attribute hblknm of          upper_reg_banks : label is "kcpsm6_reg1";	
attribute hblknm of             pc_mode1_lut : label is "kcpsm6_vector1";	
attribute hblknm of             pc_mode2_lut : label is "kcpsm6_vector1";	

--
-------------------------------------------------------------------------------------------
--	
-- Start of kcpsm6 circuit description
--
-- Summary of all primitives defined.
--
--     29 x LUT6             79 LUTs (plus 1 LUT will be required to form a GND signal)
--     50 x LUT6_2
--     48 x FD               82 flip-flops
--     20 x FDR       (Depending on the value of 'hwbuild' up)
--      0 x FDS       (to eight FDR will be replaced by FDS  )          
--     14 x FDRE
--     29 x MUXCY
--     27 x XORCY
--      4 x RAM32M    (16 LUTs)
--
--      2 x RAM64M   or  8 x RAM128X1S   or  8 x RAM256X1S
--       (8 LUTs)          (16 LUTs)           (32 LUTs)
--
-------------------------------------------------------------------------------------------
--	
begin

  --
  -------------------------------------------------------------------------------------------
  --
  -- Perform check of generic to report error as soon as possible.
  --
  -------------------------------------------------------------------------------------------
  --

  assert ((scratch_pad_memory_size = 64) 
       or (scratch_pad_memory_size = 128)
       or (scratch_pad_memory_size = 256))
  report "Invalid 'scratch_pad_memory_size'. Please set to 64, 128 or 256."
  severity FAILURE;

  --
  -------------------------------------------------------------------------------------------
  --
  -- State Machine and Control 
  --
  --
  --     1 x LUT6
  --     4 x LUT6_2
  --     9 x FD
  --
  -------------------------------------------------------------------------------------------
  --

  reset_lut: LUT6_2
  generic map (INIT => X"FFFFF55500000EEE")
  port map( I0 => run,
            I1 => internal_reset,
            I2 => stack_pointer_carry(4),
            I3 => t_state(2),
            I4 => reset,
            I5 => '1',
            O5 => run_value,
            O6 => internal_reset_value);

  run_flop: FD
  port map (  D => run_value,
              Q => run,
              C => clk);

  internal_reset_flop: FD
  port map (  D => internal_reset_value,
              Q => internal_reset,
              C => clk);

  sync_sleep_flop: FD
  port map (  D => sleep,
              Q => sync_sleep,
              C => clk);

  t_state_lut: LUT6_2
  generic map (INIT => X"0083000B00C4004C")
  port map( I0 => t_state(1),
            I1 => t_state(2),
            I2 => sync_sleep,
            I3 => internal_reset,
            I4 => special_bit,
            I5 => '1',
            O5 => t_state_value(1),
            O6 => t_state_value(2));

  t_state1_flop: FD
  port map (  D => t_state_value(1),
              Q => t_state(1),
              C => clk);

  t_state2_flop: FD
  port map (  D => t_state_value(2),
              Q => t_state(2),
              C => clk);


  int_enable_type_lut: LUT6_2
  generic map (INIT => X"0010000000000800")
  port map( I0 => instruction(13),
            I1 => instruction(14),
            I2 => instruction(15),
            I3 => instruction(16),
            I4 => instruction(17),
            I5 => '1',
            O5 => loadstar_type,
            O6 => int_enable_type);

  interrupt_enable_lut: LUT6
  generic map (INIT => X"000000000000CAAA")
  port map( I0 => interrupt_enable,
            I1 => instruction(0),
            I2 => int_enable_type,
            I3 => t_state(1),
            I4 => active_interrupt,
            I5 => internal_reset,
             O => interrupt_enable_value);                     

  interrupt_enable_flop: FD
  port map (  D => interrupt_enable_value,
              Q => interrupt_enable,
              C => clk);

  sync_interrupt_flop: FD
  port map (  D => interrupt,
              Q => sync_interrupt,
              C => clk);

  active_interrupt_lut: LUT6_2
  generic map (INIT => X"CC33FF0080808080")
  port map( I0 => interrupt_enable,
            I1 => t_state(2),
            I2 => sync_interrupt,
            I3 => bank,
            I4 => loadstar_type,
            I5 => '1',
            O5 => active_interrupt_value, 
            O6 => sx_addr4_value);

  active_interrupt_flop: FD
  port map (  D => active_interrupt_value,
              Q => active_interrupt,
              C => clk);

  interrupt_ack_flop: FD
  port map (  D => active_interrupt,
              Q => interrupt_ack,
              C => clk);


  --
  -------------------------------------------------------------------------------------------
  --
  -- Decoders 
  --
  --
  --     2 x LUT6
  --    10 x LUT6_2
  --     2 x FD
  --     6 x FDR
  --
  -------------------------------------------------------------------------------------------
  --

  --
  -- Decoding for Program Counter and Stack
  --

  pc_move_is_valid_lut: LUT6
  generic map (INIT => X"5A3CFFFF00000000")
  port map( I0 => carry_flag,
            I1 => zero_flag,
            I2 => instruction(14),
            I3 => instruction(15),
            I4 => instruction(16),
            I5 => instruction(17),
             O => pc_move_is_valid);

  move_type_lut: LUT6_2
  generic map (INIT => X"7777027700000200")
  port map( I0 => instruction(12),
            I1 => instruction(13),
            I2 => instruction(14),
            I3 => instruction(15),
            I4 => instruction(16),
            I5 => '1',
            O5 => returni_type,
            O6 => move_type);

  pc_mode1_lut: LUT6_2
  generic map (INIT => X"0000F000000023FF")
  port map( I0 => instruction(12),
            I1 => returni_type,
            I2 => move_type,
            I3 => pc_move_is_valid,
            I4 => active_interrupt,
            I5 => '1',
            O5 => pc_mode(0),
            O6 => pc_mode(1));

  pc_mode2_lut: LUT6
  generic map (INIT => X"FFFFFFFF00040000")
  port map( I0 => instruction(12),
            I1 => instruction(14),
            I2 => instruction(15),
            I3 => instruction(16),
            I4 => instruction(17),
            I5 => active_interrupt,
             O => pc_mode(2));

  push_pop_lut: LUT6_2
  generic map (INIT => X"FFFF100000002000")
  port map( I0 => instruction(12),
            I1 => instruction(13),
            I2 => move_type,
            I3 => pc_move_is_valid,
            I4 => active_interrupt,
            I5 => '1',
            O5 => pop_stack,
            O6 => push_stack);

  --
  -- Decoding for ALU
  --

  alu_decode0_lut: LUT6_2
  generic map (INIT => X"03CA000004200000")
  port map( I0 => instruction(13),
            I1 => instruction(14),
            I2 => instruction(15),
            I3 => instruction(16),
            I4 => '1',
            I5 => '1',
            O5 => alu_mux_sel_value(0),
            O6 => arith_logical_sel(0));

  alu_mux_sel0_flop: FD
  port map (  D => alu_mux_sel_value(0),
              Q => alu_mux_sel(0),
              C => clk);

  alu_decode1_lut: LUT6_2
  generic map (INIT => X"7708000000000F00")
  port map( I0 => carry_flag,
            I1 => instruction(13),
            I2 => instruction(14),
            I3 => instruction(15),
            I4 => instruction(16),
            I5 => '1',
            O5 => alu_mux_sel_value(1),
            O6 => arith_carry_in);                     

  alu_mux_sel1_flop: FD
  port map (  D => alu_mux_sel_value(1),
              Q => alu_mux_sel(1),
              C => clk);


  alu_decode2_lut: LUT6_2
  generic map (INIT => X"D000000002000000")
  port map( I0 => instruction(14),
            I1 => instruction(15),
            I2 => instruction(16),
            I3 => '1',
            I4 => '1',
            I5 => '1',
            O5 => arith_logical_sel(1),
            O6 => arith_logical_sel(2));

  --
  -- Decoding for strobes and enables
  --

  register_enable_type_lut: LUT6_2
  generic map (INIT => X"00013F3F0010F7CE")
  port map( I0 => instruction(13),
            I1 => instruction(14),
            I2 => instruction(15),
            I3 => instruction(16),
            I4 => instruction(17),
            I5 => '1',
            O5 => flag_enable_type,
            O6 => register_enable_type);

  register_enable_lut: LUT6_2
  generic map (INIT => X"C0CC0000A0AA0000")
  port map( I0 => flag_enable_type,
            I1 => register_enable_type,
            I2 => instruction(12),
            I3 => instruction(17),
            I4 => t_state(1),
            I5 => '1',
            O5 => flag_enable_value,
            O6 => register_enable_value);

  flag_enable_flop: FDR
  port map (  D => flag_enable_value,
              Q => flag_enable,
              R => active_interrupt,
              C => clk);

  register_enable_flop: FDR
  port map (  D => register_enable_value,
              Q => register_enable,
              R => active_interrupt,
              C => clk);

  spm_enable_lut: LUT6_2
  generic map (INIT => X"8000000020000000")
  port map( I0 => instruction(13),
            I1 => instruction(14),
            I2 => instruction(17),
            I3 => strobe_type,
            I4 => t_state(1),
            I5 => '1',
            O5 => k_write_strobe_value,
            O6 => spm_enable_value);

  k_write_strobe_flop: FDR
  port map (  D => k_write_strobe_value,
              Q => k_write_strobe,
              R => active_interrupt,
              C => clk);

  spm_enable_flop: FDR
  port map (  D => spm_enable_value,
              Q => spm_enable,
              R => active_interrupt,
              C => clk);

  read_strobe_lut: LUT6_2
  generic map (INIT => X"4000000001000000")
  port map( I0 => instruction(13),
            I1 => instruction(14),
            I2 => instruction(17),
            I3 => strobe_type,
            I4 => t_state(1),
            I5 => '1',
            O5 => read_strobe_value,
            O6 => write_strobe_value);

  write_strobe_flop: FDR
  port map (  D => write_strobe_value,
              Q => write_strobe,
              R => active_interrupt,
              C => clk);

  read_strobe_flop: FDR
  port map (  D => read_strobe_value,
              Q => read_strobe,
              R => active_interrupt,
              C => clk);

  --
  -------------------------------------------------------------------------------------------
  --
  -- Register bank control
  --
  --
  --     2 x LUT6
  --     1 x FDR
  --     1 x FD
  --
  -------------------------------------------------------------------------------------------
  --
  regbank_type_lut: LUT6
  generic map (INIT => X"0080020000000000")
  port map( I0 => instruction(12),
            I1 => instruction(13),
            I2 => instruction(14),
            I3 => instruction(15),
            I4 => instruction(16),
            I5 => instruction(17),
             O => regbank_type);

  bank_lut: LUT6
  generic map (INIT => X"ACACFF00FF00FF00")
  port map( I0 => instruction(0),
            I1 => shadow_bank,
            I2 => instruction(16),
            I3 => bank,
            I4 => regbank_type,
            I5 => t_state(1),
             O => bank_value);                     

  bank_flop: FDR
  port map (  D => bank_value,
              Q => bank,
              R => internal_reset,
              C => clk);

  sx_addr4_flop: FD
  port map (  D => sx_addr4_value,
              Q => sx_addr(4),
              C => clk);

  sx_addr(3 downto 0) <= instruction(11 downto 8);
  sy_addr <= bank & instruction(7 downto 4);

  --
  -------------------------------------------------------------------------------------------
  --
  -- Flags
  --
  --
  --     3 x LUT6
  --     5 x LUT6_2
  --     3 x FD
  --     2 x FDRE
  --     2 x XORCY
  --     5 x MUXCY
  --
  -------------------------------------------------------------------------------------------
  --

  arith_carry_xorcy: XORCY
  port map( LI => '0',
            CI => carry_arith_logical(7),
             O => arith_carry_value);

  arith_carry_flop: FD
  port map (  D => arith_carry_value,
              Q => arith_carry,
              C => clk);

  lower_parity_lut: LUT6_2
  generic map (INIT => X"0000000087780000")
  port map( I0 => instruction(13),
            I1 => carry_flag,
            I2 => arith_logical_result(0),
            I3 => arith_logical_result(1),
            I4 => '1',
            I5 => '1',
            O5 => lower_parity,
            O6 => lower_parity_sel);  
                   
  parity_muxcy: MUXCY
  port map( DI => lower_parity,
            CI => '0',                     
             S => lower_parity_sel,
             O => carry_lower_parity);

  upper_parity_lut: LUT6
  generic map (INIT => X"6996966996696996")
  port map( I0 => arith_logical_result(2),
            I1 => arith_logical_result(3),
            I2 => arith_logical_result(4),
            I3 => arith_logical_result(5),
            I4 => arith_logical_result(6),
            I5 => arith_logical_result(7),
             O => upper_parity);                     

  parity_xorcy: XORCY
  port map( LI => upper_parity,
            CI => carry_lower_parity,
             O => parity);

  shift_carry_lut: LUT6
  generic map (INIT => X"FFFFAACCF0F0F0F0")
  port map( I0 => sx(0),
            I1 => sx(7),
            I2 => shadow_carry_flag,
            I3 => instruction(3),
            I4 => instruction(7),
            I5 => instruction(16),
             O => shift_carry_value);                     

  shift_carry_flop: FD
  port map (  D => shift_carry_value,
              Q => shift_carry,
              C => clk);

  carry_flag_lut: LUT6_2
  generic map (INIT => X"3333AACCF0AA0000")
  port map( I0 => shift_carry,
            I1 => arith_carry,
            I2 => parity,
            I3 => instruction(14),
            I4 => instruction(15),
            I5 => instruction(16),
            O5 => drive_carry_in_zero,
            O6 => carry_flag_value);  

  carry_flag_flop: FDRE
  port map (  D => carry_flag_value,
              Q => carry_flag,
             CE => flag_enable,
              R => internal_reset,
              C => clk);

  init_zero_muxcy: MUXCY
  port map( DI => drive_carry_in_zero,
            CI => '0',
             S => carry_flag_value,
             O => carry_in_zero);

  use_zero_flag_lut: LUT6_2
  generic map (INIT => X"A280000000F000F0")
  port map( I0 => instruction(13),
            I1 => instruction(14),
            I2 => instruction(15),
            I3 => instruction(16),
            I4 => '1',
            I5 => '1',
            O5 => strobe_type,
            O6 => use_zero_flag_value);                     

  use_zero_flag_flop: FD
  port map (  D => use_zero_flag_value,
              Q => use_zero_flag,
              C => clk);

  lower_zero_lut: LUT6_2
  generic map (INIT => X"0000000000000001")
  port map( I0 => alu_result(0),
            I1 => alu_result(1),
            I2 => alu_result(2),
            I3 => alu_result(3),
            I4 => alu_result(4),
            I5 => '1',
            O5 => lower_zero,
            O6 => lower_zero_sel);                     

  lower_zero_muxcy: MUXCY
  port map( DI => lower_zero,
            CI => carry_in_zero,
             S => lower_zero_sel,
             O => carry_lower_zero);

  middle_zero_lut: LUT6_2
  generic map (INIT => X"0000000D00000000")
  port map( I0 => use_zero_flag,
            I1 => zero_flag,
            I2 => alu_result(5),
            I3 => alu_result(6),
            I4 => alu_result(7),
            I5 => '1',
            O5 => middle_zero,
            O6 => middle_zero_sel);                     

  middle_zero_muxcy: MUXCY
  port map( DI => middle_zero,
            CI => carry_lower_zero,                     
             S => middle_zero_sel,
             O => carry_middle_zero);

  upper_zero_lut: LUT6
  generic map (INIT => X"FBFF000000000000")
  port map( I0 => instruction(14),
            I1 => instruction(15),
            I2 => instruction(16),
            I3 => '1',
            I4 => '1',
            I5 => '1',
             O => upper_zero_sel);                     

  upper_zero_muxcy: MUXCY
  port map( DI => shadow_zero_flag,
            CI => carry_middle_zero,                    
             S => upper_zero_sel,
             O => zero_flag_value);

  zero_flag_flop: FDRE
  port map (  D => zero_flag_value,
              Q => zero_flag,
             CE => flag_enable,
              R => internal_reset,
              C => clk);

  --
  -------------------------------------------------------------------------------------------
  --
  -- 12-bit Program Address Generation 
  --
  -------------------------------------------------------------------------------------------
  --

  --
  -- Prepare 12-bit vector from the sX and sY register outputs.
  --

  register_vector <= sx(3 downto 0) & sy;


  address_loop: for i in 0 to 11 generate
    attribute hblknm : string;                      
    attribute hblknm of            pc_flop : label is "kcpsm6_pc" & integer'image(i/4);	
    attribute hblknm of return_vector_flop : label is "kcpsm6_stack_ram" & integer'image((i+4)/8);	  

  begin

    --
    -------------------------------------------------------------------------------------------
    --
    -- Selection of vector to load program counter
    --
    -- instruction(12)
    --              0  Constant aaa from instruction(11:0)
    --              1  Return vector from stack 
    --
    -- 'aaa' is used during 'JUMP aaa', 'JUMP c, aaa', 'CALL aaa' and 'CALL c, aaa'.
    -- Return vector is used during 'RETURN', 'RETURN c', 'RETURN&LOAD' and 'RETURNI'.
    --
    --     6 x LUT6_2
    --     12 x FD
    --
    -------------------------------------------------------------------------------------------
    --

    --
    -- Pipeline output of the stack memory
    --

    return_vector_flop: FD
    port map (  D => stack_memory(i),
                Q => return_vector(i),
                C => clk);

    --
    -- Multiplex instruction constant address and output from stack.
    -- 2 bits per LUT so only generate when 'i' is even.
    --

    output_data: if (i rem 2)=0 generate
      attribute hblknm : string;                      
      attribute hblknm of pc_vector_mux_lut : label is "kcpsm6_vector" & integer'image(i/8);	
    begin

      pc_vector_mux_lut: LUT6_2
      generic map (INIT => X"FF00F0F0CCCCAAAA")
      port map( I0 => instruction(i),
                I1 => return_vector(i),
                I2 => instruction(i+1),
                I3 => return_vector(i+1),
                I4 => instruction(12),
                I5 => '1',
                O5 => pc_vector(i),
                O6 => pc_vector(i+1));

    end generate output_data;

    --
    -------------------------------------------------------------------------------------------
    --
    -- Program Counter
    --
    -- Reset by internal_reset has highest priority.
    -- Enabled by t_state(1) has second priority.
    --
    -- The function performed is defined by pc_mode(2:0).
    --
    -- pc_mode (2) (1) (0) 
    --          0   0   1  pc+1 for normal program flow.
    --          1   0   0  Forces interrupt vector value (+0) during active interrupt.
    --                     The vector is defined by a generic with default value FF0 hex.
    --          1   1   0  register_vector (+0) for 'JUMP (sX, sY)' and 'CALL (sX, sY)'.
    --          0   1   0  pc_vector (+0) for 'JUMP/CALL aaa' and 'RETURNI'.
    --          0   1   1  pc_vector+1 for 'RETURN'.
    --
    -- Note that pc_mode(0) is High during operations that require an increment to occur.
    -- The LUT6 associated with the LSB must invert pc or pc_vector in these cases and 
    -- pc_mode(0) also has to be connected to the start of the carry chain.
    --
    -- 3 Slices 
    --     12 x LUT6
    --     11 x MUXCY
    --     12 x XORCY
    --     12 x FDRE
    --
    -------------------------------------------------------------------------------------------
    --


    pc_flop: FDRE
    port map (  D => pc_value(i),
                Q => pc(i),
                R => internal_reset,
               CE => t_state(1),
                C => clk);


    lsb_pc: if i=0 generate
      attribute hblknm : string;                      
      attribute hblknm of pc_xorcy : label is "kcpsm6_pc" & integer'image(i/4);	
      attribute hblknm of pc_muxcy : label is "kcpsm6_pc" & integer'image(i/4);	
    begin

      --
      -- Logic of LSB must invert selected value when pc_mode(0) is High.
      -- The interrupt vector is defined by a generic.
      --

      low_int_vector: if interrupt_vector(i)='0' generate
        attribute hblknm : string;                      
        attribute hblknm of pc_lut : label is "kcpsm6_pc" & integer'image(i/4);	
      begin

        pc_lut: LUT6
        generic map (INIT => X"00AA000033CC0F00")
        port map( I0 => register_vector(i),
                  I1 => pc_vector(i),
                  I2 => pc(i),
                  I3 => pc_mode(0),
                  I4 => pc_mode(1),
                  I5 => pc_mode(2), 
                   O => half_pc(i));

      end generate low_int_vector;

      high_int_vector: if interrupt_vector(i)='1' generate
        attribute hblknm : string;                      
        attribute hblknm of pc_lut : label is "kcpsm6_pc" & integer'image(i/4);	
      begin
    
        pc_lut: LUT6
        generic map (INIT => X"00AA00FF33CC0F00")
        port map( I0 => register_vector(i),
                  I1 => pc_vector(i),
                  I2 => pc(i),
                  I3 => pc_mode(0),
                  I4 => pc_mode(1),
                  I5 => pc_mode(2), 
                   O => half_pc(i));

      end generate high_int_vector;

      --
      -- pc_mode(0) connected to first MUXCY and carry input is '0'
      --

      pc_xorcy: XORCY
      port map( LI => half_pc(i),
                CI => '0',
                 O => pc_value(i));

      pc_muxcy: MUXCY
      port map( DI => pc_mode(0),
                CI => '0',
                 S => half_pc(i),
                 O => carry_pc(i));

    end generate lsb_pc;

    upper_pc: if i>0 generate
      attribute hblknm : string;                      
      attribute hblknm of pc_xorcy : label is "kcpsm6_pc" & integer'image(i/4);	
    begin

      --
      -- Logic of upper section selects required value.
      -- The interrupt vector is defined by a generic.
      --

      low_int_vector: if interrupt_vector(i)='0' generate
        attribute hblknm : string;                      
        attribute hblknm of pc_lut : label is "kcpsm6_pc" & integer'image(i/4);	
      begin
    
        pc_lut: LUT6
        generic map (INIT => X"00AA0000CCCCF000")
        port map( I0 => register_vector(i),
                  I1 => pc_vector(i),
                  I2 => pc(i),
                  I3 => pc_mode(0),
                  I4 => pc_mode(1),
                  I5 => pc_mode(2), 
                   O => half_pc(i));

      end generate low_int_vector;

      high_int_vector: if interrupt_vector(i)='1' generate
        attribute hblknm : string;                      
        attribute hblknm of pc_lut : label is "kcpsm6_pc" & integer'image(i/4);	
      begin
    
        pc_lut: LUT6
        generic map (INIT => X"00AA00FFCCCCF000")
        port map( I0 => register_vector(i),
                  I1 => pc_vector(i),
                  I2 => pc(i),
                  I3 => pc_mode(0),
                  I4 => pc_mode(1),
                  I5 => pc_mode(2), 
                   O => half_pc(i));

      end generate high_int_vector;

      --
      -- Carry chain implementing remainder of increment function
      --
      pc_xorcy: XORCY
      port map( LI => half_pc(i),
                CI => carry_pc(i-1),
                 O => pc_value(i));


      --
      -- No MUXCY required at the top of the chain
      --
      mid_pc: if i<11 generate
        attribute hblknm : string;                      
        attribute hblknm of pc_muxcy : label is "kcpsm6_pc" & integer'image(i/4);	
      begin

        pc_muxcy: MUXCY
        port map( DI => '0',
                  CI => carry_pc(i-1),
                   S => half_pc(i),
                   O => carry_pc(i));

      end generate mid_pc;

    end generate upper_pc;


    --
    -------------------------------------------------------------------------------------------
    --

  end generate address_loop;



  --
  -------------------------------------------------------------------------------------------
  --
  -- Stack 
  --  Preserves upto 31 nested values of the Program Counter during CALL and RETURN.
  --  Also preserves flags and bank selection during interrupt.
  --
  --     2 x RAM32M 
  --     4 x FD
  --     5 x FDR
  --     1 x LUT6
  --     4 x LUT6_2
  --     5 x XORCY
  --     5 x MUXCY
  --
  -------------------------------------------------------------------------------------------
  --

  shadow_carry_flag_flop: FD
  port map (  D => stack_carry_flag,
              Q => shadow_carry_flag,
              C => clk);

  stack_zero_flop: FD
  port map (  D => stack_zero_flag,
              Q => shadow_zero_value,
              C => clk);

  shadow_zero_flag_flop: FD
  port map (  D => shadow_zero_value,
              Q => shadow_zero_flag,
              C => clk);

  shadow_bank_flop: FD
  port map (  D => stack_bank,
              Q => shadow_bank,
              C => clk);

  stack_bit_flop: FD
  port map (  D => stack_bit,
              Q => special_bit,
              C => clk);

  stack_ram_low : RAM32M
  generic map (INIT_A => X"0000000000000000", 
               INIT_B => X"0000000000000000", 
               INIT_C => X"0000000000000000", 
               INIT_D => X"0000000000000000") 
  port map ( DOA(0) => stack_carry_flag, 
             DOA(1) => stack_zero_flag,
             DOB(0) => stack_bank,
             DOB(1) => stack_bit,
                DOC => stack_memory(1 downto 0), 
                DOD => stack_memory(3 downto 2),
              ADDRA => stack_pointer(4 downto 0), 
              ADDRB => stack_pointer(4 downto 0), 
              ADDRC => stack_pointer(4 downto 0), 
              ADDRD => stack_pointer(4 downto 0),
             DIA(0) => carry_flag, 
             DIA(1) => zero_flag,
             DIB(0) => bank,
             DIB(1) => run, 
                DIC => pc(1 downto 0),
                DID => pc(3 downto 2),
                 WE => t_state(1), 
               WCLK => clk );

  stack_ram_high : RAM32M
  generic map (INIT_A => X"0000000000000000", 
               INIT_B => X"0000000000000000", 
               INIT_C => X"0000000000000000", 
               INIT_D => X"0000000000000000") 
  port map (    DOA => stack_memory(5 downto 4), 
                DOB => stack_memory(7 downto 6),
                DOC => stack_memory(9 downto 8),
                DOD => stack_memory(11 downto 10),
              ADDRA => stack_pointer(4 downto 0), 
              ADDRB => stack_pointer(4 downto 0), 
              ADDRC => stack_pointer(4 downto 0), 
              ADDRD => stack_pointer(4 downto 0),
                DIA => pc(5 downto 4),
                DIB => pc(7 downto 6),
                DIC => pc(9 downto 8),
                DID => pc(11 downto 10),
                 WE => t_state(1),  
               WCLK => clk );


  stack_loop: for i in 0 to 4 generate
  begin



    lsb_stack: if i=0 generate
    attribute hblknm : string;                      
    attribute hblknm of pointer_flop      : label is "kcpsm6_stack" & integer'image(i/4);	
    attribute hblknm of stack_pointer_lut : label is "kcpsm6_stack" & integer'image(i/4);
    attribute hblknm of stack_xorcy       : label is "kcpsm6_stack" & integer'image(i/4);
    attribute hblknm of stack_muxcy       : label is "kcpsm6_stack" & integer'image(i/4);
    begin

      pointer_flop: FDR
      port map (  D => stack_pointer_value(i),
                  Q => stack_pointer(i),
                  R => internal_reset,
                  C => clk);

      stack_pointer_lut: LUT6_2
      generic map (INIT => X"001529AAAAAAAAAA")
      port map( I0 => stack_pointer(i),
                I1 => pop_stack,
                I2 => push_stack,
                I3 => t_state(1),
                I4 => t_state(2),
                I5 => '1', 
                O5 => feed_pointer_value(i),
                O6 => half_pointer_value(i));

      stack_xorcy: XORCY
      port map( LI => half_pointer_value(i),
                CI => '0',
                 O => stack_pointer_value(i));

      stack_muxcy: MUXCY
      port map( DI => feed_pointer_value(i),
                CI => '0',
                 S => half_pointer_value(i),
                 O => stack_pointer_carry(i));

    end generate lsb_stack;

    upper_stack: if i>0 generate
    attribute hblknm : string;                      
    attribute hblknm of pointer_flop      : label is "kcpsm6_stack" & integer'image(i/4);	
    attribute hblknm of stack_pointer_lut : label is "kcpsm6_stack" & integer'image(i/4);
    attribute hblknm of stack_xorcy       : label is "kcpsm6_stack" & integer'image(i/4);
    attribute hblknm of stack_muxcy       : label is "kcpsm6_stack" & integer'image(i/4);
    begin

      pointer_flop: FDR
      port map (  D => stack_pointer_value(i),
                  Q => stack_pointer(i),
                  R => internal_reset,
                  C => clk);

      stack_pointer_lut: LUT6_2
      generic map (INIT => X"002A252AAAAAAAAA")
      port map( I0 => stack_pointer(i),
                I1 => pop_stack,
                I2 => push_stack,
                I3 => t_state(1),
                I4 => t_state(2),
                I5 => '1', 
                O5 => feed_pointer_value(i),
                O6 => half_pointer_value(i));

      stack_xorcy: XORCY
      port map( LI => half_pointer_value(i),
                CI => stack_pointer_carry(i-1),
                 O => stack_pointer_value(i));

      stack_muxcy: MUXCY
      port map( DI => feed_pointer_value(i),
                CI => stack_pointer_carry(i-1),
                 S => half_pointer_value(i),
                 O => stack_pointer_carry(i));

    end generate upper_stack;

  end generate stack_loop;


  --
  -------------------------------------------------------------------------------------------
  --
  -- 8-bit Data Path 
  --
  -------------------------------------------------------------------------------------------
  --

  data_path_loop: for i in 0 to 7 generate
    attribute hblknm : string;                      
    attribute hblknm of  arith_logical_lut : label is "kcpsm6_add" & integer'image(i/4);	
    attribute hblknm of arith_logical_flop : label is "kcpsm6_add" & integer'image(i/4);	
    attribute hblknm of        alu_mux_lut : label is "kcpsm6_alu" & integer'image(i/4);	
  begin

    --
    -------------------------------------------------------------------------------------------
    --
    -- Selection of second operand to ALU and port_id
    --
    -- instruction(12)
    --           0  Register sY
    --           1  Constant kk 
    --
    --     4 x LUT6_2
    --
    -------------------------------------------------------------------------------------------
    --
    --
    -- 2 bits per LUT so only generate when 'i' is even
    --

    output_data: if (i rem 2)=0 generate
      attribute hblknm : string;                      
      attribute hblknm of sy_kk_mux_lut : label is "kcpsm6_port_id";	
    begin

      sy_kk_mux_lut: LUT6_2
      generic map (INIT => X"FF00F0F0CCCCAAAA")
      port map( I0 => sy(i),
                I1 => instruction(i),
                I2 => sy(i+1),
                I3 => instruction(i+1),
                I4 => instruction(12),
                I5 => '1',
                O5 => sy_or_kk(i),
                O6 => sy_or_kk(i+1));

    end generate output_data;

    --
    -------------------------------------------------------------------------------------------
    --
    -- Selection of out_port value
    --
    -- instruction(13)
    --              0  Register sX
    --              1  Constant kk from instruction(11:4)
    --
    --     4 x LUT6_2
    --
    -------------------------------------------------------------------------------------------
    --
    --
    -- 2 bits per LUT so only generate when 'i' is even
    --

    second_operand: if (i rem 2)=0 generate
      attribute hblknm : string;                      
      attribute hblknm of out_port_lut : label is "kcpsm6_out_port";	
    begin

      out_port_lut: LUT6_2
      generic map (INIT => X"FF00F0F0CCCCAAAA")
      port map( I0 => sx(i),
                I1 => instruction(i+4),
                I2 => sx(i+1),
                I3 => instruction(i+5),
                I4 => instruction(13),
                I5 => '1',
                O5 => out_port(i),
                O6 => out_port(i+1));

    end generate second_operand;

    --
    -------------------------------------------------------------------------------------------
    --
    -- Arithmetic and Logical operations
    --
    -- Definition of....
    --    ADD and SUB also used for ADDCY, SUBCY, COMPARE and COMPARECY.
    --    LOAD, AND, OR and XOR also used for LOAD*, RETURN&LOAD, TEST and TESTCY.
    --
    -- arith_logical_sel (2) (1) (0)
    --                    0   0   0  - LOAD
    --                    0   0   1  - AND
    --                    0   1   0  - OR
    --                    0   1   1  - XOR
    --                    1   X   0  - SUB
    --                    1   X   1  - ADD
    --
    -- Includes pipeline stage.
    --
    -- 2 Slices
    --     8 x LUT6_2
    --     8 x MUXCY
    --     8 x XORCY
    --     8 x FD
    --
    -------------------------------------------------------------------------------------------
    --

    arith_logical_lut: LUT6_2
    generic map (INIT => X"69696E8ACCCC0000")
    port map( I0 => sy_or_kk(i),
              I1 => sx(i),
              I2 => arith_logical_sel(0),
              I3 => arith_logical_sel(1),
              I4 => arith_logical_sel(2),
              I5 => '1',
              O5 => logical_carry_mask(i),
              O6 => half_arith_logical(i));

    arith_logical_flop: FD
    port map ( D => arith_logical_value(i),
               Q => arith_logical_result(i),
               C => clk);

    lsb_arith_logical: if i=0 generate
      attribute hblknm : string;                      
      attribute hblknm of arith_logical_muxcy : label is "kcpsm6_add" & integer'image(i/4);	
      attribute hblknm of arith_logical_xorcy : label is "kcpsm6_add" & integer'image(i/4);	
    begin
      --
      -- Carry input to first MUXCY and XORCY
      --
      arith_logical_muxcy: MUXCY
      port map( DI => logical_carry_mask(i),
                CI => arith_carry_in,
                 S => half_arith_logical(i),
                 O => carry_arith_logical(i));

      arith_logical_xorcy: XORCY
      port map( LI => half_arith_logical(i),
                CI => arith_carry_in,
                 O => arith_logical_value(i));

    end generate lsb_arith_logical;

    upper_arith_logical: if i>0 generate
      attribute hblknm : string;                      
      attribute hblknm of arith_logical_muxcy : label is "kcpsm6_add" & integer'image(i/4);	
      attribute hblknm of arith_logical_xorcy : label is "kcpsm6_add" & integer'image(i/4);	
    begin
      --
      -- Main carry chain  
      --
      arith_logical_muxcy: MUXCY
      port map( DI => logical_carry_mask(i),
                CI => carry_arith_logical(i-1),
                 S => half_arith_logical(i),
                 O => carry_arith_logical(i));

      arith_logical_xorcy: XORCY
      port map( LI => half_arith_logical(i),
                CI => carry_arith_logical(i-1),
                 O => arith_logical_value(i));

    end generate upper_arith_logical;


    --
    -------------------------------------------------------------------------------------------
    --
    -- Shift and Rotate operations
    --
    -- Definition of SL0, SL1, SLX, SLA, RL, SR0, SR1, SRX, SRA, and RR 
    --
    -- instruction (3) (2) (1) (0)
    --              0   1   1   0  - SL0
    --              0   1   1   1  - SL1
    --              0   1   0   0  - SLX         
    --              0   0   0   0  - SLA
    --              0   0   1   0  - RL
    --              1   1   1   0  - SR0
    --              1   1   1   1  - SR1
    --              1   0   1   0  - SRX
    --              1   0   0   0  - SRA
    --              1   1   0   0  - RR
    --
    -- instruction(3) 
    --             0 - Left
    --             1 - Right
    --
    -- instruction (2) (1)  Bit shifted in 
    --              0   0   Carry_flag
    --              0   1   sX(7)
    --              1   0   sX(0)
    --              1   1   instruction(0)
    --
    -- Includes pipeline stage.
    --
    --     4 x LUT6_2
    --     1 x LUT6
    --     8 x FD
    --
    -------------------------------------------------------------------------------------------
    --

    low_hwbuild: if hwbuild(i)='0' generate
      attribute hblknm : string;                      
      attribute hblknm of shift_rotate_flop : label is "kcpsm6_sandr";	
    begin
      --
      -- Reset Flip-flop to form '0' for this bit of HWBUILD 
      --
      shift_rotate_flop: FDR
      port map ( D => shift_rotate_value(i),
                 Q => shift_rotate_result(i),
                 R => instruction(7),
                 C => clk);

    end generate low_hwbuild;

    high_hwbuild: if hwbuild(i)='1' generate
      attribute hblknm : string;                      
      attribute hblknm of shift_rotate_flop : label is "kcpsm6_sandr";	
    begin
      --
      -- Set Flip-flop to form '1' for this bit of HWBUILD 
      --
      shift_rotate_flop: FDS
      port map ( D => shift_rotate_value(i),
                 Q => shift_rotate_result(i),
                 S => instruction(7),
                 C => clk);

    end generate high_hwbuild;


    lsb_shift_rotate: if i=0 generate
      attribute hblknm : string;                      
      attribute hblknm of shift_rotate_lut : label is "kcpsm6_sandr";
      attribute hblknm of    shift_bit_lut : label is "kcpsm6_decode1";
    begin
      --
      -- Select bit to be shifted or rotated into result
      --
      shift_bit_lut: LUT6
      generic map (INIT => X"BFBC8F8CB3B08380")
      port map( I0 => instruction(0),
                I1 => instruction(1),
                I2 => instruction(2),
                I3 => carry_flag,
                I4 => sx(0),
                I5 => sx(7),
                 O => shift_in_bit);

      --
      -- Define lower bits of result
      --
      shift_rotate_lut: LUT6_2
      generic map (INIT => X"FF00F0F0CCCCAAAA")
      port map( I0 => shift_in_bit,
                I1 => sx(i+1),
                I2 => sx(i),
                I3 => sx(i+2),
                I4 => instruction(3),
                I5 => '1',
                O5 => shift_rotate_value(i),
                O6 => shift_rotate_value(i+1));

    end generate lsb_shift_rotate;


    mid_shift_rotate: if i=2 or i=4 generate
      attribute hblknm : string;                      
      attribute hblknm of shift_rotate_lut : label is "kcpsm6_sandr";
    begin
      --
      -- Define middle bits of result
      --
      shift_rotate_lut: LUT6_2
      generic map (INIT => X"FF00F0F0CCCCAAAA")
      port map( I0 => sx(i-1),
                I1 => sx(i+1),
                I2 => sx(i),
                I3 => sx(i+2),
                I4 => instruction(3),
                I5 => '1',
                O5 => shift_rotate_value(i),
                O6 => shift_rotate_value(i+1));

    end generate mid_shift_rotate;

    msb_shift_rotate: if i=6 generate
      attribute hblknm : string;                      
      attribute hblknm of shift_rotate_lut : label is "kcpsm6_sandr";
    begin
      --
      -- Define upper bits of result
      --
      shift_rotate_lut: LUT6_2
      generic map (INIT => X"FF00F0F0CCCCAAAA")
      port map( I0 => sx(i-1),
                I1 => sx(i+1),
                I2 => sx(i),
                I3 => shift_in_bit,
                I4 => instruction(3),
                I5 => '1',
                O5 => shift_rotate_value(i),
                O6 => shift_rotate_value(i+1));

    end generate msb_shift_rotate;

    --
    -------------------------------------------------------------------------------------------
    --
    -- Multiplex outputs from ALU functions, scratch pad memory and input port.
    --
    -- alu_mux_sel (1) (0)  
    --              0   0  Arithmetic and Logical Instructions
    --              0   1  Shift and Rotate Instructions
    --              1   0  Input Port
    --              1   1  Scratch Pad Memory
    --
    --     8 x LUT6
    --
    -------------------------------------------------------------------------------------------
    --

    alu_mux_lut: LUT6
    generic map (INIT => X"FF00F0F0CCCCAAAA")
    port map( I0 => arith_logical_result(i),
              I1 => shift_rotate_result(i),
              I2 => in_port(i),
              I3 => spm_data(i),
              I4 => alu_mux_sel(0),
              I5 => alu_mux_sel(1),
               O => alu_result(i));

    --
    -------------------------------------------------------------------------------------------
    --
    -- Scratchpad Memory with output register.
    --
    -- The size of the scratch pad memory is defined by the 'scratch_pad_memory_size' generic.
    -- The default size is 64 bytes the same as KCPSM3 but this can be increased to 128 or 256 
    -- bytes at an additional cost of 2 and 6 Slices.
    --
    --
    -- 8 x RAM256X1S (256 bytes).
    -- 8 x RAM128X1S (128 bytes).
    -- 2 x RAM64M    (64 bytes).
    --
    -- 8 x FD.
    --
    -------------------------------------------------------------------------------------------
    --


    small_spm: if scratch_pad_memory_size = 64 generate
      attribute hblknm : string;                      
      attribute hblknm of spm_flop : label is "kcpsm6_spm" & integer'image(i/4);	
    begin

      spm_flop: FD
      port map ( D => spm_ram_data(i),
                 Q => spm_data(i),
                 C => clk);

      small_spm_ram: if (i=0 or i=4) generate
        attribute hblknm of spm_ram  : label is "kcpsm6_spm" & integer'image(i/4);	
      begin

        spm_ram: RAM64M
        generic map ( INIT_A => X"0000000000000000",
                      INIT_B => X"0000000000000000",
                      INIT_C => X"0000000000000000",
                      INIT_D => X"0000000000000000") 
        port map (   DOA => spm_ram_data(i),
                     DOB => spm_ram_data(i+1),
                     DOC => spm_ram_data(i+2),
                     DOD => spm_ram_data(i+3),
                   ADDRA => sy_or_kk(5 downto 0),
                   ADDRB => sy_or_kk(5 downto 0),
                   ADDRC => sy_or_kk(5 downto 0),
                   ADDRD => sy_or_kk(5 downto 0),
                     DIA => sx(i),
                     DIB => sx(i+1),
                     DIC => sx(i+2),
                     DID => sx(i+3),
                      WE => spm_enable,
                    WCLK => clk );

      end generate small_spm_ram;

    end generate small_spm;


    medium_spm: if scratch_pad_memory_size = 128 generate
      attribute hblknm : string;                      
      attribute hblknm of spm_ram  : label is "kcpsm6_spm" & integer'image(i/2);	
      attribute hblknm of spm_flop : label is "kcpsm6_spm" & integer'image(i/2);	
    begin

      spm_ram: RAM128X1S
      generic map(INIT => X"00000000000000000000000000000000")
      port map (       D => sx(i),
                      WE => spm_enable,
                    WCLK => clk,
                      A0 => sy_or_kk(0),
                      A1 => sy_or_kk(1),
                      A2 => sy_or_kk(2),
                      A3 => sy_or_kk(3),
                      A4 => sy_or_kk(4),
                      A5 => sy_or_kk(5),
                      A6 => sy_or_kk(6),
                       O => spm_ram_data(i));

      spm_flop: FD
      port map ( D => spm_ram_data(i),
                 Q => spm_data(i),
                 C => clk);

    end generate medium_spm;


    large_spm: if scratch_pad_memory_size = 256 generate
      attribute hblknm : string;                      
      attribute hblknm of spm_ram  : label is "kcpsm6_spm" & integer'image(i);	
      attribute hblknm of spm_flop : label is "kcpsm6_spm" & integer'image(i);	
    begin

      spm_ram: RAM256X1S
      generic map(INIT => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map (       D => sx(i),
                      WE => spm_enable,
                    WCLK => clk,
                       A => sy_or_kk,
                       O => spm_ram_data(i));

      spm_flop: FD
      port map ( D => spm_ram_data(i),
                 Q => spm_data(i),
                 C => clk);

    end generate large_spm;

    --
    -------------------------------------------------------------------------------------------
    --

  end generate data_path_loop;




  --
  -------------------------------------------------------------------------------------------
  --
  -- Two Banks of 16 General Purpose Registers.
  --
  -- sx_addr - Address for sX is formed by bank select and instruction[11:8]
  -- sy_addr - Address for sY is formed by bank select and instruction[7:4]
  --
  -- 2 Slices
  --     2 x RAM32M
  --
  -------------------------------------------------------------------------------------------
  --

  lower_reg_banks : RAM32M
  generic map (INIT_A => X"0000000000000000", 
               INIT_B => X"0000000000000000", 
               INIT_C => X"0000000000000000", 
               INIT_D => X"0000000000000000") 
  port map (    DOA => sy(1 downto 0), 
                DOB => sx(1 downto 0),
                DOC => sy(3 downto 2),
                DOD => sx(3 downto 2),
              ADDRA => sy_addr, 
              ADDRB => sx_addr, 
              ADDRC => sy_addr, 
              ADDRD => sx_addr, 
                DIA => alu_result(1 downto 0),
                DIB => alu_result(1 downto 0),
                DIC => alu_result(3 downto 2),
                DID => alu_result(3 downto 2),
                 WE => register_enable, 
               WCLK => clk );

  upper_reg_banks : RAM32M
  generic map (INIT_A => X"0000000000000000", 
               INIT_B => X"0000000000000000", 
               INIT_C => X"0000000000000000", 
               INIT_D => X"0000000000000000") 
  port map (    DOA => sy(5 downto 4), 
                DOB => sx(5 downto 4),
                DOC => sy(7 downto 6),
                DOD => sx(7 downto 6),
              ADDRA => sy_addr, 
              ADDRB => sx_addr, 
              ADDRC => sy_addr, 
              ADDRD => sx_addr, 
                DIA => alu_result(5 downto 4),
                DIB => alu_result(5 downto 4),
                DIC => alu_result(7 downto 6),
                DID => alu_result(7 downto 6),
                 WE => register_enable, 
               WCLK => clk );




  --
  -------------------------------------------------------------------------------------------
  --
  -- Connections to KCPSM6 outputs.
  --
  -------------------------------------------------------------------------------------------
  --


  address <= pc;
  bram_enable <= t_state(2);
 
  --
  -------------------------------------------------------------------------------------------
  --
  -- Connections KCPSM6 Outputs.
  --
  -------------------------------------------------------------------------------------------
  --

  port_id <= sy_or_kk;

--
-------------------------------------------------------------------------------------------
--
-- End of description for kcpsm6 macro.
--
-------------------------------------------------------------------------------------------
--
-- *****************************************************
-- * Code for simulation purposes only after this line *
-- *****************************************************
--
--
-- Disassemble the instruction codes to form a text string for display.
-- Determine status of reset and flags and present in the form of a text string.
-- Provide signals to simulate the contents of each register and scratch pad memory 
-- location.
--
-------------------------------------------------------------------------------------------
--
  --All of this section is ignored during synthesis.
  --synthesis translate off

  simulation: process (clk, instruction, carry_flag, zero_flag, bank, interrupt_enable)

  --
  -- Variables for contents of each register in each bank
  --
  variable bank_a_s0 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_s1 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_s2 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_s3 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_s4 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_s5 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_s6 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_s7 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_s8 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_s9 : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_sa : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_sb : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_sc : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_sd : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_se : std_logic_vector(7 downto 0) := X"00";
  variable bank_a_sf : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s0 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s1 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s2 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s3 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s4 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s5 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s6 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s7 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s8 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_s9 : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_sa : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_sb : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_sc : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_sd : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_se : std_logic_vector(7 downto 0) := X"00";
  variable bank_b_sf : std_logic_vector(7 downto 0) := X"00";
  --
  -- Temporary variables for instruction decoding
  --
  variable     sx_decode : string(1 to 2);   -- sX register specification
  variable     sy_decode : string(1 to 2);   -- sY register specification
  variable     kk_decode : string(1 to 2);   -- constant value kk, pp or ss
  variable    aaa_decode : string(1 to 3);   -- address value aaa
  --
  -----------------------------------------------------------------------------------------
  --
  -- Function to convert 4-bit binary nibble to hexadecimal character
  --
  -----------------------------------------------------------------------------------------
  --
  function hexcharacter (nibble: std_logic_vector(3 downto 0))
  return character is
  variable hex: character;
  begin
    case nibble is
      when "0000" => hex := '0';
      when "0001" => hex := '1';
      when "0010" => hex := '2';
      when "0011" => hex := '3';
      when "0100" => hex := '4';
      when "0101" => hex := '5';
      when "0110" => hex := '6';
      when "0111" => hex := '7';
      when "1000" => hex := '8';
      when "1001" => hex := '9';
      when "1010" => hex := 'A';
      when "1011" => hex := 'B';
      when "1100" => hex := 'C';
      when "1101" => hex := 'D';
      when "1110" => hex := 'E';
      when "1111" => hex := 'F';
      when others => hex := 'x';
    end case;
    return hex;
  end hexcharacter;
  --
  -----------------------------------------------------------------------------------------
  --
  begin
     
    -- decode first register sX
    sx_decode(1) := 's';
    sx_decode(2) := hexcharacter(instruction(11 downto 8));             

    -- decode second register sY
    sy_decode(1) := 's';
    sy_decode(2) := hexcharacter(instruction(7 downto 4));  

    -- decode constant value
    kk_decode(1) := hexcharacter(instruction(7 downto 4));
    kk_decode(2) := hexcharacter(instruction(3 downto 0));

    -- address value
    aaa_decode(1) := hexcharacter(instruction(11 downto 8));
    aaa_decode(2) := hexcharacter(instruction(7 downto 4));
    aaa_decode(3) := hexcharacter(instruction(3 downto 0));

    -- decode instruction
    case instruction(17 downto 12) is
      when "000000" => kcpsm6_opcode <= "LOAD " & sx_decode & ", " & sy_decode & "        ";
      when "000001" => kcpsm6_opcode <= "LOAD " & sx_decode & ", " & kk_decode & "        ";
      when "010110" => kcpsm6_opcode <= "STAR " & sx_decode & ", " & sy_decode & "        ";
      when "010111" => kcpsm6_opcode <= "STAR " & sx_decode & ", " & kk_decode & "        ";
      when "000010" => kcpsm6_opcode <= "AND " & sx_decode & ", " & sy_decode & "         ";
      when "000011" => kcpsm6_opcode <= "AND " & sx_decode & ", " & kk_decode & "         ";
      when "000100" => kcpsm6_opcode <= "OR " & sx_decode & ", " & sy_decode & "          ";
      when "000101" => kcpsm6_opcode <= "OR " & sx_decode & ", " & kk_decode & "          ";
      when "000110" => kcpsm6_opcode <= "XOR " & sx_decode & ", " & sy_decode & "         ";
      when "000111" => kcpsm6_opcode <= "XOR " & sx_decode & ", " & kk_decode & "         ";
      when "001100" => kcpsm6_opcode <= "TEST " & sx_decode & ", " & sy_decode & "        ";
      when "001101" => kcpsm6_opcode <= "TEST " & sx_decode & ", " & kk_decode & "        ";
      when "001110" => kcpsm6_opcode <= "TESTCY " & sx_decode & ", " & sy_decode & "      ";
      when "001111" => kcpsm6_opcode <= "TESTCY " & sx_decode & ", " & kk_decode & "      ";
      when "010000" => kcpsm6_opcode <= "ADD " & sx_decode & ", " & sy_decode & "         ";
      when "010001" => kcpsm6_opcode <= "ADD " & sx_decode & ", " & kk_decode & "         ";
      when "010010" => kcpsm6_opcode <= "ADDCY " & sx_decode & ", " & sy_decode & "       ";
      when "010011" => kcpsm6_opcode <= "ADDCY " & sx_decode & ", " & kk_decode & "       ";
      when "011000" => kcpsm6_opcode <= "SUB " & sx_decode & ", " & sy_decode & "         ";
      when "011001" => kcpsm6_opcode <= "SUB " & sx_decode & ", " & kk_decode & "         ";
      when "011010" => kcpsm6_opcode <= "SUBCY " & sx_decode & ", " & sy_decode & "       ";
      when "011011" => kcpsm6_opcode <= "SUBCY " & sx_decode & ", " & kk_decode & "       ";
      when "011100" => kcpsm6_opcode <= "COMPARE " & sx_decode & ", " & sy_decode & "     ";
      when "011101" => kcpsm6_opcode <= "COMPARE " & sx_decode & ", " & kk_decode & "     ";
      when "011110" => kcpsm6_opcode <= "COMPARECY " & sx_decode & ", " & sy_decode & "   ";
      when "011111" => kcpsm6_opcode <= "COMPARECY " & sx_decode & ", " & kk_decode & "   ";
      when "010100" =>
        if instruction(7) = '1' then
          kcpsm6_opcode <= "HWBUILD " & sx_decode & "         ";
         else
          case instruction(3 downto 0) is
            when "0110" => kcpsm6_opcode <= "SL0 " & sx_decode & "             ";
            when "0111" => kcpsm6_opcode <= "SL1 " & sx_decode & "             ";
            when "0100" => kcpsm6_opcode <= "SLX " & sx_decode & "             ";
            when "0000" => kcpsm6_opcode <= "SLA " & sx_decode & "             ";
            when "0010" => kcpsm6_opcode <= "RL " & sx_decode & "              ";
            when "1110" => kcpsm6_opcode <= "SR0 " & sx_decode & "             ";
            when "1111" => kcpsm6_opcode <= "SR1 " & sx_decode & "             ";
            when "1010" => kcpsm6_opcode <= "SRX " & sx_decode & "             ";
            when "1000" => kcpsm6_opcode <= "SRA " & sx_decode & "             ";
            when "1100" => kcpsm6_opcode <= "RR " & sx_decode & "              ";
            when others => kcpsm6_opcode <= "Invalid Instruction";
          end case;
         end if;
      when "101100" => kcpsm6_opcode <= "OUTPUT " & sx_decode & ", (" & sy_decode & ")    ";
      when "101101" => kcpsm6_opcode <= "OUTPUT " & sx_decode & ", " & kk_decode & "      ";
      when "101011" => kcpsm6_opcode <= "OUTPUTK " & aaa_decode(1) & aaa_decode(2)
                                                          & ", " & aaa_decode(3) & "      ";
      when "001000" => kcpsm6_opcode <= "INPUT " & sx_decode & ", (" & sy_decode & ")     ";
      when "001001" => kcpsm6_opcode <= "INPUT " & sx_decode & ", " & kk_decode & "       ";
      when "101110" => kcpsm6_opcode <= "STORE " & sx_decode & ", (" & sy_decode & ")     ";
      when "101111" => kcpsm6_opcode <= "STORE " & sx_decode & ", " & kk_decode & "       ";
      when "001010" => kcpsm6_opcode <= "FETCH " & sx_decode & ", (" & sy_decode & ")     ";
      when "001011" => kcpsm6_opcode <= "FETCH " & sx_decode & ", " & kk_decode & "       ";
      when "100010" => kcpsm6_opcode <= "JUMP " & aaa_decode & "           ";
      when "110010" => kcpsm6_opcode <= "JUMP Z, " & aaa_decode & "        ";
      when "110110" => kcpsm6_opcode <= "JUMP NZ, " & aaa_decode & "       ";
      when "111010" => kcpsm6_opcode <= "JUMP C, " & aaa_decode & "        ";
      when "111110" => kcpsm6_opcode <= "JUMP NC, " & aaa_decode & "       ";
      when "100110" => kcpsm6_opcode <= "JUMP@ (" & sx_decode & ", " & sy_decode & ")     ";
      when "100000" => kcpsm6_opcode <= "CALL " & aaa_decode & "           ";
      when "110000" => kcpsm6_opcode <= "CALL Z, " & aaa_decode & "        ";
      when "110100" => kcpsm6_opcode <= "CALL NZ, " & aaa_decode & "       ";
      when "111000" => kcpsm6_opcode <= "CALL C, " & aaa_decode & "        ";
      when "111100" => kcpsm6_opcode <= "CALL NC, " & aaa_decode & "       ";
      when "100100" => kcpsm6_opcode <= "CALL@ (" & sx_decode & ", " & sy_decode & ")     ";
      when "100101" => kcpsm6_opcode <= "RETURN             ";
      when "110001" => kcpsm6_opcode <= "RETURN Z           ";
      when "110101" => kcpsm6_opcode <= "RETURN NZ          ";
      when "111001" => kcpsm6_opcode <= "RETURN C           ";
      when "111101" => kcpsm6_opcode <= "RETURN NC          ";
      when "100001" => kcpsm6_opcode <= "LOAD&RETURN " & sx_decode & ", " & kk_decode & " ";
      when "101001" =>
        case instruction(0) is
          when '0' => kcpsm6_opcode <= "RETURNI DISABLE    ";
          when '1' => kcpsm6_opcode <= "RETURNI ENABLE     ";
          when others => kcpsm6_opcode <= "Invalid Instruction";
        end case;
      when "101000" =>
        case instruction(0) is
          when '0' => kcpsm6_opcode <= "DISABLE INTERRUPT  ";
          when '1' => kcpsm6_opcode <= "ENABLE INTERRUPT   ";
          when others => kcpsm6_opcode <= "Invalid Instruction";
        end case;
      when "110111" =>
        case instruction(0) is
          when '0' => kcpsm6_opcode <= "REGBANK A          ";
          when '1' => kcpsm6_opcode <= "REGBANK B          ";
          when others => kcpsm6_opcode <= "Invalid Instruction";
        end case;
      when others => kcpsm6_opcode <= "Invalid Instruction";
    end case;



    -- Flag status information
    
    if zero_flag = '0' then
      kcpsm6_status(3 to 5) <= "NZ,";
     else
      kcpsm6_status(3 to 5) <= " Z,";
    end if;

    if carry_flag = '0' then
      kcpsm6_status(6 to 8) <= "NC,";
     else
      kcpsm6_status(6 to 8) <= " C,";
    end if;

    if interrupt_enable = '0' then
      kcpsm6_status(9 to 10) <= "ID";
     else
      kcpsm6_status(9 to 10) <= "IE";
    end if;

    -- Operational status 

    if clk'event and clk = '1' then 
      if internal_reset = '1' then
        kcpsm6_status(11 to 16) <= ",Reset";
       else
        if sync_sleep = '1' and t_state = "00" then
          kcpsm6_status(11 to 16) <= ",Sleep";
         else
          kcpsm6_status(11 to 16) <= "      ";
        end if;
      end if;
    end if;


    -- Simulation of register contents
    if clk'event and clk = '1' then 
      if register_enable = '1' then
        case sx_addr is
          when "00000" => bank_a_s0 := alu_result;
          when "00001" => bank_a_s1 := alu_result;
          when "00010" => bank_a_s2 := alu_result;
          when "00011" => bank_a_s3 := alu_result;
          when "00100" => bank_a_s4 := alu_result;
          when "00101" => bank_a_s5 := alu_result;
          when "00110" => bank_a_s6 := alu_result;
          when "00111" => bank_a_s7 := alu_result;
          when "01000" => bank_a_s8 := alu_result;
          when "01001" => bank_a_s9 := alu_result;
          when "01010" => bank_a_sa := alu_result;
          when "01011" => bank_a_sb := alu_result;
          when "01100" => bank_a_sc := alu_result;
          when "01101" => bank_a_sd := alu_result;
          when "01110" => bank_a_se := alu_result;
          when "01111" => bank_a_sf := alu_result;
          when "10000" => bank_b_s0 := alu_result;
          when "10001" => bank_b_s1 := alu_result;
          when "10010" => bank_b_s2 := alu_result;
          when "10011" => bank_b_s3 := alu_result;
          when "10100" => bank_b_s4 := alu_result;
          when "10101" => bank_b_s5 := alu_result;
          when "10110" => bank_b_s6 := alu_result;
          when "10111" => bank_b_s7 := alu_result;
          when "11000" => bank_b_s8 := alu_result;
          when "11001" => bank_b_s9 := alu_result;
          when "11010" => bank_b_sa := alu_result;
          when "11011" => bank_b_sb := alu_result;
          when "11100" => bank_b_sc := alu_result;
          when "11101" => bank_b_sd := alu_result;
          when "11110" => bank_b_se := alu_result;
          when "11111" => bank_b_sf := alu_result;
          when others => null;
        end case;
      end if;

      --simulation of scratch pad memory contents
      if spm_enable = '1' then
        case sy_or_kk is
          when "00000000" => sim_spm00 <= sx;
          when "00000001" => sim_spm01 <= sx;
          when "00000010" => sim_spm02 <= sx;
          when "00000011" => sim_spm03 <= sx;
          when "00000100" => sim_spm04 <= sx;
          when "00000101" => sim_spm05 <= sx;
          when "00000110" => sim_spm06 <= sx;
          when "00000111" => sim_spm07 <= sx;
          when "00001000" => sim_spm08 <= sx;
          when "00001001" => sim_spm09 <= sx;
          when "00001010" => sim_spm0A <= sx;
          when "00001011" => sim_spm0B <= sx;
          when "00001100" => sim_spm0C <= sx;
          when "00001101" => sim_spm0D <= sx;
          when "00001110" => sim_spm0E <= sx;
          when "00001111" => sim_spm0F <= sx;
          when "00010000" => sim_spm10 <= sx;
          when "00010001" => sim_spm11 <= sx;
          when "00010010" => sim_spm12 <= sx;
          when "00010011" => sim_spm13 <= sx;
          when "00010100" => sim_spm14 <= sx;
          when "00010101" => sim_spm15 <= sx;
          when "00010110" => sim_spm16 <= sx;
          when "00010111" => sim_spm17 <= sx;
          when "00011000" => sim_spm18 <= sx;
          when "00011001" => sim_spm19 <= sx;
          when "00011010" => sim_spm1A <= sx;
          when "00011011" => sim_spm1B <= sx;
          when "00011100" => sim_spm1C <= sx;
          when "00011101" => sim_spm1D <= sx;
          when "00011110" => sim_spm1E <= sx;
          when "00011111" => sim_spm1F <= sx;
          when "00100000" => sim_spm20 <= sx;
          when "00100001" => sim_spm21 <= sx;
          when "00100010" => sim_spm22 <= sx;
          when "00100011" => sim_spm23 <= sx;
          when "00100100" => sim_spm24 <= sx;
          when "00100101" => sim_spm25 <= sx;
          when "00100110" => sim_spm26 <= sx;
          when "00100111" => sim_spm27 <= sx;
          when "00101000" => sim_spm28 <= sx;
          when "00101001" => sim_spm29 <= sx;
          when "00101010" => sim_spm2A <= sx;
          when "00101011" => sim_spm2B <= sx;
          when "00101100" => sim_spm2C <= sx;
          when "00101101" => sim_spm2D <= sx;
          when "00101110" => sim_spm2E <= sx;
          when "00101111" => sim_spm2F <= sx;
          when "00110000" => sim_spm30 <= sx;
          when "00110001" => sim_spm31 <= sx;
          when "00110010" => sim_spm32 <= sx;
          when "00110011" => sim_spm33 <= sx;
          when "00110100" => sim_spm34 <= sx;
          when "00110101" => sim_spm35 <= sx;
          when "00110110" => sim_spm36 <= sx;
          when "00110111" => sim_spm37 <= sx;
          when "00111000" => sim_spm38 <= sx;
          when "00111001" => sim_spm39 <= sx;
          when "00111010" => sim_spm3A <= sx;
          when "00111011" => sim_spm3B <= sx;
          when "00111100" => sim_spm3C <= sx;
          when "00111101" => sim_spm3D <= sx;
          when "00111110" => sim_spm3E <= sx;
          when "00111111" => sim_spm3F <= sx;
          when "01000000" => sim_spm40 <= sx;
          when "01000001" => sim_spm41 <= sx;
          when "01000010" => sim_spm42 <= sx;
          when "01000011" => sim_spm43 <= sx;
          when "01000100" => sim_spm44 <= sx;
          when "01000101" => sim_spm45 <= sx;
          when "01000110" => sim_spm46 <= sx;
          when "01000111" => sim_spm47 <= sx;
          when "01001000" => sim_spm48 <= sx;
          when "01001001" => sim_spm49 <= sx;
          when "01001010" => sim_spm4A <= sx;
          when "01001011" => sim_spm4B <= sx;
          when "01001100" => sim_spm4C <= sx;
          when "01001101" => sim_spm4D <= sx;
          when "01001110" => sim_spm4E <= sx;
          when "01001111" => sim_spm4F <= sx;
          when "01010000" => sim_spm50 <= sx;
          when "01010001" => sim_spm51 <= sx;
          when "01010010" => sim_spm52 <= sx;
          when "01010011" => sim_spm53 <= sx;
          when "01010100" => sim_spm54 <= sx;
          when "01010101" => sim_spm55 <= sx;
          when "01010110" => sim_spm56 <= sx;
          when "01010111" => sim_spm57 <= sx;
          when "01011000" => sim_spm58 <= sx;
          when "01011001" => sim_spm59 <= sx;
          when "01011010" => sim_spm5A <= sx;
          when "01011011" => sim_spm5B <= sx;
          when "01011100" => sim_spm5C <= sx;
          when "01011101" => sim_spm5D <= sx;
          when "01011110" => sim_spm5E <= sx;
          when "01011111" => sim_spm5F <= sx;
          when "01100000" => sim_spm60 <= sx;
          when "01100001" => sim_spm61 <= sx;
          when "01100010" => sim_spm62 <= sx;
          when "01100011" => sim_spm63 <= sx;
          when "01100100" => sim_spm64 <= sx;
          when "01100101" => sim_spm65 <= sx;
          when "01100110" => sim_spm66 <= sx;
          when "01100111" => sim_spm67 <= sx;
          when "01101000" => sim_spm68 <= sx;
          when "01101001" => sim_spm69 <= sx;
          when "01101010" => sim_spm6A <= sx;
          when "01101011" => sim_spm6B <= sx;
          when "01101100" => sim_spm6C <= sx;
          when "01101101" => sim_spm6D <= sx;
          when "01101110" => sim_spm6E <= sx;
          when "01101111" => sim_spm6F <= sx;
          when "01110000" => sim_spm70 <= sx;
          when "01110001" => sim_spm71 <= sx;
          when "01110010" => sim_spm72 <= sx;
          when "01110011" => sim_spm73 <= sx;
          when "01110100" => sim_spm74 <= sx;
          when "01110101" => sim_spm75 <= sx;
          when "01110110" => sim_spm76 <= sx;
          when "01110111" => sim_spm77 <= sx;
          when "01111000" => sim_spm78 <= sx;
          when "01111001" => sim_spm79 <= sx;
          when "01111010" => sim_spm7A <= sx;
          when "01111011" => sim_spm7B <= sx;
          when "01111100" => sim_spm7C <= sx;
          when "01111101" => sim_spm7D <= sx;
          when "01111110" => sim_spm7E <= sx;
          when "01111111" => sim_spm7F <= sx;
          when "10000000" => sim_spm80 <= sx;
          when "10000001" => sim_spm81 <= sx;
          when "10000010" => sim_spm82 <= sx;
          when "10000011" => sim_spm83 <= sx;
          when "10000100" => sim_spm84 <= sx;
          when "10000101" => sim_spm85 <= sx;
          when "10000110" => sim_spm86 <= sx;
          when "10000111" => sim_spm87 <= sx;
          when "10001000" => sim_spm88 <= sx;
          when "10001001" => sim_spm89 <= sx;
          when "10001010" => sim_spm8A <= sx;
          when "10001011" => sim_spm8B <= sx;
          when "10001100" => sim_spm8C <= sx;
          when "10001101" => sim_spm8D <= sx;
          when "10001110" => sim_spm8E <= sx;
          when "10001111" => sim_spm8F <= sx;
          when "10010000" => sim_spm90 <= sx;
          when "10010001" => sim_spm91 <= sx;
          when "10010010" => sim_spm92 <= sx;
          when "10010011" => sim_spm93 <= sx;
          when "10010100" => sim_spm94 <= sx;
          when "10010101" => sim_spm95 <= sx;
          when "10010110" => sim_spm96 <= sx;
          when "10010111" => sim_spm97 <= sx;
          when "10011000" => sim_spm98 <= sx;
          when "10011001" => sim_spm99 <= sx;
          when "10011010" => sim_spm9A <= sx;
          when "10011011" => sim_spm9B <= sx;
          when "10011100" => sim_spm9C <= sx;
          when "10011101" => sim_spm9D <= sx;
          when "10011110" => sim_spm9E <= sx;
          when "10011111" => sim_spm9F <= sx;
          when "10100000" => sim_spma0 <= sx;
          when "10100001" => sim_spmA1 <= sx;
          when "10100010" => sim_spmA2 <= sx;
          when "10100011" => sim_spmA3 <= sx;
          when "10100100" => sim_spmA4 <= sx;
          when "10100101" => sim_spmA5 <= sx;
          when "10100110" => sim_spmA6 <= sx;
          when "10100111" => sim_spmA7 <= sx;
          when "10101000" => sim_spmA8 <= sx;
          when "10101001" => sim_spmA9 <= sx;
          when "10101010" => sim_spmAA <= sx;
          when "10101011" => sim_spmAB <= sx;
          when "10101100" => sim_spmAC <= sx;
          when "10101101" => sim_spmAD <= sx;
          when "10101110" => sim_spmAE <= sx;
          when "10101111" => sim_spmAF <= sx;
          when "10110000" => sim_spmB0 <= sx;
          when "10110001" => sim_spmB1 <= sx;
          when "10110010" => sim_spmB2 <= sx;
          when "10110011" => sim_spmB3 <= sx;
          when "10110100" => sim_spmB4 <= sx;
          when "10110101" => sim_spmB5 <= sx;
          when "10110110" => sim_spmB6 <= sx;
          when "10110111" => sim_spmB7 <= sx;
          when "10111000" => sim_spmB8 <= sx;
          when "10111001" => sim_spmB9 <= sx;
          when "10111010" => sim_spmBA <= sx;
          when "10111011" => sim_spmBB <= sx;
          when "10111100" => sim_spmBC <= sx;
          when "10111101" => sim_spmBD <= sx;
          when "10111110" => sim_spmBE <= sx;
          when "10111111" => sim_spmBF <= sx;
          when "11000000" => sim_spmC0 <= sx;
          when "11000001" => sim_spmC1 <= sx;
          when "11000010" => sim_spmC2 <= sx;
          when "11000011" => sim_spmC3 <= sx;
          when "11000100" => sim_spmC4 <= sx;
          when "11000101" => sim_spmC5 <= sx;
          when "11000110" => sim_spmC6 <= sx;
          when "11000111" => sim_spmC7 <= sx;
          when "11001000" => sim_spmC8 <= sx;
          when "11001001" => sim_spmC9 <= sx;
          when "11001010" => sim_spmCA <= sx;
          when "11001011" => sim_spmCB <= sx;
          when "11001100" => sim_spmCC <= sx;
          when "11001101" => sim_spmCD <= sx;
          when "11001110" => sim_spmCE <= sx;
          when "11001111" => sim_spmCF <= sx;
          when "11010000" => sim_spmD0 <= sx;
          when "11010001" => sim_spmD1 <= sx;
          when "11010010" => sim_spmD2 <= sx;
          when "11010011" => sim_spmD3 <= sx;
          when "11010100" => sim_spmD4 <= sx;
          when "11010101" => sim_spmD5 <= sx;
          when "11010110" => sim_spmD6 <= sx;
          when "11010111" => sim_spmD7 <= sx;
          when "11011000" => sim_spmD8 <= sx;
          when "11011001" => sim_spmD9 <= sx;
          when "11011010" => sim_spmDA <= sx;
          when "11011011" => sim_spmDB <= sx;
          when "11011100" => sim_spmDC <= sx;
          when "11011101" => sim_spmDD <= sx;
          when "11011110" => sim_spmDE <= sx;
          when "11011111" => sim_spmDF <= sx;
          when "11100000" => sim_spmE0 <= sx;
          when "11100001" => sim_spmE1 <= sx;
          when "11100010" => sim_spmE2 <= sx;
          when "11100011" => sim_spmE3 <= sx;
          when "11100100" => sim_spmE4 <= sx;
          when "11100101" => sim_spmE5 <= sx;
          when "11100110" => sim_spmE6 <= sx;
          when "11100111" => sim_spmE7 <= sx;
          when "11101000" => sim_spmE8 <= sx;
          when "11101001" => sim_spmE9 <= sx;
          when "11101010" => sim_spmEA <= sx;
          when "11101011" => sim_spmEB <= sx;
          when "11101100" => sim_spmEC <= sx;
          when "11101101" => sim_spmED <= sx;
          when "11101110" => sim_spmEE <= sx;
          when "11101111" => sim_spmEF <= sx;
          when "11110000" => sim_spmF0 <= sx;
          when "11110001" => sim_spmF1 <= sx;
          when "11110010" => sim_spmF2 <= sx;
          when "11110011" => sim_spmF3 <= sx;
          when "11110100" => sim_spmF4 <= sx;
          when "11110101" => sim_spmF5 <= sx;
          when "11110110" => sim_spmF6 <= sx;
          when "11110111" => sim_spmF7 <= sx;
          when "11111000" => sim_spmF8 <= sx;
          when "11111001" => sim_spmF9 <= sx;
          when "11111010" => sim_spmFA <= sx;
          when "11111011" => sim_spmFB <= sx;
          when "11111100" => sim_spmFC <= sx;
          when "11111101" => sim_spmFD <= sx;
          when "11111110" => sim_spmFE <= sx;
          when "11111111" => sim_spmFF <= sx;
          when others => null;
        end case;
      end if;

    end if;

    --
    -- Assignment of internal register variables to active registers 
    --
    if bank = '0' then
      kcpsm6_status(1 to 2) <= "A,";
      sim_s0 <= bank_a_s0;
      sim_s1 <= bank_a_s1;
      sim_s2 <= bank_a_s2;
      sim_s3 <= bank_a_s3;
      sim_s4 <= bank_a_s4;
      sim_s5 <= bank_a_s5;
      sim_s6 <= bank_a_s6;
      sim_s7 <= bank_a_s7;
      sim_s8 <= bank_a_s8;
      sim_s9 <= bank_a_s9;
      sim_sA <= bank_a_sA;
      sim_sB <= bank_a_sB;
      sim_sC <= bank_a_sC;
      sim_sD <= bank_a_sD;
      sim_sE <= bank_a_sE;
      sim_sF <= bank_a_sF;
     else
      kcpsm6_status(1 to 2) <= "B,";
      sim_s0 <= bank_b_s0;
      sim_s1 <= bank_b_s1;
      sim_s2 <= bank_b_s2;
      sim_s3 <= bank_b_s3;
      sim_s4 <= bank_b_s4;
      sim_s5 <= bank_b_s5;
      sim_s6 <= bank_b_s6;
      sim_s7 <= bank_b_s7;
      sim_s8 <= bank_b_s8;
      sim_s9 <= bank_b_s9;
      sim_sA <= bank_b_sA;
      sim_sB <= bank_b_sB;
      sim_sC <= bank_b_sC;
      sim_sD <= bank_b_sD;
      sim_sE <= bank_b_sE;
      sim_sF <= bank_b_sF;
    end if;

    --
  end process simulation;
  
  --synthesis translate on
--
-- **************************
-- * End of simulation code *
-- **************************
--
--
-------------------------------------------------------------------------------------------
--
end low_level_definition;
--
-------------------------------------------------------------------------------------------
--
-- END OF FILE kcpsm6.vhd
--
-------------------------------------------------------------------------------------------
