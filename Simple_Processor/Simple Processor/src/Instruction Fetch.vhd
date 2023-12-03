-------------------------------------------------------------------------------
--
-- Title       : Instruction Fetch
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description :  This program fetches instructions and also handles
--				  instantiating the Instruction Memory
--
-------------------------------------------------------------------------------

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;

entity InstructionFetch is
    port (
        clk: in std_logic;
        reset: in std_logic;
        pc_out: out std_logic_vector(15 downto 0); 			--current program counter value	output
        instruction_out: out std_logic_vector(15 downto 0)
    );
end InstructionFetch;

architecture Behavioral of InstructionFetch is

-- Signal declarations
signal pc_current: std_logic_vector(15 downto 0);
signal pc_next: std_logic_vector(15 downto 0);
signal instr: std_logic_vector(15 downto 0);
	
begin  
	-- Program counter register process 
    -- Resets to 0x0000 on reset 
    -- Else increments pc_current with pc_next on rising edge of clock
    process(clk, reset)
    begin
        if reset = '1' then	 -- Reset set at active high
            pc_current <= x"0000";
        elsif rising_edge(clk) then
            pc_current <= pc_next;
        end if;
    end process;
	
	-- Next PC value increments current PC value by 2
    pc_next <= std_logic_vector(unsigned(pc_current) + 2);
	
	-- Instantiate instruction memory entity
    InstructionMemory: entity work.InstructionMemory 
        port map (
            pc => pc_current,
            instruction => instr
        );
	
	-- Registered output process
    process
    begin
        wait for 1 ns; 	-- Ensure that the instruction is available by waiting
        -- Output current PC and instruction
		pc_out <= pc_current;
        instruction_out <= instr;
        wait;
    end process;
end Behavioral;