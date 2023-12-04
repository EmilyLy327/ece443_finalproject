-------------------------------------------------------------------------------
--
-- Title       : Simple Processor
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : TB
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor_TB is
end Processor_TB;

architecture Testbench of Processor_TB is
    -- Clock period
    constant clk_period: time := 10 ns;

    -- Signals
    signal clk, reset: std_logic;
    signal alu_result: signed(15 downto 0);
    signal pc_out: signed(15 downto 0);

    -- Memory to hold instructions
    type memory_array is array(0 to 15) of std_logic_vector(15 downto 0);
    signal memory: memory_array := (
        X"500A", -- ldi #r0, 10
        X"5105", -- ldi #r1, 5
        X"5200", -- ldi $r2, 0
        X"5300", -- ldi #r3, 0
        X"5400", -- ldi $r4, 0
        X"5500", -- ldi $r5, 0
        X"5600", -- ldi $r6, 0
        X"5700", -- ldi $r7, 0
        X"0201", -- add $r2, $r0, $r1
        X"1301", -- mult $r3, $r0, $r1
        X"4401", -- sub $r4, $r0, $r1
        X"630B", -- sh $r3, 0x0B
        X"640A", -- sh $r4, 0x0A
        X"760A", -- lh $r6, 0x0A
        X"770B"  -- lh $r7, 0x0B
    );

begin
    -- Instantiate processor
    uut: entity work.Processor
        port map (
            clk => clk,
            reset => reset,
            alu_result => alu_result
        );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Reset process
    reset_process: process
    begin
        reset <= '1';
        wait for 2 * clk_period;
        reset <= '0';
        wait;
    end process;

-- Monitor process to verify output after each instruction
monitor_process: process
begin
    wait for 2 * clk_period; -- Wait for reset and initializations
    for i in memory'range loop
        wait until rising_edge(clk);
        pc_out <= std_logic_vector(to_signed(i, pc_out'length));
        wait for clk_period; -- Allow one clock cycle for execution
        
        -- Simulate the processor's behavior for each instruction
		case i is
    		when 0 =>
        		-- Execute ldi #r0, 10
        		alu_result <= to_signed(10, alu_result'length); -- Assuming '10' as the immediate value
    		when 1 =>
        		-- Execute ldi #r1, 5
        		alu_result <= to_signed(5, alu_result'length); -- Assuming '5' as the immediate value
    			-- Add cases for other instructions
  		    when others =>
        null;
end case;

-- Verify the result
assert alu_result = signed(to_unsigned(conv_integer(memory(i)), alu_result'length))
    report "Mismatch at instruction " & integer'image(i)
    severity error;
    end loop;
    wait;
end process;


end Testbench;
