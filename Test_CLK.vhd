--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:52:43 02/14/2016
-- Design Name:   
-- Module Name:   /home/almu/RelojBinario2/Test_CLK.vhd
-- Project Name:  RelojBinario2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: digi_clk
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Test_CLK IS
END Test_CLK;
 
ARCHITECTURE behavior OF Test_CLK IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT digi_clk
    PORT(
         clk1 : IN  std_logic;
         seconds : OUT  std_logic_vector(5 downto 0);
         minutes : OUT  std_logic_vector(5 downto 0);
         hours : OUT  std_logic_vector(3 downto 0);
         set_hour : IN  std_logic;
         set_minutes : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk1 : std_logic := '0';
   signal set_hour : std_logic := '0';
   signal set_minutes : std_logic := '0';

 	--Outputs
   signal seconds : std_logic_vector(5 downto 0);
   signal minutes : std_logic_vector(5 downto 0);
   signal hours : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk1_period : time := 31.25 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: digi_clk PORT MAP (
          clk1 => clk1,
          seconds => seconds,
          minutes => minutes,
          hours => hours,
          set_hour => set_hour,
          set_minutes => set_minutes
        );

   -- Clock process definitions
   clk1_process :process
   begin
		clk1 <= '0';
		wait for clk1_period/2;
		clk1 <= '1';
		wait for clk1_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk1_period*10;
      -- insert stimulus here

      wait;
   end process;

END;
