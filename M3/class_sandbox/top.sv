module top;
	
	//Importing package containing parameters and svh files
	import fifo_pkg::*;
	
	// Instantiating the interface
	fifo_bfm bfm();
	
	// Instantiate the FIFO
	fifo_top #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH)
	  ) dut (
		.clk_wr(bfm.clk_wr),
		.clk_rd(bfm.clk_rd),
		.rst_n(bfm.rst_n),
		.wr_en(bfm.wr_en),
		.rd_en(bfm.rd_en),
		.data_in(bfm.data_in),
		.data_out(bfm.data_out),
		.full(bfm.full),
		.empty(bfm.empty)
	  );
	
	// Instantiate the testbench
	testbench testbench_h;
	
	initial begin
		testbench_h = new(bfm);
		testbench_h.execute();
	end

endmodule : top