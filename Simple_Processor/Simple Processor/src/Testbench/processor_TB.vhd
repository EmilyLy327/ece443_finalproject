library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity processor_tb is
end processor_tb;

architecture TB_ARCHITECTURE of processor_tb is
	-- Component declaration of the tested unit
	component processor
	port(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		instruction : in SIGNED(15 downto 0);
		result : out SIGNED(15 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal reset : STD_LOGIC;
	signal instruction : SIGNED(15 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal result : SIGNED(15 downto 0);

	 -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

	-- Unit Under Test port map
	UUT : processor
		port map (
			clk => clk,
			reset => reset,
			instruction => instruction,
			result => result
		);

	-- Clock process definitions
   	clk_process :process
   	begin
      	clk <= not clk after clk_period/2;
      	wait for clk_period;
   	end process;

   	-- Stimulus process
   	stim_proc: process
   	begin  
      	reset <= '1';
      	wait for clk_period*10;
      	reset <= '0';

      	-- Test Scenario
      	instruction <= "0000000000000101"; -- Example R-Type instruction

      	wait for clk_period * 10;

      	instruction <= "0100000000000010"; -- Example I-Type Store instruction

      	wait;

   	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_processor of processor_tb is
	for TB_ARCHITECTURE
		for UUT : processor
			use entity work.processor(structural);
		end for;
	end for;
end TESTBENCH_FOR_processor;

