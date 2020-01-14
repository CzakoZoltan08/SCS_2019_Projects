----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2019 17:16:34
-- Design Name: 
-- Module Name: PADDSW - Behavioral
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

entity PADDSW is
  Port (input_1: in std_logic_vector(31 downto 0);
        input_2: in std_logic_vector(31 downto 0);
        sel: in std_logic_vector(1 downto 0); --select 8/16/32 bits op
        
        res: out std_logic_vector(31 downto 0);
        cout: out std_logic
                 );
end PADDSW;


architecture Behavioral of PADDSW is

component ripple_carry_adder is
generic (
        g : natural :=8);
        
    Port ( iadd1 : in std_logic_vector(g-1 downto 0);
           iadd2 : in std_logic_vector(g-1 downto 0);
           carry_in: in std_logic;
           
           carry_out: out std_logic;
           ores: out std_logic_vector(g-1 downto 0) );
 end component;
 
 signal cout8no1: std_logic;
 signal cout8no2: std_logic;
 signal cout8no3: std_logic;
 signal cout8no4: std_logic;

signal c1: std_logic;
signal c0: std_logic;
signal cout16no1: std_logic;
signal cout16no2: std_logic;



signal cx1: std_logic;
signal cx0: std_logic;
signal cx2: std_logic;
signal cout32: std_logic;

signal res8: std_logic_vector(31 downto 0); 
signal res16: std_logic_vector(31 downto 0); 
signal res32: std_logic_vector(31 downto 0); 
begin
    --port map 32 biti carry in 0 x4 
    
    
    
    
    rip32MSB1 : ripple_carry_adder port map (iadd1 =>input_1(31 downto 24),
                                                   iadd2=>input_2(31 downto 24),
                                                   carry_in=>cx2,
                      
                                                   carry_out=>cout32,
                                                   ores=>res32(31 downto 24) );
    
                                                   
    rip32MSB0 : ripple_carry_adder port map (iadd1 =>input_1(23 downto 16),
                                                  iadd2=>input_2(23 downto 16),
                                                   carry_in=>cx1,
                      
                                                   carry_out=>cx2,
                                                   ores=>res32(23 downto 16) );
    
    rip32LSB1 : ripple_carry_adder port map (iadd1 =>input_1(15 downto 8),
                                                   iadd2=>input_2(15 downto 8),
                                                   carry_in=>cx0,
                      
                                                   carry_out=>cx1,
                                                   ores=>res32(15 downto 8) );
    
                                                   
    rip32LSB0 : ripple_carry_adder port map (iadd1 =>input_1(7 downto 0),
                                                  iadd2=>input_2(7 downto 0),
                                                   carry_in=>'0',
                      
                                                   carry_out=>cx0,
                                                   ores=>res32(7 downto 0) );
                                                   
                                                   
    --port map 16 biti carry in 0 x4 
    rip16MSB1 : ripple_carry_adder port map (iadd1 =>input_1(31 downto 24),
                                                   iadd2=>input_2(31 downto 24),
                                                   carry_in=>c1,
                      
                                                   carry_out=>cout16no2,
                                                   ores=>res16(31 downto 24) );
    
                                                   
    rip16MSB0 : ripple_carry_adder port map (iadd1 =>input_1(23 downto 16),
                                                  iadd2=>input_2(23 downto 16),
                                                   carry_in=>'0',
                      
                                                   carry_out=>c1,
                                                   ores=>res16(23 downto 16) );
    
    rip16LSB1 : ripple_carry_adder port map (iadd1 =>input_1(15 downto 8),
                                                   iadd2=>input_2(15 downto 8),
                                                   carry_in=>c0,
                      
                                                   carry_out=>cout16no1,
                                                   ores=>res16(15 downto 8) );
    
                                                   
    rip16LSB0 : ripple_carry_adder port map (iadd1 =>input_1(7 downto 0),
                                                  iadd2=>input_2(7 downto 0),
                                                   carry_in=>'0',
                      
                                                   carry_out=>c0,
                                                   ores=>res16(7 downto 0) );
                                                   
    --port map 8 biti carry in 0 x4 
    rip8MSB1 : ripple_carry_adder port map (iadd1 =>input_1(31 downto 24),
                                                   iadd2=>input_2(31 downto 24),
                                                   carry_in=>'0',
                      
                                                   carry_out=>cout8no4,
                                                   ores=>res8(31 downto 24) );
    
                                                   
    rip8MSB0 : ripple_carry_adder port map (iadd1 =>input_1(23 downto 16),
                                                  iadd2=>input_2(23 downto 16),
                                                   carry_in=>'0',
                      
                                                   carry_out=>cout8no3,
                                                   ores=>res8(23 downto 16) );
    
    rip8LSB1 : ripple_carry_adder port map (iadd1 =>input_1(15 downto 8),
                                                   iadd2=>input_2(15 downto 8),
                                                   carry_in=>'0',
                      
                                                   carry_out=>cout8no2,
                                                   ores=>res8(15 downto 8) );
    
                                                   
    rip8LSB0 : ripple_carry_adder port map (iadd1 =>input_1(7 downto 0),
                                                  iadd2=>input_2(7 downto 0),
                                                   carry_in=>'0',
                      
                                                   carry_out=>cout8no1,
                                                   ores=>res8(7 downto 0) );
                                                   
              
                                         
    process(sel,res8,res16,res32,cout32)
    begin
         CASE sel IS
           -- add
           WHEN "00" => res<=res8; cout<='0'; --adunare pt 8 biti  ce fac cu cele 4 outputuri?
           when "01" => res<=res16; cout<='0'; -- adunare 16 biti -//- 2 outuri
           when "10"=>                  --adunare 32 biti
                res<=res32;
                cout<= cout32;
           when others=> res<=x"00000000"; cout<='0';
           END CASE;
    
    
    
    
    
    end process;
end Behavioral;




