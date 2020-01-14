----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/17/2019 08:06:36 PM
-- Design Name: 
-- Module Name: PSL - Behavioral
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

entity PSL is
    Port ( input_1:in std_logic_vector(31 downto 0);
            sel: in std_logic_vector(1 downto 0);
           result:out std_logic_vector(31 downto 0) );
end PSL;

architecture Behavioral of PSL is

component shift_left is
   
   Port ( 
       cin:in std_logic;
       data_in: in std_logic_vector(7 downto 0);
       data_out: out std_logic_vector(7 downto 0);
       cout:out std_logic
    );
end component;

signal cout16_1:std_logic;
signal cout16_2:std_logic;
signal cout32_1:std_logic;
signal cout32_2:std_logic;
signal cout32_3:std_logic;
signal cout32_4:std_logic;
signal useless8:std_logic_vector(6 downto 0);

signal res8: std_logic_vector(31 downto 0);
signal res32: std_logic_vector(31 downto 0);
signal res16: std_logic_vector(31 downto 0);

begin
    
        --8 biti shift separat
        sll8MSB1: shift_left port map (cin=>'0',
                                       data_in=> input_1(31 downto 24), 
                                       data_out=>res8(31 downto 24),
                                       cout=>useless8(0));
        
        sll8MSB0: shift_left port map (cin=>'0',
                                       data_in=> input_1(23 downto 16), 
                                       data_out=>res8(23 downto 16),
                                       cout=>useless8(1));
        
        sll8LSB1: shift_left port map (cin=>'0',
                                       data_in=> input_1(15 downto 8), 
                                       data_out=>res8(15 downto 8),
                                       cout=>useless8(2));
        
        sll8LSB0: shift_left port map (cin=>'0',
                                       data_in=> input_1(7 downto 0), 
                                       data_out=>res8(7 downto 0),
                                       cout=>useless8(3));
        --second 16
        sll16MSB1: shift_left port map (cin=>cout16_2,
                                       data_in=> input_1(31 downto 24), 
                                       data_out=>res16(31 downto 24),
                                       cout=>useless8(4));
        
        sll16MSB0: shift_left port map (cin=>'0',
                                       data_in=> input_1(23 downto 16), 
                                       data_out=>res16(23 downto 16),
                                       cout=>cout16_2);
        
        --first 16
        sll16LSB1: shift_left port map (cin=>cout16_1,
                                       data_in=> input_1(15 downto 8), 
                                       data_out=>res16(15 downto 8),
                                       cout=>useless8(5));
        
        sll16LSB0: shift_left port map (cin=>'0',
                                       data_in=> input_1(7 downto 0), 
                                       data_out=>res16(7 downto 0),
                                       cout=>cout16_1);
                                       
        --32 bit shift
        sll32MSB1: shift_left port map (cin=>cout32_3,
                                       data_in=> input_1(31 downto 24), 
                                       data_out=>res32(31 downto 24),
                                       cout=>useless8(6));
        
        sll32MSB0: shift_left port map (cin=>cout32_2,
                                       data_in=> input_1(23 downto 16), 
                                       data_out=>res32(23 downto 16),
                                       cout=>cout32_3);
        
        sll32LSB1: shift_left port map (cin=>cout32_1,
                                       data_in=> input_1(15 downto 8), 
                                       data_out=>res32(15 downto 8),
                                       cout=>cout32_2);
        
        sll32LSB0: shift_left port map (cin=>'0',
                                       data_in=> input_1(7 downto 0), 
                                       data_out=>res32(7 downto 0),
                                       cout=>cout32_1);  
                                       
                                       
    process(sel, res8, res16, res32)
    begin
         CASE sel IS
           -- add
           WHEN "00" => result<=res8; --shift pt 8 biti  ce fac cu cele 4 outputuri?
           when "01" => result<=res16; -- shift 16 biti -//- 2 outuri
           when "10"=>                  --shift 32 biti
                result<=res32;
           when others=> result<=x"00000000";
           END CASE;                               
 end process;                                      
                                       
                                                                           
end Behavioral;



