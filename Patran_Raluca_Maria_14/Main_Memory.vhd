library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Main_Memory is
    Port ( clock      : in  STD_LOGIC;  
		   reset 	   : in STD_LOGIC;    
           rd         : in  STD_LOGIC;   
           wr         : in STD_LOGIC;	  		  
           addr       : in  STD_LOGIC_VECTOR (9 downto 0);
           data_in    : in  STD_LOGIC_VECTOR (31  downto 0); 
           data_out   : out  STD_LOGIC_VECTOR (128-1  downto 0);
           data_ready : out  STD_LOGIC); 
end Main_Memory;

architecture Behavioral of Main_Memory is

signal data_out_0   : STD_LOGIC_VECTOR (32-1 downto 0);
signal data_out_1   : STD_LOGIC_VECTOR (32-1 downto 0);
signal data_out_2   : STD_LOGIC_VECTOR (32-1 downto 0);
signal data_out_3   : STD_LOGIC_VECTOR (32-1 downto 0);
signal data_ready_0 : STD_LOGIC;
signal data_ready_1 : STD_LOGIC;
signal data_ready_2 : STD_LOGIC;
signal data_ready_3 : STD_LOGIC;
signal wr_demux     : STD_LOGIC_VECTOR (4-1 downto 0) ; 
COMPONENT RAM
	PORT(
		clock 		: IN STD_LOGIC;
      reset		   : IN STD_LOGIC;
		rd 			: IN STD_LOGIC;
		wr 			: IN STD_LOGIC;
		addr 			: IN STD_LOGIC_VECTOR (7 downto 0);
		data_in 		: IN STD_LOGIC_VECTOR (31 downto 0);          
		data_out 	: OUT STD_LOGIC_VECTOR (31 downto 0);
		data_ready  : OUT STD_LOGIC
		);
END COMPONENT;

begin

-- FOUR MEMORY BANKS
Memory_Bank_0 : RAM PORT MAP(
		clock => clock,
		reset => reset,
		rd => rd,
		wr => wr_demux(3),
		addr => addr(9 downto 2), 
		data_in => data_in,
		data_out => data_out_0,
		data_ready => data_ready_0
	);
RAM_1 :RAM PORT MAP(
		clock => clock,
		reset => reset,
		rd => rd,
		wr => wr_demux(2),
		addr => addr(9 downto 2),
		data_in => data_in,
		data_out => data_out_1,
		data_ready => data_ready_1
	);
RAM_2 :RAM PORT MAP(
		clock => clock,
		reset => reset,
		rd => rd,
		wr => wr_demux(1),
		addr => addr(9 downto 2),
		data_in => data_in,
		data_out => data_out_2,
		data_ready => data_ready_2
	);
RAM_3 :RAM PORT MAP(
		clock => clock,
		reset => reset,
		rd => rd,
		wr => wr_demux(0),
		addr => addr(9 downto 2),
		data_in => data_in,
		data_out => data_out_3,
		data_ready => data_ready_3
	);

process(wr,addr(2-1 downto 0))
begin
if addr(2-1 downto 0) = "00" then
	wr_demux(3) <= wr;
	wr_demux(2) <= '0';
	wr_demux(1) <= '0';
	wr_demux(0) <= '0';
elsif addr(2-1 downto 0) = "01" then
	wr_demux(3) <= '0';
	wr_demux(2) <= wr;
	wr_demux(1) <= '0';
	wr_demux(0) <= '0';
elsif addr(2-1 downto 0) = "10" then
	wr_demux(3) <= '0';
	wr_demux(2) <= '0';
	wr_demux(1) <= wr;
	wr_demux(0) <= '0';
else
	wr_demux(3) <= '0';
	wr_demux(2) <= '0';
	wr_demux(1) <= '0';
	wr_demux(0) <= wr;
end if;
end process;

data_out <= data_out_0 & data_out_1 & data_out_2 & data_out_3; 
data_ready <= data_ready_0 OR data_ready_1 OR data_ready_2 OR data_ready_3;

end Behavioral;

