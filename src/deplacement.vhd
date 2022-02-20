library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity deplacement is
 Port (
    clk                 : in  std_logic;
    rst                 : in  std_logic;
    current_player      : in  std_logic;  -- '0' -> blanc, sinon noir
    enable              : in  std_logic;  -- activation du bloc par la FSM principale
    e_pos_actuelle      : in  std_logic_vector(15 downto 0);
    e_pos_souhaitee     : in  std_logic_vector(15 downto 0);
    s_activate_codeur   : out std_logic;
    s_new_pos_actuelle  : out std_logic_vector(15 downto 0);
    s_new_pos_souhaitee : out std_logic_vector(15 downto 0)
 );
end deplacement;

architecture Behavioral of deplacement is

-- Dï¿½claration des ï¿½tats de la FSM
TYPE state IS (init,wait_enable,calculate_pos, load_data, write_mem, wait_end_enable);
SIGNAL next_state, current_state : state;

-- 8 premiers bits : correspond Ã  l'addrese A
-- 8 derniers bits : donnÃ©es contenue Ã  l'adresse A
signal addr_a, addr_s, data_a, data_s                   : std_logic_vector (7 downto 0);
signal result                                           : signed (7 downto 0);
signal new_data_a, new_data_s                           : std_logic_vector (7 downto 0);
signal calculate                                        : std_logic;

begin
addr_a <= e_pos_actuelle (15 downto 8);
addr_s <= e_pos_souhaitee(15 downto 8);
data_a <= e_pos_actuelle (7 downto 0);
data_s <= e_pos_souhaitee(7 downto 0);

-- Calcul de la distance entre les deux cases
result <= abs(signed(addr_s) - signed(addr_a));

   FSM : process (clk, rst) is
   begin
      if rst = '1' then
         current_state <= init;
      elsif clk'event and clk = '1' then
         current_state <= next_state;
      end if;
  end process FSM;

    process(current_state,enable, current_player,e_pos_actuelle,e_pos_souhaitee)
    begin
        case current_state is
            when init =>
              next_state <= wait_enable;

            when wait_enable =>
                if enable ='1' then
                  next_state <= calculate_pos;
                else
                  next_state <= wait_enable;
                end if;

            when calculate_pos => 
                 next_state <= load_data;
                
            when load_data =>
                 next_state <= write_mem;
                 
            when write_mem =>
                next_state <= wait_end_enable;
                
            when wait_end_enable =>
               if enable = '0' then
                    next_state <= wait_enable;
               else
                    next_state <= wait_end_enable;
               end if;
            
        end case;
    end process;

    process (current_state,addr_a,addr_s,new_data_a,new_data_s,result,data_s)
    begin
        case current_state is
        when init =>       
            s_activate_codeur                <= '0';         
            s_new_pos_actuelle (15 downto 0) <= (others => '0');
            s_new_pos_souhaitee(15 downto 0) <= (others => '0');
            calculate                        <= '0';
            
        when wait_enable => 
            s_activate_codeur                <= '0';      
            s_new_pos_actuelle (15 downto 8) <= addr_a;
            s_new_pos_souhaitee(15 downto 8) <= addr_s;
            s_new_pos_actuelle (7 downto 0)  <= new_data_a;
            s_new_pos_souhaitee(7 downto 0)  <= new_data_s;        
            calculate                        <= '0';
        
        when calculate_pos =>
        if (result = x"09" or result = x"0B") and data_s = x"07" then
            calculate <= '1';
        else 
            calculate <= '0';        
        end if;      
            s_activate_codeur                <= '0';                     
            s_new_pos_actuelle (15 downto 0) <= (others => '0');
            s_new_pos_souhaitee(15 downto 0) <= (others => '0');
--            save_data_a                      <= (others => '0');
--            save_data_s                      <= (others => '0');           
        
        when load_data =>        
            calculate                        <= '0';  
            s_activate_codeur                <= '0';     -- /!\ à vérifier si c'est 1 ou 0                      
            s_new_pos_actuelle (15 downto 8) <= addr_a;
            s_new_pos_souhaitee(15 downto 8) <= addr_s;
            s_new_pos_actuelle (7 downto 0)  <= new_data_a;
            s_new_pos_souhaitee(7 downto 0)  <= new_data_s; 
            
        when write_mem =>
            calculate                        <= '0';   
            s_activate_codeur                <= '1';                        
            s_new_pos_actuelle (15 downto 8) <= addr_a;
            s_new_pos_souhaitee(15 downto 8) <= addr_s;
            s_new_pos_actuelle (7 downto 0)  <= new_data_a;
            s_new_pos_souhaitee(7 downto 0)  <= new_data_s;
            
        when wait_end_enable =>  
            calculate                        <= '0';   
            s_activate_codeur                <= '1';                        
            s_new_pos_actuelle (15 downto 8) <= addr_a;
            s_new_pos_souhaitee(15 downto 8) <= addr_s;
            s_new_pos_actuelle (7 downto 0)  <= new_data_a;
            s_new_pos_souhaitee(7 downto 0)  <= new_data_s;                     
        end case;           
    end process;
    
    -- Case blanche vierge    : X'00'
    -- Case noire vierge      : X'01'
    -- Pion marron            : X'02'
    -- Dame marron            : X'03'
    -- Pion blanc             : X'04'
    -- Dame blanche           : X'05'
    -- Sélection case blanche : X'06'
    -- Sélection case noire   : X'07'
    -- Sélection pion marron  : X'08'
    -- Sélection dame marron  : X'09'
    -- Sélection pion blanc   : X'0A'
    -- Sélection dame blanche : X'0B'
    
    process(clk, rst)
    begin
        if rst = '1' then 
            new_data_a <= (others => '0');
            new_data_s <= (others => '0');
        elsif clk'event and clk = '1' then
            if calculate = '1'  and current_state = calculate_pos then  
                case data_a is
                    when x"02" =>
                        if current_player = '1' then 
                            new_data_a <= x"01";
                            new_data_s <= x"08";
                        else 
                            new_data_a <= x"FF";
                            new_data_s <= x"FF"; 
                        end if;    
                                           
                    when x"03" =>  
                        if current_player = '1' then 
                        new_data_a <= x"01";
                        new_data_s <= x"09";
                    else 
                        new_data_a <= x"FF";
                        new_data_s <= x"FF"; 
                    end if;     

                    when x"04" =>
                        if current_player = '0' then 
                            new_data_a <= x"01";
                            new_data_s <= x"0A";
                        else 
                            new_data_a <= x"FF";
                            new_data_s <= x"FF"; 
                        end if;    
                                           
                    when x"05" =>  
                        if current_player = '0' then 
                        new_data_a <= x"01";
                        new_data_s <= x"0B";
                    else 
                        new_data_a <= x"FF";
                        new_data_s <= x"FF"; 
                    end if;  
                   
                   when others =>      
                        new_data_a <= x"F0";
                        new_data_s <= x"F0";                                        
                end case;
            elsif calculate = '0'  and current_state = calculate_pos then  
                new_data_a <= x"F1";
                new_data_s <= x"F1";                 
            end if;
        end if;
     end process;
     
end Behavioral;