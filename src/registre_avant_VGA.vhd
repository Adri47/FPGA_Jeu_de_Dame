library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registre_avant_VGA is
    Port ( clk                      : in STD_LOGIC;
           rst                      : in STD_LOGIC;
           e_reg_ADDR_VGA           : in STD_LOGIC_VECTOR (16 downto 0);
           e_reg_data_in_VGA        : in STD_LOGIC_VECTOR (11 downto 0);
           e_reg_data_write_VGA     : in STD_LOGIC;
           s_reg_ADDR_VGA           : out STD_LOGIC_VECTOR (16 downto 0);
           s_reg_data_in_VGA        : out STD_LOGIC_VECTOR (11 downto 0);
           s_reg_data_write_VGA     : out STD_LOGIC
           );
end registre_avant_VGA;

architecture Behavioral of registre_avant_VGA is

signal data_write_VGA     :  STD_LOGIC;
signal data_in_VGA        :  STD_LOGIC_VECTOR (11 downto 0);
signal ADDR_VGA           :  STD_LOGIC_VECTOR (16 downto 0);

begin

process (clk, rst)
    begin
        if rst = '1' then
            ADDR_VGA <= (others => '0');
            data_in_VGA <= (others => '0');
            data_write_VGA <= '0';
            
        elsif clk'event and clk = '1' then
            ADDR_VGA <= e_reg_ADDR_VGA;
            data_in_VGA <= e_reg_data_in_VGA;
            data_write_VGA <= e_reg_data_write_VGA;
             
        end if;        
    end process;
    
s_reg_ADDR_VGA        <= ADDR_VGA;
s_reg_data_in_VGA     <= data_in_VGA;
s_reg_data_write_VGA  <= data_write_VGA;

end Behavioral;
