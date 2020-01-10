library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity CacheController_tb is
end;

architecture bench of CacheController_tb is

  component CacheController 
  	port (
  	clk, readmem, writemem : in std_logic;
  	address: in std_logic_vector (15 downto 0);
  	data : inout std_logic_vector (15 downto 0);
  	memdataready : out std_logic
  	);
  end component;

  signal clk, readmem, writemem: std_logic;
  signal address: std_logic_vector (15 downto 0);
  signal data: std_logic_vector (15 downto 0);
  signal memdataready: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: CacheController port map ( clk          => clk,
                                  readmem      => readmem,
                                  writemem     => writemem,
                                  address      => address,
                                  data         => data,
                                  memdataready => memdataready );

  stimulus: process
  begin
  
	address <= "0000000000000001";
	data <= "0000000000000101";
	readmem <= '0';
	writemem <= '1';
    
    wait for 10 ns;
    readmem <= '0';
	writemem <= '0';
	wait for 30 ns;
    
    address <= "0000000000000000";
    readmem <= '1';
	writemem <= '0';
	
	wait for 15 ns;
    readmem <= '0';
	writemem <= '0';
	wait for 30 ns;
	
	address <= "0000000000000001";
    readmem <= '1';
	writemem <= '0';
	
	wait for 15 ns;
    readmem <= '0';
	writemem <= '0';
	wait for 30 ns;
	
	address <= "0000000000000001";
	data <= "0000000000000111";
    readmem <= '0';
	writemem <= '1';
	
	wait for 15 ns;
    readmem <= '0';
	writemem <= '0';
	wait for 30 ns;
	
	address <= "0000000000000001";
    readmem <= '1';
	writemem <= '0';
	
	wait for 15 ns;
    readmem <= '0';
	writemem <= '0';
	wait for 30 ns;
	
	address <= "0000000000000011";
    readmem <= '1';
	writemem <= '0';
	
	wait for 15 ns;
    readmem <= '0';
	writemem <= '0';
	wait for 30 ns;
	
	address <= "0000000000000011";
	data <= "0000000000001001";
    readmem <= '0';
	writemem <= '1';

    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
