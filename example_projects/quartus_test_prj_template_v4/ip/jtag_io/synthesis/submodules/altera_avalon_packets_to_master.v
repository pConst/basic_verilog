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
//| Avalon ST Packets to MM Master Transaction Component
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
// --------------------------------------------------------------------------------
//| Fast Transaction Master
// --------------------------------------------------------------------------------
module altera_avalon_packets_to_master (
    // Interface: clk
      input wire             clk,
      input wire             reset_n,
      // Interface: ST in
      output wire         in_ready,
      input  wire         in_valid,
      input  wire [ 7: 0] in_data,
      input  wire         in_startofpacket,
      input  wire         in_endofpacket,

      // Interface: ST out 
      input  wire         out_ready,
      output wire         out_valid,
      output wire [ 7: 0] out_data,
      output wire         out_startofpacket,
      output wire         out_endofpacket,

      // Interface: MM out
      output wire [31: 0] address,
      input  wire [31: 0] readdata,
      output wire         read,
      output wire         write,
      output wire [ 3: 0] byteenable,
      output wire [31: 0] writedata,
      input  wire         waitrequest,
      input  wire         readdatavalid
);

    wire [ 35: 0] fifo_readdata;
    wire          fifo_read;
    wire          fifo_empty;
    wire [ 35: 0] fifo_writedata;
    wire          fifo_write;
    wire          fifo_write_waitrequest;
    
   // ---------------------------------------------------------------------
   //| Parameter Declarations
   // ---------------------------------------------------------------------
   parameter EXPORT_MASTER_SIGNALS = 0;
   parameter FIFO_DEPTHS           = 2;
   parameter FIFO_WIDTHU           = 1;
   parameter FAST_VER              = 0;
   
   generate
       if (FAST_VER) begin
            packets_to_fifo p2f (
                .clk                 (clk),
                .reset_n             (reset_n),
                .in_ready            (in_ready),
                .in_valid            (in_valid),
                .in_data             (in_data),
                .in_startofpacket    (in_startofpacket),
                .in_endofpacket      (in_endofpacket),
                .address             (address),
                .readdata            (readdata),
                .read                (read),
                .write               (write),
                .byteenable          (byteenable),
                .writedata           (writedata),
                .waitrequest         (waitrequest),
                .readdatavalid       (readdatavalid),
                .fifo_writedata      (fifo_writedata),
                .fifo_write          (fifo_write),
                .fifo_write_waitrequest (fifo_write_waitrequest)
            );
            
            fifo_to_packet f2p (
                .clk                 (clk),
                .reset_n             (reset_n),
                .out_ready           (out_ready),
                .out_valid           (out_valid),
                .out_data            (out_data),
                .out_startofpacket   (out_startofpacket),
                .out_endofpacket     (out_endofpacket),
                .fifo_readdata       (fifo_readdata),
                .fifo_read           (fifo_read),
                .fifo_empty          (fifo_empty)
            );
            
            fifo_buffer #(
                .FIFO_DEPTHS(FIFO_DEPTHS),
                .FIFO_WIDTHU(FIFO_WIDTHU)
            ) fb (
                .wrclock                          (clk),
                .reset_n                          (reset_n),
                .avalonmm_write_slave_writedata   (fifo_writedata),  
                .avalonmm_write_slave_write       (fifo_write),      
                .avalonmm_write_slave_waitrequest (fifo_write_waitrequest),
                .avalonmm_read_slave_readdata     (fifo_readdata),  
                .avalonmm_read_slave_read         (fifo_read),      
                .avalonmm_read_slave_waitrequest  (fifo_empty)
            );
       end else begin
           packets_to_master p2m (
                .clk                 (clk),
                .reset_n             (reset_n),
                .in_ready            (in_ready),
                .in_valid            (in_valid),
                .in_data             (in_data),
                .in_startofpacket    (in_startofpacket),
                .in_endofpacket      (in_endofpacket),
                .address             (address),
                .readdata            (readdata),
                .read                (read),
                .write               (write),
                .byteenable          (byteenable),
                .writedata           (writedata),
                .waitrequest         (waitrequest),
                .readdatavalid       (readdatavalid),
                .out_ready           (out_ready),
                .out_valid           (out_valid),
                .out_data            (out_data),
                .out_startofpacket   (out_startofpacket),
                .out_endofpacket     (out_endofpacket)
            );
       end
   endgenerate
endmodule

