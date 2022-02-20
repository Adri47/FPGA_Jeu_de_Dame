----------------------------------------------------------------------------------
-- Company: ENSEIRB-MATMECA
-- Engineer: Adrien CLAIN
-- 
-- Create Date: 02.03.2021 14:31:39
-- Design Name: 
-- Module Name: top_level - Behavioral
-- Project Name: Jeu de dames
-- Target Devices: 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is

 Port (clk            : in std_logic;                       -- horloge de 100 MHz
       bouton_droit   : in std_logic;                       -- bouton pour déplacement
       bouton_gauche  : in std_logic;                       -- bouton pour déplacement
       bouton_haut    : in std_logic;                       -- bouton pour déplacement
       bouton_bas     : in std_logic;                       -- bouton pour déplacement
       bouton_central : in std_logic;                       -- bouton pour déplacement
       LED_droit      : out std_logic;                      -- LED pour bouton pour déplacement
       LED_gauche     : out std_logic;                      -- LED pour bouton pour déplacement
       LED_haut       : out std_logic;                      -- LED pour bouton pour déplacement
       LED_bas        : out std_logic;                      -- LED pour bouton pour déplacement
       LED_central    : out std_logic;                      -- LED pour bouton pour déplacement
       switch         : in std_logic;                       -- interrupteur pour passer du menu au jeu de dame
       rst            : in std_logic;                       -- remise à zéro asynchrone
       VGA_hs         : out std_logic;                      -- sortie VGA pour la syncho horizontale
       VGA_vs         : out std_logic;                      -- sortie VGA pour la syncho verticale
       VGA_red        : out std_logic_vector(3 downto 0);   -- red output
       VGA_green      : out std_logic_vector(3 downto 0);   -- green output
       VGA_blue       : out std_logic_vector(3 downto 0)    -- blue output
        );
end top_level;

architecture Behavioral of top_level is

--component clk_wiz_0
--    Port ( clk_in1 : in std_logic;
--           clk_25MHz : out std_logic
--           );
--end component;

component FSM_jeu_de_dame 
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
           
end component;

component VGA_bitmap_320x240 is
  port(clk          : in  std_logic;
       reset        : in  std_logic;
       VGA_hs       : out std_logic;   
       VGA_vs       : out std_logic;   
       VGA_red      : out std_logic_vector(3 downto 0);   
       VGA_green    : out std_logic_vector(3 downto 0);   
       VGA_blue     : out std_logic_vector(3 downto 0);   
       ADDR         : in  std_logic_vector(16 downto 0);
       data_in      : in  std_logic_vector(11 downto 0);
       data_write   : in  std_logic
       );

end component;

component memoire is
    Port ( clk : in STD_LOGIC;
           e_rw : in STD_LOGIC;
           e_en_mem : in STD_LOGIC;
           e_address_mem : in STD_LOGIC_VECTOR (7 downto 0);
           s_data_out_mem : out STD_LOGIC_VECTOR (7 downto 0);
           e_data_in_mem : in STD_LOGIC_VECTOR (7 downto 0)
           );
end component;

component acquisition is
  Port (  clk                      : in  std_logic;
          rst                      : in  std_logic;
          e_data                   : in std_logic_vector(7 downto 0);  -- Donnée envoyée par la mémoire par l'adresse actuelle
          e_activation_acquisition : in  std_logic;
          e_bouton_droit           : in  std_logic; 
          e_attente_deplacement    : in std_logic;
          e_bouton_gauche          : in  std_logic;
          e_bouton_haut            : in  std_logic;
          e_bouton_bas             : in  std_logic;
          e_bouton_central         : in std_logic;
          s_enable_registre        : out std_logic;
          s_activation_bp_central  : out std_logic;
          s_RW_mem                 : out std_logic;                    -- Lecture/ecriture de la m?moire
          s_activation_memoire     : out std_logic;                    -- Activation de la R/W de la m?moire
          s_fin_acquisition        : out std_logic;
          s_data                   : out std_logic_vector(7 downto 0); -- Donnée à envoyer à la mémoire
          s_adresse                : out std_logic_vector(7 downto 0);  -- Adresse ? laquelle envoy? la donn?e en m?moire
          s_data_deplacement       : out std_logic_vector(7 downto 0); -- Donnée à envoyer à la mémoire
          s_adresse_deplacement    : out std_logic_vector(7 downto 0)  -- Adresse ? laquelle envoy? la donn?e en m?moire
         );
         
