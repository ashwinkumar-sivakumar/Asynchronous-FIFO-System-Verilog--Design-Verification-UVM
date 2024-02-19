vlib work
vlog ../rtl/design.sv
#vsim -c -voptargs=+acc -sv_seed random async_fifo1_tb -do "run -all;"
vlog testbench.sv
vsim -c -voptargs=+acc async_fifo1_tb_uvm -do "run -all;"
##Coverage
#vlog -coveropt 3 +cover +acc ../rtl/design.sv testbench.sv
#vsim -c -voptargs=+acc -coverage -vopt async_fifo1_tb_uvm -do "coverage save -onexit -directive -codeALL team1.ucdb; run -all"
#############both functional and code coverage are enabled 
#vcover report -html team1.ucdb
#coverage report -detail 
