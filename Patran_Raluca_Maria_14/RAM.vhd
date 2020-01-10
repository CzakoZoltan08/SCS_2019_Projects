library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM is
    Port ( clock      : in  STD_LOGIC;      
           reset      : in STD_LOGIC;    
           rd         : in  STD_LOGIC;    
           wr         : in STD_LOGIC;	  
           addr       : in  STD_LOGIC_VECTOR (7 downto 0);
           data_in    : in  STD_LOGIC_VECTOR (31  downto 0);
           data_out   : out  STD_LOGIC_VECTOR (31  downto 0); 
           data_ready : out  STD_LOGIC); 
end RAM;

architecture Behavioral of RAM is

type ram is array (0 to 2**8-1) of STD_LOGIC_VECTOR (32-1 downto 0);

function fill_mem
return ram is
variable data_memory_temp : ram;
begin
for i in 0 to 2**8-1 loop
    data_memory_temp(i) := STD_LOGIC_VECTOR(to_unsigned(i,32));
end loop;
return data_memory_temp;
end function fill_mem;

signal data_memory : ram := fill_mem;

begin

process(clock)
begin
if rising_edge(clock) then    	
   if wr = '1' then
	   data_memory(to_integer(unsigned(addr))) <= data_in;  
      data_out <= data_memory(to_integer(unsigned(addr))); 
	elsif rd = '1' then
	   data_out <= data_memory(to_integer(unsigned(addr))); 
	else
	   data_out <= data_memory(to_integer(unsigned(addr))); 
	end if;	
end if;
end process;

process(clock,reset)
begin
if reset = '1' then 
   data_ready <= '0';
elsif rising_edge(clock) then
	if wr = '1' then
		data_ready <= '1'; -- DATA IS WRITTEN, ACKNOWLDGE THE PROCESSOR
	elsif rd = '1' then
		data_ready <= '1'; -- DATA CAN BE READ, ACKNOWLEDGE THE PROCESSOR
	else
		data_ready <= '0';
	end if;
end if;
end process;

end Behavioral;

