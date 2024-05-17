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
  mailbox gen2driv;
  
  function new(virtual fifo_bfm b, mailbox gen2driv);
    bfm = b;
    this.gen2driv = gen2driv;
  endfunction

  // internal signal to track address
  bit [ADDR_WIDTH-1:0]  address = 0;

  task execute();
    bfm.reset_fifo();
    repeat(3) begin
      transaction tx;
      //tx = new();
      #1;
      gen2driv.get(tx);
      $display("driver tx: %h", tx);
      @(posedge bfm.clk_wr);
      bfm.data_in <= tx.data_in;
      bfm.wr_en   <= tx.wr_en;
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
