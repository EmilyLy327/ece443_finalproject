-------------------------------------------------------------------------------
--
-- Title       : Control Unit
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : Generates the necessary control signals that control the execution
-- 				 of instructions. It interprets the opcode of an instruction and produces
--				 outputs that regulate components in the processor.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ControlUnit is
  port (
    opcode : in std_logic_vector(2 downto 0);
    reset : in std_logic;
    reg_dst, mem_to_reg, alu_op : out signed(1 downto 0);
    mem_read, mem_write, alu_src, reg_write, sign_or_zero : out std_logic
  );
end ControlUnit;

architecture Behavioral of ControlUnit is
begin
  process (reset, opcode)
  begin
    if reset = '1' then	-- reset
      reg_dst <= "00";
      mem_to_reg <= "00";
      alu_op <= "00";
      mem_read <= '0';
      mem_write <= '0';
      alu_src <= '0';
      reg_write <= '0';
      sign_or_zero <= '0';
    else
      case opcode is
        when "000" => -- signed addition (add)
          reg_dst <= "01";	   -- indicates were the result of addition should be stored among the available registers
          mem_to_reg <= "00";  -- indicates that the result from the alu is directly written to register file and not read from memory
          alu_op <= "00";	   -- tells alu to perform addition
          mem_read <= '0';	   -- no memory read operation is required for this instruction
          mem_write <= '0';	   -- no write memory operation is required for this instruction
          alu_src <= '0';	   -- implys that second operand is not an immediate value
          reg_write <= '1';	   -- signals that the result should be written back to the register file
          sign_or_zero <= '0'; -- alu should produce a result without considering signed or zero
        when "001" => -- signed multiplication (mult)
          reg_dst <= "00";
          mem_to_reg <= "00";
          alu_op <= "01";
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '0';
          reg_write <= '0';
          sign_or_zero <= '0';
        when "010" => -- passthrough A (pa)
          reg_dst <= "00";
          mem_to_reg <= "00";
          alu_op <= "10";
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '1';
          reg_write <= '0';
          sign_or_zero <= '0';
        when "011" => -- passthrough B (pb)
          reg_dst <= "00";
          mem_to_reg <= "00";
          alu_op <= "11";
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '1';
          reg_write <= '0';
          sign_or_zero <= '0';
        when "100" => -- signed subtraction (sub)
          reg_dst <= "01";
          mem_to_reg <= "00";
          alu_op <= "00";
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '1';
          reg_write <= '1';
          sign_or_zero <= '0';
        when "101" => -- load immediate (ldi)
          reg_dst <= "00";
          mem_to_reg <= "00";
          alu_op <= "01";
          mem_read <= '0';
          mem_write <= '0';
          alu_src <= '0';
          reg_write <= '1';
          sign_or_zero <= '0';
        when "110" => -- store halfword (sh)
          reg_dst <= "00";
          mem_to_reg <= "00";
          alu_op <= "10";
          mem_read <= '0';
          mem_write <= '1';
          alu_src <= '0';
          reg_write <= '0';
          sign_or_zero <= '0';
        when "111" => -- load halfword (lh)
          reg_dst <= "00";
          mem_to_reg <= "01";
          alu_op <= "11";
          mem_read <= '1';
          mem_write <= '0';
          alu_src <= '0';
          reg_write <= '0';
          sign_or_zero <= '0';
        when others => -- other
          reg_dst <= "00";
          mem_to_reg <= "00";
          alu_op <= "00";
          mem_read <= '0';		  
          mem_write <= '0';
          alu_src <= '0';
          reg_write <= '0';
          sign_or_zero <= '0';
      end case;
    end if;
  end process;
end Behavioral;
