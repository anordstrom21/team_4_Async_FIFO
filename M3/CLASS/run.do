if [file exists "work"] {vdel -all}
vlib work

# Compile the package, bfm and top modules
vlog -lint fifo_pkg.sv +acc -sv
vlog -lint fifo_bfm.sv +acc -sv
vlog -lint top.sv +acc -sv

# Compile the DUT, include linting check and...
# TODO: Check what acc does
vlog -lint dut/fifo_top.sv +acc -sv
vlog -lint dut/fifo_memory.sv +acc -sv
vlog -lint dut/read_pointer.sv +acc -sv
vlog -lint dut/write_pointer.sv +acc -sv
vlog -lint dut/sync.sv +acc -sv
 
# Compile the class based portion of our testbench
vlog classes/testbench.sv 
vlog classes/tester.sv 
vlog classes/scoreboard.sv 
 

#vsim -c -do "run -all; quit" testbench