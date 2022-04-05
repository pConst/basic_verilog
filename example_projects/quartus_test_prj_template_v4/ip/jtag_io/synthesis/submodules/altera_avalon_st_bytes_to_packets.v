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
//| Avalon ST Bytes to Packet
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module altera_avalon_st_bytes_to_packets
//if ENCODING ==0, CHANNEL_WIDTH must be 8 
//else CHANNEL_WIDTH can be from 0 to 127
#(    parameter CHANNEL_WIDTH = 8,
      parameter ENCODING      = 0 ) 
(
      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST out with packets
      input              out_ready,
      output reg         out_valid,
      output reg [7: 0]  out_data,
      output reg [CHANNEL_WIDTH-1: 0]  out_channel,
      output reg         out_startofpacket,
      output reg         out_endofpacket,

      // Interface: ST in 
      output reg         in_ready,
      input              in_valid,
      input      [7: 0]  in_data
);

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  received_esc, received_channel, received_varchannel;
   wire escape_char, sop_char, eop_char, channel_char, varchannelesc_char;

   // data out mux.  
   // we need it twice (data & channel out), so use a wire here 
   wire [7:0] data_out;

   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign sop_char     = (in_data == 8'h7a);
   assign eop_char     = (in_data == 8'h7b);
   assign channel_char = (in_data == 8'h7c);
   assign escape_char  = (in_data == 8'h7d);

   assign data_out = received_esc ? (in_data ^ 8'h20) : in_data;

generate
if (CHANNEL_WIDTH == 0) begin
    // Synchorous block -- reset and registers 
    always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         received_esc      <= 0;
         out_startofpacket <= 0;
         out_endofpacket   <= 0;
      end else begin
         // we take data when in_valid and in_ready
         if (in_valid & in_ready) begin
            if (received_esc) begin
               //if we got esc char, after next byte is consumed, quit esc mode
               if (out_ready) received_esc <= 0;
            end else begin
               if (escape_char)    received_esc      <= 1;
               if (sop_char)       out_startofpacket <= 1;
               if (eop_char)       out_endofpacket   <= 1;
            end
            if (out_ready  & out_valid) begin
               out_startofpacket <= 0;
               out_endofpacket   <= 0;
            end 
         end
      end
   end

   // Combinational block for in_ready and out_valid
   always @* begin
      //we choose not to pipeline here.  We can process special characters when
      //in_ready, but in a chain of microcores, backpressure path is usually
      //time critical, so we keep it simple here.
      in_ready = out_ready;

      //out_valid when in_valid, except when we are processing the special
      //characters.  However, if we are in escape received mode, then we are
      //valid
      out_valid = 0;
      if ((out_ready | ~out_valid) && in_valid) begin
         out_valid = 1;
            if (sop_char | eop_char | escape_char | channel_char) out_valid = 0;
      end
      out_data = data_out; 
   end

end else begin
    assign varchannelesc_char = in_data[7];
    // Synchorous block -- reset and registers 
    always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         received_esc <= 0;
         received_channel <= 0;
         received_varchannel <= 0;
         out_startofpacket <= 0;
         out_endofpacket <= 0;
      end else begin
         // we take data when in_valid and in_ready
         if (in_valid & in_ready) begin
            if (received_esc) begin
               //if we got esc char, after next byte is consumed, quit esc mode
               if (out_ready | received_channel | received_varchannel) received_esc <= 0;
            end else begin
               if (escape_char)                received_esc        <= 1;
               if (sop_char)                   out_startofpacket   <= 1;
               if (eop_char)                   out_endofpacket     <= 1;
               if (channel_char & ENCODING )   received_varchannel <= 1;
               if (channel_char & ~ENCODING)   received_channel    <= 1;
            end
            if (received_channel & (received_esc | (~sop_char & ~eop_char & ~escape_char & ~channel_char ))) begin
               received_channel <= 0;
            end
            if (received_varchannel & ~varchannelesc_char & (received_esc | (~sop_char & ~eop_char & ~escape_char & ~channel_char))) begin
               received_varchannel <= 0;
            end
            if (out_ready  & out_valid) begin
               out_startofpacket <= 0;
               out_endofpacket <= 0;
            end 
         end
      end
   end

   // Combinational block for in_ready and out_valid
   always @* begin
      in_ready = out_ready;
      out_valid = 0;
      if ((out_ready | ~out_valid) && in_valid) begin
         out_valid = 1;
         if (received_esc) begin 
           if (received_channel | received_varchannel) out_valid = 0;
         end else begin
            if (sop_char | eop_char | escape_char | channel_char | received_channel | received_varchannel) out_valid = 0;
         end
      end
      out_data = data_out; 
   end
end 

endgenerate

// Channel block
generate
if (CHANNEL_WIDTH == 0) begin    
   always @(posedge clk) begin
      out_channel <= 'h0;
   end

end else if (CHANNEL_WIDTH < 8) begin
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         out_channel <= 'h0;
      end else begin
         if (in_ready & in_valid) begin
            if ((channel_char & ENCODING) & (~received_esc & ~sop_char & ~eop_char & ~escape_char )) begin
               out_channel <= 'h0;
            end else if (received_varchannel & (received_esc | (~sop_char & ~eop_char & ~escape_char & ~channel_char  & ~received_channel))) begin
               // Shifting out only the required bits
               out_channel[CHANNEL_WIDTH-1:0] <= data_out[CHANNEL_WIDTH-1:0];
            end
         end
      end
   end

end else begin   
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         out_channel <= 'h0;
      end else begin
         if (in_ready & in_valid) begin
            if (received_channel & (received_esc | (~sop_char & ~eop_char & ~escape_char & ~channel_char))) begin
               out_channel <= data_out;
            end else if ((channel_char & ENCODING) & (~received_esc & ~sop_char & ~eop_char & ~escape_char )) begin
               // Variable Channel Encoding always setting to 0 before begin to shift the channel in
               out_channel <= 'h0;
            end else if (received_varchannel & (received_esc | (~sop_char & ~eop_char & ~escape_char & ~channel_char  & ~received_channel))) begin
                // Shifting out the lower 7 bits
                out_channel <= out_channel <<7;
                out_channel[6:0] <= data_out[6:0];
            end
         end
      end
   end
   
end
endgenerate

endmodule
