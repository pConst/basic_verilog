//
//////////////////////////////////////////////////////////////////////////////////////////-
// Copyright © 2010-2012, Xilinx, Inc.
// This file contains confidential and proprietary information of Xilinx, Inc. and is
// protected under U.S. and international copyright and other intellectual property laws.
//////////////////////////////////////////////////////////////////////////////////////////-
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
//////////////////////////////////////////////////////////////////////////////////////////-
//

ROM_form.v

Template for a 1K program for KCPSM6 in a Spartan-6 device using a RAMB18WER primitive.
Includes generic parameters to allow for the inclusion of Jtag Loader hardware for
software development.

Nick Sawyer (Xilinx Ltd)
Ken Chapman (Xilinx Ltd)
Kris Chaplin (Xilinx Ltd)
3rd March 2011
20th April 2012 - Correction to copyright year range.

This is a Verilog template file for the KCPSM6 assembler.

This VHDL file is not valid as input directly into a synthesis or a simulation tool.
The assembler will read this template and insert the information required to complete
the definition of program ROM and write it out to a new '.v' file that is ready for 
synthesis and simulation.

This template can be modified to define alternative memory definitions. However, you are 
responsible for ensuring the template is correct as the assembler does not perform any 
checking of the VHDL.

The assembler identifies all text enclosed by {} characters, and replaces these
character strings. All templates should include these {} character strings for 
the assembler to work correctly. 


