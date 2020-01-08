library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity MPG is
 Port ( clk : in STD_LOGIC;         
btn : in STD_LOGIC;           
en : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal counts: std_logic_vector(15 downto 0) := "0000000000000000";
signal Q1, Q2, Q3: std_logic :='0';

begin

process (clk)
begin  
if (clk='1' and clk'event) then     
counts <= counts + 1;  		 
end if;
end process;

process (clk)
begin   
if (clk'event and clk='1')then
	if(counts = x"FFFF") then    
Q1 <= btn;    
end if;
end if;
end process;

process (clk)
begin  
if (clk'event and clk='1') then       
Q2<=Q1;        
Q3<=Q2;      
end if;
end process;

en<=(not Q3) and Q2; 

end Behavioral;
