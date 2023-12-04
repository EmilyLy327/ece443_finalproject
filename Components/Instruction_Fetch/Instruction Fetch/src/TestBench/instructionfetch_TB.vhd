library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity instructionfetch_tb is
end instructionfetch_tb;

architecture TB_ARCHITECTURE of instructionfetch_tb is
	-- Component declaration of the tested unit
	component instructionfetch
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		pc_out : out STD_LOGIC_VECTOR(15 downto 0);
		instruction_out : out STD_LOGIC_VECTOR(15 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal pc_out : STD_LOGIC_VECTOR(15 downto 0);
	signal instruction_out : STD_LOGIC_VECTOR(15 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : instructionfetch
		port map (
			clk => clk,
			reset => reset,
			pc_out => pc_out,
			instruction_out => instruction_out
		);
		
	-- clock process
    process
    begin
        while true loop
            wait for 5 ns;
            clk <= not clk;
        end loop;
    end process;

    -- reset process
    process
    begin
        wait for 10 ns;
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait;
    end process;

	-- Add your stimulus here ...

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_instructionfetch of instructionfetch_tb is
	for TB_ARCHITECTURE
		for UUT : instructionfetch
			use entity work.instructionfetch(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_instructionfetch;