The next line is used to determine where the template actually starts.
{begin template}
//
//////////////////////////////////////////////////////////////////////////////////////////-
// Copyright © 2010-2011, Xilinx, Inc.
// This file contains confidential and proprietary information of Xilinx, Inc. and is
// protected under U.S. and international copyright and other intellectual property laws.
//////////////////////////////////////////////////////////////////////////////////////////-
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
//////////////////////////////////////////////////////////////////////////////////////////-
//
//
// Definition of a program memory for KCPSM6 including generic parameters for the 
// convenient selection of device family, program memory size and the ability to include 
// the JTAG Loader hardware for rapid software development.
//
// This file is primarily for use during code development and it is recommended that the 
// appropriate simplified program memory definition be used in a final production design. 
//
//    Generic                  Values             Comments
//    Parameter                Supported
//  
//    C_FAMILY                 "S6" or "V6"       Specify Spartan-6 or Virtex-6 device
//    C_RAM_SIZE_KWORDS        1, 2 or 4          Size of program memory in K-instructions
//                                                 '4' is only supported with 'V6'.
//    C_JTAG_LOADER_ENABLE     0 or 1             Set to '1' to include JTAG Loader
//
// Notes
//
// If your design contains MULTIPLE KCPSM6 instances then only one should have the 
// JTAG Loader enabled at a time (i.e. make sure that C_JTAG_LOADER_ENABLE is only set to 
// '1' on one instance of the program memory). Advanced users may be interested to know 
// that it is possible to connect JTAG Loader to multiple memories and then to use the 
// JTAG Loader utility to specify which memory contents are to be modified. However, 
// this scheme does require some effort to set up and the additional connectivity of the 
// multiple BRAMs can impact the placement, routing and performance of the complete 
// design. Please contact the author at Xilinx for more detailed information. 
//
// Regardless of the size of program memory specified by C_RAM_SIZE_KWORDS, the complete 
// 12-bit address bus is connected to KCPSM6. This enables the generic to be modified 
// without requiring changes to the fundamental hardware definition. However, when the 
// program memory is 1K then only the lower 10-bits of the address are actually used and 
// the valid address range is 000 to 3FF hex. Likewise, for a 2K program only the lower 
// 11-bits of the address are actually used and the valid address range is 000 to 7FF hex.
//
// Programs are stored in Block Memory (BRAM) and the number of BRAM used depends on the 
// size of the program and the device family. 
//
// In a Spartan-6 device a BRAM is capable of holding 1K instructions. Hence a 2K program 
// will require 2 BRAMs to be used. Whilst it is possible to implement a 4K program in a 
// Spartan-6 device this is a less natural fit within the architecture and either requires 
// 4 BRAMs and a small amount of logic resulting in a lower performance or 5 BRAMs when 
// performance is a critical factor. Due to these additional considerations this file 
// does not support the selection of 4K when using Spartan-6. It is also possible to 
// divide a BRAM into 2 smaller memories and therefore support a program up to only 512 
// instructions. If one of these special cases is required then please contact the authors
// at Xilinx to discuss and request a specific 'ROM_form' template that will meet your 
// requirements.    
//
// In a Virtex-6 device a BRAM is capable of holding 2K instructions so obviously a 2K
// program requires only a single BRAM. Each BRAM can also be divided into 2 smaller 
// memories supporting programs of 1K in half of a 36k-bit BRAM (generally reported 
// as being an 18k-bit BRAM). For a program of 4K instructions 2 BRAMs are required.
//
//
// Program defined by '{psmname}.psm'.
//
// Generated by KCPSM6 Assembler: {timestamp}. 
//
// Assembler used ROM_form template: 3rd March 2011
//
//
`timescale 1ps/1ps

module {name} (address, instruction, enable, rdl, clk) ;

parameter integer 	C_JTAG_LOADER_ENABLE = 1 ;			
parameter  		C_FAMILY = "S6" ;			
parameter integer 	C_RAM_SIZE_KWORDS = 1 ;			

input			clk ;	
input	[11:0]	address ;	
input			enable ;	
output [17:0]	instruction ;	
output		rdl ;
//
wire	[15:0]	address_a ;
wire	[35:0]	data_in_a ;
wire	[35:0]	data_out_a ;
wire	[35:0]	data_out_a_l ;
wire	[35:0]	data_out_a_h ;
wire	[15:0]	address_b ;
wire	[35:0]	data_in_b ;
wire	[35:0]	data_out_b ;
wire	[35:0]	data_in_b_l ;
wire	[35:0]	data_in_b_h ;
wire	[35:0]	data_out_b_l ;
wire	[35:0]	data_out_b_h ;
wire			enable_b ;
wire			clk_b ;
wire	[7:0]		we_b ;
wire	[11:0]	jtag_addr ;
wire			jtag_we ;
wire			jtag_clk ;
wire	[17:0]	jtag_din ;
wire 	[17:0]	jtag_dout ;
wire	[17:0]	jtag_dout_1 ;
wire	[0:0]		jtag_en ;
wire	[0:0]		picoblaze_reset ;
wire	[0:0]		rdl_bus ;

parameter integer  	BRAM_ADDRESS_WIDTH = addr_width_calc(C_RAM_SIZE_KWORDS);
//
//
function 	integer addr_width_calc;
input 		integer size_in_k;
		if (size_in_k == 1) begin addr_width_calc = 10 ; end
		else if (size_in_k == 2) begin addr_width_calc = 11; end
		else if (size_in_k == 4) begin addr_width_calc = 12; end
		else  begin
		if (C_RAM_SIZE_KWORDS != 1 && C_RAM_SIZE_KWORDS != 2 && C_RAM_SIZE_KWORDS != 4) begin
		//#0 ;
		$display("Invalid BlockRAM size. Please set to 1, 2 or 4 K words..\n");
		$finish ;
		end
end

endfunction
//
//
generate
if (C_RAM_SIZE_KWORDS == 1) begin : ram_1k_generate 
//
 if (C_FAMILY == "S6") begin: s6 
//
      assign address_a[13:0] = {address[9:0], 4'b0000};
      assign instruction = {data_out_a[33:32], data_out_a[15:0]};
      assign data_in_a = {34'b0000000000000000000000000000000000, address[11:10]};
      assign jtag_dout = {data_out_b[33:32], data_out_b[15:0]};
      //
       if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b = {2'b00, data_out_b[33:32], 16'b0000000000000000, data_out_b[15:0]} ;
        assign address_b[13:0] = 14'b00000000000000;
        assign we_b[3:0] = 4'b0000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
       if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b = {2'b00, jtag_din[17:16], 16'b0000000000000000, jtag_din[15:0]};
        assign address_b[13:0] = {jtag_addr[9:0], 4'b0000};
        assign we_b[3:0] = {jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
  // 
  RAMB16BWER #( 
  	.DATA_WIDTH_A 		(18),
	.DOA_REG 		(0),
	.EN_RSTRAM_A 		("FALSE"),
	.INIT_A 		(9'b000000000),
	.RST_PRIORITY_A 	("CE"),
	.SRVAL_A 		(9'b000000000),
	.WRITE_MODE_A 		("WRITE_FIRST"),
	.DATA_WIDTH_B 		(18),
	.DOB_REG 		(0),
	.EN_RSTRAM_B 		("FALSE"),
	.INIT_B 		(9'b000000000),
	.RST_PRIORITY_B 	("CE"),
	.SRVAL_B 		(9'b000000000),
	.WRITE_MODE_B 		("WRITE_FIRST"),
	.RSTTYPE 		("SYNC"),
	.INIT_FILE 		("NONE"),
	.SIM_COLLISION_CHECK 	("ALL"),
	.SIM_DEVICE 		("SPARTAN6"),
	.INIT_00 		(256'h{INIT_00}),
	.INIT_01 		(256'h{INIT_01}),
	.INIT_02 		(256'h{INIT_02}),
	.INIT_03 		(256'h{INIT_03}),
	.INIT_04 		(256'h{INIT_04}),
	.INIT_05 		(256'h{INIT_05}),
	.INIT_06 		(256'h{INIT_06}),
	.INIT_07 		(256'h{INIT_07}),
	.INIT_08 		(256'h{INIT_08}),
	.INIT_09 		(256'h{INIT_09}),
	.INIT_0A 		(256'h{INIT_0A}),
	.INIT_0B 		(256'h{INIT_0B}),
	.INIT_0C 		(256'h{INIT_0C}),
	.INIT_0D 		(256'h{INIT_0D}),
	.INIT_0E 		(256'h{INIT_0E}),
	.INIT_0F 		(256'h{INIT_0F}),
	.INIT_10 		(256'h{INIT_10}),
	.INIT_11 		(256'h{INIT_11}),
	.INIT_12 		(256'h{INIT_12}),
	.INIT_13 		(256'h{INIT_13}),
	.INIT_14 		(256'h{INIT_14}),
	.INIT_15 		(256'h{INIT_15}),
	.INIT_16 		(256'h{INIT_16}),
	.INIT_17 		(256'h{INIT_17}),
	.INIT_18 		(256'h{INIT_18}),
	.INIT_19 		(256'h{INIT_19}),
	.INIT_1A 		(256'h{INIT_1A}),
	.INIT_1B 		(256'h{INIT_1B}),
	.INIT_1C 		(256'h{INIT_1C}),
	.INIT_1D 		(256'h{INIT_1D}),
	.INIT_1E 		(256'h{INIT_1E}),
	.INIT_1F 		(256'h{INIT_1F}),
	.INIT_20 		(256'h{INIT_20}),
	.INIT_21 		(256'h{INIT_21}),
	.INIT_22 		(256'h{INIT_22}),
	.INIT_23 		(256'h{INIT_23}),
	.INIT_24 		(256'h{INIT_24}),
	.INIT_25 		(256'h{INIT_25}),
	.INIT_26 		(256'h{INIT_26}),
	.INIT_27 		(256'h{INIT_27}),
	.INIT_28 		(256'h{INIT_28}),
	.INIT_29 		(256'h{INIT_29}),
	.INIT_2A 		(256'h{INIT_2A}),
	.INIT_2B 		(256'h{INIT_2B}),
	.INIT_2C 		(256'h{INIT_2C}),
	.INIT_2D 		(256'h{INIT_2D}),
	.INIT_2E 		(256'h{INIT_2E}),
	.INIT_2F 		(256'h{INIT_2F}),
	.INIT_30 		(256'h{INIT_30}),
	.INIT_31 		(256'h{INIT_31}),
	.INIT_32 		(256'h{INIT_32}),
	.INIT_33 		(256'h{INIT_33}),
	.INIT_34 		(256'h{INIT_34}),
	.INIT_35 		(256'h{INIT_35}),
	.INIT_36 		(256'h{INIT_36}),
	.INIT_37 		(256'h{INIT_37}),
	.INIT_38 		(256'h{INIT_38}),
	.INIT_39 		(256'h{INIT_39}),
	.INIT_3A 		(256'h{INIT_3A}),
	.INIT_3B 		(256'h{INIT_3B}),
	.INIT_3C 		(256'h{INIT_3C}),
	.INIT_3D 		(256'h{INIT_3D}),
	.INIT_3E 		(256'h{INIT_3E}),
	.INIT_3F 		(256'h{INIT_3F}),
	.INITP_00 		(256'h{INITP_00}),
	.INITP_01 		(256'h{INITP_01}),
	.INITP_02 		(256'h{INITP_02}),
	.INITP_03 		(256'h{INITP_03}),
	.INITP_04 		(256'h{INITP_04}),
	.INITP_05 		(256'h{INITP_05}),
	.INITP_06 		(256'h{INITP_06}),
	.INITP_07 		(256'h{INITP_07}))
  kcpsm6_rom(  
  	.ADDRA 			(address_a[13:0]),
	.ENA			(enable),
	.CLKA			(clk),
	.DOA			(data_out_a[31:0]),
	.DOPA			(data_out_a[35:32]), 
	.DIA			(data_in_a[31:0]),
	.DIPA			(data_in_a[35:32]), 
	.WEA			(4'b0000),
	.REGCEA			(1'b0),
	.RSTA			(1'b0),
	.ADDRB			(address_b[13:0]),
	.ENB			(enable_b),
	.CLKB			(clk_b),
	.DOB			(data_out_b[31:0]),
	.DOPB			(data_out_b[35:32]), 
	.DIB			(data_in_b[31:0]),
	.DIPB			(data_in_b[35:32]), 
	.WEB			(we_b[3:0]),
	.REGCEB			(1'b0),
	.RSTB			(1'b0));
              
  end // s6;
//
 if (C_FAMILY == "V6") begin: v6 
//
      assign address_a[13:0] = {address[9:0], 4'b0000};
      assign instruction = data_out_a[17:0];
      assign data_in_a[17:0] = {16'b0000000000000000, address[11:10]};
      assign jtag_dout = data_out_b[17:0];
      //
       if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b[17:0] = data_out_b[17:0] ;
        assign address_b[13:0] = 14'b00000000000000;
        assign we_b[3:0] = 4'b0000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
       if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b[17:0] = jtag_din[17:0];
        assign address_b[13:0] = {jtag_addr[9:0], 4'b0000};
        assign we_b[3:0] = {jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
  // 
  RAMB18E1 #( 
  	.READ_WIDTH_A 		(18),
  	.WRITE_WIDTH_A 		(18),
	.DOA_REG 		(0),
	.INIT_A 		(18'b000000000000000000),
	.RSTREG_PRIORITY_A 	("REGCE"),
	.SRVAL_A 		(18'b000000000000000000),
	.WRITE_MODE_A 		("WRITE_FIRST"),
	.READ_WIDTH_B 		(18),
	.WRITE_WIDTH_B 		(18),
	.DOB_REG 		(0),
	.INIT_B 		(18'b000000000000000000),
	.RSTREG_PRIORITY_B 	("REGCE"),
	.SRVAL_B 		(18'b000000000000000000),
	.WRITE_MODE_B 		("WRITE_FIRST"),
	.INIT_FILE 		("NONE"),
	.SIM_COLLISION_CHECK 	("ALL"),
	.RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
	.RAM_MODE 		("TDP"),
	.INIT_00 		(256'h{INIT_00}),
	.INIT_01 		(256'h{INIT_01}),
	.INIT_02 		(256'h{INIT_02}),
	.INIT_03 		(256'h{INIT_03}),
	.INIT_04 		(256'h{INIT_04}),
	.INIT_05 		(256'h{INIT_05}),
	.INIT_06 		(256'h{INIT_06}),
	.INIT_07 		(256'h{INIT_07}),
	.INIT_08 		(256'h{INIT_08}),
	.INIT_09 		(256'h{INIT_09}),
	.INIT_0A 		(256'h{INIT_0A}),
	.INIT_0B 		(256'h{INIT_0B}),
	.INIT_0C 		(256'h{INIT_0C}),
	.INIT_0D 		(256'h{INIT_0D}),
	.INIT_0E 		(256'h{INIT_0E}),
	.INIT_0F 		(256'h{INIT_0F}),
	.INIT_10 		(256'h{INIT_10}),
	.INIT_11 		(256'h{INIT_11}),
	.INIT_12 		(256'h{INIT_12}),
	.INIT_13 		(256'h{INIT_13}),
	.INIT_14 		(256'h{INIT_14}),
	.INIT_15 		(256'h{INIT_15}),
	.INIT_16 		(256'h{INIT_16}),
	.INIT_17 		(256'h{INIT_17}),
	.INIT_18 		(256'h{INIT_18}),
	.INIT_19 		(256'h{INIT_19}),
	.INIT_1A 		(256'h{INIT_1A}),
	.INIT_1B 		(256'h{INIT_1B}),
	.INIT_1C 		(256'h{INIT_1C}),
	.INIT_1D 		(256'h{INIT_1D}),
	.INIT_1E 		(256'h{INIT_1E}),
	.INIT_1F 		(256'h{INIT_1F}),
	.INIT_20 		(256'h{INIT_20}),
	.INIT_21 		(256'h{INIT_21}),
	.INIT_22 		(256'h{INIT_22}),
	.INIT_23 		(256'h{INIT_23}),
	.INIT_24 		(256'h{INIT_24}),
	.INIT_25 		(256'h{INIT_25}),
	.INIT_26 		(256'h{INIT_26}),
	.INIT_27 		(256'h{INIT_27}),
	.INIT_28 		(256'h{INIT_28}),
	.INIT_29 		(256'h{INIT_29}),
	.INIT_2A 		(256'h{INIT_2A}),
	.INIT_2B 		(256'h{INIT_2B}),
	.INIT_2C 		(256'h{INIT_2C}),
	.INIT_2D 		(256'h{INIT_2D}),
	.INIT_2E 		(256'h{INIT_2E}),
	.INIT_2F 		(256'h{INIT_2F}),
	.INIT_30 		(256'h{INIT_30}),
	.INIT_31 		(256'h{INIT_31}),
	.INIT_32 		(256'h{INIT_32}),
	.INIT_33 		(256'h{INIT_33}),
	.INIT_34 		(256'h{INIT_34}),
	.INIT_35 		(256'h{INIT_35}),
	.INIT_36 		(256'h{INIT_36}),
	.INIT_37 		(256'h{INIT_37}),
	.INIT_38 		(256'h{INIT_38}),
	.INIT_39 		(256'h{INIT_39}),
	.INIT_3A 		(256'h{INIT_3A}),
	.INIT_3B 		(256'h{INIT_3B}),
	.INIT_3C 		(256'h{INIT_3C}),
	.INIT_3D 		(256'h{INIT_3D}),
	.INIT_3E 		(256'h{INIT_3E}),
	.INIT_3F 		(256'h{INIT_3F}),
	.INITP_00 		(256'h{INITP_00}),
	.INITP_01 		(256'h{INITP_01}),
	.INITP_02 		(256'h{INITP_02}),
	.INITP_03 		(256'h{INITP_03}),
	.INITP_04 		(256'h{INITP_04}),
	.INITP_05 		(256'h{INITP_05}),
	.INITP_06 		(256'h{INITP_06}),
	.INITP_07 		(256'h{INITP_07}))
  kcpsm6_rom(  
  	.ADDRARDADDR		(address_a[13:0]),
	.ENARDEN		(enable),
	.CLKARDCLK		(clk),
	.DOADO			(data_out_a[15:0]),
	.DOPADOP		(data_out_a[17:16]), 
	.DIADI			(data_in_a[15:0]),
	.DIPADIP		(data_in_a[17:16]), 
	.WEA			(2'b00),
	.REGCEAREGCE		(1'b0),
	.RSTRAMARSTRAM		(1'b0),
	.RSTREGARSTREG		(1'b0),
	.ADDRBWRADDR		(address_b[13:0]),
	.ENBWREN		(enable_b),
	.CLKBWRCLK		(clk_b),
	.DOBDO			(data_out_b[15:0]),
	.DOPBDOP		(data_out_b[17:16]), 
	.DIBDI			(data_in_b[15:0]),
	.DIPBDIP		(data_in_b[17:16]), 
	.WEBWE			(we_b[3:0]),
	.REGCEB			(1'b0),
	.RSTRAMB		(1'b0),
	.RSTREGB		(1'b0));
              
  end // v6;  
 end // ram_1k_generate;
endgenerate
//  
generate
if (C_RAM_SIZE_KWORDS == 2) begin : ram_2k_generate 
//
 if (C_FAMILY == "S6") begin: s6 
//
      assign address_a[13:0] = {address[10:0], 3'b000};
      assign instruction = {data_out_a_h[32], data_out_a_h[7:0], data_out_a_l[32], data_out_a_l[7:0]};
      assign data_in_a = {35'b00000000000000000000000000000000000, address[11]};
      assign jtag_dout = {data_out_b_h[32], data_out_b_h[7:0], data_out_b_l[32], data_out_b_l[7:0]};
      //
       if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b_l = {3'b000, data_out_b_l[32], 24'b000000000000000000000000, data_out_b_l[7:0]} ;
        assign data_in_b_h = {3'b000, data_out_b_h[32], 24'b000000000000000000000000, data_out_b_h[7:0]} ;
        assign address_b[13:0] = 14'b00000000000000;
        assign we_b[3:0] = 4'b0000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
       if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b_h = {3'b000, jtag_din[17], 24'b000000000000000000000000, jtag_din[16:9]} ;
        assign data_in_b_l = {3'b000, jtag_din[8],  24'b000000000000000000000000, jtag_din[7:0]} ;
        assign address_b[13:0] = {jtag_addr[10:0], 3'b000};
        assign we_b[3:0] = {jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
  // 
  RAMB16BWER #( 
  	.DATA_WIDTH_A 		(9),
	.DOA_REG 		(0),
	.EN_RSTRAM_A 		("FALSE"),
	.INIT_A 		(9'b000000000),
	.RST_PRIORITY_A 	("CE"),
	.SRVAL_A 		(9'b000000000),
	.WRITE_MODE_A 		("WRITE_FIRST"),
	.DATA_WIDTH_B 		(9),
	.DOB_REG 		(0),
	.EN_RSTRAM_B 		("FALSE"),
	.INIT_B 		(9'b000000000),
	.RST_PRIORITY_B 	("CE"),
	.SRVAL_B 		(9'b000000000),
	.WRITE_MODE_B 		("WRITE_FIRST"),
	.RSTTYPE 		("SYNC"),
	.INIT_FILE 		("NONE"),
	.SIM_COLLISION_CHECK 	("ALL"),
	.SIM_DEVICE 		("SPARTAN6"),
	.INIT_00 		(256'h{[8:0]_INIT_00}),
	.INIT_01 		(256'h{[8:0]_INIT_01}),
	.INIT_02 		(256'h{[8:0]_INIT_02}),
	.INIT_03 		(256'h{[8:0]_INIT_03}),
	.INIT_04 		(256'h{[8:0]_INIT_04}),
	.INIT_05 		(256'h{[8:0]_INIT_05}),
	.INIT_06 		(256'h{[8:0]_INIT_06}),
	.INIT_07 		(256'h{[8:0]_INIT_07}),
	.INIT_08 		(256'h{[8:0]_INIT_08}),
	.INIT_09 		(256'h{[8:0]_INIT_09}),
	.INIT_0A 		(256'h{[8:0]_INIT_0A}),
	.INIT_0B 		(256'h{[8:0]_INIT_0B}),
	.INIT_0C 		(256'h{[8:0]_INIT_0C}),
	.INIT_0D 		(256'h{[8:0]_INIT_0D}),
	.INIT_0E 		(256'h{[8:0]_INIT_0E}),
	.INIT_0F 		(256'h{[8:0]_INIT_0F}),
	.INIT_10 		(256'h{[8:0]_INIT_10}),
	.INIT_11 		(256'h{[8:0]_INIT_11}),
	.INIT_12 		(256'h{[8:0]_INIT_12}),
	.INIT_13 		(256'h{[8:0]_INIT_13}),
	.INIT_14 		(256'h{[8:0]_INIT_14}),
	.INIT_15 		(256'h{[8:0]_INIT_15}),
	.INIT_16 		(256'h{[8:0]_INIT_16}),
	.INIT_17 		(256'h{[8:0]_INIT_17}),
	.INIT_18 		(256'h{[8:0]_INIT_18}),
	.INIT_19 		(256'h{[8:0]_INIT_19}),
	.INIT_1A 		(256'h{[8:0]_INIT_1A}),
	.INIT_1B 		(256'h{[8:0]_INIT_1B}),
	.INIT_1C 		(256'h{[8:0]_INIT_1C}),
	.INIT_1D 		(256'h{[8:0]_INIT_1D}),
	.INIT_1E 		(256'h{[8:0]_INIT_1E}),
	.INIT_1F 		(256'h{[8:0]_INIT_1F}),
	.INIT_20 		(256'h{[8:0]_INIT_20}),
	.INIT_21 		(256'h{[8:0]_INIT_21}),
	.INIT_22 		(256'h{[8:0]_INIT_22}),
	.INIT_23 		(256'h{[8:0]_INIT_23}),
	.INIT_24 		(256'h{[8:0]_INIT_24}),
	.INIT_25 		(256'h{[8:0]_INIT_25}),
	.INIT_26 		(256'h{[8:0]_INIT_26}),
	.INIT_27 		(256'h{[8:0]_INIT_27}),
	.INIT_28 		(256'h{[8:0]_INIT_28}),
	.INIT_29 		(256'h{[8:0]_INIT_29}),
	.INIT_2A 		(256'h{[8:0]_INIT_2A}),
	.INIT_2B 		(256'h{[8:0]_INIT_2B}),
	.INIT_2C 		(256'h{[8:0]_INIT_2C}),
	.INIT_2D 		(256'h{[8:0]_INIT_2D}),
	.INIT_2E 		(256'h{[8:0]_INIT_2E}),
	.INIT_2F 		(256'h{[8:0]_INIT_2F}),
	.INIT_30 		(256'h{[8:0]_INIT_30}),
	.INIT_31 		(256'h{[8:0]_INIT_31}),
	.INIT_32 		(256'h{[8:0]_INIT_32}),
	.INIT_33 		(256'h{[8:0]_INIT_33}),
	.INIT_34 		(256'h{[8:0]_INIT_34}),
	.INIT_35 		(256'h{[8:0]_INIT_35}),
	.INIT_36 		(256'h{[8:0]_INIT_36}),
	.INIT_37 		(256'h{[8:0]_INIT_37}),
	.INIT_38 		(256'h{[8:0]_INIT_38}),
	.INIT_39 		(256'h{[8:0]_INIT_39}),
	.INIT_3A 		(256'h{[8:0]_INIT_3A}),
	.INIT_3B 		(256'h{[8:0]_INIT_3B}),
	.INIT_3C 		(256'h{[8:0]_INIT_3C}),
	.INIT_3D 		(256'h{[8:0]_INIT_3D}),
	.INIT_3E 		(256'h{[8:0]_INIT_3E}),
	.INIT_3F 		(256'h{[8:0]_INIT_3F}),
	.INITP_00 		(256'h{[8:0]_INITP_00}),
	.INITP_01 		(256'h{[8:0]_INITP_01}),
	.INITP_02 		(256'h{[8:0]_INITP_02}),
	.INITP_03 		(256'h{[8:0]_INITP_03}),
	.INITP_04 		(256'h{[8:0]_INITP_04}),
	.INITP_05 		(256'h{[8:0]_INITP_05}),
	.INITP_06 		(256'h{[8:0]_INITP_06}),
	.INITP_07 		(256'h{[8:0]_INITP_07}))
  kcpsm6_rom_l(  
  	.ADDRA 			(address_a[13:0]),
	.ENA			(enable),
	.CLKA			(clk),
	.DOA			(data_out_a_l[31:0]),
	.DOPA			(data_out_a_l[35:32]), 
	.DIA			(data_in_a[31:0]),
	.DIPA			(data_in_a[35:32]), 
	.WEA			(4'b0000),
	.REGCEA			(1'b0),
	.RSTA			(1'b0),
	.ADDRB			(address_b[13:0]),
	.ENB			(enable_b),
	.CLKB			(clk_b),
	.DOB			(data_out_b_l[31:0]),
	.DOPB			(data_out_b_l[35:32]), 
	.DIB			(data_in_b_l[31:0]),
	.DIPB			(data_in_b_l[35:32]), 
	.WEB			(we_b[3:0]),
	.REGCEB			(1'b0),
	.RSTB			(1'b0));

  RAMB16BWER #( 
  	.DATA_WIDTH_A 		(9),
	.DOA_REG 		(0),
	.EN_RSTRAM_A 		("FALSE"),
	.INIT_A 		(9'b000000000),
	.RST_PRIORITY_A 	("CE"),
	.SRVAL_A 		(9'b000000000),
	.WRITE_MODE_A 		("WRITE_FIRST"),
	.DATA_WIDTH_B 		(9),
	.DOB_REG 		(0),
	.EN_RSTRAM_B 		("FALSE"),
	.INIT_B 		(9'b000000000),
	.RST_PRIORITY_B 	("CE"),
	.SRVAL_B 		(9'b000000000),
	.WRITE_MODE_B 		("WRITE_FIRST"),
	.RSTTYPE 		("SYNC"),
	.INIT_FILE 		("NONE"),
	.SIM_COLLISION_CHECK 	("ALL"),
	.SIM_DEVICE 		("SPARTAN6"),
	.INIT_00 		(256'h{[17:9]_INIT_00}),
	.INIT_01 		(256'h{[17:9]_INIT_01}),
	.INIT_02 		(256'h{[17:9]_INIT_02}),
	.INIT_03 		(256'h{[17:9]_INIT_03}),
	.INIT_04 		(256'h{[17:9]_INIT_04}),
	.INIT_05 		(256'h{[17:9]_INIT_05}),
	.INIT_06 		(256'h{[17:9]_INIT_06}),
	.INIT_07 		(256'h{[17:9]_INIT_07}),
	.INIT_08 		(256'h{[17:9]_INIT_08}),
	.INIT_09 		(256'h{[17:9]_INIT_09}),
	.INIT_0A 		(256'h{[17:9]_INIT_0A}),
	.INIT_0B 		(256'h{[17:9]_INIT_0B}),
	.INIT_0C 		(256'h{[17:9]_INIT_0C}),
	.INIT_0D 		(256'h{[17:9]_INIT_0D}),
	.INIT_0E 		(256'h{[17:9]_INIT_0E}),
	.INIT_0F 		(256'h{[17:9]_INIT_0F}),
	.INIT_10 		(256'h{[17:9]_INIT_10}),
	.INIT_11 		(256'h{[17:9]_INIT_11}),
	.INIT_12 		(256'h{[17:9]_INIT_12}),
	.INIT_13 		(256'h{[17:9]_INIT_13}),
	.INIT_14 		(256'h{[17:9]_INIT_14}),
	.INIT_15 		(256'h{[17:9]_INIT_15}),
	.INIT_16 		(256'h{[17:9]_INIT_16}),
	.INIT_17 		(256'h{[17:9]_INIT_17}),
	.INIT_18 		(256'h{[17:9]_INIT_18}),
	.INIT_19 		(256'h{[17:9]_INIT_19}),
	.INIT_1A 		(256'h{[17:9]_INIT_1A}),
	.INIT_1B 		(256'h{[17:9]_INIT_1B}),
	.INIT_1C 		(256'h{[17:9]_INIT_1C}),
	.INIT_1D 		(256'h{[17:9]_INIT_1D}),
	.INIT_1E 		(256'h{[17:9]_INIT_1E}),
	.INIT_1F 		(256'h{[17:9]_INIT_1F}),
	.INIT_20 		(256'h{[17:9]_INIT_20}),
	.INIT_21 		(256'h{[17:9]_INIT_21}),
	.INIT_22 		(256'h{[17:9]_INIT_22}),
	.INIT_23 		(256'h{[17:9]_INIT_23}),
	.INIT_24 		(256'h{[17:9]_INIT_24}),
	.INIT_25 		(256'h{[17:9]_INIT_25}),
	.INIT_26 		(256'h{[17:9]_INIT_26}),
	.INIT_27 		(256'h{[17:9]_INIT_27}),
	.INIT_28 		(256'h{[17:9]_INIT_28}),
	.INIT_29 		(256'h{[17:9]_INIT_29}),
	.INIT_2A 		(256'h{[17:9]_INIT_2A}),
	.INIT_2B 		(256'h{[17:9]_INIT_2B}),
	.INIT_2C 		(256'h{[17:9]_INIT_2C}),
	.INIT_2D 		(256'h{[17:9]_INIT_2D}),
	.INIT_2E 		(256'h{[17:9]_INIT_2E}),
	.INIT_2F 		(256'h{[17:9]_INIT_2F}),
	.INIT_30 		(256'h{[17:9]_INIT_30}),
	.INIT_31 		(256'h{[17:9]_INIT_31}),
	.INIT_32 		(256'h{[17:9]_INIT_32}),
	.INIT_33 		(256'h{[17:9]_INIT_33}),
	.INIT_34 		(256'h{[17:9]_INIT_34}),
	.INIT_35 		(256'h{[17:9]_INIT_35}),
	.INIT_36 		(256'h{[17:9]_INIT_36}),
	.INIT_37 		(256'h{[17:9]_INIT_37}),
	.INIT_38 		(256'h{[17:9]_INIT_38}),
	.INIT_39 		(256'h{[17:9]_INIT_39}),
	.INIT_3A 		(256'h{[17:9]_INIT_3A}),
	.INIT_3B 		(256'h{[17:9]_INIT_3B}),
	.INIT_3C 		(256'h{[17:9]_INIT_3C}),
	.INIT_3D 		(256'h{[17:9]_INIT_3D}),
	.INIT_3E 		(256'h{[17:9]_INIT_3E}),
	.INIT_3F 		(256'h{[17:9]_INIT_3F}),
	.INITP_00 		(256'h{[17:9]_INITP_00}),
	.INITP_01 		(256'h{[17:9]_INITP_01}),
	.INITP_02 		(256'h{[17:9]_INITP_02}),
	.INITP_03 		(256'h{[17:9]_INITP_03}),
	.INITP_04 		(256'h{[17:9]_INITP_04}),
	.INITP_05 		(256'h{[17:9]_INITP_05}),
	.INITP_06 		(256'h{[17:9]_INITP_06}),
	.INITP_07 		(256'h{[17:9]_INITP_07}))
  kcpsm6_rom_h(  
  	.ADDRA 			(address_a[13:0]),
	.ENA			(enable),
	.CLKA			(clk),
	.DOA			(data_out_a_h[31:0]),
	.DOPA			(data_out_a_h[35:32]), 
	.DIA			(data_in_a[31:0]),
	.DIPA			(data_in_a[35:32]), 
	.WEA			(4'b0000),
	.REGCEA			(1'b0),
	.RSTA			(1'b0),
	.ADDRB			(address_b[13:0]),
	.ENB			(enable_b),
	.CLKB			(clk_b),
	.DOB			(data_out_b_h[31:0]),
	.DOPB			(data_out_b_h[35:32]), 
	.DIB			(data_in_b_h[31:0]),
	.DIPB			(data_in_b_h[35:32]), 
	.WEB			(we_b[3:0]),
	.REGCEB			(1'b0),
	.RSTB			(1'b0));
	              
  end // s6;
//
 if (C_FAMILY == "V6") begin: v6 
//
      assign address_a = {1'b0, address[10:0], 4'b0000};
      assign instruction = {data_out_a[33:32], data_out_a[15:0]} ;
      assign data_in_a = {35'b00000000000000000000000000000000000, address[11]};
      assign jtag_dout = {data_out_b[33:32], data_out_b[15:0]};
      //
       if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b = {2'b00, data_out_b[33:32], 16'b0000000000000000, data_out_b[15:0]} ;
        assign address_b = 16'b0000000000000000;
        assign we_b = 8'b00000000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
       if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b = {2'b00, jtag_din[17:16], 16'b0000000000000000, jtag_din[15:0]} ;
        assign address_b = {1'b0, jtag_addr[10:0], 4'b0000};
        assign we_b = {jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
  // 
  RAMB36E1 #( 
  	.READ_WIDTH_A 		(18),
  	.WRITE_WIDTH_A 		(18),
	.DOA_REG 		(0),
	.INIT_A 		(36'h000000000),
	.RSTREG_PRIORITY_A 	("REGCE"),
	.SRVAL_A 		(36'h000000000),
	.WRITE_MODE_A 		("WRITE_FIRST"),
	.READ_WIDTH_B 		(18),
	.WRITE_WIDTH_B 		(18),
	.DOB_REG 		(0),
	.INIT_B 		(36'h000000000),
	.RSTREG_PRIORITY_B 	("REGCE"),
	.SRVAL_B 		(36'h000000000),
	.WRITE_MODE_B 		("WRITE_FIRST"),
	.INIT_FILE 		("NONE"),
	.SIM_COLLISION_CHECK 	("ALL"),
	.RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
	.RAM_MODE 		("TDP"),
	.EN_ECC_READ 		("FALSE"),
	.EN_ECC_WRITE 		("FALSE"),
	.RAM_EXTENSION_A 	("NONE"),
	.RAM_EXTENSION_B 	("NONE"),
	.INIT_00 		(256'h{INIT_00}),
	.INIT_01 		(256'h{INIT_01}),
	.INIT_02 		(256'h{INIT_02}),
	.INIT_03 		(256'h{INIT_03}),
	.INIT_04 		(256'h{INIT_04}),
	.INIT_05 		(256'h{INIT_05}),
	.INIT_06 		(256'h{INIT_06}),
	.INIT_07 		(256'h{INIT_07}),
	.INIT_08 		(256'h{INIT_08}),
	.INIT_09 		(256'h{INIT_09}),
	.INIT_0A 		(256'h{INIT_0A}),
	.INIT_0B 		(256'h{INIT_0B}),
	.INIT_0C 		(256'h{INIT_0C}),
	.INIT_0D 		(256'h{INIT_0D}),
	.INIT_0E 		(256'h{INIT_0E}),
	.INIT_0F 		(256'h{INIT_0F}),
	.INIT_10 		(256'h{INIT_10}),
	.INIT_11 		(256'h{INIT_11}),
	.INIT_12 		(256'h{INIT_12}),
	.INIT_13 		(256'h{INIT_13}),
	.INIT_14 		(256'h{INIT_14}),
	.INIT_15 		(256'h{INIT_15}),
	.INIT_16 		(256'h{INIT_16}),
	.INIT_17 		(256'h{INIT_17}),
	.INIT_18 		(256'h{INIT_18}),
	.INIT_19 		(256'h{INIT_19}),
	.INIT_1A 		(256'h{INIT_1A}),
	.INIT_1B 		(256'h{INIT_1B}),
	.INIT_1C 		(256'h{INIT_1C}),
	.INIT_1D 		(256'h{INIT_1D}),
	.INIT_1E 		(256'h{INIT_1E}),
	.INIT_1F 		(256'h{INIT_1F}),
	.INIT_20 		(256'h{INIT_20}),
	.INIT_21 		(256'h{INIT_21}),
	.INIT_22 		(256'h{INIT_22}),
	.INIT_23 		(256'h{INIT_23}),
	.INIT_24 		(256'h{INIT_24}),
	.INIT_25 		(256'h{INIT_25}),
	.INIT_26 		(256'h{INIT_26}),
	.INIT_27 		(256'h{INIT_27}),
	.INIT_28 		(256'h{INIT_28}),
	.INIT_29 		(256'h{INIT_29}),
	.INIT_2A 		(256'h{INIT_2A}),
	.INIT_2B 		(256'h{INIT_2B}),
	.INIT_2C 		(256'h{INIT_2C}),
	.INIT_2D 		(256'h{INIT_2D}),
	.INIT_2E 		(256'h{INIT_2E}),
	.INIT_2F 		(256'h{INIT_2F}),
	.INIT_30 		(256'h{INIT_30}),
	.INIT_31 		(256'h{INIT_31}),
	.INIT_32 		(256'h{INIT_32}),
	.INIT_33 		(256'h{INIT_33}),
	.INIT_34 		(256'h{INIT_34}),
	.INIT_35 		(256'h{INIT_35}),
	.INIT_36 		(256'h{INIT_36}),
	.INIT_37 		(256'h{INIT_37}),
	.INIT_38 		(256'h{INIT_38}),
	.INIT_39 		(256'h{INIT_39}),
	.INIT_3A 		(256'h{INIT_3A}),
	.INIT_3B 		(256'h{INIT_3B}),
	.INIT_3C 		(256'h{INIT_3C}),
	.INIT_3D 		(256'h{INIT_3D}),
	.INIT_3E 		(256'h{INIT_3E}),
	.INIT_3F 		(256'h{INIT_3F}),
	.INIT_40 		(256'h{INIT_40}),
	.INIT_41 		(256'h{INIT_41}),
	.INIT_42 		(256'h{INIT_42}),
	.INIT_43 		(256'h{INIT_43}),
	.INIT_44 		(256'h{INIT_44}),
	.INIT_45 		(256'h{INIT_45}),
	.INIT_46 		(256'h{INIT_46}),
	.INIT_47 		(256'h{INIT_47}),
	.INIT_48 		(256'h{INIT_48}),
	.INIT_49 		(256'h{INIT_49}),
	.INIT_4A 		(256'h{INIT_4A}),
	.INIT_4B 		(256'h{INIT_4B}),
	.INIT_4C 		(256'h{INIT_4C}),
	.INIT_4D 		(256'h{INIT_4D}),
	.INIT_4E 		(256'h{INIT_4E}),
	.INIT_4F 		(256'h{INIT_4F}),
	.INIT_50 		(256'h{INIT_50}),
	.INIT_51 		(256'h{INIT_51}),
	.INIT_52 		(256'h{INIT_52}),
	.INIT_53 		(256'h{INIT_53}),
	.INIT_54 		(256'h{INIT_54}),
	.INIT_55 		(256'h{INIT_55}),
	.INIT_56 		(256'h{INIT_56}),
	.INIT_57 		(256'h{INIT_57}),
	.INIT_58 		(256'h{INIT_58}),
	.INIT_59 		(256'h{INIT_59}),
	.INIT_5A 		(256'h{INIT_5A}),
	.INIT_5B 		(256'h{INIT_5B}),
	.INIT_5C 		(256'h{INIT_5C}),
	.INIT_5D 		(256'h{INIT_5D}),
	.INIT_5E 		(256'h{INIT_5E}),
	.INIT_5F 		(256'h{INIT_5F}),
	.INIT_60 		(256'h{INIT_60}),
	.INIT_61 		(256'h{INIT_61}),
	.INIT_62 		(256'h{INIT_62}),
	.INIT_63 		(256'h{INIT_63}),
	.INIT_64 		(256'h{INIT_64}),
	.INIT_65 		(256'h{INIT_65}),
	.INIT_66 		(256'h{INIT_66}),
	.INIT_67 		(256'h{INIT_67}),
	.INIT_68 		(256'h{INIT_68}),
	.INIT_69 		(256'h{INIT_69}),
	.INIT_6A 		(256'h{INIT_6A}),
	.INIT_6B 		(256'h{INIT_6B}),
	.INIT_6C 		(256'h{INIT_6C}),
	.INIT_6D 		(256'h{INIT_6D}),
	.INIT_6E 		(256'h{INIT_6E}),
	.INIT_6F 		(256'h{INIT_6F}),
	.INIT_70 		(256'h{INIT_70}),
	.INIT_71 		(256'h{INIT_71}),
	.INIT_72 		(256'h{INIT_72}),
	.INIT_73 		(256'h{INIT_73}),
	.INIT_74 		(256'h{INIT_74}),
	.INIT_75 		(256'h{INIT_75}),
	.INIT_76 		(256'h{INIT_76}),
	.INIT_77 		(256'h{INIT_77}),
	.INIT_78 		(256'h{INIT_78}),
	.INIT_79 		(256'h{INIT_79}),
	.INIT_7A 		(256'h{INIT_7A}),
	.INIT_7B 		(256'h{INIT_7B}),
	.INIT_7C 		(256'h{INIT_7C}),
	.INIT_7D 		(256'h{INIT_7D}),
	.INIT_7E 		(256'h{INIT_7E}),
	.INIT_7F 		(256'h{INIT_7F}),
	.INITP_00 		(256'h{INITP_00}),
	.INITP_01 		(256'h{INITP_01}),
	.INITP_02 		(256'h{INITP_02}),
	.INITP_03 		(256'h{INITP_03}),
	.INITP_04 		(256'h{INITP_04}),
	.INITP_05 		(256'h{INITP_05}),
	.INITP_06 		(256'h{INITP_06}),
	.INITP_07 		(256'h{INITP_07}),
	.INITP_08 		(256'h{INITP_08}),
	.INITP_09 		(256'h{INITP_09}),
	.INITP_0A 		(256'h{INITP_0A}),
	.INITP_0B 		(256'h{INITP_0B}),
	.INITP_0C 		(256'h{INITP_0C}),
	.INITP_0D 		(256'h{INITP_0D}),
	.INITP_0E 		(256'h{INITP_0E}),
	.INITP_0F 		(256'h{INITP_0F}))
  kcpsm6_rom(  
  	.ADDRARDADDR		(address_a),
	.ENARDEN		(enable),
	.CLKARDCLK		(clk),
	.DOADO			(data_out_a[31:0]),
	.DOPADOP		(data_out_a[35:32]), 
	.DIADI			(data_in_a[31:0]),
	.DIPADIP		(data_in_a[35:32]), 
	.WEA			(4'b0000),
	.REGCEAREGCE		(1'b0),
	.RSTRAMARSTRAM		(1'b0),
	.RSTREGARSTREG		(1'b0),
	.ADDRBWRADDR		(address_b),
	.ENBWREN		(enable_b),
	.CLKBWRCLK		(clk_b),
	.DOBDO			(data_out_b[31:0]),
	.DOPBDOP		(data_out_b[35:32]), 
	.DIBDI			(data_in_b[31:0]),
	.DIPBDIP		(data_in_b[35:32]), 
	.WEBWE			(we_b),
	.REGCEB			(1'b0),
	.RSTRAMB		(1'b0),
	.RSTREGB		(1'b0),
	.CASCADEINA 		(1'b0),
	.CASCADEINB 		(1'b0),
	.CASCADEOUTA		(),
	.CASCADEOUTB		(),
	.DBITERR		(),
	.ECCPARITY		(),
	.RDADDRECC		(),
	.SBITERR		(),
	.INJECTDBITERR 		(1'b0),       
	.INJECTSBITERR 		(1'b0));   
                              
  end // v6;  
 end // ram_2k_generate;
endgenerate              

generate
if (C_RAM_SIZE_KWORDS == 4) begin : ram_4k_generate 
//
 if (C_FAMILY == "S6") begin: s6 
//
//      assert(1=0) report "4K BRAM in Spartan-6 is a special case not supported by this template." severity FAILURE;            
  end // s6;
//
 if (C_FAMILY == "V6") begin: v6 
//
      assign address_a = {1'b0, address[11:0], 3'b000};
      assign instruction = {data_out_a_h[32], data_out_a_h[7:0], data_out_a_l[32], data_out_a_l[7:0]} ;
      assign data_in_a = 36'b00000000000000000000000000000000000 ;
      assign jtag_dout = {data_out_b_h[32], data_out_b_h[7:0], data_out_b_l[32], data_out_b_l[7:0]};
      //
       if (C_JTAG_LOADER_ENABLE == 0) begin : no_loader
        assign data_in_b_l = {3'b000, data_out_b_l[32], 24'b000000000000000000000000, data_out_b_l[7:0]} ;
        assign data_in_b_h = {3'b000, data_out_b_h[32], 24'b000000000000000000000000, data_out_b_h[7:0]} ;
        assign address_b = 16'b0000000000000000;
        assign we_b = 8'b00000000;
        assign enable_b = 1'b0;
        assign rdl = 1'b0;
        assign clk_b = 1'b0;
      end // no_loader;
      //
       if (C_JTAG_LOADER_ENABLE == 1) begin : loader
        assign data_in_b_h = {3'b000, jtag_din[17], 24'b000000000000000000000000, jtag_din[16:9]} ;
        assign data_in_b_l = {3'b000, jtag_din[8],  24'b000000000000000000000000, jtag_din[7:0]} ;
        assign address_b = {1'b0, jtag_addr[11:0], 3'b000};
        assign we_b = {jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we, jtag_we};
        assign enable_b = jtag_en[0];
        assign rdl = rdl_bus[0];
        assign clk_b = jtag_clk;
      end // loader;
  // 
  RAMB36E1 #( 
  	.READ_WIDTH_A 		(9),
  	.WRITE_WIDTH_A 		(9),
	.DOA_REG 		(0),
	.INIT_A 		(36'h000000000),
	.RSTREG_PRIORITY_A 	("REGCE"),
	.SRVAL_A 		(36'h000000000),
	.WRITE_MODE_A 		("WRITE_FIRST"),
	.READ_WIDTH_B 		(9),
	.WRITE_WIDTH_B 		(9),
	.DOB_REG 		(0),
	.INIT_B 		(36'h000000000),
	.RSTREG_PRIORITY_B 	("REGCE"),
	.SRVAL_B 		(36'h000000000),
	.WRITE_MODE_B 		("WRITE_FIRST"),
	.INIT_FILE 		("NONE"),
	.SIM_COLLISION_CHECK 	("ALL"),
	.RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
	.RAM_MODE 		("TDP"),
	.EN_ECC_READ 		("FALSE"),
	.EN_ECC_WRITE 		("FALSE"),
	.RAM_EXTENSION_A 	("NONE"),
	.RAM_EXTENSION_B 	("NONE"),
	.INIT_00 		(256'h{[8:0]_INIT_00}),
	.INIT_01 		(256'h{[8:0]_INIT_01}),
	.INIT_02 		(256'h{[8:0]_INIT_02}),
	.INIT_03 		(256'h{[8:0]_INIT_03}),
	.INIT_04 		(256'h{[8:0]_INIT_04}),
	.INIT_05 		(256'h{[8:0]_INIT_05}),
	.INIT_06 		(256'h{[8:0]_INIT_06}),
	.INIT_07 		(256'h{[8:0]_INIT_07}),
	.INIT_08 		(256'h{[8:0]_INIT_08}),
	.INIT_09 		(256'h{[8:0]_INIT_09}),
	.INIT_0A 		(256'h{[8:0]_INIT_0A}),
	.INIT_0B 		(256'h{[8:0]_INIT_0B}),
	.INIT_0C 		(256'h{[8:0]_INIT_0C}),
	.INIT_0D 		(256'h{[8:0]_INIT_0D}),
	.INIT_0E 		(256'h{[8:0]_INIT_0E}),
	.INIT_0F 		(256'h{[8:0]_INIT_0F}),
	.INIT_10 		(256'h{[8:0]_INIT_10}),
	.INIT_11 		(256'h{[8:0]_INIT_11}),
	.INIT_12 		(256'h{[8:0]_INIT_12}),
	.INIT_13 		(256'h{[8:0]_INIT_13}),
	.INIT_14 		(256'h{[8:0]_INIT_14}),
	.INIT_15 		(256'h{[8:0]_INIT_15}),
	.INIT_16 		(256'h{[8:0]_INIT_16}),
	.INIT_17 		(256'h{[8:0]_INIT_17}),
	.INIT_18 		(256'h{[8:0]_INIT_18}),
	.INIT_19 		(256'h{[8:0]_INIT_19}),
	.INIT_1A 		(256'h{[8:0]_INIT_1A}),
	.INIT_1B 		(256'h{[8:0]_INIT_1B}),
	.INIT_1C 		(256'h{[8:0]_INIT_1C}),
	.INIT_1D 		(256'h{[8:0]_INIT_1D}),
	.INIT_1E 		(256'h{[8:0]_INIT_1E}),
	.INIT_1F 		(256'h{[8:0]_INIT_1F}),
	.INIT_20 		(256'h{[8:0]_INIT_20}),
	.INIT_21 		(256'h{[8:0]_INIT_21}),
	.INIT_22 		(256'h{[8:0]_INIT_22}),
	.INIT_23 		(256'h{[8:0]_INIT_23}),
	.INIT_24 		(256'h{[8:0]_INIT_24}),
	.INIT_25 		(256'h{[8:0]_INIT_25}),
	.INIT_26 		(256'h{[8:0]_INIT_26}),
	.INIT_27 		(256'h{[8:0]_INIT_27}),
	.INIT_28 		(256'h{[8:0]_INIT_28}),
	.INIT_29 		(256'h{[8:0]_INIT_29}),
	.INIT_2A 		(256'h{[8:0]_INIT_2A}),
	.INIT_2B 		(256'h{[8:0]_INIT_2B}),
	.INIT_2C 		(256'h{[8:0]_INIT_2C}),
	.INIT_2D 		(256'h{[8:0]_INIT_2D}),
	.INIT_2E 		(256'h{[8:0]_INIT_2E}),
	.INIT_2F 		(256'h{[8:0]_INIT_2F}),
	.INIT_30 		(256'h{[8:0]_INIT_30}),
	.INIT_31 		(256'h{[8:0]_INIT_31}),
	.INIT_32 		(256'h{[8:0]_INIT_32}),
	.INIT_33 		(256'h{[8:0]_INIT_33}),
	.INIT_34 		(256'h{[8:0]_INIT_34}),
	.INIT_35 		(256'h{[8:0]_INIT_35}),
	.INIT_36 		(256'h{[8:0]_INIT_36}),
	.INIT_37 		(256'h{[8:0]_INIT_37}),
	.INIT_38 		(256'h{[8:0]_INIT_38}),
	.INIT_39 		(256'h{[8:0]_INIT_39}),
	.INIT_3A 		(256'h{[8:0]_INIT_3A}),
	.INIT_3B 		(256'h{[8:0]_INIT_3B}),
	.INIT_3C 		(256'h{[8:0]_INIT_3C}),
	.INIT_3D 		(256'h{[8:0]_INIT_3D}),
	.INIT_3E 		(256'h{[8:0]_INIT_3E}),
	.INIT_3F 		(256'h{[8:0]_INIT_3F}),
	.INIT_40 		(256'h{[8:0]_INIT_40}),
	.INIT_41 		(256'h{[8:0]_INIT_41}),
	.INIT_42 		(256'h{[8:0]_INIT_42}),
	.INIT_43 		(256'h{[8:0]_INIT_43}),
	.INIT_44 		(256'h{[8:0]_INIT_44}),
	.INIT_45 		(256'h{[8:0]_INIT_45}),
	.INIT_46 		(256'h{[8:0]_INIT_46}),
	.INIT_47 		(256'h{[8:0]_INIT_47}),
	.INIT_48 		(256'h{[8:0]_INIT_48}),
	.INIT_49 		(256'h{[8:0]_INIT_49}),
	.INIT_4A 		(256'h{[8:0]_INIT_4A}),
	.INIT_4B 		(256'h{[8:0]_INIT_4B}),
	.INIT_4C 		(256'h{[8:0]_INIT_4C}),
	.INIT_4D 		(256'h{[8:0]_INIT_4D}),
	.INIT_4E 		(256'h{[8:0]_INIT_4E}),
	.INIT_4F 		(256'h{[8:0]_INIT_4F}),
	.INIT_50 		(256'h{[8:0]_INIT_50}),
	.INIT_51 		(256'h{[8:0]_INIT_51}),
	.INIT_52 		(256'h{[8:0]_INIT_52}),
	.INIT_53 		(256'h{[8:0]_INIT_53}),
	.INIT_54 		(256'h{[8:0]_INIT_54}),
	.INIT_55 		(256'h{[8:0]_INIT_55}),
	.INIT_56 		(256'h{[8:0]_INIT_56}),
	.INIT_57 		(256'h{[8:0]_INIT_57}),
	.INIT_58 		(256'h{[8:0]_INIT_58}),
	.INIT_59 		(256'h{[8:0]_INIT_59}),
	.INIT_5A 		(256'h{[8:0]_INIT_5A}),
	.INIT_5B 		(256'h{[8:0]_INIT_5B}),
	.INIT_5C 		(256'h{[8:0]_INIT_5C}),
	.INIT_5D 		(256'h{[8:0]_INIT_5D}),
	.INIT_5E 		(256'h{[8:0]_INIT_5E}),
	.INIT_5F 		(256'h{[8:0]_INIT_5F}),
	.INIT_60 		(256'h{[8:0]_INIT_60}),
	.INIT_61 		(256'h{[8:0]_INIT_61}),
	.INIT_62 		(256'h{[8:0]_INIT_62}),
	.INIT_63 		(256'h{[8:0]_INIT_63}),
	.INIT_64 		(256'h{[8:0]_INIT_64}),
	.INIT_65 		(256'h{[8:0]_INIT_65}),
	.INIT_66 		(256'h{[8:0]_INIT_66}),
	.INIT_67 		(256'h{[8:0]_INIT_67}),
	.INIT_68 		(256'h{[8:0]_INIT_68}),
	.INIT_69 		(256'h{[8:0]_INIT_69}),
	.INIT_6A 		(256'h{[8:0]_INIT_6A}),
	.INIT_6B 		(256'h{[8:0]_INIT_6B}),
	.INIT_6C 		(256'h{[8:0]_INIT_6C}),
	.INIT_6D 		(256'h{[8:0]_INIT_6D}),
	.INIT_6E 		(256'h{[8:0]_INIT_6E}),
	.INIT_6F 		(256'h{[8:0]_INIT_6F}),
	.INIT_70 		(256'h{[8:0]_INIT_70}),
	.INIT_71 		(256'h{[8:0]_INIT_71}),
	.INIT_72 		(256'h{[8:0]_INIT_72}),
	.INIT_73 		(256'h{[8:0]_INIT_73}),
	.INIT_74 		(256'h{[8:0]_INIT_74}),
	.INIT_75 		(256'h{[8:0]_INIT_75}),
	.INIT_76 		(256'h{[8:0]_INIT_76}),
	.INIT_77 		(256'h{[8:0]_INIT_77}),
	.INIT_78 		(256'h{[8:0]_INIT_78}),
	.INIT_79 		(256'h{[8:0]_INIT_79}),
	.INIT_7A 		(256'h{[8:0]_INIT_7A}),
	.INIT_7B 		(256'h{[8:0]_INIT_7B}),
	.INIT_7C 		(256'h{[8:0]_INIT_7C}),
	.INIT_7D 		(256'h{[8:0]_INIT_7D}),
	.INIT_7E 		(256'h{[8:0]_INIT_7E}),
	.INIT_7F 		(256'h{[8:0]_INIT_7F}),
	.INITP_00 		(256'h{[8:0]_INITP_00}),
	.INITP_01 		(256'h{[8:0]_INITP_01}),
	.INITP_02 		(256'h{[8:0]_INITP_02}),
	.INITP_03 		(256'h{[8:0]_INITP_03}),
	.INITP_04 		(256'h{[8:0]_INITP_04}),
	.INITP_05 		(256'h{[8:0]_INITP_05}),
	.INITP_06 		(256'h{[8:0]_INITP_06}),
	.INITP_07 		(256'h{[8:0]_INITP_07}),
	.INITP_08 		(256'h{[8:0]_INITP_08}),
	.INITP_09 		(256'h{[8:0]_INITP_09}),
	.INITP_0A 		(256'h{[8:0]_INITP_0A}),
	.INITP_0B 		(256'h{[8:0]_INITP_0B}),
	.INITP_0C 		(256'h{[8:0]_INITP_0C}),
	.INITP_0D 		(256'h{[8:0]_INITP_0D}),
	.INITP_0E 		(256'h{[8:0]_INITP_0E}),
	.INITP_0F 		(256'h{[8:0]_INITP_0F}))
  kcpsm6_rom_l(  
  	.ADDRARDADDR		(address_a),
	.ENARDEN		(enable),
	.CLKARDCLK		(clk),
	.DOADO			(data_out_a_l[31:0]),
	.DOPADOP		(data_out_a_l[35:32]), 
	.DIADI			(data_in_a[31:0]),
	.DIPADIP		(data_in_a[35:32]), 
	.WEA			(4'b0000),
	.REGCEAREGCE		(1'b0),
	.RSTRAMARSTRAM		(1'b0),
	.RSTREGARSTREG		(1'b0),
	.ADDRBWRADDR		(address_b),
	.ENBWREN		(enable_b),
	.CLKBWRCLK		(clk_b),
	.DOBDO			(data_out_b_l[31:0]),
	.DOPBDOP		(data_out_b_l[35:32]), 
	.DIBDI			(data_in_b_l[31:0]),
	.DIPBDIP		(data_in_b_l[35:32]), 
	.WEBWE			(we_b),
	.REGCEB			(1'b0),
	.RSTRAMB		(1'b0),
	.RSTREGB		(1'b0),
	.CASCADEINA 		(1'b0),
	.CASCADEINB 		(1'b0),
	.CASCADEOUTA		(),
	.CASCADEOUTB		(),
	.DBITERR		(),
	.ECCPARITY		(),
	.RDADDRECC		(),
	.SBITERR		(),
	.INJECTDBITERR 		(1'b0),      
	.INJECTSBITERR 		(1'b0));   

  RAMB36E1 #( 
  	.READ_WIDTH_A 		(9),
  	.WRITE_WIDTH_A 		(9),
	.DOA_REG 		(0),
	.INIT_A 		(36'h000000000),
	.RSTREG_PRIORITY_A 	("REGCE"),
	.SRVAL_A 		(36'h000000000),
	.WRITE_MODE_A 		("WRITE_FIRST"),
	.READ_WIDTH_B 		(9),
	.WRITE_WIDTH_B 		(9),
	.DOB_REG 		(0),
	.INIT_B 		(36'h000000000),
	.RSTREG_PRIORITY_B 	("REGCE"),
	.SRVAL_B 		(36'h000000000),
	.WRITE_MODE_B 		("WRITE_FIRST"),
	.INIT_FILE 		("NONE"),
	.SIM_COLLISION_CHECK 	("ALL"),
	.RDADDR_COLLISION_HWCONFIG ("DELAYED_WRITE"),
	.RAM_MODE 		("TDP"),
	.EN_ECC_READ 		("FALSE"),
	.EN_ECC_WRITE 		("FALSE"),
	.RAM_EXTENSION_A 	("NONE"),
	.RAM_EXTENSION_B 	("NONE"),
	.INIT_00 		(256'h{[17:9]_INIT_00}),
	.INIT_01 		(256'h{[17:9]_INIT_01}),
	.INIT_02 		(256'h{[17:9]_INIT_02}),
	.INIT_03 		(256'h{[17:9]_INIT_03}),
	.INIT_04 		(256'h{[17:9]_INIT_04}),
	.INIT_05 		(256'h{[17:9]_INIT_05}),
	.INIT_06 		(256'h{[17:9]_INIT_06}),
	.INIT_07 		(256'h{[17:9]_INIT_07}),
	.INIT_08 		(256'h{[17:9]_INIT_08}),
	.INIT_09 		(256'h{[17:9]_INIT_09}),
	.INIT_0A 		(256'h{[17:9]_INIT_0A}),
	.INIT_0B 		(256'h{[17:9]_INIT_0B}),
	.INIT_0C 		(256'h{[17:9]_INIT_0C}),
	.INIT_0D 		(256'h{[17:9]_INIT_0D}),
	.INIT_0E 		(256'h{[17:9]_INIT_0E}),
	.INIT_0F 		(256'h{[17:9]_INIT_0F}),
	.INIT_10 		(256'h{[17:9]_INIT_10}),
	.INIT_11 		(256'h{[17:9]_INIT_11}),
	.INIT_12 		(256'h{[17:9]_INIT_12}),
	.INIT_13 		(256'h{[17:9]_INIT_13}),
	.INIT_14 		(256'h{[17:9]_INIT_14}),
	.INIT_15 		(256'h{[17:9]_INIT_15}),
	.INIT_16 		(256'h{[17:9]_INIT_16}),
	.INIT_17 		(256'h{[17:9]_INIT_17}),
	.INIT_18 		(256'h{[17:9]_INIT_18}),
	.INIT_19 		(256'h{[17:9]_INIT_19}),
	.INIT_1A 		(256'h{[17:9]_INIT_1A}),
	.INIT_1B 		(256'h{[17:9]_INIT_1B}),
	.INIT_1C 		(256'h{[17:9]_INIT_1C}),
	.INIT_1D 		(256'h{[17:9]_INIT_1D}),
	.INIT_1E 		(256'h{[17:9]_INIT_1E}),
	.INIT_1F 		(256'h{[17:9]_INIT_1F}),
	.INIT_20 		(256'h{[17:9]_INIT_20}),
	.INIT_21 		(256'h{[17:9]_INIT_21}),
	.INIT_22 		(256'h{[17:9]_INIT_22}),
	.INIT_23 		(256'h{[17:9]_INIT_23}),
	.INIT_24 		(256'h{[17:9]_INIT_24}),
	.INIT_25 		(256'h{[17:9]_INIT_25}),
	.INIT_26 		(256'h{[17:9]_INIT_26}),
	.INIT_27 		(256'h{[17:9]_INIT_27}),
	.INIT_28 		(256'h{[17:9]_INIT_28}),
	.INIT_29 		(256'h{[17:9]_INIT_29}),
	.INIT_2A 		(256'h{[17:9]_INIT_2A}),
	.INIT_2B 		(256'h{[17:9]_INIT_2B}),
	.INIT_2C 		(256'h{[17:9]_INIT_2C}),
	.INIT_2D 		(256'h{[17:9]_INIT_2D}),
	.INIT_2E 		(256'h{[17:9]_INIT_2E}),
	.INIT_2F 		(256'h{[17:9]_INIT_2F}),
	.INIT_30 		(256'h{[17:9]_INIT_30}),
	.INIT_31 		(256'h{[17:9]_INIT_31}),
	.INIT_32 		(256'h{[17:9]_INIT_32}),
	.INIT_33 		(256'h{[17:9]_INIT_33}),
	.INIT_34 		(256'h{[17:9]_INIT_34}),
	.INIT_35 		(256'h{[17:9]_INIT_35}),
	.INIT_36 		(256'h{[17:9]_INIT_36}),
	.INIT_37 		(256'h{[17:9]_INIT_37}),
	.INIT_38 		(256'h{[17:9]_INIT_38}),
	.INIT_39 		(256'h{[17:9]_INIT_39}),
	.INIT_3A 		(256'h{[17:9]_INIT_3A}),
	.INIT_3B 		(256'h{[17:9]_INIT_3B}),
	.INIT_3C 		(256'h{[17:9]_INIT_3C}),
	.INIT_3D 		(256'h{[17:9]_INIT_3D}),
	.INIT_3E 		(256'h{[17:9]_INIT_3E}),
	.INIT_3F 		(256'h{[17:9]_INIT_3F}),
	.INIT_40 		(256'h{[17:9]_INIT_40}),
	.INIT_41 		(256'h{[17:9]_INIT_41}),
	.INIT_42 		(256'h{[17:9]_INIT_42}),
	.INIT_43 		(256'h{[17:9]_INIT_43}),
	.INIT_44 		(256'h{[17:9]_INIT_44}),
	.INIT_45 		(256'h{[17:9]_INIT_45}),
	.INIT_46 		(256'h{[17:9]_INIT_46}),
	.INIT_47 		(256'h{[17:9]_INIT_47}),
	.INIT_48 		(256'h{[17:9]_INIT_48}),
	.INIT_49 		(256'h{[17:9]_INIT_49}),
	.INIT_4A 		(256'h{[17:9]_INIT_4A}),
	.INIT_4B 		(256'h{[17:9]_INIT_4B}),
	.INIT_4C 		(256'h{[17:9]_INIT_4C}),
	.INIT_4D 		(256'h{[17:9]_INIT_4D}),
	.INIT_4E 		(256'h{[17:9]_INIT_4E}),
	.INIT_4F 		(256'h{[17:9]_INIT_4F}),
	.INIT_50 		(256'h{[17:9]_INIT_50}),
	.INIT_51 		(256'h{[17:9]_INIT_51}),
	.INIT_52 		(256'h{[17:9]_INIT_52}),
	.INIT_53 		(256'h{[17:9]_INIT_53}),
	.INIT_54 		(256'h{[17:9]_INIT_54}),
	.INIT_55 		(256'h{[17:9]_INIT_55}),
	.INIT_56 		(256'h{[17:9]_INIT_56}),
	.INIT_57 		(256'h{[17:9]_INIT_57}),
	.INIT_58 		(256'h{[17:9]_INIT_58}),
	.INIT_59 		(256'h{[17:9]_INIT_59}),
	.INIT_5A 		(256'h{[17:9]_INIT_5A}),
	.INIT_5B 		(256'h{[17:9]_INIT_5B}),
	.INIT_5C 		(256'h{[17:9]_INIT_5C}),
	.INIT_5D 		(256'h{[17:9]_INIT_5D}),
	.INIT_5E 		(256'h{[17:9]_INIT_5E}),
	.INIT_5F 		(256'h{[17:9]_INIT_5F}),
	.INIT_60 		(256'h{[17:9]_INIT_60}),
	.INIT_61 		(256'h{[17:9]_INIT_61}),
	.INIT_62 		(256'h{[17:9]_INIT_62}),
	.INIT_63 		(256'h{[17:9]_INIT_63}),
	.INIT_64 		(256'h{[17:9]_INIT_64}),
	.INIT_65 		(256'h{[17:9]_INIT_65}),
	.INIT_66 		(256'h{[17:9]_INIT_66}),
	.INIT_67 		(256'h{[17:9]_INIT_67}),
	.INIT_68 		(256'h{[17:9]_INIT_68}),
	.INIT_69 		(256'h{[17:9]_INIT_69}),
	.INIT_6A 		(256'h{[17:9]_INIT_6A}),
	.INIT_6B 		(256'h{[17:9]_INIT_6B}),
	.INIT_6C 		(256'h{[17:9]_INIT_6C}),
	.INIT_6D 		(256'h{[17:9]_INIT_6D}),
	.INIT_6E 		(256'h{[17:9]_INIT_6E}),
	.INIT_6F 		(256'h{[17:9]_INIT_6F}),
	.INIT_70 		(256'h{[17:9]_INIT_70}),
	.INIT_71 		(256'h{[17:9]_INIT_71}),
	.INIT_72 		(256'h{[17:9]_INIT_72}),
	.INIT_73 		(256'h{[17:9]_INIT_73}),
	.INIT_74 		(256'h{[17:9]_INIT_74}),
	.INIT_75 		(256'h{[17:9]_INIT_75}),
	.INIT_76 		(256'h{[17:9]_INIT_76}),
	.INIT_77 		(256'h{[17:9]_INIT_77}),
	.INIT_78 		(256'h{[17:9]_INIT_78}),
	.INIT_79 		(256'h{[17:9]_INIT_79}),
	.INIT_7A 		(256'h{[17:9]_INIT_7A}),
	.INIT_7B 		(256'h{[17:9]_INIT_7B}),
	.INIT_7C 		(256'h{[17:9]_INIT_7C}),
	.INIT_7D 		(256'h{[17:9]_INIT_7D}),
	.INIT_7E 		(256'h{[17:9]_INIT_7E}),
	.INIT_7F 		(256'h{[17:9]_INIT_7F}),
	.INITP_00 		(256'h{[17:9]_INITP_00}),
	.INITP_01 		(256'h{[17:9]_INITP_01}),
	.INITP_02 		(256'h{[17:9]_INITP_02}),
	.INITP_03 		(256'h{[17:9]_INITP_03}),
	.INITP_04 		(256'h{[17:9]_INITP_04}),
	.INITP_05 		(256'h{[17:9]_INITP_05}),
	.INITP_06 		(256'h{[17:9]_INITP_06}),
	.INITP_07 		(256'h{[17:9]_INITP_07}),
	.INITP_08 		(256'h{[17:9]_INITP_08}),
	.INITP_09 		(256'h{[17:9]_INITP_09}),
	.INITP_0A 		(256'h{[17:9]_INITP_0A}),
	.INITP_0B 		(256'h{[17:9]_INITP_0B}),
	.INITP_0C 		(256'h{[17:9]_INITP_0C}),
	.INITP_0D 		(256'h{[17:9]_INITP_0D}),
	.INITP_0E 		(256'h{[17:9]_INITP_0E}),
	.INITP_0F 		(256'h{[17:9]_INITP_0F}))
  kcpsm6_rom_h(  
  	.ADDRARDADDR		(address_a),
	.ENARDEN		(enable),
	.CLKARDCLK		(clk),
	.DOADO			(data_out_a_h[31:0]),
	.DOPADOP		(data_out_a_h[35:32]), 
	.DIADI			(data_in_a[31:0]),
	.DIPADIP		(data_in_a[35:32]), 
	.WEA			(4'b0000),
	.REGCEAREGCE		(1'b0),
	.RSTRAMARSTRAM		(1'b0),
	.RSTREGARSTREG		(1'b0),
	.ADDRBWRADDR		(address_b),
	.ENBWREN		(enable_b),
	.CLKBWRCLK		(clk_b),
	.DOBDO			(data_out_b_h[31:0]),
	.DOPBDOP		(data_out_b_h[35:32]), 
	.DIBDI			(data_in_b_h[31:0]),
	.DIPBDIP		(data_in_b_h[35:32]), 
	.WEBWE			(we_b),
	.REGCEB			(1'b0),
	.RSTRAMB		(1'b0),
	.RSTREGB		(1'b0),
	.CASCADEINA 		(1'b0),
	.CASCADEINB 		(1'b0),
	.CASCADEOUTA		(),
	.CASCADEOUTB		(),
	.DBITERR		(),
	.ECCPARITY		(),
	.RDADDRECC		(),
	.SBITERR		(),
	.INJECTDBITERR 		(1'b0),      
	.INJECTSBITERR 		(1'b0));     
	                              
  end // v6;  
 end // ram_4k_generate;
endgenerate      
            
  // Instantiate the JTAG Loader block
generate
  if (C_JTAG_LOADER_ENABLE == 1) begin: instantiate_loader

jtag_loader_6  #(
	.C_FAMILY 		(C_FAMILY),
	.C_NUM_PICOBLAZE 	(1),
	.C_JTAG_LOADER_ENABLE	(C_JTAG_LOADER_ENABLE),        
	.C_BRAM_MAX_ADDR_WIDTH	(BRAM_ADDRESS_WIDTH),        
	.C_ADDR_WIDTH_0 	(BRAM_ADDRESS_WIDTH))
jtag_loader_6_inst( 
	.picoblaze_reset 	(rdl_bus),
	.jtag_en 		(jtag_en),
	.jtag_din 		(jtag_din),
	.jtag_addr 		(jtag_addr[BRAM_ADDRESS_WIDTH-1 : 0]),
	.jtag_clk 		(jtag_clk),
	.jtag_we 		(jtag_we),
	.jtag_dout_0 		(jtag_dout),
	.jtag_dout_1 		(jtag_dout), 		// ports 1-7 are not used
	.jtag_dout_2 		(jtag_dout), 		// in a 1 device debug 
	.jtag_dout_3 		(jtag_dout), 		// session.  However, Synplify
	.jtag_dout_4 		(jtag_dout), 		// etc require all ports are
	.jtag_dout_5 		(jtag_dout), 		// connected
	.jtag_dout_6 		(jtag_dout),
	.jtag_dout_7 		(jtag_dout));  
    
  end //instantiate_loader
endgenerate 
//
//
endmodule
//
//
// JTAG Loader 6 - Version 6.00
// Kris Chaplin 4 February 2010

`timescale 1ps/1ps