end component;

component traitement_deplacement is 
Port (  clk                  : in  std_logic;
        rst                  : in  std_logic;
        e_enable             : in  std_logic;
        e_current_player     : in  std_logic;
        e_data               : in  std_logic_vector(15 downto 0);
        s_rw_mem             : out std_logic;
        s_enable_mem         : out std_logic;
        s_error              : out std_logic;
        s_finish_deplacement : out std_logic;
        s_wait               : out std_logic;
        s_addr               : out std_logic_vector (7 downto 0);
        s_data_mem           : out std_logic_vector (7 downto 0)
        );
    end component;

component affichage_jeu_de_dame is
  Port ( clk                     : in std_logic; 
         rst                     : in std_logic;
         e_affichage_jeu_de_dame : in std_logic;                          
         e_plateau               : in std_logic_vector(7 downto 0);       
         s_fin_affichage         : out std_logic;                         
         s_data_write            : out std_logic;                         
         s_RW_mem                : out std_logic;                         
         s_activation_memoire    : out std_logic;                         
         s_addr_vga              : out std_logic_vector (16 downto 0);     
         s_plateau               : out std_logic_vector(7 downto 0);      
         s_data_in               : out std_logic_vector (11 downto 0)     
         );
end component;

component affichage_menu_jeu is
  Port (clk                  : in std_logic;
        rst                  : in std_logic;
        e_activation_menu    : in std_logic;
        s_fin_affichage_menu : out std_logic;
        s_addr_vga           : out std_logic_vector (16 downto 0 );
        s_data_in            : out std_logic_vector (11 downto 0);
        s_data_write         : out std_logic
        );
end component;

component Reset_memoire_plateau is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           e_activation_rst : in STD_LOGIC;
           s_rw_rst : out STD_LOGIC;
           s_en_mem_rst : out STD_LOGIC;
           s_fin_rst_mem : out STD_LOGIC;
           s_addr_rst : out STD_LOGIC_VECTOR (7 downto 0);
           s_data_in_rst : out STD_LOGIC_VECTOR (7 downto 0)
           );
end component;

component rst_VGA is
    Port ( clk                  : in STD_LOGIC;
           rst                  : in STD_LOGIC;
           e_activation_rst_VGA : in STD_LOGIC;
           s_fin_rst_VGA        : out STD_LOGIC;
           s_data_write_rst_VGA : out STD_LOGIC;
           s_addr_VGA_rst_VGA   : out STD_LOGIC_VECTOR (16 downto 0);
           s_data_in_rst_VGA    : out STD_LOGIC_VECTOR (11 downto 0)
           );
end component;

component filtre_bouton is
  port ( clk                : in std_logic;
         e_registre_bouton  : in std_logic_vector (4 DOWNTO 0);
         rst                : in std_logic;
         s_registre_bouton  : out std_logic_vector(4 DOWNTO 0)
         );
end component;

component registre_avant_VGA is
    Port ( clk                  : in STD_LOGIC;
           rst                  : in STD_LOGIC;
           e_reg_ADDR_VGA       : in STD_LOGIC_VECTOR (16 downto 0);
           e_reg_data_in_VGA    : in STD_LOGIC_VECTOR (11 downto 0);
           e_reg_data_write_VGA : in STD_LOGIC;
           s_reg_ADDR_VGA           : out STD_LOGIC_VECTOR (16 downto 0);
           s_reg_data_in_VGA        : out STD_LOGIC_VECTOR (11 downto 0);
           s_reg_data_write_VGA     : out STD_LOGIC
           );
