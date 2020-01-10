library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top2 is
	 Port ( 
	          clock : in STD_LOGIC; 
			  reset : in STD_LOGIC; 
			  addr  : in STD_LOGIC_VECTOR (31 downto 0);  
			  rdata : out STD_LOGIC_VECTOR (31 downto 0); 
			  wdata : in STD_LOGIC_VECTOR (31 downto 0);  
			  flush : in STD_LOGIC; 
			  rd    : in STD_LOGIC; 
			  wr    : in STD_LOGIC; 
			  stall : out STD_LOGIC; 
			  ready_top : out STD_LOGIC			  
			);
end Top2;

architecture Behavioral of Top2 is

signal addr_local : STD_LOGIC_VECTOR (9 downto 0); 
signal ready_inter  : STD_LOGIC;
signal data_from_mem_inter : STD_LOGIC_VECTOR (127 downto 0);  
signal rd_inter_mem : STD_LOGIC;
signal wr_inter_mem : STD_LOGIC;
signal refill_inter : STD_LOGIC;
signal update_inter : STD_LOGIC;

component Cache_Controller2
    Port ( clock			 : in STD_LOGIC; 
			  reset			 : in STD_LOGIC; 
			  flush			 : in STD_LOGIC; 
			  rd   			 : in STD_LOGIC; 
			  wr   			 : in STD_LOGIC; 
			  index			 : in STD_LOGIC_VECTOR (4-1 downto 0); 
			  tag  			 : in STD_LOGIC_VECTOR (4-1 downto 0);   
			  ready			 : in STD_LOGIC;     
			  refill			 : out STD_LOGIC;    
			  update			 : out STD_LOGIC;    
			  read_from_mem : out STD_LOGIC;    
			  write_to_mem  : out STD_LOGIC;    
			  stall 			 : out STD_LOGIC);		
END component;

component Cache_Memory
    Port ( clock  		 : in STD_LOGIC;      
			  refill 		 : in STD_LOGIC; 
			  update 		 : in STD_LOGIC; 
			  index         : in STD_LOGIC_VECTOR (4-1 downto 0);      
			  offset 		 : in STD_LOGIC_VECTOR (2-1 downto 0);     
			  data_from_mem : in STD_LOGIC_VECTOR (128-1 downto 0);      
			  write_data    : in STD_LOGIC_VECTOR (32-1 downto 0);  
			  read_data     : out STD_LOGIC_VECTOR(32-1 downto 0)); 	
end component;

component Main_Memory
    Port ( clock      : in  STD_LOGIC;   
		   reset      : in STD_LOGIC;    
           rd         : in  STD_LOGIC;   
           wr         : in STD_LOGIC;	    
           addr       : in  STD_LOGIC_VECTOR (10-1 downto 0); 
           data_in    : in  STD_LOGIC_VECTOR (32-1  downto 0); 
           data_out   : out  STD_LOGIC_VECTOR (128-1  downto 0); 
           data_ready : out  STD_LOGIC); 
end component;

begin

addr_local <= addr(10-1 downto 0);

Inst_Cache_Controller: Cache_Controller2 PORT MAP(
		clock => clock,
		reset => reset,
		flush => flush,
		rd => rd,
		wr => wr,
		index => addr_local(5 downto 1+1),
		tag   => addr_local(9 downto 5+1),
		ready => ready_inter,
		refill => refill_inter,
		update => update_inter,
		read_from_mem => rd_inter_mem,
		write_to_mem  => wr_inter_mem,
		stall => stall
	);

Inst_Cache_Memory_Data_Array: Cache_Memory PORT MAP(
		clock  => clock,
		refill => refill_inter,
		update => update_inter,
		index  => addr_local(5 downto 1+1),
		offset => addr_local(1 downto 0),
		data_from_mem => data_from_mem_inter ,
		write_data => wdata,
		read_data  => rdata
	);

Inst_Main_Memory_System: Main_Memory PORT MAP(
		clock => clock,
		reset => reset,
		rd    => rd_inter_mem,
		wr    => wr_inter_mem,
		addr  => addr_local,
		data_in  => wdata,
		data_out => data_from_mem_inter ,
		data_ready => ready_inter
	);
	
ready_top <= ready_inter;


end Behavioral;