module jtag_loader_6 (picoblaze_reset, jtag_en, jtag_din, jtag_addr, jtag_clk, jtag_we, jtag_dout_0, jtag_dout_1, jtag_dout_2, jtag_dout_3, jtag_dout_4, jtag_dout_5, jtag_dout_6, jtag_dout_7) ;

parameter integer 	C_JTAG_LOADER_ENABLE = 1 ;
parameter 	 	C_FAMILY = "V6" ;
parameter integer 	C_NUM_PICOBLAZE = 1 ;
parameter integer 	C_BRAM_MAX_ADDR_WIDTH = 10 ;
parameter integer 	C_PICOBLAZE_INSTRUCTION_DATA_WIDTH = 18 ;
parameter integer 	C_JTAG_CHAIN = 2 ;
parameter [4:0] 	C_ADDR_WIDTH_0 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_1 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_2 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_3 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_4 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_5 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_6 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_7 = 10 ;

output	[C_NUM_PICOBLAZE-1:0]				picoblaze_reset ;
output	[C_NUM_PICOBLAZE-1:0]     			jtag_en ; 		//(others (1'b0);
output	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_din ; 		//(others (1'b0);
output	[C_BRAM_MAX_ADDR_WIDTH-1:0]			jtag_addr ; 		// (others (1'b0);
output							jtag_clk  ; 		//:= 1'b0;
output							jtag_we ; 		//:= 1'b0;
input	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_0 ;
input	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_1 ;
input	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_2 ;
input	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_3 ;
input	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_4 ;
input	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_5 ;
input	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_6 ;
input	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_7 ;

