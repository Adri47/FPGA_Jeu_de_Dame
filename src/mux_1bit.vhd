library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_1bit is
  Port ( e_sel      : in  std_logic_vector (1 downto 0) ;
         e_entree_1 : in  std_logic;
         e_entree_2 : in  std_logic;
         e_entree_3 : in  std_logic;
         e_entree_4 : in std_logic;
         s_sortie   : out std_logic
        );
end mux_1bit;

architecture Behavioral of mux_1bit is

begin

mux : process(e_sel,e_entree_1,e_entree_2, e_entree_3, e_entree_4)
begin 
    case e_sel is
        when "00" =>
            s_sortie <= e_entree_1;
        when "01" =>
            s_sortie <= e_entree_2;
        when "10" =>
            s_sortie <= e_entree_3;
        when "11" =>
            s_sortie <= e_entree_4;
        when others => s_sortie <= '1';
    end case;
end process mux;

end Behavioral;
