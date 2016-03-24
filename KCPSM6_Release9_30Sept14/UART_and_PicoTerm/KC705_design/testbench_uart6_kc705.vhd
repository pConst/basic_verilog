--
-------------------------------------------------------------------------------------------
-- Copyright © 2014, Xilinx, Inc.
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
-- A very simple test bench for use with 'uart6_kc705' reference design.
--
-- 25th June 2014
--
-- Ken Chapman
-- 
-- This test bench will simply provide a clock to the design and enable the KCPSM6 code 
-- to be executed and observed. The following simulation only signals can be displayed 
-- in the waveforms window to really see what KCPSM6 is doing.  
--
--  'kcpsm6_opcode' - A string displaying the instruction being executed.
--                    e.g. "LOAD s7, s4        "
--
--  'kcpsm6_status' - A string displaying the status of KCPSM6.
--                    e.g. "A,NZ,NC,ID,Reset" representing...
--                                              Register bank 'A' is active.
--                                              Zero flag is reset (0).
--                                              Carry flag is reset (0).
--                                              Interrupts are disabled.
--                                              Internal reset is active.
--
--  'sim_s0' through to 'sim_sF' 
--                - Contents of registers s0 through to sF.  
--
--  'sim_spm00' through to 'sim_spmFF' 
--                - Contents of scratch pad memory locations 00 through to FF.  
--
-- 
-------------------------------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 
-------------------------------------------------------------------------------------------
--

entity testbench_uart6_kc705 is
end testbench_uart6_kc705;

-- 
-------------------------------------------------------------------------------------------
--

architecture behavior of testbench_uart6_kc705 is 

  -- Design to be tested

  component uart6_kc705 
  Port (  uart_rx : in std_logic;
          uart_tx : out std_logic;
         clk200_p : in std_logic;
         clk200_n : in std_logic);
  end component;

-- 
-------------------------------------------------------------------------------------------
--

-- Signals to connect to design being tested
--
-- Initial values include the UART receiving a High level which is 
-- the normal level for an inactive serial line that is connected.

signal  uart_rx : std_logic := '1';
signal  uart_tx : std_logic;
signal clk200_p : std_logic := '0';
signal clk200_n : std_logic := '1';

-- Signals used for test purposes only. 

signal  max_cycles : integer := 5000;
signal cycle_count : integer := 1;

-- 
-------------------------------------------------------------------------------------------
--

begin

  -- 
  -----------------------------------------------------------------------------------------
  --
  -- Instantiate the design under test
  -- 
  -----------------------------------------------------------------------------------------
  --

   uut: uart6_kc705 
   port map (  uart_rx => uart_rx,
               uart_tx => uart_tx,
              clk200_p => clk200_p,
              clk200_n => clk200_n);

  -- 
  -----------------------------------------------------------------------------------------
  --
  -- Simulation 
  -- 
  -----------------------------------------------------------------------------------------
  --
  -- Simulate a 200MHz differential clock as provided on the KC705 board.
  --
  -- The test bench simulates for a specified number of clock cycles previously defined by 
  -- 'max_cycles'. The current clock cycle is defined by 'cycle_count'. In this way the 
  -- simulation as a pre-defined duration and stimulus can be defined relative to a clock
  -- cycles rather than using absolute times.
  --
 
  simulate_clock: process
    begin

      -- Simulate for a specified number of 'cycles'
      while cycle_count < max_cycles loop

        -- 'clk200_p' starts Low and 'clk200_n' starts High.
        -- After 2.5ns the first transition occurs and 
        --   'clk200_p' goes High and'clk200_n' goes Low.
    
        wait for 2.5 ns;
        clk200_p <= '1';
        clk200_n <= '0';

        -- After another 2.5ns the second transition occurs and 
        --   'clk200_p' returns to Low and 'clk200_n' returns to Low.
    
        wait for 2.5 ns;
        clk200_p <= '0';
        clk200_n <= '1';

        -- This completes once full clock cycle so the cycle counter is incremented.

        cycle_count <= cycle_count + 1;

      end loop;

      wait; -- end of simulation.
  
  end process simulate_clock;

end;

-- 
-------------------------------------------------------------------------------------------
--
-- End of file 'testbench_uart6_kc705.vhd'.
--
-------------------------------------------------------------------------------------------
--

