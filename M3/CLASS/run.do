if [file exists "work"] {vdel -all}
vlib work

# Compile the DUT, include linting check and...
# TODO: Check what acc does
vlog -lint dut/fifo_top.sv +acc -sv
vlog -lint dut/fifo_memory.sv +acc -sv
vlog -lint dut/read_pointer.sv +acc -sv
vlog -lint dut/write_pointer.sv +acc -sv
vlog -lint dut/sync.sv +acc -sv
 
vlog -f tb.f
vopt top -o top_optimized  +acc +cover=sbfec+fifo_top(rtl).
 vsim top_optimized -coverage
 set NoQuitOnFinish 1
 onbreak {resume}
 log /* -r
 run -all
#quit 