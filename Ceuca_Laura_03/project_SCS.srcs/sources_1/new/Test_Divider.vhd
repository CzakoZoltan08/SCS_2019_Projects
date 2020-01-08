library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Test_Divider is
--  Port ( );
end Test_Divider;

architecture Behavioral of Test_Divider is
signal a,b,c: std_logic_vector(31 downto 0);
component Divider is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
           y : in  STD_LOGIC_VECTOR (31 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

a <= "01000001110010000000000000000000";    --25
b <= "01000001010010000000000000000000";    --12.5

div: Divider port map(x => a,y => b,z => c);

end Behavioral;
