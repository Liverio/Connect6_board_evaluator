library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity adder_6_bits is
	port (----------------
			---- INPUTS ----
			----------------
			input  : in STD_LOGIC_VECTOR(6-1 downto 0);
			-----------------
			---- OUTPUTS ----
			-----------------
         output : out STD_LOGIC_VECTOR (3-1 downto 0)
	);
end adder_6_bits;

architecture adder_6_bits_arch of adder_6_bits is
	component bit_adder 
		port (----------------
				---- INPUTS ----
				----------------
				a : in STD_LOGIC;
				b : in STD_LOGIC;
				-----------------
				---- OUTPUTS ----
				-----------------
				output : out STD_LOGIC_vector(2-1 downto 0)
		);
	end component;
	
	signal temp1, temp2, temp3: STD_LOGIC_vector(2-1 downto 0);
begin
	add1: bit_adder port map (input(0), input(1), temp1);
	add2: bit_adder port map (input(2), input(3), temp2);
	add3: bit_adder port map (input(4), input(5), temp3);
	
	output <= ('0' & temp1) + ('0' & temp2) + ('0' & temp3);
end adder_6_bits_arch;

