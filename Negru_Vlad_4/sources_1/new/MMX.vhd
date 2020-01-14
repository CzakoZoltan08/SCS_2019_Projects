----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2019 11:13:56 PM
-- Design Name: 
-- Module Name: MMX - Behavioral
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

entity MMX is
  Port (  clk : in STD_LOGIC;
       btn : in STD_LOGIC_VECTOR (4 downto 0);
       sw : in STD_LOGIC_VECTOR (15 downto 0);
       led : out STD_LOGIC_VECTOR (15 downto 0);
       an : out STD_LOGIC_VECTOR (3 downto 0);
       cat : out STD_LOGIC_VECTOR (6 downto 0)
      
     
   );
end MMX;

architecture Behavioral of MMX is
component MMXMemory is
 Port (
    dest:in std_logic_vector(2 downto 0);
    op1: in std_logic_vector(2 downto 0);
    op2:in std_logic_vector(2 downto 0);
    AOut:out std_logic_vector(31 downto 0);
    BOut:out std_logic_vector(31 downto 0);
    clk:in std_logic;
    wr:in std_logic;
    wrData:in std_logic_vector(31 downto 0)
 );
end component MMXMemory;

component Alu is
  Port (
    mode:in std_logic;
    arith:in std_logic;
    passB:in std_logic;
    packed: in std_logic_vector(1 downto 0);
    A: in std_logic_vector(31 downto 0);
    B: in std_logic_vector(31 downto 0);
    Res: out std_logic_vector(31 downto 0);
    greaterThenMask:out std_logic_vector(3 downto 0)
   );
end component Alu;

component SegDisp is
Port ( 
    clk:in std_logic;
   
    CAT: out std_logic_vector(6 downto 0);
    AN:out std_logic_vector(3 downto 0);
    Digit0:in std_logic_vector(3 downto 0);
    Digit1:in std_logic_vector(3 downto 0);
    Digit2:in std_logic_vector(3 downto 0);
    Digit3:in std_logic_vector(3 downto 0)
);
end component SegDisp;

component debouncer is
Port(
    clk:in STD_LOGIC;
    btn:in STD_LOGIC;
    Enable:out STD_LOGIC
    
);
end component debouncer;

component controlUnit is
  Port (
    clk:in std_logic;
    command:in std_logic_vector(2 downto 0);
    mode:out std_logic;
    arith:out std_logic;
    wr:out std_logic;
    passB:out std_logic;
    ExtImm: out std_logic
  
  );
end component controlUnit;

component multiplyAndAdd is
 Port (A, B:in std_logic_vector(31 downto 0);
    Res:out std_logic_vector(31 downto 0)
  );
end component multiplyAndAdd;

signal changeSSD:std_logic;
signal Aout, Bout, Res:std_logic_vector(31 downto 0);
signal ResAlu:std_logic_vector(31 downto 0);
signal AfisRes:std_logic_vector(15 downto 0);
signal high:integer:=0;
signal immS:integer:=0;
signal immediate:std_logic_vector(31 downto 0);
signal chargeLowerImmediate, chargeUpperImmediate:std_logic;
signal showImmediate:std_logic;
signal command:std_logic_vector(2 downto 0);
signal dest:std_logic_vector(2 downto 0);
signal mode, arith, wr, passB, ExtImm:std_logic;
signal Boperand:std_logic_vector(31 downto 0);
signal wrEn, enable:std_logic;
signal ResMADD:std_logic_vector(31 downto 0);
begin

Control: ControlUnit port map(clk, sw(6 downto 4), mode, arith, wr, passB, ExtImm);
ArithLogic: Alu port map(mode, arith, passB, sw(1 downto 0), AOut, Boperand, ResAlu, led(3 downto 0));
Memo: MMXMemory port map(sw(9 downto 7), sw(15 downto 13), sw(12 downto 10), Aout, Bout, clk, wrEn, Res);
afis: SegDisp port map(clk, cat, an, AfisRes(3 downto 0), AfisRes(7 downto 4), AfisRes(11 downto 8), AfisRes(15 downto 12));
db1: debouncer port map(clk, btn(0), changeSSD);
db2: debouncer port map(clk, btn(1), chargeLowerImmediate);
db3: debouncer port map(clk, btn(2), chargeUpperImmediate);
db4: debouncer port map(clk, btn(3), showImmediate);
db5: debouncer port map(clk, btn(4), enable);
pmadd: multiplyAndAdd port map(AOut, BOut, ResMADD);
wrEn<= wr and enable;

Boperand <= immediate when ExtImm='1'
else Bout;

AfisRes <= Res(15 downto 0) when high = 0 and immS = 0
else Res(31 downto 16) when high=1 and immS = 0
else immediate(31 downto 16) when high=1 and immS = 1
else immediate(15 downto 0);

Res<= ResMADD when sw(6 downto 4) = "101"
else ResAlu;


process(chargeUpperImmediate, sw, immediate, clk)
begin
if(rising_edge(clk)) then
if(chargeUpperImmediate ='1') then
immediate(31 downto 16) <= sw(15 downto 0);
end if;
end if;
end process;

process(chargeLowerImmediate, sw, immediate, clk)
begin
if(rising_edge(clk)) then
if(chargeLowerImmediate ='1') then
immediate(15 downto 0) <= sw(15 downto 0);
end if;
end if;
end process;





process(changeSSD, clk)
begin
if(rising_edge(clk)) then
if(changeSSD ='1') then
high <= 1-high;
end if;
end if;
end process;

process(showImmediate, clk)
begin
if(rising_edge(clk)) then 
if(showImmediate ='1') then
imms <= 1 - imms;
end if;
end if;
end process;

end Behavioral;
