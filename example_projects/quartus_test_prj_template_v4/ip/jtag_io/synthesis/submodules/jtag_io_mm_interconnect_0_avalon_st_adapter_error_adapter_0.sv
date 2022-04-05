// (C) 2001-2020 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

 
// $Id: //acds/rel/13.1/ip/.../avalon-st_error_adapter.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/09/09 $
// $Author: dmunday $


// --------------------------------------------------------------------------------
//| Avalon Streaming Error Adapter
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps

// ------------------------------------------
// Generation parameters:
//   output_name:        jtag_io_mm_interconnect_0_avalon_st_adapter_error_adapter_0
//   use_ready:          true
//   use_packets:        false
//   use_empty:          0
//   empty_width:        0
//   data_width:         34
//   channel_width:      0
//   in_error_width:     0
//   out_error_width:    1
//   in_errors_list      
//   in_errors_indices   0
//   out_errors_list     
//   has_in_error_desc:  FALSE
//   has_out_error_desc: FALSE
//   out_has_other:      FALSE
//   out_other_index:    -1
//   dumpVar:            
//   inString:            in_error[
//   closeString:        ] |

// ------------------------------------------




module jtag_io_mm_interconnect_0_avalon_st_adapter_error_adapter_0
(
 // Interface: in
 output reg         in_ready,
 input              in_valid,
 input [34-1: 0]     in_data,
 // Interface: out
 input               out_ready,
 output reg          out_valid,
 output reg [34-1: 0] out_data,
 output reg [0:0]         out_error,
  // Interface: clk
 input              clk,
 // Interface: reset
 input              reset_n

 /*AUTOARG*/);
   
   reg in_error = 0;
   initial in_error = 0;

   // ---------------------------------------------------------------------
   //| Pass-through Mapping
   // ---------------------------------------------------------------------
   always_comb begin
      in_ready = out_ready;
      out_valid = in_valid;
      out_data = in_data;

   end

   // ---------------------------------------------------------------------
   //| Error Mapping 
   // ---------------------------------------------------------------------
   always_comb begin
      out_error = 0;
      
      out_error = in_error;
                                    
   end //always @*
endmodule

