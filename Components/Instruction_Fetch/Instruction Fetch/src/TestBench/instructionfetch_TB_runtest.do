SetActiveLib -work
comp -include "$dsn\src\Instruction Fetch.vhd" 
comp -include "$dsn\src\TestBench\instructionfetch_TB.vhd" 
asim +access +r TESTBENCH_FOR_instructionfetch 
wave 
wave -noreg clk
wave -noreg reset
wave -noreg pc_out
wave -noreg instruction_out
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\instructionfetch_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_instructionfetch 