wire							shift_clk ;
wire							shift_din ;
wire							shift_dout ;
wire							shift ;
wire							capture ;
wire							control_reg_ce ;
wire	[C_NUM_PICOBLAZE-1:0]				bram_ce ;
wire	[C_NUM_PICOBLAZE-1:0]				bus_zero ; 				//:= (others (1'b0);
wire	[C_NUM_PICOBLAZE-1:0]				jtag_en_int ;
wire	[7:0]						jtag_en_expanded ; 			//:= (others (1'b0);
wire	[C_BRAM_MAX_ADDR_WIDTH-1:0]			jtag_addr_int ;
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_din_int ;
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	control_din ;				//:= (others (1'b0);
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	control_dout ;				//:= (others (1'b0);
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	bram_dout_int ;				//:= (others (1'b0);
wire							jtag_we_int ;
wire							jtag_clk_int ;
wire							bram_ce_valid ;
reg							din_load ;
						
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_0_masked ;
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_1_masked ;
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_2_masked ;
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_3_masked ;
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_4_masked ;
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_5_masked ;
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_6_masked ;
wire	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	jtag_dout_7_masked ;
wire	[C_NUM_PICOBLAZE-1:0]				picoblaze_reset_int ; 			//:= (others (1'b0);

genvar i ;
generate
for (i = 0 ; i <= C_NUM_PICOBLAZE-1 ; i = i+1)
begin : npzero_loop
assign bus_zero[i] = 1'b0 ;
end
endgenerate

