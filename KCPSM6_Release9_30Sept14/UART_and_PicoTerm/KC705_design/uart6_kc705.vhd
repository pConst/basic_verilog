--
-------------------------------------------------------------------------------------------
-- Copyright © 2011-2014, Xilinx, Inc.
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
-- Ken Chapman - Xilinx Ltd.
--
-- 20th June 2014 - Initial version for KC705 board using Vivado 2014.1
--
-- This reference design provides a simple UART communication example. Please see 
-- 'UART6_User_Guide_and_Reference_Designs_30Sept14.pdf' (or later) for more detailed 
-- descriptions.
--
-- The KC705 board provides a 200MHz clock to the Kintex-7 device which is used by all 
-- circuits in this design including KCPSM6 and the UART macros. In this example, KCPSM6
-- computes a constant which is applied to a clock division circuit to define a UART 
-- communication BAUD rate of 115200. 
--
-- Whilst the design is presented as a working example for the XC7K325TFFG900-2 device on 
-- the KC705 Evaluation Board (www.xilinx.com), it is a simple reference design that is 
-- easily adapted or incorporated into a design for use with any hardware platform. Indeed,
-- the method presented to define the BAUD rate can make this code even easier to port as
-- it only requires one constant to be defined and KCPSM6 works out everything else. 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--
library unisim;
use unisim.vcomponents.all;
--
-------------------------------------------------------------------------------------------
--
--

entity uart6_kc705 is
  Port (  uart_rx : in std_logic;
          uart_tx : out std_logic;
         clk200_p : in std_logic;
         clk200_n : in std_logic);
  end uart6_kc705;

