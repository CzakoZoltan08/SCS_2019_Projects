--Implemented a TUTORIAL

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;



ENTITY Divider2 IS
    PORT ( 
             clk       :  in  STD_LOGIC;
             Start     :  in  STD_LOGIC;
			 Divisor    :  in  STD_LOGIC_VECTOR (7 downto 0);
			 Dividend  :  in  STD_LOGIC_VECTOR (15 downto 0);
			 Stop      : out  STD_LOGIC;
             Remainder : out  STD_LOGIC_VECTOR (7 downto 0);
			 Quotient  : out  STD_LOGIC_VECTOR (7 downto 0)
			);
END Divider2;



ARCHITECTURE BehavioralDivision OF Divider2 IS
    SIGNAL DivReg: STD_LOGIC_VECTOR (3 downto 0);
	
	-- signal DivNeg: STD_LOGIC_VECTOR (3 downto 0);
	
	SIGNAL Remaind : STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL M,Z_REG,D_REG  ,ACC  : STD_LOGIC_VECTOR (15 downto 0);
	SIGNAL sum     : STD_LOGIC_VECTOR (3 downto 0);

	TYPE state IS (S0, S1, S2, S3, S4);
	SIGNAL FSM_cur_state, FSM_nx_state : state;
	SIGNAL FSM_Stop                    : STD_LOGIC;
	SIGNAL INC_CNT                     : STD_LOGIC;
	SIGNAL LD_high                     : STD_LOGIC;
	SIGNAL AccShift_left0              : STD_LOGIC;
	SIGNAL AccShift_left1              : STD_LOGIC;
	SIGNAL Counter                     : STD_LOGIC_VECTOR (2 downto 0);
	--signal addd: STD_LOGIC;
	--signal subb: STD_LOGIC;
	--signal sum: STD_LOGIC_VECTOR(3 downto 0);
     BEGIN
  
        DivisorReg: PROCESS (clk, start)
		BEGIN
		
				IF (clk'event AND clk = '1') THEN 
				
					IF (start = '1') THEN
					
						DivReg <= Divisor;
						Z_REG <= DividenD;
						D_REG <= Divisor;
						
					END IF;
					
				END IF;
				
		END PROCESS;


		ComboSum: PROCESS (DivReg, ACC)
		BEGIN
		
				-- sum <= ACC(7 downto 4) + (not(DivReg) + 1);--scadere
				if( Dividend(15 downto 8) > Divisor) then 
				         sum <= "0000";
				 else
				        sum <= "1111" ;
				  end if;
				       
				 
		END PROCESS;


		ACCReg: PROCESS (clk, start, Dividend, sum, AccShift_left0, AccShift_left1, LD_high)
		BEGIN
		
			IF (clk'event and clk = '1' )THEN
			
				IF (start = '1') THEN
			  
					ACC   <= Dividend(6 downto 0)&'0';	--daca am ajuns shift
					Z_REG <= '0' & Dividend(14 downto 0);
					D_REG <= '0' & Divisor(14 downto 0);
					
			  
				ELSIF  LD_high = '1' THEN ---cand am facut scadere din divizor si nu avem OF
			  
					ACC(7 downto 4) <= sum;--pt calcululul restului
					Z_REG <= Z_REG(15 downto 1) & '0';
					
				  
				ELSIF AccShift_left0 = '1' THEN 
			  
					ACC  <= ACC(6 downto 0) & '0';--adaugam 0 la cat
					
				ELSIF AccShift_left1 = '1' THEN
				  
				  ACC  <= ACC(6 downto 0) & '1';---adaugam 1 la cat 
				  
				END IF;
				
			END IF;
			
		END PROCESS;


		-- output the results
		Result: PROCESS (ACC)
		BEGIN  
		
			 Quotient  <=     ACC(3 downto 0);	 
			 Remainder <= '0'&ACC(7 downto 5);
			 
		END PROCESS;

       -- Combo Control Output
		ComboFSMoutput: PROCESS(FSM_cur_State, start, sum, FSM_Stop)
		BEGIN
		
			INC_CNT <= '0';
			LD_high <= '0';--daca schimbam intermediar
			AccShift_left0 <= '0';
			AccShift_left1 <= '0';
			CASE FSM_cur_State IS 
					WHEN S0 =>
								 IF start = '1' THEN 
								 
										FSM_nx_State <= S0;
									
								 ELSIF sum(3) = '0' THEN 
								 
										FSM_nx_State <= S1;
								 
								 ELSE 
								 
										FSM_nx_State <= S2;
								 
								 END IF;
								 
					WHEN S1 =>
								 LD_high      <= '1';
								 
								 FSM_nx_State <= S3;
									
					WHEN S2 =>
								AccShift_left0 <= '1';
								
								INC_CNT        <= '1';
								
								FSM_nx_State   <= S4;
								
					WHEN S3 => 
								AccShift_left1 <= '1';
								
								INC_CNT        <= '1';
								
								FSM_nx_State   <= S4;
								
					WHEN S4 =>
								IF FSM_Stop = '1' THEN 
								
									FSM_nx_State <= S4;
									
								ELSE
								
									FSM_nx_State <= S0;
								
								END IF;
			END CASE;
			
		END PROCESS;

        -- FSM next state register	  
		RegFSM_State: PROCESS (clk, FSM_nx_State, start)
		BEGIN
		
			 IF (clk'event AND clk = '1') THEN 
			 
				  IF start ='1' THEN 
				  
						FSM_Cur_State <= S0;
				  
				  ELSE
				  
						FSM_Cur_State <= FSM_nx_State;
				  
				  END IF;
				  
			 END IF;
			 
		END PROCESS;


		-- Counter to control the iteration
		RegCounter: PROCESS(clk, start)
		BEGIN
		
			 IF clk'event AND clk = '1' THEN 
			 
				 IF start = '1' THEN
				 
						Counter <= (others => '0');
				 
				 ELSIF INC_CNT = '1' THEN
				 
						Counter <= Counter + 1;
				 
				 END IF;
				 
			 END IF;
			 
		END PROCESS;

		-- update FSM_Stop
		ComboFSMStop: PROCESS(Counter)
		BEGIN
		
			FSM_Stop <= counter(2) AND (NOT(counter(1))) AND (NOT(counter(0)));
			
		END PROCESS;

		PROCESS(FSM_Stop)
		BEGIN 
		
				Stop <= FSM_Stop;
				
		END PROCESS;

END BehavioralDivision;