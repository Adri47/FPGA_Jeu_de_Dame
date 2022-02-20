library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_plateau is
    Port ( e_plateau_aff_jeu : in STD_LOGIC_VECTOR (7 downto 0);
           e_plateau_acquisition : in STD_LOGIC_VECTOR (7 downto 0);
           e_sel_mux_2 : in STD_LOGIC_VECTOR (1 downto 0);
           s_plateau_mem : out STD_LOGIC_VECTOR (7 downto 0));
end mux_plateau;

architecture Behavioral of mux_plateau is

begin

process(e_plateau_aff_jeu, e_plateau_acquisition, e_sel_mux_2)
    begin
        case e_sel_mux_2 is
            when "00" =>
                s_plateau_mem <= e_plateau_aff_jeu;
            when "01" =>
                s_plateau_mem <= e_plateau_acquisition;
            when others => null;
        end case;
    end process;

end Behavioral;