--
-------------------------------------------------------------------------------------------
--
-- Start of test architecture
--
architecture Behavioral of uart6_kc705 is
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

  component auto_baud_rate_control
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
-- Signals used to create internal 200MHz clock from 200MHz differential clock
--
signal               clk200 : std_logic;
signal                  clk : std_logic;
--
-- Constant to specify the clock frequency in megahertz.
--
constant clock_frequency_in_MHz : integer range 0 to 255 := 200; 
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
signal            interrupt : std_logic;
signal        interrupt_ack : std_logic;
signal         kcpsm6_sleep : std_logic;
signal         kcpsm6_reset : std_logic;
signal                  rdl : std_logic;
--
-- Signals used to connect UART_TX6
--
signal      uart_tx_data_in : std_logic_vector(7 downto 0);
signal     write_to_uart_tx : std_logic;
signal        pipe_port_id0 : std_logic := '0';
signal uart_tx_data_present : std_logic;
signal    uart_tx_half_full : std_logic;
signal         uart_tx_full : std_logic;
signal         uart_tx_reset : std_logic;
--
-- Signals used to connect UART_RX6
--
signal     uart_rx_data_out : std_logic_vector(7 downto 0);
signal    read_from_uart_rx : std_logic := '0';
signal uart_rx_data_present : std_logic;
signal    uart_rx_half_full : std_logic;
signal         uart_rx_full : std_logic;
signal        uart_rx_reset : std_logic;
--
-- Signals used to define baud rate
--
signal        set_baud_rate : std_logic_vector(7 downto 0) := "00000000"; 
signal    baud_rate_counter : std_logic_vector(7 downto 0) := "00000000"; 
signal         en_16_x_baud : std_logic := '0';
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
  -- Create and distribute an internal 200MHz clock from 200MHz differential clock
  -----------------------------------------------------------------------------------------
  --
  
  diff_clk_buffer: IBUFGDS
    port map (  I => clk200_p,
               IB => clk200_n,
                O => clk200);

  --
  -- BUFG used to reach the entire device with 200MHz
  --

  buffer200: BUFG
    port map (   I => clk200,
                 O => clk);

  --
  -----------------------------------------------------------------------------------------
  -- Instantiate KCPSM6 and connect to program ROM
  -----------------------------------------------------------------------------------------
  --
  -- The generics can be defined as required. In this case the 'hwbuild' value is used to 
  -- define a version using the ASCII code for the desired letter. 
  --

  processor: kcpsm6
    generic map (                 hwbuild => X"41",    -- 41 hex is ASCII Character "A"
                         interrupt_vector => X"7FF",   
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
  -- Reset connected to JTAG Loader enabled Program Memory
  --

  kcpsm6_reset <= rdl;

  --
  -- Unused signals tied off until required.
  -- Tying to other signals used to minimise warning messages.
  --

  kcpsm6_sleep <= write_strobe and k_write_strobe;  -- Always '0'
  interrupt <= interrupt_ack;

  --
  -- Development Program Memory 
  --   JTAG Loader enabled for rapid code development. 
  --

  program_rom: auto_baud_rate_control
    generic map(             C_FAMILY => "7S", 
                    C_RAM_SIZE_KWORDS => 2,
                 C_JTAG_LOADER_ENABLE => 1)
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => rdl,
                       clk => clk);



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
  -- UART baud rate 
  -----------------------------------------------------------------------------------------
  --
  -- The baud rate is defined by the frequency of 'en_16_x_baud' pulses. These should occur  
  -- at 16 times the desired baud rate. KCPSM6 computes and sets an 8-bit value into 
  -- 'set_baud_rate' which is used to divide the clock frequency appropriately.
  -- 
  -- For example, if the clock frequency is 200MHz and the desired serial communication 
  -- baud rate is 115200 then PicoBlaze will set 'set_baud_rate' to 6C hex (108 decimal). 
  -- This circuit will then generate an 'en_16_x_baud' pulse once every 109 clock cycles 
  -- (note that 'baud_rate_counter' will include state zero). This would actually result 
  -- in a baud rate of 114,679 baud but that is only 0.45% low and well within limits.
  --

  baud_rate: process(clk)
  begin
    if clk'event and clk = '1' then
      if baud_rate_counter = set_baud_rate then         
        baud_rate_counter <= "00000000"; 
        en_16_x_baud <= '1';                     -- single cycle enable pulse
       else
        baud_rate_counter <= baud_rate_counter + 1;
        en_16_x_baud <= '0';
      end if;
    end if;
  end process baud_rate;


  --
  -----------------------------------------------------------------------------------------
  -- General Purpose Input Ports. 
  -----------------------------------------------------------------------------------------
  --
  -- Three input ports are used with the UART macros. 
  -- 
  --   The first is used to monitor the flags on both the transmitter and receiver.
  --   The second is used to read the data from the receiver and generate a 'buffer_read' 
  --     pulse. 
  --   The third is used to read a user defined constant that enabled KCPSM6 to know the 
  --     clock frequency so that it can compute values which will define the BAUD rate 
  --     for UART communications (as well as values used to define software delays).
  --

  input_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      case port_id(1 downto 0) is

        -- Read UART status at port address 00 hex
        when "00" =>   in_port(0) <= uart_tx_data_present;
                       in_port(1) <= uart_tx_half_full;
                       in_port(2) <= uart_tx_full; 
                       in_port(3) <= uart_rx_data_present;
                       in_port(4) <= uart_rx_half_full;
                       in_port(5) <= uart_rx_full;

        -- Read UART_RX6 data at port address 01 hex
        -- (see 'buffer_read' pulse generation below) 
        when "01" =>      in_port <= uart_rx_data_out;
 
        -- Read clock frequency contant at port address 02 hex
        when "10" =>      in_port <= conv_std_logic_vector(clock_frequency_in_MHz, 8);

        -- Specify don't care for all other inputs to obtain optimum implementation
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
  -- In this design there are two general purpose output ports. 
  --
  --   A port used to write data directly to the FIFO buffer within 'uart_tx6' macro.
  -- 
  --   A port used to define the communication BAUD rate of the UART.
  --
  -- Note that the assignment and decoding of 'port_id' is a one-hot resulting 
  -- in the minimum number of signals actually being decoded for a fast and 
  -- optimum implementation.  
  --

  output_ports: process(clk)
  begin
    if clk'event and clk = '1' then

      -- 'write_strobe' is used to qualify all writes to general output ports.
      if write_strobe = '1' then

        -- Write to UART at port addresses 01 hex
        -- See below this clocked process for the combinatorial decode required.

        -- Write to 'set_baud_rate' at port addresses 02 hex     
        -- This value is set by KCPSM6 to define the BAUD rate of the UART. 
        -- See the 'UART baud rate' section for details.

        if (port_id(1) = '1') then
          set_baud_rate <= out_port;
        end if;

      end if;

      --
      -- *** To reliably achieve 200MHz performance when writing to the FIFO buffer
      --     within the UART transmitter, 'port_id' is pipelined to exploit both of  
      --     the clock cycles that it is valid.
      --

      pipe_port_id0 <= port_id(0);

    end if; 
  end process output_ports;


  --
  -- Write directly to the FIFO buffer within 'uart_tx6' macro at port address 01 hex.
  -- Note the direct connection of 'out_port' to the UART transmitter macro and the 
  -- way that a single clock cycle write pulse is generated to capture the data.
  -- 

  uart_tx_data_in <= out_port;

  -- See *** above for definition of 'pipe_port_id0'. 

  write_to_uart_tx  <= '1' when (write_strobe = '1') and (pipe_port_id0 = '1')
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
-- END OF FILE uart6_kc705.vhd
--
-------------------------------------------------------------------------------------------
