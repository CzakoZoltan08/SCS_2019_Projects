----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 10:56:35 AM
-- Design Name: 
-- Module Name: IF - Behavioral
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

entity IF_entity is
    Port ( j_addr : in STD_LOGIC_VECTOR (15 downto 0);
           br_addr : in STD_LOGIC_VECTOR (15 downto 0);
           PC_Src : in STD_LOGIC;
           jump : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           pc_1 : out STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           clk: in std_logic
           );
end IF_entity;

architecture Behavioral of IF_entity is

type rom_array is array(0 to 255) of std_logic_vector(15 downto 0);
signal rom : rom_array := (
    x"0010", --add $1,$0,$0         0
    x"220A", --addi $4,$0,10     1
    x"0020", --add $2,$0,$0         2
    x"0050", --add $5,$0,$0         3
    x"8605", --beq $1,$4,5          4
    x"4980", --lw $3,0($2)          5
    x"15D0", --add $5,$5,$3         6
    x"2902", --addi $2,$2,2         7
    x"2482", --addi $1,$1,2         8
    x"E004", --j 4                  9
    x"628B", --sw $5,11($0)         A
    x"400B", --lw $3,0($2)          B

    others => x"0000"
 );

signal sum: std_logic_vector(15 downto 0);
signal out_jump: std_logic_vector(15 downto 0);
signal out_pc: std_logic_vector(15 downto 0);
signal out_mux1: std_logic_vector(15 downto 0);

begin
    process(clk, rst)
    begin
        if rst = '1' then
            out_pc <= x"0000";
        end if;
        if rising_edge(clk) then
            if en = '1' then
                 out_pc <= out_jump;
            end if;
        end if;
    end process;
    
    instr <= rom(conv_integer(out_pc));
    sum <= 1 + out_pc;
    
    --mux pentru branch
    process(PC_Src, sum, br_addr)
    begin
        case PC_Src is
            when '0' => out_mux1 <= sum;       -- sum reprezinta pc+1
            when '1' => out_mux1 <= br_addr;
        end case;
    end process;
    
    -- mux pentru jump
    process(jump, out_mux1, j_addr)
    begin
        case jump is
            when '0' => out_jump <= out_mux1;
            when '1' => out_jump <= j_addr;
        end case;
    end process;
    
    pc_1 <= sum;
    
end Behavioral;
