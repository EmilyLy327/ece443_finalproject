library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity data_memory_tb is
end data_memory_tb;

architecture TB_ARCHITECTURE of data_memory_tb is
	-- Component declaration of the tested unit
	component data_memory
	port(
		clk : in STD_LOGIC;
		mem_access_addr : in STD_LOGIC_VECTOR(15 downto 0);
		mem_write_data : in STD_LOGIC_VECTOR(15 downto 0);
		mem_write_en : in STD_LOGIC;
		mem_read : in STD_LOGIC;
		mem_read_data : out STD_LOGIC_VECTOR(15 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal mem_access_addr : STD_LOGIC_VECTOR(15 downto 0);
	signal mem_write_data : STD_LOGIC_VECTOR(15 downto 0);
	signal mem_write_en : STD_LOGIC;
	signal mem_read : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal mem_read_data : STD_LOGIC_VECTOR(15 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : data_memory
		port map (
			clk => clk,
			mem_access_addr => mem_access_addr,
			mem_write_data => mem_write_data,
			mem_write_en => mem_write_en,
			mem_read => mem_read,
			mem_read_data => mem_read_data
		);

	-- Setting the clock process
    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

     -- Testing the read and write
    process
    begin
        -- initializing the memory address 1 with random data
        mem_write_en <= '1';				   -- enabling writing
        mem_access_addr <= "0000000000000001"; -- selecting address 1
        mem_write_data <= "1111000011110000"; -- writing data to address 1 (61680 in decimal)
        wait for 10 ns;

        -- reading from memory address 1
        mem_read <= '1';					   -- enabling reading
        mem_access_addr <= "0000000000000001"; -- reading from address 1
        wait for 10 ns;

        -- writing to address 2
        mem_read <= '0';		  			  -- disabiling reading
        mem_write_en <= '1';				  -- enabling writing
        mem_access_addr <= "0000000000000010"; -- selecting address 2
        mem_write_data <= "0000111100001111"; -- writing random data to address 2 (3855 in decimal)
        wait for 10 ns;

        -- reading from address 2
        mem_read <= '1';					   -- enabling reading
        mem_access_addr <= "0000000000000010"; -- reading from address 2
        wait for 10 ns;

        wait;
    end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_data_memory of data_memory_tb is
	for TB_ARCHITECTURE
		for UUT : data_memory
			use entity work.data_memory(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_data_memory;

