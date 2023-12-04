-------------------------------------------------------------------------------
--
-- Title       : Instruction Memory Testbench 
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description :  TB
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionMemory_tb is
end InstructionMemory_tb;

architecture TB_ARCHITECTURE of InstructionMemory_tb is
    signal pc : unsigned(3 downto 0) := (others => '0');  -- Initializing program counter as unsigned
    signal instruction : std_logic_vector(15 downto 0);  -- Signal to capture output instruction
    
    constant CLOCK_PERIOD : time := 10 ns;  -- Clock period of 10 ns
    
    -- Clock generation process
    procedure CLK_GEN is
    begin
        wait for CLOCK_PERIOD / 2;
        pc <= pc + 1;  -- Incrementing the program counter
    end CLK_GEN;
    
begin
    -- Instantiate the InstructionMemory module
    UUT : entity work.InstructionMemory
        port map (
            pc => std_logic_vector(pc),  -- Passing pc as std_logic_vector
            instruction => instruction
        );
        
    -- Clock generation process instantiation
    CLK_PROCESS: process
    begin
        for i in 0 to 15 loop  -- Simulating for 16 clock cycles
            CLK_GEN;  		   -- Calling clock generation procedure
        end loop;
        wait;  				   -- Stop simulation
    end process;
end TB_ARCHITECTURE;



