//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2010-2013, Xilinx, Inc.
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

Production template for a 2K program for KCPSM6 in a 7-Series device using a 
RAMB36E1 primitive.

Nick Sawyer (Xilinx Ltd)
Ken Chapman (Xilinx Ltd)

5th August 2011 - First Release
14th March 2013 - Unused address inputs on BRAMs connected High to reflect 
                  descriptions UG473.

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
// Copyright © 2010-2013, Xilinx, Inc.
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
// Production definition of a 2K program for KCPSM6 in a 7-Series device using a 
// RAMB36E1 primitive.
//
// Note: The complete 12-bit address bus is connected to KCPSM6 to facilitate future code 
//       expansion with minimum changes being required to the hardware description. 
//       Only the lower 11-bits of the address are actually used for the 2K address range
//       000 to 7FF hex.  
//
// Program defined by '{psmname}.psm'.
//
// Generated by KCPSM6 Assembler: {timestamp}. 
//
// Assembler used ROM_form template: ROM_form_7S_2K_14March13.v
//
//
module {name} (
input  [11:0] address,
output [17:0] instruction,
input         enable,
input         clk);
//
//
wire [15:0] address_a;
wire [35:0] data_in_a;
wire [35:0] data_out_a;
wire [15:0] address_b;
wire [35:0] data_in_b;
wire [35:0] data_out_b;
wire        enable_b;
wire        clk_b;
wire [7:0]  we_b;
//
//
assign address_a = {1'b1, address[10:0], 4'b1111};
assign instruction = {data_out_a[33:32],  data_out_a[15:0]};
assign data_in_a = {35'b000000000000000000000000000000000000, address[11]};
//
assign address_b = 16'b1111111111111111;
assign data_in_b = {2'h0,  data_out_b[33:32], 16'h0000, data_out_b[15:0]};
assign enable_b = 1'b0;
assign we_b = 8'h00;
assign clk_b = 1'b0;
//
RAMB36E1 # ( .READ_WIDTH_A              (18),
             .WRITE_WIDTH_A             (18),
             .DOA_REG                   (0),
             .INIT_A                    (36'h000000000),
             .RSTREG_PRIORITY_A         ("REGCE"),
             .SRVAL_A                   (36'h000000000),
             .WRITE_MODE_A              ("WRITE_FIRST"),
             .READ_WIDTH_B              (18),
             .WRITE_WIDTH_B             (18),
             .DOB_REG                   (0),
             .INIT_B                    (36'h000000000),
             .RSTREG_PRIORITY_B         ("REGCE"),
             .SRVAL_B                   (36'h000000000),
             .WRITE_MODE_B              ("WRITE_FIRST"),
             .INIT_FILE                 ("NONE"),
             .SIM_COLLISION_CHECK       ("ALL"),
             .RAM_MODE                  ("TDP"),
             .RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
             .EN_ECC_READ               ("FALSE"),
             .EN_ECC_WRITE              ("FALSE"),
             .RAM_EXTENSION_A           ("NONE"),
             .RAM_EXTENSION_B           ("NONE"),
             .SIM_DEVICE                ("7SERIES"),
             .INIT_00                   (256'h{INIT_00}),
             .INIT_01                   (256'h{INIT_01}),
             .INIT_02                   (256'h{INIT_02}),
             .INIT_03                   (256'h{INIT_03}),
             .INIT_04                   (256'h{INIT_04}),
             .INIT_05                   (256'h{INIT_05}),
             .INIT_06                   (256'h{INIT_06}),
             .INIT_07                   (256'h{INIT_07}),
             .INIT_08                   (256'h{INIT_08}),
             .INIT_09                   (256'h{INIT_09}),
             .INIT_0A                   (256'h{INIT_0A}),
             .INIT_0B                   (256'h{INIT_0B}),
             .INIT_0C                   (256'h{INIT_0C}),
             .INIT_0D                   (256'h{INIT_0D}),
             .INIT_0E                   (256'h{INIT_0E}),
             .INIT_0F                   (256'h{INIT_0F}),
             .INIT_10                   (256'h{INIT_10}),
             .INIT_11                   (256'h{INIT_11}),
             .INIT_12                   (256'h{INIT_12}),
             .INIT_13                   (256'h{INIT_13}),
             .INIT_14                   (256'h{INIT_14}),
             .INIT_15                   (256'h{INIT_15}),
             .INIT_16                   (256'h{INIT_16}),
             .INIT_17                   (256'h{INIT_17}),
             .INIT_18                   (256'h{INIT_18}),
             .INIT_19                   (256'h{INIT_19}),
             .INIT_1A                   (256'h{INIT_1A}),
             .INIT_1B                   (256'h{INIT_1B}),
             .INIT_1C                   (256'h{INIT_1C}),
             .INIT_1D                   (256'h{INIT_1D}),
             .INIT_1E                   (256'h{INIT_1E}),
             .INIT_1F                   (256'h{INIT_1F}),
             .INIT_20                   (256'h{INIT_20}),
             .INIT_21                   (256'h{INIT_21}),
             .INIT_22                   (256'h{INIT_22}),
             .INIT_23                   (256'h{INIT_23}),
             .INIT_24                   (256'h{INIT_24}),
             .INIT_25                   (256'h{INIT_25}),
             .INIT_26                   (256'h{INIT_26}),
             .INIT_27                   (256'h{INIT_27}),
             .INIT_28                   (256'h{INIT_28}),
             .INIT_29                   (256'h{INIT_29}),
             .INIT_2A                   (256'h{INIT_2A}),
             .INIT_2B                   (256'h{INIT_2B}),
             .INIT_2C                   (256'h{INIT_2C}),
             .INIT_2D                   (256'h{INIT_2D}),
             .INIT_2E                   (256'h{INIT_2E}),
             .INIT_2F                   (256'h{INIT_2F}),
             .INIT_30                   (256'h{INIT_30}),
             .INIT_31                   (256'h{INIT_31}),
             .INIT_32                   (256'h{INIT_32}),
             .INIT_33                   (256'h{INIT_33}),
             .INIT_34                   (256'h{INIT_34}),
             .INIT_35                   (256'h{INIT_35}),
             .INIT_36                   (256'h{INIT_36}),
             .INIT_37                   (256'h{INIT_37}),
             .INIT_38                   (256'h{INIT_38}),
             .INIT_39                   (256'h{INIT_39}),
             .INIT_3A                   (256'h{INIT_3A}),
             .INIT_3B                   (256'h{INIT_3B}),
             .INIT_3C                   (256'h{INIT_3C}),
             .INIT_3D                   (256'h{INIT_3D}),
             .INIT_3E                   (256'h{INIT_3E}),
             .INIT_3F                   (256'h{INIT_3F}),
             .INIT_40                   (256'h{INIT_40}),
             .INIT_41                   (256'h{INIT_41}),
             .INIT_42                   (256'h{INIT_42}),
             .INIT_43                   (256'h{INIT_43}),
             .INIT_44                   (256'h{INIT_44}),
             .INIT_45                   (256'h{INIT_45}),
             .INIT_46                   (256'h{INIT_46}),
             .INIT_47                   (256'h{INIT_47}),
             .INIT_48                   (256'h{INIT_48}),
             .INIT_49                   (256'h{INIT_49}),
             .INIT_4A                   (256'h{INIT_4A}),
             .INIT_4B                   (256'h{INIT_4B}),
             .INIT_4C                   (256'h{INIT_4C}),
             .INIT_4D                   (256'h{INIT_4D}),
             .INIT_4E                   (256'h{INIT_4E}),
             .INIT_4F                   (256'h{INIT_4F}),
             .INIT_50                   (256'h{INIT_50}),
             .INIT_51                   (256'h{INIT_51}),
             .INIT_52                   (256'h{INIT_52}),
             .INIT_53                   (256'h{INIT_53}),
             .INIT_54                   (256'h{INIT_54}),
             .INIT_55                   (256'h{INIT_55}),
             .INIT_56                   (256'h{INIT_56}),
             .INIT_57                   (256'h{INIT_57}),
             .INIT_58                   (256'h{INIT_58}),
             .INIT_59                   (256'h{INIT_59}),
             .INIT_5A                   (256'h{INIT_5A}),
             .INIT_5B                   (256'h{INIT_5B}),
             .INIT_5C                   (256'h{INIT_5C}),
             .INIT_5D                   (256'h{INIT_5D}),
             .INIT_5E                   (256'h{INIT_5E}),
             .INIT_5F                   (256'h{INIT_5F}),
             .INIT_60                   (256'h{INIT_60}),
             .INIT_61                   (256'h{INIT_61}),
             .INIT_62                   (256'h{INIT_62}),
             .INIT_63                   (256'h{INIT_63}),
             .INIT_64                   (256'h{INIT_64}),
             .INIT_65                   (256'h{INIT_65}),
             .INIT_66                   (256'h{INIT_66}),
             .INIT_67                   (256'h{INIT_67}),
             .INIT_68                   (256'h{INIT_68}),
             .INIT_69                   (256'h{INIT_69}),
             .INIT_6A                   (256'h{INIT_6A}),
             .INIT_6B                   (256'h{INIT_6B}),
             .INIT_6C                   (256'h{INIT_6C}),
             .INIT_6D                   (256'h{INIT_6D}),
             .INIT_6E                   (256'h{INIT_6E}),
             .INIT_6F                   (256'h{INIT_6F}),
             .INIT_70                   (256'h{INIT_70}),
             .INIT_71                   (256'h{INIT_71}),
             .INIT_72                   (256'h{INIT_72}),
             .INIT_73                   (256'h{INIT_73}),
             .INIT_74                   (256'h{INIT_74}),
             .INIT_75                   (256'h{INIT_75}),
             .INIT_76                   (256'h{INIT_76}),
             .INIT_77                   (256'h{INIT_77}),
             .INIT_78                   (256'h{INIT_78}),
             .INIT_79                   (256'h{INIT_79}),
             .INIT_7A                   (256'h{INIT_7A}),
             .INIT_7B                   (256'h{INIT_7B}),
             .INIT_7C                   (256'h{INIT_7C}),
             .INIT_7D                   (256'h{INIT_7D}),
             .INIT_7E                   (256'h{INIT_7E}),
             .INIT_7F                   (256'h{INIT_7F}),
             .INITP_00                  (256'h{INITP_00}),
             .INITP_01                  (256'h{INITP_01}),
             .INITP_02                  (256'h{INITP_02}),
             .INITP_03                  (256'h{INITP_03}),
             .INITP_04                  (256'h{INITP_04}),
             .INITP_05                  (256'h{INITP_05}),
             .INITP_06                  (256'h{INITP_06}),
             .INITP_07                  (256'h{INITP_07}),
             .INITP_08                  (256'h{INITP_08}),
             .INITP_09                  (256'h{INITP_09}),
             .INITP_0A                  (256'h{INITP_0A}),
             .INITP_0B                  (256'h{INITP_0B}),
             .INITP_0C                  (256'h{INITP_0C}),
             .INITP_0D                  (256'h{INITP_0D}),
             .INITP_0E                  (256'h{INITP_0E}),
             .INITP_0F                  (256'h{INITP_0F}))
 kcpsm6_rom( .ADDRARDADDR               (address_a),
             .ENARDEN                   (enable),
             .CLKARDCLK                 (clk),
             .DOADO                     (data_out_a[31:0]),
             .DOPADOP                   (data_out_a[35:32]), 
             .DIADI                     (data_in_a[31:0]),
             .DIPADIP                   (data_in_a[35:32]), 
             .WEA                       (4'h0),
             .REGCEAREGCE               (1'b0),
             .RSTRAMARSTRAM             (1'b0),
             .RSTREGARSTREG             (1'b0),
             .ADDRBWRADDR               (address_b),
             .ENBWREN                   (enable_b),
             .CLKBWRCLK                 (clk_b),
             .DOBDO                     (data_out_b[31:0]),
             .DOPBDOP                   (data_out_b[35:32]), 
             .DIBDI                     (data_in_b[31:0]),
             .DIPBDIP                   (data_in_b[35:32]), 
             .WEBWE                     (we_b),
             .REGCEB                    (1'b0),
             .RSTRAMB                   (1'b0),
             .RSTREGB                   (1'b0),
             .CASCADEINA                (1'b0),
             .CASCADEINB                (1'b0),
             .CASCADEOUTA               (),
             .CASCADEOUTB               (),
             .DBITERR                   (),
             .ECCPARITY                 (),
             .RDADDRECC                 (),
             .SBITERR                   (),
             .INJECTDBITERR             (1'b0),
             .INJECTSBITERR             (1'b0));
//
//
endmodule
//
////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE {name}.v
//
////////////////////////////////////////////////////////////////////////////////////