end component;

component registre is
  Port (clk               : in  std_logic;
        rst               : in  std_logic;
        e_enable_registre : in std_logic;
        e_data_registre   : in  std_logic_vector (15 downto 0);
        s_data_registre   : out std_logic_vector (15 downto 0)
        );
end component;

component mux_ADDR_VGA is
    Port ( e_ADDR_affichage_jeu_de_dame : in STD_LOGIC_VECTOR (16 downto 0);
           e_ADDR_affichage_menu_jeu    : in STD_LOGIC_VECTOR (16 downto 0);
           e_ADDR_rst_VGA               : in STD_LOGIC_VECTOR (16 downto 0);
           e_sel_mux                    : in STD_LOGIC_VECTOR (1 downto 0);
           s_ADDR_VGA_mux               : out STD_LOGIC_VECTOR (16 downto 0)
           );
end component;

component mux_data_in is
    Port ( e_data_in_affichage_jeu_de_dame : in STD_LOGIC_VECTOR (11 downto 0);
           e_data_in_affichage_menu        : in STD_LOGIC_VECTOR (11 downto 0);
           e_data_in_rst_VGA               : in STD_LOGIC_VECTOR (11 downto 0);
           e_sel_mux                       : in STD_LOGIC_VECTOR (1 downto 0);
           s_mux_data_in                   : out STD_LOGIC_VECTOR (11 downto 0)
           );
end component;

component mux_data_write is
    Port ( e_data_write_affichage_jeu_de_dame : in STD_LOGIC;
           e_data_write_affichage_menu_jeu    : in STD_LOGIC;
           e_data_write_rst_VGA               : in STD_LOGIC;
           e_sel_mux                          : in STD_LOGIC_VECTOR (1 downto 0);
           s_data_write_mux                   : out STD_LOGIC
           );
end component;

component mux_entree_mem is
     Port ( e_sel      : in  std_logic_vector (1 downto 0) ;
            e_entree_1 : in  std_logic_vector (7 downto 0);
            e_entree_2 : in  std_logic_vector (7 downto 0);
            e_entree_3 : in  std_logic_vector (7 downto 0);
            e_entree_4 : in  std_logic_vector (7 downto 0);
            s_sortie   : out std_logic_vector(7 downto 0)
            );
end component;

component mux_1bit is
      Port (e_sel      : in  std_logic_vector (1 downto 0) ;
            e_entree_1 : in  std_logic;
            e_entree_2 : in  std_logic;
            e_entree_3 : in  std_logic;
            e_entree_4 : in  std_logic;
            s_sortie   : out std_logic
            );
end component;

component demux_8bits is
    Port ( e_sel      : in  std_logic_vector (1 downto 0) ;
           e_entree   : in  std_logic_vector ( 7 downto 0);
           s_sortie_1 : out std_logic_vector ( 7 downto 0);
           s_sortie_2 : out std_logic_vector ( 7 downto 0)
           );
end component;

signal clk_25MHz                                                                       : std_logic;
signal rst_not                                                                         : std_logic;

signal data_write, reg_data_write, s_data_write_aff_jeu, data_write_rst_VGA, s_data_write_aff_menu, s_data_write_aff_menu2     : std_logic;
signal addr_vga,reg_addr_vga, s_addr_vga_aff_jeu, s_addr_vga_aff_menu,s_addr_vga_aff_menu2, addr_VGA_rst_VGA             : std_logic_vector(16 downto 0);
signal data_in, reg_data_in,  s_data_in_affichage_jeu, data_in_rst_VGA, s_data_in_affichage_menu, s_data_in_affichage_menu2     : std_logic_vector(11 downto 0);

