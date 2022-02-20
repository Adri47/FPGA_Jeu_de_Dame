library ieee;
use ieee.std_logic_1164.all;

entity tb_acquisition is
end tb_acquisition;

architecture tb of tb_acquisition is

    component acquisition
        port (clk                      : in std_logic;
              rst                      : in std_logic;
              e_data                   : in std_logic_vector (7 downto 0);
              e_activation_acquisition : in std_logic;
              e_bouton_droit           : in std_logic;
              e_bouton_gauche          : in std_logic;
              e_bouton_haut            : in std_logic;
              e_bouton_bas             : in std_logic;
              s_RW_mem                 : out std_logic;
              s_activation_memoire     : out std_logic;
              s_fin_acquisition        : out std_logic;
              s_data                   : out std_logic_vector (7 downto 0);
              s_adresse                : out std_logic_vector (7 downto 0));
    end component;

    signal clk                      : std_logic;
    signal rst                      : std_logic;
    signal e_data                   : std_logic_vector (7 downto 0);
    signal e_activation_acquisition : std_logic;
    signal e_bouton_droit           : std_logic;
    signal e_bouton_gauche          : std_logic;
    signal e_bouton_haut            : std_logic;
    signal e_bouton_bas             : std_logic;
    signal s_RW_mem                 : std_logic;
    signal s_activation_memoire     : std_logic;
    signal s_fin_acquisition        : std_logic;
    signal s_data                   : std_logic_vector (7 downto 0);
    signal s_adresse                : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 1 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : acquisition
    port map (clk                      => clk,
              rst                      => rst,
              e_data                   => e_data,
              e_activation_acquisition => e_activation_acquisition,
              e_bouton_droit           => e_bouton_droit,
              e_bouton_gauche          => e_bouton_gauche,
              e_bouton_haut            => e_bouton_haut,
              e_bouton_bas             => e_bouton_bas,
              s_RW_mem                 => s_RW_mem,
              s_activation_memoire     => s_activation_memoire,
              s_fin_acquisition        => s_fin_acquisition,
              s_data                   => s_data,
              s_adresse                => s_adresse);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        e_data <= x"06";
        e_activation_acquisition <= '1';
        e_bouton_droit <= '0';
        e_bouton_gauche <= '1';
        e_bouton_haut <= '0';
        e_bouton_bas <= '0';

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 103.500 ns;
        e_bouton_gauche <= '0';
        wait for 50 ns;
        e_data <= x"04";
        e_bouton_gauche <= '1';
        wait for 10 ns;
        e_bouton_gauche <= '0';
        -- EDIT Add stimuli here
        wait for 100000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;