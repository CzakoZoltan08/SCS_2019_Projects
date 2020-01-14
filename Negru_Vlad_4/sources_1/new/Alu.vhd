----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2019 08:44:36 PM
-- Design Name: 
-- Module Name: Alu - Behavioral
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

entity Alu is
  Port (
    mode:in std_logic;
    arith:in std_logic;
    passB:in std_logic;
    packed: in std_logic_vector(1 downto 0);
    A: in std_logic_vector(31 downto 0);
    B: in std_logic_vector(31 downto 0);
    Res: out std_logic_vector(31 downto 0);
    greaterThenMask:out std_logic_vector(3 downto 0)
   );
end Alu;

architecture Behavioral of Alu is

component AdderSub8Bit is
Port (A: in std_logic_vector(7 downto 0);
    B:in std_logic_vector(7 downto 0);
    CIN: in std_logic;
    COUT:out std_logic;
    RES:out std_logic_vector(7 downto 0);
    mode:in std_logic;
    arith:in std_logic
);
end component AdderSub8Bit;

signal couts:std_logic_vector(3 downto 0);
signal cins:std_logic_vector(3 downto 0);
signal ResAdder:std_logic_vector(31 downto 0);
signal ResLogic:std_logic_vector(31 downto 0);

signal useCarry:std_logic_vector(3 downto 0);
signal resSelect:std_logic;

begin

U0: AdderSub8Bit port map(A(7 downto 0), B(7 downto 0), '0', couts(0), ResAdder(7 downto 0), mode, arith);
U1: AdderSub8Bit port map(A(15 downto 8), B(15 downto 8), cins(0), couts(1), ResAdder(15 downto 8), mode, arith);
U2: AdderSub8Bit port map(A(23 downto 16), B(23 downto 16), cins(1), couts(2), ResAdder(23 downto 16), mode, arith);
U3: AdderSub8Bit port map(A(31 downto 24), B(31 downto 24), cins(2), couts(3), ResAdder(31 downto 24), mode, arith);

cins <= couts and useCarry;



process(packed)
begin

case packed is

when "00" => useCarry<="0000";
when "01" => useCarry<="0101";
when "10" => useCarry<="0111";
when others => useCarry<="0000";
end case;

end process;

Res<=ResAdder when passB='0'
else B;

greaterThenMask(0) <= couts(0) and (not useCarry(0));
greaterThenMask(1) <= couts(1) and (not useCarry(1));
greaterThenMask(2) <= couts(2) and (not useCarry(2));
greaterThenMask(3) <= couts(3) and (not useCarry(3));



end Behavioral;
