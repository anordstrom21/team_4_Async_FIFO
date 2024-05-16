/*********************************************
//	Driver Class for the OOP/Class Based 
//  Testbench for an Asynchronous FIFO Module
//
//  Creates virtual bfm and calls constructor
//  Contains task execute which records writes 
//  that go to the bfm on data_in bus
//
//	Alexander Maso
//	 
*********************************************/

class driver;
  virtual fifo_bfm bfm;
  
  function new(virtual fifo_bfm b);
    bfm = b;
  endfunction

  // internal signal to track address
  bit [ADDR_WIDTH-1:0]  address = 0;

  task execute();
    forever begin
      @(posedge bfm.clk_wr);
      if (bfm.wr_en && !bfm.full) begin
        address++;
        $display("Write to addr:  %d | Data: %h", address, bfm.data_in);
      end
    end
  endtask : execute
  
/*  
  task execute();
    // Generate random data and write to FIFO
    forever begin
      bfm.data_in = $random;
      bfm.wr_en = 1;
      @(negedge bfm.clk_wr);
      bfm.wr_en = 0;
      repeat(10) @(negedge bfm.clk_wr);
    end
  endtask : execute
*/

endclass
