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


// --------------------------------------------------------------------------------
//| Avalon ST Packets to Bytes Component
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_packets_to_bytes
//if ENCODING ==0, CHANNEL_WIDTH must be 8 
//else CHANNEL_WIDTH can be from 0 to 127
#(    parameter CHANNEL_WIDTH = 8,
      parameter ENCODING      = 0) 
(
      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST in with packets
      output reg         in_ready,
      input              in_valid,
      input      [7: 0]  in_data,
      input      [CHANNEL_WIDTH-1: 0]  in_channel,
      input              in_startofpacket,
      input              in_endofpacket,

      // Interface: ST out
      input              out_ready,
      output reg         out_valid,
      output reg [7: 0]  out_data
);

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   localparam CHN_COUNT = (CHANNEL_WIDTH-1)/7;
   localparam CHN_EFFECTIVE = CHANNEL_WIDTH-1;
   reg  sent_esc, sent_sop, sent_eop;
   reg  sent_channel_char, channel_escaped, sent_channel;
   reg  [CHANNEL_WIDTH:0] stored_channel;
   reg  [4:0] channel_count;
   reg    [((CHN_EFFECTIVE/7+1)*7)-1:0] stored_varchannel;
   reg     channel_needs_esc;



   wire need_sop, need_eop, need_esc, need_channel;

   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign need_esc = (in_data === 8'h7a |
                      in_data === 8'h7b |
                      in_data === 8'h7c |
                      in_data === 8'h7d );
   assign need_eop = (in_endofpacket);
   assign need_sop = (in_startofpacket);


generate
if( CHANNEL_WIDTH > 0) begin
   wire   channel_changed;
   assign channel_changed = (in_channel != stored_channel);
   assign need_channel = (need_sop | channel_changed);

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         sent_esc <= 0;
         sent_sop <= 0;
         sent_eop <= 0;
         sent_channel <= 0;
         channel_escaped <= 0;
         sent_channel_char <= 0;
         out_data <= 0;
         out_valid <= 0;
         channel_count <= 0;
         channel_needs_esc <= 0;
      end else begin

         if (out_ready )
           out_valid <= 0;

         if ((out_ready | ~out_valid) && in_valid  )
           out_valid <= 1;

         if ((out_ready | ~out_valid) && in_valid) begin
            if (need_channel & ~sent_channel) begin
                 if (~sent_channel_char) begin
                    sent_channel_char <= 1;
                    out_data <= 8'h7c;
                    channel_count <= CHN_COUNT[4:0];
                    stored_varchannel <= in_channel;
                    if ((ENCODING == 0) | (CHANNEL_WIDTH == 7)) begin
                    channel_needs_esc <= (in_channel == 8'h7a |
                                          in_channel == 8'h7b |
                                          in_channel == 8'h7c |
                                          in_channel == 8'h7d );
                    end
                 end else if (channel_needs_esc & ~channel_escaped) begin
                    out_data <= 8'h7d;
                    channel_escaped <= 1;
                 end else if (~sent_channel) begin
                       if (ENCODING) begin
                            // Sending out MSB=1, while not last 7 bits of Channel
                               if (channel_count > 0) begin
                                   if (channel_needs_esc) out_data <= {1'b1, stored_varchannel[((CHN_EFFECTIVE/7+1)*7)-1:((CHN_EFFECTIVE/7+1)*7)-7]} ^ 8'h20;
                                   else                   out_data <= {1'b1, stored_varchannel[((CHN_EFFECTIVE/7+1)*7)-1:((CHN_EFFECTIVE/7+1)*7)-7]};
                                   stored_varchannel <= stored_varchannel<<7;

                                   channel_count <= channel_count - 1'b1;
                                   // check whether the last 7 bits need escape or not
                                   if (channel_count ==1 & CHANNEL_WIDTH > 7) begin
                                      channel_needs_esc <=
                                         ((stored_varchannel[((CHN_EFFECTIVE/7+1)*7)-8:((CHN_EFFECTIVE/7+1)*7)-14]  == 7'h7a)|
                                         (stored_varchannel[((CHN_EFFECTIVE/7+1)*7)-8:((CHN_EFFECTIVE/7+1)*7)-14] == 7'h7b) |
                                         (stored_varchannel[((CHN_EFFECTIVE/7+1)*7)-8:((CHN_EFFECTIVE/7+1)*7)-14] == 7'h7c) |
                                         (stored_varchannel[((CHN_EFFECTIVE/7+1)*7)-8:((CHN_EFFECTIVE/7+1)*7)-14] == 7'h7d) );
                                   end
                              end else begin
                               // Sending out MSB=0, last 7 bits of Channel
                                   if (channel_needs_esc) begin 
                                      channel_needs_esc <= 0; 
                                      out_data <= {1'b0, stored_varchannel[((CHN_EFFECTIVE/7+1)*7)-1:((CHN_EFFECTIVE/7+1)*7)-7]} ^ 8'h20;
                                   end else   out_data <= {1'b0, stored_varchannel[((CHN_EFFECTIVE/7+1)*7)-1:((CHN_EFFECTIVE/7+1)*7)-7]};
                                   sent_channel <= 1;
                              end
                       end else begin
                            if (channel_needs_esc) begin 
                               channel_needs_esc <= 0; 
                               out_data <= in_channel ^ 8'h20; 
                            end else out_data <= in_channel;
                            sent_channel <= 1;
                       end
                 end
            end else if (need_sop & ~sent_sop) begin
                 sent_sop <= 1;
                 out_data <= 8'h7a;

            end else if (need_eop & ~sent_eop) begin
                 sent_eop <= 1;
                 out_data <= 8'h7b;

            end else if (need_esc & ~sent_esc) begin
                 sent_esc <= 1;
                 out_data <= 8'h7d;
            end else begin
                 if (sent_esc)    out_data <= in_data ^ 8'h20;
                 else             out_data <= in_data;
                 sent_esc <= 0;
                 sent_sop <= 0;
                 sent_eop <= 0;
                 sent_channel <= 0;
                 channel_escaped <= 0;
                 sent_channel_char <= 0;
            end
         end
      end
   end

   //channel related signals
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         //extra bit in stored_channel to force reset
         stored_channel <= {CHANNEL_WIDTH{1'b1}};
      end else begin
         //update stored_channel only when it is sent out
         if (sent_channel) stored_channel <= in_channel;
      end
   end
    always @* begin

      // in_ready.  Low when:
      // back pressured, or when
      // we are outputting a control character, which means that one of
      // {escape_char, start of packet, end of packet, channel}
      // needs to be, but has not yet, been handled.
      in_ready = (out_ready | !out_valid) & in_valid & (~need_esc | sent_esc)
                 & (~need_sop | sent_sop)
                 & (~need_eop | sent_eop)
                 & (~need_channel | sent_channel);
   end

end else begin

assign need_channel = (need_sop);

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         sent_esc <= 0;
         sent_sop <= 0;
         sent_eop <= 0;
         out_data <= 0;
         out_valid <= 0;
         sent_channel <= 0;
         sent_channel_char <= 0;
      end else begin

         if (out_ready )
           out_valid <= 0;

         if ((out_ready | ~out_valid) && in_valid  )
           out_valid <= 1;

         if ((out_ready | ~out_valid) && in_valid) begin
            if (need_channel & ~sent_channel) begin
                 if (~sent_channel_char) begin           //Added sent channel 0 before the 1st SOP
                    sent_channel_char <= 1;
                    out_data <= 8'h7c;
                 end else if (~sent_channel) begin
                    out_data <= 'h0;
                    sent_channel <= 1;
                 end
            end else if (need_sop & ~sent_sop) begin
                 sent_sop <= 1;
                 out_data <= 8'h7a;
            end else if (need_eop & ~sent_eop) begin
                 sent_eop <= 1;
                 out_data <= 8'h7b;
            end else if (need_esc & ~sent_esc) begin
                 sent_esc <= 1;
                 out_data <= 8'h7d;
            end else begin
                 if (sent_esc)    out_data <= in_data ^ 8'h20;
                 else             out_data <= in_data;
                 sent_esc <= 0;
                 sent_sop <= 0;
                 sent_eop <= 0;
            end
         end
     end
   end
   
 always @* begin
      in_ready = (out_ready | !out_valid) & in_valid & (~need_esc | sent_esc)
                 & (~need_sop | sent_sop)
                 & (~need_eop | sent_eop)
                 & (~need_channel | sent_channel);
   end
end
endgenerate

endmodule
