----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2019 08:06:57 PM
-- Design Name: 
-- Module Name: AdderSub4Bit - Behavioral
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

entity AdderSub8Bit is
Port (A: in std_logic_vector(7 downto 0);
    B:in std_logic_vector(7 downto 0);
    CIN: in std_logic;
    COUT:out std_logic;
    RES:out std_logic_vector(7 downto 0);
    mode:in std_logic;
    arith:in std_logic
);
end AdderSub8Bit;

architecture Behavioral of AdderSub8Bit is


component FullAdder is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           cin : in STD_LOGIC;
           cout : out STD_LOGIC;
           s : out STD_LOGIC;
           mode:in std_logic;
           arith:in std_logic
           );

end component FullAdder;
signal couts:std_logic_vector(7 downto 0);
begin

A0: FullAdder port map(A(0), B(0), CIN, couts(0), RES(0), mode, arith);
A1: FullAdder port map(A(1), B(1), couts(0), couts(1), RES(1), mode, arith);
A2: FullAdder port map(A(2), B(2), couts(1), couts(2), RES(2), mode, arith);
A3: FullAdder port map(A(3), B(3), couts(2), couts(3), RES(3), mode, arith);
A4: FullAdder port map(A(4), B(4), couts(3), couts(4), RES(4), mode, arith);
A5: FullAdder port map(A(5), B(5), couts(4), couts(5), RES(5), mode, arith);
A6: FullAdder port map(A(6), B(6), couts(5), couts(6), RES(6), mode, arith);
A7: FullAdder port map(A(7), B(7), couts(6), couts(7), RES(7), mode, arith);

COUT<=couts(7);

end Behavioral;
