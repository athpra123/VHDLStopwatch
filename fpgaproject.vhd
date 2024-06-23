library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fpgaproject is
Port(clk,rst,stop: In std_logic; Count_LED_S1,Count_LED_S2,Count_LED_M1,Count_LED_M2: Out std_logic_vector(6 downto 0));
end fpgaproject;

Architecture behave of fpgaproject is
	Signal q_s1,q_s2,q_m1,q_m2: std_logic_vector(3 downto 0);
	Signal sclk, srst: std_logic;
	type int_to_bin is array (0 to 9) of std_logic_vector   (3 downto 0);
constant int_bin : int_to_bin :=
("0000","0001","0010","0011","0100","0101","0110","0111","1000","1001");
	Signal temp: std_logic_vector(25 downto 0);
	Signal Count_s1,Count_s2,Count_m1,Count_m2: std_logic_vector(3 downto 0):=(others=>'0');
	begin
		Creating_Slow_Clock: Process(clk, rst)
		begin
			if clk'event and clk='1' then
				if rst='1' then
					srst <= '1';
					temp <= (others=>'0');
				else
					temp <= temp+1;
					sclk <= temp(24);
				if temp(25)='1' then
					srst <='0';
				end if;
				end if;
			end if;
		end process;
		
			
		LED_Interfacing: process(count_s1,count_s2,count_m1,count_m2)
		begin
			case Count_s1 is
				when "0000" => Count_LED_S1 <= "0000001"; -- "0"     
				when "0001" => Count_LED_S1 <= "1001111"; -- "1" 
				when "0010" => Count_LED_S1 <= "0010010"; -- "2" 
				when "0011" => Count_LED_S1 <= "0000110"; -- "3" 
				when "0100" => Count_LED_S1 <= "1001100"; -- "4" 
				when "0101" => Count_LED_S1 <= "0100100"; -- "5" 
				when "0110" => Count_LED_S1 <= "0100000"; -- "6" 
				when "0111" => Count_LED_S1 <= "0001111"; -- "7" 
				when "1000" => Count_LED_S1 <= "0000000"; -- "8"     
				when "1001" => Count_LED_S1 <= "0000001"; -- "9" 
				when others => Count_LED_S1 <= "0000001";
			end case;
			
			case Count_s2 is
				when "0000" => Count_LED_S2 <= "0000001"; -- "0"     
				when "0001" => Count_LED_S2 <= "1001111"; -- "1" 
				when "0010" => Count_LED_S2 <= "0010010"; -- "2" 
				when "0011" => Count_LED_S2 <= "0000110"; -- "3" 
				when "0100" => Count_LED_S2 <= "1001100"; -- "4" 
				when "0101" => Count_LED_S2 <= "0100100"; -- "5" 
				when "0110" => Count_LED_S2 <= "0100000"; -- "6" 
				when "0111" => Count_LED_S2 <= "0001111"; -- "7" 
				when "1000" => Count_LED_S2 <= "0000000"; -- "8"     
				when "1001" => Count_LED_S2 <= "0000001"; -- "9" 
				when others => Count_LED_S1 <= "0000001";
			end case;
			
			case Count_m1 is
				when "0000" => Count_LED_M1 <= "0000001"; -- "0"     
				when "0001" => Count_LED_M1 <= "1001111"; -- "1" 
				when "0010" => Count_LED_M1 <= "0010010"; -- "2" 
				when "0011" => Count_LED_M1 <= "0000110"; -- "3" 
				when "0100" => Count_LED_M1 <= "1001100"; -- "4" 
				when "0101" => Count_LED_M1 <= "0100100"; -- "5" 
				when "0110" => Count_LED_M1 <= "0100000"; -- "6" 
				when "0111" => Count_LED_M1 <= "0001111"; -- "7" 
				when "1000" => Count_LED_M1 <= "0000000"; -- "8"     
				when "1001" => Count_LED_M1 <= "0000001"; -- "9" 
				when others => Count_LED_S1 <= "0000001";
			end case;
			
			case Count_m2 is
				when "0000" => Count_LED_M2 <= "0000001"; -- "0"     
				when "0001" => Count_LED_M2 <= "1001111"; -- "1" 
				when "0010" => Count_LED_M2 <= "0010010"; -- "2" 
				when "0011" => Count_LED_M2 <= "0000110"; -- "3" 
				when "0100" => Count_LED_M2 <= "1001100"; -- "4" 
				when "0101" => Count_LED_M2 <= "0100100"; -- "5" 
				when "0110" => Count_LED_M2 <= "0100000"; -- "6" 
				when "0111" => Count_LED_M2 <= "0001111"; -- "7" 
				when "1000" => Count_LED_M2 <= "0000000"; -- "8"     
				when "1001" => Count_LED_M2 <= "0000001"; -- "9" 
				when others => Count_LED_S1 <= "0000001";
			end case;
		end process;
		
		Slow_Clock_Count: Process(sclk,srst)
		Variable seconds: Integer := 0;
		begin
			if srst='1' then
				q_s1 <= "0000";
				q_s2 <= "0000";
				q_m1 <= "0000";
				q_m2 <= "0000";
				seconds := 0;
			elsif stop='1' then
				q_s1 <= q_s1;
				q_s2 <= q_s2;
				q_m1 <= q_m1;
				q_m2 <= q_m2;
				seconds := seconds;
			elsif (sclk'event and sclk='1') then
				if seconds=3600 then
					seconds:=0;
				else 
					seconds := seconds+1;
				end if;
				q_s1 <= int_bin((seconds mod 60) mod 10);
				q_s2 <= int_bin((seconds mod 60) / 10);
				q_m1 <= int_bin((seconds / 60) mod 10);
				q_m2 <= int_bin((seconds / 60) / 10);
			end if;
			Count_s1 <= q_s1;
			Count_s2 <= q_s2;
			Count_m1 <= q_m1;
			Count_m2 <= q_m2;
		end process;
end behave;