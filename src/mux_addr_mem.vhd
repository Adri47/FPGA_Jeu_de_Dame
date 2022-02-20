library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_addr_mem is
    Port ( e_addr_aff_plateau : in STD_LOGIC_VECTOR (7 downto 0);
           e_addr_acquisition : in STD_LOGIC_VECTOR (7 downto 0);
           e_sel_mux_2 : in STD_LOGIC_VECTOR (1 downto 0);
           s_addr_mem         : out STD_LOGIC_VECTOR (7 downto 0)
           );
end mux_addr_mem;

architecture Behavioral of mux_addr_mem is

begin

process(e_addr_acquisition, e_addr_aff_plateau, e_sel_mux_2)
    begin
        case e_sel_mux_2 is
            when "00" =>
                s_addr_mem <= e_addr_aff_plateau;
            when "01" =>
                s_addr_mem <= e_addr_acquisition;
            when others => null;
        end case;
    end process;

end Behavioral;
