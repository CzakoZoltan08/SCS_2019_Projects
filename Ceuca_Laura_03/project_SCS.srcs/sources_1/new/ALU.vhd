library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;

entity ALU is
port(
    sw: in std_logic_vector(15 downto 0); 
    clk : in STD_LOGIC;
    reset  : in STD_LOGIC;
    anode : out STD_LOGIC_VECTOR (7 downto 0);
    catode : out STD_LOGIC_VECTOR (6 downto 0);
    mult_btn, div_btn: in std_logic;
    confirm_number, confirm_sel: in std_logic
);
end ALU;

architecture Behavioral of ALU is

component displ_7seg is
	port ( clk, rst : in std_logic;
		    data_16 : in std_logic_vector (15 downto 0);
		    data_8: in std_logic_vector(11 downto 0);
		    sseg : out std_logic_vector (6 downto 0);
		    an : out std_logic_vector (7 downto 0));
end component;

component bin_to_BCD is
    generic(N: positive := 16);
    port(
        clk, reset: in std_logic;
        binary_in: in std_logic_vector(N-1 downto 0);
        bcd0, bcd1, bcd2, bcd3, bcd4: out std_logic_vector(3 downto 0)
    );
end component ;

component Multiplier is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
           y : in  STD_LOGIC_VECTOR (31 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component Divider is
    Port ( x : in  STD_LOGIC_VECTOR (31 downto 0);
           y : in  STD_LOGIC_VECTOR (31 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal first_operand: std_logic_vector(31 downto 0) := "00010011100000001001011000010000";
signal second_operand: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal exp_bcd: std_logic_vector(7 downto 0);
signal mantissa_bcd: std_logic_vector(15 downto 0);
signal result: std_logic_vector(31 downto 0);
signal result_mult, result_div: std_logic_vector(31 downto 0);
signal bcd_exp0, bcd_exp1, bcd_exp2, bcd_exp3: std_logic_vector(3 downto 0);
signal bcd_man0, bcd_man1, bcd_man2, bcd_man3: std_logic_vector(3 downto 0);
signal bcd_mantissa: std_logic_vector(15 downto 0);
signal bcd_exponent: std_logic_vector(11 downto 0);
signal real_exponent: std_logic_vector(11 downto 0);

begin
    -- Process that reads/loads inputs --
    input_demux: process(confirm_number, confirm_sel)
        variable input_sw: std_logic_vector(15 downto 0);
        variable sel: std_logic_vector(1 downto 0);
    begin
        if(confirm_number = '1') then
            input_sw(15 downto 0) := sw(15 downto 0);
        end if;
        
        if(confirm_sel = '1') then
        sel := sw(1 downto 0);
            case sel is
                when "00" => first_operand(31 downto 16) <= input_sw(15 downto 0);
                when "01" => first_operand(15 downto 0)  <= input_sw(15 downto 0);
                when "10" => second_operand(31 downto 16) <= input_sw(15 downto 0);
                when "11" => second_operand(15 downto 0) <= input_sw(15 downto 0);
                when others => NULL;
            end case;
        end if;
    end process;
    
    operation: process(mult_btn, div_btn, clk)
    begin
        if(mult_btn = '1') then
            result <= result_mult;
        elsif (div_btn = '1') then
            result <= result_div;
        end if;
    end process;

    multiplication: Multiplier port map(x => first_operand, y => second_operand, z => result_mult);
    division: Divider port map(x => first_operand, y => second_operand, z => result_div);
    real_exponent <= "0000" & result(30 downto 23);
    bin_to_bcd_exp: bin_to_BCD generic map(n => 12)
                        port map(clk => clk, reset => reset, binary_in => real_exponent, bcd0 => bcd_exp0, bcd1 => bcd_exp1, bcd2 => bcd_exp2, bcd3 => bcd_exp3);
    bin_to_bcd_man: bin_to_BCD generic map(n => 16)
                        port map(clk => clk, reset => reset, binary_in => result(22 downto 7), bcd0 => bcd_man0, bcd1 => bcd_man1, bcd2 => bcd_man2, bcd3 => bcd_man3);
                        
   bcd_mantissa <= bcd_man3 & bcd_man2 & bcd_man1 & bcd_man0;
   bcd_exponent <= bcd_exp2 & bcd_exp1 & bcd_exp0;
   
    display: displ_7seg port map(clk => clk,rst => reset,data_16 => bcd_mantissa, data_8 => bcd_exponent, sseg =>catode,an => anode);
end Behavioral;