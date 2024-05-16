package fifo_pkg;
	// Parameters for FIFO configuration
	parameter DATA_WIDTH = 8, ADDR_WIDTH = 6;
	parameter CYCLE_TIME_WR = 12.5;  // 80 MHz
	parameter CYCLE_TIME_RD = 20;    // 50 MHz
	
	`include "coverage.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "tester.sv"
	`include "scoreboard.sv"
	`include "testbench.sv"
	
endpackage : fifo_pkg
