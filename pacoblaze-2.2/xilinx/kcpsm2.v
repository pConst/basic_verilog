// Constant (K) Coded Programmable State Machine for Virtex-II Devices
//
// Verilog Version : 1.00
//            Date : July 2003
//
// Translation by Joel Coburn - Xilinx Inc.
//
// Derived from kcpsm2.vhd version 1.31 - 19th September 2002
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
//----------------------------------------------------------------------------------
//
// NOTICE:
//
// Copyright Xilinx, Inc. 2003.   This code may be contain portions patented by other 
// third parties.  By providing this core as one possible implementation of a standard,
// Xilinx is making no representation that the provided implementation of this standard 
// is free from any claims of infringement by any third party.  Xilinx expressly 
// disclaims any warranty with respect to the adequacy of the implementation, including 
// but not limited to any warranty or representation that the implementation is free 
// from claims of any third party.  Futhermore, Xilinx is providing this core as a 
// courtesy to you and suggests that you contact all third parties to obtain the 
// necessary rights to use this implementation.
//
//----------------------------------------------------------------------------------
//
// Format of this file.
//
// This file contains the definition of KCPSM2 and all the submodules which it requires. 
//
// The submodules define the implementation of the logic using Xilinx primitives.
// These ensure predictable synthesis results and maximise the density of the implementation. 
// The Unisim Library is used to define Xilinx primitives. It is also used during
// simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
// It is only specified in sub modules which contain primitive components.
// 
//----------------------------------------------------------------------------------
//
// Main Entity for KCPSM2
//
module kcpsm2 (address, instruction, port_id, write_strobe, out_port, read_strobe, in_port, interrupt, reset, clk);

   output[9:0] address; 
   wire[9:0] address;
   input[17:0] instruction; 
   output[7:0] port_id; 
   wire[7:0] port_id;
   output write_strobe; 
   wire write_strobe;
   output[7:0] out_port; 
   wire[7:0] out_port;
   output read_strobe; 
   wire read_strobe;
   input[7:0] in_port; 
   input interrupt; 
   input reset; 
   input clk; 

   wire T_state; 
   wire internal_reset; 
   wire[7:0] sX_register; 
   wire[7:0] sY_register; 
   wire register_write_enable; 
   wire[7:0] second_operand; 
   wire[7:0] logical_result; 
   wire[7:0] shift_and_rotate_result; 
   wire shift_and_rotate_carry; 
   wire[7:0] arithmetic_result; 
   wire arithmetic_carry; 
   wire[7:0] ALU_result; 
   wire carry_flag; 
   wire zero_flag; 
   wire flag_clock_enable; 
   wire flag_condition_met; 
   wire shaddow_carry_flag; 
   wire shaddow_zero_flag; 
   wire interrupt_enable; 
   wire active_interrupt; 
   wire[9:0] program_count; 
   wire[9:0] stack_pop_data; 
   wire[4:0] stack_pointer; 

   assign out_port = sX_register ;
   assign port_id = second_operand ;
   T_state_and_Reset basic_control (.reset_input(reset), .internal_reset(internal_reset), .T_state(T_state), .clk(clk)); 
   data_register_bank data_registers (.Address_A(instruction[12:8]), .Din_A_bus(ALU_result), .Write_A_bus(register_write_enable), .Dout_A_bus(sX_register), .Address_B(instruction[7:3]), .Dout_B_bus(sY_register), .clk(clk)); 
   zero_flag_logic zero (.data(ALU_result), .instruction17(instruction[17]), .instruction14(instruction[14]), .shadow_zero(shaddow_zero_flag), .reset(internal_reset), .flag_enable(flag_clock_enable), .zero_flag(zero_flag), .clk(clk)); 
   carry_flag_logic carry (.instruction17(instruction[17]), .instruction15(instruction[15]), .instruction14(instruction[14]), .shift_carry(shift_and_rotate_carry), .add_sub_carry(arithmetic_carry), .shadow_carry(shaddow_carry_flag), .reset(internal_reset), .flag_enable(flag_clock_enable), .carry_flag(carry_flag), .clk(clk)); 
   register_and_flag_enable reg_and_flag_enables (.instruction(instruction[17:13]), .active_interrupt(active_interrupt), .T_state(T_state), .register_enable(register_write_enable), .flag_enable(flag_clock_enable), .clk(clk)); 
   flag_test test_flags (.instruction11(instruction[11]), .instruction10(instruction[10]), .zero_flag(zero_flag), .carry_flag(carry_flag), .condition_met(flag_condition_met)); 
   data_bus_mux2 operand_select (.D1_bus(sY_register), .D0_bus(instruction[7:0]), .sel(instruction[16]), .Y_bus(second_operand)); 
   logical_bus_processing logical_group (.first_operand(sX_register), .second_operand(second_operand), .code1(instruction[14]), .code0(instruction[13]), .Y(logical_result), .clk(clk)); 
   arithmetic_process arithmetic_group (.first_operand(sX_register), .second_operand(second_operand), .carry_in(carry_flag), .code1(instruction[14]), .code0(instruction[13]), .Y(arithmetic_result), .carry_out(arithmetic_carry), .clk(clk)); 
   shift_rotate_process shift_group (.operand(sX_register), .carry_in(carry_flag), .inject_bit(instruction[0]), .shift_right(instruction[3]), .code1(instruction[2]), .code0(instruction[1]), .Y(shift_and_rotate_result), .carry_out(shift_and_rotate_carry), .clk(clk)); 
   data_bus_mux4 ALU_mux (.D3_bus(shift_and_rotate_result), .D2_bus(in_port), .D1_bus(arithmetic_result), .D0_bus(logical_result), .sel1(instruction[17]), .sel0(instruction[15]), .Y_bus(ALU_result)); 
   program_counter prog_count (.instruction17(instruction[17]), .instruction16(instruction[16]), .instruction15(instruction[15]), .instruction14(instruction[14]), .instruction12(instruction[12]), .low_instruction(instruction[9:0]), .stack_value(stack_pop_data), .flag_condition_met(flag_condition_met), .T_state(T_state), .reset(internal_reset), .force_3FF(active_interrupt), .program_count(program_count), .clk(clk)); 
   assign address = program_count ;
   stack_ram stack_memory (.Din(program_count), .Dout(stack_pop_data), .addr(stack_pointer), .write_bar(T_state), .clk(clk)); 
   stack_counter stack_control (.instruction17(instruction[17]), .instruction16(instruction[16]), .instruction14(instruction[14]), .instruction13(instruction[13]), .instruction12(instruction[12]), .T_state(T_state), .flag_condition_met(flag_condition_met), .active_interrupt(active_interrupt), .reset(internal_reset), .stack_count(stack_pointer), .clk(clk)); 
   IO_strobe_logic IO_strobes (.instruction17(instruction[17]), .instruction15(instruction[15]), .instruction14(instruction[14]), .instruction13(instruction[13]), .active_interrupt(active_interrupt), .T_state(T_state), .reset(internal_reset), .write_strobe(write_strobe), .read_strobe(read_strobe), .clk(clk)); 
   interrupt_capture get_interrupt (.interrupt(interrupt), .T_state(T_state), .reset(internal_reset), .interrupt_enable(interrupt_enable), .active_interrupt(active_interrupt), .clk(clk)); 
   interrupt_logic interrupt_control (.instruction17(instruction[17]), .instruction15(instruction[15]), .instruction14(instruction[14]), .instruction0(instruction[0]), .active_interrupt(active_interrupt), .carry_flag(carry_flag), .zero_flag(zero_flag), .reset(internal_reset), .interrupt_enable(interrupt_enable), .shaddow_carry(shaddow_carry_flag), .shaddow_zero(shaddow_zero_flag), .clk(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of an 8-bit adder/subtractor
//	
// This function uses 8 LUTs and associated MUXCY/XORCY components.
// The function contains an output pipeline register using 8 FDs.
// Total size is 4 slices.
//
//     subtract    Operation
//
//         0          ADD          Y <= first_operand + second_operand
//         1          SUB          Y <= first_operand - second_operand
//
//
module addsub8 (first_operand, second_operand, carry_in, subtract, Y, carry_out, clk);

   input[7:0] first_operand; 
   input[7:0] second_operand; 
   input carry_in; 
   input subtract; 
   output[7:0] Y; 
   wire[7:0] Y;
   output carry_out; 
   wire carry_out;
   input clk; 

   wire[7:0] half_addsub; 
   wire[7:0] full_addsub; 
   wire[6:0] carry_chain; 

   MUXCY arithmetic_carry_0 (.DI(first_operand[0]), .CI(carry_in), .S(half_addsub[0]), .O(carry_chain[0]));

   XORCY arithmetic_xor_0 (.LI(half_addsub[0]), .CI(carry_in), .O(full_addsub[0]));

   LUT3 arithmetic_lut_0(.I0(first_operand[0]), .I1(second_operand[0]), .I2(subtract), .O(half_addsub[0])); 
   // synthesis translate_off
   defparam arithmetic_lut_0.INIT = 8'h96;
   // synthesis translate_on
   // synthesis attribute INIT of arithmetic_lut_0 "96"
   FD pipeline_bit_0 (.D(full_addsub[0]), .Q(Y[0]), .C(clk));

   MUXCY arithmetic_carry_xhdl1_1 (.DI(first_operand[1]), .CI(carry_chain[1 - 1]), .S(half_addsub[1]), .O(carry_chain[1]));

   XORCY arithmetic_xor_xhdl2_1 (.LI(half_addsub[1]), .CI(carry_chain[1 - 1]), .O(full_addsub[1]));

   LUT3 arithmetic_lut_1(.I0(first_operand[1]), .I1(second_operand[1]), .I2(subtract), .O(half_addsub[1])); 
   // synthesis translate_off
   defparam arithmetic_lut_1.INIT = 8'h96;
   // synthesis translate_on
   // synthesis attribute INIT of arithmetic_lut_1 "96"
   FD pipeline_bit_1 (.D(full_addsub[1]), .Q(Y[1]), .C(clk));

   MUXCY arithmetic_carry_xhdl1_2 (.DI(first_operand[2]), .CI(carry_chain[2 - 1]), .S(half_addsub[2]), .O(carry_chain[2]));

   XORCY arithmetic_xor_xhdl2_2 (.LI(half_addsub[2]), .CI(carry_chain[2 - 1]), .O(full_addsub[2]));

   LUT3 arithmetic_lut_2(.I0(first_operand[2]), .I1(second_operand[2]), .I2(subtract), .O(half_addsub[2])); 
   // synthesis translate_off
   defparam arithmetic_lut_2.INIT = 8'h96;
   // synthesis translate_on
   // synthesis attribute INIT of arithmetic_lut_2 "96"
   FD pipeline_bit_2 (.D(full_addsub[2]), .Q(Y[2]), .C(clk));

   MUXCY arithmetic_carry_xhdl1_3 (.DI(first_operand[3]), .CI(carry_chain[3 - 1]), .S(half_addsub[3]), .O(carry_chain[3]));

   XORCY arithmetic_xor_xhdl2_3 (.LI(half_addsub[3]), .CI(carry_chain[3 - 1]), .O(full_addsub[3]));

   LUT3 arithmetic_lut_3(.I0(first_operand[3]), .I1(second_operand[3]), .I2(subtract), .O(half_addsub[3])); 
   // synthesis translate_off
   defparam arithmetic_lut_3.INIT = 8'h96;
   // synthesis translate_on
   // synthesis attribute INIT of arithmetic_lut_3 "96"
   FD pipeline_bit_3 (.D(full_addsub[3]), .Q(Y[3]), .C(clk));

   MUXCY arithmetic_carry_xhdl1_4 (.DI(first_operand[4]), .CI(carry_chain[4 - 1]), .S(half_addsub[4]), .O(carry_chain[4]));

   XORCY arithmetic_xor_xhdl2_4 (.LI(half_addsub[4]), .CI(carry_chain[4 - 1]), .O(full_addsub[4]));

   LUT3 arithmetic_lut_4(.I0(first_operand[4]), .I1(second_operand[4]), .I2(subtract), .O(half_addsub[4])); 
   // synthesis translate_off
   defparam arithmetic_lut_4.INIT = 8'h96;
   // synthesis translate_on
   // synthesis attribute INIT of arithmetic_lut_4 "96"
   FD pipeline_bit_4 (.D(full_addsub[4]), .Q(Y[4]), .C(clk));

   MUXCY arithmetic_carry_xhdl1_5 (.DI(first_operand[5]), .CI(carry_chain[5 - 1]), .S(half_addsub[5]), .O(carry_chain[5]));

   XORCY arithmetic_xor_xhdl2_5 (.LI(half_addsub[5]), .CI(carry_chain[5 - 1]), .O(full_addsub[5]));

   LUT3 arithmetic_lut_5(.I0(first_operand[5]), .I1(second_operand[5]), .I2(subtract), .O(half_addsub[5])); 
   // synthesis translate_off
   defparam arithmetic_lut_5.INIT = 8'h96;
   // synthesis translate_on
   // synthesis attribute INIT of arithmetic_lut_5 "96"
   FD pipeline_bit_5 (.D(full_addsub[5]), .Q(Y[5]), .C(clk));

   MUXCY arithmetic_carry_xhdl1_6 (.DI(first_operand[6]), .CI(carry_chain[6 - 1]), .S(half_addsub[6]), .O(carry_chain[6]));

   XORCY arithmetic_xor_xhdl2_6 (.LI(half_addsub[6]), .CI(carry_chain[6 - 1]), .O(full_addsub[6]));

   LUT3 arithmetic_lut_6(.I0(first_operand[6]), .I1(second_operand[6]), .I2(subtract), .O(half_addsub[6])); 
   // synthesis translate_off
   defparam arithmetic_lut_6.INIT = 8'h96;
   // synthesis translate_on
   // synthesis attribute INIT of arithmetic_lut_6 "96"
   FD pipeline_bit_6 (.D(full_addsub[6]), .Q(Y[6]), .C(clk));

   MUXCY arithmetic_carry_xhdl3_7 (.DI(first_operand[7]), .CI(carry_chain[7 - 1]), .S(half_addsub[7]), .O(carry_out));

   XORCY arithmetic_xor_xhdl4_7 (.LI(half_addsub[7]), .CI(carry_chain[7 - 1]), .O(full_addsub[7]));

   LUT3 arithmetic_lut_7(.I0(first_operand[7]), .I1(second_operand[7]), .I2(subtract), .O(half_addsub[7])); 
   // synthesis translate_off
   defparam arithmetic_lut_7.INIT = 8'h96;
   // synthesis translate_on
   // synthesis attribute INIT of arithmetic_lut_7 "96"
   FD pipeline_bit_7 (.D(full_addsub[7]), .Q(Y[7]), .C(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of an 8-bit arithmetic process
//	
// This function uses 10 LUTs and associated carry logic.
// The function contains an output pipeline register using 9 FDs.
//
// Operation
//
// Two input operands are added or subtracted.
// An input carry bit can be included in the calculation.
// An output carry is always generated.
// Carry signals work in the positive sense at all times.
//
//     code1     code0         Bit injected
//
//       0        0            ADD           
//       0        1            ADD with carry 
//       1        0            SUB  
//       1        1            SUB with carry 
//
//
module arithmetic_process (first_operand, second_operand, carry_in, code1, code0, Y, carry_out, clk);

   input[7:0] first_operand; 
   input[7:0] second_operand; 
   input carry_in; 
   input code1; 
   input code0; 
   output[7:0] Y; 
   wire[7:0] Y;
   output carry_out; 
   wire carry_out;
   input clk; 

   wire carry_in_bit; 
   wire carry_out_bit; 
   wire modified_carry_out; 
 
   LUT3 carry_input_lut(.I0(carry_in), .I1(code0), .I2(code1), .O(carry_in_bit)); 
   // synthesis translate_off
   defparam carry_input_lut.INIT = 8'h78;
   // synthesis translate_on
   // synthesis attribute INIT of carry_input_lut "78" 
   addsub8 add_sub_module (.first_operand(first_operand), .second_operand(second_operand), .carry_in(carry_in_bit), .subtract(code1), .Y(Y), .carry_out(carry_out_bit), .clk(clk)); 

   LUT2 carry_output_lut(.I0(carry_out_bit), .I1(code1), .O(modified_carry_out)); 
   // synthesis translate_off
   defparam carry_output_lut.INIT = 4'h6;
   // synthesis translate_on
   // synthesis attribute INIT of carry_output_lut "6"
   FD pipeline_bit (.D(modified_carry_out), .Q(carry_out), .C(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of the Carry Flag 
//
// 2 LUTs are used to select the source for the CARRY flag
// which is stored in an FDRE.
//	
//
module carry_flag_logic (instruction17, instruction15, instruction14, shift_carry, add_sub_carry, shadow_carry, reset, flag_enable, carry_flag, clk);

   input instruction17; 
   input instruction15; 
   input instruction14; 
   input shift_carry; 
   input add_sub_carry; 
   input shadow_carry; 
   input reset; 
   input flag_enable; 
   output carry_flag; 
   wire carry_flag;
   input clk; 

   wire carry_status; 
   wire next_carry_flag; 

   LUT4 status_lut(.I0(instruction15), .I1(instruction17), .I2(add_sub_carry), .I3(shift_carry), .O(carry_status)); 
   // synthesis translate_off
   defparam status_lut.INIT = 16'hEC20;
   // synthesis translate_on
   // synthesis attribute INIT of status_lut "EC20"

   LUT4 select_lut(.I0(instruction14), .I1(instruction17), .I2(carry_status), .I3(shadow_carry), .O(next_carry_flag)); 
   // synthesis translate_off
   defparam select_lut.INIT = 16'hF870;
   // synthesis translate_on
   // synthesis attribute INIT of select_lut "F870"
   FDRE carry_flag_flop (.D(next_carry_flag), .Q(carry_flag), .CE(flag_enable), .R(reset), .C(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of an 8-bit bus 2 to 1 multiplexer
//
// Requires 8 LUTs or 4 \'slices\'.
//	 
//
module data_bus_mux2 (D1_bus, D0_bus, sel, Y_bus);

   input[7:0] D1_bus; 
   input[7:0] D0_bus; 
   input sel; 
   output[7:0] Y_bus; 
   wire[7:0] Y_bus;

   mux2_LUT bit_mux2_0 (.D1(D1_bus[0]), .D0(D0_bus[0]), .sel(sel), .Y(Y_bus[0]));

   mux2_LUT bit_mux2_1 (.D1(D1_bus[1]), .D0(D0_bus[1]), .sel(sel), .Y(Y_bus[1]));

   mux2_LUT bit_mux2_2 (.D1(D1_bus[2]), .D0(D0_bus[2]), .sel(sel), .Y(Y_bus[2]));

   mux2_LUT bit_mux2_3 (.D1(D1_bus[3]), .D0(D0_bus[3]), .sel(sel), .Y(Y_bus[3]));

   mux2_LUT bit_mux2_4 (.D1(D1_bus[4]), .D0(D0_bus[4]), .sel(sel), .Y(Y_bus[4]));

   mux2_LUT bit_mux2_5 (.D1(D1_bus[5]), .D0(D0_bus[5]), .sel(sel), .Y(Y_bus[5]));

   mux2_LUT bit_mux2_6 (.D1(D1_bus[6]), .D0(D0_bus[6]), .sel(sel), .Y(Y_bus[6]));

   mux2_LUT bit_mux2_7 (.D1(D1_bus[7]), .D0(D0_bus[7]), .sel(sel), .Y(Y_bus[7])); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of an 8-bit bus 4 to 1 multiplexer
//	 
// Requires 8 \'slices\'.
//
//
module data_bus_mux4 (D3_bus, D2_bus, D1_bus, D0_bus, sel1, sel0, Y_bus);

   input[7:0] D3_bus; 
   input[7:0] D2_bus; 
   input[7:0] D1_bus; 
   input[7:0] D0_bus; 
   input sel1; 
   input sel0; 
   output[7:0] Y_bus; 
   wire[7:0] Y_bus;

   mux4_LUTS_MUXF5 bit_mux4_0 (.D3(D3_bus[0]), .D2(D2_bus[0]), .D1(D1_bus[0]), .D0(D0_bus[0]), .sel1(sel1), .sel0(sel0), .Y(Y_bus[0]));

   mux4_LUTS_MUXF5 bit_mux4_1 (.D3(D3_bus[1]), .D2(D2_bus[1]), .D1(D1_bus[1]), .D0(D0_bus[1]), .sel1(sel1), .sel0(sel0), .Y(Y_bus[1]));

   mux4_LUTS_MUXF5 bit_mux4_2 (.D3(D3_bus[2]), .D2(D2_bus[2]), .D1(D1_bus[2]), .D0(D0_bus[2]), .sel1(sel1), .sel0(sel0), .Y(Y_bus[2]));

   mux4_LUTS_MUXF5 bit_mux4_3 (.D3(D3_bus[3]), .D2(D2_bus[3]), .D1(D1_bus[3]), .D0(D0_bus[3]), .sel1(sel1), .sel0(sel0), .Y(Y_bus[3]));

   mux4_LUTS_MUXF5 bit_mux4_4 (.D3(D3_bus[4]), .D2(D2_bus[4]), .D1(D1_bus[4]), .D0(D0_bus[4]), .sel1(sel1), .sel0(sel0), .Y(Y_bus[4]));

   mux4_LUTS_MUXF5 bit_mux4_5 (.D3(D3_bus[5]), .D2(D2_bus[5]), .D1(D1_bus[5]), .D0(D0_bus[5]), .sel1(sel1), .sel0(sel0), .Y(Y_bus[5]));

   mux4_LUTS_MUXF5 bit_mux4_6 (.D3(D3_bus[6]), .D2(D2_bus[6]), .D1(D1_bus[6]), .D0(D0_bus[6]), .sel1(sel1), .sel0(sel0), .Y(Y_bus[6]));

   mux4_LUTS_MUXF5 bit_mux4_7 (.D3(D3_bus[7]), .D2(D2_bus[7]), .D1(D1_bus[7]), .D0(D0_bus[7]), .sel1(sel1), .sel0(sel0), .Y(Y_bus[7])); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of an 8-bit dual port RAM with 32 locations
//	
// This mode of distributed RAM requires 2 \'slices\' per bit.
// Hence this 8-bit module requires 16 \'slices\'.
// 
//
module data_register_bank (Address_A, Din_A_bus, Write_A_bus, Dout_A_bus, Address_B, Dout_B_bus, clk);

   input[4:0] Address_A; 
   input[7:0] Din_A_bus; 
   input Write_A_bus; 
   output[7:0] Dout_A_bus; 
   wire[7:0] Dout_A_bus;
   input[4:0] Address_B; 
   output[7:0] Dout_B_bus; 
   wire[7:0] Dout_B_bus;
   input clk; 

   RAM32X1D data_register_bit_0(.D(Din_A_bus[0]), .WE(Write_A_bus), .WCLK(clk), .A0(Address_A[0]), .A1(Address_A[1]), .A2(Address_A[2]), .A3(Address_A[3]), .A4(Address_A[4]), .DPRA0(Address_B[0]), .DPRA1(Address_B[1]), .DPRA2(Address_B[2]), .DPRA3(Address_B[3]), .DPRA4(Address_B[4]), .SPO(Dout_A_bus[0]), .DPO(Dout_B_bus[0])); 
   // synthesis translate_off
   defparam data_register_bit_0.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of data_register_bit_0 "00000000"

   RAM32X1D data_register_bit_1(.D(Din_A_bus[1]), .WE(Write_A_bus), .WCLK(clk), .A0(Address_A[0]), .A1(Address_A[1]), .A2(Address_A[2]), .A3(Address_A[3]), .A4(Address_A[4]), .DPRA0(Address_B[0]), .DPRA1(Address_B[1]), .DPRA2(Address_B[2]), .DPRA3(Address_B[3]), .DPRA4(Address_B[4]), .SPO(Dout_A_bus[1]), .DPO(Dout_B_bus[1])); 
   // synthesis translate_off
   defparam data_register_bit_1.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of data_register_bit_1 "00000000"

   RAM32X1D data_register_bit_2(.D(Din_A_bus[2]), .WE(Write_A_bus), .WCLK(clk), .A0(Address_A[0]), .A1(Address_A[1]), .A2(Address_A[2]), .A3(Address_A[3]), .A4(Address_A[4]), .DPRA0(Address_B[0]), .DPRA1(Address_B[1]), .DPRA2(Address_B[2]), .DPRA3(Address_B[3]), .DPRA4(Address_B[4]), .SPO(Dout_A_bus[2]), .DPO(Dout_B_bus[2])); 
   // synthesis translate_off
   defparam data_register_bit_2.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of data_register_bit_2 "00000000"

   RAM32X1D data_register_bit_3(.D(Din_A_bus[3]), .WE(Write_A_bus), .WCLK(clk), .A0(Address_A[0]), .A1(Address_A[1]), .A2(Address_A[2]), .A3(Address_A[3]), .A4(Address_A[4]), .DPRA0(Address_B[0]), .DPRA1(Address_B[1]), .DPRA2(Address_B[2]), .DPRA3(Address_B[3]), .DPRA4(Address_B[4]), .SPO(Dout_A_bus[3]), .DPO(Dout_B_bus[3])); 
   // synthesis translate_off
   defparam data_register_bit_3.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of data_register_bit_3 "00000000"

   RAM32X1D data_register_bit_4(.D(Din_A_bus[4]), .WE(Write_A_bus), .WCLK(clk), .A0(Address_A[0]), .A1(Address_A[1]), .A2(Address_A[2]), .A3(Address_A[3]), .A4(Address_A[4]), .DPRA0(Address_B[0]), .DPRA1(Address_B[1]), .DPRA2(Address_B[2]), .DPRA3(Address_B[3]), .DPRA4(Address_B[4]), .SPO(Dout_A_bus[4]), .DPO(Dout_B_bus[4])); 
   // synthesis translate_off
   defparam data_register_bit_4.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of data_register_bit_4 "00000000"

   RAM32X1D data_register_bit_5(.D(Din_A_bus[5]), .WE(Write_A_bus), .WCLK(clk), .A0(Address_A[0]), .A1(Address_A[1]), .A2(Address_A[2]), .A3(Address_A[3]), .A4(Address_A[4]), .DPRA0(Address_B[0]), .DPRA1(Address_B[1]), .DPRA2(Address_B[2]), .DPRA3(Address_B[3]), .DPRA4(Address_B[4]), .SPO(Dout_A_bus[5]), .DPO(Dout_B_bus[5])); 
   // synthesis translate_off
   defparam data_register_bit_5.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of data_register_bit_5 "00000000"

   RAM32X1D data_register_bit_6(.D(Din_A_bus[6]), .WE(Write_A_bus), .WCLK(clk), .A0(Address_A[0]), .A1(Address_A[1]), .A2(Address_A[2]), .A3(Address_A[3]), .A4(Address_A[4]), .DPRA0(Address_B[0]), .DPRA1(Address_B[1]), .DPRA2(Address_B[2]), .DPRA3(Address_B[3]), .DPRA4(Address_B[4]), .SPO(Dout_A_bus[6]), .DPO(Dout_B_bus[6])); 
   // synthesis translate_off
   defparam data_register_bit_6.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of data_register_bit_6 "00000000"

   RAM32X1D data_register_bit_7(.D(Din_A_bus[7]), .WE(Write_A_bus), .WCLK(clk), .A0(Address_A[0]), .A1(Address_A[1]), .A2(Address_A[2]), .A3(Address_A[3]), .A4(Address_A[4]), .DPRA0(Address_B[0]), .DPRA1(Address_B[1]), .DPRA2(Address_B[2]), .DPRA3(Address_B[3]), .DPRA4(Address_B[4]), .SPO(Dout_A_bus[7]), .DPO(Dout_B_bus[7]));  
   // synthesis translate_off
   defparam data_register_bit_7.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of data_register_bit_7 "00000000"
endmodule

//----------------------------------------------------------------------------------
//
// Definition of a 10-bit dual loadable counter for use as Program Counter
//	
// This function uses 20 LUTs and associated MUXCY/XORCY components.
// The count value is held in 10 FDs.
//
// Operation
//
// When the normal_count signal is high the 10-bit counter will simply increment
// by selecting the feedback from the register and incrementing it.
//
// When the normal_count signal is low, the counter will load a new input value.
// The new value can be selected from one of two inputs, and optionally incremented
// before being applied to the counter register. 
//
// In this way the counter can load an absolute value used during a JUMP or CALL,
// instruction, or alternatively, load a value from the stack during a RETURN or 
// RETURNI instruction. During a RETURN, the value must be incremented.
//
// The register has an active low clock enable and a reset. 
// It also has the ability to be forced to maximum count (3FF) in the event of an interrupt.
//
//
module dual_loadable_counter (load_1_value, load_0_value, select_load_value, increment_load_value, normal_count, enable_bar, reset, force_3FF, count, clk);

   input[9:0] load_1_value; 
   input[9:0] load_0_value; 
   input select_load_value; 
   input increment_load_value; 
   input normal_count; 
   input enable_bar; 
   input reset; 
   input force_3FF; 
   output[9:0] count; 
   wire[9:0] count;
   input clk; 

   wire not_enable; 
   wire[9:0] selected_load_value; 
   wire[8:0] inc_load_value_carry; 
   wire[9:0] inc_load_value; 
   wire[9:0] selected_count_value; 
   wire[8:0] inc_count_value_carry; 
   wire[9:0] inc_count_value; 
   wire[9:0] count_value; 

   INV invert_enable (.I(enable_bar), .O(not_enable)); 
   mux2_LUT value_select_mux_0 (.D1(load_1_value[0]), .D0(load_0_value[0]), .sel(select_load_value), .Y(selected_load_value[0]));

   mux2_LUT count_select_mux_0 (.D1(count_value[0]), .D0(inc_load_value[0]), .sel(normal_count), .Y(selected_count_value[0]));

   FDRSE register_bit_0 (.D(inc_count_value[0]), .Q(count_value[0]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   MUXCY load_inc_carry_0 (.DI(1'b0), .CI(increment_load_value), .S(selected_load_value[0]), .O(inc_load_value_carry[0]));

   XORCY load_inc_xor_0 (.LI(selected_load_value[0]), .CI(increment_load_value), .O(inc_load_value[0]));

   MUXCY count_inc_carry_0 (.DI(1'b0), .CI(normal_count), .S(selected_count_value[0]), .O(inc_count_value_carry[0]));

   XORCY count_inc_xor_0 (.LI(selected_count_value[0]), .CI(normal_count), .O(inc_count_value[0]));

   mux2_LUT value_select_mux_1 (.D1(load_1_value[1]), .D0(load_0_value[1]), .sel(select_load_value), .Y(selected_load_value[1]));

   mux2_LUT count_select_mux_1 (.D1(count_value[1]), .D0(inc_load_value[1]), .sel(normal_count), .Y(selected_count_value[1]));

   FDRSE register_bit_1 (.D(inc_count_value[1]), .Q(count_value[1]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   MUXCY load_inc_carry_xhdl1_1 (.DI(1'b0), .CI(inc_load_value_carry[1 - 1]), .S(selected_load_value[1]), .O(inc_load_value_carry[1]));

   XORCY load_inc_xor_xhdl2_1 (.LI(selected_load_value[1]), .CI(inc_load_value_carry[1 - 1]), .O(inc_load_value[1]));

   MUXCY count_inc_carry_xhdl3_1 (.DI(1'b0), .CI(inc_count_value_carry[1 - 1]), .S(selected_count_value[1]), .O(inc_count_value_carry[1]));

   XORCY count_inc_xor_xhdl4_1 (.LI(selected_count_value[1]), .CI(inc_count_value_carry[1 - 1]), .O(inc_count_value[1]));

   mux2_LUT value_select_mux_2 (.D1(load_1_value[2]), .D0(load_0_value[2]), .sel(select_load_value), .Y(selected_load_value[2]));

   mux2_LUT count_select_mux_2 (.D1(count_value[2]), .D0(inc_load_value[2]), .sel(normal_count), .Y(selected_count_value[2]));

   FDRSE register_bit_2 (.D(inc_count_value[2]), .Q(count_value[2]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   MUXCY load_inc_carry_xhdl1_2 (.DI(1'b0), .CI(inc_load_value_carry[2 - 1]), .S(selected_load_value[2]), .O(inc_load_value_carry[2]));

   XORCY load_inc_xor_xhdl2_2 (.LI(selected_load_value[2]), .CI(inc_load_value_carry[2 - 1]), .O(inc_load_value[2]));

   MUXCY count_inc_carry_xhdl3_2 (.DI(1'b0), .CI(inc_count_value_carry[2 - 1]), .S(selected_count_value[2]), .O(inc_count_value_carry[2]));

   XORCY count_inc_xor_xhdl4_2 (.LI(selected_count_value[2]), .CI(inc_count_value_carry[2 - 1]), .O(inc_count_value[2]));

   mux2_LUT value_select_mux_3 (.D1(load_1_value[3]), .D0(load_0_value[3]), .sel(select_load_value), .Y(selected_load_value[3]));

   mux2_LUT count_select_mux_3 (.D1(count_value[3]), .D0(inc_load_value[3]), .sel(normal_count), .Y(selected_count_value[3]));

   FDRSE register_bit_3 (.D(inc_count_value[3]), .Q(count_value[3]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   MUXCY load_inc_carry_xhdl1_3 (.DI(1'b0), .CI(inc_load_value_carry[3 - 1]), .S(selected_load_value[3]), .O(inc_load_value_carry[3]));

   XORCY load_inc_xor_xhdl2_3 (.LI(selected_load_value[3]), .CI(inc_load_value_carry[3 - 1]), .O(inc_load_value[3]));

   MUXCY count_inc_carry_xhdl3_3 (.DI(1'b0), .CI(inc_count_value_carry[3 - 1]), .S(selected_count_value[3]), .O(inc_count_value_carry[3]));

   XORCY count_inc_xor_xhdl4_3 (.LI(selected_count_value[3]), .CI(inc_count_value_carry[3 - 1]), .O(inc_count_value[3]));

   mux2_LUT value_select_mux_4 (.D1(load_1_value[4]), .D0(load_0_value[4]), .sel(select_load_value), .Y(selected_load_value[4]));

   mux2_LUT count_select_mux_4 (.D1(count_value[4]), .D0(inc_load_value[4]), .sel(normal_count), .Y(selected_count_value[4]));

   FDRSE register_bit_4 (.D(inc_count_value[4]), .Q(count_value[4]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   MUXCY load_inc_carry_xhdl1_4 (.DI(1'b0), .CI(inc_load_value_carry[4 - 1]), .S(selected_load_value[4]), .O(inc_load_value_carry[4]));

   XORCY load_inc_xor_xhdl2_4 (.LI(selected_load_value[4]), .CI(inc_load_value_carry[4 - 1]), .O(inc_load_value[4]));

   MUXCY count_inc_carry_xhdl3_4 (.DI(1'b0), .CI(inc_count_value_carry[4 - 1]), .S(selected_count_value[4]), .O(inc_count_value_carry[4]));

   XORCY count_inc_xor_xhdl4_4 (.LI(selected_count_value[4]), .CI(inc_count_value_carry[4 - 1]), .O(inc_count_value[4]));

   mux2_LUT value_select_mux_5 (.D1(load_1_value[5]), .D0(load_0_value[5]), .sel(select_load_value), .Y(selected_load_value[5]));

   mux2_LUT count_select_mux_5 (.D1(count_value[5]), .D0(inc_load_value[5]), .sel(normal_count), .Y(selected_count_value[5]));

   FDRSE register_bit_5 (.D(inc_count_value[5]), .Q(count_value[5]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   MUXCY load_inc_carry_xhdl1_5 (.DI(1'b0), .CI(inc_load_value_carry[5 - 1]), .S(selected_load_value[5]), .O(inc_load_value_carry[5]));

   XORCY load_inc_xor_xhdl2_5 (.LI(selected_load_value[5]), .CI(inc_load_value_carry[5 - 1]), .O(inc_load_value[5]));

   MUXCY count_inc_carry_xhdl3_5 (.DI(1'b0), .CI(inc_count_value_carry[5 - 1]), .S(selected_count_value[5]), .O(inc_count_value_carry[5]));

   XORCY count_inc_xor_xhdl4_5 (.LI(selected_count_value[5]), .CI(inc_count_value_carry[5 - 1]), .O(inc_count_value[5]));

   mux2_LUT value_select_mux_6 (.D1(load_1_value[6]), .D0(load_0_value[6]), .sel(select_load_value), .Y(selected_load_value[6]));

   mux2_LUT count_select_mux_6 (.D1(count_value[6]), .D0(inc_load_value[6]), .sel(normal_count), .Y(selected_count_value[6]));

   FDRSE register_bit_6 (.D(inc_count_value[6]), .Q(count_value[6]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   MUXCY load_inc_carry_xhdl1_6 (.DI(1'b0), .CI(inc_load_value_carry[6 - 1]), .S(selected_load_value[6]), .O(inc_load_value_carry[6]));

   XORCY load_inc_xor_xhdl2_6 (.LI(selected_load_value[6]), .CI(inc_load_value_carry[6 - 1]), .O(inc_load_value[6]));

   MUXCY count_inc_carry_xhdl3_6 (.DI(1'b0), .CI(inc_count_value_carry[6 - 1]), .S(selected_count_value[6]), .O(inc_count_value_carry[6]));

   XORCY count_inc_xor_xhdl4_6 (.LI(selected_count_value[6]), .CI(inc_count_value_carry[6 - 1]), .O(inc_count_value[6]));

   mux2_LUT value_select_mux_7 (.D1(load_1_value[7]), .D0(load_0_value[7]), .sel(select_load_value), .Y(selected_load_value[7]));

   mux2_LUT count_select_mux_7 (.D1(count_value[7]), .D0(inc_load_value[7]), .sel(normal_count), .Y(selected_count_value[7]));

   FDRSE register_bit_7 (.D(inc_count_value[7]), .Q(count_value[7]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   MUXCY load_inc_carry_xhdl1_7 (.DI(1'b0), .CI(inc_load_value_carry[7 - 1]), .S(selected_load_value[7]), .O(inc_load_value_carry[7]));

   XORCY load_inc_xor_xhdl2_7 (.LI(selected_load_value[7]), .CI(inc_load_value_carry[7 - 1]), .O(inc_load_value[7]));

   MUXCY count_inc_carry_xhdl3_7 (.DI(1'b0), .CI(inc_count_value_carry[7 - 1]), .S(selected_count_value[7]), .O(inc_count_value_carry[7]));

   XORCY count_inc_xor_xhdl4_7 (.LI(selected_count_value[7]), .CI(inc_count_value_carry[7 - 1]), .O(inc_count_value[7]));

   mux2_LUT value_select_mux_8 (.D1(load_1_value[8]), .D0(load_0_value[8]), .sel(select_load_value), .Y(selected_load_value[8]));

   mux2_LUT count_select_mux_8 (.D1(count_value[8]), .D0(inc_load_value[8]), .sel(normal_count), .Y(selected_count_value[8]));

   FDRSE register_bit_8 (.D(inc_count_value[8]), .Q(count_value[8]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   MUXCY load_inc_carry_xhdl1_8 (.DI(1'b0), .CI(inc_load_value_carry[8 - 1]), .S(selected_load_value[8]), .O(inc_load_value_carry[8]));

   XORCY load_inc_xor_xhdl2_8 (.LI(selected_load_value[8]), .CI(inc_load_value_carry[8 - 1]), .O(inc_load_value[8]));

   MUXCY count_inc_carry_xhdl3_8 (.DI(1'b0), .CI(inc_count_value_carry[8 - 1]), .S(selected_count_value[8]), .O(inc_count_value_carry[8]));

   XORCY count_inc_xor_xhdl4_8 (.LI(selected_count_value[8]), .CI(inc_count_value_carry[8 - 1]), .O(inc_count_value[8]));

   mux2_LUT value_select_mux_9 (.D1(load_1_value[9]), .D0(load_0_value[9]), .sel(select_load_value), .Y(selected_load_value[9]));

   mux2_LUT count_select_mux_9 (.D1(count_value[9]), .D0(inc_load_value[9]), .sel(normal_count), .Y(selected_count_value[9]));

   FDRSE register_bit_9 (.D(inc_count_value[9]), .Q(count_value[9]), .R(reset), .S(force_3FF), .CE(not_enable), .C(clk));

   XORCY load_inc_xor_xhdl5_9 (.LI(selected_load_value[9]), .CI(inc_load_value_carry[9 - 1]), .O(inc_load_value[9]));

   XORCY count_inc_xor_xhdl6_9 (.LI(selected_count_value[9]), .CI(inc_count_value_carry[9 - 1]), .O(inc_count_value[9])); 
   assign count = count_value ;
endmodule

//----------------------------------------------------------------------------------
//
// Decode of flag conditions 
//	
// This function determines if the flags meet the conditions specified in a 
// JUMP, CALL, or RETURN instruction. It is defined as a separate macro because 
// it provides information required by both the program counter and stack pointer.
//
// It uses 1 LUT.
//
//
module flag_test (instruction11, instruction10, zero_flag, carry_flag, condition_met);

   input instruction11; 
   input instruction10; 
   input zero_flag; 
   input carry_flag; 
   output condition_met; 
   wire condition_met;

   LUT4 decode_lut(.I0(carry_flag), .I1(zero_flag), .I2(instruction10), .I3(instruction11), .O(condition_met)); 
   // synthesis translate_off
   defparam decode_lut.INIT = 16'h5A3C;
   // synthesis translate_on
   // synthesis attribute INIT of decode_lut "5A3C"
endmodule

//----------------------------------------------------------------------------------
//
// Definition of interrupt signal capture
//	
// This function accepts the external interrupt signal and synchronises it to the 
// processor logic. It then forms a single cycle pulse provided that interrupts 
// are currently enabled.
//
// It uses 1 LUT and 2 FDs.
//
//
module interrupt_capture (interrupt, T_state, reset, interrupt_enable, active_interrupt, clk);

   input interrupt; 
   input T_state; 
   input reset; 
   input interrupt_enable; 
   output active_interrupt; 
   wire active_interrupt;
   input clk; 

   wire clean_interrupt; 
   wire interrupt_pulse; 
   wire active_interrupt_pulse; 

   FDR input_flop (.D(interrupt), .Q(clean_interrupt), .R(reset), .C(clk)); 

   LUT4 interrupt_pulse_lut(.I0(T_state), .I1(clean_interrupt), .I2(interrupt_enable), .I3(active_interrupt_pulse), .O(interrupt_pulse)); 
   // synthesis translate_off
   defparam interrupt_pulse_lut.INIT = 16'h0080;
   // synthesis translate_on
   // synthesis attribute INIT of interrupt_pulse_lut "0080"
   FDR toggle_flop (.D(interrupt_pulse), .Q(active_interrupt_pulse), .R(reset), .C(clk)); 
   assign active_interrupt = active_interrupt_pulse ;
endmodule

//----------------------------------------------------------------------------------
//
// Definition of interrupt enable and shaddow flags
//	
// This function decodes the ENABLE and DSIABLE INTERRUPT instructions as well as
// the RETURNI ENABLE and RETURNI DISABLE instructions to determine if future interrupts
// will be enabled.
//
// It also provideds the shaddow flags which store the flag status at time of an 
// interrupt.
//
// It uses 2 LUTs and 3 FDs.
//
//
module interrupt_logic (instruction17, instruction15, instruction14, instruction0, active_interrupt, carry_flag, zero_flag, reset, interrupt_enable, shaddow_carry, shaddow_zero, clk);

   input instruction17; 
   input instruction15; 
   input instruction14; 
   input instruction0; 
   input active_interrupt; 
   input carry_flag; 
   input zero_flag; 
   input reset; 
   output interrupt_enable; 
   wire interrupt_enable;
   output shaddow_carry; 
   wire shaddow_carry;
   output shaddow_zero; 
   wire shaddow_zero;
   input clk; 

   wire update_enable; 
   wire new_enable_value; 

   LUT4 decode_lut(.I0(active_interrupt), .I1(instruction14), .I2(instruction15), .I3(instruction17), .O(update_enable)); 
   // synthesis translate_off
   defparam decode_lut.INIT = 16'hEAAA;
   // synthesis translate_on
   // synthesis attribute INIT of decode_lut "EAAA"

   LUT2 value_lut(.I0(active_interrupt), .I1(instruction0), .O(new_enable_value)); 
   // synthesis translate_off
   defparam value_lut.INIT = 4'h4;
   // synthesis translate_on
   // synthesis attribute INIT of value_lut "4"
   FDRE int_enable_flop (.D(new_enable_value), .Q(interrupt_enable), .CE(update_enable), .R(reset), .C(clk)); 
   FDE preserve_carry_flop (.D(carry_flag), .Q(shaddow_carry), .CE(active_interrupt), .C(clk)); 
   FDE preserve_zero_flop (.D(zero_flag), .Q(shaddow_zero), .CE(active_interrupt), .C(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of the Input and Output Strobes 
//	
// Uses 3 LUTs and 2 FDR.
//
//
module IO_strobe_logic (instruction17, instruction15, instruction14, instruction13, active_interrupt, T_state, reset, write_strobe, read_strobe, clk);

   input instruction17; 
   input instruction15; 
   input instruction14; 
   input instruction13; 
   input active_interrupt; 
   input T_state; 
   input reset; 
   output write_strobe; 
   wire write_strobe;
   output read_strobe; 
   wire read_strobe;
   input clk; 

   wire IO_type; 
   wire write_event; 
   wire read_event; 
   
   LUT3 IO_type_lut(.I0(instruction14), .I1(instruction15), .I2(instruction17), .O(IO_type)); 
   // synthesis translate_off
   defparam IO_type_lut.INIT = 8'h10;
   // synthesis translate_on
   // synthesis attribute INIT of IO_type_lut "10"

   LUT4 write_lut(.I0(active_interrupt), .I1(T_state), .I2(instruction13), .I3(IO_type), .O(write_event)); 
   // synthesis translate_off
   defparam write_lut.INIT = 16'h1000;
   // synthesis translate_on
   // synthesis attribute INIT of write_lut "1000"
   FDR write_flop (.D(write_event), .Q(write_strobe), .R(reset), .C(clk)); 

   LUT4 read_lut(.I0(active_interrupt), .I1(T_state), .I2(instruction13), .I3(IO_type), .O(read_event)); 
   // synthesis translate_off
   defparam read_lut.INIT = 16'h0100;
   // synthesis translate_on
   // synthesis attribute INIT of read_lut "0100"
   FDR read_flop (.D(read_event), .Q(read_strobe), .R(reset), .C(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of an 8-bit logical processing unit
//	
// This function uses 8 LUTs (4 slices) to provide the logical bit operations.
// The function contains an output pipeline register using 8 FDs.
//
//     Code1    Code0       Bit Operation
//
//       0        0            LOAD      Y <= second_operand 
//       0        1            AND       Y <= first_operand and second_operand
//       1        0            OR        Y <= first_operand or second_operand 
//       1        1            XOR       Y <= first_operand xor second_operand
//
//
module logical_bus_processing (first_operand, second_operand, code1, code0, Y, clk);

   input[7:0] first_operand; 
   input[7:0] second_operand; 
   input code1; 
   input code0; 
   output[7:0] Y; 
   wire[7:0] Y;
   input clk; 

   wire[7:0] combinatorial_logical_processing; 

   LUT4 logical_lut_0(.I0(second_operand[0]), .I1(first_operand[0]), .I2(code0), .I3(code1), .O(combinatorial_logical_processing[0])); 
   // synthesis translate_off
   defparam logical_lut_0.INIT = 16'h6E8A;
   // synthesis translate_on
   // synthesis attribute INIT of logical_lut_0 "6E8A"

   FD pipeline_bit_0 (.D(combinatorial_logical_processing[0]), .Q(Y[0]), .C(clk));

   LUT4 logical_lut_1(.I0(second_operand[1]), .I1(first_operand[1]), .I2(code0), .I3(code1), .O(combinatorial_logical_processing[1])); 
   // synthesis translate_off
   defparam logical_lut_1.INIT = 16'h6E8A;
   // synthesis translate_on 
   // synthesis attribute INIT of logical_lut_1 "6E8A"
   FD pipeline_bit_1 (.D(combinatorial_logical_processing[1]), .Q(Y[1]), .C(clk));

   LUT4 logical_lut_2(.I0(second_operand[2]), .I1(first_operand[2]), .I2(code0), .I3(code1), .O(combinatorial_logical_processing[2])); 
   // synthesis translate_off
   defparam logical_lut_2.INIT = 16'h6E8A;
   // synthesis translate_on
   // synthesis attribute INIT of logical_lut_2 "6E8A" 
   FD pipeline_bit_2 (.D(combinatorial_logical_processing[2]), .Q(Y[2]), .C(clk));

   LUT4 logical_lut_3(.I0(second_operand[3]), .I1(first_operand[3]), .I2(code0), .I3(code1), .O(combinatorial_logical_processing[3])); 
   // synthesis translate_off
   defparam logical_lut_3.INIT = 16'h6E8A;
   // synthesis translate_on
   // synthesis attribute INIT of logical_lut_3 "6E8A"
   FD pipeline_bit_3 (.D(combinatorial_logical_processing[3]), .Q(Y[3]), .C(clk));

   LUT4 logical_lut_4(.I0(second_operand[4]), .I1(first_operand[4]), .I2(code0), .I3(code1), .O(combinatorial_logical_processing[4])); 
   // synthesis translate_off
   defparam logical_lut_4.INIT = 16'h6E8A;
   // synthesis translate_on
   // synthesis attribute INIT of logical_lut_4 "6E8A"
   FD pipeline_bit_4 (.D(combinatorial_logical_processing[4]), .Q(Y[4]), .C(clk));

   LUT4 logical_lut_5(.I0(second_operand[5]), .I1(first_operand[5]), .I2(code0), .I3(code1), .O(combinatorial_logical_processing[5])); 
   // synthesis translate_off
   defparam logical_lut_5.INIT = 16'h6E8A;
   // synthesis translate_on
   // synthesis attribute INIT of logical_lut_5 "6E8A"
   FD pipeline_bit_5 (.D(combinatorial_logical_processing[5]), .Q(Y[5]), .C(clk));

   LUT4 logical_lut_6(.I0(second_operand[6]), .I1(first_operand[6]), .I2(code0), .I3(code1), .O(combinatorial_logical_processing[6])); 
   // synthesis translate_off
   defparam logical_lut_6.INIT = 16'h6E8A;
   // synthesis translate_on
   // synthesis attribute INIT of logical_lut_6 "6E8A"
   FD pipeline_bit_6 (.D(combinatorial_logical_processing[6]), .Q(Y[6]), .C(clk));

   LUT4 logical_lut_7(.I0(second_operand[7]), .I1(first_operand[7]), .I2(code0), .I3(code1), .O(combinatorial_logical_processing[7])); 
   // synthesis translate_off
   defparam logical_lut_7.INIT = 16'h6E8A;
   // synthesis translate_on
   // synthesis attribute INIT of logical_lut_7 "6E8A"
   FD pipeline_bit_7 (.D(combinatorial_logical_processing[7]), .Q(Y[7]), .C(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of a 2 to 1 multiplexer in a LUT
//
// This simple function is used many times.
//	 
//
module mux2_LUT (D1, D0, sel, Y);

   input D1; 
   input D0; 
   input sel; 
   output Y; 
   wire Y;
	
  LUT3 the_mux_lut(.I0(sel), .I1(D0), .I2(D1), .O(Y));
  // synthesis translate_off
  defparam the_mux_lut.INIT = 8'hE4;
  // synthesis translate_on   
  // synthesis attribute INIT of the_mux_lut "E4"
endmodule

//----------------------------------------------------------------------------------
//
// Definition of a 4 to 1 multiplexer using 2 LUTs and an MUXF5
//	 
// Builds on the definition of a 2 to 1 multiplexer on a LUT to 
// create a 4 to 1 multiplexer in a \'slice\'.
//
//
module mux4_LUTS_MUXF5 (D3, D2, D1, D0, sel1, sel0, Y);

   input D3; 
   input D2; 
   input D1; 
   input D0; 
   input sel1; 
   input sel0; 
   output Y; 
   wire Y;

   wire upper_selection; 
   wire lower_selection; 

   mux2_LUT upper_mux (.D1(D3), .D0(D2), .sel(sel0), .Y(upper_selection)); 
   mux2_LUT lower_mux (.D1(D1), .D0(D0), .sel(sel0), .Y(lower_selection)); 
   MUXF5 final_mux (.I1(upper_selection), .I0(lower_selection), .S(sel1), .O(Y)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of an 10-bit program counter
//	
// This function provides the control to the dual loadable counter macro which uses
// 3 LUTs. The total size of the program counter is then 23 LUTs (12 slices).
//
//
module program_counter (instruction17, instruction16, instruction15, instruction14, instruction12, low_instruction, stack_value, flag_condition_met, T_state, reset, force_3FF, program_count, clk);

   input instruction17; 
   input instruction16; 
   input instruction15; 
   input instruction14; 
   input instruction12; 
   input[9:0] low_instruction; 
   input[9:0] stack_value; 
   input flag_condition_met; 
   input T_state; 
   input reset; 
   input force_3FF; 
   output[9:0] program_count; 
   wire[9:0] program_count;
   input clk; 

   wire move_group; 
   wire normal_count; 
   wire increment_vector; 

   LUT4 move_group_lut(.I0(instruction14), .I1(instruction15), .I2(instruction16), .I3(instruction17), .O(move_group)); 
   // synthesis translate_off
   defparam move_group_lut.INIT = 16'h2A00;
   // synthesis translate_on
   // synthesis attribute INIT of move_group_lut "2A00"

   LUT3 normal_count_lut(.I0(instruction12), .I1(flag_condition_met), .I2(move_group), .O(normal_count)); 
   // synthesis translate_off
   defparam normal_count_lut.INIT = 8'h2F;
   // synthesis translate_on
   // synthesis attribute INIT of normal_count_lut "2F"

   LUT2 inc_vector_lut(.I0(instruction15), .I1(instruction16), .O(increment_vector)); 
   // synthesis translate_off
   defparam inc_vector_lut.INIT = 4'h1;
   // synthesis translate_on
   // synthesis attribute INIT of inc_vector_lut "1"
   dual_loadable_counter the_counter (.load_1_value(low_instruction), .load_0_value(stack_value), .select_load_value(instruction16), .increment_load_value(increment_vector), .normal_count(normal_count), .enable_bar(T_state), .reset(reset), .force_3FF(force_3FF), .count(program_count), .clk(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of write enable for register bank and flags
//	
// This function decodes all instructions which result in a value being stored
// in the data registers and those cases in which the flags must be enabled. 
// It uses 5 LUTs and and 3 FDs.
// The generation of a register enable pulse is prevented by an active interrupt condition.
// The single cycle pulse timing of each enable is determined by the T-state.  
//
//
module register_and_flag_enable (instruction, active_interrupt, T_state, register_enable, flag_enable, clk);

   input[17:13] instruction; 
   input active_interrupt; 
   input T_state; 
   output register_enable; 
   wire register_enable;
   output flag_enable; 
   wire flag_enable;
   input clk; 

   wire reg_instruction_decode; 
   wire register_write_valid; 
   wire returni_or_shift_decode; 
   wire returni_or_shift_valid; 
   wire arith_or_logical_decode; 
   wire arith_or_logical_valid; 

   LUT4 reg_decode_lut(.I0(active_interrupt), .I1(instruction[13]), .I2(instruction[14]), .I3(instruction[17]), .O(reg_instruction_decode)); 
   // synthesis translate_off
   defparam reg_decode_lut.INIT = 16'h0155;
   // synthesis translate_on
   // synthesis attribute INIT of reg_decode_lut "0155"
   FD reg_pipeline_bit (.D(reg_instruction_decode), .Q(register_write_valid), .C(clk)); 

   LUT2 reg_pulse_timing_lut(.I0(T_state), .I1(register_write_valid), .O(register_enable)); 
   // synthesis translate_off
   defparam reg_pulse_timing_lut.INIT = 4'h8;
   // synthesis translate_on
   // synthesis attribute INIT of reg_pulse_timing_lut "8"

   LUT4 flag_decode1_lut(.I0(instruction[13]), .I1(instruction[14]), .I2(instruction[15]), .I3(instruction[17]), .O(arith_or_logical_decode)); 
   // synthesis translate_off
   defparam flag_decode1_lut.INIT = 16'h00FE;
   // synthesis translate_on
   // synthesis attribute INIT of flag_decode1_lut "00FE" 
   FD flag_pipeline1_bit (.D(arith_or_logical_decode), .Q(arith_or_logical_valid), .C(clk)); 

   LUT3 flag_decode2_lut(.I0(instruction[15]), .I1(instruction[16]), .I2(instruction[17]), .O(returni_or_shift_decode)); 
   // synthesis translate_off
   defparam flag_decode2_lut.INIT = 8'h20;
   // synthesis translate_on
   // synthesis attribute INIT of flag_decode2_lut "20"
   FD flag_pipeline2_bit (.D(returni_or_shift_decode), .Q(returni_or_shift_valid), .C(clk)); 

   LUT3 flag_pulse_timing_lut(.I0(T_state), .I1(arith_or_logical_valid), .I2(returni_or_shift_valid), .O(flag_enable)); 
   // synthesis translate_off
   defparam flag_pulse_timing_lut.INIT = 8'hA8;
   // synthesis translate_on
   // synthesis attribute INIT of flag_pulse_timing_lut "A8"
endmodule

//----------------------------------------------------------------------------------
//
// Definition of an 8-bit shift/rotate process
//	
// This function uses 11 LUTs.
// The function contains an output pipeline register using 9 FDs.
//
// Operation
//
// The input operand is shifted by one bit left or right.
// The bit which falls out of the end is passed to the carry_out.
// The bit shifted in is determined by the select bits
//
//     code1    code0         Bit injected
//
//       0        0          carry_in           
//       0        1          msb of input_operand 
//       1        0          lsb of operand 
//       1        1          inject_bit 
//
//
module shift_rotate_process (operand, carry_in, inject_bit, shift_right, code1, code0, Y, carry_out, clk);

   input[7:0] operand; 
   input carry_in; 
   input inject_bit; 
   input shift_right; 
   input code1; 
   input code0; 
   output[7:0] Y; 
   wire[7:0] Y;
   output carry_out; 
   wire carry_out;
   input clk; 

   wire[7:0] mux_output; 
   wire shift_in_bit; 
   wire carry_bit; 

   mux4_LUTS_MUXF5 input_bit_mux4 (.D3(inject_bit), .D2(operand[0]), .D1(operand[7]), .D0(carry_in), .sel1(code1), .sel0(code0), .Y(shift_in_bit)); 
   mux2_LUT bit_mux2_0 (.D1(operand[0 + 1]), .D0(shift_in_bit), .sel(shift_right), .Y(mux_output[0]));

   FD pipeline_bit_0 (.D(mux_output[0]), .Q(Y[0]), .C(clk));

   mux2_LUT bit_mux2_xhdl1_1 (.D1(operand[1 + 1]), .D0(operand[1 - 1]), .sel(shift_right), .Y(mux_output[1]));

   FD pipeline_bit_1 (.D(mux_output[1]), .Q(Y[1]), .C(clk));

   mux2_LUT bit_mux2_xhdl1_2 (.D1(operand[2 + 1]), .D0(operand[2 - 1]), .sel(shift_right), .Y(mux_output[2]));

   FD pipeline_bit_2 (.D(mux_output[2]), .Q(Y[2]), .C(clk));

   mux2_LUT bit_mux2_xhdl1_3 (.D1(operand[3 + 1]), .D0(operand[3 - 1]), .sel(shift_right), .Y(mux_output[3]));

   FD pipeline_bit_3 (.D(mux_output[3]), .Q(Y[3]), .C(clk));

   mux2_LUT bit_mux2_xhdl1_4 (.D1(operand[4 + 1]), .D0(operand[4 - 1]), .sel(shift_right), .Y(mux_output[4]));

   FD pipeline_bit_4 (.D(mux_output[4]), .Q(Y[4]), .C(clk));

   mux2_LUT bit_mux2_xhdl1_5 (.D1(operand[5 + 1]), .D0(operand[5 - 1]), .sel(shift_right), .Y(mux_output[5]));

   FD pipeline_bit_5 (.D(mux_output[5]), .Q(Y[5]), .C(clk));

   mux2_LUT bit_mux2_xhdl1_6 (.D1(operand[6 + 1]), .D0(operand[6 - 1]), .sel(shift_right), .Y(mux_output[6]));

   FD pipeline_bit_6 (.D(mux_output[6]), .Q(Y[6]), .C(clk));

   mux2_LUT bit_mux2_xhdl2_7 (.D1(shift_in_bit), .D0(operand[7 - 1]), .sel(shift_right), .Y(mux_output[7]));

   FD pipeline_bit_7 (.D(mux_output[7]), .Q(Y[7]), .C(clk)); 
   mux2_LUT carry_out_mux2 (.D1(operand[0]), .D0(operand[7]), .sel(shift_right), .Y(carry_bit)); 
   FD pipeline_bit_xhdl3 (.D(carry_bit), .Q(carry_out), .C(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of a 5-bit special counter for stack pointer
//	
// This 5-bit counter is a relatively complex function
//
// The counter is able to increment and decrement.
// It can also hold current value during an active interrupt
// and decrement by two during a RETURN or RETURNI.
//
// Counter 5 LUTs, 5 FDREs, and associated carry logic.
// Decoding lgic requires a futher 3 LUTs.
// Total size 4 slices.
//
//
module stack_counter (instruction17, instruction16, instruction14, instruction13, instruction12, T_state, flag_condition_met, active_interrupt, reset, stack_count, clk);

   input instruction17; 
   input instruction16; 
   input instruction14; 
   input instruction13; 
   input instruction12; 
   input T_state; 
   input flag_condition_met; 
   input active_interrupt; 
   input reset; 
   output[4:0] stack_count; 
   wire[4:0] stack_count;
   input clk; 

   wire not_interrupt; 
   wire[4:0] count_value; 
   wire[4:0] next_count; 
   wire[3:0] count_carry; 
   wire[4:0] half_count; 
   wire call_type; 
   wire valid_to_move; 
   wire push_or_pop_type; 

   INV invert_interrupt (.I(active_interrupt), .O(not_interrupt)); 

   LUT2 valid_move_lut(.I0(instruction12), .I1(flag_condition_met), .O(valid_to_move)); 
   // synthesis translate_off
   defparam valid_move_lut.INIT = 4'hD;
   // synthesis translate_on
   // synthesis attribute INIT of valid_move_lut "D"

   LUT4 call_lut(.I0(instruction13), .I1(instruction14), .I2(instruction16), .I3(instruction17), .O(call_type)); 
   // synthesis translate_off
   defparam call_lut.INIT = 16'h8000;
   // synthesis translate_on
   // synthesis attribute INIT of call_lut "8000"

   LUT4 push_pop_lut(.I0(instruction13), .I1(instruction14), .I2(instruction16), .I3(instruction17), .O(push_or_pop_type)); 
   // synthesis translate_off
   defparam push_pop_lut.INIT = 16'h8C00;
   // synthesis translate_on
   // synthesis attribute INIT of push_pop_lut "8C00"
   FDRE register_bit_0 (.D(next_count[0]), .Q(count_value[0]), .R(reset), .CE(not_interrupt), .C(clk));

   LUT4 count_lut_0(.I0(count_value[0]), .I1(T_state), .I2(valid_to_move), .I3(push_or_pop_type), .O(half_count[0])); 
   // synthesis translate_off
   defparam count_lut_0.INIT = 16'h6555;
   // synthesis translate_on
   // synthesis attribute INIT of count_lut_0 "6555"
   
   MUXCY count_muxcy_0 (.DI(count_value[0]), .CI(1'b0), .S(half_count[0]), .O(count_carry[0]));

   XORCY count_xor_0 (.LI(half_count[0]), .CI(1'b0), .O(next_count[0]));

   FDRE register_bit_1 (.D(next_count[1]), .Q(count_value[1]), .R(reset), .CE(not_interrupt), .C(clk));

   LUT4 count_lut_xhdl1_1(.I0(count_value[1]), .I1(T_state), .I2(valid_to_move), .I3(call_type), .O(half_count[1])); 
   // synthesis translate_off
   defparam count_lut_xhdl1_1.INIT = 16'hA999;
   // synthesis translate_on
   // synthesis attribute INIT of count_lut_xhdl1_1 "A999"
   MUXCY count_muxcy_xhdl2_1 (.DI(count_value[1]), .CI(count_carry[1 - 1]), .S(half_count[1]), .O(count_carry[1]));

   XORCY count_xor_xhdl3_1 (.LI(half_count[1]), .CI(count_carry[1 - 1]), .O(next_count[1]));

   FDRE register_bit_2 (.D(next_count[2]), .Q(count_value[2]), .R(reset), .CE(not_interrupt), .C(clk));

   LUT4 count_lut_xhdl1_2(.I0(count_value[2]), .I1(T_state), .I2(valid_to_move), .I3(call_type), .O(half_count[2])); 
   // synthesis translate_off
   defparam count_lut_xhdl1_2.INIT = 16'hA999;
   // synthesis translate_on
   // synthesis attribute INIT of count_lut_xhdl1_2 "A999"
   MUXCY count_muxcy_xhdl2_2 (.DI(count_value[2]), .CI(count_carry[2 - 1]), .S(half_count[2]), .O(count_carry[2]));

   XORCY count_xor_xhdl3_2 (.LI(half_count[2]), .CI(count_carry[2 - 1]), .O(next_count[2]));

   FDRE register_bit_3 (.D(next_count[3]), .Q(count_value[3]), .R(reset), .CE(not_interrupt), .C(clk));

   LUT4 count_lut_xhdl1_3(.I0(count_value[3]), .I1(T_state), .I2(valid_to_move), .I3(call_type), .O(half_count[3])); 
   // synthesis translate_off
   defparam count_lut_xhdl1_3.INIT = 16'hA999;
   // synthesis translate_on
   // synthesis attribute INIT of count_lut_xhdl1_3 "A999"
   MUXCY count_muxcy_xhdl2_3 (.DI(count_value[3]), .CI(count_carry[3 - 1]), .S(half_count[3]), .O(count_carry[3]));

   XORCY count_xor_xhdl3_3 (.LI(half_count[3]), .CI(count_carry[3 - 1]), .O(next_count[3]));

   FDRE register_bit_4 (.D(next_count[4]), .Q(count_value[4]), .R(reset), .CE(not_interrupt), .C(clk));

   LUT4 count_lut_xhdl4_4(.I0(count_value[4]), .I1(T_state), .I2(valid_to_move), .I3(call_type), .O(half_count[4])); 
   // synthesis translate_off
   defparam count_lut_xhdl4_4.INIT = 16'hA999;
   // synthesis translate_on
   // synthesis attribute INIT of count_lut_xhdl4_4 "A999"
   XORCY count_xor_xhdl5_4 (.LI(half_count[4]), .CI(count_carry[4 - 1]), .O(next_count[4])); 
   assign stack_count = count_value ;
endmodule

//----------------------------------------------------------------------------------
//
// Definition of RAM for stack
//	 
// This is a 32 location single port RAM of 10-bits to support the address range
// of the program counter. The ouput is registered and the write enable is active low.
//
// Ecah bit requires 1 slice, and therefore the 10-bit RAM requires 10-slices.
//
//
module stack_ram (Din, Dout, addr, write_bar, clk);

   input[9:0] Din; 
   output[9:0] Dout; 
   wire[9:0] Dout;
   input[4:0] addr; 
   input write_bar; 
   input clk; 

   wire[9:0] ram_out; 
   wire write_enable; 

   INV invert_enable (.I(write_bar), .O(write_enable)); 

   RAM32X1S stack_ram_bit_0(.D(Din[0]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[0])); 
   // synthesis translate_off
   defparam stack_ram_bit_0.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_0 "00000000"
   FD stack_ram_flop_0 (.D(ram_out[0]), .Q(Dout[0]), .C(clk));

   RAM32X1S stack_ram_bit_1(.D(Din[1]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[1])); 
   // synthesis translate_off
   defparam stack_ram_bit_1.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_1 "00000000"
   FD stack_ram_flop_1 (.D(ram_out[1]), .Q(Dout[1]), .C(clk));

   RAM32X1S stack_ram_bit_2(.D(Din[2]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[2])); 
   // synthesis translate_off
   defparam stack_ram_bit_2.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_2 "00000000"
   FD stack_ram_flop_2 (.D(ram_out[2]), .Q(Dout[2]), .C(clk));

   RAM32X1S stack_ram_bit_3(.D(Din[3]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[3])); 
   // synthesis translate_off
   defparam stack_ram_bit_3.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_3 "00000000"
   FD stack_ram_flop_3 (.D(ram_out[3]), .Q(Dout[3]), .C(clk));

   RAM32X1S stack_ram_bit_4(.D(Din[4]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[4])); 
   // synthesis translate_off
   defparam stack_ram_bit_4.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_4 "00000000"
   FD stack_ram_flop_4 (.D(ram_out[4]), .Q(Dout[4]), .C(clk));

   RAM32X1S stack_ram_bit_5(.D(Din[5]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[5])); 
   // synthesis translate_off
   defparam stack_ram_bit_5.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_5 "00000000"
   FD stack_ram_flop_5 (.D(ram_out[5]), .Q(Dout[5]), .C(clk));

   RAM32X1S stack_ram_bit_6(.D(Din[6]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[6])); 
   // synthesis translate_off
   defparam stack_ram_bit_6.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_6 "00000000"
   FD stack_ram_flop_6 (.D(ram_out[6]), .Q(Dout[6]), .C(clk));

   RAM32X1S stack_ram_bit_7(.D(Din[7]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[7])); 
   // synthesis translate_off
   defparam stack_ram_bit_7.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_7 "00000000"
   FD stack_ram_flop_7 (.D(ram_out[7]), .Q(Dout[7]), .C(clk));

   RAM32X1S stack_ram_bit_8(.D(Din[8]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[8])); 
   // synthesis translate_off
   defparam stack_ram_bit_8.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_8 "00000000"
   FD stack_ram_flop_8 (.D(ram_out[8]), .Q(Dout[8]), .C(clk));

   RAM32X1S stack_ram_bit_9(.D(Din[9]), .WE(write_enable), .WCLK(clk), .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]), .A4(addr[4]), .O(ram_out[9])); 
   // synthesis translate_off
   defparam stack_ram_bit_9.INIT = 32'h00000000;
   // synthesis translate_on
   // synthesis attribute INIT of stack_ram_bit_9 "00000000"
   FD stack_ram_flop_9 (.D(ram_out[9]), .Q(Dout[9]), .C(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
// Definition of basic time T-state and clean reset
//	
// This function forms the basic 2 cycle T-state control used by the processor.
// It also forms a clean synchronous reset pulse that is long enough to ensure 
// correct operation at start up and following a reset input.
// It uses 1 LUT, an FDR, and 2 FDS pimatives.
//
//
module T_state_and_Reset (reset_input, internal_reset, T_state, clk);

   input reset_input; 
   output internal_reset; 
   wire internal_reset;
   output T_state; 
   wire T_state;
   input clk; 

   wire reset_delay1; 
   wire reset_delay2; 
   wire not_T_state; 
   wire internal_T_state; 


   FDS delay_flop1 (.D(1'b0), .Q(reset_delay1), .S(reset_input), .C(clk)); 
   FDS delay_flop2 (.D(reset_delay1), .Q(reset_delay2), .S(reset_input), .C(clk)); 

   LUT1 invert_lut(.I0(internal_T_state), .O(not_T_state));
   // synthesis translate_off
   defparam invert_lut.INIT = 4'h1;
   // synthesis translate_on    
   // synthesis attribute INIT of invert_lut "1"
   FDR toggle_flop (.D(not_T_state), .Q(internal_T_state), .R(reset_delay2), .C(clk)); 
   assign T_state = internal_T_state ;
   assign internal_reset = reset_delay2 ;
endmodule

//----------------------------------------------------------------------------------
//
// Definition of the Zero Flag 
//	
// The ZERO value is detected using 2 LUTs and associated carry logic to 
// form a wired NOR gate. A further LUT selects the source for the ZERO flag
// which is stored in an FDRE.
//
//
module zero_flag_logic (data, instruction17, instruction14, shadow_zero, reset, flag_enable, zero_flag, clk);

   input[7:0] data; 
   input instruction17; 
   input instruction14; 
   input shadow_zero; 
   input reset; 
   input flag_enable; 
   output zero_flag; 
   wire zero_flag;
   input clk; 

   wire lower_zero; 
   wire upper_zero; 
   wire lower_zero_carry; 
   wire data_zero; 
   wire next_zero_flag; 

   LUT4 lower_zero_lut(.I0(data[0]), .I1(data[1]), .I2(data[2]), .I3(data[3]), .O(lower_zero)); 
   // synthesis translate_off
   defparam lower_zero_lut.INIT = 16'h0001;
   // synthesis translate_on
   // synthesis attribute INIT of lower_zero_lut "0001"

   LUT4 upper_zero_lut(.I0(data[4]), .I1(data[5]), .I2(data[6]), .I3(data[7]), .O(upper_zero)); 
   // synthesis translate_off
   defparam upper_zero_lut.INIT = 16'h0001;
   // synthesis translate_on
   // synthesis attribute INIT of upper_zero_lut "0001"

   MUXCY lower_carry (.DI(1'b0), .CI(1'b1), .S(lower_zero), .O(lower_zero_carry)); 
   MUXCY upper_carry (.DI(1'b0), .CI(lower_zero_carry), .S(upper_zero), .O(data_zero)); 

   LUT4 select_lut(.I0(instruction14), .I1(instruction17), .I2(data_zero), .I3(shadow_zero), .O(next_zero_flag)); 
   // synthesis translate_off
   defparam select_lut.INIT = 16'hF870;
   // synthesis translate_on
   // synthesis attribute INIT of select_lut "F870"
   FDRE zero_flag_flop (.D(next_zero_flag), .Q(zero_flag), .CE(flag_enable), .R(reset), .C(clk)); 
endmodule

//----------------------------------------------------------------------------------
//
