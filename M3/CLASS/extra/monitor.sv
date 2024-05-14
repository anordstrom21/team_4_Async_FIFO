class Monitor;
  
  import fifo_pkg::*;
  
  virtual Asynchronous_FIFO_bfm_ext bfm;

  function new(virtual Asynchronous_FIFO_bfm_ext bfm);
    this.bfm = bfm;
  endfunction
  
  task execute();
    forever begin
      @(posedge bfm.clk_rd);
      if (bfm.rd_en && !bfm.empty) begin
        $display("Data Read: %h", bfm.data_out);
      end
    end
  endtask
endclass
