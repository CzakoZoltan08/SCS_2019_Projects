library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity displ_7seg is
	port ( clk, rst : in std_logic;
		    data_16 : in std_logic_vector (15 downto 0);
		    data_8: in std_logic_vector(11 downto 0);
		    sseg : out std_logic_vector (6 downto 0);
		    an : out std_logic_vector (7 downto 0));
end displ_7seg;

architecture Behavioral of displ_7seg is
	component hex2sseg is
    	port ( hex : in std_logic_vector (3 downto 0);
           	 sseg : out std_logic_vector (6 downto 0));
	end component hex2sseg;
	
	signal ledsel : std_logic_vector (2 downto 0);
	signal cntdiv : std_logic_vector (10 downto 0);
	signal segdata : std_logic_vector (3 downto 0);
	
begin
	process (clk, rst)
	begin
		if rst = '1' then
			cntdiv <= (others => '0');
		elsif (clk'event and clk = '1') then
			cntdiv <= cntdiv + 1;
		end if;
	end process;
	
	ledsel <= cntdiv(10 downto 8);
	
	an <=  "11111110" when ledsel = "000" else
		   "11111101" when ledsel = "001" else
		   "11111011" when ledsel = "010" else
		   "11110111" when ledsel = "011" else
		   "11101111" when ledsel = "100" else
		   "11011111" when ledsel = "101" else
		   "10111111" when ledsel = "110" else
		   "01111111" when ledsel = "111";
			
	segdata <=  data_8 (3 downto 0)   when ledsel = "000" else
		        data_8 (7 downto 4)   when ledsel = "001" else
		        data_8 (11 downto 8)  when ledsel = "010" else     
		        "1110"                when ledsel = "011" else
	            data_16 (3 downto 0)   when ledsel = "100" else
		        data_16 (7 downto 4)   when ledsel = "101" else
		        data_16 (11 downto 8)  when ledsel = "110" else
		        data_16 (15 downto 12) when ledsel = "111";
				  
	hex2sseg_u: hex2sseg
		port map (hex => segdata, sseg => sseg);
		
end Behavioral;
