----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2019 01:08:30
-- Design Name: 
-- Module Name: multiply - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplicator_test is
    generic(
            WORD_SIZE: natural := 16
 
        );
        port(
            input_1: in std_logic_vector(WORD_SIZE-1 downto 0);
            input_2: in std_logic_vector(WORD_SIZE-1 downto 0);
            result: out std_logic_vector((2*WORD_SIZE - 1) downto 0)
            
        );
end entity multiplicator_test;

architecture multiplicator_test_arch of multiplicator_test is
    
begin
       result<= std_logic_vector(unsigned(input_1) * unsigned(input_2));
end architecture multiplicator_test_arch;
