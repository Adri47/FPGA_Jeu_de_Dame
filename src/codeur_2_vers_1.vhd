library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity codeur_2_vers_1 is
 Port ( 
 clk                : in  std_logic;
 rst                : in  std_logic;
 enable             : in  std_logic;
 data_1             : in  std_logic_vector (15 downto 0);
 data_2             : in  std_logic_vector (15 downto 0);
 rw_mem             : out std_logic;
 enable_mem         : out std_logic;
 error              : out std_logic;
 finish_deplacement : out std_logic;
 addr               : out std_logic_vector (7 downto 0);
 data_mem           : out std_logic_vector (7 downto 0)
 );
end codeur_2_vers_1;

architecture Behavioral of codeur_2_vers_1 is

TYPE state IS (init,wait_enable,write_data_1, write_data_2,wait_end_enable);
SIGNAL next_state, current_state : state;

begin

    process (clk,rst)
    begin 
        if rst = '1' then 
            current_state <= init;
        elsif clk'event and clk = '1'then 
            current_state <= next_state;
        end if;
    end process;

    process (current_state,enable,data_1,data_2)
    begin
        case current_state is
            when init => 
                next_state <= wait_enable;
              
            when wait_enable =>
                if enable = '1' then
                    next_state <= write_data_1;
                else 
                    next_state <= wait_enable;                
                end if;
              
            when write_data_1 =>
                next_state <= write_data_2;
            
            when write_data_2 =>
                next_state <= wait_end_enable;
            
            when wait_end_enable =>
                if enable = '0' then 
                    next_state <=  wait_enable;  
                else 
                    next_state <= wait_end_enable;
                end if;     
        end case;
    end process;
    
    process (current_state,enable,data_1,data_2)
    begin
        case current_state is
        when init =>
            rw_mem             <= '0';
            enable_mem         <= '0' ;
            addr               <= (others => '0');
            data_mem           <= (others => '0');
            error              <= '0';
            finish_deplacement <= '0';
          
        when wait_enable =>
            rw_mem             <= '0';
            enable_mem         <= '0' ;
            addr               <= (others => '0');
            data_mem           <= (others => '0'); 
            error              <= '0';
            finish_deplacement <= '0'; 
                   
        when write_data_1  =>
            if data_1(7) = '1' then 
                rw_mem     <= '0';
                enable_mem <= '0' ;
                addr       <= (others => '0');
                data_mem   <= (others => '0');    
                error      <= '0';           
            else 
                rw_mem     <= '1';
                enable_mem <= '1' ;
                addr       <= data_1(15 downto 8);
                data_mem   <= data_1(7 downto 0); 
                error      <= '0';           
            end if;
            finish_deplacement <= '0';
 
         when write_data_2  =>
            if data_2(7) = '1' then
                rw_mem     <= '0';
                enable_mem <= '0' ;
                addr       <= (others => '0');
                data_mem   <= (others => '0'); 
                error      <= '1';             
            else 
                rw_mem     <= '1';
                enable_mem <= '1' ;
                addr       <= data_2(15 downto 8);
                data_mem   <= data_2(7 downto 0);   
                error      <= '0';           
            end if;
            finish_deplacement <= '1';
              
         when wait_end_enable  =>
            rw_mem             <= '0';
            enable_mem         <= '0' ;
            addr               <= (others => '0');
            data_mem           <= (others => '0');  
            error              <= '0';   
            finish_deplacement <= '0';                              
        end case;
    end process;

end Behavioral;
