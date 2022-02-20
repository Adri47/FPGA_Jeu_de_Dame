library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_entree_mem is
 Port ( e_sel      : in  std_logic_vector (1 downto 0) ;
        e_entree_1 : in  std_logic_vector (7 downto 0);
        e_entree_2 : in  std_logic_vector (7 downto 0);
        e_entree_3 : in  std_logic_vector (7 downto 0);
        e_entree_4 : in  std_logic_vector (7 downto 0);
        s_sortie   : out std_logic_vector(7 downto 0)
        );
end mux_entree_mem;

architecture Behavioral of mux_entree_mem is

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
            
        when others => s_sortie <= (others =>'1');
    end case;
end process mux;

end Behavioral;
