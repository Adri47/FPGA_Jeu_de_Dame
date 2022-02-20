LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY filtre_bouton IS
  PORT ( clk                : in std_logic;
         e_registre_bouton  : in std_logic_vector(4 DOWNTO 0);
         rst                : in std_logic;
         s_registre_bouton  : out std_logic_vector(4 DOWNTO 0)
         );
END filtre_bouton;

ARCHITECTURE Behavioral OF filtre_bouton IS

  SIGNAL registre : std_logic_vector(4 DOWNTO 0);

BEGIN

  PROCESS(clk, rst) IS
  BEGIN

    IF rst = '1' THEN
        registre <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN
            IF e_registre_bouton = "00000" OR (((e_registre_bouton(3) XOR e_registre_bouton(2)) XOR (e_registre_bouton(1) XOR e_registre_bouton(0)) XOR e_registre_bouton(4)) = '0') THEN
                registre <= registre;
            ELSE
                registre <= e_registre_bouton;
            END IF;
    END IF;
  END PROCESS;
    
   s_registre_bouton  <= registre ;

END Behavioral;
