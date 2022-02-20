library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity compteur_addr_mem_menu is
    Port ( clk                  : in STD_LOGIC;
           rst                  : in STD_LOGIC;
           e_activation_menu    : in STD_LOGIC;
           s_addr_menu          : out STD_LOGIC_VECTOR(16 DOWNTO 0);
           s_fin_affichage_menu : out STD_LOGIC
           );
end compteur_addr_mem_menu;

architecture Behavioral of compteur_addr_mem_menu is

signal compteur_adresse : unsigned(16 downto 0) := (others =>'0');

begin
process(clk, rst, compteur_adresse)
    begin
        if rst = '1' then
            compteur_adresse <= (others => '0');
            s_fin_affichage_menu <= '0';
            
        elsif clk'event and clk = '1' then
            if e_activation_menu = '1' then
                if compteur_adresse < 76799 then
                    compteur_adresse <= compteur_adresse + 1;
                    s_fin_affichage_menu <= '0';
                else
                    compteur_adresse <= (others => '0');
                    s_fin_affichage_menu <= '1';
                end if;
             else 
                compteur_adresse <= (others => '0');
                s_fin_affichage_menu <= '0';
             end if;
        end if;
        
    end process;

s_addr_menu <= std_logic_vector(compteur_adresse);

end Behavioral;
