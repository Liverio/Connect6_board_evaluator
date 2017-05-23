library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.types.all;

entity threats_analyzer is
	generic (player : tp_player := HERO);
	port (----------------
			---- INPUTS ----
			----------------
			clk, rst : in STD_LOGIC;
			-- Board analysis
			board 	 : in tp_board;		  
			analyze : in STD_LOGIC;		  
			-----------------
			---- OUTPUTS ----
			-----------------
			num_t4 : out std_logic_vector(3-1 downto 0);
			num_t3 : out std_logic_vector(5-1 downto 0);
			num_t2 : out std_logic_vector(5-1 downto 0)
	);
end threats_analyzer;

architecture threats_analyzer_arch of threats_analyzer is
	component section_processor
		generic (section_size: positive := 19; player : tp_player := HERO);
		port(----------------
			  ---- INPUTS ----
			  ----------------
			  clk, rst : in STD_LOGIC;
			  start	 : in STD_LOGIC;		  
			  section : in STD_LOGIC_VECTOR(section_size*2-1 downto 0);
			  -----------------
			  ---- OUTPUTS ----
			  -----------------			  
			  num_t4: out STD_LOGIC_VECTOR(2-1 downto 0);
			  num_t3: out STD_LOGIC_VECTOR(2-1 downto 0);
			  num_t2: out STD_LOGIC_VECTOR(2-1 downto 0)
		);
	end component;
	
	component tree_adder
		generic (output_size : positive := 3);
		port (----------------
				---- INPUTS ----
				----------------
				rows		  : in tp_num_threats_19;
				cols		  : in tp_num_threats_19;
				diags 		  : in tp_num_threats_27;
				reverse_diags : in tp_num_threats_27;
				-----------------
				---- OUTPUTS ----
				-----------------
				output: out STD_LOGIC_VECTOR(output_size-1 downto 0)
		);
	end component;
	
	
	signal section_row, section_col, section_diag, section_reverse_diag: tp_section;
	signal num_t4_row, num_t4_col: tp_num_threats_19;	
	signal num_t3_row, num_t3_col: tp_num_threats_19;
	signal num_t2_row, num_t2_col: tp_num_threats_19;
	signal num_t4_diag, num_t4_reverse_diag: tp_num_threats_27;
	signal num_t3_diag, num_t3_reverse_diag: tp_num_threats_27;
	signal num_t2_diag, num_t2_reverse_diag: tp_num_threats_27;
begin	
	rows: for i in 0 to 19-1 generate
		section_row(i) <= board(i)(0) & board(i)(1) & board(i)(2) & board(i)(3) & board(i)(4) & board(i)(5) & board(i)(6) & board(i)(7) & board(i)(8) & board(i)(9) & board(i)(10) & board(i)(11) & board(i)(12) & board(i)(13) & board(i)(14) & board(i)(15) & board(i)(16) & board(i)(17) & board(i)(18);
		section_processor_rows: section_processor generic map(19, player)
            port map(---- INPUTS ----
                     clk, rst,
                     analyze,
                     section_row(i),
                     ---- OUTPUTS ----
                     num_t4_row(i),
                     num_t3_row(i),
                     num_t2_row(i)
			);
	end generate;
	
	cols: for i in 0 to 19-1 generate
		section_col(i) <= board(0)(i) & board(1)(i) & board(2)(i) & board(3)(i) & board(4)(i) & board(5)(i) & board(6)(i) & board(7)(i) & board(8)(i) & board(9)(i) & board(10)(i) & board(11)(i) & board(12)(i) & board(13)(i) & board(14)(i) & board(15)(i) & board(16)(i) & board(17)(i) & board(18)(i);
		section_processor_cols: section_processor generic map(19, player)
			port map(---- INPUTS ----
						clk, rst,
						analyze,
						section_col(i),
						---- OUTPUTS ----
						num_t4_col(i),
						num_t3_col(i),
						num_t2_col(i)
			);
	end generate;
	
	diags: for i in 0 to 14+13-1 generate
		diag_section(i, board, section_diag(i));
		
		section_processor_diags: section_processor generic map(diag_size(i), player)
			port map(---- INPUTS ----
						clk, rst,
						analyze,
						section_diag(i)(19*2-1 downto (19*2-1)-(diag_size(i)-1)*2-1),
						---- OUTPUTS ----
						num_t4_diag(i),
						num_t3_diag(i),
						num_t2_diag(i)
			);
	end generate;

	reverse_diags: for i in 0 to 14+13-1 generate
		reverse_diag_section(i, board, section_reverse_diag(i));
		
		section_processor_reverse_diags: section_processor generic map(diag_size(i), player)
			port map(---- INPUTS ----
						clk, rst,
						analyze,
						section_reverse_diag(i)(19*2-1 downto (19*2-1)-(diag_size(i)-1)*2-1),
						---- OUTPUTS ----
						num_t4_reverse_diag(i),
						num_t3_reverse_diag(i),
						num_t2_reverse_diag(i)
			);
	end generate;
	
	tree_adder_t4: tree_adder generic map(3)
		port map (num_t4_row,
					 num_t4_col,
					 num_t4_diag,
					 num_t4_reverse_diag,
					 num_t4);
	
	tree_adder_t3: tree_adder generic map(5)
		port map (num_t3_row,
					 num_t3_col,
					 num_t3_diag,
					 num_t3_reverse_diag,
					 num_t3);
	
	tree_adder_t2: tree_adder generic map(5)
		port map (num_t2_row,
					 num_t2_col,
					 num_t2_diag,
					 num_t2_reverse_diag,
					 num_t2);

end threats_analyzer_arch;
