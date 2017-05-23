library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use work.types.ALL;

entity tree_adder is
    generic (output_size : positive := 3);
	port (----------------
		  ---- INPUTS ----
		  ----------------
		  rows		    : in tp_num_threats_19;
		  cols  		: in tp_num_threats_19;
		  diags 		: in tp_num_threats_27;
		  reverse_diags : in tp_num_threats_27;
		  -----------------
		  ---- OUTPUTS ----
		  -----------------
		  output: out STD_LOGIC_VECTOR(output_size-1 downto 0));
end tree_adder;

architecture tree_adder_arch of tree_adder is
	type tp_extended_num_threats_19 is array(0 to 19-1) of STD_LOGIC_VECTOR(output_size-1 downto 0);
	type tp_extended_num_threats_27 is array(0 to 27-1) of STD_LOGIC_VECTOR(output_size-1 downto 0);
	signal rows_extended: tp_extended_num_threats_19;
	signal cols_extended: tp_extended_num_threats_19;
	signal diags_extended: tp_extended_num_threats_27;
	signal reverse_diags_extended: tp_extended_num_threats_27;	
begin	
    extend_rows_cols: for i in 0 to 19-1 generate
        rows_extended(i)(output_size-1 downto 2) <= (others => '0');
        rows_extended(i)(1 downto 0) <= rows(i);
        cols_extended(i)(output_size-1 downto 2) <= (others => '0');
        cols_extended(i)(1 downto 0) <= cols(i);
    end generate;
    
    extend_diags: for i in 0 to 27-1 generate
        diags_extended(i)(output_size-1 downto 2) <= (others => '0');
        diags_extended(i)(1 downto 0) <= diags(i);
        reverse_diags_extended(i)(output_size-1 downto 2) <= (others => '0');
        reverse_diags_extended(i)(1 downto 0) <= reverse_diags(i);
    end generate;	
	
	output <= rows_extended( 0) + cols_extended( 0) + diags_extended( 0) + reverse_diags_extended( 0) +
              rows_extended( 1) + cols_extended( 1) + diags_extended( 1) + reverse_diags_extended( 1) +
              rows_extended( 2) + cols_extended( 2) + diags_extended( 2) + reverse_diags_extended( 2) +
              rows_extended( 3) + cols_extended( 3) + diags_extended( 3) + reverse_diags_extended( 3) +
              rows_extended( 4) + cols_extended( 4) + diags_extended( 4) + reverse_diags_extended( 4) +
              rows_extended( 5) + cols_extended( 5) + diags_extended( 5) + reverse_diags_extended( 5) +
              rows_extended( 6) + cols_extended( 6) + diags_extended( 6) + reverse_diags_extended( 6) +
              rows_extended( 7) + cols_extended( 7) + diags_extended( 7) + reverse_diags_extended( 7) +
              rows_extended( 8) + cols_extended( 8) + diags_extended( 8) + reverse_diags_extended( 8) +
              rows_extended( 9) + cols_extended( 9) + diags_extended( 9) + reverse_diags_extended( 9) +
              rows_extended(10) + cols_extended(10) + diags_extended(10) + reverse_diags_extended(10) +
              rows_extended(11) + cols_extended(11) + diags_extended(11) + reverse_diags_extended(11) +
              rows_extended(12) + cols_extended(12) + diags_extended(12) + reverse_diags_extended(12) +
              rows_extended(13) + cols_extended(13) + diags_extended(13) + reverse_diags_extended(13) +
              rows_extended(14) + cols_extended(14) + diags_extended(14) + reverse_diags_extended(14) +
              rows_extended(15) + cols_extended(15) + diags_extended(15) + reverse_diags_extended(15) +
              rows_extended(16) + cols_extended(16) + diags_extended(16) + reverse_diags_extended(16) +
              rows_extended(17) + cols_extended(17) + diags_extended(17) + reverse_diags_extended(17) +
              rows_extended(18) + cols_extended(18) + diags_extended(18) + reverse_diags_extended(18) +
                                                      diags_extended(19) + reverse_diags_extended(19) +
                                                      diags_extended(20) + reverse_diags_extended(20) +
                                                      diags_extended(21) + reverse_diags_extended(21) +
                                                      diags_extended(22) + reverse_diags_extended(22) +
                                                      diags_extended(23) + reverse_diags_extended(23) +
                                                      diags_extended(24) + reverse_diags_extended(24) +
                                                      diags_extended(25) + reverse_diags_extended(25) +
                                                      diags_extended(26) + reverse_diags_extended(26);
end tree_adder_arch;