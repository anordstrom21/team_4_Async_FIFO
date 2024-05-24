/*********************************************
//	Monitor Class for the OOP/Class Based 
//  Testbench for an Asynchronous FIFO Module
//
//
//	Author: Alexander Maso
//	 
*********************************************/

class monitor;
  
  virtual fifo_bfm bfm;
  mailbox drv2mon, mon2scb;
  transaction tx;

  function new (virtual fifo_bfm bfm, mailbox drv2mon, mailbox mon2scb);
    this.bfm = bfm;
    this.drv2mon= drv2mon;
    this.mon2scb = mon2scb;
  endfunction

  // internal signal to track address
  // bit [ADDR_WIDTH-1:0]  address = 0;
  
  task execute();
    $display("********** Monitor Started **********"); 
    //forever begin
    repeat(2*TX_COUNT) begin
      drv2mon.get(tx);
      $display("Monitor tx   | wr_en: %b | rd_en: %b | Data: %h", tx.wr_en, tx.rd_en, tx.data_out); 
      if (tx.rd_en) begin
        @(posedge bfm.clk_rd);
        tx.data_out = bfm.data_out;
      end
      mon2scb.put(tx); 
      // NOTE: NEED TO ADD FULL/EMPTY/HALF MONITORING
      //if (bfm.rd_en && !bfm.empty) begin
        //$display("Read from addr: %d | Data: %h", address, bfm.data_out);
        //address++;
    end
    $display("********** Monitor Ended **********"); 
  endtask : execute

endclass