generate
if (C_JTAG_LOADER_ENABLE == 1)
begin : jtag_loader_gen

bscan_logic # (
	.C_JTAG_CHAIN 				(C_JTAG_CHAIN),
        .C_BUFFER_SHIFT_CLOCK 			("TRUE"),
	.C_FAMILY 				(C_FAMILY ))
Inst_bscan_logic(
	.shift_dout 				(shift_dout),
	.shift_clk 				(shift_clk),
	.bram_en 				(bram_ce_valid),
	.shift_din 				(shift_din),
        .bram_strobe 				(jtag_clk_int),
	.capture 				(capture),
	.shift 					(shift) );
                
jtag_shifter # (
	.C_NUM_PICOBLAZE 			(C_NUM_PICOBLAZE),
	.C_BRAM_MAX_ADDR_WIDTH 			(C_BRAM_MAX_ADDR_WIDTH),
	.C_PICOBLAZE_INSTRUCTION_DATA_WIDTH 	(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH) )       
Inst_jtag_shifter(
	.shift_clk 				(shift_clk),
	.shift_din 				(shift_din),
	.shift 					(shift),
	.shift_dout 				(shift_dout),
	.control_reg_ce 			(control_reg_ce),
	.bram_ce 				(bram_ce),
	.bram_a 				(jtag_addr_int),
	.din_load 				(din_load),
	.din 					(bram_dout_int),
	.bram_d 				(jtag_din_int),
	.bram_we 				(jtag_we_int) );

