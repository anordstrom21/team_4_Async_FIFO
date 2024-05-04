class scoreboard;
	
	// Instantiating the interface
	virtual Asynchronous_FIFO_bfm_ext bfm;
	
	function new (virtual Asynchronous_FIFO_bfm_ext b);
		bfm = b;
	endfunction
	
	//Internal registers for the scoreboard. Not part of the bfm
	// NOTE: 1<<ADDR_WIDTH = 2 to the power of ADDR_WIDTH
	logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
	logic [ADDR_WIDTH-1:0] write_addr, read_addr;
	
	//Initializing the internal scoreboard registers
	initial
	begin
		write_addr = '0;
		read_addr = '0;
	end
	
	task execute();
  	
		// At every clk_wr, if wr_en&!full -> Shift data_in into scoreboard's FIFO
		always @(posedge bfm.clk_wr) begin
    		if (bfm.wr_en && !bfm.full) begin
      			memory[write_addr] = bfm.data_in;
      			write_addr++;
    		end
  		end

		// At every clk_rd, if rd_en&!empty -> Check data out against where read_addr pointed in scoreboard's FIFO, last cycle
		// $sampled() is used to ensue the value is sampled in the correct time region of the simulation 
  		always @(posedge bfm.clk_rd) begin
    		if (bfm.rd_en && !bfm.empty) begin
      			if ($sampled(bfm.data_out !== memory[$past(read_addr, 1, bfm.clk_rd)])) begin
        		$error("Mismatch at read address %d ...  Output expected: %h, received: %h", $past(read_addr, 1, bfm.clk_rd), $sampled(memory[$past(read_addr, 1, bfm.clk_rd)]), bfm.data_out);
      			end
      		read_addr++;
    		end
  		end


	endtask
endclass
