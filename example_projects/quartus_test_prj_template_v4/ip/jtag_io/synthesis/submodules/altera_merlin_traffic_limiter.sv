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


// $Id: //acds/rel/20.1std/ip/merlin/altera_merlin_traffic_limiter/altera_merlin_traffic_limiter.sv#1 $
// $Revision: #1 $
// $Date: 2019/10/06 $
// $Author: psgswbuild $

// -----------------------------------------------------
// Merlin Traffic Limiter
//
// Ensures that non-posted transaction responses are returned 
// in order of request. Out-of-order responses can happen 
// when a master does a non-posted transaction on a slave 
// while responses are pending from a different slave.
//
// Examples:
//   1) read to any latent slave, followed by a read to a 
//      variable-latent slave
//   2) read to any fixed-latency slave, followed by a read 
//      to another fixed-latency slave whose fixed latency is smaller.
//   3) non-posted write to any latent slave, followed by a non-posted
//      write or read to any variable-latent slave.
//
// This component has two implementation modes that ensure
// response order, controlled by the REORDER parameter.
// 
//   0) Backpressure to prevent a master from switching slaves 
//   until all outstanding responses have returned. We also 
//   have to suppress the non-posted transaction, obviously.
//
//   1) Reorder the responses as they return using a memory
//   block.
// -----------------------------------------------------

