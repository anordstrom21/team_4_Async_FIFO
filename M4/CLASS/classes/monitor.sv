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

  bit last_rd_en = 0;
  
  task execute();
    $display("********** Monitor Started **********"); 
    // NOTE: NEED TO ADD FULL/EMPTY/HALF MONITORING
    repeat(2*TX_COUNT) begin
      drv2mon.get(tx);
      if (tx.rd_en && !bfm.empty) begin
        if (!last_rd_en) begin
          #(CYCLE_TIME_RD);
        end
        @(posedge bfm.clk_rd);
        tx.data_out = bfm.data_out;
        $display("Monitor tx \t|  wr_en: %b  |  rd_en: %b  |  data_in: %h |  data_out: %h", tx.wr_en, tx.rd_en, tx.data_in, tx.data_out); 
        last_rd_en = tx.rd_en;
        mon2scb.put(tx);
      end
      else begin
        @(posedge bfm.clk_rd);
        $display("Monitor tx \t|  wr_en: %b  |  rd_en: %b  |  data_in: %h |  data_out: %h", tx.wr_en, tx.rd_en, tx.data_in, tx.data_out); 
        last_rd_en = tx.rd_en;
        mon2scb.put(tx);
      end 
    end
    $display("********** Monitor Ended **********"); 
  endtask : execute

endclass