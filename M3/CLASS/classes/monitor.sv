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

  function new (virtual fifo_bfm b, mailbox mon2scb);
    bfm = b;
    this.mon2scb = mon2scb;
  endfunction

  // internal signal to track address
  bit [ADDR_WIDTH-1:0]  address = 0;
  
  task execute();
    //forever begin
    repeat(240) begin
      tx = new();
      @(posedge bfm.clk_rd);
      bfm.rd_en = $random;
      tx.data_out = bfm.data_out;
      tx.rd_en = bfm.rd_en;
      $display("monitor tx data: %h rd_en: %b", tx.data_out, tx.rd_en); 
      mon2scb.put(tx); 
      if (bfm.rd_en && !bfm.empty) begin
        $display("Read from addr: %d | Data: %h", address, bfm.data_out);
        address++;
      end
    end
  endtask : execute

endclass
