-------------------------------------------------------------------------------
--
-- Title       : Data Memory
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : This VHDL code represents the data memory module of a MIPS Processor. 
--				 It is responsible for storing and retrieving data in response to memory
-- 				 access requests from the processor such as load and store requests (ldi, lh, sh). 
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Memory is
    port (
        clk: in std_logic;								   -- processor clock
        mem_access_addr: in std_logic_vector(15 downto 0); -- memory address to access
        mem_write_data: in std_logic_vector(15 downto 0);  -- write data to be written to memory address
        mem_write_en, mem_read: in std_logic;			   -- write enable and read enable
        mem_read_data: out std_logic_vector(15 downto 0)   -- read data from specified memory address
    );
end entity Data_Memory;

architecture Behavioral of Data_Memory is
    signal ram_addr: std_logic_vector(7 downto 0);						   -- memory addresses used for indexing the ram array
    type DataMemType is array (0 to 255) of std_logic_vector(15 downto 0); -- defines the array type for the ram, each are 16-bits
    signal RAM: DataMemType := (others => (others => '0'));				   -- actual ram array init with 0's
begin
    ram_addr <= mem_access_addr(8 downto 1);						   -- populate the ram addresses from memory

    process(clk)
    begin
        if rising_edge(clk) then									   -- when rising edge of clock
            if mem_write_en = '1' then								   -- and the write mem is enabled
                RAM(to_integer(unsigned(ram_addr))) <= mem_write_data; -- then we write the data to the ram at the specified ram address (ram_addr)
            end if;
        end if;
    end process;

    mem_read_data <= RAM(to_integer(unsigned(ram_addr))) when mem_read = '1' else (others => '0'); -- else read the data output based on the ram content. If the read is not enabled then it outputs 0's
end architecture Behavioral;