library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity memoire is
    Port ( e_rw           : in STD_LOGIC;
           e_en_mem       : in STD_LOGIC;
           clk            : in STD_LOGIC;
           e_address_mem  : in STD_LOGIC_VECTOR (7 downto 0);
           s_data_out_mem : out STD_LOGIC_VECTOR (7 downto 0);
           e_data_in_mem  : in STD_LOGIC_VECTOR (7 downto 0)
           );
end memoire;

architecture Behavioral of memoire is

type memoire is array (0 to 99) of integer;
signal plateau : memoire :=(0,2,0,2,0,2,0,2,0,2,2,0,2,0,2,0,2,0,2,0,0,2,0,2,0,2,0,2,0,2,2,0,2,0,2,0,2,0,2,0,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,0,4,0,4,0,4,0,4,0,4,4,0,4,0,4,0,4,0,4,0,0,4,0,4,0,4,0,4,0,4,4,0,4,0,4,0,4,0,4,0);
--signal plateau : memoire := (0,6,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
begin

    process (clk)
        begin
            if (clk'event and clk = '1') then
                    if (e_en_mem = '1') then
                        if (e_rw = '1') then
                             plateau(to_integer(unsigned(e_address_mem))) <= to_integer(unsigned(e_data_in_mem));
                        else
                            s_data_out_mem <= std_logic_vector(to_unsigned(plateau(to_integer(unsigned(e_address_mem))),8));
                    end if;
                 end if;
             end if;
      end process;
end Behavioral;
