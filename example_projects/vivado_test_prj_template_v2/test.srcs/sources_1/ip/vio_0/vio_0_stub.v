// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2700185 Thu Oct 24 18:46:05 MDT 2019
// Date        : Fri Apr  1 15:55:35 2022
// Host        : PAVLOV running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               J:/basic_verilog/example_projects/vivado_test_prj_template_v2/test.srcs/sources_1/ip/vio_0/vio_0_stub.v
// Design      : vio_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.2" *)
module vio_0(clk, probe_in0, probe_in1, probe_out0)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[31:0],probe_in1[31:0],probe_out0[31:0]" */;
  input clk;
  input [31:0]probe_in0;
  input [31:0]probe_in1;
  output [31:0]probe_out0;
endmodule
