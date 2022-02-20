library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity acquisition is
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
end acquisition;

architecture Behavioral of acquisition is

-- D?claration des ?tats de la FSM
TYPE state IS (etatInit, etat0, etat1, etat2, etat3, etat4, etat5, etat6, etat7, etat8, etat9, etat10, etat11, etat12, etat13, etat14); 
SIGNAL next_state, current_state : state;

signal buffer_addr_courante : unsigned(7 downto 0) := (others =>'0');
signal buffer_addr_suivante, buffer_addr_suivante_bas, buffer_addr_suivante_haut, buffer_addr_suivante_droit, buffer_addr_suivante_gauche : unsigned(7 downto 0) := (others =>'0');
signal activation_addr_droite                                                                             : std_logic;
signal activation_addr_gauche                                                                             : std_logic;
signal activation_addr_haut                                                                               : std_logic;
signal activation_addr_bas                                                                                : std_logic;
signal buffer_valeur_case_courante, buffer_new_valeur_case_courante                                       : unsigned(7 downto 0) := (others =>'0');
signal buffer_valeur_case_suivante, buffer_new_valeur_case_suivante                                       : unsigned(7 downto 0):=(others =>'0');
signal buffer_old_valeur_case_courante                                                                    : unsigned(7 downto 0):=(others =>'0');
signal activation_cpt_addr, activation_new_valeur_case_suivante, activation_valeur_case_courante          : std_logic;
signal cpt, activation_buffer_addr_courante, activation_new_valeur_case_courante, activation_buffer_addr_suivante, activation_valeur_case_suivante                          : std_logic;
signal fin_etape_4, fin_calcul_btn_bas, fin_calcul_btn_haut, fin_calcul_btn_droit, fin_calcul_btn_gauche  : std_logic;

begin

calcul_addr_droite : process(clk, rst)
    begin
    if rst = '1' then
        buffer_addr_suivante_droit <= (others => '0');
        fin_calcul_btn_droit <= '0';
        
    elsif clk'event and clk = '1' then
        if activation_addr_droite = '1' then
            if buffer_addr_courante < 99 then
                buffer_addr_suivante_droit <= buffer_addr_courante + 1;
                fin_calcul_btn_droit <= '1';
            else 
                buffer_addr_suivante_droit <= (others => '0');
                fin_calcul_btn_droit <= '1';
            end if;
        else 
            buffer_addr_suivante_droit <= (others => '0');
            fin_calcul_btn_droit <= '0';
        end if; 
     end if;      
   end process;
    
calcul_addr_gauche : process(clk, rst)
    begin
        if rst = '1' then
            buffer_addr_suivante_gauche <= (others => '0');
            fin_calcul_btn_gauche <= '0';
            
        elsif  clk'event and clk = '1' then
            if activation_addr_gauche = '1' then
                if buffer_addr_courante > 0 then
                    buffer_addr_suivante_gauche <= buffer_addr_courante - 1;
                    fin_calcul_btn_gauche <= '1';
                else 
                    buffer_addr_suivante_gauche <= x"63";
                    fin_calcul_btn_gauche <= '1';
                end if;
            else 
                buffer_addr_suivante_gauche <= (others => '0');
                fin_calcul_btn_gauche <= '0';
         end if;
       end if;       
    end process;

calcul_addr_haut : process(clk, rst)
    begin
        if rst = '1' then
            buffer_addr_suivante_haut <= (others => '0');
            fin_calcul_btn_haut <= '0';
            
        elsif clk'event and clk = '1' then
            if activation_addr_haut = '1' then
                if buffer_addr_courante > 10 then
                    buffer_addr_suivante_haut <= buffer_addr_courante - 10;
                    fin_calcul_btn_haut <= '1';
                else 
                    buffer_addr_suivante_haut <= 99 - ( 9 - buffer_addr_courante) ;
                    fin_calcul_btn_haut <= '1';
                end if;
            else 
                buffer_addr_suivante_haut <= (others => '0');
                fin_calcul_btn_haut <= '0';
            end if;       
       end if;
    end process;

