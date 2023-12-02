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

/* 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor is
    port (
		clk,reset: in std_logic;
		alu_result: out signed(15 downto 0)
	);
end entity Processor;

architecture Structural of Processor is

	-- instruction decoding/encoding signals
    signal opcode : signed(2 downto 0);
    signal internal_i_type, internal_r_type : std_logic; -- store bits from the instruction signal that represent the type of instruction
    signal i_type_reg, r_type_reg : std_logic; -- intermediate signals to hold instruction decode fields   
	signal instruction_type : signed(1 downto 0);
	signal instruction: signed(15 downto 0);
	
	-- instruction fields for signals 
	signal immediate_value : signed(15 downto 0);
	--signal source_register, destination_register, source_operand, destination_operand : signed(3 downto 0);
	
	-- control signals
	signal write_enable : std_logic;
	signal mem_read_en, mem_write_en : std_logic;
	
	-- ALU signals
	signal regfile_read_data1, regfile_read_data2 : signed(15 downto 0);
	signal ALU_Output: signed(15 downto 0);
	
	-- data memory signals
    signal data_memory_read_data, data_memory_write_data : signed(15 downto 0);	
		
	-- register file signals
	signal write_addr, read_addr_1, read_addr_2 : signed(2 downto 0);
 	signal write_data, read_data_1, read_data_2: signed(15 downto 0);
	 
	-- memory signals
	signal mem_read_data: signed(15 downto 0);
	
	-- control unit signals
	--signal cu_reg_dst, cu_mem_to_reg, cu_alu_op : signed(1 downto 0);
    --signal cu_alu_src, cu_reg_write, cu_sign_or_zero : std_logic;
	signal reg_dst, mem_to_reg, alu_op: signed(1 downto 0);
 	signal mem_read, mem_write, alu_src, reg_write: std_logic;
	signal sign_or_zero: std_logic;
	
	-- other signals
	signal result : signed(15 downto 0);
	
 	-- COMPONENTS
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
            sel : in signed(2 downto 0);   -- opcode
            A, B : in signed(15 downto 0); -- operand's A & B
            R : out signed(15 downto 0)	   -- ALU result
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
	
	component InstructionMemory is
	    port (
	        pc: in signed(15 downto 0);
	        instruction: out signed(15 downto 0)
	    );
	end component InstructionMemory;
	
	component ControlUnit is
	  port (
	    opcode : in signed(2 downto 0);
	    reset : in std_logic;
	    reg_dst, mem_to_reg, alu_op : out signed(1 downto 0);
	    mem_read, mem_write, alu_src, reg_write, sign_or_zero : out std_logic
	  );
	end component ControlUnit;
	
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
	
	read_addr_1 <= instruction(12 downto 10);
 	read_addr_2 <= instruction(9 downto 7);
	 
	RegisterFile_Inst : RegisterFile
        port map (
            clk => clk,
            rst => reset,
			reg_write_en => write_enable,
            reg_read_addr_1 => read_addr_1,
            reg_read_addr_2 => read_addr_2,
            reg_write_dest => write_addr,
            reg_read_data_1 => read_data_1,
            reg_read_data_2 => read_data_2,
            reg_write_data => write_data
        );

    ALU_Inst : ALU
        port map (
            sel => opcode,
            A => regfile_read_data1,
            B => (others => '0'), -- Operand B is not used for some instructions
            R => ALU_Output
        );
		
	--ControlUnit_Inst: ControlUnit
    --   port map (
    --        opcode => opcode,
    --        reset => reset,
    --        reg_dst => cu_reg_dst,
    --        mem_to_reg => cu_mem_to_reg,
    --        alu_op => cu_alu_op,
    --        mem_read => mem_read_en,
    --        mem_write => mem_write_en,
    --        alu_src => cu_alu_src,
    --        reg_write => cu_reg_write,
    --        sign_or_zero => cu_sign_or_zero
    --    );
	
	Control: entity work.ControlUnit
   		port map
   		(reset => reset,
    		opcode => opcode,
    		reg_dst => reg_dst,
    		mem_to_reg => mem_to_reg,
    		alu_op => alu_op,
    		mem_read => mem_read,
    		mem_write => mem_write,
    		alu_src => alu_src,
    		reg_write => reg_write,
    		sign_or_zero => sign_or_zero
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
                    result <= ALU_Output;
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
        
		--if rising_edge(clk) then

  			-- Check R-type control signals
    		--if reg_write = '1' and alu_src = '0' then  
       			result <= ALU_output;
       
    		-- Check I-type load immediate  
    		--elsif mem_to_reg = "01" and mem_read = '1' then
       			result <= immediate_value; 

    		-- Check I-type store  
    		--elsif mem_write = '1' and alu_src = '1' then
       		--	data_memory_write_data <= regfile_read_data1;
       			--result <= (others => '0');
       
    		-- Check I-type load     
    		--elsif mem_to_reg = "10" and mem_read = '1' then
       			--result <= data_memory_read_data;
       			--data_memory_write_data <= (others => '0'); 

    		--else  
       			--result <= (others => '0');
    		--end if;
		
		end if;
    end process;
	alu_result <= result;
end architecture Structural;
*/

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Processor is
    port (
        clk, reset: in std_logic;
        alu_result: out signed(15 downto 0) 
    );
end Processor;

architecture Structural of Processor is

    -- Program Counter
    signal pc_counter : signed(15 downto 0);
    
    -- Instruction Memory
    signal pc : in std_logic_vector(15 downto 0);
    signal instruction : out std_logic_vector(15 downto 0);
    
	-- Instruction decoding
    signal opcode : std_logic_vector(2 downto 0);
    signal i_type, r_type : std_logic; 
    signal instruction_type : signed(1 downto 0);
    
    -- Register File 
    signal write_data, read_data_1, read_data_2 : signed(15 downto 0);
    signal write_addr, read_addr_1, read_addr_2: signed(2 downto 0);  

    -- ALU
    signal alu_result_s : signed(15 downto 0);

    -- Data Memory  
    signal data_mem_write_data, data_mem_read_data : signed(15 downto 0);
    
    -- Control Signals
    signal reg_write : std_logic;
    signal mem_read, mem_write : std_logic;
	
begin

    -- Program Counter
    pc_counter : process(clk) 
    begin
        if reset = '1' then
           pc_counter <= (others => '0');
        elsif rising_edge(clk) then
           pc_counter <= pc_counter + 1; 
        end if;
    end process;

    -- Instruction Memory
    InstructionMemory: entity work.InstructionMemory 
        port map(
            pc_counter => pc,
            instruction => instruction
        );

    -- Instruction Decode  
    instr_decode : process(instruction)
	begin
    	opcode <= instruction(15 downto 13);
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
        port map(
            sel => opcode,
            A => read_data_1, 
            B => (others => '0'),
            R => alu_result_s  
        );

    -- Data Memory
    DataMemory: entity work.DataMemory
        port map(
            clk => clk,
            mem_access_addr => alu_result_s,
            mem_write_data => read_data_2, 
            mem_write_en => mem_write,
            mem_read => mem_read,
            mem_read_data => data_mem_read_data
        );

    -- Control Unit 
    ControlUnit: entity work.ControlUnit
       port map(
           opcode => opcode,  
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
                    write_data <= alu_result_s;
                    alu_result <= alu_result_s;
                when "01" => -- I-type (load immediate) 
                    write_data <= data_mem_read_data;  
                    alu_result <= data_mem_read_data;
                when others => null;  
            end case;
        end if;
    end process;
    
end architecture Structural;