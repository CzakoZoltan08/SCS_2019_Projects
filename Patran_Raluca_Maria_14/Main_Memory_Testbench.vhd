library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Main_Memory_Testbench is
end Main_Memory_Testbench;

architecture Behavioral of Main_Memory_Testbench is

component Main_Memory is
 Port(
           clk        : in  STD_LOGIC;  
		   reset 	  : in STD_LOGIC;    
           rd         : in  STD_LOGIC; 
           wr         : in STD_LOGIC;			  
           addr       : in  STD_LOGIC_VECTOR (9 downto 0); 
           data_in    : in  STD_LOGIC_VECTOR (31  downto 0);
           data_out   : out  STD_LOGIC_VECTOR (127  downto 0); 
           data_ready : out  STD_LOGIC 
        ); 
end component;

signal clk        : STD_LOGIC;  
signal reset 	  : STD_LOGIC:= '0';    
signal rd         : STD_LOGIC:='0'; 
signal wr         : STD_LOGIC:='0';	    
signal addr       : STD_LOGIC_VECTOR (9 downto 0);
signal data_in    : STD_LOGIC_VECTOR (31  downto 0); 
signal data_out   : STD_LOGIC_VECTOR (127  downto 0); 
signal data_ready : STD_LOGIC;

begin

UUT: Main_Memory Port Map (
                            clk => clk,
                            reset => reset,
                            rd => rd,
                            wr => wr,
                            addr => addr,
                            data_in => data_in,
                            data_out => data_out,
                            data_ready => data_ready
                           );

clock: process 
 begin
 
 clk <= '0';
 wait for 10 ns;
 
 clk <= '1';
 wait for 10 ns;
end process;  
 
 process
    begin
        addr <= "0011001010";
        data_in <= "00101001100011011010000011101001";
        
        wait for 30 ns;
        
        wr <= '1';
        
        wait for 30 ns;
        
        reset <= '1';
        wr <= '0';
        
        wait for 20 ns;
        
        reset <= '0';
        
        rd <= '1';
        
        addr <= "0011100101";
        
        wait for 30 ns;
        
        addr <= "0011001010";
        
 wait;
 end process;
end Behavioral;