signal addr_mem, s_addr_deplacement, addr_acquisition2,  s_data_out_mem, addr_aff_plateau, addr_acquisition, aff_jeu_addr_mem, addr_rst_mem  : std_logic_vector(7 downto 0);
signal aff_jeu_en_mem, acquisition_en_mem, rst_mem_en_mem                                              : std_logic;

signal data_in_mem, data_out_mem, entree_1,ack_data_in_mem,rst_data_in   : std_logic_vector (7 downto 0);
signal e_affichage_jeu_de_dame                                                         : std_logic;
signal s_fin_affichage_jeu, fin_rst_VGA, fin_rst_mem                                    : std_logic;
signal e_data_in_mem, plateau_aff_jeu, plateau_acquisition, s_data_mem_deplacement   : std_logic_vector (7 downto 0);
signal activation_acquisition, activation_aff_jeu, activation_aff_menu, enable_traitement_deplacement, activation_bp_central               : std_logic;
signal fin_acquisition, fin_affichage_menu, fin_rst_plateau                            : std_logic;

signal sel_mux, sel_mux_2                                                              : std_logic_vector (1 downto 0);

signal activation_acquisition_1, actiavtion_jeu_2, activation_rst_VGA, activation_rst_mem                 : std_logic;
signal en_mem                                                                          : std_logic;
signal rw_acquisition, rw_aff_jeu, rw , acquisition_en_mem2, rw_acquisition2, rw_rst_mem, rw_mem_deplacement                                            : std_logic;

signal e_bouton, s_bouton : std_logic_vector (4 downto 0);

signal attente_deplacement, enable_registre : std_logic;
signal addresse_data_deplacement, data_registre : std_logic_vector (15 downto 0);

signal deplacement_en_mem, s_enable_mem_deplacement, fin_deplacement, error_deplacement, current_player : std_logic;
signal e_data_deplacement : std_logic_vector(15 downto 0);
begin

