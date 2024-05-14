/*********************************************
//	Interface for the Asynchronous FIFO
//	Contains external signals plus function reset_fifo()
//
//	NOTE: I think this might need to have additonal functions
//	for reading and writing from the fifo...
//	Maybe specifically for read/write burst
//
//	Alexander Maso
//	 
*********************************************/

interface fifo_bfm;
	import fifo_pkg::*;

	//External FIFO signals
	logic clk_wr, clk_rd, rst_n;
	logic wr_en, rd_en;
	logic [DATA_WIDTH-1:0] data_in, data_out;
	logic full, empty, half;
	
	//Internal FIFO signals
	logic [ADDR_WIDTH:0] wptr;
	logic [ADDR_WIDTH:0] rptr;
	logic [ADDR_WIDTH-1:0] waddr;
	logic [ADDR_WIDTH-1:0] raddr;
	logic [ADDR_WIDTH:0] wq2_rptr;
	logic [ADDR_WIDTH:0] rq2_wptr;

	// Clock Generation for Write and Read domains
	initial begin
		clk_wr = 1'b0;
		clk_rd = 1'b0;
		forever #(CYCLE_TIME_WR/2) clk_wr = ~clk_wr;
		forever #(CYCLE_TIME_RD/2) clk_rd = ~clk_rd;
	end


	task reset_fifo();
	    rst_n = 1'b0;
	    @(negedge clk_rd);
	    @(negedge clk_rd);
	    rst_n = 1'b1;
	    wr_en = 1'b0;
	    rd_en = 1'b0;
	endtask

endinterface


