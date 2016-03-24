////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2004 Xilinx, Inc.
// All Rights Reserved
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: 1.30
//  \   \         Filename: kcpsm3.v
//  /   /         Date Last Modified:  August 5 2004
// /___/   /\     Date Created: May 19 2003
// \   \  /  \
//  \___\/\___\
//
//Device:  	Xilinx
//Purpose: 	
// Constant (K) Coded Programmable State Machine for Spartan-3 Devices.
// Also suitable for use with Virtex-II and Virtex-IIPRO devices.
//
// Includes additional code for enhanced verilog simulation. 
//
// Instruction disassembly concept inspired by the work of Prof. Dr.-Ing. Bernhard Lang.
// University of Applied Sciences, Osnabrueck, Germany.
//
// Format of this file.
//	--------------------
// This file contains the definition of KCPSM3 as one complete module This 'flat' 
// approach has been adopted to decrease 
// the time taken to load the module into simulators and the synthesis process.
//
// The module defines the implementation of the logic using Xilinx primitives.
// These ensure predictable synthesis results and maximise the density of the implementation. 
//
//Reference:
// 	None
//Revision History:
//    Rev 1.00 - kc -  Start of design entry,  May 19 2003.
//    Rev 1.20 - njs - Converted to verilog,  July 20 2004.
// 		Verilog version creation supported by Chip Lukes, 
//		Advanced Electronic Designs, Inc.
//		www.aedbozeman.com,
// 		chip.lukes@aedmt.com
//	Rev 1.21 - sus - Added text to adhere to HDL standard, August 4 2004. 
//	Rev 1.30 - njs - Updated as per VHDL version 1.30 August 5 2004. 
//
////////////////////////////////////////////////////////////////////////////////
// Contact: e-mail  picoblaze@xilinx.com
//////////////////////////////////////////////////////////////////////////////////
//
// Disclaimer: 
// LIMITED WARRANTY AND DISCLAIMER. These designs are
// provided to you "as is". Xilinx and its licensors make and you
// receive no warranties or conditions, express, implied,
// statutory or otherwise, and Xilinx specifically disclaims any
// implied warranties of merchantability, non-infringement, or
// fitness for a particular purpose. Xilinx does not warrant that
// the functions contained in these designs will meet your
// requirements, or that the operation of these designs will be
// uninterrupted or error free, or that defects in the Designs
// will be corrected. Furthermore, Xilinx does not warrant or
// make any representations regarding use or the results of the
// use of the designs in terms of correctness, accuracy,
// reliability, or otherwise.
//
// LIMITATION OF LIABILITY. In no event will Xilinx or its
// licensors be liable for any loss of data, lost profits, cost
// or procurement of substitute goods or services, or for any
// special, incidental, consequential, or indirect damages
// arising from the use or operation of the designs or
// accompanying documentation, however caused and on any theory
// of liability. This limitation will apply even if Xilinx
// has been advised of the possibility of such damage. This
// limitation shall apply not-withstanding the failure of the 
// essential purpose of any limited remedies herein. 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ps / 1ps

module kcpsm3(
 	address,
 	instruction,
 	port_id,
 	write_strobe,
 	out_port,
 	read_strobe,
 	in_port,
 	interrupt,
 	interrupt_ack,
 	reset,
 	clk) ;
 
output 	[9:0]	address ;
input 	[17:0]	instruction ;
output 	[7:0]	port_id ;
output 		write_strobe, read_strobe, interrupt_ack ;
output 	[7:0]	out_port ;
input 	[7:0]	in_port ;
input		interrupt, reset, clk ;
//
////////////////////////////////////////////////////////////////////////////////////
//
// Start of Main Architecture for KCPSM3
//
////////////////////////////////////////////////////////////////////////////////////
//
// Signals used in KCPSM3
//
////////////////////////////////////////////////////////////////////////////////////
//
// Fundamental control and decode signals
//	 
wire 		t_state ;
wire 		not_t_state ;
wire 		internal_reset ;
wire 		reset_delay ;
wire 		move_group ;
wire 		condition_met ;
wire 		normal_count ;
wire 		call_type ;
wire 		push_or_pop_type ;
wire 		valid_to_move ;
//
// Flag signals
// 
wire 		flag_type ;
wire 		flag_write ;
wire 		flag_enable ;
wire 		zero_flag ;
wire 		sel_shadow_zero ;
wire 		low_zero ;
wire 		high_zero ;
wire 		low_zero_carry ;
wire 		high_zero_carry ;
wire 		zero_carry ;
wire 		zero_fast_route ;
wire 		low_parity ;
wire 		high_parity ;
wire 		parity_carry ;
wire 		parity ;
wire 		carry_flag ;
wire 		sel_parity ;
wire 		sel_arith_carry ;
wire 		sel_shift_carry ;
wire 		sel_shadow_carry ;
wire 	[3:0]	sel_carry ;
wire 		carry_fast_route ;
//
// Interrupt signals
// 
wire 		active_interrupt ;
wire 		int_pulse ;
wire 		clean_int ;
wire 		shadow_carry ;
wire 		shadow_zero ;
wire 		int_enable ;
wire 		int_update_enable ;
wire 		int_enable_value ;
wire 		interrupt_ack_internal ;
//
// Program Counter signals
//
wire 	[9:0]	pc ;
wire 	[9:0]	pc_vector ;
wire 	[8:0]	pc_vector_carry ;
wire 	[9:0]	inc_pc_vector ;
wire 	[9:0]	pc_value ;
wire 	[8:0]	pc_value_carry ;
wire 	[9:0]	inc_pc_value ;
wire 		pc_enable ;
//
// Data Register signals
//
wire 	[7:0]	sx ;
wire 	[7:0]	sy ;
wire 		register_type ;
wire 		register_write ;
wire 		register_enable ;
wire 	[7:0]	second_operand ;
//
// Scratch Pad Memory signals
//
wire 	[7:0]	memory_data ;
wire 	[7:0]	store_data ;
wire 		memory_type ;
wire 		memory_write ;
wire 		memory_enable ;
//
// Stack signals
//
wire 	[9:0]	stack_pop_data ;
wire 	[9:0]	stack_ram_data ;
wire 	[4:0]	stack_address ;
wire 	[4:0]	half_stack_address ;
wire 	[3:0]	stack_address_carry ;
wire 	[4:0]	next_stack_address ;
wire 		stack_write_enable ;
wire 		not_active_interrupt ;
//
// ALU signals
//
wire 	[7:0]	logical_result ;
wire 	[7:0]	logical_value ;
wire 		sel_logical ;
wire 	[7:0]	shift_result ;
wire 	[7:0]	shift_value ;
wire 		sel_shift ;
wire 		high_shift_in ;
wire 		low_shift_in ;
wire 		shift_in ;
wire 		shift_carry ;
wire 		shift_carry_value ;
wire 	[7:0]	arith_result ;
wire 	[7:0]	arith_value ;
wire 	[7:0]	half_arith ;
wire 	[7:0]	arith_internal_carry ;
wire 		sel_arith_carry_in ;
wire 		arith_carry_in ;
wire 		invert_arith_carry ;
wire 		arith_carry_out ;
wire 		sel_arith ;
wire 		arith_carry ;
//
// ALU multiplexer signals
//
wire 		input_fetch_type ;
wire 		sel_group ;
wire 	[7:0]	alu_group ;
wire 	[7:0]	input_group ;
wire 	[7:0]	alu_result ;
//
// read and write strobes 
//
wire 		io_initial_decode ;
wire 		write_active ;
wire 		read_active ;
//
//
////////////////////////////////////////////////////////////////////////////////////
//
// XST attributes (Synplicity attributes are inline)

//synthesis attribute INIT of t_state_lut "1"; 
//synthesis attribute INIT of int_pulse_lut "0080";
//synthesis attribute INIT of int_update_lut "EAAA";
//synthesis attribute INIT of int_value_lut "04";
//synthesis attribute INIT of move_group_lut "7400";
//synthesis attribute INIT of condition_met_lut "5A3C";
//synthesis attribute INIT of normal_count_lut "2F";
//synthesis attribute INIT of call_type_lut "1000";
//synthesis attribute INIT of push_pop_lut "5400";
//synthesis attribute INIT of valid_move_lut "D";
//synthesis attribute INIT of flag_type_lut "41FC";
//synthesis attribute INIT of flag_enable_lut "8";
//synthesis attribute INIT of low_zero_lut "0001";
//synthesis attribute INIT of high_zero_lut "0001";
//synthesis attribute INIT of sel_shadow_zero_lut "3F";
//synthesis attribute INIT of low_parity_lut "6996";
//synthesis attribute INIT of high_parity_lut "6996";
//synthesis attribute INIT of sel_parity_lut "F3FF";
//synthesis attribute INIT of sel_arith_carry_lut "F3";
//synthesis attribute INIT of sel_shift_carry_lut "C";
//synthesis attribute INIT of sel_shadow_carry_lut "3";
//synthesis attribute INIT of register_type_lut "0145";
//synthesis attribute INIT of register_enable_lut "8";
//synthesis attribute INIT of memory_type_lut "0400";
//synthesis attribute INIT of memory_enable_lut "8000";
//synthesis attribute INIT of sel_logical_lut "FFE2";
//synthesis attribute INIT of low_shift_in_lut "E4";
//synthesis attribute INIT of high_shift_in_lut "E4";
//synthesis attribute INIT of shift_carry_lut "E4";
//synthesis attribute INIT of sel_arith_lut "1F";
//synthesis attribute INIT of input_fetch_type_lut "0002";
//synthesis attribute INIT of io_decode_lut "0010";
//synthesis attribute INIT of write_active_lut "4000";
//synthesis attribute INIT of read_active_lut "0100";
//
//synthesis attribute INIT of vector_select_mux_0 "E4";
//synthesis attribute INIT of vector_select_mux_1 "E4";
//synthesis attribute INIT of vector_select_mux_2 "E4";
//synthesis attribute INIT of vector_select_mux_3 "E4";
//synthesis attribute INIT of vector_select_mux_4 "E4";
//synthesis attribute INIT of vector_select_mux_5 "E4";
//synthesis attribute INIT of vector_select_mux_6 "E4";
//synthesis attribute INIT of vector_select_mux_7 "E4";
//synthesis attribute INIT of vector_select_mux_8 "E4";
//synthesis attribute INIT of vector_select_mux_9 "E4";
//synthesis attribute INIT of value_select_mux_0 "E4";
//synthesis attribute INIT of value_select_mux_1 "E4";
//synthesis attribute INIT of value_select_mux_2 "E4";
//synthesis attribute INIT of value_select_mux_3 "E4";
//synthesis attribute INIT of value_select_mux_4 "E4";
//synthesis attribute INIT of value_select_mux_5 "E4";
//synthesis attribute INIT of value_select_mux_6 "E4";
//synthesis attribute INIT of value_select_mux_7 "E4";
//synthesis attribute INIT of value_select_mux_8 "E4";
//synthesis attribute INIT of value_select_mux_9 "E4";
//
//synthesis attribute INIT of reg_loop_register_bit_0 "0000"; 
//synthesis attribute INIT of reg_loop_register_bit_1 "0000"; 
//synthesis attribute INIT of reg_loop_register_bit_2 "0000"; 
//synthesis attribute INIT of reg_loop_register_bit_3 "0000"; 
//synthesis attribute INIT of reg_loop_register_bit_4 "0000"; 
//synthesis attribute INIT of reg_loop_register_bit_5 "0000"; 
//synthesis attribute INIT of reg_loop_register_bit_6 "0000"; 
//synthesis attribute INIT of reg_loop_register_bit_7 "0000"; 
//synthesis attribute INIT of operand_select_mux_0 "E4"; 
//synthesis attribute INIT of operand_select_mux_1 "E4"; 
//synthesis attribute INIT of operand_select_mux_2 "E4"; 
//synthesis attribute INIT of operand_select_mux_3 "E4"; 
//synthesis attribute INIT of operand_select_mux_4 "E4"; 
//synthesis attribute INIT of operand_select_mux_5 "E4"; 
//synthesis attribute INIT of operand_select_mux_6 "E4"; 
//synthesis attribute INIT of operand_select_mux_7 "E4"; 
//
//synthesis attribute INIT of memory_bit_0 "0000000000000000"; 
//synthesis attribute INIT of memory_bit_1 "0000000000000000"; 
//synthesis attribute INIT of memory_bit_2 "0000000000000000"; 
//synthesis attribute INIT of memory_bit_3 "0000000000000000"; 
//synthesis attribute INIT of memory_bit_4 "0000000000000000"; 
//synthesis attribute INIT of memory_bit_5 "0000000000000000"; 
//synthesis attribute INIT of memory_bit_6 "0000000000000000"; 
//synthesis attribute INIT of memory_bit_7 "0000000000000000"; 
//
//synthesis attribute INIT of logical_lut_0 "6E8A"; 
//synthesis attribute INIT of logical_lut_1 "6E8A"; 
//synthesis attribute INIT of logical_lut_2 "6E8A"; 
//synthesis attribute INIT of logical_lut_3 "6E8A"; 
//synthesis attribute INIT of logical_lut_4 "6E8A"; 
//synthesis attribute INIT of logical_lut_5 "6E8A"; 
//synthesis attribute INIT of logical_lut_6 "6E8A"; 
//synthesis attribute INIT of logical_lut_7 "6E8A"; 
//
//synthesis attribute INIT of shift_mux_lut_0 "E4"; 
//synthesis attribute INIT of shift_mux_lut_1 "E4"; 
//synthesis attribute INIT of shift_mux_lut_2 "E4"; 
//synthesis attribute INIT of shift_mux_lut_3 "E4"; 
//synthesis attribute INIT of shift_mux_lut_4 "E4"; 
//synthesis attribute INIT of shift_mux_lut_5 "E4"; 
//synthesis attribute INIT of shift_mux_lut_6 "E4"; 
//synthesis attribute INIT of shift_mux_lut_7 "E4"; 

