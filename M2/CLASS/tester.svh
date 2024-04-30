class tester;

	// Instantiating the interface
	virtual Asynchronous_FIFO_bfm bfm();
	
	function new (virtual Asynchronous_FIFO_bfm b);
		bfm = b;
	endfunction
	
	
	// Randomized Data Generator
	protected function [DATA_WIDTH-1:0] getdata();
		return $random;
	endfunction
	
	task execute();
		write_addr = '0;
		read_addr = '0;
		bfm.wr_en = 1'b0;
		bfm.rd_en = 1'b0;
		repeat (10) @(posedge bfm.clk_wr);

		// Grab data, set write enable and write for 10 write cylces
		@(negedge bfm.clk_wr)
		bfm.data_in = getdata();
		bfm.wr_en = 1'b1;
		repeat (9) begin
			@(negedge bfm.clk_wr)
			bfm.data_in = getdata();
		end
		// After 10 cycles enable read and continue for 110 remaining writes in burst
		bfm.rd_en = 1'b1;
		repeat (110) begin
			@(negedge bfm.clk_wr)
			bfm.data_in = getdata();
		end
		// Wait for all reads to complete
		repeat (150) @(posedge bfm.clk_rd);
		bfm.wr_en = 1'b0;
		bfm.rd_en = 1'b0;
		repeat (10) @(posedge bfm.clk_rd);
		$finish;
	endtask

endclass