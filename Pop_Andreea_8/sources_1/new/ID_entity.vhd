----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2019 10:31:58 AM
-- Design Name: 
-- Module Name: ID_entity - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_entity is
    Port ( clk : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           RegDst : in STD_LOGIC;
           RegWr : in STD_LOGIC;
           enable: in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           readData1 : out STD_LOGIC_VECTOR (15 downto 0);
           readData2 : out STD_LOGIC_VECTOR (15 downto 0);
           extImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end ID_entity;

architecture Behavioral of ID_entity is

component registre_file 
    Port ( readAddress1 : in STD_LOGIC_VECTOR (2 downto 0);
           readAddress2 : in STD_LOGIC_VECTOR (2 downto 0);
           writeAddress : in STD_LOGIC_VECTOR (2 downto 0);
           writeData : in STD_LOGIC_VECTOR (15 downto 0);
           readData1 : out STD_LOGIC_VECTOR (15 downto 0);
           readData2 : out STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

signal out_mux: std_logic_vector(2 downto 0);
signal finalEnable: std_logic;

begin

    --mux alegere registru de scriere
    process(RegDst, instruction(9 downto 7), instruction(6 downto 4))
    begin
        case RegDst is
            when '0' => out_mux <= instruction(9 downto 7);   --rt
            when '1' => out_mux <= instruction(6 downto 4);   --rs
        end case;
    end process;
    
    process(ExtOp, instruction(6 downto 0))    
    begin
        case ExtOp is
            when '0' => extImm <= "000000000" & instruction(6 downto 0);   --zero extension
            when '1' => 
                            if instruction(6) = '0' then      --sign extension
                                extImm <= "000000000" & instruction(6 downto 0);    --positive
                            else
                                extImm <= "111111111" & instruction(6 downto 0);    --negative
                            end if;               
        end case;
    end process;

    func <= instruction(2 downto 0);   --function field
    sa <= instruction(3);              --shift amount field
    
    c1: registre_file port map(readAddress1 => instruction(12 downto 10), readAddress2 => instruction(9 downto 7), writeAddress => out_mux, 
                               writeData => wd, readData1 => readData1, readData2 => readData2, regWrite=> finalEnable, clk => clk);

    finalEnable <= RegWr and enable; 
    
end Behavioral;
