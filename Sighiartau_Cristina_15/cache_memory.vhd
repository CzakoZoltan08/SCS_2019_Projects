library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--Cache memory of 32B

entity cache_memory is
    Port ( clk: in std_logic;
           en: in std_logic;
           memory_en: in std_logic;
           read_enable: in std_logic;
           write_enable: in std_logic;
           request: in std_logic_vector(6 downto 0);
           memory_data_block: in std_logic_vector(15 downto 0);
           hit: out STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (15 downto 0));
end cache_memory;

architecture Behavioral of cache_memory is

type data_memory is array (0 to 15) of std_logic_vector (15 downto 0); 
signal data_mem: data_memory := (x"A5A6", x"48FF", x"1115", x"33AF", others=>x"0000"); 

type tag_memory is array (0 to 15) of std_logic_vector (1 downto 0); 
signal tag_mem: tag_memory  := ("00", "01", "00", "11", others=>"00"); 

signal tag_address: std_logic_vector(1 downto 0); 
signal cache_line: std_logic_vector(3 downto 0);
signal block_offset: std_logic;

signal tag_result:std_logic_vector(1 downto 0);
signal mem_result:std_logic_vector(15 downto 0);

begin

tag_address<=request(6 downto 5);
cache_line<=request(4 downto 1);
block_offset<=request(0);

tag_result<=tag_mem(conv_integer(cache_line));
mem_result<=data_mem(conv_integer(cache_line));

cache_hit_or_miss: process(clk)
begin
if clk'event and clk='1' then
   if en='1' then
    if read_enable='1' then
        if tag_result = tag_address then
            hit<='1';
            if block_offset='1' then
                data_out<= "000000" & tag_result & mem_result(7 downto 0);
            else
                data_out<= "000000" & tag_result & mem_result(15 downto 8);
            end if;
        else 
            hit<='0'; 
            if memory_en = '1' then
                data_mem(conv_integer(cache_line))<=memory_data_block;
                tag_mem(conv_integer(cache_line))<=request(6 downto 5);
                data_out<=memory_data_block;
            end if;
        end if;
    end if;   
   if write_enable='1' then 
      if tag_result = tag_address then
        hit<='1';
        data_out<=memory_data_block;
        if block_offset='1' then
            data_mem(conv_integer(cache_line))(7 downto 0)<=memory_data_block(7 downto 0);
        else
            data_mem(conv_integer(cache_line))(15 downto 8)<=memory_data_block(7 downto 0);
        end if;
      else
        hit<='0';
        data_out<=memory_data_block;
      end if;      
   end if;
end if;
end if;
end process;
end Behavioral;
