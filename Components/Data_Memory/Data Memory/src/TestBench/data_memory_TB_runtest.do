SetActiveLib -work
comp -include "$dsn\src\Data Memory.vhd" 
comp -include "$dsn\src\TestBench\data_memory_TB.vhd" 
asim +access +r TESTBENCH_FOR_data_memory 
wave 
wave -noreg clk
wave -noreg mem_access_addr
wave -noreg mem_write_data
wave -noreg mem_write_en
wave -noreg mem_read
wave -noreg mem_read_data
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\data_memory_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_data_memory 
