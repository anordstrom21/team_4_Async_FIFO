class scoreboard
	
	// Instantiating the interface
	virtual Asynchronous_FIFO_bfm;
	
	// Coverage
	covergroup cg_fifo with function sample(bit wr_en, bit rd_en, bit full, bit empty);
		coverpoint wr_en;
		coverpoint rd_en;
		coverpoint full;
		coverpoint empty;
	endgroup
	
	function new (virtual Asynchronous_FIFO_bfm b);
		cg_fifo = new();
		bfm = b;
	endfunction
	
	// Instantiate coverage
	task execute();
		forever begin
			@(negedge bfm.clk_wr);
			cg.sample(bfm.wr_en, bfm.rd_en, bfm.full, bfm.empty);
		end
	endtask

endclass