library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
Port(
clk: in std_logic;
btn : in STD_LOGIC_VECTOR(4 downto 0);   
sw : in std_logic_vector (15 downto 0);
led : out STD_LOGIC_VECTOR (15 downto 0); 
an : out STD_LOGIC_VECTOR (3 downto 0);
cat : out STD_LOGIC_VECTOR (6 downto 0)
);
end controller;

architecture Behavioral of controller is

component MPG is --MPG compnoent
 Port ( clk : in STD_LOGIC;         
btn : in STD_LOGIC;           
en : out STD_LOGIC);
end component;

component SSD is --SSD component
    Port ( digit : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component cache_memory is
Port ( clk: in std_logic;
           en: in std_logic;
           memory_en: in std_logic;
           read_enable: in std_logic;
           write_enable: in std_logic;
           request: in std_logic_vector(6 downto 0);
           memory_data_block: in std_logic_vector(15 downto 0);
           hit: out STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component main_memory is
Port ( clk: in std_logic;
           memory_write_enable:in std_logic;
           memory_read_enable:in std_logic;
           address : in STD_LOGIC_VECTOR (6 downto 0);
           data_in: in std_logic_vector(7 downto 0);
           data_out : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal request: std_logic_vector(6 downto 0);
signal data: std_logic_vector(7 downto 0);

signal enable: std_logic;
signal data_out: std_logic_vector(15 downto 0):=x"0000";
signal data_final: std_logic_vector(15 downto 0):=x"0000";

signal cache_read_enable: std_logic;
signal cache_write_enable: std_logic;

signal cache_hit: std_logic;
signal cache_en: std_logic:='0';

signal memory_write_enable: std_logic;
signal memory_read_enable: std_logic;

signal memory_block_from_memory: std_logic_vector(15 downto 0);
signal memory_block_to_cache: std_logic_vector(15 downto 0);

begin

en: MPG port map (clk, btn(0), enable);
ssdmap: SSD port map(data_final, clk, cat, an);

cache_map: cache_memory port map (clk, enable, cache_en,cache_read_enable,cache_write_enable, request, memory_block_to_cache, cache_hit, data_out);
main_memory_map: main_memory port map(clk, memory_write_enable, memory_read_enable, request, data, memory_block_from_memory); 

led(15)<=memory_write_enable;
led(14)<=memory_read_enable;
led(13)<=cache_write_enable;
led(12)<=cache_read_enable;

request<=sw(6 downto 0);
data<=sw(14 downto 7);

memory_read_enable<=not cache_hit and not sw(15);
memory_write_enable<=sw(15);

cache_read_enable<=not sw(15);
cache_write_enable<=sw(15);

process(clk, enable)
begin

if clk'event and clk='1' then
    if enable='1' then
        if sw(15) = '0' then --READ request
            if cache_hit='0' then 
            cache_en<='1';
            memory_block_to_cache<=memory_block_from_memory;
            else
            cache_en<='0';
            end if;
        else --WRITE REQUEST
            cache_en<='0';
            memory_block_to_cache<=x"00" & data;
        end if;
    end if;
end if;
end process;

process(enable, clk)
begin
if cache_hit='1' then
            led(3 downto 0)<=x"F";
            led(7 downto 4)<=x"0";
            data_final<=data_out;
else
            led(3 downto 0)<=x"0";
            led(7 downto 4)<=x"F";
            if sw(15) = '1' then 
                data_final <= memory_block_to_cache;
            else
                data_final<=memory_block_from_memory;
            end if;
end if;
end process;
end Behavioral;