//synthesis attribute INIT of arith_carry_in_lut "6C"; 
//synthesis attribute INIT of arith_carry_out_lut "2"; 
//synthesis attribute INIT of arith_lut_0 "96"; 
//synthesis attribute INIT of arith_lut_1 "96"; 
//synthesis attribute INIT of arith_lut_2 "96"; 
//synthesis attribute INIT of arith_lut_3 "96"; 
//synthesis attribute INIT of arith_lut_4 "96"; 
//synthesis attribute INIT of arith_lut_5 "96"; 
//synthesis attribute INIT of arith_lut_6 "96"; 
//synthesis attribute INIT of arith_lut_7 "96"; 
//
//synthesis attribute INIT of or_lut_0 "FE"; 
//synthesis attribute INIT of or_lut_1 "FE"; 
//synthesis attribute INIT of or_lut_2 "FE"; 
//synthesis attribute INIT of or_lut_3 "FE"; 
//synthesis attribute INIT of or_lut_4 "FE"; 
//synthesis attribute INIT of or_lut_5 "FE"; 
//synthesis attribute INIT of or_lut_6 "FE"; 
//synthesis attribute INIT of or_lut_7 "FE"; 
//
//synthesis attribute INIT of mux_lut_0 "E4"; 
//synthesis attribute INIT of mux_lut_1 "E4"; 
//synthesis attribute INIT of mux_lut_2 "E4"; 
//synthesis attribute INIT of mux_lut_3 "E4"; 
//synthesis attribute INIT of mux_lut_4 "E4"; 
//synthesis attribute INIT of mux_lut_5 "E4"; 
//synthesis attribute INIT of mux_lut_6 "E4"; 
//synthesis attribute INIT of mux_lut_7 "E4"; 
//
//synthesis attribute INIT of stack_bit_0 "00000000"; 
//synthesis attribute INIT of stack_bit_1 "00000000"; 
//synthesis attribute INIT of stack_bit_2 "00000000"; 
//synthesis attribute INIT of stack_bit_3 "00000000"; 
//synthesis attribute INIT of stack_bit_4 "00000000"; 
//synthesis attribute INIT of stack_bit_5 "00000000"; 
//synthesis attribute INIT of stack_bit_6 "00000000"; 
//synthesis attribute INIT of stack_bit_7 "00000000"; 
//synthesis attribute INIT of stack_bit_8 "00000000"; 
//synthesis attribute INIT of stack_bit_9 "00000000"; 
//
//synthesis attribute INIT of count_lut_0 "6555"; 
//synthesis attribute INIT of count_lut_1 "A999"; 
//synthesis attribute INIT of count_lut_2 "A999"; 
//synthesis attribute INIT of count_lut_3 "A999"; 
//synthesis attribute INIT of count_lut_4 "A999"; 

