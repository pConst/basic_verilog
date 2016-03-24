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
//
// Target platform - ATLYS Spartan-6 Board (www.digilentinc.com).
//                   To be used in conjunction with the PicoTerm terminal.
//
//
// Ken Chapman - Xilinx Ltd.
//
// 19th September 2012 - Conversion from original VHDL version (6th September 2012). 
//
//
// This reference design primarily provides an example of UART communication. It also 
// includes some simple I/O ports (switches and LEDs) together with a simple example of
// a KCPSM6 interrupt. The KCPSM6 program provided with this hardware design demonstrates 
// each of these KCPSM6 features together with features of PicoTerm.
//
// Please see 'UART6_User_Guide_30Sept12.pdf' for more descriptions.
//
// The code in this example is set to implement a 115200 UART baud rate and generates 
// interrupts at one second intervals based on a 100MHz clock.
//
// Whilst the design is presented as a working example for the XC6SLX45-2CSG324 device on
// the ATLYS Spartan-6 Board (www.digilentinc.com), it is a simple reference design that
// is easily adapted or incorporated into a design for use with any hardware platform.
// 
//
//////////////////////////////////////////////////////////////////////////////////////////-
//
//

module uart6_atlys (
  input        uart_rx,
  output       uart_tx,
  output [7:0] led,
  input  [7:0] switch,
  input        reset_b,
  input        clk );

//
///////////////////////////////////////////////////////////////////////////////////////////
// Signals
///////////////////////////////////////////////////////////////////////////////////////////
//


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
reg         interrupt;   
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

reg [5:0]   baud_count;
reg         en_16_x_baud;

// Signals to drive LEDs

reg [7:0]   led_port;

// Signals used to generate interrupt at one second intervals

reg [26:0]  int_count;
reg         event_1hz;


//
//
///////////////////////////////////////////////////////////////////////////////////////////
//
// Start of circuit description
//
///////////////////////////////////////////////////////////////////////////////////////////
//


  /////////////////////////////////////////////////////////////////////////////////////////
  // Instantiate KCPSM6 and connect to program ROM
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // The generics can be defined as required. In this case the 'hwbuild' value is used to 
  // define a version using the ASCII code for the desired letter and the interrupt vector
  // has been set to 3C0 to provide 64 instructions for an Interrupt Service Routine (ISR)
  // before reaching the end of a 1K memory 
  //


  kcpsm6 #(
	.interrupt_vector	(12'h3C0),
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

  // Reset by press button (active Low) or JTAG Loader enabled Program Memory 

  assign kcpsm6_reset = rdl | ~reset_b;


  // Unused signals tied off until required.
  // Tying to other signals used to minimise warning messages.
 
  assign kcpsm6_sleep = write_strobe & k_write_strobe;  // Always '0'

  
  // Development Program Memory 
  //   JTAG Loader enabled for rapid code development. 
  
  atlys_real_time_clock #(
	.C_FAMILY		   ("S6"),  
	.C_RAM_SIZE_KWORDS	(1),  
	.C_JTAG_LOADER_ENABLE	(1))
  program_rom (
 	.rdl 			(rdl),
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(clk));


  /////////////////////////////////////////////////////////////////////////////////////////
  // Interrupt control
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // Interrupt is used to provide a 1 second time reference.
  //
  // A simple binary counter is used to divide the 100MHz clock and provide 
  // interrupt pulses that remain active until acknowledged by KCPSM6.
  //

  always @ (posedge clk )
  begin

    // divide 100MHz by 100,000,000 to form 1Hz pulses

    if (int_count == 27'b101111101011110000011111111) begin
      int_count <= 27'b000000000000000000000000000;
      event_1hz <= 1'b1;                 // single cycle enable pulse
    end
    else begin
      int_count <= int_count + 27'b000000000000000000000000001;
      event_1hz  <= 1'b0;
    end

    // Interrupt becomes active each second and remains active until acknowledged

    if (interrupt_ack == 1'b1) begin
      interrupt <= 1'b0;
    end
    else begin
      if (event_1hz == 1'b1) begin
        interrupt <= 1'b1;
      end
      else begin
        interrupt <= interrupt;
      end
    end

  end


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
  // High at 1,843,200Hz which is every 54.28 cycles at 100MHz. In this implementation 
  // a pulse is generated every 54 cycles resulting is a baud rate of 115,741 baud which
  // is only 0.5% high and well within limits.
  //

  always @ (posedge clk )
  begin
    if (baud_count == 6'b110101) begin      // counts 54 states including zero
      baud_count <= 6'b000000;
      en_16_x_baud <= 1'b1;                 // single cycle enable pulse
    end
    else begin
      baud_count <= baud_count + 6'b000001;
      en_16_x_baud <= 1'b0;
    end
  end

  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // General Purpose Input Ports. 
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // Two input ports are used with the UART macros. The first is used to monitor the flags
  // on both the UART transmitter and receiver. The second is used to read the data from 
  // the UART receiver. Note that the read also requires a 'buffer_read' pulse to be 
  // generated.
  //
  // This design includes a third input port to read 8 general purpose switches.
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

        // Read 8 general purpose switches at port address 02 hex

        2'b10 : in_port <= switch;

        // Don't Care for unused case(s) ensures minimum logic implementation  

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
  // In this simple example there are two output ports. 
  //   A simple output port used to control a set of 8 general purpose LEDs.
  //   A port used to write data directly to the FIFO buffer within 'uart_tx6' macro.
  // 

  // LEDs are connected to a typical KCPSM6 output port. 
  //  i.e. A register and associated decode logic to enable data capture.
  

  always @ (posedge clk)
  begin

      // 'write_strobe' is used to qualify all writes to general output ports.
      if (write_strobe == 1'b1) begin

        // Write to LEDs at port address 02 hex
        if (port_id[1] == 1'b1) begin
          led_port <= out_port;
        end

      end

  end

  // Connect KCPSM6 port to device output pins

  assign led = led_port;


  // Write directly to the FIFO buffer within 'uart_tx6' macro at port address 01 hex.
  // Note the direct connection of 'out_port' to the UART transmitter macro and the 
  // way that a single clock cycle write pulse is generated to capture the data.
  
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
// END OF FILE uart6_atlys.v
///////////////////////////////////////////////////////////////////////////////////////////
//
