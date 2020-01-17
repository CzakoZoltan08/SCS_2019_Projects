----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2019 20:49:24
-- Design Name: 
-- Module Name: Top_Level - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_Level is
 Port ( clk : in std_logic;
        btn : in STD_LOGIC_VECTOR (4 downto 0);
        sw : in STD_LOGIC_VECTOR (15 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0);
        an : out STD_LOGIC_VECTOR (3 downto 0);
        cat : out STD_LOGIC_VECTOR (6 downto 0));
end Top_Level;

architecture Behavioral of Top_Level is

component ssd
Port ( clk : in STD_LOGIC;
           s1 : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Debouncer_BTN
Port(
    clk:in STD_LOGIC;
    btn:in STD_LOGIC;
    Enable:out STD_LOGIC);
end component;

component InputReg
 Port ( clk : in std_logic;
         inputSelection : in std_logic;
         enable : in std_logic;
         input : in std_logic_vector(3 downto 0);
         output : out std_logic_vector(3 downto 0));
end component;

component booth_multiplier
GENERIC (x : INTEGER := 4;
		 y : INTEGER := 4);
PORT(clk : IN STD_LOGIC;
	 m : IN STD_LOGIC_VECTOR(x - 1 DOWNTO 0);
	 r : IN STD_LOGIC_VECTOR(y - 1 DOWNTO 0);
	 result : OUT STD_LOGIC_VECTOR(x + y - 1 DOWNTO 0));
end component;

component Adder
Port ( A : in STD_LOGIC;
       B : in STD_LOGIC;
       Cin : in STD_LOGIC;
       S : out STD_LOGIC;
       Cout : out STD_LOGIC);
end component;

component Adder_8Bits
Port (Cin		:	In	Std_logic;
	  x : in std_logic_vector(7 downto 0);
	  y : in std_logic_vector(7 downto 0);
	  r : out std_logic_vector(7 downto 0);
	  Cout		:	Out	Std_logic
	);
end component;

signal digita : std_logic_vector(3 downto 0);
signal digitb : std_logic_vector(3 downto 0);
signal digitc : std_logic_vector(3 downto 0);
signal digit_4 : std_logic_vector(3 downto 0);

signal digita_8 : std_logic_vector(7 downto 0);
signal digitb_8 : std_logic_vector(7 downto 0);
signal digitc_8 : std_logic_vector(7 downto 0);
signal digit_8 : std_logic_vector(7 downto 0) := "00000000";
signal digitab_8 : std_logic_vector(7 downto 0);

signal digit2 : std_logic_vector(15 downto 0);

signal filteredSignal : std_logic_vector(7 downto 0);

signal overflow : std_logic := '0';
signal Cin :std_logic;

signal enable : std_logic;
signal showResult : std_logic;
signal inputSelection : std_logic;

signal reset : std_logic;

begin

BTN0 : Debouncer_BTN port map (clk => clk,
                               btn => btn(0),
                               Enable => enable);
                               
BTN1 : Debouncer_BTN port map (clk => clk,
                               btn => btn(1),
                               Enable => showResult);

BTN3 : Debouncer_BTN port map (clk => clk,
                               btn => btn(2),
                               Enable => reset);


process(sw(12), clk)
begin 
    if ( sw(12) = '0' ) then
        digit2 <= "000000000000" & digit_4;
    else if ( sw(12) = '1' ) then 
            digit2 <= "00000000" & digit_8;
         end if;
    end if;
end process;
SSD1: ssd port map (clk => clk,
                    s1 =>  digit2,
                    cat => cat,
                    an => an);
                    
SIGNAL_1: InputReg port map (clk => clk,
                             inputSelection => sw(15),
                             enable => enable, 
                             input => sw(3 downto 0),
                             output => digita);
                             
SIGNAL_2: InputReg port map (clk => clk,
                             inputSelection => sw(14),
                             enable => enable, 
                             input => sw(3 downto 0),
                             output => digitb);
                             
SIGNAL_3: InputReg port map (clk => clk,
                             inputSelection => sw(13),
                             enable => enable, 
                             input => sw(3 downto 0),
                             output => digitc);
                             
MULTIPLIER_1: booth_multiplier generic map ( x  => 4,
                                             y  => 4 )
                               port map ( clk    => clk,
                                          m      => digita,
                                          r      => "0001",
                                          result => digita_8);
                                          
MULTIPLIER_2: booth_multiplier generic map ( x  => 4,
                                             y  => 4 )
                               port map ( clk    => clk,
                                          m      => digitb,
                                          r      => "0010",
                                          result => digitb_8);
                                          
MULTIPLIER_3: booth_multiplier generic map ( x  => 4,
                                             y  => 4 )
                               port map ( clk    => clk,
                                          m      => digitc,
                                          r      => "0011",
                                          result => digitc_8);
                                          
ADDITION_1: Adder_8Bits port map (Cin => '0',
	                              x => digita_8,
	                              y => digitb_8,
	                              r => digitab_8,
	                              Cout => Cin);
	                           
ADDITION_2: Adder_8Bits port map (Cin => Cin,
	                              x => digitab_8,
	                              y => digitc_8,
	                              r => filteredSignal,
	                              Cout => overflow);
                                          

process(clk)
begin
    if (sw(15) = '1' and sw(14) = '0' and sw(13) = '0') then digit_4 <= digita; end if;
    if (sw(15) = '0' and sw(14) = '1' and sw(13) = '0') then digit_4 <= digitb; end if;
    if (sw(15) = '0' and sw(14) = '0' and sw(13) = '1') then digit_4 <= digitc; end if;
end process;

--process(clk)
--begin
    --if (sw(15) = '1' and sw(14) = '0' and sw(13) = '0') then digit_8 <= digita_8; end if;
    --if (sw(15) = '0' and sw(14) = '1' and sw(13) = '0') then digit_8 <= digitb_8; end if;
    --if (sw(15) = '0' and sw(14) = '0' and sw(13) = '1') then digit_8 <= digitc_8; end if;
--end process;

process(showResult)
begin
    if (overflow = '1') then
        digit_8 <= "00000001";
    end if;
    digit_8 <= filteredSignal;
end process;


end Behavioral;
