//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2010-2012, Xilinx, Inc.
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

ROM_form.v

Production template for a 4K KCPSM6 program in a Spartan-6 device using 
4 x RAMB18WER. It should be noted that a 4K program is not such a natural fit in
a Spartan-6 device and the implementation also requires a small amount of logic 
(9 x LUT6_2 and an FD) resulting in slightly lower performance compared with 
memories for 1K and 2K programs.

Ken Chapman (Xilinx Ltd)

26th November 2012

This is a verilog template file for the KCPSM6 assembler.

This verilog file is not valid as input directly into a synthesis or a simulation tool.
The assembler will read this template and insert the information required to complete
the definition of program ROM and write it out to a new '.v' file that is ready for 
synthesis and simulation.

This template can be modified to define alternative memory definitions. However, you are 
responsible for ensuring the template is correct as the assembler does not perform any 
checking of the verilog.

The assembler identifies all text enclosed by {} characters, and replaces these
character strings. All templates should include these {} character strings for 
the assembler to work correctly. 

The next line is used to determine where the template actually starts.
{begin template}
//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2010-2012, Xilinx, Inc.
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
//
// Production definition of a 4K program for KCPSM6 in a Spartan-6 device using 
// 4 x RAMB18WER. It should be noted that a 4K program is not such a natural fit in
// a Spartan-6 device and the implementation also requires a small amount of logic 
// (9 x LUT6_2 and an FD) resulting in slightly lower performance compared with 
// memories for 1K and 2K programs.
//
//
// Program defined by '{psmname}.psm'.
//
// Generated by KCPSM6 Assembler: {timestamp}. 
//
// Assembler used ROM_form template: 26th November 2012
//
module {name} (
input  [11:0] address,
output [17:0] instruction,
input         enable,
input         clk);
//
//
wire [13:0] address_a;
wire        pipe_a11;
wire [35:0] data_in_a;
wire [35:0] data_out_a_ll;
wire [35:0] data_out_a_lh;
wire [35:0] data_out_a_hl;
wire [35:0] data_out_a_hh;
wire [13:0] address_b;
wire [35:0] data_in_b_ll;
wire [35:0] data_out_b_ll;
wire [35:0] data_in_b_lh;
wire [35:0] data_out_b_lh;
wire [35:0] data_in_b_hl;
wire [35:0] data_out_b_hl;
wire [35:0] data_in_b_hh;
wire [35:0] data_out_b_hh;
wire        enable_b;
wire        clk_b;
wire  [3:0] we_b;
//
//
assign address_a = {address[10:0], 3'b000};
assign data_in_a = 36'b000000000000000000000000000000000000;
//
FD s6_a11_flop ( .D      (address[11]),
                 .Q      (pipe_a11),
                 .C      (clk));
//
LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
 s6_4k_mux0_lut( .I0     (data_out_a_ll[0]),
                 .I1     (data_out_a_hl[0]),
                 .I2     (data_out_a_ll[1]),
                 .I3     (data_out_a_hl[1]),
                 .I4     (pipe_a11),
                 .I5     (1'b1),
                 .O5     (instruction[0]),
                 .O6     (instruction[1]));
//
LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
 s6_4k_mux2_lut( .I0     (data_out_a_ll[2]),
                 .I1     (data_out_a_hl[2]),
                 .I2     (data_out_a_ll[3]),
                 .I3     (data_out_a_hl[3]),
                 .I4     (pipe_a11),
                 .I5     (1'b1),
                 .O5     (instruction[2]),
                 .O6     (instruction[3]));
//
LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
 s6_4k_mux4_lut( .I0     (data_out_a_ll[4]),
                 .I1     (data_out_a_hl[4]),
                 .I2     (data_out_a_ll[5]),
                 .I3     (data_out_a_hl[5]),
                 .I4     (pipe_a11),
                 .I5     (1'b1),
                 .O5     (instruction[4]),
                 .O6     (instruction[5]));
//
LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
 s6_4k_mux6_lut( .I0     (data_out_a_ll[6]),
                 .I1     (data_out_a_hl[6]),
                 .I2     (data_out_a_ll[7]),
                 .I3     (data_out_a_hl[7]),
                 .I4     (pipe_a11),
                 .I5     (1'b1),
                 .O5     (instruction[6]),
                 .O6     (instruction[7]));
//
LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
 s6_4k_mux8_lut( .I0     (data_out_a_ll[32]),
                 .I1     (data_out_a_hl[32]),
                 .I2     (data_out_a_lh[0]),
                 .I3     (data_out_a_hh[0]),
                 .I4     (pipe_a11),
                 .I5     (1'b1),
                 .O5     (instruction[8]),
                 .O6     (instruction[9]));
//
LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
s6_4k_mux10_lut( .I0     (data_out_a_lh[1]),
                 .I1     (data_out_a_hh[1]),
                 .I2     (data_out_a_lh[2]),
                 .I3     (data_out_a_hh[2]),
                 .I4     (pipe_a11),
                 .I5     (1'b1),
                 .O5     (instruction[10]),
                 .O6     (instruction[11]));
//
LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
s6_4k_mux12_lut( .I0     (data_out_a_lh[3]),
                 .I1     (data_out_a_hh[3]),
                 .I2     (data_out_a_lh[4]),
                 .I3     (data_out_a_hh[4]),
                 .I4     (pipe_a11),
                 .I5     (1'b1),
                 .O5     (instruction[12]),
                 .O6     (instruction[13]));
//
LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
s6_4k_mux14_lut( .I0     (data_out_a_lh[5]),
                 .I1     (data_out_a_hh[5]),
                 .I2     (data_out_a_lh[6]),
                 .I3     (data_out_a_hh[6]),
                 .I4     (pipe_a11),
                 .I5     (1'b1),
                 .O5     (instruction[14]),
                 .O6     (instruction[15]));
//
LUT6_2 # (       .INIT   (64'hFF00F0F0CCCCAAAA))
s6_4k_mux16_lut( .I0     (data_out_a_lh[7]),
                 .I1     (data_out_a_hh[7]),
                 .I2     (data_out_a_lh[32]),
                 .I3     (data_out_a_hh[32]),
                 .I4     (pipe_a11),
                 .I5     (1'b1),
                 .O5     (instruction[16]),
                 .O6     (instruction[17]));
//
assign address_b = 14'b00000000000000;
assign data_in_b_ll = {3'h0, data_out_b_ll[32], 24'b000000000000000000000000, data_out_b_ll[7:0]};
assign data_in_b_lh = {3'h0, data_out_b_lh[32], 24'b000000000000000000000000, data_out_b_lh[7:0]};
assign data_in_b_hl = {3'h0, data_out_b_hl[32], 24'b000000000000000000000000, data_out_b_hl[7:0]};
assign data_in_b_hh = {3'h0, data_out_b_hh[32], 24'b000000000000000000000000, data_out_b_hh[7:0]};
assign enable_b = 1'b0;
assign we_b = 4'b0000;
assign clk_b = 1'b0;
//
RAMB16BWER # ( .DATA_WIDTH_A        (9),
               .DOA_REG             (0),
               .EN_RSTRAM_A         ("FALSE"),
               .INIT_A              (32'h000000000),
               .RST_PRIORITY_A      ("CE"),
               .SRVAL_A             (32'h000000000),
               .WRITE_MODE_A        ("WRITE_FIRST"),
               .DATA_WIDTH_B        (9),
               .DOB_REG             (0),
               .EN_RSTRAM_B         ("FALSE"),
               .INIT_B              (32'h000000000),
               .RST_PRIORITY_B      ("CE"),
               .SRVAL_B             (32'h000000000),
               .WRITE_MODE_B        ("WRITE_FIRST"),
               .RSTTYPE             ("SYNC"),
               .INIT_FILE           ("NONE"),
               .SIM_COLLISION_CHECK ("ALL"),
               .SIM_DEVICE          ("SPARTAN6"),
               .INIT_00             (256'h{[8:0]_INIT_00}),
               .INIT_01             (256'h{[8:0]_INIT_01}),
               .INIT_02             (256'h{[8:0]_INIT_02}),
               .INIT_03             (256'h{[8:0]_INIT_03}),
               .INIT_04             (256'h{[8:0]_INIT_04}),
               .INIT_05             (256'h{[8:0]_INIT_05}),
               .INIT_06             (256'h{[8:0]_INIT_06}),
               .INIT_07             (256'h{[8:0]_INIT_07}),
               .INIT_08             (256'h{[8:0]_INIT_08}),
               .INIT_09             (256'h{[8:0]_INIT_09}),
               .INIT_0A             (256'h{[8:0]_INIT_0A}),
               .INIT_0B             (256'h{[8:0]_INIT_0B}),
               .INIT_0C             (256'h{[8:0]_INIT_0C}),
               .INIT_0D             (256'h{[8:0]_INIT_0D}),
               .INIT_0E             (256'h{[8:0]_INIT_0E}),
               .INIT_0F             (256'h{[8:0]_INIT_0F}),
               .INIT_10             (256'h{[8:0]_INIT_10}),
               .INIT_11             (256'h{[8:0]_INIT_11}),
               .INIT_12             (256'h{[8:0]_INIT_12}),
               .INIT_13             (256'h{[8:0]_INIT_13}),
               .INIT_14             (256'h{[8:0]_INIT_14}),
               .INIT_15             (256'h{[8:0]_INIT_15}),
               .INIT_16             (256'h{[8:0]_INIT_16}),
               .INIT_17             (256'h{[8:0]_INIT_17}),
               .INIT_18             (256'h{[8:0]_INIT_18}),
               .INIT_19             (256'h{[8:0]_INIT_19}),
               .INIT_1A             (256'h{[8:0]_INIT_1A}),
               .INIT_1B             (256'h{[8:0]_INIT_1B}),
               .INIT_1C             (256'h{[8:0]_INIT_1C}),
               .INIT_1D             (256'h{[8:0]_INIT_1D}),
               .INIT_1E             (256'h{[8:0]_INIT_1E}),
               .INIT_1F             (256'h{[8:0]_INIT_1F}),
               .INIT_20             (256'h{[8:0]_INIT_20}),
               .INIT_21             (256'h{[8:0]_INIT_21}),
               .INIT_22             (256'h{[8:0]_INIT_22}),
               .INIT_23             (256'h{[8:0]_INIT_23}),
               .INIT_24             (256'h{[8:0]_INIT_24}),
               .INIT_25             (256'h{[8:0]_INIT_25}),
               .INIT_26             (256'h{[8:0]_INIT_26}),
               .INIT_27             (256'h{[8:0]_INIT_27}),
               .INIT_28             (256'h{[8:0]_INIT_28}),
               .INIT_29             (256'h{[8:0]_INIT_29}),
               .INIT_2A             (256'h{[8:0]_INIT_2A}),
               .INIT_2B             (256'h{[8:0]_INIT_2B}),
               .INIT_2C             (256'h{[8:0]_INIT_2C}),
               .INIT_2D             (256'h{[8:0]_INIT_2D}),
               .INIT_2E             (256'h{[8:0]_INIT_2E}),
               .INIT_2F             (256'h{[8:0]_INIT_2F}),
               .INIT_30             (256'h{[8:0]_INIT_30}),
               .INIT_31             (256'h{[8:0]_INIT_31}),
               .INIT_32             (256'h{[8:0]_INIT_32}),
               .INIT_33             (256'h{[8:0]_INIT_33}),
               .INIT_34             (256'h{[8:0]_INIT_34}),
               .INIT_35             (256'h{[8:0]_INIT_35}),
               .INIT_36             (256'h{[8:0]_INIT_36}),
               .INIT_37             (256'h{[8:0]_INIT_37}),
               .INIT_38             (256'h{[8:0]_INIT_38}),
               .INIT_39             (256'h{[8:0]_INIT_39}),
               .INIT_3A             (256'h{[8:0]_INIT_3A}),
               .INIT_3B             (256'h{[8:0]_INIT_3B}),
               .INIT_3C             (256'h{[8:0]_INIT_3C}),
               .INIT_3D             (256'h{[8:0]_INIT_3D}),
               .INIT_3E             (256'h{[8:0]_INIT_3E}),
               .INIT_3F             (256'h{[8:0]_INIT_3F}),
               .INITP_00            (256'h{[8:0]_INITP_00}),
               .INITP_01            (256'h{[8:0]_INITP_01}),
               .INITP_02            (256'h{[8:0]_INITP_02}),
               .INITP_03            (256'h{[8:0]_INITP_03}),
               .INITP_04            (256'h{[8:0]_INITP_04}),
               .INITP_05            (256'h{[8:0]_INITP_05}),
               .INITP_06            (256'h{[8:0]_INITP_06}),
               .INITP_07            (256'h{[8:0]_INITP_07}))
kcpsm6_rom_ll( .ADDRA               (address_a),
               .ENA                 (enable),
               .CLKA                (clk),
               .DOA                 (data_out_a_ll[31:0]),
               .DOPA                (data_out_a_ll[35:32]), 
               .DIA                 (data_in_a[31:0]),
               .DIPA                (data_in_a[35:32]), 
               .WEA                 (4'h0),
               .REGCEA              (1'b0),
               .RSTA                (1'b0),
               .ADDRB               (address_b),
               .ENB                 (enable_b),
               .CLKB                (clk_b),
               .DOB                 (data_out_b_ll[31:0]),
               .DOPB                (data_out_b_ll[35:32]), 
               .DIB                 (data_in_b_ll[31:0]),
               .DIPB                (data_in_b_ll[35:32]), 
               .WEB                 (we_b),
               .REGCEB              (1'b0),
               .RSTB                (1'b0));
//
RAMB16BWER # ( .DATA_WIDTH_A        (9),
               .DOA_REG             (0),
               .EN_RSTRAM_A         ("FALSE"),
               .INIT_A              (32'h000000000),
               .RST_PRIORITY_A      ("CE"),
               .SRVAL_A             (32'h000000000),
               .WRITE_MODE_A        ("WRITE_FIRST"),
               .DATA_WIDTH_B        (9),
               .DOB_REG             (0),
               .EN_RSTRAM_B         ("FALSE"),
               .INIT_B              (32'h000000000),
               .RST_PRIORITY_B      ("CE"),
               .SRVAL_B             (32'h000000000),
               .WRITE_MODE_B        ("WRITE_FIRST"),
               .RSTTYPE             ("SYNC"),
               .INIT_FILE           ("NONE"),
               .SIM_COLLISION_CHECK ("ALL"),
               .SIM_DEVICE          ("SPARTAN6"),
               .INIT_00             (256'h{[17:9]_INIT_00}),
               .INIT_01             (256'h{[17:9]_INIT_01}),
               .INIT_02             (256'h{[17:9]_INIT_02}),
               .INIT_03             (256'h{[17:9]_INIT_03}),
               .INIT_04             (256'h{[17:9]_INIT_04}),
               .INIT_05             (256'h{[17:9]_INIT_05}),
               .INIT_06             (256'h{[17:9]_INIT_06}),
               .INIT_07             (256'h{[17:9]_INIT_07}),
               .INIT_08             (256'h{[17:9]_INIT_08}),
               .INIT_09             (256'h{[17:9]_INIT_09}),
               .INIT_0A             (256'h{[17:9]_INIT_0A}),
               .INIT_0B             (256'h{[17:9]_INIT_0B}),
               .INIT_0C             (256'h{[17:9]_INIT_0C}),
               .INIT_0D             (256'h{[17:9]_INIT_0D}),
               .INIT_0E             (256'h{[17:9]_INIT_0E}),
               .INIT_0F             (256'h{[17:9]_INIT_0F}),
               .INIT_10             (256'h{[17:9]_INIT_10}),
               .INIT_11             (256'h{[17:9]_INIT_11}),
               .INIT_12             (256'h{[17:9]_INIT_12}),
               .INIT_13             (256'h{[17:9]_INIT_13}),
               .INIT_14             (256'h{[17:9]_INIT_14}),
               .INIT_15             (256'h{[17:9]_INIT_15}),
               .INIT_16             (256'h{[17:9]_INIT_16}),
               .INIT_17             (256'h{[17:9]_INIT_17}),
               .INIT_18             (256'h{[17:9]_INIT_18}),
               .INIT_19             (256'h{[17:9]_INIT_19}),
               .INIT_1A             (256'h{[17:9]_INIT_1A}),
               .INIT_1B             (256'h{[17:9]_INIT_1B}),
               .INIT_1C             (256'h{[17:9]_INIT_1C}),
               .INIT_1D             (256'h{[17:9]_INIT_1D}),
               .INIT_1E             (256'h{[17:9]_INIT_1E}),
               .INIT_1F             (256'h{[17:9]_INIT_1F}),
               .INIT_20             (256'h{[17:9]_INIT_20}),
               .INIT_21             (256'h{[17:9]_INIT_21}),
               .INIT_22             (256'h{[17:9]_INIT_22}),
               .INIT_23             (256'h{[17:9]_INIT_23}),
               .INIT_24             (256'h{[17:9]_INIT_24}),
               .INIT_25             (256'h{[17:9]_INIT_25}),
               .INIT_26             (256'h{[17:9]_INIT_26}),
               .INIT_27             (256'h{[17:9]_INIT_27}),
               .INIT_28             (256'h{[17:9]_INIT_28}),
               .INIT_29             (256'h{[17:9]_INIT_29}),
               .INIT_2A             (256'h{[17:9]_INIT_2A}),
               .INIT_2B             (256'h{[17:9]_INIT_2B}),
               .INIT_2C             (256'h{[17:9]_INIT_2C}),
               .INIT_2D             (256'h{[17:9]_INIT_2D}),
               .INIT_2E             (256'h{[17:9]_INIT_2E}),
               .INIT_2F             (256'h{[17:9]_INIT_2F}),
               .INIT_30             (256'h{[17:9]_INIT_30}),
               .INIT_31             (256'h{[17:9]_INIT_31}),
               .INIT_32             (256'h{[17:9]_INIT_32}),
               .INIT_33             (256'h{[17:9]_INIT_33}),
               .INIT_34             (256'h{[17:9]_INIT_34}),
               .INIT_35             (256'h{[17:9]_INIT_35}),
               .INIT_36             (256'h{[17:9]_INIT_36}),
               .INIT_37             (256'h{[17:9]_INIT_37}),
               .INIT_38             (256'h{[17:9]_INIT_38}),
               .INIT_39             (256'h{[17:9]_INIT_39}),
               .INIT_3A             (256'h{[17:9]_INIT_3A}),
               .INIT_3B             (256'h{[17:9]_INIT_3B}),
               .INIT_3C             (256'h{[17:9]_INIT_3C}),
               .INIT_3D             (256'h{[17:9]_INIT_3D}),
               .INIT_3E             (256'h{[17:9]_INIT_3E}),
               .INIT_3F             (256'h{[17:9]_INIT_3F}),
               .INITP_00            (256'h{[17:9]_INITP_00}),
               .INITP_01            (256'h{[17:9]_INITP_01}),
               .INITP_02            (256'h{[17:9]_INITP_02}),
               .INITP_03            (256'h{[17:9]_INITP_03}),
               .INITP_04            (256'h{[17:9]_INITP_04}),
               .INITP_05            (256'h{[17:9]_INITP_05}),
               .INITP_06            (256'h{[17:9]_INITP_06}),
               .INITP_07            (256'h{[17:9]_INITP_07}))
kcpsm6_rom_lh( .ADDRA               (address_a),
               .ENA                 (enable),
               .CLKA                (clk),
               .DOA                 (data_out_a_lh[31:0]),
               .DOPA                (data_out_a_lh[35:32]), 
               .DIA                 (data_in_a[31:0]),
               .DIPA                (data_in_a[35:32]), 
               .WEA                 (4'h0),
               .REGCEA              (1'b0),
               .RSTA                (1'b0),
               .ADDRB               (address_b),
               .ENB                 (enable_b),
               .CLKB                (clk_b),
               .DOB                 (data_out_b_lh[31:0]),
               .DOPB                (data_out_b_lh[35:32]), 
               .DIB                 (data_in_b_lh[31:0]),
               .DIPB                (data_in_b_lh[35:32]), 
               .WEB                 (we_b),
               .REGCEB              (1'b0),
               .RSTB                (1'b0));
//
RAMB16BWER # ( .DATA_WIDTH_A        (9),
               .DOA_REG             (0),
               .EN_RSTRAM_A         ("FALSE"),
               .INIT_A              (32'h000000000),
               .RST_PRIORITY_A      ("CE"),
               .SRVAL_A             (32'h000000000),
               .WRITE_MODE_A        ("WRITE_FIRST"),
               .DATA_WIDTH_B        (9),
               .DOB_REG             (0),
               .EN_RSTRAM_B         ("FALSE"),
               .INIT_B              (32'h000000000),
               .RST_PRIORITY_B      ("CE"),
               .SRVAL_B             (32'h000000000),
               .WRITE_MODE_B        ("WRITE_FIRST"),
               .RSTTYPE             ("SYNC"),
               .INIT_FILE           ("NONE"),
               .SIM_COLLISION_CHECK ("ALL"),
               .SIM_DEVICE          ("SPARTAN6"),
               .INIT_00             (256'h{[8:0]_INIT_40}),
               .INIT_01             (256'h{[8:0]_INIT_41}),
               .INIT_02             (256'h{[8:0]_INIT_42}),
               .INIT_03             (256'h{[8:0]_INIT_43}),
               .INIT_04             (256'h{[8:0]_INIT_44}),
               .INIT_05             (256'h{[8:0]_INIT_45}),
               .INIT_06             (256'h{[8:0]_INIT_46}),
               .INIT_07             (256'h{[8:0]_INIT_47}),
               .INIT_08             (256'h{[8:0]_INIT_48}),
               .INIT_09             (256'h{[8:0]_INIT_49}),
               .INIT_0A             (256'h{[8:0]_INIT_4A}),
               .INIT_0B             (256'h{[8:0]_INIT_4B}),
               .INIT_0C             (256'h{[8:0]_INIT_4C}),
               .INIT_0D             (256'h{[8:0]_INIT_4D}),
               .INIT_0E             (256'h{[8:0]_INIT_4E}),
               .INIT_0F             (256'h{[8:0]_INIT_4F}),
               .INIT_10             (256'h{[8:0]_INIT_50}),
               .INIT_11             (256'h{[8:0]_INIT_51}),
               .INIT_12             (256'h{[8:0]_INIT_52}),
               .INIT_13             (256'h{[8:0]_INIT_53}),
               .INIT_14             (256'h{[8:0]_INIT_54}),
               .INIT_15             (256'h{[8:0]_INIT_55}),
               .INIT_16             (256'h{[8:0]_INIT_56}),
               .INIT_17             (256'h{[8:0]_INIT_57}),
               .INIT_18             (256'h{[8:0]_INIT_58}),
               .INIT_19             (256'h{[8:0]_INIT_59}),
               .INIT_1A             (256'h{[8:0]_INIT_5A}),
               .INIT_1B             (256'h{[8:0]_INIT_5B}),
               .INIT_1C             (256'h{[8:0]_INIT_5C}),
               .INIT_1D             (256'h{[8:0]_INIT_5D}),
               .INIT_1E             (256'h{[8:0]_INIT_5E}),
               .INIT_1F             (256'h{[8:0]_INIT_5F}),
               .INIT_20             (256'h{[8:0]_INIT_60}),
               .INIT_21             (256'h{[8:0]_INIT_61}),
               .INIT_22             (256'h{[8:0]_INIT_62}),
               .INIT_23             (256'h{[8:0]_INIT_63}),
               .INIT_24             (256'h{[8:0]_INIT_64}),
               .INIT_25             (256'h{[8:0]_INIT_65}),
               .INIT_26             (256'h{[8:0]_INIT_66}),
               .INIT_27             (256'h{[8:0]_INIT_67}),
               .INIT_28             (256'h{[8:0]_INIT_68}),
               .INIT_29             (256'h{[8:0]_INIT_69}),
               .INIT_2A             (256'h{[8:0]_INIT_6A}),
               .INIT_2B             (256'h{[8:0]_INIT_6B}),
               .INIT_2C             (256'h{[8:0]_INIT_6C}),
               .INIT_2D             (256'h{[8:0]_INIT_6D}),
               .INIT_2E             (256'h{[8:0]_INIT_6E}),
               .INIT_2F             (256'h{[8:0]_INIT_6F}),
               .INIT_30             (256'h{[8:0]_INIT_70}),
               .INIT_31             (256'h{[8:0]_INIT_71}),
               .INIT_32             (256'h{[8:0]_INIT_72}),
               .INIT_33             (256'h{[8:0]_INIT_73}),
               .INIT_34             (256'h{[8:0]_INIT_74}),
               .INIT_35             (256'h{[8:0]_INIT_75}),
               .INIT_36             (256'h{[8:0]_INIT_76}),
               .INIT_37             (256'h{[8:0]_INIT_77}),
               .INIT_38             (256'h{[8:0]_INIT_78}),
               .INIT_39             (256'h{[8:0]_INIT_79}),
               .INIT_3A             (256'h{[8:0]_INIT_7A}),
               .INIT_3B             (256'h{[8:0]_INIT_7B}),
               .INIT_3C             (256'h{[8:0]_INIT_7C}),
               .INIT_3D             (256'h{[8:0]_INIT_7D}),
               .INIT_3E             (256'h{[8:0]_INIT_7E}),
               .INIT_3F             (256'h{[8:0]_INIT_7F}),
               .INITP_00            (256'h{[8:0]_INITP_08}),
               .INITP_01            (256'h{[8:0]_INITP_09}),
               .INITP_02            (256'h{[8:0]_INITP_0A}),
               .INITP_03            (256'h{[8:0]_INITP_0B}),
               .INITP_04            (256'h{[8:0]_INITP_0C}),
               .INITP_05            (256'h{[8:0]_INITP_0D}),
               .INITP_06            (256'h{[8:0]_INITP_0E}),
               .INITP_07            (256'h{[8:0]_INITP_0F}))
kcpsm6_rom_hl( .ADDRA               (address_a),
               .ENA                 (enable),
               .CLKA                (clk),
               .DOA                 (data_out_a_hl[31:0]),
               .DOPA                (data_out_a_hl[35:32]), 
               .DIA                 (data_in_a[31:0]),
               .DIPA                (data_in_a[35:32]), 
               .WEA                 (4'h0),
               .REGCEA              (1'b0),
               .RSTA                (1'b0),
               .ADDRB               (address_b),
               .ENB                 (enable_b),
               .CLKB                (clk_b),
               .DOB                 (data_out_b_hl[31:0]),
               .DOPB                (data_out_b_hl[35:32]), 
               .DIB                 (data_in_b_hl[31:0]),
               .DIPB                (data_in_b_hl[35:32]), 
               .WEB                 (we_b),
               .REGCEB              (1'b0),
               .RSTB                (1'b0));
//
RAMB16BWER # ( .DATA_WIDTH_A        (9),
               .DOA_REG             (0),
               .EN_RSTRAM_A         ("FALSE"),
               .INIT_A              (32'h000000000),
               .RST_PRIORITY_A      ("CE"),
               .SRVAL_A             (32'h000000000),
               .WRITE_MODE_A        ("WRITE_FIRST"),
               .DATA_WIDTH_B        (9),
               .DOB_REG             (0),
               .EN_RSTRAM_B         ("FALSE"),
               .INIT_B              (32'h000000000),
               .RST_PRIORITY_B      ("CE"),
               .SRVAL_B             (32'h000000000),
               .WRITE_MODE_B        ("WRITE_FIRST"),
               .RSTTYPE             ("SYNC"),
               .INIT_FILE           ("NONE"),
               .SIM_COLLISION_CHECK ("ALL"),
               .SIM_DEVICE          ("SPARTAN6"),
               .INIT_00             (256'h{[17:9]_INIT_40}),
               .INIT_01             (256'h{[17:9]_INIT_41}),
               .INIT_02             (256'h{[17:9]_INIT_42}),
               .INIT_03             (256'h{[17:9]_INIT_43}),
               .INIT_04             (256'h{[17:9]_INIT_44}),
               .INIT_05             (256'h{[17:9]_INIT_45}),
               .INIT_06             (256'h{[17:9]_INIT_46}),
               .INIT_07             (256'h{[17:9]_INIT_47}),
               .INIT_08             (256'h{[17:9]_INIT_48}),
               .INIT_09             (256'h{[17:9]_INIT_49}),
               .INIT_0A             (256'h{[17:9]_INIT_4A}),
               .INIT_0B             (256'h{[17:9]_INIT_4B}),
               .INIT_0C             (256'h{[17:9]_INIT_4C}),
               .INIT_0D             (256'h{[17:9]_INIT_4D}),
               .INIT_0E             (256'h{[17:9]_INIT_4E}),
               .INIT_0F             (256'h{[17:9]_INIT_4F}),
               .INIT_10             (256'h{[17:9]_INIT_50}),
               .INIT_11             (256'h{[17:9]_INIT_51}),
               .INIT_12             (256'h{[17:9]_INIT_52}),
               .INIT_13             (256'h{[17:9]_INIT_53}),
               .INIT_14             (256'h{[17:9]_INIT_54}),
               .INIT_15             (256'h{[17:9]_INIT_55}),
               .INIT_16             (256'h{[17:9]_INIT_56}),
               .INIT_17             (256'h{[17:9]_INIT_57}),
               .INIT_18             (256'h{[17:9]_INIT_58}),
               .INIT_19             (256'h{[17:9]_INIT_59}),
               .INIT_1A             (256'h{[17:9]_INIT_5A}),
               .INIT_1B             (256'h{[17:9]_INIT_5B}),
               .INIT_1C             (256'h{[17:9]_INIT_5C}),
               .INIT_1D             (256'h{[17:9]_INIT_5D}),
               .INIT_1E             (256'h{[17:9]_INIT_5E}),
               .INIT_1F             (256'h{[17:9]_INIT_5F}),
               .INIT_20             (256'h{[17:9]_INIT_60}),
               .INIT_21             (256'h{[17:9]_INIT_61}),
               .INIT_22             (256'h{[17:9]_INIT_62}),
               .INIT_23             (256'h{[17:9]_INIT_63}),
               .INIT_24             (256'h{[17:9]_INIT_64}),
               .INIT_25             (256'h{[17:9]_INIT_65}),
               .INIT_26             (256'h{[17:9]_INIT_66}),
               .INIT_27             (256'h{[17:9]_INIT_67}),
               .INIT_28             (256'h{[17:9]_INIT_68}),
               .INIT_29             (256'h{[17:9]_INIT_69}),
               .INIT_2A             (256'h{[17:9]_INIT_6A}),
               .INIT_2B             (256'h{[17:9]_INIT_6B}),
               .INIT_2C             (256'h{[17:9]_INIT_6C}),
               .INIT_2D             (256'h{[17:9]_INIT_6D}),
               .INIT_2E             (256'h{[17:9]_INIT_6E}),
               .INIT_2F             (256'h{[17:9]_INIT_6F}),
               .INIT_30             (256'h{[17:9]_INIT_70}),
               .INIT_31             (256'h{[17:9]_INIT_71}),
               .INIT_32             (256'h{[17:9]_INIT_72}),
               .INIT_33             (256'h{[17:9]_INIT_73}),
               .INIT_34             (256'h{[17:9]_INIT_74}),
               .INIT_35             (256'h{[17:9]_INIT_75}),
               .INIT_36             (256'h{[17:9]_INIT_76}),
               .INIT_37             (256'h{[17:9]_INIT_77}),
               .INIT_38             (256'h{[17:9]_INIT_78}),
               .INIT_39             (256'h{[17:9]_INIT_79}),
               .INIT_3A             (256'h{[17:9]_INIT_7A}),
               .INIT_3B             (256'h{[17:9]_INIT_7B}),
               .INIT_3C             (256'h{[17:9]_INIT_7C}),
               .INIT_3D             (256'h{[17:9]_INIT_7D}),
               .INIT_3E             (256'h{[17:9]_INIT_7E}),
               .INIT_3F             (256'h{[17:9]_INIT_7F}),
               .INITP_00            (256'h{[17:9]_INITP_08}),
               .INITP_01            (256'h{[17:9]_INITP_09}),
               .INITP_02            (256'h{[17:9]_INITP_0A}),
               .INITP_03            (256'h{[17:9]_INITP_0B}),
               .INITP_04            (256'h{[17:9]_INITP_0C}),
               .INITP_05            (256'h{[17:9]_INITP_0D}),
               .INITP_06            (256'h{[17:9]_INITP_0E}),
               .INITP_07            (256'h{[17:9]_INITP_0F}))
kcpsm6_rom_hh( .ADDRA               (address_a),
               .ENA                 (enable),
               .CLKA                (clk),
               .DOA                 (data_out_a_hh[31:0]),
               .DOPA                (data_out_a_hh[35:32]), 
               .DIA                 (data_in_a[31:0]),
               .DIPA                (data_in_a[35:32]), 
               .WEA                 (4'h0),
               .REGCEA              (1'b0),
               .RSTA                (1'b0),
               .ADDRB               (address_b),
               .ENB                 (enable_b),
               .CLKB                (clk_b),
               .DOB                 (data_out_b_hh[31:0]),
               .DOPB                (data_out_b_hh[35:32]), 
               .DIB                 (data_in_b_hh[31:0]),
               .DIPB                (data_in_b_hh[35:32]), 
               .WEB                 (we_b),
               .REGCEB              (1'b0),
               .RSTB                (1'b0));
//
endmodule
//
////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE {name}.v
//
////////////////////////////////////////////////////////////////////////////////////
