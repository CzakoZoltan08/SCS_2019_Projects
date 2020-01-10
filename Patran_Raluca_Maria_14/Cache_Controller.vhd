library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Cache_Controller is
    Port 
        (
            clock         : in STD_LOGIC;
            code          : in STD_LOGIC;
            reset         : in STD_LOGIC;
            enable        : in STD_LOGIC;
            tag           : in STD_LOGIC_VECTOR(3 downto 0);
            index         : in STD_LOGIC_VECTOR(3 downto 0);
            read          : in STD_LOGIC;
            write         : in STD_LOGIC;
            ready         : in STD_LOGIC;
            flush         : in STD_LOGIC;
            stall         : out STD_LOGIC;
            refill        : out STD_LOGIC;
            update        : out STD_LOGIC;
            read_from_mem : out STD_LOGIC;
            write_to_mem  : out STD_LOGIC
         );
end Cache_Controller;

architecture Behavioral of Cache_Controller is

type MOORE_FSM is (Idle, Write_Miss_Hit, Read_Miss, Refill_State, Stall_State, Wait_State);
signal current_state, next_state: MOORE_FSM;
signal hit : STD_LOGIC;
signal miss : STD_LOGIC;
type ram is array (0 to 2**3) of STD_LOGIC_VECTOR (4 downto 0);
signal tag_array : ram := (OTHERS => (OTHERS =>'0'));
signal write_temp, read_temp : STD_LOGIC;

begin

write_temp <= write;
read_temp <= read;

process(clock,reset)
begin
 if(reset='1') then
  current_state <= Idle;
 elsif(rising_edge(clock)) then
    if(enable = '1') then
  current_state <= next_state;
  end if;
 end if;
end process;

process(current_state, code, read_temp, write_temp)
begin
case(current_state) is
when Idle => 
    if code = '0' then 
    next_state <= Write_Miss_Hit;
    else next_state <= Read_Miss;
    end if;
when Write_Miss_Hit => next_state <= Wait_State;
when Read_Miss => next_state <= Refill_State;
when Refill_State => next_state <= Stall_State;
when Stall_State => next_state <= Wait_State;
when Wait_State => 
    if write_temp = '0' and read_temp = '0' then 
next_state <= Idle;
end if;
end case;
end process;

process(current_state,tag_array,read,write,ready)

variable temp_tag   : STD_LOGIC_VECTOR (4 downto 0);
variable temp_index : integer;

begin
	   
	       case (current_state) is
                           
	           when Idle =>
	           hit   <= '0';
                            miss  <= '0';
                            tag_array <= (OTHERS => (OTHERS =>'0'));
                            
                            -- out port 
                            stall <= '0';
                            read_from_mem <= '0';
                            write_to_mem  <= '0';
                            refill <= '0';
                            update <= '0';
	                       temp_tag   := '1' & tag; -- for valid bit
						   temp_index := to_integer(unsigned(index));
						   
						   if ((temp_tag XOR tag_array(temp_index)) = "00000") then 
							    if write = '1' then  -- if write + hit     								 
									 hit   <= '1';        
									 miss  <= '0';
									 
									 stall <= '1';		    
									 update <= '1';       
								     refill <= '0';
							         write_to_mem <= '1'; 
								     read_from_mem <= '0';
     
	                        elsif read = '1' then 
									 hit  <= '1';
									 miss <= '0' ;
                            else 
									 HIT  <= '0';     
									 MISS <= '0';
						        end if;
							elsif write = '1' then 
                                     hit   <= '0';    
                                     miss  <= '1';
                                         	  
                                     stall <= '1';			  
                                     update <= '0';  		  
                                     refill <= '0';
                                     write_to_mem <= '1';  
                                     read_from_mem <= '0';
                                     
							 elsif read = '1' then 
                                     HIT    <= '0';    
                                     MISS   <= '1';   
                                          
                                     stall  <= '1';		  
                                     update <= '0';   
                                     refill <= '0';   
                                     write_to_mem <= '0';
                                     read_from_mem <= '1'; 
                                     
							 else 
                                     hit  <= '0';     
                                     miss <= '0';
							 end if;
							 
				when Write_Miss_Hit  => 
							         update <= '0';        
                                     refill <= '0';
                                     
                                     if ready = '1' then    
                                     stall <= '0';       
                                     write_to_mem  <= '0';
                                     read_from_mem <= '0';
                                     
                                     
                                     end if; 
                when Read_Miss => 
                                 if ready = '1' then
								 read_from_mem <= '0';
								 write_to_mem  <= '0';
								 refill <= '1';      
								 update <= '0';
								
								 end if;
	           
	           when Refill_State => 
	                             refill <= '0';
                                 update <= '0';							 
                                 temp_index := to_integer(unsigned(index)); 
                                 tag_array(temp_index) <= '1' & tag; 
                               
               
               when Stall_State => 
                                 stall <= '0';
							    
			   when Wait_State =>
                                 hit   <= '0';
                                 miss   <= '0';
                                 stall  <= '0';
                                 refill <= '0';
                                 update <= '0';
                                 read_from_mem <= '0';
                                 write_to_mem  <= '0';
        end case;    
                                    
end process;
end Behavioral;
