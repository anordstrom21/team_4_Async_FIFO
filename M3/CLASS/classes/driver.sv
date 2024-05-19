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
  transaction tx;
  int tx_count = 500;

  function new(virtual fifo_bfm bfm, mailbox gen2driv);
    this.bfm = bfm;
    this.gen2driv = gen2driv;
  endfunction

  // internal signal to track address
  bit [ADDR_WIDTH-1:0]  address = 0;

  task execute();
    bfm.reset_fifo();  // reset takes 2 RD_CLKs
    $display("********** Driver Started **********");
    repeat(tx_count) begin
      gen2driv.get(tx);
      $display("Driver tx     |  wr_en: %b  |  data: %h", tx.wr_en, tx.data_in);
      @(posedge bfm.clk_wr);
      bfm.data_in <= tx.data_in;
      bfm.wr_en   <= tx.wr_en;
      if (bfm.wr_en && !bfm.full) begin
        //address++;
        //$display("Write to addr:  %d | Data: %h", address, bfm.data_in);
      end
    end
    $display("********** Driver Ended **********");
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
