----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2019 23:03:13
-- Design Name: 
-- Module Name: compEQ - Behavioral
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

entity compEQ is
 Port ( a:in std_logic_vector(7 downto 0);
        b:in std_logic_vector(7 downto 0);
        eq: out std_logic );
end compEQ;

architecture Behavioral of compEQ is
begin
    process(a,b)
    begin
        if a=b then
            eq<='1';
            else eq<='0';
        end if;
    end process;


end Behavioral;
