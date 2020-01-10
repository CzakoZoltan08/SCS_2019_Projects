library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    Port (
            clock   : in STD_LOGIC;
            btn   : in STD_LOGIC_VECTOR(4 downto 0);
            sw    : in STD_LOGIC_VECTOR(15 downto 0);
            led   : out STD_LOGIC_VECTOR(15 downto 0);
            cat   : out std_logic_vector(6 downto 0);
            an    : out STD_LOGIC_VECTOR(3 downto 0)
         );
end TOP;

architecture Behavioral of TOP is

component Mono_Pulse_Generator is
    Port(
            clk    : in STD_LOGIC;
            btn    : in STD_LOGIC;
            enable : out STD_LOGIC
        );
end component;

signal en : STD_LOGIC;
signal reset : STD_LOGIC;

component SSD is
    Port ( 
            clk : IN std_logic;
            cat: OUT std_logic_vector(6 downto 0);
            an : OUT STD_LOGIC_VECTOR(3 downto 0);
            Digit0 : IN STD_LOGIC_VECTOR(3 downto 0);
            Digit1 : IN STD_LOGIC_VECTOR(3 downto 0);
            Digit2 : IN STD_LOGIC_VECTOR(3 downto 0);
            Digit3 : IN STD_LOGIC_VECTOR(3 downto 0)
         );
end component;

signal afisare_ssd : STD_LOGIC_VECTOR(15 downto 0);
signal afisare_ssd_32 : STD_LOGIC_VECTOR(31 downto 0);


component Main_Memory is
 Port(
           clock       : in  STD_LOGIC;  
		   reset 	  : in STD_LOGIC;    
           rd         : in  STD_LOGIC; 
           wr         : in STD_LOGIC;			  
           addr       : in  STD_LOGIC_VECTOR (9 downto 0); 
           data_in    : in  STD_LOGIC_VECTOR (31  downto 0);
           data_out   : out  STD_LOGIC_VECTOR (127  downto 0); 
           data_ready : out  STD_LOGIC 
        ); 
end component;
     
signal addr       : STD_LOGIC_VECTOR (9 downto 0);
signal data_in    : STD_LOGIC_VECTOR (31  downto 0); 
signal data_out   : STD_LOGIC_VECTOR (127  downto 0); 
signal data_ready,code : STD_LOGIC;

component Cache_Memory is
    Port ( 
          clock  		 : in STD_LOGIC;  
          refill 		 : in STD_LOGIC; 
          update 		 : in STD_LOGIC;
          index          : in STD_LOGIC_VECTOR (3 downto 0); 
          offset 		 : in STD_LOGIC_VECTOR (1 downto 0);
          data_from_mem  : in STD_LOGIC_VECTOR (127 downto 0); 
          write_data     : in STD_LOGIC_VECTOR (31 downto 0); 
          read_data      : out STD_LOGIC_VECTOR(31 downto 0)
          );	
end component;

signal refill_cache  : STD_LOGIC; 
signal update_cache  : STD_LOGIC;
signal write_data    : STD_LOGIC_VECTOR (31 downto 0); 
signal read_data     : STD_LOGIC_VECTOR(31 downto 0);

component Cache_Controller is
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
end component;

signal flush         : STD_LOGIC;
signal stall         : STD_LOGIC;
signal read_from_mem : STD_LOGIC;
signal write_to_mem  : STD_LOGIC;
signal write         : STD_LOGIC;
signal read          : STD_LOGIC;
signal data_in_bus   : STD_LOGIC_VECTOR(31 downto 0);

begin

top_0: Mono_Pulse_Generator Port Map 
                                (
                                    clk => clock,
                                    btn => btn (0),
                                    enable => en
                                 );
                                    
top_1: Cache_Controller Port Map 
                            (
                                clock => clock,
                                code => code,
                                reset => reset,
                                enable => en,
                                tag => addr (9 downto 6),
                                index => addr (5 downto 2),
                                read => read,
                                write => write,
                                ready => data_ready,
                                flush => flush,
                                stall => stall,
                                refill => refill_cache,
                                update => update_cache,
                                read_from_mem => read_from_mem,
                                write_to_mem => write_to_mem
                              );
                              
top_2: Main_Memory Port Map 
                        (
                            clock => clock,
                            reset => reset,
                            rd => read_from_mem,
                            wr => write_to_mem,
                            addr => addr,
                            data_in => data_in_bus,
                            data_out => data_out,
                            data_ready => data_ready
                         );
                       
top_3: Cache_Memory Port Map (
                                clock  => clock,
                                refill => refill_cache,
                                update => update_cache,
                                index  => addr (5 downto 2),
                                offset => addr (1 downto 0),
                                data_from_mem => data_out,
                                write_data => data_in_bus,
                                read_data => read_data
                              ); 

top_4 : SSD Port Map (
                      clk => clock,
                      cat => cat,
                      an => an,
                      Digit0 => afisare_ssd(3 downto 0),
                      Digit1 => afisare_ssd(7 downto 4),
                      Digit2 => afisare_ssd(11 downto 8),
                      Digit3 => afisare_ssd(15 downto 12)
                      );
                                            
afisare_ssd_32 <= read_data; 

afisare_ssd<= afisare_ssd_32(31 downto 16) when sw(15)='1'
else afisare_ssd_32(15 downto 0);

led(0) <= stall;
led(1) <= en;
led(2) <= update_cache;
led(3) <= refill_cache;
led(4) <= read_from_mem;
led(5) <= write_to_mem;
led(6) <= data_ready;


reset <= sw(0);
read <= sw(1);
write <= sw(2);
flush <= sw(3);
code <= sw(4);

addr <= sw(14 downto 5);
data_in_bus <= x"7777ffff";

                              
end Behavioral;
