Library IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
  
entity Top2_Testbench is
end Top2_Testbench;
 
ARCHITECTURE behavior OF Top2_Testbench IS 

    COMPONENT Top2
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         addr : IN  std_logic_vector(31 downto 0);
         rdata : OUT  std_logic_vector(31 downto 0);
         wdata : IN  std_logic_vector(31 downto 0);
         flush : IN  std_logic;
         rd : IN  std_logic;
         wr : IN  std_logic;
         stall : OUT  std_logic;
         ready_top : OUT std_logic
        );
    END COMPONENT;
    
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal addr : std_logic_vector(31 downto 0) := (others => '0');
   signal wdata : std_logic_vector(31 downto 0) := (others => '0');
   signal flush : std_logic := '0';
   signal rd : std_logic := '0';
   signal wr : std_logic := '0';
   signal ready_top : std_logic;
 
   signal rdata : std_logic_vector(31 downto 0);
   signal stall : std_logic;

   constant clock_period : time := 10 ns; 
	
	type my_array is array (0 to 8) of STD_LOGIC_VECTOR (31 downto 0);
   signal test_data : my_array := (OTHERS => (OTHERS =>'0'));
   type my_array1 is array (0 to 8) of STD_LOGIC_VECTOR (31 downto 0);
   signal test_addr : my_array1 := (OTHERS => (OTHERS =>'0'));	
 
	
	-- reset
	procedure RESET_SYS (signal reset : out std_logic) is
	begin
	   reset <= '1';
		wait for 4*clock_period;
		reset <= '0';
	end procedure;
	
	-- MODELS A LATENCY OF 4 CYCLES UNTIL THE NEXT INSTRUCTION IS DECODED
	procedure HALT (signal wr : out std_logic;
                   signal rd : out std_logic) is
	begin
	   wait for clock_period;
	   wait until clock = '1' and stall = '0';
	   wait for 1.5*clock_period; 
	   wr <= '0';
		rd <= '0';		
	   wait for 4*clock_period;   
	end procedure;
	
	-- FINISH
	procedure FINISH is
	begin
	   wait;
	end procedure;
	
	-- FLUSH 
	procedure FLUSH_CACHE (signal flush : out std_logic) is
	begin
	   flush <= '1';
		wait for clock_period;
		flush <= '0';
	end procedure;
	
	-- WRITE 
	procedure MEM_WR (signal tb_data : in std_logic_vector(31 downto 0);
							signal tb_addr : in std_logic_vector(31 downto 0);
							signal wdata   : out std_logic_vector(31 downto 0);
							signal addr    : out std_logic_vector(31 downto 0);
							signal wr      : out std_logic;
							signal rd      : out std_logic) is
	begin
      wdata <= tb_data;
		addr  <= tb_addr;
		wr    <= '1';
		rd	   <= '0';
   end procedure;	
	
	-- READ 
	procedure MEM_RD (signal tb_addr : in std_logic_vector(31 downto 0);							
							signal addr    : out std_logic_vector(31 downto 0);
							signal wr      : out std_logic;
							signal rd      : out std_logic) is
	begin      
		addr  <= tb_addr;
		wr    <= '0';
		rd	   <= '1';
   end procedure;	
	
BEGIN
 
   uut: Top2 PORT MAP (
          clock => clock,
          reset => reset,
          addr => addr,
          rdata => rdata,
          wdata => wdata,
          flush => flush,
          rd => rd,
          wr => wr,
          stall => stall,
          ready_top => ready_top
        );
		  
	test_data(0) <= x"12345678"; -- WRITE MISS
	test_addr(0) <= x"00000201";   
	
	test_data(1) <= x"abcdef01"; -- WRITE MISS
	test_addr(1) <= x"00000201";
	
	test_addr(2) <= x"00000203"; -- READ MISS
	
	test_addr(3) <= x"00000201"; -- READ HIT
	
	test_data(4) <= x"7777ffff"; -- WRITE HIT
	test_addr(4) <= x"00000202";
	
	test_data(5) <= x"64646464"; -- WRITE MISS
	test_addr(5) <= x"00000142";
	
	test_data(6) <= x"12121212"; -- WRITE HIT
	test_addr(6) <= x"00000201";
	
	test_data(7) <= x"34343434"; -- WRITE HIT
	test_addr(7) <= x"00000203";
	
	test_addr(8) <= x"00000203"; -- READ HIT
  
   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 
  process
   begin	
	
      RESET_SYS(reset);
      FLUSH_CACHE(flush);
		
		-- RANDOM READ WRITE REQUESTS TO MEMORY BY PROCESSOR
      MEM_WR(test_data(0),test_addr(0),wdata,addr,wr,rd);		
		HALT(wr,rd);
		
		MEM_WR(test_data(1),test_addr(1),wdata,addr,wr,rd);
		HALT(wr,rd);
		
		MEM_RD(test_addr(2),addr,wr,rd);
		HALT(wr,rd);
		
		MEM_RD(test_addr(3),addr,wr,rd);	
		HALT(wr,rd);
		
		MEM_WR(test_data(4),test_addr(4),wdata,addr,wr,rd);	
		HALT(wr,rd);
		
	   MEM_WR(test_data(5),test_addr(5),wdata,addr,wr,rd);	
		HALT(wr,rd);	
		
		MEM_WR(test_data(6),test_addr(6),wdata,addr,wr,rd);	
		HALT(wr,rd);
		
		MEM_WR(test_data(7),test_addr(7),wdata,addr,wr,rd);	
		HALT(wr,rd);
		
		MEM_RD(test_addr(8),addr,wr,rd);	
		HALT(wr,rd);
	
		
		-- FLUSH AND CHECK DATA VALIDITY
      FLUSH_CACHE(flush);
		MEM_RD(test_addr(8),addr,wr,rd);	
		HALT(wr,rd);
		
      FINISH;
		
   end process;

END;