calcul_addr_bas : process(clk, rst)
    begin
        if rst = '1' then
            buffer_addr_suivante_bas <= (others => '0');
            fin_calcul_btn_bas <= '0';
            
        elsif clk'event and clk = '1' then
            if activation_addr_bas = '1' then
                if buffer_addr_courante < 90 then
                    buffer_addr_suivante_bas <= buffer_addr_courante + 10;
                    fin_calcul_btn_bas <= '1';
                else 
                    buffer_addr_suivante_bas <= buffer_addr_courante - 90;
                    fin_calcul_btn_bas <= '1';
                end if;
            else 
                buffer_addr_suivante_bas <= (others => '0');
                fin_calcul_btn_bas <= '0';
            end if; 
        end if;      
    end process;
    
affectation_buff_valeur_case_courante : process(clk, rst)
    begin
      if rst = '1' then
        buffer_valeur_case_courante <= (others => '0');
      elsif clk'event and clk = '1' then
        if activation_valeur_case_courante = '1' then
            buffer_valeur_case_courante <= unsigned(e_data);
--        else
--            buffer_valeur_case_courante <= buffer_valeur_case_courante;
        end if;
      end if;
    end process;  

affectation_buff_valeur_case_suivante : process(clk, rst)
    begin
      if rst = '1' then
        buffer_valeur_case_suivante <= (others => '0');
      elsif clk'event and clk = '1' then
        if activation_valeur_case_suivante = '1' then
            buffer_valeur_case_suivante <= unsigned(e_data);
        end if;
      end if;
    end process;  
    
affectation_buff_addr_courante : process(clk, rst)
    begin
        if rst = '1' then
            buffer_addr_courante <= x"63";
        elsif clk'event and clk = '1' then
            if activation_buffer_addr_courante = '1' then
                if cpt = '0' then
                    buffer_addr_courante <= x"63"; -- on prélève la valeur par défaut de la case 99
                else 
                    buffer_addr_courante <= buffer_addr_suivante; --sinon 
                end if;
             end if;
         end if;
     end process;

affectation_buff_addr_suivante : process(clk, rst)
    begin
        if rst = '1' then
            buffer_addr_suivante <= (others => '0');
        elsif clk'event and clk = '1' then
            if activation_buffer_addr_suivante = '1' then
                    if fin_calcul_btn_droit = '1' then
                        buffer_addr_suivante <= buffer_addr_suivante_droit;
                    elsif fin_calcul_btn_gauche = '1' then
                        buffer_addr_suivante <= buffer_addr_suivante_gauche;
                    elsif fin_calcul_btn_haut = '1' then
                        buffer_addr_suivante <= buffer_addr_suivante_haut;   
                    elsif fin_calcul_btn_bas = '1' then
                        buffer_addr_suivante <= buffer_addr_suivante_bas;
                    end if;
             end if;
         end if;
    end process;
    
table_de_correspondance_case_courante : process(clk, rst)
         begin
          if rst = '1' then
            buffer_new_valeur_case_courante <= x"00";
          elsif clk'event and clk = '1' then
            if activation_new_valeur_case_courante = '1' then     
                 case buffer_valeur_case_courante is 
                    when x"06" =>
                        buffer_new_valeur_case_courante <= x"00";
                    when x"07" =>  
                        buffer_new_valeur_case_courante <= x"01";
                    when x"08" =>
                        buffer_new_valeur_case_courante <= x"02";
                    when x"09" =>
                        buffer_new_valeur_case_courante <= x"03";
                    when x"0A" =>
                        buffer_new_valeur_case_courante <= x"04";
                    when x"0B" =>
                        buffer_new_valeur_case_courante <= x"05";
                    when others =>
                        buffer_new_valeur_case_courante <= x"00";
                 end case;
              end if;
             end if;
           end process;

table_de_correspondance_case_suivante : process(clk, rst)
    begin
        if rst = '1' then
            buffer_new_valeur_case_suivante <= (others => '0');
        elsif clk'event and clk = '1' then
            if activation_new_valeur_case_suivante = '1' then
             case buffer_valeur_case_suivante is 
                    when x"00" =>
                        buffer_new_valeur_case_suivante <= x"06";
                    when x"01" =>  
                        buffer_new_valeur_case_suivante <= x"07";
                    when x"02" =>
                        buffer_new_valeur_case_suivante <= x"08";
                    when x"03" =>
                        buffer_new_valeur_case_suivante <= x"09";
                    when x"04" =>
                        buffer_new_valeur_case_suivante <= x"0A";
                    when x"05" =>
                        buffer_new_valeur_case_suivante <= x"0B";
                    when others =>
                        buffer_new_valeur_case_suivante <= x"0B";
              end case;
            end if;
           end if;
      end process;
           
