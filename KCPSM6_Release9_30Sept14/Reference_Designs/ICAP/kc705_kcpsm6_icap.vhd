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
-- 20th August 2014 - Initial version for KC705 board using Vivado 2014.2
--
--
-- INTRODUCTION
--
-- The primary purpose of this reference design is to show how KCPSM6 can communicate with
-- the Internal Configuration Access Port (ICAPE2) inside a 7-Series device. Some specific 
-- interfacing defined in this file is required to facilitate fundamental communication and  
-- then all transactions are implemented by KCPSM6. Please see the descriptions contained 
-- in the PSM files for more details concerning the various transactions.
-- 
-- The code presented implements a reasonable set of operations and should provide adequate
-- reference material for those wanting to implement other procedures (e.g. MultiBoot
-- schemes also require interaction with the configuration registers and KCPSM6 would be
-- and idea way to implement the ICAP communication as well as the MultiBoot control).
-- Please refer to the '7 Series FPGA Configuration User Guide' (UG470) for more details.
-- Although this reference design is not intended to be a definitive description of how
-- ICAP transactions are implemented, the fact that this is a known good working example
-- can help to add 'colour' to the official documentation!
--
-- The design shows the ability to read and write configuration registers. It also shows
-- how to read and write complete frames of configuration memory. Note that YOU are 
-- RESPONSIBLE for the consequences of any modifications that you make to the configuration
-- of a live device. 
--
-- Due to the size of a configuration frame, a BRAM has also been connected to KCPSM6 to 
-- provide a 4096 bytes of RAM storage. Although this design only needs to use some of that
-- space, this is also a useful reference example for reuse in other applications.
--
-- This design should also be useful for those interested in Soft Error Upsets (SEU). The 
-- 7-Series devices have built-in Readback CRC circuits for the detection of SEU as well
-- as built-in error correction circuits. The features implemented by KCPSM6 in this design
-- can enable you to enable and disable these built-in features, monitor their behaviour 
-- and inject configuration errors to test them and your designs (i.e. modify configuration 
-- in the way that an SEU might do). Note that Xilinx provide the Soft Error Mitigation 
-- (SEM) IP core which you should also investigate (see PG036). However, even users of this 
-- core could find it useful to experiment with this design. For example, this design can 
-- generate a complete 'memory map' of the Readback CRC scan of a device.
--
-- This design is based on the 'uart6_kc705.vhd' reference design provided in the KCPSM6
-- package. Please see the 'UART_and_PicoTerm' section for documentation and code 
-- containing longer descriptions and educational code relating to the UART communications.
-- In this case, the design has been set to operate with a clock frequency of 100MHz and 
-- KCPSM6 then determines the clock division factor required to implement UART 
-- communication at 115200 BAUD.
--
-- The KC705 board provides a 200MHz clock to the Kintex-7 device. The maximum clock 
-- frequency that can be applied to ICAPE2 is 100MHz so in this design the 200HMz is 
-- divided by two to form a 100MHz clock that is distributed to all circuits. The 
-- 'clock_frequency_in_MHz' constant has been set to 100 and is read by KCPSM6 which 
-- uses this information to define a UART communication BAUD rate of 115200. 
--
-- Whilst the design is presented as a working example for the XC7K325TFFG900-2 device on 
-- the KC705 Evaluation Board (www.xilinx.com) it could be used with any 7-Series device.
--
-- Please note that PicoTerm must be used with this design. KCPSM6 makes use of some
-- unique PicoTerm features such as being able to open a LOG file.
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

entity kc705_kcpsm6_icap is
  Port (  uart_rx : in std_logic;
          uart_tx : out std_logic;
          cpu_rst : in std_logic;
              led : out std_logic_vector(7 downto 0); 
         clk200_p : in std_logic;
         clk200_n : in std_logic);
  end kc705_kcpsm6_icap;

