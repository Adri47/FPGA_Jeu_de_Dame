library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registre is
  Port (clk               : in  std_logic;
        rst               : in  std_logic;
        e_enable_registre : in std_logic;
        e_data_registre   : in  std_logic_vector (15 downto 0);
        s_data_registre   : out std_logic_vector (15 downto 0)
        );
end registre;

architecture Behavioral of registre is

begin

process (clk, rst) is

 begin

     if rst = '1' then 
        s_data_registre <= (others => '0');

     elsif clk'event and clk = '1' then
        if e_enable_registre = '1' then
                s_data_registre <= e_data_registre;
        end if;
     end if;
 end process;

end Behavioral;
