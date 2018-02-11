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


--Copyright (C) 2016  Almudena Garcia Jurado-Centurion

--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.

--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <http://www.gnu.org/licenses/>

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
		set_minutes: in std_logic;
		set_t: in std_logic;
		set_enable: out std_logic
     );
end digi_clk;

architecture Behavioral of digi_clk is
	signal min_set, sec_clk, min_clk: integer range 0 to 60 := 0;
	signal hour_set, hour_clk: integer range 0 to 12 := 0; 
	signal count : integer := 1;
	signal clk : std_logic :='0';
	
	subtype mystates is std_logic_vector(1 downto 0);
	constant clock: mystates := "00";
	constant set_time: mystates := "01";
	constant wait_toset: mystates := "10";
	constant wait_toclock: mystates := "11";
	
	signal state: mystates := clock;
	
begin
	seconds <= conv_std_logic_vector(sec_clk,6) when(state = clock) else conv_std_logic_vector(0,6);
	minutes <= conv_std_logic_vector(min_clk,6) when(state = clock) else  conv_std_logic_vector(min_set, 6);
	hours <= conv_std_logic_vector(hour_clk,4) when(state = clock) else conv_std_logic_vector(hour_set,4);
	set_enable <= set_t;

	transitions: process(clk1)
		begin
			if(clk1'event and clk1='1') then
				case state is	
					when clock => if(set_t = '1') then state <= wait_toset; else state <= clock; end if;
					when wait_toset => if(set_t = '0') then state <= set_time; else state <= wait_toset; end if;
					when set_time => if(set_t = '1') then state <= wait_toclock; else state <= set_time; end if;
					when wait_toclock => if(set_t = '0') then state <= clock; else state <= wait_toclock; end if;
					when others => state <= clock;
				end case;
		end if;
	end process;

	process(set_t)
	begin
		if(state = set_time) then
	
			if(set_hour='1') then
				if(hour_set = 12) then
					hour_set <= 0;
				else hour_set <= hour_set + 1;
				end if;
			end if;
			
			if(set_minutes='1') then
				if(min_set < 59) then
					min_set <= min_set + 1;
				else min_set <= 0;
				end if;
			end if;
		end if;
		
	end process;

	 --clk generation.For 32 MHz clock this generates 1 Hz clock.
	process(clk1)
	begin
		if(clk1'event and clk1='1') then
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
			sec_clk <= sec_clk + 1;
			if(sec_clk = 59) then
				sec_clk <=0;
				min_clk <= min_clk + 1;
				if(min_clk = 59) then
					hour_clk <= hour_clk + 1;
					min_clk <= 0;
					if(hour_clk = 12) then
						hour_clk <= 0;
					end if;
				end if;
			end if;
		end if;

end process;

end Behavioral;
