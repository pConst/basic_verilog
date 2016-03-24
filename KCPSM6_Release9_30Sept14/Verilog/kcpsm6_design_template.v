//
///////////////////////////////////////////////////////////////////////////////////////////
// Copyright © 2010-2011, Xilinx, Inc.
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
///////////////////////////////////////////////////////////////////////////////////////////
//
//              *** PLEASE NOTE THIS IS NOT A COMPLETE DESIGN *** 
//
// This file contains sections of Verilog code intended to be helpful reference when using 
// a KCPSM6 (PicoBlaze) processor in a Spartan-6 or Virtex-6 design. Please refer to the
// documentation provided with PicoBlaze. 
//
// Nick Sawyer and Ken Chapman - Xilinx - 4th March 2011
//
///////////////////////////////////////////////////////////////////////////////////////////
// Signals
///////////////////////////////////////////////////////////////////////////////////////////
//

//
// Signals for connection of KCPSM6 and Program Memory.
//
// NOTE: In Verilog a 'reg' must be used when a signal is used in a process and a 'wire'
//       must be used when using a simple assignment. This means that you may need to 
//       change the definition for the 'interrupt', 'kcpsm6_sleep' and 'kcpsm6_reset'
//       depending on how you use them in your design. For example, if you don't use 
//       interrupt then you will probably tie it to '0' and this will require a 'wire'.
//
//

wire	[11:0]	address;
wire	[17:0]	instruction;
wire			bram_enable;
wire	[7:0]		port_id;
wire	[7:0]		out_port;
reg	[7:0]		in_port;
wire			write_strobe;
wire			k_write_strobe;
wire			read_strobe;
reg			interrupt;            //See note above
wire			interrupt_ack;
wire			kcpsm6_sleep;         //See note above
reg			kcpsm6_reset;         //See note above

//
// Some additional signals are required if your system also needs to reset KCPSM6. 
//

wire			cpu_reset;
wire			rdl;

//
// When interrupt is to be used then the recommended circuit included below requires 
// the following signal to represent the request made from your system.
//

wire			int_request;

