library ieee;
use ieee.std_logic_1164.all;

entity tb_FSM_jeu_de_dame is
end tb_FSM_jeu_de_dame;

architecture tb of tb_FSM_jeu_de_dame is

    component FSM_jeu_de_dame
        port (clk                      : in std_logic;
              rst                      : in std_logic;
              e_fin_rst_mem            : in std_logic;
              e_fin_affichage          : in std_logic;
              e_fin_rst_VGA            : in std_logic;
              e_fin_acquisition        : in std_logic;
              e_fin_deplacement        : in std_logic;
              e_activation_aff_jeu     : in std_logic;
              e_error_deplacement      : in std_logic;
              e_attente_deplacement    : in std_logic;
              e_activation_bp_central  : in std_logic;
              s_activation_rst_mem     : out std_logic;
              s_activation_aff_jeu     : out std_logic;
              s_activation_aff_menu    : out std_logic;
              s_activation_rst_VGA     : out std_logic;
              s_activation_acquisition : out std_logic;
              s_activation_deplacement : out std_logic;
              s_current_player         : out std_logic;
              s_sel_mux_2              : out std_logic_vector (1 downto 0);
              s_sel_mux                : out std_logic_vector (1 downto 0));
    end component;

    signal clk                      : std_logic;
    signal rst                      : std_logic;
    signal e_fin_rst_mem            : std_logic;
    signal e_fin_affichage          : std_logic;
    signal e_fin_rst_VGA            : std_logic;
    signal e_fin_acquisition        : std_logic;
    signal e_fin_deplacement        : std_logic;
    signal e_activation_aff_jeu     : std_logic;
    signal e_error_deplacement      : std_logic;
    signal e_attente_deplacement    : std_logic;
    signal e_activation_bp_central  : std_logic;
    signal s_activation_rst_mem     : std_logic;
    signal s_activation_aff_jeu     : std_logic;
    signal s_activation_aff_menu    : std_logic;
    signal s_activation_rst_VGA     : std_logic;
    signal s_activation_acquisition : std_logic;
    signal s_activation_deplacement : std_logic;
    signal s_current_player         : std_logic;
    signal s_sel_mux_2              : std_logic_vector (1 downto 0);
    signal s_sel_mux                : std_logic_vector (1 downto 0);

    constant TbPeriod : time := 1 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : FSM_jeu_de_dame
    port map (clk                      => clk,
              rst                      => rst,
              e_fin_rst_mem            => e_fin_rst_mem,
              e_fin_affichage          => e_fin_affichage,
              e_fin_rst_VGA            => e_fin_rst_VGA,
              e_fin_acquisition        => e_fin_acquisition,
              e_fin_deplacement        => e_fin_deplacement,
              e_activation_aff_jeu     => e_activation_aff_jeu,
              e_error_deplacement      => e_error_deplacement,
              e_attente_deplacement    => e_attente_deplacement,
              e_activation_bp_central  => e_activation_bp_central,
              s_activation_rst_mem     => s_activation_rst_mem,
              s_activation_aff_jeu     => s_activation_aff_jeu,
              s_activation_aff_menu    => s_activation_aff_menu,
              s_activation_rst_VGA     => s_activation_rst_VGA,
              s_activation_acquisition => s_activation_acquisition,
              s_activation_deplacement => s_activation_deplacement,
              s_current_player         => s_current_player,
              s_sel_mux_2              => s_sel_mux_2,
              s_sel_mux                => s_sel_mux);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '0';

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '1';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '0';
        
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '1';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '0';
        
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '1';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '0';
        
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '1';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '0';
        
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '1';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '0';
        
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '1';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '0';
        
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '1';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '0';
        
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '1';
        e_activation_bp_central <= '0';
        
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '1';
        
        wait for 100 ns;
        wait for 100 ns;
        e_fin_rst_mem <= '0';
        e_fin_affichage <= '0';
        e_fin_rst_VGA <= '0';
        e_fin_acquisition <= '0';
        e_fin_deplacement <= '0';
        e_activation_aff_jeu <= '0';
        e_error_deplacement <= '0';
        e_attente_deplacement <= '0';
        e_activation_bp_central <= '0';
        
        wait for 100 ns;
        -- EDIT Add stimuli here
        wait for 10000000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;