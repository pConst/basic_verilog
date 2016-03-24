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
// UART Transmitter with integral 16 byte FIFO buffer
//
// 8 bit, no parity, 1 stop bit
//
// This module was made for use with Spartan-6 Generation Devices and is also ideally 
// suited for use with Virtex-6 and 7-Series devices.
//
// Version 1 - 8th July 2011. 
//             Derived from uart_tx6.vhd Version 1 (31st March 2011) by Nick Sawyer.
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

module uart_tx6 (
input [7:0] data_in,
input       buffer_write,
input       buffer_reset,
input       en_16_x_baud,
output      serial_out,
output      buffer_data_present,
output      buffer_half_full,
output      buffer_full,
input       clk );
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// wires used in uart_tx6
//
///////////////////////////////////////////////////////////////////////////////////////////
//
wire [7:0] store_data;
wire [7:0] data;
wire [3:0] pointer_value;
wire [3:0] pointer;
wire       en_pointer;
wire       zero;
wire       full_int;
wire       data_present_value;
wire       data_present_int;
wire [3:0] sm_value;
wire [3:0] sm;
wire [3:0] div_value;
wire [3:0] div;
wire       lsb_data;
wire       msb_data;
wire       last_bit;
wire       serial_data;
wire       next_value;
wire       next_bit;
wire       buffer_read_value;
wire       buffer_read;
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Start of uart_tx6 circuit description
//
///////////////////////////////////////////////////////////////////////////////////////////
//	
genvar i;

  // SRL16E data storage

generate
for (i = 0 ; i <= 7 ; i = i+1)
begin : data_width_loop