always @ (bram_ce or din_load or capture or bus_zero or control_reg_ce) begin
if ( bram_ce == bus_zero ) begin
        din_load <= capture & control_reg_ce ;
end else begin
        din_load <= capture ;
end
end

control_registers # (
	.C_NUM_PICOBLAZE 			(C_NUM_PICOBLAZE),
	.C_PICOBLAZE_INSTRUCTION_DATA_WIDTH 	(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH),
	.C_ADDR_WIDTH_0 			(C_ADDR_WIDTH_0),
	.C_ADDR_WIDTH_1 			(C_ADDR_WIDTH_1),
	.C_ADDR_WIDTH_2 			(C_ADDR_WIDTH_2),
	.C_ADDR_WIDTH_3 			(C_ADDR_WIDTH_3),
	.C_ADDR_WIDTH_4 			(C_ADDR_WIDTH_4),
	.C_ADDR_WIDTH_5 			(C_ADDR_WIDTH_5),
	.C_ADDR_WIDTH_6 			(C_ADDR_WIDTH_6),
	.C_ADDR_WIDTH_7 			(C_ADDR_WIDTH_7),
	.C_BRAM_MAX_ADDR_WIDTH 			(C_BRAM_MAX_ADDR_WIDTH))
Inst_control_registers(
	.en 					(bram_ce_valid),
	.ce 					(control_reg_ce),
	.wnr 					(jtag_we_int),
	.clk 					(jtag_clk_int),
	.a 					(jtag_addr_int[3:0]),
	.din 					(control_din[C_NUM_PICOBLAZE-1 : 0]),
	.dout 					(control_dout[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-8]),
	.picoblaze_reset 			(picoblaze_reset_int));

