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
		set_t: in std_logic
     );
end digi_clk;

architecture Behavioral of digi_clk is
	signal sec_clock,min_clock : integer range 0 to 59 :=0;
	signal hour_clock, hour_set : integer range 0 to 12 :=0;
	signal sec_set,min_set : integer range 0 to 59 :=0;
	signal count : integer := 1;
	signal clk : std_logic :='0';
	
	subtype mystates is std_logic_vector(1 downto 0);
	constant clock: mystates := "00";
	constant set_time: mystates := "01";
	
	signal state: mystates := clock;
begin
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

	transitions: process(set_t, state)
		begin
			case state is	
				when clock => if(set_t = '1') then state <= set_time; else state <= clock; end if;
				when set_time => if(set_t = '1') then state <= clock; else state <= set_time; end if;
				when others => state <= state;
			end case;
	end process;
			
	process(clk)   --period of clk is 1 second.
	begin
			if(clk'event and clk='1' and state = clock) then
				if(sec_clock < 59) then sec_clock <= sec_clock + 1;
				else
					sec_clock <= 0;
					if(min_clock < 59) then min_clock <= min_clock + 1;
					else
						min_clock <= 0;
						if(hour_clock < 12) then hour_clock <= hour_clock + 1;
						else 
							min_clock <= 0;
							hour_clock <= 0;
							sec_clock <= 0;
						end if;
						
					end if;
					
				end if;
				
			end if;
end process;

-- Logica combinacional (instantanea, no requiere de señal de reloj, queremos que las pulsaciones de 
	-- los botones de "set_hour" y "set_min" se hagan instantaneamente y sean independientes del tiempo)
sec_set <= 0 when (state = set_time);
min_set <= min_set + 1 when (state = set_time) and (set_minutes = '1') and (min_set < 59) else 0;
hour_set <= hour_set + 1 when (state = set_time) and (set_hour = '1') and (hour_set < 12) else 0;

-- Asignamos a las salidas, una señal u otra dependiendo del estado en el que estemos
seconds <= conv_std_logic_vector(sec_clock,6) when (state = clock) else conv_std_logic_vector(sec_set,6);
minutes <= conv_std_logic_vector(min_clock,6) when (state = clock) else conv_std_logic_vector(min_set,6);
hours <= conv_std_logic_vector(hour_clock,4) when (state = clock) else conv_std_logic_vector(hour_set,4);


end Behavioral;