module packets_to_fifo (

      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST in
      output reg         in_ready,
      input              in_valid,
      input      [ 7: 0] in_data,
      input              in_startofpacket,
      input              in_endofpacket,

      // Interface: MM out
      output reg [31: 0] address,
      input      [31: 0] readdata,
      output reg         read,
      output reg         write,
      output reg [ 3: 0] byteenable,
      output reg [31: 0] writedata,
      input              waitrequest,
      input              readdatavalid,
      
      // Interface: FIFO
      // FIFO data format:
      // | sop, eop, [1:0]valid, [31:0]data |
      output reg [ 35: 0] fifo_writedata,
      output reg        fifo_write,
      input wire        fifo_write_waitrequest
);

   // ---------------------------------------------------------------------
   //| Command Declarations
   // ---------------------------------------------------------------------
   localparam CMD_WRITE_NON_INCR = 8'h00;
   localparam CMD_WRITE_INCR     = 8'h04;
   localparam CMD_READ_NON_INCR  = 8'h10;
   localparam CMD_READ_INCR      = 8'h14;
   
   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  [ 3: 0]  state;
   reg  [ 7: 0]  command;
   reg  [ 1: 0]  current_byte, byte_avail;
   reg  [ 15: 0] counter;
   reg  [ 31: 0] read_data_buffer;
   reg  [ 31: 0] fifo_data_buffer;
   reg           in_ready_0;
   reg           first_trans, last_trans, fifo_sop;
   reg  [ 3: 0]  unshifted_byteenable;
   wire enable;

   localparam READY           = 4'b0000,
              GET_EXTRA       = 4'b0001,
              GET_SIZE1       = 4'b0010,
              GET_SIZE2       = 4'b0011,
              GET_ADDR1       = 4'b0100,
              GET_ADDR2       = 4'b0101,
              GET_ADDR3       = 4'b0110,
              GET_ADDR4       = 4'b0111,
              GET_WRITE_DATA  = 4'b1000,
              WRITE_WAIT      = 4'b1001,
              READ_ASSERT     = 4'b1010,
              READ_CMD_WAIT   = 4'b1011,
              READ_DATA_WAIT  = 4'b1100,
              PUSH_FIFO       = 4'b1101,
              PUSH_FIFO_WAIT  = 4'b1110,
              FIFO_CMD_WAIT   = 4'b1111;
   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign enable = (in_ready & in_valid);

   always @* begin
      in_ready = in_ready_0;      
   end
   
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
            in_ready_0          <= 1'b0;
            fifo_writedata      <=  'b0;
            fifo_write          <= 1'b0;
            fifo_sop            <= 1'b0;
            read                <= 1'b0;
            write               <= 1'b0;
            byteenable          <=  'b0;
            writedata           <=  'b0;
            address             <=  'b0;
            counter             <=  'b0;
            command             <=  'b0;
            first_trans         <= 1'b0;
            last_trans          <= 1'b0;
            state               <=  'b0;
            current_byte        <=  'b0;
            read_data_buffer    <=  'b0;
            unshifted_byteenable <= 'b0;
            byte_avail          <=  'b0;
            fifo_data_buffer    <=  'b0;
      end else begin
            address[1:0]      <= 'b0;
            in_ready_0 <= 1'b0;
            
            if (counter > 3)       unshifted_byteenable <= 4'b1111;
            else if (counter == 3) unshifted_byteenable <= 4'b0111;
            else if (counter == 2) unshifted_byteenable <= 4'b0011;
            else if (counter == 1) unshifted_byteenable <= 4'b0001;

            case (state)
              READY : begin
                   in_ready_0        <= !fifo_write_waitrequest;
                   fifo_write        <= 1'b0;
              end
              GET_EXTRA : begin
                   in_ready_0        <= 1'b1;
                   byteenable        <=  'b0;
                   if (enable) state <= GET_SIZE1;
              end

              GET_SIZE1 : begin
                   in_ready_0        <= 1'b1;
                   //load counter on reads only
                   counter[15:8]     <= command[4]?in_data:8'b0;
                   if (enable) state <= GET_SIZE2;
              end

              GET_SIZE2 : begin
                   in_ready_0        <= 1'b1;
                   //load counter on reads only
                   counter[7:0]      <= command[4]?in_data:8'b0;
                   if (enable) state <= GET_ADDR1;
              end
              
              GET_ADDR1 : begin
                in_ready_0        <= 1'b1;
                first_trans       <= 1'b1;
                last_trans        <= 1'b0;
                address[31:24]    <= in_data;
                if (enable) state <= GET_ADDR2;
              end

              GET_ADDR2 : begin
                in_ready_0        <= 1'b1;
                address[23:16]    <= in_data;
                if (enable) state <= GET_ADDR3;
              end

              GET_ADDR3 : begin
                in_ready_0        <= 1'b1;
                address[15:8]     <= in_data;
                if (enable) state <= GET_ADDR4;
              end

              GET_ADDR4 : begin
                in_ready_0        <= 1'b1;
                address[7:2]      <= in_data[7:2];
                current_byte      <= in_data[1:0];
                if (enable) begin
                      if (command == CMD_WRITE_NON_INCR | command == CMD_WRITE_INCR) begin
                        state <= GET_WRITE_DATA; //writes
                        in_ready_0 <= 1'b1;
                      end
                      else if (command == CMD_READ_NON_INCR | command == CMD_READ_INCR) begin
                        state   <= READ_ASSERT; //reads
                        in_ready_0 <= 1'b0;
                      end
                      else begin
                        //nops
                        //treat all unrecognized commands as nops as well
                        in_ready_0          <= 1'b0;
                        state <= FIFO_CMD_WAIT; 
                        //| sop, eop, [1:0]valid, [31:0]data            |
                        //|  1 ,  1 ,  2'b11  ,{counter,reserved_byte}|
                        fifo_writedata[7:0] <= (8'h80 | command);
                        fifo_writedata[35:8]<= {4'b1111,counter[7:0],counter[15:8],8'b0};
                        fifo_write          <= 1'b1;    
                        counter             <= 0;
                      end
                end
              end

              GET_WRITE_DATA : begin
                        in_ready_0 <= 1'b1; 
                        if (enable) begin
                          counter <= counter + 1'b1;
                          //2 bit, should wrap by itself
                          current_byte <= current_byte + 1'b1;
                          if (in_endofpacket || current_byte == 3) 
                          begin
                             in_ready_0 <= 1'b0;
                             write      <= 1'b1;
                             state      <= WRITE_WAIT;
                          end
                        end
                        if (in_endofpacket) begin
                          last_trans <= 1'b1;
                        end
                        // handle byte writes properly
                        // drive data pins based on addresses
                        case (current_byte)
                          0: begin
                            writedata[7:0]   <= in_data;
                            byteenable[0]    <= 1'b1;
                          end
                          1: begin
                            writedata[15:8]  <= in_data;
                            byteenable[1]    <= 1'b1;
                          end
                          2: begin
                            writedata[23:16] <= in_data;
                            byteenable[2]    <= 1'b1;
                          end
                          3: begin
                            writedata[31:24] <= in_data;
                            byteenable[3]    <= 1'b1;
                          end
                        endcase
              end
              WRITE_WAIT : begin
                        in_ready_0 <= 1'b0;
                        write      <= 1'b1;
                        if (~waitrequest) begin
                           write <= 1'b0;
                           state <= GET_WRITE_DATA;
                           in_ready_0 <= 1'b1;
                           byteenable <= 'b0;
                           if (command[2] == 1'b1) begin
                              //increment address, but word-align it
                              address[31:2] <= (address[31:2] + 1'b1);
                           end
                           if (last_trans) begin
                               in_ready_0         <= 1'b0;
                               state <= FIFO_CMD_WAIT;
                               //| sop, eop, [1:0]valid, [31:0]data            |
                               //|  1 ,  1 ,  2'b11  ,{counter,reserved_byte}|
                               fifo_writedata[7:0] <= (8'h80 | command);
                               fifo_writedata[35:8]<= {4'b1111,counter[7:0],counter[15:8],8'b0};
                               fifo_write          <= 1'b1;
                               counter             <= 0;
                           end
                        end
              end
              READ_ASSERT : begin
                            if (current_byte == 3) byteenable <= unshifted_byteenable << 3;
                            if (current_byte == 2) byteenable <= unshifted_byteenable << 2;
                            if (current_byte == 1) byteenable <= unshifted_byteenable << 1;
                            if (current_byte == 0) byteenable <= unshifted_byteenable;
                            read             <= 1'b1;
                            fifo_write       <= 1'b0;
                            state            <= READ_CMD_WAIT;
              end
              READ_CMD_WAIT : begin
                        // number of valid byte
                        case (byteenable)
                            4'b0000 : byte_avail <= 1'b0;
                            4'b0001 : byte_avail <= 1'b0;
                            4'b0010 : byte_avail <= 1'b0;
                            4'b0100 : byte_avail <= 1'b0;
                            4'b1000 : byte_avail <= 1'b0;
                            4'b0011 : byte_avail <= 1'b1;
                            4'b0110 : byte_avail <= 1'b1;
                            4'b1100 : byte_avail <= 1'b1;
                            4'b0111 : byte_avail <= 2'h2;
                            4'b1110 : byte_avail <= 2'h2;
                            default : byte_avail <= 2'h3;
                        endcase
                        read_data_buffer <= readdata;
                        read             <= 1; 
                        // if readdatavalid, take the data and 
                        // go directly to READ_SEND_ISSUE.  This is for fixed
                        // latency slaves. Ignore waitrequest in this case,
                        // since this master does not issue pipelined reads.
                        //
                        // For variable latency slaves, once waitrequest is low
                        // the read command is accepted, so deassert read and
                        // go to READ_DATA_WAIT to wait for readdatavalid 
                        if (readdatavalid) begin
                           state <= PUSH_FIFO;
                           read <= 0;
                        end else begin
                           if (~waitrequest) begin
                               state <= READ_DATA_WAIT;
                               read <= 0;
                           end
                        end
              end
              READ_DATA_WAIT : begin
                        read_data_buffer <= readdata;
                        if (readdatavalid) begin
                            state <= PUSH_FIFO;
                        end
              end              
              PUSH_FIFO : begin
                        fifo_write <= 1'b0;
                        fifo_sop   <= 1'b0;
                        if (first_trans) begin
                            first_trans <= 1'b0;
                            fifo_sop    <= 1'b1;
                        end
                        case (current_byte)
                            3 : begin
                                fifo_data_buffer <= read_data_buffer >> 24;
                                counter <= counter - 1'b1;
                            end
                            2 : begin
                                fifo_data_buffer <= read_data_buffer >> 16;
                                if (counter == 1) counter <= 0;
                                else counter <= counter - 2'h2;
                            end
                            1 : begin
                                fifo_data_buffer <= read_data_buffer >> 8;
                                if (counter < 3) counter <= 0;
                                else counter <= counter - 2'h3;
                            end
                            default : begin
                                fifo_data_buffer <= read_data_buffer;
                                if (counter < 4) counter <= 0;
                                else counter <= counter - 3'h4;
                            end
                        endcase
                        current_byte <= 0;
                        state <= PUSH_FIFO_WAIT;
              end
              PUSH_FIFO_WAIT : begin
                            // pushd return packet with data
                            fifo_write     <= 1'b1;
                            fifo_writedata <= {fifo_sop,(counter == 0)?1'b1:1'b0,byte_avail,fifo_data_buffer};
                            // count down on the number of bytes to read
                            // shift current byte location within word
                            // if increment address, add it, so the next read
                            // can use it, if more reads are required
                            
                            // no more bytes to send - go to READY state
                            if (counter == 0) begin
                                state <= FIFO_CMD_WAIT;
                            end else if (command[2]== 1'b1) begin
                                    //increment address, but word-align it
                                    state <= FIFO_CMD_WAIT;
                                    address[31:2] <= (address[31:2] + 1'b1);
                            end
              end
              FIFO_CMD_WAIT : begin
                        // back pressure if fifo_write_waitrequest
                        if (!fifo_write_waitrequest) begin
                            if (counter == 0) begin
                                state       <= READY;
                            end else begin
                                state <= READ_ASSERT;
                            end
                            fifo_write  <= 1'b0;
                        end
              end
           endcase
           if (enable & in_startofpacket) begin
              state      <= GET_EXTRA;
              command    <= in_data;
              in_ready_0 <= !fifo_write_waitrequest;
           end
      end  // end else
   end  // end always block
endmodule

// --------------------------------------------------------------------------------
// FIFO buffer
// --------------------------------------------------------------------------------
// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module fifo_buffer_single_clock_fifo (
                                                   // inputs:
                                                    aclr,
                                                    clock,
                                                    data,
                                                    rdreq,
                                                    wrreq,

                                                   // outputs:
                                                    empty,
                                                    full,
                                                    q
                                                 )
;

  parameter FIFO_DEPTHS = 2;
  parameter FIFO_WIDTHU = 1;

  output           empty;
  output           full;
  output  [ 35: 0] q;
  input            aclr;
  input            clock;
  input   [ 35: 0] data;
  input            rdreq;
  input            wrreq;

  wire             empty;
  wire             full;
  wire    [ 35: 0] q;
  scfifo single_clock_fifo
    (
      .aclr (aclr),
      .clock (clock),
      .data (data),
      .empty (empty),
      .full (full),
      .q (q),
      .rdreq (rdreq),
      .wrreq (wrreq)
    );

  defparam single_clock_fifo.add_ram_output_register = "OFF",
           single_clock_fifo.lpm_numwords = FIFO_DEPTHS,
           single_clock_fifo.lpm_showahead = "OFF",
           single_clock_fifo.lpm_type = "scfifo",
           single_clock_fifo.lpm_width = 36,
           single_clock_fifo.lpm_widthu = FIFO_WIDTHU,
           single_clock_fifo.overflow_checking = "ON",
           single_clock_fifo.underflow_checking = "ON",
           single_clock_fifo.use_eab = "OFF";


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module fifo_buffer_scfifo_with_controls (
                                                      // inputs:
                                                       clock,
                                                       data,
                                                       rdreq,
                                                       reset_n,
                                                       wrreq,

                                                      // outputs:
                                                       empty,
                                                       full,
                                                       q
                                                    )
;

  parameter FIFO_DEPTHS = 2;
  parameter FIFO_WIDTHU = 1;
  
  output           empty;
  output           full;
  output  [ 35: 0] q;
  input            clock;
  input   [ 35: 0] data;
  input            rdreq;
  input            reset_n;
  input            wrreq;

  wire             empty;
  wire             full;
  wire    [ 35: 0] q;
  wire             wrreq_valid;
  //the_scfifo, which is an e_instance
  fifo_buffer_single_clock_fifo #(
            .FIFO_DEPTHS(FIFO_DEPTHS),
            .FIFO_WIDTHU(FIFO_WIDTHU)
  ) the_scfifo (
      .aclr  (~reset_n),
      .clock (clock),
      .data  (data),
      .empty (empty),
      .full  (full),
      .q     (q),
      .rdreq (rdreq),
      .wrreq (wrreq_valid)
    );

  assign wrreq_valid = wrreq & ~full;

endmodule

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module fifo_buffer (
                                 // inputs:
                                  avalonmm_read_slave_read,
                                  avalonmm_write_slave_write,
                                  avalonmm_write_slave_writedata,
                                  reset_n,
                                  wrclock,

                                 // outputs:
                                  avalonmm_read_slave_readdata,
                                  avalonmm_read_slave_waitrequest,
                                  avalonmm_write_slave_waitrequest
                               )
;

  parameter FIFO_DEPTHS = 2;
  parameter FIFO_WIDTHU = 1;


  output  [ 35: 0] avalonmm_read_slave_readdata;
  output           avalonmm_read_slave_waitrequest;
  output           avalonmm_write_slave_waitrequest;
  input            avalonmm_read_slave_read;
  input            avalonmm_write_slave_write;
  input   [ 35: 0] avalonmm_write_slave_writedata;
  input            reset_n;
  input            wrclock;

  wire    [ 35: 0] avalonmm_read_slave_readdata;
  wire             avalonmm_read_slave_waitrequest;
  wire             avalonmm_write_slave_waitrequest;
  wire             clock;
  wire    [ 35: 0] data;
  wire             empty;
  wire             full;
  wire    [ 35: 0] q;
  wire             rdreq;
  wire             wrreq;
  //the_scfifo_with_controls, which is an e_instance
  fifo_buffer_scfifo_with_controls #(
      .FIFO_DEPTHS(FIFO_DEPTHS),
      .FIFO_WIDTHU(FIFO_WIDTHU)
  ) the_scfifo_with_controls
    (
      .clock   (clock),
      .data    (data),
      .empty   (empty),
      .full    (full),
      .q       (q),
      .rdreq   (rdreq),
      .reset_n (reset_n),
      .wrreq   (wrreq)
    );

  //in, which is an e_avalon_slave
  //out, which is an e_avalon_slave
  assign data = avalonmm_write_slave_writedata;
  assign wrreq = avalonmm_write_slave_write;
  assign avalonmm_read_slave_readdata = q;
  assign rdreq = avalonmm_read_slave_read;
  assign clock = wrclock;
  assign avalonmm_write_slave_waitrequest = full;
  assign avalonmm_read_slave_waitrequest = empty;

endmodule

// --------------------------------------------------------------------------------
// fifo_buffer to Avalon-ST interface
// --------------------------------------------------------------------------------

module fifo_to_packet (

      // Interface: clk
      input              clk,
      input              reset_n,

      // Interface: ST out
      input              out_ready,
      output reg         out_valid,
      output reg [ 7: 0] out_data,
      output reg         out_startofpacket,
      output reg         out_endofpacket,

      // Interface: FIFO in
      input  [ 35: 0]    fifo_readdata,
      output reg         fifo_read,
      input              fifo_empty 
);

reg [ 1: 0]     state;
reg             enable, sent_all;
reg [ 1: 0]     current_byte, byte_end;
reg             first_trans, last_trans;
reg [ 23:0]     fifo_data_buffer;

localparam    POP_FIFO        = 2'b00,
              POP_FIFO_WAIT   = 2'b01,
              FIFO_DATA_WAIT  = 2'b10,
              READ_SEND_ISSUE = 2'b11;

always @* begin
      enable = (!fifo_empty & sent_all);
end
          
always @(posedge clk or negedge reset_n) begin
          if (!reset_n) begin
                fifo_data_buffer  <=  'b0;
                out_startofpacket <= 1'b0;
                out_endofpacket   <= 1'b0;
                out_valid         <= 1'b0;
                out_data          <=  'b0;
                state             <=  'b0;
                fifo_read         <= 1'b0;
                current_byte      <=  'b0;
                byte_end          <=  'b0;
                first_trans       <= 1'b0;
                last_trans        <= 1'b0;
                sent_all          <= 1'b1;
          end else begin
                if (out_ready) begin
                  out_startofpacket <= 1'b0;
                  out_endofpacket   <= 1'b0;
                end
                
                case (state)
                  POP_FIFO : begin
                            if (out_ready) begin
                                out_startofpacket   <= 1'b0;
                                out_endofpacket     <= 1'b0;
                                out_valid           <= 1'b0;
                                first_trans         <= 1'b0;
                                last_trans          <= 1'b0;
                                byte_end            <=  'b0;
                                fifo_read           <= 1'b0;
                                sent_all            <= 1'b1;
                            end
                            // start poping fifo after all data sent and data available
                            if (enable) begin   
                                fifo_read       <= 1'b1;
                                out_valid       <= 1'b0;
                                state           <= POP_FIFO_WAIT;
                            end
                  end
                  POP_FIFO_WAIT : begin
                  //fifo latency of 1
                                fifo_read               <= 1'b0;
                                state                   <= FIFO_DATA_WAIT;
                  end
                  FIFO_DATA_WAIT : begin
                                sent_all                <= 1'b0;
                                first_trans             <= fifo_readdata[35];
                                last_trans              <= fifo_readdata[34];
                                out_data                <= fifo_readdata[7:0];
                                fifo_data_buffer        <= fifo_readdata[31:8];
                                byte_end                <= fifo_readdata[33:32];
                                current_byte            <= 1'b1;
                                out_valid               <= 1'b1;
                                
                                // first byte sop eop handling
                                if (fifo_readdata[35] & fifo_readdata[34] & (fifo_readdata[33:32] == 0)) begin
                                    first_trans         <= 1'b0;
                                    last_trans          <= 1'b0;
                                    out_startofpacket   <= 1'b1;
                                    out_endofpacket     <= 1'b1;
                                    state <= POP_FIFO;
                                end else if (fifo_readdata[35] & (fifo_readdata[33:32] == 0)) begin
                                    first_trans         <= 1'b0;
                                    out_startofpacket   <= 1'b1;
                                    state               <= POP_FIFO;
                                end else if (fifo_readdata[35]) begin
                                   first_trans          <= 1'b0;
                                   out_startofpacket    <= 1'b1;
                                   state <= READ_SEND_ISSUE;
                                end else if (fifo_readdata[34] & (fifo_readdata[33:32] == 0)) begin
                                    last_trans          <= 1'b0;
                                    out_endofpacket     <= 1'b1;
                                    state               <= POP_FIFO;
                                end else begin
                                    state               <= READ_SEND_ISSUE;
                                end
                                
                  end
                  READ_SEND_ISSUE : begin
                            out_valid         <= 1'b1;
                            sent_all          <= 1'b0;
                            
                            if (out_ready) begin
                                out_startofpacket <= 1'b0;
                                // last byte
                                if (last_trans & (current_byte == byte_end)) begin
                                        last_trans      <= 1'b0;
                                        out_endofpacket <= 1'b1;
                                        state           <= POP_FIFO;
                                end
                                case (current_byte)
                                       3: begin
                                          out_data <= fifo_data_buffer[23:16];
                                       end
                                       2: begin
                                          out_data <= fifo_data_buffer[15:8];
                                       end
                                       1: begin
                                          out_data <= fifo_data_buffer[7:0];
                                       end
                                       default: begin
                                          //out_data        <= fifo_readdata[7:0];
                                       end
                                endcase
                                current_byte <= current_byte + 1'b1;
                                if (current_byte == byte_end) begin
                                    state <= POP_FIFO;
                                end else begin
                                    state <= READ_SEND_ISSUE;
                                end
                            end
                  end
                endcase
          end
    end
endmodule

// --------------------------------------------------------------------------------
//| Economy Transaction Master
// --------------------------------------------------------------------------------
module packets_to_master (

      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: ST in
      output reg         in_ready,
      input              in_valid,
      input      [ 7: 0] in_data,
      input              in_startofpacket,
      input              in_endofpacket,

      // Interface: ST out 
      input              out_ready,
      output reg         out_valid,
      output reg [ 7: 0] out_data,
      output reg         out_startofpacket,
      output reg         out_endofpacket,

      // Interface: MM out
      output reg [31: 0] address,
      input      [31: 0] readdata,
      output reg         read,
      output reg         write,
      output reg [ 3: 0] byteenable,
      output reg [31: 0] writedata,
      input              waitrequest,
      input              readdatavalid
      
);

   // ---------------------------------------------------------------------
   //| Parameter Declarations
   // ---------------------------------------------------------------------
   parameter EXPORT_MASTER_SIGNALS = 0;

   // ---------------------------------------------------------------------
   //| Command Declarations
   // ---------------------------------------------------------------------
   localparam CMD_WRITE_NON_INCR = 8'h00;
   localparam CMD_WRITE_INCR     = 8'h04;
   localparam CMD_READ_NON_INCR  = 8'h10;
   localparam CMD_READ_INCR      = 8'h14;
   
   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  [ 3: 0]  state;
   reg  [ 7: 0]  command;
   reg  [ 1: 0]  current_byte; //, result_byte;
   reg  [ 15: 0] counter;
   reg  [ 23: 0] read_data_buffer;
   reg           in_ready_0;
   reg           first_trans, last_trans;
   reg  [ 3: 0]  unshifted_byteenable;
   wire enable;

   localparam READY          = 4'b0000, 
              GET_EXTRA      = 4'b0001,
              GET_SIZE1      = 4'b0010,
              GET_SIZE2      = 4'b0011,
              GET_ADDR1      = 4'b0100,
              GET_ADDR2      = 4'b0101,
              GET_ADDR3      = 4'b0110,
              GET_ADDR4      = 4'b0111,
              GET_WRITE_DATA = 4'b1000,      
              WRITE_WAIT     = 4'b1001,
              RETURN_PACKET  = 4'b1010,
              READ_ASSERT    = 4'b1011,
              READ_CMD_WAIT  = 4'b1100,
              READ_DATA_WAIT = 4'b1101,
              READ_SEND_ISSUE= 4'b1110,
              READ_SEND_WAIT = 4'b1111;
   
   
   // ---------------------------------------------------------------------
   //| Thingofamagick
   // ---------------------------------------------------------------------

   assign enable = (in_ready & in_valid);

   always @*
//      in_ready = in_ready_0 & out_ready;
      in_ready = in_ready_0;
   
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
            in_ready_0        <= 1'b0;
            out_startofpacket <= 1'b0;
            out_endofpacket   <= 1'b0;
            out_valid         <= 1'b0;
            out_data          <=  'b0;
            read              <= 1'b0;
            write             <= 1'b0;
            byteenable        <=  'b0;
            writedata         <=  'b0;
            address           <=  'b0;
            counter           <=  'b0;
            command           <=  'b0;
            first_trans       <= 1'b0;
            last_trans        <= 1'b0;
            state             <= 'b0;
            current_byte      <= 'b0;
          //  result_byte       <= 'b0;
            read_data_buffer  <= 'b0;
            unshifted_byteenable <= 'b0;
      end else begin
            address[1:0]      <= 'b0;
 
            if (out_ready) begin
              out_startofpacket <= 1'b0;
              out_endofpacket   <= 1'b0;
              out_valid         <= 1'b0;
            end
            in_ready_0 <= 1'b0;
            
            if (counter >= 3)      unshifted_byteenable <= 4'b1111;
            else if (counter == 3) unshifted_byteenable <= 4'b0111;
            else if (counter == 2) unshifted_byteenable <= 4'b0011;
            else if (counter == 1) unshifted_byteenable <= 4'b0001;

            case (state)
              READY : begin
                   out_valid         <= 1'b0;
                   in_ready_0        <= 1'b1;
              end
              GET_EXTRA : begin
                   in_ready_0        <= 1'b1;
                   byteenable        <=  'b0;
                   if (enable) state <= GET_SIZE1;
              end

              GET_SIZE1 : begin
                   in_ready_0        <= 1'b1;
                   //load counter on reads only
                   counter[15:8]     <= command[4]?in_data:8'b0;
                   if (enable) state <= GET_SIZE2;
              end

              GET_SIZE2 : begin
                   in_ready_0        <= 1'b1;
                   //load counter on reads only
                   counter[7:0]      <= command[4]?in_data:8'b0;
                   if (enable) state <= GET_ADDR1;
              end
              
              GET_ADDR1 : begin
                in_ready_0        <= 1'b1;
                first_trans       <= 1'b1;
                last_trans        <= 1'b0;
                address[31:24]    <= in_data;
                if (enable) state <= GET_ADDR2;
              end

              GET_ADDR2 : begin
                in_ready_0        <= 1'b1;
                address[23:16]    <= in_data;
                if (enable) state <= GET_ADDR3;
              end

              GET_ADDR3 : begin
                in_ready_0        <= 1'b1;
                address[15:8]     <= in_data;
                if (enable) state <= GET_ADDR4;
              end

              GET_ADDR4 : begin
                in_ready_0        <= 1'b1;
                address[7:2]      <= in_data[7:2];
                current_byte      <= in_data[1:0];
                if (enable) begin
                      if (command == CMD_WRITE_NON_INCR | command == CMD_WRITE_INCR) begin
                        state <= GET_WRITE_DATA; //writes
                        in_ready_0 <= 1'b1;
                      end
                      else if (command == CMD_READ_NON_INCR | command == CMD_READ_INCR) begin
                        state   <= READ_ASSERT; //reads
                        in_ready_0 <= 1'b0;
                      end
                      else begin
                        //nops
                        //treat all unrecognized commands as nops as well
                        state <= RETURN_PACKET; 
                        out_startofpacket <= 1'b1;
                        out_data <= (8'h80 | command);
                        out_valid <= 1'b1;
                        current_byte <= 'h0;
                        in_ready_0 <= 1'b0;
                      end
                end
              end

              GET_WRITE_DATA : begin
                        in_ready_0 <= 1; 
                        if (enable) begin
                          counter <= counter + 1'b1;
                          //2 bit, should wrap by itself
                          current_byte <= current_byte + 1'b1;
                          if (in_endofpacket || current_byte == 3) 
                          begin
                             in_ready_0 <= 0;
                             write      <= 1'b1;
                             state      <= WRITE_WAIT;
                          end
                        end
                        if (in_endofpacket) begin
                          last_trans <= 1'b1;
                        end
                        // handle byte writes properly
                        // drive data pins based on addresses
                        case (current_byte)
                          0: begin
                            writedata[7:0]   <= in_data;
                            byteenable[0]    <= 1;
                          end
                          1: begin
                            writedata[15:8]  <= in_data;
                            byteenable[1]    <= 1;
                          end
                          2: begin
                            writedata[23:16] <= in_data;
                            byteenable[2]    <= 1;
                          end
                          3: begin
                            writedata[31:24] <= in_data;
                            byteenable[3]    <= 1;
                          end
                        endcase
              end

              WRITE_WAIT : begin
                        in_ready_0 <= 0;
                        write      <= 1'b1;
                        if (~waitrequest) begin
                           write <= 1'b0;
                           state <= GET_WRITE_DATA;
                           in_ready_0 <= 1;
                           byteenable <= 'b0;
                           if (command[2] == 1'b1) begin
                              //increment address, but word-align it
                              address[31:2] <= (address[31:2] + 1'b1);
                           end
                           if (last_trans) begin
                              state <= RETURN_PACKET;
                              out_startofpacket <= 1'b1;
                              out_data <= (8'h80 | command);
                              out_valid <= 1'b1;
                              current_byte <= 'h0;
                              in_ready_0 <= 1'b0;
                           end
                        end
              end
              
              RETURN_PACKET : begin
                        out_valid <= 1'b1;
                        if (out_ready) begin
                           case (current_byte)
                          //   0: begin
                          //     out_startofpacket <= 1'b1;
                          //     out_data <= (8'h80 | command);
                          //   end
                             0: begin
                               out_data <= 8'b0;
                             end
                             1: begin
                               out_data <= counter[15:8];
                             end
                             2: begin
                               out_endofpacket <= 1'b1;
                               out_data <= counter[7:0];
                             end
                             default: begin
                          //     out_data <= 8'b0;
                          //     out_startofpacket <= 1'b0;
                          //     out_endofpacket <= 1'b0;
                             end
                           endcase
                           current_byte <= current_byte + 1'b1;
                           if (current_byte == 3) begin
                              state     <= READY;
                              out_valid <= 1'b0;
                           end
                           else                   state     <= RETURN_PACKET;
                        end
              end
              READ_ASSERT : begin
                        if (current_byte == 3) byteenable <= unshifted_byteenable << 3;
                        if (current_byte == 2) byteenable <= unshifted_byteenable << 2;
                        if (current_byte == 1) byteenable <= unshifted_byteenable << 1;
                        if (current_byte == 0) byteenable <= unshifted_byteenable;
//                        byteenable <= unshifted_byteenable << current_byte;
                        read             <= 1;
                        state            <= READ_CMD_WAIT;
              end
              READ_CMD_WAIT : begin
                        read_data_buffer <= readdata[31:8];
                        out_data         <= readdata[7:0];
                        read             <= 1; 
                        // if readdatavalid, take the data and 
                        // go directly to READ_SEND_ISSUE.  This is for fixed
                        // latency slaves. Ignore waitrequest in this case,
                        // since this master does not issue pipelined reads.
                        //
                        // For variable latency slaves, once waitrequest is low
                        // the read command is accepted, so deassert read and
                        // go to READ_DATA_WAIT to wait for readdatavalid 
                        if (readdatavalid) begin
                           state <= READ_SEND_ISSUE;
                           read <= 0;
                        end else begin
                           if (~waitrequest) begin
                               state <= READ_DATA_WAIT;
                               read <= 0;
                           end
                        end
              end
              READ_DATA_WAIT : begin
                        read_data_buffer <= readdata[31:8];
                        out_data         <= readdata[7:0];
                        if (readdatavalid) begin
                            state <= READ_SEND_ISSUE;
                        end
              end
              READ_SEND_ISSUE : begin
                        out_valid <= 1'b1;
                        out_startofpacket <= 'h0;
                        out_endofpacket   <= 'h0;
                        if (counter == 1) begin
                           out_endofpacket <= 1'b1;
                        end 
                        if (first_trans) begin
                           first_trans <= 1'b0;
                           out_startofpacket <= 1'b1;
                        end
                        case (current_byte)
                          3: begin
                             out_data        <= read_data_buffer[23:16];
                          end
                          2: begin
                             out_data        <= read_data_buffer[15:8];
                          end
                          1: begin
                             out_data        <= read_data_buffer[7:0];
                          end
                          default: begin
                             out_data        <= out_data; 
                          end
                        endcase
                        state <= READ_SEND_WAIT;
              end
              READ_SEND_WAIT : begin
                        out_valid <= 1'b1;
                        if (out_ready) begin
                           counter <= counter - 1'b1;
                           current_byte <= current_byte + 1'b1;
                           out_valid <= 1'b0;
                           // count down on the number of bytes to read
                           // shift current byte location within word
                           // if increment address, add it, so the next read
                           // can use it, if more reads are required
                           
                           // no more bytes to send - go to READY state
                           if (counter == 1) begin
                              state <= READY;
                           // end of current word, but we have more bytes to
                           // read - go back to READ_ASSERT
                           end else if (current_byte == 3) begin
                              if (command[2] == 1'b1) begin
                                 //increment address, but word-align it
                                 address[31:2] <= (address[31:2] + 1'b1);
                              end
                              state <= READ_ASSERT;
                           // continue sending current word
                           end else begin
                              state <= READ_SEND_ISSUE;
                           end
                           //maybe add in_ready_0 here so we are ready to go
                           //right away
                        end 
              end
           endcase
           if (enable & in_startofpacket) begin
              state <= GET_EXTRA;
              command           <= in_data;
              in_ready_0 <= 1'b1;
           end
      end  // end else
   end  // end always block
endmodule
