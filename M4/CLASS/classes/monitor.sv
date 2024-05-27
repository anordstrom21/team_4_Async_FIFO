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
    #((READ_DELAY+3)*CYCLE_TIME_RD); // wait for the driver to reset the FIFO (2 RD_CLKs might be enough...)
    $display("********** Monitor Started **********"); 
    repeat(TX_COUNT_RD) begin
      gen2mon.get(tx_rd);
      @(posedge bfm.clk_rd);
        bfm.rd_en <= tx_rd.rd_en;
        //#(CYCLE_TIME_RD);
        //if (tx_rd.rd_en) begin
        //if (!last_rd_en || last_empty) begin
        //if (tx_rd.rd_en && last_rd_en) begin
        //    #(CYCLE_TIME_RD);
        //end

        // Sample data and flags from FIFO
        @(posedge bfm.clk_rd);
        tx_rd.data_out = bfm.data_out;
        tx_rd.empty = bfm.empty;
        tx_rd.full = bfm.full;
        tx_rd.half = bfm.half;
        //last_rd_en = tx_rd.rd_en;
        //last_empty= tx_rd.empty;
        mon2scb.put(tx_rd);
        $display("Monitor tx_rd \t|  wr_en: %b  |  rd_en: %b  |  data_in: %h  |  data_out: %h  |  full: %b  |  empty: %b  |  half: %b", tx_rd.wr_en, tx_rd.rd_en, tx_rd.data_in, tx_rd.data_out, tx_rd.full, tx_rd.empty, tx_rd.half); 
    end
    $display("********** Monitor Ended **********"); 
  endtask : execute

endclass
