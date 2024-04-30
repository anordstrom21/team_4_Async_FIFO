class testbench;

	// Instantiating the interface
	virtual Asynchronous_FIFO_bfm bfm();
	
	tester tester_h;
	coverage coverage_h;
	scoreboard scoreboard_h;
	
	function new (virtual Asynchronous_FIFO_bfm b);
		bfm = b;
	endfunction
	
	// Instantiate testbench objects
	task execute();
		tester_h = new(bfm);
		coverage_h = new(bfm);
		scoreboard_h = new(bfm);
		
		fork 
			tester_h.execute();
			coverage_h.execute();
			scoreboard_h.execute();
			
		join_none
	endtask
endclass