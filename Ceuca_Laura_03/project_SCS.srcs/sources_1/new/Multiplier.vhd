library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
           y : in  STD_LOGIC_VECTOR (31 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end Multiplier;

architecture Behavioral of Multiplier is

begin
	process(x,y)
		variable mantissa_X : STD_LOGIC_VECTOR (23 downto 0);
		variable exponent_X : STD_LOGIC_VECTOR (8 downto 0);
		variable sign_X : STD_LOGIC;
		
		variable mantissa_Y : STD_LOGIC_VECTOR (23 downto 0);
		variable exponent_Y : STD_LOGIC_VECTOR (8 downto 0);
		variable sign_Y : STD_LOGIC;
		
		variable mantissa_Z : STD_LOGIC_VECTOR (22 downto 0);
		variable exponent_Z : STD_LOGIC_VECTOR (7 downto 0);
		variable sign_Z : STD_LOGIC;
		
		variable carry : STD_LOGIC:='0';
		variable carry1 : STD_LOGIC:='0';
		
		variable AUX_1: STD_LOGIC_VECTOR (8 downto 0);
		variable AUX_127 : STD_LOGIC_VECTOR (8 downto 0);
		variable Sum : STD_LOGIC_VECTOR (8 downto 0);
		
		variable Product : STD_LOGIC_VECTOR (47 downto 0);
		variable Reg_1 : STD_LOGIC_VECTOR (47 downto 0);
		variable Reg_2 : STD_LOGIC_VECTOR (47 downto 0);
		variable Rounder : STD_LOGIC_VECTOR (22 downto 0);
	begin
	
		mantissa_X(22 downto 0) := x(22 downto 0);
		mantissa_Y(22 downto 0) := y(22 downto 0);
		--EXTRA BIT FOR MULTIPLICATION
		mantissa_X(23):='0';                          
		mantissa_Y(23):='0';  
		                                  
		exponent_X(7 downto 0) := x(30 downto 23);
		exponent_Y(7 downto 0) := y(30 downto 23);
		--EXTRA BIT FOR ADDITION
		exponent_X(8) := '0';                          
		exponent_Y(8) := '0';  
		                              
		sign_X := x(31);
		sign_Y := y(31);	
		
		--TREAT CORNER CASES INF OR ZERO FIRST
		if (exponent_X=255 or exponent_Y=255) then     --INFINITY
			exponent_Z := "11111111";
			mantissa_Z := (others => '0');
			sign_Z := sign_X xor sign_Y;
		elsif (exponent_X=0 or exponent_Y=0) then      --ZERO
			exponent_Z := (others => '0');
			mantissa_Z := (others => '0');
			sign_Z := '0';
		else
		--TREAT REST OF THE CASES
		        --SET UP REGISTERS
                AUX_127 := "001111111" ;
                AUX_1 := "000000001";
                Reg_1 := (others =>'0');
                Reg_2 := (others => '0');
                Product := (others => '0') ;
                
                Rounder := (others => '0');
                Rounder(0) := '1';
			
			mantissa_X(23) := '1';                                
			mantissa_Y(23) := '1';
			
			--SHIFT AND ADD MULTIPLIER
			for J in 0 to 23 loop
				Reg_1 := (others => '0');                
				if(mantissa_Y(J)='1') then
					Reg_1(23+J downto J) := mantissa_X;   
				end if;
				
				Reg_2 := Product;                         
				
				for I in 0 to 47 loop                             
					Product(I) := Reg_2(I) xor Reg_1(I) xor carry;
					carry  := ( Reg_2(I) and Reg_1(I) ) or ( Reg_2(I) and carry ) or ( Reg_1(I) and carry );
				end loop;
			end loop;
			
			--REUSE CARRY AUX BIT FOR NEXT OPERATIONS
			carry  := '0'; 
			carry1 := '0';
			
			--ADD EXPONENTS
			for I in 0 to 8 loop
				Sum(I) := exponent_X(I) xor exponent_Y(I) xor carry ;
				carry := ( exponent_X(I) and exponent_Y(I) ) or ( exponent_X(I) and carry ) or ( exponent_Y(I) and carry ) ;
			end loop;
			
			--REUSE CARRY AUX BIT FOR NEXT OPERATIONS
			carry := '0' ;
			carry1 := '0'; 
			
			-- ADD 1 TO EXPONENT 
			if(Product(47)='1') then
                    for I in 0 to 8 loop
                        carry := Sum(I) ;
                        Sum(I) :=  carry xor AUX_1(I) xor carry1 ;
                        carry1 := (AUX_1(I) and carry ) or ( AUX_1(I) and carry1 ) or ( carry and carry1 ) ;
                    end loop;
                    
                    mantissa_Z := Product(46 downto 24);
                    
                    carry := '0' ; 
                    carry1 := '0'; 
                    -- EITHER 0 OR 1
                    Rounder(0) := Product(23);
                    
                    -- ROUND MANTISSA
                    for I in 0 to 22 loop
                        carry := mantissa_Z(I) ;
                        mantissa_Z(I) :=  carry xor Rounder(I) xor carry1 ;
                        carry1 := (Rounder(I) and carry ) or ( Rounder(I) and carry1 ) or ( carry and carry1 ) ;
                    end loop;
			else
                    mantissa_Z := Product(45 downto 23);
                    
                    carry := '0' ;
                    carry1 := '0';
                    -- EITHER 0 OR 1
                    Rounder(0) := Product(22);
                    
                    -- ROUND MANTISSA
                    for I in 0 to 22 loop
                        carry := mantissa_Z(I) ;
                        mantissa_Z(I) :=  carry xor Rounder(I) xor carry1 ;
                        carry1 := (Rounder(I) and carry ) or ( Rounder(I) and carry1 ) or ( carry and carry1 ) ;
                    end loop;
                end if;
			
			-- SUBTRACT 127 FROM EXPONENT
			for I in 0 to 8 loop
				carry := Sum(I) ;
				Sum(I) :=  carry xor AUX_127(I) xor carry1 ;
				carry1 := ( carry1 and Not carry ) or ( AUX_127(I) and Not carry ) or (AUX_127(I) and carry1) ;
			end loop;
			
			if (Sum(8)='1') then 
				if (Sum(7)='0') then
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
				exponent_Z := Sum(7 downto 0);
				sign_Z := sign_X xor sign_Y;
			end if;
			
			sign_Z := sign_X xor sign_Y;
		end if;
		
		z(31)<=sign_Z;
		z(30 downto 23) <= exponent_Z;
		z(22 downto 0)<= mantissa_Z;
	end process;
end Behavioral;