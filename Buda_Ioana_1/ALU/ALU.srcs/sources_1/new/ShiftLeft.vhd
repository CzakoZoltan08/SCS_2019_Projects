----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/03/2019 04:22:03 PM
-- Design Name: 
-- Module Name: ShiftLeft - Behavioral
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

entity RotateX is
    Port ( clk:in std_logic;
           A : in STD_LOGIC_VECTOR (15 downto 0);
           B : out STD_LOGIC_VECTOR (15 downto 0);
           N: in std_logic_vector(3 downto 0);
           R: in std_logic );
end RotateX;

architecture Behavioral of RotateX is


begin
   process(N)
      begin
      if(R='0') then---left
      case(N) is
      when "0000" => B <= A ;
      when "0001" => B <= A(14 downto 0) &A(15);
      when "0010" => B<=  A(13 downto 0) & A(15 downto 14);
      when "0011" => B <= A(12 downto 0) &A(15 downto 13);
      when "0100" => B<=  A(11 downto 0) & A(15 downto 12);
      when "0101" => B <= A(10 downto 0) &A(15 downto 11);  
      when "0110" => B<=  A(9 downto 0) & A(15 downto 10);
      when "0111" => B <= A(8 downto 0) &A(15 downto 9);
      when "1000" => B<=  A(7 downto 0) & A(15 downto 8);
      when "1001" => B <= A(6 downto 0) &A(15 downto 7);  
       
      when "1010" => B<= A(5 downto 0)&A(15 downto 6);-- ROR8
      when "1011" => B <= A(4 downto 0)&A(15 downto 5);-- ROR4
      when "1100" => B <= A(3 downto 0) & A(15 downto 4) ;-- SLL8
      when "1101" => B<= A(2 downto 0) & A(15 downto 3);-- ROR8
      when "1110" => B <= A(1 downto 0)&A(15 downto 2);-- ROR4
      when "1111" => B <= A(0) & A(15 downto 1);
    --  when "1100" => B <= A(3 downto 0) & A(15 downto 4); -- SLL
      when others => B <= x"0000";
      end case;
      else
       case(N) is
           when "0000" => B <= A ;
           when "0001" => B <=A(0) & A(15 downto 1) ;
           when "0010" => B<= A(1 downto 0) & A(15 downto 2)  ;
           when "0011" => B <= A(2 downto 0) & A(15 downto 3)  ; --
           when "0100" => B<= A(3 downto  0) & A(15 downto 4) ;  --
           when "0101" => B <= A(4 downto 0) & A(15 downto 5) ;  --
           when "0110" => B<= A(5 downto 0) & A(15 downto 6) ;
           when "0111" => B <= A(6 downto 0) & A(15 downto 7) ; --
           when "1000" => B<= A(7 downto 0) & A(15 downto 8) ;
           when "1001" => B <= A(8 downto 0)& A(15 downto 9) ;  
            
           when "1010" => B<= A(9 downto 0) &A(15 downto 10) ;-- ROR8
           when "1011" => B <= A(10 downto 0) & A(15 downto 11) ;-- ROR4
           when "1100" => B <=  A(11 downto 0) & A(15 downto 12)  ;-- SLL8
           when "1101" => B<= A(12 downto 0) & A(15 downto 13);-- ROR8
           when "1110" => B <= A(13 downto 0)&A(15 downto 14);-- ROR4
           when "1111" => B <= A(14 downto 0) & A(15); -- SLL
           when others => B <= x"0000";
           end case;
           end if;
      end process;


end Behavioral;
