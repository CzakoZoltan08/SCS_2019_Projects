----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2019 12:02:54
-- Design Name: 
-- Module Name: PCMPEQB - Behavioral
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

entity PCMPEQB is
  Port (input_1:in std_logic_vector(31 downto 0);
         input_2:in std_logic_vector(31 downto 0);
         sel: in std_logic_vector(1 downto 0);
         equal: out std_logic_vector(3 downto 0));
end PCMPEQB;



architecture Behavioral of PCMPEQB is

signal eq32MSB1:std_logic;
signal eq16MSB1:std_logic;
signal eq8MSB1:std_logic;


signal eq32LSB1:std_logic;
signal eq16LSB1:std_logic;
signal eq8LSB1:std_logic;

signal eq32MSB0:std_logic;
signal eq16MSB0:std_logic;
signal eq8MSB0:std_logic;

signal eq32LSB0:std_logic;
signal eq16LSB0:std_logic;
signal eq8LSB0:std_logic;

signal bit1_16:std_logic;
signal bit2_16:std_logic;

signal bit32:std_logic;

component compEQ is
 Port ( a:in std_logic_vector(7 downto 0);
        b:in std_logic_vector(7 downto 0);
        eq: out std_logic );
end component;


begin
        --32 
        compEQ32MSB1 : compEQ port map( a=>input_1(31 downto 24),
                                        b=>input_2(31 downto 24),
                                        eq=>eq32MSB1);
                                        
        compEQ32MSB0 : compEQ port map( a=>input_1(23 downto 16),
                                        b=>input_2(23 downto 16),
                                        eq=>eq32MSB0);
                                
        compEQ32LSB1 : compEQ port map( a=>input_1(15 downto 8),
                                        b=>input_2(15 downto 8),
                                        eq=>eq32LSB1);    
                                           
        compEQ32LSB0 : compEQ port map( a=>input_1(7 downto 0),
                                        b=>input_2(7 downto 0),
                                        eq=>eq32LSB0);   
         
         
         bit32<= eq32LSB0 and eq32LSB1 and eq32MSB0 and eq32MSB1;
       --16                                
        compEQ16MSB1 : compEQ port map( a=>input_1(31 downto 24),
                                 b=>input_2(31 downto 24),
                                 eq=>eq16MSB1);
                                                                                
        compEQ16MSB0 : compEQ port map( a=>input_1(23 downto 16),
                                        b=>input_2(23 downto 16),
                                        eq=>eq16MSB0);
           
         bit2_16<= eq16MSB1 and eq16MSB0;
                                                                      
        compEQ16LSB1 : compEQ port map( a=>input_1(15 downto 8),
                                        b=>input_2(15 downto 8),
                                         eq=>eq16LSB1);    
                                                                                   
        compEQ16LSB0 : compEQ port map( a=>input_1(7 downto 0),
                                        b=>input_2(7 downto 0),
                                        eq=>eq16LSB0);  
                                        
          bit1_16<= eq16LSB1 and eq16LSB0;                             
          --8                                   
         compEQ8MSB1 : compEQ port map( a=>input_1(31 downto 24),
                                         b=>input_2(31 downto 24),
                                         eq=>eq8MSB1);
                                                                                                                
         compEQ8MSB0 : compEQ port map( a=>input_1(23 downto 16),
                                        b=>input_2(23 downto 16),
                                        eq=>eq8MSB0);
                                                                                                        
         compEQ8LSB1 : compEQ port map( a=>input_1(15 downto 8),
                                        b=>input_2(15 downto 8),
                                        eq=>eq8LSB1);    
                                                                                                                   
        compEQ8LSB0 : compEQ port map( a=>input_1(7 downto 0),
                                       b=>input_2(7 downto 0),
                                       eq=>eq8LSB0);  
           
        
        
           
process(sel, eq8MSB1, eq8MSB0, eq8LSB1, eq8LSB0, bit32, bit1_16, bit2_16)
begin
        CASE sel IS
          WHEN "00" => 
               equal<=eq8MSB1 & eq8MSB0 & eq8LSB1 &eq8LSB0; --comparare pe cate 8 biti separat
          when "01" => equal<='0' & '0' & bit2_16 & bit1_16; --comparare pe 16 ,1 pt LSB,2 pt MSB
          when "10"=>  equal<='0' & '0' & '0' & bit32;    
                                            
         when others=> equal<="0000";
         END CASE;
 
 end process;                                                                                                                                                                                            
end Behavioral;
