library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    Port ( 
            clk    : IN std_logic;
            cat    : out std_logic_vector(6 downto 0);
            an     : out STD_LOGIC_VECTOR(3 downto 0);
            Digit0 : in STD_LOGIC_VECTOR(3 downto 0);
            Digit1 : in STD_LOGIC_VECTOR(3 downto 0);
            Digit2 : in STD_LOGIC_VECTOR(3 downto 0);
            Digit3 : in STD_LOGIC_VECTOR(3 downto 0)
         );
end SSD;

architecture Behavioral of SSD is

signal Digit : STD_LOGIC_VECTOR(3 downto 0);
signal Q     : STD_LOGIC_VECTOR(15 downto 0) := x"0000";

begin

    with Digit select
       Cat<= "1111001" when "0001",   --1
             "0100100" when "0010",   --2
             "0110000" when "0011",   --3
             "0011001" when "0100",   --4
             "0010010" when "0101",   --5
             "0000010" when "0110",   --6
             "1111000" when "0111",   --7
             "0000000" when "1000",   --8
             "0010000" when "1001",   --9
             "0001000" when "1010",   --A
             "0000011" when "1011",   --b
             "1000110" when "1100",   --C
             "0100001" when "1101",   --d
             "0000110" when "1110",   --E
             "0001110" when "1111",   --F
             "1000000" when others;   --0
				
CNTER: process(clk)
	begin
	   if(rising_edge(clk)) then
	    Q <= Q + '1';
	   end if;
	end process;	
	
MUXes: process(Q(15 downto 14), Digit0, Digit1, Digit2, Digit3)
	begin
        case Q(15 downto 14) is
           when "00" => Digit <=Digit0; an<="1110";
           when "01" => Digit <=Digit1; an<="1101";
           when "10" => Digit <=Digit2; an<="1011";
           when others => Digit <=Digit3; an<="0111";
        end case;
end process;	


end Behavioral;
