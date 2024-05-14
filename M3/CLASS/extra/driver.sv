class Driver;
  virtual Asynchronous_FIFO_bfm_ext bfm;
  
  function new(virtual Asynchronous_FIFO_bfm_ext bfm);
    this.bfm = bfm;
  endfunction
  
  task execute();
    // Generate random data and write to FIFO
    forever begin
      bfm.data_in = $random;
      bfm.wr_en = 1;
      @(negedge bfm.clk_wr);
      bfm.wr_en = 0;
      repeat(10) @(negedge bfm.clk_wr);
    end
  endtask
endclass
