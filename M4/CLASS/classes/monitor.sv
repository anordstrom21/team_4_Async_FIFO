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
  mailbox gen2mon, mon2scb;
  transaction tx_rd;

  function new (virtual fifo_bfm bfm, mailbox gen2mon, mailbox mon2scb);
    this.bfm = bfm;
    this.gen2mon= gen2mon;
    this.mon2scb = mon2scb;
  endfunction

  bit last_rd_en = 0;
  bit last_empty = 0;
  
  task execute();
    #(40*CYCLE_TIME_RD); // wait for the driver to reset the FIFO (2 RD_CLKs might be enough...)
    $display("********** Monitor Started **********"); 
    // NOTE: NEED TO ADD FULL/EMPTY/HALF MONITORING
    repeat(TX_COUNT_RD) begin
      gen2mon.get(tx_rd);
      @(posedge bfm.clk_rd);
        bfm.rd_en <= tx_rd.rd_en;
        #(CYCLE_TIME_RD);
        if (tx_rd.rd_en) begin
            if (!last_rd_en || last_empty) begin
            #(CYCLE_TIME_RD);
            end
        end 
        tx_rd.data_out = tx_rd.rd_en ? bfm.data_out : tx_rd.data_out; // if rd_en is high, grab data_out from FIFO
        // udpdate flags in this transaction
        tx_rd.empty = bfm.empty;
        tx_rd.full = bfm.full;
        tx_rd.half = bfm.half;
        last_rd_en = tx_rd.rd_en;
        last_empty= tx_rd.empty;
        mon2scb.put(tx_rd);
        $display("Monitor tx_rd \t|  wr_en: %b  |  rd_en: %b  |  data_in: %h  |  data_out: %h", tx_rd.wr_en, tx_rd.rd_en, tx_rd.data_in, tx_rd.data_out); 
    end
    $display("********** Monitor Ended **********"); 
  endtask : execute

endclass
