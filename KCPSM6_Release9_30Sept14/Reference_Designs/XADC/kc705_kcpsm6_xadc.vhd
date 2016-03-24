--
-------------------------------------------------------------------------------------------
-- Copyright © 2011-2013, Xilinx, Inc.
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
--              _  ______ ____  ____  __  __  __  
--             | |/ / ___|  _ \/ ___||  \/  |/ /_ 
--             | ' / |   | |_) \___ \| |\/| | '_ \
--             | . \ |___|  __/ ___) | |  | | (_) )
--             |_|\_\____|_|   |____/|_|  |_|\___/
--                                     
-- 
-- 
-- KCPSM6 reference design on Xilinx KC705 Evaluation Board (www.xilinx.com).
-- 
-- XC7K325T-1FFG900 Device  
--
-- Ken Chapman - Xilinx Ltd.
--
-- 16th January 2013 - Initial version
--   20th March 2013 - Adjustments to initial XADC configuration register values 
--
--
-- The primary purpose of this reference design is to illustrate how to interface KCPSM6
-- with XADC in a 7-Series device. XADC is a dual 12-bit, 1-MSPS analog-to-digital 
-- converter with up to 17 external analog inputs (depending on device, package and 
-- hardware platform) and the ability sample internal power supply rails and measure 
-- die temperature. Please refer to the XADC User Guide UG480 for full descriptions and 
-- technical details.
--
-- This reference design is presented on the KC705 board so there are physical limits to 
-- what can be implemented. Connections are made the XADC Header (J46) which provides 
-- connections to 3 of the external analog inputs but obviously there will be nothing to 
-- measure unless you connect something to the header! For this reason, The KCPSM6 program
-- provided will only measure and display simple values associated with those inputs. 
-- However, the hardware arrangement presented in this file and the KCPSM6 program still 
-- represent a valid and useful starting point for further development of applications 
-- that would exploit the external inputs. 
--
-- Internally to the device, XADC can be used to monitor the VCCINT, VCCBRAM and VCCAUX 
-- power supplies and the die temperature. In these cases, PicoBlaze is ideally suited 
-- to this task and this information becomes the major focus of the KCPSM6 program.  
--
-- XADC is instantiated within this file with initial values assigned to its configuration 
-- registers to define its operation. Quite extensive descriptions are included later in 
-- this file so please take some time to study them. However, the general arrangement is 
-- that XADC has been configured to automatically sequence through the relevant analogue 
-- channels such that KCPSM6 can immediately read valid samples for each. The KCPSM6 
-- program code provided would enable you to modify the configuration of XADC if you 
-- wish to experiment further.
--
-- The design is based on the standard reference designs provided with KCPSM6 (PicoBlaze).
-- These provide a UART-USB connection allowing messages to be displayed on a terminal and 
-- for keyboard entries to allow a degree of control and data input. Please refer to the 
-- documentation provided with KCPSM6 and the UART macros if you need to know more about 
-- PicoBlaze and UART communication. 
--
-- PicoTerm is a simple terminal utility that is also supplied with KCPSM6. For this 
-- reference design to work successfully it MUST be used with PicoTerm as it also exploits  
-- its graphic display to plot a simple graph of die temperature over time. It is hoped 
-- that the simplicity of PicoTerm and its ability to provide simple graphics at the same 
-- time as a basic terminal will also be of interest and be considered for reuse as much 
-- as the hardware and PSM code.
--
-- Please note that this design uses a 200MHz clock.
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
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
-- 
library unisim;
use unisim.vcomponents.all;
--
--
-------------------------------------------------------------------------------------------
--
--

entity kc705_kcpsm6_xadc is
  Port (       uart_rx : in std_logic;
               uart_tx : out std_logic;
               cpu_rst : in std_logic;
             analog_vp : in std_logic; 
             analog_vn : in std_logic; 
         analog_vaux0p : in std_logic; 
         analog_vaux0n : in std_logic; 
         analog_vaux8p : in std_logic; 
         analog_vaux8n : in std_logic; 
              clk200_p : in std_logic;
              clk200_n : in std_logic);
  end kc705_kcpsm6_xadc;

