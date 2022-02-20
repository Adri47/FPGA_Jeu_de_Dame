library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decodeur_1_vers_2 is
Port ( 
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    enable               : in  std_logic;   
    data                 : in  std_logic_vector(15 downto 0);
    activate_deplacement : out std_logic;
    s_wait               : out std_logic;
    data_a               : out std_logic_vector(15 downto 0);
    data_s               : out std_logic_vector(15 downto 0)
);
end decodeur_1_vers_2;

architecture Behavioral of decodeur_1_vers_2 is

TYPE state IS (init,wait_enable,load_data_1,wait_change_data,load_data_2,write_data,wait_end_enable);
SIGNAL next_state, current_state                 : state;
signal load_reg_1, load_reg_2,activation_load    : std_logic;
signal compare_data , save_data_a, save_data_s   : std_logic_vector (15 downto 0);

begin

    process (clk, rst)
    begin 
        if rst = '1' then
            current_state <= init;
        elsif clk'event and clk = '1' then
            current_state <= next_state;
        end if;
    end process;
    
    process(current_state,enable,data,activation_load)
    begin
        case current_state is
            when init => 
              next_state <= wait_enable;
              
            when wait_enable => 
                if enable = '1' and activation_load ='1' then
                    next_state <= load_data_1;
                else 
                     next_state <= wait_enable;               
                end if;

            when load_data_1 =>
                next_state <= wait_change_data;  
      
            when wait_change_data =>
                if activation_load = '1' then
                    next_state <= load_data_2;
                else 
                    next_state <= wait_change_data;
                end if;
                
            when load_data_2 =>
               next_state <= write_data;           
            
            when write_data =>
               next_state <= wait_end_enable;              
                           
            when wait_end_enable =>
                if enable = '0' then
                    next_state <= wait_enable;                    
                else 
                    next_state <= wait_end_enable;    
                end if;                          
        end case;
    end process;

    process(current_state)
    begin
        case current_state is
            when init =>
                activate_deplacement <= '0';
                load_reg_1           <= '0';
                load_reg_2           <= '0'; 
                s_wait               <= '0';           
                            
            when wait_enable =>
                activate_deplacement <= '0';            
                load_reg_1           <= '0';
                load_reg_2           <= '0'; 
                s_wait               <= '1';                 
                
            when load_data_1 =>
                activate_deplacement <= '0';            
                load_reg_1           <= '1';
                load_reg_2           <= '0'; 
                s_wait               <= '0';                
                
            when wait_change_data =>
                activate_deplacement <= '0';            
                load_reg_1           <= '0';
                load_reg_2           <= '0';
                s_wait               <= '1';                 
                 
            when load_data_2 =>
                activate_deplacement <= '0';            
                load_reg_1           <= '0';
                load_reg_2           <= '1'; 
                s_wait               <= '0';                 
                
            when write_data => 
                activate_deplacement <= '1';
                load_reg_1           <= '0';
                load_reg_2           <= '0';  
                s_wait               <= '0';                 
                
            when wait_end_enable => 
                activate_deplacement <= '0';
                load_reg_1           <= '0';
                load_reg_2           <= '0'; 
                s_wait               <= '0';                                
                                
        end case;
    end process;
    
    process(clk,rst,load_reg_1,current_state,save_data_a)
    begin
        if rst = '1'  then 
            data_a      <= (others => '0');
            save_data_a <= (others => '0');
            
        elsif clk'event and clk = '1' then
            if load_reg_1 = '1' then 
                save_data_a <= data;
            end if;
            if current_state = wait_enable then
                save_data_a <= (others => '0');
            end if;            
        end if;
        data_a <= save_data_a ;        
    end process; 
       
    process(clk,rst,load_reg_2,current_state,save_data_s)
    begin
        if rst = '1' then 
            data_s      <= (others => '0');
            save_data_s <= (others  => '0');
            
         elsif clk'event and clk = '1' then
            if load_reg_2 = '1' then
                 save_data_s <= data;                     
            end if;
            if current_state = wait_enable then
                 save_data_s <= (others => '0');
            end if; 
         end if;         
         data_s <= save_data_s;   
    end process;
    
    
    process (clk,rst)
    begin
        if rst ='1' then 
            compare_data  <= (others => '0');
            activation_load <= '0';
        elsif clk'event and clk = '1' then
            if compare_data(0) /= data(0) then
                activation_load <= '1';
            elsif compare_data(1) /= data(1) then
                activation_load <= '1'; 
            elsif compare_data(2) /= data(2) then
                activation_load <= '1';
            elsif compare_data(3) /= data(3) then
                activation_load <= '1'; 
            elsif compare_data(4) /= data(4) then
                activation_load <= '1';
            elsif compare_data(5) /= data(5) then
                 activation_load <= '1'; 
            elsif compare_data(6) /= data(6) then
                 activation_load <= '1';
            elsif compare_data(7) /= data(7) then
                 activation_load <= '1';            
            elsif compare_data(8) /= data(8) then
                 activation_load <= '1'; 
            elsif compare_data(9) /= data(9) then
                 activation_load <= '1';
            elsif compare_data(10) /= data(10) then
                 activation_load <= '1'; 
            elsif compare_data(11) /= data(11) then
                 activation_load <= '1';
            elsif compare_data(12) /= data(12) then
                 activation_load <= '1'; 
            elsif compare_data(13) /= data(13) then
                 activation_load <= '1';
            elsif compare_data(14) /= data(14) then
                 activation_load <= '1';
            elsif compare_data(15) /= data(15) then
                 activation_load <= '1';                                  
            else 
                activation_load <= '0';                                              
            end if;
            compare_data <= data;
        end if;
    end process; 
end Behavioral;
