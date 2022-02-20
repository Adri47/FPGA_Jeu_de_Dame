library ieee;
use ieee.std_logic_1164.all;

entity tb_filtre_bouton is
end tb_filtre_bouton;

architecture tb of tb_filtre_bouton is

    component filtre_bouton
        port (clk             : in std_logic;
              rst             : in std_logic;
              e_bouton        : in std_logic_vector (4 downto 0);
              s_bouton_filtre : out std_logic_vector (4 downto 0));
    end component;

    signal clk             : std_logic;
    signal rst             : std_logic;
    signal e_bouton        : std_logic_vector (4 downto 0);
    signal s_bouton_filtre : std_logic_vector (4 downto 0);

    constant TbPeriod : time := 1 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : filtre_bouton
    port map (clk             => clk,
              rst             => rst,
              e_bouton        => e_bouton,
              s_bouton_filtre => s_bouton_filtre);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        e_bouton <= (others => '0');

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        
        e_bouton <= "00010";
        wait for 95 ns;
        
        wait for 1000 * TbPeriod;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;