--
-------------------------------------------------------------------------------------------
--
-- Start of test architecture
--
architecture Behavioral of kc705_kcpsm6_xadc is
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

  component xadc_monitor
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
--
-- Signals to distribute a 200MHz clock from the differential input source
--
signal               clk200 : std_logic;
signal                  clk : std_logic;
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
signal uart_tx_data_present : std_logic;
signal    uart_tx_half_full : std_logic;
signal         uart_tx_full : std_logic;
signal        uart_tx_reset : std_logic;
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
signal           baud_count : integer range 0 to 108 := 0; 
signal         en_16_x_baud : std_logic := '0';
--
--
-- Signals used to generate interrupt at one second intervals
--
signal           int_count : integer range 0 to 199999999 := 0;
signal           event_1hz : std_logic := '0';
--
--
-- Signals used to interface with XADC
--
signal           xadc_addr : std_logic_vector(6 downto 0) := "0000000";
signal             xadc_di : std_logic_vector(15 downto 0) := "0000000000000000";
signal            xadc_den : std_logic;
signal            xadc_dwe : std_logic;
signal           xadc_drdy : std_logic;
signal            xadc_tip : std_logic := '0';
signal             xadc_do : std_logic_vector(15 downto 0);
signal      xadc_read_data : std_logic_vector(15 downto 0) := "0000000000000000";
signal                  vp : std_logic;
signal                  vn : std_logic;
signal               vauxp : std_logic_vector(15 downto 0);
signal               vauxn : std_logic_vector(15 downto 0);
signal             xadc_ot : std_logic;
signal            xadc_alm : std_logic_vector(7 downto 0);
signal       xadc_jtagbusy : std_logic;
signal     xadc_jtaglocked : std_logic;
signal   xadc_jtagmodified : std_logic;
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
  -- Create and distribute a 200MHz clock from the differential input
  -----------------------------------------------------------------------------------------
  --

  --
  -- 200MHz differential input clock
  --
 
  clk200_input_buffer: IBUFGDS
    port map (  I => clk200_p,
               IB => clk200_n,
                O => clk200);

  --
  -- BUFG to distribute 200MHz clock 
  --

  clock_100mhz_buffer: BUFG
    port map (   I => clk200,
                 O => clk);

  --
  -----------------------------------------------------------------------------------------
  -- Instantiate KCPSM6 and connect to program ROM
  -----------------------------------------------------------------------------------------
  --
  -- The generics can be defined as required. In this case the 'hwbuild' value is used to 
  -- define a version using the ASCII code for the desired letter and the interrupt vector
  -- has been set to 700 to provide 256 instructions for an Interrupt Service Routine (ISR)
  -- before reaching the end of a 2K memory. 
  -- 
  --

  processor: kcpsm6
    generic map (                 hwbuild => X"43",    -- 43 hex is ASCII character "C"
                         interrupt_vector => X"700",   
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
  -- Reset by press button (active Low) or JTAG Loader enabled Program Memory 
  --

  kcpsm6_reset <= rdl or cpu_rst;


  --
  -- Unused signals tied off until required.
  -- Tying to other signals used to minimise warning messages.
  --

  kcpsm6_sleep <= write_strobe and k_write_strobe;  -- Always '0'

  --
  -- Development Program Memory 
  --   JTAG Loader enabled for rapid code development. 
  --

  program_rom: xadc_monitor
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
  -- Interrupt control
  -----------------------------------------------------------------------------------------
  --
  -- Interrupt is used to provide a 1 second time reference.
  --
  -- A simple binary counter is used to divide the 200MHz clock and provide 
  -- interrupt pulses that remain active until acknowledged by KCPSM6.
  --

  interrupt_control: process(clk)
  begin
    if clk'event and clk='1' then

      -- divide 200MHz by 200,000,000 to form 1Hz pulses

      if int_count=199999999 then
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
  -- XADC 
  -----------------------------------------------------------------------------------------
  --
  -- XADC is a dual 12-bit, 1MSPS analog-to-digital converter with on-chip sensors. 
  -- Please refer to the XADC User Guide UG480 for full descriptions.
  --
  --
  -- External Inputs
  -- ---------------
  --
  -- XADC can observe up to 17 external differential analog inputs. One pair called VP and 
  -- VN are fully dedicated analog input pins. The remaining 16 pairs of pins are called 
  -- auxiliary inputs VAUXP[15:0] and VAUXN[15:0] which can be used as analog inputs or as 
  -- standard digital I/O pins. The auxiliary pins are automatically enabled as analog
  -- inputs when they are connected to the XADC primitive (which also prevents them from 
  -- being used as digital I/O).   
  -- 
  -- On the KC705 board is a an 'XADC Header' (J46) which provides the ability to connect 
  -- analogue signals to VP/VN, VAUXP[0]/VAUXN[0] and VAUXP[8]/VAUXN[8]. This header is 
  -- described in UG810. Obviously something needs to supply signals to this header in 
  -- order that XADC can make any meaningful measurements but this reference design does 
  -- make the connections to the XADC primitive to enable these analog inputs and the 
  -- KCPSM6 program provided does collect samples and display their values to illustrate 
  -- the fundamental techniques.
  --

  vp <= analog_vp;
  vn <= analog_vn;
  vauxp <= "0000000" & analog_vaux8p & "0000000" & analog_vaux0p;
  vauxn <= "0000000" & analog_vaux8n & "0000000" & analog_vaux0n;

  --
  -- Configuration Registers
  -- -----------------------
  --
  -- XADC contains a number of internal registers that are accessed by KCPSM6 via the DRP 
  -- (see 'XADC Interface' below). The first 64 registers (addresses 00 to 3F) are read 
  -- only Status Registers which provide the results of analog-to-digital conversion and a 
  -- variety of other information and status (see the KCPSM6 program and UG480 for more 
  -- details). The next 32 registers (addresses 00 to 3F) are the read/write Configuration 
  -- Registers whose contents define the way in which XADC will operate and a set of 
  -- threshold values.
  --
  -- The configuration registers need to be loaded with values consistent with the behaviour
  -- required for a given application. The registers can be loaded or modified via the DRP 
  -- during operation but it is good practice to pre-load the configuration registers with 
  -- a valid set of initial values by setting the corresponding INIT values as part of the 
  -- instantiation of the XADC primitive. In this way XADC can start working immediately 
  -- after device configuration has completed. 
  --
  --   Hint - The XADC Wizard within the Xilinx CORE Generator can be a more convenient 
  --          way to configure XADC for your own application. However, you would still need
  --          to understand the configuration registers in more detail if KCSPM6 is to 
  --          modify the configuration via the DRP during operation.  
  --
  -- As provided, the configuration registers have been set such that XADC will automatically
  -- sequence through the analogue channels relevant to the Kintex device and KC705 hardware
  -- with thresholds for alarms set to values consistent with the device data sheet. The 
  -- descriptions included below introduce the meaning of each configuration register and 
  -- show the specific definitions contained in this reference design but please refer to 
  -- UG480 for full details of XADC.
  --
  -- Configuration Registers 0, 1 and 2 define the fundamental operating modes of XADC and 
  -- required quite detailed consideration worthy of more description given below.
  --
  --
  -- Configuration Register 0 (INIT_40 = 9400 hex)
  -- ---------------------------------------------
  --
  -- Bits[4:0] are CH[4:0] and are only used in single channel or external multiplexer modes 
  -- so are not relevant in this reference design and set to zero.
  --
  -- Bits[7:0] are always "000".
  --
  -- Bit8 is the 'ACQ' control bit which applies to the external analog inputs only and then
  -- only when XADC is used in single channel mode with continuous sampling. In this design 
  -- the channel sequencer is used so the values of INIT_4E and INIT_4F define the settling 
  -- time individually for each channel (see later).
  --   0 - Standard acquisition time (4 ADCCLK cycles)
  --   1 - Increase settling time to 10 ADCCLK cycles
  -- In this design the ACQ bit defines the standard settling time (ACQ = '0') but it will 
  -- not be recognised because the sequencer is enabled(see 'SEQ[3:0]' bits).
  --
  -- Bit9 is the 'EC' control bit 
  --   0 - Continuous sampling mode used in this reference design
  --   1 - Event driven mode 
  --
  -- Bit10 is the 'BU' control bit which applies to the external analog inputs only
  -- and then only when XADC is used in single channel mode. In this design the channel 
  -- sequencer is used so the input mode of external analog inputs is defined by the 
  -- values of INIT_4C and INIT_4D (see later).   
  --   0 - Unipolar mode ('P' input range 0v to +1.0v with respect to the 'N' input)
  --   1 - Bipolar mode  ('P' input range -0.5v to +0.5v with respect to the 'N' input)
  -- In this design BU = '1' and would apply if the mode was changed to single channel.
  --
  -- Bit11 is the 'MUX' control bit 
  --   0 - Internal analogue multiplexer used in this reference design
  --   1 - External analogue multiplexer
  --
  -- Bits[13:12] are the 'AVG[1:0]' control bits to define the amount of sample averaging 
  --   00 - No averaging 
  --   01 - Average of 16 Samples
  --   10 - Average of 64 Samples
  --   11 - Average of 256 Samples
  -- In this design 256 sample averaging has been selected but this will only be applied to 
  -- the channels defined by INIT_4A and INIT_4B (see later). 
  --
  -- Bit14 is always '0'.
  --
  -- Bit15 is the 'CAVG' control bit 
  --   0 - Averaging enabled for calculation of calibration coefficients
  --   1 - Averaging disabled for calculation of calibration coefficients
  -- In this design averaging is enabled.
  --
  --
  --  INIT_40
  --
  --  CAVG  0  AVG[1:0]   MUX  BU   EC  ACQ  000  CH[4:0]
  --  1     0  11         0    1    0   0    000  00000    = B400 Hex
  --
  --
  --
  --
  -- Configuration Register 1 (INIT_41 = 2EF0 hex)
  -- ---------------------------------------------
  --
  -- Bit0 controls the over-temperature alarm signal OT.
  --   0 - OT alarm is enabled and is used in this reference design
  --   1 - OT alarm is disabled
  --
  -- Bits[11:8] and Bits[3:1] control the other seven alarms ALM[6:0]
  --   ALM[0] - Temperature   Enabled (0) in this design
  --   ALM[1] - VCCINT        Enabled (0) in this design
  --   ALM[2] - VCCAUX        Enabled (0) in this design
  --   ALM[3] - VCCBRAM       Enabled (0) in this design
  --   ALM[4] - VCCPINT       Disabled (1) in this design (only applicable to Zynq)
  --   ALM[5] - VCCPAUX       Disabled (1) in this design (only applicable to Zynq)
  --   ALM[6] - VCCO_DDR      Disabled (1) in this design (only applicable to Zynq)
  --
  -- Bit[7:4] are CAL[3:0] and enable the application of the calibration coefficients to the 
  -- converters and on-chip sensors.  
  --   CAL[0] - ADCs offset correction                       Enabled (1) in this design
  --   CAL[1] - ADCs offset and gain correction              Enabled (1) in this design
  --   CAL[2] - Supply Sensor offset correction              Enabled (1) in this design
  --   CAL[3] - Supply Sensor offset and gain correction     Enabled (1) in this design
  --
  -- Bits[15:12] are SEQ[3:0] and control the channel sequencer
  --   0000 - Default mode
  --   0001 - Single pass sequence
  --   0010 - Continuous sequence mode                  <- In this design
  --   0011 - Single Channel mode (sequencer off)
  --   01xx - Simultaneous sampling mode
  --   10xx - Independent ADC mode
  --   11xx - Default mode
  -- In this design the continuous sequence mode is selected. 
  --
  --
  --  INIT_41
  --
  --  SEQ[3:0]  ALM[6:3]   CAL[3:0]   ALM[2:0]   OT
  --  0010      1110       1111       000        0     = 2EF0 Hex
  --
  --
  --
  --
  -- Configuration Register 2 (INIT_42 = C820 hex)
  -- ---------------------------------------------
  --
  -- Bits[3:0] are always "0000".
  --
  -- Bits[5:4] of this register control the power down selection PD[1:0]. In this reference 
  -- design ADC-B is powered down (turned OFF) to minimise power consumption.
  --
  --  PD1 (bit5)   PD1 (bit5)    ADC-B    ADC-A
  --   0            0             ON       ON
  --   1            0             OFF      ON        <- In this design
  --   0            1             ON       OFF
  --
  -- Bits[7:6] are always "00".
  --
  -- Bits[15:8] of this register define a clock division factor CD[7:0]. DCLK is the clock 
  -- provided to the System Monitor and must be in the range 8 to 250MHz. In this reference 
  -- design a 200MHz clock is provided. Internally to System Monitor an ADCCLK is formed 
  -- through the division of DCLK by the factor CD[7:0]. The ADCCLCK is used to drive the 
  -- A/D converters and must be in the range 1 to 26MHz. 
  --
  -- In this design ADCCLK = 200MHz/8 = 25MHz       Hence CD[7:0] = 8 decimal = 08 hex
  --
  --   Hint - As provided this design is only taking occasional 'measurements' so there
  --          in no compelling reason to sample at a higher rate. The important point is
  --          that the DCLK has been divided such that ADCCLK is within the specified range.  
  --
  -- With ADCCLCK at 25MHz then the actual conversion rate of the A/D will be 961.538KHz 
  -- because each conversion takes 26 ADCCLCK clock cycles. In this design the sequencer 
  -- multiplexes a total of 10 channels (See INIT_48 and INIT_49 below) to the A/D 
  -- resulting in each individual channel being sampled at a rate of 96.154KHz. Sample 
  -- averaging is then applied to certain channels (See INIT_40 and INIT_4A). 
  --
  -- Bits[7:6] and Bits[3:0] are always '0' so the lower 8-bits of INIT_42 are set to 20 hex.
  --
  --
  --  INIT_42
  --
  --  CD[7:0]     00   PD[1:0]  0000
  --  0000 1000   00   10       0000 = 0820 Hex
  --
  --
  --
  --
  -- Channel Sequence Registers 
  -- --------------------------
  -- 
  -- There are 8 control registers associated with the sequencer and these are pre-loaded with
  -- the values defined by INIT_48 through to INIT_4F. There are actually 4 pairs of registers
  -- with each pair providing 32 control bits corresponding with 32 ADC channels as follows. 
  --
  --  Lower Register Bit     ADC Input
  --
  --                   0      XADC Calibration     
  --                   1       unused     
  --                   2       unused    
  --                   3       unused 
  --                   4       unused
  --                   5      VCCINTP  (Zynq Only)
  --                   6      VCCAUXP  (Zynq Only)
  --                   7      VCCO_DDR (Zynq Only)
  --                   8      On-chip temperature
  --                   9      VCCINT  
  --                  10      VCCAUX  
  --                  11      Dedicated external input VP/VN
  --                  12      VREFP (1.25V)
  --                  13      VREFN (0V)   
  --                  14      VCCBRAM
  --                  15       unused  
  --
  --  Upper Register Bit     ADC Input
  --
  --                   0      Auxiliary external input VAUXP[0]/VAUXN[0]    
  --                   1      Auxiliary external input VAUXP[1]/VAUXN[1]     
  --                   2      Auxiliary external input VAUXP[2]/VAUXN[2]     
  --                   3      Auxiliary external input VAUXP[3]/VAUXN[3]  
  --                   4      Auxiliary external input VAUXP[4]/VAUXN[4] 
  --                   5      Auxiliary external input VAUXP[5]/VAUXN[5] 
  --                   6      Auxiliary external input VAUXP[6]/VAUXN[6] 
  --                   7      Auxiliary external input VAUXP[7]/VAUXN[7] 
  --                   8      Auxiliary external input VAUXP[8]/VAUXN[8] 
  --                   9      Auxiliary external input VAUXP[9]/VAUXN[9] 
  --                  10      Auxiliary external input VAUXP[10]/VAUXN[10] 
  --                  11      Auxiliary external input VAUXP[11]/VAUXN[11] 
  --                  12      Auxiliary external input VAUXP[12]/VAUXN[12] 
  --                  13      Auxiliary external input VAUXP[13]/VAUXN[13] 
  --                  14      Auxiliary external input VAUXP[14]/VAUXN[14] 
  --                  15      Auxiliary external input VAUXP[15]/VAUXN[15] 
  -- 
  -- When a bit is set in one of the registers then the corresponding function is enabled for 
  -- the corresponding channel.
  --
  -- ADC Channel Selection INIT_48 (lower) and INIT_49 (upper) select which channels will 
  -- be included then the scanning sequence. In this design all internal sources applicable  
  -- to a Kintex-7 device are included as well as the three external analog channels 
  -- made available on the 'XADC Header' (VP/VN, VAUXP[0]/VAUXN[0] and VAUXP[8]/VAUXN[8]).
  -- XADC calibration is also enabled.
  --   
  --  INIT_48 = 0111 1111 0000 0001 = 7F01 hex
  --  INIT_49 = 0000 0001 0000 0001 = 0101 hex
  --
  -- ADC Channel Averaging INIT_4A (lower) and INIT_4B (upper) apply the amount of sample 
  -- averaging defined by AVG[1:0] in Configuration Register 0 (INIT_40) which in this design
  -- has been set to 256 samples. Averaging has only been enabled for the VCCINT, VCCAUX, 
  -- VCCBRAM and Temperature channels. In this case, the sample rate of each channel works 
  -- out to be 96.154KHz (see previous description of CD[7:0] in Configuration Register 2)
  -- so each channel with the 256 sample averaging enabled will update the value in the 
  -- corresponding status register at 375.6Hz. This update rate is more than adequate for 
  -- monitoring temperature and voltage and the averaging minimises any noise impacts 
  -- (i.e. higher quality values in which more that 12-bits can be trusted).
  --   
  --  INIT_4A = 0100 0111 0000 0000 = 4700 hex
  --  INIT_4B = 0000 0000 0000 0000 = 0000 hex
  --
  -- ADC Channel Analog-Input Mode INIT_4C (lower) and INIT_4D (upper) defines if an input is... 
  --   0 - Unipolar mode  ('P' input range 0v to +1.0v with respect to the 'N' input)
  --   1 - Bipolar mode   ('P' input range -0.5v to +0.5v with respect to the 'N' input)
  -- This definition is only applicable to the external analog inputs and in this design the 
  -- dedicated external input (VP/VN) has been set to Unipolar mode and the two auxiliary 
  -- external inputs (VAUXP[0]/VAUXN[0] and VAUXP[8]/VAUXN[8]) have been defined as Bipolar. 
  --   
  --  INIT_4C = 0000 0000 0000 0000 = 0000 hex
  --  INIT_4D = 0000 0001 0000 0001 = 0101 hex
  --
  -- ADC Channel Settling Time INIT_4E (lower) and INIT_4F (upper) defines the settling time of 
  -- an external input and is only applicable to the external analog inputs.
  --   0 - Standard acquisition time (4 ADCCLK cycles)
  --   1 - Increase settling time to 10 ADCCLK cycles
  -- In this design, three external analog channels are connected to the 'XADC Header' on the 
  -- KC705 board and the standard acquisition time is defined.
  --  
  --  INIT_4E = 0000 0000 0000 0000 = 0000 hex
  --  INIT_4F = 0000 0000 0000 0000 = 0000 hex
  --
  --
  --
  --
  -- Alarm Threshold Registers 
  -- -------------------------
  -- 
  -- INIT_50 through to INIT_5F pre-load 16 registers with voltage or temperature threshold 
  -- values which are used to trigger or clear the various alarm signals. Only the alarms 
  -- selected by OT and ALM[6:0] in Configuration Register 1 (INIT_41) will apply. In this 
  -- design presented on a Kintex-7 device this includes Temperature (OT and ALM[0]), VCCINT 
  -- (ALM[1]), VCCAUX (ALM[2]) and VCCBRAM (ALM[3]).
  --
  -- Note that the combination of continuous sampling mode and the sequencer set up to 
  -- include measurements of Temperature, VCCINT, VCCAUX and VCCBRAM mean that these alarms 
  -- have become automatic in this design and the alarm signals are then monitored by KCPSM6.
  --
  --  Hint - ALM[7] becomes active (1) if one or more the individual alarms become active.
  --         Hence ALM[7] and OT would be suitable signals to generate a KCPSM6 interrupt where
  --         an interrupt service routine (ISR) could then initiate suitable actions depending 
  --         on the specific alarm signal (e.g. OT or ALM[0] could trigger the shutting down of 
  --         high power circuits in order to allow the die temperature to fall). 
  --
  -- The setting of each threshold value is described in the XADC instantiation below.
  -- 




  a_to_d_converters: XADC
    generic map(                              -- 
                                              -- Configuration Registers
                                              -- 
                          INIT_40 => X"B400", -- Configuration register 0    See descriptions 
                          INIT_41 => X"2EF0", -- Configuration register 1    above and UG480 for  
                          INIT_42 => X"0820", -- Configuration register 2    more details  
                                              -- 
                                              -- Factory Test Registers 
                                              -- 
                          INIT_43 => X"0000", -- 0
                          INIT_44 => X"0000", -- 1      ALL TEST REGISTERS  
                          INIT_45 => X"0000", -- 2     SHOULD BE INITIALISED 
                          INIT_46 => X"0000", -- 3   WITH ZERO AND NOT CHANGED 
                          INIT_47 => X"0000", -- 4
                                              -- 
                                              -- Channel Sequence Registers 
                                              -- 
                          INIT_48 => X"7F01", -- Selection (dedicated and on-chip channels)
                          INIT_49 => X"0101", -- Selection (auxiliary channels)
                          INIT_4A => X"4700", -- Averaging (dedicated and on-chip channels)
                          INIT_4B => X"0000", -- Averaging (auxiliary channels)
                          INIT_4C => X"0000", -- Analogue-Input Mode (dedicated channel)
                          INIT_4D => X"0101", -- Analogue-Input Mode (auxiliary channels)
                          INIT_4E => X"0000", -- Settling Time (dedicated and on-chip channels)
                          INIT_4F => X"0000", -- Settling Time (auxiliary channels)
                                              -- 
                                              -- Alarm Registers with initial threshold values defined
                                              -- 
                                              --   16-bit Voltage threshold value = 16 x 4096 x (Voltage / 3)
                                              -- 
                                              --   16-bit Temperature threshold value = 16 x 4096 x ((Temp_degC + 273.15) / 503.975)
                                              -- 
                          INIT_50 => X"B5ED", -- ALM(0) Trigger temperature alarm above this threshold      (85C) 
                          INIT_51 => X"57E5", -- ALM(1) VCCINT upper limit   (1.03v)
                          INIT_52 => X"A148", -- ALM(2) VCCAUX upper limit   (1.89v)
                          INIT_53 => X"CA3F", -- OT     Trigger Over Temperature alarm above this threshold (125C) 
                          INIT_54 => X"A93A", -- ALM(0) Reset temperature alarm below this threshold        (60C)
                          INIT_55 => X"52C6", -- ALM(1) VCCINT Lower limit   (0.97v)
                          INIT_56 => X"91EC", -- ALM(2) VCCAUX Lower limit   (1.71v)
                          INIT_57 => X"AE4F", -- OT     Reset Over Temperature alarm below this threshold   (70C)
                          INIT_58 => X"57E5", -- ALM(3) VCCBRAM upper limit  (1.03v)
                          INIT_59 => X"599A", -- ALM(4) VCCPINT upper limit  (1.05v)    (Zynq only)
                          INIT_5A => X"A148", -- ALM(5) VCCPAUX upper limit  (1.89v)    (Zynq only)
                          INIT_5B => X"A148", -- ALM(6) VCCO_DDR upper limit (1.89v)    (Zynq only)
                          INIT_5C => X"52C6", -- ALM(3) VCCBRAM lower limit  (0.97v)
                          INIT_5D => X"5111", -- ALM(4) VCCPINT lower limit  (0.95v)    (Zynq only)
                          INIT_5E => X"91EC", -- ALM(5) VCCPAUX lower limit  (1.71v)    (Zynq only)
                          INIT_5F => X"6148", -- ALM(6) VCCO_DDR lower limit (1.14v)    (Zynq only) 
                                              --
                       SIM_DEVICE => "7SERIES",
                 SIM_MONITOR_FILE => "xadc_sim_values.txt")    -- Stimulus file for analog simulation
  port map ( 
                                                    -- Dynamic Reconfiguration Port (DRP)
                                                    --                           
                       DO => xadc_do,               -- [15:0] 16-bit data output
                       DI => xadc_di,               -- [15:0] 16-bit data input
                    DADDR => xadc_addr,             -- [6:0]  7-bit register address input 
                      DEN => xadc_den,              --        Enable input
                      DWE => xadc_dwe,              --        Write enable
                     DRDY => xadc_drdy,             --        Data Ready output
                     DCLK => clk,                   --        DRP clock (internally divided to form ADCCLK)
                                                    --                           
                                                    -- External Analogue Inputs (differential)                          
                                                    --                           
                       VP => vp,                    -- Dedicated input (positive)
                       VN => vn,                    --                 (negative)
                    VAUXP => vauxp,                 -- [15:0]  16 Auxiliary inputs (positive)
                    VAUXN => vauxn,                 -- [15:0]                      (negative)
                                                    --                           
                                                    -- Alarm Outputs
                                                    --                           
                      ALM => xadc_alm,              -- [7:0]  8-bit Alarm Bus    
                                                    --    ALM(0) Temperature
                                                    --    ALM(1) VCCINT
                                                    --    ALM(2) VCCAUX
                                                    --    ALM(3) VCCBRAM
                                                    --    ALM(4) VCCPINT  (Zynq only)
                                                    --    ALM(5) VCCPAUX  (Zynq only)
                                                    --    ALM(6) VCCO_DDR (Zynq only)
                                                    --    ALM(7) Active if any of above are active
                       OT => xadc_ot,               -- Over Temperature Alarm
                                                    --                           
                                                    --                           
                                                    -- Status Outputs (active High)
                                                    --                           
                     BUSY => open,                  --       ADC is Busy converting or calibrating
                      EOC => open,                  --       End of Conversion
                      EOS => open,                  --       End of Sequence
                  CHANNEL => open,                  -- [4:0] Input channel last converted
                 JTAGBUSY => xadc_jtagbusy,         --       JTAG transaction in progress
               JTAGLOCKED => xadc_jtaglocked,       --       JTAG has locked DRP (Low indicates DRP accessible)
             JTAGMODIFIED => xadc_jtagmodified,     --       JTAG has written to a configuration register
                  MUXADDR => open,                  -- [4:0] External Analog Multiplexer selection
                                                    --                           
                                                    --                           
                                                    -- Control Inputs (used for event driven sampling)
                                                    --                           
                   CONVST => '0',                   -- Convert Start (active High)
                CONVSTCLK => '0',                   -- Convert Start Clock
                                                    --                           
                                                    --                           
                                                    -- Control Input 
                                                    --                           
                    RESET => '0');                  -- Reset for XADC control logic (active High)


  --
  -----------------------------------------------------------------------------------------
  -- XADC to KCPSM6 Interface using Dynamic Reconfiguration Port (DRP)
  -----------------------------------------------------------------------------------------
  --
  -- This interface enables KCPSM6 to read any of the 64 Status registers and read or write 
  -- any of the 32 Configuration Registers. 
  --
  -- Any read or write operation is initiated by a single clock cycle High strobe being 
  -- applied to the DEN input with the DWE defining the operation as read (0) or write (1). 
  -- A single Constant-Optimised Output Port (2 hex) is used to generate the DEN strobe 
  -- and define DEN when initiating a DRP operation. Please see the 'Constant-Optimised 
  -- Output Ports' section for the definition of this port.
  --
  -- Before a read or write is initiated, the 7-bit address of the register to be accessed 
  -- must be provided on the DADDR input. In the case of a write operation the 16-bit data
  -- to be written to the target register must also be provided on the DI input. Three 
  -- general purpose output ports have been allocated to present address (80 hex) and data
  -- (82 and 83 hex) to XADC. Please see the 'General Purpose Output Ports' section for 
  -- the definition of these output ports.
  --
  -- When reading an XADC register the 16-bit value is provided on the D0 output. However, 
  -- the value is only valid for the one clock cycle in which the DRDY strobe is High. For 
  -- this reason the value is captured in a hardware register (xadc_read_data) so that it 
  -- can be read by KCPSM6. Two input ports have been allocated to read the captured data  
  -- (02 and 03 hex). Please see the 'General Purpose Input Ports' section for the 
  -- definition of these input ports.
  -- 
  -- DRP Operations
  --
  -- Unlike reading or writing a Block Memory (BRAM) a DRP takes a few clock cycles to 
  -- complete each operation. After an operation is initiated by a strobe applied to the 
  -- DEN input, KCPSM6 must wait for XADC to generate a DRDY strobe which signifies that 
  -- the operation has completed. In the case of a read operation, DRDY must also be used
  -- to capture the register value (see above). However, regardless of the operation being 
  -- a read or a write, KCPSM6 must not attempt to perform another XADC operation until 
  -- the DRDY strobe has been generated.  
  --
  -- The single clock cycle DRDY strobe cannot be observed reliably by KCPSM6 so a the 
  -- following logic creates a 'transaction in progress' flag (xadc_tip) which is set by 
  -- the DEN strobe and remains High until the subsequent DRDY strobe is observed. This flag
  -- can then be monitored by KCPSM6 to determine when the operation has completed before 
  -- reading the newly captured data following a read operation or performing another 
  -- transaction.
  --
  -- An KCPSM6 input port (04 hex) has been allocated to observe the 'transaction in progress'
  -- flag. This port can also be used to observe the JTAG status signals and OT alarm from 
  -- XADC. One further input port (05 hex) has been allocated to observe the other voltage 
  -- and temperature alarm signals. Please see the 'General Purpose Input Ports' section for
  -- the definition of these input ports.
  --
  --  Hint - The 'transaction in progress' flag could be applied to the 'sleep' control 
  --         input on KCPSM6 rather than polling the status of a standard input port.
  --                     

  xadc_drp: process(clk)
  begin
    if clk'event and clk='1' then

      if xadc_drdy = '1' then

        -- Capture output data when DRDY is High 
        -- (for both read and write operations to keep logic simple)
        xadc_read_data <= xadc_do;

        -- Clear 'transaction in progress' flag 
        xadc_tip <= '0';

       else

        -- Hold last captured value 
        xadc_read_data <= xadc_read_data;

        -- Check for start of new read or write operation
        if xadc_den = '1' then
          -- Set 'transaction in progress' flag if DEN is High
          xadc_tip <= '1';
         else
          -- Keep current state of flag
          xadc_tip <= xadc_tip;
        end if;
      end if;

    end if; 
  end process xadc_drp;

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
  -- High at 1,843,200Hz which is every 108.51 cycles at 200MHz. In this implementation 
  -- a pulse is generated every 109 cycles resulting is a baud rate of 114,679 baud which
  -- is only 0.45% low and well within limits.
  --

  baud_rate: process(clk)
  begin
    if clk'event and clk = '1' then
      if baud_count = 108 then                   -- counts 109 states including zero
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
  -- generated (see below the clocked process).
  --
  -- This design also defines four further ports associated with the XADC interface. Please
  -- see the 'XADC to KCPSM6 Interface using Dynamic Reconfiguration Port (DRP)' section 
  -- for the description of these output ports and how they are used.
  --
 
  input_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      case port_id(2 downto 0) is

        -- Read UART status at port address 00 hex
        when "000" => in_port(0) <= uart_tx_data_present;
                      in_port(1) <= uart_tx_half_full;
                      in_port(2) <= uart_tx_full; 
                      in_port(3) <= uart_rx_data_present;
                      in_port(4) <= uart_rx_half_full;
                      in_port(5) <= uart_rx_full;

        -- Read UART_RX6 data at port address 01 hex
        -- (see 'buffer_read' pulse generation below) 
        when "001" =>       in_port <= uart_rx_data_out;
 

        -- XADC data (16-bit) read from register at port addresses 02 and 03 hex
        when "010" =>    in_port <= xadc_read_data(7 downto 0);
        when "011" =>    in_port <= xadc_read_data(15 downto 8);


        -- XADC DRP status and OT signals at port address 04 hex
        when "100" =>    in_port(0) <= xadc_tip;
                         in_port(1) <= xadc_jtagbusy;
                         in_port(2) <= xadc_jtaglocked;
                         in_port(3) <= xadc_jtagmodified;
                         in_port(4) <= xadc_ot;

        -- XADC Alarm signals at port address 05 hex
        when "101" =>    in_port <= xadc_alm;


        -- Don't Care for unused cases ensures minimum logic implementation  

        when others =>    in_port <= "XXXXXXXX";  

      end case;

      -- Generate 'buffer_read' pulse following read from port address 01

      if (read_strobe = '1') and (port_id(2 downto 0) = "001") then
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
  -- In this design there are four output ports. 
  --   A port used to write data directly to the FIFO buffer within 'uart_tx6' macro.
  --   Three ports used to present a 7-bit register address and 16-bit data to XADC.
  --
  --   NOTE - The decoding of 'port_id' is a combination of one-hot and encoded 
  --          with the minimum number of signals actually being decoded for a fast
  --          optimum implementation.  
  --

  output_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      -- 'write_strobe' is used to qualify all writes to general output ports.
      if write_strobe = '1' then


        -- XADC register address (7-bit) at port addresses 80 hex

        if (port_id(7) = '1') and (port_id(1) = '0') then
          xadc_addr <= out_port(6 downto 0);
        end if;


        -- XADC data (16-bit) to write to register at port addresses 82 and 83 hex

        if (port_id(7) = '1') and (port_id(1) = '1') and (port_id(0) = '0') then
          xadc_di(7 downto 0) <= out_port;   -- Lower 8-bits
        end if;

        if (port_id(7) = '1') and (port_id(1) = '1') and (port_id(0) = '1') then
          xadc_di(15 downto 8) <= out_port;  -- Upper 8-bits
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

  write_to_uart_tx  <= '1' when (write_strobe = '1') and (port_id(7) = '0') and (port_id(0) = '1')
                           else '0';                     

  --
  -----------------------------------------------------------------------------------------
  -- Constant-Optimised Output Ports 
  -----------------------------------------------------------------------------------------
  --
  -- Two constant-optimised output ports are used in this reference design.
  --

  constant_output_ports: process(clk)
  begin
    if clk'event and clk = '1' then
      if k_write_strobe = '1' then

        -- Reset FIFO buffers in the UART macros at constant port address 1 hex

        if port_id(0) = '1' then
          uart_tx_reset <= out_port(0);
          uart_rx_reset <= out_port(1);
        end if;

      end if;
    end if; 
  end process constant_output_ports;


  --
  -- Initiate DRP transaction with XADC at constant port address 2 hex
  --
  -- Please see the 'XADC to KCPSM6 Interface using Dynamic Reconfiguration Port (DRP)'
  -- section for the description of this constant optimised output port.
  --

  xadc_den <= k_write_strobe and port_id(1);
  xadc_dwe <= out_port(0);

  --
  -----------------------------------------------------------------------------------------
  --

end Behavioral;

-------------------------------------------------------------------------------------------
--
-- END OF FILE kc705_kcpsm6_xadc.vhd
--
-------------------------------------------------------------------------------------------

