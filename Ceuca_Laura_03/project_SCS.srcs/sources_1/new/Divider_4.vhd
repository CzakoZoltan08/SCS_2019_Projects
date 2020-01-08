library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Divider is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
           y : in  STD_LOGIC_VECTOR (31 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end Divider;

architecture Behavioral of Divider is

component Integer_Divider is
    Port(x,y: in STD_LOGIC_VECTOR(31 downto 0);
         quot: out STD_LOGIC_VECTOR(23 downto 0));
end component;

signal Quotient: std_logic_vector(23 downto 0);
signal mantissa_X: STD_LOGIC_VECTOR(31 downto 0);
signal mantissa_Y: STD_LOGIC_VECTOR(31 downto 0);

begin

mantissa_X <= "00000000" & '1' & x(22 downto 0);
mantissa_Y <= "00000000" & '1' & y(22 downto 0);
divide_mantissa: Integer_Divider port map(x => mantissa_X, y => mantissa_Y, quot => Quotient);

process(x,y)
		variable exponent_X : STD_LOGIC_VECTOR (8 downto 0);
		variable sign_X : STD_LOGIC;
		variable exponent_Y : STD_LOGIC_VECTOR (8 downto 0);
		variable sign_Y : STD_LOGIC;
		
		variable mantissa_Z : STD_LOGIC_VECTOR (22 downto 0);
		variable exponent_Z : STD_LOGIC_VECTOR (7 downto 0);
		variable sign_Z : STD_LOGIC;
		
		variable carry : STD_LOGIC:='0';
		variable carry1 : STD_LOGIC:='0';
		
		variable AUX_127 : STD_LOGIC_VECTOR (8 downto 0);
		variable Difference : STD_LOGIC_VECTOR (8 downto 0);
		
	begin                           
		exponent_X(7 downto 0) := x(30 downto 23);
		exponent_Y(7 downto 0) := y(30 downto 23);
		--EXTRA BIT FOR SUBTACTION
		exponent_X(8) := '0';                          
		exponent_Y(8) := '0';  
		                              
		sign_X := x(31);
		sign_Y := y(31);	
		
		--TREAT CORNER CASES INF OR ZERO FIRST
		if (exponent_X=255 or exponent_Y=0) then     --INFINITY
			exponent_Z := "11111111";
			mantissa_Z := (others => '0');
			sign_Z := sign_X xor sign_Y;
		elsif (exponent_X=0 or exponent_Y=255) then      --ZERO
			exponent_Z := (others => '0');
			mantissa_Z := (others => '0');
			sign_Z := '0';
		else
		
		Difference := exponent_X - exponent_y + 127;
			
		if (Difference(8)='1') then 
			if (Difference(7)='0') then
				-- OVERFLOW
				exponent_Z := "11111111";
				mantissa_Z := (others => '0');
				sign_Z := sign_X xor sign_Y;
			else 
			   -- UNDERFLOW								
			   exponent_Z := (others => '0');
			   mantissa_Z := (others => '0');
			   sign_Z := '0';
		    end if;
		else	
			 -- NO ERROR	
			 mantissa_Z := Quotient(22 downto 0);				  		
		     exponent_Z := Difference(7 downto 0);
			 sign_Z := sign_X xor sign_Y;
		end if;
			
		sign_Z := sign_X xor sign_Y;
	end if;
		
	z(31)<=sign_Z;
	z(30 downto 23) <= exponent_Z;
	z(22 downto 0)<= mantissa_Z;
	end process;

end Behavioral;
