-------------------------------------------------------------------------------
--
-- Title       : ALU Control Unit
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : Determines the correct control signals for the ALU. The ALUOp
-- 				 and ALU_Funct is used to determine the signal.
--
-- Example of ALU Control Unit
-- ALUOp = "00" (Arithmetic Operation)
-- 	   ALU_Funct = "000" (Addition)
--     ALU_Funct = "001" (Subtraction)
--     ALU_Funct = "010" (Multiplication)
--     ...
-- 
-- ***POINT OF INQUIRY***
-- Do we need this?? We should only have to do the arithmetic operations and nothing else 
-- I don't think we need this as this is written using our decode execute file... i think
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_control is
port(
  ALU_Control: out std_logic_vector(2 downto 0); -- Holds the correct ALU_Funct
  ALUOp : in std_logic_vector(1 downto 0);	-- specifies category of ALU operation
  ALU_Funct : in std_logic_vector(2 downto 0) -- specifies operation category
);
end ALU_control;

architecture Behavioral of ALU_control is
begin
	process(ALUOp, ALU_Funct)
	begin
		case ALUOp is
			when "00" => -- Arithmetic Operation
				ALU_Control <= ALU_Funct(2 downto 0); -- specifies arthmetic operation to perform
			when "01" => -- Logical Operation
 				ALU_Control <= "001"; -- specifies logical operation to perform
			when "10" => -- Shift Operation
 				ALU_Control <= "100"; -- specifies shift operation to perform
			when "11" => -- Default or Unrecongized Operation
 				ALU_Control <= "000";
			when others => ALU_Control <= "000";
		end case;
	end process;
end Behavioral;