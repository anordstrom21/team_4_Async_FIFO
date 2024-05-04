class tester;

	// Instantiating the interface
	virtual Asynchronous_FIFO_bfm_ext bfm;
	
	function new (virtual Asynchronous_FIFO_bfm_ext b);
		bfm = b;
	endfunction
	
	
	// Randomized Data Generator
	protected function [DATA_WIDTH-1:0] getdata();
		return $random;
	endfunction
	
/*	task execute();
		bfm.write_addr = '0;
		bfm.read_addr = '0;
		bfm.wr_en = 1'b0;
		bfm.rd_en = 1'b0;
		repeat (10) @(posedge bfm.clk_wr);
		repeat (1000) begin
			bfm.data_in = getdata();
			@(negedge bfm.clk_wr)
			bfm.wr_en = $random;
			@(negedge bfm.clk_rd)
			bfm.rd_en = $random;
			@(posedge bfm.clk_wr)
			@(posedge bfm.clk_rd)
		end
		repeat (10) @(posedge bfm.clk_wr);
		$stop;
	endtask
*/
	task execute();
		//Call the task to reset the FIFO (located in the interface)
		bfm.reset_FIFO();
		
		//Initialize wr_en and rd_en
		bfm_ext.wr_en = '0;
		bfm_ext.rd_en = '0;
		
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
		bfm.wr_en = 1'b0;
		
		// Wait for all reads to complete
		repeat (150) @(posedge bfm.clk_rd);
		bfm.rd_en = 1'b0;
		repeat (10) @(posedge bfm.clk_rd);
		$finish;
	endtask
endclass