--    Divion_Freq : clk_wiz_0
--    Port map ( clk_in1 => clk,
--               clk_25MHz => clk_25MHz
--                );
    
    FSM_jeu : FSM_jeu_de_dame
    Port map ( clk                      => clk,
               rst                      => rst_not,
               e_fin_rst_mem            => fin_rst_mem,
               e_activation_aff_jeu     => switch,
               e_fin_rst_VGA            => fin_rst_VGA,
               e_fin_affichage          => s_fin_affichage_jeu,
               e_fin_acquisition        => fin_acquisition,
               e_fin_deplacement        => fin_deplacement,
               e_error_deplacement      => error_deplacement,
               e_attente_deplacement    => attente_deplacement,
               e_activation_bp_central  => activation_bp_central,
               s_current_player         => current_player,
               s_activation_rst_mem     => activation_rst_mem,
               s_activation_aff_menu    => activation_aff_menu,
               s_activation_aff_jeu     => activation_aff_jeu,
               s_activation_acquisition => activation_acquisition,
               s_activation_rst_VGA     => activation_rst_VGA,
               s_activation_deplacement => enable_traitement_deplacement,
               s_sel_mux_2              => sel_mux_2,
               s_sel_mux                => sel_mux
               );
               
    VGA : VGA_bitmap_320x240 
    port map (clk          => clk,
              reset        => rst_not,
              VGA_hs       => VGA_hs,
              VGA_vs       => VGA_vs,
              VGA_red      => VGA_red,
              VGA_green    => VGA_green,
              VGA_blue     => VGA_blue,
              ADDR         => addr_vga,
              data_in      => data_in,
              data_write   => data_write
              );
    Registre_bouton : filtre_bouton
    port map ( clk                   => clk,
               rst                   => rst_not,
               e_registre_bouton(0)  => bouton_droit,
               e_registre_bouton(1)  => bouton_gauche,
               e_registre_bouton(2)  => bouton_bas,
               e_registre_bouton(3)  => bouton_haut,
               e_registre_bouton(4)  => bouton_central,
               s_registre_bouton     => s_bouton
              );       
                
  FSM_Ack : acquisition
    Port map (clk                      => clk,
              rst                      => rst_not,
              e_data                   => plateau_acquisition,
              e_bouton_droit           => bouton_droit,
              e_bouton_gauche          => bouton_gauche,
              e_bouton_haut            => bouton_haut,
              e_bouton_central         => bouton_central,
              e_bouton_bas             => bouton_bas,
              e_activation_acquisition => activation_acquisition,
              e_attente_deplacement    => attente_deplacement,
              s_activation_bp_central  => activation_bp_central,
              s_enable_registre        => enable_registre,
              s_RW_mem                 => rw_acquisition,
              s_activation_memoire     => acquisition_en_mem,                
              s_fin_acquisition        => fin_acquisition,
              s_data                   => ack_data_in_mem,
              s_adresse                => addr_acquisition,
              s_data_deplacement       => addresse_data_deplacement(7 downto 0),
              s_adresse_deplacement    => addresse_data_deplacement(15 downto 8)
             );
    
    Traitement : traitement_deplacement
    Port map (  clk                  => clk,
                rst                  => rst_not,
                e_enable             => enable_traitement_deplacement,
                e_current_player     => current_player,
                e_data               => data_registre,
                s_rw_mem             => rw_mem_deplacement,
                s_enable_mem         => deplacement_en_mem,
                s_error              => error_deplacement,
                s_finish_deplacement => fin_deplacement,
                s_wait               => attente_deplacement,
                s_addr               => s_addr_deplacement,
                s_data_mem           => s_data_mem_deplacement
                );
                
    Affichage_jeu : affichage_jeu_de_dame
    port map ( clk                     => clk,
               rst                     => rst_not,
               e_affichage_jeu_de_dame => activation_aff_jeu,                         
               e_plateau               => plateau_aff_jeu,                  
               s_fin_affichage         => s_fin_affichage_jeu,                      
               s_data_write            => s_data_write_aff_jeu,                         
               s_RW_mem                => rw_aff_jeu,                     
               s_activation_memoire    => aff_jeu_en_mem,                    
               s_addr_vga              => s_addr_vga_aff_jeu, 
               s_plateau               => addr_aff_plateau,  
               s_data_in               => s_data_in_affichage_jeu
               );
               
    Menu : affichage_menu_jeu
    
    Port map   (clk                  => clk,
                rst                  => rst_not,
                e_activation_menu    => activation_aff_menu,
                s_fin_affichage_menu => fin_affichage_menu,
                s_addr_vga           => s_addr_vga_aff_menu,
                s_data_in            => s_data_in_affichage_menu,
                s_data_write         => s_data_write_aff_menu
                );
     
    MEM : memoire
    Port map  ( clk            => clk,
                e_rw           => rw,
                e_en_mem       => en_mem,
                e_address_mem  => addr_mem,
                s_data_out_mem => s_data_out_mem,
                e_data_in_mem  => data_in_mem
                );
                
    RAZ_VGA : rst_VGA
    Port map  ( clk                 => clk,
               rst                  => rst_not,
               e_activation_rst_VGA => activation_rst_VGA,
               s_fin_rst_VGA        => fin_rst_VGA,
               s_data_write_rst_VGA => data_write_rst_VGA,
               s_addr_VGA_rst_VGA   => addr_VGA_rst_VGA,
               s_data_in_rst_VGA    => data_in_rst_VGA
               );
    
    REG_VGA : registre_avant_VGA 
    Port map(  clk                      => clk,
               rst                      => rst_not,
               e_reg_ADDR_VGA           => reg_addr_vga,
               e_reg_data_in_VGA        => reg_data_in,
               e_reg_data_write_VGA     => reg_data_write,
               s_reg_ADDR_VGA           => addr_vga,
               s_reg_data_in_VGA        => data_in,
               s_reg_data_write_VGA     => data_write
               );
    REG_deplacement : registre 
  Port map (clk               => clk,
            rst               => rst_not,
            e_enable_registre => enable_registre,
            e_data_registre   => addresse_data_deplacement,
            s_data_registre   => data_registre
            );

    RST_MEM : Reset_memoire_plateau 
    Port map( clk => clk,
              rst =>rst_not,
              e_activation_rst => activation_rst_mem,
              s_rw_rst => rw_rst_mem,
              s_en_mem_rst => rst_mem_en_mem,
              s_fin_rst_mem => fin_rst_mem,
              s_addr_rst => addr_rst_mem,
              s_data_in_rst => rst_data_in
              );
    MUX_DW :  mux_data_write
    Port map ( e_data_write_affichage_jeu_de_dame => s_data_write_aff_jeu,
               e_data_write_affichage_menu_jeu    => s_data_write_aff_menu,
               e_data_write_rst_VGA               => data_write_rst_VGA,
               e_sel_mux                          => sel_mux,
               s_data_write_mux                   => reg_data_write
               );
    
    MUX_ADDR : mux_ADDR_VGA
    Port map ( e_ADDR_affichage_jeu_de_dame => s_addr_vga_aff_jeu,
               e_ADDR_affichage_menu_jeu    => s_addr_vga_aff_menu,
               e_ADDR_rst_VGA               => addr_VGA_rst_VGA,
               e_sel_mux                    => sel_mux,
               s_ADDR_VGA_mux               => reg_addr_vga
               );
               
    MUX_D_IN : mux_data_in
    Port map ( e_data_in_affichage_jeu_de_dame => s_data_in_affichage_jeu,
               e_data_in_affichage_menu        => s_data_in_affichage_menu,
               e_data_in_rst_VGA               => data_in_rst_VGA,
               e_sel_mux                       => sel_mux,
               s_mux_data_in                   => reg_data_in
               );
    
    Mux_enter_addr : mux_entree_mem
    port map( e_sel      => sel_mux_2,
              e_entree_1 => addr_aff_plateau,
              e_entree_2 => addr_acquisition,
              e_entree_3 => addr_rst_mem,
              e_entree_4 => s_addr_deplacement,
              s_sortie   => addr_mem
             );
   
    Mux_enter_data_in : mux_entree_mem
    port map( e_sel      => sel_mux_2,
              e_entree_1 => entree_1,
              e_entree_2 => ack_data_in_mem,
              e_entree_3 => rst_data_in,
              e_entree_4 => s_data_mem_deplacement,
              s_sortie   => data_in_mem
             );
    
    Mux_enable_mem : mux_1bit
    port map(
              e_sel      => sel_mux_2,
              e_entree_1 => aff_jeu_en_mem,
              e_entree_2 => acquisition_en_mem,
              e_entree_3 => rst_mem_en_mem,
              e_entree_4 => deplacement_en_mem,
              s_sortie   => en_mem
              );
    
    Mux_rw_mem : mux_1bit
    port map(
              e_sel      => sel_mux_2,
              e_entree_1 => rw_aff_jeu,
              e_entree_2 => rw_acquisition,
              e_entree_3 => rw_rst_mem,
              e_entree_4 => rw_mem_deplacement,
              s_sortie   => rw
              );
    
    Demux_8bits_mem : demux_8bits
    Port map (e_sel      => sel_mux_2,
              e_entree   => s_data_out_mem,
              s_sortie_1 => plateau_aff_jeu,
              s_sortie_2 => plateau_acquisition
              );
       
rst_not <= not(rst);
LED_droit      <= s_bouton(0);
LED_gauche     <= s_bouton(1);
LED_haut       <= s_bouton(2);
LED_bas        <= s_bouton(3);
LED_central    <= s_bouton(4);
entree_1        <= (others=>'0');
--actiavtion_jeu_2 <= '1';
--activation_acquisition_1 <='0';
    

end Behavioral;
