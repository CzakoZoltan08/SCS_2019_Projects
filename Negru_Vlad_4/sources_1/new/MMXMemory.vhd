----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2019 11:20:06 PM
-- Design Name: 
-- Module Name: MMXMemory - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MMXMemory is
 Port (
    dest:in std_logic_vector(2 downto 0);
    op1: in std_logic_vector(2 downto 0);
    op2:in std_logic_vector(2 downto 0);
    AOut:out std_logic_vector(31 downto 0);
    BOut:out std_logic_vector(31 downto 0);
    clk:in std_logic;
    wr:in std_logic;
    wrData:in std_logic_vector(31 downto 0)
 );
end MMXMemory;



architecture Behavioral of MMXMemory is
type mem is array(0 to 7) of std_logic_vector(31 downto 0);
signal memory:mem:=(x"00000000",
x"00000011",
x"00000022", 
x"00000034",
x"00000052",
x"00000089",
x"12345678",
x"00000F23"
);


begin

process(clk, op1, op2) 
begin
if(rising_edge(clk)) then
if(wr = '1') then 
    memory(conv_integer(dest)) <= wrData;
end if;
end if;
AOut <= memory(conv_integer(op1));
BOut <= memory(conv_integer(op2));
end process;

end Behavioral;