if (C_PICOBLAZE_INSTRUCTION_DATA_WIDTH > 8) begin
assign control_dout[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-9:0] = 9'h000 ;
end

// Qualify the blockram CS signal with bscan select output
assign jtag_en_int = (bram_ce_valid) ? bram_ce : bus_zero ;

assign jtag_en_expanded[C_NUM_PICOBLAZE-1:0] = jtag_en_int;
//jtag_en_expanded(7:C_NUM_PICOBLAZE) <= (others => 1'b0) when (C_NUM_PICOBLAZE < 8);

//generate
for (i = 7 ; i >= C_NUM_PICOBLAZE ; i = i-1)
begin : loop4 
if (C_NUM_PICOBLAZE < 8) begin : jtag_en_expanded_gen
assign jtag_en_expanded[i] = 1'b0 ;
end
end
//endgenerate

assign bram_dout_int = control_dout | jtag_dout_0_masked | jtag_dout_1_masked | jtag_dout_2_masked | jtag_dout_3_masked | jtag_dout_4_masked | jtag_dout_5_masked | jtag_dout_6_masked | jtag_dout_7_masked;

assign control_din = jtag_din_int;

assign jtag_dout_0_masked = (jtag_en_expanded[0]) ? jtag_dout_0 : 18'h00000 ;
assign jtag_dout_1_masked = (jtag_en_expanded[1]) ? jtag_dout_1 : 18'h00000 ;
assign jtag_dout_2_masked = (jtag_en_expanded[2]) ? jtag_dout_2 : 18'h00000 ;
assign jtag_dout_3_masked = (jtag_en_expanded[3]) ? jtag_dout_3 : 18'h00000 ;
assign jtag_dout_4_masked = (jtag_en_expanded[4]) ? jtag_dout_4 : 18'h00000 ;
assign jtag_dout_5_masked = (jtag_en_expanded[5]) ? jtag_dout_5 : 18'h00000 ;
assign jtag_dout_6_masked = (jtag_en_expanded[6]) ? jtag_dout_6 : 18'h00000 ;
assign jtag_dout_7_masked = (jtag_en_expanded[7]) ? jtag_dout_7 : 18'h00000 ;
        
end
endgenerate


assign jtag_en = jtag_en_int;
assign jtag_din = jtag_din_int;
assign jtag_addr = jtag_addr_int;
assign jtag_clk = jtag_clk_int;
assign jtag_we = jtag_we_int;
assign picoblaze_reset = picoblaze_reset_int;

