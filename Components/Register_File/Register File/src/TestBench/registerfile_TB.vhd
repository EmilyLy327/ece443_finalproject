library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity registerfile_tb is
end registerfile_tb;

architecture TB_ARCHITECTURE of registerfile_tb is
	-- Component declaration of the tested unit
	component registerfile
	port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		reg_write_en : in STD_LOGIC;
		reg_write_dest : in STD_LOGIC_VECTOR(2 downto 0);
		reg_write_data : in STD_LOGIC_VECTOR(15 downto 0);
		reg_read_addr_1 : in STD_LOGIC_VECTOR(2 downto 0);
		reg_read_addr_2 : in STD_LOGIC_VECTOR(2 downto 0);
		reg_read_data_1 : out STD_LOGIC_VECTOR(15 downto 0);
		reg_read_data_2 : out STD_LOGIC_VECTOR(15 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal rst : STD_LOGIC;
	signal reg_write_en : STD_LOGIC;
	signal reg_write_dest : STD_LOGIC_VECTOR(2 downto 0);
	signal reg_write_data : STD_LOGIC_VECTOR(15 downto 0);
	signal reg_read_addr_1 : STD_LOGIC_VECTOR(2 downto 0);
	signal reg_read_addr_2 : STD_LOGIC_VECTOR(2 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal reg_read_data_1 : STD_LOGIC_VECTOR(15 downto 0);
	signal reg_read_data_2 : STD_LOGIC_VECTOR(15 downto 0);
	
	constant CLOCK_PERIOD : time := 10 ns;

begin

	-- Unit Under Test port map
	UUT : registerfile
		port map (
			clk => clk,
			rst => rst,
			reg_write_en => reg_write_en,
			reg_write_dest => reg_write_dest,
			reg_write_data => reg_write_data,
			reg_read_addr_1 => reg_read_addr_1,
			reg_read_addr_2 => reg_read_addr_2,
			reg_read_data_1 => reg_read_data_1,
			reg_read_data_2 => reg_read_data_2
		);

	-- Add your stimulus here ...
	 -- Clock process
    process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        wait for 20 ns; -- Allow for initializations

        -- Test Write Operation
        rst <= '1';
        wait for CLOCK_PERIOD;
        rst <= '0';

        reg_write_en <= '1';
        reg_write_dest <= "001";  -- Write to register 1
        reg_write_data <= x"1234";  -- Data to be written
        wait for CLOCK_PERIOD;
        reg_write_en <= '0';

        -- Test Read Operation
        reg_read_addr_1 <= "001";  -- Read from register 1
        reg_read_addr_2 <= "010";  -- Read from register 2
        wait for CLOCK_PERIOD;
        
        -- Check the read data
        assert reg_read_data_1 = x"1234" report "Error: Incorrect data read from register 1" severity error;
        -- assert reg_read_data_2 = (others => '0') report "Error: Incorrect data read from register 2" severity error;

        wait;

    end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_registerfile of registerfile_tb is
	for TB_ARCHITECTURE
		for UUT : registerfile
			use entity work.registerfile(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_registerfile;

