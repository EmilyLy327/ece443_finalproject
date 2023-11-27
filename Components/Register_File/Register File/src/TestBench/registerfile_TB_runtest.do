SetActiveLib -work
comp -include "$dsn\src\Register File.vhd" 
comp -include "$dsn\src\TestBench\registerfile_TB.vhd" 
asim +access +r TESTBENCH_FOR_registerfile 
wave 
wave -noreg clk
wave -noreg rst
wave -noreg reg_write_en
wave -noreg reg_write_dest
wave -noreg reg_write_data
wave -noreg reg_read_addr_1
wave -noreg reg_read_addr_2
wave -noreg reg_read_data_1
wave -noreg reg_read_data_2
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\registerfile_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_registerfile 
