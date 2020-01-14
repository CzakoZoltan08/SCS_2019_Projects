----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2019 23:35:28
-- Design Name: 
-- Module Name: MMX - Behavioral
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

entity MMX is
--  Port ( );
 Port ( clk : in STD_LOGIC;
          btn : in STD_LOGIC_VECTOR (4 downto 0);
          sw : in STD_LOGIC_VECTOR (15 downto 0);
          led : out STD_LOGIC_VECTOR (15 downto 0);
          an : out STD_LOGIC_VECTOR (3 downto 0);
          cat : out STD_LOGIC_VECTOR (6 downto 0));
end MMX;

architecture Behavioral of MMX is

component PADDSW is
  Port (input_1: in std_logic_vector(31 downto 0);
        input_2: in std_logic_vector(31 downto 0);
        sel: in std_logic_vector(1 downto 0); --select 8/16/32 bits op
        
        res: out std_logic_vector(31 downto 0);
        cout: out std_logic
                 );
end component;

component PSL is
    Port ( input_1:in std_logic_vector(31 downto 0);
            sel: in std_logic_vector(1 downto 0);
           result:out std_logic_vector(31 downto 0) );
end component;

component PCMPEQB is
  Port (input_1:in std_logic_vector(31 downto 0);
         input_2:in std_logic_vector(31 downto 0);
         sel: in std_logic_vector(1 downto 0);
         equal: out std_logic_vector(3 downto 0));
end component;

 
 component  PAND is
 Port ( a: in std_logic_vector(31 downto 0);
        b:in std_logic_vector(31 downto 0);
        c:out std_logic_vector(31 downto 0));
end component;

component PXOR is
  Port (a:in std_logic_vector(31 downto 0);
        b:in std_logic_vector(31 downto 0);
        c:out std_logic_vector(31 downto 0) );
        
end component;

component regfile IS
    generic(width : integer :=32;
            regfile_depth : positive := 7;
            regfile_adrsize : positive := 3

);
PORT (clk:in std_logic;
      rst_n : IN std_logic;
      wen : IN std_logic; -- write control
      writeport : IN std_logic_vector(width-1 DOWNTO 0); -- register input
      adrwport : IN std_logic_vector(regfile_adrsize-1 DOWNTO 0);-- address write
      adrport0 : IN std_logic_vector(regfile_adrsize-1 DOWNTO 0);-- address port 0
      adrport1 : IN std_logic_vector(regfile_adrsize-1 DOWNTO 0);-- address port 1
      readport0 : OUT std_logic_vector(width-1 DOWNTO 0); -- output port 0
      readport1 : OUT std_logic_vector(width-1 DOWNTO 0) -- output port 1
);
END component;


component multiplicator_test is
    generic(
            WORD_SIZE: natural := 16
 
        );
        port(
            input_1: in std_logic_vector(WORD_SIZE-1 downto 0);
            input_2: in std_logic_vector(WORD_SIZE-1 downto 0);
            result: out std_logic_vector((2*WORD_SIZE - 1) downto 0)
            
        );
end component;
 
 component ssd is
    Port ( digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
 end component;
 
 component  debounce is
Port(
    clk:in STD_LOGIC;
    btn:in STD_LOGIC;
    Enable:out STD_LOGIC
    
);
end component;

signal equal:std_logic_vector(3 downto 0);
signal ceva:std_logic_vector(31 downto 0);

signal afis32:std_logic_vector(31 downto 0);
signal afis16:std_logic_vector(15 downto 0);

signal A:std_logic_vector(31 downto 0);
signal B:std_logic_vector(31 downto 0);
signal Z:std_logic_vector(31 downto 0);

signal add:std_logic_vector(31 downto 0);
signal xorr:std_logic_vector(31 downto 0);
signal andd:std_logic_vector(31 downto 0);
signal mulll:std_logic_vector(31 downto 0);
signal A_shiftat:std_logic_vector(31 downto 0);

signal reset:std_logic;
signal en:std_logic;

begin
        
        
        c1: regfile port map(
                  clk=>clk,
                  rst_n =>reset,
                  wen =>en,
                  writeport =>Z, -- register input//!!!!!!!!!!!!!!!!!!!!!!!!! nu uita de astaa ZZZZZZZ
                  adrwport =>sw(8 downto 6),-- address write
                  adrport0=>sw(2 downto 0),--port 0
                  adrport1 =>sw(5 downto 3),-- address port 1
                  readport0=>A, -- output port 0
                  readport1=>B -- output port 1
                  );
        
        c2: PADDSW port map(input_1=>A,
                    input_2=>B,
                    sel=>sw(14 downto 13),
                    
                    res=>add,
                    cout=>led(15));
                    
        c3: PAND port map(a=>A,
                          b=>B,
                          c=>andd);        
       
       c4: PXOR port map(
                        a=>A,
                        b=>B,
                        c=>xorr );  
                        
       
       c5: multiplicator_test port map(input_1=>A(15 downto 0),
                                        input_2=>B(15 downto 0),
                                         result=>mulll);                   
        
        
        c6:PSL port map(input_1=>A,
                        sel=>sw(14 downto 13),
                        result=>A_shiftat);
         
         
         c7: PCMPEQB port map(  input_1=>A,
                                input_2=>B,
                                sel=>sw(14 downto 13),
                                equal=>equal);
         
         led(3 downto 0)<= equal;--???????????????????????????????????????????????
                                
         Z<= add when sw(12 downto 10)="000"
                else andd when sw(12 downto 10)="001"
                else xorr when sw(12 downto 10)="010"
                else mulll when sw(12 downto 10)="011"
                    else A_shiftat  ;
                    
                                                    
        debounce_EN: debounce port map (clk=>clk,
                                  btn=>btn(0),
                                  Enable=>en);
                                  
        debounce_RESET: debounce port map (clk=>clk,
                                    btn=>btn(1),
                                    Enable=>Reset);
        afis16<= afis32(31 downto 16) when sw(15)='1'
                 else afis32(15 downto 0);

        c8: ssd port map(digit=>afis16,
                    clk=>clk,
                    cat=>cat,
                    an=>an);
   
   afis32<= Z;
   
   
   

    
end Behavioral;
