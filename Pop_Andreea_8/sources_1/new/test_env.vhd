----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2019 07:02:25 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component mpg 
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component ssd 
    Port ( digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component IF_entity 
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
end component;

component ID_entity
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
end component;

component EX_entity 
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
end component;

component MEM_entity 
    Port ( clk : in STD_LOGIC;
           ALURes : inout STD_LOGIC_VECTOR (15 downto 0);
           readData2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWr : in STD_LOGIC;
           enable: in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal enable1: std_logic;
signal en: std_logic;

signal out_ssd: std_logic_vector(15 downto 0);    --display in ssd
signal out_pc_1: std_logic_vector(15 downto 0);   --PC + 1
signal out_instr: std_logic_vector(15 downto 0);  --instrucion taken from ROM(IF) and given to Registre File(ID)

signal RegDst: std_logic:= '0';       --control signals
signal RegWr: std_logic:= '0';
signal ExtOp: std_logic:= '0';
signal ALUSrc: std_logic:= '0';
signal ALUOp: std_logic_vector (1 downto 0):= "10";
signal Branch,BranchNE: std_logic:= '0';
signal Jump: std_logic:= '0';
signal MemWr: std_logic:= '0';
signal MemRd: std_logic:= '0';
signal MemToReg: std_logic:= '0';
signal PCSrc: std_logic:= '0';

signal functionn: std_logic_vector(2 downto 0);
signal shiftAmount: std_logic;
signal ext_imm: std_logic_vector(15 downto 0);
signal readData1, readData2: std_logic_vector(15 downto 0);

signal sum: std_logic_vector(15 downto 0);
signal branchAddr: std_logic_vector(15 downto 0);
signal resultALU: std_logic_vector(15 downto 0);
signal zero: std_logic;
signal memRAM: std_logic_vector(15 downto 0);
signal wrData: std_logic_vector(15 downto 0);
signal outBranch: std_logic_vector(15 downto 0);
signal outJump: std_logic_vector(15 downto 0);

begin

    c1: mpg port map(clk => clk, input => btn(0), enable => en);  --pc
    c2: mpg port map(clk => clk, input => btn(1), enable => enable1);  --reset
    c4: ssd port map(digit => out_ssd, clk => clk, cat => cat, an => an);
    c5: IF_entity port map(j_addr => outJump, br_addr => outBranch, PC_Src => PCSrc, jump => Jump, en => en, rst => enable1,
                           pc_1 => out_pc_1, instr => out_instr, clk => clk);
    c6: ID_entity port map(clk => clk, instruction => out_instr, wd => wrData, RegDst => RegDst, RegWr => RegWr, enable => en,
                           ExtOp => ExtOp, readData1 => readData1, readData2 =>readData2, extImm => ext_imm, func => functionn, sa => shiftAmount);  
    c7: EX_entity port map(PC_1 => out_pc_1, readData1 => readData1, readData2 => readData2, extImm => ext_imm,sa => shiftAmount, func => functionn,
                           ALUSrc => ALUSrc, ALUOp => ALUOp, branchAddress => branchAddr, ALURes => resultALU, Zero => zero);
    c8: MEM_entity port map(clk => clk, ALURes => resultALU, readData2 => readData2, MemWr => MemWr, enable => en, MemData => memRAM);
   
    PCSrc <= ( (Branch and zero) or (BranchNE and (not zero)) ) ;
    
    process(MemToReg, resultALU, memRAM)
    begin
        case MemToReg is
            when '0' => wrData <= resultALU;   --wa = wrData
            when '1' => wrData <= memRAM;
        end case;
    end process;
    
    outBranch <= out_pc_1 + ext_imm; --br_addr = outBranch
    
    outJump <= out_pc_1(15 downto 13) & out_instr(12 downto 0);  --j_addr = outJump
    
   
    process(sw(7 downto 5), out_instr, out_pc_1, readData1, readData2, ext_imm, resultALU, memRAM, wrData)         --display on SSD
    begin
        case sw(7 downto 5) is
            when "000" => out_ssd <= out_instr;               --intstruction from ROM
            when "001" => out_ssd <= out_pc_1;                --PC + 1
            when "010" => out_ssd <= readData1;               --readData1
            when "011" => out_ssd <= readData2;               --readData2
            when "100" => out_ssd <= ext_imm;                 --sign extension or zero extension
            when "101" => out_ssd <= resultALU;               --out from ALU   
            when "110" => out_ssd <= memRAM;                  --what i write in RAM
            when others => out_ssd <= wrData;                 --from Registre File
            
        end case;
    end process;
    
    led(0) <= RegDst;                   --all the signals are on the leds
    led(1) <= RegWr;
    led(2) <= ExtOp;
    led(3) <= ALUSrc;
    led(10 downto 9) <= ALUOp;
    led(4) <= Branch;
    led(5) <= Jump;
    led(6) <= MemWr;
    led(7) <= MemRd;
    led(8) <= MemToReg;
    led(15) <= zero;
    led(14) <= PCSrc;
 
    
    process(out_instr)  --instruction from IF(ROM)
    begin
    BranchNE <= '0';
    Branch <= '0';
        case out_instr(15 downto 13) is   --opcode
            when "000" =>  --type R
               case out_instr(2 downto 0) is  --function if is type R
                    when "000" => RegDst <= '1';    --add
                                  RegWr <= '1';    
                                  ExtOp <= 'X';
                                  ALUSrc <= '0';
                                  Branch <= '0';
                                  Jump <= '0';
                                  MemWr <= '0';
                                  MemRd <= '0';
                                  MemToReg <= '0';
                                  ALUOp <= "10";
                                  
                    when "001" => RegDst <= '1';    --subb
                                  RegWr <= '1';
                                  ExtOp <= 'X';
                                  ALUSrc <= '0';
                                  Branch <= '0';
                                  Jump <= '0';
                                  MemWr <= '0';
                                  MemRd <= '0';
                                  MemToReg <= '0';
                                  ALUOp <= "10";
                                  
                    when "010" => RegDst <= '1';    --sll
                                  RegWr <= '1';
                                  ExtOp <= 'X';
                                  ALUSrc <= '0';
                                  Branch <= '0';
                                  Jump <= '0';
                                  MemWr <= '0';
                                  MemRd <= '0';
                                  MemToReg <= '0';
                                  ALUOp <= "10";
                                  
                    when "011" => RegDst <= '1';    --srl  
                                  RegWr <= '1';
                                  ExtOp <= 'X';
                                  ALUSrc <= '0';
                                  Branch <= '0';
                                  Jump <= '0';
                                  MemWr <= '0';
                                  MemRd <= '0';
                                  MemToReg <= '0';
                                  ALUOp <= "10";
                                  
                    when "100" => RegDst <= '1';    --and
                                  RegWr <= '1';
                                  ExtOp <= 'X';
                                  ALUSrc <= '0';
                                  Branch <= '0';
                                  Jump <= '0';
                                  MemWr <= '0';
                                  MemRd <= '0';
                                  MemToReg <= '0';
                                  ALUOp <= "10"; 
                                               
                    when "101" => RegDst <= '1';    --or
                                  RegWr <= '1';
                                  ExtOp <= 'X';
                                  ALUSrc <= '0';
                                  Branch <= '0';
                                  Jump <= '0';
                                  MemWr <= '0';
                                  MemRd <= '0';
                                  MemToReg <= '0';
                                  ALUOp <= "10";
                                  
                    when "110" => RegDst <= '1';    --xor
                                  RegWr <= '1';
                                  ExtOp <= 'X';
                                  ALUSrc <= '0';
                                  Branch <= '0';
                                  Jump <= '0';
                                  MemWr <= '0';
                                  MemRd <= '0';
                                  MemToReg <= '0';
                                  ALUOp <= "10";
                                  
                    when "111" => RegDst <= '1';    --sllv
                                  RegWr <= '1';
                                  ExtOp <= 'X';
                                  ALUSrc <= '0';
                                  Branch <= '0';
                                  Jump <= '0';
                                  MemWr <= '0';
                                  MemRd <= '0';
                                  MemToReg <= '0'; 
                                  ALUOp <= "10";   
               end case;
               
            when "001" => RegWr <= '1';             --addi
                          ExtOp <= '1';
                          AluSrc <= '1';
                          ALUOp <= "00";
                          RegDst <= '0';
                          Branch <= '0';
                          Jump <= '0';
                          MemWr <= '0';
                          MemRd <= '0';
                          MemToReg <= '0';
            
           when "010" => RegWr <= '1';              --lw
                         ExtOp <= '1';
                         AluSrc <= '1';
                         ALUOp <= "00"; 
                         MemRd <= '1';
                         MemToReg <= '1';
                         RegDst <= '0';
                         Branch <= '0';
                         Jump <= '0';
                         MemWr <= '0';
                         
           when "011" => RegDst <= 'X';             --sw
                         ExtOp <= '1';
                         AluSrc <= '1';
                         ALUOp <= "00";
                         MemWr <= '1';
                         MemToReg <= '1';
                         RegWr <= '0';
                         Branch <= '0';
                         Jump <= '0';
                         MemRd <= '0';
                         
           when "100" => RegDst <= 'X';             --beq
                         ExtOp <= '1';
                         ALUOp <= "01";
                         Branch <= '1';
                         MemToReg <= 'X';
                         RegWr <= '0';
                         ALUSrc <= '0';
                         Jump <= '0';
                         MemWr <= '0';
                         MemRd <= '0';
                          
           when "101" => RegDst <= 'X';             --bne
                         ExtOp <= '1';
                         ALUOp <= "01";
                         BranchNE <= '1';
                         Branch <= '0';
                         MemToReg <= 'X'; 
                         RegWr <= '0';
                         ALUSrc <= '0';
                         Jump <= '0';
                         MemWr <= '0';
                         MemRd <= '0';
                         
           when "110" => RegWr <= '1';              --ori
                         ExtOp <= '0';
                         ALUSrc <= '1';
                         ALUOp <= "11";
                         RegDst <= '0';
                         Branch <= '0';
                         Jump <= '0';
                         MemWr <= '0';
                         MemRd <= '0';
                         MemToReg <= '0';
                         
           when "111"  => RegDst <= 'X';             --j
                          ExtOp <= 'X';
                          ALUSrc <= 'X';
                          ALUOp <= "XX";
                          Jump <= '1';
                          MemToReg <= 'X';
                          RegWr <= '0';
                          Branch <= '0';
                          MemWr <= '0';
                          MemRd <= '0';
        end case;
    
    end process;
    
end Behavioral;
