library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.ALL;

entity connect6_evaluator_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4;

		-- Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic;

		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_aclk	: in std_logic;
		s00_axis_aresetn	: in std_logic;
		s00_axis_tready	: out std_logic;
		s00_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s00_axis_tstrb	: in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic
	);
end connect6_evaluator_v1_0;

architecture arch_imp of connect6_evaluator_v1_0 is

	-- component declaration
	component connect6_evaluator_v1_0_S00_AXI is
		generic (C_S_AXI_DATA_WIDTH	: integer	:= 32;
                 C_S_AXI_ADDR_WIDTH	: integer	:= 4
        );
		port (-- Evaluation
              t4_hero, t4_rival : in STD_LOGIC_VECTOR(3-1 downto 0);
              t3_hero, t3_rival : in STD_LOGIC_VECTOR(5-1 downto 0);
              t2_hero, t2_rival : in STD_LOGIC_VECTOR(5-1 downto 0);        
              -- Timer
              game_time : in STD_LOGIC_VECTOR(64-1 downto 0);
              playing   : out STD_LOGIC;
              S_AXI_ACLK	: in std_logic;
              S_AXI_ARESETN	: in std_logic;
              S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
              S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
              S_AXI_AWVALID	: in std_logic;
              S_AXI_AWREADY	: out std_logic;
              S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
              S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
              S_AXI_WVALID	: in std_logic;
              S_AXI_WREADY	: out std_logic;
              S_AXI_BRESP	: out std_logic_vector(1 downto 0);
              S_AXI_BVALID	: out std_logic;
              S_AXI_BREADY	: in std_logic;
              S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
              S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
              S_AXI_ARVALID	: in std_logic;
              S_AXI_ARREADY	: out std_logic;
              S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
              S_AXI_RRESP	: out std_logic_vector(1 downto 0);
              S_AXI_RVALID	: out std_logic;
              S_AXI_RREADY	: in std_logic
        );
	end component connect6_evaluator_v1_0_S00_AXI;

	component connect6_evaluator_v1_0_S00_AXIS
        generic (C_S_AXIS_TDATA_WIDTH	: integer	:= 32);
		port (-- Added ports
		      data	 : OUT STD_LOGIC_VECTOR(C_S_AXIS_TDATA_WIDTH-1 downto 0);
              new_data : OUT STD_LOGIC;
              S_AXIS_ACLK	: in std_logic;
              S_AXIS_ARESETN	: in std_logic;
              S_AXIS_TREADY	: out std_logic;
              S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
              S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
              S_AXIS_TLAST	: in std_logic;
              S_AXIS_TVALID	: in std_logic
        );
	end component;
	
	component board_storage
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
    end component;
	
	component threats_analyzer is
        generic (player : tp_player := HERO);
        port (----------------
                ---- INPUTS ----
                ----------------
                clk, rst : in STD_LOGIC;
                -- Board analysis
                board      : in tp_board;          
                analyze : in STD_LOGIC;          
                -----------------
                ---- OUTPUTS ----
                -----------------
                num_t4 : out std_logic_vector(3-1 downto 0);
                num_t3 : out std_logic_vector(5-1 downto 0);
                num_t2 : out std_logic_vector(5-1 downto 0)
        );
    end component;
    
    component counter
        generic (bits: positive);
        port (clk, rst: in STD_LOGIC;
              rst2 : in STD_LOGIC;
              inc : in STD_LOGIC;
              count : out STD_LOGIC_VECTOR(bits-1 downto 0)
        );
    end component;
    
    -- Board storage
    signal new_data_in: STD_LOGIC;
    signal data_in: STD_LOGIC_VECTOR(32-1 downto 0);
    signal analyze: STD_LOGIC;
    signal board: tp_board;
    
    -- Evaluator
    signal rst: STD_LOGIC;
    signal t4_hero, t4_rival: STD_LOGIC_VECTOR(3-1 downto 0);
    signal t3_hero, t3_rival: STD_LOGIC_VECTOR(5-1 downto 0);
    signal t2_hero, t2_rival: STD_LOGIC_VECTOR(5-1 downto 0);
    
    -- Time measurement
    signal rst_game_timer: STD_LOGIC;
    signal inc_game_timer: STD_LOGIC;
    signal playing: STD_LOGIC;
    signal game_time: STD_LOGIC_VECTOR(64-1 downto 0);
    type states is (IDLE, GAME_IN_PROGRESS);
    signal current_state, next_state: states;
