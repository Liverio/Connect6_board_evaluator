library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit_adder is
	port (a : in STD_LOGIC;
         b : in STD_LOGIC;
         output : out  STD_LOGIC_vector(1 downto 0)
	);
end bit_adder;

architecture bit_adder_arch of bit_adder is
begin
	output(1) <= a and b;
	output(0) <= a xor b;
end bit_adder_arch;

