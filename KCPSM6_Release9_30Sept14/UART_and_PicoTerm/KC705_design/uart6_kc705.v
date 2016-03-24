//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2011-2014, Xilinx, Inc.
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
// 20th June 2014 - Initial version for KC705 board using Vivado 2014.1
//
// This reference design provides a simple UART communication example. Please see 
// 'UART6_User_Guide_and_Reference_Designs_30Sept14.pdf' (or later) for more detailed 
// descriptions.
//
// The KC705 board provides a 200MHz clock to the Kintex-7 device which is used by all 
// circuits in this design including KCPSM6 and the UART macros. In this example, KCPSM6
// computes a constant which is applied to a clock division circuit to define a UART 
// communication BAUD rate of 115200. 
//
// Whilst the design is presented as a working example for the XC7K325TFFG900-2 device on 
// the KC705 Evaluation Board (wwx.xilinx.com), it is a simple reference design that is 
// easily adapted or incorporated into a design for use with any hardware platform. Indeed,
// the method presented to define the BAUD rate can make this code even easier to port as
// it only requires one constant to be defined and KCPSM6 works out everything else. 
//
//
///////////////////////////////////////////////////////////////////////////////////////////
//
//

module uart6_kc705 (  input   uart_rx,
                     output   uart_tx,
                      input   clk200_p,
                      input   clk200_n);

//
///////////////////////////////////////////////////////////////////////////////////////////
// Signals
///////////////////////////////////////////////////////////////////////////////////////////
//

// Signals used to create internal 200MHz clock from 200MHz differential clock

wire        clk200;
wire        clk;

// Signal used to specify the clock frequency in megahertz.

wire [7:0]  clock_frequency_in_MHz; 

// Signals used to connect KCPSM6

wire [11:0] address;
wire [17:0] instruction;
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
reg         pipe_port_id0;
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

reg [7:0]   set_baud_rate;
reg [7:0]   baud_rate_counter;
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
  // Assign constant value which specifies the clock frequency in megahertz. 
  /////////////////////////////////////////////////////////////////////////////////////////

  assign clock_frequency_in_MHz = 8'd200;


  /////////////////////////////////////////////////////////////////////////////////////////
  // Create and distribute an internal 200MHz clock from 200MHz differential clock
  /////////////////////////////////////////////////////////////////////////////////////////

  IBUFGDS diff_clk_buffer(
      .I(clk200_p),
      .IB(clk200_n),
      .O(clk200));

  // BUFG used to reach the entire device with 200MHz

  BUFG clock_divide ( 
      .I(clk200),
      .O(clk));

  /////////////////////////////////////////////////////////////////////////////////////////
  // Instantiate KCPSM6 and connect to program ROM
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // The generics can be defined as required. In this case the 'hwbuild' value is used to 
  // define a version using the ASCII code for the desired letter. 
  //


  kcpsm6 #(
	.interrupt_vector	(12'h7FF),
	.scratch_pad_memory_size(64),
	.hwbuild		(8'h41))            // 41 hex is ASCII Character "A"
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
  // Tying to other signals used to minimise warning messages.
 
  assign kcpsm6_sleep = write_strobe && k_write_strobe;  // Always '0'
  assign interrupt = interrupt_ack;

  
  // Development Program Memory 
  //   JTAG Loader enabled for rapid code development. 
  
  auto_baud_rate_control #(
	.C_FAMILY		   ("7S"),  
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
  // The baud rate is defined by the frequency of 'en_16_x_baud' pulses. These should occur  
  // at 16 times the desired baud rate. KCPSM6 computes and sets an 8-bit value into 
  // 'set_baud_rate' which is used to divide the clock frequency appropriately.
  // 
  // For example, if the clock frequency is 200MHz and the desired serial communication 
  // baud rate is 115200 then PicoBlaze will set 'set_baud_rate' to 6C hex (108 decimal). 
  // This circuit will then generate an 'en_16_x_baud' pulse once every 109 clock cycles 
  // (note that 'baud_rate_counter' will include state zero). This would actually result 
  // in a baud rate of 114,679 baud but that is only 0.45% low and well within limits.
  //

  always @ (posedge clk )
  begin
    if (baud_rate_counter == set_baud_rate) begin    
      baud_rate_counter <= 5'b00000;
      en_16_x_baud <= 1'b1;                 // single cycle enable pulse
    end
    else begin
      baud_rate_counter <= baud_rate_counter + 5'b00001;
      en_16_x_baud <= 1'b0;
    end
  end

  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // General Purpose Input Ports. 
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // Three input ports are used with the UART macros. 
  // 
  // The first is used to monitor the flags on both the transmitter and receiver.
  // The second is used to read the data from the receiver and generate a 'buffer_read' 
  //   pulse. 
  // The third is used to read a user defined constant that enabled KCPSM6 to know the 
  //   clock frequency so that it can compute values which will define the BAUD rate 
  //   for UART communications (as well as values used to define software delays).
  //

  always @ (posedge clk)
  begin
    case (port_id[1:0]) 
      
        // Read UART status at port address 00 hex
        2'b00 : in_port <= { 2'b00,
                             uart_rx_full,
                             uart_rx_half_full,
                             uart_rx_data_present,
                             uart_tx_full, 
                             uart_tx_half_full,
                             uart_tx_data_present };


        // Read UART_RX6 data at port address 01 hex
        // (see 'buffer_read' pulse generation below) 
        2'b01 : in_port <= uart_rx_data_out;

        // Read clock frequency contant at port address 02 hex
        2'b10 : in_port <= clock_frequency_in_MHz;

        // Specify don't care for all other inputs to obtain optimum implementation
        default : in_port <= 8'bXXXXXXXX ;  

    endcase;

    // Generate 'buffer_read' pulse following read from port address 01

    if ((read_strobe == 1'b1) && (port_id[1:0] == 2'b01)) begin
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
  // In this design there are two general purpose output ports. 
  //
  //   A port used to write data directly to the FIFO buffer within 'uart_tx6' macro.
  // 
  //   A port used to define the communication BAUD rate of the UART.
  //
  // Note that the assignment and decoding of 'port_id' is a one-hot resulting 
  // in the minimum number of signals actually being decoded for a fast and 
  // optimum implementation.  
  // 

  always @ (posedge clk)
  begin

      // 'write_strobe' is used to qualify all writes to general output ports.
      if (write_strobe == 1'b1) begin

        // Write to UART at port addresses 01 hex
        // See below this clocked process for the combinatorial decode required.

        // Write to 'set_baud_rate' at port addresses 02 hex     
        // This value is set by KCPSM6 to define the BAUD rate of the UART. 
        // See the 'UART baud rate' section for details.

        if (port_id[1] == 1'b1) begin
          set_baud_rate <= out_port;
        end

      end

      //
      // *** To reliably achieve 200MHz performance when writing to the FIFO buffer
      //     within the UART transmitter, 'port_id' is pipelined to exploit both of  
      //     the clock cycles that it is valid.
      //

      pipe_port_id0 <= port_id[0];


  end

  //
  // Write directly to the FIFO buffer within 'uart_tx6' macro at port address 01 hex.
  // Note the direct connection of 'out_port' to the UART transmitter macro and the 
  // way that a single clock cycle write pulse is generated to capture the data.
  // 

  assign uart_tx_data_in = out_port;

  // See *** above for definition of 'pipe_port_id0'. 

  assign write_to_uart_tx = write_strobe & pipe_port_id0;


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
// END OF FILE uart6_kc705.v
///////////////////////////////////////////////////////////////////////////////////////////
//