////////////////////////////////////////////////////////////////////////////////////
//
// Start of KCPSM3 circuit description
//
////////////////////////////////////////////////////////////////////////////////////
//
// Fundamental Control
//
// Definition of T-state and internal reset
//
////////////////////////////////////////////////////////////////////////////////////
//
 // synthesis translate_off 
 defparam t_state_lut.INIT = 2'h1 ;
 // synthesis translate_on 
 LUT1 t_state_lut( 
 .I0(t_state),
 .O(not_t_state))/* synthesis xc_props = "INIT=1"*/;

 FDR toggle_flop ( 
 .D(not_t_state),
 .Q(t_state),
 .R(internal_reset),
 .C(clk));

 FDS reset_flop1 ( 
 .D(1'b0),
 .Q(reset_delay),
 .S(reset),
 .C(clk));

 FDS reset_flop2 ( 
 .D(reset_delay),
 .Q(internal_reset),
 .S(reset),
 .C(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// Interrupt input logic, Interrupt enable and shadow Flags.
//	
// Captures interrupt input and enables the shadow flags.
// Decodes instructions which set and reset the interrupt enable flip-flop. 
//
////////////////////////////////////////////////////////////////////////////////////
//
 // Interrupt capture

 FDR int_capture_flop ( 
 .D(interrupt),
 .Q(clean_int),
 .R(internal_reset),
 .C(clk));

 // synthesis translate_off 
 defparam int_pulse_lut.INIT = 16'h0080 ;
 // synthesis translate_on 
 LUT4 int_pulse_lut ( 
 .I0(t_state),
 .I1(clean_int),
 .I2(int_enable),
 .I3(active_interrupt),
 .O(int_pulse ))/* synthesis xc_props = "INIT=0080"*/;

 FDR int_flop ( 
 .D(int_pulse),
 .Q(active_interrupt),
 .R(internal_reset),
 .C(clk));

 FD ack_flop ( 
 .D(active_interrupt),
 .Q(interrupt_ack_internal),
 .C(clk));

 assign interrupt_ack = interrupt_ack_internal ;

 // Shadow flags

 FDE shadow_carry_flop ( 
 .D(carry_flag),
 .Q(shadow_carry),
 .CE(active_interrupt),
 .C(clk));

 FDE shadow_zero_flop ( 
 .D(zero_flag),
 .Q(shadow_zero),
 .CE(active_interrupt),
 .C(clk));

 // Decode instructions that set or reset interrupt enable

 // synthesis translate_off 
 defparam int_update_lut.INIT = 16'hEAAA ;
 // synthesis translate_on 
 LUT4 int_update_lut( 
 .I0(active_interrupt),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .I3(instruction[17]),
 .O(int_update_enable) )/* synthesis xc_props = "INIT=EAAA"*/;

 // synthesis translate_off 
 defparam int_value_lut.INIT = 8'h04 ;
 // synthesis translate_on 
 LUT3 int_value_lut ( 
 .I0(active_interrupt),
 .I1(instruction[0]),
 .I2(interrupt_ack_internal),
 .O(int_enable_value ))/* synthesis xc_props = "INIT=04"*/;

 FDRE int_enable_flop ( 
 .D(int_enable_value),
 .Q(int_enable),
 .CE(int_update_enable),
 .R(internal_reset),
 .C(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// Decodes for the control of the program counter and CALL/RETURN stack
//
////////////////////////////////////////////////////////////////////////////////////
//
 // synthesis translate_off 
 defparam move_group_lut.INIT = 16'h7400 ;
 // synthesis translate_on 
 LUT4 move_group_lut ( 
 .I0(instruction[14]),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .I3(instruction[17]),
 .O(move_group))/* synthesis xc_props = "INIT=7400"*/;

 // synthesis translate_off 
 defparam condition_met_lut.INIT = 16'h5A3C ;
 // synthesis translate_on 
 LUT4 condition_met_lut ( 
 .I0(carry_flag),
 .I1(zero_flag),
 .I2(instruction[10]),
 .I3(instruction[11]),
 .O(condition_met))/* synthesis xc_props = "INIT=5A3C"*/;

 // synthesis translate_off 
 defparam normal_count_lut.INIT = 8'h2F ;
 // synthesis translate_on 
 LUT3 normal_count_lut ( 
 .I0(instruction[12]),
 .I1(condition_met),
 .I2(move_group),
 .O(normal_count ))/* synthesis xc_props = "INIT=2F"*/;

 // synthesis translate_off 
 defparam call_type_lut.INIT = 16'h1000;
 // synthesis translate_on 
 LUT4 call_type_lut ( 
 .I0(instruction[14]),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .I3(instruction[17]),
 .O(call_type ))/* synthesis xc_props = "INIT=1000"*/;

 // synthesis translate_off 
 defparam push_pop_lut.INIT = 16'h5400;
 // synthesis translate_on 
 LUT4 push_pop_lut ( 
 .I0(instruction[14]),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .I3(instruction[17]),
 .O(push_or_pop_type))/* synthesis xc_props = "INIT=5400"*/;

 // synthesis translate_off 
 defparam valid_move_lut.INIT = 4'hD;
 // synthesis translate_on 
 LUT2 valid_move_lut ( 
 .I0(instruction[12]),
 .I1(condition_met),
 .O(valid_to_move ))/* synthesis xc_props = "INIT=D"*/;
//
////////////////////////////////////////////////////////////////////////////////////
//
// The ZERO and CARRY Flags
//
////////////////////////////////////////////////////////////////////////////////////
//
 // Enable for flags

 // synthesis translate_off 
 defparam flag_type_lut.INIT = 16'h41FC;
 // synthesis translate_on 
 LUT4 flag_type_lut ( 
 .I0(instruction[14]),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .I3(instruction[17]),
 .O(flag_type ))/* synthesis xc_props = "INIT=41FC"*/;

 FD flag_write_flop ( 
 .D(flag_type),
 .Q(flag_write),
 .C(clk));

 // synthesis translate_off 
 defparam flag_enable_lut.INIT = 4'h8;
 // synthesis translate_on 
 LUT2 flag_enable_lut ( 
 .I0(t_state),
 .I1(flag_write),
 .O(flag_enable))/* synthesis xc_props = "INIT=8"*/;

 // Zero Flag

 // synthesis translate_off 
 defparam low_zero_lut.INIT = 16'h0001;
 // synthesis translate_on 
 LUT4 low_zero_lut ( 
 .I0(alu_result[0]),
 .I1(alu_result[1]),
 .I2(alu_result[2]),
 .I3(alu_result[3]),
 .O(low_zero ))/* synthesis xc_props = "INIT=0001"*/;

 // synthesis translate_off 
 defparam high_zero_lut.INIT = 16'h0001;
 // synthesis translate_on 
 LUT4 high_zero_lut ( 
 .I0(alu_result[4]),
 .I1(alu_result[5]),
 .I2(alu_result[6]),
 .I3(alu_result[7]),
 .O(high_zero ))/* synthesis xc_props = "INIT=0001"*/;

 MUXCY low_zero_muxcy ( 
 .DI(1'b0),
 .CI(1'b1),
 .S(low_zero),
 .O(low_zero_carry));

 MUXCY high_zero_cymux ( 
 .DI(1'b0),
 .CI(low_zero_carry),
 .S(high_zero),
 .O(high_zero_carry));

 // synthesis translate_off 
 defparam sel_shadow_zero_lut.INIT = 8'h3F;
 // synthesis translate_on 
 LUT3 sel_shadow_zero_lut ( 
 .I0(shadow_zero),
 .I1(instruction[16]),
 .I2(instruction[17]),
 .O(sel_shadow_zero ))/* synthesis xc_props = "INIT=3F"*/;

 MUXCY zero_cymux ( 
 .DI(shadow_zero),
 .CI(high_zero_carry),
 .S(sel_shadow_zero),
 .O(zero_carry ));

 XORCY zero_xor( 
 .LI(1'b0),
 .CI(zero_carry),
 .O(zero_fast_route));
             
 FDRE zero_flag_flop ( 
 .D(zero_fast_route),
 .Q(zero_flag),
 .CE(flag_enable),
 .R(internal_reset),
 .C(clk));

 // Parity detection

 // synthesis translate_off 
 defparam low_parity_lut.INIT = 16'h6996;
 // synthesis translate_on 
 LUT4 low_parity_lut ( 
 .I0(logical_result[0]),
 .I1(logical_result[1]),
 .I2(logical_result[2]),
 .I3(logical_result[3]),
 .O(low_parity ))/* synthesis xc_props = "INIT=6996"*/;

 // synthesis translate_off 
 defparam high_parity_lut.INIT = 16'h6996;
 // synthesis translate_on 
 LUT4 high_parity_lut ( 
 .I0(logical_result[4]),
 .I1(logical_result[5]),
 .I2(logical_result[6]),
 .I3(logical_result[7]),
 .O(high_parity ))/* synthesis xc_props = "INIT=6996"*/;

 MUXCY parity_muxcy ( 
 .DI(1'b0),
 .CI(1'b1),
 .S(low_parity),
 .O(parity_carry) );

 XORCY parity_xor ( 
 .LI(high_parity),
 .CI(parity_carry),
 .O(parity));

 // CARRY flag selection

 // synthesis translate_off 
 defparam sel_parity_lut.INIT = 16'hF3FF;
 // synthesis translate_on 
 LUT4 sel_parity_lut ( 
 .I0(parity),
 .I1(instruction[13]),
 .I2(instruction[15]),
 .I3(instruction[16]),
 .O(sel_parity ))/* synthesis xc_props = "INIT=F3FF"*/;

 // synthesis translate_off 
 defparam sel_arith_carry_lut.INIT = 8'hF3;
 // synthesis translate_on 
 LUT3 sel_arith_carry_lut ( 
 .I0(arith_carry),
 .I1(instruction[16]),
 .I2(instruction[17]),
 .O(sel_arith_carry ))/* synthesis xc_props = "INIT=F3"*/;

 // synthesis translate_off 
 defparam sel_shift_carry_lut.INIT = 4'hC;
 // synthesis translate_on 
 LUT2 sel_shift_carry_lut ( 
 .I0(shift_carry),
 .I1(instruction[15]),
 .O(sel_shift_carry ))/* synthesis xc_props = "INIT=C"*/;

 // synthesis translate_off 
 defparam sel_shadow_carry_lut.INIT = 4'h3;
 // synthesis translate_on 
 LUT2 sel_shadow_carry_lut ( 
 .I0(shadow_carry),
 .I1(instruction[17]),
 .O(sel_shadow_carry ))/* synthesis xc_props = "INIT=3"*/;

 MUXCY sel_shadow_muxcy ( 
 .DI(shadow_carry),
 .CI(1'b0),
 .S(sel_shadow_carry),
 .O(sel_carry[0]) );

 MUXCY sel_shift_muxcy ( 
 .DI(shift_carry),
 .CI(sel_carry[0]),
 .S(sel_shift_carry),
 .O(sel_carry[1]) );

 MUXCY sel_arith_muxcy ( 
 .DI(arith_carry),
 .CI(sel_carry[1]),
 .S(sel_arith_carry),
 .O(sel_carry[2]) );

 MUXCY sel_parity_muxcy ( 
 .DI(parity),
 .CI(sel_carry[2]),
 .S(sel_parity),
 .O(sel_carry[3]) );

 XORCY carry_xor(
 .LI(1'b0),
 .CI(sel_carry[3]),
 .O(carry_fast_route));
             
 FDRE carry_flag_flop ( 
 .D(carry_fast_route),
 .Q(carry_flag),
 .CE(flag_enable),
 .R(internal_reset),
 .C(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// The Program Counter
//
// Definition of a 10-bit counter which can be loaded from two sources
//
////////////////////////////////////////////////////////////////////////////////////
//	

 INV invert_enable(// Inverter should be implemented in the CE to flip flops
 .I(t_state),
 .O(pc_enable)); 
 
 // pc_loop

 // synthesis translate_off 
 defparam vector_select_mux_0.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_0 ( 
 .I0(instruction[15]),
 .I1(instruction[0]),
 .I2(stack_pop_data[0]), 
 .O(pc_vector[0]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_0.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_0(
 .I0(normal_count),
 .I1(inc_pc_vector[0]),
 .I2(pc[0]),
 .O(pc_value[0]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_0 ( 
 .D(inc_pc_value[0]),
 .Q(pc[0]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 MUXCY pc_vector_muxcy_0 ( 
 .DI(1'b0),
 .CI(instruction[13]),
 .S(pc_vector[0]),
 .O(pc_vector_carry[0]));

 XORCY pc_vector_xor_0 ( 
 .LI(pc_vector[0]),
 .CI(instruction[13]),
 .O(inc_pc_vector[0]));

 MUXCY pc_value_muxcy_0 ( 
 .DI(1'b0),
 .CI(normal_count),
 .S(pc_value[0]),
 .O(pc_value_carry[0]));

 XORCY pc_value_xor_0 ( 
 .LI(pc_value[0]),
 .CI(normal_count),
 .O(inc_pc_value[0]));

 // synthesis translate_off 
 defparam vector_select_mux_1.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_1 ( 
 .I0(instruction[15]),
 .I1(instruction[1]),
 .I2(stack_pop_data[1]), 
 .O(pc_vector[1]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_1.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_1(
 .I0(normal_count),
 .I1(inc_pc_vector[1]),
 .I2(pc[1]),
 .O(pc_value[1]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_1 ( 
 .D(inc_pc_value[1]),
 .Q(pc[1]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 MUXCY pc_vector_muxcy_1 ( 
 .DI(1'b0),
 .CI(pc_vector_carry[0]),
 .S(pc_vector[1]),
 .O(pc_vector_carry[1]));

 XORCY pc_vector_xor_1 ( 
 .LI(pc_vector[1]),
 .CI(pc_vector_carry[0]),
 .O(inc_pc_vector[1]));

 MUXCY pc_value_muxcy_1 ( 
 .DI(1'b0),
 .CI(pc_value_carry[0]),
 .S(pc_value[1]),
 .O(pc_value_carry[1]));

 XORCY pc_value_xor_1 ( 
 .LI(pc_value[1]),
 .CI(pc_value_carry[0]),
 .O(inc_pc_value[1]));
 
 // synthesis translate_off 
 defparam vector_select_mux_2.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_2 ( 
 .I0(instruction[15]),
 .I1(instruction[2]),
 .I2(stack_pop_data[2]), 
 .O(pc_vector[2]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_2.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_2(
 .I0(normal_count),
 .I1(inc_pc_vector[2]),
 .I2(pc[2]),
 .O(pc_value[2]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_2 ( 
 .D(inc_pc_value[2]),
 .Q(pc[2]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 MUXCY pc_vector_muxcy_2 ( 
 .DI(1'b0),
 .CI(pc_vector_carry[1]),
 .S(pc_vector[2]),
 .O(pc_vector_carry[2]));

 XORCY pc_vector_xor_2 ( 
 .LI(pc_vector[2]),
 .CI(pc_vector_carry[1]),
 .O(inc_pc_vector[2]));

 MUXCY pc_value_muxcy_2 ( 
 .DI(1'b0),
 .CI(pc_value_carry[1]),
 .S(pc_value[2]),
 .O(pc_value_carry[2]));

 XORCY pc_value_xor_2 ( 
 .LI(pc_value[2]),
 .CI(pc_value_carry[1]),
 .O(inc_pc_value[2]));
 
 // synthesis translate_off 
 defparam vector_select_mux_3.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_3 ( 
 .I0(instruction[15]),
 .I1(instruction[3]),
 .I2(stack_pop_data[3]), 
 .O(pc_vector[3]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_3.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_3(
 .I0(normal_count),
 .I1(inc_pc_vector[3]),
 .I2(pc[3]),
 .O(pc_value[3]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_3 ( 
 .D(inc_pc_value[3]),
 .Q(pc[3]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 MUXCY pc_vector_muxcy_3 ( 
 .DI(1'b0),
 .CI(pc_vector_carry[2]),
 .S(pc_vector[3]),
 .O(pc_vector_carry[3]));

 XORCY pc_vector_xor_3 ( 
 .LI(pc_vector[3]),
 .CI(pc_vector_carry[2]),
 .O(inc_pc_vector[3]));

 MUXCY pc_value_muxcy_3 ( 
 .DI(1'b0),
 .CI(pc_value_carry[2]),
 .S(pc_value[3]),
 .O(pc_value_carry[3]));

 XORCY pc_value_xor_3 ( 
 .LI(pc_value[3]),
 .CI(pc_value_carry[2]),
 .O(inc_pc_value[3]));
 
 // synthesis translate_off 
 defparam vector_select_mux_4.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_4 ( 
 .I0(instruction[15]),
 .I1(instruction[4]),
 .I2(stack_pop_data[4]), 
 .O(pc_vector[4]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_4.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_4(
 .I0(normal_count),
 .I1(inc_pc_vector[4]),
 .I2(pc[4]),
 .O(pc_value[4]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_4 ( 
 .D(inc_pc_value[4]),
 .Q(pc[4]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 MUXCY pc_vector_muxcy_4 ( 
 .DI(1'b0),
 .CI(pc_vector_carry[3]),
 .S(pc_vector[4]),
 .O(pc_vector_carry[4]));

 XORCY pc_vector_xor_4 ( 
 .LI(pc_vector[4]),
 .CI(pc_vector_carry[3]),
 .O(inc_pc_vector[4]));

 MUXCY pc_value_muxcy_4 ( 
 .DI(1'b0),
 .CI(pc_value_carry[3]),
 .S(pc_value[4]),
 .O(pc_value_carry[4]));

 XORCY pc_value_xor_4 ( 
 .LI(pc_value[4]),
 .CI(pc_value_carry[3]),
 .O(inc_pc_value[4]));
 
 // synthesis translate_off 
 defparam vector_select_mux_5.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_5 ( 
 .I0(instruction[15]),
 .I1(instruction[5]),
 .I2(stack_pop_data[5]), 
 .O(pc_vector[5]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_5.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_5(
 .I0(normal_count),
 .I1(inc_pc_vector[5]),
 .I2(pc[5]),
 .O(pc_value[5]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_5 ( 
 .D(inc_pc_value[5]),
 .Q(pc[5]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 MUXCY pc_vector_muxcy_5 ( 
 .DI(1'b0),
 .CI(pc_vector_carry[4]),
 .S(pc_vector[5]),
 .O(pc_vector_carry[5]));

 XORCY pc_vector_xor_5 ( 
 .LI(pc_vector[5]),
 .CI(pc_vector_carry[4]),
 .O(inc_pc_vector[5]));

 MUXCY pc_value_muxcy_5 ( 
 .DI(1'b0),
 .CI(pc_value_carry[4]),
 .S(pc_value[5]),
 .O(pc_value_carry[5]));

 XORCY pc_value_xor_5 ( 
 .LI(pc_value[5]),
 .CI(pc_value_carry[4]),
 .O(inc_pc_value[5]));
 
 // synthesis translate_off 
 defparam vector_select_mux_6.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_6 ( 
 .I0(instruction[15]),
 .I1(instruction[6]),
 .I2(stack_pop_data[6]), 
 .O(pc_vector[6]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_6.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_6(
 .I0(normal_count),
 .I1(inc_pc_vector[6]),
 .I2(pc[6]),
 .O(pc_value[6]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_6 ( 
 .D(inc_pc_value[6]),
 .Q(pc[6]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 MUXCY pc_vector_muxcy_6 ( 
 .DI(1'b0),
 .CI(pc_vector_carry[5]),
 .S(pc_vector[6]),
 .O(pc_vector_carry[6]));

 XORCY pc_vector_xor_6 ( 
 .LI(pc_vector[6]),
 .CI(pc_vector_carry[5]),
 .O(inc_pc_vector[6]));

 MUXCY pc_value_muxcy_6 ( 
 .DI(1'b0),
 .CI(pc_value_carry[5]),
 .S(pc_value[6]),
 .O(pc_value_carry[6]));

 XORCY pc_value_xor_6 ( 
 .LI(pc_value[6]),
 .CI(pc_value_carry[5]),
 .O(inc_pc_value[6]));
     
 // synthesis translate_off 
 defparam vector_select_mux_7.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_7 ( 
 .I0(instruction[15]),
 .I1(instruction[7]),
 .I2(stack_pop_data[7]), 
 .O(pc_vector[7]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_7.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_7(
 .I0(normal_count),
 .I1(inc_pc_vector[7]),
 .I2(pc[7]),
 .O(pc_value[7]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_7 ( 
 .D(inc_pc_value[7]),
 .Q(pc[7]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 MUXCY pc_vector_muxcy_7 ( 
 .DI(1'b0),
 .CI(pc_vector_carry[6]),
 .S(pc_vector[7]),
 .O(pc_vector_carry[7]));

 XORCY pc_vector_xor_7 ( 
 .LI(pc_vector[7]),
 .CI(pc_vector_carry[6]),
 .O(inc_pc_vector[7]));

 MUXCY pc_value_muxcy_7 ( 
 .DI(1'b0),
 .CI(pc_value_carry[6]),
 .S(pc_value[7]),
 .O(pc_value_carry[7]));

 XORCY pc_value_xor_7 ( 
 .LI(pc_value[7]),
 .CI(pc_value_carry[6]),
 .O(inc_pc_value[7]));
 
 // synthesis translate_off 
 defparam vector_select_mux_8.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_8 ( 
 .I0(instruction[15]),
 .I1(instruction[8]),
 .I2(stack_pop_data[8]), 
 .O(pc_vector[8]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_8.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_8(
 .I0(normal_count),
 .I1(inc_pc_vector[8]),
 .I2(pc[8]),
 .O(pc_value[8]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_8 ( 
 .D(inc_pc_value[8]),
 .Q(pc[8]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 MUXCY pc_vector_muxcy_8 ( 
 .DI(1'b0),
 .CI(pc_vector_carry[7]),
 .S(pc_vector[8]),
 .O(pc_vector_carry[8]));

 XORCY pc_vector_xor_8 ( 
 .LI(pc_vector[8]),
 .CI(pc_vector_carry[7]),
 .O(inc_pc_vector[8]));

 MUXCY pc_value_muxcy_8 ( 
 .DI(1'b0),
 .CI(pc_value_carry[7]),
 .S(pc_value[8]),
 .O(pc_value_carry[8]));

 XORCY pc_value_xor_8 ( 
 .LI(pc_value[8]),
 .CI(pc_value_carry[7]),
 .O(inc_pc_value[8]));
 
 // synthesis translate_off 
 defparam vector_select_mux_9.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 vector_select_mux_9 ( 
 .I0(instruction[15]),
 .I1(instruction[9]),
 .I2(stack_pop_data[9]), 
 .O(pc_vector[9]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam value_select_mux_9.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 value_select_mux_9(
 .I0(normal_count),
 .I1(inc_pc_vector[9]),
 .I2(pc[9]),
 .O(pc_value[9]))/* synthesis xc_props = "INIT=E4"*/;

 FDRSE pc_loop_register_bit_9 ( 
 .D(inc_pc_value[9]),
 .Q(pc[9]),
 .R(internal_reset),
 .S(active_interrupt),
 .CE(pc_enable),
 .C(clk));

 XORCY pc_vector_xor_high ( 
 .LI(pc_vector[9]),
 .CI(pc_vector_carry[8]),
 .O(inc_pc_vector[9]));

 XORCY pc_value_xor_high ( 
 .LI(pc_value[9]),
 .CI(pc_value_carry[8]),
 .O(inc_pc_value[9]));

 //end pc_loop;
 			
 assign address = pc;
//
////////////////////////////////////////////////////////////////////////////////////
//
// Register Bank and second operand selection.
//
// Definition of an 8-bit dual port RAM with 16 locations 
// including write enable decode.
//
// Outputs are assigned to PORT_ID and OUT_PORT.
//
////////////////////////////////////////////////////////////////////////////////////
//	
 // Forming decode signal

 // synthesis translate_off 
 defparam register_type_lut.INIT = 16'h0145;
 // synthesis translate_on 
 LUT4 register_type_lut ( 
 .I0(active_interrupt),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .I3(instruction[17]),
 .O(register_type ))/* synthesis xc_props = "INIT=0145"*/;

 FD register_write_flop ( 
 .D(register_type),
 .Q(register_write),
 .C(clk));

 // synthesis translate_off 
 defparam register_enable_lut.INIT = 4'h8;
 // synthesis translate_on 
 LUT2 register_enable_lut ( 
 .I0(t_state),
 .I1(register_write),
 .O(register_enable))/* synthesis xc_props = "INIT=8"*/;

 //reg_loop

 // synthesis translate_off 
 defparam reg_loop_register_bit_0.INIT = 16'h0000;
 // synthesis translate_on 
 RAM16X1D reg_loop_register_bit_0 ( 
 .D(alu_result[0]),
 .WE(register_enable),
 .WCLK(clk),
 .A0(instruction[8]),
 .A1(instruction[9]),
 .A2(instruction[10]),
 .A3(instruction[11]),
 .DPRA0(instruction[4]),
 .DPRA1(instruction[5]),
 .DPRA2(instruction[6]),
 .DPRA3(instruction[7]),
 .SPO(sx[0]),
 .DPO(sy[0]))/* synthesis xc_props = "INIT=0000"*/;

 // synthesis translate_off 
 defparam operand_select_mux_0.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 operand_select_mux_0 ( 
 .I0(instruction[12]),
 .I1(instruction[0]),
 .I2(sy[0]),
 .O(second_operand[0]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam reg_loop_register_bit_1.INIT = 16'h0000;
 // synthesis translate_on 
 RAM16X1D reg_loop_register_bit_1 ( 
 .D(alu_result[1]),
 .WE(register_enable),
 .WCLK(clk),
 .A0(instruction[8]),
 .A1(instruction[9]),
 .A2(instruction[10]),
 .A3(instruction[11]),
 .DPRA0(instruction[4]),
 .DPRA1(instruction[5]),
 .DPRA2(instruction[6]),
 .DPRA3(instruction[7]),
 .SPO(sx[1]),
 .DPO(sy[1]))/* synthesis xc_props = "INIT=0000"*/;

 // synthesis translate_off 
 defparam operand_select_mux_1.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 operand_select_mux_1 ( 
 .I0(instruction[12]),
 .I1(instruction[1]),
 .I2(sy[1]),
 .O(second_operand[1]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam reg_loop_register_bit_2.INIT = 16'h0000;
 // synthesis translate_on 
 RAM16X1D reg_loop_register_bit_2 ( 
 .D(alu_result[2]),
 .WE(register_enable),
 .WCLK(clk),
 .A0(instruction[8]),
 .A1(instruction[9]),
 .A2(instruction[10]),
 .A3(instruction[11]),
 .DPRA0(instruction[4]),
 .DPRA1(instruction[5]),
 .DPRA2(instruction[6]),
 .DPRA3(instruction[7]),
 .SPO(sx[2]),
 .DPO(sy[2]))/* synthesis xc_props = "INIT=0000"*/;

 // synthesis translate_off 
 defparam operand_select_mux_2.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 operand_select_mux_2 ( 
 .I0(instruction[12]),
 .I1(instruction[2]),
 .I2(sy[2]),
 .O(second_operand[2]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam reg_loop_register_bit_3.INIT = 16'h0000;
 // synthesis translate_on 
 RAM16X1D reg_loop_register_bit_3 ( 
 .D(alu_result[3]),
 .WE(register_enable),
 .WCLK(clk),
 .A0(instruction[8]),
 .A1(instruction[9]),
 .A2(instruction[10]),
 .A3(instruction[11]),
 .DPRA0(instruction[4]),
 .DPRA1(instruction[5]),
 .DPRA2(instruction[6]),
 .DPRA3(instruction[7]),
 .SPO(sx[3]),
 .DPO(sy[3]))/* synthesis xc_props = "INIT=0000"*/;

 // synthesis translate_off 
 defparam operand_select_mux_3.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 operand_select_mux_3 ( 
 .I0(instruction[12]),
 .I1(instruction[3]),
 .I2(sy[3]),
 .O(second_operand[3]))/* synthesis xc_props = "INIT=E4"*/;
  
 // synthesis translate_off 
 defparam reg_loop_register_bit_4.INIT = 16'h0000;
 // synthesis translate_on 
 RAM16X1D reg_loop_register_bit_4 ( 
 .D(alu_result[4]),
 .WE(register_enable),
 .WCLK(clk),
 .A0(instruction[8]),
 .A1(instruction[9]),
 .A2(instruction[10]),
 .A3(instruction[11]),
 .DPRA0(instruction[4]),
 .DPRA1(instruction[5]),
 .DPRA2(instruction[6]),
 .DPRA3(instruction[7]),
 .SPO(sx[4]),
 .DPO(sy[4]))/* synthesis xc_props = "INIT=0000"*/;

 // synthesis translate_off 
 defparam operand_select_mux_4.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 operand_select_mux_4 ( 
 .I0(instruction[12]),
 .I1(instruction[4]),
 .I2(sy[4]),
 .O(second_operand[4]))/* synthesis xc_props = "INIT=E4"*/;
 
 // synthesis translate_off 
 defparam reg_loop_register_bit_5.INIT = 16'h0000;
 // synthesis translate_on 
 RAM16X1D reg_loop_register_bit_5 ( 
 .D(alu_result[5]),
 .WE(register_enable),
 .WCLK(clk),
 .A0(instruction[8]),
 .A1(instruction[9]),
 .A2(instruction[10]),
 .A3(instruction[11]),
 .DPRA0(instruction[4]),
 .DPRA1(instruction[5]),
 .DPRA2(instruction[6]),
 .DPRA3(instruction[7]),
 .SPO(sx[5]),
 .DPO(sy[5]))/* synthesis xc_props = "INIT=0000"*/;

 // synthesis translate_off 
 defparam operand_select_mux_5.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 operand_select_mux_5 ( 
 .I0(instruction[12]),
 .I1(instruction[5]),
 .I2(sy[5]),
 .O(second_operand[5]))/* synthesis xc_props = "INIT=E4"*/;
 
 // synthesis translate_off 
 defparam reg_loop_register_bit_6.INIT = 16'h0000;
 // synthesis translate_on 
 RAM16X1D reg_loop_register_bit_6 ( 
 .D(alu_result[6]),
 .WE(register_enable),
 .WCLK(clk),
 .A0(instruction[8]),
 .A1(instruction[9]),
 .A2(instruction[10]),
 .A3(instruction[11]),
 .DPRA0(instruction[4]),
 .DPRA1(instruction[5]),
 .DPRA2(instruction[6]),
 .DPRA3(instruction[7]),
 .SPO(sx[6]),
 .DPO(sy[6]))/* synthesis xc_props = "INIT=0000"*/;

 // synthesis translate_off 
 defparam operand_select_mux_6.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 operand_select_mux_6 ( 
 .I0(instruction[12]),
 .I1(instruction[6]),
 .I2(sy[6]),
 .O(second_operand[6]))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam reg_loop_register_bit_7.INIT = 16'h0000;
 // synthesis translate_on 
 RAM16X1D reg_loop_register_bit_7 ( 
 .D(alu_result[7]),
 .WE(register_enable),
 .WCLK(clk),
 .A0(instruction[8]),
 .A1(instruction[9]),
 .A2(instruction[10]),
 .A3(instruction[11]),
 .DPRA0(instruction[4]),
 .DPRA1(instruction[5]),
 .DPRA2(instruction[6]),
 .DPRA3(instruction[7]),
 .SPO(sx[7]),
 .DPO(sy[7]))/* synthesis xc_props = "INIT=0000"*/;

 // synthesis translate_off 
 defparam operand_select_mux_7.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 operand_select_mux_7 ( 
 .I0(instruction[12]),
 .I1(instruction[7]),
 .I2(sy[7]),
 .O(second_operand[7]))/* synthesis xc_props = "INIT=E4"*/;
    
 assign out_port = sx;
 assign port_id = second_operand;
//
////////////////////////////////////////////////////////////////////////////////////
//
// Store Memory
//
// Definition of an 8-bit single port RAM with 64 locations 
// including write enable decode.
//
////////////////////////////////////////////////////////////////////////////////////
//	
 // Forming decode signal

 // synthesis translate_off 
 defparam memory_type_lut.INIT = 16'h0400;
 // synthesis translate_on 
 LUT4 memory_type_lut ( 
 .I0(active_interrupt),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .I3(instruction[17]),
 .O(memory_type ))/* synthesis xc_props = "INIT=0400"*/;

 FD memory_write_flop ( 
 .D(memory_type),
 .Q(memory_write),
 .C(clk));

 // synthesis translate_off 
 defparam memory_enable_lut.INIT = 16'h8000;
 // synthesis translate_on 
 LUT4 memory_enable_lut ( 
 .I0(t_state),
 .I1(instruction[13]),
 .I2(instruction[14]),
 .I3(memory_write),
 .O(memory_enable ))/* synthesis xc_props = "INIT=8000"*/;

 // store_loop

 // synthesis translate_off 
 defparam memory_bit_0.INIT = 64'h0000000000000000;
 // synthesis translate_on 
 RAM64X1S memory_bit_0 ( 
 .D(sx[0]),
 .WE(memory_enable),
 .WCLK(clk),
 .A0(second_operand[0]),
 .A1(second_operand[1]),
 .A2(second_operand[2]),
 .A3(second_operand[3]),
 .A4(second_operand[4]),
 .A5(second_operand[5]),
 .O(memory_data[0]))/* synthesis xc_props = "INIT=0000000000000000"*/;

 FD store_flop_0 ( 
 .D(memory_data[0]),
 .Q(store_data[0]),
 .C(clk));

 // synthesis translate_off 
 defparam memory_bit_1.INIT = 64'h0000000000000000;
 // synthesis translate_on 
 RAM64X1S memory_bit_1 ( 
 .D(sx[1]),
 .WE(memory_enable),
 .WCLK(clk),
 .A0(second_operand[0]),
 .A1(second_operand[1]),
 .A2(second_operand[2]),
 .A3(second_operand[3]),
 .A4(second_operand[4]),
 .A5(second_operand[5]),
 .O(memory_data[1]))/* synthesis xc_props = "INIT=0000000000000000"*/;

 FD store_flop_1 ( 
 .D(memory_data[1]),
 .Q(store_data[1]),
 .C(clk));

 // synthesis translate_off 
 defparam memory_bit_2.INIT = 64'h0000000000000000;
 // synthesis translate_on 
 RAM64X1S memory_bit_2 ( 
 .D(sx[2]),
 .WE(memory_enable),
 .WCLK(clk),
 .A0(second_operand[0]),
 .A1(second_operand[1]),
 .A2(second_operand[2]),
 .A3(second_operand[3]),
 .A4(second_operand[4]),
 .A5(second_operand[5]),
 .O(memory_data[2]))/* synthesis xc_props = "INIT=0000000000000000"*/;

 FD store_flop_2 ( 
 .D(memory_data[2]),
 .Q(store_data[2]),
 .C(clk));

 // synthesis translate_off 
 defparam memory_bit_3.INIT = 64'h0000000000000000;
 // synthesis translate_on 
 RAM64X1S memory_bit_3 ( 
 .D(sx[3]),
 .WE(memory_enable),
 .WCLK(clk),
 .A0(second_operand[0]),
 .A1(second_operand[1]),
 .A2(second_operand[2]),
 .A3(second_operand[3]),
 .A4(second_operand[4]),
 .A5(second_operand[5]),
 .O(memory_data[3]))/* synthesis xc_props = "INIT=0000000000000000"*/;

 FD store_flop_3 ( 
 .D(memory_data[3]),
 .Q(store_data[3]),
 .C(clk));

 // synthesis translate_off 
 defparam memory_bit_4.INIT = 64'h0000000000000000;
 // synthesis translate_on 
 RAM64X1S memory_bit_4 ( 
 .D(sx[4]),
 .WE(memory_enable),
 .WCLK(clk),
 .A0(second_operand[0]),
 .A1(second_operand[1]),
 .A2(second_operand[2]),
 .A3(second_operand[3]),
 .A4(second_operand[4]),
 .A5(second_operand[5]),
 .O(memory_data[4]))/* synthesis xc_props = "INIT=0000000000000000"*/;

 FD store_flop_4 ( 
 .D(memory_data[4]),
 .Q(store_data[4]),
 .C(clk));

 // synthesis translate_off 
 defparam memory_bit_5.INIT = 64'h0000000000000000;
 // synthesis translate_on 
 RAM64X1S memory_bit_5 ( 
 .D(sx[5]),
 .WE(memory_enable),
 .WCLK(clk),
 .A0(second_operand[0]),
 .A1(second_operand[1]),
 .A2(second_operand[2]),
 .A3(second_operand[3]),
 .A4(second_operand[4]),
 .A5(second_operand[5]),
 .O(memory_data[5]))/* synthesis xc_props = "INIT=0000000000000000"*/;

 FD store_flop_5 ( 
 .D(memory_data[5]),
 .Q(store_data[5]),
 .C(clk));

 // synthesis translate_off 
 defparam memory_bit_6.INIT = 64'h0000000000000000;
 // synthesis translate_on 
 RAM64X1S memory_bit_6 ( 
 .D(sx[6]),
 .WE(memory_enable),
 .WCLK(clk),
 .A0(second_operand[0]),
 .A1(second_operand[1]),
 .A2(second_operand[2]),
 .A3(second_operand[3]),
 .A4(second_operand[4]),
 .A5(second_operand[5]),
 .O(memory_data[6]))/* synthesis xc_props = "INIT=0000000000000000"*/;

 FD store_flop_6 ( 
 .D(memory_data[6]),
 .Q(store_data[6]),
 .C(clk));

 // synthesis translate_off 
 defparam memory_bit_7.INIT = 64'h0000000000000000;
 // synthesis translate_on 
 RAM64X1S memory_bit_7 ( 
 .D(sx[7]),
 .WE(memory_enable),
 .WCLK(clk),
 .A0(second_operand[0]),
 .A1(second_operand[1]),
 .A2(second_operand[2]),
 .A3(second_operand[3]),
 .A4(second_operand[4]),
 .A5(second_operand[5]),
 .O(memory_data[7]))/* synthesis xc_props = "INIT=0000000000000000"*/;

 FD store_flop_7 ( 
 .D(memory_data[7]),
 .Q(store_data[7]),
 .C(clk));
      
//
////////////////////////////////////////////////////////////////////////////////////
//
// Logical operations
//
// Definition of AND, OR, XOR and LOAD functions which also provides TEST.
// Includes pipeline stage used to form ALU multiplexer including decode.
//
////////////////////////////////////////////////////////////////////////////////////
//
 // synthesis translate_off 
 defparam sel_logical_lut.INIT = 16'hFFE2;
 // synthesis translate_on 
 LUT4 sel_logical_lut ( 
 .I0(instruction[14]),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .I3(instruction[17]),
 .O(sel_logical ))/* synthesis xc_props = "INIT=FFE2"*/;

 // logical_loop

 // synthesis translate_off 
 defparam logical_lut_0.INIT = 16'h6E8A;
 // synthesis translate_on 
 LUT4 logical_lut_0 ( 
 .I0(second_operand[0]),
 .I1(sx[0]),
 .I2(instruction[13]),
 .I3(instruction[14]),
 .O(logical_value[0]))/* synthesis xc_props = "INIT=6E8A"*/;

 FDR logical_flop_0 ( 
 .D(logical_value[0]),
 .Q(logical_result[0]),
 .R(sel_logical),
 .C(clk));

 // synthesis translate_off 
 defparam logical_lut_1.INIT = 16'h6E8A;
 // synthesis translate_on 
 LUT4 logical_lut_1 ( 
 .I0(second_operand[1]),
 .I1(sx[1]),
 .I2(instruction[13]),
 .I3(instruction[14]),
 .O(logical_value[1]))/* synthesis xc_props = "INIT=6E8A"*/;

 FDR logical_flop_1 ( 
 .D(logical_value[1]),
 .Q(logical_result[1]),
 .R(sel_logical),
 .C(clk));
 
 // synthesis translate_off 
 defparam logical_lut_2.INIT = 16'h6E8A;
 // synthesis translate_on 
 LUT4 logical_lut_2 ( 
 .I0(second_operand[2]),
 .I1(sx[2]),
 .I2(instruction[13]),
 .I3(instruction[14]),
 .O(logical_value[2]))/* synthesis xc_props = "INIT=6E8A"*/;

 FDR logical_flop_2 ( 
 .D(logical_value[2]),
 .Q(logical_result[2]),
 .R(sel_logical),
 .C(clk));
 
 // synthesis translate_off 
 defparam logical_lut_3.INIT = 16'h6E8A;
 // synthesis translate_on 
 LUT4 logical_lut_3 ( 
 .I0(second_operand[3]),
 .I1(sx[3]),
 .I2(instruction[13]),
 .I3(instruction[14]),
 .O(logical_value[3]))/* synthesis xc_props = "INIT=6E8A"*/;

 FDR logical_flop_3 ( 
 .D(logical_value[3]),
 .Q(logical_result[3]),
 .R(sel_logical),
 .C(clk));

 // synthesis translate_off 
 defparam logical_lut_4.INIT = 16'h6E8A;
 // synthesis translate_on 
 LUT4 logical_lut_4 ( 
 .I0(second_operand[4]),
 .I1(sx[4]),
 .I2(instruction[13]),
 .I3(instruction[14]),
 .O(logical_value[4]))/* synthesis xc_props = "INIT=6E8A"*/;

 FDR logical_flop_4 ( 
 .D(logical_value[4]),
 .Q(logical_result[4]),
 .R(sel_logical),
 .C(clk));

 // synthesis translate_off 
 defparam logical_lut_5.INIT = 16'h6E8A;
 // synthesis translate_on 
 LUT4 logical_lut_5 ( 
 .I0(second_operand[5]),
 .I1(sx[5]),
 .I2(instruction[13]),
 .I3(instruction[14]),
 .O(logical_value[5]))/* synthesis xc_props = "INIT=6E8A"*/;

 FDR logical_flop_5 ( 
 .D(logical_value[5]),
 .Q(logical_result[5]),
 .R(sel_logical),
 .C(clk));

 // synthesis translate_off 
 defparam logical_lut_6.INIT = 16'h6E8A;
 // synthesis translate_on 
 LUT4 logical_lut_6 ( 
 .I0(second_operand[6]),
 .I1(sx[6]),
 .I2(instruction[13]),
 .I3(instruction[14]),
 .O(logical_value[6]))/* synthesis xc_props = "INIT=6E8A"*/;

 FDR logical_flop_6 ( 
 .D(logical_value[6]),
 .Q(logical_result[6]),
 .R(sel_logical),
 .C(clk));

 // synthesis translate_off 
 defparam logical_lut_7.INIT = 16'h6E8A;
 // synthesis translate_on 
 LUT4 logical_lut_7 ( 
 .I0(second_operand[7]),
 .I1(sx[7]),
 .I2(instruction[13]),
 .I3(instruction[14]),
 .O(logical_value[7]))/* synthesis xc_props = "INIT=6E8A"*/;

 FDR logical_flop_7 ( 
 .D(logical_value[7]),
 .Q(logical_result[7]),
 .R(sel_logical),
 .C(clk));
     
//
////////////////////////////////////////////////////////////////////////////////////
//
// Shift and Rotate operations
//
// Includes pipeline stage used to form ALU multiplexer including decode.
//
////////////////////////////////////////////////////////////////////////////////////
//
 INV sel_shift_inv( // Inverter should be implemented in the reset to flip flops
 .I(instruction[17]),
 .O(sel_shift)); 

 // Bit to input to shift register

 // synthesis translate_off 
 defparam high_shift_in_lut.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 high_shift_in_lut ( 
 .I0(instruction[1]),
 .I1(sx[0]),
 .I2(instruction[0]),
 .O(high_shift_in ))/* synthesis xc_props = "INIT=E4"*/;

 // synthesis translate_off 
 defparam low_shift_in_lut.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 low_shift_in_lut ( 
 .I0(instruction[1]),
 .I1(carry_flag),
 .I2(sx[7]),
 .O(low_shift_in))/* synthesis xc_props = "INIT=E4"*/;

 MUXF5 shift_in_muxf5 ( 
 .I1(high_shift_in),
 .I0(low_shift_in),
 .S(instruction[2]),
 .O(shift_in )); 

 // Forming shift carry signal

 // synthesis translate_off 
 defparam shift_carry_lut.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 shift_carry_lut ( 
 .I0(instruction[3]),
 .I1(sx[7]),
 .I2(sx[0]),
 .O(shift_carry_value ))/* synthesis xc_props = "INIT=E4"*/;
					 
 FD pipeline_bit ( 
 .D(shift_carry_value),
 .Q(shift_carry),
 .C(clk));

// shift_loop

 // synthesis translate_off 
 defparam shift_mux_lut_0.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 shift_mux_lut_0 ( 
 .I0(instruction[3]),
 .I1(shift_in),
 .I2(sx[1]),
 .O(shift_value[0]))/* synthesis xc_props = "INIT=E4"*/;

 FDR shift_flop_0 ( 
 .D(shift_value[0]),
 .Q(shift_result[0]),
 .R(sel_shift),
 .C(clk));
 	 
 // synthesis translate_off 
 defparam shift_mux_lut_1.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 shift_mux_lut_1 ( 
 .I0(instruction[3]),
 .I1(sx[0]),
 .I2(sx[2]),
 .O(shift_value[1]))/* synthesis xc_props = "INIT=E4"*/;

 FDR shift_flop_1 ( 
 .D(shift_value[1]),
 .Q(shift_result[1]),
 .R(sel_shift),
 .C(clk));

 // synthesis translate_off 
 defparam shift_mux_lut_2.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 shift_mux_lut_2 ( 
 .I0(instruction[3]),
 .I1(sx[1]),
 .I2(sx[3]),
 .O(shift_value[2]))/* synthesis xc_props = "INIT=E4"*/;

 FDR shift_flop_2 ( 
 .D(shift_value[2]),
 .Q(shift_result[2]),
 .R(sel_shift),
 .C(clk));
 	 
 // synthesis translate_off 
 defparam shift_mux_lut_3.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 shift_mux_lut_3 ( 
 .I0(instruction[3]),
 .I1(sx[2]),
 .I2(sx[4]),
 .O(shift_value[3]))/* synthesis xc_props = "INIT=E4"*/;

 FDR shift_flop_3 ( 
 .D(shift_value[3]),
 .Q(shift_result[3]),
 .R(sel_shift),
 .C(clk));

 // synthesis translate_off 
 defparam shift_mux_lut_4.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 shift_mux_lut_4 ( 
 .I0(instruction[3]),
 .I1(sx[3]),
 .I2(sx[5]),
 .O(shift_value[4]))/* synthesis xc_props = "INIT=E4"*/;

 FDR shift_flop_4 ( 
 .D(shift_value[4]),
 .Q(shift_result[4]),
 .R(sel_shift),
 .C(clk));

 // synthesis translate_off 
 defparam shift_mux_lut_5.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 shift_mux_lut_5 ( 
 .I0(instruction[3]),
 .I1(sx[4]),
 .I2(sx[6]),
 .O(shift_value[5]))/* synthesis xc_props = "INIT=E4"*/;

 FDR shift_flop_5 ( 
 .D(shift_value[5]),
 .Q(shift_result[5]),
 .R(sel_shift),
 .C(clk));

 // synthesis translate_off 
 defparam shift_mux_lut_6.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 shift_mux_lut_6 ( 
 .I0(instruction[3]),
 .I1(sx[5]),
 .I2(sx[7]),
 .O(shift_value[6]))/* synthesis xc_props = "INIT=E4"*/;

 FDR shift_flop_6 ( 
 .D(shift_value[6]),
 .Q(shift_result[6]),
 .R(sel_shift),
 .C(clk));

 // synthesis translate_off 
 defparam shift_mux_lut_7.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 shift_mux_lut_7 ( 
 .I0(instruction[3]),
 .I1(sx[6]),
 .I2(shift_in),
 .O(shift_value[7]) )/* synthesis xc_props = "INIT=E4"*/;
	 
 FDR shift_flop_7 ( 
 .D(shift_value[7]),
 .Q(shift_result[7]),
 .R(sel_shift),
 .C(clk));

//
////////////////////////////////////////////////////////////////////////////////////
//
// Arithmetic operations
//
// Definition of ADD, ADDCY, SUB and SUBCY functions which also provides COMPARE.
// Includes pipeline stage used to form ALU multiplexer including decode.
//
////////////////////////////////////////////////////////////////////////////////////
//
 // synthesis translate_off 
 defparam sel_arith_lut.INIT = 8'h1F;
 // synthesis translate_on 
 LUT3 sel_arith_lut ( 
 .I0(instruction[14]),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .O(sel_arith))/* synthesis xc_props = "INIT=1F"*/; 
 
 //arith_loop 

 // synthesis translate_off 
 defparam arith_carry_in_lut.INIT = 8'h6C;
 // synthesis translate_on 
 LUT3 arith_carry_in_lut ( 
 .I0(instruction[13]),
 .I1(instruction[14]),
 .I2(carry_flag),
 .O(sel_arith_carry_in ))/* synthesis xc_props = "INIT=6C"*/;

 MUXCY arith_carry_in_muxcy ( 
 .DI(1'b0),
 .CI(1'b1),
 .S(sel_arith_carry_in),
 .O(arith_carry_in));

 MUXCY arith_muxcy_0 ( 
 .DI(sx[0]),
 .CI(arith_carry_in),
 .S(half_arith[0]),
 .O(arith_internal_carry[0]));
 
 XORCY arith_xor_0 ( 
 .LI(half_arith[0]),
 .CI(arith_carry_in),
 .O(arith_value[0]));

 // synthesis translate_off 
 defparam arith_lut_0.INIT = 8'h96;
 // synthesis translate_on 
 LUT3 arith_lut_0 ( 
 .I0(sx[0]),
 .I1(second_operand[0]),
 .I2(instruction[14]),
 .O(half_arith[0]))/* synthesis xc_props = "INIT=96"*/;

 FDR arith_flop_0 ( 
 .D(arith_value[0]),
 .Q(arith_result[0]),
 .R(sel_arith),
 .C(clk));
 
 MUXCY arith_muxcy_1 ( 
 .DI(sx[1]),
 .CI(arith_internal_carry[0]),
 .S(half_arith[1]),
 .O(arith_internal_carry[1]));

 XORCY arith_xor_1 ( 
 .LI(half_arith[1]),
 .CI(arith_internal_carry[0]),
 .O(arith_value[1]));

 // synthesis translate_off 
 defparam arith_lut_1.INIT = 8'h96;
 // synthesis translate_on 
 LUT3 arith_lut_1 ( 
 .I0(sx[1]),
 .I1(second_operand[1]),
 .I2(instruction[14]),
 .O(half_arith[1]))/* synthesis xc_props = "INIT=96"*/;

 FDR arith_flop_1 ( 
 .D(arith_value[1]),
 .Q(arith_result[1]),
 .R(sel_arith),
 .C(clk));
 
 MUXCY arith_muxcy_2 ( 
 .DI(sx[2]),
 .CI(arith_internal_carry[1]),
 .S(half_arith[2]),
 .O(arith_internal_carry[2]));

 XORCY arith_xor_2 ( 
 .LI(half_arith[2]),
 .CI(arith_internal_carry[1]),
 .O(arith_value[2]));

 // synthesis translate_off 
 defparam arith_lut_2.INIT = 8'h96;
 // synthesis translate_on 
 LUT3 arith_lut_2 ( 
 .I0(sx[2]),
 .I1(second_operand[2]),
 .I2(instruction[14]),
 .O(half_arith[2]))/* synthesis xc_props = "INIT=96"*/;

 FDR arith_flop_2 ( 
 .D(arith_value[2]),
 .Q(arith_result[2]),
 .R(sel_arith),
 .C(clk));
  
 MUXCY arith_muxcy_3 ( 
 .DI(sx[3]),
 .CI(arith_internal_carry[2]),
 .S(half_arith[3]),
 .O(arith_internal_carry[3]));

 XORCY arith_xor_3 ( 
 .LI(half_arith[3]),
 .CI(arith_internal_carry[2]),
 .O(arith_value[3]));

 // synthesis translate_off 
 defparam arith_lut_3.INIT = 8'h96;
 // synthesis translate_on 
 LUT3 arith_lut_3 ( 
 .I0(sx[3]),
 .I1(second_operand[3]),
 .I2(instruction[14]),
 .O(half_arith[3]))/* synthesis xc_props = "INIT=96"*/;

 FDR arith_flop_3 ( 
 .D(arith_value[3]),
 .Q(arith_result[3]),
 .R(sel_arith),
 .C(clk));
 
 MUXCY arith_muxcy_4 ( 
 .DI(sx[4]),
 .CI(arith_internal_carry[3]),
 .S(half_arith[4]),
 .O(arith_internal_carry[4]));

 XORCY arith_xor_4 ( 
 .LI(half_arith[4]),
 .CI(arith_internal_carry[3]),
 .O(arith_value[4]));

 // synthesis translate_off 
 defparam arith_lut_4.INIT = 8'h96;
 // synthesis translate_on 
 LUT3 arith_lut_4 ( 
 .I0(sx[4]),
 .I1(second_operand[4]),
 .I2(instruction[14]),
 .O(half_arith[4]))/* synthesis xc_props = "INIT=96"*/;

 FDR arith_flop_4 ( 
 .D(arith_value[4]),
 .Q(arith_result[4]),
 .R(sel_arith),
 .C(clk));
  
 MUXCY arith_muxcy_5 ( 
 .DI(sx[5]),
 .CI(arith_internal_carry[4]),
 .S(half_arith[5]),
 .O(arith_internal_carry[5]));

 XORCY arith_xor_5 ( 
 .LI(half_arith[5]),
 .CI(arith_internal_carry[4]),
 .O(arith_value[5])); 	 

 // synthesis translate_off 
 defparam arith_lut_5.INIT = 8'h96;
 // synthesis translate_on 
 LUT3 arith_lut_5 ( 
 .I0(sx[5]),
 .I1(second_operand[5]),
 .I2(instruction[14]),
 .O(half_arith[5]))/* synthesis xc_props = "INIT=96"*/;

 FDR arith_flop_5 ( 
 .D(arith_value[5]),
 .Q(arith_result[5]),
 .R(sel_arith),
 .C(clk));
 
 MUXCY arith_muxcy_6 ( 
 .DI(sx[6]),
 .CI(arith_internal_carry[5]),
 .S(half_arith[6]),
 .O(arith_internal_carry[6]));

 XORCY arith_xor_6 ( 
 .LI(half_arith[6]),
 .CI(arith_internal_carry[5]),
 .O(arith_value[6]));

 // synthesis translate_off 
 defparam arith_lut_6.INIT = 8'h96;
 // synthesis translate_on 
 LUT3 arith_lut_6 ( 
 .I0(sx[6]),
 .I1(second_operand[6]),
 .I2(instruction[14]),
 .O(half_arith[6]))/* synthesis xc_props = "INIT=96"*/;

 FDR arith_flop_6 ( 
 .D(arith_value[6]),
 .Q(arith_result[6]),
 .R(sel_arith),
 .C(clk));
 
 MUXCY arith_muxcy_7 ( 
 .DI(sx[7]),
 .CI(arith_internal_carry[6]),
 .S(half_arith[7]),
 .O(arith_internal_carry[7]));

 XORCY arith_xor_7 ( 
 .LI(half_arith[7]),
 .CI(arith_internal_carry[6]),
 .O(arith_value[7]));

 // synthesis translate_off 
 defparam arith_carry_out_lut.INIT = 2'h2;
 // synthesis translate_on 
 LUT1 arith_carry_out_lut ( 
 .I0(instruction[14]),
 .O(invert_arith_carry ))/* synthesis xc_props = "INIT=2"*/;
 
  XORCY arith_carry_out_xor ( 
 .LI(invert_arith_carry),
 .CI(arith_internal_carry[7]),
 .O(arith_carry_out));

 // synthesis translate_off 
 defparam arith_lut_7.INIT = 8'h96;
 // synthesis translate_on 
 LUT3 arith_lut_7 ( 
 .I0(sx[7]),
 .I1(second_operand[7]),
 .I2(instruction[14]),
 .O(half_arith[7]))/* synthesis xc_props = "INIT=96"*/;

 FDR arith_flop_7 ( 
 .D(arith_value[7]),
 .Q(arith_result[7]),
 .R(sel_arith),
 .C(clk));
 
 FDR arith_carry_flop ( 
 .D(arith_carry_out),
 .Q(arith_carry),
 .R(sel_arith),
 .C(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// ALU multiplexer
//
////////////////////////////////////////////////////////////////////////////////////
//
 // synthesis translate_off 
 defparam input_fetch_type_lut.INIT = 16'h0002;
 // synthesis translate_on 
 LUT4 input_fetch_type_lut ( 
 .I0(instruction[14]),
 .I1(instruction[15]),
 .I2(instruction[16]),
 .I3(instruction[17]),
 .O(input_fetch_type ))/* synthesis xc_props = "INIT=0002"*/;

 FD sel_group_flop ( 
 .D(input_fetch_type),
 .Q(sel_group),
 .C(clk));
 
 //alu_mux_loop 

 // synthesis translate_off 
 defparam or_lut_0.INIT = 8'hFE;
 // synthesis translate_on 
 LUT3 or_lut_0 ( 
 .I0(logical_result[0]),
 .I1(arith_result[0]),
 .I2(shift_result[0]),
 .O(alu_group[0]))/* synthesis xc_props = "INIT=FE"*/;

 // synthesis translate_off 
 defparam mux_lut_0.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 mux_lut_0 ( 
 .I0(instruction[13]),
 .I1(in_port[0]),
 .I2(store_data[0]),
 .O(input_group[0]))/* synthesis xc_props = "INIT=E4"*/;

 MUXF5 shift_in_muxf5_0 ( 
 .I1(input_group[0]),
 .I0(alu_group[0]),
 .S(sel_group),
 .O(alu_result[0]) ); 

 // synthesis translate_off 
 defparam or_lut_1.INIT = 8'hFE;
 // synthesis translate_on 
 LUT3 or_lut_1 ( 
 .I0(logical_result[1]),
 .I1(arith_result[1]),
 .I2(shift_result[1]),
 .O(alu_group[1]))/* synthesis xc_props = "INIT=FE"*/;

 // synthesis translate_off 
 defparam mux_lut_1.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 mux_lut_1 ( 
 .I0(instruction[13]),
 .I1(in_port[1]),
 .I2(store_data[1]),
 .O(input_group[1]))/* synthesis xc_props = "INIT=E4"*/;

 MUXF5 shift_in_muxf5_1 ( 
 .I1(input_group[1]),
 .I0(alu_group[1]),
 .S(sel_group),
 .O(alu_result[1]) ); 

 // synthesis translate_off 
 defparam or_lut_2.INIT = 8'hFE;
 // synthesis translate_on 
 LUT3 or_lut_2 ( 
 .I0(logical_result[2]),
 .I1(arith_result[2]),
 .I2(shift_result[2]),
 .O(alu_group[2]))/* synthesis xc_props = "INIT=FE"*/;

 // synthesis translate_off 
 defparam mux_lut_2.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 mux_lut_2 ( 
 .I0(instruction[13]),
 .I1(in_port[2]),
 .I2(store_data[2]),
 .O(input_group[2]))/* synthesis xc_props = "INIT=E4"*/;

 MUXF5 shift_in_muxf5_2 ( 
 .I1(input_group[2]),
 .I0(alu_group[2]),
 .S(sel_group),
 .O(alu_result[2]) ); 

 // synthesis translate_off 
 defparam or_lut_3.INIT = 8'hFE;
 // synthesis translate_on 
 LUT3 or_lut_3 ( 
 .I0(logical_result[3]),
 .I1(arith_result[3]),
 .I2(shift_result[3]),
 .O(alu_group[3]))/* synthesis xc_props = "INIT=FE"*/;

 // synthesis translate_off 
 defparam mux_lut_3.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 mux_lut_3 ( 
 .I0(instruction[13]),
 .I1(in_port[3]),
 .I2(store_data[3]),
 .O(input_group[3]))/* synthesis xc_props = "INIT=E4"*/;

 MUXF5 shift_in_muxf5_3 ( 
 .I1(input_group[3]),
 .I0(alu_group[3]),
 .S(sel_group),
 .O(alu_result[3]) ); 
  
 // synthesis translate_off 
 defparam or_lut_4.INIT = 8'hFE;
 // synthesis translate_on 
 LUT3 or_lut_4 ( 
 .I0(logical_result[4]),
 .I1(arith_result[4]),
 .I2(shift_result[4]),
 .O(alu_group[4]))/* synthesis xc_props = "INIT=FE"*/;

 // synthesis translate_off 
 defparam mux_lut_4.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 mux_lut_4 ( 
 .I0(instruction[13]),
 .I1(in_port[4]),
 .I2(store_data[4]),
 .O(input_group[4]))/* synthesis xc_props = "INIT=E4"*/;

 MUXF5 shift_in_muxf5_4 ( 
 .I1(input_group[4]),
 .I0(alu_group[4]),
 .S(sel_group),
 .O(alu_result[4]) ); 
 
  // synthesis translate_off 
 defparam or_lut_5.INIT = 8'hFE;
 // synthesis translate_on 
 LUT3 or_lut_5 ( 
 .I0(logical_result[5]),
 .I1(arith_result[5]),
 .I2(shift_result[5]),
 .O(alu_group[5]))/* synthesis xc_props = "INIT=FE"*/;

 // synthesis translate_off 
 defparam mux_lut_5.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 mux_lut_5 ( 
 .I0(instruction[13]),
 .I1(in_port[5]),
 .I2(store_data[5]),
 .O(input_group[5]))/* synthesis xc_props = "INIT=E4"*/;

 MUXF5 shift_in_muxf5_5 ( 
 .I1(input_group[5]),
 .I0(alu_group[5]),
 .S(sel_group),
 .O(alu_result[5]) ); 

 // synthesis translate_off 
 defparam or_lut_6.INIT = 8'hFE;
 // synthesis translate_on 
 LUT3 or_lut_6 ( 
 .I0(logical_result[6]),
 .I1(arith_result[6]),
 .I2(shift_result[6]),
 .O(alu_group[6]))/* synthesis xc_props = "INIT=FE"*/;

 // synthesis translate_off 
 defparam mux_lut_6.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 mux_lut_6 ( 
 .I0(instruction[13]),
 .I1(in_port[6]),
 .I2(store_data[6]),
 .O(input_group[6]))/* synthesis xc_props = "INIT=E4"*/;

 MUXF5 shift_in_muxf5_6 ( 
 .I1(input_group[6]),
 .I0(alu_group[6]),
 .S(sel_group),
 .O(alu_result[6]) ); 
  
 // synthesis translate_off 
 defparam or_lut_7.INIT = 8'hFE;
 // synthesis translate_on 
 LUT3 or_lut_7 ( 
 .I0(logical_result[7]),
 .I1(arith_result[7]),
 .I2(shift_result[7]),
 .O(alu_group[7]))/* synthesis xc_props = "INIT=FE"*/;

 // synthesis translate_off 
 defparam mux_lut_7.INIT = 8'hE4;
 // synthesis translate_on 
 LUT3 mux_lut_7 ( 
 .I0(instruction[13]),
 .I1(in_port[7]),
 .I2(store_data[7]),
 .O(input_group[7]))/* synthesis xc_props = "INIT=E4"*/;

 MUXF5 shift_in_muxf5_7 ( 
 .I1(input_group[7]),
 .I0(alu_group[7]),
 .S(sel_group),
 .O(alu_result[7]) );   
 //
////////////////////////////////////////////////////////////////////////////////////
//
// Read and Write Strobes
//
////////////////////////////////////////////////////////////////////////////////////
//
 // synthesis translate_off 
 defparam io_decode_lut.INIT = 16'h0010;
 // synthesis translate_on 
 LUT4 io_decode_lut ( 
 .I0(active_interrupt),
 .I1(instruction[13]),
 .I2(instruction[14]),
 .I3(instruction[16]),
 .O(io_initial_decode ))/* synthesis xc_props = "INIT=0010"*/;

 // synthesis translate_off 
 defparam write_active_lut.INIT = 16'h4000;
 // synthesis translate_on 
 LUT4 write_active_lut ( 
 .I0(t_state),
 .I1(instruction[15]),
 .I2(instruction[17]),
 .I3(io_initial_decode),
 .O(write_active ))/* synthesis xc_props = "INIT=4000"*/;

 FDR write_strobe_flop ( 
 .D(write_active),
 .Q(write_strobe),
 .R(internal_reset),
 .C(clk));

 // synthesis translate_off 
 defparam read_active_lut.INIT = 16'h0100;
 // synthesis translate_on 
 LUT4 read_active_lut ( 
 .I0(t_state),
 .I1(instruction[15]),
 .I2(instruction[17]),
 .I3(io_initial_decode),
 .O(read_active ))/* synthesis xc_props = "INIT=0100"*/;

 FDR read_strobe_flop ( 
 .D(read_active),
 .Q(read_strobe),
 .R(internal_reset),
 .C(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// Program CALL/RETURN stack
//
// Provided the counter and memory for a 32 deep stack supporting nested 
// subroutine calls to a depth of 31 levels.
//
////////////////////////////////////////////////////////////////////////////////////
//
 // Stack memory is 32 locations of 10-bit single port.
 
 INV stack_ram_inv ( // Inverter should be implemented in the WE to RAM
 .I(t_state),
 .O(stack_write_enable)); 
 
 //stack_ram_loop 
 
 // synthesis translate_off 
 defparam stack_bit_0.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_0 ( 
 .D(pc[0]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[0]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_0 ( 
 .D(stack_ram_data[0]),
 .Q(stack_pop_data[0]),
 .C(clk));

 // synthesis translate_off 
 defparam stack_bit_1.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_1 ( 
 .D(pc[1]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[1]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_1 ( 
 .D(stack_ram_data[1]),
 .Q(stack_pop_data[1]),
 .C(clk));

 // synthesis translate_off 
 defparam stack_bit_2.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_2 ( 
 .D(pc[2]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[2]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_2 ( 
 .D(stack_ram_data[2]),
 .Q(stack_pop_data[2]),
 .C(clk));
 
  // synthesis translate_off 
 defparam stack_bit_3.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_3 ( 
 .D(pc[3]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[3]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_3 ( 
 .D(stack_ram_data[3]),
 .Q(stack_pop_data[3]),
 .C(clk));
 
 // synthesis translate_off 
 defparam stack_bit_4.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_4 ( 
 .D(pc[4]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[4]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_4 ( 
 .D(stack_ram_data[4]),
 .Q(stack_pop_data[4]),
 .C(clk));

 // synthesis translate_off 
 defparam stack_bit_5.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_5 ( 
 .D(pc[5]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[5]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_5 ( 
 .D(stack_ram_data[5]),
 .Q(stack_pop_data[5]),
 .C(clk));

 // synthesis translate_off 
 defparam stack_bit_6.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_6 ( 
 .D(pc[6]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[6]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_6 ( 
 .D(stack_ram_data[6]),
 .Q(stack_pop_data[6]),
 .C(clk));

 // synthesis translate_off 
 defparam stack_bit_7.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_7 ( 
 .D(pc[7]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[7]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_7 ( 
 .D(stack_ram_data[7]),
 .Q(stack_pop_data[7]),
 .C(clk));

 // synthesis translate_off 
 defparam stack_bit_8.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_8 ( 
 .D(pc[8]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[8]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_8 ( 
 .D(stack_ram_data[8]),
 .Q(stack_pop_data[8]),
 .C(clk));

 // synthesis translate_off 
 defparam stack_bit_9.INIT = 32'h00000000;
 // synthesis translate_on 
 RAM32X1S stack_bit_9 ( 
 .D(pc[9]),
 .WE(stack_write_enable),
 .WCLK(clk),
 .A0(stack_address[0]),
 .A1(stack_address[1]),
 .A2(stack_address[2]),
 .A3(stack_address[3]),
 .A4(stack_address[4]),
 .O(stack_ram_data[9]))/* synthesis xc_props = "INIT=00000000"*/;

 FD stack_flop_9 ( 
 .D(stack_ram_data[9]),
 .Q(stack_pop_data[9]),
 .C(clk));
       
 // Stack address pointer is a 5-bit counter

 INV stack_count_inv( // Inverter should be implemented in the CE to the flip-flops
 .I(active_interrupt),
 .O(not_active_interrupt)); 

 //stack_count_loop 

 // synthesis translate_off 
 defparam count_lut_0.INIT = 16'h6555;
 // synthesis translate_on 
 LUT4 count_lut_0 ( 
 .I0(stack_address[0]),
 .I1(t_state),
 .I2(valid_to_move),
 .I3(push_or_pop_type),
 .O(half_stack_address[0]) )/* synthesis xc_props = "INIT=6555"*/;
 
 MUXCY count_muxcy_0 ( 
 .DI(stack_address[0]),
 .CI(1'b0),
 .S(half_stack_address[0]),
 .O(stack_address_carry[0]));
 
 XORCY count_xor_0 ( 
 .LI(half_stack_address[0]),
 .CI(1'b0),
 .O(next_stack_address[0]));

 FDRE stack_count_loop_register_bit_0 ( 
 .D(next_stack_address[0]),
 .Q(stack_address[0]),
 .R(internal_reset),
 .CE(not_active_interrupt),
 .C(clk)); 				 					 

 // synthesis translate_off 
 defparam count_lut_1.INIT = 16'hA999;
 // synthesis translate_on 
 LUT4 count_lut_1 ( 
 .I0(stack_address[1]),
 .I1(t_state),
 .I2(valid_to_move),
 .I3(call_type),
 .O(half_stack_address[1]) )/* synthesis xc_props = "INIT=A999"*/;
 
 MUXCY count_muxcy_1 ( 
 .DI(stack_address[1]),
 .CI(stack_address_carry[0]),
 .S(half_stack_address[1]),
 .O(stack_address_carry[1]));
 
 XORCY count_xor_1 ( 
 .LI(half_stack_address[1]),
 .CI(stack_address_carry[0]),
 .O(next_stack_address[1]));
 				 					 
 FDRE stack_count_loop_register_bit_1 ( 
 .D(next_stack_address[1]),
 .Q(stack_address[1]),
 .R(internal_reset),
 .CE(not_active_interrupt),
 .C(clk)); 	

 // synthesis translate_off 
 defparam count_lut_2.INIT = 16'hA999;
 // synthesis translate_on 
 LUT4 count_lut_2 ( 
 .I0(stack_address[2]),
 .I1(t_state),
 .I2(valid_to_move),
 .I3(call_type),
 .O(half_stack_address[2]) )/* synthesis xc_props = "INIT=A999"*/;
 
 MUXCY count_muxcy_2 ( 
 .DI(stack_address[2]),
 .CI(stack_address_carry[1]),
 .S(half_stack_address[2]),
 .O(stack_address_carry[2]));
 
 XORCY count_xor_2 ( 
 .LI(half_stack_address[2]),
 .CI(stack_address_carry[1]),
 .O(next_stack_address[2]));
 				 					 
 FDRE stack_count_loop_register_bit_2 ( 
 .D(next_stack_address[2]),
 .Q(stack_address[2]),
 .R(internal_reset),
 .CE(not_active_interrupt),
 .C(clk)); 

 // synthesis translate_off 
 defparam count_lut_3.INIT = 16'hA999;
 // synthesis translate_on 
 LUT4 count_lut_3 ( 
 .I0(stack_address[3]),
 .I1(t_state),
 .I2(valid_to_move),
 .I3(call_type),
 .O(half_stack_address[3]) )/* synthesis xc_props = "INIT=A999"*/;
 
 MUXCY count_muxcy_3 ( 
 .DI(stack_address[3]),
 .CI(stack_address_carry[2]),
 .S(half_stack_address[3]),
 .O(stack_address_carry[3]));
 
 XORCY count_xor_3 ( 
 .LI(half_stack_address[3]),
 .CI(stack_address_carry[2]),
 .O(next_stack_address[3]));
 				 					 
 FDRE stack_count_loop_register_bit_3 ( 
 .D(next_stack_address[3]),
 .Q(stack_address[3]),
 .R(internal_reset),
 .CE(not_active_interrupt),
 .C(clk)); 

 // synthesis translate_off 
 defparam count_lut_4.INIT = 16'hA999;
 // synthesis translate_on 
 LUT4 count_lut_4 ( 
 .I0(stack_address[4]),
 .I1(t_state),
 .I2(valid_to_move),
 .I3(call_type),
 .O(half_stack_address[4]) )/* synthesis xc_props = "INIT=A999"*/;
 
 XORCY count_xor_4 ( 
 .LI(half_stack_address[4]),
 .CI(stack_address_carry[3]),
 .O(next_stack_address[4]));

 FDRE stack_count_loop_register_bit_4 ( 
 .D(next_stack_address[4]),
 .Q(stack_address[4]),
 .R(internal_reset),
 .CE(not_active_interrupt),
 .C(clk));
//
////////////////////////////////////////////////////////////////////////////////////
//
// End of description for KCPSM3 macro.
//
////////////////////////////////////////////////////////////////////////////////////
//
//**********************************************************************************
// Code for simulation purposes only after this line
//**********************************************************************************
//
////////////////////////////////////////////////////////////////////////////////////
//
// Code for simulation.
//
// Disassemble the instruction codes to form a text string for display.
// Determine status of reset and flags and present in the form of a text string.
// Provide local variables to simulate the contents of each register and scratch 
// pad memory location.
//
////////////////////////////////////////////////////////////////////////////////////
//
 //All of this section is ignored during synthesis.
 //synthesis translate_off
 //
 //complete instruction decode
 //
 reg 	[1:152] kcpsm3_opcode ;
 //
 //Status of flags and processor
 //
 reg 	[1:104] kcpsm3_status ;
 //
 //contents of each register
 //
 reg 	[7:0]	s0_contents ;
 reg 	[7:0]	s1_contents ;
 reg  	[7:0]	s2_contents ;
 reg  	[7:0]	s3_contents ;
 reg  	[7:0]	s4_contents ;
 reg  	[7:0]	s5_contents ;
 reg  	[7:0]	s6_contents ;
 reg  	[7:0]	s7_contents ;
 reg  	[7:0]	s8_contents ;
 reg  	[7:0]	s9_contents ;
 reg  	[7:0]	sa_contents ;
 reg  	[7:0]	sb_contents ;
 reg  	[7:0]	sc_contents ;
 reg  	[7:0]	sd_contents ;
 reg  	[7:0]	se_contents ;
 reg  	[7:0]	sf_contents ;
 //
 //contents of each scratch pad memory location
 // 
 reg 	[7:0] 	spm00_contents ;
 reg 	[7:0] 	spm01_contents ;
 reg 	[7:0] 	spm02_contents ;
 reg 	[7:0] 	spm03_contents ;
 reg 	[7:0] 	spm04_contents ;
 reg 	[7:0] 	spm05_contents ;
 reg 	[7:0] 	spm06_contents ;
 reg 	[7:0] 	spm07_contents ;
 reg 	[7:0] 	spm08_contents ;
 reg 	[7:0] 	spm09_contents ;
 reg 	[7:0] 	spm0a_contents ;
 reg 	[7:0] 	spm0b_contents ;
 reg 	[7:0] 	spm0c_contents ;
 reg 	[7:0] 	spm0d_contents ;
 reg 	[7:0] 	spm0e_contents ;
 reg 	[7:0] 	spm0f_contents ;
 reg 	[7:0] 	spm10_contents ;
 reg 	[7:0] 	spm11_contents ;
 reg 	[7:0] 	spm12_contents ;
 reg 	[7:0] 	spm13_contents ;
 reg 	[7:0] 	spm14_contents ;
 reg 	[7:0] 	spm15_contents ;
 reg 	[7:0] 	spm16_contents ;
 reg 	[7:0] 	spm17_contents ;
 reg 	[7:0] 	spm18_contents ;
 reg 	[7:0] 	spm19_contents ;
 reg 	[7:0] 	spm1a_contents ;
 reg 	[7:0] 	spm1b_contents ;
 reg 	[7:0] 	spm1c_contents ;
 reg 	[7:0] 	spm1d_contents ;
 reg 	[7:0] 	spm1e_contents ;
 reg 	[7:0] 	spm1f_contents ;
 reg 	[7:0] 	spm20_contents ;
 reg 	[7:0] 	spm21_contents ;
 reg 	[7:0] 	spm22_contents ;
 reg 	[7:0] 	spm23_contents ;
 reg 	[7:0] 	spm24_contents ;
 reg 	[7:0] 	spm25_contents ;
 reg 	[7:0] 	spm26_contents ;
 reg 	[7:0] 	spm27_contents ;
 reg 	[7:0] 	spm28_contents ;
 reg 	[7:0] 	spm29_contents ;
 reg 	[7:0] 	spm2a_contents ;
 reg 	[7:0] 	spm2b_contents ;
 reg 	[7:0] 	spm2c_contents ;
 reg 	[7:0] 	spm2d_contents ;
 reg 	[7:0] 	spm2e_contents ;
 reg 	[7:0] 	spm2f_contents ;
 reg 	[7:0] 	spm30_contents ;
 reg 	[7:0] 	spm31_contents ;
 reg 	[7:0] 	spm32_contents ;
 reg 	[7:0] 	spm33_contents ;
 reg 	[7:0] 	spm34_contents ;
 reg 	[7:0] 	spm35_contents ;
 reg 	[7:0] 	spm36_contents ;
 reg 	[7:0] 	spm37_contents ;
 reg 	[7:0] 	spm38_contents ;
 reg 	[7:0] 	spm39_contents ;
 reg 	[7:0] 	spm3a_contents ;
 reg 	[7:0] 	spm3b_contents ;
 reg 	[7:0] 	spm3c_contents ;
 reg 	[7:0] 	spm3d_contents ;
 reg 	[7:0] 	spm3e_contents ;
 reg 	[7:0] 	spm3f_contents ;
  
 // initialise the values 
 initial begin
 kcpsm3_status = "NZ, NC, Reset";

 s0_contents = 8'h00 ;
 s1_contents = 8'h00 ;
 s2_contents = 8'h00 ;
 s3_contents = 8'h00 ;
 s4_contents = 8'h00 ;
 s5_contents = 8'h00 ;
 s6_contents = 8'h00 ;
 s7_contents = 8'h00 ;
 s8_contents = 8'h00 ;
 s9_contents = 8'h00 ;
 sa_contents = 8'h00 ;
 sb_contents = 8'h00 ;
 sc_contents = 8'h00 ;
 sd_contents = 8'h00 ;
 se_contents = 8'h00 ;
 sf_contents = 8'h00 ;

 spm00_contents = 8'h00 ;
 spm01_contents = 8'h00 ;
 spm02_contents = 8'h00 ;
 spm03_contents = 8'h00 ;
 spm04_contents = 8'h00 ;
 spm05_contents = 8'h00 ;
 spm06_contents = 8'h00 ;
 spm07_contents = 8'h00 ;
 spm08_contents = 8'h00 ;
 spm09_contents = 8'h00 ;
 spm0a_contents = 8'h00 ;
 spm0b_contents = 8'h00 ;
 spm0c_contents = 8'h00 ;
 spm0d_contents = 8'h00 ;
 spm0e_contents = 8'h00 ;
 spm0f_contents = 8'h00 ;
 spm10_contents = 8'h00 ;
 spm11_contents = 8'h00 ;
 spm12_contents = 8'h00 ;
 spm13_contents = 8'h00 ;
 spm14_contents = 8'h00 ;
 spm15_contents = 8'h00 ;
 spm16_contents = 8'h00 ;
 spm17_contents = 8'h00 ;
 spm18_contents = 8'h00 ;
 spm19_contents = 8'h00 ;
 spm1a_contents = 8'h00 ;
 spm1b_contents = 8'h00 ;
 spm1c_contents = 8'h00 ;
 spm1d_contents = 8'h00 ;
 spm1e_contents = 8'h00 ;
 spm1f_contents = 8'h00 ;
 spm20_contents = 8'h00 ;
 spm21_contents = 8'h00 ;
 spm22_contents = 8'h00 ;
 spm23_contents = 8'h00 ;
 spm24_contents = 8'h00 ;
 spm25_contents = 8'h00 ;
 spm26_contents = 8'h00 ;
 spm27_contents = 8'h00 ;
 spm28_contents = 8'h00 ;
 spm29_contents = 8'h00 ;
 spm2a_contents = 8'h00 ;
 spm2b_contents = 8'h00 ;
 spm2c_contents = 8'h00 ;
 spm2d_contents = 8'h00 ;
 spm2e_contents = 8'h00 ;
 spm2f_contents = 8'h00 ;
 spm30_contents = 8'h00 ;
 spm31_contents = 8'h00 ;
 spm32_contents = 8'h00 ;
 spm33_contents = 8'h00 ;
 spm34_contents = 8'h00 ;
 spm35_contents = 8'h00 ;
 spm36_contents = 8'h00 ;
 spm37_contents = 8'h00 ;
 spm38_contents = 8'h00 ;
 spm39_contents = 8'h00 ;
 spm3a_contents = 8'h00 ;
 spm3b_contents = 8'h00 ;
 spm3c_contents = 8'h00 ;
 spm3d_contents = 8'h00 ;
 spm3e_contents = 8'h00 ;
 spm3f_contents = 8'h00 ;
 end
 //
 //
 wire	[1:16] 	sx_decode ; //sX register specification
 wire 	[1:16]  sy_decode ; //sY register specification
 wire 	[1:16]	kk_decode ; //constant value specification
 wire 	[1:24]	aaa_decode ; //address specification
 //
 ////////////////////////////////////////////////////////////////////////////////
 //
 // Function to convert 4-bit binary nibble to hexadecimal character
 //
 ////////////////////////////////////////////////////////////////////////////////
 //
 function [1:8] hexcharacter ;
 input 	[3:0] nibble ;
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
  /*
 //
 ////////////////////////////////////////////////////////////////////////////////
 //
 begin
 */
 // decode first register
 assign sx_decode[1:8] = "s" ;
 assign sx_decode[9:16] = hexcharacter(instruction[11:8]) ; 

 // decode second register
 assign sy_decode[1:8] = "s";
 assign sy_decode[9:16] = hexcharacter(instruction[7:4]); 

 // decode constant value
 assign kk_decode[1:8] = hexcharacter(instruction[7:4]);
 assign kk_decode[9:16] = hexcharacter(instruction[3:0]);

 // address value
 assign aaa_decode[1:8] = hexcharacter({2'b00, instruction[9:8]});
 assign aaa_decode[9:16] = hexcharacter(instruction[7:4]);
 assign aaa_decode[17:24] = hexcharacter(instruction[3:0]);

 // decode instruction
 always @ (instruction or kk_decode or sy_decode or sx_decode or aaa_decode) 
 begin
 case (instruction[17:12]) 
 6'b000000 : begin kcpsm3_opcode <= {"LOAD ", sx_decode, ",", kk_decode, " "} ; end 
 6'b000001 : begin kcpsm3_opcode <= {"LOAD ", sx_decode, ",", sy_decode, " "} ; end
 6'b001010 : begin kcpsm3_opcode <= {"AND  ", sx_decode, ",", kk_decode, " "} ; end 
 6'b001011 : begin kcpsm3_opcode <= {"AND  ", sx_decode, ",", sy_decode, " "} ; end 
 6'b001100 : begin kcpsm3_opcode <= {"OR   ", sx_decode, ",", kk_decode, " "} ; end 
 6'b001101 : begin kcpsm3_opcode <= {"OR   ", sx_decode, ",", sy_decode, " "} ; end 
 6'b001110 : begin kcpsm3_opcode <= {"XOR  ", sx_decode, ",", kk_decode, " "} ; end 
 6'b001111 : begin kcpsm3_opcode <= {"XOR  ", sx_decode, ",", sy_decode, " "} ; end 
 6'b010010 : begin kcpsm3_opcode <= {"TEST ", sx_decode, ",", kk_decode, " "} ; end 
 6'b010011 : begin kcpsm3_opcode <= {"TEST ", sx_decode, ",", sy_decode, " "} ; end 
 6'b011000 : begin kcpsm3_opcode <= {"ADD  ", sx_decode, ",", kk_decode, " "} ; end 
 6'b011001 : begin kcpsm3_opcode <= {"ADD  ", sx_decode, ",", sy_decode, " "} ; end 
 6'b011010 : begin kcpsm3_opcode <= {"ADDCY", sx_decode, ",", kk_decode, " "} ; end 
 6'b011011 : begin kcpsm3_opcode <= {"ADDCY", sx_decode, ",", sy_decode, " "} ; end 
 6'b011100 : begin kcpsm3_opcode <= {"SUB  ", sx_decode, ",", kk_decode, " "} ; end 
 6'b011101 : begin kcpsm3_opcode <= {"SUB  ", sx_decode, ",", sy_decode, " "} ; end 
 6'b011110 : begin kcpsm3_opcode <= {"SUBCY", sx_decode, ",", kk_decode, " "} ; end 
 6'b011111 : begin kcpsm3_opcode <= {"SUBCY", sx_decode, ",", sy_decode, " "} ; end 
 6'b010100 : begin kcpsm3_opcode <= {"COMPARE ", sx_decode, ",", kk_decode, " "} ; end 
 6'b010101 : begin kcpsm3_opcode <= {"COMPARE ", sx_decode, ",", sy_decode, " "} ; end  
 6'b100000 : begin
   case (instruction[3:0])
     4'b0110 : begin kcpsm3_opcode <= {"SL0 ", sx_decode, " "}; end
     4'b0111 : begin kcpsm3_opcode <= {"SL1 ", sx_decode, " "}; end
     4'b0100 : begin kcpsm3_opcode <= {"SLX ", sx_decode, " "}; end
     4'b0000 : begin kcpsm3_opcode <= {"SLA ", sx_decode, " "}; end
     4'b0010 : begin kcpsm3_opcode <= {"RL ", sx_decode, " "}; end
     4'b1110 : begin kcpsm3_opcode <= {"SR0 ", sx_decode, " "}; end
     4'b1111 : begin kcpsm3_opcode <= {"SR1 ", sx_decode, " "}; end
     4'b1010 : begin kcpsm3_opcode <= {"SRX ", sx_decode, " "}; end
     4'b1000 : begin kcpsm3_opcode <= {"SRA ", sx_decode, " "}; end
     4'b1100 : begin kcpsm3_opcode <= {"RR ", sx_decode, " "}; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 6'b101100 : begin kcpsm3_opcode <= {"OUTPUT ", sx_decode, ",", kk_decode, " "}; end
 6'b101101 : begin kcpsm3_opcode <= {"OUTPUT ", sx_decode, ",(", sy_decode, ") "}; end
 6'b000100 : begin kcpsm3_opcode <= {"INPUT ", sx_decode, ",", kk_decode, " "}; end
 6'b000101 : begin kcpsm3_opcode <= {"INPUT ", sx_decode, ",(", sy_decode, ") "}; end
 6'b101110 : begin kcpsm3_opcode <= {"STORE ", sx_decode, ",", kk_decode, " "}; end
 6'b101111 : begin kcpsm3_opcode <= {"STORE ", sx_decode, ",(", sy_decode, ") "}; end
 6'b000110 : begin kcpsm3_opcode <= {"FETCH ", sx_decode, ",", kk_decode, " "}; end
 6'b000111 : begin kcpsm3_opcode <= {"FETCH ", sx_decode, ",(", sy_decode, ") "}; end
 6'b110100 : begin kcpsm3_opcode <= {"JUMP ", aaa_decode, " "}; end
 6'b110101 : begin
   case (instruction[11:10])
     2'b00   : begin kcpsm3_opcode <= {"JUMP Z,", aaa_decode, " "}; end
     2'b01   : begin kcpsm3_opcode <= {"JUMP NZ,", aaa_decode, " "}; end
     2'b10   : begin kcpsm3_opcode <= {"JUMP C,", aaa_decode, " "}; end
     2'b11   : begin kcpsm3_opcode <= {"JUMP NC,", aaa_decode, " "}; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 6'b110000 : begin kcpsm3_opcode <= {"CALL ", aaa_decode, " "}; end
 6'b110001 : begin
   case (instruction[11:10])
     2'b00   : begin kcpsm3_opcode <= {"CALL Z,", aaa_decode, " "}; end
     2'b01   : begin kcpsm3_opcode <= {"CALL NZ,", aaa_decode, " "}; end
     2'b10   : begin kcpsm3_opcode <= {"CALL C,", aaa_decode, " "}; end
     2'b11   : begin kcpsm3_opcode <= {"CALL NC,", aaa_decode, " "}; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 6'b101010 : begin kcpsm3_opcode <= "RETURN "; end
 6'b101011 : begin
 case (instruction[11:10])
     2'b00   : begin kcpsm3_opcode <= "RETURN Z "; end
     2'b01   : begin kcpsm3_opcode <= "RETURN NZ "; end
     2'b10   : begin kcpsm3_opcode <= "RETURN C "; end
     2'b11   : begin kcpsm3_opcode <= "RETURN NC "; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end  
 6'b111000 : begin
   case (instruction[0])
     1'b0    : begin kcpsm3_opcode <= "RETURNI DISABLE "; end
     1'b1    : begin kcpsm3_opcode <= "RETURNI ENABLE "; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 6'b111100 : begin
   case (instruction[0])
     1'b0    : begin kcpsm3_opcode <= "DISABLE INTERRUPT "; end
     1'b1    : begin kcpsm3_opcode <= "ENABLE INTERRUPT "; end
     default : begin kcpsm3_opcode <= "Invalid Instruction"; end
   endcase
 end
 default : begin kcpsm3_opcode <= "Invalid Instruction"; end
 endcase
 end
 
 //reset and flag status information
 always @ (posedge clk) begin
   if (reset==1'b1 || reset_delay==1'b1) begin
     kcpsm3_status = "NZ, NC, Reset";
   end 
   else begin
     kcpsm3_status[65:104] <= "       ";
     if (flag_enable == 1'b1) begin
       if (zero_carry == 1'b1) begin
         kcpsm3_status[1:32] <= " Z, ";
       end
       else begin
         kcpsm3_status[1:32] <= "NZ, ";
       end
       if (sel_carry[3] == 1'b1) begin
         kcpsm3_status[33:48] <= " C";
       end
       else begin
         kcpsm3_status[33:48] <= "NC";
       end
     end
   end
 end
 //simulation of register contents
 always @ (posedge clk) begin
   if (register_enable == 1'b1) begin
     case (instruction[11:8])
       4'b0000 : begin s0_contents <= alu_result; end
       4'b0001 : begin s1_contents <= alu_result; end
       4'b0010 : begin s2_contents <= alu_result; end
       4'b0011 : begin s3_contents <= alu_result; end
       4'b0100 : begin s4_contents <= alu_result; end
       4'b0101 : begin s5_contents <= alu_result; end
       4'b0110 : begin s6_contents <= alu_result; end
       4'b0111 : begin s7_contents <= alu_result; end
       4'b1000 : begin s8_contents <= alu_result; end
       4'b1001 : begin s9_contents <= alu_result; end
       4'b1010 : begin sa_contents <= alu_result; end
       4'b1011 : begin sb_contents <= alu_result; end
       4'b1100 : begin sc_contents <= alu_result; end
       4'b1101 : begin sd_contents <= alu_result; end
       4'b1110 : begin se_contents <= alu_result; end
       default : begin sf_contents <= alu_result; end
     endcase
   end
 end
 //simulation of scratch pad memory contents
 always @ (posedge clk) begin
   if (memory_enable==1'b1) begin
     case (second_operand[5:0])
       6'b000000 : begin spm00_contents <= sx ; end
       6'b000001 : begin spm01_contents <= sx ; end
       6'b000010 : begin spm02_contents <= sx ; end
       6'b000011 : begin spm03_contents <= sx ; end
       6'b000100 : begin spm04_contents <= sx ; end
       6'b000101 : begin spm05_contents <= sx ; end
       6'b000110 : begin spm06_contents <= sx ; end
       6'b000111 : begin spm07_contents <= sx ; end
       6'b001000 : begin spm08_contents <= sx ; end
       6'b001001 : begin spm09_contents <= sx ; end
       6'b001010 : begin spm0a_contents <= sx ; end
       6'b001011 : begin spm0b_contents <= sx ; end
       6'b001100 : begin spm0c_contents <= sx ; end
       6'b001101 : begin spm0d_contents <= sx ; end
       6'b001110 : begin spm0e_contents <= sx ; end
       6'b001111 : begin spm0f_contents <= sx ; end
       6'b010000 : begin spm10_contents <= sx ; end
       6'b010001 : begin spm11_contents <= sx ; end
       6'b010010 : begin spm12_contents <= sx ; end
       6'b010011 : begin spm13_contents <= sx ; end
       6'b010100 : begin spm14_contents <= sx ; end
       6'b010101 : begin spm15_contents <= sx ; end
       6'b010110 : begin spm16_contents <= sx ; end
       6'b010111 : begin spm17_contents <= sx ; end
       6'b011000 : begin spm18_contents <= sx ; end
       6'b011001 : begin spm19_contents <= sx ; end
       6'b011010 : begin spm1a_contents <= sx ; end
       6'b011011 : begin spm1b_contents <= sx ; end
       6'b011100 : begin spm1c_contents <= sx ; end
       6'b011101 : begin spm1d_contents <= sx ; end
       6'b011110 : begin spm1e_contents <= sx ; end
       6'b011111 : begin spm1f_contents <= sx ; end
       6'b100000 : begin spm20_contents <= sx ; end
       6'b100001 : begin spm21_contents <= sx ; end
       6'b100010 : begin spm22_contents <= sx ; end
       6'b100011 : begin spm23_contents <= sx ; end
       6'b100100 : begin spm24_contents <= sx ; end
       6'b100101 : begin spm25_contents <= sx ; end
       6'b100110 : begin spm26_contents <= sx ; end
       6'b100111 : begin spm27_contents <= sx ; end
       6'b101000 : begin spm28_contents <= sx ; end
       6'b101001 : begin spm29_contents <= sx ; end
       6'b101010 : begin spm2a_contents <= sx ; end
       6'b101011 : begin spm2b_contents <= sx ; end
       6'b101100 : begin spm2c_contents <= sx ; end
       6'b101101 : begin spm2d_contents <= sx ; end
       6'b101110 : begin spm2e_contents <= sx ; end
       6'b101111 : begin spm2f_contents <= sx ; end
       6'b110000 : begin spm30_contents <= sx ; end
       6'b110001 : begin spm31_contents <= sx ; end
       6'b110010 : begin spm32_contents <= sx ; end
       6'b110011 : begin spm33_contents <= sx ; end
       6'b110100 : begin spm34_contents <= sx ; end
       6'b110101 : begin spm35_contents <= sx ; end
       6'b110110 : begin spm36_contents <= sx ; end
       6'b110111 : begin spm37_contents <= sx ; end
       6'b111000 : begin spm38_contents <= sx ; end
       6'b111001 : begin spm39_contents <= sx ; end
       6'b111010 : begin spm3a_contents <= sx ; end
       6'b111011 : begin spm3b_contents <= sx ; end
       6'b111100 : begin spm3c_contents <= sx ; end
       6'b111101 : begin spm3d_contents <= sx ; end
       6'b111110 : begin spm3e_contents <= sx ; end
       default   : begin spm3f_contents <= sx ; end
     endcase
   end
 end
//**********************************************************************************
// End of simulation code.
//**********************************************************************************
 //synthesis translate_on
////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE KCPSM3.V
//
////////////////////////////////////////////////////////////////////////////////////
//
endmodule