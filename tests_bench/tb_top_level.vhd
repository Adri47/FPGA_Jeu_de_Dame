library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (clk            : in std_logic;
              bouton_droit   : in std_logic;
              bouton_gauche  : in std_logic;
              bouton_haut    : in std_logic;
              bouton_bas     : in std_logic;
              bouton_central : in std_logic;
              LED_droit      : out std_logic;
              LED_gauche     : out std_logic;
              LED_haut       : out std_logic;
              LED_bas        : out std_logic;
              LED_central    : out std_logic;
              switch         : in std_logic;
              rst            : in std_logic;
              VGA_hs         : out std_logic;
              VGA_vs         : out std_logic;
              VGA_red        : out std_logic_vector (3 downto 0);
              VGA_green      : out std_logic_vector (3 downto 0);
              VGA_blue       : out std_logic_vector (3 downto 0));
    end component;

    signal clk            : std_logic;
    signal bouton_droit   : std_logic;
    signal bouton_gauche  : std_logic;
    signal bouton_haut    : std_logic;
    signal bouton_bas     : std_logic;
    signal bouton_central : std_logic;
    signal LED_droit      : std_logic;
    signal LED_gauche     : std_logic;
    signal LED_haut       : std_logic;
    signal LED_bas        : std_logic;
    signal LED_central    : std_logic;
    signal switch         : std_logic;
    signal rst            : std_logic;
    signal VGA_hs         : std_logic;
    signal VGA_vs         : std_logic;
    signal VGA_red        : std_logic_vector (3 downto 0);
    signal VGA_green      : std_logic_vector (3 downto 0);
    signal VGA_blue       : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 1 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_level
    port map (clk            => clk,
              bouton_droit   => bouton_droit,
              bouton_gauche  => bouton_gauche,
              bouton_haut    => bouton_haut,
              bouton_bas     => bouton_bas,
              bouton_central => bouton_central,
              LED_droit      => LED_droit,
              LED_gauche     => LED_gauche,
              LED_haut       => LED_haut,
              LED_bas        => LED_bas,
              LED_central    => LED_central,
              switch         => switch,
              rst            => rst,
              VGA_hs         => VGA_hs,
              VGA_vs         => VGA_vs,
              VGA_red        => VGA_red,
              VGA_green      => VGA_green,
              VGA_blue       => VGA_blue);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        bouton_droit <= '0';
        bouton_gauche <= '0';
        bouton_haut <= '0';
        bouton_bas <= '0';
        bouton_central <= '0';
        switch <= '0';

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '0';
        wait for 5 ns;
        rst <= '1';
        wait for 6 ns;
        
        bouton_gauche <= '1';
        wait for 2 ns;
        bouton_gauche <= '0';
        wait for 50 ns;
        
        bouton_central <= '1';
        wait for 50 ns;
        bouton_central <= '0';
        wait for 50 ns;
        
        bouton_gauche <= '1';
        wait for 50 ns;
        bouton_gauche <= '0';
        wait for 50 ns;
        
        bouton_central <= '1';
        wait for 50 ns;
        bouton_central <= '0';
        -- EDIT Add stimuli here
        wait for 100000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
