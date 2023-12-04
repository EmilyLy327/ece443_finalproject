-------------------------------------------------------------------------------
--
-- Title       : Instruction Execute
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionExecute is
    port (
        clk: in std_logic;                                -- Clock input
        reset: in std_logic;                              -- Reset input
        decode_opcode: in std_logic_vector(2 downto 0);   -- Decoded opcode from Instruction Decode stage
        i_type: in std_logic;                             -- Instruction type flag from Instruction Decode stage
        r_type: in std_logic;                             -- Instruction type flag from Instruction Decode stage
        read_data_1: in std_logic_vector(15 downto 0);    -- Data read from register file 1
        read_data_2: in std_logic_vector(15 downto 0);    -- Data read from register file 2
        instruction: in std_logic_vector(15 downto 0);    -- Instruction input
        reg_write_dest: in std_logic_vector(2 downto 0);  -- Destination register for writeback
        sign_extend_immediate: in std_logic_vector(15 downto 0);  -- Sign-extended immediate value
        sign_or_zero: in std_logic;                       -- Flag for sign or zero extension
        alu_src: in std_logic;                            -- ALU source selector
        alu_opcode: in signed(2 downto 0);                -- ALU operation code
        mem_write: in std_logic;                          -- Memory write enable signal
        alu_result_sig: out signed(15 downto 0);          -- ALU result output
        write_data: out std_logic_vector(15 downto 0)     -- Data to be written to memory or register file
    );
end entity InstructionExecute;

architecture Behavioral of InstructionExecute is
    signal immediate_extend: std_logic_vector(15 downto 0);  -- Extended immediate value
    signal data_mem_read_data: signed(15 downto 0);          -- Data read from memory

begin
    process (clk, reset)
    begin
        if reset = '1' then
            -- Reset condition: Initialize or reset internal signals

        elsif rising_edge(clk) then
            -- On rising edge of clock when not in reset
            -- Need Execution logic for processor instructions like memory access, ALU ops
            
        end if;
    end process;
end architecture Behavioral;
