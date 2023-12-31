-------------------------------------------------------------------------------
--
-- Title       : Instruction Decode
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

entity InstructionDecode is
    port (
        clk: in std_logic;
        reset: in std_logic;
        instruction_in: in std_logic_vector(15 downto 0);
        decode_opcode: out std_logic_vector(2 downto 0);
        i_type: out std_logic;
        r_type: out std_logic;
        reg_read_addr_1: out std_logic_vector(2 downto 0);
        reg_read_addr_2: out std_logic_vector(2 downto 0);
        reg_write_dest: out std_logic_vector(2 downto 0);
        sign_or_zero: out std_logic;
        alu_src: out std_logic;
        reg_dist: out std_logic_vector(1 downto 0);
        mem_to_reg_signal: out std_logic_vector(1 downto 0);
        alu_op_signal: out std_logic_vector(1 downto 0)
    );
end InstructionDecode;

architecture Behavioral of InstructionDecode is
    -- Internal signals and components
    --signal decode_opcode: std_logic_vector(2 downto 0);
    --signal i_type, r_type: std_logic;
    --signal instruction_type: signed(1 downto 0);
	
	--signal reg_dist: std_logic_vector(1 downto 0);
	--signal mem_to_reg_signal: std_logic_vector(1 downto 0);
	--signal alu_op_signal: std_logic_vector(2 downto 0);
	--signal sign_or_zero: std_logic;
	--signal alu_src: std_logic;


begin
    -- Instruction Decode
    --instr_decode : process(instruction_in)
    --begin
    --    decode_opcode <= instruction_in(15 downto 13);
    --    i_type <= instruction_in(12);
    --    r_type <= instruction_in(11);
    --end process;

    process(clk, reset)
	begin
	    if rising_edge(clk) then
	        instruction_type <= r_type & i_type;
	
	        -- Generate control signals based on instruction type
	        case instruction_type is
	            when "00" => -- R-type
	                -- Set control signals for R-type instructions
	                reg_dist <= "00";
	                mem_to_reg_signal <= "00";
	                alu_op_signal <= "000";
	                sign_or_zero <= '0';
	                alu_src <= '0';
	                -- Set other control signals as needed
	
	            when "01" => -- I-type (load immediate)
	                -- Set control signals for I-type instructions
	                reg_dist <= "01";
	                mem_to_reg_signal <= "01";
	                alu_op_signal <= "000";
	                sign_or_zero <= '1';
	                alu_src <= '1';
	                -- Set other control signals as needed
	
	            when others =>
	                -- Handle other instruction types if needed
	        end case;
	    end if;
	end process;

    -- Add other logic as needed for instruction decoding

end architecture Behavioral;
