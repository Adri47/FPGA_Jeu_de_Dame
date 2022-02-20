
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity rst_VGA is
    Port ( clk                  : in STD_LOGIC;
           rst                  : in STD_LOGIC;
           e_activation_rst_VGA : in STD_LOGIC;
           s_fin_rst_VGA        : out STD_LOGIC;
           s_data_write_rst_VGA : out STD_LOGIC;
           s_addr_VGA_rst_VGA   : out STD_LOGIC_VECTOR (16 downto 0);
           s_data_in_rst_VGA    : out STD_LOGIC_VECTOR (11 downto 0)
           );
end rst_VGA;

architecture Behavioral of rst_VGA is

signal cpt : unsigned(16 downto 0):= (others =>'0');

begin

process(clk,rst,e_activation_rst_VGA)
    begin
        if rst = '1' then
            cpt <= (others =>'0');
            s_fin_rst_VGA <= '0';
            
        elsif clk'event and clk = '1' then
            if e_activation_rst_VGA = '1' then
                if cpt < 76799 then
                    cpt <= cpt + 1;
                    s_fin_rst_VGA <= '0';
                else
                    cpt <= (others => '0');
                    s_fin_rst_VGA <= '1';
                end if;
            else
                cpt <= (others => '0');
                s_fin_rst_VGA <= '0';
            end if;
        end if;
     end process;
 
 s_data_write_rst_VGA <= '1';
 s_data_in_rst_VGA <= (others => '0');
 s_addr_VGA_rst_VGA <= std_logic_vector(cpt);
 
end Behavioral;
