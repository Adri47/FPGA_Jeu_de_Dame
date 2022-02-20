----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2021 21:06:01
-- Design Name: 
-- Module Name: num_case - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity num_case is
    Port ( num_case : in STD_LOGIC_VECTOR (7 downto 0);
           colonne : out STD_LOGIC_VECTOR (3 downto 0);
           ligne : out STD_LOGIC_VECTOR (3 downto 0));
end num_case;

architecture Behavioral of num_case is

begin


end Behavioral;
