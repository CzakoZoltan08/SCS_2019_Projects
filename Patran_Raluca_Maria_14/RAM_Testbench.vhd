library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAM_Testbench is
end RAM_Testbench;

architecture Behavioral of RAM_Testbench is

component RAM is
  Port ( 
           clock           : in STD_LOGIC;        
           reset         : in STD_LOGIC;    
           read          : in  STD_LOGIC;  
           write         : in STD_LOGIC;	 	  
           input_address : in  STD_LOGIC_VECTOR (7 downto 0);
           data_in       : in  STD_LOGIC_VECTOR (31  downto 0); 
           data_out      : out  STD_LOGIC_VECTOR (31  downto 0);
           data_ready    : out  STD_LOGIC
         );
end component;

signal clock : STD_LOGIC;       
signal reset : STD_LOGIC :='0';    
signal read  : STD_LOGIC := '0';    
signal write : STD_LOGIC := '0' ;	   
signal input_address : STD_LOGIC_VECTOR (7 downto 0); 
signal data_in : STD_LOGIC_VECTOR (31  downto 0); 
signal data_out : STD_LOGIC_VECTOR (31  downto 0); 
signal data_ready : STD_LOGIC;

begin

UUT: RAM PORT MAP (clock => clock,
                   reset => reset,
                   read => read,
                   write => write,
                   input_address => input_address,
                   data_in => data_in,
                   data_out => data_out,
                   data_ready => data_ready
                   );
clk: process 
 begin
 
 clock <= '0';
 wait for 10 ns;
 
 clock <= '1';
 wait for 10 ns;

end process;               

process
begin

write <= '1';

wait for 10 ns;

input_address <= "00010010";
data_in <= "00000000000000000000000000010010";

wait for 30 ns;

write <='0';
read <='1';

wait for 20 ns;

read <='0';
wait for 10 ns;

input_address <= "01010010";
data_in <= "00000000000000000000000000000001";

wait for 20 ns;

read <= '1';

wait for 30 ns;
reset <= '1';

wait;
end process;
end Behavioral;
