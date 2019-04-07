--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:04:31 04/07/2019
-- Design Name:   
-- Module Name:   /home/almu/VHDL-Binary-Clock/Test_CLK.vhd
-- Project Name:  Binary_Clock
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
         clk : IN  std_logic;
         seconds : INOUT  std_logic_vector(5 downto 0);
         minutes : INOUT  std_logic_vector(5 downto 0);
         hours : INOUT  std_logic_vector(3 downto 0);
         set_hour : IN  std_logic;
         set_minutes : IN  std_logic;
         set_t : IN  std_logic;
         set_enable : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal set_hour : std_logic := '0';
   signal set_minutes : std_logic := '0';
   signal set_t : std_logic := '0';

	--BiDirs
   signal seconds : std_logic_vector(5 downto 0);
   signal minutes : std_logic_vector(5 downto 0);
   signal hours : std_logic_vector(3 downto 0);

 	--Outputs
   signal set_enable : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: digi_clk PORT MAP (
          clk => clk,
          seconds => seconds,
          minutes => minutes,
          hours => hours,
          set_hour => set_hour,
          set_minutes => set_minutes,
          set_t => set_t,
          set_enable => set_enable
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		-- insert stimulus here 

		for t in 0 to 160*4 loop
			set_t <= '0';
			--wait until clk'event and clk='1';
			wait for 100 ns;
		end loop;

		set_t <= '1';
		wait for 100 ns;
		set_t <= '0';
		wait for 100 ns;

		for t in 0 to 160*4 loop
			set_hour <= '1';
			--wait until clk'event and clk='1';
			wait for 100 ns;
		end loop;
		
		set_hour <= '1';
		--wait until clk'event and clk='1';
      wait for 10 ns;
		
		wait for clk_period*10;
      wait;
   end process;

END;
