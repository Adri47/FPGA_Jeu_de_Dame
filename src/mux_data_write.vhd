

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_data_write is
    Port ( e_data_write_affichage_jeu_de_dame : in STD_LOGIC;
           e_data_write_affichage_menu_jeu    : in STD_LOGIC;
           e_data_write_rst_VGA               : in STD_LOGIC;
           e_sel_mux                          : in STD_LOGIC_VECTOR (1 downto 0);
           s_data_write_mux                   : out STD_LOGIC
           );
end mux_data_write;

architecture Behavioral of mux_data_write is

begin

process (e_data_write_affichage_jeu_de_dame, e_data_write_affichage_menu_jeu, e_data_write_rst_VGA, e_sel_mux)
    begin
        case e_sel_mux is 
        
            when "00" => 
                s_data_write_mux <= e_data_write_affichage_menu_jeu;
                
            when "01" =>
                s_data_write_mux <= e_data_write_affichage_jeu_de_dame;
            
            when "10" =>
                s_data_write_mux <= e_data_write_rst_VGA;
                
            when others => 
                s_data_write_mux <= '0';
            
        end case;
    end process;
end Behavioral;
