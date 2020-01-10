library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cache_Memory is
    Port ( clock  		 : in STD_LOGIC;
			  refill 		 : in STD_LOGIC; -- MISS, REFILL CACHE USING DATA FROM MEMORY
			  update 		 : in STD_LOGIC; -- HIT, UPDATE CACHE USING DATA FROM PROCESSOR
			  index         : in STD_LOGIC_VECTOR (3 downto 0);      
			  offset 		 : in STD_LOGIC_VECTOR (1 downto 0);
			  data_from_mem : in STD_LOGIC_VECTOR (127 downto 0);    
			  write_data    : in STD_LOGIC_VECTOR (31 downto 0); 
			  read_data     : out STD_LOGIC_VECTOR(31 downto 0)); 			  
end Cache_Memory;

architecture Behavioral of Cache_Memory is

type ram is array (0 to 2**6-1) of STD_LOGIC_VECTOR (31 downto 0);


signal cache_memory : ram := (OTHERS => (OTHERS =>'0'));

begin

process(clock)

variable v0 : STD_LOGIC_VECTOR (4+2-1 downto 0);
variable v1 : STD_LOGIC_VECTOR (4+2-1 downto 0);
variable v2 : STD_LOGIC_VECTOR (4+2-1 downto 0);
variable v3 : STD_LOGIC_VECTOR (4+2-1 downto 0);
variable v4 : STD_LOGIC_VECTOR (4+2-1 downto 0);

begin
if rising_edge(clock) then   
   v0 := index & offset; 
   v1 := index & "00";
	v2 := index & "01";
	v3 := index & "10";
	v4 := index & "11";	
   if update = '1' then    -- HIT, UPDATE CACHE BLOCK USING WORD FROM PROCESSOR	
	   cache_memory(to_integer(unsigned(v0))) <= write_data; 
	elsif refill = '1' then -- MISS, REFILL CACHE BLOCK USING DATA BLOCK FROM MEMORY		   
	   cache_memory(to_integer(unsigned(v1))) <= data_from_mem(127 downto 96);
		cache_memory(to_integer(unsigned(v2))) <= data_from_mem(95 downto 64);
		cache_memory(to_integer(unsigned(v3))) <= data_from_mem(63 downto 32);
		cache_memory(to_integer(unsigned(v4))) <= data_from_mem(31 downto 0);
	end if;	
	read_data <= cache_memory(to_integer(unsigned(v0))); -- READ WORD FROM CACHE
	
end if;
end process;

end Behavioral;

