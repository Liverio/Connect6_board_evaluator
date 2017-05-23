library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cod_pri is
	generic (num_elements : positive := 14);
	port (----------------
			---- INPUTS ----
			----------------
			input : in  STD_LOGIC_VECTOR(num_elements-1 downto 0);				
			-----------------
			---- OUTPUTS ----
			-----------------
			active : out STD_LOGIC;
			output : out STD_LOGIC_VECTOR(4-1 downto 0)
	);
end cod_pri;

architecture cod_pri_arch of cod_pri is
begin
	process(input)
	begin
		output <= conv_std_logic_vector(0, 4);
		
		for i in num_elements-1 downto 0 loop
			if input(i) = '1' then
				output <= conv_std_logic_vector(i, 4);
			end if;
		end loop;
	end process;
	
	active <= '1' when input /= conv_std_logic_vector(0, num_elements) else '0';	
end cod_pri_arch;

