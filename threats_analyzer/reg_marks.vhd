library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity reg_marks is
   generic(size: positive := 19);
	port (----------------
			---- INPUTS ----
			----------------
			clk : in std_logic;
			rst : in std_logic;
			ld	 : in std_logic;
			din : in std_logic_vector(0 to size-1);
			-----------------
			---- OUTPUTS ----
			-----------------
			dout : out std_logic_vector(0 to size-1)
	);
end reg_marks;

architecture reg_marks_arch of reg_marks is
   signal cs, ns : std_logic_vector(0 to size-1);
begin
	state:
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				cs <= conv_std_logic_vector(0, size);
			else         
				cs <= ns;
			end if;
		end if;
	end process;

   ns <= din when ld = '1' else cs;
	
	dout <= cs;
end reg_marks_arch;