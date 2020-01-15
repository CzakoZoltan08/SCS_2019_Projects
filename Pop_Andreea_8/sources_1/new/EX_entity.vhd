----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2019 04:06:24 PM
-- Design Name: 
-- Module Name: EX_entity - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX_entity is
    Port ( PC_1 : in STD_LOGIC_VECTOR (15 downto 0);
           readData1 : in STD_LOGIC_VECTOR (15 downto 0);
           readData2 : in STD_LOGIC_VECTOR (15 downto 0);
           extImm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
           branchAddress : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC);
end EX_entity;

architecture Behavioral of EX_entity is

signal inALU,ALU_ResAux: std_logic_vector(15 downto 0);
signal ALUCtrl: std_logic_vector(2 downto 0);
 

begin

    branchAddress <= PC_1 + extImm;
    
    process(readData2, extImm, ALUSrc)
    begin
        case ALUSrc is
            when '0' => inALU <= readData2;
            when '1' => inALU <= extImm; 
        end case;
    end process;
    
    process(ALUCtrl, readData1, inALU, sa)
    begin
        case ALUCtrl is
            when "000" => ALURes <= readData1 + inALU;          --add, addi, lw, sw  
            when "001" => ALURes <= readData1 and inALU;        --AND     
            when "010" => ALURes <= readData1 or inALU;         --OR, ORI
            when "011" => ALURes <= readData1 xor inALU;        --XOR
            when "100" => ALURes <= readData1 - inALU;          --sub, beq
            when "101" =>                                       --shift left
                            if sa = '0' then
                                ALURes <= readData1(14 downto 0)  & '0';  
                            else
                                ALURes <= readData1(13 downto 0) & "00";
                            end if;           
            when "110" =>                                        --shift right
                            if sa = '0' then
                                ALURes <= '0' & readData1(15 downto 1);
                            else
                                ALURes <= "00" & readData1(15 downto 2);
                            end if;
            when "111" => ALURes <= inALU;          
        end case;
    end process; 
    
    Zero <= '1' when   inALU - readData1 = 0 else '0';
    
    process(ALUOp, func)
    begin
        case ALUOp is
            when "00" => ALUCtrl <= "000";                  --addi, lw, sw
            when "01" => ALUCtrl <= "100";                  --beq
            when "10" =>  --type R
                case func is
                    when "000" => ALUCtrl <= "000";         --add
                    when "001" => ALUCtrl <= "100";         --sub
                    when "010" => ALUCtrl <= "101";         --sll
                    when "011" => ALUCtrl <= "110";         --srl
                    when "100" => ALUCtrl <= "001";         --and
                    when "101" => ALUCtrl <= "010";         --or
                    when "110" => ALUCtrl <= "011";         --xor
                    when "111" => ALUCtrl <= "111";         --sllv
                end case;
            when "11" => ALUCtrl <= "010";                  --ori
            when others => ALUCtrl <= "XXX";                --j
        end case;
    end process;
    
end Behavioral;
