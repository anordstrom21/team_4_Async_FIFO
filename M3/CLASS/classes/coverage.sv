class coverage;
	
	// Instantiating the interface
	virtual fifo_bfm bfm;
	
	// Coverage
	covergroup cg_fifo with function sample(bit wr_en, bit rd_en, bit full, bit empty, bit half);
		coverpoint wr_en;
		coverpoint rd_en;
		coverpoint full;
		coverpoint empty;
		coverpoint half;
	endgroup
	
	function new (virtual fifo_bfm b);
		cg_fifo = new();
		bfm = b;
	endfunction: new
	
	// Instantiate coverage
	task execute();
		forever begin
			@(negedge bfm.clk_wr);
			/*
			wr_en = bfm.wr_en;
			rd_en = bfm.rd_en;
			full = bfm.full_en;
			empty = bfm.empty_en;
			half = bfm.half;
			*/
			cg_fifo.sample(bfm.wr_en, bfm.rd_en, bfm.full, bfm.empty, bfm.half);
		end
	endtask

endclass