endmodule

`timescale 1ps/1ps

module control_registers (en, ce, wnr, clk, a, din, dout, picoblaze_reset) ;

parameter integer 	C_NUM_PICOBLAZE = 1 ;
parameter integer 	C_BRAM_MAX_ADDR_WIDTH = 10 ;
parameter integer 	C_PICOBLAZE_INSTRUCTION_DATA_WIDTH = 18 ;
parameter integer 	C_JTAG_CHAIN = 2 ;
parameter [4:0] 	C_ADDR_WIDTH_0 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_1 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_2 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_3 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_4 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_5 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_6 = 10 ;
parameter [4:0] 	C_ADDR_WIDTH_7 = 10 ;
                      
input				en ;
input   			ce ;
input				wnr ;
input				clk ;
input	[3:0]			a ;
input	[C_NUM_PICOBLAZE-1:0]	din ;
output	[7:0]			dout ;
output	[C_NUM_PICOBLAZE-1:0]	picoblaze_reset ;

wire	[7:0]			version  ; 				//:= "00000001";
reg	[C_NUM_PICOBLAZE-1:0]	picoblaze_reset_int ;			//:= (others (1'b0);
wire	[C_NUM_PICOBLAZE-1:0]	picoblaze_wait_int ;			//:= (others (1'b0);
reg	[7:0]			dout_int ;				//:= (others (1'b0);

wire	[2:0]			num_picoblaze ; 			// := conv_std_logic_vector(C_NUM_PICOBLAZE-1,3);
        
wire	[4:0]			picoblaze_instruction_data_width ;	// := conv_std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1,5);

initial picoblaze_reset_int = 0 ;

assign num_picoblaze = C_NUM_PICOBLAZE-3'h1 ;
assign picoblaze_instruction_data_width = C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-5'h01 ;

always @ (posedge clk) begin
        if (en == 1'b1 && wnr == 1'b0 && ce == 1'b1) begin
                case (a) 
                0 :							// 0 = version - returns (7:4) illustrating number of PB
                               						// and [3:0] picoblaze instruction data width
                        dout_int <= {num_picoblaze, picoblaze_instruction_data_width};
                1 : 							// 1 = PicoBlaze 0 reset / status
                        if (C_NUM_PICOBLAZE >= 1) begin 
                                dout_int <= {picoblaze_reset_int[0], 2'b00, C_ADDR_WIDTH_0-5'h01};
                        end else begin
                                dout_int <= 8'h00 ;
                        end
                2 :							// 2 = PicoBlaze 1 reset / status
                        if (C_NUM_PICOBLAZE >= 2) begin 
                                dout_int <= {picoblaze_reset_int[1], 2'b00, C_ADDR_WIDTH_1-5'h01} ;
                        end else begin
                                dout_int <= 8'h00 ;
                        end
                3 : 							// 3 = PicoBlaze 2 reset / status
                        if (C_NUM_PICOBLAZE >= 3) begin 
                                dout_int <= {picoblaze_reset_int[2], 2'b00, C_ADDR_WIDTH_2-5'h01} ;
                        end else begin
                                dout_int <= 8'h00 ;
                        end
                4 : 							// 4 = PicoBlaze 3 reset / status
                        if (C_NUM_PICOBLAZE >= 4) begin 
                                dout_int <= {picoblaze_reset_int[3], 2'b00, C_ADDR_WIDTH_3-5'h01} ;
                        end else begin
                                dout_int <= 8'h00 ;
                        end
                5: 							// 5 = PicoBlaze 4 reset / status
                        if (C_NUM_PICOBLAZE >= 5) begin 
                                dout_int <= {picoblaze_reset_int[4], 2'b00, C_ADDR_WIDTH_4-5'h01} ;
                        end else begin
                                dout_int <= 8'h00 ;
                        end
                6 : 							// 6 = PicoBlaze 5 reset / status
                        if (C_NUM_PICOBLAZE >= 6) begin 
                                dout_int <= {picoblaze_reset_int[5], 2'b00, C_ADDR_WIDTH_5-5'h01} ;
                        end else begin
                                dout_int <= 8'h00 ;
                        end
                7 : 							// 7 = PicoBlaze 6 reset / status
                        if (C_NUM_PICOBLAZE >= 7) begin 
                                dout_int <= {picoblaze_reset_int[6], 2'b00, C_ADDR_WIDTH_6-5'h01} ;
                        end else begin
                                dout_int <= 8'h00 ;
                        end

                8 : 							// 8 = PicoBlaze 7 reset / status
                        if (C_NUM_PICOBLAZE >= 8) begin 
                                dout_int <= {picoblaze_reset_int[7], 2'b00, C_ADDR_WIDTH_7-5'h01} ;
                        end else begin
                                dout_int <= 8'h00 ;
                        end
                15 : 
                        dout_int <= C_BRAM_MAX_ADDR_WIDTH -1 ;
                default :
                        dout_int <= 8'h00 ;
                endcase
	end else begin
                dout_int <= 8'h00 ;
        end
end 

assign dout = dout_int;

always @ (posedge clk) begin
	if (en == 1'b1 && wnr == 1'b1 && ce == 1'b1) begin
		picoblaze_reset_int[C_NUM_PICOBLAZE-1:0] <= din[C_NUM_PICOBLAZE-1:0];
	end
end     

assign picoblaze_reset = picoblaze_reset_int ;

endmodule

`timescale 1ps/1ps

module jtag_shifter (shift_clk, shift_din, shift, shift_dout, control_reg_ce, bram_ce, bram_a, din_load, din, bram_d, bram_we) ;

parameter integer 	C_NUM_PICOBLAZE = 1 ;
parameter integer 	C_BRAM_MAX_ADDR_WIDTH = 10 ;
parameter integer 	C_PICOBLAZE_INSTRUCTION_DATA_WIDTH = 18 ;

input							shift_clk ;
input							shift_din ;
input							shift ;
output							shift_dout ;
output							control_reg_ce ;
output	[C_NUM_PICOBLAZE-1:0]				bram_ce ;
output	[C_BRAM_MAX_ADDR_WIDTH-1:0]			bram_a ;
input							din_load ;
input	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	din ;
output	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	bram_d ;
output							bram_we ;

reg							control_reg_ce_int ;
reg	[C_NUM_PICOBLAZE-1:0]				bram_ce_int ;		//:= (others (1'b0);
reg	[C_BRAM_MAX_ADDR_WIDTH-1:0]			bram_a_int ;		//:= (others (1'b0);
reg	[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1:0]	bram_d_int ; 		//:= (others (1'b0);
reg							bram_we_int ; 		//:= 1'b0;

always @ (posedge shift_clk) begin
	if (shift == 1'b1) begin
	        control_reg_ce_int <= shift_din;
	end
end

assign control_reg_ce = control_reg_ce_int;

always @ (posedge shift_clk) begin
	if (shift == 1'b1) begin
	        bram_ce_int[0] <= control_reg_ce_int ;
	end
end 

genvar i ;
generate
for (i = 0 ; i <= C_NUM_PICOBLAZE-2 ; i = i+1)
begin : loop0
if (C_NUM_PICOBLAZE > 1) begin
always @ (posedge shift_clk) begin
	if (shift == 1'b1) begin
	        bram_ce_int[i+1] <= bram_ce_int[i] ;
	end
end
end 
end
endgenerate

always @ (posedge shift_clk) begin
        if (shift == 1'b1) begin
		bram_we_int <= bram_ce_int[C_NUM_PICOBLAZE-1] ;
        end
end

always @ (posedge shift_clk) begin 
        if (shift == 1'b1) begin
               	bram_a_int[0] <= bram_we_int ;
        end
end

generate
for (i = 0 ; i <= C_BRAM_MAX_ADDR_WIDTH-2 ; i = i+1)
begin : loop1
always @ (posedge shift_clk) begin
	if (shift == 1'b1) begin
	        bram_a_int[i+1] <= bram_a_int[i] ;
	end
end 
end
endgenerate

always @ (posedge shift_clk) begin 
        if (din_load == 1'b1) begin
                bram_d_int[0] <= din[0] ;
        end
        else if (shift == 1'b1) begin
              	bram_d_int[0] <= bram_a_int[C_BRAM_MAX_ADDR_WIDTH-1] ;
        end
end

generate
for (i = 0 ; i <= C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-2 ; i = i+1)
begin : loop2
always @ (posedge shift_clk) begin
        if (din_load == 1'b1) begin
                bram_d_int[i+1] <= din[i+1] ;
        end
	if (shift == 1'b1) begin
	        bram_d_int[i+1] <= bram_d_int[i] ;
	end
end 
end
endgenerate

assign bram_ce = bram_ce_int;
assign bram_we = bram_we_int;
assign bram_d  = bram_d_int;
assign bram_a  = bram_a_int;
assign shift_dout = bram_d_int[C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1];

endmodule

`timescale 1ps/1ps

module bscan_logic (shift_dout, shift_clk, bram_en, shift_din, bram_strobe, capture, shift) ;

parameter integer 	C_JTAG_CHAIN = 2 ;
parameter  		C_BUFFER_SHIFT_CLOCK = "TRUE" ;
parameter 	 	C_FAMILY = "S6" ;

input		shift_dout ;
output		shift_clk ;
output		bram_en ;
output		shift_din ;
output		bram_strobe ;
output		capture ;
output		shift ;
      
wire		drck ;

generate
if (C_FAMILY == "V4")
begin : BSCAN_VIRTEX4_gen

BSCAN_VIRTEX4 # (
	.JTAG_CHAIN 	(C_JTAG_CHAIN))
BSCAN_BLOCK_inst (
	.CAPTURE 	(capture),
	.DRCK 		(drck),
	.RESET 		(),
	.SEL 		(bram_en),
	.SHIFT 		(shift),
	.TDI 		(shift_din),
	.UPDATE 	(bram_strobe),
	.TDO 		(shift_dout)) ;
end 
endgenerate

generate
if (C_FAMILY == "V5")
begin : BSCAN_VIRTEX5_gen

BSCAN_VIRTEX5 # (
        .JTAG_CHAIN 	(C_JTAG_CHAIN))
BSCAN_BLOCK_inst (
	.CAPTURE 	(capture),
	.DRCK 		(drck),
	.RESET 		(),
	.SEL 		(bram_en),
	.SHIFT 		(shift),
	.TDI 		(shift_din),
	.UPDATE 	(bram_strobe),
	.TDO 		(shift_dout));
end 
endgenerate
                
generate
if (C_FAMILY == "S6")
begin : BSCAN_SPARTAN6_gen

BSCAN_SPARTAN6 # (
        .JTAG_CHAIN 	(C_JTAG_CHAIN))
BSCAN_BLOCK_inst (
	.CAPTURE 	(capture),
	.DRCK 		(drck),
	.RESET 		(),
	.RUNTEST 	(),
	.SEL 		(bram_en),
	.SHIFT 		(shift),
	.TCK 		(),
	.TDI 		(shift_din),
	.TMS 		(),
	.UPDATE 	(bram_strobe),
	.TDO 		(shift_dout)); 
            
end 
endgenerate

generate
if (C_FAMILY == "V6")
begin : BSCAN_VIRTEX6_gen

BSCAN_VIRTEX6 # (
	.JTAG_CHAIN 	(C_JTAG_CHAIN),
        .DISABLE_JTAG 	("FALSE"))
BSCAN_BLOCK_inst (
	.CAPTURE 	(capture),
	.DRCK 		(drck),
	.RESET 		(),
        .RUNTEST 	(),
	.SEL 		(bram_en),
	.SHIFT 		(shift),
	.TCK 		(),
	.TDI 		(shift_din),
	.TMS 		(),
	.UPDATE 	(bram_strobe),
	.TDO 		(shift_dout)) ;

end 
endgenerate   

generate
if (C_BUFFER_SHIFT_CLOCK == "TRUE")
begin : BUFG_SHIFT_CLOCK_gen      
        
BUFG upload_clock (.I (drck), .O (shift_clk));
        
end 
endgenerate   

generate
if (C_BUFFER_SHIFT_CLOCK == "FALSE")
begin : NO_BUFG_SHIFT_CLOCK_gen         

assign shift_clk = drck ;

end 
endgenerate   
        
endmodule

