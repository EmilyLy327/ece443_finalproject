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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Processor is
    port (
        clk : in std_logic;
        reset : in std_logic;
        instruction : in std_logic_vector(15 downto 0);
        result : out std_logic_vector(15 downto 0)
    );
end entity Processor;

architecture Structural of Processor is
 	constant i_type_constant : std_logic := instruction(11);
    constant r_type_constant : std_logic := instruction(12);

    signal opcode : std_logic_vector(2 downto 0);
    signal r_type : std_logic;
    signal i_type : std_logic;
    signal r_a, r_b, r_c, r_d : std_logic_vector(3 downto 0);
    signal immediate_value : std_logic_vector(7 downto 0);

    -- Components
    component RegisterFile
        port (
            clk : in std_logic;
            reset : in std_logic;
            read_address1, read_address2, write_address : in std_logic_vector(3 downto 0);
            read_data1, read_data2 : out std_logic_vector(15 downto 0);
            write_data : in std_logic_vector(15 downto 0)
        );
    end component RegisterFile;

    component ALU
        port (
            opcode : in std_logic_vector(2 downto 0);
            operand_a, operand_b : in std_logic_vector(15 downto 0);
            result : out std_logic_vector(15 downto 0)
        );
    end component ALU;

    component DataMemory
        port (
            clk : in std_logic;
            address : in std_logic_vector(15 downto 0);
            read_data, write_data : inout std_logic_vector(15 downto 0)
        );
    end component DataMemory;

    -- Instantiate components
    signal regfile_read_data1, regfile_read_data2 : std_logic_vector(15 downto 0);
    signal alu_result : std_logic_vector(15 downto 0);
    signal data_memory_read_data, data_memory_write_data : std_logic_vector(15 downto 0);

begin
    -- Extract opcode and instruction type
    opcode <= instruction(15 downto 13);
    --r_type <= instruction(12);
    --i_type <= instruction(11);

    -- Extract fields based on instruction type
    r_a <= instruction(8 downto 5);
    r_b <= instruction(4 downto 1);
    r_c <= instruction(12 downto 9);
    r_d <= instruction(8 downto 5);
    immediate_value <= instruction(15 downto 8);

    -- Instantiate and connect components
    --RegisterFile_Inst : RegisterFile
    --    port map (
    --        clk => clk,
    --        reset => reset,
    --        read_address1 => r_a,
    --        read_address2 => r_b,
    --        write_address => r_c,
    --        read_data1 => regfile_read_data1,
    --        read_data2 => regfile_read_data2,
    --        write_data => (others => '0')
    --    );

    --ALU_Inst : ALU
    --    port map (
    --        opcode => opcode,
    --        operand_a => regfile_read_data1,
    --        operand_b => (others => '0'), -- Operand B is not used for some instructions
    --        result => alu_result
    --    );

    --DataMemory_Inst : DataMemory
    --    port map (
    --        clk => clk,
    --        address => immediate_value,
    --        read_data => data_memory_read_data,
    --        write_data => (others => '0')
    --    );

    -- Connect components based on instruction type
    process (clk)
    begin
        if rising_edge(clk) then
			i_type <= i_type_constant;
			r_type <= r_type_constant;
			
            case i_type & r_type is
                when "00" => -- R-Type
                    result <= alu_result;
                when "01" => -- I-Type, Load Immediate
                    result <= immediate_value;
                when "10" => -- I-Type, Store halfword
                    data_memory_write_data <= regfile_read_data1;
                    result <= (others => '0'); -- No result for store instructions
                when "11" => -- I-Type, Load halfword
                    result <= data_memory_read_data;
                    data_memory_write_data <= (others => '0'); -- No write for load instructions
                when others =>
                    result <= (others => '0');
            end case;
        end if;
    end process;

end architecture Structural;
