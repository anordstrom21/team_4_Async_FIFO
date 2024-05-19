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
  mailbox mon2scb;
  transaction tx;
  int tx_count = 1000;

  function new (virtual fifo_bfm bfm, mailbox mon2scb);
    this.bfm = bfm;
    this.mon2scb = mon2scb;
  endfunction

  // internal signal to track address
  bit [ADDR_WIDTH-1:0]  address = 0;
  
  task execute();
    #(CYCLE_TIME_RD*15);
    $display("********** Monitor Started **********"); 
    //forever begin
    repeat(tx_count) begin
      tx = new();
      @(posedge bfm.clk_rd);
      bfm.rd_en = $random;
      tx.data_out = bfm.data_out;
      tx.rd_en = bfm.rd_en;
      $display("Monitor tx   | rd_en: %b | Data: %h", tx.rd_en, tx.data_out); 
      mon2scb.put(tx); 
      if (bfm.rd_en && !bfm.empty) begin
        //$display("Read from addr: %d | Data: %h", address, bfm.data_out);
        address++;
      end
    end
    $display("********** Monitor Ended **********"); 
    $finish();
  endtask : execute

endclass
