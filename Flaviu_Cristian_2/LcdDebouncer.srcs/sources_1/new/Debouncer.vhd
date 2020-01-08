
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

entity debouncer is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_vector(4 downto 0);
           enable : out STD_LOGIC_vector(4 downto 0));
end debouncer;

architecture Behavioral of debouncer is
signal Q:STD_LOGIC_VECTOR(15 downto 0);
signal D1Out,D2Out,D3Out:STD_LOGIC_vector(4 downto 0);
signal FlipEnable: std_logic;
   
begin
    process (clk)
     variable cnt: std_logic_vector(15 downto 0) := x"0000";
        begin
            IF(rising_edge(clk)) THEN            
                    cnt:=cnt+x"0001";
            END IF;
          Q<=cnt;
        end process ;
  
 process(CLK,Q)
      begin 
             if(Q=x"FFFF") then 
                FlipEnable<='1';
             else
                FlipEnable<='0';
             end if;
      end process ;
 
 process(clk)
 begin 
  if(rising_edge(clk)) then
            if (FlipEnable='1') then
                D1out<=btn;
             end if;
        end if;
     
 end process; 
 
 process(clk,D1Out)
    begin
     if(rising_edge(clk)) then
        D2out<=D1Out;
     end if;
    end process ;             
  
  process(clk,D2Out)
       begin
        if(rising_edge(clk)) then
           D3out<=D2Out;
        end if;
    end process;             
     
enable<=D2out and (not D3out);    
end Behavioral;