class scoreboard;

	// Parameters for FIFO configuration
	parameter DATA_WIDTH = 8, ADDR_WIDTH = 6;
	parameter CYCLE_TIME_WR = 12.5;  // 80 MHz
	parameter CYCLE_TIME_RD = 20;    // 50 MHz

	// Instantiating the interface
	virtual Asynchronous_FIFO_bfm_ext bfm;
	
	function new (virtual Asynchronous_FIFO_bfm_ext b);
		bfm = b;
	endfunction
	
	//Internal registers for the scoreboard. Not part of the bfm
	// NOTE: 1<<ADDR_WIDTH = 2 to the power of ADDR_WIDTH
	logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
	logic [ADDR_WIDTH-1:0] write_addr, read_addr;
	
	task execute();
  	
		// At every clk_wr, if wr_en&!full -> Shift data_in into scoreboard's FIFO
		@(posedge b.clk_wr) begin
    		if (b.wr_en && !b.full) begin
      			memory[write_addr] = b.data_in;
      			write_addr++;
    		end
  		end

		// At every clk_rd, if rd_en&!empty -> Check data out against where read_addr pointed in scoreboard's FIFO, last cycle
		// $sampled() is used to ensue the value is sampled in the correct time region of the simulation 
  		@(posedge b.clk_rd) begin
    		if (b.rd_en && !b.empty) begin
      			if ($sampled(b.data_out !== memory[$past(read_addr, 1, b.clk_rd)])) begin
        		$error("Mismatch at read address %d ...  Output expected: %h, received: %h", $past(read_addr, 1, b.clk_rd), $sampled(memory[$past(read_addr, 1, b.clk_rd)]), b.data_out);
      			end
      		read_addr++;
    		end
		end

	endtask
endclass
