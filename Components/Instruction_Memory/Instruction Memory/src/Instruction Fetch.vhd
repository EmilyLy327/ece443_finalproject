library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;

entity InstructionFetch is
    port (
        clk: in std_logic;
        reset: in std_logic;
        pc_out: out std_logic_vector(15 downto 0);
        instruction_out: out std_logic_vector(15 downto 0)
    );
end InstructionFetch;

architecture Behavioral of InstructionFetch is

signal pc_current: std_logic_vector(15 downto 0);
signal pc_next: std_logic_vector(15 downto 0);
signal instr: std_logic_vector(15 downto 0);
	
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_current <= x"0000";
        elsif rising_edge(clk) then
            pc_current <= pc_next;
        end if;
    end process;

    pc_next <= std_logic_vector(unsigned(pc_current) + 2);

    Instruction_Memory: entity work.Instruction_Memory 
        port map (
            pc => pc_current,
            instruction => instr
        );

    process
    begin
        wait for 1 ns; -- Ensure that the instruction is available
        pc_out <= pc_current;
        instruction_out <= instr;
        wait;
    end process;
end Behavioral;
