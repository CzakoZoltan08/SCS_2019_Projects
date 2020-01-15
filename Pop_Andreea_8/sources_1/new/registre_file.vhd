----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2019 10:42:32 AM
-- Design Name: 
-- Module Name: registre_file - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registre_file is
    Port ( readAddress1 : in STD_LOGIC_VECTOR (2 downto 0);
           readAddress2 : in STD_LOGIC_VECTOR (2 downto 0);
           writeAddress : in STD_LOGIC_VECTOR (2 downto 0);
           writeData : in STD_LOGIC_VECTOR (15 downto 0);
           readData1 : out STD_LOGIC_VECTOR (15 downto 0);
           readData2 : out STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in STD_LOGIC;
           clk : in STD_LOGIC);
end registre_file;

architecture Behavioral of registre_file is

type reg_array is array (0 to 7) of std_logic_vector (15 downto 0);

signal reg_file : reg_array := (
  0 => x"0000",
  1 => x"0001",
  2 => x"0002",
  3 => x"0003",
  4 => x"0004",
  5 => x"0005",
  6 => x"0006",
  7 => x"0007"
);

begin

   readData1 <= reg_file(conv_integer(readAddress1));
   readData2 <= reg_file(conv_integer(readAddress2));
    
   process(clk)
   begin
        if rising_edge(clk) then
            if regWrite = '1' then
               reg_file(conv_integer(writeAddress)) <= writeData; 
            end if;
        end if;
   
   end process;


end Behavioral;
