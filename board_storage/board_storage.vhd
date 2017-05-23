library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.types.ALL;

entity board_storage is
    port (----------------
          ---- INPUTS ----
          ----------------              
          clk, rst : in STD_LOGIC;
          new_data : in STD_LOGIC;
          data     : in STD_LOGIC_VECTOR(32-1 downto 0);
          -----------------
          ---- OUTPUTS ----
          -----------------
          board   : out tp_board;
          analyze : out STD_LOGIC
    );
end board_storage;

architecture board_storage_arch of board_storage is
    signal count: STD_LOGIC_VECTOR(5-1 downto 0);
    signal row: tp_row;
begin       
	row_conversion: for j in 0 to 16-1 generate
        row(j)  <= data(2*j+1 downto 2*j);
	end generate;
	
	process(clk)                                                                        
    begin                                                                                       
        if rising_edge(clk) then                                                       
            if rst = '1' then
				count <= (others => '0');
				board <= (others => (others => "00"));            
			elsif new_data = '1' AND count = 0 then
                board( 0)(0 to 15) <= row(0 to 15);
				count <= count + 1;
            elsif new_data = '1' AND count = 1 then
                board( 0)(16 to 18) <= row( 0 to 2);
                board( 1)( 0 to 12) <= row( 3 to 15);
                count <= count + 1;
            elsif new_data = '1' AND count = 2 then
                board( 1)(13 to 18) <= row( 0 to 5);
                board( 2)( 0 to  9) <= row( 6 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 3 then
                board( 2)(10 to 18) <= row( 0 to 8);
                board( 3)( 0 to  6) <= row( 9 to 15);
                count <= count + 1;
            elsif new_data = '1' AND count = 4 then
                board( 3)( 7 to 18) <= row( 0 to 11);
                board( 4)( 0 to  3) <= row(12 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 5 then
                board( 4)( 4 to 18) <= row( 0 to 14);
                board( 5)(       0) <= row(      15);
                count <= count + 1;
			elsif new_data = '1' AND count = 6 then
                board( 5)( 1 to 16) <= row( 0 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 7 then
                board( 5)(17 to 18) <= row( 0 to  1);
                board( 6)( 0 to 13) <= row( 2 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 8 then
                board( 6)(14 to 18) <= row( 0 to  4);
                board( 7)( 0 to 10) <= row( 5 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 9 then
                board( 7)(11 to 18) <= row( 0 to  7);
                board( 8)( 0 to  7) <= row( 8 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 10 then
                board( 8)( 8 to 18) <= row( 0 to 10);
                board( 9)( 0 to  4) <= row(11 to 15);
                count <= count + 1;
            elsif new_data = '1' AND count = 11 then
                board( 9)( 5 to 18) <= row( 0 to 13);
                board(10)( 0 to  1) <= row(14 to 15);
                count <= count + 1;
            elsif new_data = '1' AND count = 12 then
                board(10)( 2 to 17) <= row( 0 to 15);                
                count <= count + 1;
			elsif new_data = '1' AND count = 13 then
                board(10)(      18) <= row(       0);
                board(11)( 0 to 14) <= row( 1 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 14 then
                board(11)(15 to 18) <= row( 0 to  3);                
                board(12)( 0 to 11) <= row( 4 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 15 then
                board(12)(12 to 18) <= row( 0 to  6);                
                board(13)( 0 to  8) <= row( 7 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 16 then
                board(13)( 9 to 18) <= row( 0 to  9);                
                board(14)( 0 to  5) <= row(10 to 15);
                count <= count + 1;
            elsif new_data = '1' AND count = 17 then
                board(14)( 6 to 18) <= row( 0 to 12);                
                board(15)( 0 to  2) <= row(13 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 18 then
                board(15)( 3 to 18) <= row( 0 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 19 then
                board(16)( 0 to 15) <= row( 0 to 15);                
                count <= count + 1;
			elsif new_data = '1' AND count = 20 then
                board(16)(16 to 18) <= row( 0 to  2); 
                board(17)( 0 to 12) <= row( 3 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 21 then
                board(17)(13 to 18) <= row( 0 to  5);
                board(18)( 0 to  9) <= row( 6 to 15);
                count <= count + 1;
			elsif new_data = '1' AND count = 22 then
                board(18)(10 to 18) <= row( 0 to  8);                
                count <= count + 1;
			elsif count = 23 then			
                count <= (others => '0');                
            end if;
        end if;
    end process;
    
	analyze <= '1' when count = 23 else '0';
end board_storage_arch;