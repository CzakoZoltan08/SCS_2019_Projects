library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity main is
        Port ( clk:in std_logic;       
           led:out std_logic_vector(15 downto 0);         
           sw:in std_logic_vector(15 downto 0);
           btn:in std_logic_vector(4 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end main;

architecture Behavioral of main is

component addEnable is
    Port ( clk:in std_logic;
           A : in STD_LOGIC_VECTOR (7 downto 0);
           sign:out std_logic;
           exp:out std_logic_vector(7 downto 0);
           mantissa:out std_logic_vector(22 downto 0)
          );          
end component;

component LCD is
Port (     clk : in STD_LOGIC;
           enable:in std_logic;
           d0 : in STD_LOGIC_VECTOR (3 downto 0);
           d1 : in STD_LOGIC_VECTOR (3 downto 0);
           d2 : in STD_LOGIC_VECTOR (3 downto 0);
           d3 : in STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Debouncer is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           enable : out STD_LOGIC_VECTOR(4 downto 0));
end component;


signal reset: std_logic;
signal enable:std_logic_vector(4 downto 0);
signal number:std_logic_vector(15 downto 0):=x"0000";
signal fancyEnable: std_logic;
signal SignA,SignB: std_logic;
signal MntA,MntB:std_logic_vector(22 downto 0);
signal MntA_shift,MntB_shift:std_logic_vector(22 downto 0):="000"&x"00000";

signal expA,expB:std_logic_vector(7 downto 0);
signal A,B:std_logic_vector( 7 downto 0);
signal diffExp:std_logic_vector(7 downto 0);
signal expFinal:std_logic_vector(7 downto 0);

signal rezultat:std_logic_vector(23 downto 0);
signal exp_egali:std_logic:='0';
signal operation:std_logic;


type state_type is (standby, rd1,rd2,state3,egalare_Exp,adunare_mantissa);
signal state, next_state : state_type;


begin
reset<=enable(1);


C1:LCD port map(clk,fancyEnable,number(3 downto 0),number(7 downto 4),number( 11 downto 8),number(15 downto 12),cat,an);
C2:Debouncer port map(clk,btn,enable);
C3:AddEnable port map(clk,A,signA,expA,MntA);
C4:AddEnable port map(clk,B,signB,expB,MntB);

fancyEnable<='1' when state=standby else '0';


SYNC_PROC : process (clk)
    begin
        if rising_edge(clk) then
                if (reset = '1') then
                       state <= standby;
                else
                       state <= next_state;   
                             
                end if;
        end if;
end process;

NEXT_STATE_DECODE : process (state,clk)
    begin
              case (state) is
                 when standby =>
                        if (enable(0) = '1') then
                        next_state <= rd1;                       
                        else
                        next_state <= standby;
                        end if;
                 when rd1 =>
                        if (enable(0)='1') then
                               A<=sw(7 downto 0);
                              next_state <= rd2;
                             
                        else
                               A<=sw(7 downto 0);
                              next_state <= rd1;
                        end if;
                    
                  when rd2 =>
                        if (enable(0)='1') then
                              B<=sw(7 downto 0);
                              next_state <=egalare_Exp;
                        else
                             B<=sw(7 downto 0);
                            next_state <= rd2;
                        end if;                 
                       operation<=sw(15);
                   when egalare_Exp=>                         
                       if(enable(0)='1') then
                            next_state<=adunare_mantissa;
                        else
                            next_state<=egalare_Exp;
                       end if;                                             
                       
                           if(expA>ExpB) then
                                expFinal<=expA;
                                diffExp<=ExpA-ExpB;
                                MntA_shift<=MntA;
                                
                                case diffExp(2 downto 0) is
                                    when "001"=>MntB_shift<='1'&MntB(22 downto 1);
                                    when "010"=>MntB_shift<="01"&MntB(22 downto 2);
                                    when "011"=>MntB_shift<="001"&MntB(22 downto 3);
                                    when "100"=>MntB_shift<="0001"&MntB(22 downto 4);
                                    when others=>MntB_shift<=x"FFFFF"&"111";                                    
                                end case;
                           else if(expA<expB) then
                                
                                expFinal<=expB;
                                diffExp<=ExpB-ExpA;
                                MntB_shift<=MntB;
                             case diffExp(2 downto 0) is
                                when "001"=>MntA_shift<='1'&MntA(22 downto 1);
                                when "010"=>MntA_shift<="01"&MntA(22 downto 2);
                                when "011"=>MntA_shift<="001"&MntA(22 downto 3);
                                when "100"=>MntA_shift<="0001"&MntA(22 downto 4);
                                when others=>MntA_shift<=x"FFFFF"&"111";                                    
                            end case;
                                
                           end if;
                           end if;
                     if(expA=expB) then
                            MntA_shift<=MntA;
                            MntB_shift<=MntB;
                             expFinal<=expB;
                             diffExp<=x"00";
                            exp_egali<='1';
                            
                     end if;
                  
                                                                  
                  when adunare_mantissa=>
                  
                          if (enable(0)='1') then                             
                                      next_state <= state3;                             
                                else                              
                                      next_state <= adunare_mantissa;
                                end if;
                          if operation='0' then
                        
                          if((signa='0' and signB='0') )then
                                   rezultat<='1'& (MntA_shift+MntB_shift);  
                            else if((signa='0' and signB='1') )then
                                   rezultat<='1'& (MntA_shift-MntB_shift);                           
                            else  if((signa='1' and signB='0') )then
                                   rezultat<='1'& (MntA_shift-MntB_shift); 
                            else  if((signa='1' and signB='1') )then
                                   rezultat<='1'& (MntA_shift+MntB_shift);   
                        
                                  end if;
                                  end if;
                                  end if;
                            end if;  
                  
                 
                    else
                        if((signa='0' and signB='0') )then
                               rezultat<='1'& (MntA_shift-MntB_shift);  
                        else if((signa='0' and signB='1') )then
                               rezultat<='1'& (MntA_shift+MntB_shift);  
                               
                        else  if((signa='1' and signB='0') )then
                               rezultat<='1'& (MntA_shift+MntB_shift); 
                        else  if((signa='1' and signB='1') )then
                               rezultat<='1'& (MntA_shift-MntB_shift);   
                    
                              end if;
                              end if;
                              end if;
                        end if;
                        
                    end if;
                
                  
                  when state3=> next_state<=state3;
                  
              
                              
           end case;
    end process; 

OUTPUT_DECODE : process (state,clk)
        begin
       
             case (state) is
                    when standby =>led<=x"0000";
                                   number<=x"3D1E";
                    when rd1 =>led<=x"0001" ;                              
                               number(7 downto 0)<=expA;
                               number(15 downto 8)<=MntA(22 downto 15);
                               
                    when rd2 =>led<=x"0003";
                               number(7 downto 0)<=expB;
                               number(15 downto 8)<=MntB(22 downto 15);  
           
                    when Egalare_Exp=>led<=x"0007"; 
                                       number<=x"0000";                     
                                
                    when state3=>led<=x"8000";
                    
                    case sw(2 downto 0) is 
                        when "000"=>number(7 downto 0)<=MntA(22 downto 15);
                                    number(15 downto 8)<=MntB(22 downto 15);
                                  
                        when "001"=>number(7 downto 0)<=MntA_shift(22 downto 15);
                                    number(15 downto 8)<=MntB_shift(22 downto 15);
                                  
                        when "010"=>number(7 downto 0)<=expA;
                                    number(15 downto 8)<=expB;
                                  
                        when "011"=>number(7 downto 0)<=diffexp;
                                    number(15 downto 8)<=expFinal;
                       
                        when "100"=>number<=rezultat(23 downto 8);
                       
                        when "101"=>number(7 downto 0)<=A;
                                   number(15 downto 8)<=B;
                                  
                    when "110"=>number<=(MntA_shift(22 downto 7) - MntB_shift(22 downto 7));
                    when "111"=>number<=(MntA_shift(22 downto 7) + MntB_shift(22 downto 7));    
                       when others=>number<=x"FFFF";
                   end case;      
                   led(0)<=signa;
                   led(1)<=signb; 
                   led(2)<=exp_egali;    
                   led(3)<=operation;        
                            
            when adunare_mantissa=>led<=x"000F";
                                   number<=x"1111";
            when others => led<=x"00FF";
                            
               end case;
       end process; 
  
end Behavioral;

