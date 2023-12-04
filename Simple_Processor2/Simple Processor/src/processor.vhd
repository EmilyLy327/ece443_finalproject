-------------------------------------------------------------------------------
--
-- Title       : Instruction
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : this is the processor. all components are combine here
--
-------------------------------------------------------------------------------

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
    signal read_data_1, read_data_2, write_data : std_logic_vector(15 downto 0);
    signal alu_result_sig : signed(15 downto 0);
    signal data_mem_read_data, data_mem_write_data : signed(15 downto 0);

    -- Control Signals
    signal reg_write, mem_read, mem_write: std_logic;

    -- Control Unit Signals
    signal reg_dist: std_logic_vector(1 downto 0);
    signal mem_to_reg_signal: std_logic_vector(1 downto 0);
    signal alu_op_signal: std_logic_vector(1 downto 0);
    signal sign_or_zero, alu_src: std_logic;

    -- Register Signals
    signal reg_write_dest: std_logic_vector(2 downto 0);

    signal pc: std_logic_vector(15 downto 0);

    -- ALU Signals
    signal alu_status: std_logic_vector(2 downto 0);

    -- Other Signals
    signal temp_sig: std_logic_vector(8 downto 0);
    signal sign_extend_immediate, zero_extend_immediate, immediate_extend: std_logic_vector(15 downto 0);

    component InstructionFetch
        port (
            clk: in std_logic;
            reset: in std_logic;
            pc_out: out std_logic_vector(15 downto 0);
            instruction_out: out std_logic_vector(15 downto 0)
        );
    end component;

    component ALU
        port (
            A, B: in signed(15 downto 0);
            R: out signed(15 downto 0);
            sel: in signed(2 downto 0);
            status: out std_logic_vector(2 downto 0)
        );
    end component;

    component DataMemory
        port (
            clk: in std_logic;
            mem_access_addr: in signed(15 downto 0);
            mem_write_data: in signed(15 downto 0);
            mem_write_en, mem_read: in std_logic;
            mem_read_data: out signed(15 downto 0)
        );
    end component;

    component ControlUnit
        port (
            opcode: in std_logic_vector(2 downto 0);
            reset: in std_logic;
            reg_dst, mem_to_reg : out std_logic_vector(1 downto 0);
            alu_op: out std_logic_vector(1 downto 0);
            reg_write, mem_read, mem_write, alu_src, sign_or_zero: out std_logic
        );
    end component;

begin
    InstructionFetch_Inst: InstructionFetch
        port map (
            clk => clk,
            reset => reset,
            pc_out => pc,
            instruction_out => instruction
        );

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

    ALU_Inst: alu
        port map (
            A => signed(read_data_1),
            B => signed(read_data_2),
            R => alu_result_sig,
            sel => signed(alu_op_signal),
            status => alu_status
        );

    DataMemory_Inst: DataMemory
        port map (
            clk => clk,
            mem_access_addr => alu_result_sig,
            mem_write_data => signed(read_data_2),
            mem_write_en => mem_write,
            mem_read => mem_read,
            mem_read_data => data_mem_read_data
        );

    ControlUnit_Inst: ControlUnit
        port map (
            opcode => instruction(15 downto 13),
            reset => reset,
            reg_dst => reg_dist,
            mem_to_reg => mem_to_reg_signal,
            alu_op => alu_op_signal,
            reg_write => reg_write,
            mem_read => mem_read,
            mem_write => mem_write,
            alu_src => alu_src,
            sign_or_zero => sign_or_zero
        );

    -- Writeback
    process(clk)
    begin
        if rising_edge(clk) then
            case instruction_type is
                when "00" => -- R-type
                    write_data <= std_logic_vector(alu_result_sig);
                    alu_result <= alu_result_sig;
                when "01" => -- I-type (load immediate)
                    write_data <= std_logic_vector(data_mem_read_data);
                    alu_result <= data_mem_read_data;
                when others => null;
            end case;
        end if;
    end process;

end architecture Structural;

