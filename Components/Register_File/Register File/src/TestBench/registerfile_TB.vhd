-------------------------------------------------------------------------------
--
-- Title       : Register File Testbench
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : TB for all 8 Registers
--
-------------------------------------------------------------------------------

library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

entity registerfile_tb is
end registerfile_tb;

architecture TB_ARCHITECTURE of registerfile_tb is
	-- Component declaration of the tested unit
	component registerfile
	port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		reg_write_en : in STD_LOGIC;
		reg_write_dest : in SIGNED(2 downto 0);
		reg_write_data : in SIGNED(15 downto 0);
		
		reg_read_addr_1: in signed(2 downto 0);
		reg_read_addr_2: in signed(2 downto 0);
		reg_read_addr_3: in signed(2 downto 0);
		reg_read_addr_4: in signed(2 downto 0);
		reg_read_addr_5: in signed(2 downto 0);
		reg_read_addr_6: in signed(2 downto 0);
		reg_read_addr_7: in signed(2 downto 0);
		reg_read_addr_8: in signed(2 downto 0);
        
		reg_read_data_1: out signed(15 downto 0); 
		reg_read_data_2: out signed(15 downto 0);
		reg_read_data_3: out signed(15 downto 0); 
		reg_read_data_4: out signed(15 downto 0);
		reg_read_data_5: out signed(15 downto 0); 
		reg_read_data_6: out signed(15 downto 0);
		reg_read_data_7: out signed(15 downto 0); 
		reg_read_data_8: out signed(15 downto 0)
		);
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal rst : STD_LOGIC;
	signal reg_write_en : STD_LOGIC;
	signal reg_write_dest : SIGNED(2 downto 0);
	signal reg_write_data : SIGNED(15 downto 0);
	
	signal reg_read_addr_1 : SIGNED(2 downto 0);
	signal reg_read_addr_2 : SIGNED(2 downto 0);
	signal reg_read_addr_3 : SIGNED(2 downto 0);
	signal reg_read_addr_4 : SIGNED(2 downto 0);
	signal reg_read_addr_5 : SIGNED(2 downto 0);
	signal reg_read_addr_6 : SIGNED(2 downto 0);
	signal reg_read_addr_7 : SIGNED(2 downto 0);
	signal reg_read_addr_8 : SIGNED(2 downto 0);

	-- Observed signals - signals mapped to the output ports of tested entity
	signal reg_read_data_1 : SIGNED(15 downto 0);
	signal reg_read_data_2 : SIGNED(15 downto 0);
	signal reg_read_data_3 : SIGNED(15 downto 0); 
	signal reg_read_data_4 : SIGNED(15 downto 0);
	signal reg_read_data_5 : SIGNED(15 downto 0);
	signal reg_read_data_6 : SIGNED(15 downto 0);
	signal reg_read_data_7 : SIGNED(15 downto 0); 
	signal reg_read_data_8 : SIGNED(15 downto 0);
	
	constant CLOCK_PERIOD : time := 10 ns;