(* HBLKNM = "uart_tx6_5" *)
SRL16E #(
	.INIT   (16'h0000))
storage_srl (   
	.D  	(data_in[i]),
        .CE 	(buffer_write),
        .CLK	(clk),
        .A0 	(pointer[0]),
        .A1 	(pointer[1]),
        .A2 	(pointer[2]),
        .A3 	(pointer[3]),
        .Q  	(store_data[i]));

(* HBLKNM = "uart_tx6_5" *)
FD storage_flop(  
	.D	(store_data[i]),
        .Q	(data[i]),
        .C	(clk));

end //generate data_width_loop;
endgenerate
 
(* HBLKNM = "uart_tx6_1" *)
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

(* HBLKNM = "uart_tx6_1" *)
FDR pointer3_flop(  
	.D	(pointer_value[3]),
	.Q	(pointer[3]),
	.R	(buffer_reset),
	.C	(clk));

(* HBLKNM = "uart_tx6_1" *)
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
	
(* HBLKNM = "uart_tx6_1" *)
FDR pointer2_flop(  
	.D	(pointer_value[2]),
	.Q	(pointer[2]),
	.R	(buffer_reset),
	.C	(clk));

(* HBLKNM = "uart_tx6_1" *)
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
	
(* HBLKNM = "uart_tx6_1" *)
FDR pointer1_flop(  
	.D	(pointer_value[1]),
	.Q	(pointer[1]),
	.R	(buffer_reset),
	.C	(clk));

(* HBLKNM = "uart_tx6_1" *)
FDR pointer0_flop(  
	.D	(pointer_value[0]),
	.Q	(pointer[0]),
	.R	(buffer_reset),
	.C	(clk));	

(* HBLKNM = "uart_tx6_1" *)
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
	
(* HBLKNM = "uart_tx6_1" *)
FDR data_present_flop(  
	.D	(data_present_value),
	.Q	(data_present_int),
	.R	(buffer_reset),
	.C	(clk));
	
(* HBLKNM = "uart_tx6_4" *)
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

(* HBLKNM = "uart_tx6_4" *)
LUT6 #(
	.INIT    (64'hFF00F0F0CCCCAAAA))
lsb_data_lut( 
	.I0     (data[0]),
	.I1     (data[1]),
	.I2     (data[2]),
	.I3     (data[3]),
	.I4     (sm[0]),
	.I5     (sm[1]),
	.O      (lsb_data)); 
                   
(* HBLKNM = "uart_tx6_4" *)
LUT6 #(
	.INIT    (64'hFF00F0F0CCCCAAAA))
msb_data_lut( 
	.I0     (data[4]),
	.I1     (data[5]),
	.I2     (data[6]),
	.I3     (data[7]),
	.I4     (sm[0]),
	.I5     (sm[1]),
	.O      (msb_data)); 

(* HBLKNM = "uart_tx6_4" *)
LUT6_2 #(
	.INIT    (64'hCFAACC0F0FFFFFFF))
serial_lut( 
	.I0     (lsb_data),
	.I1     (msb_data),
	.I2     (sm[1]),
	.I3     (sm[2]),
	.I4     (sm[3]),
	.I5     (1'b1),
	.O5     (last_bit),
	.O6     (serial_data));                     

(* HBLKNM = "uart_tx6_4" *)
FD serial_flop(  
	.D 	(serial_data),
	.Q 	(serial_out),
	.C 	(clk));

(* HBLKNM = "uart_tx6_2" *)
LUT6 #(
        .INIT    (64'h85500000AAAAAAAA))
sm0_lut( 
        .I0     (sm[0]),
        .I1     (sm[1]),
        .I2     (sm[2]),
        .I3     (sm[3]),
        .I4     (data_present_int),
        .I5     (next_bit),
        .O      (sm_value[0])); 
        
(* HBLKNM = "uart_tx6_2" *)
FD sm0_flop(  
        .D      (sm_value[0]),
        .Q      (sm[0]),
        .C      (clk));                   

(* HBLKNM = "uart_tx6_2" *)
LUT6 #(
	.INIT    (64'h26610000CCCCCCCC))
sm1_lut( 
	.I0     (sm[0]),
	.I1     (sm[1]),
	.I2     (sm[2]),
	.I3     (sm[3]),
	.I4     (data_present_int),
	.I5     (next_bit),
	.O      (sm_value[1])); 
	
(* HBLKNM = "uart_tx6_2" *)
FD sm1_flop(  
	.D 	(sm_value[1]),
	.Q 	(sm[1]),
	.C 	(clk)); 
	
(* HBLKNM = "uart_tx6_2" *)
LUT6 #(
	.INIT    (64'h88700000F0F0F0F0))
sm2_lut( 
	.I0     (sm[0]),
	.I1     (sm[1]),
	.I2     (sm[2]),
	.I3     (sm[3]),
	.I4     (data_present_int),
	.I5     (next_bit),
	.O      (sm_value[2])); 
	
(* HBLKNM = "uart_tx6_2" *)
FD sm2_flop(  
	.D 	(sm_value[2]),
	.Q 	(sm[2]),
	.C 	(clk)); 

(* HBLKNM = "uart_tx6_2" *)
LUT6 #(
	.INIT    (64'h87440000FF00FF00))
sm3_lut( 
	.I0     (sm[0]),
	.I1     (sm[1]),
	.I2     (sm[2]),
	.I3     (sm[3]),
	.I4     (data_present_int),
	.I5     (next_bit),
	.O      (sm_value[3])); 
	
(* HBLKNM = "uart_tx6_2" *)
FD sm3_flop(  
	.D 	(sm_value[3]),
	.Q 	(sm[3]),
	.C 	(clk)); 

(* HBLKNM = "uart_tx6_3" *)
LUT6_2 #(
	.INIT    (64'h6C0000005A000000))
div01_lut( 
	.I0     (div[0]),
	.I1     (div[1]),
	.I2     (en_16_x_baud),
	.I3     (1'b1),
	.I4     (1'b1),
	.I5     (1'b1),
	.O5     (div_value[0]),
	.O6     (div_value[1]));                     

(* HBLKNM = "uart_tx6_3" *)
FD div0_flop(  
	.D 	(div_value[0]),
	.Q 	(div[0]),
	.C 	(clk));
	
(* HBLKNM = "uart_tx6_3" *)
FD div1_flop(  
	.D 	(div_value[1]),
	.Q 	(div[1]),
	.C 	(clk));

(* HBLKNM = "uart_tx6_3" *)
LUT6_2 #(
	.INIT    (64'h7F80FF007878F0F0))
div23_lut( 
	.I0     (div[0]),
	.I1     (div[1]),
	.I2     (div[2]),
	.I3     (div[3]),
	.I4     (en_16_x_baud),
	.I5     (1'b1),
	.O5     (div_value[2]),
	.O6     (div_value[3]));                     

(* HBLKNM = "uart_tx6_3" *)
FD div2_flop(  
	.D 	(div_value[2]),
	.Q 	(div[2]),
	.C 	(clk));
	
(* HBLKNM = "uart_tx6_3" *)
FD div3_flop(  
	.D 	(div_value[3]),
	.Q 	(div[3]),
	.C 	(clk));
	
(* HBLKNM = "uart_tx6_3" *)
LUT6_2 #(
	.INIT    (64'h0000000080000000))
next_lut( 
	.I0     (div[0]),
	.I1     (div[1]),
	.I2     (div[2]),
	.I3     (div[3]),
	.I4     (en_16_x_baud),
	.I5     (last_bit),
	.O5     (next_value),
	.O6     (buffer_read_value));                     

(* HBLKNM = "uart_tx6_3" *)
FD next_flop(  
	.D 	(next_value),
	.Q 	(next_bit),
	.C 	(clk));
	
(* HBLKNM = "uart_tx6_3" *)
FD read_flop(  
	.D 	(buffer_read_value),
	.Q 	(buffer_read),
	.C 	(clk));

// assign internal wires to outputs

assign buffer_full = full_int;  
assign buffer_half_full = pointer[3];  
assign buffer_data_present = data_present_int;

endmodule

///////////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE uart_tx6.v
//
///////////////////////////////////////////////////////////////////////////////////////////


