----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/23/2019 09:49:43 PM
-- Design Name: 
-- Module Name: NOT_GATE - Behavioral
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

entity NOT_GATE is
    Port ( A : in STD_LOGIC_VECTOR (0 to 15);
           B : out STD_LOGIC_VECTOR (0 to 15));
end NOT_GATE;

architecture Behavioral of NOT_GATE is

signal temp: std_logic_vector(15 downto 0);
begin
 gen: for i in 0 to 15 generate
       temp(i) <= not A(i);
   end generate; 
B<=temp;

end Behavioral;
