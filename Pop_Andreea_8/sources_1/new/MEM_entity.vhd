----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2019 05:05:03 PM
-- Design Name: 
-- Module Name: MEM_entity - Behavioral
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

entity MEM_entity is
    Port ( clk : in STD_LOGIC;
           ALURes : inout STD_LOGIC_VECTOR (15 downto 0);
           readData2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWr : in STD_LOGIC;
           enable: in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end MEM_entity;

architecture Behavioral of MEM_entity is
type ram_array is array (0 to 127) of std_logic_vector ( 15 downto 0);

signal mem_ram: ram_array :=(
   0 => x"0000",
   1 => x"0001",
   2 => x"0002",
   3 => x"0003",
   4 => x"0004",
   5 => x"0005",
   6 => x"0006",
   7 => x"0007",
   8 => x"0008",
   9 => x"0009", 
   10 => x"0010",
   others => x"0000"
);

begin
    
    MemData <= mem_ram(conv_integer(ALURes));
    
    process(clk)
    begin
        if rising_edge(clk) then
            if MemWr = '1' and enable = '1' then
                   mem_ram(conv_integer(ALURes)) <= readData2;
            end if;
        end if;
    end process;
    
end Behavioral;
