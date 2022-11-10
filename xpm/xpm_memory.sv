//------------------------------------------------------------------------------
//  (c) Copyright 2015 Xilinx, Inc. All rights reserved.
//
//  This file contains confidential and proprietary information
//  of Xilinx, Inc. and is protected under U.S. and
//  international copyright and other intellectual property
//  laws.
//
//  DISCLAIMER
//  This disclaimer is not a license and does not grant any
//  rights to the materials distributed herewith. Except as
//  otherwise provided in a valid license issued to you by
//  Xilinx, and to the maximum extent permitted by applicable
//  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//  (2) Xilinx shall not be liable (whether in contract or tort,
//  including negligence, or under any other theory of
//  liability) for any loss or damage of any kind or nature
//  related to, arising under or in connection with these
//  materials, including for any direct, or any indirect,
//  special, incidental, or consequential loss or damage
//  (including loss of data, profits, goodwill, or any type of
//  loss or damage suffered as a result of any action brought
//  by a third party) even if such damage or loss was
//  reasonably foreseeable or Xilinx had been advised of the
//  possibility of the same.
//
//  CRITICAL APPLICATIONS
//  Xilinx products are not designed or intended to be fail-
//  safe, or for use in any application requiring fail-safe
//  performance, such as life-support or safety devices or
//  systems, Class III medical devices, nuclear facilities,
//  applications related to the deployment of airbags, or any
//  other applications that could lead to death, personal
//  injury, or severe property or environmental damage
//  (individually and collectively, "Critical
//  Applications"). Customer assumes the sole risk and
//  liability of any use of Xilinx products in Critical
//  Applications, subject only to applicable laws and
//  regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//  PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------

// ***************************
// * DO NOT MODIFY THIS FILE *
// ***************************

`timescale 1ps/1ps
`default_nettype none

(* XPM_MODULE = "TRUE",  KEEP_HIERARCHY = "SOFT" *)
module xpm_memory_base # (

  // Common module parameters
  parameter integer                 MEMORY_TYPE             = 2,
  parameter integer                 MEMORY_SIZE             = 2048,
  parameter integer                 MEMORY_PRIMITIVE        = 0,
  parameter integer                 CLOCKING_MODE           = 0,
  parameter integer                 ECC_MODE                = 0,
  parameter                         MEMORY_INIT_FILE        = "none",
  parameter                         MEMORY_INIT_PARAM       = "",
  parameter integer                 IGNORE_INIT_SYNTH       = 0,
  parameter integer                 USE_MEM_INIT_MMI        = 0,
  parameter integer                 USE_MEM_INIT            = 1,
  parameter                         MEMORY_OPTIMIZATION     = "true",
  parameter integer                 WAKEUP_TIME             = 0,
  parameter integer                 AUTO_SLEEP_TIME         = 0,
  parameter integer                 MESSAGE_CONTROL         = 0,
  parameter integer                 VERSION                 = 0,
  parameter integer                 USE_EMBEDDED_CONSTRAINT = 0,
  parameter integer                 CASCADE_HEIGHT          = 0,
  parameter integer                 SIM_ASSERT_CHK          = 0,
  parameter integer                 WRITE_PROTECT           = 1,
  // Port A module parameters
  parameter integer                 WRITE_DATA_WIDTH_A      = 32,
  parameter integer                 READ_DATA_WIDTH_A       = WRITE_DATA_WIDTH_A,
  parameter integer                 BYTE_WRITE_WIDTH_A      = WRITE_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_A            = $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A),
  parameter                         READ_RESET_VALUE_A      = "0",
  parameter integer                 READ_LATENCY_A          = 2,
  parameter integer                 WRITE_MODE_A            = 2,
  parameter                         RST_MODE_A              = "SYNC",

  // Port B module parameters
  parameter integer                 WRITE_DATA_WIDTH_B      = WRITE_DATA_WIDTH_A,
  parameter integer                 READ_DATA_WIDTH_B       = WRITE_DATA_WIDTH_B,
  parameter integer                 BYTE_WRITE_WIDTH_B      = WRITE_DATA_WIDTH_B,
  parameter integer                 ADDR_WIDTH_B            = $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_B),
  parameter                         READ_RESET_VALUE_B      = "0",
  parameter integer                 READ_LATENCY_B          = READ_LATENCY_A,
  parameter integer                 WRITE_MODE_B            = WRITE_MODE_A,
  parameter                         RST_MODE_B              = "SYNC"
) (
 
  // Common module ports
  input  wire                                               sleep,

  // Port A module ports
  input  wire                                               clka,
  input  wire                                               rsta,
  input  wire                                               ena,
  input  wire                                               regcea,
  input  wire [(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0] wea,
  input  wire [ADDR_WIDTH_A-1:0]                            addra,
  input  wire [WRITE_DATA_WIDTH_A-1:0]                      dina,
  input  wire                                               injectsbiterra,
  input  wire                                               injectdbiterra,
  output wire [READ_DATA_WIDTH_A-1:0]                       douta,
  output wire                                               sbiterra,
  output wire                                               dbiterra,

  // Port B module ports
  input  wire                                               clkb,
  input  wire                                               rstb,
  input  wire                                               enb,
  input  wire                                               regceb,
  input  wire [(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B)-1:0] web,
  input  wire [ADDR_WIDTH_B-1:0]                            addrb,
  input  wire [WRITE_DATA_WIDTH_B-1:0]                      dinb,
  input  wire                                               injectsbiterrb,
  input  wire                                               injectdbiterrb,
  output wire [READ_DATA_WIDTH_B-1:0]                       doutb,
  output wire                                               sbiterrb,
  output wire                                               dbiterrb
);

  // -------------------------------------------------------------------------------------------------------------------
  // Macro definitions
  // -------------------------------------------------------------------------------------------------------------------

  // Define macros for parameter value size comparisons
  `define MAX(a,b) {(a) > (b) ? (a) : (b)}
  `define MIN(a,b) {(a) < (b) ? (a) : (b)}

  // Define macros to simplify variable vector slicing
  `define ONE_ROW_OF_DIN  row*P_MIN_WIDTH_DATA +: P_MIN_WIDTH_DATA
  `define ONE_COL_OF_DINA col*P_WIDTH_COL_WRITE_A +: P_WIDTH_COL_WRITE_A
  `define ONE_COL_OF_DINB col*P_WIDTH_COL_WRITE_B +: P_WIDTH_COL_WRITE_B
  `define ONE_ROW_COL_OF_DINA  (row*P_MIN_WIDTH_DATA+col*P_WIDTH_COL_WRITE_A) +: P_WIDTH_COL_WRITE_A
  `define ONE_ROW_COL_OF_DINB  (row*P_MIN_WIDTH_DATA+col*P_WIDTH_COL_WRITE_B) +: P_WIDTH_COL_WRITE_B

  // Define macros to meaningfully designate the memory type and primitive
  `define MEM_TYPE_RAM_SP          (MEMORY_TYPE == 0)
  `define MEM_TYPE_RAM_SDP         (MEMORY_TYPE == 1)
  `define MEM_TYPE_RAM_TDP         (MEMORY_TYPE == 2)
  `define MEM_TYPE_ROM_SP          (MEMORY_TYPE == 3)
  `define MEM_TYPE_ROM_DP          (MEMORY_TYPE == 4)
  `define MEM_TYPE_RAM             (`MEM_TYPE_RAM_SP || `MEM_TYPE_RAM_SDP || `MEM_TYPE_RAM_TDP)
  `define MEM_TYPE_ROM             (`MEM_TYPE_ROM_SP || `MEM_TYPE_ROM_DP)
  `define MEM_PRIM_AUTO            (MEMORY_PRIMITIVE == 0)
  `define MEM_PRIM_DISTRIBUTED     (MEMORY_PRIMITIVE == 1)
  `define MEM_PRIM_BLOCK           (MEMORY_PRIMITIVE == 2)
  `define MEM_PRIM_ULTRA           (MEMORY_PRIMITIVE == 3)
  `define MEM_PRIM_MIXED           (MEMORY_PRIMITIVE == 4)
  `define WRITE_PROT_ENABLED       (WRITE_PROTECT == 1)
  `define WRITE_PROT_DISABLED      (WRITE_PROTECT == 0)

  // Define macros to meaningfully designate port A characteristics
  `define MEM_PORTA_WRITE          (`MEM_TYPE_RAM_SP || `MEM_TYPE_RAM_SDP || `MEM_TYPE_RAM_TDP)
  `define MEM_PORTA_READ           (`MEM_TYPE_RAM_SP || `MEM_TYPE_RAM_TDP || `MEM_TYPE_ROM)
  `define MEM_PORTA_WF             (WRITE_MODE_A == 0)
  `define MEM_PORTA_RF             (WRITE_MODE_A == 1)
  `define MEM_PORTA_NC             (WRITE_MODE_A == 2)
  `define MEM_PORTA_WR_NARROW      (P_NUM_ROWS_WRITE_A == 1)
  `define MEM_PORTA_WR_WIDE        (P_NUM_ROWS_WRITE_A > 1)
  `define MEM_PORTA_WR_WORD        (P_ENABLE_BYTE_WRITE_A == 0)
  `define MEM_PORTA_WR_BYTE        (P_ENABLE_BYTE_WRITE_A == 1)
  `define MEM_PORTA_RD_NARROW      (P_NUM_ROWS_READ_A == 1)
  `define MEM_PORTA_RD_WIDE        (P_NUM_ROWS_READ_A > 1)
  `define MEM_PORTA_RD_COMB        (READ_LATENCY_A == 0)
  `define MEM_PORTA_RD_REG         (READ_LATENCY_A == 1)
  `define MEM_PORTA_RD_PIPE        (READ_LATENCY_A > 1)

  // Define macros to meaningfully designate port B characteristics
  `define MEM_PORTB_WRITE          (`MEM_TYPE_RAM_TDP && !`MEM_PRIM_DISTRIBUTED)
  `define MEM_PORTB_READ           (`MEM_TYPE_RAM_SDP || `MEM_TYPE_RAM_TDP || `MEM_TYPE_ROM_DP)
  `define MEM_PORTB_WF             (WRITE_MODE_B == 0)
  `define MEM_PORTB_RF             (WRITE_MODE_B == 1)
  `define MEM_PORTB_NC             (WRITE_MODE_B == 2)
  `define MEM_PORTB_WR_NARROW      (P_NUM_ROWS_WRITE_B == 1)
  `define MEM_PORTB_WR_WIDE        (P_NUM_ROWS_WRITE_B > 1)
  `define MEM_PORTB_WR_WORD        (P_ENABLE_BYTE_WRITE_B == 0)
  `define MEM_PORTB_WR_BYTE        (P_ENABLE_BYTE_WRITE_B == 1)
  `define MEM_PORTB_RD_NARROW      (P_NUM_ROWS_READ_B == 1)
  `define MEM_PORTB_RD_WIDE        (P_NUM_ROWS_READ_B > 1)
  `define MEM_PORTB_RD_COMB        (READ_LATENCY_B == 0)
  `define MEM_PORTB_RD_REG         (READ_LATENCY_B == 1)
  `define MEM_PORTB_RD_PIPE        (READ_LATENCY_B > 1)
  `define MEM_PORTB_URAM_LAT       (READ_LATENCY_B > 2)

  // Define macros to meaningfully designate other code characteristics
  `define COMMON_CLOCK             (CLOCKING_MODE == 0)
  `define INDEPENDENT_CLOCKS       (CLOCKING_MODE == 1)
  `define NO_MEMORY_INIT           ((MEMORY_INIT_FILE == "none" || MEMORY_INIT_FILE == "NONE" || MEMORY_INIT_FILE == "None") && (MEMORY_INIT_PARAM == "" || MEMORY_INIT_PARAM == "0"))
  `define REPORT_MESSAGES          (MESSAGE_CONTROL == 1)
  `define NO_MESSAGES              (MESSAGE_CONTROL == 0)
  `define EN_INIT_MESSAGE          (USE_MEM_INIT == 1)
  `define MEM_PORTA_ASYM_BWE       ((WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_A) && (WRITE_DATA_WIDTH_A > BYTE_WRITE_WIDTH_A) && (`MEM_PORTA_WRITE && `MEM_PORTA_READ))
  `define MEM_PORTB_ASYM_BWE       ((WRITE_DATA_WIDTH_B != READ_DATA_WIDTH_B) && (WRITE_DATA_WIDTH_B > BYTE_WRITE_WIDTH_B) && (`MEM_PORTB_WRITE && `MEM_PORTB_READ))
  `define MEM_ACRSS_PORT_ASYM_BWE  ((((WRITE_DATA_WIDTH_A != WRITE_DATA_WIDTH_B) && `MEM_PORTA_WRITE && `MEM_PORTB_WRITE) || ((WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B) && `MEM_PORTA_WRITE && `MEM_PORTB_READ)) && ((WRITE_DATA_WIDTH_A > BYTE_WRITE_WIDTH_A) || (WRITE_DATA_WIDTH_B > BYTE_WRITE_WIDTH_B)))
  `define MEM_PORT_ASYM_BWE        (`MEM_PORTA_ASYM_BWE || `MEM_PORTB_ASYM_BWE || `MEM_ACRSS_PORT_ASYM_BWE)

  `define MEM_PORTA_ASYM           ((WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_A) && (`MEM_PORTA_WRITE && `MEM_PORTA_READ))
  `define MEM_PORTB_ASYM           ((WRITE_DATA_WIDTH_B != READ_DATA_WIDTH_B) && (`MEM_PORTB_WRITE && `MEM_PORTB_READ))
  `define MEM_ACRSS_PORT_ASYM      ((((WRITE_DATA_WIDTH_A != WRITE_DATA_WIDTH_B) && `MEM_PORTA_WRITE && `MEM_PORTB_WRITE) || ((WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B) && `MEM_PORTA_WRITE && `MEM_PORTB_READ)) )
  `define MEM_PORT_ASYM            (`MEM_PORTA_ASYM  || `MEM_PORTB_ASYM || `MEM_ACRSS_PORT_ASYM)

  `define ROM_MEMORY_OPT           (MEMORY_OPTIMIZATION == "true")

  // Define macros to meaningfully designate power saving features
  `define SLEEP_MODE               (WAKEUP_TIME == 2)

  // Define macros to meaningfully designate collision safety
  `define IS_COLLISION_A_SAFE      ((`MEM_TYPE_RAM_SDP || `MEM_TYPE_RAM_TDP) && (`MEM_PORTA_RF && `COMMON_CLOCK))
  `define IS_COLLISION_B_SAFE      (`MEM_TYPE_RAM_TDP && (`MEM_PORTB_RF && `COMMON_CLOCK))
  `define IS_COLLISION_SAFE        ((`MEM_TYPE_RAM_TDP && `IS_COLLISION_A_SAFE && `IS_COLLISION_B_SAFE) || (`MEM_TYPE_RAM_SDP && `IS_COLLISION_A_SAFE))

  // Define Macros related to ECC
  `define NO_ECC                   (ECC_MODE == 0)
  `define ENC_ONLY                 (ECC_MODE == 1)
  `define DEC_ONLY                 (ECC_MODE == 2)
  `define BOTH_ENC_DEC             (ECC_MODE == 3)

  // Macro that prevents the templates to synthesis for the configurations
  // that does not have the synthesis supported coding styles e.g black box
  // approach for asymmetry with byte write enable
  `define DISABLE_SYNTH_TEMPL            (`MEM_PORT_ASYM_BWE)

  // Auto sleep mode related parameters
  `define MEM_AUTO_SLP_EN          (`MEM_PRIM_ULTRA && (AUTO_SLEEP_TIME != 0))

  //Asynchronous Reset for dout
  `define ASYNC_RESET_A            (RST_MODE_A == "ASYNC")
  `define ASYNC_RESET_B            (RST_MODE_B == "ASYNC")

  // -------------------------------------------------------------------------------------------------------------------
  // Local parameter definitions
  // -------------------------------------------------------------------------------------------------------------------

  // Define local parameters for memory declaration pragmas
  localparam         P_MEMORY_PRIMITIVE       = `MEM_PRIM_DISTRIBUTED ? "distributed" :
                                               (`MEM_PRIM_BLOCK ? "block" :
                                               (`MEM_PRIM_ULTRA ? "ultra" : 
                                               (`MEM_PRIM_MIXED ? "mixed" : "auto")));

  // Define local parameters for memory array sizing
  localparam integer P_MIN_WIDTH_DATA_A       = `MEM_TYPE_RAM_SDP ? WRITE_DATA_WIDTH_A :
                                               (`MEM_TYPE_ROM ? READ_DATA_WIDTH_A :
                                                `MIN(WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_A));
  localparam integer P_MIN_WIDTH_DATA_B       = `MEM_TYPE_RAM_SDP || `MEM_TYPE_ROM_DP ? READ_DATA_WIDTH_B :
                                               (`MEM_TYPE_RAM_SP || `MEM_TYPE_ROM_SP ? P_MIN_WIDTH_DATA_A :
                                                `MIN(WRITE_DATA_WIDTH_B, READ_DATA_WIDTH_B));
  localparam integer P_MIN_WIDTH_DATA         = `MIN(P_MIN_WIDTH_DATA_A, P_MIN_WIDTH_DATA_B);
  localparam integer P_MIN_WIDTH_DATA_ECC     = `NO_ECC ?  P_MIN_WIDTH_DATA : `BOTH_ENC_DEC ? P_MIN_WIDTH_DATA+((WRITE_DATA_WIDTH_A/64)*8) : (`DEC_ONLY && `MEM_PORTA_WRITE) ? WRITE_DATA_WIDTH_A : (`DEC_ONLY && `MEM_PORTA_READ) ? P_MIN_WIDTH_DATA+((READ_DATA_WIDTH_A/64)*8) : (`ENC_ONLY && `MEM_PORTA_READ) ? READ_DATA_WIDTH_A : READ_DATA_WIDTH_B;
  localparam integer P_MAX_DEPTH_DATA         = `BOTH_ENC_DEC ? MEMORY_SIZE/P_MIN_WIDTH_DATA : MEMORY_SIZE/P_MIN_WIDTH_DATA_ECC;
  localparam         P_ECC_MODE               = `BOTH_ENC_DEC ? "both_encode_and_decode" : `DEC_ONLY ? "decode_only" : `ENC_ONLY ? "encode_only" : "no_ecc";
  localparam         P_MEMORY_OPT             = (!(`ROM_MEMORY_OPT) && `MEM_TYPE_ROM) ? "no" : "yes";

  // Define local parameters for write and read data sizing
  // When ECC is enabled, Byte writes and Asymmetry are not allowed
  localparam integer P_WIDTH_COL_WRITE_A      = `MIN(BYTE_WRITE_WIDTH_A, P_MIN_WIDTH_DATA);
  localparam integer P_WIDTH_COL_WRITE_B      = `MIN(BYTE_WRITE_WIDTH_B, P_MIN_WIDTH_DATA);
  localparam integer P_NUM_COLS_WRITE_A       = !(`NO_ECC) ? 1 : P_MIN_WIDTH_DATA/P_WIDTH_COL_WRITE_A;
  localparam integer P_NUM_COLS_WRITE_B       = !(`NO_ECC) ? 1 : P_MIN_WIDTH_DATA/P_WIDTH_COL_WRITE_B;
  localparam integer P_NUM_ROWS_WRITE_A       = !(`NO_ECC) ? 1 : WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA;
  localparam integer P_NUM_ROWS_WRITE_B       = !(`NO_ECC) ? 1 : WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA;
  localparam integer P_NUM_ROWS_READ_A        = !(`NO_ECC) ? 1 : READ_DATA_WIDTH_A/P_MIN_WIDTH_DATA;
  localparam integer P_NUM_ROWS_READ_B        = !(`NO_ECC) ? 1 : READ_DATA_WIDTH_B/P_MIN_WIDTH_DATA;
  localparam integer P_WIDTH_ADDR_WRITE_A     = (`ENC_ONLY && `MEM_PORTB_READ) ? $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B) : (`ENC_ONLY && `MEM_PORTA_READ) ? $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A) : $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A);
  localparam integer P_WIDTH_ADDR_WRITE_B     = `DEC_ONLY ? $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A) : $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_B);
  localparam integer P_WIDTH_ADDR_READ_A      = (`ENC_ONLY && `MEM_PORTB_READ) ? $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B) : (`ENC_ONLY && `MEM_PORTA_READ) ? $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A) : $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A);
  localparam integer P_WIDTH_ADDR_READ_B      = `DEC_ONLY ? $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A) : $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B);
  localparam integer P_WIDTH_ADDR_LSB_WRITE_A = $clog2(P_NUM_ROWS_WRITE_A);
  localparam integer P_WIDTH_ADDR_LSB_WRITE_B = $clog2(P_NUM_ROWS_WRITE_B);
  localparam integer P_WIDTH_ADDR_LSB_READ_A  = $clog2(P_NUM_ROWS_READ_A);
  localparam integer P_WIDTH_ADDR_LSB_READ_B  = $clog2(P_NUM_ROWS_READ_B);

  // Define local parameters for other code characteristics
  localparam integer P_ENABLE_BYTE_WRITE_A    = !(`NO_ECC) ? 0 : WRITE_DATA_WIDTH_A > BYTE_WRITE_WIDTH_A ? 1 : 0;
  localparam integer P_ENABLE_BYTE_WRITE_B    = !(`NO_ECC) ? 0 : WRITE_DATA_WIDTH_B > BYTE_WRITE_WIDTH_B ? 1 : 0;
 
  // Define local parameters for SDP write mode
  localparam         P_SDP_WRITE_MODE         = (`MEM_PRIM_BLOCK && `MEM_PORTB_NC && `MEM_TYPE_RAM_SDP) ? "no" : "yes";

  // Define local parameters for reset value conversions
  localparam integer  rsta_loop_iter  =  (READ_DATA_WIDTH_A < 4) ? 4 : (READ_DATA_WIDTH_A%4) ? (READ_DATA_WIDTH_A + (4-READ_DATA_WIDTH_A%4)) : READ_DATA_WIDTH_A;  
  localparam integer rstb_loop_iter  =  (READ_DATA_WIDTH_B < 4) ? 4 : (READ_DATA_WIDTH_B%4) ? (READ_DATA_WIDTH_B + (4-READ_DATA_WIDTH_B%4)) : READ_DATA_WIDTH_B;
  // -------------------------------------------------------------------------------------------------------------------
  // Configuration DRCs
  // -------------------------------------------------------------------------------------------------------------------

  initial begin : config_drc
    reg drc_err_flag;
    drc_err_flag = 0;
    #1;

    // notification and restrictions
    if (1) 
    if (`MEM_PORTA_WRITE && `MEM_PORTA_READ && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_A && `NO_ECC) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_A (%0d) for this configuration which uses port A write and read operations, but this release of XPM_MEMORY requires symmetric write and read data widths within each enabled port. %m", "XPM_MEMORY", 1, 2, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && `MEM_PORTB_READ && WRITE_DATA_WIDTH_B != READ_DATA_WIDTH_B && `NO_ECC) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this configuration which uses port B write and read operations, but this release of XPM_MEMORY requires symmetric write and read data widths within each enabled port. %m", "XPM_MEMORY", 1, 3, WRITE_DATA_WIDTH_B, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    
    if (`MEM_TYPE_RAM_SDP && `MEM_PRIM_DISTRIBUTED && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this simple dual port RAM configuration with memory primitive set to distributed RAM, but this release of XPM_MEMORY requires symmetric write and read data widths when memory primitive set to distributed RAM. %m", "XPM_MEMORY", 1, 13, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

    if (`MEM_TYPE_RAM_TDP && `MEM_PRIM_DISTRIBUTED && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this true dual port RAM configuration with memory primitive set to distributed RAM, but this release of XPM_MEMORY requires symmetric write and read data widths when memory primitive set to distributed RAM. %m", "XPM_MEMORY", 1, 14, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

    if (`MEM_TYPE_ROM_DP && READ_DATA_WIDTH_A != READ_DATA_WIDTH_B) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this dual port ROM configuration , but this release of XPM_MEMORY requires symmetric read data widths when memory type is set to dual port ROM. %m", "XPM_MEMORY", 1, 15, READ_DATA_WIDTH_A, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

    if (CASCADE_HEIGHT > 64 && `MEM_PRIM_ULTRA) begin
      $error("[%s %0d-%0d] XPM_MEMORY does not support CASCADE_HEIGHT (%0d) greater than 64 for Ultra RAM configurations. %m", "XPM_MEMORY", 1, 16, CASCADE_HEIGHT);
      drc_err_flag = 1;
    end

    if (CASCADE_HEIGHT > 16 && `MEM_PRIM_BLOCK) begin
      $error("[%s %0d-%0d] XPM_MEMORY does not support CASCADE_HEIGHT (%0d) greater than 16 for Block RAM configurations. %m", "XPM_MEMORY", 1, 16, CASCADE_HEIGHT);
      drc_err_flag = 1;
    end 

    if (!`NO_ECC && !`NO_MEMORY_INIT) begin
      $error("[%s %0d-%0d] Memory initialization is specified for this configuration with ECC (%0d) enabled, but this release of XPM_MEMORY does not support ECC with memory Initialization . %m", "XPM_MEMORY", 1, 18, ECC_MODE);
      drc_err_flag = 1;
    end
    
    if (!`NO_ECC && `MEM_TYPE_ROM) begin
      $error("[%s %0d-%0d] Memory type is set to ROM for this configuration with ECC (%0d) enabled, but this release of XPM_MEMORY does not support ECC with memory Initialization . %m", "XPM_MEMORY", 1, 19, ECC_MODE);
      drc_err_flag = 1;
    end
    
    if  (`MEM_PORT_ASYM_BWE && !`NO_MEMORY_INIT) begin
      $error("[%s %0d-%0d] Asymmetry with Byte Write Enable is specified with Memory initialization, but this release of XPM_MEMORY does not support Memory initialization with Asymmetric Byte Write Enable. %m", "XPM_MEMORY", 1, 21);
      drc_err_flag = 1;
    end

    if (`MEM_PORT_ASYM_BWE && `MEM_PRIM_ULTRA && (`SLEEP_MODE || `MEM_AUTO_SLP_EN)) begin
      $error("[%s %0d-%0d] The configuration has UltraRAM,Asymmetric ports with Byte Write Enable with Sleep Mode or Auto Sleep Mode enabled, but this release of XPM_MEMORY does not support the specified configuration. %m", "XPM_MEMORY", 1, 20);
      drc_err_flag = 1;
    end

    if ((`MEM_PRIM_AUTO || `MEM_PRIM_BLOCK || `MEM_PRIM_ULTRA) && USE_EMBEDDED_CONSTRAINT) begin
      $error("[%s %0d-%0d] USE_EMBEDDED_CONSTRAINT is set to (%0d), but Embedded Constraint is supported only for distributed RAM with separate write and read clocks. %m", "XPM_MEMORY", 1, 22, USE_EMBEDDED_CONSTRAINT);
      drc_err_flag = 1;
    end

    if ((`MEM_PORT_ASYM_BWE && `MEM_TYPE_RAM_SDP && `MEM_PORTA_WR_BYTE && (WRITE_DATA_WIDTH_B%BYTE_WRITE_WIDTH_A != 0)) || (`MEM_PORT_ASYM_BWE && `MEM_TYPE_RAM_TDP && `MEM_PORTA_WR_BYTE && (BYTE_WRITE_WIDTH_B%BYTE_WRITE_WIDTH_A != 0)) || (`MEM_PORT_ASYM_BWE && `MEM_TYPE_RAM_TDP && `MEM_PORTB_WR_BYTE && (BYTE_WRITE_WIDTH_A%BYTE_WRITE_WIDTH_B != 0))) begin
      $error("[%s %0d-%0d] Asymmetry with Byte Write Enable is specified, but the write data width and byte write width of port A and port B are not compatible. If byte write is enabled on port A, then data width of port B must be divisible by Port A byte write width, and vice versa. %m", "XPM_MEMORY", 1, 23);
      drc_err_flag = 1;
    end

    if (`MEM_AUTO_SLP_EN && `MEM_TYPE_RAM_SDP && `MEM_PORTB_WF && (READ_LATENCY_B < 4) ) begin
      $error("[%s %0d-%0d] This configuration has Simple Dual Port RAM, UltraRAM, Write First Mode with Non-Zero Auto Sleep value and READ_LATENCY_B (%0d) value less than 4. But in this release of XPM_MEMORY does not support READ_LATENCY_B value less than 4 for the specified configuration. %m", "XPM_MEMORY", 1, 24, READ_LATENCY_B);
      drc_err_flag = 1;
    end

    if (`MEM_AUTO_SLP_EN && `MEM_TYPE_RAM_SDP && `MEM_PORTB_RF && (READ_LATENCY_B < 3)) begin
      $error("[%s %0d-%0d] This configuration has Simple Dual Port RAM, UltraRAM, Read First Mode with Non-Zero Auto Sleep value and READ_LATENCY_B (%0d) value less than 3. But in this release of XPM_MEMORY does not support READ_LATENCY_B value less than 3 for the specified configuration. %m", "XPM_MEMORY", 1, 25, READ_LATENCY_B);
      drc_err_flag = 1;
    end

    if (`MEM_AUTO_SLP_EN && `MEM_TYPE_RAM_SP && (READ_LATENCY_A < 3)) begin
      $error("[%s %0d-%0d] This configuration has Single Port RAM, UltraRAM with Non-Zero Auto Sleep value and READ_LATENCY_A (%0d) value less than 3. But in this release of XPM_MEMORY does not support READ_LATENCY_A value less than 3 for the specified configuration. %m", "XPM_MEMORY", 1, 26, READ_LATENCY_A);
      drc_err_flag = 1;
    end

    if (`MEM_AUTO_SLP_EN && `MEM_TYPE_RAM_TDP && (READ_LATENCY_A < 3)) begin
      $error("[%s %0d-%0d] This configuration has True Dual Port RAM, UltraRAM with Non-Zero Auto Sleep value and READ_LATENCY_A (%0d) value less than 3. But in this release of XPM_MEMORY does not support READ_LATENCY_A value less than 3 for the specified configuration. %m", "XPM_MEMORY", 1, 27, READ_LATENCY_A);
      drc_err_flag = 1;
    end

    if (`MEM_AUTO_SLP_EN && `MEM_TYPE_RAM_TDP && (READ_LATENCY_B < 3)) begin
      $error("[%s %0d-%0d] This configuration has True Dual Port RAM, UltraRAM with Non-Zero Auto Sleep value and READ_LATENCY_B (%0d) value less than 3. But in this release of XPM_MEMORY does not support READ_LATENCY_B value less than 3 for the specified configuration. %m", "XPM_MEMORY", 1, 28, READ_LATENCY_B);
      drc_err_flag = 1;
    end

    if ((WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B) && `MEM_TYPE_RAM_SDP && `MEM_PORTB_WF) begin
      $error("[%s %0d-%0d] This configuration has Simple Dual Port RAM, Port-B Write First Mode with WRITE_DATA_WIDTH_A (%0d) not equal to READ_DATA_WIDTH_B (%0d). But in this release of XPM_MEMORY does not support the specified configuration. %m", "XPM_MEMORY", 1, 29, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end


    // Range checks
    if (!(MEMORY_TYPE == 0 || MEMORY_TYPE == 1 || MEMORY_TYPE == 2 || MEMORY_TYPE == 3 || MEMORY_TYPE == 4)) begin
      $error("[%s %0d-%0d] MEMORY_TYPE (%0d) value is outside of legal range. %m", "XPM_MEMORY", 10, 1, MEMORY_TYPE);
      drc_err_flag = 1;
    end
    if (!(MEMORY_SIZE > 0)) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) value is outside of legal range. %m", "XPM_MEMORY", 10, 2, MEMORY_SIZE);
      drc_err_flag = 1;
    end
    //if ((MEMORY_SIZE > 150994944 )) begin
    //  $error("[%s %0d-%0d] MEMORY_SIZE (%0d) value exceeds the maximum supported size. %m", "XPM_MEMORY", 10, 11, MEMORY_SIZE);
    //  drc_err_flag = 1;
    //end
    if (!(MEMORY_PRIMITIVE == 0 || MEMORY_PRIMITIVE == 1 || MEMORY_PRIMITIVE == 2 || MEMORY_PRIMITIVE == 3 || MEMORY_PRIMITIVE == 4)) begin
      $error("[%s %0d-%0d] MEMORY_PRIMITIVE (%0d) value is outside of legal range. %m", "XPM_MEMORY", 10, 3, MEMORY_PRIMITIVE);
      drc_err_flag = 1;
    end
    if (!(CLOCKING_MODE == 0 || CLOCKING_MODE == 1)) begin
      $error("[%s %0d-%0d] CLOCKING_MODE (%0d) value is outside of legal range. %m", "XPM_MEMORY", 10, 4, CLOCKING_MODE);
      drc_err_flag = 1;
    end
    if (!(ECC_MODE == 0 || ECC_MODE == 1 || ECC_MODE == 2 || ECC_MODE == 3)) begin
      $error("[%s %0d-%0d] ECC_MODE (%0d) value is outside of legal range. %m", "XPM_MEMORY", 10, 5, ECC_MODE);
      drc_err_flag = 1;
    end
    if (!(WAKEUP_TIME == 0 || WAKEUP_TIME == 2)) begin
      $error("[%s %0d-%0d] WAKEUP_TIME (%0d) value is outside of legal range. %m", "XPM_MEMORY", 10, 7, WAKEUP_TIME);
      drc_err_flag = 1;
    end
    if (!(MESSAGE_CONTROL == 0 || MESSAGE_CONTROL == 1)) begin
      $error("[%s %0d-%0d] MESSAGE_CONTROL (%0d) value is outside of legal range. %m", "XPM_MEMORY", 10, 8, MESSAGE_CONTROL);
      drc_err_flag = 1;
    end
    if (!(VERSION == 0)) begin
      $error("[%s %0d-%0d] VERSION (%0d) value is outside of legal range. %m", "XPM_MEMORY", 10, 9, VERSION);
      drc_err_flag = 1;
    end
    if (!(AUTO_SLEEP_TIME == 0 || (AUTO_SLEEP_TIME >=3 && AUTO_SLEEP_TIME < 16))) begin
      $error("[%s %0d-%0d] AUTO_SLEEP_TIME (%0d) value is outside of legal range. %m", "XPM_MEMORY", 10, 10, AUTO_SLEEP_TIME);
      drc_err_flag = 1;
    end
    if (!(WRITE_DATA_WIDTH_A > 0)) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) value is outside of legal range. %m", "XPM_MEMORY", 15, 1, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (!(READ_DATA_WIDTH_A > 0)) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_A (%0d) value is outside of legal range. %m", "XPM_MEMORY", 15, 2, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (!(BYTE_WRITE_WIDTH_A == 8 || BYTE_WRITE_WIDTH_A == 9 || BYTE_WRITE_WIDTH_A == WRITE_DATA_WIDTH_A)) begin
      $error("[%s %0d-%0d] BYTE_WRITE_WIDTH_A (%0d) value is outside of legal range. %m", "XPM_MEMORY", 15, 3, BYTE_WRITE_WIDTH_A);
      drc_err_flag = 1;
    end
    if (!(ADDR_WIDTH_A > 0)) begin
      $error("[%s %0d-%0d] ADDR_WIDTH_A (%0d) value is outside of legal range. %m", "XPM_MEMORY", 15, 4, ADDR_WIDTH_A);
      drc_err_flag = 1;
    end
    if (!(READ_LATENCY_A >= 0)) begin
      $error("[%s %0d-%0d] READ_LATENCY_A (%0d) value is outside of legal range. %m", "XPM_MEMORY", 15, 6, READ_LATENCY_A);
      drc_err_flag = 1;
    end
    if (!(WRITE_MODE_A == 0 || WRITE_MODE_A == 1 || WRITE_MODE_A == 2)) begin
      $error("[%s %0d-%0d] WRITE_MODE_A (%0d) value is outside of legal range. %m", "XPM_MEMORY", 15, 7, WRITE_MODE_A);
      drc_err_flag = 1;
    end
    if (!(WRITE_DATA_WIDTH_B > 0)) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) value is outside of legal range. %m", "XPM_MEMORY", 16, 1, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (!(READ_DATA_WIDTH_B > 0)) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_B (%0d) value is outside of legal range. %m", "XPM_MEMORY", 16, 2, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (!(BYTE_WRITE_WIDTH_B == 8 || BYTE_WRITE_WIDTH_B == 9 || BYTE_WRITE_WIDTH_B == WRITE_DATA_WIDTH_B)) begin
      $error("[%s %0d-%0d] BYTE_WRITE_WIDTH_B (%0d) value is outside of legal range. %m", "XPM_MEMORY", 16, 3, BYTE_WRITE_WIDTH_B);
      drc_err_flag = 1;
    end
    if (!(ADDR_WIDTH_B > 0)) begin
      $error("[%s %0d-%0d] ADDR_WIDTH_B (%0d) value is outside of legal range. %m", "XPM_MEMORY", 16, 4, ADDR_WIDTH_B);
      drc_err_flag = 1;
    end
    if (!(READ_LATENCY_B >= 0)) begin
      $error("[%s %0d-%0d] READ_LATENCY_B (%0d) value is outside of legal range. %m", "XPM_MEMORY", 16, 6, READ_LATENCY_B);
      drc_err_flag = 1;
    end
    if (!(WRITE_MODE_B == 0 || WRITE_MODE_B == 1 || WRITE_MODE_B == 2)) begin
      $error("[%s %0d-%0d] WRITE_MODE_B (%0d) value is outside of legal range. %m", "XPM_MEMORY", 16, 7, WRITE_MODE_B);
      drc_err_flag = 1;
    end

    // Infos
    if (`MEM_PRIM_AUTO)
      $info("[%s %0d-%0d] MEMORY_PRIMITIVE (%0d) instructs Vivado Synthesis to choose the memory primitive type. Depending on their values, other XPM_MEMORY parameters may preclude the choice of certain memory primitive types. Review XPM_MEMORY documentation and parameter values to understand any limitations, or set MEMORY_PRIMITIVE to a different value. %m", "XPM_MEMORY", 20, 1, MEMORY_PRIMITIVE);
    if (`NO_MEMORY_INIT && !`MEM_PRIM_ULTRA && `EN_INIT_MESSAGE)
      $info("[%s %0d-%0d] MEMORY_INIT_FILE (%0s), MEMORY_INIT_PARAM together specify no memory initialization. Initial memory contents will be all 0's. %m", "XPM_MEMORY", 20, 2, MEMORY_INIT_FILE,MEMORY_INIT_PARAM);
    if (`COMMON_CLOCK && `MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP)
      $info("[%s %0d-%0d] XPM_MEMORY behaviorally models the port operation ordering of true dual port UltraRAM configurations by slightly delaying the common clock for port B operations only. Refer to UltraRAM documentation for details. %m", "XPM_MEMORY", 20, 3);
    if (AUTO_SLEEP_TIME != 0 && `MEM_PRIM_ULTRA) begin
      $info("[%s %0d-%0d] Non-zero AUTO_SLEEP_TIME (%0d) is specifed for this configuration, An input pipeline having the number of register stages equal to AUTO_SLEEP_TIME will be introduced on all the input control/data signals path except for the port-enables(en[a|b]) and reset(rst[a|b]). %m", "XPM_MEMORY", 20, 4, AUTO_SLEEP_TIME);
    end

    // Warnings
    if (`MEM_TYPE_ROM && `NO_MEMORY_INIT)
      $warning("[%s %0d-%0d] MEMORY_INIT_FILE (%0s) specifies no memory initialization file for this ROM configuration, which will result in an empty memory that may be optimized away. %m", "XPM_MEMORY", 30, 1, MEMORY_INIT_FILE);
    if (`MEM_TYPE_ROM && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_A)
      $warning("[%s %0d-%0d] Non-default WRITE_DATA_WIDTH_A (%0d) value ignored for ROM configurations because write operations are not used. %m", "XPM_MEMORY", 30, 2, WRITE_DATA_WIDTH_A);
    if (`MEM_TYPE_RAM_SDP && READ_DATA_WIDTH_A != WRITE_DATA_WIDTH_A)
      $warning("[%s %0d-%0d] Non-default READ_DATA_WIDTH_A (%0d) value ignored for simple dual port RAM configurations because port A read operations are not used. %m", "XPM_MEMORY", 30, 3, READ_DATA_WIDTH_A);
    if (`MEM_TYPE_ROM && BYTE_WRITE_WIDTH_A != WRITE_DATA_WIDTH_A)
      $warning("[%s %0d-%0d] Non-default BYTE_WRITE_WIDTH_A (%0d) value ignored for ROM configurations because write operations are not used. %m", "XPM_MEMORY", 30, 4, BYTE_WRITE_WIDTH_A);
    if (`MEM_TYPE_RAM_SDP && READ_RESET_VALUE_A != "0")
      $warning("[%s %0d-%0d] Non-default READ_RESET_VALUE_A value ignored for simple dual port RAM configurations because port A read operations are not used. %m", "XPM_MEMORY", 30, 5);
    if (`MEM_TYPE_RAM_SDP && READ_LATENCY_A != 2)
      $warning("[%s %0d-%0d] Non-default READ_LATENCY_A (%0d) value ignored for simple dual port RAM configurations because port A read operations are not used. %m", "XPM_MEMORY", 30, 6, READ_LATENCY_A);
    if (`MEM_TYPE_RAM_SP && WRITE_DATA_WIDTH_B != WRITE_DATA_WIDTH_A)
      $warning("[%s %0d-%0d] Non-default WRITE_DATA_WIDTH_B (%0d) value ignored for single port RAM configurations because port B write operations are not used. %m", "XPM_MEMORY", 30, 7, WRITE_DATA_WIDTH_B);
    if ((`MEM_TYPE_RAM_SDP || (`MEM_TYPE_RAM_TDP && `MEM_PRIM_DISTRIBUTED) || `MEM_TYPE_ROM) && WRITE_DATA_WIDTH_B != READ_DATA_WIDTH_B)
      $warning("[%s %0d-%0d] Non-default WRITE_DATA_WIDTH_B (%0d) value ignored for simple dual port RAM, dual port distributed RAM, or ROM configurations because port B write operations are not used. %m", "XPM_MEMORY", 30, 8, WRITE_DATA_WIDTH_B);
    if ((`MEM_TYPE_RAM_SP || `MEM_TYPE_ROM_SP) && READ_DATA_WIDTH_B != READ_DATA_WIDTH_A)
      $warning("[%s %0d-%0d] Non-default READ_DATA_WIDTH_B (%0d) value ignored for single port RAM or single port ROM configurations because port B is not used. %m", "XPM_MEMORY", 30, 9, READ_DATA_WIDTH_B);
    if ((`MEM_TYPE_RAM_SP || `MEM_TYPE_RAM_SDP || (`MEM_TYPE_RAM_TDP && `MEM_PRIM_DISTRIBUTED) || `MEM_TYPE_ROM) && BYTE_WRITE_WIDTH_B != WRITE_DATA_WIDTH_B)
      $warning("[%s %0d-%0d] Non-default BYTE_WRITE_WIDTH_B (%0d) value ignored for single port RAM, simple dual port RAM, dual port distributed RAM, or ROM configurations because port B write operations are not used. %m", "XPM_MEMORY", 30, 10, BYTE_WRITE_WIDTH_B);
    if ((`MEM_TYPE_RAM_SP || `MEM_TYPE_ROM_SP) && ADDR_WIDTH_B != $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_B))
      $warning("[%s %0d-%0d] Non-default ADDR_WIDTH_B (%0d) value ignored for single port RAM or single port ROM configurations because port B is not used. %m", "XPM_MEMORY", 30, 11, ADDR_WIDTH_B);
    if ((`MEM_TYPE_RAM_SP || `MEM_TYPE_ROM_SP) && READ_RESET_VALUE_B != "0")
      $warning("[%s %0d-%0d] Non-default READ_RESET_VALUE_B value ignored for single port RAM or single port ROM configurations because port B is not used. %m", "XPM_MEMORY", 30, 12);
    if ((`MEM_TYPE_RAM_SP || `MEM_TYPE_ROM_SP) && READ_LATENCY_B != READ_LATENCY_A)
      $warning("[%s %0d-%0d] Non-default READ_LATENCY_B (%0d) value ignored for single port RAM or single port ROM configurations because port B is not used. %m", "XPM_MEMORY", 30, 13, READ_LATENCY_B);
    if ((`MEM_TYPE_RAM_SP || `MEM_TYPE_ROM) && WRITE_MODE_B != WRITE_MODE_A)
      $warning("[%s %0d-%0d] Non-default WRITE_MODE_B (%0d) value ignored for single port RAM or ROM configurations because port B write operations are not used. %m", "XPM_MEMORY", 30, 14, WRITE_MODE_B);
    if (`MEM_TYPE_RAM_TDP && `MEM_PRIM_DISTRIBUTED)
      $warning("[%s %0d-%0d] MEMORY_TYPE (%0d) and MEMORY_PRIMITIVE (%0d) together specify a true dual port distributed RAM, which will be mapped to a dual port RAM structure using port A and B read interfaces but a single port A write interface, leaving the port B write interface unused. %m", "XPM_MEMORY", 30, 15, MEMORY_TYPE, MEMORY_PRIMITIVE);
    if (`MEM_PORTA_WRITE && $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A) < ADDR_WIDTH_A)
      $warning("[%s %0d-%0d] MEMORY_SIZE (%0d), WRITE_DATA_WIDTH_A (%0d), and ADDR_WIDTH_A (%0d) together imply that the addressable range exceeds the memory size for this configuration which uses port A write operations. %m", "XPM_MEMORY", 30, 16, MEMORY_SIZE, WRITE_DATA_WIDTH_A, ADDR_WIDTH_A);
    if (`MEM_PORTA_READ && $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A) < ADDR_WIDTH_A)
      $warning("[%s %0d-%0d] MEMORY_SIZE (%0d), READ_DATA_WIDTH_A (%0d), and ADDR_WIDTH_A (%0d) together imply that the addressable range exceeds the memory size for this configuration which uses port A read operations. %m", "XPM_MEMORY", 30, 17, MEMORY_SIZE, READ_DATA_WIDTH_A, ADDR_WIDTH_A);
    if (`MEM_PORTB_WRITE && $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_B) < ADDR_WIDTH_B)
      $warning("[%s %0d-%0d] MEMORY_SIZE (%0d), WRITE_DATA_WIDTH_B (%0d), and ADDR_WIDTH_B (%0d) together imply that the addressable range exceeds the memory size for this configuration which uses port B write operations. %m", "XPM_MEMORY", 30, 18, MEMORY_SIZE, WRITE_DATA_WIDTH_B, ADDR_WIDTH_B);
    if (`MEM_PORTB_READ && $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B) < ADDR_WIDTH_B)
      $warning("[%s %0d-%0d] MEMORY_SIZE (%0d), READ_DATA_WIDTH_B (%0d), and ADDR_WIDTH_B (%0d) together imply that the addressable range exceeds the memory size for this configuration which uses port B read operations. %m", "XPM_MEMORY", 30, 19, MEMORY_SIZE, READ_DATA_WIDTH_B, ADDR_WIDTH_B);
    if (`MEM_PORTA_WRITE && `MEM_PORTA_READ && `MEM_PRIM_DISTRIBUTED && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_A)
      $warning("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_A (%0d) for this distributed RAM configuration configuration which uses port A write and read operations, resulting in inefficient use of memory resources. %m", "XPM_MEMORY", 30, 20, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_A);
    if (`MEM_PORTA_WRITE && `MEM_PORTB_READ && `MEM_PRIM_DISTRIBUTED && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B)
      $warning("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this distributed RAM configuration configuration which uses port A write and port B read operations, resulting in inefficient use of memory resources. %m", "XPM_MEMORY", 30, 21, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_B);
    if (`MEM_PORTA_READ && `MEM_PORTB_READ && `MEM_PRIM_DISTRIBUTED && READ_DATA_WIDTH_A != READ_DATA_WIDTH_B)
      $warning("[%s %0d-%0d] READ_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this distributed memory configuration which uses port A and port B read operations, resulting in inefficient use of memory resources. %m", "XPM_MEMORY", 30, 22, READ_DATA_WIDTH_A, READ_DATA_WIDTH_B);
    if (`MEM_PORTA_READ && `MEM_PORTA_RD_COMB && READ_RESET_VALUE_A != "0")
      $warning("[%s %0d-%0d] Non-default READ_RESET_VALUE_A value ignored for this configuration which uses port A read operations, because READ_LATENCY_A (%0d) specifies a combinatorial read output. %m", "XPM_MEMORY", 30, 23, READ_LATENCY_A);
    if (`MEM_PORTB_READ && `MEM_PORTB_RD_COMB && READ_RESET_VALUE_B != "0")
      $warning("[%s %0d-%0d] Non-default READ_RESET_VALUE_B value ignored for this configuration which uses port B read operations, because READ_LATENCY_B (%0d) specifies a combinatorial read output. %m", "XPM_MEMORY", 30, 24, READ_LATENCY_B);
    if (`REPORT_MESSAGES && (`MEM_TYPE_RAM_SDP || `MEM_TYPE_RAM_TDP) && !(`MEM_PRIM_DISTRIBUTED || `MEM_PRIM_ULTRA))
      $warning("[%s %0d-%0d] MESSAGE_CONTROL (%0d) specifies simulation message reporting, but any potential collisions reported for this configuration should be further investigated in netlist timing simulations for improved accuracy. %m", "XPM_MEMORY", 30, 25, MESSAGE_CONTROL);
    if (WRITE_DATA_WIDTH_A > 4608 || READ_DATA_WIDTH_A > 4608)
      $warning("[%s %0d-%0d] This configuration has WRITE_DATA_WIDTH_A of (%0d) and  READ_DATA_WIDTH_A of (%0d), but in this release of XPM_MEMORY, the configurations having write/read data widths greater than 4608 are not completely verified. %m", "XPM_MEMORY", 30, 26, WRITE_DATA_WIDTH_A,READ_DATA_WIDTH_A);
    if (WRITE_DATA_WIDTH_B > 4608 || READ_DATA_WIDTH_B > 4608)
      $warning("[%s %0d-%0d] This configuration has WRITE_DATA_WIDTH_B of (%0d) and  READ_DATA_WIDTH_B (%0d), but in this release of XPM_MEMORY, the configurations having write/read data widths greater than 4608 are not completely verified. %m", "XPM_MEMORY", 30, 27 , WRITE_DATA_WIDTH_B,READ_DATA_WIDTH_B);
    if ( `MEM_TYPE_RAM_TDP && (BYTE_WRITE_WIDTH_A == 8 || BYTE_WRITE_WIDTH_A == 9) && (READ_DATA_WIDTH_B == BYTE_WRITE_WIDTH_B && WRITE_DATA_WIDTH_B == BYTE_WRITE_WIDTH_B) && (READ_DATA_WIDTH_B % BYTE_WRITE_WIDTH_A != 0 || WRITE_DATA_WIDTH_B % BYTE_WRITE_WIDTH_A != 0))
      $warning("[%s %0d-%0d] This configuration has byte wide writes on port-A and port-B does not have byte wide writes, but in this release of XPM_MEMORY, the configurations having byte wide writes on one port and other port not having byte wide writes is not completely verified. %m", "XPM_MEMORY", 30, 28);
    if ( `MEM_TYPE_RAM_TDP && (BYTE_WRITE_WIDTH_B == 8 || BYTE_WRITE_WIDTH_B == 9) && (READ_DATA_WIDTH_A == BYTE_WRITE_WIDTH_A && WRITE_DATA_WIDTH_A == BYTE_WRITE_WIDTH_A) && (READ_DATA_WIDTH_A % BYTE_WRITE_WIDTH_B != 0 || WRITE_DATA_WIDTH_A % BYTE_WRITE_WIDTH_B != 0))
      $warning("[%s %0d-%0d] This configuration has byte wide writes on port-B and port-A does not have byte wide writes, but in this release of XPM_MEMORY, the configurations having byte wide writes on one port and other port not having byte wide writes is not completely verified. %m", "XPM_MEMORY", 30, 29);
  if (AUTO_SLEEP_TIME != 0  && `MEM_PORTA_READ && READ_LATENCY_A == 2)
      $warning("[%s %0d-%0d] The configuration specified is having non-zero Auto Sleep latency value with READ_LATENCY_A parameter value set to 2; There could be simulation mismatches between behavioral and post-synthesis simulations, please run netlist simulations for improved accuracy. %m", "XPM_MEMORY", 30, 30);
  if (AUTO_SLEEP_TIME != 0  && `MEM_PORTB_READ && READ_LATENCY_B == 2)
      $warning("[%s %0d-%0d] The configuration specified is having non-zero Auto Sleep latency value with READ_LATENCY_B  parameter value set to 2; There could be simulation mismatches between behavioral and post-synthesis simulations, please run netlist simulations for improved accuracy. %m", "XPM_MEMORY", 30, 31);

    // Errors
    if ((`MEM_TYPE_RAM_SP || `MEM_TYPE_ROM_SP) && `INDEPENDENT_CLOCKS) begin
      $error("[%s %0d-%0d] CLOCKING_MODE (%0d) specifies independent clocks, but single port RAM or single port ROM configurations require a common clock. %m", "XPM_MEMORY", 40, 2, CLOCKING_MODE);
      drc_err_flag = 1;
    end
    if (`MEM_PRIM_ULTRA && `INDEPENDENT_CLOCKS) begin
      $error("[%s %0d-%0d] CLOCKING_MODE (%0d) specifies independent clocks, but UltraRAM configurations require a common clock. %m", "XPM_MEMORY", 40, 3, CLOCKING_MODE);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && (`MEM_PRIM_BLOCK || `MEM_PRIM_ULTRA) && `MEM_PORTA_RD_COMB) begin
      $error("[%s %0d-%0d] READ_LATENCY_A (%0d) specifies a combinatorial read output for this configuration which uses port A read operations, but at least one register stage is required for block memory or UltraRAM configurations. %m", "XPM_MEMORY", 40, 5, READ_LATENCY_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && (`MEM_PRIM_BLOCK || `MEM_PRIM_ULTRA) && `MEM_PORTB_RD_COMB) begin
      $error("[%s %0d-%0d] READ_LATENCY_B (%0d) specifies a combinatorial read output for this configuration which uses port B read operations, but at least one register stage is required for block memory or UltraRAM configurations. %m", "XPM_MEMORY", 40, 6, READ_LATENCY_B);
      drc_err_flag = 1;
    end
    if (`MEM_TYPE_RAM_SDP && `MEM_PRIM_ULTRA && !`MEM_PORTB_RF && !`MEM_PORTB_WF) begin
      $error("[%s %0d-%0d] WRITE_MODE_B (%0d) specifies no-change mode, but simple dual port RAM configurations targeting UltraRAM can only mimic read-first mode or write-first mode behaviour for port B. Please change WRITE_MODE_B to either read-first mode or write-first mode. %m", "XPM_MEMORY", 40, 8, WRITE_MODE_B);
      drc_err_flag = 1;
    end
    if (`MEM_TYPE_RAM_SDP && `MEM_PRIM_ULTRA && `MEM_PORTB_WF && !`MEM_PORTB_URAM_LAT) begin
      $error("[%s %0d-%0d] READ_LATENCY_B (%0d) specifies fewer than 3 stages, but simple dual port RAM configurations targeting UltraRAM and using write-first mode for port B must use a read latency of at least 3 for port B. %m", "XPM_MEMORY", 40, 9, READ_LATENCY_B);
      drc_err_flag = 1;
    end
    if (`MEM_TYPE_ROM && !`MEM_PORTA_RF) begin
      $error("[%s %0d-%0d] WRITE_MODE_A (%0d) specifies write-first mode or no-change mode, but ROM configurations must use read-first mode for port A. %m", "XPM_MEMORY", 40, 10, WRITE_MODE_A);
      drc_err_flag = 1;
    end
    if (`MEM_TYPE_ROM_DP && !`MEM_PORTB_RF) begin
      $error("[%s %0d-%0d] WRITE_MODE_B (%0d) specifies write-first mode or no-change mode, but dual port ROM configurations must use read-first mode for port B. %m", "XPM_MEMORY", 40, 11, WRITE_MODE_B);
      drc_err_flag = 1;
    end
    if ((`MEM_TYPE_RAM_SP || `MEM_TYPE_RAM_TDP) && `MEM_PRIM_DISTRIBUTED && !`MEM_PORTA_RF) begin
      $error("[%s %0d-%0d] WRITE_MODE_A (%0d) specifies write-first mode or no-change mode, but single port and dual port distributed RAM configurations must use read-first mode for port A. %m", "XPM_MEMORY", 40, 12, WRITE_MODE_A);
      drc_err_flag = 1;
    end
    if (`MEM_TYPE_RAM_TDP && `MEM_PRIM_DISTRIBUTED && !`MEM_PORTB_RF) begin
      $error("[%s %0d-%0d] WRITE_MODE_B (%0d) specifies write-first mode or no-change mode, but dual port distributed RAM configurations must use read-first mode for port B. %m", "XPM_MEMORY", 40, 13, WRITE_MODE_B);
      drc_err_flag = 1;
    end
    if (`MEM_TYPE_RAM_TDP && `MEM_PRIM_ULTRA && !`MEM_PORTA_NC) begin
      $error("[%s %0d-%0d] WRITE_MODE_A (%0d) specifies read-first mode or write-first mode, but true dual port UltraRAM configurations must use no-change mode for port A. %m", "XPM_MEMORY", 40, 14, WRITE_MODE_A);
      drc_err_flag = 1;
    end
    if (`MEM_TYPE_RAM_TDP && `MEM_PRIM_ULTRA && !`MEM_PORTB_NC) begin
      $error("[%s %0d-%0d] WRITE_MODE_B (%0d) specifies read-first mode or write-first mode, but true dual port UltraRAM configurations must use no-change mode for port B. %m", "XPM_MEMORY", 40, 15, WRITE_MODE_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && MEMORY_SIZE % WRITE_DATA_WIDTH_A != 0 && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of WRITE_DATA_WIDTH_A (%0d) for this configuration which uses port A write operations. %m", "XPM_MEMORY", 40, 16, MEMORY_SIZE, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && MEMORY_SIZE % READ_DATA_WIDTH_A != 0 && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of READ_DATA_WIDTH_A (%0d) for this configuration which uses port A read operations. %m", "XPM_MEMORY", 40, 17, MEMORY_SIZE, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && MEMORY_SIZE % WRITE_DATA_WIDTH_B != 0 && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of WRITE_DATA_WIDTH_B (%0d) for this configuration which uses port B write operations. %m", "XPM_MEMORY", 40, 18, MEMORY_SIZE, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && MEMORY_SIZE % READ_DATA_WIDTH_B != 0 && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of READ_DATA_WIDTH_B (%0d) for this configuration which uses port B read operations. %m", "XPM_MEMORY", 40, 19, MEMORY_SIZE, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A) > ADDR_WIDTH_A && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), WRITE_DATA_WIDTH_A (%0d), and ADDR_WIDTH_A (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port A write operations. %m", "XPM_MEMORY", 40, 20, MEMORY_SIZE, WRITE_DATA_WIDTH_A, ADDR_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A) > ADDR_WIDTH_A && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), READ_DATA_WIDTH_A (%0d), and ADDR_WIDTH_A (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port A read operations. %m", "XPM_MEMORY", 40, 21, MEMORY_SIZE, READ_DATA_WIDTH_A, ADDR_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && MEMORY_SIZE/WRITE_DATA_WIDTH_A < 2 && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and WRITE_DATA_WIDTH_A (%0d) imply that the memory is not at least two words from the perspective of port A write operations. %m", "XPM_MEMORY", 40, 22, MEMORY_SIZE, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && MEMORY_SIZE/READ_DATA_WIDTH_A < 2 && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and READ_DATA_WIDTH_A (%0d) imply that the memory is not at least two words from the perspective of port A read operations. %m", "XPM_MEMORY", 40, 23, MEMORY_SIZE, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_B) > ADDR_WIDTH_B && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), WRITE_DATA_WIDTH_B (%0d), and ADDR_WIDTH_B (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port B write operations. %m", "XPM_MEMORY", 40, 24, MEMORY_SIZE, WRITE_DATA_WIDTH_B, ADDR_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B) > ADDR_WIDTH_B && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), READ_DATA_WIDTH_B (%0d), and ADDR_WIDTH_B (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port B read operations. %m", "XPM_MEMORY", 40, 25, MEMORY_SIZE, READ_DATA_WIDTH_B, ADDR_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && MEMORY_SIZE/WRITE_DATA_WIDTH_B < 2 && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and WRITE_DATA_WIDTH_B (%0d) imply that the memory is not at least two words from the perspective of port B write operations. %m", "XPM_MEMORY", 40, 26, MEMORY_SIZE, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && MEMORY_SIZE/READ_DATA_WIDTH_B < 2 && `NO_ECC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and READ_DATA_WIDTH_B (%0d) imply that the memory is not at least two words from the perspective of port B read operations. %m", "XPM_MEMORY", 40, 27, MEMORY_SIZE, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && `MEM_PORTA_READ && `MEM_PRIM_ULTRA && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_A && `NO_ECC) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_A (%0d) for this configuration which uses port A write and read operations, but symmetric port widths are required for UltraRAM configurations. %m", "XPM_MEMORY", 40, 28, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && `MEM_PORTB_READ && `MEM_PRIM_ULTRA && WRITE_DATA_WIDTH_B != READ_DATA_WIDTH_B && `NO_ECC) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this configuration which uses port B write and read operations, but symmetric port widths are required for UltraRAM configurations. %m", "XPM_MEMORY", 40, 31, WRITE_DATA_WIDTH_B, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && `MEM_PRIM_ULTRA && rst_val_conv_a(READ_RESET_VALUE_A) != 0) begin
      $error("[%s %0d-%0d] READ_RESET_VALUE_A is nonzero for this configuration which uses port A read operations, but UltraRAM configurations require a zero-valued output register reset. %m", "XPM_MEMORY", 40, 33);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && `MEM_PRIM_ULTRA && rst_val_conv_b(READ_RESET_VALUE_B) != 0) begin
      $error("[%s %0d-%0d] READ_RESET_VALUE_B is nonzero for this configuration which uses port B read operations, but UltraRAM configurations require a zero-valued output register reset. %m", "XPM_MEMORY", 40, 34);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && `MEM_PORTA_READ  && `NO_ECC && !(WRITE_DATA_WIDTH_A == 32*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_A == 16*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_A == 8*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_A == 4*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_A == 2*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_A || 32*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_A || 16*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_A || 8*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_A || 4*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_A || 2*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_A)) begin
      $error("[%s %0d-%0d] The ratio of WRITE_DATA_WIDTH_A (%0d) to READ_DATA_WIDTH_A (%0d) is not within the legal range of 32, 16, 8, 4, 2, 1, 1/2, 1/4, 1/8, 1/16, or 1/32 for this configuration which uses port A write and read operations. %m", "XPM_MEMORY", 40, 35, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && `MEM_PORTB_READ && `NO_ECC  && !(WRITE_DATA_WIDTH_A == 32*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_A == 16*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_A == 8*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_A == 4*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_A == 2*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_B || 32*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_B || 16*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_B || 8*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_B || 4*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_B || 2*WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_B)) begin
      $error("[%s %0d-%0d] The ratio of WRITE_DATA_WIDTH_A (%0d) to READ_DATA_WIDTH_B (%0d) is not within the legal range of 32, 16, 8, 4, 2, 1, 1/2, 1/4, 1/8, 1/16, or 1/32 for this configuration which uses port A write and port B read operations. %m", "XPM_MEMORY", 40, 36, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && `MEM_PORTA_READ && `NO_ECC  && !(WRITE_DATA_WIDTH_B == 32*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_B == 16*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_B == 8*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_B == 4*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_B == 2*READ_DATA_WIDTH_A || WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_A || 32*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_A || 16*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_A || 8*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_A || 4*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_A || 2*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_A)) begin
      $error("[%s %0d-%0d] The ratio of WRITE_DATA_WIDTH_B (%0d) to READ_DATA_WIDTH_A (%0d) is not within the legal range of 32, 16, 8, 4, 2, 1, 1/2, 1/4, 1/8, 1/16, or 1/32 for this configuration which uses port B write and port A read operations. %m", "XPM_MEMORY", 40, 37, WRITE_DATA_WIDTH_B, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && `MEM_PORTB_READ && `NO_ECC  && !(WRITE_DATA_WIDTH_B == 32*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_B == 16*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_B == 8*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_B == 4*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_B == 2*READ_DATA_WIDTH_B || WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_B || 32*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_B || 16*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_B || 8*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_B || 4*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_B || 2*WRITE_DATA_WIDTH_B == READ_DATA_WIDTH_B)) begin
      $error("[%s %0d-%0d] The ratio of WRITE_DATA_WIDTH_B (%0d) to READ_DATA_WIDTH_B (%0d) is not within the legal range of 32, 16, 8, 4, 2, 1, 1/2, 1/4, 1/8, 1/16, or 1/32 for this configuration which uses port B write and read operations. %m", "XPM_MEMORY", 40, 38, WRITE_DATA_WIDTH_B, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && `MEM_PORTB_READ && `NO_ECC  && !(READ_DATA_WIDTH_A == 32*READ_DATA_WIDTH_A || READ_DATA_WIDTH_A == 16*READ_DATA_WIDTH_A || READ_DATA_WIDTH_A == 8*READ_DATA_WIDTH_A || READ_DATA_WIDTH_A == 4*READ_DATA_WIDTH_A || READ_DATA_WIDTH_A == 2*READ_DATA_WIDTH_A || READ_DATA_WIDTH_A == READ_DATA_WIDTH_A || 32*READ_DATA_WIDTH_A == READ_DATA_WIDTH_A || 16*READ_DATA_WIDTH_A == READ_DATA_WIDTH_A || 8*READ_DATA_WIDTH_A == READ_DATA_WIDTH_A || 4*READ_DATA_WIDTH_A == READ_DATA_WIDTH_A || 2*READ_DATA_WIDTH_A == READ_DATA_WIDTH_A)) begin
      $error("[%s %0d-%0d] The ratio of READ_DATA_WIDTH_A (%0d) to READ_DATA_WIDTH_B (%0d) is not within the legal range of 32, 16, 8, 4, 2, 1, 1/2, 1/4, 1/8, 1/16, or 1/32 for this configuration which uses port A and port B read operations. %m", "XPM_MEMORY", 40, 39, READ_DATA_WIDTH_A, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && WRITE_DATA_WIDTH_A % BYTE_WRITE_WIDTH_A != 0) begin
      $error("[%s %0d-%0d] BYTE_WRITE_WIDTH_A (%0d) does not result in an integer number of bytes within the specified WRITE_DATA_WIDTH_A (%0d) for this configuration which uses port A write operations. %m", "XPM_MEMORY", 40, 40, BYTE_WRITE_WIDTH_A, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && WRITE_DATA_WIDTH_B % BYTE_WRITE_WIDTH_B != 0) begin
      $error("[%s %0d-%0d] BYTE_WRITE_WIDTH_B (%0d) does not result in an integer number of bytes within the specified WRITE_DATA_WIDTH_B (%0d) for this configuration which uses port B write operations. %m", "XPM_MEMORY", 40, 41, BYTE_WRITE_WIDTH_B, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (32'(MEMORY_INIT_FILE) == ".coe" || 32'(MEMORY_INIT_FILE) == ".COE") begin
      $error("[%s %0d-%0d] MEMORY_INIT_FILE (%0s) specifies a file with a .coe extension, but XPM_MEMORY does not support the COE file format. %m", "XPM_MEMORY", 40, 43, MEMORY_INIT_FILE);
      drc_err_flag = 1;
    end
    if ( (`MEM_PRIM_AUTO || `MEM_PRIM_DISTRIBUTED) &&  (WAKEUP_TIME != 0)) begin
      $error("[%s %0d-%0d] Wake up time of (%0d) is not valid when the Memory Primitive is set to %d.", "XPM_MEMORY", 40, 42, WAKEUP_TIME,MEMORY_PRIMITIVE);
      drc_err_flag = 1;
    end 
    if (`MEM_PORTA_WRITE && `MEM_PORTA_READ && `MEM_PRIM_DISTRIBUTED && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_A) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_A (%0d) for this configuration which uses port A write and read operations, but symmetric port widths are required for Distributed RAM configurations. %m", "XPM_MEMORY", 40, 44, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && `MEM_PORTB_READ && `MEM_PRIM_DISTRIBUTED && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this configuration which uses port A write and port B read operations, but symmetric port widths are required for Distributed RAM configurations. %m", "XPM_MEMORY", 40, 45, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && `MEM_PORTA_READ && `MEM_PRIM_DISTRIBUTED && WRITE_DATA_WIDTH_B != READ_DATA_WIDTH_A) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) does not equal READ_DATA_WIDTH_A (%0d) for this configuration which uses port B write and port A read operations, but symmetric port widths are required for Distributed RAM configurations. %m", "XPM_MEMORY", 40, 46, WRITE_DATA_WIDTH_B, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && `MEM_PORTB_READ && `MEM_PRIM_DISTRIBUTED && WRITE_DATA_WIDTH_B != READ_DATA_WIDTH_B) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this configuration which uses port B write and read operations, but symmetric port widths are required for Distributed RAM configurations. %m", "XPM_MEMORY", 40, 47, WRITE_DATA_WIDTH_B, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if ((MEMORY_INIT_FILE != "none" && MEMORY_INIT_FILE != "NONE" && MEMORY_INIT_FILE != "None") && MEMORY_SIZE > 192*1024*1024) begin
      $error("[%s %0d-%0d] Memory size of (%0d) is specified for this configuration with memory initialization, but XPM_MEMORY supports initialization up to 5 million bits only. %m", "XPM_MEMORY", 40, 48, MEMORY_SIZE);
      drc_err_flag = 1;
    end
    if (`MEM_TYPE_RAM_SDP && `MEM_PRIM_DISTRIBUTED && !`MEM_PORTB_RF) begin
      $error("[%s %0d-%0d] WRITE_MODE_B (%0d) specifies write-first or no-change mode , but Simple Dual port distributed RAM configurations must use read-first mode for port B. %m", "XPM_MEMORY", 40, 49, WRITE_MODE_B);
      drc_err_flag = 1;
    end
    if (`MEM_TYPE_RAM_SDP && `MEM_PRIM_BLOCK && !(`MEM_PORTB_RF || `MEM_PORTB_NC)) begin
      $error("[%s %0d-%0d] WRITE_MODE_B (%0d) specifies write-first mode , but Simple Dual port block RAM configurations must use read-first mode for port B. %m", "XPM_MEMORY", 40, 50, WRITE_MODE_B);
      drc_err_flag = 1;
    end
    if ((MEMORY_INIT_PARAM != "" && MEMORY_INIT_PARAM != "0") && MEMORY_SIZE > 4*1024) begin
      $error("[%s %0d-%0d] Memory size of (%0d) is specified for this configuration with memory initialization through parameter, but XPM_MEMORY supports initialization through parameter up to memory size of 4k bits only. %m", "XPM_MEMORY", 40, 51, MEMORY_SIZE);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && `MEM_PORTB_WRITE && `MEM_PORTA_WR_BYTE && `MEM_PORTB_WR_BYTE && (BYTE_WRITE_WIDTH_A != BYTE_WRITE_WIDTH_B)) begin
      $error("[%s %0d-%0d] BYTE_WRITE_WIDTH_A (%0d) does not equal BYTE_WRITE_WIDTH_B (%0d) for this configuration which uses port A byte wide write and port B byte wide write operations, but symmetric byte write widths are required for this configuration. %m", "XPM_MEMORY", 40, 52, BYTE_WRITE_WIDTH_A, BYTE_WRITE_WIDTH_B);
      drc_err_flag = 1;
    end

    if (!(32'(MEMORY_INIT_FILE) == ".mem" || 32'(MEMORY_INIT_FILE) == ".MEM") && (MEMORY_INIT_FILE != "none" && MEMORY_INIT_FILE != "NONE" && MEMORY_INIT_FILE != "None") ) begin
      $error("[%s %0d-%0d] MEMORY_INIT_FILE (%0s) specified a file without .mem extension, but XPM_MEMORY supports Initialization files with MEM file format only. %m", "XPM_MEMORY", 40, 53, MEMORY_INIT_FILE);
      drc_err_flag = 1;
    end

// DRCs related to ECC
    if (!(`NO_ECC) && !(`MEM_PRIM_BLOCK || `MEM_PRIM_ULTRA)) begin
      $error("[%s %0d-%0d] The configuration specified has ECC_MODE(%0d) parameter is set to a non-zero value and the MEMORY_PRIMITIVE(%0d) specified is other than BlockRAM or UltraRAM, but ECC feature is supported only when the MEMORY_PRIMITIVE is set to either BlockRAM or UltraRAM . %m", "XPM_MEMORY", 41, 1, ECC_MODE, MEMORY_PRIMITIVE);
      drc_err_flag = 1;
    end

    if (!(`NO_ECC) && `MEM_PRIM_BLOCK && !`MEM_TYPE_RAM_SDP) begin
      $error("[%s %0d-%0d] The configuration specified has ECC_MODE(%0d) parameter is set to a non-zero value, MEMORY_PRIMITIVE(%0d) set to BlockRAM and MEMORY_TYPE(%0d) specified is other than Simple Dual port RAM , but ECC feature is supported only when the MEMORY_TYPE is set to simple Dual port RAM . %m", "XPM_MEMORY", 41, 2, ECC_MODE, MEMORY_PRIMITIVE, MEMORY_TYPE);
      drc_err_flag = 1;
    end

    if (!(`NO_ECC) && `MEM_PRIM_ULTRA && !(`MEM_TYPE_RAM_SP || `MEM_TYPE_RAM_SDP || `MEM_TYPE_RAM_TDP)) begin
      $error("[%s %0d-%0d] The configuration specified has ECC_MODE(%0d) parameter is set to a non-zero value, MEMORY_PRIMITIVE(%0d) set to  ultraRAM and MEMORY_TYPE(%0d) specified is other than Simple Dual port RAM , but ECC feature is supported only when the MEMORY_TYPE is set to simple Dual port RAM . %m", "XPM_MEMORY", 41, 3, ECC_MODE, MEMORY_PRIMITIVE, MEMORY_TYPE);
      drc_err_flag = 1;
    end

// Both_Enc_Dec
    if (`MEM_PORTA_WRITE && `MEM_PORTA_READ && `MEM_PRIM_ULTRA && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_A && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_A (%0d) for this configuration which uses port A write and read operations with ECC mode(both encode and decode) enabled, but this configuration requires symmetric write and read data widths within each enabled port. %m", "XPM_MEMORY", 41, 4, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && `MEM_PORTB_READ && `MEM_PRIM_ULTRA && WRITE_DATA_WIDTH_B != READ_DATA_WIDTH_B && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this configuration which uses port B write and read operations with ECC(both encode and decode) enabled, but this configuration requires symmetric write and read data widths within each enabled port. %m", "XPM_MEMORY", 41, 5, WRITE_DATA_WIDTH_B, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && `MEM_PORTB_READ && `MEM_TYPE_RAM_SDP && WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_B (%0d) for this configuration which uses port A write and port B read operations with ECC(both encode and decode) enabled, but this configuration requires symmetric write and read data widths across each enabled port. %m", "XPM_MEMORY", 41, 6, WRITE_DATA_WIDTH_A, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

    if (`MEM_PORTA_WRITE && WRITE_DATA_WIDTH_A%64 != 0 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) is not a multiple of 64 for this configuration which uses port A write with ECC mode(both encode and decode) enabled, but this configuration requires write ddata width to be multiple of 64. %m", "XPM_MEMORY", 41, 7, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && READ_DATA_WIDTH_A%64 != 0 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_A (%0d) is not a multiple of 64 for this configuration which uses port A write with ECC mode(both encode and decode) enabled, but this configuration requires write ddata width to be multiple of 64. %m", "XPM_MEMORY", 41, 8, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && WRITE_DATA_WIDTH_B%64 != 0 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) is not a multiple of 64 for this configuration which uses port A write with ECC mode(both encode and decode) enabled, but this configuration requires write ddata width to be multiple of 64. %m", "XPM_MEMORY", 41, 9, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && READ_DATA_WIDTH_B%64 != 0 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_B (%0d) is not a multiple of 64 for this configuration which uses port A write with ECC mode(both encode and decode) enabled, but this configuration requires write ddata width to be multiple of 64. %m", "XPM_MEMORY", 41, 10, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

    if (`MEM_PORTA_WRITE && MEMORY_SIZE % WRITE_DATA_WIDTH_A != 0 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of WRITE_DATA_WIDTH_A (%0d) for this configuration which uses port A write operations. %m", "XPM_MEMORY", 41, 11, MEMORY_SIZE, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && MEMORY_SIZE % READ_DATA_WIDTH_A != 0 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of READ_DATA_WIDTH_A (%0d) for this configuration which uses port A read operations. %m", "XPM_MEMORY", 41, 12, MEMORY_SIZE, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && MEMORY_SIZE % WRITE_DATA_WIDTH_B != 0 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of WRITE_DATA_WIDTH_B (%0d) for this configuration which uses port B write operations. %m", "XPM_MEMORY", 41, 13, MEMORY_SIZE, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && MEMORY_SIZE % READ_DATA_WIDTH_B != 0 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of READ_DATA_WIDTH_B (%0d) for this configuration which uses port B read operations. %m", "XPM_MEMORY", 41, 14, MEMORY_SIZE, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A) > ADDR_WIDTH_A && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), WRITE_DATA_WIDTH_A (%0d), and ADDR_WIDTH_A (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port A write operations. %m", "XPM_MEMORY", 41, 15, MEMORY_SIZE, WRITE_DATA_WIDTH_A, ADDR_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A) > ADDR_WIDTH_A && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), READ_DATA_WIDTH_A (%0d), and ADDR_WIDTH_A (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port A read operations. %m", "XPM_MEMORY", 41, 16, MEMORY_SIZE, READ_DATA_WIDTH_A, ADDR_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && MEMORY_SIZE/WRITE_DATA_WIDTH_A < 2 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and WRITE_DATA_WIDTH_A (%0d) imply that the memory is not at least two words from the perspective of port A write operations. %m", "XPM_MEMORY", 41, 17, MEMORY_SIZE, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && MEMORY_SIZE/READ_DATA_WIDTH_A < 2 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and READ_DATA_WIDTH_A (%0d) imply that the memory is not at least two words from the perspective of port A read operations. %m", "XPM_MEMORY", 41, 18, MEMORY_SIZE, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_B) > ADDR_WIDTH_B && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), WRITE_DATA_WIDTH_B (%0d), and ADDR_WIDTH_B (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port B write operations. %m", "XPM_MEMORY", 41, 19, MEMORY_SIZE, WRITE_DATA_WIDTH_B, ADDR_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B) > ADDR_WIDTH_B && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), READ_DATA_WIDTH_B (%0d), and ADDR_WIDTH_B (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port B read operations. %m", "XPM_MEMORY", 41, 20, MEMORY_SIZE, READ_DATA_WIDTH_B, ADDR_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && MEMORY_SIZE/WRITE_DATA_WIDTH_B < 2 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and WRITE_DATA_WIDTH_B (%0d) imply that the memory is not at least two words from the perspective of port B write operations. %m", "XPM_MEMORY", 41, 21, MEMORY_SIZE, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && MEMORY_SIZE/READ_DATA_WIDTH_B < 2 && `BOTH_ENC_DEC) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and READ_DATA_WIDTH_B (%0d) imply that the memory is not at least two words from the perspective of port B read operations. %m", "XPM_MEMORY", 41, 22, MEMORY_SIZE, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

// Enc_Only
    if (`MEM_PORTA_WRITE && `MEM_PORTA_READ && `MEM_PRIM_ULTRA && READ_DATA_WIDTH_A != (WRITE_DATA_WIDTH_A + (WRITE_DATA_WIDTH_A/64)*8) && `ENC_ONLY) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_A (%0d) does not equal WRITE_DATA_WIDTH_A + number of syndrome bits (%0d) for this configuration which uses port A write and read operations with ECC mode(encode only) enabled, but this configuration requires symmetric write and read data widths within each enabled port. %m", "XPM_MEMORY", 41, 50, READ_DATA_WIDTH_A, (WRITE_DATA_WIDTH_A + (WRITE_DATA_WIDTH_A/64)*8));
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && `MEM_PORTB_READ && `MEM_PRIM_ULTRA && READ_DATA_WIDTH_B != (WRITE_DATA_WIDTH_B + (WRITE_DATA_WIDTH_B/64)*8) && `ENC_ONLY) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_B (%0d) does not equal WRITE_DATA_WIDTH_B + number of syndrome bits (%0d) for this configuration which uses port B write and read operations with ECC(encode only) enabled, but this configuration requires symmetric write and read data widths within each enabled port. %m", "XPM_MEMORY", 41, 51, READ_DATA_WIDTH_B, (WRITE_DATA_WIDTH_B + (WRITE_DATA_WIDTH_B/64)*8));
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && `MEM_PORTB_READ && `MEM_TYPE_RAM_SDP && READ_DATA_WIDTH_B != (WRITE_DATA_WIDTH_A + (WRITE_DATA_WIDTH_A/64)*8) && `ENC_ONLY) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_B (%0d) does not equal WRITE_DATA_WIDTH_A + number of syndrome bits (%0d) for this configuration which uses port A write and port B read operations with ECC(encode only) enabled, but this configuration requires symmetric write and read data widths across each enabled port. %m", "XPM_MEMORY", 41, 52, READ_DATA_WIDTH_B, (WRITE_DATA_WIDTH_A + (WRITE_DATA_WIDTH_A/64)*8));
      drc_err_flag = 1;
    end

    if (`MEM_PORTA_WRITE && WRITE_DATA_WIDTH_A%64 != 0 && `ENC_ONLY) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) is not a multiple of 64 for this configuration which uses port A write with ECC mode(encode only) enabled, but this configuration requires write data width to be multiple of 64. %m", "XPM_MEMORY", 41, 53, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && READ_DATA_WIDTH_A%72 != 0 && `ENC_ONLY) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_A (%0d) is not a multiple of 72 for this configuration which uses port A read with ECC mode(encode only) enabled, but this configuration requires read data width to be multiple of 72. %m", "XPM_MEMORY", 41, 54, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && WRITE_DATA_WIDTH_B%64 != 0 && `ENC_ONLY) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) is not a multiple of 64 for this configuration which uses port B write with ECC mode(encode only) enabled, but this configuration requires write data width to be multiple of 64. %m", "XPM_MEMORY", 41, 55, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && READ_DATA_WIDTH_B%72 != 0 && `ENC_ONLY) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_B (%0d) is not a multiple of 72 for this configuration which uses port B read with ECC mode(encode only) enabled, but this configuration requires write data width to be multiple of 72. %m", "XPM_MEMORY", 41, 56, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

    if (`MEM_PORTA_READ && MEMORY_SIZE % READ_DATA_WIDTH_A != 0 && `ENC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of READ_DATA_WIDTH_A (%0d) for this configuration which uses port A read operations. %m", "XPM_MEMORY", 41, 57, MEMORY_SIZE, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && MEMORY_SIZE % READ_DATA_WIDTH_B != 0 && `ENC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of READ_DATA_WIDTH_B (%0d) for this configuration which uses port B read operations. %m", "XPM_MEMORY", 41, 58, MEMORY_SIZE, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A) > ADDR_WIDTH_A && `ENC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), READ_DATA_WIDTH_A (%0d), and ADDR_WIDTH_A (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port A read operations. %m", "XPM_MEMORY", 41, 59, MEMORY_SIZE, READ_DATA_WIDTH_A, ADDR_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && MEMORY_SIZE/READ_DATA_WIDTH_A < 2 && `ENC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and READ_DATA_WIDTH_A (%0d) imply that the memory is not at least two words from the perspective of port A read operations. %m", "XPM_MEMORY", 41, 60, MEMORY_SIZE, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B) > ADDR_WIDTH_B && `ENC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), READ_DATA_WIDTH_B (%0d), and ADDR_WIDTH_B (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port B read operations. %m", "XPM_MEMORY", 41, 62, MEMORY_SIZE, READ_DATA_WIDTH_B, ADDR_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && MEMORY_SIZE/READ_DATA_WIDTH_B < 2 && `ENC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and READ_DATA_WIDTH_B (%0d) imply that the memory is not at least two words from the perspective of port B read operations. %m", "XPM_MEMORY", 41, 63, MEMORY_SIZE, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

// Dec_Only
    if (`MEM_PORTA_WRITE && `MEM_PORTA_READ && `MEM_PRIM_ULTRA && WRITE_DATA_WIDTH_A != (READ_DATA_WIDTH_A + (READ_DATA_WIDTH_A/64)*8) && `DEC_ONLY) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_A + number of syndrome bits (%0d) for this configuration which uses port A write and read operations with ECC mode(decode only) enabled, but this configuration requires symmetric write and read data widths within each enabled port. %m", "XPM_MEMORY", 41, 100, WRITE_DATA_WIDTH_A, (READ_DATA_WIDTH_A + (READ_DATA_WIDTH_A/64)*8));
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && `MEM_PORTB_READ && `MEM_PRIM_ULTRA && WRITE_DATA_WIDTH_B != (READ_DATA_WIDTH_B + (READ_DATA_WIDTH_B/64)*8) && `DEC_ONLY) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) does not equal READ_DATA_WIDTH_B + number of syndrome bits (%0d) for this configuration which uses port B write and read operations with ECC(decode only) enabled, but this configuration requires symmetric write and read data widths within each enabled port. %m", "XPM_MEMORY", 41, 101, WRITE_DATA_WIDTH_B, (READ_DATA_WIDTH_B + (READ_DATA_WIDTH_B/64)*8));
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && `MEM_PORTB_READ && `MEM_TYPE_RAM_SDP && WRITE_DATA_WIDTH_A != (READ_DATA_WIDTH_B + (READ_DATA_WIDTH_B/64)*8) && `DEC_ONLY) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) does not equal READ_DATA_WIDTH_B + number of syndrome bits (%0d) for this configuration which uses port A write and port B read operations with ECC(decode only) enabled, but this configuration requires symmetric write and read data widths across each enabled port. %m", "XPM_MEMORY", 41, 102, WRITE_DATA_WIDTH_A, (READ_DATA_WIDTH_B + (READ_DATA_WIDTH_B/64)*8));
      drc_err_flag = 1;
    end

    if (`MEM_PORTA_WRITE && WRITE_DATA_WIDTH_A%72 != 0 && `DEC_ONLY) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_A (%0d) is not a multiple of 72 for this configuration which uses port A write with ECC mode(decode only) enabled, but this configuration requires write data width to be multiple of 72. %m", "XPM_MEMORY", 41, 103, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_READ && READ_DATA_WIDTH_A%64 != 0 && `DEC_ONLY) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_A (%0d) is not a multiple of 64 for this configuration which uses port A read with ECC mode(decode only) enabled, but this configuration requires write data width to be multiple of 64. %m", "XPM_MEMORY", 41, 104, READ_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && WRITE_DATA_WIDTH_B%72 != 0 && `DEC_ONLY) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH_B (%0d) is not a multiple of 72 for this configuration which uses port B write with ECC mode(decode only) enabled, but this configuration requires write data width to be multiple of 72. %m", "XPM_MEMORY", 41, 105, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_READ && READ_DATA_WIDTH_B%64 != 0 && `DEC_ONLY) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH_B (%0d) is not a multiple of 64 for this configuration which uses port B write with ECC mode(decode only) enabled, but this configuration requires write data width to be multiple of 64. %m", "XPM_MEMORY", 41, 106, READ_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

    if (`MEM_PORTA_WRITE && MEMORY_SIZE % WRITE_DATA_WIDTH_A != 0 && `DEC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of WRITE_DATA_WIDTH_A (%0d) for this configuration which uses port A write operations. %m", "XPM_MEMORY", 41, 107, MEMORY_SIZE, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && MEMORY_SIZE % WRITE_DATA_WIDTH_B != 0 && `DEC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) is not an integer multiple of WRITE_DATA_WIDTH_B (%0d) for this configuration which uses port B write operations. %m", "XPM_MEMORY", 41, 108, MEMORY_SIZE, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A) > ADDR_WIDTH_A && `DEC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), WRITE_DATA_WIDTH_A (%0d), and ADDR_WIDTH_A (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port A write operations. %m", "XPM_MEMORY", 41, 109, MEMORY_SIZE, WRITE_DATA_WIDTH_A, ADDR_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTA_WRITE && MEMORY_SIZE/WRITE_DATA_WIDTH_A < 2 && `DEC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and WRITE_DATA_WIDTH_A (%0d) imply that the memory is not at least two words from the perspective of port A write operations. %m", "XPM_MEMORY", 41, 110, MEMORY_SIZE, WRITE_DATA_WIDTH_A);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_B) > ADDR_WIDTH_B && `DEC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d), WRITE_DATA_WIDTH_B (%0d), and ADDR_WIDTH_B (%0d) together imply that the memory size exceeds its addressable range for this configuration which uses port B write operations. %m", "XPM_MEMORY", 41, 111, MEMORY_SIZE, WRITE_DATA_WIDTH_B, ADDR_WIDTH_B);
      drc_err_flag = 1;
    end
    if (`MEM_PORTB_WRITE && MEMORY_SIZE/WRITE_DATA_WIDTH_B < 2 && `DEC_ONLY) begin
      $error("[%s %0d-%0d] MEMORY_SIZE (%0d) and WRITE_DATA_WIDTH_B (%0d) imply that the memory is not at least two words from the perspective of port B write operations. %m", "XPM_MEMORY", 41, 112, MEMORY_SIZE, WRITE_DATA_WIDTH_B);
      drc_err_flag = 1;
    end

    if (!(`NO_ECC) && `MEM_PORTA_WRITE && (WRITE_DATA_WIDTH_A != BYTE_WRITE_WIDTH_A)) begin
      $error("[%s %0d-%0d] The configuration specified has ECC_MODE(%0d) parameter is set to a non-zero value, WRITE_DATA_WIDTH_A(%0d) is not equal to BYTE_WRITE_WIDTH_A(%0d) specified, but byte wide write operations are not allowed when ECC feature is enabled . %m", "XPM_MEMORY", 41, 113, ECC_MODE, WRITE_DATA_WIDTH_A, BYTE_WRITE_WIDTH_A);
      drc_err_flag = 1;
    end

    if (!(`NO_ECC) && `MEM_PORTB_WRITE && (WRITE_DATA_WIDTH_B != BYTE_WRITE_WIDTH_B)) begin
      $error("[%s %0d-%0d] The configuration specified has ECC_MODE(%0d) parameter is set to a non-zero value, WRITE_DATA_WIDTH_B(%0d) is not equal to BYTE_WRITE_WIDTH_B(%0d) specified, but byte wide write operations are not allowed when ECC feature is enabled . %m", "XPM_MEMORY", 41, 114, ECC_MODE, WRITE_DATA_WIDTH_B, BYTE_WRITE_WIDTH_B);
      drc_err_flag = 1;
    end

    if (!(`NO_ECC) && `MEM_PORTA_READ && rst_val_conv_a(READ_RESET_VALUE_A) != 0) begin
      $error("[%s %0d-%0d] The configuration specified has ECC_MODE(%0d) enabled and non-zero READ_RESET_VALUE_A (%0h) value is specified, but non-zero reset value is not supported when ECC_MODE is enabled. %m", "XPM_MEMORY", 41, 115, ECC_MODE, READ_RESET_VALUE_A);
      drc_err_flag = 1;
    end

    if (!(`NO_ECC) && `MEM_PORTB_READ && rst_val_conv_b(READ_RESET_VALUE_B) != 0) begin
      $error("[%s %0d-%0d] The configuration specified has ECC_MODE(%0d) enabled and non-zero READ_RESET_VALUE_B (%0h) value is specified, but non-zero reset value is not supported when ECC_MODE is enabled. %m", "XPM_MEMORY", 41, 116, ECC_MODE, READ_RESET_VALUE_B);
      drc_err_flag = 1;
    end

// DRCs related to Auto Sleep
    if (AUTO_SLEEP_TIME != 0 && !`MEM_PRIM_ULTRA) begin
      $error("[%s %0d-%0d] AUTO_SLEEP_TIME (%0d) value specified is non-zero for this configuration which has MEMORY_PRIMITIVE (%0d) value other than ultraRAM, but the auto sleep feature is supported only by UltraRAM primitive. %m", "XPM_MEMORY", 40, 52, AUTO_SLEEP_TIME,MEMORY_PRIMITIVE);
      drc_err_flag = 1;
    end
    if (AUTO_SLEEP_TIME != 0 && WAKEUP_TIME != 0) begin
      $error("[%s %0d-%0d] The configuration specified has non-zero AUTO_SLEEP_TIME (%0d) and WAKEUP_TIME (%0d), but both of these features cannot co-exist. %m", "XPM_MEMORY", 40, 53, AUTO_SLEEP_TIME,WAKEUP_TIME);
      drc_err_flag = 1;
    end

// DRCs related to Reset Mode
    if (`ASYNC_RESET_A && !(`MEM_PRIM_BLOCK || `MEM_PRIM_ULTRA)) begin
      $error("[%s %0d-%0d] The configuration specified has RST_MODE_A parameter is set ASYNC and the MEMORY_PRIMITIVE(%0d) specified is other than BlockRAM or UltraRAM, but Asynchronous Reset is supported only when the MEMORY_PRIMITIVE is set to either BlockRAM or UltraRAM . %m", "XPM_MEMORY", 40, 54, MEMORY_PRIMITIVE);
      drc_err_flag = 1;
    end

    if (`ASYNC_RESET_B && !(`MEM_PRIM_BLOCK || `MEM_PRIM_ULTRA)) begin
      $error("[%s %0d-%0d] The configuration specified has RST_MODE_B parameter is set ASYNC and the MEMORY_PRIMITIVE(%0d) specified is other than BlockRAM or UltraRAM, but Asynchronous Reset is supported only when the MEMORY_PRIMITIVE is set to either BlockRAM or UltraRAM . %m", "XPM_MEMORY", 40, 54, MEMORY_PRIMITIVE);
      drc_err_flag = 1;
    end

// DRCs related to Read Reset Value
    if (`ASYNC_RESET_A && (READ_RESET_VALUE_A != "0")) begin
      $error("[%s %0d-%0d] The configuration specified has RST_MODE_A parameter is set ASYNC and the READ_RESET_VALUE_A specified is Non-Zero value, but Non-Zero Reset value not allowed when RST_MODE_A is Asynchronous. %m", "XPM_MEMORY", 40, 55);
      drc_err_flag = 1;
    end

    if (`ASYNC_RESET_B && (READ_RESET_VALUE_B != "0")) begin
      $error("[%s %0d-%0d] The configuration specified has RST_MODE_B parameter is set ASYNC and the READ_RESET_VALUE_B specified is Non-Zero value, but Non-Zero Reset value not allowed when RST_MODE_B is Asynchronous. %m", "XPM_MEMORY", 40, 56);
      drc_err_flag = 1;
    end

// DRCs related to Mixed Mode Primitives
    if (`MEM_PRIM_MIXED && (!`NO_ECC || AUTO_SLEEP_TIME != 0)) begin
      $error("[%s %0d-%0d] ECC and Auto Sleep features not supported for Mixed Mode Primitives. %m", "XPM_MEMORY", 4, 1);
      drc_err_flag = 1;
    end

    if (`MEM_PRIM_MIXED && (`MEM_TYPE_ROM_SP || `MEM_TYPE_ROM_DP)) begin
      $error("[%s %0d-%0d] Mixed Mode Primitives does not support ROM configurations. %m", "XPM_MEMORY", 4, 2);
      drc_err_flag = 1;
    end

    if (`MEM_PRIM_MIXED && ((`MEM_PORTA_WRITE && `MEM_PORTA_NC) || (`MEM_PORTB_WRITE && `MEM_PORTB_NC))) begin
      $error("[%s %0d-%0d] Mixed Mode Primitives does not support No_Change on Write Mode. %m", "XPM_MEMORY", 4, 3);
      drc_err_flag = 1;
    end

    if (`MEM_PRIM_MIXED && ((`MEM_TYPE_RAM_TDP && (WRITE_DATA_WIDTH_A != WRITE_DATA_WIDTH_B)) || (`MEM_TYPE_RAM_SDP && (WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B)))) begin
      $error("[%s %0d-%0d] Mixed Mode Primitives does not support Asymmetric Data Width. %m", "XPM_MEMORY", 4, 4);
      drc_err_flag = 1;
    end

    if (drc_err_flag == 1)
      #1 $finish;
  end : config_drc

  // -------------------------------------------------------------------------------------------------------------------
  // Memory array declaration and initialization
  // -------------------------------------------------------------------------------------------------------------------
  
  (* ram_style = P_MEMORY_PRIMITIVE,
     rom_style = P_MEMORY_PRIMITIVE,
     rw_addr_collision = P_SDP_WRITE_MODE,
     ram_ecc = P_ECC_MODE,
     cascade_height = CASCADE_HEIGHT,
     ram_optimization = P_MEMORY_OPT *) reg [P_MIN_WIDTH_DATA_ECC-1:0] mem [0:P_MAX_DEPTH_DATA-1];

  // Initialization through parameter
  // Parameter and variable declarations
    localparam NUM_CHAR_LOC = (MEMORY_INIT_PARAM == "" || MEMORY_INIT_PARAM == "0") ? 0 : (P_MIN_WIDTH_DATA%4 == 0) ? (P_MIN_WIDTH_DATA/4) : ((P_MIN_WIDTH_DATA/4)+1);
    localparam MAX_NUM_CHAR = (MEMORY_INIT_PARAM == "" || MEMORY_INIT_PARAM == "0") ? 0 : P_MAX_DEPTH_DATA * NUM_CHAR_LOC + P_MAX_DEPTH_DATA;
  // constants declared to eliminate the eloboration warnings in modelsim, vcs and ies
    localparam P_MIN_WIDTH_DATA_SHFT = (P_MIN_WIDTH_DATA <= 4) ? 5 : P_MIN_WIDTH_DATA;
    localparam P_MIN_WIDTH_DATA_LDW  = (P_MIN_WIDTH_DATA <= 4) ? P_MIN_WIDTH_DATA : 4;
    integer num_char_in_param=0;
  
  // Function to calculate the number of characters in the string
    function integer num_char_init;
      input [(MAX_NUM_CHAR+1)*8-1:0]    str_i;
      num_char_init = 0;
      for(integer char_cnt=0; char_cnt<=MAX_NUM_CHAR; char_cnt=char_cnt+1)
        begin
          if(str_i[(char_cnt*8)+7 -: 8] != "")
             num_char_init = num_char_init+1;
        end
    endfunction
  
  // Function that parses the string and returns the initialized array to the memory
    function [P_MAX_DEPTH_DATA-1:0] [P_MIN_WIDTH_DATA-1:0] init_param_memory;
      input         [(MAX_NUM_CHAR+1)*8-1:0]  mem_init_param_reg;
      reg [3:0]                               ascii_to_binary_reg;
      reg [P_MIN_WIDTH_DATA-1:0]              conv_bin_val;
      integer                                 mem_location;
      integer                                 num_char;
        conv_bin_val = {P_MIN_WIDTH_DATA{1'b0}};
        mem_location = 0;
        num_char = 0;
        for (integer init_char=MAX_NUM_CHAR+1; init_char>0; init_char = init_char-1) begin : ascii_to_bin_loop
          if((mem_init_param_reg[(init_char*8)-1 -: 8] == 8'h2c) || (mem_init_param_reg[(init_char*8)-1 -: 8] == 8'h3b) || 
               (mem_init_param_reg[(init_char*8)-1 -: 8] == 8'h00)) begin
            ascii_to_binary_reg = 4'h0;
            if (num_char > 0) // Check at least for one valid character before encountering the delimiter or NULL
              begin
                init_param_memory[mem_location] = conv_bin_val[P_MIN_WIDTH_DATA-1:0];
                mem_location = mem_location+1;
              end
            conv_bin_val = {P_MIN_WIDTH_DATA{1'b0}};
            num_char = 0;
          end
          else if(mem_init_param_reg[(init_char*8)-1 -: 8] != 8'h00) begin
            ascii_to_binary_reg = str_val_binary(mem_init_param_reg[(init_char*8)-1 -: 8]);
            if (P_MIN_WIDTH_DATA <= 4)
              conv_bin_val = ascii_to_binary_reg[P_MIN_WIDTH_DATA_LDW-1:0]; // converted 4-bit value from ASCII
            else begin
              conv_bin_val = {conv_bin_val[P_MIN_WIDTH_DATA_SHFT-5:0], ascii_to_binary_reg}; // Store the converted value in shift register
              //conv_bin_val = conv_bin_val<<4 | ascii_to_binary_reg; // Store the converted value in shift register
            end
            num_char = num_char+1; // Increment number of characters parsed
            if(num_char > NUM_CHAR_LOC)
              $error("Number of characters given in the Initialization string exceeded the memory width, Please enter a valid string");
          end
        end : ascii_to_bin_loop
    endfunction

generate 
if(IGNORE_INIT_SYNTH == 0) begin : gen_no_ignore_init_synth
  // Initialize memory array to the data file content if file name is specified, or to all zeroes if it is not specified
  initial begin
    if (`NO_MEMORY_INIT) begin : init_zeroes
      integer initword;
      for (initword=0; initword<P_MAX_DEPTH_DATA; initword=initword+1) begin
        mem[initword] = {P_MIN_WIDTH_DATA{1'b0}};
      end
    end : init_zeroes
    else if (!(MEMORY_INIT_PARAM == "0" || MEMORY_INIT_PARAM == "")) begin : init_param
      reg [P_MAX_DEPTH_DATA-1:0] [P_MIN_WIDTH_DATA-1:0] mem_param;
      num_char_in_param = num_char_init(MEMORY_INIT_PARAM);
      assert (num_char_in_param <= MAX_NUM_CHAR) // Check if the string length exceeds the depth of the memory size
      else
        $error("No.of characters given in the Initialization Parameter string exceeds the Memory Size");
      mem_param = init_param_memory({MEMORY_INIT_PARAM, 8'h0}); //Append NULL to identify the end of string
      for(integer mem_location=0; mem_location<P_MAX_DEPTH_DATA; mem_location=mem_location+1)
        mem[mem_location] = mem_param[mem_location]; //assign the initial value to the memory
    end : init_param    
    else begin : init_datafile
        #10;
      $readmemh(MEMORY_INIT_FILE, mem, 0, P_MAX_DEPTH_DATA-1);
    end : init_datafile
  end
end : gen_no_ignore_init_synth
if(IGNORE_INIT_SYNTH == 1) begin : gen_ignore_init_synth
  // Initialize memory array to the data file content if file name is specified, or to all zeroes if it is not specified
  initial begin
    if (`NO_MEMORY_INIT) begin : init_zeroes
      integer initword;
      for (initword=0; initword<P_MAX_DEPTH_DATA; initword=initword+1) begin
        mem[initword] = {P_MIN_WIDTH_DATA{1'b0}};
      end
    end : init_zeroes
    else if (!(MEMORY_INIT_PARAM == "0" || MEMORY_INIT_PARAM == "")) begin : init_param
      reg [P_MAX_DEPTH_DATA-1:0] [P_MIN_WIDTH_DATA-1:0] mem_param;
      num_char_in_param = num_char_init(MEMORY_INIT_PARAM);
      assert (num_char_in_param <= MAX_NUM_CHAR) // Check if the string length exceeds the depth of the memory size
      else
        $error("No.of characters given in the Initialization Parameter string exceeds the Memory Size");
      mem_param = init_param_memory({MEMORY_INIT_PARAM, 8'h0}); //Append NULL to identify the end of string
      for(integer mem_location=0; mem_location<P_MAX_DEPTH_DATA; mem_location=mem_location+1)
        mem[mem_location] = mem_param[mem_location]; //assign the initial value to the memory
    end : init_param    
  // synthesis translate_off
    else begin : init_datafile
        #10;
      $readmemh(MEMORY_INIT_FILE, mem, 0, P_MAX_DEPTH_DATA-1);
    end : init_datafile
  // synthesis translate_on
  end
end : gen_ignore_init_synth
endgenerate

  generate
    // Function to convert ASCII value to binary 
    function [3:0] str_val_binary;
      input [7:0] str_val_ascii;
        if((str_val_ascii == 8'h30) || (str_val_ascii == 8'h31) || 
            (str_val_ascii == 8'h32) || (str_val_ascii == 8'h33) || 
             (str_val_ascii == 8'h34) || (str_val_ascii == 8'h35) || 
              (str_val_ascii == 8'h36) || (str_val_ascii == 8'h37) || 
               (str_val_ascii == 8'h38) || (str_val_ascii == 8'h39) || 
                (str_val_ascii == 8'h41) || (str_val_ascii == 8'h42) || 
                 (str_val_ascii == 8'h43) || (str_val_ascii == 8'h44) || 
                  (str_val_ascii == 8'h45) || (str_val_ascii == 8'h46) || 
                   (str_val_ascii == 8'h61) || (str_val_ascii == 8'h62) || 
                    (str_val_ascii == 8'h63) || (str_val_ascii == 8'h64) || 
                     (str_val_ascii == 8'h65) || (str_val_ascii == 8'h66) || 
                      (str_val_ascii == 8'h00)) begin
           if (!str_val_ascii[6])
              str_val_binary = str_val_ascii[3:0];
           else begin
             str_val_binary [3] = 1'b1;
             str_val_binary [2] = str_val_ascii[2] | (str_val_ascii[1] & str_val_ascii[0]);
             str_val_binary [1] = str_val_ascii[0] ^ str_val_ascii[1];
             str_val_binary [0] = !str_val_ascii[0];
           end
        end
        else
          $error("Found Invalid character while parsing the string, please cross check the value specified for either READ_RESET_VALUE_A|B or MEMORY_INIT_PARAM (if initialization of memory through parameter is used). XPM_MEMORY supports strings (hex) that contains characters 0-9, A-F and a-f.");
    endfunction
    // Function that parses the complete reset value string
    function logic [READ_DATA_WIDTH_A-1 :0] rst_val_conv_a;
      input [READ_DATA_WIDTH_A*8-1 : 0] rst_val_reg_a;
      integer rst_loop_a;
      logic [rsta_loop_iter-1 : 0] rst_val_conv_a_i;
      for (rst_loop_a=1; rst_loop_a <= rsta_loop_iter/4; rst_loop_a = rst_loop_a+1) begin
        rst_val_conv_a_i[(rst_loop_a*4)-1 -: 4] =  str_val_binary(rst_val_reg_a[(rst_loop_a*8)-1 -: 8]);
      end
      return rst_val_conv_a_i[READ_DATA_WIDTH_A-1 :0];
    endfunction

    function logic [READ_DATA_WIDTH_B-1 :0] rst_val_conv_b;
      input [READ_DATA_WIDTH_B*8-1 : 0] rst_val_reg_b;
      integer rst_loop_b;
      logic [rstb_loop_iter-1 : 0] rst_val_conv_b_i;
      for (rst_loop_b=1; rst_loop_b<= rstb_loop_iter/4; rst_loop_b = rst_loop_b+1) begin
        rst_val_conv_b_i[(rst_loop_b*4)-1 -: 4] =  str_val_binary(rst_val_reg_b[(rst_loop_b*8)-1 -: 8]);
      end
      return rst_val_conv_b_i[READ_DATA_WIDTH_B-1 :0];
    endfunction

    wire  [READ_DATA_WIDTH_A-1 : 0] douta_bb;
    wire  [READ_DATA_WIDTH_B-1 : 0] doutb_bb;

  // -------------------------------------------------------------------------------------------------------------------
  // Auto Sleep delays for port-A
  // -------------------------------------------------------------------------------------------------------------------

  wire ena_i;
  wire [(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0] wea_i;
  wire [P_WIDTH_ADDR_WRITE_A-1:0] addra_i;
  wire [WRITE_DATA_WIDTH_A-1:0] dina_i;
  wire ena_o_pipe_ctrl;
  wire regcea_i;

  if(`MEM_AUTO_SLP_EN) begin : gen_auto_slp_dly_a
    reg [P_WIDTH_ADDR_WRITE_A-1:0] addra_aslp_pipe [AUTO_SLEEP_TIME-1:0];

    // Check if write operation is allowed on Port-A, if yes then
    // generate the pipeline register stages on write enable and input data
    if (`MEM_PORTA_WRITE) begin : gen_aslp_wr_a
    reg [(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0] wea_aslp_pipe [AUTO_SLEEP_TIME-1:0];
    reg [WRITE_DATA_WIDTH_A-1:0] dina_aslp_pipe [AUTO_SLEEP_TIME-1:0];
      // Initialize the wea and dina pipelines
      initial begin
        integer aslp_initstage_a;
        for (aslp_initstage_a=0; aslp_initstage_a < AUTO_SLEEP_TIME; aslp_initstage_a=aslp_initstage_a+1) begin : for_wr_en_pipe_init
          wea_aslp_pipe[aslp_initstage_a] = {(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A){1'b0}};
          dina_aslp_pipe[aslp_initstage_a] = {WRITE_DATA_WIDTH_A{1'b0}};
        end : for_wr_en_pipe_init
      end
      // Connect the user inputs to the pipeline
      always @(posedge clka) begin
          wea_aslp_pipe[0]    <= wea;
          dina_aslp_pipe[0]   <= dina;
      end
      for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
        always @(posedge clka) begin
          wea_aslp_pipe[aslp_stage]   <= wea_aslp_pipe[aslp_stage-1];
          dina_aslp_pipe[aslp_stage]  <= dina_aslp_pipe[aslp_stage-1];
        end
      end : gen_aslp_inp_pipe
      // Assign the last stage register outputs to appropriate internal signals
      assign wea_i  = wea_aslp_pipe[AUTO_SLEEP_TIME-1];
      assign dina_i = dina_aslp_pipe[AUTO_SLEEP_TIME-1];
    end : gen_aslp_wr_a
    // If write operation is not allowed, then connect the write control signals
    // to zero
    else begin : gnd_wr_a_ctrls
      assign  wea_i  = {(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A){1'b0}};
      assign  dina_i = {(WRITE_DATA_WIDTH_A){1'b0}};
    end : gnd_wr_a_ctrls
    // Generate the pipeline register stages on addra
    // Initialize the addra pipeline
    initial begin
      integer aslp_initstage_a;
      for (aslp_initstage_a=0; aslp_initstage_a < AUTO_SLEEP_TIME; aslp_initstage_a=aslp_initstage_a+1) begin : for_addr_pipe_init
        addra_aslp_pipe[aslp_initstage_a] = {P_WIDTH_ADDR_WRITE_A{1'b0}};
      end : for_addr_pipe_init
    end
    // Connect the user inputs to the pipeline
    always @(posedge clka) begin
        addra_aslp_pipe[0]  <= addra;
    end
    for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
      always @(posedge clka) begin
        addra_aslp_pipe[aslp_stage] <= addra_aslp_pipe[aslp_stage-1];
      end
    end : gen_aslp_inp_pipe
    // Assign the last stage register outputs to internal address
    assign addra_i = addra_aslp_pipe[AUTO_SLEEP_TIME-1];
    // Check if Read Operations are allowed on Port-A and if output pipeline
    // exists
    if(`MEM_PORTA_READ) begin : gen_aslp_rd_a
      if(READ_LATENCY_A >= 2) begin : gen_aslp_dly_regce
        reg regcea_aslp_pipe [AUTO_SLEEP_TIME-1:0];
        // Initialize the regcea pipeline
        initial begin
          integer aslp_initstage_a;
          for (aslp_initstage_a=0; aslp_initstage_a < AUTO_SLEEP_TIME; aslp_initstage_a=aslp_initstage_a+1) begin : for_regce_pipe_init
            regcea_aslp_pipe[aslp_initstage_a] = 1'b0;
          end : for_regce_pipe_init
        end
        // Connect the user inputs to the pipeline
        always @(posedge clka) begin
          regcea_aslp_pipe[0] <= regcea;
        end
        for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
          always @(posedge clka) begin
            regcea_aslp_pipe[aslp_stage]  <= regcea_aslp_pipe[aslp_stage-1];
          end
        end : gen_aslp_inp_pipe
        // Assign the final pipeline output to internal regce
        assign  regcea_i = regcea_aslp_pipe[AUTO_SLEEP_TIME-1];
      end : gen_aslp_dly_regce
      else begin : gnd_regce_ctrl
        // If there are no output pipe lines, then connect to zero
        assign  regcea_i = 1'b0;
      end : gnd_regce_ctrl
      if(READ_LATENCY_A > 2) begin : gen_aslp_dly_out_pipe
        reg ena_aslp_pipe    [AUTO_SLEEP_TIME-1:0];
        // Initialize the ena pipeline
        initial begin
          integer aslp_initstage_a;
          for (aslp_initstage_a=0; aslp_initstage_a < AUTO_SLEEP_TIME; aslp_initstage_a=aslp_initstage_a+1) begin : for_en_pipe_init
            ena_aslp_pipe[aslp_initstage_a] = 1'b0;
          end : for_en_pipe_init
        end
        // Connect the user inputs to the pipeline
        always @(posedge clka) begin
          ena_aslp_pipe[0]    <= ena;
        end
        for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
          always @(posedge clka) begin
            ena_aslp_pipe[aslp_stage]   <= ena_aslp_pipe[aslp_stage-1];
          end
        end : gen_aslp_inp_pipe
        // Assign the final pipeline output to internal enable that controls the
        // output pipeline
        assign  ena_o_pipe_ctrl  = ena_aslp_pipe[AUTO_SLEEP_TIME-1];
      end : gen_aslp_dly_out_pipe
      else begin : gnd_pipe_en_ctrl
        // If there are no output pipe lines, then connect to zero
        assign ena_o_pipe_ctrl = 0;
      end : gnd_pipe_en_ctrl
    end : gen_aslp_rd_a
  end : gen_auto_slp_dly_a
  else begin : gen_nauto_slp_dly_a
    // connect all the internal control signals to the ports when auto sleep is
    // not enabled
    assign addra_i = addra;
    assign wea_i   = wea;
    assign dina_i  = dina;
    assign ena_o_pipe_ctrl  = ena;
    assign regcea_i = regcea;
  end : gen_nauto_slp_dly_a
  // Enable needs to reach URAM early compared to other inputs in Auto Sleep
  // Mode, so no pipe line stages on enable irrespective auto sleep mode
  // enabled/disabled
  assign ena_i    = ena;

  // -------------------------------------------------------------------------------------------------------------------
  // Port A write
  // -------------------------------------------------------------------------------------------------------------------

  // If the memory is any type of RAM, generate a port A write process
  if (`MEM_PORTA_WRITE && !`DISABLE_SYNTH_TEMPL) begin : gen_wr_a
    wire [P_WIDTH_ADDR_WRITE_A-1:0] addra_int = addra_i;

    // Synchronous port A write; word-wide write; port width is the narrowest of the data ports
    if (`MEM_PORTA_WR_WORD && `MEM_PORTA_WR_NARROW && `WRITE_PROT_ENABLED) begin : gen_word_narrow
      always @(posedge clka) begin
        if (ena_i) begin
          if (wea_i)
            mem[addra_int] <= dina_i;
        end
      end
    end : gen_word_narrow
    else if (`MEM_PORTA_WR_WORD && `MEM_PORTA_WR_NARROW && `WRITE_PROT_DISABLED) begin : gen_word_narrow_wp
      always @(posedge clka) begin
          if (wea_i)
            mem[addra_int] <= dina_i;
      end
    end : gen_word_narrow_wp

    // Synchronous port A write; word-wide write; port width is wider than at least one other data port;
    // not generated in port A write-first read with wide data width special case
    else if (`MEM_PORTA_WR_WORD && `MEM_PORTA_WR_WIDE &&
          !((`MEM_TYPE_RAM_SP || `MEM_TYPE_RAM_TDP) && `MEM_PORTA_WF && `MEM_PORTA_RD_WIDE) && `WRITE_PROT_ENABLED) begin : gen_word_wide
      always @(posedge clka) begin : wr_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_WRITE_A-1:0] addralsb;
        for (row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin : for_mem_rows
          addralsb = row;
          if (ena_i) begin
            if (wea_i)
              mem[{addra_int, addralsb}] <= dina_i[`ONE_ROW_OF_DIN];
          end
        end : for_mem_rows
      end : wr_sync
    end : gen_word_wide
    else if (`MEM_PORTA_WR_WORD && `MEM_PORTA_WR_WIDE &&
          !((`MEM_TYPE_RAM_SP || `MEM_TYPE_RAM_TDP) && `MEM_PORTA_WF && `MEM_PORTA_RD_WIDE) && `WRITE_PROT_DISABLED) begin : gen_word_wide_wp
      always @(posedge clka) begin : wr_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_WRITE_A-1:0] addralsb;
        for (row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin : for_mem_rows
          addralsb = row;
            if (wea_i)
              mem[{addra_int, addralsb}] <= dina_i[`ONE_ROW_OF_DIN];
        end : for_mem_rows
      end : wr_sync
    end : gen_word_wide_wp
    
    // Synchronous port A write-first read; port width is wider than at least one other data port; no output pipeline;
    // write and read combined special case
    else if (`MEM_PORTA_WF && `MEM_PORTA_RD_WIDE && `MEM_PORTA_RD_REG && `WRITE_PROT_ENABLED) begin : gen_wf_wide_reg
      always @(posedge clka) begin : wr_rd_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
        for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
          addralsb = row;
            if (ena_i) begin
              if (wea_i)
                mem[{addra_int, addralsb}] <= dina_i[`ONE_ROW_OF_DIN];
            end
        end : for_mem_rows
      end : wr_rd_sync
    end : gen_wf_wide_reg
    else if (`MEM_PORTA_WF && `MEM_PORTA_RD_WIDE && `MEM_PORTA_RD_REG && `WRITE_PROT_DISABLED) begin : gen_wf_wide_reg_wp
      always @(posedge clka) begin : wr_rd_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
        for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
          addralsb = row;
              if (wea_i)
                mem[{addra_int, addralsb}] <= dina_i[`ONE_ROW_OF_DIN];
        end : for_mem_rows
      end : wr_rd_sync
    end : gen_wf_wide_reg_wp

    // Synchronous port A write; byte-wide write; port width is the narrowest of the data ports
    else if (`MEM_PORTA_WR_BYTE && `MEM_PORTA_WR_NARROW && `WRITE_PROT_ENABLED) begin : gen_byte_narrow
      for (genvar col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin : for_mem_cols
        always @(posedge clka) begin : wr_sync
          if (ena_i) begin
            if (wea_i[col])
              mem[addra_int][`ONE_COL_OF_DINA] <= dina_i[`ONE_COL_OF_DINA];
          end
        end : wr_sync
      end : for_mem_cols
    end : gen_byte_narrow
    else if (`MEM_PORTA_WR_BYTE && `MEM_PORTA_WR_NARROW && `WRITE_PROT_DISABLED) begin : gen_byte_narrow_wp
      for (genvar col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin : for_mem_cols
        always @(posedge clka) begin : wr_sync
            if (wea_i[col])
              mem[addra_int][`ONE_COL_OF_DINA] <= dina_i[`ONE_COL_OF_DINA];
        end : wr_sync
      end : for_mem_cols
    end : gen_byte_narrow_wp
  // Error Injection in ECC modes ("Both encode and Decode" mode and "Encode_only" modes)
  // Append required synthesis attributes
    if(`BOTH_ENC_DEC || `ENC_ONLY) begin : err_inj_ecc
      (* keep = "yes", xpm_ecc_inject_sbiterr = "yes" *) wire injectsbiterra_i;
      (* keep = "yes", xpm_ecc_inject_dbiterr = "yes" *) wire injectdbiterra_i;

      // Declare injecterr inputs to synth ANDed with LSB data
      (* keep = "yes" *) wire inj_sbiterra_to_synth;
      (* keep = "yes" *) wire inj_dbiterra_to_synth;
      if(`MEM_AUTO_SLP_EN) begin : gen_aslp_dly_inj_err
        // Auto Sleep pipe line delays on the error inject signals      
        reg injsbiterra_aslp_pipe    [AUTO_SLEEP_TIME-1:0]; 
        reg injdbiterra_aslp_pipe    [AUTO_SLEEP_TIME-1:0];
        // Initialize the inject error signal's pipe-lines
        initial begin
          integer aslp_initstage_a;
          for (aslp_initstage_a=0; aslp_initstage_a<AUTO_SLEEP_TIME; aslp_initstage_a=aslp_initstage_a+1) begin : for_injerr_pipe_init
            injsbiterra_aslp_pipe[aslp_initstage_a] = 1'b0;
            injdbiterra_aslp_pipe[aslp_initstage_a] = 1'b0;
          end : for_injerr_pipe_init
        end
        // Connect the user inputs to the pipeline
        always @(posedge clka)
          begin
            injsbiterra_aslp_pipe[0]  <= injectsbiterra;
            injdbiterra_aslp_pipe[0]  <= injectdbiterra;
          end
        for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
          always @(posedge clka) begin
            injsbiterra_aslp_pipe[aslp_stage]  <= injsbiterra_aslp_pipe[aslp_stage-1];
            injdbiterra_aslp_pipe[aslp_stage]  <= injdbiterra_aslp_pipe[aslp_stage-1];
          end
        end : gen_aslp_inp_pipe
        assign injectsbiterra_i  = injsbiterra_aslp_pipe[AUTO_SLEEP_TIME-1];
        assign injectdbiterra_i  = injdbiterra_aslp_pipe[AUTO_SLEEP_TIME-1];
      end : gen_aslp_dly_inj_err
      else begin : gen_naslp_dly_inj_err
        assign injectsbiterra_i = injectsbiterra;
        assign injectdbiterra_i = injectdbiterra;
      end : gen_naslp_dly_inj_err
      //Assignment to error Injection signals passed to synthesis
      assign inj_sbiterra_to_synth = injectsbiterra_i & dina_i[0];
      assign inj_dbiterra_to_synth = injectdbiterra_i & dina_i[0];
    end : err_inj_ecc

  end : gen_wr_a

  // -------------------------------------------------------------------------------------------------------------------
  // Port B write
  // -------------------------------------------------------------------------------------------------------------------

  // -------------------------------------------------------------------------------------------------------------------
  // Auto Sleep delays for port-B
  // -------------------------------------------------------------------------------------------------------------------

  wire enb_i;
  wire [(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B)-1:0] web_i;
  wire [P_WIDTH_ADDR_WRITE_B-1:0] addrb_i;
  wire [WRITE_DATA_WIDTH_B-1:0] dinb_i;
  wire enb_o_pipe_ctrl;
  wire regceb_i;
  if(`MEM_AUTO_SLP_EN && (`MEM_PORTB_WRITE || `MEM_PORTB_READ)) begin : gen_auto_slp_dly_b
    reg [P_WIDTH_ADDR_WRITE_B-1:0] addrb_aslp_pipe [AUTO_SLEEP_TIME-1:0];
    wire clkb_int;

    // In true dual port UltraRAM configurations, use the port A clock delayed by a small amount to model the port B
    // synchronous processes; although both ports share a common clock, port B operations occur after port A operations
    if (`COMMON_CLOCK && `MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin : gen_uram_tdp_common_clock
      assign clkb_int = clka;
    end : gen_uram_tdp_common_clock

    // In all other common clocking configurations, use the port A clock for port B synchronous processes
    else if (`COMMON_CLOCK) begin : gen_common_clock
      assign clkb_int = clka;
    end : gen_common_clock

    // In independent clocking configurations, use the port B clock for port B synchronous processes
    else if (`INDEPENDENT_CLOCKS) begin : gen_independent_clocks
      assign clkb_int = clkb;
    end : gen_independent_clocks

    // Check if write operation is allowed on Port-B, if yes then
    // generate the pipeline register stages on write enable and input data
    if(`MEM_PORTB_WRITE) begin : gen_aslp_wr_b
      reg [(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B)-1:0] web_aslp_pipe [AUTO_SLEEP_TIME-1:0];
      reg [WRITE_DATA_WIDTH_B-1:0] dinb_aslp_pipe [AUTO_SLEEP_TIME-1:0];
     // Initialize the web and dinb pipelines
      initial begin
        integer aslp_initstage_b;
        for (aslp_initstage_b=0; aslp_initstage_b<AUTO_SLEEP_TIME; aslp_initstage_b=aslp_initstage_b+1) begin : for_wr_en_pipe_init
          web_aslp_pipe[aslp_initstage_b] = {(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B){1'b0}};
          dinb_aslp_pipe[aslp_initstage_b] = {WRITE_DATA_WIDTH_B{1'b0}};
        end : for_wr_en_pipe_init
      end
     // Connect the user inputs to the pipeline
      always @(posedge clkb_int) begin
        web_aslp_pipe[0]    <= web;
        dinb_aslp_pipe[0]   <= dinb;
      end
      for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
        always @(posedge clkb_int) begin
          web_aslp_pipe[aslp_stage]   <= web_aslp_pipe[aslp_stage-1];
          dinb_aslp_pipe[aslp_stage]  <= dinb_aslp_pipe[aslp_stage-1];
        end
      end : gen_aslp_inp_pipe
    // Assign the last stage register outputs to appropriate internal signals
        assign web_i  = web_aslp_pipe[AUTO_SLEEP_TIME-1];
        assign dinb_i = dinb_aslp_pipe[AUTO_SLEEP_TIME-1];
    end : gen_aslp_wr_b
    // If write operation is not allowed, then connect the write control signals
    // to zero
    else begin : gnd_wr_b_ctrls
      assign web_i  = {(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B){1'b0}};
      assign dinb_i = {(WRITE_DATA_WIDTH_B){1'b0}};
    end : gnd_wr_b_ctrls
    if(`MEM_PORTB_WRITE || `MEM_PORTB_READ) begin : gen_aslp_addr_b
      // Generate the pipeline register stages on addrb
      // Initialize the addrb pipelines
      initial begin
        integer aslp_initstage_b;
        for (aslp_initstage_b=0; aslp_initstage_b<AUTO_SLEEP_TIME; aslp_initstage_b=aslp_initstage_b+1) begin : for_addr_pipe_init
          addrb_aslp_pipe[aslp_initstage_b] = {P_WIDTH_ADDR_WRITE_B{1'b0}};
        end : for_addr_pipe_init
      end
      // Connect the user inputs to the pipeline
      always @(posedge clkb_int)
        begin
          addrb_aslp_pipe[0]  <= addrb;
        end
      for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
        always @(posedge clkb_int) begin
          addrb_aslp_pipe[aslp_stage] <= addrb_aslp_pipe[aslp_stage-1];
        end
      end : gen_aslp_inp_pipe
      // Assign the last stage register outputs to internal address
      assign addrb_i = addrb_aslp_pipe[AUTO_SLEEP_TIME-1];
    end : gen_aslp_addr_b
    else begin : gnd_addr_dly
    // If write operation is not allowed, then connect the internal address to zero
      assign addrb_i = {P_WIDTH_ADDR_WRITE_B{1'b0}};
    end : gnd_addr_dly
    // Check if read operation is not allowed, then connect the write control signals
   // to zero
    if(`MEM_PORTB_READ) begin : gen_aslp_rd_b
      if(READ_LATENCY_B >= 2) begin : gen_aslp_dly_regce
        reg regceb_aslp_pipe [AUTO_SLEEP_TIME-1:0];
        // Initialize the regceb pipelines
        initial begin
          integer aslp_initstage_b;
          for (aslp_initstage_b=0; aslp_initstage_b<AUTO_SLEEP_TIME; aslp_initstage_b=aslp_initstage_b+1) begin : for_regce_pipe_init
            regceb_aslp_pipe[aslp_initstage_b] = 1'b0;
          end : for_regce_pipe_init
        end
        // Connect the user inputs to the pipeline
        always @(posedge clkb_int) begin
          regceb_aslp_pipe[0] <= regceb;
        end
        for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
          always @(posedge clkb_int) begin
            regceb_aslp_pipe[aslp_stage]  <= regceb_aslp_pipe[aslp_stage-1];
          end
        end : gen_aslp_inp_pipe
      // Assign the last stage register outputs to internal regce 
        assign  regceb_i = regceb_aslp_pipe[AUTO_SLEEP_TIME-1];
      end : gen_aslp_dly_regce
      else begin : gnd_regce_ctrl
      // If there is no output pipeline, then connect regce to zero
        assign regceb_i = 0;
      end : gnd_regce_ctrl
      if(READ_LATENCY_B > 2) begin : gen_aslp_dly_out_pipe
        reg enb_aslp_pipe [AUTO_SLEEP_TIME-1:0];
        // Initialize the enb pipelines
        initial begin
          integer aslp_initstage_b;
          for (aslp_initstage_b=0; aslp_initstage_b<AUTO_SLEEP_TIME; aslp_initstage_b=aslp_initstage_b+1) begin : for_en_pipe_init
            enb_aslp_pipe[aslp_initstage_b] = 1'b0;
          end : for_en_pipe_init
        end
        // Connect the user inputs to the pipeline
        always @(posedge clkb_int) begin
          enb_aslp_pipe[0]    <= enb;
        end
        for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
          always @(posedge clkb_int) begin
            enb_aslp_pipe[aslp_stage]   <= enb_aslp_pipe[aslp_stage-1];
          end
        end : gen_aslp_inp_pipe
      // Assign the last stage register outputs to internal enable that controls
      // the output pipeline
        assign  enb_o_pipe_ctrl  = enb_aslp_pipe[AUTO_SLEEP_TIME-1];
      end : gen_aslp_dly_out_pipe
      else begin : gnd_pipe_en_ctrl
      // If there is no output pipeline, then connect enable to zero
        assign enb_o_pipe_ctrl = 1'b0;
      end : gnd_pipe_en_ctrl
    end : gen_aslp_rd_b
  end : gen_auto_slp_dly_b
  else begin : gen_nauto_slp_dly_b
    // connect all the internal control signals to the ports when auto sleep is
    // not enabled
    assign web_i  = web;
    assign dinb_i = dinb;
    assign addrb_i = addrb;
    assign enb_o_pipe_ctrl = enb;
    assign regceb_i = regceb;
  end : gen_nauto_slp_dly_b
  // Enable needs to reach URAM early compared to other inputs in Auto Sleep
  // Mode, so no pipe line stages on enable irrespective auto sleep mode
  // enabled/disabled
  assign enb_i    = enb;

  // If the memory type is true dual port RAM, generate a port B write process
  if (`MEM_PORTB_WRITE && !`DISABLE_SYNTH_TEMPL) begin : gen_wr_b
    wire clkb_int;
    wire [P_WIDTH_ADDR_WRITE_B-1:0] addrb_int = addrb_i;

    // In true dual port UltraRAM configurations, use the port A clock delayed by a small amount to model the port B
    // synchronous processes; although both ports share a common clock, port B operations occur after port A operations
    if (`COMMON_CLOCK && `MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin : gen_uram_tdp_common_clock
      assign clkb_int = clka;
    end : gen_uram_tdp_common_clock

    // In all other common clocking configurations, use the port A clock for port B synchronous processes
    else if (`COMMON_CLOCK) begin : gen_common_clock
      assign clkb_int = clka;
    end : gen_common_clock

    // In independent clocking configurations, use the port B clock for port B synchronous processes
    else if (`INDEPENDENT_CLOCKS) begin : gen_independent_clocks
      assign clkb_int = clkb;
    end : gen_independent_clocks

    // Synchronous port B write; word-wide write; port width is the narrowest of the data ports
    if (`MEM_PORTB_WR_WORD && `MEM_PORTB_WR_NARROW && `WRITE_PROT_ENABLED) begin : gen_word_narrow
      always @(posedge clkb_int) begin
        if (enb_i) begin
          if (web_i)
            mem[addrb_int] <= dinb_i;
        end
      end
    end : gen_word_narrow
    else if (`MEM_PORTB_WR_WORD && `MEM_PORTB_WR_NARROW && `WRITE_PROT_DISABLED) begin : gen_word_narrow_wp
      always @(posedge clkb_int) begin
          if (web_i)
            mem[addrb_int] <= dinb_i;
      end
    end : gen_word_narrow_wp

    // Synchronous port B write; word-wide write; port width is wider than at least one other data port;
    // not generated in port B write-first read with wide data width special case
    else if (`MEM_PORTB_WR_WORD && `MEM_PORTB_WR_WIDE &&
           !(`MEM_TYPE_RAM_TDP && `MEM_PORTB_WF && `MEM_PORTB_RD_WIDE) && `WRITE_PROT_ENABLED) begin : gen_word_wide
      always @(posedge clkb_int) begin : wr_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_WRITE_B-1:0] addrblsb;
        for (row=0; row<P_NUM_ROWS_WRITE_B; row=row+1) begin : for_mem_rows
          addrblsb = row;
          if (enb_i) begin
            if (web_i)
              mem[{addrb_int, addrblsb}] <= dinb_i[`ONE_ROW_OF_DIN];
          end
        end : for_mem_rows
      end : wr_sync
    end : gen_word_wide
    else if (`MEM_PORTB_WR_WORD && `MEM_PORTB_WR_WIDE &&
           !(`MEM_TYPE_RAM_TDP && `MEM_PORTB_WF && `MEM_PORTB_RD_WIDE) && `WRITE_PROT_DISABLED) begin : gen_word_wide_wp
      always @(posedge clkb_int) begin : wr_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_WRITE_B-1:0] addrblsb;
        for (row=0; row<P_NUM_ROWS_WRITE_B; row=row+1) begin : for_mem_rows
          addrblsb = row;
            if (web_i)
              mem[{addrb_int, addrblsb}] <= dinb_i[`ONE_ROW_OF_DIN];
        end : for_mem_rows
      end : wr_sync
    end : gen_word_wide_wp
    
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_REG && `WRITE_PROT_ENABLED) begin : gen_wf_wide_reg
      always @(posedge clkb_int) begin : wr_rd_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
        for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
          addrblsb = row;
            if (enb_i) begin
              if (web_i)
                mem[{addrb_int, addrblsb}] <= dinb_i[`ONE_ROW_OF_DIN];
            end
        end : for_mem_rows
      end : wr_rd_sync
    end : gen_wf_wide_reg
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_REG && `WRITE_PROT_DISABLED) begin : gen_wf_wide_reg_wp
      always @(posedge clkb_int) begin : wr_rd_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
        for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
          addrblsb = row;
              if (web_i)
                mem[{addrb_int, addrblsb}] <= dinb_i[`ONE_ROW_OF_DIN];
        end : for_mem_rows
      end : wr_rd_sync
    end : gen_wf_wide_reg_wp

    // Synchronous port B write; byte-wide write; port width is the narrowest of the data ports
    else if (`MEM_PORTB_WR_BYTE && `MEM_PORTB_WR_NARROW && `WRITE_PROT_ENABLED) begin : gen_byte_narrow
      for (genvar col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin : for_mem_cols
        always @(posedge clkb_int) begin : wr_sync
          if (enb_i) begin
            if (web_i[col])
              mem[addrb_int][`ONE_COL_OF_DINB] <= dinb_i[`ONE_COL_OF_DINB];
          end
        end : wr_sync
      end : for_mem_cols
    end : gen_byte_narrow
    else if (`MEM_PORTB_WR_BYTE && `MEM_PORTB_WR_NARROW && `WRITE_PROT_DISABLED) begin : gen_byte_narrow_wp
      for (genvar col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin : for_mem_cols
        always @(posedge clkb_int) begin : wr_sync
            if (web_i[col])
              mem[addrb_int][`ONE_COL_OF_DINB] <= dinb_i[`ONE_COL_OF_DINB];
        end : wr_sync
      end : for_mem_cols
    end : gen_byte_narrow_wp
  // Error Injection in ECC modes ("Both encode and Decode" mode and "Encode_only" modes)
  // Append required synthesis attributes
    if(`BOTH_ENC_DEC || `ENC_ONLY) begin : err_inj_ecc
      (* keep = "yes", xpm_ecc_inject_sbiterr = "yes" *) reg injectsbiterrb_i;
      (* keep = "yes", xpm_ecc_inject_dbiterr = "yes" *) reg injectdbiterrb_i;

      // Declare injecterr inputs to synth ANDed with LSB data
      (* keep = "yes" *) wire inj_sbiterrb_to_synth;
      (* keep = "yes" *) wire inj_dbiterrb_to_synth;
      if(`MEM_AUTO_SLP_EN) begin : gen_aslp_dly_inj_err
        // Auto Sleep pipe line delays on the error inject signals      
        reg injsbiterrb_aslp_pipe    [AUTO_SLEEP_TIME-1:0];
        reg injdbiterrb_aslp_pipe    [AUTO_SLEEP_TIME-1:0];

        // Initialize the error injection pipelines
        initial begin
          integer aslp_initstage_b;
          for (aslp_initstage_b=0; aslp_initstage_b<AUTO_SLEEP_TIME; aslp_initstage_b=aslp_initstage_b+1) begin : for_injerr_pipe_init
            injsbiterrb_aslp_pipe[aslp_initstage_b] = 1'b0;
            injdbiterrb_aslp_pipe[aslp_initstage_b] = 1'b0;
          end : for_injerr_pipe_init
        end
       // Connect the user inputs to the pipeline
        always @(posedge clkb_int) begin
          injsbiterrb_aslp_pipe[0]  <= injectsbiterrb;
          injdbiterrb_aslp_pipe[0]  <= injectdbiterrb;
        end
        for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
          always @(posedge clkb_int) begin
            injsbiterrb_aslp_pipe[aslp_stage]  <= injsbiterrb_aslp_pipe[aslp_stage-1];
            injdbiterrb_aslp_pipe[aslp_stage]  <= injdbiterrb_aslp_pipe[aslp_stage-1];
          end
        end : gen_aslp_inp_pipe
        assign  injectsbiterrb_i  = injsbiterrb_aslp_pipe[AUTO_SLEEP_TIME-1];
        assign  injectdbiterrb_i  = injdbiterrb_aslp_pipe[AUTO_SLEEP_TIME-1];
      end : gen_aslp_dly_inj_err
      else begin : gen_naslp_dly_inj_err
        assign injectsbiterrb_i = injectsbiterrb;
        assign injectdbiterrb_i = injectdbiterrb;
      end : gen_naslp_dly_inj_err
      //Assignment to error Injection signals passed to synthesis
      assign inj_sbiterrb_to_synth = injectsbiterrb_i & dinb_i[0];
      assign inj_dbiterrb_to_synth = injectdbiterrb_i & dinb_i[0];
    end : err_inj_ecc
  end : gen_wr_b

  // -------------------------------------------------------------------------------------------------------------------
  // Black Box Instantiation
  // -------------------------------------------------------------------------------------------------------------------
  if(`DISABLE_SYNTH_TEMPL) begin : gen_blk_box
    // Delayed ports(with auto sleep latency) are not connected to this module, as this module is used
    // for asymmetry and URAM does not support asymmetry
    if(`COMMON_CLOCK) begin : gen_bb_sync
      asym_bwe_bb # (
        // Common module parameters
        .MEMORY_TYPE        (MEMORY_TYPE       ),
        .MEMORY_SIZE        (MEMORY_SIZE       ),
        .MEMORY_PRIMITIVE   (MEMORY_PRIMITIVE  ),
        .CLOCKING_MODE      (0                 ), // Common Clock
        .MEMORY_INIT_FILE   (MEMORY_INIT_FILE  ),
        .MEMORY_INIT_PARAM  (MEMORY_INIT_PARAM ),
        .WAKEUP_TIME        (WAKEUP_TIME       ),
        .AUTO_SLEEP_TIME    (AUTO_SLEEP_TIME   ),

        // Port A module parameters
        .WRITE_DATA_WIDTH_A (WRITE_DATA_WIDTH_A),
        .READ_DATA_WIDTH_A  (READ_DATA_WIDTH_A ),
        .BYTE_WRITE_WIDTH_A (BYTE_WRITE_WIDTH_A),
        .ADDR_WIDTH_A       (ADDR_WIDTH_A      ),
        .READ_RESET_VALUE_A (READ_RESET_VALUE_A),
        .READ_LATENCY_A     (READ_LATENCY_A    ),
        .WRITE_MODE_A       (WRITE_MODE_A      ),
        .RST_MODE_A         (RST_MODE_A        ),

        // Port B module parameters
        .WRITE_DATA_WIDTH_B (WRITE_DATA_WIDTH_B),
        .READ_DATA_WIDTH_B  (READ_DATA_WIDTH_B ),
        .BYTE_WRITE_WIDTH_B (BYTE_WRITE_WIDTH_B),
        .ADDR_WIDTH_B       (ADDR_WIDTH_B      ),
        .READ_RESET_VALUE_B (READ_RESET_VALUE_B),
        .READ_LATENCY_B     (READ_LATENCY_B    ),
        .WRITE_MODE_B       (WRITE_MODE_B      ),
        .RST_MODE_B         (RST_MODE_B        )
      ) xpm_memory_base_inst (

        // Common module ports
        .sleep          (sleep                 ),

        // Port A module ports
        .clka           (clka                  ),
        .rsta           (rsta                  ),
        .ena            (ena                   ),
        .regcea         (regcea                ),
        .wea            (wea                   ),
        .addra          (addra                 ),
        .dina           (dina                  ),
        .douta          (douta_bb              ),

        // Port B module ports
        .clkb           (clka                  ),
        .rstb           (rstb                  ),
        .enb            (enb                   ),
        .regceb         (regceb                ),
        .web            (web                   ),
        .addrb          (addrb                 ),
        .dinb           (dinb                  ),
        .doutb          (doutb_bb              )
      );
      end : gen_bb_sync
      else begin : gen_bb_async
        asym_bwe_bb # (
          // Common module parameters
          .MEMORY_TYPE        (MEMORY_TYPE       ),
          .MEMORY_SIZE        (MEMORY_SIZE       ),
          .MEMORY_PRIMITIVE   (MEMORY_PRIMITIVE  ),
          .CLOCKING_MODE      (1                 ), // Independent Clock
          .MEMORY_INIT_FILE   (MEMORY_INIT_FILE  ),
          .MEMORY_INIT_PARAM  (MEMORY_INIT_PARAM ),
          .WAKEUP_TIME        (WAKEUP_TIME       ),
          .AUTO_SLEEP_TIME    (AUTO_SLEEP_TIME   ),

          // Port A module parameters
          .WRITE_DATA_WIDTH_A (WRITE_DATA_WIDTH_A),
          .READ_DATA_WIDTH_A  (READ_DATA_WIDTH_A ),
          .BYTE_WRITE_WIDTH_A (BYTE_WRITE_WIDTH_A),
          .ADDR_WIDTH_A       (ADDR_WIDTH_A      ),
          .READ_RESET_VALUE_A (READ_RESET_VALUE_A),
          .READ_LATENCY_A     (READ_LATENCY_A    ),
          .WRITE_MODE_A       (WRITE_MODE_A      ),

          // Port B module parameters
          .WRITE_DATA_WIDTH_B (WRITE_DATA_WIDTH_B),
          .READ_DATA_WIDTH_B  (READ_DATA_WIDTH_B ),
          .BYTE_WRITE_WIDTH_B (BYTE_WRITE_WIDTH_B),
          .ADDR_WIDTH_B       (ADDR_WIDTH_B      ),
          .READ_RESET_VALUE_B (READ_RESET_VALUE_B),
          .READ_LATENCY_B     (READ_LATENCY_B    ),
          .WRITE_MODE_B       (WRITE_MODE_B      )
        ) xpm_memory_base_inst (

          // Common module ports
          .sleep          (sleep                 ),

          // Port A module ports
          .clka           (clka                  ),
          .rsta           (rsta                  ),
          .ena            (ena                   ),
          .regcea         (regcea                ),
          .wea            (wea                   ),
          .addra          (addra                 ),
          .dina           (dina                  ),
          .douta          (douta_bb              ),

          // Port B module ports
          .clkb           (clkb                  ),
          .rstb           (rstb                  ),
          .enb            (enb                   ),
          .regceb         (regceb                ),
          .web            (web                   ),
          .addrb          (addrb                 ),
          .dinb           (dinb                  ),
          .doutb          (doutb_bb              )
        );
      end : gen_bb_async
  end : gen_blk_box

  // -------------------------------------------------------------------------------------------------------------------
  // Port A read
  // -------------------------------------------------------------------------------------------------------------------

  // If the memory type is single port RAM, true dual port RAM, or any ROM, generate a port A read process
  if (`MEM_PORTA_READ) begin : gen_rd_a
    localparam READ_DATA_WIDTH_A_ECC = `NO_ECC ? READ_DATA_WIDTH_A : P_MIN_WIDTH_DATA_ECC;
    wire [P_WIDTH_ADDR_READ_A-1:0] addra_int = addra_i;
    reg [READ_DATA_WIDTH_A_ECC-1:0] douta_reg;
    localparam logic [READ_DATA_WIDTH_A_ECC-1:0] rsta_val = `ASYNC_RESET_A ? {READ_DATA_WIDTH_A_ECC{1'b0}} : rst_val_conv_a(READ_RESET_VALUE_A);
    reg sbiterra_i = 1'b0 ;
    reg dbiterra_i = 1'b0 ;

    initial begin
      if (`MEM_PORTA_RD_REG) begin : init_rstval
        douta_reg = rsta_val;
      end : init_rstval
      else if (`MEM_PORTA_RD_PIPE && `MEM_PORTA_NC) begin : init_rstval_NC
        douta_reg = rsta_val;
      end : init_rstval_NC
      else if (`MEM_PORTA_RD_PIPE && (`MEM_PORTA_WF || `MEM_PORTA_RF)) begin : init_zero
        douta_reg = {READ_DATA_WIDTH_A_ECC{1'b0}};
      end : init_zero
    end
    if (!`DISABLE_SYNTH_TEMPL) begin : gen_rd_a_synth_template
      // Asynchronous port A read; port width is the narrowest of the data ports; no output pipeline
      if (`MEM_PORTA_RD_NARROW && `MEM_PORTA_RD_COMB) begin : gen_narrow_comb
        always @(*) begin
          douta_reg = mem[addra_int];
        end
      end : gen_narrow_comb

      // Asynchronous port A read; port width is wider than at least one other data port; no output pipeline
      else if (`MEM_PORTA_RD_WIDE && `MEM_PORTA_RD_COMB) begin : gen_wide_comb
        always @(*) begin : rd_comb
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
          for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
            addralsb = row;
            douta_reg[`ONE_ROW_OF_DIN] = mem[{addra_int, addralsb}];
          end : for_mem_rows
        end : rd_comb
      end : gen_wide_comb

      // Synchronous port A write-first read; port width is the narrowest of the data ports; no output pipeline
      else if (`MEM_PORTA_WF && `MEM_PORTA_RD_NARROW && `MEM_PORTA_RD_REG && `MEM_PORTA_WR_WORD) begin : gen_wf_narrow_reg
        if(`ASYNC_RESET_A) begin
          always @(posedge rsta or posedge clka) begin
            if (rsta)
              douta_reg <= rsta_val;
            else begin
              if (ena_i) begin
                if (wea_i)
                  douta_reg <= dina_i;
                else
                  douta_reg <= mem[addra_int];
              end
            end
          end
        end
        else begin
          always @(posedge clka) begin
            if (rsta)
              douta_reg <= rsta_val;
            else begin
              if (ena_i) begin
                if (wea_i)
                  douta_reg <= dina_i;
                else
                  douta_reg <= mem[addra_int];
              end
            end
          end
        end
      end : gen_wf_narrow_reg

      // Synchronous port A write-first read; port width is the narrowest of the data ports; no output pipeline;
      // symmetric byte-wide write special case
      else if (`MEM_PORTA_WF && `MEM_PORTA_RD_NARROW && `MEM_PORTA_RD_REG &&
               `MEM_PORTA_WR_NARROW && `MEM_PORTA_WR_BYTE) begin : gen_wf_narrow_reg_sym_byte
        for (genvar col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin : for_mem_cols
          if(`ASYNC_RESET_A) begin
            always @(posedge rsta or posedge clka) begin : wr_sync
              if (rsta)
                douta_reg[`ONE_COL_OF_DINA] <= rsta_val[`ONE_COL_OF_DINA];
              else begin
                if (ena_i) begin
                  if (wea_i[col])
                    douta_reg[`ONE_COL_OF_DINA] <= dina_i[`ONE_COL_OF_DINA];
                  else
                    douta_reg[`ONE_COL_OF_DINA] <= mem[addra_int][`ONE_COL_OF_DINA];
                end
              end
            end : wr_sync
          end
          else begin 
            always @(posedge clka) begin : wr_sync
              if (rsta)
                douta_reg[`ONE_COL_OF_DINA] <= rsta_val[`ONE_COL_OF_DINA];
              else begin
                if (ena_i) begin
                  if (wea_i[col])
                    douta_reg[`ONE_COL_OF_DINA] <= dina_i[`ONE_COL_OF_DINA];
                  else
                    douta_reg[`ONE_COL_OF_DINA] <= mem[addra_int][`ONE_COL_OF_DINA];
                end
              end
            end : wr_sync
          end
        end : for_mem_cols
      end : gen_wf_narrow_reg_sym_byte

      // Synchronous port A write-first read; port width is the narrowest of the data ports; output pipeline
      else if (`MEM_PORTA_WF && `MEM_PORTA_RD_NARROW && `MEM_PORTA_RD_PIPE && `MEM_PORTA_WR_WORD) begin : gen_wf_narrow_pipe
        always @(posedge clka) begin
          if (ena_i) begin
            if (wea_i)
              douta_reg <= dina_i;
            else
              douta_reg <= mem[addra_int];
          end
        end
      end : gen_wf_narrow_pipe

      // Synchronous port A write-first read; port width is the narrowest of the data ports; output pipeline;
      // symmetric byte-wide write special case
      else if (`MEM_PORTA_WF && `MEM_PORTA_RD_NARROW && `MEM_PORTA_RD_PIPE &&
               `MEM_PORTA_WR_NARROW && `MEM_PORTA_WR_BYTE) begin : gen_wf_narrow_pipe_sym_byte
        for (genvar col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin : for_mem_cols
          always @(posedge clka) begin : wr_sync
            if (ena_i) begin
              if (wea_i[col])
                douta_reg[`ONE_COL_OF_DINA] <= dina_i[`ONE_COL_OF_DINA];
              else
                douta_reg[`ONE_COL_OF_DINA] <= mem[addra_int][`ONE_COL_OF_DINA];
            end
          end : wr_sync
        end : for_mem_cols
      end : gen_wf_narrow_pipe_sym_byte

      // Synchronous port A write-first read; port width is wider than at least one other data port; no output pipeline;
      // write and read combined special case
      else if (`MEM_PORTA_WF && `MEM_PORTA_RD_WIDE && `MEM_PORTA_RD_REG) begin : gen_wf_wide_reg
        if(`ASYNC_RESET_A) begin
          always @(posedge rsta or posedge clka) begin : wr_rd_sync
            integer row;
            reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
            for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
              addralsb = row;
              if (rsta)
                douta_reg[`ONE_ROW_OF_DIN] <= rsta_val[`ONE_ROW_OF_DIN];
              else begin
                if (ena_i) begin
                  if (wea_i)
                    douta_reg[`ONE_ROW_OF_DIN] <= dina_i[`ONE_ROW_OF_DIN];
                  else
                    douta_reg[`ONE_ROW_OF_DIN] <= mem[{addra_int, addralsb}];
                end
              end
            end : for_mem_rows
          end : wr_rd_sync
        end
        else begin 
          always @(posedge clka) begin : wr_rd_sync
            integer row;
            reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
            for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
              addralsb = row;
              if (rsta)
                douta_reg[`ONE_ROW_OF_DIN] <= rsta_val[`ONE_ROW_OF_DIN];
              else begin
                if (ena_i) begin
                  if (wea_i)
                    douta_reg[`ONE_ROW_OF_DIN] <= dina_i[`ONE_ROW_OF_DIN];
                  else
                    douta_reg[`ONE_ROW_OF_DIN] <= mem[{addra_int, addralsb}];
                end
              end
            end : for_mem_rows
          end : wr_rd_sync
        end
      end : gen_wf_wide_reg

      // Synchronous port A write-first read; port width is wider than at least one other data port; output pipeline;
      // write and read combined special case
      else if (`MEM_PORTA_WF && `MEM_PORTA_RD_WIDE && `MEM_PORTA_RD_PIPE) begin : gen_wf_wide_pipe
        always @(posedge clka) begin : wr_rd_sync
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
          for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
            addralsb = row;
            if (ena_i) begin
              if (wea_i)
                mem[{addra_int, addralsb}] = dina_i[`ONE_ROW_OF_DIN];
              douta_reg[`ONE_ROW_OF_DIN] <= mem[{addra_int, addralsb}];
            end
          end : for_mem_rows
        end : wr_rd_sync
      end : gen_wf_wide_pipe

      // Synchronous port A read-first read; port width is the narrowest of the data ports; no output pipeline
      else if (`MEM_PORTA_RF && `MEM_PORTA_RD_NARROW && `MEM_PORTA_RD_REG) begin : gen_rf_narrow_reg
        if(`ASYNC_RESET_A) begin
          always @(posedge rsta or posedge clka) begin
            if (rsta)
              douta_reg <= rsta_val;
            else begin
              if (ena_i)
                douta_reg <= mem[addra_int];
            end
          end
        end
        else begin
          always @(posedge clka) begin
            if (rsta)
              douta_reg <= rsta_val;
            else begin
              if (ena_i)
                douta_reg <= mem[addra_int];
            end
          end
        end
      end : gen_rf_narrow_reg

      // Synchronous port A read-first read; port width is the narrowest of the data ports; output pipeline
      else if (`MEM_PORTA_RF && `MEM_PORTA_RD_NARROW && `MEM_PORTA_RD_PIPE) begin : gen_rf_narrow_pipe
        always @(posedge clka) begin
          if (ena_i)
            douta_reg <= mem[addra_int];
        end
      end : gen_rf_narrow_pipe

      // Synchronous port A read-first read; port width is wider than at least one other data port; no output pipeline
      else if (`MEM_PORTA_RF && `MEM_PORTA_RD_WIDE && `MEM_PORTA_RD_REG) begin : gen_rf_wide_reg
        if(`ASYNC_RESET_A) begin
          always @(posedge rsta or posedge clka) begin : rd_sync
            integer row;
            reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
            for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
              addralsb = row;
              if (rsta)
                douta_reg[`ONE_ROW_OF_DIN] <= rsta_val[`ONE_ROW_OF_DIN];
              else begin
                if (ena_i)
                  douta_reg[`ONE_ROW_OF_DIN] <= mem[{addra_int, addralsb}];
              end
            end : for_mem_rows
          end : rd_sync
        end
        else begin
          always @(posedge clka) begin : rd_sync
            integer row;
            reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
            for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
              addralsb = row;
              if (rsta)
                douta_reg[`ONE_ROW_OF_DIN] <= rsta_val[`ONE_ROW_OF_DIN];
              else begin
                if (ena_i)
                  douta_reg[`ONE_ROW_OF_DIN] <= mem[{addra_int, addralsb}];
              end
            end : for_mem_rows
          end : rd_sync
        end
      end : gen_rf_wide_reg

      // Synchronous port A read-first read; port width is wider than at least one other data port; output pipeline
      else if (`MEM_PORTA_RF && `MEM_PORTA_RD_WIDE && `MEM_PORTA_RD_PIPE) begin : gen_rf_wide_pipe
        always @(posedge clka) begin : rd_sync
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
          for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
            addralsb = row;
            if (ena_i)
              douta_reg[`ONE_ROW_OF_DIN] <= mem[{addra_int, addralsb}];
          end : for_mem_rows
        end : rd_sync
      end : gen_rf_wide_pipe

      // Synchronous port A no-change read; port width is the narrowest of the data ports; no output pipeline
      else if (`MEM_PORTA_NC && `MEM_PORTA_RD_NARROW && `MEM_PORTA_RD_REG) begin : gen_nc_narrow_reg
        if(`ASYNC_RESET_A) begin
          always @(posedge rsta or posedge clka) begin
            if (rsta)
              douta_reg <= rsta_val;
            else begin
              if (ena_i) begin
                if (~|wea_i)
                  douta_reg <= mem[addra_int];
              end
            end
          end
        end
        else begin
          always @(posedge clka) begin
            if (rsta)
              douta_reg <= rsta_val;
            else begin
              if (ena_i) begin
                if (~|wea_i)
                  douta_reg <= mem[addra_int];
              end
            end
          end
        end
      end : gen_nc_narrow_reg

      // Synchronous port A no-change read; port width is the narrowest of the data ports; output pipeline
      else if (`MEM_PORTA_NC && `MEM_PORTA_RD_NARROW && `MEM_PORTA_RD_PIPE) begin : gen_nc_narrow_pipe
        always @(posedge clka) begin
          if (ena_i) begin
            if (~|wea_i)
              douta_reg <= mem[addra_int];
          end
        end
      end : gen_nc_narrow_pipe

      // Synchronous port A no-change read; port width is wider than at least one other data port; no output pipeline
      else if (`MEM_PORTA_NC && `MEM_PORTA_RD_WIDE && `MEM_PORTA_RD_REG) begin : gen_nc_wide_reg
        if(`ASYNC_RESET_A) begin
          always @(posedge rsta or posedge clka) begin : rd_sync
            integer row;
            reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
            for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
              addralsb = row;
              if (rsta)
                douta_reg[`ONE_ROW_OF_DIN] <= rsta_val[`ONE_ROW_OF_DIN];
              else begin
                if (ena_i) begin
                  if (~|wea_i)
                    douta_reg[`ONE_ROW_OF_DIN] <= mem[{addra_int, addralsb}];
                end
              end
            end : for_mem_rows
          end : rd_sync
        end
        else begin
          always @(posedge clka) begin : rd_sync
            integer row;
            reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
            for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
              addralsb = row;
              if (rsta)
                douta_reg[`ONE_ROW_OF_DIN] <= rsta_val[`ONE_ROW_OF_DIN];
              else begin
                if (ena_i) begin
                  if (~|wea_i)
                    douta_reg[`ONE_ROW_OF_DIN] <= mem[{addra_int, addralsb}];
                end
              end
            end : for_mem_rows
          end : rd_sync
        end
      end : gen_nc_wide_reg

      // Synchronous port A no-change read; port width is wider than at least one other data port; output pipeline
      else if (`MEM_PORTA_NC && `MEM_PORTA_RD_WIDE && `MEM_PORTA_RD_PIPE) begin : gen_nc_wide_pipe
        always @(posedge clka) begin : rd_sync
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb;
          for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin : for_mem_rows
            addralsb = row;
            if (ena_i) begin
              if (~|wea_i)
                douta_reg[`ONE_ROW_OF_DIN] <= mem[{addra_int, addralsb}];
            end
          end : for_mem_rows
        end : rd_sync
      end : gen_nc_wide_pipe
    end : gen_rd_a_synth_template
    else begin : gen_rd_a_synth_black_box
      always @(*) begin
        douta_reg = douta_bb;
      end
    end : gen_rd_a_synth_black_box

    // If no output pipeline is used, then the enabled read process directly drives the data output port
    if (`MEM_PORTA_RD_COMB || `MEM_PORTA_RD_REG) begin : gen_douta
      assign douta = douta_reg;
    end : gen_douta

    // If an output pipeline is used, generate it
    else if (`MEM_PORTA_RD_PIPE) begin : gen_douta_pipe
      reg                         ena_pipe   [READ_LATENCY_A-2:0];
      reg [READ_DATA_WIDTH_A_ECC-1:0] douta_pipe [READ_LATENCY_A-2:0];

      always @(posedge clka) begin
        ena_pipe[0] <= ena_o_pipe_ctrl;
      end

      // Initialize the final output pipeline stage to the specified reset value, and all prior stages to zero
      initial begin
        integer initstage;
        for (initstage=0; initstage<READ_LATENCY_A-1; initstage=initstage+1) begin : for_pipe_init
          if (initstage < READ_LATENCY_A-2 && (`MEM_PORTA_WF || `MEM_PORTA_RF)) begin : init_zero
            douta_pipe[initstage] = {READ_DATA_WIDTH_A{1'b0}};
          end : init_zero
          else if (initstage < READ_LATENCY_A-2 && `MEM_PORTA_NC) begin : init_rstval_NC
            douta_pipe[initstage] = rsta_val;
          end : init_rstval_NC
          else begin : init_rstval
            douta_pipe[initstage] = rsta_val;
          end : init_rstval
        end : for_pipe_init
      end

      // If two stages are used, the synchronous read output drives the final pipeline stage
      if (READ_LATENCY_A == 2) begin : gen_stage
        if(`ASYNC_RESET_A) begin
          always @(posedge rsta or posedge clka) begin
            if (rsta)
              douta_pipe[0] <= rsta_val;
            else begin
              if (regcea_i)
                douta_pipe[0] <= douta_reg;
            end
          end
        end
        else begin
          always @(posedge clka) begin
            if (rsta)
              douta_pipe[0] <= rsta_val;
            else begin
              if (regcea_i)
                douta_pipe[0] <= douta_reg;
            end
          end
        end
      end : gen_stage

      // If more than two stages are used, loops generate all pipeline stages except the first and last
      else if (READ_LATENCY_A > 2) begin : gen_stages
        always @(posedge clka) begin
          if (ena_pipe[0])
            douta_pipe[0] <= douta_reg;
        end

        for (genvar estage=1; estage<READ_LATENCY_A-1; estage=estage+1) begin : gen_epipe
          always @(posedge clka) begin
            ena_pipe[estage] <= ena_pipe[estage-1];
          end
        end : gen_epipe

        for (genvar dstage=1; dstage<READ_LATENCY_A-2; dstage=dstage+1) begin : gen_dpipe
          always @(posedge clka) begin
            if (ena_pipe[dstage])
              douta_pipe[dstage] <= douta_pipe[dstage-1];
          end
        end : gen_dpipe

        if(`ASYNC_RESET_A) begin
          always @(posedge rsta or posedge clka) begin
            if (rsta)
              douta_pipe[READ_LATENCY_A-2] <= rsta_val;
            else begin
              if (regcea_i)
                douta_pipe[READ_LATENCY_A-2] <= douta_pipe[READ_LATENCY_A-3];
            end
          end
        end
        else begin
          always @(posedge clka) begin
            if (rsta)
              douta_pipe[READ_LATENCY_A-2] <= rsta_val;
            else begin
              if (regcea_i)
                douta_pipe[READ_LATENCY_A-2] <= douta_pipe[READ_LATENCY_A-3];
            end
          end
        end
      end : gen_stages

      // The final pipeline stage drives the data output port
      assign douta = douta_pipe[READ_LATENCY_A-2];
    end : gen_douta_pipe
    if(ECC_MODE == 2 || ECC_MODE == 3) begin : pipeline_ecc_status
      // Error status signals (should be pipelined along with the data)
      if (`MEM_PORTA_READ && (`MEM_PRIM_ULTRA || `MEM_PRIM_AUTO)) begin : status_out_proc_a
        // ECC status signal declarations
        (* keep = "yes", xpm_ecc_sbiterr = "yes"*)  wire sbiterra_ram;
        (* keep = "yes", xpm_ecc_dbiterr = "yes"*)  wire dbiterra_ram;
        reg sbiterra_in_pipe;
        reg dbiterra_in_pipe;
        
        // WRITE_FIRST Mode
        if (`MEM_PORTA_WF && `MEM_PORTA_RD_REG) begin : ecc_status_wf_reg
          always @(posedge clka) begin
            if(rsta) begin
              sbiterra_in_pipe <= 1'b0;
              dbiterra_in_pipe <= 1'b0;
            end
            else if (ena_i) begin
                sbiterra_in_pipe <= sbiterra_ram;
                dbiterra_in_pipe <= dbiterra_ram;
            end
          end
        end : ecc_status_wf_reg

        if (`MEM_PORTA_WF && `MEM_PORTA_RD_PIPE) begin : ecc_status_wf_pipe
          always @(posedge clka) begin
            if (ena_i) begin
                sbiterra_in_pipe <= sbiterra_ram;
                dbiterra_in_pipe <= dbiterra_ram;
            end
          end
        end : ecc_status_wf_pipe

        // READ_FIRST Mode
        if (`MEM_PORTA_RF && `MEM_PORTA_RD_REG) begin : ecc_status_rf_reg
          always @(posedge clka) begin
            if(rsta) begin
              sbiterra_in_pipe <= 1'b0;
              dbiterra_in_pipe <= 1'b0;
            end
            else if (ena_i) begin
              sbiterra_in_pipe <= sbiterra_ram;
              dbiterra_in_pipe <= dbiterra_ram;
            end
          end
        end : ecc_status_rf_reg

        if (`MEM_PORTA_RF && `MEM_PORTA_RD_PIPE) begin : ecc_status_rf_pipe
          always @(posedge clka) begin
            if (ena_i) begin
              sbiterra_in_pipe <= sbiterra_ram;
              dbiterra_in_pipe <= dbiterra_ram;
            end
          end
        end : ecc_status_rf_pipe

        // NO_CHANGE Mode
        if (`MEM_PORTA_NC && `MEM_PORTA_RD_REG) begin : ecc_status_nc_reg
          always @(posedge clka) begin
            if(rsta) begin
              sbiterra_in_pipe <= 1'b0;
              dbiterra_in_pipe <= 1'b0;
            end
            else if (ena_i) begin
              if(~(|wea_i)) begin
                sbiterra_in_pipe <= sbiterra_ram;
                dbiterra_in_pipe <= dbiterra_ram;
              end
            end
          end
        end : ecc_status_nc_reg

        if (`MEM_PORTA_NC && `MEM_PORTA_RD_PIPE) begin : ecc_status_nc_pipe
          always @(posedge clka) begin
            if (ena_i) begin
              if(~(|wea_i)) begin
                sbiterra_in_pipe <= sbiterra_ram;
                dbiterra_in_pipe <= dbiterra_ram;
              end
            end
          end
        end : ecc_status_nc_pipe
 
        if (READ_LATENCY_A >= 2) begin : ecc_status_a_pipe
          reg sbiterra_pipe   [READ_LATENCY_A-2:0];    
          reg dbiterra_pipe   [READ_LATENCY_A-2:0];    
          if (READ_LATENCY_A == 2) begin : RL_2_dly_err_status
            always @(posedge clka) begin
              if(rsta) begin
                sbiterra_i <= 1'b0;
                dbiterra_i <= 1'b0;
              end
              else if (regcea_i) begin
                sbiterra_i <= sbiterra_in_pipe;
                dbiterra_i <= dbiterra_in_pipe;
              end
            end
          end : RL_2_dly_err_status

          if (READ_LATENCY_A > 2) begin : RL_gr_2_dly_err_status
            reg ena_ecc_pipe   [READ_LATENCY_A-2:0];
            always @(posedge clka) begin
              ena_ecc_pipe[0] <= ena_o_pipe_ctrl;
            end
        
            for (genvar ecc_estage_a=1; ecc_estage_a<READ_LATENCY_A-1; ecc_estage_a=ecc_estage_a+1) begin : gen_epipe
              always @(posedge clka) begin
                ena_ecc_pipe[ecc_estage_a] <= ena_ecc_pipe[ecc_estage_a-1];
              end
            end : gen_epipe

            always @(posedge clka) begin
              if(ena_ecc_pipe[0]) begin
                sbiterra_pipe[0] <= sbiterra_in_pipe;
                dbiterra_pipe[0] <= dbiterra_in_pipe;
              end
            end
            for (genvar ecc_errstage_a=1; ecc_errstage_a<READ_LATENCY_A-2; ecc_errstage_a=ecc_errstage_a+1) begin : porta_gen_ecc_epipe
              always @(posedge clka) begin
                if (ena_ecc_pipe[ecc_errstage_a]) begin
                  sbiterra_pipe[ecc_errstage_a]   <= sbiterra_pipe[ecc_errstage_a-1];
                  dbiterra_pipe[ecc_errstage_a]   <= dbiterra_pipe[ecc_errstage_a-1];
                end
              end
            end : porta_gen_ecc_epipe
            always @(posedge clka) begin
              if(rsta) begin
                sbiterra_i <= 1'b0;
                dbiterra_i <= 1'b0;
              end
              else if (regcea_i) begin
                sbiterra_i <= sbiterra_pipe[READ_LATENCY_A-3];
                dbiterra_i <= dbiterra_pipe[READ_LATENCY_A-3];
              end
            end
          end : RL_gr_2_dly_err_status
        end : ecc_status_a_pipe
        else begin :ecc_status_a_reg
          always @(*) begin
            sbiterra_i = sbiterra_in_pipe;
            dbiterra_i = dbiterra_in_pipe;
          end
        end : ecc_status_a_reg
      end : status_out_proc_a
    end : pipeline_ecc_status
    else begin : no_ecc_err_status
//      always_comb begin
//        sbiterra_i = 0;
//        dbiterra_i = 0;
//      end
    end : no_ecc_err_status
    // Assign Output signals
    assign sbiterra = sbiterra_i;
    assign dbiterra = dbiterra_i;
  end : gen_rd_a

  // If a port A read process is not generated, drive the data output port to a constant zero
  else begin : gen_no_rd_a
    assign douta = {READ_DATA_WIDTH_A{1'b0}};
    assign sbiterra = 1'b0;
    assign dbiterra = 1'b0;
  end : gen_no_rd_a

  // -------------------------------------------------------------------------------------------------------------------
  // Port B read
  // -------------------------------------------------------------------------------------------------------------------

  // If the memory type is simple dual port RAM, true dual port RAM, or dual port ROM, generate a port B read process
  if (`MEM_PORTB_READ) begin : gen_rd_b
    wire clkb_int;

    // In true dual port UltraRAM configurations, use the port A clock delayed by a small amount to model the port B
    // synchronous processes; although both ports share a common clock, port B operations occur after port A operations
    if (`COMMON_CLOCK && `MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin : gen_uram_tdp_common_clock
      assign clkb_int = clka;
    end : gen_uram_tdp_common_clock

    // In all other common clocking configurations, use the port A clock for port B synchronous processes
    else if (`COMMON_CLOCK) begin : gen_common_clock
      assign clkb_int = clka;
    end : gen_common_clock

    // In independent clocking configurations, use the port B clock for port B synchronous processes
    else if (`INDEPENDENT_CLOCKS) begin : gen_independent_clocks
      assign clkb_int = clkb;
    end : gen_independent_clocks

    localparam READ_DATA_WIDTH_B_ECC = `NO_ECC ? READ_DATA_WIDTH_B : P_MIN_WIDTH_DATA_ECC;
    wire [P_WIDTH_ADDR_READ_B-1:0] addrb_int = addrb_i;
    localparam EMB_XDC = USE_EMBEDDED_CONSTRAINT ? "yes" : "no";
    (* dram_emb_xdc = EMB_XDC *) reg [READ_DATA_WIDTH_B_ECC-1:0] doutb_reg;
    localparam logic [READ_DATA_WIDTH_B_ECC-1:0] rstb_val = `ASYNC_RESET_B ? {READ_DATA_WIDTH_B_ECC{1'b0}} : rst_val_conv_b(READ_RESET_VALUE_B);
    // ECC error status signals
    reg sbiterrb_i = 1'b0 ;
    reg dbiterrb_i = 1'b0 ;

    // Initialize doutb_reg to the specified reset value if it is the only output register, or to zero if an output
    // pipeline is used
    initial begin
      if (`MEM_PORTB_RD_REG) begin : init_rstval
        doutb_reg = rstb_val;
      end : init_rstval
      else if (`MEM_PORTB_RD_PIPE && `MEM_PORTB_NC) begin : init_rstval_NC
        doutb_reg = rstb_val;
      end : init_rstval_NC
      else if (`MEM_PORTB_RD_PIPE && (`MEM_PORTB_WF || `MEM_PORTB_RF)) begin : init_zero
        doutb_reg = {READ_DATA_WIDTH_B_ECC{1'b0}};
      end : init_zero
    end
    if (!`DISABLE_SYNTH_TEMPL) begin : gen_rd_b_synth_template
    // Asynchronous port B read; port width is the narrowest of the data ports; no output pipeline
    if (`MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_COMB) begin : gen_narrow_comb
      always @(*) begin
        doutb_reg = mem[addrb_int];
      end
    end : gen_narrow_comb

    // Asynchronous port B read; port width is wider than at least one other data port; no output pipeline
    else if (`MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_COMB) begin : gen_wide_comb
      always @(*) begin : rd_comb
        integer row;
        reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
        for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
          addrblsb = row;
          doutb_reg[`ONE_ROW_OF_DIN] = mem[{addrb_int, addrblsb}];
        end : for_mem_rows
      end : rd_comb
    end : gen_wide_comb

    // Synchronous port B write-first read; port width is the narrowest of the data ports; no output pipeline
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_REG && `MEM_PORTB_WR_WORD) begin : gen_wf_narrow_reg
      if(`ASYNC_RESET_B) begin
        always @(posedge rstb or posedge clkb_int) begin
          if (rstb)
            doutb_reg <= rstb_val;
          else begin
            if (enb_i) begin
              if (web_i)
                doutb_reg <= dinb_i;
              else
                doutb_reg <= mem[addrb_int];
            end
          end
        end
      end
      else begin
        always @(posedge clkb_int) begin
          if (rstb)
            doutb_reg <= rstb_val;
          else begin
            if (enb_i) begin
              if (web_i)
                doutb_reg <= dinb_i;
              else
                doutb_reg <= mem[addrb_int];
            end
          end
        end
      end
    end : gen_wf_narrow_reg

    // Synchronous port B write-first read; port width is the narrowest of the data ports; no output pipeline;
    // symmetric byte-wide write special case
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_REG &&
             `MEM_PORTB_WR_NARROW && `MEM_PORTB_WR_BYTE) begin : gen_wf_narrow_reg_sym_byte
      for (genvar col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin : for_mem_cols
        if(`ASYNC_RESET_B) begin
        always @(posedge rstb or posedge clkb_int) begin : wr_sync
          if (rstb)
            doutb_reg[`ONE_COL_OF_DINB] <= rstb_val[`ONE_COL_OF_DINB];
          else begin
            if (enb_i) begin
              if (web_i[col])
                doutb_reg[`ONE_COL_OF_DINB] <= dinb_i[`ONE_COL_OF_DINB];
              else
                doutb_reg[`ONE_COL_OF_DINB] <= mem[addrb_int][`ONE_COL_OF_DINB];
            end
          end
        end : wr_sync
      end
      else begin
        always @(posedge clkb_int) begin : wr_sync
          if (rstb)
            doutb_reg[`ONE_COL_OF_DINB] <= rstb_val[`ONE_COL_OF_DINB];
          else begin
            if (enb_i) begin
              if (web_i[col])
                doutb_reg[`ONE_COL_OF_DINB] <= dinb_i[`ONE_COL_OF_DINB];
              else
                doutb_reg[`ONE_COL_OF_DINB] <= mem[addrb_int][`ONE_COL_OF_DINB];
            end
          end
        end : wr_sync
      end
    end : for_mem_cols
    end : gen_wf_narrow_reg_sym_byte

    // Synchronous port B write-first read; port width is the narrowest of the data ports; output pipeline;
    // UltraRAM simple dual port RAM special case
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_PIPE &&
             `MEM_PRIM_ULTRA && `MEM_TYPE_RAM_SDP) begin : gen_wf_narrow_pipe_ultra_sdp
      reg [P_WIDTH_ADDR_WRITE_B-1:0] addrb_reg = {P_WIDTH_ADDR_WRITE_B{1'b0}};
      always @(posedge clkb_int) begin
        addrb_reg <= addrb_int;
      end
      always @(*) begin
        doutb_reg = mem[addrb_reg];
      end
    end : gen_wf_narrow_pipe_ultra_sdp

    // Synchronous port B write-first read; port width is the wider of the data ports; output pipeline;
    // UltraRAM simple dual port RAM special case
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_PIPE &&
             `MEM_PRIM_ULTRA && `MEM_TYPE_RAM_SDP) begin : gen_wf_wide_pipe_ultra_sdp
      reg [P_WIDTH_ADDR_WRITE_B-1:0] addrb_reg = {P_WIDTH_ADDR_WRITE_B{1'b0}};
      always @(posedge clkb_int) begin
        addrb_reg <= addrb_int;
      end
      always @(*) begin : rd_comb
        integer row;
        reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
        for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
          addrblsb = row;
          doutb_reg[`ONE_ROW_OF_DIN] = mem[{addrb_reg, addrblsb}];
        end : for_mem_rows
      end : rd_comb
    end : gen_wf_wide_pipe_ultra_sdp


    // Synchronous port B write-first read; port width is the narrowest of the data ports; output pipeline
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_PIPE && `MEM_PORTB_WR_WORD) begin : gen_wf_narrow_pipe
      always @(posedge clkb_int) begin
        if (enb_i) begin
          if (web_i)
            doutb_reg <= dinb_i;
          else
            doutb_reg <= mem[addrb_int];
        end
      end
    end : gen_wf_narrow_pipe

    // Synchronous port B write-first read; port width is the narrowest of the data ports; output pipeline;
    // symmetric byte-wide write special case
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_PIPE &&
             `MEM_PORTB_WR_NARROW && `MEM_PORTB_WR_BYTE) begin : gen_wf_narrow_pipe_sym_byte
      for (genvar col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin : for_mem_cols
        always @(posedge clkb_int) begin : wr_sync
          if (enb_i) begin
            if (web_i[col])
              doutb_reg[`ONE_COL_OF_DINB] <= dinb_i[`ONE_COL_OF_DINB];
            else
              doutb_reg[`ONE_COL_OF_DINB] <= mem[addrb_int][`ONE_COL_OF_DINB];
          end
        end : wr_sync
      end : for_mem_cols
    end : gen_wf_narrow_pipe_sym_byte

    // Synchronous port B write-first read; port width is wider than at least one other data port; no output pipeline;
    // write and read combined special case
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_REG) begin : gen_wf_wide_reg
      if(`ASYNC_RESET_B) begin
        always @(posedge rstb or posedge clkb_int) begin : wr_rd_sync
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
          for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
            addrblsb = row;
            if (rstb)
              doutb_reg[`ONE_ROW_OF_DIN] <= rstb_val[`ONE_ROW_OF_DIN];
            else begin
              if (enb_i) begin
                if (web_i)
                  doutb_reg[`ONE_ROW_OF_DIN] <= dinb_i[`ONE_ROW_OF_DIN];
                else
                  doutb_reg[`ONE_ROW_OF_DIN] <= mem[{addrb_int, addrblsb}];
              end
            end
          end : for_mem_rows
        end : wr_rd_sync
      end
      else begin
        always @(posedge clkb_int) begin : wr_rd_sync
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
          for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
            addrblsb = row;
            if (rstb)
              doutb_reg[`ONE_ROW_OF_DIN] <= rstb_val[`ONE_ROW_OF_DIN];
            else begin
              if (enb_i) begin
                if (web_i)
                  doutb_reg[`ONE_ROW_OF_DIN] <= dinb_i[`ONE_ROW_OF_DIN];
                else
                  doutb_reg[`ONE_ROW_OF_DIN] <= mem[{addrb_int, addrblsb}];
              end
            end
          end : for_mem_rows
        end : wr_rd_sync
      end 
    end : gen_wf_wide_reg

    // Synchronous port B write-first read; port width is wider than at least one other data port; output pipeline;
    // write and read combined special case
    else if (`MEM_PORTB_WF && `MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_PIPE) begin : gen_wf_wide_pipe
      always @(posedge clkb_int) begin : wr_rd_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
        for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
          addrblsb = row;
          if (enb_i) begin
            if (web_i)
              mem[{addrb_int, addrblsb}] = dinb_i[`ONE_ROW_OF_DIN];
            doutb_reg[`ONE_ROW_OF_DIN] <= mem[{addrb_int, addrblsb}];
          end
        end : for_mem_rows
      end : wr_rd_sync
    end : gen_wf_wide_pipe

    // Synchronous port B read-first read; port width is the narrowest of the data ports; no output pipeline
    else if (`MEM_PORTB_RF && `MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_REG) begin : gen_rf_narrow_reg
      if(`ASYNC_RESET_B) begin
        always @(posedge rstb or posedge clkb_int) begin
          if (rstb)
            doutb_reg <= rstb_val;
          else begin
            if (enb_i)
              doutb_reg <= mem[addrb_int];
          end
        end
      end
      else begin
        always @(posedge clkb_int) begin
          if (rstb)
            doutb_reg <= rstb_val;
          else begin
            if (enb_i)
              doutb_reg <= mem[addrb_int];
          end
        end
      end
    end : gen_rf_narrow_reg

    // Synchronous port B read-first read; port width is the narrowest of the data ports; output pipeline
    else if (`MEM_PORTB_RF && `MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_PIPE) begin : gen_rf_narrow_pipe
      always @(posedge clkb_int) begin
        if (enb_i)
          doutb_reg <= mem[addrb_int];
      end
    end : gen_rf_narrow_pipe

    // Synchronous port B read-first read; port width is wider than at least one other data port; no output pipeline
    else if (`MEM_PORTB_RF && `MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_REG) begin : gen_rf_wide_reg
      if(`ASYNC_RESET_B) begin
        always @(posedge rstb or posedge clkb_int) begin : rd_sync
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
          for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
            addrblsb = row;
            if (rstb)
              doutb_reg[`ONE_ROW_OF_DIN] <= rstb_val[`ONE_ROW_OF_DIN];
            else begin
              if (enb_i)
                doutb_reg[`ONE_ROW_OF_DIN] <= mem[{addrb_int, addrblsb}];
            end
          end : for_mem_rows
        end : rd_sync
      end
      else begin
        always @(posedge clkb_int) begin : rd_sync
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
          for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
            addrblsb = row;
            if (rstb)
              doutb_reg[`ONE_ROW_OF_DIN] <= rstb_val[`ONE_ROW_OF_DIN];
            else begin
              if (enb_i)
                doutb_reg[`ONE_ROW_OF_DIN] <= mem[{addrb_int, addrblsb}];
            end
          end : for_mem_rows
        end : rd_sync
      end
    end : gen_rf_wide_reg

    // Synchronous port B read-first read; port width is wider than at least one other data port; output pipeline
    else if (`MEM_PORTB_RF && `MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_PIPE) begin : gen_rf_wide_pipe
      always @(posedge clkb_int) begin : rd_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
        for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
          addrblsb = row;
          if (enb_i)
            doutb_reg[`ONE_ROW_OF_DIN] <= mem[{addrb_int, addrblsb}];
        end : for_mem_rows
      end : rd_sync
    end : gen_rf_wide_pipe

    // Synchronous port B no-change read; port width is the narrowest of the data ports; no output pipeline
    else if (`MEM_PORTB_NC && `MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_REG) begin : gen_nc_narrow_reg
      if(`ASYNC_RESET_B) begin
        always @(posedge rstb or posedge clkb_int) begin
          if (rstb)
            doutb_reg <= rstb_val;
          else begin
            if (enb_i) begin
              if (~|web_i)
                doutb_reg <= mem[addrb_int];
            end
          end
        end
      end
      else begin
        always @(posedge clkb_int) begin
          if (rstb)
            doutb_reg <= rstb_val;
          else begin
            if (enb_i) begin
              if (~|web_i)
                doutb_reg <= mem[addrb_int];
            end
          end
        end
      end
    end : gen_nc_narrow_reg

    // Synchronous port B no-change read; port width is the narrowest of the data ports; output pipeline
    else if (`MEM_PORTB_NC && `MEM_PORTB_RD_NARROW && `MEM_PORTB_RD_PIPE) begin : gen_nc_narrow_pipe
      always @(posedge clkb_int) begin
        if (enb_i) begin
          if (~|web_i)
            doutb_reg <= mem[addrb_int];
        end
      end
    end : gen_nc_narrow_pipe

    // Synchronous port B no-change read; port width is wider than at least one other data port; no output pipeline
    else if (`MEM_PORTB_NC && `MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_REG) begin : gen_nc_wide_reg
      if(`ASYNC_RESET_B) begin
        always @(posedge rstb or posedge clkb_int) begin : rd_sync
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
          for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
            addrblsb = row;
            if (rstb)
              doutb_reg[`ONE_ROW_OF_DIN] <= rstb_val[`ONE_ROW_OF_DIN];
            else begin
              if (enb_i) begin
                if (~|web_i)
                  doutb_reg[`ONE_ROW_OF_DIN] <= mem[{addrb_int, addrblsb}];
              end
            end
          end : for_mem_rows
        end : rd_sync
      end
      else begin
        always @(posedge clkb_int) begin : rd_sync
          integer row;
          reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
          for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
            addrblsb = row;
            if (rstb)
              doutb_reg[`ONE_ROW_OF_DIN] <= rstb_val[`ONE_ROW_OF_DIN];
            else begin
              if (enb_i) begin
                if (~|web_i)
                  doutb_reg[`ONE_ROW_OF_DIN] <= mem[{addrb_int, addrblsb}];
              end
            end
          end : for_mem_rows
        end : rd_sync
      end
    end : gen_nc_wide_reg

    // Synchronous port B no-change read; port width is wider than at least one other data port; output pipeline
    else if (`MEM_PORTB_NC && `MEM_PORTB_RD_WIDE && `MEM_PORTB_RD_PIPE) begin : gen_nc_wide_pipe
      always @(posedge clkb_int) begin : rd_sync
        integer row;
        reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
        for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
          addrblsb = row;
          if (enb_i) begin
            if (~|web_i)
              doutb_reg[`ONE_ROW_OF_DIN] <= mem[{addrb_int, addrblsb}];
          end
        end : for_mem_rows
      end : rd_sync
    end : gen_nc_wide_pipe
    end : gen_rd_b_synth_template
    else begin : gen_rd_b_synth_black_box
      always @(*) begin
        doutb_reg = doutb_bb;
      end
    end : gen_rd_b_synth_black_box
    // If no output pipeline is used, then the enabled read process directly drives the data output port
    if (`MEM_PORTB_RD_COMB || `MEM_PORTB_RD_REG) begin : gen_doutb
      assign doutb = doutb_reg;
    end : gen_doutb

    // If an output pipeline is used, generate it
    else if (`MEM_PORTB_RD_PIPE) begin : gen_doutb_pipe
      reg                         enb_pipe   [READ_LATENCY_B-2:0];
      reg [READ_DATA_WIDTH_B_ECC-1:0] doutb_pipe [READ_LATENCY_B-2:0];

      always @(posedge clkb_int) begin
        enb_pipe[0] <= enb_o_pipe_ctrl;
      end

      // Initialize the final output pipeline stage to the specified reset value, and all prior stages to zero
      initial begin
        integer initstage;
        for (initstage=0; initstage<READ_LATENCY_B-1; initstage=initstage+1) begin : for_pipe_init
          if (initstage < READ_LATENCY_B-2 && (`MEM_PORTB_WF || `MEM_PORTB_RF)) begin : init_zero
            doutb_pipe[initstage] = {READ_DATA_WIDTH_B_ECC{1'b0}};
          end : init_zero
          else if (initstage < READ_LATENCY_B-2 && `MEM_PORTB_NC ) begin : init_rstval_NC
            doutb_pipe[initstage] = rstb_val;
          end : init_rstval_NC
          else begin : init_rstval
            doutb_pipe[initstage] = rstb_val;
          end : init_rstval
        end : for_pipe_init
      end

      // If two stages are used, the synchronous read output drives the final pipeline stage
      if (READ_LATENCY_B == 2) begin : gen_stage
        if(`ASYNC_RESET_B) begin
          always @(posedge rstb or posedge clkb_int) begin
            if (rstb)
              doutb_pipe[0] <= rstb_val;
            else begin
              if (regceb_i)
                doutb_pipe[0] <= doutb_reg;
            end
          end
        end
        else begin
          always @(posedge clkb_int) begin
            if (rstb)
              doutb_pipe[0] <= rstb_val;
            else begin
              if (regceb_i)
                doutb_pipe[0] <= doutb_reg;
            end
          end
        end
      end : gen_stage

      // If more than two stages are used, loops generate all pipeline stages except the first and last
      else if (READ_LATENCY_B > 2) begin : gen_stages
        always @(posedge clkb_int) begin
          if (enb_pipe[0])
            doutb_pipe[0] <= doutb_reg;
        end

        for (genvar estage=1; estage<READ_LATENCY_B-1; estage=estage+1) begin : gen_epipe
          always @(posedge clkb_int) begin
            enb_pipe[estage] <= enb_pipe[estage-1];
          end
        end : gen_epipe

        for (genvar dstage=1; dstage<READ_LATENCY_B-2; dstage=dstage+1) begin : gen_dpipe
          always @(posedge clkb_int) begin
            if (enb_pipe[dstage])
              doutb_pipe[dstage] <= doutb_pipe[dstage-1];
          end
        end : gen_dpipe

        if(`ASYNC_RESET_B) begin
          always @(posedge rstb or posedge clkb_int) begin
            if (rstb)
              doutb_pipe[READ_LATENCY_B-2] <= rstb_val;
            else begin
              if (regceb_i)
                doutb_pipe[READ_LATENCY_B-2] <= doutb_pipe[READ_LATENCY_B-3];
            end
          end
        end
        else begin
          always @(posedge clkb_int) begin
            if (rstb)
              doutb_pipe[READ_LATENCY_B-2] <= rstb_val;
            else begin
              if (regceb_i)
                doutb_pipe[READ_LATENCY_B-2] <= doutb_pipe[READ_LATENCY_B-3];
            end
          end
        end
      end : gen_stages

      // The final pipeline stage drives the data output port
      assign doutb = doutb_pipe[READ_LATENCY_B-2];
    end : gen_doutb_pipe

    if(ECC_MODE == 2 || ECC_MODE == 3) begin : pipeline_ecc_status
      (* keep = "yes", xpm_ecc_sbiterr = "yes"*)  wire sbiterrb_ram;
      (* keep = "yes", xpm_ecc_dbiterr = "yes"*)  wire dbiterrb_ram;
      reg sbiterrb_in_pipe;
      reg dbiterrb_in_pipe;

      // WRITE_FIRST Mode
      // This mode is allowed only for Ultra RAM + SDP + RL > 3
      if (`MEM_PORTB_WF) begin : ecc_status_wf_reg
        always @(*) begin
          sbiterrb_in_pipe <= sbiterrb_ram;
          dbiterrb_in_pipe <= dbiterrb_ram;
        end
      end : ecc_status_wf_reg

      // READ_FIRST Mode
      if (`MEM_PORTB_RF && `MEM_PORTB_RD_REG) begin : ecc_status_rf_reg
        always @(posedge clkb_int) begin
          if(rstb) begin
            sbiterrb_in_pipe <= 1'b0;
            dbiterrb_in_pipe <= 1'b0;
          end
          else if (enb_i) begin
            sbiterrb_in_pipe <= sbiterrb_ram;
            dbiterrb_in_pipe <= dbiterrb_ram;
          end
        end
      end : ecc_status_rf_reg

      if (`MEM_PORTB_RF && `MEM_PORTB_RD_PIPE) begin : ecc_status_rf_pipe
        always @(posedge clkb_int) begin
          if (enb_i) begin
            sbiterrb_in_pipe <= sbiterrb_ram;
            dbiterrb_in_pipe <= dbiterrb_ram;
          end
        end
      end : ecc_status_rf_pipe

      // NO_CHANGE Mode
      if (`MEM_PORTB_NC && `MEM_PORTB_RD_REG) begin : ecc_status_nc_reg
        always @(posedge clkb_int) begin
          if(rstb) begin
            sbiterrb_in_pipe <= 1'b0;
            dbiterrb_in_pipe <= 1'b0;
          end
          else if (enb_i) begin
            if(~(|web_i)) begin
              sbiterrb_in_pipe <= sbiterrb_ram;
              dbiterrb_in_pipe <= dbiterrb_ram;
            end
          end
        end
      end : ecc_status_nc_reg

      if (`MEM_PORTB_NC && `MEM_PORTB_RD_PIPE) begin : ecc_status_nc_pipe
        always @(posedge clkb_int) begin
          if (enb_i) begin
            if(~(|web_i)) begin
              sbiterrb_in_pipe <= sbiterrb_ram;
              dbiterrb_in_pipe <= dbiterrb_ram;
            end
          end
        end
      end : ecc_status_nc_pipe

      // Error status signals (should be pipelined along with the data)
      if (READ_LATENCY_B >= 2) begin : ecc_status_b_pipe
        reg sbiterrb_pipe   [READ_LATENCY_B-2:0];    
        reg dbiterrb_pipe   [READ_LATENCY_B-2:0];    
 
        if (READ_LATENCY_B == 2) begin : RL_2_dly_err_status
          always @(posedge clkb_int) begin
            if(rstb) begin
              sbiterrb_i <= 1'b0;
              dbiterrb_i <= 1'b0;
            end
            else if (regceb_i) begin
              sbiterrb_i <= sbiterrb_in_pipe;
              dbiterrb_i <= dbiterrb_in_pipe;
            end
          end
        end : RL_2_dly_err_status

        if (READ_LATENCY_B > 2) begin : RL_gr_2_dly_err_status
        reg enb_ecc_pipe   [READ_LATENCY_B-2:0];
          always @(posedge clkb_int) begin
            enb_ecc_pipe[0] <= enb_o_pipe_ctrl;
          end

          for (genvar ecc_estage_b=1; ecc_estage_b<READ_LATENCY_B-1; ecc_estage_b=ecc_estage_b+1) begin : gen_epipe
            always @(posedge clkb_int) begin
              enb_ecc_pipe[ecc_estage_b] <= enb_ecc_pipe[ecc_estage_b-1];
            end
          end : gen_epipe

          always @(posedge clkb_int) begin
            if (enb_ecc_pipe[0]) begin
              sbiterrb_pipe[0] <= sbiterrb_in_pipe;
              dbiterrb_pipe[0] <= dbiterrb_in_pipe;
            end
          end
          for (genvar ecc_errstage_b=1; ecc_errstage_b<READ_LATENCY_B-2; ecc_errstage_b=ecc_errstage_b+1) begin : portb_gen_ecc_epipe
            always @(posedge clkb_int) begin
              if (enb_ecc_pipe[ecc_errstage_b]) begin
                sbiterrb_pipe[ecc_errstage_b]   <= sbiterrb_pipe[ecc_errstage_b-1];
                dbiterrb_pipe[ecc_errstage_b]   <= dbiterrb_pipe[ecc_errstage_b-1];
              end
            end
          end : portb_gen_ecc_epipe
          always @(posedge clkb_int) begin
            if(rstb) begin
              sbiterrb_i <= 1'b0;
              dbiterrb_i <= 1'b0;
            end
            else if (regceb_i) begin
              sbiterrb_i <= sbiterrb_pipe[READ_LATENCY_B-3];
              dbiterrb_i <= dbiterrb_pipe[READ_LATENCY_B-3];
            end
          end
          end : RL_gr_2_dly_err_status
      end : ecc_status_b_pipe
      else begin :ecc_status_b_reg
        always @(*) begin
          sbiterrb_i = sbiterrb_in_pipe;
          dbiterrb_i = dbiterrb_in_pipe;
        end
      end : ecc_status_b_reg
    end : pipeline_ecc_status
    else begin : no_ecc_err_status
//      always_comb begin
//        sbiterrb_i = 0;
//        dbiterrb_i = 0;
//      end
    end : no_ecc_err_status
    // Assign to output signals
     assign sbiterrb = sbiterrb_i;
     assign dbiterrb = dbiterrb_i;
  end : gen_rd_b

  // If a port B read process is not generated, drive the data output port to a constant zero
  else begin : gen_no_rd_b
    assign doutb = {READ_DATA_WIDTH_B{1'b0}};
    assign sbiterrb = 1'b0;
    assign dbiterrb = 1'b0;
  end : gen_no_rd_b

  // -------------------------------------------------------------------------------------------------------------------
  // Simulation constructs
  // -------------------------------------------------------------------------------------------------------------------
  // synthesis translate_off
  // Param to enable or disable the cover points/assertion checks

  // Sleep related signals shall be used across the simulation model,
  // so declaring them globally
  reg sleep_int_a = 0; // sleep port registered on Port-A clock 
  reg sleep_int_b = 0; // sleep port registered on Port-B clock
  wire [ADDR_WIDTH_A-1:0] addra_aslp_sim; // Delayed address in auto sleep mode that is
                                          // used to check out of range addressing
  wire [ADDR_WIDTH_B-1:0] addrb_aslp_sim;

  // Internal wires to accomodate Auto sleep mode delays if enabled
  wire injectsbiterra_sim;
  wire injectdbiterra_sim;
  wire injectsbiterrb_sim;
  wire injectdbiterrb_sim;

  initial begin
  #1;
    if (`REPORT_MESSAGES && (!`MEM_TYPE_RAM_TDP || !`MEM_TYPE_RAM_SDP || `MEM_PRIM_DISTRIBUTED || `MEM_PRIM_ULTRA))
      $warning("MESSAGE_CONTROL (%0d) specifies simulation message reporting, but this release of XPM_MEMORY only reports messages for true dual port RAM and simple dual port RAM configurations which specify auto or block memory primitive types.", MESSAGE_CONTROL);
    if (`REPORT_MESSAGES && (`MEM_TYPE_RAM_TDP || `MEM_TYPE_RAM_SDP) && !(`MEM_PRIM_DISTRIBUTED || `MEM_PRIM_ULTRA))
    `ifdef OBSOLETE
      $warning("Vivado Simulator does not currently support the SystemVerilog Assertion syntax used within XPM_MEMORY. Memory collisions will not be reported.");
    `else
      $info("MESSAGE_CONTROL (%0d) specifies simulation message reporting, this release of XPM_MEMORY reports messages for potential write-write and write-read collisions in this configuration.", MESSAGE_CONTROL);
    `endif
  end

  // Simulation assertions warn of the effects when potential write-write, write-read collisions occur and illegal access to memory
  `ifndef OBSOLETE

  // The below message is to catch the out-of range address access for a write
  // operation.

  if (`REPORT_MESSAGES && `MEM_PORTA_WRITE && AUTO_SLEEP_TIME == 0 && !(`DISABLE_SYNTH_TEMPL)) begin : illegal_wr_ena
    assert property (@(posedge clka)
      !(ena === 1 && |wea && (addra > gen_wr_a.addra_int) ))
    else
      $warning("XPM_MEMORY_OUT_OF_RANGE_WRITE_ACCESS : Write Operation on Port-A to an out-of-range address at time %0t; Actual Address --> %0h , effective address is %0h.There is a chance that data at the effective address location may get written in the synthesis netlist, and there by the simulation mismatch can occur between behavioral model and netlist simulations", $time,addra,gen_wr_a.addra_int);
  end : illegal_wr_ena

  if (`REPORT_MESSAGES && `MEM_PORTB_WRITE && AUTO_SLEEP_TIME == 0 && !(`DISABLE_SYNTH_TEMPL)) begin : illegal_wr_enb
    assert property (@(posedge gen_wr_b.clkb_int)
      !(enb === 1 && |web && (addrb > gen_wr_b.addrb_int) ))
    else
      $warning("XPM_MEMORY_OUT_OF_RANGE_WRITE_ACCESS : Write Operation on Port-B to an out-of-range address at time %0t; Actual Address --> %0h , effective address is %0h.There is a chance that data at the effective address location may get written in the synthesis netlist, and there by the simulation mismatch can occur between behavioral model and netlist simulations", $time,addrb,gen_wr_b.addrb_int);
  end : illegal_wr_enb

  // In ECC Reset is not supported and these messages are not guarded under
  // MESSAGE_CONTROL param, as these are critical.

  if (!(`NO_ECC) && `MEM_PORTA_READ) begin : illegal_rsta_in_ecc
    assert property (@(posedge clka)
      !(rsta))
    else
      $warning("XPM_MEMORY_ILLEGAL_RESET_IN_ECC_MODE : Attempt to reset the data output through Port-A at time %0t when ECC is enabled ; reset operation is not supported when ECC is enabled.", $time);
  end : illegal_rsta_in_ecc

  if (!(`NO_ECC) && `MEM_PORTB_READ) begin : illegal_rstb_in_ecc
    assert property (@(posedge gen_rd_b.clkb_int)
      !(rstb))
    else
      $warning("XPM_MEMORY_ILLEGAL_RESET_IN_ECC_MODE : Attempt to reset the data output through Port-B at time %0t when ECC is enabled ; reset operation is not supported when ECC is enabled.", $time);
  end : illegal_rstb_in_ecc

  if (`REPORT_MESSAGES) begin : gen_assert_illegal_mem_access_w
    // Assertion to catch illegal write access to the memory through port-B when
    // the memory type is set to simple Dual port RAM
    if (`MEM_TYPE_RAM_SDP) begin : illegal_mem_access_w_sdp
      assert property (@(posedge clkb)
        !(enb && |web))
      else
        $warning("XPM_MEMORY_ILLEGAL_WRITE_SDP : Attempt to write to memory through Port-B at address 0x%0h at time %0t when the memory type is set to simple dual port RAM ; data outputs and memory content may be corrupted.", addrb, $time);
    end : illegal_mem_access_w_sdp
    // Assertion to catch illegal write access to the memory through port-A when
    // the memory type is set to single port ROM/Dual Port ROM
    if (`MEM_TYPE_ROM) begin : illegal_mem_access_w_rom
      assert property (@(posedge clka)
        !(ena && |wea))
      else
        $warning("XPM_MEMORY_ILLEGAL_WRITE_ROM: Attempt to write to memory through Port-A at address 0x%0h at time %0t for ROM configuration ; data outputs and memory content may be corrupted.", addra, $time);
    end : illegal_mem_access_w_rom
    // Assertion to catch illegal write access to the memory through port-B when
    // the memory type is set to Dual Port ROM
    if (`MEM_TYPE_ROM_DP) begin : illegal_mem_access_w_dprom
      assert property (@(posedge clkb)
        !(enb && |web))
      else
        $warning("XPM_MEMORY_ILLEGAL_WRITE_ROM: Attempt to write to memory through Port-B at address 0x%0h at time %0t for ROM configuration ; data outputs and memory content may be corrupted.", addrb, $time);
    end : illegal_mem_access_w_dprom

  // Assertion to catch illegal REGCE assertion after Reset

  if(`MEM_PORTA_READ && `MEM_PORTA_RD_PIPE && `REPORT_MESSAGES) begin : illegal_regcea_after_rsta
    reg flag_rst_regce_a = 1'b0;
    // flag generation to capture the reset to valid enable duration
    always @(posedge clka)
      begin
       if (rsta)
         flag_rst_regce_a <= 1'b1;
       else begin
         if (gen_rd_a.gen_douta_pipe.ena_pipe[READ_LATENCY_A-2])
           flag_rst_regce_a <= 1'b0;
       end
      end
      // Assertion
      assert property (@(posedge clka)
        !(~rsta && regcea && flag_rst_regce_a))
      else
        $warning("regcea asserted at address 0x%0h at time %0t after reset without a valid read happened to the memory ; reset value on the output port maynot be preserved.", addra, $time);
  end : illegal_regcea_after_rsta
  
  if(`MEM_PORTB_READ && `MEM_PORTB_RD_PIPE && `REPORT_MESSAGES) begin : illegal_regcea_after_rstb
    reg flag_rst_regce_b = 1'b0;
    // flag generation to capture the reset to valid enable duration
    always @(posedge clkb)
      begin
       if (rstb)
         flag_rst_regce_b <= 1'b1;
       else begin
         if (gen_rd_b.gen_doutb_pipe.enb_pipe[READ_LATENCY_B-2])
           flag_rst_regce_b <= 1'b0;
       end
      end
      // Assertion
      assert property (@(posedge clkb)
        !(~rstb && regceb && flag_rst_regce_b))
      else
        $warning("regceb asserted at address 0x%0h at time %0t after reset without a valid read happened to the memory ; reset value on the output port maynot be preserved.", addrb, $time);
  end : illegal_regcea_after_rstb

  // Decode only mode can not have error injection
    if (`DEC_ONLY) begin : illegal_injerr_dec_only
      assert property (@(posedge clka)
        !(ena && |wea && injectsbiterra))
      else
        $warning("XPM_MEMORY_ILLEGAL_ERR_INJ_ASSRT: Attempt to inject single bit error into the memory through Port-A at address 0x%0h at time %0t in Decode only mode configuration ; Error injection is not allowed in Decode only mode.", addra, $time);
      assert property (@(posedge clka)
        !(ena && |wea && injectdbiterra))
      else
        $warning("XPM_MEMORY_ILLEGAL_ERR_INJ_ASSRT: Attempt to inject double bit error into the memory through Port-A at address 0x%0h at time %0t in Decode only mode configuration ; Error injection is not allowed in Decode only mode.", addra, $time);
      assert property (@(posedge clkb)
        !(enb && |web && injectsbiterrb))
      else
        $warning("XPM_MEMORY_ILLEGAL_ERR_INJ_ASSRT: Attempt to inject single bit error into the memory through Port-B at address 0x%0h at time %0t in Decode only mode configuration ; Error injection is not allowed in Decode only mode.", addrb, $time);

      assert property (@(posedge clkb)
        !(enb && |web && injectdbiterrb))
      else
        $warning("XPM_MEMORY_ILLEGAL_ERR_INJ_ASSRT: Attempt to inject double bit error into the memory through Port-B at address 0x%0h at time %0t in Decode only mode configuration ; Error injection is not allowed in Decode only mode.", addrb, $time);

    end : illegal_injerr_dec_only

  end : gen_assert_illegal_mem_access_w

  if ((`MEM_TYPE_RAM_TDP || `MEM_TYPE_RAM_SDP) && !(`MEM_PRIM_DISTRIBUTED || `MEM_PRIM_ULTRA)) begin : gen_assert_coll_ww

    // When port A and port B use independent clocks, capture write transactions to detect collisions
    reg wra = 1'b0;
    reg wrb = 1'b0;
    reg rda_cap = 1'b0;
    reg rdb_cap = 1'b0;
    reg [(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0] wea_cap = 'b0;
    reg [(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B)-1:0] web_cap = 'b0;
    reg [P_WIDTH_ADDR_WRITE_A-1:0] addra_cap = 'b0;
    reg [P_WIDTH_ADDR_WRITE_A-1:0] addra_rd_cap = 'b0;
    reg [P_WIDTH_ADDR_WRITE_B-1:0] addrb_cap = 'b0;
    reg [P_WIDTH_ADDR_WRITE_B-1:0] addrb_rd_cap = 'b0;

    /**************************************************************************************************
    | Collision Minimum and Maximum window requirements                                               |
    |   Minimum window requirement = 50 ps                                                            |
    |   Maximum window requirement -->                                                                |
    |     If the clock period is >= 3000 ps, then the window is 3000 ps                               |
    |     If the clock period is >50 ps  < 3000 ps, then the window is "Clock period" ps              |
    **************************************************************************************************/
    integer t_half_period_a = 3000;
    integer t_half_period_b = 3000;
    reg clk_prd_det_a = 0;
    reg clk_prd_det_b = 0;
    // Determine the clock periods
   initial begin
        @(posedge clka);
          t_half_period_a = $time/1.0;
        @ (negedge clka) t_half_period_a = $time/1.0 - t_half_period_a;
        clk_prd_det_a <= 1;
   end
   initial begin
        @(posedge clkb);
          t_half_period_b = $time/1.0;
        @ (negedge clkb) t_half_period_b = $time/1.0 - t_half_period_b;
        clk_prd_det_b <= 1;
   end

   integer col_win_max = 0;
   
    always @(clka or clkb) begin
      if(~(clk_prd_det_a && clk_prd_det_b)) begin
        if(t_half_period_a > 1500 && t_half_period_b > 1500)
          col_win_max = 3000;
        else if(t_half_period_a <= 1500 && t_half_period_a <= t_half_period_b)
          col_win_max = 2 * t_half_period_a;
        else if(t_half_period_b <= 1500 && t_half_period_b <= t_half_period_a)
          col_win_max = 2 * t_half_period_b;
        else
          col_win_max = 500;
      end
    end

    reg col_win_wr_a = 'b0;
    reg col_win_rd_a = 'b0;

    always @(posedge clka) begin
      if(ena) begin
        if(|wea) begin
          col_win_wr_a <= 1'b1;
          col_win_wr_a <= #(col_win_max) 1'b0;
        end
      end
    end
    
    always @(posedge clka) begin
      if(ena) begin
        if(~(|wea)) begin
          col_win_rd_a <= 1'b1;
          col_win_rd_a <= #(col_win_max) 1'b0;
        end
      end
    end

    reg col_win_wr_b = 'b0;
    reg col_win_rd_b = 'b0;

    always @(posedge clkb) begin
      if(enb) begin
        if(|web) begin
          col_win_wr_b <= 1'b1;
          col_win_wr_b <= #(col_win_max) 1'b0;
        end
      end
    end
    
    always @(posedge clkb) begin
      if(enb) begin
        if(~(|web)) begin
          col_win_rd_b <= 1'b1;
          col_win_rd_b <= #(col_win_max) 1'b0;
        end
      end
    end

    if (`INDEPENDENT_CLOCKS) begin : gen_wr_cap
    
      // Capture port A write transactions for one port A clock cycle, for purposes of detecting a collision at clock B
      always @(posedge clka) begin
        if (ena && |wea) begin
          wra       <= 1'b1;
          wea_cap   <= wea;
          addra_cap <= addra_i;
        end
        else
          wra <= 1'b0;
      end
      
      // Capture port A read transactions for one port A clock cycle, for purposes of detecting a collision at clock B
      always @(posedge clka) begin
        rda_cap   <= (ena && ~(|wea));
        if(ena && ~(|wea))
          addra_rd_cap <= addra_i;          
      end

      // Capture port B write transactions for one port B clock cycle, for purposes of detecting a collision at clock A
      always @(posedge clkb) begin
        if (enb && |web) begin
          wrb       <= 1'b1;
          web_cap   <= web;
          addrb_cap <= addrb_i;
        end
        else
          wrb <= 1'b0;
      end

      // Capture port B read transactions for one port B clock cycle, for purposes of detecting a collision at clock A
      always @(posedge clkb) begin
        rdb_cap   <= (enb && ~(|web));
        if(enb && ~(|web))
          addrb_rd_cap <= addrb_i;
      end

    end : gen_wr_cap

    if(`REPORT_MESSAGES) begin : gen_coll_msgs
     // Port A and port B write data widths are symmetric
     if (WRITE_DATA_WIDTH_A == WRITE_DATA_WIDTH_B) begin : gen_wdw_sym

      // Port A and port B write enable widths are symmetric
      if (BYTE_WRITE_WIDTH_A == BYTE_WRITE_WIDTH_B) begin : gen_we_sym

        // Port A and port B use a common clock
        if (`COMMON_CLOCK) begin : gen_clock
          assert property (@(posedge clka)
            ena && enb |-> !((addra == addrb) && |(wea & web)))
          else
            $warning("COLLISION: potential write-write collision to memory at time %0t (address location --> %0d); data outputs and memory content may be corrupted.", $time,addra);
          if (!`IS_COLLISION_SAFE) begin : col_unsafe
            assert property (@(posedge clka)
              ena && enb |-> !((addra == addrb) && (|wea && ~(|web))))
            else
              $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-A, Read happened through --> Port-B at address location %0d).", $time,addra);

            assert property (@(posedge clka)
              ena && enb |-> !((addra == addrb) && (~(|wea) && |web )))
            else
              $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-B, Read happened through --> Port-A at address location %0d).", $time,addrb);
          end : col_unsafe

        end : gen_clock

        // Port A and port B use independent clocks
        else if (`INDEPENDENT_CLOCKS) begin : gen_clocks

          assert property (@(posedge clkb)
            enb && |web && $rose(wra) |-> !((addrb == addra_cap) && |(web & wea_cap)))
          else
            $warning("COLLISION: potential write-write collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
          assert property (@(posedge clka)
            ena && |wea && $rose(wrb) |-> !((addra == addrb_cap) && |(wea & web_cap)))
          else
            $warning("COLLISION: potential write-write collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);

          if (!`IS_COLLISION_SAFE) begin : col_unsafe
          assert property (@(posedge clkb)
            enb && |web && $rose(rda_cap) |-> !((addrb == addra_rd_cap) && (~(|wea_cap) && |web)))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
          assert property (@(posedge clkb)
            enb && ~(|web) && $rose(wra) |-> !((addrb == addra_cap) && (|wea_cap && ~(|web))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);

          assert property (@(posedge clka)
            ena && |wea && $rose(rdb_cap) |-> !((addra == addrb_rd_cap) && (|wea && ~(|web_cap))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
          assert property (@(posedge clka)
            ena && ~(|wea) && $rose(wra) |-> !((addra == addrb_cap) && (~(|wea) && (|web_cap))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
          end : col_unsafe

        end : gen_clocks
      end : gen_we_sym

      // Port A write enable is wider than port B write enable
      else if (WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A > 1) begin : gen_we_wide_a

        // Port A and port B use a common clock
        if (`COMMON_CLOCK) begin : gen_clock
          assert property (@(posedge clka)
            ena && enb |-> !((addra == addrb) && |(wea & {(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A){web}})))
          else
            $warning("COLLISION: potential write-write collision to memory at time %0t (address location --> %0d); data outputs and memory content may be corrupted.", $time,addra);
          
          if (!`IS_COLLISION_SAFE) begin : col_unsafe
          assert property (@(posedge clka)
            ena && enb |-> !((addra == addrb) && (|wea && ~(|web))))
          else
            $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-A, Read happened through --> Port-B at address location %0d).", $time,addra);

          assert property (@(posedge clka)
            ena && enb |-> !((addra == addrb) && (~(|wea) && |web )))
          else
            $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-B, Read happened through --> Port-A at address location %0d).", $time,addrb);
          end : col_unsafe

        end : gen_clock

        // Port A and port B use independent clocks
        else if (`INDEPENDENT_CLOCKS) begin : gen_clocks
          assert property (@(posedge clkb)
            enb && web && $rose(wra) |-> !((addrb == addra_cap) && |({(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A){web}} & wea_cap)))
          else
            $warning("COLLISION: potential write-write collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
          assert property (@(posedge clka)
            ena && |wea && $rose(wrb) |-> !((addra == addrb_cap) && |(wea & {(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A){web_cap}})))
          else
            $warning("COLLISION: potential write-write collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
        
          if (!`IS_COLLISION_SAFE) begin : col_unsafe
          assert property (@(posedge clkb)
            enb && |web && $rose(rda_cap) |-> !((addrb == addra_rd_cap) && (~(|wea_cap) && |web)))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
          assert property (@(posedge clkb)
            enb && ~(|web) && $rose(wra) |-> !((addrb == addra_cap) && (|wea_cap && ~(|web))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);

          assert property (@(posedge clka)
            ena && |wea && $rose(rdb_cap) |-> !((addra == addrb_rd_cap) && (|wea && ~(|web_cap))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
          assert property (@(posedge clka)
            ena && ~(|wea) && $rose(wra) |-> !((addra == addrb_cap) && (~(|wea) && (|web_cap))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
          end : col_unsafe

        end : gen_clocks
      end : gen_we_wide_a

      // Port B write enable is wider than port A write enable
      else if (WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B > 1) begin : gen_we_wide_b

        // Port A and port B use a common clock
        if (`COMMON_CLOCK) begin : gen_clock
          assert property (@(posedge clka)
            ena && enb |-> !((addra == addrb) && |({(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B){wea}} & web)))
          else
            $warning("COLLISION: potential write-write collision to memory at time %0t (address location --> %0d); data outputs and memory content may be corrupted.", $time,addra);
    
          if (!`IS_COLLISION_SAFE) begin : col_unsafe
          assert property (@(posedge clka)
            ena && enb |-> !((addra == addrb) && (|wea && ~(|web))))
          else
            $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-A, Read happened through --> Port-B at address location %0d).", $time,addra);

          assert property (@(posedge clka)
            ena && enb |-> !((addra == addrb) && (~(|wea) && |web )))
          else
            $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-B, Read happened through --> Port-A at address location %0d).", $time,addrb);
          end : col_unsafe
        end : gen_clock

        // Port A and port B use independent clocks
        else if (`INDEPENDENT_CLOCKS) begin : gen_clocks
          assert property (@(posedge clkb)
            enb && |web && $rose(wra) |-> !((addrb == addra_cap) && |(web & {(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B){wea_cap}})))
          else
            $warning("COLLISION: potential write-write collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
          assert property (@(posedge clka)
            ena && |wea && $rose(wrb) |-> !((addra == addrb_cap) && |({(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B){wea}} & web_cap)))
          else
            $warning("COLLISION: potential write-write collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
 
          if (!`IS_COLLISION_SAFE) begin : col_unsafe
            assert property (@(posedge clkb)
              enb && |web && $rose(rda_cap) |-> !((addrb == addra_rd_cap) && (~(|wea_cap) && |web)))
            else
              $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
            assert property (@(posedge clkb)
              enb && ~(|web) && $rose(wra) |-> !((addrb == addra_cap) && (|wea_cap && ~(|web))))
            else
              $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);

            assert property (@(posedge clka)
              ena && |wea && $rose(rdb_cap) |-> !((addra == addrb_rd_cap) && (|wea && ~(|web_cap))))
            else
              $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
            assert property (@(posedge clka)
              ena && ~(|wea) && $rose(wra) |-> !((addra == addrb_cap) && (~(|wea) && (|web_cap))))
            else
              $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
          end : col_unsafe

        end : gen_clocks
      end : gen_we_wide_b
    end : gen_wdw_sym

    // Port A write data is wider than port B write data
    else if (WRITE_DATA_WIDTH_A > WRITE_DATA_WIDTH_B) begin : gen_wdw_wide_a

      // Port A and port B use a common clock
      if (`COMMON_CLOCK) begin : gen_clock
        assert property (@(posedge clka)
          ena && enb |-> !((addra == addrb >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A) && |(wea & web)))
        else
          $warning("COLLISION: potential write-write collision to memory at time %0t (address location --> %0d); data outputs and memory content may be corrupted.", $time,addra);

        if (!`IS_COLLISION_SAFE) begin : col_unsafe
          assert property (@(posedge clka)
              ena && enb |-> !((addra == addrb) && (|wea && ~(|web))))
          else
            $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-A, Read happened through --> Port-B at address location %0d).", $time,addra);
          assert property (@(posedge clka)
            ena && enb |-> !((addra == addrb) && (~(|wea) && |web )))
          else
            $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-B, Read happened through --> Port-A at address location %0d).", $time,addrb);

        end : col_unsafe
       end : gen_clock

      // Port A and port B use independent clocks
      else if (`INDEPENDENT_CLOCKS) begin : gen_clocks
        assert property (@(posedge clkb)
          enb && |web && $rose(wra) |-> !((addra_cap == addrb >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A) && |(web & wea_cap)))
        else
          $warning("COLLISION: potential write-write collision to memory at port A address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
        assert property (@(posedge clka)
          ena && |wea && $rose(wrb) |-> !((addra == addrb_cap >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A) && |(wea & web_cap)))
        else
          $warning("COLLISION: potential write-write collision to memory at port B address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);

        if (!`IS_COLLISION_SAFE) begin : col_unsafe
          assert property (@(posedge clkb)
            enb && |web && $rose(rda_cap) |-> !((addra_rd_cap == addrb >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A) && (~(|wea_cap) && |web)))
          else
            $warning("COLLISION: potential write-read collision to memory at port A address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
          assert property (@(posedge clka)
            ena && |wea && $rose(rdb_cap) |-> !((addra == addrb_rd_cap >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A) && (|wea && ~(|web_cap))))
          else
            $warning("COLLISION: potential write-read collision to memory at port B address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);

          assert property (@(posedge clkb)
            enb && ~(|web) && $rose(wra) |-> !((addrb >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A == addra_cap) && (|wea_cap && ~(|web))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);

          assert property (@(posedge clka)
            ena && ~(|wea) && $rose(wra) |-> !((addra == addrb_cap >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A) && (~(|wea) && (|web_cap))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
        end : col_unsafe

      end : gen_clocks
    end : gen_wdw_wide_a

    // Port B write data is wider than port A write data
    else if (WRITE_DATA_WIDTH_B > WRITE_DATA_WIDTH_A) begin : gen_wdw_wide_b

      // Port A and port B use a common clock
      if (`COMMON_CLOCK) begin : gen_clock
        assert property (@(posedge clka)
          ena && enb |-> !((addrb == addra >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B) && |(wea & web)))
        else
          $warning("COLLISION: potential write-write collision to memory at time %0t (address location --> %0d); data outputs and memory content may be corrupted.", $time,addra);

        if (!`IS_COLLISION_SAFE) begin : col_unsafe
          assert property (@(posedge clka)
              ena && enb |-> !((addra == addrb) && (|wea && ~(|web))))
          else
            $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-A, Read happened through --> Port-B at address location %0d).", $time,addra);

          assert property (@(posedge clka)
            ena && enb |-> !((addra == addrb) && (~(|wea) && |web )))
          else
            $warning("COLLISION: potential write-read collision to memory at time %0t; data outputs and memory content may be corrupted (Write happened through --> Port-B, Read happened through --> Port-A at address location %0d).", $time,addrb);
        end : col_unsafe

       end : gen_clock

      // Port A and port B use independent clocks
      else if (`INDEPENDENT_CLOCKS) begin : gen_clocks
        assert property (@(posedge clkb)
          enb && |web && $rose(wra) |-> !((addrb == addra_cap >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B) && |(web & wea_cap)))
        else
          $warning("COLLISION: potential write-write collision to memory at port A address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
        assert property (@(posedge clka)
          ena && |wea && $rose(wrb) |-> !((addrb_cap == addra >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B) && |(wea & web_cap)))
        else
          $warning("COLLISION: potential write-write collision to memory at port B address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);

        if (!`IS_COLLISION_SAFE) begin : col_unsafe
          assert property (@(posedge clkb)
            enb && |web && $rose(rda_cap) |-> !((addrb == addra_rd_cap >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B) && (~(|wea_cap) && |web)))
          else
            $warning("COLLISION: potential write-read collision to memory at port A address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);
          assert property (@(posedge clka)
            ena && |wea && $rose(rdb_cap) |-> !((addrb_rd_cap == addra >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B) && (|wea && ~(|web_cap))))
          else
            $warning("COLLISION: potential write-read collision to memory at port B address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);

          assert property (@(posedge clkb)
            enb && ~(|web) && $rose(wra) |-> !((addrb == addra_cap >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B) && (|wea_cap && ~(|web))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addra_cap, $time);

          assert property (@(posedge clka)
            ena && ~(|wea) && $rose(wra) |-> !((addra >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B == addrb_cap) && (~(|wea) && (|web_cap))))
          else
            $warning("COLLISION: potential write-read collision to memory at address 0x%0h at time %0t; data outputs and memory content may be corrupted.", addrb_cap, $time);
        end : col_unsafe

      end : gen_clocks
    end : gen_wdw_wide_b
  end : gen_coll_msgs

////////////////////////////////////////////////////////////////////////////////////////////
// code is for Common clock and symmetric case
////////////////////////////////////////////////////////////////////////////////////////////
 if (`COMMON_CLOCK && (((WRITE_DATA_WIDTH_A == WRITE_DATA_WIDTH_B) && (WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_B) && (READ_DATA_WIDTH_A == WRITE_DATA_WIDTH_B) && `NO_ECC) || !`NO_ECC)) begin : sync_clk_sym 
 reg wr_wr_col = 0;
   always @(ena or enb or addra_i or addrb_i or wea or web or dina_i or dinb_i) begin
     if ((ena == 1'b1 && enb == 1'b1)) begin
       if (addra_i == addrb_i) begin
         if(|wea && |web) begin
           force dina_i  = {WRITE_DATA_WIDTH_A{1'bX}};
           force dinb_i  = {WRITE_DATA_WIDTH_B{1'bX}};
           wr_wr_col     <= 1'b1;
         end
         else begin
          release dina_i;
          release dinb_i;
          wr_wr_col     <= 1'b0;
         end
       end
       else begin
         release dina_i;
         release dinb_i;
         wr_wr_col     <= 1'b0;
       end
     end
     else begin
       release dina_i;
       release dinb_i;
       wr_wr_col     <= 1'b0;
     end
   end

   if (`MEM_PORTB_READ && !(`IS_COLLISION_SAFE)) begin : gen_rd_b_coll
     always @(posedge clka) begin
       if (enb == 1'b1) begin
         if (ena == 1'b1 && (addra_i == addrb_i)) begin
           if((|wea & ~(|web)) || wr_wr_col) begin
             if(READ_LATENCY_B == 1) begin
               force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
             end
             else begin
               #1ps force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
             end
           end
           else begin
             release gen_rd_b.doutb_reg;
           end
         end
         else begin
           release gen_rd_b.doutb_reg;
         end
       end
     end
   end : gen_rd_b_coll

   if (`MEM_PORTA_READ && !(`IS_COLLISION_SAFE)) begin : gen_rd_a_coll
      always @(posedge clka) begin
        if (ena == 1'b1) begin
          if (enb == 1'b1 && (addra_i == addrb_i)) begin
            if((~(|wea) & |web) || wr_wr_col)begin
              if (READ_LATENCY_A == 1) begin
                force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
              end
              else begin
                #1ps force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
              end
            end
            else begin
              release gen_rd_a.douta_reg;
            end
          end
          else begin
            release gen_rd_a.douta_reg;
          end
        end
      end
   end : gen_rd_a_coll
 end : sync_clk_sym
////////////////////////////////////////////////////////////////////////////////////////////
// code is for Common clock, Asymmetric case
////////////////////////////////////////////////////////////////////////////////////////////

 if (`COMMON_CLOCK && `NO_ECC && ((WRITE_DATA_WIDTH_A != WRITE_DATA_WIDTH_B) || (WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B) || (READ_DATA_WIDTH_A != WRITE_DATA_WIDTH_B))) begin : sync_clk_asym 
 reg wr_wr_col_asym = 0;
    always @(ena or enb or wea or web or addra_i or addrb_i) begin
     if (ena & enb) begin
       if(|wea && |web) begin
         if(WRITE_DATA_WIDTH_A > WRITE_DATA_WIDTH_B) begin
           if (addra_i == addrb_i >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A)
             begin
               wr_wr_col_asym  <= 1'b1;
             end
           else begin
             wr_wr_col_asym  <= 1'b0;
           end
         end
         else begin
           if (addrb_i == addra_i >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B)
             begin
               wr_wr_col_asym <= 1'b1;
             end
           else begin
             wr_wr_col_asym <= 1'b0;
           end
         end
       end
       else begin
         wr_wr_col_asym  <= 1'b0;
       end
     end 
     else
       wr_wr_col_asym  <= 1'b0;
    end

   // write-write collision modeling
   // 1. check if both ports are writing and the address is equal
   // 2. always allow the wider port to write to the memory
   // 3. write enable of the narrower port has to be forced to 0
   // 4. assert the status signal to indicate wr-wr collision
   // 5. <TBD> check if both ports are writing same data

   always @(ena or enb or wea or web or addra_i or addrb_i) begin
     if(ena & enb) begin
       if(|wea && |web) begin
         if(WRITE_DATA_WIDTH_A > WRITE_DATA_WIDTH_B) begin
           if (addra_i == addrb_i >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A)
             force dina_i = {WRITE_DATA_WIDTH_A{1'bX}};
           else
             release dina_i;
         end
       end
       else
         release dina_i;
     end
     else
       release dina_i;
   end

   always @(ena or enb or wea or web or addra_i or addrb_i) begin
     if(ena & enb) begin
       if(|wea && |web) begin
         if(WRITE_DATA_WIDTH_A < WRITE_DATA_WIDTH_B) begin
           if (addrb_i == addra_i >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B)
             force dinb_i = {WRITE_DATA_WIDTH_B{1'bX}};
           else
             release dinb_i;
         end
       end
       else
         release dinb_i;
     end
     else
       release dinb_i;
   end

   always @(ena or enb or wea or web or addra_i or addrb_i) begin
     if(ena & enb) begin
       if(|wea && |web) begin
         if(WRITE_DATA_WIDTH_A > WRITE_DATA_WIDTH_B) begin
           if (addra_i == addrb_i >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A)
             force web_i = 'b0;
           else
             release web_i;
         end
       end
       else
         release web_i;
     end
     else
       release web_i;
   end

   always @(ena or enb or wea or web or addra_i or addrb_i) begin
     if(ena & enb) begin
       if(|wea && |web) begin
         if(WRITE_DATA_WIDTH_A < WRITE_DATA_WIDTH_B) begin
           if (addrb_i == addra_i >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B)
             force wea_i = 'b0;
           else
             release wea_i;
         end
       end
       else
         release wea_i;
     end
     else
       release wea_i;
   end

   if (`MEM_PORTB_READ && !(`IS_COLLISION_SAFE)) begin : gen_rd_b_coll
     always @(posedge gen_rd_b.clkb_int) begin
       if (enb == 1'b1) begin
         if (ena == 1'b1) begin
           if((|wea && ~(|web)) || wr_wr_col_asym) begin
             if(WRITE_DATA_WIDTH_A > READ_DATA_WIDTH_B) begin
               if (addra_i == addrb_i >> P_WIDTH_ADDR_READ_B-P_WIDTH_ADDR_WRITE_A) begin
                 if (READ_LATENCY_B == 1)
                   force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
                 else
                   #1ps force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
               end    
               else
                 release gen_rd_b.doutb_reg;
             end
             else begin
               if (addrb_i == addra_i >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_READ_B) begin
                 if (READ_LATENCY_B == 1)
                   force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
                 else
                   #1ps force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
               end
               else
                 release gen_rd_b.doutb_reg;
             end
           end
           else
             release gen_rd_b.doutb_reg; // write enable condition fails
         end
         else
           release gen_rd_b.doutb_reg; // ena is 0
       end
     end
   end : gen_rd_b_coll

   if (`MEM_PORTA_READ && !(`IS_COLLISION_SAFE)) begin : gen_rd_a_coll
     always @(posedge clka) begin
       if (ena == 1'b1) begin
         if (enb == 1'b1) begin
           if((~(|wea) && |web) || wr_wr_col_asym) begin
             if(READ_DATA_WIDTH_A > WRITE_DATA_WIDTH_B) begin
               if (addra_i == addrb_i >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_READ_A) begin
                 if (READ_LATENCY_A == 1)
                   force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
                 else
                   #1ps force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
               end
               else
                 release gen_rd_a.douta_reg;
             end
             else begin
               if (addrb_i == addra_i >> P_WIDTH_ADDR_READ_A-P_WIDTH_ADDR_WRITE_B) begin
                 if(READ_LATENCY_A == 1)
                   force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
                 else
                   #1ps force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
               end
               else
                 release gen_rd_a.douta_reg;
             end
          end
          else
            release gen_rd_a.douta_reg;
        end
        else
          release gen_rd_a.douta_reg;
      end
    end
  end : gen_rd_a_coll

end : sync_clk_asym

////////////////////////////////////////////////////////////////////////////////////////////
// code is for Independant clock, symmetric case
////////////////////////////////////////////////////////////////////////////////////////////
 if (`INDEPENDENT_CLOCKS && (((WRITE_DATA_WIDTH_A == WRITE_DATA_WIDTH_B) && (WRITE_DATA_WIDTH_A == READ_DATA_WIDTH_B) && (READ_DATA_WIDTH_A == WRITE_DATA_WIDTH_B) && `NO_ECC) || !`NO_ECC)) begin : async_clk_sym
 reg wr_wr_col_asym_a = 0;
 reg wr_wr_col_asym_b = 0;
 
  always @(ena or enb or wea or web or addra_i or addrb_i or wra or wrb or addra_cap or addrb_cap or col_win_wr_b or col_win_wr_a or dinb_i or dina_i)
    begin
      if(enb == 1'b1) begin
        if(wra == 1'b1 && addrb_i == addra_cap && col_win_wr_a) begin
          if(|web) begin
            force dinb_i = {WRITE_DATA_WIDTH_B{1'bX}};
            wr_wr_col_asym_b <= 1'b1;
          end
          else begin
            release dinb_i;
            wr_wr_col_asym_b <= 1'b0;
          end
        end
        else begin
          release dinb_i;
          wr_wr_col_asym_b <= 1'b0;
        end
      end 
      else begin
        release dinb_i;
        wr_wr_col_asym_b <= 1'b0;
      end
    end
  always @(ena or enb or wea or web or addra_i or addrb_i or wra or wrb or addra_cap or addrb_cap or col_win_wr_b or col_win_wr_a or dinb_i or dina_i)
    begin
      if(ena == 1'b1) begin
        if(wrb == 1'b1 && addra_i == addrb_cap && col_win_wr_b) begin
          if(|wea) begin
            force dina_i = {WRITE_DATA_WIDTH_A{1'bX}};
            wr_wr_col_asym_a <= 1'b1;
          end
          else begin
            release dina_i;
            wr_wr_col_asym_a <= 1'b0;
          end
        end
        else begin
          release dina_i;
          wr_wr_col_asym_a <= 1'b0;
        end
      end
      else begin
        release dina_i;
        wr_wr_col_asym_a <= 1'b0;
      end
    end
 
    if (`MEM_PORTB_READ && !(`IS_COLLISION_SAFE)) begin : gen_rd_b_coll
      always @(posedge gen_rd_b.clkb_int) begin
        if (enb == 1'b1) begin
          if ( (wra == 1'b1 && addrb_i == addra_cap && ~(|web) && col_win_wr_a ) || (wr_wr_col_asym_a | wr_wr_col_asym_b)) begin
            if(READ_LATENCY_B == 1) begin
              force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};

            end
            else begin
              #1ps force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};

            end
          end
          else begin
            release gen_rd_b.doutb_reg;

          end
        end      
      end
    end : gen_rd_b_coll

   if (`MEM_PORTA_READ && !(`IS_COLLISION_SAFE)) begin : gen_rd_a_coll
     always @(posedge clka) begin
       if (ena == 1'b1) begin
         if ( ((wrb == 1'b1 && addra_i == addrb_cap && ~(|wea) && col_win_wr_b) || (wr_wr_col_asym_a | wr_wr_col_asym_b))) begin
           if(READ_LATENCY_A == 1)
             force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
           else
             #1ps force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
         end
         else
           release gen_rd_a.douta_reg;
       end
     end
   end : gen_rd_a_coll

 end : async_clk_sym

////////////////////////////////////////////////////////////////////////////////////////////
// code is for Independant clock, Asymmetric case
////////////////////////////////////////////////////////////////////////////////////////////

 if (`INDEPENDENT_CLOCKS && `NO_ECC && ((WRITE_DATA_WIDTH_A != WRITE_DATA_WIDTH_B) && (WRITE_DATA_WIDTH_A != READ_DATA_WIDTH_B) && (READ_DATA_WIDTH_A != WRITE_DATA_WIDTH_B))) begin : async_clk_asym
 reg wr_wr_col_asym_a = 0;
 reg wr_wr_col_asym_b = 0;

   always @(ena or enb or wra or wrb or addra_i or addrb_i or addra_cap or addrb_cap or wea or web or col_win_wr_b or col_win_wr_a or dina_i or dinb_i) begin
     if (ena == 1'b1) begin
       if(wrb == 1'b1) begin
         if(WRITE_DATA_WIDTH_A > WRITE_DATA_WIDTH_B) begin
           if (addra_i == addrb_cap >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A)  begin
             if(|wea && col_win_wr_b) begin
               force dina_i = {WRITE_DATA_WIDTH_A{1'bX}};
               wr_wr_col_asym_a <= 1'b1;
             end
             else begin
               release dina_i;
               wr_wr_col_asym_a <= 1'b0;
             end
           end
           else begin
             release dina_i;
             wr_wr_col_asym_a <= 1'b0;
           end
         end
         else begin
           if (addrb_cap == addra_i >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B)  begin
             if(|wea && col_win_wr_b) begin
               force dina_i = {WRITE_DATA_WIDTH_A{1'bX}};
               wr_wr_col_asym_a <= 1'b1;
             end
             else begin
               release dina_i;
               wr_wr_col_asym_a <= 1'b0;
             end
           end
           else begin
             release dina_i;
             wr_wr_col_asym_a <= 1'b0;
           end
         end
       end
       else begin
         release dina_i;
         wr_wr_col_asym_a <= 1'b0;
       end
     end
     else begin
       release dina_i;   
       wr_wr_col_asym_a <= 1'b0;
     end
   end

   always @(ena or enb or wra or wrb or addra_i or addrb_i or addra_cap or addrb_cap or wea or web or col_win_wr_b or col_win_wr_a or dina_i or dinb_i) begin
     if (enb == 1'b1) begin
       if(wra == 1'b1) begin
         if(WRITE_DATA_WIDTH_A > WRITE_DATA_WIDTH_B) begin
           if (addra_cap == addrb_i >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_WRITE_A)  begin
             if(|web && col_win_wr_a) begin
               force dinb_i = {WRITE_DATA_WIDTH_B{1'bX}};
               wr_wr_col_asym_b <= 1'b1;
             end
             else begin
               release dinb_i;
               wr_wr_col_asym_b <= 1'b0;
             end
           end
           else begin
             release dinb_i;
             wr_wr_col_asym_b <= 1'b0;
           end
         end
         else begin
           if (addrb_i == addra_cap >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_WRITE_B)  begin
             if(|web && col_win_wr_a) begin
               force dinb_i = {WRITE_DATA_WIDTH_B{1'bX}};
               wr_wr_col_asym_b <= 1'b1;
             end
             else begin
               release dinb_i;
               wr_wr_col_asym_b <= 1'b0;
             end
           end
           else begin
             release dinb_i;
             wr_wr_col_asym_b <= 1'b0;
           end
         end
       end
       else begin
         release dinb_i;
         wr_wr_col_asym_b <= 1'b0;
       end
     end
     else begin
       release dinb_i;  
       wr_wr_col_asym_b <= 1'b0;
     end
   end

// As Assymetry Internal to port is not allowed, Limiting the comparision to
// across ports (WRITE_DATA_WIDTH_A = READ_DATA_WIDTH_A and READ_DATA_WIDTH_B = WRITE_DATA_WIDTH_B)
 if (`MEM_PORTA_READ && !(`IS_COLLISION_SAFE)) begin : gen_rd_a_coll
   always @(posedge clka) begin
     if (ena == 1'b1 ) begin
       if(wrb == 1'b1 && ~(|wea)) begin
         if(READ_DATA_WIDTH_A > WRITE_DATA_WIDTH_B) begin
           if ((addra_i == addrb_cap >> P_WIDTH_ADDR_WRITE_B-P_WIDTH_ADDR_READ_A && col_win_wr_b) || (wr_wr_col_asym_a | wr_wr_col_asym_b)) begin
             if (READ_LATENCY_A == 1)
               force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
             else
               #1ps force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
           end
           else
             release gen_rd_a.douta_reg;
         end
         else begin
           if ((addrb_cap == addra_i >> P_WIDTH_ADDR_READ_A-P_WIDTH_ADDR_WRITE_B && col_win_wr_b) || (wr_wr_col_asym_a | wr_wr_col_asym_b)) begin
             if (READ_LATENCY_A == 1)
               force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
             else
               #1ps force gen_rd_a.douta_reg = {READ_DATA_WIDTH_A{1'bX}};
           end
           else
             release gen_rd_a.douta_reg;
         end
       end
       else
         release gen_rd_a.douta_reg;
     end
   end
 end : gen_rd_a_coll

 if (`MEM_PORTB_READ && !(`IS_COLLISION_SAFE)) begin : gen_rd_b_coll
   always @(posedge clkb) begin
     if (enb == 1'b1) begin
       if( wra == 1'b1 && ~(|web) ) begin
         if(WRITE_DATA_WIDTH_A > READ_DATA_WIDTH_B) begin
           if ((addra_cap == addrb_i >> P_WIDTH_ADDR_READ_B-P_WIDTH_ADDR_WRITE_A && col_win_wr_a) || (wr_wr_col_asym_a | wr_wr_col_asym_b)) begin
             if(READ_LATENCY_B == 1)
               force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
             else
               #1ps force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
           end
           else
             release gen_rd_b.doutb_reg;
         end
         else begin
           if ((addrb_i == addra_cap >> P_WIDTH_ADDR_WRITE_A-P_WIDTH_ADDR_READ_B && col_win_wr_a) || (wr_wr_col_asym_a | wr_wr_col_asym_b)) begin
             if(READ_LATENCY_B == 1)
               force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
             else
               #1ps force gen_rd_b.doutb_reg = {READ_DATA_WIDTH_B{1'bX}};
           end
           else
             release gen_rd_b.doutb_reg;
         end
       end
       else
         release gen_rd_b.doutb_reg;
     end
   end
  end : gen_rd_b_coll
 end : async_clk_asym
end : gen_assert_coll_ww

`endif

// Sleep Mode behaviour Model

if (`SLEEP_MODE && !`MEM_AUTO_SLP_EN) begin : gen_dyn_power_saving_mode

////////////////////////////////////////////////////////////////////////////////
    //     Wakeup_time modeling    //
    // SLEEP      ---     2 clocks //
//////////////////////////////////////////////////////////////////////////////// 

  reg [9:0] sleep_edg_det_a;
  wire de_activate_slp_mode_a; //falling edge of sleep port + wakeup_time w.r.to Port-A clock

// Initialize the variables 
  initial begin 
      sleep_edg_det_a = 'b0;
      sleep_int_a = 1'b0;
     end
// Shift register to continuously monitor the transitions on sleep port
  always @(posedge clka) begin :  sleep_sync_clka
   sleep_edg_det_a <= {sleep_edg_det_a[8:0],sleep}; 
  end : sleep_sync_clka

// Sleep Falling edge detection
  if (`SLEEP_MODE) 
    assign de_activate_slp_mode_a = (sleep_edg_det_a[2:0] == 3'b100)? 1'b1 : 1'b0;
  else
    assign de_activate_slp_mode_a = 1'b1;

// Generate the Active sleep duration including the wake up time
  always @(*)
    begin
      if(sleep == 1'b1)
        sleep_int_a = 1'b1;
      else if(de_activate_slp_mode_a == 1'b1)
        #2 sleep_int_a = 1'b0;
    end

// Check if port-A write is allowed
if (`MEM_PORTA_WRITE ) begin : gen_dyn_pwr_save_wr_a  
  // ignore write operation during sleep mode  
  always @(sleep_int_a or sleep_int_b)
    begin : proc_force_dina
      if (sleep_int_a == 1'b1 || sleep_int_b == 1'b1)
        force mem = mem; // mem array is un-changed
      else
        release mem;
    end : proc_force_dina
  // Assertion to detect the write operation during sleep mode
  assert property (@(posedge clka)
    ~(sleep_int_a === 1'b1 && ena === 1'b1 && |wea))
 else
      $warning("WRITE on Port A attempted while in SLEEP mode at time %t", $time);
end : gen_dyn_pwr_save_wr_a

// Check if Read on Port-A is allowed
if (`MEM_PORTA_READ ) begin : gen_dyn_pwr_save_rd_a
  // Assertion to detect the read operation during sleep mode
  assert property (@(posedge clka)
    ~(sleep_int_a === 1'b1 && ena === 1'b1 && ~(|wea) ))
 else
      $warning("READ on Port A attempted while in SLEEP mode at time %t", $time);

// When in Latch Mode
   if (`MEM_PORTA_RD_REG) begin : gen_sleep_a_latch_mode
     always @(posedge clka) begin : pwr_sav_mode_rd_det_a
       if (sleep_int_a == 1'b1 || sleep_int_b == 1'b1) begin
         if (ena == 1'b1 ) begin
           if (`MEM_PORTA_WF) begin
             if(|wea)
               force douta = {READ_DATA_WIDTH_A{1'bx}};
             else
               force douta = {READ_DATA_WIDTH_A{1'bx}}; end
           else if (`MEM_PORTA_RF)
             force douta = {READ_DATA_WIDTH_A{1'bx}};
           else begin
             if(|wea)
               force douta = douta;
             else
               force douta = {READ_DATA_WIDTH_A{1'bx}};
           end
         end
       end
       else begin
         if(`MEM_PORTA_NC) begin
           if(~(|wea) & ena)
             release douta;
         end
         else begin
           if(ena)
             release douta;
         end
       end
     end : pwr_sav_mode_rd_det_a
   end : gen_sleep_a_latch_mode

// If pipe line stages are enabled
   if (`MEM_PORTA_RD_PIPE) begin : gen_sleep_a_reg_mode
      reg ena_pipe_sleep   [READ_LATENCY_A-2:0];
      reg ena_pipe_dup     [READ_LATENCY_A-2:0];
      reg wea_pipe_sleep   [READ_LATENCY_A-2:0];
      reg wea_pipe_dup     [READ_LATENCY_A-2:0];
   // Capture the READ operations during and after sleep modes
     always @(posedge clka) begin
        if(sleep_int_a == 1'b1 || sleep_int_b == 1'b1) begin
          ena_pipe_sleep[0] <= ena;  // Capture all READ operations during sleep
          ena_pipe_dup[0]   <= 1'b0; 
          wea_pipe_sleep[0] <= |wea; // Capture all WRITE operations during sleep
          wea_pipe_dup[0]   <= 1'b0;   
        end
        else begin
          ena_pipe_sleep[0] <= 1'b0;
          ena_pipe_dup[0]   <= ena;  // Capture All valid READ Operations
          wea_pipe_sleep[0] <= 1'b0;
          wea_pipe_dup[0]   <= |wea; // Capture All valid WRITE Operations   
        end
      end

   // If more than two stages are used, loops generate all pipeline stages except the first and last
      if (READ_LATENCY_A > 2) begin : porta_slp_gen_estages
        for (genvar slp_estage=1; slp_estage<READ_LATENCY_A-1; slp_estage=slp_estage+1) begin : porta_gen_slp_epipe
          always @(posedge clka) begin
            ena_pipe_sleep[slp_estage] <= ena_pipe_sleep[slp_estage-1];
            ena_pipe_dup[slp_estage]   <= ena_pipe_dup[slp_estage-1];
            wea_pipe_sleep[slp_estage] <= wea_pipe_sleep[slp_estage-1];          
            wea_pipe_dup[slp_estage]   <= wea_pipe_dup[slp_estage-1];          
          end
        end : porta_gen_slp_epipe
      end : porta_slp_gen_estages
  
  // Flag asserts when the Read during sleep arrives to the last pipeline stage
  // and de-asserts when the valid read arrives to the last pipeline stage
    reg last_pipe_en_ctrl_a;
    reg rda_happened;
    initial begin
      last_pipe_en_ctrl_a = 1'b0;
      rda_happened = 1'b0;
    end

    always @(*)
      begin
        if (ena_pipe_sleep[READ_LATENCY_A-2]) begin
          last_pipe_en_ctrl_a = 1'b1;
          if(~wea_pipe_sleep[READ_LATENCY_A-2])
            rda_happened = 1'b1;
        end
        else if(ena_pipe_dup[READ_LATENCY_A-2]) begin
          last_pipe_en_ctrl_a = 1'b0;
          rda_happened = 1'b0;
        end
      end

  // If READ_LATENCY_A > 2
  // Force DOUT depending on the latency and the WRITE_MODE
   if ( READ_LATENCY_A >= 2) begin : gen_sleep_porta_highr_Latncy
     always @(posedge clka) begin : sleep_porta_rd_highr_Latncy_force
       if (last_pipe_en_ctrl_a && regcea) begin 
         if (`MEM_PORTA_WF) begin
           force douta = {READ_DATA_WIDTH_A{1'bx}};
         end
         else if (`MEM_PORTA_RF)
           force douta = {READ_DATA_WIDTH_A{1'bx}};
         else begin
           if(rda_happened)
             force douta = {READ_DATA_WIDTH_A{1'bx}};
           else if(ena_pipe_sleep[READ_LATENCY_A-2] & wea_pipe_sleep[READ_LATENCY_A-2])
             force douta = douta;
         end
       end
     end : sleep_porta_rd_highr_Latncy_force

     always @(posedge clka) begin : sleep_porta_rd_highr_Latncy_release
       if(~last_pipe_en_ctrl_a)  begin
         // when all the reads of sleep are over, check if there is a
         // valid regcea and pipe lined enable (not sleep enable)
         if (rsta) release douta;
         else begin
           if (regcea) begin
             if(`MEM_PORTA_NC) begin
               if(!wea_pipe_dup[READ_LATENCY_A-2] && ena_pipe_dup[READ_LATENCY_A-2])
                 release douta;
             end
             else // not No_change     
               release douta;    
           end // release when there is a valid READ
         end
       end
     end : sleep_porta_rd_highr_Latncy_release   
    end : gen_sleep_porta_highr_Latncy
  end : gen_sleep_a_reg_mode
end : gen_dyn_pwr_save_rd_a

if (`MEM_PORTB_READ ) begin : gen_dyn_pwr_save_b
// Internal Signal Declarations    
    reg [9:0] sleep_edg_det_b;
    reg de_activate_slp_mode_b; //falling edge of sleep port + wakeup_time w.r.to Port-B clock

// Initialize all the internal signals
  initial begin 
      sleep_int_b = 1'b0; 
      sleep_edg_det_b = 'b0;
  end

 //Effective Sleep Mode Duration identification
  always @(posedge gen_rd_b.clkb_int)
    begin :  sleep_sync_clkb
   sleep_edg_det_b <= {sleep_edg_det_b[8:0],sleep}; 
  end : sleep_sync_clkb
 
  if (`SLEEP_MODE)
    assign de_activate_slp_mode_b = (sleep_edg_det_b[2:0] == 3'b100)? 1'b1 : 1'b0;
  else
    assign de_activate_slp_mode_b = 1'b1;
  
  always @(*)
    begin
      if(sleep == 1'b1)
        sleep_int_b = 1'b1;
      else if(de_activate_slp_mode_b == 1'b1)
        #2 sleep_int_b = 1'b0;     
    end

// Check if Port-B write is allowed
  if (`MEM_PORTB_WRITE ) begin : gen_dyn_pwr_save_wr_b
  // Assertions to detect the READ and WRITE operations during sleep mode
    assert property (@(posedge gen_rd_b.clkb_int)
      ~(sleep_int_b === 1'b1 && enb === 1'b1 && |web))
    else    
      $warning("WRITE on Port B attempted while in SLEEP mode at time %t", $time);  
  end : gen_dyn_pwr_save_wr_b

  assert property (@(posedge gen_rd_b.clkb_int)
    ~(sleep_int_b === 1'b1 && enb === 1'b1 && ~(|web)))
  else    
    $warning("READ on Port B attempted while in SLEEP mode at time %t", $time);  
// Forcing DOUTB when in latch mode  
  if (`MEM_PORTB_RD_REG) begin : gen_sleep_b_latch_mode

    always @(posedge gen_rd_b.clkb_int) begin : pwr_sav_mode_rd_det_b
      if (sleep_int_a == 1'b1 || sleep_int_b == 1'b1) begin
        if (enb == 1'b1 ) begin
          if (`MEM_PORTB_WF) begin
            if(|web)
              force doutb = {READ_DATA_WIDTH_B{1'bx}};
            else
              force doutb = {READ_DATA_WIDTH_B{1'bx}}; end
          else if (`MEM_PORTB_RF)
            force doutb = {READ_DATA_WIDTH_B{1'bx}};
          else begin
            if(|web)
              force doutb = doutb;
            else
              force doutb = {READ_DATA_WIDTH_B{1'bx}};
          end
        end
      end
      else begin
        if(`MEM_PORTB_NC) begin
          if(~(|web) & enb)
            release doutb;
        end
        else begin
          if(enb)
            release doutb;
        end
      end
     end : pwr_sav_mode_rd_det_b
   end : gen_sleep_b_latch_mode

  if (`MEM_PORTB_RD_PIPE) begin :  gen_sleep_b_reg_mode
      // Internal Signal Declaration
      reg enb_pipe_sleep   [READ_LATENCY_B-2:0];    
      reg enb_pipe_dup     [READ_LATENCY_B-2:0];
      reg web_pipe_sleep   [READ_LATENCY_B-2:0];
      reg web_pipe_dup     [READ_LATENCY_B-2:0];
      
      always @(posedge gen_rd_b.clkb_int) begin
        if(sleep_int_a === 1'b1 || sleep_int_b === 1'b1)
          begin
            enb_pipe_sleep[0] <= enb;  // Capture all READ operations during sleep
            enb_pipe_dup[0]   <= 1'b0;
            web_pipe_sleep[0] <= |web; // Capture all WRITE operations during sleep         
            web_pipe_dup[0]   <= 1'b0;          
        end 
        else
          begin
            enb_pipe_sleep[0] <= 1'b0;
            enb_pipe_dup[0]   <= enb;  // Capture All valid READ Operations
            web_pipe_sleep[0] <= 1'b0;
            web_pipe_dup[0]   <= |web; // Capture All valid WRITE Operations  
          end
       end

  // If more than two stages are used, loops generate all pipeline stages except the first and last
      if (READ_LATENCY_B > 2) begin : portb_slp_gen_estages
        for (genvar portb_slp_estage=1; portb_slp_estage<READ_LATENCY_B-1; portb_slp_estage=portb_slp_estage+1) begin : portb_gen_slp_epipe
          always @(posedge gen_rd_b.clkb_int) begin
            enb_pipe_sleep[portb_slp_estage] <= enb_pipe_sleep[portb_slp_estage-1];
            enb_pipe_dup[portb_slp_estage]   <= enb_pipe_dup[portb_slp_estage-1];
            web_pipe_sleep[portb_slp_estage] <= web_pipe_sleep[portb_slp_estage-1];    
            web_pipe_dup[portb_slp_estage]   <= web_pipe_dup[portb_slp_estage-1];    
          end
        end : portb_gen_slp_epipe
      end : portb_slp_gen_estages
   
    reg last_pipe_en_ctrl_b;
    reg rdb_happened;
    initial begin
      last_pipe_en_ctrl_b = 1'b0;
      rdb_happened = 1'b0;
    end

    always @(*)
      begin
        if (enb_pipe_sleep[READ_LATENCY_B-2]) begin
          last_pipe_en_ctrl_b = 1'b1;
          if(~web_pipe_sleep[READ_LATENCY_B-2])
            rdb_happened = 1'b1;
        end
        else if(enb_pipe_dup[READ_LATENCY_B-2]) begin
          last_pipe_en_ctrl_b = 1'b0;
          rdb_happened = 1'b0;
        end
      end

// Forcing DOUTB depending on the READ latency and WRITE_MODE
    if ( READ_LATENCY_B >= 2) begin : gen_sleep_portb_highr_Latncy
      always @(posedge gen_rd_b.clkb_int) begin : sleep_portb_rd_highr_Latncy_force     
        if(last_pipe_en_ctrl_b && regceb) begin 
          if (`MEM_PORTB_WF) begin
            force doutb = {READ_DATA_WIDTH_B{1'bx}};
          end
          else if (`MEM_PORTB_RF)
            force doutb = {READ_DATA_WIDTH_B{1'bx}};
          else begin
            if(rdb_happened)
              force doutb = {READ_DATA_WIDTH_B{1'bx}};
            else if(enb_pipe_sleep[READ_LATENCY_B-2] & web_pipe_sleep[READ_LATENCY_B-2])
              force doutb = doutb;
          end
        end 
      end : sleep_portb_rd_highr_Latncy_force

      always @(posedge gen_rd_b.clkb_int) begin : sleep_portb_rd_highr_Latncy_release     
        if (~last_pipe_en_ctrl_b)  begin
          // when all the reads of sleep are over, check if there is a
          // valid regceb and pipe lined enable (not sleep enable)
          if (rstb) release doutb;
          else begin
            if (regceb) begin
              if(`MEM_PORTB_NC) begin
                if(!web_pipe_dup[READ_LATENCY_B-2] && enb_pipe_dup[READ_LATENCY_B-2])
                  release doutb;
              end
              else // not No_change     
                release doutb;    
            end // release when there is a valid READ
          end
        end
      end : sleep_portb_rd_highr_Latncy_release
    end : gen_sleep_portb_highr_Latncy
  end : gen_sleep_b_reg_mode
end : gen_dyn_pwr_save_b

end : gen_dyn_power_saving_mode

  if(`MEM_AUTO_SLP_EN) begin : gen_auto_slp_dly_sim
    reg [ADDR_WIDTH_A-1:0] addra_aslp_pipe_sim [AUTO_SLEEP_TIME-1:0];
    reg [ADDR_WIDTH_B-1:0] addrb_aslp_pipe_sim [AUTO_SLEEP_TIME-1:0];
    // Initialize the address pipeline
    initial begin
      integer initstage_a;
      integer initstage_b;
      for (initstage_a=0; initstage_a<AUTO_SLEEP_TIME; initstage_a=initstage_a+1) begin : for_addra_pipe_init
        addra_aslp_pipe_sim[initstage_a] = {ADDR_WIDTH_A{1'b0}};
      end : for_addra_pipe_init
      for (initstage_b=0; initstage_b<AUTO_SLEEP_TIME; initstage_b=initstage_b+1) begin : for_addrb_pipe_init
        addrb_aslp_pipe_sim[initstage_b] = {ADDR_WIDTH_B{1'b0}};
      end : for_addrb_pipe_init
    end

    // port-a complete address delays for simulation
    always @(posedge clka) begin
      addra_aslp_pipe_sim[0]  <= addra;
    end
    for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe_a
      always @(posedge clka) begin
        addra_aslp_pipe_sim[aslp_stage] <= addra_aslp_pipe_sim[aslp_stage-1];
      end
    end : gen_aslp_inp_pipe_a
    assign addra_aslp_sim= addra_aslp_pipe_sim[AUTO_SLEEP_TIME-1];
    
    if (`MEM_PORTB_READ ) begin : gen_addrb_sim_dly
      // port-b complete address delays for simulation
      always @(posedge gen_rd_b.clkb_int) begin
        addrb_aslp_pipe_sim[0]  <= addrb;
      end
      for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe_b
        always @(posedge gen_rd_b.clkb_int) begin
          addrb_aslp_pipe_sim[aslp_stage] <= addrb_aslp_pipe_sim[aslp_stage-1];
        end
      end : gen_aslp_inp_pipe_b
      assign  addrb_aslp_sim= addrb_aslp_pipe_sim[AUTO_SLEEP_TIME-1];
    end : gen_addrb_sim_dly
    if(`MEM_PORTA_WRITE && (`BOTH_ENC_DEC || `ENC_ONLY)) begin : gen_aslp_inj_err_a_sim
      // Force the error injection signals
      assign injectsbiterra_sim = gen_wr_a.err_inj_ecc.gen_aslp_dly_inj_err.injsbiterra_aslp_pipe[AUTO_SLEEP_TIME-1];
      assign injectdbiterra_sim = gen_wr_a.err_inj_ecc.gen_aslp_dly_inj_err.injdbiterra_aslp_pipe[AUTO_SLEEP_TIME-1];
    end : gen_aslp_inj_err_a_sim
    else begin : gen_aslp_no_inj_err_a_sim
      assign injectsbiterra_sim = 1'b0; 
      assign injectdbiterra_sim = 1'b0; 
    end : gen_aslp_no_inj_err_a_sim

    if(`MEM_PORTB_WRITE && `MEM_PRIM_ULTRA && (`BOTH_ENC_DEC || `ENC_ONLY)) begin : gen_aslp_inj_err_b_sim
      // Force the error injection signals
      assign injectsbiterrb_sim = gen_wr_b.err_inj_ecc.gen_aslp_dly_inj_err.injsbiterrb_aslp_pipe[AUTO_SLEEP_TIME-1];
      assign injectdbiterrb_sim = gen_wr_b.err_inj_ecc.gen_aslp_dly_inj_err.injdbiterrb_aslp_pipe[AUTO_SLEEP_TIME-1];
    end : gen_aslp_inj_err_b_sim
    else begin : gen_aslp_no_inj_err_b_sim
      assign injectsbiterrb_sim = 1'b0; 
      assign injectdbiterrb_sim = 1'b0; 
    end : gen_aslp_no_inj_err_b_sim

  end : gen_auto_slp_dly_sim
  else begin : gen_nauto_slp_dly_sim
    assign  addra_aslp_sim = addra;
    assign  addrb_aslp_sim = addrb;
    assign  injectsbiterra_sim = injectsbiterra;
    assign  injectdbiterra_sim = injectdbiterra;
    assign  injectsbiterrb_sim = injectsbiterrb;
    assign  injectdbiterrb_sim = injectdbiterrb;
  end : gen_nauto_slp_dly_sim

// -------------------------------------------------------------------------------------------------------------------
// ecc behavioral modeling
// -------------------------------------------------------------------------------------------------------------------
  // ecc behavioral modeling has to be done for the below 3 cases
  // 1. when both encoder and decoder are enabled
  // 2. when ecc encoder is enabled alone
  // 3. when ecc decoder is enabled alone

// -------------------------------------------------------------------------------------------------------------------
  /**ECC Behavioral Modeling when both Encoder and Decoder are enabled
   This module need not code the parity calculations for encoding and decoding????
   This module needs to model the Error Injection (data input and output
   are expected to be multiple of 64 bits)
  **/
// -------------------------------------------------------------------------------------------------------------------
  if (ECC_MODE != 0) begin : ecc_behav_logic
    localparam integer P_MIN_WIDTH_PARITY_ECC  = (ECC_MODE == 3 && `NO_MEMORY_INIT) ? P_MIN_WIDTH_DATA : (ECC_MODE == 2) ? WRITE_DATA_WIDTH_A : P_MIN_WIDTH_DATA+((WRITE_DATA_WIDTH_A/64)*8);
    // Memory Array Declaration for ECC 
    reg [P_MIN_WIDTH_PARITY_ECC-1:0] mem_ecc [0:P_MAX_DEPTH_DATA-1];
    reg [READ_DATA_WIDTH_A-1:0] douta_int = 0;
    reg [READ_DATA_WIDTH_B-1:0] doutb_int = 0;
    reg sbiterra_int;
    reg dbiterra_int;
    reg sbiterrb_int;
    reg dbiterrb_int;
    
    function [7:0] fn_ecc_enc_dec (
       input encode,
       input [63:0] d_i,
       input [7:0] dp_i
       );
       reg ecc_7;
    begin
       fn_ecc_enc_dec[0] = d_i[0]   ^  d_i[1]   ^  d_i[3]   ^  d_i[4]   ^  d_i[6]   ^
                   d_i[8]   ^  d_i[10]  ^  d_i[11]  ^  d_i[13]  ^  d_i[15]  ^
                   d_i[17]  ^  d_i[19]  ^  d_i[21]  ^  d_i[23]  ^  d_i[25]  ^
                   d_i[26]  ^  d_i[28]  ^  d_i[30]  ^  d_i[32]  ^  d_i[34]  ^
                   d_i[36]  ^  d_i[38]  ^  d_i[40]  ^  d_i[42]  ^  d_i[44]  ^
                   d_i[46]  ^  d_i[48]  ^  d_i[50]  ^  d_i[52]  ^  d_i[54]  ^
                   d_i[56]  ^  d_i[57]  ^  d_i[59]  ^  d_i[61]  ^  d_i[63];
    
       fn_ecc_enc_dec[1] = d_i[0]   ^  d_i[2]   ^  d_i[3]   ^  d_i[5]   ^  d_i[6]   ^
                   d_i[9]   ^  d_i[10]  ^  d_i[12]  ^  d_i[13]  ^  d_i[16]  ^
                   d_i[17]  ^  d_i[20]  ^  d_i[21]  ^  d_i[24]  ^  d_i[25]  ^
                   d_i[27]  ^  d_i[28]  ^  d_i[31]  ^  d_i[32]  ^  d_i[35]  ^
                   d_i[36]  ^  d_i[39]  ^  d_i[40]  ^  d_i[43]  ^  d_i[44]  ^
                   d_i[47]  ^  d_i[48]  ^  d_i[51]  ^  d_i[52]  ^  d_i[55]  ^
                   d_i[56]  ^  d_i[58]  ^  d_i[59]  ^  d_i[62]  ^  d_i[63];
    
       fn_ecc_enc_dec[2] = d_i[1]   ^  d_i[2]   ^  d_i[3]   ^  d_i[7]   ^  d_i[8]   ^
                   d_i[9]   ^  d_i[10]  ^  d_i[14]  ^  d_i[15]  ^  d_i[16]  ^
                   d_i[17]  ^  d_i[22]  ^  d_i[23]  ^  d_i[24]  ^  d_i[25]  ^
                   d_i[29]  ^  d_i[30]  ^  d_i[31]  ^  d_i[32]  ^  d_i[37]  ^
                   d_i[38]  ^  d_i[39]  ^  d_i[40]  ^  d_i[45]  ^  d_i[46]  ^
                   d_i[47]  ^  d_i[48]  ^  d_i[53]  ^  d_i[54]  ^  d_i[55]  ^
                   d_i[56]  ^  d_i[60]  ^  d_i[61]  ^  d_i[62]  ^  d_i[63];
    
       fn_ecc_enc_dec[3] = d_i[4]   ^  d_i[5]   ^  d_i[6]   ^  d_i[7]   ^  d_i[8]   ^
                   d_i[9]   ^  d_i[10]  ^  d_i[18]  ^  d_i[19]  ^  d_i[20]  ^
                   d_i[21]  ^  d_i[22]  ^  d_i[23]  ^  d_i[24]  ^  d_i[25]  ^
                   d_i[33]  ^  d_i[34]  ^  d_i[35]  ^  d_i[36]  ^  d_i[37]  ^
                   d_i[38]  ^  d_i[39]  ^  d_i[40]  ^  d_i[49]  ^  d_i[50]  ^
                   d_i[51]  ^  d_i[52]  ^  d_i[53]  ^  d_i[54]  ^  d_i[55]  ^
                   d_i[56];
    
       fn_ecc_enc_dec[4] = d_i[11]  ^  d_i[12]  ^  d_i[13]  ^  d_i[14]  ^  d_i[15]  ^
                   d_i[16]  ^  d_i[17]  ^  d_i[18]  ^  d_i[19]  ^  d_i[20]  ^
                   d_i[21]  ^  d_i[22]  ^  d_i[23]  ^  d_i[24]  ^  d_i[25]  ^
                   d_i[41]  ^  d_i[42]  ^  d_i[43]  ^  d_i[44]  ^  d_i[45]  ^
                   d_i[46]  ^  d_i[47]  ^  d_i[48]  ^  d_i[49]  ^  d_i[50]  ^
                   d_i[51]  ^  d_i[52]  ^  d_i[53]  ^  d_i[54]  ^  d_i[55]  ^
                   d_i[56];
    
       fn_ecc_enc_dec[5] = d_i[26]  ^  d_i[27]  ^  d_i[28]  ^  d_i[29]  ^  d_i[30]  ^
                   d_i[31]  ^  d_i[32]  ^  d_i[33]  ^  d_i[34]  ^  d_i[35]  ^
                   d_i[36]  ^  d_i[37]  ^  d_i[38]  ^  d_i[39]  ^  d_i[40]  ^
                   d_i[41]  ^  d_i[42]  ^  d_i[43]  ^  d_i[44]  ^  d_i[45]  ^
                   d_i[46]  ^  d_i[47]  ^  d_i[48]  ^  d_i[49]  ^  d_i[50]  ^
                   d_i[51]  ^  d_i[52]  ^  d_i[53]  ^  d_i[54]  ^  d_i[55]  ^
                   d_i[56];
    
       fn_ecc_enc_dec[6] = d_i[57]  ^  d_i[58]  ^  d_i[59]  ^  d_i[60]  ^  d_i[61]  ^
                   d_i[62]  ^  d_i[63];
    
       ecc_7 = d_i[0]   ^  d_i[1]   ^  d_i[2]   ^  d_i[3]   ^ d_i[4]   ^
               d_i[5]   ^  d_i[6]   ^  d_i[7]   ^  d_i[8]   ^ d_i[9]   ^
               d_i[10]  ^  d_i[11]  ^  d_i[12]  ^  d_i[13]  ^ d_i[14]  ^
               d_i[15]  ^  d_i[16]  ^  d_i[17]  ^  d_i[18]  ^ d_i[19]  ^
               d_i[20]  ^  d_i[21]  ^  d_i[22]  ^  d_i[23]  ^ d_i[24]  ^
               d_i[25]  ^  d_i[26]  ^  d_i[27]  ^  d_i[28]  ^ d_i[29]  ^
               d_i[30]  ^  d_i[31]  ^  d_i[32]  ^  d_i[33]  ^ d_i[34]  ^
               d_i[35]  ^  d_i[36]  ^  d_i[37]  ^  d_i[38]  ^ d_i[39]  ^
               d_i[40]  ^  d_i[41]  ^  d_i[42]  ^  d_i[43]  ^ d_i[44]  ^
               d_i[45]  ^  d_i[46]  ^  d_i[47]  ^  d_i[48]  ^ d_i[49]  ^
               d_i[50]  ^  d_i[51]  ^  d_i[52]  ^  d_i[53]  ^ d_i[54]  ^
               d_i[55]  ^  d_i[56]  ^  d_i[57]  ^  d_i[58]  ^ d_i[59]  ^
               d_i[60]  ^  d_i[61]  ^  d_i[62]  ^  d_i[63];
    
       if (encode) begin
          fn_ecc_enc_dec[7] = ecc_7 ^
                      fn_ecc_enc_dec[0] ^ fn_ecc_enc_dec[1] ^ fn_ecc_enc_dec[2] ^ fn_ecc_enc_dec[3] ^
                      fn_ecc_enc_dec[4] ^ fn_ecc_enc_dec[5] ^ fn_ecc_enc_dec[6];
          end
       else begin
          fn_ecc_enc_dec[7] = ecc_7 ^
                      dp_i[0] ^ dp_i[1] ^ dp_i[2] ^ dp_i[3] ^
                      dp_i[4] ^ dp_i[5] ^ dp_i[6];
          end
    end
    endfunction // fn_ecc_enc_dec

    function [71:0] fn_correct_bit (
       input [6:0] error_bit,
       input [63:0] d_i,
       input [7:0] dp_i
       );
       reg [71:0] cor_int;
    begin
       cor_int = {d_i[63:57], dp_i[6], d_i[56:26], dp_i[5], d_i[25:11], dp_i[4],
                  d_i[10:4], dp_i[3], d_i[3:1], dp_i[2], d_i[0], dp_i[1:0],
                  dp_i[7]};
       cor_int[error_bit] = ~cor_int[error_bit];
       fn_correct_bit = {cor_int[0], cor_int[64], cor_int[32], cor_int[16],
                     cor_int[8], cor_int[4], cor_int[2:1], cor_int[71:65],
                     cor_int[63:33], cor_int[31:17], cor_int[15:9],
                     cor_int[7:5], cor_int[3]};
    end
    endfunction // fn_correct_bit


    `ifndef OBSOLETE
    `ifndef DISABLE_XPM_ASSERTIONS    
      if(SIM_ASSERT_CHK == 1) begin : ecc_cover
      // Assertions to catch some of the valid/mandatory configurations of ECC
        if(`BOTH_ENC_DEC) begin : chk_vld_ecc_both_configs
          // checks to see if error injection is covered
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration.", addrb, $time);

          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && injectdbiterra && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_BOTH_ERR_INJ_ASSRT: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && injectdbiterrb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_BOTH_ERR_INJ_ASSRT: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration.", addrb, $time);

          // checks to see if error injection is covered during reset
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && rsta && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_RST_ASSRT: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during reset.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && rsta && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_RST_ASSRT: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during reset.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && rstb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_RST_ASSRT: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during reset.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && rstb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_RST_ASSRT: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during reset.", addrb, $time);

        // Check if sleep port is asserted on both port-a and port-b
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && sleep && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && sleep && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && sleep && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && sleep && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode.", addrb, $time);

          // checks to see if error injection is covered during sleep & reset
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && sleep && rsta && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode with reset asserted.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && sleep && rsta && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode with reset asserted.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && sleep && rstb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode with reset asserted.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && sleep && rstb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode with reset asserted.", addrb, $time);

        // Check if out-of range addresses are driven
          // Check if the error injection is happening
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && sleep && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode and the address being out of range.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && sleep && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode and the address being out of range.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && sleep && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode and the address being out of range.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && sleep && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode and the address being out of range.", addrb, $time);

          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && rsta && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during reset and the address being out of range.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && rsta && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during reset and the address being out of range.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && rstb && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during reset and the address being out of range.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && rstb && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during reset and the address being out of range.", addrb, $time);

          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && sleep && rsta && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode with reset asserted and the address being out of range.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && sleep && rsta && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode with reset asserted and the address being out of range.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && sleep && rstb && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode with reset asserted and the address being out of range.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && sleep && rstb && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in both Encode and Decode mode configuration during sleep mode with reset asserted and the address being out of range.", addrb, $time);
        end : chk_vld_ecc_both_configs

        if(`ENC_ONLY) begin : chk_vld_ecc_enc_only_configs
          // checks to see if error injection is covered
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration.", addrb, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && injectdbiterra && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_BOTH_ERR_INJ_ASSRT: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && injectdbiterrb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_BOTH_ERR_INJ_ASSRT: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration.", addrb, $time);


          // checks to see if error injection is covered during reset
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && rsta && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_RST_ASSRT: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during reset.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && rsta && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_RST_ASSRT: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during reset.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && rstb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_RST_ASSRT: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during reset.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && rstb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_RST_ASSRT: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during reset.", addrb, $time);

        // Check if sleep port is asserted on both port-a and port-b
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && sleep && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && sleep && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && sleep && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && sleep && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode.", addrb, $time);

          // checks to see if error injection is covered during sleep & reset
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && sleep && rsta && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode with reset asserted.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && sleep && rsta && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode with reset asserted.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && sleep && rstb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode with reset asserted.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && sleep && rstb && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode with reset asserted.", addrb, $time);

        // Check if out-of range addresses are driven
          // Check if the error injection is happening
          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && sleep && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode and the address being out of range.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && sleep && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode and the address being out of range.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && sleep && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode and the address being out of range.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && sleep && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode and the address being out of range.", addrb, $time);

          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && rsta && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during reset and the address being out of range.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && rsta && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during reset and the address being out of range.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && rstb && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during reset and the address being out of range.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && rstb && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during reset and the address being out of range.", addrb, $time);

          assert property (@(posedge clka)
            !(ena && |wea && injectsbiterra && sleep && rsta && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode with reset asserted and the address being out of range.", addra, $time);
          assert property (@(posedge clka)
            !(ena && |wea && injectdbiterra && sleep && rsta && addra > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-A at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode with reset asserted and the address being out of range.", addra, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectsbiterrb && sleep && rstb && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_INJ_ASSRT_SLEEP: single bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode with reset asserted and the address being out of range.", addrb, $time);
          assert property (@(posedge clkb)
            !(enb && |web && injectdbiterrb && sleep && rstb && addrb > P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_INJ_ASSRT_SLEEP: double bit error into the memory through Port-B at address 0x%0h at time %0t happened in encode only mode configuration during sleep mode with reset asserted and the address being out of range.", addrb, $time);
        end : chk_vld_ecc_enc_only_configs

        if(`DEC_ONLY) begin : chk_vld_ecc_dec_only_configs
        // Decode only mode Checks
          assert property (@(posedge clka)
            !(sbiterra_int && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_STATUS: single bit error asserted through Port-A at address 0x%0h at time %0t in decode only mode configuration", addra, $time);
         assert property (@(posedge clka)
            !(dbiterra_int && addra <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_STATUS: single bit error asserted through Port-A at address 0x%0h at time %0t in decode only mode configuration", addra, $time);
          assert property (@(posedge clkb)
            !(sbiterrb_int && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_SINGLE_BIT_ERR_STATUS: single bit error asserted through Port-B at address 0x%0h at time %0t in decode only mode configuration", addrb, $time);
         assert property (@(posedge clkb)
            !(dbiterrb_int && addrb <= P_MAX_DEPTH_DATA))
          else
            $info("XPM_MEMORY_DOUBLE_BIT_ERR_STATUS: single bit error asserted through Port-B at address 0x%0h at time %0t in decode only mode configuration", addrb, $time);
        end : chk_vld_ecc_dec_only_configs

        // Check if there is a collision that happened during ECC mode w.r.t
        // data and error status ports
      end : ecc_cover
    `endif
    `endif

    function  [P_MIN_WIDTH_PARITY_ECC-1:0] ecc_init_mem_loc;
      input [WRITE_DATA_WIDTH_A-1 : 0] data_in;
      integer data_slice;
      for (data_slice=1; data_slice <= WRITE_DATA_WIDTH_A/64; data_slice=data_slice+1) begin 
          //ecc_init_mem_loc[(72*data_slice)-9 : (72*data_slice)-72] = data_in[(64*data_slice)-1 : (data_slice-1)*64];
          ecc_init_mem_loc[(72*data_slice)-9 -: 64] = data_in[(64*data_slice)-1 -: 64];
          ecc_init_mem_loc[(72*data_slice)-1 -: 8] = fn_ecc_enc_dec(1'b1, data_in[(64*data_slice)-1 -: 64], 8'h00);
      end
    endfunction

    // Memory Array Initialization
    initial begin
      if (`NO_MEMORY_INIT) begin : init_zeroes
        integer ecc_initword;
        for (ecc_initword=0; ecc_initword<P_MAX_DEPTH_DATA; ecc_initword=ecc_initword+1) begin
          mem_ecc[ecc_initword] = {P_MIN_WIDTH_PARITY_ECC{1'b0}};
        end
      end : init_zeroes
      else begin : init_datafile
        if (ECC_MODE == 3 ) begin
          $readmemh(MEMORY_INIT_FILE, mem_ecc, 0, P_MAX_DEPTH_DATA-1);
        end else begin
          $readmemh(MEMORY_INIT_FILE, mem_ecc, 0, P_MAX_DEPTH_DATA-1);
          for(int i=0; i<P_MAX_DEPTH_DATA; i=i+1) begin
              mem_ecc[i] = ecc_init_mem_loc(mem_ecc[i]);
          end
        end
      end : init_datafile
    end

    reg [P_MIN_WIDTH_PARITY_ECC-1 : 0] din_to_mem_ecc_a;
    reg [P_MIN_WIDTH_PARITY_ECC-1 : 0] din_to_mem_ecc_b;

    if (ECC_MODE == 3 && `NO_MEMORY_INIT) begin : en_enc_dec
      // memory declaration (aspect ratio is not supported when ECC Enabled)
      // Actual Template needs to be supplied by synthesis team
      reg [0:0] sbiterr_status [0:P_MAX_DEPTH_DATA-1];
      reg [0:0] dbiterr_status [0:P_MAX_DEPTH_DATA-1];
      reg [P_MIN_WIDTH_PARITY_ECC-1 : 0] din_to_mem_ecc_a_tdp_ultra;
      initial begin
        sbiterrb_int <= 1'b0;
        dbiterrb_int <= 1'b0;
        sbiterra_int <= 1'b0;
        dbiterra_int <= 1'b0;
      end

    for (genvar data_slice_a=1; data_slice_a <= WRITE_DATA_WIDTH_A/64; data_slice_a=data_slice_a+1) begin : ecc_data_calc_a
      always @(posedge clka) begin : ecc_enc_only_data_wr
        if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addra_aslp_sim < P_MAX_DEPTH_DATA) begin
          if(`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin
            if (!(enb_i && |web_i && addrb_i == addra_i)) begin
              if(|wea_i) begin
                if(injectdbiterra_sim)
                  mem_ecc[addra_i][(64*data_slice_a)-1 : (data_slice_a-1)*64] <= {dina_i[(64*data_slice_a)-1],~dina_i[(64*data_slice_a)-2] ,dina_i[(64*data_slice_a)-3 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
                else
                  mem_ecc[addra_i][(64*data_slice_a)-1 : (data_slice_a-1)*64] <= dina_i[(64*data_slice_a)-1 : (data_slice_a-1)*64];
              end
            end
          end
          else begin
            if(|wea_i) begin
              if(injectdbiterra_sim)
                mem_ecc[addra_i][(64*data_slice_a)-1 : (data_slice_a-1)*64] <= {dina_i[(64*data_slice_a)-1],~dina_i[(64*data_slice_a)-2] ,dina_i[(64*data_slice_a)-3 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
              else
                mem_ecc[addra_i][(64*data_slice_a)-1 : (data_slice_a-1)*64] <= dina_i[(64*data_slice_a)-1 : (data_slice_a-1)*64];
            end
          end
        end
      end : ecc_enc_only_data_wr
    end : ecc_data_calc_a

      always @(posedge clka)  begin: store_injbiterra
        if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addra_aslp_sim < P_MAX_DEPTH_DATA) begin
          if(`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin
            if (!(enb_i && |web_i && addrb_i == addra_i)) begin
              if(|wea_i) begin
                if(injectsbiterra_sim == 1'b1)
                   sbiterr_status[addra_i] <= 1'b1;
                 else
                   sbiterr_status[addra_i] <= 1'b0;
                if(injectdbiterra_sim == 1'b1)
                   dbiterr_status[addra_i] <= 1'b1;
                else
                   dbiterr_status[addra_i] <= 1'b0;
              end
            end
          end
          else begin
            if(|wea_i) begin
              if(injectsbiterra_sim == 1'b1)
                 sbiterr_status[addra_i] <= 1'b1;
               else
                 sbiterr_status[addra_i] <= 1'b0;
              if(injectdbiterra_sim == 1'b1)
                 dbiterr_status[addra_i] <= 1'b1;
              else
                 dbiterr_status[addra_i] <= 1'b0;
            end
          end
        end
      end : store_injbiterra

     if (`MEM_PORTB_WRITE && (`MEM_PRIM_ULTRA || `MEM_PRIM_AUTO)) begin : ecc_both_data_wrb
        for (genvar data_slice_b=1; data_slice_b <= WRITE_DATA_WIDTH_B/64; data_slice_b=data_slice_b+1) begin : ecc_data_calc_b
          always @(posedge gen_wr_b.clkb_int) begin : ecc_enc_only_data_wr
            if(enb_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addrb_aslp_sim < P_MAX_DEPTH_DATA) begin
              if(|web_i) begin
                if(injectdbiterrb_sim) begin
                  mem_ecc[addrb_i][(64*data_slice_b)-1 : (data_slice_b-1)*64] <= {dinb_i[(64*data_slice_b)-1],~dinb_i[(64*data_slice_b)-2] ,dinb_i[(64*data_slice_b)-3 : (64*data_slice_b)-33],~dinb_i[(64*data_slice_b)-34],dinb_i[(64*data_slice_b)-35 : (data_slice_b-1)*64]};
                  din_to_mem_ecc_b <= {dinb_i[(64*data_slice_b)-1],~dinb_i[(64*data_slice_b)-2] ,dinb_i[(64*data_slice_b)-3 : (64*data_slice_b)-33],~dinb_i[(64*data_slice_b)-34],dinb_i[(64*data_slice_b)-35 : (data_slice_b-1)*64]};
                end
                else begin
                  mem_ecc[addrb_i][(64*data_slice_b)-1 : (data_slice_b-1)*64] <= dinb_i[(64*data_slice_b)-1 : (data_slice_b-1)*64];
                  din_to_mem_ecc_b <= dinb_i[(64*data_slice_b)-1 : (data_slice_b-1)*64];
                end
              end
            end
          end : ecc_enc_only_data_wr
        end : ecc_data_calc_b

        always @(posedge gen_wr_b.clkb_int)  begin: errb_status_proc
          if(enb_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addrb_aslp_sim < P_MAX_DEPTH_DATA) begin
            if (|web_i) begin
              if(injectsbiterrb_sim == 1'b1)
                sbiterr_status[addrb_i] <= 1'b1;
              else
                sbiterr_status[addrb_i] <= 1'b0;
              if(injectdbiterrb_sim == 1'b1)
                dbiterr_status[addrb_i] <= 1'b1;
              else
                dbiterr_status[addrb_i] <= 1'b0;
            end
          end
        end : errb_status_proc
     end : ecc_both_data_wrb

   // Single Bit Error Injection
   // Error Injecting Position is dina|b[30] : Corrupted data need not be
   // written to memory as the decoder will correct the data.
   // Double Bit Error Injection
   // Error Injecting bit-Positions are dina|b[30] and dina|b[62]
   if ((`MEM_PRIM_ULTRA || `MEM_PRIM_AUTO) && (`MEM_TYPE_RAM_SP || `MEM_TYPE_RAM_TDP)) begin : nc_rf_wf_porta
     if (`MEM_PORTA_NC) begin : nc_prta
       always @(posedge clka)  begin: erra_status
         if (sleep_int_a || sleep_int_b == 1'b1 || (addra_aslp_sim >= P_MAX_DEPTH_DATA)) begin
           if(ena_i & ~(|wea_i)) begin
             sbiterra_int <= 1'bX;
             dbiterra_int <= 1'bX;
           end
         end
         else if (rsta && READ_LATENCY_A ==1) begin
           sbiterra_int <= 1'b0;
           dbiterra_int <= 1'b0; 
         end
         else if(ena_i) begin
           if(~(|wea_i)) begin
             if (sbiterr_status[addra_i] == 1'b1)
               sbiterra_int <= 1'b1;
             else
               sbiterra_int <= 1'b0;
             if (dbiterr_status[addra_i] == 1'b1)
               dbiterra_int <= 1'b1;
             else
               dbiterra_int <= 1'b0;
           end
         end
         assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.sbiterra_in_pipe = sbiterra_int & ~dbiterra_int;
         assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.dbiterra_in_pipe = dbiterra_int;
       end : erra_status
       always @(posedge clka) begin
         if(rsta && READ_LATENCY_A ==1)
           deassign gen_rd_a.douta_reg;
         else begin
           if(addra_aslp_sim < P_MAX_DEPTH_DATA) begin
             if(ena_i && ~(|wea_i) && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))) begin
               douta_int <= mem_ecc[addra_i];
               assign gen_rd_a.douta_reg = douta_int;
             end
           end
           else begin
             douta_int <= 'bX; 
             assign gen_rd_a.douta_reg = douta_int;
           end
         end
       end
     end : nc_prta
     if (`MEM_PORTA_RF) begin : rf_prta
       always @(posedge clka)  begin: erra_status
         if (sleep_int_a || sleep_int_b == 1'b1 || (addra_aslp_sim >= P_MAX_DEPTH_DATA)) begin
           if(ena_i) begin
             sbiterra_int <= 1'bX;
             dbiterra_int <= 1'bX;
           end
         end
         else if (rsta && READ_LATENCY_A ==1) begin
           sbiterra_int <= 1'b0;
           dbiterra_int <= 1'b0; 
         end
         else if(ena_i) begin
           if (sbiterr_status[addra_i] == 1'b1)
             sbiterra_int <= 1'b1;
           else
             sbiterra_int <= 1'b0;
           if (dbiterr_status[addra_i] == 1'b1)
             dbiterra_int <= 1'b1;
           else
             dbiterra_int <= 1'b0;
         end
         assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.sbiterra_in_pipe = sbiterra_int & ~dbiterra_int;
         assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.dbiterra_in_pipe = dbiterra_int;
       end : erra_status
       always @(posedge clka) begin
         if(rsta && READ_LATENCY_A ==1)
           deassign gen_rd_a.douta_reg;
         else begin
           if(addra_aslp_sim < P_MAX_DEPTH_DATA) begin
             if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))) begin
               douta_int <= mem_ecc[addra_i];
               assign gen_rd_a.douta_reg = douta_int;
             end
           end
           else begin
             douta_int <= 'bX; 
             assign gen_rd_a.douta_reg = douta_int;
           end
         end
       end
     end : rf_prta

     if (`MEM_PORTA_WF) begin : wf_porta
       always @(posedge clka)  begin: erra_status
         if (sleep_int_a || sleep_int_b == 1'b1 || (addra_aslp_sim >= P_MAX_DEPTH_DATA)) begin
           if(ena_i) begin
             sbiterra_int <= 1'bX;
             dbiterra_int <= 1'bX;
           end
         end
         else if (rsta && READ_LATENCY_A ==1) begin
           sbiterra_int <= 1'b0;
           dbiterra_int <= 1'b0; 
         end
         else if(ena_i) begin
           if(|wea_i) begin
             if(injectsbiterra_sim)
               sbiterra_int <= 1'b1;
             else
               sbiterra_int <= 1'b0;
             if(injectdbiterra_sim)
               dbiterra_int <= 1'b1;
             else
               dbiterra_int <= 1'b0;
           end
          else begin
            if (sbiterr_status[addra_i] == 1'b1)
              sbiterra_int <= 1'b1;
            else
              sbiterra_int <= 1'b0;
            if (dbiterr_status[addra_i] == 1'b1)
              dbiterra_int <= 1'b1;
            else
              dbiterra_int <= 1'b0;
          end
         end
         assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.sbiterra_in_pipe = sbiterra_int & ~dbiterra_int;
         assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.dbiterra_in_pipe = dbiterra_int;
       end : erra_status
       for (genvar data_slice_a=1; data_slice_a <= WRITE_DATA_WIDTH_A/64; data_slice_a=data_slice_a+1) begin : ecc_data_calc_a
         always @(*) begin : ecc_enc_only_data_wr
           if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addra_aslp_sim < P_MAX_DEPTH_DATA) begin
             if(|wea_i) begin
               if(injectdbiterra_sim)
                 din_to_mem_ecc_a[(64*data_slice_a)-1 : (data_slice_a-1)*64] = {dina_i[(64*data_slice_a)-1],~dina_i[(64*data_slice_a)-2] ,dina_i[(64*data_slice_a)-3 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
             end
           end
         end : ecc_enc_only_data_wr
       end : ecc_data_calc_a

       always @(posedge clka) begin
         if(rsta && READ_LATENCY_A ==1)
           deassign gen_rd_a.douta_reg;
         else begin
           if(addra_aslp_sim < P_MAX_DEPTH_DATA) begin
             if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))) begin
               if(|wea_i) begin
                 if (injectdbiterra_sim)
                   douta_int <= din_to_mem_ecc_a;
                 else
                   douta_int <= dina_i;
               end
               else
                 douta_int <= mem_ecc[addra_i];
              assign gen_rd_a.douta_reg = douta_int;
             end
           end
           else begin
             douta_int <= 'bX; 
             assign gen_rd_a.douta_reg = douta_int;
           end
         end
       end
   end : wf_porta
  end : nc_rf_wf_porta
  if (`MEM_PORTB_READ) begin : dbiterrb_data_gen_proc
     // Only No_Change mode behavior is considered, as TDP + URAM supports
     // no_change mode. This will work for BRAM as only SDP mode is supported
     always @(posedge gen_rd_b.clkb_int)  begin: sbiterrb_gen_proc
       if (sleep_int_a == 1'b1 || sleep_int_b == 1'b1 || (addrb_aslp_sim >= P_MAX_DEPTH_DATA)) begin
         if (enb_i & ~(|web_i)) begin
           sbiterrb_int <= 1'bX;
           dbiterrb_int <= 1'bX;
         end
       end
       else if (rstb && READ_LATENCY_B ==1) begin
         sbiterrb_int <= 1'b0;
         dbiterrb_int <= 1'b0; 
       end
       else if(enb_i & ~(|web_i)) begin
         if(`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin
           if (ena_i && |wea_i && (addra_i == addrb_i) && addrb_aslp_sim < P_MAX_DEPTH_DATA) begin
             if(injectsbiterra_sim)
               sbiterrb_int <= 1'b1;
             else
               sbiterrb_int <= 1'b0;
             if(injectdbiterra_sim)
               dbiterrb_int <= 1'b1;
             else
               dbiterrb_int <= 1'b0;
           end
           else begin
             if (sbiterr_status[addrb_i] == 1'b1)
               sbiterrb_int <= 1'b1;
             else
               sbiterrb_int <= 1'b0;
             if (dbiterr_status[addrb_i] == 1'b1)
               dbiterrb_int <= 1'b1;
             else
               dbiterrb_int <= 1'b0;
           end
         end
         else begin
           if (sbiterr_status[addrb_i] == 1'b1)
             sbiterrb_int <= 1'b1;
           else
             sbiterrb_int <= 1'b0;
           if (dbiterr_status[addrb_i] == 1'b1)
             dbiterrb_int <= 1'b1;
           else
             dbiterrb_int <= 1'b0;
         end
       end
      assign gen_rd_b.pipeline_ecc_status.sbiterrb_in_pipe = sbiterrb_int & ~dbiterrb_int;
      assign gen_rd_b.pipeline_ecc_status.dbiterrb_in_pipe = dbiterrb_int;
     end : sbiterrb_gen_proc

     if(`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin : tdp_ultra_wf_gen
       for (genvar data_slice_a=1; data_slice_a <= WRITE_DATA_WIDTH_A/64; data_slice_a=data_slice_a+1) begin : ecc_data_calc_a
         always @(*) begin : ecc_enc_only_data_wr
           if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addra_aslp_sim < P_MAX_DEPTH_DATA) begin
             if(|wea_i) begin
               if(injectdbiterra_sim)
                 din_to_mem_ecc_a_tdp_ultra[(64*data_slice_a)-1 : (data_slice_a-1)*64] = {dina_i[(64*data_slice_a)-1],~dina_i[(64*data_slice_a)-2] ,dina_i[(64*data_slice_a)-3 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
             end
           end
         end : ecc_enc_only_data_wr
       end : ecc_data_calc_a
     end : tdp_ultra_wf_gen

     always @(posedge gen_rd_b.clkb_int)  begin
       if (rstb && READ_LATENCY_B == 1)
         deassign gen_rd_b.doutb_reg;
       else begin
         if(addrb_aslp_sim < P_MAX_DEPTH_DATA) begin
           if(enb_i & ~(|web_i) && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))) begin
             // If A is writing and B is reading then it should read the new data
             if(`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin
               if (ena_i && |wea_i && (addra_i == addrb_i) && addrb_aslp_sim < P_MAX_DEPTH_DATA) begin
                 if(injectdbiterra_sim) begin
                   doutb_int <= din_to_mem_ecc_a_tdp_ultra;
                   assign gen_rd_b.doutb_reg = doutb_int;
                 end
                 else begin
                   doutb_int <= dina_i;
                   assign gen_rd_b.doutb_reg = doutb_int;
                 end
               end
               else begin
                 doutb_int <= mem_ecc[addrb_i];
                 assign gen_rd_b.doutb_reg = doutb_int;
               end
             end
             else begin
               doutb_int <= mem_ecc[addrb_i];
               assign gen_rd_b.doutb_reg = doutb_int;
             end
           end
         end
         else begin
           doutb_int <= 'bX;
           assign gen_rd_b.doutb_reg = doutb_int;
         end
       end
     end
   end : dbiterrb_data_gen_proc
  end : en_enc_dec
 // -------------------------------------------------------------------------------------------------------------------
   /**ECC Behavioral Modeling when Encoder only is enabled
     This module need to perform the parity calculations on the data and write to the memroy
     This module needs to model the Error Injection, corrupt the data and
     write to the memory
     Error status signals can never get asserted here
  **/
 // -------------------------------------------------------------------------------------------------------------------


  if (ECC_MODE == 1 || (ECC_MODE == 3 && !(`NO_MEMORY_INIT))) begin : en_enc_only

    // memory declaration (aspect ratio is not supported when ECC Enabled)
    // Actual Template needs to be supplied by synthesis team


      reg [0:0] sbiterr_status [0:P_MAX_DEPTH_DATA-1];
      reg [0:0] dbiterr_status [0:P_MAX_DEPTH_DATA-1];

    // Data is expected to be in the multiples of 64-bits
    // Data - parity calculation can be continuously calculated

    // The Implementation involves in 3 steps :
    // 1. Memory Array in this case needs to be created with the width being
    // multiple of 72 bits
    // 2. Calculate the width of the vector comprising of data and parity
    // 3. Have a generate statement to calculate the parity and assign to the
    // din_to_mem_ecc vector
    // 4. Have a generate statement to assign the data input to the proper
    // segments of the din_to_mem_ecc vector
    // 5. Assign the complete constructed data array to the memory
 
   // Error Injection Implementation
   // Memory needs to be corrupted for both Single and Double bit Error
   // injection transactions here

    for (genvar data_slice_a=1; data_slice_a <= WRITE_DATA_WIDTH_A/64; data_slice_a=data_slice_a+1) begin : ecc_data_calc_a
      always @(posedge clka) begin : ecc_enc_only_data_wr
        if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addra_aslp_sim < P_MAX_DEPTH_DATA) begin
          if(`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin
            if (!(enb_i && |web_i && addrb_i == addra_i)) begin
              if(|wea_i) begin
                if(injectdbiterra_sim)
                  mem_ecc[addra_i][(72*data_slice_a)-9 : (72*data_slice_a)-72] <= {dina_i[(64*data_slice_a)-1],~dina_i[(64*data_slice_a)-2] ,dina_i[(64*data_slice_a)-3 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
                else if(injectsbiterra_sim)
                  mem_ecc[addra_i][(72*data_slice_a)-9 : (72*data_slice_a)-72] <= {dina_i[(64*data_slice_a)-1 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
                else
                  mem_ecc[addra_i][(72*data_slice_a)-9 : (72*data_slice_a)-72] <= dina_i[(64*data_slice_a)-1 : (data_slice_a-1)*64];
              mem_ecc[addra_i][(72*data_slice_a)-1 : (72*data_slice_a)-8] <= fn_ecc_enc_dec(1'b1, dina_i[(64*data_slice_a)-1 : (data_slice_a-1)*64], 8'h00);
              end
            end
          end
          else begin
            if(|wea_i) begin
              if(injectdbiterra_sim)
                mem_ecc[addra_i][(72*data_slice_a)-9 : (72*data_slice_a)-72] <= {dina_i[(64*data_slice_a)-1],~dina_i[(64*data_slice_a)-2] ,dina_i[(64*data_slice_a)-3 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
              else if(injectsbiterra_sim)
                mem_ecc[addra_i][(72*data_slice_a)-9 : (72*data_slice_a)-72] <= {dina_i[(64*data_slice_a)-1 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
              else
                mem_ecc[addra_i][(72*data_slice_a)-9 : (72*data_slice_a)-72] <= dina_i[(64*data_slice_a)-1 : (data_slice_a-1)*64];
              mem_ecc[addra_i][(72*data_slice_a)-1 : (72*data_slice_a)-8] <= fn_ecc_enc_dec(1'b1, dina_i[(64*data_slice_a)-1 : (data_slice_a-1)*64], 8'h00);
            end
          end
        end
      end : ecc_enc_only_data_wr
    end : ecc_data_calc_a

    if (`MEM_PORTB_WRITE && (`MEM_PRIM_ULTRA || `MEM_PRIM_AUTO)) begin : data_in_proc_b
       for (genvar data_slice_b=1; data_slice_b <= WRITE_DATA_WIDTH_B/64; data_slice_b=data_slice_b+1) begin : ecc_data_calc_b
         always @(posedge gen_wr_b.clkb_int) begin : ecc_enc_only_data_wr_b
           if(enb_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addrb_aslp_sim < P_MAX_DEPTH_DATA) begin
             if(|web_i) begin
               if(injectdbiterrb_sim)
                 mem_ecc[addrb_i][(72*data_slice_b)-9 : (72*data_slice_b)-72] <= {dinb_i[(64*data_slice_b)-1],~dinb_i[(64*data_slice_b)-2] ,dinb_i[(64*data_slice_b)-3 : (64*data_slice_b)-33],~dinb_i[(64*data_slice_b)-34],dinb_i[(64*data_slice_b)-35 : (data_slice_b-1)*64]};
               else if(injectsbiterrb_sim)
                 mem_ecc[addrb_i][(72*data_slice_b)-9 : (72*data_slice_b)-72] <= {dinb_i[(64*data_slice_b)-1 : (64*data_slice_b)-33],~dinb_i[(64*data_slice_b)-34],dinb_i[(64*data_slice_b)-35 : (data_slice_b-1)*64]};
               else
                 mem_ecc[addrb_i][(72*data_slice_b)-9 : (72*data_slice_b)-72] <= dinb_i[(64*data_slice_b)-1 : (data_slice_b-1)*64];
               mem_ecc[addrb_i][(72*data_slice_b)-1 : (72*data_slice_b)-8] <= fn_ecc_enc_dec(1'b1, dinb_i[(64*data_slice_b)-1 : (data_slice_b-1)*64], 8'h00);
             end
           end
         end : ecc_enc_only_data_wr_b
       end : ecc_data_calc_b
    end : data_in_proc_b
      if (ECC_MODE == 1 && `MEM_PORTB_READ) begin : data_enc_only
        always @(posedge gen_rd_b.clkb_int)  begin: data_out_proc_b
          if (rstb && READ_LATENCY_B == 1)
            deassign gen_rd_b.doutb_reg;
          else if(enb_i && ~(|web_i) && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))) begin
            if(`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin
              if (ena_i && |wea_i && (addra_i == addrb_i) && addrb_aslp_sim < P_MAX_DEPTH_DATA) begin
                if(injectdbiterra_sim) begin
                  for (integer data_slice_a=1; data_slice_a <= WRITE_DATA_WIDTH_A/64; data_slice_a=data_slice_a+1) begin
                    din_to_mem_ecc_a[(72*data_slice_a)-9 -: 64] = {dina_i[(64*data_slice_a)-1],~dina_i[(64*data_slice_a)-2] ,dina_i[(64*data_slice_a)-3 -: 31],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 -: 30]};
                    din_to_mem_ecc_a[(72*data_slice_a)-1 -: 8]  = fn_ecc_enc_dec(1'b1, dina_i[(64*data_slice_a)-1 -: 64], 8'h00);
                  end
                end
                else if(injectsbiterra_sim) begin
                  for (integer data_slice_a=1; data_slice_a <= WRITE_DATA_WIDTH_A/64; data_slice_a=data_slice_a+1) begin
                    din_to_mem_ecc_a[(72*data_slice_a)-9 -: 64] = {dina_i[(64*data_slice_a)-1 -:33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 -: 30]};
                    din_to_mem_ecc_a[(72*data_slice_a)-1 -: 8]  = fn_ecc_enc_dec(1'b1, dina_i[(64*data_slice_a)-1 -: 64], 8'h00);
                  end
                end
                else begin
                  for (integer data_slice_a=1; data_slice_a <= WRITE_DATA_WIDTH_A/64; data_slice_a=data_slice_a+1) begin
                    din_to_mem_ecc_a[(72*data_slice_a)-9 -: 64] = dina_i[(64*data_slice_a)-1 -: 64];
                    din_to_mem_ecc_a[(72*data_slice_a)-1 -: 8]  = fn_ecc_enc_dec(1'b1, dina_i[(64*data_slice_a)-1 -: 64], 8'h00);
                  end
                end
               doutb_int <= din_to_mem_ecc_a;
              end
              else begin
                if(addrb_aslp_sim < P_MAX_DEPTH_DATA)
                  doutb_int <= mem_ecc[addrb_i];
                else
                  doutb_int <= 'bX;
              end
            end
            else begin
              if(addrb_aslp_sim < P_MAX_DEPTH_DATA)
                doutb_int <= mem_ecc[addrb_i];
              else
                doutb_int <= 'bX;
            end
            assign gen_rd_b.doutb_reg = doutb_int;
          end
        end : data_out_proc_b
      end : data_enc_only

      if (`MEM_PORTA_READ && (`MEM_PRIM_ULTRA || `MEM_PRIM_AUTO)) begin : data_out_proc_a
        // Here the write mode can be Write First, Read First or No Change for
        // SPRAM, and for TDP it is always No Change
        if (`MEM_PORTA_RF) begin : rf_prta
          always @(posedge clka)  begin
            if (rsta && READ_LATENCY_A == 1)
              deassign gen_rd_a.douta_reg;
            else if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))) begin
              if(addra_aslp_sim < P_MAX_DEPTH_DATA)
                douta_int <= mem_ecc[addra_i];
              else
                douta_int <= 'bX;
              assign gen_rd_a.douta_reg = douta_int;
            end
          end
        end : rf_prta
        if (`MEM_PORTA_NC) begin : nc_prta
          always @(posedge clka)  begin
            if (rsta && READ_LATENCY_A == 1)
              deassign gen_rd_a.douta_reg;
            else if(ena_i & ~(|wea_i) && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))) begin
              if(addra_aslp_sim < P_MAX_DEPTH_DATA)
                douta_int <= mem_ecc[addra_i];
              else
                douta_int <= 'bX;
                assign gen_rd_a.douta_reg = douta_int;
            end
          end
        end : nc_prta
        if (`MEM_PORTA_WF) begin : wf_prta
          for (genvar data_slice_a=1; data_slice_a <= WRITE_DATA_WIDTH_A/64; data_slice_a=data_slice_a+1) begin : ecc_data_calc_a
            always @(*) begin : ecc_enc_only_data_wr
              if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addra_aslp_sim < P_MAX_DEPTH_DATA) begin
                if(|wea_i) begin
                  if(injectdbiterra_sim)
                    din_to_mem_ecc_a[(72*data_slice_a)-9 : (72*data_slice_a)-72] = {dina_i[(64*data_slice_a)-1],~dina_i[(64*data_slice_a)-2] ,dina_i[(64*data_slice_a)-3 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
                  else if(injectsbiterra_sim)
                    din_to_mem_ecc_a[(72*data_slice_a)-9 : (72*data_slice_a)-72] = {dina_i[(64*data_slice_a)-1 : (64*data_slice_a)-33],~dina_i[(64*data_slice_a)-34],dina_i[(64*data_slice_a)-35 : (data_slice_a-1)*64]};
                  else
                    din_to_mem_ecc_a[(72*data_slice_a)-9 : (72*data_slice_a)-72] = dina_i[(64*data_slice_a)-1 : (data_slice_a-1)*64];
                  din_to_mem_ecc_a[(72*data_slice_a)-1 : (72*data_slice_a)-8] = fn_ecc_enc_dec(1'b1, dina_i[(64*data_slice_a)-1 : (data_slice_a-1)*64], 8'h00);
                end
              end
            end : ecc_enc_only_data_wr
          end : ecc_data_calc_a
          always @(posedge clka)  begin
            if (rsta && READ_LATENCY_A == 1)
              deassign gen_rd_a.douta_reg;
            else if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))) begin
              if (addra_aslp_sim < P_MAX_DEPTH_DATA) begin
                if(|wea_i)
                    douta_int <= din_to_mem_ecc_a;
                else
                  douta_int <= mem_ecc[addra_i];
              end
              else begin
                douta_int <= 'bX;
              end
              assign gen_rd_a.douta_reg = douta_int; 
            end
          end
        end : wf_prta
      end : data_out_proc_a
  end : en_enc_only
 
  // -------------------------------------------------------------------------------------------------------------------
   /**ECC Behavioral Modeling when Decoder only is enabled
      This module need not perform the parity calculation as the parity needs to be supplied by the user
      But, this needs to check the parity correctness and assert the error
      status bits. (sbiterr and dbiterr status signals) 
      This module needs to model the Error Injection
    **/
  // -------------------------------------------------------------------------------------------------------------------

  if ((ECC_MODE == 3 && !(`NO_MEMORY_INIT)) || ECC_MODE == 2) begin : en_dec_only 
    // memory declaration (aspect ratio is not supported when ECC Enabled)
      reg [0:0] sbiterra_status [0:P_MAX_DEPTH_DATA-1];
      reg [0:0] dbiterra_status [0:P_MAX_DEPTH_DATA-1];
      reg [7:0] synda_i [(WRITE_DATA_WIDTH_A/72)-1:0];
      reg [7:0] synda_calc [(WRITE_DATA_WIDTH_A/72)-1:0];
      reg [(WRITE_DATA_WIDTH_A/72)-1:0] sbita_calc;
      reg [(WRITE_DATA_WIDTH_A/72)-1:0] dbita_calc;
      reg [WRITE_DATA_WIDTH_A-1 : 0] douta_frm_mem_ecc = 'b0;
      reg [READ_DATA_WIDTH_A-1 : 0] douta_frm_mem_ecc_out = 'b0; // always to be in multiples of 64, data to be forced on to dout

      reg [0:0] sbiterrb_status [0:P_MAX_DEPTH_DATA-1];
      reg [0:0] dbiterrb_status [0:P_MAX_DEPTH_DATA-1];
      reg [7:0] syndb_i [(WRITE_DATA_WIDTH_A/72)-1:0];
      reg [7:0] syndb_calc [(WRITE_DATA_WIDTH_A/72)-1:0];
      reg [(WRITE_DATA_WIDTH_A/72)-1:0] sbitb_calc;
      reg [(WRITE_DATA_WIDTH_A/72)-1:0] dbitb_calc;
      reg [WRITE_DATA_WIDTH_A-1 : 0] doutb_frm_mem_ecc = 'b0;
      reg [READ_DATA_WIDTH_B-1 : 0] doutb_frm_mem_ecc_out = 'b0; // always to be in multiples of 64, data to be forced on to dout

      initial begin
        sbiterra_int <= 1'b0;
        dbiterra_int <= 1'b0;
        sbiterrb_int <= 1'b0;
        dbiterrb_int <= 1'b0;
      end

    // Data is expected to be in the multiples of 72-bits
    // Data - parity calculation can be continuously calculated
    // and compare it with what user supplied

    // The Implementation involves in 3 steps :
    // 1. Memory Array in this case needs to be created with the width being
    // multiple of 72 bits
    // 2. write the data to the memory
    // 3. Always Read the data from memory based on the address, and separate
    // data and parity bits
    // 4. calculate the parity bits on the data
    // 5. compare the user supplied parity bits with calculated syndrome bits

    // Data to be written to the memory array, no error injection in decode only mode
      if(ECC_MODE == 2) begin :data_dec_only
        always @(posedge clka) begin : ecc_dec_only_data_wr
          if(ena_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addra_aslp_sim < P_MAX_DEPTH_DATA) begin
            if(`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin
              if (!(enb_i && |web_i && addrb_i == addra_i)) begin
                if(|wea_i)
                  mem_ecc[addra_i] <= dina_i;
              end
            end
            else begin
              if(|wea_i)
                mem_ecc[addra_i] <= dina_i;
            end
          end
        end : ecc_dec_only_data_wr
        if (`MEM_PORTB_WRITE && (`MEM_PRIM_ULTRA || `MEM_PRIM_AUTO)) begin : data_in_proc_b
          always @(posedge gen_wr_b.clkb_int) begin
            if(enb_i && (~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) && addrb_aslp_sim < P_MAX_DEPTH_DATA) begin
              if(|web_i)
                mem_ecc[addrb_i] <= dinb_i;
            end
          end
        end : data_in_proc_b
      end : data_dec_only
      
      if (`MEM_PORTB_READ) begin : data_out_proc_b
        for (genvar dat_par_slice_b=1; dat_par_slice_b <= WRITE_DATA_WIDTH_A/72; dat_par_slice_b = dat_par_slice_b+1) begin : ecc_par_calc_b
          always @(*) begin
            if (enb_i & ~|web_i) begin
              if(`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP) begin
                if (ena_i) begin
                  if(|wea_i && (addra_i == addrb_i))
                    doutb_frm_mem_ecc = dina_i;
                  else
                    doutb_frm_mem_ecc = mem_ecc[addrb_i];
                end
                else
                  doutb_frm_mem_ecc = mem_ecc[addrb_i];
              end
              else
                doutb_frm_mem_ecc = mem_ecc[addrb_i];
              syndb_i[dat_par_slice_b-1] = fn_ecc_enc_dec(1'b0, doutb_frm_mem_ecc[(72*dat_par_slice_b)-9 : (72*dat_par_slice_b)-72], doutb_frm_mem_ecc[(72*dat_par_slice_b)-1 : (72*dat_par_slice_b)-8]);
              syndb_calc[dat_par_slice_b-1] = syndb_i[dat_par_slice_b-1] ^ doutb_frm_mem_ecc[(72*dat_par_slice_b)-1 : (72*dat_par_slice_b)-8];
              sbitb_calc[dat_par_slice_b-1] = |syndb_calc[dat_par_slice_b-1] && syndb_calc[dat_par_slice_b-1][7];
              dbitb_calc[dat_par_slice_b-1] = |syndb_calc[dat_par_slice_b-1] && ~syndb_calc[dat_par_slice_b-1][7];
              if(sbitb_calc[dat_par_slice_b-1] && ~dbitb_calc[dat_par_slice_b-1])
                  doutb_frm_mem_ecc_out[(64*dat_par_slice_b)-1 : (64*dat_par_slice_b)-64] = fn_correct_bit(syndb_calc[dat_par_slice_b-1], doutb_frm_mem_ecc[(72*dat_par_slice_b)-9 : (72*dat_par_slice_b)-72],doutb_frm_mem_ecc[(72*dat_par_slice_b)-1 : (72*dat_par_slice_b)-8]);
              else
                doutb_frm_mem_ecc_out[(64*dat_par_slice_b)-1 : (64*dat_par_slice_b)-64] = doutb_frm_mem_ecc[(72*dat_par_slice_b)-9 : (72*dat_par_slice_b)-72];
            end
          end
        end : ecc_par_calc_b

        always @(posedge gen_rd_b.clkb_int)  begin: data_gen_proc
          if (sleep_int_a == 1'b1 || sleep_int_b == 1'b1) begin
            if(enb_i & ~(|web_i)) begin
              sbiterrb_int <= 1'bX;
              dbiterrb_int <= 1'bX;
            end
          end
          else if (rstb && READ_LATENCY_B == 1) begin
            assign gen_rd_b.doutb_reg = gen_rd_b.rstb_val;
            sbiterrb_int <= 0;
            dbiterrb_int <= 0;
          end
          else if(enb_i & ~(|web_i)) begin
	    if (addrb_aslp_sim >= P_MAX_DEPTH_DATA) begin
              doutb_int    <= 'bX;
              sbiterrb_int <= 1'bX;
              dbiterrb_int <= 1'bX;
            end
	    else begin
              doutb_int <= doutb_frm_mem_ecc_out;
              sbiterrb_int <= |sbitb_calc;
              dbiterrb_int <= |dbitb_calc;
	    end
            assign gen_rd_b.doutb_reg = doutb_int;
          end
          assign gen_rd_b.pipeline_ecc_status.sbiterrb_in_pipe = sbiterrb_int;
          assign gen_rd_b.pipeline_ecc_status.dbiterrb_in_pipe = dbiterrb_int;
        end : data_gen_proc
      end : data_out_proc_b

      if (`MEM_PORTA_READ && (`MEM_PRIM_ULTRA || `MEM_PRIM_AUTO)) begin : data_out_proc_a
        for (genvar dat_par_slice_a=1; dat_par_slice_a <= WRITE_DATA_WIDTH_A/72; dat_par_slice_a = dat_par_slice_a+1) begin : ecc_par_calc_a
          always @(*) begin
            if (addra_aslp_sim < P_MAX_DEPTH_DATA) begin
              if (ena_i) begin
                if(`MEM_PORTA_WF) begin
                  if(|wea_i)
                    douta_frm_mem_ecc = dina_i;
                  else
                    douta_frm_mem_ecc = mem_ecc[addra_i];
                end
                else begin
                  douta_frm_mem_ecc = mem_ecc[addra_i];
                end
                synda_i[dat_par_slice_a-1] = fn_ecc_enc_dec(1'b0, douta_frm_mem_ecc[(72*dat_par_slice_a)-9 : (72*dat_par_slice_a)-72], douta_frm_mem_ecc[(72*dat_par_slice_a)-1 : (72*dat_par_slice_a)-8]);
                synda_calc[dat_par_slice_a-1] = synda_i[dat_par_slice_a-1] ^ douta_frm_mem_ecc[(72*dat_par_slice_a)-1 : (72*dat_par_slice_a)-8];
                sbita_calc[dat_par_slice_a-1] = |synda_calc[dat_par_slice_a-1] && synda_calc[dat_par_slice_a-1][7];
                dbita_calc[dat_par_slice_a-1] = |synda_calc[dat_par_slice_a-1] && ~synda_calc[dat_par_slice_a-1][7];
                if(sbita_calc[dat_par_slice_a-1] && ~dbita_calc[dat_par_slice_a-1])
                    douta_frm_mem_ecc_out[(64*dat_par_slice_a)-1 : (64*dat_par_slice_a)-64] = fn_correct_bit(synda_calc[dat_par_slice_a-1], douta_frm_mem_ecc[(72*dat_par_slice_a)-9 : (72*dat_par_slice_a)-72],douta_frm_mem_ecc[(72*dat_par_slice_a)-1 : (72*dat_par_slice_a)-8]);
                else
                  douta_frm_mem_ecc_out[(64*dat_par_slice_a)-1 : (64*dat_par_slice_a)-64] = douta_frm_mem_ecc[(72*dat_par_slice_a)-9 : (72*dat_par_slice_a)-72];
              end
            end
            else begin
              douta_frm_mem_ecc_out = 'bX;
              sbita_calc = 'bX;
              dbita_calc = 'bX;
            end
          end
        end : ecc_par_calc_a

        if (`MEM_PORTA_RF || `MEM_PORTA_WF) begin : rf_prta
          always @(posedge clka)  begin: data_gen_proc
            if (sleep_int_a == 1'b1 || sleep_int_b == 1'b1) begin
              if (ena_i) begin
                sbiterra_int <= 1'bX;
                dbiterra_int <= 1'bX;
              end
            end
            else if (rsta && READ_LATENCY_A == 1) begin
              assign gen_rd_a.douta_reg = gen_rd_a.rsta_val;
              sbiterra_int <= 0;
              dbiterra_int <= 0;
            end
            else if(ena_i) begin
              if (addra_aslp_sim >= P_MAX_DEPTH_DATA) begin
                douta_int <= 'bX;
                sbiterra_int <= 1'bX;
                dbiterra_int <= 1'bX;
              end
              else begin
                douta_int <= douta_frm_mem_ecc_out;
                sbiterra_int <= |sbita_calc;
                dbiterra_int <= |dbita_calc;
              end
              assign gen_rd_a.douta_reg = douta_int;
            end
            assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.sbiterra_in_pipe = sbiterra_int;
            assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.dbiterra_in_pipe = dbiterra_int;
          end : data_gen_proc
        end : rf_prta

        if (`MEM_PORTA_NC) begin : nc_prta
          always @(posedge clka)  begin: data_gen_proc
            if (sleep_int_a == 1'b1 || sleep_int_b == 1'b1) begin
              if(ena_i & ~(|wea_i)) begin
                sbiterra_int <= 1'bX;
                dbiterra_int <= 1'bX;
              end
            end
            else if (rsta && READ_LATENCY_A == 1) begin
              assign gen_rd_a.douta_reg = gen_rd_a.rsta_val;
              sbiterra_int <= 0;
              dbiterra_int <= 0;
            end
            else if(ena_i & ~(|wea_i)) begin
              if (addra_aslp_sim >= P_MAX_DEPTH_DATA) begin
                douta_int <= 'bX;
                sbiterra_int <= 1'bX;
                dbiterra_int <= 1'bX;
              end
              else begin
                douta_int <= douta_frm_mem_ecc_out;
                sbiterra_int <= |sbita_calc;
                dbiterra_int <= |dbita_calc;
              end
              assign gen_rd_a.douta_reg = douta_int;
            end
            assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.sbiterra_in_pipe = sbiterra_int;
            assign gen_rd_a.pipeline_ecc_status.status_out_proc_a.dbiterra_in_pipe = dbiterra_int;
          end : data_gen_proc
        end : nc_prta
      end : data_out_proc_a
    end : en_dec_only
  end : ecc_behav_logic

  // -------------------------------------------------------------------------------------------------------------------
  // Asymmetry with Byte Write Enable Across Ports Implementation
  // -------------------------------------------------------------------------------------------------------------------

   if (`DISABLE_SYNTH_TEMPL) begin : gen_beh_model_bbox
    `ifndef OBSOLETE
    `ifndef DISABLE_XPM_ASSERTIONS    
     initial begin
       if(SIM_ASSERT_CHK == 1) begin : chk_vld_asym_bwe_only_configs
         /*
          Check for the following conditions,
          1. Byte writes enabled on both ports with Byte size being 8,9
          2. Byte writes are enabled on only one port and the other being word wide read
         */
         if(`MEM_PORTA_WRITE && `MEM_PORTA_WR_BYTE && `MEM_TYPE_RAM_SDP) begin
           $info("XPM_MEMORY_ASSYM_BWE-1: Configuration selected is having Byte writes on Port-A, and the Read side is word-wide Read (Memory type is set to SDP)");
         end

         if(`MEM_PORTA_WRITE && `MEM_PORTA_WR_BYTE && `MEM_TYPE_RAM_TDP) begin
           $info("XPM_MEMORY_ASSYM_BWE-2: Configuration selected is having Byte writes on Port-A, and the Read side is word-wide Read (Memory type is set to TDP)");
         end

         if(`MEM_PORTA_WR_BYTE && `MEM_PORTB_WR_BYTE &&  BYTE_WRITE_WIDTH_A == 8 && `MEM_TYPE_RAM_TDP) begin
           $info("XPM_MEMORY_ASSYM_BWE-3: Configuration selected is having Byte writes on Port-A and Port-B (Memory type is set to TDP, and byte size is 8)");
         end

         if(`MEM_PORTA_WR_BYTE && !`MEM_PORTB_WR_BYTE && `MEM_TYPE_RAM_TDP) begin
           $info("XPM_MEMORY_ASSYM_BWE-4: Configuration selected is having Byte writes on Port-A and the Read side is word-wide Read on Port-B (Memory type is set to TDP)");
         end

         if(!`MEM_PORTA_WR_BYTE && `MEM_PORTB_WR_BYTE && `MEM_TYPE_RAM_TDP) begin
           $info("XPM_MEMORY_ASSYM_BWE-5: Configuration selected is having Byte writes on Port-B and the Read side is word-wide Read on Port-A (Memory type is set to TDP)");
         end

         if(`MEM_PORTA_WR_BYTE && `MEM_PORTB_WR_BYTE && BYTE_WRITE_WIDTH_A == 9 && `MEM_TYPE_RAM_TDP) begin
           $info("XPM_MEMORY_ASSYM_BWE-6: Configuration selected is having Byte writes (byte width is 9) on Port-A and Port-B (Memory type is set to TDP)");
         end
       end : chk_vld_asym_bwe_only_configs
     end
    `endif
    `endif
    
    localparam READ_DATA_WIDTH_A_ECC_ASYM = `NO_ECC ? READ_DATA_WIDTH_A : P_MIN_WIDTH_DATA_ECC;
    localparam READ_DATA_WIDTH_B_ECC_ASYM = `NO_ECC ? READ_DATA_WIDTH_B : P_MIN_WIDTH_DATA_ECC;
    localparam logic [READ_DATA_WIDTH_A_ECC_ASYM-1:0] rsta_val_asym = `ASYNC_RESET_A ? {READ_DATA_WIDTH_A_ECC_ASYM{1'b0}} : rst_val_conv_a(READ_RESET_VALUE_A);
    localparam logic [READ_DATA_WIDTH_B_ECC_ASYM-1:0] rstb_val_asym = `ASYNC_RESET_B ? {READ_DATA_WIDTH_B_ECC_ASYM{1'b0}} : rst_val_conv_b(READ_RESET_VALUE_B);

     if(`MEM_PORTA_WRITE) begin : gen_wr_a_asymbwe
       if(`MEM_PORTA_WR_BYTE) begin : gen_wr_bwe
         if(`MEM_PORTA_WR_NARROW) begin : gen_byte_narrow
           reg [P_MIN_WIDTH_DATA_ECC-1:0] i_tmp_dat_storage_a = 0;
           reg [READ_DATA_WIDTH_A-1:0] o_tmp_dat_storage_a = rsta_val_asym;
           if(`MEM_PORTA_READ && `MEM_PORTA_WF) begin : port_a_write_read
             always @(posedge clka) begin : wr_dat
               if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|wea_i) begin
                   i_tmp_dat_storage_a = mem[addra_i];
                   for(integer byte_cnt=1; byte_cnt<=P_NUM_COLS_WRITE_A; byte_cnt=byte_cnt+1) begin
                     if(wea_i[byte_cnt-1]) begin
                       i_tmp_dat_storage_a[(byte_cnt*BYTE_WRITE_WIDTH_A)-1 -: BYTE_WRITE_WIDTH_A] = dina_i[(byte_cnt*BYTE_WRITE_WIDTH_A)-1 -: BYTE_WRITE_WIDTH_A];
                     end
                   end
                   mem[addra_i] <= i_tmp_dat_storage_a;
                 end
               end
             end : wr_dat
             if(READ_LATENCY_A == 1) begin : gen_narrow_wf_rd_reg
               if(`ASYNC_RESET_A) begin 
                 always @(posedge rsta or posedge clka) begin : wr_dat_rd
                   if(rsta)
                     o_tmp_dat_storage_a <= rsta_val_asym;
                   else begin
                     for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                       if (ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                         if (|wea_i) begin
                           if (wea_i[col])
                             o_tmp_dat_storage_a[`ONE_COL_OF_DINA] <= dina_i[`ONE_COL_OF_DINA];
                           else
                             o_tmp_dat_storage_a[`ONE_COL_OF_DINA] <= mem[addra_i][`ONE_COL_OF_DINA];
                         end else begin
                           o_tmp_dat_storage_a <= mem[addra_i];
                         end
                       end
                     end
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end : wr_dat_rd
               end 
               else begin
                 always @(posedge clka) begin : wr_dat_rd
                   if(rsta)
                     o_tmp_dat_storage_a <= rsta_val_asym;
                   else begin
                     for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                       if (ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                         if (|wea_i) begin
                           if (wea_i[col])
                             o_tmp_dat_storage_a[`ONE_COL_OF_DINA] <= dina_i[`ONE_COL_OF_DINA];
                           else
                             o_tmp_dat_storage_a[`ONE_COL_OF_DINA] <= mem[addra_i][`ONE_COL_OF_DINA];
                         end else begin
                           o_tmp_dat_storage_a <= mem[addra_i];
                         end
                       end
                     end
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end : wr_dat_rd
               end 
             end : gen_narrow_wf_rd_reg
             else begin: gen_narrow_wf_rd_pipe
               always @(posedge clka) begin : wr_dat_rd
                 for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                   if (ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     if (|wea_i) begin
                       if (wea_i[col])
                         o_tmp_dat_storage_a[`ONE_COL_OF_DINA] <= dina_i[`ONE_COL_OF_DINA];
                       else
                         o_tmp_dat_storage_a[`ONE_COL_OF_DINA] <= mem[addra_i][`ONE_COL_OF_DINA];
                     end else begin
                       o_tmp_dat_storage_a <= mem[addra_i];
                     end
                   end
                 end
                 assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
               end : wr_dat_rd
             end : gen_narrow_wf_rd_pipe
           end : port_a_write_read
           else begin : port_a_write_only
             always @(posedge clka) begin : wr_dat
               if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|wea_i) begin
                   i_tmp_dat_storage_a = mem[addra_i];
                   for(integer byte_cnt=1; byte_cnt<=P_NUM_COLS_WRITE_A; byte_cnt=byte_cnt+1) begin
                     if(wea_i[byte_cnt-1]) begin
                       i_tmp_dat_storage_a[(byte_cnt*BYTE_WRITE_WIDTH_A)-1 -: BYTE_WRITE_WIDTH_A] = dina_i[(byte_cnt*BYTE_WRITE_WIDTH_A)-1 -: BYTE_WRITE_WIDTH_A];
                     end
                   end
                   mem[addra_i] <= i_tmp_dat_storage_a;
                 end
               end
             end : wr_dat
           end : port_a_write_only
         end : gen_byte_narrow
         else if(`MEM_PORTA_WR_WIDE) begin : gen_byte_wide
           reg [WRITE_DATA_WIDTH_A-1:0] i_tmp_dat_storage_a = 0;
           wire [P_WIDTH_ADDR_WRITE_A-1:0] addra_effctv = addra_i;
           reg [P_WIDTH_ADDR_LSB_WRITE_A-1:0] addr_shft = 0;
           reg [P_WIDTH_ADDR_LSB_WRITE_A-1:0] addr_shft_rd = 0;
           reg [READ_DATA_WIDTH_A-1:0] o_tmp_dat_storage_a = rsta_val_asym;
           if(`MEM_PORTA_WF && `MEM_PORTA_READ) begin : port_a_write_read
             always @(posedge clka) begin : wr_dat_tmp
               for (integer row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin 
                 for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                   if (ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     addr_shft = row;
                     if (wea_i[row*P_NUM_COLS_WRITE_A+col]) begin
                       i_tmp_dat_storage_a[`ONE_ROW_COL_OF_DINA] = dina_i[`ONE_ROW_COL_OF_DINA];
                     end else begin
                       i_tmp_dat_storage_a[`ONE_ROW_COL_OF_DINA] = mem[{addra_i, addr_shft}][`ONE_COL_OF_DINA];
                     end
                   end
                 end 
               end 
             end : wr_dat_tmp
             always @(posedge clka) begin : wr_dat
               for (integer row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin 
                 for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                   if (ena_i & wea_i[row*P_NUM_COLS_WRITE_A+col] & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     addr_shft = row;
                     mem[{addra_i, addr_shft}][`ONE_COL_OF_DINA] = dina_i[`ONE_ROW_COL_OF_DINA];
                   end
                 end 
               end 
             end : wr_dat
             if(READ_LATENCY_A == 1) begin : gen_narrow_wf_rd_reg
               if(`ASYNC_RESET_A) begin 
                 always @(posedge rsta or posedge clka) begin : wr_dat_rd
                   if(rsta)
                     o_tmp_dat_storage_a <= rsta_val_asym;
                   else begin
                     if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|wea_i) begin
                          for (integer row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin 
                            for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                              if (ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                                addr_shft = row;
                                if (wea_i[row*P_NUM_COLS_WRITE_A+col]) begin
                                  o_tmp_dat_storage_a[`ONE_ROW_COL_OF_DINA] <= dina_i[`ONE_ROW_COL_OF_DINA];
                                end else begin
                                  o_tmp_dat_storage_a[`ONE_ROW_COL_OF_DINA] <= mem[{addra_i, addr_shft}][`ONE_COL_OF_DINA];
                                end
                              end
                            end 
                          end 
                       end
                       else begin
                         for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                           begin
                             addr_shft_rd = word_cnt-1;
                             o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft_rd}];
                           end
                       end
                     end
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end : wr_dat_rd
               end 
               else begin
                 always @(posedge clka) begin : wr_dat_rd
                   if(rsta)
                     o_tmp_dat_storage_a <= rsta_val_asym;
                   else begin
                     if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|wea_i) begin
                          for (integer row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin 
                            for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                              if (ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                                addr_shft = row;
                                if (wea_i[row*P_NUM_COLS_WRITE_A+col]) begin
                                  o_tmp_dat_storage_a[`ONE_ROW_COL_OF_DINA] <= dina_i[`ONE_ROW_COL_OF_DINA];
                                end else begin
                                  o_tmp_dat_storage_a[`ONE_ROW_COL_OF_DINA] <= mem[{addra_i, addr_shft}][`ONE_COL_OF_DINA];
                                end
                              end
                            end 
                          end 
                       end
                       else begin
                         for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                           begin
                             addr_shft_rd = word_cnt-1;
                             o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft_rd}];
                           end
                       end
                     end
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end : wr_dat_rd
               end 
             end : gen_narrow_wf_rd_reg
             else begin: gen_narrow_wf_rd_pipe
               always @(posedge clka) begin : wr_dat_rd
                 if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   if(|wea_i) begin
                      for (integer row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin 
                        for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                          if (ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                            addr_shft = row;
                            if (wea_i[row*P_NUM_COLS_WRITE_A+col]) begin
                              o_tmp_dat_storage_a[`ONE_ROW_COL_OF_DINA] <= dina_i[`ONE_ROW_COL_OF_DINA];
                            end else begin
                              o_tmp_dat_storage_a[`ONE_ROW_COL_OF_DINA] <= mem[{addra_i, addr_shft}][`ONE_COL_OF_DINA];
                            end
                          end
                        end 
                      end 
                   end
                   else begin
                     for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft_rd = word_cnt-1;
                         o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft_rd}];
                       end
                   end
                 end
                 assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
               end : wr_dat_rd
             end : gen_narrow_wf_rd_pipe
           end : port_a_write_read
           else begin : port_a_write_only
             always @(posedge clka) begin : wr_dat
               if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|wea_i) begin
                   for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                     begin
                       addr_shft = word_cnt-1;
                       i_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] = mem[{addra_effctv,addr_shft}];
                     end
                   for(integer byte_cnt=1; byte_cnt<=WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A; byte_cnt=byte_cnt+1) begin
                     if(wea_i[byte_cnt-1]) begin
                       i_tmp_dat_storage_a[(byte_cnt*BYTE_WRITE_WIDTH_A)-1 -: BYTE_WRITE_WIDTH_A] = dina_i[(byte_cnt*BYTE_WRITE_WIDTH_A)-1 -: BYTE_WRITE_WIDTH_A];
                     end
                   end
                   for(integer word_cnt_mem=1; word_cnt_mem<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt_mem=word_cnt_mem+1) 
                     begin
                       addr_shft = word_cnt_mem-1;
                       mem[{addra_effctv,addr_shft}] <= i_tmp_dat_storage_a[(word_cnt_mem*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC];
                     end
                   end
                 end
               end : wr_dat
             end : port_a_write_only
         end : gen_byte_wide
       end : gen_wr_bwe
       else begin : gen_wr_word
         if(`MEM_PORTA_WR_NARROW) begin : gen_word_narrow
           reg [READ_DATA_WIDTH_A-1:0] o_tmp_dat_storage_a = rsta_val_asym;
           if(`MEM_PORTA_READ && `MEM_PORTA_WF) begin : port_a_write_read
             always @(posedge clka) begin : wr_dat
               if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|wea_i) begin
                   mem[addra_i] <= dina_i;
                 end
               end
             end : wr_dat
             if(READ_LATENCY_A == 1) begin : gen_narrow_wf_rd_reg
               if(`ASYNC_RESET_A) begin 
                 always @(posedge rsta or posedge clka) begin : wr_dat_rd
                   if(rsta)
                     o_tmp_dat_storage_a <= rsta_val_asym;
                   else begin
                     if(ena_i && ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|wea_i)
                         o_tmp_dat_storage_a <= dina_i;
                       else
                         o_tmp_dat_storage_a <= mem[addra_i];
                     end 
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end : wr_dat_rd
               end 
               else begin
                 always @(posedge clka) begin : wr_dat_rd
                   if(rsta)
                     o_tmp_dat_storage_a <= rsta_val_asym;
                   else begin
                     if(ena_i && ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|wea_i)
                         o_tmp_dat_storage_a <= dina_i;
                       else
                         o_tmp_dat_storage_a <= mem[addra_i];
                     end 
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end : wr_dat_rd
               end 
             end : gen_narrow_wf_rd_reg
             else begin: gen_narrow_wf_rd_pipe
               always @(posedge clka) begin : wr_dat_rd
                 if(ena_i && ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   if(|wea_i)
                     o_tmp_dat_storage_a <= dina_i;
                   else
                     o_tmp_dat_storage_a <= mem[addra_i];
                 end 
                 assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
               end : wr_dat_rd
             end : gen_narrow_wf_rd_pipe
           end : port_a_write_read
           else begin : port_a_write_only
             always @(posedge clka) begin : wr_dat
               if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|wea_i) begin
                   mem[addra_i] <= dina_i;
                 end
               end
             end : wr_dat
           end : port_a_write_only
         end : gen_word_narrow
         else if(`MEM_PORTA_WR_WIDE) begin : gen_word_wide
           wire [P_WIDTH_ADDR_WRITE_A-1:0] addra_effctv = addra_i;
           reg [P_WIDTH_ADDR_LSB_WRITE_A-1:0] addr_shft = 0;
           reg [READ_DATA_WIDTH_A-1:0] o_tmp_dat_storage_a = rsta_val_asym;
           reg [P_WIDTH_ADDR_LSB_WRITE_A-1:0] addr_shft_rd = 0;

           if(`MEM_PORTA_READ && `MEM_PORTA_WF) begin : port_a_write_read
             always @(posedge clka) begin : wr_dat
               if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|wea_i) begin
                   for(integer word_cnt_mem=1; word_cnt_mem<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt_mem=word_cnt_mem+1) 
                     begin
                       addr_shft = word_cnt_mem-1;
                       mem[{addra_effctv,addr_shft}] <= dina_i[(word_cnt_mem*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC];
                     end
                 end
               end
             end : wr_dat
             if(READ_LATENCY_A == 1) begin : gen_narrow_wf_rd_reg
               if(`ASYNC_RESET_A) begin 
                 always @(posedge rsta or posedge clka) begin : wr_dat_rd
                   if(rsta)
                     o_tmp_dat_storage_a <= rsta_val_asym;
                   else begin
                     if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|wea_i)
                         o_tmp_dat_storage_a <= dina_i;
                       else begin
                         for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                           begin
                             addr_shft_rd = word_cnt-1;
                             o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft_rd}];
                           end
                       end
                     end 
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end : wr_dat_rd
               end 
               else begin
                 always @(posedge clka) begin : wr_dat_rd
                   if(rsta)
                     o_tmp_dat_storage_a <= rsta_val_asym;
                   else begin
                     if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|wea_i)
                         o_tmp_dat_storage_a <= dina_i;
                       else begin
                         for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                           begin
                             addr_shft_rd = word_cnt-1;
                             o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft_rd}];
                           end
                       end
                     end 
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end : wr_dat_rd
               end 
             end : gen_narrow_wf_rd_reg
             else begin: gen_narrow_wf_rd_pipe
               always @(posedge clka) begin : wr_dat_rd
                 if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   if(|wea_i)
                     o_tmp_dat_storage_a <= dina_i;
                   else begin
                     for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft_rd = word_cnt-1;
                         o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft_rd}];
                       end
                   end
                 end 
                 assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
               end : wr_dat_rd
             end : gen_narrow_wf_rd_pipe
           end : port_a_write_read
           else begin : port_a_write_only
             always @(posedge clka) begin : wr_dat
               if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|wea_i) begin
                   for(integer word_cnt_mem=1; word_cnt_mem<=WRITE_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt_mem=word_cnt_mem+1) 
                     begin
                       addr_shft = word_cnt_mem-1;
                       mem[{addra_effctv,addr_shft}] <= dina_i[(word_cnt_mem*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC];
                     end
                 end
               end
             end : wr_dat
           end : port_a_write_only
         end : gen_word_wide
       end : gen_wr_word
     end : gen_wr_a_asymbwe

     if(`MEM_PORTA_READ) begin : gen_rd_a_asymbwe
       //initial douta_bb = rsta_val_asym;
       if(`MEM_PORTA_RD_NARROW) begin : gen_rda_narrow
         reg [READ_DATA_WIDTH_A-1:0] o_tmp_dat_storage_a = rsta_val_asym;
         if(`MEM_PORTA_RF) begin : gen_narrow_rf
           if(READ_LATENCY_A == 1) begin : gen_narrow_rf_reg
             if(`ASYNC_RESET_A) begin 
               always @(posedge rsta or posedge clka) begin : rd_dat
                 if(rsta) begin
                   assign gen_rd_a.douta_reg = rsta_val_asym;
                   o_tmp_dat_storage_a <= rsta_val_asym;
                 end
                 else begin
                   if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     o_tmp_dat_storage_a <= mem[addra_i];
                     assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                   end
                 end
               end : rd_dat
             end 
             else begin
               always @(posedge clka) begin : rd_dat
                 if(rsta) begin
                   assign gen_rd_a.douta_reg = rsta_val_asym;
                   o_tmp_dat_storage_a <= rsta_val_asym;
                 end
                 else begin
                   if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     o_tmp_dat_storage_a <= mem[addra_i];
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end
               end : rd_dat
             end 
           end : gen_narrow_rf_reg
           else begin: gen_narrow_rf_pipe
             always @(posedge clka) begin : rd_dat
                 if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   o_tmp_dat_storage_a <= mem[addra_i];
                 end
                 assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
             end : rd_dat
           end : gen_narrow_rf_pipe
         end : gen_narrow_rf
         else if (`MEM_PORTA_NC) begin : gen_narrow_nc
           if(READ_LATENCY_A == 1) begin : gen_narrow_nc_reg
             if(`ASYNC_RESET_A) begin 
               always @(posedge rsta or posedge clka) begin : rd_dat
                 if(rsta) begin
                   assign gen_rd_a.douta_reg = rsta_val_asym;
                   o_tmp_dat_storage_a <= rsta_val_asym;
                 end
                 else begin
                   if(ena_i & ~(|wea_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     o_tmp_dat_storage_a <= mem[addra_i];
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end
               end : rd_dat
             end 
             else begin
               always @(posedge clka) begin : rd_dat
                 if(rsta) begin
                   assign gen_rd_a.douta_reg = rsta_val_asym;
                   o_tmp_dat_storage_a <= rsta_val_asym;
                 end
                 else begin
                   if(ena_i & ~(|wea_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     o_tmp_dat_storage_a <= mem[addra_i];
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end
               end : rd_dat
             end 
           end : gen_narrow_nc_reg
           else begin: gen_narrow_nc_pipe
             always @(posedge clka) begin : rd_dat
               if(ena_i & ~(|wea_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 o_tmp_dat_storage_a <= mem[addra_i];
               end
               assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
             end : rd_dat
           end : gen_narrow_nc_pipe
         end : gen_narrow_nc
       end : gen_rda_narrow
       else if(`MEM_PORTA_RD_WIDE) begin : gen_rda_wide
         reg [READ_DATA_WIDTH_A-1:0] o_tmp_dat_storage_a = rsta_val_asym;
         wire [P_WIDTH_ADDR_READ_A-1:0] addra_effctv = addra_i;
         reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addr_shft = 0;
         if(`MEM_PORTA_RF) begin : gen_narrow_rf
           if(READ_LATENCY_A == 1) begin : gen_narrow_rf_reg
             if(`ASYNC_RESET_A) begin 
               always @(posedge rsta or posedge clka) begin : rd_dat
                 if(rsta) begin
                   assign gen_rd_a.douta_reg = rsta_val_asym;
                   gen_rd_a.douta_reg <= rsta_val_asym;
                 end
                 else begin
                   if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft = word_cnt-1;
                         o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft}];
                     end
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end
               end : rd_dat
             end 
             else begin
               always @(posedge clka) begin : rd_dat
                 if(rsta)
                   assign gen_rd_a.douta_reg = rsta_val_asym;
                 else begin
                   if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft = word_cnt-1;
                         o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft}];
                     end
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end
               end : rd_dat
             end 
           end : gen_narrow_rf_reg
           else begin: gen_narrow_rf_pipe
             always @(posedge clka) begin : rd_dat
               if(ena_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                   begin
                     addr_shft = word_cnt-1;
                     o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft}];
                 end
               end
               assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
             end : rd_dat
           end : gen_narrow_rf_pipe
         end : gen_narrow_rf
         else if (`MEM_PORTA_NC) begin : gen_narrow_nc
           if(READ_LATENCY_A == 1) begin : gen_narrow_nc_reg
             if(`ASYNC_RESET_A) begin 
               always @(posedge rsta or posedge clka) begin : rd_dat
                 if(rsta)
                   assign gen_rd_a.douta_reg = rsta_val_asym;
                 else begin
                   if(ena_i & ~(|wea_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft = word_cnt-1;
                         o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft}];
                     end
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end
               end : rd_dat
             end 
             else begin
               always @(posedge clka) begin : rd_dat
                 if(rsta)
                   assign gen_rd_a.douta_reg = rsta_val_asym;
                 else begin
                   if(ena_i & ~(|wea_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft = word_cnt-1;
                         o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft}];
                     end
                   end
                   assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
                 end
               end : rd_dat
             end 
           end : gen_narrow_nc_reg
           else begin: gen_narrow_nc_pipe
             always @(posedge clka) begin : rd_dat
               if(ena_i & ~(|wea_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_A/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                   begin
                     addr_shft = word_cnt-1;
                     o_tmp_dat_storage_a[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addra_effctv,addr_shft}];
                 end
               end
               assign gen_rd_a.douta_reg = o_tmp_dat_storage_a; 
             end : rd_dat
           end : gen_narrow_nc_pipe
         end : gen_narrow_nc
       end : gen_rda_wide
     end : gen_rd_a_asymbwe
    
     if(`MEM_PORTB_WRITE) begin : gen_wr_b_asymbwe
       if(`MEM_PORTB_WR_BYTE) begin : gen_wr_bwe
         if(`MEM_PORTB_WR_NARROW) begin : gen_byte_narrow
           reg [P_MIN_WIDTH_DATA_ECC-1:0] i_tmp_dat_storage_b = 0;
           reg [READ_DATA_WIDTH_B-1:0] o_tmp_dat_storage_b = rstb_val_asym;
           if(`MEM_PORTB_WF && `MEM_PORTB_READ) begin : portb_write_read
             always @(posedge gen_rd_b.clkb_int) begin : wr_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|web_i) begin
                   i_tmp_dat_storage_b = mem[addrb_i];
                   for(integer byte_cnt=1; byte_cnt<=P_NUM_COLS_WRITE_B; byte_cnt=byte_cnt+1) begin
                     if(web_i[byte_cnt-1]) begin
                       i_tmp_dat_storage_b[(byte_cnt*BYTE_WRITE_WIDTH_B)-1 -: BYTE_WRITE_WIDTH_B] = dinb_i[(byte_cnt*BYTE_WRITE_WIDTH_B)-1 -: BYTE_WRITE_WIDTH_B];
                     end
                   end
                   mem[addrb_i] <= i_tmp_dat_storage_b;
                 end
               end
             end : wr_dat
             if(READ_LATENCY_B == 1) begin : gen_narrow_wf_rd_reg
               if(`ASYNC_RESET_B) begin 
                 always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
                       if (enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                         if (|web_i) begin
                           if (web_i[col])
                             o_tmp_dat_storage_b[`ONE_COL_OF_DINB] <= dinb_i[`ONE_COL_OF_DINB];
                           else
                             o_tmp_dat_storage_b[`ONE_COL_OF_DINB] <= mem[addrb_i][`ONE_COL_OF_DINB];
                         end else begin
                           o_tmp_dat_storage_b <= mem[addrb_i];
                         end
                       end
                     end
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : wr_dat_rd
               end 
               else begin
                 always @(posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
                       if (enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                         if (|web_i) begin
                           if (web_i[col])
                             o_tmp_dat_storage_b[`ONE_COL_OF_DINB] <= dinb_i[`ONE_COL_OF_DINB];
                           else
                             o_tmp_dat_storage_b[`ONE_COL_OF_DINB] <= mem[addrb_i][`ONE_COL_OF_DINB];
                         end else begin
                           o_tmp_dat_storage_b <= mem[addrb_i];
                         end
                       end
                     end
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : wr_dat_rd
               end 
             end : gen_narrow_wf_rd_reg
             else begin: gen_narrow_wf_rd_pipe
               always @(posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                 for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
                   if (enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     if (|web_i) begin
                       if (web_i[col])
                         o_tmp_dat_storage_b[`ONE_COL_OF_DINB] <= dinb_i[`ONE_COL_OF_DINB];
                       else
                         o_tmp_dat_storage_b[`ONE_COL_OF_DINB] <= mem[addrb_i][`ONE_COL_OF_DINB];
                     end else begin
                       o_tmp_dat_storage_b <= mem[addrb_i];
                     end
                   end
                 end
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : wr_dat_rd
             end : gen_narrow_wf_rd_pipe
           end : portb_write_read
           else begin : portb_write_only
             always @(posedge gen_rd_b.clkb_int) begin : wr_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|web_i) begin
                   i_tmp_dat_storage_b = mem[addrb_i];
                   for(integer byte_cnt=1; byte_cnt<=P_NUM_COLS_WRITE_B; byte_cnt=byte_cnt+1) begin
                     if(web_i[byte_cnt-1]) begin
                       i_tmp_dat_storage_b[(byte_cnt*BYTE_WRITE_WIDTH_B)-1 -: BYTE_WRITE_WIDTH_B] = dinb_i[(byte_cnt*BYTE_WRITE_WIDTH_B)-1 -: BYTE_WRITE_WIDTH_B];
                     end
                   end
                   mem[addrb_i] <= i_tmp_dat_storage_b;
                 end
               end
             end : wr_dat
           end : portb_write_only
         end : gen_byte_narrow
         else if(`MEM_PORTB_WR_WIDE) begin : gen_byte_wide
           reg [WRITE_DATA_WIDTH_B-1:0] i_tmp_dat_storage_b = 0;
           reg [READ_DATA_WIDTH_B-1:0] o_tmp_dat_storage_b = rstb_val_asym;
           wire [P_WIDTH_ADDR_WRITE_B-1:0] addrb_effctv = addrb_i;
           reg [P_WIDTH_ADDR_LSB_WRITE_B-1:0] addr_shft = 0;
           reg [P_WIDTH_ADDR_LSB_WRITE_B-1:0] addr_shft_rd = 0;
           if(`MEM_PORTB_WF && `MEM_PORTB_READ) begin : portb_write_read
             always @(posedge gen_rd_b.clkb_int) begin : wr_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|web_i) begin
                   for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                     begin
                       addr_shft = word_cnt-1;
                       i_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] = mem[{addrb_effctv,addr_shft}];
                     end
                   for(integer byte_cnt=1; byte_cnt<=WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B; byte_cnt=byte_cnt+1) begin
                     if(web_i[byte_cnt-1]) begin
                       i_tmp_dat_storage_b[(byte_cnt*BYTE_WRITE_WIDTH_B)-1 -: BYTE_WRITE_WIDTH_B] = dinb_i[(byte_cnt*BYTE_WRITE_WIDTH_B)-1 -: BYTE_WRITE_WIDTH_B];
                     end
                   end
                   for(integer word_cnt_mem=1; word_cnt_mem<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt_mem=word_cnt_mem+1) 
                     begin
                       addr_shft = word_cnt_mem-1;
                       mem[{addrb_effctv,addr_shft}] <= i_tmp_dat_storage_b[(word_cnt_mem*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC];
                     end
                 end
               end
             end : wr_dat
             if(READ_LATENCY_B == 1) begin : gen_narrow_wf_rd_reg
               if(`ASYNC_RESET_B) begin 
                 always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|web_i) begin
                          for (integer row=0; row<P_NUM_ROWS_WRITE_B; row=row+1) begin 
                            for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
                              if (enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                                addr_shft = row;
                                if (web_i[row*P_NUM_COLS_WRITE_B+col]) begin
                                  o_tmp_dat_storage_b[`ONE_ROW_COL_OF_DINB] <= dinb_i[`ONE_ROW_COL_OF_DINB];
                                end else begin
                                  o_tmp_dat_storage_b[`ONE_ROW_COL_OF_DINB] <= mem[{addrb_i, addr_shft}][`ONE_COL_OF_DINB];
                                end
                              end
                            end 
                          end 
                       end
                       else begin
                         for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                           begin
                             addr_shft_rd = word_cnt-1;
                             o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft_rd}];
                           end
                       end
                     end 
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : wr_dat_rd
               end 
               else begin
                 always @(posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|web_i) begin
                          for (integer row=0; row<P_NUM_ROWS_WRITE_B; row=row+1) begin 
                            for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
                              if (enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                                addr_shft = row;
                                if (web_i[row*P_NUM_COLS_WRITE_B+col]) begin
                                  o_tmp_dat_storage_b[`ONE_ROW_COL_OF_DINB] <= dinb_i[`ONE_ROW_COL_OF_DINB];
                                end else begin
                                  o_tmp_dat_storage_b[`ONE_ROW_COL_OF_DINB] <= mem[{addrb_i, addr_shft}][`ONE_COL_OF_DINB];
                                end
                              end
                            end 
                          end 
                       end
                       else begin
                         for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                           begin
                             addr_shft_rd = word_cnt-1;
                             o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft_rd}];
                           end
                       end
                     end 
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : wr_dat_rd
               end 
             end : gen_narrow_wf_rd_reg
             else begin: gen_narrow_wf_rd_pipe
               always @(posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                 if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   if(|web_i) begin
                      for (integer row=0; row<P_NUM_ROWS_WRITE_B; row=row+1) begin 
                        for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
                          if (enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                            addr_shft = row;
                            if (web_i[row*P_NUM_COLS_WRITE_B+col]) begin
                              o_tmp_dat_storage_b[`ONE_ROW_COL_OF_DINB] <= dinb_i[`ONE_ROW_COL_OF_DINB];
                            end else begin
                              o_tmp_dat_storage_b[`ONE_ROW_COL_OF_DINB] <= mem[{addrb_i, addr_shft}][`ONE_COL_OF_DINB];
                            end
                          end
                        end 
                      end 
                   end
                   else begin
                     for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft_rd = word_cnt-1;
                         o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft_rd}];
                       end
                   end
                 end 
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : wr_dat_rd
             end : gen_narrow_wf_rd_pipe
           end : portb_write_read
           else begin : portb_write_only
             always @(posedge gen_rd_b.clkb_int) begin : wr_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|web_i) begin
                   for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                     begin
                       addr_shft = word_cnt-1;
                       i_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] = mem[{addrb_effctv,addr_shft}];
                     end
                   for(integer byte_cnt=1; byte_cnt<=WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B; byte_cnt=byte_cnt+1) begin
                     if(web_i[byte_cnt-1]) begin
                       i_tmp_dat_storage_b[(byte_cnt*BYTE_WRITE_WIDTH_B)-1 -: BYTE_WRITE_WIDTH_B] = dinb_i[(byte_cnt*BYTE_WRITE_WIDTH_B)-1 -: BYTE_WRITE_WIDTH_B];
                     end
                   end
                   for(integer word_cnt_mem=1; word_cnt_mem<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt_mem=word_cnt_mem+1) 
                     begin
                       addr_shft = word_cnt_mem-1;
                       mem[{addrb_effctv,addr_shft}] <= i_tmp_dat_storage_b[(word_cnt_mem*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC];
                     end
                 end
               end
             end : wr_dat
           end : portb_write_only
         end : gen_byte_wide
       end : gen_wr_bwe
       else begin : gen_wr_word
         if(`MEM_PORTB_WR_NARROW) begin : gen_word_narrow
           reg [READ_DATA_WIDTH_B-1:0] o_tmp_dat_storage_b = rstb_val_asym;
           if(`MEM_PORTB_WF && `MEM_PORTB_READ) begin : portb_write_read
             always @(posedge gen_rd_b.clkb_int) begin : wr_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|web_i) begin
                   mem[addrb_i] <= dinb_i;
                 end
               end
             end : wr_dat
             if(READ_LATENCY_B == 1) begin : gen_narrow_wf_rd_reg
               if(`ASYNC_RESET_B) begin 
                 always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|web_i)
                         o_tmp_dat_storage_b <= dinb_i;
                       else
                         o_tmp_dat_storage_b <= mem[addrb_i];
                     end 
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : wr_dat_rd
               end 
               else begin
                 always @(posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|web_i)
                         o_tmp_dat_storage_b <= dinb_i;
                       else
                         o_tmp_dat_storage_b <= mem[addrb_i];
                     end 
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : wr_dat_rd
               end 
             end : gen_narrow_wf_rd_reg
             else begin: gen_narrow_wf_rd_pipe
               always @(posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                 if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   if(|web_i)
                     o_tmp_dat_storage_b <= dinb_i;
                   else
                     o_tmp_dat_storage_b <= mem[addrb_i];
                 end 
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : wr_dat_rd
             end : gen_narrow_wf_rd_pipe
           end : portb_write_read
           else begin : portb_write_only
             always @(posedge gen_rd_b.clkb_int) begin : wr_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|web_i) begin
                   mem[addrb_i] <= dinb_i;
                 end
               end
             end : wr_dat
           end : portb_write_only
         end : gen_word_narrow
         else if(`MEM_PORTB_WR_WIDE) begin : gen_word_wide
           wire [P_WIDTH_ADDR_WRITE_B-1:0] addrb_effctv = addrb_i;
           reg [P_WIDTH_ADDR_LSB_WRITE_B-1:0] addr_shft = 0;
           reg [P_WIDTH_ADDR_LSB_WRITE_B-1:0] addr_shft_rd = 0;
           reg [READ_DATA_WIDTH_B-1:0] o_tmp_dat_storage_b = rstb_val_asym;
           if(`MEM_PORTB_WF && `MEM_PORTB_READ) begin : portb_write_read
             always @(posedge gen_rd_b.clkb_int) begin : wr_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|web_i) begin
                   for(integer word_cnt_mem=1; word_cnt_mem<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt_mem=word_cnt_mem+1) 
                     begin
                       addr_shft = word_cnt_mem-1;
                       mem[{addrb_effctv,addr_shft}] <= dinb_i[(word_cnt_mem*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC];
                     end
                 end
               end
             end : wr_dat
             if(READ_LATENCY_B == 1) begin : gen_narrow_wf_rd_reg
               if(`ASYNC_RESET_B) begin 
                 always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|web_i)
                         o_tmp_dat_storage_b <= dinb_i;
                       else begin
                         for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                           begin
                             addr_shft_rd = word_cnt-1;
                             o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft_rd}];
                           end
                       end
                     end 
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : wr_dat_rd
               end 
               else begin
                 always @(posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       if(|web_i)
                         o_tmp_dat_storage_b <= dinb_i;
                       else begin
                         for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                           begin
                             addr_shft_rd = word_cnt-1;
                             o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft_rd}];
                           end
                       end
                     end 
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : wr_dat_rd
               end 
             end : gen_narrow_wf_rd_reg
             else begin: gen_narrow_wf_rd_pipe
               always @(posedge gen_rd_b.clkb_int) begin : wr_dat_rd
                 if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   if(|web_i)
                     o_tmp_dat_storage_b <= dinb_i;
                   else begin
                     for(integer word_cnt=1; word_cnt<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft_rd = word_cnt-1;
                         o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft_rd}];
                       end
                   end
                 end 
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : wr_dat_rd
             end : gen_narrow_wf_rd_pipe
           end : portb_write_read
           else begin : portb_write_only
             always @(posedge gen_rd_b.clkb_int) begin : wr_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 if(|web_i) begin
                   for(integer word_cnt_mem=1; word_cnt_mem<=WRITE_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt_mem=word_cnt_mem+1) 
                     begin
                       addr_shft = word_cnt_mem-1;
                       mem[{addrb_effctv,addr_shft}] <= dinb_i[(word_cnt_mem*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC];
                     end
                 end
               end
             end : wr_dat
           end : portb_write_only
         end : gen_word_wide
       end : gen_wr_word
     end : gen_wr_b_asymbwe

     if(`MEM_PORTB_READ) begin : gen_rd_b_asymbwe
       //initial doutb_bb = rstb_val_asym;
       if(`MEM_PORTB_RD_NARROW) begin : gen_rdb_narrow
         reg [READ_DATA_WIDTH_B-1:0] o_tmp_dat_storage_b = rstb_val_asym;
         reg [P_WIDTH_ADDR_WRITE_B-1:0] addrb_reg = {P_WIDTH_ADDR_WRITE_B{1'b0}};
         if(`MEM_PORTB_RF) begin : gen_narrow_rf
           if(READ_LATENCY_B == 1) begin : gen_narrow_rf_reg
             if(`ASYNC_RESET_B) begin 
               always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : rd_dat
                 if(rstb)
                   o_tmp_dat_storage_b <= rstb_val_asym;
                 else begin
                   if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     o_tmp_dat_storage_b <= mem[addrb_i];
                   end
                 end
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : rd_dat
             end 
             else begin
               always @(posedge gen_rd_b.clkb_int) begin : rd_dat
                 if(rstb)
                   o_tmp_dat_storage_b <= rstb_val_asym;
                 else begin
                   if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     o_tmp_dat_storage_b <= mem[addrb_i];
                   end
                 end
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : rd_dat
             end 
           end : gen_narrow_rf_reg
           else begin: gen_narrow_rf_pipe
             always @(posedge gen_rd_b.clkb_int) begin : rd_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 o_tmp_dat_storage_b <= mem[addrb_i];
               end
               assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
             end : rd_dat
           end : gen_narrow_rf_pipe
         end : gen_narrow_rf
         else if (`MEM_PORTB_NC) begin : gen_narrow_nc
           if(READ_LATENCY_B == 1) begin : gen_narrow_nc_reg
             if(`ASYNC_RESET_B) begin 
               always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : rd_dat
                 if(rstb)
                   o_tmp_dat_storage_b <= rstb_val_asym;
                 else begin
                   if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     o_tmp_dat_storage_b <= mem[addrb_i];
                   end
                 end
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : rd_dat
             end 
             else begin
               always @(posedge gen_rd_b.clkb_int) begin : rd_dat
                 if(rstb)
                   o_tmp_dat_storage_b <= rstb_val_asym;
                 else begin
                   if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     o_tmp_dat_storage_b <= mem[addrb_i];
                   end
                 end
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : rd_dat
             end 
           end : gen_narrow_nc_reg
           else begin: gen_narrow_nc_pipe
             always @(posedge gen_rd_b.clkb_int) begin : rd_dat
               if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 o_tmp_dat_storage_b <= mem[addrb_i];
               end
               assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
             end : rd_dat
           end : gen_narrow_nc_pipe
         end : gen_narrow_nc
         else if (`MEM_PORTB_WF) begin : gen_narrow_wf
           if (`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_SDP) begin : gen_wf_narrow_pipe_ultra_sdp
             if(READ_LATENCY_B == 1) begin : gen_narrow_wf_reg
               if(`ASYNC_RESET_B) begin 
                 always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : rd_dat
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       o_tmp_dat_storage_b <= mem[addrb_i];
                     end
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : rd_dat
               end 
               else begin
                 always @(posedge gen_rd_b.clkb_int) begin : rd_dat
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       o_tmp_dat_storage_b <= mem[addrb_i];
                     end
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : rd_dat
               end 
             end : gen_narrow_wf_reg
             else begin: gen_narrow_wf_pipe
                 always @(posedge gen_rd_b.clkb_int) begin
                   addrb_reg <= addrb_i;
                 end
                 always @(*) begin
                   o_tmp_dat_storage_b = mem[addrb_reg];
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end
             end : gen_narrow_wf_pipe
           end : gen_wf_narrow_pipe_ultra_sdp
         end : gen_narrow_wf
       end : gen_rdb_narrow
       else if(`MEM_PORTB_RD_WIDE) begin : gen_rdb_wide
         reg [READ_DATA_WIDTH_B-1:0] o_tmp_dat_storage_b = rstb_val_asym;
         reg [P_WIDTH_ADDR_WRITE_B-1:0] addrb_reg = {P_WIDTH_ADDR_WRITE_B{1'b0}};
         wire [P_WIDTH_ADDR_READ_B-1:0] addrb_effctv = addrb_i;
         reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addr_shft = 0;
         if(`MEM_PORTB_RF) begin : gen_narrow_rf
           if(READ_LATENCY_B == 1) begin : gen_narrow_rf_reg
             if(`ASYNC_RESET_B) begin 
               always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : rd_dat
                 if(rstb)
                   o_tmp_dat_storage_b <= rstb_val_asym;
                 else begin
                   if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft = word_cnt-1;
                         o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft}];
                     end
                   end
                 end
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : rd_dat
             end 
             else begin
               always @(posedge gen_rd_b.clkb_int) begin : rd_dat
                 if(rstb)
                   o_tmp_dat_storage_b <= rstb_val_asym;
                 else begin
                   if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft = word_cnt-1;
                         o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft}];
                     end
                   end
                 end
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : rd_dat
             end 
           end : gen_narrow_rf_reg
           else begin: gen_narrow_rf_pipe
             always @(posedge gen_rd_b.clkb_int) begin : rd_dat
               if(enb_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                   begin
                     addr_shft = word_cnt-1;
                     o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft}];
                 end
               end
               assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
             end : rd_dat
           end : gen_narrow_rf_pipe
         end : gen_narrow_rf
         else if (`MEM_PORTB_NC) begin : gen_narrow_nc
           if(READ_LATENCY_B == 1) begin : gen_narrow_nc_reg
             if(`ASYNC_RESET_B) begin 
               always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : rd_dat
                 if(rstb)
                   o_tmp_dat_storage_b <= rstb_val_asym;
                 else begin
                   if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft = word_cnt-1;
                         o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft}];
                     end
                   end
                 end
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : rd_dat
             end 
             else begin
               always @(posedge gen_rd_b.clkb_int) begin : rd_dat
                 if(rstb)
                   o_tmp_dat_storage_b <= rstb_val_asym;
                 else begin
                   if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                     for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                       begin
                         addr_shft = word_cnt-1;
                         o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft}];
                     end
                   end
                 end
                 assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
               end : rd_dat
             end 
           end : gen_narrow_nc_reg
           else begin: gen_narrow_nc_pipe
             always @(posedge gen_rd_b.clkb_int) begin : rd_dat
               if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                 for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                   begin
                     addr_shft = word_cnt-1;
                     o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft}];
                 end
               end
               assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
             end : rd_dat
           end : gen_narrow_nc_pipe
         end : gen_narrow_nc
         else if (`MEM_PORTB_WF) begin : gen_narrow_wf
           if (`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_SDP) begin : gen_wf_wide_pipe_ultra_sdp
             if(READ_LATENCY_B == 1) begin : gen_narrow_wf_reg
               if(`ASYNC_RESET_B) begin 
                 always @(posedge rstb or posedge gen_rd_b.clkb_int) begin : rd_dat
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                         begin
                           addr_shft = word_cnt-1;
                           o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft}];
                       end
                     end
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : rd_dat
               end 
               else begin
                 always @(posedge gen_rd_b.clkb_int) begin : rd_dat
                   if(rstb)
                     o_tmp_dat_storage_b <= rstb_val_asym;
                   else begin
                     if(enb_i & ~(|web_i) & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                       for(integer word_cnt=1; word_cnt<=READ_DATA_WIDTH_B/P_MIN_WIDTH_DATA_ECC; word_cnt=word_cnt+1) 
                         begin
                           addr_shft = word_cnt-1;
                           o_tmp_dat_storage_b[(word_cnt*P_MIN_WIDTH_DATA_ECC)-1 -: P_MIN_WIDTH_DATA_ECC] <= mem[{addrb_effctv,addr_shft}];
                       end
                     end
                   end
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : rd_dat
               end 
             end : gen_narrow_wf_reg
             else begin: gen_narrow_wf_pipe
                 always @(posedge gen_rd_b.clkb_int) begin
                   addrb_reg <= addrb_i;
                 end
                 always @(*) begin : rd_comb
                   integer row;
                   reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb;
                   for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin : for_mem_rows
                     addrblsb = row;
                     o_tmp_dat_storage_b[`ONE_ROW_OF_DIN] = mem[{addrb_reg, addrblsb}];
                   end : for_mem_rows
                   assign gen_rd_b.doutb_reg = o_tmp_dat_storage_b; 
                 end : rd_comb
             end : gen_narrow_wf_pipe
           end : gen_wf_wide_pipe_ultra_sdp
         end : gen_narrow_wf
       end : gen_rdb_wide
     end : gen_rd_b_asymbwe
   end : gen_beh_model_bbox

  // -------------------------------------------------------------------------------------------------------------------
  // Auto Sleep Mode behavioral Modeling
  // This involves the following steps:
  // 1. Implement a counter to check the number of in-active cycles
  // 2. If the Number of in-active cycles is greater than Auto sleep latency,
  // then force the data output to 'x'
  // 3. Sampling Enable has to happen on both the ports in case of TDP/SDP, if
  // both ports are in-active, then only push the memory into Auto Sleep
  // -------------------------------------------------------------------------------------------------------------------

    if(`MEM_AUTO_SLP_EN) begin : gen_alsp_model
      // Maximum Auto Sleep latency is 15, declare count of width 4, and width to be
      // fine-tuned as per the latency
      reg [3:0] ena_activity_cnt = 'b0;
      reg [3:0] enb_activity_cnt = 'b0;
      reg aslp_mode_active_a = 'b1;
      reg aslp_mode_active_b = 'b1;
      wire aslp_mode_active;

      always @(posedge clka) begin
        if(~ena) begin
          if(ena_activity_cnt >= AUTO_SLEEP_TIME)
            ena_activity_cnt <= ena_activity_cnt;
          else
            ena_activity_cnt <= ena_activity_cnt + 1'b1;
        end
        else
          ena_activity_cnt <= 'b0;
      end
      // Enable pipe line Delay Enable by Auto Sleep Number of times
      reg ena_aslp_pipe [AUTO_SLEEP_TIME-1:0];
        // Initialize the ena pipeline
        initial begin
          integer aslp_initstage_a;
          for (aslp_initstage_a=0; aslp_initstage_a < AUTO_SLEEP_TIME; aslp_initstage_a=aslp_initstage_a+1) begin : for_en_pipe_init
            ena_aslp_pipe[aslp_initstage_a] = 1'b0;
          end : for_en_pipe_init
        end

      // This code may needs to be mode up
      always @(posedge clka)
        begin
          ena_aslp_pipe[0]    <= ena;
        end
      for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
        always @(posedge clka) begin
          ena_aslp_pipe[aslp_stage]   <= ena_aslp_pipe[aslp_stage-1];
        end
      end : gen_aslp_inp_pipe


      always @(posedge clka) begin
        if(ena_aslp_pipe[AUTO_SLEEP_TIME-2])
          aslp_mode_active_a = 1'b0;
        else begin 
          if(ena_aslp_pipe[AUTO_SLEEP_TIME-1] == 1'b0 && ena_activity_cnt >= AUTO_SLEEP_TIME)
            aslp_mode_active_a <= 1'b1;
        end
      end
     // Place Memory to Auto sleep only when there is no activity on both ports
     assign aslp_mode_active = aslp_mode_active_a & aslp_mode_active_b;

      // Assign delayed enable to "en_i" for the memory write to happen
      always @(posedge clka) begin
        force ena_i = ena_aslp_pipe[AUTO_SLEEP_TIME-1];
      end
      if (READ_LATENCY_A == 1) begin : aslp_en_a
        if(`ASYNC_RESET_A) begin  : async_aslp_en_a
          always @(posedge rsta or posedge clka) begin
            if(rsta) begin
              force douta = gen_rd_a.rsta_val;
            end
            else begin
              if(aslp_mode_active) begin
                force douta = 'bX;
              end
              else begin
                if(`MEM_PORTA_NC) begin
                  if(ena_i & ~(|wea_i)) begin
                    release douta;
                  end
                end
                else begin
                  if(ena_i) begin
                    release douta;
                  end
                end
              end
            end
          end
        end  : async_aslp_en_a
        else begin : sync_aslp_en_a
          always @(posedge clka) begin
            if(rsta) begin
              force douta = gen_rd_a.rsta_val;
            end
            else begin
              if(aslp_mode_active) begin
                force douta = 'bX;
              end
              else begin
                if(`MEM_PORTA_NC) begin
                  if(ena_i & ~(|wea_i)) begin
                    release douta;
                  end
                end
                else begin
                  if(ena_i) begin
                    release douta;
                  end
                end
              end
            end
          end
        end : sync_aslp_en_a
        always @(posedge clka) begin
          if(rsta) begin
            force sbiterra = 1'b0;
            force dbiterra = 1'b0;
          end
          else begin
            if(aslp_mode_active) begin
              force sbiterra = 'bX;
              force dbiterra = 'bX;
            end
            else begin
              if(`MEM_PORTA_NC) begin
                if(ena_i & ~(|wea_i)) begin
                  release sbiterra;
                  release dbiterra;
                end
              end
              else begin
                if(ena_i) begin
                  release sbiterra;
                  release dbiterra;
                end
              end
            end
          end
        end
      end : aslp_en_a
      if(`MEM_PORTB_READ) begin : gen_aslp_b_rd
        reg enb_aslp_pipe [AUTO_SLEEP_TIME-1:0];
        // Initialize the enb pipelines
        initial begin
          integer aslp_initstage_b;
          for (aslp_initstage_b=0; aslp_initstage_b<AUTO_SLEEP_TIME; aslp_initstage_b=aslp_initstage_b+1) begin : for_en_pipe_init
            enb_aslp_pipe[aslp_initstage_b] = 1'b0;
          end : for_en_pipe_init
        end

        always @(posedge gen_auto_slp_dly_b.clkb_int) begin
          if(~enb) begin
            if(enb_activity_cnt >= AUTO_SLEEP_TIME)
              enb_activity_cnt <= enb_activity_cnt;
            else
              enb_activity_cnt <= enb_activity_cnt + 1'b1;
          end
          else
            enb_activity_cnt <= 'b0;
        end

        always @(posedge gen_auto_slp_dly_b.clkb_int) begin
          if(enb_aslp_pipe[AUTO_SLEEP_TIME-2])
            aslp_mode_active_b = 1'b0;
          else begin 
            if(enb_aslp_pipe[AUTO_SLEEP_TIME-1] == 1'b0 && enb_activity_cnt >= AUTO_SLEEP_TIME)
              aslp_mode_active_b <= 1'b1;
          end
        end
        // Delay the Enable, this code may needs to be mode up
        always @(posedge gen_auto_slp_dly_b.clkb_int)
          begin
            enb_aslp_pipe[0]    <= enb;
          end
        for (genvar aslp_stage=1; aslp_stage < AUTO_SLEEP_TIME; aslp_stage = aslp_stage+1) begin : gen_aslp_inp_pipe
          always @(posedge gen_auto_slp_dly_b.clkb_int) begin
            enb_aslp_pipe[aslp_stage]   <= enb_aslp_pipe[aslp_stage-1];
          end
        end : gen_aslp_inp_pipe
        // Assign delayed enable to "en_i" for the memory write to happen
        always @(posedge gen_auto_slp_dly_b.clkb_int) begin
          force enb_i = enb_aslp_pipe[AUTO_SLEEP_TIME-1];
        end
        if (READ_LATENCY_B == 1) begin : aslp_en_b
          //always @(posedge gen_auto_slp_dly_b.clkb_int) begin
        if(`ASYNC_RESET_B) begin : async_aslp_en_b
          always @(posedge rstb or posedge clka) begin // sampling on clka to make to sure that both ports drive-x at the same time
            if(rstb) begin
              force doutb = gen_rd_b.rstb_val;
            end
            else begin
              if(aslp_mode_active) begin
                force doutb = 'bX;
              end
              else begin
                if(`MEM_PORTB_NC) begin
                  if(enb_i & ~(|web_i)) begin
                    release doutb;
                  end
                end
                else begin
                  if(enb_i) begin
                    release doutb;
                  end
                end
              end
            end
          end
        end : async_aslp_en_b
        else begin : sync_aslp_en_b
          always @(posedge clka) begin // sampling on clka to make to sure that both ports drive-x at the same time
            if(rstb) begin
              force doutb = gen_rd_b.rstb_val;
            end
            else begin
              if(aslp_mode_active) begin
                force doutb = 'bX;
              end
              else begin
                if(`MEM_PORTB_NC) begin
                  if(enb_i & ~(|web_i)) begin
                    release doutb;
                  end
                end
                else begin
                  if(enb_i) begin
                    release doutb;
                  end
                end
              end
            end
          end
        end : sync_aslp_en_b
          always @(posedge clka) begin // sampling on clka to make to sure that both ports drive-x at the same time
            if(rstb) begin
              force sbiterrb = 1'b0;
              force dbiterrb = 1'b0;
            end
            else begin
              if(aslp_mode_active) begin
                force sbiterrb = 'bX;
                force dbiterrb = 'bX;
              end
              else begin
                if(`MEM_PORTB_NC) begin
                  if(enb_i & ~(|web_i)) begin
                    release sbiterrb;
                    release dbiterrb;
                  end
                end
                else begin
                  if(enb_i) begin
                    release sbiterrb;
                    release dbiterrb;
                  end
                end
              end
            end
          end
        end : aslp_en_b
      end : gen_aslp_b_rd

      `ifndef OBSOLETE
    `ifndef DISABLE_XPM_ASSERTIONS

         wire clkb_int;
         if (`COMMON_CLOCK) begin 
           assign clkb_int = clka;
         end 
         else if (`INDEPENDENT_CLOCKS) begin
           assign clkb_int = clkb;
         end
         wire [P_WIDTH_ADDR_WRITE_A-1:0] effctv_addra_aslp = addra;
         wire [P_WIDTH_ADDR_WRITE_B-1:0] effctv_addrb_aslp = addrb;
         if (`REPORT_MESSAGES && `MEM_PORTA_WRITE) begin : illegal_wr_ena_aslp
           assert property (@(posedge clka)
             !(ena && |wea && (addra > effctv_addra_aslp) ))
           else
             $warning("XPM_MEMORY_OUT_OF_RANGE_WRITE_ACCESS : Write Operation on Port-A to an out-of-range address at time %0t; Actual Address --> %0h , effective address is %0h.There is a chance that data at the effective address location may get written in the synthesis netlist, and there by the simulation mismatch can occur between behavioral model and netlist simulations", $time,addra,effctv_addra_aslp);
         end : illegal_wr_ena_aslp
       
         if (`REPORT_MESSAGES && `MEM_PORTB_WRITE) begin : illegal_wr_enb_aslp
           assert property (@(posedge clkb_int)
             !(enb && |web && (addrb > effctv_addrb_aslp) ))
           else
             $warning("XPM_MEMORY_OUT_OF_RANGE_WRITE_ACCESS : Write Operation on Port-B to an out-of-range address at time %0t; Actual Address --> %0h , effective address is %0h.There is a chance that data at the effective address location may get written in the synthesis netlist, and there by the simulation mismatch can occur between behavioral model and netlist simulations", $time,addrb,effctv_addrb_aslp);
         end : illegal_wr_enb_aslp

         if (`REPORT_MESSAGES && `MEM_PORTA_WRITE && `MEM_PORTA_NC) begin : unsupported_wr_ena
           assert property (@(posedge clka)
             !(aslp_mode_active && ena && |wea))
           else
             $warning("XPM_MEMORY_WR_IN_ASLP_NC : Write Operation on Port-A at time %0t when in Auto Sleep mode and the write mode is set to No_Change, at address : addra(%h);behavioral and netlist simulation may not match for the data output corresponding to this write operation.", $time,addra);
         end : unsupported_wr_ena

         if (`REPORT_MESSAGES && `MEM_PORTB_WRITE && `MEM_PORTB_NC) begin : unsupported_wr_enb
           assert property (@(posedge clkb_int)
             !(aslp_mode_active && enb && |web))
           else
             $warning("XPM_MEMORY_WR_IN_ASLP_NC : Write Operation on Port-B at time %0t when in Auto Sleep mode and the write mode is set to No_Change, at address : addrb(%h); behavioral and netlist simulation may not match for the data output corresponding to this write operation.", $time,addrb);
         end : unsupported_wr_enb

         if(SIM_ASSERT_CHK == 1) begin : chk_vld_aslp_configs
           if(`MEM_AUTO_SLP_EN && `MEM_PRIM_ULTRA) begin : assrt_chks_aslp
             assert property (@(posedge clka)
               !(ena_activity_cnt >= AUTO_SLEEP_TIME))
               $info("XPM_MEMORY_ASLP_EN: ena is active, and the memory cannot enter Auto Sleep Mode");
             else
               $info("XPM_MEMORY_ASLP_EN: ena in-active (%t) for more than AUTO_SLEEP_TIME", $time);
  
             if(`MEM_PORTB_READ || `MEM_PORTB_WRITE) begin : assrt_chks_aslp_b
               assert property (@(posedge clkb)
                 !(enb_activity_cnt >= AUTO_SLEEP_TIME))
                 $info("XPM_MEMORY_ASLP_EN: enb is active, and the memory cannot enter Auto Sleep Mode");
               else
                 $info("XPM_MEMORY_ASLP_EN: enb in-active (%t) for more than AUTO_SLEEP_TIME", $time);
               assert property (@(posedge clka)
                 !(aslp_mode_active & (ena & ~enb)))
               else
                 $info("XPM_MEMORY_ASLP_EN: Memory is in AUTO_SLEEP, and Port-A enable (ena) alone is asserted at time (%t) to bring the memory to active mode.", $time);
  
               assert property (@(posedge clkb)
                 !(aslp_mode_active & (~ena & enb)))
               else
                 $info("XPM_MEMORY_ASLP_EN: Memory is in AUTO_SLEEP, and Port-B enable (enb) alone is asserted at time (%t) to bring the memory to active mode.", $time);
             end : assrt_chks_aslp_b
           end : assrt_chks_aslp
         end : chk_vld_aslp_configs
      `endif
      `endif
    end : gen_alsp_model

  // UltraRAM TDP mode Modeling
  // below conditions to be taken care.
  /** If both ports are executing read and write for the same address, : 
    //If port A is writing, port B is reading, then port B reads new data.
    //If port A is reading, port B is writing, then port A reads the old data.
    //If port A and B are writing, then port B write overwrites the port A write. At the end of the clock cycle, the memory stores port B write data.
  **/
  // <TBD> When the address does not overlap - then do we need to model any behavior?

  if (`MEM_PRIM_ULTRA && `MEM_TYPE_RAM_TDP && `NO_ECC) begin : uram_tdp_model

    reg [P_MIN_WIDTH_DATA-1:0] mem_col [0:P_MAX_DEPTH_DATA-1];
    reg [READ_DATA_WIDTH_A-1 : 0] douta_col = 0;
    reg [READ_DATA_WIDTH_B-1 : 0] doutb_col = 0;
    wire [P_WIDTH_ADDR_WRITE_A-1:0] addra_int = addra_i;
    wire [P_WIDTH_ADDR_WRITE_B-1:0] addrb_int ;
    wire rstb_int;
    wire enb_int;
    wire [(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B)-1:0] web_int ;
    wire [READ_DATA_WIDTH_B-1 : 0] dinb_int;
    wire #1 clkb_int_i = gen_rd_b.clkb_int; 

    assign #2 addrb_int =  addrb_i;
    assign #2 rstb_int =  rstb;
    assign #2 enb_int =  enb_i;
    assign #2  web_int =  web_i;
    assign #2  dinb_int =  dinb_i;

    integer row;
    reg [P_WIDTH_ADDR_LSB_WRITE_A-1:0] addralsb;
    reg [P_WIDTH_ADDR_LSB_READ_A-1:0] addralsb_rd;
    reg [P_WIDTH_ADDR_LSB_WRITE_B-1:0] addrblsb;
    reg [P_WIDTH_ADDR_LSB_READ_B-1:0] addrblsb_rd;
    // Memory Array Initialization
    //initial begin
    //  integer col_initword;
    //  for (col_initword=0; col_initword<P_MAX_DEPTH_DATA; col_initword=col_initword+1) begin
    //    mem_col[col_initword] = {P_MIN_WIDTH_DATA{1'b0}};
    //  end
    //end

    // Initialize memory array to the data file content if file name is specified, or to all zeroes if it is not specified
    initial begin
      if (`NO_MEMORY_INIT) begin : init_zeroes_uram
        integer initword;
        for (initword=0; initword<P_MAX_DEPTH_DATA; initword=initword+1) begin
          mem_col[initword] = {P_MIN_WIDTH_DATA{1'b0}};
        end
      end : init_zeroes_uram
      else if (!(MEMORY_INIT_PARAM == "0" || MEMORY_INIT_PARAM == "")) begin : init_param_uram
        reg [P_MAX_DEPTH_DATA-1:0] [P_MIN_WIDTH_DATA-1:0] mem_param;
        num_char_in_param = num_char_init(MEMORY_INIT_PARAM);
        assert (num_char_in_param <= MAX_NUM_CHAR) // Check if the string length exceeds the depth of the memory size
        else
          $error("No.of characters given in the Initialization Parameter string exceeds the Memory Size");
        mem_param = init_param_memory({MEMORY_INIT_PARAM, 8'h0}); //Append NULL to identify the end of string
        for(integer mem_location=0; mem_location<P_MAX_DEPTH_DATA; mem_location=mem_location+1)
          mem_col[mem_location] = mem_param[mem_location]; //assign the initial value to the memory
      end : init_param_uram   
      else begin : init_datafile_uram
          #10;
        $readmemh(MEMORY_INIT_FILE, mem_col, 0, P_MAX_DEPTH_DATA-1);
      end : init_datafile_uram
    end

    // Synchronous port A write; byte-wide write; port width is the narrowest of the data ports
    // For UltraRAM, there is no Asymmetry
//Port-A
    if(`ASYNC_RESET_A) begin : async_rst_a
      if(`MEM_PORTA_RD_REG) begin : async_rd_rl1
        always @(posedge clka or posedge rsta) begin
          if(rsta)
            douta_col <= {READ_DATA_WIDTH_A{1'b0}};
          else begin
            if(ena_i & ~|wea_i)  begin 
              if (`MEM_PORTA_NC && `MEM_PORTA_RD_WIDE ) begin 
                 for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin 
                   addralsb_rd = row;
                   douta_col[`ONE_ROW_OF_DIN] <= mem_col[{addra_i, addralsb_rd}];
                 end 
              end
              else 
                  douta_col <= mem_col[addra_i];
            end
          end
          force gen_rd_a.douta_reg = douta_col;
        end
      end : async_rd_rl1
      else begin : async_rd_rl_n
        always @(posedge clka) begin
          if(ena_i & ~|wea_i)  begin 
            if (`MEM_PORTA_NC && `MEM_PORTA_RD_WIDE ) begin 
               for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin 
                 addralsb_rd = row;
                 douta_col[`ONE_ROW_OF_DIN] <= mem_col[{addra_i, addralsb_rd}];
               end 
            end
            else 
                douta_col <= mem_col[addra_i];
          end
          force gen_rd_a.douta_reg = douta_col;
        end
      end : async_rd_rl_n
      always @(posedge clka) begin
        if(`MEM_PORTA_WR_BYTE) begin
          if (`MEM_PORTA_WR_WIDE ) begin
             for (row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin 
               for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                 if (ena_i & wea_i[row*P_NUM_COLS_WRITE_A+col] & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   addralsb = row;
                   mem_col[{addra_i, addralsb}][`ONE_COL_OF_DINA] = dina_i[`ONE_ROW_COL_OF_DINA];
                 end
               end 
             end 
          end 
          else begin 
            for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
              if (ena_i & wea_i[col] & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))
                mem_col[addra_i][`ONE_COL_OF_DINA] = dina_i[`ONE_COL_OF_DINA];
            end
          end
        end
        else begin
          if (ena_i & |wea_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
              if (`MEM_PORTA_WR_WIDE ) begin 
                 for (row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin 
                   addralsb = row;
                   mem_col[{addra_i, addralsb}] = dina_i[`ONE_ROW_OF_DIN];
                 end 
              end
              else 
                mem_col[addra_int] = dina_i;
          end
        end
      end
    end  : async_rst_a
    else begin : sync_rst_a
      always @(posedge clka) begin
        if(rsta && READ_LATENCY_A == 1)
          douta_col <= {READ_DATA_WIDTH_A{1'b0}};
        else begin
          if(ena_i & ~|wea_i)  begin 
            if (`MEM_PORTA_NC && `MEM_PORTA_RD_WIDE ) begin 
               for (row=0; row<P_NUM_ROWS_READ_A; row=row+1) begin 
                 addralsb_rd = row;
                 douta_col[`ONE_ROW_OF_DIN] <= mem_col[{addra_i, addralsb_rd}];
               end 
            end
            else 
                douta_col <= mem_col[addra_i];
          end
        end
        if(`MEM_PORTA_WR_BYTE) begin
          if (`MEM_PORTA_WR_WIDE ) begin
             for (row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin 
               for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
                 if (ena_i & wea_i[row*P_NUM_COLS_WRITE_A+col] & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   addralsb = row;
                   mem_col[{addra_i, addralsb}][`ONE_COL_OF_DINA] = dina_i[`ONE_ROW_COL_OF_DINA];
                 end
               end
             end 
          end 
          else begin 
            for (integer col=0; col<P_NUM_COLS_WRITE_A; col=col+1) begin
              if (ena_i & wea_i[col] & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))
                mem_col[addra_i][`ONE_COL_OF_DINA] = dina_i[`ONE_COL_OF_DINA];
            end
          end
        end
        else begin
          if (ena_i & |wea_i & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
              if (`MEM_PORTA_WR_WIDE ) begin 
                 for (row=0; row<P_NUM_ROWS_WRITE_A; row=row+1) begin 
                   addralsb = row;
                   mem_col[{addra_i, addralsb}] = dina_i[`ONE_ROW_OF_DIN];
                 end 
              end
              else 
                mem_col[addra_int] = dina_i;
          end
        end
        force gen_rd_a.douta_reg = douta_col;
      end
    end  : sync_rst_a
//Port-B
    if(`ASYNC_RESET_B) begin
      if(READ_LATENCY_B == 1) begin
        always @(posedge clkb_int_i or posedge rstb_int) begin
          if(rstb_int)
            doutb_col <= {READ_DATA_WIDTH_B{1'b0}};
          else begin
            if(enb_int & ~|web_int) begin 
              if (`MEM_PORTB_NC && `MEM_PORTB_RD_WIDE ) begin 
                 for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin 
                   addrblsb_rd = row;
                   doutb_col[`ONE_ROW_OF_DIN] <= mem_col[{addrb_int, addrblsb_rd}];
                 end 
              end
              else 
                  doutb_col = mem_col[addrb_int];
            end
          end
          force gen_rd_b.doutb_reg = doutb_col;
        end
      end
      else begin
        always @(posedge clkb_int_i) begin
          if(enb_int & ~|web_int) begin 
            if (`MEM_PORTB_NC && `MEM_PORTB_RD_WIDE ) begin 
               for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin 
                 addrblsb_rd = row;
                 doutb_col[`ONE_ROW_OF_DIN] <= mem_col[{addrb_int, addrblsb_rd}];
               end 
            end
            else 
                doutb_col = mem_col[addrb_int];
          end
          force gen_rd_b.doutb_reg = doutb_col;
        end
      end
      always @(posedge clkb_int_i) begin
        if(`MEM_PORTB_WR_BYTE) begin
          if (`MEM_PORTB_WR_WIDE ) begin
             for (row=0; row<P_NUM_ROWS_WRITE_B; row=row+1) begin 
               for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
                 if (enb_int & web_int[row*P_NUM_COLS_WRITE_B+col] & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   addrblsb = row;
                   mem_col[{addrb_int, addrblsb}][`ONE_COL_OF_DINB] = dinb_int[`ONE_ROW_COL_OF_DINB];
                 end 
               end 
             end 
          end 
          else begin 
            for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
              if (enb_int & web_int[col] & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))
                mem_col[addrb_int][`ONE_COL_OF_DINB] = dinb_int[`ONE_COL_OF_DINB];
            end
          end
        end
        else begin
          if (enb_int & |web_int & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
              if (`MEM_PORTB_WR_WIDE ) begin 
                 for (row=0; row<P_NUM_ROWS_WRITE_B; row=row+1) begin 
                   addrblsb = row;
                   mem_col[{addrb_int, addrblsb}] = dinb_int[`ONE_ROW_OF_DIN];
                 end 
              end
              else 
                mem_col[addrb_int] = dinb_int;
          end
        end
      end
    end
    else begin
      always @(posedge clkb_int_i) begin
        if(rstb_int && READ_LATENCY_B == 1)
          doutb_col <= {READ_DATA_WIDTH_B{1'b0}};
        else begin
            if(enb_int & ~|web_int) begin 
              if (`MEM_PORTB_NC && `MEM_PORTB_RD_WIDE ) begin 
                 for (row=0; row<P_NUM_ROWS_READ_B; row=row+1) begin 
                   addrblsb_rd = row;
                   doutb_col[`ONE_ROW_OF_DIN] <= mem_col[{addrb_int, addrblsb_rd}];
                 end 
              end
              else 
                  doutb_col = mem_col[addrb_int];
            end
        end
        if(`MEM_PORTB_WR_BYTE) begin
          if (`MEM_PORTB_WR_WIDE ) begin
             for (row=0; row<P_NUM_ROWS_WRITE_B; row=row+1) begin 
               for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
                 if (enb_int & web_int[row*P_NUM_COLS_WRITE_B+col] & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
                   addrblsb = row;
                   mem_col[{addrb_int, addrblsb}][`ONE_COL_OF_DINB] = dinb_int[`ONE_ROW_COL_OF_DINB];
                 end 
               end 
             end 
          end 
          else begin 
            for (integer col=0; col<P_NUM_COLS_WRITE_B; col=col+1) begin
              if (enb_int & web_int[col] & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1))
                mem_col[addrb_int][`ONE_COL_OF_DINB] = dinb_int[`ONE_COL_OF_DINB];
            end
          end
        end
        else begin
          if (enb_int & |web_int & ~(sleep_int_a == 1'b1 || sleep_int_b == 1'b1)) begin
              if (`MEM_PORTB_WR_WIDE ) begin 
                 for (row=0; row<P_NUM_ROWS_WRITE_B; row=row+1) begin 
                   addrblsb = row;
                   mem_col[{addrb_int, addrblsb}] = dinb_int[`ONE_ROW_OF_DIN];
                 end 
              end
              else 
                mem_col[addrb_int] = dinb_int;
          end
        end
        force gen_rd_b.doutb_reg = doutb_col;
      end
    end
  end : uram_tdp_model

// synthesis translate_on

  endgenerate

  // -------------------------------------------------------------------------------------------------------------------
  // Macro undefine
  // -------------------------------------------------------------------------------------------------------------------

  `undef MAX
  `undef MIN
  `undef ONE_ROW_OF_DIN
  `undef ONE_COL_OF_DINA
  `undef ONE_COL_OF_DINB
  `undef MEM_TYPE_RAM_SP
  `undef MEM_TYPE_RAM_SDP
  `undef MEM_TYPE_RAM_TDP
  `undef MEM_TYPE_ROM_SP
  `undef MEM_TYPE_ROM_DP
  `undef MEM_TYPE_RAM
  `undef MEM_TYPE_ROM
  `undef MEM_PRIM_AUTO
  `undef MEM_PRIM_DISTRIBUTED
  `undef MEM_PRIM_BLOCK
  `undef MEM_PORTA_WRITE
  `undef MEM_PORTA_READ
  `undef MEM_PORTA_WF
  `undef MEM_PORTA_RF
  `undef MEM_PORTA_NC
  `undef MEM_PORTA_WR_NARROW
  `undef MEM_PORTA_WR_WIDE
  `undef MEM_PORTA_WR_WORD
  `undef MEM_PORTA_WR_BYTE
  `undef MEM_PORTA_RD_NARROW
  `undef MEM_PORTA_RD_WIDE
  `undef MEM_PORTA_RD_COMB
  `undef MEM_PORTA_RD_REG
  `undef MEM_PORTA_RD_PIPE
  `undef MEM_PORTB_WRITE
  `undef MEM_PORTB_READ
  `undef MEM_PORTB_WF
  `undef MEM_PORTB_RF
  `undef MEM_PORTB_NC
  `undef MEM_PORTB_WR_NARROW
  `undef MEM_PORTB_WR_WIDE
  `undef MEM_PORTB_WR_WORD
  `undef MEM_PORTB_WR_BYTE
  `undef MEM_PORTB_RD_NARROW
  `undef MEM_PORTB_RD_WIDE
  `undef MEM_PORTB_RD_COMB
  `undef MEM_PORTB_RD_REG
  `undef MEM_PORTB_RD_PIPE
  `undef COMMON_CLOCK
  `undef INDEPENDENT_CLOCKS
  `undef NO_MEMORY_INIT
  `undef REPORT_MESSAGES
  `undef NO_MESSAGES
  `undef SLEEP_MODE
  `undef IS_COLLISION_A_SAFE
  `undef IS_COLLISION_B_SAFE
  `undef IS_COLLISION_SAFE
  `undef DISABLE_SYNTH_TEMPL
  `undef NO_ECC
  `undef ENC_ONLY
  `undef DEC_ONLY
  `undef BOTH_ENC_DEC
  `undef MEM_PORTA_ASYM_BWE
  `undef MEM_PORTB_ASYM_BWE 
  `undef MEM_ACRSS_PORT_ASYM_BWE 
  `undef MEM_PORT_ASYM_BWE
  `undef MEM_PORTB_URAM_LAT
  `undef EN_INIT_MESSAGE
  `undef MEM_PRIM_ULTRA
  `undef MEM_PRIM_MIXED

endmodule : xpm_memory_base

//********************************************************************************************************************
//********************************************************************************************************************

//********************************************************************************************************************

(* XPM_MODULE = "TRUE", black_box = "YES"*)
module asym_bwe_bb # (
  // Common module parameters
  parameter integer                 MEMORY_TYPE        = 2,
  parameter integer                 MEMORY_SIZE        = 2048,
  parameter integer                 MEMORY_PRIMITIVE   = 0,
  parameter integer                 CLOCKING_MODE      = 0,
  parameter                         MEMORY_INIT_FILE   = "none",
  parameter                         MEMORY_INIT_PARAM  = "",
  parameter integer                 WAKEUP_TIME        = 0,
  parameter integer                 AUTO_SLEEP_TIME    = 0,

  // Port A module parameters
  parameter integer                 WRITE_DATA_WIDTH_A = 32,
  parameter integer                 READ_DATA_WIDTH_A  = WRITE_DATA_WIDTH_A,
  parameter integer                 BYTE_WRITE_WIDTH_A = WRITE_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_A       = $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A),
  parameter                         READ_RESET_VALUE_A = "0",
  parameter integer                 READ_LATENCY_A     = 2,
  parameter integer                 WRITE_MODE_A       = 2,
  parameter                         RST_MODE_A         = "SYNC",

  // Port B module parameters
  parameter integer                 WRITE_DATA_WIDTH_B = WRITE_DATA_WIDTH_A,
  parameter integer                 READ_DATA_WIDTH_B  = WRITE_DATA_WIDTH_B,
  parameter integer                 BYTE_WRITE_WIDTH_B = WRITE_DATA_WIDTH_B,
  parameter integer                 ADDR_WIDTH_B       = $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_B),
  parameter                         READ_RESET_VALUE_B = "0",
  parameter integer                 READ_LATENCY_B     = READ_LATENCY_A,
  parameter integer                 WRITE_MODE_B       = WRITE_MODE_A,
  parameter                         RST_MODE_B         = "SYNC"

) (
  // Common module ports
  input  wire                                               sleep,

  // Port A module ports
  input  wire                                               clka,
  input  wire                                               rsta,
  input  wire                                               ena,
  input  wire                                               regcea,
  input  wire [(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0] wea,
  input  wire [ADDR_WIDTH_A-1:0]                            addra,
  input  wire [WRITE_DATA_WIDTH_A-1:0]                      dina,
  output wire [READ_DATA_WIDTH_A-1:0]                       douta,

  // Port B module ports
  input  wire                                               clkb,
  input  wire                                               rstb,
  input  wire                                               enb,
  input  wire                                               regceb,
  input  wire [(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B)-1:0] web,
  input  wire [ADDR_WIDTH_B-1:0]                            addrb,
  input  wire [WRITE_DATA_WIDTH_B-1:0]                      dinb,
  output wire [READ_DATA_WIDTH_B-1:0]                       doutb
);
endmodule : asym_bwe_bb

//********************************************************************************************************************
//********************************************************************************************************************

(* XPM_MODULE = "TRUE" *)
module xpm_memory_dpdistram # (

  // Common module parameters
  parameter integer                 MEMORY_SIZE        = 2048,
  parameter                         CLOCKING_MODE      = "common_clock",
  parameter                         MEMORY_INIT_FILE   = "none",
  parameter                         MEMORY_INIT_PARAM  = "",
  parameter integer                 USE_MEM_INIT       = 1,
  parameter integer                 USE_MEM_INIT_MMI   = 0,
  parameter integer                 MESSAGE_CONTROL    = 0,
  parameter integer                 USE_EMBEDDED_CONSTRAINT = 0,
  parameter                         MEMORY_OPTIMIZATION     = "true",
  parameter integer                 SIM_ASSERT_CHK          = 0,
  parameter integer                 IGNORE_INIT_SYNTH       = 0,

  // Port A module parameters
  parameter integer                 WRITE_DATA_WIDTH_A = 32,
  parameter integer                 READ_DATA_WIDTH_A  = WRITE_DATA_WIDTH_A,
  parameter integer                 BYTE_WRITE_WIDTH_A = WRITE_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_A       = $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A),
  parameter                         READ_RESET_VALUE_A = "0",
  parameter integer                 READ_LATENCY_A     = 2,
  parameter                         RST_MODE_A         = "SYNC",

  // Port B module parameters
  parameter integer                 READ_DATA_WIDTH_B  = READ_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_B       = $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B),
  parameter                         READ_RESET_VALUE_B = "0",
  parameter integer                 READ_LATENCY_B     = READ_LATENCY_A,
  parameter                         RST_MODE_B         = "SYNC"

) (

  // Port A module ports
  input  wire                                               clka,
  input  wire                                               rsta,
  input  wire                                               ena,
  input  wire                                               regcea,
  input  wire [(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0] wea,
  input  wire [ADDR_WIDTH_A-1:0]                            addra,
  input  wire [WRITE_DATA_WIDTH_A-1:0]                      dina,
  output wire [READ_DATA_WIDTH_A-1:0]                       douta,

  // Port B module ports
  input  wire                                               clkb,
  input  wire                                               rstb,
  input  wire                                               enb,
  input  wire                                               regceb,
  input  wire [ADDR_WIDTH_B-1:0]                            addrb,
  output wire [READ_DATA_WIDTH_B-1:0]                       doutb
);
  
  // Define local parameters for mapping with base file
  
  localparam integer P_CLOCKING_MODE         =  ( (CLOCKING_MODE == 0 || CLOCKING_MODE == "common_clock"      || CLOCKING_MODE == "COMMON_CLOCK"     ) ? 0 :
                                                ( (CLOCKING_MODE == 1 || CLOCKING_MODE == "independent_clock" || CLOCKING_MODE == "INDEPENDENT_CLOCK") ? 1 : 0));

  localparam integer P_MEMORY_OPTIMIZATION       = (MEMORY_OPTIMIZATION == "false" ? 0 : 1);

  // -------------------------------------------------------------------------------------------------------------------
  // Base module instantiation with dual port distributed RAM configuration
  // -------------------------------------------------------------------------------------------------------------------

  xpm_memory_base # (

    // Common module parameters
    .MEMORY_OPTIMIZATION      (MEMORY_OPTIMIZATION   ),
    .MEMORY_TYPE              (2                       ),
    .MEMORY_SIZE              (MEMORY_SIZE             ),
    .MEMORY_PRIMITIVE         (1                       ),
    .CLOCKING_MODE            (P_CLOCKING_MODE         ),
    .ECC_MODE                 (0                       ),
    .SIM_ASSERT_CHK           (SIM_ASSERT_CHK          ),
    .MEMORY_INIT_FILE         (MEMORY_INIT_FILE        ),
    .MEMORY_INIT_PARAM        (MEMORY_INIT_PARAM       ),
    .USE_MEM_INIT             (USE_MEM_INIT            ),
    .USE_MEM_INIT_MMI         (USE_MEM_INIT_MMI        ),
    .WAKEUP_TIME              (0                       ),
    .AUTO_SLEEP_TIME          (0                       ),
    .MESSAGE_CONTROL          (MESSAGE_CONTROL         ),
    .VERSION                  (0                       ),
    .USE_EMBEDDED_CONSTRAINT  (USE_EMBEDDED_CONSTRAINT ),
    .IGNORE_INIT_SYNTH        (IGNORE_INIT_SYNTH       ),

    // Port A module parameters
    .WRITE_DATA_WIDTH_A (WRITE_DATA_WIDTH_A),
    .READ_DATA_WIDTH_A  (READ_DATA_WIDTH_A ),
    .BYTE_WRITE_WIDTH_A (BYTE_WRITE_WIDTH_A),
    .ADDR_WIDTH_A       (ADDR_WIDTH_A      ),
    .READ_RESET_VALUE_A (READ_RESET_VALUE_A),
    .READ_LATENCY_A     (READ_LATENCY_A    ),
    .WRITE_MODE_A       (1                 ),
    .RST_MODE_A         (RST_MODE_A        ),

    // Port B module parameters
    .WRITE_DATA_WIDTH_B (READ_DATA_WIDTH_B ),
    .READ_DATA_WIDTH_B  (READ_DATA_WIDTH_B ),
    .BYTE_WRITE_WIDTH_B (READ_DATA_WIDTH_B ),
    .ADDR_WIDTH_B       (ADDR_WIDTH_B      ),
    .READ_RESET_VALUE_B (READ_RESET_VALUE_B),
    .READ_LATENCY_B     (READ_LATENCY_B    ),
    .WRITE_MODE_B       (1                 ),
    .RST_MODE_B         (RST_MODE_B        )
  ) xpm_memory_base_inst (

    // Common module ports
    .sleep          (1'b0                     ),

    // Port A module ports
    .clka           (clka                     ),
    .rsta           (rsta                     ),
    .ena            (ena                      ),
    .regcea         (regcea                   ),
    .wea            (wea                      ),
    .addra          (addra                    ),
    .dina           (dina                     ),
    .injectsbiterra (1'b0                     ),
    .injectdbiterra (1'b0                     ),
    .douta          (douta                    ),
    .sbiterra       (                         ),
    .dbiterra       (                         ),

    // Port B module ports
    .clkb           (clkb                     ),
    .rstb           (rstb                     ),
    .enb            (enb                      ),
    .regceb         (regceb                   ),
    .web            (1'b0                     ),
    .addrb          (addrb                    ),
    .dinb           ({READ_DATA_WIDTH_B{1'b0}}),
    .injectsbiterrb (1'b0                     ),
    .injectdbiterrb (1'b0                     ),
    .doutb          (doutb                    ),
    .sbiterrb       (                         ),
    .dbiterrb       (                         )
  );

endmodule : xpm_memory_dpdistram

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************

(* XPM_MODULE = "TRUE" *)
module xpm_memory_dprom # (

  // Common module parameters
  parameter integer                 MEMORY_SIZE        = 2048,
  parameter                         MEMORY_PRIMITIVE   = "auto",
  parameter                         CLOCKING_MODE      = "common_clock",
  parameter                         ECC_MODE           = "no_ecc",
  parameter                         MEMORY_INIT_FILE   = "none",
  parameter                         MEMORY_INIT_PARAM  = "",
  parameter integer                 USE_MEM_INIT       = 1,
  parameter integer                 USE_MEM_INIT_MMI   = 0,
  parameter                         WAKEUP_TIME        = "disable_sleep",
  parameter integer                 AUTO_SLEEP_TIME    = 0,
  parameter integer                 MESSAGE_CONTROL    = 0,
  parameter                         MEMORY_OPTIMIZATION     = "true",
  parameter integer                 CASCADE_HEIGHT          = 0,
  parameter integer                 SIM_ASSERT_CHK          = 0,
  parameter integer                 IGNORE_INIT_SYNTH       = 0,

  // Port A module parameters
  parameter integer                 READ_DATA_WIDTH_A  = 32,
  parameter integer                 ADDR_WIDTH_A       = $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A),
  parameter                         READ_RESET_VALUE_A = "0",
  parameter integer                 READ_LATENCY_A     = 2,
  parameter                         RST_MODE_A         = "SYNC",

  // Port B module parameters
  parameter integer                 READ_DATA_WIDTH_B  = READ_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_B       = $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B),
  parameter                         READ_RESET_VALUE_B = "0",
  parameter integer                 READ_LATENCY_B     = READ_LATENCY_A,
  parameter                         RST_MODE_B         = "SYNC"
) (

  // Common module ports
  input  wire                         sleep,

  // Port A module ports
  input  wire                         clka,
  input  wire                         rsta,
  input  wire                         ena,
  input  wire                         regcea,
  input  wire [ADDR_WIDTH_A-1:0]      addra,
  input  wire                         injectsbiterra,
  input  wire                         injectdbiterra,
  output wire [READ_DATA_WIDTH_A-1:0] douta,
  output wire                         sbiterra,
  output wire                         dbiterra,

  // Port B module ports
  input  wire                         clkb,
  input  wire                         rstb,
  input  wire                         enb,
  input  wire                         regceb,
  input  wire [ADDR_WIDTH_B-1:0]      addrb,
  input  wire                         injectsbiterrb,
  input  wire                         injectdbiterrb,
  output wire [READ_DATA_WIDTH_B-1:0] doutb,
  output wire                         sbiterrb,
  output wire                         dbiterrb
);

  // Define local parameters for mapping with base file
  localparam integer P_MEMORY_PRIMITIVE      = 
                                  ( (MEMORY_PRIMITIVE == 1 || MEMORY_PRIMITIVE == "lutram"   || MEMORY_PRIMITIVE == "LUTRAM" || MEMORY_PRIMITIVE == "distributed" || MEMORY_PRIMITIVE == "DISTRIBUTED" ) ? 1 :
                                  ( (MEMORY_PRIMITIVE == 2 || MEMORY_PRIMITIVE == "blockram" || MEMORY_PRIMITIVE == "BLOCKRAM" || MEMORY_PRIMITIVE == "block" || MEMORY_PRIMITIVE == "BLOCK" ) ? 2 :
                                  ( (MEMORY_PRIMITIVE == 3 || MEMORY_PRIMITIVE == "ultraram" || MEMORY_PRIMITIVE == "ULTRARAM" || MEMORY_PRIMITIVE == "ultra" || MEMORY_PRIMITIVE == "ULTRA") ? 3 :
                                  ( (MEMORY_PRIMITIVE == 4 || MEMORY_PRIMITIVE == "mixedram" || MEMORY_PRIMITIVE == "MIXEDRAM" || MEMORY_PRIMITIVE == "mixed" || MEMORY_PRIMITIVE == "MIXED" ) ? 4 : 0))));
  
  localparam integer P_CLOCKING_MODE         = ( (CLOCKING_MODE == 0 || CLOCKING_MODE == "common_clock"      || CLOCKING_MODE == "COMMON_CLOCK"     ) ? 0 :
                                               ( (CLOCKING_MODE == 1 || CLOCKING_MODE == "independent_clock" || CLOCKING_MODE == "INDEPENDENT_CLOCK") ? 1 : 0));

  localparam integer P_ECC_MODE              = ( (ECC_MODE  == 0  || ECC_MODE  == "no_ecc"                 || ECC_MODE  == "NO_ECC"                ) ? 0 :
                                               ( (ECC_MODE  == 1  || ECC_MODE  == "encode_only"            || ECC_MODE  == "ENCODE_ONLY"           ) ? 1 :
                                               ( (ECC_MODE  == 2  || ECC_MODE  == "decode_only"            || ECC_MODE  == "DECODE_ONLY"           ) ? 2 :
                                               ( (ECC_MODE  == 3  || ECC_MODE  == "both_encode_and_decode" || ECC_MODE  == "BOTH_ENCODE_AND_DECODE") ? 3 : 4))));

  localparam integer P_WAKEUP_TIME           = ( (WAKEUP_TIME == 2 || WAKEUP_TIME == "use_sleep_pin"    || WAKEUP_TIME == "USE_SLEEP_PIN") ? 2 : 0 );

  localparam integer P_MEMORY_OPTIMIZATION   = (MEMORY_OPTIMIZATION == "false" ? 0 : 1);

  // -------------------------------------------------------------------------------------------------------------------
  // Base module instantiation with dual port ROM configuration
  // -------------------------------------------------------------------------------------------------------------------

  xpm_memory_base # (

    // Common module parameters
    .MEMORY_OPTIMIZATION      (MEMORY_OPTIMIZATION   ),
    .MEMORY_TYPE        (4                 ),
    .MEMORY_SIZE        (MEMORY_SIZE       ),
    .MEMORY_PRIMITIVE   (P_MEMORY_PRIMITIVE),
    .CLOCKING_MODE      (P_CLOCKING_MODE   ),
    .ECC_MODE           (P_ECC_MODE        ),
    .SIM_ASSERT_CHK     (SIM_ASSERT_CHK    ),
    .MEMORY_INIT_FILE   (MEMORY_INIT_FILE  ),
    .MEMORY_INIT_PARAM  (MEMORY_INIT_PARAM ),
    .USE_MEM_INIT       (USE_MEM_INIT      ),
    .USE_MEM_INIT_MMI   (USE_MEM_INIT_MMI  ),
    .WAKEUP_TIME        (P_WAKEUP_TIME     ),
    .AUTO_SLEEP_TIME    (AUTO_SLEEP_TIME   ),
    .MESSAGE_CONTROL    (MESSAGE_CONTROL   ),
    .VERSION            (0                 ),
    .USE_EMBEDDED_CONSTRAINT  (0 ),
    .CASCADE_HEIGHT     (CASCADE_HEIGHT  ),
    .IGNORE_INIT_SYNTH        (IGNORE_INIT_SYNTH       ),

    // Port A module parameters
    .WRITE_DATA_WIDTH_A (READ_DATA_WIDTH_A ),
    .READ_DATA_WIDTH_A  (READ_DATA_WIDTH_A ),
    .BYTE_WRITE_WIDTH_A (READ_DATA_WIDTH_A ),
    .ADDR_WIDTH_A       (ADDR_WIDTH_A      ),
    .READ_RESET_VALUE_A (READ_RESET_VALUE_A),
    .READ_LATENCY_A     (READ_LATENCY_A    ),
    .WRITE_MODE_A       (1                 ),
    .RST_MODE_A         (RST_MODE_A        ),

    // Port B module parameters
    .WRITE_DATA_WIDTH_B (READ_DATA_WIDTH_B ),
    .READ_DATA_WIDTH_B  (READ_DATA_WIDTH_B ),
    .BYTE_WRITE_WIDTH_B (READ_DATA_WIDTH_B ),
    .ADDR_WIDTH_B       (ADDR_WIDTH_B      ),
    .READ_RESET_VALUE_B (READ_RESET_VALUE_B),
    .READ_LATENCY_B     (READ_LATENCY_B    ),
    .WRITE_MODE_B       (1                 ),
    .RST_MODE_B         (RST_MODE_B        )
  ) xpm_memory_base_inst (

    // Common module ports
    .sleep          (sleep                    ),

    // Port A module ports
    .clka           (clka                     ),
    .rsta           (rsta                     ),
    .ena            (ena                      ),
    .regcea         (regcea                   ),
    .wea            (1'b0                     ),
    .addra          (addra                    ),
    .dina           ({READ_DATA_WIDTH_A{1'b0}}),
    .injectsbiterra (injectsbiterra           ),
    .injectdbiterra (injectdbiterra           ),
    .douta          (douta                    ),
    .sbiterra       (sbiterra                 ),
    .dbiterra       (dbiterra                 ),

    // Port B module ports
    .clkb           (clkb                     ),
    .rstb           (rstb                     ),
    .enb            (enb                      ),
    .regceb         (regceb                   ),
    .web            (1'b0                     ),
    .addrb          (addrb                    ),
    .dinb           ({READ_DATA_WIDTH_B{1'b0}}),
    .injectsbiterrb (injectsbiterrb           ),
    .injectdbiterrb (injectdbiterrb           ),
    .doutb          (doutb                    ),
    .sbiterrb       (sbiterrb                 ),
    .dbiterrb       (dbiterrb                 )
  );

endmodule : xpm_memory_dprom

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************

(* XPM_MODULE = "TRUE" *)
module xpm_memory_sdpram # (
  
  // Common module parameters
  parameter integer                 MEMORY_SIZE        = 2048,
  parameter                         MEMORY_PRIMITIVE   = "auto",
  parameter                         CLOCKING_MODE      = "common_clock",
  parameter                         ECC_MODE           = "no_ecc",
  parameter                         MEMORY_INIT_FILE   = "none",
  parameter                         MEMORY_INIT_PARAM  = "",
  parameter integer                 USE_MEM_INIT       = 1,
  parameter integer                 USE_MEM_INIT_MMI   = 0,
  parameter                         WAKEUP_TIME        = "disable_sleep",
  parameter integer                 AUTO_SLEEP_TIME    = 0,
  parameter integer                 MESSAGE_CONTROL    = 0,
  parameter integer                 USE_EMBEDDED_CONSTRAINT = 0,
  parameter                         MEMORY_OPTIMIZATION     = "true",
  parameter integer                 CASCADE_HEIGHT          = 0,
  parameter integer                 SIM_ASSERT_CHK          = 0,
  parameter integer                 WRITE_PROTECT           = 1,
  parameter integer                 IGNORE_INIT_SYNTH       = 0,

  // Port A module parameters
  parameter integer                 WRITE_DATA_WIDTH_A = 32,
  parameter integer                 BYTE_WRITE_WIDTH_A = WRITE_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_A       = $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A),
  parameter                         RST_MODE_A         = "SYNC",

  // Port B module parameters
  parameter integer                 READ_DATA_WIDTH_B  = WRITE_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_B       = $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B),
  parameter                         READ_RESET_VALUE_B = "0",
  parameter integer                 READ_LATENCY_B     = 2,
  parameter                         WRITE_MODE_B       = "no_change",
  parameter                         RST_MODE_B         = "SYNC"

) (

  // Common module ports
  input  wire                                               sleep,

  // Port A module ports
  input  wire                                               clka,
  input  wire                                               ena,
  input  wire [(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0] wea,
  input  wire [ADDR_WIDTH_A-1:0]                            addra,
  input  wire [WRITE_DATA_WIDTH_A-1:0]                      dina,
  input  wire                                               injectsbiterra,
  input  wire                                               injectdbiterra,

  // Port B module ports
  input  wire                                               clkb,
  input  wire                                               rstb,
  input  wire                                               enb,
  input  wire                                               regceb,
  input  wire [ADDR_WIDTH_B-1:0]                            addrb,
  output wire [READ_DATA_WIDTH_B-1:0]                       doutb,
  output wire                                               sbiterrb,
  output wire                                               dbiterrb
);

  // Define local parameters for mapping with base file
  localparam integer P_MEMORY_PRIMITIVE      = 
                                   ( (MEMORY_PRIMITIVE == 1 || MEMORY_PRIMITIVE == "LUTRAM"   || MEMORY_PRIMITIVE == "lutram" || MEMORY_PRIMITIVE == "distributed" || MEMORY_PRIMITIVE == "DISTRIBUTED" ) ? 1 :
                                   ( (MEMORY_PRIMITIVE == 2 || MEMORY_PRIMITIVE == "BLOCKRAM" || MEMORY_PRIMITIVE == "blockram" || MEMORY_PRIMITIVE == "block" || MEMORY_PRIMITIVE == "BLOCK" ) ? 2 :
                                   ( (MEMORY_PRIMITIVE == 3 || MEMORY_PRIMITIVE == "ULTRARAM" || MEMORY_PRIMITIVE == "ultraram" || MEMORY_PRIMITIVE == "ultra" || MEMORY_PRIMITIVE == "ULTRA" ) ? 3 :
                                   ( (MEMORY_PRIMITIVE == 4 || MEMORY_PRIMITIVE == "mixedram" || MEMORY_PRIMITIVE == "MIXEDRAM" || MEMORY_PRIMITIVE == "mixed" || MEMORY_PRIMITIVE == "MIXED" ) ? 4 : 0))));
  
  localparam integer P_CLOCKING_MODE         = ( (CLOCKING_MODE == 0 || CLOCKING_MODE == "COMMON_CLOCK"      || CLOCKING_MODE == "common_clock"     )? 0 :
                                               ( (CLOCKING_MODE == 1 || CLOCKING_MODE == "INDEPENDENT_CLOCK" || CLOCKING_MODE == "independent_clock")? 1 : 0));

  localparam integer P_ECC_MODE              = ( (ECC_MODE  == 0  || ECC_MODE  == "NO_ECC"                 || ECC_MODE  == "no_ecc"                ) ? 0 :
                                               ( (ECC_MODE  == 1  || ECC_MODE  == "ENCODE_ONLY"            || ECC_MODE  == "encode_only"           ) ? 1 :
                                               ( (ECC_MODE  == 2  || ECC_MODE  == "DECODE_ONLY"            || ECC_MODE  == "decode_only"           ) ? 2 :
                                               ( (ECC_MODE  == 3  || ECC_MODE  == "BOTH_ENCODE_AND_DECODE" || ECC_MODE  == "both_encode_and_decode") ? 3 : 4))));

  localparam integer P_WAKEUP_TIME           = ( (WAKEUP_TIME == 2 || WAKEUP_TIME == "use_sleep_pin"    || WAKEUP_TIME == "USE_SLEEP_PIN") ? 2 : 0 );
  
  localparam integer P_WRITE_MODE_B          = ( (WRITE_MODE_B == 0 || WRITE_MODE_B == "WRITE_FIRST" || WRITE_MODE_B == "write_first") ? 0 :
                                               ( (WRITE_MODE_B == 1 || WRITE_MODE_B == "READ_FIRST"  || WRITE_MODE_B == "read_first")  ? 1 :
                                               ( (WRITE_MODE_B == 2 || WRITE_MODE_B == "NO_CHANGE"   || WRITE_MODE_B == "no_change")   ? 2 : 0)));

  localparam integer P_MEMORY_OPTIMIZATION       = (MEMORY_OPTIMIZATION == "false" ? 0 : 1);

  // -------------------------------------------------------------------------------------------------------------------
  // Base module instantiation with simple dual port RAM configuration
  // -------------------------------------------------------------------------------------------------------------------

  xpm_memory_base # (

    // Common module parameters
    .MEMORY_OPTIMIZATION      (MEMORY_OPTIMIZATION   ),
    .MEMORY_TYPE              (1                       ),
    .MEMORY_SIZE              (MEMORY_SIZE             ),
    .MEMORY_PRIMITIVE         (P_MEMORY_PRIMITIVE      ),
    .CLOCKING_MODE            (P_CLOCKING_MODE         ),
    .ECC_MODE                 (P_ECC_MODE              ),
    .SIM_ASSERT_CHK           (SIM_ASSERT_CHK    ),
    .MEMORY_INIT_FILE         (MEMORY_INIT_FILE        ),
    .MEMORY_INIT_PARAM        (MEMORY_INIT_PARAM       ),
    .USE_MEM_INIT             (USE_MEM_INIT            ),
    .USE_MEM_INIT_MMI         (USE_MEM_INIT_MMI        ),
    .WAKEUP_TIME              (P_WAKEUP_TIME           ),
    .AUTO_SLEEP_TIME          (AUTO_SLEEP_TIME         ),
    .MESSAGE_CONTROL          (MESSAGE_CONTROL         ),
    .VERSION                  (0                       ),
    .USE_EMBEDDED_CONSTRAINT  (USE_EMBEDDED_CONSTRAINT ),
    .CASCADE_HEIGHT           (CASCADE_HEIGHT          ),
    .WRITE_PROTECT            (WRITE_PROTECT           ),
    .IGNORE_INIT_SYNTH        (IGNORE_INIT_SYNTH       ),

    // Port A module parameters
    .WRITE_DATA_WIDTH_A (WRITE_DATA_WIDTH_A        ),
    .READ_DATA_WIDTH_A  (WRITE_DATA_WIDTH_A        ),
    .BYTE_WRITE_WIDTH_A (BYTE_WRITE_WIDTH_A        ),
    .ADDR_WIDTH_A       (ADDR_WIDTH_A              ),
    .READ_RESET_VALUE_A ("0"                       ),
    .READ_LATENCY_A     (2                         ),
    .WRITE_MODE_A       (P_WRITE_MODE_B            ),
    .RST_MODE_A         (RST_MODE_A                ),

    // Port B module parameters
    .WRITE_DATA_WIDTH_B (READ_DATA_WIDTH_B         ),
    .READ_DATA_WIDTH_B  (READ_DATA_WIDTH_B         ),
    .BYTE_WRITE_WIDTH_B (READ_DATA_WIDTH_B         ),
    .ADDR_WIDTH_B       (ADDR_WIDTH_B              ),
    .READ_RESET_VALUE_B (READ_RESET_VALUE_B        ),
    .READ_LATENCY_B     (READ_LATENCY_B            ),
    .WRITE_MODE_B       (P_WRITE_MODE_B            ),
    .RST_MODE_B         (RST_MODE_B                )
  ) xpm_memory_base_inst (

    // Common module ports
    .sleep          (sleep                    ),

    // Port A module ports
    .clka           (clka                     ),
    .rsta           (1'b0                     ),
    .ena            (ena                      ),
    .regcea         (1'b0                     ),
    .wea            (wea                      ),
    .addra          (addra                    ),
    .dina           (dina                     ),
    .injectsbiterra (injectsbiterra           ),
    .injectdbiterra (injectdbiterra           ),
    .douta          (                         ),
    .sbiterra       (                         ),
    .dbiterra       (                         ),

    // Port B module ports
    .clkb           (clkb                     ),
    .rstb           (rstb                     ),
    .enb            (enb                      ),
    .regceb         (regceb                   ),
    .web            (1'b0                     ),
    .addrb          (addrb                    ),
    .dinb           ({READ_DATA_WIDTH_B{1'b0}}),
    .injectsbiterrb (1'b0                     ),
    .injectdbiterrb (1'b0                     ),
    .doutb          (doutb                    ),
    .sbiterrb       (sbiterrb                 ),
    .dbiterrb       (dbiterrb                 )
  );

endmodule : xpm_memory_sdpram

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************

(* XPM_MODULE = "TRUE" *)
module xpm_memory_spram # (

  // Common module parameters
  parameter integer                 MEMORY_SIZE        = 2048,
  parameter                         MEMORY_PRIMITIVE   = "auto",
  parameter                         ECC_MODE           = "no_ecc",
  parameter                         MEMORY_INIT_FILE   = "none",
  parameter                         MEMORY_INIT_PARAM   = "",
  parameter integer                 USE_MEM_INIT       = 1,
  parameter integer                 USE_MEM_INIT_MMI   = 0,
  parameter                         WAKEUP_TIME        = "disable_sleep",
  parameter integer                 AUTO_SLEEP_TIME    = 0,
  parameter integer                 MESSAGE_CONTROL    = 0,
  parameter                         MEMORY_OPTIMIZATION     = "true",
  parameter integer                 CASCADE_HEIGHT          = 0,
  parameter integer                 SIM_ASSERT_CHK          = 0,
  parameter integer                 WRITE_PROTECT           = 1,
  parameter integer                 IGNORE_INIT_SYNTH       = 0,

  // Port A module parameters
  parameter integer                 WRITE_DATA_WIDTH_A = 32,
  parameter integer                 READ_DATA_WIDTH_A  = WRITE_DATA_WIDTH_A,
  parameter integer                 BYTE_WRITE_WIDTH_A = WRITE_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_A       = $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A),
  parameter                         READ_RESET_VALUE_A = "0",
  parameter integer                 READ_LATENCY_A     = 2,
  parameter                         WRITE_MODE_A       = "read_first",
  parameter                         RST_MODE_A         = "SYNC"

) (

  // Common module ports
  input  wire                                               sleep,

  // Port A module ports
  input  wire                                               clka,
  input  wire                                               rsta,
  input  wire                                               ena,
  input  wire                                               regcea,
  input  wire [(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0] wea,
  input  wire [ADDR_WIDTH_A-1:0]                            addra,
  input  wire [WRITE_DATA_WIDTH_A-1:0]                      dina,
  input  wire                                               injectsbiterra,
  input  wire                                               injectdbiterra,
  output wire [READ_DATA_WIDTH_A-1:0]                       douta,
  output wire                                               sbiterra,
  output wire                                               dbiterra

);

  // Define local parameters for mapping with base file
  localparam integer P_MEMORY_PRIMITIVE      = 
                                   ( (MEMORY_PRIMITIVE == 1 || MEMORY_PRIMITIVE == "LUTRAM"   || MEMORY_PRIMITIVE == "lutram" || MEMORY_PRIMITIVE == "distributed" || MEMORY_PRIMITIVE == "DISTRIBUTED" ) ? 1 :
                                   ( (MEMORY_PRIMITIVE == 2 || MEMORY_PRIMITIVE == "BLOCKRAM" || MEMORY_PRIMITIVE == "blockram" || MEMORY_PRIMITIVE == "block" || MEMORY_PRIMITIVE == "BLOCK" )  ? 2 :
                                   ( (MEMORY_PRIMITIVE == 3 || MEMORY_PRIMITIVE == "ULTRARAM" || MEMORY_PRIMITIVE == "ultraram" || MEMORY_PRIMITIVE == "ultra" || MEMORY_PRIMITIVE == "ULTRA" )  ? 3 :
                                   ( (MEMORY_PRIMITIVE == 4 || MEMORY_PRIMITIVE == "mixedram" || MEMORY_PRIMITIVE == "MIXEDRAM" || MEMORY_PRIMITIVE == "mixed" || MEMORY_PRIMITIVE == "MIXED" )  ? 4 : 0))));
  
  localparam integer P_CLOCKING_MODE         = 0;

  localparam integer P_ECC_MODE              = ( (ECC_MODE  == 0  || ECC_MODE  == "NO_ECC"                 || ECC_MODE  == "no_ecc")                 ? 0 :
                                               ( (ECC_MODE  == 1  || ECC_MODE  == "ENCODE_ONLY"            || ECC_MODE  == "encode_only")            ? 1 :
                                               ( (ECC_MODE  == 2  || ECC_MODE  == "DECODE_ONLY"            || ECC_MODE  == "decode_only")            ? 2 :
                                               ( (ECC_MODE  == 3  || ECC_MODE  == "BOTH_ENCODE_AND_DECODE" || ECC_MODE  == "both_encode_and_decode") ? 3 : 4))));

  localparam integer P_WAKEUP_TIME           = ( (WAKEUP_TIME == 2 || WAKEUP_TIME == "use_sleep_pin" || WAKEUP_TIME == "USE_SLEEP_PIN") ? 2 : 0 ) ;


  localparam integer P_WRITE_MODE_A          = ( (WRITE_MODE_A == 0 || WRITE_MODE_A == "WRITE_FIRST" || WRITE_MODE_A == "write_first") ? 0 :
                                               ( (WRITE_MODE_A == 1 || WRITE_MODE_A == "READ_FIRST"  || WRITE_MODE_A == "read_first")  ? 1 :
                                               ( (WRITE_MODE_A == 2 || WRITE_MODE_A == "NO_CHANGE"   || WRITE_MODE_A == "no_change")   ? 2 : 0)));

  localparam integer P_MEMORY_OPTIMIZATION       = (MEMORY_OPTIMIZATION == "false" ? 0 : 1);
  
  // -------------------------------------------------------------------------------------------------------------------
  // Base module instantiation with single port RAM configuration
  // -------------------------------------------------------------------------------------------------------------------

  xpm_memory_base # (

    // Common module parameters
    .MEMORY_OPTIMIZATION      (MEMORY_OPTIMIZATION   ),
    .MEMORY_TYPE        (0                                     ),
    .MEMORY_SIZE        (MEMORY_SIZE                           ),
    .MEMORY_PRIMITIVE   (P_MEMORY_PRIMITIVE                    ),
    .CLOCKING_MODE      (P_CLOCKING_MODE                       ),
    .ECC_MODE           (P_ECC_MODE                            ),
    .SIM_ASSERT_CHK     (SIM_ASSERT_CHK                        ),
    .MEMORY_INIT_FILE   (MEMORY_INIT_FILE                      ),
    .MEMORY_INIT_PARAM  (MEMORY_INIT_PARAM                     ),
    .USE_MEM_INIT       (USE_MEM_INIT                          ),
    .USE_MEM_INIT_MMI   (USE_MEM_INIT_MMI                      ),
    .WAKEUP_TIME        (P_WAKEUP_TIME                         ),
    .AUTO_SLEEP_TIME    (AUTO_SLEEP_TIME                       ),
    .MESSAGE_CONTROL    (MESSAGE_CONTROL                       ),
    .VERSION            (0                                     ),
    .USE_EMBEDDED_CONSTRAINT  (0 ),
    .CASCADE_HEIGHT     (CASCADE_HEIGHT                        ),
    .WRITE_PROTECT      (WRITE_PROTECT                         ),
    .IGNORE_INIT_SYNTH  (IGNORE_INIT_SYNTH                     ),

    // Port A module parameters
    .WRITE_DATA_WIDTH_A (WRITE_DATA_WIDTH_A                    ),
    .READ_DATA_WIDTH_A  (READ_DATA_WIDTH_A                     ),
    .BYTE_WRITE_WIDTH_A (BYTE_WRITE_WIDTH_A                    ),
    .ADDR_WIDTH_A       (ADDR_WIDTH_A                          ),
    .READ_RESET_VALUE_A (READ_RESET_VALUE_A                    ),
    .READ_LATENCY_A     (READ_LATENCY_A                        ),
    .WRITE_MODE_A       (P_WRITE_MODE_A                        ),
    .RST_MODE_A         (RST_MODE_A                            ),

    // Port B module parameters
    .WRITE_DATA_WIDTH_B (WRITE_DATA_WIDTH_A                    ),
    .READ_DATA_WIDTH_B  (READ_DATA_WIDTH_A                     ),
    .BYTE_WRITE_WIDTH_B (WRITE_DATA_WIDTH_A                    ),
    .ADDR_WIDTH_B       ($clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A)),
    .READ_RESET_VALUE_B ("0"                                   ),
    .READ_LATENCY_B     (READ_LATENCY_A                        ),
    .WRITE_MODE_B       (P_WRITE_MODE_A                        )
  ) xpm_memory_base_inst (

    // Common module ports
    .sleep          (sleep                                         ),

    // Port A module ports
    .clka           (clka                                          ),
    .rsta           (rsta                                          ),
    .ena            (ena                                           ),
    .regcea         (regcea                                        ),
    .wea            (wea                                           ),
    .addra          (addra                                         ),
    .dina           (dina                                          ),
    .injectsbiterra (injectsbiterra                                ),
    .injectdbiterra (injectdbiterra                                ),
    .douta          (douta                                         ),
    .sbiterra       (sbiterra                                      ),
    .dbiterra       (dbiterra                                      ),

    // Port B module ports
    .clkb           (1'b0                                          ),
    .rstb           (1'b0                                          ),
    .enb            (1'b0                                          ),
    .regceb         (1'b0                                          ),
    .web            (1'b0                                          ),
    .addrb          ({$clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A){1'b0}}),
    .dinb           ({READ_DATA_WIDTH_A{1'b0}}                     ),
    .injectsbiterrb (1'b0                                          ),
    .injectdbiterrb (1'b0                                          ),
    .doutb          (                                              ),
    .sbiterrb       (                                              ),
    .dbiterrb       (                                              )
  );

endmodule : xpm_memory_spram

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************

(* XPM_MODULE = "TRUE" *)
module xpm_memory_sprom # (

  // Common module parameters
  parameter integer                 MEMORY_SIZE        = 2048,
  parameter                         MEMORY_PRIMITIVE   = "auto",
  parameter                         ECC_MODE           = "no_ecc",
  parameter                         MEMORY_INIT_FILE   = "none",
  parameter                         MEMORY_INIT_PARAM  = "",
  parameter integer                 USE_MEM_INIT       = 1,
  parameter integer                 USE_MEM_INIT_MMI   = 0,
  parameter                         WAKEUP_TIME        = "disable_sleep",
  parameter integer                 AUTO_SLEEP_TIME    = 0,
  parameter integer                 MESSAGE_CONTROL    = 0,
  parameter                         MEMORY_OPTIMIZATION     = "true",
  parameter integer                 CASCADE_HEIGHT          = 0,
  parameter integer                 SIM_ASSERT_CHK          = 0,
  parameter integer                 IGNORE_INIT_SYNTH       = 0,

  // Port A module parameters
  parameter integer                 READ_DATA_WIDTH_A  = 32,
  parameter integer                 ADDR_WIDTH_A       = $clog2(MEMORY_SIZE/READ_DATA_WIDTH_A),
  parameter                         READ_RESET_VALUE_A = "0",
  parameter integer                 READ_LATENCY_A     = 2,
  parameter                         RST_MODE_A         = "SYNC"
) (

  // Common module ports
  input  wire                         sleep,

  // Port A module ports
  input  wire                         clka,
  input  wire                         rsta,
  input  wire                         ena,
  input  wire                         regcea,
  input  wire [ADDR_WIDTH_A-1:0]      addra,
  input  wire                         injectsbiterra,
  input  wire                         injectdbiterra,
  output wire [READ_DATA_WIDTH_A-1:0] douta,
  output wire                         sbiterra,
  output wire                         dbiterra

);

  
  // Define local parameters for mapping with base file
  localparam integer P_MEMORY_PRIMITIVE      = 
                                 ( (MEMORY_PRIMITIVE == 1 || MEMORY_PRIMITIVE == "lutram"   || MEMORY_PRIMITIVE == "LUTRAM" || MEMORY_PRIMITIVE == "distributed" || MEMORY_PRIMITIVE == "DISTRIBUTED" ) ? 1 :
                                 ( (MEMORY_PRIMITIVE == 2 || MEMORY_PRIMITIVE == "blockram" || MEMORY_PRIMITIVE == "BLOCKRAM" || MEMORY_PRIMITIVE == "block" || MEMORY_PRIMITIVE == "BLOCK" ) ? 2 :
                                 ( (MEMORY_PRIMITIVE == 3 || MEMORY_PRIMITIVE == "ultraram" || MEMORY_PRIMITIVE == "ULTRARAM" || MEMORY_PRIMITIVE == "ultra" || MEMORY_PRIMITIVE == "ULTRA" ) ? 3 :
                                 ( (MEMORY_PRIMITIVE == 4 || MEMORY_PRIMITIVE == "mixedram" || MEMORY_PRIMITIVE == "MIXEDRAM" || MEMORY_PRIMITIVE == "mixed" || MEMORY_PRIMITIVE == "MIXED" ) ? 4 : 0))));
  
  localparam integer P_CLOCKING_MODE         = 0;

  localparam integer P_ECC_MODE              = ( (ECC_MODE  == 0  || ECC_MODE  == "no_ecc"                 || ECC_MODE  == "NO_ECC"                ) ? 0 :
                                               ( (ECC_MODE  == 1  || ECC_MODE  == "encode_only"            || ECC_MODE  == "ENCODE_ONLY"           ) ? 1 :
                                               ( (ECC_MODE  == 2  || ECC_MODE  == "decode_only"            || ECC_MODE  == "DECODE_ONLY"           ) ? 2 :
                                               ( (ECC_MODE  == 3  || ECC_MODE  == "both_encode_and_decode" || ECC_MODE  == "BOTH_ENCODE_AND_DECODE") ? 3 : 4))));

  localparam integer P_WAKEUP_TIME           = ( (WAKEUP_TIME == 2 || WAKEUP_TIME == "use_sleep_pin"    || WAKEUP_TIME == "USE_SLEEP_PIN") ? 2 : 0 );

  localparam integer P_MEMORY_OPTIMIZATION       = (MEMORY_OPTIMIZATION == "false" ? 0 : 1);

  // -------------------------------------------------------------------------------------------------------------------
  // Base module instantiation with single port ROM configuration
  // -------------------------------------------------------------------------------------------------------------------

  xpm_memory_base # (

    // Common module parameters
    .MEMORY_OPTIMIZATION      (MEMORY_OPTIMIZATION   ),
    .MEMORY_TYPE        (3                                    ),
    .MEMORY_SIZE        (MEMORY_SIZE                          ),
    .MEMORY_PRIMITIVE   (P_MEMORY_PRIMITIVE                   ),
    .CLOCKING_MODE      (P_CLOCKING_MODE                      ),
    .ECC_MODE           (P_ECC_MODE                           ),
    .SIM_ASSERT_CHK     (SIM_ASSERT_CHK                       ),
    .MEMORY_INIT_FILE   (MEMORY_INIT_FILE                     ),
    .MEMORY_INIT_PARAM  (MEMORY_INIT_PARAM                    ),
    .USE_MEM_INIT       (USE_MEM_INIT                         ),
    .USE_MEM_INIT_MMI   (USE_MEM_INIT_MMI                     ),
    .WAKEUP_TIME        (P_WAKEUP_TIME                        ),
    .AUTO_SLEEP_TIME    (AUTO_SLEEP_TIME                      ),
    .MESSAGE_CONTROL    (MESSAGE_CONTROL                      ),
    .VERSION            (0                                    ),
    .USE_EMBEDDED_CONSTRAINT  (0 ),
    .CASCADE_HEIGHT     (CASCADE_HEIGHT                       ),
    .IGNORE_INIT_SYNTH  (IGNORE_INIT_SYNTH                    ),

    // Port A module parameters
    .WRITE_DATA_WIDTH_A (READ_DATA_WIDTH_A                    ),
    .READ_DATA_WIDTH_A  (READ_DATA_WIDTH_A                    ),
    .BYTE_WRITE_WIDTH_A (READ_DATA_WIDTH_A                    ),
    .ADDR_WIDTH_A       (ADDR_WIDTH_A                         ),
    .READ_RESET_VALUE_A (READ_RESET_VALUE_A                   ),
    .READ_LATENCY_A     (READ_LATENCY_A                       ),
    .WRITE_MODE_A       (1                                    ),
    .RST_MODE_A         (RST_MODE_A                           ),

    // Port B module parameters
    .WRITE_DATA_WIDTH_B (READ_DATA_WIDTH_A                    ),
    .READ_DATA_WIDTH_B  (READ_DATA_WIDTH_A                    ),
    .BYTE_WRITE_WIDTH_B (READ_DATA_WIDTH_A                    ),
    .ADDR_WIDTH_B       ($clog2(MEMORY_SIZE/READ_DATA_WIDTH_A)),
    .READ_RESET_VALUE_B ("0"                                  ),
    .READ_LATENCY_B     (READ_LATENCY_A                       ),
    .WRITE_MODE_B       (1                                    )
  ) xpm_memory_base_inst (

    // Common module ports
    .sleep          (sleep                                        ),

    // Port A module ports
    .clka           (clka                                         ),
    .rsta           (rsta                                         ),
    .ena            (ena                                          ),
    .regcea         (regcea                                       ),
    .wea            (1'b0                                         ),
    .addra          (addra                                        ),
    .dina           ({READ_DATA_WIDTH_A{1'b0}}                    ),
    .injectsbiterra (injectsbiterra                               ),
    .injectdbiterra (injectdbiterra                               ),
    .douta          (douta                                        ),
    .sbiterra       (sbiterra                                     ),
    .dbiterra       (dbiterra                                     ),

    // Port B module ports
    .clkb           (1'b0                                         ),
    .rstb           (1'b0                                         ),
    .enb            (1'b0                                         ),
    .regceb         (1'b0                                         ),
    .web            (1'b0                                         ),
    .addrb          ({$clog2(MEMORY_SIZE/READ_DATA_WIDTH_A){1'b0}}),
    .dinb           ({READ_DATA_WIDTH_A{1'b0}}                    ),
    .injectsbiterrb (1'b0                                         ),
    .injectdbiterrb (1'b0                                         ),
    .doutb          (                                             ),
    .sbiterrb       (                                             ),
    .dbiterrb       (                                             )
  );

endmodule : xpm_memory_sprom

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************

(* XPM_MODULE = "TRUE" *)
module xpm_memory_tdpram # (

  // Common module parameters
  parameter integer                 MEMORY_SIZE        = 2048,
  parameter                         MEMORY_PRIMITIVE   = "auto",
  parameter                         CLOCKING_MODE      = "common_clock",
  parameter                         ECC_MODE           = "no_ecc",
  parameter                         MEMORY_INIT_FILE   = "none",
  parameter                         MEMORY_INIT_PARAM  = "",
  parameter integer                 USE_MEM_INIT       = 1,
  parameter integer                 USE_MEM_INIT_MMI   = 0,
  parameter                         WAKEUP_TIME        = "disable_sleep",
  parameter integer                 AUTO_SLEEP_TIME    = 0,
  parameter integer                 MESSAGE_CONTROL    = 0,
  parameter integer                 USE_EMBEDDED_CONSTRAINT = 0,
  parameter                         MEMORY_OPTIMIZATION     = "true",
  parameter integer                 CASCADE_HEIGHT          = 0,
  parameter integer                 SIM_ASSERT_CHK          = 0,
  parameter integer                 WRITE_PROTECT           = 1,
  parameter integer                 IGNORE_INIT_SYNTH       = 0,

  // Port A module parameters
  parameter integer                 WRITE_DATA_WIDTH_A = 32,
  parameter integer                 READ_DATA_WIDTH_A  = WRITE_DATA_WIDTH_A,
  parameter integer                 BYTE_WRITE_WIDTH_A = WRITE_DATA_WIDTH_A,
  parameter integer                 ADDR_WIDTH_A       = $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A),
  parameter                         READ_RESET_VALUE_A = "0",
  parameter integer                 READ_LATENCY_A     = 2,
  parameter                         WRITE_MODE_A       = "no_change",
  parameter                         RST_MODE_A         = "SYNC",

  // Port B module parameters
  parameter integer                 WRITE_DATA_WIDTH_B = WRITE_DATA_WIDTH_A,
  parameter integer                 READ_DATA_WIDTH_B  = WRITE_DATA_WIDTH_B,
  parameter integer                 BYTE_WRITE_WIDTH_B = WRITE_DATA_WIDTH_B,
  parameter integer                 ADDR_WIDTH_B       = $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_B),
  parameter                         READ_RESET_VALUE_B = "0",
  parameter integer                 READ_LATENCY_B     = READ_LATENCY_A,
  parameter                         WRITE_MODE_B       = "no_change",
  parameter                         RST_MODE_B         = "SYNC"
) (

  // Common module ports
  input  wire                                               sleep,

  // Port A module ports
  input  wire                                               clka,
  input  wire                                               rsta,
  input  wire                                               ena,
  input  wire                                               regcea,
  input  wire [(WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A)-1:0] wea,
  input  wire [ADDR_WIDTH_A-1:0]                            addra,
  input  wire [WRITE_DATA_WIDTH_A-1:0]                      dina,
  input  wire                                               injectsbiterra,
  input  wire                                               injectdbiterra,
  output wire [READ_DATA_WIDTH_A-1:0]                       douta,
  output wire                                               sbiterra,
  output wire                                               dbiterra,

  // Port B module ports
  input  wire                                               clkb,
  input  wire                                               rstb,
  input  wire                                               enb,
  input  wire                                               regceb,
  input  wire [(WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B)-1:0] web,
  input  wire [ADDR_WIDTH_B-1:0]                            addrb,
  input  wire [WRITE_DATA_WIDTH_B-1:0]                      dinb,
  input  wire                                               injectsbiterrb,
  input  wire                                               injectdbiterrb,
  output wire [READ_DATA_WIDTH_B-1:0]                       doutb,
  output wire                                               sbiterrb,
  output wire                                               dbiterrb
);

  // Define local parameters for mapping with base file
  localparam integer P_MEMORY_PRIMITIVE      = 
                                  ( (MEMORY_PRIMITIVE == 1 || MEMORY_PRIMITIVE == "lutram"   || MEMORY_PRIMITIVE == "LUTRAM" || MEMORY_PRIMITIVE == "distributed" || MEMORY_PRIMITIVE == "DISTRIBUTED" ) ? 1 :
                                  ( (MEMORY_PRIMITIVE == 2 || MEMORY_PRIMITIVE == "blockram" || MEMORY_PRIMITIVE == "BLOCKRAM" || MEMORY_PRIMITIVE == "block" || MEMORY_PRIMITIVE == "BLOCK" ) ? 2 :
                                  ( (MEMORY_PRIMITIVE == 3 || MEMORY_PRIMITIVE == "ultraram" || MEMORY_PRIMITIVE == "ULTRARAM" || MEMORY_PRIMITIVE == "ultra" || MEMORY_PRIMITIVE == "ULTRA" ) ? 3 :
                                  ( (MEMORY_PRIMITIVE == 4 || MEMORY_PRIMITIVE == "mixedram" || MEMORY_PRIMITIVE == "MIXEDRAM" || MEMORY_PRIMITIVE == "mixed" || MEMORY_PRIMITIVE == "MIXED" ) ? 4 : 0))));
  
  localparam integer P_CLOCKING_MODE         = ( (CLOCKING_MODE == 0 || CLOCKING_MODE == "common_clock"      || CLOCKING_MODE == "COMMON_CLOCK"     ) ? 0 :
                                               ( (CLOCKING_MODE == 1 || CLOCKING_MODE == "independent_clock" || CLOCKING_MODE == "INDEPENDENT_CLOCK") ? 1 : 0));

  localparam integer P_ECC_MODE              = ( (ECC_MODE  == 0  || ECC_MODE  == "no_ecc"                 || ECC_MODE  == "NO_ECC"                ) ? 0 :
                                               ( (ECC_MODE  == 1  || ECC_MODE  == "encode_only"            || ECC_MODE  == "ENCODE_ONLY"           ) ? 1 :
                                               ( (ECC_MODE  == 2  || ECC_MODE  == "decode_only"            || ECC_MODE  == "DECODE_ONLY"           ) ? 2 :
                                               ( (ECC_MODE  == 3  || ECC_MODE  == "both_encode_and_decode" || ECC_MODE  == "BOTH_ENCODE_AND_DECODE") ? 3 : 4))));

  localparam integer P_WAKEUP_TIME           = ( (WAKEUP_TIME == 2 || WAKEUP_TIME == "use_sleep_pin"    || WAKEUP_TIME == "USE_SLEEP_PIN") ? 2 : 0 );

  localparam integer P_WRITE_MODE_A          = ( (WRITE_MODE_A == 0 || WRITE_MODE_A == "write_first" || WRITE_MODE_A == "WRITE_FIRST") ? 0 :
                                               ( (WRITE_MODE_A == 1 || WRITE_MODE_A == "read_first"  || WRITE_MODE_A == "READ_FIRST" ) ? 1 :
                                               ( (WRITE_MODE_A == 2 || WRITE_MODE_A == "no_change"   || WRITE_MODE_A == "NO_CHANGE"  ) ? 2 : 0)));

  localparam integer P_WRITE_MODE_B          = ( (WRITE_MODE_B == 0 || WRITE_MODE_B == "write_first" || WRITE_MODE_B == "WRITE_FIRST") ? 0 :
                                               ( (WRITE_MODE_B == 1 || WRITE_MODE_B == "read_first"  || WRITE_MODE_B == "READ_FIRST" ) ? 1 :
                                               ( (WRITE_MODE_B == 2 || WRITE_MODE_B == "no_change"   || WRITE_MODE_B == "NO_CHANGE"  ) ? 2 : 0)));

  localparam integer P_MEMORY_OPTIMIZATION       = (MEMORY_OPTIMIZATION == "false" ? 0 : 1);

  // -------------------------------------------------------------------------------------------------------------------
  // Base module instantiation with true dual port RAM configuration
  // -------------------------------------------------------------------------------------------------------------------

  xpm_memory_base # (

    // Common module parameters
    .MEMORY_OPTIMIZATION      (MEMORY_OPTIMIZATION   ),
    .MEMORY_TYPE              (2                       ),
    .MEMORY_SIZE              (MEMORY_SIZE             ),
    .MEMORY_PRIMITIVE         (P_MEMORY_PRIMITIVE      ),
    .CLOCKING_MODE            (P_CLOCKING_MODE         ),
    .ECC_MODE                 (P_ECC_MODE              ),
    .SIM_ASSERT_CHK           (SIM_ASSERT_CHK    ),
    .MEMORY_INIT_FILE         (MEMORY_INIT_FILE        ),
    .MEMORY_INIT_PARAM        (MEMORY_INIT_PARAM       ),
    .USE_MEM_INIT             (USE_MEM_INIT            ),
    .USE_MEM_INIT_MMI         (USE_MEM_INIT_MMI        ),
    .WAKEUP_TIME              (P_WAKEUP_TIME           ),
    .AUTO_SLEEP_TIME          (AUTO_SLEEP_TIME         ),
    .MESSAGE_CONTROL          (MESSAGE_CONTROL         ),
    .VERSION                  (0                       ),
    .USE_EMBEDDED_CONSTRAINT  (USE_EMBEDDED_CONSTRAINT ),
    .CASCADE_HEIGHT           (CASCADE_HEIGHT          ),
    .WRITE_PROTECT            (WRITE_PROTECT           ),
    .IGNORE_INIT_SYNTH        (IGNORE_INIT_SYNTH       ),

    // Port A module parameters
    .WRITE_DATA_WIDTH_A (WRITE_DATA_WIDTH_A),
    .READ_DATA_WIDTH_A  (READ_DATA_WIDTH_A ),
    .BYTE_WRITE_WIDTH_A (BYTE_WRITE_WIDTH_A),
    .ADDR_WIDTH_A       (ADDR_WIDTH_A      ),
    .READ_RESET_VALUE_A (READ_RESET_VALUE_A),
    .READ_LATENCY_A     (READ_LATENCY_A    ),
    .WRITE_MODE_A       (P_WRITE_MODE_A    ),
    .RST_MODE_A         (RST_MODE_A        ),

    // Port B module parameters
    .WRITE_DATA_WIDTH_B (WRITE_DATA_WIDTH_B),
    .READ_DATA_WIDTH_B  (READ_DATA_WIDTH_B ),
    .BYTE_WRITE_WIDTH_B (BYTE_WRITE_WIDTH_B),
    .ADDR_WIDTH_B       (ADDR_WIDTH_B      ),
    .READ_RESET_VALUE_B (READ_RESET_VALUE_B),
    .READ_LATENCY_B     (READ_LATENCY_B    ),
    .WRITE_MODE_B       (P_WRITE_MODE_B    ),
    .RST_MODE_B         (RST_MODE_B        )
  ) xpm_memory_base_inst (

    // Common module ports
    .sleep          (sleep         ),

    // Port A module ports
    .clka           (clka          ),
    .rsta           (rsta          ),
    .ena            (ena           ),
    .regcea         (regcea        ),
    .wea            (wea           ),
    .addra          (addra         ),
    .dina           (dina          ),
    .injectsbiterra (injectsbiterra),
    .injectdbiterra (injectdbiterra),
    .douta          (douta         ),
    .sbiterra       (sbiterra      ),
    .dbiterra       (dbiterra      ),

    // Port B module ports
    .clkb           (clkb          ),
    .rstb           (rstb          ),
    .enb            (enb           ),
    .regceb         (regceb        ),
    .web            (web           ),
    .addrb          (addrb         ),
    .dinb           (dinb          ),
    .injectsbiterrb (injectsbiterrb),
    .injectdbiterrb (injectdbiterrb),
    .doutb          (doutb         ),
    .sbiterrb       (sbiterrb      ),
    .dbiterrb       (dbiterrb      )
  );

endmodule : xpm_memory_tdpram

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************

`default_nettype wire
