-------------------------------------------------------------------------------
--
-- Title       : Instruction
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : this implements a basic single-cycle MIPS CPU by fetching 
-- 				instructions, decoding them, executing them, accessing memory, 
--				and writing back results. The control logic handles hazard 
--				detection and stalling.
--
-------------------------------------------------------------------------------
--NOTE:  Need to reference instruction fetch where PC counter is
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor is
    port (
        clk, reset: in std_logic;
        alu_result: out signed(15 downto 0)  
    );
end entity Processor;

architecture Structural of Processor is

    -- Instruction Fetch Signals
    signal instruction : std_logic_vector(15 downto 0);
    
    -- Instruction Decode Signals
	signal decode_opcode: std_logic_vector(2 downto 0);
    signal i_type, r_type: std_logic;   
    signal instruction_type: signed(1 downto 0);
    
    -- Datapath Signals
    signal read_data_1, read_data_2, write_data : signed(15 downto 0);
    signal alu_result_sig : signed(15 downto 0); 
    signal data_mem_read_data, data_mem_write_data : signed(15 downto 0);
    
    -- Control Signals
    signal reg_write: std_logic;
    signal mem_read, mem_write: std_logic;
	
	signal pc: std_logic_vector(15 downto 0);
	
	-- ALU Signals
	signal alu_opcode: signed(2 downto 0);
	signal alu_status: std_logic_vector(2 downto 0);

    -- NOTE:  We do not need component declarations as we're going to be calling them by instantiating that entity
		--IE ALU, Instruction Fetch, Data Memory, etc.
begin	
    -- Instantiate instruction fetch entity
    InstructionFetch_Inst: entity work.InstructionFetch
        port map(
            clk => clk,
            reset => reset,
            pc_out => pc,  
            instruction_out => instruction
        );		
		
    -- Instruction Decode  
    instr_decode : process(instruction)
	begin
    	decode_opcode <= instruction(15 downto 13);
    	i_type <= instruction(12); 
    	r_type <= instruction(11);
	end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            instruction_type <= r_type & i_type; 
        end if;
    end process;

    -- Register File
    RegisterFile_Inst: entity work.RegisterFile
       port map(
           clk => clk,
           rst => reset,
           -- Control signals
           reg_write_en => reg_write,
           -- Address signals  
           reg_read_addr_1 => instruction(11 downto 9),
           reg_read_addr_2 => instruction(8 downto 6),
           reg_write_dest => instruction(4 downto 2),
           -- Data signals
           reg_write_data => write_data,
           reg_read_data_1 => read_data_1,
           reg_read_data_2 => read_data_2
       );

    -- ALU
    ALU_Inst: entity work.ALU
        port map (
            A => read_data_1, 
            B => (others => '0'),
            R => alu_result_sig,
			sel => alu_opcode,
			status => alu_status
        );

    -- Data Memory
    DataMemory: entity work.DataMemory
        port map(
            clk => clk,
            mem_access_addr => alu_result_sig,
            mem_write_data => read_data_2, 
            mem_write_en => mem_write,
            mem_read => mem_read,
            mem_read_data => data_mem_read_data
        );

    -- Control Unit 
    ControlUnit_Inst: entity work.ControlUnit
       port map(
           opcode => instruction(15 downto 13),  
           reset => reset,
           reg_write => reg_write,
           mem_read => mem_read,
           mem_write => mem_write           
       );

    -- Writeback  
    process(clk)
    begin
        if rising_edge(clk) then  
            case instruction_type is
                when "00" => -- R-type
                    write_data <= alu_result_sig;
                    alu_result <= alu_result_sig;
                when "01" => -- I-type (load immediate) 
                    write_data <= data_mem_read_data;  
                    alu_result <= data_mem_read_data;
                when others => null;  
            end case;
        end if;
    end process;
    
end architecture Structural;