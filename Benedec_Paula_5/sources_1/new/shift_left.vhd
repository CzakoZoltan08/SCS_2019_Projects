----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.11.2019 22:08:55
-- Design Name: 
-- Module Name: shift_left - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_left is
   
   Port ( 
       cin:in std_logic;
       data_in: in std_logic_vector(7 downto 0);
       data_out: out std_logic_vector(7 downto 0);
       cout:out std_logic
    );
end shift_left;

architecture Behavioral of shift_left is

signal d:unsigned(7 downto 0);
begin
    
    process(cin,data_in)
    begin
            data_out(7)<=data_in(6);
            data_out(6)<=data_in(5);
            data_out(5)<=data_in(4);
            data_out(4)<=data_in(3);
            data_out(3)<=data_in(2);
            data_out(2)<=data_in(1);
            data_out(1)<=data_in(0);
            data_out(0)<=cin;
            cout<=data_in(7);
    end process;
        


end Behavioral;
