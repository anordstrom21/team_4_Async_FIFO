class scoreboard;
	
	// Instantiating the interface
	virtual Asynchronous_FIFO_bfm bfm;
	
	function new (virtual Asynchronous_FIFO_bfm b);
		bfm = b;
	endfunction
	
	task execute();
  	
		// At every clk_wr, if wr_en&!full -> Shift data_in into scoreboard's FIFO
		always @(posedge bfm.clk_wr) begin
    		if (bfm.wr_en && !bfm.full) begin
      			bfm.memory[bfm.write_addr] = bfm.data_in;
      			bfm.write_addr++;
    		end
  		end

		// At every clk_rd, if rd_en&!empty -> Check data out against where read_addr pointed in scoreboard's FIFO, last cycle
		// $sampled() is used to ensue the value is sampled in the correct time region of the simulation 
  		always @(posedge bfm.clk_rd) begin
    		if (bfm.rd_en && !bfm.empty) begin
      			if ($sampled(bfm.data_out != bfm.memory[$past(bfm.read_addr, 1, bfm.clk_rd)])) begin
        		$error("Mismatch at read address %d ...  Output expected: %h, received: %h", $past(bfm.read_addr, 1, bfm.clk_rd), $sampled(bfm.memory[$past(bfm.read_addr, 1, bfm.clk_rd)]), bfm.data_out);
      			end
      		bfm.read_addr++;
    		end
  		end


	endtask
endclass
