library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.types.all;

entity window_processor is
	generic (player : tp_player := HERO);
	port (----------------
			---- INPUTS ----
			----------------
			window : in tp_window;
			marks	 : in STD_LOGIC_VECTOR(0 to 6-1);
			-----------------
			---- OUTPUTS ----
			-----------------
			t4_found : out STD_LOGIC;
			t3_found : out STD_LOGIC;
			t2_found : out STD_LOGIC;
			-- This position will be marked when a threat is found
			rightmost_empty : out STD_LOGIC_VECTOR(3-1 downto 0)
	);
end window_processor;

architecture window_processor_arch of window_processor is
	component adder_6_bits 
		port (----------------
				---- INPUTS ----
				----------------
				input  : in STD_LOGIC_VECTOR(6-1 downto 0);
				-----------------
				---- OUTPUTS ----
				-----------------
				output : out STD_LOGIC_VECTOR (3-1 downto 0)
		);
	end component;

	signal hero_stones: STD_LOGIC_VECTOR(0 to 6-1);
	signal any_rival_stone: STD_LOGIC;
	signal valid_window: STD_LOGIC;
	signal num_stones_hero: STD_LOGIC_VECTOR(3-1 downto 0);
begin
	-- A valid window must be free of marks and rival stones
	stones_HERO: if player = HERO generate
		hero_stones <= window(0)(1) & window(1)(1) & window(2)(1) & window(3)(1) & window(4)(1) & window(5)(1);
		any_rival_stone <= window(0)(0) OR window(1)(0) OR window(2)(0) OR window(3)(0) OR window(4)(0) OR window(5)(0);
	end generate;
	
	stones_RIVAL: if player = RIVAL generate
		hero_stones <= window(0)(0) & window(1)(0) & window(2)(0) & window(3)(0) & window(4)(0) & window(5)(0);
		any_rival_stone <= window(0)(1) OR window(1)(1) OR window(2)(1) OR window(3)(1) OR window(4)(1) OR window(5)(1);
	end generate;	
	
	valid_window <= '1' when marks = "000000" AND any_rival_stone = '0' else '0';
	
	-- #hero_stones
	adder_hero : adder_6_bits port map (hero_stones, num_stones_hero);
	
	-------------
	-- OUTPUTS --
	-------------
	-- t4 or t5
	t4_found <= '1' when valid_window = '1' AND num_stones_hero(2) = '1' else '0';
	t3_found <= '1' when valid_window = '1' AND conv_integer(num_stones_hero) = 3 else '0';
	t2_found <= '1' when valid_window = '1' AND conv_integer(num_stones_hero) = 2 else '0';	
	rightmost_empty <= conv_std_logic_vector(5, 3) when hero_stones(5) = '0' else
							 conv_std_logic_vector(4, 3) when hero_stones(4) = '0' else
							 conv_std_logic_vector(3, 3) when hero_stones(3) = '0' else
							 conv_std_logic_vector(2, 3) when hero_stones(2) = '0' else
							 conv_std_logic_vector(1, 3) when hero_stones(1) = '0' else
							 conv_std_logic_vector(0, 3);
end window_processor_arch;