/*********************************************
//	Monitor Class for the OOP/Class Based 
//  Testbench for an Asynchronous FIFO Module
//
//  Creates virtual bfm and calls constructor
//  Contains task execute which records reads 
//  that come from the bfm on data_out bus
//
//	Alexander Maso
//	 
*********************************************/

class monitor;
  
  virtual fifo_bfm bfm;

  function new (virtual fifo_bfm b);
    bfm = b;
  endfunction
  
  task execute();
    forever begin
      @(posedge bfm.clk_rd);
      if (bfm.rd_en && !bfm.empty) begin
        $display("Data Read: %h", bfm.data_out);
      end
    end
  endtask : execute

endclass
