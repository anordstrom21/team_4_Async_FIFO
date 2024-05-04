if [file exists "work"] {vdel -all}
vlib work

# Comment out either the SystemVerilog or VHDL DUT.
# There can be only one!

# SystemVerilog DUT
vlog -lint fifo_top.sv +acc -sv
vlog -lint fifo_memory.sv +acc -sv
vlog -lint read_pointer.sv +acc -sv
vlog -lint write_pointer.sv +acc -sv
vlog -lint sync.sv +acc -sv
vlog -lint async_pkg.sv +acc -sv
vlog -lint interface.sv +acc -sv

# Top module
vlog -lint top.sv +acc -sv

# Class based testbench
vlog -lint coverage.svh +acc -sv
vlog -lint testbench.svh +acc -sv
vlog -lint tester.svh +acc -sv
vlog -lint scoreboard.svh +acc -sv


vopt top -o top_optimized  +acc +cover=sbfec+fifo_top(rtl).
vsim top_optimized -coverage
set NoQuitOnFinish 1
onbreak {resume}
log /* -r

#adding waves
add wave -position insertpoint sim:/top/*
add wave -position insertpoint sim:/top/dut/*

run -all

coverage save async_fifo.ucdb
vcover report async_fifo.ucdb
vcover report async_fifo.ucdb -cvg -details

quit