begin
    -- Instantiation of Axi Bus Interface S00_AXI
    connect6_evaluator_v1_0_S00_AXI_inst : connect6_evaluator_v1_0_S00_AXI
        generic map (C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
                     C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH)
        port map (-- Evaluation
                  t4_hero  => t4_hero,
                  t4_rival => t4_rival,
                  t3_hero  => t3_hero,
                  t3_rival => t3_rival,
                  t2_hero  => t2_hero,
                  t2_rival => t2_rival,
                  -- Timer
                  game_time => game_time,
                  playing => playing,
                  S_AXI_ACLK	=> s00_axi_aclk,
                  S_AXI_ARESETN	=> s00_axi_aresetn,
                  S_AXI_AWADDR	=> s00_axi_awaddr,
                  S_AXI_AWPROT	=> s00_axi_awprot,
                  S_AXI_AWVALID	=> s00_axi_awvalid,
                  S_AXI_AWREADY	=> s00_axi_awready,
                  S_AXI_WDATA	=> s00_axi_wdata,
                  S_AXI_WSTRB	=> s00_axi_wstrb,
                  S_AXI_WVALID	=> s00_axi_wvalid,
                  S_AXI_WREADY	=> s00_axi_wready,
                  S_AXI_BRESP	=> s00_axi_bresp,
                  S_AXI_BVALID	=> s00_axi_bvalid,
                  S_AXI_BREADY	=> s00_axi_bready,
                  S_AXI_ARADDR	=> s00_axi_araddr,
                  S_AXI_ARPROT	=> s00_axi_arprot,
                  S_AXI_ARVALID	=> s00_axi_arvalid,
                  S_AXI_ARREADY	=> s00_axi_arready,
                  S_AXI_RDATA	=> s00_axi_rdata,
                  S_AXI_RRESP	=> s00_axi_rresp,
                  S_AXI_RVALID	=> s00_axi_rvalid,
                  S_AXI_RREADY	=> s00_axi_rready
        );

    -- Instantiation of Axi Bus Interface S00_AXIS
    connect6_evaluator_v1_0_S00_AXIS_inst : connect6_evaluator_v1_0_S00_AXIS
        generic map (C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH)
        port map (S_AXIS_ACLK	=> s00_axis_aclk,
                  S_AXIS_ARESETN	=> s00_axis_aresetn,
                  S_AXIS_TREADY	=> s00_axis_tready,
                  S_AXIS_TDATA	=> s00_axis_tdata,
                  S_AXIS_TSTRB	=> s00_axis_tstrb,
                  S_AXIS_TLAST	=> s00_axis_tlast,
                  S_AXIS_TVALID	=> s00_axis_tvalid,
                  -- Added ports
                  data      => data_in,
                  new_data  => new_data_in
        );
    
	-- Add user logic here
	rst <= NOT(s00_axi_aresetn);
	
	board_storage_I: board_storage
        port map(---- INPUTS ----
                 s00_axis_aclk, rst,
                 new_data_in,
                 data_in,
                 ---- OUTPUTS ----
                 board,
                 analyze);
	
	threats_analyzer_HERO: threats_analyzer generic map(HERO)
        port map(---- INPUTS ----
                 s00_axis_aclk, rst,
                 -- Board analysis
                 board,          
                 analyze,
                 ---- OUTPUTS ----
                 t4_hero,
                 t3_hero,
                 t2_hero);
    
    threats_analyzer_RIVAL: threats_analyzer generic map(RIVAL)
        port map(---- INPUTS ----
                 s00_axis_aclk, rst,
                 -- Board analysis
                 board,          
                 analyze,
                 ---- OUTPUTS ----
                 t4_rival,
                 t3_rival,
                 t2_rival);
    
    -- Time measurement
    game_timer: counter generic map(64)
        port map(s00_axi_aclk, rst, rst_game_timer, inc_game_timer, game_time);
    
    -- Timer FSM
    timer_FSM: process(current_state, playing) is
    begin
        -- Defaults                
        rst_game_timer <= '0';
        inc_game_timer <= '0';
        next_state <= current_state;
           
        case current_state is
            when IDLE =>
                if playing = '1' then
                    rst_game_timer <= '1';
                    next_state <= GAME_IN_PROGRESS;
                end if;
            when GAME_IN_PROGRESS =>
                inc_game_timer <= '1';
                if playing = '0' then                    
                    next_state <= IDLE;
                end if;
        end case;
    end process;
    
    state: process (s00_axis_aclk)
    begin              
        if s00_axis_aclk'EVENT and s00_axis_aclk = '1' then
            if rst = '1' then
                current_state <= IDLE;
            else
                current_state <= next_state;
            end if;
        end if;
    end process state;
	
	-- User logic ends

end arch_imp;
