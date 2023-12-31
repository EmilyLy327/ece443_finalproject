-------------------------------------------------------------------------------
--
-- Title       : Instruction Memory
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description :  This is where the instructions are stored.  Need this in this
--				  component as its' being called in the Instruction Fetch entity
--
-------------------------------------------------------------------------------

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  

entity InstructionMemory is
    port (
        pc: in std_logic_vector(15 downto 0);
        instruction: out std_logic_vector(15 downto 0)
    );
end InstructionMemory;

architecture Behavioral of InstructionMemory is
	signal rom_address: std_logic_vector(7 downto 0);
	-- ldi $r0, 10
	-- ldi $r1, 5
	-- ldi $r2, 0
	-- ldi $r3, 0
	-- ldi $r4, 0
	-- ldi $r5, 0
	-- ldi $r6, 0
	-- ldi $r7, 0
	-- add $r2, $r0, $r1
	-- mult $r3, $r0, $r1
	-- sub $r4, $r0, $r1
	-- sh $r3, 0x0B
	-- sh $r4, 0x0A
	-- lh $r6, 0x0A
	-- lh $r7, 0x0B
    type ROM_type is array (0 to 255) of std_logic_vector(15 downto 0);  -- 256 RAM
    constant rom_data: ROM_type := (
	X"500A", 
	X"5105", 
	X"5200", 
	X"5300", 
	X"5400", 
	X"5500", 
	X"5600", 
	X"5700",
    X"0201", 
	X"1301", 
	X"4401", 
	X"630B", 
	X"640A", 
	X"760A", 
	X"770B", 
	others => X"0000"
    );
	
begin
    rom_address <= pc(7 downto 0);	-- 8 bit PC address space
    instruction <= rom_data(to_integer(unsigned(rom_address)));
	
end Behavioral;