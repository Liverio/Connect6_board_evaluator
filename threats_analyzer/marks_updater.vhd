library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity marks_updater is
	generic (size: integer := 19);
	port (----------------
			---- INPUTS ----
			----------------
			clk, rst : in STD_LOGIC;
			update : in STD_LOGIC;
			num_window 		 : in STD_LOGIC_VECTOR(4-1 downto 0);
			window_position : in STD_LOGIC_VECTOR(3-1 downto 0);			
			-----------------
			---- OUTPUTS ----
			-----------------
			marks : out STD_LOGIC_VECTOR(0 to size-1) 
    );
end marks_updater;

architecture marks_updater_arch of marks_updater is
	component reg_marks
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
	end component;	

	signal marks_new, current_marks: STD_LOGIC_VECTOR(0 to size-1);
begin
	-- Compose new input
	new_marks_gen: for i in 0 to size-1 generate
							marks_new(i) <= '1' when i = conv_integer(num_window) + conv_integer(window_position) else current_marks(i);
	end generate;
	
	reg_marks_I: reg_marks generic map(size)
		port map (clk, rst, update, marks_new, current_marks);
	
	-------------
	-- OUTPUTS --
	-------------
	marks <= current_marks;
end marks_updater_arch;


