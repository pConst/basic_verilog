--
-------------------------------------------------------------------------------------------
-- Copyright © 2011-2012, Xilinx, Inc.
-- This file contains confidential and proprietary information of Xilinx, Inc. and is
-- protected under U.S. and international copyright and other intellectual property laws.
-------------------------------------------------------------------------------------------
--
-- Disclaimer:
-- This disclaimer is not a license and does not grant any rights to the materials
-- distributed herewith. Except as otherwise provided in a valid license issued to
-- you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
-- MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
-- DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
-- INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
-- OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
-- (whether in contract or tort, including negligence, or under any other theory
-- of liability) for any loss or damage of any kind or nature related to, arising
-- under or in connection with these materials, including for any direct, or any
-- indirect, special, incidental, or consequential loss or damage (including loss
-- of data, profits, goodwill, or any type of loss or damage suffered as a result
-- of any action brought by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-safe, or for use in any
-- application requiring fail-safe performance, such as life-support or safety
-- devices or systems, Class III medical devices, nuclear facilities, applications
-- related to the deployment of airbags, or any other applications that could lead
-- to death, personal injury, or severe property or environmental damage
-- (individually and collectively, "Critical Applications"). Customer assumes the
-- sole risk and liability of any use of Xilinx products in Critical Applications,
-- subject only to applicable laws and regulations governing limitations on product
-- liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------------------
--
--
-- KCPSM6 reference design using 'uart_tx6' and 'uart_rx6'macros.
--
-- Target platform - ATLYS Spartan-6 Board (www.digilentinc.com).
--                   To be used in conjunction with the PicoTerm terminal.
--
--
-- Ken Chapman - Xilinx Ltd.
--
-- 6th September 2012 - Initial version
--
--
-- This reference design primarily provides an example of UART communication. It also 
-- includes some simple I/O ports (switches and LEDs) together with a simple example of
-- a KCPSM6 interrupt. The KCPSM6 program provided with this hardware design demonstrates 
-- each of these KCPSM6 features together with features of PicoTerm.
--
-- Please see 'UART6_User_Guide_30Sept12.pdf' for more descriptions.
--
-- The code in this example is set to implement a 115200 UART baud rate and generates 
-- interrupts at one second intervals based on a 100MHz clock.
--
-- Whilst the design is presented as a working example for the XC6SLX45-2CSG324 device on
-- the ATLYS Spartan-6 Board (www.digilentinc.com), it is a simple reference design that
-- is easily adapted or incorporated into a design for use with any hardware platform.
-- 
--
-------------------------------------------------------------------------------------------
--
-- Library declarations
--
-- Standard IEEE libraries
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
--
-------------------------------------------------------------------------------------------
--
--

entity uart6_atlys is
  Port ( uart_rx : in std_logic;
         uart_tx : out std_logic;
             led : out std_logic_vector(7 downto 0);
          switch : in std_logic_vector(7 downto 0);
         reset_b : in std_logic;
             clk : in std_logic);
  end uart6_atlys;

--
-------------------------------------------------------------------------------------------
--
-- Start of test architecture
--
architecture Behavioral of uart6_atlys is
--
-------------------------------------------------------------------------------------------
--
-- Components
--
-------------------------------------------------------------------------------------------
--

--
-- declaration of KCPSM6
--

  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;


--
-- Development Program Memory
--

  component atlys_real_time_clock
    generic(             C_FAMILY : string := "S6"; 
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
  end component;

--
-- UART Transmitter with integral 16 byte FIFO buffer
--

  component uart_tx6 
    Port (             data_in : in std_logic_vector(7 downto 0);
                  en_16_x_baud : in std_logic;
                    serial_out : out std_logic;
                  buffer_write : in std_logic;
           buffer_data_present : out std_logic;
              buffer_half_full : out std_logic;
                   buffer_full : out std_logic;
                  buffer_reset : in std_logic;
                           clk : in std_logic);
  end component;

--
-- UART Receiver with integral 16 byte FIFO buffer
--

  component uart_rx6 
    Port (           serial_in : in std_logic;
                  en_16_x_baud : in std_logic;
                      data_out : out std_logic_vector(7 downto 0);
                   buffer_read : in std_logic;
           buffer_data_present : out std_logic;
              buffer_half_full : out std_logic;
                   buffer_full : out std_logic;
                  buffer_reset : in std_logic;
                           clk : in std_logic);
  end component;

--
--
-------------------------------------------------------------------------------------------
--
-- Signals
--
-------------------------------------------------------------------------------------------
--
--
-- Signals used to connect KCPSM6
--
signal              address : std_logic_vector(11 downto 0);
signal          instruction : std_logic_vector(17 downto 0);
signal          bram_enable : std_logic;
signal              in_port : std_logic_vector(7 downto 0);
signal             out_port : std_logic_vector(7 downto 0);
signal              port_id : std_logic_vector(7 downto 0);
signal         write_strobe : std_logic;
signal       k_write_strobe : std_logic;
signal          read_strobe : std_logic;
signal            interrupt : std_logic := '0';
signal        interrupt_ack : std_logic;
signal         kcpsm6_sleep : std_logic;
signal         kcpsm6_reset : std_logic;
signal                  rdl : std_logic;
--
-- Signals used to connect UART_TX6
--
signal      uart_tx_data_in : std_logic_vector(7 downto 0);
signal     write_to_uart_tx : std_logic;
signal uart_tx_data_present : std_logic;
signal    uart_tx_half_full : std_logic;
signal         uart_tx_full : std_logic;
signal         uart_tx_reset : std_logic;
--
-- Signals used to connect UART_RX6
--
signal     uart_rx_data_out : std_logic_vector(7 downto 0);
signal    read_from_uart_rx : std_logic;
signal uart_rx_data_present : std_logic;
signal    uart_rx_half_full : std_logic;
signal         uart_rx_full : std_logic;
signal        uart_rx_reset : std_logic;
--
-- Signals used to define baud rate
--
signal           baud_count : integer range 0 to 53 := 0; 
signal         en_16_x_baud : std_logic := '0';
--
--
-- Signals used to generate interrupt at one second intervals
--
signal        int_count : integer range 0 to 99999999 := 0;
signal        event_1hz : std_logic := '0';
--
--
-------------------------------------------------------------------------------------------
--
-- Start of circuit description
--
-------------------------------------------------------------------------------------------
--
begin

  --
  -----------------------------------------------------------------------------------------
  -- Instantiate KCPSM6 and connect to program ROM
  -----------------------------------------------------------------------------------------
  --
  -- The generics can be defined as required. In this case the 'hwbuild' value is used to 
  -- define a version using the ASCII code for the desired letter and the interrupt vector
  -- has been set to 3C0 to provide 64 instructions for an Interrupt Service Routine (ISR)
  -- before reaching the end of a 1K memory 
  -- 
  --

  processor: kcpsm6
    generic map (                 hwbuild => X"41",    -- 41 hex is ASCII character "A"
                         interrupt_vector => X"3C0",   
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
 

  --
  -- Reset by press button (active Low) or JTAG Loader enabled Program Memory 
  --

  kcpsm6_reset <= rdl or not(reset_b);


  --
  -- Unused signals tied off until required.
  -- Tying to other signals used to minimise warning messages.
  --

  kcpsm6_sleep <= write_strobe and k_write_strobe;  -- Always '0'


  --
  -- Development Program Memory 
  --   JTAG Loader enabled for rapid code development. 
  --

  program_rom: atlys_real_time_clock
    generic map(             C_FAMILY => "S6", 
                    C_RAM_SIZE_KWORDS => 1,
                 C_JTAG_LOADER_ENABLE => 1)
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => rdl,
                       clk => clk);


  --
  -----------------------------------------------------------------------------------------
  -- Interrupt control
  -----------------------------------------------------------------------------------------
  --
  -- Interrupt is used to provide a 1 second time reference.
  --
  -- A simple binary counter is used to divide the 100MHz clock and provide 
  -- interrupt pulses that remain active until acknowledged by KCPSM6.
  --

  interrupt_control: process(clk)
  begin
    if clk'event and clk='1' then

      --divide 100MHz by 100,000,000 to form 1Hz pulses

      if int_count=99999999 then
         int_count <= 0;
         event_1hz <= '1';
       else
         int_count <= int_count + 1;
         event_1hz <= '0';
      end if;

      -- Interrupt becomes active each second and remains active until acknowledged

      if interrupt_ack = '1' then
         interrupt <= '0';
        else
         if event_1hz = '1' then
          interrupt <= '1';
         else
          interrupt <= interrupt;
        end if;
      end if;

    end if; 
  end process interrupt_control;

  --
  -----------------------------------------------------------------------------------------
  -- UART Transmitter with integral 16 byte FIFO buffer
  -----------------------------------------------------------------------------------------
  --
  -- Write to buffer in UART Transmitter at port address 01 hex
  -- 

  tx: uart_tx6 
  port map (              data_in => uart_tx_data_in,
                     en_16_x_baud => en_16_x_baud,
                       serial_out => uart_tx,
                     buffer_write => write_to_uart_tx,
              buffer_data_present => uart_tx_data_present,
                 buffer_half_full => uart_tx_half_full,
                      buffer_full => uart_tx_full,
                     buffer_reset => uart_tx_reset,              
                              clk => clk);


  --
  -----------------------------------------------------------------------------------------
  -- UART Receiver with integral 16 byte FIFO buffer
  -----------------------------------------------------------------------------------------
  --
  -- Read from buffer in UART Receiver at port address 01 hex.
  --
  -- When KCPMS6 reads data from the receiver a pulse must be generated so that the 
  -- FIFO buffer presents the next character to be read and updates the buffer flags.
  -- 
  
  rx: uart_rx6 
  port map (            serial_in => uart_rx,
                     en_16_x_baud => en_16_x_baud,
                         data_out => uart_rx_data_out,
                      buffer_read => read_from_uart_rx,
              buffer_data_present => uart_rx_data_present,
                 buffer_half_full => uart_rx_half_full,
                      buffer_full => uart_rx_full,
                     buffer_reset => uart_rx_reset,              
                              clk => clk);

  --
  -----------------------------------------------------------------------------------------
  -- RS232 (UART) baud rate 
  -----------------------------------------------------------------------------------------
  --
  -- To set serial communication baud rate to 115,200 then en_16_x_baud must pulse 
  -- High at 1,843,200Hz which is every 54.28 cycles at 100MHz. In this implementation 
  -- a pulse is generated every 54 cycles resulting is a baud rate of 115,741 baud which
  -- is only 0.5% high and well within limits.
  --

  baud_rate: process(clk)
  begin
    if clk'event and clk = '1' then
      if baud_count = 53 then                    -- counts 54 states including zero
        baud_count <= 0;
        en_16_x_baud <= '1';                     -- single cycle enable pulse
       else
        baud_count <= baud_count + 1;
        en_16_x_baud <= '0';
      end if;
    end if;
  end process baud_rate;

  --
  -----------------------------------------------------------------------------------------
  -- General Purpose Input Ports. 
  -----------------------------------------------------------------------------------------
  --
  -- Two input ports are used with the UART macros. The first is used to monitor the flags
  -- on both the UART transmitter and receiver. The second is used to read the data from 
  -- the UART receiver. Note that the read also requires a 'buffer_read' pulse to be 
  -- generated.
  --
  -- This design includes a third input port to read 8 general purpose switches.
  --

  input_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      case port_id(1 downto 0) is

        -- Read UART status at port address 00 hex
        when "00" =>  in_port(0) <= uart_tx_data_present;
                      in_port(1) <= uart_tx_half_full;
                      in_port(2) <= uart_tx_full; 
                      in_port(3) <= uart_rx_data_present;
                      in_port(4) <= uart_rx_half_full;
                      in_port(5) <= uart_rx_full;

        -- Read UART_RX6 data at port address 01 hex
        -- (see 'buffer_read' pulse generation below) 
        when "01" =>       in_port <= uart_rx_data_out;
 

        -- Read 8 general purpose switches at port address 02 hex
        when "10" =>       in_port <= switch;

        -- Don't Care for unused case(s) ensures minimum logic implementation  

        when others =>    in_port <= "XXXXXXXX";  

      end case;

      -- Generate 'buffer_read' pulse following read from port address 01

      if (read_strobe = '1') and (port_id(1 downto 0) = "01") then
        read_from_uart_rx <= '1';
       else
        read_from_uart_rx <= '0';
      end if;
 
    end if;
  end process input_ports;


  --
  -----------------------------------------------------------------------------------------
  -- General Purpose Output Ports 
  -----------------------------------------------------------------------------------------
  --
  -- In this simple example there are two output ports. 
  --   A simple output port used to control a set of 8 general purpose LEDs.
  --   A port used to write data directly to the FIFO buffer within 'uart_tx6' macro.
  --

  --
  -- LEDs are connected to a typical KCPSM6 output port. 
  --  i.e. A register and associated decode logic to enable data capture.
  -- 

  output_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      -- 'write_strobe' is used to qualify all writes to general output ports.
      if write_strobe = '1' then

        -- Write to LEDs at port address 02 hex
        if port_id(1) = '1' then
          led <= out_port;
        end if;

      end if;
    end if; 
  end process output_ports;


  --
  -- Write directly to the FIFO buffer within 'uart_tx6' macro at port address 01 hex.
  -- Note the direct connection of 'out_port' to the UART transmitter macro and the 
  -- way that a single clock cycle write pulse is generated to capture the data.
  -- 

  uart_tx_data_in <= out_port;

  write_to_uart_tx  <= '1' when (write_strobe = '1') and (port_id(0) = '1')
                           else '0';                     

  --
  -----------------------------------------------------------------------------------------
  -- Constant-Optimised Output Ports 
  -----------------------------------------------------------------------------------------
  --
  -- One constant-optimised output port is used to facilitate resetting of the UART macros.
  --

  constant_output_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      if k_write_strobe = '1' then

        if port_id(0) = '1' then
          uart_tx_reset <= out_port(0);
          uart_rx_reset <= out_port(1);
        end if;

      end if;
    end if; 
  end process constant_output_ports;

  --
  -----------------------------------------------------------------------------------------
  --

end Behavioral;

-------------------------------------------------------------------------------------------
--
-- END OF FILE uart6_atlys.vhd
--
-------------------------------------------------------------------------------------------

