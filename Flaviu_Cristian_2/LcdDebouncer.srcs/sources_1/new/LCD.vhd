----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2019 08:05:01 PM
-- Design Name: 
-- Module Name: LCD - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LCD is
Port (     clk : in STD_LOGIC;
           enable:in std_logic;
           d0 : in STD_LOGIC_VECTOR (3 downto 0);
           d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end LCD;

architecture Behavioral of LCD is
signal selector:std_logic_vector(1 downto 0):="00";
signal count:std_logic_vector(15 downto 0);
signal tempD: STD_LOGIC_VECTOR(3 DOWNTO 0);
begin

process(selector)
begin
case selector is
     when "00"=>tempD<=d0;
     when "01"=>tempD<=d1;
     when "10"=>tempD<=d2;
     when "11"=>tempD<=d3;
     when others=>null;
end case;
end process;

process(selector)
begin
case selector is
     when "00"=>an <= "1110";
     when "01"=>an <= "1101";
     when "10"=>an <= "1011";
     when "11"=>an <= "0111";
     when others=>null;
end case;
end process;

process(clk)
begin 
    if rising_edge(clk) then
        count <= count  + 1;
     end if;
 end process;
selector<=count(15 downto 14);
process(clk)
begin 

    if(enable='0') then
 case tempD is 
            when "0001"=>cat<= "1111001";  --1
            when "0010"=>cat<="0100100";  --2
            when "0011"=>cat<="0110000";   --3
            when "0100"=>cat<= "0011001";   --4
            when "0101"=>cat<= "0010010";  --5
            when "0110"=>cat<=  "0000010";  --6
            when "0111"=>cat<="1111000";   --7
            when "1000"=>cat<=  "0000000";   --8
            when "1001"=>cat<= "0010000";   --9
            when "1010"=>cat<="0001000";   --A
            when "1011"=>cat<="0000011";   --b
            when "1100"=>cat<="1000110";   --C
            when "1101"=>cat<="0100001";  --d
            when "1110"=>cat<="0000110";   --E
            when "1111"=>cat<="0001110";   --F
            when others=>cat<="1000000";   --0
     end case;
     
    else
     case tempD is 
            when "0001"=>cat<="1000111";  --L 1 
            when "0010"=>cat<="1000000";  --D 2 
            when "0011"=>cat<="1001111";   --I 3
            when "0100"=>cat<="0001000";   --R 4
            when "0101"=>cat<="1111001";  --1 5 
            when "0110"=>cat<="0100100";  --2 6
            when "0111"=>cat<="1011111";   --7
            when "1000"=>cat<="0111111";   --8
            when "1001"=>cat<= "0010000";   --9
            when "1010"=>cat<="0001000";   --A
            when "1011"=>cat<="0000011";   --b
            when "1100"=>cat<="1000110";   --C
            when "1101"=>cat<="0100001";  --d
            when "1110"=>cat<="0000110";   --E
            when "1111"=>cat<="0001110";   --F
            when others=>cat<="1000000";   --0
     end case;
    end if;  
   end process;
end Behavioral;
