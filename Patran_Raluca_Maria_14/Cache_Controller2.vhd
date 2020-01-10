library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cache_Controller2 is

	 Port ( 
	          clock			 : in STD_LOGIC;   
			  reset			 : in STD_LOGIC;   
			  flush			 : in STD_LOGIC; 
			  rd   			 : in STD_LOGIC; 
			  wr   			 : in STD_LOGIC;
			  index			 : in STD_LOGIC_VECTOR (3 downto 0); 
			  tag  			 : in STD_LOGIC_VECTOR (3 downto 0);  
			  ready			 : in STD_LOGIC;  
			  refill		 : out STD_LOGIC; 
			  update		 : out STD_LOGIC; 
			  read_from_mem  : out STD_LOGIC;  
			  write_to_mem   : out STD_LOGIC; 
			  stall 		 : out STD_LOGIC); 	  
end Cache_Controller2;

architecture Behavioral of Cache_Controller2 is

signal STATE : STD_LOGIC_VECTOR (7 downto 0) := (OTHERS => '0'); 
signal HIT   : STD_LOGIC := '0'; 
signal MISS  : STD_LOGIC := '0';


type ram is array (0 to 2**4-1) of STD_LOGIC_VECTOR (4 downto 0);
signal tag_array : ram := (OTHERS => (OTHERS =>'0'));

begin

process(clock, reset)

variable temp_tag   : STD_LOGIC_VECTOR (4 downto 0);
variable temp_index : integer;

begin
if reset = '1' then
	STATE <= (OTHERS => '0'); 
	HIT   <= '0';
	MISS  <= '0';
	tag_array <= (OTHERS => (OTHERS =>'0'));
	stall <= '0';
	read_from_mem <= '0';
	write_to_mem  <= '0';
	refill <= '0';
	update <= '0';
elsif rising_edge(clock) then
   if flush = '1' then 
	   tag_array <= (OTHERS => (OTHERS => '0')); 
	else
		Case STATE is
			when x"00"  => 
								
                      temp_tag   := '1' & tag;
							 temp_index := to_integer(unsigned(index));
							 if ((temp_tag XOR tag_array(temp_index)) = "00000") then -- CHECKING IF VALID BIT = '1' AND TAGS ARE MATCHING
							    if wr = '1' then        -- IF WRITE REQUEST + HIT, UPDATE CACHE, INITIATE MEMORY WRITE									 
									 HIT   <= '1';        -- HIT OCCURED
									 MISS  <= '0';
									 stall <= '1';		    -- STALL CZ MAIN MEMORY ACCESS
									 update <= '1';       -- UPDATES CACHE
								    refill <= '0';
							       write_to_mem <= '1'; -- INITIATE WRITE TO MEMORY
								    read_from_mem <= '0';
									 STATE <= x"01";      -- GO TO WRITE HIT STATE
								 elsif rd = '1' then -- IF READ REQUEST + HIT, DO NOTHING
									 HIT  <= '1';
									 MISS <= '0';
								    STATE <= x"00";  
                         else -- IF NO REQUEST, DO NOTHING
									 HIT  <= '0';     
									 MISS <= '0';
									 STATE <= x"00";
								 end if;
							 elsif wr = '1' then -- IF WRITE REQUEST + MISS
								 HIT   <= '0';    
								 MISS  <= '1';    	  -- MISS OCCURED
								 stall <= '1';			  -- STALL CZ MAIN MEMORY ACCESS
								 update <= '0';  		  -- NO UPDATE ON CACHE
								 refill <= '0';
							    write_to_mem <= '1';  -- INITIATE WRITE TO MEMORY
								 read_from_mem <= '0';
								 STATE <= x"01";       -- GO TO WRITE MISS STATE
							 elsif rd = '1' then -- IF READ REQUEST + MISS, INITIATE REFILL CACHE
								 HIT    <= '0';    
								 MISS   <= '1';        -- MISS OCCURED
								 stall  <= '1';		  -- STALL CZ MAIN MEMORY ACCESS
								 update <= '0';   
								 refill <= '0';   
							    write_to_mem <= '0';
								 read_from_mem <= '1'; -- INITIATE READ FROM MEMORY
								 STATE <= x"02";       -- GO TO READ MISS STATE
							 else -- IF NO REQUEST, DO NOTHING
								 HIT  <= '0';     
								 MISS <= '0';
								 STATE <= x"00";
							 end if;	
         when x"01"  => -- WRITE HIT/MISS STATE
							 update <= '0';          -- STOP UPDATING CACHE
							 refill <= '0';
							 if ready = '1' then     -- IF READY, ACKNOWLEDGE THE MEMORY
							    stall <= '0';        -- SIGNAL PROCESSOR THAT NEW REQUEST CAN BE INITIATED
								 write_to_mem  <= '0';-- ACKNOWLEDGING THE MEMORY
								 read_from_mem <= '0';
								 STATE <= x"07";      -- GO TO GLOBAL WAIT STATE
							 else
								 STATE <= x"01";      -- WAIT HERE 
							 end if;		
			when x"02"	=> -- READ MISS STATE
							 if ready = '1' then
								 read_from_mem <= '0';-- ACKNOWLEDGING MEMORY
								 write_to_mem  <= '0';
								 refill <= '1';       -- INITIATE REFILLING CACHE DATA ARRAY
								 update <= '0';
								 STATE <= x"03";      -- GO TO REFILL DE-ASSERT STATE
							 else
								 STATE <= x"02";      -- WAIT HERE
							 end if;
			when x"03"  => -- REFILL DE-ASSERT STATE
							 refill <= '0';
                      update <= '0';							 
							 temp_index := to_integer(unsigned(index)); -- UPDATING CORRESPONDING TAG
							 tag_array(temp_index) <= '1' & tag; 
							 STATE  <= x"04";			 -- GO TO STALL DE-ASSERT STATE
			when x"04"	=> -- STALL DE-ASSERT STATE
							 stall <= '0';
							 STATE <= x"07";			 -- GO TO GLOBAL WAIT STATE
			when x"07"  => -- GLOBAL WAIT STATE
							 HIT    <= '0';
							 MISS   <= '0';
							 stall  <= '0';
							 refill <= '0';
							 update <= '0';
							 read_from_mem <= '0';
							 write_to_mem  <= '0';
							 if wr = '0' and rd = '0' then -- IF PROCESSOR FINISHED CURRENT REQUEST 
							    STATE <= x"00";            -- GO TO INIT STATE
							 else
							    STATE <= x"07";
							 end if;
			when OTHERS =>
							 STATE <= x"00";
		end Case;
	end if;
end if; 
end process;

end Behavioral;

