----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2019 11:47:40 AM
-- Design Name: 
-- Module Name: ram_write_first - Behavioral
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

entity ram_write_first is
    Port( readAddress: in STD_LOGIC_VECTOR(3 downto 0);
          writeAddress: in STD_LOGIC_VECTOR(3 downto 0);
          writeData: in STD_LOGIC_VECTOR(15 downto 0);
          readData: out STD_LOGIC_VECTOR(15 downto 0);
          regWrite: in STD_LOGIC;
          clk: in STD_LOGIC
    );
end ram_write_first;

architecture Behavioral of ram_write_first is

type ram_array is array (0 to 15) of std_logic_vector ( 15 downto 0);

signal mem_ram: ram_array :=(
   x"0001",
   x"0001",
   x"0002",
   x"0003",
   others => "0000" 
);

begin
    
    readData <= mem_ram(conv_integer(readAddress));
    
    process(clk)
    begin
        if rising_edge(clk) then
            if regWrite = '1' then
                   mem_ram(conv_integer(writeAddress)) <= writeData;
            end if;
        end if;
          
    end process;

end Behavioral;
