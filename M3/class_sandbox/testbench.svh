class testbench;

	// Instantiating the interface
	virtual fifo_bfm bfm;
	
	//`include "coverage.svh"
	`include "tester.svh"
	`include "scoreboard.svh"
	
	tester tester_h;
	//coverage coverage_h;
	scoreboard scoreboard_h;

	function new (virtual fifo_bfm b);
		bfm = b;
	endfunction : new
	
	// Instantiate testbench objects
	task execute();
		tester_h = new(bfm);
		//coverage_h = new(bfm);
		scoreboard_h = new(bfm);
		
		fork 
			tester_h.execute();
			//coverage_h.execute();
			scoreboard_h.execute();
		join_none
	endtask : execute

endclass : testbench
