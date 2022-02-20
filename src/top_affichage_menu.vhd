library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top_affichage_menu is
  Port (clk                  : in std_logic;
        rst                  : in std_logic;
        e_activation_menu    : in std_logic;
        s_fin_affichage_menu : out std_logic;
        s_addr_vga           : out std_logic_vector (16 downto 0 );
        s_data_in            : out std_logic_vector (11 downto 0);
        s_data_write         : out std_logic
        );
        
end top_affichage_menu;

architecture Behavioral of top_affichage_menu is

component compteur_addr_mem_menu is
    Port ( clk                  : in STD_LOGIC;
           rst                  : in STD_LOGIC;
           e_activation_menu    : in STD_LOGIC;
           s_addr_menu          : out STD_LOGIC_VECTOR(16 DOWNTO 0);
           s_fin_affichage_menu : out STD_LOGIC
           );
end component;

component memoire_menu is
    Port ( clk                  : in STD_LOGIC;
           e_addr_mem_menu      : in STD_LOGIC_VECTOR (16 downto 0);
           e_activation_mem     : in STD_LOGIC;
           e_fin_affichage_menu : in STD_LOGIC;
           s_addr_vga           : out STD_LOGIC_VECTOR (16 downto 0);
           s_data_in            : out STD_LOGIC_VECTOR (11 downto 0);
           s_data_write         : out STD_LOGIC;
           s_fin_affichage_menu : out STD_LOGIC);
end component;

signal clk_top, rst_top : std_logic;
signal activation_menu, fin_affichage_menu, fin_affichage_menu_cpt : std_logic;
signal addr_vga, addr_menu : std_logic_vector (16 downto 0 );
signal data_in  :  std_logic_vector (11 downto 0);
signal data_write         :  std_logic;

begin

CPT : compteur_addr_mem_menu 
Port map ( clk                  => clk_top,
           rst                  => rst_top,
           e_activation_menu    => activation_menu,
           s_addr_menu          => addr_menu,
           s_fin_affichage_menu => fin_affichage_menu_cpt
           );

MEM_MENU :  memoire_menu
Port map  ( clk                 => clk_top,
           e_addr_mem_menu      => addr_menu,
           e_activation_mem     => activation_menu,
           e_fin_affichage_menu => fin_affichage_menu_cpt,
           s_addr_vga           => s_addr_vga,
           s_data_in            => s_data_in,
           s_data_write         => s_data_write,
           s_fin_affichage_menu => s_fin_affichage_menu
           );
           
clk_top <= clk;
rst_top <= rst;
activation_menu <= e_activation_menu;
   
end Behavioral;
