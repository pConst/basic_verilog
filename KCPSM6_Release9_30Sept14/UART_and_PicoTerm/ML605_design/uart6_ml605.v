//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2011-2012, Xilinx, Inc.
// This file contains confidential and proprietary information of Xilinx, Inc. and is
// protected under U.S. and international copyright and other intellectual property laws.
///////////////////////////////////////////////////////////////////////////////////////////
//
// Disclaimer:
// This disclaimer is not a license and does not grant any rights to the materials
// distributed herewith. Except as otherwise provided in a valid license issued to
// you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
// MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
// DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
// INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
// OR FITNESS FOR ANY PARTICULAR PURPOSE; and [2] Xilinx shall not be liable
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
///////////////////////////////////////////////////////////////////////////////////////////
//
//
// KCPSM6 reference design using 'uart_tx6' and 'uart_rx6'macros.
//
// Ken Chapman - Xilinx Ltd.
//
// 30th April 2012 - Conversion from original VHDL version (30th April 2012). 
//  30th July 2014 - Corrections to comment only.
//
// This reference design provides a simple UART communication example. 
// Please see 'UART6_User_Guide_and_Reference_Designs_30Sept14.pdf'  for more detailed 
// descriptions.
//
// The code in this example is set to implement a 115200 baud rate when using a 50MHz 
// clock. Whilst the design is presented as a working example for the XC6VLX240T-1FF1156
// device on the ML605 Evaluation Board (www.xilinx.com) it is a simple reference design 
// that is easily adapted or incorporated into a design for use with any hardware platform.
//
//
//////////////////////////////////////////////////////////////////////////////////////////-
//
//

module uart6_ml605 (  input   uart_rx,
                      input   clk200_p,
                      input   clk200_n,
                     output   uart_tx );

//
///////////////////////////////////////////////////////////////////////////////////////////
// Signals
///////////////////////////////////////////////////////////////////////////////////////////
//

// Signals used to create 50MHz clock from 200MHz differential clock
//

wire          clk200;
wire          clk;

// Signals used to connect KCPSM6

wire [11:0] address;
wire [17:0]	instruction;
wire        bram_enable;
reg  [7:0]  in_port;
wire [7:0]  out_port;
wire [7:0]  port_id;
wire        write_strobe;
wire        k_write_strobe;
wire        read_strobe;
wire        interrupt;   
wire        interrupt_ack;
wire        kcpsm6_sleep;  
wire        kcpsm6_reset;
wire        rdl;

// Signals used to connect UART_TX6

wire [7:0]  uart_tx_data_in;
wire        write_to_uart_tx;
wire        uart_tx_data_present;
wire        uart_tx_half_full;
wire        uart_tx_full;
reg         uart_tx_reset;

// Signals used to connect UART_RX6


wire [7:0]  uart_rx_data_out;
reg         read_from_uart_rx;
wire        uart_rx_data_present;
wire        uart_rx_half_full;
wire        uart_rx_full;
reg         uart_rx_reset;

// Signals used to define baud rate

reg [4:0]   baud_count;
reg         en_16_x_baud;

