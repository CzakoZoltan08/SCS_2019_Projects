library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity InputReg is
  Port ( clk : in std_logic;
         inputSelection : in std_logic;
         enable : in std_logic;
         input : in std_logic_vector(3 downto 0);
         output : out std_logic_vector(3 downto 0));
end InputReg;

architecture Behavioral of InputReg is

signal temp : std_logic_vector(3 downto 0);

begin

process(clk, enable)
begin
    if (rising_edge(clk)) then
        if ( inputSelection = '1' and enable = '1' ) then
            temp <= input;
        end if;
    end if;
end process;

output <= temp;

end Behavioral;