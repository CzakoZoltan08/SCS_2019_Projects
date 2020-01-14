----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2019 04:11:46 PM
-- Design Name: 
-- Module Name: FullAdder - Behavioral
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

entity FullAdder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           cin : in STD_LOGIC;
           cout : out STD_LOGIC;
           s : out STD_LOGIC;
          
           mode:in std_logic;
           arith:in std_logic
           );
           
end FullAdder;


   architecture Behavioral of FullAdder is

begin


s<=(a xor b xor  cin) when arith = '1'
else (a or b) when (arith = '0' and mode='0')
else cin;

cout <= (a and b) or ((a or b) and cin) when (mode = '0' and arith = '1')
else ((b and cin) or ((not a) and (b or cin))) when (mode='1' and arith = '1')
else '0' when (mode='0' and arith='0')
else a
; 

end Behavioral;