cpt_premiere_addr : process(clk, rst)
    begin
        if rst = '1' then
            cpt <= '0';
        elsif clk'event and clk = '1' then
            if activation_cpt_addr = '1' then
                cpt <= '1';
            end if; 
        end if;
    end process;

process(clk, rst)
    begin
        if rst = '1' then
            current_state <= etatInit;
        elsif clk'event and clk = '1' then
            current_state <= next_state;
        end if;
    end process;
    
    
process(current_state, cpt, buffer_addr_suivante, buffer_addr_suivante_droit, buffer_addr_suivante_gauche,
        buffer_addr_suivante_haut, buffer_addr_suivante_bas, buffer_new_valeur_case_suivante,buffer_new_valeur_case_courante, 
        buffer_valeur_case_suivante, buffer_old_valeur_case_courante, e_activation_acquisition,
        fin_calcul_btn_droit, fin_calcul_btn_gauche, fin_calcul_btn_haut, fin_calcul_btn_bas,
        buffer_addr_courante, e_data, e_bouton_gauche, e_bouton_droit, e_bouton_haut, e_bouton_bas, buffer_valeur_case_courante)
        
    begin
        case current_state is
        
            when etatInit =>
                s_activation_memoire <= '0';
                s_RW_mem             <= '0';
                s_data               <= (others => '0');
                s_adresse            <= (others => '0');
                s_adresse_deplacement <= (others => '0');
                s_data_deplacement    <= (others => '0');
                s_enable_registre <= '0';
                s_fin_acquisition   <= '0';
                s_activation_bp_central <= '0';
                
                activation_addr_droite <= '0';
                activation_addr_gauche <= '0';
                activation_addr_haut   <= '0';
                activation_addr_bas    <= '0';
                
                activation_buffer_addr_suivante     <= '0';
                activation_buffer_addr_courante     <= '1';
                activation_valeur_case_courante     <= '0';
                activation_valeur_case_suivante     <= '0';
                activation_new_valeur_case_courante <= '0';
                activation_new_valeur_case_suivante <= '0';
                
                activation_cpt_addr <= '0';
                fin_etape_4         <= '0';  
                  
            when etat0 =>
                --l'adresse de la case courrante prend la valeur par défaut de la case 99, sinon on l'initialise à la case suivante calculé précédemment
                s_activation_memoire <= '0';
                s_RW_mem             <= '0';
                s_data               <= (others => '0');
                s_adresse            <= (others => '0');
                s_adresse_deplacement <= (others => '0');
                s_data_deplacement    <= (others => '0');
                s_enable_registre <= '0';
                s_fin_acquisition   <= '0';
                s_activation_bp_central <= '0';
                
                activation_addr_droite <= '0';
                activation_addr_gauche <= '0';
                activation_addr_haut   <= '0';
                activation_addr_bas    <= '0';
                
                activation_buffer_addr_suivante     <= '0';
                activation_buffer_addr_courante     <= '1';
                activation_valeur_case_suivante     <= '0';
                activation_valeur_case_courante     <= '0';
                activation_new_valeur_case_courante <= '0';
                activation_new_valeur_case_suivante <= '0';
                                               
                activation_cpt_addr <= '1';
                fin_etape_4 <= '0';
                
            when etat1 =>
            -- demande de lecture de la case mémoire courante
                s_activation_memoire <= '1';
                s_RW_mem             <= '0';
                s_adresse            <= std_logic_vector(buffer_addr_courante);
                s_data               <= (others => '0');
                s_adresse_deplacement <= (others => '0');
                s_data_deplacement    <= (others => '0');
                s_enable_registre <= '0';
                s_fin_acquisition   <= '0';
                s_activation_bp_central <= '0';
                
                activation_addr_droite <= '0';
                activation_addr_gauche <= '0';
                activation_addr_haut   <= '0';
                activation_addr_bas    <= '0';
                
                activation_buffer_addr_suivante     <= '0';
                activation_buffer_addr_courante     <= '0';
                activation_valeur_case_courante     <= '0';
                activation_valeur_case_suivante     <= '0';
                activation_new_valeur_case_courante <= '0';
                activation_new_valeur_case_suivante <= '0';
                
                activation_cpt_addr <= '1';
                fin_etape_4         <= '0';
                
            when etat2 =>
            -- on stocke la donnée renvoyée par la mémoire de l'adresse courante
                s_activation_memoire <= '0';
                s_RW_mem             <= '0';
                s_adresse            <= (others => '0');
                s_data               <= (others => '0');
                s_adresse_deplacement <= (others => '0');
                s_data_deplacement    <= (others => '0');
                s_enable_registre <= '0';
                s_fin_acquisition   <= '0';
                s_activation_bp_central <= '0';
                
                activation_addr_droite <= '0';
                activation_addr_gauche <= '0';
                activation_addr_haut   <= '0';
                activation_addr_bas    <= '0';
                
                activation_buffer_addr_suivante     <= '0';
                activation_buffer_addr_courante     <= '0';
                activation_valeur_case_courante     <= '1';
                activation_valeur_case_suivante     <= '0';
                activation_new_valeur_case_courante <= '1';
                activation_new_valeur_case_suivante <= '0';
                
                activation_cpt_addr <= '1';
                fin_etape_4         <= '0';
                
           when etat3 =>
           -- conversion de la case courante par sa valeur de base (ex : selection case blanche -> case blanche
           
                s_activation_memoire <= '0';
                s_RW_mem             <= '0';
                s_adresse            <= (others => '0');
                s_data               <= (others => '0');
                s_adresse_deplacement <= (others => '0');
                s_data_deplacement    <= (others => '0');
                s_enable_registre <= '0';
                s_fin_acquisition   <= '0';
                s_activation_bp_central <= '0';
                
                activation_addr_droite <= '0';
                activation_addr_gauche <= '0';
                activation_addr_haut   <= '0';
                activation_addr_bas    <= '0';
                
                activation_buffer_addr_suivante     <= '1';
                activation_buffer_addr_courante     <= '0';
                activation_valeur_case_courante     <= '0';
                activation_valeur_case_suivante     <= '0';
                activation_new_valeur_case_courante <= '1';
                activation_new_valeur_case_suivante <= '0';
                
                activation_cpt_addr <= '1';
                fin_etape_4 <= '0';
                 
            when etat4 =>
            -- activation du process correspond à un appuie de btn 
                s_activation_memoire <= '0';
                s_RW_mem             <= '0';
                s_adresse            <= (others => '0');
                s_data               <= (others => '0');
                s_adresse_deplacement <= (others => '0');
                s_data_deplacement    <= (others => '0');
                s_enable_registre <= '0';
                s_fin_acquisition   <= '0';
                s_activation_bp_central <= '0';
                
                if  e_bouton_droit = '1' then
                
                    activation_addr_droite <= '1';
                    activation_addr_gauche <= '0';
                    activation_addr_haut   <= '0';
                    activation_addr_bas    <= '0';
                    fin_etape_4            <= '1';
                    
                elsif e_bouton_gauche = '1' then
                
                    activation_addr_droite <= '0';
                    activation_addr_gauche <= '1';
                    activation_addr_haut   <= '0';
                    activation_addr_bas    <= '0';
                    fin_etape_4            <= '1';
                                    
                elsif e_bouton_haut = '1' then
                    activation_addr_droite <= '0';
                    activation_addr_gauche <= '0';
                    activation_addr_haut   <= '1';
                    activation_addr_bas    <= '0';
                    fin_etape_4            <= '1';
                    
                elsif e_bouton_bas = '1' then
                    activation_addr_droite <= '0';
                    activation_addr_gauche <= '0';
                    activation_addr_haut   <= '0';
                    activation_addr_bas    <= '1';
                    fin_etape_4            <= '1';
                    
                else
                    activation_addr_droite <= '0';
                    activation_addr_gauche <= '0';
                    activation_addr_haut   <= '0';
                    activation_addr_bas    <= '0';
                    fin_etape_4            <= '0';
                end if;
                
                activation_buffer_addr_suivante <= '1';
                activation_valeur_case_suivante <= '0';
                activation_buffer_addr_courante <= '0';
                activation_valeur_case_courante <= '0';
                activation_new_valeur_case_courante <= '0';
                activation_new_valeur_case_suivante <= '0';
                
                activation_cpt_addr <= '1';
                
            when etat5 =>
            --attente que l'utilisateur n'appuie plus sur le bouton et que les process soit terminés
                s_activation_memoire <= '0';
                s_RW_mem             <= '0';
                s_adresse            <= (others => '0');
                s_data               <= (others => '0');
                s_adresse_deplacement <= (others => '0');
                s_data_deplacement    <= (others => '0');
                s_enable_registre <= '0';
                s_fin_acquisition   <= '0';
                s_activation_bp_central <= '0';
                
                activation_buffer_addr_suivante <= '1';
                activation_addr_droite <= '0';
                activation_addr_gauche <= '0';
                activation_addr_haut   <= '0';
                activation_addr_bas    <= '0';
                
                activation_valeur_case_suivante <= '0';
                activation_new_valeur_case_courante <= '0';
                activation_buffer_addr_courante <= '0';
                activation_valeur_case_courante <= '0';
                activation_new_valeur_case_suivante <= '0';
               
                activation_cpt_addr <= '1';
                fin_etape_4 <= '0';
                
            when etat6 =>
            -- on demande de lire la case mémoire suivante calculée par le process suivant l'appuie du btn
               
               s_activation_memoire <= '1';
               s_RW_mem             <= '0';
               s_adresse            <= std_logic_vector(buffer_addr_suivante);
               s_data               <= (others => '0');
               s_adresse_deplacement <= (others => '0');
               s_data_deplacement    <= (others => '0');
               s_enable_registre <= '0';
               s_fin_acquisition   <= '0';
               s_activation_bp_central <= '0';
               
               activation_addr_droite <= '0';
               activation_addr_gauche <= '0';
               activation_addr_haut   <= '0';
               activation_addr_bas    <= '0';
               
               activation_buffer_addr_suivante <= '0';
               activation_valeur_case_suivante <= '1';
               activation_new_valeur_case_courante <= '0';
               activation_buffer_addr_courante <= '0';
               activation_valeur_case_courante <= '0';
               activation_new_valeur_case_suivante <= '0';

               activation_cpt_addr <= '1';
               fin_etape_4         <= '0';
               
            when etat7 =>
            -- on stocke la valeur de la case suivante dans un buffer
               s_activation_memoire <= '1';
               s_RW_mem             <= '0';
               s_adresse            <= (others => '0');
               s_data               <= (others => '0');
               s_adresse_deplacement <= (others => '0');
               s_data_deplacement    <= (others => '0');
               s_enable_registre <= '0';
               s_fin_acquisition   <= '0';
               s_activation_bp_central <= '0';
                              
               activation_addr_droite <= '0';
               activation_addr_gauche <= '0';
               activation_addr_haut   <= '0';
               activation_addr_bas    <= '0';
               
               activation_buffer_addr_suivante     <= '0';
               activation_valeur_case_suivante     <= '1';
               activation_new_valeur_case_courante <= '0';
               activation_buffer_addr_courante     <= '0';
               activation_valeur_case_courante     <= '0';
               activation_new_valeur_case_suivante <= '0';
               
               activation_cpt_addr                 <= '1';
               fin_etape_4                         <= '0';
               
            when etat8 =>
            --on détermine la nouvelle valeur à affecter à la case suivante 
               s_activation_memoire <= '0';
               s_RW_mem             <= '0';
               s_adresse            <= (others => '0');
               s_data               <= (others => '0');
               s_adresse_deplacement <= (others => '0');
               s_data_deplacement    <= (others => '0');
               s_enable_registre <= '0';
               s_fin_acquisition   <= '0';
               s_activation_bp_central <= '0';
               
               activation_addr_droite <= '0';
               activation_addr_gauche <= '0';
               activation_addr_haut   <= '0';
               activation_addr_bas    <= '0';
               
               activation_buffer_addr_suivante <= '0';
               activation_valeur_case_suivante <= '0';
               activation_new_valeur_case_courante <= '0';
               activation_buffer_addr_courante <= '0';
               activation_valeur_case_courante <= '0';
               activation_new_valeur_case_suivante <= '1';
               
               activation_cpt_addr <= '1';
               fin_etape_4 <= '0';
                 
            when etat9 =>
            --on remplace la valeur de la case suivante par sa nouvelle valeur
               s_activation_memoire <= '1';
               s_RW_mem             <= '1';
               s_adresse            <= std_logic_vector(buffer_addr_suivante);
               s_data               <= std_logic_vector(buffer_new_valeur_case_suivante);
               s_adresse_deplacement <= (others => '0');
               s_data_deplacement    <= (others => '0');
               s_enable_registre <= '0';
               s_fin_acquisition <= '0';
               s_activation_bp_central <= '0';
                     
               activation_addr_droite <= '0';
               activation_addr_gauche <= '0';
               activation_addr_haut   <= '0';
               activation_addr_bas    <= '0';
               
               activation_buffer_addr_suivante <= '0';
               activation_valeur_case_suivante <= '0';
               activation_new_valeur_case_courante <= '0';
               activation_buffer_addr_courante <= '0';
               activation_valeur_case_courante <= '0';
               activation_new_valeur_case_suivante <= '0';
               
               activation_cpt_addr <= '1';
               fin_etape_4 <= '0';
               
            when etat10 =>
            -- on remplace la valeur de la case actuelle par son ancienne valeur 
               s_activation_memoire <= '1';
               s_RW_mem             <= '1';
               s_adresse            <= std_logic_vector(buffer_addr_courante);
               s_data               <= std_logic_vector(buffer_new_valeur_case_courante);
               s_adresse_deplacement <= (others => '0');
               s_data_deplacement    <= (others => '0');
               s_enable_registre <= '0';
               s_activation_bp_central <= '0';
               s_fin_acquisition   <= '0'; 
                                                         
               activation_addr_droite <= '0';
               activation_addr_gauche <= '0';
               activation_addr_haut   <= '0';
               activation_addr_bas    <= '0';
               
               activation_buffer_addr_suivante <= '0';
               activation_valeur_case_suivante <= '0';
               activation_new_valeur_case_courante <= '1';
               activation_buffer_addr_courante <= '0';
               activation_valeur_case_courante <= '0';
               activation_new_valeur_case_suivante <= '0';
               
               activation_cpt_addr <= '1';
               fin_etape_4         <= '0';

            when etat11 =>
            -- fin ack / l'adress suivante devient maintenant la courante
               s_activation_memoire  <= '0';
               s_RW_mem              <= '0';
               s_adresse             <= (others => '0');
               s_data                <= (others => '0');
               s_adresse_deplacement <= (others => '0');
               s_data_deplacement    <= (others => '0');
               s_enable_registre     <= '0';
               s_activation_bp_central <= '0';
               s_fin_acquisition     <= '1'; 
               
               activation_buffer_addr_suivante     <= '0';
               activation_valeur_case_suivante     <= '0';
               activation_new_valeur_case_courante <= '0';
               activation_buffer_addr_courante     <= '0';
               activation_valeur_case_courante     <= '0';
               activation_new_valeur_case_suivante <= '0';
               
               activation_addr_droite <= '0';
               activation_addr_gauche <= '0';
               activation_addr_haut   <= '0';
               activation_addr_bas    <= '0';
               
                
               activation_cpt_addr <= '1';
               fin_etape_4 <= '0';
               
            when etat12 =>
            -- si appuie sur le bouton centrale, on envoie l'adresse et la valeur courante au bloc déplacement, on active le chargement des données du registre 
               s_activation_memoire  <= '0';
               s_RW_mem              <= '0';
               s_adresse             <= (others => '0');
               s_data                <= (others => '0');
               s_adresse_deplacement <= std_logic_vector(buffer_addr_courante);
               s_data_deplacement    <= std_logic_vector(buffer_valeur_case_courante);
               s_enable_registre     <= '1';
               s_activation_bp_central <= '0';
               s_fin_acquisition     <= '0'; 
               
               activation_buffer_addr_suivante     <= '0';
               activation_valeur_case_suivante     <= '0';
               activation_new_valeur_case_courante <= '0';
               activation_buffer_addr_courante     <= '0';
               activation_valeur_case_courante     <= '0';
               activation_new_valeur_case_suivante <= '0';
               
               activation_addr_droite <= '0';
               activation_addr_gauche <= '0';
               activation_addr_haut   <= '0';
               activation_addr_bas    <= '0';
               
               activation_cpt_addr <= '1';
               fin_etape_4 <= '0'; 
               
           when etat13 =>    
           -- état d'attente tant que l'utilisateur n'appuie plus sur le bouton central
               s_activation_memoire  <= '0';
               s_RW_mem              <= '0';
               s_adresse             <= (others => '0');
               s_data                <= (others => '0');
               s_adresse_deplacement <= std_logic_vector(buffer_addr_courante);
               s_data_deplacement    <= std_logic_vector(buffer_valeur_case_courante);
               s_enable_registre     <= '0';
               s_activation_bp_central <= '0';
               s_fin_acquisition     <= '0'; 
               
               activation_buffer_addr_suivante     <= '0';
               activation_valeur_case_suivante     <= '0';
               activation_new_valeur_case_courante <= '0';
               activation_buffer_addr_courante     <= '0';
               activation_valeur_case_courante     <= '0';
               activation_new_valeur_case_suivante <= '0';
               
               activation_addr_droite <= '0';
               activation_addr_gauche <= '0';
               activation_addr_haut   <= '0';
               activation_addr_bas    <= '0';
               
               s_fin_acquisition   <= '0';  
               activation_cpt_addr <= '1';
               fin_etape_4 <= '0'; 
           
           when etat14 =>
           -- état d'attente tant que l'utilisateur n'appuie plus sur le bouton central
               s_activation_memoire  <= '0';
               s_RW_mem              <= '0';
               s_adresse             <= (others => '0');
               s_data                <= (others => '0');
               s_adresse_deplacement <= std_logic_vector(buffer_addr_courante);
               s_data_deplacement    <= std_logic_vector(buffer_valeur_case_courante);
               s_enable_registre     <= '0';
               s_activation_bp_central <= '1';
               s_fin_acquisition     <= '0'; 
               
               activation_buffer_addr_suivante     <= '0';
               activation_valeur_case_suivante     <= '0';
               activation_new_valeur_case_courante <= '0';
               activation_buffer_addr_courante     <= '0';
               activation_valeur_case_courante     <= '0';
               activation_new_valeur_case_suivante <= '0';
               
               activation_addr_droite <= '0';
               activation_addr_gauche <= '0';
               activation_addr_haut   <= '0';
               activation_addr_bas    <= '0';
               
               s_fin_acquisition   <= '0';  
               activation_cpt_addr <= '1';
               fin_etape_4 <= '0';       
        end case;
    end process;
    
    
process(current_state, fin_etape_4, e_activation_acquisition, e_bouton_droit, e_bouton_gauche, e_bouton_bas, e_bouton_haut, e_bouton_central, e_attente_deplacement)
    begin
        case current_state is
           when etatInit =>
                next_state <= etat0;
                
           when etat0 =>
                if e_activation_acquisition = '1' then
                    next_state <= etat1;
                else 
                    next_state <= etat0;
                end if;
            
           when etat1 =>
                next_state <= etat2;
                
           when etat2 =>
                next_state <= etat3;
           
            when etat3 =>
                next_state <= etat4;
             
           when etat4 =>
                 if fin_etape_4 = '1' then
                    next_state <= etat5;
                 elsif (e_bouton_central = '1' and e_attente_deplacement = '1') then -- si on appuie sur le bonton centrale et que le bloc deplacment est prêt à recevoir une donnée
                    next_state <= etat12;
                 else 
                    next_state <= etat4; 
                 end if;
                                      
           when etat5 =>
                if ( (e_bouton_droit = '0') and (e_bouton_gauche = '0') and (e_bouton_haut = '0') and (e_bouton_bas = '0') ) then
                    next_state <= etat6; --6 de base
                else 
                    next_state <= etat5;
                end if;
                
           when etat6 =>
                next_state <= etat7;
                               
           when etat7 =>
                next_state <= etat8;
                
           when etat8 =>
                next_state <= etat9;
           
           when etat9 =>
                next_state <= etat10; -- 10 de base
           
           when etat10 =>
                next_state <= etat11; --11 de base
           
           when etat11 =>
                next_state <= etat0;
           
           when etat12 =>
                next_state <= etat13;
                
           when etat13 =>
                if e_bouton_central = '1' then
                    next_state <= etat13;
                else
                    next_state <= etat14;
                end if;
                
           when etat14 =>
                next_state <= etat0;
                
           end case;
    end process;
end Behavioral;