--
-------------------------------------------------------------------------------------------
--
-- Start of test architecture
--
architecture Behavioral of kc705_kcpsm6_icap is
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

  component icap_control
    generic(             C_FAMILY : string := "7S"; 
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
-- 4096 x 8-bit RAM
--

  component ram_4096x8 is
    Port (  address : in std_logic_vector(11 downto 0);
            data_in : in std_logic_vector(7 downto 0);
           data_out : out std_logic_vector(7 downto 0);
                 we : in std_logic;
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
--
-- Signals used to create 100MHz clock from 200MHz differential clock
--
signal                 clk200 : std_logic;
signal                 clk100 : std_logic := '0';
signal                    clk : std_logic;
--
-- Constant to specify the clock frequency in megahertz.
--
constant clock_frequency_in_MHz : integer range 0 to 255 := 100; 
--
--
-- Signals used to connect KCPSM6
--
signal                 address : std_logic_vector(11 downto 0);
signal             instruction : std_logic_vector(17 downto 0);
signal             bram_enable : std_logic;
signal                 in_port : std_logic_vector(7 downto 0);
signal                out_port : std_logic_vector(7 downto 0);
signal                 port_id : std_logic_vector(7 downto 0);
signal            write_strobe : std_logic;
signal          k_write_strobe : std_logic;
signal             read_strobe : std_logic;
signal               interrupt : std_logic;
signal           interrupt_ack : std_logic;
signal            kcpsm6_sleep : std_logic;
signal            kcpsm6_reset : std_logic;
signal                     rdl : std_logic;
--
-- Signals used to connect UART_TX6
--
signal         uart_tx_data_in : std_logic_vector(7 downto 0);
signal        write_to_uart_tx : std_logic;
signal    uart_tx_data_present : std_logic;
signal       uart_tx_half_full : std_logic;
signal            uart_tx_full : std_logic;
signal            uart_tx_reset : std_logic;
--
-- Signals used to connect UART_RX6
--
signal        uart_rx_data_out : std_logic_vector(7 downto 0);
signal       read_from_uart_rx : std_logic := '0';
signal    uart_rx_data_present : std_logic;
signal       uart_rx_half_full : std_logic;
signal            uart_rx_full : std_logic;
signal           uart_rx_reset : std_logic;
--
-- Signals used to define baud rate
--
signal           set_baud_rate : std_logic_vector(7 downto 0) := "00000000"; 
signal       baud_rate_counter : std_logic_vector(7 downto 0) := "00000000"; 
signal            en_16_x_baud : std_logic := '0';
--
-- Signals used to connect 4096 Byte RAM
--
signal             ram_address : std_logic_vector(11 downto 0) := "000000000000";
signal             ram_data_in : std_logic_vector(7 downto 0);
signal                  ram_we : std_logic;
signal            ram_data_out : std_logic_vector(7 downto 0);
--
--
-- Signals to interface with ICAPE2 
--
signal                  icap_i : std_logic_vector(31 downto 0);   
signal                  icap_o : std_logic_vector(31 downto 0);   
signal               icap_csib : std_logic := '1';                
signal              icap_rdwrb : std_logic := '0';                
signal                icap_din : std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
signal             enable_icap : std_logic := '1';
signal              icap_o_reg : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal          icap_csib_dly1 : std_logic := '1'; 
signal          icap_csib_dly2 : std_logic := '1'; 
signal           icap_o_reg_en : std_logic := '0'; 
signal               icap_dout : std_logic_vector(31 downto 0);
--
-- Signals to interface with FRAME_ECCE2
--
signal        frame_ecc_crcerr : std_logic;
signal        frame_ecc_eccerr : std_logic;
signal  frame_ecc_eccerrsingle : std_logic;
signal           frame_ecc_far : std_logic_vector(25 downto 0);
signal        frame_ecc_synbit : std_logic_vector(4 downto 0);
signal      frame_ecc_syndrome : std_logic_vector(12 downto 0);
signal frame_ecc_syndromevalid : std_logic;
signal       frame_ecc_synword : std_logic_vector(6 downto 0);
--
-- signals to monitor Readback CRC scanning activity
--
signal            scan_counter : std_logic_vector(7 downto 0) := "00000000";
signal             end_of_scan : std_logic := '0';
signal            end_of_frame : std_logic := '0';
--
signal        syndrome_counter : std_logic_vector(23 downto 0) := "000000000000000000000000";
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
  -- Create 100MHz clock from 200MHz differential clock
  -----------------------------------------------------------------------------------------
  --
  -- The maximum clock frequency that can be applied to ICAP is 100MHz. To simplify all 
  -- communication with ICAP, all circuits including KCPSM6 will be operated at 100MHz.
  -- This single clock, fully synchronous arrangement will also ensure reliable operation.
  --

  --
  -- Receive the 200MHz differential clock from the oscillator on the board.
  --

  diff_clk_buffer: IBUFGDS
    port map (  I => clk200_p,
               IB => clk200_n,
                O => clk200);

  --
  -- In this case a simple 1-bit toggle flip-flop is used to divide the clock by two 
  -- which is then distributed by a global clock buffer. Just like the physical external
  -- 200MHz oscillator, this internally generated 100MHz has no particular phase 
  -- relationship with any of the input or outputs signals of the design. As such, there
  -- was no reason to expend an MMCM to implement such a simple clock division although 
  -- one could be used if it were desirable for multiple clocks to have a defined phase
  -- relationship.
  --

  clock_generation: process(clk200)
  begin
    if clk200'event and clk200 = '1' then
      clk100 <= not(clk100);
    end if;
  end process clock_generation;


  --
  -- BUFG used to reach the entire device with 100MHz
  --

  buffer100: BUFG
    port map (   I => clk100,
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
                         interrupt_vector => X"FFF",   
                  scratch_pad_memory_size => 256)
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
  -- Reset by press button or JTAG Loader enabled Program Memory 
  --

  kcpsm6_reset <= rdl or cpu_rst;

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

  program_rom: icap_control
    generic map(             C_FAMILY => "7S", 
                    C_RAM_SIZE_KWORDS => 4,
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
  -- 4096 x 8-bit RAM
  -----------------------------------------------------------------------------------------
  --
  
  ram: ram_4096x8
  port map (  address => ram_address,
              data_in => ram_data_in,
             data_out => ram_data_out,
                   we => ram_we,
                  clk => clk);

  --
  -----------------------------------------------------------------------------------------
  -- General Purpose Input Ports. 
  -----------------------------------------------------------------------------------------
  --

  input_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      case port_id(4 downto 0) is

        -- Read UART status at port address 00 hex
        when "00000" => in_port(0) <= uart_tx_data_present;
                        in_port(1) <= uart_tx_half_full;
                        in_port(2) <= uart_tx_full; 
                        in_port(3) <= uart_rx_data_present;
                        in_port(4) <= uart_rx_half_full;
                        in_port(5) <= uart_rx_full;

        -- Read UART_RX6 data at port address 01 hex
        -- (see 'buffer_read' pulse generation below) 
        when "00001" => in_port <= uart_rx_data_out;
 
        -- Read clock frequency contant at port address 02 hex
        when "00010" => in_port <= conv_std_logic_vector(clock_frequency_in_MHz, 8);

        -- Read 32-bit data from ICAPE2 at addresses 04, 05, 06 and 07 hex
        when "00100" => in_port <= icap_dout(7 downto 0);
        when "00101" => in_port <= icap_dout(15 downto 8);
        when "00110" => in_port <= icap_dout(23 downto 16);
        when "00111" => in_port <= icap_dout(31 downto 24);

        -- Read status signals from FRAME_ECCE2 at port addresse 08 hex
        -- (Only 'crcerr' is currently used in the KCPSM6 program provided)
        when "01000" => in_port(0) <= frame_ecc_crcerr;        -- device CRC error
                        in_port(1) <= frame_ecc_eccerr;        -- frame ECC error
                        in_port(2) <= frame_ecc_eccerrsingle;  -- single bit error detected
                        in_port(3) <= frame_ecc_syndromevalid; -- syndrome output is valid

        -- Read 7-bit syndrome word from FRAME_ECCE2 at port addresse 09 hex
        -- (Not currently used in the KCPSM6 program provided)
        when "01001" => in_port(6 downto 0) <= frame_ecc_synword;  -- word address of error

        -- Read 5-bit syndrome bit from FRAME_ECCE2 at port addresse 0A hex
        -- (Not currently used in the KCPSM6 program provided)
        when "01010" => in_port(4 downto 0) <= frame_ecc_synbit;   -- bit address of error

        -- Read 13-bit syndrome from FRAME_ECCE2 at ports addresse 0C and 0D hex
        -- (Not currently used in the KCPSM6 program provided)
        when "01100" => in_port(7 downto 0) <= frame_ecc_syndrome(7 downto 0);
        when "01101" => in_port(4 downto 0) <= frame_ecc_syndrome(12 downto 8);

       -- Read 26-bit Frame Address from FRAME_ECCE2 at port addresses 10, 11, 12 and 13 hex
        when "10000" => in_port(7 downto 0) <= frame_ecc_far(7 downto 0);
        when "10001" => in_port(7 downto 0) <= frame_ecc_far(15 downto 8);
        when "10010" => in_port(7 downto 0) <= frame_ecc_far(23 downto 16);
        when "10011" => in_port(1 downto 0) <= frame_ecc_far(25 downto 24);

        -- Read the RAM at the defined 'ram_address' at port address 14 hex.
        when "10100" => in_port <= ram_data_out;


        -- Read 'end_of_frame' and 'end_of_scan' pulse at port address 15 hex
        when "10101" => in_port(0) <= end_of_scan;
                        in_port(1) <= end_of_frame;


        -- Specify don't care for all other inputs to obtain optimum implementation
        when others =>  in_port <= "XXXXXXXX";  

      end case;

      -- Generate 'buffer_read' pulse following read of UART data from port address 01

      if (read_strobe = '1') and (port_id(4 downto 0) = "00001") then
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
  -- Note that the assignment and decoding of 'port_id' is a mixture of one-hot and 
  -- encoded resulting in the minimum number of signals actually being decoded for a 
  -- fast and optimum implementation.  
  --
  -- Port      port_id      Purpose
  --  
  --  01       xxxx x0x1    Write to UART
  --  02       xxxx x01x    Set BAUD rate
  --  04       xxxx x100    Set icap_din(7 downto 0)
  --  05       xxxx x101    Set icap_din(15 downto 8)
  --  06       xxxx x110    Set icap_din(23 downto 16)
  --  07       xxxx x111    Set icap_din(31 downto 24)
  --  08       xxxx 1xxx    Set ram_address(7 downto 0)
  --  10       xxx1 xxxx    Set ram_address(11 downto 8)
  --  20       xx1x xxxx    Write to RAM
  --  80       1xxx xxxx    Set LEDs                            < Disconnected
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

        if ((port_id(2) = '0') and (port_id(1) = '1')) then
          set_baud_rate <= out_port;
        end if;

        -- Set 32-bit data for writing to ICAPE2 at port addresses 04, 05, 06 and 07.
        -- port_id(2) is the general selection and then port_id(1:0) selects byte.

        if port_id(2 downto 0) = "100" then
          icap_din(7 downto 0) <= out_port;
        end if;

        if port_id(2 downto 0) = "101" then
          icap_din(15 downto 8) <= out_port;
        end if;

        if port_id(2 downto 0) = "110" then
          icap_din(23 downto 16) <= out_port;
        end if;

        if port_id(2 downto 0) = "111" then
          icap_din(31 downto 24) <= out_port;
        end if;

        -- Set 12-bit address presented to the 4096 x 8-bit RAM at port addresses 08 and 10.

        if port_id(3) = '1' then
          ram_address(7 downto 0) <= out_port;
        end if;

        if port_id(4) = '1' then
          ram_address(11 downto 8) <= out_port(3 downto 0);
        end if;

        -- Write data to 4096 x 8-bit RAM at port addresses 20 hex
        -- See below this clocked process for the combinatorial decode required.


        -- Write to general purpose LEDs at port addresses 80 hex
        
        --if (port_id(7) = '1') then
        --  led <= out_port;
        --end if;

      end if;

    end if; 
  end process output_ports;


  --
  -- Write directly to the FIFO buffer within 'uart_tx6' macro at port address 01 hex.
  -- Note the direct connection of 'out_port' to the UART transmitter macro and the 
  -- way that a single clock cycle write pulse is generated to capture the data.
  -- 

  uart_tx_data_in <= out_port;

  write_to_uart_tx  <= '1' when (write_strobe = '1') and (port_id(2) = '0') and (port_id(0) = '1') 
                           else '0';                     


  --
  -- Write data directly in to the RAM at the defined 'ram_address' at port address 20 hex.
  -- Note the direct connection of 'out_port' to 'ram_data_in' and the way that a single
  -- clock cycle write pulse is generated to store the data.
  -- 

  ram_data_in <= out_port;

  ram_we  <= '1' when (write_strobe = '1') and (port_id(5) = '1')  
                 else '0';                     


  --
  -----------------------------------------------------------------------------------------
  -- Constant-Optimised Output Ports 
  -----------------------------------------------------------------------------------------
  --
  -- One constant-optimised output port is used to facilitate resetting of the UART macros.
  --
  -- 
  --

  constant_output_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      if k_write_strobe = '1' then

        -- Reset FIFO buffers in UART macros at constant port address 1 hex.

        if port_id(0) = '1' then
          uart_tx_reset <= out_port(0);
          uart_rx_reset <= out_port(1);
        end if;

        -- Initiate ICAPE2 operation at constant port address 2 hex
        -- Bit0 defines the value applied to RDWRB; read(1) or write(0) operation.
        -- OUTPUTK to this port will also generate a single clock cycle active 
        -- Low ICAPE2 enable pulse to CSIB (see below).

        if port_id(1) = '1' then
          icap_rdwrb <= out_port(0);
         else
          icap_rdwrb <= icap_rdwrb;
        end if;

      end if;

      -- Generate a single clock cycle active Low ICAPE2 enable pulse to CSIB   
      -- when OUTPUTK instruction to constant port address 2 hex.

      if (k_write_strobe = '1') and (port_id(1) = '1') then
        icap_csib <= '0';
       else
        icap_csib <= '1';
      end if;

    end if; 
  end process constant_output_ports;


  --
  -----------------------------------------------------------------------------------------
  -- ICAPE2 primitive and Interfacing
  -----------------------------------------------------------------------------------------
  --
  -- This primitive is used to supply the clock to the Readback CRC circuitry as well 
  -- provide access to the configuration state machine and configuration memory. 
  -- 
  -- The 'DEVICE_ID' has been set to reflect the XC7K325T device on the KC705 board but
  -- this definition is only used by the simulation model when simulating a design. Note 
  -- also that the '0' at the start of the defined value would probably be a different 
  -- value when reading the real device ID from a XC7K325T device because this is the 
  -- silicon revision field.
  --

  icap: ICAPE2
  generic map(         DEVICE_ID => X"03651093",    -- IDCODE for a 7K325T device
                      ICAP_WIDTH => "X32",          -- native 32-bit interface  
               SIM_CFG_FILE_NAME => "NONE")
  port map(     I => icap_i,                        -- data input 
                O => icap_o,                        -- data output
             CSIB => icap_csib,                     -- enable (active Low)
            RDWRB => icap_rdwrb,                    -- read(1) write(0)
              CLK => clk );                         -- clock also used by Readback CRC

  --
  -- KCPSM6 uses a constant optimised output port to set the RDWRB input to either read(1)
  -- or write(0) a 32-bit word to or from ICAP. The act of setting the RDWRD signal will 
  -- also result in the generation of a single cycle active Low pulse that will be applied
  -- to the CSIB input of ICAP to initiate the read or write operation. 
  --
  -- In order that KCPSM6 can read a 32-bit word from ICAP, the following circuit captures
  -- the output from ICAP into a 32-bit register that holds the value static so that KCPSM6
  -- can read it one byte at a time. Although CSIB is an 'enable' signal, the output of 
  -- ICAP does not remain static when CSIB is inactive (1). Furthermore, a read of ICAP 
  -- involves a latency of 3 clock cycles so the 32-bit register has to be enabled 3 clock 
  -- cycles after ICAP has been enabled in order to sample and capture the correct value.
  --

  icap_interface: process(clk)
  begin

    if clk'event and clk = '1' then

      -- Enable capture of ICAP output data 3 clock cycles after ICAPE2 is enabled
      -- Note that CSIB is active Low so an inversion is required.
 
      icap_csib_dly1 <= icap_csib;
      icap_csib_dly2 <= icap_csib_dly1;
      icap_o_reg_en <= not(icap_csib_dly2);
      
      -- Register to capture ICAP output data 
      if icap_o_reg_en  = '1' then                  
        icap_o_reg <= icap_o;
       else
        icap_o_reg <= icap_o_reg;
      end if;

    end if;

  end process icap_interface;

  --
  -- Connections to ICAPE2 configured in 32-bit access mode requires bit reversal within 
  -- each byte to produce values with a more logical format (i.e. like those described 
  --  and shown in UG470). 
  -- 
  -- Although the following code could be written in a more concise form it is presented 
  -- and defined in this way to make it absolutely clear which bits are being swapped.
  --
  -- Meaningful data to ICAPE2 is called icap_din with the twisted version called icap_i 
  -- corresponding with the port name on the ICAP primitive.
  --
  -- Meaningful data from ICAPE2 is called icap_dout which is derived from the twisted 
  -- version icap_o_reg which is  a direct capture of the icap_o output from the port 
  -- with a corresponding name on the ICAPE2 primitive.
  --

  -- Data to ICAP  

  icap_i(0)  <= icap_din(7);
  icap_i(1)  <= icap_din(6);
  icap_i(2)  <= icap_din(5);
  icap_i(3)  <= icap_din(4);
  icap_i(4)  <= icap_din(3);
  icap_i(5)  <= icap_din(2);
  icap_i(6)  <= icap_din(1);
  icap_i(7)  <= icap_din(0);

  icap_i(8)  <= icap_din(15);
  icap_i(9)  <= icap_din(14);
  icap_i(10) <= icap_din(13);
  icap_i(11) <= icap_din(12);
  icap_i(12) <= icap_din(11);
  icap_i(13) <= icap_din(10);
  icap_i(14) <= icap_din(9);
  icap_i(15) <= icap_din(8);

  icap_i(16) <= icap_din(23);
  icap_i(17) <= icap_din(22);
  icap_i(18) <= icap_din(21);
  icap_i(19) <= icap_din(20);
  icap_i(20) <= icap_din(19);
  icap_i(21) <= icap_din(18);
  icap_i(22) <= icap_din(17);
  icap_i(23) <= icap_din(16);

  icap_i(24) <= icap_din(31);
  icap_i(25) <= icap_din(30);
  icap_i(26) <= icap_din(29);
  icap_i(27) <= icap_din(28);
  icap_i(28) <= icap_din(27);
  icap_i(29) <= icap_din(26);
  icap_i(30) <= icap_din(25);
  icap_i(31) <= icap_din(24);

  -- Data from ICAP  

  icap_dout(0)  <= icap_o_reg(7);  
  icap_dout(1)  <= icap_o_reg(6);  
  icap_dout(2)  <= icap_o_reg(5);  
  icap_dout(3)  <= icap_o_reg(4);  
  icap_dout(4)  <= icap_o_reg(3);  
  icap_dout(5)  <= icap_o_reg(2);  
  icap_dout(6)  <= icap_o_reg(1);  
  icap_dout(7)  <= icap_o_reg(0);
  
  icap_dout(8)  <= icap_o_reg(15);  
  icap_dout(9)  <= icap_o_reg(14);  
  icap_dout(10) <= icap_o_reg(13);  
  icap_dout(11) <= icap_o_reg(12);  
  icap_dout(12) <= icap_o_reg(11);  
  icap_dout(13) <= icap_o_reg(10);  
  icap_dout(14) <= icap_o_reg(9);  
  icap_dout(15) <= icap_o_reg(8); 
 
  icap_dout(16) <= icap_o_reg(23);  
  icap_dout(17) <= icap_o_reg(22);  
  icap_dout(18) <= icap_o_reg(21);  
  icap_dout(19) <= icap_o_reg(20);  
  icap_dout(20) <= icap_o_reg(19);  
  icap_dout(21) <= icap_o_reg(18);  
  icap_dout(22) <= icap_o_reg(17);  
  icap_dout(23) <= icap_o_reg(16); 
 
  icap_dout(24) <= icap_o_reg(31);  
  icap_dout(25) <= icap_o_reg(30);  
  icap_dout(26) <= icap_o_reg(29);  
  icap_dout(27) <= icap_o_reg(28);  
  icap_dout(28) <= icap_o_reg(27);  
  icap_dout(29) <= icap_o_reg(26);  
  icap_dout(30) <= icap_o_reg(25);  
  icap_dout(31) <= icap_o_reg(24);  


  --
  -----------------------------------------------------------------------------------------
  -- FRAME_ECCE2 Primitive 
  -----------------------------------------------------------------------------------------
  --

  frame_ecc: FRAME_ECCE2
  generic map(                FARSRC => "EFAR",
               FRAME_RBT_IN_FILENAME => "NONE")
  port map(       CRCERROR =>  frame_ecc_crcerr,              -- device CRC error
                  ECCERROR =>  frame_ecc_eccerr,              -- frame ECC error
            ECCERRORSINGLE =>  frame_ecc_eccerrsingle,        -- single bit error detected
                       FAR =>  frame_ecc_far,                 -- frame address register value
                    SYNBIT =>  frame_ecc_synbit,              -- bit address of error
                  SYNDROME =>  frame_ecc_syndrome,            -- frame syndrome 
             SYNDROMEVALID =>  frame_ecc_syndromevalid,       -- syndrome output is valid 
                   SYNWORD =>  frame_ecc_synword);            -- word address of error

  --
  -----------------------------------------------------------------------------------------
  -- Readback CRC Monitor
  -----------------------------------------------------------------------------------------
  --
  -- 'SYNDROMEVALID' output of FRAME_ECCE2
  -- 
  -- This signal will pulse High (1) every time a configuration frame has been read and 
  -- indicates that the value being presented on the 'SYNDROME' output is valid and ready 
  -- for inspection (if required). When Readback CRC scanning of the device is enabled, a 
  -- configuration frame is read every 101 clock cycles and therefore 'SYNDROMEVALID' 
  -- typically pulses High for one clock cycle in every 101 clock cycles. The steady 
  -- generation of 'SYNDROMEVALID' pulses is a perfect way to confirm when Readback CRC
  -- scanning is active (i.e. vital for those demanding SEU detection).
  --
  -- When the Readback CRC scan reaches the end of the device there is a slightly larger 
  -- gap of 140 clock cycles between the reading of the last frame of one scan and the
  -- first frame of the next scan. This additional 39 clock cycles can be detected and 
  -- used to identify the end/start of each device scan.
  --
  -- KCPSM6 cannot reliably observe single clock cycle pulses so the following counter 
  -- based circuit is used to stretch the 'SYNDROMEVALID' pulses as well as generate a 
  -- reasonably long pulse indicating the end of a device scan.
  --
  -- An 8-bit counter is generally free to increment every clock cycle but it will be 
  -- reset by each 'SYNDROMEVALID' pulse. In this way the counter typically reaches 100
  -- (64 hex) and then resets (00 hex). However, at the end of each device scan, the 
  -- counter will exceed 100 (64 hex), so when it does reach 101 (65 hex) an 'end_of_scan'
  -- signal is set. providing Readback CRC scanning is active, the next 'SYNDROMEVALID' 
  -- pulse will occur 39 clock cycles later resetting the counter and clearing the 
  -- 'end_of_scan' signal. The 'end_of_scan' pulse is long enough to be seen by KCPSM6. 
  --
  -- If  no 'SYNDROMEVALID' pulse occurs for 255 clock cycles the 8-bit counter will 
  -- saturate at FF hex avoiding false indication of Readback CRC activity. This will 
  -- happen if Readback CRC scanning is disabled or if ICAP is being accessed by KCPSM6. 
  --
  -- So that KCPSM6 can reliably observe 'SYNDROMEVALID' pulses, an 'end_of_frame' pulse 
  -- with a duration of 16 clock cycles is generated for each 'SYNDROMEVALID' pulse that 
  -- is generated by FRAME_ECCE2.
  --
  -- Note that KCPSM6 must poll the input port associated with reading the 'end_of_scan'
  -- and 'end_of_frame' signals at an adequate rate to avoid missing them (at least when
  -- they are relevant to the task). Furthermore, KCPSM6 has a maximum of 101 clock cycles
  -- between 'end_of_frames' to perform any tasks and this equates to the execution of a 
  -- maximum of 50 instructions.
  --  

  scan_monitor: process(clk)
  begin
    if clk'event and clk = '1' then
      if frame_ecc_syndromevalid = '1' then

        -- Reset counter, clear 'end_of_scan' and set 'end_of_frame'
        scan_counter <= "00000000";
        end_of_scan <= '0';
        end_of_frame <= '1';

       else

        -- Increment counter unless saturated  
        if scan_counter = "11111111" then
          scan_counter <= scan_counter;
         else
          scan_counter <= scan_counter + 1;
        end if;

        -- Set end_of_scan when counter goes above 100 (64 hex)
        if scan_counter = "01100100" then
          end_of_scan <= '1';
         else
          end_of_scan <= end_of_scan;
        end if;

        -- Clear 'end_of_frame' when counter reaches 16 (10 hex)
        if scan_counter(4) = '1' then
          end_of_frame <= '0';
         else
          end_of_frame <= end_of_frame;
        end if;

      end if;
    end if;
  end process scan_monitor;

  --
  -----------------------------------------------------------------------------------------
  -- Independent Readback CRC Scan Active Indicator
  -----------------------------------------------------------------------------------------
  --
  -- The SYNDROMEVALID output of FRAME_ECCE2 will pulse High as the Readback CRC mechanism
  -- reads each frame comprising 101 words. A 24-bit counter is used to count and divide 
  -- the pulses observed such that bit16 will have a frequency of ~15Hz and bit23 will have
  -- a frequency of ~0.06Hz (i.e. a period of ~16.9 seconds) when the clock is 100MHz.
  --
  -- The most significant 8-bits are provided to 'scan_indicator' output and are ideal
  -- for connection to 8 LEDs which will provide an instant visual indication of scanning
  -- activity. Note that the PSM code will initially prompt the user to grant the SEM IP
  -- access to ICAP so Readback CRC scanning will only become active once permission has
  -- been granted.
  --
  -- SYNDROMEVALID pulse rate will be 990,099Hz when using a 100MHz clock.
  --
         
  scan_indicator: process(clk)
  begin
    if clk'event and clk = '1' then
      if frame_ecc_syndromevalid = '1' then       
        syndrome_counter <= syndrome_counter + 1;
       else
        syndrome_counter <= syndrome_counter;
      end if;
    end if;
  end process scan_indicator;

  led <= syndrome_counter(23 downto 16);


  --
  -----------------------------------------------------------------------------------------
  --

end Behavioral;

-------------------------------------------------------------------------------------------
--
-- END OF FILE kc705_kcpsm6_icap.vhd
--
-------------------------------------------------------------------------------------------

