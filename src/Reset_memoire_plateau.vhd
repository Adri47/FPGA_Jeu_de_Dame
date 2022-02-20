library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Reset_memoire_plateau is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           e_activation_rst : in STD_LOGIC;
           s_rw_rst : out STD_LOGIC;
           s_en_mem_rst : out STD_LOGIC;
           s_fin_rst_mem : out STD_LOGIC;
           s_addr_rst : out STD_LOGIC_VECTOR (7 downto 0);
           s_data_in_rst : out STD_LOGIC_VECTOR (7 downto 0)
           );
end Reset_memoire_plateau;

architecture Behavioral of Reset_memoire_plateau is

type memoire is array (0 to 99) of integer;
signal plateau : memoire :=(0,2,0,2,0,2,0,2,0,2,2,0,2,0,2,0,2,0,2,0,0,2,0,2,0,2,0,2,0,2,2,0,2,0,2,0,2,0,2,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,0,4,0,4,0,4,0,4,0,4,4,0,4,0,4,0,4,0,4,0,0,4,0,4,0,4,0,4,0,4,4,0,4,0,4,0,4,0,4,0);

signal cpt : unsigned(7 downto 0):= (others =>'0');

begin

process(clk, rst, e_activation_rst)
    begin
        if rst = '1' then
            cpt <= (others => '0');
            s_fin_rst_mem <= '0';
            s_en_mem_rst <= '0';
            s_rw_rst <= '0';
            
        elsif clk'event and clk = '1' then
            if e_activation_rst = '1' then
            
                s_en_mem_rst <= '1';
                s_rw_rst <= '1';
                
                    if cpt < 99 then 
                        cpt <= cpt + 1;
                    else 
                        cpt <= (others => '0');
                        s_fin_rst_mem <= '1';
                    end if;
            else 
                cpt <= (others => '0');
                s_fin_rst_mem <= '0';
                s_en_mem_rst <= '0';
                
            end if;
        end if;
     end process;
     
s_addr_rst <= std_logic_vector(cpt);
s_data_in_rst <= std_logic_vector(to_unsigned(plateau(to_integer(unsigned(cpt))),8));


end Behavioral;
