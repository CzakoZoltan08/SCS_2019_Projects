----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2019 20:46:11
-- Design Name: 
-- Module Name: Adder_8Bits - Behavioral
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

entity Adder_8Bits is
  Port (Cin		:	In	Std_logic;
		x : in std_logic_vector(7 downto 0);
		y : in std_logic_vector(7 downto 0);
		r : out std_logic_vector(7 downto 0);
		Cout		:	Out	Std_logic
	);
end Adder_8Bits;

architecture Behavioral of Adder_8Bits is

component Adder
    Port ( A : in STD_LOGIC;
       B : in STD_LOGIC;
       Cin : in STD_LOGIC;
       S : out STD_LOGIC;
       Cout : out STD_LOGIC);
end component;

signal c : std_logic_vector(7 downto 1);

begin

stage0: Adder port map ( x(0), y(0), Cin, r(0), c(1));
stage1: Adder port map ( x(1), y(1), c(1), r(1), c(2));
stage2: Adder port map ( x(2), y(2), c(2), r(2), c(3));
stage3: Adder port map ( x(3), y(3), c(3), r(3), c(4));
stage4: Adder port map ( x(4), y(4), c(4), r(4), c(5));
stage5: Adder port map ( x(5), y(5), c(5), r(5), c(6));
stage6: Adder port map ( x(6), y(6), c(6), r(6), c(7));
stage7: Adder port map ( x(7), y(7), c(7), r(7), Cout);

end Behavioral;
