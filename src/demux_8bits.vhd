
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_8bits is
  Port ( e_sel      : in  std_logic_vector (1 downto 0) ;
         e_entree   : in  std_logic_vector ( 7 downto 0);
         s_sortie_1 : out std_logic_vector ( 7 downto 0);
         s_sortie_2 : out std_logic_vector ( 7 downto 0)
--         s_sortie_3 : out std_logic_vector ( 7 downto 0)
       );
end demux_8bits;

architecture Behavioral of demux_8bits is

signal sortie_1 : std_logic_vector ( 7 downto 0);
signal sortie_2 : std_logic_vector ( 7 downto 0);
--signal sortie_3 : std_logic_vector ( 7 downto 0);
signal reg_e_entree : std_logic_vector ( 7 downto 0);

begin

mux : process(e_sel, e_entree, reg_e_entree)
begin
    case e_sel is
        when "00" =>
            sortie_1 <= reg_e_entree;
            sortie_2 <= (others => '0');
--            sortie_3 <= (others => '0');
            
        when "01" =>
            sortie_1 <= (others => '0');
            sortie_2 <= reg_e_entree;
--            sortie_3 <= (others => '0');
            
        when "10" =>
            sortie_1 <= (others => '0');
            sortie_2 <= (others => '0');
--            sortie_3 <= reg_e_entree;
            
        when others => 
            sortie_1 <= (others => '1');
            sortie_2 <= (others => '1');
--            sortie_3 <= (others => '1');

    end case;
end process mux;

reg_e_entree <= e_entree;
s_sortie_1 <= sortie_1;
s_sortie_2 <= sortie_2;
--s_sortie_3 <= sortie_3;

end Behavioral;
