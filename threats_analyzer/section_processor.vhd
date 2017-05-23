library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.types.all;

entity section_processor is
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
end section_processor;

architecture section_processor_arch of section_processor is
	component window_processor
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
	end component;

	component cod_pri
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
	end component;	
	
	component marks_updater
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
	end component;
	
	component counter
		generic (bits: positive := 4);
		port (----------------
				---- INPUTS ----
				----------------
				clk, rst: in STD_LOGIC;
				rst2 : in STD_LOGIC;
				inc  : in STD_LOGIC;
				-----------------
				---- OUTPUTS ----
				-----------------
				count : out STD_LOGIC_VECTOR(bits-1 downto 0));
	end component;	
	
	-- Windows
	type tp_array_windows is array(0 to (section_size-5)-1) of tp_window;
	signal window: tp_array_windows;
	signal t4_found, t3_found, t2_found: STD_LOGIC_VECTOR((section_size-5)-1 downto 0);
	signal current_num_window: STD_LOGIC_VECTOR(4-1 downto 0);
	signal current_window_position: STD_LOGIC_VECTOR(3-1 downto 0);
	
	-- Marks
	signal marks: STD_LOGIC_VECTOR(0 to section_size-1);
	type tp_array_pos_marks is array(0 to (section_size-5)-1) of STD_LOGIC_VECTOR(3-1 downto 0);
	signal pos_to_mark: tp_array_pos_marks;
	signal rst_marks, update_marks: STD_LOGIC;
	
	-- Priority encoders
	signal t4_pending, t3_pending, t2_pending: STD_LOGIC;
	signal window_num_t4, window_num_t3, window_num_t2: STD_LOGIC_VECTOR(4-1 downto 0);
	
	-- Threat counters	
	signal inc_t4, inc_t3, inc_t2: STD_LOGIC;
	
	-- FSM
	type tp_state is (IDLE, PROCESSING);
	signal current_state, next_state: tp_state;
begin
	-- Process all the section in parallel
	windows_gen: for i in 0 to (section_size-5)-1 generate
		window_gen: for j in 0 to 6-1 generate
			window(i)(j) <= section((section_size*2-1)-i*2-j*2 downto (section_size*2-1)-i*2-j*2-1);
		end generate;
		
		window_processor_I: window_processor generic map(player)
			port map (---- INPUTS ----
						 window(i),
						 marks(i to i+5),
						 ---- OUTPUTS ----
						 t4_found(i),
						 t3_found(i),
						 t2_found(i),
						 pos_to_mark(i));
	end generate;
	
	-- Select the leftmost window where a threat was found
	cod_t4: cod_pri generic map(section_size-5) port map (t4_found, t4_pending, window_num_t4);
	cod_t3: cod_pri generic map(section_size-5) port map (t3_found, t3_pending, window_num_t3);
	cod_t2: cod_pri generic map(section_size-5) port map (t2_found, t2_pending, window_num_t2);
	
	-- Muxes to locate the current mark to write
	current_num_window <= window_num_t4 when t4_pending = '1' else
								 window_num_t3 when t3_pending = '1' else
								 window_num_t2;
	
	current_window_position <= pos_to_mark(conv_integer(window_num_t4)) when t4_pending = '1' else
										pos_to_mark(conv_integer(window_num_t3)) when t3_pending = '1' else
										pos_to_mark(conv_integer(window_num_t2));
	
	marks_updater_I: marks_updater generic map(section_size)
		port map(---- INPUTS ----				
					clk, rst_marks, update_marks, current_num_window, current_window_position,					
					---- OUTPUTS ----
					marks);
	rst_marks <= rst OR start;
					
	t4_counter: counter generic map(2) port map(clk, rst, start, inc_t4, num_t4);
	t3_counter: counter generic map(2) port map(clk, rst, start, inc_t3, num_t3);
	t2_counter: counter generic map(2) port map(clk, rst, start, inc_t2, num_t2);	

	-- Control FSM
	control_FSM: process(current_state, start, t4_pending, t3_pending, t2_pending) is
	begin
		-- Defaults		
		update_marks <= '0';
		inc_t4 <= '0';
		inc_t3 <= '0';
		inc_t2 <= '0';		
		next_state <= current_state;
			  
		case current_state is
			when IDLE =>				
				if start = '1' then					
					next_state <= PROCESSING;
				end if;
			
			when PROCESSING =>
				-- Update threats count
				if t4_pending = '1' then
					inc_t4 <= '1';
					update_marks <= '1';
				elsif t3_pending = '1' then
					inc_t3 <= '1';
					update_marks <= '1';
				elsif t2_pending = '1' then
					inc_t2 <= '1';
					update_marks <= '1';
				-- Section explored
				else
					next_state <= IDLE;
				end if;
		end case;
	end process;

	process(clk)
	begin              
		if rising_edge(clk) then
			if rst = '1' then
				current_state <= IDLE;
			else
				current_state <= next_state;
			end if;
	  end if;
	end process;
end section_processor_arch;