library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Test_multiplier is
--  Port ( );
end Test_multiplier;

architecture Behavioral of Test_multiplier is
signal a,b,c: std_logic_vector(31 downto 0);
component Multiplier is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
           y : in  STD_LOGIC_VECTOR (31 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

a <= "01000001010010000000000000000000";    --12.5
b <= "01000000101000000000000000000000";    --5

--a <= "01111111110010000000000000000000";   
--b <= "01000000101000000000000000000000";    

mul: Multiplier port map(x => a,y => b,z => c);

end Behavioral;
