----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/17/2019 07:37:07 PM
-- Design Name: 
-- Module Name: PMUL - Behavioral
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

entity PMUL is
  Port ( input1: in std_logic_vector(15 downto 0);
         input2: in std_logic_vector(15 downto 0);
         result: out std_logic_vector(31 downto 0) );
end PMUL;

architecture Behavioral of PMUL is

component  multiplicator_test is
    generic(
            WORD_SIZE: natural := 8
 
        );
        port(
            input_1: in std_logic_vector(WORD_SIZE-1 downto 0);
            input_2: in std_logic_vector(WORD_SIZE-1 downto 0);
            result: out std_logic_vector((2*WORD_SIZE - 1) downto 0)
            
        );
end component;
begin


end Behavioral;
