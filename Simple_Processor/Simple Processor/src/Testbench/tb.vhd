-------------------------------------------------------------------------------
--
-- Title       : Instruction
-- Design      : Simple Processor
-- Author      : Emily Ly and Brice Zimmerman
-- Company     : Old Dominion University
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
    -- Component Declaration 
    COMPONENT processor
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         pc_out : OUT  signed(15 downto 0);
         alu_result : OUT  signed(15 downto 0)
        );
    END COMPONENT;
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   --Outputs
   signal pc_out : signed(15 downto 0);
   signal alu_result : signed(15 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
BEGIN
 -- Instantiate 
   uut: Processor PORT MAP (
          clk => clk,
          reset => reset,
          pc_out => pc_out,
          alu_result => alu_result
        );

   -- Clock process definitions
   clk_process :process
   begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
   end process;
   -- Stimulus process
   stim_proc: process
   begin  
      reset <= '1';
      wait for clk_period*10;
  reset <= '0';
      -- insert stimulus here 
      wait;
   end process;

END;