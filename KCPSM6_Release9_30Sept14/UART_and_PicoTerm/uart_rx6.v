//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2011, Xilinx, Inc.
// This file contains confidential and proprietary information of Xilinx, Inc. and is
// protected under U.S. and international copyright and other intellectual property laws.
///////////////////////////////////////////////////////////////////////////////////////////
//
// Disclaimer:
// This disclaimer is not a license and does not grant any rights to the materials
// distributed herewith. Except as otherwise provided in a valid license issued to
// you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
// MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
// DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
// INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
// OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
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
// (individually and collectively, "Critical Applications"). Customer assumes the
// sole risk and liability of any use of Xilinx products in Critical Applications,
// subject only to applicable laws and regulations governing limitations on product
// liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// UART Receiver with integral 16 byte FIFO buffer
//
// 8 bit, no parity, 1 stop bit
//
// This module was made for use with Spartan-6 Generation Devices and is also ideally 
// suited for use with Virtex-6 and 7-Series devices.
//
// Version 1 - 8th July 2011. 
//             Derived from uart_rx6.vhd Version 1 (31st March 2011) by Nick Sawyer.
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
// These ensure predictable synthesis results and maximise the density of the 
// implementation. The Unisim Library is used to define Xilinx primitives. It is also 
// used during simulation. 
// The source can be viewed at %XILINX%\verilog\src\unisims\
// 
///////////////////////////////////////////////////////////////////////////////////////////
//
`timescale 1 ps / 1ps

module uart_rx6 (
input        serial_in,
input        en_16_x_baud,
output [7:0] data_out,
input        buffer_read,
output       buffer_data_present,
output       buffer_half_full,
output       buffer_full,
input        buffer_reset,
input        clk );
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// wires used in uart_rx6
//
///////////////////////////////////////////////////////////////////////////////////////////
//
wire [3:0] pointer_value;
wire [3:0] pointer;
wire       en_pointer;
wire       zero;
wire       full_int;
wire       data_present_value;
wire       data_present_int;
wire       sample_value;
wire       sample;
wire       sample_dly_value;
wire       sample_dly;
wire       stop_bit_value;
wire       stop_bit;
wire [7:0] data_value;
wire [7:0] data;
wire       run_value;
wire       run;
wire       start_bit_value;
wire       start_bit;
wire [3:0] div_value;
wire [3:0] div;
wire       div_carry;
wire       sample_input_value;
wire       sample_input;
wire       buffer_write_value;
wire       buffer_write;
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Start of uart_rx6 circuit description
//
///////////////////////////////////////////////////////////////////////////////////////////
//      
genvar i;

// SRL16E data storage

generate
for (i = 0 ; i <= 7 ; i = i+1)
begin : data_width_loop

(* HBLKNM = "uart_rx6_5" *)
SRL16E #(
        .INIT   (16'h0000))
storage_srl (   
        .D      (data[i]),
        .CE     (buffer_write),
        .CLK    (clk),
        .A0     (pointer[0]),
        .A1     (pointer[1]),
        .A2     (pointer[2]),
        .A3     (pointer[3]),
        .Q      (data_out[i]));

end //generate data_width_loop;
endgenerate

(* HBLKNM = "uart_rx6_1" *)
LUT6 #(
        .INIT    (64'hFF00FE00FF80FF00))
pointer3_lut( 
        .I0     (pointer[0]),
        .I1     (pointer[1]),
        .I2     (pointer[2]),
        .I3     (pointer[3]),
        .I4     (buffer_write),
        .I5     (buffer_read),
        .O      (pointer_value[3]));                      

(* HBLKNM = "uart_rx6_1" *)
FDR pointer3_flop(  
        .D      (pointer_value[3]),
        .Q      (pointer[3]),
        .R      (buffer_reset),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_1" *)
LUT6 #(
        .INIT    (64'hF0F0E1E0F878F0F0))
pointer2_lut( 
        .I0     (pointer[0]),
        .I1     (pointer[1]),
        .I2     (pointer[2]),
        .I3     (pointer[3]),
        .I4     (buffer_write),
        .I5     (buffer_read),
        .O      (pointer_value[2])); 
        
(* HBLKNM = "uart_rx6_1" *)
FDR pointer2_flop(  
        .D      (pointer_value[2]),
        .Q      (pointer[2]),
        .R      (buffer_reset),
        .C      (clk));

(* HBLKNM = "uart_rx6_1" *)
LUT6_2 #(
        .INIT    (64'hCC9060CCAA5050AA))
pointer01_lut( 
        .I0     (pointer[0]),
        .I1     (pointer[1]),
        .I2     (en_pointer),
        .I3     (buffer_write),
        .I4     (buffer_read),
        .I5     (1'b1),
        .O5     (pointer_value[0]),
        .O6     (pointer_value[1])); 
        
(* HBLKNM = "uart_rx6_1" *)
FDR pointer1_flop(  
        .D      (pointer_value[1]),
        .Q      (pointer[1]),
        .R      (buffer_reset),
        .C      (clk));

(* HBLKNM = "uart_rx6_1" *)
FDR pointer0_flop(  
        .D      (pointer_value[0]),
        .Q      (pointer[0]),
        .R      (buffer_reset),
        .C      (clk));

(* HBLKNM = "uart_rx6_1" *)
LUT6_2 #(
        .INIT    (64'hF4FCF4FC040004C0))
data_present_lut( 
        .I0     (zero),
        .I1     (data_present_int),
        .I2     (buffer_write),
        .I3     (buffer_read),
        .I4     (full_int),
        .I5     (1'b1),
        .O5     (en_pointer),
        .O6     (data_present_value)); 
        
(* HBLKNM = "uart_rx6_1" *)
FDR data_present_flop(  
        .D      (data_present_value),
        .Q      (data_present_int),
        .R      (buffer_reset),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_3" *)
LUT6_2 #(
        .INIT    (64'h0001000080000000))
full_lut( 
        .I0     (pointer[0]),
        .I1     (pointer[1]),
        .I2     (pointer[2]),
        .I3     (pointer[3]),
        .I4     (1'b1),
        .I5     (1'b1),
        .O5     (full_int),
        .O6     (zero)); 

(* HBLKNM = "uart_rx6_4" *)
LUT6_2 #(
        .INIT    (64'hCCF00000AACC0000))
sample_lut( 
        .I0     (serial_in),
        .I1     (sample),
        .I2     (sample_dly),
        .I3     (en_16_x_baud),
        .I4     (1'b1),
        .I5     (1'b1),
        .O5     (sample_value),
        .O6     (sample_dly_value)); 
        
(* HBLKNM = "uart_rx6_4" *)
FD sample_flop(  
        .D      (sample_value),
        .Q      (sample),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_4" *)
FD sample_dly_flop(  
        .D      (sample_dly_value),
        .Q      (sample_dly),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_4" *)
LUT6_2 #(
        .INIT    (64'hCAFFCAFF0000C0C0))
stop_bit_lut( 
        .I0     (stop_bit),
        .I1     (sample),
        .I2     (sample_input),
        .I3     (run),
        .I4     (data[0]),
        .I5     (1'b1),
        .O5     (buffer_write_value),
        .O6     (stop_bit_value)); 
        
(* HBLKNM = "uart_rx6_4" *)
FD buffer_write_flop(  
        .D      (buffer_write_value),
        .Q      (buffer_write),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_4" *)
FD stop_bit_flop(  
        .D      (stop_bit_value),
        .Q      (stop_bit),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
LUT6_2 #(
        .INIT    (64'hF0CCFFFFCCAAFFFF))
data01_lut( 
        .I0     (data[0]),
        .I1     (data[1]),
        .I2     (data[2]),
        .I3     (sample_input),
        .I4     (run),
        .I5     (1'b1),
        .O5     (data_value[0]),
        .O6     (data_value[1])); 
        
(* HBLKNM = "uart_rx6_2" *)
FD data0_flop(  
        .D      (data_value[0]),
        .Q      (data[0]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
FD data1_flop(  
        .D      (data_value[1]),
        .Q      (data[1]),
        .C      (clk)); 

(* HBLKNM = "uart_rx6_2" *)
LUT6_2 #(
        .INIT    (64'hF0CCFFFFCCAAFFFF))
data23_lut( 
        .I0     (data[2]),
        .I1     (data[3]),
        .I2     (data[4]),
        .I3     (sample_input),
        .I4     (run),
        .I5     (1'b1),
        .O5     (data_value[2]),
        .O6     (data_value[3])); 
        
(* HBLKNM = "uart_rx6_2" *)
FD data2_flop(  
        .D      (data_value[2]),
        .Q      (data[2]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
FD data3_flop(  
        .D      (data_value[3]),
        .Q      (data[3]),
        .C      (clk)); 

(* HBLKNM = "uart_rx6_2" *)
LUT6_2 #(
        .INIT    (64'hF0CCFFFFCCAAFFFF))
data45_lut( 
        .I0     (data[4]),
        .I1     (data[5]),
        .I2     (data[6]),
        .I3     (sample_input),
        .I4     (run),
        .I5     (1'b1),
        .O5     (data_value[4]),
        .O6     (data_value[5])); 
        
(* HBLKNM = "uart_rx6_2" *)
FD data4_flop(  
        .D      (data_value[4]),
        .Q      (data[4]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
FD data5_flop(  
        .D      (data_value[5]),
        .Q      (data[5]),
        .C      (clk)); 

(* HBLKNM = "uart_rx6_2" *)
LUT6_2 #(
        .INIT    (64'hF0CCFFFFCCAAFFFF))
data67_lut( 
        .I0     (data[6]),
        .I1     (data[7]),
        .I2     (stop_bit),
        .I3     (sample_input),
        .I4     (run),
        .I5     (1'b1),
        .O5     (data_value[6]),
        .O6     (data_value[7])); 
        
(* HBLKNM = "uart_rx6_2" *)
FD data6_flop(  
        .D      (data_value[6]),
        .Q      (data[6]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_2" *)
FD data7_flop(  
        .D      (data_value[7]),
        .Q      (data[7]),
        .C      (clk)); 
        
(* HBLKNM = "uart_rx6_4" *)
LUT6 #(
        .INIT    (64'h2F2FAFAF0000FF00))
run_lut( 
        .I0     (data[0]),
        .I1     (start_bit),
        .I2     (sample_input),
        .I3     (sample_dly),
        .I4     (sample),
        .I5     (run),
        .O      (run_value)); 
        
(* HBLKNM = "uart_rx6_4" *)
FD run_flop(  
        .D      (run_value),
        .Q      (run),
        .C      (clk));  
        
(* HBLKNM = "uart_rx6_4" *)
LUT6 #(
        .INIT    (64'h222200F000000000))
start_bit_lut( 
        .I0     (start_bit),
        .I1     (sample_input),
        .I2     (sample_dly),
        .I3     (sample),
        .I4     (run),
        .I5     (1'b1),
        .O      (start_bit_value)); 
        
(* HBLKNM = "uart_rx6_4" *)
FD start_bit_flop(  
        .D      (start_bit_value),
        .Q      (start_bit),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_3" *)
LUT6_2 #(
        .INIT    (64'h6C0000005A000000))
div01_lut( 
        .I0     (div[0]),
        .I1     (div[1]),
        .I2     (en_16_x_baud),
        .I3     (run),
        .I4     (1'b1),
        .I5     (1'b1),
        .O5     (div_value[0]),
        .O6     (div_value[1])); 
        
(* HBLKNM = "uart_rx6_3" *)
FD div0_flop(  
        .D      (div_value[0]),
        .Q      (div[0]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_3" *)
FD div1_flop(  
        .D      (div_value[1]),
        .Q      (div[1]),
        .C      (clk)); 
        
(* HBLKNM = "uart_rx6_3" *)
LUT6_2 #(
        .INIT    (64'h6CCC00005AAA0000))
div23_lut( 
        .I0     (div[2]),
        .I1     (div[3]),
        .I2     (div_carry),
        .I3     (en_16_x_baud),
        .I4     (run),
        .I5     (1'b1),
        .O5     (div_value[2]),
        .O6     (div_value[3])); 
        
(* HBLKNM = "uart_rx6_3" *)
FD div2_flop(  
        .D      (div_value[2]),
        .Q      (div[2]),
        .C      (clk));
        
(* HBLKNM = "uart_rx6_3" *)
FD div3_flop(  
        .D      (div_value[3]),
        .Q      (div[3]),
        .C      (clk)); 
        
(* HBLKNM = "uart_rx6_3" *)
LUT6_2 #(
        .INIT    (64'h0080000088888888))
sample_input_lut( 
        .I0     (div[0]),
        .I1     (div[1]),
        .I2     (div[2]),
        .I3     (div[3]),
        .I4     (en_16_x_baud),
        .I5     (1'b1),
        .O5     (div_carry),
        .O6     (sample_input_value)); 
        
(* HBLKNM = "uart_rx6_3" *)
FD sample_input_flop(  
        .D      (sample_input_value),
        .Q      (sample_input),
        .C      (clk)); 
        
// assign internal wires to outputs

assign buffer_full = full_int;  
assign buffer_half_full = pointer[3];  
assign buffer_data_present = data_present_int;

endmodule

///////////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE uart_rx6.v
//
///////////////////////////////////////////////////////////////////////////////////////////


