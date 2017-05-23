library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

package types is
	-- Board
	subtype tp_square is STD_LOGIC_VECTOR(2-1 downto 0);
--	type tp_board is array(0 to 19-1, 0 to 19-1) of tp_square;
	type tp_row is array(0 to 19-1) of tp_square;
	type tp_board is array(0 to 19-1) of tp_row;
	
	constant SQUARE_FREE	: STD_LOGIC_VECTOR(2-1 downto 0) := "00";
	constant SQUARE_RIVAL: STD_LOGIC_VECTOR(2-1 downto 0) := "01";
	constant SQUARE_HERO	: STD_LOGIC_VECTOR(2-1 downto 0) := "10";
	
	-- Window
	type tp_window is array(0 to 6-1) of tp_square;
	
	-- Section processor inputs/outputs
	type tp_section is array(0 to 14+13-1) of STD_LOGIC_VECTOR(19*2-1 downto 0);
	type tp_num_threats_19 is array(0 to 19-1) of STD_LOGIC_VECTOR(2-1 downto 0);	
	type tp_num_threats_27 is array(0 to 27-1) of STD_LOGIC_VECTOR(2-1 downto 0);	
	
	-- Player
	subtype tp_player is STD_LOGIC;
	
	constant HERO : STD_LOGIC := '0';
	constant RIVAL: STD_LOGIC := '1';
	
	-- Diagonal size
	function diag_size(diag_num: natural) return positive;
	procedure diag_section(diag_num		  : in natural;
								  signal board	  : in tp_board;
								  signal section : out STD_LOGIC_VECTOR(19*2-1 downto 0));
	procedure reverse_diag_section(diag_num	  : in natural;
											 signal board : in tp_board;
											 signal section : out STD_LOGIC_VECTOR(19*2-1 downto 0));
end types;

package body types is
	-- Diagonal size
	function diag_size(diag_num: natural) return positive is
	begin
		if diag_num < 14 then
			return diag_num + 6;
		else
			return 32 - diag_num;
		end if;
	end function;
	
	procedure diag_section(diag_num	   : in natural;
								  signal board : in tp_board;
								  signal section : out STD_LOGIC_VECTOR(19*2-1 downto 0)) is
		variable row, col: integer;
	begin
		-- Locate diagonal in the board		
		if diag_num <= 13 then
			row := 5 + diag_num;
			col := 0;
		else
			row := 18;
			col := diag_num - 13;
		end if;
		
		for i in 0 to diag_size(diag_num)-1 loop
			section((19*2-1)-i*2 downto (19*2-1)-i*2-1) <= board(row-i)(col+i);
		end loop;
		
		-- Not used
		for i in diag_size(diag_num) to 18 loop
			section((19*2-1)-i*2 downto (19*2-1)-i*2-1) <= "00";
		end loop;
	end procedure;
	
	procedure reverse_diag_section(diag_num	  : in natural;
											 signal board : in tp_board;
											 signal section : out STD_LOGIC_VECTOR(19*2-1 downto 0)) is
		variable row, col: integer;
	begin
		-- Locate diagonal in the board		
		if diag_num <= 13 then
			row := 0;
			col := 13 - diag_num;
		else
			row := diag_num - 13;
			col := 0;
		end if;
				
		for i in 0 to diag_size(diag_num)-1 loop
			section((19*2-1)-i*2 downto (19*2-1)-i*2-1) <= board(row+i)(col+i);
		end loop;
		
		-- Not used
		for i in diag_size(diag_num) to 18 loop
			section((19*2-1)-i*2 downto (19*2-1)-i*2-1) <= "00";
		end loop;
	end procedure;
end types;