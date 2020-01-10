----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:26:43 10/23/2019 
-- Design Name: 
-- Module Name:    Ripple - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY Adder8 IS PORT (
Cin: IN STD_LOGIC;
A, B: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
Cout: OUT STD_LOGIC;
SUM: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END Adder8;
ARCHITECTURE Structural OF Adder8 IS

COMPONENT add_1 PORT (
cin, a, b: IN STD_LOGIC;
cout, s: OUT STD_LOGIC);
END COMPONENT;

SIGNAL Carryv: STD_LOGIC_VECTOR(16 DOWNTO 0);

BEGIN
Carryv(0) <= Cin;
Adder: FOR k IN 15 DOWNTO 0 GENERATE
FullAdder: add_1 PORT MAP (Carryv(k), A(k), B(k), Carryv(k+1), SUM(k));
END GENERATE Adder;
Cout <= Carryv(16);
END Structural;
