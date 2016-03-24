//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2010-2011, Xilinx, Inc.
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

Production template for a 1K program for KCPSM6 in a Spartan-6 device using a 
RAMB18WER primitive.

Nick Sawyer (Xilinx Ltd)
Ken Chapman (Xilinx Ltd)

5th August 2011

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
// Copyright © 2010-2011, Xilinx, Inc.
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
// Production definition of a 1K program for KCPSM6 in a Spartan-6 device using a 
// RAMB18WER primitive.
//
// Note: The complete 12-bit address bus is connected to KCPSM6 to facilitate future code 
//       expansion with minimum changes being required to the hardware description. 
//       Only the lower 10-bits of the address are actually used for the 1K address range
//       000 to 3FF hex.  
//
// Program defined by '{psmname}.psm'.
//
// Generated by KCPSM6 Assembler: {timestamp}. 
//
//
module {name} (
input  [11:0] address,
output [17:0] instruction,
input         enable,
input         clk);
//
//
wire [13:0] address_a;
wire [35:0] data_in_a;
wire [35:0] data_out_a;
wire [35:0] data_out_b;
wire [13:0] address_b;
wire [35:0] data_in_b;
wire        enable_b;
wire        clk_b;
wire [3:0]  we_b;
//
assign address_a = {address[9:0], 4'b0000};
assign instruction = {data_out_a[33:32], data_out_a[15:0]};
assign data_in_a = {34'b0000000000000000000000000000000000, address[11:10]};
//
assign address_b = 14'b00000000000000;
assign data_in_b = {2'h0,  data_out_b[33:32], 16'b0000000000000000, data_out_b[15:0]};
assign enable_b = 1'b0;
assign we_b = 4'h0;
assign clk_b = 1'b0;
//
//
// 
RAMB16BWER # ( .DATA_WIDTH_A        (18),
               .DOA_REG             (0),
               .EN_RSTRAM_A         ("FALSE"),
               .INIT_A              (32'h000000000),
               .RST_PRIORITY_A      ("CE"),
               .SRVAL_A             (32'h000000000),
               .WRITE_MODE_A        ("WRITE_FIRST"),
               .DATA_WIDTH_B        (18),
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
               .INIT_00             (256'h{INIT_00}),
               .INIT_01             (256'h{INIT_01}),
               .INIT_02             (256'h{INIT_02}),
               .INIT_03             (256'h{INIT_03}),
               .INIT_04             (256'h{INIT_04}),
               .INIT_05             (256'h{INIT_05}),
               .INIT_06             (256'h{INIT_06}),
               .INIT_07             (256'h{INIT_07}),
               .INIT_08             (256'h{INIT_08}),
               .INIT_09             (256'h{INIT_09}),
               .INIT_0A             (256'h{INIT_0A}),
               .INIT_0B             (256'h{INIT_0B}),
               .INIT_0C             (256'h{INIT_0C}),
               .INIT_0D             (256'h{INIT_0D}),
               .INIT_0E             (256'h{INIT_0E}),
               .INIT_0F             (256'h{INIT_0F}),
               .INIT_10             (256'h{INIT_10}),
               .INIT_11             (256'h{INIT_11}),
               .INIT_12             (256'h{INIT_12}),
               .INIT_13             (256'h{INIT_13}),
               .INIT_14             (256'h{INIT_14}),
               .INIT_15             (256'h{INIT_15}),
               .INIT_16             (256'h{INIT_16}),
               .INIT_17             (256'h{INIT_17}),
               .INIT_18             (256'h{INIT_18}),
               .INIT_19             (256'h{INIT_19}),
               .INIT_1A             (256'h{INIT_1A}),
               .INIT_1B             (256'h{INIT_1B}),
               .INIT_1C             (256'h{INIT_1C}),
               .INIT_1D             (256'h{INIT_1D}),
               .INIT_1E             (256'h{INIT_1E}),
               .INIT_1F             (256'h{INIT_1F}),
               .INIT_20             (256'h{INIT_20}),
               .INIT_21             (256'h{INIT_21}),
               .INIT_22             (256'h{INIT_22}),
               .INIT_23             (256'h{INIT_23}),
               .INIT_24             (256'h{INIT_24}),
               .INIT_25             (256'h{INIT_25}),
               .INIT_26             (256'h{INIT_26}),
               .INIT_27             (256'h{INIT_27}),
               .INIT_28             (256'h{INIT_28}),
               .INIT_29             (256'h{INIT_29}),
               .INIT_2A             (256'h{INIT_2A}),
               .INIT_2B             (256'h{INIT_2B}),
               .INIT_2C             (256'h{INIT_2C}),
               .INIT_2D             (256'h{INIT_2D}),
               .INIT_2E             (256'h{INIT_2E}),
               .INIT_2F             (256'h{INIT_2F}),
               .INIT_30             (256'h{INIT_30}),
               .INIT_31             (256'h{INIT_31}),
               .INIT_32             (256'h{INIT_32}),
               .INIT_33             (256'h{INIT_33}),
               .INIT_34             (256'h{INIT_34}),
               .INIT_35             (256'h{INIT_35}),
               .INIT_36             (256'h{INIT_36}),
               .INIT_37             (256'h{INIT_37}),
               .INIT_38             (256'h{INIT_38}),
               .INIT_39             (256'h{INIT_39}),
               .INIT_3A             (256'h{INIT_3A}),
               .INIT_3B             (256'h{INIT_3B}),
               .INIT_3C             (256'h{INIT_3C}),
               .INIT_3D             (256'h{INIT_3D}),
               .INIT_3E             (256'h{INIT_3E}),
               .INIT_3F             (256'h{INIT_3F}),
               .INITP_00            (256'h{INITP_00}),
               .INITP_01            (256'h{INITP_01}),
               .INITP_02            (256'h{INITP_02}),
               .INITP_03            (256'h{INITP_03}),
               .INITP_04            (256'h{INITP_04}),
               .INITP_05            (256'h{INITP_05}),
               .INITP_06            (256'h{INITP_06}),
               .INITP_07            (256'h{INITP_07}))
   kcpsm6_rom( .ADDRA               (address_a),
               .ENA                 (enable),
               .CLKA                (clk),
               .DOA                 (data_out_a[31:0]),
               .DOPA                (data_out_a[35:32]), 
               .DIA                 (data_in_a[31:0]),
               .DIPA                (data_in_a[35:32]), 
               .WEA                 (4'h0),
               .REGCEA              (1'b0),
               .RSTA                (1'b0),
               .ADDRB               (address_b),
               .ENB                 (enable_b),
               .CLKB                (clk_b),
               .DOB                 (data_out_b[31:0]),
               .DOPB                (data_out_b[35:32]), 
               .DIB                 (data_in_b[31:0]),
               .DIPB                (data_in_b[35:32]), 
               .WEB                 (we_b),
               .REGCEB              (1'b0),
               .RSTB                (1'b0));
//
//
endmodule
//
////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE {name}.v
//
////////////////////////////////////////////////////////////////////////////////////
