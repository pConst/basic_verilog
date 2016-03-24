//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2010-2014, Xilinx, Inc.
// This file contains confidential and proprietary information of Xilinx, Inc. and is
// protected under U.S. and international copyright and other intellectual property laws.
///////////////////////////////////////////////////////////////////////////////////////////
//
// Disclaimer:
// This disclaimer is not a license and does not grant any rights to the materials
// distributed herewith. Except as otherwise provided in a valid license issued to
// you by Xilinx, and to the maximum extent permitted by applicable law: [1] THESE
// MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
// DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
// INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
// OR FITNESS FOR ANY PARTICULAR PURPOSE; and [2] Xilinx shall not be liable
// (whether in contract or tort, including negligence, or under any other theory
// of liability) for any loss or damage of any kind or nature related to, arising
// under or in connection with these materials, including for any direct, or any
// indirect, special, incidental, or consequential loss or damage (including loss
// of data, profits, goodwill, or any type of loss or damage suffered as a result
// of any action brought by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-safe, or for use in any
// application requiring fail-safe performance, such as life-support or safety
// devices or systems, Class III medical devices, nuclear facilities, applications
// related to the deployment of airbags, or any other applications that could lead
// to death, personal injury, or severe property or environmental damage
// (individually and collectively, "Critical Applications)). Customer assumes the
// sole risk and liability of any use of Xilinx products in Critical Applications,
// subject only to applicable laws and regulations governing limitations on product
// liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// KCPSM6 - PicoBlaze for Spartan-6 and Virtex-6 devices.
//
// Version 1.1 - 4th March 2010. 
//               Derived from kcpsm6.vhd Version 1.1 (9th February 2011) by Nick Sawyer.
// Version 1.2 - 4th October 2012. 
//               Addition of WebTalk information.
// Version 1.3 - 21st May 2014. 
//               Disassembly of 'STAR sX, kk' instruction added to the simulation
//               code. No changes to functionality or the physical implementation.
//
// Ken Chapman
// Xilinx Ltd
// Benchmark House
// 203 Brooklands Road
// Weybridge
// Surrey KT13 ORH
// United Kingdom
//
// chapman@xilinx.com
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Format of this file.
//
// The module defines the implementation of the logic using Xilinx primitives.
// These ensure predictable synthesis results and maximise the density of the implementation. 
// The Unisim Library is used to define Xilinx primitives. It is also used during
// simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
// 
///////////////////////////////////////////////////////////////////////////////////////////
//
`timescale 1ps/1ps
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Main Entity for kcpsm6 with WebTalk Attributes
//
(* CORE_GENERATION_INFO = "kcpsm6,kcpsm6_v1_3,{component_name=kcpsm6}" *)
module kcpsm6 (address, instruction, bram_enable, in_port, out_port, port_id, write_strobe, k_write_strobe, read_strobe, interrupt, interrupt_ack, sleep, reset, clk) ;

parameter [7:0] 	hwbuild = 8'h00 ;
parameter [11:0] 	interrupt_vector = 12'h3FF ;
parameter integer scratch_pad_memory_size = 64 ;   

output [11:0]	address ;
input	 [17:0]    	instruction ;
output		bram_enable ;
input	 [7:0]	in_port ;
output [7:0]	out_port ;
output [7:0]	port_id ;
output		write_strobe ;
output		k_write_strobe ;
output		read_strobe ;
input			interrupt ;
output		interrupt_ack ;
input			sleep ;
input			reset ;
input			clk ;
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Start of Main Architecture for kcpsm6
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Signals used in kcpsm6
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// State Machine and Interrupt
//	 
wire	[2:1]		t_state_value ;
wire	[2:1]		t_state ;
wire 			run_value ;
wire              run ;
wire  		internal_reset_value ;
wire 			internal_reset ;
wire 			sync_sleep ;
wire 			int_enable_type ;
wire 			interrupt_enable_value ;
wire			interrupt_enable ;
wire			sync_interrupt ;
wire 			active_interrupt_value ;
wire 			active_interrupt ;
//
// Arithmetic and Logical Functions
//	 
wire	[2:0]		arith_logical_sel ;
wire			arith_carry_in ;
wire			arith_carry_value ;
wire			arith_carry ;
wire 	[7:0]		half_arith_logical ;
wire 	[7:0]		logical_carry_mask ;
wire 	[7:0]		carry_arith_logical ;
wire 	[7:0]		arith_logical_value ;
wire 	[7:0]		arith_logical_result ;
//
// Shift and Rotate Functions
//	 
wire 	[7:0]		shift_rotate_value ;
wire 	[7:0]		shift_rotate_result ;
wire			shift_in_bit ;
//
// ALU structure
//	 
wire 	[7:0]		alu_result ;
wire 	[1:0]		alu_mux_sel_value ;
wire 	[1:0]		alu_mux_sel ;
//
// Strobes
//	
wire			strobe_type ;
wire 			write_strobe_value ;
wire 			k_write_strobe_value ;
wire			read_strobe_value ;
//
// Flags
//	
wire			flag_enable_type ;
wire			flag_enable_value ;
wire			flag_enable ; 
wire			lower_parity ;
wire			lower_parity_sel ;
wire			carry_lower_parity ;
wire 			upper_parity ;
wire			parity ;
wire			shift_carry_value ;
wire			shift_carry ;
wire			carry_flag_value ;
wire			carry_flag ;

wire 			use_zero_flag_value ;
wire			use_zero_flag ;
wire 			drive_carry_in_zero ;
wire          	carry_in_zero ;
wire             	lower_zero ;
wire         	lower_zero_sel ;
wire       		carry_lower_zero ;
wire           	middle_zero ;
wire        	middle_zero_sel ;
wire      		carry_middle_zero ;
wire         	upper_zero_sel ;
wire        	zero_flag_value ;
wire              zero_flag ;
//
// Scratch Pad Memory
//	 
wire       		spm_enable_value ;
wire             	spm_enable ;
wire 	[7:0]		spm_ram_data ;
wire 	[7:0]		spm_data  ;
//
// Registers
//	 
wire           	regbank_type ;
wire             	bank_value ;
wire              bank ;
wire          	loadstar_type ;
wire         	sx_addr4_value ;
wire   		register_enable_type ;
wire  		register_enable_value ;
wire        	register_enable ;
wire 	[4:0]		sx_addr ;
wire 	[4:0]		sy_addr ;
wire 	[7:0]		sx ;
wire 	[7:0]		sy ;
//
// Second Operand 
//	 
wire 	[7:0]		sy_or_kk ;
//
// Program Counter 
//	 
wire       		pc_move_is_valid ;
wire              move_type ;
wire           	returni_type ;
wire 	[2:0]		pc_mode ;
wire 	[11:0]	register_vector ;
wire 	[11:0]	half_pc ;
wire 	[10:0]	carry_pc ;
wire 	[11:0]	pc_value ;
wire 	[11:0]	pc ;
wire 	[11:0]	pc_vector ;
//
// Program Counter Stack 
//	 
wire             	push_stack ;
wire              pop_stack ;
wire 	[11:0]	stack_memory ;
wire 	[11:0]	return_vector ;
wire       		stack_carry_flag ;
wire      		shadow_carry_flag ;
wire        	stack_zero_flag ;
wire      		shadow_zero_value ;
wire       		shadow_zero_flag ;
wire             	stack_bank ;
wire            	shadow_bank ;
wire              stack_bit ;
wire            	special_bit ;
wire 	[4:0]		half_pointer_value ;
wire 	[4:0]		feed_pointer_value ;
wire 	[4:0]		stack_pointer_carry ;
wire 	[4:0]		stack_pointer_value ;
wire 	[4:0]		stack_pointer ;
//
//
//
//**********************************************************************************
//
// Signals between these *** lines are only made visible during simulation 
//
//synthesis translate_off
//
reg	[1:152]	kcpsm6_opcode ;
reg	[1:128]	kcpsm6_status ;
reg	[7:0]	      sim_s0 ;
reg	[7:0]	      sim_s1 ;
reg	[7:0]	      sim_s2 ;
reg	[7:0]	      sim_s3 ;
reg	[7:0]	      sim_s4 ;
reg	[7:0]	      sim_s5 ;
reg	[7:0]	      sim_s6 ;
reg	[7:0]	      sim_s7 ;
reg	[7:0]	      sim_s8 ;
reg	[7:0]	      sim_s9 ;
reg	[7:0]	      sim_sA ;
reg	[7:0]	      sim_sB ;
reg	[7:0]	      sim_sC ;
reg	[7:0]	      sim_sD ;
reg	[7:0]	      sim_sE ;
reg	[7:0]	      sim_sF ;
reg	[7:0]	     	sim_spm00 ;
reg	[7:0]		sim_spm01 ;
reg	[7:0]		sim_spm02 ;
reg	[7:0]		sim_spm03 ;
reg	[7:0]		sim_spm04 ;
reg	[7:0]		sim_spm05 ;
reg	[7:0]		sim_spm06 ;
reg	[7:0]		sim_spm07 ;
reg	[7:0]		sim_spm08 ;
reg	[7:0]		sim_spm09 ;
reg	[7:0]		sim_spm0A ;
reg	[7:0]		sim_spm0B ;
reg	[7:0]		sim_spm0C ;
reg	[7:0]		sim_spm0D ;
reg	[7:0]		sim_spm0E ;
reg	[7:0]		sim_spm0F ;
reg	[7:0]		sim_spm10 ;
reg	[7:0]		sim_spm11 ;
reg	[7:0]		sim_spm12 ;
reg	[7:0]		sim_spm13 ;
reg	[7:0]		sim_spm14 ;
reg	[7:0]		sim_spm15 ;
reg	[7:0]		sim_spm16 ;
reg	[7:0]		sim_spm17 ;
reg	[7:0]		sim_spm18 ;
reg	[7:0]		sim_spm19 ;
reg	[7:0]		sim_spm1A ;
reg	[7:0]		sim_spm1B ;
reg	[7:0]		sim_spm1C ;
reg	[7:0]		sim_spm1D ;
reg	[7:0]		sim_spm1E ;
reg	[7:0]		sim_spm1F ;
reg	[7:0]		sim_spm20 ;
reg	[7:0]		sim_spm21 ;
reg	[7:0]		sim_spm22 ;
reg	[7:0]		sim_spm23 ;
reg	[7:0]		sim_spm24 ;
reg	[7:0]		sim_spm25 ;
reg	[7:0]		sim_spm26 ;
reg	[7:0]		sim_spm27 ;
reg	[7:0]		sim_spm28 ;
reg	[7:0]		sim_spm29 ;
reg	[7:0]		sim_spm2A ;
reg	[7:0]		sim_spm2B ;
reg	[7:0]		sim_spm2C ;
reg	[7:0]		sim_spm2D ;
reg	[7:0]		sim_spm2E ;
reg	[7:0]		sim_spm2F ;
reg	[7:0]		sim_spm30 ;
reg	[7:0]		sim_spm31 ;
reg	[7:0]		sim_spm32 ;
reg	[7:0]		sim_spm33 ;
reg	[7:0]		sim_spm34 ;
reg	[7:0]		sim_spm35 ;
reg	[7:0]		sim_spm36 ;
reg	[7:0]		sim_spm37 ;
reg	[7:0]		sim_spm38 ;
reg	[7:0]		sim_spm39 ;
reg	[7:0]		sim_spm3A ;
reg	[7:0]		sim_spm3B ;
reg	[7:0]		sim_spm3C ;
reg	[7:0]		sim_spm3D ;
reg	[7:0]		sim_spm3E ;
reg	[7:0]		sim_spm3F ;
reg	[7:0]		sim_spm40 ;
reg	[7:0]		sim_spm41 ;
reg	[7:0]		sim_spm42 ;
reg	[7:0]		sim_spm43 ;
reg	[7:0]		sim_spm44 ;
reg	[7:0]		sim_spm45 ;
reg	[7:0]		sim_spm46 ;
reg	[7:0]		sim_spm47 ;
reg	[7:0]		sim_spm48 ;
reg	[7:0]		sim_spm49 ;
reg	[7:0]		sim_spm4A ;
reg	[7:0]		sim_spm4B ;
reg	[7:0]		sim_spm4C ;
reg	[7:0]		sim_spm4D ;
reg	[7:0]		sim_spm4E ;
reg	[7:0]		sim_spm4F ;
reg	[7:0]		sim_spm50 ;
reg	[7:0]		sim_spm51 ;
reg	[7:0]		sim_spm52 ;
reg	[7:0]		sim_spm53 ;
reg	[7:0]		sim_spm54 ;
reg	[7:0]		sim_spm55 ;
reg	[7:0]		sim_spm56 ;
reg	[7:0]		sim_spm57 ;
reg	[7:0]		sim_spm58 ;
reg	[7:0]		sim_spm59 ;
reg	[7:0]		sim_spm5A ;
reg	[7:0]		sim_spm5B ;
reg	[7:0]		sim_spm5C ;
reg	[7:0]		sim_spm5D ;
reg	[7:0]		sim_spm5E ;
reg	[7:0]		sim_spm5F ;
reg	[7:0]		sim_spm60 ;
reg	[7:0]		sim_spm61 ;
reg	[7:0]		sim_spm62 ;
reg	[7:0]		sim_spm63 ;
reg	[7:0]		sim_spm64 ;
reg	[7:0]		sim_spm65 ;
reg	[7:0]		sim_spm66 ;
reg	[7:0]		sim_spm67 ;
reg	[7:0]		sim_spm68 ;
reg	[7:0]		sim_spm69 ;
reg	[7:0]		sim_spm6A ;
reg	[7:0]		sim_spm6B ;
reg	[7:0]		sim_spm6C ;
reg	[7:0]		sim_spm6D ;
reg	[7:0]		sim_spm6E ;
reg	[7:0]		sim_spm6F ;
reg	[7:0]		sim_spm70 ;
reg	[7:0]		sim_spm71 ;
reg	[7:0]		sim_spm72 ;
reg	[7:0]		sim_spm73 ;
reg	[7:0]		sim_spm74 ;
reg	[7:0]		sim_spm75 ;
reg	[7:0]		sim_spm76 ;
reg	[7:0]		sim_spm77 ;
reg	[7:0]		sim_spm78 ;
reg	[7:0]		sim_spm79 ;
reg	[7:0]		sim_spm7A ;
reg	[7:0]		sim_spm7B ;
reg	[7:0]		sim_spm7C ;
reg	[7:0]		sim_spm7D ;
reg	[7:0]		sim_spm7E ;
reg	[7:0]		sim_spm7F ;
reg	[7:0]		sim_spm80 ;
reg	[7:0]		sim_spm81 ;
reg	[7:0]		sim_spm82 ;
reg	[7:0]		sim_spm83 ;
reg	[7:0]		sim_spm84 ;
reg	[7:0]		sim_spm85 ;
reg	[7:0]		sim_spm86 ;
reg	[7:0]		sim_spm87 ;
reg	[7:0]		sim_spm88 ;
reg	[7:0]		sim_spm89 ;
reg	[7:0]		sim_spm8A ;
reg	[7:0]		sim_spm8B ;
reg	[7:0]		sim_spm8C ;
reg	[7:0]		sim_spm8D ;
reg	[7:0]		sim_spm8E ;
reg	[7:0]		sim_spm8F ;
reg	[7:0]		sim_spm90 ;
reg	[7:0]		sim_spm91 ;
reg	[7:0]		sim_spm92 ;
reg	[7:0]		sim_spm93 ;
reg	[7:0]		sim_spm94 ;
reg	[7:0]		sim_spm95 ;
reg	[7:0]		sim_spm96 ;
reg	[7:0]		sim_spm97 ;
reg	[7:0]		sim_spm98 ;
reg	[7:0]		sim_spm99 ;
reg	[7:0]		sim_spm9A ;
reg	[7:0]		sim_spm9B ;
reg	[7:0]		sim_spm9C ;
reg	[7:0]		sim_spm9D ;
reg	[7:0]		sim_spm9E ;
reg	[7:0]		sim_spm9F ;
reg	[7:0]		sim_spmA0 ;
reg	[7:0]		sim_spmA1 ;
reg	[7:0]		sim_spmA2 ;
reg	[7:0]		sim_spmA3 ;
reg	[7:0]		sim_spmA4 ;
reg	[7:0]		sim_spmA5 ;
reg	[7:0]		sim_spmA6 ;
reg	[7:0]		sim_spmA7 ;
reg	[7:0]		sim_spmA8 ;
reg	[7:0]		sim_spmA9 ;
reg	[7:0]		sim_spmAA ;
reg	[7:0]		sim_spmAB ;
reg	[7:0]		sim_spmAC ;
reg	[7:0]		sim_spmAD ;
reg	[7:0]		sim_spmAE ;
reg	[7:0]		sim_spmAF ;
reg	[7:0]		sim_spmB0 ;
reg	[7:0]		sim_spmB1 ;
reg	[7:0]		sim_spmB2 ;
reg	[7:0]		sim_spmB3 ;
reg	[7:0]		sim_spmB4 ;
reg	[7:0]		sim_spmB5 ;
reg	[7:0]		sim_spmB6 ;
reg	[7:0]		sim_spmB7 ;
reg	[7:0]		sim_spmB8 ;
reg	[7:0]		sim_spmB9 ;
reg	[7:0]		sim_spmBA ;
reg	[7:0]		sim_spmBB ;
reg	[7:0]		sim_spmBC ;
reg	[7:0]		sim_spmBD ;
reg	[7:0]		sim_spmBE ;
reg	[7:0]		sim_spmBF ;
reg	[7:0]		sim_spmC0 ;
reg	[7:0]		sim_spmC1 ;
reg	[7:0]		sim_spmC2 ;
reg	[7:0]		sim_spmC3 ;
reg	[7:0]		sim_spmC4 ;
reg	[7:0]		sim_spmC5 ;
reg	[7:0]		sim_spmC6 ;
reg	[7:0]		sim_spmC7 ;
reg	[7:0]		sim_spmC8 ;
reg	[7:0]		sim_spmC9 ;
reg	[7:0]		sim_spmCA ;
reg	[7:0]		sim_spmCB ;
reg	[7:0]		sim_spmCC ;
reg	[7:0]		sim_spmCD ;
reg	[7:0]		sim_spmCE ;
reg	[7:0]		sim_spmCF ;
reg	[7:0]		sim_spmD0 ;
reg	[7:0]		sim_spmD1 ;
reg	[7:0]		sim_spmD2 ;
reg	[7:0]		sim_spmD3 ;
reg	[7:0]		sim_spmD4 ;
reg	[7:0]		sim_spmD5 ;
reg	[7:0]		sim_spmD6 ;
reg	[7:0]		sim_spmD7 ;
reg	[7:0]		sim_spmD8 ;
reg	[7:0]		sim_spmD9 ;
reg	[7:0]		sim_spmDA ;
reg	[7:0]		sim_spmDB ;
reg	[7:0]		sim_spmDC ;
reg	[7:0]		sim_spmDD ;
reg	[7:0]		sim_spmDE ;
reg	[7:0]		sim_spmDF ;
reg	[7:0]		sim_spmE0 ;
reg	[7:0]		sim_spmE1 ;
reg	[7:0]		sim_spmE2 ;
reg	[7:0]		sim_spmE3 ;
reg	[7:0]		sim_spmE4 ;
reg	[7:0]		sim_spmE5 ;
reg	[7:0]		sim_spmE6 ;
reg	[7:0]		sim_spmE7 ;
reg	[7:0]		sim_spmE8 ;
reg	[7:0]		sim_spmE9 ;
reg	[7:0]		sim_spmEA ;
reg	[7:0]		sim_spmEB ;
reg	[7:0]		sim_spmEC ;
reg	[7:0]		sim_spmED ;
reg	[7:0]		sim_spmEE ;
reg	[7:0]		sim_spmEF ;
reg	[7:0]		sim_spmF0 ;
reg	[7:0]		sim_spmF1 ;
reg	[7:0]		sim_spmF2 ;
reg	[7:0]		sim_spmF3 ;
reg	[7:0]		sim_spmF4 ;
reg	[7:0]		sim_spmF5 ;
reg	[7:0]		sim_spmF6 ;
reg	[7:0]		sim_spmF7 ;
reg	[7:0]		sim_spmF8 ;
reg	[7:0]		sim_spmF9 ;
reg	[7:0]		sim_spmFA ;
reg	[7:0]		sim_spmFB ;
reg	[7:0]		sim_spmFC ;
reg	[7:0]		sim_spmFD ;
reg	[7:0]		sim_spmFE ;
reg	[7:0]		sim_spmFF ;
//
// initialise the values
//
initial begin
kcpsm6_status = "A,NZ,NC,ID,Reset" ;
kcpsm6_opcode = "LOAD s0, s0        " ;

sim_s0 = 8'h00 ;
sim_s1 = 8'h00 ;
sim_s2 = 8'h00 ;
sim_s3 = 8'h00 ;
sim_s4 = 8'h00 ;
sim_s5 = 8'h00 ;
sim_s6 = 8'h00 ;
sim_s7 = 8'h00 ;
sim_s8 = 8'h00 ;
sim_s9 = 8'h00 ;
sim_sA = 8'h00 ;
sim_sB = 8'h00 ;
sim_sC = 8'h00 ;
sim_sD = 8'h00 ;
sim_sE = 8'h00 ;
sim_sF = 8'h00 ;

sim_spm00 = 8'h00 ;
sim_spm01 = 8'h00 ;
sim_spm02 = 8'h00 ;
sim_spm03 = 8'h00 ;
sim_spm04 = 8'h00 ;
sim_spm05 = 8'h00 ;
sim_spm06 = 8'h00 ;
sim_spm07 = 8'h00 ;
sim_spm08 = 8'h00 ;
sim_spm09 = 8'h00 ;
sim_spm0A = 8'h00 ;
sim_spm0B = 8'h00 ;
sim_spm0C = 8'h00 ;
sim_spm0D = 8'h00 ;
sim_spm0E = 8'h00 ;
sim_spm0F = 8'h00 ;
sim_spm10 = 8'h00 ;
sim_spm11 = 8'h00 ;
sim_spm12 = 8'h00 ;
sim_spm13 = 8'h00 ;
sim_spm14 = 8'h00 ;
sim_spm15 = 8'h00 ;
sim_spm16 = 8'h00 ;
sim_spm17 = 8'h00 ;
sim_spm18 = 8'h00 ;
sim_spm19 = 8'h00 ;
sim_spm1A = 8'h00 ;
sim_spm1B = 8'h00 ;
sim_spm1C = 8'h00 ;
sim_spm1D = 8'h00 ;
sim_spm1E = 8'h00 ;
sim_spm1F = 8'h00 ;
sim_spm20 = 8'h00 ;
sim_spm21 = 8'h00 ;
sim_spm22 = 8'h00 ;
sim_spm23 = 8'h00 ;
sim_spm24 = 8'h00 ;
sim_spm25 = 8'h00 ;
sim_spm26 = 8'h00 ;
sim_spm27 = 8'h00 ;
sim_spm28 = 8'h00 ;
sim_spm29 = 8'h00 ;
sim_spm2A = 8'h00 ;
sim_spm2B = 8'h00 ;
sim_spm2C = 8'h00 ;
sim_spm2D = 8'h00 ;
sim_spm2E = 8'h00 ;
sim_spm2F = 8'h00 ;
sim_spm30 = 8'h00 ;
sim_spm31 = 8'h00 ;
sim_spm32 = 8'h00 ;
sim_spm33 = 8'h00 ;
sim_spm34 = 8'h00 ;
sim_spm35 = 8'h00 ;
sim_spm36 = 8'h00 ;
sim_spm37 = 8'h00 ;
sim_spm38 = 8'h00 ;
sim_spm39 = 8'h00 ;
sim_spm3A = 8'h00 ;
sim_spm3B = 8'h00 ;
sim_spm3C = 8'h00 ;
sim_spm3D = 8'h00 ;
sim_spm3E = 8'h00 ;
sim_spm3F = 8'h00 ;
sim_spm40 = 8'h00 ;
sim_spm41 = 8'h00 ;
sim_spm42 = 8'h00 ;
sim_spm43 = 8'h00 ;
sim_spm44 = 8'h00 ;
sim_spm45 = 8'h00 ;
sim_spm46 = 8'h00 ;
sim_spm47 = 8'h00 ;
sim_spm48 = 8'h00 ;
sim_spm49 = 8'h00 ;
sim_spm4A = 8'h00 ;
sim_spm4B = 8'h00 ;
sim_spm4C = 8'h00 ;
sim_spm4D = 8'h00 ;
sim_spm4E = 8'h00 ;
sim_spm4F = 8'h00 ;
sim_spm50 = 8'h00 ;
sim_spm51 = 8'h00 ;
sim_spm52 = 8'h00 ;
sim_spm53 = 8'h00 ;
sim_spm54 = 8'h00 ;
sim_spm55 = 8'h00 ;
sim_spm56 = 8'h00 ;
sim_spm57 = 8'h00 ;
sim_spm58 = 8'h00 ;
sim_spm59 = 8'h00 ;
sim_spm5A = 8'h00 ;
sim_spm5B = 8'h00 ;
sim_spm5C = 8'h00 ;
sim_spm5D = 8'h00 ;
sim_spm5E = 8'h00 ;
sim_spm5F = 8'h00 ;
sim_spm60 = 8'h00 ;
sim_spm61 = 8'h00 ;
sim_spm62 = 8'h00 ;
sim_spm63 = 8'h00 ;
sim_spm64 = 8'h00 ;
sim_spm65 = 8'h00 ;
sim_spm66 = 8'h00 ;
sim_spm67 = 8'h00 ;
sim_spm68 = 8'h00 ;
sim_spm69 = 8'h00 ;
sim_spm6A = 8'h00 ;
sim_spm6B = 8'h00 ;
sim_spm6C = 8'h00 ;
sim_spm6D = 8'h00 ;
sim_spm6E = 8'h00 ;
sim_spm6F = 8'h00 ;
sim_spm70 = 8'h00 ;
sim_spm71 = 8'h00 ;
sim_spm72 = 8'h00 ;
sim_spm73 = 8'h00 ;
sim_spm74 = 8'h00 ;
sim_spm75 = 8'h00 ;
sim_spm76 = 8'h00 ;
sim_spm77 = 8'h00 ;
sim_spm78 = 8'h00 ;
sim_spm79 = 8'h00 ;
sim_spm7A = 8'h00 ;
sim_spm7B = 8'h00 ;
sim_spm7C = 8'h00 ;
sim_spm7D = 8'h00 ;
sim_spm7E = 8'h00 ;
sim_spm7F = 8'h00 ;
sim_spm80 = 8'h00 ;
sim_spm81 = 8'h00 ;
sim_spm82 = 8'h00 ;
sim_spm83 = 8'h00 ;
sim_spm84 = 8'h00 ;
sim_spm85 = 8'h00 ;
sim_spm86 = 8'h00 ;
sim_spm87 = 8'h00 ;
sim_spm88 = 8'h00 ;
sim_spm89 = 8'h00 ;
sim_spm8A = 8'h00 ;
sim_spm8B = 8'h00 ;
sim_spm8C = 8'h00 ;
sim_spm8D = 8'h00 ;
sim_spm8E = 8'h00 ;
sim_spm8F = 8'h00 ;
sim_spm90 = 8'h00 ;
sim_spm91 = 8'h00 ;
sim_spm92 = 8'h00 ;
sim_spm93 = 8'h00 ;
sim_spm94 = 8'h00 ;
sim_spm95 = 8'h00 ;
sim_spm96 = 8'h00 ;
sim_spm97 = 8'h00 ;
sim_spm98 = 8'h00 ;
sim_spm99 = 8'h00 ;
sim_spm9A = 8'h00 ;
sim_spm9B = 8'h00 ;
sim_spm9C = 8'h00 ;
sim_spm9D = 8'h00 ;
sim_spm9E = 8'h00 ;
sim_spm9F = 8'h00 ;
sim_spmA0 = 8'h00 ;
sim_spmA1 = 8'h00 ;
sim_spmA2 = 8'h00 ;
sim_spmA3 = 8'h00 ;
sim_spmA4 = 8'h00 ;
sim_spmA5 = 8'h00 ;
sim_spmA6 = 8'h00 ;
sim_spmA7 = 8'h00 ;
sim_spmA8 = 8'h00 ;
sim_spmA9 = 8'h00 ;
sim_spmAA = 8'h00 ;
sim_spmAB = 8'h00 ;
sim_spmAC = 8'h00 ;
sim_spmAD = 8'h00 ;
sim_spmAE = 8'h00 ;
sim_spmAF = 8'h00 ;
sim_spmB0 = 8'h00 ;
sim_spmB1 = 8'h00 ;
sim_spmB2 = 8'h00 ;
sim_spmB3 = 8'h00 ;
sim_spmB4 = 8'h00 ;
sim_spmB5 = 8'h00 ;
sim_spmB6 = 8'h00 ;
sim_spmB7 = 8'h00 ;
sim_spmB8 = 8'h00 ;
sim_spmB9 = 8'h00 ;
sim_spmBA = 8'h00 ;
sim_spmBB = 8'h00 ;
sim_spmBC = 8'h00 ;
sim_spmBD = 8'h00 ;
sim_spmBE = 8'h00 ;
sim_spmBF = 8'h00 ;
sim_spmC0 = 8'h00 ;
sim_spmC1 = 8'h00 ;
sim_spmC2 = 8'h00 ;
sim_spmC3 = 8'h00 ;
sim_spmC4 = 8'h00 ;
sim_spmC5 = 8'h00 ;
sim_spmC6 = 8'h00 ;
sim_spmC7 = 8'h00 ;
sim_spmC8 = 8'h00 ;
sim_spmC9 = 8'h00 ;
sim_spmCA = 8'h00 ;
sim_spmCB = 8'h00 ;
sim_spmCC = 8'h00 ;
sim_spmCD = 8'h00 ;
sim_spmCE = 8'h00 ;
sim_spmCF = 8'h00 ;
sim_spmD0 = 8'h00 ;
sim_spmD1 = 8'h00 ;
sim_spmD2 = 8'h00 ;
sim_spmD3 = 8'h00 ;
sim_spmD4 = 8'h00 ;
sim_spmD5 = 8'h00 ;
sim_spmD6 = 8'h00 ;
sim_spmD7 = 8'h00 ;
sim_spmD8 = 8'h00 ;
sim_spmD9 = 8'h00 ;
sim_spmDA = 8'h00 ;
sim_spmDB = 8'h00 ;
sim_spmDC = 8'h00 ;
sim_spmDD = 8'h00 ;
sim_spmDE = 8'h00 ;
sim_spmDF = 8'h00 ;
sim_spmE0 = 8'h00 ;
sim_spmE1 = 8'h00 ;
sim_spmE2 = 8'h00 ;
sim_spmE3 = 8'h00 ;
sim_spmE4 = 8'h00 ;
sim_spmE5 = 8'h00 ;
sim_spmE6 = 8'h00 ;
sim_spmE7 = 8'h00 ;
sim_spmE8 = 8'h00 ;
sim_spmE9 = 8'h00 ;
sim_spmEA = 8'h00 ;
sim_spmEB = 8'h00 ;
sim_spmEC = 8'h00 ;
sim_spmED = 8'h00 ;
sim_spmEE = 8'h00 ;
sim_spmEF = 8'h00 ;
sim_spmF0 = 8'h00 ;
sim_spmF1 = 8'h00 ;
sim_spmF2 = 8'h00 ;
sim_spmF3 = 8'h00 ;
sim_spmF4 = 8'h00 ;
sim_spmF5 = 8'h00 ;
sim_spmF6 = 8'h00 ;
sim_spmF7 = 8'h00 ;
sim_spmF8 = 8'h00 ;
sim_spmF9 = 8'h00 ;
sim_spmFA = 8'h00 ;
sim_spmFB = 8'h00 ;
sim_spmFC = 8'h00 ;
sim_spmFD = 8'h00 ;
sim_spmFE = 8'h00 ;
sim_spmFF = 8'h00 ;
end
//
//synthesis translate_on
//
//**********************************************************************************
//
//
///////////////////////////////////////////////////////////////////////////////////////////
//
//	
// Start of kcpsm6 circuit description
//
// Summary of all primitives defined.
//
//     29 x LUT6             79 LUTs
//     50 x LUT6_2
//     48 x FD               82 flip-flops
//     20 x FDR       (Depending on the value of 'hwbuild' up)
//      0 x FDS       (to eight FDR will be replaced by FDS  )          
//     14 x FDRE
//     29 x MUXCY
//     27 x XORCY
//      4 x RAM32M    (16 LUTs)
//
//      2 x RAM64M   or  8 x RAM128X1S   or  8 x RAM256X1S
//       (8 LUTs)          (16 LUTs)           (32 LUTs)
//
///////////////////////////////////////////////////////////////////////////////////////////
//	
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Perform check of generic to report error as soon as possible.
//
///////////////////////////////////////////////////////////////////////////////////////////
//
initial begin
if (scratch_pad_memory_size != 64 && scratch_pad_memory_size != 128 && scratch_pad_memory_size != 256) begin
#1;
$display("\n\nInvalid 'scratch_pad_memory_size'. Please set to 64, 128 or 256.\n\n");
$finish;
end
end
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// State Machine and Control 
//
//
//     1 x LUT6
//     4 x LUT6_2
//     9 x FD
//
///////////////////////////////////////////////////////////////////////////////////////////
//

(* HBLKNM = "kcpsm6_control" *)
LUT6_2 #(
	.INIT	(64'hFFFFF55500000EEE))
reset_lut( 
	.I0 	(run),
	.I1 	(internal_reset),
	.I2 	(stack_pointer_carry[4]),
	.I3 	(t_state[2]),
	.I4 	(reset),
	.I5 	(1'b1),
	.O5 	(run_value),
	.O6 	(internal_reset_value));

(* HBLKNM = "kcpsm6_control" *)
FD run_flop (  
	.D 	(run_value),
	.Q 	(run),
	.C 	(clk));

(* HBLKNM = "kcpsm6_control" *)
FD internal_reset_flop(
	.D	(internal_reset_value),
	.Q	(internal_reset),
	.C	(clk));

(* HBLKNM = "kcpsm6_decode2" *)
FD sync_sleep_flop(
	.D 	(sleep),
	.Q 	(sync_sleep),
	.C 	(clk));

(* HBLKNM = "kcpsm6_control" *)
LUT6_2 #(
	.INIT    (64'h0083000B00C4004C))
t_state_lut( 
	.I0     (t_state[1]),
	.I1     (t_state[2]),
	.I2     (sync_sleep),
	.I3     (internal_reset),
	.I4     (special_bit),
	.I5     (1'b1),
	.O5     (t_state_value[1]),
	.O6     (t_state_value[2]));

(* HBLKNM = "kcpsm6_control" *)
FD t_state1_flop (  
	.D      (t_state_value[1]),
	.Q      (t_state[1]),
	.C      (clk));

(* HBLKNM = "kcpsm6_control" *)
FD t_state2_flop (  
	.D      (t_state_value[2]),
	.Q      (t_state[2]),
	.C      (clk));


(* HBLKNM = "kcpsm6_decode0" *)
LUT6_2 #(
	.INIT	(64'h0010000000000800))
int_enable_type_lut( 
	.I0     (instruction[13]),
	.I1     (instruction[14]),
	.I2     (instruction[15]),
	.I3     (instruction[16]),
	.I4     (instruction[17]),
	.I5     (1'b1),
	.O5     (loadstar_type),
	.O6     (int_enable_type)) ;

(* HBLKNM = "kcpsm6_decode0" *)
LUT6 #(
	.INIT    (64'h000000000000CAAA))
interrupt_enable_lut( 
	.I0     (interrupt_enable),
	.I1     (instruction[0]),
	.I2     (int_enable_type),
	.I3     (t_state[1]),
	.I4     (active_interrupt),
	.I5     (internal_reset),
	.O      (interrupt_enable_value));                     

(* HBLKNM = "kcpsm6_decode0" *)
FD interrupt_enable_flop (  
	.D      (interrupt_enable_value),
	.Q      (interrupt_enable),
	.C      (clk));

(* HBLKNM = "kcpsm6_decode2" *)
FD sync_interrupt_flop (  
	.D      (interrupt),
	.Q      (sync_interrupt),
	.C      (clk));

(* HBLKNM = "kcpsm6_control" *)
LUT6_2 # (
	.INIT    (64'hCC33FF0080808080))
active_interrupt_lut( 
	.I0     (interrupt_enable),
	.I1     (t_state[2]),
	.I2     (sync_interrupt),
	.I3     (bank),
	.I4     (loadstar_type),
	.I5     (1'b1),
	.O5     (active_interrupt_value), 
	.O6     (sx_addr4_value));

(* HBLKNM = "kcpsm6_control" *)
FD active_interrupt_flop (  
	.D      (active_interrupt_value),
	.Q      (active_interrupt),
	.C      (clk));

(* HBLKNM = "kcpsm6_decode1" *)
FD interrupt_ack_flop (  
	.D      (active_interrupt),
	.Q      (interrupt_ack),
	.C      (clk));
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Decoders 
//
//
//     2 x LUT6
//    10 x LUT6_2
//     2 x FD
//     6 x FDR
//
///////////////////////////////////////////////////////////////////////////////////////////
//

//
// Decoding for Program Counter and Stack
//

(* HBLKNM = "kcpsm6_decode0" *)
LUT6 #(
	.INIT    (64'h5A3CFFFF00000000))
pc_move_is_valid_lut( 
	.I0     (carry_flag),
	.I1     (zero_flag),
	.I2     (instruction[14]),
	.I3     (instruction[15]),
	.I4     (instruction[16]),
	.I5     (instruction[17]),
	.O      (pc_move_is_valid)) ;

(* HBLKNM = "kcpsm6_decode0" *)
LUT6_2 # (
	.INIT    (64'h7777027700000200))
move_type_lut( 
	.I0     (instruction[12]),
	.I1     (instruction[13]),
	.I2     (instruction[14]),
	.I3     (instruction[15]),
	.I4     (instruction[16]),
	.I5     (1'b1),
	.O5     (returni_type),
	.O6     (move_type)) ;

(* HBLKNM = "kcpsm6_vector1" *)
LUT6_2 # (
	.INIT    (64'h0000F000000023FF))
pc_mode1_lut( 
	.I0     (instruction[12]),
	.I1     (returni_type),
	.I2     (move_type),
	.I3     (pc_move_is_valid),
	.I4     (active_interrupt),
	.I5     (1'b1),
	.O5     (pc_mode[0]),
	.O6     (pc_mode[1])) ;

(* HBLKNM = "kcpsm6_vector1" *)
LUT6 # (
	.INIT    (64'hFFFFFFFF00040000))
pc_mode2_lut( 
	.I0     (instruction[12]),
	.I1     (instruction[14]),
	.I2     (instruction[15]),
	.I3     (instruction[16]),
	.I4     (instruction[17]),
	.I5     (active_interrupt),
	.O      (pc_mode[2])) ;

(* HBLKNM = "kcpsm6_stack1" *)
LUT6_2 # (
	.INIT    (64'hFFFF100000002000))
push_pop_lut( 
	.I0     (instruction[12]),
	.I1     (instruction[13]),
	.I2     (move_type),
	.I3     (pc_move_is_valid),
	.I4     (active_interrupt),
	.I5     (1'b1),
	.O5     (pop_stack),
	.O6     (push_stack)) ;

//
// Decoding for ALU
//

(* HBLKNM = "kcpsm6_decode2" *)
LUT6_2 #(
	.INIT    (64'h03CA000004200000))
alu_decode0_lut( 
	.I0     (instruction[13]),
	.I1     (instruction[14]),
	.I2     (instruction[15]),
	.I3     (instruction[16]),
	.I4     (1'b1),
	.I5     (1'b1),
	.O5     (alu_mux_sel_value[0]),
	.O6     (arith_logical_sel[0])) ;

(* HBLKNM = "kcpsm6_decode2" *)
FD alu_mux_sel0_flop(  
	.D      (alu_mux_sel_value[0]),
	.Q      (alu_mux_sel[0]),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_decode1" *)
LUT6_2 #(
	.INIT    (64'h7708000000000F00))
alu_decode1_lut( 
	.I0     (carry_flag),
	.I1     (instruction[13]),
	.I2     (instruction[14]),
	.I3     (instruction[15]),
	.I4     (instruction[16]),
	.I5     (1'b1),
	.O5     (alu_mux_sel_value[1]),
	.O6     (arith_carry_in)) ;                     

(* HBLKNM = "kcpsm6_decode1" *)
FD alu_mux_sel1_flop (  
	.D      (alu_mux_sel_value[1]),
	.Q      (alu_mux_sel[1]),
	.C      (clk)) ;


(* HBLKNM = "kcpsm6_decode2" *)
LUT6_2 # (
	.INIT    (64'hD000000002000000))
alu_decode2_lut( 
	.I0     (instruction[14]),
	.I1     (instruction[15]),
	.I2     (instruction[16]),
	.I3     (1'b1),
	.I4     (1'b1),
	.I5     (1'b1),
	.O5     (arith_logical_sel[1]),
	.O6     (arith_logical_sel[2])) ;

//
// Decoding for strobes and enables
//

(* HBLKNM = "kcpsm6_strobes" *)
LUT6_2 # (
	.INIT    (64'h00013F3F0010F7CE))
register_enable_type_lut( 
	.I0     (instruction[13]),
	.I1     (instruction[14]),
	.I2     (instruction[15]),
	.I3     (instruction[16]),
	.I4     (instruction[17]),
	.I5     (1'b1),
	.O5     (flag_enable_type),
	.O6     (register_enable_type)) ;

(* HBLKNM = "kcpsm6_strobes" *)
LUT6_2 # (
	.INIT    (64'hC0CC0000A0AA0000))
register_enable_lut( 
	.I0     (flag_enable_type),
	.I1     (register_enable_type),
	.I2     (instruction[12]),
	.I3     (instruction[17]),
	.I4     (t_state[1]),
	.I5     (1'b1),
	.O5     (flag_enable_value),
	.O6     (register_enable_value)) ;

(* HBLKNM = "kcpsm6_strobes" *)
FDR flag_enable_flop (  
	.D      (flag_enable_value),
	.Q      (flag_enable),
	.R      (active_interrupt),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_strobes" *)
FDR register_enable_flop (  
	.D      (register_enable_value),
	.Q      (register_enable),
	.R      (active_interrupt),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_strobes" *)
LUT6_2 # (
	.INIT    (64'h8000000020000000))
spm_enable_lut( 
	.I0     (instruction[13]),
	.I1     (instruction[14]),
	.I2     (instruction[17]),
	.I3     (strobe_type),
	.I4     (t_state[1]),
	.I5     (1'b1),
	.O5     (k_write_strobe_value),
	.O6     (spm_enable_value)) ;

(* HBLKNM = "kcpsm6_strobes" *)
FDR k_write_strobe_flop (  
	.D      (k_write_strobe_value),
	.Q      (k_write_strobe),
	.R      (active_interrupt),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_strobes" *)
FDR spm_enable_flop (  
	.D      (spm_enable_value),
	.Q      (spm_enable),
	.R      (active_interrupt),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_strobes" *)
LUT6_2 # (
	.INIT    (64'h4000000001000000))
read_strobe_lut( 
	.I0     (instruction[13]),
	.I1     (instruction[14]),
	.I2     (instruction[17]),
	.I3     (strobe_type),
	.I4     (t_state[1]),
	.I5     (1'b1),
	.O5     (read_strobe_value),
	.O6     (write_strobe_value)) ;

(* HBLKNM = "kcpsm6_strobes" *)
FDR write_strobe_flop (  
	.D      (write_strobe_value),
	.Q      (write_strobe),
	.R      (active_interrupt),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_strobes" *)
FDR read_strobe_flop (  
	.D      (read_strobe_value),
	.Q      (read_strobe),
	.R      (active_interrupt),
	.C      (clk)) ;
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Register bank control
//
//
//     2 x LUT6
//     1 x FDR
//     1 x FD
//
///////////////////////////////////////////////////////////////////////////////////////////
//
(* HBLKNM = "kcpsm6_stack1" *)
LUT6 # (
	.INIT    (64'h0080020000000000))
regbank_type_lut( 
	.I0     (instruction[12]),
	.I1     (instruction[13]),
	.I2     (instruction[14]),
	.I3     (instruction[15]),
	.I4     (instruction[16]),
	.I5     (instruction[17]),
	.O      (regbank_type)) ;

(* HBLKNM = "kcpsm6_stack1" *)
LUT6 # (
	.INIT    (64'hACACFF00FF00FF00))
bank_lut( 
	.I0     (instruction[0]),
	.I1     (shadow_bank),
	.I2     (instruction[16]),
	.I3     (bank),
	.I4     (regbank_type),
	.I5     (t_state[1]),
	.O      (bank_value)) ;                     

(* HBLKNM = "kcpsm6_stack1" *)
FDR bank_flop (  
	.D      (bank_value),
	.Q      (bank),
	.R      (internal_reset),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_control" *)
FD sx_addr4_flop (  
	.D      (sx_addr4_value),
	.Q      (sx_addr[4]),
	.C      (clk)) ;

assign sx_addr[3:0] = instruction[11:8] ;
assign sy_addr = {bank, instruction[7:4]} ;

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Flags
//
//
//     3 x LUT6
//     5 x LUT6_2
//     3 x FD
//     2 x FDRE
//     2 x XORCY
//     5 x MUXCY
//
///////////////////////////////////////////////////////////////////////////////////////////
//

(* HBLKNM = "kcpsm6_control" *)
XORCY arith_carry_xorcy ( 
	.LI 	(1'b0),
	.CI 	(carry_arith_logical[7]),
	.O      (arith_carry_value)) ;

(* HBLKNM = "kcpsm6_control" *)
FD arith_carry_flop (  
	.D      (arith_carry_value),
	.Q      (arith_carry),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_decode2" *)
LUT6_2 # (
	.INIT    (64'h0000000087780000))
lower_parity_lut( 
	.I0     (instruction[13]),
	.I1     (carry_flag),
	.I2     (arith_logical_result[0]),
	.I3     (arith_logical_result[1]),
	.I4     (1'b1),
	.I5     (1'b1),
	.O5     (lower_parity),
	.O6     (lower_parity_sel)) ;  
                 
(* HBLKNM = "kcpsm6_decode2" *)
MUXCY parity_muxcy ( 
	.DI	(lower_parity),
	.CI	(1'b0),                     
	.S	(lower_parity_sel),
	.O      (carry_lower_parity)) ;

(* HBLKNM = "kcpsm6_decode2" *)
LUT6 #(
	.INIT    (64'h6996966996696996))
upper_parity_lut( 
	.I0     (arith_logical_result[2]),
	.I1     (arith_logical_result[3]),
	.I2     (arith_logical_result[4]),
	.I3     (arith_logical_result[5]),
	.I4     (arith_logical_result[6]),
	.I5     (arith_logical_result[7]),
	.O      (upper_parity)) ;                     

(* HBLKNM = "kcpsm6_decode2" *)
XORCY parity_xorcy( 
	.LI	(upper_parity),
        .CI	(carry_lower_parity),
	.O      (parity)) ;

(* HBLKNM = "kcpsm6_decode1" *)
LUT6 #(
	.INIT    (64'hFFFFAACCF0F0F0F0))
shift_carry_lut( 
	.I0     (sx[0]),
	.I1     (sx[7]),
	.I2     (shadow_carry_flag),
	.I3     (instruction[3]),
	.I4     (instruction[7]),
	.I5     (instruction[16]),
	.O      (shift_carry_value)) ;                     

(* HBLKNM = "kcpsm6_decode1" *)
FD shift_carry_flop(  
	.D      (shift_carry_value),
	.Q      (shift_carry),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_flags" *)
LUT6_2 #(
	.INIT    (64'h3333AACCF0AA0000))
carry_flag_lut( 
	.I0     (shift_carry),
	.I1     (arith_carry),
	.I2     (parity),
	.I3     (instruction[14]),
	.I4     (instruction[15]),
	.I5     (instruction[16]),
	.O5     (drive_carry_in_zero),
	.O6     (carry_flag_value)) ;  

(* HBLKNM = "kcpsm6_flags" *)
FDRE carry_flag_flop(  
	.D      (carry_flag_value),
	.Q      (carry_flag),
       	.CE     (flag_enable),
	.R      (internal_reset),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_flags" *)
MUXCY init_zero_muxcy( 
	.DI	(drive_carry_in_zero),
	.CI	(1'b0),
	.S	(carry_flag_value),
	.O      (carry_in_zero)) ;

(* HBLKNM = "kcpsm6_decode1" *)
LUT6_2 # (
	.INIT    (64'hA280000000F000F0))
use_zero_flag_lut( 
	.I0     (instruction[13]),
	.I1     (instruction[14]),
	.I2     (instruction[15]),
	.I3     (instruction[16]),
	.I4     (1'b1),
	.I5     (1'b1),
	.O5     (strobe_type),
	.O6     (use_zero_flag_value)) ;                     

(* HBLKNM = "kcpsm6_decode1" *)
FD use_zero_flag_flop(  
	.D      (use_zero_flag_value),
	.Q      (use_zero_flag),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_flags" *)
LUT6_2 #(
	.INIT    (64'h0000000000000001))
lower_zero_lut( 
	.I0     (alu_result[0]),
	.I1     (alu_result[1]),
	.I2     (alu_result[2]),
	.I3     (alu_result[3]),
	.I4     (alu_result[4]),
	.I5     (1'b1),
	.O5     (lower_zero),
	.O6     (lower_zero_sel)) ;                     

(* HBLKNM = "kcpsm6_flags" *)
MUXCY lower_zero_muxcy( 
	.DI	(lower_zero),
	.CI	(carry_in_zero),
	.S	(lower_zero_sel),
	.O      (carry_lower_zero)) ;

(* HBLKNM = "kcpsm6_flags" *)
LUT6_2 # (
	.INIT    (64'h0000000D00000000))
middle_zero_lut( 
	.I0     (use_zero_flag),
	.I1     (zero_flag),
	.I2     (alu_result[5]),
	.I3     (alu_result[6]),
	.I4     (alu_result[7]),
	.I5     (1'b1),
	.O5     (middle_zero),
	.O6     (middle_zero_sel)) ;                     

(* HBLKNM = "kcpsm6_flags" *)
MUXCY middle_zero_muxcy( 
	.DI	(middle_zero),
	.CI	(carry_lower_zero),                     
	.S 	(middle_zero_sel),
  	.O      (carry_middle_zero)) ;

(* HBLKNM = "kcpsm6_flags" *)
LUT6 #(
	.INIT    (64'hFBFF000000000000))
upper_zero_lut( 
	.I0     (instruction[14]),
	.I1     (instruction[15]),
	.I2     (instruction[16]),
	.I3     (1'b1),
	.I4     (1'b1),
	.I5     (1'b1),
	.O      (upper_zero_sel)) ;                     

(* HBLKNM = "kcpsm6_flags" *)
MUXCY upper_zero_muxcy( 
	.DI	(shadow_zero_flag),
	.CI	(carry_middle_zero),                    
	.S	(upper_zero_sel),
	.O      (zero_flag_value)) ;

(* HBLKNM = "kcpsm6_flags" *)
FDRE zero_flag_flop(  
	.D      (zero_flag_value),
	.Q      (zero_flag),
	.CE     (flag_enable),
	.R      (internal_reset),
	.C      (clk)) ;

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// 12-bit Program Address Generation 
//
///////////////////////////////////////////////////////////////////////////////////////////
//

//
// Prepare 12-bit vector from the sX and sY register outputs.
//

assign register_vector = {sx[3:0], sy} ;

genvar i ;

generate
for (i = 0 ; i <= 11 ; i = i+1)
begin : address_loop
parameter [7:0] id4 = 8'h30 + i/4 ;
parameter [7:0] id8 = 8'h30 + i/8 ;
parameter [7:0] ip4d8 = 8'h30 + (i+4)/8 ;	  
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Selection of vector to load program counter
//
// instruction[12]
//              0  Constant aaa from instruction(11:0)
//              1  Return vector from stack 
//
// 'aaa' is used during 'JUMP aaa', 'JUMP c, aaa', 'CALL aaa' and 'CALL c, aaa'.
// Return vector is used during 'RETURN', 'RETURN c', 'RETURN&LOAD' and 'RETURNI'.
//
//     6 x LUT6_2
//     12 x FD
//
///////////////////////////////////////////////////////////////////////////////////////////
//

//
// Pipeline output of the stack memory
//
(* HBLKNM = {"kcpsm6_stack_ram",ip4d8} *)
FD return_vector_flop(  
	.D      (stack_memory[i]),
	.Q      (return_vector[i]),
	.C      (clk));
//
// Multiplex instruction constant address and output from stack.
// 2 bits per LUT so only generate when 'i' is even.
//
if (i % 2 == 0) begin: output_data

(* HBLKNM = {"kcpsm6_vector",id8} *)
LUT6_2 #(
	.INIT   (64'hFF00F0F0CCCCAAAA))
pc_vector_mux_lut( 
	.I0     (instruction[i]),
	.I1     (return_vector[i]),
	.I2     (instruction[i+1]),
	.I3     (return_vector[i+1]),
	.I4     (instruction[12]),
	.I5     (1'b1),
	.O5     (pc_vector[i]),
	.O6     (pc_vector[i+1]));

end //output_data

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Program Counter
//
// Reset by internal_reset has highest priority.
// Enabled by t_state[1] has second priority.
//
// The function performed is defined by pc_mode(2:0).
//
// pc_mode [2] [1] [0] 
//          0   0   1  pc+1 for normal program flow.
//          1   0   0  Forces interrupt vector value (+0) during active interrupt.
//                     The vector is defined by a generic with default value FF0 hex.
//          1   1   0  register_vector (+0) for 'JUMP (sX, sY)' and 'CALL (sX, sY)'.
//          0   1   0  pc_vector (+0) for 'JUMP/CALL aaa' and 'RETURNI'.
//          0   1   1  pc_vector+1 for 'RETURN'.
//
// Note that pc_mode[0] is High during operations that require an increment to occur.
// The LUT6 associated with the LSB must invert pc or pc_vector in these cases and 
// pc_mode[0] also has to be connected to the start of the carry chain.
//
// 3 Slices 
//     12 x LUT6
//     11 x MUXCY
//     12 x XORCY
//     12 x FDRE
//
///////////////////////////////////////////////////////////////////////////////////////////
//
(* HBLKNM = {"kcpsm6_pc",id4} *)
FDRE pc_flop(  
	.D      (pc_value[i]),
	.Q      (pc[i]),
	.R      (internal_reset),
	.CE     (t_state[1]),
	.C      (clk));

if (i == 0) begin: lsb_pc

//
// Logic of LSB must invert selected value when pc_mode[0] is High.
// The interrupt vector is defined by a generic.
//

if (interrupt_vector[i] == 1'b0) begin: low_int_vector

(* HBLKNM = {"kcpsm6_pc",id4} *)
LUT6 #(
	.INIT    (64'h00AA000033CC0F00))
pc_lut( 
	.I0     (register_vector[i]),
	.I1     (pc_vector[i]),
	.I2     (pc[i]),
	.I3     (pc_mode[0]),
	.I4     (pc_mode[1]),
	.I5     (pc_mode[2]), 
	.O      (half_pc[i]));

end //low_int_vector

if (interrupt_vector[i] == 1'b1) begin: high_int_vector

(* HBLKNM = {"kcpsm6_pc",id4} *)
LUT6 #(
	.INIT    (64'h00AA00FF33CC0F00))
pc_lut( 
	.I0     (register_vector[i]),
	.I1     (pc_vector[i]),
	.I2     (pc[i]),
	.I3     (pc_mode[0]),
	.I4     (pc_mode[1]),
	.I5     (pc_mode[2]), 
	.O      (half_pc[i]));

end //high_int_vector

//
// pc_mode[0] connected to first MUXCY and carry input is 1'b0
//

(* HBLKNM = {"kcpsm6_pc",id4} *)
XORCY pc_xorcy( 
	.LI	(half_pc[i]),
	.CI	(1'b0),
	.O      (pc_value[i]));

(* HBLKNM = {"kcpsm6_pc",id4} *)
MUXCY pc_muxcy( 
	.DI 	(pc_mode[0]),
	.CI 	(1'b0),
	.S	(half_pc[i]),
        .O      (carry_pc[i]));

end //lsb_pc

if (i > 0) begin : upper_pc

//
// Logic of upper section selects required value.
// The interrupt vector is defined by a generic.
//

if (interrupt_vector[i] == 1'b0) begin: low_int_vector

(* HBLKNM = {"kcpsm6_pc",id4} *)
LUT6 #(
	.INIT    (64'h00AA0000CCCCF000))
pc_lut( 
	.I0     (register_vector[i]),
	.I1     (pc_vector[i]),
	.I2     (pc[i]),
	.I3     (pc_mode[0]),
	.I4     (pc_mode[1]),
	.I5     (pc_mode[2]), 
	.O      (half_pc[i]));

end //low_int_vector

if (interrupt_vector[i] == 1'b1) begin: high_int_vector

(* HBLKNM = {"kcpsm6_pc",id4} *)
LUT6 #(
	.INIT    (64'h00AA00FFCCCCF000))
pc_lut( 
	.I0     (register_vector[i]),
	.I1     (pc_vector[i]),
	.I2     (pc[i]),
	.I3     (pc_mode[0]),
	.I4     (pc_mode[1]),
	.I5     (pc_mode[2]), 
	.O      (half_pc[i]));

end //high_int_vector

//
// Carry chain implementing remainder of increment function
//
(* HBLKNM = {"kcpsm6_pc",id4} *)
XORCY pc_xorcy( 
	.LI	(half_pc[i]),
	.CI	(carry_pc[i-1]),
	.O      (pc_value[i]));


//
// No MUXCY required at the top of the chain
//
if (i < 11) begin: mid_pc

(* HBLKNM = {"kcpsm6_pc",id4} *)
MUXCY pc_muxcy( 
	.DI 	(1'b0),
	.CI 	(carry_pc[i-1]),
	.S 	(half_pc[i]),
	.O     	(carry_pc[i]));

end //mid_pc

end //upper_pc


//
///////////////////////////////////////////////////////////////////////////////////////////
//
end //address_loop
endgenerate
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Stack 
//  Preserves upto 31 nested values of the Program Counter during CALL and RETURN.
//  Also preserves flags and bank selection during interrupt.
//
//     2 x RAM32M 
//     4 x FD
//     5 x FDR
//     1 x LUT6
//     4 x LUT6_2
//     5 x XORCY
//     5 x MUXCY
//
///////////////////////////////////////////////////////////////////////////////////////////
//

(* HBLKNM = "kcpsm6_stack_ram0" *)
FD shadow_carry_flag_flop(  
	.D      (stack_carry_flag),
	.Q      (shadow_carry_flag),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_stack_ram0" *)
FD stack_zero_flop(  
	.D      (stack_zero_flag),
	.Q      (shadow_zero_value),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_decode1" *)
FD shadow_zero_flag_flop(  
	.D      (shadow_zero_value),
	.Q      (shadow_zero_flag),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_stack_ram0" *)
FD shadow_bank_flop(  
	.D      (stack_bank),
	.Q      (shadow_bank),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_stack_ram0" *)
FD stack_bit_flop(  
	.D      (stack_bit),
	.Q      (special_bit),
	.C      (clk)) ;

(* HBLKNM = "kcpsm6_stack_ram0" *)
RAM32M #(
	.INIT_A	(64'h0000000000000000), 
	.INIT_B	(64'h0000000000000000), 
	.INIT_C (64'h0000000000000000), 
	.INIT_D (64'h0000000000000000)) 
stack_ram_low ( 
	.DOA	({stack_zero_flag, stack_carry_flag}), 
	.DOB	({stack_bit, stack_bank}),
	.DOC    (stack_memory[1:0]), 
	.DOD    (stack_memory[3:2]),
	.ADDRA	(stack_pointer[4:0]), 
	.ADDRB	(stack_pointer[4:0]), 
	.ADDRC  (stack_pointer[4:0]), 
	.ADDRD  (stack_pointer[4:0]),
	.DIA	({zero_flag, carry_flag}), 
	.DIB	({run, bank}),
	.DIC    (pc[1:0]),
	.DID    (pc[3:2]),
	.WE 	(t_state[1]), 
	.WCLK	(clk));

(* HBLKNM = "kcpsm6_stack_ram1" *)
RAM32M #(
	.INIT_A	(64'h0000000000000000), 
	.INIT_B	(64'h0000000000000000), 
	.INIT_C	(64'h0000000000000000), 
	.INIT_D	(64'h0000000000000000)) 
stack_ram_high(    
	.DOA	(stack_memory[5:4]), 
	.DOB	(stack_memory[7:6]),
	.DOC   	(stack_memory[9:8]),
	.DOD   	(stack_memory[11:10]),
	.ADDRA 	(stack_pointer[4:0]), 
	.ADDRB 	(stack_pointer[4:0]), 
	.ADDRC  (stack_pointer[4:0]), 
	.ADDRD  (stack_pointer[4:0]),
	.DIA    (pc[5:4]),
	.DIB    (pc[7:6]),
	.DIC    (pc[9:8]),
	.DID    (pc[11:10]),
	.WE 	(t_state[1]),  
	.WCLK 	(clk));

generate
for (i = 0 ; i <= 4 ; i = i+1)
begin : stack_loop

parameter [7:0]	id4 = 8'h30 + i/4 ;

if (i == 0) begin: lsb_stack

(* HBLKNM = {"kcpsm6_stack",id4} *)
FDR pointer_flop(  
	.D      (stack_pointer_value[i]),
	.Q      (stack_pointer[i]),
	.R      (internal_reset),
	.C      (clk)) ;

(* HBLKNM = {"kcpsm6_stack",id4} *)
LUT6_2 #(
	.INIT    (64'h001529AAAAAAAAAA))
stack_pointer_lut( 
	.I0     (stack_pointer[i]),
	.I1     (pop_stack),
	.I2     (push_stack),
	.I3     (t_state[1]),
	.I4     (t_state[2]),
	.I5     (1'b1), 
	.O5     (feed_pointer_value[i]),
	.O6     (half_pointer_value[i]));

(* HBLKNM = {"kcpsm6_stack",id4} *)
XORCY stack_xorcy( 
	.LI 	(half_pointer_value[i]),
	.CI 	(1'b0),
	.O      (stack_pointer_value[i]));

(* HBLKNM = {"kcpsm6_stack",id4} *)
MUXCY stack_muxcy( 
	.DI	(feed_pointer_value[i]),
	.CI	(1'b0),
	.S 	(half_pointer_value[i]),
	.O      (stack_pointer_carry[i]));

end //lsb_stack

if (i > 0) begin: upper_stack

(* HBLKNM = {"kcpsm6_stack",id4} *)
FDR pointer_flop(  
	.D      (stack_pointer_value[i]),
	.Q      (stack_pointer[i]),
	.R      (internal_reset),
	.C      (clk)) ;

(* HBLKNM = {"kcpsm6_stack",id4} *)
LUT6_2 #(
	.INIT    (64'h002A252AAAAAAAAA))
stack_pointer_lut( 
	.I0     (stack_pointer[i]),
	.I1     (pop_stack),
	.I2     (push_stack),
	.I3     (t_state[1]),
	.I4     (t_state[2]),
	.I5     (1'b1), 
	.O5     (feed_pointer_value[i]),
	.O6     (half_pointer_value[i]));

(* HBLKNM = {"kcpsm6_stack",id4} *)
XORCY stack_xorcy( 
	.LI 	(half_pointer_value[i]),
	.CI 	(stack_pointer_carry[i-1]),
	.O      (stack_pointer_value[i]));

(* HBLKNM = {"kcpsm6_stack",id4} *)
MUXCY stack_muxcy( 
	.DI 	(feed_pointer_value[i]),
	.CI 	(stack_pointer_carry[i-1]),
	.S 	(half_pointer_value[i]),
	.O      (stack_pointer_carry[i]));

end //upper_stack

end //stack_loop
endgenerate

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// 8-bit Data Path 
//
///////////////////////////////////////////////////////////////////////////////////////////
//
generate
for (i = 0 ; i <= 7 ; i = i+1)
begin : data_path_loop
parameter [7:0]	id1 = 8'h30 + i ;
parameter [7:0]	id2 = 8'h30 + i/2 ;
parameter [7:0]	id4 = 8'h30 + i/4 ;
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Selection of second operand to ALU and port_id
//
// instruction[12]
//           0  Register sY
//           1  Constant kk 
//
//     4 x LUT6_2
//
///////////////////////////////////////////////////////////////////////////////////////////
//
//
// 2 bits per LUT so only generate when 'i' is even
//
if (i % 2 == 0) begin: output_data

(* HBLKNM = "kcpsm6_port_id" *)
LUT6_2 #(
	.INIT    (64'hFF00F0F0CCCCAAAA))
sy_kk_mux_lut( 
	.I0     (sy[i]),
	.I1     (instruction[i]),
	.I2     (sy[i+1]),
	.I3     (instruction[i+1]),
	.I4     (instruction[12]),
	.I5     (1'b1),
	.O5     (sy_or_kk[i]),
	.O6     (sy_or_kk[i+1]));

end //output_data

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Selection of out_port value
//
// instruction[13]
//              0  Register sX
//              1  Constant kk from instruction(11:4)
//
//     4 x LUT6_2
//
///////////////////////////////////////////////////////////////////////////////////////////
//
//
// 2 bits per LUT so only generate when 'i' is even
//

if (i % 2 == 0) begin: second_operand

(* HBLKNM = "kcpsm6_out_port" *)
LUT6_2 #(
	.INIT    (64'hFF00F0F0CCCCAAAA))
out_port_lut( 
	.I0     (sx[i]),
	.I1     (instruction[i+4]),
	.I2     (sx[i+1]),
	.I3     (instruction[i+5]),
	.I4     (instruction[13]),
	.I5     (1'b1),
	.O5     (out_port[i]),
	.O6     (out_port[i+1]));

end //second_operand;

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Arithmetic and Logical operations
//
// Definition of....
//    ADD and SUB also used for ADDCY, SUBCY, COMPARE and COMPARECY.
//    LOAD, AND, OR and XOR also used for LOAD*, RETURN&LOAD, TEST and TESTCY.
//
// arith_logical_sel [2] [1] [0]
//                    0   0   0  - LOAD
//                    0   0   1  - AND
//                    0   1   0  - OR
//                    0   1   1  - XOR
//                    1   X   0  - SUB
//                    1   X   1  - ADD
//
// Includes pipeline stage.
//
// 2 Slices
//     8 x LUT6_2
//     8 x MUXCY
//     8 x XORCY
//     8 x FD
//
///////////////////////////////////////////////////////////////////////////////////////////
//

(* HBLKNM = {"kcpsm6_add",id4} *)
LUT6_2 #(
	.INIT    (64'h69696E8ACCCC0000))
arith_logical_lut( 
	.I0     (sy_or_kk[i]),
	.I1     (sx[i]),
	.I2     (arith_logical_sel[0]),
	.I3     (arith_logical_sel[1]),
	.I4     (arith_logical_sel[2]),
	.I5     (1'b1),
	.O5     (logical_carry_mask[i]),
	.O6     (half_arith_logical[i]));

(* HBLKNM = {"kcpsm6_add",id4} *)
FD arith_logical_flop( 
	.D      (arith_logical_value[i]),
	.Q      (arith_logical_result[i]),
	.C      (clk)) ;

if (i == 0) begin: lsb_arith_logical
//
// Carry input to first MUXCY and XORCY
//
(* HBLKNM = {"kcpsm6_add",id4} *)
MUXCY arith_logical_muxcy( 
	.DI 	(logical_carry_mask[i]),
	.CI 	(arith_carry_in),
	.S 	(half_arith_logical[i]),
	.O      (carry_arith_logical[i]));

(* HBLKNM = {"kcpsm6_add",id4} *)
XORCY arith_logical_xorcy( 
	.LI 	(half_arith_logical[i]),
	.CI 	(arith_carry_in),
	.O      (arith_logical_value[i]));

end //lsb_arith_logical

if (i > 0) begin: upper_arith_logical
//
// Main carry chain  
//
(* HBLKNM = {"kcpsm6_add",id4} *)
MUXCY arith_logical_muxcy( 
	.DI 	(logical_carry_mask[i]),
	.CI 	(carry_arith_logical[i-1]),
	.S 	(half_arith_logical[i]),
	.O      (carry_arith_logical[i]));

(* HBLKNM = {"kcpsm6_add",id4} *)
XORCY arith_logical_xorcy( 
	.LI 	(half_arith_logical[i]),
	.CI 	(carry_arith_logical[i-1]),
	.O      (arith_logical_value[i]));

end //upper_arith_logical;


//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Shift and Rotate operations
//
// Definition of SL0, SL1, SLX, SLA, RL, SR0, SR1, SRX, SRA, and RR 
//
// instruction [3] [2] [1] [0]
//              0   1   1   0  - SL0
//              0   1   1   1  - SL1
//              0   1   0   0  - SLX         
//              0   0   0   0  - SLA
//              0   0   1   0  - RL
//              1   1   1   0  - SR0
//              1   1   1   1  - SR1
//              1   0   1   0  - SRX
//              1   0   0   0  - SRA
//              1   1   0   0  - RR
//
// instruction[3] 
//             0 - Left
//             1 - Right
//
// instruction [2] [1]  Bit shifted in 
//              0   0   Carry_flag
//              0   1   sX[7]
//              1   0   sX[0]
//              1   1   instruction[0]
//
// Includes pipeline stage.
//
//     4 x LUT6_2
//     1 x LUT6
//     8 x FD
//
///////////////////////////////////////////////////////////////////////////////////////////
//

if (hwbuild[i] == 1'b0) begin: low_hwbuild 
//
// Reset Flip-flop to form 1'b0 for this bit of HWBUILD 
//
(* HBLKNM = "kcpsm6_sandr" *)
FDR shift_rotate_flop( 
	.D      (shift_rotate_value[i]),
	.Q      (shift_rotate_result[i]),
	.R      (instruction[7]),
	.C      (clk)) ;
           
end // low_hwbuild;

if (hwbuild[i] == 1'b1) begin: high_hwbuild 
//
// Set Flip-flop to form 1'b1 for this bit of HWBUILD 
//
(* HBLKNM = "kcpsm6_sandr" *)
FDS shift_rotate_flop( 
	.D      (shift_rotate_value[i]),
	.Q      (shift_rotate_result[i]),
	.S 	(instruction[7]),
	.C      (clk)) ;

end // high_hwbuild;

if (i == 0) begin: lsb_shift_rotate
//
// Select bit to be shifted or rotated into result
//
(* HBLKNM = "kcpsm6_decode1" *)
LUT6 #(
	.INIT    (64'hBFBC8F8CB3B08380))
shift_bit_lut( 
	.I0     (instruction[0]),
	.I1     (instruction[1]),
	.I2     (instruction[2]),
	.I3     (carry_flag),
	.I4     (sx[0]),
	.I5     (sx[7]),
	.O      (shift_in_bit));

//
// Define lower bits of result
//
(* HBLKNM = "kcpsm6_sandr" *)
LUT6_2 #(
	.INIT    (64'hFF00F0F0CCCCAAAA))
shift_rotate_lut( 
	.I0     (shift_in_bit),
	.I1     (sx[i+1]),
	.I2     (sx[i]),
	.I3     (sx[i+2]),
	.I4     (instruction[3]),
	.I5     (1'b1),
	.O5     (shift_rotate_value[i]),
	.O6     (shift_rotate_value[i+1]));

end // lsb_shift_rotate;

if (i == 2 || i == 4) begin: mid_shift_rotate
//
// Define middle bits of result
//
(* HBLKNM = "kcpsm6_sandr" *)
LUT6_2 #(
	.INIT    (64'hFF00F0F0CCCCAAAA))
shift_rotate_lut( 
	.I0     (sx[i-1]),
	.I1     (sx[i+1]),
	.I2     (sx[i]),
	.I3     (sx[i+2]),
	.I4     (instruction[3]),
	.I5     (1'b1),
	.O5     (shift_rotate_value[i]),
	.O6     (shift_rotate_value[i+1]));

end // mid_shift_rotate;

if (i == 6) begin: msb_shift_rotate
//
// Define upper bits of result
//
(* HBLKNM = "kcpsm6_sandr" *)
LUT6_2 #(
	.INIT    (64'hFF00F0F0CCCCAAAA))
shift_rotate_lut( 
	.I0     (sx[i-1]),
	.I1     (sx[i+1]),
	.I2     (sx[i]),
	.I3     (shift_in_bit),
	.I4     (instruction[3]),
	.I5     (1'b1),
	.O5     (shift_rotate_value[i]),
	.O6     (shift_rotate_value[i+1]));

end // msb_shift_rotate;

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Multiplex outputs from ALU functions, scratch pad memory and input port.
//
// alu_mux_sel [1] [0]  
//              0   0  Arithmetic and Logical Instructions
//              0   1  Shift and Rotate Instructions
//              1   0  Input Port
//              1   1  Scratch Pad Memory
//
//     8 x LUT6
//
///////////////////////////////////////////////////////////////////////////////////////////
//

(* HBLKNM = {"kcpsm6_alu",id4} *)
LUT6 #(
	.INIT    (64'hFF00F0F0CCCCAAAA))
alu_mux_lut( 
	.I0     (arith_logical_result[i]),
	.I1     (shift_rotate_result[i]),
	.I2     (in_port[i]),
	.I3     (spm_data[i]),
	.I4     (alu_mux_sel[0]),
	.I5     (alu_mux_sel[1]),
	.O      (alu_result[i]));

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Scratchpad Memory with output register.
//
// The size of the scratch pad memory is defined by the 'scratch_pad_memory_size' generic.
// The default size is 64 bytes the same as KCPSM3 but this can be increased to 128 or 256 
// bytes at an additional cost of 2 and 6 Slices.
//
//
// 8 x RAM256X1S (256 bytes).
// 8 x RAM128X1S (128 bytes).
// 2 x RAM64M    (64 bytes).
//
// 8 x FD.
//
///////////////////////////////////////////////////////////////////////////////////////////
//

if (scratch_pad_memory_size == 64) begin : small_spm

(* HBLKNM = {"kcpsm6_spm",id4} *)
FD spm_flop( 
	.D      (spm_ram_data[i]),
	.Q      (spm_data[i]),
	.C      (clk)) ;

if (i == 0 || i == 4) begin: small_spm_ram

RAM64M #( 
	.INIT_A	(64'h0000000000000000),
	.INIT_B	(64'h0000000000000000),
	.INIT_C	(64'h0000000000000000),
	.INIT_D	(64'h0000000000000000)) 
spm_ram(   
	.DOA 	(spm_ram_data[i]),
	.DOB 	(spm_ram_data[i+1]),
	.DOC    (spm_ram_data[i+2]),
	.DOD    (spm_ram_data[i+3]),
	.ADDRA 	(sy_or_kk[5:0]),
	.ADDRB 	(sy_or_kk[5:0]),
	.ADDRC  (sy_or_kk[5:0]),
	.ADDRD  (sy_or_kk[5:0]),
	.DIA 	(sx[i]),
	.DIB 	(sx[i+1]),
	.DIC    (sx[i+2]),
	.DID    (sx[i+3]),
	.WE 	(spm_enable),
	.WCLK 	(clk));

end // small_spm_ram;

end // small_spm;

if (scratch_pad_memory_size == 128) begin : medium_spm

(* HBLKNM = {"kcpsm6_spm",id2} *)
RAM128X1S  #(
	.INIT	(128'h00000000000000000000000000000000))
spm_ram(       
	.D      (sx[i]),
	.WE 	(spm_enable),
	.WCLK 	(clk),
	.A0 	(sy_or_kk[0]),
	.A1 	(sy_or_kk[1]),
	.A2 	(sy_or_kk[2]),
	.A3 	(sy_or_kk[3]),
	.A4 	(sy_or_kk[4]),
	.A5 	(sy_or_kk[5]),
	.A6 	(sy_or_kk[6]),
	.O      (spm_ram_data[i]));

(* HBLKNM = {"kcpsm6_spm",id2} *)
FD spm_flop( 
	.D      (spm_ram_data[i]),
	.Q      (spm_data[i]),
	.C      (clk)) ;

end // medium_spm;

if (scratch_pad_memory_size == 256) begin : large_spm

(* HBLKNM = {"kcpsm6_spm",id1} *)
RAM256X1S #(
	.INIT	(256'h0000000000000000000000000000000000000000000000000000000000000000))
spm_ram (       
	.D      (sx[i]),
	.WE 	(spm_enable),
	.WCLK 	(clk),
	.A 	(sy_or_kk),
	.O      (spm_ram_data[i]));

(* HBLKNM = {"kcpsm6_spm",id1} *)
FD spm_flop( 
	.D      (spm_ram_data[i]),
	.Q      (spm_data[i]),
	.C      (clk)) ;

end // large_spm;

//
///////////////////////////////////////////////////////////////////////////////////////////
//

end // data_path_loop;
endgenerate



//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Two Banks of 16 General Purpose Registers.
//
// sx_addr - Address for sX is formed by bank select and instruction[11:8]
// sy_addr - Address for sY is formed by bank select and instruction[7:4]
//
// 2 Slices
//     2 x RAM32M
//
///////////////////////////////////////////////////////////////////////////////////////////
//

(* HBLKNM = "kcpsm6_reg0" *)
RAM32M #(
	.INIT_A	(64'h0000000000000000), 
	.INIT_B	(64'h0000000000000000), 
	.INIT_C (64'h0000000000000000), 
	.INIT_D (64'h0000000000000000)) 
lower_reg_banks(    
	.DOA 	(sy[1:0]), 
	.DOB 	(sx[1:0]),
	.DOC    (sy[3:2]),
	.DOD    (sx[3:2]),
	.ADDRA 	(sy_addr), 
	.ADDRB 	(sx_addr), 
	.ADDRC  (sy_addr), 
	.ADDRD  (sx_addr), 
	.DIA 	(alu_result[1:0]),
	.DIB 	(alu_result[1:0]),
	.DIC    (alu_result[3:2]),
	.DID    (alu_result[3:2]),
	.WE 	(register_enable), 
	.WCLK	(clk));

(* HBLKNM = "kcpsm6_reg1" *)
RAM32M #(
	.INIT_A	(64'h0000000000000000), 
	.INIT_B	(64'h0000000000000000), 
	.INIT_C (64'h0000000000000000),  
	.INIT_D (64'h0000000000000000)) 
upper_reg_banks(    
	.DOA 	(sy[5:4]), 
	.DOB 	(sx[5:4]),
	.DOC    (sy[7:6]),
	.DOD    (sx[7:6]),
	.ADDRA 	(sy_addr),
	.ADDRB 	(sx_addr),
	.ADDRC  (sy_addr), 
	.ADDRD  (sx_addr), 
	.DIA 	(alu_result[5:4]),
	.DIB 	(alu_result[5:4]),
	.DIC    (alu_result[7:6]),
	.DID    (alu_result[7:6]),
	.WE 	(register_enable), 
	.WCLK	(clk));

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Connections to KCPSM6 outputs.
//
///////////////////////////////////////////////////////////////////////////////////////////
//


assign address = pc;
assign bram_enable = t_state[2];

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Connections KCPSM6 Outputs.
//
///////////////////////////////////////////////////////////////////////////////////////////
//

assign port_id = sy_or_kk;

//
///////////////////////////////////////////////////////////////////////////////////////////
//
// End of description for kcpsm6 macro.
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// *****************************************************
// * Code for simulation purposes only after this line *
// *****************************************************
//
//
// Disassemble the instruction codes to form a text string for display.
// Determine status of reset and flags and present in the form of a text string.
// Provide signals to simulate the contents of each register and scratch pad memory 
// location.
//
///////////////////////////////////////////////////////////////////////////////////////////
//
//All of this section is ignored during synthesis.
//synthesis translate_off
// 
//
// Variables for contents of each register in each bank
//
reg	[7:0]		bank_a_s0 ;
reg	[7:0]		bank_a_s1 ;
reg	[7:0]		bank_a_s2 ;
reg	[7:0]		bank_a_s3 ;
reg	[7:0]		bank_a_s4 ;
reg	[7:0]		bank_a_s5 ;
reg	[7:0]		bank_a_s6 ;
reg	[7:0]		bank_a_s7 ;
reg	[7:0]		bank_a_s8 ;
reg	[7:0]		bank_a_s9 ;
reg	[7:0]		bank_a_sa ;
reg	[7:0]		bank_a_sb ;
reg	[7:0]		bank_a_sc ;
reg	[7:0]		bank_a_sd ;
reg	[7:0]		bank_a_se ;
reg	[7:0]		bank_a_sf ;
reg	[7:0]		bank_b_s0 ;
reg	[7:0]		bank_b_s1 ;
reg	[7:0]		bank_b_s2 ;
reg	[7:0]		bank_b_s3 ;
reg	[7:0]		bank_b_s4 ;
reg	[7:0]		bank_b_s5 ;
reg	[7:0]		bank_b_s6 ;
reg	[7:0]		bank_b_s7 ;
reg	[7:0]		bank_b_s8 ;
reg	[7:0]		bank_b_s9 ;
reg	[7:0]		bank_b_sa ;
reg	[7:0]		bank_b_sb ;
reg	[7:0]		bank_b_sc ;
reg	[7:0]		bank_b_sd ;
reg	[7:0]		bank_b_se ;
reg	[7:0]		bank_b_sf ;
//
initial begin
bank_a_s0 = 8'h00 ;
bank_a_s1 = 8'h00 ;
bank_a_s2 = 8'h00 ;
bank_a_s3 = 8'h00 ;
bank_a_s4 = 8'h00 ;
bank_a_s5 = 8'h00 ;
bank_a_s6 = 8'h00 ;
bank_a_s7 = 8'h00 ;
bank_a_s8 = 8'h00 ;
bank_a_s9 = 8'h00 ;
bank_a_sa = 8'h00 ;
bank_a_sb = 8'h00 ;
bank_a_sc = 8'h00 ;
bank_a_sd = 8'h00 ;
bank_a_se = 8'h00 ;
bank_a_sf = 8'h00 ;
bank_b_s0 = 8'h00 ;
bank_b_s1 = 8'h00 ;
bank_b_s2 = 8'h00 ;
bank_b_s3 = 8'h00 ;
bank_b_s4 = 8'h00 ;
bank_b_s5 = 8'h00 ;
bank_b_s6 = 8'h00 ;
bank_b_s7 = 8'h00 ;
bank_b_s8 = 8'h00 ;
bank_b_s9 = 8'h00 ;
bank_b_sa = 8'h00 ;
bank_b_sb = 8'h00 ;
bank_b_sc = 8'h00 ;
bank_b_sd = 8'h00 ;
bank_b_se = 8'h00 ;
bank_b_sf = 8'h00 ;  
end
//
// Temporary variables for instruction decoding
//
wire	[1:16] 		sx_decode ; 	//sX register specification
wire 	[1:16]  	sy_decode ; 	//sY register specification
wire 	[1:16]		kk_decode ; 	//constant value specification
wire 	[1:24]		aaa_decode ; 	//address specification
wire			clk_del ;	// Delayed clock for simulation
//
/////////////////////////////////////////////////////////////////////////////////////////
//
// Function to convert 4-bit binary nibble to hexadecimal character
//
/////////////////////////////////////////////////////////////////////////////////////////
//
 function [1:8] hexcharacter ;
 input [3:0] nibble ;
 begin
 case (nibble)
 4'b0000 : hexcharacter = "0" ;
 4'b0001 : hexcharacter = "1" ;
 4'b0010 : hexcharacter = "2" ;
 4'b0011 : hexcharacter = "3" ;
 4'b0100 : hexcharacter = "4" ;
 4'b0101 : hexcharacter = "5" ;
 4'b0110 : hexcharacter = "6" ;
 4'b0111 : hexcharacter = "7" ;
 4'b1000 : hexcharacter = "8" ;
 4'b1001 : hexcharacter = "9" ;
 4'b1010 : hexcharacter = "A" ;
 4'b1011 : hexcharacter = "B" ;
 4'b1100 : hexcharacter = "C" ;
 4'b1101 : hexcharacter = "D" ;
 4'b1110 : hexcharacter = "E" ;
 4'b1111 : hexcharacter = "F" ;
 endcase
 end
 endfunction
//
/////////////////////////////////////////////////////////////////////////////////////////
//
// decode first register sX

assign sx_decode[1:8]  = "s";
assign sx_decode[9:16] = hexcharacter(instruction[11:8]);             

// decode second register sY
assign sy_decode[1:8]  = "s";
assign sy_decode[9:16] = hexcharacter(instruction[7:4]);  

// decode constant value
assign kk_decode[1:8]  = hexcharacter(instruction[7:4]);
assign kk_decode[9:16] = hexcharacter(instruction[3:0]);

// address value
assign aaa_decode[1:8]   = hexcharacter(instruction[11:8]);
assign aaa_decode[9:16]  = hexcharacter(instruction[7:4]);
assign aaa_decode[17:24] = hexcharacter(instruction[3:0]);

assign #200 clk_del = clk ;
// decode instruction
//always @ (clk or instruction or carry_flag or zero_flag or bank or interrupt_enable) 
always @ (posedge clk_del) 
begin : simulation
case (instruction[17:12])
	6'b000000	: kcpsm6_opcode <= {"LOAD ", sx_decode, ", ", sy_decode, "        "} ;
	6'b000001	: kcpsm6_opcode <= {"LOAD ", sx_decode, ", ", kk_decode, "        "} ;
	6'b010110	: kcpsm6_opcode <= {"STAR ", sx_decode, ", ", sy_decode, "        "} ;
	6'b010111	: kcpsm6_opcode <= {"STAR ", sx_decode, ", ", kk_decode, "        "} ;
	6'b000010	: kcpsm6_opcode <= {"AND ", sx_decode, ", ", sy_decode, "         "} ;
	6'b000011	: kcpsm6_opcode <= {"AND ", sx_decode, ", ", kk_decode, "         "} ;
	6'b000100	: kcpsm6_opcode <= {"OR ", sx_decode, ", ", sy_decode, "          "} ;
	6'b000101	: kcpsm6_opcode <= {"OR ", sx_decode, ", ", kk_decode, "          "} ;
	6'b000110	: kcpsm6_opcode <= {"XOR ", sx_decode, ", ", sy_decode, "         "} ;
	6'b000111	: kcpsm6_opcode <= {"XOR ", sx_decode, ", ", kk_decode, "         "} ;
	6'b001100	: kcpsm6_opcode <= {"TEST ", sx_decode, ", ", sy_decode, "        "} ;
	6'b001101	: kcpsm6_opcode <= {"TEST ", sx_decode, ", ", kk_decode, "        "} ;
	6'b001110	: kcpsm6_opcode <= {"TESTCY ", sx_decode, ", ", sy_decode, "      "} ;
	6'b001111	: kcpsm6_opcode <= {"TESTCY ", sx_decode, ", ", kk_decode, "      "} ;
	6'b010000	: kcpsm6_opcode <= {"ADD ", sx_decode, ", ", sy_decode, "         "} ;
	6'b010001	: kcpsm6_opcode <= {"ADD ", sx_decode, ", ", kk_decode, "         "} ;
	6'b010010	: kcpsm6_opcode <= {"ADDCY ", sx_decode, ", ", sy_decode, "       "} ;
	6'b010011	: kcpsm6_opcode <= {"ADDCY ", sx_decode, ", ", kk_decode, "       "} ;
	6'b011000	: kcpsm6_opcode <= {"SUB ", sx_decode, ", ", sy_decode, "         "} ;
	6'b011001	: kcpsm6_opcode <= {"SUB ", sx_decode, ", ", kk_decode, "         "} ;
	6'b011010	: kcpsm6_opcode <= {"SUBCY ", sx_decode, ", ", sy_decode, "       "} ;
	6'b011011	: kcpsm6_opcode <= {"SUBCY ", sx_decode, ", ", kk_decode, "       "} ;
	6'b011100	: kcpsm6_opcode <= {"COMPARE ", sx_decode, ", ", sy_decode, "     "} ;
	6'b011101	: kcpsm6_opcode <= {"COMPARE ", sx_decode, ", ", kk_decode, "     "} ;
	6'b011110	: kcpsm6_opcode <= {"COMPARECY ", sx_decode, ", ", sy_decode, "   "} ;
	6'b011111	: kcpsm6_opcode <= {"COMPARECY ", sx_decode, ", ", kk_decode, "   "} ;
	6'b010100	: begin
				if (instruction[7] == 1'b1) 
				  	kcpsm6_opcode <= {"HWBUILD ", sx_decode, "         "} ;
				else
				  	case (instruction[3:0])
				    		4'b0110	: kcpsm6_opcode <= {"SL0 ", sx_decode, "             "} ;
				    		4'b0111	: kcpsm6_opcode <= {"SL1 ", sx_decode, "             "} ;
				    		4'b0100	: kcpsm6_opcode <= {"SLX ", sx_decode, "             "} ;
				    		4'b0000	: kcpsm6_opcode <= {"SLA ", sx_decode, "             "} ;
				    		4'b0010	: kcpsm6_opcode <= {"RL ", sx_decode, "              "} ;
				    		4'b1110	: kcpsm6_opcode <= {"SR0 ", sx_decode, "             "} ;
				    		4'b1111	: kcpsm6_opcode <= {"SR1 ", sx_decode, "             "} ;
				    		4'b1010	: kcpsm6_opcode <= {"SRX ", sx_decode, "             "} ;
				    		4'b1000	: kcpsm6_opcode <= {"SRA ", sx_decode, "             "} ;
				    		4'b1100	: kcpsm6_opcode <= {"RR ", sx_decode, "              "} ;
				    		default	: kcpsm6_opcode <= "Invalid Instruction";
				  	endcase
			end
	6'b101100 	: kcpsm6_opcode <= {"OUTPUT ", sx_decode, ", (", sy_decode, ")    "} ;
	6'b101101 	: kcpsm6_opcode <= {"OUTPUT ", sx_decode, ", ", kk_decode, "      "} ;
	6'b101011 	: kcpsm6_opcode <= {"OUTPUTK ", aaa_decode[1:16], ", ", aaa_decode[17:24], "      " };
	6'b001000 	: kcpsm6_opcode <= {"INPUT ", sx_decode, ", (", sy_decode, ")     "} ;
	6'b001001 	: kcpsm6_opcode <= {"INPUT ", sx_decode, ", ", kk_decode, "       "} ;
	6'b101110 	: kcpsm6_opcode <= {"STORE ", sx_decode, ", (", sy_decode, ")     "} ;
	6'b101111 	: kcpsm6_opcode <= {"STORE ", sx_decode, ", ", kk_decode, "       "} ;
	6'b001010 	: kcpsm6_opcode <= {"FETCH ", sx_decode, ", (", sy_decode, ")     "} ;
	6'b001011 	: kcpsm6_opcode <= {"FETCH ", sx_decode, ", ", kk_decode, "       "} ;
	6'b100010 	: kcpsm6_opcode <= {"JUMP ", aaa_decode, "           "} ;
	6'b110010 	: kcpsm6_opcode <= {"JUMP Z, ", aaa_decode, "        "} ;
	6'b110110 	: kcpsm6_opcode <= {"JUMP NZ, ", aaa_decode, "       "} ;
	6'b111010 	: kcpsm6_opcode <= {"JUMP C, ", aaa_decode, "        "} ;
	6'b111110 	: kcpsm6_opcode <= {"JUMP NC, ", aaa_decode, "       "} ;
	6'b100110 	: kcpsm6_opcode <= {"JUMP@ (", sx_decode, ", ", sy_decode, ")     "} ;
	6'b100000 	: kcpsm6_opcode <= {"CALL ", aaa_decode, "           "} ;
	6'b110000 	: kcpsm6_opcode <= {"CALL Z, ", aaa_decode, "        "} ;
	6'b110100 	: kcpsm6_opcode <= {"CALL NZ, ", aaa_decode, "       "} ;
	6'b111000 	: kcpsm6_opcode <= {"CALL C, ", aaa_decode, "        "} ;
	6'b111100 	: kcpsm6_opcode <= {"CALL NC, ", aaa_decode, "       "} ;
	6'b100100 	: kcpsm6_opcode <= {"CALL@ (", sx_decode, ", ", sy_decode, ")     "} ;
	6'b100101 	: kcpsm6_opcode <= {"RETURN             "} ;
	6'b110001 	: kcpsm6_opcode <= {"RETURN Z           "} ;
	6'b110101 	: kcpsm6_opcode <= {"RETURN NZ          "} ;
	6'b111001 	: kcpsm6_opcode <= {"RETURN C           "} ;
	6'b111101 	: kcpsm6_opcode <= {"RETURN NC          "} ;
	6'b100001 	: kcpsm6_opcode <= {"LOAD&RETURN ", sx_decode, ", ", kk_decode, " "} ;
	6'b101001	: begin
				case (instruction[0])
				  1'b0    : kcpsm6_opcode <= "RETURNI DISABLE    ";
				  1'b1    : kcpsm6_opcode <= "RETURNI ENABLE     ";
				  default : kcpsm6_opcode <= "Invalid Instruction";
				endcase
			end
	6'b101000	: begin
				case (instruction[0])
				  1'b0    : kcpsm6_opcode <= "DISABLE INTERRUPT  ";
				  1'b1    : kcpsm6_opcode <= "ENABLE INTERRUPT   ";
				  default : kcpsm6_opcode <= "Invalid Instruction";
				endcase
			end
	6'b110111	: begin
				case (instruction[0])
				  1'b0 	  : kcpsm6_opcode <= "REGBANK A          ";
				  1'b1 	  : kcpsm6_opcode <= "REGBANK B          ";
				  default : kcpsm6_opcode <= "Invalid Instruction";
				endcase
			end
	default 	: kcpsm6_opcode <= "Invalid Instruction";
endcase



// Flag status information

if (zero_flag == 1'b0) 
  	kcpsm6_status[17:40] <= "NZ,";
else
  	kcpsm6_status[17:40] <= " Z,";


if (carry_flag == 1'b0) 
  	kcpsm6_status[41:64] <= "NC,";
else
  	kcpsm6_status[41:64] <= " C,";


if (interrupt_enable == 1'b0) 
   	kcpsm6_status[65:80] <= "ID";
else
  	kcpsm6_status[65:80] <= "IE";


// Operational status 

if (clk) begin
if (internal_reset == 1'b1)
    	kcpsm6_status[81 : 128] <= ",Reset";
else
    	if (sync_sleep == 1'b1 && t_state == 2'b00) 
      		kcpsm6_status[81 : 128] <= ",Sleep";
     	else
      		kcpsm6_status[81 : 128] <= "      ";
end


// Simulation of register contents
if (clk) begin
	if (register_enable == 1'b1) begin
		case (sx_addr)
			5'b00000	: bank_a_s0 <= alu_result ;
			5'b00001	: bank_a_s1 <= alu_result ;
			5'b00010	: bank_a_s2 <= alu_result ;
			5'b00011	: bank_a_s3 <= alu_result ;
			5'b00100	: bank_a_s4 <= alu_result ;
			5'b00101	: bank_a_s5 <= alu_result ;
			5'b00110	: bank_a_s6 <= alu_result ;
			5'b00111	: bank_a_s7 <= alu_result ;
			5'b01000	: bank_a_s8 <= alu_result ;
			5'b01001	: bank_a_s9 <= alu_result ;
			5'b01010	: bank_a_sa <= alu_result ;
			5'b01011	: bank_a_sb <= alu_result ;
			5'b01100	: bank_a_sc <= alu_result ;
			5'b01101	: bank_a_sd <= alu_result ;
			5'b01110	: bank_a_se <= alu_result ;
			5'b01111	: bank_a_sf <= alu_result ;
			5'b10000	: bank_b_s0 <= alu_result ;
			5'b10001	: bank_b_s1 <= alu_result ;
			5'b10010	: bank_b_s2 <= alu_result ;
			5'b10011	: bank_b_s3 <= alu_result ;
			5'b10100	: bank_b_s4 <= alu_result ;
			5'b10101	: bank_b_s5 <= alu_result ;
			5'b10110	: bank_b_s6 <= alu_result ;
			5'b10111	: bank_b_s7 <= alu_result ;
			5'b11000	: bank_b_s8 <= alu_result ;
			5'b11001	: bank_b_s9 <= alu_result ;
			5'b11010	: bank_b_sa <= alu_result ;
			5'b11011	: bank_b_sb <= alu_result ;
			5'b11100	: bank_b_sc <= alu_result ;
			5'b11101	: bank_b_sd <= alu_result ;
			5'b11110	: bank_b_se <= alu_result ;
			5'b11111	: bank_b_sf <= alu_result ;
		endcase
	end

//simulation of scratch pad memory contents
if (spm_enable == 1'b1) begin
	case (sy_or_kk)
		8'b00000000	: sim_spm00 <= sx;
		8'b00000001	: sim_spm01 <= sx;
		8'b00000010	: sim_spm02 <= sx;
		8'b00000011	: sim_spm03 <= sx;
		8'b00000100	: sim_spm04 <= sx;
		8'b00000101	: sim_spm05 <= sx;
		8'b00000110	: sim_spm06 <= sx;
		8'b00000111	: sim_spm07 <= sx;
		8'b00001000	: sim_spm08 <= sx;
		8'b00001001	: sim_spm09 <= sx;
		8'b00001010	: sim_spm0A <= sx;
		8'b00001011	: sim_spm0B <= sx;
		8'b00001100	: sim_spm0C <= sx;
		8'b00001101	: sim_spm0D <= sx;
		8'b00001110	: sim_spm0E <= sx;
		8'b00001111	: sim_spm0F <= sx;
		8'b00010000	: sim_spm10 <= sx;
		8'b00010001	: sim_spm11 <= sx;
		8'b00010010	: sim_spm12 <= sx;
		8'b00010011	: sim_spm13 <= sx;
		8'b00010100	: sim_spm14 <= sx;
		8'b00010101	: sim_spm15 <= sx;
		8'b00010110	: sim_spm16 <= sx;
		8'b00010111	: sim_spm17 <= sx;
		8'b00011000	: sim_spm18 <= sx;
		8'b00011001	: sim_spm19 <= sx;
		8'b00011010	: sim_spm1A <= sx;
		8'b00011011	: sim_spm1B <= sx;
		8'b00011100	: sim_spm1C <= sx;
		8'b00011101	: sim_spm1D <= sx;
		8'b00011110	: sim_spm1E <= sx;
		8'b00011111	: sim_spm1F <= sx;
		8'b00100000	: sim_spm20 <= sx;
		8'b00100001	: sim_spm21 <= sx;
		8'b00100010	: sim_spm22 <= sx;
		8'b00100011	: sim_spm23 <= sx;
		8'b00100100	: sim_spm24 <= sx;
		8'b00100101	: sim_spm25 <= sx;
		8'b00100110	: sim_spm26 <= sx;
		8'b00100111	: sim_spm27 <= sx;
		8'b00101000	: sim_spm28 <= sx;
		8'b00101001	: sim_spm29 <= sx;
		8'b00101010	: sim_spm2A <= sx;
		8'b00101011	: sim_spm2B <= sx;
		8'b00101100	: sim_spm2C <= sx;
		8'b00101101	: sim_spm2D <= sx;
		8'b00101110	: sim_spm2E <= sx;
		8'b00101111	: sim_spm2F <= sx;
		8'b00110000	: sim_spm30 <= sx;
		8'b00110001	: sim_spm31 <= sx;
		8'b00110010	: sim_spm32 <= sx;
		8'b00110011	: sim_spm33 <= sx;
		8'b00110100	: sim_spm34 <= sx;
		8'b00110101	: sim_spm35 <= sx;
		8'b00110110	: sim_spm36 <= sx;
		8'b00110111	: sim_spm37 <= sx;
		8'b00111000	: sim_spm38 <= sx;
		8'b00111001	: sim_spm39 <= sx;
		8'b00111010	: sim_spm3A <= sx;
		8'b00111011	: sim_spm3B <= sx;
		8'b00111100	: sim_spm3C <= sx;
		8'b00111101	: sim_spm3D <= sx;
		8'b00111110	: sim_spm3E <= sx;
		8'b00111111	: sim_spm3F <= sx;
		8'b01000000	: sim_spm40 <= sx;
		8'b01000001	: sim_spm41 <= sx;
		8'b01000010	: sim_spm42 <= sx;
		8'b01000011	: sim_spm43 <= sx;
		8'b01000100	: sim_spm44 <= sx;
		8'b01000101	: sim_spm45 <= sx;
		8'b01000110	: sim_spm46 <= sx;
		8'b01000111	: sim_spm47 <= sx;
		8'b01001000	: sim_spm48 <= sx;
		8'b01001001	: sim_spm49 <= sx;
		8'b01001010	: sim_spm4A <= sx;
		8'b01001011	: sim_spm4B <= sx;
		8'b01001100	: sim_spm4C <= sx;
		8'b01001101	: sim_spm4D <= sx;
		8'b01001110	: sim_spm4E <= sx;
		8'b01001111	: sim_spm4F <= sx;
		8'b01010000	: sim_spm50 <= sx;
		8'b01010001	: sim_spm51 <= sx;
		8'b01010010	: sim_spm52 <= sx;
		8'b01010011	: sim_spm53 <= sx;
		8'b01010100	: sim_spm54 <= sx;
		8'b01010101	: sim_spm55 <= sx;
		8'b01010110	: sim_spm56 <= sx;
		8'b01010111	: sim_spm57 <= sx;
		8'b01011000	: sim_spm58 <= sx;
		8'b01011001	: sim_spm59 <= sx;
		8'b01011010	: sim_spm5A <= sx;
		8'b01011011	: sim_spm5B <= sx;
		8'b01011100	: sim_spm5C <= sx;
		8'b01011101	: sim_spm5D <= sx;
		8'b01011110	: sim_spm5E <= sx;
		8'b01011111	: sim_spm5F <= sx;
		8'b01100000	: sim_spm60 <= sx;
		8'b01100001	: sim_spm61 <= sx;
		8'b01100010	: sim_spm62 <= sx;
		8'b01100011	: sim_spm63 <= sx;
		8'b01100100	: sim_spm64 <= sx;
		8'b01100101	: sim_spm65 <= sx;
		8'b01100110	: sim_spm66 <= sx;
		8'b01100111	: sim_spm67 <= sx;
		8'b01101000	: sim_spm68 <= sx;
		8'b01101001	: sim_spm69 <= sx;
		8'b01101010	: sim_spm6A <= sx;
		8'b01101011	: sim_spm6B <= sx;
		8'b01101100	: sim_spm6C <= sx;
		8'b01101101	: sim_spm6D <= sx;
		8'b01101110	: sim_spm6E <= sx;
		8'b01101111	: sim_spm6F <= sx;
		8'b01110000	: sim_spm70 <= sx;
		8'b01110001	: sim_spm71 <= sx;
		8'b01110010	: sim_spm72 <= sx;
		8'b01110011	: sim_spm73 <= sx;
		8'b01110100	: sim_spm74 <= sx;
		8'b01110101	: sim_spm75 <= sx;
		8'b01110110	: sim_spm76 <= sx;
		8'b01110111	: sim_spm77 <= sx;
		8'b01111000	: sim_spm78 <= sx;
		8'b01111001	: sim_spm79 <= sx;
		8'b01111010	: sim_spm7A <= sx;
		8'b01111011	: sim_spm7B <= sx;
		8'b01111100	: sim_spm7C <= sx;
		8'b01111101	: sim_spm7D <= sx;
		8'b01111110	: sim_spm7E <= sx;
		8'b01111111	: sim_spm7F <= sx;
		8'b10000000	: sim_spm80 <= sx;
		8'b10000001	: sim_spm81 <= sx;
		8'b10000010	: sim_spm82 <= sx;
		8'b10000011	: sim_spm83 <= sx;
		8'b10000100	: sim_spm84 <= sx;
		8'b10000101	: sim_spm85 <= sx;
		8'b10000110	: sim_spm86 <= sx;
		8'b10000111	: sim_spm87 <= sx;
		8'b10001000	: sim_spm88 <= sx;
		8'b10001001	: sim_spm89 <= sx;
		8'b10001010	: sim_spm8A <= sx;
		8'b10001011	: sim_spm8B <= sx;
		8'b10001100	: sim_spm8C <= sx;
		8'b10001101	: sim_spm8D <= sx;
		8'b10001110	: sim_spm8E <= sx;
		8'b10001111	: sim_spm8F <= sx;
		8'b10010000	: sim_spm90 <= sx;
		8'b10010001	: sim_spm91 <= sx;
		8'b10010010	: sim_spm92 <= sx;
		8'b10010011	: sim_spm93 <= sx;
		8'b10010100	: sim_spm94 <= sx;
		8'b10010101	: sim_spm95 <= sx;
		8'b10010110	: sim_spm96 <= sx;
		8'b10010111	: sim_spm97 <= sx;
		8'b10011000	: sim_spm98 <= sx;
		8'b10011001	: sim_spm99 <= sx;
		8'b10011010	: sim_spm9A <= sx;
		8'b10011011	: sim_spm9B <= sx;
		8'b10011100	: sim_spm9C <= sx;
		8'b10011101	: sim_spm9D <= sx;
		8'b10011110	: sim_spm9E <= sx;
		8'b10011111	: sim_spm9F <= sx;
		8'b10100000	: sim_spmA0 <= sx;
		8'b10100001	: sim_spmA1 <= sx;
		8'b10100010	: sim_spmA2 <= sx;
		8'b10100011	: sim_spmA3 <= sx;
		8'b10100100	: sim_spmA4 <= sx;
		8'b10100101	: sim_spmA5 <= sx;
		8'b10100110	: sim_spmA6 <= sx;
		8'b10100111	: sim_spmA7 <= sx;
		8'b10101000	: sim_spmA8 <= sx;
		8'b10101001	: sim_spmA9 <= sx;
		8'b10101010	: sim_spmAA <= sx;
		8'b10101011	: sim_spmAB <= sx;
		8'b10101100	: sim_spmAC <= sx;
		8'b10101101	: sim_spmAD <= sx;
		8'b10101110	: sim_spmAE <= sx;
		8'b10101111	: sim_spmAF <= sx;
		8'b10110000	: sim_spmB0 <= sx;
		8'b10110001	: sim_spmB1 <= sx;
		8'b10110010	: sim_spmB2 <= sx;
		8'b10110011	: sim_spmB3 <= sx;
		8'b10110100	: sim_spmB4 <= sx;
		8'b10110101	: sim_spmB5 <= sx;
		8'b10110110	: sim_spmB6 <= sx;
		8'b10110111	: sim_spmB7 <= sx;
		8'b10111000	: sim_spmB8 <= sx;
		8'b10111001	: sim_spmB9 <= sx;
		8'b10111010	: sim_spmBA <= sx;
		8'b10111011	: sim_spmBB <= sx;
		8'b10111100	: sim_spmBC <= sx;
		8'b10111101	: sim_spmBD <= sx;
		8'b10111110	: sim_spmBE <= sx;
		8'b10111111	: sim_spmBF <= sx;
		8'b11000000	: sim_spmC0 <= sx;
		8'b11000001	: sim_spmC1 <= sx;
		8'b11000010	: sim_spmC2 <= sx;
		8'b11000011	: sim_spmC3 <= sx;
		8'b11000100	: sim_spmC4 <= sx;
		8'b11000101	: sim_spmC5 <= sx;
		8'b11000110	: sim_spmC6 <= sx;
		8'b11000111	: sim_spmC7 <= sx;
		8'b11001000	: sim_spmC8 <= sx;
		8'b11001001	: sim_spmC9 <= sx;
		8'b11001010	: sim_spmCA <= sx;
		8'b11001011	: sim_spmCB <= sx;
		8'b11001100	: sim_spmCC <= sx;
		8'b11001101	: sim_spmCD <= sx;
		8'b11001110	: sim_spmCE <= sx;
		8'b11001111	: sim_spmCF <= sx;
		8'b11010000	: sim_spmD0 <= sx;
		8'b11010001	: sim_spmD1 <= sx;
		8'b11010010	: sim_spmD2 <= sx;
		8'b11010011	: sim_spmD3 <= sx;
		8'b11010100	: sim_spmD4 <= sx;
		8'b11010101	: sim_spmD5 <= sx;
		8'b11010110	: sim_spmD6 <= sx;
		8'b11010111	: sim_spmD7 <= sx;
		8'b11011000	: sim_spmD8 <= sx;
		8'b11011001	: sim_spmD9 <= sx;
		8'b11011010	: sim_spmDA <= sx;
		8'b11011011	: sim_spmDB <= sx;
		8'b11011100	: sim_spmDC <= sx;
		8'b11011101	: sim_spmDD <= sx;
		8'b11011110	: sim_spmDE <= sx;
		8'b11011111	: sim_spmDF <= sx;
		8'b11100000	: sim_spmE0 <= sx;
		8'b11100001	: sim_spmE1 <= sx;
		8'b11100010	: sim_spmE2 <= sx;
		8'b11100011	: sim_spmE3 <= sx;
		8'b11100100	: sim_spmE4 <= sx;
		8'b11100101	: sim_spmE5 <= sx;
		8'b11100110	: sim_spmE6 <= sx;
		8'b11100111	: sim_spmE7 <= sx;
		8'b11101000	: sim_spmE8 <= sx;
		8'b11101001	: sim_spmE9 <= sx;
		8'b11101010	: sim_spmEA <= sx;
		8'b11101011	: sim_spmEB <= sx;
		8'b11101100	: sim_spmEC <= sx;
		8'b11101101	: sim_spmED <= sx;
		8'b11101110	: sim_spmEE <= sx;
		8'b11101111	: sim_spmEF <= sx;
		8'b11110000	: sim_spmF0 <= sx;
		8'b11110001	: sim_spmF1 <= sx;
		8'b11110010	: sim_spmF2 <= sx;
		8'b11110011	: sim_spmF3 <= sx;
		8'b11110100	: sim_spmF4 <= sx;
		8'b11110101	: sim_spmF5 <= sx;
		8'b11110110	: sim_spmF6 <= sx;
		8'b11110111	: sim_spmF7 <= sx;
		8'b11111000	: sim_spmF8 <= sx;
		8'b11111001	: sim_spmF9 <= sx;
		8'b11111010	: sim_spmFA <= sx;
		8'b11111011	: sim_spmFB <= sx;
		8'b11111100	: sim_spmFC <= sx;
		8'b11111101	: sim_spmFD <= sx;
		8'b11111110	: sim_spmFE <= sx;
		8'b11111111	: sim_spmFF <= sx;
    endcase
end

end

//
// Assignment of internal register variables to active registers 
//
if (bank == 1'b0) begin
	kcpsm6_status[1:16] <= "A,";
	sim_s0 <= bank_a_s0 ;
	sim_s1 <= bank_a_s1 ;
	sim_s2 <= bank_a_s2 ;
	sim_s3 <= bank_a_s3 ;
	sim_s4 <= bank_a_s4 ;
	sim_s5 <= bank_a_s5 ;
	sim_s6 <= bank_a_s6 ;
	sim_s7 <= bank_a_s7 ;
	sim_s8 <= bank_a_s8 ;
	sim_s9 <= bank_a_s9 ;
	sim_sA <= bank_a_sa ;
	sim_sB <= bank_a_sb ;
	sim_sC <= bank_a_sc ;
	sim_sD <= bank_a_sd ;
	sim_sE <= bank_a_se ;
	sim_sF <= bank_a_sf ;
end
else begin
	kcpsm6_status[1:16] <= "B,";
	sim_s0 <= bank_b_s0 ;
	sim_s1 <= bank_b_s1 ;
	sim_s2 <= bank_b_s2 ;
	sim_s3 <= bank_b_s3 ;
	sim_s4 <= bank_b_s4 ;
	sim_s5 <= bank_b_s5 ;
	sim_s6 <= bank_b_s6 ;
	sim_s7 <= bank_b_s7 ;
	sim_s8 <= bank_b_s8 ;
	sim_s9 <= bank_b_s9 ;
	sim_sA <= bank_b_sa ;
	sim_sB <= bank_b_sb ;
	sim_sC <= bank_b_sc ;
	sim_sD <= bank_b_sd ;
	sim_sE <= bank_b_se ;
	sim_sF <= bank_b_sf ;
end
// 
//
end //process simulation;
  
  //synthesis translate_on
//
// **************************
// * End of simulation code *
// **************************
//
//
///////////////////////////////////////////////////////////////////////////////////////////
//
endmodule
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE kcpsm6.v
//
///////////////////////////////////////////////////////////////////////////////////////////
