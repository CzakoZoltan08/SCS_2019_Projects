----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2019 12:52:25 AM
-- Design Name: 
-- Module Name: controlUnit - Behavioral
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

entity controlUnit is
  Port (
    clk:in std_logic;
    command:in std_logic_vector(2 downto 0);
    mode:out std_logic;
    arith:out std_logic;
    wr:out std_logic;
    passB:out std_logic;
    ExtImm: out std_logic
  
  );
end controlUnit;

architecture Behavioral of controlUnit is

begin
process (clk)
begin

if(rising_edge(clk)) then
case command is
when "000" => mode<='1'; wr<='1'; passB<='0'; ExtImm<='0'; arith<='1';--sub
when "001" => mode<='1'; wr<='0'; passB<='0'; ExtImm<='0'; arith<='1';--compari
when "010" => mode<='0'; wr<='1'; passB<='0'; ExtImm<='0'; arith<='0';--or
when "011" => mode<='1'; wr<='1'; passB<='0'; ExtImm<='0'; arith<='0';--shift
when "100" => mode<='0'; wr<='1'; passB<='1'; ExtImm<='1'; arith<='0';--mov
when others=>mode<='0'; wr<='1'; passB<='0'; ExtImm<='0'; arith<='0'; --pmadd
end case;
end if;
end process;

end Behavioral;