//
///////////////////////////////////////////////////////////////////////////////////////////
// Circuit Descriptions
///////////////////////////////////////////////////////////////////////////////////////////
//

  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // Instantiate KCPSM6 and connect to Program Memory
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // The KCPSM6 parameters can be defined as required but the default values are shown below
  // and these would be adequate for most designs.
  //

  kcpsm6 #(
	.interrupt_vector	(12'h3FF),
	.scratch_pad_memory_size(64),
	.hwbuild		(8'h00))
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

  //
  // In many designs (especially your first) interrupt and sleep are not used.
  // Tie these inputs Low until you need them. 
  // 

  assign kcpsm6_sleep = 1'b0;
  assign interrupt = 1'b0;

  //
  // The default Program Memory recommended for development.
  // 
  // The generics should be set to define the family, program size and enable the JTAG
  // Loader. As described in the documentation the initial recommended values are.  
  //    'S6', '1' and '1' for a Spartan-6 design.
  //    'V6', '2' and '1' for a Virtex-6 design.
  // Note that all 12-bits of the address are connected regardless of the program size
  // specified by the generic. Within the program memory only the appropriate address bits
  // will be used (e.g. 10 bits for 1K memory). This means it that you only need to modify 
  // the generic when changing the size of your program.   
  //
  // When JTAG Loader updates the contents of the program memory KCPSM6 should be reset 
  // so that the new program executes from address zero. The Reset During Load port 'rdl' 
  // is therefore connected to the reset input of KCPSM6.
  //

  <your_program> #(
	.C_FAMILY		   ("V6"),   	//Family 'S6' or 'V6'
	.C_RAM_SIZE_KWORDS	(2),  	//Program size '1', '2' or '4'
	.C_JTAG_LOADER_ENABLE	(1))  	//Include JTAG Loader when set to '1' 
  program_rom (    				//Name to match your PSM file
 	.rdl 			(kcpsm6_reset),
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(clk));

  //
  // If your design also needs to be able to reset KCPSM6 the arrangement below should be 
  // used to 'OR' your signal with 'rdl' from the program memory.
  // 

  <your_program> #(
	.C_FAMILY		   ("V6"),   	//Family 'S6' or 'V6'
	.C_RAM_SIZE_KWORDS	(2),     	//Program size '1', '2' or '4'
	.C_JTAG_LOADER_ENABLE	(1))     	//Include JTAG Loader when set to 1'b1 
  program_rom (    		       	//Name to match your PSM file
 	.rdl 			(rdl),
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(clk));
	
  assign kcpsm6_reset = cpu_reset | rdl;

  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // Example of General Purose I/O Ports.
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // The following code corresponds with the circuit diagram shown on page 72 of the 
  // KCPSM6 Guide and includes additional advice and recommendations.
  //
  //

  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // General Purpose Input Ports. 
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  // The inputs connect via a pipelined multiplexer. For optimum implementation, the input
  // selection control of the multiplexer is limited to only those signals of 'port_id' 
  // that are necessary. In this case, only 2-bits are required to identify each of  
  // four input ports to be read by KCPSM6.
  //
  // Note that 'read_strobe' only needs to be used when whatever supplying information to
  // KPPSM6 needs to know when that information has been read. For example, when reading 
  // a FIFO a read signal would need to be generated when that port is read such that the 
  // FIFO would know to present the next oldest information.
  //

  always @ (posedge clk)
  begin

      case (port_id[1:0]) 
      
        // Read input_port_a at port address 00 hex
        2'b00 : in_port <= input_port_a;

        // Read input_port_b at port address 01 hex
        2'b01 : in_port <= input_port_b;

        // Read input_port_c at port address 02 hex
        2'b10 : in_port <= input_port_c;

        // Read input_port_d at port address 03 hex
        2'b11 : in_port <= input_port_d;

        // To ensure minimum logic implementation when defining a multiplexer always
        // use don't care for any of the unused cases (although there are none in this 
        // example).

        default : in_port <= 8'bXXXXXXXX ;  

      endcase

  end

  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // General Purpose Output Ports 
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  // Output ports must capture the value presented on the 'out_port' based on the value of 
  // 'port_id' when 'write_strobe' is High.
  //
  // For an optimum implementation the allocation of output ports should be made in a way 
  // that means that the decoding of 'port_id' is minimised. Whilst there is nothing 
  // logically wrong with decoding all 8-bits of 'port_id' it does result in a function 
  // that can not fit into a single 6-input look up table (LUT6) and requires all signals 
  // to be routed which impacts size, performance and power consumption of your design.
  // So unless you really have a lot of output ports it is best practice to use 'one-hot'
  // allocation of addresses as used below or to limit the number of 'port_id' bits to 
  // be decoded to the number required to cover the ports.
  // 
  // Code examples in which the port address is 04 hex. 
  //
  // Best practice in which one-hot allocation only requires a single bit to be tested.
  // Supports up to 8 output ports with each allocated a different bit of 'port_id'.
  //
  //   if (port_id[2] == 1'b1)  output_port_x <= out_port;  
  //
  //
  // Limited decode in which 5-bits of 'port_id' are used to identify up to 32 ports and 
  // the decode logic can still fit within a LUT6 (the 'write_strobe' requiring the 6th 
  // input to complete the decode).
  // 
  //   if (port_id[4:0] == 5'b00100) output_port_x <= out_port;
  // 
  //
  // The 'generic' code may be the easiest to write with the minimum of thought but will 
  // result in two LUT6 being used to implement each decoder. This will also impact
  // performance and power. This is not generally a problem and hence it is reasonable to 
  // consider this as over attention to detail but good design practice will often bring 
  // rewards in the long term. When a large design struggles to fit into a given device 
  // and/or meet timing closure then it is often the result of many small details rather 
  // that one big cause. PicoBlaze is extremely efficient so it would be a shame to 
  // spoil that efficiency with unnecessarily large and slow peripheral logic.
  //
  //   if port_id = X"04" then output_port_x <= out_port;  
  //

  always @ (posedge clk)
  begin

      // 'write_strobe' is used to qualify all writes to general output ports.
      if (write_strobe == 1'b1) begin

        // Write to output_port_w at port address 01 hex
        if (port_id[0] == 1'b1) begin
          output_port_w <= out_port;
        end

        // Write to output_port_x at port address 02 hex
        if (port_id[1] == 1'b1) begin
          output_port_x <= out_port;
        end

        // Write to output_port_y at port address 04 hex
        if (port_id[2] == 1'b1) begin
          output_port_y <= out_port;
        end

        // Write to output_port_z at port address 08 hex
        if (port_id[3] == 1'b1) begin
          output_port_z <= out_port;
        end

      end

  end






  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // Constant-Optimised Output Ports 
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  // Implementation of the Constant-Optimised Output Ports should follow the same basic 
  // concepts as General Output Ports but remember that only the lower 4-bits of 'port_id'
  // are used and that 'k_write_strobe' is used as the qualifier.
  //

  always @ (posedge clk)
  begin

      // 'k_write_strobe' is used to qualify all writes to constant output ports.
      if (k_write_strobe == 1'b1) begin

        // Write to output_port_k at port address 01 hex
        if (port_id[0] == 1'b1) begin
          output_port_k <= out_port;
        end

        // Write to output_port_c at port address 02 hex
        if (port_id[1] == 1'b1) begin
          output_port_c <= out_port;
        end

      end
  end





  //
  /////////////////////////////////////////////////////////////////////////////////////////
  // Recommended 'closed loop' interrupt interface (when required).
  /////////////////////////////////////////////////////////////////////////////////////////
  //
  // Interrupt becomes active when 'int_request' is observed and then remains active until 
  // acknowledged by KCPSM6. Please see description and waveforms in documentation.
  //

  always @ (posedge clk)
  begin
      if (interrupt_ack == 1'b1) begin
         interrupt <= 1'b0;
      end
      else if (int_request == 1'b1) begin
          interrupt <= 1'b1;
      end
      else begin
          interrupt <= interrupt;
      end
  end

  //
  /////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////
//
// END OF FILE kcpsm6_design_template.v
//
///////////////////////////////////////////////////////////////////////////////////////////

