----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Almudena Garcia Jurado-Centurion, based on vhdlguru's digital clock code.
-- 
-- Create Date:    22:54:18 02/12/2016 
-- Design Name: 
-- Module Name:    Reloj - Behavioral 
-- Project Name: RelojBinario
-- Target Devices: Papilio One 500K
-- Tool versions: 
-- Description: Binary Clock. Show hours, minutes and seconds using binary system
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: Original code from http://vhdlguru.blogspot.com.es/2010/03/digital-clock-in-vhdl.html
-- 						Adapted for Papilio One 500K
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity digi_clk is
port (clk1 : in std_logic;
      seconds : out std_logic_vector(5 downto 0);
      minutes : out std_logic_vector(5 downto 0);
      hours : out std_logic_vector(3 downto 0);
		set_hour: in std_logic;
		set_minutes: in std_logic
     );
end digi_clk;

architecture Behavioral of digi_clk is
	
	
	signal sec,min,hour : integer range 0 to 60 :=0;
	signal count : integer := 1;
	signal clk : std_logic :='0';
begin
	seconds <= conv_std_logic_vector(sec,6);
	minutes <= conv_std_logic_vector(min,6);
	hours <= conv_std_logic_vector(hour,4);

--	process(set_hour)
--	begin
--		if(set_hour='1') then
--			hour<=hour + 1;
--			if(hour=12) then
--				hour<=0;
--			end if;
--		end if;
--	end process;

	 --clk generation.For 32 MHz clock this generates 1 Hz clock.
	process(clk1)
	begin
		--if(clk1'event and clk1='1') then
		if(rising_edge(clk1)) then
			count <=count+1;
			if(count = 16000000) then
				clk <= not clk;
				count <=1;
			end if;
		end if;
	end process;

	process(clk)   --period of clk is 1 second.
	begin

		if(clk'event and clk='1') then
			sec <= sec + 1;
			if(sec = 59) then
				sec<=0;
				min <= min + 1;
				if(min = 59) then
					hour <= hour + 1;
					min <= 0;
					if(hour = 12) then
						hour <= 0;
					end if;
				end if;
			end if;
		end if;

end process;

end Behavioral;
