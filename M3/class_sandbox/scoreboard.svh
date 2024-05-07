class scoreboard;

	// Parameters for FIFO configuration
	parameter DATA_WIDTH = 8, ADDR_WIDTH = 6;
	parameter CYCLE_TIME_WR = 12.5;  // 80 MHz
	parameter CYCLE_TIME_RD = 20;    // 50 MHz

	// Instantiating the interface
	virtual fifo_bfm bfm;
	
	function new (virtual fifo_bfm b);
		bfm = b;
	endfunction
	
	//Internal registers for the scoreboard. Not part of the bfm
	// NOTE: 1<<ADDR_WIDTH = 2 to the power of ADDR_WIDTH
	logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
	logic [ADDR_WIDTH-1:0] write_addr = '0; 
	logic [ADDR_WIDTH-1:0] read_addr = '0;
	
	// Shift register to hold value of memory and rd_en signal
  	// Shift register in dut's synchronizer means if rd_en was just 
  	// asserted, read_addr will point to data in memory. However, if
  	// rd_en was already asserted then read_addr points to the next data 
  	// by the time wed get data_out from the fifo
  	// (Essentially the dut's read pointer is slower)
  	logic [DATA_WIDTH-1:0] data_last;
  	logic  rd_en_last;

	task execute();

	  forever begin : self_checker
		// At every clk_wr, if wr_en&!full -> Shift data_in into scoreboard's FIFO
		@(posedge bfm.clk_wr) begin
    		if (bfm.wr_en && !bfm.full) begin
      			memory[write_addr] = bfm.data_in;
      			write_addr++;
    		end
  		end

  	  	@(posedge bfm.clk_rd) begin
    		if (bfm.rd_en && !bfm.empty) begin
      			data_last <= memory[read_addr];
      			rd_en_last <= bfm.rd_en;
    		end
  		end

		@(posedge bfm.clk_rd) begin
 			if (bfm.rd_en && !bfm.empty) begin
  	    		// If rd_en wasn't asserted last cycle then read_addr points to data
   				if (!rd_en_last) begin
        			if (bfm.data_out != memory[read_addr]) begin
          				$error("Mismatch at address %d: expected %h, got %h", read_addr, data_last, bfm.data_out);
          				$display("Flag Values||  full: %b  empty: %b  wr_en: %b  rd_en: %b ", bfm.full, bfm.empty, bfm.wr_en, bfm.rd_en);
        			end
      			end
      			// If rd_en was asserted last cycle then data will be one cycle behind
      			else begin
        			if (bfm.data_out != data_last) begin
          				$error("Mismatch at address %d: expected %h, got %h", read_addr, data_last, bfm.data_out);
          				$display("Flag Values||  full: %b  empty: %b  wr_en: %b  rd_en: %b ", bfm.full, bfm.empty, bfm.wr_en, bfm.rd_en);
        			end
      			end
      			//else begin
        		//	$display("Match at address %d: expected %h, got %h", read_addr, data_last, bfm.data_out);
      			//end
      		read_addr++;
    		end
  		end
	  end : self_checker
	endtask : execute
endclass : scoreboard
