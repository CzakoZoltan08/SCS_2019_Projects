library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;  

entity Integer_Divider is
    Port(x,y: in STD_LOGIC_VECTOR(31 downto 0);
         quot: out STD_LOGIC_VECTOR(23 downto 0));
end Integer_Divider;

architecture Behavioural of Integer_Divider is

function  divide  (a : UNSIGNED; b : UNSIGNED) return UNSIGNED is
    variable a1 : unsigned(a'length-1 downto 0):=a;
    variable b1 : unsigned(b'length-1 downto 0):=b;
    variable p1 : unsigned(b'length downto 0):= (others => '0');
    variable i : integer:=0;
  
    begin
    for i in 0 to b'length-1 loop
    p1(b'length-1 downto 1) := p1(b'length-2 downto 0);
    p1(0) := a1(a'length-1);
    a1(a'length-1 downto 1) := a1(a'length-2 downto 0);
    p1 := p1-b1;
    if(p1(b'length-1) ='1') then
    a1(0) :='0';
    p1 := p1+b1;
    else
    a1(0) :='1';
    end if;
    end loop;
    return a1;
end divide;

signal a : unsigned(31 downto 0);
signal b : unsigned(31 downto 0);
signal c : unsigned(31 downto 0) :=(others => '0');

begin

a<= unsigned(x);
b<= unsigned(y);

c <= divide ( a , b );
quot <= std_logic_vector(c(23 downto 0));
    
end Behavioural;