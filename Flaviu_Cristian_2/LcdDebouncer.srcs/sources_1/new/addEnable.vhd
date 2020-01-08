----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.10.2019 20:06:52
-- Design Name: 
-- Module Name: addEnable - Behavioral
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity addEnable is
    Port ( clk:in std_logic;
           A : in STD_LOGIC_VECTOR (7 downto 0);
           sign:out std_logic;
           exp:out std_logic_vector(7 downto 0);
           mantissa:out std_logic_vector(22 downto 0)
          );
          
end addEnable;

architecture Behavioral of addEnable is



begin

sign<=A(7);
process(clk)
    begin    
   if A(6)='1' then
         mantissa<=A(5 downto 0)&x"0000"&"0";
                 exp<=x"02"+127;
   else if A(5)='1'then  mantissa<=A(4 downto 0)&x"0000"&"00";
                 exp<=x"01"+127;
    else if A(4)='1' then mantissa<=A(3 downto 0)&x"0000"&"000";
                 exp<=x"00"+127;
    else if A(3)='1' then
                    if(a(2)='1') then
                        mantissa<=A(2 downto 0)& x"00000";
                    else if(a(1)='1') then
                         mantissa<=a(1 downto 0)&x"00000"&"0";
                    else if (a(0)='1') then
                         mantissa<=x"10000"&"000";
                         else
                         mantissa<=x"00000"&"000";   
                         end if;                         
                         end if;
                     end if;
                  exp<=x"00"+126;    
    else if A(2)='1' then 
                    if(a(1)='1') then
                         mantissa<=a(1 downto 0)&x"00000"&"0";
                    else if (a(0)='1') then
                         mantissa<="1"&x"00000"&"00"; 
                         else
                         mantissa<="0"&x"00000"&"00";               
                         end if;                         
                     end if;
                  exp<=x"00"+125;     
    else if A(1)='1' then 
    
                  if(A(0)='1') then
                            mantissa<="1"&x"00000"&"00";
                  else
                            mantissa<=x"00000"&"000";
                  end if;
                  
                  exp<=x"00"+124;
                  
    else if A(0)='1' then mantissa<=x"00000"&"000";
                  exp<=x"00"+123;
     else  mantissa<=x"00000"&"000";
                  exp<=x"00";      
      
   end if;
   end if;
   end if;
   end if;
   end if;
   end if;
   end if;
  end process ; 
                 
    

end Behavioral;
