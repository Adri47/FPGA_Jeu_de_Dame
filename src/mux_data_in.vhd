library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_data_in is
    Port ( e_data_in_affichage_jeu_de_dame : in STD_LOGIC_VECTOR (11 downto 0);
           e_data_in_affichage_menu        : in STD_LOGIC_VECTOR (11 downto 0);
           e_data_in_rst_VGA               : in STD_LOGIC_VECTOR (11 downto 0);
           e_sel_mux                       : in STD_LOGIC_VECTOR (1 downto 0);
           s_mux_data_in                   : out STD_LOGIC_VECTOR (11 downto 0)
           );
end mux_data_in;

architecture Behavioral of mux_data_in is

begin

process (e_data_in_affichage_jeu_de_dame, e_data_in_affichage_menu, e_data_in_rst_VGA, e_sel_mux)
    begin
        case e_sel_mux is
            
            when "00" =>
                s_mux_data_in <= e_data_in_affichage_menu;
            
            when "01" =>
                s_mux_data_in <= e_data_in_affichage_jeu_de_dame;
            
            when "10" =>
                s_mux_data_in <= e_data_in_rst_VGA;
            
            when others => 
                s_mux_data_in <= (others => '0');
            
        end case;
    end process;
end Behavioral;
