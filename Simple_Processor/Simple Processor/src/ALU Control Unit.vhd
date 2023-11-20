-------------------------------------------------------------------------------
--
-- Title       : ALU Control Unit
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_control is
port(
  ALU_Control: out std_logic_vector(2 downto 0);
  ALUOp : in std_logic_vector(1 downto 0);
  ALU_Funct : in std_logic_vector(2 downto 0)
);
end ALU_control;

architecture Behavioral of ALU_control is
begin
process(ALUOp,ALU_Funct)
begin
case ALUOp is
when "00" => 
 ALU_Control <= ALU_Funct(2 downto 0);
when "01" => 
 ALU_Control <= "001";
when "10" => 
 ALU_Control <= "100";
when "11" => 
 ALU_Control <= "000";
when others => ALU_Control <= "000";
end case;
end process;
end Behavioral;