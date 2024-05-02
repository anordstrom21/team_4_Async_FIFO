class coverage;
	
	// Instantiating the interface
	virtual Asynchronous_FIFO_bfm bfm;
	
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
			wr_en = bfm.wr_en;
			rd_en = bfm.rd_en;
			full = bfm.full_en;
			empty = bfm.empty_en;
			cg_fifo.sample(wr_en, rd_en, full, empty);
		end
	endtask

endclass
