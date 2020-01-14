----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2019 21:13:42
-- Design Name: 
-- Module Name: ripple_carry_adder - Behavioral
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

entity ripple_carry_adder is
    generic (
        g : natural :=8);
        
    Port ( iadd1 : in std_logic_vector(g-1 downto 0);
           iadd2 : in std_logic_vector(g-1 downto 0);
           carry_in: in std_logic;
           
           carry_out: out std_logic;
           ores: out std_logic_vector(g-1 downto 0) );
end ripple_carry_adder;

architecture Behavioral of ripple_carry_adder is

  component full_adder is
    Port ( i1 : in std_logic;
           i2 : in std_logic;
           ic : in std_logic;
           
           
          osum : out std_logic;
          oc : out std_logic   );
  end component full_adder;
 
signal CARRY : std_logic_vector(g downto 0);
signal SUM : std_logic_vector(g-1 downto 0);
begin
    
     CARRY(0) <= carry_in;
     
     set_addder: for k in 0 to g-1 generate
        full_adder_init : full_adder port map (  i1 => iadd1(k) ,
                                                 i2 =>iadd2(k),
                                                 ic =>CARRY(k),
                  
                                                osum  =>SUM(k),
                                                oc  => CARRY(k+1) );
     end generate set_addder;
     
     ores <= SUM;
     carry_out<= CARRY(g);
     


end Behavioral;
