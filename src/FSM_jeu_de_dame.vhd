library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity FSM_jeu_de_dame is
    Port ( clk                      : in STD_LOGIC;
           rst                      : in STD_LOGIC;
           e_fin_rst_mem            : in STD_LOGIC;
           e_fin_affichage          : in STD_LOGIC;
           e_fin_rst_VGA            : in STD_LOGIC;
           e_fin_acquisition        : in STD_LOGIC; 
           e_fin_deplacement        : in STD_LOGIC;
           e_activation_aff_jeu     : in STD_LOGIC;
           e_error_deplacement      : in STD_LOGIC;
           e_attente_deplacement    : in std_logic;
           e_activation_bp_central  : in std_logic;
           s_activation_rst_mem     : out STD_LOGIC;
           s_activation_aff_jeu     : out STD_LOGIC;
           s_activation_aff_menu    : out STD_LOGIC;
           s_activation_rst_VGA     : out STD_LOGIC;
           s_activation_acquisition : out STD_LOGIC;
           s_activation_deplacement : out STD_LOGIC;
           s_current_player         : out STD_LOGIC;
           s_sel_mux_2              : out STD_LOGIC_VECTOR (1 downto 0);
           s_sel_mux                : out STD_LOGIC_VECTOR (1 downto 0)
           );

end FSM_jeu_de_dame;

architecture Behavioral of FSM_jeu_de_dame is

TYPE state IS (etat_Init, reset_memoire, affichage_menu, rst_VGA, affichage_plateau, acquistion, deplacement); 
SIGNAL next_state, current_state : state; 

begin

process (clk, rst)
    begin
        if rst = '1' then
            current_state <= etat_Init;
        elsif clk'event and clk = '1' then
            current_state <= next_state;
        end if;
    end process;

process(current_state, e_fin_rst_mem, e_activation_aff_jeu, e_fin_affichage, e_fin_rst_VGA, e_fin_acquisition, e_fin_deplacement, e_error_deplacement, e_attente_deplacement, e_activation_bp_central)
    begin
        case current_state is
            
            when etat_Init =>
                next_state <= reset_memoire;
--            next_state <= affichage_plateau;
            
            when reset_memoire =>
                if e_fin_rst_mem = '1' then
                    next_state <= affichage_menu;
                else 
                    next_state <= reset_memoire;
                end if;
                
            when affichage_menu =>
                if e_activation_aff_jeu = '1' then
                    next_state <= rst_VGA;
                else
                    next_state <= affichage_menu;
                end if;
                
            when rst_VGA =>
                if e_fin_rst_VGA = '1' then
                    next_state <= affichage_plateau;
                else 
                    next_state <= rst_VGA;
                end if;
                
            when affichage_plateau =>
                if e_fin_affichage = '1' then
                    next_state <= acquistion;
                else
                    next_state <= affichage_plateau;
                end if;
                
            when acquistion =>
                if e_fin_acquisition = '1'  then        --si l'ack est finie et qu'on a pas selectionner de case alors on affiche
                    next_state <= affichage_plateau;
--                        next_state <= acquistion;
                elsif e_activation_bp_central = '1' then-- si un appuie est fait alors on passe au déplacement
                    next_state <= deplacement;
                else 
                    next_state <= acquistion;
                end if;
--            if e_fin_acquisition = '1'  then
--                next_state <= deplacement;
--             else 
--             next_state <= acquistion;
--             end if;
            when deplacement =>
                if e_attente_deplacement = '1' and e_error_deplacement = '0' then
                    next_state <= affichage_plateau; -- bonne changement d'état
--                    next_state <= acquistion;
                elsif e_fin_deplacement = '1' and e_error_deplacement = '1' then
                    next_state <= acquistion;
                else 
                    next_state <= deplacement;
                end if;
        end case;
    end process;

process (current_state)
    begin
        case current_state is 
        
            when etat_Init =>
                s_activation_rst_mem <= '0';
                s_activation_aff_jeu <= '0';
                s_activation_aff_menu <= '0';
                s_activation_rst_VGA <= '0';
                s_activation_acquisition <= '0';
                s_activation_deplacement <= '0';
                s_sel_mux <= "00";
                s_sel_mux_2 <= "00";
            
            when reset_memoire =>
                s_activation_rst_mem <= '1';
                s_activation_aff_jeu <= '0';
                s_activation_aff_menu <= '0';
                s_activation_rst_VGA <= '0';
                s_activation_acquisition <= '0';
                s_activation_deplacement <= '0';
                s_sel_mux <= "00";
                s_sel_mux_2 <= "10";          
             
            when affichage_menu =>
                s_activation_rst_mem <= '0';
                s_activation_aff_jeu <= '0';
                s_activation_aff_menu <= '1';
                s_activation_rst_VGA <= '0';
                s_activation_acquisition <= '0';
                s_activation_deplacement <= '0';
                s_sel_mux <= "00";
                s_sel_mux_2 <= "00";
            
            when rst_VGA =>
                s_activation_rst_mem <= '0';
                s_activation_aff_jeu <= '0';
                s_activation_aff_menu <= '0';
                s_activation_rst_VGA <= '1';
                s_activation_acquisition <= '0';
                s_activation_deplacement <= '0';
                s_sel_mux <= "10";
                s_sel_mux_2 <= "00";
                
            when affichage_plateau =>
                s_activation_rst_mem <= '0';
                s_activation_aff_jeu <= '1';
                s_activation_aff_menu <= '0';
                s_activation_rst_VGA <= '0';
                s_activation_acquisition <= '0';
                s_activation_deplacement <= '0';
                s_sel_mux <= "01";
                s_sel_mux_2 <= "00";
            
            when acquistion =>
                s_activation_rst_mem <= '0';
                s_activation_aff_jeu <= '0';
                s_activation_aff_menu <= '0';
                s_activation_rst_VGA <= '0';
                s_activation_acquisition <= '1';
                s_activation_deplacement <= '0';
                s_sel_mux <= "01";   
                s_sel_mux_2 <= "01";
                
            when deplacement =>
                s_activation_rst_mem <= '0';
                s_activation_aff_jeu <= '0';
                s_activation_aff_menu <= '0';
                s_activation_rst_VGA <= '0';
                s_activation_acquisition <= '0';
                s_activation_deplacement <= '1';
                s_sel_mux <= "01";   
                s_sel_mux_2 <= "11";
                
          end case;
    end process;

s_current_player <= '0';

end Behavioral;
