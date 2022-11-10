//------------------------------------------------------------------------------
//  (c) Copyright 2016 Xilinx, Inc. All rights reserved.
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
module xpm_fifo_base # (

  // Common module parameters
  parameter integer                 COMMON_CLOCK         = 1,
  parameter integer                 RELATED_CLOCKS       = 0,
  parameter integer                 FIFO_MEMORY_TYPE     = 0,
  parameter integer                 ECC_MODE             = 0,
  parameter integer                 SIM_ASSERT_CHK       = 0,
  parameter integer                 CASCADE_HEIGHT       = 0,

  parameter integer                 FIFO_WRITE_DEPTH     = 2048,
  parameter integer                 WRITE_DATA_WIDTH     = 32,
  parameter integer                 WR_DATA_COUNT_WIDTH  = 12,
  parameter integer                 PROG_FULL_THRESH     = 10,
  parameter                         USE_ADV_FEATURES     = "0707",

  parameter                         READ_MODE            = 0,
  parameter                         FIFO_READ_LATENCY    = 1,
  parameter integer                 READ_DATA_WIDTH      = WRITE_DATA_WIDTH,
  parameter integer                 RD_DATA_COUNT_WIDTH  = 12,
  parameter integer                 PROG_EMPTY_THRESH    = 10,
  parameter                         DOUT_RESET_VALUE     = "",
  parameter integer                 CDC_DEST_SYNC_FF     = 2,
  parameter integer                 FULL_RESET_VALUE     = 0,
  parameter integer                 REMOVE_WR_RD_PROT_LOGIC = 0,

  parameter integer                 WAKEUP_TIME          = 0,
  parameter integer                 VERSION              = 1

) (

  // Common module ports
  input  wire                                sleep,
  input  wire                                rst,

  // Write Domain ports
  input  wire                                wr_clk,
  input  wire                                wr_en,
  input  wire [WRITE_DATA_WIDTH-1:0]         din,
  output wire                                full,
  output wire                                full_n,
  output wire                                prog_full,
  output wire [WR_DATA_COUNT_WIDTH-1:0]      wr_data_count,
  output wire                                overflow,
  output wire                                wr_rst_busy,
  output wire                                almost_full,
  output wire                                wr_ack,

  // Read Domain ports
  input  wire                                rd_clk,
  input  wire                                rd_en,
  output wire [READ_DATA_WIDTH-1:0]          dout,
  output wire                                empty,
  output wire                                prog_empty,
  output wire [RD_DATA_COUNT_WIDTH-1:0]      rd_data_count,
  output wire                                underflow,
  output wire                                rd_rst_busy,
  output wire                                almost_empty,
  output wire                                data_valid,

  // ECC Related ports
  input  wire                                injectsbiterr,
  input  wire                                injectdbiterr,
  output wire                                sbiterr,
  output wire                                dbiterr
);

  function integer clog2;
    input integer value;
  begin 
    value = value-1;
    for (clog2=0; value>0; clog2=clog2+1)
      value = value>>1;
    end 
  endfunction
  // Function to convert ASCII value to binary 
  function [3:0] str2bin;
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
            str2bin = str_val_ascii[3:0];
         else begin
           str2bin [3] = 1'b1;
           str2bin [2] = str_val_ascii[2] | (str_val_ascii[1] & str_val_ascii[0]);
           str2bin [1] = str_val_ascii[0] ^ str_val_ascii[1];
           str2bin [0] = !str_val_ascii[0];
         end
      end
      else
        $error("Found Invalid character while parsing the string, please cross check the value specified for either READ_RESET_VALUE_A|B or MEMORY_INIT_PARAM (if initialization of memory through parameter is used). XPM_MEMORY supports strings (hex) that contains characters 0-9, A-F and a-f.");
  endfunction
  // Function that parses the complete reset value string
  function logic [15:0] hstr2bin;
    input [16*8-1 : 0] hstr_val;
    integer rst_loop_a;
    localparam integer  rsta_loop_iter  =  16;
    logic [rsta_loop_iter-1 : 0] rst_val_conv_a_i;
    for (rst_loop_a=1; rst_loop_a <= rsta_loop_iter/4; rst_loop_a = rst_loop_a+1) begin
      rst_val_conv_a_i[(rst_loop_a*4)-1 -: 4] =  str2bin(hstr_val[(rst_loop_a*8)-1 -: 8]);
    end
    return rst_val_conv_a_i[15:0];
  endfunction


  localparam invalid             = 0;
  localparam stage1_valid        = 2;
  localparam stage2_valid        = 1;
  localparam both_stages_valid   = 3;

  reg  [1:0] curr_fwft_state = invalid;
  reg  [1:0] next_fwft_state;// = invalid;



  localparam FIFO_MEM_TYPE   = FIFO_MEMORY_TYPE;
  localparam RD_MODE         = READ_MODE;
  localparam ENABLE_ECC      = (ECC_MODE == 1) ? 3 : 0;
  localparam FIFO_READ_DEPTH = FIFO_WRITE_DEPTH*WRITE_DATA_WIDTH/READ_DATA_WIDTH;
  localparam FIFO_SIZE       = FIFO_WRITE_DEPTH*WRITE_DATA_WIDTH;
  localparam WR_WIDTH_LOG    = clog2(WRITE_DATA_WIDTH);
  localparam WR_DEPTH_LOG    = clog2(FIFO_WRITE_DEPTH);
  localparam WR_PNTR_WIDTH   = clog2(FIFO_WRITE_DEPTH);
  localparam RD_PNTR_WIDTH   = clog2(FIFO_READ_DEPTH);
  localparam FULL_RST_VAL    = FULL_RESET_VALUE == 0 ? 1'b0 : 1'b1;
  localparam WR_RD_RATIO     = (WR_PNTR_WIDTH > RD_PNTR_WIDTH) ? (WR_PNTR_WIDTH-RD_PNTR_WIDTH) : 0;
  localparam READ_MODE_LL    = (READ_MODE == 0) ? 0 : 1;
  localparam PF_THRESH_ADJ   = (READ_MODE == 0) ? PROG_FULL_THRESH :
                               PROG_FULL_THRESH - (2*(2**WR_RD_RATIO));
  localparam PE_THRESH_ADJ   = (READ_MODE_LL == 1 && FIFO_MEMORY_TYPE != 4) ? PROG_EMPTY_THRESH - 2'h2 : PROG_EMPTY_THRESH;

  localparam PF_THRESH_MIN   = 3+(READ_MODE_LL*2*(((FIFO_WRITE_DEPTH-1)/FIFO_READ_DEPTH)+1))+(COMMON_CLOCK?0:CDC_DEST_SYNC_FF);
  localparam PF_THRESH_MAX   = (FIFO_WRITE_DEPTH-3)-(READ_MODE_LL*2*(((FIFO_WRITE_DEPTH-1)/FIFO_READ_DEPTH)+1));
  localparam PE_THRESH_MIN   = 3+(READ_MODE_LL*2);
  localparam PE_THRESH_MAX   = (FIFO_READ_DEPTH-3)-(READ_MODE_LL*2);
  localparam WR_DC_WIDTH_EXT = clog2(FIFO_WRITE_DEPTH)+1;
  localparam RD_DC_WIDTH_EXT = clog2(FIFO_READ_DEPTH)+1;
  localparam RD_LATENCY      = (READ_MODE == 2) ? 1 : (READ_MODE == 1) ? 2 : FIFO_READ_LATENCY;
  localparam WIDTH_RATIO     = (READ_DATA_WIDTH > WRITE_DATA_WIDTH) ? (READ_DATA_WIDTH/WRITE_DATA_WIDTH) : (WRITE_DATA_WIDTH/READ_DATA_WIDTH);

  localparam [15:0] EN_ADV_FEATURE = hstr2bin(USE_ADV_FEATURES);

  localparam EN_OF           = EN_ADV_FEATURE[0];  //EN_ADV_FLAGS_WR[0] ? 1 : 0;
  localparam EN_PF           = EN_ADV_FEATURE[1];  //EN_ADV_FLAGS_WR[1] ? 1 : 0;
  localparam EN_WDC          = EN_ADV_FEATURE[2];  //EN_ADV_FLAGS_WR[2] ? 1 : 0;
  localparam EN_AF           = EN_ADV_FEATURE[3];  //EN_ADV_FLAGS_WR[3] ? 1 : 0;
  localparam EN_WACK         = EN_ADV_FEATURE[4];  //EN_ADV_FLAGS_WR[4] ? 1 : 0;
  localparam FG_EQ_ASYM_DOUT = EN_ADV_FEATURE[5];  //EN_ADV_FLAGS_WR[5] ? 1 : 0;
  localparam EN_UF           = EN_ADV_FEATURE[8];  //EN_ADV_FLAGS_RD[0] ? 1 : 0;
  localparam EN_PE           = EN_ADV_FEATURE[9];  //EN_ADV_FLAGS_RD[1] ? 1 : 0;
  localparam EN_RDC          = EN_ADV_FEATURE[10]; //EN_ADV_FLAGS_RD[2] ? 1 : 0;
  localparam EN_AE           = EN_ADV_FEATURE[11]; //EN_ADV_FLAGS_RD[3] ? 1 : 0;
  localparam EN_DVLD         = EN_ADV_FEATURE[12]; //EN_ADV_FLAGS_RD[4] ? 1 : 0;

  wire                       wrst_busy;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr;
  wire [WR_PNTR_WIDTH:0]     wr_pntr_ext;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_rd_cdc;
  wire [WR_PNTR_WIDTH:0]     wr_pntr_rd_cdc_dc;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_rd;
  wire [WR_PNTR_WIDTH:0]     wr_pntr_rd_dc;
  wire [WR_PNTR_WIDTH-1:0]   rd_pntr_wr_adj;
  wire [WR_PNTR_WIDTH:0]     rd_pntr_wr_adj_dc;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_plus1;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_plus2;
  wire [WR_PNTR_WIDTH-1:0]   wr_pntr_plus3;
  wire [WR_PNTR_WIDTH:0]     wr_pntr_plus1_pf;
  wire [WR_PNTR_WIDTH:0]     rd_pntr_wr_adj_inv_pf;
  reg  [WR_PNTR_WIDTH:0]     diff_pntr_pf_q = {WR_PNTR_WIDTH{1'b0}};
  wire [WR_PNTR_WIDTH-1:0]   diff_pntr_pf;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr;
  wire [RD_PNTR_WIDTH:0]     rd_pntr_ext;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr_wr_cdc;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr_wr;
  wire [RD_PNTR_WIDTH:0]     rd_pntr_wr_cdc_dc;
  wire [RD_PNTR_WIDTH:0]     rd_pntr_wr_dc;
  wire [RD_PNTR_WIDTH-1:0]   wr_pntr_rd_adj;
  wire [RD_PNTR_WIDTH:0]     wr_pntr_rd_adj_dc;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr_plus1;
  wire [RD_PNTR_WIDTH-1:0]   rd_pntr_plus2;
  wire                       invalid_state;
  wire                       valid_fwft;
  wire                       ram_valid_fwft;
  wire                       going_empty;
  wire                       leaving_empty;
  wire                       going_aempty;
  wire                       leaving_aempty;
  reg                        ram_empty_i  = 1'b1;
  reg                        ram_aempty_i = 1'b1;
  wire                       empty_i;
  wire                       going_full;
  wire                       leaving_full;
  wire                       going_afull;
  wire                       leaving_afull;
  reg                        prog_full_i = FULL_RST_VAL;
  reg                        ram_full_i  = FULL_RST_VAL;
  reg                        ram_afull_i = FULL_RST_VAL;
  reg                        ram_full_n  = ~FULL_RST_VAL;
  wire                       ram_wr_en_i;
  wire                       ram_rd_en_i;
  reg                        wr_ack_i = 1'b0;
  wire                       rd_en_i;
  reg                        rd_en_fwft;
  wire                       ram_regce;
  wire                       ram_regce_pipe;
  wire [READ_DATA_WIDTH-1:0] dout_i;
  reg                        empty_fwft_i     = 1'b1;
  reg                        aempty_fwft_i    = 1'b1;
  reg                        empty_fwft_fb    = 1'b1;
  reg                        overflow_i       = 1'b0;
  reg                        underflow_i      = 1'b0;
  reg                        data_valid_fwft  = 1'b0;
  reg                        data_valid_std   = 1'b0;
  wire                       data_vld_std;
  wire                       wrp_gt_rdp_and_red;
  wire                       wrp_lt_rdp_and_red;
  reg                        ram_wr_en_pf_q = 1'b0;
  reg                        ram_rd_en_pf_q = 1'b0;
  wire                       ram_wr_en_pf;
  wire                       ram_rd_en_pf;
  wire                       wr_pntr_plus1_pf_carry;
  wire                       rd_pntr_wr_adj_pf_carry;
  wire                       write_allow;
  wire                       read_allow;
  wire                       read_only;
  wire                       write_only;
  reg                        write_only_q;
  reg                        read_only_q;
  reg [RD_PNTR_WIDTH-1:0]    diff_pntr_pe_reg1;
  reg [RD_PNTR_WIDTH-1:0]    diff_pntr_pe_reg2;
  reg [RD_PNTR_WIDTH-1:0]    diff_pntr_pe = 'b0;
  reg                        prog_empty_i = 1'b1;
  reg                        ram_empty_i_d1 = 1'b1;
  wire                       fe_of_empty;
  // function to validate the write depth value
  function logic dpth_pwr_2;
    input integer fifo_depth;
    integer log2_of_depth; // correcponding to the default value of 2k depth
    log2_of_depth = clog2(fifo_depth);
    if (fifo_depth == 2 ** log2_of_depth)
      dpth_pwr_2 = 1;
    else
      dpth_pwr_2 = 0;
    return dpth_pwr_2;
  endfunction
  
  initial begin : config_drc
    reg drc_err_flag;
    drc_err_flag = 0;
    #1;

    if (COMMON_CLOCK == 0 && FIFO_MEM_TYPE == 3) begin
      $error("[%s %0d-%0d] UltraRAM cannot be used as asynchronous FIFO because it has only one clock support %m", "XPM_FIFO", 1, 1);
      drc_err_flag = 1;
    end

    if (COMMON_CLOCK == 1 && RELATED_CLOCKS == 1) begin
      $error("[%s %0d-%0d] Related Clocks cannot be used in synchronous FIFO because it is applicable only for asynchronous FIFO %m", "XPM_FIFO", 1, 2);
      drc_err_flag = 1;
    end

    if(!(FIFO_WRITE_DEPTH > 15 && FIFO_WRITE_DEPTH <= 4*1024*1024)) begin
      $error("[%s %0d-%0d] FIFO_WRITE_DEPTH (%0d) value specified is not within the supported ranges. Miniumum supported depth is 16, and the maximum supported depth is 4*1024*1024 locations. %m", "XPM_FIFO", 1, 3, FIFO_WRITE_DEPTH);
      drc_err_flag = 1;
    end

    if(!dpth_pwr_2(FIFO_WRITE_DEPTH) && (FIFO_WRITE_DEPTH > 15 && FIFO_WRITE_DEPTH <= 4*1024*1024)) begin
      $error("[%s %0d-%0d] FIFO_WRITE_DEPTH (%0d) value specified is non-power of 2, but this release of XPM_FIFO supports configurations having the fifo write depth set to power of 2. %m", "XPM_FIFO", 1, 4, FIFO_WRITE_DEPTH);
      drc_err_flag = 1;
    end

    if (CDC_DEST_SYNC_FF < 2 || CDC_DEST_SYNC_FF > 8) begin
      $error("[%s %0d-%0d] CDC_DEST_SYNC_FF (%0d) value is specified for this configuration, but this beta release of XPM_FIFO supports CDC_DEST_SYNC_FF values in between 2 and 8. %m", "XPM_FIFO", 1, 5,CDC_DEST_SYNC_FF);
      drc_err_flag = 1;
    end
    if (CDC_DEST_SYNC_FF != 2 && RELATED_CLOCKS == 1) begin
      $error("[%s %0d-%0d] CDC_DEST_SYNC_FF (%0d) value is specified for this configuration, but CDC_DEST_SYNC_FF value can not be modified from default value when RELATED_CLOCKS parameter is set to 1. %m", "XPM_FIFO", 1, 6,CDC_DEST_SYNC_FF);
      drc_err_flag = 1;
    end
    if (FIFO_WRITE_DEPTH == 16 && CDC_DEST_SYNC_FF > 4) begin
      $error("[%s %0d-%0d] CDC_DEST_SYNC_FF = %0d and FIFO_WRITE_DEPTH = %0d. This is invalid combination. Either FIFO_WRITE_DEPTH should be increased or CDC_DEST_SYNC_FF should be reduced. %m", "XPM_FIFO", 1, 7,CDC_DEST_SYNC_FF, FIFO_WRITE_DEPTH);
      drc_err_flag = 1;
    end
    if (EN_ADV_FEATURE[7:5] != 3'h0) begin
      $error("[%s %0d-%0d] USE_ADV_FEATURES[7:5] = %0h. This is a reserved field and must be set to 0s. %m", "XPM_FIFO", 1, 8, EN_ADV_FEATURE[7:5]);
      drc_err_flag = 1;
    end
    if (EN_ADV_FEATURE[15:14] != 3'h0) begin
      $error("[%s %0d-%0d] USE_ADV_FEATURES[15:13] = %0h. This is a reserved field and must be set to 0s. %m", "XPM_FIFO", 1, 9, EN_ADV_FEATURE[15:13]);
      drc_err_flag = 1;
    end
//    if(WIDTH_RATIO > 32) begin
//      $error("[%s %0d-%0d] The ratio between WRITE_DATA_WIDTH (%0d) and READ_DATA_WIDTH (%0d) is greater than 32, but this release of XPM_FIFO supports configurations having the ratio between data widths must be less than 32. %m", "XPM_FIFO", 1, 10, WRITE_DATA_WIDTH, READ_DATA_WIDTH);
//      drc_err_flag = 1;
//    end
    if (WR_WIDTH_LOG+WR_DEPTH_LOG > 30) begin
      $error("[%s %0d-%0d] The specified Width(%0d) and Depth(%0d) exceeds the maximum supported FIFO SIZE. Please reduce either FIFO Width or Depth. %m", "XPM_FIFO", 1, 10, WRITE_DATA_WIDTH,FIFO_WRITE_DEPTH);
      drc_err_flag = 1;
    end
    if(FIFO_READ_DEPTH < 16) begin
      $error("[%s %0d-%0d] Write Width is %0d Read Width is %0d and Write Depth is %0d, this results in the Read Depth(%0d) less than 16. This is an invalid combination, Ensure the depth on both sides is minimum 16. %m", "XPM_FIFO", 1, 11, WRITE_DATA_WIDTH, READ_DATA_WIDTH, FIFO_WRITE_DEPTH, FIFO_READ_DEPTH);
      drc_err_flag = 1;
    end

    // Range Checks
    if (COMMON_CLOCK > 1) begin
      $error("[%s %0d-%0d] COMMON_CLOCK (%s) value is outside of legal range. %m", "XPM_FIFO", 10, 1, COMMON_CLOCK);
      drc_err_flag = 1;
    end
    if (FIFO_MEMORY_TYPE > 3) begin
      $error("[%s %0d-%0d] FIFO_MEMORY_TYPE (%s) value is outside of legal range. %m", "XPM_FIFO", 10, 2, FIFO_MEMORY_TYPE);
      drc_err_flag = 1;
    end
	if (READ_MODE > 2) begin
      $error("[%s %0d-%0d] READ_MODE (%s) value is outside of legal range. %m", "XPM_FIFO", 10, 3, READ_MODE);
      drc_err_flag = 1;
    end

    if (ECC_MODE > 1) begin
      $error("[%s %0d-%0d] ECC_MODE (%s) value is outside of legal range. %m", "XPM_FIFO", 10, 4, ECC_MODE);
      drc_err_flag = 1;
    end
	if (!(WAKEUP_TIME == 0 || WAKEUP_TIME == 2)) begin
      $error("[%s %0d-%0d] WAKEUP_TIME (%0d) value is outside of legal range. WAKEUP_TIME should be either 0 or 2. %m", "XPM_FIFO", 10, 5, WAKEUP_TIME);
      drc_err_flag = 1;
    end
    if (!(VERSION == 0)) begin
      $error("[%s %0d-%0d] VERSION (%0d) value is outside of legal range. %m", "XPM_FIFO", 10, 6, VERSION);
      drc_err_flag = 1;
    end

    if (!(WRITE_DATA_WIDTH > 0)) begin
      $error("[%s %0d-%0d] WRITE_DATA_WIDTH (%0d) value is outside of legal range. %m", "XPM_FIFO", 15, 2, WRITE_DATA_WIDTH);
      drc_err_flag = 1;
    end
    if (!(READ_DATA_WIDTH > 0)) begin
      $error("[%s %0d-%0d] READ_DATA_WIDTH (%0d) value is outside of legal range. %m", "XPM_FIFO", 15, 3, READ_DATA_WIDTH);
      drc_err_flag = 1;
    end

    if (EN_PF == 1 && ((PROG_FULL_THRESH < PF_THRESH_MIN) || (PROG_FULL_THRESH > PF_THRESH_MAX))) begin
      $error("[%s %0d-%0d] Programmable Full flag is enabled, but PROG_FULL_THRESH (%0d) value is outside of legal range. PROG_FULL_THRESH value must be between %0d and %0d. %m", "XPM_FIFO", 15, 4, PROG_FULL_THRESH, PF_THRESH_MIN, PF_THRESH_MAX);
      drc_err_flag = 1;
    end

    if (EN_PE == 1 && (WIDTH_RATIO <= 32) && ((PROG_EMPTY_THRESH < PE_THRESH_MIN) || (PROG_EMPTY_THRESH > PE_THRESH_MAX))) begin
      $error("[%s %0d-%0d] Programmable Empty flag is enabled, but PROG_EMPTY_THRESH (%0d) value is outside of legal range. PROG_EMPTY_THRESH value must be between %0d and %0d. %m", "XPM_FIFO", 15, 5, PROG_EMPTY_THRESH, PE_THRESH_MIN, PE_THRESH_MAX);
      drc_err_flag = 1;
    end

    if (EN_WDC == 1 && ((WR_DATA_COUNT_WIDTH < 0) || (WR_DATA_COUNT_WIDTH > WR_DC_WIDTH_EXT))) begin
      $error("[%s %0d-%0d] Write Data Count is enabled, but WR_DATA_COUNT_WIDTH (%0d) value is outside of legal range. WR_DATA_COUNT_WIDTH value must be between %0d and %0d. %m", "XPM_FIFO", 15, 6, WR_DATA_COUNT_WIDTH, 0, WR_DC_WIDTH_EXT);
      drc_err_flag = 1;
    end


    if (EN_RDC == 1 && ((RD_DATA_COUNT_WIDTH < 0) || (RD_DATA_COUNT_WIDTH > RD_DC_WIDTH_EXT))) begin
      $error("[%s %0d-%0d] Read Data Count is enabled, but RD_DATA_COUNT_WIDTH (%0d) value is outside of legal range. RD_DATA_COUNT_WIDTH value must be between %0d and %0d. %m", "XPM_FIFO", 15, 7, RD_DATA_COUNT_WIDTH, 0, RD_DC_WIDTH_EXT);
      drc_err_flag = 1;
    end

    //DRCs on Low Latency FWFT mode
    if (READ_MODE == 2 && FIFO_MEMORY_TYPE != 1) begin
      $error("[%s %0d-%0d] XPM_FIFO does not support Read Mode (Low Latency FWFT) for FIFO_MEMORY_TYPE other than lutram/distributed. %m", "XPM_FIFO", 16, 2);
      drc_err_flag = 1;
    end
    if (READ_MODE == 2 && EN_ADV_FEATURE != 16'h0) begin
      $error("[%s %0d-%0d] USE_ADV_FEATURES = %0h. XPM_FIFO does not support Advanced Features in Low Latency FWFT mode. %m", "XPM_FIFO", 16, 3, EN_ADV_FEATURE);
      drc_err_flag = 1;
    end

    // Infos

    // Warnings
    if (drc_err_flag == 1)
      #1 $finish;
  end : config_drc

  wire wr_en_i;
  wire wr_rst_i;
  wire rd_rst_i;
  reg  rd_rst_d2 = 1'b0;
  wire rst_d1;
  wire rst_d2;
  wire clr_full;
  wire empty_fwft_d1;
  wire leaving_empty_fwft_fe;
  wire leaving_empty_fwft_re;
  wire le_fwft_re;
  wire le_fwft_fe;
  wire [1:0] extra_words_fwft;
  wire le_fwft_re_wr;
  wire le_fwft_fe_wr;

  generate

  xpm_fifo_rst # (COMMON_CLOCK, CDC_DEST_SYNC_FF, SIM_ASSERT_CHK)
    xpm_fifo_rst_inst (rst, wr_clk, rd_clk, wr_rst_i, rd_rst_i, wrst_busy, rd_rst_busy);
  assign wr_rst_busy = wrst_busy | rst_d1;

  xpm_fifo_reg_bit #(0)
    rst_d1_inst (1'b0, wr_clk, wrst_busy, rst_d1);
  xpm_fifo_reg_bit #(0)
    rst_d2_inst (1'b0, wr_clk, rst_d1, rst_d2);

  assign clr_full = ~wrst_busy & rst_d1 & ~rst;
  assign rd_en_i = (RD_MODE == 0) ? rd_en : rd_en_fwft;

  if (REMOVE_WR_RD_PROT_LOGIC == 1) begin : ngen_wr_rd_prot
    assign ram_wr_en_i = wr_en;
    assign ram_rd_en_i = rd_en_i;
  end : ngen_wr_rd_prot
  else begin : gen_wr_rd_prot
    assign ram_wr_en_i = wr_en & ~ram_full_i & ~(wrst_busy|rst_d1);
    assign ram_rd_en_i = rd_en_i & ~ram_empty_i;
  end : gen_wr_rd_prot

  // Write pointer generation
  xpm_counter_updn # (WR_PNTR_WIDTH+1, 0)
    wrp_inst (wrst_busy, wr_clk, ram_wr_en_i, ram_wr_en_i, 1'b0, wr_pntr_ext);
  assign wr_pntr = wr_pntr_ext[WR_PNTR_WIDTH-1:0];

  xpm_counter_updn # (WR_PNTR_WIDTH, 1)
    wrpp1_inst (wrst_busy, wr_clk, ram_wr_en_i, ram_wr_en_i, 1'b0, wr_pntr_plus1);

  xpm_counter_updn # (WR_PNTR_WIDTH, 2)
    wrpp2_inst (wrst_busy, wr_clk, ram_wr_en_i, ram_wr_en_i, 1'b0, wr_pntr_plus2);

  if (EN_AF == 1) begin : gaf_wptr_p3
    xpm_counter_updn # (WR_PNTR_WIDTH, 3)
      wrpp3_inst (wrst_busy, wr_clk, ram_wr_en_i, ram_wr_en_i, 1'b0, wr_pntr_plus3);
  end : gaf_wptr_p3

  // Read pointer generation
  xpm_counter_updn # (RD_PNTR_WIDTH+1, 0)
    rdp_inst (rd_rst_i, rd_clk, ram_rd_en_i, ram_rd_en_i, 1'b0, rd_pntr_ext);
  assign rd_pntr = rd_pntr_ext[RD_PNTR_WIDTH-1:0];

  xpm_counter_updn # (RD_PNTR_WIDTH, 1)
    rdpp1_inst (rd_rst_i, rd_clk, ram_rd_en_i, ram_rd_en_i, 1'b0, rd_pntr_plus1);

  if (EN_AE == 1) begin : gae_rptr_p2
    xpm_counter_updn # (RD_PNTR_WIDTH, 2)
      rdpp2_inst (rd_rst_i, rd_clk, ram_rd_en_i, ram_rd_en_i, 1'b0, rd_pntr_plus2);
  end : gae_rptr_p2

  assign full        = ram_full_i;
  assign full_n      = ram_full_n;
  assign almost_full = EN_AF == 1 ? ram_afull_i : 1'b0;
  assign wr_ack      = EN_WACK == 1 ? wr_ack_i : 1'b0;
  if (EN_WACK == 1) begin : gwack
    always @ (posedge wr_clk) begin
      if (rst | wr_rst_i | wrst_busy)
        wr_ack_i  <= 1'b0;
      else
        wr_ack_i  <= ram_wr_en_i;
    end
  end : gwack

  assign prog_full  = EN_PF == 1 ? (PROG_FULL_THRESH > 0)  ? prog_full_i  : 1'b0 : 1'b0;
  assign prog_empty = EN_PE == 1 ? (PROG_EMPTY_THRESH > 0) ? prog_empty_i : 1'b1 : 1'b0;
  
  assign empty_i = (RD_MODE == 0)? ram_empty_i : empty_fwft_i;
  assign empty   = empty_i;
  assign almost_empty = EN_AE == 1 ? (RD_MODE == 0) ? ram_aempty_i : aempty_fwft_i : 1'b0;
  
  assign data_valid   = EN_DVLD == 1 ? (RD_MODE == 0) ? data_valid_std : data_valid_fwft : 1'b0;
  if (EN_DVLD == 1) begin : gdvld
    assign data_vld_std = (RD_MODE == 0) ? (FIFO_READ_LATENCY == 1) ? ram_rd_en_i: ram_regce_pipe : ram_regce;
    always @ (posedge rd_clk) begin
      if (rd_rst_i)
        data_valid_std  <= 1'b0;
      else
        data_valid_std  <= data_vld_std;
    end
  end : gdvld

  // Simple dual port RAM instantiation for non-Built-in FIFO
  if (FIFO_MEMORY_TYPE < 4) begin : gen_sdpram

  // Reset is not supported when ECC is enabled by the BRAM/URAM primitives
    wire rst_int;
    if(ECC_MODE !=0) begin : gnd_rst
      assign rst_int = 0;
    end : gnd_rst
    else begin : rst_gen
      assign rst_int = rd_rst_i;
    end : rst_gen
  // ----------------------------------------------------------------------
  // Base module instantiation with simple dual port RAM configuration
  // ----------------------------------------------------------------------
  localparam USE_DRAM_CONSTRAINT = (COMMON_CLOCK == 0 && FIFO_MEMORY_TYPE == 1) ? 1 : 0;
  localparam WR_MODE_B           = (FIFO_MEMORY_TYPE == 1 || FIFO_MEMORY_TYPE == 3) ? 1 : 2;
  xpm_memory_base # (

    // Common module parameters
    .MEMORY_TYPE              (1                    ),
    .MEMORY_SIZE              (FIFO_SIZE            ),
    .MEMORY_PRIMITIVE         (FIFO_MEMORY_TYPE     ),
    .CLOCKING_MODE            (COMMON_CLOCK ? 0 : 1 ),
    .ECC_MODE                 (ENABLE_ECC           ),
    .USE_MEM_INIT             (0                    ),
    .MEMORY_INIT_FILE         ("none"               ),
    .MEMORY_INIT_PARAM        (""                   ),
    .WAKEUP_TIME              (WAKEUP_TIME          ),
    .MESSAGE_CONTROL          (0                    ),
    .VERSION                  (0                    ),
    .MEMORY_OPTIMIZATION      ("true"               ),
    .AUTO_SLEEP_TIME          (0                    ),
    .USE_EMBEDDED_CONSTRAINT  (USE_DRAM_CONSTRAINT  ),
    .CASCADE_HEIGHT           (CASCADE_HEIGHT       ),

    // Port A module parameters
    .WRITE_DATA_WIDTH_A       (WRITE_DATA_WIDTH     ),
    .READ_DATA_WIDTH_A        (WRITE_DATA_WIDTH     ),
    .BYTE_WRITE_WIDTH_A       (WRITE_DATA_WIDTH     ),
    .ADDR_WIDTH_A             (WR_PNTR_WIDTH        ),
    .READ_RESET_VALUE_A       ("0"                  ),
    .READ_LATENCY_A           (2                    ),
    .WRITE_MODE_A             (2                    ),

    // Port B module parameters
    .WRITE_DATA_WIDTH_B       (READ_DATA_WIDTH      ),
    .READ_DATA_WIDTH_B        (READ_DATA_WIDTH      ),
    .BYTE_WRITE_WIDTH_B       (READ_DATA_WIDTH      ),
    .ADDR_WIDTH_B             (RD_PNTR_WIDTH        ),
    .READ_RESET_VALUE_B       (DOUT_RESET_VALUE     ),
    .READ_LATENCY_B           (RD_LATENCY           ),
    .WRITE_MODE_B             (WR_MODE_B            )
  ) xpm_memory_base_inst (

    // Common module ports
    .sleep          (sleep                    ),

    // Port A module ports
    .clka           (wr_clk                   ),
    .rsta           (1'b0                     ),
    .ena            (ram_wr_en_i              ),
    .regcea         (1'b0                     ),
    .wea            (ram_wr_en_i              ),
    .addra          (wr_pntr                  ),
    .dina           (din                      ),
    .injectsbiterra (injectsbiterr            ),
    .injectdbiterra (injectdbiterr            ),
    .douta          (                         ),
    .sbiterra       (                         ),
    .dbiterra       (                         ),

    // Port B module ports
    .clkb           (rd_clk                   ),
    .rstb           (rst_int                  ),
    .enb            (ram_rd_en_i              ),
    .regceb         (READ_MODE == 0 ? ram_regce_pipe: ram_regce),
    .web            (1'b0                     ),
    .addrb          (rd_pntr                  ),
    .dinb           ({READ_DATA_WIDTH{1'b0}}  ),
    .injectsbiterrb (1'b0                     ),
    .injectdbiterrb (1'b0                     ),
    .doutb          (dout_i                   ),
    .sbiterrb       (sbiterr                  ),
    .dbiterrb       (dbiterr                  )
  );
  end : gen_sdpram

  if (WR_PNTR_WIDTH == RD_PNTR_WIDTH) begin : wrp_eq_rdp
    assign wr_pntr_rd_adj    = wr_pntr_rd[WR_PNTR_WIDTH-1:WR_PNTR_WIDTH-RD_PNTR_WIDTH];
    assign wr_pntr_rd_adj_dc = wr_pntr_rd_dc[WR_PNTR_WIDTH:WR_PNTR_WIDTH-RD_PNTR_WIDTH];
    assign rd_pntr_wr_adj    = rd_pntr_wr[RD_PNTR_WIDTH-1:RD_PNTR_WIDTH-WR_PNTR_WIDTH];
    assign rd_pntr_wr_adj_dc = rd_pntr_wr_dc[RD_PNTR_WIDTH:RD_PNTR_WIDTH-WR_PNTR_WIDTH];
  end : wrp_eq_rdp

  if (WR_PNTR_WIDTH > RD_PNTR_WIDTH) begin : wrp_gt_rdp
    assign wr_pntr_rd_adj = wr_pntr_rd[WR_PNTR_WIDTH-1:WR_PNTR_WIDTH-RD_PNTR_WIDTH];
    assign wr_pntr_rd_adj_dc = wr_pntr_rd_dc[WR_PNTR_WIDTH:WR_PNTR_WIDTH-RD_PNTR_WIDTH];
    assign rd_pntr_wr_adj[WR_PNTR_WIDTH-1:WR_PNTR_WIDTH-RD_PNTR_WIDTH] = rd_pntr_wr;
    assign rd_pntr_wr_adj[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1:0] = {(WR_PNTR_WIDTH-RD_PNTR_WIDTH){1'b0}};
    assign rd_pntr_wr_adj_dc[WR_PNTR_WIDTH:WR_PNTR_WIDTH-RD_PNTR_WIDTH] = rd_pntr_wr_dc;
    assign rd_pntr_wr_adj_dc[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1:0] = {(WR_PNTR_WIDTH-RD_PNTR_WIDTH){1'b0}};
  end : wrp_gt_rdp

  if (WR_PNTR_WIDTH < RD_PNTR_WIDTH) begin : wrp_lt_rdp
    assign wr_pntr_rd_adj[RD_PNTR_WIDTH-1:RD_PNTR_WIDTH-WR_PNTR_WIDTH] = wr_pntr_rd;
    assign wr_pntr_rd_adj[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1:0] = {(RD_PNTR_WIDTH-WR_PNTR_WIDTH){1'b0}};
    assign wr_pntr_rd_adj_dc[RD_PNTR_WIDTH:RD_PNTR_WIDTH-WR_PNTR_WIDTH] = wr_pntr_rd_dc;
    assign wr_pntr_rd_adj_dc[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1:0] = {(RD_PNTR_WIDTH-WR_PNTR_WIDTH){1'b0}};
    assign rd_pntr_wr_adj = rd_pntr_wr[RD_PNTR_WIDTH-1:RD_PNTR_WIDTH-WR_PNTR_WIDTH];
    assign rd_pntr_wr_adj_dc = rd_pntr_wr_dc[RD_PNTR_WIDTH:RD_PNTR_WIDTH-WR_PNTR_WIDTH];
  end : wrp_lt_rdp

  if (COMMON_CLOCK == 0 && RELATED_CLOCKS == 0) begin : gen_cdc_pntr
    // Synchronize the write pointer in rd_clk domain
    xpm_cdc_gray #(
      .DEST_SYNC_FF          (CDC_DEST_SYNC_FF),
      .INIT_SYNC_FF          (1),
      .WIDTH                 (WR_PNTR_WIDTH))
      
      wr_pntr_cdc_inst (
        .src_clk             (wr_clk),
        .src_in_bin          (wr_pntr),
        .dest_clk            (rd_clk),
        .dest_out_bin        (wr_pntr_rd_cdc));

    // Register the output of XPM_CDC_GRAY on read side
    xpm_fifo_reg_vec #(WR_PNTR_WIDTH)
      wpr_gray_reg (rd_rst_i, rd_clk, wr_pntr_rd_cdc, wr_pntr_rd);

    // Synchronize the extended write pointer in rd_clk domain
    xpm_cdc_gray #(
      .DEST_SYNC_FF          (READ_MODE == 0 ? CDC_DEST_SYNC_FF : CDC_DEST_SYNC_FF+2),
      .INIT_SYNC_FF          (1),
      .WIDTH                 (WR_PNTR_WIDTH+1))
      wr_pntr_cdc_dc_inst (
        .src_clk             (wr_clk),
        .src_in_bin          (wr_pntr_ext),
        .dest_clk            (rd_clk),
        .dest_out_bin        (wr_pntr_rd_cdc_dc));

    // Register the output of XPM_CDC_GRAY on read side
    xpm_fifo_reg_vec #(WR_PNTR_WIDTH+1)
      wpr_gray_reg_dc (rd_rst_i, rd_clk, wr_pntr_rd_cdc_dc, wr_pntr_rd_dc);

    // Synchronize the read pointer in wr_clk domain
    xpm_cdc_gray #(
      .DEST_SYNC_FF          (CDC_DEST_SYNC_FF),
      .INIT_SYNC_FF          (1),
      .WIDTH                 (RD_PNTR_WIDTH))
      rd_pntr_cdc_inst (
        .src_clk             (rd_clk),
        .src_in_bin          (rd_pntr),
        .dest_clk            (wr_clk),
        .dest_out_bin        (rd_pntr_wr_cdc));

    // Register the output of XPM_CDC_GRAY on write side
    xpm_fifo_reg_vec #(RD_PNTR_WIDTH)
      rpw_gray_reg (wrst_busy, wr_clk, rd_pntr_wr_cdc, rd_pntr_wr);

    // Synchronize the read pointer, subtracted by the extra word read for FWFT, in wr_clk domain
    xpm_cdc_gray #(
      .DEST_SYNC_FF          (CDC_DEST_SYNC_FF),
      .INIT_SYNC_FF          (1),
      .WIDTH                 (RD_PNTR_WIDTH+1))
      rd_pntr_cdc_dc_inst (
        .src_clk             (rd_clk),
        .src_in_bin          (rd_pntr_ext-extra_words_fwft),
        .dest_clk            (wr_clk),
        .dest_out_bin        (rd_pntr_wr_cdc_dc));

    // Register the output of XPM_CDC_GRAY on write side
    xpm_fifo_reg_vec #(RD_PNTR_WIDTH+1)
      rpw_gray_reg_dc (wrst_busy, wr_clk, rd_pntr_wr_cdc_dc, rd_pntr_wr_dc);

  end : gen_cdc_pntr

  if (RELATED_CLOCKS == 1) begin : gen_pntr_pf_rc
    xpm_fifo_reg_vec #(RD_PNTR_WIDTH)
      rpw_rc_reg (wrst_busy, wr_clk, rd_pntr, rd_pntr_wr);

    xpm_fifo_reg_vec #(WR_PNTR_WIDTH)
      wpr_rc_reg (rd_rst_i, rd_clk, wr_pntr, wr_pntr_rd);

    xpm_fifo_reg_vec #(WR_PNTR_WIDTH+1)
      wpr_rc_reg_dc (rd_rst_i, rd_clk, wr_pntr_ext, wr_pntr_rd_dc);

    xpm_fifo_reg_vec #(RD_PNTR_WIDTH+1)
      rpw_rc_reg_dc (wrst_busy, wr_clk, (rd_pntr_ext-extra_words_fwft), rd_pntr_wr_dc);
  end : gen_pntr_pf_rc

  if (COMMON_CLOCK == 0 || RELATED_CLOCKS == 1) begin : gen_pf_ic_rc
  
    assign going_empty     = ((wr_pntr_rd_adj == rd_pntr_plus1) & ram_rd_en_i);
    assign leaving_empty   = ((wr_pntr_rd_adj == rd_pntr));
    assign going_aempty    = ((wr_pntr_rd_adj == rd_pntr_plus2) & ram_rd_en_i);
    assign leaving_aempty  = ((wr_pntr_rd_adj == rd_pntr_plus1));
  
    assign going_full      = ((rd_pntr_wr_adj == wr_pntr_plus2) & ram_wr_en_i);
    assign leaving_full    = ((rd_pntr_wr_adj == wr_pntr_plus1));
    assign going_afull     = ((rd_pntr_wr_adj == wr_pntr_plus3) & ram_wr_en_i);
    assign leaving_afull   = ((rd_pntr_wr_adj == wr_pntr_plus2));
  
    // Empty flag generation
    always @ (posedge rd_clk) begin
      if (rd_rst_i) begin
         ram_empty_i  <= 1'b1;
      end else begin
         ram_empty_i  <= going_empty | leaving_empty;
      end
    end

    if (EN_AE == 1) begin : gae_ic_std
      always @ (posedge rd_clk) begin
        if (rd_rst_i) begin
          ram_aempty_i <= 1'b1;
        end else if (~ram_empty_i) begin
          ram_aempty_i <= going_aempty | leaving_aempty;
        end
      end
    end : gae_ic_std
  
    // Full flag generation
    if (FULL_RST_VAL == 1) begin : gen_full_rst_val
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_full_i      <= FULL_RST_VAL;
          ram_full_n      <= ~FULL_RST_VAL;
        end else begin
	  if (clr_full) begin
            ram_full_i    <= 1'b0;
            ram_full_n    <= 1'b1;
	  end else begin
            ram_full_i    <= going_full | leaving_full;
            ram_full_n    <= ~(going_full | leaving_full);
          end
        end
      end
    end : gen_full_rst_val
    else begin : ngen_full_rst_val
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_full_i   <= 1'b0;
          ram_full_n   <= 1'b1;
	end else begin
          ram_full_i   <= going_full | leaving_full;
          ram_full_n   <= ~(going_full | leaving_full);
	end
      end
    end : ngen_full_rst_val

    if (EN_AF == 1) begin : gaf_ic
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_afull_i  <= FULL_RST_VAL;
        end else if (~rst) begin
	  if (clr_full) begin
            ram_afull_i  <= 1'b0;
	  end else if (~ram_full_i) begin
            ram_afull_i  <= going_afull | leaving_afull;
          end
        end
      end
    end : gaf_ic

  // synthesis translate_off
    `ifndef DISABLE_XPM_ASSERTIONS
    if (SIM_ASSERT_CHK == 1) begin: assert_wr_rd_en
      always @ (posedge rd_clk) begin
        assert (!$isunknown(rd_en)) else $warning ("Input port 'rd_en' has unknown value 'X' or 'Z' at %0t. This may cause full/empty to be 'X' or 'Z' in simulation. Ensure 'rd_en' has a valid value ('0' or '1')",$time);
      end

      always @ (posedge wr_clk) begin
        assert (!$isunknown(wr_en)) else $warning ("Input port 'wr_en' has unknown value 'X' or 'Z' at %0t. This may cause full/empty to be 'X' or 'Z' in simulation. Ensure 'wr_en' has a valid value ('0' or '1')",$time);
      end

      always @ (posedge wr_clk) begin
        assert (!$isunknown(wr_en)) else $warning ("Input port 'wr_en' has unknown value 'X' or 'Z' at %0t. This may cause full/empty to be 'X' or 'Z' in simulation. Ensure 'wr_en' has a valid value ('0' or '1')",$time);
      end

    end : assert_wr_rd_en
    `endif
  // synthesis translate_on

    // Programmable Full flag generation
    if (EN_PF == 1) begin : gpf_ic
      assign wr_pntr_plus1_pf = {wr_pntr_plus1,wr_pntr_plus1_pf_carry};
      assign rd_pntr_wr_adj_inv_pf = {~rd_pntr_wr_adj,rd_pntr_wr_adj_pf_carry};
  
      // PF carry generation
      assign wr_pntr_plus1_pf_carry  = ram_wr_en_i;
      assign rd_pntr_wr_adj_pf_carry = ram_wr_en_i;
  
      // PF diff pointer generation
      always @ (posedge wr_clk) begin
        if (wrst_busy)
           diff_pntr_pf_q  <= {WR_PNTR_WIDTH{1'b0}};
        else
           diff_pntr_pf_q  <= wr_pntr_plus1_pf + rd_pntr_wr_adj_inv_pf;
      end
      assign diff_pntr_pf = diff_pntr_pf_q[WR_PNTR_WIDTH:1];
  
      always @ (posedge wr_clk) begin
        if (wrst_busy)
           prog_full_i  <= FULL_RST_VAL;
        else if (clr_full)
           prog_full_i  <= 1'b0;
        else if (~ram_full_i) begin
          if (diff_pntr_pf >= PF_THRESH_ADJ)
            prog_full_i  <= 1'b1;
          else
            prog_full_i  <= 1'b0;
        end else
          prog_full_i  <= prog_full_i;
      end
    end : gpf_ic

    /*********************************************************
     * Programmable EMPTY flags
     *********************************************************/
    //Determine the Assert and Negate thresholds for Programmable Empty
    if (EN_PE == 1) begin : gpe_ic
 
      always @(posedge rd_clk) begin
        if (rd_rst_i) begin
          diff_pntr_pe      <= 0;
          prog_empty_i       <= 1'b1;
        end else begin
          if (ram_rd_en_i)
            diff_pntr_pe       <=  (wr_pntr_rd_adj - rd_pntr) - 1'h1;
          else
            diff_pntr_pe       <=  (wr_pntr_rd_adj - rd_pntr);
     
          if (~empty_i) begin
            if (diff_pntr_pe <= PE_THRESH_ADJ)
              prog_empty_i <= 1'b1;
            else
              prog_empty_i <= 1'b0;
          end else
            prog_empty_i   <= prog_empty_i;
        end
      end
    end : gpe_ic
  end : gen_pf_ic_rc

  if (COMMON_CLOCK == 1 && RELATED_CLOCKS == 0) begin : gen_pntr_flags_cc
    assign wr_pntr_rd = wr_pntr;
    assign rd_pntr_wr = rd_pntr;
    assign wr_pntr_rd_dc = wr_pntr_ext;
    assign rd_pntr_wr_dc = rd_pntr_ext-extra_words_fwft;
    assign write_allow  = ram_wr_en_i & ~ram_full_i;
    assign read_allow   = ram_rd_en_i & ~empty_i;

    if (WR_PNTR_WIDTH == RD_PNTR_WIDTH) begin : wrp_eq_rdp
      assign ram_wr_en_pf  = ram_wr_en_i;
      assign ram_rd_en_pf  = ram_rd_en_i;
  
      assign going_empty    = ((wr_pntr_rd_adj == rd_pntr_plus1) & ~ram_wr_en_i & ram_rd_en_i);
      assign leaving_empty  = ((wr_pntr_rd_adj == rd_pntr) & ram_wr_en_i);
      assign going_aempty   = ((wr_pntr_rd_adj == rd_pntr_plus2) & ~ram_wr_en_i & ram_rd_en_i);
      assign leaving_aempty = ((wr_pntr_rd_adj == rd_pntr_plus1) & ram_wr_en_i & ~ram_rd_en_i);
  
      assign going_full     = ((rd_pntr_wr_adj == wr_pntr_plus1) & ram_wr_en_i & ~ram_rd_en_i);
      assign leaving_full   = ((rd_pntr_wr_adj == wr_pntr) & ram_rd_en_i);
      assign going_afull    = ((rd_pntr_wr_adj == wr_pntr_plus2) & ram_wr_en_i & ~ram_rd_en_i);
      assign leaving_afull  = ((rd_pntr_wr_adj == wr_pntr_plus1) & ram_rd_en_i & ~ram_wr_en_i);

      assign write_only    = write_allow & ~read_allow;
      assign read_only     = read_allow & ~write_allow;

    end : wrp_eq_rdp
  
    if (WR_PNTR_WIDTH > RD_PNTR_WIDTH) begin : wrp_gt_rdp
      assign wrp_gt_rdp_and_red = &wr_pntr_rd[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1:0];
  
      assign going_empty    = ((wr_pntr_rd_adj == rd_pntr_plus1) & ~(ram_wr_en_i & wrp_gt_rdp_and_red) & ram_rd_en_i);
      assign leaving_empty  = ((wr_pntr_rd_adj == rd_pntr) & (ram_wr_en_i & wrp_gt_rdp_and_red));
      assign going_aempty   = ((wr_pntr_rd_adj == rd_pntr_plus2) & ~(ram_wr_en_i & wrp_gt_rdp_and_red) & ram_rd_en_i);
      assign leaving_aempty = ((wr_pntr_rd_adj == rd_pntr_plus1) & (ram_wr_en_i & wrp_gt_rdp_and_red) & ~ram_rd_en_i);
  
      assign going_full     = ((rd_pntr_wr_adj == wr_pntr_plus1) & ram_wr_en_i & ~ram_rd_en_i);
      assign leaving_full   = ((rd_pntr_wr_adj == wr_pntr) & ram_rd_en_i);
      assign going_afull    = ((rd_pntr_wr_adj == wr_pntr_plus2) & ram_wr_en_i & ~ram_rd_en_i);
      assign leaving_afull  = (((rd_pntr_wr_adj == wr_pntr) | (rd_pntr_wr_adj == wr_pntr_plus1) | (rd_pntr_wr_adj == wr_pntr_plus2)) & ram_rd_en_i);
  
      assign ram_wr_en_pf  = ram_wr_en_i & wrp_gt_rdp_and_red;
      assign ram_rd_en_pf  = ram_rd_en_i;

      assign read_only     = read_allow & (~(write_allow  & (&wr_pntr[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1 : 0])));
      assign write_only    = write_allow & (&wr_pntr[WR_PNTR_WIDTH-RD_PNTR_WIDTH-1 : 0]) & ~read_allow;


    end : wrp_gt_rdp
  
    if (WR_PNTR_WIDTH < RD_PNTR_WIDTH) begin : wrp_lt_rdp
      assign wrp_lt_rdp_and_red = &rd_pntr_wr[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1:0];
  
      assign going_empty     = ((wr_pntr_rd_adj == rd_pntr_plus1) & ~ram_wr_en_i & ram_rd_en_i);
      assign leaving_empty   = ((wr_pntr_rd_adj == rd_pntr) & ram_wr_en_i);
      assign going_aempty    = ((wr_pntr_rd_adj == rd_pntr_plus2) & ~ram_wr_en_i & ram_rd_en_i);
      assign leaving_aempty  = (((wr_pntr_rd_adj == rd_pntr) | (wr_pntr_rd_adj == rd_pntr_plus1) | (wr_pntr_rd_adj == rd_pntr_plus2)) & ram_wr_en_i);
  
      assign going_full      = ((rd_pntr_wr_adj == wr_pntr_plus1) & ~(ram_rd_en_i & wrp_lt_rdp_and_red) & ram_wr_en_i);
      assign leaving_full    = ((rd_pntr_wr_adj == wr_pntr) & (ram_rd_en_i & wrp_lt_rdp_and_red));
      assign going_afull     = ((rd_pntr_wr_adj == wr_pntr_plus2) & ~(ram_rd_en_i & wrp_lt_rdp_and_red) & ram_wr_en_i);
      assign leaving_afull   = ((rd_pntr_wr_adj == wr_pntr_plus1) & ~ram_wr_en_i & (ram_rd_en_i & wrp_lt_rdp_and_red));
  
      assign ram_wr_en_pf = ram_wr_en_i;
      assign ram_rd_en_pf = ram_rd_en_i & wrp_lt_rdp_and_red;

      assign read_only   = read_allow & (&rd_pntr[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1 : 0]) & ~write_allow;
      assign write_only    = write_allow    & (~(read_allow & (&rd_pntr[RD_PNTR_WIDTH-WR_PNTR_WIDTH-1 : 0])));
    end : wrp_lt_rdp
  
    // Empty flag generation
    always @ (posedge rd_clk) begin
      if (rd_rst_i) begin
         ram_empty_i  <= 1'b1;
      end else begin
         ram_empty_i  <= going_empty | (~leaving_empty & ram_empty_i);
      end
    end

    if (EN_AE == 1) begin : gae_cc_std
      always @ (posedge rd_clk) begin
        if (rd_rst_i) begin
          ram_aempty_i <= 1'b1;
        end else begin
          ram_aempty_i <= going_aempty | (~leaving_aempty & ram_aempty_i);
        end
      end
    end : gae_cc_std

    // Full flag generation
    if (FULL_RST_VAL == 1) begin : gen_full_rst_val
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_full_i   <= FULL_RST_VAL;
          ram_full_n   <= ~FULL_RST_VAL;
        end else begin
	  if (clr_full) begin
            ram_full_i   <= 1'b0;
            ram_full_n   <= 1'b1;
	  end else begin
            ram_full_i   <= going_full | (~leaving_full & ram_full_i);
            ram_full_n   <= ~(going_full | (~leaving_full & ram_full_i));
          end
        end
      end
    end : gen_full_rst_val
    else begin : ngen_full_rst_val
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_full_i   <= 1'b0;
          ram_full_n   <= 1'b1;
	end else begin
          ram_full_i   <= going_full | (~leaving_full & ram_full_i);
          ram_full_n   <= ~(going_full | (~leaving_full & ram_full_i));
	end
      end
    end : ngen_full_rst_val

    if (EN_AF == 1) begin : gaf_cc
      always @ (posedge wr_clk) begin
	if (wrst_busy) begin
          ram_afull_i  <= FULL_RST_VAL;
        end else if (~rst) begin
	  if (clr_full) begin
            ram_afull_i  <= 1'b0;
	  end else begin
            ram_afull_i  <= going_afull | (~leaving_afull & ram_afull_i);
          end
        end
      end
    end : gaf_cc
    // Programmable Full flag generation
    if ((WR_PNTR_WIDTH == RD_PNTR_WIDTH) && (RELATED_CLOCKS == 0)) begin : wrp_eq_rdp_pf_cc
      if (EN_PF == 1) begin : gpf_cc_sym

        assign wr_pntr_plus1_pf = {wr_pntr_plus1,wr_pntr_plus1_pf_carry};
        assign rd_pntr_wr_adj_inv_pf = {~rd_pntr_wr_adj,rd_pntr_wr_adj_pf_carry};
  
        // Delayed write/read enable for PF generation
        always @ (posedge wr_clk) begin
          if (wrst_busy) begin
             ram_wr_en_pf_q   <= 1'b0;
             ram_rd_en_pf_q   <= 1'b0;
          end else begin
             ram_wr_en_pf_q   <= ram_wr_en_pf;
             ram_rd_en_pf_q   <= ram_rd_en_pf;
          end
        end
  
        // PF carry generation
       assign wr_pntr_plus1_pf_carry  = ram_wr_en_i & ~ram_rd_en_pf;
       assign rd_pntr_wr_adj_pf_carry = ram_wr_en_i & ~ram_rd_en_pf;
  
        // PF diff pointer generation
        always @ (posedge wr_clk) begin
          if (wrst_busy)
             diff_pntr_pf_q  <= {WR_PNTR_WIDTH{1'b0}};
          else
             diff_pntr_pf_q  <= wr_pntr_plus1_pf + rd_pntr_wr_adj_inv_pf;
        end
        assign diff_pntr_pf = diff_pntr_pf_q[WR_PNTR_WIDTH:1];
  
        always @ (posedge wr_clk) begin
          if (wrst_busy)
             prog_full_i  <= FULL_RST_VAL;
          else if (clr_full)
             prog_full_i  <= 1'b0;
          else if ((diff_pntr_pf == PF_THRESH_ADJ) & ram_wr_en_pf_q & ~ram_rd_en_pf_q)
             prog_full_i  <= 1'b1;
          else if ((diff_pntr_pf == PF_THRESH_ADJ) & ~ram_wr_en_pf_q & ram_rd_en_pf_q)
             prog_full_i  <= 1'b0;
          else
             prog_full_i  <= prog_full_i;
        end
      end : gpf_cc_sym

      if (EN_PE == 1) begin : gpe_cc_sym
        always @(posedge rd_clk) begin
          if (rd_rst_i) begin
            read_only_q    <= 1'b0;
            write_only_q   <= 1'b0;
            diff_pntr_pe   <= 0;
          end 
          else begin
            read_only_q  <= read_only;
            write_only_q <= write_only;
            // Add 1 to the difference pointer value when write or both write & read or no write & read happen.
            if (read_only)
              diff_pntr_pe <= wr_pntr_rd_adj - rd_pntr - 1;
            else
              diff_pntr_pe <= wr_pntr_rd_adj - rd_pntr;
          end
        end
  
        always @(posedge rd_clk) begin
          if (rd_rst_i)
            prog_empty_i  <= 1'b1;
          else begin
            if (diff_pntr_pe == PE_THRESH_ADJ && read_only_q)
              prog_empty_i <= 1'b1;
            else if (diff_pntr_pe == PE_THRESH_ADJ && write_only_q)
              prog_empty_i <= 1'b0;
            else
              prog_empty_i <= prog_empty_i;
          end
        end
      end : gpe_cc_sym
    end : wrp_eq_rdp_pf_cc

    if ((WR_PNTR_WIDTH != RD_PNTR_WIDTH) && (RELATED_CLOCKS == 0)) begin : wrp_neq_rdp_pf_cc
      if (EN_PF == 1) begin : gpf_cc_asym
        // PF diff pointer generation
        always @ (posedge wr_clk) begin
          if (wrst_busy)
             diff_pntr_pf_q  <= {WR_PNTR_WIDTH{1'b0}};
          else if (~ram_full_i)
             diff_pntr_pf_q[WR_PNTR_WIDTH:1]  <= wr_pntr + ~rd_pntr_wr_adj + 1;
        end
        assign diff_pntr_pf = diff_pntr_pf_q[WR_PNTR_WIDTH:1];
        always @ (posedge wr_clk) begin
          if (wrst_busy)
             prog_full_i  <= FULL_RST_VAL;
          else if (clr_full)
             prog_full_i  <= 1'b0;
          else if (~ram_full_i) begin
            if (diff_pntr_pf >= PF_THRESH_ADJ)
               prog_full_i  <= 1'b1;
            else if (diff_pntr_pf < PF_THRESH_ADJ)
               prog_full_i  <= 1'b0;
            else
               prog_full_i  <= prog_full_i;
          end
        end
      end : gpf_cc_asym
      if (EN_PE == 1) begin : gpe_cc_asym
        // Programmanble Empty flag Generation
        // Diff pointer Generation
        localparam [RD_PNTR_WIDTH-1 : 0] DIFF_MAX_RD = {RD_PNTR_WIDTH{1'b1}};
        wire [RD_PNTR_WIDTH-1:0] diff_pntr_pe_max;
        wire                     carry;
        reg  [RD_PNTR_WIDTH : 0] diff_pntr_pe_asym = 'b0;
        wire [RD_PNTR_WIDTH : 0] wr_pntr_rd_adj_asym;
        wire [RD_PNTR_WIDTH : 0] rd_pntr_asym;
        reg                      full_reg;
        reg                      rst_full_ff_reg1;
        reg                      rst_full_ff_reg2;
  
        assign diff_pntr_pe_max = DIFF_MAX_RD;
        assign wr_pntr_rd_adj_asym[RD_PNTR_WIDTH:0] = {wr_pntr_rd_adj,1'b1};
        assign rd_pntr_asym[RD_PNTR_WIDTH:0] = {~rd_pntr,1'b1};
  
        always @(posedge rd_clk ) begin
          if (rd_rst_i) begin
            diff_pntr_pe_asym    <= 0;
            full_reg             <= 0;
            rst_full_ff_reg1     <= 1;
            rst_full_ff_reg2     <= 1;
            diff_pntr_pe_reg1    <= 0;
          end else begin
            diff_pntr_pe_asym <= wr_pntr_rd_adj_asym + rd_pntr_asym;
            full_reg          <= ram_full_i;
            rst_full_ff_reg1  <= FULL_RST_VAL;
            rst_full_ff_reg2  <= rst_full_ff_reg1;
          end
        end
        wire [RD_PNTR_WIDTH-1:0]    diff_pntr_pe_i;
        assign carry = (~(|(diff_pntr_pe_asym [RD_PNTR_WIDTH : 1])));
        assign diff_pntr_pe_i = (full_reg && ~rst_d2 && carry ) ? diff_pntr_pe_max : diff_pntr_pe_asym[RD_PNTR_WIDTH:1];
    
        always @(posedge rd_clk) begin
          if (rd_rst_i)
            prog_empty_i  <= 1'b1;
          else begin
            if (diff_pntr_pe_i <= PE_THRESH_ADJ)
              prog_empty_i <= 1'b1;
            else if (diff_pntr_pe_i > PE_THRESH_ADJ)
              prog_empty_i <= 1'b0;
            else
              prog_empty_i <= prog_empty_i;
          end
        end
      end : gpe_cc_asym
    end : wrp_neq_rdp_pf_cc

  end : gen_pntr_flags_cc

  if (READ_MODE == 0 && FIFO_READ_LATENCY > 1) begin : gen_regce_std
    xpm_reg_pipe_bit #(FIFO_READ_LATENCY-1, 0)
      regce_pipe_inst (rd_rst_i, rd_clk, ram_rd_en_i, ram_regce_pipe);
  end : gen_regce_std
  if (!(READ_MODE == 0 && FIFO_READ_LATENCY > 1)) begin : gnen_regce_std
    assign ram_regce_pipe = 1'b0;
  end : gnen_regce_std

  if (!((READ_MODE == 1 || READ_MODE == 2)&& FIFO_MEMORY_TYPE != 4)) begin : gn_fwft
   assign invalid_state = 1'b0;
  end : gn_fwft
  //if (READ_MODE == 1 && FIFO_MEMORY_TYPE != 4) begin : gen_fwft
  if (READ_MODE != 0 && FIFO_MEMORY_TYPE != 4) begin : gen_fwft
  // First word fall through logic

   //localparam invalid             = 0;
   //localparam stage1_valid        = 2;
   //localparam stage2_valid        = 1;
   //localparam both_stages_valid   = 3;

   //reg  [1:0] curr_fwft_state = invalid;
   //reg  [1:0] next_fwft_state;// = invalid;
   wire next_fwft_state_d1;
   assign invalid_state = ~|curr_fwft_state;
   assign valid_fwft = next_fwft_state_d1;
   assign ram_valid_fwft = curr_fwft_state[1];

    xpm_fifo_reg_bit #(0)
      next_state_d1_inst (1'b0, rd_clk, next_fwft_state[0], next_fwft_state_d1);
   //FSM : To generate the enable, clock enable for xpm_memory and to generate
   //empty signal
   //FSM : Next state Assignment
     if (READ_MODE == 1) begin : gen_fwft_ns
     always @(curr_fwft_state or ram_empty_i or rd_en) begin
       case (curr_fwft_state)
         invalid: begin
           if (~ram_empty_i)
              next_fwft_state     = stage1_valid;
           else
              next_fwft_state     = invalid;
           end
         stage1_valid: begin
           if (ram_empty_i)
              next_fwft_state     = stage2_valid;
           else
              next_fwft_state     = both_stages_valid;
           end
         stage2_valid: begin
           if (ram_empty_i && rd_en)
              next_fwft_state     = invalid;
           else if (~ram_empty_i && rd_en)
              next_fwft_state     = stage1_valid;
           else if (~ram_empty_i && ~rd_en)
              next_fwft_state     = both_stages_valid;
           else
              next_fwft_state     = stage2_valid;
           end
         both_stages_valid: begin
           if (ram_empty_i && rd_en)
              next_fwft_state     = stage2_valid;
           else if (~ram_empty_i && rd_en)
              next_fwft_state     = both_stages_valid;
           else
              next_fwft_state     = both_stages_valid;
           end
         default: next_fwft_state    = invalid;
       endcase
     end
     end : gen_fwft_ns
     if (READ_MODE == 2) begin : gen_fwft_ns_ll
     always @(curr_fwft_state or ram_empty_i or rd_en) begin
       case (curr_fwft_state)
         invalid: begin
           if (~ram_empty_i)
              next_fwft_state     = stage1_valid;
           else
              next_fwft_state     = invalid;
           end
         stage1_valid: begin
           if (ram_empty_i && rd_en)
              next_fwft_state     = invalid;
           else
              next_fwft_state     = stage1_valid;
           end
         default: next_fwft_state    = invalid;
       endcase
     end
     end : gen_fwft_ns_ll
     // FSM : current state assignment
     always @ (posedge rd_clk) begin
       if (rd_rst_i)
          curr_fwft_state  <= invalid;
       else
          curr_fwft_state  <= next_fwft_state;
     end
 
     reg ram_regout_en;

     // FSM(output assignments) : clock enable generation for xpm_memory
     if (READ_MODE == 1) begin : gen_fwft_ro
     always @(curr_fwft_state or rd_en) begin
       case (curr_fwft_state)
         invalid:           ram_regout_en = 1'b0;
         stage1_valid:      ram_regout_en = 1'b1;
         stage2_valid:      ram_regout_en = 1'b0;
         both_stages_valid: ram_regout_en = rd_en;
         default:           ram_regout_en = 1'b0;
       endcase
     end
     end : gen_fwft_ro
     if (READ_MODE == 2) begin : gen_fwft_ro_ll
     always @(curr_fwft_state or rd_en or ram_empty_i or fe_of_empty) begin
       case (curr_fwft_state)
         invalid:           ram_regout_en = fe_of_empty;
         stage1_valid:      ram_regout_en = rd_en & !ram_empty_i;
         default:           ram_regout_en = 1'b0;
       endcase
     end
     end : gen_fwft_ro_ll

     // FSM(output assignments) : rd_en (enable) signal generation for xpm_memory
     if (READ_MODE == 1) begin : gen_fwft_re
     always @(curr_fwft_state or ram_empty_i or rd_en) begin
       case (curr_fwft_state)
         invalid :
           if (~ram_empty_i)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         stage1_valid :
           if (~ram_empty_i)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         stage2_valid :
           if (~ram_empty_i)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         both_stages_valid :
           if (~ram_empty_i && rd_en)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         default :
           rd_en_fwft = 1'b0;
       endcase
     end
     end : gen_fwft_re
     if (READ_MODE == 2) begin : gen_fwft_re_ll
     always @(curr_fwft_state or ram_empty_i or rd_en) begin
       case (curr_fwft_state)
         invalid :
           if (~ram_empty_i)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         stage1_valid :
           if (~ram_empty_i && rd_en)
             rd_en_fwft = 1'b1;
           else
             rd_en_fwft = 1'b0;
         default :
           rd_en_fwft = 1'b0;
       endcase
     end
     end : gen_fwft_re_ll
     // assingment to control regce xpm_memory
     assign ram_regce = ram_regout_en;

     reg going_empty_fwft;
     reg leaving_empty_fwft;

     if (READ_MODE == 1) begin : gen_fwft_ge
     always @(curr_fwft_state or rd_en) begin
       case (curr_fwft_state)
         stage2_valid : going_empty_fwft = rd_en;
         default      : going_empty_fwft = 1'b0;
       endcase
     end

     always @(curr_fwft_state or rd_en) begin
       case (curr_fwft_state)
         stage1_valid : leaving_empty_fwft = 1'b1;
         default      : leaving_empty_fwft = 1'b0;
       endcase
     end
     end : gen_fwft_ge
     if (READ_MODE == 2) begin : gen_fwft_ge_ll
     always @(curr_fwft_state or rd_en or ram_empty_i) begin
       case (curr_fwft_state)
         stage1_valid : going_empty_fwft = rd_en & ram_empty_i;
         default      : going_empty_fwft = 1'b0;
       endcase
     end

     always @ (posedge rd_clk) begin
       if (rd_rst_i) begin
          ram_empty_i_d1  <= 1'b1;
       end else begin
          ram_empty_i_d1  <= ram_empty_i;
       end
     end
     assign fe_of_empty = ram_empty_i_d1 & !ram_empty_i;

     always @(curr_fwft_state or fe_of_empty) begin
       case (curr_fwft_state)
         invalid      : leaving_empty_fwft = fe_of_empty;
         stage1_valid : leaving_empty_fwft = 1'b1;
         default      : leaving_empty_fwft = 1'b0;
       endcase
     end
     end : gen_fwft_ge_ll

     // fwft empty signal generation 
     always @ (posedge rd_clk) begin
       if (rd_rst_i) begin
         empty_fwft_i     <= 1'b1;
         empty_fwft_fb    <= 1'b1;
       end else begin
         empty_fwft_i     <= going_empty_fwft | (~ leaving_empty_fwft & empty_fwft_fb);
         empty_fwft_fb    <= going_empty_fwft | (~ leaving_empty_fwft & empty_fwft_fb);
       end
     end

     if (EN_AE == 1) begin : gae_fwft
       reg going_aempty_fwft;
       reg leaving_aempty_fwft;

       if (READ_MODE == 1) begin : gen_fwft_ae
         always @(curr_fwft_state or rd_en or ram_empty_i) begin
           case (curr_fwft_state)
             both_stages_valid : going_aempty_fwft = rd_en & ram_empty_i;
             default      : going_aempty_fwft = 1'b0;
           endcase
         end
       end : gen_fwft_ae
       if (READ_MODE == 2) begin : gen_fwft_ae_ll
         always @(curr_fwft_state or rd_en or ram_empty_i) begin
           case (curr_fwft_state)
             stage1_valid : going_aempty_fwft = !rd_en & ram_empty_i;
             default      : going_aempty_fwft = 1'b0;
           endcase
         end
       end : gen_fwft_ae_ll

       always @(curr_fwft_state or rd_en or ram_empty_i) begin
         case (curr_fwft_state)
           stage1_valid : leaving_aempty_fwft = ~ram_empty_i;
           stage2_valid : leaving_aempty_fwft = ~(rd_en | ram_empty_i);
           default      : leaving_aempty_fwft = 1'b0;
         endcase
       end

       always @ (posedge rd_clk) begin
         if (rd_rst_i) begin
           aempty_fwft_i    <= 1'b1;
         end else begin
           aempty_fwft_i    <= going_aempty_fwft | (~ leaving_aempty_fwft & aempty_fwft_i);
         end
       end
     end : gae_fwft

     if (EN_DVLD == 1) begin : gdvld_fwft
       always @ (posedge rd_clk) begin
         if (rd_rst_i) begin
           data_valid_fwft  <= 1'b0;
         end else begin
           data_valid_fwft  <= ~(going_empty_fwft | (~ leaving_empty_fwft & empty_fwft_fb));
         end
       end
     end : gdvld_fwft

    xpm_fifo_reg_bit #(0)
      empty_fwft_d1_inst (1'b0, rd_clk, leaving_empty_fwft, empty_fwft_d1);

    wire ge_fwft_d1;
    xpm_fifo_reg_bit #(0)
      ge_fwft_d1_inst (1'b0, rd_clk, going_empty_fwft, ge_fwft_d1);

    wire count_up  ;
    wire count_down;
    wire count_en  ;
    wire count_rst ;
    assign count_up   = (next_fwft_state == 2'b10 && ~|curr_fwft_state) | (curr_fwft_state == 2'b10 && &next_fwft_state) | (curr_fwft_state == 2'b01 && &next_fwft_state);
    assign count_down = (next_fwft_state == 2'b01 && &curr_fwft_state) | (curr_fwft_state == 2'b01 && ~|next_fwft_state);
    assign count_en   = count_up | count_down;
    assign count_rst  = (rd_rst_i | (~|curr_fwft_state & ~|next_fwft_state));

    xpm_counter_updn # (2, 0)
      rdpp1_inst (count_rst, rd_clk, count_en, count_up, count_down, extra_words_fwft);

 
  end : gen_fwft

  if (READ_MODE == 0) begin : ngen_fwft
    assign le_fwft_re       = 1'b0;
    assign le_fwft_fe       = 1'b0;
    assign extra_words_fwft = 2'h0;
  end : ngen_fwft

  // output data bus assignment
  if (FG_EQ_ASYM_DOUT == 0) begin : nfg_eq_asym_dout
    assign dout  = dout_i;
  end : nfg_eq_asym_dout

  // Overflow and Underflow flag generation
  if (EN_UF == 1) begin : guf
    always @ (posedge rd_clk) begin
      underflow_i <=  (rd_rst_i | empty_i) & rd_en;
    end
    assign underflow   = underflow_i;
  end : guf
  if (EN_UF == 0) begin : gnuf
    assign underflow   = 1'b0;
  end : gnuf

  if (EN_OF == 1) begin : gof
    always @ (posedge wr_clk) begin
     overflow_i  <=  (wrst_busy | rst_d1 | ram_full_i) & wr_en;
    end
    assign overflow    = overflow_i;
  end : gof
  if (EN_OF == 0) begin : gnof
    assign overflow    = 1'b0;
  end : gnof

  // -------------------------------------------------------------------------------------------------------------------
  // Write Data Count for Independent Clocks FIFO
  // -------------------------------------------------------------------------------------------------------------------
  if (EN_WDC == 1) begin : gwdc
    reg  [WR_DC_WIDTH_EXT-1:0] wr_data_count_i;
    wire [WR_DC_WIDTH_EXT-1:0] diff_wr_rd_pntr;
    assign diff_wr_rd_pntr = wr_pntr_ext-rd_pntr_wr_adj_dc;
    always @ (posedge wr_clk) begin
      if (wrst_busy)
         wr_data_count_i   <= {WR_DC_WIDTH_EXT{1'b0}};
      else
         wr_data_count_i  <= diff_wr_rd_pntr;
    end
    assign wr_data_count = wr_data_count_i[WR_DC_WIDTH_EXT-1:WR_DC_WIDTH_EXT-WR_DATA_COUNT_WIDTH];
  end : gwdc
  if (EN_WDC == 0) begin : gnwdc
    assign wr_data_count = {WR_DC_WIDTH_EXT{1'b0}};
  end : gnwdc

  // -------------------------------------------------------------------------------------------------------------------
  // Read Data Count for Independent Clocks FIFO
  // -------------------------------------------------------------------------------------------------------------------
  if (EN_RDC == 1) begin : grdc
    reg  [RD_DC_WIDTH_EXT-1:0] rd_data_count_i;
    wire [RD_DC_WIDTH_EXT-1:0] diff_wr_rd_pntr_rdc;
    assign diff_wr_rd_pntr_rdc = wr_pntr_rd_adj_dc-rd_pntr_ext+extra_words_fwft;
    always @ (posedge rd_clk) begin
      if (rd_rst_i | invalid_state)
         rd_data_count_i   <= {RD_DC_WIDTH_EXT{1'b0}};
      else
         rd_data_count_i  <= diff_wr_rd_pntr_rdc;
    end
    assign rd_data_count = rd_data_count_i[RD_DC_WIDTH_EXT-1:RD_DC_WIDTH_EXT-RD_DATA_COUNT_WIDTH];
  end : grdc
  if (EN_RDC == 0) begin : gnrdc
    assign rd_data_count = {RD_DC_WIDTH_EXT{1'b0}};
  end : gnrdc

  endgenerate

  // -------------------------------------------------------------------------------------------------------------------
  // Simulation constructs
  // -------------------------------------------------------------------------------------------------------------------
  // synthesis translate_off

 `ifndef DISABLE_XPM_ASSERTIONS  
  initial begin
  #1;
    if (SIM_ASSERT_CHK == 1)
    `ifdef OBSOLETE
      $warning("Vivado Simulator does not currently support the SystemVerilog Assertion syntax used within XPM_FIFO.  \
Messages related to potential misuse will not be reported.");
    `else
      $warning("SIM_ASSERT_CHK (%0d) specifies simulation message reporting, messages related to potential misuse \
will be reported.", SIM_ASSERT_CHK);
    `endif
  end

  `ifndef OBSOLETE
  if (SIM_ASSERT_CHK == 1) begin : rst_usage
    //Checks for valid conditions in which the src_send signal can toggle (based on src_rcv value)
    //Start new handshake after previous handshake completes.
    assume property (@(posedge wr_clk )
      (($past(rst) == 0) && (rst == 1)) |-> ##1 $rose(wrst_busy))
    else
      $error("[%s %s-%0d] New reset (rst transitioning to 1) at %0t shouldn't occur until the previous reset \
sequence completes (wrst_busy must be 0).  This reset is ignored.  Please refer to the \
XPM_FIFO documentation in the libraries guide.", "XPM_FIFO_RESET", "S", 1, $time);
  end : rst_usage

  if (SIM_ASSERT_CHK == 1 && FULL_RESET_VALUE == 1) begin : rst_full_usage
    assert property (@(posedge wr_clk )
      $rose(wrst_busy) |-> ##1 $rose(full))
    else 
      $error("[%s %s-%0d] FULL_RESET_VALUE is set to %0d. Full flag is not 1 or transitioning to 1 at %0t.", "FULL_RESET_VALUE", "S", 2, FULL_RESET_VALUE, $time);

    assert property (@(posedge wr_clk )
      $fell(wrst_busy) |-> ##1 $fell(full))
    else
      $error("[%s %s-%0d] After reset removal, full flag is not transitioning to 0 at %0t.", "FULL_CHECK", "S", 3, $time);

  end : rst_full_usage

  if (SIM_ASSERT_CHK == 1) begin : rst_empty_chk
    assert property (@(posedge rd_clk )
      ($rose(rd_rst_busy) || (empty && $rose(rd_rst_busy))) |-> ##1 $rose(empty))
    else 
      $error("[%s %s-%0d] Reset is applied, but empty flag is not 1 or transitioning to 1 at %0t.", "EMPTY_CHECK", "S", 4, $time);

  end : rst_empty_chk

  if (SIM_ASSERT_CHK == 1) begin : sleep_chk
    assert property (@(posedge wr_clk )
      ($fell(sleep) |->  !wr_en[*WAKEUP_TIME]))
    else 
      $error("[%s %s-%0d] 'sleep' is deasserted at %0t, but wr_en must be low for %0d wr_clk cycles after %0t", "SLEEP_CHECK", "S", 6, $time, WAKEUP_TIME, $time);

    assert property (@(posedge rd_clk )
      ($fell(sleep) |->  !rd_en[*WAKEUP_TIME]))
    else 
      $error("[%s %s-%0d] 'sleep' is deasserted at %0t, but rd_en must be low for %0d rd_clk cycles after %0t", "SLEEP_CHECK", "S", 7, $time, WAKEUP_TIME, $time);
  end : sleep_chk

  if (SIM_ASSERT_CHK == 1) begin : flag_chk

    assert property (@(posedge wr_clk ) (!overflow)) else $warning("[%s %s-%0d] Overflow detected at %0t", "OVERFLOW_CHECK", "S", 8, $time);

    assert property (@(posedge rd_clk ) (!underflow)) else $warning("[%s %s-%0d] Underflow detected at %0t", "UNDERFLOW_CHECK", "S", 9, $time);

  end : flag_chk

  `endif
  `endif

  // synthesis translate_on
endmodule : xpm_fifo_base

//********************************************************************************************************************

module xpm_fifo_rst # (
  parameter integer   COMMON_CLOCK     = 1,
  parameter integer   CDC_DEST_SYNC_FF = 2,
  parameter integer   SIM_ASSERT_CHK = 0

) (
  input  wire         rst,
  input  wire         wr_clk,
  input  wire         rd_clk,
  output wire         wr_rst,
  output wire         rd_rst,
  output wire         wr_rst_busy,
  output wire         rd_rst_busy
);
  reg  [1:0] power_on_rst  = 2'h3;
  wire rst_i;

  // -------------------------------------------------------------------------------------------------------------------
  // Reset Logic
  // -------------------------------------------------------------------------------------------------------------------
  //Keeping the power on reset to work even when the input reset(to xpm_fifo) is not applied or not using
   always @ (posedge wr_clk) begin
     power_on_rst <= {power_on_rst[0], 1'b0};
   end
   assign rst_i = power_on_rst[1] | rst;

  // Write and read reset generation for common clock FIFO
   if (COMMON_CLOCK == 1) begin : gen_rst_cc
    reg [2:0] fifo_wr_rst_cc = 3'b00;
    assign wr_rst        = fifo_wr_rst_cc[2];
    assign rd_rst        = fifo_wr_rst_cc[2];
    assign rd_rst_busy   = fifo_wr_rst_cc[2];
    assign wr_rst_busy   = fifo_wr_rst_cc[2];

  // synthesis translate_off
    `ifndef DISABLE_XPM_ASSERTIONS  
    if (SIM_ASSERT_CHK == 1) begin: assert_rst
      always @ (posedge wr_clk) begin
        assert (!$isunknown(rst)) else $warning ("Input port 'rst' has unknown value 'X' or 'Z' at %0t. This may cause the outputs of FIFO to be 'X' or 'Z' in simulation. Ensure 'rst' has a valid value ('0' or '1')",$time);
      end
    end : assert_rst
  `endif
  // synthesis translate_on

    always @ (posedge wr_clk) begin
      if (rst_i) begin
        fifo_wr_rst_cc    <= 3'h7;
      end else begin
  	fifo_wr_rst_cc   <= {fifo_wr_rst_cc[1:0],1'b0};
      end
    end
  end : gen_rst_cc

  // Write and read reset generation for independent clock FIFO
  if (COMMON_CLOCK == 0) begin : gen_rst_ic
    wire fifo_wr_rst_rd;
    wire fifo_rd_rst_wr_i;
    reg  fifo_wr_rst_i       = 1'b0;
    reg  wr_rst_busy_i       = 1'b0;
    reg  fifo_rd_rst_i       = 1'b0;
    reg  fifo_rd_rst_ic      = 1'b0;
    reg  fifo_wr_rst_ic      = 1'b0;
    reg  wr_rst_busy_ic      = 1'b0;
    reg  rst_seq_reentered   = 1'b0;

    assign wr_rst          = fifo_wr_rst_ic | wr_rst_busy_ic;
    assign rd_rst          = fifo_rd_rst_ic;
    assign rd_rst_busy     = fifo_rd_rst_ic;
    assign wr_rst_busy     = wr_rst_busy_ic;

    (* fsm_safe_state = "default_state" *) enum logic [2:0] {WRST_IDLE    = 3'b000,
                      WRST_IN      = 3'b010,
                      WRST_OUT     = 3'b111,
                      WRST_EXIT    = 3'b110,
                      WRST_GO2IDLE = 3'b100} curr_wrst_state = WRST_IDLE, next_wrst_state = WRST_IDLE;

    (* fsm_safe_state = "default_state" *) enum logic [1:0] {RRST_IDLE = 2'b00,
                      RRST_IN   = 2'b10,
                      RRST_OUT  = 2'b11,
                      RRST_EXIT = 2'b01} curr_rrst_state = RRST_IDLE, next_rrst_state = RRST_IDLE;

   // synthesis translate_off
    `ifndef DISABLE_XPM_ASSERTIONS   
   if (SIM_ASSERT_CHK == 1) begin: assert_rst
     always @ (posedge wr_clk) begin
       assert (!$isunknown(rst)) else $warning ("Input port 'rst' has unknown value 'X' or 'Z' at %0t. This may cause the outputs of FIFO to be 'X' or 'Z' in simulation. Ensure 'rst' has a valid value ('0' or '1')",$time);
      end
   end : assert_rst
  `endif

   // synthesis translate_on

   always @ (posedge wr_clk) begin
     if (rst_i) begin
       rst_seq_reentered  <= 1'b0;
     end else begin
       if (curr_wrst_state == WRST_GO2IDLE) begin
	 rst_seq_reentered  <= 1'b1;
       end
     end
   end

   always @* begin
      case (curr_wrst_state)
         WRST_IDLE: begin
            if (rst_i)
               next_wrst_state     <= WRST_IN;
            else
               next_wrst_state     <= WRST_IDLE;
            end
         WRST_IN: begin
            if (rst_i)
               next_wrst_state     <= WRST_IN;
            else if (fifo_rd_rst_wr_i)
               next_wrst_state     <= WRST_OUT;
            else
               next_wrst_state     <= WRST_IN;
            end
         WRST_OUT: begin
            if (rst_i)
               next_wrst_state     <= WRST_IN;
            else if (~fifo_rd_rst_wr_i)
               next_wrst_state     <= WRST_EXIT;
            else
               next_wrst_state     <= WRST_OUT;
            end
         WRST_EXIT: begin
            if (rst_i)
               next_wrst_state     <= WRST_IN;
            else if (~rst & ~rst_seq_reentered)
               next_wrst_state     <= WRST_GO2IDLE;
            else if (rst_seq_reentered)
               next_wrst_state     <= WRST_IDLE;
            else
               next_wrst_state     <= WRST_EXIT;
            end
         WRST_GO2IDLE: begin
	      next_wrst_state     <= WRST_IN;
            end
         default: next_wrst_state  <= WRST_IDLE;
      endcase
   end

   always @ (posedge wr_clk) begin
     curr_wrst_state     <= next_wrst_state;
     fifo_wr_rst_ic      <= fifo_wr_rst_i;
     wr_rst_busy_ic      <= wr_rst_busy_i;
   end

   always @* begin
      case (curr_wrst_state)
         WRST_IDLE     : fifo_wr_rst_i = rst_i;
         WRST_IN       : fifo_wr_rst_i = 1'b1;
         WRST_OUT      : fifo_wr_rst_i = 1'b0;
         WRST_EXIT     : fifo_wr_rst_i = 1'b0;
         WRST_GO2IDLE  : fifo_wr_rst_i = 1'b1;
         default:   fifo_wr_rst_i = fifo_wr_rst_ic;
      endcase
   end

   always @* begin
      case (curr_wrst_state)
         WRST_IDLE: wr_rst_busy_i = rst_i;
         WRST_IN  : wr_rst_busy_i = 1'b1;
         WRST_OUT : wr_rst_busy_i = 1'b1;
         WRST_EXIT: wr_rst_busy_i = 1'b1;
         default:   wr_rst_busy_i = wr_rst_busy_ic;
      endcase
   end

    always @* begin
      case (curr_rrst_state)
         RRST_IDLE: begin
            if (fifo_wr_rst_rd)
               next_rrst_state      <= RRST_IN;
            else
               next_rrst_state      <= RRST_IDLE;
            end
         RRST_IN  : next_rrst_state <= RRST_OUT;
         RRST_OUT : begin
            if (~fifo_wr_rst_rd)
               next_rrst_state      <= RRST_EXIT;
            else
               next_rrst_state      <= RRST_OUT;
            end
         RRST_EXIT: next_rrst_state <= RRST_IDLE;
         default: next_rrst_state   <= RRST_IDLE;
      endcase
   end

   always @ (posedge rd_clk) begin
     curr_rrst_state  <= next_rrst_state;
     fifo_rd_rst_ic   <= fifo_rd_rst_i;
   end

   always @* begin
      case (curr_rrst_state)
         RRST_IDLE: fifo_rd_rst_i <= fifo_wr_rst_rd;
         RRST_IN  : fifo_rd_rst_i <= 1'b1;
         RRST_OUT : fifo_rd_rst_i <= 1'b1;
         RRST_EXIT: fifo_rd_rst_i <= 1'b0;
         default:   fifo_rd_rst_i <= 1'b0;
      endcase
   end

    // Synchronize the wr_rst (fifo_wr_rst_ic) in read clock domain
    xpm_cdc_sync_rst #(
      .DEST_SYNC_FF      (CDC_DEST_SYNC_FF),
      .INIT              (0),
      .INIT_SYNC_FF      (1),
      .SIM_ASSERT_CHK    (0),
      .VERSION           (0))
      wrst_rd_inst (
        .src_rst         (fifo_wr_rst_ic),
        .dest_clk        (rd_clk),
        .dest_rst        (fifo_wr_rst_rd));

    // Synchronize the rd_rst (fifo_rd_rst_ic) in write clock domain
    xpm_cdc_sync_rst #(
      .DEST_SYNC_FF      (CDC_DEST_SYNC_FF),
      .INIT              (0),
      .INIT_SYNC_FF      (1),
      .SIM_ASSERT_CHK    (0),
      .VERSION           (0))
      rrst_wr_inst (
        .src_rst         (fifo_rd_rst_ic),
        .dest_clk        (wr_clk),
        .dest_rst        (fifo_rd_rst_wr_i));
  end : gen_rst_ic
endmodule : xpm_fifo_rst
      

//********************************************************************************************************************

//********************************************************************************************************************
// -------------------------------------------------------------------------------------------------------------------
// Up-Down Counter
// -------------------------------------------------------------------------------------------------------------------
//********************************************************************************************************************

module xpm_counter_updn # (
  parameter integer               COUNTER_WIDTH        = 4,
  parameter integer               RESET_VALUE          = 0

) (
  input  wire                     rst,
  input  wire                     clk,
  input  wire                     cnt_en,
  input  wire                     cnt_up,
  input  wire                     cnt_down,
  output wire [COUNTER_WIDTH-1:0] count_value
);
  reg [COUNTER_WIDTH-1:0]          count_value_i = RESET_VALUE;
  assign count_value = count_value_i;
  always @ (posedge clk) begin
    if (rst) begin
      count_value_i  <= RESET_VALUE;
    end else if (cnt_en) begin
      count_value_i  <= count_value_i + cnt_up - cnt_down;
    end
  end
endmodule : xpm_counter_updn

//********************************************************************************************************************
//********************************************************************************************************************

module xpm_fifo_reg_vec # (
  parameter integer           REG_WIDTH        = 4

) (
  input  wire                 rst,
  input  wire                 clk,
  input  wire [REG_WIDTH-1:0] reg_in,
  output wire  [REG_WIDTH-1:0] reg_out
);
  reg [REG_WIDTH-1:0] reg_out_i = {REG_WIDTH{1'b0}};
  always @ (posedge clk) begin
    if (rst)
      reg_out_i  <= {REG_WIDTH{1'b0}};
    else
      reg_out_i  <= reg_in;
  end
  assign reg_out = reg_out_i;
endmodule : xpm_fifo_reg_vec

//********************************************************************************************************************
//********************************************************************************************************************

module xpm_fifo_reg_bit # (
  parameter integer           RST_VALUE        = 0

) (
  input  wire  rst,
  input  wire  clk,
  input  wire  d_in,
  output reg   d_out = RST_VALUE
);
  always @ (posedge clk) begin
    if (rst)
      d_out  <= RST_VALUE;
    else
      d_out  <= d_in;
  end
endmodule : xpm_fifo_reg_bit
//********************************************************************************************************************
//********************************************************************************************************************

module xpm_reg_pipe_bit # (
  parameter integer           PIPE_STAGES      = 1,
  parameter integer           RST_VALUE        = 0

) (
  input  wire  rst,
  input  wire  clk,
  input  wire  pipe_in,
  output wire  pipe_out
);
  wire pipe_stage_ff [PIPE_STAGES:0];

  assign pipe_stage_ff[0] = pipe_in;

    for (genvar pipestage = 0; pipestage < PIPE_STAGES ;pipestage = pipestage + 1) begin : gen_pipe_bit
      xpm_fifo_reg_bit #(RST_VALUE)
        pipe_bit_inst (rst, clk, pipe_stage_ff[pipestage], pipe_stage_ff[pipestage+1]);
    end : gen_pipe_bit

  assign pipe_out = pipe_stage_ff[PIPE_STAGES];
endmodule : xpm_reg_pipe_bit
//********************************************************************************************************************
//********************************************************************************************************************


(* XPM_MODULE = "TRUE",  KEEP_HIERARCHY = "SOFT" *)
module xpm_fifo_sync # (

  // Common module parameters
  parameter                         FIFO_MEMORY_TYPE     = "auto",
  parameter                         ECC_MODE             = "no_ecc",
  parameter integer                 SIM_ASSERT_CHK       = 0,
  parameter integer                 CASCADE_HEIGHT       = 0,

  parameter integer                 FIFO_WRITE_DEPTH     = 2048,
  parameter integer                 WRITE_DATA_WIDTH     = 32,
  parameter integer                 WR_DATA_COUNT_WIDTH  = 1,
  parameter integer                 PROG_FULL_THRESH     = 10,
  parameter integer                 FULL_RESET_VALUE     = 0,
  parameter                         USE_ADV_FEATURES     = "0707",

  parameter                         READ_MODE            = "std",
  parameter integer                 FIFO_READ_LATENCY    = 1,
  parameter integer                 READ_DATA_WIDTH      = WRITE_DATA_WIDTH,
  parameter integer                 RD_DATA_COUNT_WIDTH  = 1,
  parameter integer                 PROG_EMPTY_THRESH    = 10,
  parameter                         DOUT_RESET_VALUE     = "0",

  parameter                         WAKEUP_TIME          = 0

) (

  // Common module ports
  input  wire                                  sleep,
  input  wire                                  rst,

  // Write Domain ports
  input  wire                                  wr_clk,
  input  wire                                  wr_en,
  input  wire [WRITE_DATA_WIDTH-1:0]           din,
  output wire                                  full,
  output wire                                  prog_full,
  output wire [WR_DATA_COUNT_WIDTH-1:0]        wr_data_count,
  output wire                                  overflow,
  output wire                                  wr_rst_busy,
  output wire                                  almost_full,
  output wire                                  wr_ack,

  // Read Domain ports
  input  wire                                  rd_en,
  output wire [READ_DATA_WIDTH-1:0]            dout,
  output wire                                  empty,
  output wire                                  prog_empty,
  output wire [RD_DATA_COUNT_WIDTH-1:0]        rd_data_count,
  output wire                                  underflow,
  output wire                                  rd_rst_busy,
  output wire                                  almost_empty,
  output wire                                  data_valid,

  // ECC Related ports
  input  wire                                  injectsbiterr,
  input  wire                                  injectdbiterr,
  output wire                                  sbiterr,
  output wire                                  dbiterr
);
  // Function to convert ASCII value to binary 
  function [3:0] str2bin;
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
            str2bin = str_val_ascii[3:0];
         else begin
           str2bin [3] = 1'b1;
           str2bin [2] = str_val_ascii[2] | (str_val_ascii[1] & str_val_ascii[0]);
           str2bin [1] = str_val_ascii[0] ^ str_val_ascii[1];
           str2bin [0] = !str_val_ascii[0];
         end
      end
      else
        $error("Found Invalid character while parsing the string, please cross check the value specified for either READ_RESET_VALUE_A|B or MEMORY_INIT_PARAM (if initialization of memory through parameter is used). XPM_MEMORY supports strings (hex) that contains characters 0-9, A-F and a-f.");
  endfunction
  // Function that parses the complete reset value string
  function logic [15:0] hstr2bin;
    input [16*8-1 : 0] hstr_val;
    integer rst_loop_a;
    localparam integer  rsta_loop_iter  =  16;
    logic [rsta_loop_iter-1 : 0] rst_val_conv_a_i;
    for (rst_loop_a=1; rst_loop_a <= rsta_loop_iter/4; rst_loop_a = rst_loop_a+1) begin
      rst_val_conv_a_i[(rst_loop_a*4)-1 -: 4] =  str2bin(hstr_val[(rst_loop_a*8)-1 -: 8]);
    end
    return rst_val_conv_a_i[15:0];
  endfunction

  localparam [15:0] EN_ADV_FEATURE_SYNC = hstr2bin(USE_ADV_FEATURES);

  // Define local parameters for mapping with base file
  localparam integer P_FIFO_MEMORY_TYPE      = ( (FIFO_MEMORY_TYPE == "lutram"   || FIFO_MEMORY_TYPE == "LUTRAM"   || FIFO_MEMORY_TYPE == "distributed"   || FIFO_MEMORY_TYPE == "DISTRIBUTED"  ) ? 1 :
                                               ( (FIFO_MEMORY_TYPE == "bram" || FIFO_MEMORY_TYPE == "BRAM" || FIFO_MEMORY_TYPE == "block" || FIFO_MEMORY_TYPE == "BLOCK") ? 2 :
                                               ( (FIFO_MEMORY_TYPE == "uram" || FIFO_MEMORY_TYPE == "URAM" || FIFO_MEMORY_TYPE == "ultra" || FIFO_MEMORY_TYPE == "ULTRA") ? 3 :
                                               ( (FIFO_MEMORY_TYPE == "builtin"  || FIFO_MEMORY_TYPE == "BUILTIN" ) ? 4 : 0))));
  
  localparam integer P_COMMON_CLOCK          = 1;

  localparam integer P_ECC_MODE              = ( (ECC_MODE  == "no_ecc" || ECC_MODE  == "NO_ECC" ) ? 0 : 1);

  localparam integer P_READ_MODE             = ( (READ_MODE == "std"  || READ_MODE == "STD" ) ? 0 :
                                               ( (READ_MODE == "fwft" || READ_MODE == "FWFT") ? 1 :
                                               ( (READ_MODE == "low_latency_fwft" || READ_MODE == "Low_Latency_FWFT") ? 2 : 3)));


  localparam integer P_WAKEUP_TIME           = ( (WAKEUP_TIME == "disable_sleep"    || WAKEUP_TIME == "DISABLE_SLEEP"   ) ? 0 : 2);
  
  initial begin : config_drc_sync
    reg drc_err_flag_sync;
    drc_err_flag_sync = 0;
    #1;
    if (EN_ADV_FEATURE_SYNC[13] != 1'b0) begin
      $error("[%s %0d-%0d] USE_ADV_FEATURES[13] = %0b. This is a reserved field and must be set to 0. %m", "XPM_FIFO_SYNC", 1, 1, EN_ADV_FEATURE_SYNC[13]);
      drc_err_flag_sync = 1;
    end
  
    if (drc_err_flag_sync == 1)
      #1 $finish;
  end : config_drc_sync

  // -------------------------------------------------------------------------------------------------------------------
  // Generate the instantiation of the appropriate XPM module
  // -------------------------------------------------------------------------------------------------------------------
      assign rd_rst_busy = wr_rst_busy;
      xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK      ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE  ),
        .ECC_MODE                   (P_ECC_MODE          ),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT       ),
        .FIFO_WRITE_DEPTH           (FIFO_WRITE_DEPTH    ),
        .WRITE_DATA_WIDTH           (WRITE_DATA_WIDTH    ),
        .WR_DATA_COUNT_WIDTH        (WR_DATA_COUNT_WIDTH ),
        .PROG_FULL_THRESH           (PROG_FULL_THRESH    ),
        .FULL_RESET_VALUE           (FULL_RESET_VALUE    ),
        .USE_ADV_FEATURES           (USE_ADV_FEATURES    ),
        .READ_MODE                  (P_READ_MODE         ),
        .FIFO_READ_LATENCY          (FIFO_READ_LATENCY   ),
        .READ_DATA_WIDTH            (READ_DATA_WIDTH     ),
        .RD_DATA_COUNT_WIDTH        (RD_DATA_COUNT_WIDTH ),
        .PROG_EMPTY_THRESH          (PROG_EMPTY_THRESH   ),
        .DOUT_RESET_VALUE           (DOUT_RESET_VALUE    ),
        .CDC_DEST_SYNC_FF           (2                   ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (WAKEUP_TIME         ),
        .VERSION                    (0                   )

      ) xpm_fifo_base_inst (
        .sleep            (sleep),
        .rst              (rst),
        .wr_clk           (wr_clk),
        .wr_en            (wr_en),
        .din              (din),
        .full             (full),
        .full_n           (),
        .prog_full        (prog_full),
        .wr_data_count    (wr_data_count),
        .overflow         (overflow),
        .wr_rst_busy      (wr_rst_busy),
        .almost_full      (almost_full),
        .wr_ack           (wr_ack),
        .rd_clk           (wr_clk),
        .rd_en            (rd_en),
        .dout             (dout),
        .empty            (empty),
        .prog_empty       (prog_empty),
        .rd_data_count    (rd_data_count),
        .underflow        (underflow),
        .rd_rst_busy      (),
        .almost_empty     (almost_empty),
        .data_valid       (data_valid),
        .injectsbiterr    (injectsbiterr),
        .injectdbiterr    (injectdbiterr),
        .sbiterr          (sbiterr),
        .dbiterr          (dbiterr)
      );

endmodule : xpm_fifo_sync

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************


(* XPM_MODULE = "TRUE",  DONT_TOUCH = "TRUE" *)
module xpm_fifo_async # (

  // Common module parameters
  parameter                         FIFO_MEMORY_TYPE     = "auto",
  parameter                         ECC_MODE             = "no_ecc",
  parameter integer                 RELATED_CLOCKS       = 0,
  parameter integer                 SIM_ASSERT_CHK       = 0,
  parameter integer                 CASCADE_HEIGHT       = 0,

  parameter integer                 FIFO_WRITE_DEPTH     = 2048,
  parameter integer                 WRITE_DATA_WIDTH     = 32,
  parameter integer                 WR_DATA_COUNT_WIDTH  = 1,
  parameter integer                 PROG_FULL_THRESH     = 10,
  parameter integer                 FULL_RESET_VALUE     = 0,
  parameter                         USE_ADV_FEATURES     = "0707",

  parameter                         READ_MODE            = "std",
  parameter integer                 FIFO_READ_LATENCY    = 1,
  parameter integer                 READ_DATA_WIDTH      = WRITE_DATA_WIDTH,
  parameter integer                 RD_DATA_COUNT_WIDTH  = 1,
  parameter integer                 PROG_EMPTY_THRESH    = 10,
  parameter                         DOUT_RESET_VALUE     = "0",
  parameter integer                 CDC_SYNC_STAGES      = 2,

  parameter                         WAKEUP_TIME          = 0
) (

  // Common module ports
  input  wire                                         sleep,
  input  wire                                         rst,

  // Write Domain ports
  input  wire                                         wr_clk,
  input  wire                                         wr_en,
  input  wire [WRITE_DATA_WIDTH-1:0]                  din,
  output wire                                         full,
  output wire                                         prog_full,
  output wire [WR_DATA_COUNT_WIDTH-1:0]               wr_data_count,
  output wire                                         overflow,
  output wire                                         wr_rst_busy,
  output wire                                         almost_full,
  output wire                                         wr_ack,

  // Read Domain ports
  input  wire                                         rd_clk,
  input  wire                                         rd_en,
  output wire [READ_DATA_WIDTH-1:0]                   dout,
  output wire                                         empty,
  output wire                                         prog_empty,
  output wire [RD_DATA_COUNT_WIDTH-1:0]               rd_data_count,
  output wire                                         underflow,
  output wire                                         rd_rst_busy,
  output wire                                         almost_empty,
  output wire                                         data_valid,

  // ECC Related ports
  input  wire                                         injectsbiterr,
  input  wire                                         injectdbiterr,
  output wire                                         sbiterr,
  output wire                                         dbiterr
);
  // Function to convert ASCII value to binary 
  function [3:0] str2bin;
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
            str2bin = str_val_ascii[3:0];
         else begin
           str2bin [3] = 1'b1;
           str2bin [2] = str_val_ascii[2] | (str_val_ascii[1] & str_val_ascii[0]);
           str2bin [1] = str_val_ascii[0] ^ str_val_ascii[1];
           str2bin [0] = !str_val_ascii[0];
         end
      end
      else
        $error("Found Invalid character while parsing the string, please cross check the value specified for either READ_RESET_VALUE_A|B or MEMORY_INIT_PARAM (if initialization of memory through parameter is used). XPM_MEMORY supports strings (hex) that contains characters 0-9, A-F and a-f.");
  endfunction
  // Function that parses the complete reset value string
  function logic [15:0] hstr2bin;
    input [16*8-1 : 0] hstr_val;
    integer rst_loop_a;
    localparam integer  rsta_loop_iter  =  16;
    logic [rsta_loop_iter-1 : 0] rst_val_conv_a_i;
    for (rst_loop_a=1; rst_loop_a <= rsta_loop_iter/4; rst_loop_a = rst_loop_a+1) begin
      rst_val_conv_a_i[(rst_loop_a*4)-1 -: 4] =  str2bin(hstr_val[(rst_loop_a*8)-1 -: 8]);
    end
    return rst_val_conv_a_i[15:0];
  endfunction

  localparam [15:0] EN_ADV_FEATURE_ASYNC = hstr2bin(USE_ADV_FEATURES);

  // Define local parameters for mapping with base file
  localparam integer P_FIFO_MEMORY_TYPE      = ( (FIFO_MEMORY_TYPE == "lutram"   || FIFO_MEMORY_TYPE == "LUTRAM"   || FIFO_MEMORY_TYPE == "distributed"   || FIFO_MEMORY_TYPE == "DISTRIBUTED"  ) ? 1 :
                                               ( (FIFO_MEMORY_TYPE == "bram" || FIFO_MEMORY_TYPE == "BRAM" || FIFO_MEMORY_TYPE == "block" || FIFO_MEMORY_TYPE == "BLOCK") ? 2 :
                                               ( (FIFO_MEMORY_TYPE == "uram" || FIFO_MEMORY_TYPE == "URAM" || FIFO_MEMORY_TYPE == "ultra" || FIFO_MEMORY_TYPE == "ULTRA") ? 3 :
                                               ( (FIFO_MEMORY_TYPE == "builtin"  || FIFO_MEMORY_TYPE == "BUILTIN" ) ? 4 : 0))));
  
  localparam integer P_COMMON_CLOCK          = 0;

  localparam integer P_ECC_MODE              = ( (ECC_MODE  == "no_ecc" || ECC_MODE  == "NO_ECC" ) ? 0 : 1);

  localparam integer P_READ_MODE             = ( (READ_MODE == "std"  || READ_MODE == "STD" ) ? 0 :
                                               ( (READ_MODE == "fwft" || READ_MODE == "FWFT") ? 1 :
                                               ( (READ_MODE == "low_latency_fwft" || READ_MODE == "Low_Latency_FWFT") ? 2 : 3)));

  localparam integer P_WAKEUP_TIME           = ( (WAKEUP_TIME == "disable_sleep"    || WAKEUP_TIME == "DISABLE_SLEEP"   ) ? 0 : 2);
  
  initial begin : config_drc_async
    reg drc_err_flag_async;
    drc_err_flag_async = 0;
    #1;
    if (EN_ADV_FEATURE_ASYNC[13] != 1'b0) begin
      $error("[%s %0d-%0d] USE_ADV_FEATURES[13] = %0b. This is a reserved field and must be set to 0. %m", "XPM_FIFO_ASYNC", 1, 1, EN_ADV_FEATURE_ASYNC[13]);
      drc_err_flag_async = 1;
    end
  
    if (drc_err_flag_async == 1)
      #1 $finish;
  end : config_drc_async

  // -------------------------------------------------------------------------------------------------------------------
  // Generate the instantiation of the appropriate XPM module
  // -------------------------------------------------------------------------------------------------------------------
      generate if (P_FIFO_MEMORY_TYPE != 3) begin : gnuram_async_fifo
        xpm_fifo_base # (
          .COMMON_CLOCK               (P_COMMON_CLOCK      ),
          .RELATED_CLOCKS             (RELATED_CLOCKS      ),
          .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE  ),
          .ECC_MODE                   (P_ECC_MODE          ),
          .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
          .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
          .FIFO_WRITE_DEPTH           (FIFO_WRITE_DEPTH    ),
          .WRITE_DATA_WIDTH           (WRITE_DATA_WIDTH    ),
          .WR_DATA_COUNT_WIDTH        (WR_DATA_COUNT_WIDTH ),
          .PROG_FULL_THRESH           (PROG_FULL_THRESH    ),
          .FULL_RESET_VALUE           (FULL_RESET_VALUE    ),
          .USE_ADV_FEATURES           (USE_ADV_FEATURES    ),
          .READ_MODE                  (P_READ_MODE         ),
          .FIFO_READ_LATENCY          (FIFO_READ_LATENCY   ),
          .READ_DATA_WIDTH            (READ_DATA_WIDTH     ),
          .RD_DATA_COUNT_WIDTH        (RD_DATA_COUNT_WIDTH ),
          .PROG_EMPTY_THRESH          (PROG_EMPTY_THRESH   ),
          .DOUT_RESET_VALUE           (DOUT_RESET_VALUE    ),
          .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
          .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
          .WAKEUP_TIME                (WAKEUP_TIME         ),
          .VERSION                    (0                   )
        
        ) xpm_fifo_base_inst (
          .sleep            (sleep),
          .rst              (rst),
          .wr_clk           (wr_clk),
          .wr_en            (wr_en),
          .din              (din),
          .full             (full),
          .full_n           (),
          .prog_full        (prog_full),
          .wr_data_count    (wr_data_count),
          .overflow         (overflow),
          .wr_rst_busy      (wr_rst_busy),
          .almost_full      (almost_full),
          .wr_ack           (wr_ack),
          .rd_clk           (rd_clk),
          .rd_en            (rd_en),
          .dout             (dout),
          .empty            (empty),
          .prog_empty       (prog_empty),
          .rd_data_count    (rd_data_count),
          .underflow        (underflow),
          .rd_rst_busy      (rd_rst_busy),
          .almost_empty     (almost_empty),
          .data_valid       (data_valid),
          .injectsbiterr    (injectsbiterr),
          .injectdbiterr    (injectdbiterr),
          .sbiterr          (sbiterr),
          .dbiterr          (dbiterr)
        );
      end endgenerate // gnuram_async_fifo
endmodule : xpm_fifo_async

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************


(* XPM_MODULE = "TRUE", DONT_TOUCH = "TRUE"  *)
module xpm_fifo_axis # (

  // Common module parameters
  parameter                         CLOCKING_MODE        = "common_clock",
  parameter                         FIFO_MEMORY_TYPE     = "auto",
  parameter                         PACKET_FIFO          = "false",
  parameter integer                 FIFO_DEPTH           = 2048,
  parameter integer                 TDATA_WIDTH          = 32,
  parameter integer                 TID_WIDTH            = 1,
  parameter integer                 TDEST_WIDTH          = 1,
  parameter integer                 TUSER_WIDTH          = 1,
  parameter integer                 SIM_ASSERT_CHK       = 0,
  parameter integer                 CASCADE_HEIGHT       = 0,

  parameter                         ECC_MODE             = "no_ecc",
  parameter integer                 RELATED_CLOCKS       = 0,
  parameter                         USE_ADV_FEATURES     = "1000",
  parameter integer                 WR_DATA_COUNT_WIDTH  = 1,
  parameter integer                 RD_DATA_COUNT_WIDTH  = 1,
  parameter integer                 PROG_FULL_THRESH     = 10,
  parameter integer                 PROG_EMPTY_THRESH    = 10,
  parameter integer                 CDC_SYNC_STAGES      = 2


) (

  // Common module ports
  input  wire                           s_aresetn,
  input  wire                           s_aclk,
  input  wire                           m_aclk,
    
  // AXI Streaming Slave Signals (Write side)
  input  wire                           s_axis_tvalid,
  output wire                           s_axis_tready,
  input  wire [TDATA_WIDTH-1:0]         s_axis_tdata,
  input  wire [TDATA_WIDTH/8-1:0]       s_axis_tstrb,
  input  wire [TDATA_WIDTH/8-1:0]       s_axis_tkeep,
  input  wire                           s_axis_tlast,
  input  wire [TID_WIDTH-1:0]           s_axis_tid,
  input  wire [TDEST_WIDTH-1:0]         s_axis_tdest,
  input  wire [TUSER_WIDTH-1:0]         s_axis_tuser,
  
  // AXI Streaming Master Signals (Read side)
  output wire                           m_axis_tvalid,
  input  wire                           m_axis_tready,
  output wire [TDATA_WIDTH-1:0]         m_axis_tdata,
  output wire [TDATA_WIDTH/8-1:0]       m_axis_tstrb,
  output wire [TDATA_WIDTH/8-1:0]       m_axis_tkeep,
  output wire                           m_axis_tlast,
  output wire [TID_WIDTH-1:0]           m_axis_tid,
  output wire [TDEST_WIDTH-1:0]         m_axis_tdest,
  output wire [TUSER_WIDTH-1:0]         m_axis_tuser,
  
  // AXI Streaming Sideband Signals
  output wire                           prog_full_axis,
  output wire [WR_DATA_COUNT_WIDTH-1:0] wr_data_count_axis,
  output wire                           almost_full_axis,
  output wire                           prog_empty_axis,
  output wire [RD_DATA_COUNT_WIDTH-1:0] rd_data_count_axis,
  output wire                           almost_empty_axis,

  // ECC Related ports
  input  wire                           injectsbiterr_axis,
  input  wire                           injectdbiterr_axis,
  output wire                           sbiterr_axis,
  output wire                           dbiterr_axis
);

  function integer clog2;
    input integer value;
  begin 
    value = value-1;
    for (clog2=0; value>0; clog2=clog2+1)
      value = value>>1;
    end 
  endfunction
  // Function to convert ASCII value to binary 
  function [3:0] str2bin;
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
            str2bin = str_val_ascii[3:0];
         else begin
           str2bin [3] = 1'b1;
           str2bin [2] = str_val_ascii[2] | (str_val_ascii[1] & str_val_ascii[0]);
           str2bin [1] = str_val_ascii[0] ^ str_val_ascii[1];
           str2bin [0] = !str_val_ascii[0];
         end
      end
      else
        $error("Found Invalid character while parsing the string, please cross check the value specified for either READ_RESET_VALUE_A|B or MEMORY_INIT_PARAM (if initialization of memory through parameter is used). XPM_MEMORY supports strings (hex) that contains characters 0-9, A-F and a-f.");
  endfunction
  // Function that parses the complete reset value string
  function logic [15:0] hstr2bin;
    input [16*8-1 : 0] hstr_val;
    integer rst_loop_a;
    localparam integer  rsta_loop_iter  =  16;
    logic [rsta_loop_iter-1 : 0] rst_val_conv_a_i;
    for (rst_loop_a=1; rst_loop_a <= rsta_loop_iter/4; rst_loop_a = rst_loop_a+1) begin
      rst_val_conv_a_i[(rst_loop_a*4)-1 -: 4] =  str2bin(hstr_val[(rst_loop_a*8)-1 -: 8]);
    end
    return rst_val_conv_a_i[15:0];
  endfunction

//Function to convert binary to ASCII value
  function [7:0] bin2str;
    input [3:0] bin_val;
      if( bin_val > 4'h9) begin
           bin2str [7:4] = 4'h4;
           bin2str [3]   = 1'b0;
           bin2str [2:0] = bin_val[2:0]-1'b1;
           end
         else begin
           bin2str [7:4] = 4'h3;
           bin2str [3:0] = bin_val;
         end
  endfunction

  // Function that parses the complete binary value to string
  function [31:0] bin2hstr;
    input [15 : 0] bin_val;
    integer str_pos;
    localparam integer  str_max_bits  =  32;
    for (str_pos=1; str_pos <= str_max_bits/8; str_pos = str_pos+1) begin
      bin2hstr[(str_pos*8)-1 -: 8] =  bin2str(bin_val[(str_pos*4)-1 -: 4]);
    end
  endfunction


  localparam [15:0] EN_ADV_FEATURE_AXIS = hstr2bin(USE_ADV_FEATURES);
  localparam        EN_ALMOST_FULL_INT  = (PACKET_FIFO == "true") ? 1'b1 : EN_ADV_FEATURE_AXIS[3]; 
  localparam        EN_ALMOST_EMPTY_INT = (PACKET_FIFO == "true") ? 1'b1 : EN_ADV_FEATURE_AXIS[11]; 
  localparam        EN_DATA_VALID_INT   = 1'b1;
  localparam [15:0] EN_ADV_FEATURE_AXIS_INT = {EN_ADV_FEATURE_AXIS[15:13], EN_DATA_VALID_INT, EN_ALMOST_EMPTY_INT, EN_ADV_FEATURE_AXIS[10:4], EN_ALMOST_FULL_INT, EN_ADV_FEATURE_AXIS[2:0]};
  localparam        USE_ADV_FEATURES_INT = bin2hstr(EN_ADV_FEATURE_AXIS_INT);


  localparam PKT_SIZE_LT8      = EN_ADV_FEATURE_AXIS[13];

  localparam LOG_DEPTH_AXIS    = clog2(FIFO_DEPTH);
  localparam TDATA_OFFSET      = TDATA_WIDTH;
  localparam TSTRB_OFFSET      = TDATA_OFFSET+(TDATA_WIDTH/8);
  localparam TKEEP_OFFSET      = TSTRB_OFFSET+(TDATA_WIDTH/8);
  localparam TID_OFFSET        = TID_WIDTH > 0 ? TKEEP_OFFSET+TID_WIDTH : TKEEP_OFFSET;
  localparam TDEST_OFFSET      = TDEST_WIDTH > 0 ? TID_OFFSET+TDEST_WIDTH : TID_OFFSET;
  localparam TUSER_OFFSET      = TUSER_WIDTH > 0 ? TDEST_OFFSET+TUSER_WIDTH : TDEST_OFFSET;
  localparam AXIS_DATA_WIDTH   = TUSER_OFFSET+1;

  // Define local parameters for mapping with base file
  
  localparam integer P_COMMON_CLOCK          = ( (CLOCKING_MODE == "common_clock"      || CLOCKING_MODE == "COMMON_CLOCK"      || CLOCKING_MODE == "COMMON" || CLOCKING_MODE == "common") ? 1 :
                                               ( (CLOCKING_MODE == "independent_clock" || CLOCKING_MODE == "INDEPENDENT_CLOCK" || CLOCKING_MODE == "INDEPENDENT" || CLOCKING_MODE == "independent") ? 0 : 1));
  localparam integer P_FIFO_MEMORY_TYPE      = ( (FIFO_MEMORY_TYPE == "lutram"   || FIFO_MEMORY_TYPE == "LUTRAM"   || FIFO_MEMORY_TYPE == "distributed"   || FIFO_MEMORY_TYPE == "DISTRIBUTED"  ) ? 1 :
                                               ( (FIFO_MEMORY_TYPE == "bram" || FIFO_MEMORY_TYPE == "BRAM" || FIFO_MEMORY_TYPE == "block" || FIFO_MEMORY_TYPE == "BLOCK") ? 2 :
                                               ( (FIFO_MEMORY_TYPE == "uram" || FIFO_MEMORY_TYPE == "URAM" || FIFO_MEMORY_TYPE == "ultra" || FIFO_MEMORY_TYPE == "ULTRA") ? 3 : 0)));

  localparam integer P_ECC_MODE              = ( (ECC_MODE  == "no_ecc" || ECC_MODE  == "NO_ECC" ) ? 0 : 1);
  localparam integer P_PKT_MODE              = PACKET_FIFO  == "true" ? 1 : 0;
  localparam AXIS_FINAL_DATA_WIDTH           = P_ECC_MODE == 0 ? AXIS_DATA_WIDTH : (((AXIS_DATA_WIDTH/64)*64) + ((AXIS_DATA_WIDTH%64 == 0) ? 0 : 64));
  localparam TUSER_MAX_WIDTH                 = 4096 - (TDEST_OFFSET+1);

  wire rst_axis;
  wire data_valid_axis;
  wire rd_rst_busy_axis;
  wire [AXIS_FINAL_DATA_WIDTH-1:0] axis_din;
  wire [AXIS_FINAL_DATA_WIDTH-1:0] axis_dout;
  
  initial begin : config_drc_axis
    reg drc_err_flag_axis;
    drc_err_flag_axis = 0;
    #1;

    if (AXIS_FINAL_DATA_WIDTH > 4096) begin
      $error("[%s %0d-%0d] Total width (sum of TDATA, TID, TDEST, TKEEP, TSTRB, TUSER and TLAST) of AXI Stream FIFO (%0d) exceeds the maximum supported width (%0d). Please reduce the width of TDATA or TID or TDEST or TUSER %m", "XPM_FIFO_AXIS", 20, 2, AXIS_FINAL_DATA_WIDTH, 4096);
      drc_err_flag_axis = 1;
    end

    if ((TDATA_WIDTH%8 != 0) || TDATA_WIDTH < 8 || TDATA_WIDTH > 2048) begin
      $error("[%s %0d-%0d] TDATA_WIDTH (%0d) value is outside of legal range. TDATA_WIDTH value must be between %0d and %0d, and it must be multiples of 8. %m", "XPM_FIFO_AXIS", 20, 3, TDATA_WIDTH, 8, 2048);
      drc_err_flag_axis = 1;
    end

    if (TID_WIDTH < 1 || TID_WIDTH > 32) begin
      $error("[%s %0d-%0d] TID_WIDTH (%0d) value is outside of legal range. TID_WIDTH value must be between %0d and %0d, and it must be multiples of 8. %m", "XPM_FIFO_AXIS", 20, 4, TID_WIDTH, 1, 32);
      drc_err_flag_axis = 1;
    end

    if (TDEST_WIDTH < 1 || TDEST_WIDTH > 32) begin
      $error("[%s %0d-%0d] TDEST_WIDTH (%0d) value is outside of legal range. TDEST_WIDTH value must be between %0d and %0d, and it must be multiples of 8. %m", "XPM_FIFO_AXIS", 20, 5, TDEST_WIDTH, 1, 32);
      drc_err_flag_axis = 1;
    end

    if (TUSER_WIDTH < 1 || TUSER_WIDTH > TUSER_MAX_WIDTH) begin
      $error("[%s %0d-%0d] TUSER_WIDTH (%0d) value is outside of legal range. TUSER_WIDTH value must be between %0d and %0d, and it must be multiples of 8. %m", "XPM_FIFO_AXIS", 20, 6, TUSER_WIDTH, 1, TUSER_MAX_WIDTH);
      drc_err_flag_axis = 1;
    end

    if (RELATED_CLOCKS == 1 && P_PKT_MODE != 1'b0) begin
      $error("[%s %0d-%0d] RELATED_CLOCKS (%0d) value is outside of legal range. RELATED_CLOCKS value must be 0 when PACKET_FIFO is set to %s. %m", "XPM_FIFO_AXIS", 20, 7, RELATED_CLOCKS, RELATED_CLOCKS);
      drc_err_flag_axis = 1;
    end

    if (EN_ADV_FEATURE_AXIS[13] == 1'b1 && (P_PKT_MODE != 1'b1 || P_COMMON_CLOCK != 1'b0)) begin
      $error("[%s %0d-%0d] USE_ADV_FEATURES[13] (%0b) value is outside of legal range. USE_ADV_FEATURES[13] can be set to 1 only for packet mode in asynchronous AXI-Stream FIFO. %m", "XPM_FIFO_AXIS", 20, 8, EN_ADV_FEATURE_AXIS[13]);
      drc_err_flag_axis = 1;
    end
 
    // Infos
    if (P_PKT_MODE == 1'b1 && EN_ADV_FEATURE_AXIS[3] != 1'b1)
      $info("[%s %0d-%0d] Almost full flag option is not enabled (USE_ADV_FEATURES[3] = %0b) but Packet FIFO mode requires almost_full to be enabled. XPM_FIFO_AXIS enables the Almost full flag automatically. You may ignore almost_full port if not required %m", "XPM_FIFO_AXIS", 21, 1, EN_ADV_FEATURE_AXIS[3]);

    if (P_PKT_MODE == 1'b1 && EN_ADV_FEATURE_AXIS[11] != 1'b1)
      $info("[%s %0d-%0d] Almost empty flag option is not enabled (USE_ADV_FEATURES[11] = %0b) but Packet FIFO mode requires almost_empty to be enabled. XPM_FIFO_AXIS enables the Almost empty flag automatically. You may ignore almost_empty port if not required %m", "XPM_FIFO_AXIS", 21, 1, EN_ADV_FEATURE_AXIS[11]);
 
    if (drc_err_flag_axis == 1)
      #1 $finish;
  end : config_drc_axis

  generate 
    if (P_ECC_MODE == 0) begin : axis_necc
      assign axis_din = ({s_axis_tlast, s_axis_tuser, s_axis_tdest, s_axis_tid, s_axis_tkeep, s_axis_tstrb, s_axis_tdata});
    end // axis_necc

   if (P_ECC_MODE == 1) begin : axis_ecc
    assign axis_din = ({{(AXIS_FINAL_DATA_WIDTH - AXIS_DATA_WIDTH){1'b0}},s_axis_tlast, s_axis_tuser, s_axis_tdest, s_axis_tid, s_axis_tkeep, s_axis_tstrb, s_axis_tdata});
   end // axis_ecc

   assign m_axis_tlast = axis_dout[AXIS_DATA_WIDTH-1];
   assign m_axis_tuser = axis_dout[TUSER_OFFSET-1:TDEST_OFFSET];
   assign m_axis_tdest = axis_dout[TDEST_OFFSET-1:TID_OFFSET];
   assign m_axis_tid   = axis_dout[TID_OFFSET-1:TKEEP_OFFSET];
   assign m_axis_tkeep = axis_dout[TKEEP_OFFSET-1:TSTRB_OFFSET];
   assign m_axis_tstrb = axis_dout[TSTRB_OFFSET-1:TDATA_OFFSET];
   assign m_axis_tdata = axis_dout[TDATA_OFFSET-1:0];
 
   // -------------------------------------------------------------------------------------------------------------------
   // Generate the instantiation of the appropriate XPM module
   // -------------------------------------------------------------------------------------------------------------------
   if (EN_ADV_FEATURE_AXIS[15] == 1'b0) begin : gaxis_rst_sync
      xpm_cdc_sync_rst #(
        .DEST_SYNC_FF   (P_COMMON_CLOCK?4:CDC_SYNC_STAGES),
        .INIT           (0),
        .INIT_SYNC_FF   (1),
        .SIM_ASSERT_CHK (0)
      ) xpm_cdc_sync_rst_inst (
        .src_rst  (~s_aresetn),
        .dest_clk (s_aclk),
        .dest_rst (rst_axis)
      );
   end // gaxis_rst_sync
   if (EN_ADV_FEATURE_AXIS[15] == 1'b1) begin : gnaxis_rst_sync
     assign rst_axis = s_aresetn;
   end // gnaxis_rst_sync

      xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK        ),
        .RELATED_CLOCKS             (RELATED_CLOCKS        ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE    ),
        .ECC_MODE                   (P_ECC_MODE            ),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH            ),
        .WRITE_DATA_WIDTH           (AXIS_FINAL_DATA_WIDTH ),
        .WR_DATA_COUNT_WIDTH        (WR_DATA_COUNT_WIDTH   ),
        .PROG_FULL_THRESH           (PROG_FULL_THRESH      ),
        .FULL_RESET_VALUE           (1                     ),
        .USE_ADV_FEATURES           (USE_ADV_FEATURES_INT  ),
        .READ_MODE                  (1                     ),
        .FIFO_READ_LATENCY          (0                     ),
        .READ_DATA_WIDTH            (AXIS_FINAL_DATA_WIDTH ),
        .RD_DATA_COUNT_WIDTH        (RD_DATA_COUNT_WIDTH   ),
        .PROG_EMPTY_THRESH          (PROG_EMPTY_THRESH     ),
        .DOUT_RESET_VALUE           (""                    ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES       ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                     ),
        .WAKEUP_TIME                (0                     ),
        .VERSION                    (0                     )
      ) xpm_fifo_base_inst (
        .sleep            (1'b0),
        .rst              (rst_axis),
        .wr_clk           (s_aclk),
        .wr_en            (s_axis_tvalid),
        .din              (axis_din),
        .full             (),
        .full_n           (s_axis_tready),
        .prog_full        (prog_full_axis),
        .wr_data_count    (wr_data_count_axis),
        .overflow         (),
        .wr_rst_busy      (),
        .almost_full      (almost_full_axis),
        .wr_ack           (),
        .rd_clk           (P_COMMON_CLOCK?s_aclk:m_aclk),
        .rd_en            (m_axis_tvalid&m_axis_tready),
        .dout             (axis_dout),
        .empty            (),
        .prog_empty       (prog_empty_axis),
        .rd_data_count    (rd_data_count_axis),
        .underflow        (),
        .rd_rst_busy      (rd_rst_busy_axis),
        .almost_empty     (almost_empty_axis),
        .data_valid       (data_valid_axis),
        .injectsbiterr    (injectsbiterr_axis),
        .injectdbiterr    (injectdbiterr_axis),
        .sbiterr          (sbiterr_axis),
        .dbiterr          (dbiterr_axis)
      );
  reg      axis_pkt_read  = 1'b0;
  reg      axis_wr_eop_d1 = 1'b0;
  wire     axis_wr_eop;
  wire     axis_rd_eop;
  integer  axis_pkt_cnt;

  if (P_PKT_MODE == 0) begin : gaxis_npkt_fifo
    assign m_axis_tvalid = data_valid_axis;
  end // gaxis_npkt_fifo

  if (P_PKT_MODE == 1 && P_COMMON_CLOCK == 1) begin : gaxis_pkt_fifo_cc
    assign axis_wr_eop = s_axis_tvalid & s_axis_tready & s_axis_tlast;
    assign axis_rd_eop = m_axis_tvalid & m_axis_tready & m_axis_tlast & axis_pkt_read;
    assign m_axis_tvalid = data_valid_axis & axis_pkt_read;

    always @ (posedge s_aclk) begin
      if (rst_axis)
        axis_pkt_read    <= 1'b0;
      else if (axis_rd_eop && (axis_pkt_cnt == 1) && ~axis_wr_eop_d1)
        axis_pkt_read    <= 1'b0;
      else if ((axis_pkt_cnt > 0) || (almost_full_axis && data_valid_axis))
        axis_pkt_read    <= 1'b1;
    end

    always @ (posedge s_aclk) begin
      if (rst_axis)
        axis_wr_eop_d1    <= 1'b0;
      else
        axis_wr_eop_d1   <= axis_wr_eop;
    end

    always @ (posedge s_aclk) begin
      if (rst_axis)
        axis_pkt_cnt    <= 0;
      else if (axis_wr_eop_d1 && ~axis_rd_eop)
        axis_pkt_cnt    <= axis_pkt_cnt + 1;
      else if (axis_rd_eop && ~axis_wr_eop_d1)
        axis_pkt_cnt    <= axis_pkt_cnt - 1;
    end
  end // gaxis_pkt_fifo_cc

  if (P_PKT_MODE == 1 && P_COMMON_CLOCK == 0) begin : gaxis_pkt_fifo_ic
    wire [LOG_DEPTH_AXIS-1 : 0] axis_wpkt_cnt_rd_lt8_0;
    wire [LOG_DEPTH_AXIS-1 : 0] axis_wpkt_cnt_rd_lt8_1;
    wire [LOG_DEPTH_AXIS-1 : 0] axis_wpkt_cnt_rd_lt8_2;
    wire [LOG_DEPTH_AXIS-1 : 0] axis_wpkt_cnt_rd;
    reg  [LOG_DEPTH_AXIS-1 : 0] axis_wpkt_cnt = 0;
    reg  [LOG_DEPTH_AXIS-1 : 0] axis_rpkt_cnt = 0;
    wire [LOG_DEPTH_AXIS : 0]   adj_axis_wpkt_cnt_rd_pad;
    wire [LOG_DEPTH_AXIS : 0]   rpkt_inv_pad;
    wire [LOG_DEPTH_AXIS-1 : 0] diff_pkt_cnt;
    reg  [LOG_DEPTH_AXIS : 0]   diff_pkt_cnt_pad = 0;
    reg  adj_axis_wpkt_cnt_rd_pad_0 = 0;
    reg  rpkt_inv_pad_0 = 0;
    wire axis_af_rd ;

    assign axis_wr_eop = s_axis_tvalid & s_axis_tready & s_axis_tlast;
    assign axis_rd_eop = m_axis_tvalid & m_axis_tready & m_axis_tlast & axis_pkt_read;
    assign m_axis_tvalid = data_valid_axis & axis_pkt_read;

    always @ (posedge m_aclk) begin
      if (rd_rst_busy_axis)
        axis_pkt_read    <= 1'b0;
      else if (axis_rd_eop && (diff_pkt_cnt == 1))
        axis_pkt_read    <= 1'b0;
      else if ((diff_pkt_cnt > 0) || (axis_af_rd && data_valid_axis))
        axis_pkt_read    <= 1'b1;
    end

    always @ (posedge s_aclk) begin
      if (rst_axis)
        axis_wpkt_cnt    <= 1'b0;
      else if (axis_wr_eop)
        axis_wpkt_cnt    <= axis_wpkt_cnt + 1;
    end

    xpm_cdc_gray #(
      .DEST_SYNC_FF          (CDC_SYNC_STAGES),
      .INIT_SYNC_FF          (1),
      .REG_OUTPUT            (1),
      .WIDTH                 (LOG_DEPTH_AXIS))
      
      wpkt_cnt_cdc_inst (
        .src_clk             (s_aclk),
        .src_in_bin          (axis_wpkt_cnt),
        .dest_clk            (m_aclk),
        .dest_out_bin        (axis_wpkt_cnt_rd_lt8_0));

    if (PKT_SIZE_LT8 == 1) begin : pkt_lt8
      xpm_fifo_reg_vec #(LOG_DEPTH_AXIS)
        wpkt_cnt_rd_dly_inst1 (rd_rst_busy_axis, m_aclk, axis_wpkt_cnt_rd_lt8_0, axis_wpkt_cnt_rd_lt8_1);
      xpm_fifo_reg_vec #(LOG_DEPTH_AXIS)
        wpkt_cnt_rd_dly_inst2 (rd_rst_busy_axis, m_aclk, axis_wpkt_cnt_rd_lt8_1, axis_wpkt_cnt_rd_lt8_2);
      xpm_fifo_reg_vec #(LOG_DEPTH_AXIS)
        wpkt_cnt_rd_dly_inst3 (rd_rst_busy_axis, m_aclk, axis_wpkt_cnt_rd_lt8_2, axis_wpkt_cnt_rd);
    end else begin : pkt_nlt8
      assign axis_wpkt_cnt_rd = axis_wpkt_cnt_rd_lt8_0;
    end

    xpm_cdc_single #(
      .DEST_SYNC_FF          (CDC_SYNC_STAGES),
      .SRC_INPUT_REG         (0),
      .INIT_SYNC_FF          (1))
      
      af_axis_cdc_inst (
        .src_clk             (s_aclk),
        .src_in              (almost_full_axis),
        .dest_clk            (m_aclk),
        .dest_out            (axis_af_rd));

    always @ (posedge m_aclk) begin
      if (rd_rst_busy_axis)
        axis_rpkt_cnt    <= 1'b0;
      else if (axis_rd_eop)
        axis_rpkt_cnt    <= axis_rpkt_cnt + 1;
    end

    // Take the difference of write and read packet count using 1's complement
    assign adj_axis_wpkt_cnt_rd_pad[LOG_DEPTH_AXIS : 1] = axis_wpkt_cnt_rd;
    assign rpkt_inv_pad[LOG_DEPTH_AXIS : 1]             = ~axis_rpkt_cnt;
    assign adj_axis_wpkt_cnt_rd_pad[0]                  = adj_axis_wpkt_cnt_rd_pad_0;
    assign rpkt_inv_pad[0]                              = rpkt_inv_pad_0;


    always @ ( axis_rd_eop ) begin
      if (!axis_rd_eop) begin
        adj_axis_wpkt_cnt_rd_pad_0    <= 1'b1;
        rpkt_inv_pad_0                <= 1'b1;
      end else begin 
        adj_axis_wpkt_cnt_rd_pad_0    <= 1'b0;
        rpkt_inv_pad_0                <= 1'b0;
      end	
    end
  
    always @ (posedge m_aclk) begin
      if (rd_rst_busy_axis)
        diff_pkt_cnt_pad    <= 1'b0;
      else 
        diff_pkt_cnt_pad    <= adj_axis_wpkt_cnt_rd_pad + rpkt_inv_pad ;
    end

    assign  diff_pkt_cnt = diff_pkt_cnt_pad [LOG_DEPTH_AXIS : 1] ;

  end // gaxis_pkt_fifo_ic
  endgenerate

endmodule : xpm_fifo_axis 

//********************************************************************************************************************
//********************************************************************************************************************
//********************************************************************************************************************


(* XPM_MODULE = "TRUE",  KEEP_HIERARCHY = "SOFT" *)
module xpm_fifo_axif
  #(
  parameter integer  AXI_ID_WIDTH            = 1,
  parameter integer  AXI_ADDR_WIDTH          = 32,
  parameter integer  AXI_DATA_WIDTH          = 32,
  parameter integer  AXI_LEN_WIDTH           = 8,
  parameter integer  AXI_ARUSER_WIDTH        = 1,
  parameter integer  AXI_AWUSER_WIDTH        = 1,
  parameter integer  AXI_WUSER_WIDTH         = 1,
  parameter integer  AXI_BUSER_WIDTH         = 1,
  parameter integer  AXI_RUSER_WIDTH         = 1,
  parameter          CLOCKING_MODE             = "common",
  parameter integer  SIM_ASSERT_CHK            = 0,
  parameter integer  CASCADE_HEIGHT            = 0,
  parameter integer  CDC_SYNC_STAGES           = 2,
  parameter integer  EN_RESET_SYNCHRONIZER     = 0,
  parameter          PACKET_FIFO               = "false",
  parameter          FIFO_MEMORY_TYPE_WACH     = "lutram",
  parameter          FIFO_MEMORY_TYPE_WDCH     = "bram",
  parameter          FIFO_MEMORY_TYPE_WRCH     = "lutram",
  parameter          FIFO_MEMORY_TYPE_RACH     = "lutram",
  parameter          FIFO_MEMORY_TYPE_RDCH     = "bram",
  parameter integer  FIFO_DEPTH_WACH           = 16,
  parameter integer  FIFO_DEPTH_WDCH           = 16,
  parameter integer  FIFO_DEPTH_WRCH           = 2048,
  parameter integer  FIFO_DEPTH_RACH           = 16,
  parameter integer  FIFO_DEPTH_RDCH           = 2048,
  parameter          ECC_MODE_WDCH             = "no_ecc",
  parameter          ECC_MODE_RDCH             = "no_ecc",
  parameter          USE_ADV_FEATURES_WDCH     = "1000",
  parameter          USE_ADV_FEATURES_RDCH     = "1000",
  parameter integer  WR_DATA_COUNT_WIDTH_WDCH  = 10,
  parameter integer  WR_DATA_COUNT_WIDTH_RDCH  = 10,
  parameter integer  RD_DATA_COUNT_WIDTH_WDCH  = 10,
  parameter integer  RD_DATA_COUNT_WIDTH_RDCH  = 10,
  parameter integer  PROG_FULL_THRESH_WDCH     = 10,
  parameter integer  PROG_FULL_THRESH_RDCH     = 10,
  parameter integer  PROG_EMPTY_THRESH_WDCH    = 10,
  parameter integer  PROG_EMPTY_THRESH_RDCH    = 10

    )
   (
    // AXI Global Signal
    input wire                              m_aclk,
    input wire                              s_aclk,
    input wire                              s_aresetn,

    // AXI Full/Lite Slave Write Channel (write side)
    input wire [AXI_ID_WIDTH-1:0]          s_axi_awid,
    input wire [AXI_ADDR_WIDTH-1:0]        s_axi_awaddr,
    input wire [AXI_LEN_WIDTH-1:0]         s_axi_awlen,
    input wire [3-1:0]                       s_axi_awsize,
    input wire [2-1:0]                       s_axi_awburst,
    input wire [2-1:0]                       s_axi_awlock,
    input wire [4-1:0]                       s_axi_awcache,
    input wire [3-1:0]                       s_axi_awprot,
    input wire [4-1:0]                       s_axi_awqos,
    input wire [4-1:0]                       s_axi_awregion,
    input wire [AXI_AWUSER_WIDTH-1:0]      s_axi_awuser,
    input wire                               s_axi_awvalid,
    output wire                              s_axi_awready,
    input wire [AXI_DATA_WIDTH-1:0]        s_axi_wdata,
    input wire [AXI_DATA_WIDTH/8-1:0]      s_axi_wstrb,
    input wire                               s_axi_wlast,
    input wire [AXI_WUSER_WIDTH-1:0]       s_axi_wuser,
    input wire                               s_axi_wvalid,
    output wire                              s_axi_wready,
    output wire  [AXI_ID_WIDTH-1:0]        s_axi_bid,
    output wire  [2-1:0]                     s_axi_bresp,
    output wire  [AXI_BUSER_WIDTH-1:0]     s_axi_buser,
    output wire                              s_axi_bvalid,
    input wire                               s_axi_bready,

    // AXI Full/Lite Master Write Channel (read side)
    output wire [AXI_ID_WIDTH-1:0]         m_axi_awid,
    output wire [AXI_ADDR_WIDTH-1:0]       m_axi_awaddr,
    output wire [AXI_LEN_WIDTH-1:0]        m_axi_awlen,
    output wire [3-1:0]                      m_axi_awsize,
    output wire [2-1:0]                      m_axi_awburst,
    output wire [2-1:0]                      m_axi_awlock,
    output wire [4-1:0]                      m_axi_awcache,
    output wire [3-1:0]                      m_axi_awprot,
    output wire [4-1:0]                      m_axi_awqos,
    output wire [4-1:0]                      m_axi_awregion,
    output wire [AXI_AWUSER_WIDTH-1:0]     m_axi_awuser,
    output wire                              m_axi_awvalid,
    input  wire                              m_axi_awready,
    output wire [AXI_DATA_WIDTH-1:0]       m_axi_wdata,
    output wire [AXI_DATA_WIDTH/8-1:0]     m_axi_wstrb,
    output wire                              m_axi_wlast,
    output wire [AXI_WUSER_WIDTH-1:0]      m_axi_wuser,
    output wire                              m_axi_wvalid,
    input  wire                              m_axi_wready,
    input wire [AXI_ID_WIDTH-1:0]          m_axi_bid,
    input wire [2-1:0]                       m_axi_bresp,
    input wire [AXI_BUSER_WIDTH-1:0]       m_axi_buser,
    input wire                               m_axi_bvalid,
    output wire                              m_axi_bready,

    // AXI Full/Lite Slave Read Channel (write side)
    input wire [AXI_ID_WIDTH-1:0]          s_axi_arid,
    input wire [AXI_ADDR_WIDTH-1:0]        s_axi_araddr, 
    input wire [AXI_LEN_WIDTH-1:0]         s_axi_arlen,
    input wire [3-1:0]                       s_axi_arsize,
    input wire [2-1:0]                       s_axi_arburst,
    input wire [2-1:0]                       s_axi_arlock,
    input wire [4-1:0]                       s_axi_arcache,
    input wire [3-1:0]                       s_axi_arprot,
    input wire [4-1:0]                       s_axi_arqos,
    input wire [4-1:0]                       s_axi_arregion,
    input wire [AXI_ARUSER_WIDTH-1:0]      s_axi_aruser,
    input wire                               s_axi_arvalid,
    output wire                              s_axi_arready,
    output wire  [AXI_ID_WIDTH-1:0]        s_axi_rid,       
    output wire  [AXI_DATA_WIDTH-1:0]      s_axi_rdata, 
    output wire  [2-1:0]                     s_axi_rresp,
    output wire                              s_axi_rlast,
    output wire  [AXI_RUSER_WIDTH-1:0]     s_axi_ruser,
    output wire                              s_axi_rvalid,
    input wire                               s_axi_rready,

    // AXI Full/Lite Master Read Channel (read side)
    output wire [AXI_ID_WIDTH-1:0]         m_axi_arid,        
    output wire [AXI_ADDR_WIDTH-1:0]       m_axi_araddr,  
    output wire [AXI_LEN_WIDTH-1:0]        m_axi_arlen,
    output wire [3-1:0]                      m_axi_arsize,
    output wire [2-1:0]                      m_axi_arburst,
    output wire [2-1:0]                      m_axi_arlock,
    output wire [4-1:0]                      m_axi_arcache,
    output wire [3-1:0]                      m_axi_arprot,
    output wire [4-1:0]                      m_axi_arqos,
    output wire [4-1:0]                      m_axi_arregion,
    output wire [AXI_ARUSER_WIDTH-1:0]     m_axi_aruser,
    output wire                              m_axi_arvalid,
    input  wire                              m_axi_arready,
    input wire [AXI_ID_WIDTH-1:0]          m_axi_rid,        
    input wire [AXI_DATA_WIDTH-1:0]        m_axi_rdata,  
    input wire [2-1:0]                       m_axi_rresp,
    input wire                               m_axi_rlast,
    input wire [AXI_RUSER_WIDTH-1:0]       m_axi_ruser,
    input wire                               m_axi_rvalid,
    output wire                              m_axi_rready,

    // AXI4-Full Sideband Signals
    output wire                           prog_full_wdch,
    output wire                           prog_empty_wdch,
    output wire [WR_DATA_COUNT_WIDTH_WDCH-1:0] wr_data_count_wdch,
    output wire [RD_DATA_COUNT_WIDTH_WDCH-1:0] rd_data_count_wdch,
    output wire                           prog_full_rdch,
    output wire                           prog_empty_rdch,
    output wire [WR_DATA_COUNT_WIDTH_RDCH-1:0] wr_data_count_rdch,
    output wire [RD_DATA_COUNT_WIDTH_RDCH-1:0] rd_data_count_rdch,
  
    // ECC Related ports
    input  wire                           injectsbiterr_wdch,
    input  wire                           injectdbiterr_wdch,
    output wire                           sbiterr_wdch,
    output wire                           dbiterr_wdch,
    input  wire                           injectsbiterr_rdch,
    input  wire                           injectdbiterr_rdch,
    output wire                           sbiterr_rdch,
    output wire                           dbiterr_rdch

    );


  // Function to convert ASCII value to binary 
  function [3:0] str2bin;
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
            str2bin = str_val_ascii[3:0];
         else begin
           str2bin [3] = 1'b1;
           str2bin [2] = str_val_ascii[2] | (str_val_ascii[1] & str_val_ascii[0]);
           str2bin [1] = str_val_ascii[0] ^ str_val_ascii[1];
           str2bin [0] = !str_val_ascii[0];
         end
      end
      else
        $error("Found Invalid character while parsing the string, please cross check the value specified for either READ_RESET_VALUE_A|B or MEMORY_INIT_PARAM (if initialization of memory through parameter is used). XPM_MEMORY supports strings (hex) that contains characters 0-9, A-F and a-f.");
  endfunction
  // Function that parses the complete reset value string
  function logic [15:0] hstr2bin;
    input [16*8-1 : 0] hstr_val;
    integer rst_loop_a;
    localparam integer  rsta_loop_iter  =  16;
    logic [rsta_loop_iter-1 : 0] rst_val_conv_a_i;
    for (rst_loop_a=1; rst_loop_a <= rsta_loop_iter/4; rst_loop_a = rst_loop_a+1) begin
      rst_val_conv_a_i[(rst_loop_a*4)-1 -: 4] =  str2bin(hstr_val[(rst_loop_a*8)-1 -: 8]);
    end
    return rst_val_conv_a_i[15:0];
  endfunction

//Function to convert binary to ASCII value
  function [7:0] bin2str;
    input [3:0] bin_val;
      if( bin_val > 4'h9) begin
           bin2str [7:4] = 4'h4;
           bin2str [3]   = 1'b0;
           bin2str [2:0] = bin_val[2:0]-1'b1;
           end
         else begin
           bin2str [7:4] = 4'h3;
           bin2str [3:0] = bin_val;
         end
  endfunction

  // Function that parses the complete binary value to string
  function [31:0] bin2hstr;
    input [15 : 0] bin_val;
    integer str_pos;
    localparam integer  str_max_bits  =  32;
    for (str_pos=1; str_pos <= str_max_bits/8; str_pos = str_pos+1) begin
      bin2hstr[(str_pos*8)-1 -: 8] =  bin2str(bin_val[(str_pos*4)-1 -: 4]);
    end
  endfunction

//WDCH advanced features parameter conversion
  localparam [15:0] EN_ADV_FEATURE_WDCH       = hstr2bin(USE_ADV_FEATURES_WDCH);
  localparam        EN_ALMOST_FULL_INT_WDCH   = (PACKET_FIFO == "true") ? 1'b1 : EN_ADV_FEATURE_WDCH[3]; 
  localparam        EN_ALMOST_EMPTY_INT_WDCH  = (PACKET_FIFO == "true") ? 1'b1 : EN_ADV_FEATURE_WDCH[11]; 
  localparam        EN_DATA_VALID_INT         = 1'b1;
  localparam [15:0] EN_ADV_FEATURE_WDCH_INT   = {EN_ADV_FEATURE_WDCH[15:13], EN_DATA_VALID_INT, EN_ALMOST_EMPTY_INT_WDCH, EN_ADV_FEATURE_WDCH[10:4], EN_ALMOST_FULL_INT_WDCH, EN_ADV_FEATURE_WDCH[2:0]};
  localparam        USE_ADV_FEATURES_WDCH_INT = bin2hstr(EN_ADV_FEATURE_WDCH_INT);


//RDCH advanced features parameter conversion
  localparam [15:0] EN_ADV_FEATURE_RDCH       = hstr2bin(USE_ADV_FEATURES_RDCH);
  localparam        EN_ALMOST_FULL_INT_RDCH   = (PACKET_FIFO == "true") ? 1'b1 : EN_ADV_FEATURE_RDCH[3]; 
  localparam        EN_ALMOST_EMPTY_INT_RDCH  = (PACKET_FIFO == "true") ? 1'b1 : EN_ADV_FEATURE_RDCH[11]; 
  localparam [15:0] EN_ADV_FEATURE_RDCH_INT   = {EN_ADV_FEATURE_RDCH[15:13], EN_DATA_VALID_INT, EN_ALMOST_EMPTY_INT_RDCH, EN_ADV_FEATURE_RDCH[10:4], EN_ALMOST_FULL_INT_RDCH, EN_ADV_FEATURE_RDCH[2:0]};
  localparam        USE_ADV_FEATURES_RDCH_INT = bin2hstr(EN_ADV_FEATURE_RDCH_INT);


    localparam C_AXI_LOCK_WIDTH   = 2;
    // AXI Channel Type
    // WACH --> Write Address Channel
    // WDCH --> Write Data Channel
    // WRCH --> Write Response Channel
    // RACH --> Read Address Channel
    // RDCH --> Read Data Channel
    localparam C_WACH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logic
    localparam C_WDCH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logie
    localparam C_WRCH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logie
    localparam C_RACH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logie
    localparam C_RDCH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logie

    // Input Data Width
    // Accumulation of all AXI input signal's width
    localparam C_DIN_WIDTH_WACH               = AXI_ID_WIDTH+AXI_ADDR_WIDTH+AXI_AWUSER_WIDTH+AXI_LEN_WIDTH+C_AXI_LOCK_WIDTH+20;
    localparam C_DIN_WIDTH_WDCH               = AXI_DATA_WIDTH/8+AXI_DATA_WIDTH+AXI_WUSER_WIDTH+1;
    localparam C_DIN_WIDTH_WRCH               = AXI_ID_WIDTH+AXI_BUSER_WIDTH+2;
    localparam C_DIN_WIDTH_RACH               = AXI_ID_WIDTH+AXI_ADDR_WIDTH+AXI_ARUSER_WIDTH+AXI_LEN_WIDTH+C_AXI_LOCK_WIDTH+20;
    localparam C_DIN_WIDTH_RDCH               = AXI_ID_WIDTH+AXI_DATA_WIDTH+AXI_RUSER_WIDTH+3;


  // Define local parameters for mapping with base file
  localparam integer P_COMMON_CLOCK          = ( (CLOCKING_MODE == "common_clock"      || CLOCKING_MODE == "COMMON_CLOCK"      || CLOCKING_MODE == "COMMON" || CLOCKING_MODE == "common") ? 1 :
                                               ( (CLOCKING_MODE == "independent_clock" || CLOCKING_MODE == "INDEPENDENT_CLOCK" || CLOCKING_MODE == "INDEPENDENT" || CLOCKING_MODE == "independent") ? 0 : 2));

  localparam integer P_ECC_MODE_WDCH         = ( (ECC_MODE_WDCH == "no_ecc" || ECC_MODE_WDCH == "NO_ECC" ) ? 0 : 1);
  localparam integer P_ECC_MODE_RDCH         = ( (ECC_MODE_RDCH == "no_ecc" || ECC_MODE_RDCH == "NO_ECC" ) ? 0 : 1);
  localparam integer P_FIFO_MEMORY_TYPE_WACH = ( (FIFO_MEMORY_TYPE_WACH == "lutram"   || FIFO_MEMORY_TYPE_WACH == "LUTRAM"   || FIFO_MEMORY_TYPE_WACH == "distributed"   || FIFO_MEMORY_TYPE_WACH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_WACH == "blockram" || FIFO_MEMORY_TYPE_WACH == "BLOCKRAM" || FIFO_MEMORY_TYPE_WACH == "bram" || FIFO_MEMORY_TYPE_WACH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_WACH == "ultraram" || FIFO_MEMORY_TYPE_WACH == "ULTRARAM" || FIFO_MEMORY_TYPE_WACH == "uram" || FIFO_MEMORY_TYPE_WACH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_WACH == "builtin"  || FIFO_MEMORY_TYPE_WACH == "BUILTIN") ? 4 : 0))));
  localparam integer P_FIFO_MEMORY_TYPE_WDCH = ( (FIFO_MEMORY_TYPE_WDCH == "lutram"   || FIFO_MEMORY_TYPE_WDCH == "LUTRAM"   || FIFO_MEMORY_TYPE_WDCH == "distributed"   || FIFO_MEMORY_TYPE_WDCH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_WDCH == "blockram" || FIFO_MEMORY_TYPE_WDCH == "BLOCKRAM" || FIFO_MEMORY_TYPE_WDCH == "bram" || FIFO_MEMORY_TYPE_WDCH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_WDCH == "ultraram" || FIFO_MEMORY_TYPE_WDCH == "ULTRARAM" || FIFO_MEMORY_TYPE_WDCH == "uram" || FIFO_MEMORY_TYPE_WDCH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_WDCH == "builtin"  || FIFO_MEMORY_TYPE_WDCH == "BUILTIN") ? 4 : 0))));
  localparam integer P_FIFO_MEMORY_TYPE_WRCH = ( (FIFO_MEMORY_TYPE_WRCH == "lutram"   || FIFO_MEMORY_TYPE_WRCH == "LUTRAM"   || FIFO_MEMORY_TYPE_WRCH == "distributed"   || FIFO_MEMORY_TYPE_WRCH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_WRCH == "blockram" || FIFO_MEMORY_TYPE_WRCH == "BLOCKRAM" || FIFO_MEMORY_TYPE_WRCH == "bram" || FIFO_MEMORY_TYPE_WRCH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_WRCH == "ultraram" || FIFO_MEMORY_TYPE_WRCH == "ULTRARAM" || FIFO_MEMORY_TYPE_WRCH == "uram" || FIFO_MEMORY_TYPE_WRCH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_WRCH == "builtin"  || FIFO_MEMORY_TYPE_WRCH == "BUILTIN") ? 4 : 0))));
  localparam integer P_FIFO_MEMORY_TYPE_RACH = ( (FIFO_MEMORY_TYPE_RACH == "lutram"   || FIFO_MEMORY_TYPE_RACH == "LUTRAM"   || FIFO_MEMORY_TYPE_RACH == "distributed"   || FIFO_MEMORY_TYPE_RACH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_RACH == "blockram" || FIFO_MEMORY_TYPE_RACH == "BLOCKRAM" || FIFO_MEMORY_TYPE_RACH == "bram" || FIFO_MEMORY_TYPE_RACH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_RACH == "ultraram" || FIFO_MEMORY_TYPE_RACH == "ULTRARAM" || FIFO_MEMORY_TYPE_RACH == "uram" || FIFO_MEMORY_TYPE_RACH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_RACH == "builtin"  || FIFO_MEMORY_TYPE_RACH == "BUILTIN") ? 4 : 0))));
  localparam integer P_FIFO_MEMORY_TYPE_RDCH = ( (FIFO_MEMORY_TYPE_RDCH == "lutram"   || FIFO_MEMORY_TYPE_RDCH == "LUTRAM"   || FIFO_MEMORY_TYPE_RDCH == "distributed"   || FIFO_MEMORY_TYPE_RDCH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_RDCH == "blockram" || FIFO_MEMORY_TYPE_RDCH == "BLOCKRAM" || FIFO_MEMORY_TYPE_RDCH == "bram" || FIFO_MEMORY_TYPE_RDCH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_RDCH == "ultraram" || FIFO_MEMORY_TYPE_RDCH == "ULTRARAM" || FIFO_MEMORY_TYPE_RDCH == "uram" || FIFO_MEMORY_TYPE_RDCH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_RDCH == "builtin"  || FIFO_MEMORY_TYPE_RDCH == "BUILTIN") ? 4 : 0))));


    localparam C_DIN_WIDTH_WDCH_ECC           = (P_ECC_MODE_WDCH == 0) ? C_DIN_WIDTH_WDCH : ((C_DIN_WIDTH_WDCH%64 == 0) ? C_DIN_WIDTH_WDCH : (64*(C_DIN_WIDTH_WDCH/64+1)));
    localparam C_DIN_WIDTH_RDCH_ECC           = (P_ECC_MODE_RDCH == 0) ? C_DIN_WIDTH_RDCH : ((C_DIN_WIDTH_RDCH%64 == 0) ? C_DIN_WIDTH_RDCH : (64*(C_DIN_WIDTH_RDCH/64+1)));


    wire                              wr_rst_busy_wach;
    wire                              wr_rst_busy_wdch;
    wire                              wr_rst_busy_wrch;
    wire                              wr_rst_busy_rach;
    wire                              wr_rst_busy_rdch;










  localparam C_AXI_SIZE_WIDTH   = 3;
  localparam C_AXI_BURST_WIDTH  = 2;
  localparam C_AXI_CACHE_WIDTH  = 4;
  localparam C_AXI_PROT_WIDTH   = 3;
  localparam C_AXI_QOS_WIDTH    = 4;
  localparam C_AXI_REGION_WIDTH = 4;
  localparam C_AXI_BRESP_WIDTH  = 2;
  localparam C_AXI_RRESP_WIDTH  = 2;


  wire     inverted_reset = ~s_aresetn;
  wire     rst_axif_sclk;
  wire     rst_axif_mclk;
  wire     m_aclk_int;
  assign   m_aclk_int = P_COMMON_CLOCK ? s_aclk : m_aclk;

  generate 
  if (EN_RESET_SYNCHRONIZER == 1) begin : gen_sync_reset
//Reset Synchronizer
      xpm_cdc_sync_rst #(
        .DEST_SYNC_FF   (P_COMMON_CLOCK ? 4 : CDC_SYNC_STAGES),
        .INIT           (0),
        .INIT_SYNC_FF   (1),
        .SIM_ASSERT_CHK (0)
      ) xpm_cdc_sync_rst_sclk_inst (
        .src_rst  (~s_aresetn),
        .dest_clk (s_aclk),
        .dest_rst (rst_axif_sclk)
      );
      xpm_cdc_sync_rst #(
        .DEST_SYNC_FF   (P_COMMON_CLOCK ? 4 : CDC_SYNC_STAGES),
        .INIT           (0),
        .INIT_SYNC_FF   (1),
        .SIM_ASSERT_CHK (0)
      ) xpm_cdc_sync_rst_mclk_inst (
        .src_rst  (~s_aresetn),
        .dest_clk (m_aclk_int),
        .dest_rst (rst_axif_mclk)
      );
  end // gen_sync_reset
  if (EN_RESET_SYNCHRONIZER == 0) begin : gen_async_reset
  assign rst_axif_sclk = inverted_reset;
  assign rst_axif_mclk = inverted_reset;
  
  end // gen_async_reset
  endgenerate 


  //###########################################################################
  //  AXI FULL Write Channel (axi_write_channel)
  //###########################################################################


  localparam IS_AXI_FULL_WACH  = ((C_WACH_TYPE == 0)) ? 1 : 0;
  localparam IS_AXI_FULL_WDCH  = ((C_WDCH_TYPE == 0)) ? 1 : 0;
  localparam IS_AXI_FULL_WRCH  = ((C_WRCH_TYPE == 0)) ? 1 : 0;
  localparam IS_AXI_FULL_RACH  = ((C_RACH_TYPE == 0)) ? 1 : 0;
  localparam IS_AXI_FULL_RDCH  = ((C_RDCH_TYPE == 0)) ? 1 : 0;

  localparam IS_WR_ADDR_CH     = (IS_AXI_FULL_WACH == 1)  ? 1 : 0;
  localparam IS_WR_DATA_CH     = (IS_AXI_FULL_WDCH == 1)  ? 1 : 0;
  localparam IS_WR_RESP_CH     = (IS_AXI_FULL_WRCH == 1)  ? 1 : 0;
  localparam IS_RD_ADDR_CH     = (IS_AXI_FULL_RACH == 1)  ? 1 : 0;
  localparam IS_RD_DATA_CH     = (IS_AXI_FULL_RDCH == 1)  ? 1 : 0;

  localparam AWID_OFFSET       = C_DIN_WIDTH_WACH - AXI_ID_WIDTH ;
  localparam AWADDR_OFFSET     = AWID_OFFSET - AXI_ADDR_WIDTH;
  localparam AWLEN_OFFSET      = AWADDR_OFFSET - AXI_LEN_WIDTH ;
  localparam AWSIZE_OFFSET     = AWLEN_OFFSET - C_AXI_SIZE_WIDTH ;
  localparam AWBURST_OFFSET    = AWSIZE_OFFSET - C_AXI_BURST_WIDTH ;
  localparam AWLOCK_OFFSET     = AWBURST_OFFSET - C_AXI_LOCK_WIDTH ;
  localparam AWCACHE_OFFSET    = AWLOCK_OFFSET - C_AXI_CACHE_WIDTH ;
  localparam AWPROT_OFFSET     = AWCACHE_OFFSET - C_AXI_PROT_WIDTH;
  localparam AWQOS_OFFSET      = AWPROT_OFFSET - C_AXI_QOS_WIDTH;
  localparam AWREGION_OFFSET   = AWQOS_OFFSET - C_AXI_REGION_WIDTH ;
  localparam AWUSER_OFFSET     = AWREGION_OFFSET-AXI_AWUSER_WIDTH ;

  localparam WID_OFFSET        = C_DIN_WIDTH_WDCH;
  localparam WDATA_OFFSET      = WID_OFFSET - AXI_DATA_WIDTH;
  localparam WSTRB_OFFSET      = WDATA_OFFSET - AXI_DATA_WIDTH/8;
  localparam WUSER_OFFSET      = WSTRB_OFFSET-AXI_WUSER_WIDTH ;

  localparam BID_OFFSET        = C_DIN_WIDTH_WRCH - AXI_ID_WIDTH ;
  localparam BRESP_OFFSET      = BID_OFFSET - C_AXI_BRESP_WIDTH;
  localparam BUSER_OFFSET      = BRESP_OFFSET-AXI_BUSER_WIDTH;


  wire  [C_DIN_WIDTH_WACH-1:0]  wach_din          ;
  wire  [C_DIN_WIDTH_WACH-1:0]  wach_dout         ;
  wire  [C_DIN_WIDTH_WACH-1:0]  wach_dout_pkt     ;
  wire                          wach_full         ;
  wire                          wach_almost_full  ;
  wire                          wach_prog_full    ;
  wire                          wach_empty        ;
  wire                          wach_almost_empty ;
  wire                          wach_prog_empty   ;
  wire  [C_DIN_WIDTH_WDCH_ECC-1:0]  wdch_din          ;
  wire  [C_DIN_WIDTH_WDCH_ECC-1:0]  wdch_dout         ;
  wire                          wdch_full         ;
  wire                          wdch_almost_full  ;
  wire                          wdch_prog_full    ;
  wire                          wdch_empty        ;
  wire                          wdch_almost_empty ;
  wire                          wdch_prog_empty   ;
  wire  [C_DIN_WIDTH_WRCH-1:0]  wrch_din          ;
  wire  [C_DIN_WIDTH_WRCH-1:0]  wrch_dout         ;
  wire                          wrch_full         ;
  wire                          wrch_almost_full  ;
  wire                          wrch_prog_full    ;
  wire                          wrch_empty        ;
  wire                          wrch_almost_empty ;
  wire                          wrch_prog_empty   ;
  wire                          axi_aw_underflow_i;
  wire                          axi_w_underflow_i ;
  wire                          axi_b_underflow_i ;
  wire                          axi_aw_overflow_i ;
  wire                          axi_w_overflow_i  ;
  wire                          axi_b_overflow_i  ;
  wire                          wach_s_axi_awready;
  wire                          wach_m_axi_awvalid;
  wire                          wach_rd_en        ;
  wire                          wdch_s_axi_wready ;
  wire                          wdch_m_axi_wvalid ;
  wire                          wdch_wr_en        ;
  wire                          wdch_rd_en        ;
  wire                          wrch_s_axi_bvalid ;
  wire                          wrch_m_axi_bready ;
  wire                          txn_count_up      ;
  wire                          txn_count_down    ;
  wire                          awvalid_en        ;
  wire                          awvalid_pkt       ;
  wire                          awready_pkt       ;
  integer                       wr_pkt_count      ;
  wire                          wach_re           ;
  wire                          wdch_we           ;
  wire                          wdch_re           ;

  generate if (IS_WR_ADDR_CH == 1) begin : axi_write_address_channel
    // Write protection when almost full or prog_full is high

    // Read protection when almost empty or prog_empty is high
    assign wach_re    = (PACKET_FIFO == "true") ? awready_pkt & awvalid_en : m_axi_awready;
    assign wach_rd_en = wach_re;


xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK      ),
        .RELATED_CLOCKS             (0                   ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_WACH),
        .ECC_MODE                   (0),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_WACH     ),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_WACH    ),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           ("0101"),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_WACH    ),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_wach_dut (
        .sleep            (1'b0),
        .rst              (rst_axif_sclk),
        .wr_clk           (s_aclk),
        .wr_en            (s_axi_awvalid),
        .din              (wach_din),
        .full             (wach_full),
        .full_n           (),
        .prog_full        (),
        .wr_data_count    (),
        .overflow         (axi_aw_overflow_i),
        .wr_rst_busy      (wr_rst_busy_wach),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (m_aclk_int),
        .rd_en            (wach_rd_en),
        .dout             (wach_dout_pkt),
        .empty            (wach_empty),
        .prog_empty       (),
        .rd_data_count    (),
        .underflow        (axi_aw_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (1'b0),
        .injectdbiterr    (1'b0),
        .sbiterr          (),
        .dbiterr          ()
      );

    assign wach_s_axi_awready    = (FIFO_MEMORY_TYPE_WACH == "lutram") ? ~(wach_full | wr_rst_busy_wach) : ~wach_full;
    assign wach_m_axi_awvalid   = ~wach_empty;
    assign s_axi_awready        = wach_s_axi_awready;


  end endgenerate // axi_write_address_channel

  
  generate if (PACKET_FIFO == "true") begin : axi_mm_pkt_fifo_wr

    xpm_fifo_axi_reg_slice
          #(
            .C_DATA_WIDTH            (C_DIN_WIDTH_WACH),
            .C_REG_CONFIG            (1)
            )
    wach_pkt_reg_slice_inst
        (
          // System Signals
          .ACLK                      (s_aclk),
          .ARESET                    (rst_axif_sclk),

          // Slave side
          .S_PAYLOAD_DATA            (wach_dout_pkt),
          .S_VALID                   (awvalid_pkt),
          .S_READY                   (awready_pkt),

          // Master side
          .M_PAYLOAD_DATA            (wach_dout),
          .M_VALID                   (m_axi_awvalid),
          .M_READY                   (m_axi_awready)
          );

    assign awvalid_pkt = wach_m_axi_awvalid && awvalid_en;

    assign txn_count_up = wdch_s_axi_wready && wdch_wr_en && wdch_din[0]; 
    assign txn_count_down = wach_m_axi_awvalid && awready_pkt && awvalid_en;

    always@(posedge s_aclk ) begin
      if(rst_axif_sclk == 1) begin
	     wr_pkt_count <= 0;
      end else begin
	     if(txn_count_up == 1 && txn_count_down == 0) begin
	       wr_pkt_count <= wr_pkt_count + 1;
	     end else if(txn_count_up == 0 && txn_count_down == 1) begin
	       wr_pkt_count <= wr_pkt_count - 1;
	     end
      end
    end //Always end
    assign awvalid_en = (wr_pkt_count > 0)? 1:0;
  end endgenerate 
  
  generate if (PACKET_FIFO == "false") begin : axi_mm_fifo_wr
    assign awvalid_en    = 1;    
    assign wach_dout     = wach_dout_pkt;
    assign m_axi_awvalid = wach_m_axi_awvalid;
  end
  endgenerate



  generate if (IS_WR_DATA_CH == 1) begin : axi_write_data_channel
    // Write protection when almost full or prog_full is high
    assign wdch_we    = wdch_s_axi_wready & s_axi_wvalid ;

    // Read protection when almost empty or prog_empty is high
    assign wdch_re    = wdch_m_axi_wvalid & m_axi_wready ;
    assign wdch_wr_en = wdch_we;
    assign wdch_rd_en = wdch_re;

xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK ),
        .RELATED_CLOCKS             (0      ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_WDCH),
        .ECC_MODE                   (P_ECC_MODE_WDCH),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_WDCH),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_WDCH_ECC),
        .WR_DATA_COUNT_WIDTH        (WR_DATA_COUNT_WIDTH_WDCH),
        .PROG_FULL_THRESH           (PROG_FULL_THRESH_WDCH),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           (USE_ADV_FEATURES_WDCH_INT),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_WDCH_ECC),
        .RD_DATA_COUNT_WIDTH        (RD_DATA_COUNT_WIDTH_WDCH),
        .PROG_EMPTY_THRESH          (PROG_EMPTY_THRESH_WDCH),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_wdch_dut (
        .sleep            (1'b0),
        .rst              (rst_axif_sclk),
        .wr_clk           (s_aclk),
        .wr_en            (wdch_wr_en),
        .din              (wdch_din),
        .full             (wdch_full),
        .full_n           (),
        .prog_full        (prog_full_wdch),
        .wr_data_count    (wr_data_count_wdch),
        .overflow         (axi_w_overflow_i),
        .wr_rst_busy      (wr_rst_busy_wdch),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (m_aclk_int),
        .rd_en            (wdch_rd_en),
        .dout             (wdch_dout),
        .empty            (wdch_empty),
        .prog_empty       (prog_empty_wdch),
        .rd_data_count    (rd_data_count_wdch),
        .underflow        (axi_w_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (injectsbiterr_wdch),
        .injectdbiterr    (injectdbiterr_wdch),
        .sbiterr          (sbiterr_wdch),
        .dbiterr          (dbiterr_wdch)
      );


    assign wdch_s_axi_wready     = (FIFO_MEMORY_TYPE_WDCH == "lutram") ? ~(wdch_full | wr_rst_busy_wdch) : ~wdch_full;
    assign wdch_m_axi_wvalid = ~wdch_empty;
    assign s_axi_wready      = wdch_s_axi_wready;
    assign m_axi_wvalid      = wdch_m_axi_wvalid;


  end endgenerate // axi_write_data_channel


  generate if (IS_WR_RESP_CH == 1) begin : axi_write_resp_channel

xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK      ),
        .RELATED_CLOCKS             (0                   ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_WRCH),
        .ECC_MODE                   (0),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_WRCH     ),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_WRCH),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           ("0101"),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_WRCH),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_wrch_dut (
        .sleep            (1'b0),
        .rst              (rst_axif_mclk),
        .wr_clk           (m_aclk_int),
        .wr_en            (m_axi_bvalid),
        .din              (wrch_din),
        .full             (wrch_full),
        .full_n           (),
        .prog_full        (),
        .wr_data_count    (),
        .overflow         (axi_b_overflow_i),
        .wr_rst_busy      (wr_rst_busy_wrch),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (s_aclk),
        .rd_en            (s_axi_bready),
        .dout             (wrch_dout),
        .empty            (wrch_empty),
        .prog_empty       (),
        .rd_data_count    (),
        .underflow        (axi_b_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (1'b0),
        .injectdbiterr    (1'b0),
        .sbiterr          (),
        .dbiterr          ()
      );

    assign wrch_s_axi_bvalid = ~wrch_empty;
    assign wrch_m_axi_bready     = (FIFO_MEMORY_TYPE_WRCH == "lutram") ? ~(wrch_full | wr_rst_busy_wrch) : ~wrch_full;
    assign s_axi_bvalid      = wrch_s_axi_bvalid;
    assign m_axi_bready      = wrch_m_axi_bready;

  end endgenerate // axi_write_resp_channel




  generate if (IS_AXI_FULL_WACH == 1 || (C_WACH_TYPE == 1)) begin : axi_wach_output
    assign m_axi_awaddr    = wach_dout[AWID_OFFSET-1:AWADDR_OFFSET];    
    assign m_axi_awlen     = wach_dout[AWADDR_OFFSET-1:AWLEN_OFFSET];    
    assign m_axi_awsize    = wach_dout[AWLEN_OFFSET-1:AWSIZE_OFFSET];    
    assign m_axi_awburst   = wach_dout[AWSIZE_OFFSET-1:AWBURST_OFFSET];    
    assign m_axi_awlock    = wach_dout[AWBURST_OFFSET-1:AWLOCK_OFFSET];    
    assign m_axi_awcache   = wach_dout[AWLOCK_OFFSET-1:AWCACHE_OFFSET];    
    assign m_axi_awprot    = wach_dout[AWCACHE_OFFSET-1:AWPROT_OFFSET];    
    assign m_axi_awqos     = wach_dout[AWPROT_OFFSET-1:AWQOS_OFFSET];    
    assign wach_din[AWID_OFFSET-1:AWADDR_OFFSET]    = s_axi_awaddr;
    assign wach_din[AWADDR_OFFSET-1:AWLEN_OFFSET]   = s_axi_awlen;
    assign wach_din[AWLEN_OFFSET-1:AWSIZE_OFFSET]   = s_axi_awsize;
    assign wach_din[AWSIZE_OFFSET-1:AWBURST_OFFSET] = s_axi_awburst;
    assign wach_din[AWBURST_OFFSET-1:AWLOCK_OFFSET] = s_axi_awlock;
    assign wach_din[AWLOCK_OFFSET-1:AWCACHE_OFFSET] = s_axi_awcache;
    assign wach_din[AWCACHE_OFFSET-1:AWPROT_OFFSET] = s_axi_awprot;
    assign wach_din[AWPROT_OFFSET-1:AWQOS_OFFSET]   = s_axi_awqos;
  end endgenerate // axi_wach_output

  generate if ((IS_AXI_FULL_WACH == 1 || (C_WACH_TYPE == 1))) begin : axi_awregion
    assign m_axi_awregion  = wach_dout[AWQOS_OFFSET-1:AWREGION_OFFSET];    
  end endgenerate // axi_awregion

  generate if ((IS_AXI_FULL_WACH == 1 || (C_WACH_TYPE == 1))) begin : axi_awuser
    assign m_axi_awuser  = wach_dout[AWREGION_OFFSET-1:AWUSER_OFFSET];    
  end endgenerate // axi_awuser


  generate if ((IS_AXI_FULL_WACH == 1 || (C_WACH_TYPE == 1))) begin : axi_awid
    assign m_axi_awid      = wach_dout[C_DIN_WIDTH_WACH-1:AWID_OFFSET];
  end endgenerate //axi_awid

  generate if (IS_AXI_FULL_WDCH == 1 || (C_WDCH_TYPE == 1)) begin : axi_wdch_output
    assign m_axi_wdata     = wdch_dout[WID_OFFSET-1:WDATA_OFFSET];
    assign m_axi_wstrb     = wdch_dout[WDATA_OFFSET-1:WSTRB_OFFSET];
    assign m_axi_wlast     = wdch_dout[0];
    assign wdch_din[WID_OFFSET-1:WDATA_OFFSET]   = s_axi_wdata;
    assign wdch_din[WDATA_OFFSET-1:WSTRB_OFFSET] = s_axi_wstrb;
    assign wdch_din[0]   = s_axi_wlast;
  end endgenerate // axi_wdch_output

//  generate if ((IS_AXI_FULL_WDCH == 1 || (C_WDCH_TYPE == 1)) ) begin
//    assign m_axi_wid       = 0;
//  end endgenerate

  generate if ((IS_AXI_FULL_WDCH == 1 || (C_WDCH_TYPE == 1))) begin
    assign m_axi_wuser     = wdch_dout[WSTRB_OFFSET-1:WUSER_OFFSET];    
  end endgenerate

  generate if (IS_AXI_FULL_WRCH == 1 || (C_WRCH_TYPE == 1)) begin : axi_wrch_output
    assign s_axi_bresp = wrch_dout[BID_OFFSET-1:BRESP_OFFSET]; 
    assign wrch_din[BID_OFFSET-1:BRESP_OFFSET]   = m_axi_bresp;
  end endgenerate // axi_wrch_output

  generate if ((IS_AXI_FULL_WRCH == 1 || (C_WRCH_TYPE == 1))) begin : axi_buser
    assign s_axi_buser = wrch_dout[BRESP_OFFSET-1:BUSER_OFFSET];
  end endgenerate // axi_buser

  generate if ((IS_AXI_FULL_WRCH == 1 || ( C_WRCH_TYPE == 1))) begin : axi_bid
    assign s_axi_bid   =  wrch_dout[C_DIN_WIDTH_WRCH-1:BID_OFFSET];
  end endgenerate // axi_bid
  

  generate if ((IS_AXI_FULL_WACH == 1 || ( C_WACH_TYPE == 1))) begin : gwach_din1
    assign wach_din[AWREGION_OFFSET-1:AWUSER_OFFSET]     = s_axi_awuser;
  end endgenerate // gwach_din1

  generate if ((IS_AXI_FULL_WACH == 1 || ( C_WACH_TYPE == 1))) begin : gwach_din2
    assign wach_din[C_DIN_WIDTH_WACH-1:AWID_OFFSET]     = s_axi_awid;
  end endgenerate // gwach_din2

  generate if ((IS_AXI_FULL_WACH == 1 || ( C_WACH_TYPE == 1))) begin : gwach_din3
    assign wach_din[AWQOS_OFFSET-1:AWREGION_OFFSET]     = s_axi_awregion;
  end endgenerate // gwach_din3

  generate if ((IS_AXI_FULL_WDCH == 1 || ( C_WDCH_TYPE == 1))) begin : gwdch_din1
    assign wdch_din[WSTRB_OFFSET-1:WUSER_OFFSET] = s_axi_wuser;
  end endgenerate // gwdch_din1

  generate if ((IS_AXI_FULL_WRCH == 1 || ( C_WRCH_TYPE == 1))) begin : gwrch_din1
    assign wrch_din[BRESP_OFFSET-1:BUSER_OFFSET]    = m_axi_buser;
  end endgenerate // gwrch_din1

  generate if ((IS_AXI_FULL_WRCH == 1 || ( C_WRCH_TYPE == 1))) begin : gwrch_din2
    assign wrch_din[C_DIN_WIDTH_WRCH-1:BID_OFFSET]    = m_axi_bid;
  end endgenerate // gwrch_din2

  //end of  axi_write_channel

  //###########################################################################
  //  AXI FULL Read Channel (axi_read_channel)
  //###########################################################################
  wire [C_DIN_WIDTH_RACH-1:0]        rach_din            ;
  wire [C_DIN_WIDTH_RACH-1:0]        rach_dout           ;
  wire [C_DIN_WIDTH_RACH-1:0]        rach_dout_pkt       ;
  wire                               rach_full           ;
  wire                               rach_almost_full    ;
  wire                               rach_prog_full      ;
  wire                               rach_empty          ;
  wire                               rach_almost_empty   ;
  wire                               rach_prog_empty     ;
  wire [C_DIN_WIDTH_RDCH_ECC-1:0]        rdch_din            ;
  wire [C_DIN_WIDTH_RDCH_ECC-1:0]        rdch_dout           ;
  wire                               rdch_full           ;
  wire                               rdch_almost_full    ;
  wire                               rdch_prog_full      ;
  wire                               rdch_empty          ;
  wire                               rdch_almost_empty   ;
  wire                               rdch_prog_empty     ;
  wire                               axi_ar_underflow_i  ;
  wire                               axi_r_underflow_i   ;
  wire                               axi_ar_overflow_i   ;
  wire                               axi_r_overflow_i    ;
  wire                               rach_s_axi_arready  ;
  wire                               rach_m_axi_arvalid  ;
  wire                               rach_rd_en          ;
  wire                               rdch_m_axi_rready   ;
  wire                               rdch_s_axi_rvalid   ;
  wire                               rdch_wr_en          ;
  wire                               rdch_rd_en          ;
  wire                               arvalid_pkt         ;
  wire                               arready_pkt         ;
  wire                               arvalid_en          ;
  wire                               rdch_rd_ok          ;
  wire                               accept_next_pkt     ;
  integer                            rdch_free_space     ;
  integer                            rdch_commited_space ;
  wire                               rach_re             ;
  wire                               rdch_we             ;
  wire                               rdch_re             ;

  localparam ARID_OFFSET       = C_DIN_WIDTH_RACH - AXI_ID_WIDTH ;
  localparam ARADDR_OFFSET     = ARID_OFFSET - AXI_ADDR_WIDTH;
  localparam ARLEN_OFFSET      = ARADDR_OFFSET - AXI_LEN_WIDTH ;
  localparam ARSIZE_OFFSET     = ARLEN_OFFSET - C_AXI_SIZE_WIDTH ;
  localparam ARBURST_OFFSET    = ARSIZE_OFFSET - C_AXI_BURST_WIDTH ;
  localparam ARLOCK_OFFSET     = ARBURST_OFFSET - C_AXI_LOCK_WIDTH ;
  localparam ARCACHE_OFFSET    = ARLOCK_OFFSET - C_AXI_CACHE_WIDTH ;
  localparam ARPROT_OFFSET     = ARCACHE_OFFSET - C_AXI_PROT_WIDTH;
  localparam ARQOS_OFFSET      = ARPROT_OFFSET - C_AXI_QOS_WIDTH;
  localparam ARREGION_OFFSET   = ARQOS_OFFSET - C_AXI_REGION_WIDTH ;
  localparam ARUSER_OFFSET     = ARREGION_OFFSET-AXI_ARUSER_WIDTH;

  localparam RID_OFFSET        = C_DIN_WIDTH_RDCH - AXI_ID_WIDTH ;
  localparam RDATA_OFFSET      = RID_OFFSET - AXI_DATA_WIDTH;
  localparam RRESP_OFFSET      = RDATA_OFFSET - C_AXI_RRESP_WIDTH;
  localparam RUSER_OFFSET      = RRESP_OFFSET-AXI_RUSER_WIDTH;

  generate begin : xpm_fifo_rd_chnl
  if (IS_RD_ADDR_CH == 1) begin : axi_read_addr_channel

    // Write protection when almost full or prog_full is high

    // Read protection when almost empty or prog_empty is high
    assign rach_re    = (PACKET_FIFO == "true") ? arready_pkt & arvalid_en : m_axi_arready;
    assign rach_rd_en = rach_re;


xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK      ),
        .RELATED_CLOCKS             (0                   ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_RACH),
        .ECC_MODE                   (0),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_RACH     ),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_RACH),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           ("0101"),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_RACH),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_rach_dut (
        .sleep            (1'b0),
        .rst              (rst_axif_sclk),
        .wr_clk           (s_aclk),
        .wr_en            (s_axi_arvalid),
        .din              (rach_din),
        .full             (rach_full),
        .full_n           (),
        .prog_full        (),
        .wr_data_count    (),
        .overflow         (axi_ar_overflow_i),
        .wr_rst_busy      (wr_rst_busy_rach),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (m_aclk_int),
        .rd_en            (rach_rd_en),
        .dout             (rach_dout_pkt),
        .empty            (rach_empty),
        .prog_empty       (),
        .rd_data_count    (),
        .underflow        (axi_ar_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (1'b0),
        .injectdbiterr    (1'b0),
        .sbiterr          (),
        .dbiterr          ()
      );


    assign rach_s_axi_arready    = (FIFO_MEMORY_TYPE_RACH == "lutram") ? ~(rach_full | wr_rst_busy_rach) : ~rach_full;
    assign rach_m_axi_arvalid = ~rach_empty;
    assign s_axi_arready      = rach_s_axi_arready;


  end : axi_read_addr_channel


  // Register Slice for Read Address Channel for MM Packet FIFO
  if (C_RACH_TYPE == 0 && (PACKET_FIFO == "true")) begin : grach_reg_slice_mm_pkt_fifo

    xpm_fifo_axi_reg_slice
          #(
            .C_DATA_WIDTH            (C_DIN_WIDTH_RACH),
            .C_REG_CONFIG            (1)
            )
    reg_slice_mm_pkt_fifo_inst
        (
          // System Signals
          .ACLK                      (s_aclk),
          .ARESET                    (rst_axif_sclk),

          // Slave side
          .S_PAYLOAD_DATA            (rach_dout_pkt),
          .S_VALID                   (arvalid_pkt),
          .S_READY                   (arready_pkt),

          // Master side
          .M_PAYLOAD_DATA            (rach_dout),
          .M_VALID                   (m_axi_arvalid),
          .M_READY                   (m_axi_arready)
          );
  end : grach_reg_slice_mm_pkt_fifo 

  
  if (C_RACH_TYPE == 0 && (PACKET_FIFO == "false")) begin : grach_m_axi_arvalid
    assign m_axi_arvalid      = rach_m_axi_arvalid;
    assign rach_dout          = rach_dout_pkt;
  end : grach_m_axi_arvalid
  
  
  if (PACKET_FIFO == "true") begin : axi_mm_pkt_fifo_rd
    assign rdch_rd_ok = rdch_s_axi_rvalid && rdch_rd_en;
    assign arvalid_pkt = rach_m_axi_arvalid && arvalid_en;
    assign accept_next_pkt  = rach_m_axi_arvalid && arready_pkt && arvalid_en;

    always@(posedge s_aclk ) begin
      if(rst_axif_sclk) begin
	     rdch_commited_space <= 0;
      end else begin
	     if(rdch_rd_ok && !accept_next_pkt) begin
	       rdch_commited_space <= rdch_commited_space-1;
	     end else if(!rdch_rd_ok && accept_next_pkt) begin
	       rdch_commited_space <= rdch_commited_space+(rach_dout_pkt[ARADDR_OFFSET-1:ARLEN_OFFSET]+1);
	     end else if(rdch_rd_ok && accept_next_pkt) begin
	       rdch_commited_space <= rdch_commited_space+(rach_dout_pkt[ARADDR_OFFSET-1:ARLEN_OFFSET]);
	     end
      end
    end //Always end

    always@(*) begin
      rdch_free_space <= (FIFO_DEPTH_RDCH -(rdch_commited_space+rach_dout_pkt[ARADDR_OFFSET-1:ARLEN_OFFSET]+1));
    end

    assign arvalid_en = (rdch_free_space >= 0)? 1:0;
  end : axi_mm_pkt_fifo_rd 
  
  if (PACKET_FIFO == "false") begin : axi_mm_fifo_rd
    assign arvalid_en = 1;    
  end :axi_mm_fifo_rd 

  if (IS_RD_DATA_CH == 1) begin : axi_read_data_channel

    // Write protection when almost full or prog_full is high
    assign rdch_we    = rdch_m_axi_rready  & m_axi_rvalid ;

    // Read protection when almost empty or prog_empty is high
    assign rdch_re    = rdch_s_axi_rvalid  & s_axi_rready;
    assign rdch_wr_en = rdch_we;
    assign rdch_rd_en = rdch_re;


xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK      ),
        .RELATED_CLOCKS             (0                   ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_RDCH),
        .ECC_MODE                   (P_ECC_MODE_RDCH     ),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_RDCH     ),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_RDCH_ECC),
        .WR_DATA_COUNT_WIDTH        (WR_DATA_COUNT_WIDTH_RDCH),
        .PROG_FULL_THRESH           (PROG_FULL_THRESH_RDCH ),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           (USE_ADV_FEATURES_RDCH_INT),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_RDCH_ECC),
        .RD_DATA_COUNT_WIDTH        (RD_DATA_COUNT_WIDTH_RDCH),
        .PROG_EMPTY_THRESH          (PROG_EMPTY_THRESH_RDCH),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_rdch_dut (
        .sleep            (1'b0),
        .rst              (rst_axif_mclk),
        .wr_clk           (m_aclk_int),
        .wr_en            (rdch_wr_en),
        .din              (rdch_din),
        .full             (rdch_full),
        .full_n           (),
        .prog_full        (prog_full_rdch),
        .wr_data_count    (wr_data_count_rdch),
        .overflow         (axi_r_overflow_i),
        .wr_rst_busy      (wr_rst_busy_rdch),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (s_aclk),
        .rd_en            (rdch_rd_en),
        .dout             (rdch_dout),
        .empty            (rdch_empty),
        .prog_empty       (prog_empty_rdch),
        .rd_data_count    (rd_data_count_rdch),
        .underflow        (axi_r_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (injectsbiterr_rdch),
        .injectdbiterr    (injectdbiterr_rdch),
        .sbiterr          (sbiterr_rdch),
        .dbiterr          (dbiterr_rdch)
      );

    assign rdch_s_axi_rvalid = ~rdch_empty;
    assign rdch_m_axi_rready     = (FIFO_MEMORY_TYPE_RDCH == "lutram") ? ~(rdch_full | wr_rst_busy_rdch) : ~rdch_full;
    assign s_axi_rvalid      = rdch_s_axi_rvalid;
    assign m_axi_rready      = rdch_m_axi_rready;

  end :axi_read_data_channel





  if (IS_AXI_FULL_RACH == 1 || ( C_RACH_TYPE == 1)) begin : axi_full_rach_output
    assign m_axi_araddr    = rach_dout[ARID_OFFSET-1:ARADDR_OFFSET];    
    assign m_axi_arlen     = rach_dout[ARADDR_OFFSET-1:ARLEN_OFFSET];    
    assign m_axi_arsize    = rach_dout[ARLEN_OFFSET-1:ARSIZE_OFFSET];    
    assign m_axi_arburst   = rach_dout[ARSIZE_OFFSET-1:ARBURST_OFFSET];    
    assign m_axi_arlock    = rach_dout[ARBURST_OFFSET-1:ARLOCK_OFFSET];    
    assign m_axi_arcache   = rach_dout[ARLOCK_OFFSET-1:ARCACHE_OFFSET];    
    assign m_axi_arprot    = rach_dout[ARCACHE_OFFSET-1:ARPROT_OFFSET];    
    assign m_axi_arqos     = rach_dout[ARPROT_OFFSET-1:ARQOS_OFFSET];    
    assign rach_din[ARID_OFFSET-1:ARADDR_OFFSET]    = s_axi_araddr;
    assign rach_din[ARADDR_OFFSET-1:ARLEN_OFFSET]   = s_axi_arlen;
    assign rach_din[ARLEN_OFFSET-1:ARSIZE_OFFSET]   = s_axi_arsize;
    assign rach_din[ARSIZE_OFFSET-1:ARBURST_OFFSET] = s_axi_arburst;
    assign rach_din[ARBURST_OFFSET-1:ARLOCK_OFFSET] = s_axi_arlock;
    assign rach_din[ARLOCK_OFFSET-1:ARCACHE_OFFSET] = s_axi_arcache;
    assign rach_din[ARCACHE_OFFSET-1:ARPROT_OFFSET] = s_axi_arprot;
    assign rach_din[ARPROT_OFFSET-1:ARQOS_OFFSET]   = s_axi_arqos;
  end : axi_full_rach_output

  if ((IS_AXI_FULL_RACH == 1 || ( C_RACH_TYPE == 1))) begin : axi_arregion
    assign m_axi_arregion  = rach_dout[ARQOS_OFFSET-1:ARREGION_OFFSET];    
  end : axi_arregion

  if ((IS_AXI_FULL_RACH == 1 || ( C_RACH_TYPE == 1))) begin : axi_aruser
    assign m_axi_aruser = rach_dout[ARREGION_OFFSET-1:ARUSER_OFFSET];    
  end : axi_aruser

  if ((IS_AXI_FULL_RACH == 1 || ( C_RACH_TYPE == 1))) begin : axi_arid
    assign m_axi_arid      = rach_dout[C_DIN_WIDTH_RACH-1:ARID_OFFSET];
  end : axi_arid

  if (IS_AXI_FULL_RDCH == 1 || ( C_RDCH_TYPE == 1)) begin : axi_full_rdch_output
    assign s_axi_rdata     = rdch_dout[RID_OFFSET-1:RDATA_OFFSET];
    assign s_axi_rresp     = rdch_dout[RDATA_OFFSET-1:RRESP_OFFSET];
    assign s_axi_rlast     = rdch_dout[0];
    assign rdch_din[RID_OFFSET-1:RDATA_OFFSET]   = m_axi_rdata;
    assign rdch_din[RDATA_OFFSET-1:RRESP_OFFSET] = m_axi_rresp;
    assign rdch_din[0] = m_axi_rlast;
  end : axi_full_rdch_output
  
  if ((IS_AXI_FULL_RDCH == 1 || ( C_RDCH_TYPE == 1))) begin : axi_full_ruser_output
    assign s_axi_ruser     = rdch_dout[RRESP_OFFSET-1:RUSER_OFFSET];
  end : axi_full_ruser_output

  if ((IS_AXI_FULL_RDCH == 1 || ( C_RDCH_TYPE == 1))) begin : axi_rid
    assign s_axi_rid       = rdch_dout[C_DIN_WIDTH_RDCH-1:RID_OFFSET];
  end : axi_rid


  if ((IS_AXI_FULL_RACH == 1 || ( C_RACH_TYPE == 1))) begin : grach_din1
    assign rach_din[ARREGION_OFFSET-1:ARUSER_OFFSET]     = s_axi_aruser;
  end : grach_din1

  if ((IS_AXI_FULL_RACH == 1 || ( C_RACH_TYPE == 1))) begin : grach_din2
    assign rach_din[C_DIN_WIDTH_RACH-1:ARID_OFFSET]     = s_axi_arid;
  end : grach_din2

  if ((IS_AXI_FULL_RACH == 1 || ( C_RACH_TYPE == 1))) begin
    assign rach_din[ARQOS_OFFSET-1:ARREGION_OFFSET] = s_axi_arregion;
  end 

  if ((IS_AXI_FULL_RDCH == 1 || ( C_RDCH_TYPE == 1))) begin : grdch_din1
    assign rdch_din[RRESP_OFFSET-1:RUSER_OFFSET]     = m_axi_ruser;
  end : grdch_din1

  if ((IS_AXI_FULL_RDCH == 1 || ( C_RDCH_TYPE == 1))) begin : grdch_din2
    assign rdch_din[C_DIN_WIDTH_RDCH-1:RID_OFFSET] = m_axi_rid;
  end : grdch_din2

  //end of axi_read_channel

  
  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  // Pass Through Logic or Wiring Logic
  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------
  // Pass Through Logic for Read Channel
  //-------------------------------------------------------------------------

  // Wiring logic for Write Address Channel
  if (C_WACH_TYPE == 2) begin : gwach_pass_through
    assign m_axi_awid      = s_axi_awid;
    assign m_axi_awaddr    = s_axi_awaddr;
    assign m_axi_awlen     = s_axi_awlen;
    assign m_axi_awsize    = s_axi_awsize;
    assign m_axi_awburst   = s_axi_awburst;
    assign m_axi_awlock    = s_axi_awlock;
    assign m_axi_awcache   = s_axi_awcache;
    assign m_axi_awprot    = s_axi_awprot;
    assign m_axi_awqos     = s_axi_awqos;
    assign m_axi_awregion  = s_axi_awregion;
    assign m_axi_awuser    = s_axi_awuser;
    assign s_axi_awready   = m_axi_awready;
    assign m_axi_awvalid   = s_axi_awvalid;
  end //: gwach_pass_through;

  // Wiring logic for Write Data Channel
  if (C_WDCH_TYPE == 2) begin : gwdch_pass_through
//    assign m_axi_wid       = s_axi_wid;
    assign m_axi_wdata     = s_axi_wdata;
    assign m_axi_wstrb     = s_axi_wstrb;
    assign m_axi_wlast     = s_axi_wlast;
    assign m_axi_wuser     = s_axi_wuser;
    assign s_axi_wready    = m_axi_wready;
    assign m_axi_wvalid    = s_axi_wvalid;
  end //: gwdch_pass_through;

  // Wiring logic for Write Response Channel
  if (C_WRCH_TYPE == 2) begin : gwrch_pass_through
    assign s_axi_bid       = m_axi_bid;
    assign s_axi_bresp     = m_axi_bresp;
    assign s_axi_buser     = m_axi_buser;
    assign m_axi_bready    = s_axi_bready;
    assign s_axi_bvalid    = m_axi_bvalid;
  end //: gwrch_pass_through;

  //-------------------------------------------------------------------------
  // Pass Through Logic for Read Channel
  //-------------------------------------------------------------------------

  // Wiring logic for Read Address Channel
  if (C_RACH_TYPE == 2) begin : grach_pass_through
    assign m_axi_arid      = s_axi_arid;
    assign m_axi_araddr    = s_axi_araddr;
    assign m_axi_arlen     = s_axi_arlen;
    assign m_axi_arsize    = s_axi_arsize;
    assign m_axi_arburst   = s_axi_arburst;
    assign m_axi_arlock    = s_axi_arlock;
    assign m_axi_arcache   = s_axi_arcache;
    assign m_axi_arprot    = s_axi_arprot;
    assign m_axi_arqos     = s_axi_arqos;
    assign m_axi_arregion  = s_axi_arregion;
    assign m_axi_aruser    = s_axi_aruser;
    assign s_axi_arready   = m_axi_arready;
    assign m_axi_arvalid   = s_axi_arvalid;
  end //: grach_pass_through;

  // Wiring logic for Read Data Channel 
  if (C_RDCH_TYPE == 2) begin : grdch_pass_through
    assign s_axi_rid      = m_axi_rid;
    assign s_axi_rlast    = m_axi_rlast;
    assign s_axi_ruser    = m_axi_ruser;
    assign s_axi_rdata    = m_axi_rdata;
    assign s_axi_rresp    = m_axi_rresp;
    assign s_axi_rvalid   = m_axi_rvalid;
    assign m_axi_rready   = s_axi_rready;
  end //: grdch_pass_through;

end : xpm_fifo_rd_chnl
endgenerate


endmodule //xpm_fifo_axif


/*******************************************************************************
 * Declaration of top-level module
 ******************************************************************************/
(* XPM_MODULE = "TRUE",  KEEP_HIERARCHY = "SOFT" *)
module xpm_fifo_axil
  #(
    //-----------------------------------------------------------------------
    // Generic Declarations
    //-----------------------------------------------------------------------
  parameter integer  AXI_ADDR_WIDTH          = 32,
  parameter integer  AXI_DATA_WIDTH          = 32,
  parameter          CLOCKING_MODE             = "common",
  parameter integer  SIM_ASSERT_CHK            = 0,
  parameter integer  CASCADE_HEIGHT            = 0,
  parameter integer  CDC_SYNC_STAGES           = 2,
  parameter integer  EN_RESET_SYNCHRONIZER     = 0,
  parameter          FIFO_MEMORY_TYPE_WACH     = "lutram",
  parameter          FIFO_MEMORY_TYPE_WDCH     = "bram",
  parameter          FIFO_MEMORY_TYPE_WRCH     = "lutram",
  parameter          FIFO_MEMORY_TYPE_RACH     = "lutram",
  parameter          FIFO_MEMORY_TYPE_RDCH     = "bram",
  parameter integer  FIFO_DEPTH_WACH           = 16,
  parameter integer  FIFO_DEPTH_WDCH           = 16,
  parameter integer  FIFO_DEPTH_WRCH           = 2048,
  parameter integer  FIFO_DEPTH_RACH           = 16,
  parameter integer  FIFO_DEPTH_RDCH           = 2048,
  parameter          ECC_MODE_WDCH             = "no_ecc",
  parameter          ECC_MODE_RDCH             = "no_ecc",
  parameter          USE_ADV_FEATURES_WDCH     = "1000",
  parameter          USE_ADV_FEATURES_RDCH     = "1000",
  parameter integer  WR_DATA_COUNT_WIDTH_WDCH  = 10,
  parameter integer  WR_DATA_COUNT_WIDTH_RDCH  = 10,
  parameter integer  RD_DATA_COUNT_WIDTH_WDCH  = 10,
  parameter integer  RD_DATA_COUNT_WIDTH_RDCH  = 10,
  parameter integer  PROG_FULL_THRESH_WDCH     = 10,
  parameter integer  PROG_FULL_THRESH_RDCH     = 10,
  parameter integer  PROG_EMPTY_THRESH_WDCH    = 10,
  parameter integer  PROG_EMPTY_THRESH_RDCH    = 10


    )

   (
    // AXI Global Signal
    input wire                               m_aclk,
    input wire                               s_aclk,
    input wire                               s_aresetn,

    // AXI Full/Lite Slave Write Channel (write side)
    input wire [AXI_ADDR_WIDTH-1:0]        s_axi_awaddr,
    input wire [3-1:0]                       s_axi_awprot,
    input wire                               s_axi_awvalid,
    output wire                              s_axi_awready,
    input wire [AXI_DATA_WIDTH-1:0]        s_axi_wdata,
    input wire [AXI_DATA_WIDTH/8-1:0]      s_axi_wstrb,
    input wire                               s_axi_wvalid,
    output wire                              s_axi_wready,
    output wire  [2-1:0]                     s_axi_bresp,
    output wire                              s_axi_bvalid,
    input wire                               s_axi_bready,

    // AXI Full/Lite Master Write Channel (read side)
    output wire [AXI_ADDR_WIDTH-1:0]       m_axi_awaddr,
    output wire [3-1:0]                      m_axi_awprot,
    output wire                              m_axi_awvalid,
    input  wire                              m_axi_awready,
    output wire [AXI_DATA_WIDTH-1:0]       m_axi_wdata,
    output wire [AXI_DATA_WIDTH/8-1:0]     m_axi_wstrb,
    output wire                              m_axi_wvalid,
    input  wire                              m_axi_wready,
    input wire [2-1:0]                       m_axi_bresp,
    input wire                               m_axi_bvalid,
    output wire                              m_axi_bready,

    // AXI Full/Lite Slave Read Channel (write side)
    input wire [AXI_ADDR_WIDTH-1:0]        s_axi_araddr, 
    input wire [3-1:0]                       s_axi_arprot,
    input wire                               s_axi_arvalid,
    output wire                              s_axi_arready,
    output wire  [AXI_DATA_WIDTH-1:0]      s_axi_rdata, 
    output wire  [2-1:0]                     s_axi_rresp,
    output wire                              s_axi_rvalid,
    input wire                               s_axi_rready,

    // AXI Full/Lite Master Read Channel (read side)
    output wire [AXI_ADDR_WIDTH-1:0]       m_axi_araddr,  
    output wire [3-1:0]                      m_axi_arprot,
    output wire                              m_axi_arvalid,
    input  wire                              m_axi_arready,
    input wire [AXI_DATA_WIDTH-1:0]        m_axi_rdata,  
    input wire [2-1:0]                       m_axi_rresp,
    input wire                               m_axi_rvalid,
    output wire                              m_axi_rready,

    // AXI4-Full Sideband Signals
    output wire                           prog_full_wdch,
    output wire                           prog_empty_wdch,
    output wire [WR_DATA_COUNT_WIDTH_WDCH-1:0] wr_data_count_wdch,
    output wire [RD_DATA_COUNT_WIDTH_WDCH-1:0] rd_data_count_wdch,
    output wire                           prog_full_rdch,
    output wire                           prog_empty_rdch,
    output wire [WR_DATA_COUNT_WIDTH_RDCH-1:0] wr_data_count_rdch,
    output wire [RD_DATA_COUNT_WIDTH_RDCH-1:0] rd_data_count_rdch,
  
    // ECC Related ports
    input  wire                           injectsbiterr_wdch,
    input  wire                           injectdbiterr_wdch,
    output wire                           sbiterr_wdch,
    output wire                           dbiterr_wdch,
    input  wire                           injectsbiterr_rdch,
    input  wire                           injectdbiterr_rdch,
    output wire                           sbiterr_rdch,
    output wire                           dbiterr_rdch

    );



  // Function to convert ASCII value to binary 
  function [3:0] str2bin;
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
            str2bin = str_val_ascii[3:0];
         else begin
           str2bin [3] = 1'b1;
           str2bin [2] = str_val_ascii[2] | (str_val_ascii[1] & str_val_ascii[0]);
           str2bin [1] = str_val_ascii[0] ^ str_val_ascii[1];
           str2bin [0] = !str_val_ascii[0];
         end
      end
      else
        $error("Found Invalid character while parsing the string, please cross check the value specified for either READ_RESET_VALUE_A|B or MEMORY_INIT_PARAM (if initialization of memory through parameter is used). XPM_MEMORY supports strings (hex) that contains characters 0-9, A-F and a-f.");
  endfunction
  // Function that parses the complete reset value string
  function logic [15:0] hstr2bin;
    input [16*8-1 : 0] hstr_val;
    integer rst_loop_a;
    localparam integer  rsta_loop_iter  =  16;
    logic [rsta_loop_iter-1 : 0] rst_val_conv_a_i;
    for (rst_loop_a=1; rst_loop_a <= rsta_loop_iter/4; rst_loop_a = rst_loop_a+1) begin
      rst_val_conv_a_i[(rst_loop_a*4)-1 -: 4] =  str2bin(hstr_val[(rst_loop_a*8)-1 -: 8]);
    end
    return rst_val_conv_a_i[15:0];
  endfunction

//Function to convert binary to ASCII value
  function [7:0] bin2str;
    input [3:0] bin_val;
      if( bin_val > 4'h9) begin
           bin2str [7:4] = 4'h4;
           bin2str [3]   = 1'b0;
           bin2str [2:0] = bin_val[2:0]-1'b1;
           end
         else begin
           bin2str [7:4] = 4'h3;
           bin2str [3:0] = bin_val;
         end
  endfunction

  // Function that parses the complete binary value to string
  function [31:0] bin2hstr;
    input [15 : 0] bin_val;
    integer str_pos;
    localparam integer  str_max_bits  =  32;
    for (str_pos=1; str_pos <= str_max_bits/8; str_pos = str_pos+1) begin
      bin2hstr[(str_pos*8)-1 -: 8] =  bin2str(bin_val[(str_pos*4)-1 -: 4]);
    end
  endfunction

//WDCH advanced features parameter conversion
  localparam [15:0] EN_ADV_FEATURE_WDCH       = hstr2bin(USE_ADV_FEATURES_WDCH);
  localparam        EN_DATA_VALID_INT         = 1'b1;
  localparam [15:0] EN_ADV_FEATURE_WDCH_INT   = {EN_ADV_FEATURE_WDCH[15:13], EN_DATA_VALID_INT, EN_ADV_FEATURE_WDCH[11:0]};
  localparam        USE_ADV_FEATURES_WDCH_INT = bin2hstr(EN_ADV_FEATURE_WDCH_INT);


//RDCH advanced features parameter conversion
  localparam [15:0] EN_ADV_FEATURE_RDCH       = hstr2bin(USE_ADV_FEATURES_RDCH);
  localparam [15:0] EN_ADV_FEATURE_RDCH_INT   = {EN_ADV_FEATURE_RDCH[15:13], EN_DATA_VALID_INT, EN_ADV_FEATURE_RDCH[11:0]};
  localparam        USE_ADV_FEATURES_RDCH_INT = bin2hstr(EN_ADV_FEATURE_RDCH_INT);


    localparam C_WACH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logic
    localparam C_WDCH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logie
    localparam C_WRCH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logie
    localparam C_RACH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logie
    localparam C_RDCH_TYPE                    = 0; // 0 = FIFO, 1 = Register Slice, 2 = Pass Through Logie

    // Input Data Width
    // Accumulation of all AXI input signal's width
    localparam C_DIN_WIDTH_WACH               = AXI_ADDR_WIDTH+3;
    localparam C_DIN_WIDTH_WDCH               = AXI_DATA_WIDTH/8+AXI_DATA_WIDTH;
    localparam C_DIN_WIDTH_WRCH               = 2;
    localparam C_DIN_WIDTH_RACH               = AXI_ADDR_WIDTH+3;
    localparam C_DIN_WIDTH_RDCH               = AXI_DATA_WIDTH+2;


  // Define local parameters for mapping with base file
  localparam integer P_COMMON_CLOCK          = ( (CLOCKING_MODE == "common_clock"      || CLOCKING_MODE == "COMMON_CLOCK"      || CLOCKING_MODE == "COMMON" || CLOCKING_MODE == "common") ? 1 :
                                               ( (CLOCKING_MODE == "independent_clock" || CLOCKING_MODE == "INDEPENDENT_CLOCK" || CLOCKING_MODE == "INDEPENDENT" || CLOCKING_MODE == "independent") ? 0 : 2));

  localparam integer P_ECC_MODE_WDCH         = ( (ECC_MODE_WDCH == "no_ecc" || ECC_MODE_WDCH == "NO_ECC" ) ? 0 : 1);
  localparam integer P_ECC_MODE_RDCH         = ( (ECC_MODE_RDCH == "no_ecc" || ECC_MODE_RDCH == "NO_ECC" ) ? 0 : 1);
  localparam integer P_FIFO_MEMORY_TYPE_WACH = ( (FIFO_MEMORY_TYPE_WACH == "lutram"   || FIFO_MEMORY_TYPE_WACH == "LUTRAM"   || FIFO_MEMORY_TYPE_WACH == "distributed"   || FIFO_MEMORY_TYPE_WACH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_WACH == "blockram" || FIFO_MEMORY_TYPE_WACH == "BLOCKRAM" || FIFO_MEMORY_TYPE_WACH == "bram" || FIFO_MEMORY_TYPE_WACH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_WACH == "ultraram" || FIFO_MEMORY_TYPE_WACH == "ULTRARAM" || FIFO_MEMORY_TYPE_WACH == "uram" || FIFO_MEMORY_TYPE_WACH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_WACH == "builtin"  || FIFO_MEMORY_TYPE_WACH == "BUILTIN") ? 4 : 0))));
  localparam integer P_FIFO_MEMORY_TYPE_WDCH = ( (FIFO_MEMORY_TYPE_WDCH == "lutram"   || FIFO_MEMORY_TYPE_WDCH == "LUTRAM"   || FIFO_MEMORY_TYPE_WDCH == "distributed"   || FIFO_MEMORY_TYPE_WDCH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_WDCH == "blockram" || FIFO_MEMORY_TYPE_WDCH == "BLOCKRAM" || FIFO_MEMORY_TYPE_WDCH == "bram" || FIFO_MEMORY_TYPE_WDCH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_WDCH == "ultraram" || FIFO_MEMORY_TYPE_WDCH == "ULTRARAM" || FIFO_MEMORY_TYPE_WDCH == "uram" || FIFO_MEMORY_TYPE_WDCH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_WDCH == "builtin"  || FIFO_MEMORY_TYPE_WDCH == "BUILTIN") ? 4 : 0))));
  localparam integer P_FIFO_MEMORY_TYPE_WRCH = ( (FIFO_MEMORY_TYPE_WRCH == "lutram"   || FIFO_MEMORY_TYPE_WRCH == "LUTRAM"   || FIFO_MEMORY_TYPE_WRCH == "distributed"   || FIFO_MEMORY_TYPE_WRCH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_WRCH == "blockram" || FIFO_MEMORY_TYPE_WRCH == "BLOCKRAM" || FIFO_MEMORY_TYPE_WRCH == "bram" || FIFO_MEMORY_TYPE_WRCH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_WRCH == "ultraram" || FIFO_MEMORY_TYPE_WRCH == "ULTRARAM" || FIFO_MEMORY_TYPE_WRCH == "uram" || FIFO_MEMORY_TYPE_WRCH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_WRCH == "builtin"  || FIFO_MEMORY_TYPE_WRCH == "BUILTIN") ? 4 : 0))));
  localparam integer P_FIFO_MEMORY_TYPE_RACH = ( (FIFO_MEMORY_TYPE_RACH == "lutram"   || FIFO_MEMORY_TYPE_RACH == "LUTRAM"   || FIFO_MEMORY_TYPE_RACH == "distributed"   || FIFO_MEMORY_TYPE_RACH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_RACH == "blockram" || FIFO_MEMORY_TYPE_RACH == "BLOCKRAM" || FIFO_MEMORY_TYPE_RACH == "bram" || FIFO_MEMORY_TYPE_RACH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_RACH == "ultraram" || FIFO_MEMORY_TYPE_RACH == "ULTRARAM" || FIFO_MEMORY_TYPE_RACH == "uram" || FIFO_MEMORY_TYPE_RACH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_RACH == "builtin"  || FIFO_MEMORY_TYPE_RACH == "BUILTIN") ? 4 : 0))));
  localparam integer P_FIFO_MEMORY_TYPE_RDCH = ( (FIFO_MEMORY_TYPE_RDCH == "lutram"   || FIFO_MEMORY_TYPE_RDCH == "LUTRAM"   || FIFO_MEMORY_TYPE_RDCH == "distributed"   || FIFO_MEMORY_TYPE_RDCH == "DISTRIBUTED") ? 1 :
                                               ( (FIFO_MEMORY_TYPE_RDCH == "blockram" || FIFO_MEMORY_TYPE_RDCH == "BLOCKRAM" || FIFO_MEMORY_TYPE_RDCH == "bram" || FIFO_MEMORY_TYPE_RDCH == "BRAM") ? 2 :
                                               ( (FIFO_MEMORY_TYPE_RDCH == "ultraram" || FIFO_MEMORY_TYPE_RDCH == "ULTRARAM" || FIFO_MEMORY_TYPE_RDCH == "uram" || FIFO_MEMORY_TYPE_RDCH == "URAM") ? 3 :
                                               ( (FIFO_MEMORY_TYPE_RDCH == "builtin"  || FIFO_MEMORY_TYPE_RDCH == "BUILTIN") ? 4 : 0))));

    localparam C_DIN_WIDTH_WDCH_ECC           = (P_ECC_MODE_WDCH == 0) ? C_DIN_WIDTH_WDCH : ((C_DIN_WIDTH_WDCH%64 == 0) ? C_DIN_WIDTH_WDCH : (64*(C_DIN_WIDTH_WDCH/64+1)));
    localparam C_DIN_WIDTH_RDCH_ECC           = (P_ECC_MODE_RDCH == 0) ? C_DIN_WIDTH_RDCH : ((C_DIN_WIDTH_RDCH%64 == 0) ? C_DIN_WIDTH_RDCH : (64*(C_DIN_WIDTH_RDCH/64+1)));



    wire                              wr_rst_busy_wach;
    wire                              wr_rst_busy_wdch;
    wire                              wr_rst_busy_wrch;
    wire                              wr_rst_busy_rach;
    wire                              wr_rst_busy_rdch;



  localparam C_AXI_PROT_WIDTH   = 3;
  localparam C_AXI_BRESP_WIDTH  = 2;
  localparam C_AXI_RRESP_WIDTH  = 2;


  wire     inverted_reset = ~s_aresetn;
  wire     rst_axil_sclk;
  wire     rst_axil_mclk;
  wire     m_aclk_int;
  assign   m_aclk_int = P_COMMON_CLOCK ? s_aclk : m_aclk;

  generate 
  if (EN_RESET_SYNCHRONIZER == 1) begin : gen_sync_reset
//Reset Synchronizer
      xpm_cdc_sync_rst #(
        .DEST_SYNC_FF   (P_COMMON_CLOCK ? 4 : CDC_SYNC_STAGES),
        .INIT           (0),
        .INIT_SYNC_FF   (1),
        .SIM_ASSERT_CHK (0)
      ) xpm_cdc_sync_rst_sclk_inst (
        .src_rst  (~s_aresetn),
        .dest_clk (s_aclk),
        .dest_rst (rst_axil_sclk)
      );
      xpm_cdc_sync_rst #(
        .DEST_SYNC_FF   (P_COMMON_CLOCK ? 4 : CDC_SYNC_STAGES),
        .INIT           (0),
        .INIT_SYNC_FF   (1),
        .SIM_ASSERT_CHK (0)
      ) xpm_cdc_sync_rst_mclk_inst (
        .src_rst  (~s_aresetn),
        .dest_clk (m_aclk_int),
        .dest_rst (rst_axil_mclk)
      );
  end // gen_sync_reset
  if (EN_RESET_SYNCHRONIZER == 0) begin : gen_async_reset
  assign rst_axil_sclk = inverted_reset;
  assign rst_axil_mclk = inverted_reset;
  
  end // gen_async_reset
  endgenerate 

  //###########################################################################
  //  AXI FULL Write Channel (axi_write_channel)
  //###########################################################################



  localparam IS_AXI_LITE_WACH  = ((C_WACH_TYPE == 0)) ? 1 : 0;
  localparam IS_AXI_LITE_WDCH  = ((C_WDCH_TYPE == 0)) ? 1 : 0;
  localparam IS_AXI_LITE_WRCH  = ((C_WRCH_TYPE == 0)) ? 1 : 0;
  localparam IS_AXI_LITE_RACH  = ((C_RACH_TYPE == 0)) ? 1 : 0;
  localparam IS_AXI_LITE_RDCH  = ((C_RDCH_TYPE == 0)) ? 1 : 0;

  localparam IS_WR_ADDR_CH     = ((IS_AXI_LITE_WACH == 1)) ? 1 : 0;
  localparam IS_WR_DATA_CH     = ((IS_AXI_LITE_WDCH == 1)) ? 1 : 0;
  localparam IS_WR_RESP_CH     = ((IS_AXI_LITE_WRCH == 1)) ? 1 : 0;
  localparam IS_RD_ADDR_CH     = ((IS_AXI_LITE_RACH == 1)) ? 1 : 0;
  localparam IS_RD_DATA_CH     = ((IS_AXI_LITE_RDCH == 1)) ? 1 : 0;

  localparam AWADDR_OFFSET     = C_DIN_WIDTH_WACH - AXI_ADDR_WIDTH;
  localparam AWPROT_OFFSET     = AWADDR_OFFSET - C_AXI_PROT_WIDTH;

  localparam WDATA_OFFSET      = C_DIN_WIDTH_WDCH - AXI_DATA_WIDTH;
  localparam WSTRB_OFFSET      = WDATA_OFFSET - AXI_DATA_WIDTH/8;

  localparam BRESP_OFFSET      = C_DIN_WIDTH_WRCH - C_AXI_BRESP_WIDTH;


  wire  [C_DIN_WIDTH_WACH-1:0]  wach_din          ;
  wire  [C_DIN_WIDTH_WACH-1:0]  wach_dout         ;
  wire  [C_DIN_WIDTH_WACH-1:0]  wach_dout_pkt     ;
  wire                          wach_full         ;
  wire                          wach_almost_full  ;
  wire                          wach_prog_full    ;
  wire                          wach_empty        ;
  wire                          wach_almost_empty ;
  wire                          wach_prog_empty   ;
  wire  [C_DIN_WIDTH_WDCH_ECC-1:0]  wdch_din          ;
  wire  [C_DIN_WIDTH_WDCH_ECC-1:0]  wdch_dout         ;
  wire                          wdch_full         ;
  wire                          wdch_almost_full  ;
  wire                          wdch_prog_full    ;
  wire                          wdch_empty        ;
  wire                          wdch_almost_empty ;
  wire                          wdch_prog_empty   ;
  wire  [C_DIN_WIDTH_WRCH-1:0]  wrch_din          ;
  wire  [C_DIN_WIDTH_WRCH-1:0]  wrch_dout         ;
  wire                          wrch_full         ;
  wire                          wrch_almost_full  ;
  wire                          wrch_prog_full    ;
  wire                          wrch_empty        ;
  wire                          wrch_almost_empty ;
  wire                          wrch_prog_empty   ;
  wire                          axi_aw_underflow_i;
  wire                          axi_w_underflow_i ;
  wire                          axi_b_underflow_i ;
  wire                          axi_aw_overflow_i ;
  wire                          axi_w_overflow_i  ;
  wire                          axi_b_overflow_i  ;
  wire                          wach_s_axi_awready;
  wire                          wach_m_axi_awvalid;
  wire                          wach_rd_en        ;
  wire                          wdch_s_axi_wready ;
  wire                          wdch_m_axi_wvalid ;
  wire                          wdch_wr_en        ;
  wire                          wdch_rd_en        ;
  wire                          wrch_s_axi_bvalid ;
  wire                          wrch_m_axi_bready ;
  wire                          txn_count_up      ;
  wire                          txn_count_down    ;
  wire                          awvalid_en        ;
  wire                          awvalid_pkt       ;
  wire                          awready_pkt       ;
  integer                       wr_pkt_count      ;
  wire                          wach_re           ;
  wire                          wdch_we           ;
  wire                          wdch_re           ;

  generate if (IS_WR_ADDR_CH == 1) begin : axi_write_address_channel
    // Write protection when almost full or prog_full is high

    // Read protection when almost empty or prog_empty is high
    assign wach_re    = m_axi_awready;
    assign wach_rd_en = wach_re;


xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK      ),
        .RELATED_CLOCKS             (0                   ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_WACH),
        .ECC_MODE                   (0),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_WACH     ),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_WACH    ),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           ("0101"),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_WACH    ),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_wach_dut (
        .sleep            (1'b0),
        .rst              (rst_axil_sclk),
        .wr_clk           (s_aclk),
        .wr_en            (s_axi_awvalid),
        .din              (wach_din),
        .full             (wach_full),
        .full_n           (),
        .prog_full        (),
        .wr_data_count    (),
        .overflow         (axi_aw_overflow_i),
        .wr_rst_busy      (wr_rst_busy_wach),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (m_aclk_int),
        .rd_en            (wach_rd_en),
        .dout             (wach_dout_pkt),
        .empty            (wach_empty),
        .prog_empty       (),
        .rd_data_count    (),
        .underflow        (axi_aw_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (1'b0),
        .injectdbiterr    (1'b0),
        .sbiterr          (),
        .dbiterr          ()
      );

    assign wach_s_axi_awready    = (FIFO_MEMORY_TYPE_WACH == "lutram") ? ~(wach_full | wr_rst_busy_wach) : ~wach_full;
    assign wach_m_axi_awvalid   = ~wach_empty;
    assign s_axi_awready        = wach_s_axi_awready;


  end endgenerate // axi_write_address_channel

    assign awvalid_en    = 1;    
    assign wach_dout     = wach_dout_pkt;
    assign m_axi_awvalid = wach_m_axi_awvalid;

  generate if (IS_WR_DATA_CH == 1) begin : axi_write_data_channel
    // Write protection when almost full or prog_full is high
    assign wdch_we    = wdch_s_axi_wready & s_axi_wvalid ;

    // Read protection when almost empty or prog_empty is high
    assign wdch_re    = wdch_m_axi_wvalid & m_axi_wready ;
    assign wdch_wr_en = wdch_we;
    assign wdch_rd_en = wdch_re;

xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK ),
        .RELATED_CLOCKS             (0      ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_WDCH),
        .ECC_MODE                   (P_ECC_MODE_WDCH),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_WDCH),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_WDCH_ECC),
        .WR_DATA_COUNT_WIDTH        (WR_DATA_COUNT_WIDTH_WDCH),
        .PROG_FULL_THRESH           (PROG_FULL_THRESH_WDCH),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           (USE_ADV_FEATURES_WDCH_INT),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_WDCH_ECC),
        .RD_DATA_COUNT_WIDTH        (RD_DATA_COUNT_WIDTH_WDCH),
        .PROG_EMPTY_THRESH          (PROG_EMPTY_THRESH_WDCH),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_wdch_dut (
        .sleep            (1'b0),
        .rst              (rst_axil_sclk),
        .wr_clk           (s_aclk),
        .wr_en            (wdch_wr_en),
        .din              (wdch_din),
        .full             (wdch_full),
        .full_n           (),
        .prog_full        (prog_full_wdch),
        .wr_data_count    (wr_data_count_wdch),
        .overflow         (axi_w_overflow_i),
        .wr_rst_busy      (wr_rst_busy_wdch),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (m_aclk_int),
        .rd_en            (wdch_rd_en),
        .dout             (wdch_dout),
        .empty            (wdch_empty),
        .prog_empty       (prog_empty_wdch),
        .rd_data_count    (rd_data_count_wdch),
        .underflow        (axi_w_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (injectsbiterr_wdch),
        .injectdbiterr    (injectdbiterr_wdch),
        .sbiterr          (sbiterr_wdch),
        .dbiterr          (dbiterr_wdch)
      );


    assign wdch_s_axi_wready     = (FIFO_MEMORY_TYPE_WDCH == "lutram") ? ~(wdch_full | wr_rst_busy_wdch) : ~wdch_full;
    assign wdch_m_axi_wvalid = ~wdch_empty;
    assign s_axi_wready      = wdch_s_axi_wready;
    assign m_axi_wvalid      = wdch_m_axi_wvalid;

  end endgenerate // axi_write_data_channel


  generate if (IS_WR_RESP_CH == 1) begin : axi_write_resp_channel

xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK      ),
        .RELATED_CLOCKS             (0                   ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_WRCH),
        .ECC_MODE                   (0),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_WRCH     ),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_WRCH),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           ("0101"),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_WRCH),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_wrch_dut (
        .sleep            (1'b0),
        .rst              (rst_axil_mclk),
        .wr_clk           (m_aclk_int),
        .wr_en            (m_axi_bvalid),
        .din              (wrch_din),
        .full             (wrch_full),
        .full_n           (),
        .prog_full        (),
        .wr_data_count    (),
        .overflow         (axi_b_overflow_i),
        .wr_rst_busy      (wr_rst_busy_wrch),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (s_aclk),
        .rd_en            (s_axi_bready),
        .dout             (wrch_dout),
        .empty            (wrch_empty),
        .prog_empty       (),
        .rd_data_count    (),
        .underflow        (axi_b_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (1'b0),
        .injectdbiterr    (1'b0),
        .sbiterr          (),
        .dbiterr          ()
      );

    assign wrch_s_axi_bvalid = ~wrch_empty;
    assign wrch_m_axi_bready     = (FIFO_MEMORY_TYPE_WRCH == "lutram") ? ~(wrch_full | wr_rst_busy_wrch) : ~wrch_full;
    assign s_axi_bvalid      = wrch_s_axi_bvalid;
    assign m_axi_bready      = wrch_m_axi_bready;

  end endgenerate // axi_write_resp_channel



  generate if (IS_AXI_LITE_WACH == 1 || (C_WACH_TYPE == 1)) begin : axi_wach_output1
    assign wach_din        = {s_axi_awaddr, s_axi_awprot};
    assign m_axi_awaddr    = wach_dout[C_DIN_WIDTH_WACH-1:AWADDR_OFFSET];    
    assign m_axi_awprot    = wach_dout[AWADDR_OFFSET-1:AWPROT_OFFSET];    
  end endgenerate // axi_wach_output1

  generate if (IS_AXI_LITE_WDCH == 1 || (C_WDCH_TYPE == 1)) begin : axi_wdch_output1
    assign wdch_din        = {s_axi_wdata, s_axi_wstrb};
    assign m_axi_wdata     = wdch_dout[C_DIN_WIDTH_WDCH-1:WDATA_OFFSET];
    assign m_axi_wstrb     = wdch_dout[WDATA_OFFSET-1:WSTRB_OFFSET];
  end endgenerate // axi_wdch_output1

  generate if (IS_AXI_LITE_WRCH == 1 || (C_WRCH_TYPE == 1)) begin : axi_wrch_output1
    assign wrch_din        = m_axi_bresp;
    assign s_axi_bresp     = wrch_dout[C_DIN_WIDTH_WRCH-1:BRESP_OFFSET]; 
  end endgenerate // axi_wrch_output1


  //end of  axi_write_channel

  //###########################################################################
  //  AXI FULL Read Channel (axi_read_channel)
  //###########################################################################
  wire [C_DIN_WIDTH_RACH-1:0]        rach_din            ;
  wire [C_DIN_WIDTH_RACH-1:0]        rach_dout           ;
  wire [C_DIN_WIDTH_RACH-1:0]        rach_dout_pkt       ;
  wire                               rach_full           ;
  wire                               rach_almost_full    ;
  wire                               rach_prog_full      ;
  wire                               rach_empty          ;
  wire                               rach_almost_empty   ;
  wire                               rach_prog_empty     ;
  wire [C_DIN_WIDTH_RDCH_ECC-1:0]        rdch_din            ;
  wire [C_DIN_WIDTH_RDCH_ECC-1:0]        rdch_dout           ;
  wire                               rdch_full           ;
  wire                               rdch_almost_full    ;
  wire                               rdch_prog_full      ;
  wire                               rdch_empty          ;
  wire                               rdch_almost_empty   ;
  wire                               rdch_prog_empty     ;
  wire                               axi_ar_underflow_i  ;
  wire                               axi_r_underflow_i   ;
  wire                               axi_ar_overflow_i   ;
  wire                               axi_r_overflow_i    ;
  wire                               rach_s_axi_arready  ;
  wire                               rach_m_axi_arvalid  ;
  wire                               rach_rd_en          ;
  wire                               rdch_m_axi_rready   ;
  wire                               rdch_s_axi_rvalid   ;
  wire                               rdch_wr_en          ;
  wire                               rdch_rd_en          ;
  wire                               arvalid_pkt         ;
  wire                               arready_pkt         ;
  wire                               arvalid_en          ;
  wire                               rdch_rd_ok          ;
  wire                               accept_next_pkt     ;
  integer                            rdch_free_space     ;
  integer                            rdch_commited_space ;
  wire                               rach_re             ;
  wire                               rdch_we             ;
  wire                               rdch_re             ;

  localparam ARADDR_OFFSET     = C_DIN_WIDTH_RACH - AXI_ADDR_WIDTH;
  localparam ARPROT_OFFSET     = ARADDR_OFFSET - C_AXI_PROT_WIDTH;

  localparam RDATA_OFFSET      = C_DIN_WIDTH_RDCH - AXI_DATA_WIDTH;
  localparam RRESP_OFFSET      = RDATA_OFFSET - C_AXI_RRESP_WIDTH;


  generate if (IS_RD_ADDR_CH == 1) begin : axi_read_addr_channel

    // Write protection when almost full or prog_full is high

    // Read protection when almost empty or prog_empty is high
    assign rach_re    = m_axi_arready;
    assign rach_rd_en = rach_re;


xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK      ),
        .RELATED_CLOCKS             (0                   ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_RACH),
        .ECC_MODE                   (0),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_RACH     ),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_RACH),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           ("0101"),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_RACH),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_rach_dut (
        .sleep            (1'b0),
        .rst              (rst_axil_sclk),
        .wr_clk           (s_aclk),
        .wr_en            (s_axi_arvalid),
        .din              (rach_din),
        .full             (rach_full),
        .full_n           (),
        .prog_full        (),
        .wr_data_count    (),
        .overflow         (axi_ar_overflow_i),
        .wr_rst_busy      (wr_rst_busy_rach),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (m_aclk_int),
        .rd_en            (rach_rd_en),
        .dout             (rach_dout_pkt),
        .empty            (rach_empty),
        .prog_empty       (),
        .rd_data_count    (),
        .underflow        (axi_ar_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (1'b0),
        .injectdbiterr    (1'b0),
        .sbiterr          (),
        .dbiterr          ()
      );

    assign rach_s_axi_arready    = (FIFO_MEMORY_TYPE_RACH == "lutram") ? ~(rach_full | wr_rst_busy_rach) : ~rach_full;
    assign rach_m_axi_arvalid = ~rach_empty;
    assign s_axi_arready      = rach_s_axi_arready;

  end endgenerate // axi_read_addr_channel


  generate if (C_RACH_TYPE == 0) begin : grach_m_axi_arvalid
    assign m_axi_arvalid      = rach_m_axi_arvalid;
    assign rach_dout          = rach_dout_pkt;
  end endgenerate // grach_m_axi_arvalid
  
  assign arvalid_en = 1;    

  generate if (IS_RD_DATA_CH == 1) begin : axi_read_data_channel

    // Write protection when almost full or prog_full is high
    assign rdch_we    = rdch_m_axi_rready  & m_axi_rvalid ;

    // Read protection when almost empty or prog_empty is high
    assign rdch_re    = rdch_s_axi_rvalid  & s_axi_rready;
    assign rdch_wr_en = rdch_we;
    assign rdch_rd_en = rdch_re;


xpm_fifo_base # (
        .COMMON_CLOCK               (P_COMMON_CLOCK      ),
        .RELATED_CLOCKS             (0                   ),
        .FIFO_MEMORY_TYPE           (P_FIFO_MEMORY_TYPE_RDCH),
        .ECC_MODE                   (P_ECC_MODE_RDCH     ),
        .SIM_ASSERT_CHK             (SIM_ASSERT_CHK      ),
        .CASCADE_HEIGHT             (CASCADE_HEIGHT      ),
        .FIFO_WRITE_DEPTH           (FIFO_DEPTH_RDCH     ),
        .WRITE_DATA_WIDTH           (C_DIN_WIDTH_RDCH_ECC),
        .WR_DATA_COUNT_WIDTH        (WR_DATA_COUNT_WIDTH_RDCH),
        .PROG_FULL_THRESH           (PROG_FULL_THRESH_RDCH ),
        .FULL_RESET_VALUE           (1                   ),
        .USE_ADV_FEATURES           (USE_ADV_FEATURES_RDCH_INT),
        .READ_MODE                  (1                   ),
        .FIFO_READ_LATENCY          (0                   ),
        .READ_DATA_WIDTH            (C_DIN_WIDTH_RDCH_ECC),
        .RD_DATA_COUNT_WIDTH        (RD_DATA_COUNT_WIDTH_RDCH),
        .PROG_EMPTY_THRESH          (PROG_EMPTY_THRESH_RDCH),
        .DOUT_RESET_VALUE           (""                  ),
        .CDC_DEST_SYNC_FF           (CDC_SYNC_STAGES     ),
        .REMOVE_WR_RD_PROT_LOGIC    (0                   ),
        .WAKEUP_TIME                (0                   ),
        .VERSION                    (0                   )
      ) xpm_fifo_base_rdch_dut (
        .sleep            (1'b0),
        .rst              (rst_axil_mclk),
        .wr_clk           (m_aclk_int),
        .wr_en            (rdch_wr_en),
        .din              (rdch_din),
        .full             (rdch_full),
        .full_n           (),
        .prog_full        (prog_full_rdch),
        .wr_data_count    (wr_data_count_rdch),
        .overflow         (axi_r_overflow_i),
        .wr_rst_busy      (wr_rst_busy_rdch),
        .almost_full      (),
        .wr_ack           (),
        .rd_clk           (s_aclk),
        .rd_en            (rdch_rd_en),
        .dout             (rdch_dout),
        .empty            (rdch_empty),
        .prog_empty       (prog_empty_rdch),
        .rd_data_count    (rd_data_count_rdch),
        .underflow        (axi_r_underflow_i),
        .rd_rst_busy      (),
        .almost_empty     (),
        .data_valid       (),
        .injectsbiterr    (injectsbiterr_rdch),
        .injectdbiterr    (injectdbiterr_rdch),
        .sbiterr          (sbiterr_rdch),
        .dbiterr          (dbiterr_rdch)
      );

    assign rdch_s_axi_rvalid = ~rdch_empty;
    assign rdch_m_axi_rready     = (FIFO_MEMORY_TYPE_RDCH == "lutram") ? ~(rdch_full | wr_rst_busy_rdch) : ~rdch_full;
    assign s_axi_rvalid      = rdch_s_axi_rvalid;
    assign m_axi_rready      = rdch_m_axi_rready;


  end endgenerate //axi_read_data_channel




  generate if (IS_AXI_LITE_RACH == 1 || (C_RACH_TYPE == 1)) begin : axi_lite_rach_output1
    assign rach_din      = {s_axi_araddr, s_axi_arprot};
    assign m_axi_araddr  = rach_dout[C_DIN_WIDTH_RACH-1:ARADDR_OFFSET];
    assign m_axi_arprot  = rach_dout[ARADDR_OFFSET-1:ARPROT_OFFSET];
  end endgenerate // axi_lite_rach_output

  generate if (IS_AXI_LITE_RDCH == 1 || (C_RDCH_TYPE == 1)) begin : axi_lite_rdch_output1
    assign rdch_din      = {m_axi_rdata, m_axi_rresp};
    assign s_axi_rdata   = rdch_dout[C_DIN_WIDTH_RDCH-1:RDATA_OFFSET];
    assign s_axi_rresp   = rdch_dout[RDATA_OFFSET-1:RRESP_OFFSET];
  end endgenerate // axi_lite_rdch_output


  //end of axi_read_channel

  
  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  // Pass Through Logic or Wiring Logic
  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  //-------------------------------------------------------------------------
  
  //-------------------------------------------------------------------------
  // Pass Through Logic for Read Channel
  //-------------------------------------------------------------------------

  // Wiring logic for Write Address Channel
  generate if (C_WACH_TYPE == 2) begin : gwach_pass_through
    assign m_axi_awaddr    = s_axi_awaddr;
    assign m_axi_awprot    = s_axi_awprot;
    assign s_axi_awready   = m_axi_awready;
    assign m_axi_awvalid   = s_axi_awvalid;
  end endgenerate // gwach_pass_through;

  // Wiring logic for Write Data Channel
  generate if (C_WDCH_TYPE == 2) begin : gwdch_pass_through
    assign m_axi_wdata     = s_axi_wdata;
    assign m_axi_wstrb     = s_axi_wstrb;
    assign s_axi_wready    = m_axi_wready;
    assign m_axi_wvalid    = s_axi_wvalid;
  end endgenerate // gwdch_pass_through;

  // Wiring logic for Write Response Channel
  generate if (C_WRCH_TYPE == 2) begin : gwrch_pass_through
    assign s_axi_bresp     = m_axi_bresp;
    assign m_axi_bready    = s_axi_bready;
    assign s_axi_bvalid    = m_axi_bvalid;
  end endgenerate // gwrch_pass_through;

  //-------------------------------------------------------------------------
  // Pass Through Logic for Read Channel
  //-------------------------------------------------------------------------

  // Wiring logic for Read Address Channel
  generate if (C_RACH_TYPE == 2) begin : grach_pass_through
    assign m_axi_araddr    = s_axi_araddr;
    assign m_axi_arprot    = s_axi_arprot;
    assign s_axi_arready   = m_axi_arready;
    assign m_axi_arvalid   = s_axi_arvalid;
  end endgenerate // grach_pass_through;

  // Wiring logic for Read Data Channel 
  generate if (C_RDCH_TYPE == 2) begin : grdch_pass_through
    assign s_axi_rdata    = m_axi_rdata;
    assign s_axi_rresp    = m_axi_rresp;
    assign s_axi_rvalid   = m_axi_rvalid;
    assign m_axi_rready   = s_axi_rready;
  end endgenerate // grdch_pass_through;


endmodule //xpm_fifo_axil

module xpm_fifo_axi_reg_slice #
  (
   parameter C_DATA_WIDTH = 32,
   parameter C_REG_CONFIG = 32'h00000000
   )
  (
   // System Signals
   input  wire                      ACLK,
   input  wire                      ARESET,

   // Slave side
   input  wire [C_DATA_WIDTH-1:0]   S_PAYLOAD_DATA,
   input  wire                      S_VALID,
   output wire                      S_READY,

   // Master side
   output wire [C_DATA_WIDTH-1:0]   M_PAYLOAD_DATA,
   output wire                      M_VALID,
   input  wire                      M_READY
   );

  localparam RST_SYNC_STAGES = 5;
  localparam RST_BUSY_LEN    = 6;
  reg [1:0] arst_sync_wr  = 2'b11;
  reg [RST_BUSY_LEN-1:0] sckt_wr_rst_cc = 0;
  wire sync_reset;
  wire extnd_reset;


  always @(posedge ARESET or posedge ACLK) begin
    if (ARESET)
      arst_sync_wr <= 2'b11;
    else
      arst_sync_wr <= {arst_sync_wr[0], 1'b0};
  end

  always @(posedge ACLK) begin
    sckt_wr_rst_cc   <= {sckt_wr_rst_cc[RST_BUSY_LEN-2:0], arst_sync_wr[1]};
  end

  assign sync_reset     = |sckt_wr_rst_cc[RST_BUSY_LEN-5:0] | arst_sync_wr[1]; 
  assign extnd_reset    = |sckt_wr_rst_cc | arst_sync_wr[1];
  generate
  ////////////////////////////////////////////////////////////////////
  //
  // Both FWD and REV mode
  //
  ////////////////////////////////////////////////////////////////////
    if (C_REG_CONFIG == 32'h00000000)
    begin
      reg [1:0] state;
      localparam [1:0] 
        ZERO = 2'b10,
        ONE  = 2'b11,
        TWO  = 2'b01;
      
      reg [C_DATA_WIDTH-1:0] storage_data1 = 0;
      reg [C_DATA_WIDTH-1:0] storage_data2 = 0;
      reg                    load_s1;
      wire                   load_s2;
      wire                   load_s1_from_s2;
      reg                    s_ready_i; //local signal of output
      wire                   m_valid_i; //local signal of output

      // assign local signal to its output signal
      assign S_READY = s_ready_i;
      assign M_VALID = m_valid_i;

      reg  areset_d1; // Reset delay register
      always @(posedge ACLK) begin
        areset_d1 <= extnd_reset;
      end
      
      // Load storage1 with either slave side data or from storage2
      always @(posedge ACLK) 
      begin
        if (load_s1)
          if (load_s1_from_s2)
            storage_data1 <= storage_data2;
          else
            storage_data1 <= S_PAYLOAD_DATA;        
      end

      // Load storage2 with slave side data
      always @(posedge ACLK) 
      begin
        if (load_s2)
          storage_data2 <= S_PAYLOAD_DATA;
      end

      assign M_PAYLOAD_DATA = storage_data1;

      // Always load s2 on a valid transaction even if it's unnecessary
      assign load_s2 = S_VALID & s_ready_i;

      // Loading s1
      always @ *
      begin
        if ( ((state == ZERO) && (S_VALID == 1)) || // Load when empty on slave transaction
             // Load when ONE if we both have read and write at the same time
             ((state == ONE) && (S_VALID == 1) && (M_READY == 1)) ||
             // Load when TWO and we have a transaction on Master side
             ((state == TWO) && (M_READY == 1)))
          load_s1 = 1'b1;
        else
          load_s1 = 1'b0;
      end // always @ *

      assign load_s1_from_s2 = (state == TWO);
                       
      // State Machine for handling output signals
      always @(posedge ACLK) begin
        if (sync_reset || extnd_reset) begin
          s_ready_i <= 1'b0;
          state <= ZERO;
        end else if (areset_d1 && ~extnd_reset) begin
          s_ready_i <= 1'b1;
        end else begin
          case (state)
            // No transaction stored locally
            ZERO: if (S_VALID) state <= ONE; // Got one so move to ONE

            // One transaction stored locally
            ONE: begin
              if (M_READY & ~S_VALID) state <= ZERO; // Read out one so move to ZERO
              if (~M_READY & S_VALID) begin
                state <= TWO;  // Got another one so move to TWO
                s_ready_i <= 1'b0;
              end
            end

            // TWO transaction stored locally
            TWO: if (M_READY) begin
              state <= ONE; // Read out one so move to ONE
              s_ready_i <= 1'b1;
            end
          endcase // case (state)
        end
      end // always @ (posedge ACLK)
      
      assign m_valid_i = state[0];

    end // if (C_REG_CONFIG == 1)
  ////////////////////////////////////////////////////////////////////
  //
  // 1-stage pipeline register with bubble cycle, both FWD and REV pipelining
  // Operates same as 1-deep FIFO
  //
  ////////////////////////////////////////////////////////////////////
    else if (C_REG_CONFIG == 32'h00000001)
    begin
      reg [C_DATA_WIDTH-1:0] storage_data1 = 0;
      reg                    s_ready_i; //local signal of output
      reg                    m_valid_i; //local signal of output

      // assign local signal to its output signal
      assign S_READY = s_ready_i;
      assign M_VALID = m_valid_i;

      reg  areset_d1; // Reset delay register
      always @(posedge ACLK) begin
        areset_d1 <= extnd_reset;
      end
      
      // Load storage1 with slave side data
      always @(posedge ACLK) 
      begin
        if (sync_reset || extnd_reset) begin
          s_ready_i <= 1'b0;
          m_valid_i <= 1'b0;
        end else if (areset_d1 && ~extnd_reset) begin
          s_ready_i <= 1'b1;
        end else if (m_valid_i & M_READY) begin
          s_ready_i <= 1'b1;
          m_valid_i <= 1'b0;
        end else if (S_VALID & s_ready_i) begin
          s_ready_i <= 1'b0;
          m_valid_i <= 1'b1;
        end
        if (~m_valid_i) begin
          storage_data1 <= S_PAYLOAD_DATA;        
        end
      end
      assign M_PAYLOAD_DATA = storage_data1;
    end // if (C_REG_CONFIG == 7)
    
    else begin : default_case
      // Passthrough
      assign M_PAYLOAD_DATA = S_PAYLOAD_DATA;
      assign M_VALID        = S_VALID;
      assign S_READY        = M_READY;      
    end

  endgenerate
endmodule // reg_slice
`default_nettype wire
