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
        instruction : in signed(15 downto 0);
        result : out signed(15 downto 0)  
    );
end entity Processor;

architecture Structural of Processor is

    signal opcode : signed(2 downto 0);
    signal internal_i_type, internal_r_type : std_logic; -- store bits from the instruction signal that represent the type of instruction
    signal i_type_reg, r_type_reg : std_logic; -- intermediate signals to hold instruction decode fields   
	signal source_register, destination_register, source_operand, destination_operand : signed(3 downto 0);
    
    -- updated immediate value length 
    signal immediate_value : signed(15 downto 0);
	
	signal reg_write_enable : std_logic;
	
	
 -- components
    component RegisterFile
        port (
            clk : in std_logic;
            rst : in std_logic;
			reg_write_en : in std_logic;
            reg_read_addr_1, reg_read_addr_2, reg_write_dest : in signed(2 downto 0);
            reg_read_data_1, reg_read_data_2 : out signed(15 downto 0);
            reg_write_data : in signed(15 downto 0)
        );
    end component RegisterFile;

    component ALU
        port (
            sel : in signed(2 downto 0); -- opcode
            A, B : in signed(15 downto 0); -- operand's A & B
            R : out signed(15 downto 0)	 -- ALU result
        );
    end component ALU;

    component DataMemory
        port (
            clk: in std_logic;					
        	mem_access_addr: in signed(15 downto 0);
        	mem_write_data: in signed(15 downto 0);
        	mem_write_en, mem_read: in std_logic;
        	mem_read_data: out signed(15 downto 0)
        );
    end component DataMemory;

    signal regfile_read_data1, regfile_read_data2 : signed(15 downto 0);
    signal alu_result : signed(15 downto 0);
    signal data_memory_read_data, data_memory_write_data : signed(15 downto 0);	
	signal instruction_type : std_logic_vector(1 downto 0);	
	
	signal reg_write_dest, reg_read_addr_1, reg_read_addr_2 : signed(2 downto 0);
 	signal reg_write_data, reg_read_data_1, reg_read_data_2: signed(15 downto 0);
	 
	signal mem_read_en, mem_write_en : std_logic;
	signal mem_read_data: signed(15 downto 0);
	
begin

    -- extract opcode and instruction decode fields
    opcode <= instruction(15 downto 13);  
    
    internal_i_type <= instruction(11);  
    internal_r_type <= instruction(12);

   -- instruction decoding logic
   process(clk) 
   begin
     if rising_edge(clk) then  
       i_type_reg <= internal_i_type;
       r_type_reg <= internal_r_type;
	   instruction_type <= i_type_reg & r_type_reg;
     end if;
   end process;
	
    -- extract fields based on instruction type
    --source_register <= instruction(8 downto 5);
    --destination_register <= instruction(4 downto 1);
    --source_operand <= instruction(12 downto 9);
    --destination_operand <= instruction(8 downto 5);
    --immediate_value <= instruction(15 downto 0);   -- this seems wrong but won't compile with the last 8 bits
	
	reg_read_addr_1 <= instruction(12 downto 10);
 	reg_read_addr_2 <= instruction(9 downto 7);
	 
	RegisterFile_Inst : RegisterFile
        port map (
            clk => clk,
            rst => reset,
			reg_write_en => reg_write_enable,
            reg_read_addr_1 => reg_read_addr_1,
            reg_read_addr_2 => reg_read_addr_2,
            reg_write_dest => reg_write_dest,
            reg_read_data_1 => reg_read_data_1,
            reg_read_data_2 => reg_read_data_2,
            reg_write_data => reg_write_data
        );

    ALU_Inst : ALU
        port map (
            sel => opcode,
            A => regfile_read_data1,
            B => (others => '0'), -- Operand B is not used for some instructions
            R => alu_result
        );

    DataMemory_Inst : DataMemory
        port map (
			clk => clk,
			mem_access_addr => alu_result,
            mem_write_data => reg_read_data_2,
			mem_write_en => mem_write_en,
			mem_read => mem_read_en,
			mem_read_data => mem_read_data
        );


	-- initialization or assignment of values
	i_type_reg <= '0'; -- Assign initial value
	r_type_reg <= '1'; -- Assign initial value
	
	-- main Process
    -- connect components based on instruction type
    process (clk)
    begin
        if rising_edge(clk) then
			-- Case statement with intermediate signals
             case instruction_type is
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
