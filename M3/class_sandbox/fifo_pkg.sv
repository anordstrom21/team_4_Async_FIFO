package fifo_pkg;
	// Parameters for FIFO configuration
	parameter DATA_WIDTH = 8, ADDR_WIDTH = 6;
	parameter CYCLE_TIME_WR = 12.5;  // 80 MHz
	parameter CYCLE_TIME_RD = 20;    // 50 MHz
	
//	`include "coverage.svh"
	`include "tester.svh"
	`include "scoreboard.svh"
	`include "testbench.svh"
	
endpackage : fifo_pkg
