----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/18/2019 12:06:43 PM
-- Design Name: 
-- Module Name: multiplyAndAdd - Behavioral
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

entity multiplyAndAdd is
 Port (A, B:in std_logic_vector(31 downto 0);
    Res:out std_logic_vector(31 downto 0)
  );
end multiplyAndAdd;

architecture Behavioral of multiplyAndAdd is
signal temp: std_logic_vector(63 downto 0);
begin

temp(15 downto 0) <= A(7 downto 0) * B(7 downto 0);
temp(31 downto 16) <= A(15 downto 8) * B(15 downto 8);
temp(47 downto 32) <= A(23 downto 16) * B(23 downto 16);
temp(63 downto 48) <= A(31 downto 24) * B(31 downto 24);

Res(31 downto 16) <= temp(63 downto 48) + temp(47 downto 32);
Res(15 downto 0) <= temp(31 downto 16) + temp(15 downto 0);
end Behavioral;
