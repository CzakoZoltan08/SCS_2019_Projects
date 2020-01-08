library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Byte-adressable main memory of 128B in size

entity main_memory is 
    Port ( clk: in std_logic;
           memory_write_enable:in std_logic;
           memory_read_enable:in std_logic;
           address : in STD_LOGIC_VECTOR(6 downto 0);
           data_in: in std_logic_vector(7 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0));
end main_memory;

architecture Behavioral of main_memory is

signal block_index: std_logic_vector(5 downto 0);

type main_memory is array(0 to 63) of std_logic_vector(15 downto 0);
signal mem : main_memory := (
                            0 => x"A5A6", 
                            1 => x"BB12", 
                            2 => x"1115", 
                            3 => x"CC17",
                            16 => x"A7CD",
                            17 => x"48FF",
                            18 => x"791E",
                            19 => x"5568",
                            32 => x"1234",
                            33 => x"AB45",
                            34 => x"98AA",
                            35 => x"4D47",
                            48 => x"AB54",
                            49 => x"1AC5",
                            50 => x"8A57",
                            51 => x"33AF",
                            others => x"0000");
begin

block_index<=address(6 downto 1);

process(clk, memory_write_enable, memory_read_enable)
begin
if clk'event and clk='1' then
    if memory_read_enable='1' then
        data_out<=mem(conv_integer(block_index));
    end if;
    if memory_write_enable='1' then
        if address(0)='1' then
            mem(conv_integer(block_index))(7 downto 0)<=data_in;
        else
            mem(conv_integer(block_index))(15 downto 8)<=data_in;
        end if;
     end if;
end if;
end process;

end Behavioral;
