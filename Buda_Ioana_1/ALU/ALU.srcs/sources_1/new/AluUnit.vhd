----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2019 04:23:26 PM
-- Design Name: 
-- Module Name: AluUnit - Behavioral
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

entity AluUnit is
Port ( 
       clk: in std_logic;
       dataA: in std_logic_vector(15 downto 0):="0000000000000000";
       dataB:in std_logic_vector(15  downto 0);
       led: out std_logic_vector(15 downto 0);
       sel: in std_logic_vector(4 downto 0);
        sw : in STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";
       cat : out  STD_LOGIC_VECTOR (6 downto 0);
       btn: in std_logic_vector(4 downto 0);
       an : out  STD_LOGIC_VECTOR (3 downto 0)
       
  );
end AluUnit;

architecture Behavioral of AluUnit is
signal op ,stop, cout2,enable,enable2,enable3,enable4: std_logic;
signal enable5 : std_logic:='0';
signal citire_op: std_logic:='0';
signal operatie_aleasa:std_logic_vector(3 downto 0);
signal ssdOut,adunare,scadere,increment,decrement,rotateresult2,oldData,andresult,notresult,orresult,multresult,divisionresult,rotateResult
: std_logic_vector(15 downto 0);
signal dataO2: std_logic_vector(15 downto 0);
signal dataA2,dataA3,dataA3n: std_logic_vector(15 downto 0):="0000000000000000";
signal  remainder,quotient: std_logic_vector(7 downto 0);
signal start : std_logic:='1';
COMPONENT CarrySaveAdder IS
		PORT ( 
				a    :  in STD_LOGIC_VECTOR (3 downto 0);
				b    :  in STD_LOGIC_VECTOR (3 downto 0);
				c    :  in STD_LOGIC_VECTOR (3 downto 0);
				cout : out STD_LOGIC;
				s    : out STD_LOGIC_VECTOR (4 downto 0)
			   );			
END COMPONENT; 

Component Adder8 
      IS PORT (

      Cin: IN STD_LOGIC;
      A, B: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      Cout: OUT STD_LOGIC;
      SUM: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));

END component; 

component ACC is
  Port ( clk,reset: in std_logic;
         Din: in std_logic_vector(15 downto 0);
         Q: out std_logic_vector(15 downto 0);
         enable:in std_logic);
end component;

component MPG is
 Port (   btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component MultiplierComp is
	Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           prod : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component Division IS
    PORT (  enable : in std_logic;
             clk       :  in  STD_LOGIC;
             Divisor    :  in  STD_LOGIC_VECTOR (7 downto 0);
			 Dividend  :  in  STD_LOGIC_VECTOR (15 downto 0);
			 Stop      : out  STD_LOGIC;
             Remainder : out  STD_LOGIC_VECTOR (7 downto 0);
			 Quotient  : out  STD_LOGIC_VECTOR (7 downto 0)
			);
end component;




COMPONENT RotateX is
    Port ( clk:in std_logic;
           A : in STD_LOGIC_VECTOR (15 downto 0);
           B : out STD_LOGIC_VECTOR (15 downto 0);
           N: in std_logic_vector(3 downto 0);
           R: in std_logic );
end COMPONENT;







component SSD is
 Port ( digit0: in std_logic_vector(3 downto 0):="0000";
        digit1:in std_logic_vector(3 downto 0):="0000";
        digit2:in std_logic_vector(3 downto 0):="0000";
        digit3:in std_logic_vector(3 downto 0):="0100";
        clk: in std_logic;
        cat :out std_logic_vector(6 downto 0);
        an: out std_logic_vector(3 downto 0)
        );
end component;

COMPONENT AND_GATE is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           C : out STD_LOGIC_VECTOR (15 downto 0));
end COMPONENT;
COMPONENT OR_GATE is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           C : out STD_LOGIC_VECTOR (15 downto 0));
end COMPONENT;

COMPONENT NOT_GATE is
    Port ( A : in STD_LOGIC_VECTOR (0 to 15);
           B : out STD_LOGIC_VECTOR (0 to 15));
end COMPONENT;


begin

Choose_op_mux: process(clk)

begin
     if(rising_edge(clk))then
          case sel is
          when "0000" => op<='0';
          when  others => op<='1';
          
          end case;
          
          
          end if;
     


end process;

Citire_operatie :process(clk,enable,enable2,enable3,enable4,enable5)
begin


    if(rising_edge(clk)) then
      
       
           if(enable3='1') then
               operatie_aleasa <=sw(3 downto 0);
               
               
           
           elsif(enable='1') then
    dataA2 <= sw;
    
   
    --dataA3 <= not dataA2;
          elsif( enable2='1') then
         
          dataA3<= sw;
          
          dataA3n <= not dataA3;
          elsif(enable4='1') then
          
          dataA3<=oldData;
          dataA3n <= not dataA3;
    end if;
    end if;
   
  end process;  
 Alegere_res :process (clk,divisionresult,dataA2,dataA3,start,enable5)
 begin
 
 case operatie_aleasa is
 when "0010" => dataO2<=adunare;
 when "0001" => dataO2 <=scadere;
 when "0011" => dataO2<= andresult;
 when "0100" => dataO2 <= orresult;
 when "0101" => dataO2 <=notresult;
 when "0110" => 
 dataO2<= rotateResult;
 when "0111" =>
  dataO2 <= rotateResult2;
 
 when "1000" => dataO2 <= multresult;
 when "1001" => dataO2<=divisionresult;
                 --led<=divisionresult;
 --when "1010" => dataA3 <= oldData;                
  when others => dataO2<="0000000000000000";
  
  end case;
  led<=oldData;
end process;


adder : Adder8 PORT MAP ('0',dataA2,dataA3, Cout2 , adunare );
Scaderea :  Adder8 PORT MAP ('1',dataA2,dataA3n, Cout2 , scadere );
andop : AND_GATE PORT MAP (dataA2,dataA3,andresult);
ORop : OR_GATE PORT MAP (dataA2,dataA3,orresult);
NOTop : NOT_GATE PORT MAP (dataA2,notresult);
multiplication : MultiplierComp port map(dataA2(7 downto 0),dataA3(7 downto 0),multresult);
impartite : Division port map (enable5,clk,"00000010",DataA2,stop,divisionresult(15 downto 8),divisionresult(7 downto 0));
enabling : MPG port map(btn(0),clk,enable);
enabling2 : MPG port map(btn(1),clk,enable2);
enabling3 : MPG port map(btn(2),clk,enable3);
enabling4 : MPG port map(btn(3),clk,enable4);
enabling5 : MPG port map(btn(4),clk,enable5);
accumulator : ACC port map(clk,'0',dataO2(15 downto 0),oldData,enable4);
--impartire : Division2 PORT MAP(clk ,'1',"0011","00001110",stop,dataO2(7  downto 4),dataO2(11 downto 8));
rotate: RotateX PORT MAP (clk, DataA2 ,rotateResult ,"0001",'0');
rotate2: RotateX PORT MAP (clk, DataA2 ,rotateResult2 ,"0001",'1');
--afisare: SSD PORT MAP( dataO2(15 downto 12),dataO2(11 downto 8),dataO2(7 downto 4),dataO2(3 downto 0),clk,cat,an);  
 afisare: SSD PORT MAP( dataO2(3 downto 0),dataO2(7 downto 4),dataO2(11 downto 8),dataO2(15 downto 12),clk,cat,an);           





end Behavioral;
