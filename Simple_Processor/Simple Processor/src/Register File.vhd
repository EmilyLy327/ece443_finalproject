-------------------------------------------------------------------------------
--
-- Title       : Register File
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : 
--				
-- clk -> clock, rst -> reset, and reg_write_en -> enable write signal
-- reg_write_dest -> input port for write destination register address (3 bits)
-- reg_write_data -> input port for the data to be written to (16 bits)
-- reg_read_addr_1 & 2 -> input ports for the read addresses of the registers (3 bits each)
-- reg_read_data_1 & 2 -> output ports for the data read from the registers (16 bits each)
--
-------------------------------------------------------------------------------
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    port (
        clk, rst, reg_write_en: in std_logic;
        reg_write_dest: in std_logic_vector(2 downto 0);
        reg_write_data: in std_logic_vector(15 downto 0);
        reg_read_addr_1, reg_read_addr_2: in std_logic_vector(2 downto 0);
        reg_read_data_1, reg_read_data_2: out std_logic_vector(15 downto 0)
    );
end entity RegisterFile;

architecture Behavioral of RegisterFile is
    type RegArrayType is array (0 to 7) of std_logic_vector(15 downto 0); -- represents the registers where each holds 16 bits
    signal reg_array: RegArrayType;	-- signal of type RegArrayType so that we can store the register values
begin
    process (clk, rst)
    begin
        if rst = '1' then -- if we reset then
            reg_array <= ( -- set all 8 registers to 0
                x"0000", x"0000", x"0000", x"0000",
                x"0000", x"0000", x"0000", x"0000"
            );
        elsif rising_edge(clk) then -- if rising edge of clock we then instead want to start writing
            if reg_write_en = '1' then -- but only when the register write is enabled do we want to write to one of the registers
                reg_array(to_integer(unsigned(reg_write_dest))) <= reg_write_data; -- we write to the specified register via the register destination (i.e. index of array)															
            end if;																   -- and finally write the register write data to it 
        end if;
    end process;

    -- Read operation
    reg_read_data_1 <= reg_array(to_integer(unsigned(reg_read_addr_1))); -- assigned the value stored in reg_read_addr_1
    reg_read_data_2 <= reg_array(to_integer(unsigned(reg_read_addr_2))); -- assigned the value stored in reg_read_addr_2
end architecture Behavioral;