if [file exists "work"] {vdel -all}
vlib work

# SystemVerilog DUT
vlog -lint dut/fifo_top.sv +acc -sv
vlog -lint dut/fifo_memory.sv +acc -sv
vlog -lint dut/read_pointer.sv +acc -sv
vlog -lint dut/write_pointer.sv +acc -sv
vlog -lint dut/sync.sv +acc -sv
vlog -lint fifo_pkg.sv +acc -sv
vlog -lint fifo_bfm.sv +acc -sv

# Top module
vlog -lint top.sv +acc -sv

# Class based testbench
#vlog -lint coverage.svh +acc -sv
vlog -lint testbench.svh +acc -sv
vlog -lint tester.svh +acc -sv
vlog -lint scoreboard.svh +acc -sv

vsim -coverage top -voptargs="+cover=sbfec"

#adding waves
#add wave -position insertpoint sim:/top/*
#add wave -position insertpoint sim:/top/dut/*

#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r

run -all

coverage report -codeAll


#coverage save async_fifo.ucdb
#vcover report async_fifo.ucdb
#vcover report async_fifo.ucdb -cvg -details
#quit
