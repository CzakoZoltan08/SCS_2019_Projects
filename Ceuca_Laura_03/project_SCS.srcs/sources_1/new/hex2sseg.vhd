library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex2sseg is
    port ( hex : in std_logic_vector (3 downto 0);
           sseg : out std_logic_vector (6 downto 0));
end hex2sseg;

architecture Behavioral of hex2sseg is

begin

process(hex)
begin
    case(hex) is
     when "0000" => sseg <= "0000001";
     when "0001" => sseg <= "1001111";
     when "0010" => sseg <= "0010010";
     when "0011" => sseg <= "0000110";
     when "0100" => sseg <= "1001100";
     when "0101" => sseg <= "0100100";
     when "0110" => sseg <= "0100000";
     when "0111" => sseg <= "0001111";
     when "1000" => sseg <= "0000000";
     when "1001" => sseg <= "0000100";
     when "1010" => sseg <= "0001000";
     when "1011" => sseg <= "0000000";
     when "1100" => sseg <= "0110001";
     when "1101" => sseg <= "0000001";
     when "1110" => sseg <= "0110000";
     when "1111" => sseg <= "0111000";
     end case;
     
end process;

end Behavioral;
