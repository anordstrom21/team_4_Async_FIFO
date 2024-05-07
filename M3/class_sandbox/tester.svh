class tester;

	parameter DATA_WIDTH = 8, ADDR_WIDTH = 6;
	parameter CYCLE_TIME_WR = 12.5;  // 80 MHz
	parameter CYCLE_TIME_RD = 20;    // 50 MHz

	// Instantiating the interface
	virtual fifo_bfm bfm;
	
	function new (virtual fifo_bfm b);
		bfm = b;
	endfunction : new
	
	
	// Randomized Data Generator
	protected function [DATA_WIDTH-1:0] get_data();
		return $random;
	endfunction : get_data
	
	task execute();
		//Call the task to reset the FIFO (located in the interface)
		bfm.reset_fifo();
		
    	bfm.wr_en = 1'b0;
    	bfm.rd_en = 1'b0;
    	repeat (10) @(posedge bfm.clk_wr);
    
   	 	// Run through 25 randomized 120 word bursts. 
    	repeat (25) begin
      		// Grab data, set write enable and write for 10 write cylces
      		@(negedge bfm.clk_wr)
      		bfm.data_in = get_data();
      		bfm.wr_en = 1'b1;
      		repeat (9) begin
       			@(negedge bfm.clk_wr)
        		bfm.data_in = get_data();
      		end

      		// After 10 cycles enable read and continue for 110 remaining writes in burst
      		bfm.rd_en = 1'b1;
      		repeat (110) begin
        		@(negedge bfm.clk_wr)
        		bfm.data_in = get_data();
      		end
    
    	  	// After 120 cycles of wr_clk -> Deassert wr_en
     	 	bfm.wr_en = 1'b0;
      		// Wait for all reads to complete -> Deassert rd_en
      		repeat (150) @(posedge bfm.clk_rd);
      		bfm.rd_en = 1'b0;
      		repeat (50) @(posedge bfm.clk_rd);
    	end

	endtask : execute
endclass : tester