begin

	-- Unit Under Test port map
	-- Instantiate the component RegisterFile
	UUT : registerfile
		port map (
			clk => clk,
			rst => rst,
			reg_write_en => reg_write_en,
			reg_write_dest => reg_write_dest,
			reg_write_data => reg_write_data,
			
			reg_read_addr_1 => reg_read_addr_1,
			reg_read_addr_2 => reg_read_addr_2,
			reg_read_addr_3 => reg_read_addr_3,
			reg_read_addr_4 => reg_read_addr_4,
			reg_read_addr_5 => reg_read_addr_5,
			reg_read_addr_6 => reg_read_addr_6,
			reg_read_addr_7 => reg_read_addr_7,
			reg_read_addr_8 => reg_read_addr_8,
			
			reg_read_data_1 => reg_read_data_1,
			reg_read_data_2 => reg_read_data_2,
			reg_read_data_3 => reg_read_data_3,
			reg_read_data_4 => reg_read_data_4,
			reg_read_data_5 => reg_read_data_5,
			reg_read_data_6 => reg_read_data_6,
			reg_read_data_7 => reg_read_data_7,
			reg_read_data_8 => reg_read_data_8
		);

	 -- Clock process
    process
    begin
        while now < 1200 ns loop
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
        wait for 80 ns; -- Allow for initializations

        -- Test Write Operation
        rst <= '1';
        wait for CLOCK_PERIOD;
        rst <= '0';

        reg_write_en <= '1';
        reg_write_dest <= "001";    -- Write to register 1
        reg_write_data <= x"1234";  -- Data to be written
        wait for CLOCK_PERIOD;
        reg_write_en <= '0';
		
		reg_write_en <= '1';
		reg_write_dest <= "010"; -- Write to register 2
		reg_write_data <= x"2222"; 
		wait for CLOCK_PERIOD;
		reg_write_en <= '0';
		
		reg_write_en <= '1';
		reg_write_dest <= "011"; -- Write to register 3
		reg_write_data <= x"3333";
		wait for CLOCK_PERIOD;
		reg_write_en <= '0';
		
		reg_write_en <= '1';
		reg_write_dest <= "100"; -- Write to register 4
		reg_write_data <= x"4444"; 
		wait for CLOCK_PERIOD;
		reg_write_en <= '0';
		
		reg_write_en <= '1';
		reg_write_dest <= "101"; -- Write to register 5	
		reg_write_data <= x"5555";
		wait for CLOCK_PERIOD;
		reg_write_en <= '0';
		
		reg_write_en <= '1';
		reg_write_dest <= "110"; -- Write to register 6
		reg_write_data <= x"6666"; 
		wait for CLOCK_PERIOD;
		reg_write_en <= '0';
		
		reg_write_en <= '1';
		reg_write_dest <= "111"; -- Write to register 7	
		reg_write_data <= x"7777";
		wait for CLOCK_PERIOD;		
		reg_write_en <= '0';
		
		reg_write_en <= '1';
		reg_write_dest <= "000"; -- Write to register 8
		reg_write_data <= x"8888"; 
		wait for CLOCK_PERIOD;
		reg_write_en <= '0';
		
        -- Test Read Operation
        reg_read_addr_1 <= "001";  -- Read from register 1
        reg_read_addr_2 <= "010";  -- Read from register 2
		reg_read_addr_3 <= "011";  -- Read from register 3
        reg_read_addr_4 <= "100";  -- Read from register 4
		reg_read_addr_5 <= "101";  -- Read from register 5
        reg_read_addr_6 <= "110";  -- Read from register 6
		reg_read_addr_7 <= "111";  -- Read from register 7
        reg_read_addr_8 <= "000";  -- Read from register 8
		
        wait for CLOCK_PERIOD;
        
        -- Check the read data
        assert reg_read_data_1 = x"1234" report "Error: Incorrect data read from register 1" severity error;
        assert reg_read_data_2 = x"2222" report "Error: Incorrect data read from register 1" severity error;
		assert reg_read_data_3 = x"3333" report "Error: Incorrect data read from register 1" severity error;
		assert reg_read_data_4 = x"4444" report "Error: Incorrect data read from register 1" severity error;
		assert reg_read_data_5 = x"5555" report "Error: Incorrect data read from register 1" severity error;
		assert reg_read_data_6 = x"6666" report "Error: Incorrect data read from register 1" severity error;
		assert reg_read_data_7 = x"7777" report "Error: Incorrect data read from register 1" severity error;
		assert reg_read_data_8 = x"8888" report "Error: Incorrect data read from register 1" severity error;
		-- assert reg_read_data_2 = (others => '0') report "Error: Incorrect data read from register 2" severity error;

    end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_registerfile of registerfile_tb is
	for TB_ARCHITECTURE
		for UUT : registerfile
			use entity work.registerfile(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_registerfile;

