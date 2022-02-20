library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity traitement_deplacement is 
Port (  clk                  : in  std_logic;
        rst                  : in  std_logic;
        e_enable             : in  std_logic;
        e_current_player     : in  std_logic;
        e_data               : in  std_logic_vector(15 downto 0);
        s_rw_mem             : out std_logic;
        s_enable_mem         : out std_logic;
        s_error              : out std_logic;
        s_finish_deplacement : out std_logic;
        s_wait               : out std_logic;
        s_addr               : out std_logic_vector (7 downto 0);
        s_data_mem           : out std_logic_vector (7 downto 0)
        );
end traitement_deplacement;

architecture Behavioral of traitement_deplacement is

component decodeur_1_vers_2 is
Port ( 
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    enable               : in  std_logic;   
    data                 : in  std_logic_vector(15 downto 0);
    activate_deplacement : out std_logic;
    s_wait               : out std_logic;
    data_a               : out std_logic_vector(15 downto 0);
    data_s               : out std_logic_vector(15 downto 0)
);
end component;

component deplacement is
 Port (
    clk                 : in  std_logic;
    rst                 : in  std_logic;
    current_player      : in  std_logic;  -- '0' -> blanc, sinon noir
    enable              : in  std_logic;  -- activation du bloc par la FSM principale
    e_pos_actuelle      : in  std_logic_vector(15 downto 0);
    e_pos_souhaitee     : in  std_logic_vector(15 downto 0);
    s_activate_codeur   : out std_logic;
    s_new_pos_actuelle  : out std_logic_vector(15 downto 0);
    s_new_pos_souhaitee : out std_logic_vector(15 downto 0)
 );
end component;

component codeur_2_vers_1 is
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
end component;

signal activation_deplacement, activation_codeur : std_logic;
signal data_a_codeur, data_a_deplacement         : std_logic_vector (15 downto 0);
signal data_s_codeur, data_s_deplacement         : std_logic_vector (15 downto 0);

begin

Decodeur : decodeur_1_vers_2
port map(
    clk                  => clk,
    rst                  => rst,
    enable               => e_enable,    
    data                 => e_data,
    activate_deplacement => activation_deplacement,
    s_wait               => s_wait,
    data_a               => data_a_codeur,
    data_s               => data_s_codeur
);

Bloc_deplacement : deplacement 
port map(

    clk                 => clk,
    rst                 => rst,
    current_player      => e_current_player,
    enable              => activation_deplacement,
    e_pos_actuelle      => data_a_codeur,
    e_pos_souhaitee     => data_s_codeur,
    s_activate_codeur   => activation_codeur,
    s_new_pos_actuelle  => data_a_deplacement,
    s_new_pos_souhaitee => data_s_deplacement
);

Codeur : codeur_2_vers_1 
port map(
    clk                => clk,
    rst                => rst,
    enable             => activation_codeur,
    data_1             => data_a_deplacement,
    data_2             => data_s_deplacement,
    rw_mem             => s_rw_mem,
    enable_mem         => s_enable_mem,
    error              => s_error,
    finish_deplacement => s_finish_deplacement,
    addr               => s_addr,
    data_mem           => s_data_mem
);

end Behavioral;