`timescale 1 ns / 1 ns

// altera message_off 10036
module altera_merlin_traffic_limiter
#(
   parameter
      PKT_TRANS_POSTED           = 1,
      PKT_DEST_ID_H              = 0,
      PKT_DEST_ID_L              = 0,
      PKT_SRC_ID_H               = 0,
      PKT_SRC_ID_L               = 0,
      PKT_BYTE_CNT_H             = 0,
      PKT_BYTE_CNT_L             = 0,
      PKT_BYTEEN_H               = 0,
      PKT_BYTEEN_L               = 0,
      PKT_TRANS_WRITE            = 0,
      PKT_TRANS_READ             = 0,
      ST_DATA_W                  = 72,
      ST_CHANNEL_W               = 32,

      MAX_OUTSTANDING_RESPONSES  = 1,
      PIPELINED                  = 0,
      ENFORCE_ORDER              = 1,

      // -------------------------------------
      // internal: allows optimization between this
      // component and the demux
      // -------------------------------------
      VALID_WIDTH                = 1,

      // -------------------------------------
      // Prevents all RAW and WAR hazards by waiting for 
      // responses to return before issuing a command 
      // with different direction.
      //
      // This is intended for Avalon masters which are 
      // connected to AXI slaves, because of the differing
      // ordering models for the protocols.
      //
      // If PREVENT_HAZARDS is 1, then the current implementation
      // needs to know whether incoming writes will be posted or
      // not at compile-time. Only one of SUPPORTS_POSTED_WRITES
      // and SUPPORTS_NONPOSTED_WRITES can be 1.
      //
      // When PREVENT_HAZARDS is 0 there is no such restriction.
      //
      // It is possible to be less restrictive for memories.
      // -------------------------------------
      PREVENT_HAZARDS            = 0,

      // -------------------------------------
      // Used only when hazard prevention is on, but may be used
      // for optimization work in the future.
      // -------------------------------------
      SUPPORTS_POSTED_WRITES     = 1,
      SUPPORTS_NONPOSTED_WRITES  = 0,

      // -------------------------------------------------
      // Enables the reorder buffer which allows a master to 
      // switch slaves while responses are pending.
      // Reponses will be reordered following command issue order.
      // -------------------------------------------------
      REORDER                    = 0
)
(
   // -------------------
   // Clock & Reset
   // -------------------
   input clk,
   input reset,

   // -------------------
   // Command
   // -------------------
   input                            cmd_sink_valid,
   input [ST_DATA_W-1 : 0]          cmd_sink_data,
   input [ST_CHANNEL_W-1 : 0]       cmd_sink_channel,
   input                            cmd_sink_startofpacket,
   input                            cmd_sink_endofpacket,
   output                           cmd_sink_ready,

   output reg [VALID_WIDTH-1  : 0]  cmd_src_valid,
   output reg [ST_DATA_W-1    : 0]  cmd_src_data,
   output reg [ST_CHANNEL_W-1 : 0]  cmd_src_channel,
   output reg                       cmd_src_startofpacket,
   output reg                       cmd_src_endofpacket,
   input                            cmd_src_ready,

   // -------------------
   // Response
   // -------------------
   input                            rsp_sink_valid,
   input [ST_DATA_W-1 : 0]          rsp_sink_data,
   input [ST_CHANNEL_W-1 : 0]       rsp_sink_channel,
   input                            rsp_sink_startofpacket,
   input                            rsp_sink_endofpacket,
   output reg                       rsp_sink_ready,

   output reg                       rsp_src_valid,
   output reg [ST_DATA_W-1 : 0]     rsp_src_data,
   output reg [ST_CHANNEL_W-1 : 0]  rsp_src_channel,
   output reg                       rsp_src_startofpacket,
   output reg                       rsp_src_endofpacket,
   input                            rsp_src_ready
);

   // -------------------------------------
   // Local Parameters
   // -------------------------------------
   localparam DEST_ID_W = PKT_DEST_ID_H - PKT_DEST_ID_L + 1;
   localparam COUNTER_W = log2ceil(MAX_OUTSTANDING_RESPONSES + 1);
   localparam PAYLOAD_W = ST_DATA_W + ST_CHANNEL_W + 4;
   localparam NUMSYMBOLS = PKT_BYTEEN_H - PKT_BYTEEN_L + 1;
   localparam MAX_DEST_ID = 1 << (DEST_ID_W);
   localparam PKT_BYTE_CNT_W = PKT_BYTE_CNT_H - PKT_BYTE_CNT_L + 1;
   
   // -------------------------------------------------------
   // Memory Parameters
   // ------------------------------------------------------
   localparam MAX_BYTE_CNT = 1 << (PKT_BYTE_CNT_W);
   localparam MAX_BURST_LENGTH = log2ceil(MAX_BYTE_CNT/NUMSYMBOLS);

   // Memory stores packet width, including sop and eop
   localparam MEM_W = ST_DATA_W + ST_CHANNEL_W + 1 + 1;
   localparam MEM_DEPTH = MAX_OUTSTANDING_RESPONSES * (MAX_BYTE_CNT/NUMSYMBOLS);
   
   // -----------------------------------------------------
   // Input Stage
   //
   // Figure out if the destination id has changed
   // -----------------------------------------------------
   wire                    stage1_dest_changed;
   wire                    stage1_trans_changed;
   wire [PAYLOAD_W-1 : 0]  stage1_payload;
   wire                    in_nonposted_cmd;
   reg [ST_CHANNEL_W-1:0]  last_channel;
   wire [DEST_ID_W-1 : 0]  dest_id;
   reg [DEST_ID_W-1 : 0]   last_dest_id;
   reg                     was_write;
   wire                    is_write;
   wire                    suppress;
   wire                    save_dest_id;

   wire                    suppress_change_dest_id;
   wire                    suppress_max_outstanding;
   wire                    suppress_change_trans_but_not_dest;
   wire                    suppress_change_trans_for_one_slave;
   
   generate if (PREVENT_HAZARDS == 1) begin : convert_posted_to_nonposted_block
      assign in_nonposted_cmd = 1'b1;
   end else begin : non_posted_cmd_assignment_block
      assign in_nonposted_cmd = (cmd_sink_data[PKT_TRANS_POSTED] == 0);
   end
   endgenerate

   // ------------------------------------
   // Optimization: for the unpipelined case, we can save the destid if
   // this is an unsuppressed nonposted command. This eliminates
   // dependence on the backpressure signal.
   //
   // Not a problem for the pipelined case.
   // ------------------------------------
   generate
      if (PIPELINED) begin : pipelined_save_dest_id
         assign save_dest_id = cmd_sink_valid & cmd_sink_ready & in_nonposted_cmd;
      end else begin : unpipelined_save_dest_id
         assign save_dest_id = cmd_sink_valid & ~(suppress_change_dest_id | suppress_max_outstanding) & in_nonposted_cmd;
      end
   endgenerate

   always @(posedge clk, posedge reset) begin
      if (reset) begin
         last_dest_id   <= 0;
         last_channel   <= 0;
         was_write      <= 0;
      end
      else if (save_dest_id) begin
         last_dest_id   <= dest_id;
         last_channel   <= cmd_sink_channel;
         was_write      <= is_write;
      end
   end

   assign dest_id = cmd_sink_data[PKT_DEST_ID_H:PKT_DEST_ID_L];
   assign is_write = cmd_sink_data[PKT_TRANS_WRITE];
   assign stage1_dest_changed = (last_dest_id != dest_id);
   assign stage1_trans_changed = (was_write != is_write);

   assign stage1_payload = {
      cmd_sink_data, 
      cmd_sink_channel,
      cmd_sink_startofpacket,
      cmd_sink_endofpacket,
      stage1_dest_changed,
      stage1_trans_changed };
      
   // -----------------------------------------------------
   // (Optional) pipeline between input and output
   // -----------------------------------------------------
   wire                    stage2_valid;
   reg                     stage2_ready;
   wire [PAYLOAD_W-1 : 0]  stage2_payload;
   
   generate
      if (PIPELINED == 1) begin : pipelined_limiter
         altera_avalon_st_pipeline_base
         #(
            .BITS_PER_SYMBOL(PAYLOAD_W)
         ) stage1_pipe (
            .clk        (clk),
            .reset      (reset),
            .in_ready   (cmd_sink_ready),
            .in_valid   (cmd_sink_valid),
            .in_data    (stage1_payload),
            .out_valid  (stage2_valid),
            .out_ready  (stage2_ready),
            .out_data   (stage2_payload)
         );
      end else begin : unpipelined_limiter
         assign stage2_valid   = cmd_sink_valid;
         assign stage2_payload = stage1_payload;
         assign cmd_sink_ready = stage2_ready;
      end
   endgenerate

   // -----------------------------------------------------
   // Output Stage
   // -----------------------------------------------------
   wire [ST_DATA_W-1 : 0]  stage2_data;
   wire [ST_CHANNEL_W-1:0] stage2_channel;
   wire                    stage2_startofpacket;
   wire                    stage2_endofpacket;
   wire                    stage2_dest_changed;               
   wire                    stage2_trans_changed;               
   reg                     has_pending_responses;
   reg [COUNTER_W-1 : 0]   pending_response_count;
   reg [COUNTER_W-1 : 0]   next_pending_response_count;
   wire                    nonposted_cmd;
   wire                    nonposted_cmd_accepted;
   wire                    response_accepted;
   wire                    response_sink_accepted;
   wire                    response_src_accepted;
   wire                    count_is_1;
   wire                    count_is_0;
   reg                     internal_valid;
   wire [VALID_WIDTH-1:0]  wide_valid;

   assign { stage2_data, 
      stage2_channel,
      stage2_startofpacket,
      stage2_endofpacket,
      stage2_dest_changed,
      stage2_trans_changed } = stage2_payload;

   generate if (PREVENT_HAZARDS == 1) begin : stage2_nonposted_block
      assign nonposted_cmd = 1'b1;
   end else begin
      assign nonposted_cmd = (stage2_data[PKT_TRANS_POSTED] == 0);
   end
   endgenerate

   assign nonposted_cmd_accepted = nonposted_cmd && internal_valid && (cmd_src_ready && cmd_src_endofpacket);

   // -----------------------------------------------------------------------------
   // Use the sink's control signals here, because write responses may be dropped
   // when hazard prevention is on.
   //
   // When case REORDER, move all side to rsp_source as all packets from rsp_sink will 
   // go in the reorder memory.
   // One special case when PREVENT_HAZARD is on, need to use reorder_memory_valid
   // as the rsp_source will drop
   // -----------------------------------------------------------------------------
   
   assign response_sink_accepted = rsp_sink_valid && rsp_sink_ready && rsp_sink_endofpacket;
   // Avoid Qis warning when incase, no REORDER, the signal reorder_mem_valid is not in used.
   wire   reorder_mem_out_valid;
   wire   reorder_mem_valid;
   generate 
      if (REORDER) begin
         assign reorder_mem_out_valid = reorder_mem_valid;
      end else begin
         assign reorder_mem_out_valid = '0;
      end
   endgenerate

   assign response_src_accepted = reorder_mem_out_valid & rsp_src_ready & rsp_src_endofpacket;
   assign response_accepted = (REORDER == 1) ? response_src_accepted : response_sink_accepted;
   
   always @* begin
      next_pending_response_count = pending_response_count;

      if (nonposted_cmd_accepted)
         next_pending_response_count = pending_response_count + 1'b1;
      if (response_accepted)
         next_pending_response_count = pending_response_count - 1'b1;
      if (nonposted_cmd_accepted && response_accepted)
         next_pending_response_count = pending_response_count;
   end

   assign count_is_1 = (pending_response_count == 1);
   assign count_is_0 = (pending_response_count == 0);
   // ------------------------------------------------------------------
   // count_max_reached : count if maximum command reach to backpressure
   // ------------------------------------------------------------------
   reg count_max_reached;
   always @(posedge clk, posedge reset) begin
      if (reset) begin
         pending_response_count <= 0;
         has_pending_responses <= 0;
         count_max_reached     <= 0;
      end
      else begin
         pending_response_count <= next_pending_response_count;
         // synthesis translate_off
         if (count_is_0 && response_accepted) 
            $display("%t: %m: Error: unexpected response: pending_response_count underflow", $time());
         // synthesis translate_on
         has_pending_responses <= has_pending_responses 
            && ~(count_is_1 && response_accepted && ~nonposted_cmd_accepted)
            || (count_is_0 && nonposted_cmd_accepted && ~response_accepted);
            count_max_reached <= (next_pending_response_count == MAX_OUTSTANDING_RESPONSES);
         
      end
   end

   wire suppress_prevent_harzard_for_particular_destid;
   wire this_destid_trans_changed;
   genvar j;
   generate
      if (REORDER) begin: fifo_dest_id_write_read_control_reorder_on
         wire [COUNTER_W - 1 : 0]    current_trans_seq_of_this_destid;
         wire [MAX_DEST_ID - 1 : 0]  current_trans_seq_of_this_destid_valid;
         wire [MAX_DEST_ID - 1 : 0]  responses_arrived;
         reg [COUNTER_W - 1:0]       trans_sequence;
         wire [MAX_DEST_ID - 1 : 0]  trans_sequence_we;
         
         wire [COUNTER_W : 0]        trans_sequence_plus_trans_type;
         wire                        current_trans_type_of_this_destid;
         wire [COUNTER_W : 0]        current_trans_seq_of_this_destid_plus_trans_type [MAX_DEST_ID];
         // ------------------------------------------------------------
         // Control write trans_sequence to fifos
         //
         // 1. when command accepted, read destid from command packet, 
         //     write this id to the fifo (each fifo for each desitid)  
         // 2. when response acepted, read the destid from response packet,
         //     will know which sequence of this response, write it to
         //     correct segment in memory.
         //     what if two commands go to same slave, the two sequences
         //     go time same fifo, this even helps us to maintain order
         //     when two commands same thread to one slave.
         // -----------------------------------------------------------
         wire [DEST_ID_W - 1 : 0]   rsp_sink_dest_id; 
         wire [DEST_ID_W - 1 : 0]   cmd_dest_id;
         assign rsp_sink_dest_id = rsp_sink_data[PKT_SRC_ID_H : PKT_SRC_ID_L];
         
         // write in fifo the trans_sequence and type of transaction
         assign trans_sequence_plus_trans_type = {stage2_data[PKT_TRANS_WRITE], trans_sequence};

         // read the cmd_dest_id from output of pipeline stage so that either
         // or not, it wont affect how we write to fifo
         assign cmd_dest_id = stage2_data[PKT_DEST_ID_H : PKT_DEST_ID_L];
         // -------------------------------------
         // Get the transaction_seq for that dest_id
         // -------------------------------------
         wire [COUNTER_W - 1: 0]    trans_sequence_rsp;
         wire [COUNTER_W : 0]       trans_sequence_rsp_plus_trans_type;
         wire [COUNTER_W - 1: 0]    trans_sequence_rsp_this_destid_waiting;
         wire [COUNTER_W : 0]       sequence_and_trans_type_this_destid_waiting;
         wire                         trans_sequence_rsp_this_destid_waiting_valid;
         assign trans_sequence_rsp_plus_trans_type = current_trans_seq_of_this_destid_plus_trans_type[rsp_sink_dest_id];
         assign trans_sequence_rsp                 = trans_sequence_rsp_plus_trans_type[COUNTER_W - 1: 0];

         // do I need to check if this fifo is valid, it should be always valid, unless a command not yet sent
         // and response comes back which means something weird happens.
         // It is worth to do an assertion but now to avoid QIS warning, just do as normal ST handshaking
         // check valid and ready
         
         for (j = 0; j < MAX_DEST_ID; j = j+1) 
            begin : write_and_read_trans_sequence
               assign trans_sequence_we[j] = (cmd_dest_id == j) && nonposted_cmd_accepted;
               assign responses_arrived[j] = (rsp_sink_dest_id == j) && response_sink_accepted;
            end
   
         // --------------------------------------------------------------------
         // This is array of fifos, which will be created base on how many slaves
         // that this master can see (max dest_id_width)
         // Each fifo, will store the trans_sequence, which go to that slave
         // On the response path, based in the response from which slave
         // the fifo of that slave will be read, to check the sequences.
         // and this sequence is the write address to the memory
         // -----------------------------------------------------------------------------------
         // There are 3 sequences run around the limiter, they have a relationship
         // And this is how the key point of reorder work:
         // 
         // trans_sequence      : command sequence, each command go thru the limiter
         //                   will have a sequence to show their order. A simple 
         //                   counter from 0 go up and repeat.      
         // trans_sequence_rsp   : response sequence, each response that go back to limiter,
         //                   will be read from trans_fifos to know their sequence.
         // expect_trans_sequence : Expected sequences for response that the master is waiting
         //                   The limiter will hold this sequence and wait until exactly response
         //                   for this sequence come back (trans_sequence_rsp)
         //                   aka: if trans_sequence_rsp back is same as expect_trans_sequence
         //                   then it is correct order, else response store in memory and
         //                   send out to master later, when expect_trans_sequence match.
         // ------------------------------------------------------------------------------------
         for (j = 0;j < MAX_DEST_ID; j = j+1) begin : trans_sequence_per_fifo
            altera_avalon_sc_fifo 
                #(
                  .SYMBOLS_PER_BEAT   (1),
                  .BITS_PER_SYMBOL    (COUNTER_W + 1), // one bit extra to store type of transaction
                  .FIFO_DEPTH         (MAX_OUTSTANDING_RESPONSES),
                  .CHANNEL_WIDTH      (0),
                  .ERROR_WIDTH        (0),
                  .USE_PACKETS        (0),
                  .USE_FILL_LEVEL     (0),
                  .EMPTY_LATENCY      (1),
                  .USE_MEMORY_BLOCKS  (0),
                  .USE_STORE_FORWARD  (0),
                  .USE_ALMOST_FULL_IF (0),
                  .USE_ALMOST_EMPTY_IF (0)
                  ) dest_id_fifo 
                (
                 .clk            (clk),
                 .reset          (reset),
                 .in_data         (trans_sequence_plus_trans_type),
                 .in_valid        (trans_sequence_we[j]),
                 .in_ready        (),     
                 .out_data        (current_trans_seq_of_this_destid_plus_trans_type[j]),
                 .out_valid       (current_trans_seq_of_this_destid_valid[j]),
                 .out_ready       (responses_arrived[j]),
                 .csr_address      (2'b00),                        // (terminated)
                 .csr_read        (1'b0),                         // (terminated)
                 .csr_write       (1'b0),                         // (terminated)
                 .csr_readdata     (),                            // (terminated)
                 .csr_writedata    (32'b00000000000000000000000000000000), // (terminated)
                 .almost_full_data (),                            // (terminated)
                 .almost_empty_data (),                            // (terminated)
                 .in_startofpacket (1'b0),                         // (terminated)
                 .in_endofpacket   (1'b0),                         // (terminated)
                 .out_startofpacket (),                            // (terminated)
                 .out_endofpacket   (),                            // (terminated)
                 .in_empty        (1'b0),                         // (terminated)
                 .out_empty       (),                            // (terminated)
                 .in_error        (1'b0),                         // (terminated)
                 .out_error       (),                            // (terminated)
                 .in_channel      (1'b0),                         // (terminated)
                 .out_channel      ()                             // (terminated)
                 );
         end // block: trans_sequence_per_fifo
      
         // -------------------------------------------------------
         // Calculate the transaction sequence, just simple increase
         // when each commands pass by
         // --------------------------------------------------------
         always @(posedge clk or posedge reset) 
            begin
               if (reset) begin
                  trans_sequence   <= '0;
               end else begin
                  if (nonposted_cmd_accepted) 
                     trans_sequence <= ( (trans_sequence + 1'b1) == MAX_OUTSTANDING_RESPONSES) ? '0 : trans_sequence + 1'b1;
               end
            end
   
         // -------------------------------------
         // Control Memory for reorder responses 
         // -------------------------------------
         wire [COUNTER_W - 1 : 0] next_rd_trans_sequence;
         reg [COUNTER_W - 1 : 0] rd_trans_sequence;
         reg [COUNTER_W - 1 : 0] next_expected_trans_sequence;
         reg [COUNTER_W - 1 : 0] expect_trans_sequence;
         wire [ST_DATA_W - 1 : 0]        reorder_mem_data;
         wire [ST_CHANNEL_W - 1 : 0]      reorder_mem_channel;
         wire                       reorder_mem_startofpacket;
         wire                       reorder_mem_endofpacket;
         wire                        reorder_mem_ready;
         // -------------------------------------------
         // Data to write and read from reorder memory
         // Store everything includes channel, sop, eop
         // -------------------------------------------
         reg [MEM_W - 1 : 0]       mem_in_rsp_sink_data;
         reg [MEM_W - 1 : 0]       reorder_mem_out_data;
         always_comb
            begin
               mem_in_rsp_sink_data = {rsp_sink_data, rsp_sink_channel, rsp_sink_startofpacket, rsp_sink_endofpacket};
            end
   
         assign next_rd_trans_sequence = ((rd_trans_sequence + 1'b1) == MAX_OUTSTANDING_RESPONSES) ? '0 : rd_trans_sequence + 1'b1;
         assign next_expected_trans_sequence = ((expect_trans_sequence + 1'b1) == MAX_OUTSTANDING_RESPONSES) ? '0 : expect_trans_sequence + 1'b1;
   
         always_ff @(posedge clk, posedge reset)
            begin
               if (reset) begin
                  rd_trans_sequence    <= '0;
                  expect_trans_sequence <= '0;
               end else begin
                  if (rsp_src_ready && reorder_mem_valid) begin
                     if (reorder_mem_endofpacket == 1) begin //endofpacket
                        expect_trans_sequence <= next_expected_trans_sequence;
                        rd_trans_sequence    <= next_rd_trans_sequence;
                     end
                  end
               end
            end // always_ff @
   
         // For PREVENT_HAZARD, 
         // Case: Master Write to S0, read S1, and Read S0 back but if Write for S0
         // not yet return then we need to backpressure this, else read S0 might take over write 
         // This is more checking after the fifo destid, as read S1 is inserted in midle
         // when see new packet, try to look at the fifo for that slave id, check if it
         // type of transaction
         assign sequence_and_trans_type_this_destid_waiting = current_trans_seq_of_this_destid_plus_trans_type[cmd_dest_id];
         assign current_trans_type_of_this_destid = sequence_and_trans_type_this_destid_waiting[COUNTER_W];
         assign trans_sequence_rsp_this_destid_waiting_valid = current_trans_seq_of_this_destid_valid[cmd_dest_id];
         // it might waiting other sequence, check if different type of transaction as only for PREVENT HAZARD
         // if comming comamnd to one slave and this slave is still waiting for response from previous command
         // which has diiferent type of transaction, we back-pressure this command to avoid HAZARD
         assign suppress_prevent_harzard_for_particular_destid = (current_trans_type_of_this_destid != is_write) & trans_sequence_rsp_this_destid_waiting_valid;
         
         // -------------------------------------
         // Memory for reorder buffer
         // -------------------------------------
         altera_merlin_reorder_memory 
            #(
              .DATA_W     (MEM_W),
              .ADDR_H_W   (COUNTER_W),
              .ADDR_L_W   (MAX_BURST_LENGTH),
              .NUM_SEGMENT (MAX_OUTSTANDING_RESPONSES),
              .DEPTH      (MEM_DEPTH)
              ) reorder_memory 
               (
                .clk          (clk),
                .reset        (reset),              
                .in_data      (mem_in_rsp_sink_data),
                .in_valid     (rsp_sink_valid),
                .in_ready     (reorder_mem_ready),
                .out_data     (reorder_mem_out_data),
                .out_valid    (reorder_mem_valid),              
                .out_ready    (rsp_src_ready),              
                .wr_segment   (trans_sequence_rsp),
                .rd_segment   (expect_trans_sequence)             
                );
         // -------------------------------------
         // Output from reorder buffer
         // -------------------------------------
         assign reorder_mem_data = reorder_mem_out_data[MEM_W -1 : ST_CHANNEL_W + 2];
         assign reorder_mem_channel = reorder_mem_out_data[ST_CHANNEL_W + 2 - 1 : 2];
         assign reorder_mem_startofpacket = reorder_mem_out_data[1];
         assign reorder_mem_endofpacket = reorder_mem_out_data[0];

         // -------------------------------------
         // Because use generate statment
         // so move all rsp_src_xxx controls here
         // -------------------------------------
         always_comb begin
            cmd_src_data            = stage2_data;
            rsp_src_valid           = reorder_mem_valid;
            rsp_src_data            = reorder_mem_data;
            rsp_src_channel         = reorder_mem_channel;
            rsp_src_startofpacket   = reorder_mem_startofpacket;
            rsp_src_endofpacket     = reorder_mem_endofpacket;
            // -------------------------------------
            // Forces commands to be non-posted if hazard prevention
            // is on, also drops write responses
            // -------------------------------------
            rsp_sink_ready       = reorder_mem_ready; // now it takes ready signal from the memory not direct from master
            if (PREVENT_HAZARDS == 1) begin
               cmd_src_data[PKT_TRANS_POSTED] = 1'b0;
               
               if (rsp_src_data[PKT_TRANS_WRITE] == 1'b1 && SUPPORTS_POSTED_WRITES == 1 && SUPPORTS_NONPOSTED_WRITES == 0) begin
                  rsp_src_valid = 1'b0;
                  rsp_sink_ready = 1'b1;
               end
            end
         end // always_comb

      end // block: fifo_dest_id_write_read_control_reorder_on
   endgenerate
   
   // -------------------------------------
   // Pass-through command and response
   // -------------------------------------

   always_comb 
      begin
         cmd_src_channel         = stage2_channel;
         cmd_src_startofpacket   = stage2_startofpacket;
         cmd_src_endofpacket     = stage2_endofpacket;
      end // always_comb
   
   // -------------------------------------
   // When there is no REORDER requirement
   // Just pass through signals
   // -------------------------------------
   generate
      if (!REORDER) begin : use_selector_or_pass_thru_rsp
         always_comb begin
            cmd_src_data            = stage2_data;
            // pass thru almost signals
            rsp_src_valid           = rsp_sink_valid;
            rsp_src_data            = rsp_sink_data;
            rsp_src_channel         = rsp_sink_channel;
            rsp_src_startofpacket   = rsp_sink_startofpacket;
            rsp_src_endofpacket     = rsp_sink_endofpacket;
            // -------------------------------------
            // Forces commands to be non-posted if hazard prevention
            // is on, also drops write responses
            // -------------------------------------
            rsp_sink_ready = rsp_src_ready; // take care this, should check memory empty
            if (PREVENT_HAZARDS == 1) begin
               cmd_src_data[PKT_TRANS_POSTED] = 1'b0;

               if (rsp_sink_data[PKT_TRANS_WRITE] == 1'b1 && SUPPORTS_POSTED_WRITES == 1 && SUPPORTS_NONPOSTED_WRITES == 0) begin
                  rsp_src_valid = 1'b0;
                  rsp_sink_ready = 1'b1;
               end
            end
         end // always_comb
      end // if (!REORDER)
   endgenerate

   // --------------------------------------------------------
   // Backpressure & Suppression
   // --------------------------------------------------------
   // ENFORCE_ORDER: unused option, always is 1, remove it
   // Now the limiter will suppress when max_outstanding reach
   // --------------------------------------------------------
   generate
      if (ENFORCE_ORDER) begin : enforce_order_block
         assign suppress_change_dest_id = (REORDER == 1) ? 1'b0 : nonposted_cmd && has_pending_responses && 
                                   (stage2_dest_changed || (PREVENT_HAZARDS == 1 && stage2_trans_changed));
      end else begin : no_order_block
         assign suppress_change_dest_id = 1'b0;
      end
   endgenerate

   // ------------------------------------------------------------
   // Even we allow change slave while still have pending responses
   // But one special case, when PREVENT_HAZARD=1, we still allow
   // switch slave while type of transaction change (RAW, WAR) but
   // only to different slaves.
   // if to same slave, we still need back pressure that to make
   // sure no racing
   // ------------------------------------------------------------

   generate
      if (REORDER) begin : prevent_hazard_block
         assign suppress_change_trans_but_not_dest = nonposted_cmd && has_pending_responses && 
                                          !stage2_dest_changed && (PREVENT_HAZARDS == 1 && stage2_trans_changed);
      end else begin : no_hazard_block
         assign suppress_change_trans_but_not_dest = 1'b0; // no REORDER, the suppress_changes_destid take care of this.
      end
   endgenerate
   
   generate
      if (REORDER) begin : prevent_hazard_block_for_particular_slave
         assign suppress_change_trans_for_one_slave = nonposted_cmd && has_pending_responses && (PREVENT_HAZARDS == 1 && suppress_prevent_harzard_for_particular_destid);
      end else begin : no_hazard_block_for_particular_slave
         assign suppress_change_trans_for_one_slave = 1'b0; // no REORDER, the suppress_changes_destid take care of this.
      end
   endgenerate
   
   // ------------------------------------------
   // Backpressure when max outstanding transactions are reached
   // ------------------------------------------
   generate
      if (REORDER) begin : max_outstanding_block
         assign suppress_max_outstanding = count_max_reached;
      end else begin
         assign suppress_max_outstanding = 1'b0;
      end
   endgenerate

   assign suppress = suppress_change_trans_for_one_slave | suppress_change_dest_id | suppress_max_outstanding;
   assign wide_valid = { VALID_WIDTH {stage2_valid} } & stage2_channel;

   always @* begin
      stage2_ready = cmd_src_ready;
      internal_valid = stage2_valid;
      // --------------------------------------------------------
      // change suppress condidtion, in case REODER it will alllow changing slave
      // even still have pending transactions.
      // -------------------------------------------------------
      if (suppress) begin
         stage2_ready = 0;
         internal_valid = 0;
      end

      if (VALID_WIDTH == 1) begin
         cmd_src_valid = {VALID_WIDTH{1'b0}};
         cmd_src_valid[0] = internal_valid;
      end else begin
         // -------------------------------------
         // Use the one-hot channel to determine if the destination
         // has changed. This results in a wide valid bus
         // -------------------------------------
         cmd_src_valid = wide_valid;
         if (nonposted_cmd & has_pending_responses) begin
            if (!REORDER) begin
               cmd_src_valid = wide_valid & last_channel;
               // -------------------------------------
               // Mask the valid signals if the transaction type has changed
               // if hazard prevention is enabled
               // -------------------------------------
               if (PREVENT_HAZARDS == 1)
                  cmd_src_valid = wide_valid & last_channel & { VALID_WIDTH {!stage2_trans_changed} };
            end else begin // else: !if(!REORDER) if REORDER happen
               if (PREVENT_HAZARDS == 1)
                  cmd_src_valid = wide_valid & { VALID_WIDTH {!suppress_change_trans_for_one_slave} };
               if (suppress_max_outstanding) begin
                  cmd_src_valid = {VALID_WIDTH {1'b0}};
               end

            end 
         end
      end
   end
   
   // --------------------------------------------------
   // Calculates the log2ceil of the input value.
   //
   // This function occurs a lot... please refactor.
   // --------------------------------------------------
   function integer log2ceil;
      input integer val;
      integer i;

      begin
         i = 1;
         log2ceil = 0;

         while (i < val) begin
            log2ceil = log2ceil + 1;
            i = i << 1;
         end
      end
   endfunction

endmodule