//
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Start of circuit description
//
///////////////////////////////////////////////////////////////////////////////////////////
//

  /////////////////////////////////////////////////////////////////////////////////////////
  // Create 50MHz clock from 200MHz differential clock
  /////////////////////////////////////////////////////////////////////////////////////////

  IBUFGDS diff_clk_buffer(
      .I(clk200_p),
      .IB(clk200_n),
      .O(clk200));

  // BUFR used to divide by 4 and create a regional clock 

  BUFR #(
      .BUFR_DIVIDE("4"),
      .SIM_DEVICE("VIRTEX6"))
  clock_divide ( 
      .I(clk200),
      .O(clk),
      .CE(1'b1),
      .CLR(1'b0));

  /////////////////////////////////////////////////////////////////////////////////////////
  // Instantiate KCPSM6 and connect to program ROM
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // The generics can be defined as required. In this case the 'hwbuild' value is used to 
  // define a version using the ASCII code for the desired letter. 
  //


  kcpsm6 #(
	.interrupt_vector	(12'h7F0),
	.scratch_pad_memory_size(64),
	.hwbuild		(8'h42))            // 42 hex is ASCII Character "B"
  processor (
	.address 		(address),
	.instruction 	(instruction),
	.bram_enable 	(bram_enable),
	.port_id 		(port_id),
	.write_strobe 	(write_strobe),
	.k_write_strobe 	(k_write_strobe),
	.out_port 		(out_port),
	.read_strobe 	(read_strobe),
	.in_port 		(in_port),
	.interrupt 		(interrupt),
	.interrupt_ack 	(interrupt_ack),
	.reset 		(kcpsm6_reset),
	.sleep		(kcpsm6_sleep),
	.clk 			(clk)); 

  // Reset connected to JTAG Loader enabled Program Memory

  assign kcpsm6_reset = rdl;


  // Unused signals tied off until required.
 
  assign kcpsm6_sleep = 1'b0;
  assign interrupt = interrupt_ack;

  
  // Development Program Memory 
  //   JTAG Loader enabled for rapid code development. 
  
  uart_control #(
	.C_FAMILY		   ("V6"),  
	.C_RAM_SIZE_KWORDS	(2),  
	.C_JTAG_LOADER_ENABLE	(1))
  program_rom (
 	.rdl 			(rdl),
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(clk));


  /////////////////////////////////////////////////////////////////////////////////////////
  // UART Transmitter with integral 16 byte FIFO buffer
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // Write to buffer in UART Transmitter at port address 01 hex
  // 

  uart_tx6 tx(
      .data_in(uart_tx_data_in),
      .en_16_x_baud(en_16_x_baud),
      .serial_out(uart_tx),
      .buffer_write(write_to_uart_tx),
      .buffer_data_present(uart_tx_data_present),
      .buffer_half_full(uart_tx_half_full ),
      .buffer_full(uart_tx_full),
      .buffer_reset(uart_tx_reset),              
      .clk(clk));


  /////////////////////////////////////////////////////////////////////////////////////////
  // UART Receiver with integral 16 byte FIFO buffer
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // Read from buffer in UART Receiver at port address 01 hex.
  //
  // When KCPMS6 reads data from the receiver a pulse must be generated so that the 
  // FIFO buffer presents the next character to be read and updates the buffer flags.
  // 

  uart_rx6 rx(
      .serial_in(uart_rx),
      .en_16_x_baud(en_16_x_baud ),
      .data_out(uart_rx_data_out ),
      .buffer_read(read_from_uart_rx ),
      .buffer_data_present(uart_rx_data_present ),
      .buffer_half_full(uart_rx_half_full ),
      .buffer_full(uart_rx_full ),
      .buffer_reset(uart_rx_reset ),              
      .clk(clk ));

  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // RS232 (UART) baud rate 
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // To set serial communication baud rate to 115,200 then en_16_x_baud must pulse 
  // High at 1,843,200Hz which is every 27.13 cycles at 50MHz. In this implementation 
  // a pulse is generated every 27 cycles resulting is a baud rate of 115,741 baud which
  // is only 0.5% high and well within limits.
  //

  always @ (posedge clk )
  begin
    if (baud_count == 5'b11010) begin       // counts 27 states including zero
      baud_count <= 5'b00000;
      en_16_x_baud <= 1'b1;                 // single cycle enable pulse
    end
    else begin
      baud_count <= baud_count + 5'b00001;
      en_16_x_baud <= 1'b0;
    end
  end

  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // General Purpose Input Ports. 
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // Two input ports are used with the UART macros. The first is used to monitor the flags
  // on both the transmitter and receiver. The second is used to read the data from the 
  // receiver and generate the 'buffer_read' pulse.
  //

  always @ (posedge clk)
  begin
    case (port_id[0]) 
      
        // Read UART status at port address 00 hex
        1'b0 : in_port <= { 2'b00,
                            uart_rx_full,
                            uart_rx_half_full,
                            uart_rx_data_present,
                            uart_tx_full, 
                            uart_tx_half_full,
                            uart_tx_data_present };


        // Read UART_RX6 data at port address 01 hex
        // (see 'buffer_read' pulse generation below) 

        1'b1 : in_port <= uart_rx_data_out;

        default : in_port <= 8'bXXXXXXXX ;  

    endcase;

    // Generate 'buffer_read' pulse following read from port address 01

    if ((read_strobe == 1'b1) && (port_id[0] == 1'b1)) begin
        read_from_uart_rx <= 1'b1;
      end
      else begin
        read_from_uart_rx <= 1'b0;
      end

  end


  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // General Purpose Output Ports 
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // In this simple example there is only one output port and that it involves writing 
  // directly to the FIFO buffer within 'uart_tx6'. As such the only requirements are to 
  // connect the 'out_port' to the transmitter macro and generate the write pulse.
  // 

  assign uart_tx_data_in = out_port;

  assign write_to_uart_tx = write_strobe & port_id[0];


  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // Constant-Optimised Output Ports 
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // One constant-optimised output port is used to facilitate resetting of the UART macros.
  //

  always @ (posedge clk)
  begin

    if (k_write_strobe == 1'b1) begin

      if (port_id[0] == 1'b1) begin
          uart_tx_reset <= out_port[0];
          uart_rx_reset <= out_port[1];
      end

    end
  end

  /////////////////////////////////////////////////////////////////////////////////////////


endmodule

//
///////////////////////////////////////////////////////////////////////////////////////////
// END OF FILE uart6_ml605.v
///////////////////////////////////////////////////////////////////////////////////////////
//
