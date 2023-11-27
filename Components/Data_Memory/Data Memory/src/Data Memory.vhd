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
        clk: in std_logic;
        mem_access_addr: in std_logic_vector(15 downto 0);
        mem_write_data: in std_logic_vector(15 downto 0);
        mem_write_en, mem_read: in std_logic;
        mem_read_data: out std_logic_vector(15 downto 0)
    );
end entity Data_Memory;

architecture Behavioral of Data_Memory is
    signal ram_addr: std_logic_vector(7 downto 0);
    type DataMemType is array (0 to 255) of std_logic_vector(15 downto 0);
    signal RAM: DataMemType := (others => (others => '0'));
begin
    ram_addr <= mem_access_addr(8 downto 1);

    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write_en = '1' then
                RAM(to_integer(unsigned(ram_addr))) <= mem_write_data;
            end if;
        end if;
    end process;

    mem_read_data <= RAM(to_integer(unsigned(ram_addr))) when mem_read = '1' else (others => '0');
end architecture Behavioral;

