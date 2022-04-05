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


// This module is a simple clock crosser for control signals. It will take
// the asynchronous control signal and synchronize it to the clk domain
// attached to the clk input. It does so by passing the control signal
// through a pair of registers and then sensing the level transition from
// either hi-to-lo or lo-to-hi. *ATTENTION* This module makes the assumption
// that the control signal will always transition every time is asserted.
// i.e.:
//       ____            ___________________
// -> ___|   |___ and ___|                  |_____
//
// on the control signal will be seen as only one assertion of the control
// signal. In short, if your control could be asserted back-to-back, then
// don't use this module. You'll be losing data.

`timescale 1 ns / 1 ns

module altera_jtag_control_signal_crosser (
   clk,
   reset_n,
   async_control_signal,
   sense_pos_edge,
   sync_control_signal
);
   input  clk;
   input  reset_n;
   input  async_control_signal;
   input  sense_pos_edge;
   output sync_control_signal;

   parameter SYNC_DEPTH = 3; // number of synchronizer stages for clock crossing

   reg sync_control_signal;

   wire synchronized_raw_signal;
   reg  edge_detector_register;

   altera_std_synchronizer #(.depth(SYNC_DEPTH)) synchronizer (
       .clk(clk),
       .reset_n(reset_n),
       .din(async_control_signal),
       .dout(synchronized_raw_signal)
   );

  always @ (posedge clk or negedge reset_n)
    if (~reset_n)
      edge_detector_register <= 1'b0;
    else
      edge_detector_register <= synchronized_raw_signal;

  always @* begin
    if (sense_pos_edge)
      sync_control_signal <= ~edge_detector_register & synchronized_raw_signal;
    else
      sync_control_signal <= edge_detector_register & ~synchronized_raw_signal;
  end
endmodule

// This module crosses the clock domain for a given source
module altera_jtag_src_crosser (
   sink_clk,
   sink_reset_n,
   sink_valid,
   sink_data,
   src_clk,
   src_reset_n,
   src_valid,
   src_data
);
   parameter WIDTH = 8;
   parameter SYNC_DEPTH = 3; // number of synchronizer stages for clock crossing

   input              sink_clk;
   input              sink_reset_n;
   input              sink_valid;
   input [WIDTH-1:0]  sink_data;
   input              src_clk;
   input              src_reset_n;
   output             src_valid;
   output [WIDTH-1:0] src_data;

   reg              sink_valid_buffer;
   reg [WIDTH-1:0]  sink_data_buffer;

   reg              src_valid;
   reg [WIDTH-1:0]  src_data /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101 ; {-from \"*\"} CUT=ON " */;

   wire synchronized_valid;

   altera_jtag_control_signal_crosser #(
     .SYNC_DEPTH(SYNC_DEPTH)
   ) crosser (
       .clk(src_clk),
       .reset_n(src_reset_n),
       .async_control_signal(sink_valid_buffer),
       .sense_pos_edge(1'b1),
       .sync_control_signal(synchronized_valid)
   );
   always @ (posedge sink_clk or negedge sink_reset_n) begin
      if (~sink_reset_n) begin
         sink_valid_buffer <= 1'b0;
         sink_data_buffer <= 'b0;
      end else begin
         sink_valid_buffer <= sink_valid;
         if (sink_valid) begin
           sink_data_buffer <= sink_data;
         end
      end //end if
   end //always sink_clk

   always @ (posedge src_clk or negedge src_reset_n) begin
      if (~src_reset_n) begin
     src_valid <= 1'b0;
     src_data <= {WIDTH{1'b0}};
      end else begin
     src_valid <= synchronized_valid;
     src_data <= synchronized_valid ? sink_data_buffer : src_data;
      end
   end

endmodule

module altera_jtag_dc_streaming  #(
    parameter PURPOSE = 0, // for discovery of services behind this JTAG Phy - 0
                           //   for JTAG Phy, 1 for Packets to Master
    parameter UPSTREAM_FIFO_SIZE = 0,
    parameter DOWNSTREAM_FIFO_SIZE = 0,
    parameter MGMT_CHANNEL_WIDTH = -1
) (
    // Signals in the JTAG clock domain
    input  wire       tck,
    input  wire       tdi,
    output wire       tdo,
    input  wire [2:0] ir_in,
    input  wire       virtual_state_cdr,
    input  wire       virtual_state_sdr,
    input  wire       virtual_state_udr,

    input  wire       clk,
    input  wire       reset_n,
    output wire [7:0] source_data,
    output wire       source_valid,
    input  wire [7:0] sink_data,
    input  wire       sink_valid,
    output wire       sink_ready,
    output wire       resetrequest,
    output wire       debug_reset,
    output wire       mgmt_valid,
    output wire [(MGMT_CHANNEL_WIDTH>0?MGMT_CHANNEL_WIDTH:1)-1:0] mgmt_channel,
    output wire       mgmt_data
);

   // the tck to sysclk sync depth is fixed at 8
   // 8 is the worst case scenario from our metastability analysis, and since
   // using TCK serially is so slow we should have plenty of clock cycles.
   localparam TCK_TO_SYSCLK_SYNC_DEPTH = 8;
   // The clk to tck path is fixed at 3 deep for Synchronizer depth.
   // Since the tck clock is so slow, no parameter is exposed.
   localparam SYSCLK_TO_TCK_SYNC_DEPTH = 3;

   wire       jtag_clock_reset_n; // system reset is synchronized with tck
   wire [7:0] jtag_source_data;
   wire       jtag_source_valid;
   wire [7:0] jtag_sink_data;
   wire       jtag_sink_valid;
   wire       jtag_sink_ready;

   /* Reset Synchronizer module.
    *
    * The SLD Node does not provide a reset for the TCK clock domain.
    * Due to the handshaking nature of the Avalon-ST Clock Crosser,
    * internal states need to be reset to 0 in order to guarantee proper
    * functionality throughout resets.
    *
    * This reset block will asynchronously assert reset, and synchronously
    * deassert reset for the tck clock domain.
    */
   altera_std_synchronizer #(
       .depth(SYSCLK_TO_TCK_SYNC_DEPTH)
   ) synchronizer (
       .clk(tck),
       .reset_n(reset_n),
       .din(1'b1),
       .dout(jtag_clock_reset_n)
   );

   altera_jtag_streaming #(
       .PURPOSE(PURPOSE),
       .UPSTREAM_FIFO_SIZE(UPSTREAM_FIFO_SIZE),
       .DOWNSTREAM_FIFO_SIZE(DOWNSTREAM_FIFO_SIZE),
       .MGMT_CHANNEL_WIDTH(MGMT_CHANNEL_WIDTH)
   ) jtag_streaming (
       .tck              (tck),
       .tdi              (tdi),
       .tdo              (tdo),
       .ir_in            (ir_in),
       .virtual_state_cdr(virtual_state_cdr),
       .virtual_state_sdr(virtual_state_sdr),
       .virtual_state_udr(virtual_state_udr),

       .reset_n(jtag_clock_reset_n),
       .source_data(jtag_source_data),
       .source_valid(jtag_source_valid),
       .sink_data(jtag_sink_data),
       .sink_valid(jtag_sink_valid),
       .sink_ready(jtag_sink_ready),
       .clock_to_sample(clk),
       .reset_to_sample(reset_n),
       .resetrequest(resetrequest),
       .debug_reset(debug_reset),
       .mgmt_valid(mgmt_valid),
       .mgmt_channel(mgmt_channel),
       .mgmt_data(mgmt_data)
    );

   // synchronization in both clock domain crossings takes place in the "clk" system clock domain!

   altera_avalon_st_clock_crosser #(
       .SYMBOLS_PER_BEAT(1),
       .BITS_PER_SYMBOL(8),
       .FORWARD_SYNC_DEPTH(SYSCLK_TO_TCK_SYNC_DEPTH),
       .BACKWARD_SYNC_DEPTH(TCK_TO_SYSCLK_SYNC_DEPTH)
   ) sink_crosser (
       .in_clk(clk),
       .in_reset(~reset_n),
       .in_data(sink_data),
       .in_ready(sink_ready),
       .in_valid(sink_valid),
       .out_clk(tck),
       .out_reset(~jtag_clock_reset_n),
       .out_data(jtag_sink_data),
       .out_ready(jtag_sink_ready),
       .out_valid(jtag_sink_valid)
   );

   altera_jtag_src_crosser #(
       .SYNC_DEPTH(TCK_TO_SYSCLK_SYNC_DEPTH)
   ) source_crosser (
       .sink_clk(tck),
       .sink_reset_n(jtag_clock_reset_n),
       .sink_valid(jtag_source_valid),
       .sink_data(jtag_source_data),
       .src_clk(clk),
       .src_reset_n(reset_n),
       .src_valid(source_valid),
       .src_data(source_data)
   );

endmodule
