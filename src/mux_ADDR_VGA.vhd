library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_ADDR_VGA is
    Port ( e_ADDR_affichage_jeu_de_dame : in STD_LOGIC_VECTOR (16 downto 0);
           e_ADDR_affichage_menu_jeu    : in STD_LOGIC_VECTOR (16 downto 0);
           e_ADDR_rst_VGA               : in STD_LOGIC_VECTOR (16 downto 0);
           e_sel_mux                    : in STD_LOGIC_VECTOR (1 downto 0);
           s_ADDR_VGA_mux               : out STD_LOGIC_VECTOR (16 downto 0)
           );
           
end mux_ADDR_VGA;

architecture Behavioral of mux_ADDR_VGA is

begin

process (e_ADDR_affichage_jeu_de_dame, e_ADDR_affichage_menu_jeu, e_ADDR_rst_VGA, e_sel_mux)
    begin
        case e_sel_mux is
            when "00" =>
                s_ADDR_VGA_mux <= e_ADDR_affichage_menu_jeu;
                
            when "01" =>
                s_ADDR_VGA_mux <= e_ADDR_affichage_jeu_de_dame;
            
            when "10" =>
                s_ADDR_VGA_mux <= e_ADDR_rst_VGA;
                
            when others => 
                s_ADDR_VGA_mux <= (others => '0');
         end case; 
    end process;
end Behavioral;
